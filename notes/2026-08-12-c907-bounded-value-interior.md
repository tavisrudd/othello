# C907 dense-torus bounded-value separation

**Lane:** `clebsch`

Fix $Q\ne0$, write $Y=y_1y_2y_3$, and take

\[
 F_\delta=y_1+y_2+y_3+\frac Q{YBC}
 +\delta^{-2}(1-B)(1-C).
\]

This note concerns the critical scheme on the dense torus only.  It neither
constructs a common pair-of-pants modification nor proves any overlap or
collar statement.

## Exact critical scheme

Put $P=Q/(YBC)$.  The five logarithmic critical equations are

\[
 y_i-P=0,\qquad
 P=-\delta^{-2}B(1-C)=-\delta^{-2}C(1-B).
\]

The last equality gives $B=C=b$, so

\[
 y_1=y_2=y_3=P,qquad
 P=-\delta^{-2}b(1-b),\qquad
 b^6(1-b)^4=Q\delta^8. \tag{1}
\]

The critical value is

\[
 L=F_\delta=4P+\delta^{-2}(1-b)^2
 =\delta^{-2}(1-b)(1-5b). \tag{2}
\]

For the exact algebraic convention, begin with the cleared graph

\[
 \delta^2YBC(L-S)-\delta^2Q-YBC(1-B)(1-C)=0,
\]

where $S=y_1+y_2+y_3$.  Dividing on the dense torus gives the displayed
Laurent equation $L-F_\delta=0$; the two forms differ by the unit
$\delta^2YBC$.  The replay introduces $P$, clears no additional dense
factor, and saturates only by $y_1y_2y_3BC$.

## Count and nondegeneracy

For fixed nonzero $\delta$, equation (1) has degree ten.  Its derivative is

\[
 h'(b)=2b^5(1-b)^3(3-5b).
\]

On the dense torus the only possible repeated root is $b=3/5$, requiring

\[
 5^{10}Q\delta^8=3^6 2^4.
\]

It is therefore absent for all sufficiently small nonzero $\delta$.  There
are then exactly ten reduced, nondegenerate dense-torus critical points.  The
exact replay identifies the saturated six-equation critical ideal with (1)
and computes its univariate Jacobian as $\delta^2h'(b)$.

## Four bounded and six escaping branches

At $\delta=0$, (1) has multiplicity four at $b=1$ and multiplicity six at
$b=0$.  The analytic branches therefore split $4+6$ for small nonzero
$\delta$.

For the four $b\to1$ branches, the relation
$P=-\delta^{-2}b(1-b)$ and $P^4b^2=Q$ gives

\[
 P\longrightarrow a,\quad a^4=Q,\qquad
 L=P\frac{5b-1}{b}\longrightarrow4a.
\]

For the six $b\to0$ branches, after a finite ramification
$b=\delta^{4/3}c$, equation (1) gives $c^6\to Q$.  Equation (2) gives

\[
 \delta^2L=(1-b)(1-5b)\longrightarrow1.
\]

This convergence is uniform over the finite six-branch packet.  Hence those
six values leave every fixed bounded value disk, while the other four converge
to the residual values $4a$, $a^4=Q$.  This is the required dense-torus
bounded-value separation.

## Exact replay

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-bounded-value-interior-replay.sing | \
  cmp -s - notes/2026-08-12-c907-bounded-value-interior-replay.out
```

The direct branch argument above is independent of the Groebner calculation.

## EJ/TT and mystery ledger

- **EJ:** five logarithmic equations collapse to one degree-ten polynomial.
  Its $6+4$ multiplicity split simultaneously counts every critical point
  and separates ambient escape from the residual packet.
- **TT:** boundary freeness alone does not rule out bounded-value interior
  escape.  The scalar value formula (2), not support enumeration, supplies
  the required uniform separation.
- **Settled:** the full dense-torus critical scheme, its discriminant, the
  four residual sections, and the six escaping values.
- **Open:** the pair-of-pants boundary attachment, coarse-stratum Fitting
  replay, and controlled residual interface.
