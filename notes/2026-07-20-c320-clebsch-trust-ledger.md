# C320 — Clebsch referee-facing trust ledger

**Lane:** `clebsch`

**Status:** active; implementation complete and ready for user-launched independent review

This file is both the cold-read task specification and the required durable result report. Complete
it in place. C320 is not an editorial summary: it is the authoritative claim-by-claim ledger that
determines which Clebsch paper statements may be labelled Lean-formalized, certificate/replay-backed,
conceptual/citation-backed, or mixed.

## Early-start authorization and current boundary

On 2026-07-23 the user explicitly authorized C320 to begin while C507 was underway, with the C505
and C507 results to be admitted when ready.  This overrides the start-order gate but not the
release gate.  Both slices have now delivered final reviewed implementations and are admitted
below.  The replacement-spine manuscript, stable public evidence bundles, complete claim manifest,
tracked aggregate paper audit, and deterministic adequacy appendix have now landed.  C320 remains
live only through the final clean-release output and the mandatory user-launched independent review.

The checked-in `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` is now the replacement-spine
manuscript described by `notes/2026-07-21-clebsch-paper-abstract-outline.md`; the historical
19-page baseline is no longer the release manuscript.  The manifest derives its identities from
the final manuscript itself: 27 theorem-like environments and 30 separately hashed prose/table
claims produce 57 exact claim rows.  No claim inherits a trust route merely because a related
terminal exists.

The repaired C507 implementation `9a388b41` plus its final user-launched review `GO` provide the
exact admission boundary below.  Its lifecycle closure is committed, its live-queue row is absent,
and its handoff records the final boundary.  C320 corrected one stale report-header status line
that still said “queued task brief”; no source, evidence, or review content changed.

## Foundation landed before final slice intake

The initial public verification surface is under
`papers/clebsch-hexagon-code/verification/`:

- `extract_statement_adequacy.py` deterministically extracts every theorem, proposition, lemma,
  and corollary environment, preserving exact TeX, source line, label or content-addressed key,
  and SHA-256 digest.  Against the protected baseline it finds 18 statements, including one
  intentionally unlabelled corollary.
- `verify_trust_manifest.py` defines and fail-closed validates the semantic
  `clebsch-trust-manifest-v1` contract.  It requires a full commit pin and manuscript hash, exact
  coverage of every theorem-like statement, exact occurrence and hashing of separately stated
  prose/table claims, one final route per claim, terminal-by-terminal axiom lists for Lean routes,
  full checker/artifact/coverage/replay/residual-trust fields for computational routes, pinpointed
  inputs and an unconditional remainder for conceptual routes, and explicit subclaim
  decomposition for mixed routes.  Every referenced gate, audit module, validation output,
  verify-all entry point, verify-all output, checker, generator, schema, data file, and certificate
  names either the flattened paper repository or the separately supplied flattened shared Lean
  repository and uses a safe path relative to that root; current bytes must match the recorded
  SHA-256.
- `extract_gate_audits.py` records each import-only gate's exact SHA-256, imports, declared
  `#print axioms` terminals, and whether the audit is embedded in that gate.  It does not mistake
  an import-only module name for an audited terminal surface.
- `verify_release.py` is the single argv-only release runner.  It rejects shell commands, requires
  clean paper and Lean scopes, validates the separately supplied flattened Lean root against its
  pinned commit, validates the manifest first, runs every uniquely named check in its declared
  repository with an explicit bounded timeout, reports only bounded failure tails, and verifies
  that no tracked or untracked paper or Lean path changed during the run.  Ignored build caches are
  outside the Git snapshot; every scholarly output is instead a tracked hash-pinned manifest
  artifact.  Success output omits timings and machine-local paths, making it byte-reproducible for
  a fixed manifest and passing check set.
- `test_verification_tools.py` exercises content-addressed statement extraction, uniqueness of
  manuscript claim keys, the embedded 23-terminal arithmetic-gluing gate surface, direct argv
  acceptance, shell-command rejection, a tracked gate serving as its own embedded audit, and
  rejection of a mismatched artifact hash.  It intentionally does not freeze the protected
  baseline's statement count, because replacement-manuscript integration must be accepted through
  exact new statement hashes rather than a stale cardinality.

The final `trust_manifest.json` is deliberately absent at this foundation stage.  The validator
therefore fails loudly rather than accepting an incomplete or baseline-only ledger as a release
manifest.  After the replacement manuscript and the last two reviewed deltas land, the manifest
must cover both the extracted theorem environments and every load-bearing abstract, table,
caption, and standalone prose claim through verbatim source rows.

Current foundation checks:

```text
python3 -m py_compile verification/extract_statement_adequacy.py \
  verification/verify_trust_manifest.py
python3 verification/extract_statement_adequacy.py
  -> schema clebsch-statement-adequacy-v1, 18 statements, one unlabelled
python3 verification/verify_trust_manifest.py --lean-root <shared-lean-checkout>
  -> fails closed because trust_manifest.json has not yet been admitted
python3 verification/extract_gate_audits.py <thirteen completed gate paths>
  -> 13 gates, 162 embedded audit terminals
python3 verification/verify_release.py --lean-root <shared-lean-checkout>
  -> fails closed because trust_manifest.json has not yet been admitted
python3 -m unittest verification/test_verification_tools.py
  -> 6 tests passed
```

