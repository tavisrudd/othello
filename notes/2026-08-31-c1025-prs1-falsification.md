# C1025 — Testing Conjecture PRS-1 outside its sampled region

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** complete.  The premise behind the proposed accelerator was **false**
and was replaced by two proved reductions; the falsification was then run and
**Conjecture PRS-1 survives** on a domain an order of magnitude larger, with its
`k` hypothesis shown necessary and sharpenable from `k ≥ 6` to `k ≥ 4`.

Predecessors: `notes/2026-08-31-c1024-incidence-threshold.md` (which raised the
sampling-artifact risk and proposed the `(17,7)` test), and
`notes/2026-08-31-c1018-prs-deephole-conjecture.md` §6 (Conjecture PRS-1 and its
verified domain).  Notation is theirs.

## Part 1, step 1 — the premise, settled first

C1024 §6 item 2 recorded the `(17, m=7)` cell at `q = 29` as out of budget and
attributed the fix to a claim of mine: *"the Hankel rank is bounded by `M` by
construction on a stratum, here 3"*.  Gate 2 of this task required proving that
before using it.

**The claim is false, and not marginally — the rank is generically full.**

Sampling stratum points uniformly and computing `rank H^{(j)}_s` for every `j`:

| carrier | `d` | `M` | ranks `j = 1 … d` | max rank | apolar degree `e` |
|---|---:|---:|---|---:|---:|
| `(9, m=3)`, `{1,4,7}`, `q=13`   | 8  | 3 | `2,3,4,5,4,3,2,1` | **5** | 5 |
| `(11, m=4)`, `{1,5,9}`, `q=13`  | 10 | 3 | `2,3,4,5,6,5,4,3,2,1` | **6** | 6 |
| `(17, m=7)`, `{1,8,15}`, `q=29` | 16 | 3 | `2,3,4,5,6,7,8,9,8,7,6,5,4,3,2,1` | **9** | 9 |

In every case the rank is exactly `min(j+1, d-j+1)` — the largest it can be for
a matrix of that shape — and the apolar degree is exactly `⌈(d+1)/2⌉`, the
generic value.  A stratum point is apolar-*generic*; it is special as a point of
`PG(d,q)`, not as a source of rank deficiency.  200, 50 and 30 samples
respectively, identical profile every time.

### What is actually true, and why it does not help

There *is* real structure, just not the structure I claimed.

> **Proposition (block decomposition).**  Let `s` lie on the stratum
> `{ s_i = 0 unless i ≡ a (mod m) }` of `PG(d,q)`, with compressed coefficient
> vector `g` of length `M`.  After permuting rows and columns by residue class
> mod `m`, `H^{(j)}_s` is block diagonal with `m` blocks: block `c` has columns
> `{u ∈ [0,j] : u ≡ c}` and rows `{v ∈ [0,d-j] : v ≡ a-c}`, and its entries are
> the `g` themselves.  Hence
> `rank H^{(j)}_s = Σ_c rank(B_c)` with
> `rank(B_c) ≤ min(|cols_c|, |rows_c|, M)`.

*Proof.*  `H[v][u] = s_{u+v}`, nonzero only when `u+v ≡ a (mod m)`, so `u ≡ c`
forces `v ≡ a-c`: entries vanish off those row/column pairings, giving the block
form.  Within block `c`, `u + v` runs through `I` and the entry is the
corresponding `g`.  Each `B_c` is a submatrix of a Hankel matrix of `g`, whose
rank is at most its length `M`. ∎

> **Corollary (the `M` bound is vacuous).**  On an `a = b = 1` carrier stratum,
> `d = 2 + m(M-1)`, and for every `j` and `c`,
> `min(|cols_c|, |rows_c|) ≤ ⌈min(j+1, d-j+1)/m⌉ ≤ ⌈(d+1)/(2m)⌉ =
> ⌈(M-1)/2 + 3/(2m)⌉ < M` for all `M ≥ 2`, `m ≥ 2`.
> So the constraint `rank(B_c) ≤ M` is **never active**: every block already has
> fewer than `M` rows or columns.

