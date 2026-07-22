# C478 — exceptional-family atlas controls

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete.  The universal edge-torus layer of C475 recovers every projective
deep-syndrome orbit in the four frozen C398 non-GRS classes, but after unlabelling it retains
exactly the full child's intrinsic point-orbit colouring and has one fixed-child parent signature
in every row.  The `A3/B3/H3` full-conic children have no deep-syndrome atlas domain.  Modular
machinery belongs only after a separately supplied matching decoration passes both the Gram and
Sylow gates.

## Result

For a six-arc parent `A={h_1,...,h_6}` and a deepest projective syndrome `u`, put

```text
d_ij(u)=det(u,h_i,h_j)
```

and retain C475's universal edge-torus coordinates

```text
(d_ij d_kl / d_ik d_jl, d_ij d_kl / d_il d_jk)          (1)
```

for every `i<j<k<l`.  There are thirty coordinates.  Formula (1), unlike C475's subsequent
Veronese bracket normalization, makes sense for an arbitrary six-arc.  It is invariant under
syndrome scaling and independent column scaling.  For parent comparison, canonicalize it over all
six support relabellings and all Frobenius powers.

The exact cross-family table is:

| family | atlas domain | syndrome orbits recovered by (1) | fixed-child parents / Coxeter decorations | unlabelled atlas parent signatures | independent decoration recovers parent? | shared Gram rank | Sylow gate | modular verdict |
|:---|:---:|:---:|---:|---:|:---:|:---:|:---:|:---:|
| C398 q=8, `|U|=4` | 4 | `4` | 6 | 1 | no | — | — | not entered |
| C398 q=9 cube, `|U|=6` | 6 | `6` | 8 | 1 | yes | `3` over `F_3` | fails: regular/projective `F_3 C3` endpoint | **fails** |
| C398 q=9, `|U|=7` | 7 | `1+6` | 2 | 1 | no | — | — | not entered |
| C398 q=11 matching, `|U|=12` | 12 | `12` | 22 | 1 | yes | `0` over `F_3` | passes: `Omega(F_3)+free` | **passes** |
| `A3` conic phase q=5 | 0 | vacuous | 5 | — | bare child no | — | — | no equal sheet pair |
| `B3` conic phase q=7 | 0 | vacuous | 14 | — | bare child no | `0` over `F_2` | passes: relative `D8` syzygy | **passes when pointed** |
| `H3` conic phase q=11 | 0 | vacuous | 22 | — | bare child no | `0` over `F_3` | passes: `Omega(F_3)+free` | **passes when pointed** |

Here “independent decoration” is C474's deletion-trace signature in the C398 rows.  For the Coxeter
rows the bare full-conic child forgets among the classical `5,14,22` decorations; the q=7 and q=11
positive modular statements consume the already-pointed matching sheets certified by C465/C474.
They do not assert that the unmarked child reconstructs a sheet.

This proves the sharp negative requested by the task:

> Exact geometric orbit recovery by the determinant atlas neither recovers the parent nor implies
> modular invertibility.  A modular carrier can be attached only after an independent intrinsic
> decoration produces the requisite cross-incidence geometry and passes its own Gram and Sylow
> gates.

## 1. What the atlas detects

On the four C398 representatives, all `4,6,7,12` labelled syndromes have distinct thirty-coordinate
atlases.  After quotienting by the recorded parent semilinear automorphism group, the atlas orbit
sizes are respectively

```text
4;  6;  1+6;  12,
```

exactly the projective deep-hole orbit sizes independently proved by C474.  Thus (1) loses no
syndrome-orbit information in the frozen non-GRS domain.  This is a finite control, not an
all-non-GRS theorem: C475's general rank-two reconstruction theorem uses the Veronese structure of
a conic parent and is not silently extended here.

The q=11 row is particularly clarifying.  Every syndrome point lies on the child conic, but its
edge labels are measured against a non-GRS parent.  They do not factor as C475's rank-one
Veronese edge array, and all twelve atlases are distinct.  Rank-one contraction is therefore a
property of the pair “conic parent plus syndrome,” not of the ambient syndrome point merely lying
on some conic.

## 2. What the atlas does not detect

Fix the literal child `L=U(A)`.  For every parent above it, canonicalize each syndrome atlas over
all support relabellings and Frobenius powers, and retain the resulting function on the literal
points of `L`.  Across the four fixed-child fibres of sizes

```text
6, 8, 2, 22,
```

the numbers of distinct functions are

```text
1, 1, 1, 1.                                             (2)
```

