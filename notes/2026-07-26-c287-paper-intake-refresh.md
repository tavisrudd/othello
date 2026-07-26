# C287 paper-boundary intake refresh

**Lane:** `build-sys`
**Status:** complete planning refresh; no source export or Lean action performed
**Evidence snapshot:** monorepo commit
`e4ccab889b34f6af3761ae2ab270a4d061da6d74`

## Result

C287's coordinated extraction plan now reflects the current paper-owned trust boundaries:

- AME--LU C602 is complete at 67 project-owned Lean files plus five locked build-identity files.
- The geometric PRS R5--R7 closure is 17 files with 74 ordered audit targets. Its balanced-quantum
  gate is a separate cross-paper state that must follow AME--LU.
- Clebsch Rigidity retains its nineteen-row/24-terminal single-gate boundary.
- Clebsch Factorization advertises three Lean gates and six Lean-backed claim rows, but its evidence
  fingerprint contains closure maps for only two of those gates. It remains blocked from source
  intake.
- Clebsch Passages has a release-ready nine-claim trust manifest and no Lean root. It is recorded
  as a paper boundary but creates no `finitegeom` state.

The live plan, intake, execution card, and build-system handoff now agree that source export waits
for C553, two foreign-owned public-prose repairs identified by C602, and the complete three-gate
Clebsch Factorization fingerprint.

## Evidence hashes

- Clebsch Rigidity trust manifest:
  `a05fbd075ea335350b9ffeeda33ed0314d2fc9a69c89e091fd871c00121e64e2`
- Clebsch Factorization trust manifest:
  `b1d47ee9db48c5e82a43bdadba2cf364cdda392a0e188bccc6038da7d2bc8f5c`
- Clebsch Factorization evidence fingerprint:
  `e741658f577dc8cbca05ef96ee505951d62d73b834e25e0160928d04957a2a89`
- Clebsch Passages trust manifest:
  `56fc3b841c42ed7ea915e05fa5af8bf96114bd19425aee9f81326beb9d8478d7`
- PRS exact-closure statement map:
  `cca570904b381358dff893b98a9016c68082ad4542f294eb634e8c8d54dc83eb`
- AME--LU statement-adequacy map:
  `07ba0643fc8599db03b701b097e45efb0456009390e671f3b10f65c8f9dab776`
- C602 trust-audit report:
  `150a7adeed757bb234f9a222a7c0ca717b4de1572819924d21f9e1a5263f87d7`

## Open evidence gaps

- `ClebschHyperplaneSquare` is advertised by the factorization runner but is absent as a key from
  `project_lean_import_closure_sha256`; the source owner must regenerate the complete fingerprint.
- Clebsch Passages has no missing Lean evidence because it currently makes no Lean-backed claim.
  A later formal companion would require a new manifest delta rather than inferred reuse.

