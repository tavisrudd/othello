# Node-Kayles open-problem targets — cross-domain scout synthesis

**Date:** 2026-07-04
**Scope:** ranked open-problem targets for the Node-Kayles / queens toolkit, synthesized from a
multi-agent literature sweep plus one direct computation. Companion to
[analytic-node-kayles-plan](2026-07-04-analytic-node-kayles-plan.md) (torus / kings / Paley
targets) and [n20-lucky-first-win-plan](2026-07-04-n20-lucky-first-win-plan.md).

**Provenance.** Four domain scouts (stats/probability, analytic combinatorics, discrete solvers,
geometry/number-theory/topology) + a focused novelty-verification agent + a direct 3xN
computation. A second batch of three fresh-field scouts (other graph games, formal
methods/ITP, symbolic dynamics) is in flight — fold results in when they land. All scout
citations are one-pass unless marked otherwise; re-verify anything load-bearing before external
use.

## The toolkit these are ranked against

Symmetry certificates (S1 static closed pairing; S2 adaptive mirror + bounded-exception book);
vertex-transitivity reductions; the Cayley lemmas (abelian order-2 non-generator ⇒ P; odd-abelian
halving-closure ⇒ G=1); character-sum / Weil closure (infinite family ⇒ finite check);
finite-state transfer systems + automatic-sequence decision procedures; twin/module
kernelization; the solver stack (TT alpha-beta, heap-sum nimber engine, df-pn weak solves,
component-decomposition + Sprague-Grundy XOR, machine-checkable certificates).

## Cross-domain ranking

Openness legend: ✅ = verified open (OEIS `more` tag / explicit "left open" in a cited source /
direct check); ⚠️ = inferred open (literature absence, novelty-checked where noted); ~ = partially
scooped.

| # | Target | Open? | Tool | Feasible |
|---|--------------------------------------------------------|-------|------------------------------------|-----------|
| 1 | 3xN strip Node-Kayles (A316632) — periodicity + table | ✅ | transfer-system + component-XOR | High |
| 2 | Generalized-Paley GP(q,k) + Peisert nimber laws | ⚠️ NOVEL-checked | halving→Chebotarev + Weil | High/Med |
| 3 | Toroidal queens + grid-tori game | ⚠️ NOVEL-checked | transitivity + S1/S2 | High/Med |
| 4 | Wider odd strips (w≥5) + "bounded ⇒ periodic" lemma | ✅ | transfer-system | Med |
| 5 | Tree families open in arXiv:2512.24221 | ✅ | kernelization + transfer | High |
| 6 | Node-Kayles automaticity test (A316629 etc.) | ✅ | Walnut / k-kernel | High (expt) |
| 7 | DRAT-for-games certificate standard | ⚠️ premise | S2 rule+exception book | Med |
| 8 | Impartial games on random Cayley / G(n,p) | ~ scooped | transitivity collapses branching | High (expt) |
| 9 | Smith-theory / equivariant formalization of S2 | ✅ novel | independence-complex Z/2-action | Med-Low |
| — | A344227 queens n=17 (committed next step) | ✅ | heap-sum engine | Med |

