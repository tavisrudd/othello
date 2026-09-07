# Cubic pair: Astra feedback vetting and action queue

**Lane:** `cubic-threefolds`
**Date:** 2026-09-07
**Scope:** Review the author's pasted mathematical assessment, percentile grades,
and exposition recommendations against the current authority; queue action.

## Verdict and evidence boundary

The feedback contains useful deductions and editorial proposals, but is not a
second proof certificate for either headline theorem. Two proposed repairs are
already in the authority at `6034287a6` (2026-09-06): the cyclic-centralizer
argument in `prop:rank2-rigidity`, and the containment in `eq:witness-cover`.
Do not allocate their implementation again. Verify their proof/provenance and
release status as part of C1116.

This pass read all three current m1 section files and the complete sharpness
manuscript, inspected the lattice input and weight construction in
`verification/derive_slice_cover.py`, and checked Bittner's Theorem 3.1. It
did not replay the finite computations, the full certificate gates, Lean, or
mirror exports. Astra's sandbox Python/JSON links are not available artifacts
in this conversation. In particular, 1,992 is an attributed count awaiting
reproduction, not a computation certified by this report. No manuscript was
changed by this triage.

The handoff contains superseded all-stabilization claims. Its current C956 and
C978 cards and the actual manuscripts determine the scope here. The two
headline papers remain open by author instruction. The initial handoff read
exceeded the output limit; the complete file was then read in bounded chunks.
No conclusion relies on the truncated output.

## Claim-by-claim decisions

| Feedback | Decision | Remaining gate / owner |
|---|---|---|
| Cubic matrix, smoothness, determinant, Bezout checks | Existing evidence plus an unavailable attributed replay; no new certification here | C1116 checks source revisions and existing gate coverage |
| Nilpotent persistence | Repair already present, including continuation of a separated cluster, cyclicity over the formal ring, regular coefficient, and homogeneous recursion for N squared | C1116 audits the repaired argument and formal-coverage correspondence |
| Faithful center comparison | Highest-risk interface remains open to targeted scrutiny, regardless of earlier Accept reports | C1116 |
| Witness-cover equality | Already corrected to the sufficient containment; Astra's localized equality is equivalent for the intended purpose | C1116 checks release consistency; no further notation rewrite needed |
| Additive Bittner extension | Formal deduction is sound **if** the operation formulas identify every center occurrence intrinsically in every dimension | C1117 after C1116 |
| Spectrum-valued refinement | Plausible, but stronger than preservation of exponent classes modulo integers | C1117 separately proves exact discriminant transport and a common target |
| Hodge-diamond example | Correct conditional use of the blowup formulas; use a smooth bidegree-(2,6) curve on a split quadric in P3, of degree eight and genus five | C1117 |
| Net three marker units in dimension five | Correct conditional telescoping consequence of intrinsic center formulas, with signs oriented from the cubic product to P5 | C1117 |
| Every marked threefold stays irrational after P1 | Direct consequence of the existing dimension-four argument | C1120 |
| Unique rank-four candidate and orbit obstruction | Mathematical reduction is persuasive; numerical claims still require exact reconstruction and an independent check | C1118 |
| All characteristic-zero fields | Correct consequence of finite-coefficient descent of a birational map and its inverse | C1120 |
| Generic del Pezzo surfaces have exact level two | Correct using the specified generic-fiber field identification, conditional on the companion lower bound | C1120 |
| Genus-eight partners have level two | Correct only for partners related to the specific level-two cubics over the field of the correspondence | C1120; not a claim about every genus-eight Fano |
| Quantitative fibration identity | Correct consequence of the displayed birational equivalence, with geometrically integral varieties and infinity convention stated | C1120 |
| Finite-index slice degree divides index | Viable proof outline; needs a descended geometrically integral component, dominance, and degree argument | C1119 |
| Coprime-index universal CH0-triviality | Viable once the parametrizations exist; write resolution, moving, and degree-one-cycle arguments for every field extension | C1119 |
| Deformation-invariant quantum data cannot completely detect stable rationality | Correct conditional conceptual limitation, with marked versus unmarked data distinguished | C1117 coda; no new detector claim |
| Higher-rank pairing counterexample | Direct displayed matrix identities support the warning; general regularity inequality also needs the leading-term/Jordan-frame hypotheses | C1117 records the boundary; no higher-rank programme allocated |
| Finite-jet and quotient engines | Useful directions already overlap the software queue | Route through C963/C965/C966; no duplicate engine tasks |
| Percentile grades and commercial expectations | Subjective assessment, not evidence of correctness, priority, referee readiness, or product value | No grading task; no commercial expansion |

## Why the proposed deductions work, and what they do not establish

### Additive motivic construction

Bittner's Theorem 3.1 presents the **abelian group** using smooth projective
classes, the empty class, and the blowup relation. It does not require a
multiplicative assignment. If the current faithful-center lemma really gives
`c_exp(omega_j)=I_exp(Z)` for all centers, composing the count with N -> Z
satisfies that relation because

    I(Bl_Z Y) - I(P_Z(N)) = I(Y) + (c-1)I(Z) - cI(Z).

