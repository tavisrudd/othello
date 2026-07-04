# The almost-mirror method: D1 refuted, repair anatomy, and the S2 candidate (2026-07-03)

**Status: INTERIM-FINAL** — session cut short at the certificate-uniformity stage (§5);
everything above §5 is complete and self-standing. **Headline: Conjecture D1 is FALSE —
refuted at n=10 by verified, reachable counterexamples (G = 3 at scar budget d = 1,
even with an empty scar).** The almost-mirror/budget road to bounding G is closed at
its first rung; the surviving theorem shape is the oracle-conditional S2 (§6), which is
proven here in its conditional form.

**Scope**: THEORY + scratchpad Python only. No builds, no solver runs, no git-state
changes. Executes the top CGT items of the
[external-review backlog](2026-07-03-external-review-and-backlog.md) (next steps 1, 3,
4, 6). Companions: [cgt-laws](2026-07-03-cgt-laws-and-tricks.md) (Theorem S1,
Conjecture D1 §4.3/§6, parity-flip lemma),
[winning-geometry](2026-07-03-winning-geometry-n20.md),
[conjecture theory](2026-07-02-a344227-conjecture-theory.md) (Lemma 1/2, Theorem 3).

**Scripts** (this session, git-tracked): `notes/scripts/2026-07-03-almost-mirror/` —
`d1_verify.py` (full-DAG D1 verification + strike/repair anatomy + fine structure),
`d1_counterexamples.py` (independent recheck + placement witnesses + D4 classes),
`strategy_compiler.py` (pairing-plus-exceptions defense extraction). They import the
2026-07-03-geometry lab. All runs single-threaded, seconds-to-minutes, RSS ≤ ~0.5 GB
(box watched; the 17 GB computation untouched).

**Status labels**: PROVEN / COMPUTED (exhaustive at the stated range) /
TESTED-CONSISTENT / REFUTED / CONJECTURE.

**Notation** (even n): `ρ(r,c) = (n−1−r, n−1−c)`; a *symmetric* position is a
ρ-invariant available set reachable in play; `𝒮_d` = symmetric positions with exactly
`d` live long-diagonal ρ-pairs. For `A ∈ 𝒮_1` with live pair `{e, ē = ρ(e)}`
(mutually attacking, same long diagonal):

- `A_e = A ∖ N[e]` — the **strike child** (`G(A_e) = G(A_ē)`, since `A_ē = ρ(A_e)`);
- `Δ = A_e ∩ N[ē]` — the **scar**: squares surviving the strike whose ρ-partner died
  with it (they lie on the three lines through `ē` other than the shared diagonal);
- `C = A_e ∖ N[ē]` — the **core**: ρ-invariant and diagonal-free;
- `A_s = A ∖ N[s]` for non-diagonal `s`; `A' = A_s ∖ N[ρs]` — the **mirrored-exchange
  grandchild** (always symmetric, `d(A') ≤ 1`).

---

## 1. Conjecture D1 — REFUTED at n = 10 (COMPUTED, exhaustive n = 6, 8, 10)

**D1 (cgt-laws §4.3/§6)**: `A ∈ 𝒮_1 ⟹ G(A) ≤ 1`. TESTED-CONSISTENT at n ≤ 8; **FALSE
at n = 10.**

### 1.1 Method and verdict

Full game DAG (every reachable position, full-mex Grundy, no pruning) at n = 6, 8, 10;
filter ρ-invariant positions; bucket by `d`. This upgrades the prior enumeration in one
way: the DAG filter catches symmetric positions with **no symmetric placement witness**
(reachable only through asymmetric placements whose deletion sets happen to be
ρ-invariant) — the symmetric-play enumeration missed those.

| n  | reachable positions | symmetric | DAG-only symmetric | d=1 count | d=1 G-histogram        | D1       |
|----|---------------------|-----------|--------------------|-----------|------------------------|----------|
| 6  | 1,562               | 27        | 0                  | 8         | {0:4, 1:4}             | holds    |
| 8  | 70,258              | 155       | 10                 | 52        | {0:20, 1:32}           | holds    |
| 10 | 4,415,447           | 1,120     | 82                 | 246       | {0:96, 1:110, 2:4, 3:36} | **FALSE** |

