# C685 Clebsch Passages formal companion

**Lane:** `build-sys`
**Status:** ACTIVE; exact formal surface corrected, `finitegeom` candidate constructed, clean replay
running, paper lock waits for a publicly reachable immutable commit

## Corrected statement boundary

The current manuscript's formal companion is the three-module closure of
`RelativeConicArcs.Gates.ClebschOrientationMechanisms`:

- `RelativeConicArcs.InvolutiveOddUnit`;
- `RelativeConicArcs.KneserPairEigenspace`; and
- the import-only gate.

The odd-unit localization theorem accompanies only the symbolic splitting clause in `ARITH-1`.
The pair-sum equivalence and dimension theorem accompany only the abstract Petersen-module clause
in `HARM-1`. Neither is a premise of a manuscript theorem. `ARITH-2`, `HARM-2`, the `5J₀` square
class, golden fibre, spinor specialization, face-axis geometry, spherical moments, and Gaunt
coefficient remain outside formal coverage.

The originally proposed `ClebschPassageInterfaces` and `ClebschHarmonicQuotient` gates concern
theta/Fourier/code interfaces and a low-degree conic harmonic quotient from a broader development
surface. They do not match the current degree-six paper. `Q11BrianchonPetersen` belongs to the
separate Clebsch-hexagon dictionary. None enters the C685 export.

## Immutable inputs and candidates

- Private preparation checkpoint:
  `4493afe499109531bf5dcb489f79a2edc1ae8ed5`.
- Exact companion closure: 3 Lean modules, 34,834 bytes, 939 lines, one external import (`Mathlib`).
- Public `finitegeom` candidate branch: `candidate/c685-clebsch-passages`.
- Current candidate commit:
  `d8ea8326f09da54ffd50b77a3bf54f91a7fbb5ed`.
- Standalone paper candidate:
  `~/src/math-papers/clebsch-passages-c685`; the existing superseded
  `~/src/math-papers/clebsch-passages` history has not been modified or replaced.

The public candidate adds an exact content manifest, paper-to-Lean boundary, twelve-terminal trust
spine, axiom-audit entry point, and extraction provenance. It contains no generated certificate,
private source path, or private Git history.

The paper candidate records the exact `finitegeom` commit, gate, concept DOI, audit, and manifest.
Its flake uses the immutable GitHub revision and checks that the three named formal-companion
artifacts exist. The paper manifest retains `formal_coverage: none claimed`.

## Validation state

The target working-tree gate passed under the serialized `single` profile in 4:51.55 wall time
with a 2,871,812 kB peak. Its final trace-only aggregate passed. The twelve observed axiom sets
match `trust/areas/clebsch_passages.toml` exactly: each is a subset of `propext`,
`Classical.choice`, and `Quot.sound`, with no project-local axiom, generated certificate,
`native_decide`, or admitted declaration.

A separate clone of candidate commit `8fe749cce6d8a2deff3060d5c15393a9d5c11d94` is running the cold Lean replay.
The current candidate differs only by the tracked provenance document; after the cold replay
finishes, the clean clone must advance to `d8ea8326f09da54ffd50b77a3bf54f91a7fbb5ed` and pass an
exact trace-current aggregate before local `main` may fast-forward.

The paper flake parses and its companion metadata is internally consistent. `flake.lock` cannot be
generated against the immutable GitHub revision until that `finitegeom` commit is publicly
reachable. No push is authorized or performed. The paper candidate therefore remains uncommitted
and its release/clean-room aggregate is intentionally not run with a fabricated local-path lock.

## Next

1. finish the clean `finitegeom` replay and exact-current confirmation;
2. fast-forward local `finitegeom/main` only after that candidate passes;
3. obtain explicit authority to push the validated `finitegeom` commit;
4. generate the paper's remote-revision `flake.lock`, refresh its content manifest, run the paper
   and clean-room gates, and construct its fresh final history; and
5. replace the superseded local paper directory only with explicit history-replacement authority.
