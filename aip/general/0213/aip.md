# Common components

In general, APIs should be designed to be self-contained. APIs generally need
to be able to move forward independently of one another, and mutual
dependencies can cause downstream APIs to be forced into taking major version
changes or even lead to dependency conflicts.

However, there are also cases where common structures are valuable, especially
where a concept is well-known and it is sufficiently clear that it will not
change. Common components serve this use case. This AIP defines those common
components.

## Guidance

The public representation of APIs **should** be self-contained (for protocol
buffers, this means that all API protos used by the API originate in the same
proto `package`), except for common components, which **may** be used freely in
any API.

An API **must not** define a set of API-specific common components which live
outside of its versioning structure. This prevents independent movement of
particular versions and also causes problems for client libraries in many
languages that compile the proto messages into classes.

An API **should not** define alternative representations of any of the existing
common components described below, even within its versioning structure.

## Existing common components

The common components, which public-facing APIs **may** safely depend on, are
defined canonically in the [AIP type][] repository. These include READMEs with
guidance for each type, and -- when applicable -- definitions of type schemas,
in both JSON Schema and protobuf formats. The protobufs are also published to
the Buf Schema Sepository at [`buf.build/aip/type`][buf], and the JSON schemas
are published to the [JSON Schema Store][] with names of the form
`aip-type-money`.

While the [AIP type][] repository is canonical and has precedence over this
list, some of the common components defined there include representations of
the following concepts:

### API design patterns

- `StatusMonitor` / `Operation`: Represents the status of a long-running
  request (see [AIP-151][] for details).

#### gRPC-specific API design patterns

- [`google.api.*`][api] (but _not_ subpackages of `google.api`): Annotations
  useful for gRPC/JSON transcoding, supported by frameworks including .NET 7.

- [`google.rpc.*`][rpc]: A small number of components related to gRPC
  request/response status and errors.

<!-- prettier-ignore-start -->
[api]: https://github.com/googleapis/googleapis/tree/master/google/api
[rpc]: https://github.com/googleapis/googleapis/tree/master/google/rpc
<!-- prettier-ignore-end -->

### General common types

- `Color`: RGB or RGBA colors.

- `Fraction`: A numeric fraction.

- `LatLng`: Geographic coordinates.

- `Money`: An amount of money in a given currency.

- `PhoneNumber`: A phone number in most countries.

- `PostalAddress`: Postal addresses in most countries.

- `Quaternion`: A geometric quaternion.

### Date- and time-related types

- `Date`: A calendar date, with no time or time zone component.

- `DateTime`: A calendar date and wall-clock time, with optional time zone or
  UTC offset information.

- `DayOfWeek`: An enumeration representing the day of the week.

- `Duration`: A duration with nanosecond-level precision.

- `Interval`: An interval between two timestamps.

- `Month`: An enumeration representing the Gregorian month.

- `TimeOfDay`: Wall-clock time, with no date or time zone component.

- `Timestamp`: A timestamp with nanosecond-level precision.

### Protobuf types

The [`google.protobuf`][protobuf] package is somewhat special in that it is
shipped with protocol buffers itself, rather than with API tooling. The
Well-Known Types defined in this package should always be used when
appropriate, and the [AIP type][] repo **does not** define any protos for these
types, even when it defines a corresponding JSON Schema. These include:

- [`google.protobuf.Duration`][duration]: Durations, with nanosecond-level
  precision. The protobuf runtime provides helper functions to convert to and
  from language-native duration objects where applicable (such as Python's
  [`timedelta`][timedelta]).
- [`google.protobuf.Timestamp`][timestamp]: Timestamps, with nanosecond-level
  precision. The protobuf runtime provides helper functions in most languages
  to convert to and from language-native timestamp objects (such as Python's
  [`datetime`][datetime]).

`google.protobuf` also provides some useful components that correspond to JSON
primitives (and so have no representation at all in the [AIP type][] repo),
namely:

- [`google.protobuf.Value`][struct]: An arbitrary JSON value. The protobuf
  runtime provides helper functions in most languages to convert `Value`
  objects to and from JSON.
- [`google.protobuf.Struct`][struct]: JSON-like structures (a dictionary of
  primitives, lists, and other dictionaries). The protobuf runtime provides
  helper functions in most languages to convert `Struct` objects to and from
  JSON.

`google.protobuf.Struct` and `google.protobuf.Value` are designated common
components by this AIP; proto-based APIs **should** use them when appropriate.

<!-- prettier-ignore-start -->
[datetime]: https://docs.python.org/3/library/datetime.html#datetime.datetime
[duration]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/duration.proto
[protobuf]: https://github.com/protocolbuffers/protobuf/tree/main/src/google/protobuf
[struct]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/struct.proto
[timedelta]: https://docs.python.org/3/library/datetime.html#datetime.timedelta
[timestamp]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/timestamp.proto
<!-- prettier-ignore-end -->

## Appendix: Adding to common components

Occasionally, it may be useful to add protos to these packages or to add to the
list of common components. In order to do this, [open an issue][] on the [AIP
type][] repository in GitHub.

However, some general guidelines are worth noting for this:

- Schemas **should** only be granted common component status if we are certain
  that they will never change (at all -- even in ways that would normally be
  considered backwards compatible). Common components are generally not
  versioned, and it must be the case that we can rely on the component to be a
  complete and accurate representation indefinitely.
- Schemas must be applicable to a significant number of APIs for consideration
  as common components.
- Even after a common component is added, APIs using local versions **must**
  continue to do so until they go to the next major version.

In the event that you believe adding a common component is appropriate, please
[open an issue][].

[open an issue]: https://github.com/aip-dev/type/issues
[aip type]: https://github.com/aip-dev/type
[json schema store]: https://www.schemastore.org/json/
[aip-151]: ../0151
[buf]: https://buf.build/aip/type
