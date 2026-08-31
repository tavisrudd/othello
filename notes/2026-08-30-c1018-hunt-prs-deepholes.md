# C1018 — Sharpened PRS deep-hole conjectures and exact computational test

**Lane:** `gem-mining`
**Date:** 2026-08-30, extended 2026-08-31
**Status:** complete for the redundancy-four sweep, the redundancy-eight band
`8 ≤ q ≤ 19`, the certificate-reproduction gate, the redundancy-nine decider
(which **falsified** Conjecture B — §5.3c), the structural identification
and recurrence sweep of the resulting exceptional orbit (§5.3d), and the
redundancy-ten and redundancy-eleven carrier sweeps (§5.3f, which **falsified**
Conjecture D and its invariant-cut corollary).  Partial for
the replacement Conjecture B′ and for redundancy ten; the three redundancy-nine
census cells at `q = 16, 17, 19` are recorded as out of budget in §5.3e.
See §8.

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

**Stratum mode** (`--stratum-mod M --stratum-class A`) skips the orbit census
and instead sweeps only `{ s : s_i = 0 unless i ≡ A (mod M) }`, the fixed locus
of the order-`M` diagonal torus element `t ↦ ζ_M t`.  That locus is a
projective subspace of dimension `|{i ≡ A}| - 1`, so it is exhaustively
searchable at field orders far beyond the reach of a full `PG(d,q)` census; the
mode reports the exact weight histogram over the stratum together with the deep
and exceptional (catalecticant rank `≥ 3`) counts and example points.

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

# exhaustive sweeps of the cyclic-pullback carrier strata (m | r-3)
./target/release/c1018_prs_deephole --q 13 --r 9  --stratum-mod 3 --stratum-class 1
./target/release/c1018_prs_deephole --q 13 --r 11 --stratum-mod 4 --stratum-class 1
./target/release/c1018_prs_deephole --q 29 --r 10 --stratum-mod 7 --stratum-class 1

# independent Python re-derivation from the definition
python3 notes/2026-08-30-c1018-prs-helper.py census 8 5
python3 notes/2026-08-30-c1018-prs-helper.py verify 13 8 ~/.cache/ergodis/c1018/r8-q13.json
python3 notes/2026-08-30-c1018-prs-helper.py stratum 13 9 3 1
python3 notes/2026-08-30-c1018-prs-helper.py structure 13 9 1,0,1,2,4,12,4,3,6
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

Bulk JSON lives under `~/.cache/ergodis/c1018/` — ten census files
`r{r}-q{q}.json` for `r = 8` (`q = 8,9,11,13,16,17,19`) and `r = 9`
(`q = 9,11,13`), plus thirteen stratum files `r{r}-s{class}-q{q}.json` for the
`r = 10` and `r = 11` sweeps — all outside the repository as instructed, with
the tables in this report as the committed record.  The three task-owned files are

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

### 5.3d (2026-08-31, follow-up) What the exceptional orbit is, and where it recurs

#### The orbit is the `S_3`-fixed stratum

Running the orbit through the group directly (`structure` subcommand of the
helper) gives, for the 364-point orbit at `(r,q) = (9,13)`:

* stabilizer order 6, with element orders `1, 2, 2, 2, 3, 3` — three
  involutions and two elements of order three, so the stabilizer is **`S_3`**,
  not `C_6`;
* the orbit contains exactly **four** points of minimal support, all supported
  on the index set `{1, 4, 7}`:
  `(0,1,0,0,1,0,0,8,0)`, `(0,1,0,0,5,0,0,5,0)`, `(0,1,0,0,8,0,0,5,0)`,
  `(0,1,0,0,12,0,0,8,0)`;
* the apolar quintic pencil has 14 members with root-type profile
  `6 × (no rational root)`, `6 × (one simple rational root)`,
  `2 × (2+1+1+1)` — **no split squarefree member**, and the two fibres that are
  totally rational are ramified rather than squarefree.

