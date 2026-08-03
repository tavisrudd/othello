# C853 Golden quantum-statistics Lean remediation

**Lane:** `golden`

**Status:** in progress; export prerequisite closed, matrix-level vocabulary and
the balanced exchange benchmark landed

## Scope decision

The user requires every mathematical statement of the manuscript
*Orientation, exchange statistics, and rigidity in the Golden six-mode
conference interferometer* to be formalized to the repository's Lean standards,
using Mathlib wherever the library already has the object.  The formal artifact
therefore grows from four scalar ring identities to a theorem-level companion
covering the paper's eight labelled results, with an explicit trust route for
everything that stays outside Lean.

## Export prerequisite

The blocking guarded exporter is now `lean/scripts/lean-companion-export.py`,
covered by `lean/scripts/test_lean_companion_export.py` and configured for this
paper by `lean/trust/export/golden_quantum_statistics.toml`.  It derives a
gate's project-local closure, terminal list, and observed axioms from the
committed trust registry and generated fact, materializes a disposable
candidate on the canonical Lean base twice, requires byte-identical repeats,
verifies byte identity, manifests, terminals, base cleanliness, and prints a
read-only forward delta without committing, tagging, pushing, or editing either
repository.  Details and the seven-point contract check are in the export
preparation record.

## Landed formal content

`RelativeConicArcs.ConferenceExchangeSpectrum` is the new matrix-level module.
Over a commutative ring it proves that a two-block splitting of a matrix
satisfying `C * C = q • 1` forces `A * A + S * Sᵀ = q • 1`, hence the cross Gram
identity `S * Sᵀ = q • 1 - A * A`, and that a signed triangle block with unit
off-diagonal entries satisfies `A * A = 2 • 1 + (a * b * c) • A`.

Over the reals it defines the normalized exchange operator
`normalizedExchange q S = q⁻¹ • (S * Sᵀ)` and proves, for every three-element
cut of every order-six symmetric conference matrix and every choice of the three
edge signs:

- `Matrix.charpoly (normalizedExchange 5 S) = (X - C (1/5)) * (X - C (4/5)) ^ 2`;
- the multiset of characteristic roots is `{1/5, 4/5, 4/5}`;
- `spectrum ℝ (normalizedExchange 5 S) = {1/5, 4/5}`;
- trace `9/5`, squared trace `33/25`, determinant `16/125`; and
- the degree-three sectors `313/125`, `8/5`, `16/125` with the Schur–Weyl
  checksum `729/125`.

Elementary symmetric functions use `Multiset.esymm`; power sums are a thin
definition over a multiset.  The library has no Schur-polynomial API, so the
third complete homogeneous symmetric function and the Schur function of the
partition `(2,1)` are defined by their monomial expansions in three variables
and connected to `Multiset.esymm` by proved identities.

This is the manuscript's balanced exchange benchmark at the cross-Gram level,
proved uniformly in the edge signs rather than by a census of the twenty
balanced controls.

## Eigenframe compression bridge

The manuscript's exchange operator is `H = K*K` for the compression
`K_C(x) = Q₋* D_x Q₊` between orthonormal eigenframes of `C`.
`RelativeConicArcs.ConferenceExchangeCompression` carries the matrix half of
that bridge.  For an involution `Q` with eigenprojections `(1 ± Q)/2` and a
frame `Qp` characterized by `Qpᵀ * Qp = 1` and `Qp * Qpᵀ = (1 + Q)/2`, it
proves:

- the commutator of the cut sign involution with a block matrix is
  `fromBlocks 0 (2 • R) (-(2 • Rᵀ)) 0`, and its square is block diagonal with
  `-(4 • (R * Rᵀ))` and `-(4 • (Rᵀ * R))` on the diagonal;
- `Kᵀ * K` is the compression `Qpᵀ * (D * ((1 - Q)/2) * D) * Qp`;
- the commutator acts on a positive eigenframe as twice the complementary
  projection of the controlled frame; and
- `4 • (Kᵀ * K) = Qpᵀ * (Lᵀ * L) * Qp` for that commutator `L`.

What remains for the bridge is the spectral half: the compressions of
`Lᵀ * L` to the two eigenspaces have equal characteristic polynomials, because
the commutator intertwines them; their product is the characteristic polynomial
of the block-diagonal `Lᵀ * L`, which is the square of that of the normalized
cross Gram matrix; and two monic real polynomials with equal squares are equal.
Until that lands, the exchange results reach the manuscript's operator only
through the equality of spectra the paper proves separately, which the module
headers state as an explicit trust boundary.

Still unformalized: the all-orders exchange rigidity theorem with its aligned
four-set purity formula and inclusion/Ramsey converse; the continuous-control
optimum and its equality set; the Hermitian exchange landscape, Pareto
frontier, squared-spectrum rigidity, and stability bounds; the balance
obstruction; and the orbit and orientation layer.  Decoding schedules,
tomography, optical compilation, and every experimental threshold stay outside
Lean by design and must be recorded with their own trust routes rather than
counted as missing formal proof.

## Validation state

Every landed declaration elaborates through the guarded single-file entry point,
and the import-only gate `RelativeConicArcs.Gates.GoldenQuantumStatistics`
builds through the guarded queue with its trace-only aggregate gate passing in
the shared tree.  The trust registry now advertises the eight matrix-level
terminals alongside the four legacy scalar identities.

The gate also builds in a clean disposable worktree at the exact source commit,
and the generated fact was regenerated there because the shared tree carries
foreign uncommitted Lean edits and extraction correctly refuses in that state.
The fact records a three-module closure, no project axiom, and no opaque
declaration.  The eight matrix-level terminals observe exactly
`Classical.choice`, `Quot.sound`, and `propext`; the four legacy scalar
identities observe exactly `propext`.  The area-wide audit reports no finding
against this unit; its remaining errors are the unrelated relconic baseline.

The guarded companion exporter then produces a verified, deterministic
eleven-file candidate carrying all twelve terminals, taking the canonical
library state from 273 to 276 modules, without mutating the canonical base.