That is the whole story.  The blocks are genuinely there, but they are *too
small* for the `M` bound to constrain anything, so the bound I proposed is not
merely unproved, it is vacuous by a counting argument.  And summing the honest
per-block bound gives

```text
Σ_c min(|cols_c|, |rows_c|)  =  min(j+1, d-j+1) − O(m),
```

because the blocks partition the rows and columns nearly evenly — so the block
decomposition can improve on the generic rank bound by at most `m`, a term
independent of `q` and swamped by everything else.

**Verdict on Part 1: no usable a-priori rank bound exists on a stratum.**  Per
the task's instruction 3, I stop there rather than weakening the claim to fit
the code.  Rank was never the bottleneck in any case — the bottleneck is the
search for a split squarefree element of the kernel, and a full-rank kernel is
the worst case for that search too.

### Method note: the recurring pattern

This is the second time in this thread that a plausible claim of mine needed
checking before use — C1023's Lemma 1 turned out to be essentially Sylvester's
theorem, caught only at the end of that task; this rank bound turned out to be
vacuous, caught before any code was written.  The common failure is asserting a
structural bound from the *shape* of the situation ("the support is sparse, so
the rank must be small") without doing the one computation that tests it.  The
correction that worked both times is mechanical and cheap: before building on a
claim, spend one probe on the smallest instance where it could fail.  Both
catches came from the gate, not from my own re-reading, which is worth noting
about where to place gates in future tasks.

## Part 1, step 2 — a different accelerator, on a proved reduction

The premise failed, so the accelerator had to come from elsewhere.  Two
reductions do the work, both proved rather than assumed.

> **Lemma A (single level).**  If `q + 1 ≥ d - 1` then `w(s) ≤ d-1` iff some
> split squarefree form of degree **exactly** `d-1` annihilates `s`.
>
> *Proof.*  (⇐) immediate.  (⇒) if `w(s) = j₀ ≤ d-1`, take a minimal spanning
> set `T₀ ⊆ PG(1,q)`, `|T₀| = j₀`, and enlarge it to `T ⊇ T₀` with `|T| = d-1`
> using any further points of `PG(1,q)`, available since `|PG(1,q)| = q+1 ≥ d-1`.
> Then `s ∈ span{P_t : t ∈ T₀} ⊆ span{P_t : t ∈ T}`. ∎

Deciding *deep or not* therefore needs **one** level, not all of `j = 1..d-1`.
The 2026-08-30 and 2026-08-31 drivers search every level because they report the
exact rank `w(s)`; for the deep question that is wasted work, and it is what made
the `(17,7)` cell time out.

> **Lemma B (Sylvester fast path).**  If the apolar degree satisfies `e ≤ 2`,
> the verdict costs `O(q)`: with `s^⊥ = (F,H)` and `deg F = e`, `s` is deep iff
> `F` is not split squarefree over `F_q`.

This is C1023 Lemma 1, attributed there to Sylvester via the Apolarity Lemma
with the finite-field refinement the only new part.  It disposes of the entire
persistent locus without search, which matters because the persistent points are
precisely the ones that genuinely *are* deep and would otherwise each cost a
full `C(q+1, d-1)` enumeration.

On top of those, a **randomised witness hunt** at level `d-1`: annihilation is
two linear conditions, so a uniform random `(d-1)`-subset succeeds with
probability about `q^{-2}`.  That phase can only certify *not deep*, and does so
by exhibiting a witness verified directly, so it introduces no hypothesis.
Survivors fall through to the complete `C(q+1,d-1)` enumeration, and the driver
reports how many did, so exactness is auditable.

Driver: `ergodis-private/src/bin/c1025_prs_stratum.rs`.

### Gate 1 — agreement with the exact path

Every cell whose answer is already committed, across both characteristics, both
exponent shapes, and `M = 2, 3, 4`:

| cell | stratum | points | deep | exceptional | committed | agrees |
|---|---|---:|---:|---:|---|:--|
| `(9, m=3, cls 1), q=13`   | `{1,4,7}`    | 183   | 6  | 4  | 6 / 4  | ✓ |
| `(9, m=3, cls 0), q=13`   | `{0,3,6}`    | 183   | 0  | 0  | 0      | ✓ |
| `(11, m=4), q=13`         | `{1,5,9}`    | 183   | 14 | 12 | 14 / 12| ✓ |
| `(8, m=5), q=11`          | `{1,6}`      | 12    | 6  | 4  | 6 / 4  | ✓ |
| `(9, m=3), q=16` (char 2) | `{1,4,7}`    | 273   | 2  | 0  | 2 / 0  | ✓ |
| `(13, m=5), q=16` (char 2)| `{1,6,11}`   | 273   | 2  | 0  | 2 / 0  | ✓ |
| `(15, m=4), q=17`         | `{1,5,9,13}` | 5,220 | 6  | 4  | 6 / 4  | ✓ |
| `(10, m=4, cls 0), q=13`  | `{0,4,8}`    | 183   | 4  | 3  | 3 exc  | ✓ |

Eight of eight.  With Lemma B active the `phase2` counter — points needing the
exhaustive fallback — equals the exceptional count in every row and is **zero**
on every clean cell: the randomised hunt certifies every non-deep point and
Sylvester every persistent one, so the expensive path runs only on genuine
exceptional candidates.

## Part 2 — the cell that was out of budget, and the region beyond it

`(17, m=7)` at `q = 29`, stratum `{1,8,15}`, `k = 13` (a clean cell, not
degenerate):

```text
871 stratum points,  2 deep,  0 exceptional,  0 points needing exhaustive search
wall 22.5 s   →   after Lemma B, 0.14 s
```

Against the 600 s timeout it previously hit.  **The cell is clean**: the two
deep points are the persistent ones the stratum meets, and there is no
exceptional deep hole at `q = 29`.

### The `M = 3` family, exhaustively

`(17,7)` at one field settles little, since the C1024 heuristic allows firing
anywhere below `(r-3)^2/2`.  So every `M = 3` carrier was swept over its **whole
admissible range** — every prime power `q ≤ 127` with `m | q-1`, `q ≥ d`, and
`k = q+1-r ≥ 1`.  `M = 3` means `m = (r-3)/2`, which is the direction along
which the heuristic threshold grows quadratically and is therefore where a
constant threshold is most likely to break.

```text
111 cells.   redundancy r = 9 … 39.   fields q = 13 … 127.
cells with an exceptional deep hole:  2
    r=9,  m=3,  q=13    183 points,  6 deep,  4 exceptional
    r=11, m=4,  q=13    183 points, 14 deep, 12 exceptional
```

Both are already-known cells at `q = 13`.  **Every one of the other 109 cells is
clean**, including every field above 13 at every redundancy up to 39.

This is the direct test C1024 asked for and it comes out **against** the
sampling-artifact worry: the region that was previously unreachable — `m` up to
18, `r` up to 39, `q` up to 127 — behaves exactly as Conjecture PRS-1 predicts.
The heuristic `(r-3)^2/2`, which would have permitted firing at (say) `r = 31`
for every `q` below 392, is not merely unproved but **empirically wrong as a
description of where carriers fire**: nothing fires above 13 anywhere in the
`M = 3` region.

### The larger-`M` direction, and the whole picture

Extending to `M = 4, 5, 6` (the other axis of the sampling bias — larger support,
smaller `m`), with `q` capped per `M` by the stratum size `q^{M-1}`:

```text
190 cells total.   M = 3,4,5,6.   r = 9 … 39.   q = 9 … 127.   m = 2 … 18.
largest stratum swept: 10,172,526 points
cells with an exceptional deep hole: 10
```

All ten, classified against PRS-1's actual hypotheses (`r ≥ 6`, `q ≥ 16`,
`k = q+1-r ≥ 6`):

