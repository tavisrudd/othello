# Clebsch factorization-memory paper planning

**Lane:** `clebsch` with read-only inputs from `crowns`

**Date:** 2026-07-20

**Verdict:** `PROTECTED C399 BASELINE RETAINED; PAPER 1 USES THE C406+C411 REPLACEMENT SPINE,
SELECTIVE C412 MODULAR UPGRADE, C445 ARITHMETIC-GLUING CLOSE, AND AN EXACT SURVIVAL/FORGETTING
LEDGER; NO NATURAL CUBIC-TO-DEPTH OR UNIVERSAL WEIL IDENTIFICATION IS CLAIMED`

**Revision 2026-07-21:** the two-paper division is adopted.  Paper 1 is the C406+C411
factorization-memory spine, selectively sharpened by C412 and closed by C445 plus the certified
survival/forgetting ledger.  Paper 2 owns canonicity, arithmetic mechanism, and continuation and
stays in the `crowns` lane until its own planning report exists.

**Late revision 2026-07-21:** C444--C468 sharpen the ending into an exact
**survival/forgetting ledger**.  C445 supplies the rank-three
arithmetic-gluing close, C464 closes the perfect-code evidence row, and C453+C466 separate the
paper-facing mod-40 law from its sequel-level subgroup mechanism.  The clean negatives C450,
C451, C454, C456, and C467 are retained as erasure/non-identification theorems rather than omitted
failed rows.  C457, C459, C462, C463, C466, and C468 make paper 2 concrete but do not enlarge paper
1's proof body.  The complete result and paper-disposition inventory now lives in
`2026-07-21-clebsch-weil-roof-results-ledger.md`; this document keeps only the narrative and
manuscript decisions needed in a cold session.

The high-level generalist compression test, possible unseen connections, adopted exposition
changes, and remaining theorem-xref TODOs are recorded in
`2026-07-21-clebsch-high-level-reader-cold-read.md`.  This is an internal checklist, not an
external review or an attribution to the named reader who motivated the thought experiment.

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

- **Paper 1** — *the bit exists, is minimal, is recoverable, and has an exact survival/forgetting
  profile under natural passages*, every row certified, plus the roof conjecture staged as a
  cliffhanger. Paper 1 is this planning report's manuscript: the factorization-memory spine above,
  closed by one compact ledger section.
- **Paper 2** — *who owns the faces* (metaplectic canonicity), *the mechanism* (split torus,
  Dickson/spin-field splitting, quaternion reduction), and *the continuation* (13/19/31, the zeta
  program, the walls). Paper 2 is owned by the `crowns` lane and its results are indexed in
  `2026-07-21-clebsch-weil-roof-program.md`; it gets its own planning report after C465 receives a
  disposition and the Phase-3 synthesis freezes the roof verdict.  It must not be accumulated into
  paper 1.
- **Mutual protection:** paper 1's referee cannot demand the roof — every survival and erasure row
  in its table is a theorem or certificate; paper 2 inherits a certified foundation and
  pre-registered predictions.  The literal module, theta, and quantum identifications have already
  collapsed without weakening paper 1; the sequel is now a mechanism paper with certified
  quaternion, descent, torsor, Dickson, and zeta content independent of a universal roof.

### Opening narrative and graphic sweep

The polished paper opens with a three-to-five-page proof-free guided tour after the conventional
introduction.  Its purpose is to give the reader one mental model before coordinates, finite
certificates, double cosets, modular modules, or Lean boundaries appear.  It must not preview every
companion result.

The main figure is one left-to-right theorem diagram:

```text
Clebsch parent + secant matching
  -- conic restriction forgets pairing/orientation --> full-conic GRS child
  -- divide factorization differences by Q --------> 22 quotient points
  -- balanced first/second moments ----------------> unique unordered 11+11 sheets
  -- first nonzero signed cubic moment ------------> oriented sheet bit
  -- A4 double-coset depth map --------------------> six profiles 1,4,6 / 1,4,6
  -- singleton profile + matching -----------------> Clebsch parent recovered.
```

Every arrow is labelled by its theorem and by one of four verbs: **forgets**, **recovers
unordered**, **orients**, or **reconstructs**.  Solid arrows are Paper-1 theorems, blocked arrows
are proved non-identifications, and at most one dashed arrow points to the sequel's metaplectic
question.  Classical objects and locally new transport theorems use distinct grayscale-safe node
styles.  The conceptual figure is not combined with the Lean dependency graph, which remains in
the verification section or supplement.

A second compact rank-three panel displays only the complete input frame:

| type | `h` | `q=h+1` | projective matching behaviour | certified carrier |
|:---|---:|---:|:---|:---|
| A3 | 4 | 5 | antipodal marker fused | fused control; companion `C2` torsor is a sequel pointer |
| B3 | 6 | 7 | two `PSL_2(7)` sheets | silver/spin reduction and cubic sign |
| H3 | 10 | 11 | two golden `PSL_2(11)` sheets | matching, cubic orientation, and arithmetic gluing |

