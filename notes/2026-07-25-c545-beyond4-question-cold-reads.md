# Beyond-four PRS question cold reads

**Lane:** `reed-solomon`

**Scope.** Two independent readers saw the complete 35-page draft without
prior reviews, ledgers, task records, or each other's response. Each answered:
what questions the paper begs, what its implications suggest proving next,
and what strong connections it misses. A separate read compared the bundled
Clebsch-factorization manuscript with the PRS paper.

## Immediate consequence exposed by the reads

The first reader noticed that the uniform transverse range already forces the
covering-radius equality that the draft stated conditionally. Seroussi--Roth,
Theorem 1, applied to the dual \(r\)-dimensional GRS code of length \(q+1\),
gives completeness of the normal rational curve, hence
\[
 \rho(\operatorname{PRS}(q+1-r))=r-1,
 \qquad r\leq\left\lfloor\frac q2\right\rfloor+2,
\]
apart from the even-field dimension-three exception. For \(r\geq6\),
\[
 Q_r=6r-15+\left\lfloor2\sqrt{6r-17}\right\rfloor
 \geq 2r-3,
\]
so \(q\geq Q_r\) implies the displayed Seroussi--Roth range and avoids the
exception. The uniform theorem therefore gives unconditional deep-hole
containment in \(\mathcal P_r\cup\mathcal M_r\), and in characteristic
greater than \(r-1\) gives the exact persistent deep-hole list.

The source was checked against the cached primary PDF
DOI `10.1109/TIT.1986.1057188`, SHA-256
`0b5c152819f91d5e410146ada3527b5b795a55fc6170c14a27e43b8c3e39a5f9`,
especially Theorem 1 and its geometric restatement. Kaipa's Theorem 2 remains
the paper's geometric secondary restatement.

## Questions ranked by expected value

1. **Exact modular membership.** Classify the split-free subset of every
   higher Lucas consecutive-support carrier, beginning with
   \(\mathbb P\langle e_2,\ldots,e_7\rangle\subset\Gamma^9E\).
   Redundancies six and seven suggest an extension-degree or subfield
   criterion, but no such theorem is known at the first fresh carrier.
2. **Stable counts and orbit counts.** State the all-level persistent count
   \(q(q+1)^2/2\), prove disjointness uniformly, and turn the
   \(T/T^{r-1}\), inversion, Frobenius, and tangent-cocycle laws into explicit
   Burnside formulas.
3. **The three R7 radius cases.** Determine the covering radii at
   \(q=7,8,9\), preferably by compact covering certificates rather than an
   ambient undocumented census.
4. **Explain R5 sporadicity.** Normalize the integral \((2,2)\) fiber-square
   curves and test whether their Jacobians, twists, Frobenius traces, or
   \(j\)-invariants characterize the sporadic fields.
5. **Improve the uniform threshold.** Replace the six-deletions-per-marker
   union bound by intersection or simultaneous-marker geometry. The opposite
   trends of the last sporadic fields \(19,13,11\) and the gates \(23,29,37\)
   show substantial slack.
6. **Scheme-level stability.** Determine whether the recursive bad ideal is
   radical after persistent/modular saturation and whether embedded primary
   structure can be excluded uniformly.
7. **Quantum equivalence at \(q=8\).** Determine the actual monomial,
   local-Clifford, and local-unitary classes among the 1116 relative
   extensions and whether sporadic versus nonsporadic type survives.
8. **Effective decoding.** Turn the recurrence/Hankel criterion and coherent
   contraction into a constructive Prony--Berlekamp--Massey-style exact
   decoder with proved complexity.

## Strong connections worth developing

- Modular \(\mathrm{SL}_2\) representation theory: Weyl and divided-power
  modules, Frobenius twists, Lucas supports, and Steinberg tensor structure.
- Linearized and subspace polynomials, with Moore determinants controlling
  rational root spaces on modular carriers.
- Degree-three Hurwitz spaces, exceptional covers, and effective
  function-field Chebotarev for the R5 cyclic/\(S_3\) split.
- Elliptic curves and cubic resolvents for the genus-one off-diagonal
  fiber square.
- Prony reconstruction, linear recurrences, and Berlekamp--Massey with
  distinct rational poles.
- Rational versus geometric symmetric-tensor rank on the secant/tangent
  varieties detected by catalecticants.
- Colon ideals, residual exact sequences, and configuration-space
  compactifications as intrinsic languages for marked contraction and
  collision boundaries.

## Clebsch-factorization comparison inside the PRS paper

The relevant theorem is not merely that the companion also uses conics.
Its matching products have a common restriction to the conic, while division
of their differences by the conic equation retains factorization memory in
the \(3,6,10\)-dimensional \(A_3,B_3,H_3\) quotient spaces; balanced cases
recover two sheets quadratically and orient them cubically. This is
complementary to coherent polar contraction: both retain factor data erased
by a natural reduction, but neither theorem is an input to the other.

The PRS introduction should state that exact comparison and cite the
companion there. Its bibliography should use the companion's current title,
*Factorization memory in a conic ideal: the \(A_3\), \(B_3\), and \(H_3\)
configurations*.

## Mystery ledger

Settled:

- The uniform radius gate is automatic for \(q\geq Q_r\); it is not an open
  premise in the all-level range.
- Clebsch factorization supplies a precise comparison about retained
  factorization data, not a proof input for the PRS classifications.
- Both readers independently selected higher modular-carrier arithmetic as
  the strongest next theorem.

Open:

- The exact split-free subset of the first fresh Lucas carrier is owned by
  C620.
- R7 at \(q=7,8,9\), explicit stable orbit counts, scheme-level radicality,
  and the elliptic explanation of sporadicity remain unallocated questions.
- The public Version 1 release gates remain owned by C545.
