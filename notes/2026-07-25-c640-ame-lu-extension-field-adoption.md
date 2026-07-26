# C640: Lean-complete extension-field pencil adoption

**Lane:** `ame-lu`

## Result

The manuscript now adopts exactly the unconditional scalar content of
`RelativeConicArcs.AMELU.ExtensionFieldPencil`.  Proposition
`prop:frobenius-sector-divisors` gives, for every automorphism of an odd
finite field:

- the diagonal frame-ratio divisor
  \[
  E_\sigma(t)=(\sigma(t)-t)(1-\sigma(t)t);
  \]
- the Frobenius--Gale divisor
  \[
  D_\sigma(t)=((1-\sigma(t))(1-t))^2+\sigma(t)t;
  \]
- the explicit six-coordinate Gale multiplier
  \((-h,-h,1,1,-1,-1)\), with \(h=(1-\sigma(t))(1-t)\);
- \(D_{\mathrm{id}}=G\);
- disjointness of the diagonal and Gale modes at one fixed exponent on the
  admitted non-GRS locus; and
- field-automorphism equivariance of \(G,A,B,z\) and the admitted locus.

The aggregate gate and axiom audit now import and inspect the eleven
unconditional declarations supporting those statements.

The full extension-field Clifford-orbit classification is not adopted.
`extensionField_pencil_classified_by_galoisZ` remains conditional on the two
fields of `ExtensionFieldPencilOrbitInputs`: extraction of a projective
Frobenius sector from an additive Clifford equivalence, and construction of
a Clifford from a Galois match of \(z\).

The same strict rule was applied retrospectively to C631.  The intrinsic
diagonal-multiplier line and nullity test remain in the paper, because they
are unconditionally formalized.  The generator-matrix/Veronese presentation
and its \(m=2,3\) consequences were removed because they do not have separate
Lean theorems.

## Reconciliation

The theorem map, claim/proof/novelty ledger, verification map, formalization
ledger, formal-statement adequacy map, and verification section now state the
same boundary.  No new finite computation entered the manuscript.

## Validation

- `RelativeConicArcs.Gates.AMELUAggregate` and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms` passed the guarded serial
  build queue.
- The new declarations report only `propext`, `Classical.choice`, and
  `Quot.sound`, with the expected declaration-by-declaration subsets.
- `make -C papers/ame_lu check` passed without warnings.
- `python3 papers/ame_lu/supplement/verify.py --replay` verified 17 artifacts
  and replayed all eight evidence bundles.
- Pages 8, 12, and 19 were visually inspected after the final build.
- The PDF has 23 pages, 206246 bytes, and SHA-256
  `0880655a11ba3f4c0c6106d5751b5ccacf900c2657b2c81eb3574f6206ef137b`.
- The release verifier reports 37 public artifacts with tree
  `143df92917fe2e41e614178f318fe04c30291ecb746c145bb6b6222406d94cde`
  and 80 formal artifacts with tree
  `4c4b2fae61e3b2d3d879d6e1ef73a567c4adcc79d8c4e73381b306604105e39a`.

## Extra-juice and Tao-style closeout

The cheap high-value upgrade was not another theorem but a sharper division
of labor: the scalar sector geometry is exact and formal, while the
representation-theoretic passage to arbitrary additive Cliffords is named
separately.  This prevents a conditional composition theorem from being read
as a formal proof of the full orbit classification.  Removing the C631
Veronese add-on applies the same standard uniformly across the paper.

## Mystery ledger

- **Open:** Does every additive local-Clifford equivalence expose a nonzero
  projective Frobenius sector?  Evidence gap: the first field of
  `ExtensionFieldPencilOrbitInputs`.
- **Open:** Does a Galois match of \(z\) always construct an additive local
  Clifford?  Evidence gap: the second field of
  `ExtensionFieldPencilOrbitInputs`.
- **Settled here:** no same-exponent diagonal/Gale coexistence occurs off the
  GRS locus; different-exponent coexistence remains compatible with the
  exceptional kernels already found in C623.
- **No new incidental mystery:** the remaining quantitative question is the
  separately queued C581 approximate-rigidity problem.
