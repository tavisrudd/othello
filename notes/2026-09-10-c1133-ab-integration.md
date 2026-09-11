# C1133 — A/B manuscript integration

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Scope:** user-authorized implementation of the reviewed two-part plan.

## Result and hierarchy

The primary manuscript in `papers/cubic-stabilization-m1/` now states the
unchanged unconditional cubic headline, the all-seventeen-family numerical
classification A, and the nine-family rational Hodge conservation theorem B.
Part I gives the direct cubic proof before A; Part II contains all essential
additional steps of B. C is a short very-general cubic/quartic Torelli
application. D is the geometric bounded-degree arithmetic appendix.

The direct cubic proof ends on page 13, as in the 20-page baseline. The
assembled body ends on page 21. Optional general operations, additive results,
the independent cubic check, mandatory Fano input data, arithmetic application,
and references follow. Final PDF identity/page count is recorded below after
the last replay. Length is measured without shrinking the main typography.

The general Iritani–Koto projective-bundle theorem is absent from core A–D
proof dependencies. It remains explicitly required for the broader arbitrary
threefold, arbitrary bundle, additive Grothendieck-group and higher-stabilization
statements retained in the appendices. No legacy theorem was silently dropped.

## Mathematical integration and review repairs

- The actual blowup comparison and faithful reduced-domain proof precede
  surface vanishing. The full-even-bulk ruled-product potential includes the
  elliptic zero-operator case and retains horizontal Novikov spectators.
- The specialized P1 lemma is scoped to the nine detected families. It uses
  the small full tensor connection and original lattice, independent shifts,
  and continuation in every even mixed bulk direction.
- Rank-three cyclic persistence is now explicitly proved by two trace
  equations; the old rank-two lemma was insufficient as a citation. The
  separate hostile mathematical reviewer independently derived the equations.
- A uses full odd dimension O3, without an unnecessary division by two, on
  even-rank-three factors. Rank-one Frobenius vanishing and the nef-surface
  b2=1 exception are proved explicitly before fourfold invariance.
- B uses one common rational reductive Hodge group, a fixed parameter base
  with full fiber, directly proved injection, unlabelled selected odd sum,
  representation cancellation, pure weight three and rational Hom descent.
  The result includes neither integral lattices nor principal polarizations.
- C keeps a very-general source and arbitrary smooth same-degree target.
  D uses corrected Orr v4, finite kernels, finite polarizations and cubic
  Torelli, counting only geometric classes and claiming no effectiveness.

The assembled specialist and adjacent-reader reports recommend acceptance
after minor revision within their stated scopes:
`2026-09-10-c1133-assembled-specialist-referee.md` and
`2026-09-10-c1133-assembled-adjacent-referee.md`.
The additional frozen-proof hostile report is
`2026-09-10-c1133-integration-mathematical-referee.md`.
All concrete minor requests were implemented: abstract rank-three branch,
backward center reference, explicit mandatory role of the Fano appendix,
source reconstruction citation, P1 family pointer, and the distinction from
higher-rank logarithmic lattice theory. The cubic-first title is retained as
the author-approved positioning choice.

Both assembled readers preferred the integrated paper in an explicitly
**nonblind** comparison. This is not the style guide's fully blinded
before/after publication experiment. The adjacent reader reports accessibility
4/5 and birational/Hodge confidence 4/5, while explicitly not independently
verifying the external quantum sources. The specialist selectively checked
primary comparison, reconstruction, Torelli and isogeny passages; exact
hashes/read scopes are in that report. Neither review certifies novelty or
reproves every imported geometric theorem.

## Evidence and formal boundary

The public bundle `verification/fano-matrices/` contains exact inputs,
two independent checkers, source-normalization checker, JSON certificates,
README, byte-count manifest and SHA256SUMS. No internal task IDs or cache paths
are required by that artifact. Replay from the paper root:

```
uv run --with sympy==1.14.0 python verification/fano-matrices/finite_checks.py --check
python3 verification/fano-matrices/independent_checks.py --check
uv run --with sympy==1.14.0 python verification/fano-matrices/source_check.py --source-dir SOURCE_DIR
sha256sum --quiet -c verification/fano-matrices/SHA256SUMS
make check
```

