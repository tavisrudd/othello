# C210: projective genuineness on the three known a!=0 branches

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-18. This closes Packet 4 of the C210 umbrella handoff on the
infinite tail. Every known `a!=0,b!=0` factorization branch carries genuine
projective collisions over every odd-tower field `q>=512`. Branch 3 also does
so at `q=8`; branches 1 and 2 have an exact, fully enumerated bounded `q=8`
exception set. The three-branch list is still not proved arithmetically
complete.

## Theorem

Work over `k=GF(8^m)`, `m` odd, on `a*delta*N*b*p!=0`, with

    theta = w^2+w+1,                 N = a^2+a+1,
    Q = u^2+u*delta+delta^2,         G1 = u^2+u*p+p^2*theta,
    G2a = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta
          +delta^2*p+delta*a*G1.

For branches 1 and 2 the exact original cover has the uniform factorization

    R = T*U,                         U = Q^2*T+delta*N*G1*G2a.

The `T=0` component is exactly a repeated seed/repair point. Every rational
`U=0` point with `G2a!=0` reconstructs three distinct projective points.
The second-layer report proves that the smooth normalization of `U=0` has
genus at most two and actual constant field `k`. Hasse--Weil, followed by
deleting the unique infinity point and at most six points over the three roots
of `G2a`, gives

    # genuine affine points >= q-4*sqrt(q)-6.

This is positive for every odd-tower `q>=512`.

On branch 3, the chosen noncoincident component is affine-linear and has
exactly `q` affine points. At its two intersections with branches 1 and 2, at
most the two points over `u=a*p` lie on the coincidence component. Hence it
has at least `q-2` genuine points, including at `q=8`.

**Conclusion:** all three known branches are collision-forcing on the entire
infinite tail `q>=512`. No known factorization branch survives as an
infinite-family construction candidate.

## Exact coincidence classification

Use the normalized height coordinates of the universal collision quadratics.
The seed and repair points have distinct first coordinates except in two
cases:

- the left repair can equal the seed only when `e=0` and its base parameter is
  `r=t`;
- the right repair can equal the seed only when `e+delta=0` and
  `r+u=t`.

The two repair points themselves are always distinct: their first-coordinate
difference is `delta*omega+u`, with `delta!=0`, `u in k`, and
`omega notin k`.

On branch 1 (`e=h0=0`), equality of the left repair with the seed is exactly

    T1 = a*t^2+b*t+h1 = 0.

The committed universal quadratics give the exact reconstruction identity

    J+t*H = 0 mod T1,                H=delta*N*G1.

Thus `T1=0` reconstructs `r=t` and is a coincidence artifact, not a genuine
collision component.

On branch 2, its forced height is exactly `h0=k0`, while

    L2 = a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1
       = h1+k1,
    T2 = a*t^2+b*t+L2.

The exact identity

    J+(t+u)*H = 0 mod T2

reconstructs `r=t+u`, so the right repair equals the seed. The checker also
substitutes `r=t` and `r=t+u` directly into both universal collision
quadratics and verifies their vanishing modulo `T1` and `T2`, respectively.

For either branch,

    U+Q^2*T = delta*N*G1*G2a.

Therefore `T=U=0` forces `G1*G2a=0`. The already certified trace argument says
`G1` has no rational zero anywhere in the odd tower. Away from `G2a=0`, a
rational point of `U=0` cannot lie on the coincidence component; reconstruction
through nonzero `H` then gives a unique base parameter and three distinct
points. Since `deg_u(G2a)=3` and a quadratic component has at most two points
over a fixed `u`, at most six affine normalization points are deleted.

## Branch 3

On `delta=p`, `theta=1`, direct identities give

    G1=Q,                            G2a=(u+a*p)*Q.

Write the branch-3 factors after cancelling `Q^2` as

    T3 = a*t^2+b*t+h1+e*b+e*N*(u+p+(a+1)*e),
    V3 = T3+p*N*(u+a*p).

At `e=0`, `T3=T1` is the branch-1 coincidence component, so use `V3`; its
linear coefficient is nonzero. At `e=p`, component labels swap and `T3` is
the branch-2 noncoincident component, again with nonzero linear coefficient.
For `e` outside `{0,p}`, neither repair layer meets the seed coset and every
cover point is automatically distinct. At either intersection,
`T3=V3=0` forces `u=a*p`, so removing at most two points leaves at least
`q-2` genuine affine points.

