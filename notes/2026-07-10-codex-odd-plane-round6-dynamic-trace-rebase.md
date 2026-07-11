# Odd projective cap game — Codex round 6: dynamic trace contraction and rebase rigidity

**Date:** 2026-07-10
**Scope:** three independent delegates plus root audit; committed q<=19 artifacts only; no q=25
work; no complete proof claimed.  Run every reproduction command below from `rust/`.

## Executive result

Round 5 left a narrow-looking request: append the smallest old-trace bit that splits the sole
q=11 live-cover P/N collision while retaining genuine compression.  Round 6 proves that this
literal request is impossible and replaces it with a dynamic target.

1. **[PROVED] Exact raw-trace contraction.** If `R_T` retains every rank-1, rank-2, and rank-3
   residue of a collinear triple against the selected cap `T`, then legal extension is exactly
   associative hypergraph contraction:

   ```text
   R_(T union A) = R_T / A.
   ```

   This gives a complete, value-blind update law for old deletions, pair constraints, and new
   secants.  It is full information, not yet a proof compression.
2. **[PROVED] Relative gain/phase form.** Once the live two-cover is fixed, trace ambiguity is a
   relative `H^1` class plus the marked-lift phases.  Rank-three trace rows are indispensable;
   live voltage plus pair attachments is not autonomous under a move.
3. **[PROVED / COMPUTED-EXACT] First free-fiber attachment bit.** The first switching-invariant free-trace datum is
   `tau(v)`, the parity of deleted opposite-side fibers joined to live fiber `v` by both gains.
   Each contribution is an unbalanced quotient 2-cycle.  `tau` has an explicit affine formula and
   separates q=11 `a=9` from `a=5`.
4. **[PROVED / COMPUTED-EXACT] Augmentation trap.** The q=11 live partition has exactly one block
   meeting two PGL cap orbits, and it is exactly the sole mixed P/N block.  Therefore *every*
   value-homogeneous refinement formed by appending trace bits necessarily refines the PGL orbit
   partition.  A complete static “live signature plus bits” cannot both separate values and retain
   cross-orbit compression.
5. **[REFUTED]** Two natural partial Good predicates were frozen and killed.  The polarity bit
   fails at q=13 and has no q=17 coverage.  Integer trace-overlap asymmetry passes q=11 and q=13
   but includes 60 N incidences at q=17.
6. **[PROVED] PGL rebase rigidity.** For an eight-cap and q>=23, every fixed-point-free-on-the-live-
   game PGL involution preserving the continuation clutter stabilizes the selected cap and is a
   homology with exactly two fixed selected points.  It therefore recreates exactly two defect
   lines.  Rebasing can relocate the DSC state; it cannot remove it.
7. **[COMPUTED-EXACT]** Every legal cross-defect pair in both members of the q=11 P/N collision has
   exactly one cap-stabilizing two-defect rebase.  “A rebase exists” is not a Good certificate.

The best new frontier is consequently not a static invariant.  It is a **dynamic semiconjugacy**:
find a proper projection `Q(R_T)` such that contraction, optionally followed by the explicit
homology rebase, induces an autonomous update on `Q`; then prove a value-blind Good-restoring reply
and terminal SG-zero argument.  This is a materially narrower obligation than “choose a P reply,”
but it remains open.

No new q=25 status was consumed and no census process was started.

## 1. Raw trace hypergraph

Let `Omega=PG(2,q)`, let `C` be the set of all collinear three-subsets of `Omega`, and let `T` be a
selected cap.  Define the **unminimized trace hypergraph**

```text
R_T = { e \ T : e in C }
```

on `Omega\T`.  It is intentionally a hypergraph rather than a clutter:

- a rank-1 row is an old deleted point, witnessed by two selected points;
- a rank-2 row is a future incompatibility witnessed by one selected point;
- a rank-3 row is a collinear triple disjoint from `T`.

Dominated rows are retained.  Deleting loop vertices and then minimizing recovers the ordinary
continuation clutter `H_T`, but minimizing at the outset would erase the attachment data this
round needs.

### Theorem 1 — exact associative contraction

**[PROVED]** If `A subset Omega\T` is a legal extension, then

```text
R_(T union A) = R_T / A := { r \ A : r in R_T }.
```

No empty row occurs.

**Proof.** For every collinear triple `e`,

