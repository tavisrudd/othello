# C317: fiber geometry and post-C297 asymptotic dichotomy

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; the prescribed-target fibers are finite schemes with affine-line
translation factors, not positive-genus curves.  Fixed coefficients are collision-forcing after
an odd extension of relative degree at most five; fresh per-field coefficients remain behind an
exact simultaneous finite no-root gate.

## Result

Let `F=GF(2^n)`, with `n` odd and `Q=|F|>=32`, and let `E/F` and the marked two-repair family be as
in C297.  C313 and C315 reduce every internally, cross-repair, and seed--repair legal member to
C315's constant-height `E4` open

    c=K=1,                 B=0,

with parameters `(rho,P0,w,Gamma_alpha,Gamma_beta,H)`.  The linear-`p` stratum is empty.  For every
member of this `E4` open the following statements hold.

1. After quotienting the free simultaneous translation of the three selected affine parameters,
   each mixed-layer prescribed-target fiber is zero-dimensional.  Restoring translation makes
   every reduced closed point with residue field `L` into an affine line `A1_L`.  Its smooth
   projective completion is `P1_L`, has constant field `L` and genus zero, and loses exactly its
   point at infinity when returned to the affine collision incidence.
2. For each seed--seed--repair support, the reduced fiber is exactly the degree-five algebra

       F[p]/(E_SS(p)),

   where `E_SS` is C316 (31).  Its leading coefficient is `e_i^2!=0`, its value at `p=0` is
   nonzero, and `a` is reconstructed uniquely.  Thus it has an `F`-rational point exactly when
   `E_SS` has a linear factor over `F`.
3. If a seed--seed--repair fiber has no `F`-point, the factor-degree partition of `E_SS` is exactly
   `(5)` or `(3,2)`.  Consequently it acquires a rational point over an odd extension of relative
   degree `5` or `3`, respectively.  If it already has a linear factor, the relative degree is
   `1`.
4. Hence every fixed seed-legal `E4` configuration has a genuine mixed-layer collision after an
   odd scalar extension of relative degree in `{1,3,5}`.  Seed legality and all four nonzero-height
   opens persist under odd scalar extension, so no fixed configuration remains an arc throughout
   its odd scalar tower.
5. For coefficients chosen independently in each field, the theorem stops at an exact finite
   arithmetic gate: both degree-five polynomials must have factor type `(5)` or `(3,2)`, and both
   repair--repair--seed fibers must have no `F`-point.  No component, genus, or Hasse--Weil argument
   forces an `F`-point of a zero-dimensional fiber.  Existence of such simultaneous no-root seed
   pairs, followed by relative coverage, is the remaining construction-facing question.

This is a mixed bounded result.  It is a fixed-coefficient odd-tower obstruction on the whole
seed-legal constant-`p` family, but it is not a uniform per-field obstruction and not a global
nonexistence theorem for `C`-complete `O(sqrt(Q))` arcs.

## Why the expected curve theorem changes form

C316's unreduced incidence has dimension one over a fixed configuration and target only because

    (u,a,r) -> (u,a),              (p,a,t) -> (p,a)

forgets a free simultaneous translation.  Equations C316 (15) and (27) are inverse
reconstructions, so this is an actual affine-line factor, not a hidden collision parameter.  The
reduced maps have source and target both two-dimensional and are generically finite of degrees
`6,6,5,5`.  Therefore a prescribed-target reduced fiber has dimension zero.  The normalization,
constant-field, and genus data belong to the affine-line factors over its closed points:

| reduced closed point | unreduced component | constant field | genus | affine deletion |
|---|---|---|---:|---:|
| residue degree `r` | `A1_{GF(Q^r)}` | `GF(Q^r)` | `0` | one point at infinity |

Over an algebraic closure, Frobenius permutes the resulting projective lines exactly as it
permutes the reduced fiber points.  A Frobenius-fixed line exists exactly when the reduced fiber
has an `F`-point.  Hasse--Weil then counts `Q+1` points on a line that is already defined over `F`;
it cannot make a non-fixed line descend.  This is the zero-dimensional version of C301's
component-descent alternative.

Every affine point on such a line is genuine.  C316 proves that the three selected layers are
distinct affine cosets or distinct marked seed layers, and that the sole same-`x` seed case
`p=0` is collision-free.  Thus no repeated-point or reconstruction deletion is needed on an
affine-line component.  A component with constant field `L` supplies exactly `|L|` ordered
genuine collisions over `L`, and in particular a base-defined component supplies `Q` over `F`.

## Exact degree-five fiber theorem

For repair layer `i`, retain C316's notation

    Delta_S=Gamma_alpha+Gamma_beta,
    Z=Gamma_alpha+Delta_i,
    Delta_1=0,                    Delta_2=Delta_R.

