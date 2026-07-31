# Lean trust map for the golden-return package

## Result

The formal package uses the same labelled conference matrix, oriented triangle
tensor, increasing-triple basis, Hodge signs, and restriction-of-scalars
matrices as the human proofs.  Symbolic arguments handle the ring-general
claims.  Native decision is confined to literal integral matrices and the
finite twenty-triple incidence carrier; no generated matrix or certificate is
imported.

The modules are:

- `RelativeConicArcs.ClebschGoldenConference`;
- `RelativeConicArcs.ClebschTwoGraph`;
- `RelativeConicArcs.ClebschMiddleExterior` and its three theorem leaves
  `ClebschMiddleExteriorSquare`, `ClebschMiddleExteriorDiagonal`, and
  `ClebschMiddleExteriorSupport`;
- `RelativeConicArcs.ClebschGoldenDescent`; and
- the audit gate `RelativeConicArcs.Gates.ClebschGoldenReturn`.

## Theorem map

| mathematical claim | Lean declaration | proof mode |
|---|---|---|
| displayed integral matrix is symmetric | `ClebschGoldenConference.conferenceMatrix_transpose` | native decision |
| (C^2=5I) over (mathbf Z) | `ClebschGoldenConference.conferenceMatrix_sq` | native decision |
| (C^2=5I) after commutative-ring base change | `ClebschGoldenConference.conferenceMatrixOver_sq` | symbolic map argument |
| switching preserves triangle signs and the cubic | `ClebschGoldenConference.triangleSign_switch`, `triangleCubic_switch` | symbolic ring proof |
| orientation reversal negates the cubic | `ClebschGoldenConference.triangleCubic_neg` | symbolic ring proof |
| four-point two-graph identity | `ClebschGoldenConference.triangleSign_four_point` | symbolic ring proof |
| pair balance follows from, and forces, the conference square | `ClebschGoldenConference.pairTriangleSum_eq_zero`, `sq_eq_five_of_pairTriangleSum_eq_zero` | symbolic matrix proof |
| cubic descends to the augmentation quotient | `ClebschGoldenConference.conference_triangleCubic_translate` | twenty checked coefficients, then symbolic polynomial identity |
| triangle tensor reconstructs the signed matrix up to switching | `ClebschTwoGraph.switch_eq_reconstructed_triangleSign`, `reconstructed_triangle_root`, `reconstructed_triangle_nonroot` | root-gauge symbolic proof |
| Hodge sign and column-action convention | `ClebschMiddleExterior.hodgeSign_complement`, `hodgeMatrix_complement_entry`, `middleExterior_eq_hodge_mul` | definitional finite cases and sparse matrix multiplication |
| Hodge square and (K^2=125I) | `ClebschMiddleExterior.hodgeMatrix_sq`, `middleExterior_sq` | native decision from minors and Hodge signs |
| (K_{SS}=4c_S) | `ClebschMiddleExterior.middleExterior_diagonal` | native decision from minors |
| `K mod 2` is the intersection-one graph | `ClebschMiddleExterior.middleExterior_mod_two_eq_one_iff` | native decision from minors |
| parity graph recovers complementation | `ClebschMiddleExterior.commonIntersectionOneNeighbors_eq`, `commonIntersectionOneNeighbors_eq_zero_iff` | exhaustive kernel evaluation on twenty triples |
| golden companion square and descended commutation | `ClebschGoldenDescent.goldenCompanion_sq`, `goldenCompanion_mul_descendedCoefficient` | symbolic ring proof |
| degree-ten integral intertwiner and index | `ClebschGoldenDescent.conference_mul_degreeTenComparison`, `degreeTenComparison_det` | native decision on displayed matrices |
| normalized return-scalar conversion | `ClebschGoldenDescent.normalizedReturnScalar` | rational normalization |

## Exact boundary

The following human statements are deliberately not represented by a weaker
finite surrogate:

- the classification of every balanced two-graph as the unique pentagon
  switching class;
- recovery of the six abstract atoms from the maximum cliques of the Johnson
  scheme;
- the general-field kernel theorem for the third exterior-power map
  `GL₆ → GL₂₀`, and hence the
  final abstract return-to-conference implication;
- construction of the binary-form transvectant and its Fischer adjoint, as
  opposed to the formalized exact normalization conversion; and
- the optional split-quaternion, order, Iwahori, and Morita refinements added
  after the core seven-lemma package.

The first two require a reusable finite-incidence classification layer rather
than a Boolean enumeration.  The exterior-kernel statement needs a projective
or exterior-algebra API that remembers decomposable lines.  The transvectant
claim needs paper-faithful binary-form and adjoint definitions.  The optional
quaternion refinements have no manuscript dependency in the frozen sub-700
package.  These omissions remain human-proved interfaces and are not included
in the formal coverage claim.  This is the accepted C712 boundary: extending
any of these items requires new abstract library interfaces rather than a
paper-faithful strengthening of the present finite carrier.

## Trust and replay

The pinned toolchain is `leanprover/lean4:v4.32.0-rc1`.  Native-decision
terminals are named in the gate header and in the paper-local manifest
`papers/clebsch-passages/verification/golden_return_formal.json`; the complete
observed report is pinned as `golden_return_axioms.txt`.  It contains only
Lean's standard `propext`, `Classical.choice`, and `Quot.sound` dependencies
plus the theorem-local `native_decide` axioms displayed there.  The replay
entry point is

```text
python3 papers/clebsch-passages/verification/verify_golden_return_lean.py \
  --lean-root /path/to/formal-artifact
```

The script verifies the exact source hashes and toolchain, builds the gate,
replays every `#print axioms` command, and rejects `sorry`, declared axioms,
unsafe declarations, and private workflow identifiers in the pinned source
set.

## `ej` + `tt` closeout

The extra-juice pass retained three cheap strengthening steps: the converse
from pair balance to the conference square, the direct sparse equality
`middleExterior = hodgeMatrix * compoundThree conferenceMatrix`, and an
explicit regression theorem for the Hodge column sign.  The Tao-style pass
then separated what the fixed carrier genuinely proves from what would require
new abstract structure: balanced-class uniqueness, atom reconstruction,
faithfulness of the exterior cube, and the transvectant/Fischer construction
remain visible boundaries rather than being replaced by finite Boolean
surrogates.  No incidental observation met the discovery-track discriminator.

## Mystery ledger

- **Why the cubic descends:** settled formally at the paper's twenty-term
  normalization; no division by six is hidden.
- **Whether pair balance is weaker than the conference equation:** settled
  formally in both directions for symmetric signed order-six matrices.
- **Whether the middle-exterior check uses a stored return matrix:** settled
  negatively.  It evaluates signed Hodge complementation and closed
  (3\times3) minors from the displayed (C).
- **Which Hodge sign acts on columns:** settled definitionally.  The formal
  matrix proves `*e_S = ε(S,Sᶜ)e_{Sᶜ}` before checking the diagonal; this
  regression theorem prevents the harmless-for-the-square global sign from
  passing unnoticed.
- **What parity remembers:** settled through the intersection-one graph and
  its intrinsic complement relation.  Atom recovery from maximum cliques is
  the precise unformalized final step.
- **Whether the large differential scalar is intrinsic:** settled formally at
  the conversion level; it becomes (64/1575) under the normalized
  transvectant and Bombieri--Fischer conventions.
- **Remaining formal mystery:** no unexplained numerical coincidence remains.
  The unformalized items above are missing library interfaces or classification
  layers, not evidence gaps in the human theorems.
