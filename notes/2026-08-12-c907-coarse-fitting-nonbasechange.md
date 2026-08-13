# C907 coarse-control Fitting: the non-base-change obstruction

**Lane:** `clebsch`

**Status:** exact local obstruction and coefficient-uniform replacement
rule.  This closes neither the finite regular pair-of-pants refinement nor
its all-stratum Fitting replay.  It proves why no global Fitting ideal may be
obtained by restricting the auxiliary marked-face calculations, and gives the
correct globally defined module to replay once the genuine control strata
exist.

## The only intrinsic Fitting object

Let `G -> Delta` be a strict graph on a regular log model, and let `T` be a
**globally defined reduced coarse control stratum**.  Write `d=dim(T/Delta)`.
The relative critical scheme of the value map on this stratum is defined by

\[
 \mathcal M_T=
 \Omega^1_{(G\cap T)_{\rm red}/\Delta}/
 \mathcal O\,dL,
 \qquad
 \operatorname {Crit}_T(L)=
 \operatorname {Fitt}_{d-1}(\mathcal M_T).
 \tag{1}
\]

Both the reduction and the choice of the coarse `T` occur before the
Fitting operation.  If two graph charts present the same `T`, (1) agrees on
their overlap, because Kähler differentials, reduction, the quotient by
`dL`, and Fitting ideals commute with localization.  This is the
scheme-theoretic gluing mechanism for a future finite ledger.

There is no corresponding rule for an auxiliary face `F` cut inside `T`.
Indeed, locally suppose that `v` remains a tangent coordinate on `T` and

\[
 L=v+\phi(x_1,\ldots,x_{d-1}),\qquad F=(v=0)\subset T.
 \tag{2}
\]

Then

\[
 \mathcal M_T|_F\simeq
 \Omega^1_{F/\Delta},\qquad
 \mathcal M_F=
 \Omega^1_{F/\Delta}/\mathcal O\,d\phi,
 \tag{3}
\]

and the comparison is the exact sequence

\[
 \mathcal O_Fd\phi\longrightarrow
 \mathcal M_T|_F\longrightarrow\mathcal M_F\longrightarrow0.
 \tag{4}
\]

Thus auxiliary restriction makes a *new* cotangent quotient; it is not base
change of the coarse Fitting module.  In particular, a unit coefficient of
`dv` makes `Crit_T(L)` empty, while `Crit_F(L)` may be arbitrary.  The same
argument works with `partial_vL` any unit after multiplying (2) by a unit.

## Exact imbalanced regression

In the `Z^{-1}` residual-Rees chart set

\[
 r=Z^{-1},\quad v=ZU,\quad\delta=rh,\quad A=Q/Y,
\]

so that

\[
 B=1-h+r^2h^2A,\qquad
 C=1-r^2hv+r^2h^2A,
\tag{5}
\]

and

\[
 \Phi=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
\tag{6}
\]

On both genuine central components `r=0` and `h=0`, `partial_v Phi=1`.
Therefore their coarse relative critical Fitting ideals are the unit ideal.
The symmetric `U^{-1}` chart has the identical conclusion after exchanging
`B,C`.

If one falsely promotes the interior coordinate `v=0` to a boundary face,
then on `r=v=0` the restricted potential is

\[
 \Phi_F=S+\frac A{1-h}-hA.
\tag{7}
\]

After inverting `AY(1-h)`, its critical ideal is reduced and equals the
intersection of the two Morse packets

\[
\begin{array}{c|c|c}
  h& y_1=y_2=y_3&L\\ \hline
  0&a,\ a^4=Q&4a\\
  2&b,\ b^4=-3Q&4b.
\end{array}
\tag{8}
\]

The second row is the apparent `h=2` packet.  It is a critical scheme of the
newly restricted value map (7), not of the original value map (6).  In
particular its bounded values cannot be quarantined away: the first, equally
artificial row has the desired residual values.

The attached exact replay verifies the unit coarse ideal before the auxiliary
restriction, the ideal decomposition in (8), and radicality over `Q(Q)`.

## Consequence for the nine actual boundary types

The coarse labels are `{0,g,infinity}^2`, with `g` containing the marked
value `1`.  A fine report for a translated seam can enter the coarse ledger
only in either of two ways:

1. it gives a derivation tangent to the **reduced coarse stratum** whose
   value derivative is a unit; or
2. it is recomputed as (1) after the auxiliary divisor has been forgotten.

There is no third, global-Fitting shortcut.  Formula (4) is the obstruction.
It applies coefficient-uniformly to every residue chart: it depends only on
a unit normal coefficient, not on the other pair-of-pants or toric
coefficients.

Accordingly the `g,g` record is not the disjoint union of its generic,
one-marked, double-marked, or imbalanced auxiliary records.  The imbalanced
coordinate `v` must stay tangent.  Likewise, `B=1` and `C=1` are not
control-boundary equations.  The four nearby bounded critical sections are
instead certified on the separate bounded core; their special fibre is the
four reduced points `a^4=Q, L=4a`.

## Minimal remaining global computation

No all-coarse-type Fitting certificate can honestly be generated yet: the
regular integral support refinement and the full-initial attachment maps are
not constructed, hence neither the genuine exceptional divisors nor their
globally defined reduced intersections `T` are known.  Computing Fitting
ideals on the present ten auxiliary charts would repeat exactly the invalid
base-change operation above.

The minimal missing finite object is, for each cone/face/residue chart of a
chosen regular refinement, a chart map to one of the nine coarse types and
an equality of reduced overlap ideals.  Only then can a script form (1),
localize it across those equalities, and check the fixed bounded value disk.
The dense interior already supplies that disk: its only bounded branches are
the four residual sections, while the six others satisfy `delta^2 L -> 1`.

## Replay

From the repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-coarse-fitting-nonbasechange.sing | \
  cmp -s - notes/2026-08-12-c907-coarse-fitting-nonbasechange.out
```

The output and adjacent SHA-256 manifest pin the script and its canonical
certificate.  The computation is a local algebra check; it does not assert
that the unconstructed global refinement has only these charts.

As an independent coordinate check, the pre-existing
`2026-08-12-c907-imbalanced-endpoint.sing` replay derives the same two
auxiliary packets directly from the restricted potential, including their
Hessians.  The two programs use different cleared graph presentations; the
unit-derivative argument in (2)--(4) is independent of both computations.

## EJ/TT and mystery ledger

- **EJ:** one exact cotangent sequence, (4), explains both why the full
  imbalanced chart is free and why the `h=2` calculation must survive as a
  regression test rather than as a value packet.
- **TT:** Fitting ideals commute with localization of one fixed module, but
  not with changing the stratum before forming the cotangent quotient.
- **Settled:** the coefficient-uniform coarsening rule; the exact false
  `h=2` mechanism in both imbalanced charts; and the minimal data required
  for legitimate global gluing.
- **Open:** the finite regular-refinement/full-initial attachment object,
  then the actual nine-type coarse Fitting replay and the controlled collar.
