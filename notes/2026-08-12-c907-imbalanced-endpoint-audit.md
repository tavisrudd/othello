# C907 imbalanced endpoint artificial-face audit

**Lane:** `clebsch`

**Status:** exact coordinate-face warning with hashed Singular replay.  The
full imbalanced central chart is free.  Two four-point packets appear only if
$v=0$ is artificially declared a stratum, so a valid log/control model must
keep $v$ as an interior coordinate.  This note does not classify the other
exceptional strata of a global refinement.

## The imbalanced chart

In the $Z^{-1}$ chart put

\[
r=Z^{-1},\qquad v=ZU,\qquad \delta=rh,
\qquad A=\frac QY,\qquad S=y_1+y_2+y_3.
\tag{1}
\]

The exact identities are

\[
B=1-h+r^2h^2A,\qquad
C=1-r^2hv+r^2h^2A,
\tag{2}
\]

and the exact potential is

\[
\Phi=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
\tag{3}
\]

The reduced central fibre is $r=0\cup h=0$.  On either component and their
intersection,

\[
\partial_v\Phi=1.
\tag{4}
\]

Consequently the relative tangent-Fitting ideal on the full imbalanced
central chart is the unit ideal.  The true residual Morse points lie in the
bounded $(Z,U)$ chart, not this affine $Z^{-1}$ chart.

The coordinate $v$ is a smooth residue coordinate along the imbalanced
boundary.  It is not automatically a divisor of the log structure and must
remain unsplit in the control stratification.

## Artificial-face two-packet lemma

If one nevertheless deletes the $v$ direction by imposing $r=v=0$, then

\[
\Phi=S+\frac A{1-h}-hA.
\tag{5}
\]

With $A$, $Y$, and $1-h$ inverted, its restricted tangent scheme is the
disjoint union

\[
\mathcal C_Q\sqcup\mathcal C_{-3Q},
\tag{6}
\]

where

\[
\begin{aligned}
\mathcal C_Q:
&\quad h=0,\quad y_1=y_2=y_3=a,\quad a^4=Q,
\quad L=4a,\\
\mathcal C_{-3Q}:
&\quad h=2,\quad y_1=y_2=y_3=b,\quad b^4=-3Q,
\quad L=4b.
\end{aligned}
\tag{7}
\]

Both schemes are reduced and all eight geometric points are Morse for the
restricted $(y,h)$ function.  They are not critical points of the full map,
because the discarded normal derivative is (4).  The symmetric $U^{-1}$
chart exchanges $B,C$ and gives the identical warning.

### Proof

Let

\[
c(h)=\frac1{1-h}-h=\frac{h^2-h+1}{1-h}.
\tag{8}
\]

The cleared tangent equations of (5) are

\[
Ah(2-h)=0,\qquad
(1-h)y_i-A(h^2-h+1)=0.
\tag{9}
\]

Because $A$ and $1-h$ are units, only $h=0,2$ occur.  At $h=0$ the equations
give $y_i=A=a$ and $a^4=Q$.  At $h=2$ they give $y_i=-3A=b$ and
$b^4=-3Q$.  Substitution gives the values in (7), proving that there is no
third finite branch.

At a symmetric critical point with common coordinate $x$, the ordinary
$y$-Hessian is

\[
\frac1x(I_3+J_3),\qquad \det=\frac4{x^3}.
\tag{10}
\]

The mixed $h,y$ derivatives vanish.  The $h$-second derivative is $2a$ at
$h=0$ and $2b/3$ at $h=2$, so the full restricted Hessian determinants are

\[
\frac8{a^2},\qquad \frac8{3b^2}.
\tag{11}
\]

Both are nonzero.  The replay independently verifies the exact ideal
decomposition and radicality over $\mathbf Q(Q)$.

## Structural consequence

The artificial value packets

\[
\Lambda_Q=\{4a:a^4=Q\},\qquad
\Lambda_{-3Q}=\{4b:b^4=-3Q\}
\tag{12}
\]

are disjoint.  But value quarantine is not the correct repair: the artificial
$h=0$ packet has the desired residual values themselves.  The repair is to
ensure that the regular log refinement does not add $v=0$ to its boundary
complex.  Then (4) proves the entire chart free.

Thus the finite refinement ledger must distinguish genuine boundary divisors
from smooth chart coordinates.  Treating every coordinate zero as a log face
manufactures false critical schemes.

## Replay

From the repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-imbalanced-endpoint.sing | \
  cmp -s - notes/2026-08-12-c907-imbalanced-endpoint.out
```

The replay uses Singular 4.4.1.  It saturates by $AY(1-h)$, checks equality
with the intersection of the two ideals in (7), and checks radicality.  The
adjacent SHA-256 manifest pins the script and canonical output.

## EJ/TT and mystery ledger

- **EJ:** one unit derivative, $\partial_v\Phi=1$, removes the entire
  imbalanced chart from the critical audit.  The factor $h(2-h)$ is retained
  as a regression test against refinements that accidentally mark $v=0$.
- **TT:** not every coordinate zero is a log stratum.  Deleting the $v$
  direction manufactures two false Morse packets.
- **Settled:** full-chart imbalanced freeness; exact artificial-face
  decomposition, absence of further branches, reducedness, Hessians, values,
  and the symmetric copy.
- **Open evidence gap:** construct the regular refinement while keeping $v$
  interior, and audit only its genuine log strata.
