# Reed--Solomon deep-hole programme

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** C475--C499, C509--C510, C512--C519, C525, C529, and C530 complete. C519 found the
characteristic-two doubled-quadric obstruction; C525 replaces it by the ordered-Hessian `(2,2)`
model and proves that its complete constrained degeneracy pullback is exactly the persistent
catalecticant/Lucas-nucleus carrier union.  Outside it, the effective base threshold is
`q >= min((n-4)(n+3)/2+1, 5(n-4))`, with deletion budget `3n-4`.  C529 proves the infinite
power-of-two top-nucleus carrier family and normalizes the linearized root cover on its
distinguished Borel-endpoint orbit.  The
C498/C509 parity law is the `F4`/order-two level; the first fresh degree-nine carrier has minimal
constant field `F8` and an order-three component cycle on its `e_7` orbit.  C530 proves that this
is only the `AGL_1(F8)` linear section: quotient directions `t^2,t^4` enlarge it to an
`AGL_3(F2)` additive cover, while the generic framed incidence is a nonconstant Artin--Schreier
double cover.  Every field of dimension at least three over `F2` contains a three-space subspace
polynomial, so the full `e_7` orbit is shallow over every admissible field.  C531 is next and owns
the remaining intrinsic degree-nine carrier strata; C532 packages the resulting redundancy-ten
theorem.  C533 independently owns C525 threshold/deletion sharpening.
C500 remains release-gated.
C498 now closes the all-field redundancy-six
classification, including intrinsic small exceptional semilinear normal forms;
C500 (redundancy-five paper,
release-gated) queued.  C478's coherence upgrade identifies each
syndrome atlas with a projected sextic and proves that one diagonal support correspondence across
at most three syndrome fibres recovers every frozen C398 parent.  C481 proves that the determinant
atlas is exactly the projected labelled `M_0,6` point.  C482 proves exact residual dimensions two
and one for two/three projections, but corrects the four-view target: pure reconstruction is a
separable quadratic cover, not a rational inverse, even after diagonal `S6`.  C483 identifies its
deck swap with Gale association, proves that the reduced branch divisor is exactly the conic locus,
and expresses fixed-child recovery as an exact incidence cut explaining the frozen `3/3/2/3`
thresholds.  C484 globalizes Frobenius-equivariant descent: the Gale sheet has an exact
Kummer/Artin--Schreier class, connected gauges add no obstruction, finite diagonal stabilizers have
an image criterion, and q=8's `C3` is a lossy colour coequalizer rather than Hilbert--90 failure.
Modular machinery remains separate behind the matching, Gram, and Sylow gates.  C485 packages the
all-field theorem, proves that the complete child alone recovers the unlabelled parent for `q>=16`,
and confines the unresolved at-most-three base-size question to an exact collision-hypergraph
problem over `q<=13`.  C490 closes it with exact empty-child and q=7 two-point exceptions; every
recoverable fibre has base at most three, and q=13 is already child-rigid.  C491 closes the
2019-announced redundancy-five case: covering radius unconditional, a characteristic-free
Hankel-pencil criterion, the complete PΓL₂ deep-hole classification of `PRS(q-4)` (tangent and
sigma-secant plus new arithmetic families: osculating-pair intersections gated by q mod 3, and in
characteristic 3 a fixed nucleus deep hole plus a wild Artin--Schreier family), sporadic orbits
exactly at q in {7,8,9,11,13,17,19}, and an NRC bridge ledger whose next falsifiable gate is the
redundancy-six net-of-quartics split-member lemma.

## Goal

Develop intrinsic, computable invariants for projective deepest-syndrome directions of
redundancy-three generalized Reed--Solomon codes, prove exactly what they remember modulo the full
projective-semilinear code automorphism group, and isolate the first exceptional fibres where a
coarser invariant fails. Use the C398 non-GRS examples as controls, not as substitutes for the
standard-GRS problem.

The coding dictionary is fixed. If `H` is a `3 x n` parity-check matrix whose projective columns
form an arc `A` in `PG(2,q)`, then a projective syndrome `u` has coset weight three exactly when it
lies on no secant of `A`; equivalently, adjoining `u` gives a one-column MDS extension. For a
standard redundancy-three GRS code, `A` lies on a nonsingular conic.

## Context map

```text
C398 classification + certificate
  -> C474 decorated-fibre theorem + replay
       -> C475 coefficient atlas for standard GRS parents (complete)
            -> C476 bounded standard-GRS atlas pilot (complete)
                 -> C477 first q=11 collision fibre (complete)
            -> C478 frozen exceptional controls
                 -> only after a collision: modular/descent discriminators
```

| Role | Read | What C475 imports |
|---|---|---|
| Immediate precursor | [`C474 Reed--Solomon companion`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.md) | Deep-hole/MDS-extension dictionary, determinant-atlas question, four orbit profiles, and exact stop rule. |
| Control theorem | [`C398 classification`](../2026-07-20-c398-conic-deep-hole-classification.md) | The exhaustive four non-GRS controls at `q=8,9,9,11` and the controlling literature boundary. |
| Control evidence | C398 [`data`](../2026-07-20-c398-conic-deep-hole-classification.json) / [`checker`](../2026-07-20-c398-conic-deep-hole-classification.py) / [`hash`](../2026-07-20-c398-conic-deep-hole-classification.sha256); C474 [`data`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.json) / [`checker`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.py) / [`replay`](../2026-07-22-c474-reed-solomon-decorated-deep-holes-replay.py) / [`hash`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.sha256) | Frozen regression inputs; do not regenerate them. |
| Conditional discriminator | [`C474 modular gateway`](../2026-07-22-c474-modular-gateway-theory.md) | Gram and Sylow gates to use only if coefficient-atlas fibres leave a nontrivial incidence carrier. |
| Idea provenance, not an input theorem | [`gateway brainstorm`](../2026-07-20-clebsch-gateway-chain-brainstorm.md) §§G3--G4 | Separates decorated-transform inversion from the distinct higher-order-MDS/list-decoding branch. |
| Candidate language, not assumptions | [`C417 cocycle audit`](../2026-07-20-c417-affine-cocycle-line-bundle-audit.md) and [`Weil-roof ledger`](../2026-07-21-clebsch-weil-roof-results-ledger.md) | Possible descent/cubic vocabulary after the elementary atlas is known; neither is part of the C475 proof base. |

The older [`C121 q=11 checks`](../2026-07-13-c121-icosahedral-mds-checks.md) and
[`C122 deep-hole audit`](../2026-07-13-c122-deep-hole-novelty-audit.md) are archaeology only; C398
and C474 supersede them for lane entry.

Use the [`papers index`](../../papers/papers-index.md) as the cross-paper theorem registry. Adjacent
banks are opt-in, by obstruction shape:

