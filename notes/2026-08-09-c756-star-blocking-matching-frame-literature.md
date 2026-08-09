# C756 focused literature audit: star blocking and matching tight frames

## Verdict

The two new C756 interfaces survive a focused predecessor check, with careful
claim limits.

1. The conic-relative blocking literature classifies **minimum-size** blockers
   for various selections of secant, tangent, and external lines.  It does not
   classify quadratic-size internal blockers that are pairwise-intersection
   sets of a dual-arc arrangement of passants.
2. Algebraic star-configuration literature supplies the standard ideal and
   set-theoretic complete-intersection language, but not the finite-field
   condition that the rational star vertices meet every non-tangent line.
3. Tight-frame/eutaxy literature contains root-lattice and graph-frame
   constructions, but the searched sources do not study decompositions of the
   \(A_m\) frame operator by nonzero signed matching vectors with a finite-conic
   concurrency realization.
4. The nearby 2025 papers do not pre-empt either result.  One treats blocking
   sets with an \(r_\infty\)-property; another classifies minimum blockers of
   secant or secant-plus-tangent line families for quadrics.  C756 blocks the
   complementary family of all **non-tangent** lines with an internal star set
   and imposes an arrangement/tight-frame structure absent from those papers.

The qualified novelty position is therefore:

> We found no predecessor for the dual passant-star blocking equivalence, the
> positive diagonal-bias inequality, or the outside signed-matching tight-frame
> identity in the searched sources.

This is not a field-wide priority guarantee.  The search was targeted, and the
exact matching-vector phrase may not be standard terminology.

## 1. Exact C756 objects audited

### Finite-geometric object

For \(q=2m-1\), take \(m+1\) passants in dual-arc position.  Their
\(\binom{m+1}{2}\) pairwise intersections are internal and contain the full
internal half of each arrangement line.  C756 asks whether this star vertex
set can meet every secant and every passant while avoiding all tangents.

The distinctive hypotheses are simultaneous:

- star configuration of \(m+1\) lines with no three concurrent;
- every arrangement line passant;
- every star vertex internal;
- every non-tangent line blocked; and
- the arrangement is polar to a coherent saturated exterior arc.

### Frame/design object

The outside block has \(2m(m-2)\) nonzero rows
\[
 R_X=\sum_{(i,j)\in M_X}\pm(e_i-e_j),
\]
where every \(M_X\) is a nonempty matching and
\[
 R^{\mathsf T}R=(m-2)((m+1)I-J).
\]
The matchings are not arbitrary: they are the chord pencils through outside
internal points of one conic-external arc.

## 2. Closest conic-blocking predecessors

### Aguglia--Korchmáros and Aguglia--Giulietti

Aguglia--Korchmáros classify minimum point sets blocking the external lines
of a conic for odd \(q\), with minimum size \(q-1\).  Their companion paper on
nonsecant lines classifies minimum sets meeting external and tangent lines.
Aguglia--Giulietti classify minimum blockers for secants (odd \(q\)) and for
external-plus-tangent lines (even \(q\)).

These are essential terminology and lower-bound predecessors, but their
extremal sizes are linear in \(q\), their line families differ, and their
theorems do not impose a star-configuration vertex set.  They do not decide
the C756 gate.

- A. Aguglia and G. Korchmáros, *Blocking sets of nonsecant lines to a conic
  in PG(2,q), q odd*, J. Combin. Designs 13 (2005), 292--301,
  <https://doi.org/10.1002/jcd.20042>.
- A. Aguglia and G. Korchmáros, *Blocking sets of external lines to a conic
  in PG(2,q), q odd*, Combinatorica 26 (2006), 379--394,
  <https://doi.org/10.1007/s00493-006-0021-2>.
- A. Aguglia and M. Giulietti, *Blocking sets of certain line sets related to
  a conic*, Designs Codes Cryptogr. 39 (2006), 397--405,
  <https://doi.org/10.1007/s10623-005-6131-9>.

### Patra--Sahoo--Sahu

Patra--Sahoo--Sahu complete the remaining minimum-size line-family cases.  In
particular, an odd-order point set blocking external and secant lines has size
at least \(q+1\).  This is exactly C756's line family, but only at the general
minimum-size level.  The star set has size \(m(m+1)/2\), far above the minimum,
and the paper does not classify structured blockers of that size.

- K. L. Patra, B. K. Sahoo, and B. Sahu, *Minimum size blocking sets of
  certain line sets related to a conic in PG(2,q)*, Discrete Math. 339 (2016),
  1716--1721, <https://doi.org/10.1016/j.disc.2016.01.010>.

This is the closest direct predecessor and should be cited in any eventual
statement of the star-blocking formulation.

### Giulietti line partitions

Giulietti classifies line sets that partition all internal points of a conic.
The result is structurally adjacent because each C756 arrangement passant
contains its complete internal half, but the C756 arrangement lines overlap
pairwise at the star vertices and do not partition the internal point set.

- M. Giulietti, *Line partitions of internal points to a conic in PG(2,q)*,
  <https://arxiv.org/abs/math/0607118>.

The partition theorem is a possible technique source, not a pre-emption.

## 3. Star-configuration algebra

Tohaneanu proves that generic star configurations are set-theoretic complete
intersections and records their ideals in terms of products of the arrangement
linear forms.  This supports C756's algebraic carrier
\(I_{\mathcal B}=\langle F/L_i\rangle\), but the work is over an arbitrary
field and asks an ideal-theoretic question.  It does not study rational-point
blocking, conic point types, or finite-projective-plane line avoidance.

