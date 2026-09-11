# C1133 — consolidated mathematical acceptance map

**Date:** 2026-09-09. **Status:** main mathematical deductions audited;
complete literature coverage and author manuscript/hierarchy review remain open.
This is the task's acceptance map, not a replacement for the manuscript's
owning claim–proof–novelty ledger or its formal-coverage registry.

## Main statements

| Packet claim | Mathematical disposition | Exact scope and dependencies |
|---|---|---|
| A: one stabilization preserves rationality for Picard-rank-one Fano threefolds | Accepted as a deduction from the audited comparison contract and established geometric inputs | Every smooth complex member of all seventeen families. Nine detected families, eight rational controls. Uses numerical selectors only, not B–D or optional rank three. |
| B: rational Hodge conservation | Accepted as a deduction on the stated Hodge-fixed bases | For X,Y among the nine detected families, birationality of X×P¹ and Y×P¹ forces H³(X,Q)≅H³(Y,Q). Retain full fibers, use whole-primary selection first, then rational semisimple cancellation. |
| C: generic cubic/quartic cancellation | Accepted deduction from B and Voisin | Very-general source; arbitrary smooth target in the same hypersurface family. Neither every-source cancellation nor integral Torelli is asserted. |
| D: bounded-degree arithmetic cubic partners | Accepted deduction with primary arithmetic inputs checked | Fixed X/K, K finitely generated of characteristic zero, [L:K] bounded; finitely many geometric partner classes. Orr v4, Achter, fixed-degree polarization finiteness and cubic Torelli. Original NN Theorem 1.1 and principal-polarization consequence now verified from all four scanned pages; see the 2026-09-10 source closeout. No effectivity, height bound or twist count. |

“Accepted” originally recorded this auditor's mathematical disposition. The
2026-09-10 independent cold referee now supports the tested transport,
vanishing, Hodge and downstream interfaces, and separately accepts the P¹
replacement: `2026-09-10-c1133-hostile-referee.md`. Its independent reread did
not cover the entire seventeen-family geometric package. This is not a
Lean-complete claim, a global novelty verdict, or acceptance of an unassembled
manuscript. The finite evidence is reproducible; the geometric statements
remain proofs from identified imported theorems.

## Input ledger F0–A1

All filenames below have prefix `notes/2026-09-09-c1133-`.

| Gate | Disposition and exact evidence |
|---|---|
| F0 reduced formal domains | Retain graded divisor-equation-reduced domains, polynomial occurrence units and the specified formal completions. `fixed-base-proof.md` supplies the operative fixed coordinates; the baseline/source QDM construction is imported. |
| F1 operation comparisons | Core A–D now use Iritani blowup Theorem 5.18 plus the specialized P¹ proof in `2026-09-10-c1133-transport-input-reduction.md`: small GW product, full mixed-bulk persistence and explicit ruled-product potential. The independently reviewed replacement removes IK from core A–D. General projective-bundle statements retain IK and the older twisting/completion match. |
| F2 faithful center transport | Direct proof using independent divisor characters and occurrence variables in `fixed-base-proof.md`. This is not an assertion that arbitrary quotienting preserves injection. |
| F3 separation and lattices | Independent occurrence-unit shifts separate spectra. The original comparison and inverse are regular; the canonical rank-two modification is preserved. `transport-vanishing-audit.md`. |
| P1 full supermodule | Odd bulk coordinates are set to zero while odd cohomology remains in the fiber. Full comparison, parity and pairing checked in `transport-vanishing-audit.md`. |
| H1 equivariance/fixed base | Iritani's Hodge refinement fully read; fixed-base injection reproved directly. Core B uses small tensor identification and equivariant projector continuation for P¹, so no separate IK-equivariance adaptation is required. That adaptation remains available for the general bundle theorem. |
| H2 representation constancy | Equivariant projectors and rational semisimple cancellation, with the unlabelled safe sum invariant under splitting-branch permutations. No separate rational descent of every scalar-labelled summand is needed. |
| Q1 matrix input | Seventeen matrices and nine rank-two discriminants checked by two implementations; fifteen index-one/two source matrices matched entrywise and periods verified through degree eight. Only the nine detected-family matrices are core premises; eight rational-control matrices are cross-checks. `finite-audit.md`, `geometric-source-audit.md` and manifests. |
| D1 every smooth member | Classification exhaustion and all seventeen Hodge numbers verified in KP; CCGK identifies the families, with explicit special quartic and GM smooth bridges. Eight rational controls have all-member geometric scope. `geometric-source-audit.md`. |
| T1 rational generic Torelli | Voisin v3 Theorem 0.2 and Remarks 0.1/0.3, with exact (d,n)=(3,4),(4,4) and source/target quantifiers checked. |
| A1 arithmetic inputs | Achter arithmetic Jacobian, corrected Orr v4 Theorem 5.1, and finite polarization classes give `arithmetic-audit.md`. NN original-source gap closed on 2026-09-10; Orr's fourth-power alternative is a separate cross-check. |

