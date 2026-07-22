# Clebsch paper planning after C403--C412

**Lane:** `clebsch` with read-only inputs from `crowns`

**Date:** 2026-07-20

**Verdict:** `PROTECTED C399 BASELINE RETAINED; THE NEW-PAPER PLAN USES THE C406+C411 REPLACEMENT
SPINE WITH A SELECTIVE C412 MODULAR UPGRADE; NO NATURAL CUBIC-TO-DEPTH IDENTIFICATION IS CLAIMED`

**Revision 2026-07-21:** the two-paper division of the conversation dossier
(`2026-07-21-clebsch-weil-roof-conversation-report.md` §11) is adopted, and the Phase-1 weil-roof
battery has landed, so paper 1 gains the certified Rosetta ending described in the new section
below. Paper 1 = the C406+C411 spine plus the certified faces of the bit and the conjecture as a
cliffhanger; paper 2 = ownership, mechanism, and continuation, and stays in the `crowns` lane
until its own planning report exists. The architecture, gates, and routing sections carry dated
2026-07-21 updates in place.

## Executive decision

The current Clebsch project has two coherent forms.  The existing C399-led manuscript remains a
protected fallback, but the new-paper plan now uses the factorization-memory spine.  This planning
choice does not itself edit or supersede the protected manuscript source.

1. **Protected paper.**  Keep the reversible q=11 Clebsch hexagon as the centre and use C399 as
   the one portable rank-three Coxeter theorem.  This is already a strong, focused paper.
2. **Selected new-paper spine: factorization memory.**  Replace weaker descriptive passages with
   the single mechanism

   ```text
   Coxeter conic phase
     -> conic restriction forgets a secant pairing
     -> the conic-ideal quotient remembers the symmetry-selected factorizations
     -> balanced second moments recover the two sheets
     -> the first signed tensor memory is cubic
     -> H3 depth profiles enter the odd Fourier sector
     -> a singleton profile plus its matching recovers the Clebsch parent.
   ```

   C406 proves this mechanism exactly.  C411 now derives the six depth profiles conceptually from
   `A4 \ PGL_2(11) / A5` subgroup marks and one canonical incidence calculation per double coset,
   identifies the coordinates as mixed bi-Hecke matrix-coefficient data, and reduces cubic-first
   survival to one weighted barycentre relation and a three-term cubic witness.  The claim-specific
   audits find no predecessor for the composite conic-quotient/moment/Fourier theorem within the
   recorded coverage.  It is therefore a real candidate to raise the paper's ceiling, not an
   automatic seventh theorem clause.

   C412 strengthens this step without adding another arrow.  Its all-degree antipodal formula
   proves that every even signed moment vanishes and that the weighted `1:4:6` barycentre kills
   degree one, so cubic survival is forced and sharp.  The primitive dependence of the three
   positive profile rays intrinsically recovers the orbit sizes `1,4,6` and stabilizer orders
   `12,3,2`.  Modularly, the depth plane is

   ```text
   P(1)^A4 / soc(P(1)),       with Loewy layers 1|9|1,
   ```

   which conceptually explains the mixed-Hecke `6 -> 2` rank drop.  A separate canonical Tate
   two-plane in the relative-cubic module has two equivalent constructions, but C412 proves that
   the natural transfer, orbital, correlation, and rank-flag routes do **not** identify it with the
   depth plane.  That source-naturality result belongs in an appendix; the non-identification is a
   scope boundary, not a second headline.

The second form is now the selected mathematical target for the new paper: C411 supplied the
missing conceptual pass and C412 supplied its cleanest modular explanation.  Actual manuscript
integration still belongs to the paper owner and must carry the remaining source-access gaps.  If
integration is deferred, the protected first form remains independently submittable.

## Two-paper division and the paper-1 ending (revision 2026-07-21)

The dossier's division is adopted verbatim as the split rule:

- **Paper 1** — *the bit exists, is minimal, is measurable, and wears its faces*, every row
  certified, plus the roof conjecture staged as a cliffhanger. Paper 1 is this planning report's
  manuscript: the factorization-memory spine above, closed by one Rosetta section.
