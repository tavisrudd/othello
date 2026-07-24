# C320 — Clebsch referee-facing trust ledger

**Lane:** `clebsch`

**Status:** repaired after the user-launched independent `NO-GO`; awaiting
the separately user-launched post-fix review required before final `GO`

This file is both the cold-read task specification and the required durable result report. Complete
it in place. C320 is not an editorial summary: it is the authoritative claim-by-claim ledger that
determines which Clebsch paper statements may be labelled Lean-formalized, certificate/replay-backed,
conceptual/citation-backed, or mixed.

## Authoritative current scope — Paper I only

C576 superseded the former mega-paper release path. The active manuscript is
`papers/clebsch-rigidity/clebsch_rigidity.tex`, a 19-page focused rigidity
candidate. C320 must construct and review a new Paper I surface from exactly
the nineteen C575 rows `2, 11--26, 29, 58`.

Required inputs:

- `notes/2026-07-24-c575-clebsch-split-disposition.md`;
- `notes/2026-07-24-c575-clebsch-trust-disposition.csv`;
- `notes/2026-07-24-c576-clebsch-rigidity-candidate.md`;
- the Paper I manuscript and its printed nineteen-row claim map.

C320 must generate a Paper I-specific statement extraction, manifest,
aggregate Lean gate, axiom audit, release runner, toolchain/hash pins, and
clean replay. It may reuse an existing proof, checker, or certificate only
after verifying that it establishes the adopted Paper I claim. It must not
filter the fallback manifest and call the result certified, overwrite the
fallback evidence surface, or import any Paper II/III claim.

The broad manuscript in `papers/clebsch-hexagon-code/`, its previous
58-row manifest and earlier 61-row ledger, 29-statement extraction,
aggregate gate, deterministic
18-check replay, independent `NO-GO`, and subsequent repairs are preserved
fallback evidence. They are not the active C320 acceptance state. The old
instruction to launch a post-fix reviewer for that manuscript is retired.

C321 is expected not to trigger because Paper I retains no load-bearing
Singular claim; close that condition only after checking the final nineteen
rows. The final Paper I surface still requires the user-launched independent
review and post-fix `GO` specified in the closing protocol below.

## Paper I implementation — ready for independent review

**Date:** 2026-07-24

**Pre-review verdict:** `READY FOR INDEPENDENT REVIEW`, not final `GO`.

The focused Paper I surface was built from the manuscript rather than by
filtering the fallback manifest. It is committed in
`bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`,
`3d1eac40`, `573e0ef8`, and post-review repair `3ed43a0d`. The first commit
is the exact pinned formal source commit; the later commits repin, harden,
and repair the Paper I release surface.

### Frozen artifacts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-rigidity/clebsch_rigidity.tex` | 67,973 | `17c6deff3ef29f03d9aeb98fd700cb4a1ef343f0f3f3fd5c19741decd5925c9a` |
| `papers/clebsch-rigidity/clebsch_rigidity.pdf` | 175,664 | `3a58346d083d5fe40df883cc8fc8045ba3a444eb74b076b4f902da2dbcee6209` |
| `papers/clebsch-rigidity/verification/statement_identity.json` | 15,451 | `aa586b5864b3b0a107d87b4307398e35e2cf4b09ceba98392964ebe4dfff61b2` |
| `papers/clebsch-rigidity/verification/trust_manifest.json` | 60,055 | `a885307fc0295e0226259c3990a3e0a79bfeb1d5020814fe81c7a48cca1ffb87` |
| `papers/clebsch-rigidity/verification/checker_outputs.json` | 1,716 | `d9595a11734de303b21b3a214419e2c76668fa8b97353e44c914ef1077bc0b56` |
| `papers/clebsch-rigidity/verification/verify-release-output.json` | 1,768 | `6b59e85768f5cc0b65126dbd0a0f3899d948a5d04dfdfef819283c331024609a` |
| `papers/clebsch-rigidity/verification/verify_release.py` | 11,136 | `94e514d3cc7de42a99280ff779e6a22cd1b93a9bd457b16515f5cf1b2ea65cca` |
| `lean/RelativeConicArcs/Gates/ClebschRigidityTrust.lean` | 3,436 | `dce51b42bfb384950bbffa756a87c3aabccfda03502d19545988f52aca32cb69` |
| `lean/verification/clebsch_rigidity_trust/axiom-audit.txt` | 3,365 | `ef031beeb322b7bd217651aec0b1822b231a01991c1652e21e048bc9f5305767` |

