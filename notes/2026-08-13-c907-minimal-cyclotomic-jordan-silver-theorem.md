# C907 minimal cyclotomic-Jordan theorem for Silver

**Lane:** `clebsch`

**Status:** theorem-grade reduction of the `m=2` acceptance object.  Silver
does not require an integral Gamma marking, an Euler pairing, or the full
directed Stokes flag.  It is enough to construct a strict
operation-compatible nilpotent operator on one generalized primitive-sixth
eigenspace.  The target category is the elementary Krull--Schmidt category
of nilpotent Jordan modules over `Q(zeta_6)`.

## The minimal category

Let

\[
 K=\mathbf Q(\zeta_6),
 \qquad
 \mathcal J=\{\text{finite-dimensional }K[N]\text{-modules with }N
              \text{ nilpotent}\}.
 \tag{1}
\]

This is the category of finite-length modules over the local PID
`K[N]_(N)`.  It is idempotent complete and Krull--Schmidt, and its
indecomposables are exactly

\[
 J_r=K[N]/(N^r),\qquad r\ge1.
 \tag{2}
\]

Thus multiplicity of `J_3` is an isomorphism invariant.  It cannot be made
from several `J_1` or `J_2` summands by taking a direct sum, and it cannot
disappear under cancellation in a positive biproduct identity.

The most economical handling of Tate shifts is an upstream graded
`K[N]`-category in which `N` has degree `+1` and Tate translation shifts the
grading, followed by the exact additive functor forgetting the grading to
`mathcal J`.  Equivalently one may start with a strict blowup formula already
in `mathcal J`, provided every Tate-shift autoequivalence preserves `J_3`.
A degree-zero labelled category would not model the operator joining
consecutive Tate levels.  No integral Krull--Schmidt assertion is needed: the
final cancellation argument takes place over `K`.

## Exact Silver realization hypotheses

For every smooth projective variety `Y` of dimension at most five, it is
enough to construct an object

\[
 \mathscr J_6(Y)\in\mathcal J
 \tag{3}
\]

with the following properties.

1. **Formal forgetting.**  After scalar extension to `K`, let

   \[
    E_{\zeta}=\ker(T-\zeta_6)^M
   \]

   be the entire generalized `zeta_6` eigenspace for sufficiently large
   `M`.  Forgetting `N` identifies the whole underlying `K`-space of
   `mathscr J_6(Y)` with `E_zeta`, and `[N,T]=0`.  The rational form makes
   the conjugate algebraic multiplicities equal.  Every Tate shift used in
   (5) preserves this selected sector, or the comparison is first made in
   both conjugate sectors and then forgotten to the same Jordan category.
2. **Projective endpoint.**  In addition to the formal Kunneth dimension
   calculation, the specified operation-compatible `N` satisfies
   
   \[
    \mathscr J_6(X\times\mathbf P^2)
    \supset J_3
    \tag{4}
   \]
   
   as an actual direct summand.  This is an independent endpoint calibration:
   Kunneth alone gives three vector-space copies, not the arrows joining them.
   Formal forgetting as an equality implies `mathscr J_6(P^5)=0`.
3. **Strict blowup.**  For every smooth blowup of codimension `r`, there is an
   actual biproduct in one common additive category (or one whose exact
   grading-forgetful image lies in `mathcal J`),
   
   \[
    \mathscr J_6(\operatorname{Bl}_Z Y)
    \simeq
    \mathscr J_6(Y)\oplus
    \bigoplus_{j=1}^{r-1}T^j\mathscr J_6(Z).
    \tag{5}
   \]
4. **Center exclusion.**  For every smooth projective threefold `Z` and every
   shift occurring in (5), the forgotten object contains no `J_3`; point,
   curve, and surface packets are zero.

These are strictly weaker data than an integral Stokes/Gamma/Rees object.
Pairing compatibility, a marked Gamma seed, the point-class shear, and
ordinary directed Stokes flags are absent.  Composition coherence of chosen
bases is also unnecessary for one weak factorization: the actual
isomorphisms (5) can simply be composed.

## Silver theorem

Under hypotheses 1--4, `X x P^2` is irrational for every smooth cubic
threefold `X`.

Indeed, a weak factorization of a hypothetical birational map to `P^5`
contains only smooth centers of dimension at most three.  Moving the two
sides of (5) at every step and composing yields a positive biproduct identity

\[
 \mathscr J_6(X\times\mathbf P^2)\oplus C_-
 \simeq C_+,
 \tag{6}
\]

where every indecomposable summand of `C_+` and `C_-` is a Tate shift of a
center summand.  The left side contains `J_3` by (4); the right side contains
none by item 4.  Krull--Schmidt uniqueness contradicts (6).

## Formal-rank admission inside the minimal category

The generalized `K`-eigenspace has dimension

\[
 \dim_K\mathscr J_6(Z)=\nu_6(Z)/2
 \tag{7}
\]

under the rational generalized-primary form and formal forgetting.  Ordinary
eigenspace dimension would be wrong in the presence of a nonsemisimple
formal-monodromy block.  Therefore

\[
 J_3\subset\mathscr J_6(Z)
 \quad\Longrightarrow\quad
 \nu_6(Z)\ge6.
 \tag{8}
\]

This recovers the cyclotomic rank-six screen without referring to individual
integral Rees grades.  Under the repaired generalized-eigenspace and
all-shifts hypotheses for each model, it conditionally removes every landed
`nu_6<=4` birational class from the center search.  The universal carrier
input can be stated at its exact weakest level: no arbitrary smooth
threefold with `nu_6>=6` realizes `J_3` in (3).

## What remains genuinely analytic

The reduction does not manufacture `N`.  Iritani's formal QDM biproduct gives
the underlying primitive-sixth vector spaces, but an associated-graded or
semiorthogonal splitting does not prove the strict `K[N]`-module identity
(5).  Likewise the three projective-bundle copies become the endpoint `J_3`
only after a geometric operator joins their consecutive Tate levels.

The revised analytic gate is therefore precisely:

> construct one presentation-independent rational nilpotent operator `N`
> on the generalized primitive-sixth QDM eigenspace, prove the independent
> endpoint calibration (4),
> and prove strict blowup additivity (5).

This is smaller than the former integral hyperplane-equivariant
Stokes/Gamma/Rees theorem.  The latter remains valuable for a fully marked
platinum object, but it is not a Silver prerequisite.

## EJ/TT and mystery ledger

- **EJ:** pass to one cyclotomic eigenspace and remember only its nilpotent
  Jordan operator.  Silver is a `J_3` noncancellation theorem, not a Gamma
  marking theorem.
- **TT:** the forgetting functor must preserve an actual direct-sum operator,
  not merely associated grades.  Without strictness, three `J_1` pieces can
  be glued into `J_3`.
- **Settled:** the minimal rational Krull--Schmidt target and the exact four
  hypotheses implying `m=2` irrationality.
- **Open:** construct the operation-compatible `N`; exclude `J_3` for
  arbitrary threefolds of formal multiplicity at least six.  Under the
  generalized-eigenspace/all-shifts realization, every `nu_6<=4` class is
  inadmissible.
