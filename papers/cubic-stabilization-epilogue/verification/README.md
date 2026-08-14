# Verification boundary

The manuscript is intended to have a wholly human proof spine.  No certificate,
enumeration, or symbolic program is invoked as a premise.

`make check` performs the source-only Lean correspondence check, deterministic
PDF construction, and warning rejection.  The
correspondence check inventories every theorem-like manuscript environment and
records whether its current Lean coverage is absent, fragmentary, a conditional
deduction, or complete.  It does not build Lean.

At the current interim checkpoint the exact inventory is 23 manuscript claims,
with 0 absent, 13 fragmentary, 9 conditional deductions, and 1 complete.
There are 162 reviewer-facing Lean terminals.  These counts summarize the
current checked map; any change to manuscript labels, claim-map declarations,
public terminals, axiom-audit commands, or expected axiom rows must preserve
their exact correspondence.

Checked coverage snapshot: 23 claims; 0 absent; 13 fragmentary; 9 conditional;
1 complete; 162 reviewer terminals.

The Lean modules and axiom audit can be built with the pinned package command
documented in `lean/README.md`.  Passing the captured audit output to
`make formal-audit` checks every reviewer terminal against the tracked exact
axiom list.  Neither a source-only pass nor a successful build substitutes for
that transcript check.

The research calculations that led to the integral gluing and divisor-product
statements are discovery evidence rather than premises.  Formal coverage of
those statements requires kernel-checked structural proofs matching the
objects, hypotheses, conclusions, and cautions recorded in
`lean/verification/claims.json`.

## Remaining formalization checklist

- Construct the marked finite-etale graph presentation from the geometric
  quotient and identify geometric divisor descent with entrywise integrality
  of its graph-coordinate product.  From supplied split blocks onward, Lean
  now proves the exact flattened coefficient lattice and its rank-one
  generation (`lem:graph-coefficient-lattice`).
- Identify the six labels in the formal characteristic-two augmentation
  quotient with the manuscript's six conjugate `D5` subgroups.  Lean now
  proves that the two displayed permutations preserve a one-factorization,
  faithfully generate the alternating group `A5`, act simply on the heart,
  and the entire generated heart action has exactly the quadratic four-element
  matrix commutant.  It also proves that a subspace of two heart copies is
  four-dimensional and diagonally stable exactly when it is the vertical half
  or a graph of one of those four commutant endomorphisms; the resulting packet
  has exactly five distinct members.  An explicit equivalence with the actual
  `P¹(F4)` identifies its vertical-plus-affine chart with the vertical half and
  the four graphs.  The explicit alternating polarization on the two heart
  copies is nondegenerate, and those five halves are exactly the diagonally
  stable maximal-isotropic subspaces.  The chosen symplectic coordinates
  identify the rank-eight tensor-product discriminant with the two-heart
  model, preserve the form, and transport that exact classification.  It identifies
  the six labels with the actual `P¹(F5)`, where the permutations are induced
  by `(x,y) ↦ (x,x+y)` and `(x,y) ↦ (y,-x)`.  It also
  constructs all six Sylow-five subgroups, proves their conjugation action is
  the same six-point action, and identifies every ten-element normalizer with
  the dihedral group `D5`; the actual `P¹(F5)` is explicitly equivalent to
  that Sylow-five packet.  Lean also constructs the faithful natural
  `PSL₂(F5)` action, proves its order is `60`, realizes the two displayed
  generators by determinant-one matrices, and constructs an action-compatible
  isomorphism `PSL₂(F5) ≃ A5`; each natural projective point stabilizer has
  order ten and is explicitly equivalent to `D5`, and both six-point actions
  are two-transitive.  Identification of those concrete subgroups,
  action, normalizers, and heart with the geometric ones remains open
  (`prop:principal-gluing-packet`).
- Identify the explicitly constructed quadratic finite-etale splitting field
  and eigenbasis of the residue model with the manuscript's marked geometric
  splitting extension, and prove that scalar extension of the geometric graph
  lattice is the formal weighted lattice.
  The abstract coefficient extension, extended rank-one assembly,
  ordinary-product base-change containment, and faithfully-flat reflection
  are now formalized (`thm:all-degree-graph-saturation`).
- Construct the actual cohomology realizations and the isogeny pullback, prove
  its required injectivity on the torsion-free integral lattice, and match the
  geometric graph classes with the canonical elliptic-source exterior model
  (`thm:all-degree-graph-saturation`).
- Identify the actual six-axis kernel with the now-formalized explicit
  quadratic and scalar residue-field slope models, and prove persistence over
  each connected smooth component (`lem:six-axis-local-chart`).  Lean now
  identifies the marked Frobenius pair directly as two scalar graphs on the
  actual projective line over `F4` and proves the connectedness deduction for
  any supplied continuous classifier into that projective line.  Nonfixity at
  one fibre suffices to identify and propagate the exact marked pair;
  constructing the geometric kernel packet and classifier remains open.
