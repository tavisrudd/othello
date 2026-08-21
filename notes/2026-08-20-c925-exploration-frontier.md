# Exploration frontier

**Packet part:** open C925 experiments.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

This packet deliberately remains open under C925.  The next design questions
are:

1. **Proof-carrying record or type class?**  The mathematical object is more
   faithfully a record containing `observe`, `select`, `emit`, and proofs of
   the three laws.  A Haskell implementation could expose a type class for
   ergonomic instance selection while storing the laws in a refinement layer.
2. **Free monoidal category or only its decategorification?**  The
   \(\operatorname{Sym}(\mathsf{QBlock})\) formulation records actual block
   isomorphisms; \(\mathbf N^{(\Pi)}\) is smaller and sufficient for the
   present theorem.  Future extension data may require staying categorified.
3. **Monoid quotient or group completion?**  The center congruence uses no
   subtraction and works for Boolean consumers.  Passing prematurely to a
   Grothendieck group would add cancellation that the proof neither needs nor
   geometrically justifies.
4. **Which enrichments are lawful under the available comparison maps?**
   Even rank, nilpotent Jordan type, and modified residue are proved lawful.
   Stokes data, integral structures, Gamma classes, and extension classes
   would require stronger adapters.
5. **Can the cubic calculation become conceptual?**  The current packet has
   compressed the finite computation to one cross-term, but the appearance of
   the nonzero sheared-residue discriminant is still computed rather than
   explained structurally.
6. **Can the geometric source category be made canonical?**  Here it is a
   category presented by comparison correspondences.  A more intrinsic
   version might use a bicategory of coefficient spines and regular QDM
   correspondences, with the Iritani maps as invertible 1-cells.
7. **What is the canonical category of evaluation probes?**  Guéré's
   evaluation maps depend on a morphism \(Y\to Z\), and BFGMP Remark 4.2
   warns that maximality relative to an embedding is weaker than maximality
   relative to the identity.  A full implementation should index probes on
   arrows, probably by a double category or equipment, rather than only by
   varieties.
8. **Should KKPYY elementary equivalences retain path data?**  The thin
   groupoid is exactly sufficient for their atom set and chemical formula.
   A theory of specific birational maps would need the non-thin groupoid or
   bicategory of actual comparison spans, together with its 2-cells.
9. **When is the Bittner backend multiplicative?**  Equation (7.25) is only
   additive.  A ring-valued motivic measure requires a generic-big-QDM
   Künneth theorem compatible with the chosen atomizer and coefficient
   spines.
10. **Can a correlated marking beat the \(m=1\) constituent threshold?**
    Theorem 19.2 proves that such a marking is mandatory.  The two precise
    candidates are the \(\mathbf G_a\)-operation producing \(J_{m+1}\) and
    the pointed Gamma rank row; their provider theorems remain open.
11. **Can the provider land in one augmented-row category?**  Theorem 19.3A
    then makes the row-output kernel automatically two-sided, or avoids a
    quotient entirely.  Wall-local annihilation in separately chosen
    receivers is insufficient until the overlap 2-cells are row-line
    compatible.
12. **Can the projective and blowup lifts be made one rig pseudofunctor?**
    Equation (19.13) is the first compulsory regression.  For \(m\ge3\), it
    forces the exceptional copies into a non-split \(J_{m-1}\) string.
13. **Does the point-row marker descend through a finite Krylov shadow?**
    Theorem 20.3 reduces this to cyclicity, a nondegenerate common point
    column, and preservation of one finite recurrence at every threshold.
14. **Which comparison paths admit lawful optics?**  A useful path must retain
    a cartesian lift or residual and satisfy the relevant Beck--Chevalley
    2-cell.  Provenance without that residual is not reconstructive.
15. **Can the arbitrary-center gate be stated in kernel-profile language?**
    For \(m=2\), vanishing of the top rank \(\operatorname{rank}D^2\) is much
    smaller than classification of every center's full Stokes object, but it
    still needs a geometric proof.
16. **Can the fivefold path functor be built directly in the augmented
    primitive-row category?**  This would avoid choosing ambient threshold
    isomorphisms that the final Boolean never consumes, while retaining the
    one-object and zero-mode conditions that the countermodels show are
    essential.