Thus the unlabelled atlas never recovers the parent.  This is not a collision caused by one
exceptional syndrome: the complete atlas family agrees across each entire parent fibre.  By
contrast, deletion traces recover exactly the q=9 six-locus and q=11 full-conic fibres.  The two
invariants therefore perform genuinely different jobs:

```text
determinant atlas:   syndrome inside a fixed parent;
deletion trace:      parent above a fixed child.
```

Keeping support labels would make the parent visible tautologically; (2) uses the intrinsic
unlabelled/Frobenius quotient and is the relevant recovery test.

The requested extra-juice pass gives a structural explanation for the maximal blindness.  Let
`Gamma=Stab_PGammaL(L)`, let `X` be the unlabelled/Frobenius atlas space, and write

```text
f_A : L -> X,                    u |-> canonical atlas of (A,u).
```

Covariance of determinants gives the exact transporter identity

```text
f_(gA)(u)=f_A(g^-1 u),           g in Gamma.             (3)
```

Consequently the atlas recovers the parent orbit `Gamma/Stab(A)` exactly if and only if
`Stab_Gamma(f_A)=Stab_Gamma(A)`.  This is the parent-recovery criterion that the raw signature
count alone concealed.

In the four frozen rows, the numbers of values of `f_A` are

```text
1, 1, 2, 1,
```

and their fibre sizes are respectively

```text
4;  6;  1+6;  12.                                      (4)
```

These are exactly the point-orbit partitions of the full child stabilizers, not merely coarsenings
of them.  Hence `f_A` is `Gamma`-invariant and

```text
Stab_Gamma(f_A)=Gamma                                  (5)
```

in every row.  Equation (5) forces the one-signature parent collapse in (2).  The q=9 seven-point
case is the informative exception to “one colour”: its two atlas values recognize the child's
intrinsic fixed point and six-orbit, but still retain no parent-specific decoration.

## 3. The full-conic controls

For each fixed C399 conic phase, direct projective enumeration verifies that the invariant conic
has `q+1=6,8,12` points and every point outside it lies on a conic secant.  Hence the full conic is
a complete arc and has zero one-column MDS extensions:

```text
U(C(F_q))=emptyset,             q=5,7,11.                (6)
```

Consequently the C475 deep-syndrome atlas of the full-conic child is empty in all three controls.
The q=7 and q=11 modular carriers live on extra Coxeter/matching decoration of that child, not on
deep syndromes of the child code itself.  The q=5 control has five decorations, so it does not even
admit the equal two-sheet input used by the proved cross-incidence construction.

This separates three structures that the numerical coincidences can otherwise blur:

```text
non-GRS parent --deep locus--> conic GRS child;
conic child + marking       --> matching sheets;
matching cross incidence    --> possible modular carrier.
```

Only the q=11 C398/H3 control presently realizes all three arrows in one frozen object.

## 4. Why q=9 and q=11 diverge

Both recovering C398 rows have two matching sheets and exact atlas recovery of individual
syndrome orbits.  Their first difference is already the Gram gate.

For the q=9 cube, after ordering the four-point sheets,

```text
B=J-P,  Z=P,  rank(B)=3,  rank(B B^T)=3 over F_3.
```

The shared code is the nondegenerate augmentation `A_4`, not a Lagrangian.  Independently, a Sylow
`C3` acts as `(3)(1)`, and `A_4|C3` is the regular projective module.  Its stable class is zero;
the trace splitting required by the endotrivial criterion also fails because `dim(A_4)=0` in
`F_3`.

For q=11,

```text
rank(B)=5,  rank(B B^T)=0,  rank(Z)=6,  rank(Z Z^T)=1 over F_3.
```

The cross-code identities give `D=<1> direct-sum S` and `S=D^perp`; the augmentation is a nonsplit
self-dual Lagrangian extension.  On a Sylow `C3`, `S=Omega(F_3)+free`, and the trace-zero
endomorphism module is projective, so `S` is an endotrivial Picard unit.  The q=7 pointed `B3`
control passes the analogous test over `F_2`, with a reflection-relative `D8` syzygy.

Thus matching sheets and decorated recovery are still only geometric entry data.  Bad-prime Gram
degeneration and Sylow endomorphism projectivity are the first genuinely modular discriminators.

## 5. Weakest proved gateway hypotheses

Within the present programme, atlas recovery can feed the modular gateway only after all of the
following independent conditions are supplied:

1. an intrinsic parent decoration, injective on the fixed-child fibre, producing two equal sheets
   and canonical cross relations;