- **Paper 2** — *who owns the faces* (metaplectic canonicity), *the mechanism* (split torus,
  Dickson/spin-field splitting, quaternion reduction), and *the continuation* (13/19/31, the zeta
  program, the walls). Paper 2 is owned by the `crowns` lane and its results are indexed in
  `2026-07-21-clebsch-weil-roof-program.md`; it gets its own planning report after C465/C466
  land and must not be accumulated into paper 1.
- **Mutual protection:** paper 1's referee cannot demand the roof — every row in its table is a
  certificate; paper 2 inherits a certified foundation and pre-registered predictions; if the
  remaining roof clauses collapse, paper 1 stands unchanged and the sequel becomes a mechanism
  paper (it already has certified mechanism content independent of the roof).

### Paper-1 narrative arc

The spine order of the architecture section stands (steps 1–6). The revision adds the staging
frame and the closing section:

- **Frame (kills "singular exception"):** A3/B3/H3 is the complete irreducible rank-3 Coxeter
  list; each conic phase `q = h+1 = 5, 7, 11` lands on a named exceptional object, and the
  isolation theorems the paper proves (`thm-clebsch-why11`, `thm-clebsch-family-uncovered`) are
  the shadow of classifications the literature already owns. A3 is stated as the degenerate
  control, not a third full data point.
- **Closing section (one section, not six):** the Rosetta table — one row per certified
  incarnation of the bit: object, involution, certificate, credit, epistemic status. Five rows
  are funded; the sixth died by its own gating rule (below). The cliffhanger follows the table.

### Rosetta-row ledger (status at 2026-07-21)

| Row | Face                                  | Status | Certificates / notes |
|:----|:--------------------------------------|:-------|:----------------------|
| 1   | Design polarity (Fano / biplane)      | CERTIFIED | C450 Gram profiles; C452 QR difference sets; uniqueness classical |
| 2   | QR perfect-code outer symmetry        | CERTIFIED (bundle pending) | C452; exact span probe checked; durable bundle = C464 (queued); no `M_12` claim |
| 3   | `mu_3` sign / low-degree threshold    | PROVED | C406/C412/C430; the paper's own spine |
| 4   | Advice complexity exactly one         | PROVED, STRENGTHENED | C413/C379/C417 as planned; C456/C467 resolved the dossier's AME trap the labeled way: all-degree LU collapse, so the advice framing is the theorem, not a hedge |
| 5   | Frobenius / spin-prime covariation    | CERTIFIED AS A LAW | C453 mod-40 fusion law with the exact `(2/q)` cut; the load-bearing row landed; mechanism (Dickson/biquadratic) stays in paper 2 (C466) |
| 6   | Theta / Arf parity                    | DEAD — omit | C451: Arf differs across primes but does not separate the sheets; the dossier's gating rule ("five rows is fine") applies |

### Cliffhanger (three beats, updated to certified form)

1. *Mystery* — the 5/6 dimensional coincidence plus C455's exact scoped statement (the three
   frozen matrices restrict one ambient `Sp_6(F_11)` Weil Weyl operator; genuine normalization
   `rho(w) = iF`). State only the certified scoped wording; C450's sharp negative forbids any
   module-identification phrasing.
2. *Prophecy* — no longer a blind guess: the certified mod-40 law says the bit survives at 19 and
   fuses at 31 (`(2/31) = +1`), with the H4/600-cell phase as the gated tease. This is stronger
   than the dossier's version because it is a proved law applied forward, not a prediction.
3. *Stakes* — the walls: perfect codes end at 11, odd Barker at 13 (and 13 is golden-inert —
   one-sentence remark only), polytopes at 19 in the ambient classification only (the red-team
   category fix). A q=13 phase must collect the last odd Barker word or the tower ends at 11.

### Red-team discipline carried into drafting

11-cell claims at vertex-facet design level only; dualities vs polarities stated correctly;
"chirality" disambiguated from chiral-polytope usage at first use; the `+/-6` readout staged as
measurable-given-decoration, never determinable-from-child; no `M_12` overclaim
(`PSL_2(11)` maximal in `M_11`); Paley-deflation credit (Pan–Wu–Yin and classical QR territory)
carried from the C406 audit into the table's credit column; every row's literature audit per
`literature-audit-conventions.md` before any absence wording.

### Paper-1-facing intake from the 2026-07-21 weil-roof battery