d-histograms (count : max G): n=6 `{0:(13,0), 1:(8,1), 2:(5,1), 6:(1,1)}`; n=8
`{0:(49,0), 1:(52,1), 2:(28,3), 3:(20,3), 4:(5,3), 8:(1,3)}`; n=10
`{0:(347,0), 1:(246,3), 2:(296,6), 3:(148,5), 4:(40,4), 5:(32,5), 6:(10,0), 10:(1,0)}`.
The proven `d=0 ⟹ G=0` leaf reconfirmed at all three sizes. Note the n=10 `d=2` bucket
reaches **G = 6** — double any board-level value ever seen.

### 1.2 The counterexamples, verified and characterized (COMPUTED)

The 40 violating positions form 10 D4-orbit classes: eight classes with G = 3 on only
6–8 live squares, plus two 20-live classes (G = 3 with `|Δ| = 4`; G = 2 with
`|Δ| = 5`). Every class was **re-verified on an independent Grundy implementation**
(`cgtlib.make_grundy`, different code path) and given an **explicit placement
witness** (an independent queen set whose available set equals the position), so all
are genuinely reachable — in fact all witnesses found are themselves ρ-symmetric
placements. The sharpest specimen (`d1_counterexamples.py`, n = 10):

```
Q at (0,4),(2,1),(4,7),(5,2),(7,8),(9,5)   live: o / pair: E      G = 3
   . . . . Q . . . . .
   . . . . . . . . . o        live = { (1,9), (3,3)=e, (3,9), (6,0),
   . Q . . . . . . . .                 (6,6)=ē, (8,0) }  plus pair
   . . . E . . . . . o        d = 1, and Δ = ∅ — the strike leaves a
   . . . . . . . Q . .        perfectly symmetric P-residual, yet
   . . Q . . . . . . .        G(A) = 3.
   o . . . . . E . . .
   . . . . . . . . Q .
   o . . . . . . . . .
   . . . . . Q . . . .
```

Structural readings:

- **`Δ = ∅` does not save D1.** Four of the ten classes have an empty scar. `Δ = ∅` is
  equivalent to `e, ē` being live true twins (`N[e] ∩ A = N[ē] ∩ A`; Lemma C below),
  the tamest conceivable diagonal pair — and G still reaches 3. The value is
  manufactured entirely by the **non-diagonal children**: asymmetric intermediate
  positions realize values 1 and 2 that no mirror argument controls.
- **Size is not the driver.** The G = 3 classes have 6–8 live squares — the same scale
  as the n ≤ 8 d=1 positions that all had G ≤ 1. What changed at n = 10 is the residual
  *graph shape* (long border files supply 3-cliques with cross-links unavailable on
  smaller boards).
- **Consequences.** The conditional engine leaf of cgt-laws §4.3 (symmetric one-pair
  state with heap `h ≥ 2` is an instant mover win) is **dead** — do not wire it in. The
  cgt-laws prediction that "a counterexample at n = 10 would kill budget-style
  boundedness for good" has fired: after `G ≤ d` fell at d = 2 (n=8), now even d = 1
  bounds nothing. **`d` measures mirror-obstruction, not game value.**

### 1.3 The n ≤ 8 fine structure (COMPUTED) — and its collapse at n = 10

For each `A ∈ 𝒮_1` and non-diagonal live `s`, classify `A_s` by the mirrored-exchange
grandchild `A'`. Joint histogram (strike child P?, exchange kills pair?, `G(A')`,
`G(A_s)`), counts n=6 / n=8:

| strike child | pair after exchange | G(A') | G(A_s) | n=6 | n=8 |
|--------------|---------------------|-------|--------|-----|-----|
| N (G ≥ 1)    | dead (d=0)          | 0     | 1      | 16  | 104 |
| N (G ≥ 1)    | dead (d=0)          | 0     | 2      | 16  | 0   |
| P (G = 0)    | alive (d=1)         | 1     | 0      | 0   | 32  |
| P (G = 0)    | dead (d=0)          | 0     | 2      | 16  | 64  |
| P (G = 0)    | dead (d=0)          | 0     | 3      | 16  | 32  |

At n ≤ 8 this supported a complete induction package: **H1** (value formula:
`G(A) = 1 ⟺ G(A_e) = 0`), **mirror-or-P** (every non-diagonal child is either refuted
by `ρ(s)` or is itself P), and a uniform sum-repair (every pair-killing `A_s` from a
`G(A_e)=0` position has the surviving pair square as a value-1 child — the defender of
`A + *1` counter-strikes it). At n = 10 **every one of these fails**: H1 has 20
violations (including `G(A) = 2` with `G(A_e) = 4` — a refutable strike on an
N-position); mirror-or-P fails in 168 child cases (winning refutations are scar-line
or unclassified squares, not the mirror); 40 pair-killing cases have **no value-1
child at all**; and the n=10 fine table populates rows (pair-preserving exchanges from
strike-refutable positions, `G(A') = 3` grandchildren) that were empty at n ≤ 8. The
n ≤ 8 cleanliness was a small-board artifact, not the first rungs of a theorem.

### 1.4 Strike-repair anatomy (COMPUTED n = 6, 8, 10)

For every strike-refutable `A ∈ 𝒮_1` (`A_e` is N), classify all winning replies `t`
in `A_e`:

| n  | positions | replies | t ∈ Δ | kills whole scar | residual ρ-symmetric | residual closed-paired (S1) | positions with NEITHER |
|----|-----------|---------|-------|------------------|----------------------|------------------------------|------------------------|
| 6  | 4         | 4       | 4     | 4                | 4                    | 0 (all symmetric)            | 0                      |
| 8  | 20        | 48      | 48    | 36               | 36                   | 12                           | 0                      |
| 10 | 116       | 232     | 176   | 104              | 96                   | 56 (of 136 checked)          | **16**                 |

- At n ≤ 8: **every winning repair is a scar move** (`t ∈ Δ` — the parity-flip lemma's
  "scar moves are answered by scar moves" holds exactly), and killing the whole scar
  coincides per-reply with restoring exact ρ-symmetry ("perfect repair"); every
  non-perfect repair residual admits a static closed pairing. **Zero deep repairs.**
- At n = 10 all three regularities degrade: repairs from outside the scar exist (56 of
  232), kills-scar and perfect-repair decouple (8 mismatches), and **16 positions admit
  only "deep" repairs** — winning replies whose residual is neither symmetric nor
  closed-pairable, i.e. P-positions with irreducible strategy content. (No conflict
  with cgt-laws §1.2, which searched opening residuals; but the same lesson at smaller
  scale: static S1 certificates run out exactly where the induction needs them.)

---

## 2. Proven fragments (these survive the refutation)

Setting: even n, `A ∈ 𝒮_1` with pair `{e, ē}`.

**Lemma A (mirror leaf; known, restated).** `A ∈ 𝒮_0 ⟹ G(A) = 0`.
*Proof.* `π = ρ|_A` is a fixed-point-free involution (even boards have no ρ-fixed
cell); `d = 0` means no live self-mirroring square (Lemma 1 of the conjecture note:
self-mirroring = long-diagonal), so S1(a) holds; S1(b) is automatic for an automorphism
(`N[ρv] = ρN[v]`). Theorem S1 applies. ∎

**Lemma B (strike-child decomposition).** `A_e = C ⊎ Δ` with `C` ρ-invariant and
diagonal-free, and the asymmetry defect of `A_e` is exactly `Δ`: for `x ∈ A_e`,
`ρ(x) ∉ A_e ⟺ x ∈ Δ`.
*Proof.* `ρ(x) ∉ A_e` means `ρ(x) ∈ N[e]` or `ρ(x) ∉ A`; the latter is impossible for
`x ∈ A` (ρ-invariance). `ρ(x) ∈ N[e] ⟺ x ∈ ρN[e] = N[ē]`, and `x ∈ A_e` gives
`x ∉ N[e]`, so `x ∈ Δ`. Conversely `x ∈ Δ ⟹ ρ(x) ∈ N[e]`. `Δ` avoids the shared long
diagonal because that line lies inside `N[e]`. ∎

**Lemma C (empty scar ⟺ twin pair; strike is then safe).** `Δ = ∅` iff
`N[e] ∩ A = N[ē] ∩ A` (the pair squares are live true twins), and then
`A_e = C ∈ 𝒮_0`, so `G(A_e) = 0` and `G(A) ≥ 1`.
*Proof.* `Δ = ∅` means `A ∩ N[ē] ⊆ A ∩ N[e]`; applying ρ gives the reverse inclusion.
Then `A_e = A ∖ (N[e] ∪ N[ē])`, which is ρ-invariant and diagonal-free; Lemma A. ∎
(The converse — `Δ ≠ ∅ ⟹ G(A_e) ≥ 1` — is false: computed counterexamples at every
n ∈ {6, 8, 10}. And Lemma C does NOT bound `G(A)` above: the §1.2 counterexample has
`Δ = ∅` and `G = 3`.)

**Lemma D (pair-killing mirror refutation).** If non-diagonal `s` is live in
`A ∈ 𝒮_1` and `d(A') = 0`, then `ρ(s)` is a winning reply to `s`: `G(A') = 0`.
*Proof.* `s` non-diagonal ⟹ `ρ(s) ∉ N[s]` and `ρ(s) ∈ A`, so the reply is legal; `A'`
is ρ-invariant with `d = 0`; Lemma A. ∎

**Lemma E (heap-strike duality).** For `A ∈ 𝒮_1` with `G(A_e) = 0`, the second player
of `A + *1` answers a heap move with the strike and a strike with the heap move; both
replies reach P-positions. *Proof.* `G(A_e) = G(A_ē) = 0 = G(A_e + 0)`. ∎

**Proposition F (what remains of D1's N-side).** If `A ∈ 𝒮_1` and `G(A_e) = 0` (in
particular whenever `Δ = ∅`), then `A` is an N-position. *Proof.* The strike is a move
to a P-position. ∎ — This, plus Lemmas A–E, is the full salvage: **outcome statements
survive; no value bound does.**

---

## 3. Where the proof died, precisely — and the minimal repair that is still true

The almost-mirror proof of D1 was a two-sided induction; both sides are now refuted as
*general* laws, and the data pinpoints the failure:

1. **P-side (`G(A_e) ≥ 1 ⟹ G(A) = 0`)** needed: every non-diagonal child refutable.
   Pair-killing children: refuted by the mirror (Lemma D, PROVEN). Pair-preserving
   children: needed "strike-refutability persists under mirrored exchanges"
   (`A_e` N ⟹ `A'_e` N). This row of the fine table is empty at n ≤ 8 (untestable
   there) and **false at n = 10**: `G(A) = 2, G(A_e) = 4` counterexamples show a
   refutable strike sitting on an N-position — some non-diagonal child is P even
   though the mirror grandchild has `G(A') = 3`.
2. **N-side (`G(A_e) = 0 ⟹ G(A) = 1`)** needed: no value-1 child. Via Lemma E the
   heap handles strike/heap moves; the gap was pair-killing children, where the n ≤ 8
   repair (counter-strike the surviving pair square, value exactly 1) fails at n = 10:
   40 such children have **no value-1 child at all** (`G(A_s) = 1`, which makes
   `mex ≥ 2` at the parent — these are the G = 3 counterexamples).

**Minimal strengthened hypothesis that survives all data**: none worth stating in
budget form. Any hypothesis of the shape "d small + scar small/empty + pair-twin ⟹
G ≤ 1" is refuted (§1.2: `d = 1`, `Δ = ∅`, twins, G = 3). What is actually true and
proven is Proposition F (outcome) and the oracle-conditional S2 (§6): boundedness must
be *purchased per position* by exhibiting the defender's repair oracle; no static
invariant of the position class supplies it. This redirects the Border Battle: the
`d = 1` case was supposed to be "Δ-battle with one event"; the refutation shows even
one event has irreducible strategy content, so **Conjecture BB-style theorems must be
stated (and if true, proven) with the reply oracle as an explicit object** — which is
a finite certificate per n, not a uniform lemma.

---

## 4. Defender-reply extraction (the S2-shape probe) — COMPUTED n = 6, 8

`strategy_compiler.py` compiles the winner's full defense of each winning opening's
residual `P0` (every intruder move at every reachable P-node) under the policy "play
`π(s)` if live and winning, else mint/reuse an exception keyed by the intruder square
`s`", for `π` = the best point-reflection (all centers swept, depth-1 coverage).

n = 6 (all five winning-opening classes) and n = 8 (the unique winner c*):

| opening (n)   | best π center [is it τ_w = 2w?] | depth-1 π coverage | decisions | paired | exceptions (mint/reuse) | key conflicts | max repair events per line | mint residual: sym / paired / none |
|---------------|----------------------------------|--------------------|-----------|--------|--------------------------|---------------|----------------------------|-------------------------------------|
| (2,2) c* (6)  | (4,4)  YES                       | 0.50               | 64        | 28     | 25 / 11                  | 10            | 2                          | 24 / 1 / 0                          |
| (1,1) (6)     | (7,7)  no                        | 0.44               | 68        | 18     | 35 / 15                  | 19            | 2                          | 31 / 2 / 2                          |
| (0,0) (6)     | (7,7)  no                        | 0.40               | 68        | 16     | 42 / 10                  | 24            | 2                          | 35 / 4 / 3                          |
| (1,2) (6)     | (7,4)  no                        | 0.44               | 59        | 18     | 32 / 9                   | 16            | 2                          | 26 / 4 / 2                          |
| (0,2) (6)     | (9,4)  no                        | 0.40               | 70        | 10     | 39 / 21                  | 21            | 2                          | 31 / 3 / 5                          |
| (3,3) c* (8)  | (6,6)  YES                       | 0.44               | 944       | 214    | 363 / 367                | 327           | **3**                      | 298 / 45 / 20                       |

Readings (the empirical shape S2 must capture):

- **The winner's pairing about c\* is point-reflection about his own queen** (τ_w is
  the best center at both n=6 and n=8 central openings) — matching the n=18 PV's
  τ-posture. For non-central winning openings the best center drifts off `2w` (the
  defense is not "reflect about the placed queen" in general).
