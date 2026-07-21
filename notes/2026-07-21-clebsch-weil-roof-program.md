# Weil-roof execution program

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** design document, pre-allocation. No task below is allocated. Execute Phase 0 before any
other phase. Source dossier:
[`2026-07-21-clebsch-weil-roof-conversation-report.md`](2026-07-21-clebsch-weil-roof-conversation-report.md).

**Intended executor:** Opus-level sessions/sub-agents for all computational, literature, and
writing tasks; escalate to Fable only at the marked verification/judgment gates and for any
genuine proof attempt. Sub-agents write their reports directly to dated `notes/` files and return
paths, not transcripts.

## Cold-start context load (every executing session)

Read, in order, nothing else: (1) this program; (2) the source dossier above; (3) only the
per-task inputs named in the task spec being executed. Do not preload the manuscript, archives, or
other lanes' handoffs.

## Phase 0 — governance (one session, first)

1. Allocate a contiguous C-ID block for the Phase 1 battery from the repository root:
   `python3 notes/scripts/allocate_codex_task_ids.py reserve --count <N> --lane crowns
   --purpose 'Weil-roof verification battery'`. Commit the ledger before dispatch. Never derive
   IDs from text; never reuse.
2. Enter allocated rows in the live queue with `[crowns]` pegs, one row per task below.
3. Standing rules for every task: evidence bundle = dated report + exact script + canonical
   JSON + sha256 manifest, committed together; deterministic enumeration, no timestamps; an
   independent replay or a stated reason none exists; frozen inputs referenced by SHA (C406 Gate-1
   conventions and the C406/C411/C412 certificates are the ground truth); changed paths must stay
   inside `notes/`. The manuscript and `papers/` are out of scope for the entire program.
4. Every task that words a novelty or absence claim follows
   `notes/literature-audit-conventions.md`. All citations in the dossier are unverified model
   memory: resolving each load-bearing one (DOI/arXiv ID, then cache via litcache) is part of the
   consuming task, not optional. Zero-citation or absence findings need three graphs (OpenAlex,
   Crossref, Semantic Scholar).

## Phase 1 — verification battery

Ordering respects information-per-hour and dependencies. T1–T5 are the decisive week. Each spec:
**Goal / Method / Deliverable / Falsifier / Model**.

