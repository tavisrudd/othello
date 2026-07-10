# Ultra round 1 prompt — projective-cap odd-plane frontier

Date: 2026-07-10.  Intended as the quota-conservative pre-reset round.  Do not execute this file
implicitly; paste its prompt into the Ultra session only when the user explicitly launches it.

```text
Current task statement

Let q be an odd prime power and let PG(2,q) be the Desarguesian projective plane. Two players
alternately select previously unselected projective points while maintaining that no three
selected points are collinear. The player with no legal move loses. A position is P if the player
to move loses under perfect play, and N otherwise.

Make rigorous progress on the active theorem frontier:

    For every odd prime power q, the empty cap-game position on PG(2,q) is P.

Equivalently, prove that the second player has a winning strategy for every odd q.

The project has a Lean-proved bidirectional reduction. After the opening/frame reduction, the game
becomes a residual q×q grid game whose legal positions are affine caps with at most one selected
cell in each row and column. Every legal residual size-3 position has exactly

    q² - 9q + 21

legal size-4 children, and

    PG(2,q) is P
    iff every legal residual size-3 position has at least one P-valued size-4 child.

Thus a counterexample is exactly a trapped size-3 position whose every legal size-4 child is N.
Proving that an extension is legal is insufficient; it must be P-valued.

A stronger route, called (ON), asks for a P-valued child among the q−4 legal extensions on the
unique conic through the residual size-3 position and the two burned directions. Do not assume
(ON). It may fail while the main theorem survives through an off-conic P child.

Assume as a search heuristic that the main theorem is true and has a uniform proof accessible by
refining the current structure. This may not be used as a premise. In particular, it gives no
license to assume (ON), a geometric selector, a potential invariant, or a missing closure lemma.

Round-one resource and quota limits

- Hard wall time: 40 minutes from launch.
- Hard parallel limit: 3 active agents total, including the root. Spawn at most 2 delegates.
- Keep the root at the current Ultra/high-reasoning setting for orchestration and synthesis. Use one
  proof delegate at high effort and one literature/data delegate at medium effort. Do not run two
  Ultra/high-effort delegates concurrently before the quota reset.
- The currently exposed sub-agent launcher may not provide a model/effort selector. If it does not,
  treat "high" and "medium" as task-depth instructions and enforce them through narrow scopes,
  deadlines, and output caps; do not claim that a product-level effort setting was changed. If the
  runtime does expose the setting, record the actual model/effort used in the final report.
- Budget the high-effort proof delegate for at most 24 minutes. Budget the medium-effort scout for
  at most 18 minutes initially, plus at most one focused follow-up of 7 minutes. All delegates must
  be stopped or have returned by minute 27. Reserve minutes 27-40 for root synthesis and audit.
- Do not use nested delegation or exceed the three-agent total.
- This is the pre-reset scouting/refinement round. Its final output must identify the strongest
  one or two routes for a larger second round after the quota reset.
- The root has no reliable tool for reading the product's live five-hour quota percentage. It can
  monitor elapsed time and agent status only. If the user reports a quota warning or sends a stop
  instruction, immediately interrupt delegates and synthesize the work already obtained.
- Quota consumption is not linear in wall time; it depends on model, effort, context, and generated
  tokens. The limits above cap nominal agent work at roughly 89 agent-minutes, but that is only a
  scheduling bound, not a quota prediction. Keep prompts focused and outputs compact.
- Do not start the full q=25 census, a new q=23 Grundy campaign, or any run likely to exceed 2 GB
  RSS or 8 minutes. Prefer existing artifacts and read-only queries.
- Do not edit tracked project files or commit during this research round. Small diagnostic scripts
  may be written under /tmp. Return exact commands and outputs for computational claims.

Authoritative local context

The root must first read AGENTS.md and enough of these current sources to avoid stale or duplicated
work:

- notes/handoffs/2026-07-06-projective-cap-game-handoff.md
- notes/2026-07-09-odd-plane-falsification-map.md
- notes/2026-07-08-nk-involution-residual.md
- notes/2026-07-09-codex-potential-lp-dual.md
- notes/2026-07-09-codex-reply-automaton.md
- notes/2026-07-09-codex-selector-library-scoring.md
- notes/2026-07-10-codex-q19-psi-selector-hard-surface.md
- notes/2026-07-09-codex-depletion-fraction.md
- notes/2026-07-10-codex-a5-nbucket-density.md
- notes/2026-07-09-codex-q25-baer-census.md
- notes/2026-07-08-s4-memo-dump-query-manual.md

Delegates should read only the subset needed for their route. The root must enforce every known
negative below.

Current evidence and live structure

- Every tested odd Desarguesian plane through q=23 is P at its recorded trust tier.
- q=5,7,11,13 are Lean-closed.
- q=9,17,19 are computed P; q=17/19 have independently rules-checked reply books.
- q=23 has 22/22 P full-PGL on-conic buckets, a Lean-proved PGL transport bridge, and a rules-only
  check of all 241,627,613 early-break records.
- q=25 currently has at least 3/28 on-conic buckets certified P; consult the latest committed
  census status at launch and do not duplicate a running computation.
- All four projective planes of order 9 are P. This suggests that an incidence/oval-level mechanism
  may exist, but one order is not a theorem.
- PG(4,3)=P is the first higher-even-dimensional odd-field datum. It is an optional structural
  control, not the active target.

For the stronger (ON) route:

- At q=5,7,9,13,19,23 every known on-conic S4 bucket is P.
- The only depleted orders so far are q=11 and q=17.
- Their worst-class on-conic P-witness counts fall from 2 to 1.
- The orbit-weighted N-bucket density rises from ν(11)=0.357 to ν(17)=0.791.
- Under an independence null, the expected number of fully-N size-3 fans is 0.006 at q=11 and
  exactly 1.000 at q=17, versus zero observed. This is a heuristic showing that density alone gives
  no safety margin; it is not a proof input and does not make the observed dependence accidental.
- The onP distribution is bimodal at depleted orders: q=11 has onP in {2,5}; q=17 has onP in
  {1,3}. The minimum is an exact extremal fan type, not an average.
- Bucket fiber size separates values at q=11 and q=17: at q=17 P-bucket fibers are at most 120
  and N-bucket fibers at least 240. This correlation motivates a special-completion theorem but
  does not prove one.
- At q=17's worst class the main theorem is less fragile than (ON): it has five total P escapes,
  four off-conic.

For the dynamic strategy route:

- Each off-conic intruder induces an involution matching on the conic parameter line.
- With one or two intruders, the live-conic graph is understood: paths plus even cycles, with every
  even cycle contributing Grundy zero. The value lies in Dawson-path defects.
- Three or more intruders give a dynamically growing union of matchings coupled to the off-conic
  zone. No theorem currently controls this layer.
- The clean decomposition g = g_conic XOR g_zone is empirically false.
- The recursive steering ceiling is not uniformly small: Z(13)=2, Z(17)=9, Z(19)=16, and
  40<=Z(23)<=136.
- The strongest current charge is

      Psi(S) = reservoir_slack(S)
             + 6*defect_components(S)
             - 4*selected_intruders(S)
             - 2*[conic_xor(S)=0].

  Under the exact oracle-selected strategy, Psi strictly decreases on every q=13 and q=17
  obligation. In the exact q=19 root, every obligation has some P reply decreasing Psi, although
  the fixed C31 selector fails on twelve obligations. A q=23 extremal trajectory also descends.
  This is evidence for a charge, not a proof invariant: known replies still use exact values.

Known dead or wounded routes

Do not repeat any of these without naming a genuinely new premise that escapes the recorded
counterexample:

- a single fixed mirror or projective involution for odd planes;
- the tested play-closed symmetric strategy families;
- naive parity, terminal parity, or area/counting bounds such as bad=o(q²);
- MirrorStepGood compression at the S4 escape layer;
- a q-independent static feature dictionary or exact type-to-value table;
- fixed-q census propagation from uniform geometric census vectors;
- residue-class explanations such as the mixed-column mod-3 law;
- the tested group-side, completion-poset, envelope, polarity, and Psi flip/control classifiers;
- the clean conic/zone disjunctive-sum law;
- reservoir-to-Hall/matching arguments at the q=23 frontier;
- a uniformly bounded small-Z strategy;
- the tested q-blind finite reply automaton;
- rho-greedy or any currently tested deterministic selector as an exact law;
- repairing an immediately N-valued response over a later move pair;
- treating exact Z, Grundy value, tablebase membership, remoteness, or strategy depth as a
  proof-admissible coordinate.

A route ending in "choose a P reply" or "choose the reply minimizing exact Z" is circular. A route
proving only that Psi decreases somewhere is incomplete unless it defines a value-blind Good class,
proves Good-restoring reply existence, and supplies the correct base/terminal argument.

Round-one research objective

Use the 40 minutes to produce the strongest rigorous logical refinement, literature import, or
exact missed-data signal possible. A complete proof is welcome but not required for this scouting
round. Prioritize work that does at least one of the following:

1. Refines the theorem to a genuinely weaker sufficient lemma rather than renaming "a winning
   reply exists."
2. Imports a specific external theorem whose exact hypotheses resolve or sharply constrain a
   missing step.
3. Finds an exact identity or existing-data signal with a predeclared falsification test.
4. Turns Psi, fan/bucket incidence, special completions, forced replies, or third-intruder geometry
   into an exact combinatorial statement.
5. Shows that (ON) is the wrong target and formulates a credible off-conic escape replacement.

Primary exact A5 object: fan-to-bucket incidence

In the full-PGL conic model, let rows A be five-point conic frames

    A = {infinity, 0, t1, t2, t3},

let columns B be full-PGL six-point buckets, and define

    M_q(A,B) = number of sixth points x for which A union {x} lies in bucket B,
    f_q(B)   = 1 if bucket B is P, else 0.

Then

    onP(A) = sum_B M_q(A,B) f_q(B),
    (ON) iff every coordinate of M_q f_q is positive.

The independence null throws away precisely the dependence encoded by M_q. At q=17, the exact
phenomenon is that P buckets occupy only 20.9% of raw six-point states yet cover every row of M_q.

At q=11 and q=17, pursue as much of the following exact program as the time budget permits:

1. Construct or recover M_q and reproduce onP types {2,5} and {1,3}.
2. Identify the smallest collection of P buckets covering every row.
3. Compute each bucket's exact setwise stabilizer, order, fiber/orbit size, and permutation cycle
   types on its six points.
4. Determine whether "small fiber" is shorthand for a q-uniform group-theoretic property, such as
   a specified nontrivial stabilizer type. Test the definition at q=13 and q=19 controls.
5. Seek an algebraic construction that, from arbitrary A, chooses x making A union {x} special.
   Record every denominator, characteristic, square-class, and prime-power exception.

The target factorization is

    every five-frame admits a special completion
    + every special completion is P
    => (ON).

Both obligations are required. Do not define "special" by its P label. Do not infer special=>P
from fiber correlation. C28's zero MirrorStepGood census forbids silently identifying a nontrivial
stabilizer with a valid mirror strategy.

Harmonic/design analysis is useful only if it explains row coverage or the two-valued onP vector:
test inclusion-matrix rank, Johnson-scheme components, t-design identities, PGL permutation modules,
or exact orbit-incidence relations against both depleted orders.

Other live directions

A. Reservoir slack as exact collision energy

Before truncation, the reservoir term is plausibly the overlap surplus among used-column blockers,
secant-trace blockers, and the unique conic cell in each unused row. Derive an exact local
multiplicity formula and its delta under an opponent/reply pair. Test whether the current
max(0,...) truncation hides the q-sensitive incidence quantity responsible for q=17/q=19
differences. An averaging argument must range over a value-blind algebraic candidate family.

B. Third-intruder transition geometry

Search for an exact transition law for adding a third involution matching: triples/products of
involutions in PGL(2,q), incidence geometry of their centers, subgroup/orbit constraints, and the
change in live defect components. The useful result need not solve arbitrary degree-3 Node-Kayles;
a bound or identity for the Psi terms under one added matching could suffice.

C. Off-conic fallback

Use the q=17 extremal fans, with one on-conic and four off-conic P escapes, as the exact model.
Identify whether the off-conic escapes share a projectively definable relation that is absent from
generic classes. State a direct total-escape lemma that remains meaningful if q=25 refutes (ON).

D. Incidence/oval-level mechanism

All four order-9 planes are P while matched random hypergraphs are often N. Look for a
projective-plane or oval-level property shared across the four planes that yields a concrete reply
lemma for the Desarguesian target. Do not broaden the theorem merely for elegance.

Live q=25 decision tree

At launch, check the latest committed q=25 status. Do not duplicate a running or completed census.

If q=25 has ν=0:
- record that q=25 is non-depleted;
- do not call the adverse depleted-order trend refuted;
- continue the q=11/q=17 covering analysis, since q=25 supplies no stressed A5 row.

If q=25 has mixed P/N buckets:
- compute ν(25) and the exact or currently determined fan-to-bucket incidence information;
- determine whether any five-frame is fully N;
- compare stabilizer types and fiber separation with q=11/q=17.

If a fully-N five-frame exists:
- mark (ON) refuted at q=25, not the main theorem;
- extract its known off-conic P children, or state honestly that they remain unknown;
- redirect the proof route to a direct off-conic escape lemma.

If ν(25)>0 but every fan still has a P completion:
- treat this as strong evidence for a structured covering theorem;
- identify exactly which rare bucket types cover the extremal fan.

Literature-search rules

Public search is encouraged, but use primary sources: papers, monographs, official preprints, or
authoritative documentation. Do not spend the round merely confirming that the conjecture is open.

High-value search neighborhoods:

- setwise stabilizers and orbit classifications of unordered six-subsets of P1(F_q);
- one-point extensions of five-point configurations to six-point sets with prescribed automorphisms;
- M_0,6, binary sextics, and automorphism groups of genus-2 branch loci;
- PGL(2,q) tactical decompositions, permutation modules, and orbit-incidence matrices on k-subsets;
- covering designs formed by exceptional orbits of multiply transitive groups;
- triples of involutions in PGL(2,q), trace-zero involutions, and center/involution geometry;
- arcs with large conical subsets and excess-two/excess-three classifications;
- inclusion matrices, Johnson schemes, harmonic set functions, and t-design identities;
- exact character-sum or polynomial nonvanishing methods for finite-field reply existence;
- impartial build/avoidance games, reply strategies, discharging, and strategy-complexity bounds.

Every literature result must include a direct citation/link, exact theorem statement, all
hypotheses, a translation into the cap-game variables, the obligation it resolves, and any gap.
An analogy or bibliography list alone is not progress. Distinguish the special-completion covering
question from C69: C69 tested arithmetic invariants as direct value classifiers; this route asks
whether exceptional six-set orbits cover every five-set, followed by a separate game-value theorem.

Using existing S4 data

Use existing exact artifacts before computing anything new. Locate them with rg under
rust/s4-dumps and follow notes/2026-07-08-s4-memo-dump-query-manual.md.

Useful read-only tools:

- s4query: interactive state, move, and reply inspection;
- s4mine: root/ply summaries, known replies, and live-conic components;
- s4gdistill: forced N nodes and their unique P replies;
- s4gremote: exact remoteness strata;
- s4potential: exact transition extraction for the fixed oracle strategy;
- s4selectors: exact selector/failure scoring;
- s4potentialprobe: geometric/Psi inspection of explicit trajectories;
- existing s4xormine/s4zcensus artifacts for q=23 steering;
- s4arena summaries for q<=19 and the current q=25 census.

Example query shape:

    printf 'state\nmoves\nreplies r,c\nquit\n' |
      <gridcap-binary> s4query q t1,t2,t3,t4 --raw <exact-raw-dump>

Data rules:

- State the hypothesis and kill-test before inspecting labels.
- Prefer q=11/q=17 depleted contrasts with q=13/q=19 controls.
- Use forced-node corpora when claiming a reply distinction is necessary.
- Distinguish early-break P/N dumps from complete Grundy dumps.
- An absent early-break child is unknown, not P or N.
- Capped q=25 unknowns remain unknown.
- Treat BuRR archives only within their documented exploratory trust boundary.
- Report counterexamples and a proposed theorem statement for every correlation.
- Do not launch a broad feature search because one local discriminator worked.
- Do not promote an exact per-q pattern without a q-parametric mechanism.

Multi-agent protocol

Use the root plus at most two delegates dynamically.

1. In the first 3 minutes, launch two delegates on genuinely different approach families:

       Delegate A — requested high effort, proof/theorem role, one exact target lemma.
       Delegate B — requested medium effort, literature/data scout, one bounded search question.

   Preserve independence: do not tell both that Psi or fan-to-bucket covering is favored. Do not
   spend the medium delegate on a second broad proof brainstorm; its job is targeted reconnaissance
   with exact applicability or reproducible falsification.
2. The root works simultaneously and maintains a registry:

       approach family
       exact target lemma
       evidence used
       strongest result
       blocker
       whether blocker is weaker than the theorem
       next kill-test

3. At minute 14, inspect both agents. If neither has engaged the exact fan-to-bucket covering
   object, redirect one only if it does not already have a comparably concrete theorem-level lead.
   A redirect does not justify increasing its effort level.
4. The medium scout should make its first return by minute 18. Spend its optional 7-minute follow-up
   only on a concrete theorem citation, a specified S4 query, or an adversarial check of another
   agent's stated lemma. Keep that follow-up at medium effort.
5. The high-effort proof delegate should return by minute 24. Do not extend it merely because it is
   still brainstorming. An extension is allowed only after stopping the other delegate and only if
   the root already has a precise near-closure to audit; the minute-27 all-delegate stop still holds.
6. When practical, have the non-originating delegate adversarially check the best candidate. Stop
   all delegates by minute 27. Use minutes 27-40 for root synthesis and audit.

Do not let an elegant reduction dominate because its missing lemma sounds natural. If the final
lemma is equivalent to "every opponent move has a winning reply," mark it circular and redirect.

Required delegate output

Reject vague reports. Each delegate must return at least one of:

- a fully stated and proved lemma;
- a precise lemma with a stepwise proof plan and one isolated gap;
- a counterexample to a live sublemma;
- an exact literature theorem with verified applicability;
- a reproducible data finding with command, output, and falsification test;
- a genuinely bidirectional new equivalence;
- a rigorous obstruction to a proposed invariant class.

The high-effort proof delegate has a 2,000-word output cap. The medium scout has a 1,200-word cap per
return. They should cite local paths and line numbers rather than repeating project context, and
include only the equations, commands, or quotations needed to verify their claims. These are output
caps, not permission to omit a proof-critical step.

Use tags:

    [PROVED]
    [COMPUTED-EXACT]
    [COMPUTED-PARTIAL]
    [LITERATURE-IMPORTED]
    [CONJECTURED]
    [REFUTED]
    [BLOCKED]

Adversarial checklist

Check every candidate for:

- reversed P/N recursion;
- proving legality rather than P-value;
- silently replacing the main theorem with (ON);
- consulting exact value, Z, remoteness, or future strategy in the selector;
- extrapolating the two-intruder theorem to three intruders;
- treating conic and zone as a disjunctive sum;
- confusing fixed-q PGL transport with cross-q transport;
- using prime-field coordinates when all odd prime powers are required;
- losing Frobenius/GF(25) effects;
- treating missing early-break states as known;
- using the independence null as a proof bound;
- defining "special" through its P label;
- claiming special=>P from fiber correlation;
- assuming nontrivial stabilizer supplies MirrorStepGood;
- ending at a lemma equivalent to the original escape theorem.

Return condition

At minute 40:

- If a complete uniform proof survives adversarial audit, return it in full.
- Otherwise return the strongest rigorous progress, not a restatement of the handoff.

The final response must contain:

1. The best new theorem/lemma chain, every step tagged by status.
2. The exact remaining gap and why it is narrower than the original theorem.
3. The best literature import and its precise application.
4. The strongest missed data signal, including reproduction and counterexamples.
5. The approach registry and why each route advanced, failed, or was redirected.
6. The best one or two routes to fund in the post-reset second round, with exact agent assignments,
   requested model/effort levels, success/failure gates, and estimated cost.
7. A short audit for circularity and scope errors.

Do not claim progress merely for generating features, finding another high-accuracy selector, or
computing another fixed q. This round should end with a sharper lemma, sharper obstruction, or
sharply justified second-round attack.
```
