# C572 AME--LU release candidate

Date: 2026-07-24

## Verdict

The paper is a reproducible local release candidate. No upload, public
identifier, license grant, account change, or journal submission was made.
Those actions remain author gates.

The release fixes two separately verifiable trees:

```text
public tree:
640a51ff2d4154b948b9e0b10ed8f12f45ec0bc600027877f650ffc7cb790b40

formal companion tree:
91c8ba3c885a65e71adb0cf5cf3491086c3f810cec11673435112852983399de
```

The public tree contains 35 manuscript, release, and evidence artifacts. The
formal tree contains the pinned Lean toolchain, nine AME modules, the aggregate
gate, and its axiom-audit terminal.

## Clean source and evidence replay

A clean tree was created from the tracked paper source rather than from the
working directory. In that tree:

```text
python3 supplement/verify.py --replay
```

verified all 15 evidence artifacts and replayed all seven evidence bundles.
The paper-only public export was then extracted independently and replayed
through the same command.

The arXiv-profile source archive contains only `main.tex`, `refs.bib`, and the
eight included section sources. A clean XeLaTeX/BibTeX build from that archive
passed with 15 pages and no manuscript warning.

The convenience `make release-check` wrapper was externally terminated with
signal 143 during its long replay and left no diagnostic log. Its three
constituent gates were therefore assessed from their separate completed runs:
the warning-free clean build, two complete seven-bundle replays, and the final
paper-plus-formal manifest verification all passed.

## Reproducible PDF

The ordinary warning gate initially exposed a release-only defect: two clean
builds from identical source produced different PDF hashes because XeLaTeX
embedded build-time metadata. The Makefile now fixes
`SOURCE_DATE_EPOCH=1784851200`, `FORCE_SOURCE_DATE=1`, and `TZ=UTC`.

Two independent clean builds are byte-identical:

```text
pages: 15
bytes: 156688
SHA-256: a8ce4867d3999a6bba4c8f5590a6e11de046d7100ecf318e1450f99ed683b3b1
```

The title and final bibliography pages of this exact PDF were rendered and
inspected.

## Deterministic exports

`papers/ame_lu/release/verify_release.py` verifies the manifest, refuses to
overwrite an export, normalizes archive ownership and timestamps, and provides
two profiles.

```text
public scholarly bundle
bytes: 275082
SHA-256: bb3da1321ecaa6259437dc4ee7ae45705af9aa7d9f8584bd9b495f7ee1df8df9

arXiv source bundle
bytes: 19140
SHA-256: 0ec996cb3530856f9841b4d12beb2ded7e6e6b9a90f7b190032eeb9c88d35cfe
```

Two separately generated public bundles had identical hashes. The extracted
paper-only verifier checks every bundled byte and reports explicitly that the
formal companion is recorded rather than duplicated. In the monorepo,
`--require-formal` checks both trees.

## Target-policy check

Quantum is the natural first journal target, subject to the author's venue
choice. Its author instructions were checked on 2026-07-24:

- initial submission is an arXiv identifier posted to or cross-listed with
  `quant-ph`;
- the present 15-page format is permitted because Quantum has no initial
  typesetting or length constraint;
- the main theorem and hypotheses already appear on the first page;
- an author-contribution statement is mandatory;
- the scope of language-model use must be disclosed in that statement; and
- submission certifies author/rightsholder permission, originality, and no
  simultaneous journal consideration.

The arXiv instructions were also checked on 2026-07-24. They prefer TeX source,
require a registered author to self-submit, require a distribution license and
submittal agreement, reject unnecessary build output alongside TeX source, and
require inspection of the platform-generated PDF. The paper's fixed date avoids
the discouraged `\today` behavior. The local source bundle builds under
XeLaTeX; the submitter must select that processor and `main.tex`.

The abstract is one paragraph and approximately 150 words. The intended arXiv
primary category is `quant-ph`, with `cs.IT` a plausible cross-list; the author
must confirm both.

## Author and account gates

Publication remains blocked until the author confirms:

1. author name and order;
2. affiliation, corresponding email, and ORCID;
3. funding, acknowledgments, and the exact contribution/AI-disclosure text;
4. copyright and supplement-distribution authority;
5. the arXiv license and category/cross-list;
6. absence of simultaneous journal consideration;
7. the archival repository or DOI used in the manuscript;
8. Quantum editor/referee suggestions and Scholastica account readiness; and
9. explicit authorization for each external upload or submission.

`release/QUANTUM-CHECKLIST.md` records these as unchecked gates. Placeholder
metadata was not inserted into the manuscript.

## `ej` + `tt` closeout

The cheap release-owned upgrade was to make the PDF and both archives
reproducible, not merely hash the first successful build. The resulting
content identities separate three notions that must not be conflated:
mathematical source, a publicly distributable byte sequence, and an
author-authorized publication. The first two are now fixed; the third cannot
be created by a technical gate.

No task-owned mystery remains. The unresolved publication fields have an
explicit author gate, and the unresolved extension-field geometry has an
explicit optional successor.

## Mystery ledger

- **Settled by the release pass:** PDF nondeterminism was metadata-only and is
  eliminated by a fixed source epoch; clean source now reproduces the tracked
  PDF byte for byte.
- **Settled by the export pass:** a paper-only archive can verify its own
  contents while retaining an immutable identity for the nonduplicated formal
  companion.
- **Open, author-owned:** the archival identifier, license, author metadata,
  disclosure wording, and submission target cannot be inferred from repository
  state.
- **Open, optional mathematical successor:** extension-field rigidity still
  depends on whether shortened marginal planes recover the Desarguesian
  `F_q`-spread inside additive `F_p` phase space. This is owned by C581, not by
  the release candidate.