```text
e \ (T union A) = (e \ T) \ A.
```

These identities give equality of the two row families.  An empty residue would mean a collinear
triple lies in the cap `T union A`, contrary to legality.  Set deletion is associative, so the
update is associative. `square`

This is the exact update theorem missing from the round-5 discussion.  It contains no P/N value.
It also explains why a rank-two signed graph was never dynamically closed: selecting one point of
a rank-three row turns that row into a new rank-two constraint, and selecting two turns it into a
new deletion.

### 1.1 Geometric attachment update

For `p` outside the selected extension, put

```text
I_T(p) = {v in V_T : line(p,v) meets T},
J_p(x) = (line(p,x) intersect V_T) \ {p,x}.
```

For a legal pair `A={x,y}`, the new live set is exactly

```text
V'={v in V_T\{x,y} :
    v notin I_T(x) union I_T(y), and v notin line(x,y)}.
```

For every old or newly deleted `p` not in `T union A`,

```text
I_(T union A)(p) intersect V'
  = V' intersect ( I_T(p) union J_p(x) union J_p(y) ).
```

**[PROVED]** The first formula lists exactly the three ways `v` can form a new collinear triple:
with `x` and an old selected point, with `y` and an old selected point, or with both `x,y`.  The
second formula says that `p,v` become incompatible either through an old selected point or through
new selected `x` or `y`.  Both follow directly from the cap rule.

This supplies an exact local update for trace-attachment rows.  A projected statistic is useful
only if these unions and restrictions can be computed from the projection itself.

## 2. Relative `C_2` gain and pointed contraction

At a symmetric `d=4` checkpoint, `sigma R_T=R_T`.  On the free part, choose point and row lifts as
in round 5 and let `B` be the quotient incidence graph.  Let `B_L` denote the sub-incidence graph
retained by the live cover.

### Theorem 2 — location of the missing trace class

**[PROVED]** After fixing the live-cover switching class, the remaining gain ambiguity lies in

```text
ker( H^1(B;F_2) -> H^1(B_L;F_2) ),
```

which is the image of relative `H^1(B,B_L;F_2)`.  The quotient incidence base and fixed/branched
rows must still be recorded; cohomology does not encode their multiplicities or supports.

This is the standard exactness statement for the cochain restriction sequence, applied to the
gain labeling.  It identifies the old trace as a *relative* voltage extension of the live cover.

If a marked lift is `x_s`, the lifted row `e_t` containing it satisfies

```text
t = s + gamma(x,e),
```

and a surviving incidence at `w` has sheet

```text
s + gamma(x,e) + gamma(w,e).
```

Two marks `x_s,y_r` lie in the same lifted row exactly when

```text
s+r = gamma(x,e)+gamma(y,e).
```

These formulas prove the pointed phase update under Theorem 1.  One mark lowers a rank-three row
to rank two; two marks lower it to a singleton.  A fixed fiber edge `{v_+,v_-}` contracts after
selecting `v_s` to the singleton `v_(1-s)`, which is the exact deck-mate deletion.

An invariant rank-three trace row may contain a fixed deleted point plus a free fiber.  It is
branched trace data and is not represented by ordinary unbranched cycle voltage.  This is another
reason the full update cannot be reduced to the live signed graph alone.

## 3. The first free-fiber switching-invariant attachment bit

Let `v` be a live `sigma`-fiber.  For each deleted fiber `w` on the opposite defect line, inspect
the two possible quotient gains between `v` and `w`.

### Definition

```text
tau(v) = parity of deleted opposite-side fibers w
         for which both gain 0 and gain 1 occur between v and w.
```

The two parallel quotient edges form a length-two cycle of voltage one.  Switching at either
endpoint toggles both edge signs and preserves their difference.  A single edge sign is not
switching-invariant, so this is the first voltage-bearing datum in the cycle-length filtration
that attaches one live fiber to one free trace fiber.  Fixed/branched trace rows remain separate,
as in Section 2.

### 3.1 Explicit affine formula

Use `U={+/-r,+/-s}`, `x_b=(0:b:1)`, and `y_d=(-a:d:1)`.  For `u in U`, put

```text
alpha_u=(a+u^2)/u^2.
```

The cross-defect blocker through selected `C(u)` is

```text
d = alpha_u b - a/u,
```

