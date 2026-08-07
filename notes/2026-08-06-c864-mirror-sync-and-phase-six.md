# C864 — published mirrors synchronized, and the phase 6 closing evidence

**Lane:** `build-sys`

**Date:** 2026-08-06

Ran steps 27 through 33 of the export-completion execution plan
(`2026-08-06-c864-export-completion-execution-plan.md`), after settling the open decision on the
arcs paper's order-16 pin that the plan's phase 5 report left blocking. All nine published papers
and the portfolio summary are synchronized, every mirror's release gate was replayed inside the
mirror, and every mirror verifies against its export manifest at one authority commit. Nothing was
pushed from here.

## The arcs order-16 pin, settled

The decision was whether the arcs paper advances to the published order-16 certificate package at
`0b04429b` and a current finitegeom revision, which the phase 5 report recorded as a
re-verification rather than a bump. It advances, and the re-verification found three defects that a
bump would have carried into the mirror.

The paper named package `ecee482d`, three revisions behind the `0b04429b` the registry pins. Between
them the package gained its own trust gate `RelativeConicArcs.Gates.Q16CertificateTrust`, the
order-16 sources extracted from finitegeom, the frozen generator report, and the pattern checker's
JSON certificate; nothing the manuscript describes was removed. The package's published trust fact
records all nineteen of its declarations over `propext`, `Classical.choice` and `Quot.sound` alone,
which is exactly the axiom sentence the manuscript states, so advancing the pin re-establishes that
claim at the newer revision rather than weakening it. The package pins finitegeom `a7665be6`, an
ancestor of the paper's own `575cf3e9` pin, and both documents now say so.

Three defects, each of which would have survived a mechanical pin bump:

- **The finitegeom link and its displayed short hash disagreed.** The manuscript's `\href` target
  was advanced to `575cf3e9` in phase 5 while the visible label still read `0b3f37d`, so the printed
  paper named one revision and linked another.
- **Two gate names in the evidence table were wrong.** The structural row named
  `Gates.ArcsCompleteOutsideConicHuman`, which phase 1 deleted from finitegeom as export residue,
  and the order-16 row credited the certificate package with `Gates.ArcsCompleteOutsideConic` — a
  name the shared library now publishes itself. The rows name `Gates.ArcsCompleteOutsideConic` in
  finitegeom and the package's own `Gates.Q16CertificateTrust`.
- **The README listed two files the repository no longer carries.** The order-16 generator and the
  pattern checker moved into the certificate package at this pin, and the checker's replay command
  passed a `--levels` path naming a finitegeom file that no longer exists. Both commands now run
  from a package checkout, where the level data lives.

The package carries a module named `RelativeConicArcs.Gates.ArcsCompleteOutsideConic` of its own,
which collides with the shared library's module of that name as of `575cf3e9` but not at the
`a7665be6` the package pins, so the boundary checker's collision rule is correctly green today and
will fire when that package is re-pinned forward. That re-pin is out of this pass's scope.

## Five defects the replay found, all in the release surface

Every one of these was invisible until a gate was actually run in the tree that publishes the
artifact.

**The arcs paper had no manuscript build gate.** Alone among the published papers it carried
neither the shared pinned flake nor a deterministic build checker, so nothing compared its tracked
PDF against its source and a manuscript edit could ship a PDF that was never rebuilt. It now carries
both, and the tracked PDF is a fresh build of the tracked source at twenty-six pages, warning-free.

**Two tracked PDFs did not match their sources.** The order-13 passant code and Clebsch
factorization manuscripts both failed their own gates: each tracked PDF was produced by an older TeX
than the shared pinned flake and still carried a PDF 1.5 header where the pinned toolchain writes
1.7. Both were rebuilt; the rendered text is identical in both cases, at twelve and forty-three
pages. The factorization failure reproduced in the authority and the mirror alike, which is what
identifies it as staleness rather than a mirror defect.

**The golden quantum statistics gate overwrote the artifact it was checking.** Its `check` target
built the tracked PDF in place, with TeX resolved from the mutable flake registry and no pinned
build clock, so two builds of one source never agreed and running the gate silently replaced the
published PDF. The paper now carries the shared pinned flake and the deterministic checker, `check`
compares instead of replacing, and the evidence manifest covers the new checker. The rebuilt PDF
renders identical text at sixteen pages.

**Two release verifiers could not run downstream at all.** The AME/LU and MDS--CSS verifiers read
their formal companion's file list from the development tree's extracted trust facts, which no
standalone copy carries, and they exited before reaching the paper-only branch they already had — so
the `release-check` target both Makefiles export could never pass in a mirror. Both now distinguish
an absent Lean tree from a Lean tree with facts missing. The first states how many formal artifacts
and which recorded tree hash went unchecked, the wording the order-13 passant verifier already uses;
the second stays an error, because in the development tree it is a real defect. The public profile
is unchanged and still exact, so a mirror's public tree hash must equal the authority's — and does.

## Result table

