# C973 checkpoint — cofinite GRS transfer and the top two distance shells

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** structural
transfer proved; novelty of the next-to-deep shell requires a claim-specific
literature audit

## Result

The pointed simultaneous-marker theorem is not merely compatible with GRS
codes.  It gives one theorem for every cofinite evaluation support

\[
 S=\mathbf P^1(\mathbf F_q)\setminus A,\qquad |A|=s,
\]

and every choice of nonzero GRS column multipliers.  Put

\[
 Q^*_{r,s}=6r+6s-16+
 \left\lfloor2\sqrt{6r+6s-18}\right\rfloor                 \tag{1}
\]

and, in characteristic two,

\[
 Q^*_{r,s,2}=6r+6s-22+
 \left\lfloor2\sqrt{6r+6s-24}\right\rfloor.               \tag{2}
\]

For `r>=6`, `q>=Q^*_{r,s}` (or the binary bound (2)), and every
projective syndrome direction `f`,

\[
 f\notin\mathcal P_r\cup\mathcal M^{\max}_{r,p}
 \quad\Longrightarrow\quad d_S(f)\le r-2.                 \tag{3}
\]

Here `d_S` is coset-leader weight for the GRS code supported on `S`.
Thus every syndrome of weight at least `r-1` lies on the same persistent or
Lucas carrier as in the projective paper.  This is stronger than a deep-hole
containment: it controls the entire top two layers of the distance partition.

When `p>r-1`, the Lucas carrier is empty.  Combining (3), the existing
rank-two arithmetic, and the Seroussi--Roth unique-extension theorem gives an
exact top-shell classification.

* If `s=0`, the covering radius is `r-1`; the weight-`r-1` directions are
  exactly the rational tangent and conjugate-secant points.  This is the
  current projective theorem.
* If `s>0`, the covering radius is `r`.  The weight-`r` directions are exactly
  the omitted curve points `nu_(r-1)(A)`.  The weight-`r-1` directions are
  exactly
  1. the rational tangent points off the curve;
  2. the rational points on conjugate secants; and
  3. the interior rational points of split secants having at least one
     endpoint in `A`.

Consequently, for `s>0`, the numbers of projective syndrome directions in the
top two shells are

\[
 N_r=s,
 \qquad
N_{r-1}=\frac{q(q+1)^2}{2}
  +\frac{(q-1)s(2q+1-s)}{2}.                              \tag{4}
\]

Equivalently, the two leading nonzero coefficients of the coset-leader
weight enumerator are `(q-1)N_r` and `(q-1)N_(r-1)`: every nonzero
projective syndrome direction contains `q-1` syndromes, and syndrome vectors
parametrize cosets.

For the full affine code `A={infinity}`, this specializes to

\[
 N_r=1,
 \qquad
 N_{r-1}=\frac{q(q^2+4q-1)}2.                              \tag{5}
\]

The deep shell in this high-rate regime is already forced by classical MDS
extension theory.  The potentially new strengthening is the exact
next-to-deep shell together with the constructive `r-2` witness outside the
carrier.  No Cheng--Murray novelty claim is licensed by this note.

In every characteristic, the digit-stripping theorem also makes the
candidate bound explicit.  Put `d=r-2`, let
`nu(d)=prod_i(d_i+1)` for the base-`p` digits `d_i`, let `eta(d)` be the
number of consecutive nonzero runs in Pascal row `d`, and set

\[
 c_{r,p}=r-\nu(r-2)-\eta(r-2)=\dim C_{r-2}.                \tag{5a}
\]

Then, for `s>0`,

\[
 N_{r-1}\le (q+1)(q^2+1)+\frac{q^{c_{r,p}}-1}{q-1}-s.     \tag{5b}
\]

Thus the Lucas recursion transfers not only as an exceptional locus but as a
digit-explicit bound on the whole next-to-deep population.

## 1. Multiplier-free syndrome geometry

Let `C_S(v)` be a GRS code whose redundancy is `r`, with nonzero coordinate
multipliers.  A parity-check matrix has columns

\[
                         w_a\nu_{r-1}(a),\qquad a\in S,
\]

for nonzero `w_a`.  For a syndrome `f`, therefore,

