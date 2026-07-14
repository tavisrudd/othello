# Adversarial novelty review — equivariant extension and robust completion

**Date:** 2026-07-13
**Scope:** only *Equivariant extension and robust completion of finite-geometric arcs*,
[`paper-baer-equivariant-robust-completion.md`](2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md),
including its Appendix A discovery list. No other proposed paper was audited here.
**Companion proof audit:**
[`baer-completion-adversarial-review.md`](2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md).
**Method:** three adversarial passes, divided into finite geometry, abstract completion/hypergraphs,
and applications/algorithms, followed by a claim-by-claim reconciliation with the earlier
Baer-extension citation audit. This is a broad literature screen, not a claim of exhaustive
MathSciNet/Zentralblatt priority clearance.

## Executive verdict

The paper remains viable, but its defensible novelty is narrower than its current discovery ledger
suggests.

1. The abstract completion framework is a useful, reusable, kernel-checked synthesis. Its central
   identities are standard conflict/correction-set, transversal, blocker, defining-set, or
   asymmetric-code facts in paper-specific language. Formalization and unification are real
   contributions; historical invention of the underlying combinatorics is not.
2. The strongest surviving paper-specific result is the exact quadratic-Frobenius conjugate-pair
   extension theorem: its empty-Baer-line decomposition, restricted forbidden charge, exact
   coordinate discharge, and semantic construction of a legal orbit extension. No exact prior
   theorem with this orbit-valued statement was located. Its proof is elementary counting, so it
   should be sold as a clean structural criterion and verified synthesis, not as a deep new
   inequality.
3. The square-root constant is not new. It is the classical Lunelli–Sce scale at `q=s²`. What may
   be new is obtaining it under the weaker condition of *no conjugate-pair extension*, rather than
   ordinary completeness. That distinction is potentially meaningful but needs an example or a
   sharper consequence to become a strong headline.
4. The exact support/invisible/collision correction has since been Lean-proved. The exceptional
   `f=2` existence theorem is now also Lean-proved by `Q25PairResult.f2_pair_extension`; its census
   size and observed minimum 32 remain external computation. The `f=0,4` geometry is only sketched,
   so the uniform order-five conclusion remains unproved.
5. Two proposed notions have direct terminology-level collisions: `premium_G=δ_G/δ` is the known
   **cost of symmetry** `τ_G/τ`, and deletion-resistant defining sets have a close 2026 antecedent as
   **k-strong defining sets**. They must be cited and reframed.

The safe contribution claim is therefore:

> We give a kernel-checked common framework translating finite-geometric insertion into standard
> obstruction-transversal language, and use it to prove an exact orbit-valued extension criterion
> for quadratic Frobenius-invariant arcs. The abstract blocker, weighted, reliability, symmetry,
> and asymmetric-distance connections are applications of established theories; possible further
> novelty lies in geometric evaluations made possible by the Frobenius-restricted obstruction map.

## Verdict vocabulary

- **Classical / direct collision:** the same invariant or theorem is already standard.
- **Standard specialization:** immediate application of established theory; useful, but not
  historical novelty.
- **Packaging novelty:** an apparently unlocated combination or statement interface whose
  ingredients and proof are standard.
- **Plausibly new, conditional:** no exact collision located, but a concrete theorem still has to
  be proved or its separation from known results demonstrated.
- **Open / too vague:** not yet a claim that can be audited.

Formal proof status and novelty status are independent. A newly formalized classical theorem stays
classical; an unformalized new consequence stays conjectural.

## Main theorem package