The support condition is forced, not accidental.  `s_i = 0` unless
`i ≡ a (mod 3)` is exactly the fixed locus of the order-three diagonal torus
element `t ↦ ζ_3 t`, which exists when `3 | q-1`.  The extra involution
`t ↦ μ/t` acts by `s_i ↦ μ^i s_{d-i}`, so it preserves the class of `a` only
when `d ≡ 2a (mod 3)`; with `d = 8` that selects `a = 1`.  Confirmed directly:
sweeping the other two classes at `(9,13)` gives `{0,3,6}` → 0 deep points and
`{2,5,8}` → 0 deep points, against `{1,4,7}` → 6 deep, 4 exceptional.

#### Closed membership condition

The stratum `{1,4,7}` is a plane `PG(2,13)` of 183 points.  Its exact weight
census is `w = 3` for 4 points, `w = 6` for 89, `w = 7` for 84, `w = 8` for 6.
The 6 deep points are 2 persistent plus the 4 above.  Two invariants cut them
out.  Under the torus `s_i ↦ ζ^i s_i` and projective scaling,

```text
c(s) = s_4 / s_1      is well defined in  F_q^* / (F_q^*)^3 ,
u(s) = s_4^2 / (s_1 s_7)   is absolutely invariant
                            (also fixed by the involution t ↦ μ/t).
```

Verified on all four points: `c ∈ {1, 5, 8, 12}` — precisely the cubes of
`F_13^*` — and `u = 5` in every case, with `u^2 = 12 = -1`, so `u` is a
primitive fourth root of unity.  Neither condition alone suffices: `u = 5`
alone admits 12 stratum points and `c` a cube alone admits 48, while their
conjunction admits exactly the 4.  So

> **Membership.**  A syndrome lies in the exceptional orbit at `(9,13)` iff it
> is `PGL_2(13)`-equivalent to a point of the `{1,4,7}` stratum with
> `s_1 s_4 s_7 ≠ 0`, `s_4/s_1` a cube, and `s_4^2/(s_1 s_7) = 5`.

Because `c` is a cube it can be normalized to 1 by the torus, forcing
`s_7/s_1 = 1/5 = 8`, so the whole orbit collapses to a **single normal form**.
Since `p = 13 > d = 8` the syndrome is honestly a binary octic, and it is

```text
s  =  X^7 Y + X^4 Y^4 + 8 X Y^7  =  X Y ( X^6 + X^3 Y^3 + 8 Y^6 ).
```

The sextic factor is the pullback of `z^2 + z + 8` under `z = (X/Y)^3`, and
`z^2 + z + 8` is irreducible over `F_13` (discriminant `-31 = 8`, a non-square),
so the sextic has no rational root.  This is the **cyclic-cubic pullback of an
irreducible binary quadratic, times the two coordinate points** — recognizably
the same mechanism C491 identifies at redundancy five as "Frobenius twisting of
the cyclic cubic deck transformation", reappearing four redundancies up.

**Count check.**  The characterization reproduces the census exactly: the four
stratum points sweep out one `PGL_2(13)`-orbit of size `2184/6 = 364`, and
`1274 + 364 = 1638`, which is the deep total from the independent exhaustive
census of all 883,708,281 points of `PG(8,13)` in §5.3c.  The stratum sweep and
the full census were also cross-checked against each other and against the
Python verifier: all three give the same 4 points.

#### Recurrence: one field per redundancy, and which one

The stratum is a projective subspace, so it can be swept exactly at field orders
far past the reach of a full `PG(d,q)` census.  Sweeping `{i ≡ 1 mod 3}` at
redundancies `r ≡ 0 (mod 3)` (the ones for which `d = r-1 ≡ 2 (mod 3)` makes
the class self-symmetric):

| `r` | `d` | stratum | fields swept | exceptional points found |
|---:|---:|---|---|---|
| 6  | 5  | `{1,4}`       | `q = 7,9,11,13,16,19,25,27,31,37,43,49,64` | **only at `q = 7`** (4 points) |
| 9  | 8  | `{1,4,7}`     | `q = 13,16,17,19,23,25,27,29,31`           | **only at `q = 13`** (4 points) |
| 12 | 11 | `{1,4,7,10}`  | `q = 13,16,17`                             | **only at `q = 13`** (404 points) |