| Bank | Exact handles | Use in this lane |
|---|---|---|
| `arcs_complete_outside_conic` | `thm-arc-mds-syndrome`, `thm-relative-syndrome-confinement`, `thm-extension-conflict-hypergraph`, `thm-defect-leader-collision`, `thm-evaluation-dichotomy` | Foundational syndrome/extension semantics, moment constraints, and evaluation-rank obstructions. See the [`arcs` handoff](done/2026-07-12-arcs-complete-outside-conic-formalization.md) and [proof audit](../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic_proof_audit.md). |
| `clebsch-hexagon-code` | `thm-clebsch-rigidity`, `thm-conic-filling-kle7`, `thm-clebsch-reflection-arrangements`, `thm-rank3-reflection-complement-code` | Rigidity and reflection-family controls beyond the four-class certificate; do not import paper claims by folklore. |
| `relconic` | [`C312 determinant/trace criterion`](../2026-07-18-c312-c297-seed-repair-legality.md), [`C314 invariant atlas`](../2026-07-18-c314-c297-invariant-moduli-stratification.md) | Model for separating scaling, gauge, Frobenius, stabilizers, and degeneracy divisors when a C475 fibre becomes an algebraic moduli problem. |
| `complete-repair-ports` | `thm-repair-coefficients` | Warning/control: raw recovery coefficients vary under monomial rescaling, so only gauge-invariant combinations can classify. |
| Higher-order-MDS branch | [`C295`](../2026-07-17-c295-intrinsic-continuation-reconstruction.md), plus `comp-q11-extension-complex` | Simultaneous-extension input only; not needed for the one-column C475 gate. |

Do not recompute the four C398 fibres, their deletion traces, the q=9 cube, or their automorphism
orbits unless a new invariant exposes a concrete inconsistency. They are regression controls.

## Closed base — C475

[`C475 determinant atlas`](../2026-07-22-c475-reed-solomon-determinant-atlas.md) proves the
homogeneous Veronese factorization in all characteristics, including infinity; the full integral
edge-torus quotient; exact finite-field orbit separation; and projective-semilinear descent.
Four-cycles reconstruct every rank-two syndrome for supports of size at least five.  They contract
exactly the rank-one/conic locus, where the unique missing datum is the radical point in
`P1(F)-S`.  C476/C478 must retain the raw four-cycle fibres for collision detection, then use the
support-stabilizer orbit of the radical point as C475's proved rank-one discriminator.  No higher
edge monomial is permitted as a purported repair of that structural contraction.

## Closed base — C476

[`C476 bounded pilot`](../2026-07-22-c476-standard-grs-atlas-pilot.md) exhausts every six-support
class through q=9 and the first canonical q=11 support, where the stop rule fires.  For
`S={0,1,2,3,4,infinity}`, the full semilinear stabilizer is Klein four and its complement orbits
are `{5,10}` and `{6,7,8,9}`.  The associated rank-one syndromes `(1,5,3)` and `(1,6,3)` share the
all-one raw atlas but are separated by their radical orbits.  All five rank-two syndrome orbits on
that support have distinct atlases.  The unique external two-point orbit is also the rational fixed
set of the unique stabilizer involution whose fixed points both avoid `S`.  The
[`C476 extra-juice review`](../2026-07-22-reed-solomon-c476-ej-review.md) identifies the exact Klein
quotient: the two-point collision orbit is a ramified fibre and the four-point orbit is ordinary,
so nontrivial syndrome stabilizer is a canonical one-bit discriminator.

## Closed base — C477

[`C477 first collision theorem`](../2026-07-22-c477-first-atlas-collision-fibre.md) independently
reconstructs the full Klein action and proves that nontrivial radical stabilizer is the sharp
cardinality-minimal intrinsic discriminator.  Quadratic evaluation rank is `5` on both extended
arcs, but the first extension-conflict statistic separates: legal continuation counts are `11`
and `7`.  The exact continuation graphs are `K5 union C5 union K1` on the external branch orbit and
`K5 union 2 K1` on the ordinary orbit.  The atomic certificate and structurally independent replay
cover all finite claims.  A requested second extra-juice pass further proves that the branch
involution acts with cycle type `1+2+2` on both five-vertex components and fixes the isolated
off-conic vertex.  No balanced edge monomial can refine the collision.

## Closed base — C478

[`C478 exceptional controls`](../2026-07-22-c478-exceptional-family-controls.md) evaluates the
universal edge-torus atlas on the four C398 non-GRS classes and the fixed `A3/B3/H3` conic phases.
It recovers the exact syndrome orbit profiles `4 / 6 / 1+6 / 12`.  Independent fibrewise
unlabelling retains only those child-orbit colours and no parent information, but the coherent
Galois-equivariant family—one diagonal `S6` across fibres—has exactly `6 / 8 / 2 / 22` parent
signatures and recovers all four fibres with minimum syndrome counts `3 / 3 / 2 / 3`.  The q=8
`3+3` collapse under a colourwise Frobenius quotient is exactly erased `Gal(F_8/F_2)` orientation.
The three full conics are complete arcs, so their own atlas domains are empty.  The q=9 cube still
fails at shared Gram rank `3` and a stably zero Sylow endpoint; the pointed q=7/q=11 carriers pass
Gram rank zero and Sylow endotriviality.  The next theorem gate is simultaneous projection
reconstruction with an explicit discriminant; modular machinery remains conditional downstream
structure.

Task card: `notes/reed-solomon-tasks/c478-exceptional-family-controls.md`.

## Closed base — C481

[`C481 projection-sextic theorem`](../2026-07-22-c481-projection-sextic-coherent-atlas.md)
constructs the quotient-line alternating form and identifies its determinant brackets, modulo the
exact edge torus, with labelled `M_0,6` in every characteristic.  Both the Pluecker-array inverse
and the normalized three-cross-ratio inverse are explicit.  Pointwise, diagonally coherent,
Frobenius-colour-orbit, and Galois-equivariant functors have exact semilinear transporter laws and
the common stabilizer recovery criterion.  The finite quotient lattice explains all C478
distinctions, but does not model C482's positive-dimensional pure-reconstruction fibres; the
Fable/RS template applies only after ambient-child data cuts the fibre to a finite set.

Task card: `notes/reed-solomon-tasks/c481-projection-sextic-coherent-atlas.md`.

## Closed base — C482

[`C482 synchronization theorem`](../2026-07-22-c482-three-centre-synchronization.md) normalizes
each quotient gauge and derives one exact compatibility equation per view.  Two and three views
leave complete-intersection residual families of dimensions two and one.  With four views, the
linearized compatibility matrix has a kernel line containing the universal forbidden collision
`h_5=h_6=h_4`; removing it from the product cubic leaves an explicit separable quadratic.  Exact
`F_101` and `F_256` witnesses have two deep parents and trivial common diagonal stabilizer, so the
proposed rational inverse is false in odd and characteristic two and remains false after diagonal
unlabelling.  A requested second closeout gives the rational source-side deck swap
`z -> rho(L_1 e-L_0 z)`, so both sheets of an `F_q` parent are `F_q`-rational.  C483 must express
that involution intrinsically, factor the quadratic branch divisor, and determine how fixed-child
side information selects a sheet.

