# Unicode

APIs should be consistent on how they explain, limit, and bill for string
values and their encodings. This ranges from little ambiguities (like fields
"limited to 1024 characters") all the way to billing confusion (are names and
values of properties in Datastore billed based on characters or bytes?).

In general, if limits are measured in bytes, we are discriminating against
non-ASCII text since it takes up more space. On the other hand, if limits are
measured in "characters", this is ambiguous about whether those are Unicode
"code points", "code units" for a particular encoding (e.g. UTF-8 or UTF-16),
"graphemes", or "grapheme clusters".

## Unicode primer

Character encoding tends to be an area we often gloss over, so a quick primer:

- Strings are just sequences of bytes that represent text according to some
  encoding format.
- When we talk about **characters**, we sometimes mean Unicode **code points**,
  which are 21-bit unsigned integers `0` through `0x10FFFF`.
- Other times we might mean **grapheme clusters**, which are _perceived_ as
  single characters but may be composed of multiple code points. For example,
  `á` can be represented as the single code point `U+00E1` or as a sequence of
  `U+0061` followed by `U+0301` (the letter `a`, then a combining acute
  accent).
- Protocol buffers uses **UTF-8** ("Unicode Transformation Format") which is a
  variable-length encoding scheme that represents each code point as a sequence
  of 1 to 4 single-byte **code units**.

## Guidance

### Character definition

**TL;DR:** In our APIs, "character" means "Unicode code point".

In API documentation (e.g., API reference documents, blog posts, marketing
documentation, billing explanations, etc), "character" **must** be defined as a
Unicode code point.

### Length units

**TL;DR:** Set size limits in "characters" (as defined above).

All string field length limits defined in the API **must** be measured and
enforced in characters as defined above. This means that there is an underlying
maximum limit of (`4 * characters`) bytes, though this limit will only be hit
when using exclusively characters that consist of 4 UTF-8 code units (32 bits).

If you use a database system (e.g. Spanner) which allows you to define a limit
in characters, it is safe to assume that this byte-defined requirement is
handled by the underlying storage system.

### Billing units

APIs **may** use either code points or bytes (using the UTF-8 encoding) as the
unit for billing or quota measurement (e.g., Cloud Translation chooses to use
characters). If an API does not define this, the assumption is that the unit of
billing is characters (e.g., $0.01 _per character_, not $0.01 _per byte_).

### Unique identifiers

**TL;DR:** Unique identifiers **should** limit to ASCII, generally only
letters, numbers, hyphens, and underscores. Additionally, unique identifiers
**should** start with a letter, **should** end in either a letter or number,
and **should not** have hyphens or underscores that are next to other hyphens
or underscores.

Strings used as unique identifiers **should** limit inputs to ASCII characters,
typically letters, numbers, hyphens, and underscores
(`[a-zA-Z][a-zA-Z0-9_-]*`). This ensures that there are never accidental
collisions due to normalization. If an API decides to allow all valid Unicode
characters in unique identifiers, the API **must** reject any inputs that are
not in Normalization Form C.

Unique identifiers **should** use a maximum length of 64 characters, though
this limit may be expanded as necessary. 64 characters should be sufficient for
most purposes as even UUIDs only require 36 characters.

### Normalization

**TL;DR:** Unicode values **should** be stored in [Normalization Form C][].

Values **should** always be normalized into Normalization Form C. Unique
identifiers **must** always be stored in Normalization Form C (see the next
section).

Imagine we're dealing with Spanish input "estar<strong>é</strong>" (the
accented part will be bolded throughout). This text has 6 grapheme clusters,
and can be represented by two distinct sequences of Unicode code points:

- Using 6 code points: `U+0065` `U+0073` `U+0074` `U+0061` `U+0072`
  **`U+00E9`**
- Using 7 code points: `U+0065` `U+0073` `U+0074` `U+0061` `U+0072` **`U+0065`
  `U+0301`**

Further, when encoding to UTF-8, these code points have two different
serialized representations:

- Using 7 code-units (7 bytes): `0x65` `0x73` `0x74` `0x61` `0x72` **`0xC3`
  `0xA9`**
- Using 8 code-units (8 bytes): `0x65` `0x73` `0x74` `0x61` `0x72` **`0x65`
  `0xCC` `0x81`**

To avoid this discrepancy in size (both code units and code points), use
[Normalization Form C][] which provides a canonical representation for strings.

[normalization form c]: https://unicode.org/reports/tr15/

### Uniqueness

**TL;DR:** Unicode values **must** be normalized to [Normalization Form C][]
before checking uniqueness.

For the purposes of unique identification (e.g., `name`, `id`, or `parent`),
the value **must** be normalized into [Normalization Form C][] (which happens
to be the most compact). Otherwise we may have what is essentially "the same
string" used to identify two entirely different resources.

In our example above, there are two ways of representing what is essentially
the same text. This raises the question about whether the two representations
should be treated as equivalent or not. In other words, if someone were to use
both of those byte sequences in a string field that acts as a unique
identifier, would it violate a uniqueness constraint?

The W3C recommends using Normalization Form C for all content moving across the
internet. It is the most compact normalized form on Unicode text, and avoids
most interoperability problems. If we were to treat two Unicode byte sequences
as different when they have the same representation in NFC, we'd be required to
reply to possible "Get" requests with content that is **not** in normalized
form. Since that is definitely unacceptable, we **must** treat the two as
identical by transforming any incoming string data into Normalized Form C or
rejecting identifiers not in the normalized form.

There is some debate about whether we should view strings as sequences of code
points encoded into byte sequences (leading to uniqueness determined based on
the byte-representation of said string) or to interpret strings as a higher
level abstraction having many different possible byte-representations. The
stance taken here is that we already have a field type for handling that:
`bytes`. Fields of type `string` already express an opinion of the validity of
an input (it must be valid UTF-8). As a result, treating two inputs that have
identical normalized forms as different due to their underlying byte
representation seems to go against the original intent of the `string` type.
This distinction typically doesn't matter for strings that are opaque to our
services (e.g., `description` or `display_name`), however when we rely on
strings to uniquely identify resources, we are forced to take a stance.

Put differently, our goal is to allow someone with text in any encoding (ASCII,
UTF-16, UTF-32, etc) to interact with our APIs without a lot of "gotchas".

## References

- [Unicode normalization forms](https://unicode.org/reports/tr15/)
- [Datastore pricing "name and value of each property"](https://cloud.google.com/datastore/pricing)
  doesn't clarify this.
- [Natural Language pricing](https://cloud.google.com/natural-language/pricing)
  uses charges based on UTF-8 code points rather than code units.
- [Text matching and normalization](https://sites.google.com/a/google.com/intl-eng/apis/matching?pli=1)
