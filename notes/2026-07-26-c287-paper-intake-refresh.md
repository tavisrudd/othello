# C287 paper-boundary intake registry

**Lane:** `build-sys`
**Status:** ACTIVE; current paper contracts synchronized; immutable source checkpoint blocked by
dirty arcs/Lean inputs
**Last clean monorepo commit inspected:** `c09b390129bfb15cd14d37762de02b6ac2345516`

## Export rule

The private monorepo is an immutable input to the extraction wave. No module is deleted, renamed,
or rewritten here. Public-prose rewrites, API consolidation, and the approved removal of
`ProjectiveCap.Almost.OddEscape` and `ProjectiveCap.StableFacts` occur only while constructing the
fresh-history target candidate. The target transformation must be recorded as a deterministic
source-to-source delta and validated with the complete target commit.

An input checkpoint is admissible only when every exported source and paper-contract path matches
one private source commit. Stopped Lean processes do not make a dirty worktree immutable.

## Adopted paper boundaries

| Paper state | Adopted Lean root or boundary | Current source contract | Public-package split |
|---|---|---|---|
| Arcs complete outside a prescribed conic | `RelativeConicArcs.Gates.ArcsCompleteOutsideConic` | 61 audited terminals; raw project import closure 1,392 files | 74-file human/core portion in `finitegeom`; 1,318 `Q16CertificateData`/`Q16CertificateRows`/`Q16LeafData` files in the opt-in Q16 certificate package |
| AME--LU | `RelativeConicArcs.Gates.AMELUAggregate`, `RelativeConicArcs.Gates.AMELUAggregateAxioms` | current release manifest: 83 formal artifacts, comprising 78 Lean files and five build-identity files; tree SHA-256 `dd217eb47952cc9e31dd65cb2e4799dbf40828c77bed5c77cd17964991dfa2a1`; aggregate axiom gate prints 175 terminals | all human-scale Lean source in `finitegeom`; five non-Lean identity files remain environment inputs |
| Beyond-four PRS R5--R7 | `PRSFoundation`, `PRSRedundancyFive`, `PRSPolarInductionRedundancySixSeven`, `PRSStableComponents`, `PRSBeyondRedundancyFour`, and `PRSBeyondRedundancyFourAxiomAudit` under `RelativeConicArcs.Gates` | exact 17-file union; 74 ordered audit terminals | geometric state in `finitegeom`; balanced-quantum gates remain a separate later state after AME--LU |
| Clebsch Rigidity | `RelativeConicArcs.Gates.ClebschRigidityTrust` | 24 terminals; raw project import closure 157 files | 17-file human/core portion in `finitegeom`; 140 Q11-generated files in the opt-in Q11 certificate package |
| Clebsch Factorization | `RelativeConicArcs.Gates.ClebschArithmeticGluing`, `ClebschHilbertSymmetry`, and `ClebschHyperplaneSquare` | three-gate fingerprint now complete; 29-file union; 26 printed terminals | human-scale state in `finitegeom` |
| Clebsch Passages | no Lean root | four trust-manifest claim groups covering nine manuscript labels; the manifest explicitly claims no Lean dependency | paper boundary only; creates no `finitegeom` state |
| Complete bounded repair ports | `RepairPorts.Gates.CompletePorts` | observed trust fact: exact 30-file closure and 36 terminals, all with only `propext`, `Classical.choice`, and `Quot.sound` | human-scale state in `finitegeom`; retained finite replay bundles stay paper-side unless separately packaged |

The Clebsch Factorization fingerprint generator now content-addresses all three advertised gates,
including `ClebschHyperplaneSquare`; the former two-gate mismatch is closed.

## Candidate-state order

1. first human-scale finite-geometry tag, with C553 transformations applied only in the target;
2. arcs core plus its separately validated Q16 package dependency;
3. Clebsch Rigidity core plus its separately validated Q11 package dependency;
4. Clebsch Factorization;
5. AME--LU;
6. geometric PRS R5--R7;
7. PRS balanced quantum, after AME--LU;
8. complete ports.

Clebsch Passages remains in the paper registry but does not create a source state. Shared hashes
deduplicate review work; each paper retains its own gate, terminal ledger, package pins, and exact
candidate commit.

## Current checkpoint blockers

- The Lean worktree has foreign modified and untracked paths. In particular,
  `RelativeConicArcs/Gates/ArcsCompleteOutsideConic.lean` differs from `HEAD`, so the current arcs
  paper contract cannot yet be tied to a commit.
- The current arcs manuscript and proof-audit files are also modified outside this lane.
- The two referee-prose defects reported by AME--LU remain in
  `RelativeConicArcs/Plane.lean` and `FiniteGeom/Code.lean`. Their public rewrites belong in the
  target transformation unless their source owners land clean private-source corrections first.
- The first candidate still needs the deterministic C553 rewrite, the exact transformed
  26-file manifest, and a whole-closure semantic review before it can become the first commit.

No Lean/Lake command, source copy, target deletion, remote action, or public commit was performed
while synchronizing this registry.
