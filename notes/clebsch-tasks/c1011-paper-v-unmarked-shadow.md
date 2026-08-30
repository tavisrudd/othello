# C1011 — Paper V unmarked metric-shadow obstruction

**Lane:** `clebsch`  
**Status:** exact finite evidence and human algebraic/query proofs complete.  
**Scope:** no manuscript or Ergodis source files were edited.

## Verdict

Paper V has a useful strengthening, but it is a boundary theorem rather than
a new standalone paper by itself.  The singular rational normal quartic
recovers the six axes only relative to the retained (A_5)-action (or an
equivalent (H_3) matching marker).  Its natural unmarked metric shadows do
not recover that carrier: their symmetry is the full
(operatorname{PGL}_2(11)), of order (1320), rather than (A_5), of
order (60).

This makes the phrase “the singular quartic recovers the six axes” precise.
The recovery is (G)-relative, not intrinsic to the unmarked quartic and its
ambient quadratic form.

## 1. The quartic Gram-shadow theorem

Let (R\cong\mathbf P^1(\mathbf F_{11})) be Paper V's twelve-point rational
normal quartic in the five-dimensional quadratic space.  Exact computation
from the paper-owned sparse-shadow export gives:

- all twelve points are isotropic;
- no two distinct points are orthogonal;
- the projective Gram character of every triple is (+1);
- among the (495) four-sets, (165) have Gram character (+1) and (330)
  have Gram character (-1).

There is a uniform explanation.  On a rational normal quartic, the invariant
bilinear pairing satisfies, up to a nonzero global scalar,

\[
 B(v_{[s:t]},v_{[u:v]})=(sv-tu)^4.
\]

Normalize four distinct parameters to
((\infty,0,1,\lambda)).  Their Gram determinant is

\[
 16\lambda^2(1-\lambda)^2(\lambda^2-\lambda+1),
\]

up to a square arising from the chosen projective representatives.  Hence

\[
 \boxed{\chi(\det \operatorname{Gram})
       =\chi(\lambda^2-\lambda+1).}
\]

At (q=11), this character is positive exactly for the harmonic cross-ratio
orbit

\[
 \lambda\in\{-1,2,1/2\}.
\]

Thus the positive four-sets are precisely the harmonic quadruples.  They form
a (3\!-!(12,4,3)) design: every point lies in (55) blocks, every pair in
(15), and every triple in (3).

The full automorphism group of this design has order (1320) and is
(operatorname{PGL}_2(11)).  The certificate obtains the lower bound by
enumerating the projective fractional-linear action and proves the matching
upper bound by checking that an automorphism fixing one ordered triple is the
identity.  The latter check has only (9!) candidates.  A manuscript version
should replace that last finite check by a short recognition lemma or a
standard citation for the harmonic quadruple design if a clean source is
available.

### No-go consequence

The unmarked pair shadow and triangle shadow are constant, while the first
nonconstant projective metric invariant—the four-set Gram character—still has
automorphism group (operatorname{PGL}_2(11)).  Therefore none of these data
can distinguish the Paper V subgroup (A_5), its six Sylow-5 axes, or the
six stabilizer pairs on (R).

This is a concrete instance of C1005's fusion-subalgebra obstruction: the
metric shadow has strictly more automorphisms than the desired marked
geometry.

## 2. The exact missing marker

Paper II's (H_3) orbit consists of exactly (22) perfect matchings on
(mathbf P^1(\mathbf F_{11})).  The full projective group acts transitively
on them, and the stabilizer of any one matching is (A_5):

\[
 \operatorname{PGL}_2(11)/A_5,
 \qquad 1320/60=22.
\]

Selecting one such matching therefore restores precisely the missing
(A_5)-marking.  Its six edges are the six exact (C_5)-stabilizer pairs,
and hence the six axes used by Paper V.

The resulting information-loss ledger has three distinct entries:

1. forgetting the (H_3) matching gives a (22)-element carrier ambiguity;
2. after the carrier is fixed, forgetting the selected chordal line gives
   Paper V's residual (C_2)-torsor;
3. conference global negation gives the separate conference/Frobenius
   (C_2)-torsor.

The first ambiguity is not another torsor of order two and should not be
conflated with either of the latter two.

## 3. Exact cost of recovering the matching by edge queries

Suppose the hidden marker is one of the (22) (H_3) matchings and a binary
query asks whether a specified pair of quartic points is one of its edges.
Each of the (66) point pairs belongs to exactly two candidate matchings.
Consequently the query system is a simple (6)-regular graph on the (22)
candidates, with one graph edge per query.

### Nonadaptive optimum: 14

For a fixed set of queries, two candidates have the same answer word exactly
when they are two isolated vertices or the two vertices of a selected
(K_2)-component.  A separating query graph may therefore have at most one
isolated vertex and no component of order two.  Covering the other (21)
vertices by components of order at least three requires at least

\[
 21-7=14
\]

edges.  The certificate exhibits seven disjoint selected (P_3)'s and one
isolated vertex, attaining the bound.

### Adaptive optimum: 11

Along an all-negative branch, one query removes at most two candidates.
After ten negative answers at least two of the (22) candidates remain, so
depth at least (11) is necessary.  For the upper bound, the certificate
exhibits ten pairwise disjoint query edges.  A positive answer leaves the two
endpoints and one additional incident query separates them.  Ten negative
answers leave two unmatched candidates, again separated by one query.  Thus

