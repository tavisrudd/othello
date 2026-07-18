# C288 — Exhaustive tame polyhedral embedding census, odd prime powers `q ≤ 101`

**Lane**: `dihedral` (task C288)
**Date**: 2026-07-17. **Status**: COMPLETE.
**Evidence bundle**: `2026-07-17-c288-polyhedral-embedding-census.{rs,json,sha256}` (adjacent in `notes/`).

## Result

For every odd prime power `q ≤ 101`, every admissible tame `S₄` and `A₅` projective-line
realization is enumerated and fully classified: orbit types, split indicators, refined
`(σ,ρ)` triple classes, and full-board Node-Kayles values. Up to `PGL₂(q)`-conjugacy there is
exactly one realization per admissible `(group, q)`; the census therefore covers the complete
tame polyhedral landscape below 101, including the prime-power fields `q = 25, 49` and the
congruence classes `q ≡ ±3 (mod 8)` that C284's sample never touched. On C284's domain the
census reproduces its templates and values exactly: 38/38 abstract template rows byte-identical,
10/10 conic rows, 2,160 triples, 50 per-class value comparisons, 0 mismatches.

Headline new facts (relative to C284):

- **Full-board Grundy value 2 occurs.** The class `(2,3,3); ρ=4` has board value
  `2·(ε₂ₐ ⊕ ε₄)`, which is 2 exactly when `q ≡ 3, 5 (mod 8)` — congruence classes outside
  C284's sample (`q ≡ ±1 (mod 8)`). First appearance: `q = 5`. Every board value C284 observed
  was 0 or 1.
- **Split-indicator laws, completed.** Over the whole census: `S₄` has `ε₂ₐ = 1` iff
  `q ≡ 1, 3 (mod 8)`; `ε₄ = ε₂ᵦ = 1` iff `q ≡ 1 (mod 4)`; `ε₃ = 1` iff `q ≡ 1 (mod 3)`.
  This is consistent with, and refines, C284's statement (`ε₂ = ε₄ = 1` iff `q ≡ 1 (mod 8)`),
  which is correct on its sampled classes `q ≡ ±1 (mod 8)`: on `q ≡ 3 (mod 8)` the
  transpositions lie outside `PSL₂(q)` and are split without `C₄` being split. For `A₅`
  the C284 laws hold verbatim on the full domain: `ε₂ = 1` iff `q ≡ 1 (mod 4)`, `ε₃ = 1` iff
  `q ≡ 1 (mod 3)`, `ε₅ = 1` iff `q ≡ 1 (mod 5)`.
- **Closed-form value laws** (verified on every census row; derived from the C284 template
  table):

  ```text
  S4:  v(2,3,3;4) = 2 (e2a XOR e4);   v(2,3,4;3) = v(3,3,3;4) = v(3,4,4;3) = e2a.
  A5:  v(2,3,5;5) = m1 mod 2;         v(2,5,5;3) = e5 XOR (m1 mod 2);
       v(3,3,5;3) = 0;                v(3,5,5;3) = e3 XOR e5;
       v(3,5,5;5) = 0;                v(5,5,5;5) = e2.
  ```

  So the `S₄` board value depends only on `q mod 8`, and the `A₅` board value only on
  `(ε₂, ε₃, ε₅, m₁ mod 2)`.
- **Free-orbit `A₅` fields appear** (`q = 59, 71, 79, 89, 101`; none occurred in C284's
  sample): the regular value `t₁` enters through the parity `m₁ mod 2`, giving the first
  boards where classes `(2,3,5)` and `(2,5,5)` take value 1 via the regular template.
- **Prime-power fields behave by the same congruence laws**: `q = 25, 49` (`≡ 1 (mod 8)`)
  match the `q ≡ 1 (mod 8)` prime pattern exactly.

## Domain and exclusions (exact)

Odd prime powers `q ≤ 101`. Tame requires `p = char F_q ∤ |G|` (`|S₄| = 24`, `|A₅| = 60`);
this is the C283 boundary.

- Wild, excluded for both groups: `q = 3, 9, 27, 81` (`p = 3` divides 24 and 60).
- Wild, excluded for `A₅` only: `q = 5, 25` (`p = 5` divides 60).
- `A₅` inadmissible (no embedding): `q = 7, 13, 17, 23, 37, 43, 47, 53, 67, 73, 83, 97`
  (`q ≡ ±2 (mod 5)`, so `5 ∤ q³−q = |PGL₂(q)|` — asserted arithmetically — hence no element
  of order 5 and no `A₅`).
