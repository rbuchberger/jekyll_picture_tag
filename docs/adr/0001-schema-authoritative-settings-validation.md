# Schema-authoritative settings validation, eager at site scope

Status: proposed — targeted at 4.0, not 3.0.0.

## Decision

Replace the `Instructions`/`Router` machinery with published JSON Schemas
(`json_schemer`) that own validation and defaults for Picture Config and
Presets, validated once per build from a `:site, :post_read` hook, aborting the
build on failure. Coercion and resolution stay in hand-written Ruby.

## Why

Validation today is spread across ~25 `Instruction` subclasses, dispatched by
`Router#method_missing` mapping a method name to a class name. It works, and
`Instruction`'s source/valid?/coerce/error_message template is a clean seam —
but the setting model exists nowhere a user or a tool can read it, and nothing
static (rubocop, an editor, a call-graph tool) can follow the dispatch.

A schema fixes the readable-model problem twice over: it is the validator, and
it is a publishable artifact users can point `yaml-language-server` at for
autocomplete and inline errors in `picture.yml`. That second benefit is the one
users actually see, and it's why this is worth doing at all — the refactor
alone is invisible from outside.

## What this rules out

**Ruby has no standard-library equivalent of zod.** `Data` and pattern matching
can check shape but produce `NoMatchingPatternKeyError`, not "`fallback_width`
for preset 'logo' should be a positive integer." Error quality is most of the
value here.

**dry-schema** is the established Ruby answer and is genuinely zod-shaped, but
it pulls dry-core, dry-logic, dry-types, zeitwerk and concurrent-ruby into
every JPT user's bundle, alongside whatever other Jekyll plugins they run.
`json_schemer` needs only bigdecimal, hana, regexp_parser and simpleidn, and it
is the only option whose output is a standard document other tools consume.

**json_schemer does not coerce.** Roughly half of what the `Instruction`
classes do is coercion or resolution — scalar-to-list, `center` to `centre`,
markup name to class, quality interpolation between width points, environment
expressions. None of that is expressible in JSON Schema, so a normalization
layer survives the rewrite. The schema is not a total replacement for
`Instructions`; it replaces the validation half.

## Consequences

**Eager validation is the breaking change, not the rewrite.** Today an
instruction validates on first read, so a malformed setting that a site never
exercises never raises. Validating the whole document at `:post_read` turns
latent bad settings into build failures, including on sites that contain no
picture tags at all. That is the only reason this needs a major version; the
refactor by itself is invisible.

**`:post_read` is the only viable hook.** `_data` is loaded during
`Site#read`, so `:after_init` and `:after_reset` are both too early. Under
`--watch` the hook re-fires each rebuild, so the parsed result must hang off
the site object or be invalidated on `:after_reset` — the same staleness
problem `clear_instructions` exists to solve today, and easy to reintroduce at
build scope.

**Uniform access is kept; the metaprogramming is not.** Callers continue to say
`PictureTag.fallback_width` without knowing which document it came from, via
explicit `def_delegators` rather than `method_missing`. What is lost is the
ability to add a setting by dropping a file into `instructions/children/` —
internal convenience only.

**The fidelity risk is the real cost.** The schema must accept every input the
`valid?` methods currently accept, including undocumented flexibility that is
specified nowhere but in those methods and in strangers' sites. We decided
against deprecating any of it, which locks that surface in permanently.

To de-risk this, the schemas ship first — published and descriptive in a 3.x
minor, warning-only if they validate at all — and become authoritative in 4.0.
A wrong schema then produces a spurious warning for a release cycle instead of
a broken build.

**`markup:` becomes a closed enum.** `OutputClass` currently resolves it with
`Object.const_get`, so a user-defined `PictureTag::OutputFormats::Whatever` in
`_plugins/` works by accident. This is undocumented, is a code-execution
surface driven by a user-controlled string, and is not treated as public API.
If anyone turns out to depend on it, the replacement is a registration call,
not the const lookup.