The standing seed open gives `Delta_S notin F`, so its `omega`-coordinate `delta_1` is nonzero.
The `omega`-coordinate of the collision equation uniquely gives

    a=N/delta_1,

with `N` as in C316 (30).  Substitution gives C316's polynomial

    E_SS(p)=N^2*p+e_i^2*delta_1^2*p
      +(p^2+delta_0)*N*delta_1+e_i*delta_1^3
      +Z_0*delta_1^2*p.

It has degree five and leading coefficient `e_i^2`.  Moreover

    E_SS(0)=e_i*delta_1*Nm(Delta_S)!=0.

There is therefore no root introduced by clearing `p`, and the coordinate algebra of the reduced
fiber is exactly `F[p]/(E_SS)`.  Ramification is exactly the common-root scheme of `E_SS` and
C316's

    B_SS=p^4+delta_1*p^2+Nm(Delta_S).

It changes multiplicities but does not create a curve component or a reconstruction failure.

If `E_SS` has no linear factor, a degree-five factorization over `F` can only have irreducible
degree partition `(5)` or `(3,2)`.  Repeated factors cannot yield another partition without using
a linear factor.  An irreducible factor of odd degree `r in {3,5}` gives a closed point with
constant field `GF(Q^r)`, hence an affine collision line over that odd extension.  This proves the
fixed-coefficient theorem using either of the two degree-five supports; no information from the
degree-six maps is needed.

For an odd relative extension `F'/F`, absolute trace on an element of `F` is multiplied by the
odd relative degree and is therefore unchanged.  C315's trace-one seed conditions remain true;
the inequalities and the four deleted common-height sections remain deleted after base change.
Also `E intersect F'=F`, since the relative degrees `2` and odd are coprime, so
`Gamma_alpha+Gamma_beta notin F` remains outside `F'` and the two seed cosets stay distinct.
Thus the supplied collision occurs while the original configuration is still a legal member of
the same marked architecture.

## Repair--repair--seed fibers

For `Delta_R!=0`, use C316's two split-coordinate equations before the `S`-chart solve:

    y^2+A*y=Gamma_1,
    (y+1)^2+Bx*(y+1)=Gamma_2.

Their sum is `S*y=T`.  The reduced fiber is finite.  Away from `S=0`, `y=T/S` is unique.  At
`S=0`, compatibility requires `T=0`, after
which either original equation is still a monic quadratic in `y`, so it has length at most two.
Thus the alternate chart contains only isolated points.  Away from it, the exact degree-six
eliminant is C316's `F_RR=E_RR/D`; at `S=0`, one uses the original two equations and the
compatibility condition `T=0`.  The source pole divisor `D=x*(x+d)=0` is deleted.  It has no
odd-tower `F`-point because it is the split form of the norm
`u^2+d*u+d^2`, whose trace-one class has no root.

On `Delta_R=0`, equivalently `P0=d` and `w in {0,1}`, one has `S=d!=0`, and C316's solve gives an
exact quadratic with nonzero leading coefficient.  The reduced generic fiber has degree two; a
no-root fiber is one quadratic closed point, whose affine-line component has constant field
`GF(Q^2)`.  This lower-degree coincidence locus is retained and is not a deletion.

For the degree-six generic etale fiber, absence of an `F`-point permits exactly the Frobenius cycle
partitions

    (6),             (4,2),             (3,3),             (2,2,2).

Branch targets merge geometric points and are read scheme-theoretically from C316 (20a); the same
closed-point/constant-field criterion applies to the reduced support.  The displayed partitions
are asserted only on the etale open.  In particular, the even-cycle types may stay point-free on
every odd relative extension.  This is why the odd-degree-five support, not the degree-six
support, proves the fixed-coefficient tower theorem.

## Complete theorem matrix

