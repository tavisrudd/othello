# C374 — Clebsch `AME(6,11)` local-equivalence class

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; EXACT LC AND LU SEPARATION FROM EVERY SIX-POINT GRS AME CLASS`

## The theorem

Work over `F_11`, put `omega=exp(2*pi*i/11)`, and use

```text
X(a)|x> = |x+a>,                 Z(b)|x> = omega^(b*x)|x>.
```

In the C341 manuscript fibre `tau=8`, the ordered Clebsch parity-check columns are

```text
(0,1,4), (0,1,7), (1,4,0), (1,7,0), (1,0,3), (1,0,8).
```

Their kernel `C <= F_11^6` has the fixed reduced generator matrix

```text
G = [1 0 0 | 3  7  1]
    [0 1 0 | 3  1  7]
    [0 0 1 | 1 10 10].
```

Define

```text
|Psi_C> = 11^(-3/2) sum_(c in C) |c>.
```

Then:

1. `|Psi_C>` is a minimal-support stabilizer `AME(6,11)` state.  Its Pauli-label
   Lagrangian, in `(x_0,...,x_5 | z_0,...,z_5)` order, is

   ```text
   L_C = rowspace [G 0]
                    [0 H],
   ```

   where `H` is the displayed Clebsch parity-check matrix and `rowspace(H)=C^perp`.
   Both `C` and `C^perp` are `[6,3,4]_11` MDS codes.
2. Allowing arbitrary party permutation, `|Psi_C>` is not local-Clifford equivalent
   to the minimal-support AME state of any length-six generalized Reed--Solomon code
   over `F_11`.
3. More strongly, allowing arbitrary party permutation, it is not local-unitary
   equivalent to any such GRS-derived state.

Thus C341's classical non-GRS verdict is not merely monomial inequivalence: the associated
Clebsch stabilizer state lies outside every six-point GRS local-Clifford orbit and every
six-point GRS local-unitary orbit.

This is not a classification against arbitrary non-GRS `AME(6,11)` states.

## Stabilizer and AME verification

The six independent generators are `X(g_i)` for the three rows of `G` and `Z(h_i)` for
three rows spanning `C^perp`.  Since `G H^T=0`, they commute.  Their label space has
dimension six and is Lagrangian, so after fixing the displayed `+1` eigenstate convention
they determine one stabilizer state.  Any character/phasing difference on the same
Lagrangian is removable by a tensor product of local Pauli operators.

C341 already certifies all twenty nonzero three-column minors.  Equivalently, both `C`
and its dual have minimum distance four.  Projection of `C` onto any three coordinates is
therefore bijective, so tracing any complementary three parties from `|Psi_C><Psi_C|`
gives `I_(11^3)/11^3`.  The state is `AME(6,11)` and has the minimum possible support
`11^3`.

The JSON records the reduced code, dual, and full `6 x 12` stabilizer matrices.  The
checker independently exhausts all `11^3-1` nonzero coefficient vectors for each minimum
distance calculation.

## Complete local-Clifford obstruction

For every four-party subset `T`, let

```text
K_T = {ell in L_C : supp(ell) subset T}.
```

The MDS property gives `dim K_T=2`, and projection `K_T -> F_11^2` onto either Pauli
coordinate pair `(x_i,z_i)` with `i in T` is an isomorphism.  Hence a support `T`
defines an intrinsic transition matrix `M_T(i,j)` from the Pauli-label plane at party
`i` to that at party `j`.

For two supports `T,U` containing `i,j`, form the holonomy

```text
Hol(T,U;i,j) = M_U(j,i) M_T(i,j).
```

A local Clifford with symplectic blocks `F_i in SL_2(11)` conjugates this matrix by
`F_i`.  Recording `(trace,determinant)` for both `Hol` and `Hol^(-1)` removes the
orientation choice.  The resulting 450-element multiset is therefore invariant under
local Clifford operations and party permutation.

The Clebsch histogram is

| trace | determinant | multiplicity |
|---:|---:|---:|
| 1 | 10 | 120 |
| 2 | 1 | 60 |
| 3 | 1 | 120 |
| 9 | 1 | 30 |
| 10 | 10 | 120 |

Every dimension-three length-six GRS code is, up to nonzero column multipliers, obtained
from six points of `P^1(F_11)`.  Column multipliers act by local computational-basis
scalings, hence by local Cliffords.  Exact enumeration gives four `PGL_2(11)` orbits on
the `binom(12,6)=924` evaluation sets:

| representative | orbit size | Clebsch LC signature? |
|:---|---:|:---:|
| `{0,1,2,3,4,5}` | 330 | no |
| `{0,1,2,3,4,6}` | 264 | no |
| `{0,1,2,3,5,6}` | 220 | no |
| `{0,1,2,3,5,9}` | 110 | no |

The independent replay does not use the CSS code/dual decomposition.  It shortens the
full six-dimensional Lagrangian directly, reconstructs all 15 two-dimensional `K_T`,
and checks all 924 evaluation sets individually.  It obtains exactly four GRS signatures
and zero Clebsch matches.

As a second complete check against the conventional extended-RS presentation at
`{0,1,2,3,4,infinity}`, the checker enumerates all 720 party permutations and all 1,320
choices for one anchor block in `SL_2(11)`.  Each choice forces the other five local
blocks through the minimal-support transitions.  All `950,400` candidates fail; none
even passes every support relation.  A passing candidate would additionally be checked
by direct equality of the transformed and target Lagrangian row spaces.

## Finite general local-unitary obstruction

The LC signature is not asserted to be invariant under arbitrary local unitaries.  The
LU separation uses a different, elementary marginal-moment invariant.

For a four-party subset `T`, let `rho_T` be the reduced density matrix and embed it back
into all six parties as

```text
A_T = rho_T tensor I_(T^c).
```

For every unordered triple `{T,U,V}`, the number

```text
mu(T,U,V) = Tr(A_T A_U A_V)
```

is invariant under arbitrary party-local unitaries; a party permutation merely permutes
the 455 triples.  For a stabilizer state,

```text
A_T = 11^(-4) sum_(s in K_T) s.
```

The product trace is nonzero precisely when the three stabilizer labels sum to zero.
Consequently

```text
mu(T,U,V) = 11^(-rank(K_T + K_U + K_V)).
```

The exact distributions are:

| state/evaluation orbit | `11^-4` triples | `11^-6` triples |
|:---|---:|---:|
| Clebsch | **70** | 385 |
| GRS orbit size 330 | 62 | 393 |
| GRS orbit size 264 | 60 | 395 |
| GRS orbit size 220 | 63 | 392 |
| GRS orbit size 110 | 64 | 391 |

Thus one finite exact LU invariant separates the Clebsch state from all four GRS
evaluation-set orbits.  A direct independent sweep of all 924 evaluation sets obtains
the four distributions with multiplicities `330,264,220,110` and zero Clebsch matches.
No continuous search and no LU=`LC` assumption is used.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-19-c374-clebsch-ame-equivalence.py --check
sha256sum -c notes/2026-07-19-c374-clebsch-ame-equivalence.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 24,690 | `15a99411b06f46f07e9b77a8593541031d98b4353fa0d9076d8452e2484ca694` |
| certificate `.json` | 15,469 | `b3ecefac292797375ec7849480cd003039bf6e56219f61a117e39f575898405d` |

The checker is standard-library-only and deterministic.  Its trusted boundary is Python
3 integer arithmetic modulo 11, exact row reduction, the stabilizer/Pauli dictionary,
and the displayed conjugation and marginal-trace arguments.  The CSS and direct-
Lagrangian computations derive the LC signature by different shortenings.  The GRS
comparison is checked both through the four `PGL_2(11)` orbits and by direct enumeration
of all 924 evaluation sets.

The certificate does not classify arbitrary non-GRS AME states, prove that the simple
moment multiset is a complete LU invariant, analyze non-stabilizer states, or supply a
preparation circuit.  C375 owns the circuit and `A5`-equivariance questions.

## Literature closure and novelty boundary

### Read-depth summary

This audit read **zero external papers in full** and **seven external papers partially**.
Every source below records the exact portion used.  The conclusion is a bounded exact-
object verdict, not a universal priority claim; MathSciNet and Google Scholar were not
available, and Semantic Scholar's API returned HTTP 429 for every pinned seed query.

### Primary-source matrix

| source | read depth and exact access | result for C374 |
|:---|:---|:---|
| Raissi--Gogolin--Riera--Acin, *Optimal quantum error correcting codes from absolutely maximally entangled states* | **partial**: arXiv `1701.03359v2`, Sections III and VI, extracted lines 100--180 and 500--569; cache `arXiv:1701.03359`, SHA-256 `768f70614685a881ba7902428164fe9e2cf0e78be123cd344c6e838ac072e673` | Owns the minimal-support AME--MDS correspondence and the `X(G),Z(H)` stabilizer construction.  Those are not Clebsch novelties. |
| Bahramgiri--Beigi, *Graph States Under the Action of Local Clifford Group in Non-Binary Case* | **partial**: arXiv `quant-ph/0610267v2`, Section III.A--D through Theorem 5, extracted lines 233--725; cache `arXiv:quant-ph/0610267`, SHA-256 `c3f8ae13be712936fd823c96d070d0afddf48b1f18ddf879441a8c4512f0b4db` | Supplies the prime-qudit Pauli convention, local `SL_2(p)` symplectic action, and complete LC framework.  C374's support-holonomy invariant and exact Clebsch census are new computations, not a new general LC formalism. |
| Burchardt--Raissi, *Stochastic Local Operations with Classical Communication of Absolutely Maximally Entangled States* | **partial**: arXiv `2003.13639v1`, Sections III--IV and Appendix C opening, extracted lines 480--980 and 2439--2820; cache `arXiv:2003.13639`, SHA-256 `7b38bd6a5bd8fb8299863e5ca3c7f64dfadd51a12f1b865edbbcbc3d4847a9e3` | Proves LU/SLOCC equivalence for critical states, finite restrictions in bounded minimal-support regimes, and infinitely many inequivalent minimal-support AME states once six or more parties exist.  It pre-empts any generic “more than one AME(6,11) class” claim but does not identify the Clebsch code or separate it from every GRS orbit. |
| Rather--Ramadas--Kodiyalam--Lakshminarayan, *Absolutely maximally entangled state equivalence...36 officers* | **partial**: arXiv `2212.06737v2`, abstract and Introduction, extracted lines 1--180; cache `arXiv:2212.06737`, SHA-256 `740ee6e03fcd77f320ff03233f6b9ab0a7fba32781aa0cac40b5e88ed0465655` | Develops polynomial LU invariants for four-party AME states and proves the four-qutrit result.  It does not cover the six-party dimension-eleven object. |
| Ramadas--Lakshminarayan, *Local unitary equivalence of absolutely maximally entangled states constructed from orthogonal arrays* | **partial**: arXiv `2411.04096v1`, Sections 1--3, Corollary 2, the `N=6` discussion, and Section 7; cache `arXiv:2411.04096`, SHA-256 `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647` | Gives a complete family of polynomial LU invariants and proves infinitely many LU classes whenever a minimal-support `AME(6,d)` exists, including `d=11`.  This sharply narrows C374: the surviving statement is the explicit `A5`-symmetric Clebsch class and its exact separation from all GRS classes, not the existence of multiple classes. |
| Burchardt--de Jong--Vandre, *Algorithm to Verify Local Equivalence of Stabilizer States* | **partial**: arXiv `2410.03961v2`, abstract, Introduction, and Section II opening, extracted lines 1--260 after removal of extraction NULs; cache `arXiv:2410.03961`, SHA-256 `107a3548b8ed622181c7ee81dd1f19051d0e67bd6a72c6c9c59a36911a2cc984` | The algorithm and the up-to-eleven-vertex LU=`LC` census are explicitly for qubits.  They do not authorize LU=`LC` at local dimension eleven. |
| Rajchel-Mieldzioc--Bistron--Rico--Lakshminarayan--Zyczkowski, *Absolutely maximally entangled pure states of multipartite quantum systems* | **partial**: arXiv `2508.04777v1`, AME(6,d) construction discussion and Section VII, extracted lines 630--675 and 1560--1675; cache `arXiv:2508.04777`, SHA-256 `bc8ee8fc5648b574dc8e994eb7d27b7ef213e1873a2204e4060cc3613e15760b` | The 2026 review treats LU classification as open in general and summarizes known infinite-class results.  No exact Clebsch or `AME(6,11)` equivalence result appears in the inspected passages or exact-text hits. |

The trace-of-products construction used here is presented only as an elementary member
of the standard polynomial-LU-invariant toolkit.  No novelty is claimed for polynomial
invariants themselves.

### Exact-query screened sets

On 2026-07-19, four exact discriminators were run against OpenAlex and Crossref:

```text
AME(6,11) local unitary equivalence
Clebsch absolutely maximally entangled
six-party dimension eleven AME stabilizer
non-GRS MDS AME local unitary
```

For each query the top 20 title records were screened, except where OpenAlex returned
fewer.  OpenAlex returned respectively `20/20`, `20/41`, `17/17`, and `3/3`; Crossref
returned `20` titles for each from noisy totals `6,593,541`, `25,622`, `409,141`, and
`2,435,060`.  The mechanical discriminator retained a record only if its title contained
the exact `AME(6,11)`/Clebsch-entanglement object or combined AME/stabilizer language
with local equivalence.  It retained zero exact-object records.  The enormous Crossref
totals are token-collision noise and weak absence evidence, not proof of nonexistence.

### Forward-citation closure

Pinned seeds and provider counts were:

| seed | OpenAlex | Crossref | Semantic Scholar |
|:---|---:|---:|:---|
| Raissi et al., DOI `10.1088/1751-8121/aaa151`, OpenAlex `W2610757301` | 51 citing records returned and screened | `is-referenced-by-count=46` | **NOT COVERED:** HTTP 429 |
| Burchardt--Raissi, DOI `10.1103/PhysRevA.102.022413`, OpenAlex `W3013896097` | 22 citing records returned and screened | `is-referenced-by-count=19` | **NOT COVERED:** HTTP 429 |
| Ramadas--Lakshminarayan, DOI `10.1088/1751-8121/adbf75`, OpenAlex `W4408319724` | metadata count 2 but citing filter returned 3; all 3 screened | `is-referenced-by-count=3` | **NOT COVERED:** HTTP 429 |

The 51- and 22-record sets were screened over title plus available abstract with the
verbatim discriminator: retain exact `AME(6,11)`, six-party/dimension-eleven, Clebsch,
or a conjunction of AME/stabilizer with local-unitary/local-Clifford/equivalence language,
plus GRS or marginal-moment hits.  Seven and nine records respectively were retained for
individual inspection.  The only directly applicable classification advance was the
2025 Ramadas--Lakshminarayan paper above.  Its three forward records were the 2026 AME
review, a minimal-decomposition-entropy paper, and a four-qutrit transversal-gate paper;
none has the exact six-party dimension-eleven Clebsch object in its title or abstract.

Coverage gaps remain MathSciNet, Google Scholar, Semantic Scholar, and full-body reading
of the 2026 review.  Therefore the released publication wording is deliberately narrow:

> The Clebsch `A5`-symmetric stabilizer presentation defines an explicit
> `AME(6,11)` local-unitary class outside every generalized Reed--Solomon-derived class.

Do not replace this by “the first non-GRS AME class,” “the first new `AME(6,11)` class,”
or a universal priority claim.

## Ownership and hand-back

- C341 continues to own the non-GRS parent code and its rank-eight syndrome scheme.
- C368 continues to own the q=11 parent/deep-hole-conic/GRS-child arithmetic phase.
- C373 continues to own intrinsic chirality and the affine `A5` automorphism theorem.
- C374 owns only the fixed stabilizer presentation and the exact LC/LU separation proved here.
- C375 may consume these conventions and the inequivalence verdict, but generic transport from
  an RS circuit is no longer available; its minimal-circuit and `A5`-equivariance gates remain open.
