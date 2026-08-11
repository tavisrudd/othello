# Clebsch Paper V reviewer and critic dossier

**Lane:** `clebsch`

**Date:** 2026-08-11

**Task:** C904

**Manuscript:** *The Golden Companion Correspondence*

**Purpose:** forecast realistic referee profiles, construct hostile specialist
personas, and define sealed cold-read packets for the completed structural
Paper V.

> **REVIEW MATERIAL ONLY.** Do not load this dossier into ordinary drafting,
> proof discovery, Lean work, or a reviewer-facing submission. A cold reader
> should receive the frozen manuscript and one packet, not the dossier's
> proposed answers. Remediation receives findings, not persona prompts.

This dossier supersedes the 2026-08-10 dossier for the old eleven-page
surface. That batch remains useful historical evidence for the repaired
outer-action and singular-orbit arguments, but it is not a review of the
current theorem.

## 1. Frozen review surface

Commit: `72497df2` (`papers: finish structural Paper V`).

- source: `papers/clebsch-round-trip/golden_companion_reconstruction.tex`;
  SHA-256
  `56dead3ccce1de4f0eccace367f707be76a06c500e8900fae64a8671862caccf`;
- PDF: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`;
  SHA-256
  `c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`;
- visible length: eighteen pages;
- build: warning-free `make check` under the repository Nix environment;
- trust boundary: the proof is human-readable and load-bearing; the executable
  check replays only the Paper-II normalization leaf.

A cold review must verify both hashes. Any manuscript edit creates a new
surface and invalidates a mixed batch.

## 2. What the paper now asks a referee to certify

The paper is no longer merely an explicit placement of one invariant cubic.
It asserts one structural round trip with four proof engines.

1. **Geometric recognition.** A metric chordal cubic determines its singular
   rational normal quartic; the quartic's split (A_5/C_5)-orbit recovers the
   six axes (A_5/D_{10}).
2. **Outer and conference recognition.** The literal outer permutation of
   the recovered six-set acts on the invariant pencil. Its difference map is
   an equivalence after a chordal line is selected, and otherwise has the
   exact residual deck involution (uq).
3. **Integral saturation.** For a symmetric conference matrix (B), the
   integral endomorphism on (D_n^ee) is ((I+B)/2), with a split/inert
   classification controlled by (nmod 8).
4. **The golden residue.** At (n=6), reduction produces the unique nonsplit
   (A_5)-extension over (mathbf F_4); the golden Galois involution and the
   outer normalizer induce the same Frobenius action. Paper IV's
   (mathbf F_8)-marking is then placed as the independent degree-three
   instance of the same Frobenius-orbit commutant mechanism.

The review must therefore be deliberately mixed. No single geometry reader
or combinatorics reader is likely to cover the whole proof at referee depth.

## 3. Forecast, not inside information

Names below are forecasts from public research overlap, closest-source
proximity, and current public roles. They are not claims about editorial
practice, willingness, conflicts, or actual selection. Close source authors
are often best treated as priority critics rather than as the sole referee.

### Tier A: plausible whole-paper referees

#### Andrew Snowden — outer (S_6), invariant theory, and categorical marking

Why plausible: the paper's six-set bridge uses exactly the exceptional
outer-six phenomenon and must distinguish literal modules, projective
modules, transported markings, and scalar rigidification. Snowden's work on
the outer automorphism and six-point invariants makes him the strongest
all-paper algebraic critic. His public University of Michigan profile lists
representation theory among his research areas.

Likely verdict pressure: he will accept explicit calculations only after the
objects and morphisms are intrinsic. He is the reader most likely to find a
hidden quotient, a projectivization performed too early, or a false
full-faithfulness statement.

Public-role check, accessed 2026-08-11:
<https://lsa.umich.edu/math/people/faculty/asnowden.html>.

#### Edwin van Dam — conference matrices, switching, and spectral structure

Why plausible: the paper's middle theorem is a uniform statement about
symmetric conference matrices and their integral saturation, not just the
order-six example. Van Dam is an active full professor at Tilburg working in
spectral and algebraic graph theory, with recent work on gain graphs and
association schemes. He is a more realistic active conference/spectral
referee than an historical-source-only choice.

Likely verdict pressure: he will demand that switching equivalence, labeled
matrices, opposite orientation, coefficient algebras, and lattice
isomorphism types never be conflated. He will test whether the general
(D_n^ee) theorem is genuinely conceptual rather than an order-six census
in disguise.

Public-role check, accessed 2026-08-11:
<https://www.tilburguniversity.edu/nl/medewerkers/edwin-vandam>.

#### Lisa Marquand — singular cubic geometry and automorphism boundary

Why plausible: she is a close specialist on singular cubic threefolds,
automorphisms, and equivariant birational geometry. Her public page lists a
current NSF postdoctoral fellowship at Courant and a Rutgers appointment
beginning in fall 2026. She is well placed to judge whether the quartic and
orbit recovery are geometric or merely coordinate recognition.

Likely verdict pressure: she will insist that the unmarked chordal cubic's
large (operatorname{PGL}_2)-automorphism group is respected, that the
six-set comes from the marked (A_5)-action rather than from the cubic alone,
and that scheme-theoretic singular-locus statements survive base change.

Public-role check, accessed 2026-08-11:
<https://sites.google.com/view/lisamarquand/home>.

#### Frauke Bleher — modular extensions and integral representation theory

Why plausible: the last third of the paper uses a nonsplit modular
extension, an (operatorname{Ext}^1)-line, endpoint automorphisms, and a
Galois-semilinear identification. Bleher is a University of Iowa professor
whose public research description centers representation theory of groups
and finite-dimensional algebras.

Likely verdict pressure: she will not accept an extension class identified
only by dimensions. She will ask for the exact presentation, coboundary
quotient, nonsplitting witness, endpoint automorphism action, and uniqueness
of the middle module.

Public-role check, accessed 2026-08-11:
<https://math.uiowa.edu/people/frauke-bleher>.

### Tier B: closest-source and high-value specialist critics

#### Antoine Pinardin — closest chordal-pencil and priority reader

Pinardin is a closest source author for the (A_5)-invariant pencil and its
two chordal members. His public CV lists a 2025 Edinburgh PhD and research in
equivariant birational geometry. He is therefore an unusually valuable
priority and normalization reader, but his proximity and career stage make
him better treated as a specialist critic than as the only broad referee.

He should check the exact distinction between what is imported from the
geometric pencil and what Paper V newly proves: metric normalization,
axis recovery, the selected-line outer-difference bridge, integral lattice
saturation, and the golden residue.

Public-role check, accessed 2026-08-11:
<https://www.antoinepinardin.com/CV-Antoine-Pinardin.pdf>.

#### Zhijia Zhang — singular cubic and equivariant-geometry critic

Zhang coauthors the closest singular-cubic and (A_5)-equivariant sources.
His current public page identifies him as a Courant PhD student working in
equivariant birational geometry and rationality. He is a strong source-usage
and convention critic, especially for the chordal members, but should not be
counted as an independent second geometry referee when Pinardin or Marquand
is already used.

Public-role check, accessed 2026-08-11:
<https://zhijiazhangz.github.io/>.

#### Willem Haemers — senior conference-matrix critic

Haemers is emeritus at Tilburg and a closest intellectual critic for
symmetric conference matrices and their spectral equivalences. He is less
plausible as the primary active referee than van Dam, but extremely valuable
for a sealed theorem-only read of conference saturation and its relationship
to the literature.

Public-role check, accessed 2026-08-11:
<https://research.tilburguniversity.edu/en/organisations/econometrics-and-or/persons/>.

#### Peter Sin — finite-group and modular permutation-module alternate

Sin is a University of Florida professor and an appropriate alternate for
the (A_5)-module, permutation-lattice, and modular-extension packet. He is
especially useful if the editor wants one reader whose center of gravity is
finite-group representations rather than deformation theory.

Public-role checks, accessed 2026-08-11:
<https://gradcatalog.ufl.edu/graduate/colleges-departments/liberal-arts-sciences/mathematics/>
and <https://people.clas.ufl.edu/sin/files/shortdeptvita-Oct2023.pdf>.

### Tier C: persona roles without a named-referee claim

- **Integral lattice purist.** Checks (D_n^ee), saturation, Smith and
  discriminant normalizations, coefficient-algebra faithfulness, and descent
  without trusting the finite examples.
- **Series cold reader.** Has Papers I--IV available but is instructed to
  demand every import be stated by a stable named result and every new bridge
  be proved locally. This reader judges whether V is a punchline rather than
  an index of prior papers.
- **Trust and reproducibility critic.** Checks that the executable
  certificate is a leaf, that no proof cites an output file, and that the
  human proof is sufficient if every script is deleted.
- **Hostile generalist editor.** Asks whether the uniform conference theorem
  and Frobenius-commutant principle justify a separate paper, whether the
  source-return language overclaims reconstruction, and whether the Paper IV
  comparison is structural rather than decorative.

## 4. Recommended panel

For an actual editorial route, a coherent two-referee pair is:

1. one of Snowden / a comparable invariant-and-representation theorist; and
2. one of van Dam / Haemers / a comparable conference-and-lattice theorist.

The editor should then obtain a targeted geometry opinion from Marquand or a
comparable singular-cubic specialist if neither referee covers Section 3.

For internal cold review, use four sealed reads:

1. **Snowden persona:** packets O and M below;
2. **van Dam persona:** packets C and L;
3. **Bleher persona:** packet R;
4. **Marquand persona:** packet G plus the introduction and source-return
   section.

Pinardin or Zhang should perform a separate priority/convention audit, not be
used as a substitute for all four.

## 5. Packet G — geometric recognition

**Read:** Sections 2--3 and the relevant definitions in Section 1.

### Imported facts to police

- the (A_5)-invariant cubic pencil and its two chordal members;
- the Hankel chordal model and its rational normal quartic singular locus;
- the unmarked chordal cubic's larger automorphism group.

### Critical questions

1. Does the Jacobian calculation prove equality with the saturated quartic
   ideal, or merely set-theoretic containment?
2. Is the fixed divisor of an exact (C_5) on the quartic split, reduced, and
   of the asserted size over every allowed neutral extension?
3. Is the stabilizer map from the (A_5/C_5)-orbit to the six Sylow-five
   axes canonical, while the two points above an axis remain unordered?
4. Is (D_{10}), rather than an ambiguous (D_5) convention, used
   consistently for the order-ten normalizer?
5. Does the paper recover the original marked axes, not merely an abstract
   six-element set?
6. Is the metric (Q_0) part of the object wherever scalar rigidity is
   claimed?
7. Are characteristic-zero geometric inputs separated from the
   characteristic-eleven companion theorem?

### Major-finding threshold

Failure of scheme equality, failure of exact stabilizers, or recovery only
up to an unrecorded twist is MAJOR. A missing chart computation or clearer
credit line is MINOR if the intrinsic argument is intact.

## 6. Packet O — outer difference, groupoids, and markings

**Read:** Sections 4--6.

### Critical questions

1. Is the outer lift constructed from the literal permutation module on the
   recovered six-set, so its action on the invariant pencil is linear and
   independent of an arbitrary intertwiner scalar?
2. If the odd normalizer representative changes by (A_5), is the induced
   operator on (A_5)-invariants unchanged?
3. Does the metric plus cubic condition kill scalar automorphisms over fields
   containing (mu_3), using (lambda^2=lambda^3=1)?
4. Is the selected chordal line part of the oriented conference groupoid,
   rather than silently reconstructed from the conference cubic?
5. Is

   \[
     (q_\Pi-1)(-q_\Pi h)=(q_\Pi-1)h
   \]
   identified as the exact reason the unselected map is two-to-one?
6. Is the residual deck transformation exactly (uq), and is the full
   (V_4=\langle u,q\rangle) asserted only at the fully forgotten vertex?
7. Does the dependency lattice distinguish actual generators, projective
   lines, sign choices, normalized metrics, and source data?
8. Is full faithfulness proved on morphisms, including coordinated outer
   relabeling, rather than only on isomorphism classes?
9. Is source return explicitly restricted to decorated packages in the
   image of the source functors?

### Major-finding threshold

Any residual (mu_3), an unrecorded selected-line choice, or a false global
one-to-one bridge is MAJOR. A notation or dependency-table mismatch is MINOR
unless it changes a fibre.

## 7. Packet C — conference classification and orientation

**Read:** the conference lemma in Section 3, Section 4, and Section 8.

### Literature boundary

The manuscript may use the classical conference-matrix vocabulary and
switching tradition. It must not present the order-six conference object,
the conference cubic, or known spectral facts as new. The new content is the
specific intrinsic bridge, the exact marking torsor, and the uniform integral
saturation theorem.

### Critical questions

1. Is the uniqueness claim the unique unordered pair of
   **(A_5)-invariant** switching classes on the fixed six-set, not a false
   uniqueness among all labeled order-six conference classes?
2. Does first-row normalization reduce the proof to a 2-regular graph on five
   vertices, hence a five-cycle, without an unexplained census?
3. Are switching, relabeling, negation, and orientation reversal kept
   distinct?
4. Does (B^2=5I) follow structurally from triangle balance, with no hidden
   sign convention?
5. Does the oriented triangle cubic span the correct outer eigenspace?
6. Is the scalar (8) obtained by one displayed coefficient comparison,
   after the independent conference pair is already known?
7. Is the opposite conference class exchanged by the outer normalizer for a
   proved reason rather than by an observed finite permutation?

## 8. Packet L — integral lattice saturation

**Read:** Sections 7--9, but judge Section 8 as a standalone theorem.

### Critical questions

1. Is (D_n^ee), not (mathbf Z^n) or (D_n), the minimal integral
   carrier on which ((I+B)/2) acts?
2. Does the proof establish preservation and minimality without Smith-form
   computation?
3. Is switching independence proved by conjugation on the same integral
   lattice?
4. In the split case (n\equiv0\pmod8), is a non-scalar coefficient-algebra
   line exhibited so the decomposition is not only dimension counting?
5. In the inert case (n\equiv4\pmod8), is the quadratic field extension and
   its Frobenius action derived from the coefficient algebra?
6. Are the two rank-five integral lattices from the six-set shown to have the
   same binary heart by a canonical calculation?
7. Does the (n=6) specialization really yield the claimed
   (mathbf F_4)-structure, rather than merely an order-three endomorphism?
8. Are all local-to-global or base-change statements honest about neutral
   extensions and split forms?

### Deletion test

Delete every replay script and finite matrix output. If the theorem no
longer follows from the printed parity, lattice, and coefficient-algebra
arguments, return MAJOR.

## 9. Packet R — modular extension and golden Frobenius

**Read:** Section 9.

### Critical questions

1. Are the generators and relations for the (A_5)-module written down
   sufficiently to verify the action?
2. Is the commutator space computed modulo coboundaries, not confused with
   the cocycle space?
3. Does the fixed-space calculation rule out an (mathbf F_4)-line and hence
   prove nonsplitting?
4. Are (dim Z^1), (dim B^1), and (dimoperatorname{Ext}^1) tied to a
   conceptual exact sequence rather than asserted from software?
5. Does the endpoint automorphism group act transitively on nonzero extension
   classes, yielding uniqueness of the middle module?
6. Is

   \[
     \mathbf Z^\Omega\cap2D_6^\vee
       =2\mathbf Z^\Omega+\mathbf Z\mathbf1
   \]
   proved exactly, and does it identify the integral extension line?
7. Do golden conjugation and the outer normalizer induce the same
   nontrivial automorphism of (mathbf F_4), not merely the same permutation
   of two unnamed objects?
8. Are the Bleher/block-theoretic inputs cited at the depth actually read,
   and are stronger uniqueness claims proved internally?

## 10. Packet IV — the Paper IV bridge

**Read:** Section 10 and the series map in the introduction.

### Critical questions

1. Is the Frobenius-orbit commutant lemma stated for a simple module with a
   full Galois orbit of absolutely irreducible constituents?
2. Does the conclusion
   (operatorname{End}_{kG}(S)\cong\mathbf F_{q^d}) follow by descent without
   assuming the desired field structure?
3. Is the Paper IV (mathbf F_8)-marking presented as an independent
   degree-three instance, not as a geometric descendant of the six-set
   construction?
4. Does the comparison genuinely explain why both markings are forced by
   Frobenius orbit structure?
5. Is any statement about carrying the golden companion into Paper IV
   avoided unless a functor is actually constructed?

This packet is where the series can be strengthened or diluted. The correct
claim is a shared structural mechanism, not a new cross-paper geometric map.

## 11. Packet T — trust, exposition, and series role

**Read:** introduction, verification section, conclusion, and one proof from
each engine.

### Critical questions

1. Can a reader state the main theorem without naming any script, matrix
   file, or task card?
2. Are the four engines announced before technical notation accumulates?
3. Does each section explain which datum has been forgotten and which fibre
   remains?
4. Are Paper I--IV imports stable named results with enough local restatement
   to avoid forced rereading?
5. Is the Paper-II scalar normalization the only executable leaf?
6. Does the paper distinguish structural classification from source return?
7. Does it explain why the general (D_n^ee) theorem matters outside the
   Clebsch series?
8. Is the Paper IV connection visible as a conceptual payoff without
   overtaking the main six-set theorem?
9. Would the paper remain complete if all companion repositories vanished?

## 12. Cross-persona failure modes

These are the highest-probability major objections.

1. **Projective versus linear outer action.** A projective involution is used
   where sign and scalar are load-bearing.
2. **The (mu_3) stabilizer.** A cubic alone is claimed to rigidify a linear
   module over arbitrary extensions.
3. **Global versus selected-line bridge.** The two chordal lines are silently
   identified, hiding the (uq)-deck involution.
4. **Conference uniqueness overstated.** An (A_5)-fixed pair is described
   as the unique labeled switching class.
5. **Abstract six-set substituted for recovered axes.** Stabilizer data are
   lost between the singular quartic and the source package.
6. **Finite computation masquerading as the uniform lattice theorem.** The
   (n=6) example is correct but the (D_n^ee) minimality or mod-eight
   classification is not proved.
7. **An extension dimension mistaken for an extension classification.** The
   nonzero line, nonsplitting, or endpoint automorphism action is absent.
8. **Two involutions merely compared as sets.** Golden conjugation and outer
   action are not shown to be the same Frobenius-semilinear operation.
9. **Paper IV overbridge.** A common commutant principle is inflated into an
   unconstructed geometric correspondence.
10. **Source-return overclaim.** The theorem reconstructs arbitrary Paper-I,
    II, or III objects rather than only decorated packages in the image.

## 13. Cold-read protocol

Each reader receives:

- the frozen PDF and both hashes;
- exactly one packet, or an explicitly named pair of packets;
- the instruction to locate the earliest unsupported implication;
- the instruction to distinguish mathematical defects, priority defects,
  and editorial improvements;
- the verdict scale GO / MINOR / MAJOR.

Readers do not receive proposed repairs. They should report:

1. the earliest failing sentence or implication;
2. the smallest counterexample or ambiguity;
3. whether the theorem survives with a local repair;
4. which downstream claims must be re-read after repair;
5. whether the claimed novelty boundary remains accurate.

After any mathematical edit, rebuild, record new hashes, and rerun every
packet whose causal chain passes through the change. Wording-only changes may
receive a scoped spot check only if they do not alter a mathematical
quantifier, object, morphism, or novelty claim.

## 14. Recommended review order

1. **O first.** Groupoid and marking mistakes can invalidate the theorem's
   formulation even when every calculation is correct.
2. **G and C independently.** This prevents the geometric and conference
   constructions from validating each other circularly.
3. **L.** Review the uniform saturation theorem before specializing to six.
4. **R.** Review the modular extension after the integral carrier is fixed.
5. **IV and T.** Judge the series payoff and exposition only after the spine
   has survived.
6. **Priority pass.** Recheck the closest geometric, conference, modular, and
   outer-(S_6) sources under the literature-audit conventions.

## 15. Acceptance matrix

| Reader | Required packet result | Acceptable residual issue |
|---|---|---|
| Outer/invariant theorist | O = GO | notation tightening |
| Singular-cubic geometer | G = GO | one additional chart or citation |
| Conference/lattice theorist | C and L = GO | historical attribution wording |
| Modular representation theorist | R = GO | expanded standard cohomology detail |
| Series cold reader | IV and T at most MINOR | shortened perspective or roadmap |

The paper is not submission-ready if O, L, or R is MAJOR. A MINOR in G or C
may still require a new frozen surface because those packets feed the main
classification theorem. A MINOR in IV can be repaired by narrowing the
series claim without changing the core theorem.

## 16. Public-role and literature-audit boundary

The public-role links above were checked only to avoid stale affiliations and
to justify subject-overlap forecasts. They are not evidence of availability,
editorial assignment, or endorsement.

The theorem-level literature boundary remains governed by the focused Paper V
audits and `notes/literature-audit-conventions.md`. In particular:

- full text was read for the Chapman conference-lattice and
  Haemers--Parsaei Majd conference-matrix sources recorded in the Paper V
  literature audit;
- Bleher and Bendel were read only at the recorded partial theorem/section
  depth;
- the opening audit recorded seven full-text and eight partial-text sources;
- no reviewer forecast upgrades a partial read to full-text coverage;
- no negative novelty statement may be inferred from this dossier.

The old review batch's GO verdict applies only to the old placement,
outer-action, and singular-orbit surface. The current integral saturation,
golden extension, marking groupoids, and Paper IV bridge require the new
packets above.
