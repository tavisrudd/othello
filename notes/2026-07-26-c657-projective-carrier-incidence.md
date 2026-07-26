# C657 projective carrier incidence instantiation

**Lane:** `relconic`

## Result

The coordinate-free square-root carrier API now has a projective incidence
instantiation with no affine-chart choice.

For a homogeneous parametrization \(M:K^2\to K^3\), Lean proves

\[
 (\operatorname{res}_M F)(z)=F(Mz)
 \quad\text{and}\quad
 F(\lambda p)=\lambda^dF(p)
\]

for homogeneous \(F\) of degree \(d\).  If a plane covector \(A\) restricts
to the binary coefficient vector \(a=A M\), its actual restricted factor is
\(a_0X+a_1Y\), its canonical projective zero is
\([a_1:-a_0]\), and the image of that zero is incident with \(A\).

For two plane covectors \(A,B\), Lean expands the determinant of their
restricted coefficient vectors as the three-term Cauchy--Binet pairing

\[
 \det(AM,BM)=
 \sum_{0\le i<j\le2}
   (A_iB_j-A_jB_i)(M_{i0}M_{j1}-M_{i1}M_{j0}).
\]

Nonvanishing of this determinant implies that the two restricted
degree-one forms are relatively prime in the divisor sense.  Pairwise
determinant nonvanishing therefore supplies the exact hypothesis of the
coordinate-free finite-product divisibility theorem.  In exponent
characteristic two, square agreement at the canonical projective zeros
then makes the product of the actual restricted plane factors divide the
difference of the two homogeneous roots.

Finally, if binary representatives on two parametrized carrier lines map
to one *equal plane vector*, restrictions of the ambient Chow polynomial
have equal values there.  When the two restrictions are squares,
Frobenius injectivity gives equality of the corresponding root values.
Thus exact shared plane representatives remove the transition scalar
entirely.  If only proportional representatives are available, the new
homogeneous scaling theorem records the missing factor
\(\lambda^d\); it is not silently discarded.

## Lean declarations

`RelativeConicArcs.ChowRestrictionDescent` adds:

- `MvPolynomial.IsHomogeneous.eval_smul_point`;
- `eval_planeLineRestriction`;
- `binaryLinearCoefficientDeterminant_planeLineRestrictedCoefficients`;
- `eval_homogeneousLinearPolynomial_canonicalProjectiveZero`;
- `eval_planeCovector_pointOnParametrizedLine_canonicalRestrictedZero`;
- `eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq`;
- `eval_eq_of_planeLineRestriction_sq_eq_at_shared_plane_representative`.

`RelativeConicArcs.CarrierArcBound` adds:

- `mvPolynomial_irreducible_of_totalDegree_eq_one`;
- `homogeneousLinearPolynomial_isRelPrime_of_binaryCoefficientDeterminant_ne_zero`;
- `pairwise_isRelPrime_planeLineRestrictedLinearFactors_of_determinant_ne_zero`;
- `fintypeProd_planeLineRestrictedLinearFactors_dvd_sub_of_projectiveZero_sq_eq`.

The final theorem identifies the divisors as the actual restrictions
`planeLineRestriction M (homogeneousLinearPolynomial A)`, rather than an
affine normalization or an unspecified proportional factor.

## Exact boundary

Lean now discharges all algebra after the following geometric data are
supplied:

1. a homogeneous rank-two parametrization for each carrier line;
2. nonvanishing of each restricted coefficient vector;
3. pairwise nonvanishing of the displayed Cauchy--Binet determinants;
4. binary preimages that map to one exact plane representative at each
   shared intersection;
5. the ambient Chow restriction-square identities and homogeneity of the
   chosen roots.

Items 2 and 3 are the concrete no-containment/no-triple-concurrence
incidence checks.  Item 4 is a normalization choice, not an additional
geometric theorem.  Interpolation of the compatible linewise roots and
bounded-degree joint detection remain the later carrier-extension layer.

## Verification

- Warning-free single-file elaboration of
  `RelativeConicArcs/ChowRestrictionDescent.lean`: **PASS**.
- Warning-free single-file elaboration of
  `RelativeConicArcs/CarrierArcBound.lean`: **PASS**.
- The import-only gates were extended to audit every declaration listed
  above.  Their exact build and axiom-audit results are recorded in the
  completion update after the shared build window.

## Extra-juice and Tao closeout

The closeout caught one terminology trap worth making explicit:
Mathlib's `IsRelPrime` is the correct “all common divisors are units”
notion for distinct homogeneous linear forms.  `IsCoprime` is the stronger
Bézout identity and would be false here because all homogeneous linear
forms vanish at the affine origin.  The landed theorem uses `IsRelPrime`
and proves it from determinant nonvanishing through irreducibility; no
vacuous comaximality hypothesis was introduced.

The highest-value normalization is to choose the shared plane vector first
and then choose its two binary preimages.  This turns compatibility into
literal equality and avoids carrying a degree-dependent transition cocycle.
The scaling lemma nevertheless exposes that cocycle exactly when a later
geometric construction supplies only proportional representatives.

## Mystery ledger

- **Settled — hidden transition scalar.**  Exact shared representatives
  remove it; proportional representatives scale a degree-\(d\) evaluation
  by \(\lambda^d\), now kernel-checked.
- **Settled — pairwise factor hypothesis.**  The Cauchy--Binet determinant
  gate implies `IsRelPrime` for the actual restricted factors.
- **Open — geometric determinant nonvanishing.**  A concrete carrier family
  must identify its no-containment/no-triple-concurrence hypothesis with
  nonvanishing of the displayed minors.
- **Open — global representative selection.**  The algebra accepts exact
  shared representatives, but a concrete carrier construction must choose
  them coherently.
- **Open — ambient extension.**  Compatible linewise roots still need the
  interpolation and bounded-degree detection hypotheses already isolated
  by the carrier API.

No manuscript file was edited.  This belongs in Lean and in the internal
formalization report now; it should enter the paper only when a concrete
geometric carrier supplies the three open inputs above, so the paper does
not advertise a conditional algebraic shell as a completed carrier theorem.
