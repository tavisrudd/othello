# Trust-doc diff review — factual accuracy (Fable, 2026-07-18)

Scope: the 599-line diff combining the `lean/TRUST.md` rewrite, `lean/NodeKayles/TRUST.md`,
`lean/RelativeConicArcs/README.md`, the `lean/README.md` scope note, the RowConclusion.lean
working-tree change, and queue rows C318–C325. All claims re-checked against the repository;
no Lean builds were run (forbidden for this review), so "kernel-checked" status is taken from
the manifests' self-reports, not re-verified. Every import-graph statement below is from reading
`import` lines, one or two levels deep — not a transitive-closure computation.

## Verdict

The document is largely accurate and appropriately hedged, and the per-area summary table and
named-classical-inputs table check out against the five manifests. But the "Axiom position"
section — the part flagged as previously wrong — is **still incomplete**: it fails to disclose
two custom axiom declarations that exist under `lean/RelativeConicArcs/`, and one queue row
(C320) makes a claim about Dye that is factually false. The generated-data table in the new
README has one wrong consumer row, one consumer that exists only in uncommitted work, and a
blanket "DO NOT EDIT docstring with generator and hash" claim that is false for three of the
trees it lists. Details below, worst first.

## 1. Axiom position — the correction is better but still not complete

Ground truth. An exact-pattern sweep for axiom declarations under `lean/` (`^\s*axiom\s`,
all `.lean` files) finds exactly four:

1. `DihedralSchreier/DensityAxioms.lean:54` — `primes_equidistribute` (disclosed).
2. `RepairCodes/Imported.lean:34` — `stichtenoth_selfDual_TVZ_6561` (disclosed).
3. `RelativeConicArcs/Q11DyeAxioms.lean:40` — `dye1991_brianchon_bound` (**not disclosed**).
4. `RelativeConicArcs/Q11DyeAxioms.lean:47` — `dye1991_equality_classification` (**not disclosed**).

A separate sweep for `sorry`/`admit`/`native_decide` found only doc-comment mentions of the
form "never `native_decide`" (e.g. `RelativeConicArcs/FiniteFields.lean:10`); no actual uses.
All other `axiom` string hits across `ProjectiveCap`, `CapGame`, `Sumfree`, `RepairPorts`,
`Queens` are `#print axioms` commands, not declarations.

Assessment of the two Dye axioms:

