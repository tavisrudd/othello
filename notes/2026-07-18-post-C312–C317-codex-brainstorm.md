# Post-C312–C317 Codex brainstorm: questions, frontiers, and program exports

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** strategic brainstorm after C317; this is not a theorem report, task allocation, or
manuscript-scope decision.

## Executive assessment

C297 and C312--C317 turn the C210 aftermath from one failed ansatz into a structural theory of the
natural quadratic two-repair extension.  The sequence identifies the ambient moduli, solves the
seed-legality problem, finds its unique large survivor, reduces every remaining mixed collision to
four explicit finite maps, and proves that no fixed surviving configuration remains an arc through
its odd scalar tower.

The central open question is now exact:

> For infinitely many odd scalar degrees, does C315's trace-defined seed set contain a pair that
> simultaneously avoids the rational images of all four C316 collision maps, and, if so, is the
> resulting four-layer arc relatively complete with respect to the prescribed conic?

This is no longer a request to search a larger coefficient space.  It is a correlated
factorization-and-coverage problem on one explicit nine-dimensional arithmetic stratum.

The cumulative theory is substantial but its headline boundary matters.  It supports a strong
moduli/classification and fixed-coefficient mechanism-obstruction paper.  It does not yet support
a fresh-per-field asymptotic obstruction, a finite construction, or a global nonexistence theorem
for `C`-complete `O(sqrt(Q))` arcs.

## What the theorem stack delivered

| Task | New theory, bound, or tool | Assessment | Paper-facing weight |
|---|---|---|---|
| C297 | C210 is a codimension-three slice of the natural thirteen-dimensional constant-`p` quadratic family; exact projective and semilinear actions; possible linear-`p` branch | High conceptual significance | Reframes C210 honestly and defines the correct ambient moduli problem |
| C312 | Basis-independent seed--repair determinant/trace theorem; necessary-and-sufficient eight-packet legality system; exact constant, affine, pole, repeated-root, and deletion strata | High foundational significance | Reusable characteristic-two incidence engine rather than a one-off calculation |
| C313 | The normalized linear-`p` stratum is empty over every odd scalar degree by an exact trace contradiction | Medium-high, narrow but decisive | Short, clean closure theorem eliminating an apparently new branch |
| C314 | Lossless six-stratum atlas for the constant-`p` quotient, including reconstruction, stabilizers, relabelings, semilinear sheets, and every conic/packet degeneracy | High structural significance | A genuine moduli classification; central theorem plus likely appendix material |
| C315 | All eight legality packets force `c=K=1,B=0`; the sole survivor is a nonempty nine-dimensional constant-height `E4` open whose single-seed safe set has exact size `Q(Q+1)/4` before the ordered-pair inequality and zero-height deletions | Very high; the central classification theorem | Strongest positive structural result in the sequence |
| C316 | Common height cancels identically; all mixed collisions reduce losslessly to four finite relative-offset maps of generic degrees `6,6,5,5`, with degree `2` on repair-conic coincidence | High, including an important correction | Replaces an ill-specified height-image problem by four exact finite maps and branch ideals |
| C317 | Prescribed-target reduced fibers are zero-dimensional with genus-zero translation-line components; every fixed survivor collides after odd relative degree `1`, `3`, or `5`; fresh coefficients face four exact no-root gates plus coverage | Medium-high theorem significance, moderate headline significance | A sharp fixed-tower obstruction and an honest terminal boundary, not a per-field asymptotic theorem |

As a package, the work has strong structural and technical weight.  Its best narrative is:

> We classified the natural quadratic extension of the obstructed mechanism, found its unique
> positive-dimensional legal boundary, proved fixed-coefficient odd-tower failure, and isolated
> the exact arithmetic image-avoidance and coverage gates separating that boundary from a genuine
> construction.

## Frontier A: simultaneous finite-image avoidance

For a fresh configuration over `F=GF(2^n)`, collision-freeness on C315's survivor is equivalent to
four conditions:

1. the repair-1 degree-five seed--seed--repair eliminant has no linear factor;
2. the repair-2 degree-five eliminant has no linear factor;
3. the `Gamma_alpha` repair--repair--seed fiber has no `F`-point;
4. the `Gamma_beta` repair--repair--seed fiber has no `F`-point.

For the first two gates, the no-root factor types are exactly `(5)` and `(3,2)`.  The two
degree-six gates retain C316's exact `S=0`, branch, pole, and `Delta_R=0` skeleton.

