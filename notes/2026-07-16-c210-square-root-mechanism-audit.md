# C210 — square-root mechanism audit

**Lane**: `relconic`
**Date**: 2026-07-16
**Status**: ACTIVE — seed--cross-repair legality is an explicit resultant-curve gate

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

## Fifth coordinate gate: q=64 orbit recognition and affine completeness

The twelve nonlinear survivors were compared as actual point sets, not coefficient strings. The
checker enumerates all 262,080 elements of `PGL(2,64)` in their symmetric-square action preserving
the standard conic, composes them with all six field automorphisms, and retains the subgroup
preserving the fixed two-layer seed. That semilinear seed stabilizer has order eight and is already
projective: it consists exactly of the subfield translations

```text
[X:Y:Z] -> [X:Y+d*X:Z+d^2*X],             d in F.
```

The twelve repairs split into three inequivalent seed-stabilizer orbits of size four. Within an
orbit, `eta,a,b` are fixed and

```text
c -> c + a*d^2 + b*d,                      d in F.
```

gives exactly the four recorded constants. All three representatives satisfy the compact relations

```text
a*b = 8 = beta^3,             a/b in F^*,
```

in the frozen model with `(alpha,beta)=(1,2)`. Their subfield ratios `a/b` are `14,22,23`, and the
corresponding coset invariants `Tr_E/F(eta)` are `14,24,22`. These are discovery coordinates, not
yet a basis-free existence theorem.

More importantly, every one of the nineteen uncovered points of every survivor lies on the line at
infinity. There are no uncovered affine points. Hence each nonlinear 24-arc is a **complete affine
arc** in `AG(2,64)`. Any two of its missing directions can be adjoined legally: after the first is
adjoined, a secant through it and an affine selected point contains no other point at infinity; the
second new point is therefore still legal. Their mutual secant is the entire line at infinity, so
the resulting 26-arc is ordinarily complete. Both added points avoid the standard conic, whose
point at infinity is `[0:0:1]`.

This changes the construction signal. A characteristic-two family with the same three-layer affine
coverage would give complete arcs of size `3s+2` in `PG(2,s^2)`, already disjoint from the prescribed
standard conic, and would solve C210 on an infinite square-order sequence. The current result proves
this only for `s=8`. A targeted literature search found adjacent work on complete affine,
hyperfocused, and bicovering arcs, but no direct match for this three-subfield-parabola mechanism;
no novelty claim is made without a dedicated source comparison.

## Sixth coordinate gate: trace sets and the minimal coverage route

For `U in E\F`, define the same-layer secant-value set

```text
S_U = {U*p+q : p in F^*, q in F, tr_F/GF(2)(q/p^2)=0}.
```

Indeed, an unordered pair `r!=s` has `p=r+s!=0`, `q=rs`, and the polynomial
`X^2+pX+q` has the two roots `r,s` exactly under the displayed absolute-trace condition. Conversely,
every such split polynomial supplies one unordered pair. Hence `|S_U|=s(s-1)/2`. For a fiber
coordinate `y outside F`, the two same-seed-layer chord sets are exactly

```text
y^2 + alpha + S_y,                 y^2 + beta + S_y.
```

For `y-eta outside F`, the repair--repair values are an affine image of `S_(y-eta)`. The q=64
checker verifies the trace description for all 56 choices of `U outside F`.

The six chord classes are `AA,AB,AR,BB,BR,RR`, where `A,B` denote the two seed layers and `R` the
quadratic repair layer. Exhausting only the 63 subsets of these six classes gives a unique minimal
class cover of the affine plane:

```text
AA, AB, AR, BB, BR.
```

Thus repair--repair secants are unnecessary for affine completeness. Their split-polynomial gate
is needed only to preserve the arc condition. The three cross-layer classes `AB,AR,BR` already
miss only 56 affine points. Adding either `AA` or `BB` reduces this to 14; both same-seed classes
fill the final holes. By contrast, adding `RR` to the cross-layer classes leaves 20 points.

This separates the prospective proof into two independent statements:

1. the discriminant/trace conditions from the fourth gate make the three-layer set an arc;
2. `AB,AR,BR` cover all but a trace-described residue, and the two translates of `S_y` cover that
   residue.

No general coverage theorem is claimed yet, but repair-pair coverage can now be omitted entirely.

## Seventh coordinate gate: the first orbit is sporadic

The first q=64 orbit has a basis-free one-parameter description. Put

```text
tau = Tr_E/F(beta),                 n = N_E/F(beta).
```

For all 56 choices `beta outside F` at `s=8`, the trace-parametrized coefficients

```text
eta=beta, lambda=a/b=tau, b^2=beta^3/tau, a=tau*b, c=b^(-2)
```

give an arc if and only if

```text
tr_F/GF(2)(tau)=0,                 n=tau^5.
```

There are six such `beta`, one absolute-Frobenius orbit; every resulting 24-arc is affine-complete
and extends by two directions to a complete 26-arc. At `s=4` there is no predicted `beta` and no
arc. The quadratic `X^2+tau*X+tau^5` is irreducible over `F` precisely when
`tr_F/GF(2)(tau^3)=1`.

At `s=8`, the three possible `tau` are the roots of `tau^3+tau+1=0`. Writing
`beta=1+tau*omega`, where `omega^2+omega+1=0`, simplifies the repair height to

```text
g(r)=omega*(tau^6*r^2 + tau^5*r + tau^4).
```

This suggests extending the same `GF(8)` coefficients to larger `F` containing `GF(8)`. That
natural extension is obstructed. A collision between one repair point and two points of the
`beta` seed layer exists as soon as there is `z in F^*` with

```text
tr(z)=0,                           tr(z^(-1))=0.          (6)
```

For this family the relevant pair sum is `p=tau^3*z`, with `z=x^2+x`; the split-polynomial
criterion becomes exactly the second condition in (6). If `N_00` counts such `z` and

```text
K_s = sum_{z in F^*} (-1)^(tr(z+z^(-1))),
```

then the character expansion gives

```text
N_00 = (s-3+K_s)/4.
```

The classical Weil bound `|K_s|<=2*sqrt(s)` forces `N_00>0` for every `s>=16`. Thus the direct
`GF(8)` scalar extension of the first orbit cannot produce an infinite family. The bounded checker
records `N_00=1, K_4=3` and the exceptional `N_00=0, K_8=-5`. This obstruction does not yet apply
to the other two q=64 orbits or to partial repair domains.

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
python3 papers/arcs_complete_outside_conic/analyze_c210_q64_quadratic_orbits.py
python3 papers/arcs_complete_outside_conic/analyze_c210_q64_affine_coverage.py
python3 papers/arcs_complete_outside_conic/probe_c210_trace_parameter_family.py
python3 papers/arcs_complete_outside_conic/analyze_c210_remaining_trace_orbits.py
python3 papers/arcs_complete_outside_conic/analyze_c210_partial_domain_deletions.py
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
8414e703504f3f20519c8c1833682e0afea1126474b181c50d5d725121838878  analyze_c210_q64_quadratic_orbits.py
9d8eca6d73ced53bf961d1802b70aaa4e7d6902427558dc351f338f22ce5d019  analyze_c210_q64_quadratic_orbits_output.txt
8c16bd721123534b8138a52aebd78cf00fcd8529c89cf2a8d4f13b6cda1d3520  analyze_c210_q64_affine_coverage.py
1e4d1b0f6c2c0efb40e94acd6491c88978ea47c84360d010a335167d4fa4d4a8  analyze_c210_q64_affine_coverage_output.txt
73727d2ce39719fbe00f80cc5d569827ba023c197a8bfb2f89660d563bb2895c  probe_c210_trace_parameter_family.py
8485fdc566bb6e7175ceaccb6aa8eeec072adbddbe2570ff5476a0a3eee37127  probe_c210_trace_parameter_family_output.txt
3562f174a7dd97527805b96ae3fe102f60f856400dbac3cf59729466c73ccf36  analyze_c210_remaining_trace_orbits.py
3eec58250f1cdd9bea201937750b479b05867ad71c34a3cdca31541c46059f0f  analyze_c210_remaining_trace_orbits_output.txt
cb80d3ef030482580ec3ea79e7675497dc6775c2f3e7f180923f83294be73eda  analyze_c210_partial_domain_deletions.py
5eff4f4a29f451375228257c5e2260d0123f3a748ca14c552e4f8786ad767ba9  analyze_c210_partial_domain_deletions_output.txt
```

## Eighth coordinate gate: all three scalar extensions are obstructed

The other two q=64 orbits admit equally compact coordinates, but they do not escape (6).  Retain
the first orbit's notation

```text
tau^3+tau+1=0,                    omega^2+omega+1=0,
beta=1+tau*omega.
```

Choosing one representative from each translation orbit gives

```text
orbit 1: eta=1+tau*omega,
         g(r)=omega*(tau^6*r^2+tau^5*r+tau^4),

orbit 2: eta=tau^3+tau^5*omega,
         g(r)=tau^2+omega*(tau^5*r^2+tau^6*r+1),

orbit 3: eta=tau+tau^6*omega,
         g(r)=tau^5+omega*(tau^3*r^2+tau*r+tau^4).
```

These identities normalize all twelve q=64 survivors, four per representative under subfield
translation.  For any orbit and either seed height, the one-repair/two-seed equation determines a
quadratic pair sum `p(r)` with two distinct roots `r0,r1` in `GF(8)`.  Put

```text
r=r0+(r0+r1)*x,                  z=x^2+x.
```

Then `p=kappa*z`.  Write the corresponding forced pair product as `q`; after the same substitution,

```text
q/p^2 = N(x)/(x^2*(x+1)^2),      deg(N)<=3.
```

Its partial fractions have double-pole coefficients `N(0),N(1)` and simple-pole coefficients
`N'(0),N'(1)`.  Inside an absolute trace, `A/x^2` may be replaced by `sqrt(A)/x`.  The exact
coefficient calculation gives reduced simple-pole coefficients `(1,1)` in all six orbit/seed
cases.  Consequently every split-polynomial gate is

```text
tr(q/p^2)=tr(1/x+1/(x+1))=tr(1/z).
```

Because `z=x^2+x` runs through the nonzero absolute-trace-zero elements, a collision exists exactly
when

```text
tr(z)=0,                          tr(z^(-1))=0.
```

Thus the three q=64 orbits are exceptional manifestations of one mechanism, not three candidate
infinite mechanisms.  Every admissible direct scalar extension of their `GF(8)` coefficients is
obstructed once the reciprocal-trace count is positive; the Kloosterman calculation above gives
positivity for every `s>=16`.  This closes all full-domain scalar extensions of the three observed
orbits.  It does not obstruct coefficient families that vary with `s`, or partial repair domains.

The next gate is therefore partial-domain rather than another full-field census: quantify how many
repair parameters must be deleted to hit every bad reciprocal-trace pair, then determine whether
the surviving seed--repair secants can still cover the affine plane with `O(s)` total points.  Do
not test a larger field before that coverage/collision tradeoff survives symbolically.

## Ninth coordinate gate: the partial-domain deletion floor

The same normalization makes the mandatory same-seed deletions exact.  For a characteristic-two
subfield `F` put

```text
B_s={x in F\{0,1}: tr(1/(x^2+x))=0}.
```

For each orbit, normalize the repair parameter using the two roots of the `A`-seed pair-sum
polynomial.  The corresponding `B`-seed normalization differs by a fixed translation:

```text
orbit 1: delta=tau,               orbit 2: delta=tau^6,
orbit 3: delta=tau^5.
```

All three shifts are nonzero and different from one.  A partial repair domain avoiding both
same-seed collision classes must therefore delete exactly

```text
D_delta=|B_s union (B_s+delta)|
```

parameters before the mixed-seed and two-repair/one-seed gates are even considered.  The earlier
Kloosterman count gives

```text
|B_s|=(s-3+K_s)/2=s/2+O(sqrt(s)).
```

Writing `chi(u)=(-1)^tr(u)` and `f(x)=1/(x^2+x)`, the overlap has the exact character-sum expression

```text
|B_s intersect (B_s+delta)|
  = 1/4 * sum_{x notin {0,1,delta,delta+1}}
      (1+chi(f(x)))*(1+chi(f(x+delta))).
