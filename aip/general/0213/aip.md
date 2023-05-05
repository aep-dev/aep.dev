# Common components

In general, APIs should be designed to be self-contained. APIs generally need
to be able to move forward independently of one another, and mutual
dependencies can cause downstream APIs to be forced into taking major version
changes or even lead to dependency conflicts.

However, there are also cases where common structures are valuable, especially
where a concept is well-known and it is sufficiently clear that it will not
change. Having a single representation of these common structures is valuable
because it avoids disrepancies between APIs in things like how dates or
monetary values are represented. It also enables shared libraries for common
operations, such as basic arithmetic on monetary values.

Common components serve this use case.

## Guidance

The public representation of APIs **should** be self-contained (for protocol
buffers, this means that all API protos used by the API originate in the same
proto `package`), except for common components, which **may** be used freely in
any API.

An API **must not** define a set of API-specific common components which live
outside of its versioning structure. This prevents independent movement of
particular versions and also causes problems for client libraries in many
languages that compile protobuf messages into classes.

An API **should not** define alternative representations of any of the existing
common components described below, even within its versioning structure.

## Existing common components

The common components, which public-facing APIs **may** safely depend on, are
defined canonically in the [AIP common components][] repository. These include
READMEs with canonical definitions for each component, and -- when applicable
-- implementations of these definitions, in both JSON Schema and protobuf
formats. The protobufs are also published to the Buf Schema Sepository at
[`buf.build/aip/common`][buf], and the JSON schemas are published to the [JSON
Schema Store][] with names beginning with `aip-`, for example `aip-type-money`
or `aip-longrunning-operation`.

While the [AIP common components][] repository is canonical and takes
precedence over this list, some of the common components defined there include
representations of the following concepts:

### API design patterns

- `StatusMonitor` / `Operation`: Represents the status of a long-running
  request (see [AIP-151][] for details).

#### gRPC-specific API design patterns

- [`google.api.*`][api] (but _not_ subpackages of `google.api`): Annotations
  useful for gRPC/JSON transcoding, supported by frameworks including .NET 7.

- [`google.rpc.*`][rpc]: A small number of components related to gRPC
  request/response status and errors.

### Common types

This section provides examples for the sake of illustration; it may not be
exhaustive. The [AIP common components][] repo is canonical.

#### General common types

- [`Color`][color]: RGB or RGBA colors.

- [`Fraction`][fraction]: A numeric fraction.

- [`LatLng`][lat_lng]: Geographic coordinates.

- [`Money`][money]: An amount of money in a given currency.

- [`PhoneNumber`][phone_number]: A phone number in most countries.

- [`PostalAddress`][postal_address]: Postal addresses in most countries.

- [`Quaternion`][quaternion]: A geometric quaternion.

#### Date- and time-related types

- [`Date`][date]: A calendar date, with no time or time zone component.

- [`DateTime`][date_time]: A calendar date and wall-clock time, with optional
  time zone or UTC offset information.

- [`DayOfWeek`][day_of_week]: An enumeration representing the day of the week.

- [`Duration`][duration]: A duration with nanosecond-level precision.

- [`Interval`][interval]: An interval between two timestamps.

- [`Month`][month]: An enumeration representing the Gregorian month.

- [`TimeOfDay`][time_of_day]: Wall-clock time, with no date or time zone
  component.

- [`Timestamp`][timestamp]: A timestamp with nanosecond-level precision.

#### Protobuf types

The [`google.protobuf`][protobuf] package is shipped with protocol buffers
itself, rather than with API tooling. The Well-Known Types defined in this
package should always be used when appropriate, and the [AIP common
components][] repo does not define any protos for these types, even when it
defines a corresponding JSON Schema. These include:

- [`google.protobuf.Duration`][duration]: Durations, with nanosecond-level
  precision. The protobuf runtime provides helper functions to convert to and
  from language-native duration objects where applicable (such as Python's
  [`timedelta`][timedelta]).
