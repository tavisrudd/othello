# `alt-orbit-repair` discovery track

**Lane**: `alt-orbit-repair` — companion to
[the lane handoff](handoffs/2026-07-14-alternate-orbit-repair.md).

Append-only catchment for incidental observations and musings noticed while doing planned lane work.
Entries are leads, not authorities or commitments: logging one allocates no C-ID and authorizes no
extra investigation. See [the conventions](discovery-track-conventions.md).

---

## 2026-07-18 — `orbitSize` was schema payload nobody had proved

**Context.** Diagnosing why `Q25ResidualMinimumOrbits.lean` would not compile; the task was the
compile failure, not an audit of the schema.

**Noticed.** `orbitSize` sits in `ValidRowPayload` and `ResidualClassPayload`
(`Q25ResidualCoverData/Schema.lean`) and occurs in no proof anywhere in the lane. The bridge
docstring already says so. The five sizes `200,400,400,200,400` have been carried as generator
output since the cover was built, and read as established because they appear in a schema and a
report table.

**Why it may matter.** A payload field is a plausible place for an unproved number to look proved,
because it is adjacent to checked data and survives every regeneration. Worth a habit: when a
generated schema carries a quantity the paper states, check whether any theorem consumes that field
before treating the number as evidence.

**Evidence level.** Verified by grep across the lane plus the bridge's own docstring.

---

## 2026-07-18 — the certificate trees were pre-adapted to a blocker nobody had named

**Context.** Tracing why `decide` would not reduce on residual images.

**Noticed.** Every generated transport leaf carries
`simp [residualApply, shift, scale, realPart, imagPart, GF25.ofNat, GF25.encode] <;> decide`. That
`simp` list is exactly the workaround for the opaque `ZMod 5` inversion inside `scale`. The
generator author evidently hit the wall and coded around it per-leaf, but the obstruction itself
does not appear in any report or docstring — so the next module written by hand walked straight
into it.

**Why it may matter.** A workaround replicated across a thousand generated files is a strong signal
that an unstated invariant exists. Such repeated incantations may be worth reading as documentation
of a constraint, and promoting to a named lemma the first time they recur.

**Evidence level.** Read from generated sources; the causal link to `ZMod.inv` well-founded
recursion is confirmed by the elaboration failure and by the fix working.

---

## 2026-07-18 — inversion as cubing avoided a table the review had assumed

**Context.** Building the reducible evaluator. The design review proposed a five-entry `F5` inverse
table with a lookup lemma, following the Q11 precedent's eleven-entry table.

**Noticed.** On `F5` no table is needed: `a⁻¹ = a ^ 3` for every element, including `0`, from
`a ^ 4 = 1` away from zero. Three lines, no data, nothing to mistype or audit. The Q11 file used a
table because `ZMod 11` inversion is not a small power, so the precedent's shape was inherited
without checking whether the smaller field admits something cheaper.

**Why it may matter.** Copying a precedent's *mechanism* rather than its *principle* can import
avoidable trusted data. For any `ZMod p` with small `p`, inversion is `a ^ (p - 2)` and needs no
table at all — possibly worth a shared lemma if another small-field evaluator appears.

**Evidence level.** Kernel-checked (`f5_inv_eq_pow`, built green).

---

## 2026-07-18 — a finishing tactic reintroduced the blocked computation

**Context.** Closing the semantic bridge `IsMinimumResidualClass C ↔ C ∈ minimumOrbitUnion`. After
rewriting, the goal was pure re-association of a five-way disjunction of `Finset` memberships, so
`tauto` looked like the obvious closer.

**Noticed.** `tauto` hit the recursion limit. The disjuncts are decidable propositions, so the
tactic's decision procedures attempt to evaluate them — which is exactly the orbit materialization
the whole module is built to avoid. `simp only [Finset.mem_union, or_assoc]` closes the same goal
symbolically and instantly.

**Why it may matter.** The route's cost discipline lives in how statements are phrased, but a
finishing tactic can silently discard that phrasing and evaluate a decidable proposition that the
design never intended to evaluate. In a development where decidability is abundant and evaluation
is catastrophic, `decide`-capable automation is a hazard at the *end* of a proof, not only inside
it. The same caution applies to `omega`-adjacent closers and to `simp` with `decide := true`.

**Evidence level.** Observed elaboration failure and the working symbolic replacement; both built
green.

## 2026-07-18 — a name-resolution slip cost a full tree build to discover

**Context.** First build of `Q25MinimumClassification`, the semantic normalization lift, which sits
downstream of the 304-module conclusion dispatch tree.

**Noticed.** The build ran about 30 minutes and then failed on the consuming module for a missing
`open Q25MinimumMask`: `legalOrbitSet` was unknown, and `autoImplicit` turned it into an implicit
binder, so the three declarations mentioning it never entered the environment and every later
reference cascaded into an unrelated-looking "unknown identifier". Once the tree was warm, the same
module elaborated in about 6 seconds, and the remaining real errors — an `Admissible` ambiguity
with `Configuration.Admissible`, and a missing `orbitCodeOfNumber 5 = standardOrbit` step — took
three fast iterations.

**Why it may matter.** The cost of a mistake in a tree-consuming module is set by the tree, not by
the mistake. Elaborating the consumer once against the already-built dependencies before committing
to a cold full-tree build converts a 30-minute failure into a 6-second one. `autoImplicit` also
makes the *first* reported error the least informative one: prefer the unknown-identifier hint over
the cascade below it. The exhaustion layer is another large generated tree and will present the
same asymmetry.

**Evidence level.** Two observed build runs, the failing cold one and the passing warm one, with
the queue's recorded timings.

## 2026-07-19 — a generator that hashes itself into its output cannot gain a `--check` mode

**Observation.** Every C151 generator writes its own SHA-256 into the header of every file it
emits. That makes the generator immutable once its output is committed: any edit — including a
pure-comment one — changes the self-hash, changes all emitted headers, and so invalidates the entire
generated tree and forces a full re-elaboration. This surfaced while adding the repo-preferred
`--check` mode to the three exhaustion generators. The regeneration check then reported all `1,918`
files differing, which is the correct answer to the wrong question: the trees were fine, the
comparison baseline had moved.

The fix was to put the checker in a separate script that imports the generators without touching
them (`notes/2026-07-18-c151-exhaustion-check.py`). The `--check` edits were reverted and the three
generator hashes confirmed back at their committed values before continuing.

**Why it may matter.** This is a property of the whole repo's generator convention, not of C151.
Any generator family that embeds `source_sha256()` in its output has the same trap, so `--check`,
docstring fixes, and refactors on such a generator all carry a hidden full-rebuild cost — here about
two hours. Two ways out are available for future generator families: keep the checker external, as
done here, or hash only the *rendering* logic rather than the whole file. The second would let
generators evolve their CLI and documentation without invalidating committed output, but nothing
currently depends on it and changing the convention would itself invalidate every existing tree.

Worth noting for the `build-sys` lane, which owns build orchestration and would feel this cost in
any repo-wide generator maintenance pass. It is logged here only as an observation; promoting it to
a convention change needs a C-ID and the normal lane routing.

**Evidence level.** Directly observed: one regeneration check reporting `239`, `1,375`, and `304`
files differing after a comment-only generator edit, and passing on all three trees after the edit
was reverted.