```

For fixed `delta` in `GF(8)\{0,1}`, the three nonconstant terms are fixed-genus Artin--Schreier
character sums.  Their poles remain distinct, so the Weil bounds give

```text
|B_s intersect (B_s+delta)|=s/4+O(sqrt(s)),
D_delta=3s/4+O(sqrt(s)).
```

Thus only `s/4+O(sqrt(s))` repair parameters survive this necessary vertex-deletion gate.  This is
still linear in `s`, so it does not by itself obstruct an `O(s)` construction.  Nor do the deleted
repair points automatically become coverage holes: each was deleted precisely because it already
lies on a same-seed secant.  The result is a sharp route separator instead.  Any partial-domain
construction based on these coefficients must establish all three remaining facts on a domain of
asymptotic density at most one quarter:

1. no repair point lies on a mixed `A`--`B` secant;
2. the domain is independent in both two-repair/one-seed collision graphs;
3. the surviving seed--repair secants retain full affine coverage.

The next symbolic gate is the first item: eliminate the mixed-seed chord equations for the three
normal forms and determine whether they impose another positive-density deletion.  Coverage work
should wait until a linear-size domain survives all arc-legality gates.

## Tenth coordinate gate: mixed-seed collisions form a regular quintic cover

The mixed `A`--`B` chord variables can also be eliminated without an extension-field census. Work
over a characteristic-two field `F` containing the frozen `GF(8)` coefficients and retain

```text
omega^2+omega+1=0,               beta=1+tau*omega,
eta=e0+e1*omega,                 g(r)=g0+omega*(a1*r^2+b1*r+c1).
```

Put `h(r)=a1*r^2+b1*r+c1+e1^2`. If the seed parameters are `t,t+d`, where
`d!=0`, the `omega` coordinate of the chord equation determines `t` uniquely. Substitution into
its `F` coordinate shows that the repair point at `r` lies on a mixed-seed chord exactly when
`M(r,d)=0` for some `d in F^*`, where

```text
M(r,d) = e1^2*d^5 + e1*tau*d^4 + (h(r)^2+tau*h(r))*d^3
         + e1*tau^2*d^2 + (g0+1)*tau^2*d + tau^3*e1.       (7)
```

The deterministic checker derives (7) for all three orbit normal forms and compares it with the
original chord formula for every `(r,d)` over `GF(8)`. There are no roots, as required by the known
full `q=64` arcs.

Equation (7) also exposes the correct asymptotic object. As a polynomial in `r`, after division by
`d^3`, it is a separable additive quartic plus a constant: its linear coefficient is
`tau*b1!=0`. Its rational right side has an exact pole of order three at `d=0`, because
`tau^3*e1!=0`. Over the algebraic closure, every nontrivial index-two quotient of the additive
quartic is an Artin--Schreier equation. A rational Artin--Schreier coboundary has even pole order,
so the order-three pole makes every quotient nontrivial. The mixed-collision curve is therefore
geometrically irreducible. Equivalently, projection to the `r`-line gives a regular, generically
separable degree-five cover whose rational fibers are exactly the forbidden mixed parameters.

This is a genuine elimination, but not yet a linear-survivor theorem. Geometric irreducibility
rules out a component-level forced collision; it does not by itself exclude exceptional Frobenius
cosets in which every rational fiber has a point. More importantly, even a positive-density set
of rootless quintics need not meet the density-one-quarter complement of
`B_s union (B_s+delta)` in positive density. The next gate is therefore the arithmetic monodromy
of (7) together with the two Artin--Schreier trace covers. A derangement class in the required
Frobenius coset of that compositum would certify a linear-size domain surviving all one-repair
collision gates. Until then, the two-repair/one-seed graphs and affine coverage remain deferred.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_mixed_seed_collisions.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_mixed_seed_collisions_output.txt`.

```text
fb2f08f232919ae10490ec7b056df8e73e21d1629696be3a9ce7999e7c945811  analyze_c210_mixed_seed_collisions.py
a0007cbcfc1363c7782406a47f0ae4655bcc1ffec7ceed33d369132844ac2084  analyze_c210_mixed_seed_collisions_output.txt
```

## Eleventh coordinate gate: a linear domain survives all one-repair collisions

The degree-five cover in (7) has full monodromy, and its interaction with the two same-seed trace
conditions is independent. Differentiate (7) with respect to `d`. Simultaneous vanishing of `M`
and `M_d` forces

```text
d^4+tau*d^2+tau^2=0,
```

so, over the algebraic closure, `d^2` is one of `tau*omega,tau*omega^2`. For either value the
critical equation in `r` is one fiber of the separable additive quartic `h(r)^2+tau*h(r)`, hence
has four distinct roots. The two fibers are disjoint because their right sides differ by

```text
tau*(e1^2+g0+1),
```

which is nonzero in all three orbit normal forms. Thus there are eight distinct branch values.
At each critical point the second Hasse derivative in `d` is nonzero, so the local ramification
index is exactly two and the inertia permutation on the five sheets is a transposition. The cover
is already geometrically irreducible by the tenth gate. A transitive degree-five subgroup of `S5`
containing a transposition is `S5`; therefore both geometric and arithmetic monodromy are `S5`.

The two same-seed conditions are independent Artin--Schreier characters. Each has two simple poles,
and the two pole pairs are disjoint because `delta` is neither zero nor one. All four poles lie in
`GF(8)`. By contrast, every mixed branch value lies outside `GF(8)`: its additive-quartic value has
nonzero `omega` coordinate. The unique possible quadratic intersection with an `S5` Galois closure
is its sign subcover, which ramifies at the transposition branch values. None of the three
nontrivial combinations of the same-seed characters has that ramification support. Consequently
the joint geometric and arithmetic group is

```text
S5 x C2 x C2.
```

A repair parameter clears the mixed-seed gate precisely when its `S5` Frobenius is a derangement;
`S5` has 44 derangements. It clears each same-seed gate precisely when the corresponding
Artin--Schreier Frobenius is nontrivial. Function-field Chebotarev therefore gives, for
`F=GF(8^m)` with odd `m`,

```text
|T_one-repair| = (44/(120*4))*s + O(sqrt(s))
               = 11s/120 + O(sqrt(s)).                    (8)
```

The restriction to odd `m` keeps `omega^2+omega+1` irreducible over `F`, so
`E=F(omega)` is the required quadratic ambient extension. Equation (8) is the first infinite-family
positive-density result for the partial repair route: a linear-size domain survives every
collision involving exactly one repair point. It does not yet make that whole domain an arc,
because two-repair/one-seed chords can join two surviving vertices. The next gate is to derive the
two seed-colored collision graphs on `T_one-repair` and prove that their union has a linear-size
independent set. Affine coverage remains deferred.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_one_repair_monodromy.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_one_repair_monodromy_output.txt`.

```text
63b04512757e78bd21200ce28d2ee062579573ab7b4495992a85db38404f05af  analyze_c210_one_repair_monodromy.py
0d25ebcc184156dbfbc277ea9a5ad9a404e9dc656e39edb86732bb4134ba0b36  analyze_c210_one_repair_monodromy_output.txt
```

## Twelfth coordinate gate: the two-repair graphs have bounded degree

It remains to prevent a chord through two retained repair points from passing through one seed
point. Fix a repair parameter `r`, let `s` be the other repair parameter, and let `t` be the seed
parameter. In the `GF(8)+GF(8)*omega` coordinates used above, put

```text
p=r+s,                            q=r*s,
x=t+eta0,                         eta=eta0+e1*omega,
a=a1*omega,                       b=b1*omega,
c=c0+c1*omega.
```

For seed omega-coordinate `seed1` (zero for `A`, `tau` for `B`), the collision equation splits as

```text
x^2+e1^2+x*p+e1*(a1*p+b1)+c0+q+1 = 0,                  (9)
e1^2+x*(a1*p+b1)+e1*p+e1*(a1*p+b1)
    +c1+a1*q+seed1 = 0.                                (10)
```

For fixed `r,x`, both equations are linear in `s`. Their `s` coefficients cannot vanish together.
Indeed, vanishing of the coefficient in (9) forces `x=r+e1*a1`; substitution into the coefficient
in (10) gives

```text
e1*(a1^2+a1+1) != 0.
```

The inequality is uniform: `e1!=0`, while `X^2+X+1` has no root in `GF(8)` because `GF(8)` has no
`GF(4)` subfield. Cross-multiplying the two `s`-linear equations therefore gives the exact
compatibility condition in `x`. It is a cubic with leading coefficient `a1!=0`. Hence for fixed
`r` there are at most three possible neighbors `s` in either seed-colored collision graph.

The union of the two graphs has maximum degree at most six. Apply the greedy bound
`alpha(G)>=|V(G)|/(Delta+1)` to the one-repair domain from (8), after discarding the at most two
roots of `g(r)` that would put a repair point on the conic. This gives an independent repair domain
`T_arc` with

```text
|T_arc| >= 11s/840 - O(sqrt(s)).                         (11)
```

The quadratic height has constant second divided difference `a`, and `a+1!=0` in all three
normal forms, so every subset of the repair graph is internally an arc. Combining (8)--(11), the
two `s`-point seed layers with `T_arc` form a conic-disjoint arc of linear size along every
`s=8^m`, odd `m`. Thus **all arc-legality gates for the partial-domain mechanism are now closed**.
The remaining C210 question for this mechanism is affine coverage: determine whether seed--repair
secants from a domain of density at least `11/840+o(1)` can cover all affine points not already
covered by the two seed layers. Repair--repair secants remain unnecessary for the selected q=64
coverage route, but the drastic domain thinning makes a new symbolic coverage count essential.

The checker independently compares (9)--(10) with the original extension-field equation for all
2,688 ordered `(orbit,seed,r,s,t)` tuples over `GF(8)` and records the uniform nondegeneracy
coefficients.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_two_repair_graphs.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_two_repair_graphs_output.txt`.

```text
4a79b9cd4ddaf2e6d555bff0c6af000d3af2edd42fdeda85e477d2a5a2c342f7  analyze_c210_two_repair_graphs.py
973ba28352f18a06e536f1a89577508079485a2938b915e1ce303ebbff2810ae  analyze_c210_two_repair_graphs_output.txt
```

## Thirteenth coordinate gate: coverage does not inherit under naive thinning

Arc legality survives a positive-density thinning, but the known affine-coverage certificate does
not. For a target `P(y,h)`, a repair point `P(x,g)`, and a seed point `P(t,c_seed)`, the exact
height-coordinate collinearity equation is

```text
(t+x)*((y+x)^2+h+g) + (y+x)*((t+x)^2+c_seed+g) = 0.       (12)
```

Here `x=eta+r`, `g=g(r)`, and `r,t in F`. Splitting (12) in the
`F+F*omega` basis gives two equations of total degree at most three in `(r,t)`. Thus affine
coverage by a partial repair domain is a bounded-rank candidate-hypergraph problem, not a direct
consequence of the positive density in (11). Generic targets have at most nine `(r,t)` solutions by
Bézout; targets for which the two coordinate equations share a component require separate
classification.

The exact q=64 audit makes the obstruction concrete without widening the order census. With the
two seed layers frozen, they cover 3,808 of the 4,096 affine points. For each of the remaining 288
targets, record the set of repair parameters whose `AR` or `BR` secants contain it. The candidate
set-size distribution is

```text
size       1    2    3    4    5
targets   80   80   72   48    8.
```

