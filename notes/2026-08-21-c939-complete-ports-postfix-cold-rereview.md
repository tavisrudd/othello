# C939 complete repair ports — post-fix cold rereview

Date: 2026-08-21

## Artifact and verdict

- Reviewed commit: `467cec4dd66bf325d3c75e063249145600eecf85`
- Reviewed PDF: `papers/complete-repair-ports/complete_repair_ports.pdf`
- PDF SHA-256: `1e39fe1f38b1084a27930674d48a63ae7b4c4a41b2eabe14af4630dd60b2b033`
- Length: 22 pages
- Verdict: **GO**

The working-tree PDF and the PDF blob at the stated commit have the same
SHA-256. I reread the complete rendered PDF. The earlier terminology defect is
fixed, the new main theorem accurately synthesizes its cited body results, the
Singer argument now exposes the action convention and disjointness step, and
the expanded geometric bridges close the previously compressed arguments. I
found no new correctness, scope, or proof-completeness defect.

## Targeted checks

### 1. Pointed-profile terminology

**Pass.** The Abstract now says “pointed rank-triple multiplicity enumerator”
and immediately identifies it with the full pointed-perspective polynomial.
The same terminology is used in the Introduction and Theorem 6.5.

Lemma 6.3 is now titled “Sparse-paving pointed enumerator” and states exactly
what its proof establishes: the two circuit-hyperplane counts determine the
multiplicity enumerator of

`(r_M(A), r_M(A union {x}), |A|)`

and hence the pointed-perspective polynomial. It also explicitly says that
these data do not determine the labeled subset-rank function. This removes the
only required correction from the first cold review without weakening the
separation in Proposition 6.4.

### 2. New Main Theorem 1.1

**Pass.** The first paragraph is an accurate specialization and synthesis of
Theorems 3.1 and 4.1:

- the inner code is fixed and represented;
- `x` is assumed repairable, so the displayed pointed minimum is finite;
- the outer family is `L`-linear and has dual distance tending to infinity;
- radius `r` is fixed;
- confinement is eventual and is stated iff `r+1 < z_x(I)`;
- only under that inequality are the support and normalized coefficient ports
  copied exactly; and
- asymptotic goodness is obtained by choosing an outer family with positive
  primal relative distance as well as diverging dual distance.

The displayed formula

`z_x(I) = min{wt(u) : u in I^perp, u_x != 0} + d(I^perp)`

is exactly `mu_x(0) + d(I^perp)` under the zero-fiber definition in Section 3.
The density `1/|E|` agrees with `1/m` in Theorem 4.1.

The second paragraph accurately summarizes Theorem 6.5. It claims equality of
the seed enumerators, not equality of labeled rank functions or of the full
pointed invariants of the concatenated codes. It also claims only matched
length and dimension formulas and the same proved distance lower bound, not
equal actual minimum distances. The two reliability laws and density `1/7`
are carried over exactly.

### 3. Singer clarification in Corollary 3.2

**Pass.** The proof now defines the 20-element unit-cost class set `S`, defines
the induced action by `a^*[f] = [f compose a]`, and chooses `a` with
`a^*(S) cap S = empty`. The regular Singer action has 820 elements/classes;
at most `20^2 = 400` group elements map a selected class to another selected
class, so such an `a` exists.

For a hypothetical weight-five realization, unit cost in all five blocks gives
both `[f] in S` and `a^*[f] in S`; since `[f] in S` also gives
`a^*[f] in a^*(S)`, this contradicts the displayed disjointness. The action
direction that was previously implicit is now explicit and correct. The proof
continues to distinguish this existence argument from a computed multiplier,
both in the body and Appendix A.2.

### 4. Geometric bridge expansions

**Pass.** The added steps in Theorem 7.1 correctly close both exact-invariant
bridges.

For the completed axis-target matching bound, a minimal repair edge with `c`
cubic and `a` axis helpers satisfies `2c+3a >= 6`: axis-only edges have at
least two axis helpers, cubic-only edges have at least three cubic helpers, and
the small mixed exceptions are excluded by the circuit classification and
minimality. Summing this inequality over disjoint edges against the available
`q+1` cubic and `q` axis helpers gives

`6 nu <= 2(q+1) + 3q = 5q+2`.

For `q = 3^h`, the resulting integer upper bound is `(5q-3)/6`, matching the
explicit radius-three construction.

For the axis-target transversal bound, the proof no longer merely asserts
that a four-point avoiding section exists. Choosing
`alpha in F_q \ F_3` makes `e_1=1+alpha` nonzero, so the plane through
`C(0), C(1), C(alpha)` has the displayed finite axis completion. It avoids
`A_infinity` and supplies the required four-point section. Together with the
general at-most-four bound this gives `tau = 2q-3`.

The quartic-nucleus bridge remains correct and renders cleanly: the
Vandermonde and complementary-minor arguments classify all circuits through
size five, the harmonic blocks give the five-point hyperplane sections, and
the Steiner counts are displayed without ambiguity.

The Appendix's formal-boundary paragraph is also more precise: the paired Lean
declaration is said to cover simultaneous eventual port transfer through one
outer family, while the concrete field-seven matrices, their finite invariants,
and the human assembly of Theorem 6.5 remain outside that declaration. This is
the correct trust boundary.

## Regression scan

- The exact zero-, singleton-, and multisupport functional strata remain
  separated in Theorem 3.1.
- The strict inequality uses total witness weight `r+1`, not helper count `r`.
- The eventual necessity direction in Theorem 4.1 still constructs the
  two-block zero-functional witness.
- The common outer family in Theorem 6.5 still preserves both concatenated
  parameter formulas and applies simultaneously to both seed ports.
- The paper still records the unmatched availability values and does not
  promote seed-level pointed-polynomial equality to the concatenated codes.
- The reliability, bounded-EXIT, and harmonic-closure scope disclaimers remain
  intact.
- The rendered 22-page PDF has no visible equation collision or malformed
  bridge at the dense page 16–18 transition.

## Final assessment

**GO.** The requested corrections and expansions are mathematically accurate
and remove the prior ambiguity. No further paper change is required by this
correctness rereview. Release still depends on the separate formal replay,
public finite replay, and export/hash-consistency gates, none of which is
replaced by this PDF review.
