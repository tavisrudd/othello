# C1133 — actual transport maps and a narrower P¹ proof

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Status:** replacement proof accepted by the separate focused hostile review;
core A–D lose the general projective-bundle input without weaker quantifiers.
This is a mathematical audit supplement, not a manuscript or Lean promotion.
The independent baseline referee owns `2026-09-10-c1133-hostile-referee.md`.
No new external full-text read was completed by the root in this pass.
The cumulative source register has 91 entries (90 external, one local),
with nine external full-text reads (seven papers, two source scripts).

## 1. Actual maps, with the internal obligations exposed

The following primary passages were read, rather than inferred from abstracts:
Iritani, blowups v3, §2.2–2.3 (extraction 617–865), §5.6/Remark 5.6
(4250–4348), (5.33)–(5.43)/Theorem 5.18 (5300–5765), and §5.8.2
(5810–5960); Iritani–Koto v4, Theorem 5.1/Remarks 5.2–5.4 (2338–2490).
Both remain **partial** reads. Source hashes and expanded scopes are in
`2026-09-09-c1133-literature-sources.json`.

1. **Domains.** Iritani's Remark 2.3 uses the divisor-reduced ring with
   combined generators Q^d exp(σ^(2)·d), polynomial unit dependence and
   graded completion. There are no additional free source divisor variables.
   Remark 5.6 explicitly warns that the unreduced substitution is ill-defined;
   its reduced substitution is the permitted one. The raw Novikov map alone
   need not be injective.
2. **Independent coordinates.** The source's reconstruction (5.47)–(5.48)
   places the external direct sum over independent t,s₀,…,sᵣ₋₂. The joint
   Jacobian has an inverse; these are actual coordinates, not tags added to
   force injectivity. Initial shifts and inverse changes are handled in the
   source's graded Q-adic topology. One must not translate an arbitrary
   ungraded power series by a nonzero constant.
3. **Connection, not just product.** Equations (5.41)–(5.43) intertwine the
   actual z-direction, including the grading term. Theorem 5.18 is an
   isomorphism on the specified completed C[z]-modules; its inverse is on
   those same modules. The positive graded realization preserves the original
   z-lattices. IK Remark 5.3 explicitly explains the coefficientwise
   nonnegative-z realization for the projective-bundle version.
4. **Our injection lemma.** The source does not assert the precise
   intrinsic generic-field embedding we need verbatim. The proof remains
   `2026-09-09-c1133-fixed-base-proof.md`: use the first nonzero ample-degree
   slice, finite numerical classes in that slice, polynomial coefficients at
   fixed class and bounded grading, and the independent divisor characters.
   Their finite Vandermonde matrix rules out cancellation after raw Novikov
   collisions. Algebraic divisors survive on the Hodge-fixed base; repeat
   this argument there, rather than taking a quotient of an injection.
5. **Lattice and primary factors.** A regular map with regular inverse sends
   N and im(N) to their counterparts, hence preserves the canonical
   elementary modification and conjugates its residue. Independent unit
   coordinates separate distinct occurrences generically. The full even
   rank is selected before odd representations are extracted.
6. **Common fields.** Each operation is compared in its own external
   domain/fraction field after a finite splitting extension. No composite
   of incompatible Laurent expansions along a factorization is required:
   intrinsic invariant equalities telescope. This does not license an
   arbitrary specialization between the two intrinsic coefficient fields.

These checks support the written transport argument at these interfaces.
They are not a claim to have reconstructed the cited comparison theorems
from first principles. Numerical Novikov conventions, bounded graded
completion, equivariance and the regular inverse remain indispensable.

## 2. Exactly the replacement needed

For core A–D we need only (i) endpoint values on X×P¹ for the nine detected
Fano families, and (ii) zero center selectors on ruled surfaces. We do not
need a product theorem for arbitrary varieties or a projective-bundle theorem
for arbitrary vector bundles.

Use the existing blowup comparison and Hodge refinement, cyclic persistence
(packet Proposition 12.1), rank-two residue transport (Proposition 13.1),
and the standard genus-zero product formula for GW classes. Behrend,
*The product formula for Gromov–Witten invariants*, arXiv:alg-geom/9710014,
formula (1), is the primary product source (**partial**: extracted 30–145
and 280–340, including Theorem 1). We use its small quantum consequence;
we do not claim that the big quantum product is tensorial at mixed bulk.

### 2.1 Endpoint continuation, transverse directions included

Let X be one of the nine detected smooth Fano threefolds. At zero higher
bulk, small quantum Künneth identifies the **full supermodule** of X×P¹
with the tensor product, including its z-connection and original lattice:
the Euler and grading operators are the sums of those on the two factors.
The quantum Künneth assertion follows from the n=3 product formula; the
grading assertion is ordinary cohomological grading, not another theorem.

