# Notes:
This file is just some brainstorming from an early session working on this project.  All of the types were prefaced with Late at that point of the design.

# Options

- iterations: how many exemplars to check; defaults to 1000
- max_time: if set, how many seconds to check exemplars for, rather than a count
- max_shrink_attempts: how many times to try simplifying a failing exemplar, defaults to 1000
- max_shrink_time: if set, how long to spend shrinking a failing exemplar, rather than a count.


# Thoughts

- need a way to specify the seed from the command line to re-create failing exemplars
  but default to a random seed.

# Types

## LateMap

Complex Type

### Options

- keys: allows specifying a LateType to generate keys
- values: same, but for keys
- length: number of keys to generate.  range options like integer? reuse integer?

## LateList

Complex Type

### Options

- values: specify a LateType for the values
- of: alias for values
- length: specify a LateType? maybe just a range?

## LateTuple

Complex Type, just a thin wrapper around LateList (can we also do this for Map?)

### Options

- Same as LateList

## LateInteger

### Options

- between: `%Range{}` specifies inclusive
- in: alias for between
- above: exclusive lower bound
- below: exclusive upper bound
- positive: shortcut to above: 0
- negative: shortcut to below: 0

### Notes

- need to figure out just how big to make them
- shrink on half digits and half value
- what's the preposition for above/below, but inclusive?

## LateFloat

### Options

- all from integer
- precision

## LateAtom

### Options

- alpha
- alphanumeric
- numeric
- length
- lowercase
- spaces
- special characters
- normal looking

## LateString

### Options

- all from LateAtom

## LateChoice

### Options

- from: specify a list, could be of LateTypes, or statics

## LateBinary

Need a sweet syntax for this; maybe worth a macro:

LateBinary <<LateInteger.between(0, 0xff)::8 >>
### Options

- length
-
