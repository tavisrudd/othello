# C732 — Clebsch AME extremal-\(X\)-syndrome bridge adoption

**Date:** 2026-07-31
**Lane:** `ame-lu`
**Status:** complete; authoritative and standalone gates passed

## Outcome

Section 5 now contains `prop:clebsch-x-syndrome` and
`rem:clebsch-x-syndrome-boundary`.  The proposition gives the exact quantum
interpretation of the Clebsch deep-hole theorem without changing the paper's
title, abstract, or headline hierarchy.

For the Clebsch code \(C=\ker H\), it proves directly that

\[
 X(e)|\Psi_C\rangle=X(f)|\Psi_C\rangle
 \quad\Longleftrightarrow\quad e-f\in C,
\]

that distinct cosets give orthogonal translated states, and that the
\(Z(C^\perp)\)-stabilizer syndrome is \(He^{\mathsf T}\).  Invertibility of
every three-column submatrix proves the one-per-support statement directly.
With an explicit companion-preprint citation, it imports the exact Clebsch
results:

- twelve projective covering-radius rays forming a nonsingular conic;
- 120 nonzero syndromes;
- one transitive \(C_{10}\times A_5\) monomial orbit.

There is exactly one weight-three representative on each of the twenty
three-party supports for every extremal syndrome.  Equivalently, every
extremal translated state can be created by a minimum \(X\)-operator on
either side of every balanced \(3\mid3\) cut.

The AME--LU theorem supplies the paper-specific conclusion: the defining
six-arc is nonconic, so every fixed-party encoder view has split-torus
logical symplectic image rather than \(\operatorname{SL}_2(11)\).  General
LU rigidity separately makes every product-unitary stabilizer-AME
intertwiner Clifford factor by factor.

## Referee boundaries retained

The adjacent remark records all C731 publication conditions:

- the conic lies in the \(X\)-syndrome plane, not through the six defining
  columns;
- covering radius three is an \(X\)-only minimum-operator-support statement,
  not arbitrary weight-three quantum correction;
- the equation of the conic changes projectively with the row basis of \(H\);
- \(A_5\) is the projective monomial quotient, whereas the computed full
  Clebsch party image is \(S_5\);
- the absent Fourier block is a fixed-party obstruction; odd party motion
  inverts \(T\) and supplies the nontrivial class of \(N(T)/T\); and
- the unlabelled conic supplies neither a marked coordinate six-set nor the
  support orientation needed by finer Clebsch/Golden constructions.

No Hamiltonian, colloidal, tensor-network, topological, anomaly, or Golden
conference-operator interpretation enters the manuscript.

## Citation and trust boundary

`refs.bib` now cites the public `tavisrudd/clebsch-rigidity` preprint.  The
paper credits that source for the conic, 120-count, and automorphism orbit;
it proves the coset-state/stabilizer-syndrome and one-per-support composition
locally.

The theorem map, claim/proof/novelty ledger, verification map, formalization
ledger, formal-statement adequacy table, and adversarial audit now agree that
this is a human-proof composition.  There is no Clebsch-specific Lean
terminal and no new paper-local computation.  The existing C624 certificate
continues to own the q=11 \(S_5\) party image and torus-inversion statement.

## Validation

- `make check`: passed; warning-free 31-page PDF, 248,207 bytes, SHA-256
  `c857b9289dc43aa133284038cc9fa12a60315b826425176a05b135da19ed3d56`.
- visual inspection: pages 18--20 and 30--31 passed; the proposition and
  boundary remark occupy page 19 without overflow or hierarchy defects, and
  the public preprint URL wraps cleanly in the bibliography.
- release manifest: regenerated after the source and PDF changes.
- `make release-check`: passed; all eight evidence bundles replayed, 37
  public artifacts verified with tree
  `4fa7b49cdc982ae724eb2b4787c8e786c2d37d82bd3e289d938dde6f4c0482e9`,
  and 83 formal-companion artifacts verified with tree
  `43e5d3ea17e1d0275fad0ff84462d1817f141973b212f3386af83a8612eb4687`.
- standalone mirror: synchronized by forward commit `c1be0c8`; warning-free
  build, eight-bundle replay, public and arXiv release profiles, and the same
  37-artifact public-tree identity passed.  The formal companion was recorded
  and correctly absent from the paper-only export.  The local mirror is one
  commit ahead of `origin/main`; no push or external deposit was performed.

The authoritative manuscript commit is `68ee4664`.

## Files

- `papers/ame_lu/sections/05-logical-clifford-phase.tex`
- `papers/ame_lu/refs.bib`
- `papers/ame_lu/ame-lu.pdf`
- `papers/ame_lu/release/RELEASE-MANIFEST.json`
- `papers/ame_lu/sections/09-party-extensions.tex`
- `papers/ame_lu/{theorem-map,claim-proof-novelty-ledger,verification-map}.md`
- `papers/ame_lu/{formalization-ledger,formal-statement-adequacy}.md`
- `papers/ame_lu/adversarial-proof-evidence-audit.md`

## Extra-juice and Tao closeout

The closeout replaced the bare multiplicity “twenty” by the stronger exact
statement that every three-party support carries one representative of every
extremal syndrome.  The proof is free once one asks what the MDS condition
does support by support: each \(H_I\) is invertible, and covering radius three
forces all three recovered coefficients to be nonzero.  In the tensor
language, either side of every balanced cut can create the same extremal
translate.

The superficially adjacent count of ten minimum operator pushes for a fixed
input Pauli is a different fibre.  It chooses the ten output triples after an
input leg is fixed, whereas `prop:clebsch-x-syndrome` ranges over all twenty
three-subsets for a fixed \(X\)-syndrome.  No identification is asserted.

## Mystery ledger

- **Settled — twentyfold ambiguity.**  It is exactly one representative on
  every three-party support, not an unexplained degeneracy.
- **Settled — \(A_5\) versus \(S_5\).**  The former is the Clebsch monomial
  quotient acting on the syndrome rays; the latter is the full computed
  party image.  Section 9 now labels the \(t=2,z=1\) Clebsch row explicitly.
- **Settled — electric--magnetic wording.**  The obstruction is fixed-party;
  odd party motion reaches the nontrivial class of \(N(T)/T\).
- **Settled — evidence ownership.**  The companion preprint owns the conic,
  120-count, and monomial orbit; AME--LU proves the quantum dictionary and
  one-per-support composition.  No new Lean or finite certificate is claimed.
- **No genuine task-owned mystery remains.**  A colloidal entropic-Hessian or
  Golden-mode realization remains behind the separate C731 pre-allocation
  data gate and is not an AME--LU manuscript frontier.

## Vibe check

The example now earns its page: it makes the nonconic-encoder/conic-error-shell
contrast exact while leaving every tempting physical overclaim outside the
paper.
