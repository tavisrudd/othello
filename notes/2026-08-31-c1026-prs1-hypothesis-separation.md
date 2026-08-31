# C1026 — Do PRS-1's two hypotheses separate?

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** in progress (written incrementally)

Predecessor: `notes/2026-08-31-c1025-prs1-falsification.md`, whose closeout
raised this question, and `notes/2026-08-31-c1018-prs-deephole-conjecture.md` §6
where Conjecture PRS-1 lives.  Notation is theirs.  The driver and its two
proved reductions (single-level, Sylvester) are C1025's and are reused unchanged.

## 0. The logical design, settled before any cell was run

Conjecture PRS-1 as it now stands: for `r ≥ 6`, `q ≥ 16`, and
`k = q+1-r ≥ 4`, the deep holes of `PRS_k(q)` are exactly `P_r ∪ M^max_{r,p}`.

Since `k = q+1-r`, the two clauses are not independent, and only cells where
they disagree carry any information.  Partitioning the carrier cells:

| quadrant | `q ≥ 16` | `k ≥ 4` | what a **firing** cell there would prove |
|---|:--:|:--:|---|
| **A** | yes | yes | PRS-1 is **false** |
| **B** | yes | no  | the `k ≥ 4` clause is **necessary** (`q ≥ 16` alone insufficient) |
| **C** | no  | yes | the `q ≥ 16` clause is **necessary** (`k ≥ 4` alone insufficient) |
| **D** | no  | no  | nothing |

So the separation question is decided entirely by quadrants **B** and **C**, and
a sweep of quadrant A — however large — says nothing about it.  That is the
selection rule used below: cells were chosen for which quadrant they sit in, not
for availability.

**The key observation, made before running anything.**  The scope of PRS-1 is

```text
q ≥ 16   and   k = q+1-r ≥ 4      ⟺      q ≥ 16   and   q ≥ r+3
                                  ⟺      q ≥ max(16, r+3).
```

So the two clauses are **the two branches of a single inequality**, crossing over
at `r = 13`: for `r ≤ 13` the binding constraint is the constant `16`, and for
`r ≥ 13` it is the linear `r+3`.  If both branches turn out to bind — i.e. if
both quadrant B and quadrant C contain a firing cell — then the hypotheses are
each necessary *and* they collapse into one condition.  Those are not
alternatives; both can hold at once, and §3 argues that is exactly what happens.
