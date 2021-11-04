# Pagination

APIs often need to provide collections of data, most commonly in the
[List][aip-132] standard method. However, collections can often be arbitrarily
sized, and also often grow over time, increasing lookup time as well as the
size of the responses being sent over the wire. Therefore, it is important that
collections be paginated.

## Guidance

Operations returning collections of data **must** provide pagination _at the
outset_, as it is a [backwards-incompatible change](#backwards-compatibility)
to add pagination to an existing method.

```typescript
// The request structure for listing books.
interface ListBooksRequest {
  // The parent, which owns this collection of books.
  // Format: publishers/{publisher}
  parent: string;

  // The maximum number of books to return. The service may return fewer than
  // this value.
  // If unspecified, at most 50 books will be returned.
  // The maximum value is 1000; values above 1000 will be coerced to 1000.
  maxPageSize: bigint;

  // A page token, received from a previous `ListBooks` call.
  // Provide this to retrieve the subsequent page.
  //
  // When paginating, all other parameters provided to `ListBooks` must match
  // the call that provided the page token.
  pageToken: string;
}

// The response structure from listing books.
interface ListBooksResponse {
  // The books from the specified publisher.
  books: Book[];

  // A token that can be sent as `page_token` to retrieve the next page.
  // If this field is omitted, there are no subsequent pages.
  nextPageToken: string;
}
```

- Request definitions for collections **should** define an
  `int32 max_page_size` field, allowing users to specify the maximum number of
  results to return.
  - If the user does not specify `max_page_size` (or specifies `0`), the API
    chooses an appropriate default, which the API **should** document. The API
    **must not** return an error.
  - If the user specifies `max_page_size` greater than the maximum permitted by
    the service, the service **should** coerce down to the maximum permitted
    page size.
  - If the user specifies a negative value for `max_page_size`, the API
    **must** return a `400 Bad Request` error.
  - The service **should** the number of results requested, unless the end of
    the collection is reached.
    - However, occasionally this is infeasible, especially within expected time
      limits. In these cases, the service **may** return fewer results than the
      number requested (including zero results), even if not at the end of the
      collection.
- Request definitions for collections **should** define a `string page_token`
  field, allowing users to advance to the next page in the collection.
  - If the user changes the `max_page_size` in a request for subsequent pages,
    the service **must** honor the new page size.
  - The user is expected to keep all other arguments to the operation request
    the same; if any arguments are different, the API **should** send a
    `400 Bad Request` error.
- The response **must not** be a streaming response.
- Services **may** support using page tokens across versions of a service, but
  are not required to do so.
- Response definitions for collections **must** define a
  `string next_page_token` field, providing the user with a page token that may
  be used to retrieve the next page.
  - The field containing pagination results **should** be the first field
    specified. It **should** be a repeated field containing a list of resources
    constituting a single page of results.
  - If the end of the collection has been reached, the `next_page_token` field
    **must** be empty. This is the _only_ way to communicate
    "end-of-collection" to users.
  - If the end of the collection has not been reached (or if the API can not
    determine in time), the service **must** provide a `next_page_token`.
- Response definitions **may** include a `string next_page_url` field
  containing the full URL for the next page.
- Response definitions for collections **may** provide an `int32 total_size`
  field, providing the user with the total number of items in the list.
  - This total **may** be an estimate (but the API **should** explicitly
    document that).

[rfc-8288]: https://tools.ietf.org/html/rfc8288

### Skipping results

The request definition for a paginatied operation **may** define an
`int32 skip` field to allow the user to skip results.

The `skip` value **must** refer to the number of individual resources to skip,
not the number of pages.

For example:

- A request with no page token and a `skip` value of `30` returns a single page
  of results starting with the 31st result.
- A request with a page token corresponding to the 51st result (because the
  first 50 results were returned on the first page) and a `skip` value of `30`
  returns a single page of results starting with the 81st result.

If a `skip` value is provided that causes the cursor to move past the end of
the collection of results, the response **must** be `200 OK` with an empty
result set, and not provide a `next_page_token`.

### Opacity

Page tokens provided by services **must** be opaque (but URL-safe) strings, and
**must not** be user-parseable. This is because if users are able to
deconstruct these, _they will do so_. This effectively makes the implementation
details of your API's pagination become part of the API surface, and it becomes
impossible to update those details without breaking users.

**Warning:** Base-64 encoding an otherwise-transparent page token is **not** a
sufficient obfuscation mechanism.

For page tokens which do not need to be stored in a database, and which do not
contain sensitive data, an API **may** obfuscate the page token by defining an
internal protocol buffer message with any data needed, and send the serialized
proto, base-64 encoded.

Page tokens **must** be limited to providing an indication of where to continue
the pagination process only. They **must not** provide any form of
authorization to the underlying resources, and authorization **must** be
performed on the request as with any other regardless of the presence of a page
token.

### Expiring page tokens

Many services store page tokens in a database internally. In this situation,
the service **may** expire page tokens a reasonable time after they have been
sent, in order not to needlessly store large amounts of data that is unlikely
to be used. It is not necessary to document this behavior.

**Note:** While a reasonable time may vary between services, a good rule of
thumb is three days.

### Consistency

When discussing pagination, consistency refers to the question of what to do if
the underlying collection is modified while pagination is in progress. The most
common way that this occurs is for a resource to be added or deleted in a place
that the pagination cursor has already passed.

Services **may** choose to be strongly consistent by approximating the
"repeatable read" behavior in databases, and returning exactly the records that
exist at the time that pagination begins.

### Backwards compatibility

Adding pagination to an existing operation is a backwards-incompatible change.
This may seem strange; adding fields to interface definitions is generally
backwards compatible. However, this change is _behaviorally_ incompatible.

Consider a user whose collection has 75 resources, and who has already written
and deployed code. If the API later adds pagination fields, and sets the
default to 50, then that user's code breaks; it was getting all resources, and
now is only getting the first 50 (and does not know to advance pagination).
Even if the API set a higher default limit, such as 100, the user's collection
could grow, and _then_ the code would break.

For this reason, it is important to always add pagination to operations
returning collections _up front_; they are consistently important, and they can
not be added later without causing problems for existing users.

**Warning:** This also entails that, in addition to presenting the pagination
fields, they **must** be _actually implemented_ with a non-infinite default
value. Implementing an in-memory version (which might fetch everything then
paginate) is reasonable for initially-small collections.

## Implementation

Page tokens **should** be versioned independently of the public API, so that
page tokens can be used with any version of the service.

The simplest form of a page token only requires an offset. However, offsets
pose challenges when a distributed database is introduced, so a more robust
page token needs to store the information needed to find a "logical" position
in the database. The simplest way to do this is to include relevant data from
the last result returned. Primarily, this means the resource ID, but also
includes any other fields from the resource used to sort the results (for the
event where the resource is changed or deleted).

This information is from the resource itself, and therefore might be sensitive.
Sensitive data **must** be encrypted before being used in a page token.
Therefore, the token also includes the date it was created, to allow for the
potential need to rotate the encryption key.

This yields the following interface, which **may** be base64 encoded and used
as a page token:

```typescript
interface PageTokenSecrets {
  // The ID of the most recent resource returned.
  lastId: string;

  // Any index data needed, generally 1:1 with the fields used for ordering.
  indexData: Buffer[];

  // When this token was minted.
  createTime: Date;
}
```

**Note:** This section does not preclude alternative page token implementations
provided they conform to the guidelines discussed in this document.
