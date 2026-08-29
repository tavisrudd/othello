# ergodis certificate formats versus VeriPB-style proof logging: prior-art assessment

Date: 2026-08-29
Purpose: prior-art homework feeding a provisional-patent decision on the combined
"certified observational minimization + orbit cover + provenance DAG with witness lift"
compiler. Not a lane deliverable; not a novelty verdict for a manuscript.

Status: complete. Section 4 (certified automata minimization) comes from a dedicated
literature pass; its findings changed the verdict in §1 and the recommendation in §5.

---

## 1. Verdict

**Structurally different from VeriPB — but that is the wrong question to have asked, and
the answer that matters is worse.** Against pseudo-Boolean proof logging alone, ergodis is
genuinely a different kind of artifact certifying a different kind of property. Against the
*union* of pseudo-Boolean proof logging and the automata/conformance-testing literature,
every individual component of the ergodis bundle is anticipated, and the two literatures
between them cover the whole surface. What is unoccupied is the pipeline, not any piece of
it.

The two-literature picture:

- **Versus VeriPB:** ergodis certifies *minimality* of a compiled model; every VeriPB rule
  certifies *soundness* of a transformation. These are dual and VeriPB has no vocabulary
  for the former. That distinction holds up (§3).
- **Versus automata theory:** the minimality certificate is stated verbatim in
  Kupferman–Lavee–Sickert, ATVA 2021, as the *baseline* they improve on, and the algorithm
  that extracts all-pairs separating sequences from a Hopcroft-style refinement in
  O(m log n) is Smetsers–Moerman–Jansen, LATA 2016, with an implementation, and ships today
  as a public API in AutomataLib/LearnLib (§4.4). That distinction does not hold up.

So the position is: **partially overlapping with each of two disjoint bodies of prior art,
and fully covered by their union at the component level.** A provisional that claims any
single component will be anticipated. Whether a provisional is worth filing turns entirely
on whether the *combination and its packaging* is defensible — see §5.2 and §5.3.

### What the VeriPB comparison actually establishes

VeriPB-style pseudo-Boolean proof logging and the ergodis certificate family both emit a
machine-checkable, independently replayable artifact that justifies a model transformation
without trusting the tool that performed it. On that abstract framing they are the same
idea. They diverge on **what property the artifact establishes**:

- Every VeriPB rule — redundance-based strengthening, dominance-based strengthening,
  checked deletion, the order-change rule, the objective-bound update — certifies
  **soundness**: the transformed constraint database still has the same optimal value (or
  satisfiability status) as the original. The proof system's entire semantics is the
  "weakly (F, f)-valid configuration" invariant of Definition 1 in the JAIR paper. Nothing
  in the proof system can express, let alone check, the statement "no further reduction is
  possible."
- The load-bearing ergodis certificate — the exhaustive pair audit in
  `CertificatePolicy::ExhaustivePairAudit` — certifies **minimality/completeness**: for
  every same-sort pair of concrete states placed in different classes, an explicit
  generator word is stored whose replay ends in different observations. Together with the
  checked quotient-transition property in `verify_compilation`, this is a per-instance
  proof of a *lower bound* on the compiled state count. That is a co-NP-flavoured
  statement about the *absence* of a coarser model, and it is dual to everything VeriPB
  certifies.

Three distinguishing features against VeriPB, in order of how well they survive a
claim-level attack **once the automata literature is also on the table**:

1. **The certificate is emitted at the source-algebra level, above the encoding, and the
   compiled solver model is downstream of it.** VeriPB begins after the problem is a
   0-1 constraint database; its symmetry certificates are witnesses over the *encoded*
   literals, and its symmetry group is whatever survived encoding. The C985 measurement is
   the concrete instance of the gap: the Gross `[[144,12,12]]` semantic translation group
   has order 72, the encoded per-logical formulation retains order 2, and a matrix-
   automorphism pass correctly found only the order-2 group because the rest were no
   longer automorphisms of the encoded problem. A VeriPB proof cannot recover a symmetry
   the encoding destroyed, because the witness substitution has to act on encoded
   variables.
2. **A policy-selected certificate ladder with different verification costs and different
   strengths for the same compilation** (`QuotientOnly` canonical recomputation,
   `SplitTranscript`, `MultiwayTranscript`, `AdaptiveTranscript`, `ExhaustivePairAudit`),
   plus a separate provenance sidecar whose structural validity is checkable in one
   forward scan. VeriPB has one proof format and one checker; there is no notion of
   trading certificate strength against checker work at compile time.
3. **Certified minimality itself**, which is the strongest distinguisher *against VeriPB*
   and the weakest *overall*, because §4.4 shows it is anticipated in the automata
   literature. Keep it as a distinction in the specification's discussion of pseudo-Boolean
   proof logging; do not build an independent claim on it.

What is *not* distinguishing, and should not be claimed alone:

- The orbit cover itself. Section 3 argues it reduces to what VeriPB already does, modulo
  a case-split idiom.
- The per-pair separating-word minimality certificate. Kupferman–Lavee–Sickert, ATVA 2021,
  state the construction verbatim as their baseline; Smetsers–Moerman–Jansen, LATA 2016,
  give an O(m log n) algorithm extracting it from Hopcroft-style refinement; AutomataLib
  exposes `findSeparatingWord` and `characterizingSet` as public API (§4.4).
- "Emit a checkable certificate for a solver-model transformation." That is exactly
  Hoen–Oertel–Gleixner–Nordström, *Certifying MIP-Based Presolve Reductions for 0–1
  Integer Linear Programs*, CPAIOR 2024, whose stated goal is "to verify the equivalence
  between original and reduced models."
- "Lift a witness from the reduced model back to the source." Encoding/postsolve mapping
  with proof logging is Gocht–Martins–Nordström–Oertel, *Certified CNF Translations for
  Pseudo-Boolean Solving*, SAT 2022, and the presolve paper above.
- "An untrusted producer emits a certificate that a verified checker validates per
  instance." Wimmer & von Mutius, TACAS 2020, do exactly this for timed-automata
  reachability (§4.3).

---

## 2. Component-by-component comparison