Classical projective weak factorization is the final imported geometric step.
Bittner v1 Theorem 2.1, extraction lines 66–111, recalls its characteristic-zero
statement and projectivity over one endpoint for every intermediate variety.
For projective endpoints this gives projective intermediates, so actual centers
are smooth projective and the audited point/curve/surface vanishing applies.
The 2026-09-10 referee and root also checked AKMW v4 Theorems 0.1.1 and
0.3.1 directly (extraction 1–165), including projectivity. The full AKMW
proof has not been independently read here.

## Integration gates G1–G9

1. **G1:** full supermodule and pairing preserved; restriction is in the base.
2. **G2:** use the Hodge-fixed formal locus and its separately proved injection.
3. **G3:** selector ranks are full even fiber ranks, not invariant-vector ranks.
4. **G4:** keep full-even and fixed-base numerical invariants distinct away from
   the Fano endpoints. Even cohomology is Tate at those endpoints.
5. **G5:** select whole primary factors before decomposing Hodge representations.
6. **G6:** retain original/canonical lattices, including resonant rank-two cases.
7. **G7:** classification and special-model deformation supply every-member scope.
8. **G8:** cancel in the rational semisimple category; no integral or principally
   polarized identification is inferred.
9. **G9:** numerical checks and written geometric proofs are distinguished.
   The original acceptance checkpoint performed no Lean replay. Subsequent
   guarded algebraic implementation is tracked in `lean-upgrade-map.md`; no
   geometric manuscript coverage is promoted by those separate checks.

These are conditions the eventual revision must print and preserve. A later
rewrite omitting them would not be covered by this acceptance map.

## Optional results and residual boundaries

`optional-claims-audit.md` supplies a separate disposition for every optional
branch. The rank-three corrected lattice, odd-dimensional cubic formula,
countability, constant coarse moduli, algebraic exceptional locus, cone
implication, rational-motive example, and additive Grothendieck-group extension
now have written deductions and inspected statement-level inputs.

The odd-excess inequality also passes via Iwai–Matsumura–Müller,
DOI 10.1112/plms.70104, Theorem 1.2(A): in smooth dimension two the rational
Chern classes are ordinary Chern classes and the ample product is empty.
Thus 3c2(S)≥K_S²≥0 when K_S is nef. Since r−s equals the topological Euler
characteristic c2(S), a whole nef-surface factor cannot have s>r. Ruled
surfaces and point blowups reduce as in the transport audit. The modern
theorem statement was read; neither its proof nor the original Miyaoka paper
was read in full.

The special-pencil reduction profiles, upper rationality bound and special
isogeny/cancellation theorem remain explicit companion imports. Their conditional
deductions have been checked, but their owning companion theorems still need
exact version/status verification before inclusion. They are not inputs to A–D.

## Literature disposition

The closest inspected lines of work have distinct roles:

- Iritani/Iritani–Koto and KKPY supply the quantum comparison foundations and
  Hodge/atom framework. Do not claim the broad Hodge-localization idea.
- The author-hosted *Interpretations of spectra* chapter already displays the
  cubic exponents −1/6 and −5/6 and develops spectral ordinary-irrationality
  applications. Its published 2023 version has not been matched; exact partial
  read scopes and prior-work credit are in the owning novelty ledger.
- Cai supplies persistence and a cubic monodromy calculation; Guéré supplies
  the nef-surface nilpotence precedent. These must be credited directly.
- Lee–Przyjalkowski's fully read published three-page note concerns rationality
  of general Fano threefolds via mirror monodromy. Its one-record forward set
  was retrieved and title/abstract screened after all three services returned
  count one. This closes that specific retrieved set, not the entire field.
- Efimov/Huybrechts already separate rational Chow motives from L-equivalence.
  The explicit threefold pair and its one-stabilization separation are the
  packet's candidate contribution, without a firstness claim.
- The rank-three counterexamples refute the precise framing proposition
  identified in `framing-source-audit.md`, not its source's entire program.

The complete literature gate remains open. The latest source/coverage
and attribution dispositions are in
`2026-09-10-c1133-source-literature-closeout.md`. Original NN access is closed;
ordinary equivariant stabilization and isogeny-sensitive atom precedents are
now explicitly credited. The zbMATH screen remains 274/274 titles. Published
spectra-version matching, categorical-base-loci body access, graph/service
coverage and the exact optional pencil imports remain outstanding. The
repeating-surface inventory identifies later manuscript/export actions.
MathSciNet and Scholar access gaps are not negatives. A–D mathematical
acceptance does not certify priority or authorize manuscript promotion.

## EJ+TT and Mystery ledger

- **Settled:** A is independent of B–D and the rank-three appendix; C and D are
  independent downstream applications of B. This prevents an optional result
  or a harder source-access problem from becoming a hidden core premise.
- **Settled:** the seven numerical signatures need not distinguish nine
  geometric families. Classification of rationality does not assert unique
  recovery of the family from the numerical selector.
- **Settled:** higher-rank selectors cannot overcome the two-stabilization
  obstruction while retaining the same global blowup-additive architecture.
- **Open:** priority of the precise A–D combinations and explicit motive pair;
  exact companion-import versions; final manuscript placement. Owners are the
  remaining C1133 literature and author-review stages.
