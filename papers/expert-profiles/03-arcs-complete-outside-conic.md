# Expert profile: arcs complete outside a prescribed conic

**Paper:** `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`<br>
**Profile verified:** 2026-07-15<br>
**Status:** editorial planning only; nobody has been contacted

## Paper spine and likely venue fit

The paper introduces arcs disjoint from a prescribed conic whose secants cover every remaining
off-conic point. Its reusable spine is the exact prescribed-hole defect identity (with equality and
stability), its conic lower bound, the projective-averaging upper transfer, the characteristic-two
nucleus constraints, and the arc--MDS/syndrome interpretation. The finite spine gives exact small
values and a certified classification over `F_16`, including quadratic avoidance for every
eight-arc class.

The natural audience is finite geometry first and coding theory second. The strongest fits are
*Designs, Codes and Cryptography*, *Finite Fields and Their Applications*, or a finite-geometry
issue of *Discrete Mathematics*. A more coding-forward revision could fit *Advances in Mathematics
of Communications*. The theorem is broader than the computations, so a referee slate should not be
made entirely of computational arc classifiers.

The names below are likely expert readers, not claims about who an editor would actually invite.
Before suggesting any referee, check recent collaboration, institutional, funding, and personal
conflicts not visible from public pages.

## Candidate profiles

### 1. Simeon Ball — highest-value broad referee

