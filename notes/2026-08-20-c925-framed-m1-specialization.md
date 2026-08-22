# C925 -- the conditional framed \(m=1\) proof as a modular specialization

**Lane:** `cubic-threefolds`

**Status:** verified specialization; C925 remains active

## Verdict

The conditional framed-monodromy proof summarized in Section 6 of the
epilogue is an exact specialization of the C925 compiler after changing the
block theory from generic even QDM blocks to **framed small-even QDM
factors**.  The original small bulk point and original \(z\)-disc must be
retained in the object type.

The adaptation removes no hypothesis.  It exposes Hypotheses 5.7R and 5.7T
as two narrowly quantified proof fields and then reuses the same
direct-sum, blowup, center-null, and weak-factorization algebra as the other
C925 instances.

## Source map

The adaptation was checked against:

- `papers/cubic-stabilization-m1/sections/05-framed-monodromy.tex`:
  Definition `def:framed-sixth-multiplicity`, Hypotheses 5.7R and 5.7T,
  `prop:framed-operations`, the specialized low-dimensional vanishing
  results, `thm:nu6-birational-invariance`, the unconditional product
  formula, and the cubic endpoint calculation;
- `papers/cubic-stabilization-m1/sections/06-synthesis.tex`: the exact
  scope of the conditional refinement and its separation from the
  unconditional Section 4 proof; and
- `notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`: the generic
  marker, indexed path, ledger, and center-quotient interfaces.

No manuscript or Lean source was edited.

## Exact interface mapping

| Section 5/6 datum | C925 role | logical status |
|---|---|---|
| original-\(z\)-disc framed formal monodromy | observation payload on `FrSmQDM` | unconditional |
| multiplicity of \(\zeta_6^{\pm1}\) | selector/emitter into \((\mathbf N,+,0)\) | unconditional |
| direct sum of formal factors | symmetric-monoidal ledger addition | unconditional |
| coefficient extension and integral-\(z\) gauge | lawful path generators | unconditional |
| scalar \(H^0\) and descending fixed \(H^2\) shifts | exact adapters | unconditional |
| residual comparison tail | `reconstructionTail` field | Hypothesis 5.7R |
| center specialization \(\chi_j\) | indexed State, never erased | unconditional typing |
| strict admissibility / graded monomiality | Writer certificate | proved for comparison-generated maps |
| tagged versus specialized framed value | `residualTagging` field | used part of Hypothesis 5.7T |
| specialized low-dimensional vanishing | `CenterNullSp 2` instance | direct except for the stated R/T uses |
| weak factorization | center-quotient compiler | unconditional once the instance exists |
| \(\nu_6(Y\times\mathbf P^m)=(m+1)\nu_6(Y)\) | external product adapter | unconditional |
| cubic/projective endpoints | final consumer values \(4\) and \(0\) | unconditional |

The center specialization label is essential.  The blowup formula contains
\(\nu_6(C;\chi_j)\), not \(\nu_6(C)\), because \(\chi_j\) may identify
distinct Novikov classes.

## Provider record

The proof consumes the following conceptual Haskell record:

```haskell
data FramedM1Env = FramedM1Env
  { reconstructionTail
      :: forall e. GeneratedTail e
      -> Equal (nu6 (smallEndpoint e)) (nu6 (reconstructionEndpoint e))
  , residualTagging
      :: forall s. ResidualSurfaceSpecialization s
      -> Equal (nu6 (specializedSurface s)) (nu6 (taggedSurface s))
  }
```

Injectivity of divisor tagging identifies the tagged module with a scalar
extension of the intrinsic one.  Therefore the second field supplies the
intrinsic-to-specialized equality used in the residual surface cases.

The first field is not ordinary coordinate pseudonaturality: it moves from a
designated small point to a Laurent-Novikov reconstruction value.  The formal
bulk-germ rigidity theorem motivates it locally but does not justify that
substitution.

## Compiled proof

The direct specialized center theorems, together with the two fields above,
give

\[
\nu_6(C;\chi)=0
\quad
(\dim C\le2,\ \chi\text{ comparison-generated}).
\]

