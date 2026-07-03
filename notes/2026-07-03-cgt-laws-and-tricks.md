# CGT laws and tricks — new theorem directions beyond the mirror theory (2026-07-03)

**Scope**: THEORY session, interim report. No builds, no solver runs; all computation =
fresh Python brute force on small boards / small graphs in the scratchpad (seconds-scale,
scripts noted in §8). Companion to the
[conjecture theory](2026-07-02-a344227-conjecture-theory.md),
[primer](2026-07-02-placement-games-primer.md),
[implications](2026-07-02-theory-implications.md), and
[n=18 PV geometry](2026-07-02-n18-pv-geometry.md) notes. Everything below is NEW relative
to those notes unless explicitly cross-referenced. Status labels: **PROVEN** /
**TESTED-CONSISTENT** (checked exhaustively at the stated sizes, no proof) /
**CONJECTURE** / **REFUTED** (tested and false — recorded to stop re-derivation).

**Headline items**, in order of importance:

1. **A correction to the existing notes** (§4.1): "every non-diagonal even-n opening is an
   N-position" is NOT a consequence of Theorem 3 and is **false at n=6** — prediction P8's
   second clause and two proposed engine gates must be amended.
2. **Theorem S1 (Closed-Pairing)** (§1): the Copying Lemma generalized from automorphisms
   to arbitrary matchings with a closure property — with data showing exactly where such
   certificates exist (n=4) and where they provably cannot (n=10..16) or empirically do
   not (n=6, 8 winning residuals).
3. **Torus queens values to n=10** (§2.4): `1,1,1,0,1,0,1,0,1,0` — a clean parity law
   candidate on the borderless board, new data beyond the notes' n≤5.
4. **Well-Covered Parity Law** (§3.1): the rook solution is the special case of a general
   graph-theoretic law.
5. **True-Twin Deletion Lemma** (§2.1) + a demonstrated **no-go for Lipschitz edge-transfer
   laws** (§2.2), framing what a plane↔torus transfer principle may and may not look like.

---

## 1. Scar calculus: the Closed-Pairing Theorem and its limits

### 1.1 Theorem S1 (Closed-Pairing Theorem) — PROVEN

Setting: Node-Kayles on a graph; `N[v]` = closed neighborhood; a *position* is a set `A`
of available vertices; playing `v ∈ A` yields `A ∖ N[v]`.

> **Theorem S1.** Let `A` be a position and `π : A → A` a fixed-point-free involution
> (a perfect matching on `A`) such that
> **(a)** no pair is internally adjacent: `π(v) ∉ N[v]` for all `v ∈ A`; and
> **(b)** every pair's joint closed neighborhood is π-invariant within `A`:
> for all `v ∈ A`, the set `(N[v] ∪ N[π(v)]) ∩ A` is a union of π-pairs.
> Then the player to move loses: `A` is a P-position, `G(A) = 0`.

*Proof.* Induction on `|A|` (even by hypothesis; `|A| = 0` is a mover loss). Suppose the
mover plays `v`. By (a), `π(v) ∉ N[v]`, and `π(v) ∈ A`, so the reply `π(v)` is legal.
After both moves the deleted set is `(N[v] ∪ N[π(v)]) ∩ A`, which by (b) is π-invariant;
hence the residual `A′ = A ∖ (N[v] ∪ N[π(v)])` is π-invariant, and `π` restricts to a
fixed-point-free involution on `A′`. Hypothesis (a) holds on `A′` a fortiori; hypothesis
(b) holds because `(N[x] ∪ N[π(x)]) ∩ A′ = ((N[x] ∪ N[π(x)]) ∩ A) ∩ A′` is an
intersection of two π-invariant sets. By induction the responder wins `A′`; the responder
therefore always has a reply and makes the last move. ∎

**Remarks (all PROVEN):**

- **S1 strictly generalizes the Copying Lemma.** If `φ` is an involutive *automorphism*,
  `A` is φ-invariant, and no available square is self-mirroring, then `π = φ|_A`
  satisfies (a) (definition of self-mirroring) and (b) automatically
  (`N[φ(v)] = φ(N[v])`, so the union is φ-invariant). The point of S1 is that **the
  pairing need not come from a symmetry at all** — it is a purely combinatorial matching
  condition, checkable in `O(|A|³)` with no game search. This is the certificate format
  the primer's "rule + exceptions" discussion (implications §5) was missing: a closed
  pairing IS a complete, search-free P-certificate.
