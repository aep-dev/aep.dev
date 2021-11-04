# Time and duration

Many services need to represent the concepts surrounding time. Representing
time can be challenging due to the intricacies of calendars and time zones, as
well as the fact that common exchange formats (such as JSON) lack a native
concept of time.

## Guidance

Fields representing time **should** use a `string` field with values conforming
to [RFC 3339][], such as `2012-04-21T15:00:00Z`.

Services **should** use IDL-specific timestamps or format indicators where
applicable (such as [`google.protobuf.Timestamp`][timestamp] in protocol
buffers, or `format: date-time` in OpenAPI) provided that the service converts
values to RFC 3339 timestamp strings in JSON.

### Timestamps

Fields that represent an absolute point in time (independent of any time zone
or calendar) **should** use a `string` field with RFC 3339 values, and
**should** send values in UTC, with the `Z` time zone explicitly included.

These fields **should** have names ending in `_time`, such as `create_time` or
`update_time`. For array fields, the names **should** end in `_times` instead.

Many timestamp fields refer to an activity (for example, `create_time` refers
to when the applicable resource was created). For these, the field **should**
be named with the `{root_word}_time` form. For example, if a book is being
published, the field storing the time when this happens would use the root form
of the verb "to publish" ("publish"), resulting in a field called
`publish_time`. Fields **should not** be named using the past tense (such as
`published_time`, `created_time` or `last_updated_time`).

When accepting timestamps as input, services **should** canonicalize the
timestamp into UTC, and return values in UTC.

### Durations

Fields that represent a span between two points in time (independent of any
time zone or calendar) **should** use an `int` field if there is a single
canonical unit (for example, `ttl_seconds` for an expiring resource, or
`offset_seconds` for position in a video).

**Note:** A `float` field **may** be used if fractional seconds are needed.
However, only fractional seconds are permitted; other fractional units (such as
hours or days) **must not** be used.

If there is no canonical unit, the service **should** use a `string` field with
[ISO 8601][] duration values, such as `P3Y6M4DT12H30M5S`. The field name
**should** end with `_duration`. Designators for zero values **may** be omitted
in accordance with ISO 8601 (for example: `PT12H` is sufficient to represent
"12 hours"), but at least one designator **must** be present (therefore, a zero
duration is `PT0S` or `P0D`).

Services **should** use IDL-specific durations where applicable (such as
[`google.protobuf.Duration`][duration] in protocol buffers) provided that the
service converts values to ISO 8601 duration strings in JSON.

### Fractional seconds

Services **may** support fractional seconds for both timestamps and durations,
but **should not** support precision more granular than the nanosecond.
Services **may** also limit the supported precision, and **may** _truncate_
values received from the user to the supported precision.

**Note:** Truncation is recommended rather than rounding because rounding to
the nearest second has the potential to change day, month, year, etc., which is
surprisingly significant.

### Civil dates and times

Fields that represent a calendar date or wall-clock time **should** use partial
ISO 8601 strings.

Fields representing civil dates **should** have names ending in `_date`, while
fields representing civil times or datetimes **should** have names ending in
`_time`.

### Recurring time

A service that needs to document a recurring event **should** use cronspec if
cronspec is able to support the service's use case.

### Compatibility

Occasionally, APIs are unable to use RFC 3339 strings for legacy or
compatibility reasons. For example, an API may conform to a separate
specification that mandates that timestamps be Unix timestamp integers.

In these situations, fields **may** use other types. If possible, the following
naming conventions apply:

- Unix timestamps **should** use a `unix_time` suffix.
  - Multipliers of Unix time (such as milliseconds) **should not** be used; if
    they are unavoidable, the field name **should** use both `unix_time` and
    the unit, such as `unix_time_millis`.
- For other integers, include the meaning (examples: `time`, `duration`,
  `delay`, `latency`) **and** the unit of measurement (valid values: `seconds`,
  `millis`, `micros`, `nanos`) as a final suffix. For example,
  `send_time_millis`.
- For strings, include the meaning (examples: `time`, `duration`, `delay`,
  `latency`) but no unit suffix.

In all cases, clearly document the expected format, and the rationale for its
use.

<!-- prettier-ignore-start -->
[duration]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/duration.proto
[iso 8601]: https://www.iso.org/iso-8601-date-and-time-format.html
[rfc 3339]: https://datatracker.ietf.org/doc/html/rfc3339
[timestamp]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/timestamp.proto
<!-- prettier-ignore-end -->
