# Clebsch: Rigidity from Sparse Shadows

**Lane:** `clebsch`

**Date:** 2026-08-15

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> five-paper numbered series plus its research-only successor tracks.
> Per-task detail belongs in the task cards under `notes/clebsch-tasks/`;
> proof-level detail belongs in the dated notes those cards link to;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Formal standard for the whole series

Every numbered paper meets the same Lean standard. Paper III is held to exactly
what Papers I and II are held to, with no per-paper exception and no clause
exempted for being classical, cited, or expensive:

- no `sorry` anywhere in a paper's closure;
- no `native_decide` and no compiled-evaluation axiom at any terminal, checked
  by replays that refuse it rather than declared as a boundary;
- no project axiom and no assumed hypothesis standing in for a proof, the way
  the Dye inputs once stood in for Paper I's order-eleven classification;
- every mathematical assertion of the manuscript maps to a kernel-checked
  declaration, so no ledger row may sit permanently at partial coverage.

A manuscript step whose proof is a literature citation is not outside this
standard. It is closed by proving the statement in the form the manuscript uses
it, in whatever weaker form suffices, rather than by importing the cited theorem
in full generality. Gaps are closed by strengthening the Lean side; no
manuscript claim is narrowed to make the formal surface agree with it.

Each split paper owns its statement identity, claim manifest, aggregate gate,
replay entry point, toolchain pins, adequacy appendix, and AI/provenance
disclosure. Shared Lean sources stay in the pinned standalone Lean repository.
An immutable public locator and fresh isolated replay are release requirements,
not substitutes for a paper's local gates.

## Numbered series decision

The public series is *Clebsch: Rigidity from Sparse Shadows* and has exactly
five numbered papers:

1. Paper I — `clebsch-rigidity`;
2. Paper II — `clebsch-factorization`;
3. Paper III — alias `passages`, rooted at `clebsch-passages`;
4. Paper IV — alias `q13-passant-code`, rooted at `q13-passant-code`;
5. Paper V — *Chordal and Conference Cubics: Reconstruction and a Residual
   \(C_2\)-Torsor*, rooted at `papers/chordal-conference-reconstruction/`.

The numbered-paper streams are concurrent. An explicit selector such as
`go clebsch paper I`, `go clebsch paper III`, `go clebsch paper IV`, or
`go clebsch paper V` selects only that paper's stream; it does not pause,
reorder, or absorb work in the other papers. An unqualified `go clebsch` with
no carried task or paper selection must ask which paper stream the user wants.