The initial gate-surface pass finds that six of the thirteen admitted completed gates have no
embedded `#print axioms` commands:

```text
ClebschMomentTrade
ClebschConicMatchingQuotient
ClebschHarmonicQuotient
ClebschFactorization
ClebschBalancedSheets
ClebschSchemeFourier
```

This is not yet an axiom-evidence failure: harmonic quotient and factorization already have named
separate audit modules, and task reports record committed harnesses for other early slices.  C320
must resolve each route against the actual tracked module and final verify-all invocation.  It may
not infer an axiom list from a report or treat a bare re-export as an audit.

The first direct binding pass resolves the six cases as follows:

| import gate | durable audit source now present | C320 release action |
|---|---|---|
| `ClebschMomentTrade` | none; the report records a manual reproduction recipe and reported result | add the selected terminals to the final tracked paper audit |
| `ClebschConicMatchingQuotient` | ten `#print axioms` commands at the end of `ClebschConicMatchingQuotient.lean` | bind the manifest directly to that hashed content module |
| `ClebschHarmonicQuotient` | `Gates/ClebschHarmonicQuotientAxiomAudit.lean`, 34 terminals | bind and replay the separate audit gate |
| `ClebschFactorization` | `Gates/ClebschFactorizationAxiomAudit.lean` | bind and replay the separate audit gate |
| `ClebschBalancedSheets` | none; the 52-terminal audit wrapper and output were ephemeral | add every paper-selected balanced-sheet terminal to the final tracked paper audit |
| `ClebschSchemeFourier` | none; the twelve-terminal audit wrapper was transient | add every adopted Fourier terminal to the final tracked paper audit |

The strengthened public manifest validator now rejects a Lean route unless it supplies a tracked,
hashed audit module containing a literal `#print axioms` command for every claimed terminal and a
tracked, hashed validation output with its exact command.  This converts the three ephemeral/report
only cases into concrete C320 work rather than undocumented trust inheritance.

## Adopted release-claim partition before manuscript integration

The copy-ready replacement outline currently supplies four headline theorem blocks with fifteen
separately stated subclaims:

| block | subclaims requiring separate ledger routes |
|---|---:|
| rigidity and Coxeter phase | 4 |
| factorization forgetting and balanced recovery | 3 |
| cubic orientation and compressed depth | 5 |
| reconstruction and arithmetic gluing | 3 |

The Paper-1 survival/forgetting close supplies ten further independently routed rows: unmarked
conic forgetting; moment recovery of the unordered sheets; cubic orientation; decorated-depth
parent recovery; QR/perfect-code shadow; full-support/secant Witt shadow; Hadamard degeneration;
the mod-40 golden law; theta and quantum erasure; and the scoped ambient Fourier/Weil-Weyl shadow.
These 25 planned rows are a lower bound, not the final claim count: retained rigidity, decoding,
gap, low-degree, and small-arc statements from the protected baseline remain separately
accountable, as do load-bearing claims in the eventual abstract, figures, captions, and trust
tables.

## Slice-intake state

| slice | current C320 intake state |
|---|---|
| C420 | complete foundation result available; terminal adequacy still to be audited directly |
| C421 | complete with the `Fin 4` connectivity boundary preserved |
| C422 | final independent-review `GO`; direct terminal audit pending in C320 |
| C423 | final independent-review `GO`; proposed C320 delta available |
| C424 | final independent-review `GO`; H3 scope/fallback boundary remains explicit |
| C425 | final independent-review `GO`; external group/Fourier semantics remain explicit |
| C426 | final independent-review `GO`; proposed C320 delta preserves external Krein/fusion rows |
| C427 | complete by explicit user waiver after repairs; external rank-16/automorphism rows remain |
| C428 | final independent-review `GO` |
| C494 | complete after review repair and explicit user waiver; B3/H3-only scope retained |
| C503 | final independent-review `GO`; proposed C320 delta available |
| C504 | final independent-review `GO`; classical Mathieu/cover names remain cited inputs |
| C505 | complete; repaired Lean `4c01ea83`, provenance ledger `30c1cd6b`, final user-launched review `GO`; admitted below |
| C506 | final independent-review `GO` on implementation commit `51b21674` |
| C507 | complete; repaired commit `9a388b41`, final user-launched review `GO`, queue lifecycle closed; admitted below |

## First-pass headline adequacy map

This is an internal routing map, not the final trust manifest.  “Candidate route” means the
strongest route whose actual theorem type and axiom closure C320 still has to inspect; it is not a
paper label.

