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
nonpersistent formula adapters and the faster R5--R7 terminal-hyperplane
solver remain open.  `distance` and `decode` are exact within their explicit
candidate budget: after degrees through `r-1` they use an arbitrary NRC basis
at degree `r`, whose coefficients are forced nonzero by the failed lower
search.  Unsupported classification paths fail closed.

The locator enumeration has projective kernel dimension
`2t+1-r` at degree `t`.  At terminal split-free testing `t=r-2`, this gives
the absorbed C608 field-scale exponents `q`, `q^2`, and `q^3` for
redundancies five, six, and seven, before the `O(q)` exhaustive-root factor
check used by this reference implementation.  A later factoring backend must
separate locator selection cost from root-factorization cost.

The current exact terminal fallback enumerates the degree-`r-1` locator
hyperplane and therefore costs `O(q^(r-2))` locator candidates in the worst
case, plus exhaustive-root checks.  It is a correctness oracle, not the
absorbed C608 terminal solver; no `O(q)`, `O(q^2)`, `O(q^3)` R5--R7 claim is
made for it.