Task card: `notes/reed-solomon-tasks/c482-three-centre-synchronization.md`.

## Closed base — C483

[`C483 reconstruction discriminant`](../2026-07-22-c483-reconstruction-discriminant.md) identifies
the quadratic deck swap with the Gale association involution of the `3 x 6` parent matrix.  On the
normalized chart the kernel cubic is `st(L0 s+L1 t)`, with
`L0=-det(h4,h5,h6)` and `L1=det(v2(h1),...,v2(h6))`; hence the intrinsic reduced branch divisor is
exactly the conic locus in every characteristic, while the collision factor is only an arc-boundary
collinearity.  All rank drops are explicit cubic sections `P(ker M_r) intersect V(x_X x_a x_d-
x_Y x_b x_c)`.  Complete-child side information is the exact transporter/incidence cut
`g(L)=U(A)`, and its restriction map explains the frozen sharp `3/3/2/3` thresholds without a new
field census.  Primary symbolic certification and an independent Gale replay cover the new
computational checks.  Every further abstract view preserves the same Gale pair, since each
compatibility row annihilates both sheets; only common ambient-child placement can select one.
Locally `tau=L1/L0^2` is Gale-anti-invariant in odd characteristic, while characteristic two needs
the explicit Artin--Schreier coordinate `eta=L0/(L0+L0#)` with `eta#=eta+1`; q=8's `C3` colour
orientation is a distinct descent class.  On frame overlaps, odd `tau` coordinates differ by
invariant units and characteristic-two `eta` coordinates by invariant translations, so C484 owns
the resulting explicit Cech/Frobenius cocycle rather than discovery of the local cover.  C484
completes that globalization and proves the `C3` collapse is information loss, not a Hilbert--90
obstruction.  C485 has one genuine unresolved gate: current results prove
at-most-three child-relative recovery only on the four frozen C478 fibres.  An all-field statement
needs a new uniform base-size theorem; otherwise its clause must remain conditional on injectivity
of `Sigma_T`.

The larger-conjecture bridge is now explicit but unallocated.  For redundancy `r`, deepest
syndromes are one-point arc extensions of the degree-`r-1` parity-check normal rational curve; at
full affine length the standard RS conjecture becomes unique completion of the punctured curve.
The conic (`r=3`) base case is immediately packageable, including the even-characteristic nucleus.
Beyond it, the six-point Gale involution does not scale: Gale is self-dual only at `n=2r`.  A new
higher-symmetric-power/Grassmannian atlas plus either a secant-covering theorem or a distinct-root
rational-point existence theorem is required.  This remains behind the handoff's arbitrary-
dimension pre-allocation gate.

Task card: `notes/reed-solomon-tasks/c483-reconstruction-discriminant.md`.

## Closed base — C484

[`C484 semilinear descent`](../2026-07-22-c484-coherent-semilinear-descent.md) proves that every
C482 gauge, compatibility row, residual cubic, Gale transform, discriminant divisor, and
complete-child incidence cut commutes with coefficientwise Frobenius.  Off the conic branch, the
Gale pair has one exact `C2` descent class: locally a chart-independent Kummer square class in odd
characteristic and a chart-independent Artin--Schreier trace bit in characteristic two.  Connected
finite-field gauges contribute no further obstruction.  For a diagonal target stabilizer `H`, an
unlabelled sheet is effective exactly when the Frobenius sheet bit lies in the image of
`H -> C2`; a surjective image identifies the sheets and sacrifices uniqueness.  The frozen q=8
extractor computes colour Frobenius as `(0 4 1)(2 5 3)`, proving that the `3+3` collapse is a free
order-three colour quotient, not the Gale class or a Hilbert--90 obstruction.  Its frozen
two-centre residual pairing commutes with this `C3`, giving a regular `C6` action without asserting
that the child-relative `C2` is Gale.  Over `F_(q^m)`, the genuine Gale descent bit multiplies by
`m`, so odd extensions preserve it and even extensions split it.  After choosing a representative
two-centre restriction, the q=8 one-centre, two-centre, colour-orbit, and three-centre partitions
are exactly the `C6/C3/C2/1` subgroup-quotient diamond; the child has no preferred pairing before
that choice.  Hilbert 90 first rationalizes any Frobenius orbit of frame charts, then the intrinsic
square-class/trace test detects the separate constant `C2` sheet.

Task card: `notes/reed-solomon-tasks/c484-coherent-semilinear-descent.md`.

## Closed base — C485

[`C485 reconstruction synthesis`](../2026-07-22-c485-all-field-reconstruction-synthesis.md)
assembles the all-field redundancy-three theorem without weakening its hypotheses.  Four abstract
coherent projections recover exactly a Gale pair off the conic branch and one ramified sheet on it;
two/three-view recovery with a complete ambient child is exactly injectivity of `Sigma_T` after the
explicit incidence cut.  The report gives the canonical quadratic algorithm, every rank,
denominator, boundary, stabilizer, and semilinear exception, the Kummer/Artin--Schreier fibre
trichotomy, and the C475 GRS rank-two/rank-one specialization.  A new secant-union rigidity lemma
proves base size zero for the unlabelled fixed-child fibre when `q>=16`.  For `q<=13`, alternative
parents are alternative fifteen-line decompositions of the child complement, and at-most-three
recovery is exactly a transversal-number-three question for the explicit coherent collision
hypergraph; its hyperedges are common zero loci of balanced quartics.  Exact arrangement counting
adds `|U(A)|=q^2-14q+55-tau(A)`, where `tau` counts concurrent perfect matchings, and identifies the
four frozen profiles as `3/4/3/10`.  At q=13, common-secants of any distinct equal-child pair form
exactly `3K2`, `P4 union K2`, `K1,5`, or `K1,5` plus one leaf edge; these skeletons hit at most
`7/9/15/15` concurrent perfect matchings, so child size at most 32 forces one of the two star types.
No uniform small-field conclusion is claimed without the remaining collision-component
classification.

Task card: `notes/reed-solomon-tasks/c485-all-field-reconstruction-synthesis.md`.

## Closed base — C490

C490's [`small-field closure`](../2026-07-22-c490-small-field-base-size-closure.md) exhausts the
child-derived fifteen-line decompositions and coherent collision hypergraphs.  Its exact bases are
`3` for the q=8 mixed ten-parent fibre, `3/2/2/2` for the four nontrivial q=9 fibres, and `3` for
the q=11 conic child; all q=13 and other nonempty residual fibres are child-rigid.  Empty children
and q=7's two-point conic-complement fibre are the complete impossible table.

## Closed base — C491

