# Recovered triply-even strip certificate scripts

**Provenance.** Verbatim copies of files retrieved from an external Claude Fable session dated
2026-07-29, collected in `~/tmp/` on 2026-08-01 and copied here unmodified. Their original session
paths were under `/home/claude/`. They are the verification scripts named at the end of
`rigidity_boundary_three_promotions.md`, one of the three notes in
`~/tmp/claude-fable-physics-files.zip`; see
`notes/2026-08-01-external-chat-artifact-gap-review.md` for the catalogue.

Nothing here has yet been run under `notes/research-reproducibility-conventions.md`. These files are
recovered inputs to C778, not an evidence bundle. `SHA256SUMS` records the bytes as received.

## What each file is

`rm_family_check.py` is **not** recovered material: it was written here on 2026-08-01 to test the
corrected staircase family (see below). Everything else in this directory is verbatim external
material.

| File | Role | Trust |
|---|---|---|
| `strip_simplex.py` | exact Phase-I simplex over `Fraction`, Bland's rule; the decision procedure behind the plateau theorem | load-bearing |
| `strip_exact2.py` | exact Fourier--Motzkin with inlined rational Gaussian elimination; the independent cross-check | load-bearing, but carries the unjustified Sidon bound — see below |
| `rm_family_check.py` | locally authored; tests triple-evenness of a Reed--Muller code by the three-level basis criterion | locally replayed, below |
| `sidon_dominance_check.py` | locally authored; compares the justified and used Sidon bounds at every length | locally replayed, below |
| `strip_exact.py` | earlier exact Fourier--Motzkin path | superseded; see the defect below |
| `strip_lp.py` | floating-point Delsarte LP via `scipy.optimize.linprog` | discarded by the source session |
| `strip_search.py` | randomized code growth | source session calls its results structurally vacuous |
| `strip_search2.py` | randomized growth under the basis criterion | same vacuity note |

## Known defect in `strip_exact.py`

Line 39 imposes `sum(A_w) >= n^2/2 - 1`. That bound is stronger than a Sidon set justifies. The
repaired form is in `strip_simplex.py`'s `justified_R`: distinct pairs of distinct nonzero columns
have distinct nonzero sums, giving `2^k >= n(n-1)/2 + 1`, rounded up to a power of two because the
code size is one. `strip_exact.py` also sweeps only multiples of eight (`range(16, 89, 8)`), so it
cannot reproduce the claimed per-length range in any case.

Porting `justified_R` into `strip_exact.py` restores the independent Fourier--Motzkin cross-check
that the source session ran against the simplex path for lengths up to 56. That port is C778 work.

## Local replay, 2026-08-01

`strip_simplex.py` takes a length and a dual-distance floor on the command line. Run from this
directory with no dependencies beyond the standard library:

```
python3 strip_simplex.py <n> <dperp>
```

Results reproduced here, all well inside a five-minute per-length timeout:

| n | dperp | Result |
|---|---|---|
| 16 | 4 | feasible — required, the order-one Reed--Muller code on four variables exists |
| 16 | 5 | infeasible — matches the independent hand proof |
| 32 | 5 | infeasible |
| 40 | 5 | infeasible |
| 69 | 5 | infeasible — claimed upper edge of the first plateau interval |
| 70 | 5 | feasible — claimed start of the open window |
| 74 | 5 | feasible — claimed end of the open window |
| 75 | 5 | infeasible — claimed start of the second plateau interval |

The sanity battery passes and the boundary of the source note's Theorem 1.5 is reproduced at both
ends of the open window. This is a spot check, not the certified sweep: no Farkas dual was extracted
and no manifest was built.

## The independent Fourier--Motzkin cross-check, replayed 2026-08-01

`strip_exact2.py` is self-contained: the promised `strip_exact2_lib.py` does not exist as a separate
file, because this version inlines its own exact Gaussian elimination (`solve_affine`) instead of
calling sympy. Nothing is missing.

Run with `python3 -u strip_exact2.py`. Both sanity points pass, and it agrees with
`strip_simplex.py` at every length it reaches:

    n = 16, 24, 32, 40, 48, 56   ->  INFEASIBLE, exact certificate (agrees with simplex)
    n = 64                       ->  process dies, no output, no traceback