## Exact q=8 boundary

The large-field bound does not decide `q=8`, so the checker exhausts every

    7^4*8 = 19,208

allowed geometry `(delta,a,b,p,w)`. For each geometry it evaluates the shared
nonconstant second-layer class at all eight `u`, discards `G2a=0`, and records
separately how many remaining values have trace zero and trace one. Since the
branch constant `c_i` ranges bijectively over `GF(8)` as `h1` varies, these two
counts decide every one of the `153,664` geometry/constant-class pairs on each
branch.

Exactly `336` geometries have no genuine `u` for trace-zero `c_i`; none fails
for trace-one `c_i`. Thus branches 1 and 2 each have exactly

    336*4 = 1,344

exceptional geometry/constant classes and `152,320` genuine-collision-bearing
classes at `q=8`. The exception criterion is canonical:

1. normalize by `delta`, giving `(a,b/delta,p/delta,theta)`;
2. require that tuple to be one of the 24 sorted records in the committed JSON;
3. require `Tr_GF(8)(c_i)=0`.

The JSON uses the existing bit encoding
`GF(8)=GF(2)[z]/(z^3+z+1)`. Each normalized record accounts for seven nonzero
scales and two values of `w`, hence `24*7*2=336` geometries. This is an exact
bounded exception certificate, not a claim that any exception is arc-legal or
`C`-complete. The separate `b=0,q=8` boundary also remains open.

## Independent projective-incidence replay

The symbolic proof owns the uniform coincidence and distinctness statements.
As a coordinate-convention cross-check, the checker also reconstructs the
actual seed and repair points in `GF(64)` and compares the factor predictions
with the committed projective `line_key` incidence for both seed colors:

| branch witness `(e,delta,a,b,p,w,h0,h1)` over GF(8) | genuine per seed | coincident seen by `line_key` per seed |
|---|---:|---:|
| branch 1 `(0,1,1,1,1,0,0,0)` | 6 | 0 |
| branch 2 `(1,1,1,1,1,0,0,1)` | 6 | 16 |
| branch 3 `(2,1,1,1,1,0,0,0)` | 14 | 0 |

For branch 1, `line_key(left,left)` deliberately uses the vertical-line key,
so it does not report the anchor-degenerate `T1` points as incidences; the
exact reconstruction identity, rather than this independent witness, owns
their classification as repeated-point artifacts. On every witness, the set
of direct genuine `(u,t)` incidences equals the predicted noncoincident factor
set exactly. Branch 2 additionally matches all 16 repeated right/seed points.

## Artifact and replay

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_genuineness.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_genuineness_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_genuineness.py | diff - analyze_c210_a_nonzero_genuineness_output.txt
  sha256sum -c analyze_c210_SHA256SUMS
  ```

The Singular certificate has nineteen exact gates covering `H`, both cover
factorizations, both reconstruction identities, direct substitution into both
universal quadratics, the common-factor intersection, both branch-3 fibers,
and the branch-3 label swap. The finite-field half performs the complete
`GF(8)` exception census and the independent `GF(64)` incidence replays.

Trusted boundary: the committed universal collision quadratics and resultant;
exact polynomial arithmetic in Singular; direct deterministic `GF(8)`
arithmetic; the independent projective `line_key` implementation over
`GF(64)`; and the second-layer report's Artin--Schreier genus/Hasse--Weil
argument.

## What this does not prove

- Arithmetic completeness of the three known factorization branches.
- Genuineness on the separate `b=0,q=8` boundary.
- Arc legality, affine coverage, or `C`-completeness of a bounded `q=8`
  exception.
- The final global off-divisor `H=J=0` mechanism statement.

## SHA-256 / byte counts

    analyze_c210_a_nonzero_genuineness.py          15715  ca6775520d579f2e6b61a3410de9782750c5f0aa2282b8d1e92f15b6b3c353b6
    analyze_c210_a_nonzero_genuineness_output.txt   2797  fb04dff45b4148b342bc0b618026f0c3efa595ccc7b3c0e566dfafef35b3243e
