# C43 — PG(4,3) exact-solve sizing (the even-dimensional evidence vacuum)

Author: Claude/Opus, 2026-07-09. Status: **SOLVED — PG(4,3) = P (second-player win).**

## Verdict (headline)

**PG(4,3) is P** — a second-player win — solved exactly by the compiled orbit-canon solver
(`2026-07-09-pg43-solver.rs`) in **3.7 s / 25,258 memo states**. This is the program's
**first even-dimensional odd-q outcome** (`PG(2m,q)`, `m ≥ 2`, odd `q`, previously *zero*
direct evidence), and it is **P** — consistent with the all-P conjecture, not the seismic
N. Cross-checks (all agree P):

| run | canon | move order | verdict | states |
|---|---|---|---|---|
| default | greedy sound key | forward | **P** | 25,258 (3.7 s) |
| move-order swap | greedy sound key | reverse | **P** | 86,711 (18.5 s) |
| independent canon | IR-min `key` | forward | **P** | 2,988 (17 min) |
| calibration | (same solver) | — | PG(2,3)=P, PG(2,5)=P, PG(2,7)=P, PG(3,3)=P (all known-correct) |

The different state counts across runs (25k vs 87k) reflect different search trees /
canonical over-splitting; the **value is invariant P** across all of them. Soundness
argument: the solve's memo key is a genuine projective image `g(S)` of the position, so
inequivalent positions never collide (no wrong game value) — over-splitting only adds memo
nodes, never flips a verdict. Details and the sizing that led here follow.

Task: `notes/2026-07-07-codex-task-queue.md` §C43. Size an exact cap-game solve of
**PG(4,3)** — the smallest instance of the family `PG(2m,q)`, `m ≥ 2`, odd `q`, which
has **zero direct outcome evidence**. Sizing first; a verdict only if the extrapolation
says a full solve fits comfortably. An **N** verdict would be the program's first N
geometry (seismic — stop and report).

## Board facts (verified)

| quantity | value |
|---|---|
| points `N` | **121** = (3⁵−1)/(3−1) |
| lines | **1210**, each with `q+1 = 4` points |
| collinear triples | 1210 × C(4,3) = **4,840** (of C(121,3) = 287,980 total triples ⇒ 1.68% collinear) |
| hyperplanes (solids, proj-dim 3) | 121, each **40** points (= a PG(3,3)) — verified |
| max cap | **20** (known; game depth ≤ 20) |
| \|PGL(5,3)\| | **237,783,237,120** ≈ 2.378×10¹¹ |
| \|PGL(4,3)\| | 12,130,560 (the PG(3,3) symmetry group, for calibration) |

Solver/probe scripts (committed):
- `notes/2026-07-09-pg43-sizing.py` — raw growth + coarse spectrum probe.
- `notes/2026-07-09-pg43-orbit-sizing.py` — exact PGL(m+1,q) orbit-count BFS (Python; the
  canonicalizer prototype, validated below).
- `notes/2026-07-09-pg43-solver.rs` — **compiled Rust orbit-canon solver** (orbit-BFS +
  negamax with an exact-canon memo). Build:
  `rustc -O -C target-cpu=native notes/2026-07-09-pg43-solver.rs -o /tmp/pg43`.
  Reproduces every Python orbit count and solves the full calibration ladder (below).

## 1. Raw state space — categorically infeasible

The memoized game state is the cap `chosen`; every subset of a cap is a cap, so the raw
state space is **all caps of PG(4,3)** and `caps_k = #caps of size k` is the raw growth
curve. Exact counts (ordered-augmentation DFS, no storage — `pg43-sizing.py raw`):

| k | caps_k (exact) | check |
|---|---|---|
| 0 | 1 | |
| 1 | 121 | = N |
| 2 | 7,260 | = C(121,2) (every pair is a cap) |
| 3 | 283,140 | = C(121,3) − 4,840 collinear |
| 4 | 7,927,920 | |

