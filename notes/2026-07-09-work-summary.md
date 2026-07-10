# Repo Scope Summary — `othello` workspace

A cross-thread synthesis of scope, agenda, results, dead ends, frontier, and tooling.
(Companion week-by-week activity log: [`2026-07-09-work-summary-timeline.md`](2026-07-09-work-summary-timeline.md).)

---

## 0. What this repo is

It began as an **Othello/Reversi engine** (Python package + a high-performance Rust port with an
endgame solver). That engine still lives here and still passes its gates, but the work now is a
**combinatorial game theory (CGT) research program** on a family of impartial *placement / avoidance*
games, backed by:

- a fleet of exact solvers (Rust + Go + Python),
- a bespoke game-tablebase + query/mining toolchain,
- a `sorry`-free **Lean 4 / Mathlib** formalization layer,
- a git-tracked handoff/notes system driving a multi-agent (Fable / Codex / Claude) workflow.

The center of gravity is the **projective cap ("Nofil") program** and its **odd projective-plane
kernel**, with the Lean layer certifying results as they land.

---

## 1. The unifying frame

Every game studied here is one object: an **impartial, normal-play building-avoidance game on an
incidence hypergraph**, where legal positions are *line-capacity independent sets*. Given points,
line families, and per-line capacities `c(L)`, a move adds a point keeping `|S ∩ L| ≤ c(L)` for
every `L`; the last player able to move wins. `P` = second-player win; `N` = first-player win.

| Instance                      | Capacity / lines                           | Reduces to                               |
|-------------------------------|--------------------------------------------|------------------------------------------|
| Non-attacking **Queens**      | capacity-1, four affine directions         | Node-Kayles on the queen graph           |
| **Cap / Nofil** (aff./proj.)  | capacity-2, all lines of a finite geometry | Nofil on the collinearity-triple 3-graph |
| **Sum-free** on abelian `G`   | Schur-triple hypergraph (`a+b=c`)          | Nofil on the Schur 3-graph               |
| **Cap-set** on `F₃ⁿ`          | capacity-2 (`a+b+c=0`); `STS(3ⁿ)`          | affine cap game                          |
| **Node-Kayles**               | the capacity-1 / saturated-residual limit  | itself (the substrate)                   |

**Novelty posture (deliberately conservative):** a *structured finite-incidence subfamily* of the
published Sieben / Huggan–Huntemann–Stevens (HHS) hypergraph building-avoidance genus — **not a new
class of games**. The bare "Nofil = Node-Kayles on a saturated residual" collapse is prior art; only
the *structured* collapse (residual slacks, mirror obstructions, conic localization) is claimable.
Transfer runs **queens → cap** only, and the `c=1` mirror facts are folklore — only the `c ≥ 2`
mirror/slack analysis is new.

---

## 2. The five threads

| Thread                  | What it is                                        | State                                      |
|-------------------------|---------------------------------------------------|--------------------------------------------|
| **Projective cap**      | `PG(n,q)` cap/Nofil outcome theorem               | **Active frontier.** Odd-plane kernel open |
| **Queens**              | Non-attacking queens game + A344227 nimbers       | n=18 outcome solved; G(18) nimber open     |
| **Sum-free / cap-set**  | Achievement game on abelian groups / `F₃ⁿ`        | Core theorems proved + Lean; one slice open|
| **Node-Kayles**         | Graph/Cayley substrate for all of the above       | Outcome laws proved; classic opens remain  |
| **Othello**             | Rust port of the Python engine + endgame solver   | Stable, gate-green, effectively archived   |

---

## 3. Proved / closed (results ledger)

### Projective cap — closed families
- **`AG(n,q)` is P** for every finite affine space, every `q`. *(Lean: `CapGame/Affine`.)*
- **`PG(n,2)` is P** for every `n ≥ 1` (binary case = Nofil on projective Steiner triple systems).
  *(Lean: `Binary`.)*
- **`PG(2m−1,q)` is P** for every odd `q` — fixed-point-free elliptic projective involution.
  *(Lean: `EllipticMirror`.)*