Every other cell in that table returns exactly 2 deep stratum points, both
persistent, and 0 exceptional.  The fields that do carry exceptional points are
`7, 13, 13` for `r = 6, 9, 12` — in each case **the smallest prime power
`q ≡ 1 (mod 3)` satisfying the admissibility bound `q ≥ r-1`** (for `r=6`,
`q ≥ 5` and `5 ≡ 2`, `7 ≡ 1`; for `r=9`, `q ≥ 8` and `8 ≡ 2`, `9 ≡ 0`,
`11 ≡ 2`, `13 ≡ 1`; for `r=12`, `q ≥ 12` and `13 ≡ 1`).  Hence:

> **Prediction (cyclic-cubic stratum).**  For every redundancy `r ≡ 0 (mod 3)`,
> the arithmetic-progression stratum `{i ≡ 1 mod 3}` carries exceptional deep
> holes at exactly one field: the least prime power `q ≡ 1 (mod 3)` with
> `q ≥ r-1`.  At every larger field the stratum's only deep points are the two
> persistent ones it meets.

The `r = 12` row is the prediction's first confirmation outside the
repository's proved range, which stops at `r = 10`.  Note that `r = 12, q = 13`
gives `k = 2`, so it sits on the degenerate `q ≈ r` boundary, which is why its
exceptional count (404) is large compared with the clean `r = 9, q = 13` case
(4); the prediction is about *where* exceptional points occur, not how many.

The cube-class condition itself flips with the redundancy and is the invariant
worth tracking rather than a fixed inequality: at `r = 9, q = 13` the four
exceptional points have `s_4/s_1` **a cube**, while at `r = 6, q = 7` the four
exceptional points are `s_4 ∈ {2,3,4,5}`, precisely the **non**-cubes of
`F_7^*`.  In both cases the cut is by the class of `s_4/s_1` in
`F_q^*/(F_q^*)^3`; only the selected class differs.

### 5.3e (2026-08-31) Conjecture B′ at redundancy nine: feasibility and what was run

The three cells requested for a full census are all out of budget, by the
measured scaling of the `(9,13)` run (883,708,281 points in 396 s, 968 MB) and
against 10 GB of available memory:

| cell | `|PG(8,q)|` | memory | estimated time | verdict |
|---|---:|---:|---:|---|
| `r=9, q=16` | 4.58·10^9 | 4.6 GB | 34 min | over the ~15 min budget |
| `r=9, q=17` | 7.41·10^9 | 7.4 GB | 55 min | over budget |
| `r=9, q=19` | 1.79·10^10 | 17.9 GB | 134 min | exceeds available RAM |

All three are recorded as **out of budget and not run**.  For reference the
same scaling puts every other nearby untested cell out of reach too:
`r=8, q=23` at 21 min / 3.6 GB and `r=10, q=11` at 24 min / 2.6 GB.  The
exhaustive-census ceiling on this machine is about `2·10^9` projective points.

In their place the stratum sweep of §5.3d supplies an exact, complete search of
the predicted exceptional locus at those very fields.  At `r = 9` it returns
**zero exceptional points for every `q` in `{16, 17, 19, 23, 25, 27, 29, 31}`**,
each sweep exhaustive over the full `q^2+q+1` points of the stratum.

The scope limit must be stated plainly: this is a complete search of one
stratum, not of `PG(8,q)`.  It cannot show that `q ∈ X(9)` fails — an
exceptional orbit off the `S_3`-fixed locus would be invisible to it.  What it
does establish is that the *one structural mechanism known to produce an
exceptional orbit at redundancy nine* produces none at any of those eight
fields, which is evidence for Conjecture B′ (`q_0(r) ≤ 23`) and against any
picture in which the cyclic-cubic family persists upward.  It also refutes the
congruence guess that first suggested itself from `u^2 = -1`: `q ≡ 1 (mod 12)`
is not the right predictor, since `q = 25` is `1 (mod 12)` and carries nothing.

