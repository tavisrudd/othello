# C302: carrierwise secant-defect equality and deletion stability

**Lane**: `relconic`

Date: 2026-07-18.

## Result

Coverage and collision removal admit one exact common ground set.  Let `V` be a finite selected
point set, with any layer coloring retained, and for every projective point `x` let `G_x(V)` be the
graph on vertex set `V\{x}` whose edges are the selected pairs whose joining line contains `x`.
Then

    x outside V is covered by V    iff E(G_x(V)) is nonempty;
    x outside V\D is uncovered     iff E(G_x(V)[V\D]) is empty.

Meanwhile `V\D` is an arc exactly when `D` meets every collinear selected triple.  Thus, on the
same layer-vertex ground set used by C298, a deletion set produces a collision-free set complete
outside prescribed holes exactly when

1. `D` is a transversal of the collision-triple hypergraph; and
2. `D` is not a vertex cover of `G_x(V)` for any old required point `x`, and every deleted
   selected point is covered by a pair of surviving vertices.

This is the consumer-ready collision/coverage interface for C303.  It separates two genuinely
different hitting problems rather than inferring coverage from the number of collisions.

For a carrier `C subseteq Pi\V`, put

    r(x) = |E(G_x(V))|,
    I_C  = sum_{x in C} r(x),
    E_C  = sum_{x in C} binom(r(x),2),
    T_C  = sum_{x in C, r(x)>0} binom(r(x)-1,2),
    U_C  = {x in C : r(x)=0}.

Here `I_C` is pair-incidence mass, `E_C` is repeated-hit collision energy, and `T_C` is the exact
higher-multiplicity correction.  Then

    |U_C| = |C| - I_C + E_C - T_C.                       (1)

If `V=A` is a `k`-arc and `m=floor(k/2)`, define the carrier defect

    D_C = sum_{x in C, r(x)>0} (r(x)-1)*(m-r(x)).

Since every `G_x(A)` is a matching and `r(x)<=m`, this is nonnegative and

    m*(I_C-|C\U_C|) = 2*E_C+D_C,                         (2)
    |U_C| = |C|-I_C+(2*E_C+D_C)/m.                       (3)

Summing (2) over carriers, with the analogous hole term, is exactly the prescribed-hole defect
identity in the relative-conic paper.  Formula (1) specializes at `k=6` to C174's chord-concurrency
identity.  On Baer external fibers it proves the exact all-or-nothing invisibility theorem for a
Baer-contained arc, while for transversal off-Baer secants it identifies `E_C-T_C` as precisely the
coverage lost to repeated values of the pair-intersection map.

Under deletion, write `r_D(x)=|E(G_x(V\D))|` and

    J_C(D)=sum_{x in C}(r(x)-r_D(x)).

The exact carrierwise loss is

    |U_C(V\D)|-|U_C(V)|
      = |{x in C : r(x)>0 and r_D(x)=0}|                 (4)
      = J_C(D)-[(E_C-T_C)-(E_C(D)-T_C(D))].              (5)

Equivalently, (4) counts the points whose support graph is vertex-covered by `D`.  If `V` is an
arc, `G_x(V)` is a matching, so its vertex-cover number is `r(x)`.  Consequently deletion of `d`
vertices cannot uncover any point with `r(x)>d`.  This is the promised quantitative stability
statement.

For either terminal star of C298, deleting its repair centre `v` removes all `q-1` certified
collision triples from that component.  Its coverage cost on a carrier is not `q-1`; it is exactly

    L_C(v)=|{x in C : E(G_x(V)) is nonempty
                       and every edge of G_x(V) contains v}|.              (6)

For the union of the two seed colors, let `D_*` be the at-most-two repair centres prescribed by
C298.  If the full configuration covers the old required locus, then the resulting collision-free
restriction is complete outside the prescribed holes if and only if

    L_C(D_*)=0 on every old required carrier, and
    E(G_v(V)[V\D_*]) is nonempty for every v in D_*.

