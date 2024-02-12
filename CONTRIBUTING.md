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
view it in your browser, the easiest way to do so is to run the provided
development server.

We use [GitHub Pages][1] to make this documentation available, and a specific
[site generator][2] to build the site.

If you have [Docker][3] installed, clone this repository and run the `serve.sh`
file at the root of the repository. This script does two things:

- It builds the provided Docker image (unless you already have it) and tags it
  as `aep-site`.
- It runs the `aep-site` image.

The development server uses port 4000; point your web browser to
`http://localhost:4000`, and you should see the site.

**Note:** After building the Docker image for the first time, you may
experience issues if Python dependencies change underneath you. If this
happens, remove your Docker image (`docker rmi aep-site`) and run `serve.sh`
again.

### Arguments

Any arguments provided to `serve.sh` (or `docker run`) are forwarded (however,
the current site generator does not honor any; this may change in the future).

### Hot reloading

The development server recognizes when files change (including static files)
and local changes will be automatically reflected in your browser upon reload.

### Local Installation

It is possible to run the development server locally also. The general gist of
how to do so correctly is:

- Install Python 3.8 if you do not already have it (direct install is fine, but
  [pyenv][5] is probably the best way if you have other Python projects).
- Create a Python 3.8 [venv][6]. Once it is created, activate it in your shell
  (`source path/to/venv/bin/activate`).
- `pip install git+https://github.com/aep-dev/site-generator.git`
- `aep-site-serve .`

## Contributor License Agreement

Contributions to this project must be accompanied by a Contributor License
Agreement. You (or your employer) retain the copyright to your contribution,
this simply gives us permission to use and redistribute your contributions as
part of the project. Head over to <https://cla.developers.google.com/> to see
your current agreements on file or to sign a new one.

You generally only need to submit a CLA once, so if you have already submitted
one (even if it was for a different project), you probably do not need to do it
again.

## Code reviews

All submissions, including submissions by project members, require review. We
use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/articles/about-pull-requests/) for more
information on using pull requests.

### Formatting

We use [prettier][4] to format Markdown, JavaScript, and (most) HTML, in order
to ensure a consistent style throughout our source. You can add prettier as a
plugin in most development environments.

[1]: https://pages.github.com/
[2]: https://github.com/aep-dev/site-generator
[3]: https://docker.com/
[4]: https://prettier.io/
[5]: https://github.com/pyenv/pyenv
[6]: https://docs.python.org/3/library/venv.html
