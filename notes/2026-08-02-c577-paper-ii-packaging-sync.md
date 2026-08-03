# C577 Paper II packaging and standalone synchronization

**Date:** 2026-08-02

## Result

The strengthened Paper II release surface has been packaged deterministically
from the monorepo authority and committed as an ordinary forward update in the
standalone repository.  Publication remains incomplete only because the
current environment cannot authenticate to GitHub.

## Frozen identities

- authoritative release-metadata commit:
  `8fa7ac41bfd31906891de8fa0c9c1d6bee799cb4`;
- standalone forward commit:
  `71751691b026ff99c53a64c522b0464a2c5582e0`;
- canonical export source commit:
  `8fa7ac41bfd31906891de8fa0c9c1d6bee799cb4`;
- PDF SHA-256:
  `6a98d74e795f9c3b5f75f98781bc7e17fe2a5dadda66dd32516aa3955df6fce8`;
- export-manifest SHA-256:
  `b850ad5178997fe869c40b1d84d3e538094af6acd048337ae81604a2874968ff`.

The canonical export contains 62 tracked files.  It removes the obsolete
standalone-only `FORMAL_COMPANION.json`; the formal-companion relationship is
now carried by the public DOI in the README and Zenodo metadata.  It adds the
Paper-II structural checksum manifest and synchronizes the strengthened
manuscript, PDF, trust map, statement identity, evidence fingerprint, and
aggregate verifier.

## Validation

- deterministic export coupling audit: zero findings;
- canonical candidate verification: green;
- isolated standalone `python3 verification/verify_release.py`: green,
  including all four guarded Lean gates, evidence replays, PDF build, and
  warning scan;
- post-replay canonical export verification: green;
- staged whitespace/error check: green;
- standalone worktree after commit: clean.

The isolated replay rebuilt the PDF with environment-dependent bytes.  After
the replay passed, the standalone was restored to the exact authoritative PDF
from the canonical export, and the export verifier confirmed byte identity.

## External gate

The authorized `git push origin main` failed with GitHub SSH authentication
denied.  The GitHub CLI is also unauthenticated.  No remote branch, tag,
release, archive, or DOI state was changed.  The remaining sequence is:

1. push standalone commit `71751691b026ff99c53a64c522b0464a2c5582e0` from
   an authenticated environment;
2. create the immutable public release/archive and obtain its locator;
3. insert the locator in the authoritative manuscript and README;
4. regenerate and forward-commit the canonical export;
5. rerun the isolated aggregate and final release review.

## Mystery ledger

No mathematical mystery was created by packaging.  The only unresolved item
is operational: authenticated GitHub and archive access are absent from this
environment.  The PDF byte difference after local rebuilding is explained by
environment-dependent TeX output and is controlled by restoring and verifying
the authoritative release PDF.
