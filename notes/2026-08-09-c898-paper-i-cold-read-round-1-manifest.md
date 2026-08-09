# C898 — Paper I cold-read round 1 manifest

**Date:** 2026-08-09  
**Status:** all reports frozen; synthesis complete; remediation authorized  
**Owning task:** C898

## Frozen surface

- manuscript commit:
  `6e011ff585f46658a2650803d8672f07a48e786a`;
- PDF: `papers/clebsch-rigidity/clebsch_rigidity.pdf`;
- PDF SHA-256:
  `95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`;
- sealed reviewer dossier:
  `notes/2026-08-09-clebsch-paper-i-reviewer-dossier.md` at commit
  `d4e11cff`.

Every reviewer must record the PDF hash above. A report on any other manuscript
surface is not part of this round.

## Isolation protocol

- Each reviewer starts in a fresh context and reads only the frozen PDF, their
  assigned dossier packet, and that packet's public/cached sources.
- Reviewers must not read task cards, handoffs, internal theorem-completeness or
  release audits, prior reviews, remediation notes, or another round-1 report.
- The PDF is read before the optional public supplement. The report records the
  initial human-proof findings before a supplement postscript says what the
  allowed public artifacts do or do not resolve.
- Reports use only categorical verdicts (`GO`, `MINOR`, `MAJOR`) and at most five
  controlling findings. No numerical grade is persisted.
- All five reports are frozen before the coordinator performs cross-comparison.

## Assigned reads

1. Packet S — finite-geometry persona (Storme/Szőnyi packet):
   `notes/2026-08-09-c898-paper-i-cold-read-r1-finite-geometry.md`.
2. Packet K — coding persona (Kaipa/Pambianco packet):
   `notes/2026-08-09-c898-paper-i-cold-read-r1-coding.md`.
3. Packet H — orientation persona (Haemers/Gillespie packet):
   `notes/2026-08-09-c898-paper-i-cold-read-r1-orientation.md`.
4. Packet C — cubic-geometry persona (Zhang/Hassett packet):
   `notes/2026-08-09-c898-paper-i-cold-read-r1-cubic.md`.
5. Packet E — editorial/significance persona (Ball packet):
   `notes/2026-08-09-c898-paper-i-cold-read-r1-editorial.md`.

The synthesis path is
`notes/2026-08-09-c898-paper-i-cold-read-round-1-synthesis.md` and must not be
created until all five reports are frozen. All five reports were frozen before
that synthesis was created; the round verdict is `MAJOR`.