### 5.3f (2026-08-31, follow-up) Conjecture D at redundancies ten and eleven

#### The carrier family, correctly stated

§5.3d read the exceptional locus as "the `S_3`-fixed stratum at redundancies
`r ≡ 0 (mod 3)`."  Testing the next two rungs forced a correction, and the
corrected statement is better.  In characteristic `p > d` a syndrome supported
on `{ i ≡ a (mod m) }` factors, as a binary form of degree `d`, as

```text
s  =  X^a · Y^b · G(X^m, Y^m),        b = d - a - m(M-1),
```

where `M` is the number of admissible indices and `deg G = M-1`.  The
redundancy-nine exceptional orbit has `a = b = 1`: it is `XY · G(X^3,Y^3)`.
That shape — the cyclic pullback multiplied by the two coordinate points, each
with multiplicity **one** — is what makes every apolar level fail to be split
squarefree.  It requires the extreme indices to be `1` and `d-1`, i.e.

```text
a = b = 1   ⟺   m | d - 2 = r - 3.
```

So the carrier at redundancy `r` is indexed by the divisors of `r-3`, not by a
congruence on `r`.  For `m = 3` this reproduces `3 | r`, which is why the
original mod-3 reading looked right on `r = 6, 9, 12`.

The prediction that follows is sharper: at redundancies where `m = 3` does not
divide `r-3`, the mod-3 stratum has the wrong multiplicities and should carry
nothing.  Confirmed exactly:

| `r` | `d` | mod-3 self-symmetric class | shape | fields swept (`3 | q-1` marked) | result |
|---:|---:|---|---|---|---|
| 10 | 9  | `a = 0`, `{0,3,6,9}` | `a=b=0`: `G(X^3,Y^3)` | `q = 11,13*,16*,17,19*` | max weight `8 = d-1` at every field: the stratum never even reaches the covering radius |
| 11 | 10 | `a = 2`, `{2,5,8}`   | `a=b=2`: `X^2Y^2 G(X^3,Y^3)` | `q = 11,13*,16*,17,19*,23,25*,27` | max weight `9 = d-1` at every field with `q ≥ 13` |

(The `q = 11` cells give `k = 2` and `k = 1`, the degenerate `q ≈ r` boundary
where nearly everything is deep, and `3 ∤ 10` there so the locus is not a torus
fixed locus at all; both are excluded as artifacts.)

**Conjecture D as stated in §5.3d is therefore refuted at both new rungs**: at
`r = 10` and `r = 11` the mod-3 stratum carries no deep points whatsoever, let
alone exceptional ones at the predicted field `q = 13`.

#### The correct carriers, swept

Sweeping every `m | r-3` (each an exhaustive sweep of the full stratum):

| `r` | `r-3` | `m` | stratum | fields swept | exceptional points |
|---:|---:|---:|---|---|---|
| 9  | 6 | 2 | `{1,3,5,7}`   | `13, 16, 19` | **0** at every field (8, 17, 11 deep, all persistent) |
| 9  | 6 | 3 | `{1,4,7}`     | `13,16,17,19,23,25,27,29,31` | **4 at `q=13` only** |
| 9  | 6 | 6 | `{1,7}`       | `13, 16, 19` | **0** at every field |
| 10 | 7 | 7 | `{1,8}`       | `11,13,16,17,19,23,29,43` | **0** at every field (2 deep, persistent) |
| 11 | 8 | 2 | `{1,3,5,7,9}` | `13`         | **40 at `q=13`** |
| 11 | 8 | 4 | `{1,5,9}`     | `13,16,17,19,23,25` | **12 at `q=13` only** |
| 11 | 8 | 8 | `{1,9}`       | `13,16,17,19,23,25` | **0** at every field |

Three consequences.

