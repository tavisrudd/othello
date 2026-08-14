# Gamma point-row cold read D: D-modules and two-wall boundary

Date: 2026-08-13

Frozen authority commit:
`f73bcb4f837eed0aa8d512567b70c74534b1f61a`

Frozen PDF SHA-256:
`ed5c6c5d98ab158164e4885e8fc3734060b5fa724290b78658a20dbf9e2bd8b8`

Packet: Sections 5--7 and the cited Fourier--Laplace source. The reader
received no internal research notes, prior reports, or proposed repairs.

Verdict: **MAJOR**, repairable only by narrowing the advertised conclusion.

## Earliest unsupported implication

The abstract says that the signed output-rank condition on the complete
oriented boundary correction is proved sufficient for factorization-level
point-row invariance. Theorem 7.2 actually proves invariance from the
factorwise conditions `r(v_a)=0`. No identity is constructed between those
factorwise values and the single alternating punctual coefficient
`mu_00(B_corner)`.

A global alternating multiplicity can vanish by cancellation without
annihilating each factor. Likewise, total support of a relative kernel in
`Y x D` implies `r(T-I)=0` directly, but does not force every factor in an
independently selected factorization to have target in the supported span.

## Required narrowing

- Keep the factorwise rank-zero-target hypothesis and Theorem 7.2.
- Treat the signed punctual coefficient as a proposed shadow/open comparison,
  not an equivalent or sufficient condition.
- Remove the advertised implication from the abstract and introduction.
- If the singular shadow is retained, state the missing comparison theorem:
  construct a boundary object for each complete ray block and identify its
  marked coefficient with `r(v_a)`, with concentration strong enough to
  exclude cancellation.

Sections 5 and 6 otherwise passed. Proposition 6.1 is the strongest passage:
the explicit Weyl-algebra transform shows that punctual Fourier support can
return to generic rank one. The highest-friction passage is the undefined
point-row marking on `B_corner` and the unsupported passage from one signed
Euler coefficient to factorwise transition targets.

Source checked: Reichelt--Schulze--Sevenheck--Walther,
arXiv:2004.07262v2, especially Section 5.2.