- [`google.protobuf.Timestamp`][timestamp]: Timestamps, with nanosecond-level
  precision. The protobuf runtime provides helper functions in most languages
  to convert to and from language-native timestamp objects (such as Python's
  [`datetime`][datetime]).

`google.protobuf` also provides some useful components that correspond to JSON
primitives (and so have no representation at all in the [AIP common
components][] repo), namely:

- [`google.protobuf.Value`][struct]: An arbitrary JSON value. The protobuf
  runtime provides helper functions in most languages to convert `Value`
  objects to and from JSON.
- [`google.protobuf.Struct`][struct]: JSON-like structures (a dictionary of
  primitives, lists, and other dictionaries). The protobuf runtime provides
  helper functions in most languages to convert `Struct` objects to and from
  JSON.

`google.protobuf.Struct` and `google.protobuf.Value` are designated common
components by this AIP; proto-based APIs **should** use them when representing
arbitrary JSON-like structures.

## Libraries for common types

For the common components in the `aip.type` namespace, which represent common
data types, the [AIP common components][] repo may contain canonical libraries
in a number of languages. These libraries are designed to be idiomatic in a
given language, and should feel similar to using the language's standard
libraries. They should provide basic functionality like adding two `Money`
values, or determining if one `Date` comes before another.

When a language already has a standard library representation of a common type
(such as Python's `datetime` for the `Timestamp` type), there may instead be a
library for converting the JSON or protobuf representation to the standard
library representation.

If a library you want does not exist, and you want to contribute one, please
[open an issue][] on the [AIP common components][] repository in GitHub.

## Appendix: Adding to common components

Occasionally, it may be useful to add protos to these packages or to add to the
list of common components. In order to do this, [open an issue][] on the [AIP
common components][] repository in GitHub.

However, some general guidelines are worth noting for this:

- Schemas **should** only be granted common component status if it is certain
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

<!-- prettier-ignore-start -->
[api]: https://github.com/googleapis/googleapis/tree/master/google/api
[rpc]: https://github.com/googleapis/googleapis/tree/master/google/rpc

[color]: https://github.com/aip-dev/common-components/tree/master/aip/type/color
[fraction]: https://github.com/aip-dev/common-components/tree/master/aip/type/fraction
[lat_lng]: https://github.com/aip-dev/common-components/tree/master/aip/type/lat_lng
[money]: https://github.com/aip-dev/common-components/tree/master/aip/type/money
[phone_number]: https://github.com/aip-dev/common-components/tree/master/aip/type/phone_number
[postal_address]: https://github.com/aip-dev/common-components/tree/master/aip/type/postal_address
[quaternion]: https://github.com/aip-dev/common-components/tree/master/aip/type/quaternion

[date]: https://github.com/aip-dev/common-components/tree/master/aip/type/date
[date_time]: https://github.com/aip-dev/common-components/tree/master/aip/type/date_time
[day_of_week]: https://github.com/aip-dev/common-components/tree/master/aip/type/day_of_week
[duration]: https://github.com/aip-dev/common-components/tree/master/aip/type/duration
[interval]: https://github.com/aip-dev/common-components/tree/master/aip/type/interval
[month]: https://github.com/aip-dev/common-components/tree/master/aip/type/month
[time_of_day]: https://github.com/aip-dev/common-components/tree/master/aip/type/time_of_day
[timestamp]: https://github.com/aip-dev/common-components/tree/master/aip/type/timestamp

[datetime]: https://docs.python.org/3/library/datetime.html#datetime.datetime
[duration]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/duration.proto
[protobuf]: https://github.com/protocolbuffers/protobuf/tree/main/src/google/protobuf
[struct]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/struct.proto
[timedelta]: https://docs.python.org/3/library/datetime.html#datetime.timedelta
[timestamp]: https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/timestamp.proto

[open an issue]: https://github.com/aip-dev/common-components/issues
[aip common components]: https://github.com/aip-dev/common-components
[json schema store]: https://www.schemastore.org/json/
[aip-151]: ../0151
[buf]: https://buf.build/aip/type
<!-- prettier-ignore-end -->
