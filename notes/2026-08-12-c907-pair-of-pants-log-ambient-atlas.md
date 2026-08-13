# C907 pair-of-pants/log ambient atlas

**Lane:** `clebsch`

**Status:** exact ambient/chart specification and transition replay. This
constructs the one-tripod and residual-Rees ingredients for the full-initial
gate. It does not yet serialize a regular integral refinement of the full `y`
support complex or identify strict-transform graph ideals on every such chart.
It therefore makes no normality, tangent-Fitting, or collar claim.

## Global ambient and graph

Let `R = C[[delta]]`. Use marked projective lines

```text
P_B = P1_R, [b0:b1], B=b1/b0, U=(b0-b1)/b0,
P_C = P1_R, [c0:c1], C=c1/c0, V=(c0-c1)/c0.
```

The logarithmic points of `P_B` are `b1=0`, `b0-b1=0`, and `b0=0`;
they are `B=0,1,infinity`. With a smooth projective toric `y`-ambient `X_y`,
take `A = X_y x_R P_B x_R P_C`. The multihomogeneous graph divisor is

```text
Pbar = delta^2*Y*b0*b1*c0*c1*(L-S)
     - delta^2*Q*b0^2*c0^2
     - Y*b1*c1*(b0-b1)*(c0-c1).
```

On `b0*c0 != 0`, it is

```text
delta^2*Y*B*C*(L-S) - delta^2*Q - Y*B*C*U*V = 0.
```

The projective dense-domain complement is

```text
delta * M_y * b0*b1*c0*c1 = 0,
```

where `M_y` is the toric boundary monomial in a chosen `X_y` chart. The
translated factors `b0-b1` and `c0-c1` are deliberately absent: `B=1,C=1`
remain interior. Strict-transform saturation uses the actual pullback of this
product, never either translated factor.

## Four projective graph charts

Write `A=B^-1` and `D=C^-1`.  Before any residual Rees operation, the finite
product atlas has the following exact principal graph ideals and dense factors.
Here `M_y` is suppressed from each saturation factor only typographically.

| chart | graph generator | saturation factor |
| --- | --- | --- |
| `B,C` | `delta^2*Y*B*C*(L-S)-delta^2*Q-Y*B*C*(1-B)*(1-C)` | `delta*M_y*B*C` |
| `B,D` | `delta^2*Y*B*D*(L-S)-delta^2*Q*D^2-Y*B*(1-B)*(D-1)` | `delta*M_y*B*D` |
| `A,C` | `delta^2*Y*A*C*(L-S)-delta^2*Q*A^2-Y*C*(A-1)*(1-C)` | `delta*M_y*A*C` |
| `A,D` | `delta^2*Y*A*D*(L-S)-delta^2*Q*A^2*D^2-Y*(A-1)*(D-1)` | `delta*M_y*A*D` |

Thus each projective adjacency has an explicit full ideal to compare after
localizing the two chart coordinates which become inverse units.  The listed
factor is the only allowed saturation factor before a blowup; it does not
contain `1-B`, `1-C`, `U`, or `V`.

## One tripod: affine and logarithmic charts

The ordinary affine cover is:

| chart | equation | dense factor |
| --- | --- | --- |
| finite | `B`, `U=1-B` | `B` |
| infinity | `A=B^-1`, `U/B=A-1` | `A` |

The overlap is `A=B^-1`. The finite chart contains both the `0` and `1`
points, so the translated point is not accidentally removed.

After finite ramification write `s=delta^a`, `t=delta^b`, with `a,b >= 0`.
The strict ray presentations and their zero faces are:

| ray | presentation | zero-ray face |
| --- | --- | --- |
| `0` | `B=s*b0`, `U=1-s*b0` | `s=1`: `B=b0`, `U=1-b0` |
| `1` | `U=t*b1`, `B=1-t*b1` | `t=1`: `U=b1`, `B=1-b1` |
| `infinity` | `A=s*aInf`, `B=(s*aInf)^-1`, `U/B=s*aInf-1` | `s=1`: ordinary finite/infinity overlap |

Thus a zero ray coefficient attaches to the generic `g` presentation. It
must not retain a strict-ray pair-of-pants initial equation.

The simultaneous finite `0/1` incidence bridge is

```text
s*b0 + t*b1 = 1,
bInf = s*t*b0 = t - t^2*b1.
```

These are the required nonmonomial transitions. Setting either `s=1` or
`t=1` recovers the generic pair-of-pants equation.

The second equality follows by multiplying the incidence equation by `t`.
It exposes a defect in the old support-note display, which wrote
`t-s*t*b1` while retaining `s*b0+t*b1=1`; those two expressions agree only
under an extra unsupported relation.  The replay and this atlas use the
algebraically consistent `t-t^2*b1` formula.  This repairs a coordinate
transition, not a graph-overlap theorem.

## Product and residual Rees locus

Take the product of the two preceding atlases and a toric chart of `X_y`.
At the double translated point, the marked operation is `Bl_(delta,U,V) A`.
Its three affine charts are

```text
delta-chart: U=delta*Z, V=delta*W,
U-chart:     delta=U*r, V=U*v,
V-chart:     delta=V*s, U=V*w.
```

The exact overlaps are `Z*r=1`, `W=Z*v`, and `s*v=r`, `w*v=1`. A later
regular log refinement of this Rees model is required before Cartier
strict-transform saturation. In the imbalanced `U` chart, `v` remains an
interior smooth residue coordinate: it is never a control-stratum boundary
factor. This avoids the artificial `v=0` packets.

The finite `0/1` incidence endpoint additionally needs the projectivized
multi-Rees chart joining finite `c` to `c=infinity`, followed by the `e=1`
rescaling in `2026-08-12-c907-incidence-residual-endpoint-transition.md`.
That file identifies its graph with the bounded residual core on the common
dense open, but does not yet supply a proper common refinement. It is an open
extra residual blowup/transition, not a closed atlas edge.

## Finite regular-refinement target

The existing support fan is rational and finite but not yet a regular integral
fan. The finite toroidal algorithm is:

1. Clear ray denominators by a Kummer base change.
2. Apply ordered star (barycentric) subdivisions of every support cone, in
   decreasing dimension.
3. Star-subdivide remaining nonunimodular cones at canonical Hilbert basis
   rays until their primitive ray matrices are unimodular.
4. Apply the same sequence to the product atlas and normalized Rees fan,
   keeping the imbalanced `v` coordinate interior.
5. Pull back `Pbar`, divide only by exceptional multiplicities lying over the
   dense-domain complement, and compare the graph generator on every listed
   transition.

Steps 1--4 have not been serialized against the 81,367-cell certificate, and
step 5 is the actual full-initial gate. This is an explicit ambient atlas and
exact transition target, not a claim that the global regular modification has
already been built.

## Replay

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-one-tripod-log-atlas.sing | \
  cmp -s - notes/2026-08-12-c907-one-tripod-log-atlas.out
```

The replay checks the incidence bridge, both zero-ray specializations, and the
two independent Rees transition ideals. It does not assert graph-ideal equality
on the still-unconstructed regular refinement.

The recorded run uses Singular 4.4.1.  The script is 2,309 bytes and its
canonical output is 266 bytes; their SHA-256 hashes are recorded in the
adjacent manifest.  As an independent algebraic cross-check, every tested
identity also follows by the direct substitutions printed above: multiply
`s*b0+t*b1=1` by `t`, use `Z=U/delta`, `W=V/delta`, and localize by
`A*B=D*C=1` in the four projective charts.  No independent computation is
claimed for the unconstructed regular refinement.