- `S₄` census domain (26 fields): the 24 primes `5 ≤ q ≤ 101` with `p ≠ 3`, plus `25, 49`.
- `A₅` census domain (12 fields): `11, 19, 29, 31, 41, 49, 59, 61, 71, 79, 89, 101`.

Totals: 38 embeddings, `26·52 + 12·380 = 5,912` generating involution triples classified and
checked.

## Conventions (load-bearing)

- Board `P¹(F_q)`: indices `0..q−1` are `[z:1]`, index `q` is `[1:0]`. `F_{p²}` is
  `F_p[x]/(x²+bx+c)` with the lexicographically smallest irreducible `(b,c)`
  (`q = 25`: `x²+2`; `q = 49`: `x²+1`).
- A realization is a subgroup `G < PGL₂(q)` isomorphic to `S₄`/`A₅`; involutions are the
  trace-zero classes (`q²` of them, asserted per field). Deleted set = rational fixed points
  of the three pair products of the generating triple; residual = fixed-point-deleted Schreier
  graph; value = Node-Kayles Grundy value.
- **Realization equivalence (the stated symmetry reduction)**: realizations are enumerated up
  to `PGL₂(q)`-conjugacy, which preserves orbit types, split indicators, triple classes, and
  all values. One conjugacy class per admissible `(group, q)` is Dickson's classification;
  it is *verified* here by brute force at `q = 7, 13` (`S₄`) and `q = 11` (`A₅`) (see
  spot checks) and supported at every `q` by the normalizer computation `N(G) = G` over all of
  `PGL₂(q)`, so the class of the found `G` has exactly `(q³−q)/|G|` members.
- `(σ,ρ)` class: sorted pair-product orders plus the common order of the six ordered
  three-generator products (all six asserted equal, field-side, for every triple).
- `A₅` regular values `t₁` are cited from Appendix A / C260 plus the C284 `regular-extra`
  replay (`(2,3,5): 1`, `(2,5,5): 1`, others 0; both `ρ` classes of `(3,5,5)` are 0). `S₄`
  regular values are recomputed abstractly here.

## Census tables

`orbits` lists orbit sizes (`12/8/6` are the `S₄` exceptional `C₂ₐ/C₃/C₄` orbits, `30/20/12`
the `A₅` `C₂/C₃/C₅` orbits, `24`/`60` free). Class columns give the full-board value; `direct`
marks rows where every triple's whole board was additionally replayed by direct Sprague-Grundy
recursion (all `q ≤ 61` except `A₅` `q = 59`, whose single free 60-vertex component exceeds
the direct-replay bound).

### S4