17. **Can the rank-zero-target Stokes lemma be promoted to an optic law?**
    Equation (21.12) is one sufficient rank-one local normal form.  The exact
    condition is the augmented-row square (21.6).  The remaining issue is to
    place every wall and overlap map in one common row-line-compatible
    receiver.
18. **Can the large-radius/cusp frame coefficient be controlled directly?**
    Iritani's formal point column is pure at the exceptional Laurent cusp,
    but this does not identify the intrinsic large-radius Gamma point row.
    The first nonvacuous scalar is the point/exceptional coefficient for the
    blowup of projective five-space along the cubic; split
    complete-intersection pilots vanish, while nonsplit rank-two normal
    degeneration remains open.
19. **Is the one-object window statement easier than a Gamma--Orlov
    square?**  Proposition 21.11 needs analytic compatibility only on the
    common-open skyscraper.  The toric and ordinary-flop calibrations say yes
    in their scope; arbitrary codimension-two blowups remain the test.
20. **Does the transported row kill the surviving coniveau generators?**
    Corollary 21.12A reduces the full rank bridge to support-nullity plus one
    normalization.  For \(m=2\), only its primitive-sixth leakage on
    exceptional threefold-center generators is needed.
21. **What cancels the first forbidden relative-cap face?**  The
    \((-1,0)\) pilot contributes \(-1/R\).  A positive proof must identify a
    same-face channel contributing \(+1/R\); lower faces, grading, and path
    provenance cannot affect this coefficient.
22. **Is the consecutive-discrepant overlap saturated at resonance?**  A
    generic nonresonant window/GKZ comparison forgets parameter-torsion
    supported at the integral point.  Module 40 reduces the retained marked
    primitive-packet rank coimage to one DVR valuation, after a canonical
    trait lattice and exact closed-fibre base change are supplied.  Compute the normalized overlap matrix for
    the six neutral slopes, starting with \((1,1)\), and test whether its
    marked Smith/Gamma index is zero.  The first separate gate is whether the
    discrepant generic family lies in any proved window/GKZ comparison scope;
    neutral \(c_1\)-degree does not imply quasi-symmetry.  Module 41 closes
    the raw route negative and isolates five genuine unit-wall canonically
    completed quasi-symmetric eight-weight signatures without total
    unimodularity: one for three ordered types and two for flip--flip.  Test
    whether actual AKMW overlap data realize these matrices and whether
    removal of the extra coordinate is marked-saturated.  Module 42 shows
    that ordinary quantum-Serre removal kills the point/rank row and has
    forced valuation one.  Retain the fibre-scaling parameter, take the first
    normal jet, and divide the row shadow by \(1-q^{-1}\).  Module 43 proves
    that this residual map is a unit for every common-open completed window,
    including both the coordinate-wall and determinant-two pilots.  The raw
    special fibre is still zero: the remaining test is the vertical
    identification of this universal algebraic jet with the actual endpoint
    QDM row transition.  A parallel non-equivariant route is now available:
    realize the occurrence inside Shoemaker's narrow QDM.  The Euler coimage
    retains a shifted-point class represented by a compact Thom lift whose
    narrow pairing reconstructs the preimage rank row.  Transport of this
    shifted line in a common paired narrow receiver would replace the
    first-jet adapter.  Module 45 proves that proper Fourier--Mukai transport
    preserves the compact-to-ordinary K-theory image and that the
    Coates--Iritani--Jiang Gamma comparison restricts to this paired narrow
    QDM under the explicit Shoemaker realization, spanning, and exact
    non-equivariant base-change hypotheses.  Thus the rich bottom comparison
    is already available for a realized toric completion.  Module 46 then
    identifies the narrow rank row with equivariant rank divided by the
    universal Thom zero \((1-q^{-1})^r\).  Rank preservation therefore
    transports the row automatically, and the paired comparison transports
    its shifted Thom representative.  No independent scalar or Euler-square
    calculation remains after the occurrence/fixed-phase, Thom/framing, and
    exact-base-change identifications are supplied.
    Module 47 further shows that a single-valued horizontal realization
    automatically transports the whole generalized primitive sector; the
    divided row quotient removes any multiplicity.  Thus the fixed-phase
    gate is no longer a projector-commutation calculation.  It is the
    geometric identification of the actual cubic packet with one common
    based loop or typed deck path, including the explicit character mapping
    under adjacent reindexing.
    Module 53 now proves the strongest source-side extension available
    without constructing that occurrence.  In one canonical trait receiver,
    quotient by the saturated closure of the generic row-null supported span.
    This quotient is automatically flat, its row survives exact
    specialization, and both incident Boolean markers agree if their actual
    closed packets are faithfully read there.  The normalized
    quantum-Serre/conormal primary row is already a unit, including under
    ramification.  The highest-EV test is therefore no longer a six-case
    Stokes-matrix or scalar calculation.  Module 54 derives the exact
    row-projected Malgrange--Sabbah target
    \(\rho_j(1-T_j)|_{\operatorname{im}(1-T_i)}\), with a dual
    point-covector form; one directed covector suffices for the chosen path.
    The alternative is a normalized intermediate-extension line on the
    resonance trait with an exact actual-packet reader.  Module 55 makes
    wrong variables, resonance, normalization, occurrence, phase path, row,
    and direction unrepresentable to the telescope.  Construct the trusted
    projected source adapter for the first \((1,1)\) pilot.  Module 56 now
    proves that its projected covector follows formally from two compatible
    one-wall can/var factorizations:
    \(rv_i=a_i\rho_i\), \(\rho_ic_i=u_ir\), and positive normal order imply
    \(\rho_jc_jv_i=a_i u_j\rho_i\), hence closed-fibre zero.  The highest-EV
    pretest is now Module 57: for the canonical image factorization these
    two equations are equivalent to \(r(1-T_i)=a_i u_i r\), which forces the
    row to kill every fixed summand.  Compute whether the primitive-sixth
    projector kills the common fixed generators while retaining the moving
    rank line.  Only after that passes is the highest-EV task the exact
    occurrence reader identifying the actual
    fixed-phase inverse-Laplace blocks and maps with those Thom/divided-rank
    packages in one receiver, not a two-wall Stokes-matrix computation.
    Yu--Zhang's spectral/vanishing-cycle theorem helps type the block reader
    for an algebraic exponential-type occurrence, but constructs neither the
    Gamma row nor the can/var identification.  If that reader fails,
    construct the common trait receiver and normalized intermediate-
    extension reader, then make either construction occurrence-uniform.