Only these enter paper 1, and only through the ledger above: C450 (row 1), C452 (rows 1–2 and
the Barker wall), C464 when landed (row 2 bundle), C453 (row 5 and the prophecy beat), C451
(row 6 death, one boundary sentence), C455 (mystery beat, scoped sentence only), C456/C467
(row 4 strengthening; the golden-Fourier-duality mechanism itself is paper-2 material with a
one-line pointer from paper 1). Everything else from the battery — torsors (C462/C463), split
torus (C449), quaternion reduction (C457), Dickson/biquadratic (C466), Brauer bridge (C465),
zeta program (C468), Klein degeneration — is paper 2 and appears in paper 1 only inside the
cliffhanger's pointers, if at all.

## Complete results -> paper -> proofs ledger

### Retained original-paper results

These rows reuse the canonical IDs already allocated in `papers/papers-index.md`.  They make the
baseline inheritance explicit: the replacement spine changes the organizing mechanism, not the
identity or provenance of the original theorems it still consumes.

| ID | Source / task | Result | Origin / boundary | In new paper? | Proof or evidence location |
|:---|:---|:---|:---|:---|:---|
| `comp-clebsch-a5-point-orbits` | Original manuscript | Full `A5` point-orbit profile `[6,10,12,15,30,30,30]` | Classical Dye orbit geometry; local derivation, identification, and verification | **Yes — geometric setup** | paper §3 Prop `prop:a5-point-orbits`; registry `papers-index.md` |
| `thm-clebsch-rigidity` | Original manuscript | Five-way rigidity theorem recovering the Clebsch class and `A5` from the conic deep-hole condition | Local theorem using Dye's classical equality classification at one boundary | **Yes — central/closing theorem** | paper §4 Thm 4.3; conceptual proof plus bounded census; registry `papers-index.md` |
| `thm-clebsch-gap` | Original manuscript | Sharp global and one-point-perturbation gap from the Clebsch conic locus | Local finite theorem | **Yes — retained quantitative rigidity** | paper §4 Thm 4.7; `check_global_conic_gap.py`, `check_perturbation_gap.py` |
| `comp-clebsch-low-degree-loci` | Original manuscript | Degree-at-most-three rigidity and sharp quartic companion | Local computed classification with independent algebra replay | **Yes — compact retained result** | paper §4 Prop 4.4 and Remark 4.6; `check_low_degree_loci.py`; Singular replay |
| `comp-clebsch-u-spectrum` | Original manuscript | Six-arc uncovered-locus spectrum in `PG(2,11)` | Classical Hirschfeld--Sadeh/Sadeh classification; locally recomputed only | **Yes — classical context, no local claim** | paper §4; priority and verification record in `papers-index.md` |
| `thm-clebsch-chirality` | Original manuscript | Intrinsic unordered `10+10` support bipartition of deep-hole leaders | Local family-specific theorem; outer-`S6` dictionary classical | **Yes — reconstruction endpoint** | paper §5 Props 5.1, 5.3; checkers; `Q11DecodingSynthesis.lean` |
| `thm-clebsch-decoding` | Original manuscript | Complete distance oracle and decoder-ambiguity geometry | Local synthesis; Brianchon/Petersen geometry classical | **Yes — operational bridge** | paper §3 Prop 3.5 and §5 Cor 5.2; `check_decoding.py`; `Q11DecodingSynthesis.lean` |
| `thm-clebsch-why11` | Original manuscript | Classification-free uniqueness of q=11 for conic-filling six-arcs | Local theorem using classical small-field facts | **Yes — compact uniqueness theorem** | paper §6 Thm 6.2; `check_small_q_uniqueness.py`; `ClebschChordDefect.lean`, `Q9Sylvester.lean` |
| `thm-clebsch-family-uncovered` | Original manuscript | All-field uncovered formula `q^2-14q+45` and isolated conic filling at q=11 | Local exact formula; Dye's non-secant criterion classical | **Yes — arithmetic-phase context** | paper §6 Prop 6.3; hand proof; q=19 independent replay |
| `thm-clebsch-reflection-arrangements` | Original manuscript / C211 | Exact `A3/H3` organization of the q=5 and q=11 conic-filling cases | Local compatibility theorem; reflection arrangements classical | **Yes — bridge into C399** | paper §6 Prop `prop:h3-arrangement`; `check_reflection_arrangements.py`; Lean terminals in registry |
| `thm-conic-filling-kle7` | Original manuscript | Classification of full-conic extension loci for `4<=k<=7` | Local theorem with finite checker leaves | **Yes — compact classification** | paper §6 Thm 6.6; `check_small_k_conic_filling.py`; `SmallKChordMoments.lean`, `SmallKGeometricBridge.lean` |
| `comp-q9-exclusion` | Original side computation | q=9 icosahedral six-arc is complete | Classical SVM result independently reverified | **No — not a claim or dependency** | `check_q9_exclusion.py`; registry `papers-index.md` |
| `comp-q19-nonexample` | Original manuscript remark | q=19 icosahedral six-arc has exactly 140 deep holes | Classical Dye geometry plus local independent replay | **Yes — boundary example** | paper §6 Remark 6.4; `check_q19_nonexample.py` |
| `comp-clebsch-dual` | Original side computation | Dual code is again a Clebsch hexagon code | Local computation | **No — deliberately omitted** | `check_dual_code.py` |
| `comp-clebsch-mathieu` | Original side computation | Two icosahedral hexads are transverse to the Mathieu hexads | Local computation; Steiner system classical | **No — deliberately omitted** | `check_mathieu_hexads.py` |
| `comp-clebsch-ten-arc-foil` | Original side computation | Same-`A5` ten-arc foil has no deep holes | Local computation | **No — deliberately omitted** | `check_ten_arc_foil.py` |