The statement identity contains exactly rows `2, 11--26, 29, 58`: one
introductory headline, seventeen theorem-like environments, and the complete
census sentence. Every row carries verbatim TeX, a source line, and a digest.
The manifest assigns four rows to a purely conceptual/cited route, three to a
pure exact-replay route, and twelve to explicit mixed decompositions.

### Formal trust boundary

The Paper I gate imports only the modules used for the explicit `q=11`
action, code and decoder, the Dye rigidity seam, chord moments, the
Sylvester obstruction, and the small-arc bridge. Its 24 terminals have
exactly five axiom names in the tracked audit:

- `propext`, `Classical.choice`, and `Quot.sound`;
- `RelativeConicArcs.ClebschDye.dye1991_brianchon_bound`; and
- `RelativeConicArcs.ClebschDye.dye1991_equality_classification`.

Only the last two are external mathematical inputs. The source now identifies
them with R. H. Dye, *Hexagons, conics, \(A_5\) and
\(\mathrm{PSL}_2(K)\)*, Theorems 1 and 3, pages 275--278,
doi:10.1112/jlms/s2-44.2.270. No native execution, `sorry`, Singular result,
Paper II terminal, or Paper III terminal enters the gate.

The first fresh build exposed a stale `linarith` normalization failure in
`ClebschChordDefect.clebsch_uncovered_formula`. The repair replaces that
tactic call by an explicit equality followed by `ring`; the theorem type is
unchanged. The exact target then built, the downstream Dye consequence built,
and the new aggregate target passed its trace-only gate.

### Executable evidence and clean replay

The ten Paper I-owned exact checkers and the pinned Nix environment now live
under `papers/clebsch-rigidity/`. Their finite domains and residual trust are
recorded per claim. The low-degree checker deliberately shares the global
checker's canonical class generator; the manifest records that this is a
shared-key consistency check rather than a second independent class
enumeration.

`checker_outputs.json` is the compact certificate of each checker's canonical
stdout SHA-256, byte count, and line count. Its first regeneration exposed a
noncanonical wall-time line in `check_global_conic_gap.py`; removing that line
made two independent pinned-environment runs byte-identical at
`fdd0b0f389110860ab535d0228d4bac1c9ca780995cfe7efaab829d38e219775`.
The other nine checker outputs were already stable.

From `papers/clebsch-rigidity/`, the exact release command is:

```text
nix develop --command python3 verification/verify_release.py \
  --lean-root ../../lean
```

The committed clean replay passed in 3 minutes 39 seconds. It ran fifteen
checks: verification-tool tests, statement identity, an isolated warning-free
19-page manuscript build, manifest regeneration, all ten exact replays, and
the Paper I Lean gate. It matched the tracked deterministic output and left
every Paper I scholarly path unchanged. The runner verifies the exact formal
source pathset against pinned commit
`bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`, so unrelated dirty Lean paths
cannot either block the replay or enter its trust boundary.

One initial unwrapped Nix provisioning command exceeded the command-output
budget and was aborted. Its replacement ran through `run-quiet` and passed;
no claim or recorded artifact depends on the aborted invocation.

### Reconciliation judgments and repairs

1. **Release-local evidence.** The ten selected checkers were copied
   byte-for-byte from the fallback evidence root before Paper I-specific
   audit. Only stale workflow prose, the `q=19` theorem-number message, and
   the noncanonical runtime line were changed. Their current hashes, imports,
   and outputs are Paper I-local.
