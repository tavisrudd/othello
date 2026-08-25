# PRS structural classifier

This is the C969 implementation crate.  Its current executable slice provides:

- exact polynomial-basis arithmetic over explicitly represented finite fields;
- projective syndrome normalization;
- both affine and infinity locator charts;
- increasing-degree Hankel-kernel search over projective locator space;
- distinct rational-root recovery, Vandermonde magnitude recovery, and an
  independently replayed locator certificate; and
- the five required command names.

`classify` and `canonicalize` currently return only witness-backed
`NOT_DEEP` results.  The frozen theorem-domain and orbit adapters must be
enabled before this crate can issue `DEEP`, `UNRESOLVED`, or structural
canonicalization results.  This fail-closed boundary is intentional.

The locator enumeration has projective kernel dimension
`2t+1-r` at degree `t`.  At terminal split-free testing `t=r-2`, this gives
the absorbed C608 field-scale exponents `q`, `q^2`, and `q^3` for
redundancies five, six, and seven, before the `O(q)` exhaustive-root factor
check used by this reference implementation.  A later factoring backend must
separate locator selection cost from root-factorization cost.