and inversely

```text
b = (d+a/u)/alpha_u.
```

These follow by expanding `det(x_b,y_d,C(u))=0`.

The old free trace coordinates are

```text
Delta_a = {(uv-a)/(u+v) : u,v in {0} union U,
           u!=v, u+v!=0} \ {0},

Delta_0 = {uv/(u+v) : u,v in {0} union U,
           u!=v, u+v!=0}
          union {au/(a+u^2) : u in U} \ {0}.
```

Thus `tau_0(b)` is the parity of opposite pairs `{z,-z}` contained in

```text
{alpha_u b-a/u : u in U} intersect Delta_a,
```

and `tau_a(d)` is the dual count in

```text
{(d+a/u)/alpha_u : u in U} intersect Delta_0.
```

The diagnostic independently checks these affine formulas against projective incidence for every
tested center.

### 3.2 Exact q=11 collision

For `U={+/-1,+/-4}`:

```text
a=9: (tau_D0,tau_Da)=(0,1)
a=5: (tau_D0,tau_Da)=(1,1).
```

The `a=5` D0 blockers contain the opposite deleted pair `{4,7}`; the `a=9` blockers contain no
such pair.  This is the first label-free cohomological distinction between the two live-isomorphic
positions.

```sh
python3 scripts/r6_attachment_bit.py
```

```text
q=11 tau_classes=8  cap_orbits=6  max_cap_orbits_per_tau=1 mixed_tau_classes=0
     collision a=9 colors=[('0',0),('0',0),('a',1),('a',1)]
     collision a=5 colors=[('0',1),('0',1),('a',1),('a',1)]
     collision_tau_isomorphic=NO
q=13 tau_classes=10 cap_orbits=10 max_cap_orbits_per_tau=2 multi_cap_tau=2
     mixed_tau_classes=0 mixed_tau_profiles=1
q=17 tau_classes=24 cap_orbits=20 max_cap_orbits_per_tau=1
     mixed_tau_classes=0 mixed_tau_profiles=6
```

Here a `tau_class` is the exact live signed graph with each live vertex additionally colored by
`tau`; a `tau_profile` forgets the graph and keeps only the sidewise bit multisets.  At q=11 and
q=17 the augmented exact class refines PGL type.  At q=13 it retains two cross-orbit merges, but
purity at three fixed primes is not a value theorem.

### 3.3 A strict but nonautonomous intermediate

For each deleted boundary point `p`, let its attachment row be

```text
A_T(p)=I_T(p) intersect L_boundary,
```

and define

```text
mu(T)=#{p : A_T(p)=L_boundary}.
```

For the collision, `mu(a=9)=3` and `mu(a=5)=5`.  Across all q=11 `d=4` maximum-pencil
incidences, the live cover has six classes, `(live,mu)` has seven, and the full trace signature has
eight.  It is a genuine strict intermediate representation.

However, `mu` is not autonomous under the update in Section 1: the new sets `J_p(x),J_p(y)` cannot
be recovered from `mu`.  Its q=11 value-purity is also subject to the augmentation trap below.

## 4. The augmentation trap

Let `L` be the partition of marked q=11 incidences by exact live-cover isomorphism and `O` the
partition by full `PGL(3,11)` six-cap orbit.  The exact contingency table is:

```text
L0: orbit 1, P (6)
L1: orbit 2, N (6); orbit 4, P (16)
L2: orbit 0, P (6)
L3: orbit 1, P (10)
L4: orbit 5, P (10 incidences, 2 distinct children)
L5: orbit 3, N (10)
```

Hence `L1` is both the only live block meeting multiple PGL orbits and the only mixed-value live
block.

### Theorem 3 — no compressive monotone completion

**[PROVED / COMPUTED-EXACT HYPOTHESIS]** Let `F` be any refinement of `L`, for example
`F=(live signature, extra trace data)`.  If every `F` block is P/N-homogeneous, then every `F`
block lies inside one PGL orbit.  Thus `F` refines `O`.

**Proof.** Every `L` block other than `L1` already lies in one `O` block, so all its refinements do
also.  Inside `L1`, the two `O` pieces have opposite values.  A value-homogeneous `F` block cannot
meet both, so it too lies in one `O` block. `square`

Reproduction:

```sh
python3 scripts/r6_partition_lattice.py
```