\[
 \boxed{Q_{\mathrm{adaptive}}=11,
 \qquad Q_{\mathrm{nonadaptive}}=14.}
\]

These constants are a useful optional corollary, not part of Paper V's main
spine.

## 4. Ergodis control result

The protected control run used the (66) point pairs as rows.  Its unmarked
features were orthogonality, the numbers of positive and negative Gram
four-blocks through the pair, and the number of positive Gram triples through
the pair.  Every row has the same feature vector

\[
 (0,15,30,10).
\]

The target label was membership in one fixed six-edge (H_3) matching.
`ceiling` returned one ambiguous feature group of weight (66), with six
unavoidable errors.  This is an exact controller certificate that the chosen
unmarked local features cannot recover even the axis-pair relation.

Ergodis did not prove the group-theoretic or universal statements; those rest
on the displayed algebra and exact group/design certificates.

## 5. Publication routing

### Best immediate use: strengthen Paper V

Add a compact proposition or boundary remark after the quartic-to-axis
recovery theorem:

- identify the positive four-Gram shadow with the harmonic
  (3\!-!(12,4,3)) design;
- state that its automorphism group is (operatorname{PGL}_2(11));
- conclude that the six-axis recovery is relative to the (A_5)-marking;
- identify an (H_3) matching as the exact natural marker reducing the group
  from (operatorname{PGL}_2(11)) to (A_5).

This materially strengthens Paper V's information-loss theme and prevents an
absolute-reconstruction misreading.  It does not require changing the main
reconstruction maps.

### Combined standalone prospect

The result becomes a credible component of a sparse-shadow
reconstruction/no-go paper when combined with:

- C1008/C1010's positive (q=13) result, where one unweighted relation graph
  generates the full Bose--Mesner algebra and recovers the geometry;
- the general multiplicity-free/full-commutant criterion of C1005;
- Paper II's faithful-on-carrier/nonfaithful-off-carrier trade boundary; and
- the present Paper V example, where the first nonconstant metric shadow is a
  proper fusion with excess projective symmetry.

That combination has a clean dichotomy: a small shadow either separates all
constituents and reconstructs the carrier, or lies in a proper fusion and its
excess automorphisms certify impossibility.  Paper V alone is not enough for a
standalone article.  This comparison should be handed to the already queued
C1006 publication successor rather than opening a duplicate integration task.

### Relation to already banked Paper V successors

C904's tame (2,3,5) stabilizer tower is complementary, not superseded.  The
present result explains what must be marked before the exact
(C_5,C_3,C_2) stabilizer divisors can be interpreted as the intended
(A_5)-carrier.  A larger Paper V epilogue could pair the two:

1. the (H_3) matching selects (A_5\subset\operatorname{PGL}_2(11));
2. the selected action yields the degree (12,20,30) inertia divisors and
   the free locus;
3. the (C_5) divisor maps two-to-one onto the six Paper V axes.

The tower is already banked and still needs its stated literature and
scheme-level audit before promotion.

## 6. Post-proof deliverables

For Paper V integration:

1. a short invariant-Gram lemma with the displayed cross-ratio formula;
2. a harmonic-design recognition lemma and a proof/citation for its full
   automorphism group;
3. the relative-recovery/no-go corollary;
4. a marking ledger distinguishing the index-(22) ambiguity from the two
   (C_2)-ambiguities;
5. the exact evidence script and JSON certificate already produced here;
6. a narrow literature check on harmonic quadruple designs and
   (operatorname{PGL}_2(11)) recognition.

For a later sparse-shadow spinoff, add a common theorem vocabulary for
feature algebra, coherent closure, excess automorphisms, and the minimal
marking needed to descend from the shadow automorphism group to the intended
carrier group.

## 7. Ergodis improvement ledger

No source changes were made.  This run suggests four additions:

1. a group/orbit-aware ceiling that reports the automorphism group of feature
   fibres or accepts a supplied action certificate;
2. multiclass and partition targets, so a six-axis equivalence relation need
   not be flattened into one Boolean predicate;
3. a query-design mode that computes or certifies adaptive and nonadaptive
   separation numbers from incidence masks;
4. provenance fields for offline projective, group, and Gram-feature
   generators.

The run again assigned `request_id: 1` independently to `ceiling`, `note`,
and `shutdown`, and again recorded `code_commit: "unknown"`; the earlier
request-ID and provenance issues therefore remain reproducible.

## Reproduction

```text
python3 notes/clebsch-tasks/c1011_paper_v_shadow.py --check
```

The adjacent JSON records the group orders, design parameters, exact axis
pairs in Paper V export order, and witnesses for both query optima.  The
adjacent JSONL is the frozen Ergodis pair-shadow campaign dataset.

### Manuscript-ready draft language (not integrated)

> The recovery of the six axes from the singular quartic is relative to the
> retained (A_5)-action.  Indeed, for four quartic parameters normalized to
> ((\infty,0,1,\lambda)), the Gram determinant has square class
> (\chi(\lambda^2-\lambda+1)).  Over (\mathbf F_{11}), its positive class
> is the harmonic (3\!-!(12,4,3)) design, whose full automorphism group is
> (\operatorname{PGL}_2(11)).  Thus the unmarked metric four-shadow cannot
> distinguish the subgroup (A_5) or its six Sylow-(5) axes.  Selecting one
> matching in the (22)-point (H_3) orbit reduces
> (\operatorname{PGL}_2(11)) to its (A_5) stabilizer, and the six matching
> edges are exactly the stabilizer pairs defining the axes.