- **Current position and fit.** Full professor at Universitat Politècnica de Catalunya; the
  [official research-team page](https://gapcomb.upc.edu/en/people-en) verifies the current rank.
  His public profile lists finite geometry, classical and quantum codes, and linear-algebraic methods, and his
  publication list includes arcs, quadrics, MDS codes, and polynomial methods
  ([UPC profile](https://web.mat.upc.edu/simeon.michael.ball/), checked 2026-07-15).
- **Role:** **Likely referee fit.** Best used for the conceptual spine, or as a high-value
  commentator on how to state the
  lower bound and MDS consequence. He is unusually well placed to judge both the elementary
  secant-moment origin and whether the retained remainder is genuinely useful.
- **Questions likely to press (inference).** Is the defect identity more than a repackaging of the
  first two index equations? Is the additive `3/2` term sharp in a meaningful family? Can the
  stability statement force algebraic structure? Does `rho_C(q)` have a polynomial-method upper or
  lower bound stronger than transfer from `t_2(2,q)`? Is the non-GRS conclusion stated with the
  correct projective/monomial convention?
- **What would genuinely excite him (inference).** A structural equality classification; a
  polynomial proof that upgrades the asymptotic lower bound; or a theorem turning the syndrome
  defect into a new obstruction for codimension-three MDS extensions rather than merely a change of
  vocabulary.
- **Caution.** Ball is closely connected to the modern arcs-and-quadrics literature cited by the
  paper. That makes him excellent for priority control, but an editor should independently check
  recent collaboration conflicts.

### 2. Leo Storme — strongest packing/classification referee

- **Current position and fit.** Senior full professor at Ghent University, with official expertise
  in Galois geometry and coding theory
  ([Ghent profile](https://research.ugent.be/web/person/leo-storme-0/en), checked 2026-07-15).
  The Ghent geometry group explicitly treats arcs, caps, classifications, MDS codes, covering
  radii, and saturating sets ([group profile](https://geometry.ugent.be/), checked 2026-07-15).
- **Role:** **Likely referee fit; priority-sensitive reader.** Best used on the extremal-geometry
  positioning, exact small values, and completeness
  of the literature comparison.
- **Questions likely to press (inference).** Where does this parameter sit relative to the packing
  problem, saturating sets, almost-complete conics, and complete exterior sets? Is the claimed
  novelty a new parameter, a new identity, or the consequences of a classical identity? Does the
  `F_16` census use the published eight-arc classification correctly and exhaust all projective
  classes? Can near equality be converted into a recognizable geometric classification?
- **What would genuinely excite him (inference).** Exact `rho_C(q)` for a new infinite family; a
  genuine gap theorem in the standard packing-problem style; or a short classification showing
  that the extremizers must come from one known geometric construction.
- **Caution.** Storme coauthored close classification work used elsewhere in the paper spine. He is
  ideal for detecting overclaiming, but is also a close-prior-art reader whose objections should be
  anticipated even if another person referees.

### 3. Michel Lavrauw — geometry, quadrics, and reproducibility referee

- **Current position and fit.** Professor of mathematics at the University of Primorska, working
  in algebra, geometry, and combinatorics; author of FinInG and an editor in the finite-geometry
  publication ecosystem
  ([personal/University profile](https://mlavrauw.github.io/), checked 2026-07-15).
- **Role:** **Likely referee fit.** Best used for the projective classification,
  quadratic-avoidance claim, and the
  computational artifact; commentator on whether the construction should be expressed in FinInG
  or group-orbit language.
- **Questions likely to press (inference).** Is “no nonzero quadratic” coordinate-free and does it
  include degenerate quadrics? Is the frame normalization complete? Are stabilizers and orbit
  multiplicities independently checked? Could the `F_16` result be stated as a theorem about arcs
  and quadrics rather than as a search result?
- **What would genuinely excite him (inference).** A conceptual replacement for the 2,633-class
  sweep; a clean orbit invariant predicting quadratic avoidance; or a reusable, compact FinInG/GAP
  certificate that lets the community reproduce the classification immediately.
- **Caution.** His joint work with Ball on arcs and quadrics is very close in subject, so verify
  bibliographic and recent-collaboration conflicts before naming both on one referee slate.

### 4. Daniele Bartoli — computational complete-arc referee

- **Current position and fit.** Associate professor in geometry at the University of Perugia
  ([official profile](https://www.unipg.it/personale/daniele.bartoli/didattica), checked
  2026-07-15); his work includes algebraic constructions and searches for complete arcs.
- **Role:** **Likely referee fit.** Best used for exact finite-field computation, canonicalization,
  and the boundary
  between theorem and computer-assisted classification.
- **Questions likely to press (inference).** Does the enumerator meet every projective class exactly
  as claimed? Are the q=8,9,11,16 witnesses minimal or merely upper bounds before the analytic lower
  bound is applied? Do mutation tests and independent implementations rule out a shared bug? Can
  the computation extend cheaply to q=13,17,19 or to other prescribed curves?
- **What would genuinely excite him (inference).** A new infinite construction of small
  `C`-complete arcs; a search invariant that sharply prunes complete-arc enumeration; or a
  surprising exact value that contradicts the heuristic scale inherited from ordinary complete
  arcs.
- **Caution.** The Perugia school includes several authors of the computational arc/coding sources
  cited by the manuscript. That is valuable expertise but calls for an ordinary conflict check.

### 5. Fernanda Pambianco — codes/classification and artifact referee

- **Current position and fit.** Associate professor in geometry at the University of Perugia
  ([official profile](https://www.unipg.it/personale/fernanda.pambianco), checked 2026-07-15), with a
  long record on finite geometry, near-MDS codes, and computational classification.
- **Role:** **Likely referee fit.** Best used for the classification/coding interface and archival
  standard; also a likely commentator on whether the code consequences are stated at the right
  level.
- **Questions likely to press (inference).** What is the exact equivalence relation on arcs and on
  codes? Which claims are independently mathematical and which depend on the class list? Is the
  checker simpler than the generator? Are code parameters, covering radius, and leader counts
  derived semantically rather than inferred from names?
- **What would genuinely excite her (inference).** A classification invariant reusable for larger
  fields, an exact extension spectrum with a geometric explanation, or a certified bridge that
  turns finite-geometry class data into code theorems without a trust gap.
- **Caution.** She is an author of close cited work with Davydov and Marcugini. Treat that as
  expertise plus a prior-art sensitivity, and verify current coauthorship conflicts.

### 6. Geertrui Van de Voorde — best exterior-set/coding commentator

- **Current position and fit.** Associate professor at the University of Canterbury. Her profile
  emphasizes finite projective geometry, algebraic descriptions of combinatorial point sets, and
  links to coding theory and graphs
  ([Canterbury profile](https://www.math.canterbury.ac.nz/~g.voorde/), checked 2026-07-15).
  Her published work and talks directly include sets without tangents and exterior sets to a conic.
- **Role:** **Likely referee fit; expert commentator.** Particularly valuable on the
  distinction between complete exteriority
  (`C subset U(A)`) and completeness outside a conic (`U(A) subset C`), and on the LDPC/MDS
  separation.
- **Questions likely to press (inference).** Is the new definition already present under
  “relative saturation,” “holes,” or a dual sets-without-tangents formulation? Does the paper
  consistently distinguish exterior points, external/passant lines, and uncovered points? Can
  polarity dualize the problem into a known blocking or tangent problem?
- **What would genuinely excite her (inference).** A polarity theorem unifying prescribed-hole
  completeness with a recognized tangent-free object; a code-theoretic invariant that reconstructs
  the geometry; or an infinite family connecting extremal graphs, conics, and codes.
- **Caution.** She is the nearest modern expositor of the BSW lineage. That makes her especially
  important for terminology and priority, whether or not used as a formal referee.

### 7. Péter Sziklai — polynomial/stability referee

- **Current position and fit.** Professor and institute director at Eötvös Loránd University;
  research interests include Galois geometry, the polynomial method, coding theory, and stability
  of special point sets
  ([ELTE profile](https://ttk.elte.hu/en/staff/peter-sziklai) and
  [research-group description](https://ttk.elte.hu/en/hun-ren-elte-research-groups), checked
  2026-07-15).
- **Role:** **Likely referee fit.** Best used for the analytic inequality and stability theorem,
  with less direct
  investment in the particular `F_16` census.
- **Questions likely to press (inference).** Can the remainder identity be fed into Rédei/polynomial
  machinery? Does small defect force a low-degree curve or blocking-set structure? What changes in
  non-Desarguesian planes, where the moment identity survives but the algebraic conclusions do not?
- **What would genuinely excite him (inference).** A stability-to-algebraicity theorem: for
  example, showing that near-extremal uncovered loci must lie close to a conic or another
  low-degree curve.
- **Caution.** The paper currently proves a numerical stability estimate, not structural
  stability. Do not market the former as the latter to this audience.

### 8. Jan De Beule — graph/computation and finite-geometry referee

- **Current position and fit.** Senior lecturer at Vrije Universiteit Brussel, with official
  interests in finite geometry, algebraic graph theory, coding theory, computer algebra, and
  computational group theory
  ([VUB profile](https://researchportal.vub.be/en/persons/jan-de-beule/), checked 2026-07-15).
- **Role:** **Likely referee fit.** Best used for computation, graph reformulations, and the
  extension/conflict complex;
  commentator on making the certificates community-readable.
- **Questions likely to press (inference).** Is there a graph or association-scheme formulation of
  prescribed-hole completeness? Does the extension conflict graph reveal why q=11 and q=16 are
  special? Can the orbit search be reproduced in GAP/FinInG? Are the exact finite results robust
  under projective relabelling?
- **What would genuinely excite him (inference).** Identification of the extension graph with a
  known strongly regular or distance-regular graph; a spectral obstruction that replaces search;
  or a compact certified classification driven by group action.
- **Caution.** Best used alongside, not instead of, an extremal-inequality referee.

### 9. Tim Alderson — independent MDS/finite-geometry coding reader

- **Current position and fit.** Professor at the University of New Brunswick Saint John; his
  [official profile](https://www.unb.ca/faculty-staff/directory/school-of-graduate-studies/alderson-tim.html)
  lists finite geometries and their applications to coding and information theory.
- **Role:** **Likely referee fit** for the arc--MDS dictionary, projective equivalence, and whether
  the coding consequences are genuinely useful outside the finite-geometry formulation.
- **Questions likely to press (inference).** Does prescribed-hole completeness yield an MDS
  extension or lengthening obstruction not already visible from covering radius? Are projective,
  monomial, and code equivalence kept distinct? Can the evaluation obstruction be stated for a
  broader code family?
- **What would genuinely excite him (inference).** A portable equivariant or constrained MDS
  lengthening theorem, an exact covering-radius consequence, or a family in which the prescribed
  algebraic hole forces a new code-equivalence classification.
- **Caution.** He broadens the panel beyond the finite-geometry classification network, but should
  be paired with a reader who can audit the `F_16` exhaustive certificate.

## Historical and close-prior-art commentators

- **Aart Blokhuis — expert commentator; priority-sensitive reader.** Coauthor of the
  complete-exterior-set papers central to the q=11 comparison.
  He is a very high-value priority/terminology commentator, but the current public institutional
  status was not cleanly verified in this pass; do not list him as a formal referee without an
  updated check. His likely question is whether the prescribed-hole condition has an older dual or
  polynomial formulation. The exciting result for him would be a genuine advance on the BSW
  linearity/construction program, not merely a new name for an exterior set.
- **R. H. Dye and W. L. Edge — historical expert commentators.** These are intellectual
  referees, not practical reviewer candidates. Dye's
  1991 paper and Edge's 1956 paper determine the attribution boundary for the Clebsch example. Any
  claim about the q=11 geometry should survive the question “is this already a consequence of the
  ten Brianchon concurrences and the associated conic?”

## Ranked shortlist and suggested mix

1. **Simeon Ball** — strongest single reader across geometry, bounds, and MDS codes.
2. **Leo Storme** — strongest packing/classification and literature-positioning reader.
3. **Geertrui Van de Voorde** — strongest exterior-set and geometry-to-coding boundary reader.
4. **Daniele Bartoli** or **Fernanda Pambianco** — choose one for the finite classification.
5. **Péter Sziklai** — best independent route to a stronger structural/stability theorem.
6. **Michel Lavrauw** or **Jan De Beule** — choose according to whether the editor prioritizes
   arcs/quadrics or computational graph structure.
7. **Tim Alderson** — coding-forward alternative when the MDS/syndrome spine is emphasized.

A balanced three-person mental panel is **Ball + Van de Voorde + Bartoli**. A more traditional
finite-geometry panel is **Storme + Lavrauw + Sziklai**. Avoid choosing multiple members of one
close collaboration cluster without checking conflicts.

## What belongs in this submission versus a follow-on

**High-value upgrades to the current submission:** make the complete-exterior versus
complete-outside implication diagram explicit; use the BSW q=7 four-arc as a strict-inclusion foil;
state one consequence that genuinely needs the exact remainder; explain the `F_16` equivalence and
quadratic certificate in theorem-level prose; and archive an independently replayable artifact.
These answer the most predictable questions from Storme, Van de Voorde, Bartoli, and Lavrauw
without changing the paper's spine.

**Follow-on questions:** exact values for an infinite family of q; structural (not merely
numerical) stability; a polarity duality with blocking/tangent problems; and algebraic or polynomial
classification of near-extremizers. Those are the results most likely to excite Ball or Sziklai,
but they should not become informal promises in this submission.

## Cross-candidate questions the paper should answer before submission

1. Exactly which statement is new: the parameter, the identity, the equality/stability
   consequences, or all three in their stated form?
2. Can the paper give one example where retaining the exact remainder proves something an ordinary
   moment inequality cannot?
3. Is there a conceptual explanation of the `F_16` quadratic-avoidance classification?
4. What is the next exact `rho_C(q)`, and which theorem—not just more search—could obtain it?
5. Does polarity translate prescribed-hole completeness into an established blocking/tangent
   problem?
6. Can numerical near equality be upgraded to structural proximity to an algebraic curve?
7. Is the code theorem useful for constructing or obstructing MDS extensions, rather than only
   restating incidence?
8. Are all computations archived, independently replayed, and cleanly separated from the proof of
   the universal identity?
