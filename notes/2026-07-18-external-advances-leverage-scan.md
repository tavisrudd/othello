# External advances leverage scan — 2026-07-18

Scope: external work 2020–2026 (weighted 2023+) that increases the value of theorems and structures
we already own, across five targets: arcs (A), clebsch (B), complete-ports (C), the C210/relconic
follow-ons (D), and the crowns C332–C335 portfolio (E), plus the cross-paper orbit-valued transfer
agenda. Method: six field-fanned literature subagents (finite geometry; MDS/deep holes; distributed
storage/repair; function fields/effective Chebotarev; reflection arrangements + reconstruction;
Lean/Mathlib + matroid/Tutte), each verifying citations against fetched arXiv/DOI records. The four
citations anchoring the top-ranked entries (arXiv:2303.13670, arXiv:2401.04912, arXiv:2605.12133,
arXiv:2504.17244) were independently re-verified against their arXiv abstract pages during
synthesis. Items a subagent could locate but not verify are marked as such. Raw per-field findings
sit in the session scratchpad (`sub-*.md`, ephemeral); everything load-bearing is restated here.

Ranked by leverage-per-unit-effort, best first.

---

## Ranked leverage opportunities

### 1. D-lane: reframe the paper as a sharpness/limitation theorem for the Micheli-school complete-arc programme

- **Attaches to**: C329 (collision-free four-layer arcs for odd-tower Q >= 2^45), C330
  (line-at-infinity non-completeness obstruction), the Artin–Schreier machinery, C327
  (S5 x S5 joint monodromy) — i.e. the whole "what is this paper about" question.
- **External advance**: L. Bastioni, G. Micheli, *On complete m-arcs*, arXiv:2303.13670 (2023;
  J. Algebra 638 (2024) 238–254, journal DOI not captured — arXiv record re-verified directly), and
  D. Bartoli, G. Micheli, *Algebraic constructions of complete m-arcs*, Combinatorica 42 (2022)
  673–700, DOI 10.1007/s00493-021-4712-5 (arXiv:2007.00911). Bastioni–Micheli prove that over a
  large finite base field **any curve satisfying explicit generic geometric conditions yields a
  complete m-arc**, and instantiate this on hyperelliptic and **Artin–Schreier** curves. The
  machinery is exactly ours: Galois-theoretic transfer of external-point geometry to an arithmetic
  splitting condition, discharged by a Chebotarev-type count for q large. Supporting live thread:
  Bartoli–Timpanella, complete (q+1)-arcs from the Hermitian curve, arXiv:2306.01134,
  J. Algebraic Combin. 2025, DOI 10.1007/s10801-025-01456-w.
- **Type**: hook (the strongest in this scan).
- **Specific gain**: the D material stops being an orphaned mechanism theory and becomes an argument
  *with* a named, active, three-papers-in-four-years thread: we run the same construction machinery
  on an explicit char-2 family and then prove by an exact direction count that the arcs are **not**
  complete — a sharpness/limitation theorem for their generic conditions, publishable in the venues
  that published them (Combinatorica, J. Algebra, J. Algebraic Combin.). Named consumers: Micheli,
  Bastioni, Bartoli, Timpanella. Every owned result stays load-bearing: the AS machinery is the
  curve, C312–C317 the atlas, C327/C329 the construction, C330 the punchline, C210 the bounded
  obstruction. Secondary framing for the middle sections: explicit joint S5 x S5 monodromy on a
  codimension-three trace-compatible slice where genericity results do not apply — ambient context
  Entin–Popov, FFA 2024, DOI 10.1016/j.ffa.2024.102466 (arXiv:2311.14862) and Entin, JLMS 2025,
  DOI 10.1112/jlms.70061 (arXiv:2403.11943), who prove full S_n monodromy is *generic* for random
  families over F_q(t).
- **Cost and risk**: one careful read of Bastioni–Micheli plus a condition-by-condition comparison
  against our family. The risk is the flip side of the gain and is real: if our family *satisfies*
  their generic conditions, C329 may be a special case of their theorem, or C330 contradicts it and
  one of the two is wrong. This check is mandatory before drafting (see superseded-risk section).
- **Confidence**: high. Abstract re-verified; the Artin–Schreier + complete-m-arcs + large-q triple
  is stated in their abstract verbatim.

### 2. C: enter distributed storage through I/O cost, and answer the live trace-repair thread with the port census

- **Attaches to**: complete bounded repair-port object, parts (i) support layer and (ii) exact
  pointed weighted-functional transfer; the scope caution directly.
- **External advance**: Z. Liu, Z. Zhang, *A Formula for the I/O Cost of Linear Repair Schemes and
  Application to Reed-Solomon Codes*, arXiv:2401.04912 (2024; re-verified). Derives a general
  formula for the I/O cost — data *accessed* at helpers, as distinct from transmitted — of a linear
  repair scheme, reduced to the Hamming weight of an associated linear space; applies it to RS codes
  for lower bounds and improved schemes. Companion live thread: W. Kim, S. Kruglik, H. M. Kiah,
  *Trace Repair Never Loses to Classical Repair: Exact and Explicit Helper Nodes Selection*,
  arXiv:2509.06492 (2025) — computes exact dimensions of trace-repair subspaces under excluded
  helper sets and optimizes helper selection, i.e. a *partial* port census done point-by-point by
  optimization. Venue-matched neighbor: Haymaker–Malmskog–Matthews, hierarchical LRC with nested
  affine recovery, Designs, Codes and Cryptography 2024, DOI 10.1007/s10623-024-01510-x
  (arXiv:2310.20533).
