# C907 coarse control-stratum ledger

**Lane:** `clebsch`

**Status:** hostile-audited finite theorem specification.  It identifies the
global topological strata on which tangent/Fitting calculations must be
replayed after the algebraic pair-of-pants atlas is coarsened.  It does not
claim that the required regular modification or replay has been constructed.

## True boundary versus auxiliary markings

Let

\[
\mathcal U_0=
\{\delta\ne0,\ y_1y_2y_3\ne0,\ b_0b_1c_0c_1\ne0\}
\tag{1}
\]

be the original graph domain.  On a regular modification isomorphic over
$\mathcal U_0$, the true divisorial boundary is the total transform of

\[
D_{\mathrm{true}}=
\{\delta=0\}\cup(X_y\setminus T_y)
\cup\{B=0,\infty\}\cup\{C=0,\infty\}.
\tag{2}
\]

The control labels of each marked projective line are therefore

\[
\{0,g,\infty\},\qquad
g=\mathbf P^1\setminus\{0,\infty\}.
\tag{3}
\]

In particular, $g$ contains $1$.  The ten orbit types obtained by separating
$1$ are an auxiliary algebraic atlas, not the control partition.  The
equations $B=1,C=1$, and the zero loci of residual coordinates may be crossed
by a control vector field.

## Finite coarse ledger

Every exterior row below is further indexed by every cone $\sigma$ and face
$\tau$ of the eventual regular $y/\delta$ refinement.

| coarse piece | auxiliary reports/charts | exact certificate | target outcome |
| --- | --- | --- | --- |
| open interior, $\delta\ne0$ | original torus graph | bounded-value logarithmic-gradient and value-separation certificate | no critical point over $\Omega$ outside the residual neighborhood |
| $E_{00}$ | $(0,0)$ | full initial ideal; unit tangent derivative or empty ideal | empty/free |
| $E_{0g},E_{g0}$ | $(0,g)$ and translated-one seams | same, with $B=1,C=1$ unsplit | empty/free |
| $E_{0\infty},E_{\infty0}$ | $(0,\infty)$ and symmetric seam | full initial ideal | empty/free |
| $E_{g\infty},E_{\infty g}$ | $(g,\infty)$ and translated-one seam | unit tangent derivative, or elimination to $L=0$ | free, or absent because $0\notin\Omega$ |
| $E_{\infty\infty}$ | $(\infty,\infty)$ | full initial ideal | empty/free |
| $E_{gg}\setminus N_R$ | generic, translated-one, and double-one charts | full **coarse** tangent module, with translated and residual axes unsplit | empty/free |
| bounded residual neighborhood $N_R$ | exact bounded chart | full relative Fitting ideal | the four-section relative critical scheme $\mathscr R$ |
| $N_R\setminus\mathscr R$, including the future controlled interface | exact bounded chart localized away from $\mathscr R$ | same Fitting ideal | free |
| $Z$- and $W$-imbalanced charts, including all $r=0,h=0$ faces | $r=Z^{-1},v=ZW,\delta=rh$ and its swap | retain $v$ as tangent; $\partial_vL$ is a unit | free |
| special residual fibre $\mathscr R_0$ | central bounded chart | $Z=W=0$, $y_i=a$, $a^4=Q$, $L=4a$, nonzero relative Hessian | four reduced Morse points |

The minimal replay record is

\[
(\alpha,\beta,\sigma,\tau;
J_{\alpha\beta\sigma\tau},
T_{\alpha\beta\sigma\tau},
\operatorname{Fitt}_{d-1}\mathcal M_T,
\mathrm{outcome}),
\tag{4}
\]

where:

- $(\alpha,\beta)\in\{0,g,\infty\}^2$ is the coarse projective-line label;
- $\sigma$ is a regular support cone and $\tau$ one of its faces;
- $J$ is the saturated full initial ideal, including the pair-of-pants
  equations and residue constraints;
- $T$ is the globally defined reduced coarse control stratum; and
- the outcome is `empty`, `unit/free`, `L=0 excluded`, or the displayed
  four-point Morse ideal.

