# C281 — Exhaustive per-q census of tame legal dihedral conic configurations (q ≤ 23)

**Lane**: `dihedral` (task C281)
**Date**: 2026-07-17
**Manuscript**: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md` (not edited by this task)
**Evidence bundle**: `2026-07-17-c281-dihedral-census-appendix.{rs,json,sha256,md}` (this file is the report)

## 1. Result

The census enumerates, over every odd prime field `q ∈ {3,5,7,11,13,17,19,23}`, **every** tame
legal selected configuration whose induced involutions generate a dihedral subgroup of `PGL₂(q)`:
all 255,288 tame legal pairs (13,932 of them the `V₄` boundary `m=2`, 241,356 with `m ≥ 3`) and all
246,000 legal tame dihedral triples, classified by the paper's families with full-board value
histograms. Every configuration's directly computed Grundy value agrees with the per-orbit
template xor and with a closed finite-field formula (0 mismatches of any kind; §4).

**Finding (value-affecting manuscript gap).** The census exposes a second conjugacy class of
`D_{4n}` that the manuscript's §9 normal form misses. §9 chooses the model `s: t ↦ t⁻¹` and
concludes `a₀ = 1` (the `⟨s⟩` reflection class is always split). That holds for the chosen model,
but when `h = (q∓1)/2n` is even (equivalently `δ = 1`), `PGL₂(q)` also contains a `D_{4n}` class
whose reflections are **all nonsplit** (`t = 0` split reflection classes instead of `2`): its
rotation `⟨ω⟩` lies inside the squares of the ambient torus, and a reflection coset entirely
outside the squares exists. Such groups arise from legal triples (and pairs), e.g. `q=7`,
`T = {z,s,sr}` generating a `D₈` that acts **freely** on `P¹(7)` — the whole board is one Möbius
ladder `M₈`, value `1`, while the boxed formula (9.5) predicts `0`. In the census domain 27,528
triples lie in such a `t ≠ 1+δ` class, and for 20,196 of them (the odd-`d` ones) the actual value
differs from the §9 boxed value (`manuscript_sec9_triple_deviations` /
`..._value_deviations` in the JSON `checks` block). The general engine is untouched: Theorem 8.1's
orbit-parity formula holds on every configuration; only the orbit-multiplicity input `(f, a₀, a₁)`
of §9 is wrong for the second class. Corrected closed form (verified on every triple, 0
mismatches):

```
t = number of split reflection classes ∈ {0,1,2}   (t = 1 iff h odd; t ∈ {0,2} iff h even),
f = (q+1 − 2ε − 2nt)/4n,      ε = 1 iff 2n | q−1,
𝒢 = (f mod 2) ⊕ 1_{2|n}·(t mod 2)   (d odd),      𝒢 = t mod 2   (d even).
```

For `d` odd with `h` even the two classes have `f` of opposite parity, so **exactly one of the two
`D_{4n}` conjugacy classes is an N-position** — the paper's single boxed value and the Cor 9.1
P-position congruences are wrong for the other class. Consequences for the paper (for the C264
integration owner; nothing edited here):

- §9 (9.1)/(9.4) `a₀ = 1` and the boxed (9.2)/(9.5) values need the class split by `t`; Cor 9.1
  needs the same case split. (9.3)/(9.6) (`d` even) survive numerically: `t mod 2 = 1−δ`.
- §14/C263 Theorem D's proof step "class `⟨s⟩` is always split" is wrong for the second class, but
  the pair **value** formula `𝒢 = (1−δ)·𝒢(Pₘ)` survives because `t` has the same parity as `1+δ`
  (`ρ ∈ {0,2}` vs `2`; 20,196 pairs deviate in `ρ`, none in value —
  `manuscript_thmD_pair_deviations`). C263's end-to-end check verified the orbit-parity formula and
  the closed form's *values*, which is why this was invisible there.
- All triple values remain in `{0,1}` (visible in every triple histogram), so the paper's
  "triples have values in {0,1}" claim survives.

## 2. Conventions (load-bearing)

- **Fields**: odd prime fields only, `q ∈ {3,5,7,11,13,17,19,23}`. The C263/C283/C284 scripts are
  all prime-field; `q = 9` is deliberately excluded to match that convention (stated choice).
- **Geometry**: conic `XZ = Y²`; `P¹(q)` indexed `0..q−1` plus `∞`; off-conic `[a:b:c]`
  (`ac−b² ≠ 0`) ↔ involution `σ(t) = (bt−a)/(ct−b)` (bijection; `q²` involutions).
- **Deleted set** (manuscript (2.3)/(3.1)): `D_S = ∪_{{x,y}⊂S} Fix(σₓσᵧ)`; residual `R_S` on
  `C \ D_S` with edges `u ∼ σₓ(u)`, loops/multi-edges suppressed.
- **Legal**: no three selected points collinear (projective determinant check); pairs always legal.
- **Tame**: `p ∤ |G|` (q odd, so `p | 2m ⇔ p | m`). Wild pairs are counted and excluded
  (C283 covers them); no wild legal dihedral triple exists (re-verified, §4).
- **Value**: Node-Kayles Grundy value of `R_S`, computed directly by memoized component-xor
  Sprague–Grundy recursion (same core as C263 / `rust/scripts/nodekayles_cayley.rs`).
- **Families**: pairs `m=2` → `V₄` boundary keyed by `k` = number of split selected involutions;
  pairs `m≥3` → `D_{2m}` keyed by `(m, torus, δ, t)`; triples → `V₄` keyed by split count `s`
  (Thm 4.1) or `D_{4n}` keyed by `(4n, d-class odd/even, torus, t)`, `d`-class read off
  `ord(σ_sσ_{s'}) ∈ {2n, n}`.

## 3. Enumeration and checker design

Pairs: all `C(q²,2)` unordered pairs, complete. Triples: a legal dihedral triple must contain a
member commuting with the other two (the forced central involution), so it has ≥ 2 pairwise
products of order 2; the scan over all `C(q²,3)` triples uses that gate, then verifies the actual
group closure (order, dihedrality, centrality) before accepting. The gate is **independently
validated** for `q ∈ {3,5,7,11}` by a gate-free full-closure re-enumeration of every triple with
exact accepted-triple-set equality (`full_closure_check.triple_sets_equal = true` per q). For each
accepted configuration the checker computes: the direct residual value; the orbit decomposition
with per-orbit size/stabilizer/deletion-pattern structure checks; each orbit's own residual value
against its template value (`K₄`, `C_{2m}`, `Pₘ`, `M_{4n}`, `C_{2n}□K₂`, ladders, `∅`); the
per-orbit xor; the corrected closed finite-field formula; the orbit equation
`q+1 = 4nf + 2ε + 2n(a₀+a₁)` (triples) / `q+1 = 2mf + mρ + 2ε` (pairs); the `V₄` parity law (4.1);
and the split-class law (`t = 1` iff `h` odd).

## 4. Checks (all pass; exact counts)

From the JSON `checks` block (`all_ok = true`; the binary exits nonzero on any failure):

- `NK(Pₙ)` matches OEIS A002187 (Dawson's chess) on the hard-coded initial terms;
  `NK(Cₙ) = mex{NK(P_{n−3})}` for `3 ≤ n ≤ 60`.
- **0** formula mismatches, **0** closed-form mismatches (corrected forms), **0** structure
  failures, **0** per-orbit template-value mismatches, **0** torus anomalies, **0** orbit-equation
  violations, **0** `V₄` parity-law violations, **0** closure-shape failures, **0** split-class-law
  violations — over all 255,288 tame legal pairs and 246,000 legal tame dihedral triples.
- **C263 overlap**: tame pairs with `m ≥ 3` over `q ∈ {5,…,23}` reproduce C263 exactly — 241,344
  pairs, identical per-m histogram, identical value histogram `{0:172668, 1:36456, 2:13296,
  3:18924}` (hard-coded from the committed C263 JSON; `c263_overlap_match = true`).
- **C284 overlap**: the gate-free closure pass classifies the non-dihedral polyhedral triples.
  `q=7`: S4-closure triples split `168/336/56/168` over the `(σ,ρ)` classes = exactly **14** copies
  × C284's per-copy `12/24/4/12`; every direct residual value matches C284's field formula at
  `q=7` (`ε₃=1`, all-`t₃` values, all `0`); 0 mismatches. `q=11`: A5-closure triples split
  `2640/1320/1320/1320/1320/440` = exactly **22** copies × `120/60/60/60/60/20`, including the
  `ρ`-split of `(3,5,5)`; every direct value matches `ε₅·t₅` (values `0/1/0/1/0/0` by class);
  0 mismatches; `ρ` consistent across all six orderings on every triple.
- **C283 consistency**: 0 wild legal dihedral triples in the gate pass, and in the closure pass
  every wild dihedral closure triple is collinear (`wild_dihedral_noncollinear_closure_triples
  = 0`) — the "no legal wild triple" claim re-verified for `q ≤ 11`.
- Excluded-triple accounting: `nondihedral_commuting = 0` and `collinear = 0` at every `q`
  (empirically, every gated candidate was a legal dihedral triple).

## 5. Reproduce / verify

Working directory: `notes/`. Deterministic (no randomness, no timestamps, sorted canonical JSON);
replay reproduced a byte-identical JSON (same SHA-256). Runtime ≈ 1 min single-threaded.

```
cd notes
rustc -O 2026-07-17-c281-dihedral-census-appendix.rs -o /tmp/c281bin
/tmp/c281bin 2026-07-17-c281-dihedral-census-appendix.json
sha256sum -c 2026-07-17-c281-dihedral-census-appendix.sha256
```

**What the output certifies**: the complete census tables and histograms below for exactly the
eight listed prime fields; the per-configuration agreement of direct values with the orbit-template
engine and the corrected closed forms; the C263/C284/C283 overlap agreements; and the existence
and values of the second `D_{4n}` conjugacy class. **What it does not certify**: any `q` outside
the list (in particular the prime power `q=9` and all `q > 23`); wild configurations (excluded by
definition; see C283); non-dihedral configurations beyond the S4/A5 overlap classes at
`q ∈ {7,11}`; any unrestricted-`q` claim (the class-`t` law and corrected formulas are proved here
only by finite exhaustion on this domain, though the coset/square argument in §1 is general); and
no Lean proof. **Trusted boundary**: the shared memoized Sprague–Grundy core (validated against
the hard-coded A002187 terms and the cycle mex recurrence), the group-closure/dihedrality test
(cross-validated by the gate-free re-enumeration), and `rustc -O`.

## 6. Draft appendix for the paper (C264 integrates; manuscript untouched here)

> ### Appendix X. Census of tame legal dihedral configurations, q ≤ 23
>
> For each odd prime field `q ≤ 23` the tables list every tame legal selected configuration whose
> involutions generate a dihedral subgroup of `PGL₂(q)`, grouped by isomorphism type and
> arithmetic class, with full-board Node-Kayles values. Notation: `s`/`n` = split/nonsplit torus;
> `t` = number of split reflection classes; `o`/`e` = odd/even `d`; `count x value`; a bracketed
> value marks the rows where the two conjugacy classes of `D_{4n}` (`t ∈ {0,2}`, `h` even) force a
> departure from the single-model formula, cf. Remark Y.
>
> | q   | pairs (tame legal) | pair values 0/1/2/3  | triples (tame legal) | triple values 0/1 |
> |-----|--------------------|----------------------|----------------------|-------------------|
> | 3   | 24                 | 18/6/0/0             | 16                   | 3/13              |
> | 5   | 240                | 150/90/0/0           | 200                  | 65/135            |
> | 7   | 1008               | 756/252/0/0          | 896                  | 266/630           |
> | 11  | 6600               | 3630/330/1320/1320   | 6160                 | 3135/3025         |
> | 13  | 13104              | 10374/546/2184/0     | 12376                | 6097/6279         |
> | 17  | 39168              | 18360/3672/9792/7344 | 37536                | 11628/25908       |
> | 19  | 61560              | 46170/5130/0/10260   | 59280                | 21375/37905       |
> | 23  | 133584             | 100188/33396/0/0     | 129536               | 61226/68310       |
> | all | 255288             |                      | 246000               |                   |
>
> Pair families (`V₄` boundary by split count `k`; `D_{2m}` by `(torus, t)`; value constant per row):
>
> | q  | pair families: group (torus, t) -> count x value                                                                                                                                                                                                                                          |
> |----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
> | 3  | V4(k=0):3x0, V4(k=1):6x1, V4(k=2):3x0, D8(n,t1):12x0                                                                                                                                                                                                                                      |
> | 5  | V4(k=0):15x0, V4(k=1):30x1, V4(k=2):15x0, D6(n,t0):30x0, D6(n,t1):30x0, D8(s,t1):60x0, D12(n,t1):60x1                                                                                                                                                                                     |
> | 7  | V4(k=0):42x0, V4(k=1):84x1, V4(k=2):42x0, D6(s,t0):84x0, D6(s,t1):84x0, D8(n,t0):84x0, D8(n,t2):84x0, D12(s,t1):168x1, D16(n,t1):336x0                                                                                                                                                    |
> | 11 | V4(k=0):165x0, V4(k=1):330x1, V4(k=2):165x0, D6(n,t0):330x0, D6(n,t1):330x0, D8(n,t1):660x0, D10(s,t0):660x0, D10(s,t1):660x0, D12(n,t0):330x0, D12(n,t2):330x0, D20(s,t1):1320x3, D24(n,t1):1320x2                                                                                       |
> | 13 | V4(k=0):273x0, V4(k=1):546x1, V4(k=2):273x0, D6(s,t0):546x0, D6(s,t1):546x0, D8(s,t1):1092x0, D12(s,t0):546x0, D12(s,t2):546x0, D14(n,t0):1638x0, D14(n,t1):1638x0, D24(s,t1):2184x2, D28(n,t1):3276x0                                                                                    |
> | 17 | V4(k=0):612x0, V4(k=1):1224x1, V4(k=2):612x0, D6(n,t0):1224x0, D6(n,t1):1224x0, D8(s,t0):1224x0, D8(s,t2):1224x0, D12(n,t1):2448x1, D16(s,t0):2448x0, D16(s,t2):2448x0, D18(n,t0):3672x0, D18(n,t1):3672x0, D32(s,t1):9792x2, D36(n,t1):7344x3                                            |
> | 19 | V4(k=0):855x0, V4(k=1):1710x1, V4(k=2):855x0, D6(s,t0):1710x0, D6(s,t1):1710x0, D8(n,t1):3420x0, D10(n,t0):3420x0, D10(n,t1):3420x0, D12(s,t1):3420x1, D18(s,t0):5130x0, D18(s,t1):5130x0, D20(n,t0):3420x0, D20(n,t2):3420x0, D36(s,t1):10260x3, D40(n,t1):13680x0                       |
> | 23 | V4(k=0):1518x0, V4(k=1):3036x1, V4(k=2):1518x0, D6(n,t0):3036x0, D6(n,t1):3036x0, D8(n,t0):3036x0, D8(n,t2):3036x0, D12(n,t0):3036x0, D12(n,t2):3036x0, D16(n,t1):12144x0, D22(s,t0):15180x0, D22(s,t1):15180x0, D24(n,t0):6072x0, D24(n,t2):6072x0, D44(s,t1):30360x1, D48(n,t1):24288x0 |
>
> Triple families (`V₄` by split count `s`, Thm 4.1; `D_{4n}` by `(d-class, torus, t)`):
>
> | q  | triple families: group (d-class, torus, t) -> count x value [Sec.9 value if different]                                                                                                                                                                                                   |
> |----|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
> | 3  | V4(s=0):1x1, V4(s=2):3x0, D8(o,n,t1):12x1                                                                                                                                                                                                                                                |
> | 5  | V4(s=1):15x1, V4(s=3):5x0, D8(o,s,t1):60x1, D12(e,n,t1):60x1, D12(o,n,t1):60x0                                                                                                                                                                                                           |
> | 7  | V4(s=0):14x0, V4(s=2):42x1, D8(o,n,t0):84x1[0], D8(o,n,t2):84x0, D12(e,s,t1):168x1, D12(o,s,t1):168x0, D16(o,n,t1):336x1                                                                                                                                                                 |
> | 11 | V4(s=0):55x1, V4(s=2):165x0, D8(o,n,t1):660x0, D12(e,n,t0):330x0, D12(e,n,t2):330x0, D12(o,n,t0):330x1[0], D12(o,n,t2):330x0, D20(e,s,t1):1320x1, D20(o,s,t1):1320x0, D24(o,n,t1):1320x1                                                                                                 |
> | 13 | V4(s=1):273x1, V4(s=3):91x0, D8(o,s,t1):1092x0, D12(e,s,t0):546x0, D12(e,s,t2):546x0, D12(o,s,t0):546x1[0], D12(o,s,t2):546x0, D24(o,s,t1):2184x1, D28(e,n,t1):3276x1, D28(o,n,t1):3276x0                                                                                                |
> | 17 | V4(s=1):612x0, V4(s=3):204x1, D8(o,s,t0):1224x0[1], D8(o,s,t2):1224x1, D12(e,n,t1):2448x1, D12(o,n,t1):2448x1, D16(o,s,t0):2448x1[0], D16(o,s,t2):2448x0, D32(o,s,t1):9792x1, D36(e,n,t1):7344x1, D36(o,n,t1):7344x0                                                                     |
> | 19 | V4(s=0):285x1, V4(s=2):855x0, D8(o,n,t1):3420x1, D12(e,s,t1):3420x1, D12(o,s,t1):3420x1, D20(e,n,t0):3420x0, D20(e,n,t2):3420x0, D20(o,n,t0):3420x1[0], D20(o,n,t2):3420x0, D36(e,s,t1):10260x1, D36(o,s,t1):10260x0, D40(o,n,t1):13680x1                                                |
> | 23 | V4(s=0):506x0, V4(s=2):1518x1, D8(o,n,t0):3036x1[0], D8(o,n,t2):3036x0, D12(e,n,t0):3036x0, D12(e,n,t2):3036x0, D12(o,n,t0):3036x0[1], D12(o,n,t2):3036x1, D16(o,n,t1):12144x0, D24(o,n,t0):6072x1[0], D24(o,n,t2):6072x0, D44(e,s,t1):30360x1, D44(o,s,t1):30360x0, D48(o,n,t1):24288x1 |
>
> **Remark Y (second conjugacy class).** When `h = (q∓1)/2n` is even, `PGL₂(q)` contains two
> conjugacy classes of `D_{4n}`: the §9 normal form (both reflection classes split, `t=2`) and a
> class with all reflections nonsplit (`t=0`, no reflection orbits; for the smallest case `q=7`
> the `D₈` acts freely and the board is a single Möbius ladder `M₈`). With
> `f = (q+1−2ε−2nt)/4n` the value is `(f mod 2) ⊕ 1_{2|n}(t mod 2)` for odd `d` and `t mod 2` for
> even `d`; for odd `d` the two classes have opposite values, so exactly one is an N-position and
> the boxed single-model formulas of Section 9 apply only to the `t = 1+δ` class. The
> two-selected-point value formula of Section 14 is unaffected (`t ≡ 1+δ (mod 2)` always).

## 7. Vibe check

Better than a routine census: the tabulation itself is complete and every cross-check is exact
(C263 reproduced to the pair, C284 reproduced to the class including copy multiplicities 14 and
22), but the headline is that exhaustive enumeration caught a real, value-affecting gap in §9 —
the second `D_{4n}` conjugacy class with all-nonsplit reflections, invisible to C263's pair checks
because there it only flips `ρ` between two even values. The corrected closed form passes on every
configuration, and the fix is local (a `t`-case split in §9 and Cor 9.1), but C264 must apply it
before the paper's boxed formulas can be called complete.