| `q` | field    | `q%8` | `e2a` | `e2b` | `e3` | `e4` | `m1` | orbits          | `(2,3,3);4` | `(2,3,4);3` | `(3,3,3);4` | `(3,4,4);3` | direct |
|-----|----------|-------|-------|-------|------|------|------|-----------------|-------------|-------------|-------------|-------------|--------|
| 5   | prime    | 5     | 0     | 1     | 0    | 1    | 0    | 6               | 2           | 0           | 0           | 0           | yes    |
| 7   | prime    | 7     | 0     | 0     | 1    | 0    | 0    | 8               | 0           | 0           | 0           | 0           | yes    |
| 11  | prime    | 3     | 1     | 0     | 0    | 0    | 0    | 12              | 2           | 1           | 1           | 1           | yes    |
| 13  | prime    | 5     | 0     | 1     | 1    | 1    | 0    | 6+8             | 2           | 0           | 0           | 0           | yes    |
| 17  | prime    | 1     | 1     | 1     | 0    | 1    | 0    | 6+12            | 0           | 1           | 1           | 1           | yes    |
| 19  | prime    | 3     | 1     | 0     | 1    | 0    | 0    | 8+12            | 2           | 1           | 1           | 1           | yes    |
| 23  | prime    | 7     | 0     | 0     | 0    | 0    | 1    | 24              | 0           | 0           | 0           | 0           | yes    |
| 25  | x^2+0x+2 | 1     | 1     | 1     | 1    | 1    | 0    | 6+8+12          | 0           | 1           | 1           | 1           | yes    |
| 29  | prime    | 5     | 0     | 1     | 0    | 1    | 1    | 6+24            | 2           | 0           | 0           | 0           | yes    |
| 31  | prime    | 7     | 0     | 0     | 1    | 0    | 1    | 8+24            | 0           | 0           | 0           | 0           | yes    |
| 37  | prime    | 5     | 0     | 1     | 1    | 1    | 1    | 6+8+24          | 2           | 0           | 0           | 0           | yes    |
| 41  | prime    | 1     | 1     | 1     | 0    | 1    | 1    | 6+12+24         | 0           | 1           | 1           | 1           | yes    |
| 43  | prime    | 3     | 1     | 0     | 1    | 0    | 1    | 8+12+24         | 2           | 1           | 1           | 1           | yes    |
| 47  | prime    | 7     | 0     | 0     | 0    | 0    | 2    | 24+24           | 0           | 0           | 0           | 0           | yes    |
| 49  | x^2+0x+1 | 1     | 1     | 1     | 1    | 1    | 1    | 6+8+12+24       | 0           | 1           | 1           | 1           | yes    |
| 53  | prime    | 5     | 0     | 1     | 0    | 1    | 2    | 6+24+24         | 2           | 0           | 0           | 0           | yes    |
| 59  | prime    | 3     | 1     | 0     | 0    | 0    | 2    | 12+24+24        | 2           | 1           | 1           | 1           | yes    |
| 61  | prime    | 5     | 0     | 1     | 1    | 1    | 2    | 6+8+24+24       | 2           | 0           | 0           | 0           | yes    |
| 67  | prime    | 3     | 1     | 0     | 1    | 0    | 2    | 8+12+24+24      | 2           | 1           | 1           | 1           | -      |
| 71  | prime    | 7     | 0     | 0     | 0    | 0    | 3    | 24+24+24        | 0           | 0           | 0           | 0           | -      |
| 73  | prime    | 1     | 1     | 1     | 1    | 1    | 2    | 6+8+12+24+24    | 0           | 1           | 1           | 1           | -      |
| 79  | prime    | 7     | 0     | 0     | 1    | 0    | 3    | 8+24+24+24      | 0           | 0           | 0           | 0           | -      |
| 83  | prime    | 3     | 1     | 0     | 0    | 0    | 3    | 12+24+24+24     | 2           | 1           | 1           | 1           | -      |
| 89  | prime    | 1     | 1     | 1     | 0    | 1    | 3    | 6+12+24+24+24   | 0           | 1           | 1           | 1           | -      |
| 97  | prime    | 1     | 1     | 1     | 1    | 1    | 3    | 6+8+12+24+24+24 | 0           | 1           | 1           | 1           | -      |
| 101 | prime    | 5     | 0     | 1     | 0    | 1    | 4    | 6+24+24+24+24   | 2           | 0           | 0           | 0           | -      |

### A5

| `q` | field    | `q%60` | `e2` | `e3` | `e5` | `m1` | orbits   | `(2,3,5);5` | `(2,5,5);3` | `(3,3,5);3` | `(3,5,5);3` | `(3,5,5);5` | `(5,5,5);5` | direct |
|-----|----------|--------|------|------|------|------|----------|-------------|-------------|-------------|-------------|-------------|-------------|--------|
| 11  | prime    | 11     | 0    | 0    | 1    | 0    | 12       | 0           | 1           | 0           | 1           | 0           | 0           | yes    |
| 19  | prime    | 19     | 0    | 1    | 0    | 0    | 20       | 0           | 0           | 0           | 1           | 0           | 0           | yes    |
| 29  | prime    | 29     | 1    | 0    | 0    | 0    | 30       | 0           | 0           | 0           | 0           | 0           | 1           | yes    |
| 31  | prime    | 31     | 0    | 1    | 1    | 0    | 12+20    | 0           | 1           | 0           | 0           | 0           | 0           | yes    |
| 41  | prime    | 41     | 1    | 0    | 1    | 0    | 12+30    | 0           | 1           | 0           | 1           | 0           | 1           | yes    |
| 49  | x^2+0x+1 | 49     | 1    | 1    | 0    | 0    | 20+30    | 0           | 0           | 0           | 1           | 0           | 1           | yes    |
| 59  | prime    | 59     | 0    | 0    | 0    | 1    | 60       | 1           | 1           | 0           | 0           | 0           | 0           | -      |
| 61  | prime    | 1      | 1    | 1    | 1    | 0    | 12+20+30 | 0           | 1           | 0           | 0           | 0           | 1           | yes    |
| 71  | prime    | 11     | 0    | 0    | 1    | 1    | 12+60    | 1           | 0           | 0           | 1           | 0           | 0           | -      |
| 79  | prime    | 19     | 0    | 1    | 0    | 1    | 20+60    | 1           | 1           | 0           | 1           | 0           | 0           | -      |
| 89  | prime    | 29     | 1    | 0    | 0    | 1    | 30+60    | 1           | 1           | 0           | 0           | 0           | 1           | -      |
| 101 | prime    | 41     | 1    | 0    | 1    | 1    | 12+30+60 | 1           | 0           | 0           | 1           | 0           | 1           | -      |