| Paper item | Novelty verdict | Adversarial finding and required treatment |
|---|---|---|
| Theorem A: `δ_x(C)=τ(H_x(C))` | **Classical schema / standard specialization** | This is correction-set versus conflict-set duality, minimal diagnosis as hitting set, and monotone Boolean dualization. Say that the paper formalizes and applies the standard duality to finite hereditary independence systems. |
| Proposition A.1: minimal-obstruction clutter | **Classical** | Removing every hyperedge containing another preserves transversals and the blocker. Present as the canonical Sperner/clutter reduction, not a discovered strengthening. |
| Theorem B: sharp facet-completion radius | **Standard defining/teaching-set lemma** | The directional separation formula is elementary. State an explicit nonempty alternative-facet hypothesis; otherwise the minimum is empty. Identify the intended facet family as maximal/Sperner. The Lean theorem proves separation from a supplied alternative facet, not existence of such a facet. |
| Theorem C: arc insertion distance equals point secant index | **Known argument / elementary classical specialization** | Secants through an external point give disjoint pairs, so their transversal number is their count. Alderson explicitly uses the operation “choose one endpoint from every secant through the proposed point, delete those choices, then add the point.” The reusable abstract-projective-plane formalization and optimization terminology are valuable, but the geometric maneuver and point index are classical. |
| Theorem D: exact classical radii | **Classical application table** | Each row is an incidence count, not a new completion theorem. Cite primary sources and call the displayed numbers translations into completion language. The spread row must be restricted; see below. |
| Theorem E: fixed/conjugate secant decomposition | **Packaging/generalization, low novelty** | Fixed blocks and two-element orbits under an incidence-preserving involution are elementary group-action facts. The abstraction usefully isolates the actual hypotheses, but should not be claimed as a discovery. |
| Theorem F: exact quadratic conjugate-pair criterion | **Best surviving plausible paper-specific result** | No exact prior orbit-valued criterion with the displayed `E`, `M`, and legal-pair lower bound was located. The three geometric failure cases in fact form an **iff**, but essentially the same conjugate-pair addition maneuver appears in Baker–Wantz's Hughes-plane work. Adjacent group-invariant-arc and Baer-conic papers do not give this general quantitative Galois-orbit count. Frame it as an exact restricted Frobenius incidence criterion; acknowledge the classical maneuver and covering/union-bound mechanism. |
| Theorem F.1: heterogeneous linewise sum | **Elementary refinement / paper-specific bookkeeping** | `Σ_l(N_l-M_l)_+` is linewise set subtraction, but `M_l` is currently ambiguous. If it counts distinct forbidden candidates, equality is exact; if it counts secant-orbit charges with multiplicity, the expression is only a lower bound. Use separate support and charge-mass symbols. It earns paper weight only if it produces a sharper threshold, equality classification, or inverse theorem. |
| Candidate F.2: `PG(2,25)` profiles `f≠2` | **Unproved; novelty review deferred** | Intended bounds are five extensions for `f=0` and four for `f=4`, but center/moment geometry is not Lean-checked. Do not list this as a result. |
| Theorem F.3: `s=5,f=2` pair extension | **Lean-proved; priority not definitive** | `Q25PairResult.f2_pair_extension` proves universal existence through checked field, normalization, orbit-coverage, determinant, and semantic layers; its conclusion explicitly makes both conjugate points fresh. A second adversarial proof audit found no proof-validity defect. The targeted search found no exact statement, but older tables/code-lengthening terminology remain a priority risk. |
| Computed datum F.4: `s=5,f=2` census/minimum | **Evidence only; not a claim** | Two external implementations report 469600 normalized arcs and observed minimum 32. These stronger numerical claims are not implied by the Lean existence theorem. |
| Corollary G: invariant eight-arc extension | **Plausibly unrecorded modest corollary** | No exact `s≥7` formulation was located. It is direct arithmetic from F, not a separate method. Check small complete-arc classifications, especially `PG(2,25)`, for indirect overlap before a priority claim. |
| Corollary G: square-root saturation | **Partial collision** | The `√2` scale is the classical Lunelli–Sce complete-arc lower-bound scale at `q=s²`, and Ng–Wild obtain the adjacent square-root scale for arcs whose secants cover an external line. The possibly new point is the weaker, Frobenius-quotiented no-*orbit*-extension hypothesis. Do not advertise a new constant or saturation paradigm. Demonstrate a pair-saturated but not ordinarily complete family, or improve the constant, to make this a strong result. |
| Theorem H: persistent robust holes | **Elementary monotonicity** | Persistence of certified old obstruction edges preserves the lower bound. New edges cannot help a deletion set, but they are “harmless” only for this noninsertability lower bound—not for exact distance, equality, or insertability claims. |

