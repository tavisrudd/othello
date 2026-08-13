# C907 unit-initial tangent lift for coarse value control

**Lane:** `clebsch`

**Status:** conditional structural lemma and hostile-audited partial
application.  It reduces coarse polar strictness to a regular tangent-vector
lift and applies to 68 of the 70 exterior unit records.  The two
`coarse_unmark d_B/d_C` records do not have regular lifts along their type-`1`
exceptional faces and remain in the transition/Fitting gate.  The lemma does
not prove chart coverage or alter the protected `(1,1)` residual star.

## The filtered tangent lemma

Let `(A,F)` be a separated complete local algebra with a nonnegative
multiplicative filtration whose positive part lies in the maximal ideal, let
`h in A`, and let `T` be a reduced smooth local stratum.  Give `A_T` the
induced filtration.  Suppose `D` is a regular filtration-preserving derivation
of `A_T`, tangent to every equation defining `T` and relative to the `delta`
base, and that

\[
 D h\bmod F^{>0}A_T=u,
 \qquad u\in(A_T/F^{>0}A_T)^\times . \tag{1}
\]

Then `Dh` is a unit in `A_T`.  In particular, on the graph `L-h=0`, if `D(L)=0`
then `L` is submersive on `T`.

**Proof.**  Equation (1) and the local-unit criterion say directly that `Dh`
is a unit.  On the graph, the tangent vector obtained by varying along `D`
and correcting in the `L` coordinate evaluates `dL` as `Dh`; equivalently the
Jacobian row of `L-h` contains the unit `-Dh`.  Hence the intrinsic module
`Omega^1_T/O dL` has the required unit Fitting minor.  \(\square\)

The lemma is strictly weaker in hypotheses and stronger in conclusion than a
general comparison of Fitting modules.  It does not require

\[
 \operatorname{gr}(\Omega^1_T/OdL)
 =\Omega^1_{\operatorname{in}T}/O dL. \tag{2}
\]

One lifted unit tangent derivative is enough.  Conversely a unit visible only
after quotienting by an auxiliary fine face does not qualify: its derivation
need not be tangent to the genuine coarse `T`.

## Lifts in the marked tropical charts

The regular flag charts of
`2026-08-12-c907-kummer-pair-of-pants-refinement.md` have exceptional
coordinates `z_F`, residue units `x_i,b,c`, and the exact marked-line maps

\[
 B=b,\ \epsilon_Bb,\ 1-\epsilon_Bb,\ (\epsilon_Bb)^{-1}
 \tag{3}
\]

for types `g,0,1,infinity`, respectively, and similarly for `C`.  An actual
boundary stratum fixes a subset of the `z_F`; it does not impose `U=0`,
`V=0`, `B=1`, or `C=1`.  Therefore the following certified initial
derivations have regular tangent lifts on the corresponding coarse stratum:

- `dlog_xi` lifts as `x_i partial_xi`;
- a generic residue `dlog_b` or `dlog_c` lifts while all `z_F` are held fixed;
- the type-`1` derivatives in the marked residue coordinate lift as
  `partial_b` or `partial_c` when the witness is already expressed in that
  residue coordinate.

The logarithmic residue derivations are invariant on the Kummer cover and
descend; ordinary residue derivatives are used only on a genuine unimodular
scheme chart or after invariance is checked.  For 68 `unit` records in
`2026-08-12-c907-l-mask-coarse-polar.json`, the displayed residue unit is the
reduction (1) of a regular tangent derivative.

There are exactly two exceptions:

\[
 ((1,\infty),01234),\qquad ((\infty,1),01234). \tag{3a}
\]

Their certificate witness is `coarse_unmark d_B` or `d_C`.  In a type-`1`
chart `B=1-\epsilon_Bb`, so
`partial_B=-\epsilon_B^{-1}partial_b`; this is not regular on
`\epsilon_B=0` and does not give a tangent field on the boundary.  Keeping
the auxiliary face unimposed does not change that identity.  These two
records require a genuine imbalanced-coordinate or intrinsic coarse Fitting
calculation and are not claimed here.

This statement concerns the intrinsic tropical closure of the very-affine
graph.  Filtered Koszul strictness identifies its chart special fibre with the
full three-equation initial ideal.  Hence its normalized local graph generator
has precisely the certified initial `h`; no separate strict-transform
attachment is required for these intrinsic charts.  The conclusion would not
automatically transfer to an unrelated embedded resolution.

## The two non-unit exterior records

The remaining two exterior records have mask `{L}`.  On their exact boundary
strata every other graph term has strictly lower normalized order, so the
strict boundary equation is `L=0`.  They have no point over
`S=G_m,L`, hence no point over any bounded `Omega` contained in `C^*`.

Masks without `L` leave `L` as a literal product coordinate and are likewise
submersive.  Consequently, apart from the two transition records (3a), the
81,367-cell exterior value-control problem has the following structural form:

\[
 \boxed{\text{free }L}\quad\text{or}\quad
 \boxed{\text{one lifted unit tangent}}\quad\text{or}\quad
 \boxed{L=0}. \tag{4}
\]

No Fitting-minor Gröbner replay remains for these cases.  The two records
(3a) remain explicit exceptions.

## Exact remaining geometric gate

The two `(1,1)` masks are not exterior.  Their residue closure is the protected
Rees star of `Bl_(delta,U,V)`, with bounded chart

\[
 L=f_Q+ZW \tag{5}
\]

and two imbalanced charts in which the interior residue derivative is a unit.
The bounded chart carries the four-section Morse scheme; it must not be
eliminated.  To turn (4) into the whole coarse Fitting ledger one still needs
one coverage statement:

> choose the regular tropical subdivision relative to the already regular
> residual Rees star, so every closure face of a `(1,1)` cell lies either in
> the bounded chart (5), in one of its two imbalanced unit-derivative charts,
> or in an exterior chart covered by (4).

Besides this fan/star compatibility theorem, one must close the two transition
records (3a).  Once both are supplied, the existing residual and imbalanced
calculations plus the tangent lemma prove the global exterior Fitting ledger.

## EJ/TT and mystery ledger

- **EJ:** an initial unit derivative lifts directly to a unit derivative.
  The full associated-graded cotangent-module comparison was more than the
  exterior proof needs.
- **TT:** lift vector fields, not Fitting ideals.  The coarse-unmark convention
  is exactly the condition ensuring that the vector field remains tangent to
  the true stratum.
- **Settled:** differential lifting for 68 unit records; exclusion of the
  two `L=0` records; automaticity of every `L`-free mask.
- **Open:** the two nonregular coarse-unmark transition witnesses;
  protected-star coverage for the chosen regular fan; then the polar
  interface/collar theorem.
