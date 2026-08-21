# Referee and critic dossier: Frobenius-equivariant pair extension

**Manuscript:** *Frobenius-equivariant pair extension and robust repair of
eight-arcs*  
**Frozen authority:** commit
`b53aee00c2d91f1547b82278412bbce6385c163e`  
**Frozen PDF:**
`papers/equivariant-robust-completion/equivariant-robust-completion.pdf`  
**PDF SHA-256:**
`b9f1fda1f109dde029aed2fae6ec5e0efe6d5dd568bdc048ae1658ae159a993d`  
**Surface:** 15 A4 pages; 156 whitespace-delimited abstract tokens  
**Date:** 2026-08-21

This is an internal review-planning artifact, not evidence for the paper and
not part of its standalone export. Named critics below are expertise matches,
not claims about availability, conflicts, or an actual editorial assignment.
Do not blend their perspectives into one synthetic persona: the point of the
packets is to expose different standards of objection.

## Editorial question

Does the mate-line carrier decomposition and its exact collision correction
constitute a strong, standalone finite-geometry and coding-theory paper, and is
the normalized `PG(2,25)` census connected to arbitrary invariant arcs by a
complete human argument rather than by an unstated computational transport?

Correctness and venue significance must be judged separately. A correct paper
may still need a sharper explanation of why orbit-valued extension and
alternate repair add more than an ordinary arc-completion count.

## Likely venue routes

### Finite Fields and Their Applications

This is the strongest natural first route. The journal explicitly includes
finite-field theory, computational finite-field methods, algebraic coding
theory, and combinatorial design theory in its scope. Michel Lavrauw is listed
on its editorial board and works directly on arcs, finite projective spaces,
field reduction, MDS codes, and the geometry--coding interface.

- Journal scope: <https://www.sciencedirect.com/journal/finite-fields-and-their-applications>
- Current editorial board: <https://www.sciencedirect.com/journal/finite-fields-and-their-applications/about/editorial-board>
- Lavrauw research profile: <https://osebje.famnit.upr.si/~michel.lavrauw/research.html>

### Designs, Codes and Cryptography

This is the clearest coding/combinatorics alternate if the paper foregrounds
paired MDS extension and replacement. A referee may nevertheless ask for more
coding-theoretic consequences than the projective translation currently
supplies.

### Journal of Combinatorial Designs

This is plausible if the exact `PG(2,25)` classification and residual orbit
structure are treated as central. Coolsaet--Sticker's full classification of
complete arcs in `PG(2,23)` and `PG(2,25)` appeared there, which makes the
journal an informed but demanding home for the computational boundary.

- Coolsaet--Sticker record and DOI: <https://biblio.ugent.be/publication/524096>

### Journal of Combinatorial Theory, Series A

This is a significance stretch. The structural carrier count is clean and the
exact correction is reusable, but a JCTA-level critic is likely to ask whether
the general theorem changes the theory of complete arcs or MDS extension beyond
the isolated Frobenius-equivariant setting. Do not enlarge the theorem merely
to chase this route.

## Referee pool and distinct critical lenses

### Simeon Ball — arc structure and significance

Ball is a natural critic for the classical theory of arcs, the arc--MDS
correspondence, and the square-root completeness scale. His joint survey with
Lavrauw is already the paper's main modern arc reference.

Expected questions:

1. Is the mate-line decomposition genuinely new structure, or a convenient
   repackaging of standard secant counting in the Baer quotient?
2. Does the exact invisible-center/collision formula have consequences beyond
   the order-five application?
3. Is the Lunelli--Sce scale described strictly as classical, with the weaker
   pair-saturation hypothesis identified as the new distinction?
4. Can the principal theorem be understood and checked without reading the
   verification section?
5. Is the paper's length proportionate to the conceptual result rather than to
   the census ledger?

Primary orientation:
<https://arxiv.org/abs/1908.10772>.

### Michel Lavrauw — finite geometry, field reduction, and codes

