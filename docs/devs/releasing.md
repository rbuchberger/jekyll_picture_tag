---
---
# Cutting a Release

Publishing is automated: pushing a `vX.Y.Z` tag runs
[`.github/workflows/release.yml`](https://github.com/rbuchberger/jekyll_picture_tag/blob/master/.github/workflows/release.yml),
which builds the gem and pushes it to RubyGems.

There are no RubyGems API keys for this project. The workflow authenticates with [trusted
publishing](https://guides.rubygems.org/trusted-publishing/) Note that `release.yml` can't be
renamed without updating the trusted publisher registration on rubygems.org.

## Before you tag

1. In `CHANGELOG.md`, change the `[Unreleased]` heading to the new version and today's date, then
   add a fresh, empty `[Unreleased]` section above it.
2. `readme.md` carries a copy of the most recent changelog entries. Add the new one, then delete
   entries off the bottom until five remain.
3. Update `lib/jekyll_picture_tag/version.rb`, following [semver](https://semver.org/).
4. Commit, tag, push, and merge.

## Tagging

```sh
git tag v3.0.0
git push origin v3.0.0
```

The tag must start with `v` and match the version in `version.rb`. The `v` prefix triggers the
release workflow.

Then watch it: `gh run watch`, or the Actions tab. It takes a minute or two. When it finishes, the
new version is on
[rubygems.org/gems/jekyll_picture_tag](https://rubygems.org/gems/jekyll_picture_tag).

## When it goes wrong

**The workflow didn't run.** Tags pushed before the workflow existed, or pushed with
`--no-verify`-style shortcuts that skipped the hook, won't have triggered it. Use `workflow_dispatch`
from the Actions tab: it publishes whatever `version.rb` says on the branch you select. `rake
release` skips tagging when the tag already exists, so re-running is safe.

**RubyGems rejected the credentials.** The trusted publisher registration has to name this repo, the
workflow filename `release.yml`, and no environment. Check it under the gem's settings on
rubygems.org.

**You tagged the wrong commit, and the gem is already published.** Versions on RubyGems can be
yanked, but never reused. Bump the patch version and cut another release.
