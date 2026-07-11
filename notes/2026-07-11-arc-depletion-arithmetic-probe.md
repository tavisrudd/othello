# A5 probe — does a known arc invariant flag the depleted orders {11, 17}?

**Date**: 2026-07-11 (Claude). Literature + small-arithmetic characterization task; **no solve run**.

## Question

The on-conic escape-depletion quantity `D(q)` (C68,
[`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md)) is

- `D(q) = 0` (undepleted) at `q = 5, 7, 9, 13, 19, 23, 25`,
- `D(q) > 0` (depleted) **exactly at `q = 11, 17`** (`D(11)=5/7`, `D(17)=12/13`;
  min-witness `2 → 1`).

Is any tabulated arc-theoretic invariant of `PG(2,q)` — chiefly the second-largest complete-arc
size `m'(2,q)` — nonzero/exceptional exactly at `{11, 17}` among the tested orders?

**Verdict up front.** **No arc invariant isolates `{11,17}`.** `m'(2,q)` and its natural transforms
each flag a *different* set ({7,9,11,13}, or {9,13,17}, …), never `{11,17}`. The **one** rule that
reproduces the depletion pattern on all nine tested orders is purely arithmetic and has **no known
arc/oval mechanism**: `q` is the **lower member of a twin-prime pair with `q−2` composite**
(equivalently: `q`, `q+2` both prime, `q−2` not prime). It is a 2-positive-point correlate, a priori
suspect (the program has already killed three static config→value dictionaries, C55/C64/C69), and its
one concrete prediction is **q=29 depleted**. Present it as a correlate, not a mechanism.

## 1. The arc data (q = 5..25)

`m'(2,q)` = second-largest complete-arc size (largest complete arc strictly below the conic `q+1`).
Sources: Ball–Lavrauw *Planar arcs* (arXiv:1705.10940) Corollaries 8–9 (primary, exact classification
of size `q−1`, `q−2`, `q−3` arcs); C59 in-repo import
([`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md)) for
`m'(2,23)=17`, `m'(2,25)=21`; standard Hirschfeld tables for `m'(2,17)=m'(2,19)=14`.

| q  | status | type   | conic q+1 | m'(2,q) | m'−q | (q+1)−m' (gap) | q−1 arc? | q−2 arc? | q−3 arc? |
|---:|:------:|:-------|----------:|--------:|-----:|---------------:|:--------:|:--------:|:--------:|
| 5  | U      | prime  | 6         | — (conic only) | — | — | no  | no  | no  |
| 7  | U      | prime  | 8         | 6       | −1   | 2              | **yes**  | no  | no  |
| 9  | U      | square | 10        | 8       | −1   | 2              | **yes**  | yes | yes |
| **11** | **D** | prime | 12     | 10      | −1   | 2              | **yes**  | yes | no  |
| 13 | U      | prime  | 14        | 12      | −1   | 2              | **yes**  | no  | yes |
| **17** | **D** | prime | 18     | 14      | −3   | 4              | no       | no  | yes |
| 19 | U      | prime  | 20        | 14      | −5   | 6              | no       | no  | no  |
| 23 | U      | prime  | 24        | 17      | −6   | 7              | no       | no  | no  |
| 25 | U      | square | 26        | 21      | −4   | 5              | no       | no  | no  |

Classification facts (Ball–Lavrauw, exact):
- Complete `(q−1)`-arcs exist **only** for `q = 7, 9, 11, 13` (none for `q>13`).
- Complete `(q−2)`-arcs exist **only** for `q = 8, 9, 11`.
- Complete `(q−3)`-arcs exist for `q = 9, 13, 16, 17` (odd: `{9,13,17}`; `q=37` open).

`q=25`: `m'(2,25)=q−√q+1=21` (odd-square construction is sharp there).

## 2. Candidate characterizations vs the full undepleted set

Target: flag `{11,17}`, and in particular PASS on `q=23,25` (firmly undepleted).

| # | Candidate (from arc data) | Set it flags | vs {11,17} | q=23 | q=25 |
|--:|:--|:--|:--:|:--:|:--:|
| C1 | has a complete `(q−1)`-arc / `m'(2,q)=q−1` | {7,9,11,13} | **FAIL** | ✓(pred U) | ✓ |
| C2 | has a complete `(q−2)`-arc (odd q) | {9,11} | **FAIL** (misses 17) | ✓ | ✓ |
| C3 | has a complete `(q−3)`-arc (odd q) | {9,13,17} | **FAIL** (misses 11) | ✓ | ✓ |
| C4 | `m'(2,q)` even | {7,9,11,13,17,19} | **FAIL** | ✓ | ✓ |
| C5 | conic gap `(q+1)−m' ∈ {2,4}` | {7,9,11,13,17} | **FAIL** | ✓ | ✓ |
| C6 | `m'(2,q) < q−3` (steep drop) | {19,23,25} | **FAIL** | — | — |

**No transform of `m'(2,q)`, `t₂(2,q)` (smallest complete arc), or the size-`(q−1/2/3)`-arc
existence pattern selects `{11,17}`.** The arc-classification anomalies that *do* live at 11 and 17
point in different directions: `q=11` is the only odd order `>9` with a complete `(q−2)`-arc (C2),
while `q=17` is distinguished by its `(q−3)`-arc (C3) and by `m'` dropping to `q−3` — two *different*
exceptional features that do not unify into a single invariant covering both without also catching
`q=9` or `q=13`. This is consistent with the program's standing finding that the value lives in the
game tree, not in a static arc configuration.

### Arithmetic candidates

| # | Candidate | 5 | 7 | 9 | 11 | 13 | 17 | 19 | 23 | 25 | Result |
|--:|:--|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:--|
| A1 | `q ≡ 2 mod 3` | D? | – | – | D | – | D | – | D? | – | **FAIL** (killed by C29; 5,23) |
| A2 | `q ≡ 5 mod 6` | D? | – | – | D | – | D | – | D? | – | **FAIL** (5,23 are U) |
| **A3** | **`q,q+2` prime & `q−2` composite** | U | U | U | **D** | U | **D** | U | U | U | **PASS 9/9** |

A3 detail (all nine orders): `5`→`q−2=3` prime → excluded (U ✓); `7,13,19,23`→`q+2` composite → not
twin → U ✓; `9,25`→ not prime → U ✓; `11`→`13` prime, `9` composite → **D** ✓; `17`→`19` prime, `15`
composite → **D** ✓.

A3 is the **minimal repair of the failed mod-6 rule (A2)**: A2 failed on exactly `5` and `23`, the two
`≡5 (mod 6)` primes that are undepleted. Twin-primality with `q−2` composite kills both — `23` because
`25=q+2` is composite (not a twin), `5` because `3=q−2` is prime. Note `q=23` already discriminates A3
(predicts U, **correct**) from the naive "all `≡5 mod 6` depleted" reading (predicts D, wrong): the
existing data already favors the twin-prime refinement over a residue class.

## 3. The surviving candidate (A3): predictions and falsifiers

**Rule.** `q` depleted ⟺ `q` prime, `q+2` prime, `q−2` composite (lower twin, isolated below).

| q  | prime? | q+2 | q−2 | A3 prediction | notes |
|---:|:------:|:---:|:---:|:-------------:|:------|
| 23 | y | 25 (comp) | 21 | **UNdepleted** | matches (C54 bucket layer) |
| 25 | n | — | — | **UNdepleted** | matches (census trust tier; see §4) |
| **29** | y | **31 (prime)** | 27 (comp) | **DEPLETED** | twin `(29,31)`, `≡5 mod 6` |
| 31 | y | 33 (comp) | 29 | **UNdepleted** | `≡1 mod 6`; upper twin only |
| 41 | y | 43 (prime) | 39 (comp) | **DEPLETED** | next twin-lower after 29 |
| 47 | y | 49 (comp) | 45 | **UNdepleted** | `≡5 mod 6` **non-twin** — key separator (below) |

**Falsification.** A3 dies if **either**: (i) a `q=29` census returns `D(29)=0` (undepleted) — it
predicts depleted; **or** (ii) any non-twin prime returns depleted, or any twin-lower/`q−2`-composite
prime returns undepleted. The cheapest *positive* test is **q=29** (predicted depleted). The cheapest
test that separates A3 from a bare `≡5 mod 6` residue is a **non-twin `≡5 mod 6` prime** — `q=47` or
`q=53` (`55` composite) — where A3 predicts **UNdepleted** but a residue rule predicts depleted; an
N-bucket at 47 would break A3. (23 already did half of this separation.)

**Discipline caveat, stated plainly.** Twin-primality has **no known connection to `PG(2,q)` arc or
oval structure**. A3 is a correlate fitted to two positive points (plus seven negatives it respects),
not a mechanism. Given C55/C64/C69 already returned negative for static config→value laws, a purely
arithmetic "explanation" of a game-tree value is a priori suspect. The competing null — that `{11,17}`
are simply the *interior* `≡5 mod 6` primes of the tested window `5..25` and the pattern is a
small-window artifact — is **not** refuted by the current data; it is refuted or confirmed only by
extending past the window. A3 and the window-artifact null **agree** that 29 is depleted (29 is both a
twin-lower and `≡5 mod 6`), so **q=29 alone cannot separate them**; only a non-twin `≡5 mod 6` order
(47/53) does.

## 4. What data most cheaply discriminates

1. **q=29 census** settles the *open A5 quantity directly*: C68's min-witness margin `2 (q=11) → 1
   (q=17) → ?`. This is the program's actual live question (does the on-conic escape survive at the
   next depleted order), independent of any characterization. A3 predicts 29 depleted; the C68 trend
   (`ν(q)` doubling `0.357→0.791`, margin `→1`) predicts the margin is the thing at risk. **Highest
   value, and it is the one census the program already wants.** Note it does *not* separate A3 from the
   window-artifact null.
2. **A non-twin `≡5 mod 6` order (q=47 or q=53)** is the only cheap-in-principle test that separates
   twin-primality from a residue class (A3: undepleted; residue: depleted). Much larger census than 29,
   so lower priority unless 29 comes back depleted and the arithmetic question becomes load-bearing.
3. **q=25** is undepleted only at the **current census trust tier** — the last checkpoint had 13/28
   buckets certified all-P, remainder running
   ([`2026-07-10-codex-odd-plane-round4-isomorphisms.md`](2026-07-10-codex-odd-plane-round4-isomorphisms.md),
   [`round3-cross-field`](2026-07-10-codex-odd-plane-round3-cross-field.md)). A3 predicts 25 undepleted
   (not prime); an N-bucket surfacing in the remaining q=25 buckets would break both A3 and the
   "undepleted at squares" pattern. Finishing the q=25 census is a zero-marginal-cost check of the
   negative side.

## Bottom line

The task's headline candidate, `m'(2,q)`, and every arc-classification transform of it **fail** to
isolate `{11,17}`; the arc anomalies at 11 and at 17 are real but *different* (a `(q−2)`-arc at 11, an
`m'=q−3` `(q−3)`-arc at 17) and do not unify. The only characterization surviving all nine tested
orders is the arithmetic **A3 (twin-lower prime, `q−2` composite)** — mechanism-free, thin (2 positive
points), predicting **q=29 depleted / q=31, q=47 undepleted**. Treat it as a falsifiable correlate to
be killed or promoted by the q=29 census, with q=47/53 as the deeper (arithmetic-vs-residue)
tiebreak. The proof-usable object remains C68's min-witness margin, not any static invariant.

## Sources

- Ball, Lavrauw, *Planar arcs*, arXiv:1705.10940 (JCTA) — Cor. 8 (`(q−1)`-arcs only `q=7,9,11,13`),
  Cor. 9 (`(q−2)`-arcs only `q=8,9,11`), `(q−3)`-arcs `q=9,13,16,17`. Primary, exact.
- C59 in-repo import, [`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md)
  — `m'(2,23)=17`, `m'(2,25)=21`, `m'(2,27)=22`, `m'(2,29)=24` (sourced full spectra).
- Marcugini–Milani–Pambianco, *Minimal complete arcs in PG(2,q), q≤32*, arXiv:1005.3412
  (`t₂(2,31)=t₂(2,32)=14`); Bartoli–Davydov et al., *New sizes of complete arcs*, arXiv:1004.2817
  (small-arc tables). Consulted; neither yields a `{11,17}` separator.
- In-repo game data: C68 [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md),
  ν(q) [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md).