### Corrections to the classical-radius table

| Configuration | Review finding |
|---|---|
| Odd-order nonsingular conic | The global minimum `(q-1)/2` is correct, but the local spectrum is not uniform: external and internal points have `(q-1)/2` and `(q+1)/2` secants respectively. Say explicitly that the table gives the minimum. |
| Even-order hyperoval | The uniform external value `(q+2)/2` is consistent with the standard secant partition. Citation still required. |
| Maximal degree-`d` arc | The uniform value `q-q/d+1` is the standard external-point secant count. Citation still required. |
| Elliptic quadric `Q^-(3,q)` | The displayed `q(q-1)/2` is the standard count for an external point in the cap/secant interpretation. State the relevant point class and cite it. |
| Generalized-quadrangle ovoid | `t+1` is the standard incidence count for a point outside the ovoid. Citation still required. |
| Spread of `PG(2n-1,q)` | **Overgeneralized as written.** The value `q+1` is automatic for line spreads of `PG(3,q)`. For an `(n-1)`-spread in `PG(2n-1,q)`, an insertion candidate of the relevant type induces a subspace partition whose size is not generally `q+1`. Restrict the row to line spreads in `PG(3,q)`, or replace the value by the appropriate induced-partition count with hypotheses. |

## Formalization/discovery ledger disposition

The following table audits every item currently labelled as a proved strengthening, reusable
corollary, coordinate theorem, semantic closure, arithmetic corollary, or formalization warning.
“Keep” here means keep in the proof/trust ledger, not claim historical novelty.

| Ledger item | Disposition |
|---|---|
| Minimal-edge reduction preserves transversals and `τ` | **Keep as classical infrastructure.** Cite clutter/blocker theory; remove “proved strengthening” if that phrase implies novelty. |
| Heterogeneous linewise bound and equality | **Keep as an elementary refinement.** Candidate paper strength comes only from a nontrivial geometric consequence. |
| Persistence of old obstructions | **Keep as monotonicity.** Qualify the scope of “new obstructions are harmless.” |
| Abstract-projective-plane secant resilience | **Keep as a reusable formalized dictionary.** It is not a new finite-geometry invariant. |
| Arbitrary incidence-preserving involution | **Keep as proof-spine generality.** It exposes assumptions but is elementary. |
| Weighted completion identity | **Keep as standard weighted hitting set.** A new exact geometric weighted evaluation could be publishable. |
| Multi-insertion identity | **Keep as a checked prescribed-set API.** Calling it a “strict generalization” needs an example of irreducibly multi-target behavior; singleton specialization alone only proves API extension. |
| Weighted multi-insertion | **Keep as immediate composition.** Replace “weights and insertion commute” by “the prescribed-set representation admits nonnegative vertex weights.” |
| Exact coordinate candidate/empty-line/forbidden-count discharge | **Keep as support for Theorem F.** The component counts and injective-charge proof are valuable verification; elementary coordinate facts are not separate discoveries. |
| Semilinear projective action preserves incidence | **Classical infrastructure.** Do not list as a discovery. |
| Projective fixedness is semilinear eigenvectorhood | **Important formalization warning, classical.** Retain to prevent an invalid coordinatewise-fixed shortcut. |
| Hilbert-90 normalization and fixed-locus/cardinality results | **Classical infrastructure.** Retain in the trust story only. |
| Fixed-point-free conjugation and two-element mate fibers | **Classical orbit counting.** Retain as proof support. |
| Exact fixed two-traces / occupied and empty fixed-line count | **Paper-specific assembly of classical incidence facts.** Support for F, not a separate discovery. |
| Exact two-element nonfixed-secant orbits and injective forbidden charge | **Core mechanism of Theorem F.** The restricted charge construction is the most plausible place for paper-specific novelty; do not split its elementary orbit facts into separate claims. |
| Semantic closure from survivor to actual arc extension | **Essential theorem adequacy, not a novelty claim by itself.** It closes a real logical gap and belongs prominently in the proof account. |
| Eight-arc `M≤12` and `s≥7` surplus | **Arithmetic corollary of F.** Search found no exact collision, but it is elementary and should be presented as an explicit instance, not a headline. |
| Completed-square occupation identity | **Elementary algebra supporting G.** Full-occupation consequences may be useful, but the square-root scale remains classical. |

