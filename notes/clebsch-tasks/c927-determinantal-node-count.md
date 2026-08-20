# C927 — determinantal proof of the conference node count

**Lane:** `clebsch`
**Paper stream:** Paper V (`papers/chordal-conference-reconstruction/`)
**State:** complete. The theorem is proved; the replay checker is committed and
wired into `make evidence`. No manuscript edit was made (user instruction), so
where the proof lands in the paper is still open.

## Scope

Replace the machine-delegated step of [C926](c926-paper-v-conference-node-completeness.md)
by a structural proof that the conference triangle cubic has exactly six ordinary
nodes.

Allowed paths: `papers/chordal-conference-reconstruction/verification/`,
`papers/chordal-conference-reconstruction/Makefile`, this card, the lane queue
archive row, the lane handoff, and the dated report.

## Result

The conference cubic is \(\det M\) for the three-by-three matrix of linear forms
\(M(x)=\sum_i x_i\,\ell_i\otimes m_i\), where \(\ell_i\) and \(m_i\) are the
coordinate functionals on the two eigenspaces \(W_\pm=\ker(B\mp\sqrt5)\) of the
conference matrix. Its singular locus is the rank-at-most-one locus of \(M\),
which is exactly the six coordinate tensors \(\ell_a\otimes m_a\), the six frame
points. The proof runs on three structural facts: both eigenspaces are
\([6,3,4]\) maximum-distance-separable codes, because a short eigenvector would
make \(\sqrt5\) an eigenvalue of a hollow symmetric sign matrix of size at most
three; \(\sum_i\ell_i\otimes m_i=0\), which is orthogonality of the eigenspaces;
and the icosahedral group has no orbit of size six on \(\PP^1\), which kills both
the alternative pencil member and the Reed–Solomon branch of the rank analysis.

It holds in every characteristic outside \(\{2,3,5\}\) in which five is a square,
so it also reproves the characteristic-zero node count of Paper I. It supersedes
C926's Gröbner computation as the authority; that certificate is now an
independent machine cross-check of a proved statement.

Full statement, proof, and consequences:
`../2026-08-20-c927-determinantal-node-count.md`.

## Artifacts

- `papers/chordal-conference-reconstruction/verification/evidence/determinantal_presentation.py`
  and its JSON — schema `paper-v-determinantal-presentation-v1`, verdict
  `DETERMINANTAL_PRESENTATION_CONFIRMED`, third terminal of `make evidence`.
- `papers/chordal-conference-reconstruction/verification/README.md`, `Makefile`.

## Left for the user

1. Where the proof lands in the manuscript. It could replace the
   citation-and-Hessian argument of the proposition on nodes in characteristic
   eleven outright, since it proves more in less space, or sit as an appendix
   with the proposition unchanged. This decision subsumes the C926 remark that
   was also left unapplied.
2. Whether the paper adopts the determinantal reading of the whole pencil — the
   conference cubic as a general three-by-three determinant against the chordal
   cubic as a symmetric Hankel one, with the Segre and the Veronese as the two
   rank-one varieties. That is a rewrite of the geometric contrast, not a repair,
   and it would also carry the Hilbert polynomial \(4d+1\) of the chordal control.
3. Whether the five standalone Paper V repositories under `~/src/math-papers/`
   receive the three new verification files; nothing was propagated.
4. Optional successor: prove ordinariness of the nodes inside the determinantal
   picture (transversality of the perturbation onto the two-by-two cofactor
   block) so that the Hessian computation is no longer cited at all.

## Literature audit

Run inside this task per `notes/literature-audit-conventions.md`; the report is
`../2026-08-20-c927-determinantal-node-count-literature-audit.md`. Verdict: the
proof mechanism is prior art (C. Segre, restated and proved as Propositions 8, 10
and 19 of Hassett–Tschinkel), and must never be called new. Not located, at the
coverage the report states and with MathSciNet unreachable: the equivariant
construction of the matrix from conference-matrix eigenspaces, and any link at
all between two-graphs and determinantal cubic threefolds. The unconditional
verification replacing Hassett–Tschinkel's transversality hypothesis is ours for
this cubic. No novelty ledger row exists; one is required before any novelty
sentence appears on any surface.
