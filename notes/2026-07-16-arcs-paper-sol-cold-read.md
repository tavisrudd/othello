# Sol cold read: arcs complete outside a prescribed conic

Sol read `arcs_complete_outside_conic(3).pdf` sequentially and without prior
context or comparison to another manuscript.

## Overall recommendation

**A− / 8.8 out of 10. Accept after minor-to-moderate revision.** The paper's
strongest contribution is the exact prescribed-hole defect identity, not the
isolated value `rho_C(16)=9`. The identity unifies lower bounds, equality,
stability, coding interpretations, and finite obstructions. The principal
revision request is a clearer hierarchy between that general theorem and the
two secondary narratives: coding structure and finite classification.

## Assessment

| Dimension | Grade | Assessment |
|---|---:|---|
| Problem formulation | A | Natural and sharply distinguished from complete arcs, saturating sets, almost-complete conic subsets, and complete exterior sets. |
| Core mathematical contribution | A | Theorem 3.1 is clean, general, reusable, and conceptually central: the usual inequality's slack becomes an exact sum of nonnegative local defects. |
| Originality and significance | A− | The identity and stability statement look broadly useful; the exact q=16 value is a substantial but more specialized application. |
| Main proof architecture | A− | The route from classical moments through the exact remainder and conic specialization to finite obstruction is strong. The additive-bound proof is less transparent. |
| Introduction | A | Defines the problem, separates adjacent notions, states contributions, gives a roadmap, and distinguishes classical inputs from new work. |
| Abstract | A− | Exceptionally informative but nearly saturated; displayed bounds, exact values, averaging, and certificate detail compete for attention. |
| Expository clarity | A− | Precise and economical, though the prescribed-hole notation becomes dense. |
| Accessibility | B+ | Very good for finite geometers and reasonable for coding theorists; demanding outside those communities. |
| Organization | B+ | The central route is coherent, but the secondary coding narrative remains substantial even though it is explicitly skippable. |
| Equality and stability | A | Corollaries 3.2 and 3.4 turn the remainder into more than a strengthened counting bound. |
| Asymptotic result | B+ | The additive `3/2` is attractive and its limitation is well explained; the polynomial estimate is the least elegant passage. |
| Upper transfer | A | Short, memorable, and useful. |
| Even characteristic | B+ | Clear and honest about its limited power at q=16, but modest in payoff for a standalone section. |
| q=16 classification | A− | Conceptually simple evaluation obstruction and unusually auditable certificate contract; durable supplementation is essential. |
| Computational transparency | A+ | Exemplary separation of generation, certificate checking, formalized consequences, and external consistency checks. |
| Coding interpretation | A− | A clean dictionary and meaningful leader-collision reading, though it interrupts the geometric narrative. |
| Further questions | A | Concrete, connected to the results, and distinguished by mechanism. |
| Conclusion | B | The final synthesis is good but originally appeared only after the questions. |
| Typography and layout | A− | Clean, dense but not cramped; appendix transition somewhat abrupt. |
| Overall publishability | A− | Strong specialist paper after minor-to-moderate expository revision. |

## Sequential reading

The opening is particularly effective. The comparison

```text
complete exteriority => C(F_q) subset U(A),
C-completeness <=> U(A) subset C(F_q)
```

does substantial conceptual work. Section 2 proves the conserved secant
quantities at the right level. Section 3 is the high point: equality and
stability follow naturally from the local remainder and should be advertised
as the durable contribution.

Section 4 is efficient until the explicit additive-bound proof, whose
substitutions and coefficient bounds obscure the idea. The scale remark then
restores the conceptual perspective. The coding dictionary and averaging
transfer are each strong, but broaden the paper's identity. The nucleus section
provides useful structure while showing honestly that conic incidence alone
cannot settle q=16.

The finite proof has the right computer-assisted architecture: isolate the
mathematical obstruction, state the certificate contract, then separate
exhaustive coverage, leaf rejection, and projective transport. The q=11
extension material is interesting but reads as a substantial secondary
application. The open problems are strong, and the final distinction between
universal overlap and genuinely conic-specific geometry should inform a short
conclusion before them.

## Highest-value revisions

1. Make Theorem 3.1 unmistakably the principal result.
2. Simplify the abstract's hierarchy around the identity, its lower-bound
   consequence, and the q=16 application.
3. Isolate the polynomial estimate in the additive-bound proof or move its
   routine algebra to an appendix.
4. Clarify whether the coding material is primary or supplementary; if it stays
   secondary, keep its independence visible and consider appendix placement.
5. Compress or relocate the even-characteristic section if tighter focus is
   needed.
6. Add a short conclusion before the open problems, organized around exact
   overlap accounting, projective transfer, and evaluation-rank obstruction.
7. State explicitly that the liminf runs through prime powers.
8. Give the supplementary artifacts a permanent archived identity, including
   an exact release or commit corresponding to the manuscript.

## Disposition in the next revision

Items 1, 2, 3, 6, and 7 were adopted. The coding and nucleus sections remain in
place to preserve the paper's established theorem numbering and the publication
allocation of the q=11 material, but their secondary role remains explicit.
Item 8 is an external release gate and cannot be completed within a prose-only
revision.
