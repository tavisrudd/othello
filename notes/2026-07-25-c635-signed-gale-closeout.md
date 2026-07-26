# C635 — signed Gale formalization closeout

**Date:** 2026-07-25

## Result

The strongest redundant hypothesis in the C632 Lean theorem has been removed.
The new terminal
`RelativeConicArcs.SignedGaleDuality.signedRowSpace_eq_ker_of_fullSupport`
assumes only:

\[
A(AD)^{\mathsf T}=0,\qquad
\operatorname{rank}A=q,\qquad
\epsilon_j\ne0\ \text{for every }j,\qquad
\#\text{columns}=2q.
\]

It concludes
\[
\operatorname{rowspan}(AD)=\ker A.
\]

The proof factors the previously external independence condition into two
kernel-checked lemmas. Surjectivity of the column-evaluation map makes the rows
of \(A\) linearly independent. Coordinatewise multiplication by a full-support
weight vector is an injective linear map, so it preserves that independence.
The rank--nullity argument from C632 then applies.

## Extra-juice and Tao pass

The cheap upgrade was to make “full-support Gale scaling” do formal work rather
than remain descriptive prose. This closes the only redundant hypothesis in
the terminal theorem.

The Tao-style diagnostic asks which assumptions have distinct jobs:

- \(A(AD)^{\mathsf T}=0\) gives containment in the relation kernel;
- full row rank fixes \(\dim\ker A\);
- full support prevents diagonal scaling from losing row rank;
- the \(q\)-by-\(2q\) shape makes the two dimensions equal.

None can simply be deleted. Without full support, signed-row rank may drop.
Without full row rank, both the row span and kernel dimensions can move.
Without the half-size relation, orthogonality gives only containment.

## Degrees of freedom

- **Row-basis gauge:** replacing \(A\) by an invertible row operation changes
  the displayed Gale basis but not the projective configuration or relation
  space. The theorem intentionally concludes equality of subspaces, not
  equality of chosen bases.
- **Global weight scale:** multiplying every \(\epsilon_j\) by one nonzero
  scalar changes the displayed Gale matrix by a global scalar and leaves its
  row space unchanged. No normalization is mathematically canonical.
- **Column representatives:** homogeneous columns and Gale columns are each
  defined only up to nonzero column scaling. Full support is the invariant
  condition needed by the proof.
- **Affine reference choice:** translating the affine chart performs an
  invertible row operation on the homogenized matrix. It preserves the
  projective Gale statement but does not choose or create an equivariant
  affine origin; C417's cocycle obstruction remains.
- **Geometry-to-matrix bridge:** the \(B_3/H_3\) signed moment vanishings,
  spanning facts, and full-support sheet signs are still supplied by the exact
  C621 evidence rather than by Lean.
- **Beyond Gale duality:** Cayley--Bacharach, arithmetic Gorensteinness, descent,
  and identification of \(\mu_3\) as the inverse system remain genuinely
  different algebraic-geometric inputs.

## Validation and trust

The source elaborates without warnings. The dedicated gate prints the new
helper and terminal axioms; they use only `propext`, `Classical.choice`, and
`Quot.sound`. The guarded gate build and aggregate exact-target no-build check
pass. There are no `sorry` declarations, custom axioms, native evaluation, or
certificate imports.

Replay:

```text
lean/scripts/guarded-lean RelativeConicArcs/ClebschSignedGaleDuality.lean
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschSignedGaleDuality \
  RelativeConicArcs.Gates.ClebschSignedGaleDuality \
  --profile single --threads 1 --cores 20-23
```

## Mystery ledger

- **Settled:** signed-row independence is not an additional geometric input;
  it follows from full row rank and full-support weights.
- **Settled:** the four remaining hypotheses have separate, visible jobs.
- **Open:** formalizing invariance under row-basis changes and global rescaling
  would improve the API but would not strengthen the mathematical conclusion.
- **Open:** a formal bridge from the two frozen configurations to the abstract
  hypotheses is the next substantive coverage step. It requires an explicit
  coordinate/certificate design rather than another linear-algebra lemma.