2. **Narrow terminal admission.** Chord identity, Clebsch-family formula,
   field-order boundary, and geometric defect bridge use separate terminal
   groups. A row does not inherit unrelated terminals merely because they
   occur in one source module.
3. **Exact classical seam.** The rigidity rows are kernel checked relative
   to the two named Dye axioms; the \(A_5\) and geometric naming clauses remain
   cited inputs rather than upgraded Lean claims.
4. **Replay independence.** Decoder, support, automorphism, global, local,
   and low-degree imports are hash-pinned transitively. Shared implementation
   is disclosed instead of being called independent.
5. **Source cleanliness.** The manuscript's stale internal lane comment was
   removed. The public verification artifacts contain no task IDs, agents,
   sessions, private paths, or later-paper evidence.
6. **Formal identity.** The old shared commit `43c403b...` cannot identify a
   gate created later. Paper I therefore pins the exact new formal source
   commit `bf4fb39a...`.

The broad fallback surface remains byte-for-byte unchanged:

- statement identity:
  `f2be08486f4233ead54e744b7d51d5fcf2e52088df2ef784f8fe84e56404f4ee`;
- trust manifest:
  `f7520505f6703a349a0ed54c6ba298112ccba0a3a4d984f83f4dc365ee2d8324`;
- release output:
  `bc8b58f30bb63ecae39ad42f898899fa39047f95180ab2ff419073c95da5db90`;
- fallback aggregate gate:
  `839b45842f6cd88259e5f3fda67076240d18638aa7e76d6e79011a9a3b685bcb`.

C321 is closed as not triggered. Paper I has no load-bearing Singular claim,
the release flake contains no Singular package, and no admitted command or
manifest row invokes Singular.

### Pre-review `ej` + `tt` pass

The cheap upgrades were to make checker stdout part of the verified
certificate, pin the exact post-gate formal commit, narrow the Lean cleanliness
check to the scholarly source pathset, and turn the two Dye assumptions into
fully cited public declarations. These upgrades found and repaired one real
formal build failure, one nondeterministic replay output, one stale
manuscript workflow comment, and one invalid old formal pin before review.

A demanding referee can now move in both directions: from each published row
to its exact route and artifacts, and from every admitted terminal or checker
back to a unique Paper I row. The remaining high-value action is genuinely
independent review, not another implementing-agent polish pass.

### Mystery ledger

- **Settled — formal axiom boundary.** The only nonstandard axioms are the two
  precisely cited Dye inputs.
- **Settled — replay determinism.** Every exact checker has canonical tracked
  stdout identity; wall time is excluded.
- **Settled — C321.** No Singular route or package remains.
- **Settled — fallback preservation.** All four fallback surface hashes match
  their frozen values.
- **Open — independent adequacy review.** The implementing agent cannot satisfy
  this gate. The user must launch the cold reviewer, and any finding requires
  a fix followed by a separately user-launched post-fix review. C320 stays
  live until that reviewer records final `GO`.

## User-launched independent review and repair

**Review date:** 2026-07-24

**Review verdict:** `NO-GO`.

The cold review sampled paper-to-manifest, manifest-to-terminal,
gate-to-import, checker-to-coverage, and command-to-artifact links. The
mechanical release command was green, but the review found semantic omissions
that the original validator did not reject:

1. theorem row 17 omitted the human degenerate-conic reduction from its
   decomposition and described a nonsingular-conic Lean terminal as the exact
   implication;
2. the fourth stabilizer clause required an unrecorded
   Storme--Van Maldeghem converse;
3. row 26 omitted Dye's associated-conic edge criterion preceding his
   Theorem 6;
4. rows 25 and 29 omitted the classical inputs inherited through their
   rigidity and field-uniqueness dependencies;
5. six replay routes used generic coverage prose and five multi-checker
   routes encoded English-composed commands;
6. the deterministic release result did not attest the exact source,
   statement identity, PDF, checker certificate, or semantic release
   surface.