## Appendix A claim-by-claim audit

### A.1 Blocker duality

**Verdict: direct classical collision.** For a clutter `H`, its blocker is the clutter of minimal
transversals and `b(b(H))=H`. Diagnosis has long described minimal diagnoses as minimal hitting
sets of conflicts. The paper may specialize this to insertion certificates, but it must not rank
the duality itself as a novelty bet. Replace “stronger” with “retains the full standard certificate
duality rather than only its optimum value.”

### A.2 Weighted completion

**Verdict: standard weighted hitting set.** Nonnegative vertex costs follow immediately from the
representation. Finite weights model unequal deterministic cost. They do **not** by themselves
model correlated failures; correlation requires a joint stochastic law. Whole-orbit constraints
model grouped actions. Protected coordinates require a prohibition or an infinite-cost convention,
not merely an unspecified finite weight.

### A.3 Orbit-quotient clutters

**Verdict: standard symmetry reduction.** A group-invariant deletion is a union of vertex orbits;
orbit aggregation gives a weighted quotient cover instance. State quotient edges explicitly as the
vertex orbits meeting each obstruction. This is useful infrastructure for computation and for new
geometric evaluations, not an independently novel theorem.

### A.4 Symmetry premium

**Verdict: direct collision and definition repair required.** The ratio is the established
`τ_G(H)/τ(H)`, called the **cost of symmetry** in invariant-cover literature. Rename it “cost of
symmetry for the completion-obstruction clutter” and cite that work. The ratio is undefined when
`δ_x=0`; restrict it to blocked insertions or use the additive cost `δ_x^G-δ_x`. Novelty would be an
exact formula, extremal bound, or unbounded gap for a natural finite-geometric family.

### A.5 Fractional completion

**Verdict: standard fractional transversal LP.** `δ_x^*=τ^*` is a relabeling, and
`δ_x/δ_x^*` is the standard integrality gap. Ratios require `τ^*>0`. A sharp exact gap or an
unbounded family for geometric circuit clutters remains a credible new result.

### A.6 Local-to-global resilience spectrum

**Verdict: known data in new packaging.** For planar arcs this is the multiset of external-point
secant multiplicities; Davydov–Marcugini–Pambianco explicitly record counts `c_i` of off-arc points
on exactly `i` bisecants and connect them to MDS-code coset distributions. In coding language the
same data are closely related to syndrome/coset weight distributions and multiple coverings. The
name may be new, but ordinary conic/hyperoval spectra are not; for an odd conic both `(q-1)/2` and
`(q+1)/2` strata are classical. A previously uncomputed orbit-refined spectrum for a nonclassical
invariant family could be publishable.

### A.7 Reliability polynomials

