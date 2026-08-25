# PRS structural classifier

This is the C969 implementation crate.  Its current executable slice provides:

- exact polynomial-basis arithmetic over explicitly represented finite fields;
- projective syndrome normalization;
- both affine and infinity locator charts;
- increasing-degree Hankel-kernel search over projective locator space;
- distinct rational-root recovery, Vandermonde magnitude recovery, and an
  independently replayed locator certificate;
- explicit `PGL(2,q) x Gal(F_q/F_p)` canonicalization with the exact
  `m(q^3-q)` cost exposed; and
- the five required command names.

`classify` returns witness-backed `NOT_DEEP`, persistent-family `DEEP`, and
frozen R5--R7 finite-exception `DEEP`/`UNRESOLVED` results. `canonicalize` is
functional but currently uses the explicit group-scale fallback.  Uniform
nonpersistent formula adapters and nearest-word witnesses for split-free
inputs remain open.  Unsupported paths fail closed.

The locator enumeration has projective kernel dimension
`2t+1-r` at degree `t`.  At terminal split-free testing `t=r-2`, this gives
the absorbed C608 field-scale exponents `q`, `q^2`, and `q^3` for
redundancies five, six, and seven, before the `O(q)` exhaustive-root factor
check used by this reference implementation.  A later factoring backend must
separate locator selection cost from root-factorization cost.
