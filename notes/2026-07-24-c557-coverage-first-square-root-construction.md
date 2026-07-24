# C557: coverage-first square-root construction

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete negative in the stated architecture. A new
`2*sqrt(q)-1` conic-subarc architecture passes the full line-at-infinity
direction gate, but an exact product-direction theorem excludes every
fixed-size union of subfield lines on the infinite tail. Exact `q=64`
classification also rejects every proper union of subfield lines and all
512 binary-linear graph complements; bounded monomial-graph sweeps at
`q=64,256` have no quadratic survivor. No `O(sqrt(q))` construction is
claimed.

## Construction

Let `E=GF(Q^2)` have characteristic two and let `U=GF(Q)` be its unique
index-two subfield. Choose `omega in E\U`, so

    E=U direct_sum omega*U

as `U`-vector spaces. Put

    S=U union omega*U,
    A_S={[1:x:x^2] : x in S} subset PG(2,E).

Then

    |A_S|=2Q-1=2*sqrt(q)-1,  q=Q^2.

The set is an arc because it lies on the nonsingular parabola
`X_0 X_2=X_1^2`. This carrier is not the prescribed hole conic; the task is
to determine whether the ordinary uncovered locus lies on a second
nonsingular conic disjoint from `A_S`.

This family is not a constant-height bounded-layer repair construction and
is outside C330's closed scope.

## Global direction gate

The chord through parameters `x!=y` has affine equation

    X_2=(x+y)X_1+xy X_0.

Its point at infinity is therefore `[0:1:x+y]`. Since

    S restricted_plus S=E^*,

every nonzero finite direction is realized:

- an element of `U^*` is `0+u`;
- an element of `(omega U)^*` is `0+omega v`;
- an element `u+omega v` with `u,v!=0` is the cross-sum of
  `u` and `omega v`.

The zero direction is impossible in characteristic two with distinct
parameters, and every chord of the graph has finite slope. Thus the exact
uncovered infinity carrier consists of the two points

    [0:1:0], [0:0:1].

Unlike C330's `O(Q)`-direction family in a plane of order `Q^2`, this
architecture realizes all `Q^2-1` available nonzero finite directions and
leaves only the two points that a nonsingular conic can meet on the line at
infinity.

## Affine coverage as a dual blocking problem

Write a chord as the dual affine point

    (s,p)=(x+y,xy).

An affine primal point `[1:X:Y]` is covered exactly when the dual line

    p=Y+sX

meets the chord-parameter set

    L_S={(x+y,xy): x,y in S, x!=y}.

Here

    |L_S|=C(2Q-1,2)=2q-3Q+1.

Consequently, `A_S` is complete outside a conic precisely when the affine
lines missed by `L_S`, together with the single zero-direction point, form
a subset of a nonsingular conic avoiding `A_S`. The first exact gate is the
rank of quadratic evaluation on this ordinary uncovered locus.

## Acceptance gates

1. Exact finite reconnaissance at `Q=4,8,16`, with direct incidence replay.
2. If a unique quadratic carrier survives, derive it symbolically in
   `U+omega U` coordinates and prove avoidance/nonsingularity.
3. If no quadratic survives, classify the affine miss equations and state
   the exact mechanism obstruction; do not enlarge the family by another
   bounded-layer repair census.
4. Any surviving family must still prove coverage for all `Q` in an
   infinite field family.

## Product-direction obstruction

The line-union construction admits an exact infinite-tail rejection.

### Theorem

Let `D` be a set of `t` one-dimensional `U`-subspaces of `E`, viewed as a
subset of the cyclic quotient group

    G=E^*/U^*,  |G|=Q+1,

and put

    S_D=union_{d in D} d union {0}.

Assume `Q>=4`. If the product set `D*D` is not all of `G`, then the
ordinary uncovered locus of the parabola arc `A_{S_D}` is not contained
in any nonsingular conic.

In particular,

    |D*D|<=t(t+1)/2,

so the construction fails whenever

    Q+1>t(t+1)/2.

Hence no fixed `t` gives an infinite `O(Q)=O(sqrt(q))` family. Passing this
necessary gate requires `t=Omega(sqrt(Q))` and therefore

    |A_{S_D}|=Omega(Q^(3/2))=Omega(q^(3/4)).

### Proof

On the affine vertical line `X=0`, the chord through parameters `x,y` has
ordinate

    Y=xy.

For nonzero `x,y in S_D`, the quotient direction of `xy` belongs to
`D*D`. Conversely, every nonzero element of a direction in `D*D` is a
product of two distinct parameters. For two different `U`-lines this is
immediate. On one `U`-line, write the target as `alpha^2 w` and choose
distinct `u,v in U^*` with `uv=w`; this is possible for `Q>=4`.