```text
q=11 incidences=64 live_blocks=6 pgl_orbits=6
multi_orbit_live_blocks=[1]
mixed_value_live_blocks=[1]
THEOREM_INPUT sole_multi_orbit_block_is_sole_mixed_block=YES
```

This formally closes the round-5 request if interpreted as “keep appending bits until the static
classes determine value.”  A useful object must instead be one of:

- a partial Good certificate that leaves most states unclassified;
- a dynamic response relation rather than a value partition;
- a cross-cutting quotient that deliberately forgets some live-cover distinctions while adding
  trace information.

`tau` and `mu` remain legitimate move-local inputs, but their q=11 separation is not evidence for
a new complete classifier.

## 5. Two frozen partial-Good candidates

The root tested exactly two theorem-derived candidates and stopped after their first failures.

### 5.1 Polarity character

Round 4 gave

```text
rhohat=(a+2bd)^2 / (16 b^2 (d^2+a)).
```

For nonzero terms,

```text
chi(rhohat)=chi(d^2+a).
```

The frozen predicate `POLAR_GOOD` required every live `y_d` to have `chi(d^2+a)=+1`.  It separates
q=11 `a=9` from `a=5`, is P-sufficient and covers every marked line at q=11, but fails immediately:

- q=13: 12 P and **9 N** incidences satisfy it; three marked lines have no such center;
- q=17: no incidence satisfies it, so all 21 marked lines are uncovered.

### 5.2 Integer trace-overlap asymmetry

For each live fiber, count deleted vertices adjacent to both lifts, and compare the sidewise
multisets on `D_0,D_a`.  The collision profiles are

```text
a=9: ((9),(11))
a=5: ((11),(11)).
```

The frozen predicate `OVERLAP_GOOD` required the two side profiles to differ.  It is P-sufficient
and covers every marked line at q=11 and q=13.  At q=17 it contains **60 N** and 48 P incidences;
the first counterexample is class 0, line `(15,11)`, cell `(5,6)`, normalized `a=5`.

```sh
python3 scripts/r6_attachment_kills.py
```

```text
q=11 POLAR GOOD P=36,N=0 coverage PASS; OVERLAP GOOD P=38,N=0 coverage PASS
q=13 POLAR GOOD P=12,N=9 coverage FAIL; OVERLAP GOOD P=63,N=0 coverage PASS
q=17 POLAR GOOD empty coverage FAIL; OVERLAP GOOD P=48,N=60 coverage PASS
```

These are exact falsifiers, not invitations to combine features.  The q-sensitive failure of the
integer overlap is precisely why the next target is its contraction law, not a larger static
threshold.

## 6. Projective rebase rigidity

After a legal boundary pair, the selected set is an eight-cap `T`.  Call
`h in PGL(3,q)` a **residual rebase** if:

1. `h` has projective order two;
2. `h(H_T)=H_T`;
3. `h` has no fixed legal point.

### Theorem 4 — a large-q PGL rebase is another two-defect state

**[PROVED]** For q>=23, every residual rebase:

1. stabilizes `T` setwise;
2. is a homology;
3. fixes exactly two selected points `A,B`, both on its axis;
4. swaps the remaining six selected points in three pairs whose chords concur at its center `c`;
5. has exactly two possible fixed-fiber obstruction lines, `cA` and `cB`.

**Proof.**

First reconstruct `T`.  Through any `t in T` there are `q-6` tangent lines.  On a tangent, at most
`C(7,2)=21` points are deleted by secants among `T\{t}`; after removing `t`, at least `q-21>=2`
points remain legal.  Any two exhibit a binary edge of `H_T`.  A clutter-preserving projectivity
maps the `q-6>8` distinct tangents through `t` to distinct lines through `h(t)`, each containing a
selected point.  If `h(t)` were outside `T`, eight selected points could support at most eight such
lines.  Therefore `h(t) in T`, for every `t`, and `h(T)=T`.

For a projective involution choose a representative `M` with `M^2=lambda I`.  Since
`det(M)^2=lambda^3`, the quadratic character of `lambda` is positive; rescale so `M^2=I`.
In odd characteristic `M` diagonalizes with eigenspaces of dimensions one and two, so a nonidentity
involution is a homology with a center and axis.