For this fixed $T$ one computes

\[
\mathcal M_T=
\Omega^1_{(\mathcal G\cap T)_{\mathrm{red}}/\Delta}/
\mathcal O\,dL.
\tag{5}
\]

Only then may localization be used to identify Fitting ideals on overlaps.

## Fine-to-coarse transfer rules

There are exactly two legitimate transfers from the ten auxiliary reports.

1. A fine report transfers to coarse freeness only when it exhibits a
   derivation $\xi$ tangent to the reduced coarse stratum $T$, with
   $\xi L\in\mathcal O_T^\times$.  Being a unit only after quotienting by
   the finer-stratum ideal is insufficient.  In particular, a literal
   identity $\partial_vL=1$ transfers when $v$ remains tangent.
2. A fine restricted Fitting calculation does not transfer automatically.
   It must be recomputed on the induced reduced coarse stratum.

The second rule is load-bearing.  In the imbalanced chart

\[
W=rv,\qquad\delta=rh,\qquad
1-C=r^2h(v-hA),
\tag{6}
\]

$v=0$ is the closure of the interior equation $W=0$, while $C=1$ has strict
transform $v-hA=0$.  Neither is saturated away and neither is a coarse
control stratum.  Hence $dv$ survives; the unit $\partial_vL$ eliminates the
false $h=0$ and $h=2$ restricted packets.

The central-fibre residual calculation is confined to the bounded chart:

\[
L=f_Q+ZW,
\quad Z=W=0,
\quad y_1=y_2=y_3=a,
\quad a^4=Q,
\quad L=4a.
\tag{7}
\]

Its relative Hessian is nondegenerate.  No additional non-Morse residual
value survives coarsening.  The exterior constant value $L=0$ is removed by
choosing $\Omega\Subset\mathbf C^*$.

For $\delta\ne0$, (7) is the special fibre of four nearby analytic critical
sections, not the full-family critical scheme.  Their exact dense-torus
description is

\[
y_i=P,\qquad B=C=b,\qquad
P=-\delta^{-2}b(1-b),\qquad
b^6(1-b)^4=Q\delta^8,
\tag{8}
\]

with

\[
L=\delta^{-2}(1-b)(1-5b).
\tag{9}
\]

On the four branches $b\to1$, these values tend to $4a$, $a^4=Q$.  In the
bounded residual coordinates one has $Z=W=\delta^3z^2$ after
$b=1-\delta^2z$, so $Z=W=0$ only on $\mathscr R_0$.  Nondegeneracy at
$\delta=0$ and openness make $\mathscr R\to\Delta$ relative Morse after
shrinking.

## Exact dense-interior separation

The exact reduction (8) gives all ten dense-torus critical points for small
nonzero $\delta$.  Four are the sections $\mathscr R$.  The remaining six
satisfy $b=O(\delta^{4/3})$ and

\[
\delta^2L=(1-b)(1-5b)\longrightarrow1.
\tag{10}
\]

Thus the six ambient values escape every fixed compact $\overline\Omega$.
The saturated critical-scheme reduction, discriminant, and root separation
are proved and replayed in
`2026-08-12-c907-bounded-value-interior.md`.  The first ledger row is closed;
boundary escape and all-point attachment remain the full-initial/Fitting
gate.

## EJ/TT and mystery ledger

- **EJ:** the ten marked orbit types collapse to a $3\times3$ true-boundary
  ledger plus one bounded residual core and two imbalanced transition charts.
  Unit tangent directions transfer upward under coarsening; restricted
  Fitting schemes do not.
- **TT:** algebraic refinement and control refinement move critical schemes
  in opposite ways.  Marking an interior divisor can create a critical locus
  by deleting its normal cotangent direction.
- **Settled:** the global labels of the coarse boundary; the local imbalanced
  transfer; the exhaustive list of possible outcomes; the absence of a
  genuine $h=2$ residual value; and exact dense-torus bounded-value
  separation into four residual and six escaping branches.
- **Open:** attach every cone and face to a full initial ideal; recompute (5)
  on every coarse boundary stratum; and construct the controlled interface.
