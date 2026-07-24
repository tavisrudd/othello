# AME local-unitary paper

**Lane:** `ame-lu`

**Purpose:** complete the paper titled *Local-Unitary Rigidity and Logical
Clifford Phases of Six-Qudit AME Stabilizer Tensors*.

Discovery companion:
[`2026-07-24-ame-lu-discovery-track.md`](../2026-07-24-ame-lu-discovery-track.md).

## Current status

The paper-preparation scaffold is under `papers/ame_lu/`.  It follows the
`beyond4_prs` preparation system: the manuscript is subordinate to a theorem
adoption map, a claim/proof/novelty ledger, a verification map, an adversarial
audit, a formalization ledger, and an explicit draft-fix plan.

The source results are complete crowns reports C374, C396, C397, C402, C546,
C548, and C550.  They establish:

- the six-arc/MDS/CSS/AME dictionary and exact H3 separation from GRS states;
- classification of local-Clifford classes in the admitted non-GRS pencil by
  the scalar `z`;
- the split-torus versus `SL_2(q)` logical-Clifford phase;
- uniform marginal-moment separation of good H3 reductions from the GRS locus;
- a four-copy arbitrary-LU separator at `q=13`; and
- the transport-sheaf derivation of the rank-drop divisor and its orbit
  multiplicities.

The paper does **not** yet claim uniform `LU=LC`.  Its highest-value theorem
gate is restricted orbit coincidence inside the admitted pencil:

```text
Psi_t ~LU Psi_u  iff  Psi_t ~LC Psi_u  iff  z(t)=z(u).
```

This means equality of equivalence relations on the family, not that every
local-unitary intertwiner is Clifford.

**C559 closed negatively (2026-07-24): fixed-copy contraction invariants
cannot recover the pencil coordinate generically.**  For an equal-phase
linear-code state every permutation contraction has the exact value
`q^(km-rank M_sigma(G))`.  Hence every fixed-copy party-orbit invariant is
constant on the common generic-rank stratum; at four copies its generated
subfield of `Q(t)` is the constant field, not `Q(z)`.  C548/C550's
`(z-2)(9z-4)` remains an exact rank-jump divisor, not a rational coordinate.
This closes only the proposed proof route.  See
`2026-07-24-c559-ame-lu-invariant-field-gate.md`.

**C560 closed positively (2026-07-24): every LU intertwiner is LC.**  On any
four parties, MDS shortening gives a `q^2` stabilizer subgroup whose
nonidentity correlation tensor is diagonal on the full `q^2-1` local Weyl
basis.  The rank-one contraction axes of this four-way tensor are intrinsic,
so a product-unitary equivalence forces every local adjoint action to permute
Weyl axes and hence be Clifford. This holds for equal-phase CSS states of
all linear `[6,3,4]_q` MDS codes over every prime power. Combined with C396
and C571's full-Clifford correction, the admitted odd-prime-field pencil
satisfies `LU iff LC iff z equality`; over extension fields Frobenius is
already an additional local Clifford and the scalar classification is not
claimed. Two four-party marginals covering all six parties suffice. See
`2026-07-24-c560-ame-lu-orbit-rigidity.md` and
`2026-07-24-c571-ame-lu-adversarial-second-draft.md`.

**C561 closed (2026-07-24): theorem package and architecture frozen.**  The
title is *Local-Unitary Rigidity and Clifford Geometry of Six-Qudit AME
Stabilizer Tensors*.  C560 is the headline theorem; C396's `LU iff LC iff z`
is its admitted-pencil corollary.  Logical operations, explicit LU
certificates, fixed-copy generic constancy, and the transport divisor are
subordinate results. The synchronized boundary table now distinguishes the
all-prime-power rigidity theorem, the odd-prime-field quantum pencil
classification, the all-odd-field classical quotient, and detector-only
exceptional characteristics. See
`2026-07-24-c561-ame-lu-theorem-freeze.md`.

