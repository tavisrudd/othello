# C474 companion — decorated Reed--Solomon deep-hole recovery

**Date:** 2026-07-22

**Status:** exact four-class theorem; two recovering and two nonrecovering fibres; q=9 cube
precursor proved and its C474 Picard obstruction identified

## Result

C398 classifies every non-GRS six-arc `A` in `PG(2,q)` whose complete projective deepest-syndrome
locus

```text
U(A)=PG(2,q) minus union_(a != b in A) line(a,b)
```

is nonempty and contained in a nonsingular conic.  There are exactly four semilinear classes, at
`q=8,9,9,11`.  This report adds the first uniform decorated-fibre and fixed-code deep-hole analysis
across all four.

For `x in A`, the five-arc `A-{x}` determines a unique nonsingular conic `C_x`.  Define the
unlabelled **deletion-trace signature**

```text
Delta(A) = multiset_(x in A) (C_x intersect U(A)).              (1)
```

Fix the literal child `L=U(A)` and let its full semilinear stabilizer act on the parent.  Exact
frame-rigid enumeration gives:

| `q` | `|L|` | `|Stab(L)|` | parents above fixed `L` | block-size profile of `Delta` | distinct signatures | recovers parent? |
|---:|---:|---:|---:|:---|---:|:---:|
| 8 | 4 | 72 | 6 | `4,0,0,0,0,0` | 1 | no |
| 9 | 6 | 48 | 8 | `2,2,2,0,0,0` | 8 | **yes** |
| 9 | 7 | 12 | 2 | `1,1,1,1,1,1` | 1 | no |
| 11 | 12 | 1320 | 22 | `2,2,2,2,2,2` | 22 | **yes** |

Thus matching-decorated recovery is not unique to q=11.  The six-deep-hole q=9 class has a smaller
exact precursor:

```text
8 decorated parents
  = two sheets of 4 perfect matchings
  on K6 minus one perfect matching;

shared-trace graph on the 8 parents
  = K_(4,4) minus a perfect matching
  = the cube Q3.
```

Each sheet is a one-factorization of the same twelve-edge graph.  The full fixed-child group acts
faithfully as the order-48 automorphism group of the cube; its sheet stabilizer has order 24 and
acts as `S4` on the four matchings.

This q=9 precursor passes decorated recovery but fails the modular gateway sharply.  Over its
prime field `F_3`, after ordering the sheets the shared-trace and zero-share cross matrices are

```text
B = J-P,                    Z=P
```

for a permutation matrix `P`.  Hence

```text
rank(B)=3,   row(B)=augmentation(F_3^4),   rank(B B^T)=3,
rank(Z)=4,   row(Z)=F_3^4,                 rank(Z Z^T)=4.
```

The shared code is nondegenerate rather than Lagrangian, `row(B) != row(Z)^perp`, and the
four-point permutation augmentation splits from the fixed line.  A Sylow `C3` acts on a sheet as
`(3)(1)`, so its three-dimensional augmentation restricts to the regular projective `F_3 C3`
module.  It is therefore zero in the stable category, not an endotrivial Picard core.  The q=9
cube is a genuine decorated Reed--Solomon gateway and a decisive negative control for C474:
decorated recovery alone does not force a Picard carrier.

Finally, the same calculation classifies the projective deep-hole directions of each fixed parent
under its full semilinear code automorphism group:

| `q` | `|U(A)|` | parent automorphism order | projective deep-hole orbit sizes |
|---:|---:|---:|:---|
| 8 | 4 | 12 | `4` |
| 9 | 6 | 6 | `6` |
| 9 | 7 | 6 | `1+6` |
| 11 | 12 | 60 | `12` |

The seven-deep-hole q=9 code is the only row with inequivalent projective deep holes.  Its unique
fixed direction is intrinsic: it is the one locus point absent from all six singleton blocks in
`Delta(A)`.

## 1. Coding-theory meaning

Let `H_A` be a `3 x 6` parity-check matrix with projective column set `A`, and let
`C_A=ker(H_A)`, an `[6,3,4]_q` MDS code.  A nonzero projective syndrome direction `u` has coset
weight three exactly when it is on no line through two columns of `H_A`.  Consequently

```text
projective deepest-syndrome directions of C_A = U(A).          (2)
```

Equivalently, `u in U(A)` if and only if appending `u` to `H_A` gives a seven-arc and hence a
one-column `[7,4,4]_q` MDS extension.  This is the standard redundancy-three deep-hole/MDS-extension
dictionary used by C398 and by Kaipa for GRS parents.

Every child `L=U(A)` in the four C398 rows is itself an arc on a conic.  The code supported on the
whole child is therefore GRS, with parameters

