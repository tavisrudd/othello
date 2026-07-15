# C146 — Clebsch, Edge, and exterior-set prior-art rebase

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. The verified lineage and vocabulary are in the manuscript. C153 remains a
separate submission gate because the two original Blokhuis--Seress--Wilbrink papers are unread.

## Corrected lineage

The manuscript now distinguishes five layers that its Dye-centered draft had conflated:

1. Clebsch's 1871 real-projective antecedent;
2. Edge's 1956 construction and naming of the `q=11` finite-plane Clebsch hexagon, including its
   order-60 stabilizer, five synthematic triangles, and two systems of eleven hexagons;
3. Dye's 1991 general-field synthetic theory and invariant conic;
4. Blokhuis--Seress--Wilbrink's 1991 sets-without-tangents problem and 1992 complete-exterior-set
   vocabulary;
5. Storme--Van Maldeghem's finite-plane `K_2` description, projective-uniqueness statement, and
   `q=11` incompleteness computation.

The wording says the SVM statements used here *appear in* their paper rather than assigning final
priority to them; C161 still owns the Sadeh/earliest-source question.

## The crucial distinction now explicit in the paper

For the fixed conic, all six Clebsch vertices are external points and all fifteen joins are external
lines. In the BSW vocabulary this makes the hexagon the size-six complete exterior set at `q=11`.
That is classical incidence data, not a contribution of this paper.

The paper's covering statement is stronger and logically different:

```text
exterior-set condition: the fifteen joins avoid C;
covering/deep-hole condition: the fifteen joins cover every point outside A∪C.
```

Equivalently, the latter says the full uncovered locus is exactly the twelve rational points of the
conic. The introduction and Section 2 now say this plainly rather than presenting a known exterior
set as a new exceptional arc.

The existing coding connection is also acknowledged: Van de Voorde relates the broader
sets-without-tangents problem to stopping sets of projective-plane LDPC codes. The paper separates
that connection from its MDS covering-radius and deep-hole interpretation.

## Source and trust boundary

Edge 1956 §§29--32 and Van de Voorde's exterior-set treatment were read in full in the literature
sweep. Neither states the covering property. Dye's author-written zbMATH summary and his later
self-recap likewise contain no such statement. This is positive evidence for the present novelty
boundary, but not the final gate.

The BSW originals were unavailable. The manuscript therefore says explicitly that priority for the
covering statement is conditional until C153 reads:

- Blokhuis--Seress--Wilbrink, *Mitt. Math. Sem. Giessen* 201 (1991), 39--44;
- Blokhuis--Seress--Wilbrink, *Combinatorica* 12(2) (1992), 143--147.

The second title, *Characterization of complete exterior sets of conics*, makes that check
non-optional. C146 does not convert a secondary-source absence into a novelty theorem.

## Manuscript changes

- added Clebsch, Edge, BSW 1991, BSW 1992, and the corrected Van de Voorde journal citation;
- replaced the SVM/Dye-only introduction with the chronological lineage;
- added external-point, external-line, and complete-exterior-set vocabulary;
- replaced the long Dye-centered priority footnote by the Edge/VdV/BSW trust boundary;
- attributed the finite five-triangle/synthematic-total construction to Edge alongside Dye;
- distinguished Edge's two systems of eleven hexagons from the new support-chirality bipartition;
- cited the pre-existing LDPC stopping-set connection without confusing it with the MDS result.

An independent adversarial review proposed the same four-site repair and caught two phrasing risks:
do not say BSW rediscovered Edge while the BSW bibliographies are unread, and do not say the SVM
uniqueness statement is first while C161 is open. The landed text avoids both.

## Validation

Command:

```text
cd papers/clebsch-hexagon-code
nix shell nixpkgs#tectonic -c tectonic clebsch_hexagon_code.tex --outdir . --keep-logs
```

Tectonic completed after its internal rerun. The checked-in PDF is 146,424 bytes. Its final log has
no package/LaTeX, undefined-reference, overfull, or underfull warning.

## Remaining external gates

- **C153:** read both BSW originals and preserve or retract the covering-priority sentence.
- **C131/C161:** settle the exact Sadeh/Hirschfeld ownership of the census spectrum and earliest
  source for the equivalence used in the rigidity theorem.

Neither gate blocks the correctness of the current theorem statements. Both block a final novelty
grade and submission-ready priority language.
