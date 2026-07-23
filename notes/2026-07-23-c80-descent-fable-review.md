# C80 descent — adversarial review (Fable), 2026-07-23

**Lane:** `cap`. Scope: the `Y_NK` guard proof (`2026-07-23-c523-ynk-guard-proof.md`), the C522/C523/C524
reports, and the next-step plan. Written mid-session under a quota stop; code cross-checks completed for
the game engine convention and the `capOK` definition; the depth-2 certificate script itself
(`c524_capover_core_depth2.py`) was NOT line-audited.

## Verdict up front

**The `Y_NK` guard proof is CORRECT.** All three lemmas hold; the Lemma 2 case enumeration is
exhaustive; the engine conventions match the proof's. Only presentational nits (below), no gaps.
The depth-2 routing (C524) remains a conjecture with three data points, and the growing residual
fraction is a real reason to doubt the depth bound stays 2 — the review recommends replacing the
depth-2 target with an **overload-gadget (hypergraph Node-Kayles) law** proved by induction on total
overload, which is well-founded because overload is monotone non-increasing under all moves (a fact
already implicit in Lemma 3 but not yet exploited).

## 1. Proof audit (file: 2026-07-23-c523-ynk-guard-proof.md)

**Lemma 1 (vertex deletion).** Correct. `y ∈ L(S∪{x})` iff `{a,b}∪S∪{x,y}` is a cap. New collinear
triples decompose exactly as stated: all-old (impossible, `{a,b}∪S∪{y}` cap since `y ∈ L(S)`),
`{x,w,w'}` (impossible, `x ∈ L(S)`), `{x,y,w}` (= edge `x~y`). `y ≠ x` is handled. No missing case:
a triple in `{a,b}∪S∪{x,y}` not inside `{a,b}∪S∪{y}` must contain `x`, and the other two members come
from `{a,b}∪S∪{y}` — both-old or one-is-`y` are the only options. Exhaustive.

**Adjacency characterization (Objects bullet).** Correct. For distinct `y,z ∈ L(S)`, a cap-breaking
triple in `{a,b}∪S∪{y,z}` cannot be all-old (cap) or single-new (legality of `y`, resp. `z`), so it is
`{y,z,w}`, `w ∈ {a,b}∪S`. Note `{y,z,w}` with `w = a` or `b` is included — lines through a frame point
do produce edges; the proof handles this uniformly. Also `y,z` collinear with each other alone is not a
condition (two points are always collinear); only the third old point creates the edge — consistent.

**Lemma 2 (edge preservation, "⊆" direction) — the load-bearing step.** Correct and exhaustive.
Given `y,z ∈ L(S∪{x})`, a `G_T`-edge not in `G_S` forces a new triple containing `x` with the other two
from `{a,b}∪S∪{y,z}`. Four shapes: `{x,w,w'}` (kills `x ∈ L(S)`), `{x,y,w}` / `{x,z,w}` (each is exactly
a `G_S`-edge to `x`, contradicting Lemma-1 survival `y,z ≁ x`), `{x,y,z}`. Distinctness: `y ≠ z` as graph
vertices; `y,z ≠ x` by Lemma 1. In the `{x,y,z}` case the dichotomy on `ℓ ∩ ({a,b}∪S)` is airtight:
- `ℓ` disjoint from `{a,b}∪S`: `ℓ` is capacity-two for `S` carrying the three **distinct** legal points
  `x,y,z ∈ L(S)` — contradicts `capOK(S)`. (This is where `capOK` is spent, and only here.)
- `ℓ` meets at `w`: then `{y,z,w}` collinear (all on `ℓ`), so `y ~ z` already in `G_S` — contradiction.
No degenerate escape: repeated points are excluded by distinctness; there is no characteristic or
parity input anywhere (see below); points at infinity other than `a,b` are ordinary — a line through
such a point either misses `{a,b}∪S` (capacity-two branch) or the argument never needs to know.

**Lemma 3 (persistence).** Correct and in fact proves more than stated: the set of capacity-two lines
of `S∪{x}` is a **subset** of those of `S`, and `L` shrinks, so every line's legal-point count is
non-increasing. See §3 — this monotonicity is the unexploited asset.