23. **Can the completed comparison be restricted to the intended
    total-space open?**  Module 48 proves that canonical-character completion
    is numerically crepant for every toric wall, independently of
    quasi-symmetry and total unimodularity.  Modules 49--50 show why this does
    not finish the narrow route: every admissible pilot gains new semistable
    supports, and no finite ordinary multi-coordinate completion with the
    same torus, linearization, raw phase, and total correction character can
    avoid them.  Module 51 then gives a correspondence-level no-go: the
    natural completed kernel has mixed boundary--open support on every pilot
    adjacency and does not descend through the intended boundary
    localizations.  Generic/divided rank nevertheless kills the mixed
    boundary classes.  Thus no full open equivalence is needed or available
    from this kernel; the exact surviving test is the occurrence-level
    fixed-phase row identification of the normal-jet route.  A genuinely
    relative/enlarged-group construction remains separate.
24. **Can a superpotential erase the mixed boundary without changing the
    endpoint?**  BFK's crepant LG window theorem and critical-locus
    localization show that the boundary can be made invisible to matrix
    factorizations.  Module 52 proves the cheap stabilization impossible:
    a gauge-invariant nondegenerate quadratic added fibre has zero total
    character, so it cannot supply the correction \((1,-1)\), while
    \(p x_\kappa\) deletes a genuine raw coordinate.  A viable GLSM route
    must name a new critical target and prove that its fixed-phase QDM/Gamma
    row is the original cubic packet.

None of these questions blocks the proof in Modules 0--16 or the
transport-level specialization audit in Module 17.  Modules 18--57 isolate
the general consequences without claiming the missing enriched provider.
The open questions control whether the interface can be promoted from a
lawful compiler to a canonical equivalence with the complete external
theories, and how far it can be reused beyond this one-stabilization
application.
