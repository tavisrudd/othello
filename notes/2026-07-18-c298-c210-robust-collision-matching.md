# C298: robust C210 collision matching and the exact star-collapse locus

**Lane**: `relconic`

Date: 2026-07-18.

## Theorem

Fix one seed color and orient every C210 seed--cross-repair collision as

    (t,r,s),                 s=r+u,

where `t` is the seed parameter and `r,s` are the left- and right-repair parameters.  Let the
collision hypergraph have these three parameter classes as vertices and the genuine ordered
collisions as edges.

On every C210 collision component in the completed obstruction theorem, the maps to `t`, `r`, and
`s` are nonconstant, with geometric fiber size at most nine, except for the following exact
genuine constant-coordinate components on the `a=0`, `delta=p`, `w in {0,1}` branch:

1. `L1=0` has constant `s=p+h1/b` exactly when `e=b`;
2. `L2=0` has constant `r=h1/b` exactly when `e=b+p`.

The two collapses cannot occur simultaneously because `p!=0`.  Therefore another genuine
noncollapsed component remains unless the noncollapsed line is the repeated-point component at a
branch intersection.  This happens at exactly two terminal overlap strata:

    a=0, e=0,       delta=b=p, w in {0,1}, h0=0,
    a=0, e=delta=p, delta=b=p, w in {0,1}, h0=p^2.

On the first stratum the only genuine rational component is

    L2=p*(t+u)+h1=0,          r=h1/p;

on the second it is

    L1=p*(t+u+p)+h1=0,        s=p+h1/p.

Each is a star of exactly `q-1` genuine edges in the oriented cover, all sharing the displayed
repair vertex.  Its matching and transversal numbers are both one.  For the union of the two seed
colors, deleting at most one such repair vertex per color kills every collision supplied by these
components.  Thus C210 alone cannot force a linear deletion cost on these two overlap strata.

Everywhere else, take one genuine component with `M` rational collision points after the C210
boundary and coincidence deletions.  Each fixed vertex lies in at most nine edges.  Hence

    Delta <= 9,
    nu >= ceil(M/25),
    tau >= ceil(M/9).

Here `nu` is the matching number and `tau` the vertex-transversal number.  The matching bound is
the greedy estimate: choosing one edge removes at most
`1+3*(9-1)=25` edges.  The transversal bound follows because one vertex covers at most nine edges.
Consequently every collision-free restriction outside the two terminal stars deletes linearly
many vertices whenever the existing C210 point supply is linear.

This proves a robust obstruction on the noncollapsed scope and isolates the exact
projection-collapse locus preventing a uniform all-parameter theorem.  It does not estimate the
coverage lost after deletion; the terminal stars show that such an estimate cannot be inferred
from the C210 collision count alone.

## Projection and duplicate audit

The checker rebuilds the two universal collinearity equations `q0=q1=0` directly in `(t,r,s)`.
Each has degree at most two in each coordinate and total vertex degree three.  After one coordinate
is fixed, two plane cubics have at most nine isolated common points by Bezout.  A fiber can exceed
nine only when it contains a curve, exactly the constant-coordinate case classified above.

The trace-one resultant presentation has

| polynomial | `u`-degree | `t`-degree |
|---|---:|---:|
| collision cover `R` | 6 | 4 |
| reconstruction denominator `H` | 2 | 0 |
| reconstruction numerator `J` | 3 | 2 |

Off a factorization divisor, absolute irreducibility plus these strict degree inequalities rules
out constant `r=J/H` and `s=u+J/H`; positive `u`-degree rules out constant `t`.  The same degree
comparison applies to the genuine branch-1/2 factor

    U=Q^2*T+delta*N*G1*G2a,

whose `u`-degree is five.  Its companion `T=0` factors are exactly the already classified
seed/repair coincidences: branch 1 reconstructs `r=t`, branch 2 reconstructs `s=t`.  Their
geometric constant-`t` pieces are not genuine edges.

On the `a!=0` branch-3 lines, exact remainders of `J+cH` and `J+(u+c)H` have nonzero leading terms
on every allowed genuine component.  At `e=0` or `e=p`, the sole constant-coordinate line is again
the repeated-point component and the other line remains noncollapsed.

On `a=0`, the first- and second-coset genuine cofactors are `t`-linear with coefficient `b*Q^2`;
`Q` has no rational odd-tower root.  Exact coefficient-ideal elimination proves that their only
constant-repair specializations are the two `delta=b=p`, `w in {0,1}` terminal stars above.  On
the full `a=0` branch 3, the same calculation gives the broader `e=b` and `e=b+p` componentwise
collapses and proves that the alternate line is noncollapsed away from the terminal overlaps.

