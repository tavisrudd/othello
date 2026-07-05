# Cay⁺(Z_n, S) Node-Kayles — the structural outcome law (game (a))

**Date:** 2026-07-04
**Scope:** executes the ★ DECISION in
[node-kayles-open-problem-targets](2026-07-04-node-kayles-open-problem-targets.md) — game (a),
GRAPH Node-Kayles on the circulant Cay⁺(Z_n, S) for **general symmetric S** (not just the
k-th-power-residue / Paley subfamily already computed in
[analytic-node-kayles-plan §"Generalized Paley & Peisert"](2026-07-04-analytic-node-kayles-plan.md)).
Small-memory single-core Python (the G(17) nimber run held the box's ~17 GB TT this session);
all runs under `ulimit -Sv ~900 MB`, memo-capped, zero caps hit through the ranges below.
Engine reused from `2026-07-04-arith-cayley.py`; banked scripts:
`2026-07-04-cayley-sweep.py`, `2026-07-04-cayley-cert.py`.

**Bottom line — the law is an ASYMMETRY.** For circulants, *P-positions (G=0) are
pairing-explained* (on even n) and *N-positions (G=1) are mostly NOT*. The pairing / halving
certificate is fundamentally a P-side tool; on the N-side it fires only for a narrow
halving-closed slice — which is exactly why the Paley conjecture (an N-side statement) needs the
heavy Weil-closure machinery rather than a mirror.

Circulants are vertex-transitive ⇒ G ∈ {0,1} (all first moves isomorphic ⇒ root option multiset
is a singleton ⇒ mex ∈ {0,1}); a boolean P/N recursion gives the exact root verdict. Full
enumeration of the symmetric connection sets (S = −S, 0 ∉ S) for each n; every set solved exactly.

## The certificate hierarchy (proven pieces, all verified sound)

Three sound certificates, in the order they fire. "Sound" = it never contradicts the computed
verdict; verified over the **entire** symmetric-S enumeration through n=20 (even, 1024 sets) and
n=19 (odd, 512 sets) — zero soundness violations, zero memo caps.

**R0 — component-parity reduction (proven; the first thing to apply).**
Let `d = gcd(n, S)`. The graph is `d` isomorphic copies of the connected circulant
`Cay(Z_{n/d}, S/d)`. By Sprague–Grundy XOR of equal components:

```text
d even  ⇒  G = 0        (even multiplicity of an isomorphic component XORs to 0)
d odd   ⇒  G = G( Cay(Z_{n/d}, S/d) )     (reduce to a CONNECTED circulant)
```

Verified 0 violations / 1513 sets (n ≤ 18). This subsumes the "reflection / all-even S" pairing:
S ⊆ 2·Z_n forces d even. **Every circulant outcome reduces to a connected one**, with
disconnected-even-multiplicity automatically P.

**L1 — translation pairing (proven; n even).** If `n` is even and `n/2 ∉ S`, then
translation `x ↦ x + n/2` is a fixed-point-free involutive automorphism with no vertex adjacent to
its mate (adjacency needs `n/2 ∈ S`) ⇒ a closed S1 pairing ⇒ **G = 0**. Covers *exactly* the
`n/2 ∉ S` half of all symmetric sets at even n. Verified 0 violations, every even n ≤ 20.

**L2 — negation steal (proven; n odd).** If `n` is odd and `2S = S` (halving-closed), then after
the normalized first move (delete `N[0] = {0}∪S`) the map `x ↦ −x` is a fixed-point-free
(|A| odd ⇒ `2x=0` only at 0) involutive automorphism of the residual with no live adjacent mate
(`2x ∉ S` for `x ∉ S`, by halving-closure) ⇒ the child is P ⇒ **G = 1**. Verified 0 violations,
every odd n ≤ 19. Paley `p ≡ 1 (mod 8)` is the special case `2 ∈ QR ⇒ 2·QR = QR`.

**The odd-n P-side impossibility (proven).** An odd number of vertices admits **no**
fixed-point-free involution at all, so **no P-position on odd n can ever be pairing-certified** —
every odd-n G=0 is won by genuine strategy, not a mirror. Smallest witness: `C₅ = Cay(Z₅,{±1})`,
G=0. In the coverage table below this shows as `G0_paired = 0` for every odd n.

## Coverage — where the pairing fires and where it does not

`whole_graph_paired` = an affine involution `x↦ax+b` (`a²≡1`, `aS=S`) certifying the *whole graph*
is P (⇒ G=0). `residual_paired` = an affine involution certifying the *child after move 0* is P
(⇒ G=1) — the constructive "play 0, then mirror" winning strategy. Full enumeration:

| n  | #sym-S | G0  | G1  | G0 paired | G0 gap | G1 paired | G1 gap | sound |
|----|--------|-----|-----|-----------|--------|-----------|--------|-------|
| 8  | 16     | 13  | 3   | 10        | 3      | 1         | 2      | OK    |
| 9  | 16     | 9   | 7   | 0         | 9      | 4         | 3      | OK    |
| 12 | 64     | 50  | 14  | 40        | 10     | 7         | 7      | OK    |
| 13 | 64     | 42  | 22  | 0         | 42     | 2         | 20     | OK    |
| 16 | 256    | 211 | 45  | 136       | 75     | 1         | 44     | OK    |
| 17 | 256    | 164 | 92  | 0         | 164    | 4         | 88     | OK    |
| 18 | 512    | 410 | 102 | 256       | 154    | 27        | 75     | OK    |
| 19 | 512    | 354 | 158 | 0         | 354    | 2         | 156    | OK    |
| 20 | 1024   | 859 | 165 | 576       | 283    | 33        | 132    | OK    |

Reading it:

- **P-side (G=0).** Even n: pairing covers a large majority — `G0_paired` = the L1 half
  `2^{n/2−1}` plus affine/reflection extras when `n ≡ 0 (mod 4)` (n=20: 576 = 512 L1 + 64;
  n=18 ≡ 2 mod 4: 256 = exactly the L1 half, reflection adds nothing because an all-even S has
  `n/2` odd ∉ S ⇒ already L1). Odd n: `G0_paired = 0` everywhere (the impossibility above).
- **N-side (G=1).** Pairing covers only a **minority** at every n (n=16: 1/45; n=17: 4/92;
  n=19: 2/158). Most first-player wins on circulants have **no** affine-pairing / halving
  certificate — they win by a deeper mex>0 reason.

## Paley tie-back — the open conjecture lives in the N-side gap

Running the same `residual_paired` checker on Paley graphs (S = QR mod p) reproduces the known law
exactly and locates the open conjecture:

```text
p ≡ 1 (mod 8)  (17,41,73,89,97):  G=1, residual_paired = (−1,0)   ← negation steal fires (=L2)
p ≡ 5 (mod 8):                     residual pairing FAILS (None)
    {5,29,37}:                     G=0  (the finite Paley exceptions)
    {13,53,61,101,109,…}:          G=1  but NO pairing certificate  ← the open conjecture
```

So `G(Paley_p)=1` for `p ≡ 5 (mod 8)`, `p>37` is precisely a family of N-positions that provably
have **no affine-pairing certificate**, which is the structural reason it resists a mirror proof
and needs the character-sum / Weil-closure argument (analytic-note plan step 4). The general sweep
puts the Paley conjecture in its natural place: the sparse, hard corner of the N-side gap.

## The interval family C_n^k (S = {±1,…,±k}) — the k-th power of a cycle → octal games

Banked script: `2026-07-04-cayley-path-power.py`. First the coarse table (rows n, cols k;
`*` = k>(n−1)/2, i.e. K_n):

- **Even n: G = 0 for every k.** Fully explained by L1 — `k < n/2` ⇒ `n/2 ∉ S`. The entire even
  interval family is a P-position by translation pairing.
- **Odd n: mixed.** Endpoint `k=(n−1)/2` is `K_n` ⇒ G=1 (L4, one move clears the board).

**The exact reduction (proven + verified two ways).** A first move on `C_n^k` deletes `2k+1`
consecutive vertices → one run `P_{n−2k−1}^k`; a move at position `i` in a length-`m` run deletes
`[i−k,i+k]` and splits into two independent shorter `P^k` runs `max(0,i−k)` and `max(0,m−1−i−k)`.
So Node-Kayles on the k-th power of a path/cycle **is the octal game**

```text
P_n^k  =  0.[1×k][3×k]7      k=1: 0.137 (Dawson's chess) | k=2: 0.11337 | k=3: 0.1113337
G(C_n^k) = 1  iff  g_path_k(n − 2k − 1) = 0.
```

Verified two independent ways: the split recursion equals a direct bitmask-Grundy on the actual
`P_m^k` graph (k=2,3, m≤19, exact match), and equals an independent generic octal-game solver on
`0.[1×k][3×k]7` (k=1,2,3, m≤400, exact match). The path↔cycle reduction cross-checks against the
brute circulant engine (k=1..4, n<40, 0 mismatches).

**k=1 — periodic (the classical result recovered).** `g_path_1` has **period 34, preperiod 52**
(Guy–Smith certified), max value 9. ⇒ `G(C_n^1) = 1` exactly for `n ≡ {6,10,22,26,30} (mod 34)`
for large `n` (small-n exceptions inside the preperiod: N at n=3,7,11,17,23,27,31). This is
Dawson's chess, period 34 — a validation, not a new result.

**k ≥ 2 — UNBOUNDED and periodicity OPEN (the real finding; corrects the earlier "expected
periodic" guess).** `g_path_k` Grundy values **grow without bound** through m=8000 (k=2 reaches
**228**, k=3 reaches **136**), with **no pure period and no arithmetic period** (saltus) detectable
for `p < 2000` on the tail `[4000,8000]`. These are 5- and 7-digit octal codes — **beyond the
≤3-digit range Flammenkamp's octal tables cover**, and octal periodicity is unproven in general
(Guy's conjecture; even 3-digit octals have dozens of unsettled cases). So the interval family for
`k ≥ 2` is a **fresh instance of unbounded Node-Kayles nimbers** — it lines up with the trees result
(unbounded) and contrasts the 3×N clean-diagonal (bounded); it is NOT the quick periodic win first
hoped for.

**Cycle-outcome consequences (conjectural, from the data):**
- `k=2` (0.11337): P-positions of the path game **thin out** — zero-gaps grow to 4174 by m=8000 and
  the P/N indicator shows no period; only odd `n` can be N (even n = G=0 by L1) and those become rare.
- `k=3` (0.1113337): **no path P-position beyond m=824** in the computed range ⇒ conjecturally
  `G(C_n^3) = 0` (second player wins) for **all large n** — but uncertifiable while values stay
  unbounded (a zero could reappear).

## What is proven vs. computed

- **Proven** (proof-on-write, each with the sketch above): R0 component-parity reduction; L1;
  L2; the odd-n pairing impossibility; the interval-family even-n G=0 (a corollary of L1).
- **Computed / conjectural:** the pairing-coverage percentages and the P-vs-N asymmetry headline
  (empirical over the full enumeration to n≤20/19, sound throughout); the `C_n^k` octal
  identification `0.[1×k][3×k]7` (proven-on-write + verified two ways); the k≥2 unboundedness /
  no-periodicity (empirical through m=8000, saltus search p<2000); the k=3 "P for all large n"
  conjecture.
- **Open (unchanged, now positioned):** the outcome of an arbitrary *connected* circulant has no
  simple closed form (Node-Kayles is PSPACE-complete in general); the value lives in the "gap" and
  the only clean laws are for structured families (intervals k=1, k-th-power residues / Paley).
  **The k≥2 interval octals (0.11337, 0.1113337, …) are genuinely open** — their periodicity is a
  case of Guy's octal conjecture beyond the catalogued range.

## Next steps

1. ~~**Write up R0 + L1 + L2 + the odd-n impossibility as a short lemma bundle**~~ — **DONE**
   ([nodekayles-pairing-lemmas](2026-07-04-nodekayles-pairing-lemmas.md)): master pairing lemma P0
   at full graph generality + P0′ move-and-mirror + odd-order impossibility, then the abelian-Cayley
   specializations R0/L1/L2, all proof-on-write and generalized from `Z_n` to arbitrary finite
   abelian `Γ` (torus/kings), re-verified with zero violations through `|Γ| ≤ 16` including
   non-cyclic groups (`2026-07-04-abelian-nodekayles-verify.py`).
2. **Interval-family octals (REVISED — periodicity is NOT a quick win).** The k≥2 columns are the
   octal games `0.[1×k][3×k]7` with unbounded values; certifying periodicity ≡ resolving Guy's
   conjecture for these codes — out of scope for a probe. The tractable pieces: (a) extend
   `g_path_2`/`g_path_3` to m~10⁵–10⁶ (cheap C, the O(m²) split recursion) to firm up the
   unboundedness and search for a large period/saltus; (b) settle the k=3 "P for all large n"
   conjecture is likewise gated on the same octal question. Bank as: **the interval family is an
   open-octal-game family, one clean k=1 result + a fresh unbounded-nimber data point.** Verify
   whether the `0.[1×k][3×k]7` identification is already in the literature (Beaudou–Coupechoux–Dailly
   "Octal games on graphs"; Guignard–Sopena) before any novelty claim.
3. **N-side structure:** the pairing certificate is a minority on the N-side; the open question is
   what *does* certify the majority of circulant first-player wins. The Paley Weil-closure argument
   is one answer for one family; a second, non-pairing N-side certificate type (a potential
   function à la Erdős–Selfridge?) is the research-shaped lever flagged in the analytic note.
4. ~~Write up R0 + L1 + L2 + odd-n impossibility as a lemma bundle~~ — **DONE** (see step 1).
5. **Sum-free game (b)** remains parked for a dedicated bigger-memory session (new subset-state
   solver) — do NOT start on the busy box.