Commit `3ed43a0d` repairs every finding. The principal theorem now has the
three geometric equivalences; Dye's stabilizer theorem is a consequence, so
no load-bearing Storme--Van Maldeghem converse remains. Row 17 separates the
human degenerate-conic argument from the kernel-checked nonsingular
implication. Rows 25, 26, and 29 name their complete transitive classical
inputs. Every replay gives its exact finite domain and structured checker
argv, and the validator rejects generic coverage, missing required citations,
or checker commands absent from the fifteen-check runner. The release output
now attests the source, PDF, statement identity, checker-output certificate,
and a canonical self-reference-free release-surface hash. The public
manuscript PDF and both public README files are manifest-pinned.

The verification-tool suite increased from eight to eleven tests. The
repaired source builds to 19 pages with no warning. The clean fifteen-check
replay passed in 3 minutes 1 second at Paper I commit `3ed43a0d` and Lean pin
`bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`; its stdout exactly matches the
tracked release-output hash
`6b59e85768f5cc0b65126dbd0a0f3899d948a5d04dfdfef819283c331024609a`.
C320 now stops for a separately user-launched post-fix cold review. This
repairing session cannot supply the final `GO`.

### Post-review `ej` + `tt` closeout

The cheap general upgrade exposed by the review was to make semantic
adequacy partly machine-enforced. The validator now checks exact coverage
prose, structured checker argv, checker admission by the release runner,
selected transitive citation boundaries, public-document hashes, and a
self-reference-free release-surface attestation. This does not replace
mathematical review, but it prevents the specific omissions found here from
silently recurring.

The other high-value cleanup was routing. The live handoff now declares
itself the single Clebsch paper router and states the strict order
`C320 post-fix GO -> C182 -> C577 -> C579`. The superseded 566-line
replacement-spine plan is preserved under an explicit `-archive.md` name;
its former path is a 24-line retired redirect with no active verdict or cold
route.

### Mystery ledger after repair

- **Settled — rigidity trust decomposition.** The theorem has three geometric
  equivalences; the human degenerate-conic reduction and kernel-checked
  nonsingular implication are separate, and the stabilizer is a Dye
  consequence.
- **Settled — transitive classical inputs.** Rows 25, 26, and 29 state the
  Dye and Sylvester inputs actually used by their proofs.
- **Settled — checker coverage and command identity.** Every executable route
  has an exact finite domain and structured argv admitted by the release
  runner.
- **Settled — command-to-artifact identity.** The deterministic output attests
  the source, PDF, statement identity, checker certificate, formal pin, and
  canonical release surface.
- **Settled — active routing.** The handoff is the sole active router; the
  mega-paper and replacement-spine plans are explicit non-routing history.
- **Open gate — post-fix independence.** Only a separately user-launched cold
  review can return final `GO`; C320 remains live until then.
- **External packaging — C182.** A public companion-paper provenance target,
  archive DOI/release, licence, and final immutable package remain C182 work
  after C320 `GO`.

No other genuine C320 repair mystery remains.

## Preserved mega-paper ledger — fallback evidence only

Everything below this heading through the historical checklist records the
former 37-page integration and review surface. Consult it only to recover
candidate evidence routes and exact provenance. Do not execute its
manuscript, row-count, review-launch, or release instructions as current
C320 work.

The former early-start authorization admitted C505/C507 and the complete
replacement-spine surface. The checked-in
`papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` remains that preserved
fallback manuscript; none of its compound claims inherits into Paper I.

### Foundation landed before final slice intake

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

### Adopted release-claim partition before manuscript integration

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

### Slice-intake state

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

### First-pass headline adequacy map

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

### Admitted closing-slice evidence blocks

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

### Admitted replacement-spine core

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

### C321 trigger audit: fallback Singular dependency

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

### Initial reconciliation judgments

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

### Final fallback implementation and reconciliation record

