# Verification boundary

This registry and the bundled Lean package cover the primary paper and both
companion manuscripts in this repository.

The proof spines are structural apart from the computations in
`evidence.json`, which are the only places a symbolic program is invoked as a
premise.  None of them is certificate-checked; each is a trusted execution,
cross-checked as its registry entry records.  Exactly one statement now invokes
one as a premise: `lem:hirzebruch-euler-spectrum`, in the conditional framed
refinement.

The pencil's Eckardt locus used to be a second such place.  It no longer is.
`prop:A5-not-coprime` is proved from `lem:eckardt-involution` and
`prop:eckardt-reflection-group`: an Eckardt point is a reflection fixing the
defining form, the reflections generate an irreducible complex reflection
group of rank five, and three occurs among the invariant degrees of only two
such groups, one of which gives the singular Segre cubic threefold and the
other the Fermat cubic threefold.  The count of two members is a cohomological
count of complements inside the Fermat automorphism group.  Both statements
`prop:A5-nonseparated` and `thm:separation-family`, which inherit from
`prop:A5-not-coprime`, are therefore free of the elimination as well.  The two
Groebner bundles that determined the locus remain tracked and are now attached
to `lem:pencil-loci-coordinates`, which records the members' coordinates on the
parameter line and which no other statement uses.

Nothing on the unconditional rank-two residue route rests on any evidence
bundle, so the
irrationality theorem `thm:every-cubic` does not.  The conditional framed
route's second proof of one-step irrationality does, through
`lem:hirzebruch-euler-spectrum`.

Statements resting on a bundle are marked by `\evidence` in the source.  That
macro is typographically empty, so a reader of the rendered paper sees the
boundary in the prose of the proof that names the trust level rather than at
the annotation.  This enumeration is a reading of the printed proofs, not a
fact read off `dependency-graph.dot`: as recorded below, edges are filled for
the categorical marker route and the one-stabilization theorem only, and a statement
carrying no edge has none recorded rather than none.

`make check` performs the source-only Lean correspondence check, deterministic
PDF construction, and warning rejection.  The
correspondence check inventories every theorem-like manuscript environment and
records whether its current Lean coverage is absent, fragmentary, a conditional
deduction, or complete.  It does not build Lean.

The snapshot below is the exact current inventory; any change to manuscript
labels, claim-map declarations, public terminals, axiom-audit commands, or
expected axiom rows must preserve their exact correspondence.

The correspondence is recorded twice, and the check requires the two records to
agree.  Every theorem-like environment in the manuscript carries two
typographically empty annotations, defined in `formal-annotations.tex`:
`\coverage`, whose argument is the strength at which the statement is
formalized, and `\lean`, whose argument names the reviewer terminals carrying
it.  The per-claim record in `lean/verification/claims.json` repeats those two
fields and adds the objects, hypotheses, conclusion, and limitations of the
formal statement.  The checker reads the annotations out of the manuscript
source and rejects any disagreement with the claim map, so a statement cannot be
rewritten, retitled, or re-proved while its recorded coverage silently continues
to describe the previous version.  `\lean` follows the convention of the Lean
blueprint system of P. Massot; `\coverage` replaces that system's two-valued
formalization flag, because a statement here may also be represented by a
strictly weaker fragment or by a conditional deduction whose external premises
are exposed in the theorem type.

Three further annotations record the rest of a statement's provenance, and take
identifiers only.  `\uses` names the statements a result depends on, inside the
statement body for a conceptual dependency and inside a proof for a logical one.
`\imports` names the external results it uses, resolved in
`verification/imported-sources.json`; each entry there records the bibliography
key, the pinpoint, the form in which the result is used, and the conventions of
framing, coordinates, and normalization that must be matched for the use to be
valid, together with how this manuscript matches each one.  `\evidence` names
the computational evidence bundles a statement rests on, resolved in
`verification/evidence.json`; each entry there records the bundle's role, its
tracked checksum manifest, and the commands that replay it.  Two statements
carry one: `lem:hirzebruch-euler-spectrum`, whose premise is a symbolic
computation, and `lem:pencil-loci-coordinates`, whose exact elimination nothing
else depends on.  The checker
resolves every annotated identifier and rejects an unknown one, a bibliography
key absent from the manuscript, an imported source with no recorded conventions,
and an evidence bundle with no checksum manifest or no replay command.

A proof is paired with the statement it follows, so `\uses` inside it records a
logical dependency of that statement.  A proof separated from its statement
carries `\proves` naming the statement it establishes; the proof of the
one-stabilization theorem, which appears at the end of the atomic section while
its statement is in the introduction, is paired that way.  Annotations inside a
proof are written at its end rather than after its opening, because the run-in
proof header ends by skipping following spaces and a macro placed there stops
that skip, which perturbs the typeset output; placed at the end they leave the
built document unchanged, which the deterministic rebuild confirms.

Each claim-map row also pins the two things it describes, by digest.  One digest
covers the manuscript statement, taken with its annotations removed and its
layout normalized, so that rewriting the mathematics of a statement fails the
check until the row describing its formal coverage has been re-examined.  The
other covers normalized source declaration signatures of the terminals the row
registers, excluding their docstrings, so that changing a terminal's declared
type has the same effect while improving how it is documented does not.
Source-only checking does not establish that a declaration elaborates.
Machinery terminals carry
the second digest as well, since the reason recorded for one describes what it
states.  After re-examining a row, record its current digests with

