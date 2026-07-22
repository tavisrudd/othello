# Clebsch / Weil-roof proof-and-evidence audit

**Date:** 2026-07-21

**Lane:** `clebsch`, auditing the read-only `crowns` Weil-roof battery

**Scope:** final landed state of C440--C468 during the preceding 24 hours, excluding the Clebsch
Lean campaign C420--C428.  C465 has no landed result.  The later C469 allocation is an open task,
not evidence audited here.

## Executive verdict

The battery is mathematically much healthier than its speed of production might suggest.  The
reports consistently distinguish exact finite conclusions, standard mathematical input, failed
routes, and open interpretation.  Accepting the committed computations and hashes as stipulated,
the exact finite conclusions are justified at their stated scope.

The stronger answer to “is everything proved to our standard and ready for Lean?” is **not yet,
uniformly**:

- A large majority of the rows have a direct algebraic, combinatorial, or finite-enumeration core
  whose theorem statement and certificate boundary are clear enough to begin Lean formalization.
- Several rows are sound mixed-verification results but use a load-bearing standard theorem or an
  external representation/algebraic-geometry interface not proved in the bundle.  They are ready
  for *formalization planning*, not yet for a truthful claim that the complete conclusion can be
  transcribed into Lean without first building that interface.
- C453 is a correct conditional arithmetic law.  It proves what supplied golden parent data would
  do; it does not construct continuation objects.
- C443 and C461 are successful negative results.  They close specified construction routes and
  must not be paraphrased as nonexistence of every possible integral tensor.
- C468's exact counts and Frobenius polynomials are strongly certified, but the cohomological trace,
  functional-equation, Newton-polygon, and intermediate-Jacobian interpretations form a major
  formalization project of their own.  C468 is not a near-term “finite leaf.”

The audit found and corrected one substantive wording defect in the compact result ledger.  Its
C443+C461 row had said that a “literal integral secant-product tensor does not commute with
reduction,” although C443 stops before constructing such a tensor.  The corrected row now says
exactly what is proved: the specified M3a construction has four companions rather than a unique
one, the canonical conjugate-pair averages already miss the degree-one target, and C461 gives zero
kernel for every permitted linear weighting.

## Audit standard

This review separates four notions that should not be conflated:

1. **Exact finite certificate:** exhaustive arithmetic or enumeration proves a proposition about
   the frozen objects and stated finite domain.
2. **Mathematical proof:** a displayed argument reduces the conclusion to elementary or named
   standard theorems, with computation supplying only finite leaves.
3. **Mixed-verification theorem:** the finite leaf is exact, but an external theorem or trusted
   software interface remains in the proof boundary.
4. **Lean-ready theorem:** definitions, hypotheses, conclusion, and all noncomputational bridge
   lemmas are sufficiently explicit to become a Lean target without inventing missing mathematics.

The user's witnessed double replay and the committed hashes are accepted here.  This audit does not
make a third replay a gate.  It instead asks whether the conclusion follows from what the checker
actually checks and from the external mathematics the report openly names.

Lean-readiness labels below mean:

- **L1:** direct finite/algebraic target; generate data or prove the small structural lemma.
- **L2:** sound target after a named library/interface packet is formalized.
- **L3:** major new formalization infrastructure; do not schedule as an ordinary finite leaf.
- **N/A:** no positive theorem landed.

## Result-by-result audit