Here `L_C(D_*)` is (4).  C298's star count supplies the collision transversal but no information
about these support graphs, so it cannot decide this condition by itself.  C303 must compute or
prove the carrierwise support condition; no broad coefficient census is licensed by C302.

## 1. Pair-support graphs

Let `Pi` be a projective plane and let `V` be any finite set of selected points.  No arc hypothesis
is imposed initially.  For every `x in Pi`, define

    E(G_x(V)) = {{a,b} subseteq V\{x} : a!=b and x lies on the line ab}.

The definition uses selected vertices, not uncolored geometric images.  In a layered construction
the vertex set is therefore the disjoint union of the layer-parameter classes, exactly as in C298.
When the layer maps are injective and disjoint, this agrees with the geometric point set.  Any
coincidence must instead be removed into the bad locus before using the interface.

The graph records all pair witnesses for coverage.  It may contain a clique when three or more
selected points lie with `x` on one line.  After all collinear selected triples are removed, every
line through `x` contains at most two selected points, so `G_x` is a matching.

### Proposition 1.1: simultaneous deletion criterion

Let `H` be a prescribed set of allowed holes disjoint from `V`, and put

    R = Pi \ (V union H).

Let `K(V)` be the 3-uniform hypergraph on `V` whose edges are the collinear selected triples.  For
any `D subseteq V`, the restriction `V\D` is an arc complete outside `H` if and only if

1. `D` meets every edge of `K(V)`; and
2. for every `x in R union D` the induced graph `G_x(V)[V\D]` has an edge.

#### Proof

The first condition says exactly that no collinear selected triple survives.  The points outside
`V\D` and outside `H` are precisely `R union D`.  Such a point `x` is covered after deletion exactly
when some pair `a,b in V\D` has `x` on `ab`, which says exactly that `G_x(V)[V\D]` has an edge.

For `x in R`, the second condition is equivalently that `D` is not a vertex cover of the old
required-point support graph.  For `x in D`, it is the additional requirement that the newly
required deleted point lie on a surviving secant.  Thus collision removal is a
hypergraph-transversal condition, while retained coverage is a simultaneous support-graph
condition on both old and newly required points.

## 2. Exact carrierwise energy

Let `C subseteq Pi\V` be any carrier.  Carriers need not be lines and need not form a geometric
partition for the local identity.  When they do partition a required locus, their identities add
without overlap.

For an integer `r>=1`,

    1 = r-binom(r,2)+binom(r-1,2).                       (7)

Summing (7) over the covered points of `C` gives

    |C\U_C| = I_C-E_C+T_C,

which is equivalent to (1).  In particular,

    E_C-T_C = sum_{x in C}(r(x)-1)_+                   (8)

is the exact redundant-incidence mass.  Collision energy `E_C` alone overcharges points of
multiplicity at least three; `T_C` is the necessary correction.  This is why a repeated constant
or a raw pair-collision count is not by itself a carrierwise theorem.

### Arc specialization

Suppose now that `V=A` is a `k`-arc and `m=floor(k/2)`.  At any `x notin A`, distinct secants through
`x` have disjoint endpoint pairs, so `G_x(A)` is a matching and `r(x)<=m`.  Pointwise,

    m*(r-1) = r*(r-1)+(r-1)*(m-r)
            = 2*binom(r,2)+(r-1)*(m-r).

Summing over the covered points of `C` proves (2), and substitution into

    |U_C|=|C|-I_C+sum_x(r(x)-1)_+

proves (3).  The carrier defect `D_C` vanishes exactly when every covered point of `C` has index
`1` or `m`.

If carriers `C_j` partition the required locus `Pi\(A union H)`, summing their `D_{C_j}` and adding

    Q_H=sum_{y in H} r(y)*(m-r(y))

gives

    m*Delta_H(A) = sum_j D_{C_j}+Q_H,                   (9)

where `Delta_H(A)` is the prescribed-hole defect from the paper.  Indeed, (9) is simply that
identity with its required-point sum partitioned by carriers.  It proves a local equality and not
merely the global `sqrt(2q)` capacity count.