```text
python3 lean/verification/refresh_claim_digests.py LABEL
```

The digests cover the theorem-like environments and the terminals, not the prose
between statements.  Where a manuscript derivation runs in the text between two
environments, as parts of the atomic argument do, a change there is caught by
neither digest; the dependency edges recorded in the proofs are what make such a
derivation visible at all.

`verification/dependency-graph.dot` renders the resulting graph: statements
coloured by the strength at which they are formalized, imported sources and
evidence bundles as separate nodes, and edges dashed for a conceptual
dependency, solid for a logical one, and dotted for an import.  It is generated
by `verification/dependency_graph.py`, deterministically and with no timestamp
or path in its output, by

```text
python3 verification/dependency_graph.py verification/dependency-graph.dot
```

and the correspondence check regenerates it and rejects a stale copy, so the
graph cannot fall behind the annotations.  Dependency edges and imported-source
annotations are authored, not harvested from cross-references, so they are
recorded where they have been authored and nowhere else: densely in the
primary paper's QDM-marker section and more sparsely in its introduction and
applications, the six-axis companion, and the framed-monodromy companion.  A
statement carrying no edge has none
recorded rather than none used, and the same holds of an imported source.

The claim inventory declares the public `PaperInterface` aggregate, three
manuscript-specific entries—`PaperInterface.Main`,
`PaperInterface.SixAxisCubicPencil`, and
`PaperInterface.CubicFramedMonodromy`—and the semantic reviewer facades below
them.  The checker resolves every declared module inside the package, requires
the aggregate to import each one, and computes terminal and signature coverage
across their union.  This keeps the manuscript split visible without weakening
the exact terminal census.

Checked coverage snapshot: 57 claims; 4 absent; 25 fragmentary; 27 conditional;
1 complete; 318 reviewer terminals, of which 83 are machinery serving no current
manuscript claim.

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
  constructing the geometric kernel packet and classifier remains open.  The
  depth-one self-adjoint lift and the triviality of the principal quotient on
  the unimodular summand are formalized as stated, the second through the
  integral Smith reduction of `6I-J`; surjectivity of `Sp_2(Z_3)` onto
  `Sp_2(F_3)`, used to lift a complementary symplectic ruling at three, is not.
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
  explicit two-heart equivalence.  The characteristic-three coefficient
  model is now likewise explicit:
  `H₃ = Aug(F₃⁶)/⟨1⟩`, its normalized symmetric form is minus the dot
  product descended through the constant line, the quotient chart
  intertwines the induced generators, both the symmetric form and induced
  alternating nondegenerate rank-eight tensor form are generator-invariant,
  and its four diagonally stable halves are exactly the
  vertical copy and three scalar graphs, all maximal isotropic.  Separately,
  on the two-primary side, a conditional bridge proves that
  supplied fibre coordinates identifying the actual kernel image with one of
  these stable maximal-isotropic subspaces give a kernel-to-subspace
  equivalence and membership in the five-member packet.  Lean also proves
  that every concrete ten-element dihedral axis stabilizer has the explicit
  one-dimensional fixed line in the rational augmentation representation and
  that the sum `N` of its ten action operators has this line as its range and
  satisfies `N² = 10N`.  Each stabilizer is self-normalizing, and Lean proves
  the abstract transporter-independence implication for every object fixed by
  the source stabilizer.  The six rational axis vectors sum to zero, and their
  equivariant synthesis identifies the quotient of the rational
  six-coordinate module by the constant line with the augmentation module.
  Integrally, subtracting the sixth coordinate identifies `ℤ⁶/ℤ1` with
  `ℤ⁵`; the symmetric `6I₆-J₆` form descends through the constant line and
  has matrix `6I₅-J₅` in this chart.  The induced maps of all six-label
  permutations satisfy the action laws and preserve the descended form.
  These coordinate results are not identified with endomorphisms, elliptic
  axes, or primitive inclusions of an abelian scheme; the
  torsion local system, symplectic pairing, relative isogeny, and geometric
  maximal-isotropic kernel remain unconstructed.
- Formalize the remaining quantum inputs: the separation family, construct the
  filtered target/associated graded and prove the now-explicit compatibility
  identifying the initial form of a reduced-source series with its finite
  lowest-support exponential combination in the target-only center coordinates
  of Iritani's external direct sum, the
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
  proves independently that symmetric mixed connection derivatives together
  with pairwise commuting connection matrices imply zero curvature; these
  potentiality and commutative-associative product identities are supplied rather than derived
  from the manuscript's quantum product.  Lean
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

## Derivation of the small even gauge coefficients

`small_even_block_reduction.py` shows how the two block-off-diagonal gauge
coefficients of the small even block reduction are obtained: it conjugates the
displayed Euler and grading matrices into the separated basis and solves the
Sylvester equations that make the first and second coefficients of the
transformed system block diagonal.  Replay it with

```sh
uv run --with sympy python3 verification/small_even_block_reduction.py
```

and compare with the recorded output `small_even_block_reduction.txt`.

The script is an exhibition of the derivation, not evidence for it.  The
identities it produces are stated with those coefficients supplied explicitly
and proved by exact matrix arithmetic in the Lean module
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CubicSmallEvenBlockReduction`,
whose theorems are checked by the Lean kernel independently of any symbolic
algebra system.
