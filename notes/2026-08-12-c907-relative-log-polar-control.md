# C907 relative log-polar control from a schön graph

**Lane:** `clebsch`

**Status:** exact conditional control theorem and a negative answer to the
proposed shortcut.  Relative schönness supplies a proper regular graph model,
but no choice of regular tropical subdivision makes coarse value-submersivity
follow from graph initials alone.  The missing datum is *coarse log-polar
strictness and nondegeneracy*.  Once that datum is certified, a finite polar
replay does imply the whole exterior Fitting ledger without a chart-by-chart
topological argument.

## Setup: the two boundary structures

Keep the value coordinate in the base torus

\[
 S=\mathbb G_{m,L},\qquad R=\mathbb C[[\delta]],
\tag{1}
\]

and compactify only the seven escaping coordinates of the relative graph

\[
 B+U=1,\quad C+V=1,\quad
 L=\sum_i y_i+\frac{Q}{y_1y_2y_3BC}+\delta^{-2}UV.
\tag{2}
\]

The relative-schön theorem gives a regular proper strict graph
\(\overline{\mathcal G}_\Sigma\to\Delta\times S\) after any regular
subdivision of its certified relative tropical support.  Its fine toroidal
boundary includes the auxiliary pair-of-pants divisors `U=0` and `V=0`.
They are not boundary of the original graph: the actual reduced boundary is
the total transform of

\[
 D_{\rm act}=\{\delta=0\}\cup(X_y\setminus T_y)
 \cup\{B=0,\infty\}\cup\{C=0,\infty\}.
\tag{3}
\]

Write \(T_I\) for a reduced actual-boundary stratum, defined by a set \(I\)
of components of (3).  It is deliberately not cut by `U=0`, `V=0`, `B=1`,
or `C=1`.  In particular its two marked-line labels are
\(\{0,g,\infty\}^2\), with \(g\) containing `1`.

For \(d_I=\dim((\overline{\mathcal G}_\Sigma\cap T_I)/\Delta)\), the
only intrinsic critical module is

\[
 \mathcal M_I=
 \Omega^1_{(\overline{\mathcal G}_\Sigma\cap T_I)_{\rm red}/\Delta}
 /\mathcal O\,dL,
 \qquad
 \operatorname{Crit}_I(L)=\operatorname{Fitt}_{d_I-1}(\mathcal M_I).
\tag{4}
\]

This order of operations is essential: taking a fine face first changes the
cotangent quotient and is not base change of (4).

## Why graph schönness is not polar schönness

On an order-zero graph initial one has

\[
 F_\sigma=L-H_\sigma=0.
\tag{5}
\]

The unit \(\partial_LF_\sigma=1\) proves that the graph initial is smooth.
But the restriction of \(L\) to that graph is critical precisely where
\(dH_\sigma\) vanishes in the tangent directions of the **coarse** stratum.
Thus graph smoothness makes no statement about (4).  At positive order, an
initial in which `L` is absent does make `L` a free coordinate and is
automatically safe; the issue is the order-zero family (5), including
partial degenerations through `U=0` or `V=0`.

This distinction remains after leaving `L` uncompactified.  The usual
counterexample \(L=x\) on \(\mathbb A^2_{x,y}\), blown up at the origin,
has exceptional divisor on which \(L=0\); it lies outside the present base
torus.  Its translated version does not:

\[
 L=\ell+x,\quad \ell\in\mathbb C^*,
\tag{6}
\]

has the same regular blowup chart \(x=u, y=uv\), but on the exceptional
divisor \(u=0\) the value map is the constant \(\ell\in S\).  Hence the
uncompactified value line removes only the accidental value zero, not the
blowup obstruction.  Any theorem deducing submersivity from regularity or
ordinary schönness would falsely certify (6).

## Coarse partial initials and the polar condition

Fix a fine cone \(\sigma\), a face \(\tau\), and a residue chart which meets
one actual type \(I\).  Form the saturated strict Rees chart using the full
pair-of-pants equations, then impose only the actual equations defining
\(T_I\).  Do **not** impose an auxiliary `U=0` or `V=0` equation.  Its
reduced associated-graded chart is denoted

\[
 \operatorname{pIn}_{\sigma,\tau,I}(\mathcal G).
\tag{7}
\]