## Verification and cross-checks (exact counts)

All of the following are asserted by the `check` mode; any failure aborts.

1. **C284 comparison (required reproduction).** On C284's domain the census reproduces its
   bundle exactly: all 38 abstract template rows are byte-identical to lines of the committed
   C284 JSON; all 10 conic rows (`S₄` at `q = 7, 17, 23, 31, 41`; `A₅` at
   `q = 11, 19, 29, 31, 41`) match in orbit types and triple counts (2,160 triples total);
   all 50 per-class board-value comparisons against C284's recorded `[direct, formula]` pairs
   agree. Mismatches: 0. Note the census recomputes these values on its *own* independently
   found subgroups (conjugate to, not copied from, C284's).
2. **Per-orbit residual replay.** For every one of the 5,912 triples and every exceptional
   orbit, the residual graph is built from field arithmetic and its nimber computed by direct
   memoized Sprague-Grundy recursion, then compared to the abstract coset-template row
   (nimber, deletion count, residual size, component multiset): 8,540 checks, 0 mismatches.
3. **Whole-board direct replay.** For every triple on every board with `q ≤ 61` and largest
   residual component ≤ 40 vertices, the whole-board value is recomputed directly and compared
   with the per-orbit XOR: 3,596 checks, 0 mismatches (covers every `q ≤ 61` embedding except
   `A₅` `q = 59`).
4. **Orbit-stabilizer identity (independent invariant, every q).** For every orbit,
   `|orbit| · |Stab|` with the stabilizer counted directly by element fixing is asserted equal
   to `|G|`; stabilizers are asserted cyclic of allowed order, and `S₄` order-2 point
   stabilizers are asserted to be transposition-generated (`C₂ₐ`, 6 conjugates), never `C₂ᵦ`.
   When `C₂ᵦ` is split its fixed points are asserted to carry full `C₄` stabilizers (C284's
   completeness remark, now verified at every admissible q).
5. **Fixed-point double count.** The orbit multiset computed from the action equals the one
   predicted from the directly computed split indicators (one exceptional orbit of size
   `|G|/d` per split type, plus `m₁` free orbits), for every embedding.
6. **Class census.** Field-side `(σ,ρ)` class sizes equal the abstract `Aut(G)`-orbit counts
   (`12+24+4+12 = 52`; `120+60+60+60+60+20 = 380`) at every q; the six three-generator product
   orders are equal for every triple; board value and deletion count are constant on every
   class.
7. **Conjugacy spot checks (exhaustive, independent of Dickson).** Enumerating *all*
   involution triples of `PGL₂(q)` and *all* subgroups they generate: `q = 7` `S₄`: 728
   generating triples, 14 subgroups `= 336/24`; `q = 13` `S₄` (the `q ≡ 5 (mod 8)` case new
   in this census): 4,732 triples, 91 subgroups `= 2,184/24`; `q = 11` `A₅`: 8,360 triples,
   22 subgroups `= 1,320/60`. Union-find under conjugation by `PGL₂(q)` generators gives
   exactly 1 conjugacy class in each case, and the subgroup totals equal the normalizer-index
   prediction from the main census.
8. **Normalizer, every q.** `N(G) = G` (order 24 / 60) computed by scanning all `q³−q`
   elements of `PGL₂(q)`; subgroup count `(q³−q)/|G|` recorded per q.

## What is certified, and what is not

Certified: the displayed finite tables — existence, uniqueness up to conjugacy (exhaustively
at the three spot-check fields, by Dickson's classification plus the normalizer computation
elsewhere), orbit types, split indicators, class structure, per-orbit values, and full-board
values for every admissible tame `S₄`/`A₅` realization with odd `q ≤ 101`. The closed-form
value laws are verified on this domain only; they are consequences of the C284 template table
plus the split-indicator congruences and are *not* asserted beyond `q ≤ 101`.

Not certified: anything about wild characteristic (`p | |G|`; see C283), the full
`PSL₂/PGL₂` escape residual, fields beyond `q = 101`, or `A₅` regular values `t₁` beyond the
cited C260/C284 computations. Free-orbit residuals are verified structurally (zero deletions,
3-regular, forced isomorphism of the free-orbit Schreier graph with `Cay(G,T)`), not by
re-solving 60-vertex regular graphs per triple; for `q > 61` the whole-board XOR identity
rests on the per-orbit replays plus orbit disjointness (edges never leave an orbit), not on an
additional monolithic recomputation. Trusted boundary of the checker: one Rust binary
(field tables, matrix action, and the ported C284 abstract classifier); within it, plain
memoized recursion and the `N_G(K)/K`-canonicalized recursion are independent solver paths,
and the abstract and field-side enumerations are independent constructions, but a common bug
in the shared Grundy recurrence would not be caught. Dickson's subgroup classification is used
only where stated (single-class fact for `q` outside the three exhaustive spot checks).

## Reproduction

Working directory: `rust/`. Deterministic; no randomness, timestamps, or host paths.

```bash
rustc -O ../notes/2026-07-17-c288-polyhedral-embedding-census.rs -o /tmp/c288-census
/tmp/c288-census check ../notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.json
/tmp/c288-census json  ../notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.json \
    > ../notes/2026-07-17-c288-polyhedral-embedding-census.json
sha256sum -c ../notes/2026-07-17-c288-polyhedral-embedding-census.sha256
```

`check` prints the summary counts quoted above and asserts every cross-check
(`c284_template_matches=38/38`, `c284_conic_triples=2160`, `total_generating_triples=5912`,
`per_orbit_checks=8540`, `board_direct_checks=3596`, all mismatch counters 0, spot-check
conjugacy classes 1) and ends with `ALL CHECKS PASSED`. The trusted output is the adjacent
JSON; the `.sha256` manifest records SHA-256 and byte counts for the script and the JSON.
Runtime: minutes, single-threaded, negligible memory.

## Draft appendix section for C264 (do not edit the manuscript here)

> **Appendix: tame polyhedral embedding census for `q ≤ 101`.** For every odd prime power
> `q ≤ 101` not excluded by tameness (`p ∤ |G|`; the wild fields `q = 3, 9, 27, 81` for both
> groups and `q = 5, 25` for `A₅`), `PGL₂(q)` contains exactly one conjugacy class of `S₄`
> subgroups, and — when `q ≡ ±1 (mod 5)` — exactly one class of `A₅` subgroups; `A₅` does not
> embed otherwise since `5 ∤ |PGL₂(q)|`. Tables [S4-CENSUS] and [A5-CENSUS] list, for each
> field, the split indicators, the orbit decomposition of `P¹(F_q)`, and the full-board
> Node-Kayles value of every refined generating-triple class. The split indicators obey
> `ε₂ₐ = 1 ⇔ q ≡ 1, 3 (mod 8)`, `ε₄ = 1 ⇔ q ≡ 1 (mod 4)`, `ε₃ = 1 ⇔ q ≡ 1 (mod 3)` for `S₄`,
> and `ε₂ = 1 ⇔ q ≡ 1 (mod 4)`, `ε₃ = 1 ⇔ q ≡ 1 (mod 3)`, `ε₅ = 1 ⇔ q ≡ 1 (mod 5)` for `A₅`.
> Consequently the `S₄` board value depends only on `q mod 8`:
> `v(2,3,3) = 2(ε₂ₐ ⊕ ε₄)` and `v = ε₂ₐ` for the other three classes; in particular the value
> 2 occurs exactly when `q ≡ 3, 5 (mod 8)`. For `A₅`,
> `v(2,3,5) = m₁ mod 2`, `v(2,5,5) = ε₅ ⊕ (m₁ mod 2)`, `v(3,5,5;ρ=3) = ε₃ ⊕ ε₅`,
> `v(5,5,5) = ε₂`, and `v(3,3,5) = v(3,5,5;ρ=5) = 0`, where `m₁` is the number of free
> orbits. Every entry was verified against the coset templates orbit-by-orbit, and the whole
> board was additionally re-solved directly for every generating triple on every field with
> `q ≤ 61` (except the single free-orbit board `A₅, q = 59`), with no discrepancies.

(The two census tables above are ready to paste as [S4-CENSUS] and [A5-CENSUS]; drop the
`direct` column if the appendix states the replay bound in prose.)