| ergodis certificate component | nearest prior-art artifact | concrete difference in what is checked, and by whom |
| :--- | :--- | :--- |
| **Separating-path minimality certificate** (`SeparatorRecord`: `left_state`, `right_state`, shared generator-word slice, `left_output`, `right_output`; one record per separated same-sort concrete pair; `CertificatePolicy::ExhaustivePairAudit`) | **Anticipated.** (i) Kupferman, Lavee & Sickert, ATVA 2021 (arXiv:2107.01566): states the access-word-plus-per-pair-separating-word minimality certificate verbatim as their *offline baseline*. (ii) Smetsers, Moerman & Jansen, LATA 2016: computes minimal separating sequences for **all pairs** of states in O(m log n) out of a Hopcroft splitting tree, with an implementation. (iii) AutomataLib `Automata.findSeparatingWord` / `characterizingSet`, shipped API. (iv) Against VeriPB only: Demirović et al., CP 2024, requirement 5, "for any state S dominated, subsumed, or similar by a better state S', generate a proof that S ⇒ S'". | Against VeriPB the distinction is real and sharp: VeriPB proves each *merge* is safe and never proves that two *unmerged* states must stay apart. Against the automata literature there is no distinction of substance. The residual differences are: ergodis emits the artifact as the *minimizer's output contract* in a framed streaming format with a presentation fingerprint, over a **typed multi-sort** presentation with unary-context generators rather than a single-alphabet DFA, and pairs it with a checker. Kupferman et al. certify a *language plus a bound* (quantified over all DFAs for L) rather than a given presentation's partition; Smetsers et al. produce the same data but frame it as conformance-test input and ship no checker. Those are packaging and typing differences. |
| **Refinement transcript** (`SplitRecord` = source block, generator, splitter block, new block; `MultiwayRecord` = source block, new-block range; `CertificatePolicy::{SplitTranscript, MultiwayTranscript, AdaptiveTranscript}`) | Proof-carrying execution traces of partition refinement; VeriPB's `pol`/`rup` step log; the `del`/checked-deletion sequence in a presolve certificate. | The transcript is a replayable log of the *algorithm's own splitting decisions*, checkable in one forward pass without re-running Hopcroft/Moore. VeriPB's step log is a derivation in a fixed inference system; there is no analogous "replay the refinement" object because VeriPB does not have refinement. The adaptive selection between binary and multiway transcript from presentation shape has no counterpart at all. |
| **Canonical recomputation policy** (`CertificatePolicy::QuotientOnly` — verification recomputes the canonical minimum partition rather than retaining per-pair words) | Trust-the-algorithm baselines: verified Hopcroft in Isabelle/HOL (Lammich–Tuerk, ITP 2012) and the Coq regular-language libraries; also VeriPB "kernel mode" versus augmented mode. | This is the weakest ergodis policy and is closest to prior art: it is essentially "run a trusted minimizer twice." It is only interesting as the cheap rung of the ladder. It should not appear in an independent claim. |
| **Coordinate-orbit cover certificate** (`NonemptySupportOrbitCover`, `AnchoredSupportSubproblem{orbit, anchor}`, `verify_permutation_orbits` replaying `predecessor_points`/`predecessor_generators`/`discovery_ranks`, i.e. a certified path from each coordinate to its canonical representative) | Bogaerts–Gocht–McCreesh–Nordström, JAIR 2023, §4: lex-leader constraints certified per generator by the dominance rule; and Anders et al., *Faster Certified Symmetry Breaking Using Orders With Auxiliary Variables*, AAAI 2026 / arXiv:2511.16637. | Prior art certifies *symmetry-breaking constraints added to one model*; ergodis certifies a *partition of coordinates into orbits plus a spanning-forest reachability witness*, and then splits the solve into one anchored subproblem per orbit. The group-theoretic object (the orbit partition with a replayable path) is not what VeriPB emits — VeriPB never materializes an orbit, and "orbit" occurs once in the entire JAIR paper. But see §3: the *effect* is expressible in the dominance rule, so this component is weak on its own. |
| **Provenance DAG forward-scan witness lift** (`ProvenanceArena` with children-precede-parent ordering; `ReplaySidecar` binding a `PresentationFingerprint` + `adapter_id` to records of `(start_state, generator path, terminal_state, observation, provenance node)`; `ReplaySidecar::verify` re-walks each path in both the concrete presentation and the quotient and checks they stay in step) | (i) Gocht–Martins–Nordström–Oertel, *Certified CNF Translations for Pseudo-Boolean Solving*, SAT 2022 (auxiliary-variable encodings with proof logging). (ii) VIPR (Cheung–Gleixner–Steffy, IPCO 2017): certificate carries the claimed optimal solution alongside the bound derivation. (iii) MIP postsolve, certified in Hoen et al., CPAIOR 2024. | The prior art maps *variable assignments* through *one* encoding step. Ergodis's sidecar is a domain-neutral, adapter-typed DAG whose structural validity is decidable in a single forward scan (children precede parents, so no cycle check and no recursion), and whose replay simultaneously re-derives the concrete trajectory and the quotient trajectory and requires them to agree class-by-class. The fingerprint+adapter-id binding makes the sidecar refuse to validate against a different presentation. No prior art I found binds a provenance DAG to a minimization certificate this way. |
| **Rank-bounded contextual quotient** (`RankBoundedContextCache`, `CanonicalContextBasis` with an encoded subspace key, `RankStratifiedEnvelope`/`FrozenRankStratifiedEnvelope` with per-rank strata, restriction edges, and an envelope-parent chain that still identifies an exact minimizing basis) | Nothing close in the proof-logging literature. Nearest neighbours are coding-theoretic subspace-lattice computations and the general idea of a "reduced" DP table with witness pointers. | This is a domain-specific exact-cost structure over the subspace lattice of a finite field, with a witness chain retained after the construction-only data is discarded. It is not a proof-logging artifact and does not overlap VeriPB at all. Its patent relevance is as a dependent claim (a concrete quotient the compiler can emit), not as the novel core. |

---

## 3. What VeriPB's dominance/symmetry rule actually certifies, and whether the orbit cover reduces to it

### 3.1 The mechanism

VeriPB's proof state is a configuration `(C, D, O_⪯, z⃗, v)`: a core constraint set `C`, a
derived set `D`, a preorder `O_⪯` given as a set of pseudo-Boolean constraints over two
copies of a variable vector `z⃗`, the order variables `z⃗`, and the current best objective
value `v`. Soundness is the "weakly `(F, f)`-valid" invariant (JAIR Definition 1): the
configuration must preserve the optimal value of the original formula `F` with objective
`f`, and every total assignment satisfying `C ∪ {f ≤ v−1}` must have a `⪯_f`-dominating
counterpart satisfying `C ∪ D`.

**Redundance-based strengthening** (Definition 6) adds a constraint `C` given a *witness
substitution* `ω` such that

```
C ∪ D ∪ {f ≤ v−1} ∪ {¬C}  ⊢  (C ∪ D ∪ C)↾ω ∪ {f↾ω ≤ f} ∪ O_⪯(z⃗↾ω, z⃗)
```

Read operationally: any assignment satisfying the database but falsifying the new
constraint can be *repaired* by applying `ω`, and the repaired assignment is no worse.

**Dominance-based strengthening** (Definition 13) weakens the first premise — it need only
re-derive `C↾ω` rather than `(C ∪ D ∪ C)↾ω` — at the price of a second premise

```
C ∪ D ∪ {f ≤ v−1} ∪ {¬C} ∪ O_⪯(z⃗, z⃗↾ω)  ⊢  ⊥
```

which forces the repair to be a *strict* decrease in the order, so no infinite descent.
This is what makes symmetry breaking certifiable: repairs are allowed to cycle through
symmetric solutions only if each step strictly improves the order.

The order `O_⪯` is not fixed. The **order-change rule** (Definition 17) lets a proof swap
in a different preorder once it has been established to be a preorder; the derived set `D`
must then be re-justified. The AAAI 2026 follow-up (arXiv:2511.16637) exists precisely
because the JAIR encoding of the lexicographic order uses big-integer coefficients that
blow up for large symmetry groups, and it replaces them with auxiliary variables.

**How symmetry actually gets certified** (JAIR §4): for a syntactic symmetry `σ` of the
formula, the tool adds the standard Crawford–Ginsberg–Luks–Roy lex-leader encoding
(constraints 19a–19d, with fresh `y_j` variables over the ordered support of `σ`), and
each added clause is justified by dominance with `ω = σ` and `O_⪯ = ⪯_lex`. The group is
supplied externally (BreakID / SATSUMA / saucy); VeriPB does not compute it and does not
certify that the tool found the whole group — it only certifies each constraint it is
asked to add. Notably, BreakID's stabilizer-subgroup optimization was *not* certifiable
without extra bookkeeping the tool does not do, so the authors' certifying version drops
it.