Every in-scope paper, the mirror it published to, and the gate replayed inside that mirror. All
mirrors record authority commit `8450caa9`, pin finitegeom `575cf3e9` where they pin it at all, and
verify against their export manifest. Nothing was skipped.

| Paper                          | Mirror head | Gate replayed in the mirror                                              | Result |
|--------------------------------|-------------|--------------------------------------------------------------------------|--------|
| AME/LU                         | `2118bf1`   | `make release-check`; public tree `1f1ea11f`, formal tree `9689cefd` unchecked | pass |
| Arcs complete outside a conic  | `2286b96`   | manuscript checker, 26 pages; frozen witness replay reproduced exactly    | pass   |
| Beyond-four PRS                | `8fceb76`   | `make check` and `make tit-check`, 41 of 50 single-column pages           | pass   |
| Clebsch factorization          | `4d7e4e9`   | `verification/verify_release.py`, `CHECK OK`, 43 pages                    | pass   |
| Clebsch passages               | `be84d81`   | `verification/verify_release.py`; Lean gates reported unchecked by name   | pass   |
| Clebsch rigidity (Paper I)     | `b56314b`   | `verify_release.py` against package `a80e7de6`; `status: passed`          | pass   |
| Golden quantum statistics      | `70518b1`   | `make check`, 16 pages                                                    | pass   |
| MDS--CSS transversal groups    | `4534ce0`   | `make release-check`; public tree `5c3d3248`, formal tree `fd9279ed` unchecked | pass |
| Order-13 passant code          | `1d629c5`   | `make check`, 12 pages; formal companion absent, 16 digests unchecked     | pass   |
| Portfolio summary              | `282dd60`   | none exists; tree already identical to the authority                      | pass   |

Paper I's replay is the strongest of these: its recorded release output in the mirror is
byte-identical to the authority's, including the canonical release-surface hash
`5e8e743774a851f75a13f3a674d21f4fda5417d0c4eaeaa62726c44f2a9882d3`, so the two trees agree on the
release identity rather than merely both passing.

Where a gate reports part of its surface unchecked — AME/LU, MDS--CSS, Clebsch passages and the
order-13 passant code — that part is the Lean formal companion, which no standalone paper checkout
carries. Each names what it did not check and the tree hash it would have checked against, so the
gap is stated rather than hidden.

## Closing evidence

- **Package source audit.** `lean-package-source-audit.py` against authority `0ddbca65`: 115 sealed
  sources, 114 identical to the authority and one absent from it — the package's own aggregate gate
  `ClebschRigidityWithOrderElevenCertificates.lean`, which phase 3 created there. Zero unexplained
  drift. Its owned family seals three payload files and leaves none unsealed.
- **Export audit.** `export-paper-repos.py audit` reports zero findings for all nine published
  papers, and `verify` confirms each mirror's tracked tree against its canonical export manifest.
- **Boundary and facts.** `lean-certificate-boundary.py --verify-official-libraries` and
  `lean-external-fact.py check` are green. `paper-facts.py check` names no published paper.

## What remains

- **Nothing is pushed from here.** The certificate package `finitegeom-clebsch-q11-certificates` is
  seven commits ahead of its public `main` at `20ae258d`; every paper mirror is one or two commits
  ahead of what it published mid-session. finitegeom `575cf3e9` and the order-16 package `0b04429b`
  are already public. Verify with `git ls-remote`, never a local `origin/main` ref.
- **Five paper-facts findings survive, none in the published set.** Complete repair ports and
  equivariant robust completion each cite Clebsch rigidity by a superseded title in `refs.bib` and
  carry it into a tracked `.bbl`; `papers/clebsch-series-figures/series-figures.tex` is still an
  unregistered manuscript. The first two are the plan's second pass and an unpublished paper; the
  third is a restated exclusion.
- **The "human" label should come off the trust vocabulary.** Only certificates and computations
  carry a distinguishing label; a structurally proved Lean result needs none. The arcs paper is
  clean, but roughly sixty prose occurrences remain across eight published papers, plus role strings
  inside trust manifests, statement identities and verification scripts — the order-13 passant
  verification README states five trust modes with "human structural proof" as the first. Removing
  them touches sealed identities and re-runs every affected release chain, so it wants its own task
  rather than a mid-sync edit. The related preference is to say "the Lean formalization" rather than
  "the formal development".
- **AME/LU, MDS--CSS transversal groups and beyond-four PRS still resolve TeX from the mutable
  flake registry** and have no deterministic manuscript gate. Their tracked PDFs are frozen by a
  release manifest, so a PDF that no longer matches its source hashes consistently and goes
  undetected — the failure the order-13 passant, Clebsch factorization and golden papers turned out
  to have. Arcs and golden quantum statistics were brought onto the shared pinned flake here; the
  same treatment for the other three is a small, mechanical follow-up.
- **C864 still cannot close on this plan.** Three `pending_family` entries — order-25 data, the
  order-25 generator, and the order-13 projective-cap family — are out of scope by construction, so
  acceptance item 9 remains unmet.