### Questions

- Does the simultaneous no-root locus exist for infinitely many odd `n`?
- What is its size inside the ordered two-seed subset of `T_{rho,theta}^2`?
- Are the four avoidance events asymptotically independent, weakly correlated, or forced to be
  incompatible by a hidden invariant?
- Is there an identity among discriminants, resolvents, trace classes, or Frobenius signs analogous
  to C313's trace-sum contradiction?
- Does repair or seed interchange force paired factorization types?

### Most promising theoretical attack

1. Determine generic separability and geometric/arithmetic monodromy for each degree-five family.
2. Determine whether the two degree-five splitting fields are geometrically disjoint over the
   trace-defined parameter base or share a resolvent quotient.
3. Analyze the degree-six images over the same base and their correlation with the degree-five
   factorization types.
4. Apply an appropriate finite-field Chebotarev, character-sum, or geometric-sieve theorem only
   after proving the component fields and monodromy hypotheses.
5. Convert any density statement into an exact lower bound after removing C315's seed, conic, and
   common-height deletions.

Full symmetric monodromy would make derangement heuristics relevant, but it is not evidence by
itself.  The target subset is cut out by absolute-trace conditions and the four maps share seed
coordinates, so neither uniform target distribution nor independence may be assumed.

There is also a geometric-base caveat: the absolute-trace subsets are not one fixed Zariski-open
subvariety independent of `n`.  A Chebotarev argument would first need either an ambient geometric
monodromy theorem plus character-sum control on the trace slice, or an auxiliary
Artin--Schreier-cover formulation that geometrizes the trace conditions with all constant-field
twists audited.  Computing a generic Galois group alone would not prove the desired density.

## Frontier B: exceptional strata as construction candidates

The generic stratum need not be the best construction locus.  C315--C317 retain several exact
lower-dimensional strata rather than deleting them:

- repair-conic coincidence `Delta_R=0`, where the degree-six maps drop to degree two;
- repair--seed conic coincidences `Gamma_gamma in {0,Delta_R}`;
- the two packet repeated-root targets;
- branch targets of the degree-five and degree-six maps;
- the alternate repair--repair reconstruction chart `S=0`.

### Questions

- Does a lower-degree coincidence make rational collisions more unavoidable, or does its symmetry
  align the two seed conditions so that simultaneous avoidance becomes possible?
- Do branch targets force an `F`-point, or can nonreduced fibers remain supported only over proper
  extensions?
- Can the allowed packet repeated-root strata remove one collision gate without introducing a
  different mixed collision?
- Is there a positive-dimensional invariant exceptional stratum on which all four factorization
  types can be described uniformly?

These loci are attractive because their equations are already exact.  They should be treated by
structural factorization and trace analysis, not by being hidden under the word "nongeneric."

## Frontier C: relative coverage after collision avoidance

Passing the four finite root gates proves only that the four full layers form an arc.  The desired
construction must also cover every point of the prescribed conic by a secant of the selected set.

### Questions

- Can coverage be encoded as another bounded-degree relative-offset map over the `E4` survivor?
- Is the uncovered set controlled by a trace class, norm class, or small exceptional divisor?
- Does simultaneous collision avoidance force a coverage defect?
- Conversely, can a quantitative coverage condition force one of the four collision fibers to
  acquire a rational point?
- Can C302's carrierwise support-graph criterion turn a controlled-collision full layer into a
  collision-free relatively complete partial domain?

A theorem linking coverage density to collision-image density would be stronger than separately
classifying all four factorization types.  It could close the fresh-field problem even if the
simultaneous no-root locus is nonempty.

## Frontier D: coherent but nonconstant towers

C317 obstructs scalar extension of one fixed coefficient tuple.  It does not obstruct a rule that
chooses new coefficients in every field.

### Questions

- Can coefficients be chosen recursively along the odd tower while changing their Frobenius cycle
  types enough to retain no-root fibers?
- Is there a norm-, trace-, or Teichmuller-compatible choice that is coherent without being a
  literal scalar extension?
- Does any bounded-complexity algebraic rule over a fixed finite base eventually specialize to the
  same odd-degree closed-point obstruction?
- Can one prove a broader bounded-layer theorem: an unavoidable odd-length finite collision fiber
  rules out every fixed algebraic family over all odd extensions?

The distinction between fixed coefficients and fresh coefficients should remain explicit.  A
coherent tower result lies between them and may be the mathematically natural next obstruction
class.