Every one of the eight repair parameters is the unique candidate for at least eight targets.
Exhausting all 256 repair subsets confirms that only the full repair layer covers the affine plane;
the best proper subset still misses eight affine points. This explains why the q=64 complete arc
cannot simply be thinned according to (11). It does **not** obstruct asymptotic partial domains:
outside q=64 the collision graph supplies alternative parameters for omitted repair points, and
the candidate hyperedges themselves change with the extension field.

The next gate is now precise. Classify the common-component cases of the two coordinate equations
from (12), then determine the forced singleton and small candidate hyperedges over
`F=GF(8^m)`. The partial-domain route survives only if their hitting constraints admit an
independent transversal in the degree-six collision graph. No affine-completeness claim is made
before that hypergraph compatibility is proved.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_thinned_coverage.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_thinned_coverage_output.txt`.

```text
7ad1d0820688d2c81e089b8f5a5c84d839daebbd97aa13ab89d59eb30ee815e2  analyze_c210_thinned_coverage.py
8893b06709383647ab990e47bd640e23fc34721bc977e2946650871638648452  analyze_c210_thinned_coverage_output.txt
```

## Fourteenth coordinate gate: the coverage cubics have no hidden components

The common-component exception in the preceding Bezout bound is now classified uniformly. Write

```text
eta=e0+e1*omega,        y=Y0+Y1*omega,        h=H0+H1*omega,
g(r)=c0+omega*(a1*r^2+b1*r+c1),               omega^2+omega+1=0.
```

For all three orbit normal forms, `e1*a1*(a1^2+a1+1) != 0`. After expanding (12), the two
coordinate cubics have leading forms

```text
r*t*(r+t),              a1*r^2*t.                            (13)
```

Consequently a common component has degree at most two and leading form `r`, `t`, or `r*t`.
The linear cases have a direct geometric classification. A vertical factor `r+rho` occurs exactly
when `(y,h)` is the repair point `R(rho)`: the `t^2` coefficients first force
`rho=Y0+e0` and `Y1=e1`, and the `t` coefficients then force `h=g(rho)`. A horizontal factor
`t+theta` occurs exactly when `(y,h)` is the seed point `S(theta)`: comparing the `r^2`
coefficients gives `Y1*(a1^2+a1+1)=0`, hence `Y1=0` and `theta=Y0`, after which the `r`
coefficients give `h=c_seed`.

There is no quadratic common component. If

```text
Q=r*t+u*r+v*t+w
```

divides both cubics, their leading forms force quotients with leading parts `r+t` and `a1*r`.
The first quotient gives `u=Y0+a1*Y1`; the second gives
`a1*u=a1*(Y0+Y1)+Y1`. Thus `Y1*(a1^2+a1+1)=0`, so `Y1=0`. But the `t^2` coefficient of the
second cubic simultaneously forces `Y1=e1`, a contradiction.

It follows that every non-seed, non-repair affine target has at most nine candidates from each
seed color. A repair target has the more useful exact hyperedge

```text
{r} union N_A(r) union N_B(r),                              (14)
```

where the two neighborhoods are the seed-colored two-repair collision graphs from the twelfth
gate. Parameters outside the one-repair survivor set either already put `R(r)` on a seed secant or
on the prescribed conic, so their targets require no repair. On the survivor set, every maximal
independent set in the induced union collision graph hits every remaining hyperedge (14). At q=64
that graph is empty, so (14) specializes to the forced singleton `{r}`, explaining part of the
eighty singleton targets in the thirteenth gate.

The remaining obstruction is now confined to the generic finite hyperedges of size at most
eighteen after combining both seed colors. The next gate is to decide whether all such hyperedges
can be hit by an independent subset of the positive-density one-repair survivor set. No generic
hitting theorem, and therefore no affine-completeness theorem, is claimed yet.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/classify_c210_coverage_components.py
```

Frozen output:
`papers/arcs_complete_outside_conic/classify_c210_coverage_components_output.txt`.

```text
a31d24066f5aea18acbc248fc1fe9b9e7698c8f5100f3948ac95e04b1dd9119b  classify_c210_coverage_components.py
03c88466b485f7b0e81dd7dd3571ead430666684bcef702ef98efecbb8d12e72  classify_c210_coverage_components_output.txt
```

## Fifteenth coordinate gate: singleton persistence forces `105 | m`

The q=64 singleton targets are not merely bounded-field noise. For each non-repair singleton, the
two seed-color incidence schemes are zero-dimensional by the fourteenth gate. Factoring their
degree-seven elimination resultants over `GF(8)` and then computing the seed-parameter residue
degree gives the exact extension degrees at which new candidates appear.

Among the seventy-two non-repair q=64 singleton targets, the sets of extra odd closed-point degrees
have distribution

```text
extra odd degrees     {3}   {5}   {7}   {3,5}   {3,7}
targets                28    16    16       8       4
```

Even residue degrees never enter `GF(8^m)` for odd `m`. More strongly, for every one of the eight
repair parameters `r in GF(8)`, there is a singleton target of each pure type `{3}`, `{5}`, and
`{7}`. Therefore:

```text
if 3 does not divide m, a type-{3} target forces every r;
if 5 does not divide m, a type-{5} target forces every r;
if 7 does not divide m, a type-{7} target forces every r.                 (15)
```

Thus affine coverage forces the entire `GF(8)` repair layer in every odd extension except possibly
when `105 | m`. For `m>1`, that full layer is not arc-legal: the seventh and eighth gates produce a
one-repair/two-seed collision for every `s=8^m>=16`. Consequently the partial-domain scalar
extension mechanism is impossible for every odd `m` not divisible by `105`.

This is a strong infinite-family obstruction, not yet a closure of the mechanism. The sub-tower
`m=105*k`, `k` odd, is still infinite, and in it all three extra odd residue degrees occur. The next
gate is purely finite-algebraic: over the degree-`3`, `5`, and `7` residue fields, determine the
candidate hyperedges supplied by these persistent-target schemes and test their compatibility with
the collision graph. No `GF(8^105)` plane census is needed or permitted.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_persistent_singletons.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_persistent_singletons_output.txt`.

```text
dcbf939c5eb43ded6efc660cf50137d84fcb54e12db5f15ff315904f2c6a749a  analyze_c210_persistent_singletons.py
0131458b895aada1c115ddf1cb573e9056c2a693bfd626ba94d912a5ab81b8f9  analyze_c210_persistent_singletons_output.txt
```

## Sixteenth coordinate gate: the degree-105 residue hypergraph is empty

The remaining `105 | m` subtower does not rescue any of the three frozen q=64 orbit coefficients.
For each orbit, each of the
seventy-two persistent q=64 targets has a degree-seven seed--repair elimination resultant over
`GF(8)`. In an odd extension, only closed points of odd degree can become rational. Hence all
possible candidates have degrees `1`, `3`, `5`, or `7`; every such degree already divides `105`.
No new candidate for one of these targets can first appear farther up the odd subtower.

The exact residue-field checker runs independently on all three orbit representatives, realizes
every irreducible factor in `GF(8^d)`, includes all of its
Frobenius-conjugate repair parameters, and then applies every collision gate involving one repair
point. For a degree-`d` candidate, the two same-seed tests retain their absolute-trace form because
`105/d` is odd. For the mixed-seed gate, the checker specializes the quintic `M(r,D)` from (7) and
tests whether it has a root in `GF(8^105)`. Since its degree is five, only relative factor degrees
`1`, `3`, and `5` can enter this odd extension. The q=64 full-arc legality of all eight base repair
parameters is rechecked first as a sanity gate.

For each orbit, the accepted resultant factors and candidate vertices have the identical profile

```text
degree                         1    3    5    7
factor occurrences           72   52   24   20
distinct candidate vertices   8  132  120  140
one-repair-legal vertices      0    0   20    0
```

After the one-repair deletions, sixty-eight of the seventy-two coverage hyperedges are empty. One
compact witness uses `tau^3+tau+1=0` and target coordinates

```text
(y0,y1,h0,h1)=(1,tau^5,tau^2,1).
```

Its complete odd-degree candidate set consists of the base root of `X+tau^2` and the seven roots
of

```text
X^7 + tau^2 X^6 + tau^2 X^5 + tau^6 X^4
    + tau^3 X^2 + tau^4 X + tau^5.
```

The base candidate lies on a mixed seed chord in `GF(8^105)`. Every degree-seven candidate lies
on both a `B`--`B` seed chord and a mixed seed chord. Thus this target has no arc-legal repair
candidate. The obstruction persists in every `GF(8^(105k))`, `k` odd: the target cannot acquire
new odd-degree candidates, while each exhibited collision remains present after extension.
Consequently the partial-domain scalar extensions of the frozen q=64 quadratic repair orbits are
closed for every odd `m`, including the last `105 | m` frontier. No two-repair collision-graph
test is needed. The other two orbit representatives have independent empty-target certificates of
degrees three and five, respectively, and reproduce the same `400`-candidate, `20`-survivor,
`68`-empty-edge profile.

This closes the observed fixed-coefficient mechanism, not C210. Coefficients varying with the
field order, nonquadratic repair graphs, and other Baer-transversal designs remain possible. The
next symbolic gate is to put the quadratic coefficients themselves into the coverage resultants
and determine whether an empty-target certificate persists generically or only on the three q=64
specializations; do not replace that coefficient-space test by a larger plane census.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_residue_hypergraph.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_residue_hypergraph_output.txt`.

```text
7ccddae1628c1bdbd7683a3067d5d1b5fcc813217581c00c561b279fc4366de6  analyze_c210_residue_hypergraph.py
75381617ba722d618a74e2cef9e2c29e255e180317c0b4e15cac5bb6c3966365  analyze_c210_residue_hypergraph_output.txt
```

## Seventeenth coordinate gate: the generic coverage resultant does not collapse

The coefficient-space calculation retains

```text
eta=e0+e1*omega,                 g(r)=c0+omega*(a1*r^2+b1*r+c1),
target=(y0+y1*omega,h0+h1*omega),
seed height=z0+z1*omega,
```

and computes the seed--repair Sylvester resultant in `r` over the twelve-variable polynomial ring
in characteristic two. Its coefficient support from degree zero through seven has sizes

```text
472, 268, 276, 92, 94, 31, 16, 3.
```

The leading coefficient factors exactly as

```text
[r^7] Res = a1*y1*(a1^2+a1+1).                           (16)
```

The repair-arc condition already requires `a1!=0`. Along `F=GF(8^m)`, `m` odd, the field has no
`GF(4)` subfield, so `a1^2+a1+1` cannot vanish. Thus every target with `y1!=0` gives an exact
degree-seven coverage cover, uniformly in the remaining repair coefficients.

On the divisor `y1=0`, the degree-six coefficient is

```text
[r^6] Res = a1*(a1*(h0+z0)+h1+z1).                       (17)
```

The two seed colors have `(z0,z1)=(1,0)` and `(1,tau)`, so their degree-six coefficients differ by
`a1*tau!=0`. At least one seed color therefore retains exact degree six for every target on this
divisor. Exact GF(8) specializations give squarefree resultants of degree seven for both seed
colors and a squarefree degree-six resultant on `y1=0`. Hence both coefficient-space strata are
generically separable.

