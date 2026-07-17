# Discovery-track conventions

The discovery track is the lane's append-only catchment for **incidental observations and musings**
encountered while doing planned work. It exists because a focused task report correctly records the
answer it sought, but would otherwise discard potentially useful things noticed off to the side.

## Boundary

Apply one question to each candidate entry:

> **Was I looking for this as part of the current task or lane deliverable?**

- **Yes:** it is task work. Put it in the task report, proof/claim ledger, or handoff status map. It
  does not belong in the discovery track, even when the result is surprising, negative, or opens a
  follow-on.
- **No:** it may be a discovery-track entry. Typical entries are an unexpected side fact, a failed
  background intuition, a connection noticed in passing, or a question/musing thrown off by the
  work.

The discovery track is therefore not a task queue, work-package table, proof or claim ledger,
validation log, theorem-facing report, list of lane deliverables, or alternate handoff. It never
changes the current task's scope by itself.

## Regular proof/math handoff process

Every proof/math lane keeps exactly one companion discovery log. This is a standing part of doing
mathematical work, not an opt-in activity. Non-mathematical lanes may use the same convention when
useful.

1. Create the lane companion when proof/math work begins and link it in one line from the live
   handoff. Do not copy its entries into goals, frontiers, recommended order, or next steps, and do
   not preload it on ordinary lane entry.
2. On noticing something incidental, append a dated entry. Record enough provenance to recover the
   context, what was noticed or mused about, why it may matter or what question it raises, and the
   evidence level. When meaningful, state the expectation that failed.
3. Treat every entry as a lead, not an authority or commitment. Logging it allocates no C-ID and
   authorizes no extra investigation.
4. If the lead later becomes work, scope it normally: allocate a C-ID and lane peg, put the
   deliverable in the queue/handoff, and create a report. Leave the original log entry intact and
   append a `graduated -> ...` pointer. Cross-lane observations likewise require normal routing;
   the log cannot assign work to another lane.
5. As part of every proof/math handoff, make a brief pass over the work just done for incidental
   observations or musings worth preserving, append them, and retain the companion link. Do not
   manufacture entries when there were none. Open discovery entries remain outside the lane's
   obligations. At lane completion the append-only log remains a dated historical companion; it is
   not promoted wholesale into the archive or next lane.

Suggested compact entry:

```markdown
### YYYY-MM-DD — short observation or question

**Provenance:** task/probe/source that exposed it.
**Was I looking for this?:** no — what the work was actually trying to decide.
**Observed / musing:** ...
**Why it may matter / strongest question:** ...
**Evidence:** OPEN | REASONED | CHECKED | LEAN | source-specific tier
**Status:** open lead | graduated -> <C-ID/report> | retired -> <reason>
```

The expectation and question fields are aids, not admission tests: a worthwhile connection or
speculative musing can be logged without manufacturing a violated expectation. The admission test
is that it was incidental.

### Structural sibling predictions

One especially useful incidental lead has the form:

> We found phenomenon **P** here; we predict a related phenomenon in **X, Y, and Z** because those
> settings share mechanism **S**.

Log this when the cross-domain prediction was not part of the current deliverable. It should be a
**phenomenon forecast**, not a list of places where an algorithm might be applied. Useful forecasts
predict a missing distinction, exceptional regime, obstruction, strict separation, or pair of
objects that a coarser abstraction incorrectly identifies.

When available, add these fields to the normal entry:

```markdown
**Structural mechanism:** the invariant or ingredients shared across the settings.
**Predicted siblings:** X — predicted P_X; Y — predicted P_Y; Z — predicted P_Z.
**Discriminator / falsifier:** an observation separating the prediction from analogy, and what
would show that an existing baseline already captures it.
```

The prediction remains an open lead until checked. It does not allocate cross-lane work, and the
discovery track should not be filled with generic “could apply to” lists.

## Legacy normalization (2026-07-16)

The C115, Clebsch, and gem discovery logs follow this boundary. Two relconic companions had used
“discovery track” for substantial portions of their planned mechanism audits:

- `2026-07-16-c201-discovery-track.md` is retained at its existing path for stable links but is
  classified as a **mechanism-audit notebook**.
- `2026-07-16-c210-discovery-track.md` is retained at its existing path for stable links but is
  classified as a **mechanism notebook**.

Their contents remain useful task history, but they are not precedents for discovery-track scope.
New planned C201/C210 results belong only in their reports and handoffs. A future genuinely
incidental relconic observation may start a clean lane companion under these conventions.

The embedded registers in the live projective-completion/repaircodes and relative-conic-arcs
handoffs mostly contain genuine incidental findings, but their location predates the crisp-live-map
rule. They are frozen legacy registers: preserve them until those handoffs are archived, but put any
new incidental observations in a standalone companion log. The former “Discovery track for final
review” in the Lean formalization handoff was a summary of planned strengthenings and has been
renamed accordingly.