- **`PG(2,q)` is P for all even `q`** (char-2 residual translation mirror). *(Lean: `PlaneOutcome`.)*
- **Odd planes, per-`q`:** `q=5,7` P by a **mechanism** theorem (not enumeration); `q=11,13` P by
  **kernel-checked certificate assembly** — all four Lean-closed. `q=3,9,17,19,23` computed P (q=23
  via the 22-bucket full-`PGL(2,23)` on-conic census + the full-PGL bridge), not yet Lean-closed;
  `q=25` partial S4-rooted probe only.
- **Classical-variety harvest (C48/C51/C52)** — new P-families from the generic fpf-involution
  mirror: hyperbolic quadric **`Q⁺(2m−1,q)`**, symplectic polar space **`W(2n−1,q)`**, and Segre
  products **`PG(a,q)×PG(2m−1,q)`**, all P for odd `q`. *(Lean: `HyperbolicQuadricMirror`,
  `PolarSegreMirror` — reusable `c=2` mirror engine + grid-rook base fully proven; higher
  instantiations statement-level.)* **Boundary theorem:** odd ambient dimension is necessary but not
  sufficient — the isometry group must contain an fpf involution (elliptic/parabolic/Hermitian are
  *mirror* negatives; outcome may still be P by other means).

### Queens
- **Outcome settled through n=18.** Odd `n` → first; `n∈{4,6,8}` → first; `n∈{10,12,14,16}` → second
  (reproduces Jenrich); **`n=18` → first player**, witness opening **I9 = (8,8)** + a 15-ply PV, two
  independent leaf configs agreeing byte-for-byte.
- **A344227 nimbers beyond the catalogued n=13:** **G(14)=0, G(15)=1, G(16)=0, G(17)=2** (G(17)=2
  **verified**, ~585B nodes). **G(17)=2 falsifies the `G(n)∈{0,1}` conjecture** (first value >1 since
  G(7)). n=18 first-player win only fixes `G(18)≠0`.
- **Theorems:** self-mirroring-square lemma; odd-`n ⇒ G≥1`; even-`n` first-win *requires* a
  long-diagonal move. **Lean:** the `getK` leaf evaluator's recurrence, iso/induced invariances, and
  Grundy characterization machine-checked (`no sorry`).

### Sum-free / cap-set
- **`Z_n` mod-6 law:** for `n ≥ 5`, second player wins **iff `n ≡ 0,1,5 (mod 6)`**. *(Lean.)*
- **Abelian 2-rank criterion:** with 2-rank `s₂`, `τ₃=[3∣|G|]`: **P iff `s₂ ≥ 2`, or (`s₂ ≤ 1` and
  `s₂ = τ₃`)** — proven in the `r₃ ≤ 1`/`s₂ ≥ 2` range. New phenomenon: `Z₂²×Z₉ = P` though
  `Z₉ = N`. *(Lean via the `r₃ ≤ 1` wrapper.)*
- **`F₃ⁿ = N` for all `n`** (settles `F₃⁴/F₃⁵` with no compute); **`Z₂ × F₃ᵇ = P` for all `b`.**
  *(Lean.)*
- **Cap game `AG(n,q) = P` for every `n` and `q`** — settles the cap-set achievement game in **every
  dimension including d=5**. *(Lean: `CapGame/Affine`.)*

### Node-Kayles
- **Cayley outcome law:** P-positions pairing-explained (even order); N-positions mostly not (Paley
  `p ≡ 5 mod 8` lives in the un-pairable gap).
- **`C_n^k` = octal `0.[1×k][3×k]7`:** `k=1` = Dawson's chess (period 34); `k ≥ 2` aperiodic.
- **Double-encoding gap CLOSED** (`29c5349`): vertex-deletion ≡ independent-set-building.
  *(Lean: `ConflictGameEquiv`.)*

---

## 4. Explored and pruned as dead

**Projective / odd-plane** (do not restart without new premises): single fixed involution (killed by
exhaustive tests); play-closed symmetric family `resym` (dead q≥11); naive parity (breaks q=11);
`bad = o(q²)` (refuted q=17, 152/157); static feature dictionary (C18 null); size-4
mirror-certificate compression (zero hits); mixed-column mod-3 law (C29 refuted at q=23); primary
composite mirror (C32, PG(4,3) fails the seed obligation); **conic ⊕ zone Grundy decomposition —
C35 empirically FALSE** (the obstruction is a *coupled* invariant, not a disjunctive sum);
reservoir → Hall/matching transfer (dead below q=38); finite type → value table for on-conic
children (119 shared configs flip value across q).

