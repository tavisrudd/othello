# C901 Paper IV cold-read round 1 manifest

**Lane:** `clebsch`  
**Date:** 2026-08-09  
**Status:** sealed before reviewer launch

## Frozen surface

- manuscript source:
  `papers/q13-passant-code/passant_code_q13.tex`;
- source SHA-256:
  `12e19dd0c2f4a83e25f2a023ebd23b35bdb8415649cbac993853a0488a2ec033`;
- rendered review PDF:
  `papers/q13-passant-code/passant_code_q13.pdf`;
- PDF SHA-256:
  `715fdb6500c34386f92f61ba6fd328da8fd95a60e657c644e9e5a097e0b73fce`;
- manuscript source authority commit:
  `ff5d4690b4c12ef9a03b9dc75967b462d169d1eb`;
- dossier commit: `8e5e5407`.

Both files were clean and their hashes rechecked immediately before this
manifest was written. A report on any other bytes is outside round 1.

## Independent assignments

Each reader receives the frozen PDF, one bounded dossier extract, the sources
named in that extract, and the common neutral protocol. No reader receives the
Clebsch handoff, C761/C831/C832/C834/C857, prior Paper IV reviews, internal
evidence, another persona packet, or another round-1 report.

| persona | dossier lines | report |
|---|---|---|
| Wu | `327--358`, `486--501`, `551--578` | `notes/2026-08-09-c901-paper-iv-wu-cold-read.md` |
| Xiang | `359--385`, `502--513`, `551--578` | `notes/2026-08-09-c901-paper-iv-xiang-cold-read.md` |
| Ball | `386--404`, `514--524`, `551--578` | `notes/2026-08-09-c901-paper-iv-ball-cold-read.md` |
| Tranchida | `433--462`, `525--535`, `551--578` | `notes/2026-08-09-c901-paper-iv-tranchida-cold-read.md` |

The line ranges refer to
`notes/2026-08-09-clebsch-paper-iv-reviewer-dossier.md` at dossier commit
`8e5e5407`. Readers must not open other ranges of that file.

## Freeze and synthesis rule

Reports are written to their assigned paths and committed only after all four
have returned. No report may be revised in response to another before that
four-report freeze. Synthesis begins only after the freeze commit and compares
the earliest unsupported implication before comparing categorical verdicts.

Round 1 concerns human proof, citations, mathematical conventions, finite-step
exposition, and readability. It does not review Lean, source trust, release
engineering, or implementation correctness.