This rules out a universal resultant degree drop or hidden component as the explanation for the
three frozen empty-target certificates. Their obstruction is arithmetic: factorization and
collision rationality remove every candidate after specialization. The next coefficient-space
gate is therefore the arithmetic/geometric monodromy of the generic degree-seven cover (and the
degree-six boundary cover), together with its compositum with the one-repair collision covers.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_symbolic_coverage_resultant.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_symbolic_coverage_resultant_output.txt`.

```text
bb750f220644fe7d8f1697bb8a4ea5318256a8f37247f4b3ae74cf1c7e4f12e2  analyze_c210_symbolic_coverage_resultant.py
33e8188354b7997ea7833e2266cf5ffe176a13eff0047b2dcf7f98b3b0ed8afd  analyze_c210_symbolic_coverage_resultant_output.txt
```

## Eighteenth coordinate gate: generic coverage has full symmetric monodromy

Fix one seed color and the quadratic repair coefficients, and retain the target coordinates as
variables.  The seed--repair incidence source is rational: its coordinates are the repair
parameter `r`, the seed parameter `t`, and the target horizontal coordinates `(y0,y1)`; the chord
formula determines `(h0,h1)`.  Eliminating `t^2` between the two coordinate equations recovers `t`
linearly over the generic resultant root.  Thus the degree-seven resultant from the seventeenth
gate is the actual connected incidence cover, not a quotient with hidden seed-coordinate degree.
In particular its geometric monodromy is transitive.

One frozen `GF(8)` specialization certifies simple degree-two inertia.  With orbit-one
coefficients, seed color `A`, and

```text
(y0,y1,h0,h1)=(0,1,0,tau^4),        r=tau^5,        t=tau,
```

the degree-seven resultant has

```text
gcd(P,P_r)=(r+tau^5)^2.
```

After removing that square, the residual factor is squarefree and nonzero at `tau^5`; the two
original incidence quadratics have the unique common seed parameter `t=tau`.  Hence this is one
ramified incidence point of exact fiber multiplicity two, so geometric inertia acts as a
transposition.  A transitive group of prime degree seven is primitive, and a primitive subgroup
containing a transposition is the full symmetric group.  Therefore both geometric and arithmetic
monodromy are `S7`.  Equivalently, the generic coefficient-space degree-seven cover has full
monodromy because its group contains this specialized `S7`.

The boundary `y1=0` is similar but needs one extra group-theoretic witness.  The incidence source
on that divisor remains rational and the relevant seed color has degree six.  At

```text
(y0,y1,h0,h1)=(0,0,1,1),            r=tau^3,        t=tau^3,
```

the resultant has one exact doubled root and one incidence point over it, again giving a geometric
transposition.  At the unramified target `(0,0,0,1)`, its factor degrees are `[1,5]`, and `t` is
linear over both repair residue fields.  Frobenius therefore supplies a genuine 5-cycle.  A
5-cycle cannot preserve either nontrivial block system of a transitive degree-six action (blocks
of size two or three), so the arithmetic group is primitive; the transposition forces `S6`.  The
geometric group is normal in `S6` and contains that transposition, whose normal closure is `S6`.
Thus both boundary groups are `S6`.

These covers are also generically independent from the one-repair collision cover

```text
H = S5 x C2 x C2.
```

Pulling the collision cover back to the rational incidence source preserves its geometric group
`H`.  For a collision branch value `r=rho`, the fixed-`rho` seed--repair incidence hypersurface is
generically distinct from the corresponding hypersurfaces for every other repair value: equality
would identically put two repair points and one seed point on a chord, contrary to the explicit
bounded-degree collision equations.  Generic collision inertia is therefore supported on one
candidate sheet.  The top `S7` or `S6` action conjugates that inertia through all sheets, giving

```text
degree-seven stratum:       H wr S7,
degree-six boundary:        H wr S6
```

for both geometric and arithmetic composita.  The concrete coverage transpositions do not hide a
quadratic sign coupling: their repair roots `tau^5` and `tau^3` avoid the four same-seed poles
`{0,1,tau^2,tau^6}`, while every mixed-collision branch value lies outside `GF(8)`.

The wreath group makes the coefficient-generic density transparent.  A candidate sheet is
one-repair-legal on `44/480=11/120` of `H`.  If `sigma in S_n` is the top Frobenius, only its fixed
sheets are rational, so one seed color has at least one rational legal candidate with density

```text
1 - (1/n!) * sum_sigma (1-11/120)^fix(sigma)
 = 0.087590764727...     for n=7,
 = 0.087590764716...     for n=6.
```

This is a compatibility theorem, not an affine-completeness theorem.  It says the generic
coverage candidates do not correlate favorably with the one-repair survivor condition; roughly
`8.76%` of generic targets are hit by a legal candidate from one seed color.  The next gate is the
joint monodromy of the two seed colors together with the three seed--seed secant schemes.  It must
decide whether the simultaneous no-legal-repair class meets the seed-uncovered locus.  A larger
plane census would not answer that coefficient-space question.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_generic_coverage_monodromy.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_generic_coverage_monodromy_output.txt`.

```text
298932fe05e09b2a379d1eef8b61bbce51e02340a236bdeaefad3ce3fabbdf09  analyze_c210_generic_coverage_monodromy.py
127e6fc29257631e04f5b3229e621538a10bf56b4a4b8b55dca83e12bdcda238  analyze_c210_generic_coverage_monodromy_output.txt
```

## Nineteenth coordinate gate: the joint seed route leaves positive density uncovered

The three seed--seed chord classes also have small exact covers.  On the generic stratum `y1!=0`,
write a mixed `A`--`B` chord with seed difference `d=t+u`.  The omega-coordinate equation recovers
the translated second endpoint linearly.  Substituting it into the base-coordinate equation gives

```text
P_AB(d) = B^2*d^5 + B*d^4 + (A^2+A)*d^3
          + y1*d^2 + (h0+1)*d + y1*tau,                 (18)

A=(y1^2+h1+tau)/tau,                 B=y1/tau.
```

The incidence source is rational and (18) is generically degree five, so the geometric action is
transitive.  Three squarefree `GF(8)` fibers have factor degrees

```text
[5],                  [2,3],                  [1,4].
```

The `[2,3]` Frobenius has a transposition as its third power; prime-degree transitivity therefore
forces arithmetic `S5`.  The `[5]` Frobenius is even and the `[1,4]` Frobenius is odd.  Since both
occur at rational unramified targets, the geometric group cannot be the constant-index-two `A5`
subgroup.  Hence the mixed seed cover has both arithmetic and geometric group `S5`.

For a same-layer chord of seed height `c=(c0,c1)`, put `p=t+u` and `q=tu`.  The target equations
recover

```text
p_c = (h1+c1+y1^2)/y1,
q_c = h0+c0+y0^2+y1^2+y0*p_c.                            (19)
```

The chord exists exactly when `p_c!=0` and

```text
tr(q_c/p_c^2)=0.                                         (20)
```

Thus `AA` and `BB` are two Artin--Schreier characters.  Their pole divisors are distinct because
the two pair sums differ by `tau/y1`.  The checker exhausts all 3,584 generic q=64 targets,
25,088 mixed differences, and 200,704 same-layer unordered-pair comparisons against direct chord
incidence.  It also realizes all eight Frobenius triples

```text
(sign(P_AB), trace_AA, trace_BB) in C2^3.
```

The mixed `S5` cover can intersect an abelian compositum only through its sign quotient, so these
eight witnesses prove that the seed-only joint group is

```text
S5 x C2 x C2.                                             (21)
```

The two seed colors in the repair covers are independent as well.  At
`(y0,y1,h0,h1)=(0,1,0,tau^4)`, the `A`-repair resultant has one exact doubled root while the
`B`-repair resultant is squarefree.  At `(0,1,1,tau^4)` the roles reverse.  These supported
transpositions separate the two `S7` top groups.  The fixed-repair incidence hypersurfaces for
`A` and `B` are also distinct, so the collision inertia from the eighteenth gate remains supported
on one of the fourteen candidate sheets.  Finally, the seed-only branch divisors are independent
of the repair-coefficient branch divisors.  The full coefficient-generic group on `y1!=0` is
therefore

```text
((H wr S7) x (H wr S7)) x (S5 x C2 x C2),
H=S5 x C2 x C2.                                           (22)
```

This yields a genuine route obstruction.  Each same-layer class is absent with density `1/2`, the
mixed seed quintic is rootless with density `44/120=11/30`, and one seed color has no rational
one-repair-legal candidate with density

```text
a = 1647740935800659269 / 1805923123200000000
  = 0.9124092352729555...
```

Consequently the coefficient-generic density missed by all three seed--seed classes and both
legal seed--repair classes is

```text
(1/2)^2 * (11/30) * a^2
  = 29865552106645555637458091245391757971
    / 391362999229013085388800000000000000000
  = 0.07631163948937644... .                              (23)
```

Any partial repair domain is a subset of the one-repair-legal parameters, so thinning cannot fill
these targets with a seed--repair chord.  This does not yet close the quadratic repair mechanism:
repair--repair secants may cover part or all of the class in (23), even though they were redundant
for the full q=64 layer.  The next gate is the repair--repair incidence character together with
the requirement that both endpoints lie in an arc-legal independent domain.  No plane census is
needed.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_joint_coverage_monodromy.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_joint_coverage_monodromy_output.txt`.

```text
ba4c93d216f46f369d8143f8d39bfbc2018c4906e7964de635c2333f32621fe5  analyze_c210_joint_coverage_monodromy.py
71e9bf377337fe1fb176f24b887e01a9ebaa5d3fb4ddc4950909183512243fd2  analyze_c210_joint_coverage_monodromy_output.txt
```

## Twentieth coordinate gate: repair--repair chords do not rescue generic coefficients

For two repair parameters `r,s`, put `p=r+s`, `q=rs`, and `Y=y-eta`.  The quadratic repair height
`g(r)=a*r^2+b*r+c` makes the chord interpolation collapse to

```text
h = c + Y^2 + Y*((1+a)*p+b) + (1+a)*q.                   (24)
```

The internal repair-arc condition already gives `1+a!=0`.  Hence, after dividing by `1+a`, a
generic target determines the pair sum and product from

```text
q+Y*p = (1+a)^(-1)*(h+c+Y^2+Y*b).                       (25)
```

Writing both sides in the `1,omega` basis recovers `p` from the omega coordinate whenever
`y1!=eta1`, then recovers `q` from the base coordinate.  A repair--repair chord exists exactly when

```text
p!=0,                         tr(q/p^2)=0.               (26)
```

Thus the entire `RR` class is one more Artin--Schreier character, not a high-degree candidate
cover.  The checker compares (24)--(26) with all 100,352 direct unordered repair-pair incidences
over the generic q=64 target stratum.  It obtains 2,688 targets with nonzero recovered pair sum,
512 on the divisor `y1=eta1`, and 384 with pair sum zero; every direct chord agrees exactly.

This new character is independent.  Together with the mixed-seed sign and the two same-layer
characters, all sixteen Frobenius quadruples

```text
(sign(P_AB), trace_AA, trace_BB, trace_RR) in C2^4
```

occur at unramified `GF(8)` targets.  Its pole divisor is also distinct from the seed--repair
coverage and collision divisors.  A compact witness is

```text
(y0,y1,h0,h1)=(0,1,0,tau^6),       p_RR=0,       q_RR=tau^4.
```

Here `q_RR!=0`, so Artin--Schreier reduction gives genuine ramification, while both degree-seven
seed--repair resultants, the mixed seed quintic, and the same-layer covers are unramified.  The
repair pole varies with the quadratic coefficients and is not any fixed-repair collision image.
Consequently the full coefficient-generic group becomes

```text
((H wr S7) x (H wr S7)) x (S5 x C2 x C2 x C2_RR).       (27)
```

The `RR` class is absent on half of (23).  Therefore every chord class simultaneously misses the
coefficient-generic density

```text
29865552106645555637458091245391757971
  / 782725998458026170777600000000000000000
 = 0.03815581974468822... .                              (28)
```

This closes generic quadratic repair coefficients: even the full repair layer is not affine
complete, and deleting repair points cannot add coverage. It does not yet close every quadratic
family: a field-varying coefficient family could in principle remain inside a proper joint-
monodromy locus. The next gate must distinguish genuine monodromy drop from small-field arithmetic
coverage before classifying those coefficient conditions; the twenty-first gate performs that
distinction for the q=64 layers.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_repair_repair_coverage.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_repair_repair_coverage_output.txt`.