**Verdict: standard coherent-system reliability.** Obstructions are minimal path sets for blockage
and blockers are minimal cut sets. With independent heterogeneous probabilities the object is a
multilinear reliability function; with equal probabilities it is a univariate polynomial;
correlation needs additional data. If each point survives independently with probability `p`, then
for `σ` disjoint secant pairs the blockage probability is `1-(1-p²)^σ`. State whether `p` denotes
survival or deletion to avoid complementing the formula accidentally. A new exact polynomial or
extremal comparison for a geometric family could still be novel.

### A.8 Heterogeneous-bound stability

**Verdict: split the elementary and structural claims.** A small sum of nonnegative deficits gives
the usual averaging/Markov conclusion that most deficits are small. That is not a stability theorem
in the modern structural sense. The plausible new result is a genuine inverse theorem showing
that near-saturation forces approximation by classified geometric families. No such theorem was
located, but none is presently proved either.

### A.9 Collision corrections

**Verdict: classical method, plausible paper-specific target.** Inclusion–exclusion, multiplicity,
and second moments are standard; directions, hyperfocused arcs, generalized hyperfocused arcs, and
multiple saturating sets already study many secants collapsing onto small support. The restricted
empty-Baer-line Frobenius charge fibers appear more specific. An exact redundancy identity is

```text
|image(charge)| = total charges - Σ_y (μ(y)-1)_+.
```

A raw second moment `Σ_y binom(μ(y),2)` does not automatically give the needed upper bound on the
forbidden image: collisions may concentrate in a large fiber. A maximum-fiber, concentration,
higher-moment, or extremal argument is needed. The two-term Bonferroni truncation has the wrong
direction for an upper bound on a union. Do not promise a “second-moment improvement” until this
directionality is repaired. There is also an independent invisible-center correction, detailed
below. A proved numerical improvement remains the strongest follow-up bet.

### A.10 Higher-degree Galois orbits

**Verdict: open and too vague for novelty adjudication.** Field reduction, linear sets,
Galois-conjugate carriers, rank-weight language, and Galois methods for arc completeness are
established. For degree greater than two,
a candidate orbit may already contain a forbidden dependent subset internally. Separate candidate
feasibility from old-new obstruction charging; stratify orbit size, carrier rank, and forbidden-flat
type before stating a general theorem.

### A.11 Directed/asymmetric code distance

**Verdict: standard directional Hamming/Z-channel quantity.** `|C\F|` is the one-to-zero component
of asymmetric Hamming discrepancy on incidence vectors. Present the facet interpretation as a
translation. A new channel, decoding theorem, or exact geometric code parameter would be required
for a separate contribution.

### A.12 Tensorization and composition

**Verdict: open/underspecified.** Direct sums should give elementary component formulas. Products,
concatenation, and field reduction depend on precise definitions, while series/parallel reliability
composition is classical. Replace “expected minima, sums, or convolutions” by explicit conjectures
only after each operation is defined. A direct-sum lemma alone is unlikely to be paper-strength.

### A.13 FPT and symmetry-reduced algorithms

**Verdict: generic claims are established.** Bounded-rank `d`-Hitting Set is a canonical FPT and
kernelization problem; symmetric ILP/orbitopal reduction is mature. Rank-two hitting set is Vertex
Cover, and for the fixed external point of a planar arc its secant edges are actually a matching,
so the optimum is trivial. A contribution needs a geometry-specific kernel, complexity dichotomy,
compact verified certificate theorem, or implementation result.

### A.14 Robust defining sets

**Verdict: close/direct prior art.** Defining sets and trades are classical, and robust/fault-
tolerant identifying, resolving, and forcing sets are established. Most importantly, Bean and
Cavenagh introduced `k`-strong defining sets for Latin squares in 2026, an extremely close deletion-
resistant hierarchy. Cite and specialize it rather than introducing the generic hierarchy as new.
Exact values or classifications for conics, NRCs, designs, or other facet families could still be
new.

### A.15 Multi-insertion and orbit insertion