### Crowns intake results

This is the intake index for completed Clebsch-facing and Clebsch-adjacent results from the
2026-07-19/20 crowns push.  It includes rejected imports so that “not in the paper” is an explicit
decision rather than an omission.  It does not index unrelated crowns work on the cap game or the
other arc/code manuscripts, and it does not mix queued C413--C419 work with landed results.

The **ID** column uses stable result IDs in the `papers-index.md` style; the **source / task** column
records where the result landed.  The **origin / boundary** column separates locally established claims from classical machinery and
pre-emption.  “Local synthesis; classical inputs” means the stated composition or compatibility is
ours, while its named configurations, dictionaries, or general formalism are not.  “Local
negative” records a proved obstruction or bounded stop, not a failed theorem silently discarded.

| ID | Source / task | Result | Origin / boundary | In new paper? | Proof or evidence location |
|:---|:---|:---|:---|:---|:---|
| `thm-clebsch-arithmetic-phase` | C368 | All-odd arithmetic phase; q=11 non-GRS parent to full-conic GRS child | Local theorem; conic--GRS and reduction dictionaries classical | **Yes — main input** | note `2026-07-19-c368-h3-a5-arithmetic-phase.md` |
| `thm-frame-service-target-recovery` | C369 | Uncoloured frame graph recovers maximal-service target triple | Local bridge; service/PIR language classical | **No — separate application** | note `2026-07-19-c369-intrinsic-frame-service-bridge.md` |
| `thm-mirror-extension-periodicity` | C370 | Exact mirror-family extension periodicity and repair base change | Local theorem; orbit decomposition and Minkowski additivity classical inputs | **No — different family** | note `2026-07-19-c370-mirror-extension-periodicity.md` |
| `lem-clebsch-crossfield-priority-boundary` | C371 | Cross-field AME/scheme priority audit | Source audit identifying classical infrastructure and open priority gaps | **Yes — attribution boundary** | note `2026-07-19-c371-clebsch-cross-field-literature-audit.md` |
| `thm-clebsch-fourier-self-duality` | C372 | Primitive Fourier-self-dual rank-eight `A5` fission, `P=Q` | Local exact theorem; translation schemes and Fourier duality classical | **Yes — compressed endpoint** | note `2026-07-19-c372-clebsch-scheme-fourier.md` |
| `thm-clebsch-intrinsic-chirality` | C373 | Full affine automorphism group and intrinsic unordered `10+10` chirality torsor | Local family-specific theorem; general affine rigidity pre-empted | **Yes — closing theorem** | note `2026-07-19-c373-clebsch-scheme-automorphisms.md` |
| `thm-clebsch-ame-grs-separation` | C374 | Clebsch `AME(6,11)` separated under LC and LU from every six-point GRS class | Local exact separation; MDS-to-AME construction classical | **Yes — corollary/endpoint** | note `2026-07-19-c374-clebsch-ame-equivalence.md` |
| `comp-clebsch-ame-circuit-layouts` | C375 | Three-gate preparation and classification of Bell-triangle layouts | Local finite theorem; stabilizer-circuit formalism classical | **No — companion result** | note `2026-07-19-c375-clebsch-ame-circuit.md` |
| `thm-clebsch-cubic-chirality` | C376 | Clebsch-cubic double-six exchange equals code-chirality character | Local compatibility theorem; Clebsch cubic and double-sixes classical | **Yes — compact endpoint** | note `2026-07-19-c376-clebsch-cubic-chirality.md` |
| `lem-clebsch-golden-descent` | C377 | Integral golden map and split/inert/ramified descent | Exact local specialization; general outer `A5` Galois descent pre-empted by Benson | **Yes — brief glue, no novelty claim** | note `2026-07-19-c377-clebsch-golden-descent.md` |
| `thm-clebsch-golden-fusion` | C378 | Golden completion to `PGL_2(11)`, rank-16 refinement, signed Fourier sector | Local exact theorem; coherent refinements and Fourier formalism classical | **Yes — main bridge** | note `2026-07-19-c378-clebsch-common-duality.md` |
| `thm-clebsch-matching-parent-recovery` | C379 | Matching-decorated parent recovery; two one-factorizations and biplane incidence | Local code/deep-hole compatibility; `5/14/22`, biplane, and relation skeleton classical Edge/Dye territory | **Yes — main payoff** | notes `2026-07-19-c379-clebsch-deep-hole-extension.md`, `2026-07-19-c379-one-factorization-biplane-companion.md` |
| `lem-clebsch-gateway-verification` | C380 | Lean foundations for the q=11 transform, matching recovery, sheets, and Fourier block | Local formalization/verification boundary | **Yes — verification map** | note `2026-07-19-c380-clebsch-gateway-lean-foundations.md`; Lean gate `RelativeConicArcs.Gates.ClebschGateway` |
| `thm-clebsch-marked-e8-recovery` | C381 | Marked `E8` root types recover matching, parent, and MDS status | Local exact classification; root-lattice language classical | **No — companion extension** | note `2026-07-19-c381-clebsch-e8-extension-obstruction.md` |
| `thm-clebsch-icosian-noncomparison` | C382 | No marked icosian comparison in the required equivariant category | Local negative; icosian and Weyl-group infrastructure classical | **No — boundary only** | note `2026-07-19-c382-clebsch-icosian-e8-path-independence.md` |
| `comp-prs-apolar-orbit-separation` | C383 | Apolar plane separates the tested projective Reed--Solomon deep-syndrome orbits | Local bounded theorem; apolarity and factorization strata classical | **No — portable companion** | note `2026-07-19-c383-prs-deep-hole-marked-root-transfer.md` |
| `comp-clebsch-ame-pencil-classes` | C384 | Two non-GRS classes in the full q=11 equal-phase pencil, separated under LC/LU | Local finite classification | **No — C374 suffices for this paper** | note `2026-07-19-c384-clebsch-ame-family-classification.md` |
| `comp-clebsch-pof-negative` | C385 | Neither Clebsch one-factorization is perfect | Local bounded negative; perfect-one-factorization question classical | **No — negative companion** | note `2026-07-19-c385-clebsch-perfect-one-factorization-gate.md` |
| `thm-mirror-cayley-nimber-zero` | C388 | Regular four-generator mirror scar has nimber zero | Local game theorem; Cayley normalizer method classical infrastructure | **No — different paper/programme** | note `2026-07-19-c388-cubic-mirror-isolator.md` |
| `thm-frobenius-cayley-layers` | C389 | Exact Frobenius-degree Cayley layers and two-phase repair geometry | Local theorem; place-counting and convex-resource machinery classical | **No — different paper/programme** | note `2026-07-19-c389-universal-exact-degree-base-change.md` |
| `thm-frame-service-spectrum` | C391 | Exact three-level service spectrum while majority radius is zero | Local application theorem | **No — service companion** | note `2026-07-19-c391-frame-service-spectrum.md` |
| `thm-clebsch-sheet-service-obstruction` | C392 | Uncoloured q=11 graph forgets which sheet defines projection targets | Local obstruction | **No — service boundary** | note `2026-07-19-c392-clebsch-two-sheet-service.md` |
| `thm-clebsch-ame-pencil-arithmetic` | C395 | All-odd-field AME pencil and exact symmetry-enhancement primes | Local arithmetic theorem; GRS/AME dictionaries classical | **No — companion context** | note `2026-07-20-c395-clebsch-ame-pencil-arithmetic.md` |
| `comp-clebsch-fullconic-classification` | C398 | Four semilinear classes of full-conic deepest-syndrome six-arcs | Local exact classification; q=11 exterior six-arc classical | **Yes — compact global envelope** | note `2026-07-20-c398-conic-deep-hole-classification.md` |
| `thm-rank3-reflection-complement-code` | C399 | Uniform `A3/B3/H3` nonmirror maximum, distance, and Coxeter conic phase | Local synthesis; individual configurations and marker fibres classical Edge/Dye results | **Yes — portable prelude** | note `2026-07-20-c399-coxeter-number-conic-phase.md`; audit `2026-07-20-c399-literature-audit.md` |
| `thm-a5-fourier-phase-law` | C400 | Uniform scalar-`A5` rank/orbit law and six conic-relation phases | Local exact synthesis; projective-line orbit ladder pre-empted | **No — optional context only** | note `2026-07-20-c400-a5-fourier-phases.md` |
| `thm-weighted-adjoint-code-enumerator` | C403 | Weighted 2-adjoint enumerator, Coxeter word orbits, and all-degree pairing-forgetting quotient | Local theorem; finite-field/coboundary method and GRS matroid classical | **Yes — main forgetting theorem** | note `2026-07-20-c403-arrangement-complement-distance.md` |
| `lem-clebsch-marker-priority-boundary` | C404 | Proposed marker flagship pre-empted at its first literature gate | Classical/pre-empted result; no local flagship claim | **No** | portfolio note `2026-07-20-c403-c405-c399-successor-portfolio.md` |
| `comp-twisted-cubic-deephole-classification` | C405 | No non-GRS twisted-cubic-locus survivor; q=9 Cayley-octad/Hermitian-quartic near miss | Local exhaustive classification and exact near-miss theorem; Cayley-octad geometry classical infrastructure | **No — separate future paper** | note `2026-07-20-c405-twisted-cubic-deep-hole-pilot.md` |
| `thm-conic-factorization-memory` | C406 | Conic-ideal ranks `3,6,10`; unique balanced sheets; cubic orientation; H3 depth--Fourier bridge | Local composite theorem; `5/14/22`, one-factorizations, designs, and coarse Hadamard orbitals classical | **Yes — central theorem** | note `2026-07-20-c406-matching-module.md`; audit `2026-07-20-c406-priority-audit.md` |
| `lem-weighted-adjoint-code-corollaries` | C407 | Scalar tower, generalized weights, circuits/Tutte, radius-two, and minimal-word corollaries | Local derivations, but conventional consequences of C403 | **No — cite companion** | note `2026-07-20-c407-c403-free-arrangement-code-upgrades.md` |
| `thm-pointed-profile-forgetting` | C408 | Global enumerator/Tutte package forgets pointed repair and sometimes syndrome multiplicity | Local sharp negative/control | **No — limitation companion** | note `2026-07-20-c408-pointed-profile-forgetting-gate.md` |
| `lem-cubic-first-memory` | C409 | Exact-strength-two signed-moment filtration and Pasch sharpness | Local specialization/normalization; moment and trade formalism classical | **Yes — brief lemma/remark** | note `2026-07-20-c409-cubic-first-memory-principle.md` |
| `comp-same-tower-pointed-negative` | C410 | No same-tower pointed collision among all spanning q=7 six-point closures | Local bounded negative | **No — successor boundary** | note `2026-07-20-c410-same-tower-pointed-collision.md` |
| `thm-clebsch-double-coset-depth` | C411 | Six-representative mixed double-coset derivation and cubic-first pushforward | Local exact realization; double cosets, marks, and mixed-Hecke language classical | **Yes — conceptual proof** | note `2026-07-20-c411-double-coset-hecke.md` |
| `thm-clebsch-relative-cubic-tate` | C412 | All-degree parity, intrinsic `1:4:6`, projective-cover depth quotient, and canonical Tate plane; no natural identification of the two planes | Local theorem and local negative; Tate/Brauer/covariant infrastructure classical | **Yes — main lemma, compact proposition, appendix** | note `2026-07-20-c412-relative-cubic-depth-plane.md` |