```text
f4efb70bde75e8a417051f8d634ffb4a1f72688c869e353d837b70ea2596e479  analyze_c210_repair_repair_coverage.py
9bdbb50a57774b2f930ac5fbcaa47bd56473c82e171c997aa86a7017a2f18fa4  analyze_c210_repair_repair_coverage_output.txt
```

## Twenty-first coordinate gate: q=64 completeness is not a degree-seven monodromy drop

The phrase “the q=64 complete layers lie on an exceptional monodromy-drop locus” was too strong.
Completeness over one finite field is an arithmetic fiber statement and does not imply geometric
monodromy drop. The exact coefficient slice now separates those notions.

Translate the repair parameter so that `eta0=0`. This is an exact quotient, not a sampling
normalization: the remaining quadratic graph is

```text
eta=omega*eta1,
g(r)=c0+omega*(a1*r^2+b1*r+c1),
eta1!=0.
```

Exhausting all `7*8^4=28,672` normalized tuples gives 551 graphs whose full secant set covers every
affine point outside the conic and 550 that cover the whole affine plane. These coverage-only
counts include degenerate and collision-illegal graphs. Imposing conic avoidance and exact
no-three-collinear legality on the full 24-point layer leaves exactly twelve graphs; all twelve are
affine-complete and are precisely the previously known survivors.

The twelve legal points split into three four-point blocks. In each block
`(eta1,a1,b1,c0)` is fixed and

```text
c1 -> c1 + a1*d^2 + b1*d,       d in GF(8).             (29)
```

has four distinct values. Thus every legal q=64 exceptional block is exactly the subfield-
translation orbit of one frozen representative; there is no fourth rational component hidden by
the earlier raw parameterization. Since the translation is in the seed stabilizer and is defined
over every scalar extension, the already-closed three frozen scalar-extension families also close
these translated blocks.

More importantly, each frozen representative has an exact interior double-branch witness for the
degree-seven `A`--repair cover. The derivative gcd is `(r+rho)^2`, the residual factor is squarefree
and avoids `rho`, and the incidence point above `rho` is unique. The fixed-coefficient incidence
source is rational and geometrically connected, so transitivity in prime degree together with this
transposition gives geometric and arithmetic `S7` for every orbit. The three q=64 layers therefore
do **not** lie on the degree-seven monodromy-drop locus. Their q=64 coverage is a small-field
arithmetic exception compatible with full `S7`, exactly as the frozen extension obstructions
suggested.

This corrects the next gate. One must first specialize the **full joint** group (27) at the three
representatives and determine whether any lower factor or coupling drops; one cannot infer such a
drop from q=64 completeness. After that, classify the genuine coefficient-space drop divisors and
their intersections. The known q=64 points supply full-`S7` control points, not presumed points on
those divisors. A larger plane census still does not answer this symbolic question.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_exceptional_quadratic_locus.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_exceptional_quadratic_locus_output.txt`.

```text
7f2be80466f6d4d224f3d843d5993f59913ebf05be3c8cac0812cbe6672a40ff  analyze_c210_exceptional_quadratic_locus.py
51f17198f87cf1ede32f552acadfded1ff1281959858d881c0792cadd8127061  analyze_c210_exceptional_quadratic_locus_output.txt
```

## Twenty-second coordinate gate: the q=64 exceptions retain the full joint group

Specializing only the degree-seven top cover was not enough: a lower collision factor, a second
seed color, or a quadratic-character coupling could still have dropped at one of the three frozen
coefficient points.  The full specialization checker now excludes each possibility separately.

For every orbit representative and both seed colors, it gives a rational target at which the
degree-seven seed--repair resultant has one exact doubled repair root.  The residual factor is
squarefree and avoids that root, and the seed parameter above the doubled root is unique.  At the
same target

```text
the other seed--repair resultant is squarefree,
the mixed-seed quintic is squarefree,
both same-seed Artin--Schreier denominators are nonzero,
the repair--repair Artin--Schreier denominator is nonzero,
and the repair root avoids all four same-seed collision poles.
```

The mixed-collision branch values lie outside `GF(8)`, so the last condition also isolates the
transposition from the full one-repair group `H=S5 x C2 x C2`.  The exact witnesses, in the format
`(target tau exponents; doubled-root exponent)`, are

```text
orbit 1: A ((-,0,-,4);5),       B ((-,0,0,4);5),
orbit 2: A ((-,0,1,4);6),       B ((-,0,-,4);5),
orbit 3: A ((-,0,5,6);3),       B ((-,3,3,1);5).
```

Here `-` denotes zero.  Each fixed-coefficient incidence source is rational and connected, so
prime-degree transitivity plus its isolated transposition gives geometric and arithmetic `S7`.
The fixed-repair incidence hypersurfaces for distinct repair values and for the two seed colors
remain distinct: equality would force a forbidden three-point chord in one of these arc-legal
24-point layers.  Pulling back the already-certified one-repair collision cover and conjugating its
supported inertia by each `S7` therefore gives two independent factors

```text
(H wr S7) x (H wr S7).                                  (30)
```

The lower factors do not couple after specialization.  For each of the three representatives, an
exhaustion of the unramified `GF(8)` target fibers realizes all sixteen tuples

```text
(sign(P_AB), trace_AA, trace_BB, trace_RR) in C2^4.
```

In addition, each orbit has a repair--repair pole with nonzero product where both seed--repair
resultants, the mixed quintic, and the same-seed covers are unramified.  The targets and nonzero
products are

```text
orbit 1: target (-,0,-,6), q_RR=tau^4,
orbit 2: target (-,0,6,1), q_RR=tau^6,
orbit 3: target (-,0,1,-), q_RR=tau^2.
```

The seed-only `S5 x C2 x C2` branch supports are coefficient-independent, and these isolated
repair branches prove that `C2_RR` remains geometrically independent.  The sixteen Frobenius
tuples rule out a residual arithmetic sign coupling.  Consequently every frozen representative
has the full geometric and arithmetic group

```text
((H wr S7) x (H wr S7)) x (S5 x C2 x C2 x C2_RR),
H=S5 x C2 x C2.                                           (31)
```

The four legal q=64 layers in each block are conjugate by the seed-stabilizer translations (29),
so (31) holds on all twelve exceptional layers.  Their affine completeness is wholly a
small-field arithmetic exception: none lies on any joint-monodromy-drop locus.  The next gate is
now the genuine one—compute the coefficient-space branch discriminants, classify their drop
divisors and intersections up to the translation quotient, and determine whether any divisor can
support an arc-legal affine-complete family over infinitely many odd extensions.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_frozen_joint_monodromy.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_frozen_joint_monodromy_output.txt`.

```text
f14a9c5f2f3c21adce3e0363dcb35c5ca4f82ee408d35ddb0ec0ec9d3506eec3  analyze_c210_frozen_joint_monodromy.py
4c37c0aea0c335f7e6ce66df9f43f444240e2e6492d3e04c4d5ee14344cc970c  analyze_c210_frozen_joint_monodromy_output.txt
```

## Twenty-third coordinate gate: the translation quotient removes `c1` geometrically

Before computing large branch discriminants, one coefficient can be removed exactly.  A subfield
translation `x -> x+d` fixes both seed layers.  Reparametrizing the translated repair graph by
`r' = r+d` fixes `eta1,a1,b1,c0` and sends

```text
c1 -> c1 + a1*d^2 + b1*d.                               (32)
```

This is a conjugacy of the full point configuration, not merely an equality of coefficient counts:
the checker compares the translated and reparametrized repair point sets for every `d in GF(8)`
and every frozen representative.  It therefore preserves arc legality, every chord class, and the
entire joint incidence cover.

The repair-arc stratum has `a1!=0`.  Over the algebraic closure, the equation

```text
a1*d^2+b1*d = c1
```

always has a root, so every geometric orbit meets `c1=0`.  Thus genuine geometric monodromy-drop
divisors are pulled back from the four-coordinate quotient

```text
(eta1,a1,b1,c0).                                         (33)
```

The finite-field residue is also exact.  If `b1=0`, Frobenius is bijective and (32) has one orbit.
If `b1!=0`, its kernel is `{0,b1/a1}`, its image has index two, and the two arithmetic twist classes
are distinguished by

```text
chi = Tr(a1*c1/b1^2).                                    (34)
```

Indeed, after `z=a1*d/b1`, an increment in (34) is `Tr(z^2+z)=0`; conversely the trace-zero
criterion solves the Artin--Schreier equation.  Each q=64 exceptional block is exactly the
four-element `chi=1` class for its fixed `(eta1,a1,b1,c0)`; the opposite four coefficients form the
other twist.  Consequently the drop-divisor calculation needs only the four geometric variables
in (33), followed by at most one arithmetic trace-bit check.  It must not treat the eight `c1`
values as eight unrelated coefficient cases.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_translation_quotient.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_translation_quotient_output.txt`.

```text
100f1df367a4a02ee94e25334878feecdd1cf41e26d39ad0b8809f06a7453b6e  analyze_c210_translation_quotient.py
42e4affb290c1deeffb22c8618b1d030441d37bf9b468e345cdd0447e3c8378e  analyze_c210_translation_quotient_output.txt
```

## Twenty-fourth coordinate gate: the mixed-cover drop divisors are exact

The first coefficient-space branch calculation can be done without expanding a large resultant.
Put

```text
e=eta1,                 k=c0+1,
h(r)=a1*r^2+b1*r+e^2,  L(r)=h(r)^2+tau*h(r).
```

For the mixed-seed collision quintic, simultaneous vanishing with its `d`-derivative forces
`d^2=tau*omega` or `tau*omega^2`.  Eliminating this conjugate pair gives the degree-eight branch
polynomial

```text
B(r)=L(r)^2+tau*(e^2+k)*L(r)+tau^2*(e^4+e^2*k+k^2).       (35)
```

On the repair stratum `e*a1!=0`, its derivative is the constant

```text
B'(r)=tau^2*b1*(e^2+k).                                  (36)
```

Thus the eight branch values cease to be distinct on exactly two reduced divisors: `b1=0`, where
the additive-quartic fibers become inseparable, and `e^2+k=0`, where the two four-point critical
fibers coincide.  Loss of simple transposition inertia adds one more reduced divisor.  If
`s=sqrt(tau)` and `C=e^2+s*e`, its equation is

```text
D_H=k^2+C*k+C^2=0.                                       (37)
```

The raw norm obtained by squaring the second Hasse derivative is `D_H^2`; using that nonreduced
equation would incorrectly double the divisor.  Over `GF(64)`, (37) factors as

```text
(k+omega*C)*(k+omega^2*C).
```

The two geometric components meet on the repair stratum at `(e,k)=(s,0)`.  The critical-value
divisor meets them at `(e,k)=(s*omega,e^2)` and `(s*omega^2,e^2)`, respectively.  Intersecting with
`b1=0` gives the corresponding pair and triple intersections; there are no other ones.

An exhaustive check over the `7*7*8*8=3136` `GF(8)` quotient points with `e*a1!=0` finds 392 points
on each of `b1=0` and `e^2+k=0`, and 56 on (37).  The last 56 all lie over the single rational
intersection `(e,k)=(s,0)`.  The three pairwise rational intersection counts are `49,7,0`, and the
triple intersection has no `GF(8)` point.  All three exceptional q=64 blocks avoid every divisor,
as required by their already-certified full joint group.

Equations (35)--(37) depend only on `(eta1,a1,b1,c0)`.  Restoring `c1` therefore introduces no
geometric or arithmetic twist in this lower `S5` factor: both values of
`Tr(a1*c1/b1^2)` have the same mixed branch discriminants.  This completes the lower mixed-cover
piece of the coefficient-drop gate.  The two degree-seven seed--repair coverage covers still
require their coefficient-space branch calculation before any drop divisor can be tested for an
infinite arc-legal affine-complete family.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_coefficient_branch_divisors.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_coefficient_branch_divisors_output.txt`.