- Supply the away-from-six comparison and local-to-global integral membership
  that specializes the graph theorem to `Theta^4/4!`
  (`thm:six-axis-divided-powers`).
- Formalize the cited Voisin criterion and its application to every smooth
  fibre (`cor:universal-ch0`), then the remaining relative-family geometry in
  `lem:relative-six-axis`.  Lean now proves its full integral Smith witness and
  the coefficient-module identity behind `D₂ ≃ H₂ ⊗ E[2]`, including the
  order `2⁸` calculation and the invariant nondegenerate alternating
  coefficient form, together with the standard rank-eight tensor-product
  symplectic model, its half-dimensional maximal-isotropy criterion, and the
  exact five-member diagonally stable maximal-isotropic packet under the
  explicit two-heart equivalence.  A separate conditional bridge proves that
  supplied fibre coordinates identifying the actual kernel image with one of
  these stable maximal-isotropic subspaces give a kernel-to-subspace
  equivalence and membership in the five-member packet.  Lean also proves
  that every concrete ten-element dihedral axis stabilizer has the explicit
  one-dimensional fixed line in the rational augmentation representation and
  that the sum `N` of its ten action operators has this line as its range and
  satisfies `N² = 10N`.  This coordinate norm is not identified with a norm
  endomorphism of an elliptic scheme; the torsion local system, symplectic
  pairing, relative isogeny, and geometric maximal-isotropic kernel remain
  unconstructed.