Queued C413--C417 remain outside this results ledger.  They may change future editions only after
landing and passing the same paper-disposition and classical-boundary review.

## Safe C406 claim surface

The paper may say, with the qualifications in the priority audit:

- the canonical secant-product differences divide by the conic equation and have exact image
  ranks `3,6,10`, uniformly described by the top conic-harmonic layer plus the radial line in even
  degree;
- in B3 and H3, the two `PSL_2(q)` factorization sheets are the unique complementary equal halves
  with equal first and second tensor moments;
- their signed moments vanish in degrees one and two and first survive in degree three, giving a
  cubic orientation character whose stabilizer inside `PGL_2(q)` is `PSL_2(q)`;
- for H3, the original secant products give six `A4` depth-profile fibres of sizes
  `1,4,6 / 1,4,6`, an exact `22 -> 6 -> 2 -> 1` information lattice, and a `J`-odd map into
  C378's Fourier-stable odd sector; and
- the singleton fibres recover the unordered golden matching pair and hence, through C379, the
  unordered golden parent pair.  A chosen sheet and matching select one parent.
- C411 derives those six profiles from the mixed double-coset space
  `A4 \ PGL_2(11) / A5`: subgroup marks give `1,4,6 / 1,4,6`, six canonical secant-incidence
  representatives give the vectors, and `J`-antipodality plus `v1+4v2+6v3=0` gives the vanishing
  first/second pushed moments and nonzero cubic.  The depth map has rank two and four-dimensional
  linear kernel, although it separates all six double-coset labels as a set.