| ID | Proof/evidence verdict | Lean readiness | Audit judgment and exact boundary |
|:---|:---|:---:|:---|
| C440 | **Green infrastructure** | L1 | Exact arithmetic freezes fields, roots, conics, groups, labels, and normalizations.  It is definition-level infrastructure, not a roof theorem.  Downstream theorems must import the frozen data rather than restate remembered coordinates. |
| C441 | **Green finite theorem** | L1 | The vertex-to-`P^1(F_q)` maps, bijections, equivariance checks, and block/coset behavior are exhaustive in the three frozen cases.  No all-rank or all-prime statement is made. |
| C442 | **Green only after C458** | L1/L2 | The unique invariant antipodal matching and its two reductions are exact.  C442's original amber defect was real: the C440 rational binary-form frame is sheet-blind.  C458 supplies the missing co-equal golden frame, so the combined C442+C458 claim is sound. |
| C443 | **Green sharp blocker** | L1 | It proves four companion orbits instead of one and failure of the two canonical pair averages at degree one.  It deliberately does not construct or test the proposed integral secant-product tensor.  Any broader “tensor fails to commute” wording is unsupported. |
| C444 | **Green finite theorem** | L1 | The two B3 reductions, opposite `PSL_2(7)` fibres, cubic signs, and A3 inert/Frobenius fusion are exact consequences of the frozen reduction tables and finite group/moment checks. |
| C445 | **Green mixed theorem** | L1/L2 | Orbit sizes, `A5` stabilizers, `A4` intersection, generated `PSL_2(11)`, `S4/A4` hinge, and the reduction of `Rz` are exact.  A complete formal theorem also needs the elementary orthogonal/spinor-norm bridge and explicit identifications of the finite matrix groups.  The paper-1 matching-level theorem is justified now. |
| C446 | **Green bounded negative** | L1 | All 41 frozen marker matchings were checked and none is concurrent.  The domain and stop condition are exact; this is not a nonexistence theorem for arbitrary matchings or arbitrary selectors. |
| C447 | **Green finite repair** | L1 | The failed singleton comparison, the 66-to-66 shared-edge bijection, stabilizers, and simultaneous endpoint/matching swap are exact.  The conclusion is orbit-valued and does not select a winning game move. |
| C448 | **Green theorem** | L1 | The no-equivariant-section lemma has a complete elementary proof.  C447/C460 instantiate it, and the q=5 copycat check is a separate finite control.  “One bit” means choice in a free two-fibre, not an information-theoretic lower bound for unrelated algorithms. |
| C449 | **Green theorem in the frozen rank-three cases** | L1 | Direct powers prove that each Coxeter square fills the split maximal torus and give the exact orbit blocks.  The characteristic-zero provenance is also checked on the frozen vertex groups.  No causal implication back to the arrangement-code equality is proved. |
| C450 | **Green mixed theorem** | L2 | Matrix ranks, Gram identities, outer exchange, and explicit relation actions are finite and direct.  Ordinary character decompositions and Weil naming use GAP plus Gérardin's degree theorem.  Before Lean, replace the GAP boundary by explicit matrix-submodule certificates or formal character-table lemmas.  No standalone small Weil module is obtained. |
| C451 | **Green mixed theorem, one theorem pin needed** | L2/L3 | The matching-Lagrangian construction, intersection census, zero Cartier--Manin matrices, and Arf computations are convincing and correctly scoped.  The move from zero Cartier--Manin/a-number `g` to “superspecial” uses a standard abelian-variety theorem that should be explicitly cited and isolated.  A Lean version also needs the hyperelliptic `J[2]` subset model and its odd-characteristic transfer. |
| C452 | **Green finite identification plus audited classical walls** | L1 | The QR difference sets, correlations, and Barker words are exact.  The Barker, perfect-code, and regular-polytope walls are literature claims with careful scope and source depth; they should be cited, not reproved as part of the finite Lean leaf. |
| C453 | **Green conditional theorem** | L1/L2 | The mod-40 partition follows from `(5/p)` and `(2/p)` under the frozen golden-marker/transporter hypotheses.  The claims at 13, 19, and 31 are predictions under those hypotheses, not constructions.  The density statement additionally invokes Dirichlet equidistribution and need not be in the formalized core. |
| C454 | **Green mixed positive/negative theorem** | L2 | The direct fixed-space and intersection ranks justify the failure of the Adler five-space bridge and the three-dimensional relative-cubic space.  The labels `L(8)`, `L(4)`, the ordinary character calculation, and cyclotomic Molien interpretation require representation-theory interfaces; formalization can avoid much of this by checking the explicit matrices. |
| C455 | **Green projective/restriction theorem** | L2/L3 | The three matrix restrictions, weighted self-adjointness, squares, eigenspaces, and common ambient Fourier operator are exact.  Calling the ambient operator a Weil Weyl operator with `rho(w)=iF` uses the standard Schrödinger model and Gauss-sum normalization.  The report correctly denies full restricted Weil modules.  Formalize the matrix theorem first and the Weil interpretation separately. |
| C456 | **Green exact equivalence** | L2 | The explicit monomial/projective map gives state equality after party permutation; the 60 maps and `A5` bitorsor are finite.  Lean needs a finite-field code-state and qudit Clifford interface, but no classification of arbitrary LU invariants is required for the stated collapse. |
| C457 | **Green mixed theorem, algebra lemma needed** | L2 | Multiplication tables, trace-Gram determinants, residue ranks, group closures, and equality with frozen stabilizers are exact.  “Unit reduced-trace discriminant implies maximal at every finite localization” is a standard quaternion-order theorem and must be pinned/proved before full Lean closure.  The result does not supply an `E8` or global Picard-family bridge. |
| C458 | **Green core; one explanatory paragraph remains external** | L2 | The two-frame theorem, golden reductions, matching identities, rational `Rz`, finite closure, and sheet-faithful/sheet-blind distinction are exact.  The Schur-index explanation is explicitly marked “structural/classical, not machine-verified here”; it needs a source and proof if promoted beyond motivation. |
| C459 | **Green mixed descent classification** | L2 | Exhausting the 60-transporter torsor, ten cocycles, one gauge orbit, the `S3` stabilizer, Hilbert-90 witness, rational conic/matching, and resolvent are exact.  Lean needs nonabelian descent and projective equivalence infrastructure.  The `D5` sentence should mean no form with a pointwise rational natural `D5`; it should not be read as excluding every twisted `D5` subgroup scheme without a separate argument. |
| C460 | **Green theorem** | L1/L2 | The coordinate involution proof establishes the uniform concurrency criterion, and the B3/H3 clouds, overlaps, bipartition, triangle, and ranks are exact.  Formalization needs only modest projective-conic and finite-group orbit infrastructure.  No Weil/code constituent follows from the incidence ranks. |
| C461 | **Green sharp blocker** | L1 | Full rank of the stacked degree-one/degree-two map proves zero kernel for the entire localized four-companion weight lattice.  It rules out every linear weighting of that family, not an abstract invariant cubic constructed by other means. |
| C462 | **Green finite action; mixed scheme wording** | L2 | The four-cycle, its square `kappa`, correction independence, residue-fibre swaps, and discrepancy vector are exact.  The finite-étale and descent formulation over localized integer rings uses standard scheme/Galois descent not encoded by the finite checker.  Formalize the finite `C4`-set first, then the integral torsor statement. |
| C463 | **Green theorem** | L1/L2 | The A3/B3 companion census, outer-`S6` pentad model, two `S5` parents, `S4` hinge, equivariant syntheme/outer-edge bijection, and edge flip are exhaustive finite combinatorics.  The `Q(i)` and invert-2 finite-étale qualification is correct but belongs in a separate algebraic lemma.  No cross-case bit-carrier law is proved. |
| C464 | **Green finite theorem** | L1 | Code dimensions, distances, weight distributions, duality, perfection, Steiner `4-(11,5,1)` closure, selected/residual designs, `K_11` edge formula, and the full projective support spectrum are exhaustive.  No ternary uniqueness, Witt/`M_11` action, or equivariant bridge to C450's 55-set is proved.  C469 is precisely the missing symmetry bridge. |
| C465 | **No landed result** | N/A | It must remain absent from result claims until a certified report lands. |
| C466 | **Green on its exact domain; mixed interpretation** | L1/L2 | The tested-prime fusion table, rational hinge mechanism, q=31 C395/golden projectivities, two `A5` torsors, norm-31 divisor, and failure of every lift modulo `31^2` are exact.  “First-order collision” is justified only in the displayed integral slice, as the report says.  The three quadratic characters give the triquadratic Frobenius package, but no common geometric/metaplectic carrier or H4 parent is proved. |
| C467 | **Green exact equivalence and finite pencil classification** | L2 | The signed Fourier identity proves fixed-party LC/LU equivalence, and explicit invariants separate the three q=11 pencil classes.  The uniform golden and inversion identities are polynomial.  The assertion that degree six is minimal uses the standard description of bidegree `(2,2)` pure-state invariants as marginal purities; isolate that lemma in Lean rather than burying it in enumeration. |
| C468 | **Green mixed-verification arithmetic; not a finite Lean leaf** | L3 | Smoothness has a direct proof.  Counts, traces, Frobenius polynomials, factorizations, Gauss products, recurrence, and field arithmetic are exact.  Passing from counts to `H^3`, using the weight-three functional equation, and interpreting slopes through the cubic-threefold intermediate Jacobian rely on substantial cohomological theorems.  Those claims are mathematically plausible and honestly placed in the trusted boundary, but the complete row is not ready for routine Lean transcription. |