- **Type**: tool (Liu–Zhang) + hook (Kim–Kruglik–Kiah).
- **Specific gain**: this fixes the manuscript's stated strategic weakness. One-symbol-per-helper is
  *not* competitive on bandwidth-under-subpacketization, but it is the extremal regime for
  **access/I/O cost** — the storage community's own established metric, formalized by Liu–Zhang as
  a support-layer weight computation, which is layer (i) of our object almost verbatim. The
  manuscript can enter the distributed-storage conversation with zero subpacketization exposure:
  state it as a complete characterization of admissible scalar access patterns. Against
  Kim–Kruglik–Kiah, the complete census answers in closed form what they compute by optimization
  over a parameterized family — their excluded-set-vs-dimension trade-off is a pointed structure
  mapping directly onto part (ii). The DCC 2024 neighbor confirms the stated venue fit and supplies
  the right reviewer pool.
- **Cost and risk**: moderate — re-express part (ii)'s functional in the linear-space-weight
  language and check conventions (their bounds are for two and three parities; do not generalize
  them). Residual risk is the inverse overclaim: we have completeness of the port census, not I/O
  *optimality*; say the former only. Do not cite the 2026 subpacketization-reduction preprints
  (e.g. arXiv:2601.10685) except to delimit what we do not claim.
- **Confidence**: high. Both anchor abstracts fetched; the metric alignment is structural.

### 3. A: position the q=11 flagship inside the 2023–2026 deep-holes thread — "the deep holes form a conic" is unoccupied ground

- **Attaches to**: the non-GRS [6,3,4]_11 MDS code whose distance-three affine syndrome rays are
  exactly a conic (deep holes = conic); the arc/MDS syndrome dictionary.
- **External advance**: Y. Wu, C. Ding, T. Chen, *Extended codes and deep holes of MDS codes*,
  arXiv:2312.05534 (2023): the extended code of an MDS [n,k] code is MDS **iff** the extending
  vector is a deep hole of the dual with dual covering radius k — deep holes are now the exact
  input to MDS extension, giving the notion a construction consumer. Y. Li, Z. Lu, S. Ling,
  K.-Y. Lam, *A framework for constructing non-GRS MDS-NMDS codes from deep holes and its
  application*, arXiv:2605.12133 (May 2026; re-verified): a framework paper that consumes deep-hole
  data to build non-GRS MDS-NMDS families, landing on Roth–Lempel codes. Corroborating hook: deep
  holes of generalized Roth–Lempel codes, Designs, Codes and Cryptography 93 (2025),
  DOI 10.1007/s10623-025-01709-6 (authors unverified — Springer auth wall); and Gu–Wang–Zhang,
  deep holes of twisted RS codes characterized by *syndrome-vector* conditions, arXiv:2509.08526
  (2025) — our dictionary's framing appearing independently.
- **Type**: hook.
- **Specific gain**: our flagship's three properties — non-GRS, MDS, deep holes known exactly and
  geometrically — are precisely the three governing keywords of a framework paper published two
  months ago that wants inputs. Under Wu–Ding–Chen, the conic becomes an exact description of which
  one-symbol extensions of our code stay MDS, a statement in their language at paragraph cost via
  the syndrome dictionary. A targeted search found **no published geometric (conic/quadric)
  description of a deep-hole set** — the exactness claim is unoccupied. Mandatory boundary: Kaipa
  (arXiv:1612.05447, IEEE T-IT 2017) fully classified deep holes of **redundancy-three RS codes**;
  our code is redundancy three, so the novelty rests entirely on being non-GRS and must say so
  explicitly, or the reader reaches for Kaipa first.
- **Cost and risk**: low for the positioning (a paragraph plus dual-pairing bookkeeping for the
  extension corollary). Medium for feeding the 2026 framework: its input hypotheses are not fully
  visible from the abstract and our code may sit outside them; the thread moves fast, so priority
  pressure is real. One open verification blocker: check that the 2025 DCC Roth–Lempel paper's
  covering-radius determination does not subsume our small-codimension case.
- **Confidence**: high for the thread and the fit; medium that the framework accepts our object.

### 4. B: turn the C211 Clebsch-secants/H3-mirrors projectivity into an instance of good reduction

- **Attaches to**: C211 (exact F_11 projectivity between the 45 Clebsch secants and the
  projectivized H3 mirrors; q=5 joins are A3), and the A5 point-orbit decomposition.