- Formalize the remaining quantum inputs: the separation family, construct the
  filtered target/associated graded and prove the now-explicit compatibility
  identifying the initial form of a geometric specialized series with its
  finite lowest-support exponential combination in divisor tagging, the
  source/common coefficient fields and embeddings for the comparison maps,
  multiplicative filtration laws and identification of the now-constructed
  abstract ideal quotients with the actual geometric finite-level coefficient
  quotients, construction of the small and bulk
  monodromy matrices, divisor substitutions, and the manuscript's
  multivariable Laurent integral-`z` gauge from the string/divisor/bulk flat
  equations.  The linear differential-constant calculation under flat
  coefficient extension is proved.  For an actual derivation of a commutative
  algebra, Lean constructs the extended derivation, proves its Leibniz rule and
  coefficient-algebra constancy, and identifies its constant subalgebra with
  the image of the scalar-extended original kernel.  For a supplied
  finite-dimensional derivative and commuting monodromy endomorphism, Lean
  identifies the scalar-extended horizontal kernel with the kernel of the
  extended derivative, proves that the restricted monodromies are intertwined
  and conjugate, and maps their characteristic polynomial coefficientwise.  A
  supplied tower of coefficient algebras and adjacent reductions yields an
  explicit compatible inverse system of these horizontal characteristic
  polynomials.  The adjacent reductions also induce canonical maps between the
  scalar-extended horizontal kernels and intertwine their restricted
  monodromies.  For a supplied decreasing ideal filtration, every base
  coefficient tensor with an original horizontal vector determines an explicit
  compatible family over the quotient tower; pure tensors map only their
  coefficient, and pointwise monodromy comes from the original restricted
  monodromy.  Without additional hypotheses, no injectivity or surjectivity is
  claimed.  For a finite-dimensional source and a filtration that is complete
  in the explicit compatible-quotient-family sense and has zero ideal
  intersection, the canonical map is bijective: every compatible horizontal
  family is represented by a unique base tensor.  This is a coefficientwise
  inverse-family theorem, not a topological or categorical inverse-limit
  statement.  Lean also constructs the tower from the actual adic quotients
  `B/I^n` of a supplied coefficient algebra and ideal and proves compatibility
  under the canonical reductions.  The horizontal characteristic polynomial
  over `B` reduces exactly to the polynomial at every quotient level.  Each
  fixed polynomial coefficient is
  packaged as the compatible quotient family represented by its corresponding
  base-ring coefficient.  Lean also represents a formal differential module
  and a conditional solution presentation with a differential solution
  algebra, extended connection, framed horizontal identification, commuting
  continuation, and exact ground-field constants.  From these supplied data it
  derives framed-monodromy coefficient base change and gauge invariance and,
  under explicit adic completeness and zero-intersection premises, a bijection
  between framed horizontal tensors and compatible quotient-horizontal
  families.  Identification of `B` and `I` with the manuscript's coefficient
  data, proof that the manuscript filtration has the stated completeness and
  separatedness properties, and construction of the manuscript's
  Levelt--Turrittin solution algebra, fundamental solution, continuation,
  analytic monodromy, and inverse-limit differential module remain open.  Lean
  proves the coefficientwise
  multivariate partial derivatives are commuting derivations, derives their
  necessary zero-curvature identity from an invertible supplied solution, and
  conversely constructs the unique
  normalized invertible multivariable formal gauge from zero curvature over any
  commutative rational algebra, naturally under rational-algebra coefficient
  homomorphisms.  It also proves the necessary result for
  arbitrary commuting derivations.  From a supplied rational algebra,
  decreasing ideal filtration, base multivariable connection, and exact
  zero-curvature proof, Lean constructs the actual quotient-level connections
  and normalized invertible gauges and proves adjacent-reduction compatibility.
  Each entrywise monomial gauge coefficient is also packaged as an explicit
  compatible quotient family and identified with the compatible family
  represented by its corresponding base-gauge coefficient.
  A Laurent-coefficient specialization constructs the same system over
  `LaurentSeries (R/F^n)` at every level.  Thus each finite-level bulk
  coefficient has integral loop exponents and its own Laurent lower bound;
  finite bulk support at one level is proved to give a single lower bound for
  the entire matrix-valued bulk series.  With finitely many coordinates,
  explicit vanishing at or above one total-degree cutoff is proved to imply
  finite bulk support.  Monomials in supplied level-one parameters are proved
  to lie in the corresponding total-degree filtration level and map to zero
  in every quotient by a filtration level not exceeding their total degree.
  The same coefficientwise conclusion holds after multiplying each formal
  series coefficient by its parameter monomial; no infinite evaluation sum is
  defined.  For a zero-curvature Laurent-valued connection with finitely many
  such parameters, Lean additionally constructs its normalized invertible
  formal gauge and an actual finite evaluation at one quotient cutoff, proves
  all higher terms vanish there, and bounds every entry of the finite evaluated
  matrix by one Laurent order.  These finite evaluations commute with canonical
  adjacent quotient reductions.  Evaluation is a ring homomorphism, so the
  matrices are invertible; compatible chosen two-sided inverses package them as
  a pro-Laurent gauge system.  Every entrywise loop coefficient is also packaged
  as an explicit compatible quotient family.
  Lean does not identify those parameters with manuscript bulk coordinates or
  the finite evaluated matrix with the manuscript gauge.  Given the separately
  supplied coefficientwise completeness, separatedness, and uniform Laurent
  lower bounds for both gauges and inverses, Lean does assemble a two-sided-
  invertible Laurent matrix over the base ring whose reductions are the finite
  evaluations; it does not derive those bounds or identify the matrix with the
  manuscript's gauge.
  Separately, a supplied multiplicative character of effective curve classes
  now acts on the completed Novikov ring by the exact unital endomorphism
  multiplying each `Q^d` coefficient by its character value; Lean proves
  preservation of completed convolution.  The geometric pairing, exponential
  character, and divisor equation remain supplied or unconstructed.
  Lean also constructs `exp(aX)` over a commutative rational algebra and proves
  that its scalar matrix gauge has the opposite exponential as two-sided
  inverse, acts trivially by conjugation, and preserves every characteristic
  polynomial.  The quantum string equation, inverse-loop-coordinate
  interpretation, and analytic single-valuedness are not represented.
  A further composite now inserts these constructed compatible evaluated
  gauges and inverses into the formal-base-shift matrix packet.  With compatible
  small monodromy matrices and divisor substitutions supplied, Lean derives the
  compatible bulk matrices and their substituted characteristic-polynomial
  system.  The small monodromy/divisor data and their geometric equations are
  not constructed.
  In the stronger filtered version, one supplied filtration-preserving base
  endomorphism induces every compatible Laurent quotient divisor substitution;
  only compatible small monodromy matrices remain as finite-level matrix data.
  The endomorphism's geometric divisor-equation origin is not proved.
  In the strongest base-data version, one supplied Laurent small-monodromy
  matrix over the base ring is reduced coefficientwise to construct its whole
  compatible quotient family.  Its geometric monodromy origin is not proved.
  Their identification with the manuscript's geometric tower and quantum
  connection is not formalized; neither finite bulk support from the
  manuscript's positive filtration nor either required Laurent lower bound
  uniform across quotient levels is proved.
  The ordinary one-variable varying
  formal solution, its compatible
  abstract coefficient tower, and its realization over every quotient of an
  arbitrary supplied ideal filtration are formalized, but that filtration and
  connection are not identified with the manuscript's geometric quotients or
  quantum connection.  Also remaining
  are topological continuity
  and a categorical/topological universal property for the now-explicit
  coefficientwise inverse-limit presentation of numerical completion, and the
  geometric numerical base-change comparison, numerical invariance and
  Gromov--Witten identification of coefficient packets, construction of the
  geometric additive logarithmic weights and quantum connection, strict
  Novikov operations, cubic packet comparison, and the geometric/connection
  inputs that restrict monodromy eigenvalues to `{1,-1}` in dimensions at
  most two.  The exact terminal spectral vanishing implication is now
  formalized; matrix involutivity is recorded only as a stronger sufficient
  special case.  The
  headline deductions remain explicitly conditional until
  those premises are proved (`thm:every-cubic`,
  `thm:nu6-birational-invariance`, and `cor:v14-one-step`).
