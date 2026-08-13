# C907 hostile audit: the corrected `m=2` acceptance architecture

**Verdict:** the formal acceptance theorem is **PASS conditional**. The
existing `nu_6` and MMP results do **not** prove `ell<=2` for all smooth
projective threefolds under an honest enriched definition. They are useful
admission/exclusion tests only.

## 1. Exact sufficient theorem

Let `C` be one idempotent-complete Krull--Schmidt category, let `T` be an auto-equivalence, and let `ell` be an isomorphism-invariant of indecomposables preserved by `T`. Suppose all of the following are actual theorems in `C`.

1. `A(P^5)=0` in the cubic packet.
2. `A(X x P^2)` has a direct indecomposable summand `E` with `ell(E)=3`.
3. Every smooth projective threefold `Z` has every indecomposable summand of `A(Z)` of length at most two. Points, curves, and surfaces have empty cubic packet.
4. For every smooth blowup with center `Z` of codimension `r`, there is a strict enriched biproduct

   \[
   A(\operatorname{Bl}_Z Y)\simeq A(Y)\oplus\bigoplus_{j=1}^{r-1}T^jA(Z). \tag{1}
   \]

If `X x P^2` were rational, weak factorization with `P^5` has smooth centers of codimension at least two, hence dimension at most three. Equating (1) on the two sides of every common blowup and composing produces a positive biproduct identity. Every added center summand has length at most two, while `E` is an actual direct summand on the left. Krull--Schmidt uniqueness forces an isomorphic copy of `E` on the right, contradicting length invariance.

Thus `ell<=2` is genuinely sufficient. No marked Gamma seed and no composition coherence of chosen marked bases is required for one fixed weak factorization: actual object isomorphisms can be composed. What is required is stronger and non-negotiable: (1) must be a strict biproduct in the same category, not an equality in `K_0`, a semiorthogonal associated graded, or a formal Laurent decomposition. Otherwise shorter pieces can join to a length-three indecomposable.

The sharp weakest carrier assertion is even narrower: no threefold center may contain the same length-three indecomposable signature as `E`. The numeric bound `ell<=2` is a clean sufficient condition, not a necessary one.

## 2. Why present `nu_6` work cannot supply the bound

`nu_6` is a scalar multiplicity in the formal/numerical small quantum connection. It does not contain a sectorial Rees extension, Stokes flag, Gamma lattice comparison, or a presentation-independent composition law. Consequently neither `nu_6(Z)=0` nor `nu_6(Z)<=2` currently proves an enriched length statement without a faithful realization from the enriched packet to that formal connection. The existing notes correctly record this distinction for nef-canonical threefolds, weighted CIs, and prime Fanos.

At best, after such a realization is supplied, formal packet rank is a cheap necessary bound: a consecutive Rees string has a nonzero graded piece at each step, so it cannot be longer than the available relevant formal rank. With the self-dual primitive-sixth convention, a length-two candidate needs two primitive pairs (`nu_6>=4`), and a length-three candidate needs still more formal support. This is an admission test, not an extension theorem.

The decisive formal obstruction is already present in the stationary Picard--Lefschetz model: a self-dual Gamma-like lattice with primitive-sixth formal monodromy and a nonzero stationary square has `N^3=0` but `N^2!=0`. It is not a geometric counterexample, but proves that pairing, formal monodromy, Picard--Lefschetz parity, and Rees weight cannot force `ell<=2`. No current universal bound on `nu_6` for arbitrary non-nef threefolds exists either.

## 3. MMP does not close the gap

The landed `nu_6` invariance is confined to the numerical scalar invariant in low dimensions. It does not transport an enriched Rees/Stokes object through terminal Q-factorial models, flips, or divisorial contractions. Nor can a Mori fibre space be replaced by its base and smooth fibre: the cubic-line conic bundle and cubic-surface fibration retain `nu_6=2` in ramified Clifford/descent data while their lower-dimensional pieces have zero support. A semiorthogonal fibration decomposition is only an associated-graded statement and can contain the extensions relevant to length.

An honest MMP proof of `ell<=2` would need all of:

1. An enriched packet for terminal models and a resolution comparison.
2. Strict/nonincreasing transport through flips and contractions.
3. A ramified Clifford/descent theorem ruling out a nonzero second primitive composite in conic and del Pezzo fibrations.

None is presently available. Hence no existing MMP or `nu_6` result may be used to promote the corrected acceptance architecture from conditional to an `m=2` theorem.

## Required status

Keep `ell<=2 + strict enriched Krull--Schmidt biproduct` as the exact Silver acceptance condition. Keep the universal threefold bound and the strict blowup theorem as independent open gates. Existing `nu_6` calculations should be labelled candidate exclusions/calibrations, never evidence that the universal enriched bound has been proved.
