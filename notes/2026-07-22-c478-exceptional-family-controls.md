# C478 — exceptional-family atlas controls

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete, with coherence upgrade.  Fibrewise unlabelling retains exactly the full
child's point-orbit colouring and no parent information, but one global support relabelling across
several syndrome fibres changes the answer completely: the Galois-equivariant coherent atlas
recovers all four frozen parent fibres, using at most three syndrome points.  The `A3/B3/H3`
full-conic children have no deep-syndrome atlas domain, and coherent geometric recovery still does
not imply a modular carrier.

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
syndrome scaling and independent column scaling.  Parent comparison has two genuinely different
quotients: independent support relabelling in every syndrome fibre, or one diagonal relabelling
shared coherently by the whole family.  Frobenius must act on the retained field colours
equivariantly; quotienting those colours is an additional, strictly lossy operation at q=8.

The exact cross-family table is:

| family | atlas domain | syndrome orbits recovered by (1) | fixed-child parents / Coxeter decorations | pointwise / coherent-equivariant parent signatures | least coherent syndrome fibres | deletion trace recovers parent? | shared Gram rank | modular verdict |
|:---|:---:|:---:|---:|---:|:---:|:---:|:---:|:---:|
| C398 q=8, `|U|=4` | 4 | `4` | 6 | `1 / 6` | 3 | no | — | not entered |
| C398 q=9 cube, `|U|=6` | 6 | `6` | 8 | `1 / 8` | 3 | yes | `3` over `F_3` | **fails** |
| C398 q=9, `|U|=7` | 7 | `1+6` | 2 | `1 / 2` | 2 | no | — | not entered |
| C398 q=11 matching, `|U|=12` | 12 | `12` | 22 | `1 / 22` | 3 | yes | `0` over `F_3` | **passes** |
| `A3` conic phase q=5 | 0 | vacuous | 5 | — | — | bare child no | — | no equal sheet pair |
| `B3` conic phase q=7 | 0 | vacuous | 14 | — | — | bare child no | `0` over `F_2` | **passes when pointed** |
| `H3` conic phase q=11 | 0 | vacuous | 22 | — | — | bare child no | `0` over `F_3` | **passes when pointed** |

Here “independent decoration” is C474's deletion-trace signature in the C398 rows.  For the Coxeter
rows the bare full-conic child forgets among the classical `5,14,22` decorations; the q=7 and q=11
positive modular statements consume the already-pointed matching sheets certified by C465/C474.
They do not assert that the unmarked child reconstructs a sheet.

This proves the sharp negative requested by the task:

> Fibrewise atlas values do not recover the parent; coherent atlas transport does recover every
> frozen parent fibre.  Even that stronger geometric recovery does not imply modular invertibility:
> the q=9 cube is an exact recovering control that fails both Gram and Sylow gates.

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

There is also a uniform geometric meaning that was hidden by determinant notation.  Put
`W_u=F^3/<u>`.  A volume form on `F^3` induces an alternating form on `W_u` with

```text
d_ij(u)=<bar(h_i),bar(h_j)>_u.                            (2)
```

Deepness says that the six projected points `bar(h_i)` in `P(W_u)=P1` are distinct.  C475's exact
edge-torus quotient therefore identifies the atlas with the projective moduli of the six-point
configuration obtained by projecting the parent from `u`.  The fibrewise atlas is a projected
binary sextic; the coherent family remembers how the same six parent points correspond across
different projection centres.

## 2. Fibrewise blindness and the coherent lift

Fix the literal child `L=U(A)`.  For every parent above it, canonicalize each syndrome atlas over
all support relabellings and Frobenius powers, and retain the resulting function on the literal
points of `L`.  Across the four fixed-child fibres of sizes

```text
6, 8, 2, 22,
```

the numbers of distinct pointwise-quotiented functions are

```text
1, 1, 1, 1.                                             (3)
```

Thus independent unlabelling in every syndrome fibre never recovers the parent.  It discards the
correspondence between the six projected points at different centres.  By contrast, deletion
traces recover exactly the q=9 six-locus and q=11 full-conic fibres.

```text
determinant atlas:   syndrome inside a fixed parent;
deletion trace:      parent above a fixed child.
```

Keeping raw support labels would make the parent visible tautologically, but requiring one common
`S6` relabelling across all fibres does not: it is exactly the intrinsic quotient of one unlabelled
parent set.  The earlier pointwise quotient was therefore a deliberately stronger information loss,
not the final parent-recovery test.

The requested extra-juice pass gives a structural explanation for the maximal blindness.  Let
`Gamma=Stab_PGammaL(L)`, let `X` be the unlabelled/Frobenius atlas space, and write