## Frontier E: architecture beyond the quadratic two-repair mechanism

The completed sequence supplies design constraints for a genuinely different construction.

- A common vertical height offset is collision-invisible.
- Extra coefficient dimension is not automatically useful: seed legality collapses thirteen
  dimensions to the nine-dimensional `E4` boundary.
- A fixed unavoidable finite fiber of odd length eventually becomes rational on an odd extension.
- Collision avoidance and relative coverage must be designed together.

Promising departures therefore include:

- independent relative heights rather than a common offset;
- three or more repair cosets with a new incidence balance;
- nonquadratic or field-dependent repair functions;
- partial domains whose deletion pattern is designed simultaneously with coverage;
- incidence fibers forced into controlled even residue degrees;
- recursive coefficient choices that are not scalar extensions of one base tuple.

These are design principles, not evidence that any listed alternative succeeds.

## Bounded computational frontier

C305 rejected a raw `Q=512` census because the certified quotient remained enormous.  C316--C317
replace that raw space by four exact finite root tests on the legal `E4` base.

Potential computational work should therefore operate on invariant target coordinates and produce
factorization signatures, not enumerate raw repair coefficients.  A useful compact record for one
candidate would contain:

- normalized survivor coordinates and quotient conventions;
- the two canonical degree-five polynomials and their factor degrees;
- exact rational-point certificates or no-root factorizations for the two degree-six fibers;
- direct collision reconstruction for every claimed root;
- direct prescribed-conic coverage or an exact uncovered-set certificate.

The new formulation may make bounded experiments informative, but no feasibility claim follows
without a fresh quotient and operation-count audit.

## Reusable exports to other programs

| Export | Reusable principle | Likely consumers, subject to lane-specific audit |
|---|---|---|
| C312 trace packets | Reduce characteristic-two pair splitting to pair-sum and Artin--Schreier trace data | Baer and other characteristic-two incidence constructions |
| C314 atlas | Quotient a coefficient family while retaining arithmetic sheets, stabilizers, relabelings, and reconstruction | Baer, cubic, Clebsch, and other symmetry-heavy moduli problems |
| C301+C317 dimension audit | Decide first whether the relevant fiber is a curve or a finite scheme; use genus bounds only in the former and residue-field/Frobenius cycles in the latter | Any algebraic-geometry lane using point supply |
| Odd-degree finite-fiber lemma | A fixed finite fiber of odd length has an odd-degree closed point and becomes rational over an odd extension bounded by that length | Fixed-coefficient collision, repair, and completion mechanisms |
| Four-gate formulation | Replace a raw coefficient census by correlated finite-map image avoidance | Computational finite-geometry and certificate-oriented searches |
| Legality/collision/coverage separation | Prove internal legality, mixed collision-freeness, and relative coverage as independent gates | All layered arc/cap constructions; partial-domain work via C302 |
| Exact degeneracy skeleton | Treat coincidences and ramification strata as candidate mechanisms rather than discarded exceptions | Conic, cubic, Baer, and exceptional-incidence studies |

### Nofil and projective-cap work

The four-layer survivors and their exact collision hypergraphs may supply structured static arcs or
controlled finite game positions.  Their use in Nofil would require a separate game-value theorem:
static extendability, collision counts, or `C`-completeness do not determine impartial-game value.

### Manuscript and continuation work

The sequence is a reusable pattern for a bounded negative paper:

1. identify the ambient moduli rather than overstate an ansatz;
2. solve legality invariantly;
3. isolate every survivor and exceptional divisor;
4. audit the actual incidence-fiber dimension;
5. prove the strongest fixed-family obstruction available; and
6. name the remaining arithmetic and coverage gates without promoting them to nonexistence.

This pattern can strengthen continuation or complete-ports exposition even when the underlying
mathematics is unrelated.

### Formalization candidates

C313's trace contradiction and the elementary odd-degree finite-fiber lemma are compact and stable
formal targets.  C312's packet theorem is a larger possible characteristic-two incidence API.  A
formalization would certify those reusable kernels, not the unresolved monodromy or coverage
questions.

## Questions of broader theory

1. Is there a general bounded-layer tower obstruction for fixed algebraic full-layer
   constructions with an unavoidable odd-degree incidence fiber?
2. Must an infinite fresh-field family evade such an obstruction through even Frobenius cycles,
   changing coefficients, projection collapse, or increasing algebraic degree?