```text
q=8:   [4,3,2]_8;
q=9:   [6,3,4]_9 and [7,3,5]_9;
q=11:  [12,3,10]_11.
```

The parent codes are non-GRS.  The theorem therefore describes a precise non-GRS-to-GRS transform:
the complete deepest-syndrome set of a non-GRS MDS parent is a GRS child, and in two of the four
possible conic-contained cases the deletion-trace decoration reverses that transform.

This is adjacent to, but not a solution of, the standard Reed--Solomon deep-hole conjectures.  The
classical problem fixes a GRS parent and classifies its individual deep holes.  Here the parent is
non-GRS and the first question is whether the complete child remembers which parent produced it.
The final orbit table does answer the individual projective classification question for these four
fixed non-GRS codes.

## 2. Why deletion traces are canonical

Five points of a six-arc impose five independent conditions on plane quadrics.  Their quadratic
evaluation nullspace is therefore one-dimensional, and its nonzero form is nonsingular: a
singular conic is a union of two lines over the algebraic closure and cannot contain a five-arc.
Thus `C_x` is intrinsic to the unlabelled pair `(A,x)`.

Intersecting `C_x` with `U(A)` removes all projective coordinate choices.  Forgetting the omitted
point `x` leaves the multiset (1), so `Delta(A)` is invariant under every semilinear projectivity.
It is also cheap: six nullspaces of `5 x 6` matrices and evaluations only on the deepest-syndrome
locus.

If `U(A)` lies on a chosen conic `Q` and `C_x != Q`, Bezout bounds the trace by two points.  A trace
larger than two means `C_x=Q`.  This explains the four observed profiles:

- q=8: one deletion conic is the containing conic and contributes all four points; the other five
  miss the locus;
- q=9, `|L|=6`: three deletion conics are secant to the child and three miss it;
- q=9, `|L|=7`: all six deletion conics are tangent to the child;
- q=11: all six are secant and their pairs partition the full conic.

The profile alone does not decide recovery.  Recovery is the injectivity of the complete trace
hypergraph across the fixed-child parent fibre.

## 3. Exact fixed-child fibre theorem

Let `Gamma L` be the full `PGammaL_3(q)` stabilizer of the literal locus `L`.  Since `L` is an arc
of size at least four, a semilinear projectivity in `Gamma L` is determined by:

1. a Frobenius power; and
2. the images of one ordered four-point projective frame in `L`.

Enumerating those possibilities is therefore exhaustive, not a cutoff.  The group orders and
parent orbit sizes are

```text
(q,|L|)=(8,4):    |Gamma L|=72,    |Gamma L . A|=6,   |Stab(A)|=12;
(q,|L|)=(9,6):    |Gamma L|=48,    |Gamma L . A|=8,   |Stab(A)|=6;
(q,|L|)=(9,7):    |Gamma L|=12,    |Gamma L . A|=2,   |Stab(A)|=6;
(q,|L|)=(11,12):  |Gamma L|=1320,  |Gamma L . A|=22,  |Stab(A)|=60.
```

For every parent in each orbit, the checker recomputes `U(A)=L` from the fifteen pair-secants,
constructs all six deletion conics, and canonicalizes the trace multiset.  The resulting signature
fibre sizes are

```text
q=8:       one signature with 6 parents;
q=9, |L|=6:  eight signatures with 1 parent each;
q=9, |L|=7:  one signature with 2 parents;
q=11:      twenty-two signatures with 1 parent each.
```

This proves the recovery table in the Result.

## 4. The q=9 cube theorem

In the recovering q=9 row, discard the three empty blocks in each signature.  The remaining three
two-point blocks are disjoint and cover all six child points, so every signature is a perfect
matching.

Across all eight signatures exactly twelve of the fifteen pairs occur.  The three missing pairs
are disjoint and cover all six points, hence form a perfect matching `N`.  The trace-block graph is
therefore

```text
K6 minus N = K_(2,2,2),
```

the octahedral graph.  Every occurring edge belongs to exactly two parent matchings.  Joining two
parents when they share a trace block gives a connected bipartite three-regular graph with parts
of size four; its cross matrix has exactly one zero in each row and column.  It is therefore

```text
K_(4,4) minus a perfect matching = Q3.
```

Each bipartition class contains four matchings, and every one of the twelve octahedral edges occurs
exactly once in each class.  Hence both classes are one-factorizations of `K6-N`.

The fixed-child action on the eight signatures is faithful of order 48.  Since `Aut(Q3)` has order
48, this is the full cube action.  The index-two sheet stabilizer has order 24; its induced action
on either four-set contains cycle profiles

