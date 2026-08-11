# C904 independent audit: spectral stabilization defect towers

Date: 2026-08-11

Status: theorem-level red team; frozen replay and three independent `h=1`
checks pass; no manuscript, Lean, or commit changes

## Verdict

The spectral stabilization theorem is sound.  The fibre retraction includes
all mixed divisor classes integrally, the divided-power expansion has no
missing binomial or factorial, and the top-class hypothesis is exactly what
is needed for the upper bound.  Consequently the printed exact order-two,
order-three, and order-four towers are licensed.

Only minor exposition corrections are recommended:

1. state that the displayed product formula is for `h>=1`, with `h=0`
   tautological;
2. make the multi-fibre matching/minor expansion one sentence more explicit;
3. repair the broken inline mathematics in the theorem statement; and
4. retain the exact top-order certificate as load-bearing in the order-four
   family, since the abstract factorial bound there gives only order dividing
   eight.

## 1. Integral mixed-divisor retraction

Write the stabilized slope as

\[
                         A=A_0\oplus aI_h
\]

and an integral divisor coefficient as

\[
 T=\begin{pmatrix}T_0&U\\U^t&T_1\end{pmatrix}.
\]

The cross congruence is

\[
                        (aI_d-A_0)U=0\pmod p.
\]

Since `a` is absent from the spectrum of `A_0`, this forces `U=pV`.
For one scalar coordinate, contracting two mixed divisor forms along the
fibre gives, up to the common orientation sign, the base divisor

\[
                       \Omega_{p^2(uv^t+vu^t)}.
\]

Its coefficient matrix is zero modulo `p`, so it automatically satisfies
the base commutator congruence and belongs to the actual integral base
Néron--Severi lattice, not only its rational span.

For `h` scalar coordinates, consider a monomial of `d+h-1` divisors.  If it
contains `2s` mixed divisors, `l` pure fibre divisors, and `b` pure base
divisors, a nonzero fibre integral requires

\[
                         2s+2l=2h,
                         \qquad s+l=h.
\]

The fibre matching expansion pairs the `s` mixed `x`-legs with the `s`
mixed `y`-legs.  Integral Plücker straightening replaces two mixed brackets
by one base and one fibre bracket, with coefficients `+1` and `-1`; induction
on the number of mixed brackets leaves only base brackets and an integral
minor of the pure fibre divisor matrices.  Each paired contribution is the
integral base divisor displayed above.  The resulting number of base divisor factors is

\[
             b+s=(d+h-1-2s-l)+s=d-1.
\]

Terms with an odd number of mixed forms vanish.  Therefore every surviving
term is an integer multiple of a product of exactly `d-1` integral base
divisors, proving

\[
                     \pi_*(P_h^{d+h-1})
                         \subseteq P_0^{d-1}
\]

without division by a factorial.

## 2. Divided-power normalization

For `h>=1`, the product polarization satisfies

\[
 \gamma_{d+h-1}(\Theta_0+\Theta_1)
   =\gamma_{d-1}(\Theta_0)\gamma_h(\Theta_1)
    +\gamma_d(\Theta_0)\gamma_{h-1}(\Theta_1)
   =c_0t_1+t_0c_1.
\]

The divided-power binomial identity already absorbs the ordinary binomial
coefficients.  Since the scalar factor is principally polarized,

\[
                       \int_{A_1}t_1=1,
\]

while `c_1` is not top-dimensional.  Hence

\[
                         \pi_*c_h=c_0
\]

with no sign-independent multiplier.

If `mc_0` belongs to `P_0^{d-1}` and `mt_0` belongs to `P_0^d`, then the
displayed product formula gives \(mc_h\in P_h^{d+h-1}\).  Conversely,
\(nc_h\in P_h^{d+h-1}\) implies \(nc_0\in P_0^{d-1}\) after fibre integration.
Thus the stabilized order is exactly the base order `m`.  The top-class
hypothesis is not decorative: it controls the second summand `t_0c_1`.

## 3. Base and first-stabilization checks

The frozen base certificate gives exact `(curve order, top order)`:

| base | dimension | orders |
|---|---:|---:|
| dyadic regular nilpotent | 3 | `(2,2)` |
| triadic displayed graph | 4 | `(3,3)` |
| dyadic regular nilpotent | 5 | `(4,4)` |

The all-degree factorial lemma supplies the necessary top upper bounds for
the first two bases.  In the order-four base it gives only an upper bound of
eight because `v_2(5!)=3`; the exact top order four from the certificate is
therefore load-bearing.

As an independent spot check, direct reconstruction of the first stabilized
graph gives:

| tower | stabilized dimension | exact minimal order | product rank | monomials |
|---|---:|---:|---:|---:|
| dyadic order two | 4 | 2 | 10 | 220 |
| triadic order three | 5 | 3 | 15 | 3,060 |
| dyadic order four | 6 | 4 | 21 | 53,130 |

These calculations use the earlier arbitrary-graph lattice routine rather
than the base-certificate path and agree with the theorem.

## 4. Replay

The frozen comparison

```sh
diff -u notes/2026-08-11-c904-graph-stabilization-base-certificates.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-11-c904-graph-stabilization-base-certificates.sage").read()))')
```

returns an empty diff.

No gap or normalization correction changes the three tower conclusions.
