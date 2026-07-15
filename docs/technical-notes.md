# Technical Notes

### Decoupled Task Management with Genie
Genie Publish leverages the Genie preset architecture to function as a decoupled task manager. Rather than tightly binding deployment logic into application source code, the preset registers discrete commands (`publish`, `publish:watch`, and `publish:clean`) directly into the task runner. This separation of concerns ensures that the build lifecycle remains independent of the application, allowing creators to manage deployment capabilities without entangling infrastructure scripts with their core codebase.

### Hashing and Cache Control
Genie Publish employs content-based hashing before uploading files to the Amazon S3 bucket. Hashing ensures that files with identical contents are not uploaded repeatedly, which conserves bandwidth and accelerates the overall deployment pipeline. By utilizing content hashes, the preset can confidently instruct edge caches to store the files indefinitely.

### CloudFront Invalidation Strategy
When utilizing Amazon CloudFront as a Content Delivery Network (CDN), caching stale assets is a common challenge. Genie Publish tackles this by dispatching an invalidation request for the `/*` path whenever a deployment succeeds. The invalidation explicitly purges the edge cache, forcing the CDN to fetch the newly uploaded assets from the origin S3 bucket on the subsequent request.

### The Role of SNS Notifications
To facilitate a responsive developer ecosystem, Genie Publish broadcasts a notification to an Amazon SNS (Simple Notification Service) topic upon completion. This publish-subscribe model enables other services or background tasks to react instantly to deployment events, such as triggering end-to-end tests, notifying team channels, or logging auditing metadata.
