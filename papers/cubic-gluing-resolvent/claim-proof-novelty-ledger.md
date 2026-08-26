# Claim / proof / novelty ledger

Status as of 2026-08-21.  “Programme input” means a theorem proved in the
companion manuscript `papers/cubic-stabilization-m1`, not a claim to a
classical source.

| Claim | Status and proof provider | Priority boundary |
|---|---|---|
| The actual five principal kernels form `P_F4(F4 tensor E[2])`. | Programme input: relative six-axis source and principal gluing packet. | The geometric construction is in the companion manuscript. |
| The exotic complement has the sign character of the rational three-set. | Proved here by the two generators of `PGL_2(F_2)` on `P^1(F_4)`. | Elementary finite-group calculation; no novelty claim in isolation. |
| The exotic pair is the discriminant cover of the two-division cubic. | Proved here from the sign lemma and the classical cubic discriminant. | Classical for an `S_3` cubic; the application to the actual gluing packet is the paper’s point. |
| `T=81t^2` and `j=(T+27)(T+3)^3/T`. | Direct Fourier/VGY substitution, replayed by `verification/resolvent_identities.py`. | The ingredients come from van Geemen--Yamauchi; the normalized cubic-to-modular comparison is derived here. |
| The VGY elliptic Prym is the actual primitive norm axis. | Proved here by quotient pullback, the two polarization restrictions, and the resulting degree-one comparison. | Uses VGY’s quotient construction and the primitive axis normalization from the programme. |
| The root/sign/split curves are `X_0(6)`, `Gamma_sgn`, and `Gamma_0(3) intersect Gamma(2)`. | Human subgroup proof plus independent enumeration in `verification/subgroup_check.py`. | Standard modular interpretation of elliptic two-torsion. |
| The displayed `X_0(6)` parameter actually selects a two-division root. | Direct substitution of `T=-(4y+3)(y+3)^2/(y+1)^2` and `x=-4y^4/(y+1)^2` in the printed two-division cubic. | Proof-completeness repair; no novelty claim. |
| The sign curve is `r^2=T`, and `r=9t` after a deck choice. | Two-division discriminant `16T(T+27)^8`, then pullback by `T=81t^2`. | The identification with the signed cubic marking is the synthesis claim. |
| The actual mod-two image on the marked smooth base is exactly `A_3`. | The sign subgroup maps onto `A_3`; a loop about a deleted lift of the order-three point maps to a three-cycle. | Strengthens the containment proved in the epilogue. |
| A golden orientation makes the rational root packet a cyclic cubic splitting cover. | Over the sign subgroup, the point stabilizer has trivial intersection with `A_3`; the pullback is the regular `C_3`-set. | Formal but useful interaction between the two resolvents. |
| The cyclic cubic cover ramifies exactly at the two five-`A_2` cubic fibres. | The identities `r^2+27=(v^2+3)^3/(v^2-1)^2` and `(r-3a)/(r+3a)=((v-a)/(v+a))^3`, `a^2=-3`, give the complete local monodromy tuple. | New synthesis of the modular and cubic boundary descriptions; the Kummer calculation itself is elementary. |
| The cyclic deck action is rational and golden reversal inverts it. | `sigma(v)=(v-3)/(v+1)` fixes `r`, has order three, and `-sigma(-v)=sigma^{-1}(v)`. | Makes the orientation/cyclic-order interaction explicit; elementary once the split coordinate is known. |
| The sign curve has genus zero, cusp widths `2,6`, and two order-three points. | Proved from parabolic and elliptic monodromy and the genus formula. | Standard modular-curve calculation. |
| The root and split passports have cusp widths `1,2,3,6` and `2,2,2,6,6,6`, respectively, and genus zero. | Transposition inertia plus the genus formula at indices 12 and 24. | Standard calculation completing the resolvent square. |
| `t=3(eta(3tau)/eta(tau))^6`, with noncuspidal cubic boundary values `h=-27,5`. | Immediate from `h=729/T`, `T=81t^2`, and the chosen square root of `h`. | Explicit normalization; no novelty claim for the eta quotient itself. |
| The chordal value `h=5` carries the icosahedral hyperelliptic limit, whose Jacobian is isogenous to the fifth power of the norm-axis elliptic factor. | `verification/chordal_transversality.py` constructs the twelve-point `A_5` orbit on the singular quartic, recovers its six-dimensional quadratic ideal, and proves that adjoining `Q` raises the degree-three ideal rank from 22 to 23.  Hence `Q|_C` is nonzero and its twelve known zeros form the reduced transverse divisor.  CMGHL, Paulhus's Theorem 2, and `j(E_ico)=J(729/5)` finish the comparison. | The limit theorem and Jacobian decomposition are imported; the family-specific transverse-divisor calculation and its identification with the norm axis are the paper-specific synthesis. |
| The embedded twelve-point branch orbit reconstructs the chordal quartic, its secant cubic, and the projective first-order normal direction; that direction is the unique `A_5`-fixed normal line. | The equality `I_Z(2)=I_C(2)` recovers `C` scheme-theoretically; projective normality and the unique section of `O_C(3)` with divisor `Z` recover `[Q]` modulo `I_C(3)`.  Any fixed line yields an invariant degree-twelve divisor, necessarily the unique icosahedral orbit of that length. | Allcock--Carlson--Toledo give the general normal-direction interpretation; reconstruction and symmetry-rigidity for this exact orbit are immediate paper-specific consequences. |
| For general prime `ell`, the rational and nonrational parts of `P^1(F_{ell^2})` are the Borel and nonsplit-Cartan quotients; only at `ell=2` is the latter a double/sign cover. | Orbit-stabilizer, Frobenius, and the nonsplit-Cartan normalizer; compared with Rebolledo--Wuthrich's modular interpretation. | Classical finite and modular geometry; included to isolate what is exceptional at two. |
| Only `T=0,infinity` are modular cusps; `T=-27,729/5` are extra cubic boundary values. | Direct cubic singularity census inherited from the exact A5-pencil certificate and stated explicitly here. | This is a scope correction, not a claim that the cubic compactification is modular. |

The paper does not claim that the fivefold kernels are elliptic isogenies, that
the compactified cubic pencil is a modular stack, or that the related Winger
pencil supplies the cubic base comparison.