Thus every missing quotient direction contributes all `Q-1` of its
nonzero elements as uncovered points on `X=0`. If `D*D!=G`, that vertical
line contains at least `Q-1>=3` uncovered affine points.

The arc also leaves the two infinity points `[0:1:0]` and `[0:0:1]`
uncovered. A conic containing them has equation

    a X_0^2+d X_0 X_1+e X_0 X_2+f X_1 X_2=0.

Nonsingularity forces `f!=0`; otherwise the equation is singular or
contains the line at infinity as a component. Its restriction to the
affine vertical `X_1=0` has at most one point. It cannot contain the
`Q-1` uncovered points found above.

## Nonlinear transversal extension

Direction coverage survives a much larger family. For any function
`f:U->U` with `f(0)=0`, put

    S_f=U union {f(v)+omega v : v in U}.

Every element `a+omega b` is the sum of

    a+f(b) in U

and

    f(b)+omega b

from the graph, so `S_f restricted_plus S_f=E^*`. The product-direction
theorem for unions of `U`-lines no longer applies when `f` is nonlinear.
This is the exact surviving design freedom.

The bounded gates found no quadratic carrier in:

- all 512 binary-linear maps `f:GF(8)->GF(8)`;
- all 50 distinct monomial graph sets
  `f(v)=c v^d` over `GF(8)` from the 56 raw `(c,d)` parameters; and
- all 226 distinct monomial graph sets over `GF(16)` from 240 raw
  parameters.

These are exact finite exclusions only. They do not rule out arbitrary
nonlinear transversals over larger fields.

## Exact finite evidence

For the distinguished first `t` subfield lines, the uncovered-locus and
quadratic ranks are:

| `Q` | tested `t` | arc sizes | uncovered sizes | quadratic survivors |
|---:|:---|:---|:---|:---|
| 4 | 2--5 | 7, 10, 13, 16 | 47, 8, 5, 2 | only `t=4,5` |
| 8 | 2--6 | 15, 22, 29, 36, 43 | 569, 65, 44, 30, 23 | none |
| 16 | 2--6 | 31, 46, 61, 76, 91 | 8057, 1082, 362, 272, 242 | none |

At `Q=8`, multiplication normalization fixes one selected `U`-line.
All 254 normalized proper unions with `2<=t<=8` have quadratic evaluation
rank six. The sole `t=9` survivor is the full parameter set `S=E`, whose
arc has size `q`, not `O(sqrt(q))`.

The committed evidence bundle is:

- `notes/2026-07-24-c557-direct-sum-parabola.py` (25,240 bytes);
- `notes/2026-07-24-c557-direct-sum-parabola.json` (813,480 bytes);
- `notes/2026-07-24-c557-direct-sum-parabola.sha256`.

The generator uses deterministic exact arithmetic, records the complete
finite domains above, and has no external dependency or random seed. An
independent certificate pass verifies, for every rank-six rejection, six
literal uncovered points and the full rank of their quadratic evaluation
matrix. The base `q=16,64` cases also replay the complete uncovered locus
by direct line incidence.

Replay from the repository root with

    python3 notes/2026-07-24-c557-direct-sum-parabola.py \
      --check-evidence \
      notes/2026-07-24-c557-direct-sum-parabola.json
    python3 notes/2026-07-24-c557-direct-sum-parabola.py \
      --verify-certificates \
      notes/2026-07-24-c557-direct-sum-parabola.json
    sha256sum -c \
      notes/2026-07-24-c557-direct-sum-parabola.sha256

The first command regenerates the full sweeps and is the expensive path;
the compact rank-certificate pass is the independent quick check.

## Literature boundary

No novelty claim is made for additive difference bases, subfield-line
unions, or graph transversals. Before any manuscript use, the construction
language and product-direction obstruction require a bounded audit against
translation arcs, Baer subarcs, relative difference sets, and complete
parabola-subarc constructions.

## Mystery ledger

- **Direction miracle:** settled: the direct-sum parameter set is an
  additive difference basis and covers every nonzero finite direction with
  only `2Q-1` arc points; exactly the zero and vertical infinity points
  remain.
- **Affine misses:** the `ej`+`tt` pass settles the union-of-subfield-lines
  family by the product-direction obstruction. The nonlinear-transversal
  family remains open beyond the certified linear/monomial cells.
- **Prescribed conic:** no carrier survives the nontrivial tested cells, so
  avoidance and nonsingularity never become an infinite-family gate.
- **Architecture boundary:** C330's layers failed because their additive
  directions were sparse. C557 repairs additive directions but exposes a
  multiplicative-direction defect on an affine vertical. A viable successor
  must make both the restricted sumset and the relevant translated product
  sets large; no such successor is allocated.