**Theorem.** The induction is sound. Minor nit: the inductive invariant should be stated explicitly —
"every state `T` reachable from `S` satisfies `capOK(T)` (Lemma 3, induction) and
`G_T = G_S[L(T)]` (Lemma 2, induction along the path)" — the current wording gestures at it per-step.
No mathematical gap; the composition of induced-subgraph restrictions is an induced subgraph, so the
path-independence of `G_T` is automatic. Second nit: "by the Sprague–Grundy theorem" is an over-invocation;
`P ⟺ Grundy 0` for a single impartial normal-play game is the definition of Grundy value via mex (the S–G
theorem proper concerns sums). Harmless, but Lean formalization should target the mex fact, not game sums.

**Convention checks against the code (done, not assumed):**
- `PrimeGridGame.value` (notes/2026-07-08-intrusion-census.py:274): `moves == 0 → False` = mover loses =
  P. Matches "empty `L` is a loss for the mover" and Grundy 0 for the empty graph. ✓
- `maximum_capacity_two_line` / `node_kayles_exact` (rust/scripts/c80_response_fibre_census.py:66–83):
  capacity-two = `fixed_load + |mask ∩ ℓ| == 0` where `fixed_load` counts `a,b` on `ℓ` — exactly
  "`ℓ ∩ ({a,b}∪S) = ∅`"; guard = max legal count on such lines ≤ 2. Matches the proof's `capOK`. ✓
- `legal_mask` (intrusion-census.py:261): forbids occupied cells and every line through two points of
  `{a,b}∪S` — exactly `L(S)` as caps. ✓ (`pts = [0,1]` are `a,b`; affine cells offset by 2.)
- `projective_lines` asserts all `q²+q+1` lines are enumerated with consistent `fixed_load`. ✓

**Checklist item 5 (provenance-independence):** verified — the proof uses only "`{a,b}∪S` is a cap" and
`capOK(S)`; no conic, no reachability, no oddness of `q`. In fact **the theorem holds for even `q` too**;
`q` odd is only needed elsewhere (conic structure). Worth one sentence in the note so the Lean statement
is not over-hypothesized.

**Verdict: CORRECT, no fixable gaps needed.** Suggested edits are cosmetic: (i) state the induction
invariant; (ii) replace "Sprague–Grundy theorem" with the mex/P-position fact; (iii) record that `q` odd
is not used.

## 2. State assessment — what is proven vs conjectured

Accurate in the main, with these corrections of emphasis:

- **Proven, q-uniform:** `capOK(S) ⟹ (value(S)=P ⟺ Grundy(G_S)=0)`. Also proven en route but unstated:
  overload monotonicity (Lemma 3's proof gives it for free).
- **Conjectured:** depth-2 routing. Three primes, frozen reachable domains. The claim in C524 that this is
  "the first real evidence the depth bound is uniform" is generous: 0→0.7%→4.2% residual growth means the
  bridge carries more weight as `q` grows, and nothing structural yet pins depth at 2. The right read is
  "no counterexample yet at the only overload profiles observed" — and C523 recorded max overload 4 at q17;
  **the q19 overload profile of the 48,084 residual children was apparently not tabulated**. That is a hole:
  if q19 already shows overload 5+ or two disjoint overloaded lines, the depth-2 phenomenology is thinner
  than it looks.
- **A statement-alignment flag (check before relying):** (ON) as written in the alt-attack plan demands a
  P-valued **on-conic** size-4 child, while C522 found 63% of gap children have **intruder-only** winning
  replies. The two-tier certificate proves the responder wins, which is C80(b)'s descent, but if any
  downstream consumer (C82 counting) uses the literal on-conic form of (ON), the equivalence needs to be
  re-verified with off-conic replies in the strategy. Cheap to check; expensive to discover late.
- **Priorities in the next-steps list:** (b) Lean is over-weighted right now — the proof is elementary,
  reviewed, and cross-checked on 54,930 cases; the crown blocks on Piece 2, not on formal assurance.
  (c) q=23 stress is right but is the *second* computation to run (see §3 for the first). (d) is the right
  target but the Φ framing has a flaw, next.

## 3. Piece 2 — how to prove the routing (and why Φ, as posed, aims at the wrong thing)

**The flaw in the Φ plan as stated.** Define `Φ(S)` = Σ over capacity-two lines of
`max(0, |ℓ ∩ L(S)| − 2)`. Then `Φ = 0 ⟺ capOK` by definition — but "responder can drive Φ→0" is
**vacuous as a control problem**: by the Lemma-3 mechanism, capacity-two lines only disappear and `L`
only shrinks, so **Φ is monotone non-increasing under every move by either player**, and reaches 0 in any
play line. `capOK` is an absorbing predicate for free. The entire difficulty is arriving at `Φ = 0` **with
the right game value** — i.e. (d)-(ii) is not "control Φ", it is "control value while Φ dies", which is
just the original problem restated. Drop the Lyapunov shape.

**Recommended replacement: a static value law on the overloaded boundary — "gadget Node-Kayles",
proved by induction on Φ (well-founded by the monotonicity above).**

Structure of the overloaded states, from the geometry: an overloaded capacity-two line `ℓ` with `k ≥ 3`
legal points `p_1..p_k` has these exact dynamics — the `p_i` are **pairwise non-adjacent in `G_S`** (their
common line misses `{a,b}∪S`; any other line through two of them would contain them twice — no; two points
determine one line, which is `ℓ`), and playing any one `p_i` makes the survivors among `p_1..p_k` pairwise
adjacent (via the new selected point on `ℓ`) while `ℓ` stops being capacity-two. Playing a point off `ℓ`
deletes some of the `p_i` (closed neighborhood) and leaves the gadget on the rest. So the residual game is
exactly **Node-Kayles on `G_S` plus one hyperedge-gadget per overloaded line**: a `k`-set of independent
vertices that "collapses to a clique on the survivors" when any of its members is played. Call this game
`NK⁺(G, {gadgets})`.

- Base case Φ = 0: `NK⁺ = NK`, the proven `Y_NK` theorem.
- Induction: every move strictly decreases the lexicographic measure `(Φ, |L|)` (Φ never increases; `|L|`
  strictly decreases). So a value law for `NK⁺` with `g` gadgets reduces to positions with fewer/smaller
  gadgets or fewer vertices. The C523 data says the states that matter have **one gadget of size 3** (93%)
  or 4 — so proving the law for `g = 1, k ∈ {3,4}` may already cover every observed residual, and the
  depth-2 certificate becomes a **corollary** (play resolves or shrinks the single gadget within two plies)
  rather than the theorem. This is strictly cleaner than a depth bound: a depth bound is per-state and its
  uniformity in `q` is exactly as hard as the value question, whereas a gadget law is a static statement
  on an enlarged class, matching the shape that already succeeded (`Y_NK`).
- Concretely: compute `Grundy⁺` of `NK⁺(G, one k-gadget)` in terms of Grundy values of the resolutions:
  moves are (i) play `p_i`: → `NK` on `(G / gadget-resolution) − N[p_i]` — note the resolved state is
  capOK-by-construction only if `ℓ` was the sole overload; (ii) play off-gadget: gadget survives on the
  remaining `p_i`'s (size may drop to ≤ 2, i.e. dissolve into an ordinary non-edge pair — careful: a
  2-survivor gadget is NOT an edge; the two survivors stay non-adjacent and `ℓ` is still capacity-two but
  no longer overloaded). The mex over these is finite and local **given** the ambient Grundy data — the
  law will be conditional ("Grundy⁺ = f(Grundy of the `k+1` resolved subpositions)"), which is exactly the
  right interface for the routing lemma.

**Why not the alternatives:** a Hall/matching argument has no natural bipartite structure here (the
obstruction is a 3-uniform hyperedge, not a deficiency); induction on intruder count re-couples to the
census domain and loses `q`-uniformity; a pure local classification of capOVER states cannot work alone
because P-ness is global (Grundy 0 of the whole graph) — the gadget law is the correct localization:
local gadget + global Grundy interface.

**Should we fear depth growth?** Yes, mildly — the residual fraction grows and larger `q` will eventually
produce richer overload profiles (two disjoint overloaded lines, or `k ≥ 5`). If those occur, depth 2 is
plausibly insufficient but the gadget induction doesn't care: it handles `g` gadgets by the same measure.
That asymmetry is the strongest argument for the gadget route.