Plus three from the fresh-field batch (own section below): **normal-play Domination Game** (new
impartial game, only paths/cycles solved — a parallel track to #1), **formalize S1 in Lean**
(prereqs already in `vihdzp/combinatorial-games`), and **a verified certificate checker** (no such
thing exists).

## Direct result banked this session: the 3xN strip (target 1)

A memoized component-canonical solver ([2026-07-04-nk-3xn-probe.py](2026-07-04-nk-3xn-probe.py),
single core, 800 MB cap) was run:

- **Validation.** Reproduced A316632 for n=1..17 exactly:
  `2,1,1,0,3,3,2,2,2,3,3,5,2,4,1,3,2`. Solver is correct.
- **Extension.** Computed **n=18 → G=2, n=19 → G=1** (beyond the ~17 terms the scout read off
  OEIS; treat as new pending a direct OEIS term-count check — one scout got HTTP 403 from
  oeis.org). Full-strip sequence values stay small (≤5, the 5 at n=12).
- **Boundedness probe — the load-bearing finding.** The max Grundy value over *all* fragments
  (ragged sub-strips arising mid-game) grows **monotonically and roughly linearly**: 2,2,3,4,5,5,
  7,7,7,8,9,9,10,12,12,13,14,15,16 through n=1..19 — **no plateau**. So the intermediate
  width-3 fragment nimbers appear **unbounded**, even while the full-strip sequence stays bounded.

**Interpretation — resolved by the symbolic-dynamics scout (exact logic).**

- Ultimately periodic ⇒ finitely many values ⇒ bounded. Contrapositive: the *fragment* nimbers,
  being unbounded, are provably not eventually periodic — but that is one level down and does
  **not** refute periodicity of the full-strip sequence `G(3xN)`, which stays bounded. (`G(n) =
  mex(options)` stays small while option-nimbers blow up; no contradiction.)
- **Bounded is necessary but NOT sufficient for periodicity.** Fox (arXiv:1407.2823, 2014) and
  Larsson–Fox (JIS 18, 2015) exhibit real games with bounded (ternary) but *aperiodic — in fact
  morphic* — Grundy sequences. So "values stay ≤5" gives no periodicity by itself.
- **Transfer-route verdict.** A finite-state transfer *proof* of periodicity needs a finite state
  alphabet. Propagating Grundy values across the strip forces the state to carry the XOR of
  settled disconnected-component nimbers (Node-Kayles composes as disjunctive sums); unbounded
  fragments ⇒ unbounded running-XOR ⇒ **infinite state ⇒ the "finite transfer matrix ⇒ eventually
  periodic" argument does not go through.** The frontier is at best k-regular, and k-regular +
  unbounded ⇒ provably not k-automatic (Allouche–Shallit).
- **What survives.** The transfer system is still the right *compute* engine — the *geometric*
  frontier (width-3 boundary occupancy) is a finite alphabet, fine for generating `G(n)`. It is
  just not a finite-state *proof*. The viable proof route: compute `G(n)` far enough, then test
  whether the bounded output is **k-automatic** (k-kernel finite-closure); if yes, Honkala (1986;
  periodicity of an automatic sequence is decidable, Walnut mechanizes it) DECIDES periodicity —
  proof or refutation, not just more terms.

This also plausibly explains why 3xN resisted the octal-periodicity machinery while 1xN (Dawson's
chess) fell: path fragments have bounded nimbers; width-3 fragments do not.

**Next step (deferred — box busy, no large run without asking):** (1) extend the table to ~150–200
terms via a *geometric-frontier* transfer engine (finite width-3 boundary alphabet — far cheaper
than the current naive component memo, which is what hit the 800 MB cap at n=19); (2) compute the
k-kernel `{G(k^i·n + j)}` for k=2..6 and test finite closure; (3) if it closes, build the DFAO and
run Walnut's periodicity decision. A positive result would also be the **first Walnut application
to a Grundy (nimber) sequence** — Mignoty–Renard–Rigo (Int. J. Game Theory 54:35, 2025) applied it
only to P-positions / Wythoff.

**UPDATE 2026-07-04 (go-deep run — extended to n=22):**
- Sequence n=1..22 = `2,1,1,0,3,3,2,2,2,3,3,5,2,4,1,3,2,2,1,1,5,0`. **Five new terms** beyond OEIS's
  17 (a(20)=1, a(21)=5, a(22)=0; a(18)=2/a(19)=1 reproduced independently). Running max = **5**,
  first at n=12, **recurs at n=21 — the extreme value recurs, it does not escalate**; value set
  exactly {0..5}, tail oscillates with no upward trend.
- **Read: BOUNDED / eventually-periodic is strongly FAVORED but unproven — G(3×n) stays open.** Two
  reasons the data can't yet decide, both pointing favorable: (1) the width-1 analog (paths =
  Dawson's chess) has **preperiod 51**, so n≤22 is entirely inside a plausible long preperiod — the
  absence of a short period is EXPECTED, not evidence against; (2) the earlier "fragments are
  unbounded" flag is a **RED HERRING for the clean diagonal** — unbounded nimbers live in
  holey/capped sub-fragments (max fragment nimber climbs ~0.79/column to 18), but the clean
  full-column strip G(3×n) is one specific structured fragment whose value stays ≤5; unbounded
  sub-fragments do NOT force the diagonal to grow. This improves the boundedness outlook vs the
  first probe's framing.
- **Correction to "the geometric frontier is a finite compute engine":** a *purely geometric*
  8-state column-frontier is INSUFFICIENT for exact nimbers — capped-strip fragments have unbounded
  nimbers, so infinitely many left-contexts are inequivalent; an exact transfer must carry unbounded
  partial-Grundy structure per geometric state. The correct object is the **boundary-EQUIVALENCE
  automaton** (Myhill–Nerode: "same whole-strip nimber for every right-completion"); whether the
  clean-diagonal trajectory **closes finitely** IS exactly the open boundedness/periodicity question
  (finite closure ⟹ eventually periodic ⟹ bounded). Building it correctly is multi-session, not a
  quick script.
- **Engine ceiling (hard):** the compact bitmask fragment-memo reached n=22 (447s, 1.30M memo,
  ~0.3 GB) but distinct fragments grow **×1.838/column** (converged) ⇒ ~7.5×10¹⁰ entries at n=40 —
  impossible in any RAM. **No fragment-memo, any language, reaches n≥40.** Further extension /
  periodicity decision needs the boundary-equivalence automaton, not a bigger memo. Engine copied to
  `2026-07-04-nk3-engine.py`.
- k-kernel automaticity test: INCONCLUSIVE at 22 terms (data-starved — needs hundreds of terms);
  flagged untestable-here, not a negative.

## Novelty-check verdicts (verification agent)

Ran specifically to protect against claiming scooped territory as novel:

- **Item 1 — arithmetic Cayley graphs (Paley / GP(q,k) / Peisert / QR-circulant): VERIFIED-NOVEL,
  the SAFEST claim.** No prior work poses the impartial-game question on these graphs; the
  Node-Kayles census (Brown et al. 2020; Songsuwan et al. 2025) lists studied families and
  includes no Cayley/Paley/circulant graph. The one applicable tool (an involution ⇒ nimber-0
  argument) is standard but *nobody applies it to these graphs*. ⇒ our Paley conjecture is not
  scooped, and GP(q,k)/Peisert (target 2) are untouched.
- **Item 2 — toroidal queens game / torus grid Node-Kayles: VERIFIED-NOVEL.** The torus appears
  only for the placement/counting problem (Pólya); the last-player-wins game is untouched. Nearest
  miss is Domineering on tori/cylinders (partisan, different game). ⇒ target 3 and analytic-note
  target 1 are genuinely open.
- **Item 3 — Node-Kayles on random graphs: PARTIALLY SCOOPED, the RISKIEST claim.** Adams et al.,
  "Combinatorial Analysis of a Subtraction Game on Graphs" (Int. J. Combinatorics 2016;
  arXiv:1507.05673), §6 runs the exact outcome/threshold-on-G(n,p) program — but for the game
  "Grim" (delete v + newly-isolated vertices), NOT Node-Kayles (delete N[v]). Porting to
  Node-Kayles is "a short, obvious step." ⇒ target 8 downgraded to incremental (port an existing
  method), not a new lane. (False friend to avoid: "Grundy number of random graphs" = greedy
  coloring, not the game nimber.)

## Reading of the whole sweep

Most of the top tier **sharpens targets already in the analytic note** rather than replacing
them: the strip work is L8/target-4 made concrete (now with a validated solver and the
boundedness finding); toroidal queens is target 1, cross-validated by three independent scouts and
handed a free warm-up (grid tori `C_m □ C_n` with even `m` are P by antipodal pairing — a clean
immediate theorem from the analytic-combinatorics scout's derivation); GP(q,k)/Peisert is
Paley-plan step 5, elevated and novelty-confirmed.

**Genuinely new** (not previously in our notes): the grid-tori even-m theorem; the specific open
tree families (caterpillars/spiders/subdivided stars, arXiv:2512.24221 explicit); the
automaticity/Walnut angle on Node-Kayles sequences; and the DRAT-for-games certificate framing.

**Convergence signal:** the arithmetic-Cayley cluster (targets 2-3) was independently top-ranked
by both the stats scout and the geometry/NT scout; the strip cluster (targets 1,4) by both the
analytic-combinatorics and discrete-solvers scouts. Cross-scout agreement is why these sit at the
top.

## Second scout batch — fresh fields

Three further scouts (other graph games, formal methods / ITP, symbolic dynamics) explored fields
the first batch did not touch.

**New target — normal-play (last-player-wins) Domination Game (impartial).** Move = pick a vertex
that newly dominates ≥1 previously-undominated vertex; last to move wins. Introduced only Feb 2025
(arXiv:2502.13118), which solves *only* `P_n` (Alice wins iff n≢0 mod 4) and `C_n` (iff n≡3 mod 4)
and proves it PSPACE-complete at diameter 2 — so grids, tori, hypercubes, circulants, and **queen
graphs** are all open. It is impartial and our whole stack ports nearly verbatim: a small move-rule
change on the existing engine, component decomposition ⇒ Grundy XOR, S1/S2 certificates on
symmetric boards, the Cayley lemmas on circulants/tori. **High** feasibility; afternoon experiment
= nimbers of 2×n / 3×n strips + small tori, check OEIS + periodicity. NOTE: the domination-game
*3/5 conjecture* (Kinnersley–West–Zamani) was already PROVED (Versteegen 2024, arXiv:2212.04527) —
the live target is this impartial normal-play cousin, not the scoring original. (Cops & robbers /
Meyniel, graph burning, chip-firing were all triaged as WEAK fits — partisan or one-player, our
Sprague-Grundy tools don't bite.)

**Formalization is reachable — CGT already has Lean scaffolding.** CGT was pulled out of mathlib
core; active development is `vihdzp/combinatorial-games` (Violeta Hernández), which already has the
Sprague-Grundy theorem (`nim_grundy_equiv`), `grundy`, `grundy_add`, `grundy_eq_zero_iff`
(P ⟺ grundy 0), a general `GameGraph` framework, and specific games (Nim, Domineering, Poset).
ABSENT: misère, any pairing/involution/twin lemma, Node-Kayles / queens. Two targets:

- **Formalize S1** (fixed-point-free non-adjacent involution ⇒ grundy 0 — the Tweedledum–Tweedledee
  mirror) as a reusable lemma: small (one mirror-strategy induction), all prerequisites present,
  novel in the repo, and the reusable core a certificate checker and any queens verdict both call.
  **High.**
- **A verified rule+exception certificate checker** (a DRAT/QRAT-for-games *inside* the prover,
  generic over `GameGraph`): no verified game-solution checker exists anywhere (searched negative).
  Realizes the S2 / machine-checkable-certificate idea with machine-checked soundness. **Med**, and
  the most original.

**Symbolic dynamics — the transfer-route logic (folded into the 3xN section above).** Upshot: the
viable periodicity proof is automaticity-testing the bounded output `G(n)` + Honkala/Walnut, not a
nimber-keyed transfer matrix; a positive result would be the first Walnut application to a Grundy
sequence.

Fresh-batch caveats (scout self-flags): the exact PR/date CGT left mathlib core is unconfirmed
(some stale doc pages); "no verified game checker exists" and "no prior Walnut-on-a-Grundy-sequence"
are searched negatives; A316632's current OEIS term count is still unconfirmed (403s); the
Larsson–Fox morphism's uniformity (⇒ automatic vs morphic-not-automatic) is unverified; the
graph-games scout's Guy-conjecture citation was from memory and its Wong-2020 per-family open list
needs the PDF.

## Third scout batch — lemmas/tactics, geometry, optimization

**★ Node-Kayles on trees — the strongest new target (lemmas/tactics scout).** Determining the
complexity of the Node-Kayles outcome / Grundy value on **trees** is a named, decades-open problem
(Bodlaender–Kratsch, "still open even restricted to trees," arXiv:2003.11775; the Dec-2025 trees
paper solves only regular + two-level trees). **L3 false-twin parity compression is the exact
missing tool** — sibling leaves are false twins, so L3 collapses each leaf-bundle by parity;
true-twin deletion + L8 handle caterpillars/spiders (a width-1 strip after leaf compression).
High feasibility, same-day experiment (nimbers of spiders/caterpillars by L3 collapse vs brute
force, then a poly-time attempt on caterpillars). Arguably the single cleanest target on the whole
list: verified-open, named, and our lemma is precisely the piece that's missing.

**Parameterized complexity by clique-width / treewidth (lemmas/tactics).** FPT is known only for
vertex-cover, modular-width, and neighborhood diversity; treewidth and clique-width are open
(arXiv:2003.11775). The Grundy-Coloring analogue is W[1]-hard by treewidth — so either a hardness
reduction *or* an algorithm is publishable. Our true-twin / L3 / L9 lemmas ARE the
modular-decomposition DP the modular-width result uses; the smallest open rung is distance-hereditary
/ P4-sparse graphs (clique-width ≤3, just above the poly cographs). Med.

**Split / threshold / chordal closed forms + colored (partisan) Node-Kayles (lemmas/tactics).**
L4 + L6 clique-cover + true-twin may give a closed form on split/threshold; chordal is reportedly
open. Colored (partisan) Node-Kayles is very recent (Hanaka–Ono–Yoshiwatari, PRIMA 2025) with few
results — true-twin + L7/S2 are transfer candidates. Both Med.

**Arithmetic-Cayley cluster, now from the independence-number side (optimization scout).** The
vertex-transitive SDP / exact-subgraph hierarchy for α of generalized-Paley / Peisert / QR-circulant
graphs is open (arXiv:2412.12958; Randomstrasse101 problems 25–29), and vertex-transitivity +
character/Weil sums are the *published critical lever* (orbit-decompose the SDP under Aut(G);
character sums bound the off-diagonal eigenvalues). θ(Paley_q)=√q is tight only for square q;
odd-order gaps are the open instances; laptop-scale SDP. **This is a third independent endorsement
of the arithmetic-Cayley cluster** — after the game-value angle (stats + NT scouts), now from
independence-number / theta. (Verify the specific open orders 53,61,73,89,97,109 against the PDF
before quoting — flagged as a possible small-model hallucination.)

**Convergent conclusion on the S1-pairing-as-dual idea.** Both the geometry and optimization scouts
independently surfaced the same idea — an S1 pairing is a perfect matching, so it should dualize to
a fractional-vertex-cover / theta / SoS certificate hierarchy for P-positions — and both reached
the same verdict: there is **no citable open problem** to attach it to; it is a research program we
would *define* (high value as an original contribution, not a known gap). Pursue it as our own
framing.

**Geometry standout: the general-position achievement game (geometry scout).** A named open
impartial game (Klavžar–Neethu–Chandran, arXiv:2111.07425; survey arXiv:2501.19385 lists the grid
formulas open) that runs on our engine unchanged — only the legal-move predicate differs from
Node-Kayles. High feasibility. Also verified this batch: the Ellmann no-three-in-line constant
π/√3 ≈ 1.814 (Voutier arXiv:2603.00215, fetched) — supersedes Guy–Kelly's 1.874.

Batch-3 caveats: several lemmas/tactics citations (chordal-open, fixed-width-periodicity phrasing)
are from search summaries with unparseable PDFs; the open Paley orders in the optimization item may
be hallucinated. Re-verify before any writeup.

## Fourth scout batch — misère, poset games, group/additive games

**Misère play — a continuation of existing project work, not greenfield.** The scout (repo access)
reports the project already began this in the 2026-07-03 theory notes: a misère-queens sequence to
n≤8 (0,0,2,0,3,0,2,3), a proven "Misère Well-Covered Parity Law" (G⁻ = (m+1) mod 2 for well-covered
graphs), a `misere_small.py`, and an analysis that the naive mirror fails under misère. (NOT
re-verified this session — relayed from the scout's reading; the committed "bank the 2026-07-03
theory-agent reports" history supports their existence.) Best target: **classify the queen-graph
misère quotient tame/wild** by feeding misère-solver output to Siegel's MisereSolver, with
**extend the misère-queens sequence to n≤12** (OEIS companion to A344227) falling out of the same
run. **Hard constraint:** misère has no disjunctive-sum additivity, so the XOR/heap-sum
decomposition that powered the A344227 engine DIES — the misère solver is whole-DAG, ceiling
~n=11–13. Higher-ceiling item: whether an S1 pairing certifies a misère outcome (the mirror hands
the last move to the responder ⇒ should flip normal-play P into misère N, given an endgame-parity
lemma — the piece our own notes flagged unproven). Verified open: misère Node-Kayles is open even
on paths (Guignard–Sopena, arXiv:0806.3033); "wild" is *belief*, not a published proof. AVOID
Dawson's-chess misère ($500 Plambeck prize) — heap game, XOR breaks, poor fit.

**Poset games / Chomp — one honest wall, one convergent target.** WALL (verified): finding the
winning move in the Chomp family is PSPACE-hard (Bodwin–Grossman, "Strategy-Stealing is
Non-Constructive," arXiv:1911.06907) — so S2 provably cannot yield a general explicit Chomp
strategy; it bites only on symmetric sub-families. CONVERGENT TARGET: the Lean repo `Poset.lean`
already has the non-constructive `univ_fuzzy_zero` (top-element poset game ⇒ first-player win by
strategy-stealing, Chomp the motivating case) but **no explicit strategy**; the square-(n×n)-Chomp
win (open (2,2) → L-shape, mirror across the diagonal) is textbook-but-unformalized and an exact
S1/S2 instance — so "formalize S1 in Lean" and "machine-check square-Chomp" are the SAME
contribution. Real open complexity gap: **2-level poset games** (Fenner–Gurjar–Korwar, ECCC
TR13-019; parity-uniform in P, general open) — our kernelization + orbit-mex could extend the poly
class. (Deuber–Thomassé N-free citation unverified.)

**Group / additive games — the generating game is solved, the sum-free game is the fresh air.**
NEGATIVE (verified): the Anderson–Harary generating game (GEN/DNG) is impartial but its *arithmetic*
families are already fully solved (Benesh–Ernst–Sieben, arXiv:1407.0784 §8: complete nim-numbers for
cyclic/dihedral/abelian) — character-sum tools find no fresh air there. FRESH: the **impartial
sum-free game = Node-Kayles on the Cayley SUM graph** of Z_n / F_p^n (add elements keeping the set
sum-free; independent sets of the sum graph = sum-free sets). Fully impartial, the whole queens
toolkit transfers, and the natural symmetry x↦c−x is a character-sum/Weil object — the **direct
additive-combinatorics twin of the Paley program** (a fourth independent hit on the arithmetic-Cayley
cluster). HIGH feasibility (near-drop-in circulant solver), with a Weil "for all large order, player
X wins" theorem as the payoff. **NOVELTY DEBT:** no prior "sum-free game" surfaced, but a Vienna
thesis titled "Combinatorial Games on Cayley Graphs" was behind a bot-wall and may already cover it
— retrieve before staking novelty. Also High/enumeration: the parity of the number of maximal
sum-free sets of Z_n (our flagged unasked statistic; count known asymptotically mod 4, exact parity
uncomputed).

**CORRECTION + CLEARANCE (2026-07-04, web sub).** (1) Novelty debt CLEARED — the Vienna thesis is
relator/pursuit games, not this (see debts). (2) The claim "independent sets of the Cayley sum graph
= sum-free sets" is IMPRECISE: independent sets of Cay⁺(Z_n,S) = *S*-sum-free sets ((I+I)∩S=∅),
whereas classical sum-free is the self-referential (A+A)∩A=∅. **So there are TWO distinct games:**
(a) GRAPH Node-Kayles on Cay⁺(Z_n,S) — reuses our engine, and **Paley_p = Cay⁺(Z_p, QR)** is a
special case; (b) the classical-sum-free **Schur hypergraph game** (build a set with no x+y=z) — a
*different* subset-state solver, NOT any fixed Cay⁺ Node-Kayles. The additive-combinatorics / cap-set
spirit lives in (b); cheap engine-reuse lives in (a).

**★ DECISION (2026-07-04): game (a) — GRAPH Node-Kayles on Cay⁺(Z_n, S) — is QUEUED FOR THE NEXT
SESSION.** Reuse the validated `arith_cayley.py` engine (banked as `2026-07-04-arith-cayley.py`; Paley = Cay⁺(Z_p, QR) is the anchor); sweep
symmetric connection-set families (intervals, QR, {±1..±k}, random symmetric S) and look for a
structural outcome law (when does the residual-pairing / a halving-type condition fire?). Game (b),
the classical Schur sum-free game, is parked for a dedicated session (new subset-state solver, more
memory) — do NOT start it on the busy box.

Pairing precision: x↦c−x is an automorphism of Cay⁺(Z_n,S) iff 2c−S=S, and certifies a *residual*
P-position only when fixed-point-free and N[v]∩N[σv]=∅ — for dense diameter-2 graphs (Paley) the
full-graph mirror fails (Paley is N, G=1); the pairing that gives G=1 acts on the *child/residual*,
not the root.

## Recommended order

1. **Target 1 (3xN strip)** — now the cleanest quick-ish target: verified-open, runs on tools we
   have, with the automaticity route (compute far, then k-kernel + Walnut) as the proof path.
   **[UPDATE 2026-07-04:] Trees is NO LONGER the top quick win.** The deep-dive
   ([nk-trees-deep-dive](2026-07-04-nk-trees-deep-dive.md)) validated L3 (2807 tests, 0 failures)
   but found caterpillar/spider nimbers AND the tree-DP sufficient statistic UNBOUNDED
   (context-classes ~2^(s−2)) — so the bounded-state-DP route to poly-time is CLOSED; trees stays
   genuinely open and now points toward a *hardness* result, not a quick win. Salvage: the comb
   (`s mod 2`) and double-comb (period-4) closed forms + validated L3 are small standalone results.
2. **Target 2 (GP(q,k)/Peisert)** — the better *paper* (cross-disciplinary, extends the Paley
   story) and now novelty-confirmed as the safest claim. The compute sweep is small; the Weil
   closure reuses the Paley pipeline.
3. **Target 3 (grid tori first, then toroidal queens)** — bank the free even-m grid-tori theorem,
   then attack the odd case and the queen torus (where the naive pairing fails — S2 territory).

Deprioritize target 8 (partially scooped) unless the Node-Kayles port turns up something the Grim
analysis missed.

**Two strong additions from the fresh-field batch:**

- The **normal-play Domination Game** is the best *new* problem surfaced — impartial, brand-new
  (only paths/cycles solved), immediately runnable on the existing engine with a small move-rule
  change. A parallel track to target 1, not a replacement: same tools, different game, wide-open
  structured boards.
- **Formalizing S1 in Lean** (`vihdzp/combinatorial-games`) is the lowest-effort durable
  contribution on the whole list — small, novel, prerequisites present — and it seeds the
  verified-certificate project that realizes our entire S2 theme.

## Open verification debts

- Direct OEIS check of A316632's current term count (confirm n=18,19 are new).
- The scout citations for targets 5-9 are one-pass; re-verify before any writeup.
- The "grid tori even-m ⇒ P" derivation is the analytic-combinatorics scout's own (sound on its
  face — antipodal shift is a fixed-point-free non-adjacent involution for even m≥4, verified this
  session; m=2 excluded).
- **Vienna thesis — CLEARED 2026-07-04.** Birschitzky, "Combinatorial Games on Cayley Graphs"
  (Univ. Wien 2025, supv. Cashen) is about relator games (REL/RAV) + cops-and-robbers on Coxeter
  groups — NOT Node-Kayles, NOT Paley/circulant, NOT sum-free. Does not scoop the Paley conjecture
  or the sum-free game. Wider check: no published Node-Kayles/Grundy on Paley or circulant graphs;
  closest is Sieben, "Impartial Hypergraph Games" (EJC 30(2) 2023, #P2.13), a general framework
  that does not instantiate sum-free. ⇒ both appear unpublished / novel. (Thesis full text
  UNVERIFIED — bot-walled; from metadata + supervisor profile.)
- Misère 2026-07-03 note contents (the n≤8 sequence, the Well-Covered Parity Law) not re-verified
  this session — read the notes directly before building on them.
- Deuber–Thomassé N-free poset-game citation unverified; the open Paley SDP orders (53,61,…) may be
  a small-model hallucination.

## Master synthesis (all four batches)

Thirteen fields scouted across four batches. The map is essentially drawn — marginal domains are now
thematic. The durable output is this ranked target set plus the list of honest walls that save
wasted effort.

**Top targets** (verified-open or novelty-checked; our exact tools; afternoon-to-paper sized):

1. **Node-Kayles on trees** — named, decades-open (Bodlaender–Kratsch); L3 false-twin compression is
   the exact missing tool; a spider/caterpillar sweep is a same-day experiment. *Cleanest on the
   list.*
2. **3xN strip periodicity** — verified open (A316632); the boundedness finding routes it to the
   automaticity proof (k-kernel + Walnut), not a nimber transfer matrix.
3. **GP(q,k) / Peisert nimber laws** — novelty-verified; **four independent scout endorsements**
   (game-value, theta/independence-number SDP, sum-free game, our own Paley conjecture) make the
   arithmetic-Cayley cluster the strongest recurring theme and the most cross-disciplinary payoff.
4. **New impartial games our engine ports to unchanged:** normal-play Domination Game (only
   paths/cycles solved), general-position achievement game (named open), impartial sum-free game on
   Cayley sum graphs (Paley twin — pending the Vienna-thesis check).
5. **Formalize S1 in Lean = machine-check square-Chomp** (one contribution, two batches converged;
   prerequisites present in `vihdzp/combinatorial-games`) → seeds a **verified certificate checker**
   (none exists in any prover).
6. **Parameterized complexity of Node-Kayles** by clique-width/treewidth (open; our kernelization is
   the machinery; distance-hereditary / P4-sparse is the smallest open rung) and **2-level poset
   game complexity** (open P-vs-PSPACE gap).
7. **Continuations of existing work:** misère queens quotient tame/wild + extend the misère sequence
   (n≈11–13 ceiling, XOR breaks); A344227 queens n=17 (committed).

**Honest walls / scope boundaries (do NOT chase):**

- General Chomp winning-move: PSPACE-hard (Bodwin–Grossman) — S2 cannot crack it.
- Group-generation games: arithmetic families already fully solved (Benesh–Ernst–Sieben).
- Node-Kayles on random graphs: partially scooped by the Grim-game threshold work.
- S1-as-SDP-hierarchy: no citable open problem — a program we would define, not a known gap (two
  scouts concurred).
- Cops & robbers / graph burning / chip-firing: partisan or one-player, our SG tools don't bite.
- Dawson's-chess misère: heap game, XOR breaks — poor fit despite the $500 prize.

**Recommendation — pivot to depth.** Marginal search value is low; the highest-EV move is executing
Tier-1. Two cleanest first experiments, both afternoon-sized on tools we have: (a) the
spider/caterpillar nimber sweep (trees, via L3 collapse); (b) the sum-free-game nimber sweep on Z_n
(after the Vienna-thesis check). The arithmetic-Cayley cluster (target 3) is the best *paper*; trees
(target 1) is the best *quick win*.

## What the wins unlock (consequence maps)

Three consequence-mapping scouts traced what our likeliest wins unlock downstream. The dominant
finding is a **unifying gate**: nearly every biggest-prize downstream depends on the *same*
boundedness property, wearing three faces.

**★ The unifying gate — boundedness.**
- **Weil/arithmetic map:** the capstone meta-theorem — "a character-controlled Cayley graph ⇒ the
  Node-Kayles outcome is FO-definable and finite-check-decidable" (the first Weil ↔ Sprague-Grundy
  bridge, genuinely new — Courcelle/Seese cover graph *properties*, never game outcomes) — gates on
  bounded certificate **depth**.
- **Certificate map:** S2 scaling to flat queens n=20/22/24 gates on bounded exception-**book** size.
- **Periodicity map:** the strip-periodicity / Walnut unlocks gate on bounded Grundy **values**
  `G(3×n)` (Wong et al. JIS 23 list unboundedness as OPEN for these deletion games; our probe has
  G≤5 through n=19, but that is data, not proof — and a k-regular sequence is k-automatic *iff* it
  is finitely-valued, Allouche–Shallit, so unboundedness would sink the Walnut route).

⇒ The three highest-leverage **experiments** are therefore the three boundedness measurements:
(i) the n=18 exception-book size; (ii) whether `G(3×n)` stays bounded (extend the strip);
(iii) whether caterpillar/spider nimbers stay bounded (trees deep-work).

**RESULT (2026-07-04): measurement (iii) is IN and it FAILED** — caterpillar/spider nimbers *and*
the tree-DP sufficient statistic are UNBOUNDED ([nk-trees-deep-dive](2026-07-04-nk-trees-deep-dive.md)).
The first boundedness face measured came back unbounded, raising the prior that the gate fails in
general. Nuance that keeps (ii) alive: each *fixed 1-parameter* caterpillar family (path, comb,
double-comb) was bounded/periodic — the unboundedness is a 2-D phenomenon over the whole decoration
family. `G(3×n)` is a single 1-parameter sequence, so it can still be bounded (data: ≤5 through
n=19). So (i) the n=18 book and (ii) the single-parameter `G(3×n)` are now the two measurements that
decide whether the expensive prizes survive.

**RESULT (ii), 2026-07-04 (go-deep):** `G(3×n)` extended to n=22 (max=5, recurs at n=21, no
escalation) — **bounded/eventually-periodic FAVORED but unproven**; the earlier unbounded-fragment
flag is a red herring for the clean diagonal (fragments ≠ diagonal). **So the two measured faces
SPLIT: trees UNBOUNDED (bounded-DP route closed there), but the 3×N clean diagonal leans BOUNDED —
the strip-periodicity cone survives.** It is gated on the boundary-equivalence automaton closing
finitely (multi-session build; its finiteness *is* the open question), and the fragment-memo route
hard-caps at n<40 (×1.838/column). Only (i), the n=18 exception-book size, remains unmeasured
(blocked — big-box campaign).

**Solid dominoes (Full / Partial-Full de-risk):**
- **Arithmetic-Cayley OUTCOME family** — GP(q,k), Peisert, sum-free/cap-set games: the
  character-condition certificate is degree-agnostic (χ₂→χ_k preserves every step), the "good class"
  is a Chebotarev density in Q(ζ_k, 2^{1/k}). Concrete next dominoes: Peisert p≡3 mod 4 (first
  non-negation involution), the F₃ⁿ cap-set game, and submit G(Paley_p)=1 (p>37, exc {5,29,37}) to
  OEIS as a *proven* entry.
  - **COMPUTED 2026-07-04 (partial confirm + partial refute — see analytic note).** The
    *sufficient* half is confirmed and essentially a lemma: "2 is a k-th power residue ⟹ G=1" holds
    with zero clean-side exceptions for k=2,3,4 and Peisert (the x↦−x pairing). **Peisert is a clean
    theorem: G=1 for all valid q, no exceptions** (dlog(2)≡0 mod 4 forced). BUT the *full Paley
    finite-exception characterization does NOT generalize past k=2* — the k=3 bad side (2 not a cubic
    residue) is G=0 at ~50% density with no governing power-residue law. So this domino is Full
    de-risk for the sufficient direction + Peisert, and a **false unlock** for the complete
    "value = arithmetic invariant with finite exceptions" story at k≥3.
- **Certificate zoo** — S1-as-Lean-lemma turns "solve a symmetric impartial game" into a one-file
  typecheck (torus queens, even kings, domination game on symmetric boards). The biggest single
  unlock of the certificate map.
- **The genuine COMBINE** — W1+W2 close caterpillars: a leaf-compressed caterpillar *is* a labelled
  width-1 strip, so the kernelization OUTPUT is the automaticity INPUT. The trees deep-work run is
  executing exactly this path.
- **Walnut-decides-a-Grundy-sequence** as a standard CGT tool — first-of-kind beyond Wythoff
  P-positions (Mignoty–Renard–Rigo–Whiteland, IJGT 2025).

**High-reach / weak de-risk (all gated on the boundedness question above):** the Weil↔Sprague-Grundy
meta-theorem; S2 queens-scaling to n=20+; the fixed-width ladder 5×n/7×n + cylinders (per-width
boundedness, alphabet ~exp in width).

**Verified checker + n=18:** the checker is a new artifact class (the Empty-Hexagon SAT→LRAT→verified
cake_lpr pattern), but verifying our own n=18 is **not free** — the αβ search emits no proof object,
so it needs a separate certificate-extraction pipeline (a df-pn proof DAG) feeding the checker.

**Walls, now sharply pinned (do NOT chase):**
- Complexity: the clique-width **join** (no geometric interface; Grundy-under-join is unbounded-state)
  — distance-hereditary pendant/twin generators are reachable, the join is the wall.
- Periodicity: tori `C_m □ C_n` (two-way boundary breaks the one-directional transfer); Guy's octal
  conjecture (general octals have no finite geometric frontier).
- Optimization: **α / Lovász-θ is a FALSE unlock** — an S1 pairing is a matching in the *complement*,
  orthogonal to α (an independent set is a clique in the complement); no two-way street. Corrects the
  geometry/optimization scouts' earlier hope of an S1→θ bridge.
- Certificate: general (non-square) Chomp and arbitrary/odd boards — no global involution exists, the
  problem is PSPACE-complete, certificates stay exponential.

**False unlocks caught** (look enabled, aren't): α/θ from pairing (orthogonal); Walnut on the
arithmetic families (prime-indexed → Weil, not automata; Walnut is only for the strips); exact
nimbers >1 for deep positions (the engine gives outcome ∈{0,1} only — G>1 residuals like torus n=10
break the bounded-signature vocabulary); n=18 "verified for free"; the tree result cracking
bounded-clique-width.

**Load-bearing lowest-confidence item:** whether `G(3×n)` is actually bounded (Wong et al. leave it
open). It is the linchpin of the entire periodicity cone; it is *one* face of the unifying gate; and
it is cheap to probe further — which is why the boundedness measurements are the recommended next
work.