Its permutation on eight selected points has an even number of fixed points.  A cap meets the
fixed axis-plus-center in at most three points, so the number is zero or two.  A selected center is
impossible: it lies on every transposed pair-chord and would form a selected collinear triple.
The zero-fixed case is excluded for q>=23 by the 16-point axis bound in Section 6.1.  Thus
`A,B` lie on the axis.  Their secant blocks the full axis; the three
pair-chords block the center.  Among lines through `c`, the only lines containing exactly one
selected fixed point are `cA,cB`; they are exactly the two possible defect lines. `square`

### 6.1 Why a zero-defect PGL rebase cannot work

**[PROVED]** Suppose a homology stabilizes an eight-cap and acts freely on it.  Its four transposed
pair-chords meet the axis in at most four blocked points.  The remaining 24 secants form 12
homology-pairs; each pair meets at one axis point.  Hence at most

```text
4+12=16
```

axis points are blocked.  For q>=17 the axis has at least 18 points, so it contains a legal fixed
point.  Such a homology cannot be a global mirror.

For q>=23, Theorem 4 proves that every PGL residual rebase stabilizes the cap, so the zero-defect
case is excluded unconditionally there.  At q=17,19 the counting statement applies to homologies
already known to stabilize `T`; the tangent reconstruction bound was not claimed at those orders.

This theorem covers PGL projectivities over every odd field.  Semilinear `PGammaL` involutions with
nontrivial Frobenius part remain a separate square-order gap.

## 7. Exact algebraic rebase test and q=11 audit

Choose proposed fixed points `A,B in T` and pair the remaining six as `(P_i,Q_i)`, `i=1,2,3`.  Put

```text
ell=A cross B,
c=(P_1 cross Q_1) cross (P_2 cross Q_2).
```

When `ell(c)!=0`, define the projective reflection

```text
K=ell(c) I - 2 c ell.
```

It fixes the axis `ell`, fixes center `c` projectively, and has projective order two.  There is a
unique homology with the proposed action exactly when

```text
K P_i cross Q_i = 0,  i=1,2,3.
```

Thus a type-(two fixed, three swapped) rebase is decided by

```text
C(8,2) * 15 = 420
```

value-blind polynomial tests.

Only after freezing this family, the q=11 collision was audited.  Each center has two legal
cross-defect pairs.  Every resulting eight-cap has exactly one nonidentity **cap-stabilizing** PGL
involution, always of the two-fixed/three-swapped type, with no legal fixed point.  No free-on-`T`
cap-stabilizing involution exists.  At q=11 the large-q tangent argument does not rule out an
additional residual-clutter automorphism that fails to stabilize `T`; the finite audit makes no
claim about that separate possibility.

```sh
python3 scripts/r6_rebase_audit.py
```

```text
permutations total=525 free_on_T=105 two_fixed=420
a=9 compatible=((3,8),(8,3)): each has rebases=1, free_on_T=0, legal_fixed=0
a=5 compatible=((3,10),(8,1)): each has rebases=1, free_on_T=0, legal_fixed=0
SUMMARY cases=4 unique_rebases=4 free_on_T_rebases=0 all_assertions=PASS
```

The script checks cap legality, exact four-frame reconstruction, the action on all eight points,
projective order two, fixed loci, and the complete 525-permutation family.

**[REFUTED]** Cap-stabilizing rebase existence does not distinguish the P and N members of the collision.  A
rebase is a gauge transition between two two-defect descriptions, not a P certificate.

## 8. Exact remaining gap

The full raw trace `R_T` has a perfect update but essentially full information.  The strict
statistics `tau` and `mu` lose information needed to evaluate the unions `J_p(x),J_p(y)`.  Static
augmentation is blocked by Theorem 3, and projective rebasing only changes gauge.

The next sufficient lemma must therefore have the following form.

### Dynamic projected-contraction lemma

Find a value-blind projection `Q` of the marked relative trace hypergraph such that:

1. **properness:** `Q` does not determine the PGL cap orbit;
2. **autonomy:** for every legal marked move or pair, `Q(R_T/A)` is determined by `Q(R_T)` and the
   projected move data, possibly after one of the 420 explicit rebases;
3. **reply closure:** from every Good `Q`-state and every opponent move, an algebraic legal reply
   restores Good;
4. **base:** terminal or mirrorable Good states have SG zero by a direct argument;
5. **entry:** every required `d=4` frame has a child in Good.

