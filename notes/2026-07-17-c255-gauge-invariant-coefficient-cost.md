# C255 gauge-invariant coefficient implementation cost

**Lane:** `rp-next`
**Status:** COMPLETE — strict support-identical cost separation; the generic optimization is a
gain-graph switching/frustration problem, while the repair-library specialization makes C217's
foundation distinction operational.

## Decision

The bounded promotion gate passes.  Over
`K = GF(9) = GF(3)[z]/(z^2+1)`, take the cheap multiplier subgroup

```text
H = GF(3)^* = {1,-1} = {1,2}.
```

For the selected library consisting of all four three-point circuit equations of a represented
`U(2,4)`, C217's two support-identical axis restrictions have exact optimum costs

| axis parameters | cross-ratio orbit | equation-table cost `kappa_H` | directed multiplier cost `mu_H` |
| --- | ---: | ---: | ---: |
| `(0,1,3,4)` | `{2}` | `0` | `0` |
| `(0,1,2,8)` | `{3,4,5,6,7,8}` | `4` | `14` |

The directed cost counts the 24 ordered target/helper multipliers supplied by the four circuit
equations.  Thus the same complete radius-two repair supports can require fourteen non-prime-field
multipliers after globally optimal coordinate scaling, while the other realization requires none.
No coupled enlargement is needed.

This is a strict operational use of the foundation/cross-ratio layer, but not a claim that the
underlying switching optimization is new.  Retain the proposition for the coefficient-aware
repair-port paper or compiler story; do not promote a standalone gain-graph optimization paper.

## Gauge-invariant objectives

Let `mathcal C` be a selected circuit library on coordinates `X`, and choose a nonzero coefficient
`a(C,x)` on every incidence `x in C`.  A legitimate circuit normalization and stored-coordinate
rescaling acts by

```text
a(C,x) |-> rho_C lambda_x^(-1) a(C,x).
```

For a multiplicative subgroup `H <= K^*`, define the cheap equation-table cost

```text
kappa_H(a) = min_(rho,lambda)
             #{(C,x) : rho_C lambda_x^(-1) a(C,x) notin H}.                 (1)
```

This counts entries of a shared normalized equation table that need a multiplier outside the cheap
subgroup.  It is invariant under every legitimate initial gauge by construction.

For direct recovery of target `x` from the other coordinates in `C`, the multiplier on helper `y`
is `-a(C,y)/a(C,x)`.  Circuit normalization cancels.  The corresponding full directed-library
cost is

```text
mu_H(a) = min_lambda sum_C #{(x,y) in C^2 : x != y and
                    -a(C,y) lambda_y^(-1) /
                     (a(C,x) lambda_x^(-1)) notin H}.                       (2)
```

Because `-1 in H`, a directed multiplier is cheap exactly when the two gauged incidences occupy the
same `H`-coset.  Equation (2) therefore measures actual constant multipliers, rather than treating
the arbitrary circuit scalar as executable work.

## Quotient-switching theorem

Orient the bipartite circuit--coordinate incidence graph from circuit vertices to coordinate
vertices and reduce every edge label modulo `H`.

> **Cheap-coefficient switching proposition.**  With `G = K^*/H`, `kappa_H(a)` is exactly the
> minimum number of nonidentity edges in the `G`-gain graph over all vertex switchings.  In
> particular, `kappa_H(a)=0` if and only if every circuit-incidence cycle has holonomy in `H`.
> The value depends only on the restriction of the foundation point to the selected library.

Indeed, the images of `rho_C` and `lambda_x` are precisely independent vertex potentials in `G`,
and an edge becomes cheap precisely when its switched gain is the identity.  The usual spanning-
tree normalization proves the zero-cost criterion: tree edges can all be switched to identity, and
the remaining chord labels are exactly the fundamental-cycle holonomies.  This is C217's complete
gauge theorem after quotienting the coefficient group by `H`.

When `H=L^*` for a subfield `L`, zero table cost says that the entire selected equation library can
be normalized into `L^*`.  Positive cost is therefore a selected-library descent obstruction,
strictly weaker than requiring the whole matroid representation to descend.

## The strict `U(2,4)` pair