The death at 64 is memory, not mathematics, and reproduces the source session's report exactly. It
is a silent kill rather than the script's own `FM blowup` guard at 40000 constraints, so the
elimination exhausts memory before the guard fires. This is why the exact simplex exists; do not
try to push the Fourier--Motzkin path further without changing the elimination order.

Two exact methods therefore agree across lengths 16--56 in multiples of eight, plus the independent
hand proof at 16. That is the cross-validation the plateau theorem rests on.

## Defect in the source session's dominance claim

The source correction log states that the justified power-of-two Sidon bound dominates the
too-strong `n^2/2 - 1` bound "at every certified length (checked case by case)", which is what makes
any result computed under the wrong bound still sound. **That claim is false.** Checking every
length from 9 to 128 (`dominance` check, 2026-08-01):

    justified(n) = 2^ceil(log2(n(n-1)/2 + 1)) - 1        used(n) = n^2/2 - 1
    justified(n) < used(n)  exactly at  n = 23  and  n = 91.

At n = 23 the justified bound is 255 while the bound used is 263.5, so the imposed constraint was
strictly stronger than a Sidon set justifies, and an infeasibility proved under it would not be a
proof. Length 23 lies inside the claimed certified range 9--69.

**No shipped result is affected**, for two independent reasons, both of which must be stated
explicitly rather than asserted: the certified plateau came from `strip_simplex.py`, which computes
`justified_R` and never used the bad bound; and `strip_exact2.py`, which does carry the bad bound,
sweeps only multiples of eight and so never evaluates 23 or 91. The two exceptions fall in the gap
between the flawed script's domain and the sound script's results.

C778 must restate the dominance lemma with its exceptions named. The corrected form is stronger than
the original because it is checkable: dominance holds at all lengths except 23 and 91, and neither
is load-bearing because the certified sweep used the justified bound directly.

## The zip's staircase family is superseded — do not cite it

The three notes in `~/tmp/claude-fable-physics-files.zip` state the non-rigid staircase family as
`RM(r, 4r)` with uniformity growing like `2n^(1/4)`, and pose the growth question as whether the
exponent is `1/4`. **That is wrong and was corrected later in the same external programme.** The
Ax--McEliece divisibility threshold for triple-evenness of `RM(r, m)` is `ceil(m/r) >= 4`, i.e.
`m >= 3r+1`, not `m >= 4r`. The correct family is `RM(r, 3r+1)`:

    n = 2^(3r+1),  d = 2^(2r+1),  d_perp = 2^(r+1),  U = 2^(r+1) - 1 = 2^(2/3) * n^(1/3) - 1.

So the constructive exponent is `1/3`, not `1/4`, and the first staircase point past length 16 is
length **128**, not 256.

Verified locally on 2026-08-01 with `rm_family_check.py`, which tests the three-level basis criterion
(generator weights mod 8, pairwise products mod 4, triple products mod 2) rather than enumerating
codewords:

| Code | n | triply even | d | d_perp | U |
|---|---|---|---|---|---|
| `RM(1,4)` | 16 | yes | 8 | 4 | 3 |
| `RM(2,7)` | 128 | yes | 32 | 8 | **7** |
| `RM(2,6)` | 64 | **no** (fails at the triple level) | 16 | 8 | — |
| `RM(1,3)` | 8 | **no** (fails at the single level) | 4 | 4 | — |

The two negatives are the boundary cases of `m >= 3r+1` and confirm the threshold is sharp in `m`.

Consequently the open strip is **`[70, 74]` and `[81, 124]`**, not a single window: the certified
plateau covers `[9, 69]` and `[75, 80]`, and the constructive side now starts at 125 rather than 256
(the external programme reports shortening `RM(2,7)` by up to 3 coordinates, with a sharp floor at 4).
The linear program's killing power dies by length 88, so `[81, 124]` is out of reach of the LP and
needs either a stronger relaxation or a construction.

## Still missing from the source session

- `strip_exact2.py` and `strip_exact2_lib.py` — the repaired Fourier--Motzkin cross-check.
- `strip_sub.py` and `scan_range.py` — the sweep drivers. Not worth retrieving; C778 writes its own
  so the driver emits our certificate format.