- **Repair events per line are genuinely bounded and tiny**: at most 2 (n=6) and 3
  (n=8) exceptions on any play line, against game lengths of 6–10 plies. The "pairing
  punctuated by bounded repair events" picture is CORRECT as a description of the
  winning strategy.
- **But the exceptions are not move-class-keyed**: at n=8, 327 of 363 mints are key
  conflicts (the same intruder square demands different replies in different
  contexts), and every one of the 36 first-ply squares eventually needs an exception
  entry somewhere in the tree. A context-free `s → reply` table does NOT compile the
  strategy; keys must include position context.
- **Most repairs re-close a static structure**: at n=8, 298 of 363 mint-residuals are
  exactly symmetric (the repair restores the pairing), 45 more admit a fresh closed
  pairing; 20 are "deep". Repair triggers at n=8: scar strikes 427, off-board partners
  265, live-but-losing partners 38 — the last class is the S1(b)-failure mode the
  static theory cannot see.

---

## 5. Certificate-uniformity probe at n = 10 / 12 — CUT SHORT

Session ended before the refuter-side runs (`strategy_compiler.py 10` / `12` —
diagonal-opening refutations, book reply + compiled defense, exception counting).
Next step: run exactly those two drivers (the code is committed and tested at n ≤ 8;
the n=10 run failed only on a launch-path slip). Expectation calibrated by §4: the
mirror-plus-exceptions certificate will compile with small per-line event counts but
context-dependent keys; the open question is the table growth rate n=10 → 12.

