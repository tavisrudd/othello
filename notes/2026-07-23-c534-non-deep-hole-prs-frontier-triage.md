# C534 — non-deep-hole PRS frontier triage

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Executive verdict

The six proposed directions do not support six new projects.

1. **Characteristic-two Hessian--Arf replacement geometry** is the cleanest independent
   survivor.  C525 already proves a short theorem with a reusable `(2,2)` curve and an exact
   constrained-carrier classification; the remaining risk is whether a fuller modular-invariant
   audit or a higher-degree functoriality test makes it a cubic coincidence.
2. **Coherent polar flags** survive after deleting the classical and recently packaged parts.
   The crown is not generic secant/Fano geometry or Chebotarev.  It is the positive-characteristic
   classification of *consecutive-contraction-compatible* contained flags, including the Lucas
   components and the retained forbidden factor.  C512 already recovers four fixed levels from
   this mechanism.
3. **Finite-field Gale reconstruction** has strong mathematics and one high-upside comparison
   gate, but no clean new-paper slot yet.  Agarwal--Connelly--Crannell--Duff--Thomas occupy the
   closest flatland inverse-projection territory; their Theorem 6 gives pairwise fundamental-matrix
   compatibility and explicitly warns that pairwise reconstructions need not be jointly consistent
   for three or more cameras.  C481--C485 may resolve exactly that multi-view consistency gap, or
   may encode a different inverse problem.  C537 owns the functor-level comparison.  Meanwhile
   `arcs_complete_outside_conic` and `continuation-graph-rigidity` already own the
   deletion/extension reconstruction stories in `papers/papers-index.md`, so comparison alone
   does not authorize another paper.
4. **Lucas root-space monodromy** is absorbed into coherent polar flags.  The Gaussian-binomial
   witness count and generic linearized-polynomial monodromy are standard; the new content is the
   canonical selection of those covers by a Lucas/consecutive-row carrier.  C531 already owns the
   next carrier-stratification test.
5. **Simultaneous MDS-extension complexes** are already defined and theoremized in the pending
   `arcs` paper, including the exact pair/triple conflict hypergraph and the q=11 complex.  No
   bridge from coherent projection atlases to higher-order MDS was found.
6. **Equivalence algorithms** fail the advantage test.  General semilinear canonization and
   incidence-based equivalence algorithms already cover the growing-input problem; the C481--C485
   inverse is explicit but fixed-size and supplies no proved complexity improvement.

Three bounded successors are allocated in this evidence order: C535 for Hessian--Arf
functoriality, C536 for the modular coherent-polar Fano boundary, and C537 for the exact
Flatland--Gale multi-view comparison.  None is a manuscript task, and none displaces C531/C532.

## Audit coverage and read depth

**Full-text count:** six external sources are reused at `full text` depth from the C512/C519/C525
audits: Zhang--Wan--Kaipa, Kaipa, Wu--Ding--Chen, Xu, Wang, and Ball--Lavrauw.  No newly promoted
source is represented as read end-to-end.  The new closest source, *A Computer Vision Problem in
Flatland*, was read at `partial` depth as specified below.  Cache presence is not used as a
read-depth claim.

New or load-bearing sources:

- Agarwal, Connelly, Crannell, Duff, and Thomas, *A Computer Vision Problem in Flatland*,
  DOI `10.1137/25M1727552`, arXiv `2501.05429v2` — **read depth: partial**, arXiv v2
  introduction, Theorems 1, 2, 4, and 6, the discussion surrounding Theorem 6, Section 6, and
  Theorems 34--36.  Cache key
  `arXiv:2501.05429`, SHA-256
  `c1e2b8908474795f3eb6a11cca24228960ddd1dd81326cd6c9c28d2f595d9654`.
- Hartley--Schaffalitzky, *Reconstruction from Projections Using Grassmann Tensors*, DOI
  `10.1007/s11263-009-0225-1` — **read depth: abstract/metadata only**, official Oxford
  publication page and Crossref journal metadata.  Its generic uniqueness theorem explicitly
  excludes projection onto lines.