- **External advance**: E. Palezzato, M. Torielli, *Combinatorially equivalent hyperplane
  arrangements*, arXiv:1906.05463 (rev. 2021; Adv. Appl. Math.): a minimal-strong-Gröbner-basis
  criterion deciding exactly when an arrangement and its reduction mod p have isomorphic
  intersection lattices. Group side: B. Monson, E. Schulte, *Reflection groups and polytopes over
  finite fields* I–III (Adv. Appl. Math. 2004; arXiv:math/0601502; arXiv:0707.4007): mod-p
  reduction of Coxeter reflection representations yields finite orthogonal reflection groups, and
  every finite irreducible orthogonal reflection group over F_p is a twisted form of such a
  reduction. Companion caution: Palezzato–Torielli, *Free hyperplane arrangements over arbitrary
  fields*, J. Algebraic Combin. 2020, DOI 10.1007/s10801-019-00901-x — lattice good reduction and
  freeness good reduction are different questions.
- **Type**: tool.
- **Specific gain**: run the Gröbner criterion on the H3 mirror ideal over Z[phi] at a prime above
  11: if it certifies L(H3) ~ L(H3 mod 11), the C211 correspondence is a *consequence* of good
  reduction, complement formulas and decoder strata are inherited rather than coincidental, and the
  q=5 collapse is a *bad prime*, not an anomaly. The arithmetic explanation is available and
  apparently unstated anywhere as a criterion: H3 lives over Z[phi], so the reduction is
  F_p-rational iff 5 is a square mod p, i.e. p ≡ ±1 (mod 5) — true at 11, ramified at 5. This
  simultaneously explains why 11 works and why q=5 degenerates, and it directly steers C333's
  all-odd-field mirror locus (predicting the split of the locus by p mod 5) before that task
  starts. No located paper does both the lattice side and the group side for a non-crystallographic
  group — the general theorem does not exist, so C211 plus this synthesis *is* the instance-maker.
- **Cost and risk**: low-to-moderate — the criterion is computational (Singular/Macaulay2) and the
  mirror ideal is small, but the paper is stated over Q/Z and the Z[phi] extension is ours to
  spell out. The criterion gives the lattice statement, not the A5-in-PGL(3,11) group statement;
  Monson–Schulte covers the group side but concentrates on crystallographic string groups, so the
  H3 adaptation is real work. The p ≡ ±1 (mod 5) observation is elementary enough that a referee
  may call it folklore; present it as explanation, not novelty.
- **Confidence**: high that the tools exist as stated (both anchor records verified); the two-sided
  synthesis is our work.

### 5. E-C334: the growing-carrier tradeoff exists — service rate regions of MDS codes

