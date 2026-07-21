# Weil-roof execution program

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** design document, pre-allocation. No task below is allocated. Execute Phase 0 before any
other phase. Source dossier:
[`2026-07-21-clebsch-weil-roof-conversation-report.md`](2026-07-21-clebsch-weil-roof-conversation-report.md).
Updated 2026-07-21 (same day): Phase 1a inserted as the critical path, de-risking the
master stroke of
[`2026-07-21-clebsch-master-stroke-integral-golden-model.md`](2026-07-21-clebsch-master-stroke-integral-golden-model.md);
T1 is absorbed into M2; T10's gate moved to M2; Phase 3 gains the promotion gate. Second
same-day update: Phase 1b (cap-bridge chain, register rows 35–38) added as a parallel
non-blocking track with explicit cross-lane hygiene.

**Intended executor:** Opus-level sessions/sub-agents for all computational, literature, and
writing tasks; escalate to Fable only at the marked verification/judgment gates and for any
genuine proof attempt. Sub-agents write their reports directly to dated `notes/` files and return
paths, not transcripts.

## Cold-start context load (every executing session)

Read, in order, nothing else: (1) this program; (2) the source dossier above; (3) only the
per-task inputs named in the task spec being executed. Do not preload the manuscript, archives, or
other lanes' handoffs.

## Executor guardrails (Opus-level execution)

These rules bind every task below and exist so that execution does not require judgment calls.

1. **Compute, never recall.** Any classical formula, coordinate system, character value, or group
   fact used in a certificate must first be *verified by direct computation inside that
   certificate* (e.g., check a claimed invariant form is actually invariant under the frozen
   generators; derive character data from the group, not from memory). A formula from model
   memory or from this program's prose is a hypothesis until computed. This applies to the
   candidate objects this program itself names.
2. **One convention set, frozen first.** No M- or T-task may introduce coordinates, labelings, or
   projectivities of its own. All consume the M0 conventions artifact. If a task cannot proceed
   under the frozen conventions, that is a blocker (rule 3), not a license to re-derive.
3. **Stop-and-escalate triggers.** Halt the task, write a dated blocker note stating exactly what
   was observed, and queue Fable review — do not improvise a fix — when any of these occur:
   a denominator at 11 (resp. 7, 5) appears in an integral construction; a claimed bijection is
   not a bijection; an orbit or fibre size differs from the spec's expected value; any output
   contradicts a frozen C-certificate; a convention change looks necessary; a literature claim
   fails verification. Partial certificates up to the blocker are committed, clearly marked.
4. **Acceptance criteria are literal.** Each task's Deliverable lists objects/numbers that must
   appear in the canonical JSON. A task without its acceptance objects is not done, regardless of
   prose in the report.
5. **No scope invention.** A promising lead mid-task goes to the lane's discovery log with one
   line; the task's spec is the whole task. Escalation paths: formulation questions → the task's
   Fable gate; everything else → the Phase 3 synthesis review.

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

## Phase 1a — master-stroke chain (critical path, run first)

De-risks the integral golden model claim by claim, cheapest and most load-bearing first. Same
evidence-bundle rules as Phase 1. Risk register mapping: R1 bijection/twist → M1; R2 singleton
identification → M2; R3 denominators at 11 → M3; R4 char-0 lift boundary (the 22-point `PGL`
orbit does not lift) → M5 phrasing; R5 classical-boundary citations (Kostant, Serre, golden
reduction folklore) → Phase 0 citation rules.

**M0 — conventions freeze (run first; everything consumes its output).**
Goal: fix, once, the dictionary all M-tasks share: (i) the projectivity `P^1 ↔ conic` matching
the frozen C406 Gate-1 conic conventions; (ii) an integral model of the vertex set as a binary
form. **Candidate to verify, not assume (guardrail 1):** Klein's icosahedral vertex form
`f(x,y) = xy(x^10 + 11 x^5 y^5 − y^10)` — verify computationally that it is invariant (up to
scalar) under an explicit integral/golden `A5`-action compatible with C377's integral golden
map, and that its 12 roots are the vertex set; record the analogous binary forms for the cube's
8 vertices (over `Z[sqrt 2]`) and the octahedron's 6. (iii) a frozen labeling JSON mapping
char-0 roots to conic points at each prime. Deliverable: one conventions JSON + verification
certificate. Falsifier: no integral form compatible with C377 exists ⇒ blocker note, Fable
review of the model before M1 runs. Model: Opus.

