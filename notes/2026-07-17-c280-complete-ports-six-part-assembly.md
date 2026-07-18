# C280 complete-ports six-part manuscript assembly

**Lane:** `complete-ports`

**Status:** COMPLETE — the private paper is an 11-page theorem-led manuscript in the frozen
six-part order. The source, bibliography, proof ledger, novelty boundary, README, registries, and
PDF are synchronized. No public export, repository initialization, Lean edit, or push occurred.

## Result

The manuscript now proceeds through:

1. complete bounded ports and support/coefficient/probability layers;
2. exact weighted-functional transfer and pointed confinement;
3. prescribed positive-density realization;
4. reliability, cheapest-radius transforms, and radius-truncated BEC EXIT;
5. the standard pointed-Tutte/perspective identification and radius-filtration boundary; and
6. cubic--axis versus quartic--nucleus/harmonic flagships.

The old seed-first derivation was replaced by a short integrated source. C216, C219, C226, C227,
C218, C243, and C244 now have explicit theorem/evidence boundaries in the proof and novelty
ledgers. Reliability, EXIT, Chen--Stein, normal-rational-curve nuclei, harmonic Steiner systems,
and the Las Vergnas polynomial are labeled classical; the exact port applications retain cautious
none-found positioning. C220 is deliberately omitted pending its separate inclusion decision.

## Build and hashes

From `papers/complete-repair-ports/`:

```text
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

The build completed with no warnings. The PDF has 11 pages. Load-bearing private artifacts are:

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `complete_repair_ports.tex` | 26712 | `cc5c3e6c18ff1e1050e7438404ba47ed492b1fbe2e33269470b623f2b4116f1f` |
| `complete_repair_ports.pdf` | 115966 | `3ba73cbd6b6ef379a3fe5243f79d3207786cc36d02fcbbca12cf7345b84d1104` |
| `refs.bib` | 8975 | `206718d4740cc34821ff3d57128aad4b54a85a646b560c18cecee5c69eeb1792` |

The first and final PDF pages were rendered and visually inspected. Citation metadata for the new
Las Vergnas, EXIT, Chen--Stein, nucleus, and local-code-capacity references was checked against the
shared literature cache and primary/official records.

## Exact evidence replay

From the repository root, each cited deterministic bundle was regenerated into a temporary
directory and compared byte-for-byte with its tracked JSON:

```text
c280_replay_dir=$(mktemp -d)
python3 notes/2026-07-16-c218-quartic-nucleus-verifier.py --output "$c280_replay_dir/c218.json"
cmp "$c280_replay_dir/c218.json" notes/2026-07-16-c218-quartic-nucleus-verifier.json
python3 notes/2026-07-16-c219-repair-reliability.py --output "$c280_replay_dir/c219.json"
cmp "$c280_replay_dir/c219.json" notes/2026-07-16-c219-repair-reliability.json
python3 notes/2026-07-16-c226-repair-port-exit-transforms.py --output "$c280_replay_dir/c226.json"
cmp "$c280_replay_dir/c226.json" notes/2026-07-16-c226-repair-port-exit-transforms.json
python3 notes/2026-07-16-c227-pointed-tutte-repair-polynomial.py --output "$c280_replay_dir/c227.json"
cmp "$c280_replay_dir/c227.json" notes/2026-07-16-c227-pointed-tutte-repair-polynomial.json
python3 notes/2026-07-17-c243-nucleus-gated-separation-vet.py --output "$c280_replay_dir/c243.json"
cmp "$c280_replay_dir/c243.json" notes/2026-07-17-c243-nucleus-gated-separation-vet.json
python3 notes/2026-07-17-c244-exact-consequence-pack.py --output "$c280_replay_dir/c244.json"
cmp "$c280_replay_dir/c244.json" notes/2026-07-17-c244-exact-consequence-pack.json
rm -r "$c280_replay_dir"
```

All six comparisons were exact. These replays certify the finite q9/q27 tables and algebraic
checks recorded by their reports. They do not formalize the manuscript's trace/random/AG,
all-field Poisson, or symbolic harmonic proofs, and they do not imply an asymptotic harmonic
closure threshold.

## Remaining gates

Submission preflight still requires the dedicated specialist citation-chain audit, a C220
inclusion decision, and final public proof/evidence rewrites. Public export additionally remains
blocked on the approved repository destination/remote and license, plus the separately owned
shared-Lean export.