### 3.2 Is the ergodis orbit cover expressible in this rule?

**Yes, essentially — with one caveat, and that caveat is not where the value is.**

The ergodis soundness argument is: for a group `G` acting on a nonempty-support feasible
family `F` with `G`-invariant objective `f`, and `R` a set of one representative per
coordinate orbit,

```
min_{S ∈ F} f(S)  =  min_{r ∈ R}  min_{S ∈ F, r ∈ S} f(S)
```

The proof — pick `p ∈ S`, let `r` represent the orbit of `p`, apply the group element
sending `r` to `p` in reverse — is *exactly* a repair argument of the redundance/dominance
shape. Concretely:

- The disjunction `⋁_{r ∈ R} x_r` (some representative is in the support) is derivable by
  dominance: any solution falsifying it has some support coordinate `p` whose orbit
  representative is `r`, and the group element `ω` mapping `p ↦ r` repairs it at equal
  objective. Each such derivation is one dominance step with `ω` a permutation witness.
- The case split into `|R|` anchored subproblems is then a proof-by-cases over that
  disjunction. The VeriPB kernel format has `pbc ⟨inequality⟩ : subproof …` (proof by
  contradiction with an explicit nested subderivation) alongside `pol`, `rup`, `red`,
  `del`, `core`, `ia`, and `conclusion` — confirmed directly against the SAT Competition
  2025 checker documentation. The redundance rule likewise supports `begin`/`end` subproof
  blocks. So the branching structure is representable.
- Fixing `x_r = 1` in subproblem `r` is a literal-axiom restriction inside that branch.

The caveat: VeriPB's model of a solve is *one* constraint database, and the ergodis
product runs `|R|` **separate external solver invocations** with `|R|` separate backend
proofs. Stitching `|R|` independent backend certificates into one dominance-justified case
split is a real engineering artifact, but it is a packaging difference, not a new
inference. If a claim rests only on "restrict search to a certified orbit cover," a
competent examiner or opponent can map it onto Definition 13 plus a case split.

**Where the orbit cover is *not* reducible:** the certificate ergodis emits is about the
*group action on coordinates*, replayed by `verify_permutation_orbits` against a
`FinitePermutationAction` — every supplied generator is checked to be a permutation, the
compiled classes are checked to be exactly its coordinate orbits, and every coordinate
carries a predecessor/generator/discovery-rank triple giving a certified path from its
canonical representative. VeriPB has no group object and no orbit object; it has witness
substitutions. But that is a difference in *data structure*, and data-structure novelty is
thin patent ground on its own.

**The genuinely non-reducible part is the second obligation**, which the C985 note already
isolates: that the *source* feasible family and objective are invariant under every
supplied generator, and that feasible supports are nonempty. Ergodis deliberately does not
assert this generically — an adapter must discharge it from the source presentation. This
is the obligation that lives *above* the encoding, and it is the one VeriPB structurally
cannot host, because by the time VeriPB sees the problem the source algebra is gone. The
compiler that (a) certifies source-level equivariance, (b) emits an equivariant
class-independent model, and (c) binds the two by fingerprint is doing something the
pseudo-Boolean proof-logging stack does not do.

### 3.3 Does anything in the pseudo-Boolean stack certify a *completeness* property?

Two things come close and neither reaches minimality of a model.

- **Certified Pareto-optimality.** Jabs, Berg, Bogaerts, Järvisalo, *Certifying
  Pareto-Optimality in Multi-Objective Maximum Satisfiability*, TACAS 2025
  (arXiv:2501.17493), certifies that a computed non-dominated set is complete — that every
  Pareto-optimal point is present and every excluded point was excluded by a valid step.
- **Certified projected enumeration.** McCreesh, Nordström, Oertel, Tan, *Proof Logging for
  Projected Enumeration (and Counting?) Problems in VeriPB*, CP 2026
  (DOI 10.4230/LIPIcs.CP.2026.43), certifies that an enumeration missed nothing.

Both certify completeness of a *solution set* relative to a fixed model. Neither certifies
that a *model* admits no further reduction. The distinction matters for claim drafting: an
opponent will reach for these to argue that "certifying that nothing is missing" is known
in pseudo-Boolean proof logging. The answer is that the object whose completeness is
certified is different, and there is no pseudo-Boolean encoding of "these two states of the
compiled system are not merged, and correctly so" because states of the compiled system are
not objects the proof system quantifies over.

---

## 4. Certified automata-minimization prior art

**This section is where the assessment turns.** A dedicated literature pass found that the
separating-path minimality certificate — the component I identified in §1 as the strongest
distinguisher from VeriPB — is published prior art in the automata literature, twice, from
two directions. What follows records that finding and its exact scope.

### 4.1 Verified minimization in proof assistants: all once-and-for-all, no per-instance certificate

Isabelle/HOL and Coq/Rocq both have verified minimization, and none of it emits a
per-instance artifact:

- Lammich & Tuerk, *Applying Data Refinement for Monadic Programs to Hopcroft's Algorithm*,
  ITP 2012, LNCS 7406, 166–182, DOI 10.1007/978-3-642-32347-8_12. Verified executable
  Hopcroft in Isabelle, code-generated. Correctness is a theorem about the program.
- Paulson, *Finite Automata in Hereditarily Finite Set Theory*, AFP 2015 and ITP 2015,
  DOI 10.1007/978-3-319-21401-6_15. Myhill–Nerode, Brzozowski minimization, uniqueness of
  the minimal DFA up to isomorphism. Structural proof only.
- Doczkal, Kaiser & Smolka, *A Constructive Theory of Regular Languages in Coq*, CPP 2013,
  DOI 10.1007/978-3-319-03545-1_6 (and Doczkal & Smolka, JAR 2018,
  DOI 10.1007/s10817-018-9460-x). DFA minimization with uniqueness up to state renaming.
- Nipkow & Traytel, *Unified Decision Procedures for Regular Expression Equivalence*,
  ITP 2014. Constructs a bisimulation between derivatives internally; it is consumed by
  the correctness proof, not exported.
- Krauss & Nipkow, *Regular Sets and Expressions* (AFP 2010); Wu, Zhang & Urban,
  *The Myhill–Nerode Theorem Based on Regular Expressions* (AFP 2011); Traytel,
  *Coinductive Languages* / LMCS 2017 (arXiv:1611.09633); Coquand & Siles, CPP 2011,
  DOI 10.1007/978-3-642-25379-9_11; Almeida–Moreira–Pereira–de Sousa, CIAA 2010,
  DOI 10.1007/978-3-642-18098-9_7. All once-and-for-all.
- Mathlib's `Mathlib.Computability.MyhillNerode` has no minimization algorithm and no
  certificate machinery. Nothing on point was found in ACL2 or HOL4.

