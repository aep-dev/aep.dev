# Field names

Naming fields in a way that is intuitive to users can often be one of the most
challenging aspects of designing an API. This is true for many reasons; often a
field name that seems entirely intuitive to the author can baffle a reader.

Additionally, users rarely use only one API; they use many APIs together. As a
result, a single company using the same name to mean different things (or
different names to mean the same thing) can often cause unnecessary confusion,
because users can no longer take what they've already learned from one API and
apply that to another.

In short, APIs are easiest to understand when field names are simple,
intuitive, and consistent with one another.

## Guidance

Field names **should** be in correct American English.

Field names **should** clearly and precisely communicate the concept being
presented and avoid overly general names that are ambiguous. That said, field
names **should** avoid including unnecessary words. In particular, avoid
including adjectives that always apply and add little cognitive value. For
example, a `proxy_settings` field might be as helpful as
`shared_proxy_settings` if there is no unshared variant.

### Case

Field definitions **must** use the appropriate case for the IDL being used
(`camelCase` for TypeScript, `lower_snake_case` for protocol buffers, and so
on). These names **should** be mapped to an appropriate naming convention in
JSON and in generated code.

Additionally, each word in the field **must not** begin with a number, because
it creates ambiguity when converting between snake case and camel case.
Similarly, snake case fields **must not** contain leading, trailing, or
adjacent underscores.

### Consistency

APIs **should** endeavor to use the same name for the same concept and
different names for different concepts wherever possible. This includes names
across multiple APIs, in particular if those APIs are likely to be used
together.

### Array fields

Array fields **must** use the proper plural form, such as `books` or `authors`.
On the other hand, non-array fields **should** use the singular form such as
`book` or `author`.

### Prepositions

Field names **should not** include prepositions (such as "with", "for", "at",
"by", etc). For example:

- `error_reason` (**not** `reason_for_error`)
- `author` (**not** `written_by`)

There are several reasons for this:

- It is easier for field names to match more often when following this
  convention.
- Spoken languages vary widely in their conjugation rules, and avoiding
  prepositions tends to lead to more natural translation for many speakers for
  whom English is a secondary language (generally at no cost to Anglophones).
- Additionally, prepositions in field names may also indicate a design concern,
  such as an overly-restrictive field or a sub-optimal data type. This is
  particularly true regarding "with": a field named `book_with_publisher`
  likely indicates that the book resource may be improperly structured and
  worth redesigning.

**Note:** The word "per" is an exception to this rule, particularly in two
cases. Often "per" is part of a unit (e.g. "miles per hour"), in which case the
preposition must be present to accurately convey the unit. Additionally, "per"
is often appropriate in reporting scenarios (e.g. "nodes per instance" or
"failures per hour").

### Mood

Field names **should** use the imperative mood ("enable", "import") when the
user is deciding what to do, and the declarative mood ("enabled", "imported")
when reporting on the state of the system. If the same field is used for both
purposes, the service **should** use the imperative mood.

### Adjectives

For consistency, field names that contain both a noun and an adjective
**should** place the adjective _before_ the noun. For example:

- `collected_items` (**not** `items_collected`)
- `imported_objects` (**not** `objects_imported`)

### Booleans

Boolean fields **should** omit the prefix "is". For example:

- `disabled` (**not** `is_disabled`)
- `required` (**not** `is_required`)

**Note:** Field names that would otherwise be [reserved words](#reserved-words)
are an exception to this rule. For example, `is_new` (**not** `new`).

### String vs. bytes

When there is a need to send binary contents over the wire, the contents
**should** be base64-encoded and sent in a `string` field. Services **must**
accept base64 encoding using the normal base64 alphabet, and **may** also
accept URL-safe base64.

**Note:** In IDLs that support `bytes` fields (such as protocol buffers),
prefer the IDL's `bytes` implementation over asking the user to base64 encode
and decode manually.

### URIs

Field names representing URLs or URIs **should** use `url` for fully-qualified
URLs, and URIs for URI segment. Field names **may** use a prefix in front of
`url` or `uri` as appropriate.

### Reserved words

Field names **should** avoid using names that are likely to conflict with
keywords in common programming languages, such as `new`, `class`, `function`,
`import`, etc. Reserved keywords can cause hardship for developers using the
API in that language.

### Conflicts

Structs **should not** include a field with the same name as the enclosing
structs (ignoring case transformations). This tends to cause conflicts when
generating code.

### Display names

Many resources have a human-readable name, often used for display in UI. This
field **must** generally be called `display_name`, and **must not** have a
uniqueness requirement.

If an entity has an official, formal name (such as a company name or the title
of a book), an API **may** use `title` as the field name instead. The `title`
field **should not** have a uniqueness requirement.

## Further reading

- For naming resource fields, see AIP-122.
- For naming fields representing quantities, see AIP-141.
- For naming fields representing time, see AIP-142.