**T1 — spin-prime covariation (sheets = primes above q).**
Goal: verify the sheet labeling and the sign of `mu_3` covary with the choice of `sqrt 5` in
`F_11` (4 vs 7), and the B3 analogue with `sqrt 2` in `F_7`; exhibit the bijection
{sheets} ↔ {primes above q} in `Z[φ]` resp. `Z[sqrt 2]` via the trace data of order-5/order-4
elements. Method: rerun the frozen C406 constructions under both square-root conventions; exact
arithmetic only. Deliverable: certificate + short theorem statement ("the chirality torsor is the
Kummer torsor of the spin discriminant"). Falsifier: labeling fails to covary ⇒ the arithmetic
identity dies; record and stop the arithmetic strand's dependents (T10, row 5 of the table).
Model: Opus.

**T2 — split-Coxeter-torus mechanism.**
Goal: show the marker embedding sends the Coxeter element's rotation part to a split-torus
generator of `PSL_2(q)` for A3/B3/H3; record the `2 + (q−1)` orbit structure on the conic.
Method: conjugacy check in the frozen generator data. Deliverable: certificate + a mechanism
remark for C399. Falsifier: image lands in a nonsplit class ⇒ the mechanism claim dies (the law
q = h+1 itself is untouched). Model: Opus.

**T3 — Weil decomposition of the cross-sheet module.**
Goal: decompose the `PSL_2(11)`-module structure of the 11×11 cross-sheet incidence (both
relations), same at q=7, and test the identification with the `(q−1)/2` / `(q+1)/2` Weil
components; verify the character-field statement (`Q(sqrt −11)` at q=11) and that the outer swap
exchanges the components. Method: exact character/idempotent computation over suitable fields;
compare against the standard Weil-representation character (verify the reference first).
Deliverable: certificate + verdict on roof sub-statement (a). Falsifier: decomposition does not
match the Weil components ⇒ the roof's sharpest clause dies; the conjecture reverts to its weaker
form. Model: Opus; **Fable gate** on the module-identification verdict.

**T4 — Roquette curve: Lagrangians, supersingularity, theta parity.**
Goal: (i) certify matchings ↦ Lagrangians in `J[2]` (even-subset model) and sheets ↦ Lagrangian
packings of the 66 Weierstrass classes; (ii) compute the Cartier–Manin matrix of
`y^2 = x^q − x` for q = 5, 7, 11 and settle supersingularity; (iii) compute the Arf/theta parity
of the two sheet packings against the canonical hyperelliptic theta structure and report whether
the parity separates the sheets. Method: exact F_2 linear algebra for (i)/(iii); exact
characteristic-q polynomial coefficients for (ii); verify the theta-characteristic combinatorial
model against a standard reference before use. Deliverable: certificate; if (iii) separates,
draft row 6 of the Rosetta table. Falsifier: parity fails to separate ⇒ row 6 dies cleanly (five-
row table); record the negative exactly. Model: Opus; **Fable gate** on the theta-model setup
before computation.

**T5 — QR/Barker identifications and the impossibility wall.**
Goal: certify the disjointness designs as QR difference sets; the Legendre-sequence/Barker
identifications at lengths 7 and 11; resolve and cache Turyn–Storer, van Lint–Tietäväinen,
Leemans–Schulte; state the three-wall table with exact provenance. Method: small exact checks +
literature resolution per conventions. Deliverable: certificate + provenance note feeding the
cliffhanger's beat 3. Falsifier: any identification fails ⇒ amend the corresponding claim; the
wall table shrinks. Model: Opus.

**T6 — law evaluations at 13, 19, 31 and the H4 gate.**
Goal: evaluate the spin-field law blindly at the predicted continuations (record `31 ≡ 1 mod 5`
splits in `Z[φ]`; work out what the law's inputs would have to be at q=13 and 19, including which
parent/spin field is even meaningful); bound what "H4 marker stabilizer in `PSL_2(31)`" would
mean and whether any part is decidable by order/character arithmetic now. Deliverable: a bounded
prediction note (feeds cliffhanger beat 2); explicitly labels everything conditional. Falsifier:
none (this task only sharpens predictions); it must not silently become construction work.
Model: Opus.

**T7 — Klein-invariant probe.**
Goal: decompose the H3 quotient module `W` over char 0 and `F_11` as a `PSL_2(11)`-module;
determine the relationship (if any) between the relative-cubic space and the 5-dimensional
component's Adler cubic; settle why the relative-invariant dimension is 3 in both B3 and H3 by a
character computation. Deliverable: certificate; positive or sharp negative both feed paper 2
scoping. Model: Opus; escalate to **Fable** if an equivariant map candidate appears.

**T8 — C372/C378 reread as Weil fixed point.**
Goal: bounded rereading of the C372/C378 certificates to state precisely which discrete Fourier
operator is self-dual and whether it is (a conjugate of) a Weil-representation operator.
Deliverable: two-page note; roof sub-statement (c) verdict. Model: Opus; **Fable gate** on the
verdict wording.

**T9 — AME chirality pair.**
Goal: determine whether the two chirality-conjugate AME(6,11) states are LU-equivalent (the
party-permutation trap is the first check); if inequivalent, find the lowest separating
LU-invariant degree. Deliverable: certificate + a recommendation (quantum row vs labeled/advice
framing). Model: Opus.

**T10 — quaternion-order reduction (conditional on T1 passing).**
Goal: certify that reducing the icosian / binary octahedral maximal orders at the two primes
above q yields the two sheet embeddings, in the exact frozen conventions. Deliverable:
certificate; upgrades the T1 theorem to its structural form; reframes C382's negative.
Model: Opus.

## Phase 2 — cheap theorems and framing notes (parallel to late Phase 1)

Each is a writing task with a bounded literature audit; no new computation beyond small checks.

- **P2a — equivariant advice complexity.** Definitions + theorem (complexity exactly one) from
  C413/C417/C379; symmetry-breaking and access-structure corollaries; the PIR/service unification
  remark (C369/C391/C392 cited, not imported).
- **P2b — exactly solved low-degree threshold.** The KWB-frame statement of
  C406/C409/C430/C412, with the bounded audit that no exact finite instance exists in that
  literature (three-graph rule applies to any absence wording).
- **P2c — Chentsov/Amari–Chentsov framing.** The two-tensor statement; the pure-third-order
  interaction claim in Amari mixed coordinates; compute the KL of the bit exactly.
- **P2d — fold-over/DoE translation.** Resolution-III / minimum-aberration / strength-2
  orthogonal-array dictionary, connected to the Bamberg–Klawuhn frame already in the audit.
- **P2e — positioning paragraph pack.** Covering radius/deep holes, equivariant list structure,
  quantified isospectrality — one paragraph each with verified citations.

## Phase 3 — synthesis and paper-facing gates (Fable)

1. **Battery synthesis review (Fable).** Read all Phase 1/2 deliverables; assemble the Rosetta
   table with per-row status (proved / checked / dead); state the sheet-reciprocity verdict: do
   the surviving identities (T1, T4, `mu_3`) agree canonically, agree by computation only, or
   disagree? This is the load-bearing judgment of the program.
2. **Ending design freeze.** Produce the recommended closing-section draft (table + three-beat
   cliffhanger calibrated to what actually landed; the dossier's draft paragraph is the template,
   rewritten to the surviving evidence). Deliverable: a design note. **This note is advisory: the
   manuscript decision and any edit belong to the `clebsch` lane and its handoff process.**
3. **Program disposition.** Close or re-scope every register item (dossier §13) with an explicit
   verdict; append incidental observations to the lane's discovery log per conventions; update
   the crowns handoff; archive completed queue rows per the completion invariant.
4. **Paper 2 go/no-go (Fable).** If roof sub-statements survived: scope the metaplectic paper
   (canonicity theorem target, mechanism section from T2, continuation section from T5/T6) as a
   new allocation request. If the roof died: scope the refutation/boundary note instead. Either
   way the verdict is written before new generative work is permitted.

## Standing prohibitions

- No new generative/brainstorming passes until Phase 3 item 1 is complete.
- No manuscript, `papers/`, or Lean edits from this program; Lean formalization requests are
  handed to `build-sys`/paper lanes as proposals only.
- No unallocated work: an interesting lead found mid-task goes to the discovery log, not into the
  task.
- No absence claim without its audit; no citation used before it is resolved and cached; treat
  every dossier citation as unverified until then.
- Vibe reports and `go` lines per house convention at each substantial stop.