\[
 d_S(f)=\min\{|T|:T\subseteq S,
                  f\in\langle\nu_{r-1}(T)\rangle\}.        \tag{6}
\]

Indeed, rescaling the error value in coordinate `a` absorbs `w_a`.  Hence
nonzero GRS multipliers change affine representatives but neither projective
column spans, coset-leader weight, carrier membership, nor locator support.
This is the exact sense in which every theorem below is GRS-covariant.

The apolar dictionary used in the projective paper also survives unchanged.
A split squarefree member of `W_f` of degree `r-2`, all of whose roots belong
to `S`, is equivalent to a representation of `f` by `r-2` distinct retained
NRC columns.  Thus it proves `d_S(f)<=r-2`.

## 2. Pointed escape gives (3)

Use the pointed simultaneous-marker theorem with the omitted set `A` as the
forbidden-root set.  With `m=r-5`, its general selector condition is

\[
q>6+m-1+s=r+s,                                            \tag{7}
\]

while the characteristic-two selector condition is `q>r+s-2`.

and its terminal condition is

\[
 q+1-2\sqrt q>
 \begin{cases}
  12+6(m+s)=6r+6s-18,&p\ne2,\\
   6+6(m+s)=6r+6s-24,&p=2.
 \end{cases}                                               \tag{8}
\]

Applying `H(Delta)=Delta+2+floor(2 sqrt(Delta))` to (8) gives
(1)--(2).  These bounds dominate (7) for `r+s>=6`.  The resulting locator
has degree `r-2`, is split and squarefree, and avoids every point of `A`.
Equation (6) proves (3).  No new contraction, component, or finite-field
argument is needed.

The quantitative witness theorem transfers too.  Let `(x)_m` denote the
falling factorial, and put

\[
 G_{f,A}(q)=\max\{0,(q-s)_m-6m q^{m-1}\},                 \tag{8a}
\]

with `6m` replaced by `4m` in characteristic two, and

\[
 L_{m+s,p}(q)=\max\left\{0,
 \left\lceil\frac{q+1-2\sqrt q-B_p}{6}\right\rceil-m-s
 \right\}.                                                \tag{8b}
\]

Here `B_p=6` for `p=2` and `B_p=12` otherwise.

The use of `q-s` in (8a) is a uniform lower bound: if one forbidden point is
at infinity, the affine marker chart has one more available value.  The same
ordered marker/cubic overcount as in C973 gives

\[
 \#\{\text{degree-`r-2` locators supported on `S`}\}
 \ge \frac{6G_{f,A}(q)L_{m+s,p}(q)}{(r-2)!}.               \tag{8c}
\]

For fixed `r,s`, this retains the leading lower bound
`q^(r-4)/(r-2)!-O_(r,s)(q^(r-9/2))`.  This quantitative form is the part of
the transfer most relevant to compatibility arguments in RS-local sparse
codes.

### Lucas candidate count in every characteristic

The persistent rank-two locus has

\[
                         |\mathcal P_r(\mathbf F_q)|
                         =(q+1)(q^2+1).                    \tag{8d}
\]

Indeed, uniqueness of the length-two scheme on a degree-at-least-three
Veronese curve gives a disjoint partition into `q+1` curve points,
`binom(q+1,2)(q-1)` split-secant interiors, `q(q+1)` tangent points, and
`q(q-1)(q+1)/2` conjugate-secant points.  The digit-stripping theorem says
that the maximal Lucas carrier is the projectivization of a vector space of
dimension `c_(r,p)` from (5a), hence it has
`(q^c_(r,p)-1)/(q-1)` rational points.  Equation (3) places every syndrome of
weight at least `r-1` in the union of these two loci, while (11) identifies
the `s` weight-`r` directions.  The union bound gives (5b).  Intersections can
only improve it.

## 3. Covering radius and the deep shell

Assume `s>0` and choose `a in A`.  Every `r` distinct points of the degree
`r-1` NRC are independent.  Hence `nu_(r-1)(a)` is not in the span of any
`r-1` retained columns.  Since any `r` retained columns span the syndrome
space,

\[
                         d_S(\nu_{r-1}(a))=r.               \tag{9}
\]

