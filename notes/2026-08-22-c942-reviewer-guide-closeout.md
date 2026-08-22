# C942 reviewer-guide closeout

## Result

The primary one-stabilization paper now has a linked referee guide at
`papers/cubic-stabilization-m1/REVIEWER_GUIDE.md`.  It gives a first-pass route,
six label-addressed checks through the proof, and a claim-by-claim account of
the written, imported, computational, and Lean boundaries.  The guide calls
the formal artifact a repository Lean 4 companion built against Mathlib and
expressly says that it is not part of Mathlib.

The existing `\lean` and `\uses` markup now also has a separate, pinned
LeanBlueprint renderer.  `nix run .#blueprint-web` produces one annotated web
view and its dependency graph under `blueprint/web/`.  Generated files are
ignored.  The existing default/manuscript shell and `make check` entry point
were not replaced.

## Review disposition

The guide went through mathematical, formal/reproducibility, hostile, prose,
and final release cold reads.  The adopted repairs were:

- distinguish the primary proof from both optional companions and the
  conditional all-stabilization manuscript;
- state the marker theorem's operation and invariance hypotheses rather than
  saying it applies to any additive marker;
- use the exact claim-map word `fragment` and identify the census as the 15
  primary-paper labels;
- describe `expected_axioms.txt` as an expected axiom list, not a fresh kernel
  transcript;
- replace self-certifying opening language by a direct location statement;
- describe the Blueprint output as an annotated web view and dependency graph,
  without promising a bundled declaration browser or separate theorem pages.

The final mathematical/release reader returned PASS at confidence 0.96 with
no fatal or major finding.  The Blueprint release reader returned PASS after
the last wording repair.  The hostile audit found no open theorem-scope or
trust-boundary error.

The formal cold read found one independent defect in the conditional framed
companion: `verification/hirzebruch-euler-spectrum.sha256` contains a stale
hash for its script.  That evidence does not support `thm:every-cubic` and the
companions do not enter the proof route in this guide.  C942 therefore leaves
the C940-owned evidence bundle unchanged and records the defect rather than
silently broadening scope.

## Release evidence

- `make check`: PASS in the authority and in the standalone mirror.
- `nix run .#blueprint-web`: PASS repeatedly in the authority, including an
  idempotence comparison, and PASS in the standalone mirror.
- Export audit: zero findings.
- Export verification: 259 tracked files at authority commit `6663d9020`.
- Authority and mirror PDFs are byte-identical, SHA-256
  `246d254f7275111ba33b5b73ad344d31a89b749b28e37d76b306b919349b708a`.
- Standalone mirror commits: `4d55d23` and `b5d99f1`; no push, tag, deposit, or
  submission was made.

The initial sync exposed that the new paper-local `.gitignore` omitted the
standalone repository's established TeX/Python build patterns.  The authority
was repaired before the final export.  Pre-existing mirror build byproducts
were moved, not deleted, to `/tmp/c942-mirror-artifacts.qMA7oN` during that
repair.

## EJ + TT closeout

**EJ:** accept.  The guide earns confidence through stable labels, exact
failure modes, and unfavorable coverage disclosures.  It does not advertise
its own care or repeat the paper's prose.

**TT:** accept for the unconditional primary release surface.  The ordinary
paper gate, export verifier, reproducible web renderer, and PDF identity check
all pass.  The stale conditional-companion checksum remains a named,
out-of-scope defect rather than hidden release evidence.

## Mystery ledger

No unexplained guide claim, proof dependency, generated output, or PDF change
remains.  The conditional-companion checksum mismatch is explained and owned;
it is not a mystery and is not used by the primary theorem.
