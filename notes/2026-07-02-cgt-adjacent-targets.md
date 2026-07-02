# CGT-adjacent targets survey — where this project's machinery has unusual leverage (2026-07-02)

**Scope**: THEORY/SURVEY session, web research only (no builds, no runs — a 17 GB solve owns
the box). Question: after G(17)/G(18) land, which OTHER games with open problems can this
project attack from a position of strength?

**Claim tags** (every factual claim carries one):
- **[web-verified]** — checked today against the cited source (OEIS JSON API, arXiv, Wikipedia,
  publisher/author pages).
- **[recalled-unverified]** — from background knowledge or a search-result summary I could not
  open; treat as needing a check before load-bearing use.
- **[computed-here]** — Fermi estimate made in this session from our own anchors
  (n=16 ≈ 13 s search; n=18 ≈ days-scale; heap-sum nimber engine; 26 GB box).

**Our assets, one line each** (calibration from the repo notes): a general Node-Kayles
solver (the "attack relation" is just a graph adjacency — flat lockless TT, D4+iso
canonicalisation, complete boolean AND Grundy tables for all labelled graphs on ≤8 vertices,
nested dense evaluators far past that, dynamic ordering, cross-root killers); a validated
heap-sum nimber engine (`G(board)=k` ⟺ board+heap(k) is P); the Master-Lemma /
mirror-pairing theory toolkit (bishops/knights/torus already fall — implications note §3);
a Lean 4 verification pipeline; an OEIS/arXiv track record (A344227 extended, n=18 solved).

---

## Side-finding first (paper-relevant): the vertex-transitivity lemma is already published

Our implications note §3.2 flagged "Node-Kayles on any vertex-transitive graph has
G ∈ {0,1}; likely known — check". **Confirmed known [web-verified]**: the A344227 OEIS entry
itself contains this exact statement and proof in its comment block (fetched via the OEIS
JSON API today). Cite the OEIS entry for it in the paper; do not claim novelty. The
*per-n torus outcome values* remain uncomputed anywhere I could find (§C4 below).

---

## Candidate 1 — Node-Kayles on lattice/grid strips: extend A316632 (3×n), settle its regularity

**(a) Open problem + provenance.** A316632 = Sprague-Grundy values of Node-Kayles on the
3×n lattice graph — few terms (data ends at n=16), keyword `more`, no pattern found
**[web-verified, OEIS JSON]**. Context rows are solved: 1×n = Dawson's chess (A002187),
2×n = period 2, 4×n = identically 0 **[web-verified, A316632 comments]**. Source paper:
Brown–Daugherty–Fiorini–Maldonado–Rainville–Waechter–Wong, *Nimber Sequences of Node-Kayles
Games*, J. Integer Sequences 23 (2020) **[web-verified, JIS/NSF-PAR]**. The same cluster has
A316533 (generalized Petersen P(n,2), value ≤ 2, terms end at n=23, keyword `more`)
**[web-verified]**. A Dec-2025 arXiv paper (Node-Kayles on trees, 2512.24221) shows this
exact genre — "extend the catalog of Node-Kayles families with known Grundy behavior" — is
an active publication line **[web-verified, abstract + HTML]**.

**(b) Leverage.** This is literally our game on a different graph — zero rules work. The
real leverage is *structural*: a 3×n strip DISCONNECTS after a few moves, and disjoint
components sum by Sprague-Grundy XOR. Components of a damaged strip are themselves 3×k
strips with O(1) end-damage patterns, so beyond raw TT muscle there is a bespoke
interval-DP that should reach n in the hundreds-to-thousands and directly test eventual
periodicity (Dawson-style sparse-space methods apply) **[computed-here]**. Our GrundyW8
tables evaluate every ≤8-vertex component instantly; the parked `queens-component-nimber`
branch is exactly the component-XOR substrate this needs (its queens-negative — tail graphs
are 97–100% single-component — INVERTS here: strips shatter constantly).