```text
974c8951bbee5f0d857935eafefe201a204c4a93a5340f368230a05ed24fb024  analyze_c210_coefficient_branch_divisors.py
255f7fb968bd0ad6dff87a82dc0627f834d0c9bbcbfc052514bf3e0e811d23e5  analyze_c210_coefficient_branch_divisors_output.txt
```

## Twenty-fifth coordinate gate: the coverage ramification sources are exact and distinct

Expanding the degree-seven coverage discriminants directly is the wrong algebraic interface in
characteristic two: the ordinary discriminant is a square, while a naive sparse Sylvester
expansion obscures the much smaller ramification equation.  Work instead on the rational
incidence source.  For repair parameter `r`, seed parameter `t`, target abscissa `y`, and one fixed
seed height `z`, put

```text
x=eta+r,       D=x+t,       Y=y+t,       q=g(r)+z.
```

The height of the chord at `y` is

```text
h=z+Y^2+Y*(D+q/D).
```

Since `g'(r)=omega*b1` in characteristic two, clearing the common `D^2` denominator gives

```text
dh/dr = Y*(D^2+omega*b1*D+q),
dh/dt = D^3+q*D+Y*(D^2+q).                              (38)
```

The branch source is therefore the coordinate determinant over `F`

```text
J_z=det_F(dh/dr,dh/dt)=0.                               (39)
```

On the translation quotient `eta0=1`, `c1=0`, `k=c0+1`, exact sparse expansion gives 222 terms
for seed `A` and 238 for seed `B`.  Both have total degree eight and degree vector at most

```text
(eta1,a1,b1,k,y0,y1,r,t) = (5,2,2,2,2,2,5,5).
```

Neither ramification equation has all four source derivatives identically zero at any of the
`3136` `GF(8)` repair-stratum coefficient points `eta1*a1!=0`.  More importantly, the two seed
equations cannot merge on a coefficient stratum.  Their difference has only 35 terms, is
independent of `a1`, and the coefficient of the bare target coordinate `y1` is the nonzero
constant `tau^4`.  Hence `J_A-J_B` is never the zero polynomial, over any coefficient field or
arithmetic twist.  A wholesale identification of the two degree-seven ramification covers is
therefore not a coverage drop divisor.

The checker reconstructs the degree-seven elimination resultants on the quotient and performs
`540` direct incidence-plus-Jacobian evaluations for each seed color.  The remaining gate is to
compute the images of (39), classify where either image discriminant loses generic simple branch,
and then intersect only those genuine divisors with the mixed-cover components (36)--(37) and the
arithmetic twist bit (34).

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_coverage_branch_discriminants.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_coverage_branch_discriminants_output.txt`.

```text
7a5b31ead2c4bc990443560cc437601cc5f27fe90bf6f127a40d2be61a3a6621  analyze_c210_coverage_branch_discriminants.py
71df1c9115a48b8476f7b9f6cae282337cb070393b44e5fa9ac22d570ceb84a3  analyze_c210_coverage_branch_discriminants_output.txt
```

## Twenty-sixth coordinate gate: every rational coverage image retains simple branch

The source equations alone did not show whether their images could lose all simple branch inertia
on a coefficient stratum.  The full rational translation quotient now has an exact image-level
test.  For each of the `3136` points

```text
(eta1,a1,b1,c0) in GF(8)^4,       eta1*a1 != 0,
```

and for each seed color, the checker finds a target with a degree-seven repair resultant whose
derivative gcd is exactly `(r+rho)^2`.  The residual quintic is squarefree and avoids `rho`, the
seed parameter above `rho` is unique, the chord denominator is nonzero, and direct substitution
both maps the source point to the target and annihilates `J_z`.  The two witness tables have stable
SHA-256 digests

```text
A: 5406f7f493ac45354875348ba88b8c7c4aa73d036373c52b8359a274ad024de6
B: d8dd615e9d1626df209a969397e5af7edbdcb0334803206d5ab54a27c1e2e67f
```

This includes all `392` rational points on `b1=0`, all `392` on
`eta1^2+c0+1=0`, and all `56` on the reduced non-simple mixed-cover divisor.
Thus none of the rational points of the known lower-factor components forces a simultaneous
coverage-image drop.  There is also a uniform source-separability identity: the coefficient of
`t^4` in `dJ_z/dy1` is `1` for both seed colors, independent of every coefficient.

The conclusion is deliberately bounded to the rational quotient.  A genuine geometric coverage
drop divisor could have no `GF(8)` point, just as the reduced mixed-cover divisor has conjugate
components, and the second arithmetic class from `Tr(a1*c1/b1^2)` has not been tested.  The next
gate is therefore extension-field elimination of the two branch images, followed only then by
intersection with (36)--(37) and restoration of the twist bit.  The rational audit has removed
every `GF(8)` coefficient point from that search without replacing the symbolic gate by a plane
census.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_coverage_branch_images.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_coverage_branch_images_output.txt`.

```text
3a21781ac5c91dcf94b68b10796e68740a621c48d145981cf02ce7f19f915e29  analyze_c210_coverage_branch_images.py
f749b73d111f8356a13ebecfe5cdd3dfab1435c89394545d2862444a757da338  analyze_c210_coverage_branch_images_output.txt
```

## Twenty-seventh coordinate gate: known extension strata and the arithmetic twist survive

The first extension-field check is deliberately coefficient-geometric rather than a larger plane
census.  The reduced mixed-cover divisor (37) has two conjugate components

```text
k+omega*C=0,        k+omega^2*C=0,        C=e^2+sqrt(tau)*e,
```

and the rational audit in the preceding gate sees neither component generically.  Exact
`GF(64)` closed-point witnesses now show that both seed--repair coverage covers retain a branch
target with exactly one doubled repair root at a generic point of each component, at its
intersection with `b1=0`, at both conjugate intersections with `e^2+k=0`, and at the resulting two
conjugate triple intersections.  Thus no known geometric mixed-cover component, nor any of these
lower-factor intersection strata, is contained in a simultaneous coverage-image drop locus.

The omitted finite-field translation class is also closed at this branch gate.  For every
`7*7*7*8=2744` rational quotient point with `e*a1*b1!=0`, choose a representative satisfying

```text
Tr(a1*c1/b1^2)=1.
```

For both seed colors, the exact degree-seven resultant again has derivative gcd precisely
`(r+rho)^2`, squarefree residual quintic, and a unique seed parameter over `rho`.  The stable
witness-table digests are

```text
A: 4102a9d58baacf0bd338042a5f4c25df2eba0fee7a95fa50d5ec49e8bc0efb09
B: f603013a5e1941a58d69ee6f3687fb574d3db3ae1e494baddebb757195e9dc06
```

This does not classify unknown coverage image divisors: a new component disjoint from the known
lower-factor locus could still occur over an extension.  The next gate remains elimination of the
two branch images themselves.  What has changed is that intersections with (36)--(37) and the
arithmetic twist no longer need to be carried as unresolved first-order candidates.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_extension_branch_strata.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_extension_branch_strata_output.txt`.

```text
1f0b1d2e196fd42b1f2a71b26423ee78f438790772588dad5fcd7b73bc489d98  analyze_c210_extension_branch_strata.py
f0e913e6d2eec79c18e9988269b0dccc2d394cd45a0dd561ff2b7cee68308d11  analyze_c210_extension_branch_strata_output.txt
```

## Twenty-eighth coordinate gate: reduced coverage ramification exists universally

The remaining coverage calculation has a uniform source parametrization.  For either seed color
put

```text
D=x+t,        W=D^2+q,        E=omega*D,        Y=y+t.
```

The two differential columns in (38) become `Y*(W+b1*E)` and `(D+Y)*W`, and their
coordinate determinant has the exact decomposition

```text
J=Norm(W)*det(Y,D)+b1*det(Y*E,(D+Y)*W).                 (40)
```

Now impose

```text
W=s*E,        Y=lambda*D+mu*E.                          (41)
```

At `mu=0`, (40) vanishes identically, while its transverse derivative is

```text
dJ/dmu = s*(s+b1)*Norm(D)^2.                            (42)
```

This family exists for every repair-stratum coefficient specialization, not merely generically.
Writing `D=(d,e)` with `d=1+r+t`, the two coordinates of `W=sE` are

```text
d^2+e^2+k+1+z0 = s*e,
e^2+a1*r^2+b1*r+z1 = s*(d+e).                           (43)
```

Over the algebraic closure, first solve the monic quadratic for `d`, then the quadratic in `r`,
whose leading coefficient `a1` is nonzero; finally set `t=d+1+r`.  Because `e!=0`, only two values
of `d/e` make `Norm(D)=0`.  The free scalar `s` can therefore avoid those values as well as
`0,b1`, and `lambda` can avoid `0,1`.  Equations (41)--(42) then give a non-endpoint reduced
ramification source for both seed colors at every coefficient point with `e*a1!=0`.

Consequently no extension-field coefficient divisor can make the coverage ramification source
disappear or become everywhere nonreduced.  The remaining image-divisor gate is now only the
global collision question: can every point of this reduced family share its target with another
ramification point on a special coefficient stratum?  The next elimination should compare two
distinct ramification sources over their common target; it need not recompute source
separability or intersect the already-closed lower-factor and twist loci.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_universal_ramification_family.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_universal_ramification_family_output.txt`.

```text
14aac2cc62f18271455629981bf9d5e6a97ccf57309fc5e9bdbf4f6f545ebfa3  analyze_c210_universal_ramification_family.py
ce8bbbd3c785e427bfbd25a23da4cc314c770124870223fbb00d88c327fa9faa  analyze_c210_universal_ramification_family_output.txt
```

## Twenty-ninth coordinate gate: the universal branch section has no self-collision

On the reduced family (41), the branch target simplifies to

```text
y=t+lambda*D,
h=z+lambda^2*D^2+lambda*s*omega*D.                      (44)
```

After substituting the first equation in (43), its coordinates are triangular:

```text
y1 = lambda*e,
h0 = z0+lambda^2*(k+1+z0)+s*e*(lambda^2+lambda),
h1 = z1+lambda^2*e^2+lambda*s*(d+e),
y0 = 1+r+(lambda+1)*d.                                  (45)
```

On the already-selected open set `e*lambda*(lambda+1)*s!=0`, these recover in order
`lambda,s,d,r`, and then `t=d+1+r`.  The checker verifies every cross-multiplied inverse identity
in the exact polynomial ring.  Hence the universal reduced ramification family is injective onto
its image: two distinct points of this section cannot create a multiple branch image.  Any
remaining collision must pair the section with a ramification source outside it.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_ramification_image_section.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_ramification_image_section_output.txt`.

```text
e7b68c444e7b854d2d85ae0f1ac260f6a5b42569b9658a50cfe4e2f73ba1a84b  analyze_c210_ramification_image_section.py
d34b66da5cde54b2e65f16c2e6576475820d01331c3ed3f6b97b62350a833269  analyze_c210_ramification_image_section_output.txt
```

## Thirtieth coordinate gate: external collision is a low-variable system

Compare a section point with a second source over the same target and put

```text
u=r'+r,        v=d'+d.
```

Then the second-source data are

```text
D'=D+(v,0),
Y'=lambda*D+(u+v,0),
W'=W+(v^2,a1*u^2+b1*u).                                 (46)
```

The two target-height collision equations have only `10` and `17` terms and are both quadratic
in `v`; the second-source ramification equation has `82` terms and degree five in `v`.  Remarkably,
all three are independent of `k`, the seed color, and the original repair root `r`.

The known source is `u=v=0`.  The exact Sylvester resultant of the two collision quadratics has
factor precisely `u^2`; after saturation the external collision polynomial has `111` terms and
degree five in `u`, with digest

```text
2ec5288fc9dc900c51fccb71bf63cf72ccbf9f6f25908db6a19f3bfdf6742fed.
```

On the generic linear-subresultant chart, the common root is `v=L0/L1`, where `L0,L1` have `27`
and `18` terms.  Substitution into the ramification equation, with denominators cleared, produces
an `8866`-term polynomial with the same known-source `u^2` valuation and digest

```text
de26a6738b00c18a1a815c7b3b525d56f1120ee9659fd7a2fcf22bd8516f35b8.
```

The final image-collision gate is therefore explicit: divide the latter equation by `u^2`,
eliminate `u` against the `111`-term degree-five collision resultant, and handle the `L1=0`
boundary charts separately.  No coefficient-space branch discriminant or ambient-plane census is
needed.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision_output.txt`.

