# C685 Clebsch Passages formal companion

**Lane:** `build-sys`
**Status:** COMPLETE; exact formal surface and standalone paper pin clean-replay-valid

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
- Validated local `main` and candidate commit:
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

A separate clean clone of candidate commit `8fe749cce6d8a2deff3060d5c15393a9d5c11d94`
passed the serialized build and trace-only aggregate in 52.40 seconds after restoring Mathlib's
pinned binary cache, with a 3,427,516 kB peak. The current candidate changes only the tracked
provenance document. The clean clone then advanced to
`d8ea8326f09da54ffd50b77a3bf54f91a7fbb5ed`; Lake reported the target current and replayed the
exact trace-only aggregate successfully. Local `finitegeom/main` was fast-forwarded to that commit
and is two commits ahead of `origin/main`. No push was performed.

The public commit became reachable on GitHub through a user-owned push. The paper's `flake.lock`
resolves that exact immutable revision and records its NAR hash. The formal-companion verifier,
complete paper release gate, content-addressed export verifier, `nix flake check`, warning-free
eleven-page build, and a separate exact-commit clean-clone replay all pass.

The fresh standalone paper history is now canonical at
`~/src/math-papers/clebsch-passages`, root commit
`db4fb67c78997d3c770677313e077b1341ee4654`. Its export-manifest SHA-256 is
`1b69f29ac7233c0bbabd05d77403309200a9cc55f655944c44bb76c44b95b912`.
The superseded history was moved recoverably to
`~/src/math-papers/.backups/clebsch-passages-6c927fab`; it was not deleted.
Local commit signing is disabled in the fresh repository.

The paper carries Zenodo preprint metadata with Tavis Rudd's ORCID, CC BY 4.0, no prematurely
assigned paper version or publication date, and an `isSupplementedBy` relation to the separately
distributed `finitegeom` concept DOI. This is consistent with `finitegeom` being software under
Apache-2.0 and with the other standalone paper records.

## Closeout: extra-juice and Tao pass

The now-tested paper-to-formal-companion pin supplies the reusable one-way dependency pattern for
C686 and C687: paper repositories consume immutable human-library and certificate-package commits,
while no Lean repository imports a paper or a generated certificate family it does not use. The
highest-value next move is therefore C686's q16 split rather than widening the Passages surface.

## Mystery ledger

- **Settled:** the apparent “Passages has no Lean” discrepancy was a statement-map error. The exact
  adjacent symbolic mechanisms are identified, and the tempting but unrelated Clebsch gates are
  explicitly excluded.
- **Settled:** the paper can cite a version-independent software concept DOI before its own DOI and
  lock a later `finitegeom` commit without conflating paper and software versions.
- **Open, release-administrative only:** the user recalled another agent's Passages Zenodo JSON,
  but no prior Passages record exists in the live source path, superseded repository, or its Git
  history. The present record matches the five established paper-record conventions; reconcile any
  later-arriving external copy before a paper push. This does not block the local v0.2.0 extraction.
- **No mathematical mystery remains in C685.** Main arithmetic and harmonic claims intentionally
  remain outside the optional Lean boundary.
