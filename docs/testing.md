# Testing

This document outlines the testing strategy for Genie Publish.

## General Approach

The test suite evaluates the preset's core tasks by ensuring that files are read correctly, hashed, and processed as expected during the simulated build lifecycle. The approach focuses on integration within the Genie environment, verifying that configuration overrides take effect and that the command hooks (like `publish`, `publish:watch`, and `publish:clean`) register correctly.

To run the test suite, invoke the standard Genie command:

```bash
npx genie test
```

This ensures all tests execute using the local development dependencies defined in the project, validating that the integration with the `genie` task runner operates smoothly.
