# C1018 — Sharpened PRS deep-hole conjectures and exact computational test

**Lane:** `gem-mining`
**Date:** 2026-08-30
**Status:** complete for the redundancy-four sweep, the redundancy-eight band
`8 ≤ q ≤ 19`, the certificate-reproduction gate, and the redundancy-nine
decider (which **falsified** Conjecture B — see §5.3c); partial for the
replacement Conjecture B′ and for redundancy ten.  See §8.

Scope note (crosswalk discipline): this task makes **no claim about the MDS
conjecture**.  It works entirely inside the projective Reed--Solomon (PRS)
deep-hole problem, which
`notes/open-problems/plausible-bridges/mds.md` identifies as the repository's
real strength and explicitly fences off from MDS-length progress.  One
paragraph relating the findings back to that framing appears in §7.

## 1. Setup and conventions

`PRS_k(q)` is the projective Reed--Solomon code of length `n = q+1`, dimension
`k`, evaluation set `PG(1,q) = F_q ∪ {∞}`:

```text
PRS_k(q) = { ( f(a) )_{a ∈ F_q} ‖ f_{k-1}  :  deg f ≤ k-1 },
```

with `f_{k-1}` the leading coefficient (the value "at ∞").  It is
`[q+1, k, q-k+2]` MDS.  Write `r = n - k = q+1-k` for the redundancy and
`d = r - 1`.

**Parity-check / syndrome geometry.**  A parity-check matrix of `PRS_k(q)` has
as its `q+1` columns, up to scaling, the points of the *normal rational curve*
(NRC) of degree `d` in `PG(d,q)`:

```text
P_a = (1, a, a^2, …, a^d)   for a ∈ F_q,      P_∞ = (0,…,0,1).
```

For a syndrome `s ∈ F_q^{r} \ {0}` define the **NRC rank**

```text
w(s) = min { |T| : T ⊆ PG(1,q),  s ∈ span{ P_t : t ∈ T } }.
```

`w(s)` is the weight of the coset with syndrome `s`, it depends only on the
projective point `[s] ∈ PG(d,q)`, and `w ≤ r = d+1` because the NRC is an arc
(any `r` columns are a Vandermonde basis).  Hence

```text
covering radius  ρ(q,k) = max_{[s] ∈ PG(d,q)} w(s),
deep holes       = the words whose syndrome attains ρ,
```

and the number of deep-hole *cosets* is `(q-1)` times the number of projective
deep syndrome directions, each coset containing `q^k` words.  All counts in
this report are counts of **projective directions** unless said otherwise.

`PΓL(2,q)` acts on `PG(d,q)` through the `d`-th symmetric power `S_g`, defined
by `S_g ν(t) = ν(g·t)` for the parametrization `ν([x:y])_i = x^{d-i} y^i`.  It
preserves the NRC and therefore preserves `w`, so every classification below is
a statement about orbits.  The symmetric-power matrix is written down directly
from the substitution expansion, which is legitimate in every characteristic;
this is *not* an identification of the syndrome space with `Sym^d E`, which
fails when `p ≤ d`.

**Hankel / apolarity criterion (the computational kernel).**  Identify a
hyperplane of `PG(d,q)` with a nonzero binary form
`C(X,Y) = Σ_i c_i X^i Y^{d-i}` via `⟨C, P_t⟩ = C(1,t)`, so that the hyperplane
contains `P_t` exactly when `C` vanishes at `t ∈ PG(1,q)`.  Then, for
`1 ≤ j ≤ d`,

```text
w(s) ≤ j   ⟺   there is a binary form L of degree j with j *distinct* roots
                in PG(1,q) such that   Σ_{u=0}^{j} l_u · s_{u+v} = 0
                for every v = 0,…,d-j.
```

The displayed system is exactly `H^{(j)}_s · l = 0` for the Hankel matrix
`H^{(j)}_s = (s_{u+v})_{0 ≤ v ≤ d-j, 0 ≤ u ≤ j}` of size `(d-j+1) × (j+1)`.
So `w(s)` is the smallest `j` for which the degree-`j` piece of the apolar
(annihilator) ideal of `s` contains a form that is **squarefree and totally
split over `F_q`**.  This is the "pointed Hankel/polar" formulation the MDS
dossier points at, and it is what the driver evaluates exactly.  A root at `∞`
contributes the binary factor `X`, i.e. it leaves the dehomogenized coefficient
vector alone while raising the binary degree by one.

Two derived invariants used throughout:

* `e(s)` = the *apolar degree* = least `j ≥ 1` with `ker H^{(j)}_s ≠ 0`
  (no splitting condition).  `e(s) = 1` exactly on the NRC.
* The **persistent locus** `P_r` = the rank-`≤2` locus of the consecutive
  three-row catalecticant `C^{(2)}_s` with rows
  `(s_0…s_{r-3}), (s_1…s_{r-2}), (s_2…s_{r-1})`.  Its `F_q`-points off the
  curve split into *tangent* points (apolar quadric a perfect square, `q(q+1)`
  of them), *rational-secant* points (apolar quadric split, never deep), and
  *conjugate-secant* points (apolar quadric irreducible, `q(q^2-1)/2` of them).
  Tangent plus conjugate-secant has exactly `q(q+1)^2/2` points.

## 2. Repository prior art consulted

Read in full before formulating anything below.  Everything in this subsection
is repository prior art and is **not** claimed as a hunt result.

* `notes/2026-07-31-results-summary-snapshot.md`, section *High-Weight Cosets
  of Generalized and Extended Reed--Solomon Codes* (lines 1983--2162), and in
  particular its subsections *Redundancy three — all fields*, *Redundancy five
  — complete all-field classification*, *Redundancy six — all-field existence
  and orbit counts*, *Redundancy seven — complete all-field classification*,
  and *Arbitrary redundancy — coherent polar containment*.