The redundancy bound gives `rho(C_S(v))<=r`, so (9) proves `rho=r` without
an imported covering-radius theorem.  It also proves that every omitted
curve point is deep.

To prove that these are all the deep directions, apply Seroussi--Roth
Theorem 1 to the dual `[q+1-s,r]` GRS code.  Its hypothesis is

\[
 2\le r\le q+1-s-\left\lfloor\frac{q-1}{2}\right\rfloor,
                                                               \tag{10}
\]

with only a dimension-three exception in even characteristic.  If `q` is
odd, (10) is equivalent to `q>=2(r+s)-3`; if `q` is even, it is equivalent
to `q>=2(r+s)-4`.  Either pointed bound implies the appropriate inequality,
and `r>=6` avoids the exception.  Appending a syndrome column `f` to the
dual parity-check generator is MDS exactly when `d_S(f)=r`.  Theorem 1 says
directly that every such appended column is a nonzero multiple of
`nu_(r-1)(a)` for a missing column generator `a`; conversely each missing
NRC column gives an MDS extension.  This proves

\[
                         d_S(f)=r
 \quad\Longleftrightarrow\quad f\in\nu_{r-1}(A).            \tag{11}
\]

For `s=0`, the same theorem forbids an MDS extension of the full NRC.  Thus
every syndrome has weight at most `r-1`; the existing tangent/conjugate
families attain `r-1`, giving the projective radius gate.

This comparison is important for positioning: because (1) is much stronger
than (10), (11) is not a new solution of the full-affine Reed--Solomon
deep-hole conjecture.  In the fixed-redundancy regime of C973, the affine
deep shell was already known from high-rate MDS-extension results.

## 4. Exact next-to-deep shell in large characteristic

Assume `p>r-1`.  Then `M^max_(r,p)` is empty, and the rational points of
`P_r` have their standard disjoint rank-two stratification:

* curve points;
* interior points of rational split secants;
* rational tangent points off the curve; and
* rational points of conjugate secants.

The existing projective rank-two theorem says that every tangent or
conjugate-secant point has projective coset-leader weight `r-1`.  Deleting
columns cannot lower weight, while (11) shows that such a point is not deep
for `s>0`.  Its `S`-weight is therefore exactly `r-1`.

Let `f` be an interior point of the split secant through distinct rational
curve points `a,b`, and suppose at least one endpoint is omitted.  If `f`
were in the span of at most `r-2` retained columns, its secant expression
would give a nontrivial dependence among at most `r` distinct NRC columns.
If the retained endpoint occurs in the alleged support, combine its two
coefficients first; the omitted endpoint still has a nonzero coefficient,
so the resulting dependence remains nontrivial.  This contradicts the arc
property.  Hence `d_S(f)>=r-1`; (11) supplies `d_S(f)<=r-1`, so equality
holds.

By contrast, a retained curve point has weight one, and an interior split
secant whose two endpoints are retained has weight two.  Everything outside
`P_r` has weight at most `r-2` by (3).  This exhausts all directions and
proves the stated classification.

For the count, tangent plus conjugate-secant directions contribute the
existing

\[
                         \frac{q(q+1)^2}{2}.                \tag{12}
\]

There are

\[
 \binom{q+1}{2}-\binom{q+1-s}{2}
 =\frac{s(2q+1-s)}2                                        \tag{13}
\]

unordered rational secants incident with `A`.  Each contains `q-1` interior
rational points.  Uniqueness of the length-two scheme on the degree-at-least
three Veronese curve makes these contributions disjoint.  Equations
(12)--(13) give (4), and `s=1` gives (5).

## 5. What transfers, and what does not

### Strong transfers

1. **GRS multipliers:** exact and free, by (6).
2. **Full affine RS:** `s=1`; the theorem identifies both the known unique
   deep direction and the complete next-to-deep shell.
3. **Boundedly punctured projective/affine GRS:** exact for fixed `s`, with
   threshold cost linear in `s`.  The new locator is constructive and avoids
   every puncture simultaneously.
4. **Near-deep decoding:** outside the two carriers, the software certificate
   is not merely a non-deep verdict but an explicit correction supported on
   at most `r-2` retained coordinates.

### Projective-RS software interface