The conditional blowup adapter gives

\[
\nu_6(\operatorname{Bl}_C Y)
=\nu_6(Y)+\sum_j\nu_6(C;\chi_j).
\]

Every center term therefore vanishes in a fourfold weak factorization, so
\(\nu_6\) descends to the birational localization.  The endpoint consumer is

\[
\nu_6(X\times\mathbf P^1)=2\nu_6(X)=4,
\qquad
\nu_6(\mathbf P^4)=0.
\]

This recovers the conditional irrationality proof.

The conditional projective-bundle operation is not needed here.  The product
with \(\mathbf P^1\) uses the unconditional tensor-product formula.  This is
a genuine simplification of the provider interface, not a strengthening of
the theorem.

## Hostile audit

1. **Generic versus small bulk.**  The framed observer is not installed as a
   raw generic-bulk marker.  Moving the marked small point requires an R-edge.
2. **Original loop.**  Coefficient roots are lawful; roots of \(z\) are not.
   Every unconditional gauge path keeps the original-disc turn.
3. **Specialized centers.**  Intrinsic center zero is insufficient.  The
   finite model includes an exact negative case with intrinsic value zero and
   specialized value one.
4. **5.7R scope.**  The record quantifies only over tails generated by the
   two comparison theorems after exact low-degree normalization.
5. **5.7T scope.**  The record is required only for nonminimal,
   non-geometrically-ruled surface centers.  Direct arguments cover all other
   centers.
6. **Endpoint product.**  No conditional projective-bundle adapter is used.
7. **Relation to the atomic proof.**  The two proofs are sibling instances,
   not global coarsenings of one another.  The atomic discriminant forgets a
   common exponent shift which \(\nu_6\) retains.

The Python law model now has 38 checks.  New checks verify the conditional
fourfold telescope when every specialized center vanishes and separately
falsify the two illicit substitutions “intrinsic zero implies specialized
zero” and “coordinate naturality implies reconstruction-tail invariance.”

## EJ / TT closeout

### Settled cheaply

- The proof needs a separate framed-small theory, but the compiler itself does
  not change.
- The true reusable center interface is indexed specialized nullity, not
  intrinsic center nullity.
- The \(m=1\) provider is smaller than the full Section 5 operation package:
  it needs the blowup R-edge and residual T-edge, but not the conditional
  projective-bundle formula.
- Hypotheses 5.7R and 5.7T are marker-level equalities; a full ambient QDM
  isomorphism would be stronger than the proof consumes.

### Highest-value next question

The remaining conditionality should be attacked one field at a time.  The
cheaper target is `residualTagging`: prove support/base-change invariance for
specialized nonminimal surface centers.  The deeper target is
`reconstructionTail`: justify the Laurent-Novikov substitution for only the
primitive-sixth cyclotomic profile, not the whole formal connection.

## Mystery ledger

| mystery | status | exact gate |
|---|---|---|
| Can Section 6 use the existing compiler? | **settled: yes** | use the framed-small indexed block theory in Module 22 |
| Is 5.7R ordinary coordinate naturality? | **settled: no** | designated-small to reconstruction-tail substitution remains a hypothesis |
| Can intrinsic center zero replace specialized zero? | **settled: no** | noninjective Novikov maps give an exact interface countermodel |
| Is the conditional projective-bundle formula needed for \(m=1\)? | **settled: no** | the external product formula is unconditional |
| Can residual 5.7T be removed? | **open, C925/C920 boundary** | prove support or base change for nonminimal non-ruled surface specializations |
| Can 5.7R be removed for \(\nu_6\)? | **open, C925/C907 boundary** | control the cyclotomic profile under the actual Laurent reconstruction tails |
| Does the atomic marker determine \(\nu_6\) globally? | **settled: no** | it forgets common scalar exponent shifts; only a richer framed exponent object maps to both locally |

## Boundary

The adaptation is verified as a conditional specialization.  It does not
alter the unconditional \(m=1\) theorem, remove 5.7R or 5.7T, or affect the
open \(m=2\) provider problem.  C925 remains active.
