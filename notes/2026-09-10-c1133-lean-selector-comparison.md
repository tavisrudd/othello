# C1133 — full odd selector and composed coefficient comparison

**Lane:** `cubic-threefolds`

## Mathematical change and boundary

The exact-primary Lean selector now records full odd dimension. Its four
rank-three endpoint values are 104, 60, 40, 28, matching the manuscript and
Python certificate. No manuscript statement or matrix changes.

The full normalization removes the parity premise from
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimplePrimaryBlock.dimensionCompatible`.
The existing multiplicity bound alone proves nullity. The proof is in
`Quantum/SemisimplePrimaryLedger.lean`, theorem
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimplePrimaryBlock.weight_zero_of_numeric_zero`.

New module `Quantum/FaithfulCenterLatticeComparison.lean` proves the composite
coefficient injection, actual lattice membership preservation and reflection,
and exact modified-residue discriminant transport. Public terminals in
`PaperInterface/Main.lean` are:

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.gradedCenterComparison_faithful_lattice_and_residue`
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankThreeEndpoints_fullOddDimensions`

The common-field target embedding is explicitly faithful; source injection
is derived using the separating divisor pairing. Literal connection realization,
paired adapted connections, and a regular horizontal comparison and inverse
are supplied. Neither the actual geometric blowup comparison nor its Hodge-fixed
restriction is constructed. This does not promote the manuscript claim map.
The lattice theorem proves an iff by showing the constant lower-right
comparison entry is nonzero using the regular inverse. Discriminant transport
uses the existing horizontal-pairing theorem and does not impose nonresonance.

## Validation

Guarded full library build passes: run
`/home/tavis/.cache/othello-lean-build/run-20260911-060039-42b5c759`.
Fresh guarded AxiomAudit elaboration and exact expected/observed comparison
pass for all 373 terminals. Only `propext`, `Classical.choice`, and `Quot.sound`
occur; the 371 existing terminal dependency lists are unchanged.
Audit stdout is
`/home/tavis/.cache/othello-lean-build/guarded-lean/20260910-230132-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma/stdout.log`.
The source snapshot covers 246 Lean files and checks all 17 matrix input rows.
Primary manuscript coverage remains 20 absent, 8 fragments, 8 conditional
out of 36 claims. All-manuscript coverage remains 79 claims with no promotion.
The added two terminals are machinery, bringing that count to 135.

All touched modules were reviewed in full for mathematical scope, explicit
premises, documentation and scholarly artifact hygiene. No project axiom,
`sorry`, native decision or kernel-bypass construct was found by the bounded
source scan; the transitive public axiom result is the stronger dependency check.
The full semantic review of the prior trust pass remains the baseline; this
pass reviews the changed modules and their composition, not a second independent
specialist review of every geometric premise.

Replay the adjacent script after a fresh guarded AxiomAudit elaboration:

```
python3 notes/2026-09-10-c1133-lean-selector-comparison.py --axiom-log AUDIT_STDOUT --check
```

It reuses the committed trust-snapshot implementation, records its hash,
and pins all project Lean source hashes and verification inputs. Kernel reduction
checks the four numerical endpoints; the snapshot separately checks all 17
literal matrix rows against the Python inputs. The snapshot is bookkeeping,
not an independent proof of geometric realization.

## EJ + TT closeout and Mystery ledger

After the kernel acceptance gate, the cheap input-reduction pass confirms:
full odd dimension removes the parity premise rather than merely rescaling
four displayed numbers. The comparison also reflects lattice membership,
which prevents a one-way preservation assertion from being mistaken for an
identification. Both upgrades are implemented and kernel checked.

- **Settled:** factor-of-two mismatch; the explicit four-value terminal checks
  the exact printed normalization, and the Python table agrees.
- **Settled:** parity needed for nullity; the full dimension bound alone suffices.
- **Settled on the formal domain:** loss of lattice membership under transport;
  the regular inverse forces the required constant coefficient to be nonzero.
- **Open evidence gap:** actual geometric coefficient-field embedding and regular
  connection realization, including the Hodge-fixed base. These are visible
  inputs, not consequences of the finite calculation. C1133 owns matching each
  input to the written comparison proof and the cited source hypotheses.

No additional numerical mystery was found. There is no claim that the abstract
common-field embedding proves its own geometric existence.

## Paper gate

Authority `make check` passes: source correspondence, universal residue, both
finite implementations, reconstruction, hashes, TeX and warning rejection.
No TeX or PDF content changed. The existing built PDF remains 32 pages with
SHA-256 `33d39d37048a7c99c2d01c1b8ee14d8265a604bb9a50fc969219e79ba2e18472`.
No incidental discovery was promoted or added during this bounded alignment.
