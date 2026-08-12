# C907 `(2,3)` Fano positive carrier regression

**Lane:** `clebsch`

**Status:** theorem-grade small-even calculation; birational placement remains
outside the proof.  It is the first explicit non-cubic threefold with one
primitive-sixth pair, hence a length-one calibration rather than a length-two
counterexample.

Let

\[
 V=Q_2\cap C_3\subset\mathbf P^5
\]

be a general smooth complete intersection.  It is a Picard-rank-one Fano
threefold with `-K_V=H` and `H^3=6`.

Its ambient period is

\[
 \Phi(s)=\sum_{d\ge0}\frac{(2d)!(3d)!}{(d!)^6}s^d,
 \qquad s=q/z,
\]

with scalar operator

\[
 L=\theta_s^4-108s
 (\theta_s+\tfrac12)(\theta_s+\tfrac13)
 (\theta_s+\tfrac23).
 \tag{1}
\]

At `s=infinity`, the zero-exponential branches have scalar powers

\[
 s^{-1/2},\qquad s^{-1/3},\qquad s^{-2/3},
\]

and the fourth branch is

\[
 e^{108s}s^{-3/2}(1+\cdots).
\]

The ambient cyclic companion has components
`z^(j-3/2) theta_s^j Phi`.  Thus a scalar branch `s^(-a)` has framed residue
`a-3/2` modulo integers.  The framed residues are

\[
 0,\quad0,\quad\frac16,\quad\frac56
 \pmod{\mathbf Z}.
\]

The index-one mirror coordinate replaces `h` by `h+12q`.  This adds a scalar
term to `K`, changing only the irregular exponential and not the framed
residues above.

Thus the predicted framed characteristic polynomial is

\[
 \chi_{T_f}(T)=(T-1)^2(T^2-T+1),
 \qquad \nu_6(V)=2.
 \tag{2}
\]

This supplies one primitive pair, exactly the amount compatible with
`ell_(1/6)=1`.  A length-two carrier needs at least two primitive pairs, hence
`nu_6>=4`.  Therefore `V` is the right first strictness/Gamma calibration for
the proposed carrier object but cannot by itself falsify the universal bound.

No birational-rigidity assertion is used here.  The exact birational placement
of a general `(2,3)` member remains a separate primary-source audit.

## Source spine

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31.
- Coates--Givental, arXiv:math/0110142, Theorem 2.
- Cai, arXiv:2608.01577, Section 3: framed cubic convention.
- Hu, arXiv:1501.03683, Theorem 2.1 and (33): index-one mirror coordinate.
- Pukhlikov, *Birationally rigid Fano complete intersections*, J. Reine
  Angew. Math. 541 (2001), 55--79.

## Mystery ledger

- **Settled:** a genuine non-cubic primitive-sixth length-one calibration in
  the full small-even connection.
- **Open audit:** exact birational-rigidity scope; non-load-bearing here.
- **Open search:** an explicit smooth threefold with `nu_6>=4` on which the
  self-dual length-two Rees extension can be tested.