| `r` | `m` | `q` | `k` | exceptional | status |
|---:|---:|---:|---:|---:|---|
| 9  | 2 | 9  | 1 | 402     | `q < 16` and `k = 1` |
| 9  | 2 | 11 | 3 | 45      | `q < 16` and `k = 3` |
| 11 | 2 | 11 | 1 | 7,097   | `q < 16` and `k = 1` |
| 9  | 3 | 13 | 5 | 4       | `q < 16` (the known `(9,3)` carrier) |
| 11 | 2 | 13 | 3 | 40      | `q < 16` |
| 11 | 4 | 13 | 3 | 12      | `q < 16` (the known `(11,4)` carrier) |
| 12 | 3 | 13 | 2 | 404     | `q < 16`, degenerate |
| 13 | 2 | 13 | 1 | 157,432 | `q < 16`, degenerate |
| 15 | 3 | 16 | 2 | 2,861   | `k = 2`; also the Seroussi–Roth cell where `ρ = r`, so the driver's `w ≥ d` test over-counts — see the caveat below |
| 15 | 4 | 17 | 3 | 4       | **`k = 3`** — the only cell firing above `q = 13` |

> **Inside PRS-1's stated scope — `q ≥ 16` and `k ≥ 6` — there are 171 cells,
> spanning `r = 9 … 39`, `q = 16 … 127`, `m = 2 … 18`, and not one of them
> fires.**