Over the generic independent Novikov variables, then a finite extension,
the P¹ factor has two distinct eigenvalues ±2√q_f. Their shifts of every
X eigenvalue are pairwise distinct: an equality between opposite shifts
would make the independent q_f algebraic over the X coefficient field.
The two P¹ blocks admit regular formal separation with regular inverse.
Tensoring one with an X block therefore preserves the original lattice;
after removing its scalar exponential, its rank-one connection adds only
scalar coefficients to the X connection. The canonical rank-two residue
discriminant is unchanged by a common scalar shift.

At this point the even X matrix has one cyclic repeated primary block of
rank two or three and only rank-one complements. These facts are the
already checked nine-family finite inputs. Each product repeated cluster
is cyclic of the same even rank. On the formal germ in **all even bulk
coordinates**, including mixed classes α⊗p, Proposition 12.1 continues its
nilpotence and cyclicity. Proposition 13.1 continues its discriminant when
the rank is two. The complementary rank-one clusters stay rank one.
This uses the full QDM's flatness in every transverse variable, not an
injective map from the product locus. The small locus itself need not be
faithful. The formal germ over the generic Novikov field is precisely the
local setting used for the endpoint computation in the original packet.

All the odd cohomology of X belongs to its repeated factor by the even-rank-one
Frobenius lemma. At the product point the two repeated factors each carry
H³(X) up to the already permitted Tate periodization. On the Hodge-fixed
bulk germ their separated projectors are equivariant, so their multiplicity
ranks for the common reductive Hodge group are constant. Thus the safe
unlabelled sum is two copies of H³(X). As in B, no rational descent of each
individual scalar-labelled factor is claimed.

Consequently the numerical endpoint selector values and B's safe Hodge
class double for these nine X. Projective four-space has only rank-one
small clusters and hence zero selectors by the same simple-cluster
continuation. The eight rational controls require only rational geometry.

### 2.2 Full even bulk on C×P¹, including genus one

Let C have genus g≥1, set κ=2−2g, and use the flat even basis
1,h,p,hp, where h is the point class of C and p that of P¹, with ∫hp=1.
Write the full even bulk as v·1+a h+b p+c hp and Q=q_f exp(b).
The horizontal numerical Novikov variable remains an independent spectator
scalar in the intrinsic coefficient field; its absence from the potential
below means all positive horizontal-degree genus-zero coefficients vanish,
not that the variable has been specialized to zero or one.

Every genus-zero map to C is constant, including maps from nodal trees.
The degree-d moduli space is C times the corresponding P¹ space, with
no H¹ obstruction from the constant C factor. Thus a nonzero positive-degree
primary invariant has exactly one total h factor. If that factor is an h
insertion alone, the P¹ factor has a unit insertion and the string equation
makes the invariant zero. Otherwise it is an hp insertion and every other
nonunit insertion is p. The P¹ dimension equation forces d=1. Its degree-one
three-point invariant is 1, and the divisor equation handles further p
insertions. There can be at most one hp insertion. The full even potential,
up to irrelevant terms of degree at most two, is therefore exactly

    F = v²c/2 + vab + cQ.

The pairing has nonzero entries (1,hp)=(h,p)=1. Taking three derivatives
gives, throughout this full even formal base,

    h⋆h=0,    h⋆p=hp,    p⋆p=Q(1+ch).

The centered Euler element is κh+2p−c hp: the hp bulk coordinate has
Euler weight −1, divisor coordinates have weight zero, and the unit is
removed as a scalar. Put p′=(1−ch/2)p, using the quantum multiplication.
Then

    (p′)²=Q,             U=κh+2p′.

After adjoining √Q, the two projectors (1±p′/√Q)/2 have even rank two.
On either block the centered operator is **κh**, not merely at c=0.
For g=1 it is identically zero, so the nonzero rank-two nilpotent selector
vanishes; there is no even-rank-three selector. This handles the noncyclic
elliptic case directly, without trying to apply cyclic persistence to N=0.

For g>1, κh has rank one on each block. At c=0 the original z-connection
is the small tensor connection; the curve's canonical modified residue has
discriminant zero. Rank-two residue transport along the full even bulk
continues this value. Both rank-two selectors vanish, and the even-rank-three
odd selector is absent. The calculation applies equally on the Hodge-fixed
base; all even classes of C×P¹ are Tate.

For C=P¹, small P¹×P¹ has four distinct generic eigenvalues over independent
Novikov variables. Their rank-one continuations give zero selectors in
all mixed even directions, and the odd fiber is zero.

### 2.3 Every ruled surface, without projective-bundle QDM comparison

A geometrically ruled surface P_C(V) is birational to C×P¹ because V is
trivial over the generic point of C. Projective surface factorization
relates smooth models by point blowups and blowdowns. The existing blowup
formula adds only point selectors, which are zero. Hence every such ruled
surface has zero selectors. This is dimension-two invariance established
using points only; it does not assume the dimension-four invariant under
construction. The nef-minimal-surface argument, P² computation and point
blowup reduction finish the original surface-vanishing proof unchanged.

