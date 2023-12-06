# Idempotency

It is sometimes useful for an API to have a unique, customer-provided
identifier for particular requests. This can be useful for several purposes,
such as:

- De-duplicating requests from parallel processes
- Ensuring the safety of retries
- Auditing

The purpose of idempotency keys is to provide idempotency guarantees: allowing
the same request to be issued more than once without subsequent calls having
any effect. In the event of a network failure, the client can retry the
request, and the server can detect duplication and ensure that the request is
only processed once.

## Guidance

APIs **may** add a `string idempotency_key` parameter to request messages
(including those of standard methods) in order to uniquely identify particular
requests.

```proto
message CreateBookRequest {
  // The parent resource where this book will be created.
  // Format: publishers/{publisher}
  string parent = 1 [
    (google.api.field_behavior) = REQUIRED,
    (google.api.resource_reference) = {
      child_type: "library.example.com/Book"
    }];

  // The book to create.
  Book book = 2 [(google.api.field_behavior) = REQUIRED];

  // A unique identifier for this request. Restricted to 36 ASCII characters.
  // A random UUID is recommended.
  // This request is only idempotent if a `idempotency_key` is provided.
  string idempotency_key = 3 [(google.api.field_info).format = UUID4];
}
```

- Providing an idempotency key **must** guarantee idempotency.
  - If a duplicate request is detected, the server **should** return the
    response for the previously successful request, because the client most
    likely did not receive the previous response.
  - APIs **should** honor idempotency keys for at least an hour.
- The `idempotency_key` field **must** be provided on the request message to
  which it applies (and it **must not** be a field on resources themselves).
- Idempotency keys **should** be optional.
- Idempotency keys **must** be able to be UUIDs, and **may** allow UUIDs to be
  the only valid format. The format restrictions for idempotency keys **must**
  be documented.
  - When using protocol buffers, idempotency keys that are UUIDs **must** be
    annotated with the `google.api.FieldInfo.Format` value `UUID4` using the
    extension `(google.api.field_info).format = UUID4`. See
    [AEP-202](../0202/aep.md) for more.

### Stale success responses

In some unusual situations, it may not be possible to return an identical
success response. For example, a duplicate request to create a resource may
arrive after the resource has not only been created, but subsequently updated;
because the service has no other need to retain the historical data, it is no
longer feasible to return an identical success response.

In this situation, the method **may** return the current state of the resource
instead. In other words, it is permissible to substitute the historical success
response with a similar response that reflects more current data.

## Further reading

- For which codes to retry, see [AEP-194](https://aep.dev/194).
- For how to retry errors in client libraries, see
  [AEP-4221](https://aep.dev/4221).

## Rationale

### Naming the field `idempotency_key`

The original content from which this AEP is derived defines a `request_id`
field; we define `idempotency_key` instead for two reasons:

1. There is an [active Internet-Draft][idempotency-key-draft] to standardize an
   HTTP header named `Idempotency-Key`.
1. There may be edge cases in which separately identifying idempotent requests
   is useful; `request_id` would be more appropriate for such use cases. For
   example, an API producer might be testing the idempotency behavior of the
   API server, and might want to issue multiple requests with the same
   `idempotency_key` and trace the behavior of each request separately.

<!-- prettier-ignore-start -->
[idempotency-key-draft]: https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/
<!-- prettier-ignore-end -->

### Using UUIDs for request identification

When a value is required to be unique, leaving the format open-ended can lead
to API consumers incorrectly providing a duplicate identifier. As such,
standardizing on a universally unique identifier drastically reduces the chance
for collisions when done correctly.

## Changelog

- **2023-11-21**: Adopt AEP from from Google's AIP; rename field from
  `request_id` to `idempotency_key`.
- **2023-10-02**: Add UUID format extension guidance.
- **2019-08-01**: Changed the examples from "shelves" to "publishers", to
  present a better example of resource ownership.
