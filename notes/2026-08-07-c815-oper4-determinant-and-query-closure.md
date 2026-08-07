# C815 — closing manuscript row OPER-4: the determinant-minus-three family and the query decoder

**Lane:** `clebsch`
**Date:** 2026-08-07
**Task:** C815
**Paper:** III (`papers/clebsch-passages`), theorem `thm:aligned-faithfulness`

## What was open

Row OPER-4 of the trust manifest had two clauses with no formal counterpart:

1. the identification of the marked determinant-\((-3)\) family of a conference
   matrix with the aligned family of its two-graph;
2. the sufficiency of the selected query family — the four-sets meeting a fixed
   aligned four-point anchor in at least two points — for a decoder working from
   that single anchor.

Everything else in the row was already formalized: faithfulness at the
manuscript's quantifier range, anchor existence through both bounds behind
\(R(3,3)=6\), the normalization onto the cut classifier, the seven-point
signature classification, the finite-set extension, the switching transport, the
determinant identity \(\det = 3 - 2w\), the calibration, and the cardinality
\(3n^2-23n+45\) of the explicitly defined query family.

## What is now proved

### The determinant-minus-three family is the aligned family

`RelativeConicArcs.SeidelPrincipalMinors` works with `IsSeidelMatrix`: a
symmetric integer matrix with vanishing diagonal whose off-diagonal entries
square to one. Its two-graph is `seidelTriangleBit`, the parity of the number of
entries equal to \(-1\) among the three edges of a triple; on distinct labels
this is the bit recording that the triangle sign
\(C_{ab}C_{ac}C_{bc}\) is \(-1\) (`seidelTriangleBit_eq_decide`).

The mechanism is that each of the three signed Hamilton-cycle products of a
four-set omits one pair of opposite edges, hence is the product of the two
triangles avoiding that pair. All three therefore share a factor, and

\[
 w \;=\; t_{abc}\,(t_{abd} + t_{acd} + t_{bcd}),
\]

which is `fourCycleSum_eq_triangleSign_mul`. Since each \(t\) is \(\pm 1\), the
sum is \(3\) exactly when the four triangle signs agree, which is exactly
alignment (`aligned_iff_triangleSign_eq`). Feeding this into the existing
identity \(\det = 3 - 2w\) gives the two terminal statements

- `det_submatrix_eq_neg_three_iff_aligned` — on four distinct labels the
  principal minor is \(-3\) exactly on the aligned four-sets;
- `det_submatrix_eq_neg_three_or_five` — that minor takes no other value than
  \(-3\) and \(5\).

The second needs one input the first does not: the four triangle signs multiply
to one, because every edge of the four-set lies in exactly two of the four
triangles (`triangleSign_prod_eq_one`). Without it \(w\) would range over
\(\{3,1,-1,-3\}\); the product constraint removes the two intermediate values.

The reconstruction clause is `exists_switching_of_det_family_eq`: two Seidel
matrices on at least seven labels whose principal four-by-four minors take the
value \(-3\) on the same four-sets satisfy \(D_{ij} = \eta\, e_i e_j\, C_{ij}\)
off the diagonal, with all \(e_i\) and \(\eta\) squaring to one. The switching
signs are written down from a chosen label \(r\): \(e_r = 1\) and
\(e_i = \eta\, D_{ri} C_{ri}\), and the identity is then the recovery of each
entry from the triangle sign through \(r\).

This is stronger than the manuscript's statement in three ways. It assumes only
the Seidel conditions, not \(C C^{\mathsf T} = q I\); it needs seven labels
rather than order at least ten; and it records the second value \(5\), so the
Greaves–Suda design appears as the \(-3\) fibre of a two-valued function rather
than as a family singled out by hand.

### The query family of one anchor suffices

`RelativeConicArcs.AlignedQueryFaithfulness` proves that only the selected tests
are needed. The route is that the seven-point step already reads nothing else:
`sevenPoint_agreement` in `RelativeConicArcs.AlignedFamilyFaithfulness` now
carries the hypothesis

```
2 ≤ (({i, j, k, l} : Finset (Fin 7)) ∩ {0, 1, 2, 3}).card
```

on its aligned-family input, which is satisfied at all ten places the proof used
it: four call sites reading three anchor indices, covering the twelve such
four-sets of a seven-set, and six reading two, covering the eighteen. Weakening
the hypothesis changed no proof step.

With that in hand, `exists_complementBit_on_seven_of_anchor` runs the seven-point
argument along a *supplied* anchor rather than one found inside the seven-set,
and `exists_complementBit_of_selectedQuery_eq` globalizes it: any three distinct
points lie with the anchor in a seven-point subset, and all the resulting
complement bits agree because every such subset contains the anchor triple on
which the bit is calibrated. `exists_complementBit_of_selectedQueryFamily_eq`
states the same conclusion with the hypothesis read off membership in
`selectedQueryFamily`, the family whose cardinality
`card_selectedQueryFamily` computes as \(3n^2-23n+45\). Count and sufficiency
now refer to the same object.

The anchor hypothesis is never vacuous: `exists_distinct_alignedAnchor` produces
an aligned four-set of pairwise distinct points on any point set with at least
seven points, from a root, six further points, and the six-point Ramsey bound.
Composing it with the sufficiency theorem gives the decoder statement without
hypotheses beyond the point count.

## Validation

