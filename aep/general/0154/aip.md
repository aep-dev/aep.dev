# Resource freshness validation

APIs often need to validate that a client and server agree on the current state
of a resource before taking some kind of action on that resource. For example,
two processes updating the same resource in parallel could create a race
condition, where the latter process "stomps over" the effort of the former one.

ETags provide a way to deal with this, by allowing the server to send a
checksum based on the current content of a resource; when the client sends that
checksum back, the server can ensure that the checksums match before acting on
the request.

## Guidance

A resource **may** provide an `ETag` header when retrieving a single resource
when it is important to ensure that the client has an up to date resource
before acting on certain requests:

```
200 OK
Content-type: application/json
ETag: "55cc0347-66fc-46c3-a26f-98a9a7d61d0e"
```

The ETag **must** be provided by the server on output, and values **should**
conform to [RFC 7232][]. Resources **must** support the `If-Match` header (and
**may** support the `If-None-Match` header) if and only if resources provide
the ETag.

**Note:** ETag values **must** include quotes as described in [RFC 7232][]. For
example, a valid ETag is `"foo"`, not `foo`.

ETags **must** be based on an opaque checksum or hash of the resource that
guarantees it will change if the resource changes.

### Condition headers

Services that provide ETags **should** support the `If-Match` and
`If-None-Match` headers on incoming requests:

```http
GET /v1/publishers/{publisher}/books/{book} HTTP/2
Host: library.googleapis.com
Accept: application/json
If-Match: "55cc0347-66fc-46c3-a26f-98a9a7d61d0e"
```

If the service receives a request to modify a resource that includes an
`If-Match` header, the service **must** validate that the value matches the
current ETag. If the `If-Match` header value does not match the ETag, the
service **must** reply with an HTTP 412 error.

If the user omits the `If-Match` header, the service **should** permit the
request. However, services with strong consistency or parallelism requirements
**may** require users to send ETags all the time and reject the request with an
HTTP 400 error if it does not contain an ETag.

If any conditional headers are supported for any operation within a service,
the same conditional headers **must** be supported for all mutation methods
(`POST`, `PATCH`, `PUT`, and `DELETE`) of any path that supports them, and
**should** be supported uniformly for all operations across the service.

If any validator or conditional headers are supported for any operations in the
service, the use of unsupported conditional headers **must** result in an
error. (In other words, once a service gives the client reason to believe it
understands conditional headers, it **must not** ever ignore them.)

### Read requests

If a service receives a `GET` or `HEAD` request with an `If-Match` header, the
service **must** proceed with the request if the ETag matches, or send a
`412 Precondition Failed` error if the ETag does not match.

If a service receives a `GET` or `HEAD` request with an `If-None-Match` header,
the service **must** proceed with the request if the ETag does not match, or
return a `304 Not Modified` response if the ETag does match.

### Strong and weak ETags

ETags can be either "strongly validated" or "weakly validated":

- A strongly validated ETag means that two resources bearing the same ETag are
  byte-for-byte identical.
- A weakly validated ETag means that two resources bearing the same ETag are
  equivalent, but may differ in ways that the service does not consider to be
  important.

Resources **may** use either strong or weak ETags, as it sees fit, but
**should** document the behavior. Additionally, weak ETags **must** have a `W/`
prefix as mandated by [RFC 7232][]:

```
200 OK
Content-type: application/json
ETag: W/"55cc0347-66fc-46c3-a26f-98a9a7d61d0e"
```

Strong ETags **must** and weak ETags **should** be guaranteed to change if any
properties on the resource change that are directly mutable by the client.
Additionally, strong ETags **should** be guaranteed to change if the resource's
representation changes in a meaningful way (meaning the new representation is
not equivalent to the old one).

## Further reading

- For how to retry on errors in client libraries, see AIP-194.

## Changelog

- **2020-09-02**: Clarified that other errors may take precedence over
  `FAILED_PRECONDITION` for ETag mismatches.
- **2020-09-02**: Add guidance for ETags on request messages.
- **2019-09-23**: Changed the title to "resource freshness validation".

[rfc 7232]: https://tools.ietf.org/html/rfc7232#section-2.3
