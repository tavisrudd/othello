# C926 — Paper V mod-11 completeness certificate for the conference node count

**Lane:** `clebsch`
**Paper stream:** Paper V (`papers/chordal-conference-reconstruction/`)
**State:** complete. The certificate, its checker, the independent computer-algebra
replay, and the dated report are committed and wired into `make evidence`. The
manuscript was deliberately not edited (user instruction during the session), so
the paper still says "isolated nodes" rather than "exactly six"; the exact
wording to use if that is wanted is drafted in the report.

## Scope

Certify, over \(\F_{11}\), that the singular scheme of the \(A_5\)-invariant
conference triangle cubic \(c_B\) on \(\PP(A_0)=\PP^4\) is exactly six reduced
ordinary nodes, so that the count survives base change to
\(\overline{\F}_{11}\). Commit the bundle under the reproducibility conventions
and add it to the paper's checker.

Allowed paths: `papers/chordal-conference-reconstruction/verification/`,
`papers/chordal-conference-reconstruction/Makefile`, this card, the lane queue
row and archive, the lane handoff, and the dated report.

## Result

Projective dimension zero, projective degree six, six \(\F_{11}\)-rational
singular points equal to the frame points \([\mathbf 1-6e_a]\), rank-four
Hessian at each. Degree six against six multiplicity-one points forces
exactness and reducedness over the algebraic closure; only the
dimension-and-degree step is delegated to the machine. The same computation on
the chordal sheet cubic returns Hilbert polynomial \(4d+1\), independently
confirming mod 11 that the chordal singular locus is a rational normal quartic
with no isolated point.

Full numbers, hashes, replay commands, trust boundary, negatives, the proposed
manuscript remark, and the mystery ledger are in
`../2026-08-20-c926-conference-node-completeness.md`.

## Artifacts

- `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.py`
  — standard-library checker, schema `paper-v-conference-node-completeness-v1`,
  `--write`/`--check`.
- `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.json`
  — the certificate; verdict `EXACTLY_SIX_REDUCED_NODES`.
- `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.sing`
  — independent Singular replay, not in `make check` because it needs Singular.
- `papers/chordal-conference-reconstruction/Makefile`, `verification/README.md`
  — the new checker runs as a second `make evidence` terminal.

## Left for the user

1. Whether to land the drafted remark and the two optional exactness edits
   (Section *Paper II placement* sentence, abstract) in the manuscript, and the
   one appendix sentence naming the second checker.
2. Whether the five standalone Paper V repositories under `~/src/math-papers/`
   should receive the new verification files; nothing was propagated.