## Verdict on Conjecture PRS-1

**PRS-1 survives, and its verified domain grows by an order of magnitude.**  The
artifact risk C1024 raised is discharged: the constancy of the threshold is not
an accident of which carriers were cheap to sweep, because the carriers that
were *not* cheap — `m` up to 18, `r` up to 39, `q` up to 127 — behave the same
way.

But one hypothesis turns out to be doing real work, and the data now pin it
where they previously could not.

### The `k ≥ 6` clause is necessary, and the true boundary is `k ≥ 4`

C1018 §6 introduced `k ≥ 6` to exclude the near-degenerate boundary and said of
the intermediate range: *"no cell with `3 ≤ k ≤ 5` and `q ≥ 16` is within census
reach … This is the largest structural gap in the statement,"* and *"the true
boundary may well be `k ≥ 3`; the data cannot tell."*

The stratum sweep reaches that gap, because a stratum is small even when the
ambient space is not.  Eight cells with `3 ≤ k ≤ 5` and `q ≥ 16`:

| `r` | `m` | `q` | `k` | exceptional |
|---:|---:|---:|---:|---:|
| 13 | 5 | 16 | 4 | 0 |
| 12 | 3 | 16 | 5 | 0 |
| 13 | 2 | 17 | 5 | 0 |
| 15 | 3 | 19 | 5 | 0 |
| 15 | 6 | 19 | 5 | 0 |
| 21 | 6 | 25 | 5 | 0 |
| 27 | 6 | 31 | 5 | 0 |
| **15** | **4** | **17** | **3** | **4** |

So the data now *can* tell, and they say:

* `k = 3` **fires**, at `(15, m=4)` over `F_17`.  Without the `k` hypothesis
  PRS-1 would be **false**, since `17 > 13`.  The clause is load-bearing, not
  defensive.
* `k = 4` and `k = 5` are **clean** across seven cells.

**Recommended sharpening: replace `k ≥ 6` by `k ≥ 4` in PRS-1.**  That is the
weakest hypothesis consistent with all present evidence, it is now supported by
seven cells rather than by none, and `k = 3` is exhibited as a genuine
counterexample rather than a precaution.  The exact unverified boundary becomes
`k = 3` with `q > 17`, and `k ∈ {4,5}` beyond the seven cells listed.

*Caveat on the `(15,3,16)` row.*  That cell has `q` even and `k = 2`, i.e. the
Seroussi–Roth case where `ρ = r` rather than `r-1` (C1018 §5f found it).  This
driver decides "no split squarefree annihilator of degree `d-1`", which is
`w ≥ d`, and when `ρ = d+1` that includes non-deep points of weight `d`.  Its
2,861 count is therefore an over-count and is not a deep count; it is excluded
from PRS-1 by `k = 2` regardless, and no other cell in the sweep is of that
form.

## Out of budget, recorded rather than inferred

Cells attempted or enumerated but not run, with the cost that stopped them.  No
verdict is inferred for any of them.