- C412 upgrades the cubic-first statement to the all-degree antipodal parity formula and shows that
  the three positive profile rays intrinsically recover the primitive dependence `1:4:6`; it also
  identifies the depth plane as `P(1)^A4/soc(P(1))`, explaining the rank drop modularly.

The paper must not claim:

- novelty for the `5/14/22` marker spaces, their exceptional one-factorizations, their status as
  matching-scheme designs, or the coarse `PGL_2(11)/A5` Hadamard orbital geometry;
- novelty for double-coset enumeration, subgroup marks, mixed Hecke bimodules, or matrix-coefficient
  language; C411's likely-new content is the exact secant-depth realization and compressed cubic
  trade within that classical interface;
- that the cubic relative invariant is unique—the outer-odd cubic space has dimension three;
- that a Hessian, contraction, or singular locus canonically recovers the H3 `4+5` splitting or
  the individual quotient points;
- a linear cubic-to-C378 intertwiner—the scalar weights obstruct it;
- that the undecorated GRS child remembers a matching, parent, or chirality; or
- a universal cubic-first law.  C409 shows that exact strength two is the relevant hypothesis and
  that higher-strength trades survive later.
- that C412's canonical relative-cubic Tate plane is naturally the C411 depth plane.  Their labelled
  source relations are `[2,9,1]` and `[2,8,1]`, and divided transfer separates rather than
  identifies them.

