# C210: the b=0, a!=0 boundary is collision-forcing on the odd-tower tail

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This closes Packet 2 of the C210 umbrella handoff for
`q=8^m`, odd `m>=3` (equivalently `q>=512`). The sole smaller odd-tower field
`q=8` is recorded as a bounded exception not decided by this report.

## Statement

Let `k=GF(q)`, `q=8^m` with odd `m`, and work on
`b=0, a*delta*p!=0`. Put

    theta = w^2+w+1,                  N = a^2+a+1,
    Q = u^2+u*delta+delta^2,          G1 = u^2+u*p+p^2*theta,
    G2a = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta
          +delta^2*p+delta*a*G1,
    sigma = a*delta*N*G1*G2a.

Then the original trace-one collision cover is

    R(u,t) = a^2*Q^2*t^4 + sigma*t^2 + B0.

It is a Frobenius pullback, not a generic `tau`-quadratic. Nevertheless, for
every parameter specialization on this scope and every `q>=512`, the cover has
a reconstructible genuine `k`-rational collision. Thus `b=0,a!=0` supplies no
surviving infinite-family construction stratum.

## 1. Artin--Schreier normalization and point threshold

Set `tau=a*Q*t`, `y=tau^2`, and, away from the roots of
`D=delta*N*G1*G2a`, set `z=y/sigma`. The cover becomes

    z^2+z = phi(u),
    phi = Q^2*B0 / (delta^2*N^2*G1^2*G2a^2).

The committed preflight identity gives the exact value at infinity

    phi(infinity) = (e/delta)^2 + e/delta.

Hence infinity is unramified and split over `k`, with the two rational values
`z=e/delta` and `z=e/delta+1`. In particular an irreducible normalization has
full constant field `k`; a geometrically split cover cannot be a trace-one
constant twist, because its two rational infinity points fix its two geometric
components individually.

The denominator divisor `D` has degree five. At a place occurring with
multiplicity `n` in `D`, Artin--Schreier reduction leaves either no pole or an
odd pole of order at most `2n-1`. Therefore the conductor contribution is at
most `2n`, and the Artin--Schreier genus formula gives

    g <= deg(D)-1 = 4.