[`C491 redundancy-five classification`](../2026-07-22-c491-prs-redundancy-five.md) closes the
2019-announced `k=q-4` case after a NOT-PRE-EMPTED
[literature audit](../2026-07-22-c491-prs-redundancy-five-literature-audit.md).  The covering
radius is 4 unconditionally for all prime powers q>=7 (Seroussi--Roth range, both parities).
A characteristic-free Hankel criterion turns deep holes into pencils of binary cubics without a
split squarefree member, and the classification is exceptional-cover arithmetic of the induced
degree-3 map: tangent and sigma-secant strata (the ZWK families) from pencil gcds; osculating-pair
intersection points deep exactly per q mod 3 (rational pair at q=2 mod 3, conjugate pair at
q=1 mod 3); in characteristic 3 all osculating planes concur at a PGL₂-fixed nucleus deep hole and
a wild Artin--Schreier family of size (q²−1)/2 with stabilizer 2q is deep on the nonsquare class;
geometric-S₃ pencils have a split member for every prime power q>=23 via Aubry--Perret on the
(2,2) fiber-square curve — a threshold that exactly matches the observed sporadic boundary.  A
two-implementation exhaustive census over all nineteen prime powers 7<=q<=49 certifies every
field below the bound (and double-certifies 23..49), giving the complete sporadic tables at
q in {7,8,9,11,13,17,19} (empty otherwise, including q=16).  Totals: q²(q+3)/2, q(q+1)(q+2)/2, and (q³+3q²+q+1)/2 in characteristic 3.  Evidence
bundle: census generator/JSON, independent replay, and SHA-256 manifest, committed together.

Task card: `notes/reed-solomon-tasks/c491-prs-redundancy-five.md`.

## Closed base — C499

[`C499 sporadic pencil structure`](../2026-07-22-c499-sporadic-pencil-structure.md) gives the
intrinsic structure of every C491 sporadic deep-hole orbit at q in {7,8,9,11,13,17,19}, reconstructed
from the frozen census representatives (no regeneration).  One invariant classifies them all: the
Frobenius orbit type of the degree-3-cover branch divisor Delta(lambda), refined by j-invariant, into
five normal forms.  The stab-12 orbits (q=7,13,19) are exactly the equianharmonic (j=0, I(Delta)=0)
pencils with stabilizer A4 -- the redundancy-five analogue of the O+/O- q-mod-3 dichotomy; their
constant "4 double-root + 4 irreducible" profile is each a single stabilizer-orbit on the pencil
line.  The three q=8 size-252 orbits are one free Gal(F_8/F_2)=C3 torsor on the a4 cubic-twist label,
a structural parallel to C484's colour C3 (same Galois group, free and information-lossy, not
Gale/Hilbert-90).  Verdict: uniform structure, but sporadic deepness is a bounded-q accident -- the
equianharmonic orbit persists as a PGL2-orbit for every q=1 mod 3 (constructed at q=25,31,37,43,49)
yet is deep only at q in {7,13,19}.  Both C491 discovery-track leads settled.

## Closed base — C498

[`C498 redundancy-six calibration`](../2026-07-22-c498-prs-redundancy-six.md) gives an exhaustive
definition/Hankel census for every tested prime power q<=27.  The persistent quadratic-gcd
tangent/sigma stratum has q(q+1)^2/2 points.  Trivial-gcd exceptional orbit counts are
18/11/4/2/1 at q=7/8/9/11/13 and zero at q=16/17/19/23/25/27; covering radius is 5 throughout,
including q=7,8.  The atomic Rust/JSON/Python evidence bundle is complete.  A Tao closeout corrects
the proposed theoretical object: two rational roots of a quartic do not force the residual
quadratic to split, so the next gate is the off-diagonal ordered-triple collinearity surface
det(phi_W(t1),phi_W(t2),phi_W(t3))=0 (or its ordered-pair discriminant double cover), not the plain
fiber-square.  After division by the three diagonal brackets the residual is a symmetric (2,2,2)
surface, generically K3, with quadric Sym^3(P1) quotient.  Classify its reducible/singular and
degree-2-to-conic cases, then apply the K3 22q bound off the bad curves on the generic stratum.
The quotient has now been made exact: for a binary cubic `g`, it is the rank-three Hankel cone
`L0(g)L2(g)-L1(g)^2=0`.  This exposes the first genuine infinite exception.  In characteristic two,
the net `<1,t,t^4>` generates the full invariant 3-nucleus line, one `PGL2` and `PGammaL2` orbit of
`q+1` deep directions exactly for `q=2^m` with `m` odd; it recurs at q=32, so the census gap
through 27 is not asymptotic vanishing.
The same trinomial normal form has one isolated odd-characteristic echo: it is deep exactly at
q=11 because six collision lines exhaust the twelve rational points of a conic.  This classifies
one of the two q=11 exceptional orbits.
The other q=11 orbit is the nonsquare split-involution class
`W=<u,tu,u^2+5>`, `u=t^2-2`: all fifteen ordered rational split-quadratic factor candidates share
a root.  The same interior normal form accounts for two q=7 orbits.  C502's hexad detector is not a
C498 input: neither q=11 stabilizer is `A5`, both PGL orbits are PSL-transitive, and the full
projective equivalence already quotients the outer bit.
A Tao re-foundation identifies C498 with a line problem inside C491: choosing the fourth factor
`t-r` gives the cubic-pencil syndrome
`b(r)=(a1-r a0,...,a5-r a4)`, and these points trace the Hankel-row line in `P4`.  The K3 is the
family of C491 fiber-square curves over that line.  Any `S3` fibre gives a split quartic for
`q>=29` after the pointed-root deletion.  The next gate is therefore the Fano-scheme
classification of coherently parameterized first-polar lines contained in the C491
exceptional/pointed-collision locus, followed by the remaining `16/10/4/0/1` small-field orbit
normal forms.
The third-order close completes the characteristic-at-least-five existence theorem.  The pullback
of C491's secant cubic is the cubic of maximal minors of the quintic `3x4` catalecticant, so it
costs at most 3 points off the quadratic-gcd stratum; the tame cyclic projected Veronese costs at
most 4; pointed `g^2_4` ramification costs at most 6.  Hence no trivial-gcd exception exists for
`p>=5, q>=29`; the census closes the lower band and shows the exact deep set is the quadratic-gcd
stratum for every such field with `q>=17`.
The fourth-order close completes the all-field existence/orbit-count theorem.  In characteristic
three the C491 wild locus is the degree-four cone joining the fixed nucleus to the quartic NRC, but
no ruling satisfies the consecutive-row polar-line equations.  In characteristic two the cyclic
locus is the plane `<e1,e2,e3>`, and its unique polar-line component is exactly the C498
3-nucleus line `<e2,e3>`.  Thus the only large-field trivial-gcd exceptions are its `q+1` points
for `q=2^m`, odd `m>=5`; q=7/8/9/11/13 have the certified `18/11/4/2/1` tables, and no others
occur.
The persistent-stratum splitting is uniform too.  Tangent fibres form one PGL2 orbit unless
`p=5`, when the modular fixed point and nonzero part give two.  Sigma fibres are the norm-one
torus modulo fifth powers and inversion: one orbit if `5` does not divide `q+1`, otherwise three
with stabilizers `10,5,5`; Frobenius acts by multiplication by `p` on `C5`.  The replay asserts all
resulting orbit sizes and semilinear cycle counts.
The same first-polar recursion makes redundancy seven the cheapest new case: its sextic polar line
lies in C498 syndrome space.  Its exact entry gate is a pointed C498 lifting lemma and the
classification of polar lines contained in the quadratic-gcd/nucleus loci.
C509 has now passed its claim-specific audit and proves the exact pointed contraction identity.
Containment in C498's catalecticant secant closure is equivalent to sextic catalecticant rank at
most two; removing rank one and rational-split secants leaves the persistent tangent/sigma deep
stratum.  Its orbit law is `T/T^6` modulo inversion and Frobenius, replayed at q=4/5/7/8/9, and the
C498 characteristic-two nucleus line contracts to the central sextic point.  The active gate is
the prescribed-root collision divisor, not a full `P6` census.  The central point is now deep
exactly for odd characteristic-two extension degree (`t^4+t` is the even-degree witness), and
adding a second six-point deletion to C498's S3 fibre proof gives a pointed trivial-gcd theorem for
`q>=37`.  A bidegree union bound handles gcd-one common roots away from the marked point, while
marked equality is ramification of a separable `g^3_5` and costs at most eight parameters.
Therefore the q>=37 deep set is exactly the persistent tangent/sigma stratum plus the central
fixed point in odd characteristic-two extension degree.  The exact marked-polar affine-orbit
calibration closes every q<37 without scanning `P6`: exceptional deep orbits occur exactly at
q=7/8/9/11, while every q>=13 has only the persistent stratum and the odd-degree
characteristic-two central point.  The q=19 pointed locus has one transient size-19 orbit
`W=<1,t^3,t^4>` whose six split members all contain the marked point, but it cannot synchronize
into a sextic polar line.  C417's additive-cocycle lemma explains the tangent split intrinsically:
the Borel translation coefficient is 6, so exactly characteristics two and three split as
`1+(q-1)`.  C498/C509 now expose the higher-value successor theorem: coherently parameterized
polar flags should be persistent/modular when contained in the lower bad locus and
  arithmetically bounded otherwise.  C512 now proves this general theorem.

