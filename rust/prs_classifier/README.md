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
- the uniform R7 odd-binary central-nucleus adapter, kept separate from the
  q=7,8,9 radius gap;
- exact tangent-family canonicalization in `m*q*(q-1)` transports and
  sigma canonicalization in `m*(q^2-1)` on the rootless-form stratum and
  `O(m*r*q)` on the simple-root stratum; these exhaust persistent sigma, while
  the same charts cover general forms in `O(m*r*q^2)` even at the
  characteristic-two degenerate successor;
- exact maximal-Hasse-root canonicalization in `O(m*r*q)` transports off the
  simultaneous Lucas degeneration and `O(m*r*q^2)` on it, including pure
  powers, with the full `m*(q^3-q)` path retained as a defensive fallback;
- an intrinsic persistent-sigma `T/T^(r-1)` modulo inversion/Frobenius
  extractor in `F_q[X]/Q`, using no discrete logarithm or torus enumeration;
- distinct rational-root recovery, Vandermonde magnitude recovery, and an
  independently replayed locator certificate;
- positive deep certificates whose independent verifier replays the frozen
  theorem-domain row, transporter, family route, and radius promotion;
- explicit `PGL(2,q) x Gal(F_q/F_p)` canonicalization with the exact
  `m(q^3-q)` cost exposed; and
- the five required command names.

Structural `canonicalize` is dimension-independent: it accepts every
redundancy `r>=5` with `q>=r`. The exact tangent and binary-form lex-coset
proofs apply unchanged. Coding operations (`distance`, `decode`, and
`classify`) remain restricted to R5--R10; in particular, no higher-dimensional
canonical form is promoted to a deep-hole verdict without a theorem-domain
row. R11 tangent and sigma fixtures and R12--R13 multiple-root fixtures over
`F_13` are checked against all 2,184 explicit PGL transports. A slow ignored
regression checks GF(16)/R11 against all 16,320 semilinear transports.

The four rational-root strata—rootless, simple, multiple, and pure power—give
an exhaustive worst-case bound of `O(m*r*q^2)` exact transports for structural
canonicalization, where `m` is the field extension degree. This is strictly
below full `m*(q^3-q)` enumeration when `r` is treated as the fixed redundancy;
the implementation retains that enumeration as its independent reference. The
symmetric-power action uses adjacent exact-linear-factor rows in `O(r^2)` field
operations per transport; see the
[full accounting](../../notes/reed-solomon-tasks/c969-canonicalization-complexity.md).

`classify` returns witness-backed `NOT_DEEP`, persistent-family `DEEP`, and
frozen R5--R7 finite-exception `DEEP`/`UNRESOLVED` results. `canonicalize` uses
proved lex-coset charts on every binary form; the explicit group action remains
as a defensive reference path. Further R8--R10 nonpersistent formula adapters
remain open. `distance` and `decode` are
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

The reproducible benchmark harness is built and run with:

```text
cargo run --release --manifest-path rust/prs_classifier/Cargo.toml \
  --bin c969_benchmark -- --iterations 10 --extension-fields
```

Its selector, projective-oracle, canonicalization, classification, and replay
rows are documented in `notes/reed-solomon-tasks/c969-benchmark-v1.md`.