```text
f_A : L -> X,                    u |-> canonical atlas of (A,u).
```

Covariance of determinants gives the exact transporter identity

```text
f_(gA)(u)=f_A(g^-1 u),           g in Gamma.             (4)
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
4;  6;  1+6;  12.                                      (5)
```

These are exactly the point-orbit partitions of the full child stabilizers, not merely coarsenings
of them.  Hence `f_A` is `Gamma`-invariant and

```text
Stab_Gamma(f_A)=Gamma                                  (6)
```

in every row.  Equation (6) forces the one-signature pointwise collapse in (3).  The q=9 seven-point
case is the informative exception to “one colour”: its two atlas values recognize the child's
intrinsic fixed point and six-orbit, but still retain no parent-specific decoration.

Now retain the whole family and quotient by only one diagonal `S6`.  The exact parent-signature
counts jump to

```text
6, 8, 2, 22,                                            (7)
```

so the Galois-equivariant coherent atlas recovers every frozen parent.  Exhausting syndrome-subset
orbits under the full child groups gives the sharp minimum numbers of fibres needed:

```text
q=8: 3,       q=9 cube: 3,       q=9 seven-locus: 2,       q=11: 3.   (8)
```

For q=11 all `220` triples recover all `22` parents.  For the q=9 cube, one of the two triple
orbits recovers all eight parents while the other leaves seven signatures; for the seven-locus
row, one pair orbit already separates its two parents.  At q=8 every triple recovers all six.

There is one further Galois warning.  If the field colours of the coherent family are themselves
quotiented by a common Frobenius power, the signature counts become

```text
2, 8, 2, 22,                                            (9)
```

with q=8 fibres `3+3`.  Without that colour quotient q=8 has six singleton signatures.  The
residual triples are therefore exactly the `Gal(F_8/F_2)=C3` orientation that was erased, not an
unexplained geometric collision.  In a semilinear formulation Frobenius must act equivariantly on
the colour space and on `L`; it must not be silently modded out on colours while the literal child
points are held fixed.

## 3. The full-conic controls

For each fixed C399 conic phase, direct projective enumeration verifies that the invariant conic
has `q+1=6,8,12` points and every point outside it lies on a conic secant.  Hence the full conic is
a complete arc and has zero one-column MDS extensions:

```text
U(C(F_q))=emptyset,             q=5,7,11.               (10)
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

Both matching C398 rows have two sheets and exact coherent-atlas parent recovery.  Their first
modular difference is already the Gram gate.

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

1. intrinsic parent recovery together with an additional canonical organization into two equal
   sheets and cross relations;
2. over a coefficient field `k`, nonzero sheet degree and the exact orthogonal identities
   `D=k1 direct-sum S` and `S=D^perp`;
3. a nonsplit augmentation `0 -> S -> A -> S^* -> 0`;
4. `dim(S)` nonzero in `k` and projectivity of `End_k(S)_0` on a Sylow subgroup;
5. a one-dimensional fusion-compatible local `H^1` line containing the nonzero restricted
   extension; and
6. nonisomorphic simple endpoints with scalar endomorphism rings.

These are exactly the load-bearing hypotheses of the proved C474 Modular Gateway Theorem, grouped
to expose where the atlas stops contributing.  The coherent atlas now supplies parent recovery in
all four frozen C398 rows, but only q=9 six-locus and q=11 carry the required matching-sheet
organization.  The q=9 cube then fails conditions 2 and 4.  The pointed q=7 and q=11 matching
carriers pass all six groups of conditions.

## 6. Next level exposed

The strongest successor is no longer “try another scalar invariant.”  It is a **simultaneous
projection reconstruction theorem**.

1. For each deep centre `u`, identify (1) with the moduli point of the projected sextic
   `pi_u(A) subset P(F^3/<u>)` using (2).
2. Retain one diagonal `S6` correspondence across two or three centres, while allowing the natural
   independent `PGL_2` gauge in each quotient line.
3. Solve the compatibility equations saying that the six reconstructed lines through the
   different centres meet in one common six-arc.
4. Prove that three suitably positioned centres determine the parent away from an explicit
   discriminant; classify the two-centre exceptional fibres.

The frozen evidence is unusually sharp support for this programme: three centres suffice at
q=8, the q=9 cube, and q=11, while a distinguished pair already suffices for the q=9 seven-locus
row.  The full subset-orbit certificate records the lower failures as well as the successful
witness orbits, so this is not inferred from one lucky ordering.

The q=8 row exposes the descent refinement.  A colour-orbit quotient leaves two sheets of three,
whereas the Galois-equivariant coloured family recovers all six parents.  A general theorem must
therefore formulate Frobenius as an action on the atlas bundle, not erase it fibrewise.  This is an
exact small-field model for the unallocated semilinear-tower question; a broader task should be
allocated only if the three-centre equations turn that `C3` orientation into a structural descent
class rather than a one-case observation.

Finally, coherent recovery can reconstruct deletion traces and matching relations from the parent,
but q=9 proves that it still cannot predict modular invertibility.  The proper pipeline for the
next level is consequently

```text
coherent projected sextics -> parent reconstruction -> matching-sheet test
                            -> Gram gate -> Sylow gate -> modular carrier.
