# Fresh connections review of rp-next / C239 (Fable 5)

**Lane:** `rp-next` (external review; allocates no task, reopens no gate)

**Date:** 2026-07-17

**Reviewer model:** Claude Fable 5

> **Provenance caveat.** Most of this document may have been written by Claude Opus, not Fable 5,
> during a session where safeguards were triggered by unrelated content being read; the "Fable 5"
> attribution in the filename and header is therefore not reliable for this file. Two technical errors
> flagged in a follow-up review have since been **corrected inline** (marked **[Corrected 2026-07-17]**):
> the §5 idealness-vs-Mengerian conflation and the §1 confidence overreach. A companion pass that treats
> those corrections more fully and adds further connections is in
> [`2026-07-17-fable5-rp-next-missed-connections.md`](2026-07-17-fable5-rp-next-missed-connections.md)
> (whose own model attribution is likewise uncertain — see the note to the user in-session).

**Reviewed:** the `rp-next` handoff, the [C239 domain-translation audit](2026-07-17-c239-domain-translation-audit.md),
the [open-doors brainstorm](2026-07-16-repairports-applications-open-doors-brainstorm.md) (items 1–28),
the [brainstorm response](2026-07-16-repairports-applications-brainstorm-response.md) (R1–R11), and the
`rp-next` discovery track. Deliberately not read: the C239 scratchpad, the C238 commercial doc.

## 0. The one framing move that changes the grade ceiling

C239 keeps landing every paper at **B+/A−**. That is not a property of the material; it is a property
of *where it is searching*. The audit searches applied/systems neighborhoods — compilers, provenance,
e-graphs, planning, bioinformatics — where the contribution is always "a better packaging of known
machinery," which caps at A−. The A/A+ is in the opposite direction: **pure combinatorics and
complexity theory**, where the repair-port families are not applications to be packaged but *explicit
hard instances and separating gadgets* that resolve a stated question with an unconditional theorem.

Every high-value item below is an instance of that move: stop treating the port as a thing to compile,
start treating it as a thing that *proves a separation*. The C217/C237 support-identical-but-different
phenomena, the char-3 collapse (R11), and the AG(2,3) exclusion (R6) are not curiosities — they are
exactly the field-sensitive gadgets that the mature lower-bound machineries are hungry for.

The rest of this report is eight fresh mathematical homes. Five of them (§1, §2, §3, §5, §7) ship with
off-the-shelf theorems (unconditional lower bounds, decidable dichotomies, integrality characterizations,
universality). Those are the A-grade imports the two prior brainstorms did not name.

## 1. Papers M and T have one precise home: matroids over tracts (A+ packaging)

C239 §2.1 and Paper M reach for "pointed elementary vectors across fields and cones" and concede
"oriented-matroid and polyhedral theory may already contain most of it." It contains **all** of it, and
the exact object is newer and sharper than oriented matroids: **Baker–Bowler matroids over
hyperfields/tracts** (2017–2019), with **Baker–Lorscheid foundations** (2020) for the moduli half.

The dictionary is **conjecturally exact** — pending the tract circuit-axiom / elimination check listed as
the §10 one-page audit — rather than merely analogical (**[Corrected 2026-07-17]**: the original draft
asserted "exact, not analogical" and pre-graded the result A+; the confidence should follow that
verification, not precede it):

| rp-next object | Baker–Bowler / foundation object |
|---|---|
| finite-field repair circuits | matroid over the field `F_q` (a tract) |
| elementary flux modes / real cones | matroid over the **sign hyperfield** (= oriented matroid) |
| tropical/bottleneck delay carrier (C234) | matroid over the **tropical hyperfield** (= valuated matroid) |
| L0 support matroid | pushforward along the terminal morphism `K → Krasner hyperfield` |
| L1 label / C217 holonomy | element of the matroid's **foundation** (a pasture) |
| C217/C237 support-identical, capability-different | fibre of the foundation over the Krasner point is non-trivial |

