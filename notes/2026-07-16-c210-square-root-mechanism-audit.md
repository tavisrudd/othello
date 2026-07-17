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