**Verdict: useful checked API, low generic novelty.** Bundling a prescribed feasible target set into
the feasibility predicate and applying correction/hitting-set duality is routine; simultaneous code
extension is established. Say that singleton insertion is a checked specialization. Do not infer
“strict mathematical generalization” from that declaration alone. Higher Galois orbit applications
may become new only after their internal and mixed obstructions are classified.

## Exact repair to the collision program

The uniform `N-M` proof is valid because it subtracts an upper bound, but its prospective equality
and collision analysis missed a second source of savings.

Fix an empty fixed line `m`. For a candidate orbit `q={p,p^σ}⊂m`, define

```text
μ_m(q) = number of old secants through p,
F_m    = |{q : μ_m(q)>0}|,                 distinct forbidden support,
A_m    = Σ_q μ_m(q),                       visible charge mass,
B_m    = number of nonfixed secant orbits {l,l^σ}
         whose fixed center l∩l^σ lies on m.
```

No secant through `p` is conjugate to another secant through `p`, so `μ_m(q)` also counts the
nonfixed secant orbits covering `q`. An orbit centered on `m` meets `m` only at its fixed center and
destroys no nonfixed candidate. Every other nonfixed secant orbit charges exactly one candidate on
`m`. Therefore

```text
A_m = M-B_m,

legal(m)
  = N-F_m
  = N-M+B_m+Σ_q(μ_m(q)-1)_+.
```

There are thus two separate improvements over `N-M`:

1. `B_m`, the **invisible-orbit correction**;
2. `Σ_q(μ_m(q)-1)_+`, the genuine **collision redundancy**.

Any earlier wording that every nonfixed secant orbit charges a candidate on every empty fixed line
is false. Theorem F itself says “at most one” and remains sound. Equality in the first-order bound
requires both `B_m=0` and no candidate collisions, line by line.

The natural second moment is

```text
T_m = Σ_q binom(μ_m(q),2).
```

Globally, four arc points and their three pairings give the classical identity

```text
Σ_{x∉C} binom(σ(x,C),2) = 3 binom(k,4).
```

Only the part supported on nonfixed points whose mate line is empty contributes to `Σ_m T_m`.
Fixed points and nonfixed points on occupied fixed lines may absorb most of the global moment, so
this identity alone does not improve the extension threshold. For `s=5,k=8`, `N=10` and the
worst first-order profiles have `M=12,12,10`; forcing a survivor needs total correction
`B_m+Σ_q(μ_m(q)-1)_+` of at least `3,3,1`, respectively. Pigeonhole alone does not provide the
needed correction in the `M=12` cases.

### Post-audit proof outcome

The exact support/invisible/redundancy identities are now Lean-proved in
`FiniteGeom.BaerCompletion.CollisionProfile` and instantiated semantically in
`RelativeConicArcs.QuadraticCollision`. The cross-center incidence bound and a capped second-moment
partition close two order-five profiles in prose:

- `(f,e)=(0,4)`: `B≥48`, `R≥11`, hence at least five legal pairs;
- `(f,e)=(4,2)`: `B≥4`, hence at least four legal pairs.

The same argument does **not** close `(f,e)=(2,3)`. Ten of its fourteen occupied fixed lines have
one-point trace, invalidating the shortcut that gave every occupied nonfixed point a base secant.
A subsequent two-code normalized census reports minimum 32 legal pairs, but this remains evidence
only until Lean checks normalization, coverage, and the predicate. The exact statuses are recorded in
[`2026-07-13-c99-baer-collision-strengthening.md`](2026-07-13-c99-baer-collision-strengthening.md).

## Application-language corrections

- Database repair, diagnosis, MUS/MCS duality, code puncturing/lengthening, and coherent-system
  reliability are established application domains. Present them as consumers and translations,
  not newly discovered uses of hitting sets.
- Weighted vertices represent unequal deterministic costs. Whole-orbit selection represents group
  constraints. Neither represents arbitrary stochastic correlation without a joint law.