One quotable negative: Braibant & Pous (*An Efficient Coq Tactic for Deciding Kleene
Algebras*, ITP 2010, DOI 10.1007/978-3-642-14052-5_13; LMCS 8(1:16) 2012,
arXiv:1105.4537; the ATBR library) say in print that their procedure "involves automata
algorithms and does not produce a certificate which could easily be checked in Coq, a
posteriori." That is a published statement that a checkable a-posteriori certificate for
this class of automata reasoning was, as of 2010–2012, what the state of the art lacked.

### 4.2 The certifying-algorithms literature never reached automata

The canonical survey — McConnell, Mehlhorn, Näher & Schweitzer, *Certifying algorithms*,
Computer Science Review 5(2):119–161, 2011 — contains **no certifying algorithm for
automata minimization or automata equivalence** (the sub-agent grepped the full 94-page
preprint end to end; "automat*" occurs only in "can be automated with a checker" and in a
bibliography entry). Same negative for Alkassar, Böhme, Mehlhorn, Rizkallah & Schweitzer,
*An Introduction to Certifying Algorithms*, it–Information Technology 53(6), 2011. This is
a clean citable negative, but it is not where the risk lives.

### 4.3 The untrusted-producer / verified-checker architecture is established in automata-adjacent verification

- Wimmer & von Mutius, *Verified Certification of Reachability Checking for Timed Automata*,
  TACAS 2020, DOI 10.1007/978-3-030-45190-5_24, and Wimmer, Herbreteau & van de Pol,
  *Certifying Emptiness of Timed Büchi Automata*, FORMATS 2020, arXiv:2007.04150. An
  unverified fast tool emits a certificate (a compressed set of abstracted symbolic states);
  an Isabelle-verified checker validates it per instance. This is architecturally the same
  pattern as the ergodis compiler-plus-verifier split, applied to timed-automata
  reachability rather than to minimization. Expect it as an obviousness citation.
- Namjoshi, *Certifying Model Checkers*, CAV 2001, DOI 10.1007/3-540-44585-4_2, is the
  framing precedent for "independently checkable witness for a positive model-checking
  result."
- Tiu, Nguyen & Horne, *SPEC: An Equivalence Checker for Security Protocols*, APLAS 2016,
  DOI 10.1007/978-3-319-47958-3_5, ships "compact and independently checkable
  bisimulations" — a bisimulation as a shipped certificate, for process equivalence.
- Doenges et al., *Leapfrog: Certified Equivalence for Protocol Parsers*, PLDI 2022,
  arXiv:2205.08762, emits a Coq proof term certifying automaton equivalence.
- Bonchi & Pous, *Checking NFA equivalence with bisimulations up to congruence*, POPL 2013,
  DOI 10.1145/2429069.2429124. The bisimulation-up-to-congruence relation is a proof object
  in principle, but the HKC tool documents no exported certificate.

### 4.4 Per-pair separating words as a minimality certificate: **anticipated, explicitly**

**Kupferman, Lavee & Sickert, *Certifying DFA Bounds for Recognition and Separation*,
ATVA 2021 (full version arXiv:2107.01566), state the construction verbatim** in their
introduction, p. 2, and present it as the known baseline they improve upon:

> "assume we want to certify the minimality of a given DFA. That is, we are given a DFA A
> and a bound k ≥ 1, and we seek a proof that L(A) is not k-DFA-recognizable. … Certifying
> that L(A) is not k-DFA-recognizable, we can point to k+1 words h₁,…,h_{k+1} ∈ Σ* that
> belong to different equivalence classes of the relation ∼_{L(A)}, along with an
> explanation why they indeed belong to different classes, namely words t_{i,j} ∈ Σ*, for
> all 1 ≤ i ≠ j ≤ k+1, such that h_i·t_{i,j} and h_j·t_{i,j} do not agree on their
> membership in L(A)."

That is an access-word-per-state plus separating-word-per-pair minimality certificate,
checkable by replay. They call it the **offline** certificate; their contribution is a
shorter **online** certificate obtained from determinacy of a Prover/Refuter game with
regular winning conditions. Quantitatively: the offline certificate encoded as one
universal informative bad prefix has length ≤ (k+N+1)·k·(k+1) = O(k²·N) with a matching
Ω(N³) lower-bound family (their Theorem 1), where N = index(L); checking it costs
2·k(k+1) membership queries on words of length ≤ k+N+1. The online refuter needs only
O(k²+N) rounds, because after the pigeonhole collision a single pair suffices instead of
all pairs. Their certified statement is about a **language plus a bound** — "L is not
k-DFA-recognizable", quantified over all DFAs for L — with the given DFA entering only as
the presentation of L; they say explicitly that taking k = |Q|−1 makes it "this DFA is
minimal."

**Smetsers, Moerman & Jansen, *Minimal Separating Sequences for All Pairs of States*,
LATA 2016, LNCS 9618, 181–193, DOI 10.1007/978-3-319-30000-9_14** (reproduced verbatim as
Chapter 4 of Moerman, *Nominal Techniques and Black Box Testing for Automata Learning*,
PhD thesis, Radboud University 2019) supplies the algorithm. It computes **minimal-length
separating sequences for every pair of inequivalent states in O(m log n)** by instrumenting
Hopcroft's minimization to record a splitting tree: each internal node carries the input
sequence witnessing its split, and the separating word for any pair is read off at their
lowest common ancestor. Their Lemma 18 gives a characterisation set from the tree, Lemma 21
a separating family, Lemma 22 an O(m log n + n²) per-pair extraction bound. Implemented in
Go, benchmarked to 3,410 states. From the thesis, Chapter 1: "The algorithm is inspired by
a minimisation algorithm by Hopcroft (1971), but extending it to construct witnesses is
non-trivial." Their framing is conformance testing (W-method / HSI-method inputs); the word
"certificate" does not appear in that chapter and there is no checker.

**It also ships as a public API.** AutomataLib (the LearnLib project),
`net.automatalib.util.automata.Automata`, exposes — next to `minimize(...)` —
`findSeparatingWord(automaton, state1, state2, inputs)`, `findShortestSeparatingWord(...)`,
`characterizingSet(...)`, `stateCharacterizingSet(...)`, and
`incrementalCharacterizingSet(...)`. Iterating `findSeparatingWord` over pairs already
yields the full pairwise separating-word matrix. Reference: Isberner, Howar & Steffen,
*The Open-Source LearnLib*, CAV 2015, DOI 10.1007/978-3-319-23820-3_32.

### 4.5 The W-method / characterizing set, and exactly how close it is

The characterizing set W of FSM conformance testing — Vasilevskii, *Failure diagnosis of
automata*, Cybernetics 9(4):653–665, 1973; Chow, *Testing software design modeled by
finite-state machines*, IEEE TSE SE-4(3):178–187, 1978, DOI 10.1109/TSE.1978.231496;
Wp-method in Fujiwara, von Bochmann, Khendek, Amalou & Ghedamsi, IEEE TSE 17(6):591–603,
1991, DOI 10.1109/32.87284; survey in Dorofeeva, El-Fakih, Maag, Cavalli & Yevtushenko,
Information and Software Technology 52(12):1286–1297, 2010 — is **defined by exactly the
property a minimality certificate needs**: for every pair of inequivalent states, W
contains a word distinguishing them.

Three differences, in decreasing order of substance:

1. **No checker.** No W-method paper ships a verifier that consumes W and validates
   minimality; W is consumed by test generation. This is a gap in packaging, not in the
   artifact.
