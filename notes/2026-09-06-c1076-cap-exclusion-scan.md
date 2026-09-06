# C1076: hyperplane-section exclusion scan for complete caps

**Lane**: `relconic`
**Date**: 2026-09-06
**Status**: done; scan replayed deterministically; no paper-facing claim yet (C1075 literature
check pending, C1078 owns any manuscript use).

## Question

The Astra memo (`notes/2026-09-06-astra-cap-hyperplane-memo.md`, Part 2) excludes complete caps of
size 31, 37, 97 in `PG(4,7)`, `PG(4,8)`, `PG(4,16)` by combining the admissible hyperplane sizes
`S_L = {s : 0 ≤ Q(s) ≤ L}` with the moments of hyperplane sections through a fixed secant. Are
these three isolated parameter coincidences or the visible part of a family?

## Result

They are isolated. Over the scanned domain the mechanism gains exactly one above the counting
bound, and only at these parameters in dimension at least four:

| `d` | `q` | counting bound | excluded `k` | test | first surviving `k` |
|----:|----:|---------------:|-------------:|:-----|--------------------:|
| 4   | 7   | 31             | 31           | A    | 32                  |
| 4   | 8   | 37             | 37           | A    | 38                  |
| 4   | 16  | 97             | 97           | A    | 98                  |
| 6   | 8   | 293            | 293          | B    | 294                 |
| 6   | 9   | 387            | 387          | A    | 388                 |

Test A is degree infeasibility of the secant–hyperplane system (memo eq. 10); test B is the
coverage budget `N φ_m(β) > L` with `β` the closed-form lower bound on every `T_ℓ` (memo eqs. 13
and 18). No case in dimension five, and no other `q` in dimensions four and six, is excluded. In
dimension three the scan reproduces a one-step gain for almost every `q`, but that is the arcs
paper's own plane-pencil bound (its `PG(3,q)` corollary), not new.

Two strengthenings were tried and changed nothing: the exact integer optimum of the degree system
with the congruence `Σ b_z C(z,2) ≡ C_0 (mod D)` (memo eq. 12) whenever the admissible set has at
most three sizes, and the concentration ceiling `U_L` (memo eq. 22) together with the trivial
ceiling `(q−1)(m−1)`. Neither excluded a case the closed form had not.

Why the yield is small: the admissible set `S_L` is narrow only when the slack `L` is tiny, and `L`
grows by roughly `k(q−1)` per unit step in `k`. One step above the counting bound `S_L` is already an
interval (for `PG(4,7)`, `k = 32` has `L = 207` and every size `0..12` is admissible), so the
mechanism can never gain more than one. Larger gains need an ingredient that survives an interval of
admissible sizes.

## Scanned domain and stop condition

`d = 3` with `q ≤ 128`; `d = 4` with `q ≤ 64`; `d = 5` with `q ≤ 16`; `d = 6` with `q ≤ 9`; all
prime powers; `k` from the counting bound to twelve above it. The dimension-five and -six limits are
set by the pure-Python dynamic programme over `R = (k−2) θ_{d−3}`, not by any mathematical stop.

## Replay

```
cd ~/src/othello
python3 notes/scripts/c1076_cap_exclusion_scan.py
```

Expected: `rows=1144`, `cases with a gain over the counting bound: 37 of 88`, and the certificate
`notes/2026-09-06-c1076-cap-exclusion-scan.json` with
SHA-256 `059a6fcf0c9a3480823c2dc69870f46d6493468d3d7b3376e3a2059440ebc80a`. The script asserts the
memo's three exclusions before writing. Exact integers and fractions only; no randomness. No
independent replay exists yet beyond the memo's own (unreplayed) verifier for the three
dimension-four cases.

## Evidence boundary

The tests are sufficient conditions derived from the memo's Propositions 1, 2, 4, 5. The memo's
proofs were checked by hand at intake (see the memo's header). Nothing here is Lean-checked. The
gains are relative to the counting bound only; whether any beats a published bound is C1075's
question.

## Mystery ledger

- Dimension five yields nothing for `q ≤ 16` while dimensions four and six each yield twice. Open:
  whether this is parity of `d` (the `θ_{d−4}` term in `C_0` vanishes for `d = 4` only) or small
  numbers. No evidence either way; a Rust port would extend the domain cheaply.
- The `d = 6, q = 8` case is the only higher-dimensional exclusion by the coverage budget rather than
  by degree infeasibility; there the admissible sizes are `{29,30,31,43,44}` with a twelve-wide gap
  around the mean. Whether gap width alone predicts test-B exclusions is untested.
