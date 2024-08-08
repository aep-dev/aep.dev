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

APIs **may** add a `aep.api.IdempotencyKey idempotency_key` parameter to
request messages (including those of standard methods) in order to uniquely
identify particular requests. API servers **must not** execute requests with
the same `idempotency_key` more than once.

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

  // This request is only idempotent if `idempotency_key` is provided.
  //
  // This key will be honored for at least one hour after the first time it is
  // seen by the server.
  //
  // The key is restricted to 36 ASCII characters. A random UUID is recommended.
  aep.api.IdempotencyKey idempotency_key = 3 [
      (aep.api.field_info).minimum_lifetime = { seconds: 3600 }
  ];
}
```

- [`aep.api.IdempotencyKey`][] has a `key` and a `first_sent` timestamp.

  - `key` is simply a unique identifier.

- Providing an idempotency key **must** guarantee idempotency.

  - If a duplicate request is detected, the server **must** return one of:

    - A response equivalent to the response for the previously successful
      request, because the client most likely did not receive the previous
      response.
    - An error indicating that the `first_sent` field of the idempotency key is
      invalid or cannot be honored (expired, in the future, or differs from a
      previous `first_sent` value with the same `key`).
    - An error, if returning an equivalent response is not possible.

      For example, if a resource was created, then deleted, and then a
      duplicate request to create the resource is received, the server **may**
      return an error if returning the previously created resource is not
      possible.

  - APIs **should** honor idempotency keys for at least an hour.
    - When using protocol buffers, idempotency keys that are UUIDs **must** be
      annotated with a minimum lifetime using the extension
      [`(aep.api.field_info).minimum_lifetime`][].

- The `idempotency_key` field **must** be provided on the request message to
  which it applies (and it **must not** be a field on resources themselves).

  - The `first_sent` field can be used by API servers to determine if a key is
    expired. API servers **must** reject requests with expired keys, and
    **must** reject requests with keys that are in the future. When feasible,
    API servers **should** reject requests that use the same `key` but have a
    different `first_sent` timestamp.
  - The `key` field **must** be able to be a UUID, and **may** allow UUIDs to
    be the only valid format. The format restrictions for idempotency keys
    **must** be documented.

- Idempotency keys **should** be optional.

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
[`aep.api.IdempotencyKey`]: https://buf.build/aep/api/file/main:aep/api/idempotency_key.proto#L21
[`(aep.api.field_info).minimum_lifetime`]: https://buf.build/aep/api/file/main:aep/api/field_info.proto#L35
<!-- prettier-ignore-end -->

### Using UUIDs for request identification

When a value is required to be unique, leaving the format open-ended can lead
to API consumers incorrectly providing a duplicate identifier. As such,
standardizing on a universally unique identifier drastically reduces the chance
for collisions when done correctly.

## Changelog

- **2023-12-20**: Adopt AEP from from Google's AIP with the following changes:
  - Rename field from `request_id` to `idempotency_key` (plus some minor
    releated rewording).
  - Add a common component [`aep.api.IdempotencyKey`][] and use this rather
    than `string` for the `idempotency_key` field; add related guidance about
    `IdempotencyKey.first_seen`.
  - Remove guidance about annotating `idempotency_key` with
    `(google.api.field_info).format`.
  - Add guidance about annotating `idempotency_key` with
    [`(aep.api.field_info).minimum_lifetime`].
  - Update guidance about responses to be more explicit about success and error
    cases, while allowing "equivalent" rather than identical responses for
    subsequent requests.
  - Temporarily removed the section about stale success responses, pending
    further discussion.
- **2023-10-02**: Add UUID format extension guidance.
- **2019-08-01**: Changed the examples from "shelves" to "publishers", to
  present a better example of resource ownership.