- Matroids are a weak singleton application: inserting one nonloop element into an independent set
  costs zero or one deletion. Multi-insertion reduces to standard contraction/rank formulas.
- Greedoids are not generally hereditary, so the master theorem does not cover them without a
  restricted hereditary subclass or a new formulation.
- “Arbitrary new obstructions are harmless” means only that an old lower-bound certificate remains
  valid. It does not preserve the exact distance or characterize successful deletion sets.
- “Strict generalization,” “new invariant,” and “stronger” should be reserved for demonstrated
  mathematical separation, not API inclusion or preservation of more information.

## Revised research ranking

The current A.16 ranking should be replaced by the following order.

1. **Lean-prove every order-five profile.** The `f=2` existence certificate is complete; formalize
   the center/moment geometry for `f=0,4`. Keep the external census/minimum separate.
2. **Structural inverse theorem for near-equivariant saturation.** Go beyond averaging and classify,
   or approximate, configurations whose empty-line capacities are nearly exhausted.
3. **Explicit finite-geometric cost-of-symmetry family.** Evaluate the established `τ_G/τ` ratio
   exactly or prove an unbounded gap for a natural arc, design, or code family.
4. **Exact geometric integrality-gap theorem.** Prove a sharp `τ/τ^*` result for a genuine geometric
   circuit clutter.
5. **New orbit-refined completion/secant spectrum.** Compute a distribution not already determined
   by known secant or coset-weight results for a nonclassical invariant family.

Blocker duality and orbit quotienting should be removed from the novelty ranking. They are standard
infrastructure. The generic reliability, asymmetric-distance, and algorithmic observations should
remain applications unless they yield a new family-specific theorem.

## Sources and collision map

### Completion, blockers, repair, and defining sets

- R. Reiter, “A Theory of Diagnosis from First Principles,” 1987:
  <https://doi.org/10.1016/0004-3702(87)90062-2>.
- J. Bailey and P. Stuckey, minimal unsatisfiable subsets via hitting-set dualization:
  <https://doi.org/10.1007/978-3-540-30557-6_14>.
- T. Eiter, G. Gottlob, and K. Makino, monotone dualization and hypergraph transversals:
  <https://doi.org/10.1137/S009753970240639X>.
- J. Edmonds and D. Fulkerson, “Bottleneck Extrema,” blocker theory:
  <https://doi.org/10.1016/S0021-9800(70)80083-7>.
- Conflict-hypergraph database repairs: <https://doi.org/10.1145/1031171.1031254> and
  <https://arxiv.org/abs/0809.1551>.
- Defining sets survey: <https://doi.org/10.1017/CBO9781107359970.006>.
- Bean and Cavenagh, `k`-strong defining sets, 2026: <https://arxiv.org/abs/2605.28027>.

### Symmetry, fractional covers, algorithms, and reliability

- Klyachko and Luneva, “Invariant systems of representatives, or the cost of symmetry”:
  <https://arxiv.org/abs/1908.03315>.
- “Invariant covers of multipartite hypergraphs,” including `τ_G/τ` and fractional comparisons:
  <https://arxiv.org/abs/2602.10849>.
- F. Margot, orbit exploitation in symmetric integer programming:
  <https://doi.org/10.1007/s10107-003-0394-6>.
- D. Fulkerson, weighted covering/anti-blocking polyhedra:
  <https://doi.org/10.1016/0095-8956(72)90032-9>.
- Bounded-rank hitting-set kernels: <https://arxiv.org/abs/1112.2310>.
- A. El-Neweihi, coherent-system reliability from minimal path/cut sets:
  <https://doi.org/10.1287/moor.5.4.553>.
- Reliability of simplicial complexes and matroids: <https://arxiv.org/abs/1809.10779>.

### Finite geometry and coding

- Lunelli–Sce's classical complete-arc lower-bound scale is surveyed in Ball–Lavrauw:
  <https://arxiv.org/abs/1908.10772>.