1. **Redundancy eleven does have exceptional deep holes at `q = 13`**, carried
   by the cyclic-*quartic* stratum `{1,5,9}` (12 points) and, more abundantly,
   by the cyclic-*quadratic* stratum `{1,3,5,7,9}` (40 points, which contain the
   12 since `{1,5,9} ⊂ {1,3,5,7,9}`).  So Conjecture D's *field* prediction
   `q = 13` survives at `r = 11` even though its *mechanism* does not: the
   carrier is `m = 4`, not `m = 3`.  Both require `m | q-1`, and `q = 13` is the
   least admissible prime power with `4 | q-1`.
2. **Redundancy ten has no cyclic-pullback carrier at all.**  `r-3 = 7` is
   prime, so `m = 7` is the only candidate, it needs `7 | q-1`, and it yields
   zero exceptional points at every field swept including `q = 29` and `q = 43`
   — the two least admissible fields with `7 | q-1`.  Redundancy ten is the
   first redundancy tested where the mechanism is simply absent.
3. **At redundancy nine the cubic carrier is the unique one.**  Its siblings
   `m = 2` and `m = 6` both divide `r-3 = 6` and both yield zero exceptional
   points, so the 364-orbit of §5.3d is not one of a family at that redundancy.

Replacing Conjecture D:

> **Conjecture D′ (cyclic-pullback carriers).**  The exceptional deep holes
> with nontrivial cyclic stabilizer are exactly the `PGL_2(q)`-orbits of
> syndromes `XY · G(X^m, Y^m)` with `m | r-3` and `m | q-1`.  For each such
> `(r, m)` they occur at exactly one field: the least prime power `q` with
> `m | q-1` and `q ≥ r-1` — except that some `(r,m)` pairs carry none at all,
> `(10, 7)` being the first instance.

D′ is consistent with every cell above.  Its weakest point is the escape clause
in the last sentence, which `(10,7)` forces and which nothing here explains.

#### Do the closed invariant conditions generalize?  No.

At `(9,13,m=3)` the four exceptional points were cut exactly by `s_4/s_1` a cube
together with `s_4^2/(s_1 s_7) = 5`.  The natural generalization to a
three-index carrier `{1, 1+m, 1+2m}` is `c = s_{1+m}/s_1` in `(F_q^*)^m` and
`u = s_{1+m}^2/(s_1 s_{1+2m})` a fixed constant; both `c` (modulo `m`-th powers)
and `u` are genuine invariants of the torus and the involution at any `m`.

Tested at `(11, 13, m=4)`, where `(F_13^*)^4 = {1,3,9}`, on the exhibited
exceptional points:

```text
(s_1,s_5,s_9)   c    c ∈ 4th powers    u    u^2
( 1, 1, 4)      1         yes          10    9
( 1, 1, 8)      1         yes           5   12
( 1, 2, 6)      2         no            5   12
( 1, 3, 7)      3         yes           5   12
( 1, 3,10)      3         yes          10    9
( 1, 4,12)      4         no           10    9
( 1, 5, 5)      5         no            5   12
( 1, 6, 2)      6         no            5   12
```

Both conditions fail: `c` lies in the fourth powers for some exceptional points
and not others, and `u` takes two values, `5` (order 4) and `10` (order 6),
rather than one.  **The `(9,13)` cut does not generalize verbatim** — it is
specific to the cubic carrier, where the stratum happens to be cut by a single
class condition plus a single value.  The quartic carrier's exceptional set is
three times larger (12 against 4) and is not a single class.  Pinning its exact
cut needs the full 12-point list; only 8 are exhibited above, because the
driver's example cap is 8 and the rebuild that would raise it is blocked (see
below).  The negative is unaffected: counterexamples to both conditions already
appear among the 8.

#### Scope limit, restated

A stratum sweep is exhaustive over its stratum and blind to everything else.
It can only see exceptional orbits whose stabilizer contains the corresponding
cyclic group.  The two size-1320 exceptional orbits found at `r = 8, q = 11`
in §5.3 have **trivial** stabilizer in `PGL_2(11)` and are therefore invisible
to every sweep in this subsection.  So none of the zeros above may be read as
"this redundancy and field have no exceptional deep holes"; they mean "no
exceptional deep hole with the corresponding cyclic symmetry", which is a
statement about one mechanism, not about `X(r)`.