- **Two-tier pairing collapses into S1.** The hoped-for "mirror on the bulk `P` +
  ad-hoc matching `μ` on the exception set `S`" theorem is not a new theorem: if the
  joint map (π on `P`) ∪ (μ on `S`) satisfies (a)+(b) on `P ⊎ S`, that is exactly an S1
  pairing. So the *entire* content of "pairing with exceptions" is: **find any closed
  pairing of the whole residual; geometry is allowed on most of it and improvisation on
  the rest.** The soundness conditions asked for in the task are precisely (a) and (b) —
  nothing weaker suffices without adding strategy content (see 1.3).
- **Necessity fails.** `C₅` (the 5-cycle) has `G = 0` (every move leaves `P₂` with
  `G = 1`, so `G = mex{1} = 0`) but admits no pairing at all (odd order). Closed pairings
  are a sufficient certificate, not a characterization.
- **The parity-flip lemma.** In any pairing framework, one *unanswered* exception move is
  fatal: if the intruder plays a scar square and the defender has no reply inside the
  scar region, the defender must break a pair, and the remaining closed-paired region is
  a P-position *with the defender to move* — i.e. the defender now loses it (by S1
  applied with roles swapped). Consequence: **scar moves must be answered by scar moves;
  any bounded-scar theorem must pair scar EVENTS, not merely scar squares.**
- **Interaction is inherently two-way.** One cannot hypothesize "moves in `S` scar `P`
  symmetrically" while "moves in `P` do not erode `S`": both effects travel the *same*
  edges (adjacency is symmetric). Any transfer law of the form "pairing on `P` + `S`
  second-player-win ⟹ whole game P" with `S` treated as a *static* subgame is unsound
  unless `S` and `P` are completely non-adjacent (in which case it is the trivial
  disjunctive sum `G(A) = G(A ∩ S)`). The border battle's difficulty is this fact.

### 1.2 Where closed pairings actually exist — TESTED (exhaustive, n ≤ 8)

For each even `n`, every winning opening's residual (a P-position) was searched
exhaustively for a closed pairing (backtracking over matchings with incremental
(a)/(b) pruning; code validated by recovering the ρ-pairing on the 4×4 knights board):

| board | winning openings                  | residual P-positions          | closed pairing?                    |
|-------|-----------------------------------|-------------------------------|------------------------------------|
| n=2   | all 4 squares (all diagonal)      | empty residual                | trivial                            |
| n=4   | all 8 long-diagonal squares       | central 4: `\|R\|=4`; corner 4: `\|R\|=6` | **FOUND for all 4 central** (e.g. after (1,1): pairs {(0,3),(3,2)}, {(2,3),(3,0)}); **NONE for the corner residuals** |
| n=6   | 28 of 36 openings (12 diagonal + 16 non-diagonal) | `\|R\|` = 16–20, all `G(R)=0` | **NONE, for any of the 28**        |
| n=8   | exactly the 4 central squares (all diagonal) | `\|R\|=36`, `G(R)=0`      | **NONE**                           |

Readings:

- **The S1 certificate is real but rigid.** It exists precisely for the n=4
  central strikes — the smallest instances of the "embedded odd-center" mechanism — and
  then *stops existing* even where P-positions abound. A static matching must survive
  every move order; real queen P-positions past n=4 need adaptive strategies.
- **For n = 10..16 nonexistence is a THEOREM**: those boards are P, so every opening
  residual `R` is an N-position, and S1 (sound) forbids a closed pairing of any of them.
  Any even-n machinery must therefore consume an n-dependent resource — reconfirming the
  implications note §1.4 from a new direction.
- **Consequence for the R₁₈ certificate hope**: a closed pairing of the n=18 I9-residual
  (which IS a P-position) *may* exist, but the n=6/8 pattern says do not expect it; the
  realistic certificate target is S1-plus-bounded-strategy (below), not S1 alone.

### 1.3 The strategy-content gap, stated precisely — CONJECTURE (shape)

What a finishing lemma for even-n queens must look like, given 1.1–1.2:

> **Conjecture S2 (event-paired scars, schema).** Let `A = P ⊎ S` with π satisfying
> (a),(b) *within `P`* and (iii): `N[s] ∩ P` is π-invariant for every `s ∈ S`. Suppose
> the defender has a *reply oracle* `r(·)`: for every reachable eroded scar set
> `S′ ⊆ S` and every `s ∈ S′`, a reply `r(S′, s) ∈ S′ ∖ N[s]` such that the S-moves
> always occur in couples and the coupled deletions `(N[s] ∪ N[r]) ∩ P` are π-invariant.
> Then `G(A) = 0`.

The proof of S2 *given* the oracle is the S1 induction verbatim (couples restore
π-invariance; the parity-flip lemma shows the oracle's totality is exactly what is
needed). The open content is entirely the oracle's existence — for the queens border,
B1 (≤ 2 border queens ever) bounds the couple count at ONE, so the whole even-n problem
is: *does the single border exchange admit a reply whose joint scar is repairable by a
NEW closed pairing of what remains?* That is a bounded, finite question per `n` — but
1.2 warns the repair pairing will generally not exist statically, so the residual
Δ-battle keeps genuine strategy content. This matches, from the pairing side, the
implications note's conclusion that the Δ-battle is where all proofs currently die.

---

## 2. Quotient and transfer laws

### 2.1 True-Twin Deletion Lemma — PROVEN

> If `u ≠ v` are true twins (`N[u] = N[v]`, hence adjacent), then Node-Kayles values
> satisfy `G(Γ) = G(Γ − v)`, and the same holds for every position containing both.

*Proof.* Playing `v` and playing `u` give the same residual (`N[u] = N[v]`), so they are
one option, not two; and any other move `w` deletes `u` iff it deletes `v`
(`u ∈ N[w] ⟺ w ∈ N[u] = N[v] ⟺ v ∈ N[w]`), so twins persist or die together and the
option trees of `Γ` and `Γ − v` are isomorphic by induction, with `mex` unchanged
(duplicate options never change a mex). ∎

Verified numerically on random 8-vertex graphs with a planted twin: agreement in
600/600 trials. Presumably folklore (it is the degenerate case of the modular-width
machinery); recorded because it is the ONE exact structured-edge-set law that survived
testing — and it is consistent with the 2026-06-20 solver probe that found queen tail
graphs essentially twin-free (the lemma has nothing to fire on there).

### 2.2 No Lipschitz edge-transfer law — TESTED (no-go, quantified)

Random 9-vertex graphs, one uniformly random non-edge added, exact Grundy before/after
(1500 samples): `|ΔG|` histogram `{0: 762, 1: 231, 2: 279, 3: 138, 4: 69, 5: 21}` —
a **single** edge moved `G` by up to **5** (0 → 5), already at 9 vertices. So there is
no function bounding `|G(Γ+e) − G(Γ)|` by anything local, and no bound of
`|G(plane) − G(torus)|` by wraparound-edge counting can exist *as a general graph law* —
any plane↔torus principle must use queen-specific structure. A companion test killed the
candidate false-twin law: `G(Γ)` with a false-twin pair is NOT determined by
`G(Γ + twin edge)` (all value combinations occur). **REFUTED as general laws; recorded.**

### 2.3 Plane-in-torus embedding — PROVEN

> The n×n plane queen graph is an *induced subgraph* of the m×m torus queen graph
> (window `[0,n)²`) for every `m ≥ 2n−1`.

*Proof.* Rows/columns: distinct residues below `n ≤ m` never wrap. Wrapped main
diagonal: `r−c ≡ r′−c′ (mod m)` with both differences in `(−n, n)`, so they differ by
less than `2n−1 ≤ m`, forcing equality — i.e. a genuine plane diagonal. Anti-diagonals:
same argument on `r+c ∈ [0, 2n−2]`. ∎

So the plane board is torus-induced but NOT a torus *position* (a residual of torus
play): one torus queen deletes 4 wrapped lines, and the leftover wrapped adjacencies
inside a window differ from plane adjacencies (checked by direct arithmetic). The
embedding gives no value transfer by itself (2.2), but it is the correct formal frame
for "plane = torus minus wraparound", and any future transfer law should be stated
against it.

