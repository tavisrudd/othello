# C545 polar and R5--R7 assertion cold read

Date: 2026-07-23

## Result

Proof gates P1--P5 are closed through redundancy nine.  This cold read
specifically discharges the remaining review labels on the polar
construction and the R5--R7 manuscript proofs.  Public orbit records and
formalization remain separate release gates; they are not used to upgrade a
mathematical proof row.

## Symbol and construction audit

Before the effective induction theorem, the manuscript defines:

- `S_n`, divided-power contraction, and the exact lift identity;
- the nonzero contraction domain, configuration space, ordered marker
  space, and universal polar flag;
- the lower splitting strata and identity/Frobenius twists;
- the closed bad scheme and branch, diagonal, old-marker, new-marker, and
  self-collision divisors;
- transverse and collision degrees, the contained-component assertion
  `CC(n,j)`, and the normalized point-bound function `H_kappa`.

The construction theorem is logically prior to the dichotomy.  Perfect
pairing functoriality gives base change and `GL(E)` equivariance; evaluation
on the second basis covector gives the infinity chart; repeated lift
identities give marker propagation; and distinct markers make the
squarefree lifting criterion exact.

## Redundancy-five assertion map

- Radius promotion is an explicitly imported theorem.
- Quadratic and linear gcd strata are separate propositions.
- The cubic incidence proposition proves bidegree `(1,3)`, the residual
  `(2,2)` curve, arithmetic genus one, and the monodromy/component
  correspondence.
- The cyclic lemma proves tame rational/conjugate ramification forms,
  stabilizers, orbit sizes, the characteristic-three nucleus, and the wild
  Artin--Schreier family.
- The `S3` lemma computes diagonal degree 4, branch deletion at most 8, and
  total deletion 12 before applying Aubry--Perret.
- The exhaustion proposition separates the geometric `q>=23` proof from
  the exact low-field certificate.

## Redundancy-six and seven assertion map

For R6, named propositions prove the persistent orbit law, first-polar
secant degree three, cyclic surface degree four, collision/Wronskian degree
six, deletion degree 18, the characteristic-three cone, the
characteristic-two plane and nucleus line, and nucleus arithmetic.  The
finite bridge is used only on its displayed fields.

For R7, named propositions prove the two-marker cover, exact-gcd-one
avoidance, self-collision degree eight, the central binary lift, and the
contained-component corollary.  The manuscript keeps split-free
classification separate from code-deep promotion at `q=7,8,9`.

## Validation

- The warning-gated manuscript build remains green.
- Claim/proof and adversarial ledgers now mark R5, CC6, R6, and CC7 green.
- The second-draft plan and C545 checklist record the symbol,
  construction, containment, and numerical assertion audits as passed.
- No finite certificate is used to prove an unbounded geometric
  integrality, containment, or degree assertion.

## Extra-juice and Tao closeout

The proof architecture is cleaner than the old theorem inventory suggested.
R5 supplies the only genuinely new low-degree monodromy dichotomy; R6 and
R7 reuse it through marked polar contraction while isolating their new work
in contained components and deletion budgets.  The assertion map makes that
dependency visible and eliminates duplicated “certificate proves the
theorem” language.

The main remaining trust problem is now orthogonal to proof expansion:
external readers need canonical orbit records that distinguish equal-size
finite classes.  That is C1, not a reason to keep the unbounded R5/R6
geometry marked open.

## Mystery ledger

- **Settled:** whether any symbol in effective transverse induction is
  introduced only inside its theorem statement.  None is.
- **Settled:** whether polar construction depends on the
  contained/transverse dichotomy.  It is proved independently beforehand.
- **Settled:** whether R5/R6 numerical constants are synopsis-only.  Each
  maps to a named proof, with finite residue explicitly separated.
- **Settled:** whether R7's small-field split-free tables silently imply
  code deep holes.  The covering-radius boundary remains explicit.
- **Open release item:** canonical public R5--R7 orbit records and their
  completeness/transporter fields are still required by C1.

