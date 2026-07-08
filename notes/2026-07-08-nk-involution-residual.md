# (ON) attack, session 11 (Fable): the conic residual is NODE-KAYLES — Dawson arithmetic on the involution graph

**Date:** 2026-07-08. Continuation of route (B) via the
[intrusion calculus](2026-07-07-onconic-intrusion-calculus.md) (session 9), taking attack
option (ii) — and landing somewhere better than the guessed mechanism. Verifier:
[`2026-07-08-nk-involution-check.py`](2026-07-08-nk-involution-check.py) — **ALL OK, zero
failures**: kill-set law (NK1) 3729 + 3754 checks at q = 11 (exhaustive S₄) / 13 (sampled);
spectrum law (NK2) 1903 + 140 intruder pairs; Grundy-equality (NK3) 4863 + 1436 positions;
plus the q=11 full-game mechanism census (NK4).

## 1. Lemma V (kill-set law ⇒ Node-Kayles form)

> At any position whose played set is `c` conic points + an intruder arc `X`, playing a live
> conic cell `p` makes illegal EXACTLY `{σ_x(p) : x ∈ X}` among the live conic cells (plus
> `p` itself). No other conic cell dies.

*Proof.* A live conic cell `s` dies after `p` iff `s` is collinear with `p` and some played
point `y`. If `y` is a conic point the line `ps` meets `𝒞` only at `p, s` — impossible. If
`y = x ∈ X`: `s` on line `px` ⟺ `s = σ_x(p)`. ∎ (NK1, machine, zero fails.)

**Consequence.** Since each `σ_x` is determined by `x` alone, the graph
`G(X) = (live conic cells, p ~ σ_x(p) for x ∈ X)` is *static*, and conic-restricted play is
literally **Node-Kayles on `G(X)`** (playing a vertex deletes its closed neighborhood).
`G(X)` is a union of `|X|` partial matchings — max degree `|X|`. For `|X| = 1` the components
are `K₂`/`K₁` and Node-Kayles gives `G = parity of M`: Lemma III / §4 of session 9 recovered
exactly. **The project's two threads have met in the middle: the cap-game residual is an
instance of the Node-Kayles program** (queens, circulant outcome law, interval octals), and
the graph-general pairing-lemma bundle (`2026-07-04-nodekayles-pairing-lemmas.md`) now has a
projective-geometry client.

## 2. Lemma VI (two-intruder spectrum = dihedral orbits; cycles are `C_{2d}`)

For two simultaneously-legal intruders `x, x'` with `d = ord(σ_x σ_{x'})`, the union graph
`M_x ∪ M_{x'}` on ALL of `P¹` decomposes into:

- **free-orbit cycles of length exactly `2d`** (alternating σ/σ′ edges around a free
  `⟨σ_x, σ_{x'}⟩`-orbit);
- **the `xx'`-secant pair**: if line `xx'` is a secant meeting `𝒞` at `{s, t}`, those two
  params are the fixed points of `ρ = σ_x σ_{x'}` and form one `K₂` (a double edge) —
  present iff `d | q−1` (split); absent iff `d | q+1` (external line, nonsplit);
- **tangency-ended paths**: the σ-fixed tangency params (≤ 2 per external intruder) have
  degree ≤ 1 and terminate paths;
- the **parabolic case** `d = p` (line `xx'` tangent at `s`): `s` is fixed by both
  involutions (isolated vertex), all other orbits have size `p` ⇒ cycles `C_{2p}`.

Machine (NK2): every observed cycle length ∈ {2, 2d}, zero exceptions; the d-histogram runs
over divisors of q±1 plus p (q=11: d ∈ {2,3,4,5,6,11,12}, with d=11 the parabolic class).
This is the precise entry point of the §6 prediction — the residual state is governed by
element orders in `PGL(2,q)`, i.e. the divisor lattice of `q ± 1`.

## 3. Corollary VII (★ cycle deadness — the bulk of the conic is inert)

> `G(C_n) = 0` for EVERY even `n ≥ 4`. Hence every free `⟨σ_x, σ_{x'}⟩`-orbit contributes
> Grundy 0, and the conic-restricted residual value is the XOR of Dawson path values over
> the **defect skeleton only**: tangency-ended paths, the secant `K₂`, and the path
> fragments cut out of cycles by played/killed cells (Lemma III(1)'s kill-set
> `σ_x(played)` is where the cuts come from).

*Proof.* Node-Kayles on `C_n` has the single option `P_{n−3}`, so `G(C_n) = mex{G(P_{n−3})}`.
The zero set of Dawson's sequence (A002187, period 34) contains only even indices; `n` even
⇒ `n−3` odd ⇒ `G(P_{n−3}) ≠ 0` ⇒ `G(C_n) = 0`. (DP-verified to n = 400, which covers every
computable q; the period-34 zero set `{0,4,8,14,20,24,28} mod 34` gives it for all n.) ∎

**Why this matters:** the erratic near-cancellation of two `Θ(q²)` quantities (the known
shape of the (ESC)/(ON) obstruction) now has a mechanism-level explanation candidate — the
`Θ(q)`-sized cycle bulk cancels itself EXACTLY (Grundy 0), and the value is carried by an
O(1)-per-intruder defect set (≤ 2 tangency paths per intruder + ≤ 1 secant pair per intruder
pair + ≤ c kill-scars). The law hunt was failing on static 6-subset features because the
decisive data is this defect spectrum, which depends on where `σ_x(played)` lands on the
dihedral orbits — not on the 6-subset alone.