**(c) Effort.** Engine port: small (adjacency swap) for a brute extension of a few terms;
medium (1–3 sessions) for the component-XOR + end-pattern DP that makes periodicity hunting
possible. Compute: trivial next terms; the interesting regime (n ≫ 100 + period search) is
minutes-to-hours, nothing like n=18 **[computed-here]**.

**(d) Interest.** OEIS b-file extension + a JIS-style note ("Grundy values of Node-Kayles
on 3×n and 5×n lattices; period found / no period through N"). The 1/2/4-row rows being
regular while 3×n is not is a clean hook. Finding a period would settle the family; 5×n
would be a new sequence we define.

**(e) Risk.** Low already-solved risk (keyword `more` as of today; the Dec-2025 trees paper
lists lattices as "studied", citing only the 2020 data **[web-verified]**). Scoop risk
moderate — REU-style groups work this genre. Intractability risk low: worst case we still
ship several new terms.

---

## Candidate 2 — Sibling-piece placement games: define + compute the missing nimber sequences (kings, knights-odd, bishops-odd, rectangle queens)

**(a) Open problem + provenance.** OEIS has NO Node-Kayles/placement-game nimber sequence
for kings, knights, bishops, or rooks **[web-verified: OEIS searches for
"non-attacking"+game, "king graph"+game, knight+node-kayles all return nothing relevant]**;
literature searches for a "non-attacking kings game" likewise return nothing
**[web-verified searches; absence is inherently a weaker claim]**. A344227's xrefs point
only to counting sequences (A036464 etc.), not game values **[web-verified]**. So the whole
sibling-piece table is open in the strongest sense: the sequences do not yet exist.

**(b) Leverage.** Highest theory-compute synergy on this list. The Master Lemma already
gives (implications note §3, PROVEN there): knights even-n G=0 (complete), bishops even-n
G=0 (complete), rooks solved, kings even-n reduced to an O(1) exceptional set, odd-n G ≥ 1
for every ray piece. What remains is exactly what our heap-sum engine computes: the exact
G values on the open side (kings all n; knights odd n; bishops odd n — note bishops
decompose into two color components, so G = g_black ⊕ g_white and the components are
smaller). Engine port: swap the attack-mask generator (a geometry function), keep
everything else — TT, canon, dense tables, heap-sum driver.

**(c) Effort.** Port: days (geometry + D4 canon already generalizes; validation = full-mex
agreement on small n, which the pipeline already automates). Compute scaling is the
unknown: kings/knights games last Θ(n²) plies vs queens' ≤ n, so state spaces blow up much
earlier — expect exact G for kings to maybe n ≈ 8–10 and knights odd-n to n ≈ 7–9 before
n=16-queens-scale cost, with real uncertainty either way **[computed-here, low
confidence]**. Bishops ride the component split and should go further.

**(d) Interest.** A natural companion paper to the queens note: "the Master Lemma solves
three pieces outright; here are the new sequences for the rest" — 3–5 new OEIS sequences
(kings, knights, bishops, torus queens (§C4), maybe rectangle queens), each with theory
attached. The Noon–van Brummelen → A344227 lineage shows OEIS+College-Math-Journal-to-JIS
appetite for exactly this **[web-verified provenance of that lineage]**.

**(e) Risk.** Already-solved risk low but nonzero (folklore may exist for kings/knights
outcomes — the implications note already flags the pre-submission lit check). Intractability
risk is the real one: long games may cap sequences at small n; mitigation is that even
short sequences are new, and the theory rows carry the paper.

---

## Candidate 3 — Misère non-attacking queens: define AND compute a brand-new sequence

**(a) Open problem + provenance.** No misère variant of the Noon–van Brummelen queens game
appears anywhere I searched (papers, OEIS) **[web-verified searches; absence-claim
caveat]**. Our own implications note §4 shows the mirror/pairing theory transfers nothing to
misère — so there is no known structure at all: pure terra incognita where data comes first.

**(b) Leverage.** The key realization this session: **misère OUTCOME is a one-line engine
change, not a new engine.** The recursion `win(avail) = ∃v: ¬win(avail∖N[v])` is identical;
only the terminal flips (no moves ⟹ the player to move WINS under misère). The dense
W-table build machinery rebuilds with the flipped base case; TT, canonicalisation,
ordering, killers port unchanged. §4's "the heap-sum trick dies" applies to *additive*
misère theory — but Conway's misère Grundy value is DEFINED as the unique k with
G + heap(k) a misère second-player win (the definition Wikipedia's Cram page quotes from
ONAG **[web-verified]**), and *that* is exactly a heap-sum outcome search with misère
terminals — our driver verbatim. (It lacks additivity, so it is a reported statistic, not a
computational lever — say so in any writeup.)

**(c) Effort.** Small: const-generic `MISERE` flag through the terminal + W-table build +
validation against a naive misère reference on n ≤ 9 (the existing gate pattern). Compute:
same order as normal play per n — misère outcome for all n ≤ 14–16 plausibly within
existing-record walls; killers/ordering are tuned for normal play so expect some regression
**[computed-here]**.

**(d) Interest.** A sequence we both define and compute, with a story ("all the normal-play
symmetry theory provably fails under misère; here is what the data says") — OEIS submission
+ a section in (or companion to) the existing arXiv note. Misère CGT (Plambeck–Siegel
community) is small but engaged; misère-flavored papers are active on arXiv as of late 2025
(e.g. misère partizan Arc-Kayles PSPACE-completeness, arXiv 2511.21888) **[web-verified
listing]**.

**(e) Risk.** Minimal on every axis: already-solved risk near zero (nothing found),
scooped risk near zero (nobody else has an n≥12-capable queens engine), intractability none
(any prefix is new). The only risk is interest-ceiling: reviewers may read it as "flip a
bit, rerun" — mitigated by pairing it with the failed-transfer theory (§4) and the misère
Grundy values.

---

## Candidate 4 — Torus queens: the outcome sequence the transitivity lemma begs for

**(a) Open problem + provenance.** A344227's comment introduces the toroidal queens graph,
proves G ∈ {0,1} (vertex-transitivity), and then… no sequence of the actual per-n values
exists in OEIS **[web-verified: search "toroidal queens game" returns only A344227]**.
Bardoe's linked Python repo plays on the torus but published no value table I could find
**[web-verified that the link exists; contents unchecked]**.

**(b) Leverage.** Transitivity collapses the root: G(torus_n) is decided by ONE residual
solve (all first moves isomorphic) — so each term costs one sub-board solve, not a root
fan-out. Our engine needs only the wrapped attack masks (geometry change) — canon note: the
torus symmetry group is much larger than D4 (translations × D4), and exploiting it fully is
optional gravy; D4 alone is sound. Our B2a lemma (phantom row) even explains *why* the
torus differs structurally — theory hook included.

**(c) Effort.** Small port (attack masks + validation); compute per term ≈ one residual ≈
well under the same-n flat-board solve. n into the mid-teens plausible quickly
**[computed-here]**.

**(d) Interest.** New OEIS sequence, directly cross-referenced from A344227; rounds out the
§3 table's only {0,1}-bounded-but-unknown row. Fits inside the Candidate-2 portfolio paper.

**(e) Risk.** Near-none; the one check: whether torus-queens outcomes hide in the n-queens
torus literature (Polya/Monsky is about *counting* completions, not the game)
**[recalled-unverified]**.

---

## Candidate 5 — Cram = Arc-Kayles on grids = Node-Kayles on the grid's line graph: the misère frontier

**(a) Open problem + provenance.** Cram (impartial dominoes) positions ARE Arc-Kayles
positions on the grid graph, i.e. Node-Kayles on its line graph — our game after one graph
functor. Normal-play frontier **[web-verified, Wikipedia raw + Beling's GitHub]**: known
through 3×20 (Lemoine–Viennot 2010), 4×9/5×9/6×7/7×7 (LV), 6×9/7×8/7×9 (Beling), and
Beling's README now claims first-publication values up to 15×4, 12×5, 10×5, 9×6, 8×7, 9×7,
"most within minutes". The 3×n value sequence shows no pattern through n=20; Uiterwijk
solved the 3×21 and 5×11 *outcomes* via CGT databases (ICGA J. 2018/ACG 2019)
**[web-verified]**. **Misère frontier is far more open and dormant** [web-verified,
sprouts.tuxfamily records page + Wikipedia]: misère values known only to 3×15 / 4×9 / 5×7 /
6×6, last updated 2011; misère 3×n is conjectured periodic with period 3 (0,0,1 repeating),
verified only to n=15; the 5×8, 5×9, 6×7+ misère cells are literally "?" in the table.

**(b) Leverage.** Partial. What ports: the whole Node-Kayles stack via line graphs, the
≤8-vertex Grundy tables (any small component), the misère flag (C3), the heap-sum driver
for misère Grundy values (the exact quantity the misère Cram table tabulates). What does
NOT port cheaply: Cram positions shatter into components constantly, so a competitive
solver NEEDS component-XOR sum handling (normal play) and misère-aware sum handling
(harder: misère values don't XOR — LV used génie/misère-quotient machinery
**[recalled-unverified]**; a misère sum can still be brute-forced as one compound game,
which is what our TT would do, at a cost). Incumbents (LV's Glop, Beling's public Rust
solver) are specialized and good.

**(c) Effort.** Largest on this list: line-graph port (small) + component-sum engine
(medium, normal play — the parked branch helps) + misère sum treatment (the research part).
Compute: misère 3×16..3×24 and 5×8/5×9 plausibly land in the n=16-queens cost band; each
+1 in the conjecture test is publishable-in-aggregate **[computed-here, medium
confidence]**.

**(d) Interest.** Cram records are tracked publicly (records page, Wikipedia table);
confirming misère 3×n period 3 through a much larger n — or refuting it — is a crisp,
citable deliverable. Venue: ICGA Journal / INTEGERS + the records wiki.

**(e) Risk.** Normal-play Cram: HIGH scoop/incumbent risk (Beling active, minutes-scale on
his frontier — do not race him there). Misère Cram: dormant since ~2011, but his tooling
could extend if provoked. Intractability: misère sums are genuinely harder; budget for a
negative.

---

## Candidate 6 — Arc-Kayles structured families (subdivided stars): support/refute the periodicity conjecture

**(a) Open problem + provenance.** Arc-Kayles' complexity is open since 1978; on subdivided
stars with three paths the game is unsolved, with an explicit conjecture (Dailly et al.,
arXiv 1709.05219) that the Grundy sequence in the growing-path parameter is ultimately
periodic; the WALCOM-2026 paper (arXiv 2404.10390) restates the area's open problems
(cacti, cographs, planar) **[web-verified, both papers]**. Grundy values of Arc-Kayles are
now known to be unbounded (answering an open question) **[web-verified, 2404.10390]**.

**(b) Leverage.** Weak-to-moderate: these graphs are tiny; the bottleneck is the DP over
path-components (whose Arc-Kayles values are known octal-game sequences), not search
muscle. Our line-graph port makes term computation easy, but a laptop script does too.

**(c) Effort.** Small; compute trivial. **(d) Interest.** Supporting data for someone
else's conjecture; a note at best unless a period is actually found. **(e) Risk.** The
active French group (GRALMECO/P-GASE projects) owns this line **[web-verified funding
notes in 2404.10390]** — scoop-prone, and the payoff is theirs.

---

## Candidate 7 — Queens in exile (Dekking–Shallit–Sloane): Conjectures 22 & 26 — ALREADY SCOPED

Existing handoff: `notes/handoffs/2026-07-01-exile-queens-conjectures.md`. Status re-checked
today: no resolution of Conjecture 22 (A274641 rows/columns/diagonals are permutations of ℕ)
or Conjecture 26 (A274528 columns eventually quasi-periodic, period 16) found in 2023–2026
searches **[web-verified searches; absence-claim caveat]**. This is pure table compute (no
game tree — mex over line predecessors), trivially parallel, memory-limited; it exercises
the box, not the solver. It stays a strong, low-risk side quest — but it does not leverage
the Node-Kayles engine at all, which is why it ranks below the engine-native targets here.

---

## Candidate 8 — Octal games with open periodicity (Grundy's game, officers/0.6): NO LEVERAGE — stated plainly

Grundy's game nim-values are computed to heap sizes around 2^35 with periodicity still open
**[web-verified, Wikipedia]**; officers (0.6) has a dedicated periodicity-search paper in
Games of No Chance **[web-verified listing]**. These are 1-D heap games: the state is an
integer (or multiset of integers), the tooling is bit-sliced rare-value sieves over
billions of heap sizes, and the frontier is held by decades of specialized computation.
Our assets — graph canonicalisation, TT over graph states, dense small-graph tables,
mirror theory — have nothing to grip: **no meaningful leverage; do not spend the box
here.** (The one shared idea, the heap-sum trick, is not applicable — these games' values
are the direct object, and mex over splits admits no α-β.)

## Candidate 9 — Domination game, normal play (2025 line): adjacent, noted only

*The Normal Play of the Domination Game* (arXiv 2502.13118, 2025) starts the impartial
last-move-wins domination game: PSPACE-complete on diameter-2 graphs, paths/cycles solved
**[web-verified abstract]**. Values on further families are open, but the state is a
(dominated-set, playable-set) pair, not vertex-deletion — the engine port is a redesign,
not a swap. A crisp fit exists only if someone asks for grid/king-graph values. Parked.

---

## Ranked TOP-5

Scores 1–5 (5 best). Tractability includes engine-port size AND compute scale; novelty =
"does the sequence/answer exist anywhere in any form".

| rank | target | interest | tractability | novelty | notes |
|------|-----------------------------------------------|----------|--------------|---------|----------------------------------------------------|
| 1 | Misère queens (outcome + misère-Grundy) (C3) | 4 | 5 | 5 | one-flag engine change; we define the sequence |
| 2 | Sibling-piece portfolio incl. torus (C2+C4) | 4 | 4 | 5 | Master-Lemma theory + several new OEIS sequences |
| 3 | 3×n / 5×n lattice Node-Kayles (C1) | 3 | 4 | 4 | extend A316632, periodicity hunt; component engine |
| 4 | Misère Cram frontier (C5) | 4 | 2 | 4 | crisp records + a live conjecture; hardest port |
| 5 | Queens in exile Conj 22/26 (C7) | 3 | 4 | 3 | already scoped; zero engine reuse (pure compute) |

**Recommendation.** After G(17)/G(18) land, the single best next target is **misère
non-attacking queens (C3)**: it is the maximum-novelty deliverable per unit of new work —
a base-case flip in an already twice-validated engine yields a sequence that does not
exist anywhere, it directly extends the current paper's arc (the implications note already
proves *why* the normal-play theory cannot predict it, which turns a compute run into a
story), and the misère-Grundy variant reuses the heap-sum driver as-is. Run it as the lead
item of a combined "placement games beyond queens" push whose second wave is the
sibling-piece/torus portfolio (C2+C4, the same session's geometry-swap infrastructure),
keeping the lattice-strip extension (C1) as the component-engine follow-on. Avoid racing
Beling on normal-play Cram; treat misère Cram as a later, deliberate expedition if the
component-sum engine gets built for C1 anyway.
