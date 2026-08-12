# C907 `(2,3)` Fano positive carrier regression

**Lane:** `clebsch`

**Status:** candidate pending convention and rigidity cold audit.  It is the
first explicit non-cubic threefold with one primitive-sixth pair, hence a
length-one calibration rather than a length-two counterexample.

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

After the standard threefold scalar-to-framed `z^(1/2)` calibration, the
framed residues are

\[
 0,\quad0,\quad\frac16,\quad\frac56
 \pmod{\mathbf Z}.
\]

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

A general member is expected to be outside the cubic birational class by
birational rigidity of general index-one Fano complete intersections.  This
scope and the framed convention in (2) remain to be checked against the
primary sources before promotion from candidate to regression.

## Source spine

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31.
- Coates--Givental, arXiv:math/0110142, Theorem 2.
- Pukhlikov, *Birationally rigid Fano complete intersections*, J. Reine
  Angew. Math. 541 (2001), 55--79.

## Mystery ledger

- **Candidate:** a genuine non-cubic primitive-sixth length-one calibration.
- **Open audit:** framed shift, full even-module rank, and exact rigidity scope.
- **Open search:** an explicit smooth threefold with `nu_6>=4` on which the
  self-dual length-two Rees extension can be tested.
