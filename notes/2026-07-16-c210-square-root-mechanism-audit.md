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

## Second coordinate gate: full coset repair layers

A third parabola layer over the original parameter set `F` is impossible: for every `t in F`,
the vertical line `y=t` already contains the two seed points, so a third point gives a collinear
triple. The smallest equally structured alternative is a full additive-coset layer

```text
R(eta,gamma) = {[1:y:y^2+gamma] : y in eta+F},
```

where `eta+F` is a nontrivial additive coset and `gamma != 0`. For the best seed at each tested
order, the probe checks all `(s-1)(s^2-1)` such layers, rejects any layer that breaks the arc
condition, and profiles the survivors:

| `s` | layers tested | arc-legal | relative-complete | best required uncovered |
|---:|---:|---:|---:|---:|
| 3 | 16 | 0 | 0 | -- |
| 4 | 45 | 1 | 0 | 2 |
| 5 | 96 | 2 | 2 | 0 |
| 7 | 288 | 0 | 0 | -- |
| 8 | 441 | 35 | 0 | 42 |

Thus `s=5` has two sporadic complete `3s`-arcs in this ansatz, and `s=4` has a near miss, but the
absence of even an arc-legal layer at `s=7` rules out a uniform theorem using one full translated
parabola layer. This closes the full-layer repair mechanism, not the broader `O(s)` program.

## Third coordinate gate: repair graphs and divided differences

All affine chord calculations have one form. Represent an affine point by its horizontal
coordinate and height above the conic:

```text
P(x,h) = [1:x:x^2+h].
```

For `x != x'`, the chord through `P(x,h)` and `P(x',h')` meets the vertical fiber at `y` at

```text
H(y) = h + (y-x)(h'-h)/(x'-x) - (y-x)(y-x').                 (1)
```

The independent checker exhausts all 52,488 choices of `x != x'`, `h`, `h'`, and `y` over `GF(9)`
against projective line incidence. Formula (1) gives both collision avoidance and coverage.

Fix a nontrivial additive coset `eta+F` and a repair graph

```text
R_g = {P(eta+r,g(r)) : r in T},             T subseteq F.
```

For one repair point `P(y,g)` and two seed points, the forbidden heights are

```text
g = c - (y-t)(y-u)                                      (same seed layer c),
g = alpha + lambda*delta + d^2*lambda*(1-lambda)         (mixed layers),
lambda=(y-t)/d, d=u-t != 0.
```

For two repair parameters `r != s`, their chord collides with the seed point `P(t,c)` exactly when

```text
c = g(r) + (t-eta-r)(g(s)-g(r))/(s-r)
             - (t-eta-r)(t-eta-s).                       (2)
```

For three distinct repair parameters `r,s,u`, their determinant factors as

```text
(s-r)(u-r)(u-s) * (1 + g[r,s,u]),                        (3)
```

where `g[r,s,u]` is the second divided difference. Thus the repair layer is an arc precisely when
`g[r,s,u] != -1` for every triple. Coverage of a target `P(y,h)` says that `h` equals the value in
(1) for at least one seed--repair or repair--repair pair. The projective search has therefore been
reduced to a finite-field interpolation problem.

The first function-class test takes the full coset `T=F` and `g(r)=a*r+b`. Equation (3) is then
automatic because the second divided difference is zero; equation (2) becomes

```text
c = a(t-eta)+b-(t-eta-r)(t-eta-s).                        (4)
```

All `(s-1)s^4` affine graphs were checked at each bounded order. The off-conic column first rejects
graphs with `g(r)=0` for some `r`:

| `s` | affine graphs | off-conic | arc-legal | legal with `a != 0` | relative-complete |
|---:|---:|---:|---:|---:|---:|
| 3 | 162 | 112 | 0 | 0 | 0 |
| 4 | 768 | 585 | 1 | 0 | 0 |
| 5 | 2,500 | 2,016 | 2 | 0 | 2 |
| 7 | 14,406 | 12,384 | 0 | 0 | 0 |
| 8 | 28,672 | 25,137 | 35 | 0 | 0 |

Every legal affine graph has `a=0`, so this class recovers exactly the constant repair layers and
adds nothing at the tested orders. This is bounded evidence, not a uniform nonexistence proof.

## Fourth coordinate gate: quadratic heights

Take the full coset `T=F` and

```text
g(r)=a*r^2+b*r+c,                 A=a+1 != 0.
```

Condition `A!=0` is exactly the internal repair-arc condition from (3). For two repair parameters
`r,s`, put `p=r+s`, `q=rs`, and for a seed parameter `t` put `T=t-eta`. Formula (2) simplifies to