- Eisenbud--Popescu, *The Projective Geometry of the Gale Transform*, DOI
  `10.1006/JABR.1999.7940`, arXiv `math/9807127` — **read depth: partial**, arXiv v1
  introduction and its section-by-section theorem overview.  Cache key
  `arXiv:math/9807127`, SHA-256
  `136727dd6bf2cc4d2d08042a994b9f0a4c87c095297b205a0c5ccb473c7e6934`.
- Gordon--McNulty, *Techniques in matroid reconstruction*, DOI
  `10.1016/0012-365X(95)00227-N` — **read depth: abstract/metadata only**, publisher
  abstract.  It places deletion reconstruction as an established matroid problem and proves
  selected reconstructible classes.
- Wang, *Splitting of Polynomial Families via Galois Theory*, arXiv `2606.12810v1` —
  **read depth: full text**, all sections, reused from C512.  Cache SHA-256
  `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.
- Voisin, *Appendix: On linear subspaces contained in the secant varieties of a projective
  curve*, arXiv `math/0110256` — **read depth: abstract/metadata only**, arXiv abstract and
  theorem statement.
- Slupinski--Stanton, *The Special Symplectic Structure of Binary Cubics*, DOI
  `10.1007/978-0-8176-4817-6_8`, arXiv `0906.4309` — **read depth: abstract/metadata only**;
  its stated hypotheses exclude characteristics two and three.  Cache SHA-256
  `8754633abdd5e7271aa81cabdd7685a0d25c43e2a79bde26875301b63e165b0f`.
- Gmainer--Havlicek, *Nuclei of Normal Rational Curves*, DOI `10.1007/BF01237480`,
  arXiv `1304.0088` — **read depth: partial**, abstract and Theorem 1, reused from C512.
  Cache SHA-256 `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`.
- Gow--McGuire, *On Galois groups of linearized polynomials related to the general linear
  group of prime degree*, arXiv `2207.14113` — **read depth: abstract/metadata only**, arXiv
  abstract.
- Roth, *Higher-Order MDS Codes*, DOI `10.1109/TIT.2022.3194521`, arXiv
  `2111.03210v2` — **read depth: partial**, abstract, introduction, and Section III.A.
  Cache SHA-256 `0893a502e973e64d835389353c1e025480ae96b9e400d492a431ce27dfe14dff`.
- Feulner, *Canonical Forms and Automorphisms in the Projective Space*, arXiv
  `1305.1193v1` — **read depth: partial**, abstract and Sections 1--2.1.  Cache SHA-256
  `8c1ac455ca62fb038706b7aa1ef440f203e0a446282decc6167ff42471433f0e`.
- Bouyukliev--Bouyuklieva, *About Code Equivalence -- a Geometric Approach*, arXiv
  `2202.02086` — **read depth: partial**, introduction and the Section 3 algorithm summaries.
  Cache SHA-256 `a69e90db8361401a53ef767afdc1d816e28bf513117e9d8546a6b025d1d1bd3b`.
- Kreuzer, *Code Equivalence, Point Set Equivalence, and Polynomial Isomorphism*, arXiv
  `2511.06843` — **read depth: abstract/metadata only**, arXiv abstract.

The exact discovery queries were grouped by direction:

```text
Gale transform reconstruction point configurations from projections deletion deck matroid reconstruction theorem
projective point configuration reconstruction from projections Gale transform four projections theorem
"matroid reconstruction" deletion deck matroid
Fano scheme lines secant variety rational normal curve catalecticant
linear spaces contained secant variety rational normal curve Fano scheme
binary cubic invariants characteristic two Hessian discriminant modular invariant theory
divided Hessian binary cubic characteristic 2
generic linearized polynomial Galois group AGL finite field subspace polynomial
Lucas nuclei normal rational curve subspace polynomial
simultaneous MDS extensions arcs extension complex higher order MDS codes
site:arxiv.org linear code equivalence algorithm projective system equivalence canonical form
site:arxiv.org punctured codes reconstruction parent code deletion deck
```

The web indexes do not expose stable total-result counts, so these result pages were used for
discovery only and do not support a negative.  Promoted sources carry individual read depths above.

## Forward-citation closure

Counts were resolved on 2026-07-23 from pinned identifiers.  The largest available citing set for
each direction was screened over `title + abstract + year + external identifiers`.  The mechanical
discriminator was

```text
projection|reconstruct|deletion|deck|finite field|MDS|code|puncture|shorten|
polar|contraction|Hankel|catalecticant|Lucas|nucleus|Hessian|Arf|linearized
```

followed by manual inspection of every hit.  `NR` means that the service did not resolve the
pinned seed; it is a coverage gap, not a zero.

| Direction / pinned seed | OpenAlex | Crossref | Semantic Scholar | Largest set screened | Result |
|---|---:|---:|---:|---:|---|
| Gale: Flatland DOI `10.1137/25M1727552` | 0 | 0 | 0 | 0 | empty responses distinguished from errors by resolved metadata plus zero count |
| Gale infrastructure: Hartley DOI `10.1007/s11263-009-0225-1` | 30 | 24 | 68 | 68 | one load-bearing hit: Flatland; other hits did not address finite-field Gale sheets |
| Polar flags: Voisin arXiv `math/0110256` | NR | NR | 7 | 7 | no coherent contraction/Lucas/finite-field hit |
| Splitting infrastructure: Wang arXiv `2606.12810` | 0 | NR | 0 | 0 | Crossref has no resolved record |
| Hessian--Arf: Slupinski--Stanton DOI `10.1007/978-0-8176-4817-6_8` | 3 | 2 | 6 | 6 | no characteristic-two constrained-pullback hit |
| Lucas nuclei: Gmainer--Havlicek DOI `10.1007/BF01237480` | 0 | 0 | 3 | 3 | one general Veronese-in-positive-characteristic survey; no root-space carrier theorem |
| Higher-order MDS: Roth DOI `10.1109/TIT.2022.3194521` | NR | 19 | 23 | 23 | higher-order MDS/list-decoding works, no arc-extension-complex reconstruction bridge |
| Algorithms: Feulner arXiv `1305.1193` | 10 | NR | 11 | 11 | projective/code canonization applications; no deletion-parent reconstruction guarantee |

The Eisenbud--Popescu seed was also resolved independently at `80 / 43 / 110`
(OpenAlex/Crossref/Semantic Scholar).  All 110 Semantic Scholar citing records were screened over
the same fields.  The hits concern Gale duality, self-associated configurations, algebraic
geometry, and code/point-set equivalence; none states C485's finite-field four-view Gale-sheet
descent.  This does not rescue a separate paper slot after the closer Flatland and pending-paper
portfolio comparisons.

Coverage gaps: MathSciNet is **NOT COVERED** because institutional authentication is unavailable;
Google Scholar was not used because automated access is blocked; zbMATH Open was not independently
refreshed.  Any future novelty sentence remains qualified “to our knowledge.”

## Direction 1 — finite-field Gale reconstruction and MDS parent recovery

**Published frontier.**  Eisenbud--Popescu give the scheme-theoretic Gale involution and its
coding/self-association geometry.  Hartley--Schaffalitzky prove generic projective reconstruction
from sufficiently many projections but explicitly exclude line images.  Flatland gives a complete
inverse-projection theorem for pairs of labelled planar configurations sharing a line image and,
for six points, explicit cubic camera-center loci with birational correspondence.  Its Theorem 6
packages several views through pairwise fundamental-matrix conditions, then explicitly notes that
pairwise reconstructions need not be jointly consistent for three or more cameras.  It works in
the generic real/complex setting and does not state finite-field sheet descent or reconstruction
of an unknown common planar parent from four abstract line images.  Separately, the pending `arcs`
paper already owns complete-child parent recovery, and the pending `continuation` paper owns
continuation-object reconstruction.

**Candidate crown.**  For a labelled six-arc over a finite field, four compatible abstract
line-projection sextics determine exactly a Gale pair; the reduced branch is the conic locus, the
two rational sheets carry an explicit Kummer/Artin--Schreier descent class, and additional abstract
views cannot select a sheet.

**Why it matters.**  This is a finite-field, exceptional-line-image refinement of projective
reconstruction with an explicit degree-two inverse and arithmetic descent.

**Cheap kill.**  The broad “reconstruction from projections” claim is killed by Hartley and
Flatland.  C482's exact residual dimensions `2,1,0` for two, three, and four views, with a
quadratic rather than unique four-view fibre, kill any generic uniqueness slogan.

**Characterize test.**  Forgetting syndrome language leaves the complete functor: each atlas is
literally a labelled `M_0,6` point, and the compatibility equations and Gale involution remain.
Flatland also identifies its six-point invariant quotient with the labelled `P1` GIT quotient.
This creates a precise possible match: C481's diagonal compatibility and C482's `2,1,0` residual
dimensions plus four-view quadratic Gale pair may be an exact joint-consistency theorem for
Flatland's views.  It may instead be a different inverse problem because the scene, camera, line
image, ambient embedding, and equivalence-group data have not yet been identified functorially.
Forgetting the single diagonal labelling across views destroys C481's input, so this is not an
unlabelled deletion-deck theorem.  Complete-child rigidity is already assigned to `arcs`.

**Evidence boundary.**  C481--C485 prove the crown and explicit inverse; C490 supplies finite
complete-child exceptions but belongs to the already allocated `arcs` reconstruction story.
An exact equivalence, refinement, or separation from Flatland's Theorem 6 is not proved.  C537
owns that bounded comparison before any novelty or manuscript claim.

**Verdict:** `HIGH-UPSIDE OPEN`, restricted to C537's comparison gate.  Mathematically
theorem-ready internally, but a separate paper would still compete with Flatland and two pending
internal papers unless the functor comparison isolates a genuinely different theorem.

**Scores:** novelty confidence `4`, notability `5`, audience breadth `5`, theorem readiness `3`,
tractability `4`, publication coherence `3`; weighted score **100/125**.

## Direction 2 — coherent polar flags and structured splitting loci

**Published frontier.**  Voisin proves that, in her high-degree curve range, maximal linear spaces
inside secant varieties are the obvious secant spans.  Catalecticant equations for Veronese secants
and their arbitrary-characteristic refinements are established literature.  Wang supplies the
general finite-field Galois/Chebotarev splitting framework.  None of the screened sources states a
consecutive-Hankel contraction functor retaining a forbidden factor, classifies its modular Lucas
contained flags, or gives the C512 explicit deletion threshold.

**Candidate crown.**  Consecutive contraction flags in divided-power binary-form modules obey a
contained-or-transverse dichotomy: contained flags are the obvious rank-two
tangent/sigma families together with explicitly Lucas-selected modular components; transverse
flags admit effective rational splitting after retaining the marked collision divisor.

**Why it matters.**  It links Fano schemes of secant loci, modular representation theory of binary
forms, and effective finite-field splitting.  C498, C509, C513, and C516 become corollaries of one
mechanism.

**Cheap kill.**  The abstract “classify linear spaces on secants” crown is pre-empted in the
classical high-degree range, and the arithmetic engine is Wang's.  Removing the pointed forbidden
factor fails on the C498 and q=19 controls: split members can all use the marked/collision root.

**Characterize test.**  The smallest nonzero consecutive overlaps through degree eight are
exactly C529's degrees `4,5,8`, with ranks `2,1,6`; all intermediate degrees vanish.  Hence the
first positive-moduli boundary is the degree-eight lower nucleus / degree-nine upper carrier,
already owned computationally by C531.  This is a sharp theorem boundary rather than an
unstructured extrapolation.

**Evidence boundary.**  C512 proves the functor and conditional theorem; C529 proves the complete
first-overlap table; C531 owns the first carrier with positive-dimensional residual strata.  A new
paper-facing theorem still needs a full Fano-scheme comparison and a dependency-minimal
scheme-level statement.

**Verdict:** `THEOREM-READY`.

**Scores:** novelty confidence `4`, notability `5`, audience breadth `4`, theorem readiness `4`,
tractability `4`, publication coherence `4`; weighted score **105/125**.

## Direction 3 — characteristic-two Hessian--Arf replacement geometry

**Published frontier.**  Classical binary-cubic invariant sources and
Slupinski--Stanton explicitly avoid characteristic two (usually also three).  The characteristic-two
quadratic Arf/Dickson class itself is standard.  The closest twisted-cubic line-orbit sources in
the C525 delta either exclude characteristic two and three or give finite orbit tables.  No located
source gives the ordered divided-Hessian `(2,2)` model plus the constrained Hankel pullback.

**Candidate crown.**  Over characteristic-two base schemes, the ordered divided Hessian is a
separable replacement for the Frobenius-square cubic discriminant.  Its complete line-degeneracy
locus is the persistent Veronese surface plus the two tangent-quadric rulings; under
root-compatible consecutive contractions, the complementary ruling has rank at most one and the
only nontrivial contained pullback is the persistent/Lucas carrier.

**Why it matters.**  This is a compact modular-invariant theorem with a reusable genus-one
incidence model, rather than a coding classification in disguise.

**Cheap kill.**  Originality is not claimed for the Arf invariant, doubled quadric, twisted cubic,
or its rulings.  The crown survives only at the constrained-pullback equality.

**Characterize test.**  For an ordinary binary quartic
`A x^4+B x^3y+C x^2y^2+D xy^3+E y^4` in characteristic two, both pure second
derivatives vanish and the mixed derivative is `B x^2+D y^2`; hence the ordinary Hessian
determinant is again the square `(B x^2+D y^2)^2`.  The information-loss phenomenon is therefore
not cubic-only.  What *is* cubic-specific is the minimal `(2,2)` ordered-residual model.  C525's
four-contraction construction makes that cubic model the universal local residual for every
syndrome degree `n>=5`, which is the correct functorial claim.

**Evidence boundary.**  C519 proves the universal cubic residual and failure of the classical
discriminant; C525 proves the full constrained line theorem and all-degree pullback.  A fresh
full-text modular-invariant audit and a base-scheme naturality statement remain.

**Verdict:** `THEOREM-READY`.

**Scores:** novelty confidence `4`, notability `4`, audience breadth `3`, theorem readiness `5`,
tractability `5`, publication coherence `5`; weighted score **109/125**.

## Direction 4 — Lucas nuclei and affine root-space monodromy

**Published frontier.**  Gmainer--Havlicek give the Lucas-digit nucleus dimensions.  Linearized
polynomials, subspace polynomials, and their linear/affine Galois groups are established objects;
Gow--McGuire give representative modern monodromy theorems.  The literature located does not
select these covers from consecutive-row Lucas carriers.

**Candidate crown.**  Base-\(p\) digits canonically select affine root-space covers inside
consecutive-contraction kernels, with coefficientwise Frobenius on constant components read from
the same digits.

**Why it matters.**  The selection mechanism connects modular NRC representations to classical
linearized-polynomial arithmetic.

**Cheap kill.**  C530's witness count
`q(q-1)(q-2)(q-4)/1344` is exactly
`(q/8) * GaussianBinomial(m,3)_2`: the number of affine three-dimensional `F2`-subspaces of
`F_q`.  It adds no enumerative novelty beyond standard subspace-polynomial counting.
Likewise, generic affine monodromy is not a crown.

**Characterize test.**  C529 already proves the endpoint law for every `s`: the distinguished net
at `d=2^s` has constant field `F_(2^s)` and Frobenius order `s`.  What it does not prove is that
the rest of each carrier is canonically linearized.  The first failure of exhaustion is already
`s=3`, where `W_(e_7)/U_3` has dimension four.  C530 resolves that endpoint, and C531 is the
proper next two-strata test.

**Evidence boundary.**  The infinite endpoint family is proved in C529; the larger
`AGL_3(F2)` cover and standard affine-space count are proved in C530.  A carrier-wide digit law is
not proved and must not be inferred.

**Verdict:** `STRUCTURE-ONLY`, absorbed into Direction 2 and gated by C531.

**Scores:** novelty confidence `3`, notability `4`, audience breadth `3`, theorem readiness `3`,
tractability `4`, publication coherence `3`; weighted score **84/125**.

## Direction 5 — simultaneous MDS-extension complexes

**Published frontier.**  Roth and successors define higher-order MDS through list-decoding and
column-span intersection conditions.  Matroid deletion/extension spaces and arc extensions are
established literatures.

**Candidate crown.**  The simplicial complex of simultaneously adjoinable columns determines a
parent projective system or transfers to higher-order MDS.

**Why it matters.**  A genuine bridge would connect finite geometry, reconstruction, and
higher-order MDS/list decoding.

**Cheap kill.**  The object and its exact plane semantics are already in the pending `arcs` paper:
`thm-extension-conflict-hypergraph` says that simultaneous extensions are independent sets of the
pair/triple conflict hypergraph, and `comp-q11-extension-complex` gives the exact q=11 complex.
The hierarchy is real but elementary: three new collinear points on a line avoiding the parent
give a minimal nonface whose pairs are all legal.  This is already the triple-conflict clause, not
a new crown.

**Characterize test.**  C295's Clebsch locus is itself an arc, so its complex reduces to
independence in the pair-conflict graph.  No source or frozen theorem shows that C481 coherent
projection atlases recover the general triple-conflict data.  Recovering the parent first recovers
the complex, but that is not a bridge from atlas data to higher-order MDS.

**Evidence boundary.**  The exact complex semantics and q=11 spectrum are committed and pending
publication in `arcs`; the higher-order-MDS relationship is only analogy.

**Verdict:** `PRE-EMPTED` by the pending internal paper, with the proposed external bridge absent.

**Scores:** novelty confidence `1`, notability `4`, audience breadth `4`, theorem readiness `2`,
tractability `3`, publication coherence `2`; weighted score **65/125**.

## Direction 6 — algorithms for code equivalence and parent reconstruction

**Published frontier.**  Feulner gives practical canonical forms and stabilizers for sequences of
projective subspaces under the semilinear group.  Bouyukliev--Bouyuklieva give incidence-matrix
algorithms for linear-code equivalence.  Kreuzer reduces code equivalence to point-set and
polynomial isomorphism.  These are growing-input algorithms, unlike the fixed six-point inverse
in C481--C485.

**Candidate crown.**  A bounded set of punctured children gives a canonical, efficiently
verifiable certificate for common MDS parentage and semilinear equivalence.

**Why it matters.**  A complexity or certification advantage could interest coding and
computational-invariant audiences.

**Cheap kill.**  The C485 algorithm solves one quadratic after a fixed-size `4 x 6` kernel
calculation.  At six points this is constant-size algebra and has no asymptotic advantage over
generic projective-system canonization.  No benchmark can repair the absence of a growing input
model or complexity theorem.

**Characterize test.**  Four views are sufficient for the pure abstract Gale pair, not
information-theoretically necessary for complete-child recovery: for `q>=16` C485's literal child
alone recovers the unlabelled parent.  Missing-view robustness is therefore a different input
problem, already entangled with the pending reconstruction papers.

**Evidence boundary.**  C475/C481/C485 supply executable invariants and an exact inverse; no
complexity improvement, partial-data stability theorem, or unavailable certificate class is
proved.

**Verdict:** `KILL`.

**Scores:** novelty confidence `2`, notability `2`, audience breadth `4`, theorem readiness `3`,
tractability `4`, publication coherence `2`; weighted score **68/125**.

## Relationship tests

1. **Gale reconstruction ↔ extension complexes:** no direct bridge.  Literal parent recovery
   reconstructs the conflict hypergraph afterwards; abstract projected sextics alone do not
   recover its triple faces.  Separately, C537 tests whether C481's diagonal compatibility is the
   missing joint-consistency layer above Flatland's pairwise fundamental matrices.
2. **Polar flags ↔ Hessian--Arf:** yes.  C525 is the characteristic-two local residual model that
   supplies the nonclassical contained/transverse test needed by C512.  The link transfers a
   theorem, but the `(2,2)` statement remains clean enough for its own bounded audit.
3. **Lucas nuclei ↔ polar flags:** yes.  C529's affine root-space carriers are modular contained
   flags selected by C512's consecutive overlap.  Direction 4 is therefore absorbed into
   Direction 2 rather than promoted separately.
4. **Reconstruction ↔ algorithms:** only an explicit fixed-size inverse, not a complexity
   improvement or new canonization class.
5. **Root-space monodromy ↔ linearized RS geometry:** only the standard shared
   linearized/subspace-polynomial object was located; no functorial transfer theorem.

## Re-ranked portfolio and queue decision

| Rank | Direction | Score | Confidence interval | Decision |
|---:|---|---:|---:|---|
| 1 | Hessian--Arf replacement geometry | 109 | 101--115 | promote to C535 |
| 2 | coherent polar flags, absorbing Lucas carriers | 105 | 92--112 | promote to C536 |
| 3 | finite-field Gale reconstruction | 100 | 88--106 | promote only the Flatland functor comparison to C537 |
| 4 | Lucas root-space monodromy separately | 84 | 70--94 | merge into rank 2; C531 remains the arithmetic gate |
| 5 | equivalence algorithms | 68 | 55--78 | kill |
| 6 | simultaneous extension complexes | 65 | 55--76 | pre-empted/owned by pending `arcs` |

The highest-EV next falsifiable gate is C535: determine whether C525's constrained
divided-Hessian construction is a natural modular replacement beyond its cubic residual, or
whether full-text prior art/cubic specificity collapses the paper-shaped crown.  C536 follows with
the exact classical-Fano-versus-modular-overlap boundary.  C537 then performs the bounded
Flatland--Gale functor comparison; it is not a manuscript authorization.  C531 remains the lane's
execution next step and is not displaced.

## Mystery ledger

- **Settled — why the Gale direction felt unusually broad:** Flatland is a direct 2026 neighbor
  in line-image inverse geometry, and the pending paper portfolio already owns both deletion-child
  and continuation reconstruction.  This blocks a broad paper allocation.
- **Open — whether C481--C485 solve Flatland's explicit multi-view consistency gap:** exact owner
  C537; evidence gap is a functor-level identification of scenes, cameras, labelled line images,
  invariant quotients, equivalence groups, and the four-view Gale fibre.
- **Settled — whether C530's exact root-space count is new:** it is precisely standard affine
  three-space enumeration.
- **Settled — whether extension complexes give a fresh object:** the pending `arcs` paper already
  owns the general pair/triple hypergraph theorem.
- **Open — modular Hessian functoriality beyond the cubic residual:** exact owner C535; evidence
  gap is a full-text modular-invariant audit plus one naturality theorem or counterexample.
- **Open — whether coherent consecutive flags have nonclassical positive-dimensional contained
  components beyond persistent/Lucas loci:** exact owner C536, with C531 supplying the first
  degree-nine arithmetic boundary.

No other genuine mystery remains inside C534's triage scope.