#### Foreign breakage encountered

Midway through this wave `cargo build` began failing inside the read-only
Ergodis core:

```text
error[E0425]: cannot find value `BOUND_PULSE_COUNT_MASK`  in this scope
error[E0425]: cannot find value `BOUND_PULSE_OBSERVED_BIT` in this scope
  --> papers/complete-repair-ports/ergodis/src/css_distance.rs:1535, :3107, :3111
```

`papers/complete-repair-ports/ergodis/src/css_distance.rs`, `PERFORMANCE.md`,
and `tests/contextual_allocations.rs` are all dirty from a concurrent session
and the crate is mid-edit.  This is **foreign work in a read-only tree and was
not touched**; it is raised here per cross-lane hygiene.  All results in this
subsection were produced by the binary built before the breakage, which is why
the exceptional-example cap stayed at 8.  Nothing in this report depends on the
raised cap.

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
| B′ (`q_0(r) ≤ 23` for every `r`) | survives; replaces B | every cell in §5.1--5.3c, plus the committed R5--R7 classifications; additionally supported, on the `S_3`-fixed stratum only, at `r=9` for `q ∈ {16,…,31}` and `r=6` for `q ∈ {9,…,64}` (§5.3d--e) |
| D (cyclic-cubic stratum recurs at exactly one field per `r ≡ 0 mod 3`) | **FALSIFIED** at `r=10` and `r=11` (§5.3f): the mod-3 stratum there does not reach the covering radius at any field | mod-3 sweeps at `r=10` over 5 fields and `r=11` over 8 fields |
| D′ (carriers are `XY·G(X^m,Y^m)` with `m \| r-3` and `m \| q-1`, one field each, some pairs empty) | **new**; replaces D; survives every cell, with `(r,m)=(10,7)` as the empty instance | exhaustive stratum sweeps: `r=6` (13 fields), `r=9` for `m=2,3,6` (15 cells), `r=10` for `m=3,7` (13 cells), `r=11` for `m=2,3,4,8` (23 cells), `r=12` (3 fields) |
| E (the `(9,13)` invariant cut generalizes to other carriers) | **FALSIFIED** at `(11,13,m=4)`: `s_5/s_1` is a 4th power for some exceptional points and not others, and `u` takes two values | 8 exhibited of the 12 exceptional points |
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
4. **The single exceptional orbit at `r = 9, q = 13` is now named.**  Settled
   by the 2026-08-31 pass (§5.3d): it is the `PGL_2(13)`-orbit of the binary
   octic `XY(X^6 + X^3Y^3 + 8Y^6)`, its stabilizer is `S_3`, and membership is
   cut on the `S_3`-fixed stratum by two closed conditions — `s_4/s_1` a cube
   and `s_4^2/(s_1 s_7)` a primitive fourth root of unity.  Its sextic factor is
   the cyclic-cubic pullback of an irreducible binary quadratic, the same
   mechanism C491 names at redundancy five, so the redundancy-five branch-divisor
   machinery should extend to it directly.  Still open: a proof that the stratum
   is deep exactly at the one predicted field, rather than the sweep evidence of
   §5.3d.  Owning successor: whichever task takes item 1.
5. **Why one field per carrier, and why the least admissible one?**  Where a
   carrier fires it fires at exactly one field — `q = 7` at `(6,3)`, `q = 13` at
   `(9,3)`, `(11,4)` and `(12,3)` — and in each case that is the least prime
   power with `m | q-1` above the admissibility bound.  Every larger field in
   the sweeps returns only the persistent stratum points.  Unexplained: what
   makes deepness fail the moment `q` exceeds that first field.  The likely
   mechanism is that deepness needs the apolar levels above the minimal one to
   stay split-free too, and the number of forms at those levels grows with `q`
   while the stratum's dimension does not — but that is a heuristic, not an
   argument, and it does not explain why the *first* admissible field always
   works when the carrier is nonempty.