**M0 ADDENDUM OUTCOME (C458, 2026-07-21) — GREEN; M2 AMBER→GREEN.** M2 proved that the frozen
Klein binary form is *sheet-blind* (rational ⇒ `sigma`-invariant `A5` ⇒ prime-independent
reduction): it is the correct vertex-set model but cannot carry the sheet bit. C458 promotes the
golden six-arc + invariant anisotropic conic + polar-pair matching (already frozen de facto in
C379) to a **co-equal frozen sheet-carrying object** under M0's JSON discipline, states the
two-frame theorem, and records the bridge. The certificate and independent Fable review are GREEN;
claim 3 now has a frozen antecedent. Convention *extension*, not change: nothing frozen becomes
wrong and M1 is untouched. All downstream golden-frame work consumes
`notes/2026-07-21-c458-golden-sheet-frame-freeze.{md,py,json,sha256}` and `-replay.py`.

**M1 — vertex-reduction bijection (the load-bearing miracle).**
Goal: certify that the M0 vertex set reduces **bijectively onto `P^1(F_11)`** (the full conic)
at both primes π, π̄ of `Z[φ]`; same for the cube's 8 vertices over `Z[sqrt 2]` at both primes
above 7, and the octahedron's 6 vertices at 5. **Expected result to check, not assume:** if the
M0 candidate form is correct, then mod 11 `f ≡ xy(x^10 − y^10)`, whose root set is exactly
`{0, ∞} ∪ F_11^* = P^1(F_11)` — the bijection should fall out of this factorization, and the
certificate must exhibit it explicitly. Method: exact reduction of the M0 conventions; no new
conventions. Deliverable: certificate containing the 12-row bijection table per prime (8-row and
6-row analogues) + the vertex-count identity remark (`h + 2 = q + 1`).
Falsifier: bijection fails ⇒ search the finite set of quadratic twists of the embedding for the
repairing twist and record it; if no twist repairs, the integral model dies in its strong form
and the master-stroke note is amended before any dependent task runs. Model: Opus. **Run before
everything else in the program.**

**M2 — antipodal uniqueness and singleton identification (absorbs T1).**
Goal: (i) certify integrally that the antipodal matching is the unique `A5`-invariant perfect
matching of the 12 vertices (orbit argument: vertex-pair orbits 6/30/30, only the size-6 orbit
can be a matching); (ii) identify the two C406 singleton depth fibres as the reductions at π and
π̄ of that one antipodal matching; (iii) run T1's covariation spec (sheet labeling and `mu_3`
sign covary with the choice of `sqrt 5` = 4 vs 7; B3 analogue with `sqrt 2`) as the corollary
check. Deliverable: certificate; on success this is the first certificate of the integral-model
theorem, not a Rosetta row. Falsifier: singletons are not the reductions ⇒ claim 3 of the master
stroke dies; T1's weaker covariation may still hold — record both outcomes separately. Model:
Opus.