**Single most decisive cheap computation (run before q=23):** tabulate, on the **already-committed q19
census**, the overload profile of the 48,084 residual children and of their depth-2 witness states `G`:
(number of overloaded capacity-two lines, multiset of overloads, pairwise line intersections). Cost: one
pass over frozen data with `maximum_capacity_two_line` generalized to return the full profile. Outcomes:
(a) all `g = 1, k ≤ 4` → the `g=1` gadget law suffices for everything observed; prove exactly that;
(b) `g ≥ 2` or `k ≥ 5` appears → depth-2 was luck of small `q`, and the gadget induction is not optional.
Either branch de-risks Piece 2 more per CPU-hour than a q=23 census (which should still follow, as the
first out-of-sample test of whatever law branch (a)/(b) selects).

## 4. Tao lens — structure the current framing leaves on the table

1. **`G_S` is a partial-linear-space collinearity graph with a canonical clique partition per base point.**
   Each edge `y~z` lies on a unique line, which meets `{a,b}∪S` in exactly one point `w` (two old points on
   a line kill all its legal points). So the edge set is partitioned: for each `w ∈ {a,b}∪S`, the lines
   through `w` induce disjoint cliques on `L(S)`. `G_S` is a union of `|S|+2` cluster graphs — a
   `(|S|+2)`-colorable *edge* structure. Node-Kayles is PSPACE-complete in general but polynomial on several
   structured classes (Bodlaender–Kratsch: cocomparability, graphs of bounded asteroidal number); nobody has
   asked which class these collinearity graphs land in. Even a heuristic answer shapes the "uniform Grundy
   criterion" open question in the proof note.
2. **The path/cycle → octal-game bridge is the likely `q`-uniform endgame.** The engine already carries
   `spectrum` / `dawson_xor`: the empty-conic zone graphs decompose into paths and cycles, and Node-Kayles on
   paths is Dawson-type octal play with **eventually periodic** Grundy values (period 34 for .137). If the
   `capOK` full graphs `G_S` (or their late-game truncations) decompose similarly, then `Grundy(G_S) = 0`
   becomes an arithmetic condition on component lengths **mod a fixed period** — that is a `q`-uniform closed
   form, i.e. the missing second half of the crown ("Grundy is the value" + "Grundy is computable uniformly").
   Cheap check: component-type census (max degree, path/cycle/other fraction) of `G_S` over the q17/q19
   `capOK` reply states. If "other" is rare and bounded, the crown's shape is: gadget law (Piece 2) +
   octal periodicity (Piece 3) + finitely many sporadic components.
3. **The gadget game may already exist in the literature.** "Node-Kayles where an independent triple becomes
   a clique upon first contact" is close to arc-Kayles variants and to Schmidt's/Huggan–Nowakowski work on
   games with changing rule sets; a bounded literature pass (octal games, arc-Kayles, "Node Kayles hypergraph")
   before proving the `g=1` law from scratch is warranted — follow `notes/literature-audit-conventions.md` if
   a novelty claim will be made.
4. **Symmetry is underused at the residual core.** The 349 q17 residual children were counted raw; under
   `Stab(frame) ≤ PGL(3,q)` they collapse to few orbits (C523 hints at this but never took the quotient). The
   gadget-law verification and any base-case certificate should be run per-orbit — likely a 10–50× cost cut
   and a cleaner Lean-side finite check.
5. **A frame-point asymmetry worth one look:** `a,b` enter `capOK` only through "lines through `a` or `b` are
   never capacity-two". A capacity-two line is secant/tangent/external to the conic in a `q`-odd-specific
   pattern — if overloaded lines are always external (or always secant) to the live conic, that is a strong
   geometric handle on the gadget census and would explain the growth of the residual fraction (external-line
   count grows like `q²/2`).

## Bottom line

- `Y_NK` proof: **correct**; ship it to Lean whenever convenient, with the invariant stated and the S–G
  citation downgraded to mex; note `q`-parity is unused.
- Replace the depth-2 target: prove a **one-gadget (overloaded-line) Node-Kayles value law** by induction on
  the monotone overload measure; depth-2 should fall out as a corollary, and the approach survives richer
  overload profiles that larger `q` will likely produce.
- Run the q19 residual **overload-profile tabulation** first (frozen data, one pass), then the q=23 stress.
- Check the (ON) on-conic-child form against the off-conic replies the certificate actually uses before C82
  consumes it.