- They sit inside the very library whose row says it depends only on Kim–Vu and NRC/GRS, and
  they are mentioned neither in the new `lean/TRUST.md` nor in
  `lean/RelativeConicArcs/TRUST.md`. The arcs manifest's own audit sentence ("There is no
  sorryAx, custom axiom, admit, or native_decide dependency",
  `RelativeConicArcs/TRUST.md:178`) is scoped to the audited list, and I verified the axioms
  appear to be leaves outside the Relconic gate closure: only
  `RelativeConicArcs/SixArcDefectBridge.lean` and `RelativeConicArcs/Q11DyeConsequences.lean`
  import `Q11DyeAxioms`, and nothing imports `Q11DyeConsequences`
  (`SixArcDefectBridge.lean:19` states the import is for definitions only, "no clause of
  Dye's theorem" used). So the scoped audited-theorem claims are, as far as import-level
  checking can tell, **true**.
- But the new "Axiom position" section presents itself as the tree-level axiom picture, and
  it lists the axiom inventory as: standard three everywhere, plus Stichtenoth, plus
  `primes_equidistribute`. That inventory is missing half the custom axioms under `lean/`.
  The escape hatch "the scope of a claim below is exactly that named list, not the library
  as a whole" saves the sentences from being false, but a trust document whose axiom section
  omits two of the four axiom declarations in the tree is materially incomplete — exactly
  the failure mode the section was rewritten to fix. Recommend adding one bullet: the
  RelativeConicArcs library additionally contains the two specialized Dye axioms in
  `Q11DyeAxioms.lean`, used only by the Clebsch-facing `Q11DyeConsequences` modules, outside
  every gate closure and outside the arcs manifest's audited list.

Related and worse, because it is flatly false: queue row **C320** says "Dye is currently
documented nowhere under `lean/`". `Q11DyeAxioms.lean` is a 56-line file whose entire purpose
is documenting the exact Dye boundary, with a docstring saying so and `#print axioms` on both
axioms. What is true is that Dye appears in no TRUST/README manifest under `lean/`. The row
should say that.

- The RepairCodes bullet names only `ProjectiveAxisTwistedCubicAsymptotic` as carrying the
  Stichtenoth axiom. `RepairCodes/Asymptotic.lean:7,148` shows the earlier asymptotic family
  theorem also rests on the same import (consistent with `RepairCodes/TRUST.md:9`, "the
  asymptotic family headline"). Naming one declaration implies exclusivity a referee could
  falsify with one `#print axioms`. Say "the asymptotic family results", or name both.

## 2. Per-area summary table — verified, with three qualifications

Checked against `RelativeConicArcs/TRUST.md`, `RepairCodes/TRUST.md`,
`FiniteGeom/BaerCompletion/TRUST.md`, `DihedralSchreier/README.md`, `NodeKayles/TRUST.md`.
All five detail links resolve. Row-by-row:

- **Arcs**: accurate. Kim–Vu as named hypothesis not used by finite examples
  (`RelativeConicArcs/TRUST.md:182-184`), NRC/GRS as cited dictionary (`:185-186`) — both
  confirmed. Caveat: the row's "Depends on" column omits the Dye axioms per §1.
- **Q25 equivariant robust completion**: the hedge on the exactness/equality-orbit layer is
  right and matches C151 being ACTIVE. But "the residual lower bound for normalized rows"
  as an already-kernel-checked item is ahead of the visible state: the row-conclusion
  theorem in the diff (`Q25ResidualCoverPrototype/RowConclusion.lean`) is an **uncommitted
  working-tree change**, covers one class (`b=31`, 50 rows), and its new import
  (`Q25ResidualDispatchData`) is that data tree's only consumer. I could not verify any
  committed, built theorem matching that phrase. Either narrow the phrase to what the
  committed prototype proves, or hold the row until C151 lands.
- **Baer**: matches the manifest (unconditional results; completion radii cited, listed
  separately, not used — `FiniteGeom/BaerCompletion/TRUST.md:83-88`).
- **Repair codes**: matches (`RepairCodes/TRUST.md:60-71`); conditional-on-theorem-arguments
  phrasing is exactly the manifest's. Same single-module quibble as §1 last bullet.
- **Dihedral**: the dependency claim is exact (`DihedralSchreier/README.md:37-61`). But
  "the reduction and template results, unconditionally" is ambiguous in a bad direction:
  the README explicitly lists "every template nimber" and Brown et al.'s template Grundy
  evaluations as **not** formalized (`README.md:69-70`). What is proved is the Burnside
  template-homomorphism layer (`Burnside.lean` items), not template values. A referee
  reading "template results" as "the template tables" would be misled. Say "the reduction
  and Burnside/template-homomorphism results".
- **NodeKayles**: accurate and deliberately understated relative to
  `NodeKayles/TRUST.md` (which also covers iso-invariance and the Grundy layer). Fine.

"Areas absent from this table do not yet have a stated trust boundary. Clebsch,
complete-ports, and crowns are in that state" — see §5 (omissions) for `Queens/`.

## 3. RelativeConicArcs/README.md — layers, data table, gates

Layer lists: all eleven named modules exist
(`Q25Coordinates`, `Q25Normalization`, `Q25PairCertificate`, `Q25OrbitDecomposition`,
`Q16StepKernel`, `Q25MinimumChecker`, `Q25MinimumMask`, `Q25LineMaskChecker`,
`Q25ResidualCoverBridge`, plus `Q25LineMaskComposition`, `Q25ExactnessComposition` used by
the data table). Minor inconsistency: `Q25PairCertificate` is listed in layer 1 (semantic
definitions) but is the layer-2 consumer in the data table; it plausibly serves both, but
the README should not put it in only the layer that the data table contradicts.

Generated-data table — every listed directory exists. Consumer column, verified at the
import level:

- `Q25LineMaskData` → `Q25LineMaskChecker`: **confirmed** (leaves import the checker).
- `Q25RowCompositionData` → `Q25LineMaskComposition`: **confirmed**.
- `Q25ClassBoundData` → mask lower bounds via `Q25ClassBoundData/Bridge.lean` importing
  `Q25LineMaskComposition`: **consistent**.
- `Q25ExactMinimumRows` → `Q25ExactnessComposition`: **confirmed**.
- `Q25PairData` → `Q25PairCertificate`: **confirmed in spirit** — the actual leaf tree is
  `Q25PairRows/` (whose leaves import `Q25PairCertificate`); `Q25PairData/` files are thin
  wrappers/aggregators over it. `Q25PairRows/` is itself absent from the table.
- `Q16CertificateData`, `Q16LeafData` → `Q16StepKernel` coverage / leaf rejection:
  **roughly right** (leaf-rejection theorems live in `Q16LeafData` leaves via
  `Q16CertificateLevels`; aggregates import `Q16StepKernel`). `Q16CertificateRows/` (the
  per-row transition tree) is absent from the table.
- `Q25ResidualCoverData` → `Q25ResidualCoverBridge`: **partially right** —
  `Q25ResidualCoverBridge.lean` imports only `Q25ResidualCoverData.Schema` (its single
  import).
- `Q25ResidualTransportData` → `Q25ResidualCoverBridge`: **wrong**. Transport data is
  consumed by `Q25ResidualCoverPrototype/ClassLink.lean` and `Dispatch.lean`, not by the
  bridge. This is one of the inferred consumer relationships, and it is incorrect.
- `Q25ResidualDispatchData`, `Q25ResidualClassLinkData`, `Q25ResidualConclusionData` →
  "residual conclusion composition": **exists only partly, and partly uncommitted**.
  Dispatch/class-link data are consumed by `RowConclusion.lean` only via the uncommitted
  diff; `Q25ResidualConclusionData` is imported by nothing except the **untracked**
  `Q25ResidualConclusionDispatchData/` tree (304 files, `??` in git status). In the
  committed tree this consumer does not exist.

The blanket claim "Its files are machine-generated, carry a `DO NOT EDIT` docstring naming
the generator and the payload hash" is **false for three listed trees**: `Q16CertificateData`,
`Q16LeafData` (and the unlisted `Q16CertificateRows`), and `Q25PairData`/`Q25PairRows`
contain no `DO NOT EDIT` marker and no generator/hash docstring (checked sampled leaves,
e.g. `Q16LeafData/L_002.lean`, `Q25PairRows/R_006_C_207_306.lean` — they open directly with
`import`). Consequently "To regenerate any of them, use the generator named in the file
docstring" is unfollowable for those trees (the Q16 provenance lives in
`RelativeConicArcs/TRUST.md:123-135` instead). The residual/mask/composition trees do carry
the claimed headers (verified in five trees). Either add the headers to the Q16/pair trees
or scope the sentence to the trees that have them.

Directory omissions from the table: `Q16CertificateRows/`, `Q25PairRows/`,
`Q25ResidualConclusionDispatchData/` (untracked). Since layer 3 is defined as "the `*Data/`
directories below", a reviewer will take the list as complete; the `*Rows` trees are equally
generated data.

Gate tables (both files): all five modules exist under `RelativeConicArcs/Gates/`
(`Relconic`, `Baer`, `AlternateOrbitRepairQ25`, `AlternateOrbitRepairParameterized`,
`AlternateOrbitRepairProfileEnvelope`) and the closure descriptions match the docstrings —
with two qualifications:

- "whose docstring states exactly which subtrees it includes and excludes" — only
  `Relconic.lean` states an exclusion ("deliberately excludes the Q25 certificate and repair
  subtrees"). `Baer.lean` states only what it imports; the three alt-orbit gates state a
  separation rationale (instance-name collisions), not an include/exclude inventory. The
  sentence overclaims what the docstrings do.
- `Gates/Baer.lean | Baer completion`: the gate's docstring says it is the terminal for the
  five-profile Q25 conjugate-pair extension. Whether its transitive closure covers every
  theorem `FiniteGeom/BaerCompletion/TRUST.md` audits (multi-insertion, completion core,
  `CollisionProfile` — which the manifest's validation command builds as a separate target,
  `TRUST.md:124-130`) I could not verify without a transitive import computation. If it does
  not, a reviewer following "what to build to check a closure" for the Baer area will build
  less than the manifest's audited set. Worth an explicit check, or a narrower closure label
  ("Q25 conjugate-pair extension terminal").

Both design-review links at the bottom of `lean/TRUST.md` resolve
(`notes/2026-07-18-c151-orbit-completeness-fable-review.md`,
`notes/2026-07-18-c151-certificate-portfolio-fable-review.md`).

## 4. Named-classical-inputs table — verified, all six rows

- Kim–Vu: named hypothesis in signatures, never global axiom, unused by finite examples —
  matches `RelativeConicArcs/TRUST.md:182-184`. **Correct.**
- NRC/GRS: cited dictionary, Lean owns the implication after it — matches `:185-186`.
  **Correct.**
- Al-Seraji–Al-Ogali: external consistency check only — matches `:186-187` and `:144-145`.
  **Correct.**
- Stichtenoth: global project axiom stated once — matches `RepairCodes/TRUST.md:69-71` and
  `Imported.lean:34`. **Correct.**
- Singer regular action: explicit theorem argument — matches `RepairCodes/TRUST.md:76-77`.
  **Correct.**
- Completion radii: cited, not formalized — matches `FiniteGeom/BaerCompletion/TRUST.md:83-88`.
  **Correct.**

The table's own gap: the two Dye axioms are precisely a "result cited rather than reproved"
entering as a **global axiom** (the weaker shape the document itself warns about), and they
are missing from this table. Adding a Dye row here would fix §1 and this section at once.

## 5. Omissions a reviewer would need

- **`lean/Queens/`** (`Basic.lean`, `CentralChild.lean`, `GrundyCert3.lean`, with
  `#print axioms` headlines) appears nowhere: not in the summary table, not in the
  "absent areas" sentence (which names only Clebsch/complete-ports/crowns), and not in the
  unaudited list (`ProjectiveCap`, `CapGame`, `Sumfree`, `RepairPorts`). It has no manifest.
  A reviewer enumerating `lean/` directories against `TRUST.md` will find one undescribed
  library. Add it to the unaudited list (no axiom declarations found in it, so the addition
  is cheap).
- The unaudited-list claim itself is **verified**: none of `ProjectiveCap`, `CapGame`,
  `Sumfree`, `RepairPorts` has any `.md` manifest, and none contains an axiom declaration,
  `sorry`, or `native_decide` (string sweep; only `#print axioms` hits). No hidden warning
  needed beyond "unaudited".
- "does not yet have a stated trust boundary … their claims currently rest on reports and
  scripts outside this tree" for Clebsch is slightly too absolute: the Clebsch-facing Dye
  boundary and `Q11DyeConsequences` layer *are* in this tree (that is the point of
  `Q11DyeAxioms.lean`), and the portfolio review credits Clebsch with 11 Lean roots. "No
  stated trust boundary" is fair; "rest on reports and scripts outside this tree" undersells
  the in-tree Lean roots. One clause fixes it.
- `RepairCodes/TRUST.md:3` still says "the strict kernel-checking profile established in
  `lean/TRUST.md`" — after this rewrite, `lean/TRUST.md` states the profile per-area rather
  than establishing one strict profile; the sentence still reads sensibly but now points at
  a different document than the one it was written against. Cosmetic staleness, not an
  error.

## 6. Queue rows C318–C325

ID allocation is **correct**: prior max was C317 (relconic handoff
`notes/handoffs/2026-07-17-c210.md` and the queue archive both contain C313–C317; nothing
above), so C318–C325 are fresh and the "Max allocated ID: C325" update is right. The old
"Max allocated ID: C285" line was stale before this diff; the diff fixes it.

Per row, against the portfolio review's §6 work order:

- **C318** `[alt-orbit-repair]` — manifest rows for the residual layer. Follows from review
  items 3/§5.4; correct lane; matches the real gap found in §2–3 above (the residual trees
  are indeed undocumented in the arcs manifest). Sound.
- **C319** `[alt-orbit-repair]` GATED — canonicalizer decision after measured C151 cost.
  Mirrors review item 8, including the do-not-schedule-early gate. Sound.
- **C320** `[clebsch]` — Clebsch manifest. Follows review item 3 ("Clebsch first"). Correct
  lane. **Contains the false parenthetical** about Dye (§1); fix to "Dye appears in no
  manifest under `lean/`; the axioms themselves are stated in
  `RelativeConicArcs/Q11DyeAxioms.lean`".
- **C321** `[clebsch]` — replace load-bearing Singular evidence. The lane peg is
  questionable: the review attributes the Singular cofactor-certificate work to
  **C210/layered-arcs** (review §3 at line 122 and §6 item 6), which routes to the
  `relconic` lane, while Clebsch's inventory ("one Singular computation") is explicitly
  marked unverified in the review (§1 at line 49). As written, C321 either annexes relconic
  work into clebsch or silently narrows to the one unverified Clebsch computation. Split or
  re-peg before scheduling.
- **C322** `[dihedral]` — solver-independence audit + mutation tests. Mirrors review item 5
  precisely; correct lane. Sound.
- **C323** `[crowns]` URGENT — commit/close the untracked C294 bundle. Matches review item 1
  and the actual `??` files in git status (verified: all six `2026-07-17-c294-*` files are
  untracked). Correct lane. Note the review's item 1 pairs this with the untracked Q25
  residual layer, which has no analogous row — presumably covered by ACTIVE C151, but if
  C151 closes without committing `Q25ResidualConclusionDispatchData/` etc., nothing tracks
  it.
- **C324** `[build-sys]` — regeneration pass before C287 extraction. Mirrors review item 4;
  build-sys owns build orchestration; the "hashes prove identity, not regeneration" phrasing
  matches both the review and the new TRUST.md section. Sound.
- **C325** `[complete-ports]` — consolidated verifier + per-theorem evidence-mode ledger.
  Mirrors review item 3 ("ports") and §3's mixed-verification policy; correct lane. Sound.

No duplicates found against existing queue rows (the closest, C287, is explicitly sequenced
after C324 rather than duplicated).

## 7. Everything else in the diff

- `lean/NodeKayles/TRUST.md` is a faithful move of the old `lean/TRUST.md` content with only
  a scope header added; spot-checked against the committed file — no content drift noticed.
- `lean/README.md` scope note is accurate (the file below it is indeed NodeKayles-only) and
  the `TRUST.md` pointer resolves.
- The `RowConclusion.lean` change is uncommitted C151 work in the same worktree as the docs
  commit. If the doc changes are committed while this is not, `lean/TRUST.md`'s Q25 row
  (§2) and the README's residual consumer rows (§3) describe partly uncommitted structure.
  Sequence the commits, or hedge those two spots to the committed state.

## 8. Verified vs not checked

Verified directly: existence of all cited files/directories/gates/links; the four-axiom
inventory and absence of `sorry`/`native_decide` (string-level, whole `lean/` tree); manifest
support for every summary-table and named-inputs row; one-level import relationships behind
every consumer claim; docstring headers in sampled leaves of nine data trees; queue ID
history; untracked-file status.

Not checkable here: any actual kernel-checked status (no builds run — manifests' axiom
audits are self-reports); transitive gate closures (notably whether `Gates/Baer` covers the
full BaerCompletion audited set); whether the Q16/pair data trees are byte-reproducible from
their external generators; whether any committed residual-layer theorem matches "the
residual lower bound for normalized rows".

## 9. Keeping the trust docs and the proof spine in sync (requested)

The failures found above are all of one kind: hand-maintained prose restating facts the
tree already knows (axiom inventory, consumer edges, data-tree headers, gate closures).
The durable fix is to make the tables generated and the prose hand-written, with a drift
check that fails loudly — the same `--check` discipline the repo already mandates for
certificate data. Concretely:

1. **One machine-readable spine file per area** (`trust.json`/`trust.toml` beside each
   manifest): terminal theorem names, gate module, permitted axiom set, data trees with
   generator path + payload hash, named classical inputs with their entry mode
   (hypothesis / axiom / consistency-check). The markdown tables in `lean/TRUST.md` and the
   per-area manifests are then generated between markers from these files; prose sections
   (contract, kernel feasibility, reading guidance) stay hand-written.
2. **Extract ground truth from Lean, not from memory.** A small script (a Lean metaprogram
   run per gate, or even a parser over `import` lines plus `#print axioms` output captured
   during the gate build) emits, for each gate target: the transitive module list, every
   `axiom` declaration in the closure, and the axiom set of each named terminal. Diff that
   against the spine file in `--check` mode. This mechanically catches every §1-class
   omission: an undeclared Dye-style axiom anywhere in a closure fails the check the day it
   lands.
3. **Kernel-checked axiom guards.** Each gate can carry a companion `Guard` module with a
   `run_cmd`/`#guard`-style assertion that each terminal's `#print axioms` set equals the
   expected list (this is cheap elaboration, not proof work). That converts the "Axiom
   position" section from a prose claim into something the build enforces, and it rides the
   existing queue/gate discipline with no new infrastructure.
4. **The referee-facing dependency graph** (requested): generate it, don't draw it. Import
   lines are syntactically first in every file, so a dumb parser suffices; per gate, emit a
   DOT/mermaid graph with three node classes matching the README's layer model — semantic
   modules, checkers, and each `*Data/`/`*Rows/` tree **collapsed to a single node**
   annotated with file count, generator path, and payload hash. Edges are imports; the
   collapsed data nodes point at their consuming checker, which makes the §3 consumer table
   generated rather than inferred. Mermaid renders natively in repo-hosted markdown and in
   Artifacts, so the same generated block serves the manifest and a referee-facing HTML
   page. Regenerate in the same `--check` pass as (2); a consumer edge that disappears
   (like `Q25ResidualConclusionData` today) becomes a visible dangling node instead of a
   stale table row.
5. **Ownership and cadence.** The generator and check belong to the `build-sys` lane (it
   already owns import-graph tooling per the workspace guide); run the check inside every
   gate build window and as part of C324's regeneration pass. Uniform data-tree headers
   (the §3 `DO NOT EDIT` gap) should be an acceptance rule enforced by the same check: a
   listed data tree without a parseable generator/hash header fails.

Start with (2)+(4) for RelativeConicArcs only — that alone regenerates the two tables that
were wrong in this diff and renders the graph the referee needs; (1)/(3)/(5) can follow as
C318/C324-adjacent work.