### 2.4 Torus queens to n=10: a parity law candidate — TESTED-CONSISTENT

Fresh full-DAG values (this session, exact):

| n        | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|----------|---|---|---|---|---|---|---|---|---|----|
| G(torus) | 1 | 1 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0  |

New data past the notes' n ≤ 5. **Conjecture T1: `G(torus_n) = n mod 2` for `n ≥ 4`.**
The proven `G ∈ {0,1}` (vertex-transitivity) plus this data says the *borderless* board
does what the plane was conjectured to do — and the plane's even→0 pattern broke at
n=18 exactly via border structure (B2a's phantom row does not exist on the torus). If
T1 holds while the plane oscillation stays broken, the border is *provably* the whole
story, isolated as the difference between two concrete sequences. This is also the
uncomputed OEIS-ready sequence flagged in the targets survey (C4) — ten terms now exist.

### 2.5 Orbit-count bound — PROVEN (one line, loose but clean)

`G(Γ) ≤ #(vertex orbits of Aut Γ)`: options from same-orbit vertices are isomorphic,
so the option-value set has at most `k` elements and `mex ≤ k`. Interpolates between
the torus (`k=1`, tight: `G ≤ 1`) and the plane (`k ≈ n²/8`, useless) — the gap
measures how far from transitivity the mirror machinery must work.

---

## 3. Parity and potential functions

### 3.1 Well-Covered Parity Law — PROVEN

> If `Γ` is well-covered (every maximal independent set has the same size `m`), then
> Node-Kayles on `Γ` has `G = m mod 2`, and every position's value is its own remaining
> fixed length mod 2.

*Proof.* Maximal independent sets of `Γ ∖ N[v]` are exactly `{M ∖ {v} : v ∈ M maximal
in Γ}` (add-`v`/remove-`v` bijection, checked both directions), so residuals of
well-covered graphs are well-covered with parameter `m−1`. By induction every option of
a parameter-`m` position has value `(m−1) mod 2`; then `G = mex{(m−1) mod 2} = m mod 2`
(and `G = 0` at `m = 0`). ∎

The rook law `G = min(m,n) mod 2` is the special case "rook graphs are well-covered".
This is the correct generality of the "fixed game length" weapon: **the parity route
closes exactly the well-covered members of a family.** Queen graphs fail well-coveredness
decisively (fresh exhaustive terminal-size data):

| n | all maximal-set sizes (counts)      | optimal-play terminal sizes (counts) |
|---|-------------------------------------|--------------------------------------|
| 4 | 3 (16), 4 (2)                       | 3 (16)                               |
| 5 | 3 (16), 4 (32), 5 (10)              | 3 (16), 5 (10)                       |
| 6 | 4 (120), 5 (224), 6 (4)             | 5 (224)                              |
| 7 | 4 (8), 5 (1262), 6 (552), 7 (40)    | 5 (622), 7 (32)                      |
| 8 | 5 (728), 6 (6912), 7 (2456), 8 (92) | (not enumerated)                     |

("Optimal play" = the winning side restricted to value-preserving moves, the losing side
unrestricted.)

### 3.2 What parity does and does not give — PROVEN + REFUTED

- **PROVEN (trivial but worth stating):** under optimal play the game length is variable
  in *magnitude* but fixed *mod 2* — the winner moves last, so length parity ≡ outcome.
  The data above shows both effects: n=7 optimal terminals hit sizes 5 and 7 (both odd,
  first player wins); n=6 optimal play uses only size-5 terminals out of {4,5,6}.
  Also: the known strategies pin length parity globally (a closed-pairing defender
  forces even length; the Lemma-2 odd-board strategy forces odd length) — consistent
  with the n=18 PV length 15.
- **REFUTED (a near-miss static law):** "on even boards every *diagonal-free* maximal
  independent set has even size" holds exhaustively at n=4 and n=6 (all 50 and 52 such
  sets even) — and **fails at n=8**: diagonal-free maximal sets of sizes 5 (48 of them)
  and 7 (112) exist. So no static terminal-parity invariant of this shape survives;
  the parity content of Theorem 3 is genuinely strategic, not configurational. Recorded
  to stop re-derivation.

---

## 4. Nimber boundedness

### 4.1 A correction to the existing notes — REFUTED claim, with the exact repair