| planned subclaim | candidate formal/evidence owner | unresolved adequacy question |
|---|---|---|
| Clebsch deep-hole conic rigidity and `A5` recovery | retained rigidity gates plus exact census | reconcile the two Dye inputs and the unconditional remainder |
| common A3/B3/H3 length and distance law | `Gates.ClebschWeightedAdjoint` plus Coxeter identification input | separate conditional weighted-adjoint algebra from coordinate/Coxeter naming |
| `q=h+1` full-conic extended-GRS phase | retained Coxeter-phase gate and replay | verify exact support/conic and code-equivalence terminals |
| Coxeter-square split-torus/Legendre blocks | `Gates.ClebschArithmeticGluing` | Lean checks literal orders, orbits, and square determinants; classical torus naming remains input |
| conic restriction forgets the matching product | `Gates.ClebschConicMatchingQuotient` | retain the `Fin 4` switch base/arbitrary reversibility boundary |
| quotient ranks `3,6,10` | harmonic quotient plus factorization leaves | distinguish symbolic harmonic dimensions from finite factorization-image ranks |
| unique balanced B3/H3 complementary halves | `Gates.ClebschBalancedSheets` | verify whether H3 uniqueness is theorem-native or still uses the declared finite fallback |
| even signed moments and degree-one cancellation | moment-trade/factorization/depth gates | split general symbolic parity from finite profile barycentre |
| first surviving cubic and outer orientation | factorization/balanced-sheet gates | “first” is only for the stated signed tensor/functional family |
| two `1,4,6` triples and six depth profiles | `Gates.ClebschDoubleCosetDepth` | abstract `A4/PGL/A5` names remain external to the literal orbit tables |
| rank-two depth map, four-dimensional kernel, label separation | `Gates.ClebschDoubleCosetDepth` | terminals are explicit; paper must not identify the profile plane with the sheet set |
| projective-cover explanation and distinct relative-cubic Tate plane | C412 conceptual proof and selected formal descendants | determine which part has an adequate Lean terminal and route the remainder conceptually |
| singleton profiles recover pair/decorated parent | `Gates.ClebschDoubleCosetDepth` and replacement-spine gate | separate unordered-pair recovery from the additional decoration hypothesis |
| A3 fused/B3 split/H3 golden split row | `Gates.ClebschArithmeticGluing` | classical spin/projective-matching interpretation remains cited input |
| H3 intersection, generation, `S4/A4` hinge, and outer transporter | arithmetic-gluing gate plus exact finite certificate | decompose literal subgroup/action checks from classical group and rational-spinor names |

The depth gate already exposes separate terminals for range rank, kernel rank, profile injectivity,
the cubic-first pushforward, unordered singleton recovery, and decorated-parent recovery.  Those
must remain separate claim rows even if the manuscript groups them under one theorem letter.
Likewise the arithmetic-gluing gate exposes separate no-root/root, fused/split, Coxeter-orbit,
outer-transporter, and bounded trichotomy terminals; the final ledger may not collapse them into a
single “rank-three formalized” label.

## Admitted closing-slice evidence blocks

The following three reviewed slices are sufficiently stable for C320 to admit their exact evidence
blocks now.  Admission means their gate identity and boundary are frozen for later claim rows; it
does not mean that the replacement manuscript wording has passed adequacy comparison.

| slice | reviewed implementation | gate SHA-256 / audited terminals | admitted route boundary |
|---|---|---|---|
| C503 arithmetic gluing | final `GO` on `983ba783` | `7519ec19b26e18869593cf24a883f8927ed887f35edb3e548dcc69e157cceaaa` / 23 | full-trust literal finite reductions, roots, matching actions, Coxeter orbits, bounded subgroup data, and transporters; external exact certificate for H3 stabilizer/coset/660-word semantics; cited classical group, spinor, and number-field names; no all-prime or descent claim |
| C504 Witt--Hadamard | repaired gate pinned at `42683dff12835cef50094f2495a5a9103bb30d02` with final `GO` | `192570efea371c4f33fe48008f273d98588de512c34628945b4ad2e6d207d72e` / 25 | native-checked finite QR/code/design/Hadamard/closure/outer-hinge clauses with each declaration-local native axiom disclosed; `M11`, `M12`, `2.M12`, and `PSL_2(11)` remain cited names |
| C506 survival boundaries | final `GO` on `51b21674` | `a4b992e61232a29e3c7eb1a56d0f028dcbca4e2fccb940c9d127d258778508b8` / 14 | standard-axiom finite hit/minor/inverse/intersection/residue-partition checks; semantic coordinate, character/Weil, five-space, golden-splitting, and transporter identifications remain certificate/cited inputs; universal impossibility, reciprocity, density, and parent claims excluded |

C504's proposed single “F11 row” is rejected as a final ledger shape: its own report requires
separate entries for QR incidence, code parameters, Steiner supports, full-support points, secant
exhaustion, Hadamard identity, parent intersection/join, carrier inverse, closure/normalizer,
inner-square, and non-inner row/column clauses.  Those clauses have different statement-adequacy
targets even though they share one gate and native trust route.