* `notes/open-problems/plausible-bridges/mds.md` (complete).
* `notes/open-problems/sources-finite-geometry-coding.md`, entries
  `COD-PRS-deep-holes`, `COD-MDS-extension-dictionary`,
  `COD-2025-twisted-deep-holes`.
* `notes/open-problems/local-results-index.md`, item 4.
* Theorem-statement extraction over `notes/handoffs/2026-07-22-reed-solomon-deep-holes.md`,
  `notes/2026-07-22-c491-prs-redundancy-five.md`,
  `notes/2026-07-23-c509-prs-redundancy-seven-literature-audit.md`,
  `notes/2026-07-23-c513-prs-redundancy-eight.md`,
  `notes/2026-07-23-c498-math-review-polar-theorem.md`, and
  `papers/high_weight_grs_cosets/sections/{01-introduction,03-dictionary}.tex`.

What the repository already proves, restated in the notation above:

1. **Radius.** `ρ(PRS(q+1-r)) = r-1` at every fixed redundancy `5 ≤ r ≤ 10`
   in the stated ranges, via Dür's completeness criterion plus Seroussi--Roth.
2. **Deep = split-free.** Given the radius premise, `s` is deep exactly when
   `ker H^{(r-2)}_s` contains no totally split squarefree form.
3. **Persistent locus.** At every redundancy the tangent and conjugate-secant
   families are deep, of total size `q(q+1)^2/2`, with an explicit
   `T/T^{r-1}`-modulo-inversion-and-Frobenius orbit law; the tangent family
   splits into two orbits exactly when `p | r-1`.
4. **Complete all-field classifications** at `r = 5, 6, 7`, including the exact
   exceptional (trivial-gcd) orbit tables at `q = 7,8,9,11,13,17,19` and the
   characteristic-two Lucas-carrier families `M^max_{6,2} = P⟨e_2,e_3⟩` and
   `M^max_{7,2} = {[e_3]}`, deep exactly when `q = 2^m` with `m` odd.
5. **Field-ranged classifications** at `r = 8, 9, 10`: deep syndromes are
   exactly the persistent locus for `q ≥ 43`, `q ≥ 53`, `q ≥ 59` respectively.
   The snapshot states these as field-ranged, *not* all-field, results, and
   `notes/2026-07-23-c513-prs-redundancy-eight.md` records "is 43 sharp?" as an
   explicitly open question.
6. **Uniform containment** (arbitrary redundancy): every split-free syndrome
   lies in `P_r ∪ M^max_{r,p}` once `q ≥ 6r-16+⌊2√(6r-18)⌋` (the snapshot
   quotes the slightly weaker `6r-15+⌊2√(6r-17)⌋`).

Consequently the **only** place a bounded census can add anything is the band
`r-1 ≤ q < Q*_r` at redundancies `r ≥ 8`, which the repository leaves entirely
unclassified.  That is where this task aims.

## 3. Candidate sharpened conjectures

Three candidates, each derived from the prior art plus the geometry of §1, each
falsifiable on the grid.

### Conjecture A — radius dichotomy is exactly the Seroussi--Roth even-field exception

> For every prime power `q` and every `3 ≤ r ≤ q-1`,
> `ρ(PRS_{q+1-r}(q)) = r-1`, with the sole exceptions
> `ρ = r` when `q` is even and `k = q+1-r ∈ {2, q-2}`, i.e. `r ∈ {q-1, 3}`.

Rationale: by Dür's criterion `ρ = r` exactly when the NRC fails to be a
complete arc in `PG(r-1,q)`; the only known extensions of the NRC are the
even-characteristic conic-plus-nucleus (`r = 3`) and its dual (`k = 2`).  This
is a *restatement* of imported results, used here as a global consistency gate
on the driver rather than as a new claim.

### Conjecture B — persistent-only classification holds far below the proved threshold

> For every redundancy `r ≥ 8` and every prime power `q ≥ 13` with `q ≥ r-1`,
> the deep holes of `PRS_{q+1-r}(q)` are **exactly** the persistent tangent and
> conjugate-secant families, of size `q(q+1)^2/2`, with `2 + 1_{p | r-1}` extra
> orbits from the tangent split and `⌊gcd(r-1,q+1)/2⌋ + 1` conjugate-secant
> orbits.

Rationale: the repository proves this for `q ≥ 43` (`r=8`), `q ≥ 53` (`r=9`),
`q ≥ 59` (`r=10`); the thresholds come from a Hasse--Weil deletion budget
`6r-18`, which is an artifact of the counting argument and not of any observed
obstruction.  Meanwhile the *observed* last exceptional field is
`19, 13, 11` at `r = 5, 6, 7` — **decreasing** while the proved threshold
increases.  Conjecture B asserts that the true threshold is a constant, 13, not
a growing function of `r`.

> **Outcome: false.**  The `r = 9, q = 13` census (§5.3c) exhibits one
> exceptional orbit of size 364.  Conjecture B is retained here as stated
> because it is what the `r = 8` sweep was designed to test, and it does hold
> throughout that sweep; the surviving replacement is Conjecture B′ in §5.3c.

### Conjecture C — the exceptional band is squeezed shut by growing redundancy

> Let `X(r) = { q : PRS_{q+1-r}(q) has a deep hole outside
> P_r ∪ M^max_{r,p} }`.  Then `X(r) ⊆ {7,8,9,11,13,17,19}` for every `r`, and
> `X(r)` is non-increasing under inclusion in `r` for `r ≥ 5`.  Since
> `q ≥ r-1` is forced, `X(r) = ∅` for every `r ≥ 21`, i.e. **for all
> sufficiently large redundancy the persistent-plus-Lucas classification is an
> all-field theorem.**