| region | why | estimate |
|---|---|---|
| `m = 2`, `M ≥ 7` (i.e. `r ≥ 15`), `q ≥ 17` | stratum is `PG(M-1,q)` with `M-1 ≥ 6` | `(17,2)@27` alone is `27^8 ≈ 2.8·10^{11}` points; the sweep cost is `q^{M-1}` points × `≈ q^2` trials |
| `M = 3`, `q > 127` | phase-1 cost is `q^2` points × `q^2` trials × `O(d^2)` | at `q = 241` about `4·10^{12}` operations, roughly 200–2000 s per cell |
| `M = 4`, `q > 64`; `M = 5`, `q > 32`; `M = 6`, `q > 27` | same `q^{M+1}` scaling | `M=4` at `q=127` is `127^5 ≈ 3.3·10^{10}` |

The `q^{M+1}` scaling is the live limit.  A known fix exists and was not built:
the C1023 σ-elimination replaces the random `(d-1)`-subset by choosing `d-3`
points freely and *solving* a 2×2 linear system for the elementary symmetric
functions of the last two, so a witness is found with probability about one half
per trial instead of `q^{-2}` — a `q^2` speedup on phase 1, which would move the
`M = 3` ceiling from 127 to the driver's `u8` field limit of 251.

## `ej` + `tt` closeout

**`tt` — the interesting question this raises is about `k`, not about `q`.**  The
whole campaign has been organised around a threshold in the *field*: "nothing
above 13".  The `(15,4)@17` cell says the real boundary is at least partly in the
*dimension*: `k = 3` fires at `q = 17` while `k = 4` does not at `q = 16`.  Since
`k = q+1-r`, a hypothesis in `k` is a statement about the diagonal `q ≈ r`, and
the two conditions `q ≥ 16` and `k ≥ 4` may well be shadows of a single
condition on the pair.  Nothing here separates them, and the cells that would —
small `k` at large `q` — are exactly the ones the sweep can reach cheaply.  That
is the sharpest cheap experiment left in this lane.

A second `tt` point: Lemma A (deep is decided at one level) should have been
noticed much earlier.  Every driver in this campaign computes the exact rank
`w(s)` when the question only ever needed a yes/no at level `d-1`.  The cost of
that was a factor of roughly `d` on every stratum sweep in C1018 and C1023, and
it is the single reason `(17,7)` looked out of budget.  Reporting a richer
quantity than the question needs is a quiet and expensive habit.

**`ej` — cheap and in reach.**

1. **Separate `q` from `k`.**  Sweep carriers with `k` small and `q` large —
   e.g. `(r, m)` with `r ≈ q` at `q = 31, 61, 127` — to see whether firing
   tracks `k` or `q`.  Cheap, and it decides whether PRS-1 should be stated in
   one variable or two.
2. **σ-elimination in phase 1**, as above: a `q^2` speedup that lifts every
   ceiling in the out-of-budget table.  Half a day of work, no new mathematics.
3. **Re-run the `(15,4)@17` cell against the exact C1018 path** to be certain the
   one firing cell in the gap is real; it agrees with C1018 §5b″ already, but it
   now carries more weight than any other single cell in the report.

**Surprising and unexplained:** `(13,5)@16` is clean with `k = 4` while
`(15,4)@17` fires with `k = 3`, and the two are otherwise similar — both `M = 3`,
adjacent `m`, adjacent `q`.  Whatever distinguishes them is doing the work that
the `k` hypothesis currently papers over.

## Mystery ledger

1. **Is "Hankel rank `≤ M` on a stratum" true?**  *Settled: no.*  The rank is
   generically full, `min(j+1, d-j+1)`, verified on three carriers; and the
   block decomposition that does hold gives a bound that is provably within `m`
   of the generic one, hence useless.  Nothing open.
2. **Is PRS-1's constant threshold a sampling artifact?**  *Settled: no.*  190
   cells, `r` to 39, `q` to 127, `m` to 18: zero firing inside scope.  Risk flag
   discharged in the C1018 report.