2. over a coefficient field `k`, nonzero sheet degree and the exact orthogonal identities
   `D=k1 direct-sum S` and `S=D^perp`;
3. a nonsplit augmentation `0 -> S -> A -> S^* -> 0`;
4. `dim(S)` nonzero in `k` and projectivity of `End_k(S)_0` on a Sylow subgroup;
5. a one-dimensional fusion-compatible local `H^1` line containing the nonzero restricted
   extension; and
6. nonisomorphic simple endpoints with scalar endomorphism rings.

These are exactly the load-bearing hypotheses of the proved C474 Modular Gateway Theorem, grouped
to expose where the atlas stops contributing.  Condition 1 is not implied by (1): equation (2)
proves the contrary on every frozen C398 control.  The q=9 cube passes condition 1 and fails
conditions 2 and 4.  The pointed q=7 and q=11 matching carriers pass all six groups of conditions.

## Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c478-exceptional-family-controls.md
notes/2026-07-22-c478-exceptional-family-controls.py
notes/2026-07-22-c478-exceptional-family-controls-replay.py
notes/2026-07-22-c478-exceptional-family-controls.json
notes/2026-07-22-c478-exceptional-family-controls.sha256
```

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c478-exceptional-family-controls.py --check
python3 notes/2026-07-22-c478-exceptional-family-controls-replay.py
sha256sum -c notes/2026-07-22-c478-exceptional-family-controls.sha256
```

The primary generator hash-pins and consumes the C398, C399, C465, and two C474 certificates.  It
does not regenerate the C398 classification.  It evaluates all thirty edge-torus coordinates,
reconstructs only the already-fixed locus and parent stabilizers, canonicalizes the parent
comparison over all `6!` support relabellings and Frobenius powers, checks the three complete-conic
loci, and recomputes the load-bearing Gram ranks from the frozen cross matrices.

The independent replay implements its own arithmetic for `F_8`, `F_9`, and the three prime fields;
constructs the semilinear frame actions independently; repeats every atlas and full-conic check;
recomputes the Gram ranks; and verifies directly that the q=9 augmentation has a regular
three-vector `C3` orbit.  It imports neither new primary code nor its computed values.

Trusted boundary: Python integer/JSON correctness; the displayed polynomial bases
`F_8=F_2[x]/(x^3+x+1)` and `F_9=F_3[x]/(x^2+1)`; exhaustive ordered-frame rigidity; the frozen C398
classification and C399/C465/C474 carrier inputs; and C475's universal edge-torus quotient.  The
certificate proves exactly the seven frozen rows.  It does not classify arbitrary non-GRS parents,
construct a new matching decoration, or extend the field census.

## Extra-juice closeout and mystery ledger

- **Settled — whether conic-valued syndromes force the C475 rank-one collision.**  No.  The q=11
  non-GRS parent gives twelve distinct atlases.  Contraction requires a conic parent and the
  resulting decomposable edge factorization, not merely a syndrome point on a conic.
- **Settled — whether a complete atlas family can recover the parent.**  No on every frozen row:
  the fixed-child parent-signature count is `1` for fibres of sizes `6,8,2,22`.
- **Settled in the requested second extra-juice pass — why parent blindness is maximal.**  The
  unlabelled atlas colouring has fibres `4 / 6 / 1+6 / 12`, exactly the full child point orbits, so
  its function stabilizer is the entire child group.  The transporter criterion
  `Stab_Gamma(f_A)=Stab_Gamma(A)` now explains both failure and the precise missing symmetry.
- **Settled — whether modular structure is hidden in the full-conic child's own deep holes.**  No.
  All three Coxeter conics are complete arcs, so their atlas domains are empty.
- **Settled — the first q=9/q=11 divergence.**  It is already Gram-theoretic (`3` versus `0`), and
  the independent Sylow check then gives stably zero versus endotrivial.
- **Settled — whether modular machinery belongs generally in the Reed--Solomon atlas lane.**  Only
  conditionally.  It belongs downstream of an independently recovering matching decoration, not
  as a repair for atlas fibres or parent blindness.
- **No genuine C478 mystery remains.**  The one unresolved C477 question about a coordinate-free
  derivation of the off-conic pentagon remains owned by a future separately allocated task; C478
  neither needs nor advances it.

## Vibe check

Excellent negative control: the atlas is stronger than expected for individual non-GRS syndromes
and simultaneously maximally blind to the parent.  The modular boundary is now sharp—decoration,
Gram degeneration, and Sylow invertibility are three separate gates rather than one suggestive
coincidence.