The conjecture note (§5, experiment 2) and implications note (§6, item 3, and
prediction P8's second clause) state: *"By Theorem 3 every non-diagonal opening is an
N-position"* — proposed as an engine-correctness gate at ~99% confidence. **This is not
a consequence of Theorem 3, and it is false.** Exhaustive n=6 computation: 28 of 36
openings win for the first player, including 16 NON-diagonal openings, e.g. (0,2)
(residual `G = 0`, reconfirmed on an independent win-recursion). The error: Theorem 3's
mirror refutes lines in which the *opponent never plays a diagonal square*; after a
non-diagonal opening `s` and mirror reply `ρ(s)`, the opener may strike a diagonal
LATER and win. The n=6 trace realizes exactly this: after `(0,2)` and the mirror reply
`(5,3)`, the opener's only winning continuations are `(1,4)` and `(4,1)` — both
anti-diagonal squares. Theorem 3 itself is intact ("a first-player win must *contain* a
diagonal move" — it does, at ply 3); what fails is the ply-1 restriction.

**Repairs needed downstream:** drop the "non-diagonal openings have `G ≥ 1`" gate
(P8 clause 2, §5-exp-2, §6-item-3); weaken P6's reading (winning openings need not be
diagonal, small-n data now shows it); note that at n=8 the winning openings ARE exactly
the four central diagonal squares, so the "diagonal-opening-only" picture may still be
the *large-n* truth — but it is an empirical regularity, not Theorem-3-forced.

### 4.2 Unconditional bounds — PROVEN (small but the only ones)

- **Depth bound:** `G(position) ≤ maximum remaining play length` (induction: options
  have `G ≤ L−1`, so `mex ≤ L`). For queens, `G(B_n) ≤ α(queen graph) ≤ n`; in
  particular `G(18) ∈ [1, 18]` and the heap-sum engine never needs rounds `k > n`.
- **Orbit bound** (§2.5): `G ≤ #orbits`.

### 4.3 The diagonal-budget hierarchy — mixed status

For ρ-symmetric reachable positions `A` on even boards, let `d(A)` = number of available
diagonal ρ-pairs (available diagonal squares come in mutually-attacking ρ-pairs).
Exhaustive over all reachable symmetric positions:

| n | d=0 (count: max G) | d=1        | d=2        | d=3      | d=4      | d=root   |
|---|--------------------|------------|------------|----------|----------|----------|
| 4 | 5: **0**           | —          | —          | —        | 1: 1     | (d=4)    |
| 6 | 13: **0**          | 8: **1**   | 5: 1       | —        | —        | 1: 1     |
| 8 | 45: **0**          | 46: **1**  | 28: **3**  | 20: 3    | 5: 3     | 1: 3     |

- `d = 0 ⟹ G = 0` is the PROVEN mirror leaf (implications §6.1) — reconfirmed.
- **Conjecture D1 (TESTED-CONSISTENT, n ≤ 8): `d = 1 ⟹ G ≤ 1`.** Every symmetric
  position with exactly one live diagonal pair has `G ∈ {0,1}` (99 positions across
  n = 6, 8; max observed 1).
- **The linear budget bound `G ≤ d` is REFUTED** at n=8: a `d = 2` symmetric position
  with `G = 3` exists. So "almost-mirror ⟹ G small" is true at scar budget ≤ 1 and
  already false at 2 — the boundedness conjecture C1/C2 cannot be reached by budget
  counting alone. This sharpens where a boundedness proof must work: the first
  interesting case is two live diagonal pairs.

If D1 is proven it is also an engine leaf: at a symmetric one-pair state `(avail, h)`
with `h ≥ 2`, the mover wins outright (`G(avail) ≤ 1 < h ⟹ G ≠ h`).

---

## 5. Sum-decomposition tricks for the heap-sum engine

- **Bounded-mex identity — PROVEN.** For any position `A` and target `h`:
  `G(A) = h ⟺ (∀ j < h: some child has value j) ∧ (no child has value h)`, and
  `G(A) > h ⟺ every j ≤ h is a child value`. Deciding `G(A) = h` therefore never needs
  child values above `h` — the heap-sum engine's `(avail, h)` state realizes exactly
  this cap (heap moves are the `∃ child of value j` probes). Stated so the equivalence
  is on record: the engine is not an approximation of mex, it IS the bounded-mex
  certificate.
- **Round cap — PROVEN** (§4.2): rounds `k > n` are vacuous; ascending-`k` terminates
  by `k = n` at the latest.
- **Value-layer TT propagation — engine proposal.** A P-entry at `(A, h)` pins
  `G(A) = h` and thus implies N for *every* sibling `(A, h′)`, `h′ ≠ h`; storing the
  value once replaces up to `n` boolean entries and answers all later rounds' probes of
  `A` instantly. Caveat: the outcome solver's value layer measured NO-GO (Tier-C1), but
  the economics differ here — the nimber engine re-probes the same `avail` across
  rounds by design. Worth a gated A/B when the box frees up.
- **Conditional leaf from D1** (§4.3) if proven; the `h ≥ 1` symmetric-diagonal-free
  leaf and odd-center root fast path are already queued (implications §6.1–6.2 — cited,
  not duplicated).

---

## 6. The single most promising next theorem

> **Theorem candidate (D1): a ρ-symmetric even-board position with exactly one
> available diagonal pair has `G ≤ 1`.**

Why this one: it is the first rung of the scar calculus that is *true in all data*
(§4.3), it is the smallest statement whose proof must invent the missing tool — a
symmetry argument that survives exactly ONE unpairable exchange (the parity-flip lemma
says the defender must answer the diagonal strike with a move restoring *some* S1-style
structure, and `d = 1` means there is only one strike to survive) — and both a proof
and a refutation pay: a proof gives the first "almost-mirror ⟹ G small" theorem plus an
engine leaf, and its method is the exact template the border battle needs (`d = 1` is
"Δ-battle with one event", the B1-bounded case); a counterexample at n = 10 would kill
budget-style boundedness for good.

**Concrete attack step:** for the ~15 `d = 1` positions at n = 6, extract, for the sum
`A + *2`, the defender's winning replies to the diagonal strike `e` (full DAG is already
computed; this is a read-off). Classify the reply `t(e)` geometrically — the working
guess is that `t` restores a closed pairing of `A ∖ N[e] ∖ N[t]` (an S1 witness for the
post-strike residual, searchable with the existing `closed_pairing` code). If the
witness pattern is uniform, the proof is: mirror non-diagonal moves (S1), answer the
unique strike with the classified repair, and the position never has `G ≥ 2` because the
defender wins `A + *k` for every `k ≥ 2`. One scratchpad session, no box time.

