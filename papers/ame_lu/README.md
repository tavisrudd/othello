# Paper: Local-unitary rigidity and Clifford geometry of six-qudit AME stabilizer tensors

**Frozen title:** *Local-Unitary Rigidity and Clifford Geometry of
Six-Qudit AME Stabilizer Tensors.*

**Lane:** `ame-lu`

**Status:** theorem package and architecture frozen.  C560
shows that every local-unitary intertwiner between equal-phase CSS states of
linear `[6,3,4]_q` MDS codes is local Clifford.  C561 fixes the title,
theorem hierarchy, exception table, and section order.  The paper-local
evidence bundle, claim-specific literature audit, and complete prose are not
yet closed.

The completion program is queued as C559--C572: theorem decision, theorem
freeze, literature and reproducibility audits, first draft, four Lean theorem
packages plus their shared and aggregate gates, adversarial second draft, and
release candidate.

## Build

From this directory:

```text
make check
```

The build driver is `main.tex`; section units are under `sections/`.  Paper
control lives in:

- `theorem-map.md`;
- `claim-proof-novelty-ledger.md`;
- `verification-map.md`;
- `formalization-ledger.md`;
- `adversarial-proof-evidence-audit.md`; and
- `second-draft-fix-plan.md`.

The `supplement/` directory is initially an empty evidence package with a
manifest checker.  No computational claim is adopted into the manuscript
until its report, exact generator, compact certificate, replay command, and
hashes have been imported and independently checked.

## Mathematical scope

The paper studies equal-phase CSS `AME(6,q)` tensors arising from
six-point projective arcs and their `[6,3,4]_q` MDS kernels.  Its proved core is:

1. exact local-Clifford classification of the admitted non-GRS pencil by one
   bracket scalar `z`;
2. the `SL_2(q)` versus split-torus logical-Clifford phase on and off the GRS
   locus;
3. uniform arbitrary-LU separation of good H3 reductions from every GRS
   class;
4. an exact four-copy separator for the difficult `q=13` pair; and
5. a transport-sheaf explanation of the exceptional contraction divisor and
   its multiplicities.

Fixed-copy permutation contractions cannot supply a generic pencil
coordinate: on an equal-phase linear-code state each is a power of `q`
determined by a linear-system rank.  Their maximal minors detect special
rank-jump divisors, but their values are generically constant.

For the admitted odd non-GRS pencil, C560 and C396 give
`LU iff LC iff z equality`.  The all-MDS/CSS theorem is stronger: every LU
intertwiner is Clifford.  This is a theorem for the stated six-qudit
MDS/CSS family, not a revival of the false global LU--LC conjecture.

## Initial source set

- `notes/2026-07-19-c374-clebsch-ame-equivalence.md`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- `notes/2026-07-23-c397-ame-perfect-tensor-physics.md`
- `notes/2026-07-23-c402-h3-ame-uniform-lu-separation.md`
- `notes/2026-07-23-c546-h3-pentad-orientation-lu.md`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.md`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.md`