```text
1^4, 1^2 2, 1 3, 2^2, 4
```

with multiplicities `1,6,8,3,6`, the complete `S4` profile.

This is a smaller analogue of the q=11 structure:

```text
q=9:   two 4-matching factorizations of K6-N, shared graph Q3;
q=11:  two 11-matching factorizations of K12, shared graph 6-regular on 22 vertices.
```

The analogy is exact at the decorated incidence level and fails at the modular carrier level.

## 5. Why q=9 does not produce a C474 carrier

Order the two q=9 sheets so the unique zero-share partner of each matching lies in the same
position.  The cross matrices are then `B=J-P` and `Z=P`.  Over `k=F_3`, row sums of `B` vanish,
and exact rank gives

```text
row(B)=A_4={v in k^4 : sum(v)=0},       dim(A_4)=3;
row(Z)=k^4.
```

Moreover

```text
B B^T = I-J,             Z Z^T=I
```

over `F_3`.  Their ranks are three and four.  Thus `A_4` is nondegenerate for the coordinate
pairing, not isotropic; in particular

```text
row(B) != row(Z)^perp=0.
```

The first incidence-to-Lagrangian gate of the Modular Gateway Theorem fails.

The stable gate fails independently.  Because `4` is nonzero in `F_3`,

```text
k^4 = k1 direct-sum A_4
```

already splits.  The sheet-preserving `S4` contains a Sylow `C3` acting as a three-cycle plus one
fixed point.  Projection along the fixed coordinate gives the explicit restricted-module
isomorphism

```text
kC3 -> A_4,
v |-> (-epsilon(v),v).
```

Hence `A_4|C3` is regular and projective.  Its dimension is divisible by three, which alone also
precludes endotriviality.  There is no nonzero stable Picard core and no nonsplit dual extension to
classify.

This negative is conceptually valuable.  The q=9 row proves that all of the following can occur
without C474:

```text
reversible deep-hole decoration,
two matching sheets,
two one-factorizations,
an exceptional highly symmetric shared graph,
a low-rank cross-incidence code.
```

What distinguishes q=11 is the bad-prime Gram degeneration and nonsplit augmentation, not the
existence of matching sheets by itself.

## 6. Individual deep-hole orbits

For each representative parent, the checker takes the subgroup of `Gamma L` fixing the parent and
computes its induced permutation group on `L=U(A)`.  The independent replay obtains the same
actions by normalizing every parent frame, without constructing the primary stabilizer matrices.

Three codes have a single orbit of projective deep holes.  For the q=9 seven-locus row, the trace
signature consists of six singleton blocks and omits one locus point.  Every code automorphism
preserves that point, and the order-six group is transitive on the other six.  Therefore

```text
U(A) = {u_fixed} disjoint-union orbit_6,
```

with `u_fixed` recognized without coordinates as the unique point absent from `Delta(A)`.

The classification is projective: it identifies syndrome directions modulo semilinear code
automorphisms.  It does not count all affine received words in each coset or quotient by arbitrary
monomial maps not induced by the recorded projective action.

## 7. What this says about the famous Reed--Solomon problem

The standard deep-hole problem fixes a generalized or standard Reed--Solomon code and seeks all
received words at covering radius.  Generalized Reed--Solomon deep-hole recognition is
co-NP-complete, while the Cheng--Murray programme and its variants prove classifications only in
particular parameter ranges.  The current theorem does not evade that complexity boundary.

It contributes three reusable ideas.

1. **Classify the decorated fibre, not only the syndrome set.**  The same GRS child can have many
   non-GRS parents.  A low-degree trace hypergraph can make the transform reversible.
2. **Separate support from coefficients.**  For a redundancy-three deep hole `u`, every triple of
   parent columns is a basis and expresses `u` with three nonzero coefficients.  The support set is
   therefore uninformative; the coefficient atlas is the first nontrivial decoration.
3. **Use modular incidence only after the Gram gate.**  q=9 shows that a beautiful matching-sheet
   structure can have a projective, stably zero core.  Endotrivial/Picard invariants should be
   computed only after orthogonality and Sylow tests pass.

For a parity-check arc `A={h_i}` and a deepest syndrome `u`, define

```text
d_ij(u)=det(u,h_i,h_j).
```

All `d_ij(u)` are nonzero exactly when `u` avoids every pair-secant.  Cramer's rule gives the
coefficients of `u` in every three-column basis as ratios of the `d_ij(u)` and the Pluecker
determinants `det(h_i,h_j,h_k)`.  The collection of those coefficients is a transition-compatible
line over the basis complex.  It is complete—one chart recovers `u`—but its quotient invariants,
such as products and cross-ratios of the `d_ij`, may be much smaller than the raw syndrome.