## Cross-cutting proof findings

### 1. The central paper-1 close is sound

The C444+C445 matching-level theorem is the strongest clean close.  Its ingredients are explicit:
the A3 fusion control, B3 opposite fibres and cubic signs, H3 two prime reductions, their
`11+11` orbit gluing, `A5` intersection/generation, and the rational spinor-norm-2 transporter.
Nothing in C443 or C461 damages this theorem.  Those negatives only remove the proposed integral
secant-product lift.

### 2. The survival/forgetting ledger is supported

The positive and negative rows have genuinely different proof types, but the proposed ledger is
honest when stated narrowly:

- moments recover or orient the sheets at their certified levels;
- QR/code/design passage retains an exact structural shadow;
- theta parity and quantum LU erase the sheet label;
- the ambient Fourier comparison is projective and restricted;
- golden reductions are visible or fused under the conditional mod-40 law.

The ledger must not say that every row is another realization of one universal bit.  C463 itself
records that the carrier migrates across A3/B3/H3 and that no cross-case mechanism is known.

### 3. Negative results are properly scoped, except in the compact C443 paraphrase

C443, C446, C450, C454, C461, and the erasure parts of C451/C456/C467 are genuine results.  Their
reports state searched domains and stop conditions well.  This audit corrected the compact
C443+C461 ledger wording identified above.

