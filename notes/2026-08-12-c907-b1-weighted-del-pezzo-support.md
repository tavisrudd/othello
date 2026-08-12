# C907 degree-one weighted del Pezzo support audit

**Lane:** `clebsch`

**Status:** theorem-grade for the small-even quantum connection.

Let

\[
 B_1=\{f_6=0\}\subset\mathbf P(1,1,1,2,3)
\]

be a smooth sextic.  This is the index-two, degree-one del Pezzo threefold:
`-K=2H` and `H^3=1`.  The two stacky points of the ambient weighted
projective space have weights `2` and `3`; a smooth sextic avoids them (the
coefficients of the respective monomials `y^3` and `z^2` are nonzero).
Thus its ordinary even cohomology is the ambient rank-four space
`<1,H,H^2,H^3>`.

The weighted-projective `I`-function and quantum Lefschetz give its
small-even period

\[
 \Phi(s)=\sum_{n\ge0}
 \frac{(6n)!}{(n!)^3(2n)!(3n)!}s^n,
 \qquad s=q/z^2.
\]

Its coefficient recurrence is

\[
 \frac{a_{n+1}}{a_n}
 =432\frac{(n+1/6)(n+5/6)}{(n+1)^4},
\]

and hence its rank-four scalar operator is

\[
 L=\theta^4-432s(\theta+1/6)(\theta+5/6). \tag{1}
\]

At `s=infinity` the two zero-exponential branches are `s^(-1/6)` and
`s^(-5/6)`.  If `t=s^(1/2)`, the other two branches have exponential
factors `exp(\mathord\pm24\sqrt3\,t)` and scalar prefactor `t^(-3/2)`:
substitution of `exp(lambda t)t^alpha` in (1) gives
`lambda^2=1728` and then `alpha=-3/2`.

For a threefold, the scalar-to-framed lift has residue shift `-3/2`:
in the equation `z^2 partial_z S=(K+zG)S`,
`G|H^(2j)=3/2-j`, and the cyclic lift has components
`z^(j-3/2) theta^j Phi` up to constant rescaling.  Thus the two
zero-exponential branches have framed residues

\[
 2\cdot\frac16-\frac32=-\frac76\equiv-\frac16,
 \qquad
 2\cdot\frac56-\frac32=\frac16\pmod{\mathbf Z};
\]

the two irregular branches have integral residue.  Therefore

\[
 \chi_{B_1}(T)=(T-1)^2(T^2-T+1),\qquad \nu_6(B_1)=2.
\]

This is a positive non-complete-intersection weighted Fano calibration, but
still has only one primitive pair and cannot realize a length-two cubic
carrier.  It makes no claim about the odd sector or the operation-framed
carrier object.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: the weighted
  projective `I`-function.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.
- Cai, arXiv:2608.01577, Sections 2--3: the framed `z`-connection and the
  threefold grading convention.

## Mystery ledger

- **Settled:** the degree-one weighted del Pezzo family supplies a non-CI
  positive calibration with exactly one, not two, primitive pairs.
- **Open:** a weighted complete intersection with at least four framed
  primitive-sixth residues, or a structural reason it cannot occur.