The release manuscript now follows the selected C406+C411 replacement spine and closes with the
C480/C486/C487 torsor Rosetta result.  Its five headline blocks are A--D plus the closing theorem
E.  The survival ledger distinguishes retained finite shadows from proved erasures, C412 is
included only at its exact projective-cover/Tate-plane boundary, C471's optional degeneration
shadow is omitted, and C479 remains absent.  The historical smooth/genus-three C02 sentence was
removed, so the Singular calculation is no longer load-bearing for the
fallback. This historical conclusion predicts but does not replace the
nineteen-row Paper I C321 audit.

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
- `verification/evidence/four_sheet_holonomy/` contains the direct rank-drop and reduced
  cycle-transport checkers, canonical certificates, semantic README, and fail-closed bundle verifier;
- `verification/statement_adequacy.json` records all 28 exact theorem-like environments;
- `verification/trust_manifest.json` contains 61 claim rows with one explicit route or mixed
  decomposition per row, the pinned shared-Lean commit
  `43c403b23e7cb6b9d66dda01bb43a91bec9ea465`, exact gate/audit hashes, terminal-local axiom
  lists, cited inputs, residual trust, and the complete release check list; and
- `verification/verify_release.py` validates both flattened repositories, runs the paper checks,
  evidence bundles, pinned Mathlib-cache setup, and the exact aggregate Lean target, and rejects
  any source-tree mutation; and
- `flake.nix` and `flake.lock` define the standalone paper repository's NixOS 26.05 environment
  for Python, Singular, Tectonic, Nix, Git, and core utilities.  The manifest hash-binds both
  environment files, while the separate Lean checkout remains independently pinned.

The aggregate Lean gate and durable axiom audit landed in commit
`223584997c5691a60c066d865c0a0e449a38cd21`.  Paper evidence migration landed in commits
`be274713` and `c39d2846`; the replacement manuscript and first manifest landed through
`70c39f78`, and proof promotion/discovery banking through `f67f5f51`.  Planning reconciliation
landed in `3ee4476f`; the style-guide, proof-mechanism, and dependency-aware release revision landed
in `d98b858f`.  The tracked deterministic output and its manifest hash record the final release
state.

The Paper I Lean prose audit was repaired in the separate documentation-only commit
`43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.  It adds all 42 missing declaration docstrings,
promotes the four mathematical overviews to valid module documentation, replaces workflow-relative
language with named interfaces, attaches classical/semantic boundaries to exact manifest rows,
compresses the five longest introductions, and neutralizes the overstrong torsor title.  The exact
aggregate command then completed all 8,734 jobs at that pin.  One first attempt was killed by the
host at the large B3 kernel reduction; serially prebuilding that unchanged leaf and rerunning the
unchanged aggregate command from cache succeeded.

The standalone flake definition was captured in `5dc8f50a`; its lock, the real `finitegeom`
repository URL, the new Lean pin, and regenerated manifest landed in `6f9fca2c`.  A final
public-tree scan then found and removed two stale internal workflow references from export prose;
the checker hash and manifest were refreshed in `195f0aa7`.  The post-cleanup 17-check release
replay passed with the same deterministic output.

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
After the documentation audit, repin, and standalone-flake addition, its fresh complete run returned
`status: passed` for all 18 checks: six verification-tool tests, statement extraction, eleven
retained finite paper checkers, all three public evidence bundles, pinned Mathlib-cache setup, and the
exact aggregate Lean target.  The emitted JSON matched the tracked deterministic
`verification/verify-release-output.json`, which is hash-bound by the trust manifest.

### C552 cover-holonomy manuscript delta

The pre-review manuscript now imports the C550 linear-sheaf/cycle-holonomy
theorem.  `thm:four-sheet-holonomy` replaces the certificate-first
four-copy account by a compact conceptual proof of the constant-section
kernel, systematic `24 x 21` to `9 x 9` transport reduction, three localized
cycle obstructions, reduced divisor, relative-frame multiplicities, and
exceptional-characteristic split.  It explicitly keeps signed
`w=+/-2/3` sheets distinct before passage to `z=4/9`, restricts itself to
the admitted odd-characteristic non-GRS pencil, and claims neither complete
pencil recovery nor four-copy minimality.

The degree-six representation language is corrected throughout the adopted
passage.  The order-24 group is the rotational octahedral action on six
vertices with point stabilizer `C4`, not the tetrahedral edge action; the
axial `C2^3` seam has orbits `2+4`, not `2+2+2`; and the full octahedral
symmetry acts on the reduced linear transport frame, not the bare
bipartite multigraph.  The abstract groups, `96/192` double-coset sizes,
common derived `A4`, and `8/16` quotient counts remain unchanged.

The internal frozen C550 evidence has report/checker/certificate SHA-256
hashes
`72896f37c0fc7c410fb3282dc15a007613723d11e3f1145db1f4825ef5359cca`,
`3709c9f0578c4868a838f67a56b5fa6cec41e1571c288d1a26eb2997005d52a7`,
and
`9d3bcb92d97d8fc84d4459cde906894d40e9c542d8ab389b5cf0b4fe29e5bda3`.
The public paper artifact is the workflow-free
`verification/evidence/four_sheet_holonomy/` bundle; its checksum-manifest
hash is
`c73124261d5584a304aaf3dc52649844a5dae717dc28908f28f29574b96b8fbf`.
The bundle independently regenerates both the direct `24 x 21`
rank-drop certificate and the reduced `9 x 9` cycle-transport certificate.

The adequacy extraction now records 28 theorem-like environments, and the
trust manifest records 61 claims.  The cover-holonomy theorem has one exact
environment row and three separately hashed clause rows.  Each clause has
an explicitly mixed route: conceptual proof in the manuscript plus exact
public replay, with no inherited Lean label.  The shared-Lean pin remains
`43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.