```text
H(t) = -T^2 + T*(A*p+b) + c - A*q.
```

For a seed point of height `c0`, collision is therefore equivalent to

```text
q-T*p = A^(-1)*(-T^2+b*T+c-c0).                         (5)
```

Because `T` is outside `F`, the map `(p,q) -> q-T*p` is an `F`-linear bijection from `F^2` to `E`.
Thus (5) determines one pair `(p,q)` for each seed point, and a collision occurs exactly when
`X^2-pX+q` has two distinct roots in `F`. In odd characteristic this says that
`p^2-4q` is a nonzero square. In characteristic two it says `p!=0` and
`Tr_F/GF(2)(q/p^2)=0`. This is the promised discriminant/trace gate; it replaces all repair-pair
enumeration by `2s` split-polynomial tests per coefficient triple.

The coefficient probe first applies `A!=0`, then conic avoidance, then the one-repair/two-seed
conditions from (1), and finally (5). A direct projective line-count assertion independently checks
every surviving full arc.

| `s` | quadratic graphs | pointwise seed-legal | full arc-legal | nonlinear full arcs | best required uncovered | greedy completion |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 1,458 | 0 | 0 | 0 | -- | -- |
| 4 | 12,288 | 1 | 1 | 0 | 2 | 14 |
| 5 | 62,500 | 2 | 2 | 0 | 0 | 15 |
| 7 | 705,894 | 14 | 0 | 0 | -- | -- |
| 8 | 1,835,008 | 175 | 47 | 12 | 19 | 26 |

At `s=3,4,5` the quadratic class adds nothing beyond constants. At `s=7`, fourteen graphs clear
the pointwise seed-secant gate but every one fails the split-polynomial gate. At `s=8`, twelve
genuinely nonlinear graphs survive; all leave exactly nineteen ordinary (hence required) points
uncovered. The best `3s=24` arc becomes an ordinary complete 26-arc after adding two points at
infinity. The twelve nonlinear survivors form three raw coefficient blocks of four in the frozen
output, giving a small orbit-recognition problem for the next symbolic pass.

This is the first viable nonconstant repair class, but it remains bounded evidence: it supplies no
infinite construction and does not improve the paper's known numerical upper bounds.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/probe_c210_two_layer_parabolas.py
```

Frozen output:
`papers/arcs_complete_outside_conic/probe_c210_two_layer_parabolas_output.txt`.

Repair-graph checker and affine-class probe:

```text
python3 papers/arcs_complete_outside_conic/check_c210_repair_graph_equations.py
python3 papers/arcs_complete_outside_conic/probe_c210_affine_coset_repairs.py
python3 papers/arcs_complete_outside_conic/probe_c210_quadratic_coset_repairs.py
```

Their frozen outputs are the correspondingly named `_output.txt` files in the same directory.

```text
f0bf41b76de2a7f5db495880c5c00288e2c7c27ea6927ff9a0c7433fb5ee861d  probe_c210_two_layer_parabolas.py
92bd59cd1dcdb2dc0d34cf64d97e55571bed6a4ff38fa9300ee049508d9fbd8f  probe_c210_two_layer_parabolas_output.txt
c7523e1dee7073cf4456c81868194ff10ddba5db3e9f796d9302429129b3a8d5  check_c210_repair_graph_equations.py
936763d50ddd5cdddc7aa1289fcb8cd99822efc0a84b066ce1ede6f787669f31  check_c210_repair_graph_equations_output.txt
7c6634f651ad8436fd70b23a6511fd0f20d32926aeb50cd440204dd3695527bd  probe_c210_affine_coset_repairs.py
040d38cac56d61efbd99899c39c23991bdc123b3c09fcb2f845ece4228a32fdc  probe_c210_affine_coset_repairs_output.txt
56f9781d8d6abd0218f2d3fd2bb453fe6d1ee16928b1e5c5bcc7bc4f883c611c  probe_c210_quadratic_coset_repairs.py
02ec5f85c1658a4d21724fc58872b2d94e3d8140a5b423c6b57f2d725b3ea4ce  probe_c210_quadratic_coset_repairs_output.txt
```

The next gate is to normalize the twelve `s=8` nonlinear survivors under parameter translation,
the affine conic stabilizer, seed-layer exchange, and Frobenius. Extract invariant coefficient
relations and rewrite their nineteen-point uncovered locus in trace/norm coordinates. Only then
ask whether the pattern extends to `s=2^m`; a partial domain `T proper subset F` remains available
if the full quadratic layer cannot cover uniformly.