---

## 7. Not yet explored / cut short

- **S2 oracle for the queens border at n = 18**: search the I9-residual for a closed
  pairing (S1 witness) and, failing that (expected per §1.2), for a depth-2
  pairing-plus-one-repair certificate — needs a smarter search than exhaustive matching
  at 256 squares.
- **Erdős–Selfridge-style scar budget potential** for Conjecture BB: untouched; §4.3's
  `d = 2` violation constrains any candidate (the potential cannot be linear in `d`).
- **Torus parity law T1 proof attempt**: all natural involutions on the even torus are
  fully self-mirroring (checked for translations, glides, point reflections) — the
  observed even→0 must have a non-pairing mechanism; transitivity reduces it to "the
  one opening residual is N ⟺ n even", unexplored.
- **n=6 winning-opening geometry census vs P6/P7**: the 28-opening list is computed but
  its structure (which non-diagonal squares win and why) is unanalyzed.
- **Misère analogs of S1**: not started (expected mostly negative per implications §4).
- **Kings even-n closure via S1**: the O(1) exceptional set makes kings the easiest
  full-solution target for the two-tier machinery; not started.
- **Rectangle queens, d-dim, knights-odd values**: no new computation this session.

## 8. Method note

All computations fresh this session, single machine-independent scripts in the session
scratchpad (`cgtlib.py` + inline drivers): exact full-DAG Grundy/win recursions
(bitmask-keyed memo), validated by reproducing A344227 exactly for n = 1..9 plane and
the notes' n ≤ 5 torus values; the closed-pairing backtracker validated by recovering
the ρ-pairing on the 4×4 knights board. Random-graph experiments: exact subset-DP
Grundy on ≤ 9 vertices, seeded. Everything here is minutes of CPU total; no solver
binaries, no builds, no git-state changes.