`golden` is a separate source-development lane and unnumbered companion, not
Paper V (the C704–C710 post-700 development moved there by explicit
2026-07-31 decision; entry handoff `notes/handoffs/2026-07-31-golden-operator-paper.md`).
The MDS–CSS and Paper-I computational companions are likewise unnumbered. The
37-page mega-paper (`papers/clebsch-code/`) is a preserved fallback only,
reactivated solely by explicit user decision (C552).

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | GitHub/DOI v1 and v2 released; C855 owns a fresh q11 replay and repair of a MAJOR-verdict trust/release audit before the next release is called theorem-complete; C929 generalized the node classification off characteristic zero, and C932 generalized the Hessian and ordinary-node chain to the same range, with an exact bad-characteristic criterion and a shared `ZMod 11` specialization; the manuscript's "characteristic zero" sentences remain open | [C855](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md); [C929](../clebsch-tasks/c929-node-classification-characteristic-generalization.md); [C932](../clebsch-tasks/c932-golden-cubic-hessian-characteristic-generalization.md) |
| Paper II — *Quadratic trade rigidity and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | GitHub/DOI v1 and v2 released; manuscript/human-proof/export stream complete; C892 owns remediation of a MAJOR/NO-GO formal/trust audit before any public forward release | [C892](../clebsch-tasks/c892-paper-ii-lean-trust-boundary-review.md) |
| Paper III (`passages`) — *Golden descent and operator realizations of the Clebsch cubic* | `papers/clebsch-passages/` | GitHub/DOI v1 and v2 released unchanged; C815's three gates are green with no compiled-evaluation axiom; C916 landed the compact-incidence and Stein-normality referee corrections in authority `d4c535c8f` and standalone `6b38a86`; the release aggregate is red only at the pre-existing "Paper III" README vocabulary gate, which needs an owner; remaining Paper III route work is the arithmetic, orientation, and harmonic gap-class rows before C823 | [C815](../clebsch-tasks/c815-four-shadow-lean-formalization.md); [C897 dossier](../clebsch-tasks/c897-paper-iii-reviewer-dossier.md) |
| Paper IV — *Reconstructing \(\operatorname{PG}(2,13)\), its conic, and polarity from the minimum words of a binary conic code* | `papers/q13-passant-code/` | manuscript-only standalone pre-release published 2026-08-03, DOI `10.5281/zenodo.21783971`; Lean companion excluded, due as a forward version | [C834](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md), then [C857](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md); [C901](../clebsch-tasks/c901-paper-iv-reviewer-dossier.md) |
| Paper V — *Chordal and Conference Cubics: Reconstruction and a Residual \(C_2\)-Torsor* | `papers/chordal-conference-reconstruction/` | publishable structural authority; five standalone mirrors synchronized, nothing pushed; original relative Chow crown quarantined as C908; Lean deferred by user instruction; summary-index links, repository link, and DOI badge repaired by C918, which leaves one user decision open: re-release so the stale Zenodo record stops carrying the paper's former title (C919 settled the epigraph question by moving the poem into the coda); C926 certified the mod-11 node count and C927 then proved it structurally in every characteristic outside \(\{2,3,5\}\) with five a square, leaving the manuscript placement and mirror propagation to the user | [C904](../clebsch-tasks/c904-paper-v-publishable-round-trip.md); [C918](../clebsch-tasks/c918-summary-paper-v-links-and-series-epigraph.md); [C926](../clebsch-tasks/c926-paper-v-conference-node-completeness.md); [C927](../clebsch-tasks/c927-determinantal-node-count.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

All five manuscripts carry the same front matter and closing apparatus since
C919 (2026-08-19): no series banner, Roman number, or epigraph on page 1, and
an unnumbered `Clebsch: Rigidity from Sparse Shadows` coda after the
mathematical conclusion holding the poem, the programme map, and the paper's
place in the programme. The convention is recorded in `papers/style-guide.md`;
the per-paper detail is in `../2026-08-19-c919-series-apparatus-completion.md`.
Every forward release of any of the five must carry it.

Local aggregate replay per paper root:

```sh
cd papers/clebsch-rigidity && nix develop --command python3 verification/verify_release.py --lean-root /absolute/path/to/finitegeom-clebsch-q11-certificates
cd papers/clebsch-factorization && python3 verification/verify_release.py
cd papers/clebsch-covers && ./scripts/verify-all.sh   # Paper III
```

### Deterministic Paper III route

`go clebsch paper III` means: take the first unfinished task in this exact
conflict-safe sequence — C799 (freeze aligned-design API) → C815 (four-shadow
recognition) → C823 (robustness/distance/moment) → C800 (remaining operator
identities, manifest reconciliation) → C816 (integrate four-shadow into
manuscript) → C824 (integrate robustness, final trust/release pass). Skip
completed tasks, do not bypass an unfinished predecessor. Paper I and Paper IV
continue concurrently under their own explicit selectors.

## Research-only successor tracks

**C907, C908, C909, C910, C911, and C914 moved to the new `cubic-threefolds`
lane on 2026-08-15** (entry handoff `notes/handoffs/2026-08-15-cubic-threefolds.md`,
task cards under `notes/cubic-threefolds-tasks/`). C908 is a direct successor
of C904's Annals-upgrade frontier (below) — expect the two lanes' research to
stay in close contact even though they route separately.