Why this is A+ and not a rename: the foundation is the *universal* object recording all representations
of one support matroid up to gauge — it is precisely the "moduli of ideal linear realizations" that item
18 and item 4 asked for, already constructed, with functoriality and a cryptomorphic circuit axiom system
proved. Paper M's required theorem ("covering at least fields and subspace cones, with preservation
results") is *the definition* of a matroid over a tract plus the functoriality of circuits/vectors under
tract morphisms. Paper T's "capability shadow" is literally the terminal morphism to Krasner, and "does
the shadow determine the capability" becomes "is the foundation trivial" — a computable question per
matroid.

**Action:** before any oriented-matroid specialist audit (C239 priority 5), do a Baker–Bowler/foundation
audit. Prediction (a strategic bet, not a finding): *if* the circuit-axiom check passes, M and T plausibly
merge into one paper — "the foundation of a repair port" — with an A−/A ceiling, because the
finite-field/oriented/valuated unification is exactly the tract formalism's reason to exist and no one has
instantiated it on repair/LRC families. The grade is contingent on that instantiation.

Anchors: Baker–Bowler *Matroids over hyperfields* (arXiv 1601.01204); Baker–Lorscheid *The moduli space
of matroids* / *Foundations of matroids* (arXiv 2008.00014).

## 2. Paper N's succinctness question is monotone span program complexity (A/A+)

C239 §3.1 / Paper N wants a "knowledge-compilation map: which queries become tractable, which
representations stay succinct." The audit measures this against d-DNNF/BDD/ZDD and concedes it "needs
complexity theorems." Those theorems exist under a different name that the brainstorm walked right past
despite discussing LSSS for pages:

> The complete repair port at `x` **is a monotone span program** computing the monotone Boolean function
> "is `x` recoverable from the surviving set," and its size is the number of circuits through `x`. The
> representing field is the code's field.

This is the Karchmer–Wigderson identity (LSSS = MSP), read in the repair direction. It converts Paper N's
soft "succinctness frontier" into a hard, cited theory:

- **Unconditional size lower bounds** for monotone span programs exist (Babai–Gál–Wigderson 1999; and the
  modern super-polynomial and monotone-circuit-vs-MSP separations of Robere–Pitassi–Rossman–Cook and
  Pitassi–Robere via query-to-communication lifting). These transfer verbatim into "capability capsule
  succinctness lower bounds."
- **Field dependence of MSP size is a theorem, not a hope.** MSP size over `F_2` vs `F_3` vs `F_q` is
  provably different for explicit functions. That is exactly the L0-vs-L1 separation C239 keeps asserting
  (support forgets coefficients) — here it is *quantitative and unconditional*. The char-3 collapse (R11)
  and the AG(2,3) exclusion (R6) are the natural seed gadgets: a function whose small MSP exists only over
  fields with cube roots of unity is a field-sensitivity separation with a repair-port witness.

**This is the A+ lever.** The strongest paper in the whole portfolio is not "a KC map for recovery"; it is
"**explicit field-sensitive monotone span program separations from repair-port geometry**," aimed at the
lifting-theorem / monotone-complexity community, using C217/C237/R6/R11 as the gadget library. That
audience grades on separations, not packaging, so the ceiling is A/A+. Paper N (the KC map) then becomes
the applied companion, not the flagship.

Anchors: Karchmer–Wigderson (span programs); Beimel (LSSS↔MSP survey); Robere–Pitassi–Rossman–Cook
*Exponential Lower Bounds for Monotone Span Programs* (FOCS 2016); Pitassi–Robere (lifting).

## 3. C234 / Paper P: the finiteness boundary is the tropical-automata twins dichotomy (A−)

Paper P and C234 hand-derive "finite structural control but infinite exact value carrier," cite weighted
automata generically, and propose to prove a bespoke "canonical contextual quotient." The sharp, decidable
tool is sitting one citation away:

- C234's budget-indexed arrival profiles form a **min-plus (tropical) weighted automaton / transducer**.
- C232's unbounded-delay obstruction (triangle relays with pairwise-distinct delays) is precisely a
  **failure of the twins property** — the exact obstruction to determinization/sequentialization of a
  min-plus automaton (Mohri; Kirsten–Lombardy).
- C233's terminal-closure finiteness is **determinizability under the fork/twins condition**.
- Paper P's "minimal qualitative quotient" is **Myhill–Nerode for the tropical automaton**, and "which
  valuations factor through it" is the sequential-function characterization.

So Paper P's central theorem is not bespoke: it is the statement that bounded-restoration transfer sits
exactly on the *decidable* sequential/non-sequential boundary of tropical automata, with C232 as the
canonical non-twins witness and C233 as the twins-satisfied regime. That is a clean A− because the
dichotomy is known and decidable; the contribution is the exact-repair instantiation plus the distinguishing-
context generator (which is the twins-property counterexample construction).

Anchors: Mohri *Finite-state transducers in language and speech processing* (twins property);
Kirsten–Lombardy (decidability of sequentiality / determinizability of tropical automata).

## 4. The whole L2+L3 layer is weighted min-cost directed hyperpaths — with algorithms (A− for Paper O)

Items 15/28 and C230/C234 describe Horn rules `H → x`, sequential closure, and min–max arrival
convolutions, and correctly name "directed hypergraph reachability." They stop at *reachability*. The
weighted object is a named, solved theory:

> Cheapest/earliest sequential recovery is a **min-cost directed hyperpath** (Gallo–Longo–Pallottino–Nguyen),
> equivalently **Knuth's grammar problem** (the generalization of Dijkstra to superior/monotone functions,
> 1977), and its semiring generalization is **weighted logic programming / weighted deduction** (Goodman;
> Huang–Chiang k-best).

This is the missing engine for Paper O's failure-aware multi-extractor: the "causal materialization
schedule whose earlier terms unlock later extractions" is a min-cost hyperpath with multiple roots, and
the C234 tropical transfer algebra *is* the hyperpath valuation over the bottleneck semiring. Everything
the audit wants to build (§5.3 multi-extractor, §5.4 multi-valuation engine) is a k-best / semiring
generalization of Knuth's algorithm with capacity side-constraints. Concretely this also settles §5.4's
"which cheap evaluator is sound for which query" — it is exactly the condition that the query's semiring
is *superior* (Knuth's monotonicity), which is decidable per query.

**Consequence for grading:** Paper O should cite the hyperpath/weighted-deduction line as its backbone and
claim only the *failure+capacity+certificate* increment. Without that framing it reads as reinventing
Knuth; with it, the increment is crisp and the algorithm is a modification of a known optimal one.

Anchors: Gallo–Longo–Pallottino–Nguyen *Directed hypergraphs and applications* (1993); Knuth *A generalization
of Dijkstra's algorithm* (1977); Huang–Chiang *Better k-best parsing* (weighted-deduction k-best).

## 5. C235 capacity integrality is governed by ideal-clutter / MFMC theory (A−, and it explains the nucleus)

R9 and item 6 correctly identify batch/PIR service and the fractional LP, and note the C218 nucleus makes
availability gap-free while throughput collapses. The *reason* has an exact name they didn't reach: the
repair-set family is a **clutter**, its blockers are the transversal clutter (this is R1/C227 blocker
duality restated), and

> **[Corrected 2026-07-17]** idealness and the max-flow-min-cut (packing) property are *different*, and
> the original draft conflated them. Keep two properties apart: **ideal** (covering LP integral for all
> right-hand sides) governs **availability**; **Mengerian / MFMC** (packing LP integral for all capacities)
> governs **throughput**. MFMC implies ideal, never the converse. The C218 nucleus port is **ideal**
> (covering gap-free — this is *why* single-target availability is `(nu,tau)=(1,1)` with zero gap, matching
> R9) but **not Mengerian** (packing fails, so simultaneous throughput caps at one). The canonical
> ideal-but-not-Mengerian clutter is `Q_6`; the harmonic nucleus port is a repair-theoretic witness of the
> same kind.

This upgrades the C218 separation from "a nice example" to "an ideal-but-not-Mengerian repair clutter,"
which is a *classification* statement of the kind that grades well. It also gives C235 a general theorem
shape: characterize which port clutters are **Mengerian** (throughput-integral, no nucleus bottleneck)
versus **ideal-only** (available but throughput-capped), via Seymour's MFMC characterization (excluded
`Q_6` / odd-hole minors), rather than computing regions case by case. The `8/3`-to-`1` nucleus ratio is
then the fractional-vs-integral packing gap of a specific non-Mengerian minor.