The opening sweep ends with the survival/forgetting table below.  Proof sections then establish
the arrows in the same order, without repeating the narrative exposition.

### Paper-1 narrative arc

The spine order of the architecture section stands (steps 1–6). The revision adds the staging
frame and the closing section:

- **Frame (kills "singular exception"):** A3/B3/H3 is the complete irreducible rank-3 Coxeter
  list; each conic phase `q = h+1 = 5, 7, 11` lands on a named exceptional object, and the
  isolation theorems the paper proves (`thm-clebsch-why11`, `thm-clebsch-family-uncovered`) are
  the shadow of classifications the literature already owns. A3 is stated as the degenerate
  control, not a third full data point.
- **Closing section (one section, not six):** the survival/forgetting table — one row per natural
  passage, recording whether orientation survives, what weaker structure remains, the exact
  certificate, and the classical-credit boundary.  Positive and negative rows are coequal results;
  the cliffhanger follows the completed ledger.

### Paper-1 survival/forgetting ledger (status at 2026-07-21)

| Passage / carrier | Status of orientation | Exact retained structure | Certificates / boundary |
|:---|:---|:---|:---|
| Unmarked conic child | **forgotten** | full-conic GRS child | C403/C421; no matching, parent, or chirality claim |
| First and second quotient moments | **unoriented recovery** | unique complementary balanced sheets | C406/C430/C424 |
| Signed cubic moment | **oriented** | determinant-square character and sharp degree-three threshold | C406/C412/C420/C423--C424 |
| Decorated depth profiles | **parent recovered** | `1,4,6 / 1,4,6`, singleton matching, then golden parent | C411/C412/C425 with C379 |
| Design and perfect-code passage | **structural shadow retained** | QR difference designs, Barker words, perfect Hamming/Golay-parameter spans | C452/C464; classical design/code credit; no `M_12` claim and no unproved ternary uniqueness claim |
| Golden reduction across primes | **visible or fused** | exact mod-40 law controlled by `(5/q)` and `(2/q)` | C453; C459/C466 mechanism stays in paper 2 |
| Theta / Arf passage | **forgotten** | Lagrangian packings and superspecial Jacobians remain | C451; parity is not a sheet detector |
| Quantum LU passage | **forgotten** | exact equivalence bitorsor and signed-Fourier duality remain | C456/C467; advice concerns geometric parent choice, not a quantum LU invariant |
| Ambient Fourier restriction | **projective shadow only** | one scoped Weil-Weyl operator restriction | C455; C450/C454 forbid module-identity and Klein-five-space wording |

### Cliffhanger (three beats, updated to certified form)

1. *Mystery* — the 5/6 dimensional coincidence plus C455's exact scoped statement (the three
   frozen matrices restrict one ambient `Sp_6(F_11)` Weil Weyl operator; genuine normalization
   `rho(w) = iF`). State only the certified scoped wording; C450's sharp negative forbids any
   module-identification phrasing.
2. *Prophecy* — no longer a blind guess: the certified mod-40 law says the bit survives at 19 and
   fuses at 31 (`(2/31) = +1`).  C466 proves the rational-`S4`/Dickson mechanism on the tested
   golden-split primes, while C468 supplies an independent good-prime arithmetic carrier that is
   explicitly blind to fusion.  Paper 1 states the law and points to these sequel results without
   importing their proofs or claiming an H4 construction.
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

Paper 1 directly imports C444/C445's rank-three matching and arithmetic-gluing close, C449's
compact split-torus mechanism, C460's supporting hinge geometry, C452/C464's design/perfect-code
row, C453's mod-40 law, C451's theta-erasure boundary, C455's scoped Weil-Weyl sentence, and
C456/C467's quantum-erasure boundary.  C450 and C454 supply mandatory non-identification wording.

Quaternion reduction (C457), rational descent (C459), companion torsors (C462/C463), the Dickson
proof (C466), and Klein-cubic zeta functions (C468) are paper-2 results and appear in paper 1 only
as concise pointers after the certified ledger.  C446--C448 remain unallocated selector results.
C465 remains allocated without a landed disposition and is not a Paper-1 gate.  The complete
result-by-result record, including all infrastructure and unallocated rows, is
`2026-07-21-clebsch-weil-roof-results-ledger.md`.

## Complete results -> paper -> proofs ledger

This document retains the original-paper and pre-roof crowns ledgers below.  The complete
C440--C468 battery ledger is split to `2026-07-21-clebsch-weil-roof-results-ledger.md` so cold
sessions need not load every result report or carry a second full-width table in this planning
document.  Every landed positive and negative result is listed there even when assigned to neither
paper; C465 is recorded separately as open rather than being represented as a result.

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

