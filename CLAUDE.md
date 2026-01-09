# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository builds and publishes a Docker image that provides a Go 1.25 Alpine-based container with pre-installed tools for Go development with templ templates. The image is published to Docker Hub as `dinamic/golang-templ`.

**Key Dependencies:**
- Base: `golang:1.25-alpine`
- Pre-installed: `templ@v0.3.977`, `g++`, `libwebp-dev`, `git`

## Docker Image Build

The Dockerfile is minimal and single-stage. When modifying the templ version:
1. Update the version in `Dockerfile:4` (e.g., `github.com/a-h/templ/cmd/templ@v0.3.977`)
2. Tag and push to trigger the GitHub Actions workflow

## Release Process

Images are automatically built and pushed to Docker Hub when tags are created:

1. **Create a tag** (either via git or GitHub UI):
   ```bash
   git tag v0.3.977
   git push origin v0.3.977
   ```
   Or create the tag directly in the GitHub UI

2. **GitHub Actions workflow** (`.github/workflows/docker-build.yml`) will:
   - Trigger on tags starting with `v*`
   - Build multi-platform images for `linux/amd64` and `linux/arm64`
   - Push to Docker Hub with both the version tag and `latest`
   - Requires `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets

**Note:** The workflow includes special handling for tags created via GitHub UI vs git push, extracting tag names differently for each event type.

## Architecture

This is a Docker infrastructure project, not an application. The container serves as a base image for Go projects using templ templates. The `CMD ["/bin/sh"]` ensures the container stays running, allowing GitHub Actions or other CI/CD systems to execute steps inside it.
