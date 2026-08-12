# C907 quartic-double-solid carrier regression

**Lane:** `clebsch`

**Verdict:** support-zero calibration, not a length-two carrier candidate.

Let `Y -> P^3` be the smooth double cover branched over a quartic.  Its Hodge
number `h^(1,2)=10` is twice that of a cubic threefold, but this numerical
coincidence does not duplicate the cubic Stokes/Rees packet.  Kuznetsov--Perry
identify its residual category as noncommutative Enriques type with Serre
functor `sigma[2]`, not two cubic components.

The ambient small period is

\[
 \Phi(s)=\sum_{d\ge0}\frac{(4d)!}{(d!)^4(2d)!}s^d,
 \qquad s=q/z^2,
\]

and satisfies

\[
 \left[\theta_s^4-
 64s(\theta_s+\tfrac14)(\theta_s+\tfrac34)\right]\Phi=0.
 \tag{1}
\]

Set `t=s^(1/2)=q^(1/2)/z` and `D=t partial_t`.  Equation (1) becomes

\[
 D^4-256t^2(D+\tfrac12)(D+\tfrac32)=0.
\]

The HLT ansatz `exp(lambda t)t^alpha` gives

\[
 \lambda^2(\lambda^2-256)=0.
\]

The two irregular factors have `lambda=+/-16`, `alpha=-3/2`; the two
zero-exponential solutions have leading powers `t^(-1/2),t^(-3/2)`.  In the
scalar-period convention all four residues are `1/2` modulo integers.  Passing
to the framed first-order quantum connection adds the common `1/2` calibration
shift (the same shift that takes the cubic scalar residues `1/3,2/3` to Cai's
`5/6,1/6`).  Therefore the framed residues are integral and

\[
 \chi_{T_f}(T)=(T-1)^4,
 \qquad \nu_6(Y)=0.
\]

The coefficient extension by `q^(1/2)` does not ramify `z`, so it introduces
no deck permutation of the two irregular factors.  The quartic double solid
cannot realize the primitive-sixth length-two extension.  Its useful role is
as a hostile regression showing that doubled middle Hodge rank does not imply
doubled cubic quantum support.

## Sources

- Kuznetsov--Perry, arXiv:1411.1799, §8.1: noncommutative Enriques component
  and Serre functor.
- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: toric
  `I`-function.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.

## Mystery ledger

- **Settled:** the Hodge-rank doubling carries no primitive-sixth small-even
  QDM packet.
- **Open:** find a non-nef threefold with genuine primitive-sixth support on
  which to test the self-dual Rees extension.