### 4. “Group of the right order” is usually not the sole evidence

The stronger group identifications are normally backed by explicit action, element-order profile,
subgroup equality, orbit/stabilizer data, or generated closure.  This is adequate for mathematical
certification.  Lean should nevertheless encode the explicit subgroup equality or isomorphism
witness, not recover a group name from order alone.

### 5. The computation-to-theorem boundary is mostly explicit

The reports are particularly good about refusing the following overclaims:

- no unique generic H3 companion and no integral M3 tensor;
- no five-dimensional roof-module identification;
- no theta or LU sheet detector;
- no full restricted Weil module;
- no H4/600-cell continuation;
- no Witt/`M_11` equivariance for C464;
- no common carrier for all three conductor-40 characters;
- no global motivic projector or bad-prime monodromy bridge for C468.

Those refusals should survive manuscript compression verbatim in substance.

## Audit repairs and remaining manuscript work

Applied in this audit:

1. The result ledger's C443+C461 paraphrase now records the exact unique-companion, pair-average,
   and full-linear-weight obstruction.  It no longer says that C443 constructed a tensor that
   failed to commute.
2. C464's fourth-order projective support spectrum is now in the complete result inventory.  It is
   not promoted into Paper 1's central proof arc.

Still required before manuscript extraction:

1. Remove duplicated prose lines in C463, C466, and C467.  These are editorial only.
2. Repair the duplicated `X^3` and `X^2` terms in C468's displayed octic factor.  The certificate
   and norm formula should be treated as authoritative when making that correction.
3. Add explicit theorem/source pins for:
   - `a(A)=dim(A)` implying superspeciality in C451;
   - the unit-discriminant/maximal-order implication in C457;
   - the Schur-index explanation in C458;
   - the standard Weil linearization used in C455; and
   - the cubic-threefold `H^3(1)`/intermediate-Jacobian bridge in C468.
4. Narrow C459's `D5` wording to the exact rational-action meaning unless a broader twisted-form
   statement is separately proved.

None of these repairs overturns a finite certificate or the proposed Paper-1 theorem spine.

## Lean formalization recommendation

Do not formalize the reports chronologically.  Use four packets.

### Packet A — finite projective and matching core

Targets: C440--C449, C460--C464, and the finite subgroup/collision part of C466.

Build reusable definitions for normalized projective points, `PGL_2/PSL_2`, determinant
squareclasses, perfect matchings and one-factorizations, group actions/orbits/stabilizers, quadratic
ring reduction maps, and small exact rank certificates.  This packet contains the highest-value
and lowest-risk Paper-1 close.

### Packet B — code, Fourier, and quantum core

Targets: C452, C464, C455's raw matrix theorem, C456, and C467.

Formalize linear codes and support designs first; then finite Fourier character orthogonality and
equal-phase code states.  Keep “ambient Fourier restriction” separate from “Weil representation”
until the Gauss-phase convention is formalized.

### Packet C — representation, order, and descent bridges

Targets: C450, C451, C454, C457--C459, C462, and the scheme-theoretic part of C463.

Before theorem statements are declared ready, write small interface notes naming the exact external
lemmas.  Where practical, replace GAP character conclusions by explicit invariant-subspace or
central-idempotent certificates.  Separate finite Galois-set facts from finite-étale scheme claims.

### Packet D — C468 arithmetic geometry

Treat C468 as an independent formalization programme.  A realistic first target is only the
elementary smoothness proof and exact polynomial identities.  A full formal theorem needs an
approved library route for point-count trace formulas, the weight-three functional equation,
Frobenius eigenvalues and Newton polygons, and the intermediate Jacobian.  It should not be a gate
for Paper 1 or Paper 2's initial formal proof body.