The current engine already contains the essential operation:
`search_pointed_simultaneous_marker_locator(request, forbidden, limit)` takes
typed `Root` values and verifies that the complete locator support avoids
them.  Therefore the cofinite-GRS negative certificate needs no new search
algorithm.  A later software item only needs a typed domain/result wrapper:

* `CofiniteGrsDomain { omitted: BTreeSet<Root>,
  parity_check_scales: BTreeMap<Root, NonzeroFieldElement> }`, with the
  existing full-projective domain represented by an empty set and unit
  scales; a constructor from generator-side GRS multipliers should compute
  the dual Lagrange scales once rather than conflate the two notions;
* a shell enum distinguishing `DeepOmittedPoint`, `NextTangent`,
  `NextConjugateSecant`, `NextIncidentSplitSecant`, and
  `AtMostRMinusTwo(LocatorCertificate)`; and
* a verifier which divides each recovered NRC magnitude by the corresponding
  nonzero column multiplier to obtain the actual GRS error value.

The existing `LocatorCertificate` should remain multiplier-free: it certifies
the intrinsic NRC span relation, while the domain adapter certifies monomial
equivalence.  Tests should cover empty `A`, `A={infinity}`, multiple omitted
points, duplicate rejection, multiplier covariance, every shell variant, and
the invariant `(q-1)` conversion from projective directions to cosets.  The
new public types must not add evaluation-set, family, or verdict strings;
those should be enums or validated newtypes.  This work is outside C973's
manuscript-frozen and software-frozen ownership.

### Weak or local transfers

1. **Arbitrary short evaluation sets:** the method loses force when the
   omitted set is large.  Both the selector budget and the unique-completion
   input are cofinite-support statements.
2. **Multiplicity RS:** Hasse contraction and confluent Vandermonde geometry
   suggest a real analogue, but the terminal carrier and squarefree-locator
   semantics must be rebuilt.
3. **AG, alternant/Goppa, and rank-metric codes:** apolar or secant analogies
   alone do not preserve the proof.

## 6. LDPC and local-constraint codes

There is no direct generic-LDPC theorem.  A sparse parity-check matrix does
not have NRC columns, its local syndrome space need not be a binary symmetric
power, and its covering radius is not controlled by the C973 carrier.

The useful transfer is to sparse Tanner architectures whose check nodes are
RS/GRS constraints.  At each local check, (3) provides:

* a weight-`r-2` local coset leader outside an explicit exceptional carrier;
* typed support avoidance for symbols already committed by neighboring
  checks; and
* polynomially many local witnesses from the quantitative abundance theorem.

This turns global decoding into a compatibility problem among certified
local witnesses.  On bounded-degree Tanner graphs, a future Lovasz-local-
lemma, matching, or nibble argument could exploit the abundance to choose
compatible supports.  That global selection theorem is not proved here.
Lifted RS codes are a particularly plausible target because their local
constraints are RS and their characteristic-dependent monomial sets already
have Lucas/p-shadow structure.  Generic binary LDPC, AG-LDPC, and expander
codes without local GRS checks should not be advertised as consequences.

## 7. Literature boundary

The transfer consumes, rather than supersedes, the classical
Seroussi--Roth MDS-extension theorem and Duer/Kaipa's syndrome-extension
dictionary.  The exact one-column statement used here was checked in the
primary source: Seroussi--Roth Theorem 1 says that, in range (10), an MDS
extension column is precisely a scalar multiple of the Veronese column at a
missing projective generator, apart from the irrelevant even-characteristic
dimension-three nucleus column.  Kaipa's high-rate result already covers the
Cheng--Murray classification in the numerical range forced by (1).  Recent
work on generalized projective RS codes with deleted evaluation points gives
degree-specific subset-sum characterizations and must be compared against
any claimed punctured-word formulation.
The scoped comparison completed after this proof is recorded in
`c973-2026-08-26-cofinite-grs-literature-preaudit.md`; it licenses the
classical-input boundary below but not novelty language for the `r-1` shell.

Accordingly:

* no novelty language is licensed for the affine deep shell;
* the exact `r-1` shell and constructive `r-2` separation are the claims that
  merit a focused literature audit; and
* arbitrary-support or LDPC-global consequences remain open programmes, not
  corollaries.

