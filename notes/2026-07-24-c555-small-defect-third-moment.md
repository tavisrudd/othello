# C555: small defect, third moments, and the conic graph

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete. The exact third-moment remainder, the full hierarchy
of subordinate raw moments, and the conic-incidence graph reduction are
proved below. Raw moments and incidence-only spectra add no independent
nonnegative term; a stronger bound requires a mixed rank-three,
matching-compatibility, or polarity invariant. C556 therefore remains
gated rather than inheriting a false carrier theorem.

## Inputs from C554

For every `k`-arc, the concurrence points canonically decompose
`E(KG(k,2))` into matching cliques `K_{r(x)}`. With
`m=floor(k/2)`, zero defect makes every nontrivial clique a maximum
matching. If `E_bad` is the set of graph edges lying in cliques of order
strictly between `1` and `m`, then

    |E_bad| <= m(m-1)Delta_C(A)/2.

C555 asks whether a third moment or conic-sensitive spectral term supplies
information independent of this second-moment defect.

## Exact third-moment remainder

### Theorem

Let `A` be any `k`-arc in a projective plane and put
`m=floor(k/2)` and `epsilon=k-2m`. Then

    Theta_3(A)
      = ((k-4)/2)C(k,4)
        - sum_{x notin A} C(r(x),3)
        - (epsilon/2)C(k,4)

is nonnegative and has the exact local form

    3 Theta_3(A)
      = sum_{x notin A} C(r(x),2)(m-r(x)).

For even `k`, this is

    ((k-4)/2)C(k,4) - sum_x C(r(x),3)
      = (1/3)sum_x C(r(x),2)(m-r(x)).

For odd `k`, the unavoidable unmatched vertex contributes the subtracted
baseline `C(k,4)/2`.

### Proof

Choose two disjoint secants and one arc vertex outside their four
endpoints. There are

    3*C(k,4)*(k-4)

such ordered choices. If the two secants meet at a point of index `r`,
then their concurrence matching uses `2r` vertices. Among the `k-4`
possible chosen vertices, exactly `2(r-2)` have a partner on another
secant through the same point. Hence the number of successful ordered
choices is

    sum_x C(r(x),2)*2(r(x)-2)
      = 6*sum_x C(r(x),3).

Subtracting successes from all choices gives

    3*C(k,4)*(k-4)-6*sum_x C(r(x),3)
      = sum_x C(r(x),2)(k-2r(x)).

Now use `k=2m+epsilon` and
`sum_x C(r(x),2)=3*C(k,4)`.

## Dependence on the second-moment defect

The new remainder has the same local vanishing factor `m-r` as the C554
matching defect. More precisely:

- at an off-conic point,

      C(r,2)(m-r)
        = (r/2)*(r-1)(m-r);

- at a conic point,

      C(r,2)(m-r)
        = ((r-1)/2)*r(m-r).

Thus `Theta_3` reweights the existing local defects toward higher
multiplicity, but supplies no new nonnegative local term. Its zero set is
weaker than the prescribed-conic defect's zero set because a singleton
secant hit on `C` is invisible to `C(r,2)`.

In particular, the universal third-moment upper bound cannot by itself
improve the scalar lower bound or its additive constant. Any improvement
must prove that projective or conic geometry keeps `Theta_3` uniformly
away from its formal minimum in the relevant defect range.

## All raw higher moments are subordinate

The same boundary holds at every order.

### Theorem

For `3<=j<=m`,

    sum_{x notin A} C(r(x),j)
      <= 3*C(k,4)*C(m,j)/C(m,2),

with exact remainder

    Phi_j(A)
      = sum_{x notin A} C(r(x),2)
          * (C(m-2,j-2)-C(r(x)-2,j-2))/C(j,2)
      >=0.

This follows from

    C(r,j)
      = C(r,2)*C(r-2,j-2)/C(j,2)

and the monotonicity of `C(r-2,j-2)` for `r<=m`. For any fixed `j` in the
displayed range, equality holds exactly when every concurrence clique of
order at least two has the maximum order `m`.

Likewise, on the conic,

    sum_{y in C} C(r(y),j)
      <= (C(m,j)/m)*I_C(A),

because `C(r,j)/r` is increasing. Equality again requires every positive
index visible to that moment to equal `m`; singleton conic hits remain
invisible.

Therefore no raw higher secant moment, nor its restriction to `C`, adds a
new local extremality condition. A successful higher-order inequality must
be mixed: it must remember where concurrence centres lie, how their
matching cliques intersect, or how the dual arrangement is represented in
rank three.

## The conic-incidence graph

Let

    Y={y in C : r(y)>0}.

Build a simple graph `G_C(A)` on `Y`: join distinct `y,z` when their chord
`yz` is an `A`-secant. Attach a flag `t_y in {0,1}` when the tangent to
`C` at `y` is an `A`-secant. Every `A`-secant meeting `C` is uniquely a
chord or a tangent, so

    r(y)=deg_G(y)+t_y.

Consequently the conic part of the defect is exactly the degree-deficit
energy

    D_C(A)
      = sum_{y in Y} (deg_G(y)+t_y)
          (m-deg_G(y)-t_y).

This graph formulation gives, with `s=|Y|` and
`I_C(A)=sum_y r(y)`,

    r(y)<=s,
    D_C(A)>=(m-s)_+ I_C(A).

At zero defect, every positive degree equals `m`. Therefore either `Y` is
empty or

    s>=m.

More precisely, the chord graph on the `s` active centres has degrees
`m` or `m-1`; a vertex has degree `m-1` exactly when its tangent flag is
present. If `t=sum_y t_y`, then

    m*s=2|E(G_C(A))|+t.

This recovers the incidence parity and strengthens it to a full graphical
realizability condition.

## Spectral boundary

Writing `M` for the adjacency matrix of `G_C(A)`, `t` for the tangent-flag
vector, and `1` for the all-one vector,

    r=M*1+t,
    D_C=m*1^T r-||r||^2.

The elementary spectral bound `rho(M)<=s-1` gives exactly the support bound
above and no stronger universal term. This is not an accident: before
requiring the lines to be secants of one common arc, an arbitrary simple
graph on a subset of `C`, together with arbitrary tangent flags, is
realized by selecting the corresponding chords and tangents. Therefore a
spectral argument using only conic-line incidence cannot improve the
defect inequality. It must also encode compatibility of those lines with
the common star--matching realization on `A`.

## Current consequence

C554 and the present identities isolate the missing input:

    variable matching-clique decomposition
      + conic chord/tangent degree graph
      + rank-three projective compatibility.

The first two layers have exact moment identities but admit their extremal
distributions abstractly. A stronger lower bound requires a theorem at the
third layer—for example, a rank, polarity, or forbidden-minor condition
showing that the near-maximum matching cliques and the nearly `m`-regular
conic graph cannot coexist in `PG(2,q)`.

## Literature boundary

These identities are proved directly here, but no novelty claim is made.
Any manuscript insertion must audit higher secant-moment inequalities,
matching-design moment bounds, and graph models of conic chord incidence
under the repository's literature protocol.

## Mystery ledger

- **Higher moments:** the `ej`+`tt` pass settles every unmixed raw moment,
  not only the third: each has an exact remainder subordinate to the
  maximum-matching defect. No additive-constant improvement follows without
  a mixed projective compatibility theorem.
- **Conic spectrum:** settled at the incidence-only level; arbitrary chord
  graphs show why a bare eigenvalue estimate stops at `r(y)<=|Y|`.
- **Coupling invariant:** still open. The raw-moment and incidence-only
  attempts close negatively. C556 remains gated until a genuinely mixed
  rank-three invariant appears.