C506 likewise splits at least into four paper rows: the permitted lower-moment/integral-weight
negative, the cross-sheet small-module obstruction, the frozen five-space intersection negative,
and the conditional mod-40 partition.  The first three are exact finite-domain negatives, not
universal nonexistence theorems; the fourth does not formalize reciprocity, prime densities, or the
golden semantic identification.

### C505 torsor-Rosetta admission

C505 is admitted at repaired Lean commit `4c01ea83`, provenance-ledger commit `30c1cd6b`, and gate
SHA-256
`568258c821016bce37ac80583aaef9e1ce586d4d8837475cdd6e6556a7bf7068`.  The current gate bytes
equal the reviewed `4c01ea83` bytes.  Its eleven explicit probes split as follows:

- two generic free-torsor terminals use exactly `propext` and `Quot.sound`;
- seven local finite/certificate-interface terminals add only `Classical.choice`; and
- the forced-outer terminal and aggregate close additionally expose the two declaration-local
  C504 native-decision axioms for the finite assignment graph and exhaustive no-inner witness.

The final ledger must keep five rows separate:

1. free-`C2` obstruction and exact one-bit sufficiency;
2. fixed-child quotient and `T_11` bridge;
3. one sign character/common kernel with three readouts;
4. rank-three split/inert models plus q=11 outer/Hadamard readouts; and
5. the characteristic-zero quadratic field/conjugation/reduction interface.

Lean proves the generic deductions, explicit finite root subtypes/swaps, the 22-parent quotient
model, and consequences of four certificate structures.  The concrete affine/Čech, selector,
arithmetic-orientation, fixed-child, design/Fourier, torsor/trichotomy, and rational-descent
semantics come from seven exact JSON/hash/replay bundles.  Classical group names, the inert
quadratic-algebra interpretation, and Hilbert-90/integral-reduction semantics remain cited inputs.
Absolute cohomology, an all-prime classification, an integral cubic, genuine-Weil claims, and the
forbidden embedding claim remain excluded.

C505's seven adopted semantic bundles currently live under dated internal `notes/` paths.  Merely
hash-pinning those paths in the public manifest would violate the one-way referee-artifact rule.
C320 therefore chooses the migration route: before the manifest is cut, the adopted JSON,
generators/checkers, replays, and checksum manifests must move as exact bytes into a stable
workflow-free verification bundle, with a semantic README and unchanged hashes where filenames or
embedded paths do not require regeneration.  The already stable
`lean/verification/clebsch_arithmetic_gluing/` bundle remains in place and is referenced directly.

### C507 mixed-passage admission

C507 is admitted at repaired commit `9a388b41` and gate SHA-256
`0297f429b1488dbcd2d1516569052443a23d5ca48c2fe24e8963f265be62778d`; the current gate bytes
equal the reviewed commit bytes.  Its twenty-two probes use only `propext`,
`Classical.choice`, and `Quot.sound`, or a subset; the two matching-signature terminals use no
axioms.  No native-decision or project-local axiom enters this block.

The final ledger must separate at least five routes:

1. genus-three/genus-five finite theta-quadratic value histograms;
2. frozen q=7/q=11 same-sheet Lagrangian signatures and exact sheet erasure;
3. rank-eight, rank-sixteen, and signed integer Fourier square/trace/weighted-adjoint identities;
4. monomial parity-check transport, signed-transpose identity, and complete fixed-party
   kernel--image equivalence; and
5. the regular left/right `alternatingGroup (Fin 5)` bitorsor laws.

The Lean route recomputes the finite histograms and incidence summaries, all displayed integer
matrices, inverse/intertwining/decomposition certificates, and the abstract sixty-element bitorsor.
Projective reconstruction of the matching tables and 60 geometric maps, divisor-theoretic theta
semantics and superspeciality, ambient Schrodinger/Weil normalization, common-ambient restriction
and eigenspace multiplicities, complex state normalization, arbitrary-LU classification, and
geometric parent canonicity remain exact certificate or cited-input boundaries.

The C471 mod-three Hadamard degeneration sentence was not adopted in Paper 1 and is not exported by
this gate.  It remains Paper-2 certificate evidence unless the manuscript owner makes a new
adoption decision, in which case C320 must open a new row and validation route rather than inherit
it from C507.

C507's four adopted semantic checkers and checksum manifests also currently live under dated
internal `notes/` paths.  They join C505's bundles in the required workflow-free evidence migration
before the public trust manifest is cut.  The migrated bundle must preserve the independent routes:
theta quotient-space ranks versus alternating-cycle components, reconstructed Fourier matrices,
complete parity-check/codeword support transport, and character-sum support versus exhaustive
local-Clifford search.

Two earlier reviewed closing inputs are also admitted:

| slice | reviewed implementation | gate SHA-256 / audited terminals | admitted route boundary |
|---|---|---|---|
| C428 weighted adjoint | final independent-review `GO`; repaired source `a00f9062f3d807e2da563fc431b5ab5cd70f69c8` | `c39228cec02cce07a304bec3d8f39ee9f533dad3f9628ba16716b188f886c6a1` / 22 | seven conditional symbolic depth/enumerator implications, generic evaluation injectivity, table completeness, and displayed finite specializations are standard-axiom Lean; actual enumerators/minima come only from the explicit finite evaluation terminals; coordinate-to-Coxeter and geometric model identifications remain inputs |
| C494 B3/H3 information lattice | code commit `9e7eeec7`; final prose repair accepted by explicit user waiver | `f6423e1200dd70608e52c0c6c8d955784c32231cf4deafd8bffcf882c01e5d7d` / 31 | standard-axiom finite matching/action/profile checks and exact strict rational-function towers `1 < 2 < 6 < 14/22`; the displayed shared-edge coordinates are not identified with C425's depth coordinates; no general double-coset theorem, arbitrary field/`q`, or canonical maximal-subgroup claim |

For both slices the current gate bytes equal the bytes at the recorded reviewed code commit.  C428
cannot by itself carry the paper's whole common Coxeter distance law: its symbolic theorems are
conditional, and its finite specializations have the exact displayed fields and tables.  C494
cannot upgrade C425's rank-two depth plane to the full information lattice by name alone; the
coordinate bridge remains a separately routed semantic input unless the manuscript states only the
intrinsic finite profile theorem C494 actually checks.

## Admitted replacement-spine core

The eight F1--F8 gates are now admitted at their bounded theorem surfaces.  The hashes below are
the current import-gate bytes; final pinning still requires the release aggregate and manuscript
adequacy pass.

| slice / gate hash | audited surface | admitted boundary |
|---|---:|---|
| C420 MomentTrade / `9fcf52697e5db82e044306da48f179c32b44d36e19d57cfd14eb650bb0771a77` | 14 selected symbolic terminals; final tracked paper audit required | affine covariance, antipodal even cancellation, barycentre cancellation, exact-strength-two witness, and functional shadows only; no concrete Clebsch sheet hypotheses |
| C421 ConicMatchingQuotient / `bf378789f1b2f3fd5b6e2a0731a2f153e3b819bffba55c85aafeb946ea6c4d03` | 10 inline-audited terminals | exact switch identity/divisibility, list-permutation pullback equality, generic augmentation kernel, pointwise boundary identities, arbitrary-size switch reversibility, and `Fin 4` connectivity; no general matching graph connectivity, switch span, geometric restriction kernel, or word-weight theorem |
| C422 HarmonicQuotient / `cc4f8617ebe4e5fa46e66ca142a6c3adeec021679f6c96aab2f391c93f856e51` | 34-terminal tracked audit gate | symbolic degree-`1/2/4` harmonic/radial decompositions, dimensions, exact characteristic obstructions, prime-field instances, and the F2 switch-radial bridge; no unrestricted-degree decomposition |
| C423 Factorization / `3b2cc11aeae1cfa9b7cc8b8d05d1a2c292337266d9c8a4ac0d45d46bbcb36d02` | 16-terminal tracked audit gate | checked A3/B3/H3 image ranks `3/6/10`, lower signed cancellations, and named B3/H3 cubic witnesses; literal coordinate binding remains tied to its generated evidence bundle |
| C424 BalancedSheets / `9ea2ba12de452fb6eef09f34d4c204c6e3bc9573f4b317108dea7fe3b714d5c8` | 52 reported terminals; final tracked paper audit required | abstract radical--Hadamard recovery, concrete B3/H3 balanced-sheet uniqueness, affine signed actions, nonzero cubics, relative invariance, exact stabilizers, and plane syzygies; classical `PSL/PGL` identification remains input |
| C425 DoubleCosetDepth / `a1113d23bf3ba65b74f4e8528960870da54e38618aa53029c7ceb31c94ee36d4` | 34 embedded probes | literal orbit/profile tables, `1,4,6 / 1,4,6`, involution, rank two/four-kernel, label separation, cubic-first pushforward, singleton pair recovery, and decorated-parent recovery; named double-coset/group and scheme-Fourier semantics remain external |
| C426 SchemeFourier / `6a17f12f095aade20e5887d0c951da273febbcc9f23f8ea4ea025f8189cbebfa` | 12 reported terminals; final tracked paper audit required | abstract character/scalar-line identities, frozen `P=Q`, product/shape/valency rows, and all 126 additive-nonclosure witnesses; association-scheme rank, geometric Fourier self-duality, intersection/Krein equality, and the 877-fusion census remain exact external certificate/replay unless separately upgraded |
| C427 ReplacementSpine / `17edb28f4b4c77929973eada93eacb92ea03bb17b8c2b7604fcfa567d0134e3a` | 13 embedded probes | committed intrinsic support-chirality/replacement-spine endpoint at its exact types; rank-16 and automorphism semantics remain external, and completion used the recorded user waiver after prose repairs |