- **C904 — Paper V Annals-upgrade frontier, active.** The relative Shen-cycle
  descent gate (fixed-fibre lifting is closed; Shen's cycle is existential
  rather than horizontal) is the exact obstruction. Many routes are now
  closed dead (six-axis norms, Bridgeland/anticanonical `M9`, EFS/Kunneth
  shortcuts, genus-one support, cohomological shortcuts); the live exits are
  an intrinsic relative cycle, an odd-degree complete half relation, the
  exact even descent index, or a non-tautological correspondence
  geometry/proper boundary theory for `M_9`. Card:
  [`c904-paper-v-publishable-round-trip.md`](../clebsch-tasks/c904-paper-v-publishable-round-trip.md).
- **C905 / C906 — closed.** C905 (cross-series reconstruction-profile
  theorem) closed in `../2026-08-10-c905-reconstruction-profile-theorem.md`.
  C906 (exceptional-tower judo, research-only) closed in
  `../2026-08-10-c906-exceptional-tower-judo.md`: the unmarked fold/tower is
  classical, the surviving theorem is an exact sparse marked entry through
  the `E_6` carrier; its arithmetic-lift frontier is literature-gated and not
  promoted to any manuscript or Lean source.

No C904, Chow, manuscript, PDF, mirror, or Lean promotion
between these tracks or into the numbered series follows automatically from
any of the above.

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C943 — conventional terminology across the Clebsch and conference papers](../clebsch-tasks/c943-series-conference-terminology.md) | active; occurrence classification and semantic red-team complete; no manuscript edits yet | revise Paper I, pass its local gates, and obtain the first independent cold-referee verdict before proceeding paper by paper |
| [C855 — Paper I Lean referee-artifact standards remediation](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md) | active; authority repair, exact 51-terminal rigidity and 24-terminal orientation facts, guarded replays, and exporter-only finitegeom adoption complete | resume theorem-completeness, correspondence, distribution, and release closure |
| [C800 — Paper III operator and formal-release closure](../clebsch-tasks/c800-paper-iii-operator-formal-release-closure.md) | fourth Paper III route task; wait for C799/C815/C823 source freezes | formalize retained identities, reconcile Paper III formal maps onto one source closure |
| [C815 — four-shadow Lean formalization](../clebsch-tasks/c815-four-shadow-lean-formalization.md) | reopened; all three gates green with no compiled-evaluation axiom; four-shadow recognition and aligned-design faithfulness formalized | formalize gap class B (arithmetic, orientation, harmonic rows) and the reduced weighted-Jacobian bridge, then hand the API to C823 |
| [C816 — Paper III recognition audit and Theorem D promotion](../clebsch-tasks/c816-paper-iii-four-shadow-integration.md) | rescoped 2026-08-19; the C809 integration and the table (5.1) correction are landed in the manuscript; all five work items closed 2026-08-20; the paper-local gates and the release aggregate pass at thirty-eight pages | run the review gates the card lists: theorem-level red team, Milnor--Serre pass, fresh cold read and regrade, then downstream synchronization |
| [C823 — aligned-certificate robustness Lean](../clebsch-tasks/c823-aligned-certificate-robustness-lean.md) | next Paper III route task; C799/C815 APIs and C822 human compression frozen | formalize distance polarization, parity, bowtie equality, conference balance, moment recurrence in the shared API |
| [C824 — Paper III aligned-certificate upgrades](../clebsch-tasks/c824-paper-iii-aligned-certificate-upgrades.md) | sixth and final current Paper III route task; begin after C816; manuscript promotion authorized | select smallest A/B architecture, integrate robustness/order-26 results, final trust reconciliation and release gates |
| [C880 — aligned-design query complexity](../clebsch-tasks/c880-aligned-query-complexity.md) | active; math/computation only; adaptive constant closed exactly at 1/2; nonadaptive bracket narrowed 2026-08-19 to 0.616n^2 against (9/8)n^2, with both natural lower-bound routes closed for stated reasons | a lower bound from the alignment code's distance distribution, the only mechanism ever tight here; `g(8)` is bracketed 15 to 17 |
| [C862 — Paper III ceiling and theorem-upgrade research](../clebsch-tasks/c862-paper-iii-ceiling-upgrade-research.md) | active advisory research; theorem packet delivered, no manuscript edit | test characteristic three against the split Mukai–Umemura model over `Z[1/10]`; keep open |
| [C761 — Paper IV q13 passant code](../clebsch-tasks/c761-paper-iv-q13-passant-code.md) | active; structural manuscript and local release green; public release blocked on C834 | after C834, pin the public package, run isolated replays, seek publication authority |
| [C901 — Paper IV reviewer dossier and cold-review programme](../clebsch-tasks/c901-paper-iv-reviewer-dossier.md) | active standing programme until explicit author closure | layered-exposition pass, then a C894-style pre-draft matrix for the four core frame-correspondence claims |
| [C834 — Paper IV full Lean release closure](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md) | active; 77 of 88 audit terminals clean | close remaining native decisions (weight-ten profile shards, automorphism anchors, fixed-point exhaustion), then build release surfaces |
| [C857 — Paper IV Lean standards closure](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md) | queued after C834 | consume C834's API, close every trust/statement/transcript/provenance gap, run the rejecting release verifier |
| [C892 — Paper II Lean and trust-boundary review/remediation](../clebsch-tasks/c892-paper-ii-lean-trust-boundary-review.md) | reopened by explicit user instruction; prior MAJOR/NO-GO report is the acceptance baseline | close cheap trust-boundary defects, freeze manuscript-level formal interfaces, prove every remaining assertion |
| [C682 — Hitchin–Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active; exact optimal finite code ladder `E_8:[120,9,56] -> E_7:[28,7,12] -> E_6:[27,6,12]`; Paper-IV reconstruction ladder complete; first unrestricted column-completion gate is impossible | user decision: signed 56-root phase fold, affine `E_9/E_10` transfer lift, optional preprojective successor, or promote the code ladder |
| [C756 — all-k conic-filling classification](../clebsch-tasks/c756-all-k-conic-filling.md) | active open math; `k=12,13,14` layers impossible over every finite field; `q=25,27,81` closed by an exhaustive coherence census through `q<=127` and `q=169` | compute the `AGL(1,q)` coherence spectrum in closed form and attack its 4/3 clique-bound shortfall, or prove the determinantal/quadratic saturated gates |
| [C894 — unnumbered saturated-exterior/local-Paley companion](../clebsch-tasks/c894-saturated-exterior-paley-companion.md) | active; claim–proof–citation matrix frozen; no manuscript exists | send narrowed institutional-index and external-specialist packets, record verdicts, decide title/venue |
| [C811 — quadratic-twist specialization](../clebsch-tasks/c811-quadratic-twist-specialization.md) | queued; math only, paper promotion excluded | stress-test the fibre-recovery claim, delimit standard Kummer precedence |
| [C813 — harmonic restriction generalization](../clebsch-tasks/c813-harmonic-restriction-generalization.md) | queued; math only, paper promotion excluded | compute bounded `A_5`-branching, Petersen-channel eigenvalues, exact restriction scalars |
| [C896 — corrected universal finite-group socle theorem](../clebsch-tasks/c896-corrected-universal-socle-theorem.md) | queued future mathematics; independent of Paper II | run `q=9,25` and exponent-three reconnaissance, then attempt a carry/borrow theorem only if the data support one |

C756 optional stuck-state/review reading:
[`c756-proof-expert-dossier.md`](../clebsch-tasks/c756-proof-expert-dossier.md).
C682's dense working record is a separate lookup surface, not this table:
`2026-07-13-clebsch-c682-archive.md`.

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation.

Every card in `notes/clebsch-tasks/` not listed above (C577, C713, C714,
C751–C753, C762–C764, C703–C712, C721–C726, C730, C733, C744–C750, C792,
C797–C803, C809–C810, C812, C822, C831–C832, C856, C860, C863, C875,
C895–C898, C902–C903, C905–C906, C911) is complete or superseded; see the
card itself or the archive for closure detail — none is a live frontier.

## Released-paper corrections and novelty tracks (C866–C878, need cards)

The exceptional-code-ladder cluster below still has no task card of its own — a
lane-hygiene gap, not a routing decision. Until a card exists, the pointer is
authoritative; do not re-derive it from git history.

- **Released-paper corrections (C876, C877, C878) — applied and verified
  2026-08-19; nothing owed in any manuscript.** Paper III's benchmark sentence
  and two-graph attribution landed in `efc76fb98` and `a9f14ebf6`
  (`papers/clebsch-passages/sections/05-golden-operator.tex`), the same
  attribution repair landed in Paper I, and Paper IV now credits Madison–Wu's
  module theorem at the published pinpoints Theorem 5.1(i) and Corollary 5.4
  (C877's report quotes the arXiv preprint numbering 6.1(i)/6.3; C901's
  2026-08-09 audit reconciled the two). Two residuals, neither a manuscript
  edit: the C878 certificate pins a SHA-256 of `05-golden-operator.tex` that
  drifted in `b19233879`, so
  `notes/2026-08-05-c878-aligned-faithfulness-independence.py --write` plus a
  refreshed `.sha256` is owed once C919's page-1 de-branding settles — its
  mathematics replays green; and C876's "biangular tight frame" citation and
  `2-(10,5,16)` enumeration items belong to the golden-operator programme, not
  to any Clebsch manuscript. The standing bounded negative is unchanged: the two
  Seidel two-graph surveys remain unobtained, as `literature-boundaries.md`
  records.
- **Exceptional code ladder (C865–C875).** Research track, no manuscript.
  Novelty is largely dissolved — do not start a manuscript on this track; the
  tower `120-56-28-27` is classical (Gosset/Schlafli/E6 graphs), and the fold
  is Brouwer–Shult 1990. Two narrow live frontiers remain: the parabolic
  deficit (unexplained, grows 0 at rank five to 4 at rank nine) and whether
  120 points of `PG(8,4)` sit in four-general position under a large proper
  subgroup of `O_8^+(2)` (not expected to work). Reports:
  `../2026-08-05-c682-e8-root-pair-ladder.md`,
  `../2026-08-05-c865-e9-affine-level-code.md`,
  `../2026-08-05-c867-ladder-record-attack.md`,
  `../2026-08-05-c866-exceptional-code-ladder-literature-audit.md`,
  `../2026-08-05-c869-paper-iv-series-literature-audit.md`,
  `../2026-08-05-c871-fold-tower-literature-audit.md`.

Next lane-hygiene step: allocate one card for the exceptional-code-ladder
cluster — do not split it into one-line cards — and retire this section.

## Companion-export chain

Paper III's formal companion export (`lean/trust/export/clebsch_passages.toml`)
is blocked by drift in the canonical base, not by anything Paper III owns:
`TARGET_MANIFEST.json` in `~/src/lean/finitegeom` disagrees with its own tree
at four paths because three base commits landed without resealing it. Every
companion export refuses until the base is resealed — raise the reseal before
the next export of any area.

## Lane boundaries

This lane owns the five Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, golden, crowns, or (as of 2026-08-15)
`cubic-threefolds` work. Cross-lane results are
read-only until an owning split-paper task explicitly admits them.

The companion discovery log is `notes/2026-07-14-clebsch-discovery-track.md`.
Logging an observation neither allocates work nor adds it to a paper.

## Working and historical indexes

- Trilogy venue strategy:
  `../2026-07-30-clebsch-trilogy-venue-strategy.md`.
- Live task detail: `notes/clebsch-tasks/`.
- C682 thematic lookup and chronology: `notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
- Full accumulated handoff history: `notes/handoffs/done/2026-07-13-clebsch-lane-archive.md`.
- Retired mega-paper planning redirect: `notes/2026-07-20-clebsch-paper-planning.md`;
  full superseded record: `notes/2026-07-20-clebsch-paper-planning-archive.md`.
- Mega-paper independent cold read: `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
