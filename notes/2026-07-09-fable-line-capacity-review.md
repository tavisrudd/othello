# Fable review — line-capacity incidence framing and the six-cell reservoir lemma

Date: 2026-07-09. Reviewer: Fable.

Scope: the work committed since the evening of 2026-07-08 — the line-capacity/incidence framing
(`3863eca`), the six-cell off-conic reservoir lemma (`6699059`), and the surrounding q=23/q=25
zero-xor steering and zone mining (`72dfa83`, `3d2e723`, `ae671ee`, and the earlier live-conic
steering commits). This is a targeted critique, not a summary. It records disagreements,
corrections, and the redirect they imply. Read it against
[`2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md)
§Literature/Framing and [`2026-07-09-live-conic-bestreply-mining.md`](2026-07-09-live-conic-bestreply-mining.md)
§Semi-Formal Graph Lemma / reservoir proof.

## What is right (briefly, so the critique is not mistaken for a reversal)

- The line-capacity vocabulary is a sound organizing move and the novelty guard is well
  calibrated: attributing capacity-`c` line avoidance to Sieben-style hypergraph
  building-avoidance, capacity-1 to Node-Kayles on the conflict graph, and claiming only the
  structured finite-incidence subfamily is correct and conservative.
- The **capacity-mirror obstruction lemma is correct and clean**, including the part that is
  easy to get wrong: among *legal* moves `x` with `S` mirror-invariant, the joint reply
  `S ∪ {x, σx}` fails **exactly** on mirror-chord lines of residual slack 1. This is
  capacity-independent (for capacity `c`, `x` legal forces the chord's old-load `r ≤ c−1`, and
  the joint move fails iff `r ≥ c−1`, i.e. `r = c−1`, i.e. slack 1). Keep it. The cap
  instance "the mirror-pair line already holds one old selected point" is the `c=2` case.
- The six-cell reservoir counting is arithmetically valid as a *lower bound* (it over-counts
  kills, which only weakens it — safe).

The disagreements below are about what these facts can and cannot carry, and about one framing
sentence that a whole-board reading refutes.

## 1. The reservoir → matching step is dead at every frontier prime, not merely "Hall-hard"

The notes repeatedly point the reservoir at a "reservoir/Hall-style" or "robust pairing or
matching certificate" inside the off-conic zone
([bestreply-mining](2026-07-09-live-conic-bestreply-mining.md) lines ~329, ~371, ~431). Do the
arithmetic before investing there.

The lemma gives, per unused row, at least `q − 22` legal off-conic cells, and every such cell
lies in an **unused** column (a used column kills it by the column rule). So the relevant object
is a bipartite graph `B` on `(q−6)` unused rows × `(q−6)` unused columns with minimum degree
`≥ q − 22`. A perfect matching in `B` is what a static pairing strategy would consume. The
honest counting lever for a balanced bipartite perfect matching is min-degree ≥ n/2:

```text
q − 22 ≥ (q − 6)/2   ⟺   2q − 44 ≥ q − 6   ⟺   q ≥ 38.
```

So counting alone certifies a matching only from `q ≥ 38` (first odd plane past it: q=41).
For **q = 23, 25, 29, 31, 37 — the entire near frontier — pure incidence counting cannot
produce a matching**. At q=23 the lemma certifies min-degree exactly **1**, compatible with a
star (no matching at all). The mined `zone_v ≈ 111` (≈6–7 legal cells per unused row) says the
*real* graph is dense — but the lemma does not deliver that density, and density at the small
primes is exactly what a proof needs and counting cannot supply. "Hall-style" over-promises:
Hall needs structure the `q − 22` bound provably lacks below q≈38.

Do not spend proof effort hunting a matching certificate in the zone. It is blocked at the
primes that matter.

## 2. Conic and zone are not a disjunctive sum — "steer conic-xor to 0, then solve the zone" is not Sprague–Grundy-valid

This is the load-bearing correction. The steering plan reads (in places) as: choose a reply with
live-conic Node-Kayles xor 0, then discharge the off-conic zone as a separate game
([bestreply-mining](2026-07-09-live-conic-bestreply-mining.md) §Import, Next-Check #2). That
decomposition is invalid, and by construction, not by accident.

The live-conic graph is a *derived* object: its edges come from the involution matchings induced
by the currently-selected off-conic intruders. **Every off-conic zone move is itself an
intruder.** Playing one (a) adds a new involution matching (edges) to the conic graph and (b)
deletes live conic vertices via its chords. Both change the conic Node-Kayles game. So the conic
and the zone share their move set and interact — they are not independent components, there is no
Sprague–Grundy sum `conic_xor ⊕ zone_value`, and "conic-xor 0 now" is a snapshot that the very
next zone move destroys.

The right object is a **maintenance strategy, not a sum and not a matching**: P2 keeps the
invariant "conic-xor = 0 after each of P1's moves," responding either with an on-conic
Node-Kayles pairing move or by spending an off-conic intruder to re-zero the parity. In this
reading the reservoir's job is completely different from a matching: it is the
**move-availability lemma** that guarantees a re-steering move always exists. Full unused
row/column support = "there is always a fresh off-conic intruder to reset conic parity." This is
also why the mining keeps finding the witness "within the first four zero-xor candidates" — you
need *existence* of some xor-0 response, not a canonical one, and abundance supplies it.

This single reframing resolves both #1 and #3: you stop needing a matching (#1) and you stop
needing a decoupling that does not exist (this item). The open obligation becomes precise and
correctly shaped: prove the maintenance invariant is (a) preservable — a re-zeroing move always
exists, which the reservoir underwrites — and (b) terminating in P2's favour — P2 does not run
out of parity-preserving moves before P1 does. That is a Nim-value invariant argument, the same
family as the mirror/pairing proofs that actually landed in this project, not a static SDR.

## 3. Beware: the zone-pairing certificate is the object C28 already refuted one layer up

C28/`mir` found **zero** `MirrorStepGood` hits at the size-4 escape layer (q=11/q=13 all P
escape children, q=17 min-escape sample). A "robust pairing/matching in the zone" is
structurally the same kind of object — a pairing strategy. It can legitimately live in the zone
only if the zone genuinely decouples from the conic, which per #2 it does not. So the current
zone-matching target risks walking straight back into the refuted mirror route wearing different
notation. The maintenance-strategy framing (#2) is what keeps the zone work distinct from the
dead C27/C28 mirror line; a raw "find a pairing in the zone" target does not.

## 4. The reservoir is a bounded-depth base fact — it cannot be the recursion, and it is already at its last useful `k` for q=23

Stated for six cells, the lemma is really: for a `k`-cell legal grid position, each unused row
keeps at least

```text
q − k − C(k,2) − 1
```

legal off-conic cells (`k` used columns, `C(k,2)` secants, 1 root-conic exclusion). At q=23:
`k=6 → 1`, and `k=7 → 23 − 7 − 21 − 1 < 0` — **vacuous one ply deeper**. The bound goes
vacuous once `k ≳ √(2q)`. So this is a statement about exactly the S4-reply layer and dies
immediately below it. That is fine as the base-layer resource lemma feeding the one-shot
maintenance argument of #2; it is fatal if anyone tries to iterate it down the tree. State it as
a base fact, never as a recursion engine.

## 5. Scope the "collapse into the capacity-1 conflict-graph regime" claim — a whole-board collapse is impossible, and *why* is a positive structural fact

The residual-capacity-decomposition bullet says the free-endgame theorem "should be stated as a
collapse into the capacity-1 conflict-graph regime, not as a projective-only artifact." A reader
can over-extend "not projective-only" to a whole-board collapse. That is geometrically
impossible and worth stating as such:

- For the plane to become pure Node-Kayles, every line would need a selected point — a
  **blocking set**. The minimum blocking set in `AG(2,q)` is `2q − 1` (Jamison 1977;
  Brouwer–Schrijver).
- A cap (arc) has at most `q + 1` points for odd `q` (the conic). Since `2q − 1 > q + 1` for
  every `q > 2`, **no cap is ever a blocking set**.

So capacity-2 lines (lines missing all selected points) can never all disappear under cap play.
Read positively, this is the structural reason the cap game stays strictly harder than its
Node-Kayles shadow and does not trivialize — a permanent frontier of genuine triple-constraints
survives. Keep the collapse claim scoped to the conic / a residual subboard, and consider stating
the blocking-set bound as the obstruction lemma that *justifies* why only a local (conic) collapse
is available. It belongs next to the residual-capacity decomposition in the framing.

## 6. Minor corrections

- **"q=23 is the sharp boundary of the lemma."** This conflates the loose bound's vacuity
  threshold with a real phenomenon. The 15-secant term is a heavy over-count (most secants meet
  an unused row at cells already killed by columns or by each other), so genuine row/column
  support persists well below where `q − 22` goes to zero — the mined `zone_v ≈ 111 ≫ 17` shows
  the slack. Do not imply support *fails* at q ≤ 22; "sharp" is a property of the loose bound,
  not of the game.
- **The "+1 root-conic cell" (≤1 conic point per row)** relies on the conic being in
  Möbius/hyperbola normal form (graph of a bijection ⇒ ≤1 per row and per column). True in the
  normalized residual model, but a general conic meets a line in up to 2 points — state the
  normal form as an explicit hypothesis of the lemma so it does not silently assume ≤1.
- The general reservoir lemma should be stated once in incidence-matrix form — "legal cells in a
  target line `T` ≥ `|T|` − (number of capacity-saturated lines crossing `T` at would-be legal
  cells)" — and the row bound derived as the instance. That is exactly the "line-load/slack
  counting" example the framing already names; write it generally so column, and any future
  diagonal or conic reservoir, fall out uniformly instead of being re-derived per direction.

## Net

The line-capacity vocabulary and the mirror-obstruction lemma are keepers; the discipline
(conservative novelty, correct prior-art map) is right. The one thing to stop before it burns
cycles is the "steer-then-solve-the-zone / find-a-matching" target: it is blocked both
arithmetically (#1) and structurally (#2/#3). The redirect is to reframe the reservoir as the
move-availability lemma for a conic-xor **maintenance** strategy, and to make the two open
obligations *preservability* (always a re-zeroing move — reservoir underwrites it) and
*termination in P2's favour* (a Nim-value invariant argument). #5 is a framing scope-fix worth
folding into the handoff even if nothing else changes.

— Fable
