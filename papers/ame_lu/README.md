# Paper: Local-unitary rigidity of MDS--CSS AME tensors and logical Clifford phases of six-qudit codes

**Title:** *Local-Unitary Rigidity of MDS--CSS AME Tensors and Logical
Clifford Phases of Six-Qudit Codes.*

**Lane:** `ame-lu`

**Status:** version-1 revision under C609. Every local-unitary intertwiner
between equal-phase CSS states of linear `[2m,m,m+1]_q` MDS codes is local
Clifford, for every prime power and \(m\geq2\); the associated
`[[2m-1,1,m]]_q` quantum MDS code has no transversal non-Clifford logical
unitary. The six-party pencil and logical-phase applications retain their
existing scopes. Public identifiers, author metadata, license choice, and
submission authorization remain author gates.

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

The `supplement/` directory contains the paper-local report, exact generators,
compact certificates, load-bearing input, SHA-256 manifest, and deterministic
replay driver for every adopted computation.  Run `make evidence` for the
integrity gate or `python3 supplement/verify.py --replay` for full regeneration.

The `release/` directory contains the immutable release manifest, deterministic
paper-only export driver, public-export plan, and target-policy checklist. Run
`make release-check` for the warning-free manuscript build, full evidence
replay, and release-manifest verification.

## Mathematical scope

The headline theorem studies equal-phase CSS `AME(2m,q)` tensors arising
from linear `[2m,m,m+1]_q` MDS codes.  The detailed geometric applications
specialize to `AME(6,q)` tensors from six-point projective arcs.  Its proved
core is:

1. uniform LU-to-LC rigidity and the associated transversal Clifford no-go;
2. exact local-Clifford classification of the admitted non-GRS pencil by one
   bracket scalar `z`;
3. the `SL_2(q)` versus split-torus logical-Clifford phase on and off the GRS
   locus;
4. uniform arbitrary-LU separation of good H3 reductions from every GRS
   class;
5. an exact four-copy separator for the difficult `q=13` pair; and
6. a transport-sheaf explanation of the exceptional contraction divisor and
   its multiplicities.

Fixed-copy permutation contractions cannot supply a generic pencil
coordinate: on an equal-phase linear-code state each is a power of `q`
determined by a linear-system rank.  Their maximal minors detect special
rank-jump divisors, but their values are generically constant.

For the admitted odd non-GRS pencil, C609/C560 and C396 give
`LU iff LC iff z equality`.  The all-MDS/CSS theorem is stronger: every LU
intertwiner is Clifford.  This is a theorem for the stated linear
MDS/CSS family, not a revival of the false global LU--LC conjecture.

## Initial source set

- `notes/2026-07-19-c374-clebsch-ame-equivalence.md`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- `notes/2026-07-23-c397-ame-perfect-tensor-physics.md`
- `notes/2026-07-23-c402-h3-ame-uniform-lu-separation.md`
- `notes/2026-07-23-c546-h3-pentad-orientation-lu.md`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.md`
- `notes/2026-07-23-c550-four-copy-cover-holonomy.md`
