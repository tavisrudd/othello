# C907 proper collar and exterior excision gate

**Lane:** `clebsch`

**Status:** hostile-audited theorem specification.  The earlier total-family
product claim was false as stated: properness and relative homology must be
formulated on each fixed $\delta$ fibre, and controlled product structure
requires an explicit Whitney--Thom and interface-transversality certificate.
No collar or Stokes theorem is claimed here.

## Correct fibrewise object

Assume a future pair-of-pants gluing theorem supplies a proper graph

\[
\Pi:\mathcal G\longrightarrow\overline\Delta_\delta\times\Omega
\tag{1}
\]

over a **closed** sufficiently small parameter disk and a fixed residual path
neighborhood $\Omega$.  For each $\delta$ put

\[
\mathcal G_{\delta,\Omega}
=\Pi^{-1}(\{\delta\}\times\Omega),
\qquad L_\delta=L|_{\mathcal G_{\delta,\Omega}}.
\tag{2}
\]

The rapid-decay/Morse group is

\[
H_*\bigl(\mathcal G_{\delta,\Omega},
L_\delta^{-1}(u_0);\mathbf Z\bigr),
\tag{3}
\]

not the analogous pair on the total $\delta$-family.  Properness of (1) over
the closed parameter disk makes each $L_\delta$ proper over compact subsets of
$\Omega$; it would not make the total map to $\Omega$ proper over an open
parameter disk.

Exterior acyclicity must be proved separately on every fibre.  Transport from
$\delta=0$ to $\delta\ne0$ is a second, local analytic statement inside the
smooth residual Morse core; it is not a trivialization of the semistable
total family.

## Required controlled pair

Let $R_\delta$ be a controlled neighborhood of the four residual Morse points
and their distinguished paths, and let $P_\delta$ be an open thickening of its
exterior.  The interface cannot be an arbitrary sphere or path tube.  It must
come from a control function $\rho$ for which

\[
(L_\delta,\rho)
\tag{4}
\]

is a stratified submersion away from the four Morse points.  For a common
regular value $\varepsilon$, take the interface near
$\rho=\varepsilon$, including compatible path-tube end faces.  This is the
condition that prevents an artificial boundary from becoming tangent to an
$L_\delta$ fibre.

For each $\delta$, one must then construct an $L_\delta$-adapted Whitney
stratification of the pair $(P_\delta,I_\delta)$ compatible with

- the actual infinity boundary and exceptional complement of the original
  graph domain;
- the central-fibre strata and graph singular locus;
- all $\rho$-levels and path-tube end faces; and
- the reference fibre $L_\delta^{-1}(u_0)$.

It must not automatically refine the auxiliary pair-of-pants markings
$B=1,C=1$.  Those divisors lie in the original graph domain and the control
flow may cross them.  In the imbalanced charts, forgetting those markings and
keeping the residue coordinate $v$ interior retains the unit derivative
$\partial_vL=1$ and gives the explicit local lift from
`2026-08-12-c907-log-control-coarsening-lemma.md`.

The missing hypothesis is Thom $a_{L_\delta}$, not merely stratumwise
surjectivity of $dL_\delta$.  Once properness, $a_{L_\delta}$, and (4) are
verified, the proper Thom--Mather isotopy theorem gives controlled
trivializations of the fibrewise pairs

\[
(P_\delta,P_{\delta,u_0})
\simeq(P_{\delta,u_0}\times\Omega,
P_{\delta,u_0}\times\{u_0\})
\tag{5}
\]

and similarly for $I_\delta$.  A separate finite collar Cech cover is then
unnecessary.

## Conditional excision consequence

Assuming the literal product pairs (5), contractibility of the chosen path
neighborhood gives

\[
H_*(P_\delta,P_{\delta,u_0};\mathbf Z)=0,
\qquad
H_*(I_\delta,I_{\delta,u_0};\mathbf Z)=0.
\tag{6}
\]

Choose open thickenings $P_\delta^\circ,R_\delta^\circ$ forming an excisive
triad with controlled overlap $I_\delta^\circ$.  Relative
Mayer--Vietoris then gives the natural conditional isomorphism

\[
H_*\bigl(\mathcal G_{\delta,\Omega},L_\delta^{-1}(u_0)\bigr)
\cong
H_*\bigl(R_\delta,R_{\delta,u_0}\bigr).
\tag{7}
\]

Equation (7) alone does not identify the directed Stokes form.  One must also
prove that the controlled isotopy and excision preserve boundary orientation,
the distinguished path system, and the relative intersection/Seifert
pairing.

## Residual transport still required

Inside the compact Morse core, the four critical values should vary
analytically without a braid.  A parameterized holomorphic Morse lemma can
then compare $\delta=0$ to small $\delta\ne0$ while preserving the marked
paths and pairing.  At the central point the local potential is

\[
f_Q(y)+ZU.
\tag{8}
\]

Only after the pairing-compatibility lemma may Thom--Sebastiani yield the
unmarked Beilinson matrix

\[
\begin{pmatrix}
1&4&10&20\\
0&1&4&10\\
0&0&1&4\\
0&0&0&1
\end{pmatrix}.
\tag{9}
\]

The Gamma/Orlov marking remains a further theorem.  Its proposed seed cannot
be promoted while the global graph, value-neighborhood, and fibrewise collar
hypotheses remain unproved.

## Checklist before promotion

1. Passing serialized log refinement and saturated graph-overlap replay.
2. Actual-boundary/control-stratum Fitting audit and finite excluded-value
   list, after forgetting auxiliary translated markings.
3. Proper graph over a closed parameter disk and fixed path neighborhood.
4. Fibrewise Whitney--Thom $a_L$ certificate compatible with the actual
   topological boundary, using the coarser control rather than the full
   auxiliary log partition.
5. Controlled interface function with $(L,\rho)$ submersive.
6. Excisive open triad and pairing-preserving isotopy/excision lemma.
7. Local parameterized Morse transport in $R$, separate from the exterior.

## EJ/TT and mystery ledger

- **EJ:** formulate the topology directly as one proper controlled
  trivialization of the fibrewise exterior/interface pairs; this removes the
  unnecessary finite-intersection Cech layer.
- **TT:** a stratumwise submersion is not a controlled product theorem, and a
  total-family relative group is not the fixed-parameter Morse group.
- **Settled:** the correct fibrewise statement and the exact hypotheses under
  which relative Mayer--Vietoris would isolate the residual group.
- **Refuted:** the earlier unconditional total-family product-pair theorem.
- **Open evidence gap:** every item in the promotion checklist, beginning with
  the algebraic gluing gate.