The user-launched post-C552 cold read is
`notes/2026-07-23-c320-independent-cold-read.md` and returned `NO-GO`.  Its frozen-state finding was
subsequently settled: the normalized manuscript, 28-statement extraction, 61-claim manifest,
four-sheet evidence bundle, and deterministic 18-check output are committed, and the current paper
tree is clean.  The C552-specific exposition finding is settled in
`c5deec3c`: the manuscript now displays the pencil and coordinate covectors
before the four-sheet theorem and states, there and in the conclusion, that
the result is a strict survival boundary rather than a
parent-reconstruction step.  The remaining blockers are substantive:

1. geometric Clebsch-parent recovery is routed through a terminal that explicitly recovers only a
   frozen matching-table row;
2. the factorization/balance/depth and Rosetta sections do not expose enough bridge maps and finite
   mechanisms to support the headline wording;
3. the uniform rank-three headline lacks one locatable `A_3/B_3/H_3` proof path; and
4. the “statement adequacy” label exceeds what textual extraction and hashes establish.

The next repair pass must reconcile the user's feedback with those findings, update manuscript and
trust routes together, rerun all 18 checks on a frozen commit, and stop for user-launched post-fix
review.

The C552-specific repair's first release rerun was deliberately not
accepted: it reached the final immutability guard while this broader C320
manuscript repair was changing `clebsch_hexagon_code.tex`.  Regenerate all
manuscript-derived artifacts and rerun from the eventual frozen C320
candidate.

### Sol structural-review repair

The 2026-07-24 Sol report assessed the rigidity core as close to
submission-ready and requested one concentrated structural pass.  Commits
`00e5b19b`, `220f973f`, `3836c302`, and `5a82e80d` implement the task-owned portion:

1. Theorem 2.1(A2) now states all three code parameters.  Proposition
   `prop:lattice-good` defines the reduction boundary by finite
   nonvanishing conditions on the mirror matroid and the weighted
   singular-point collinearity matroid.  Its proof transports the exact
   `2,3,5=h/2` collision maxima and proves that every nonempty complement
   spans the plane.