**C562 closed (2026-07-24): qualified LU-rigidity novelty boundary.**
Rains's qubit `[[2m,2m-2,2]]` theorem already uses rank-one recovery of a
diagonal three-Pauli tensor, and Van den Nest--Dehaene--De Moor turn it into
a minimal-support LU-to-LC criterion.  No screened source states C560's
full `q^2-1` Weyl-axis extension or its all-prime-power linear
`[6,3,4]_q` MDS/CSS theorem.  The manuscript may claim this exact scope
only with “to our knowledge,” must credit the Rains--Van den Nest mechanism,
and must retain “equal-phase CSS”; arbitrary phased `AME(6,d)` states have
infinitely many LU classes.  See
`2026-07-24-c562-ame-lu-literature-audit.md`.

**C563 closed (2026-07-24): paper-local computational evidence complete.**
The seven adopted computational bundles C374, C396, C397, C402, C546, C548,
and C550 now have byte-identical generators and canonical JSON certificates
under `papers/ame_lu/supplement/evidence/`.  The manifest checks fifteen
load-bearing files, including C396's previously hidden hash-pinned C395 input.
`verify.py --replay` checks all hashes and regenerates all seven certificates
in memory; the complete standard-library replay passed under Python 3.13.12.
The claim-level report records every domain, independent path, negative scope,
and trust boundary.  See `2026-07-24-c563-ame-lu-evidence-package.md`.

**C564 closed (2026-07-24): complete first manuscript draft.**  All eight
sections now carry the frozen theorem spine: the title-page LU-intertwiner
theorem, arc/MDS/CSS/AME dictionary, full-Weyl axis proof, exact
`z`-classification, logical phase, H3 and q=13 LU certificates, fixed-copy
generic constancy, transport divisor, and verification boundary.  Every stable
label is synchronized with the ledgers.  `make check` produced a warning-free
11-page PDF (132,775 bytes; SHA-256
`a23aa69c7e55ccaf12135d517f35b98092f26d300f81c40e376de897bb187da3`);
pages 1, 6, and 11 passed visual inspection.  The remaining proof-
reconciliation and exposition risks are assigned to C565--C571 in the
second-draft plan.  See `2026-07-24-c564-ame-lu-first-draft.md`.

**C565 closed (2026-07-24): shared Lean convention interface complete.**
`RelativeConicArcs.AMELU.Definitions` now fixes ordered six-arcs, exact
`[6,3,4]` kernels, normalized equal-phase states, subsystem marginals and
AME, all projective/monomial/party/LU/LC action directions, the
`X(a)Z(b)` Weyl convention, and the exact finite-field trace phase.  Its
import-only gate passed guarded elaboration and the trace-only aggregate
check.  No manuscript theorem is assumed by the data structure.  See
`2026-07-24-c565-ame-lu-lean-foundation.md`.

**C590 closed (2026-07-24): CSS support and dictionary bridges complete.**
`RelativeConicArcs.AMELU.CSS` fixes `L_C=C×C^\perp`, Pauli support, and
`L_C(S)`.  `RelativeConicArcs.AMELU.Dictionary` proves six-arc to exact
`[6,3,4]`, `[6,3,4]` to AME, projective to monomial, and monomial to
local-Clifford coherence with explicit multiplier matrices.  The final
import gate and standard-axiom audit passed.  The full manuscript dictionary
still needs the stabilizer-action, Lagrangian, minimum-support, and AME
converse clauses before formal adoption; these are now queued as C591.  See
`2026-07-24-c590-ame-lu-lean-dictionary-bridges.md`.

**C591 closed (2026-07-24): shared Lean stabilizer dictionary complete.**
`RelativeConicArcs.AMELU.StabilizerDictionary` identifies the six-fold
tensor Weyl action, proves the full `C×C^\perp` stabilizer equation and its
separate `X(C)` and `Z(C^\perp)` cases, proves the CSS space is a
six-dimensional symplectic Lagrangian, and closes the exact `L_C(S)` support
criterion.  It also proves the universal `q^3` computational-support lower
bound for six-party AME states, minimality of exact-code equal-phase states,
and the converse
`IsAME (equalPhaseState C) ↔ IsMDSCode634 C`.  The measured import gate,
trace-only aggregate gate, exact no-build checks, and standard-axiom audit
passed.  The complete manuscript dictionary is now formalized; C570 owns
aggregate adoption and reconciliation.  See
`2026-07-24-c591-ame-lu-lean-stabilizer-closure.md`.