2. **Opposite direction of inference.** The W-method *presupposes* the specification FSM is
   minimal and uses W to test an implementation for conformance; a minimality certificate
   *concludes* minimality from the same data. The inferential step is one line, and
   Kupferman–Lavee–Sickert already take it in print.
3. **Flat set versus pair-indexed map.** W is a union, so recovering "which word separates
   p from q" costs up to |W| replays per pair. The HSI-method separating family {H_s} is
   closer to pair-indexed, and the Smetsers–Moerman–Jansen splitting tree is pair-indexed
   exactly, via lowest common ancestor. So even this gap is closed by existing work.

Adjacent and worth knowing: Vaandrager, Garhewal, Rot & Wißmann, *A New Approach for Active
Automata Learning Based on Apartness* (L#), TACAS 2022, arXiv:2107.05419, maintains
*apartness* — a constructive inequality carrying an explicit witness word for each apart
pair — throughout learning. That is a per-pair separating-word data structure by
construction, in a mainstream tool. Angluin, *Learning regular sets from queries and
counterexamples*, Information and Computation 75(2):87–106, 1987, is the root; observation-
table columns are a characterizing set.

Not prior art for the certificate, but owning the term: the separating-words problem
(Goralčík & Koubek 1986; Robson, *Separating strings with small automata*, IPL
30(4):209–214, 1989; Demaine, Eisenstat, Shallit & Wilson, *Remarks on Separating Words*,
DCFS 2011, LNCS 6808, 147–157) asks the inverse question — how small an automaton separates
two given words. Also Martens, *Deciding minimal distinguishing DFAs is NP-complete*,
arXiv:2306.03533, which studies a different witness object (a small DFA whose language is a
subset of exactly one of two given languages) and cites minimal distinguishing *words* only
as the easy polynomial baseline, naming Smetsers–Moerman–Jansen for the efficient
implementation; follow-up Martens, *Minimal DFAs Witnessing Language Inequivalence*,
CSL 2026, DOI 10.4230/LIPIcs.CSL.2026.44.

### 4.6 Patents on certified automata minimization: bounded search, empty

A bounded Google Patents sweep (worldwide full-text corpus as indexed August 2026) found
nothing on point. Field-restricted queries and hit counts: `AB=("automata minimization")`
1 hit (CN116599903A, multi-tenant trusted pattern matching); `AB=("minimal automaton")`
3 hits (JP2009054147A test generation, CN107992946A assume-guarantee learning, one
cross-linked systems patent); `CL=("state machine" "minimization" "certificate")` 1 hit
(CN118859885B, beverage production scheduling); `TI=(certified automata)` 2 hits
(anti-counterfeiting, certified document delivery); `AB=("separating sequence")` 18 hits,
all biotech/mechanical false friends. Full-text queries `"finite state machine"
minimization certificate` (2,121 hits) and `"state machine" minimization witness
verifiable` (298 hits) had uniformly unrelated top-ranked results.

Nearest non-matches: US 10,997,154 B2 *Verifiable state machines* (Setty et al., issued
2021-05-04; academic version at eprint.iacr.org/2020/758) — succinct cryptographic proofs
of state *transitions* of a service; US 5,594,656 classical FSM verification with no
certificate emission; US 8,793,251 and US 8,938,454 regex automaton partitioning.

**Stop condition and limits.** The field-restricted abstract/claims queries returned
single-digit hit counts, all manually inspected and off-topic; the full-text queries
returned large noisy sets whose top-ranked hits were unrelated. No professional
patent-database search (Derwent, PatBase, USPTO Patent Public Search) was run. This is not
a freedom-to-operate opinion.

---

## 5. Claim-drafting implication

### 5.1 What is anticipated and should not be claimed alone

- **A per-pair separating-word minimality certificate.** Not merely "a distinguishing word
  proves two states inequivalent" (Myhill–Nerode, 1958) but the full certificate object —
  representatives plus a separating word for every pair, checked by replay — is stated
  verbatim in Kupferman, Lavee & Sickert, ATVA 2021, as the baseline they improve upon.
  Anticipated outright.
- **Computing all-pairs separating words out of partition refinement.** Smetsers, Moerman &
  Jansen, LATA 2016, at optimal O(m log n) with a splitting tree and a Go implementation;
  exposed as public API in AutomataLib/LearnLib. Anticipated outright, with enablement.
- **The characterizing set W of the W-method / Wp-method / HSI-method** (Vasilevskii 1973,
  Chow 1978, Fujiwara et al. 1991) is by definition a set containing a distinguishing word
  for every inequivalent pair. Same content, different indexing and opposite direction of
  inference — a one-line step that Kupferman et al. already take in print.
- **Untrusted producer plus per-instance verified checker.** Wimmer & von Mutius, TACAS
  2020; Wimmer, Herbreteau & van de Pol, FORMATS 2020. The architecture is established.
- **A checkable certificate for a solver-model transformation.** Hoen–Oertel–Gleixner–
  Nordström, CPAIOR 2024, states the goal as verifying "the equivalence between original
  and reduced models" and does so for 0-1 ILP presolve using VeriPB. This is no longer
  research-only: PAPILO 2.2, the presolving library shipped with the SCIP Optimization
  Suite, lists proof logging of machine-verifiable certificates as a feature. Treat
  certified presolve as shipping production prior art, not as a paper.
- **Certified symmetry breaking with a permutation witness.** Bogaerts–Gocht–McCreesh–
  Nordström, JAIR 2023 §4; Anders et al., arXiv:2511.16637; Anders–Codel–Heule,
  *Orbitopal Fixing in SAT*, arXiv:2601.16855 (which even carries the word "orbit" in its
  technique name, though it certifies only the unit clauses it adds, not an orbit
  partition).
- **Certified merging of dynamic-programming / decision-diagram states.** Demirović–
  McCreesh–McIlree–Nordström–Oertel–Sidorov, CP 2024.
- **Mapping a solution back through an encoding.** Gocht–Martins–Nordström–Oertel, SAT
  2022; VIPR (Cheung–Gleixner–Steffy, IPCO 2017) carries the solution in the certificate.
- **Cryptographic proofs that a state machine executed correctly.** US 10,997,154,
  "Verifiable state machines" (Setty et al., Microsoft, granted 2021-05-04). Adjacent in
  vocabulary, unrelated in substance: it is succinct-argument verification of *execution*,
  not of *minimality* or of a *model reduction*.

### 5.2 The combination that appears not anticipated

Every component above is anticipated individually. What no single reference does is combine
them, and the two literatures that own the pieces do not cite each other: the
pseudo-Boolean proof-logging community (VeriPB and its ecosystem, 2020–2026) and the
automata-minimization/conformance-testing community (Vasilevskii 1973 through
Smetsers–Moerman–Jansen 2016 and Kupferman–Lavee–Sickert 2021) are disjoint bodies of work.
The candidate combination is:

1. **A per-instance certificate that the compiled model is minimal**, not merely sound,
   emitted as the compiler's output contract rather than as test-generation input — and
   over a **typed multi-sort presentation with unary-context generators**, not a
   single-alphabet DFA. The typing is not cosmetic: the certificate is per *same-sort*
   pair, generators are typed source-sort to target-sort, and `verify_compilation` checks
   sort-range containment. Nothing in the automata prior art is multi-sort in this sense.
   This is a narrower claim than "a minimality certificate" and it is the narrowing that
   might survive.
2. **Selectable certificate strength at compile time** — the same compilation emits
   canonical-recomputation-only, a binary split transcript, a multiway transcript, a
   shape-adaptive transcript, or the exhaustive pair audit, and the verifier's obligation
   changes accordingly.
3. **Bounded-memory streaming verification, with a concrete on-disk certificate format.**
   The exhaustive pair audit streams as a framed append-only file with an eight-byte
   `ERGSEP01` header carrying presentation identity and dimensions, one framed
   record-plus-path at a time, and a zero-tagged terminal count footer, so an interrupted
   stream has no valid footer; `verify_exhaustive_separator_stream` checks it straight from
   a reader without retaining records or generator paths. The layered/DAG audit is written
   in reverse-stratum order and `verify_frozen_layered_audit` replays it retaining only the
   compact state-class map and the current stratum's class signatures. This attacks the
   exact pain point the VeriPB literature reports for itself: the CPAIOR 2024 presolve
   paper's own conclusion is that verification "can suffer from large and overly verbose
   certificates," and CP 2025 *Practically Feasible Proof Logging for Pseudo-Boolean
   Optimization* exists to address proof size. A concrete framed format plus a
   constant-residency checker is claimable subject matter in a way that a mathematical
   witness is not.
4. **Binding all of the above to a source-level group action and a provenance DAG that
   lifts a witness from the compiled model back to the source**, with the presentation
   fingerprint and adapter identifier refusing to validate a mismatched pairing.

The best available independent claim is therefore a *method claim on the compiler
pipeline* — and it is only as strong as the narrowing elements, since each step in
isolation is disclosed somewhere:
accept a finite typed multi-sort presentation and a group action; compile a quotient and an
equivariant class-independent model; emit a certificate bundle selected by policy that
includes (a) a minimality witness per separated state pair, (b) an orbit partition with a
replayable representative-path witness, and (c) a provenance DAG in child-before-parent
order binding compiled results to source witnesses; and verify the bundle in a single
forward scan with memory bounded independently of the certificate length.

Dependent claims worth reciting: the streaming reverse-stratum layered audit; the
fingerprint/adapter-id binding that rejects a mismatched presentation; the
adaptive selection between binary and multiway transcripts from presentation shape; the
split of the orbit-cover obligation into a domain-neutral part the compiler discharges and
a domain part an adapter must discharge.

### 5.3 The single most dangerous reference

**Smetsers, Moerman & Jansen, "Minimal Separating Sequences for All Pairs of States",
LATA 2016, LNCS 9618, 181–193, DOI 10.1007/978-3-319-30000-9_14** (verbatim as Chapter 4 of
Moerman's 2019 Radboud PhD thesis).

It is the most dangerous because it reads directly on the core of the compiler, with
enablement. It takes a Hopcroft-style minimizer, instruments it to record a splitting tree,
and emits a minimal-length separating sequence for **every pair** of inequivalent states in
O(m log n), with an implementation benchmarked to thousands of states. That is the
separating-path certificate, produced by the mechanism ergodis uses, published a decade
ago. Its own framing is conformance testing rather than certification, and it ships no
checker — but the missing step is supplied in print by
**Kupferman, Lavee & Sickert, "Certifying DFA Bounds for Recognition and Separation",
ATVA 2021 (arXiv:2107.01566)**, which states the certificate object verbatim and calls it
the baseline. Those two together are an obviousness combination that reads on the
observational-minimization certificate in full. Assume an examiner or an opponent will make
it, because the second paper cites the same literature the first sits in.

The two runners-up, one per axis:

- **On the symmetry axis:** Bogaerts, Gocht, McCreesh, Nordström, "Certified Dominance and
  Symmetry Breaking for Combinatorial Optimisation", JAIR 77 (2023) 1539–1589,
  DOI 10.1613/jair.1.14296 (arXiv:2203.12275). Its dominance rule (Definition 13) is
  general enough to encode the ergodis orbit-cover argument — the repair-by-group-element
  proof is literally the rule's intuition — and it anchors an ecosystem (VeriPB, CakePB,
  PBLean, SATSUMA, orbitopal fixing, certified presolve, certified DP/decision diagrams)
  whose 2020–2026 output covers nearly every remaining element of the bundle.
- **On the state-merging axis:** Demirović, McCreesh, McIlree, Nordström, Oertel, Sidorov,
  "Pseudo-Boolean Reasoning About States and Transitions to Certify Dynamic Programming and
  Decision Diagram Algorithms", CP 2024, DOI 10.4230/LIPIcs.CP.2024.9. Its seven-step
  recipe is a certified state-merging compiler in all but name. The defence is precise and
  should be drafted into the specification: its step 5 obligation is "for any state S
  dominated, subsumed, or similar by a better state S', generate a proof that S ⇒ S'" — a
  soundness obligation on merges *performed*. It has no obligation of the form "for states
  S and S' left unmerged, prove they must stay apart."

**A rising threat worth watching rather than citing.** Szeider, *PBLean: Pseudo-Boolean
Proof Certificates for Lean 4*, arXiv:2602.08692 (February 2026), imports VeriPB
certificates into Lean 4 by reflection and adds "verified encodings" — formalized
correctness proofs connecting a combinatorial problem to its constraint encoding. That is
the pseudo-Boolean ecosystem reaching upward toward exactly the source-semantics boundary
that distinguishing feature 2 in §1 relies on. It closes the gap by formalizing each
encoding once in Lean rather than by emitting a per-instance certificate of source-level
equivariance, so it does not anticipate the ergodis approach today. It does mean the
"VeriPB cannot see above the encoding" argument has a shelf life and should not be the sole
load-bearing distinction in a specification.

### 5.4 Practical recommendation

**Do not file on any single component.** The orbit cover, the witness lift, and the
minimality certificate are each anticipated — the first two by the pseudo-Boolean stack,
the third by the automata literature, and the third most decisively of the three.

If a provisional is filed at all, the independent claim must be the *integrated pipeline*
over a typed multi-sort presentation with a source-level group action: compile the quotient
and the equivariant class-independent model together; emit a policy-selected certificate
bundle in a framed streaming format bound by presentation fingerprint; verify it in a
single forward scan at memory bounded independently of certificate length; and lift a
witness through the provenance DAG back to the source. The narrowing elements that carry
the weight are the multi-sort typing, the certificate-strength policy ladder, the streaming
format with constant-residency checking, and the fingerprint/adapter binding — not the
mathematics.

**My assessment of whether that is worth filing:** the surviving material is a system-and-
format claim, not a mathematical one, and system-and-format claims over a combination of
two well-published techniques are cheap to design around. Before spending on a provisional,
identify precisely what ergodis does that is not the union of Smetsers–Moerman–Jansen,
Kupferman–Lavee–Sickert, Wimmer's untrusted-producer/verified-checker architecture, and the
JAIR dominance rule. If that residue cannot be named in one sentence, the filing is not
worth it, and the same work is better spent on publication and on the compiler itself.

**Terminology warning.** "Separating path" is a coined term for what the literature calls a
separating sequence, distinguishing sequence, or separating word; "observational
minimization" overlaps standard partition-refinement minimization and bisimulation
minimization. Non-standard terminology does not create novelty, it makes the prior art
harder for an examiner to find, and at the information-disclosure stage that is a
liability. Use the standard names in any filing and in any paper.

---

## 6. Sources consulted

Cached blobs live in the shared literature cache at `/tmp/persistent/tavis/lit-search/`;
keys and SHA-256 values are given so a later reader can confirm identical bytes.

### Pseudo-Boolean proof-logging thread

| Source | Identifier | Depth |
| :--- | :--- | :--- |
| Bogaerts, Gocht, McCreesh, Nordström, *Certified Dominance and Symmetry Breaking for Combinatorial Optimisation*, JAIR 77 (2023) 1539–1589 | DOI 10.1613/jair.1.14296; arXiv:2203.12275; cache key `arXiv:2203.12275`, sha256 `026caf5d675eab8d6b8d163d91cfef5c719d0e1ce775f476e6973354ddc06509`, 51 pp. | Read in full for §3 (Definitions 1, 4, 5, 6, 8, 10, 12, 13, 17 and the §4 symmetry-breaking construction); §5 (CP) and §6 (max clique) skimmed. |
| Anders, Bogaerts, Bogø, Gontier, Koops, McCreesh, Myreen, Nordström, Oertel, Rebola-Pardo, Tan, *Faster Certified Symmetry Breaking Using Orders With Auxiliary Variables*, AAAI 2026 | arXiv:2511.16637; cache key `arXiv:2511.16637`, sha256 `eb98fe7ac7cedb44172ee73791afd91fae90cb5a5fc50e8b49b29119f0b09dbf`, 26 pp. | Abstract and introduction read; establishes that the JAIR lex-order encoding is the scaling bottleneck and is being replaced by auxiliary-variable orders. |
| Anders, Codel, Heule, *Orbitopal Fixing in SAT*, submitted 2026-01-23 | arXiv:2601.16855 | Abstract only (via fetch). Certifies added unit clauses in the substitution redundancy system; does not certify an orbit partition or a case split. |
| Demirović, McCreesh, McIlree, Nordström, Oertel, Sidorov, *Pseudo-Boolean Reasoning About States and Transitions to Certify Dynamic Programming and Decision Diagram Algorithms*, CP 2024, LIPIcs 307, 9:1–9:21 | DOI 10.4230/LIPIcs.CP.2024.9; cache key `10.4230/LIPIcs.CP.2024.9`, sha256 `f5a7037a0f74d32139a4914a4c4d9a864d744283b52e2f850eccc8ecbf09ab4d`, 21 pp. | Abstract and the seven-step framework section read in full; the knapsack/longest-path/interval-scheduling instantiations skimmed. |
| Hoen, Oertel, Gleixner, Nordström, *Certifying MIP-Based Presolve Reductions for 0–1 Integer Linear Programs*, CPAIOR 2024, 310–328 | DOI 10.1007/978-3-031-60597-0_20; arXiv:2401.09277; cache key `arXiv:2401.09277`, sha256 `4f3cd31796e50305c96a764a6f3478cf7f2a679f3e046a25c71712832402934b`, 19 pp. | Abstract and conclusion read in full; §3 rule constructions skimmed. |
| Gocht, Martins, Nordström, Oertel, *Certified CNF Translations for Pseudo-Boolean Solving*, SAT 2022 | veripb.org publication list | Metadata and topical placement only; not fetched. |
| Ihalainen, Oertel, Tan, Berg, Järvisalo, Myreen, Nordström, *Certified MaxSAT Preprocessing*, IJCAR 2024 | veripb.org publication list; arXiv:2404.17316 | Metadata only. |
| Koops, Le Berre, Myreen, Nordström, Oertel, Tan, Vinyals, *Practically Feasible Proof Logging for Pseudo-Boolean Optimization*, CP 2025 | DOI 10.4230/LIPIcs.CP.2025.21 | Abstract-level, via search result; cited only for the fact that proof size is an acknowledged problem. |
| VeriPB publication index (full topic-grouped list of the ecosystem: symmetry/dominance, preprocessing, MaxSAT, CP, graph algorithms, planning, checker verification) | https://veripb.org/publications.html | Fetched and read in full. |
| VeriPB implementation and proof-format documentation | https://github.com/StephanGocht/VeriPB; SAT Competition 2023/2025 checker documentation at satcompetition.github.io | Abstract/summary level, via search results; used for the kernel-format rule inventory (`pol`, `rup`, `pbc`, `red`, `dom`, `del`, `weaken`, `sol`/`soli`, `conclusion`). |
| Jabs, Berg, Bogaerts, Järvisalo, *Certifying Pareto-Optimality in Multi-Objective Maximum Satisfiability*, TACAS 2025 | arXiv:2501.17493 | Abstract-level, via search result; cited for the completeness-of-a-solution-set adjacency. |
| McCreesh, Nordström, Oertel, Tan, *Proof Logging for Projected Enumeration (and Counting?) Problems in VeriPB*, CP 2026 | DOI 10.4230/LIPIcs.CP.2026.43 | Metadata and abstract-level only; same adjacency. |
| Cheung, Gleixner, Steffy, *Verifying Integer Programming Results*, IPCO 2017, 148–160; VIPR format | DOI 10.1007/978-3-319-59250-3_13; arXiv:1611.08832; https://github.com/scipopt/vipr | Abstract and format description only, via search results and the repository description. |
| Szeider, *PBLean: Pseudo-Boolean Proof Certificates for Lean 4*, arXiv:2602.08692 (Feb 2026, rev. Apr 2026) | arXiv:2602.08692 | Abstract read in full via fetch. Supports all VeriPB kernel rules by reflection, plus "verified encodings" linking problem semantics to constraints. |
| Kupferman, Lavee, Sickert, *Certifying DFA Bounds for Recognition and Separation*, ATVA 2021 | arXiv:2107.01566; cache key `arXiv:2107.01566`, sha256 `240d0456869040a512dad3c676706c93af8d624fc1bf0fed44390d4f39f60818`, 20 pp. | Abstract read in full; certificate-mechanism passages located by targeted search. See §4 for the characterization. |
| US 10,997,154 B2, *Verifiable state machines* (granted 2021-05-04) | https://patents.justia.com/patent/10997154 | Abstract only. |
| Patent-landscape sweep on the optimization side | Google Patents (returned HTTP 503 on the one query attempted) and Justia via web search, on "symmetry breaking + certificate + optimization model", "state machine minimization + certificate", "proof logging + constraint solver + model transformation" | **Negative, and weakly evidenced.** Bounded search only; the direct Google Patents query failed with a server error and was not retried. Nothing in the certified-model-reduction space surfaced except US 10,997,154, which is a different subject. A real freedom-to-operate search by counsel is not substituted for by this. |

### Automata-minimization thread

| Source | Identifier | Depth |
| :--- | :--- | :--- |
| Kupferman, Lavee, Sickert, *Certifying DFA Bounds for Recognition and Separation*, ATVA 2021 | arXiv:2107.01566; cache key `arXiv:2107.01566`, sha256 `240d0456869040a512dad3c676706c93af8d624fc1bf0fed44390d4f39f60818` | Abstract, introduction (including the quoted passage), Theorem 1 and its proof, and the online-refuter theorem and proof read in full; remainder skimmed. |
| Smetsers, Moerman, Jansen, *Minimal Separating Sequences for All Pairs of States*, LATA 2016, LNCS 9618, 181–193 | DOI 10.1007/978-3-319-30000-9_14; verbatim as Ch. 4 of Moerman, *Nominal Techniques and Black Box Testing for Automata Learning*, PhD thesis, Radboud University 2019 | Thesis Ch. 1 summary, Ch. 2 §1.4 and §3, Ch. 4 §1/§4/§5 read in full. No open copy of the LATA proceedings version was reachable; the thesis chapter is the same text. |
| AutomataLib / LearnLib, `net.automatalib.util.automata.Automata` API | https://learnlib.de/ ; Isberner, Howar, Steffen, *The Open-Source LearnLib*, CAV 2015, DOI 10.1007/978-3-319-23820-3_32 | API documentation read in full; the paper metadata-only. |
| McConnell, Mehlhorn, Näher, Schweitzer, *Certifying algorithms*, Computer Science Review 5(2):119–161, 2011 | DOI 10.1016/j.cosrev.2010.09.009; preprint at people.mpi-inf.mpg.de/~mehlhorn/ftp/CertifyingAlgorithms.pdf | Full text extracted and grepped end to end. Clean negative: no automata minimization or equivalence content. |
| Alkassar, Böhme, Mehlhorn, Rizkallah, Schweitzer, *An Introduction to Certifying Algorithms*, it–Information Technology 53(6), 2011 | DOI 10.1524/itit.2011.0655 | Full text read. Same negative. |
| Braibant, Pous, *An Efficient Coq Tactic for Deciding Kleene Algebras*, ITP 2010 / *Deciding Kleene Algebras in Coq*, LMCS 8(1:16), 2012; ATBR library | DOI 10.1007/978-3-642-14052-5_13; arXiv:1105.4537 | Abstract plus library documentation. Source of the quotable statement that their procedure "does not produce a certificate which could easily be checked in Coq, a posteriori." |
| Lammich, Tuerk, *Applying Data Refinement for Monadic Programs to Hopcroft's Algorithm*, ITP 2012, LNCS 7406, 166–182 | DOI 10.1007/978-3-642-32347-8_12 | Abstract and venue metadata only; the TUM PDF was unreachable on two attempts. |
| Paulson, *Finite Automata in Hereditarily Finite Set Theory*, AFP 2015 / ITP 2015 | DOI 10.1007/978-3-319-21401-6_15 | AFP entry page read in full. |
| Krauss, Nipkow, *Regular Sets and Expressions*, AFP 2010 | AFP entry | Entry page read in full. |
| Doczkal, Kaiser, Smolka, CPP 2013; Doczkal, Smolka, JAR 2018; RegLang | DOI 10.1007/978-3-319-03545-1_6; DOI 10.1007/s10817-018-9460-x | CPP abstract and author page read; JAR abstract only. |
| Nipkow, Traytel, *Unified Decision Procedures for Regular Expression Equivalence*, ITP 2014; Wu–Zhang–Urban AFP Myhill–Nerode 2011; Traytel *Coinductive Languages* / LMCS 2017 (arXiv:1611.09633); Coquand–Siles CPP 2011 (DOI 10.1007/978-3-642-25379-9_11); Almeida–Moreira–Pereira–de Sousa CIAA 2010 (DOI 10.1007/978-3-642-18098-9_7); Moreira–Pereira–de Sousa RAMiCS 2012 (DOI 10.1007/978-3-642-33314-9_7) | as listed | Abstract-only. |
| Mathlib `Mathlib.Computability.MyhillNerode` and `Mathlib.Computability.DFA` (Lean 4) | Mathlib documentation | Metadata only. Nothing on point located in ACL2 or HOL4. |
| Wimmer, von Mutius, *Verified Certification of Reachability Checking for Timed Automata*, TACAS 2020; Wimmer, Herbreteau, van de Pol, *Certifying Emptiness of Timed Büchi Automata*, FORMATS 2020 | DOI 10.1007/978-3-030-45190-5_24; arXiv:2007.04150 | Abstract-only. Architectural precedent for untrusted producer plus verified per-instance checker. |
| Bonchi, Pous, *Checking NFA equivalence with bisimulations up to congruence*, POPL 2013; HKC tool | DOI 10.1145/2429069.2429124; perso.ens-lyon.fr/damien.pous/hknt/ | Abstract-only for the paper; tool page read in full (documents no certificate output). |
| Namjoshi, *Certifying Model Checkers*, CAV 2001; Tiu, Nguyen, Horne, *SPEC*, APLAS 2016; Doenges et al., *Leapfrog*, PLDI 2022; Hemaspaandra, Narváez, CICM 2022; Hopcroft, Karp, Cornell TR 71-114, 1971 | DOI 10.1007/3-540-44585-4_2; DOI 10.1007/978-3-319-47958-3_5; arXiv:2205.08762; DOI 10.1007/978-3-031-16681-5_17 | Abstract- or metadata-only. |
| Vasilevskii, Cybernetics 9(4):653–665, 1973; Chow, IEEE TSE SE-4(3):178–187, 1978 (DOI 10.1109/TSE.1978.231496); Fujiwara, von Bochmann, Khendek, Amalou, Ghedamsi, IEEE TSE 17(6):591–603, 1991 (DOI 10.1109/32.87284); Dorofeeva et al., IST 52(12):1286–1297, 2010; Lee, Yannakakis, Proc. IEEE 84(8):1090–1123, 1996 (DOI 10.1109/5.533956); Gill 1962; Kohavi 1970/1978; Hierons, Türker, Computer Journal 58(11):3089–3113, 2015 (DOI 10.1093/comjnl/bxv027) | as listed | Metadata-only. The W-method / characterizing-set thread. |
| Angluin, Information and Computation 75(2):87–106, 1987; Vaandrager, Garhewal, Rot, Wißmann, *L#*, TACAS 2022 (arXiv:2107.05419) | as listed | Metadata- and abstract-only. |
| Goralčík, Koubek 1986; Robson, IPL 30(4):209–214, 1989; Demaine, Eisenstat, Shallit, Wilson, DCFS 2011, LNCS 6808, 147–157; Martens, arXiv:2306.03533; Martens, CSL 2026, DOI 10.4230/LIPIcs.CSL.2026.44 | as listed | arXiv:2306.03533 read in full; the rest metadata-only. The separating-words problem is the inverse question and is not prior art for the certificate. |
| Google Patents sweep on the automata side | Google Patents full-text corpus as indexed August 2026; queries and hit counts recorded in §4.6 | Query results inspected. Bounded, not exhaustive; no professional patent-database search was run. |

### Ergodis sources and prior lane notes

| Source | Identifier | Depth |
| :--- | :--- | :--- |
| ergodis crate sources | `/home/tavis/src/othello/papers/complete-repair-ports/ergodis/src/{observational,semantic_symmetry,provenance,contextual,group_action}.rs`, `README.md` | Module documentation and public certificate/transcript types read directly; implementation bodies skimmed. |
| C985 Gurobi-boundary and semantic-symmetry spike note | `/home/tavis/src/othello/notes/2026-08-29-c985-ergodis-gurobi-boundary-and-semantic-symmetry-spike.md` | Read in full for the two-obligation split and the order-72-versus-order-2 measurement. |
| C983 90-minute cross-domain expansion report | `/home/tavis/src/othello/notes/2026-08-27-c983-90m-report.md` | Red-team findings section read; the note contains no prior-art matrix on the proof-logging axis. |
