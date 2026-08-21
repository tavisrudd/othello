# Claim / proof / novelty ledger

Status as of 2026-08-21.  “Programme input” means a theorem proved in the
companion manuscript `papers/cubic-stabilization-epilogue`, not a claim to a
classical source.

| Claim | Status and proof provider | Priority boundary |
|---|---|---|
| The actual five principal kernels form `P_F4(F4 tensor E[2])`. | Programme input: relative six-axis source and principal gluing packet. | The geometric construction is in the companion manuscript. |
| The exotic complement has the sign character of the rational three-set. | Proved here by the two generators of `PGL_2(F_2)` on `P^1(F_4)`. | Elementary finite-group calculation; no novelty claim in isolation. |
| The exotic pair is the discriminant cover of the two-division cubic. | Proved here from the sign lemma and the classical cubic discriminant. | Classical for an `S_3` cubic; the application to the actual gluing packet is the paper’s point. |
| `T=81t^2` and `j=(T+27)(T+3)^3/T`. | Direct Fourier/VGY substitution, replayed by `verification/resolvent_identities.py`. | The ingredients come from van Geemen--Yamauchi; the normalized cubic-to-modular comparison is derived here. |
| The VGY elliptic Prym is the actual primitive norm axis. | Proved here by quotient pullback, the two polarization restrictions, and the resulting degree-one comparison. | Uses VGY’s quotient construction and the primitive axis normalization from the programme. |
| The root/sign/split curves are `X_0(6)`, `Gamma_sgn`, and `Gamma_0(3) intersect Gamma(2)`. | Human subgroup proof plus independent enumeration in `verification/subgroup_check.py`. | Standard modular interpretation of elliptic two-torsion. |
| The sign curve is `r^2=T`, and `r=9t` after a deck choice. | Two-division discriminant `16T(T+27)^8`, then pullback by `T=81t^2`. | The identification with the signed cubic marking is the synthesis claim. |
| The actual mod-two image on the marked smooth base is exactly `A_3`. | The sign subgroup maps onto `A_3`; a loop about a deleted lift of the order-three point maps to a three-cycle. | Strengthens the containment proved in the epilogue. |
| The sign curve has genus zero, cusp widths `2,6`, and two order-three points. | Proved from parabolic and elliptic monodromy and the genus formula. | Standard modular-curve calculation. |
| Only `T=0,infinity` are modular cusps; `T=-27,729/5` are extra cubic boundary values. | Direct cubic singularity census inherited from the exact A5-pencil certificate and stated explicitly here. | This is a scope correction, not a claim that the cubic compactification is modular. |

The paper does not claim that the fivefold kernels are elliptic isogenies, that
the compactified cubic pencil is a modular stack, or that the related Winger
pencil supplies the cubic base comparison.
