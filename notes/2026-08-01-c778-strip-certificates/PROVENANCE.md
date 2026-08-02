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

| File | Role | Trust |
|---|---|---|
| `strip_simplex.py` | exact Phase-I simplex over `Fraction`, Bland's rule; the decision procedure behind the plateau theorem | load-bearing |
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

## Still missing from the source session

- `strip_exact2.py` and `strip_exact2_lib.py` — the repaired Fourier--Motzkin cross-check.
- `strip_sub.py` and `scan_range.py` — the sweep drivers. Not worth retrieving; C778 writes its own
  so the driver emits our certificate format.