The final small exceptional normal-form theorem
(`notes/2026-07-23-c498-small-exceptional-normal-forms.md`)
classifies the bounded residue intrinsically.  The pointed first-polar quotient-pencil profile
collapses to the shared-root collision energy of `1+3` net members.  Supplemented only in odd
characteristic by the quintic root type, it separates the frozen classes up to exactly Frobenius
fusion.  The energy is also the polar-free pair-gcd count inside the quartic net.
More sharply, zero `1+3` mass on the all-field trivial-gcd deep set is exactly the recurring
characteristic-two `3`-nucleus orbit; the q=11 trinomial echo has mass 40 and energy 60.
The root-collision graph is a disjoint union of cliques by marked root, and its factorial clique
counts recover the complete root-load spectrum by binomial inversion; C498 needs only orders one
and two.
Irreducible cubics are Frobenius `3`-cycles, with indicator
`(chi_triv+chi_sign-chi_std)/3`; the energy hierarchy is therefore a hierarchy of Chebotarev
character correlations, not an unqualified raw fibre-product point count.
Thus the q=7/8/9/11/13 tables compress from `18/11/4/2/1` PGL2 orbits to
`18/5/2/2/1` PGammaL2 normal forms.  The atomic generator/JSON/checksum bundle passes, and C498 has
no remaining theorem or classification gap.

## Closed base — C512

`notes/2026-07-23-c512-general-polar-flag-theorem.md` constructs the
pointed contraction functor over arbitrary base schemes in divided-power coordinates, including
infinity, base change, iterated markers, and the forbidden diagonal.  Its contained-or-transverse
theorem is effective: if the lower identity-Frobenius twist has genus `g` and deletion degree
`delta`, and the polar line has transverse/collision budget `b+c`, then
`max(floor((g+sqrt(g^2+delta))^2)+1,b+c)` bounds every nonpersistent split-free field.  Persistent
flags are exactly catalecticant rank-two tangent/sigma components with `T/T^(r-1)` modulo
inversion/Frobenius and tangent cocycle `u*z=z+(r-1)u`; modular-nucleus flags are the explicit
contraction kernels into Lucas-computed NRC nuclei.  C498/C509 are verified with thresholds 29/37,
and q=19's `<1,t^3,t^4>` orbit proves that individual bad contractions cannot replace coherent
flags.  The only remaining general gap is level-specific geometric monodromy/absolute
irreducibility of each new lower splitting cover, stated exactly rather than replaced by a census.
The claim-specific audit `notes/2026-07-23-c512-general-polar-flag-literature-audit.md` finds no
pre-emption and positions Wang's June 2026 splitting-family framework as arithmetic infrastructure.

## Closed base — C513

`notes/2026-07-23-c513-prs-redundancy-eight.md` proves the first new fixed-level application of
C512.  The three-marker geometric-`S3` normalization has deletion degree 30; the exact Hasse--Weil
inequality lowers the first prime-power threshold to 43.  The top polar line has
transverse/collision budget 14.  Every contained modular-nucleus lift is shallow in this range, so
the deep syndromes are exactly the persistent tangent and conjugate-sigma rank-two families,
totaling `q(q+1)^2/2`, with orbit law `T/T^7` modulo inversion/Frobenius and tangent cocycle
`z→z+7u`; the four arithmetic cases have exact `PGL2/PGammaL2` orbit counts
`2/2`, `3/3`, `5/5`, and `5/3`.  The theorem uses no ambient `PG(7,q)` census.  A redundancy-nine Lucas probe is logged
only as an incidental successor lead; its second-order refinement makes the characteristic-five
lift shallow and identifies the unresolved characteristic-seven four-space with the binary-quartic
representation, the `p=7` member of the exact prime-diagonal series
`P(det^2 tensor Sym^(p-3)(E))`.  The third-order close separates a uniform generic spine with
integer threshold `6n-10+floor(2sqrt(6n-12))` from this prime-diagonal modular spine, whose common
kernel is a nonsquarefree `p`-th-power pencil.  At `q=p=7`, the modular carrier is deep exactly on
the 819 rootless projective binary quartics.  The attempted `q=49` residual-quadratic witness fails
the squarefreeness gate because its roots collide with the fixed `F_7` quintic; rootless
sufficiency over larger fields remains open.  The next bounded gate is the residual-quadratic
discriminant together with its determinant, diagonal, and collision divisors across quartic
`PGL2` orbits.

## Closed base — C516

