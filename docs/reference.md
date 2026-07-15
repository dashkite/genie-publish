# Reference

This document covers the commands and configuration properties provided by Genie Publish.

## Commands

### publish

$publish: \to \emptyset$

Executes the primary publishing workflow. It reads files from the designated root, hashes their contents, uploads them to the configured S3 bucket, and sends an SNS notification on completion. If CloudFront domains are configured, it triggers a cache invalidation.

### publish:watch

$publish:watch: \to \emptyset$

Runs the publish workflow in watch mode. It hooks into Genie's standard `watch` command, running after `build`, to continuously monitor the root directory and publish any modified assets immediately.

### publish:clean

$publish:clean: \to \emptyset$

Clears internal tracking state about which files have already been published. This ensures that a subsequent `publish` task will re-evaluate all files in the configured root directory rather than skipping those it previously marked as unchanged.

## Configuration Properties

### root

$root \to string$

The base directory containing the built assets to publish. Defaults to `build/browser/src`.

### glob

$glob \to string$

The glob pattern used to find files within the `root` directory. Defaults to `**/*`.

### bucket

$bucket \to string$

The name of the S3 bucket where files will be uploaded. This is a required configuration.

### target

$target \to string$

The template for the target S3 key path. Defaults to `${ source.path }`.

### cache

$cache \to string$

The `Cache-Control` header value applied to uploaded files. Defaults to `must-revalidate`.

### domains

$domains \to array$

An optional list of CloudFront domains. If provided, the preset will invalidate the `/*` path on these domains after successfully publishing files.

### topic

$topic \to string$

The DRN of the SNS topic to which publish events are notified. Defaults to `drn:topic/dashkite/development`.
