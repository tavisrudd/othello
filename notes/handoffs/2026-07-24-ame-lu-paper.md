# AME local-unitary paper

**Lane:** `ame-lu`

**Purpose:** complete the paper titled *Local-Unitary Rigidity and Clifford
Geometry of Six-Qudit AME Stabilizer Tensors*.

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
Weyl axes and hence be Clifford.  This holds for equal-phase CSS states of
all linear `[6,3,4]_q` MDS codes over every prime power.  Combined with C396,
the admitted odd pencil satisfies `LU iff LC iff z equality`, with no new
exceptional characteristics.  Two four-party marginals covering all six
parties suffice.  See `2026-07-24-c560-ame-lu-orbit-rigidity.md`.

**C561 closed (2026-07-24): theorem package and architecture frozen.**  The
title is *Local-Unitary Rigidity and Clifford Geometry of Six-Qudit AME
Stabilizer Tensors*.  C560 is the headline theorem; C396's `LU iff LC iff z`
is its admitted-pencil corollary.  Logical operations, explicit LU
certificates, fixed-copy generic constancy, and the transport divisor are
subordinate results.  The synchronized boundary table distinguishes the
all-prime-power rigidity theorem, the odd admitted pencil, and detector-only
exceptional characteristics.  See
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

## Queued completion program

The complete preparation, audit, formalization, and release program is queued
as C559--C572.  Dependency order is authoritative:

1. C559--C560: fixed-copy obstruction and uniform LU/LC rigidity theorem
   (complete).
2. C561: theorem, title, exception-table, and architecture freeze.
3. C562--C563: claim-specific literature audit and paper-local evidence import.
4. C564: first complete manuscript draft and warning-free PDF.
5. C565, C590, and C591: shared Lean foundation and complete dictionary;
   C566: pencil classification interface (complete); C567--C569: three
   remaining theorem packages.
6. C570: aggregate import, axiom audit, and manuscript reconciliation.
7. C571: adversarial audit, second draft, PDF inspection, and cold read.
8. C572: clean replay, immutable manifest, public export, and release gates.

C567 is next: formalize the marginal trace/rank and concurrency-count
reduction used by the uniform H3-versus-GRS LU separator.  C581 is a
separately queued optional upgrade gate for basis-free phase-space
reconstruction and quantitative approximate rigidity.

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