Note: minimally-non-ideal (Lehman) clutters are the *wrong* class here — idealness **holds**; it is the
packing side that fails.

Anchors: Cornuéjols *Combinatorial Optimization: Packing and Covering* (`Q_6` as the ideal-not-Mengerian
exemplar); Seymour *The matroids with the max-flow min-cut property*.

## 6. C229 / Pick D: sequential unlock = bootstrap percolation = metabolic scope, one operator (surprise + free thresholds)

The brainstorm treats Horn closure (item 28), metabolic network expansion (C239 §3.3), and target-set
selection as *neighbors*. They are the **same monotone closure operator**, and the identity is worth
stating because it hands C229/Pick D its promotion gate for free:

- "random-cascade threshold theorem" (Pick D gate) = a **bootstrap-percolation threshold** on the repair
  hypergraph; the extremal/threshold machinery (Balogh–Bollobás–Morris–Riordan) is off the shelf.
- metabolic "scope" (network expansion) is *the identical operator* biologists run — so Paper R's export
  claim ("our separator transfer speeds up modular scope") is not a bio-specific gamble; it is a statement
  about the same object, which de-risks R substantially.
- the antimatroid question (item 28) is: is this closure **anti-exchange** (a convex geometry)? The
  monotone-closure/percolation literature already characterizes when unlock closures are convex geometries,
  which is exactly R4(e)'s "truncation strictly loses closure" habitat.

**Surprise worth a discovery-track entry:** if the repair-port closure is a bootstrap process on a *design*
(Steiner/harmonic) geometry, then C218's nucleus is a "seed-set percolation" bottleneck and the minimal
permanent-failure sets (Pick D deliverable) are minimal *percolation-blocking* sets — a well-studied
extremal quantity. This is the cleanest route to a *theorem* out of C229 rather than a q=9 census.

Anchors: Balogh–Bollobás–Morris–Riordan (bootstrap percolation thresholds); the metabolic "scope of a seed"
literature (Ebenhöh/Handorf) is the same operator.

## 7. Reconstruction / moduli (items 10, 18, 23): Mnëv universality is the decisive bound they omitted

Items 18/23 open reconstruction and representation-moduli programs enthusiastically. The decisive fact that
bounds the entire door — and belongs in the nonclaims list — is **Mnëv–Sturmfels universality**: the
realization space of a matroid can be (stable-equivalent to) an arbitrary semialgebraic set. Therefore:

> "Reconstruct the representation from the support port" and "test two deployed codes for equivalence via
> repair queries" are, in general, **as hard as deciding arbitrary semialgebraic sets** (∃ℝ-complete).

This is not a reason to drop the door; it is the sharp statement of *why* the moduli object must be the
foundation (§1) rather than an explicit parametrization, and it tells you the reconstruction program can
only succeed on *structured* port families (bounded connectivity, the harmonic/cubic designs), never in
general. Naming Mnëv converts item 23 from an open-ended wish into a precisely-bounded program — which is
exactly the "decisive negative that kills a tempting route" the lane's search discipline rewards.

Anchor: Mnëv universality; Sturmfels; the ∃ℝ framing (Schaefer).

## 8. C227 log-concavity: a specific import to try before declaring it exploratory

