# Decimal

The `Decimal` type represents a decimal numeric value. It uses a non-floating
point representation in order to avoid precision errors.

## Schema

A `Decimal` represents a decimal number in a form similar to scientific
notation.

It has two fields:

- The `significand` field is a 64-bit integer representing the significant
  digits of the number.
- The `exponent` field is a 32-bit integer represesnting the position of the
  deicmal point within the value of the `significand` field; it is the power of
  ten to which `significand` should be raised.

  When the exponent is `0`, the value of the `Decimal` is simply the value of
  `significand`.

  When the exponent is greater than 0, represents the number of trailing zeroes
  after the significant digits.

  When the exponent is less than 0, represents how many of the significant
  digits (and implicit leading zeroes, as needed) come after the decimal point.

The general formula for converting a `Decimal` to its numeric value is
`significant * 10^exponent`, where `*` represents multplication and `^`
represents exponentiation.

Note: The range of a Decmial exceeds that of a JSON `number` (double), as well
as that of a `decimal64`.

## Examples

- 17 === `{significand: 17, exponent: 0}`
- -0.005 === `{significand: -5, exponent: -3}`
- 33.5 million === `{significand: 335, exponent: 5}`
- 11/8 === 1.375 === `{significand: 1375, exponent: -3}`