**C566 closed (2026-07-24): admitted-pencil classification interface
complete.**  `RelativeConicArcs.AMELU.PencilClassification` defines the
ordered pencil, its five-factor admitted non-GRS locus, `A`, `B`, `y`, and
`z`; proves the exact four-branch algebraic quotient
`z(t)=z(u) iff y(u) in {±y(t),±y(t)⁻¹}`; and derives the
projective/monomial/LC classification from a structure that names the
six-arc, explicit-projectivity, bracket-invariance, and LC-holonomy inputs
separately.  Its import gate, trace-only aggregate check, no-build probes,
and standard-axiom audit passed.  See
`2026-07-24-c566-ame-lu-lean-lc-classification.md`.

**C567 closed (2026-07-24): marginal-moment separator interface
complete.**  `RelativeConicArcs.AMELU.MarginalMoment` defines the concrete
sum of three CSS supported-label spaces and its rank; checks the exact
455/60/15 six-party graph counts; and proves the `60+b` concurrency
reduction, rank-four trace specialization, and exact `70>66`
LU-separation implication.  The density-matrix trace expansion,
incidence/rank bridge, H3 ten-count, GRS six-bound, and LU covariance are
named hypotheses rather than hidden axioms.  The warning-free import gate,
trace-only aggregate gate, no-build probes, and native-aware axiom audit
passed.  See `2026-07-24-c567-ame-lu-lean-marginal-moment.md`.

**C568 closed (2026-07-24): logical phase and exact four-copy separator
interface complete.**  `RelativeConicArcs.AMELU.LogicalPhase` proves the
fixed-party kernel is `SL_2` on the conic locus and the diagonal split torus
off it from four explicit propagation hypotheses; the party-moving
isoduality/normalizer clause remains a manuscript proof input.
`RelativeConicArcs.AMELU.FourCopyContraction` defines the concrete matching
linear map and rank, exact q=13 generators and four-copy pattern, and the
party-orbit rank formula; it also proves the orbit sum is independent of
party relabelling of the seed pattern and proves that common bra-copy
relabelling normalizes the first copy permutation to the identity without
changing rank.  Its terminal derives arbitrary-LU inequivalence from explicit
`720/13^9` and `3024/13^9` certificate inputs.  The import gate, exact
no-build checks, and standard-axiom audit passed.  See
`2026-07-24-c568-ame-lu-lean-logical-phase.md`.

**C569 closed (2026-07-24): transport divisor interface complete.**
`RelativeConicArcs.AMELU.TransportDivisor` defines the parametric reduced
`9 × 9` block operator; proves all three cycle-polynomial factorizations,
the exact `(B^2-2A^2)(9B^2-4A^2)` and `(z-2)(9z-4)` divisor identities,
the rank-excess arithmetic, and the characteristic-seven doubled scheme and
zero-set merger; and derives the `96+192=288` merged support count from
explicit orbit-geometry inputs.  The determinant expansions, systematic
rank bridge, generic kernel dimension, and double-coset recognition remain
named hypotheses.  The import gate, exact no-build checks, and standard-axiom
audit passed.  See
`2026-07-24-c569-ame-lu-lean-transport-divisor.md`.

**C570 closed (2026-07-24): aggregate formal audit and statement
adequacy complete.**  `RelativeConicArcs.Gates.AMELUAggregate` imports all
seven adopted AME formal packages in one environment, and
`AMELUAggregateAxioms` audits 33 paper-facing declarations.  Outside the
three native marginal graph counts, the audit reports only `propext`,
`Classical.choice`, and `Quot.sound`; the native declarations expose their
three exact toolchain-local axioms.  The new
`formal-statement-adequacy.md` maps every manuscript label to exact Lean
declarations and distinguishes unconditional coverage, conditional
interfaces, and unformalized paper proofs.  Section 8 and all formal trust
ledgers now use the same boundary.  The measured aggregate/no-build gates
and warning-free `make check` passed.  See
`2026-07-24-c570-ame-lu-lean-aggregate-audit.md`.