`notes/2026-07-23-c516-prs-redundancy-nine.md` derives the exact residual determinant,
trace/norm numerators, branch, diagonal, and collision resultant. Six squarefree binary-quartic
normal slices have unit discriminant gcd, and every multiple-root normal form has an integral
reduced genus-at-most-one slice, so there is no exceptional quartic orbit. The characteristic-seven
carrier is deep exactly on the 819 rootless quartics at q=7, entirely shallow at q=49, and uniformly
shallow for q>=343. Hence for every prime power q>=53 the deep syndromes of `PRS(q-8)` are exactly
the persistent tangent and conjugate-sigma families, totaling `q(q+1)^2/2`, with orbit law `T/T^8`
modulo inversion/Frobenius, tangent cocycle `z→z+8u`, and exact PGL/PGamma counts
`2/2`, `3/3`, `4/4`, `6/6`, or `6/5`. The theorem/certificate boundary is frozen for C517.

## Closed base — C517

`notes/2026-07-23-c517-prs-redundancy-nine-lean.md` formalizes divided-power marker contraction,
the complete residual-quadratic Hankel/discriminant/root algebra, and an explicit synthesis
interface with no hidden geometric axioms. The terminal theorem derives split squarefree witnesses
off the persistent locus, the exact equivalence between deepness and the tangent/sigma union,
cardinality `q(q+1)^2/2`, and the six-case PGL/PGamma orbit table from named component,
rational-point, deletion, coding, and exhaustion hypotheses. The import gate and its fourteen-
terminal axiom audit pass; only standard Lean/mathlib axioms appear.

## Closed base — C510

`notes/2026-07-23-c510-trs-deep-hole-pilot.md` reconciles the 2024 full-length and 2025 punctured
last-hook families as the same rank-one tangent projection of the NRC.  A 2026 forward citation
pre-empts the translation-equivalent `p∤k` range; the first surviving target is the modular
full-length locus `p|k`.  Its affine stabilizer law is `a+(q-k)bθ=1`, so exactly on that locus the
curve retains the full additive translation group and a canonical fixed standard-syndrome line.
Lucas-maximal exponents give the exact fixed space before projection and warn that higher
redundancies can have a larger modular fixed flag; quotient invariants may add a connecting class.
Independent exact enumerations at `q=9,k=3` find only that standard projective deep-hole direction,
and prove it is the entire common translation-fixed space.  C514 owns the translation-quotient
determinant normal form and pointed-polar-recursion gate; no broader TRS classification or field
census is authorized.

## Closed base — C514

`notes/2026-07-23-c514-modular-trs-translation-quotient.md` closes the modular one-twist theorem
gate without a field census.  Every support has a canonical completion root
`r=1-sum(T)`; translating it to zero gives the exact quotient slice `U=T-r` with
`sum(U)=1`, and the coefficients of `Q_U` are an explicit invariant normal form for every
support determinant.  The quotient action groupoid retains Frobenius and syndrome transporters.
The fixed syndrome space is exactly the Lucas-maximal flag in the degree-`s` NRC module modulo
the tangent projection centre: the possible characteristic-`p` connecting class vanishes.
There is no universal C512 recursion.  The annihilator line must satisfy an explicit
consecutive-Hankel-row rank condition that generic syndromes fail, and valid supports allow the
completion root to collide with a support point, whereas C512 must delete that pointed-marker
divisor.  The refreshed three-graph citation audit finds no predecessor for this bounded quotient
claim.  No standard-only deep-hole classification or alternative recursion is asserted.
Two requested extra-juice rounds sharpen the entry to C515.  Every `(s-1)`-support has trivial
translation stabilizer because its sum changes by `-b`; finite differences satisfy the exact
augmentation identity `Delta_b F_y=F_{(A_-b-1)y}`.  The completion-collision boundary is the
trace-one configuration `U={0} union V` in `G_m`, with determinant member `X^2 Q_V`, so a
successor must treat it as recursive boundary data rather than delete it.

## Closed base — C515

`notes/2026-07-23-c515-modular-trs-hasse-recursion.md` derives the complete modular Hasse normal
form and exact finite-difference identity for C514's incidence polynomial.  The first operator
level is the Lucas filtration, and additive-degree-one endpoints have the full adjoint-kernel
trace criterion, specializing to the Artin--Schreier trace condition.  This does not recurse
deep-hole avoidance: a difference zero says that two determinant values agree, not that either
vanishes, and the standard fixed syndrome gives the sharp terminal counterexample.  The natural
polar-compatible syndromes form a ruled locus of dimension at most two; it contains the standard
line but misses every pure additional Lucas-maximal direction.  Those fixed endpoints are exact
elementary-symmetric nonvanishing problems on trace-one configurations.  The collision boundary
remains `X^2Q_V`.  A requested Tao audit separates Lucas Hasse index from augmentation depth and
adds the exact multiplicative orbit norm `Res(R^q-R,F_y)`, which eliminates the translation
coordinate without losing zero incidence; on linearized endpoints it factors through the image
linearized polynomial and recovers the full trace obstruction.  Any successor needs a global
component theorem for the trace-one incidence variety, or for its quotient together with the exact
rational lifting condition, not another local difference operator or a census.  The norm is an
exact finite-field zero detector but is visibly a product of its translated incidence factors, so
its whole hypersurface is not an absolute-irreducibility target.
A requested extra-juice refinement stratifies by the additive syndrome stabilizer `H_y`.
The full orbit resultant is the forced `|H_y|`-th power of a reduced coset norm; hence it is
inseparable on every nontrivial stabilizer stratum.  On the full fixed flag its reduced equation
is exactly the elementary-symmetric test and the unreduced multiplicity is `q`.  Removing that
forced power still leaves a product over distinct cosets; global geometry must therefore study
its component union or the corresponding quotient incidence, not assert irreducibility of the
raw or reduced resultant.

## Closed base — C518

`notes/2026-07-23-c518-modular-trs-global-incidence.md` closes at the task's allowed obstruction
exit.  Complement duality turns every extra Lucas-fixed endpoint into a `k+1`-point ordered
Frobenius alternant with exponent `(floor(k/p^l)+1)p^l+1`.  Every binary `k=2` endpoint is
uniformly shallow: the report parametrizes and counts the complete binary carrier, and proves
that every one of its zeros lies on the valid completion/support collision boundary.  The ordered
binary carrier is a rational open curve with exact reduced deletion degree; its free `S3`
ordering torsor has identity/transposition/three-cycle Frobenius types, and only the identity
type lifts a quotient point to a rational support.  A fixed-subfield criterion closes a further
range for `k>=3`.  The residual-quadratic slice has exact determinant, branch, diagonal,
fixed-root resultant, valid completion-collision semantics, and Kummer/Artin--Schreier lifting
classes.  A Tao audit semilinearizes every high Lucas level `p^l>k`: its generic ordered carrier
is rational with an explicit inverse, and its exceptional equations are the consecutive Schur
divisors `h_r=0` and `s_(r,1)=0`.  A further extra-juice pass proves consecutive `h_r,h_(r+1)`
coprime, so the vertical family is lower-dimensional and the rational component is uniquely
top-dimensional.  It also gives the effective shallow gate
`q > binom(k+1,2)+2(p^l-k)`, including every `k=3` endpoint uniformly.  The remaining gates are
low-level component geometry, bounded high-level fields below that gate, and rational avoidance
of the ordering and residual torsors for general syndromes.  A second-order pass handles the
asymptotically awkward characteristic-two top level by square-root reparametrization: its
endpoint is a fixed Schur equation of degree `k(k-3)/2+3`.  At `k=4` it is exactly the five-point
system `sum(V)=sum(1/V)=1`, and an `F4`-coset/rational two-parameter construction clears every
field where it occurs.  The first possible persistent fixed endpoint is now `k>=6`.  No universal
TRS synthesis or field census is justified.  These carriers are an unallocated future successor;
C519 remains the separately owned arbitrary-redundancy residual-discriminant task.