**Exactness check (NK3, zero fails):** restricted-game Grundy == XOR of Dawson path/cycle
values of the component spectrum, at every sampled 1- and 2-intruder position, q = 11, 13.

## 4. The q=11 full-game census (NK4) — both easy mechanisms REFUTED

Over all 330 on-conic S₄ (135 P-valued / 75 N-valued / value computed by exact full-game
search; the split is over the fixed-{a,b} parametrized enumeration, not the C15 bucket
measure):

- **N-valued S₄ win ONLY by intruding**: 300/300 winning first moves are intrusions; a conic
  move from an N-valued on-conic S₄ is never winning (equivalently: every on-conic size-5
  child of an N-valued on-conic S₄ is itself N).
- **H1 (self-polar answer) REFUTED**: after P1 intrudes on a P-valued S₄, a winning reply
  that is a second intruder with `ord(σ_x σ_y) = 2` exists in only a minority of cases
  (1760 (S₄, x) cases have none). The Klein-four/self-polar-triangle mechanism is not the
  uniform defense.
- **H2 (conic answer) REFUTED**: 650 (S₄, x) cases have NO conic winning reply — the defense
  is forced into the intruder zone. Multi-intruder play is not avoidable by any uniform
  strategy.
- Winning intruder replies exist across the whole d-spectrum
  (`{2: 150, 3: 300, 4: 1800, 5: 150, 6: 1500, 12: 600}`) — no single-d law; consistent with
  Corollary VII's reading that `d` per se is not the invariant, the defect XOR is.

## 5. What this changes

1. **The obstruction statement sharpens** (supersedes the wording of session-9 §6): the
   two-plus-intruder residual is Node-Kayles on a dynamically GROWING union of matchings on
   `P¹` (each new intruder adds one matching + shrinks the intruder zone). The conic side of
   the state compresses to the path-defect spectrum (Corollary VII); the open part is the
   interaction with the intruder-zone arc game.
2. **C20 gets the right features** (amended in the queue): per intruded child, compute the
   NK defect spectrum (path-length multiset after cuts) and the restricted-Grundy XOR —
   exact, cheap given the σ's — alongside the originally specified type/order census.
   Question (a) of C20 upgrades to: does (defect-XOR, intruder-zone size parity) decide the
   full-game value?
3. **Certificate compression (route C)**: P-certificates for conic-heavy subtrees can cite
   the NK decomposition (pairing on cycles = the reply book follows σ-images) instead of
   explicit reply trees — the same shape as the master pairing lemma. Worth folding into the
   C19/C14 format only after C20 confirms the defect-XOR carries the value.
4. **Unbounded-nimber warning imported from the octal thread**: general Node-Kayles on
   unions of matchings (paths/cycles) stays Dawson-tame, but the *dynamic* game (players add
   matchings) is not a fixed octal game — no off-the-shelf periodicity applies. The tameness
   here must come from geometry: intruder zones shrink quadratically and legal `d` values
   are pinned to the `q ± 1` divisor lattice.

## 5a. ADDENDUM (same session): q=11 spot-test of the defect-XOR hypothesis — a clean
## one-directional law + an exact endgame law

Before handing the census to C20, the lead hypothesis was Fermi-tested at q=11 over 861
two-intruder positions (all 330 S₄ × first-12 legal intruder pairs each; sample is
pair-order-biased but S₄-exhaustive). Results:

1. **Necessity law — 381/381 pure:** every P-position in the sample has defect-XOR = 0 AND
   even intruder zone. Contrapositive: `defXOR ≠ 0 ∨ |zone| odd ⇒ N` with zero exceptions.
   (Bucket table: (0,even) = 156 N + 324 P mixed; (0,odd), (≠0,even), (≠0,odd) = all N.)
2. **The mixed bucket collapses to the endgame:** every sampled (defXOR=0, zone-even) state
   had EMPTY live conic and exactly 2 zone cells — at q=11's two-intruder layer the conic
   is already wiped there, and the value sits entirely in the zone.
3. **Exact endgame law — 328/328:** with conic empty and zone = {u, v}: the position is P
   ⟺ u, v are non-conflicting (neither dies when the other is played, i.e. not collinear
   with any played point) — 2 independent moves = P; a conflicting pair = 1 effective
   move = N.

So the sampled two-intruder layer at q=11 is COMPLETELY decided by the Node-Kayles data of
the current kill structure: (conic defect-XOR, zone parity, zone conflict graph). The
upgraded hypothesis for C20 ("joint snapshot"): the full-game value is a function of the
joint Node-Kayles snapshot — conic spectrum + zone conflict graph — with the necessity law
`P ⇒ defXOR = 0 ∧ zone even` as the load-bearing testable piece at q = 13, 17 (where zones
are larger and the conic survives two intrusions; q=11's empty-conic collapse will NOT
persist, so the mixed-bucket discriminator must generalize the zone-conflict term).
Caveats recorded: c=6 layer only, q=11 only, pair sample biased to lexicographically early
intruders.

## 6. Next steps

- **C20 (Codex, queued + amended):** the game-labeled census now including defect-spectrum
  features — the direct test of "defect XOR decides".
- **Fable next:** the endgame theory — a position is terminal when every conic survivor is
  dead AND the intruder arc is complete; prove a "last-defect" lemma tying the final parity
  to the defect XOR + intruder count mod 2 (the analogue of session-9 §4 one step deeper).
  If C20 confirms the defect-XOR signal, attempt the second-intrusion lemma in defect form:
  P2 can always intrude restoring defect-XOR = 0 with an even-parity zone.
- The q=9 Lean shape (C13/C19 lane) is untouched by this — the q=9 residual is depth-1 and
  needs none of this machinery.