**C571 closed (2026-07-24): adversarial second draft and independent cold
read complete.** The proof/evidence audit repaired the LC-holonomy,
logical-phase, marginal-incidence, generic-constancy, and party-dependent
transport arguments; mapped every conditional formal input field to exact
prose/evidence; replayed all seven evidence bundles; and produced a
warning-free, visually inspected 15-page PDF. The independent reader found
the release-blocking extension-field Frobenius counterexample: Theorem 1.1
remains all-prime-power, while `LC iff LU iff z` and the full logical-phase
theorem are now restricted to odd prime fields. A final cold read returned
GO. A localized Milnor/Serre-style sweep then tightened the abstract and
logical-phase transition without changing theorem scope. See
`2026-07-24-c571-ame-lu-adversarial-second-draft.md`.

**C580 closed (2026-07-24): bounded scalar blindness versus marginal
covariant rigidity.**  For every fixed copy bound `M`, outside finitely many
`M`-dependent characteristics and for all sufficiently large `q`, at least
`ceil((q-d_M)/8)` admitted LU classes agree on every scalar LU invariant
through bidegree `(M,M)`, and hence on every outcome distribution of an
`M`-copy LU-invariant measurement.  C559's common generic-rank open and
C396's degree-eight quotient give the growing packet, while C560 shows that
the algebraic-degree-one four-party marginal covariants nevertheless
separate its classes by retaining the local Weyl axes.  This is not a
single-specimen tomography claim.  Haar-randomizing an unknown local frame
also makes the class label independent of every arbitrary `M`-copy
measurement transcript, by twirling its POVM into the blind invariant
sector.  Equivalently, the packet is a linearly growing family of
pairwise monomially inequivalent MDS codes with identical complete
contraction-rank profiles through copy degree `M`; a uniform class label has
zero mutual information with every `M`-copy LU-invariant scalar transcript.
This remains an optional synthesis corollary, not a change to C561's
headline.  See
`2026-07-24-c580-scalar-covariant-separation.md`.

**C572 closed (2026-07-24): reproducible local release candidate.** The
paper-only public tree and formal Lean companion have separate immutable
SHA-256 identities. A deterministic exporter produces a complete scholarly
bundle and a minimal arXiv source bundle; clean source rebuilds the tracked
15-page PDF byte for byte, and the complete evidence replay passes from the
extracted public bundle. Quantum and arXiv policy checks leave only author
decisions: public identifier, name/affiliation/ORCID, funding and
contribution/AI disclosure, license/category, rights, account readiness, and
explicit upload or submission authorization. No external action was taken.
See `2026-07-24-c572-ame-lu-release-candidate.md`.

**C594 closed (2026-07-24): external major revision adopted.**  The C572
candidate is superseded pending a second independent review.  Theorem 4.1 now
handles the \(A^2=B^2\), \(z=1\) collapsed bracket multiset explicitly.
Theorem 5.1 replaces its asserted propagation step by a proved
distance-four diagonal-multiplier lemma and explicit elementary-unipotent
generation.  Section 7 now distinguishes the exact \(Q_p\) from its
\(2(t-1)\)-scaled polynomial representative and uses the correct \(p=\pi\)
index convention.  The logical phase is promoted to the title and abstract,
the transport material is compressed, and the literature now includes
Coble/Dolgachev--Ortland, Segre/Hirschfeld/Ball--Lavrauw, and
polynomial/quantum Reed--Solomon and transversal-gate context.  The
warning-free 15-page build and all seven evidence replays pass.  See
`2026-07-24-c594-ame-lu-major-revision.md`.

**C598 closed (2026-07-24): scope and self-containedness revision.**  The
promoted logical-phase claim now carries its odd-prime-field restriction in
both the abstract and introduction, while the LU-to-LC theorem remains
all-prime-power.  Theorem 6.1 now proves its characteristic-\(3,5\) clauses by
explicit subgroup and polynomial arguments.  The redundant transport
calculation has moved to Appendix A; its orbit--stabilizer quotients,
support-disjointness argument, and characteristic-\(3,5,7\) identities are
restored.  The novelty-search sentence is narrowed to its actual coverage,
and the Aharonov--Ben-Or and Ball--Lavrauw records are corrected.  The
warning-free 16-page build, rendered-page inspection, and seven-bundle replay
pass.  See `2026-07-24-c598-ame-lu-scope-self-containedness.md`.