Lavrauw is the strongest two-track reader: finite projective geometry on one
side and MDS codes on the other.

Expected questions:

1. Are fixed points, fixed lines, and the embedded Baer subplane normalized
   correctly for every prime-power base order?
2. Does every nonfixed conjugate pair have exactly one fixed mate line, and is
   every carrier count projectively invariant?
3. Are the conventions for projective columns, monomial code equivalence, and
   Frobenius action stated strongly enough for coding theorists?
4. Does “repair” remain visibly different from erasure decoding in a fixed
   code?
5. Is the Clebsch specialization useful orientation or a distracting companion
   result?

### Tim Alderson — MDS extension and uniqueness boundary

Alderson's work on extending MDS codes makes him the sharpest critic of the
coding interpretation and of any suggestion that paired extension is an
ordinary lengthening theorem.

Expected questions:

1. Is the correspondence exactly between a projective `k`-arc and a linear
   `[k,3,k-2]` MDS code, with repeated/proportional columns excluded?
2. What extra datum on the code realizes quadratic Frobenius invariance?
3. Is adjoining a conjugate pair a two-column extension of one chosen generator
   configuration, or an invariant of code equivalence?
4. Does alternate-orbit repair say more than nonuniqueness of extension after
   puncturing, and is the subtraction of the erased orbit rigorous?
5. Does any sentence blur this paper's constrained paired extension with known
   unrestricted MDS extension results?

Profile and relevant paper:

- <https://www.unb.ca/faculty-staff/directory/science-ase-math/alderson-tim.html>
- <https://www.unb.ca/faculty-staff/directory/_resources/pdf/sase/alderson/mds-codes.pdf>

### Kris Coolsaet or Heide Sticker — exhaustive `PG(2,25)` classification

Coolsaet--Sticker classified complete arcs in `PG(2,25)` by independent
isomorph-free backtracking variants. This lens should not be merged with a
general arc-theory review: it tests the finite classification and equivalence
action.

Expected questions:

1. What is the exact normalized search domain of 1189 representatives?
2. Which projective group is quotiented before the residual five-orbit
   statement, and are orbit sizes measured under that same action?
3. Why do the two manuscript normalizations reach every semantic invariant
   eight-arc with two fixed points?
4. Does the certificate prove only the normalized classification, with no prose
   implying that it certifies semantic transport?
5. Can the equality-orbit exhaustion be compared with known `PG(2,25)` arc
   classifications without conflating ordinary completeness and paired
   extension?

Primary record: <https://biblio.ugent.be/publication/524096>.

### Daniele Bartoli — computational completeness and geometric relevance

Bartoli's work spans construction and exhaustive study of arcs, caps,
saturating sets, and related finite configurations. This is the best hostile
reader for whether the finite component has a credible mathematical
completeness story.

Expected questions:

1. Are enumeration, normalization, pruning, deduplication, acceptance, and
   equality classification stated independently of implementation details?
2. Is exact arithmetic used throughout, and does the certificate recompute or
   merely trust any external data?
3. Is the finite minimum 32 necessary for the uniform four-pair theorem, or is
   it a stronger secondary classification whose prominence should be reduced?
4. Are witness existence, lower bound, attainment, and orbit exhaustion kept
   logically separate?
5. Does the paper explain why the order-five obstruction is exceptional rather
   than simply small?

Research profile:
<https://www.danielebartoli.org/home-page/main-directions>.

### Frobenius/Baer specialist — source and convention audit

Use a reader familiar with Baer subplanes and Frobenius collineations, with
Ueberberg, Jungnickel, and Baker--Wantz as the initial source packet. This
packet is about conventions and precedence, not code extension.

Expected questions:

1. Is “fixed line” used setwise or pointwise, and is that distinction preserved
   in every counting argument?
2. Does the fixed-center construction `m ∩ phi(m)` cover every noninvariant
   secant orbit without degeneracy?
3. Is Hilbert--90 normalization invoked with all scalar and projective choices
   accounted for?
