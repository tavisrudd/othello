# C521 — Clebsch fixed-conic reconstruction

**Lane:** `clebsch`

**Date:** 2026-07-23

**Verdict:** `PROOF-ONLY HOMOGENEOUS FIBRE AND 11+11 ORIENTATION TORSOR; SHARP
THREE-CENTRE RECOVERY REMAINS CERTIFICATE-BACKED; COMPANION RESULT, EXCLUDED FROM PAPER 1`

## Result

Let a group `Gamma` act on parent objects `P` and child objects `Y`, and let
`f : P -> Y` be equivariant.  For `y in Y`, write

```text
Gamma_y = {g in Gamma : g y = y},       P_y = f^{-1}(y).
```

Then `Gamma_y` acts on `P_y`.  If `p in P_y` and the fixed-child rigidity
hypothesis

```text
P_y = Gamma_y . p                                           (1)
```

holds, the orbit map gives a canonical `Gamma_y`-equivariant bijection

```text
Gamma_y / Gamma_p  ->  P_y,          g Gamma_p |-> g p.      (2)
```

Without (1), the exact statement is the orbit decomposition

```text
P_y = disjoint union_[p] Gamma_y / Gamma_p,                  (3)
```

over representatives of the `Gamma_y`-orbits.  Thus “the fixed-child fibre is
a homogeneous space” is not a consequence of equivariance alone: transitivity
on that literal fibre is the necessary additional input.

For the Clebsch parent with complete child the full rational conic
`C = U(A) subset PG(2,11)`, take the projective child stabilizer.  The standard
conic action and the established Clebsch-marker identification give

```text
Gamma_C = Stab_PGL3(11)(C) ~= PGL_2(11),
Gamma_A ~= A5,
X_C = {A' : U(A')=C} ~= PGL_2(11) / A5,
|X_C| = 1320 / 60 = 22.                                   (4)
```

The identification in (4) uses the already established fact that the 22
fixed-child parents form one conic-stabilizer orbit; it does not derive that
classification from orbit--stabilizer.  Conversely, once transitivity and the
`A5` stabilizer are known, the count 22 is conceptual and needs no enumeration.

Let

```text
epsilon : PGL_2(11) -> F_11^* / (F_11^*)^2 ~= C2
```

be determinant square class.  It is well defined on projective matrices and
has kernel `PSL_2(11)`.  The restriction of `epsilon` to `A5` is trivial:
it is a homomorphism from the perfect group `A5` to `C2`.  Hence
`A5 subset PSL_2(11)`, and restriction of (4) to `PSL_2(11)` gives exactly
two orbits,

```text
X_C = X_C^+ disjoint union X_C^-,
|X_C^+| = |X_C^-| = 660 / 60 = 11.                         (5)
```

The quotient `X_C / PSL_2(11)` is intrinsically a two-element torsor.  Choosing
one parent labels its two halves by determinant square class; changing the
chosen parent by an outer element swaps the labels.  Thus (5) is an intrinsic
**determinant-orientation torsor**, but it has no preferred sign.

This is not identified here with the manuscript's intrinsic unordered
`10+10` leader-support bipartition.  C486 gives an exact certificate-backed
bridge from the 22 fixed-child parents, through deletion traces and a conic
parametrisation, to C445's two matching sheets and their torsor `T_11`.  No
equivariant comparison from (5) to the decoder's leader-support bipartition
has been proved.  Calling the two objects the same “chirality” would therefore
erase a real missing map.

## Sharp three-centre recovery

For distinct parents `A,B in X_C` and one diagonal label transporter `pi`,
let

```text
D_(A,B,pi) = {u in C : atlas_A(u) != pi.atlas_B(u)}.         (6)
```

A selected centre set `T subset C` recovers the parent exactly when it meets
every disagreement set (6).  C490 certifies for the q=11 fibre:

```text
79 distinct disagreement masks,
and every mask has size 10, 11, or 12.                      (7)
```

There are exactly

```text
binom(12,2) + binom(12,1) + binom(12,0) = 79
```

subsets of a 12-set having those sizes.  Therefore (7) says more transparently
that the support of the disagreement hypergraph is

```text
{C - S : S subset C, |S| <= 2}.                            (8)
```

The base-size conclusion is now a one-line incidence proof:

- if `|T| <= 2`, the mask `C-T` is disjoint from `T`, so recovery fails;
- if `|T| = 3`, every mask has complement of size at most two, so every mask
  meets `T`, and recovery holds.

Thus the exact coherent-projection base size is three, every pair fails, and
every triple works.

The group action explains the striking uniformity but does not replace the
finite evidence.  `PGL_2(11)` is sharply three-transitive on
`C ~= P1(F_11)`, and the disagreement hypergraph is equivariant.  Hence one
mask with a given complement size at most three forces the complete orbit of
such masks.  What remains certificate-backed is the load-bearing assertion
that the exhaustive fixed-child parent list is complete and that no
disagreement masks outside the three sizes in (7) occur.  The incidence
argument from (7) to base size three is proof-only.

## Trust boundary

The proof-only layer consists of:

1. the equivariant fibre lemma (2)--(3);
2. orbit--stabilizer and the standard conic action;
3. the determinant-square-class proof of the `11+11` split;
4. the torsor/no-preferred-sign boundary; and
5. the hypergraph deduction `(7) => (8) => base size 3`.