2. Proposition `prop:general-matching-quotient` separates the reusable
   construction from the three Coxeter applications.  For arbitrary
   `2m` conic points it proves pairing-independent restriction, divisibility
   by the conic equation, reference-translation independence, and the
   determinant-twisted equivariance law.  The `3,6,10` rank calculations
   remain separate finite applications.
3. The 157-word abstract drops its verification sentence.  The
   contribution inventory is now a contribution/dependency table; proof
   modes consistently name human proof, cited input, exhaustive exact
   replay, and Lean-checked algebra.  The conclusion now centers Theorems
   5.3 and 7.2 and the factorization-recovery mechanism.
4. The appendices are labelled A and B, the Drake--Keating DOI is formatted
   as a DOI rather than a malformed-looking URL, and the rebuilt 37-page
   PDF has no TeX error or overfull box.  Direct page inspection found the
   formerly sparse pages 25 and 31 fully occupied.
5. Because the user retained the single-paper architecture, Section 12 was
   not silently deleted.  It now opens with the retention question,
   defines every passage in the comparison table, states that none is used
   by the rigidity or matching-recovery theorems, replaces the internal
   “Paper-1 boundary” phrase, and cites the split-torus, subgroup, spinor,
   Witt--Mathieu, Hadamard, theta, Clifford, and Weil terminology.
6. The verification section and public README now give the finitegeom URL
   and Lean pin, Mathlib pin, locked paper tool versions, exact clean
   command, expected eighteen-check sentinel, and platform assumptions.
   The paper archive DOI, paper-repository URL/tag/commit, measured cold
   runtime, and licence do not yet exist and remain C182/user-supplied
   publication-package blockers; the public files say so rather than
   inventing identifiers.

The exact extraction now contains 29 theorem-like environments and the
regenerated trust manifest contains 58 rows, including explicit mixed
routes for both new propositions.  Manifest validation and all six
verification-tool tests pass.

The first clean detached replay was placed on the disk-backed but
non-executable `/tmp/persistent` mount.  It passed the paper-facing stages
and built the Mathlib cache helper, then failed closed when the operating
system refused to execute that helper.  This is an environment-placement
failure, not a failed mathematical check.  The unchanged committed
snapshot was restarted from executable disk storage.

The executable-disk cold run then reached the aggregate Lean gate but
exceeded that check's 1,800-second timeout after 40 minutes 41 seconds of
total release-runner wall time.  It reported no theorem or checker
failure.  This is measured evidence that the current cold-build timeout is
too small on this host; changing that release gate requires explicit user
approval.  The unchanged command was rerun in the same clean snapshot
against the artifacts produced before timeout, matching the previously
accepted prebuild-then-gate validation route.

That unchanged rerun passed all eighteen checks in 25 minutes 10 seconds
at detached paper commit `5a82e80d` and Lean pin
`43c403b23e7cb6b9d66dda01bb43a91bec9ea465`.  Its terminal JSON reports
`"status": "passed"` and the pinned Lean commit.  The successful run used
only artifacts produced by the immediately preceding timed-out cold
build; no source, target, timeout, manifest, or command changed between
attempts.

### Sol-round `ej` and Tao closeout

The highest-value free generalization was latent in the referee request:
the endpoint-product identity proves matching-independent conic
restriction for every perfect matching.  The paper therefore needs no
connectivity hypothesis to define the general quotient.  Proposition 8.1
now states the natural construction, while the Lean route remains
explicitly bounded to its four-endpoint and switch interfaces.

The other cheap conceptual repair was to separate two specialization
questions.  Odd reduction preserves the displayed `H_3` mirror lattice,
but the distance theorem also needs the weighted collinearity matroid of
the singular points.  Proposition 7.1 names and proves exactly that
stronger condition; the headline theorem points to it before using the
term.

The closeout leaves three genuine non-correctness items:

- **Open presentation optimization — factor the determinant boundary.**
  The current finite nonvanishing definition is exact and sufficient, but
  it does not print a minimal numerical list of bad primes for the
  singular-line matroid.  Adding that list would require a paper-facing
  generator/certificate/replay bundle under the research-reproducibility
  policy.  It is not a hidden hypothesis or current correctness gap;
  reopen only if the post-fix reviewer finds the determinant definition
  insufficiently auditable.
