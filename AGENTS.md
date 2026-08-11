# AGENTS.md

- Liquid tag syntax can only be extended; no breaking changes even in major versions.
- Maintain "no configuration required" - a new user must be able to add JPT to their gemfile, bundle
install, and start writing picture tags in their site without touching a yml file.

## Agent skills

### Github Interactions

Any github interaction (Issue, pull request, comment, etc.) that is written and/or posted using an
LLM must clearly state this fact at the beginning, in bold, using a complete sentence. You should
describe the nature of the LLM's involvement and the amount of human effort spent. Examples:

> **This was written and posted by AI** after a 40 word prompt, 14 questions and answers,
> and one round of review and feedback.

> **This was translated by AI** from Polish, more or less directly.

> **This was edited by AI** for grammar and clarity, based on an input of approximately similar
> size.

### Git commits

- All AI assisted commits should have a trailer: `Assisted-by: <model>`
- [Scoped commits](https://scopedcommits.com/), not conventional commits. Short version:

```
<scope>: <description>

[optional body]

[optional trailer(s)]
```

- <scope> — the subsystem, area, or module that the commit touches
- <description> — a short description of the changes made
- [optional body] — detailed information about the changes
- [optional trailer(s)] — additional metadata about the commit

### Issue tracker

Issues live in GitHub Issues for `rbuchberger/jekyll_picture_tag`, via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage labels, used verbatim. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