All admitted C420--C428 full-trust terminals use only the recorded standard Lean axioms or a
subset; none of these rows imports C504's native-decision axioms.  This table deliberately keeps
the C423 rank statements, C424 sheet-recovery statements, C425 profile statements, and C426
Fourier-table statements separate: their composition is the paper mechanism, not a single theorem
whose import upgrades every semantic bridge.

## C321 trigger audit: current Singular dependency

The protected manuscript has exactly one load-bearing Singular-dependent statement.  The
sharpness remark after low-degree rigidity says that class `C02` has an 18-point uncovered locus
equal to the rational points of a **smooth absolutely irreducible plane quartic of genus three**.
The evidence decomposes as follows:

- `check_low_degree_loci.py` independently regenerates the class and quartic, checks the exact
  rational zero locus, and exhausts all projective linear and quadratic possible divisors.  Since
  a reducible quartic has a factor of degree one or two, this is an exact non-CAS certificate of
  irreducibility over `F_11`.
- `check_low_degree_loci.sing` computes the Jacobian ideal and checks its zero-dimensional
  colength `27`, which is the current sole executable support for geometric smoothness.
- genus three then follows conceptually from the standard genus formula for a smooth plane
  quartic; the manuscript currently attributes both smoothness and genus to the Singular
  companion.

Therefore C321 has mandatory scope **if the smooth/genus-three sharpness sentence survives the
replacement manuscript**: replace the Jacobian/Groebner calculation with an independently
specified exact certificate and checker, then cite the standard genus formula separately.  C321
has no mandatory Paper-1 work for irreducibility or the 18-point equality, because the Python
replay already checks those without Singular.  Removing or weakening the smooth/genus clause before
release is the only route that makes this C321 item non-load-bearing; merely retaining Singular as
an “independent check” does not satisfy C320's final trust route.

## Initial reconciliation judgments

1. **Begin early without weakening the release gate.**  The alternative was to leave C320 wholly
   idle.  The user authorized early work, so source extraction, schema enforcement, baseline versus
   replacement separation, and reviewed-slice intake can proceed.  Final claim coverage, pinning,
   build evidence, and review cannot.
2. **Use manuscript-derived adequacy keys.**  Labelled statements use their TeX labels; an
   unlabelled theorem-like statement uses a content-addressed key.  Line numbers are locators, not
   identity.  This avoids a mutable manual numbering layer and makes wording changes invalidate
   stale ledger rows.
3. **Treat prose/table claims as first-class rows.**  Restricting the manifest to theorem
   environments would miss the abstract, figure arrows, survival table, and verification captions.
   Each such row must store exact TeX and its digest and must occur exactly once.
4. **Do not create an aggregate Lean gate during concurrent C507 work.**  The final gate and
   verify-all command must import the landed, reviewed C507 surface.  Creating a partial aggregate
   now would either omit a paper-adopted slice or touch an active foreign closure.  The reopening
   condition is a clean, committed C507 handoff with its reviewed terminal list.
5. **Make incompleteness fail closed.**  No placeholder trust route is allowed in the public
   manifest.  Until every row has its final evidence, the manifest is absent and the validator
   reports failure.  Internal intake state remains in this report only.
6. **Design for two flattened published repositories.**  The user states that the monorepo will
   not be published: each paper and the shared Lean development will be extracted to separate
   repositories with flattened roots.  The manifest therefore tags every artifact and check with
   repository identity `paper` or `lean`; paper-local paths start at the extracted paper root,
   Lean paths start at the extracted shared-Lean root, and the verifier accepts that root through
   `--lean-root`.  No public command, manifest row, or evidence script may depend on
   `papers/clebsch-hexagon-code`, the monorepo `lean/` prefix, or `notes/`.

## Final implementation and reconciliation record

The release manuscript now follows the selected C406+C411 replacement spine and closes with the
C480/C486/C487 torsor Rosetta result.  Its five headline blocks are A--D plus the closing theorem
E.  The survival ledger distinguishes retained finite shadows from proved erasures, C412 is
included only at its exact projective-cover/Tate-plane boundary, C471's optional degeneration
shadow is omitted, and C479 remains absent.  The historical smooth/genus-three C02 sentence was
removed, so the Singular calculation is no longer load-bearing and C321 is not triggered.

The proof hierarchy is explicit.  Headline proofs must reveal a mechanism; exact computations may
remain second-tier, load-bearing certificates for frozen orbit, rank, and normalizer hypotheses.
Three computation-facing results earned proof promotion: the split--inert frame lemma, the
conditional mod-40 reciprocity proposition, and the determinant-sign transport/no-section lemma.
The last was strengthened to the actual Rosetta mechanism: once a two-point row is verified to
carry the determinant character, equivariant transport forces its identification with the common
torsor after one marking.  The conceptual rigidity replacement, a representation-free
Witt/secant/Mathieu exhaustion, uniform theta/quantum statements, and a general information-lattice
functor did not meet that bar and are banked with reopening conditions in the discovery track.

Public evidence is now self-contained under the paper root:

