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

## The interval family C_n^k (S = {±1,…,±k}) — the k-th power of a cycle

Clean 2D table (rows n, cols k; `*` = k>(n−1)/2, i.e. K_n):

- **Even n: G = 0 for every k.** Fully explained by L1 — `k < n/2` ⇒ `n/2 ∉ S`. The entire even
  interval family is a P-position by translation pairing.
- **Odd n: mixed.** `k=1` is the cycle `C_n` (Node-Kayles ≡ removing 3 consecutive → path
  P_{n−3} = Dawson's chess, octal 0.137, eventually periodic); G(C_n)=1 at n=3,7,11,17,23,27,31,…
  The endpoint `k=(n−1)/2` is `K_n` ⇒ G=1 (L4, one move clears the board). Each fixed-k column is
  a finite octal-type game, expected eventually periodic in n (an L8 fixed-width-strip instance on
  the cyclic power) — a concrete standalone periodicity sub-target.

## What is proven vs. computed

- **Proven** (proof-on-write, each with the sketch above): R0 component-parity reduction; L1;
  L2; the odd-n pairing impossibility; the interval-family even-n G=0 (a corollary of L1).
- **Computed / conjectural:** the pairing-coverage percentages and the P-vs-N asymmetry headline
  (empirical over the full enumeration to n≤20/19, sound throughout); the interval-family odd-n
  fixed-k column periodicity (structurally expected, not yet certified).
- **Open (unchanged, now positioned):** the outcome of an arbitrary *connected* circulant has no
  simple closed form (Node-Kayles is PSPACE-complete in general); the value lives in the "gap" and
  the only clean laws are for structured families (intervals, k-th-power residues / Paley).

## Next steps

1. **Write up R0 + L1 + L2 + the odd-n impossibility as a short lemma bundle** — these are clean,
   proven, and reusable across the torus/kings/Petersen programs (they are the abelian-Cayley core
   of the L1/L2 queue in the analytic note, now verified sound to n=20).
2. **Interval-family periodicity:** certify one fixed-k column (k=2 or 3) as eventually periodic
   via the boundary-transfer engine (the cyclic-power analog of the 3×N strip work) — a concrete,
   provable closed form and the cleanest quick win here.
3. **N-side structure:** the pairing certificate is a minority on the N-side; the open question is
   what *does* certify the majority of circulant first-player wins. The Paley Weil-closure argument
   is one answer for one family; a second, non-pairing N-side certificate type (a potential
   function à la Erdős–Selfridge?) is the research-shaped lever flagged in the analytic note.
4. **Sum-free game (b)** remains parked for a dedicated bigger-memory session (new subset-state
   solver) — do NOT start on the busy box.