The brainstorm (item 9) and R-notes flag Lorentzian/log-concavity as "exploratory, do not claim." Since
C227 identifies the object as the **Las Vergnas Tutte polynomial of a matroid perspective** `M\x → M/x`,
there is a specific modern import to test rather than leave open: the Adiprasito–Huh–Katz log-concavity of
matroid characteristic polynomials and the Brändén–Huh Lorentzian-polynomial framework have been extended
to **matroid quotients/perspectives** (Eur–Huh–Larson tautological-class program; work on relative/quotient
characteristic polynomials). The concrete task is one page: check whether the pointed perspective polynomial's
relevant specialization sits in the Lorentzian class or is a valuative invariant covered by the tautological
bundle computation. If yes, C227 gets an unconditional coefficient-inequality theorem for free; if no, you
have a sharp counterexample. Either outcome is publishable and neither requires a bespoke Hodge argument.

Anchor: Adiprasito–Huh–Katz (*Hodge theory for combinatorial geometries*); Brändén–Huh (*Lorentzian
polynomials*); Eur–Huh–Larson (tautological classes of matroids).

## 9. Short xrefs on the existing material

Concurrences (no elaboration needed):

- **Concur** with R1 (pointed primal distance = minimal codewords through a coordinate). This is the correct
  spine and §1's foundation view is its moduli completion.
- **Concur** with R4(d)/(e) as unit tests over search, and with R11's char-3-uniqueness observation — it is
  the cross-ratio/`j`-invariant collapse and is exactly right.
- **Concur** with the item-7 critique that C216-as-stated gives O(1) transfer; the real hardness is the
  family-level #P/NP argument, which §2 sharpens further into monotone-span-program size.
- **Concur** with R7's split of item 21 (computable deficit now, inequality later).

Rejections / redirects:

- **Reject** promoting "operational provenance" (Paper S) as a distinct A-target. §4 shows it is weighted
  logic programming over an unusual semiring; the increment is real but it is a B paper, and C239 already
  half-says this. Fold it into the hyperpath/weighted-deduction framing rather than giving it its own flag.
- **Reject** the framing that Paper M "may already be in oriented-matroid theory, audit later." §1: it is in
  *tract* theory specifically (oriented matroids are only the sign-hyperfield slice), and that audit should
  come *before* the oriented-matroid one, not after.
- **Redirect** Paper T away from "sheaf/gain-graph fingerprint" as primary. The gain-graph reading is the
  weak (L1-only) shadow; the strong invariant is the foundation pasture (§1), and its computational barrier
  is Mnëv (§7). Sheaves are a special case, not the home.

## 10. Suggested minimal, bounded actions (user's disposition)

Ordered by grade-lift per unit effort:

1. **One-page foundation audit (§1).** Instantiate Baker–Bowler/foundation on the cubic and harmonic ports;
   confirm the foundation is non-trivial exactly where C217/C237 separate. This is the merge of Papers M and T
   and the highest ceiling in the portfolio.
2. **MSP separation scoping (§2).** Write the port-as-monotone-span-program dictionary and check whether R6/R11
   give a field-sensitivity size separation. If it does, this is the A+ paper and it re-aims the flagship at the
   complexity community.
3. **Cite-and-close on §3, §4, §5** inside Papers P, O, and C235 respectively — each replaces a bespoke
   derivation with a named dichotomy/algorithm/characterization and raises confidence without new proof burden.
4. **Add Mnëv (§7) to the nonclaims/bounds list** and the bootstrap-percolation identity (§6) to the C229
   discovery track.

**Vibe check.** The material is strong and the two prior brainstorms are unusually careful — but they are
mining the applied face of the deposit, where the ore caps at A−. The un-mined face is combinatorics/complexity:
matroids-over-tracts (a rigorous home for the unification the audit only gestured at) and monotone-span-program
field-sensitivity (a route to an unconditional separation with the port families as gadgets). Those two, plus
the four cite-and-close sharpenings, are where I'd bet the A/A+ lives. Everything else the brainstorms found is
real and correctly graded; my disagreement is about *neighborhood*, not quality.

This review allocates no task and changes no gate.