## 8. Paper-successor integration

This should strengthen and shorten the eventual paper rather than create a
new application section.

1. Define `C_S(v)` once, with `A=P1(F_q)\S`, and state multiplier covariance
   immediately after the syndrome dictionary.
2. State the pointed simultaneous-marker theorem with `s=|A|`; the current
   PRS theorem is its `s=0` specialization.
3. Replace the PRS-only high-characteristic conclusion by the cofinite-GRS
   top-shell theorem.  Display the `s=0` and `s=1` consequences in two lines.
4. Cite Seroussi--Roth for the deep shell and say explicitly that the affine
   Cheng--Murray case is already known in this high-rate range.  Emphasize the
   new distance-`r-1` shell only after its audit clears.
5. Keep LDPC out of the theorem spine.  At most one outlook sentence should
   mention RS-local Tanner/lifted codes and the unsolved global compatibility
   problem.

The cofinite extension should cost at most `1.0--1.3` pages: roughly `0.2`
for the multiplier/support dictionary, `0.5` for the theorem and shell count,
`0.4` for the split-secant/Seroussi--Roth proof, and one short frontmatter
sentence.  It reuses the pointed theorem instead of adding a new proof
section.  Against the existing successor map's `2--5` pages of recursive
package deletions, the revised paper should still become shorter by about
`1--4` pages.  Do not broaden the title or make the affine result a headline
until the next-to-deep prior-art audit clears; if the audit finds overlap,
retain the statement as a unifying corollary with no extra frontmatter.

The manuscript remains frozen in C973.  These edits belong to the separately
allocated paper-successor item.

## 9. Proof and evidence boundary

The GRS covariance, pointed threshold, omitted-point radius lower bound,
split-secant lower bound, and shell count are structural proofs.  The
`r-2` witness theorem is inherited from the proved C973 simultaneous-marker
argument.  The uniqueness of the deep shell is an explicit imported
Seroussi--Roth theorem.  The tangent/conjugate weight is inherited from the
paper's proved rank-two arithmetic.  No finite-field census or new software
output is used to establish the theorem.

## 10. `ej` + `tt` closeout and Mystery ledger

The closeout pass asked whether the transfer only restated a known affine
deep-hole theorem.  It does not: Seroussi--Roth already settles the deep
shell in this range, while C973 adds the exact carrier of the next shell,
its count, and abundant constructive witnesses one layer below.  The pass
also separated the sharp classical hypothesis (10) from the stronger
pointed-escape threshold (1)--(2), so the paper must not present the latter
as necessary for the former.

| feature | status after closeout | exact remaining gate |
|---|---|---|
| Deleting one curve point promotes all interior points of its incident split secants from weight two to weight `r-1` | settled structurally by NRC independence plus Seroussi--Roth; counted in (13) | literature audit only |
| Tangent/conjugate shell is unchanged by any bounded puncture | settled structurally by monotonicity and the exact deep-shell theorem | literature audit only |
| GRS multipliers might change locators or weights | settled: column scaling is absorbed into error magnitudes in (6) | none |
| Pointed abundance might lose its leading term | settled by (8a)--(8c) for fixed `r,s` | software exposure is a separate C974 item |
| Small-characteristic `r-1` shell on the Lucas carrier | candidate population now bounded explicitly by (5b), exact shell open | arithmetic pointed-abundance through the digit-stripping extensions remains owned by C973 |
| RS-local LDPC witnesses might globalize | open | needs a separate bounded-overlap compatibility theorem; no global LDPC claim is licensed |
| Prior art for the general cofinite-GRS next-to-deep enumerator | scoped primary-source preaudit complete; no matching theorem found | finish the citation-graph and finite-geometry audit before novelty wording or manuscript integration |

No further unexplained numerical feature remains in the threshold or shell
count: the coefficient `6s` is exactly one terminal pencil-member deletion
per forbidden root, and the factor `(q-1)` in (4) is the number of interior
points on each incident rational secant.

Open gates:

1. final citation-graph and finite-geometry audit for the full `r-1` shell and
   its count;
2. a software-facing cofinite-support schema, only if a later C974 item is
   allocated; and
3. any global compatibility theorem for RS-local Tanner or lifted codes.