- `verification/evidence/torsor_dictionary/` contains the adopted generators, exact artifacts,
  independent replays, semantic README, and a fail-closed bundle verifier;
- `verification/evidence/passage_interfaces/` does the same for the theta, Fourier, and
  fixed-party passage tests;
- `verification/statement_adequacy.json` records all 27 exact theorem-like environments;
- `verification/trust_manifest.json` contains 57 claim rows with one explicit route or mixed
  decomposition per row, the pinned shared-Lean commit
  `223584997c5691a60c066d865c0a0e449a38cd21`, exact gate/audit hashes, terminal-local axiom
  lists, cited inputs, residual trust, and the complete release check list; and
- `verification/verify_release.py` validates both flattened repositories, runs the paper checks,
  evidence bundles, pinned Mathlib-cache setup, and the exact aggregate Lean target, and rejects
  any source-tree mutation.

The aggregate Lean gate and durable axiom audit landed in commit
`223584997c5691a60c066d865c0a0e449a38cd21`.  Paper evidence migration landed in commits
`be274713` and `c39d2846`; the replacement manuscript and first manifest landed through
`70c39f78`, and proof promotion/discovery banking through `f67f5f51`.  Planning reconciliation
landed in `3ee4476f`; the style-guide, proof-mechanism, and dependency-aware release revision landed
in `d98b858f`.  The tracked deterministic output and its manifest hash record the final release
state.

Reconciliation judgments with paper effects:

1. The torsor is the determinant-sign class `T_q` at each split working prime, not an asserted
   cross-characteristic scheme.  The characteristic-zero resolvent specializes specifically to
   `T_11`; the `M_12` row is an acting face, not an additional two-point carrier.
2. `A_3` is the fused connected étale control.  The two geometric roots form one Frobenius orbit;
   it has no orientation bit over `F_5`.
3. The mod-40 result is conditional on the frozen golden-marker hypotheses.  Reciprocity and CRT
   prove the residue partition, but the manuscript makes no all-prime density or common-carrier
   claim.
4. The profile plane, sheet torsor, relative-cubic Tate plane, and fixed-child quotient are not
   silently identified.  Every positive comparison and every proved non-identification is stated
   at its actual boundary.
5. The Hofstadter citation and record-player metaphor are mathematical exposition only.  Any
   physical record is post-acceptance: representative selection and certificate checking must be
   disclosed to the editor, and the printed ignition line/hash is cut only then.
6. C471 is omitted because no adopted public replay supports even its optional shadow sentence.
   Reopen only after an adequate public artifact and a fresh manuscript-value judgment.
7. The only external release dependency not manufactured by C320 is the immutable C182 archive/DOI.
   It does not weaken the local trust run, but publication packaging cannot claim an immutable DOI
   until C182 supplies it.

### Final validation

The manuscript was rebuilt with Tectonic after the style-guide pass.  The build produced the PDF
with no TeX error; the only warnings are underfull boxes in the narrow survival-ledger table.  A
release-tree text audit found no operational reference to the post-acceptance record plan, ignition
text, hidden hash, editor procedure, or representative selection.  The only Hofstadter occurrences
in the released tree are the intentional, open explanatory paragraph and its bibliography entry.

The clean release runner used the disk-backed detached Lean checkout at the pinned commit above.
Its first complete run returned `status: passed` for all 17 checks: six verification-tool tests,
statement extraction, eleven retained finite paper checkers, both public evidence bundles, pinned
Mathlib-cache setup, and the exact aggregate Lean target.  The complete deterministic JSON is
tracked at `verification/verify-release-output.json` and hash-bound by the trust manifest.

### Mystery ledger after the `ej`+`tt` closeout

- **Settled — transport-lemma quantifier.**  The first strengthened wording said only that a
  two-point action factors through `chi`; that condition also admits the trivial action.  The
  theorem now requires the induced `C2` action to be nontrivial, exactly the hypothesis used to
  obtain a free transitive torsor and the unique marked equivariant bijection.
- **Settled — clean-build failure.**  The first detached Lean checkout was mistakenly placed on
  the host's RAM-backed `/tmp`; project artifacts then exhausted that temporary filesystem during
  `Q11Residual`.  Rebuilding the same pinned commit in the required disk-backed cache completed all
  8,734 jobs.  No proof or source change was needed.
- **Settled — released-file leakage.**  A case-insensitive scan of the released paper tree found
  only the intentional open Hofstadter paragraph and bibliography entry.  No record-production
  instruction, ignition line, representative-selection rule, editor procedure, or hidden
  commitment is present.
- **Open, deliberately sequel-owned — arithmetic origin of the sign gluing.**  Paper I proves that
  every available two-point carrier has the same determinant-sign action and therefore the same
  torsor.  It does not construct a uniform arithmetic or metaplectic object producing that gluing
  across characteristics.  The conclusion states this single scoped question; a new theorem
  requires such a construction, not another table.
- **External packaging item — immutable archive.**  C182 still owns the DOI/archive.  This is not a
  mathematical or trust-manifest gap, but release prose must not claim the DOI before it exists.

