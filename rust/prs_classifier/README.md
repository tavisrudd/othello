# PRS structural classifier

This is the C969 implementation crate.  Its current executable slice provides:

- exact polynomial-basis arithmetic over explicitly represented finite fields;
- projective syndrome normalization;
- both affine and infinity locator charts;
- increasing-degree Hankel-kernel search over projective locator space;
- the proved 12-point terminal-hyperplane selector for R5--R7, with streaming
  `O(q)`, `O(q^2)`, and `O(q^3)` prefix enumeration;
- intrinsic uniform R5 adapters for the tame rational/conjugate osculating
  families and the characteristic-three nucleus/wild families;
- the uniform R6 odd-binary third-nucleus adapter, including its exact
  extension-degree toggle;
- distinct rational-root recovery, Vandermonde magnitude recovery, and an
  independently replayed locator certificate;
- positive deep certificates whose independent verifier replays the frozen
  theorem-domain row, transporter, family route, and radius promotion;
- explicit `PGL(2,q) x Gal(F_q/F_p)` canonicalization with the exact
  `m(q^3-q)` cost exposed; and
- the five required command names.

`classify` returns witness-backed `NOT_DEEP`, persistent-family `DEEP`, and
frozen R5--R7 finite-exception `DEEP`/`UNRESOLVED` results. `canonicalize` is
functional but currently uses the explicit group-scale fallback.  Uniform
nonpersistent formula adapters remain open.  `distance` and `decode` are
exact within their explicit
candidate budget: after degrees through `r-1` they use an arbitrary NRC basis
at degree `r`, whose coefficients are forced nonzero by the failed lower
search.  Unsupported classification paths fail closed.

The locator enumeration has projective kernel dimension
`2t+1-r` at degree `t`.  At terminal split-free testing `t=r-2`, this gives
the absorbed C608 field-scale exponents `q`, `q^2`, and `q^3` for
redundancies five, six, and seven, before the `O(q)` exhaustive-root factor
check used by this reference implementation.  A later factoring backend must
separate locator selection cost from root-factorization cost.

The generic exact terminal fallback still enumerates the degree-`r-1` locator
hyperplane.  For R5--R7 it is now reached only as the bounded-small-field and
defensive correctness branch after the 12-point selector.  The proof and
degree count are recorded in
`notes/reed-solomon-tasks/c969-terminal-hyperplane-solver.md`.

`verify-certificate` accepts both `c969-locator-certificate-v1` negative
witnesses and `c969-deep-certificate-v1` positive certificates.  A deep
certificate is emitted only for `DEEP`, never for `UNRESOLVED` or
`UNSUPPORTED`.
