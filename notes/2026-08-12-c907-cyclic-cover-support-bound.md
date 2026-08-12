# C907 cyclic-cover support bound

**Lane:** `clebsch`

**Status:** theorem-grade for the small-even quantum connection.

Let `X_(m,d)` be the smooth cyclic `m`-fold cover of `P^3` branched over a
smooth surface of degree `md`.  Equivalently,

\[
 X_{m,d}=\{y^m+f_{md}(x)=0\}\subset\mathbf P(1,1,1,1,d).
\]

Its index is `r=4-(m-1)d`.  The cover is Fano exactly when `r>0`.  Its ambient
period is

\[
 \Phi(s)=\sum_{n\ge0}\frac{(mdn)!}{(n!)^4(dn)!}s^n,
 \qquad s=q/z^r.
\]

Cancelling the denominator factors gives

\[
 \theta^4-C s
 \prod_{\substack{1\le l<md\\m\nmid l}}
 \left(\theta+\frac l{md}\right),
 \qquad C=\frac{(md)^{md}}{d^d}.
\]

Hence the zero-exponential scalar branches at `s=infinity` have exponents
`l/(md)` with `m` not dividing `l`.  The framed residue of such a branch is

\[
 \rho_l=\frac{rl}{md}-\frac32\pmod{\mathbf Z}.
\]

The remaining `r` branches are irregular.  As in the ordinary
complete-intersection calculation, their scalar prefactor is `t^(-3/2)` for
`t=s^(1/r)`; their framed residue is zero.

In the index-one cases the mirror coordinate shifts `h` by a scalar multiple
of `q`.  This adds a scalar term to `K`, changing the irregular exponential
but not the framed residues.

The inequality `(m-1)d<4` leaves only

\[
 (m,d)=(2,1),(2,2),(2,3),(3,1),(4,1).
\]

The corresponding primitive-sixth multiplicities are

\[
 0,\ 0,\ 0,\ 2,\ 0.
\]

The unique positive case `(3,1)` is the cyclic-cover subfamily of cubic
threefolds.  Therefore
every smooth Fano cyclic cover of `P^3` satisfies `nu_6<=2`; none can realize
the length-two carrier, which requires `nu_6>=4`.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: weighted
  projective mirror theorem.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.
- Cai, arXiv:2608.01577, Section 3: framed cubic convention.

## EJ/TT and mystery ledger

- **Settled:** the simplest smooth weighted-hypersurface class supplies no
  hidden length-two carrier.
- **TT:** the next weighted scan must allow several weighted coordinates or a
  non-hypersurface construction; another cyclic-cover enumeration has no EV.
- **Open:** whether any smooth weighted complete intersection has `nu_6>=4`.