- **Attaches to**: C334 (application-first MDS + multi-target repair interface; gate = "must
  demonstrably improve a growing-carrier operational tradeoff").
- **External advance**: H. Ly, E. Soljanin, *Service Rate Regions of MDS Codes & Fractional
  Matchings in Quasi-uniform Hypergraphs*, arXiv:2504.17244 (2025; re-verified). The service rate
  region (SRR) is a polytope measuring a coded system's ability to serve multiple objects
  concurrently; the paper characterizes axis intercepts and enclosing simplices for a class of MDS
  codes, proves **the SRR grows with the number of systematic columns** in the generator matrix,
  and shows the SRR polytope is an image of a fractional-matching polytope of a quasi-uniform
  hypergraph. Same group's live reliability thread: Ly–Soljanin–Whiting, majority-logic decoding of
  binary LRCs, probabilistic analysis, arXiv:2601.08765 (2026) — the closest active analogue of
  the C-object's part (iv), since bounded-EXIT for algebraic codes is otherwise dormant.
- **Type**: hook.
- **Specific gain**: C334's gate stops being arbitrary. The SRR is an established, MDS-specific,
  multi-target-by-construction operational tradeoff with an explicitly proven growing-carrier
  monotonicity, and its machinery (fractional matchings on hypergraphs) is the same object category
  as a repair hypergraph, so the bridge is technical, not thematic. The falsifiable target: an
  MDS + multi-target repair interface improves the tradeoff if it enlarges the achievable region or
  attains it with fewer systematic columns.
- **Cost and risk**: moderate-to-high — adopting SRR commits C334 to a service model rather than a
  repair-bandwidth model, and the deliverable becomes an SRR statement. Scope drift between
  service and repair is the failure mode; a paper claiming both without a proved bridge gets
  rejected on the weaker half. No subpacketization exposure.
- **Confidence**: high — the monotone-growth claim is stated in the abstract verbatim.

### 6. E-C295: a decision procedure — check line-graph reconstruction first, then the WL-dimension route

- **Attaches to**: C295 (recover matching/port decomposition from an uncoloured continuation
  object).
- **External advance**: G. Chen, Q. Ren, I. Ponomarenko, *On the Weisfeiler algorithm of depth-1
  stabilization*, arXiv:2311.09940 (2023): proves that if two non-isomorphic projective planes of
  order q exist, the WL dimension of any order-q plane's incidence graph is at least 4 — the exact
  template for converting reconstruction (non-)uniqueness of incidence structures into WL-dimension
  statements about a derived graph, usable in both directions. Pre-check tools:
  hypergraph-from-line-graph reconstruction under bounded pair-degree, arXiv:2104.14863 (2021), and
  design reconstruction from line graphs, arXiv:1006.5892 (2010, attribution to Babai–Wilmes
  unverified). Supporting: Schneider–Schweitzer, arXiv:2403.12581 (2024), whose fibre-recovery
  lemmas match C295's "recover a removed fibre" shape; Fon-Der-Flaass SRG family with WL dimension
  4, arXiv:2312.00460, Combinatorica 2025, DOI 10.1007/s00493-025-00145-3, precedent that a huge
  family can be identifiable at small fixed dimension.
- **Type**: tool.
- **Specific gain**: C295 acquires a cheap decision procedure before any real work: (1) determine
  whether the continuation graph is a line graph or a design's block graph — if yes, C295 may be
  largely a citation to existing reconstruction theorems rather than a research problem; (2) if
  not, aim at a bounded claim ("k-WL with explicit refinement recovers the port classes"), which is
  a statement the reconstruction community already knows how to evaluate. Either outcome — theorem
  or bounded negative — is a deliverable in an active 2023–2025 thread (a 2024–2025
  hypergraph-reconstruction-from-projection cluster exists on the probabilistic side:
  arXiv:2401.08520, arXiv:2502.08840, arXiv:2502.14988).
- **Cost and risk**: the pre-check is nearly free; k-WL implementation costs n^k; the WL route may
  return a lower bound (hardness) instead of reconstructability — still a bounded negative worth
  having. Computing exact WL dimension is itself hard (arXiv:2402.11531), so claim bounded
  dimension, never exact.
- **Confidence**: medium — the template paper is verified and on-point; whether our derived graph
  falls in the good classes is unknown until the pre-check runs.

### 7. D: attack the 2^41/2^45 thresholds through the cover, not the density theorem

- **Attaches to**: C327 (Q >= 2^41), C329 (Q >= 2^45).
- **External advance**: G. Korchmáros, G. P. Nagy, T. Szőnyi, *Algebraic approach to the
  completeness problem for (k,n)-arcs in planes over finite fields*, arXiv:2302.10162 (2023):
  decides completeness of curve-derived point sets via Galois theory plus the **Hasse–Weil lower
  bound**, and for the rational BKS curve proves completeness iff r is even, explicitly locating
  the uncovered points (in a subplane) in the odd case. Negative anchor: Kosters,
  arXiv:1404.6345 (in litcache) is error-term-free, and no 2020–2026 improvement of effective
  Chebotarev over function fields exists (recent explicit-Chebotarev work — arXiv:2508.09480,
  arXiv:2412.01802 — is all number fields).
- **Type**: tool.
- **Specific gain**: since the density theorem carries no error term, our thresholds come from the
  Weil count against the pulled-back genus (<= 1,838,101 on a degree-64 cover). The only real
  lever is structural — reduce the cover degree or find a lower-genus model — and the
  Korchmáros–Nagy–Szőnyi Hasse–Weil formulation is the candidate machinery: their thresholds are
  polynomial in the cover degree rather than Chebotarev-constant-driven. Plausible outcome: 2^45
  drops by orders of magnitude, possibly into computationally checkable range. Quantitative
  off-the-shelf alternative for the specialization step: Bary-Soroker–Entin explicit Hilbert
  irreducibility, arXiv:1912.05162 (2019).
- **Cost and risk**: medium-to-high — requires re-deriving the cover so that absolute
  irreducibility over the base is explicit and Hasse–Weil applies directly; their setting is
  (k,n)-arcs with n >= 3, and the n=2 rigidity may block transfer; the threshold may be dominated
  by a step other than the point count. Present as a lever, not a promise.
- **Confidence**: medium.

### 8. A: import the coset-leader-enumerator-as-finite-geometry template to extend the dictionary to a family in q

- **Attaches to**: the arc/MDS syndrome dictionary and the defect identity's coset-leader
  restatement.
- **External advance**: A. Blokhuis, R. Pellikaan, T. Szőnyi, *The extended coset leader weight
  enumerator of a twisted cubic code*, arXiv:2103.16904 (2021): computes the extended coset leader
  weight enumerator of the [q+1, q-3, 5]_q GRS code by classifying point/line configurations in
  PG(3,q) relative to the twisted cubic, via the double-point scheme of a rational function and a
  Hasse–Weil argument.
- **Type**: tool.
- **Specific gain**: the closest published methodological sibling of the dictionary — they do the
  codimension-four twisted-cubic case in PG(3,q); we hold the codimension-three conic case in
  PG(2,q). Two imports: the double-point-scheme device is the right machine for turning the
  leader-collision identity into a curve statement, and their Hasse–Weil step is the technique for
  extending our bounded-q results to a family in q — the gate the dictionary currently cannot
  close. Citing them also places the work inside a named programme. That the conic case has not
  been done in this style is itself informative: the slot is open.
- **Cost and risk**: medium — the double-point machinery must be genuinely learned, and their
  genus-one argument is delicate. Scoop risk low (2021 paper, slot still open).
- **Confidence**: high — structural, not thematic, match.

### 9. C: settle the pointed-Tutte lineage before the manuscript hardens — and gain a second consumer community

- **Attaches to**: complete-ports part (v) (pointed Tutte / perspective structure) and part (ii).
- **External advance**: the reference chain. E. Gioan, *The Tutte polynomial of matroid
  perspectives*, ch. 28 of the Handbook of the Tutte Polynomial, CRC 2022, handbook DOI
  10.1201/978-0-429-16161-2 (open HAL deposit lirmm-03868715) — the current normalization and
  terminology anchor; his perspective-activity expansions are cached (arXiv:1807.06559, Discrete
  Math. 2022). Wagner, *Ported Tutte Functions of Extensors and Oriented Matroids*,
  arXiv:math/0605707 — Tutte functions defined by suspending deletion-contraction on a
  distinguished set literally called **ports**. Las Vergnas, morphism-of-matroids series
  (DOI 10.5802/aif.1702, cached; part I is titled "Set-pointed matroids and matroid perspectives").
  Consumer community: matroid ports in secret sharing — Bamiloshin–Ben-Efraim–Farràs–Padró,
  Designs, Codes and Cryptography 2021, DOI 10.1007/s10623-020-00811-1 (cached as
  arXiv:2002.08108), plus q-polymatroid ports, arXiv:2504.18294 (2025).
- **Type**: tool + mapping, with a mandatory superseded-check attached.
- **Specific gain**: three distinct established meanings of "port"/"pointed" exist (Wagner/Chaiken
  ported Tutte functions; Las Vergnas set-pointed matroids/perspectives; Padró-school matroid
  ports in secret sharing). Stating part (v) in Gioan's normalization makes it legible to the
  community that would consume it; if the Padró-school port object aligns with ours, the same
  structure theorem gains a second, funded consumer community (share-size bounds). Related active
  line for part (vi): harmonic Tutte polynomials with Greene-type identities,
  arXiv:2110.06472 / DCC 2023 DOI 10.1007/s10623-023-01196-7 and sequels — but verify first
  whether part (vi)'s "harmonic" is the Delsarte/Bachoc sense or the geometric
  harmonic-conic/nucleus sense; if the latter, that entry is a terminology coincidence.
- **Cost and risk**: low — definition checks against papers largely on disk. The risk *is* the
  finding: if Wagner's ported Tutte functions or Las Vergnas's set-pointed matroids coincide with
  our part (v) object, the framework is not new and the contribution narrows to the structure
  theorem itself. Far better found now than in review.
- **Confidence**: high that this check is necessary and the citations are real; unresolved which
  way it lands.

### 10. E-C335: a literature-backed metric exists — graph-constrained repair — but no Cayley precedent

- **Attaches to**: C335 (Cayley/Schreier network audit; stated blocker = pick a literature-backed
  operational metric).
- **External advance**: A. Patra, A. Barg, *Generalized regenerating codes and node repair on
  graphs*, IEEE Trans. Inf. Theory 71(3) (2025) 1613–1630, DOI 10.1109/TIT.2025.3532625
  (arXiv:2405.11714): repair on a topology-constrained network where cost is weighted by graphical
  distance from helper to failed node; lower bounds, achieving constructions, adversarial
  extension. Predecessors arXiv:2108.00939, arXiv:2211.00797.
- **Type**: mapping.
- **Specific gain**: C335 becomes well-posed: for a Cayley/Schreier graph of a given group and
  generating set, compute distance-weighted repair cost and compare against published bounds —
  a deliverable measured against IEEE-TIT baselines instead of a self-defined score. No paper
  applies graph-constrained repair to Cayley/Schreier graphs; the gap is the opportunity.
- **Cost and risk**: high — C335 stays high-risk. The gap may be empty for a reason:
  vertex-transitivity may make the distance-weighted problem degenerate. Check that analytically
  on one small Cayley graph before generating any data. Regenerating codes are inherently
  vectorized, so a scalar-base paper must compare only against scalar specializations — this is
  the entry where accidental subpacketization overclaim is easiest.
- **Confidence**: medium — metric verified and citable; Cayley fit untested.

### 11. B: the stabiliser-orbit equivalence method is being used to settle NMDS classification now

- **Attaches to**: Clebsch rigidity (conic containment characterizes the class, recovers A5;
  252 perturbations in eight A5 orbits).
- **External advance**: J. Lu, Y. Zhou, *On the equivalence of NMDS codes*, arXiv:2509.25645
  (2025): exhibits NMDS codes with identical weight distributions that are not monomially
  equivalent, and fully determines equivalence classes by the action of hyperoval homography
  stabilisers on the complement — take an arc, take its stabiliser, act on the complement to
  separate classes.
- **Type**: tool.
- **Specific gain**: the exact move B's orbit census makes, used in a 2025 IT paper to *completely*
  settle an equivalence question. Their write-up shows what a complete orbit-to-equivalence
  argument needs — the template for upgrading the 252-perturbation census from table to
  classification. Their weight-distribution-does-not-determine-equivalence example is also the
  cleanest available argument for why our conic-containment invariant (strictly stronger than a
  weight distribution) is needed. Positioning note: the non-GRS MDS construction thread is crowded
  (multiple 2025–2026 entrants); characterisations are scarce there — position B as a
  characterisation or it reads as one more construction.
- **Cost and risk**: low — port the argument shape. Their hyperovals are even-q; our six-arc is
  q=11, so transfer is by method, not theorem.
- **Confidence**: medium-high on the gain; the paper itself is verified.

### 12. B-orbit + Agenda: restate the orbit census as a coherent configuration and ask for separability

- **Attaches to**: the A5 orbit decomposition [6,10,12,15,30,30,30] with ambiguity census, and
  Agenda Q4 (replace case censuses by invariant structure).
- **External advance**: the schurity/separability programme for coherent configurations —
  Chen–Ponomarenko, *Lectures on Coherent Configurations* (updated June 2024, lecture notes, no
  DOI); in-window items arXiv:2005.13887 (2020), arXiv:2605.07672 (2026) (located, not fetched).
  Separability = the configuration is determined by its intersection numbers; one known route
  derives schurity+separability from "enough Desarguesian configurations" — a local hypothesis
  forcing global rigidity.
- **Type**: mapping.
- **Specific gain**: separability is literally Agenda Q4's target property — local numerical data
  forcing the global object, replacing a census. Our orbit partition is schurian by construction;
  asking whether it is *separable* converts the ambiguity census into a standard named question
  with existing technology, and is the closest existing anchor for the orbit-valued transfer
  statement (no transfer tool exists — see negatives).
- **Cost and risk**: moderate — the formalism has a learning curve; separability is often hard to
  decide, and the Desargues-type theorems are stated for two-valenced schemes, which ours likely
  is not.
- **Confidence**: medium.

### 13. Lean assets: proof-carrying covering-code certificates and PB proof import are live threads our census work feeds

- **Attaches to**: the rho_C(16)=9 kernel-checked census, the Clebsch Lean roots, gate
  architecture.
- **External advance**: A. Florath, *Formal Foundations and Proof-Carrying Certificates for q-ary
  Covering Codes in Lean 4*, arXiv:2606.09600 (June 2026), and *A Lean-Certified Proof of
  K_8(4,2)=23*, arXiv:2606.16688 (June 2026) — certificate predicates over finite
  coding-theoretic domains, with the hard residual discharged as stored CNF plus **LRAT
  refutations replayed inside Lean**, no external solver at replay. S. Szeider, *PBLean:
  Pseudo-Boolean Proof Certificates for Lean 4*, arXiv:2602.08692 (2026) — proved-sound reflective
  checker, redundance-based symmetry breaking, verified encodings, ~63k-line proofs checked in
  minutes. Matroid side: the Seymour formalization project, arXiv:2509.20539 (2025, 11 authors
  incl. Peter Nelson; github.com/Ivan-Sergeyev/seymour) is where Lean representable-matroid
  machinery actually lives — Mathlib has only maps/duals/minors.
- **Type**: hook (Florath, Seymour) + tool (PBLean, LRAT-in-Lean).
- **Specific gain**: Florath's architecture is our census's architecture in a Hamming setting —
  the certificate-predicate vocabulary is a ready mapping target, and he needs exactly what we
  have (large kernel-checked covering leaves); supplying the finite-geometry instance would attach
  our libraries to a nascent shared framework. PBLean's verified encodings plus symmetry breaking
  (our census is A5/orbit-structured) is the credible route off `native_decide` for
  enumeration-heavy leaves.
- **Cost and risk**: Florath is single-author and two months old — no adoption signal; aligning to
  a framework that dies is wasted effort. CNF/PB routes leak at encoding-correctness (PBLean's
  verified encodings address exactly that); LRAT artifacts are large, colliding with the
  no-multi-GB-evidence rule.
- **Confidence**: medium — all records verified; community durability unproven.

### 14. A: the evaluation-avoidance dichotomy has a candidate external consumer in curve-union blocking sets

- **Attaches to**: the evaluation-avoidance dichotomy (Appendix B) with its rank-sensitive lower
  bound.
- **External advance**: S. Asgarli, D. Ghioca, C. H. Yip, *Blocking sets from a union of plane
  curves*, arXiv:2510.15332 (2025): constructs blocking sets in P^2(F_q) as unions of irreducible
  degree-d curves and proves lower bounds on the number of degree-d curves needed, motivated by an
  Erdős question.
- **Type**: hook.
- **Specific gain**: their recurring primitive is "a degree-d curve covering this while missing
  that" — exactly the dichotomy's existence criterion, with our rank-sensitive bound supplying the
  lower-bound-on-number-of-curves flavour they prove by other means. Best candidate found for the
  dichotomy having an outside consumer instead of being an internal lemma.
- **Cost and risk**: medium — check that the |A| <= q hypothesis and Veronese-span formulation
  survive their setting; their bounds may subsume ours in the cases they care about.
- **Confidence**: medium.

### 15. A: recast simultaneous extension as a local-arc / arc-compatibility statement with an LRC consumer

- **Attaches to**: simultaneous extension = independent sets of a conflict hypergraph; the q=11
  independence polynomial 1 + 12t + 36t^2 + 20t^3.
- **External advance**: F. Ihringer, Y. Zhou, *On the construction of large local arcs*,
  arXiv:2602.23692 (Feb 2026): collections of disjoint point sets pairwise unioning to arcs,
  superlinear constructions, with an application to optimal LRCs with disjoint repair groups.
  Adjacent: Alderson, unique arc extension generalizing Barlotti, arXiv:2511.06193 (2025) — the
  uniqueness counterpart to our exact non-uniqueness counts.
- **Type**: mapping.
- **Specific gain**: recast in compatibility-graph language, the conflict hypergraph lands in a
  live 2026 thread with a coding consumer, where our exact independence polynomial is small-case
  ground truth constraining constructions.
- **Cost and risk**: medium — check whether our conflicts are genuinely pairwise; if 3-wise, the
  mapping degrades. Alderson's parameter range may exclude the planar q=11 case entirely.
- **Confidence**: medium.

### 16. A/B: the cheapest strategic test — read the 2025 Hirschfeld–Thas survey's open problems

- **Attaches to**: rho_C(16)=9, the asymptotic bound, the small-arc classification — everything
  whose value depends on whether anyone is asking.
- **External advance**: J. W. P. Hirschfeld, J. A. Thas, *Arcs, Caps and Generalisations in a
  Finite Projective Space*, Mathematics 13 (2025) 1489, DOI 10.3390/math13091489
  (arXiv:2503.06243) — the field's two canonical authorities, April 2025, with open problems.
- **Type**: hook (test).
- **Specific gain**: the prescribed-conic framing currently has no identified external consumer
  (see negatives). One survey read is the cheapest available decision input on how hard to push
  that framing, and the natural citation anchor for positioning the Kim–Vu scale.
- **Cost and risk**: one PDF read; the risk is only that it does not mention relative
  completeness — which is itself the answer.
- **Confidence**: high that the test is worth running.

---

## Nothing found

- **C332** (all-extension subfield decomposition): no external thread located that pulls for this
  object specifically. No steer either way from this scan.
- **Agenda orbit-valued transfer tool**: searched independently by three subagents (coding,
  storage, reconstruction). No technique exists in the window for transporting complete incidence
  or repair patterns with automorphism-orbit labels through concatenation or lifting. The nearest
  machinery (disjoint-repair-group lifting, arXiv:1905.02270) is 2019 and partial. The statement
  is genuinely ours to prove — no competitor, no shortcut.
- **PIR / secret sharing needing deep-hole or covering-radius structure**: nothing located where
  that data is the operative input. Unproductive direction.
- **Quantum codes directly from arcs/conics**: no thread; that literature is constacyclic and
  AG-code dominated. Only indirect route: Roth–Lempel/NMDS Hermitian self-orthogonality
  (arXiv:2604.11350, 2026), blocked at q=11 by the q-square requirement.

---

## The three highest-value moves

1. **Read Bastioni–Micheli (arXiv:2303.13670) and Bartoli–Micheli (DOI 10.1007/s00493-021-4712-5)
   in full, run the condition-by-condition check of their generic hypotheses against the C329
   family, and then adopt the sharpness framing.** This single read both resolves the scan's most
   urgent superseded-risk (entry 1's risk paragraph) and hands the D lane its external identity:
   a limitation theorem for a live, named, three-paper programme, with the C327 monodromy as the
   technical core against the Entin-school genericity backdrop. Everything else in the D lane
   waits on this.
2. **Reposition complete-ports on the access/I/O axis (Liu–Zhang, arXiv:2401.04912) against the
   live trace-repair thread (arXiv:2509.06492), and settle part (v)'s terminology against
   Wagner/Las Vergnas/Gioan in the same pass.** One rewrite of the framing sections converts the
   manuscript's biggest stated weakness (not-TIT, subpacketization caution) into a defensible
   entry point with zero subpacketization exposure, and the port/pointed lineage check closes the
   sharpest Tutte-side novelty risk while the manuscript is still soft.
3. **Write the deep-holes-form-a-conic positioning into the arcs manuscript now**: state the
   flagship as the exact geometric deep-hole description the 2023–2026 thread lacks
   (Wu–Ding–Chen extension criterion; Li–Lu–Ling–Lam framework as the consumer), with the Kaipa
   redundancy-three boundary stated in the same paragraph. Paragraph-level cost via the existing
   syndrome dictionary; the ground is verified unoccupied and the thread is moving fast enough
   that sitting on it has real priority cost.

Near-miss fourth: the C211 good-reduction computation (entry 4) — a small Gröbner computation
with a disproportionate payoff (coincidence becomes instance, q=5 becomes a bad prime, and C333
gets steered before it starts).

---

## Findings that suggest a framing of ours is wrong or superseded

Stated plainly, most serious first.

1. **C329/C330 vs Bastioni–Micheli — possible direct collision.** They already derive complete
   m-arcs from Artin–Schreier curves over large fields under explicit generic conditions. Until
   those conditions are checked against our family, it is open whether C329 is a special case of
   their theorem, and whether C330's obstruction *contradicts* their completeness theorem (in
   which case one of the two is wrong). This is the single highest-value verification in the scan
   and must precede any D-lane drafting.
2. **The deep-hole novelty of the q=11 flagship rests entirely on non-GRS.** Kaipa
   (arXiv:1612.05447, IEEE T-IT 2017) classified deep holes of redundancy-three RS codes
   completely; projective RS is classified to redundancy four (arXiv:1901.05445). Our code is
   redundancy three. Every write-up must state the non-GRS boundary explicitly or the result
   will be read as subsumed.
3. **The char-0 half of C211/B-orbit is classical and recently restated.** The 15 projectivized
   icosahedral mirrors in P^2 (Calvo, arXiv:2209.01499, 2022) and the A5 orbits 6/10/15 with
   invariant conic (Wiman–Edge cluster, Farb–Looijenga, DOI 10.1007/s40879-018-0231-3) are in
   print. Novelty must be claimed only for the F_11 reduction, the conic-carrying 12-orbit, the
   decoder strata, and the q=5 degeneration. The 10+10 "support chirality" bipartition should be
   checked against the classical splitting of the 10-orbit before being presented as new.
   Targeted searches for the finite-field statement itself (A5 in PGL(3,11), icosahedral lines
   over F_11) returned nothing — unclaimed as far as these queries reach; MathSciNet/zbMATH were
   not consulted and should be before a novelty claim goes to print.
4. **Part (v)'s "pointed port" framework may be a named 1970s–2000s notion.** Wagner's ported
   Tutte functions (arXiv:math/0605707) suspend deletion-contraction on a distinguished set
   called ports; Las Vergnas part I is titled "set-pointed matroids". If either coincides with
   our object, the framework contribution collapses to the structure theorem. Additionally,
   "port" carries three incompatible established meanings (ported Tutte, secret-sharing matroid
   ports, our repair ports) — the manuscript must disambiguate on page one.
5. **C330's obstruction may be a known phenomenon type.** Korchmáros–Nagy–Szőnyi find
   curve-derived arcs whose incompleteness localizes to an explicitly identified uncovered locus
   (a subplane, with a parity condition). If our line-at-infinity direction obstruction is the
   same phenomenon in different coordinates, C330's contribution narrows to the exact <= 7Q-2
   count and the explicit threshold. Check before writing it up as a new obstruction type.
6. **The "p=2 gap" in Artin–Schreier invariants is softer than it looks.** The AS-invariants
   papers (arXiv:2401.08843; arXiv:2602.22435) exclude p=2 partly because char-2 AS curves are
   the hyperelliptic analogue and considered understood. "We fill their gap" will be pushed back
   on; the defensible claim is what is genuinely new (non-constant sigma, the three-branch
   residue trichotomy, exact GF(2) splits).
7. **The prescribed-conic framing has no live external audience.** Nothing in 2020–2026 studies
   completeness relative to a prescribed conic/curve; exterior sets of conics (last activity
   2021), hyperfocused arcs (settled 2021), the small-field census race (quiet since ~2015), and
   the Kim–Vu asymptotic race (no improvement since 2003) are all dormant. A1/A2/B1 are not
   superseded — they answer a question only we are asking. The live descendants are the
   Micheli-school constructive papers and the deep-holes thread, which is exactly where entries
   1, 3, and 8 route the results. "Who needs rho_C" is an open strategic question; the
   Hirschfeld–Thas open-problem list (entry 16) is the cheapest test.
8. **The 2^41/2^45 thresholds will not fall via a better density theorem.** All recent effective
   Chebotarev work is number-field; the function-field statement in use is error-term-free, so
   the thresholds are Weil-count-bound. Only the cover's degree/genus is a lever (entry 7).
9. **The scalar-repair frontier is eroding toward the C-object.** Several groups are refining
   trace-repair machinery through 2026 (arXiv:2509.06492 already unifies two 2023–2024
   improvements; robust repair arXiv:2606.05573; partial-exclusion arXiv:2603.12585). If a
   successor computes the full admissible-port structure as an optimization by-product, the
   census loses novelty while staying correct. Mitigation: publish the completeness + I/O-cost
   framing (entries 2, 9), not a bandwidth framing, and do not sit on the manuscript.
10. **Mathlib will not shorten our Lean gates on any near horizon.** No linear-code,
    weight-enumerator, or projective-incidence development located in Mathlib 2025–2026;
    representability lives in the external Seymour project. Also a scan gap to note: no specific
    Mathlib PR numbers/dates could be verified, so the two Mathlib infrastructure claims (Burnside
    tooling, Chevalley–Warning) rest on doc pages and are long-standing, not recent additions.
    The realistic play is engaging Florath/PBLean/Seymour (entry 13), not waiting upstream.
11. **The matroid-rigidity census-replacement hope is weak on current evidence.** State of the
    art in GF(5)-representability at ten elements is still computer enumeration (564 to 2128
    excluded minors across one element, arXiv:2307.14614); the one structural exact-count result
    (arXiv:2206.15188, six inequivalent GF(5)-representations for 3-regular matroids) is anchored
    to the wrong field for our objects. Off-the-shelf structural replacement of our censuses is
    not currently available; our census-plus-kernel-check methodology is aligned with, not
    behind, how that community works.