On `a=b=0`, the exact identity `J+t*H` is independent of `t`.  Thus on every genuine univariate
`u`-root component,

    r=t+kappa,               s=t+kappa+u,

so all three vertex maps have degree one.  A constant `u` is not a selected vertex and is not a
projection collapse.  This audits the fixed-coefficient scalar-extension boundary without
promoting the finite C210 arc census to a new coefficient-varying theorem.

Finally, `H!=0` throughout the odd tower gives one reconstructed `r=J/H` for every finite
resultant point.  Since `s=r+u` and the layer colors are fixed, a finite point determines one
ordered triple.  Component intersections are counted only once, and repeated-point factors are
removed before `M` is formed.  There is no orientation or reconstruction multiplicity hidden in
the hypergraph bounds.

## Point-supply consequences

The result consumes, rather than changes, the C210 normalization and genuineness bounds.  Useful
choices of `M` include:

| stratum | certified lower bound for one usable genuine component |
|---|---:|
| `a!=0,b!=0`, off the factorization divisor | `q-30*sqrt(q)-9` |
| `a=0,b!=0`, off `D3` | `q-10*sqrt(q)-7` |
| `a!=0,b=0` | `q-8*sqrt(q)-6` |
| `a!=0,b!=0`, branches 1 and 2 | `q-4*sqrt(q)-6` |
| `a!=0,b!=0`, branch 3 | `q-2` |
| `a=0` split branches, outside the terminal stars | at least `q-O(1)` |

For the last row, the primitive component is `t`-linear with nonzero rational coefficient; only
`u=0` and its bounded intersections with the repeated factor are removed.  The exact constant is
unneeded for the linear theorem.  At the two terminal stars the edge count remains `q-1`, but its
concentration makes `nu=tau=1`.

In particular, on every noncollapsed stratum in the C210 infinite-tail theorem the matching and
transversal bounds are `Omega(q)`, with explicit constants `1/25` and `1/9` applied to the displayed
`M`.  The conclusion is about collision deletion only, not survival of relative completeness.

## Artifact and replay

The atomic evidence bundle is:

- `papers/arcs_complete_outside_conic/analyze_c298_robust_collision_matching.py`;
- `papers/arcs_complete_outside_conic/analyze_c298_robust_collision_matching_output.txt`;
- `papers/arcs_complete_outside_conic/analyze_c298_SHA256SUMS`.

Replay from `papers/arcs_complete_outside_conic/`:

```bash
python3 analyze_c298_robust_collision_matching.py \
  | diff - analyze_c298_robust_collision_matching_output.txt
sha256sum -c analyze_c298_SHA256SUMS
```

The run uses Python `3.13.12` and Singular `4.4.1`.  The script uses the local Singular binary when
available and otherwise the repository's established `nix shell nixpkgs#singular` fallback.  It
has no random choices or seeds.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `analyze_c298_robust_collision_matching.py` | 14,883 | `3099e0c604c201b608c57ef28ecd2af07e0bbd4cfe9ff2080256b1b0dd42cd38` |
| `analyze_c298_robust_collision_matching_output.txt` | 1,998 | `60448ffbe66942707dbf250f5dfb4f6c879cf5d7869fea3f7594ba40341a58c7` |

The symbolic trusted boundary is exact sparse arithmetic over `GF(2)`, Singular resultants and
Groebner reductions, and the previously certified C210 component classification.  Bezout and the
two elementary hypergraph estimates are proved in this report rather than delegated to code.

As an independent convention check, the script reconstructs the two terminal examples directly
in `PG(2,64)` using the committed projective `line_key` incidence implementation, not the
resultant.  For each of the alpha and beta seed colors it finds exactly seven genuine edges at
`q=8`; all seven share the predicted repair vertex, while their other two vertex coordinates are
distinct.

## Evidence boundary

- The theorem is for the C210 ordered collision correspondence and its certified components, not
  for arbitrary layered arcs.
- The two terminal stars are an exact bounded-mechanism obstruction to a uniform C210 transversal
  theorem, not evidence that a partial-domain construction succeeds after their centers are
  deleted.
- No coverage hypergraph, coverage-loss estimate, or collision-free partial construction is
  certified here.
- The finite `PG(2,64)` replay checks coordinate and genuineness conventions; it is not
  extrapolated to prove the symbolic classification.