SOURCE_DIR contains the two hash-pinned scripts from DOI
10.5281/zenodo.20625923. The source comparison was replayed against the shared
cache intake. All seventeen characteristic polynomials/cyclic frames and nine
rank-two residues agree independently; fifteen source matrices and their
period inputs agree entrywise after the explicit normalization. Only nine
matrices are mandatory for A/B. No checker establishes GW identification,
deformation invariance, classification, actual transport or Hodge descent.
No random seeds, approximate arithmetic, or novel search domain are involved.
The optional rank-three jet checks remain outside the theorem premises.

`make check` now includes read-only finite replay and certificate checksums.
The source-only formal gate has 79 claims: 25 absent, 27 fragments,
26 conditional deductions, one complete; 371 reviewer terminals, including
133 machinery terminals. The twelve added geometric statements have absent
coverage. Existing terminal names/signatures and expected axiom list are
unchanged. The unused bundle premise was removed from `thm:marker-ledger`
after checking its existing terminal row; no bundle premise appears in its
formal hypothesis description. The headline's formal caution now names the
specialized product proof instead of implying a core IK dependency.
No Lean build or new kernel/axiom replay is claimed.

The baseline PDF is frozen as `2026-09-10-c1133-integration-before.pdf` with
adjacent SHA256; it has 20 pages, hash
`6ee4f570d5954262dff595b260900d2dda058a1560e9921f122c433647928ffe`.
All assembled pages were inspected in rendered contact sheets, with critical
front matter, theorem table, Hodge descent and data pages additionally
available at reading resolution. Final changed-page inspection is recorded
with the final PDF identity below.

## Source scope and process corrections

The register remains 91 entries, nine external full reads. The specialist's
additional partial read of the Naive Atoms Section 9 reconstruction explanation
is added to its read scope; no full-read count was inflated. The earlier
bounded-triangulation and no-exhaustive-priority boundaries remain unchanged.

Command-shaping failures: the live handoff cat exceeded the producer cap and
was replaced by bounded chunks; an earlier combined routed-guide read also
truncated output and the Lean guide was subsequently read completely. One
bibliography-fix command used the wrong working-directory-relative path; it
was corrected to an absolute path. Two resulting underfull bibliography
warnings were fixed by scoped ragged-right bibliography formatting. No build
failure was treated as validation and no foreign tree was changed.

## EJ + TT and Mystery ledger

The post-gate pass removed the unused general bundle premise from the
abstract birational criterion: its proof uses only blowup corrections and
center vanishing. It also exposed and repaired the stale public reviewer
guide, keeping the actual full-fiber and imported-data boundaries visible.
These are cheap task-owned upgrades and do not enlarge the theorem scopes.

- **Settled:** rank-three persistence is an explicit proof, not a rank-two
  citation stretched to cover it.
- **Settled:** the eight rational-control matrices are checks, not premises;
  odd dimension is recorded without a half-integrality convention.
- **Settled:** the retained higher-rank lattice warning does not qualify A.
- **Settled:** every core and optional branch keeps its actual bundle input.
- **Open publication gate:** a fully blinded before/after preference test has
  not been performed; the two current preferences are explicitly nonblind.
- **Open C1133 scope:** the broader literature/priority audit retains the
  recorded coverage limits; this integration does not close C1133, C978 or
  C956 or authorize publication.

No new mathematical mystery remains in the implemented A/B integration.

## Final manuscript gate

Authority `make check` passes, including the exact matrix and source-only formal
gates, and no TeX warnings. The PDF has 32 pages (245381 bytes),
SHA-256 `25091940fb49b2857b8b9c509ed4826724bd6f8a91732b99c0c7882223e346c0`. The main body occupies pages 1–21;
B occupies pages 17–21 including its transition and short Torelli application.
The appendices begin on page 21 and references finish on page 32.
Final affected front matter and all appendix/reference pages were visually
rechecked after the last reflow; no clipped text or broken table was found.
