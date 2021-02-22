# Request identification

It is sometimes useful for an API to have a unique, customer-provided
identifier for particular requests. This can be useful for several purposes,
such as de-duplicating requests from parallel processes, ensuring the safety of
retries, or auditing.

The most important purpose for request IDs is to provide idempotency
guarantees: allowing the same request to be issued more than once without
subsequent calls having any effect. In the event of a network failure, the
client can retry the request, and the server can detect duplication and ensure
that the request is only processed once.

## Guidance

An operation **may** allow an `X-Request-Id` header in order to uniquely
identify particular requests:

```http
POST /v1/publishers/{publisher}/books HTTP/2
Host: library.googleapis.com
Accept: application/json
X-Request-Id: 994117a0-e9c2-4189-8c10-77d058aafa82

{
  // Request body...
}
```

- Providing a request ID **must** guarantee idempotency.
  - If a duplicate request is detected, the server **should** return the
    response for the previously successful request, because the client most
    likely did not receive the previous response.
  - APIs **may** choose any reasonable timeframe for honoring request IDs.
- Request IDs **should** be optional.
- Request IDs **should** be able to be UUIDs, and **may** allow UUIDs to be the
  only valid format. The format restrictions for request IDs **must** be
  documented.

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

- For which codes to retry, see AIP-194.

## Changelog

- **2019-08-01**: Changed the examples from "shelves" to "publishers", to
  present a better example of resource ownership.
