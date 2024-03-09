# Frequently Asked Questions

## What is the difference between aep.dev and google.aip.dev?

As aep.dev is derived from [google.aip.dev](https://google.aip.dev), a lot of
content will be familiar.

However, aep.dev has significant philosophical differences:

- aep.dev prioritizes broadly applicable design guidance, while google.aip.dev
  prioritizes design guidance this best for Google, such as guidance that is
  backwards-compatible with existing decisions at the company.
- aep.dev is protocol-agonistic, and considers gRPC and HTTP + JSON as
  first-class protocols for which examples and other content will be authored.
- google.aip.dev encourages forking the guidance, while aep.dev focuses on a
  set of core specification that should not be forked, paired with a method to
  add organization-specific guidance that does not contradict the
  specification.

aep.dev also has the advantage of hindsight, which makes it possible in some
cases to provide better guidance than google.aip.dev. (One small example:
renaming `page_size` to `max_page_size` for requests to paginated API methods.)