This is the correct point where C417's base-change cocycle, the Weil-roof cubic invariant, and
C474's descent language could enter the standard Reed--Solomon problem.  The next exact target is:

> For a fixed GRS evaluation set, determine whether bounded-degree invariants of the coefficient
> atlas separate the automorphism orbits of MDS-extension syndromes, and identify the exceptional
> fibres by a modular fusion signature.

That target is not proved here.  The present four-class theorem supplies positive and negative
controls for it: q=9 has reversible decoration but no stable core; q=11 has both.

## 8. Evidence and replay

The atomic bundle is:

- `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.md`;
- `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.py`;
- `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes-replay.py`;
- `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.json`;
- `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.py --check
python3 notes/2026-07-22-c474-reed-solomon-decorated-deep-holes-replay.py
sha256sum -c notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.sha256
```

The primary checker consumes the hash-pinned C398 certificate, reconstructs the four finite fields,
and enumerates each literal locus stabilizer by Frobenius powers and ordered-frame images.  Frame
rigidity proves exhaustion.  It recomputes every parent locus, deletion conic, trace signature,
signature stabilizer, matching relation, incidence rank, Gram rank, and fixed-parent deep-hole
orbit.

The independent replay imports no primary code.  It fixes a canonical child by independently
normalizing every ordered locus frame, reconstructs each fixed-child parent fibre without explicit
stabilizer matrices, recomputes all trace signatures and matching graphs, and separately fixes a
canonical parent to recover the deep-hole orbit decomposition.  It agrees on all four parent and
signature counts, both recovering relations, both modular ranks, and all four orbit profiles.

Trusted boundary: exact arithmetic in the C398 polynomial-basis fields; the C398 all-field
classification and its independent syndrome check; exhaustive finite frame normalization; and the
standard redundancy-three arc/MDS/deep-hole dictionary.  The certificate proves only the four
C398 conic-contained non-GRS classes.  It does not classify arbitrary non-GRS codes, ordinary
affine received words, or deep holes of every Reed--Solomon code.

## Literature boundary

C398 already contains the claim-specific full-text and citation audit for this exact four-class
domain.  It treats the q=11 complete exterior six-set as classical, Kaipa's
deep-hole/MDS-extension theorem as the mandatory GRS-parent boundary, and recent non-GRS
constructions as adjacent rather than exhaustive.  This report makes no novelty or priority claim
for one-factorizations, the q=11 biplane, Reed--Solomon deep-hole dictionaries, or the abstract use
of conics.

The new finite statement is recorded only as a proved project result: the deletion-trace signature
recovers exactly the `(q,|L|)=(9,6),(11,12)` fixed-child fibres, the q=9 recovering relation is the
cube with an exact projective modular core, and the four fixed codes have the displayed projective
deep-hole orbit profiles.  External novelty wording requires its own forward audit for deletion-
conic trace hypergraphs and decorated MDS-extension fibres.

## Extra-juice closeout and mystery ledger

- **Settled — whether q=11 decorated recovery is isolated.**  It is not.  The q=9 six-locus row is
  a second exact recovering fibre, with eight parents and a cube relation.
- **Settled — the smaller matching geometry.**  The q=9 traces are two one-factorizations of
  `K6` minus a perfect matching; the full child group is `Aut(Q3)` and the sheet action is `S4`.
- **Settled — whether q=9 opens another C474 Picard carrier.**  It does not.  Both the orthogonal
  code gate and the Sylow endotrivial gate fail: the shared code is nondegenerate augmentation and
  restricts projectively to `C3`.
- **Settled — individual deep-hole equivalence in the four-class domain.**  Three parent codes are
  transitive on their projective deepest syndromes.  The q=9 seven-locus code has exactly the
  intrinsic `1+6` split detected by the missing singleton trace.
- **Settled — support-only decoration for redundancy three.**  It is always trivial on a deep
  syndrome because every column triple is a basis with nonzero coefficients.  The first useful
  standard-RS refinement must retain the coefficient atlas.
- **Open — coefficient-atlas separation for a GRS family.**  No bounded-degree invariant theorem
  is yet proved.  The exact gate is an orbit calculation showing whether determinant cross-ratios
  or cubic products separate MDS-extension syndromes uniformly in a stated parameter range.
- **Open — modular fusion beyond q=11.**  q=9 fails before fusion.  A third positive Picard-core
  example requires a new decorated family satisfying both the Lagrangian Gram gate and the Sylow
  endomorphism-projectivity gate.
- **No mystery remains in the four C398 fibres.**  Parent counts, signature fibres, matching
  structures, modular ranks, and projective deep-hole orbits are completely determined.