## Closed base — C519

`notes/2026-07-23-c519-universal-residual-discriminant.md` constructs the four-contraction map,
derives the integral divided-power binary-cubic discriminant, and proves the first additional
modular component.  In characteristic two the discriminant scheme is the doubled smooth quadric
`(AD+BC)^2`; its reduced quadric is the twisted-cubic tangent developable.  Hence every syndrome
pullback is square, including rank-three/four examples outside the frozen persistent and
Lucas-nucleus carriers at `n=5,6,7,8`.  The zero pullbacks are exactly images that are a quadric
point or a line in one of its rulings.  Residual splitting off `DN_s=0` is instead the
Artin--Schreier class `D N_u/N_s^2`.  Characteristic three retains an irreducible quartic but has a
Frobenius-thickened twisted-cubic singular scheme.  A `B=0,C=1,D=1` specialization gives class
`1/A`, proving that the generic Artin--Schreier replacement is geometrically integral; only its
Hankel/root-compatible pullback remains.  Intrinsically, the residual quadratic is the divided
Hessian and this Artin--Schreier class is its Arf invariant, so the successor gate is a
Hessian--Arf pullback classification.  A second-order close proves that every root-compatible
pencil gives a bidegree-`(2,2)` ordered-Hessian incidence curve in `P1 x P1`, restoring arithmetic
genus at most one in the correct characteristic-two model.  This fires the task card's authorized modular
stop rule before Hasse--Weil.  The exact unallocated successors are the characteristic-two
root-compatible Artin--Schreier carrier and the odd-characteristic pullback/line classification;
neither may be replaced by a fixed-level census.

## Closed base — C529

`notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.md` computes every nonzero
consecutive-row Lucas overlap through the first fresh level and proves the infinite family
`P<e_2,...,e_(2^s-1)>`.  The distinguished `e_(2^s-1)` kernel contains
`<1,t,t^(2^s)>`; its normalized ordered-root cover has geometric monodromy
`AGL_1(F_(2^s))`, minimal constant field `F_(2^s)`, based deck group `C_(2^s-1)`, and a split
member exactly when `s|m`.  This recovers C498/C509 at
`s=2`.  At `s=3`, Frobenius has order three on the components, disproving a stable parity law and
closing C529 at its mandatory obstruction exit.  Deepness for `3∤m` needs normalization of the
four-dimensional quotient cover; C530 closes exactly that calculation at `e_7`.

## Closed base — C530

`notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.md` computes the exact Borel stabilizer
and Lucas orbit of `e_7`.  After framing two roots as `0,1`, the four-dimensional quotient
incidence normalizes to the geometrically integral nonconstant Artin--Schreier cover
`y^2+y=p/h^2`, with exact trace lifting law and every repeated-root/collision boundary explicit.
The `F8`-linear C529 cover is not a component: the quotient directions `t^2,t^4` enlarge it to
the additive-affine subcover with geometric monodromy `AGL_3(F2)`.  Three-dimensional `F2`
subspace polynomials give split squarefree members over every `F_(2^m)` with `m>=3`, so the entire
`PGL2` orbit of `e_7` is shallow over every admissible field, including all `3∤m`.  This fires
C530's prescribed nonconstant Artin--Schreier/extra-monodromy stop before other carrier strata.

## Execution ladder

