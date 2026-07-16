# C210 — square-root mechanism audit

**Lane**: `relconic`
**Date**: 2026-07-16
**Status**: ACTIVE — first construction audit complete; Baer-transversal design selected

## Boundary from the literature

The ordinary-complete-arc transfer does not already solve C210. Kim--Vu prove the general
`O(sqrt(q) log^c(q))` upper bound, and the later prescribed-symmetry constructions give strong
finite examples rather than an infinite `O(sqrt(q))` theorem:

- Kim--Vu, *Small complete arcs in projective planes*,
  [doi:10.1007/s00493-003-0024-1](https://doi.org/10.1007/s00493-003-0024-1).
- Lisoněk--Marcugini--Pambianco, *Constructions of small complete arcs with prescribed symmetry*,
  [primary PDF](https://cdm.ucalgary.ca/article/download/61979/46677/176938).

The closest coverage-only analogues also retain a logarithm. Saturating sets drop the arc
condition, while almost-complete conic subsets put the selected points on the exceptional conic:

- Nagy, *Saturating sets in projective planes and hypergraph covers*,
  [arXiv:1701.01379](https://arxiv.org/abs/1701.01379).
- Bartoli--Davydov--Marcugini--Pambianco, *On almost complete subsets of a conic...*,
  [arXiv:1609.05657](https://arxiv.org/abs/1609.05657).

An almost-complete subset `S` of a conic `D` cannot be transferred directly to C210. Its uncovered
locus contains `D \ S`. If a projective image were complete outside the prescribed conic `C`, then
`gD \ gS` would lie in `C`. Once more than four points remain, Bézout forces `gD=C`; then
`gS` lies on `C`, contradicting C210's disjointness condition.

Classical square-order complete arcs obtained from Baer geometry are large (for example size
`q-sqrt(q)+1`), not sharp-scale constructions. See Fisher--Hirschfeld--Thas,
[*Complete arcs in planes of square order*](https://doi.org/10.1016/S0304-0208(08)73141-4).

## A family-level Baer obstruction

Let the ambient plane have order `Q=s^2`, let `B` be a Baer subplane of order `s`, and let `A` be a
`k`-arc contained in `B`.

Every point of `PG(2,Q) \ B` lies on a unique extended line of `B`. Each such line has
`Q-s=s^2-s` points outside `B`, and these external fibers partition the complement of `B`.
Because every secant of `A` is an extended `B`-line, exactly `choose(k,2)` fibers are covered and

```text
|U(A) \ B| = (s^2+s+1 - choose(k,2))(s^2-s).
```

An arc in a plane of order `s` has at most `s+2` points. Hence the number of nonsecant `B`-lines is
at least

```text
s^2+s+1 - choose(s+2,2) = (s^2-s)/2.
```

For `s>=3`, this gives

```text
|U(A) \ B| >= (s^2-s)^2/2 > s^2+1.
```

A conic in the ambient plane has only `s^2+1` points. Therefore **no arc contained in a Baer
subplane can be complete outside any ambient conic when `s>=3`**. This upgrades C201's bounded Baer
failure to an infinite-family mechanism obstruction; it is not an obstruction to C210 itself.

## The selected construction reduction

The same Baer partition explains what a viable square-order construction must do. A non-Baer line
meets `B` in one point. Away from that point, it meets exactly once every extended `B`-line not
through that point. Thus a non-Baer secant is transversal: it contributes one covered point to
almost every external fiber.

For an off-Baer arc `A`, fix a `B`-line `ell` and map each pair of selected points whose secant does
not meet `B` on `ell` to the external point where its secant meets `ell`. Relative completeness asks
this pair-intersection map to cover the fiber of `ell`, except possibly the points of the prescribed
conic in that fiber.

The count is sharp. Each fiber has `s^2-s` points, while an arc of size `k~c s` has
`choose(k,2)~c^2 s^2/2` secants. Surjectivity becomes numerically possible exactly at `c>=sqrt(2)`,
the same leading constant as the defect lower bound. Collisions of the pair-intersection map are the
construction-side form of defect.

## Disposition and next gate

- Reject constructions contained in one Baer subplane before any quadratic-rank work.
- Treat finite prescribed-symmetry orbits as seeds only; their published examples do not provide an
  infinite sharp-scale family.
- Pursue a genuinely Baer-transversal, preferably two-layer, arc whose pair-intersection maps become
  finite-field difference maps on every Baer-line fiber.
- Next derive a coordinate formula for those maps and test whether planar functions, relative
  difference sets, or two conjugate graph layers can make them simultaneously near-bijective while
  forbidding collinear triples.

No infinite C210 construction or global obstruction is claimed yet.

## First coordinate gate: two parallel subfield parabolas

Let `E/F` be quadratic with `|F|=s`, and choose nonzero `alpha,beta in E` with
`delta=beta-alpha` outside `F`. In affine coordinates put

```text
A(alpha,beta) = {[1:t:t^2+alpha] : t in F}
              union {[1:t:t^2+beta] : t in F}.
```

This is a `2s`-arc disjoint from the standard conic `XZ=Y^2`. Each layer is a parabola. For two
parameters `t,u` in one layer and `v` in the other, the mixed determinant is, up to sign,

```text
(u-t) ((v-t)(v-u) + delta).
```

The product lies in `F`, while `delta` does not, so it cannot vanish; the repeated-parameter case
reduces to `(u-t)delta`. This proves the arc condition uniformly.

Write an affine point as `[1:y:z]` and `h=z-y^2`. Same-layer chords cover values

```text
h = c - (y-t)(y-u),        c in {alpha,beta}, t != u in F.
```

For a mixed chord from parameters `t` and `t+d`, put `lambda=(y-t)/d`. Then

```text
h = alpha + lambda delta + d^2 lambda(1-lambda),   d in F^*.
```

The `d=0` mixed chords are the vertical lines `y=t`, so they cover every affine point whose
`y`-coordinate lies in `F`. These formulas reduce the remaining coverage question to explicit
quadratic product-image sets over `F`; no projective-plane census is needed.

The structured offset exhaustion gives:

| `s` | ambient `Q=s^2` | seed size | offset pairs | best required uncovered | relative-complete seeds | greedy completion size |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 9 | 6 | 21 | 0 | 9 | 6 |
| 4 | 16 | 8 | 84 | 14 | 0 | 14 |
| 5 | 25 | 10 | 230 | 10 | 0 | 14 |
| 7 | 49 | 14 | 987 | 98 | 0 | 20 |
| 8 | 64 | 16 | 1736 | 330 | 0 | 24 |

Thus the pure two-layer family is closed as a direct construction beyond the `Q=9` exception. It is
nevertheless a much higher-coverage q=64 seed than the C201 families. Deterministically adding the
off-conic uncovered point with maximum new required coverage finishes the displayed seeds at sizes
`6,14,14,20,24`; for `s=5,7,8` this is at most `3s`, and the resulting arcs are ordinarily complete.
This is bounded evidence only, not an `O(s)` theorem.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/probe_c210_two_layer_parabolas.py
```

Frozen output:
`papers/arcs_complete_outside_conic/probe_c210_two_layer_parabolas_output.txt`.

```text
371aeb802996d3c235bbc625bfd27b7c07d8f4eef0af89ea2897ad7977619224  probe_c210_two_layer_parabolas.py
efd531f2d6568837a1e00f485ed80c459b3d7c539f988439920dd0ab7d7e2824  probe_c210_two_layer_parabolas_output.txt
```

The next symbolic gate is now precise: characterize the uncovered product-image complement and
either give at most `s` mutually compatible repair points for every `s`, or prove that a uniform
repair layer cannot preserve the arc condition. Do not enlarge the finite search before that step.