- Every new and changed module elaborates with no errors and no warnings through
  the guarded single-file entry point.
- `RelativeConicArcs.Gates.ClebschPassages` builds through the guarded queue.
  It now audits sixty-five terminals; every one depends only on `propext`,
  `Classical.choice` and `Quot.sound`, and none carries a compiled-evaluation
  axiom. The nine new terminals are `exists_distinct_alignedAnchor`,
  `exists_complementBit_on_seven_of_anchor`,
  `exists_complementBit_of_selectedQuery_eq`,
  `exists_complementBit_of_selectedQueryFamily_eq`,
  `seidelTriangleBit_eq_decide`, `aligned_iff_triangleSign_eq`,
  `det_submatrix_eq_neg_three_iff_aligned`,
  `det_submatrix_eq_neg_three_or_five` and
  `exists_switching_of_det_family_eq`.
- The axiom report and the source-closure inventory were regenerated by their
  tracked generators from the tracked gate stdout; both paper-local passages
  replays pass in source-only and axiom-log mode, and the golden-return and
  four-shadow replays pass unchanged.
- `verification/verify_release.py` passes every check, including the
  deterministic manuscript build. The tracked PDF was refreshed through
  `check_manuscript_build.py --update` under the paper's pinned flake, which
  also clears the manuscript-build failure recorded on 2026-08-05.

Replay, from `papers/clebsch-passages`:

```sh
python3 verification/verify_passages_lean.py --lean-root ../../lean --source-only
python3 verification/verify_passages_lean.py --lean-root ../../lean \
  --axiom-log verification/evidence/gate_stdout/passages.stdout.txt
nix develop --command python3 verification/verify_release.py --lean-root ../../lean
```

## Ledger and prose kept in step

`verification/trust_manifest.json`'s OPER-4 `proof_role` no longer says that the
two clauses are human inputs; it names what is proved and states the one precise
limitation, that the anchor search enters as existence plus a count rather than
as a formalized procedure. `verification/passages_formal.json` records the nine
new declarations in the row and rewrites its boundary text to match.
`sections/08-verification.tex` says the same thing in the manuscript's own
words, and `verification/statement_identity.json` was regenerated from the
manifest by its tracked generator.

One token was deliberately left alone. The row's `coverage` field still reads
`partial mechanism; no full row claim`, and the manifest's global
`formal_coverage.status` still reads `partial mechanisms; no complete manuscript
row claimed`. Both strings are hard-coded in `verification/verify_scaffold.py`
for all nine rows at once, so changing them is a change to the scaffold's row
vocabulary and to the release contract, not a per-row edit. Every clause of
OPER-4 now maps to a kernel-checked declaration, so the token understates the
row; promoting it belongs with the coordinated trust and release pass rather
than here.

## Mystery ledger

- **Is the three-anchor-point half of the query family removable?** Settled,
  negatively, by direct computation on the normalized model. Dropping the
  \(4(n-4)\) tests that meet the anchor in three points and keeping only the
  \(6\binom{n-4}{2}\) two-anchor-point tests collapses the 4,096 normalized
  seven-point data to 2,329 distinct signatures, with 1,767 collisions; the
  smallest are two cuts differing in one coordinate with the same three pair
  signatures. The anchor signatures are load-bearing, and this economization of
  the count fails. Script: `notes/2026-08-07-c815-pair-signature-only.py`.
- **How far is \(3n^2-23n+45\) from the minimum?** Not settled, but bounded.
  Two-graphs on \(n\) labelled points number \(2^{\binom n2 - n + 1}\), and each
  test returns one bit determined by the two-graph, so a family determining the
  two-graph up to complement has at least \(\binom n2 - n\) members. The
  selected family is therefore within a factor tending to six of the
  information-theoretic minimum. Whether a family of size \(cn^2\) with
  \(c < 3\) exists is open; the computation above rules out the one obvious
  candidate.
- **Is seven points the exact threshold?** Not settled. The theorem needs
  \(\lvert V\rvert \ge 7\) and the manuscript states it there, but nothing here
  exhibits two six-point two-graphs with the same aligned family that are not
  complements. The order-six conference matrix has no aligned four-set at all,
  so a witness would be a second six-point two-graph with empty aligned family
  outside its complement pair — a finite question on 1,024 switching classes.
- **Why does the reconstruction need no conference condition?** Settled by the
  proof: the argument uses only that the triangle signs are \(\pm 1\) and that
  the two-graph parity law holds, both of which follow from the Seidel
  conditions alone. The scalar square enters the manuscript's surrounding
  discussion, not this theorem. The order restriction \(n \ge 10\) in the
  manuscript comes from the conference orders, not from the argument.

## What remains in gap class B

OPER-4 is closed. The remaining rows are the geometric ones: ARITH-1 and
ARITH-2 (Hitchin incidence geometry, the global Stein algebra, the branch
divisor, the complete fibre and a spinor-norm interface), ORIENT-1 (scheme
normalization of the incidence pullback), the residue of OPER-1 (outer-family
coherence and the cross-golden block determinant over \(\mathbf Q(\sqrt 5)\)),
the residue of OPER-2 (outer matching frames, the Joubert coordinates, the
diagonal Clebsch section and the Segre–Igusa polar map), and HARM-1 and HARM-2
(face-axis geometry, the spherical addition theorem and the invariant-line
input). Each is a substantially larger piece of work than either clause closed
here.