Quantitative stability also localizes.  For `m>=3`, if

    M_C={x in C : 2<=r(x)<=m-1},

then

    (m-2)*|M_C| <= D_C.                                  (10)

If the carriers partition the required locus, their exceptional sets are disjoint and the bounds
sum exactly.  Thus a small global defect cannot hide many nonextremal repeated hits in one carrier.

## 3. C174 as the six-arc specialization

Let `A=H` be a six-arc and take the single carrier `C=Pi\H`.  Then `m=3`, there are fifteen chords,
and the classical first two secant-index equations give

    I_C=15*(q-1),             E_C=45.

Away from the arc, `r(x)<=3`, so

    T_C=|{x notin H : r(x)=3}|=c(H).

The ambient carrier has size `q^2+q+1-6`.  Formula (1) gives

    |U(H)|=q^2-14*q+55-c(H).

At each of the six selected vertices five chords concur, contributing `6*binom(5,3)=60` forced
triples, and every other triple concurrence is one of the `c(H)` points.  Hence

    t(H)=60+c(H),
    t(H)+|U(H)|=q^2-14*q+115,

which is exactly C174.  The concurrency correction is the higher-multiplicity term `T_C` in (1).

## 4. Baer fibers and transversal pair maps

Let the ambient plane have order `Q=s^2`, let `B` be a Baer subplane of order `s`, and let `A` be an
arc contained in `B`.  For each `B`-line `ell`, let

    F_ell = ell^E \ B

be the `s^2-s` external points of its ambient extension.  These fibers partition the complement of
`B`, and every external point lies on a unique extended `B`-line.

If `ell` is an `A`-secant, every point of `F_ell` has index one.  If it is not a secant, every point
has index zero.  Therefore

    (I_{F_ell},E_{F_ell},T_{F_ell},|U_{F_ell}|)
      = (s^2-s,0,0,0)       for a secant carrier,
      = (0,0,0,s^2-s)       otherwise.                  (11)

This is the exact Baer-fiber invisibility statement: repeated-hit energy vanishes, but every
nonsecant carrier is wholly invisible.  Summing (11) over the `s^2+s+1` `B`-lines recovers

    |U(A)\B|=(s^2+s+1-binom(|A|,2))*(s^2-s).

For an off-Baer construction, fix an external carrier on an extended `B`-line.  Every eligible
non-Baer secant is transversal to that carrier and contributes one pair-intersection value.  If
`P_ell` is the eligible pair domain, then `I_{F_ell}=|P_ell|`, and (1) becomes

    |U_{F_ell}|=|F_ell|-|P_ell|+E_{F_ell}-T_{F_ell}.      (12)

Thus pair capacity is the first term, while `E-T` is exactly the loss to repeated values.  Formula
(12), not the numerical comparison `binom(k,2) approximately |F_ell|`, is the carrierwise theorem
needed to test bounded-coset constructions.

## 5. Exact deletion stability

Let `D subseteq V`.  Put `r_D(x)=|E(G_x(V\D))|` and let all subscript-`D` carrier quantities be
computed from `r_D`.  The newly uncovered points are exactly

    L_C(D)={x in C : r(x)>0 and r_D(x)=0}.               (13)

This proves (4).  To prove (5), use the redundancy form (8).  Pointwise, if `r_D(x)>0`, the removed
incidence `r-r_D` is absorbed entirely by the drop in redundancy.  If `r_D(x)=0<r(x)`, that drop is
only `r-1`, leaving exactly one newly uncovered point.  Summation gives

    |L_C(D)|=J_C(D)-[(E_C-T_C)-(E_C(D)-T_C(D))].

Equivalently, (13) says `x` is newly uncovered precisely when `D` is a vertex cover of `G_x(V)`.
Writing `tau_x` for that graph's vertex-cover number gives the stability bound

    |D|<tau_x  implies x remains covered.                (14)

