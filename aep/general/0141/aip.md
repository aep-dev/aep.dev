# Quantities

Many services need to represent a discrete quantity of items (number of bytes,
number of miles, number of nodes, etc.).

## Guidance

Quantities with a clear unit of measurement (such as bytes, miles, and so on)
**must** include the unit of measurement as the suffix. When appropriate and
unambiguous, units **should** use generally accepted abbreviations (for
example, `distance_km` rather than `distance_kilometers`).

```typescript
// A representation of a non-stop air route.
interface Route {
  // The airport where the route begins.
  origin: string;

  // The destination airport.
  destination: string;

  // The distance between the origin and destination airports.
  // This value is also used to determine the credited frequent flyer miles.
  distance_miles: number;
}
```

If the quantity is a number of items (for example, the number of nodes in a
cluster), then the field **should** use the suffix `_count` (**not** the prefix
`num_`):

```typescript
// A cluster of individual nodes.
interface Cluster {
  // The number of nodes in the cluster.
  node_count: number;
}
```

**Note:** Fields **must not** use unsigned integer types, because many
programming languages and systems do not support them well.

### Specialized messages

It is sometimes useful to create a message that represents a particular
quantity. This is particularly valuable in two situations.

- Grouping two or more individual quantities together.
- Representing a common concept where the unit of measurement may itself vary.

Consider the example of money, which could need to do both of these:

```typescript
// A representation of an amount of money, in an arbitrary currency.
interface Money {
  // The 3-letter currency code defined in ISO 4217.
  currency_code: string;

  // The whole units of the amount.
  // For example if `currency_code` is "USD", then 1 unit is one US dollar.
  units: bigint;

  // Number of nano (10^-9) units of the amount.
  // The value must be between -999,999,999 and +999,999,999 inclusive.
  // If `units` is positive, `nanos` must be positive or zero.
  // If `units` is zero, `nanos` can be positive, zero, or negative.
  // If `units` is negative, `nanos` must be negative or zero.
  // For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  nanos: number;
}
```

APIs **may** create structs to represent quantities when appropriate. When
using these structs as fields, APIs **should** use the name of the struct as
the suffix for the field name if it makes intuitive sense to do so.

## Changelog

- **2019-09-13**: Added the prohibition on unsigned types.