The imported exact inputs are:

- C398/C399 and the classical Edge--Dye geometry: identification of the
  Clebsch fixed-child objects with one 22-marker conic orbit and stabilizer
  `A5`;
- C474: direct fixed-child orbit size `22`, child-stabilizer order `1320`,
  parent-stabilizer order `60`, and deletion-trace recovery;
- C445/C486: the exact bridge to the matching-orientation torsor `T_11`; and
- C490: complete fixed-child parent enumeration, all diagonal transporters,
  the 79 disagreement masks, and the sharp coherent base-size table.

No new finite computation is introduced.  The C490 atomic bundle is

```text
notes/2026-07-22-c490-small-field-base-size-closure.py
notes/2026-07-22-c490-small-field-base-size-closure.json
notes/2026-07-22-c490-small-field-base-size-closure-replay.py
notes/2026-07-22-c490-small-field-base-size-closure.sha256
```

and replays from `/home/tavis/src/othello` with

```bash
python3 notes/2026-07-22-c490-small-field-base-size-closure.py --check
python3 notes/2026-07-22-c490-small-field-base-size-closure-replay.py
sha256sum -c notes/2026-07-22-c490-small-field-base-size-closure.sha256
```

The committed manifest records SHA-256 hashes and byte counts for the report,
generator, 379825-byte JSON certificate, 8010-byte independent replay, and
load-bearing C398/C478 inputs.  The independent replay recomputes every emitted
parent and all 31,235,760 transporter comparisons, but does not independently
enumerate missing parents.  Completeness of the parent list remains trusted to
the primary child-derived candidate-line enumeration and its exact orbit
accounting.

## Literature boundary

This report imports the C399 audit rather than making a new absence claim.  Its
source ledger contains eight full-text readings.  The load-bearing entries
here are:

- Edge, *Conics and orthogonal projectivities in a finite plane* (1956),
  **full text**, published 21-page PDF, C399 cache SHA-256
  `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`;
  it supplies the classical `5,14,22` conic-marker fibres and conic-group
  action.
- Dye, *Hexagons, conics, A5 and PSL2(K)* (1991),
  **full text**, published pp. 270--286, OCR reconstruction SHA-256
  `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`;
  the load-bearing pages were checked against the authoritative images, and
  its theorems give the q=11 transitivity, stabilizer, and count.
- Giudici, *Maximal subgroups of almost simple groups with socle PSL(2,q)*,
  arXiv:math/0703685, **full text**, all 11 pages, SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`;
  it supplies the relevant `PSL_2/PGL_2` subgroup-fusion boundary.

Accordingly, neither the 22-space, its `A5` stabilizer, nor its coarse
`11+11` group split is presented as novel.  The general homogeneous-fibre
lemma is elementary orbit theory.  No external novelty claim is made for the
C490 three-centre reconstruction theorem; manuscript-facing novelty wording
for coherent projection signatures would require a separate claim-specific
forward audit.

## Paper disposition

**Disposition: companion result; exclude C521 from Paper 1.**

Paper 1 already has the stronger paper-shaped C445/C486 matching and torsor
statements.  Adding the elementary quotient lemma plus a certificate-heavy
three-centre reconstruction theorem would create a second reconstruction
spine and blur the conceptual/certificate boundary.  A future Paper 2
reconstruction section may cite this companion as the clean interface:

```text
classical homogeneous 22-fibre
  -> determinant-orientation torsor 11+11
  -> certified coherent-signature disagreement hypergraph
  -> exact decorated base size 3.
```

No manuscript source change is warranted by C521.

## Extra-juice closeout

The free upgrade is (8): C490's table did not merely say that every triple
works.  Its `79` masks and size set `10,11,12` force the complete
co-two-subset hypergraph.  This packages the sharp base size as a tiny
incidence theorem and localizes the computation to exactly one premise.

The second free clarification is categorical.  The two `PSL_2(11)` halves
are not two independently named geometric species; they are the fibres of a
free two-element quotient with outer `PGL_2(11)` exchange.  This explains why
a one-bit orientation can be real while no canonical `+/-` naming exists.

## Mystery ledger

- **Settled — why the fixed-child fibre has size 22.**  Once classical
  transitivity and the `A5` stabilizer are supplied, it is the index
  `|PGL_2(11):A5|`.
- **Settled — why it splits as `11+11`.**  `A5` lies in the determinant-square
  kernel `PSL_2(11)`, whose index in `PGL_2(11)` is two.
- **Settled — why every triple and no pair recovers.**  The certified mask
  support is exactly all complements of subsets of size at most two.
- **Open boundary, not promoted — support chirality comparison.**  C486
  identifies the parent quotient with the matching torsor `T_11`, but no
  equivariant map to the decoder's intrinsic `10+10` leader-support
  bipartition is proved.  This evidence gap must close before those
  chiralities are identified.
- **No remaining C521 acceptance mystery.**  The theorem, trust split,
  literature boundary, and disposition are explicit.

## Vibe check

This closes cleanly: most of the 22-space is classical rather than a new
headline, but the exact separation between orbit theory and the C490
certificate is sharper than before, and the base-three result now has a
memorable incidence proof.
