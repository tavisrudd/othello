# Paper III verification scaffold

`trust_manifest.json` is the live claim ledger.  It records claim status,
proof modes, task ownership, and admitted evidence paths before those claims
enter the final theorem.

Run from the repository root:

```text
python3 papers/clebsch-passages/verification/verify_scaffold.py
```

The checker verifies:

- the section files named by the manuscript exist exactly once;
- every `\claimid{...}` used in the manuscript occurs in the ledger;
- claim identifiers and owners are unique and well formed;
- evidence paths recorded for certified claims exist; and
- `release_ready` is false while a claim is gated or conditional.

This is a planning-time guard, not a release certificate.  The final surface
will also freeze theorem statement identity, evidence hashes, exact replay
commands, toolchains, manuscript warnings, and archival metadata.