This is [Stichtenoth, *Algebraic Function Fields and Codes*, 2nd ed.,
Proposition 3.7.8](https://link.springer.com/chapter/10.1007/978-3-540-76878-4_3),
applied to the normalization. If it is geometrically irreducible, the
Hasse--Weil bound ([ibid., Theorem
5.2.3](https://link.springer.com/chapter/10.1007/978-3-540-76878-4_5)) gives

    #C(k) >= q+1-2*g*sqrt(q) >= q+1-8*sqrt(q).

At most five normalized points lie over the pole support and two lie over
infinity, so at most seven must be removed. Since

    q+1-8*sqrt(q) > 7

for every odd-tower `q>=512`, a usable finite point remains. If the cover is
geometrically reducible, the rational infinity points make both components
`k`-rational; their normalizations are copies of `P^1`, and the same deletion
bound is more than sufficient. This dichotomy avoids any need to assume
arithmetic completeness of the three known residue branches.

At a usable point, `y` has a unique square root `tau` because Frobenius is a
bijection on `k`. Also `Q` has no rational root: after scaling by `delta`, it is
`v^2+v+1`, whose roots lie in `GF(4)`, while `GF(4)` is not a subfield of
`GF(2^(3m))` for odd `m`. Hence `t=tau/(a*Q)` is defined and rational.

## 2. Reconstruction is uniform

Pulling the universal collision quadratics through the trace-one
parametrization gives the exact identity

    H = D_quad*B_quad + A_quad*E_quad = delta*N*G1.

This identity is independent of `b`; it therefore also settles the rational
reconstruction denominator on the generic `b!=0` packets. On the odd tower,
`N` has no zero because its roots lie in `GF(4)`, and

    G1/p^2 = v^2+v+theta,
    Tr(theta) = Tr(w^2+w+1) = Tr(1) = 1.

Thus `G1` has no rational root and `H!=0` at every rational `u`. Every usable
cover point reconstructs the unique common quadratic root `r=J/H`; the
`H=J=0` split locus has no odd-tower rational point.

## 3. Genuineness and the two coincidence branches

The two repair points lie in distinct cosets because `delta!=0`. A repair
point can coincide with the seed only when its repair coset is the base coset:
`e=0` on the left or `e=delta` on the right. The real height coordinate then
forces precisely the two known branches below.

On `e=0,h0=0`, the checker proves

    R = T1 * U1,
    T1 = a*t^2+h1,
    U1 = Q^2*T1+delta*N*G1*G2a.

Reduction of `J+tH` modulo `T1` is zero, so `T1` is exactly the left
seed-coincidence factor. On

    e=delta,
    h0=p^2*theta+delta^2+delta*a*p,

it proves

    R = T2 * U2,
    T2 = a*t^2+a*p^2*theta+delta*a*p+delta^2+delta*p+h1,
    U2 = Q^2*T2+delta*N*G1*G2a,

and reduction of `J+(t+u)H` modulo `T2` is zero, so `T2` is exactly the right
seed-coincidence factor.

For either `Ui=0` and every rational `u`, `a,Q!=0` make the equation linear in
`t^2`, hence give a unique rational `t`. Such a point can also lie on the
coincidence factor only if `G2a(u)=0`; there are at most three such `u`.
Therefore each `Ui` contains genuine collisions for every `q>3`, including
`q=8`. Outside these two branches, no repair point can coincide with the seed,
so every reconstructed incidence supplied by Section 1 is genuine.

## Artifact and replay

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_b_zero.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_b_zero_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_b_zero.py | diff - analyze_c210_a_nonzero_b_zero_output.txt
  sha256sum -c analyze_c210_SHA256SUMS
  ```

The checker rebuilds the six universal collision coefficients and pulls each
one through the trace-one parametrization. It independently rebuilds the
universal resultant, verifies `H=delta*N*G1`, checks the even-`t` cover shape
and infinity leading term, and certifies both coincidence/non-coincidence
factor pairs directly in Singular.

## Exact checks and trusted boundary

- Seven numbered Singular gates: the global `H` identity, two exact branch
  factorizations, two reconstruction/coincidence reductions, and two checks
  that the other factor meets the coincidence factor only over `G2a=0`.
- Exact Python `GF(2)` checks rebuild the cover and its `b=0` coefficients from
  the committed universal equations; no coefficient is re-transcribed.
- An independent `GF(8)` convention check evaluates all 8 values of `N`, all
  56 `(delta,u)` values for `Q`, and all 448 `(p,w,u)` values for `G1`, finding
  zero roots in each case. The symbolic trace/subfield argument is
  load-bearing; this finite check guards field conventions.
- The point count is on the normalization, so the Aubry--Perret singular-curve
  bound is not used.
- Trusted boundary: exact sparse `GF(2)` arithmetic, Singular exact
  substitution/reduction, finite-field Frobenius, Stichtenoth Proposition
  3.7.8, and Stichtenoth Theorem 5.2.3.

## What this does not prove

- The remaining `q=8` specializations outside the two coincidence branches.
  They are the only finite exception to the stated odd-tower-tail result.
- The two-component second-layer classification on `b!=0`.
- Arithmetic completeness of the three known `b!=0` residue branches.
- Arc legality or coverage for any hypothetical surviving `b!=0` branch.

## Next gate

Classify both `b!=0` second-layer Artin--Schreier classes, now with the global
reconstruction identity `H=delta*N*G1` available in advance.

## SHA-256 / byte counts

    analyze_c210_a_nonzero_b_zero.py          8978  191a5257624cbea15953e76597eda367e0f3687f5522b94d712a9d49495d9894
    analyze_c210_a_nonzero_b_zero_output.txt  1252  ae8e898e35d5eb841568b6e520f1fe76fcdaa73fd7754bccac3589cbc8267ddd
