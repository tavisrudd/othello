# AME local-unitary paper

**Lane:** `ame-lu`

**Purpose:** complete the paper titled *Local-Unitary Rigidity and
Transversal Clifford Groups for MDS--CSS AME States*.

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

**C609 closed (2026-07-25): uniform version-1 headline adopted.**
The LU-to-LC theorem now holds for every prime power, every \(m\geq2\), and
every existing linear `[2m,m,m+1]_q` MDS/CSS equal-phase state.  Its Choi
corollary proves that the associated `[[2m-1,1,m]]_q` quantum MDS code has
only Clifford product logical implementations, with every physical factor
Clifford.  The proof uses the same rank-one axis mechanism after the general
dual shortening `[2m,m,m+1] -> [m+1,1,m+1]`; the six-party pencil and
logical-phase scopes are unchanged.  The warning-free 17-page build and
release gates pass.  The formalization is split into C601's generic
foundations, C612's rigidity terminal, C613's Choi/transversal terminal, and
C615's projective automorphism group packaging
before C602's aggregate audit.  See
`2026-07-25-c609-ame-lu-uniform-rigidity-v1.md`.

**C614 closed (2026-07-25): higher-\(m\) applications adopted.**
The transversal corollary now covers conversions between two associated
encoders, and product-unitary state symmetries are projectively finite.  For
odd prime \(q\) and \(2m\le q+1\), the GRS/extended-GRS quantum-MDS tower has
exact projective transversal logical group
\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\); the extended
`[8,4,5]_7` code gives the explicit `AME(8,7)` / `[[7,1,4]]_7` order-16464
case.  The manuscript has the operational title *Local-Unitary Rigidity
and Transversal Clifford Groups for MDS--CSS AME States*.  The
warning-free 18-page build, visual copy edit, seven-bundle
replay, and public/formal release checks pass.  C612 and C613 have since
closed the rigidity, encoder, exact-group-interface, and explicit-example
formalization.  See
`2026-07-25-c614-ame-lu-higher-m-applications.md`.

**C612 closed (2026-07-25): general rigidity and discrete symmetry formalized.**
The length-generic Lean development now proves the exact shortened marginal
expansion, local-unitary marginal covariance, arbitrary-arity tensor-axis
rigidity, the retained-coordinate cover, and the unconditional LU-to-LC
terminal for every prime power and every \(m\geq2\).  The six-party and
admitted-pencil terminals are recovered from the generic theorem.  The
projective one-site Clifford quotient is finite; consequently the product
automorphism quotient is finite, and its identity component before quotient
is exactly the torus of one-site scalar phases.  Both statements remain true
after adjoining party permutations.  The warning-free aggregate build and
axiom audit pass.  See
`2026-07-25-c612-ame-lu-lean-general-rigidity-terminal.md`.