4. Is Baker--Wantz described as genuine precedence for the conjugate-point
   maneuver without being weakened to create novelty?
5. Is the bounded negative literature search clearly separated from a priority
   claim?

### Formal-artifact critic — trust boundary and source closure

Use a Lean/mathlib reviewer who has not worked on the certificate. This packet
must remain separate from the geometric proof review. It does not authorize a
large Q25 rebuild.

Expected questions:

1. Does the pinned package commit and manifest digest identify immutable public
   source?
2. Do the aggregate terminals expose all finite leaves used for the minimum and
   equality-orbit claims?
3. Are the reported axioms exactly `propext`, `Classical.choice`, and
   `Quot.sound`, with no admitted declarations, custom axioms,
   `native_decide`, unsafe declarations, or untracked generated data?
4. Does the manuscript distinguish human-scale Lean reductions, the sealed
   Mathlib-only finite package, and manuscript-only normalization transport?
5. Can declaration-level checks and the sealed verification command be audited
   from existing artifacts? Any proposed cold or certificate rebuild must be
   separately scoped and approved before it is run.

## Load-bearing claim map

| Claim | Printed location | Main failure modes to test |
|---|---|---|
| every nonfixed pair has a unique fixed mate line and each fixed line carries `s(s-1)/2` pairs | Section 2 | setwise versus pointwise fixed lines; projective scalar normalization; double counting |
| empty-line count and uniform pair-extension bound | Lemmas `lem:pair-test`, `lem:empty-lines`; Theorem `thm:pair-criterion` | secant-orbit count; injection into forbidden candidates; positivity hypotheses |
| exact invisible-center and collision correction | Proposition `prop:linewise`; Corollary `cor:aggregate` | fixed-center degeneracy; visible multiplicities; sign of the correction terms |
| four structural order-five profiles | Proposition `prop:four-profiles` | omitted profile; moment/incidence inequality endpoint; strict versus weak bounds |
| exact exceptional minimum 32 and five equality orbits | Proposition `prop:f2` | normalization coverage; residual action; certificate domain; semantic transport |
| uniform four legal pairs over `F_25` | Theorem `thm:q25` | interaction of structural and exceptional branches; minimum over all profiles |
| alternate repair after deleting a selected orbit | Corollaries `cor:q25-uniform-repair`, `cor:alternate-repair` | invariance of the remainder; erased pair counted among legal pairs; off-by-one |
| profile envelope and parameterized exchange | Theorem `thm:profile-envelope`; Theorem `thm:parameterized-repair` | maximization of `floor((k-1)^2/4)`; empty-carrier hypothesis; quantifier order in `r` |
| coding-theoretic interpretation | abstract, introduction, conclusion | code equivalence; generator dependence; extension versus decoding |
| formal and computational evidence | Section 7 and `verification/` | artifact pin; axiom surface; normalized versus semantic claim boundary |

## Cross-packet criticals, ranked

These are hypotheses for a critic to test, not findings.

1. **Normalization transport is the principal proof risk.** The certificate
   closes a normalized finite model. The manuscript must prove that both
   projective normalizations preserve the arc condition, Frobenius action,
   legal-pair count, and residual equality classification.
2. **The order-five theorem must really cover all prime powers `s >= 5`.** The
   manuscript uses the special branch `s=5` and the structural branch `s>=7`;
   the final all-orders statement relies on there being no prime power strictly
   between 5 and 7.
3. **The exact correction must earn its prominence.** A referee should locate
   where invisible centers or collision redundancy produce a theorem that the
   first-order union bound alone cannot reach.
4. **Alternate repair has an off-by-one trap.** After deletion, the selected
   pair is itself legal for the remainder. The manuscript must subtract exactly
   that pair and prove every other counted pair gives a distinct repair.
5. **The five residual orbits need one action throughout.** Normalized
   representatives, stabilizers, orbit sizes, and “outside their union” must
   use compatible labeled/unlabeled and projective/semilinear conventions.