3. **Where is the true `k` boundary?**  *Sharpened, still open.*  `k = 3` fires,
   `k ∈ {4,5}` clean on seven cells, so `k ≥ 4` is the recommended clause.  Open:
   whether `k = 3` fires for `q > 17`, and whether `k ∈ {4,5}` stays clean
   beyond the seven cells.  Owner: `ej` item 1.
4. **Are `q ≥ 16` and `k ≥ 4` two conditions or one?**  *Open, newly raised.*
   See the `tt` note.  This is the most interesting question the task exposed.
5. **Why does `(15,4)@17` fire when `(13,5)@16` does not?**  *Open.*
6. **Method: two false premises in three tasks.**  C1023's Lemma 1 was
   essentially Sylvester's theorem, caught at the end; this rank bound was
   vacuous, caught before any code.  Both were mine, both were plausible from
   the shape of the situation, and neither survived one probe.  The pattern is
   asserting structure from sparsity without testing it.  What worked: the
   coordinator's gate, placed *before* the build rather than after.  No mystery,
   but a standing method note — put the cheap probe first when a claim is load
   bearing, and expect the shape-based intuition to be wrong about half the time.
7. **Nothing anomalous in the validation layer.**  Gate 1 agreed with the
   committed values on eight of eight cells across both characteristics, both
   exponent shapes and `M = 2,3,4`; and on every clean cell the exhaustive
   fallback ran zero times, so the fast path is doing the work it claims.

## Evidence bundle

```text
notes/2026-08-31-c1025-prs1-falsification.md        this report
notes/2026-08-31-c1025-certificate.py               certificate builder / checker
notes/2026-08-31-c1025-certificate.json             190-cell certificate with per-file SHA-256
ergodis-private/src/bin/c1025_prs_stratum.rs        driver
```

Bulk per-cell JSON lives outside the repository under `~/.cache/ergodis/c1025/`;
the committed certificate folds every load-bearing field of every cell together
with the SHA-256 and byte count of the file it came from.

**Build note.**  `ergodis-private`'s library does not currently compile — an
untracked `src/g133_sparse_defect.rs` from a concurrent session — so the driver
was built out of tree from a throwaway manifest at
`~/.cache/ergodis/c1025-build/Cargo.toml` that points at the in-repo source and
depends on the read-only core by path.  Nothing was written into either library
root and the foreign file was not touched.

```bash
# out-of-tree build (the in-tree one will fail while g133_sparse_defect.rs is broken)
cd ~/.cache/ergodis/c1025-build && cargo build --release --bin c1025_prs_stratum

R=~/.cache/ergodis/c1025-build/target/release/c1025_prs_stratum
C=~/.cache/ergodis/c1025 && mkdir -p $C

# the cell that was out of budget
$R --r 17 --q 29 --stratum-mod 7 --stratum-class 1 --threads 20 --out $C/r17-m7-c1-q29.json

# gate 1: agreement with the committed C1018 values
$R --r 9  --q 13 --stratum-mod 3 --stratum-class 1
$R --r 15 --q 17 --stratum-mod 4 --stratum-class 1

# rebuild / re-check the certificate
cd ~/src/othello
python3 notes/2026-08-31-c1025-certificate.py build $C notes/2026-08-31-c1025-certificate.json
python3 notes/2026-08-31-c1025-certificate.py check $C notes/2026-08-31-c1025-certificate.json
```

**Independent cross-check.**  Gate 1's eight cells are checked against values
produced by two structurally different C1018 drivers plus definition-level
Python, none of which share code with this driver.  Beyond that the results are
*self-verifying in the sound direction*: every "not deep" verdict is backed by an
explicit split squarefree annihilator that the driver verifies directly against
the Hankel system, and every "deep" verdict comes either from Sylvester's `O(q)`
test or from the complete `C(q+1,d-1)` enumeration.  The `phase2_points` field
records how many points took the exhaustive route, so the split between fast and
exact paths is auditable per cell.

**What this certifies:** for each listed cell, the exact number of deep and of
exceptional points on the named stratum.  **What it does not:** anything about
orbits with trivial stabilizer, which meet no stratum at all (C1024 §2); and
anything about cells in the out-of-budget table.