Disjoint unions and the empty variety must be explicitly included. The final
m1 paragraph's appeal to missing multiplicativity is not a valid reason to
deny an additive extension. The genuine issue is the geometric comparison
hypothesis, not group completion of N.

For a smooth projective Y, the scissor relation for Y x P1 and the product
formula give `Ical(L[Y])=Ical([Y])`. Smooth projective generators then give
`Ical((L-1)a)=0` for every a. This is an additive map from the quotient
group underlying `K0(Var_C)/(L-1)`. It is not a ring homomorphism;
`Ical(1)=Ical(L)=0` and `Ical([X])=1` already preclude that.

For the Hodge comparison, take a smooth curve C of bidegree (2,6) on a
quadric P1 x P1 in P3. Adjunction gives genus (2-1)(6-1)=5.
Blowing up a cubic threefold at a point adds one
class in bidegrees (1,1) and (2,2). Blowing up P3 along C adds the same two
classes and five classes each in (2,1) and (1,2), reproducing the cubic's
off-diagonal Hodge numbers. Marker values are 1 and 0 if the operation
formulas hold. No new quantum calculation is needed for this example.

Exact discriminants need their own transport proof. Arbitrary independent
integer shifts of two exponent representatives preserve their classes modulo
Z but can change the squared gap. The spectrum refinement must use the
canonical modified lattice and the actual regular comparisons, proving that
any shifts are common where needed. The scalar criterion alone does not
prove this refinement.

In a factorization from X x P2 to P5, forward blowups add `(c-1)I(Z)` and
forward blowdowns subtract it. Initial value 3 and terminal value 0 give
blowdowns minus blowups equal to 3. Dimension at most two vanishes, so the
only nonzero terms are threefold centers of codimension two. This does not
give three distinct centers, identify a cubic center, or construct a weak
factorization. An explicit factorization is a later research promotion,
not part of the presently allocated proof of the numerical constraint.

### Field and stabilization corollaries

A birational map over a characteristic-zero field F, its inverse, and their
identities involve finitely many coefficients. Descend them together to a
finitely generated subfield F0/Q, including the necessary nonzero
denominators. F0 embeds in C. This contradicts the complex lower bound;
the upper bound base-changes from Q. There is no need to embed all of F.

For the specified generic surface, rationality of S x A1 over F(t) would
make F(X)(u) a rational function field over F. Rationality without
stabilization also implies rationality with one stabilization. This proves
the surface lower bound once the cubic lower bound and fiber identification
are accepted, even when the Galois type shrinks after field extension.

For every V and integer a >= 0,

    ell(V x A^a) = max(ell(V)-a, 0).

This follows directly from the definition and monotonicity of rationality
under further stabilization. Applying it to
`Y x A2 ~ B x A4` proves Astra's fibration identity, including the infinite
case. The implication for genus-eight partners uses one further P1 factor
and `P1 x P1 ~ P2`; it requires an actual correspondence to X1 or X3.

### Rank four and finite index

For rank four inside a rank-five torus, the character restriction has a
saturated rank-one kernel. A Galois-stable rational line carries a sign
character, so the four simultaneous sign systems on the two generators
exhaust the possibilities. A primitive generator supplies saturation.
To finish Astra's obstruction, independently derive the quotient weights
modulo this line and their affine Galois action; raw coordinate permutations
alone are not a substitute when restricted weights may coincide. If the
sixteen restricted weights are distinct with orbits of sizes 4 and 12,
there is no descended five-weight window. This is optimality only for the
stated linear Cox-weight criterion for **full** I3.

For finite index d, the difference characters define an isogeny of split
tori after extension of constants. Its kernel K has order d in characteristic
zero. The rank/minor equations make the orbit-section intersection a K-torsor
on the free open. The component through the tangent-projection isomorphism
open is the closure of the inverse image of a linear P^(n-r); this is the
candidate geometrically integral k-rational component. Transversality must
give its dominance onto the quotient. Over algebraically closed constants,
the finite etale generic torsor splits into field components corresponding
to monodromy orbits in K, so component degrees divide d. To descend that
degree assertion, prove geometric integrality of the chosen component and
the quotient so constant extension preserves its degree. These are proof
obligations for C1119, not a substitute for them.

Coprime degrees then annihilate A0 over every extension after resolving the
parametrizations and moving cycles onto the finite flat locus. Also supply
a degree-one cycle (in this situation a rational parametrization over an
infinite field supplies a rational point on the proper target). Killing A0
alone is not the entire statement of universal CH0-triviality.

## Editorial decisions

The proposed six-section m1 rewrite is a possible implementation, not an
acceptance requirement. Prefer the smallest reorganization that gives an
adjacent expert a complete first route. C978 owns:

1. An early occurrence-indexed reduction with the values 1, 2, 0, and the
   dimension-five boundary before technical machinery.
2. A concrete rank-two residue display `(a,nu;c,d-1)`, followed by the
   canonical construction; a resonant/nonresonant example.