Use all four triple circuits on each ordered axis quadruple.  Their incidence graph is
`K_(4,4)` with the four nonincidences removed, so it has 8 vertices, 12 edges, and cycle rank 5.
Both examples have this identical graph and identical circuit supports.

For `(0,1,3,4)`, C217's cross-ratio is `2=-1`.  Its anharmonic orbit is the singleton `{2}`, and
the four points form the `GF(3)` projective line after projective normalization.  Hence all four
circuit equations admit coefficients in `H`; both costs are zero.

For `(0,1,2,8)`, the cross-ratio is `3`, whose six-element anharmonic orbit is disjoint from `H`.
The four-cycle holonomy is therefore nonidentity in `K^*/H`.  The switching proposition immediately
proves `kappa_H>0`, independently of coordinates or equation normalization.  In foundation
language, the two `U(2,4)` foundation points have the same Krasner shadow but only the first selected
library descends to the prime-field unit subgroup.

The exact stronger values follow from a complete quotient computation.  Since

```text
K^*/H = GF(9)^*/GF(3)^* = C4,
```

fixing one global vertex potential leaves exactly `4^7 = 16,384` switchings for (1).  The verifier
checks every one: the second library has minimum four noncheap table entries, attained by 38
switchings.  For (2), circuit potentials cancel and a common coordinate potential is irrelevant,
leaving `4^3 = 64` coordinate switchings.  The exact minimum is fourteen noncheap directed
multipliers, attained by 12 switchings.  The JSON certificate records explicit minimizing
potentials and the resulting edge cosets, giving upper witnesses as well as exhaustive lower bounds.

## Verification

[`2026-07-17-c255-gauge-invariant-coefficient-cost-verifier.py`](2026-07-17-c255-gauge-invariant-coefficient-cost-verifier.py)
imports the independent C203 `GF(9)` field and nullspace implementation, reconstructs the four
circuit equations for each C217 quadruple, and performs the two quotient searches.  Its checked
certificate is
[`2026-07-17-c255-gauge-invariant-coefficient-cost-verifier.json`](2026-07-17-c255-gauge-invariant-coefficient-cost-verifier.json).

The verifier asserts:

- cheap subgroup `{1,2}` and quotient `C4`;
- table optima `(0,4)` after all `2 * 16,384` searches;
- directed multiplier optima `(0,14)` after all `2 * 64` searches;
- the first holonomy lies in `H` and the second does not.

## Literature and novelty boundary

The quotient formulation is classical gain-graph switching, not a new abstract optimization.
Zaslavsky's gain graphs label oriented edges by a group, define balanced cycles by identity gain,
and treat switching and balance as fundamental structure:

- Thomas Zaslavsky, *Biased Graphs. I. Bias, Balance, and Gains*, JCTB 47 (1989), 32--52,
  [DOI](https://doi.org/10.1016/0095-8956(89)90063-4).  The cached authoritative PDF has SHA-256
  `4f504e19d7a021f7f7079a4e71ec4b8b663ac23db68d6f13676ec06c178f8596`; it is image-only in the
  local extraction.
- For the signed-group case, the minimum number of frustrated edges is the classical frustration
  index; Aref, Mason, and Wilson give modern optimization formulations in
  [*A modeling and computational study of the frustration index in signed networks*](https://doi.org/10.1002/net.21907).

The foundation interpretation is likewise positioning, inherited from C247's audited sources:
Baker--Lorscheid represent rescaling classes by foundation points and identify the `U(2,4)`
parameter with cross-ratio data in
[*Foundations of matroids I*](https://arxiv.org/abs/2008.00014).

What is new inside this program is narrower and checkable: a selected repair equation library turns
that rescaling class into an implementation observable, and two realizations with the same support
port have different certified optima.  This is not restricted-MSP size—the rows and supports are
held fixed—and it is not XOR scheduling—the optimization changes legal coefficient gauges before
execution.  Generic gain-graph algorithms own the resulting optimizer once the translation has
been made.

## Disposition

C255 passes its strict-pair gate with a single `U(2,4)`: support equality, exact optimum separation,
and a cross-ratio/foundation obstruction all hold.  The result should be presented as an
operational corollary of the coefficient layer, with gain-graph switching cited as the algorithmic
home.  Do not enlarge the construction or claim a new generic coefficient-optimization problem.

The next lane task is C256's bounded radius-truncated port-rigidity scout.