```text
62b439970626ca2e328896eaee3546c2731239eac084d944062ab69af0ed34d3  analyze_c210_external_ramification_collision.py
6b1c6607b8c5f96c5c5b3e2a8b432b73c3a00f88e42de8961c2bb66f6eeb54cd  analyze_c210_external_ramification_collision_output.txt
```

## Thirty-first coordinate gate: the subresultant boundary is disjoint from the known source

The linear subresultant has additional exact structure.  Its constant term `L0` is divisible by
`u`, while

```text
L1|_(u=0) = s*(lambda+1)^2*Norm(D).                      (47)
```

Every factor on the right is nonzero on the selected section.  Hence the denominator boundary
`L1=0` cannot approach the known source `u=v=0`; it is a purely external chart and needs no further
known-root saturation.

The constant coefficient of the already-saturated 111-term collision resultant is also exact:

```text
lambda*(lambda+1)^2*Norm(D)
  *(s^2*Norm(D)+s*e*b1*(s+b1)+lambda*b1^2*Norm(D)).      (48)
```

Thus the `u=0` behavior contains only the displayed open-set factors and one additional expression
linear in `lambda` when `b1!=0`; it hides no coefficient-only component.  The corresponding
coefficient of the saturated external-ramification equation has 220 terms and stable digest

```text
52da40d7b031044b8b5252584560c042fdbe384ba2dbad10a6982d8a3336191b.
```

The next computation can therefore treat `L1!=0` and `L1=0` as genuinely disjoint external charts.
On the generic chart, reduce the degree-eighteen saturated ramification polynomial modulo the
degree-five collision polynomial before taking the final resultant; on the boundary, impose
`L0=L1=0` and eliminate `v` directly.

## Thirty-second coordinate gate: the collision quintic is generically squarefree on every section

The final elimination has a chart-free characteristic-two shortcut.  First, the apparent `u=0`
external boundary is empty.  After setting `u=0`, both collision equations have the common factor
`(lambda+1)v`; for `v!=0` their residual equations are

```text
d*v+e*s=0,
e*v+s*(d+e)=0.                                          (49)
```

Their exact linear combination is

```text
e*(d*v+e*s)+d*(e*v+s*(d+e))=s*Norm(D),                 (50)
```

which is nonzero on the selected section.  Thus every external affine collision has `u!=0`; the
universal `u^2` saturation removes only the known source.

Let the saturated 111-term collision resultant be

```text
R(u)=r5*u^5+r4*u^4+r3*u^3+r2*u^2+r1*u+r0.
```

At an external second source, ramification makes the local intersection of the two collision
equations nonreduced, hence makes the corresponding root of `R` multiple.  This implication is
valid on every finite-`v` chart: if `C=D'F` denotes the denominator-cleared collision map, then on
`C=0` its Jacobian is `J'/Norm(D')`, where `J'` is the second-source ramification numerator.  The
endpoint divisor `Norm(D')=0` is already excluded from the source.  No division by the linear
subresultant `L1` is involved.

In characteristic two,

```text
R'(u)=r5*u^4+r3*u^2+r1,
R(u)+u*R'(u)=r4*u^4+r2*u^2+r0.                         (51)
```

Writing `z=u^2`, a repeated root is therefore detected by the resultant of two quadratics in `z`.
The checker evaluates this both by the closed quadratic formula and by an independent `4 x 4`
Sylvester determinant.  The result has `3352` terms and exact factorization

```text
Res_z(R',R+uR') = e*lambda^4*(lambda+1)*Delta,          (52)
```

where `Delta` has `2746` terms.  The displayed factors are all endpoint/open-set factors; in
particular this calculation includes the formerly separate `L1=0` boundary.

It remains to ask whether `Delta` can vanish along the entire reduced section at a special repair
coefficient.  Both seed colours have `z0=1`, so the first section equation is

```text
s*e=d^2+e^2+k.                                         (53)
```

Substitute (53) into `Delta` and clear the maximal denominator `e^6`.  The resulting polynomial has
`5580` terms and `142` distinct `(lambda,d)` coefficient positions.  Decisively, its coefficient at
`lambda^3*d^18` is exactly

```text
e*a^4.                                                  (54)
```

This is nonzero at every repair-stratum coefficient specialization, where `e*a!=0`.  Hence the
multiple-root condition is never identically zero on the two-dimensional section.  Its nonzero
locus meets the dense open conditions on `s`, `s+b`, `Norm(D)`, `lambda`, and `lambda+1`; the second
section equation is solvable over the algebraic closure because its leading coefficient is `a`.
Therefore every repair-stratum coefficient point, for both seed colours, has a reduced section
branch image that does not collide with a second ramification source.  There is no new geometric
branch-image divisor from external collision.  Residual monodromy drops, if any, must be
higher-codimensional and cannot arise by universal collision of this section.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision_output.txt`.

```text
e5f86aedec03d3c4b404671ecf7de5dd93cc07dc2377d6565ecfb9372940b3d9  analyze_c210_external_ramification_collision.py
98f27a86902d6fc1bacca0fa5f6f06ad2b030dc6823a128da7f00efa9b7c88fd  analyze_c210_external_ramification_collision_output.txt
```

## Thirty-third coordinate gate: the two coverage top groups are uniformly independent

The preceding gate isolates a simple branch inside either fixed seed cover.  To make the joint
monodromy coefficient-uniform, it remains to show that this branch need not ramify the opposite
seed cover.  The same elimination handles that question after inserting the exact seed-height
shift

```text
delta_z=beta+alpha=tau*omega.
```

For a section point of seed `A`, the opposite-seed source has

```text
W'_B=W'_A+delta_z,
C_B=D'*(Y'^2+height+delta_z)+Y'*W'_B.                   (55)
```

The two coordinates of `C_B=0` remain quadratic in `v`.  Their Sylvester resultant `Q(u)` has
`216` terms and exact degree seven in `u`.  A direct specialization at target
`(tau^3,tau^2,0,1)` agrees, after `r'=r+u` and monic normalization, with the independent
seed--repair incidence resultant for seed `B`.

As in (51), characteristic two splits the repeated-root calculation:

```text
Q'(u)=q7*u^6+q5*u^4+q3*u^2+q1,
Q(u)+u*Q'(u)=q6*u^6+q4*u^4+q2*u^2+q0.                 (56)
```

These are cubics in `z=u^2`.  Their exact `6 x 6` Sylvester resultant has `100056` terms.  Its
selected-section factorization is

```text
Res_z(Q',Q+uQ')=e*Norm(D)*(lambda+1)^6*Xi.              (57)
```

The valuations of `a`, `a^2+a+1`, `b`, `s`, `lambda`, and `s+b` are all zero; (57) contains no
hidden coefficient divisor among them.  The core `Xi` has `46266` terms.  Substitute the section
relation `s*e=d^2+e^2+k` and clear `e^10`; the restricted polynomial has `96574` terms and `371`
distinct `(lambda,d)` coefficient positions.  Its coefficient at `lambda^8*d^30` is exactly

```text
tau*e^2*a^4.                                             (58)
```

Hence `Xi` is nonzero on the section for every repair-stratum coefficient point.  The nonzero
opens of (58), the same-seed core (54), and the endpoint conditions meet.  One may therefore choose
an `A` reduced branch point that is simple in the `A` cover and unramified in the `B` cover.  The
calculation is symmetric under exchanging the seed colours, so the converse isolated
transposition also exists.

This completes the top-group specialization argument on the intended tower.  For
`F=GF(8^m)`, `m` odd, `a^2+a+1` has no root, so each fixed-coefficient cover has degree seven on
`y1!=0`.  Its rational incidence source is irreducible, hence its monodromy is transitive; prime
degree plus the coefficient-uniform transposition gives `S7`.  The cross-seed isolation above
separates the two normal factors.  Thus at every repair-stratum coefficient point on every odd
tower the two coverage top groups are

```text
S7 x S7.                                                 (59)
```

There is no residual higher-codimension drop in the coverage top group.  The geometric degree-drop
divisor `a^2+a+1=0` has no point on the odd tower.  What remains is entirely in the already-known
lower mixed-collision group: the divisors `b=0`, `e^2+k=0`, and `D_H=0`, together with their
classified pair and triple intersections.  Those strata must now be tested for an arc-legal
affine-complete infinite family; no further coverage-branch elimination is needed first.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_external_ramification_collision_output.txt`.

```text
e5f86aedec03d3c4b404671ecf7de5dd93cc07dc2377d6565ecfb9372940b3d9  analyze_c210_external_ramification_collision.py
98f27a86902d6fc1bacca0fa5f6f06ad2b030dc6823a128da7f00efa9b7c88fd  analyze_c210_external_ramification_collision_output.txt
```

## Thirty-fourth coordinate gate: the lower collision strata still miss full-graph targets

The lower divisors change only the one-repair collision cover used to thin the repair domain.  For
coverage, one may forget legality entirely and allow every repair parameter.  A target with no
rational point in either seed--repair incidence fiber then has no seed--repair chord even from the
full graph, so deleting parameters to obtain an arc cannot help.

On every repair-stratum coefficient point of the odd tower, the preceding gate gives the two
coverage marginals `S7 x S7`.  The coefficient-independent seed-only covers retain
`S5 x C2 x C2`, and the repair--repair cover retains one nontrivial Artin--Schreier character.  The
latter remains distinct uniformly: if

```text
R=h+c+Y^2+Y*b*omega = R0+R1*omega,       Y=y-eta,
```

then division by `1+a*omega` shows that its pair-sum pole is

```text
p_RR=0  iff  a*R0+R1=0.                                  (60)
```

The coefficient of `h0` in (60) is `a!=0`, whereas the two same-seed poles have equations
`h1+c1+y1^2=0`; the mixed-seed discriminant is the coefficient-independent degree-five branch
cover.  Thus the lower coverage marginal is `S5 x C2 x C2 x C2_RR` throughout the three
coefficient divisors.  Exact isolated-branch checks cover all `784` rational quotient points in
their union, for both seed colours, and also both conjugate components of `D_H=0`, their `b=0`
intersections, their intersections with `e^2+k=0`, and both conjugate triple intersections.  At
every witness the opposite `S7` cover and all four lower covers are unramified.

No direct-product assumption is needed.  Any subdirect product of `S7 x S7` with
`S5 x C2^3` can couple the two sides only through sign characters, and the common elementary
abelian quotient has rank at most two.  The derangements split by parity as

```text
S7: 930 even + 924 odd,          S5: 24 even + 20 odd.   (61)
```

Enumerating every rank-at-most-two sign relation with surjective projections, while fixing the
three Artin--Schreier characters to their no-chord values, gives the uniform lower bound

```text
density(no chord of any of AA,AB,AR,BB,BR,RR)
  >= 1331/216000
   = 0.006162037... .                                    (62)
```

With no sign coupling, the exact density is

```text
(1854/5040)^2 * (44/120) * (1/2)^3
  = 116699/18816000
  = 0.006202115... .                                     (63)