C413--C417 are not expanded in this pre-roof table.  Their paper-facing consequences are included
only where adopted by the survival/forgetting plan; any other landed clauses remain companion
results until they pass an explicit paper-disposition and classical-boundary review.

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

The copy-ready abstract, three-figure opening sweep, Theorems A--D, section order, appendix split,
and drafting constraints are in `2026-07-21-clebsch-paper-abstract-outline.md`.  The actual prose
draft of the proof-free first section and conclusion is
`2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`.  The governing order is:

1. introduction and proof-free graphic sweep of the full reconstruction arc;
2. Clebsch rigidity and the complete A3/B3/H3 Coxeter conic phase;
3. conic restriction, the factorization quotient, and balanced-sheet recovery;
4. cubic-first orientation, six depth profiles, and parent reconstruction;
5. the A3/B3/H3 matching theorem and H3 arithmetic-gluing close;
6. one survival/forgetting ledger containing both positive shadows and proved erasures;
7. verification architecture and one scoped sequel question, followed by nothing.

C376's cubic-surface character and C374's AME separation are strong corollaries or companion
endpoints.  They should not become coequal spines.  C407--C409 should be compressed to the exact
lemmas or scope controls they supply.  C456/C467 enter as the exact quantum-erasure row, not as a
positive chirality face.  C457/C459/C462/C463/C466/C468 remain sequel pointers even though their
certificates are complete.

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
3. **Architecture choice — frozen.**  The C406+C411 replacement is selected; the C399 manuscript
   remains a protected fallback only.  Do not merge the two full outlines.
4. **Formalize and reconcile.**  Complete the selected Lean campaign and C320 trust-ledger
   capstone against the copy-ready Theorems A--D.  Structural quotient, harmonic decomposition,
   moment invariance, and cubic orientation are formal proof targets; finite leaves retain their
   checker/certificate boundary unless separately promoted.
5. **External read and release.**  Obtain a cold mathematical/priority read, then perform the
   mixed-verification, exact-commit pinning, provenance, rendering, and immutable-artifact steps in
   the paper handoff.
6. **Survival-ledger audits.**  C464 has landed and closes the perfect-code evidence row.  Before
   drafting the closing section, each paper-facing row still needs its bounded literature audit per
   `literature-audit-conventions.md`; QR/design/code terminology remains heavily classical, and the
   Paley-deflation credit list is the starting point.  Apply chirality disambiguation, duality vs
   polarity, vertex-facet-level 11-cell wording, and the exact ternary Golay-parameter boundary at
   first drafting.  C466 and C468 strengthen the sequel pointers but do not enlarge Paper 1.

C410 now closes every spanning q=7 six-point external-line closure, not the broader pointed-memory
problem.  C418 and C419 own the active seven/eight-point balanced-trade and fixed-incidence-moduli
attacks.  The independent C405/C401/C402 and C413--C419 queues may continue in parallel, but none
should delay this plan or be accumulated into the same manuscript.

## Cold-session routing

Read in this order:

1. `notes/handoffs/2026-07-13-clebsch-paper.md` for the live manuscript decision;
2. this report for the current theorem/novelty map;
3. for manuscript drafting, `notes/2026-07-21-clebsch-paper-abstract-outline.md` for the selected
   narrative and section plan, then `notes/2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`
   for copy-ready opening and closing prose;
4. for a high-level generalist cold read or theorem-compression pass,
   `notes/2026-07-21-clebsch-high-level-reader-cold-read.md`;
5. for result intake or disposition review, `notes/2026-07-21-clebsch-weil-roof-results-ledger.md`
   for every recent result without loading the individual battery reports;
6. for theorem work, `notes/2026-07-20-c406-matching-module.md` for the exact theorem and negative
   results;
7. for claim wording, `notes/2026-07-20-c406-priority-audit.md` for classical ownership and access
   gaps;
8. only when comparing against the fallback, `notes/2026-07-19-clebsch-hexagons-are-the-bestagons-spine.md` for the protected exposition
   baseline and candidate replacement architecture;
9. `notes/2026-07-20-c411-double-coset-hecke.md` for the conceptual profile/cubic proof;
10. `notes/2026-07-20-c412-relative-cubic-depth-plane.md` for the selective modular upgrade and its
   non-identification boundary;
11. `notes/2026-07-20-c411-c417-c406-successors.md` only for companion research after C412;
12. `notes/handoffs/2026-07-17-crowns.md` only for live research ordering outside the manuscript
    lane.  The historical conversation report and execution controller are no longer routine
    Paper-1 context.

No cold session should infer a manuscript edit from a completed crowns theorem.  That transfer is
owned by the `clebsch` paper lane and remains an explicit architecture decision.