If `V` is an arc, `G_x(V)` is a matching of size `r(x)`, so `tau_x=r(x)`.  Therefore a deletion of
`d` selected vertices can newly uncover points only among those of original secant index at most
`d`:

    L_C(D) subseteq {x in C : 1<=r(x)<=d}.               (15)

This is sharp: choosing one endpoint from every edge of a support matching uncovers the point.

## 6. The C298 terminal stars

C298 uses the layer-vertex ground set

    V=T disjoint_union R disjoint_union S

for the seed parameter and the two repair parameters.  Its genuine collisions are hyperedges of
`K(V)`.  On either terminal overlap, all `q-1` collision edges from the surviving component share
one repair vertex `v`; deleting `v` is therefore a size-one transversal for that component.

The coverage cost is governed by the point-support graphs, not by the collision-edge count.  For
any carrier `C`, formula (13) specializes to

    |L_C({v})|
      = |{x in C : r(x)>0 and every edge of G_x(V) contains v}|,

which is (6).  For both seed colors, let `D_*` contain the at-most-two repair centres identified by
C298.  Then Proposition 1.1 gives the exact terminal-star gate:

    D_* hits the certified collision stars, and
    V\D_* retains relative completeness
      iff G_x(V)[V\D_*] has an edge for every required x.                 (16)

If the full configuration already covers every old required point, (16) is equivalently
`L_C(D_*)=0` on every old required carrier together with a surviving secant through each point of
`D_*`.  Since `|D_*|<=2`, any old required-point support graph with vertex-cover number at least
three is automatically safe.  Only old support graphs of cover number one or two, plus the deleted
centres themselves, need inspection.

C298 certifies neither these support graphs nor their vertex-cover numbers.  Its `q-1` star edges
may coexist with zero, bounded, or large coverage loss.  This is the precise reason C303 remains
gated on a coverage calculation even after the collision transversal is known.

## Consumer interface for C303

C303 should retain C298's vertices and produce, for each required carrier, one of the following
equivalent certificates:

- a surviving pair edge of `G_x(V)[V\D]` for every required `x`;
- a proof that `D` is not a vertex cover of any required support graph;
- the exact loss value `L_C(D)=0` from (4) or (5); or
- a uniform lower bound `tau_x>|D|` on the support-graph cover numbers.

In every formulation, “required” includes the deleted vertices themselves after deletion; the
carrier loss formulas cover the old required locus, and the deleted vertices require separate
surviving-secant witnesses.

For bounded-coset constructions, the transversal formula (12) additionally separates insufficient
pair mass from repeated-value loss.  A negative result must name the carrier and the exact support
graphs that become covered by `D`; a positive result must check every required carrier.  Collision
counts, matching numbers, and pair capacity alone are insufficient.

## Evidence boundary

This report is a direct combinatorial theorem and introduces no computation or generated artifact.
It consumes:

- the prescribed-hole identity and stability theorem in
  `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`;
- C174's six-arc chord-concurrency identity in
  [`2026-07-14-c174-general-six-subset-identity.md`](2026-07-14-c174-general-six-subset-identity.md);
- the Baer external-fiber partition in
  [`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md);
- C298's exact collision hypergraph and terminal stars in
  [`2026-07-18-c298-c210-robust-collision-matching.md`](2026-07-18-c298-c210-robust-collision-matching.md).

It does not prove that deleting the terminal star centres preserves relative completeness, that a
large collision-free partial domain exists, or that the omitted C297 moduli pass their seed--repair
gates.  Those are C303/C304 questions.  The new result is the exact equality and the necessary and
sufficient support-graph test, not a claim that the carrierwise `sqrt(2q)` count is new.

## Vibe check

This is a strong structural bridge.  It turns the vague tension between collision deletion and
coverage loss into two exact hitting conditions on one vertex set, localizes the paper's defect
identity to arbitrary carriers, and reduces the terminal-star question to support graphs of cover
number at most two.  It does not make C303 automatic, but it makes that task sharply finite and
auditable.
