# Lean companion to *Irrationality of Cubic Threefolds after One Stabilization*

This Mathlib-only package is the shared formal companion to the primary paper
and the two companion manuscripts in this repository.  Its reviewer-facing
entry point is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface
```

That module is a thin aggregate of three manuscript-specific public entry
points:

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Main
TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.SixAxisCubicPencil
TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.CubicFramedMonodromy
```

They correspond respectively to the primary one-stabilization paper, the
integral-divisor-products companion, and the framed-monodromy companion.
Reusable audited terminals remain grouped below these entries in semantic
reviewer and machinery facades.

and its axiom audit is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit
```

The package separates two kinds of statement.  Algebraic and logical
deductions are proved by Lean's kernel.  Deep geometric and quantum comparison
theorems imported from the literature occur as explicit hypotheses of
conditional interfaces; they are not declared as Lean axioms and are not
reported as independently formalized.

## Interim coverage status

This is a publishable partial companion, not a claim of complete
formalization.  The machine-checked claim inventory contains every labelled
theorem-like environment in all three manuscripts and classifies each one as absent
from Lean, represented by an exact but strictly weaker fragment, represented by
a conditional deduction with every external premise exposed in the theorem
type, or completely formalized from the manuscript's stated hypotheses.  Of the
direct-QDM route to the one-stabilization theorem, Lean constructs the effective
block ledger and its universal additive fold, keeps every blowup correction as
an actual indexed occurrence, and proves the dimension-parameterized
weak-factorization descent theorem.  Both the rank-two residue marker and the
finer framed primitive-sixth marker are literal specializations of that common
categorical theorem.  Their QDM block decompositions, comparison theorems, and
geometric low-dimensional nullity statements remain explicit typed premises.
The small even block reduction behind the cubic packet is
checked from the displayed connection matrices through the modified residue and
its indicial polynomial, so the packet value no longer requires a supplied
characteristic polynomial, only the passage from residue exponents to framed
monodromy.  The framed count after that stabilization is now a Lean
deduction as well: from the product formula, taken as a typed premise, Lean
obtains the value four for the product of a cubic threefold with a projective
line and the value zero for every projective space.

The geometric rows of the atomic route are covered on their algebraic side.  The
sign between the residual endomorphism of the connection in the loop coordinate
and Euler multiplication is turned into an exact dictionary between their
generalized eigenspaces, eigenvalue counts, regularity, and characteristic
discriminants; the fixed points of a family of algebra automorphisms are shown to
form a subalgebra on which multiplication by a fixed element restricts, with the
truncated polynomial algebra of exponent four as an instance; and the parity
ranks two and ten of the zero packet of a cubic threefold are derived from the
truncated Chern class arithmetic, the Betti numbers, the degree count placing the
whole odd cohomology in that packet, and the constancy of rank on a connected
component.

Checked coverage snapshot: 57 claims; 4 absent; 25 fragmentary; 27 conditional;
1 complete; 318 reviewer terminals, of which 83 are machinery serving no current
manuscript claim.

Those machinery terminals are kernel-checked and reusable, and the claim map records for each one
why no current claim rests on it.  They formalize the pro-Laurent gauge tower,
coefficientwise and flat base change of horizontal monodromy, ideal-filtration
and adic quotient towers, existence and uniqueness of normalized flat gauges
with their zero-curvature integrability identities, and the positive-filtration
evaluation branch.  The manuscript reached its specialization and
bulk-displacement steps through that route in an earlier draft and now assumes
Hypotheses 5.7R and 5.7T at those points instead.

The reviewer-facing terminals currently verify:

- the exact DVR rank-one generation equivalence for arbitrary finite symmetric
  matrix-of-ideals lattices;
- the square-zero divided-power expansion;
- finite internal rank-one list extraction and its all-degree square-zero
  realization consequence, the canonical elliptic-source factorization of
  rank-one coefficient matrices as decomposable exterior two-forms and their
  resulting square-zero identity,
  the literal ordinary degree-by-degree product submodule generated by a
  divisor submodule, and squarefree-product membership in that submodule,
  entrywise coefficient extension of weighted matrix lattices and rank-one
  matrices; congruence transport through a supplied invertible basis over the
  extension ring, with distinct base and split coordinate types, exact
  rank-one preservation, and inverse recovery; ordinary-product base-change
  containment; faithful-flat reflection of both product membership and the
  resulting factorial identity;
  reflection of source square-zero through an injective ring pullback, and
  exact reflection of integral-product membership from a faithfully flat
  tensor extension via the quotient module;
- elementwise local-to-global subgroup membership from prime-to-prime
  denominator witnesses, including its composition with all-degree rank-one
  assembly into an abstract integral product subgroup;
- the equivalence of the dual- and coefficient-form adjoint conventions,
  graph-coordinate block multiplication, equivalence of entrywise integrality
  with the three displayed block conditions, the exact DVR equivalence between
  scalar-difference-product divisibility and the truncated valuation deficit,
  the reduction of the full split-slope commutator to that deficit under the
  two diagonal coefficient conditions, the exact equivalence between the
  single cross-depth condition and all three split-slope block conditions,
  now for actual rectangular matrices of arbitrary finite block ranks; the
  unit-to-positive rectangular commutator calculation; and the remaining
  intersection arithmetic, assembled across a finite dependent family of
  blocks including unrestricted depth-zero blocks, underlying the
  coefficient-lattice calculation; its exact flattening to one literal
  matrix-of-ideals lattice; its exact transport from distinct base coordinates
  through a supplied invertible splitting-ring basis, with weighted membership
  derived from supplied formal blockwise graph-descent conditions; and automatic
  rank-one generation of that graph lattice over a DVR;
- the polarized six-axis source lattice on integral first homology: the
  Kronecker product of `6I-J` with the standard alternating rank-two elliptic
  homology pairing, its alternation and determinant `6^8`; the consequence that
  a comparison matrix pulling a unimodular alternating form back to it has
  determinant of absolute value `6^4` and is injective; the identification of
  the kernels of its two- and three-torsion reductions with four copies of the
  rank-two module over the respective prime field; and the six-coordinate form
  on augmentation lifts, which
  is six times the dot product and so has half reducing modulo two to the dot
  product and third reducing modulo three to its negative, independently of the
  chosen lift;
- the `6I-J` eigenspaces, an explicit integral Smith reduction to
  `diag(1,6,6,6,6)`, uniqueness of the polarization parameters, the explicit
  orthogonal local block, its exact depth-one arithmetic at two and three, and
  explicit residue-field slope models: the block-diagonal matrix formed from
  two copies of the companion matrix of the irreducible polynomial
  `t^2+t+1` over `F2`, whose matrix minimal polynomial is proved to be that
  quadratic; its entrywise scalar extension to any characteristic-two
  commutative ring containing a supplied root is identified with the
  same-pattern matrix and diagonalized by an explicit basis, with the two
  conjugate roots each repeated twice; the concrete root-adjoining extension
  is proved finite etale of degree two over `F2`, identified algebraically
  with the concrete `F4` used in the gluing packet, and carries that marked
  root to one of the two non-prime-field elements exchanged by Frobenius,
  whose two affine-chart points form an explicit projective-Frobenius two-cycle,
  together with the explicit diagonalization both in the root-adjoining field
  and directly over that concrete `F4`; and a scalar block over `F3`,
  without identifying
  those models with the geometric principal kernel;
- the depth-one lifting step of that chart, over a domain in which `p` and `2`
  are nonzero and for a symmetric Gram matrix with a two-sided inverse over the
  ring: every endomorphism of the reduction modulo `p` that is self-adjoint for
  the reduced dual coefficient form is the reduction of a matrix self-adjoint for
  the dual coefficient form, the witness correcting a chosen lift by `p` times
  the Gram matrix times the strictly lower triangular part of the divided
  adjointness defect, so the construction divides by nothing; with the two
  statements that make it meet an orthogonal decomposition, namely that a
  block-diagonal matrix is self-adjoint as soon as each block is, and that a
  scalar matrix is self-adjoint for every dual form;
- the orthogonal decomposition of the coefficient lattice in that chart as an
  actual change of basis, over any coefficient ring in which five has an
  inverse: the chart matrix is invertible, its columns are the first coordinate
  vector and the displayed complement vectors, and it carries `6I-J` to the
  block matrix with the unit line of value five and the complementary block
  `(6/5)(5I-J)`, whence the first chart dual vector lies in the image of `6I-J`
  and every vector is congruent modulo that image to a combination of the four
  chart dual vectors orthogonal to it;
- the location of the discriminant group of `6I-J`, the quotient by the image of
  multiplication by that matrix: the constant vector lies in the image and has
  value five under the form, every integral vector is congruent modulo the image
  to a combination of the four remaining Smith basis vectors, whose entries have
  exact depth one at two and three, and six annihilates the quotient, so at
  either prime dividing six the primary part is supported on those four
  coordinates, without identifying that quotient with a geometric isogeny kernel;
- the projective-line classification into scalar graphs and the vertical
  line, the five- and four-member finite-field packet counts, and the
  isotropic half-dimension calculation for self-adjoint graph slopes;
- explicit coordinates for the six-point characteristic-two augmentation
  quotient by its constant line, the translation and inversion matrices in
  those coordinates, an explicit identification of the labels with the actual
  projective line `P¹(F5)` under which the permutations come from
  `(x,y) ↦ (x,x+y)` and `(x,y) ↦ (y,-x)`, and an invariant
  one-factorization identifying their
  generated action faithfully with the alternating group `A5`, simplicity of
  the induced heart, and the exact four-element quadratic matrix commutant of
  the entire generated heart action; a subspace of two heart copies is
  four-dimensional and stable under the diagonal action exactly when it is the
  vertical half or the graph of one of those four commutant endomorphisms, and
  the resulting packet has exactly five distinct members; an explicit
  equivalence with the actual `P¹(F4)` sends the marked vertical-plus-affine
  chart to the vertical half and the graphs of `0`, `1`, `W`, and `W+1`;
  the explicit alternating form on the two heart copies is nondegenerate, and
  the five packet members are exactly the diagonally stable maximal-isotropic
  subspaces; the chosen symplectic coordinates identify the rank-eight
  tensor-product discriminant with this two-heart model, preserve the form,
  and transport the exact packet classification;
  all six Sylow-five subgroups of that concrete `A5` are constructed, their
  conjugation action is exactly the original six-point action, and each
  ten-element normalizer is explicitly equivalent to the dihedral group `D5`,
  with an explicit equivalence from `P¹(F5)` to the Sylow-five packet.  The
  faithful natural `PSL₂(F5)` action is constructed, its order is proved to
  be `60`, explicit determinant-one matrices induce the displayed generators,
  and an explicit isomorphism `PSL₂(F5) ≃ A5` intertwines the full projective
  action with conjugation on the Sylow-five packet; every natural projective
  point stabilizer has order ten and is explicitly equivalent to `D5`, and
  both six-point actions are two-transitive,
  without identifying this packet with the manuscript's geometric `D5`
  subgroups and axes;
- the
  exact persistence of any continuously classified finite discrete packet on
  a connected base, including the explicit transported marked-root pair both
  in the affine `F4` chart and directly in the actual projective line,
  conditional on the geometric classifying map; nonfixity under projective
  Frobenius at one fibre already identifies the marked pair and propagates it;
- the fixed points for squaring Frobenius on the concrete four-element field
  and the exact nonfixed loci in both affine-chart coordinates and the actual
  projective line, given by the scalar graphs of the transported marked root
  and `root+1`, without identifying any geometric
  normalizer action with that field map;
- the manuscript's concrete trace-determinant form on `F4²`, its
  nondegeneracy, the nondegeneracy of the induced two-copy alternating form,
  and self-orthogonality of every scalar graph;
- trace rigidity for a determinant scalar and the transparent finite-field
  cardinality calculation `|SL₂(F4)| = 60`;
- the faithful action on the five natural projective points, triviality of the
  center in characteristic two, evenness of the projective image, and the
  resulting abstract exceptional isomorphism `SL₂(F4) ≃ A5`, without
  identifying the manuscript's geometric action with this abstract model;
- the order-120 full symmetric normalizer, its index-two alternating subgroup,
  and affine-chart Frobenius as an odd transposition in the nontrivial coset,
  without identifying it with a geometric normalizer;
- for a completed Novikov ring over a finite-degree effective monoid and a
  supplied multiplicative curve-class character, construction of the exact
  unital ring endomorphism multiplying the `Q^d` coefficient by that character;
  this proves preservation of completed convolution and models
  `Q^d ↦ exp(⟨a₂,d⟩)Q^d`, but does not construct the geometric pairing,
  exponential character, or divisor equation;
- over a commutative rational algebra, construction of the scalar formal
  exponential `exp(aX)` with coefficients `a^n/n!`; the scalar matrix gauges
  for `a` and `-a` are two-sided inverses and their conjugation fixes every
  formal-power-series matrix and its characteristic polynomial; no quantum
  string equation, inverse-loop-coordinate identification, or analytic
  single-valuedness statement is constructed;
- from a supplied commutative ring with a decreasing ideal filtration,
  construction of every quotient coefficient ring and canonical adjacent
  reduction; a supplied filtration-preserving endomorphism descends to
  compatible quotient endomorphisms, with their actions on classes and the
  reduction-substitution square proved; compatible families form a pointwise
  commutative ring, and the canonical ring homomorphism from the original ring
  is injective exactly when the intersection of the ideals is zero and
  bijective exactly when the filtration is also complete in the sense that
  every compatible family has a preimage; Lean does not prove these conditions
  for the supplied filtration; powers of any ideal separately give a
  decreasing adic filtration in which multiplication sends levels `m` and `n`
  into level `m+n`; a supplied ring endomorphism preserving the generating
  ideal preserves every adic level and descends compatibly to all quotients;
  when compatible small matrices and invertible gauges over those power-ideal
  quotients are supplied, the same construction yields the compatible
  bulk matrix and characteristic-polynomial packet;
  neither that ideal nor that endomorphism is identified with the manuscript's
  filtration or divisor substitution;
  more generally, a supplied normalized multiplicative ideal filtration keeps
  its `F^0` and product-inclusion laws while its quotient tower feeds the same
  finite-level matrix packet; Lean does not prove that the manuscript's
  filtration supplies this structure;
  if coefficientwise completeness and zero-intersection separatedness are also
  supplied, the canonical ring homomorphism to compatible quotient families
  is bijective in the same composite; these properties are not proved for the
  manuscript's coefficient ring;
  Lean does not identify the supplied filtration with this adic model, and
  identification with the manuscript's geometric coefficient quotients is
  not formalized;
- finite-matrix definitions and deductions for primitive-sixth multiplicity,
  coefficient extension, conjugacy, pro-Laurent inverse systems, and the actual
  subgroup of compatible general-linear families over any fixed Laurent
  coefficient tower, as well as formal base shift and block multiplicity
  formulas; for a constant matrix over a
  commutative rational algebra, the normalized exponential coefficients are
  constructed, proved to satisfy the formal flat recursion in every degree,
  assembled into an entrywise formal power-series matrix satisfying the exact
  constant-coefficient differential equation, with the negated-connection
  series proved to be its two-sided inverse,
  and proved compatible with arbitrary rational-algebra homomorphisms;
  for a supplied compatible system of constant connection matrices, every
  coefficient and the assembled formal series commute with adjacent
  coefficient reductions; the compatible negated-connection series are
  two-sided inverses, and the differential equation holds at each level,
  without claiming a varying quantum product or filtered analytic gauge;
  for an arbitrary one-variable matrix connection `A(t)` over a commutative
  rational algebra, Lean now constructs the unique normalized formal solution
  of `dG/dt=-A(t)G(t)`, proves its coefficient recursion and invertibility, and
  proves naturality under rational-algebra homomorphisms; for a supplied tower
  of compatible varying connection coefficients, every coefficient, the
  connection series, and the whole gauge series commute with adjacent
  reductions, while uniqueness and invertibility hold at every level; this
  tower remains abstract and is not identified with the manuscript's filtered
  quotient tower or quantum connection; from a supplied rational
  algebra, decreasing ideal filtration, and base connection coefficients,
  Lean also constructs the varying connection and gauge over every actual
  quotient `R/F^n`, proves canonical adjacent-reduction compatibility, and
  retains the equation, normalized uniqueness, and invertibility at every
  quotient level; the supplied filtration and connection are still not
  identified with the manuscript's geometric objects; for an arbitrary
  coordinate-indexed connection over ordinary Laurent-series coefficients,
  Lean proves that any two supplied normalized multivariable formal gauges
  satisfying all the same coordinate equations are equal by total-degree
  induction; the coefficientwise multivariate formal partial derivatives are
  proved to satisfy the Leibniz rule and commute, an invertible supplied
  solution is proved to force their exact zero-curvature identity, while
  symmetric mixed connection derivatives and pairwise commuting connection
  matrices are proved to imply that identity without a supplied solution; in
  the quantum-product interpretation these are the potentiality and
  commutative-associative product inputs, which remain supplied rather than geometrically
  constructed; conversely, zero curvature over any commutative rational algebra is proved to
  yield a recursively constructed unique normalized invertible multivariable
  formal gauge, naturally under every rational-algebra coefficient
  homomorphism; the same necessary result holds for arbitrary commuting
  derivations; from a supplied rational algebra, decreasing ideal filtration,
  base multivariable connection, and its zero-curvature proof, Lean maps the
  connection into every actual quotient `R/F^n`, constructs the unique
  normalized invertible gauge there, and proves canonical adjacent-reduction
  compatibility; every entrywise monomial coefficient is packaged as a
  compatible quotient family and identified with the family represented by
  its base-gauge coefficient; Lean does not identify that tower or its level connections
  with the manuscript's geometric objects; a further construction with
  ordinary Laurent-series bulk coefficients maps them into every actual
  quotient and produces compatible normalized invertible gauges whose
  finite-level coefficients have integral loop exponents and individual lower
  bounds; if a level gauge has finite bulk support, Lean proves one Laurent
  lower bound works for every matrix entry and bulk monomial at that level;
  for finitely many bulk coordinates, explicit coefficient vanishing at or
  above one total-degree cutoff is proved to supply that finite support and
  bound; separately, monomials in level-one parameters are proved to lie in
  their total-degree filtration levels and map to zero in every quotient by a
  filtration level not exceeding their total degree; the same holds for every
  coefficient-times-monomial term of a formal series, without defining an
  infinite evaluation sum; for a zero-curvature Laurent-valued connection and
  finitely many level-one parameters, Lean now constructs the normalized
  invertible formal gauge, defines its actual finite evaluation in one cutoff
  quotient, proves every omitted high-degree term zero, and obtains one common
  Laurent lower bound for the evaluated matrix; these finite evaluations
  arise from a ring homomorphism, are invertible, and commute with canonical
  adjacent quotient reductions together with chosen two-sided inverses, thus
  forming a pro-Laurent gauge system; every entrywise loop coefficient is
  packaged as a compatible quotient family.  The
  parameters and evaluated matrix are not identified with the manuscript bulk
  coordinates or gauge.  If coefficientwise completeness, separatedness, and
  uniform Laurent lower bounds for both gauges and inverses are additionally
  supplied, Lean lifts the compatible families to a two-sided-invertible
  Laurent matrix over the base ring whose reductions are the finite evaluations;
  it does not prove those bounds or identify this matrix geometrically;
- a positive-evaluated formal-base-shift composite now constructs the
  compatible quotient gauges and inverses from the zero-curvature Laurent
  connection and filtration-positive parameters, then derives the full bulk
  matrix and characteristic-polynomial packet from supplied compatible small
  monodromy matrices and divisor substitutions; their geometric, string, and
  divisor-equation origins remain unformalized;
- in a stronger filtered composite, one supplied filtration-preserving base
  endomorphism now induces every compatible Laurent quotient divisor
  substitution, so only the compatible small monodromy matrices remain as
  finite-level matrix inputs; the base endomorphism's geometric divisor origin
  remains unformalized;
- in the strongest base-data composite, one supplied Laurent small-monodromy
  matrix over the base ring is reduced coefficientwise to construct its entire
  compatible quotient family; its geometric monodromy origin remains
  unformalized;
- the exact projective-bundle and blowup multiplicity formulas from supplied
  geometric relations and characteristic-polynomial block comparisons, with
  every comparison-theorem input exposed;
- the conditional low-dimensional classification induction from nef seeds,
  points, projective bundles, and point blowups, followed by transfer to every
  strictly Novikov-admissible specialization; the geometric classification,
  operation formulas, divisor-tagging comparison, and nef spectral input are
  explicit premises;
- finite-fiber numerical Novikov coefficient pushforward on ordinary functions
  and on completed coefficient families with finite support below every degree
  cutoff, including the exact coefficient formula and additivity; no topology
  or topological continuity theorem is represented;
  agreement through a homological degree cutoff is proved to imply agreement
  through the corresponding numerical cutoff, the exact finite-level
  compatibility used by the unformalized topological continuity argument;
- finite and exact ordered additive decomposition sets for every class in a
  finite-degree effective monoid, and closure of completed coefficient families
  under the resulting convolution sum; the convolution, delta-function unit,
  and pointwise addition form a commutative ring and agree coefficientwise
  through every cutoff with multiplication of the corresponding
  additive-monoid-algebra truncations; for a
  surjective degree-compatible numerical quotient, finite-fiber pushforward is
  a unital ring homomorphism commuting exactly with all finite truncations;
- an explicit compatible finite-truncation family and mutually inverse
  reconstruction equivalence with completed coefficient families; this is a
  coefficientwise inverse-limit model, not a topology or categorical universal
  property;
- numerical pushforward on that compatible-family model, with every finite
  level exactly the ordinary `mapDomain` quotient map and an exact commuting
  square with completed pushforward;
- identity-modulus cutoff continuity for addition, convolution, and numerical
  pushforward, expressed as coefficient agreement through each degree cutoff;
  no topology or Mathlib `Continuous` theorem is asserted;
- flat coefficient extension over a field preserves the kernel of a supplied
  linear derivative and every supplied exact constants--derivative pair.  For
  an actual derivation of a commutative algebra, Lean constructs the induced
  derivation on the tensor-product algebra, proves the pure-tensor formula and
  Leibniz rule, proves that it fixes the coefficient algebra, and identifies
  its constant subalgebra with the image of the scalar-extended original
  kernel.  For a supplied finite-dimensional derivative and commuting
  monodromy endomorphism, Lean also constructs the canonical equivalence from
  the scalar-extended horizontal kernel to the kernel of the extended
  derivative, proves that it intertwines and conjugates the restricted
  monodromies, and maps their characteristic polynomial coefficientwise.  A
  supplied tower of coefficient algebras and adjacent algebra reductions gives
  an explicit compatible inverse system of these horizontal characteristic
  polynomials.  The adjacent coefficient reductions canonically map the
  scalar-extended horizontal kernels and intertwine their restricted
  monodromies.  For any supplied decreasing ideal filtration, every base
  coefficient tensor with an original horizontal vector now determines an
  explicit compatible family over all quotient levels; pure tensors map only
  their coefficient, and pointwise monodromy is inherited from the original
  restricted monodromy.  Without additional hypotheses this makes no
  injectivity or surjectivity claim.  If the source is finite dimensional and
  the supplied filtration is coefficientwise complete and has zero ideal
  intersection, the canonical base-tensor map is bijective: every compatible
  horizontal family has a unique base tensor.  This is not a topological or
  categorical inverse-limit theorem.  Lean also constructs the tower from the actual adic quotients
  `B/I^n` of a supplied coefficient algebra and ideal, with canonical adjacent
  quotient reductions.  The horizontal characteristic polynomial over `B`
  reduces exactly to the polynomial at every quotient level.  Every fixed
  polynomial coefficient is an explicit
  compatible quotient family represented by its corresponding base-ring
  coefficient.  Lean now also types a formal differential module and a
  conditional solution presentation containing a differential solution
  algebra, extended connection, framed horizontal identification, commuting
  continuation, and exact ground-field constants.  From those supplied data it
  constructs framed monodromy, proves coefficientwise characteristic-polynomial
  base change and gauge invariance, and, under explicit adic completeness and
  zero-intersection hypotheses, identifies framed horizontal tensors
  bijectively with compatible quotient-horizontal families.  The same
  polynomial identities hold at every quotient.  Lean does not identify `B` or
  `I` with the manuscript's coefficient data, prove its completeness or
  separatedness, or construct the manuscript's Levelt--Turrittin solution
  algebra, fundamental solution, continuation, inverse-limit differential
  module, or analytic framed-monodromy operator;
- derivation of a compatible characteristic-polynomial inverse system from
  entrywise compatible finite-level square matrices; the differential modules
  and analytic monodromy operators producing those matrices are not constructed;
- for a supplied matrix family over the same Laurent-series inverse system as a
  supplied pro-Laurent gauge, compatible levelwise conjugation and exact
  characteristic-polynomial invariance; Lean does not prove that the bulk
  differential equations produce either supplied family;
- for compatible coefficient rings at finite levels, small matrices, divisor
  substitutions, and two-sided-invertible gauges, derivation of compatible bulk
  matrices and the substituted characteristic-polynomial identity at every
  level, including compatibility of those bulk characteristic polynomials under
  reduction and their explicit packaging as a compatible polynomial system;
  the manuscript's complete separated filtered coefficient ring, its geometric
  identification, and the bulk flat equations producing the matrix and gauge
  inputs are not constructed;
- the same bulk-matrix and characteristic-polynomial packet with its coefficient
  rings, reductions, and substitutions constructed directly from a supplied
  commutative base ring, decreasing ideal filtration, and
  filtration-preserving endomorphism; the remaining supplied finite-level
  fields are compatible small matrices, gauges and inverse gauges, together
  with their entrywise compatibility and two-sided inverse proofs;
- finite coefficient packets constant on numerical fibers descend termwise,
  with each exact fiber sum equal to the descended coefficient times the fiber
  cardinality; this does not prove numerical invariance of Gromov--Witten
  coefficients or identify the abstract packet with them;
- additive-homomorphism packaging and the Leibniz rule for coefficientwise
  logarithmic Novikov operators defined by additive scalar weights, and
  compatibility of completed numerical pushforward with these operators
  whenever their weights factor through the quotient; scalar-linearity over a
  separately modeled coefficient subring, the geometric curve-pairing weights,
  and the quantum connection are not constructed;
- the algebraic core of strict Novikov admissibility and individual-class divisor-tag
  separation; for every finite injective family of divisor-pairing vectors
  over an infinite characteristic-zero field, a kernel-checked choice of one
  abstract separating `K`-linear functional and Vandermonde proof that the
  resulting formal exponential characters are linearly independent;
  for integral pairing vectors, a kernel-checked integral direction
  `(1,t,t²,...)` obtained by avoiding the finite root sets of all pairwise
  difference polynomials, matching the manuscript's integral one-parameter
  requirement, with character independence over every characteristic-zero
  coefficient field;
- the completed Novikov support condition at coefficient level: every nonzero
  series has a nonempty finite lowest-length support with exact membership;
  for an injective integral divisor-pairing vector, an integral direction
  separates that support and every assignment of nonzero leading coefficients
  gives a nonzero exponential-character combination; the associated-graded
  identification of a specialized initial form with this combination remains
  outside the theorem;
- the exact associated-graded tagging deduction from explicit initial-form data:
  a supplied additive tagged-image map, nonzero monomial initial coefficients,
  direction-dependent initial-form detectors, and their compatibility with
  the finite lowest-support combination imply nonvanishing on every nonzero
  completed series and full injectivity; the target filtration, associated
  graded ring, valuation, and geometric specialization are not represented,
  while detector/coefficient/compatibility proxy data are supplied;
- the conditional common-field endpoint of divisor-tagging vanishing from
  supplied final intrinsic, tagged, and specialized characteristic-polynomial
  equalities, without formal coefficient embeddings or a gauge witness;
- the separation of the rank-four Euler spectrum of a Hirzebruch surface by the
  discriminant of its characteristic polynomial: for a monic complex quartic,
  that the discriminant is the squared product of the six pairwise root
  differences and that a nonzero discriminant makes every maximal generalized
  eigenspace a line; the evaluation of the discriminant on the two displayed
  quartics; the two degeneracy criteria for nonzero specialized values, the
  surjectivity of the parametrization of the odd locus, and on each locus a
  factorization exhibiting root multiplicities two, one and one, carried to
  generalized eigenspaces of dimensions two, one and one and to a rank-two block
  whose nilpotent part squares to zero.  No variety, quantum cohomology, Novikov
  specialization or Euler multiplication is constructed; the quartics enter as
  displayed polynomials, and neither the deformation reduction nor the toric
  presentation is formalized;
- the algebraic core of strict Novikov admissibility used to exclude those
  degeneracy loci: that lengths are additive and scale, that units and negation
  leave a valuation unchanged, hence the two valuation exclusions for a positive
  shift, and separately that a combination of two members of a linearly
  independent family with coefficients `256` and `27` cannot vanish, which is
  what a graded-monomial specialization supplies at equal valuations.  That the
  center specializations are graded-monomial is argued in the manuscript only:
  the package builds no associated graded ring, so `lem:center-maps-monomial`
  is recorded as absent from Lean;
- the assembled specialized vanishing statements for the rational geometrically
  ruled centers, the quadric surface through the product route and the two
  parities through the discriminant route, with the Gromov--Witten product
  formula, the tensor compatibility of the formal decomposition, and the
  conclusion of the multiplicity-one Euler block lemma as typed premises;
- typed blowup/blowdown telescoping for the common natural-valued marker ledger,
  together with the conditional framed cubic and genus-eight deductions;
- the two low-dimensional exclusions used by the direct rank-two residue fold,
  where the point-blowup formula, the passage to a minimal model, the
  nef-canonical lemma, the classification of minimal surfaces, and the parity
  ranks of a curve atom are separate premises: a variety of dimension at most
  one carrying the selected cubic block would have genus five, no such variety
  carries it, and no variety of dimension at most two does either;
- the unconditional genus-eight route, which uses no framed multiplicity: since
  each rank-two projectivization is birational to the product of its base with a
  projective line, the flop makes one projective-line stabilization of the Fano
  threefold birational to one projective-line stabilization of its associated
  Pfaffian cubic, and irrationality transports back from the cubic, where the
  direct categorical QDM marker supplies it;
- the exact fibrewise deduction from supplied primitive-minimal-class
  algebraicity and Voisin's supplied equivalence to universal `CH₀`-triviality;
- the final conditional separation-family composition, including fibre and
  stabilization `CH₀`-triviality, stabilization irrationality, and supplied
  family non-isotriviality;
- an opaque organizational relative-six-axis signature, with the full
  five-axis integral Smith witness and the coefficient-module part of the
  two-primary discriminant independently discharged by Lean: after tensoring
  with any `F₂`-module `T`, the kernel is linearly equivalent to four copies of `T`, hence
  has order `2⁸` for a two-dimensional factor, and its scalar coordinates
  agree with `Aug(F₂⁶)/⟨1⟩`; the induced coefficient form is bilinear,
  alternating, nondegenerate, and preserved by the full generated six-point
  action; after choosing a symplectic basis of the two-dimensional factor,
  the induced rank-eight tensor-product form is also alternating and
  nondegenerate, every isotropic four-dimensional subspace is maximal, and
  the five projective-line packet members are exactly its diagonally stable
  maximal-isotropic subspaces under the explicit two-heart equivalence.  The
  parallel characteristic-three heart is also explicit: Lean identifies
  `H₃` with `Aug(F₃⁶)/⟨1⟩`, proves that its normalized symmetric form is
  the descended minus-dot-product form, proves that the quotient chart
  intertwines the induced translation and inversion actions, and proves that
  both the symmetric form and the induced alternating nondegenerate
  rank-eight tensor form are generator-invariant; its
  four diagonally stable halves are exactly the vertical copy and the three
  scalar graphs, and all four are maximal isotropic.  Separately, on the
  two-primary side, from a supplied
  fibrewise coordinate realization whose image is exactly the
  geometric kernel, Lean constructs a kernel-to-subspace equivalence and
  proves membership in that five-member packet; independently, every concrete
  ten-element dihedral axis stabilizer has a one-dimensional fixed line in the
  rational six-label augmentation representation, explicitly generated by
  the vector with axis coordinate `5` and all other coordinates `-1`; the sum
  `N` of the ten stabilizer operators has exactly this line as its range,
  satisfies `N² = 10N`, and yields an idempotent projector after division by
  ten; each stabilizer is self-normalizing, and any object fixed by a source
  stabilizer has the same transported image under all group elements carrying
  that source label to a fixed target label; the six rational axis vectors
  sum to zero, and their synthesis map has kernel exactly the constant line,
  is onto the augmentation module, induces the corresponding quotient linear
  equivalence, and intertwines the concrete alternating-group actions;
  integrally, subtracting the sixth coordinate identifies `ℤ⁶/ℤ1` with
  `ℤ⁵`, the symmetric `6I₆-J₆` form descends through the constant line,
  its matrix in this quotient chart is exactly `6I₅-J₅`, and the induced
  full permutation action preserves the descended form;
- the conditional cubic packet formula: from the shared four-block reduction
  derived in the manuscript from Beauville's quantum products, the two
  primitive-sixth roots have multiplicity one each and the unit blocks
  contribute zero, giving multiplicity two; Lean checks the matrix reduction
  but does not derive its QDM input;
- simplicity of both six-point hearts under the generated label action,
  together with the exact matrix commutant of that action: the four-element
  algebra generated by a root of `W ^ 2 + W + 1` in characteristic two, in
  which the two nonidentity nonzero elements are inverse to each other, and the
  scalar matrices alone in characteristic three;
- the two product-formula corollaries, conditional on the manuscript's
  unconditional product formula for a product with a projective space: every
  projective space has vanishing primitive-sixth multiplicity, and a smooth
  cubic threefold has multiplicity four after one product stabilization by a
  projective line, with the value two for the cubic threefold itself taken from
  the block reduction rather than assumed;
- the framed-monodromy route to one-step irrationality assembled on that
  signature, in which the count of the cubic threefold, its doubling under
  multiplication by a projective line, and the vanishing of the count on
  projective four-space are proved rather than assumed, leaving the product
  formula, the point comparison, the exponent-to-monodromy passage, the
  birational input, the dimension bound, and the birational comparison supplied
  by rationality as its premises;
- the rank-two algebra of the direct residue marker: from self-adjointness of the
  square-zero leading operator for an invertible pairing coefficient and the
  constant coefficient of horizontality, the regular coefficient preserves the
  nilpotent line; the residual pole of the base connection in the modified
  lattice vanishes when the upper-right residue entry is invertible; an
  entrywise additive Leibniz map carrying the residue to a commutator
  annihilates the residue discriminant, so that invariant is constant along the
  base; and the discriminant is the squared separation of the residue
  eigenvalues and is insensitive to a scalar shift;
- block diagonality of a horizontal pairing on two spectral factors whose
  leading eigenvalues are distinct: the Sylvester equation at the leading order
  has only the zero solution, the induction over later orders kills every
  off-diagonal coefficient, and a pairing with vanishing off-diagonal blocks is
  invertible exactly when both diagonal restrictions are;
- block diagonality of a horizontal pairing for an arbitrary splitting, given
  by a label on a finite type of coordinates, whose leading eigenvalues are
  pairwise distinct and whose connection is block diagonal in the chosen frame:
  the block of the horizontality identity between two labels is the two-factor
  identity of the corresponding blocks, so every coefficient of the pairing
  vanishes on every entry whose row and column carry different labels;
- nondegeneracy of the restriction of such a pairing to the coordinates of one
  factor, and, when the pairing also vanishes between coordinates of different
  parity, to the coordinates of one factor and even parity: a nonzero kernel
  vector of a restriction extends by zero to a nonzero kernel vector of the
  whole pairing, and reindexing along a bijection with a finite ordinal
  preserves nonvanishing of the determinant;
- invariance of the residue discriminant under a change of frame and a scalar
  recentering of the residue, since conjugation preserves the trace and the
  determinant;
- the same invariance for one factor of a labelled splitting under a change of
  frame that is block diagonal for the splitting, whose diagonal blocks are
  again mutually inverse and conjugate the factor's block;
- constancy of the residue discriminant over a formal germ of the base: if each
  formal partial derivative of the residue is its commutator with a regular
  matrix, then every formal partial derivative of the residue discriminant
  vanishes and the residue discriminant is the constant series with its own
  constant coefficient.  The derivation calculus this uses, additivity and the
  Leibniz rule for the coefficientwise formal partial derivative of a
  multivariate formal power series, is proved alongside it;
- the order-by-order content of horizontality for a sesquilinear pairing whose
  right argument is evaluated at the negated loop coordinate.  For a connection
  with a simple pole, the coefficient of the inverse loop coordinate is exactly
  self-adjointness of the residue for the leading pairing coefficient, and the
  constant coefficient is the four-term relation between the regular
  coefficient, the first two pairing coefficients, and the residue; those two
  give the rank-two nilpotent-line preservation directly from horizontality.
  Between two factors with separated leading eigenvalues, each order is that
  Sylvester equation with a remainder built from strictly earlier coefficients,
  so the whole pairing between them vanishes.  A pairing that is constant in the
  frame is horizontal whenever the residue is self-adjoint and the regular part
  is an anti-self-adjoint operator in degree zero, which is the substitution
  behind horizontality of the Poincare pairing for the quantum connection;
- the arithmetic excluding a faithful action of the symmetric group on six
  letters on a classified automorphism group: its order is `720`, a group
  receiving an injective homomorphism from it has order divisible by `720`, and
  no group of smaller order and no group of order `9720` qualifies.

The authoritative per-claim account is
[`verification/claims.json`](verification/claims.json).  In particular, the
companion formalizes the relative six-axis source only through its integral
first homology: the degree and injectivity of a comparison matrix satisfying the
polarization pullback identity, and the two-primary discriminant identification
in supplied two-torsion coordinates, are proved, while the elliptic scheme, the
relative morphism inducing those matrices, the Weil and commutator pairings, and
maximal isotropy of the actual isogeny kernel are supplied.  It does not
formalize the identification
of the explicitly constructed quadratic finite-etale splitting field and
eigenbasis with the manuscript's marked geometric splitting extension, or the
construction of its geometric coefficient lattice, or the geometric
cohomology realization and isogeny pullback, the geometric inputs to the
universal `CH_0` argument,
quantum comparison theorems, the geometric and comparison inputs to
low-dimensional vanishing, or Cai's geometric block diagonalization and its
identification with the framed-monodromy polynomial, including the rank-one
numerical-curve-lattice comparison.

From this package directory, build the pinned Lean library with:

```text
lake build CubicStabilizationM1
```

The source-only correspondence check is

```text
nix shell nixpkgs#python3 --command python3 \
  verification/check_formal_artifact.py --source-only
```

It requires one claim-map row for every theorem-like manuscript environment,
an exact partition of the reviewer terminals among those rows and the machinery
bucket, a stated reason for every machinery declaration, and an exact
expected-axiom row for every terminal.  After the guarded build of the axiom
audit, pass its captured standard output back to the same checker:

```text
nix shell nixpkgs#python3 --command python3 \
  verification/check_formal_artifact.py --axiom-log AXIOM_AUDIT_STDOUT
```

The second mode parses the kernel-reported dependencies and rejects any
difference from `verification/expected_axioms.txt`.  A source-only pass does
not claim that Lean was built or that the observed axiom output was checked.