```

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
reconstructs only the already-fixed locus and parent stabilizers, distinguishes independent
fibrewise relabelling from one diagonal `S6`, separately records Galois-equivariant colours and
their Frobenius-orbit quotient, exhausts child-group orbits of syndrome subsets through the first
recovering level, checks the three complete-conic loci, and recomputes the load-bearing Gram ranks.

The independent replay implements its own arithmetic for `F_8`, `F_9`, and the three prime fields;
constructs the semilinear frame actions independently; repeats the pointwise, coherent, coloured,
and syndrome-subset orbit calculations with a separate edge-permutation canonicalizer; repeats the
full-conic checks; recomputes the Gram ranks; and verifies directly that the q=9 augmentation has a
regular three-vector `C3` orbit.  It imports neither new primary code nor its computed values.

Trusted boundary: Python integer/JSON correctness; the displayed polynomial bases
`F_8=F_2[x]/(x^3+x+1)` and `F_9=F_3[x]/(x^2+1)`; exhaustive ordered-frame rigidity; the frozen C398
classification and C399/C465/C474 carrier inputs; and C475's universal edge-torus quotient.  The
certificate proves exactly the seven frozen rows.  It does not classify arbitrary non-GRS parents,
construct a new matching decoration, or extend the field census.

## Extra-juice closeout and mystery ledger

- **Settled — whether conic-valued syndromes force the C475 rank-one collision.**  No.  The q=11
  non-GRS parent gives twelve distinct atlases.  Contraction requires a conic parent and the
  resulting decomposable edge factorization, not merely a syndrome point on a conic.
- **Settled — whether a coherent atlas family can recover the parent.**  Yes on every frozen row.
  The pointwise quotient has one parent signature, but one diagonal `S6` with Galois-equivariant
  colours gives `6,8,2,22` singleton signatures.
- **Settled in the requested second extra-juice pass — why fibrewise parent blindness is maximal.**  The
  unlabelled atlas colouring has fibres `4 / 6 / 1+6 / 12`, exactly the full child point orbits, so
  its function stabilizer is the entire child group.  The transporter criterion
  `Stab_Gamma(f_A)=Stab_Gamma(A)` explains the fibrewise failure and identifies coherence as the
  missing datum.
- **Settled in the requested third extra-juice pass — the cheap coherence threshold.**  Exact
  child-subset orbit exhaustion shows that `3,3,2,3` syndrome fibres suffice and are minimal for
  q=8, q=9 six-locus, q=9 seven-locus, and q=11 respectively.
- **Settled — the q=8 threefold residual.**  Quotienting coherent colours by common Frobenius gives
  two fibres of three; retaining the `Gal(F_8/F_2)` action equivariantly gives six singletons.  The
  apparent collision is exactly erased Galois orientation.
- **Settled — whether modular structure is hidden in the full-conic child's own deep holes.**  No.
  All three Coxeter conics are complete arcs, so their atlas domains are empty.
- **Settled — the first q=9/q=11 divergence.**  It is already Gram-theoretic (`3` versus `0`), and
  the independent Sylow check then gives stably zero versus endotrivial.
- **Settled — whether modular machinery belongs generally in the Reed--Solomon atlas lane.**  Only
  conditionally.  It belongs downstream of coherent parent recovery and an independently verified
  matching-sheet/Gram/Sylow chain.
- **Open only as a successor theorem — simultaneous projection reconstruction.**  The finite
  controls prove the exact `3,3,2,3` thresholds, but not an all-field theorem that three generic
  centres reconstruct a six-arc or a formula for its discriminant.  That is the precise next-level
  evidence gap; it requires a newly allocated Reed--Solomon task.
- **No other C478 mystery remains.**  Pointwise loss, coherent recovery, the q=8 Galois orientation,
  full-conic emptiness, and the modular gate split all replay independently.

## Vibe check

Excellent: what looked like maximal atlas blindness was exactly an overquotient.  Restoring diagonal
coherence upgrades four finite negatives to exact parent recovery with at most three syndrome
fibres, while q=9 still cleanly proves that geometric recovery and modular invertibility are
separate achievements.