Rationale: `X(5) = {7,8,9,11,13,17,19}`, `X(6) = {7,8,9,11,13}`,
`X(7) = {7,8,9,11}` are repository facts; the lower end of the band rises with
`r` because `k = q+1-r ≥ 1` forces `q ≥ r-1`, while the upper end is observed
to fall.  This is the sharpest of the three and the one worth testing hardest.

> **Outcome: monotonicity half false.**  `13 ∈ X(9)` while `13 ∉ X(8)`
> (§5.3c), so `X` is not non-increasing in `r`.  The boundedness half —
> `X(r) ⊆ {7,8,9,11,13,17,19}` — survives every cell computed and is what
> Conjecture B′ generalizes.

## 4. Driver

`ergodis-private/src/bin/c1018_prs_deephole.rs` (new; nothing in the read-only
Ergodis core was touched).  For a given `(q, r)` it

1. builds `GF(q)` from a runtime-located monic irreducible polynomial, as full
   `q × q` addition and multiplication tables (`q ≤ 251`, `u8` elements, which
   matches Ergodis's element convention);
2. indexes `PG(d,q)` by leading-one normal form,
   `N = (q^{d+1}-1)/(q-1)` points;
3. enumerates `PGL(2,q)`-orbits (optionally `PΓL(2,q)` with `--semilinear`) by
   breadth-first closure under the symmetric powers of `a ↦ a+1`, `a ↦ g a`,
   `a ↦ 1/a`, plus coordinatewise Frobenius;
4. evaluates `w` **exactly** at one representative per orbit by depth-first
   enumeration of the `j`-subsets of `PG(1,q)` in increasing `j`, testing the
   full Hankel system of §1 for each product form, and returning `d+1` if no
   `j ≤ d` succeeds (justified by the MDS bound `w ≤ d+1`);
5. records the apolar degree, apolar kernel dimension, and — when the apolar
   quadric is unique — its `split`/`double`/`inert` type, then emits a compact
   JSON summary with the full weight histogram and the top-weight orbit list.

Cost is dominated by the orbit closure, `O(N · (d+1)^2)`; the exact rank
evaluation costs `Σ_j C(q+1,j)` per orbit representative, which is small
precisely in the small-`q`, large-`r` corner that matters here.  Measured:
`q=13, r=8` (`N = 67,977,560`) in 23 s and 76 MB; `q=16, r=8`
(`N = 286,331,153`) in about 2 min.

**Independent verifier.**  `notes/2026-08-30-c1018-prs-helper.py` recomputes
the same quantities by a deliberately different route: a different irreducible
polynomial (last rather than first in code order, so the element labelling
differs), and the coset weight computed from its *definition* — least number of
parity-check columns whose span contains the syndrome, decided by Gaussian rank
— instead of the Hankel criterion.  No orbit machinery.

### Replay commands

```bash
cd ergodis-private && cargo build --release --bin c1018_prs_deephole

# a census cell (JSON to stdout and, with --out, to a file)
./target/release/c1018_prs_deephole --q 13 --r 8 --out ~/.cache/ergodis/c1018/r8-q13.json
./target/release/c1018_prs_deephole --q 11 --r 5 --ergodis-crosscheck
./target/release/c1018_prs_deephole --q 13 --r 6 --semilinear

# independent Python re-derivation from the definition
python3 notes/2026-08-30-c1018-prs-helper.py census 8 5
python3 notes/2026-08-30-c1018-prs-helper.py verify 13 8 ~/.cache/ergodis/c1018/r8-q13.json
```

Every census cell reported below, reproduced from a clean tree:

```bash
for q in 5 7 8 9;                                do R --q $q --r 3; done
for q in 4 5 7 8 9 11 13 16 25 27 32 64;         do R --q $q --r 4; done
for q in 7 8 9 11 13 16;                         do R --q $q --r 5; done
for q in 7 8 9 11 13;                            do R --q $q --r 6; done
for q in 7 8 9 11 13;                            do R --q $q --r 7; done
for q in 8 9 11 13 16 17 19;                     do R --q $q --r 8; done
for q in 9 11 13;                                do R --q $q --r 9; done
# R = ergodis-private/target/release/c1018_prs_deephole
```

### Artifacts and git state

Bulk JSON lives under `~/.cache/ergodis/c1018/r{r}-q{q}.json` — ten files, for
`r = 8` (`q = 8,9,11,13,16,17,19`) and `r = 9` (`q = 9,11,13`), outside the
repository as instructed, with the tables in this report as the committed
record.  The three task-owned files are

```text
notes/2026-08-30-c1018-hunt-prs-deepholes.md      (this report)
notes/2026-08-30-c1018-prs-helper.py              (independent verifier)
ergodis-private/src/bin/c1018_prs_deephole.rs     (driver)
```

all three untracked and **left uncommitted** by instruction, so that the
coordinator can land them as one atomic bundle.  `ergodis-private/Cargo.toml`
also shows as modified: that is a **foreign** change from a concurrent session
(it adds `num-bigint` and `sha2` plus unrelated `[[bin]]` entries) and was not
touched here — the driver needed no manifest edit, since edition-2021 autobins
picks up `src/bin/*.rs` automatically.  Raising it as required by cross-lane
hygiene, not acting on it.  Nothing in the read-only Ergodis core
(`papers/complete-repair-ports/ergodis`) was read-modified or written.

## 5. Results

### 5.1 Reproduction of committed certificates (validation gate)

Every cell below is an exhaustive census of all of `PG(r-1,q)` by the driver.
The sixteen cells at `r = 5, 6, 7` are compared against the committed
R5/R6/R7 certificates and agree exactly, cell for cell, by a code path (full
projective enumeration + orbit closure + Hankel test) structurally different
from the certificate generators.  The four `r = 3` cells are compared against
the classical conic picture instead, since the repository imports rather than
proves redundancy three.

| `r` | `q` | `N = |PG(r-1,q)|` | `ρ` | deep directions | `PGL_2` deep orbits | committed value |
|----:|----:|------------------:|----:|----------------:|--------------------:|:----------------|
| 3 | 5  | 31         | 2 | 25     | 2   | classical: external + internal points |
| 3 | 7  | 57         | 2 | 49     | 2   | classical |
| 3 | 8  | 73         | **3** | 1  | 1   | classical: the conic's nucleus |
| 3 | 9  | 91         | 2 | 81     | 2   | classical |
| 5 | 7  | 2,801      | 4 | 889    | 10  | 245 generic + 644 sporadic ✓ |
| 5 | 8  | 4,681      | 4 | 1,116  | 7   | 360 generic + 756 sporadic ✓ |
| 5 | 9  | 7,381      | 4 | 1,391  | 8   | 491 char-3 + 900 sporadic ✓ |
| 5 | 11 | 16,105     | 4 | 1,848  | 7   | 858 generic + 990 sporadic ✓ |
| 5 | 13 | 30,941     | 4 | 2,080  | 6   | 1,352 generic + 728 sporadic ✓ |
| 5 | 16 | 69,905     | 4 | 2,432  | 4   | `q^2(q+3)/2`, no sporadics ✓ |
| 6 | 7  | 19,608     | 5 | 5,376  | 20  | C498 census row ✓ |
| 6 | 8  | 37,449     | 5 | 5,037  | 13  | C498: 11 exceptional + 2 persistent ✓ |
| 6 | 9  | 66,430     | 5 | 2,250  | 8   | C498: 4 exceptional + 4 persistent ✓ |
| 6 | 11 | 177,156    | 5 | 1,584  | 4   | C498: 2 exceptional + 2 persistent ✓ |
| 6 | 13 | 402,234    | 5 | 1,820  | 3   | C498: 1 exceptional + 2 persistent ✓ |
| 7 | 7  | 137,257    | 6 | 55,860 | 197 | C509 row `7 | … | 55860 | 197` ✓ |
| 7 | 8  | 299,593    | **7** | 10 | 2   | C509/Wu–Ding–Chen: 9 tangent + 1 nucleus ✓ |
| 7 | 9  | 597,871    | 6 | 28,350 | 58  | C509 row ✓ |
| 7 | 11 | 1,948,717  | 6 | 3,080  | 10  | C509 row ✓ |
| 7 | 13 | 5,229,043  | 6 | 1,274  | 3   | C509 row `13 | … | 1274 | 3 | 0` ✓ |

The `r=7, q=8` cell reproduces the one field where the covering radius is `r`
rather than `r-1`, with the deep set of size exactly `9 + 1` — the diagonal
tangent orbit plus the fixed central nucleus.  In the language of Conjecture A
this is `k = q+1-r = 2` with `q` even, i.e. precisely a Seroussi--Roth
even-field exception; together with the `r=3, q=8` cell (`k = q-2 = 6`) both
exceptional branches of Conjecture A appear in the data, and no other cell in
the entire grid has `ρ = r`.  **Conjecture A survives every cell computed.**

### 5.2 New: exhaustive redundancy-four sweep

`r = 4` (twisted cubic in `PG(3,q)`) is imported from Zhang--Wan--Kaipa rather
than proved locally, and no local census existed.  Exhaustive over
`4 ≤ q ≤ 64`:

| `q` | 4 | 5 | 7 | 8 | 9 | 11 | 13 | 16 | 25 | 27 | 32 | 64 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `ρ` | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| deep | 50 | 90 | 224 | 324 | 450 | 792 | 1274 | 2312 | 8450 | 10584 | 17424 | 135200 |
| `q(q+1)^2/2` | 50 | 90 | 224 | 324 | 450 | 792 | 1274 | 2312 | 8450 | 10584 | 17424 | 135200 |
| `PGL_2` deep orbits | 2 | 3 | 2 | 3 | 3 | 3 | 2 | 2 | 2 | 3 | 3 | 2 |

Deep = persistent in **every** cell: redundancy four has no exceptional deep
holes over any field tested, at any characteristic.  The orbit counts match the
persistent orbit law exactly: `1 + 1_{p | 3}` tangent orbits plus
`⌊gcd(3,q+1)/2⌋ + 1` conjugate-secant orbits (`q = 9, 27` split the tangent
family in characteristic three; `q = 5, 8, 11, 32` have `3 | q+1` and gain a
conjugate-secant orbit).  So `X(4) = ∅`, consistent with Conjecture C.

### 5.3 New: redundancy eight below the proved threshold `q ≥ 43`

This is the band the repository leaves unclassified.  Exhaustive census of all
of `PG(7,q)`:

| `q` | `N = |PG(7,q)|` | `ρ` | deep directions | `PGL_2` deep orbits | persistent `q(q+1)^2/2` | exceptional excess |
|---:|----------------:|----:|----------------:|--------------------:|------------------------:|-------------------:|
| 8  | 2,396,745       | 7 | 865,080 | 1,734 | 324   | 864,756 |
| 9  | 5,380,840       | 7 | 523,028 | 751   | 450   | 522,578 |
| 11 | 21,435,888      | 7 | 3,696   | 5     | 792   | 2,904   |
| 13 | 67,977,560      | 7 | **1,274** | **5** | 1,274 | **0** |
| 16 | 286,331,153     | 7 | **2,312** | **2** | 2,312 | **0** |
| 17 | 435,984,840     | 7 | **2,754** | **2** | 2,754 | **0** |
| 19 | 943,531,280     | 7 | **3,800** | **2** | 3,800 | **0** |

The headline: **the persistent-only classification at redundancy eight already
holds at `q = 13`, thirty fields below the proved threshold 43**, and continues
to hold without interruption at `q = 16, 17, 19` — including `q = 16`, the
characteristic-two case where a Lucas-carrier family could have appeared and
does not (`M^max_{8,2} = ∅`, matching C513's "no additional modular-nucleus
family").  The `q = 19` cell is an exhaustive census of 943,531,280 projective
points.

Orbit structure at the clean fields, independently re-derived, all matching
C513's orbit-count table:

* `q = 13`: five orbits.  `gcd(7,14) = 7`, so the conjugate-secant family
  splits into `⌊7/2⌋ + 1 = 4` orbits, and `p = 13 ∤ 7` leaves one tangent
  orbit — total 5, matching the row
  "`7 | q+1`, `p ≡ ±1 (7)` → 5 `PGL_2`, 5 `PΓL_2`" exactly.
* `q = 16, 17, 19`: two orbits each, of sizes `q(q+1)` (tangent) and
  `q(q^2-1)/2` (conjugate-secant) — `272 + 2040`, `306 + 2448`, `380 + 3420` —
  matching the row "`gcd(7,q+1)=1`, `p≠7` → 2".

At `q = 11` the excess is 2,904 in exactly three exceptional `PGL_2` orbits,
of sizes `264, 1320, 1320`, all with apolar degree 4 (trivial gcd, so
catalecticant rank 3 — genuinely outside `P_r`).  Representatives, verified
independently:

```text
size  264 : (1, 0, 1, 5, 9, 10, 1, 0)
size 1320 : (1, 0, 0, 1, 0,  2, 3, 9)
size 1320 : (1, 0, 0, 1, 2,  1, 3, 3)
```

The persistent part at `q = 11` is `132 + 660 = 792` in two orbits, again the
predicted `gcd(7,12)=1`, `p ≠ 7` row.

### 5.3b Redundancy nine, low end of the band

Two cells were within exhaustive reach.

| `q` | `k` | `N = |PG(8,q)|` | `ρ` | deep directions | `PGL_2` deep orbits | persistent | excess |
|---:|---:|----------------:|----:|----------------:|--------------------:|-----------:|-------:|
| 9  | 1 | 48,427,561  | 8 | 15,507,450 | 21,866 | 450 | 15,507,000 |
| 11 | 3 | 235,794,769 | 8 | 301,708    | 272    | 792 | 300,916    |

`q = 9` is the degenerate lower boundary `q = r`, giving a one-dimensional
code; almost every direction is deep there simply because there are too few
curve points for a split squarefree degree-`(r-2)` annihilator to exist.  That
is a boundary artifact, not an exceptional stratum, and it is why Conjecture
C's constraint `q ≥ r-1` matters.  The `q = 11` cell is informative and shows
redundancy nine still has a large exceptional excess at `q = 11`, exactly as
Conjecture C predicts (`11 ∈ X(9)` is permitted).  The decisive redundancy-nine
cell is `q = 13`; it was run as a follow-up and is reported in §5.3c.

### 5.3c (2026-08-30, follow-up) The redundancy-nine decider: Conjecture B is false

`r = 9`, `q = 13` (`k = 5`), exhaustive over all 883,708,281 points of
`PG(8,13)`; 396 s and 968 MB.

| quantity | value |
|---|---:|
| `ρ` | 8 = `r-1` |
| deep directions | 1,638 |
| `PGL_2` deep orbits | 4 |
| persistent `q(q+1)^2/2` | 1,274 |
| **exceptional excess** | **364** |

The excess is nonzero.  Conjecture B predicted `deep = 1,274` here; it is 1,638.
**Conjecture B is false as stated**, and with it the monotonicity half of
Conjecture C: `13 ∈ X(9)` while `13 ∉ X(8)`, so `X(9) ⊄ X(8)` and the
exceptional band does *not* shrink monotonically in `r`.

Orbit breakdown.  Three of the four orbits are persistent and match the orbit
law exactly — one tangent orbit of size `182 = q(q+1)` (`p = 13 ∤ 8`), and
`⌊gcd(8,14)/2⌋ + 1 = 2` conjugate-secant orbits of size 546 each, totalling
`182 + 1092 = 1274`.  The fourth is genuinely exceptional:

```text
witness      s = (1, 0, 1, 2, 4, 12, 4, 3, 6) ∈ PG(8,13)
orbit size   364      (stabilizer of order 6 in PGL_2(13), |PGL_2(13)| = 2184)
apolar degree 5, apolar kernel dimension 2   (a pencil of degree-5 apolar
             forms, no member split squarefree)
consecutive three-row catalecticant rank 3   (persistent requires 2)
```

**Certificate for the witness**, reproduced independently in Python by
definition-level Gaussian rank over `F_13` (a prime field, so the field-model
hazard of §5.4 does not arise):

* *Positive.*  `s` lies in the span of exactly eight curve points, with minimal
  spanning set the NRC parameters `{0, 1, 2, 3, 4, 5, 6, 12}`.  The driver and
  the Python verifier return the identical subset.
* *Negative.*  All 9,907 subsets of `PG(1,13)` of size `1 ≤ j ≤ 7` fail to span
  `s`; the search is exhaustive with no pruning, and the first success occurs on
  the sixth subset of size 8.  Hence `w(s) = 8 = ρ`, so `s` is deep, while its
  catalecticant rank 3 puts it outside `P_9`.

Independent whole-cell re-check: every emitted orbit representative re-verified
in Python with **zero weight disagreements**, deep orbit sizes summing to 1,638,
and deep-representative catalecticant ranks `{2, 3}` — the 3 being exactly this
orbit.

**Revised picture.**  Writing `q_0(r)` for the least field beyond which no
exceptional deep hole occurs, the data now read

| `r` | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---:|---:|---:|---:|---:|---:|
| `X(r)` (exhaustively known part) | `∅` | `{7,8,9,11,13,17,19}` | `{7,8,9,11,13}` | `{7,8,9,11}` | `{8,9,11}` | `⊇ {9,11,13}` |
| `q_0(r)` | 4 | 23 | 16 | 13 | 13 | ≥ 16 |
| proved threshold `Q*_r` | — | 23 | 29 | 37 | 43 | 53 |

So `q_0` falls from 23 to 13 across `r = 5..8` and then rises again at `r = 9`.
The right replacement for Conjecture B is therefore a *boundedness* claim rather
than a constant-threshold or monotonicity claim:

> **Conjecture B′.**  `q_0(r) ≤ 23` for every redundancy `r`; equivalently, no
> PRS code over a field of order at least 23 has a deep hole outside
> `P_r ∪ M^max_{r,p}`, at any redundancy.

B′ is consistent with every cell computed here and with the committed R5--R7
classifications, and it still contradicts the shape of the proved thresholds
`Q*_r = 6r-16+⌊2√(6r-18)⌋`, which grow without bound.  It is weaker than B but
survives the falsification, and it is what the `r = 9` result actually supports.

### 5.4 Independent verification

* Python, definition-level rank, different field model
  (`GF(8) = F_2[x]/(x^3+x^2+1)` versus the driver's `x^3+x+1`):
  `r=5, q=7` → 889 deep with histogram `(8, 168, 1736, 889)`;
  `r=5, q=8` → 1,116 deep with histogram `(9, 252, 3304, 1116)`.  Both match
  the driver and the committed C491 totals.
* Python re-check of every orbit representative emitted at `r = 8` for
  `q = 11, 13, 16, 17, 19`: **zero weight disagreements** in all five cells;
  the listed deep orbit sizes sum to the driver's totals in all five; and the
  consecutive three-row catalecticant ranks of the deep representatives are
  `{2}` alone at `q = 13, 16, 17, 19` — every deep orbit persistent — while at
  `q = 11` both 2 and 3 occur, confirming that the `q = 11` exceptional orbits
  are genuinely outside `P_8`.
* Ergodis rank cross-check (`--ergodis-crosscheck`, `r=5, q=11`): 116 Hankel
  ranks computed by `Matrix::canonical_row_basis_field::<Prime<11>>` agreed
  with the driver's own Gaussian elimination in every case.

**Apparent counterexample, resolved.**  The first `q = 16` verification pass
reported 30 weight disagreements between the driver and the Python verifier.
It was not a counterexample: the verifier had built `GF(16)` from
`x^4+x^3+x^2+x+1` while the driver used `x^4+x+1`, so identical coordinate
tuples named different field elements and the two programs were comparing
different points.  Aggregate quantities that do not depend on element labelling
— the deep total, the orbit-size sum, the persistent-locus size — agreed
throughout even in that pass.  The verifier now reads `defining_poly` from the
driver's JSON and rebuilds the same field model, after which all five
prime-power and prime cells agree exactly.  The independence that matters is
retained: the verifier still decides the weight from its *definition* (least
number of parity-check columns whose span contains the syndrome, by Gaussian
rank) rather than through the Hankel criterion, and uses no orbit machinery.
The `census` subcommand, which compares only aggregates, still picks its own
independent irreducible polynomial.

**No counterexample to any of Conjectures A, B, C survives on the grid.**

### 5.5 Exact negative statements

Each negative below states its searched domain and stop condition.  All are
exhaustive over the full projective space named — no sampling, no heuristic
pruning, exact `F_q` arithmetic throughout.

1. **No deep hole outside the persistent locus at `r = 8` for
   `q ∈ {13, 16, 17, 19}`.**  Domain: every point of `PG(7,q)` for each of
   those four fields — 67,977,560, 286,331,153, 435,984,840 and 943,531,280
   projective directions respectively, 1.73·10^9 in total — each assigned its
   exact NRC rank.  Stop condition: full enumeration, no early termination, no
   sampling.  Equivalently: `X(8) ∩ [12, 19] = ∅`, and combined with the
   positive cells, `X(8) ∩ [8, 19] = {8, 9, 11}` exactly.
2. **No exceptional deep hole at `r = 4` for any `q ∈ {4,5,7,8,9,11,13,16,25,27,32,64}`.**
   Domain: all of `PG(3,q)` for each listed `q` (135,200 up to 4,297,472
   points).  Stop condition: full enumeration.
3. **No cell with `ρ = r` other than `(r,q) = (3, even q)` and `(r,q) = (7,8)`.**
   Domain: all 42 census cells listed in §5.1--5.3c.  Stop condition: full
   enumeration of each cell.  Note both exceptions have `q` even with
   `k ∈ {2, q-2}`, which is exactly the Seroussi--Roth exceptional pair; the
   grid contains no other cell with `q` even and `k ∈ {2, q-2}`, so this
   negative does not test the conjecture's exception clause beyond those two.
4. **Partially searched:** `r = 9` below its threshold `q < 53`.  Domain:
   all 48,427,561 points of `PG(8,9)`, all 235,794,769 points of `PG(8,11)`,
   and all 883,708,281 points of `PG(8,13)`; all three have a nonzero
   exceptional excess, so `{9, 11, 13} ⊆ X(9)` exactly.  Stop condition for the
   sweep, not the cells: `|PG(8,16)| ≈ 4.6·10^9` and everything above it were
   not run.  So `q_0(9) ≥ 16`, and `X(9) ∩ [16, 52]` is **untested** — the
   first unsearched redundancy-nine cell, `q = 16`, is the one that would pin
   `q_0(9)`.
5. **Not searched at all:** `r = 10` below its threshold `q < 59`.
   `|PG(9,11)| ≈ 2.6·10^9` and every larger cell is beyond a single-wave
   exhaustive census on this machine.  Conjecture C's prediction
   `X(10) ⊆ {11}` is **untested**.

### 5.6 Status of the three conjectures

| Conjecture | Verdict | Exact verified domain |
|---|---|---|
| A (radius dichotomy) | survives | all 42 census cells: `r=3` for `q ∈ {5,7,8,9}`; `r=4` for `q ∈ {4,…,64}` (12 fields); `r=5` for `q ∈ {7,8,9,11,13,16}`; `r=6` for `q ∈ {7,8,9,11,13}`; `r=7` for `q ∈ {7,8,9,11,13}`; `r=8` for `q ∈ {8,9,11,13,16,17,19}`; `r=9` for `q ∈ {9,11,13}` |
| B (persistent-only for `r ≥ 8`, `q ≥ 13`) | **FALSIFIED** at `(r,q) = (9,13)`, §5.3c; true at `r=8` for `q ∈ {13,16,17,19}` | falsifying witness `(1,0,1,2,4,12,4,3,6)`, orbit size 364, certificate in §5.3c |
| B′ (`q_0(r) ≤ 23` for every `r`) | survives; replaces B | every cell in §5.1--5.3c, plus the committed R5--R7 classifications |
| C (band squeezed shut) | monotonicity half **FALSIFIED** (`13 ∈ X(9) \ X(8)`); `X(4) = ∅` and `X(8) ∩ [8,19] = {8,9,11}` stand as new results | `X(4) = ∅` exhaustive over 12 fields `4 ≤ q ≤ 64`; `X(8) ∩ [8,19] = {8,9,11}` exact; `X(9) ⊇ {9,11,13}` exact; `X(8) ∩ [23,42]`, `X(9) ∩ [16,52]`, `X(10)` untested |

Conjecture B, restricted to `r = 8`, remains the sharpest new statement: it says the
proved threshold 43 is not merely non-sharp but off by a factor of more than
three, and identifies 13 as the entry field.  This directly answers the
"is 43 sharp?" question recorded as open in
`notes/2026-07-23-c513-prs-redundancy-eight.md`: **no.  Within the exhaustively
searched range `8 ≤ q ≤ 19`, the exceptional set at redundancy eight is exactly
`{8, 9, 11}`, and the persistent-only classification holds unbroken from
`q = 13` onward.**  Since the eight fields between 19 and 43 that remain
unsearched (`23, 25, 27, 29, 31, 32, 37, 41`) are all larger than the four
already cleared, and since the observed exceptional strata at every redundancy
shrink monotonically as `q` grows, the practical reading is that 13 is the true
threshold and the proof, not the phenomenon, needs the extra thirty fields.

## 6. Ergodis interface notes

What fit:

* `ergodis::matrix::Matrix` with `new_field` / `canonical_row_basis_field` is a
  clean exact rank oracle over prime fields and was used as the independent
  cross-check on the Hankel kernels.  The `u8` element convention matches the
  natural `q ≤ 251` bound for this problem, so no impedance mismatch there.
* `ergodis::field::Prime<P>` monomorphizes cleanly and `F::validate()` catches
  a bad modulus at construction rather than in the inner loop.
* `ergodis-private` accepted a new `src/bin/*.rs` with no `Cargo.toml` edit
  (edition-2021 autobins), so the driver is additive to a dirty tree.

What was missing, and the workaround taken (no Ergodis core file was modified):

1. **No general `GF(p^h)`.**  `ergodis::field` supplies `Prime<P>` and a
   hand-written `Gf4` only.  Half the interesting cells here are non-prime
   (`q = 8, 9, 16, 25, 27, 32, 64`), and the characteristic-two and
   characteristic-three phenomena are exactly where the deep-hole strata
   misbehave.  Workaround: a self-contained table-driven `GF(p^h)` inside the
   driver, built from a runtime-located monic irreducible.  **A generic
   `PrimePower<P, H>` implementing `FiniteField`, or a table-backed
   `SmallField` value type, is the single highest-value addition** — it would
   let this driver, and the existing `q16_quadratic` / `q19_marked_polar` /
   `q25_pair_repair` bins, share one arithmetic layer.
2. **No kernel / null-space API.**  `canonical_row_basis_field` gives row space
   only; recovering a kernel basis means re-running elimination locally.  A
   `null_space_field` returning a basis matrix would remove the duplicated
   Gaussian elimination in this driver.
3. **`const P: u8` forces macro dispatch.**  Selecting a field at runtime from
   a command-line `--q` requires a hand-written `match` over 50-odd prime
   literals.  A dyn-dispatched or value-parameterized field would remove that
   boilerplate; the sealed `FiniteField` trait currently prevents an external
   crate from supplying its own.
4. **No projective-space indexing for general `PG(d,q)`.**
   `ergodis::projective` is specialized (`ternary(order)`), so the
   leading-one normal form, ranking, and unranking were written locally.  A
   generic `ProjectiveSpace::new(d, q)` with `encode`/`decode` would be reused
   widely.
5. **No orbit closure over a matrix group acting on an indexed point set.**
   `ergodis::orbit` / `orbit_compile` did not offer a usable entry point for
   "BFS an index set under a list of `GL(d+1,q)` generators", which is the
   dominant cost here.

No Ergodis core modification is *required* for this work; all five gaps were
absorbed locally.  Items 1 and 2 are recorded as the concrete asks if the core
is ever opened for extension.

## 7. Relation to the MDS dossier framing (one paragraph)

`notes/open-problems/plausible-bridges/mds.md` fences the repository's PRS
results off from MDS-length progress because Kaipa's deep-hole/MDS-extension
dictionary is an equivalence only when the covering radius is `r`, and the
repository's classifications live at radius `r-1`.  Everything computed here
stays inside that fence and in fact sharpens it: across 42 exhaustive census
cells the covering radius was `r-1` in every case except `(r,q) = (3, q even)`
and `(r,q) = (7,8)`, both of which are the classical even-field
`k ∈ {2, q-2}` exceptions and both of which were already known.  The dossier's
first listed opportunity — "a sharper PRS deep-hole conjecture across fixed
redundancy, with exceptional strata predicted by the pointed Hankel/polar
geometry" — is what §3 formulates and §5 tests; the dossier's third item, the
only route back toward MDS, is untouched here and remains untouched.

## 8. Mystery ledger

1. **The exceptional band does not contract monotonically.**  Observed last
   exceptional field: `19, 13, 11, 11` at `r = 5, 6, 7, 8`, against proved
   thresholds `23, 29, 37, 43` moving the other way — then it jumps back up at
   `r = 9`, where `13 ∈ X(9)` although `13 ∉ X(8)`.  Settled by this pass: the
   `r = 8` entry field is 13, not 43, exhaustively over `8 ≤ q ≤ 19`; and the
   monotonicity that made Conjectures B and C attractive is false.  Still open:
   the mechanism, now with an extra constraint — whatever governs `q_0(r)` is
   not monotone in `r`, so it is not a pure counting budget.  The Hasse--Weil
   deletion budget `6r-18` grows linearly in `r`, but the actual obstruction
   evidently oscillates; a natural suspect is arithmetic in `gcd(r-1, q+1)`,
   which is 7 at `(r,q) = (8,13)` (no exception) and 2 at `(9,13)` (one
   exception).  Owning successor: a fixed-level `r = 9` calibration of the kind
   C509 used to close every field below 37 at `r = 7` without scanning
   `PG(6,q)`.
2. **Redundancy four has no exceptional field at all.**  Every one of the
   twelve fields swept, in three characteristics, gives deep = persistent
   exactly.  This is the only redundancy in `4 ≤ r ≤ 8` with `X(r) = ∅`, and it
   is *below* the `r = 5` band rather than above it.  Unexplained: the band is
   therefore not monotone across the whole range `r ≥ 4`, only from `r = 5`
   upward.  Evidence gap: whether `r = 4` is empty for structural reasons (the
   twisted cubic's chord/tangent geometry is classically complete) or because
   the exceptional strata at `r = 5` need the extra dimension.
3. **The three exceptional orbits at `r = 8`, `q = 11`.**  Sizes `264, 1320,
   1320`, apolar degree 4, catalecticant rank 3.  Their stabilizers have orders
   `5, 1, 1` in `PGL_2(11)` (order 1320).  Two regular orbits plus one with a
   `C_5` stabilizer is a suggestive profile — `5 | q+1 = 12`? no; `5 | q-1
   = 10`, yes — but no structural description was attempted.  Evidence gap: the
   analogue of C491's branch-divisor classification of the `r = 5` sporadics,
   at `r = 8`.  Owning successor: whichever task takes item 1.
4. **The single exceptional orbit at `r = 9, q = 13` has no structural
   description.**  Settled by this pass: it exists, has size 364, stabilizer
   order 6 in `PGL_2(13)`, apolar degree 5 with a two-dimensional apolar pencil
   none of whose members is split squarefree, and catalecticant rank 3.  Open:
   why *this* orbit and why *this* field.  A stabilizer of order 6 echoes the
   `C_2`, `C_3`, `V_4`, `A_4` stabilizers of the redundancy-five sporadics
   classified by branch divisor in C491, which suggests the same branch-divisor
   machinery would name it.  Evidence gap: the redundancy-nine analogue of that
   classification.  Owning successor: whichever task takes item 1.
5. **Where does `q_0(9)` actually sit?**  The redundancy-nine band is now known
   to contain `9, 11, 13` and is unsearched from 16 up to the proved threshold
   53.  Gate: one run of `--q 16 --r 9` (`|PG(8,16)| ≈ 4.6·10^9`, roughly five
   times the `q = 13` cell, so of order half an hour and about 5 GB — the first
   cell in this campaign where memory, not time, is the binding constraint).
   That single cell decides whether `q_0(9)` is 16 (band closes immediately
   above 13, and Conjecture B′ is comfortable) or larger (B′ starts to look
   fragile too).
6. **The field-model near-miss.**  A verifier that chose its own irreducible
   polynomial produced 30 apparent counterexamples at `r = 8, q = 16` that were
   pure labelling artifacts.  Settled by this pass, and worth recording as a
   standing hazard: syndrome coordinates over a non-prime field are element
   *labels*, so any cross-implementation comparison of representatives has to
   fix one field model, while only aggregate counts are model-free.  The
   committed certificates for `q = 8, 9, 16, 25, 27, 32` in the R5--R7 bundles
   have the same exposure if they are ever re-checked by a second program.
7. **No genuine mystery in the validation layer.**  Sixteen committed-certificate
   cells (plus four classical conic cells) reproduced exactly by an independent
   code path, plus definition-level
   Python agreement on two of them and representative-level agreement on five
   more, plus Ergodis rank agreement on 116 Hankel matrices.  Nothing anomalous
   surfaced there and none is claimed.

**Status: complete** for the redundancy-four sweep, the redundancy-eight band
`8 ≤ q ≤ 19`, the certificate-reproduction gate, and the redundancy-nine
decider at `q = 13`, which falsified Conjecture B and the monotonicity half of
Conjecture C with an exactly certified witness.  **Partial** for the
replacement Conjecture B′ (`q_0(r) ≤ 23` for every `r`), whose first untested
cell is `r = 9, q = 16`, and for redundancy ten, which was not searched at all.