**C615 closed (2026-07-25): projective automorphism groups packaged.**
The fixed-party and party-permuted product-unitary automorphism carriers are
now explicit topological groups, with the latter using the proved
semidirect-product law.  Independent scalar phases form a central subgroup
in the fixed-party group and a normal subgroup after party permutations.
Both scalar quotients are explicit quotient groups, their projectivizations
are continuous group homomorphisms, their exact finite signature detectors
are continuous maps, and C612's finiteness and identity-component terminals
transfer without changing scope.  The aggregate gate and axiom audit pass
with only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c615-ame-lu-projective-automorphism-group-packaging.md`.

**C613 closed (2026-07-25): encoder and transversal Clifford bridge formalized.**
`RelativeConicArcs.AMELU.EncoderTransversal` proves the one-leg
`[[2m-1,1,m]]` parameter bridge, exact `((Lᵀ)⁻¹⊗U_phys)` Choi orientation,
canonical inverse transpose from logical unitarity, Clifford
adjoint/conjugation/transpose closure, and factorwise logical/physical
Cliffordness.  It also checks the diagonal-duality CSS shears, arbitrary
upper/lower unipotent coefficients, conditional exact
`𝔽² ⋊ SL₂(𝔽)` carrier equality, and order-16464 specialization.  The exact
GRS terminal retains the concrete code construction, phase-corrected lifts,
Pauli representatives, elementary generation, and converse as named inputs.
The warning-free aggregate build, axiom audit, and 18-page manuscript build
pass.  See `2026-07-25-c613-ame-lu-lean-transversal-clifford.md`.

**C617 closed (2026-07-25): scalar-torus exact sequences and discrete
quotients formalized.**
`RelativeConicArcs.AMELU.AutomorphismExactSequence` proves the fixed-party
and party-permuted scalar tori closed and normal; packages their injective
inclusions, surjective projectivizations, exact pairs, and finite discrete
quotients; replaces the detector maps by continuous homomorphisms into
intrinsic Clifford adjoint-signature groups with exact scalar kernels and
canonical realized-image identifications; and proves that the fixed-party
projective group is exactly the kernel of the realized party-permutation
quotient.  The splitting boundary is exact: it requires a homomorphic right
inverse, while C613's phase-corrected generator representatives do not supply
that coherence.  The aggregate gate, axiom audit, and warning-free visually
inspected 19-page manuscript pass.  See
`2026-07-25-c617-ame-lu-automorphism-exact-sequence.md`.

**C602 closed (2026-07-25): full Lean/trust/style audit complete.**
Both scalar inclusions are now continuous homomorphisms; the intrinsic
Clifford adjoint quotient has a closed scalar kernel and formal
Hausdorff/discrete topology; and both automorphism groups have explicit
finite covers by scalar-torus connected components.  The paper and formal
sources distinguish the homomorphic-right-inverse splitting criterion from
an extension-class obstruction.  The release manifest recursively pins all
72 project-owned files in the formal verification graph.  The AME--LU owned
layer is referee-prose clean, but two exact foreign-owned blockers remain:
`RelativeConicArcs/Plane.lean:7` reverse-references another paper directory,
and `FiniteGeom/Code.lean:16` cites an internal handoff/work phase.  The
aggregate gate, 100-declaration axiom audit, warning-free 19-page manuscript,
seven evidence replays, visual inspection, and 35-public/72-formal release
checks pass.  See
`2026-07-25-c602-ame-lu-full-lean-trust-audit.md`.

**C618 closed (2026-07-25): nonabelian extension invariant formalized.**
The realized party-permutation exact sequence now has a canonical
section-free outer action on the fixed-party projective group.  A normalized
choice of lifts has an explicit nonabelian factor set; Lean proves its
normalization, associativity identity, ordered change-of-section law, and
choice-independent trivializability.  Trivializability is equivalent to a
homomorphic section and hence to splitting, with no abelian-kernel shortcut.
The aggregate axiom audit and warning-free 19-page manuscript/release gates
pass.  See
`2026-07-25-c618-ame-lu-nonabelian-extension-class.md`.

**C619 closed (2026-07-25): GRS split-versus-obstruction boundary exact.**
For generalized and extended GRS codes, propagation from any chosen input
block is coordinatewise conjugation by
`\(\operatorname{diag}(1,s_i/s_j)\)`, so all `SL_2(q)` relations hold
exactly.  In odd characteristic the finite Heisenberg representation has a
genuine Weil extension, and the scalar extension therefore splits over the
linear `SL_2(q)` factor.  It does not split over the full affine one-qudit
group: the nontrivial Weyl commutator obstructs a homomorphic lift of
`\(\mathbb F_q^2\)`.  This is a Heisenberg obstruction, not a residual
metaplectic or Schur-multiplier obstruction.  C618's party-permutation
extension is independent and remains governed by its code-specific
nonabelian factor set.  No finite computation was needed.  The warning-free
20-page manuscript, seven evidence replays, 35-public/73-formal release
checks, and trust ledgers are synchronized.  The manuscript now also isolates
the reusable full-Weyl marginal-cover criterion and states the exact
fixed-party projective six-arc groups:
`\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\)` on the GRS locus and
`\(\mathbb F_q^2\rtimes T\)` off it; no uniform party-moving equality is
claimed.  `all_isClifford_of_fullWeylDiagonal_intertwining` now formalizes
the reusable local criterion, while
`fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus`
formalizes the exact affine carrier from the explicit complete-translation
fiber hypothesis.  Both are included in the aggregate axiom audit, which
passes with only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c619-ame-lu-grs-splitting-obstruction.md`.