3. Visible separation of regular-gauge invariance, deformation persistence,
   and comparison compatibility; retain faithful coefficients in the main text.
4. Postpone groupoid/monoid formalism as useful, eliminate tautological
   diagrams, and resolve A(z)'s connection/gauge collision. Preserve labels
   and annotation dependencies when moving text.
5. Move secondary corollaries alongside their proofs and make the small-to-big
   bridge explicit. Generic parameters and primary blocks already have partial
   orientation in the current paper; improve without duplicating it.

C956 owns sharpness exposition:

1. Show the same quotient as P4 and S times a rank-two torus, with dimensions
   7, 5, 3, 2 and the upper/lower-bound dependency visible.
2. Put a rank-one example before the criterion and separate orbit uniqueness
   from rationality of the component. Introduce finite-index ambiguity only
   as an example until C1119 passes.
3. Present descent of the incidence open before selecting ground-field data.
   The current text already does this correctly; retain its exact hypotheses.
4. Explain uniform symbolic coverage before the witness table, then walk one
   witness through evaluation and smoothness. The corrected containment is
   sufficient and should not be churned merely to match Astra's notation.
5. Preserve the full AI disclosure, distinguish external geometric inputs
   from finite certificates, and inspect the revised rendered pages.

Mathematical extensions follow the original proofs; they must not make the
first definition more abstract. No new parallel reviewer-guide system is
needed. Prose work can proceed locally while proof tasks remain pending, but
it must not promote their conclusions in an overview or abstract.

## Source checks and version boundary

- Bittner, Theorem 3.1 and its projective-generator clause: cached
  `arXiv:math/0111062`, SHA-256
  `484d2c3586977503dc6f1b43fca158af059cd0f9c5322731d0ebae6d643e160c`.
  Read the theorem in the cached extraction; checked the official record and
  HTML on 2026-09-07: https://arxiv.org/html/math/0111062v1 .
- Tschinkel--Zhang: current manuscript pins v1; the shared cache contains that
  24-page version, SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
  The official record now lists v2 dated 2026-08-28, 25 pages:
  https://arxiv.org/abs/2608.20029 . Its introduction identifies the two cubic
  constructions as Propositions 5.1 and 5.3, rather than 5.1 and 5.2:
  https://arxiv.org/html/2608.20029v2 . This warrants a bounded comparison of
  used inputs before updating citations; no automatic source repin.
- Astra's link [7] is the Tschinkel--Zhang paper, not the Engel--de Gaay
  Fortman--Schreieder paper. The manuscripts identify the latter as
  `arXiv:2507.15704v3`. Preserve separate citations; do not copy that link
  as evidence of both theorems.
- No priority or absence-of-prior-work finding was attempted. Every proposed
  novelty claim still needs the repository's literature-audit procedure.

## Queue and next move

1. **C1116**: proof-interface and source-version audit of both papers, including
   the already-landed errata. Highest EV: the other upgrades inherit these risks.
2. **C1120**: low-cost stabilization corollaries after the relevant C1116 gates.
3. **C1117**: additive motivic extension, exact spectrum gate, Hodge example,
   and factorization constraints after the all-dimensional comparison gate.
4. **C1118**: exact full-I3 rank-four obstruction certificate; independent of
   the quantum proof, contingent on correctly transcribed lattice inputs.
5. **C1119**: finite-index slice and coprime-degree theorem, after quotient
   foundation audit; no existence claim for new coprime-index slices.

C978 and C956 retain the exposition work above. C963/C965/C966 retain
algorithmic work; integrate validated finite-index outputs there later.
Queueing does not promote a proposed theorem to an accepted manuscript claim.
Publication, deposit, and author-restricted task closure remain separate.

## EJ + TT closeout / Mystery ledger

The triage gate is a disposition and owner for every substantive proposal,
with duplicates removed and unverified computations explicitly marked.
An explicit EJ + TT pass after that gate found:

- **Settled cheaply:** the Hodge example can name a bidegree-(2,6) quadric curve;
  the fibration identity is a direct stabilization-shift identity; both reported
  errata were already fixed.
- **Open, C1116:** does the actual completed coefficient comparison recover
  intrinsic center data without an invalid passage through a noninjective image?
  Need the exact source-to-target diagram and topology, not another Vandermonde
  calculation in a surrogate ring.
- **Open, C1117:** does exact squared-gap data survive every comparison, beyond
  preservation of exponent classes? Need canonical-lattice transport.
- **Open, C1118:** does the unique rank-four restriction really have the stated
  orbit partition? Need exact quotient-lattice and affine-action certificates.
- **Open, C1119:** can examples realize useful coprime indices while satisfying
  tangent and descent hypotheses? The theorem alone supplies no examples.
- **Deferred:** locating the three net contributions in an explicit weak
  factorization requires a new geometric construction after C958 and C1117;
  it is not an unexplained arithmetic discrepancy.

No incidental discovery-log entry was needed: the observations above were
targets of the requested review, and are retained here with their owners.