**M2 OUTCOME (C442, 2026-07-21) — AMBER; falsifier did NOT trigger; claim 3 confirmed and exhibited
in the golden frame.** Clause (i) GREEN (orbits 6/30/30, unique antipodal matching). Clause (ii):
the two C406 singletons ARE the two prime-reductions of ONE golden antipodal matching — the char-0
golden six-arc's polar-pair matching reduces to base at `pi` (`phi->8`) and J-mate at `pibar`
(`phi->4`), exhibited by direct construction. But M0's frozen *rational* binary form is sheet-blind
by theorem (`sigma` normalizes its `A5`, so both prime-reductions coincide), so the sheet-carrying
object is the golden six-arc, not the binary form. Claim 4 re-scoped: the swap is the mod-11 shadow
of the RATIONAL rotation `Rz` (spinor norm 2), outer iff 2 is a nonsquare mod `q`; purely char-11
are the vertex collision onto one `P^1(F_q)` and the finite closure `<a5(8),a5(4)> = PSL_2(11)`.
Clause (iii) GREEN. Corrected paper wording and five review findings are in
`notes/2026-07-21-c442-antipodal-singleton-reduction.md`; independent review in
`notes/2026-07-21-c442-m2-fable-review.md`. **AMBER because an M0 addendum (C458) is required to
bind claim 3 to a frozen antecedent.** Next live entry after M2: C458 (M0 addendum, to bind), then
C443 (M3). Also allocated from M2: **C459** — classify the `Q`-forms of the six-arc (the six-arc
descends to `Q`; only its golden *labeling* does not — C417's sharp boundary), parallel and
non-blocking, feeding P2e/C417 positioning.

**M3 — commuting-with-reduction (the subtle-failure step; split into formulation + execution).**
**M3a (Fable):** write the exact computational specification before any coding: the `Z[φ, 1/N]`
lattices and bases for the quotient spaces, which constructions may invert what (11 never
inverted), how division-by-Q is performed integrally, and the precise commuting squares to be
checked, each with its acceptance object. Deliverable: a formulation note that M3b implements
verbatim. **M3b (Opus):** implement the M3a spec: integral secant products, factorization
differences, `mu_1, mu_2, mu_3`; verify each commutes with reduction at π and π̄; exhibit
`mu_3` as an integral tensor on which the golden conjugation acts by −1, with ±6 as its mod-π
shadow. Deliverable: certificate + the exact denominator set N. Falsifier: an uncontrollable
denominator at 11 ⇒ guardrail-3 blocker (do not widen N silently); the theorem retreats to the
sheet/matching level (M1–M2 claims) without the tensor clause, and the paper-facing statement is
cut accordingly.

**M3 OUTCOME (C443, 2026-07-21) — SHARP BLOCKER BEFORE THE DENOMINATOR STAGE.**  The frozen golden
12-point `A5` geometry has the required unique polar matching but **four**, not one, size-ten
companion orbits completing it to a one-factorization.  `kappa` fixes none and pairs them in two
transpositions.  Each companion realizes a frozen C406 sheet at exactly one of
`zeta=3,4,5,9`.  The C448-motivated unordered-pair repair does descend at each `O`-prime, but both
uniform pair averages have nonzero reduced first signed moment (support three) where C406 requires
zero.  Guardrail 3 therefore halts the literal secant-product construction before products,
quotient division, `N`, or `mu_3`.  M1--M2/C458 remain intact and the paper-1 integral tensor clause
is cut.  This does not rule out an abstract tensor: the precise missing datum would be a primitive
saturated golden-odd rank-one weight line on the four companions lying in the common kernel of the
first two moment maps.  See `notes/2026-07-21-c443-commuting-with-reduction.{md,py,json,sha256}` and
`-replay.py`.

**C461 OUTCOME (user-selected bounded M3 follow-up) — SHARP NEGATIVE.**  Over `O_0[1/2]` the full
`kappa`-descended weight lattice on the four companions has basis
`e0+e3, rho(e0-e3), e1+e2, rho(e1-e2)`.  Its golden-odd degree-1/2/3 moment maps have mod-11 ranks
`1/4/4`; stacking degrees one and two gives rank four and zero kernel.  Therefore no primitive
linear weighting of the four secant-sheet moment sums can have zero lower shadows and a nonzero
cubic shadow.  This closes the entire companion-weight route before the `+/-6` comparison, but not
a direct relative-invariant construction in the abstract tensor lattice.  See
`notes/2026-07-21-c461-four-companion-weight-line.{md,py,json,sha256}` and `-replay.py`.

**M4 — silver and fused cases (uniformity).**
Goal: B3 over `Z[sqrt 2]` at both primes above 7 (full M1–M3 analogue); A3 at 5: certify the
fusion mechanism (5 inert ⇒ the two would-be fibers are Frobenius-conjugate over `F_25` and fuse
over `F_5` ⇒ one sheet, no bit), reproducing C406's splitting criterion as reduction theory.
Deliverable: uniformity certificate across all three rows of the family. Model: Opus.
**M4 DISANALOGY WARNING (from M2/C442; do NOT copy the H3 template).** For H3 the bit-carrier is
the golden `A5`-*embedding* (the group), the rational vertex form being sheet-blind. For B3 this
DUALIZES: the group `S4` is rational and sheet-blind while the *form* (`7 sqrt2` middle
coefficient) is silver — the bit lives in the form/labeling and the spin cover `2.S4`, not the
group-embedding. M4 must be specified against this dualization. The rational skeleton of the H3
golden pair is itself the cube group (B3 inside H3), so B3 is the sheet-blind core of H3, not a
parallel copy. (See finding 3 of `notes/2026-07-21-c442-antipodal-singleton-reduction.md`.)

**M5 — the gluing statement (Fable).**
Goal: write the exact mathematical statement of master-stroke claim 4 (the characteristic-11
gluing of the two Galois-conjugate fibers into one `PGL_2(11)` orbit), with the char-0 lift
boundary stated as a feature; decide which part is provable now, which belongs to paper 2's
mechanism (Weil roof), and how the paper-1 closing theorem is phrased if M1–M3 landed.
Deliverable: statement note feeding Phase 3's promotion gate. Model: Fable.
**M5 INPUTS FROM M2/C442 (claim 4 already re-scoped; two candidate germs).** The swap element is
NOT char-11: it is the mod-`q` shadow of the rational rotation `Rz` (spinor norm 2), outer iff 2 is
a nonsquare mod `q`. Purely char-11: the vertex collision onto one `P^1(F_q)` at `q = h+1`, and the
finite closure `<a5(8),a5(4)> = PSL_2(11)`. Mechanism in one phrase: char-11 gluing = splitting of
the icosahedral quaternion (Schur-index-2) obstruction at 11. Candidate germs for the integral
gluing certificate: (a) the `sigma`-stable **perpendicularity pairing** between the two sheets' axis
systems (prime-independent, available before any char-11 choice); (b) the two-frame/quaternion
mechanism above. (See findings 4–5 of `notes/2026-07-21-c442-antipodal-singleton-reduction.md`.)
**Conditional C460 input.** If C460 identifies the golden clouds' common three-point triangle with
the prime-independent perpendicularity germ, M5 may use that identification as a concrete finite
shadow of the gluing. If the comparison fails, or remains merely cardinal, omit it completely; the
quaternion/two-frame mechanism and M5 acceptance criteria are unchanged.

## Phase 1b — cap-bridge chain (parallel, non-blocking)

Tests the cap-lane connections (dossier register rows 35–38). This track is **parallel and
non-blocking**: it must never displace an M-task's execution slot, and nothing in Phases 1a/1/3
gates on it. Cross-lane hygiene binds every task: cap-lane artifacts (`notes/handoffs/
2026-07-06-projective-cap-game-handoff.md` §§ conic localization / A5 anchor, the
`2026-07-10-a5-symmetric-completion-anchor.md` report, committed `notes/data/` bucket files) are
**read-only inputs**; no cap-lane handoff, queue-row, solver-run, or Lean edit is authorized from
this program. If committed artifacts are insufficient to reconstruct a needed cap-lane object,
that is a guardrail-3 blocker (escalate; do not run foreign solvers). Results land in crowns
notes; a one-line pointer is *offered* to the cap lane at Phase 3 disposition, nothing more.

**X1 — concurrency of the marker matchings (register row 36).**
Goal: for each frozen H3 matching (all 22), test whether its six secants are concurrent (share a
common point); uniform analogues at B3 (14 matchings, 4 secants; exterior points at q=7 lie on 4
secants) and A3 (5 matchings, 3 secants). If concurrent: identify the resulting exterior points,
their `PGL`/`PSL` orbits and stabilizers, and the sheet correspondence (sheets as two `PSL`
orbits of exterior intruder points). Method: exact linear algebra on the frozen C406 geometry
only — no cap-lane inputs needed. Deliverable: certificate; per-matching yes/no is the acceptance
object. Falsifier: non-concurrency ⇒ row 36 closes negative and X3 loses its geometric leg;
record cleanly. Model: Opus. Fully parallel to M0–M3.

**X1 OUTCOME (C446, 2026-07-21) — SHARP NEGATIVE; ROW 36 CLOSES.** Every frozen target matching
has secant-line rank three: concurrency counts are A3 `0/5`, B3 `0/14`, H3 `0/22`. An independent
full matching replay finds exactly `10/21/55` genuine secant-pencil matchings among all
`15/105/10,395` matchings and verifies that the target orbits are disjoint from them. Thus there
are no intruder-point orbits or sheet correspondence to identify, and X3 loses X1's proposed
geometric leg. See `notes/2026-07-21-c446-marker-matching-concurrency.{md,py,json,sha256}`.

**X1+ — golden–Frégier cloud bridge (C460; after C458; parallel and non-blocking).**
Goal: replace the failed point-valued concurrency guess by the exact orbit-valued geometry it
exposes. Consume C446 and C458 by SHA. First prove for every odd `q` that concurrent perfect matchings of `P^1(F_q)` are exactly
the fixed-point-free projective involutions / secant pencils through interior conic points, one
`PGL_2(q)/D_{2(q+1)}` orbit of size `q(q-1)/2`; deduce conceptually that an `S4`- or `A5`-fixed
matching cannot be concurrent. Then, in C458's frozen golden frame, certify:

- B3's `14` clouds of size `6` on `21` interior points and H3's `22` clouds of size `15` on `55`
  interior points, with all incidences and stabilizers;
- for H3, the cloud-overlap graph at intersection size five is connected, 6-regular, bipartite
  `11+11`, and recovers exactly the unordered `PSL` sheets;
- the golden base/J-mate clouds meet in a three-point set whose setwise stabilizer is exactly the
  rational octahedral `S4`, with common `A4` fixing the two matchings, and whose unique invariant
  matching is the nonconcurrent q=11 B3/cube matching;
- whether that common triangle is exactly C442's prime-independent perpendicularity-pairing germ;
  a negative answer is an accepted sharp stop and must not be repaired by changing conventions;
- the exact `22×55` incidence ranks over `Q` and the relevant small fields, including whether the
  sheet-sign line is the full left kernel; export this only as a secondary T3 control.

Deliverable: report + exact primary/replay certificate + canonical JSON + checksum manifest. Give
the conceptual double-coset proof (`A5\PGL_2(11)/D_24`, and the B3 analogue) rather than presenting
only a census. Literature scope is the classical Frégier/involution theorem and the immediately
relevant `PGL/A5/S4` orbitals; no broad matching census or novelty claim. Paper-facing output is at
most one proposition and one diagram after the two-frame theorem; Phase 3 decides whether it earns
that slot. Model: Opus; Fable gate only on the M5/X3 interpretation.

**X1+ OUTCOME (C460, 2026-07-21) — GREEN; REPAIRED GEOMETRIC INPUT CERTIFIED.** Concurrent
matchings are exactly the fixed-point-free Frégier involutions, one
`PGL_2(q)/D_{2(q+1)}` orbit; the `S4/A5` parent-order obstruction explains C446 conceptually.
B3 gives `14` clouds of size `6` on `21` interior points and H3 gives `22` clouds of size `15` on
`55`. In H3, cloud intersection size five gives a connected 6-regular bipartite graph whose
unique `11+11` bipartition is exactly the unordered `PSL` sheet pair. The golden base/J-mate
clouds meet in the coordinate triangle with rational `S4` stabilizer and common `A4`; its unique
invariant perfect matching is the nonconcurrent q=11 cube matching. The M5 comparison is positive:
the six char-0 perpendicular axis pairs reduce two-by-two onto exactly this triangle. The canonical
`22×55` incidence matrix has rank `21` over `Q`, with the sheet-sign line its full left kernel;
ranks over `F_2/F_3` are `11/20`, exported only as T3 controls. Independent direct-plane replay is
green. See `notes/2026-07-21-c460-golden-fregier-cloud-bridge.{md,py,json,sha256}` and `-replay.py`.

**X2 — knife-edge identification (register row 35).**
Goal: reconstruct, from committed cap-lane artifacts only, the q=11 knife-edge on-conic
situation (the 7 on-conic children, the D10 stabilizer, the size-2 P orbit vs size-5 N orbit);
exhibit an explicit projectivity carrying the cap frame's conic to the frozen C406 conic; test
whether the size-2 P orbit corresponds to the golden singleton pair (the two C406 singleton
fibres / their conic data) under that projectivity. Deliverable: certificate with the
projectivity and the orbit correspondence, or a refutation, or a guardrail-3 blocker if the
committed artifacts cannot pin the knife-edge classes. Falsifier: no correspondence ⇒ row 35
closes negative; X3 retains its abstract obstruction and C460 geometry, with the cap comparison
limited to consistency rather than causation. Model:
Opus; **Fable gate** on the identification verdict before it is stated anywhere.

**X2 OUTCOME (C447, 2026-07-21) — SHARP NEGATIVE; ROW 35 CLOSES; FABLE GATE GREEN.** The two
committed knife-edge classes reconstruct exactly: seven on-conic children, `D10` frame stabilizer,
and `P2+N5`, with explicit projectivities from each cap hyperbola through `XZ-Y^2` into C406's
frozen H3 coordinates. The proposed golden identification is not equivariant. Each cap `D10`
crosses the determinant boundary `5+5`; each singleton matching has an `A5` stabilizer wholly in
`PSL_2(11)`; and their unordered pair has `S4` stabilizer, which has no factor five. Exhaustion
finds zero compatible projectivities, while 120 unframed maps can force either P pair onto an edge
of either singleton, proving bare incidence is coordinate choice. Moreover, ten projectivities
carry the complete class-4 frame/P/N partition to class 7, so the cap pair itself supplies no
binary label. X3 is now unblocked: retain C460's positive cloud geometry and state the cap link as
consistency only. See `notes/2026-07-21-c447-cap-knife-edge.{md,py,json,sha256}`, `-replay.py`, and
`notes/2026-07-21-c447-cap-knife-edge-fable-review.md`.

**X2 POST-CLOSE FREE UPGRADE — GREEN TYPE-CORRECT REPAIR; FABLE ADDENDUM GATE GREEN.** The failed
singleton target has a canonical replacement in the frozen 22-matching geometry. Exactly 66 of
the 121 cross-sheet matching pairs share one conic edge, and every one of the 66 edges occurs
once. Shared-edge intersection is therefore a `PGL_2(11)`-equivariant bijection, with every
pair stabilizer equal to its edge stabilizer (`D20`, order 20). Each cap P orbit selects the
unique cross-sheet pair sharing that edge; its frame `D10` fixes/swaps the two endpoints exactly
when it fixes/swaps the two matchings, through the determinant character. This gives X3 an exact
positive cap input and local one-bit advice model, but does not orient either two-set or restore
the base/J-mate singleton claim. The construction is relative to frozen C379/C406 geometry and
makes no novelty claim. Certified in the revised C447 bundle and its GREEN Fable review.

**X3 — orbit-valued selector lemma (rows 35 + 38; after C460 and the X2 verdict).**
Goal: state and prove the bridging lemma: at a position whose stabilizer acts on a distinguished
child-pair through the chirality `C2` (C413/C417 data), no equivariant pointwise selector exists,
while orbit-valued selectors evade the obstruction. Consume C460's 15-point cloud selector and
overlap-graph recovery of the unordered sheets as the exact positive geometry; connect, with exact
scope qualifiers, the C447 shared-edge cross-sheet bijection, the cap lane's C75
feature-completeness wall, L1's q=11 failures, and the q=5 antipodal-copycat
success (canonical involution = nonsplitting case). Deliverable: a short theorem note with the
failed singleton connection stated as consistency only, while the shared-edge bijection is an
exact positive orbit-valued input. Model:
**Fable** (cross-lane theorem wording), with Opus doing any supporting checks.

**X3 OUTCOME (C448, 2026-07-21) — GREEN THEOREM; EXACT ORBIT-VALUED REPAIRS; SCOPE WALLS
PRESERVED.**  For an equivariant two-fibre whose stabilizer acts through a surjective chirality
character, an equivariant point section is impossible, while the unordered fibre is a canonical
orbit-valued output; choosing a member has exact local advice complexity one.  C460's faithful
15-point clouds and unique overlap-graph bipartition realize the global unordered-sheet recovery.
C447's `66↔66` shared-edge bijection realizes the cap-facing local torsor: the cap `D10`
determinant character swaps edge endpoints exactly when it swaps the selected cross-sheet
matchings.  The rejected singleton comparison remains negative.  C75 remains only a
feature-completeness obstruction, and L1's q=11 N choice is not repaired by symmetry; the
smallest-orbit selector instead returns the unordered P edge.  A compact exact q=5 certificate
closes the comparison premise: the frame residual is `K6` minus a perfect matching, so the marked
opponent move has a unique antipodal reply; this is a response map in the nonsplit one-sheet
control, not a choice from an unmarked two-fibre.  See
`notes/2026-07-21-c448-orbit-valued-selector.{md,py,json,sha256}`.

**X4 — C187 asymmetry via D1 (register row 37; GATED, do not start).**
Not a task now: when (if) depth-injection D1 produces the octahedral/tetrahedral all-q uncovered
formulas, evaluate at q=7 to explain the cap lane's {5,11}-not-7 filling asymmetry and record the
cross-lane corollary. Gated on D1 allocation; listed here so it is not re-invented.

## Phase 1 — verification battery

Ordering respects information-per-hour and dependencies; Phase 1a preempts this phase, and its
outcomes may re-scope tasks here. T2–T5 remain the decisive week alongside M1–M3. T1 is absorbed
into M2 (its spec is unchanged and executes there). Each spec:
**Goal / Method / Deliverable / Falsifier / Model**.

**T1 — spin-prime covariation (sheets = primes above q). [ABSORBED into M2; spec retained for
reference and executes there.]**
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
derive the full `PSL_2(11)`/`SL_2(11)` character data computationally from the group itself
(guardrail 1 — no character table from memory), then compare against the Weil-representation
literature only after resolving and caching the reference.
Deliverable: certificate + verdict on roof sub-statement (a). Falsifier: decomposition does not
match the Weil components ⇒ the roof's sharpest clause dies; the conjecture reverts to its weaker
form. Model: Opus; **Fable gate** on the module-identification verdict.
**Secondary C460 control (not a T3 gate).** Consume the certified `22×55` cloud-incidence module,
its exact rank/kernel profile, and its sheet-balanced columns as a derived comparison: test whether
its unique sheet-sign kernel and modular rank drops are explained by the same computed character
decomposition. Do not promote the observed mod-2/mod-3 drops into the Hamming/Golay or Weil story
without an exact constituent-level explanation.

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
**T6 INPUT FROM M2/C442 — the `(2/p)` sheet-fidelity law (verified, six primes).** The bit is
PSL-visible iff 2 is a nonsquare mod `p`; verified distinct at `p = 11, 19, 29, 59` and **FUSED at
`31` and `41`**. So the H4/600-cell cliffhanger prime `31` is a **fusion prime at the H3 level** —
`31 ≡ 1 mod 5` gives the bit, but 2 is a *square* mod 31 so the H3 sheets fuse in `PSL`. The
"why 11" story is now three simultaneous conditions (splits in `Q(sqrt5)`; 2 nonsquare mod `p`;
`q = h+1`); the composite is a Chebotarev class in `Q(sqrt2, sqrt5)`. T6 owns proving/evaluating
the law; the finding is verified in `notes/2026-07-21-c442-m2-fable-review.md`. This directly
re-shapes cliffhanger beat 2 (the 31 prophecy) — surface the fusion before that paragraph is drafted.

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

**T10 — quaternion-order reduction (conditional on M2 passing).**
Goal: certify that reducing the icosian / binary octahedral maximal orders at the two primes
above q yields the two sheet embeddings, in the exact frozen conventions. Deliverable:
certificate; upgrades the T1 theorem to its structural form; reframes C382's negative.
Model: Opus.

## Phase 2 — cheap theorems and framing notes (parallel to late Phase 1)

Each is a writing task with a bounded literature audit; no new computation beyond small checks.

- **P2a — equivariant advice complexity.** Consume C448 rather than re-proving its selector lemma;
  use C447's cap `D10` endpoint/cross-sheet-pair determinant torsor as the exact local
  complexity-one model and C460's clouds as the orbit-valued geometric realization, on top of
  C413/C417/C379. Add symmetry-breaking and access-structure corollaries and the PIR/service
  unification remark (C369/C391/C392 cited, not imported).
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
2. **Promotion gate (Fable).** If M1–M3 landed: promote the integral golden model to the
   recommended paper-1 closing theorem; the Rosetta rows become corollaries of specialization;
   the surviving paper-2 conjecture narrows to the char-11 gluing mechanism (Weil roof; M5's
   statement). If M1–M2 landed without M3: the closing theorem is the sheet/matching-level
   model and the tensor clause stays a checked row. If M1 failed untwisted and unrepaired: the
   ending reverts to the six-row table + conjecture form, and the master-stroke note is amended.
3. **Ending design freeze.** Produce the recommended closing-section draft (table + three-beat
   cliffhanger calibrated to what actually landed; the dossier's draft paragraph is the template,
   rewritten to the surviving evidence). Deliverable: a design note. **This note is advisory: the
   manuscript decision and any edit belong to the `clebsch` lane and its handoff process.**
4. **Program disposition.** Close or re-scope every register item (dossier §13) with an explicit
   verdict; append incidental observations to the lane's discovery log per conventions; update
   the crowns handoff; archive completed queue rows per the completion invariant. Treat C447's
   GREEN shared-edge repair as the positive X2-derived identification for this purpose (while
   retaining the negative singleton verdict): draft the one-line cross-lane pointer after C448
   fixes the theorem wording and leave the decision to surface it with the cap lane's owner — no
   cap-lane edits from this program.
5. **Paper 2 go/no-go (Fable).** If roof sub-statements survived: scope the metaplectic paper
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
