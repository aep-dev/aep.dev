# Errors

Error handling is an important part of designing simple and intuitive APIs.
Consistent error handling allows developers to know how to expect to receive
errors, and to reduce boilerplate by having common error-handling logic, rather
than being expected to constantly add verbose error handling everywhere.

## Guidance

Services **must** clearly distinguish successful responses from error responses
by using appropriate HTTP codes:
- Informational responses **must** use HTTP status codes between 100 and 199.
- Successful responses **must** use HTTP status codes between 200 and 399.
- Errors indicating a problem with the user's request **must** use HTTP status
  codes between 400 and 499.
- Errors indicating a problem with the server's handling of an valid request
  **must** use HTTP status codes between 500 and 599.

### Structure

Error responses **should** conform to the following interface:

```typescript
interface Error {
  //A machine-readable code indicating the type of error (like `name_too_long`). This value is parseable for programmatic error handling.
  code: string;

  //A human readable description of the problem. Should not change from occurrence to occurrence (except for localization).
  title?: string

  //The HTTP status code between 100 and 500
  status?: integer

  //A human-readable explanation specific to this occurrence of the problem
  detail?: string

  //A unique identifier that identifies the specific occurrence of the problem. Can be provided to the API owner for debugging purposes.
  id?: string
}
```

- The `title` field is intended for consumption by humans, and therefore
  **may** change, even within a single version.
- The `code` field is intended to have code written against it, and therefore
  **must not** change. Values for this field should be 0-63 characters, and use
  only lower-case letters, numbers, and the `-` character.



### Messages

Error messages **should** help a reasonably technical user understand and
resolve the issue, and **should not** assume that the user is an expert in the
particular API. Additionally, error messages **must not** assume that the user
will know anything about its underlying implementation.

Error messages **should** be brief but actionable. Any extra information
**should** be provided in a `details` field. If even more information is
necessary, the service **should** provide a link where a reader can get more
information or ask questions to help resolve the issue.

### Localization

Error messages **must** be in American English. If a localized error message is
also required, the service **should** provide the following structure within
its `details`:

```typescript
interface LocalizedMessage {
  // The locale for this error message.
  // Follows the spec defined at http://www.rfc-editor.org/rfc/bcp/bcp47.txt.
  // Examples: 'en-US', 'de-CH', 'es-MX'
  locale: string;

  // The localized error message in the above locale.
  message: string;
}
```

### Partial errors

APIs **should not** support partial errors. Partial errors add significant
complexity for users, because they usually sidestep the use of error codes, or
move those error codes into the response message, where the user must write
specialized error handling logic to address the problem.

However, occasionally partial errors are unavoidable, particularly in bulk
operations where it would be hostile to users to fail an entire large request
because of a problem with a single entry.

Methods that require partial errors **should** use long-running operations (as
described in AIP-151), and the method **should** put partial failure
information in the metadata message. The errors themselves **must** still be
represented with an error object.

## Further reading

- For which error codes to retry, see AIP-194.

## Changelog

- **2020-09-02**: Refactored errors AIP to be more generic.
- **2020-01-22**: Added a reference to the `ErrorInfo` message in gRPC.
- **2019-10-14**: Added guidance restricting error message mutability to if
  there is a machine-readable identifier present.
- **2019-09-23**: Added guidance about error message strings being able to
  change.