- S. Tohaneanu, *Star Configurations are Set-Theoretic Complete
  Intersections*, <https://arxiv.org/abs/1507.05667>.

The correct claim is that C756 applies standard star-configuration algebra to
a new finite-geometric relative-blocking constraint, not that it introduces
star configurations or their ideals.

## 4. Tight frames and root lattices

Fukshansky--Needell--Park--Xin develop lattices generated by rational tight
frames and vertex-transitive graphs, recovering root lattices and strongly
eutactic examples.  Classical eutactic-star work likewise provides the broad
frame language.  The inspected statements do not classify tight frames whose
individual vectors are signed sums of pairwise disjoint \(A_m\) roots, and do
not add the projective-conic realization of those matchings.

- L. Fukshansky, D. Needell, J. Park, and Y. Xin, *Lattices from tight frames
  and vertex transitive graphs*, Electron. J. Combin. 26 (2019), P3.49,
  <https://arxiv.org/abs/1902.02862>.

The broad observation “the \(A_3\) roots form a tight frame” is classical and
must not be sold as new.  The potentially new theorem is the forced geometric
matching-frame decomposition (including its exact multiplicity and conic
interpretation), preferably as a consequence inside a finite-geometry paper
rather than a standalone priority claim until a deeper frame-literature audit
is done.

## 5. The 2025 novelty threat

Two current papers were checked because their titles are close enough to cause
confusion.

- Crupi--Ficarra introduce blocking sets with an \(r_\infty\)-property in a
  finite projective plane and study attainable sizes.  Their abstract does not
  specialize to conic-relative non-tangent lines or star vertices:
  <https://arxiv.org/abs/2507.05037>.
- De Bruyn--Pradhan--Sahoo determine minimum blockers for secant and
  secant-plus-tangent lines with respect to quadrics.  In the planar conic
  case their line family is \(S\) or \(S\cup T\), whereas C756's dual set
  blocks \(S\cup E\) and automatically avoids \(T\).  Their result is also a
  minimum-cardinality classification, not a structured star classification.

**Verdict:** no novelty pre-emption of Propositions 25--30 was found.  The 2025
papers strengthen the citation context and make the line-family notation
important, but they do not state the C756 equivalence, bias inequality, or
matching-frame identity.

## 6. Publication and theorem-use consequences

The literature changes the preferred presentation as follows.

1. State the dual object as an \((E\cup S)\)-blocking set relative to the
   conic, citing Patra--Sahoo--Sahu for the general minimum-size boundary.
2. Then emphasize the extra star/internal/full-line-section structure; this is
   where the new theorem begins.
3. Cite standard star-configuration algebra for the ideal, without claiming
   novelty for \(\langle F/L_i\rangle\).
4. Present the outside matching frame as a derived structural theorem and the
   \(q=5\cong A_3\) identification as an explanation, not as discovery of the
   root frame itself.
5. Do not claim that abstract matching tight frames are classified or
   impossible.  The live problem is their conic-realizable subclass.

The strongest publishable partial addition to the already scoped companion is
currently the short chain:

\[
\text{covering}\Longleftrightarrow\text{dual star }(E\cup S)\text{-blocking}
\Longrightarrow T_4>0,
\]

together with the outside matching-frame identity and the elementary
\(q=7\) star-profile exclusion.  This is theorem material even if the full
saturated classification remains open.

## EJ + TT closeout

**EJ.**  The closest existing theorem is better than a vague novelty warning:
Patra--Sahoo--Sahu fixes the exact established category, \((E\cup S)\)-blocking
relative to a conic.  C756's novelty is the rigid star realization and the
resulting diagonal/frame consequences, not the blocking-set label.

**TT.**  Search failure is not proof of absence, especially for the matching
frame, whose terminology may live under root-lattice designs, signed graph
incidence, or eutactic decompositions.  Before a standalone frame claim, run a
human MathSciNet/zbMATH citation and terminology check.  For the finite-geometry
companion, the present source boundary is adequate for a qualified
“to our knowledge” claim because the closest conic line-family papers were
identified directly.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Is relative blocking with respect to conic line types known? | settled positive | extensive minimum-size theory; use \(E,S,T\) notation |
| Does that theory classify C756's star blocker? | no predecessor located | sizes and structural hypotheses differ |
| Is the star ideal new? | settled negative | standard star-configuration algebra |
| Is the conic-realized matching tight frame pre-empted? | no predecessor located | broad tight-frame/root-lattice theory exists; deeper terminology audit still needed |
| Do the 2025 blocking papers pre-empt the result? | settled negative for inspected statements | wrong line family/property and no star realization |
| What is safe to publish now? | settled | equivalence, \(q=7\) exclusion, positive-bias bound, and matching-frame identity with qualified novelty |
| What is the next theorem-sized gap? | open | rule out conic-realizable nonzero matching tight frames for \(m>3\), or derive a nonpositive global \(T_4\) identity from coherence |

## Next action

Attack the geometric realization, not abstract eutaxy: add the rows indexed by
outside **external** points (the secant-polar half of covering) to the matching
frame, and derive the coupled frame/cross-Gram identities.  The target is a
two-species signed matching design whose mixed Gram matrix is forced by full
projective incidence.  Continue only if this adds an independent identity to
(1); stop if it merely restates the secant line-profile moments.
