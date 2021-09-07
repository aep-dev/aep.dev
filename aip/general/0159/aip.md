# Reading across collections

Sometimes, it is useful for a user to be able to retrieve resources across
multiple collections, or retrieve a single resource without needing to know
what collection it is in.

## Guidance

There are two potential approaches for reading resources across multiple
collections. Groups of related services **should**, as a unit, select a
preferred approach and apply it consistently.

### Promoting Resources

One approach is to evade the problem entirely by promoting resources above
their erstwhile parents in the event that reading across collections is likely
to be a requirement.

In this approach, the parent becomes a field on the resource:

```typescript
interface Book {
  // The ID of the book's publisher
  publisherId: string;

  // Other fields...
}
```

Similarly, the parent is removed from the URI:

```
GET /v1/books?filter...
```

### Wildcards

The other approach is to use a wildcard character. Services **may** support
reading resources across multiple collections by allowing users to specify a
`-` (the hyphen or dash character) as a wildcard character in a standard
[`List`][aip-132] operation:

```
GET /v1/publishers/-/books?filter=...
```

- The URI pattern **must** still accept a parameter to permit the collection to
  be specified; a URI pattern **must not** hard-code the `-` character.
- The operation **must** explicitly document that this behavior is supported.
- Responses **must** populate the canonical parent ID rather than `-` if the
  parent ID is normally provided in the resource in some way.
  - If resources include the parent ID within the name of the resource, the
    resources provided in the response **must** use the canonical name of the
    resource, with the actual parent collection identifiers (instead of `-`).
  - If resources include a field indicating the ID of the parent, resources
    provided in the response **must** populate the canonical parent ID (instead
    of `-`).
- Services **may** support reading across collections on `List` requests
  regardless of whether the identifiers of the child resources are guaranteed
  to be unique.
  - However, services **must not** support reading across collections on `Get`
    requests if the child resources might have a collision.
- Cross-parent requests **may** support `order_by`. However, if reading across
  collections requires consulting multiple backends, databases, or locations,
  cross-parent requests **should not** support `order_by`, and if they do, the
  field **must** document that it is best effort. This is because cross-parent
  requests introduce ambiguity around ordering, especially if there is
  difficulty reaching a parent (see AIP-217).

**Important:** If listing across multiple collections introduces the
possibility of partial failures due to unreachable parents (such as when
listing across locations), the operation **must** indicate this following the
guidance in AIP-217.

### Unique resource lookup

Sometimes, a resource within a sub-collection has an identifier that is unique
across parent collections. In this case, it may be useful to allow a
[`Get`][aip-131] operation to retrieve that resource without knowing which
parent collection contains it. In such cases, APIs **may** allow users to
specify the wildcard collection ID `-` (the hyphen or dash character) to
represent any parent collection:

```
GET https://example.googleapis.com/v1/publishers/-/books/{book}
```

- The URI pattern **must** still be specified with `*` and permit the
  collection to be specified; a URI pattern **must not** hard-code the `-`
  character.
- The operation **must** explicitly document that this behavior is supported.
- The resource name in the response **must** use the canonical name of the
  resource, with actual parent collection identifiers (instead of `-`). For
  example, the request above returns a resource with a name like
  `publishers/123/books/456`, _not_ `publishers/-/books/456`.
- The resource ID **must** be unique within parent collections.

## Further reading

- For partial failures due to unreachable resources, see AIP-217.