No other genuine C320 correctness mystery remains before independent review.

## Required outcome

Create the Clebsch per-paper trust manifest and one documented verify-all entry point after every
paper-adopted formalization/evidence task has delivered its reviewed ledger delta. The manifest has
one row per published claim and separately stated subclaim. Each row records:

- the exact paper statement and its statement-adequacy correspondence;
- exactly one final trust route: full-trust Lean, exact replay/certificate, conceptual proof with
  named classical inputs, or an explicitly decomposed combination;
- fully qualified Lean terminals, import-only gates, pinned commit, exact validation, and terminal
  `#print axioms` results;
- checker/soundness theorem, generator, schema, data, hashes, finite domain/coverage, independent
  replay, and residual trusted boundary for every computational clause;
- cited/axiomatized inputs, including the two Dye assumptions, and what remains unconditional
  without each;
- conditional, optional, stopped, omitted, or external clauses that must not inherit a stronger
  label; and
- the exact verify-all command/entry point and durable output establishing the row's route.

The ledger must reconcile the actual final gates rather than trust task verdicts or module names.
It must explicitly preserve known mixed boundaries, including C222 compactness stops, C421's bounded
`Fin 4` connectivity, C424's possible H3 fallback, C426's external-by-default intersection/Krein and
fusion clauses, C427's external rank-16/automorphism clauses, C494's bounded B3/H3-only scope,
C503's named-group/spinor interfaces, C504's classical Mathieu/cover naming boundary, C505's
reduction-only characteristic-zero identification and excluded absolute-`H^1`/integral-cubic
claims, C506's exact searched domains, C507's external superspecial/Weil/LU/Golay semantics, and
any later review disposition. C320 starts only after C428, C494, and C503--C507 have supplied final
reviewed ledger deltas, or after the manuscript has explicitly removed the corresponding claims.

## Referee-facing standards and guarded failure modes

- A paper claim is Lean-formalized only if its adequate terminal statement is in the pinned gate,
  current validation is green, and its axiom closure satisfies the full trust policy.
- A conditional theorem does not prove its premise. A checker-backed theorem does not establish
  coverage unless its soundness/coverage bridge does. An aggregate import does not upgrade an
  imported external clause.
- Read theorem types and load-bearing definitions to detect vacuity, weakened quantifiers, hidden
  hypotheses, empty domains, conclusions frozen into data/definitions, and strength words exceeding
  the formal type.
- Hashes establish identity, not correctness or current regeneration. A second CAS run on the same
  specification is not independent validation of that specification.
- The referee-facing manifest and verification artifacts use semantic mathematical names and contain
  no task IDs, agents, sessions, private notes, mutable local paths, workflow chronology, or novelty
  claims. This internal report may cite task records but must point forward to exact public artifacts.
- Include a deterministic extraction of the headline theorem statements and load-bearing definitions
  for the paper's verbatim adequacy appendix.

## Required judgment-call record

Record every reconciliation choice: competing task claims, adequacy mismatch, route downgrade or
upgrade, conditional decomposition, omitted claim, accepted classical input, verify-all scope, and
packaging exclusion. For each give alternatives, evidence, effect on paper wording/trust, rejected
routes, and reopening condition. Never resolve conflict by choosing the strongest label or by
leaving “if feasible” in the final ledger.

## Required closing review and archival checklist

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


Keep C320 live. After the ledger, manifest, adequacy extraction, and verify-all entry point are
complete, explicitly request an independent referee-style review that samples the paper-to-ledger,
ledger-to-terminal, gate-to-import, certificate-to-checker, and command-to-artifact links. Any finding
or `NO-GO` blocks completion and archival. Fix every issue, rerun affected checks, update this report,
and request post-fix review. Only a recorded final `GO` permits C320 to be archived.

- [x] Inventory every published Clebsch claim and separately stated subclaim; account for each once.
- [x] Assign one exact final route per row and prohibit trust inheritance across combined claims.
- [x] Verify adequacy against actual theorem types/definitions, not names, reports, or intended prose.
- [x] Verify every Lean terminal is imported by the pinned gate and record current exact-target and
  axiom-audit evidence.
- [x] Verify every computational row's checker semantics, exhaustive coverage, artifacts, hashes,
  independent replay, and residual trust; distinguish search evidence from proof.
- [x] State every named classical/axiomatic input and the unconditional remainder without it.
- [x] Reconcile all task judgment logs, review findings, fallbacks, exclusions, and post-fix changes.
- [x] Provide one clean-source verify-all entry point that fails loudly on missing/stale/mismatched
  components and leaves the worktree unchanged.
- [x] Produce the verbatim adequacy-appendix extraction and compare it to final manuscript claims.
- [x] Audit the referee-facing manifest/artifacts for self-containment, stable citations, one-way
  references, semantic naming, and absence of internal workflow or unsupported novelty language.
- [ ] Record independent review, every finding/fix, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive C320 with this completed report and the manifest/entry point.
