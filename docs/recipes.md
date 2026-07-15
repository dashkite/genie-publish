# Recipes

## Basic Publishing

This guide explains how to configure basic asset publishing using Genie Publish. 
When building web applications, creators need a reliable mechanism to move final artifacts from a local build directory to a remote storage provider like S3. Genie Publish handles this securely, hashing files to prevent redundant uploads.

1. **Configure the target bucket**: In your project's `genie.yaml`, define a `publish` section to declare the destination S3 bucket.
2. **Execute the publish command**: Run the command in your terminal to begin the upload sequence.
3. **Verify the upload**: Check your S3 bucket to ensure the hashed artifacts have appeared.

```yaml
# configuration in genie.yaml
publish:
  bucket: my-production-assets
```

## Adding CloudFront Invalidation

This guide demonstrates how to configure Genie Publish to automatically invalidate a CloudFront cache after uploading new assets.
When you publish new versions of an asset to a CDN, you must inform the CDN to drop the old cached versions so consumers receive the latest updates.

1. **Specify the CloudFront domains**: Add a `domains` array to your `publish` configuration.
2. **Publish the assets**: The library will complete the standard upload.
3. **Wait for invalidation**: Upon completing the upload, Genie Publish automatically submits an invalidation request for the root path `/*` across all specified domains.

```yaml
# configuration in genie.yaml
publish:
  bucket: my-production-assets
  domains:
    - assets.example.com
```

## Customizing the Source Directory

This guide shows how to change the directory that Genie Publish reads files from.
Many projects output their final artifacts to custom directories rather than the default `build/browser/src`. Modifying the `root` and `glob` options allows you to target any directory structure.

1. **Override the root property**: Point the `root` property to your custom build output folder.
2. **Adjust the glob if necessary**: By default, it captures all files recursively. Modify the glob if you only need specific file types.
3. **Run the publish command**: The command will now source from your custom directory.

```yaml
# configuration in genie.yaml
publish:
  root: public/dist
  glob: "**/*.js"
  bucket: my-production-assets
```