It is a *partial* initial degeneration: it remembers all rates which land on
the same actual stratum while retaining the translated residue directions.
It is not, in general, an ordinary torus-orbit initial and cannot be recovered
by merely deleting `U,V` from a support mask.

Define its coarse log-polar module and ideal by

\[
 \begin{aligned}
 \mathcal M^{\rm in}_{\sigma,\tau,I}
 &=\Omega^1_{\operatorname{pIn}_{\sigma,\tau,I}(\mathcal G)/\Delta}
     /\mathcal O\,dL,\\
 \mathcal P_{\sigma,\tau,I}
 &=\operatorname{Fitt}_{d_I-1}
      (\mathcal M^{\rm in}_{\sigma,\tau,I}).
 \end{aligned}
\tag{8}
\]

All reductions and localizations by genuine residue units occur before (8).
The needed additional hypothesis is the following strictness assertion:

\[
 \operatorname{gr}_{\sigma,\tau}
 \left(\Omega^1_{(\overline{\mathcal G}_\Sigma\cap T_I)_{\rm red}/\Delta}
       /\mathcal O\,dL\right)
 \;\cong\;
 \mathcal M^{\rm in}_{\sigma,\tau,I}.
 \tag{PS}
\]

Call (PS) **coarse log-polar strictness**.  It is stronger than flatness of
the graph Rees algebra: differentials, reduction, and quotient by `dL` have
to commute with the partial degeneration.  Equivalently in a presentation,
the tangent Jacobian/Fitting minors must have their displayed partial initials
after true saturation; taking the minors only after a fine-face quotient is
not equivalent.

The accompanying **coarse log-polar nondegeneracy** condition over a fixed
bounded \(\Omega\Subset\mathbb C^*\) is

\[
 V(\mathcal P_{\sigma,\tau,I})\cap L^{-1}(\Omega)=\varnothing
 \tag{PN}
\]

for every exterior actual type \(I\).  On the bounded residual core it is
replaced by the prescribed four-section polar scheme \(\mathscr R\), whose
central fibre is

\[
 Z=W=0,\quad y_1=y_2=y_3=a,\quad a^4=Q,\quad L=4a.
\tag{9}
\]

There is a useful polyhedral restatement.  Let
\(\Pi_I^{\rm Rees}\) be the true-saturated Fitting ideal of the module (4)
in a partial Rees presentation, before passage to its associated graded, and
set

\[
 \operatorname{TropPol}_I=
 \{w:\operatorname{in}^{\rm coarse}_w\Pi_I^{\rm Rees}
 \text{ has a residue-torus point}\}.
\tag{10}
\]

Here `coarse` means that `U,V` remain variables; their further valuations are
faces inside the same partial system.  Then (PS) identifies this set with the
tropical support of (8), and (PN) says that its intersection with every
exterior coarse star has no point over the selected value region.  This is
the precise missing **tropical polar condition**.  A common regular refinement
of the graph and these finite polar initial-type complexes makes the indexing
finite; it does not prove the required emptiness.

## Relative log-polar compactification theorem

**Theorem.**  Suppose a regular relative tropical compactification has the
strict graph supplied by the relative-schön theorem; its coarse partial Rees
charts cover each reduced actual stratum and identify its reduced overlaps;
and (PS) holds on every \((\sigma,\tau,I)\).  If (PN) holds on every
exterior type and the core has exactly the relative Morse scheme
\(\mathscr R\), then, after shrinking \(\Delta\) and \(\Omega\),

\[
 \operatorname{Crit}_{T_I}(L)\cap L^{-1}(\Omega)=\varnothing
\tag{11}
\]

for every exterior actual-boundary stratum.  On the core, the relative
critical scheme is \(\mathscr R\) and its central fibre is (9).  Thus the
complete coarse Fitting/value-submersivity ledger follows from the finite
polar certificate, before any Whitney--Thom collar construction.

**Proof.**  A point of the left side of (10) has a toroidal local chart and a
lowest nonzero Rees term along some cone and face.  Strictness (PS) sends that
term to a point of \(V(\mathcal P_{\sigma,\tau,I})\) with the same invertible
value coordinate.  This contradicts (PN).  Equivalently, if the initial
Fitting ideal is the unit ideal, a unit minor lifts in the filtered local
ring; if it eliminates to `L=0`, it has no point over \(S\).  The same
argument localizes on overlaps because (4), rather than a fine-face module,
is being filtered.  The residual statement is the stated exception, and its
nearby four sections persist by the nondegenerate relative Hessian. \(\square\)