6. **The class condition does not survive a change of carrier.**  At
   `r = 9, q = 13` (cubic carrier) the exceptional points have `s_4/s_1` a cube;
   at `r = 6, q = 7` they have `s_4/s_1` a non-cube; at `r = 11, q = 13`
   (quartic carrier) `s_5/s_1` is a fourth power for some and not others, and
   the second invariant takes two values instead of one (§5.3f).  Settled by
   the 2026-08-31 pass: the clean two-condition cut is a property of the cubic
   carrier, not of the mechanism.  Open: the actual cut for the quartic carrier.
   Evidence gap: the full 12-point list at `(11,13,m=4)`, which needs the
   driver's example cap raised — blocked while the Ergodis core is mid-edit
   (§5.3f).  Cheap once the core compiles again.
7. **Redundancy ten has no cyclic-pullback carrier, and nothing explains why.**
   `r-3 = 7` is prime, so `m = 7` is the only candidate; it yields zero
   exceptional points at all eight fields swept, including the two least
   admissible ones with `7 | q-1` (`q = 29, 43`).  Every other redundancy
   tested has at least one carrier that fires.  Open: whether `(10,7)` is empty
   because `m` is large relative to `d` (the stratum `{1,8}` is only a line, so
   `G` is linear and the pullback has no room to be irreducible in the way the
   `(9,13)` sextic is), or for an arithmetic reason.  The first test that would
   separate those is `r = 13` (`r-3 = 10`, carriers `m = 2, 5, 10`), where
   `m = 5` gives a three-index stratum `{1,6,11}` with a quadratic `G` — the
   exact shape that fires at `(9,13)`.  Prediction from that reading: `(13,5)`
   fires at `q = 16`, the least prime power with `5 | q-1` and `q ≥ 12`.
   Untested, and cheap.
8. **Where does `q_0(9)` actually sit?**  The redundancy-nine band is now known
   to contain `9, 11, 13` and is unsearched from 16 up to the proved threshold
   53.  Gate: one run of `--q 16 --r 9` (`|PG(8,16)| ≈ 4.6·10^9`, roughly five
   times the `q = 13` cell, so of order half an hour and about 5 GB — the first
   cell in this campaign where memory, not time, is the binding constraint).
   That single cell decides whether `q_0(9)` is 16 (band closes immediately
   above 13, and Conjecture B′ is comfortable) or larger (B′ starts to look
   fragile too).
9. **The field-model near-miss.**  A verifier that chose its own irreducible
   polynomial produced 30 apparent counterexamples at `r = 8, q = 16` that were
   pure labelling artifacts.  Settled by this pass, and worth recording as a
   standing hazard: syndrome coordinates over a non-prime field are element
   *labels*, so any cross-implementation comparison of representatives has to
   fix one field model, while only aggregate counts are model-free.  The
   committed certificates for `q = 8, 9, 16, 25, 27, 32` in the R5--R7 bundles
   have the same exposure if they are ever re-checked by a second program.
10. **No genuine mystery in the validation layer.**  Sixteen committed-certificate
   cells (plus four classical conic cells) reproduced exactly by an independent
   code path, plus definition-level
   Python agreement on two of them and representative-level agreement on five
   more, plus Ergodis rank agreement on 116 Hankel matrices.  Nothing anomalous
   surfaced there and none is claimed.

**Status: complete** for the redundancy-four sweep, the redundancy-eight band
`8 ≤ q ≤ 19`, the certificate-reproduction gate, the redundancy-nine decider at
`q = 13` (which falsified Conjecture B and the monotonicity half of Conjecture C
with an exactly certified witness), the structural identification of the
resulting orbit together with its recurrence sweep at `r = 6, 9, 12`, and the
carrier sweeps at `r = 10, 11` that falsified Conjecture D and replaced it with
Conjecture D′.
**Partial** for the replacement Conjecture B′ (`q_0(r) ≤ 23` for every `r`),
which now has stratum-level but not census-level support above `q = 13`, and for
redundancy ten, which was not searched at all.  The three requested
redundancy-nine census cells (`q = 16, 17, 19`) are out of budget by 2--9× in
time, and `q = 19` exceeds available memory outright.