```

Function-field Chebotarev therefore supplies uncovered affine targets over all sufficiently large
admissible odd extensions on each of `b=0`, `e^2+k=0`, and `D_H=0`, including every classified
intersection.  The cover degrees are bounded, so the square-root error is uniform over these
coefficient strata.  These targets are uncovered even by the full quadratic repair graph.
Consequently no partial domain can be affine-complete, regardless of whether the lowered collision
group makes arc thinning easier.  Together with the generic gate, this closes the entire
quadratic-height repair-graph mechanism.  It does **not** close C210: the next construction gate
must leave the single quadratic graph ansatz rather than search another coefficient stratum or
larger plane census.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_lower_collision_strata.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_lower_collision_strata_output.txt`.

```text
4d6e5baeaa76da4f46e74ced2f87ac7eeab3fe749dc9742584f6afc4fac0690d  analyze_c210_lower_collision_strata.py
509006345e65f07a79fe8a78a36acb37613b5fbbe1a0493ecfb0d1ef9db0d7da  analyze_c210_lower_collision_strata_output.txt
```

## Thirty-fifth coordinate gate: two repair cosets reduce to a shared-coefficient locus

The smallest mechanism outside one repair graph adds a second nontrivial additive coset.  Write

```text
R : eta=e*omega,   g(r)=c0+omega*(a*r^2+b*r+c1),
R': eta'=e'*omega, h(s)=c0'+omega*(a'*s^2+b'*s+c1'),
delta=e'+e != 0.                                           (64)
```

Fix a point `R'(s)` and ask whether it lies on a chord through two points `R(r),R(u)`.  Put
`p=r+u`, `q=ru`, `Y=s+delta*omega`, and

```text
T=h(s)+C+Y^2+B*Y=T0+T1*omega,
N=a^2+a+1.
```

The two coordinate equations are linear in `(p,q)` and give

```text
p=(T1+a*T0)/(delta*N),
q=T0+p*(s+a*delta).                                      (65)
```

On the odd tower `N!=0`.  The two left parameters exist distinctly exactly when

```text
p!=0,                  Tr(q/p^2)=0.                      (66)
```

Thus cross-repair legality is one Artin--Schreier trace problem, not a three-parameter incidence
search.  Write `p=P2*s^2+P1*s+P0`.  Exact expansion gives

```text
P2=(a'+a)/(delta*N),       P1=(b'+b)/(delta*N),
deg(q)<=3,                 leading(q)=P2*s^3.             (67)
```

Unless `q/p^2` is Artin--Schreier-equivalent to a trace-one constant, the curve
`w^2+w=q/p^2` gives trace-zero values, and hence forbidden triples, over every sufficiently large
field.  The exceptional cases classify directly:

- If `a'!=a`, then `P2!=0` and `q/p^2` tends to zero at infinity.  Any equivalent constant has
  trace zero, so it forces rather than avoids collisions.
- If `a'=a` but `b'!=b`, equivalence to a constant requires
  `T0(0)=a^2*delta^2`.  The constant is
  `P1^(-2)+P1^(-1)=z^2+z`, again of trace zero.
- Therefore an infinite collision-avoiding pair must satisfy

```text
a'=a,                    b'=b.                           (68)
```

On (68), `p=P0` is constant in both orientations.  The `2+1` cross-repair triples disappear only
when `P0=0`, or when

```text
Tr((T0(0)+a*delta*P0)/P0^2)=1.                          (69)
```

The bounded screen now has a conceptual explanation.  Among the twelve certified q=64 repair
blocks there are `48` unordered pairs on distinct cosets and `96` orientations; every orientation
has `a'!=a`.  The checker compares (65)--(66) with `21,504` direct projective triples.  Twenty-four
pairs have two forbidden third parameters in each orientation, and twenty-four have four in each
orientation.  Hence none of the twelve blocks can be doubled to a 32-point repair construction.
This is a targeted test of the certified blocks, not a reopened coefficient census.

The two-coset route is not yet closed.  Its only remaining full-layer locus has a shared ordered
coefficient pair `(a,b)` and the trace condition (69).  The next gate is to impose the still-missing
one-seed/one-point-from-each-repair collision equations on that locus, then test affine coverage.
The q=64 blocks supply no point on it.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_two_repair_cosets.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_two_repair_cosets_output.txt`.

```text
4ccc096e92ddf510f02cacf8ad571aada27e2996578ce661d1f7ad27257b3139  analyze_c210_two_repair_cosets.py
ef47957855713923d80c8f7c535b6fd79e45b9ce52814797bb7cd59bbf8db039  analyze_c210_two_repair_cosets_output.txt
```

## Thirty-sixth coordinate gate: seed--cross-repair legality is one resultant curve

Remain on the only possible infinite full-layer locus (68), and write

```text
delta=e'+e != 0,        s=r+u,
k0=c0'+c0,              k1=c1'+c1,
gamma=g0+g1*omega
```

for either seed height `gamma`.  Clearing the chord-height denominator and splitting the
collinearity equation in the basis `(1,omega)` gives two quadratics in the first repair parameter:

```text
A*r^2+B*r+C=0,          D*r^2+E*r+F=0,                 (70)

A=u+a*delta,
B=k0+delta*b+delta^2+u^2,
D=delta*(1+a)+a*u,
E=k1+delta*b+delta^2+a*u^2,

C=e*k1+delta*(c1+g1)+t*(k0+delta^2)+u*(c0+g0)
  +e^2*delta+e*delta^2+u*e*b+u*e^2+u*t^2+u^2*t+a*e*u^2,

F=e*(k0+k1)+delta*(c0+c1+g0+g1)+t*k1+u*(c1+g1)
  +t*delta^2+t^2*delta+u*e*b+u*e^2+u*t*b
  +u^2*e+a*e*u^2+a*t*u^2.                              (71)
```

The two leading coefficients never vanish together on the intended locus: `A=D=0` would imply
`delta*(a^2+a+1)=0`.  Thus the Sylvester determinant has no universal root at `r=infinity`.  Its
exact form is

```text
R(u,t)=A^2*F^2+A*B*E*F+A*C*E^2
       +B^2*D*F+B*C*D*E+C^2*D^2.                       (72)
```

As a coefficient-parametric polynomial, (72) has `452` terms, degrees six in `u` and four in `t`,
and total `(u,t)` degree eight, with unique top form `a^2*u^4*t^4`.  More importantly, it retains
the rational repair parameter rather than merely detecting a geometric common root.  Put

```text
H=D*B+A*E,              J=D*C+A*F.                      (73)
```

On `H!=0`, (72) vanishes exactly when the unique common root is `r=J/H`, which already lies in the
base field.  The identities

```text
A*J^2+B*H*J+C*H^2=A*R,
D*J^2+E*H*J+F*H^2=D*R                                (74)
```

prove this without a root extension.  On `H=0`, equation `R=0` forces `J=0`; there the quadratics
share their full gcd and one must separately ask whether that quadratic splits over the base field.
Consequently the remaining seed--cross-repair arc gate is exactly the rational-point problem for
the coefficient-parametric bidegree-`(6,4)` curve (72), plus the explicit split test on `H=J=0`.
The checker derives (70)--(71) from the universal height-interpolation identity, verifies
(72)--(74) as polynomial identities in characteristic two, and compares `24,576` cases with direct
projective incidence over `GF(64)/GF(8)`.

This is a reduction, not yet an obstruction.  Before affine coverage, classify the geometric
components and arithmetic Frobenius classes of (72) under both oriented cross-repair trace-one
conditions (69), including the `H=J=0` locus.  A component or Frobenius coset with no rational
collision could preserve the two-coset route; otherwise Lang--Weil/Chebotarev closes its arc gate.

Reproduction:

```text
python3 papers/arcs_complete_outside_conic/analyze_c210_seed_cross_repair_curve.py
```

Frozen output:
`papers/arcs_complete_outside_conic/analyze_c210_seed_cross_repair_curve_output.txt`.

```text
2518e3b1366a2e1023c85ea0a75b225d1f3d546e7f6da726996544bc9d04c334  analyze_c210_seed_cross_repair_curve.py
5098b20640fd7b53169aafb270facaf42bcbe0fa92cda7279c6f9c263be17332  analyze_c210_seed_cross_repair_curve_output.txt
```

## Cross-lane imports worth retaining

The current resultant-curve gate remains first.  Recent results in other lanes do not classify
(72), but two of them suggest the strongest route from ansatz-by-ansatz failures to a broader C210
obstruction.

### Exact defect accounting from the Baer lane

[C135](2026-07-14-c135-baer-inverse-equality.md) proves an exact balance in which first-order
capacity excess is precisely invisible orbit mass plus collision redundancy.  C210 has the same
structural pieces: secants are the available capacity, points hit by no secant are invisible mass,
and repeated secants through one external point waste capacity.  The appropriate transplant is an
exact carrierwise identity on the external fibers of extended Baer lines, separating

```text
required external points missed
  = nominal pair capacity lost to the conic
    + invisible-fiber mass
    + repeated-hit redundancy.                                (75)
```

This should refine, not merely restate, the global secant-count lower bound.  A useful theorem must
couple the two correction terms using the Baer-fiber or trace geometry; an unstructured first- or
second-moment inequality is not enough.
[C150](2026-07-14-c150-q25-multiplicity-structure.md) is the explicit warning: in the
alternate-orbit problem, separate moment bounds on invisibility and collision redundancy missed
the sharp result because the needed information was their geometric coupling.

The bounded probe after the two-coset disposition is therefore: define the pair-intersection
charge map on each Baer-line fiber, derive the exact analogue of C135's balance, and test whether
the arc condition forces a positive linear coupling between invisible mass and collision
redundancy.  Promote this only if it yields a bound stronger than the existing global defect
inequality for `k=c*s`; do not open a moment census for its own sake.

### Secant-index hierarchy from C174

[C174](2026-07-14-c174-general-six-subset-identity.md) proves for every six-arc in every finite
projective plane that uncovered points trade exactly against triple concurrence of chords.  Its
reusable content is the inclusion--exclusion interface: coverage is determined by the external
secant-multiplicity distribution.  For C210, where `k=Theta(s)` rather than six, higher concurrence
moments enter and the six-arc closed formula does not transfer directly.  It can nevertheless
supply the local algebra behind (75): organize each fiber's covered-point indicator through
factorial moments of its secant multiplicities, then seek an arc- or trace-specific bound on the
resulting collision terms.

The Baer identity and C174 hierarchy should be developed together if the current two-coset route
closes.  Separately, each is too coarse: C135 supplies the right defect decomposition but not the
C210 geometry, while C174 supplies exact multiplicity accounting but no asymptotic control of the
higher moments.

### Lower-priority transplants and stop conditions

- The Baer/alternate-orbit robust-exchange theorems suggest a different construction architecture:
  begin with a high-coverage set and exchange Frobenius pairs to remove collisions.  Do not promote
  it until one bounded test shows an exchange invariant or monotone potential that preserves
  off-conic coverage; abundant legal replacements alone are insufficient.
- RepairCodes transfer preserves complete bounded repair patterns inside concatenated codes, but
  it does not preserve rank three, a projective plane, or one prescribed conic.  It is not a direct
  finite-seed-to-C210-family theorem without a new geometry-preserving transfer statement.
- The rp-next separator-response algebra becomes relevant only if a future construction splits
  into bounded-interface Baer fibers or cosets.  The present quadratic layers are globally coupled
  by field equations.  Sequential Horn closure must not replace C210's one-secant coverage rule.
- Clebsch-style orbit and coherent-configuration methods may explain exceptional small fields or
  reduce a finite coefficient classification.  They do not by themselves control the infinite
  asymptotic scale.

Thus the post-two-coset conceptual fallback is not another repair polynomial or larger census.  It
is the combined Baer/C174 question: can the arc condition force enough repeated-hit redundancy or
invisible-fiber mass that `Theta(s)` selected points cannot cover every required fiber at the
counting threshold?