---

## 6. The S2 theorem — conditional form PROVEN, and what the refutation teaches

The cgt-laws note left S2 as a schema. Here is the precise statement, with proof; the
D1 refutation makes this the *only* live theorem shape for the even-board program.

> **Theorem S2 (event-paired scars, oracle-conditional).** Let `A = P ⊎ S` be a
> position and `π : P → P` a fixed-point-free involution with
> (a) `π(v) ∉ N[v]` for all `v ∈ P`;
> (b) `(N[v] ∪ N[π(v)]) ∩ P` is π-invariant for all `v ∈ P`.
> Call a pair of moves `(s, r)` with `s, r ∈ S` a *couple* if `r ∉ N[s]` and
> `(N[s] ∪ N[r]) ∩ P'` is π-invariant in the current position `P' ⊎ S'`.
> Suppose the defender has a **reply oracle**: for every position `P' ⊎ S'` reachable
> under the protocol below with the mover playing any `s ∈ S'`, some `r(P', S', s)`
> completing a couple. Then the protocol — answer `v ∈ P'` with `π(v)`, answer
> `s ∈ S'` with the oracle — is winning for the second player: `G(A) = 0`.

*Proof.* Induction on `|A|`. Invariant: `P'` is π-invariant and (a), (b) hold on it
(both restrict to subsets as in the S1 proof, since an intersection of π-invariant
sets is π-invariant). If the mover plays `v ∈ P'`: `π(v) ∈ P'` (π-invariance) and
`π(v) ∉ N[v]` (a), so the reply is legal; the two moves delete
`(N[v] ∪ N[π v]) ∩ P'` from `P'` — π-invariant by (b) — and some subset of `S'`
(unconstrained). If the mover plays `s ∈ S'`: the oracle's `r` is legal and the couple
deletes a π-invariant subset of `P'` and some subset of `S'`. Either way the defender
always has a reply and the invariant is restored on a strictly smaller position; the
defender makes the last move. ∎