| invariant row | legality | reduced fiber/component statement | collision conclusion | remaining gate |
|---|---|---|---|---|
| linear-`p` | empty by C313 | no incidence base | none needed | closed |
| constant-`p`, `U,E0--E3` | empty by C315 | no incidence base | none needed | closed |
| `E4`, generic | seed-legal arithmetic open | two degree-five algebras and two generically degree-six fibers; affine-line translation factors | collision after fixed odd extension of degree `1,3`, or `5` | simultaneous base-field no-root test for fresh coefficients |
| `Delta_R=0` | allowed | repair--repair--seed degree `2`; degree-five fibers unchanged | same fixed-tower obstruction from degree five | quadratic no-root plus both degree-five no-root tests over the base field |
| `Gamma_gamma=0` or `Delta_R` | allowed conic coincidence | prescribed target specialization of the same exact fibers | same fixed-tower obstruction | evaluate the same four no-root tests |
| packet repeated-root targets | allowed by C315 | no mixed-incidence component is repeated; same fibers | same fixed-tower obstruction | evaluate the same four no-root tests |
| `S_n=0` | alternate RR chart | isolated points; use `S=T=0` and the original quadratic | an `F`-point is a genuine collision | exact finite root test |
| `J_RR=0`, `J_RR,0=0`, or `B_SS=0` | allowed | ramified/nonreduced finite fiber | residue degree one still exactly detects an `F`-collision | exact finite root test with multiplicity retained |
| `p=0` | collision-free | absent since `E_SS(0)!=0` | no lost collision | closed deletion |
| `x*(x+d)=0` | geometric RR pole | no odd-tower `F`-point | no lost base-field collision | closed deletion |
| `X_gamma=1` | absent from seed survivor | no incidence base | none | closed |
| `X_alpha=X_beta` | forbidden seed divisor | no legal configuration | none | closed |
| `H in {0,Delta_R,Gamma_alpha,Gamma_beta}` | configuration deletion | collision equations independent of `H` | does not alter fiber arithmetic | closed |

The finite trace conditions defining `T_rho,theta` remain arithmetic conditions on the target
pair.  They do not change the geometric component statements and do not imply a linear factor of
any eliminant.

## Terminal construction-versus-obstruction boundary

For a fixed seed-legal configuration, the odd-degree-five theorem is decisive: scalar extension
cannot preserve collision-freeness throughout the odd tower.  This covers every constant-`p`
member that survives C315, while C313 separately makes the linear-`p` contribution empty.

For a fresh configuration over each `F`, define the four exact collision gates:

1. `E_SS,1` has no linear factor;
2. `E_SS,2` has no linear factor;
3. the `Gamma_alpha` repair--repair--seed fiber has no `F`-point;
4. the `Gamma_beta` repair--repair--seed fiber has no `F`-point.

The configuration is collision-free if and only if all four gates hold.  For gates 1--2 the only
no-root factor types are `(5)` and `(3,2)`; gates 3--4 use the exact C316 equations, including the
`S=0`, branch, and `Delta_R=0` rows above.  This is a finite arithmetic image-avoidance problem on
C315's explicit quarter-density seed set, not a curve point-supply problem.

Passing these four gates would prove only that the four full layers form an arc.  A construction
must still prove relative coverage of every prescribed-conic point.  C302's deletion/coverage
conditions cannot be inferred from collision scarcity or abundance.

## Comparison with C210 and the `Q=512` boundary

C210 proves a stronger per-field obstruction for its nonconstant-height codimension-three slice:
all such specializations collide for `Q>=32768`, with several strata closed already at `Q>=512`.
C317 covers the whole seed-legal remainder of C297's constant-`p` family, but only in the
fixed-coefficient odd-scalar-tower sense.  It does not upgrade C210's per-field bound to fresh
`E4` coefficients.

At `Q=512`, the four finite root gates above are exact, but no theorem here forces or excludes a
simultaneous survivor.  C305's bounded finite gap therefore remains.  A full `Q=512` census is
neither performed nor justified by this report.

## Manuscript-scope recommendation for C299

C299 may now draft a sharply bounded invariant section containing:

- the C297 quotient and C313/C315 legality collapse;
- the four C316 finite relative-offset maps;
- the genus-zero affine-line component theorem; and
- the fixed-coefficient odd-extension obstruction of relative degree at most five.

It should not advertise a fresh-per-field asymptotic collision obstruction or a finite
construction.  The simultaneous no-root and relative-coverage gates must be stated as open.  A
construction paper requires a separately scoped arithmetic image-avoidance and coverage theorem;
the present results alone support a mechanism-boundary paper.

## Evidence boundary

This is a proof-only report.  The fiber algebras and reconstructions are C316's displayed
identities; the new input is the dimension correction and the elementary factor-degree argument
for the exact degree-five eliminants.  No CAS decomposition, field census, or generated artifact
is used.

The report does not prove that fresh collision-free seed pairs exist, that they do not exist, or
that a collision-free pair is relatively complete.  It does not classify the degree-six branch
fibers beyond C316's exact saturated ideals, and it makes no global claim about other repair
architectures.

## Vibe check

Mixed but mathematically clean.  The hoped-for Hasse--Weil obstruction is unavailable because the
target fibers are finite, yet odd degree gives a sharp fixed-coefficient tower obstruction with
relative degree at most five.  The surviving fresh-field problem is now an exact four-gate
arithmetic image-avoidance problem rather than an unspecified geometric exception.