## Best paper architecture from the present evidence

If the C406 branch is selected, the paper should become shorter in theorem count and stronger in
mechanism.  A recommended order is:

1. the integral H3 hexagon and the C399 Coxeter conic phases, staged with the complete-rank-3
   frame (revision 2026-07-21: the "singular exception" rebuttal is the opening posture, with A3
   as the stated degenerate control);
2. the q=11 non-GRS parent and its full-conic GRS deep-hole child;
3. C403's precise forgetting theorem and the conic-ideal factorization quotient;
4. C406's harmonic image, balanced-sheet reconstruction, and cubic orientation;
5. C411's mixed bi-Hecke derivation of the H3 depth profiles, C412's parity/primitive-dependence
   theorem and compact projective-cover quotient, followed by C378's odd Fourier map and C379
   decorated parent recovery;
6. C372/C373 intrinsic syndrome algebra and return to the unmarked hexagon;
7. (revision 2026-07-21) the closing Rosetta section — the five certified rows of the ledger
   above, the credit column carried from the audits, and the three-beat cliffhanger — followed by
   nothing: the table is the ending, and one soft row would poison it.

C376's cubic-surface character and C374's AME separation are strong corollaries or companion
endpoints.  They should not become coequal spines.  C407--C409 should be compressed to the exact
lemmas or scope controls they supply.  C456/C467 enter only as the row-4 strengthening sentence
and a pointer; their mechanism content is paper 2's.