This is not equivalent to “choose a P reply.”  It specifies a finite algebraic semiconjugacy of
the exact contraction dynamics and requires a separate SG-zero base theorem.

The first kill test is also exact: freeze `Q`, then find two marked states with equal `Q`.  If the
same projected move data produces unequal contracted `Q` states, autonomy fails before labels are
consulted.  Any survivor must then face q=11, q=13, and q=17 forced/mixed transition corpora.

The statement remains local to the `d=4` DSC phase.  The separate `d=5` root lane and the final
connection to the S3-to-P-child theorem remain necessary for a complete odd-plane proof.

## 9. Approach registry

| family | exact target | strongest result | blocker | weaker than theorem? | next kill test |
|---|---|---|---|---|---|
| Raw trace hypergraph | Make old trace update exact | `R_(T union A)=R_T/A` | Full rank-three information is essentially the original geometry | Yes | Project a named row family and test autonomy under every q=11 boundary pair |
| Relative gain cohomology | Locate trace beyond live voltage | Missing class lies in relative `H^1`; pointed sheets update explicitly | Incidence supports/multiplicities and branched rows remain | Yes | Equal projected relative class must imply equal projected contractions |
| Shortest-cycle bit `tau` | First switching-invariant trace phase | Explicit affine formula; separates collision | Static augmentation hits PGL trap; profile alone mixes values | Yes | Use only in a frozen move/rebase transition law |
| Universal-row count `mu` | Strict intermediate trace summary | q=11 live+`mu` has 7 classes between 6 and 8 | Not autonomous under new pencil rows | Yes | Produce two equal-`mu` states with different contracted `mu`, or prove closure for a restricted row family |
| Static augmentation of the q=11 live signature | Complete value coordinate | Exact q=11 partition theorem | Any q=11 value-pure refinement refines PGL | This monotone q=11 route is closed; q=13 does admit pure cross-orbit `tau` classes | Do not infer a cross-q no-go; require a uniform mechanism and the autonomy test |
| Polarity character | Partial Good class | Perfect q=11 | q=13 N counterexamples; q=17 empty | Route closed in this form | None |
| Overlap asymmetry | Partial Good class | Perfect q=11/q=13 | 60 q=17 N incidences | Route closed in this form | None |
| PGL rebase | Escape broken homology | q>=23 rebases classified; 420 polynomial test | Always another two-defect state; cap-stabilizing existence shared by q=11 P/N | Yes, as gauge tool | Compose the exact rebase with `tau`/row update, then test autonomy |
| Semilinear rebase | Cover square-order automorphisms | Not addressed | Frobenius fixed locus is not axis+center | Yes | Derive a Baer-subplane fixed-point obstruction before any q=25 label query |

## 10. Recommended next round

### Route A — primary: contraction semiconjugacy in rebase gauge

**High/Ultra proof delegate.** Choose a small, geometrically specified family of trace rows—start
with the unbalanced 2-cycles counted by `tau` plus the rank-three rows incident with the proposed
opponent/reply fibers.  Derive its exact update from Theorem 1.  Then conjugate by the unique
type-(two fixed, three swapped) rebase and determine whether the result closes on a bounded tuple.
The first algebraic test is especially concrete: the q=11 cycle structures show that the rebase
absorbs the just-played pair into a new five-point frame.  Compute the new normalized `(r',s',a')`
and decide whether rebase-conjugated contraction is literally the round-4 four-generator Möbius
system with those new parameters.  If so, autonomy reduces to a finite rational identity rather
than an open-ended state search.

**Medium exact delegate.** Before labels, enumerate every legal boundary pair in q=11 and q=13 and
test the autonomy equation.  Use q=17 only on a survivor.  Do not score classification accuracy.

**Success gate:** a proper quotient that merges distinct PGL orbits and has a proved autonomous
transition, followed by at least one explicit Good-restoring response identity.  **Failure gate:**
equal quotient states have unequal quotient contractions, the tuple reconstructs PGL type, or the
same declared Good transition occurs in the q=11 N collision member.

**Estimated cost:** 30–40 high-reasoning minutes plus 12–18 medium replay minutes; no solve and
well below 1 GB.

### Route B — secondary: semilinear rebase rigidity