## Bottom line

The landed battery is ready to support the proposed papers **as mixed-verification mathematics**,
provided the existing scope boundaries are preserved and the six manuscript repairs above are
made.  The Paper-1-facing claims are in the strongest position: their core is finite, explicit, and
structurally explained.  The Paper-2 material is also genuine, but several of its most attractive
interpretations are one abstraction layer above the certificates and need named bridge lemmas.

It would be inaccurate to say “all of C440--C468 is ready to Lean-formalize” as one block.  It is
accurate to say that the finite projective/matching/code/collision cores are ready for a designed
Lean campaign, while the Weil, theta, quaternion-descent, and especially zeta-function layers need
formal interface work first.

## Novelty spot-check

This was a bounded spot-check, not a manuscript-bound absence audit.  It reused two sources already
read at full text, consulted three more at partial depth, and used one authoritative metadata
record.  No citation graph or stable search-result set was exhaustively screened.  MathSciNet,
zbMATH Open, Google Scholar, and non-indexed historical literature were not covered.  The newly
consulted PDFs were not added to the shared cache during this pass.  Consequently the strongest
negative licensed here is **“no predecessor located within the recorded coverage,”** and even that
must be upgraded by a convention-complete audit before a manuscript novelty sentence is used.

Novelty confidence is not used anywhere above as evidence for mathematical validity.

### C463: outer-`S6` orientation

**High pre-emption risk for the combinatorial core; lower risk for the frozen arithmetic
identification.**  The six pentads, exceptional outer action, transposition cycle type `2^3`,
syntheme-to-pentad-edge bijection, endpoint `S5` stabilizers, pointwise `S4` intersection, and
order-48 setwise edge stabilizer are classical or immediate from the classical model.

The programme-specific statement for which no predecessor was located in this coverage is that the
two frozen A3 companions are exactly the endpoints of the edge belonging to the antipodal
syntheme, the projective `S4` fixes them pointwise, `i -> -i` flips the edge, and the same two-set is
the `Q(i)` arithmetic torsor (finite étale after inverting 2).

Safe wording:

> The classical duad--syntheme--pentad model identifies every syntheme with an edge of the
> six-point outer `S6`-set.  In our frozen A3 realization, the two companion factorizations are the
> endpoints of the edge associated with the antipodal syntheme, and Galois conjugation `i -> -i`
> is exactly its orientation reversal.

Do not claim a new outer-`S6` model or new `S5--S4--S5` gluing theorem.

### C464: ternary Golay/Witt closure

**Very high pre-emption risk for the code and designs; moderate risk for the explicit coordinate
formula.**  The ternary QR `[11,6,5]` perfect code, its 132 minimum words/66 supports, the Witt
`S(4,5,11)` design, the cyclic `2-(11,5,2)` biplane, and the standard `M_11` symmetry are classical.

The useful programme-specific refinement is the frozen-coordinate formula

```text
support(1-r_i-r_j) = complement(support(r_i) symmetric_difference support(r_j)),
```

which decomposes the 66 Witt blocks as the eleven selected biplane rows plus 55 residual blocks
indexed by `E(K_11)`.  Exact-phrase and structural searches found no predecessor for this formula,
but it is short and natural enough that priority risk remains material.  The projective support
spectrum is best presented as a complete certified census, not a major novelty theorem.

Safe wording:

> In the frozen quadratic-residue coordinates, the classical Witt block set admits the explicit
> decomposition `11+55`: the eleven distinguished biplane rows together with the residual blocks
> `support(1-r_i-r_j)` indexed by the edges of `K_11`.  The certificate also records the complete
> projective support spectrum.

### C466: characteristic-31 collision

**Medium novelty risk and the strongest attractive claim in this spot-check.**  Existing Edge/Dye
coverage owns substantial surrounding icosahedral conic geometry, `A5` stabilizers, and `PSL/PGL`
sheet splitting.  No predecessor was located within the recorded coverage for the combined result:

- projective equivalence of the C395 `t=-1` arc with both golden H3 arcs at 31;
- the two explicit monomial maps and their octahedral-hinge quotient;
- the divisor `3phi-8` of norm 31; and
- failure of all 120 special-fibre projectivities to lift modulo `31^2`.

Safe wording:

> In characteristic 31 we exhibit an exact projective collision between the `t=-1` non-GRS member
> of the C395 pencil and each of the two golden H3 six-arcs.  In the frozen integral model the
> collision is cut out by `3phi-8`, whose norm is 31, and none of the 120 special-fibre
> projectivities lifts modulo `31^2`.

Retain “simple first-order obstruction **in this integral slice**.”  Do not infer transversality in
an undefined moduli stack or an H4/icosian parent.  Before a manuscript-bound priority sentence,
repeat the search in older arc-classification vocabulary and reread Dye specifically for
characteristic 31.

### C453/C466: conductor-40 synthesis

**High pre-emption risk as number theory; lower risk as programme-specific synthesis.**  The three
independent quadratic characters, the degree-eight field `Q(sqrt5,sqrt2,i)`, conductor 40, the
classical `S4 <= PSL_2(q)` congruence, and the finite-field Gauss phase are standard.  What is useful
here is that three independently constructed roof faces are organized by those projections:

```text
(5/q)   golden existence,
(2/q)   PSL visibility/fusion,
(-1/q)  canonical Weil phase.
```

No predecessor was located within the recorded coverage for this exact roof diagram.  Safe
wording is that the field supplies a common Frobenius bookkeeping device, not a new
class-field-theoretic theorem.  State the additive character and complex embedding when naming the
Weil phase, and restrict the Frobenius formulation to primes not dividing 10.

### Sources and read depth

- W. L. Edge, *Conics and orthogonal projectivities in a finite plane* (1956), DOI
  `10.4153/CJM-1956-041-6`: **full text**, reused from the C406 audit's reading of the published
  PDF; cache key the DOI, SHA-256
  `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`.
- R. H. Dye, *Hexagons, conics, A5 and PSL2(K)* (1991), DOI
  `10.1112/jlms/s2-44.2.270`: **full text**, reused from the C399/C406 reading of the published
  scan; OCR reconstruction SHA-256
  `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`, with load-bearing
  passages previously checked against page images.
- E. Berkove et al., *Automorphisms of S6 and the color cubes puzzle* (Australasian Journal of
  Combinatorics 68 (2017), 71--93): **partial**, official published PDF, §§2--3 and especially
  pp. 74--76.  No cache key/hash was created in this bounded pass.
- M. de Boer and R. Pellikaan, *The Golay Codes* (Springer chapter, 1999): **partial**,
  author-hosted published-version PDF, introduction and §2 through the minimum-support/Witt
  construction, pp. 3--5.  No cache key/hash was created.
- R. M. Guralnick and M. E. Zieve, *Polynomials with PSL(2) monodromy* (Annals of Mathematics):
  **partial**, official published PDF, Appendix A, pp. 40--42, especially Dickson's subgroup
  theorem.  No cache key/hash was created.
- Eindhoven University research record for de Boer--Pellikaan: **abstract/metadata only**, used
  only for authoritative bibliographic metadata.

### Exact bounded queries

```text
site:arxiv.org duad syntheme pentad outer automorphism S6 edge orientation pentad stabilizer S5 intersection S4
site:doi.org ternary Golay code 11 6 5 minimum weight supports Steiner 4-(11,5,1) Witt design
"ternary Golay" "2-(11,5,2)"
"3phi-8" golden ratio norm 31 projective six arc
duads synthemes pentads S6 PDF
Witt design S(4,5,11) ternary Golay minimum weight codewords PDF
quadratic residue code length 11 ternary Golay biplane incidence matrix PDF
PSL(2,q) two conjugacy classes A5 S4 q mod 8 Dickson PDF
"six-arc" PG(2,31) A5
"6-arc" "PG(2,31)" A5
"non-GRS" six arc characteristic 31
icosahedral six points conic golden ratio finite field projective equivalence characteristic 31
"Q(sqrt(5),sqrt(2),i)" conductor 40 Frobenius
"mod 40" "Legendre symbol" 2 5 -1
icosahedral A5 reduction finite fields sqrt5 PSL2 q sqrt2
Weil index finite field q mod 4 i Gauss sum canonical additive character
"1-r_i-r_j" ternary Golay
ternary Golay residual 55 blocks K11 edges
Witt S(4,5,11) 11 biplane blocks remaining 55
"2-(11,5,10)" Witt blocks
```

The search interface exposed returned top results rather than stable total-result counts.  This is
why the section remains a spot-check and cannot license an unqualified absence claim.

The second-tier audit of C445, C457, C459, C460, C467, and C468 is recorded separately in
`2026-07-22-clebsch-weil-roof-runner-up-novelty-audit.md`.
