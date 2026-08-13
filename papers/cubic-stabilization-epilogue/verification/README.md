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
There are 138 reviewer-facing Lean terminals.  These counts summarize the
current checked map; any change to manuscript labels, claim-map declarations,
public terminals, axiom-audit commands, or expected axiom rows must preserve
their exact correspondence.

Checked coverage snapshot: 23 claims; 0 absent; 13 fragmentary; 9 conditional;
1 complete; 138 reviewer terminals.

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
- Construct the actual unramified splitting ring and prove that its scalar
  extension of the geometric graph lattice is the formal weighted lattice.
  The abstract coefficient extension, extended rank-one assembly,
  ordinary-product base-change containment, and faithfully-flat reflection
  are now formalized (`thm:all-degree-graph-saturation`).
- Construct the actual cohomology realizations and the isogeny pullback, prove
  its required injectivity on the torsion-free integral lattice, and match the
  geometric graph classes with the canonical elliptic-source exterior model
  (`thm:all-degree-graph-saturation`).
- Identify the actual six-axis kernel with the now-formalized explicit
  quadratic and scalar residue-field slope models, and prove persistence over
  each connected smooth component (`lem:six-axis-local-chart`).
- Supply the away-from-six comparison and local-to-global integral membership
  that specializes the graph theorem to `Theta^4/4!`
  (`thm:six-axis-divided-powers`).
- Formalize the cited Voisin criterion and its application to every smooth
  fibre (`cor:universal-ch0`), then the relative family statement
  (`lem:relative-six-axis`, currently fragmentary).
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
  equations.  Lean proves the coefficientwise multivariate partial derivatives
  are commuting derivations, derives their necessary zero-curvature identity
  from an invertible supplied solution, and conversely constructs the unique
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
