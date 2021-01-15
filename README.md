# Xon: A Superset of JSON that supports `Time` values

Xon (pronounced *//zoːn//*) is a superset of JSON that supports `Time` (and `DateTime`) values.

## Encoding

If none of the values to be encoded is a `Time` value, Xon returns the exact same output as a standard JSON encoder.

If any of the values to be encoded is a `Time` value, Xon visits all values and:
* If the value is a `Time` it encodes it to a string using ISO 8601 and prefixes it with `t:`.
* If the value is a string it prefixes it with `:` to avoid ambiguity.

Then it passes the resulting object through a standard JSON encoder, and prefixes the output with a preamble (`!:`).

## Decoding

If the preamble is not detected, a standard JSON decoder is used.

If the preamble is detected, it is stripped, and the remaining string passed through a standard JSON decoder, then all string values are visited:
* If the value starts with `:`, the `:` is stripped.
* If the value starts with `t:`, the `t:` is stripped, and the remainder of the string parsed as an ISO 8601 time.

## Usage

You can add it to your Gemfile with:

```
gem 'xon'
```

Run `bundle` to install it.

Using Xon is similar to using JSON:

```
require 'xon'

Xon.dump({}) # => "{}"
Xon.load("{}") # => {}

Xon.dump(Time.now) # => '!:"t:2020-12-01T13:37:00+02:00"'
Xon.load('!:"t:2020-12-01T13:37:00+02:00"') # Returns a Time object.
```

## Examples

### No `Time` Values

```
Xon.dump({"hello": "1", "world": 2})
```

Returns:

```
{"hello":"1","world":2}
```

### With `Time` Values

```
t = Time.parse("2020-12-01T13:37:00+02:00")
Xon.dump({"hello": t, "world": 2})
```

Returns:

```
!:{"hello":"t:2020-12-01T13:37:00+02:00","world":2}
```
