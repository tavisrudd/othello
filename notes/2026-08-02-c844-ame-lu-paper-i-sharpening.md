# C844 — sharpen Paper I around exact rigidity and quantitative rounding

**Lane:** `ame-lu`
**Status:** complete

## Result

Paper I is now the independent 35-page *Local-Unitary Rigidity and
Quantitative Rounding for Stabilizer AME States*. Its body has one exact and
one approximate causal spine:

1. AME support squeeze, full-Weyl marginal, intrinsic local axes, Clifford
   factors, minimum-support atlas, and encoder no-go;
2. three-region cleaning, leakage-aware nested commutators, Weyl--Fourier
   rounding, stabilizer-overlap branch selection, collective residual bound,
   robust symplectic-atlas compatibility, and the affine-character
   obstruction.

The exact theorem begins on page 1 and the quantitative theorem on page 2.
The quantitative statement displays the full uniform scale
`Theta(min{p^-1,q^-1/2,n^-1/2})`, the local `8 eps` bound, and the residual
`D <= pi sqrt(q) eps`. The Reed--Solomon specialization distinguishes the
prime-field `Theta(q^-1)` and extension-degree-at-least-two
`Theta(q^-1/2)` regimes.

## Split implementation

- Removed the Paper II-owned exact MDS--CSS group, pencil, logical-phase,
  scalar-invariant, transport, and party-extension sections.
- Removed the Paper II-owned symmetry-group and pencil-quotient figures.
- Removed the complete 21-file computational supplement after confirming
  Paper II's independent 17-artifact replay and ownership record.
- Replaced the combined abstract, introduction, conclusion, trust statement,
  README, provenance status, and Zenodo metadata with Paper I text.
- Rewrote the theorem, novelty, verification, formalization,
  statement-adequacy, adversarial, and revision ledgers to the Paper I
  boundary.
- Split the former 2,200-line mixed source into physical exact/atlas,
  cleaning, partial-recognition, and secondary-quantitative units. The source
  order now matches the rendered order without conditional re-inputs.
- Renumbered the body cleaning equations as `(5.1)`--`(5.12)` and the
  secondary mechanism equations as `(B.1)`--`(B.13)`.

The appendices retain partial-Weyl recognition, two- and `k`-uniform
stability, the budget-free residual theorem, the single-marginal route, the
aggregate minimum-support route, and the 2-unitary corollary. They are framed
as mechanism comparisons rather than competing headlines.

## Verification

- `make -C papers/ame_lu check`: PASS, warning-free.
- PDF: 35 pages, 297,514 bytes, SHA-256
  `08d76f3b4afa8eec52772f6a91a25e7e717556967f5542083f4e67b675f8eb57`.
- `git diff --check -- papers/ame_lu`: PASS.
- Zenodo JSON syntax check: PASS.
- Removed-section/label/source scan: zero live hits.
- Rendered inspection: pages 1, 2, 9, 13, 15, 17, and 35 pass for theorem
  hierarchy, equations, section and appendix transitions, figures, trust
  prose, and bibliography close.
- Theorem-only cold read: PASS. It identifies both mechanisms and names the
  affine stabilizer character, not the symplectic atlas, as the remaining
  obstruction.

The pre-split release manifest and broad formal aggregate are deliberately
not refreshed. The formal semantic gate, recursive formal-root contract,
release identity, and standalone forward synchronization are successor
phases. `make release-check` is therefore not a C844 acceptance gate.

## Extra-juice and Tao closeout

The closeout exposed two cheap structural improvements, both adopted. First,
the initial rendered draft retained the old equation numbers, hiding the fact
that the strongest proof had moved into the body; body and appendix numbering
now make the hierarchy visible. Second, the first implementation reused one
large TeX file conditionally; physical source units now match the mathematical
sections, which makes the future formal-root and release audit narrower.

The Tao-style question is whether the robust atlas should already remove the
`sqrt(n)` entry loss. The manuscript now answers at the correct level: it
recovers the exact linear symplectic data at a dimension-only radius, but all
localized commutators cancel the affine Weyl phases. The missing datum is the
stabilizer character, equivalently a locally controlled product-Pauli
correction. This is an exact obstruction statement, not a vague failure of the
estimate.

## Mystery ledger

| Feature | Closeout status | Exact remaining gap or owner |
|---|---|---|
| Total length is 35 pages, while the body ends on page 14 and the appendices carry the detailed alternative routes | settled for C844 | the theorem-only and visual reads found no missing proof bridge; page count is within the frozen 32--36 target and no padding was added |
| Robust symplectic compatibility holds at a dimension-only radius but does not enlarge the global entry radius | mathematically explained, open as a research problem | a future theorem would need quantitative control of the stabilizer-character discrepancy or an equivalent collective affine branch-selection principle |
| The cleaning radius has no known saturating family | open and stated | no product-unitary family currently gives a matching upper bound; any optimality task requires a separately allocated proof item |
| Paper I's exact public formal closure is not yet content addressed | intentionally open | the formal-split successor owns the semantic gate, mixed-module audit, recursive root contract, and public `finitegeom` materialization |
| Final public cross-paper citation and standalone state are absent | intentionally open | the release successor owns the regenerated manifest, immutable public locator, and forward standalone commit |

The discovery-track discriminator found no incidental observation from the
planned manuscript split. No entry was added.
