# AME local-unitary paper

**Lane:** `ame-lu`

**Purpose:** complete the paper currently titled *Clifford Geometry and
Local-Unitary Invariants of Six-Qudit AME Tensors*.

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

## Queued completion program

The complete preparation, audit, formalization, and release program is queued
as C559--C572.  Dependency order is authoritative:

1. C559--C560: fixed-copy obstruction and uniform LU/LC rigidity theorem
   (complete).
2. C561: theorem, title, exception-table, and architecture freeze.
3. C562--C563: claim-specific literature audit and paper-local evidence import.
4. C564: first complete manuscript draft and warning-free PDF.
5. C565--C569: shared Lean foundation and four theorem packages.
6. C570: aggregate import, axiom audit, and manuscript reconciliation.
7. C571: adversarial audit, second draft, PDF inspection, and cold read.
8. C572: clean replay, immutable manifest, public export, and release gates.

C562 is next; C563 is independently ready.  C562 audits the frozen headline
and portable diagonal-tensor criterion before any novelty wording.  C563
imports only the computations retained by C561's hierarchy.

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
