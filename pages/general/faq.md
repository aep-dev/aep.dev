# Frequently Asked Questions

## What are the differences between AEPs and AIPs?

If you are familiar with Google's API Improvement Proposals 
[google.aip.dev](https://google.aip.dev), then much of the 
[API Enhancement Proposals](https://aep.dev) content will be familiar.

However, AEPs have notable philosophical differences, including:

- AEPs prioritize broadly applicable design guidance for any company, while AIPs
  prioritized design guidance specifically for Google (e.g., providing
  backwards-compatibility with prior decisions to meet Google-specific needs).
- AEPs are protocol-agonistic and consider both gRPC and HTTP+JSON as
  first-class protocols for which examples and other content are necessary.
- AEPs focuses on a core specification that is not intended to be forked, paired with a 
  mechanism for optional organization-specific guidance to extend the
  specification. AIPs encourage forking its guidance outright.

AEPs also have the advantage of hindsight, which makes it possible in some
cases to provide better guidance. (One small example:
renaming `page_size` to `max_page_size` for requests to paginated API methods.)