Remarks:

- **The parity-flip lemma is built in**: couples are S-answered-by-S; one unanswered
  S-move flips the paired region to a lost P-position (cgt-laws §1.1), so the oracle's
  totality is not a convenience but a necessity — this is the exact soundness
  boundary.
- **For queens, condition "(c) `N[s] ∩ P` π-invariant per single `s`" is false at the
  root** (a diagonal strike's deletion is one-sided — that is what Δ *is*, Lemma B),
  so the couple form above, where only the JOINT deletion must be π-invariant, is the
  right queens instance: the repair move must complement the strike's scar. The n ≤ 8
  repair anatomy (§1.4) shows this literally: winning repairs sit in Δ and re-close
  the pairing.
- **What D1's refutation teaches about S2**: the oracle clause cannot be discharged by
  any budget-style position invariant — not pair count, not scar size, not twin
  structure (§3). S2 is a *certificate format*, not a self-contained law: per
  position (or per n at the border, where B1 bounds couples at one), oracle existence
  is a finite check. The compiled defenses (§4) confirm the format is faithful —
  real winning strategies ARE pairings punctuated by ≤ 2–3 repair events per line —
  and simultaneously show the oracle is context-keyed (327 move-class conflicts at
  n=8), so certificate compression must key exceptions on more than the intruder's
  square.
- **Falsification target for the S2 program**: the 16 deep-repair positions at n = 10
  (§1.4) — winning repairs whose residuals carry no static pairing. If the S2 format
  is to certify those, the oracle must recurse (pairing-of-pairings); check whether
  the deep residuals are themselves S2-certifiable with a nontrivial `S`-split. That
  is the next concrete experiment (one scratchpad session; positions are ≤ 7 live
  squares).

---

## 7. Claim-status summary

| claim                                                                     | status                              |
|---------------------------------------------------------------------------|-------------------------------------|
| D1 (`𝒮_1 ⟹ G ≤ 1`)                                                        | **REFUTED** (COMPUTED n=10, exhaustive; verified independently + witnesses) |
| d=1 G-histograms n = 6, 8, 10; d=2 reaches G=6 at n=10                     | COMPUTED                            |
| Δ = ∅ ⟺ pair true-twins; then strike child ∈ 𝒮_0 (Lemma C)                 | PROVEN                              |
| `𝒮_1` with strike child P is an N-position (Prop F)                        | PROVEN                              |
| pair-killing non-diag moves are mirror-refuted (Lemma D)                   | PROVEN                              |
| value formula H1, mirror-or-P, counter-strike repair                       | held n ≤ 8; **REFUTED at n = 10**   |
| all winning strike-repairs lie in the scar                                 | COMPUTED n ≤ 8; fails n = 10        |
| every strike-refutable `𝒮_1` position has a statically-certified repair    | COMPUTED n ≤ 8; **fails n = 10** (16 deep-only) |
| winner's pairing at c* = point-reflection about own queen (n=6, 8; n=18 PV)| COMPUTED (best-center sweep)        |
| repair events per optimal-defense line bounded (2 at n=6; 3 at n=8)        | COMPUTED                            |
| move-class-keyed exception table suffices                                  | **REFUTED at n = 8** (key conflicts dominate) |
| Theorem S2, oracle-conditional form                                        | PROVEN (this note, §6)              |
| oracle existence reducible to a static budget invariant                    | REFUTED (the D1 counterexamples)    |
| certificate-uniformity numbers at n = 10/12                                | CUT SHORT — next session (§5)       |
