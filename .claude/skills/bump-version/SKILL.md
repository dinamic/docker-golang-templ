---
name: bump-version
description: Bump Go and/or templ versions in the Dockerfile, commit, tag, and push to main
argument-hint: "[go=X.Y.Z] [templ=vX.Y.Z]"
disable-model-invocation: true
allowed-tools: Bash Read Edit WebFetch
---

Bump the Go and/or templ version in this Docker image project.

## Arguments

The user provides versions to bump as arguments, e.g.:
- `/bump-version go=1.26.2 templ=v0.3.1001` — bump both
- `/bump-version go=1.26.2` — bump Go only
- `/bump-version templ=v0.3.1001` — bump templ only

Parse `$ARGUMENTS` for `go=` and `templ=` values.

If no arguments are provided, ask the user which versions to bump.

## Steps

### 1. Validate versions exist

Before making any changes, verify the requested versions actually exist:

- **Go**: Fetch `https://hub.docker.com/v2/repositories/library/golang/tags/?name=<version>-alpine` and confirm the tag exists. If it does not exist, tell the user and stop.
- **templ**: Fetch `https://api.github.com/repos/a-h/templ/releases/tags/<version>` and confirm it returns 200. If it does not exist, tell the user and stop.

### 2. Update the Dockerfile

- Read `Dockerfile`
- Update the `FROM golang:<version>-alpine` line if a Go version was provided
- Update the `go install github.com/a-h/templ/cmd/templ@<version>` line if a templ version was provided

### 3. Commit the changes

- Stage only the `Dockerfile`
- Commit with message format: `docker: bump Go to X.Y.Z and templ to vX.Y.Z` (adjust if only one was bumped, e.g. `docker: bump Go to X.Y.Z` or `docker: bump templ to vX.Y.Z`)
- Do NOT mention Claude in the commit message

### 4. Tag and push

- Determine the tag name: always use the pattern `go<go_version>-templ<templ_version>` (e.g. `go1.26.2-templ0.3.1001`). Strip the `v` prefix from the templ version when forming the tag. If only one version was bumped, read the other from the Dockerfile to form the full tag.
- Create a git tag with that name
- Push the commit and tag to origin/main:
  ```
  git push origin main
  git push origin <tag>
  ```

### 5. Create a GitHub release

- Create a GitHub release for the tag using `gh release create`:
  - Title: the tag name
  - Notes: list what was bumped (e.g. `- Bump Go to 1.26.2\n- Bump templ to v0.3.1001`)

### 6. Report

Tell the user:
- What was updated
- The commit hash
- The tag that was pushed
- The GitHub release URL
- Remind them that the GitHub Actions workflow will build and push the Docker image automatically