| Step | Target | Entry gate | Exit gate | Level unlocked |
|---|---|---|---|---|
| C475 | Veronese factorization, torus quotient, and semilinear descent | complete | four-cycles generate; rank two reconstructs; rank one needs its radical | finite atlas is well-defined |
| C476 | all six-point GRS supports for `q in {5,7,8,9,11}` | complete | first collision is the q=11 rank-one `2+4` radical split | honest exceptional mechanism |
| C477 | intrinsic theorem for C476's first collision | complete | Klein branch split, sharp stabilizer bit, and exact continuation graphs | candidate discriminant geometry |
| C478 | C398 and `A3/B3/H3` exceptional controls | complete | coherent Galois-equivariant atlases recover all frozen parents with thresholds `3 / 3 / 2 / 3`; Gram/Sylow still separate q=9 from q=11 | simultaneous reconstruction is the next theorem gate |
| C481 | projection-sextic and coherent-atlas theorem | complete | labelled `M_0,6` with explicit inverses and exact diagonal/Frobenius actions | intrinsic coherent data model |
| C482 | multi-centre gauge synchronization | complete | residual dimensions `2/1`; explicit four-view separable quadratic cover; rational inverse disproved | exact generic ambiguity |
| C483 | reconstruction discriminant and exceptional fibres | complete | Gale association; conic branch divisor; cubic residual-family table; exact complete-child cut | global theorem domain |
| C484 | coherent semilinear descent | complete | Kummer/Artin--Schreier sheet class; finite-stabilizer criterion; q=8 colour Frobenius is `3+3` | all-field semilinear reconstruction |
| C485 | all-field redundancy-three synthesis | complete | exact pure/child-relative clauses, algorithm, exceptions, descent, GRS specialization, and `q>=16` child rigidity | programme-level reconstruction theorem |
| C490 | `q<=13` complete-child closure | complete | exact bases for every recoverable fibre; empty-child and q=7 two-point exceptions; collision hypergraphs and NRC bridge ledger | classified all-field child-relative theorem |
| C491 | PRS redundancy-five classification | complete | unconditional covering radius; complete PΓL₂ classification with new O±/nucleus/wild families and certified sporadic tables; NRC bridge ledger with the redundancy-six net lemma as next gate | first higher-normal-rational-curve calibration |
| C498 | PRS redundancy-six classification | complete | first-polar line reduction; all-field persistent/modular theorem; exact exceptional fields and intrinsic semilinear normal forms | polar induction mechanism |
| C509 | PRS redundancy-seven classification | complete | all-field persistent/central theorem; exact q=7/8/9/11 exception tables; q=19 transient pointed orbit | coherent polar flags, not isolated bad fibres |
| C512 | general coherent polar induction | complete | intrinsic pointed functor; classified persistent/modular contained flags; explicit genus/deletion/intersection threshold; C498/C509 recovered | fixed-redundancy applications reduce to finite monodromy and containment checks |
| C513 | PRS redundancy-eight application | complete | exact three-marker normalization and containment package; `q>=43` persistent-only theorem with complete PGL/PGamma orbit law | first post-C512 fixed-level theorem |
| C510 | bounded one-twist audit and geometry pilot | complete | tangent-projected NRC; exact affine stabilizer and fixed line; `p∤k` pre-emption; modular `p|k` target; q=9 calibration | translation-quotient theorem gate |
| C514 | modular one-twist translation quotient | complete | canonical completion-root slice; exact Lucas fixed flag; consecutive-row and marker-collision obstruction to C512 | a different splitting mechanism is required |
| C515 | modular additive/Hasse recursion | complete | exact Lucas/Hasse filtration, reduced stabilizer-stratified orbit norm, and trace endpoints; differences do not lift support zeros; polar ruled locus classified | global reduced-norm/incidence geometry is required |
| C516 | PRS redundancy-nine residual-quadratic theorem | complete | binary-quartic quotient; divisor/component theorem; characteristic-seven carrier | fixed-level theorem |
| C517 | Lean formalization of C516 | complete | residual algebra and exact synthesis implication; explicit geometric/coding hypotheses; green gate and axiom audit | kernel-checked PRS theorem boundary |
| C518 | modular TRS trace-one global incidence | complete | complement Frobenius alternants; binary and subfield shallow theorems; exact residual lifting torsor | first proved global obstruction |
| C519 | universal residual-discriminant base locus | complete (obstruction exit) | integral pullback; doubled-quadric characteristic-two component; exact Artin--Schreier replacement gate | first additional component |
| C525 | characteristic-two ordered-Hessian pullback | complete | universal Veronese/ruling classification; constrained carrier equality; linear base-selection route; genus-one containment theorem | arbitrary-degree characteristic-two obstruction classified |
| C529 | characteristic-two Lucas-carrier arithmetic | complete (obstruction exit) | power-of-two carrier family; exact linearized ordered-root cover; C498/C509 recovered; first fresh level has order-three Frobenius | parity law fails intrinsically; C530 owns quotient-cover arithmetic |
| C530 | degree-nine `e_7` quotient cover | complete (obstruction exit) | nonconstant Artin--Schreier normalization; `AGL_3(F2)` additive subcover; orbit shallow over every admissible field | exact distinguished-orbit arithmetic | closed `e_7` theorem boundary |
| C531 | full degree-nine Lucas-carrier strata | queued next | closed `e_7` theorem boundary | intrinsic `PGL2` strata and tractable cover arithmetic | carrier theorem boundary |
| C532 | PRS redundancy-ten synthesis | queued after C531 | degree-nine carrier theorem boundary | effective high-field deep set, threshold, and orbit law | fixed-level theorem |
| C533 | C525 threshold/deletion sharpening | queued independently | frozen C525 equations | smaller hitting/deletion constants or a sharp method obstruction | improved arbitrary-degree bound |

Closed cards include `notes/reed-solomon-tasks/c476-standard-grs-atlas-pilot.md` through
`notes/reed-solomon-tasks/c491-prs-redundancy-five.md` and
`notes/reed-solomon-tasks/c498-prs-redundancy-six.md` and
`notes/reed-solomon-tasks/c509-prs-redundancy-seven.md`.

## Unallocated level-ups

- **Higher-order MDS/list decoding:** allocate only if atlas fibres or their adjacency recover the
  simultaneous-extension complex from C295; one-column extension data alone does not pass.
- **Twisted Reed--Solomon:** C514 closes C510's translation quotient with an exact
  translation-invariant determinant normal form and a precise obstruction to C512.  C515 closes
  the additive/Hasse alternative: its filtration and trace endpoints are exact, but differences
  do not preserve zero incidence.  C518 closes the bounded global successor by dualizing the fixed
  endpoints to explicit Frobenius-alternant carriers, proving the binary and fixed-subfield shallow
  ranges, and isolating the exact residual Kummer/Artin--Schreier lift.  The remaining general
  alternant component is unallocated; the reduced stabilizer-stratified coset norm remains only a
  component union, the completion/support collision divisor remains valid, and no all-TRS claim is
  allocated.
- **Modular/category/type bridge:** allocate only if C478 produces a nondegenerate complementary
  incidence carrier passing both the Gram and Sylow endotrivial gates.
- **Further polar-flag applications:** C516 closes the redundancy-nine residual-quadratic cover
  and characteristic-seven binary-quartic carrier. C517 owns its Lean formalization against the
  frozen theorem boundary. C519 identifies the arbitrary-redundancy characteristic-two
  discriminant obstruction, and C525 closes its ordered-Hessian replacement: the only nontrivial
  contained pullback is the persistent/Lucas union, with an effective genus-one slice outside it.
  C529 selects the coherent power-of-two Lucas family and stops at its first intrinsic
  level-dependent obstruction: the degree-nine carrier has an order-three constant-field cycle.
  C530 closes the distinguished `e_7` quotient: a nonconstant Artin--Schreier generic layer and
  larger `AGL_3(F2)` additive cover make that full orbit shallow over every admissible field.
  C531 owns extension to other intrinsic `PGL2` normal forms, and C532 owns the resulting
  redundancy-ten synthesis.  C533 separately sharpens C525's bound.  No ambient census substitutes
  for any of these calculations.

**Achieved ceiling:** C485 gives the all-field redundancy-three orbit reconstruction; C490 closes
its bounded residual child clause; C491 closes the redundancy-five projective deep-hole
classification (the 2019-announced case), the first result past redundancy four and the first with
arithmetic (q mod 3 / square-class) deep-hole families.  C498 closes the redundancy-six all-field
existence/orbit-count theorem and identifies the pointed C498 polar-line lemma as the
redundancy-seven gate.  None of these is the general Reed--Solomon deep-hole conjecture.

## Boundaries

- This lane owns Reed--Solomon/GRS deep-hole and one-column MDS-extension invariants arising from
  the C398/C474 bridge.
- It does not own further Clebsch, crowns, type-theory, or stable-module development. Cross-lane
  consequences require their own routing and may not mutate the crowns handoff.
- Literature priority or a claim of progress on a famous conjecture requires a dedicated current
  literature audit. The present task is an internal theorem-and-discriminator programme.
- Avoid an unstructured field census. Normalize first, prove the group action, and enumerate only
  the resulting bounded quotient.
- No successor may enlarge C476's field/support domain. A larger range requires a theorem-derived
  bound and a newly allocated task.

Companions: [discovery log](../2026-07-22-reed-solomon-discovery-track.md) for incidental leads;
[session archive](done/2026-07-22-reed-solomon-deep-holes-archive.md) for dated or superseded lane
history.

## Next command

`go C531`

(C531 is next. C500 remains release-gated.)