- **Open editorial choice — Section 12.**  The retained section now has
  motivation, definitions, citations, and an explicit nondependence
  statement.  Sol still recommends removing it.  The user owns that scope
  decision; no further mathematical evidence will settle a venue-fit
  preference.
- **External publication packaging.**  C182 or the user must supply the
  archive DOI, paper repository and release identifier, licence, and a
  cold-runtime policy.  The measured cold attempt shows that the current
  1,800-second aggregate timeout is too small on this host; changing that
  validation gate requires explicit approval.

No mathematical correctness mystery remains from the Sol-round repair.
The next evidence gate is the user-launched independent post-fix review.

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
- **Settled — Lean prose audit.**  Every issue in the 2026-07-23 audit is repaired in the separate
  documentation-only commit above.  The aggregate trust gate is green at that exact pin.
- **Settled — standalone export environment.**  The paper root now carries a stable, locked Nix
  flake and names `https://github.com/tavisrudd/finitegeom` as its separate Lean repository.  The
  q25 certificate repository is not imported by Paper I and is therefore outside this manifest.
- **Settled — public workflow references.**  The export contains no `C###` task reference.  The
  former archive-task sentence and one checker reference to an internal report were replaced by
  stable archival and manuscript boundaries, and the affected checker hash was revalidated.
- **Open, deliberately sequel-owned — arithmetic origin of the sign gluing.**  Paper I proves that
  every available two-point carrier has the same determinant-sign action and therefore the same
  torsor.  It does not construct a uniform arithmetic or metaplectic object producing that gluing
  across characteristics.  The conclusion states this single scoped question; a new theorem
  requires such a construction, not another table.
- **External packaging item — immutable archive.**  C182 still owns the DOI/archive.  This is not a
  mathematical or trust-manifest gap, but release prose must not claim the DOI before it exists.

No other genuine C320 correctness mystery remains before independent review.

### Historical required outcome

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

### Historical referee-facing standards and guarded failure modes

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

### Historical required judgment-call record

Record every reconciliation choice: competing task claims, adequacy mismatch, route downgrade or
upgrade, conditional decomposition, omitted claim, accepted classical input, verify-all scope, and
packaging exclusion. For each give alternatives, evidence, effect on paper wording/trust, rejected
routes, and reopening condition. Never resolve conflict by choosing the strongest label or by
leaving “if feasible” in the final ledger.

### Historical mega-paper closing review and archival checklist

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

The checklist above is retained as the fallback's review record. Its checked
items do not satisfy the focused Paper I gate.

## Current Paper I closing checklist

- [x] Extract and hash every Paper I theorem-like environment and separately
  published claim from `papers/clebsch-rigidity/clebsch_rigidity.tex`.
- [x] Reconcile the extraction exactly with C575 rows
  `2, 11--26, 29, 58`; account for every adopted claim once.
- [x] Assign one exact conceptual, cited, Lean, certificate, replay, or mixed
  route per row; admit no Paper II/III route.
- [x] Verify theorem adequacy against actual Lean types and definitions,
  including axioms, imports, and the paper-to-formal correspondence.
- [x] Verify every executable row's finite domain, completeness argument,
  checker semantics, hashes, independent replay, and residual trust.
- [x] Build a Paper I aggregate gate, axiom audit, clean verify-all command,
  and deterministic output without changing either source repository.
- [x] Preserve the mega-paper manifest, gate, extraction, and release output
  byte-for-byte as a separate fallback surface.
- [x] Confirm C321 is not triggered, or interpose it before release if a
  load-bearing Singular route appears.
- [ ] Repair every issue found by the user-launched independent reviewer and
  obtain the required post-fix `GO`.
- [ ] Only after final `GO`, archive C320 and hand the exact Paper I surface
  to C182.
