# Genie Publish

*Publish build artifacts to S3*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Genie Publish is a task preset for the Genie task runner that handles uploading build artifacts to Amazon S3. It integrates directly into the standard build lifecycle, providing commands to publish assets, clean up state, and automatically publish changes during development. 

## Features

- Integrates with Genie's build lifecycle.
- Automatically hashes and publishes files to an S3 bucket.
- Supports CloudFront invalidation for deployed assets.
- Includes SNS notifications for build events.
- Automatically caches files forever by leveraging content hashes.

## Installation

```bash
pnpm install -D @dashkite/genie-publish
```

## Usage

Because Genie Publish is a preset, it automatically registers its commands when installed. You do not need to initialize it within your `genie.yaml` beyond standard task configurations.

To use the preset, configure your publish settings in `genie.yaml` and invoke the new commands:

```bash
npx genie publish
```

This will run the publish workflow. You can also run the watch command which will automatically publish upon changes:

```bash
npx genie publish:watch
```

## Other Resources

- [Reference Documentation](docs/reference.md)
- [Recipes](docs/recipes.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