6. **Coding language must not overclaim invariance.** A geometric column
   configuration carries more chosen structure than an abstract linear code;
   “repair” is replacement of generator columns, not decoding.
7. **The classical square-root scale is not new.** The potential contribution
   is the weaker pair-saturation condition and orbit-valued count, not the
   Lunelli--Sce constant.
8. **The literature boundary is bounded negative evidence.** The prior-art
   paragraph should survive a source-level check of Baker--Wantz, Ueberberg,
   Jungnickel, Alderson, Ng--Wild, and the `PG(2,25)` classification papers.
9. **The artifact must remain optional for understanding.** A mathematical
   referee should be able to verify the reduction to a finite normalized claim
   from the paper, while the artifact checks exhaustion inside that domain.
10. **Hierarchy must survive the exact data.** The mate-line mechanism and
    robust theorem are the spine; 1189 representatives and five orbit sizes are
    audit data, not the conceptual opening.

## Isolated review packets

### Packet G — finite geometry and proof spine

Read the complete frozen PDF and reconstruct Sections 2--6 without using Lean
or the verification prose as proof. Check every carrier, secant-orbit, profile,
and deletion count. Compare conventions with Hirschfeld, Martin, Ball--Lavrauw,
and Ng--Wild. Report exact page/theorem locations for every defect.

### Packet C — normalized census and certificate

Read Proposition `prop:f2`, its complete proof, Section 7, and the pinned
verification metadata. Reconstruct the mathematical search domain and both
normalizations. Audit existing aggregate terminals and axiom records. Do not
run a large build; if existing artifacts cannot answer a question, record the
missing check and the estimated build class for separate approval.

### Packet M — MDS and repair interpretation

Read the abstract, introduction, all repair statements, and conclusion. Check
the arc--code correspondence, field of definition, Frobenius datum, generator
dependence, puncture/re-extension logic, and separation from ordinary erasure
decoding. Compare with Alderson's extension results.

### Packet P — priority and adjacent literature

Verify every sentence in “Prior art and claim boundary” against the cited
source at theorem/page level. Search both finite-geometry and coding
vocabularies for orbit-constrained extension, Baer-line completion, Galois-pair
lengthening, and deletion-resistant re-extension. A negative result must record
databases, queries, dates, and scope; it must not become a historical firstness
claim.

### Packet E — editorial architecture and export surface

Read the PDF as a cold adjacent-field reader. Check that the main theorem is
findable on page 1, the mechanism follows it, the exact census does not dominate
the opening, and the conclusion ends mathematically. Audit the standalone
source closure, `.zenodo.json`, bibliography, AI disclosure, verification pin,
and reproduction command. Recommend a venue independently of correctness.

## Report contract

Each packet report must record:

- the frozen commit and PDF hash;
- sources actually opened and read depth;
- exact theorem/page/line locations;
- mandatory defects, optional improvements, and questions that remain open;
- whether each finding concerns correctness, exposition, priority, artifact
  trust, or venue significance;
- confidence and the strongest venue supported after repairs.

Reports may use the following verdict vocabulary:

- **A:** ready on the reviewed dimension;
- **B:** sound but requiring local, enumerated repairs;
- **C:** major revision, missing proof bridge, or material overclaim;
- **D:** central claim fails.

Any C/D correctness or trust finding blocks submission. Every B item must be
repaired and reread on a new frozen PDF hash. Synthesis begins only after the
isolated reports are frozen; it must preserve disagreements rather than average
them away.

## Present pre-review assessment

The current architecture is appropriate for export: the object and code
translation appear before the theorem, the theorem starts on page 1, the
mate-line mechanism and proof strategy follow immediately, exact orbit data are
demoted to the dedicated order-five section, and the verification boundary is
isolated near the end. The strongest anticipated criticism is not layout but
the manuscript-only transport from the normalized Q25 certificate to arbitrary
semantic invariant arcs. That bridge should receive the first hostile read.