**High finite-geometry delegate.** Extend Theorem 4 from PGL to involutions in `PGammaL(3,q)` with
nontrivial Frobenius part.  Determine whether an eight-cap-stabilizing semilinear involution can
have its Baer fixed subgeometry entirely blocked by the 28 secants.  The target is a theorem or a
sharp character/extension-degree exception list, not a q=25 census.

**Medium literature delegate.** Search only for an exact theorem on fixed structures of semilinear
involutions and intersections of arcs/secants with Baer subplanes.  Return hypotheses and the
precise translation.

**Success gate:** every large odd square-order rebase either has a legal fixed point or reduces to
a controlled defect geometry.  **Failure gate:** an explicit eight-cap and semilinear involution
with fully blocked fixed subgeometry.

**Estimated cost:** 25–35 high-reasoning minutes plus 10–15 literature minutes.  No q=25 labels
are needed.

The sub-agent launcher again exposed no model/effort selector.  The roles above and in this round
are task-depth descriptions only; no product-level effort change is claimed.

## 11. Circularity and scope audit

- The raw-trace, relative-cohomology, `tau`, and rebase formulas use no game value.
- The q=11 partition statement joins labels only after the live and PGL partitions are fixed.
- `tau` purity at q=11,13,17 is not promoted to a theorem; at q=11 it is explicitly identified as
  the unavoidable PGL-refinement trap.
- The polarity and overlap predicates were frozen before labels and stopped at their first stated
  counterexamples.  No feature combination was searched.
- `mu` is called an intermediate statistic, not an autonomous state or P certificate.
- Full `R_T` is acknowledged as full information; exact contraction alone is not called a proof
  compression.
- A legal rebase and a legal reply are never called winning.  Rebase existence is explicitly
  refuted as a value discriminator by the q=11 P/N pair.
- The tangent reconstruction theorem assumes an eight-cap and q>=23.  The q>=17 axis count is only
  applied after cap stabilization/free action is known.
- PGL rigidity is not silently extended to semilinear square-order involutions.
- Prime-field scripts q=11,13,17 do not establish an all-prime-power law.
- Fixed-q PGL orbit purity is not used as cross-q transport.
- `(ON)`, q=25 `min-witness>=4`, and the running q=25 census are unused.
- No missing early-break entry is assigned a value and no new game solve was launched.
- The result narrows the `d=4` strategy mechanism; it does not prove `(ON)` or the main theorem.

## 12. Files produced

- `notes/2026-07-10-codex-odd-plane-round6-dynamic-trace-rebase.md` — this report.
- `rust/scripts/r6_partition_lattice.py` — exact q=11 augmentation-trap table.
- `rust/scripts/r6_attachment_bit.py` — affine/incidence verification of `tau` and cohort audit.
- `rust/scripts/r6_attachment_kills.py` — frozen polarity/overlap kills and `mu` table.
- `rust/scripts/r6_rebase_audit.py` — exhaustive q=11 525-permutation PGL rebase audit.

All scripts are diagnostic and perform no new recursive game solve.

## 13. Independent round-6 verification (Claude, 2026-07-10)

**[INDEPENDENTLY VERIFIED]** Claude replayed all four scripts exactly and independently re-derived
`tau` from the affine formulas in Section 3.1, including the opposite deleted pair `{4,7}` for
q=11, `a=5`.  Theorems 1–4 were hand-checked, including tangent reconstruction, the square-
character rescaling of a projective involution, and the fact that paired secants meet at the same
axis point in the Section 6.1 count.  The augmentation theorem was checked against the replayed
contingency table.

The verification adds two scope/design points:

1. In every audited q=11 rebase, the cycle structure absorbs the newly played boundary pair into
   the frame—for example `(C0 x)(C1 za)(C-1 y)` with `C(+/-4)` fixed.  This motivates the explicit
   Möbius-generator conjugacy test added to Route A.
2. The augmentation trap is a theorem about refinements of the **q=11** live partition.  It is not
   a cross-q impossibility theorem: q=13 has two `tau` classes that merge PGL orbits while remaining
   value-pure in the finite data.  No such fixed-q purity is promoted to a game theorem.

No new literature trust-tier dependency was introduced.  The PGL/PΓL distinction remains
load-bearing at square orders, making the semilinear/Baer Route B genuinely separate rather than
optional cleanup.