**C599 closed (2026-07-24): local re-review closure.**  Section 5 now
restricts the displayed \(\mathcal K_C\subseteq\mathrm{SL}_2(q)^6\) kernel at
first use and contrasts the full extension-field
\(\mathrm{Sp}_{2e}(\mathbb F_p)\) action.  Theorem 6.1 uses only the proved
sharp bound \(b\leq6\) and records its octahedral equality case.  The
introduction credits established quantum Reed--Solomon, polynomial-code, and
general stabilizer gate constructions while identifying the paper's
contribution as the fixed-party self-association iff classification.  Dickson
and Faber now receive their exact finite-field/general-field roles, and
Section 2 proves that six-arcs exist exactly for \(q\geq4\) without adding an
inert theorem hypothesis.  The warning-free 16-page build, five-page visual
sweep, seven-bundle replay, and public/formal release checks pass.  See
`2026-07-24-c599-ame-lu-local-review-closure.md`.

**C600 closed (2026-07-24): final local referee corrections.**  Theorem 6.1
now exposes characteristic-five vacuity in its statement and conditions the
octahedral equality example on the required \(S_4\) subgroup.  Proposition
6.3 separates the parameter field, its cardinality, and local dimension.
The introduction links the redundant appendix witness to Corollary 1.2 and
states the bounded literature-search scope for the logical-phase comparison.
The Aharonov--Ben-Or Section 5 and Dickson §§239--261 locators remain
confirmed.  The warning-free 16-page build, all seven evidence replays, and
public/formal release checks pass.  See
`2026-07-24-c600-ame-lu-local-referee-corrections.md`.

## Queued completion program

The complete preparation, audit, formalization, and release program is queued
as C559--C572.  Dependency order is authoritative:

1. C559--C560: fixed-copy obstruction and uniform LU/LC rigidity theorem
   (complete).
2. C561: theorem, title, exception-table, and architecture freeze.
3. C562--C563: claim-specific literature audit and paper-local evidence import.
4. C564: first complete manuscript draft and warning-free PDF.
5. C565, C590, and C591: shared Lean foundation and complete dictionary;
   C566: pencil classification interface; C567--C569: remaining theorem
   packages (complete).
6. C570: aggregate import, axiom audit, and manuscript reconciliation
   (complete).
7. C571: adversarial audit, second draft, PDF inspection, and cold read
   (complete).
8. C572: clean replay, immutable manifest, public export, and release gates
   (complete, superseded by C594).
9. C594: external major-revision proof, convention, positioning, and
   literature sweep (complete; independent re-review pending).
10. C598: front-matter scope, self-contained exceptional arithmetic, and
    appendix disposition (complete).
11. C599: final local field-scope, involution-bound, attribution, existence,
    and transversal-gate positioning closure (complete).
12. C600: final theorem-local scope, referent, parameter-setting, sharpness,
    and bounded search-scope corrections (complete).

The revision has cleared the independent re-review findings and is complete
locally.  Public release waits on the author gates listed above. C581 remains a separately queued
optional manuscript upgrade: first determine whether the shortened marginal
planes recover the Desarguesian `F_q`-spread inside the additive `F_p` phase
space before attempting extension-field or approximate rigidity.

## Completion gates

1. Freeze the adopted theorem package and honest exceptional set.
2. Complete a claim-specific literature audit before novelty or priority
   wording.
3. Import every paper-facing computational claim as a committed report,
   generator, compact certificate, independent replay, and SHA-256 manifest.
4. Draft the manuscript with theorem labels synchronized to `theorem-map.md`.
5. Close the claim/proof/novelty and adversarial-evidence ledgers.
6. Run `make check`, inspect the PDF, and close the second-draft fix plan.
7. Complete a clean public replay/export plan and obtain a cold expert read.

## Allowed paths

- `papers/ame_lu/**`
- `notes/handoffs/2026-07-24-ame-lu-paper.md`
- `notes/2026-07-24-ame-lu-discovery-track.md`
- the exact report/output stem of an allocated `ame-lu` task

The completed crowns reports and their reproducibility bundles are read-only
inputs until deliberately imported into the paper evidence package.  Other
papers, handoffs, and Lean sources remain read-only unless the user expands
scope.

## Cross-lane relationships

- `crowns` owns the completed mathematical source reports.
- `ame-lu` owns theorem selection, remaining LU-rigidity work, manuscript
  synthesis, verification ledgers, and release preparation.
- Any future Lean work requires its own allocated `ame-lu` task and the nested
  Lean guide before action.