- T. Alderson, “Extending Arcs: An Elementary Proof,” for the delete-one-endpoint-per-secant
  extension maneuver: <https://doi.org/10.37236/1973>.
- B. Martin, classical point indices/secant counts for arcs:
  <https://doi.org/10.4153/CJM-1967-030-2>.
- Baker and Wantz, “An arc partition of the Hughes plane,” for an adjacent conjugate-pair addition
  maneuver: <https://msp.org/iig/2005/2-1/iig-v2-n1-p04-p.pdf>.
- Multiple saturating sets and secant multiplicity: <https://arxiv.org/abs/1505.01426>.
- Hyperfocused arcs and concentrated secants: <https://arxiv.org/abs/math/0601488>.
- Davydov–Marcugini–Pambianco, bisecant multiplicity distributions and MDS cosets:
  <https://arxiv.org/abs/2101.12722>.
- MDS coset weight distributions: <https://doi.org/10.3934/amc.2021042>.
- Arc/MDS extendability: <https://arxiv.org/abs/1609.05657>.
- Field reduction and linear sets: <https://arxiv.org/abs/1310.8522>.
- Saturating sets and hypergraph covers: <https://arxiv.org/abs/1701.01379>.
- Galois methods for arc completeness: <https://arxiv.org/abs/2007.00911> and
  <https://arxiv.org/abs/2302.10162>.
- General spread-row correction background, subspace partitions:
  <https://arxiv.org/abs/1104.2706>.
- Small complete-arc classification relevant to the `s=5`/`PG(2,25)` edge case:
  <https://doi.org/10.1002/jcd.20211>.
- Asymmetric/Z-channel coding: <https://arxiv.org/abs/2105.01427> and
  <https://www.mathnet.ru/eng/at11293>.
- Ng and Wild, “On k-Arcs Covering a Line,” *Ars Combinatoria* 58 (2001), is directly adjacent to
  the line-covering formulation of the saturation argument; the paper's restricted
  Baer/Frobenius orbit cover, not line covering as a paradigm, is the possible distinction:
  <https://combinatorialpress.com/article/ars/Volume%20058/volume-58-paper-27.pdf>.
- Historical involution-quotient/semibiplane context is summarized in Spiro, §6.4.2:
  <https://onlinelibrary.wiley.com/doi/full/10.1002/jcd.21925>.

## Residual novelty gates

Before submission, the paper still needs:

1. primary citations and exact hypotheses for every surviving Theorem D row;
2. a database-level priority search for the exact quadratic-Frobenius orbit-extension formula,
   including non-English and older finite-geometry literature;
3. an explicit example separating conjugate-pair saturation from ordinary completeness, if
   Corollary G is to carry conceptual weight;
4. kernel-check the center-incidence and `f=0,4` moment partitions before claiming a formal uniform
   threshold; certify the normalized `f=2` census only if the stronger count/minimum is claimed;
5. a clean discovery ledger that labels classical formalized infrastructure separately from
   genuinely new mathematical consequences.

Residual uncertainty is concentrated in Theorem F and its exact eight-arc corollary. Older
monographs, conference proceedings, non-digitized literature, and the full invariant-arc
classification landscape were not exhausted. The review therefore assigns “plausibly unrecorded,”
not “certified novel.”

## Final adversarial assessment

No generic Appendix A construction currently survives as a new standalone mathematical idea.
Several are excellent interfaces for future work, but the literature already owns the underlying
blocker, weighted-cover, symmetry, fractional, reliability, defining-set, asymmetric-code, and FPT
concepts. The paper is strongest when it is specific: quadratic Frobenius, empty Baer carriers,
nonfixed secant-orbit charging, and a semantically legal conjugate-pair extension. A concrete new
collision, inverse, gap, or spectrum theorem in that geometry would materially upgrade it; absent
one, the honest pitch is a formally verified structural criterion plus unification.