3. Are trace-defined arithmetic target sets statistically generic for factorization type, or do
   their Artin--Schreier origins force hidden monodromy restrictions?
4. Is C315's `E4` stratum a genuine construction signal, or the universal terminal boundary where
   seed legality becomes compatible but mixed collisions remain arithmetically unavoidable?
5. Can relative coverage itself force a rational collision, producing a direct construction-versus-
   obstruction dichotomy without a complete factorization census?

## Priority assessment

The highest-value frontier is the simultaneous finite-image problem, beginning with the two
degree-five monodromy and correlation questions.  It directly decides whether the `E4` survivor is
a construction signal or only a fixed-tower boundary.  Coverage should be formulated alongside
that work, not postponed until after a large search.

Exceptional strata are the best bounded secondary front because their equations and degree drops
are already exact.  A quotient-aware `Q=512` pilot is useful only after a new feasibility audit and
should test factorization signatures, not repeat C305's rejected census.

The cross-lane exports are mainly methods: trace packets, invariant atlas construction,
fiber-dimension discipline, and the odd-degree finite-fiber principle.  They should be imported by
exact lemma or interface after a consumer-lane audit, not by analogy alone.

## Red-team review after the initial commit

The initial report was committed before this review, as requested.  The following are the main
adversarial findings and their dispositions.

| Risk | Adversarial finding | Disposition |
|---|---|---|
| Count overstatement | `Q(Q+1)/4` counts C315's one-seed safe set `T_{rho,theta}`. The ordered two-seed survivor also imposes `X_alpha!=X_beta` and zero-height deletions. | Corrected the C315 summary; no exact ordered-pair count is claimed here. |
| Chebotarev shortcut | Absolute-trace subsets vary with the field and are not automatically a fixed geometric base. Generic monodromy does not by itself control factorization on that slice. | Added the required ambient-plus-character-sum or Artin--Schreier-cover gate. |
| False independence | All four fibers share seed and repair parameters. A product of individual derangement probabilities could be completely wrong. | Independence remains an explicit question, not a heuristic conclusion. |
| Computational optimism | Four root tests are conceptually smaller than a raw coefficient census, but the legal base and quotient may still be enormous. | Retained a mandatory operation-count and quotient feasibility audit before any `Q=512` run. |
| Coverage afterthought | Even a positive-density collision-free locus may contain no relatively complete member. | Coverage is a coequal frontier and should be formulated before a large collision search. |
| Fixed/fresh conflation | The odd-degree-five argument obstructs scalar extensions of one fixed tuple. It supplies no density bound for tuples chosen anew over each field. | The fixed, coherent, and fresh regimes remain separated throughout. |
| External novelty | Internal theorem strength does not establish publishable novelty or priority relative to the finite-geometry literature. | Paper-weight judgments are provisional pending a targeted literature comparison and manuscript-level novelty audit. |
| Cross-lane analogy | A method that worked for quadratic conic layers may not match another lane's objects, hypotheses, or quotient. | Every proposed export requires a consumer-owned theorem-interface audit; no cross-lane result is asserted. |
| Paper coherence | A collection of exact classifications can still read as an appendix to a failed construction rather than a unified paper. | The proposed paper needs one central statement: ambient-moduli classification plus fixed-tower obstruction and the exact fresh-field boundary. |

The review does not overturn the priority assessment.  It does lower confidence in any quick
Chebotarev or bounded-census resolution and reinforces that coverage must be developed alongside
factorization.  It also makes the paper-weight assessment conditional: the mathematics is
substantial internally, but external significance requires novelty diligence and a manuscript
that compresses the atlas and packet machinery around one visible theorem spine.

## Evidence and non-claims

The closed inputs are C297 and C312--C317.  Statements attributed to them are theorem summaries;
the proposed monodromy, density, exceptional-stratum, coverage, computational, cross-lane, and
formalization directions are open research questions or strategic suggestions.

This report allocates no task, changes no lane, and establishes no new computational or literature
claim.  It does not assert that the four no-root gates are simultaneously satisfiable, independent,
or asymptotically distributed; that a collision-free survivor is relatively complete; or that any
alternative architecture succeeds.

## Vibe check

The frontier is narrower and better than "search more coefficients."  The disappointing loss of a
Hasse--Weil curve obstruction exposes a more precise problem: correlated factorization and
coverage on an explicit arithmetic moduli space.  That problem is difficult but mathematically
natural, potentially reusable, and capable of producing valuable finite-field theory whether its
answer is constructive or obstructive.