**C622 closed (2026-07-25): diagonal isoduality is the intrinsic
all-length logical phase.**  For every odd-prime linear
`[2m,m,m+1]_q` MDS code, the exact fixed-party projective transversal
logical group is `F_q^2 ⋊ SL_2(q)` precisely when `SC=C^perp` for a
nonsingular diagonal `S`, and `F_q^2 ⋊ T` otherwise.  The proof extends
the diagonal-multiplier lemma to arbitrary `m`, proves the off-diagonal
converse and complete translation fiber, and moves the coherent Weil lift
from the GRS presentation to the entire diagonally isodual branch.
The diagonal-duality witness space has dimension zero or one, giving a
linear nullity test, projective uniqueness of the propagation ratios, and
the hyperbolic-form obstruction
`\(\det S\in(-1)^m(\mathbb F_q^\times)^2\)`.
The manuscript and trust ledgers now use this intrinsic boundary.
`EncoderTransversal` packages the exact conditional carrier terminal with
no GRS evaluation hypothesis, and the aggregate axiom audit passes with
only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c622-ame-lu-diagonal-isoduality-dichotomy.md`.

**C624 closed (2026-07-25): concrete party-permutation extensions split.**
The exact fixed and party-moving projective groups, normalized nonabelian
factor sets, outer actions, trivializing cochains, and complements are now
computed for both q=11 pencil classes, all four representative q=11 GRS
evaluation-set orbits, the q=17 and q=31 enhanced-symmetry rows, and four
split-prime integral H3 representatives.  The q=11 party groups are
`S5`, `S4`, `V4`, `C5`, `S3`, and `D12`; every listed extension splits.
On every non-GRS/H3 row, odd party motion inverts the fixed split torus and
enlarges the logical linear group exactly from `T` to `N(T)`.  The complete
factor tables and complement witnesses are reproducible and remain separate
from the Weil and Heisenberg scalar extensions.  No manuscript source was
edited.  See `2026-07-25-c624-ame-lu-party-extension-examples.md`.

**C629 closed (2026-07-25): split party-extension consequences formalized.**
`PartyExtensionSplitting` constructs the explicit normalized cochain that
trivializes a chosen factor set from any homomorphic complement, proves the
semidirect-product equivalence, unique kernel--quotient coordinates, exact
cardinality product, and the inverting-involution witness behind
`T`-to-`N(T)`.  The realized AME--LU specialization is imported through both
the dedicated and main aggregate gates; the axiom audit reports only
`propext`, `Classical.choice`, and `Quot.sound`.  The twelve concrete C624
complements remain honestly external exact computations until a generated
finite-table checker supplies the formal splitting witnesses.  No manuscript
source was edited.  See
`2026-07-25-c629-ame-lu-party-extension-formalization.md`.

**C623 closed negatively at its reconstruction gate (2026-07-25):
extension-field Clifford census complete.**
For the full `q=9,25,27` pencil, LC orbits are the GRS class plus Galois
orbits of `z`, but this equality of partitions hides genuine nonsemilinear
maps.  Every `q=9` non-GRS pair has such a witness; the fixed-party kernel
has order 96 with only 16 semilinear elements.  At `q=25` the GRS kernel is
the full `Sp_4(5)` of order 9,360,000, while non-GRS kernels have order 24;
at `q=27` they have order 26.  The shortened planes therefore do not
reconstruct the Desarguesian spread, so no positive reconstruction theorem
was attempted.  The exact standard-library replay, witnesses, kernel
invariants, and mystery ledger are in
`2026-07-25-c623-ame-lu-extension-field-clifford.md`.  No manuscript source
was edited.

**Post-C619 two-reader frontier (2026-07-25): exact frontiers closed;
quantitative successor remains queued.**
Two independent manuscript-only cold reads converged on the same research
frontiers.  C622 has proved the length-generic diagonal-isoduality
dichotomy, C624 has computed the first party-moving extensions, and C623 has
closed the extension-field reconstruction route negatively.  C581 remains
the separately queued quantitative approximate-rigidity problem and must
not reuse the failed exact spread-reconstruction premise.  The complete
synthesis, secondary questions, underdeveloped
connections, and EV rationale are in
`2026-07-25-ame-lu-two-cold-read-frontier.md`.

## Completion program

The complete preparation, audit, formalization, and release program through
C619 is closed.  Dependency order is authoritative:

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
13. C601: length-generic code/state/action API, exact MDS dual shortening,
    full-basis diagonal-axis theorem, and six-party compatibility foundation
    (complete).
14. C614: higher-\(m\) encoder conversion, discrete-symmetry, exact GRS-group,
    and explicit `[[7,1,4]]_7` applications (complete).
15. C612: shortened marginal expansion and covariance, general LU-to-LC
    terminal, six-party specialization, projective-finiteness, and
    scalar-phase identity-component corollary (complete).
16. C613: AME-to-`[[2m-1,1,m]]` encoder parameters, exact Choi orientation,
    Clifford transpose closure, transversal no-go, exact GRS group, and
    explicit `[[7,1,4]]_7` terminal (complete).
17. C615: explicit product-unitary and party-permuted topological groups,
    normal scalar-phase torus, quotient groups, and projectivization/signature
    maps preserving the C612 finiteness and identity-component terminals
    (complete).
18. C617: closed scalar-torus exact sequence, finite discrete quotient,
    intrinsic continuous signature homomorphisms, realized party-permutation
    extension, and splitting obstruction, using C613's GRS split where
    available (complete; the available GRS interface does not supply a
    coherent split).
19. C602: full AME-LU Lean/trust/style/standards audit and repair pass, after
    C617 (complete; two exact foreign-owned prose blockers recorded).
20. C618: canonical outer action, normalized factor set, nonabelian
    change-of-section law, and genuine splitting obstruction for the realized
    party-permutation extension, after C602 (complete).
21. C619: GRS/extended-GRS relation audit and exact
    split-versus-metaplectic/Schur-multiplier boundary, after C618 (complete).
22. C624: exact code-specific party-permutation groups, outer actions,
    normalized factor sets, splitting witnesses, and `T`-normalizer
    enlargements (complete).
23. C622: intrinsic all-length diagonal-isoduality dichotomy, arbitrary-length
    multiplier converse, complete translation fiber, manuscript adoption, and
    conditional evaluation-free Lean terminal (complete).
24. C623: extension-field `q=9,25,27` full additive-symplectic falsifier and
    nonsemilinear-kernel census (complete; spread reconstruction false).
25. C629: explicit cochain trivialization, semidirect decomposition,
    cardinality product, and torus-normalizer inversion witness in Lean
    (complete; concrete complements remain externally certified).

The revision has cleared the independent re-review findings and is complete
locally.  Public release waits on the author gates listed above. C581 remains
a separately queued optional manuscript upgrade in quantitative approximate
rigidity; C623 has disproved the exact spread-reconstruction premise.

C601--C615 close the paper's principal formalization gap in four acceptance
gates.  The full \(m=3\) prototype and pencil composition are already
unconditional in `RelativeConicArcs.AMELU.LURigidity` and
`RelativeConicArcs.AMELU.LUPencilClassification`.  C601 is complete:
`GenericDefinitions`, `GenericMDS`, and `GenericDiagonalTensor` provide the
length-generic code/state/action layer, exact dual `[2m,m,m+1]` shortening,
full-basis diagonal-axis theorem, and six-party compatibility.  C612 is
complete: the marginal expansion including the identity axis, covariance,
general Clifford terminal, compatible six-party/pencil specializations,
projective finiteness, and scalar-phase identity component are formalized.
C613 is complete: the one-leg quantum-MDS parameters, exact
Choi/transposition bridge, Clifford closure operations, transversal terminal,
GRS shear algebra, conditional exact carrier equality, and order-seven
specialization are formalized.  C615 upgraded C612's quotient carriers and identity-component
statements to explicit group/topological-group structures, normal scalar
phases, quotient groups, and structured projectivization/signature maps.  C617
has now packaged the closed exact sequences, discrete quotients, intrinsic
signature homomorphisms, realized party-permutation extension, and splitting
boundary.  C602 has completed the referee-facing audit of the AME-LU Lean
aggregate, trust ledgers, verification prose, scholarly closure, and release
claims.  C618 packages the section-free nonabelian party-permutation
invariant.  C619 separates it from the scalar lift problem: the GRS linear
symplectic factor splits by the odd-field Weil representation, while the full
affine one-qudit extension is non-split by the Heisenberg commutator.

**Token-constrained completion route:** the principal `ame-lu` Version-1
completion program is closed through C619.  The post-Version-1 diagonal
isoduality, party-extension, and extension-field frontiers C622/C624/C623
are complete, and C629 formalizes the reusable split-extension consequences.
C581 is now unblocked as a separate quantitative-rigidity upgrade, without
an exact spread-reconstruction assumption.  The next
cross-lane route remains C553 and then the coordinated build-system
extraction.  The authoritative three-session protocol is
`notes/2026-07-25-c287-token-efficient-execution.md`.

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
- `lean/RelativeConicArcs/AMELU/**`
- `lean/RelativeConicArcs/Gates/AMELU*.lean`
- `notes/handoffs/2026-07-24-ame-lu-paper.md`
- `notes/2026-07-24-ame-lu-discovery-track.md`
- the exact report/output stem of an allocated `ame-lu` task

The completed crowns reports and their reproducibility bundles are read-only
inputs until deliberately imported into the paper evidence package.  Other
papers, handoffs, and Lean sources remain read-only unless the user expands
scope.

## Cross-lane relationships

- `crowns` retains the completed source reports as provenance.
- `ame-lu` owns the H3 AME/LU/LC results, including theorem adoption,
  manuscript exposition, verification, and every future quantum-equivalence
  refinement; it also owns the remaining paper synthesis and release
  preparation.
- Any future Lean work requires its own allocated `ame-lu` task and the nested
  Lean guide before action.