**Queens:** SG component decomposition for n=16 (tail 97–100% single-component); modular/twin
reduction (0% at pc≥13); DFS tail parallelization (transposition-saturated); K=17 dense (negative;
W_K node-cut lever exhausted at K=16, u128 ceiling); ply-windowed BuRR retrograde (forfeits α-β);
SMT scheduling / PGO past +2.6% / getK vectorization / warm-restart / degree-sort (wash-to-negative).
**"Hard floor" claims are wrong** — the default n=16 solve runs **13.43s**, well under prior floor
estimates, which were measurement artifacts of a memory-degraded box.

**Sum-free:** **socle reduction `G(G)=G(G[6])` — FALSE** (`Z₃²×Z₇ = P` while `G[6]=Z₃²=N`, two
independent solvers; the coprime factor's *size* flips the outcome); socle reduction is not a mirror;
twisted-`ρ` mirror, combined B+negation, bounded-defect, automorphism pairing, static F₃-color
monovariant — all fail off pure `F₃ʳ`.

**Node-Kayles:** trees bounded-state DP (unbounded context classes); nimber-transfer-matrix
periodicity (infinite state); budget conjecture `d=1 ⇒ G≤1` (refuted at n=10, G=3); capacity-`c`
mirror lift for `c ≥ 3` (genuine counterexample in `PG(2,q)`).

---

## 5. The frontier

**Primary open problem — the odd projective-plane kernel:** prove `PG(2,q)` is P for every **odd
`q`**. Evidence says this is **not** another static mirror. The live route is a reduction chain,
Lean-anchored at both ends:

```
frame reduction  (PG(2,q)=P ⟺ a single 4-cap frame is P; Lean)
  → residual q×q grid game  (affine caps + one point per burned row/column)
  → size-3 escape crux  (each size-3 residual has exactly q²−9q+21 legal size-4 children; Lean)
  → conic localization  (size-3 + burned dirs = a 5-arc ⇒ unique conic)
  → intrusion / Node-Kayles / zone-steering
```

- Equivalence **`PG(2,q)=P ⟺ OddEscapeStatement`** proved **both directions** in Lean
  (`TrapConverse`) — a found residual trap is now a Lean-certifiable projective counterexample.
- Sharpest target: **(ON)** every size-3 residual has a P-valued **on-conic** size-4 child (verified
  through q=19; q=23 all-P on-conic bucket census).
- For **q ≥ 23** the live conic cannot be emptied at the two-ply layer, so the target is
  **live-conic xor-zero maintenance**: every first move has a P-reply with conic Node-Kayles xor 0
  (within the first four zero-xor candidates); one bucket (`1,3,4,9`) is verified maintainable through
  one further coupled move (28,646/28,646 obligations). Termination not proved.
- **Even-dimensional odd-`q` (`PG(2m,q)`, m≥2) is an evidence vacuum** — no such board has ever been
  exactly solved. **C43** sizes an exact `PG(4,3)` solve; an N verdict would be the program's first N
  geometry.
- Prize calibrated ~20–25%, de-risked into the D-items (§8).

**Queens:** exact **G(18)** (the nimber; outcome already settled). ~300–500B nodes, ~1.5–2 days per
ascending-`k` round, **no checkpoint/resume**; policy is `k=1` first (~55% one-shot). Further out:
n=20 outcome (conjectured first, witness (9,9)); nimbers past n=17.

**Sum-free:** the abelian slice **`s₂ ≤ 1 ∧ r₃ ≥ 2`** (never occurs in `Z_n`); conjecture
`Z₃²×Z_p = N` iff `p=5` (verified `p=5→N`, `p=7→P`; `p ≥ 11` compute-infeasible).

**Node-Kayles:** Paley `p ≡ 5 mod 8 ⇒ G=1` (needs Weil/character-sum, not a mirror); 3×N-strip
periodicity (A316632, extended to n=22); Node-Kayles on trees (decades-open).

---

## 6. Tools built

**Rust crate `othello`** (Makefile, znver5 + mold):
- **`othello`** — engine ladder minimax → alphabeta → ordered → **strong** (native PVS + iterative
  deepening + hash-move TT + exact endgame solver) → **strong+** (stronger eval, changes value) →
  **strong++** (adds Multi-ProbCut forward pruning). Bitboard core (Kogge-Stone fills), black-centred
  values (sound TT over the whole game DAG).
- **`queens`** — solver lineage **naive → iso-flat → iso-window → iso-dense** (the `W_K`/`getK`
  Node-Kayles leaf evaluator resolves pc≤K positions directly from complete tables W0..W8 via a
  BMI2-`pext` sweep — no TT probe; n=16 in **13.43s / 178.5M nodes**), plus a heap-sum **nimber
  engine**, a proof-number solver, and HyperLogLog distinct-count sizing. Lockless flat
  `Box<[AtomicU64]>` TT (55-bit fingerprint, huge-pages / `MADV_COLLAPSE`) + a **BuRR** (Bumped
  Ribbon Retrieval) succinct value store (~1.1 bit/key, validated exact on 2B+ keys).
- Micro-benches: `canon_bench`, `iso_key_bench`, `dense_*_bench`, `w9_purity_bench`, etc.

**`gridcap`** (standalone `rustc` solver, `notes/2026-07-06-grid-cap-solver.rs`) — the PG(2,q)
grid-cap engine and host of the **S4 memo-dump / query / mining toolchain**: `s4dump`/`s4gdump`
(P/N and exact `u8` **Grundy** raw dumps, 128-bit **PGL(2,q)-quotiented canonical key**), `s4freeze`
(**BuRR used *lossily*** as a value store — accepted false positives, since the consumer is a
conjecture-miner, not a player; a genuinely fresh CGT move), `s4query` (line-protocol shell:
`state`/`moves`/`play`/`pop`/`replies`), `s4mine`/`s4xormine` (feature + targeted Node-Kayles-xor
reply miners), `s4gcheck`/`s4gmeasure`/`s4gdistill`/`s4gremote` (Grundy validation, strategy-freedom,
remoteness), `s4bucketlist`. Plus `escape`/`esc`/`feat`/`cert`/`certcheck`/`mir`/`resym`.

**Sum-free solvers:** Rust (`sumfree.rs` cyclic Grundy; `capset2/5.rs` u128/256-bit AGL-canonical),
Go (`sumfree.go` full-`Aut(G)` negamax; `sumfree_par.go` sharded-parallel + pairing verifier;
`grundy.go` disjunctive-sum **nimber engine** that solved `Z₃²×Z₇=∗0`), Python cross-checks.
Node-Kayles: Cayley sweep/cert solvers + a fast octal-game engine (`octal.c`).

**Lean 4 layer** — see §7. **Harnesses & analysis:** `queens-ab.sh` (canonical interleaved A/B,
`cyc/node` metric, OOM-safe 12 GB TT), `s4_ml_mine.py` (PCA/decision-tree miner over s4 logs → the
conic-depletion bounds), `s4_raw_isect.py` (raw-dump soundness intersection), border-signature mining
passes, geometry probes (`projcap_mirror_harvest.py`, `polar_space_nofil.py`, `segre_product_nofil.py`).
Pre-commit git hook auto-rustfmts + gates on `make clippy -D warnings`. Committed artifacts:
P-certificates `notes/certs/gridcap-q5..q19.cert`; reproducibility data `notes/data/*.jsonl.gz`; the
sum-free/cap paper skeleton `notes/paper-sumfree-capgame/`.

---

## 7. Lean formalization ledger

**Trust posture:** every terminal theorem's `#print axioms` is exactly `[propext,
Classical.choice, Quot.sound]` — **no `sorry`, no `native_decide`, no custom axioms;
kernel-complete.** Certificate cap-legality is checked by the **Lean kernel** (`decide` /
`checkCap_sound`), not `native_decide` and not trusted.

Five namespaces: **CapGame** (finite build-game kernel + affine cap theorem + reusable mirror
lemmas), **ProjectiveCap** (the flagship — Binary / Elliptic / Hyperbolic / PolarSegre mirrors, the
rank-3 grid model, the `TrapConverse` escape reduction, per-`q` certificate assemblies
`CertData/Q5,Q7,Q11,Q13`), **Sumfree** (mod-6, abelian rank-count criterion, `F₃ⁿ`, `Z₂×V`),
**NodeKayles** (`getK` recurrence + Grundy + double-encoding closure, `no sorry` throughout),
**Queens** (queen board ↦ `NodeKayles.Graph` + n=18/n=20 certificate wrappers, sound *given* a
certificate).

**Lean-open:** odd planes `q=3,9,17,19,23` (q=9 conditional on `IntruderTerminalReplyStatement`); the
**uniform** odd-plane `OddEscapeStatement` (only proved per-`q` via certificates — the intrusion
reductions carry explicit WARNINGs that their no-intrusion hypotheses are *false* for `q ≥ 11`); the
q=17/q=19 generated-cert path (blocked on a `maxRecDepth` refactor).

---

## 8. Publishable deliverables & OEIS

The ~20–25% prize (uniform odd-plane theorem) is de-risked into six independently shippable units:

| ID | Deliverable                                                           | Confidence |
|----|----------------------------------------------------------------------|------------|
| D1 | Outcome-classes paper (all proven families; odd-plane as conjecture) | ~80%       |
| D2 | Corrected capacity-≥2 mirror/pairing principle, Lean-checked          | ~85%       |
| D3 | Conic-localization reduction (first layer = Dawson's chess)          | ~65%       |
| D4 | Machine-verified per-q ladder + kernel-clean Lean formalization       | ~75%       |
| D5 | Sum-free achievement game on abelian groups (the `q=2` sibling)      | ~65%       |
| D6 | Extended non-attacking-queens nimbers past the OEIS horizon           | ~70%       |

Plus a **tooling methods note** (the tablebase-meets-CGT story; BuRR-as-lossy-store + the
PGL-quotiented key are the two fresh wrinkles, the rest competent adoption of strong-solving
technique). Paper in progress: `notes/paper-sumfree-capgame/` (Nofil-genus: the `Z_n` mod-6 law + the
affine cap theorem).

**OEIS:** **A344227** (queens nimbers) sits at rev #54 (`n ≤ 13`); a ready package extends it with
`a(14)=0, a(15)=1, a(16)=0, a(17)=2`. **Submission is a pending user action, blocked on a public
code/preprint artifact — the repo has no public git remote.** A sum-free `Z_n` OEIS draft + b-file
(65 terms) is prepared, verified absent, not submitted. Candidates: torus-queens nimbers, sum-free
outcome indicator, Paley-game sequence, A316632 extension.

---

## 9. Process / infrastructure

- **Multi-agent division of labor:** **Fable** = research lead / planner / reviewer (deliverables
  proposal, task queue, day-plans, line-capacity vets); **Codex** = execution (compute campaigns, ML
  attribution, Lean scaffolds, `[REPORTED]` per-task notes); **Claude/Opus** = a subset incl. the
  C48/C51/C52 mirror harvest + Lean landings, C53.
- **Task queue** (`notes/2026-07-07-codex-task-queue.md`): C1–C28 largely closed; the C29–C54 band
  drives the frontier. Open high-value: **C34** (D1 manuscript), **C43** (PG(4,3) sizing), **C44**
  (q=25 census), **C45–C47** (defect-skeleton / depletion-ladder / minimal-CE constraints), **C50**
  (kernel-checked Grundy certs), **C54** (q=23 bucket-label certification).
- **Named-expert-personas system:** dossiers on real mathematicians (`notes/expert-personas/`) loaded
  as *proof-context lenses* before nontrivial Lean work — Lean-CGT maintainer, finite-group game
  theorist, mirror-strategy skeptic, Mathlib projective geometer, finite-arc specialist,
  complete-arc searcher, formal cap-set methodologist, graph-game certificate engineer.
- **Handoff system:** git-tracked `notes/handoffs/` are the single source of truth; the invisible
  auto-memory holds cross-project preferences only.
- **Validation gates:** queens `solver_lineage_agrees` + exact distinct counts (n=12 = **1,060,823**,
  n=14 ≈ 29.2M) + Jenrich n≤16 reproduction; Othello cross-engine value-equivalence + endgame solves
  **6 / −40 / 4**; Lean axiom-gate discipline.