Beyond k=4 the raw count explodes (caps₅ ≈ 1.6×10⁸; the Poisson-with-line-correlation
model calibrated to k≤4 puts the total over all sizes at **~10¹³–10¹⁴** caps). For
calibration, the *naive* (no-symmetry) memo already needed 11.3M states for PG(2,11) and
blew past 1.3 GB with no sign of stopping for PG(5,2) (31→ that's F₂⁵). **A raw memo of
PG(4,3) is out of the question** — it would need tens of TB. The only route is orbit
canonicalization.

## 2. The reduction is the whole ballgame — exact PGL-orbit counts

PG(3,3) has **55,909** raw caps but only **17** projective-equivalence classes total, so
the raw→orbit reduction is ~3,300× there and grows with |PGL|. The decisive question is
the orbit-count growth curve of PG(4,3): if the peak stays within an orbit-solver's reach
(~10⁷ states, cf. the grid solver ran q=17 at 15.5M canon-states in ~15 min/1.6 GB) then
an exact solve is feasible.

### Canonicalizer (sound, verified)

`Canonizer.canon` computes an exact PGL(m+1,q) canonical form of a cap:
- project the cap onto its span (dim `r`; rank `r` is a PGL-invariant prefix);
- if the cap contains an `(r+1)`-frame (general position), **frame-min**: PGL is sharply
  transitive on frames, so minimizing the sorted image over all frames in the cap is a
  complete canonical form;
- otherwise (frameless caps — a proper projective invariant, so never sharing an orbit
  with frame-having caps) **torus enumeration**: map any independent `r`-subset to the
  standard basis, then minimize over the residual projective torus (`(q−1)^{r−1}` = 16
  elements at q=3). Method tag `F`/`T` keeps the two value-spaces disjoint.

Both branches are complete canonical forms, so **equal canon ⟺ PGL-equivalent** (equal
canon ⇒ a projectivity relates the caps, by construction; no under-merge is possible).
Soundness gate: **invariance under random projectivities** — 400 checks on PG(3,3) and
144 on PG(4,3), **0 failures** (an over-split would show as non-invariance).

Validation against known classifications (`orbit-sizing.py validate`):

| space | orbits by ply (k=0…) | known check |
|---|---|---|
| PG(2,5) | 1,1,1,1,1,1,1 | every arc ≤ conic is one PGL(3,5) orbit ✓ |
| PG(2,7) | 1,1,1,1,1,1,3 | 6-arcs split in PG(2,7) ✓ |
| PG(3,3) | 1,1,1,1,2,2,2,2,3,1,1 (total **17**) | k=4 = planar quadrangle + spatial tetrahedron ✓; k=10 ovoid **unique** ✓ |

The Rust solver reproduces all three orbit curves **identically** (and ~30× faster), and its
orbit-canon negamax solves the calibration ladder to the known outcomes with tiny proof
trees (alpha-beta + canon collapse): **PG(2,3)=P (5 nodes), PG(2,5)=P (7), PG(2,7)=P (9),
PG(3,3)=P (10 nodes vs 55,909 raw caps)**. The small node counts are expected — those are
all closed P families (odd projective dim / small planes) with mirror/pairing strategies, so
the proof tree is shallow. PG(4,3) is even-dimensional with **no** known strategy, so its
proof tree is the open question the solve now answers directly.

### PG(4,3) exact orbit growth (Rust BFS)

Exact PGL(5,3)-orbit counts per ply (`pg43-solver.rs orbit 4 3`), cross-checked two ways:
the color-restricted canon and the unconditionally-complete unrestricted frame-min
(`orbitx`) agree through k=9, and the color-restricted canon is invariance-verified
(600 random-projectivity checks, 0 fails):

| k | orbits_k (exact) | notes |
|---|---|---|
| 0–3 | 1,1,1,1 | empty / point / pair / triangle — PGL-transitive |
| 4 | 2 | planar quadrangle; solid tetrahedron (rank 3 / rank 4) |
| 5 | 3 | rank-5 basis + the two rank-4 PG(3,3) 5-cap classes |
| 6 | 5 | |
| 7 | 8 | |
| 8 | 19 | (unrestricted gold agrees) |
| 9 | 46 | (unrestricted gold agrees) |
| 10 | 137 | |
| 11 | 204 | |

**Reduction factor.** At k=4 the raw count is 7,927,920 and the orbit count is 2 — a
~4,000,000× collapse; the ratio grows with k toward |PGL(5,3)| ≈ 2.4×10¹¹. The orbit curve
`1,1,1,1,2,3,5,8,19,46,137,204` grows ≈2–3× per ply and (by analogy with the unimodal
PG(3,3) curve, and the max cap = 20 ceiling) turns over near k≈13–15. **Total cap orbits:
low tens of thousands** — the exact figure is still being enumerated, but every extrapolation
puts it far inside an orbit-solver's reach (the grid solver routinely ran 10⁷ canon-states).
The state count is decisively *not* the constraint.

(The earlier hyperplane-spectrum lower bound `…,18,34,66,…` under-counts from k≈9 on — the
true orbit counts 46/137 exceed it — so it is a floor, not a tracker; the exact orbit-BFS
above supersedes it.)

**The one real constraint was canonicalization throughput — now resolved.** A sound
game-value memo needs a key that never merges inequivalent caps. The *minimal* canonical
form (unrestricted frame-min, O(P(k,6)) — 27M frames at k=20) is hopeless deep, and a
complete WL+individualization canon still cost ~100–700 ms at size 13–17 (WL-1 gives coarse
partitions on cap incidence structures, and a frame-unit search that falls back to a slow
torus enumeration). The fix: the solve does **not** need the *minimal* canon — any genuine
projective image `g(S)` is a sound key (inequivalent caps never collide), so a single
greedy color-guided basis map (no unit search, no torus) is enough. That runs a uniform
**~35–70 µs/canon** at every size — the ~2000× speedup that made the 3.7 s solve possible.
It over-splits symmetric caps into a few keys (the solve visits 25,258 keys vs the ~10⁴ true
orbits), which only adds nodes, never changes a value.

## 3. Frame-reduction analog (rank-5) — analysis

In rank 3 (PG(2,q)) the game reduces to a single frame position: sizes 1,2,3 are each one
PGL orbit and the size-4 frame (a plane-spanning quadrangle) is still one orbit, giving the
clean chain `empty P ⇔ point N ⇔ pair P ⇔ triangle N ⇔ frame P`; deleting the opening
line then yields the residual **grid game**.

The rank-5 analog is weaker. PGL(5,3) is sharply transitive on ordered **frames = 6 points
in general position**, so it is transitive on caps of size 1, 2, 3 (each a single orbit,
confirmed above) — but the game **already branches at size 4** (planar-quadrangle orbit vs
solid-tetrahedron orbit, split by span rank) and further at size 5 and 6. So transitivity
prunes only the first three plies to single orbits; there is **no single frame position the
whole game reduces to**. The rank-3 "delete the opening line ⇒ affine grid" trick has no
clean rank-5 analog because the opening structure does not collapse to one residual game —
the span rank of the opening is itself a branching invariant. Conclusion: frame reduction
is a genuine but limited pruning (first 3 plies), not a game-collapsing reduction here.

## 4. Verdict — PG(4,3) = P (solved)

The sizing (raw infeasible; orbit space low-tens-of-thousands) said an exact orbit-canon
solve was feasible, and the compiled solver returns it: **PG(4,3) = P**.

- **Solver** (`2026-07-09-pg43-solver.rs`): incremental forbidden-mask negamax + an
  orbit-canon memo. The memo key is a genuine projective image `g(S)` of the cap (project to
  the span, WL-color the point–hyperplane incidence, individualize to a discrete order, map
  the first basis to the standard basis). **This is *sound* by construction** — different
  orbits produce different images, so no two inequivalent positions ever share a key; the
  game value is therefore exact. (It is not the *minimal* canonical form, so it can
  over-split one orbit into a few keys — that only adds memo nodes, never changes a value.)
- **Canon throughput** was the one real lever: the minimal (all-frames) canon is O(P(k,6)),
  hopeless deep; the sound greedy key runs a uniform **~35–70 µs/canon** across all sizes.
  That turned a multi-hour crawl into a **3.7 s** solve.
- **Correctness gates, all passed:**
  1. Calibration ladder to known outcomes: **PG(2,3)=P, PG(2,5)=P, PG(2,7)=P, PG(3,3)=P**
     (the last independently matches the raw no-symmetry Python solver `2026-07-05-proj-cap-fast.py`).
  2. Exact orbit counts reproduced and cross-checked against the unconditionally-complete
     unrestricted frame-min (`orbitx`) through k=9.
  3. **Two independent move orderings** (forward, reverse) → both **P** (25,258 vs 86,711
     states — different trees, same value).
  4. **Independent canonicalization** (IR-min `key`, a different canon code path) → P
     (see status line / cross-check table above).

**Reading.** PG(4,3) = P extends the all-P pattern to the even-dimensional odd-`q` family,
which had no prior evidence. It is *not* a counterexample and *not* an N geometry. It does
not, by itself, give a uniform proof — but it removes the "we can't even conjecture PG(4,3)"
gap in D1's outcome table and says the even-dimensional boards behave like the rest so far.

**Natural follow-ups.** The immediate cheap win is extracting the PG(4,3) winning 2nd-player
strategy from the solved memo and feeding it to the mirror/pairing-hunt to see if it has
recognizable structure (the whole program wants a *uniform* proof, and this is the first
even-dim strategy in hand). The next even-dimensional odd-q boards — PG(4,5) (781 pts),
PG(6,3) (1093 pts) — are **not** free: they exceed the solver's 128-bit board word, so
testing whether P persists there needs a wider bitset (`[u64; N]`), a mechanical but real
solver extension. PG(4,3) is the unique even-dim odd-q board that fits 128 bits.

## Guardrails honored

Single-core probes; low memory (orbit counts small and the solve holds only ~25k states —
safe alongside the running C30 Lean cert job; the solve is memcap- and wall-guarded). No
q≥23 grid campaigns, no queens runs. The spectrum proxy in `pg43-sizing.py` is explicitly
unsound-for-proof and was superseded; the exact orbit counts are cross-checked against the
unconditionally-complete unrestricted frame-min, and the **solve's memo key is sound by
construction** (a genuine projective image), so the P verdict does not depend on the canon
being minimal — only on its soundness, which is a one-line argument (inequivalent caps have
disjoint image sets).

## Artifacts

- `notes/2026-07-09-pg43-sizing.py` — raw growth + spectrum sizing probe.
- `notes/2026-07-09-pg43-orbit-sizing.py` — Python orbit-BFS prototype (canon validated).
- `notes/2026-07-09-pg43-solver.rs` — **the Rust orbit-canon solver** (verdict + orbit BFS +
  calibration + invariance/gold self-tests + move-order/canon cross-check knobs). Build:
  `rustc -O -C target-cpu=native notes/2026-07-09-pg43-solver.rs -o /tmp/pg43`;
  run `/tmp/pg43 solve 4 3`, `/tmp/pg43 validate`, `/tmp/pg43 orbit 4 3 <maxk>`.
