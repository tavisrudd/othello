# C907 $B=\infty$, $C\notin\{0,1,\infty\}$ mixed-star certificate

**Lane:** `clebsch`

**Status:** exact infinity/one-pole exterior-star calculation; no global fan
claim.

## Chart and central graph

Use `B=delta^(-beta)b` with `beta>0`, `C=c`, and invert `c(1-c)`.  After
clearing rational weights by a ramified base change, put

\[
y_i=\delta^{-p_i}x_i,\qquad p=\sum_i p_i,
\qquad m=\max\{2+\beta,p_1,p_2,p_3,-p-\beta\}.
\tag{1}
\]

All `x_i,b,c,1-c` are chart units.  The monomial-normalized saturated graph
is

\[
\begin{aligned}
G=Xbc\bigg(&\delta^mL-\sum_i\delta^{m-p_i}x_i
-\delta^{m+p+\beta}\frac Q{Xbc}
-\delta^{m-2}(1-c)\\
&+\delta^{m-2-\beta}b(1-c)\bigg)=0.
\end{aligned}
\tag{2}
\]

It agrees with `delta^m Xbc(L-F_delta)` on the dense torus.  Since at least
one coefficient has order zero, and all chart units have been inverted, (2)
is the saturated graph ideal.  Its central reduced graph is

\[
H=\sum_{p_i=m}x_i+
\mathbf1_{-p-\beta=m}\frac Q{Xbc}
-\mathbf1_{2+\beta=m}b(1-c)=0.
\tag{3}
\]

No $L$ term survives.

## Exact tangent-Fitting calculation

The single-term supports are empty.  For a support containing exactly one of
the polar term $P=Q/(Xbc)$ and the positive-pole term $R=b(1-c)$, the
logarithmic `b` derivative is a unit on $H=0$.  If neither occurs, an
occurring `x_i` has unit logarithmic derivative.  The only potentially mixed
case contains both.  Write

\[
H=T+P-R,\qquad T=\sum_{i\in I}x_i.
\]

At a tangent critical point, `D_bH=-P-R=0`, hence $P=-R$.  If any index is
absent from $I$, its logarithmic derivative is `-P`, impossible on the
torus.  If $I=\{1,2,3\}$, then $D_{x_i}H=x_i-P=0$ gives
$x_i=P$, while $H=0$ gives $3P+P-R=5P=0$, again impossible in
characteristic zero.  Thus every nonempty central graph is smooth.  It is
already reduced and normal, the total graph is smooth along it, and $L$ is
a free coordinate, so $dL$ is a cotangent direct summand.  The
reduced-stratum relative tangent-Fitting ideal is
therefore `(1)`: every nonempty cone is **free**.

There is no residual outcome, since the marked residual center is
`B=C=1`.  The excluded faces `c=0` and `c=1` are respectively a two-infinity
corner and an infinity/translated seam; neither is included in this theorem.

## Finite replay

The five leading terms are

\[
x_1,x_2,x_3,Q/(Xbc),b(1-c).
\]

The Singular replay enumerates all 31 nonempty supports, saturates the graph
by `Xbc(1-c)`, and only then computes the tangent ideal using the three
logarithmic `x_i` derivatives, the logarithmic `b` derivative, and ordinary
`c` derivative.  It reports 5 empty masks, 26 free masks, and no holds.
The computation verifies the mixed $P-R$ case that a bare pole-order count
does not decide.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-binf-cunit-star-fan.sing \
  > notes/2026-08-12-c907-binf-cunit-star-fan.out
```

The displayed derivative argument is independent of the computer algebra
replay and establishes the reduction/normality step before Fitting.

To check the tracked output without changing it:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-binf-cunit-star-fan.sing | \
  cmp -s - notes/2026-08-12-c907-binf-cunit-star-fan.out
```

The script and canonical output are 2,012 and 931 bytes; their SHA-256 values
are recorded in `2026-08-12-c907-binf-cunit-star-fan.sha256`.

## Relation to the positive-pole product lemma

The positive-pole observation is useful but not sufficient by itself.  It
forces the $R=b(1-c)$ term to occur at order $2+\beta$, so it gives the
empty alternative when that term is unique.  It does not exclude cancellation
with $P$ and all three `x_i`; the five-support calculation above is exactly
the missing tangent-Jacobian step.  Thus the product lemma supplies the
valuation prefilter but does **not** subsume this certificate unless it is
strengthened to the same Fitting assertion.

## Coverage and boundary accounting

This closes the `B=infinity`, `C`-generic star for arbitrary `y` weights.
Interchanging `B,C` gives its symmetric companion.  With the previously
closed two-pole and two generic finite one-pole stars, five exterior star
types now have exact empty/free certificates.  Still separate are the
translated seams, the two-infinity corner, generic and intersecting
`B=1`/`C=1` stars, their noncompact refinements, and global fan/collar data.
No final cone count is claimed.

## EJ/TT and mystery ledger

- **EJ:** the infinity star has the same finite five-support size as the
  finite one-pole star, despite the extra pole order.
- **TT:** the mixed `P-R` support is the necessary check that prevents a
  misleading ``unique dominant pole'' argument.
- **Settled:** this infinity/one-pole star and its `B,C` swap are empty/free.
- **Open:** the named seams, corners, and global compactification remain;
  no genuine mystery remains inside this star.