## 3. Dependency economy and unchanged scope

The focused review accepts §2, so core A–D can omit the general
Iritani–Koto projective-bundle reconstruction theorem and the separate
equivariance adaptation for it. They use the elementary ruled calculation
and small GW product formula instead. The endpoint statements retain
every-member scope for all seventeen families in A, the same nine-family
scope in B, and precisely the existing C/D quantifiers.

No claim is made that general projective-bundle formulas or optional
extensions lose their IK dependency. The currently annotated manuscript
still states that stronger operation theorem; its dependency graph cannot
be pruned without revising those statements and their coverage records.

Other eliminations already justified by the earlier economy review remain:
A needs no Hodge transport; C/D reuse B; D needs no fourth-power detour,
initial polarization-preserving isogeny, effectivity or twist finiteness.
Rank-three logarithmic lattice theory, Stokes/Gamma enhancements and the
conditional pencil companion are not core inputs. The remaining blowup,
weak factorization, finite/geometric, rational Torelli and arithmetic inputs
are doing actual work and are not removed by this argument.

The finite/geometric packet can also be made smaller **without changing
A–D**. Its seventeen-family table remains useful validation, but:

- Only the **nine detected quantum matrices** are mandatory. The eight
  rational-control matrices are consistency checks; their products are
  rational from the geometric rationality input alone.
- Exact values of all seventeen h^(2,1) are unnecessary. For A it suffices
  that H³ is nonzero in the four even-rank-three cases g=2,3,4,5; the five
  rank-two cases are detected numerically without an H³ dimension input.
  B identifies the entire H³ representation and needs no numerical value
  for its dimension. General Fano cohomological shape is still used.
- Even the five nonzero discriminants need not be retained as separate
  labels for A–D: the positive rank-two selector and its odd Hodge class
  use only **δ≠0**. Their actual values and the four Hodge dimensions
  support the additional signature-separation corollaries, so keep the
  existing certified table available for those stronger optional outputs.
- Ordinary irrationality theorems for the nine detected families are
  historical comparison, not premises: one-stable irrationality implies
  ordinary irrationality because a rational X has rational X×P¹.

Classification exhaustion, every-member family/matrix identification and
the eight all-member rationality assertions cannot be replaced by this
dependency pruning. In particular, no deformation-invariance claim for
rationality is introduced.
The rational-control zeros in the checked table are then forced by
dimension-three birational invariance (point and curve centers suffice)
and their geometric rationality, since P³ has simple generic blocks.
This explains the zeros independently of the numerical table; it does not
recover rationality from those zeros.

## 4. Reproducible algebra check and boundary

From `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python notes/2026-09-10-c1133-p1-reduction.py
    uv run --with sympy==1.14.0 python notes/2026-09-10-c1133-p1-reduction.py --check

The adjacent `.json` and `.sha256` record the deterministic certificate,
script/output hashes and byte counts. The checker differentiates the stated
potential with ∂_bQ=Q, constructs all four multiplication matrices, checks
all sixteen associativity pairs, the two separated rank-two projectors and
the identically zero elliptic centered operator. Inputs are rational
symbolic variables Q,c,κ (with √Q nonzero after extension); no random seed.
The hand calculation p′²=(1−ch)Q(1+ch)=Q is an independent algebra check.
The checker does **not** prove the GW potential, cited transport theorems,
generic-field realization, or Hodge descent. Those remain the written
arguments above and their identified inputs. No Lean replay occurred.

## 5. EJ + TT and Mystery ledger

Both hostile passes are complete: baseline `e8ad70084`, focused replacement
`76269bc67`. The reviewer found no demonstrated major flaw in the audited
interfaces and accepted the replacement. The only requested refinement was
to keep horizontal Novikov parameters as independent spectators; §2.2 now
does so. The reviewer independently derived the potential and tensor-lattice
argument, rather than accepting the script's potential as an oracle.

The explicit EJ + TT pass then pruned the finite premises in §3 and traced
the rational-control zeros to geometric rationality and dimension-three
invariance. These are task-owned improvements, not new research tasks.

- **Settled:** actual independent occurrence coordinates, reduced-domain
  injection and regular inverse at the inspected source interfaces.
- **Settled:** the elliptic mixed-bulk obstruction. The exact Euler weight
  −1 explains cancellation after p→p′; no accidental specialization is used.
- **Settled:** the full-bulk endpoint continuation and original-lattice
  matching needed for the narrower P¹ proof.
- **Settled:** why control-table zeros need not be additional premises.
- **Remaining gate:** consolidate the proved lemmas and dependencies into
  the manuscript, using `2026-09-10-c1133-integration-outline.md` for the
  author's requested accessible structure. The all-member geometric input
  audit retains its existing read boundaries; this referee did not redo it.

No genuine new mathematical mystery remains in the replacement argument.
The independent baseline still recommends revision/consolidation before
submission, not blanket acceptance of an unassembled paper. No broader
projective-bundle claim follows from the special calculation.