The theorem is deliberately one-way.  It turns a polar certificate into the
control ledger.  It does not assert that arbitrary graph initial smoothness
supplies (PS) or (PN).

## The auxiliary-marking test

The `Z`-imbalanced chart is the local regression that fixes the formulation.
With

\[
 r=Z^{-1},\quad v=ZW,\quad\delta=rh,
\tag{11}
\]

the actual central components are `r=0` and `h=0`, whereas `v=0` is an
interior translated-residue locus.  The coarse partial chart has
\(\partial_vL=1\), so (8) is the unit ideal.  If one first takes the fine
face `v=0`, the new restricted map instead acquires the artificial `h=0,2`
packets.  This is exactly the failure of (PS) for the wrongly chosen face:
the cotangent quotient has changed before taking the initial.  It confirms
that the polar condition must forget the auxiliary markings before forming
its Fitting ideal.

The four points (9) provide the complementary test.  They are genuine polar
points at nonzero values and lie in the bounded core, not on an exterior
actual stratum.  A condition saying that every initial polar ideal is empty
would incorrectly erase the residual \(\mathbb P^3\) packet.  The correct
certificate has exactly three permitted outcomes:

| locus | permitted polar outcome over the bounded value disk |
| --- | --- |
| exterior actual stratum | unit ideal, or elimination to `L=0` |
| imbalanced transition | unit tangent derivative with `v` retained |
| bounded core | the four-section relative Morse scheme \(\mathscr R\) |

## What the new schön theorem leaves to replay

The relative-schön certificate proves that each full graph initial is smooth
or empty.  It does not prove either of the following polar statements:

1. **partial attachment/strictness:** the partial Rees chart for a coarse
   stratum is the associated graded of the globally defined module (4);
2. **polar nondegeneracy:** its ideal (8) is unit or forces `L=0` outside the
   residual core.

These are coefficient-sensitive statements, not properties of the support
complex alone.  A regular subdivision can be chosen to refine the finite
Gröbner complexes of the graph and of all displayed polar minors, but that
only makes their initial types constant.  It cannot make a nonempty polar
initial disappear: the translated blowup (6) is already regular, and its
exceptional polar initial remains nonempty on every further regular
subdivision.

There is therefore no graph-initial-only shortcut and no purely combinatorial
choice of tropical compactification that closes coarse control.  The smallest
honest finite replay is, for each actual label
\((\alpha,\beta)\in\{0,g,\infty\}^2\), regular support cone \(\sigma\),
face \(\tau\), and necessary residue family:

\[
 (\alpha,\beta,\sigma,\tau;
  \text{partial Rees presentation},\text{ true saturation},
  \text{coarse overlap map},\text{(PS) comparison},
  \mathcal P_{\sigma,\tau,I},\text{ outcome}).
\tag{12}
\]

The `g` entries in (12) are single coarse records; their `U=0` and `V=0`
subfaces are checked inside the same partial presentation, not made separate
control strata.  Every face is needed: a polar component can first appear on
a face even when a maximal-cone polar ideal is unit.  The existing circuit
lemma can compress the *smooth graph* part of this replay, but a new
coefficient-aware polar circuit lemma, or exact Fitting elimination, is still
required for (PS) and (PN).

## EJ/TT and mystery ledger

- **EJ:** the global schön model reduces the algebraic existence problem to
  one finite polar certificate.  The right object is a partial initial of
  the coarse cotangent module, not another enumeration of smooth graph
  faces.
- **TT:** smoothness of `L-H=0` is maximally uninformative about critical
  points of `L`; the unit `dL` that proves the first is absent from the
  second.  The translated blowup shows that keeping values in \(\mathbb G_m\)
  changes the exceptional value but not this logical gap.
- **Settled:** the exact stronger hypothesis under which a regular tropical
  model gives the desired coarse Fitting ledger; its compatibility with the
  imbalanced unit direction; and the necessary residual exception.
- **Open:** construct the partial Rees/overlap data in (12), then prove (PS)
  and (PN), preferably by a polar circuit lemma with an exact finite replay.