## Remaining decision gates

1. **Conceptual proof — complete and modularly sharpened.**  C411 replaces the 22-matching table by subgroup marks, six
   canonical representatives, and a three-term cubic argument.  Its mixed bi-Hecke interpretation
   is precise: the map is rank two and set-separating, not a faithful linear quotient or a zonal
   spherical-function theorem.  C412 explains the target rank drop through the projective cover
   `P(1)` and proves the all-degree parity and primitive-dependence statements.  Its failed
   source-to-depth identification is the final boundary, not an open prerequisite.
2. **Priority confidence.**  Carry the explicit C406/C411 audit gaps into the manuscript.  Close
   MathSciNet, Google Scholar, zbMATH, and the uncovered forward-citation branches if access permits;
   otherwise use only “no predecessor located within the recorded coverage.”  C378's own bounded
   priority also qualifies the Fourier endpoint.
3. **Architecture choice — now ripe.**  Choose the protected C399 paper or the C406+C411
   replacement.  The latter is this report's recommendation.  Do not merge both full outlines.
4. **Freeze and formalize.**  Once chosen, freeze one copy-ready theorem and dependency graph.
   Lean should prove the structural quotient, harmonic decomposition, moment invariance, and
   cubic-sign implication; finite ranks, orbit uniqueness, and profile tables remain checked
   certificate leaves unless separately promoted.
5. **External read and release.**  Obtain a cold mathematical/priority read, then perform the
   mixed-verification, exact-commit pinning, provenance, rendering, and immutable-artifact steps in
   the paper handoff.
6. **(Added 2026-07-21) Rosetta-row promotion and audits.**  Before drafting the closing section:
   C464 must land (row 2's durable bundle); each row needs its bounded literature audit per
   `literature-audit-conventions.md` (rows 1–2 sit in heavily classical QR/design/code territory;
   the dossier's Paley-deflation credit list is the starting point); and the terminology fixes
   (chirality disambiguation, dualities vs polarities, vertex-facet-level 11-cell wording) are
   applied at first drafting, not in revision.  Row content is frozen to certificates only — any
   upgrade landed later by paper-2 work (C465/C466/C468) changes the *sequel*, not this table.

C410 now closes every spanning q=7 six-point external-line closure, not the broader pointed-memory
problem.  C418 and C419 own the active seven/eight-point balanced-trade and fixed-incidence-moduli
attacks.  The independent C405/C401/C402 and C413--C419 queues may continue in parallel, but none
should delay this plan or be accumulated into the same manuscript.

## Cold-session routing

Read in this order:

1. `notes/handoffs/2026-07-13-clebsch-paper.md` for the live manuscript decision;
2. this report for the current theorem/novelty map;
3. `notes/2026-07-20-c406-matching-module.md` for the exact theorem and negative results;
4. `notes/2026-07-20-c406-priority-audit.md` for classical ownership and access gaps;
5. `notes/2026-07-19-clebsch-hexagons-are-the-bestagons-spine.md` for the protected exposition
   baseline and candidate replacement architecture;
6. `notes/2026-07-20-c411-double-coset-hecke.md` for the conceptual profile/cubic proof;
7. `notes/2026-07-20-c412-relative-cubic-depth-plane.md` for the selective modular upgrade and its
   non-identification boundary;
8. `notes/2026-07-20-c411-c417-c406-successors.md` only for companion research after C412;
9. `notes/handoffs/2026-07-17-crowns.md` for live research ordering outside the manuscript lane;
10. (revision 2026-07-21) `notes/2026-07-21-clebsch-weil-roof-conversation-report.md` §§2–4, 11
    for the staging frame, red-team fixes, and two-paper division, and
    `notes/2026-07-21-clebsch-weil-roof-program.md` (read-only) for the certification status of
    every Rosetta-row input.

No cold session should infer a manuscript edit from a completed crowns theorem.  That transfer is
owned by the `clebsch` paper lane and remains an explicit architecture decision.
