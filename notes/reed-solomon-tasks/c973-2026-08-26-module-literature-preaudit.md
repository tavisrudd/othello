# C973 preliminary literature positioning — digit-stripping modules

Date: 2026-08-26  
Scope: background triage only; not a novelty or priority audit  
Full-text sources read: 0

## Outcome

The C973 digit-stripping exact sequences should be treated as a concrete
PRS-coordinate extraction from classical modular `SL_2/GL_2` symmetric-power
structure unless a full-text audit proves otherwise.  The preliminary search
located older work explicitly claiming the submodule structure of type `A_1`
Weyl modules and the complete carry-pattern submodule lattice of symmetric
powers.  No manuscript novelty sentence is licensed.

The likely paper value is therefore not “a new Weyl-module filtration.”  It is
the exact identification of the PRS adjacent-zero carrier and Pascal nucleus
inside that filtration, the digit formulas tailored to the syndrome basis,
and the arithmetic question of transporting pointed split locators through
the resulting nonsplit extensions.

## Sources screened individually

1. **R. Carter and E. Cline, “The submodule structure of Weyl modules for
   groups of type A1.”**
   DOI `10.1016/B978-0-12-633650-4.50021-7`.
   Read depth: **abstract/metadata only**, ScienceDirect result page; full text
   returned HTTP 403.  The metadata says it characterizes composition factors
   of the type-`A_1` Weyl modules.  Exact overlap with the C973 coordinate
   sequences was not checked.

2. **Stephen Doty, “Submodules of symmetric powers of the natural module for
   GL_n.”** DOI `10.1090/conm/088/999991`.
   Read depth: **abstract/metadata only** from the author's publication list
   and AMS-linked search metadata, plus **secondary only** through the
   retrieved Hemmer paper excerpt, itself read only in the displayed
   symmetric-power-structure passage.  That excerpt attributes to Doty a
   complete submodule lattice indexed by base-`p` carry patterns.  This is the
   most likely predecessor framework, but the primary text was not read.

3. **Stephen Doty, “Filtrations of rational representations of reductive
   groups of semisimple rank 1.”** DOI
   `10.1090/S0002-9939-1990-1000153-4`.
   Read depth: **partial**, retrieved search copy, abstract and introduction
   only.  Those passages construct filtrations for induced rank-one modules
   and connect them to Jantzen--Andersen filtrations.  The theorem sections
   were not read, so no claim is made that they contain the exact C973
   sequences.

4. **Stephen Doty and Anne Henke, “Decomposition of tensor products of modular
   irreducibles for SL2.”** arXiv `math/0205186`, DOI
   `10.1093/qmath/hah027`.
   Read depth: **abstract/metadata only**, arXiv abstract page.  It concerns
   twisted tensor decompositions of simple modules, so it is background for
   the tensor factors but does not, at the depth read, settle the Weyl-module
   extension used by C973.

5. **Bjørn Cattell-Ravdal, Erin Delargy, Akash Ganguly, Sean Guan, Trevor
   Karn, Michael Perlman, and Saisudharshan Sivakumar, “Ideals preserved by
   linear changes of coordinates in positive characteristic.”** arXiv
   `2404.10544`.
   Read depth: **partial**, arXiv v1 HTML, Introduction; Theorem 2.8 statement;
   Section 3.3 statements of Theorems 3.14--3.15; and Section 3.4 statement of
   Theorem 3.20 and Remark 3.22.  The paper reviews Doty's carry-pattern
   submodule lattice, completely identifies the image of multiplication
   `S_1 tensor W -> S_(d+1)`, and in two variables writes carry ideals as
   products of Frobenius powers of powers of the maximal ideal.  This is a
   current, directly relevant bridge that the full audit must compare against
   the C973 sequences.

   Auditor inference, not a claim attributed at this read depth: the
   multiplication theorem is likely dual to the PRS coherent-lift/contraction
   map defining `C_d`.  The exact carry-pattern and duality identification was
   not completed in this sprint.  If it matches, Theorem 3.14 may supply the
   cleanest citation for the structural image while Theorem 3.20 may explain
   the Frobenius tensor blocks; neither addresses pointed locator arithmetic.

## Search trace and coverage

Queries included:

```text
SL2 symmetric power exact sequence Frobenius twist determinant modular representation binary forms
SL2 induced module exact sequence Frobenius twist symmetric power characteristic p
"Submodules of symmetric powers of the natural module" Doty PDF
"The submodule structure of Weyl modules" "A_1" 1976 PDF
"carry patterns" symmetric powers GL2 Doty submodule lattice
```

Covered: general web/arXiv indexing, the author's publication list, and
search-accessible abstracts/snippets.  Not covered: MathSciNet, zbMATH full
screen, citation-graph enumeration, the full Cline/Doty primary texts, or a
modern monograph treatment.  This preaudit licenses no negative claim.

Cache status: the connector-rendered metadata and snippets were not preserved
as authoritative source bytes in the shared literature cache.  A conforming
successor audit must fetch, hash, and cache the primary texts; this preaudit
cannot be promoted merely by changing its label.

## Required successor audit

Before manuscript integration:

1. obtain and read the type-`A_1` and Doty symmetric-power primary texts in
   full;
2. map their conventions (Weyl versus induced, symmetric versus divided
   power, duality, determinant twist) to the C973 basis;
3. decide whether equations (1)--(3) are quoted classical sequences, a direct
   corollary, or merely compatible with the known lattice;
4. update the owning claim--proof--novelty ledger row before writing any
   novelty language; and
5. keep the PRS pointed-abundance application as a separate novelty question.

Vibe: assume the representation structure is classical; the coding-theoretic
use is where the research claim should live.
