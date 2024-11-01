# Contributing

We'd love to accept your patches and contributions to this project.

## Importing an AEP from google.aip.dev

Currently, the project is focused on adopting AIPs from
https://google.aip.dev/. You can contribute!

You can
[watch the video walkthrough](https://drive.google.com/file/d/1hCBxfTJPINVUpTLnzccJy4pFXZhQQMd3/view?usp=sharing),
or follow the step by step guide:

1. [Select an AIP to adopt into an AEP from the open issues with the label "adoption"](https://github.com/aep-dev/aep.dev/labels/adoption).
   - Consider
     [ones also with the label "good first issue"](https://github.com/aep-dev/aep.dev/issues?q=is%3Aopen+label%3A%22good+first+issue%22+label%3Aadoption).
1. Navigate to the
   [GitHub Repository](https://github.com/aip-dev/google.aip.dev), and find the
   AIP in the
   [general directory](https://github.com/aip-dev/google.aip.dev/tree/master/aip/general).
   Copy the raw content.
1. Create a directory for the aep, and update the aep.yaml file to "approved".
   [Full example PR](https://github.com/aep-dev/aep.dev/pull/77/files).
1. Modify the content from the aip markdown and paste over the aep.md content.
   - Remove any Google-isms (e.g. replace Google domains with example.com).
   - Extend any proto-specific guidance to include both OpenAPI and proto.
     representations.
1. Create a GitHub PR. A reviewer should be with you in 24 hours.
   - If a reviewer does not review within that time, please ping @rofrankel or
     @toumorokoshi.
   - Leave comments on any parts of the text that you would like to discuss.
1. Come say hi in our various communication channels documented in the
   [README](README.md#learn-and-connect).

Some tips:

- Less is more. If there's a hard disagreement about particular guidance,
  consider filing a follow-up issue to get the agreed upon guidance merged.
- Perfect is the enemy of good. Feel free to submit PRs that are mostly there,
  and leave questions so reviewers can help address any questions or concerns.

## Development Environment

If you are contributing AEP content (rather than code) and want to be able to
view it in your browser, the easiest way to do so is to run the site-generator
script.

We use [GitHub Pages][1] to make this documentation available, and a specific
[site generator][2] to build the site.

Run `./scripts/serve.sh` to:

- clone the site-generator repository.
- run the appropriate npm commands.
- begin the dev server at port 4321.

### Hot reloading

The development server currently does not support hot reloading.
