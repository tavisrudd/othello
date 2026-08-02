# Verification map

The initial manuscript imports frozen results from these atomic bundles:

- `notes/2026-08-01-c718-golden-boson-fermion-complement.*` for the permanent
  obstruction, symmetric/exterior-cube values, and balanced census;
- `notes/2026-08-01-c719-golden-six-mode-demonstrator.*` for the exact mesh,
  thresholds, shot budgets, and simplex schedules;
- `notes/2026-07-31-c715-golden-anomaly-inverse.*` for the rational filter,
  amplitude normalization, and exact success costs.

The paper-local checker verifies the three source manifests, reads their
canonical certificates, and independently recomputes the displayed rational
identities and finite decoder checks using only the Python standard library.
Run from the repository root:

    python3 papers/golden-quantum-statistics/verification/check_imports.py --check

or run the complete paper gate:

    make -C papers/golden-quantum-statistics check

The paper-local `uv.lock` pins SymPy for the C718 symbolic generator. To
regenerate all three imported atomic certificates and run their independent
replays in that environment, use:

    make -C papers/golden-quantum-statistics verify-sources

The generated `c767-import-certificate.json` records the imported values,
source hashes, and trust classification. `SHA256SUMS` covers the paper-local
checker and certificate. Regenerate only after an intentional source-bundle
change:

    python3 papers/golden-quantum-statistics/verification/check_imports.py --write

The source generators and their independent replays remain authoritative for
the internal algebra of each atomic bundle. The C767 checker verifies their
hashes and the claims used by this paper; it does not reimplement their full
symbolic derivations. C768 owns the full-text literature record and
citation-depth ledger. No priority claim is licensed by this evidence surface.
