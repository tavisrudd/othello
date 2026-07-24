# C320 — Clebsch referee-facing trust ledger

**Lane:** `clebsch`

**Status:** active incremental foundation; C505/C507 final reviewed deltas not yet admitted

This file is both the cold-read task specification and the required durable result report. Complete
it in place. C320 is not an editorial summary: it is the authoritative claim-by-claim ledger that
determines which Clebsch paper statements may be labelled Lean-formalized, certificate/replay-backed,
conceptual/citation-backed, or mixed.

## Early-start authorization and current boundary

On 2026-07-23 the user explicitly authorized C320 to begin while C507 is underway, with the C505
and C507 results to be admitted when ready.  This overrides the start-order gate but not the
release gate: C320 remains live and cannot claim a complete inventory, pin a release commit, run
its final adequacy comparison, or request its independent review until both slices have delivered
their final reviewed deltas or the corresponding manuscript claims have been removed.

The checked-in `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` is still the protected
19-page baseline.  It is not the replacement-spine manuscript described by
`notes/2026-07-21-clebsch-paper-abstract-outline.md`.  Consequently the current baseline statement
inventory and the adopted replacement-spine claim inventory are tracked separately.  No planned
claim inherits a trust route merely because a related terminal already exists, and no baseline
statement is silently dropped before the final manuscript edit makes that deletion explicit.

The C507 worktree is active and foreign to this C320 foundation.  Its untracked Lean modules and
modified report are not read as final evidence, edited, built, staged, or included in a C320
commit.

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
  decomposition for mixed routes.
- `extract_gate_audits.py` records each import-only gate's exact SHA-256, imports, declared
  `#print axioms` terminals, and whether the audit is embedded in that gate.  It does not mistake
  an import-only module name for an audited terminal surface.

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
python3 verification/verify_trust_manifest.py
  -> fails closed because trust_manifest.json has not yet been admitted
python3 verification/extract_gate_audits.py <thirteen completed gate paths>
  -> 13 gates, 162 embedded audit terminals
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
| C505 | implementation commit `5ec97659`; final independent-review `GO` not recorded |
| C506 | final independent-review `GO` on implementation commit `51b21674` |
| C507 | implementation underway; no final artifact or reviewed delta admitted |

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

- [ ] Inventory every published Clebsch claim and separately stated subclaim; account for each once.
- [ ] Assign one exact final route per row and prohibit trust inheritance across combined claims.
- [ ] Verify adequacy against actual theorem types/definitions, not names, reports, or intended prose.
- [ ] Verify every Lean terminal is imported by the pinned gate and record current exact-target and
  axiom-audit evidence.
- [ ] Verify every computational row's checker semantics, exhaustive coverage, artifacts, hashes,
  independent replay, and residual trust; distinguish search evidence from proof.
- [ ] State every named classical/axiomatic input and the unconditional remainder without it.
- [ ] Reconcile all task judgment logs, review findings, fallbacks, exclusions, and post-fix changes.
- [ ] Provide one clean-source verify-all entry point that fails loudly on missing/stale/mismatched
  components and leaves the worktree unchanged.
- [ ] Produce the verbatim adequacy-appendix extraction and compare it to final manuscript claims.
- [ ] Audit the referee-facing manifest/artifacts for self-containment, stable citations, one-way
  references, semantic naming, and absence of internal workflow or unsupported novelty language.
- [ ] Record independent review, every finding/fix, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive C320 with this completed report and the manifest/entry point.
