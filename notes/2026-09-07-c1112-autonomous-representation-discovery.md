# C1112 autonomous representation discovery: bounded worktree pilot

Same branch and worktree as C1111; no main-checkout implementation changes.
The existing core `synthesize_decision_tree` learns a predicate on clique size.
The initial F13 training batch contains smallest nontraces and true traces;
size > 3 misclassifies 2600 candidates. The harness adds those concrete F13
counterexamples and relearns size > 5. All 2652 F13, 8180 F17 and 12676 F19
candidate labels then agree. F17/F19 labels never enter feedback.

The candidate adapter supplies maximal-clique enumeration and the second-stage
largest-disjointness-clique rule. The learner selects traces; it does not invent
that algorithm or recover finite-field arithmetic. Independent line-equation
checks verify the teacher labels and final partition words. The Rust plan is
also evaluated by a separate Python interpreter.

Five interleaved Python query rounds find direct graph lookup about five times
faster than partition-word comparison. Packed label payloads are smaller
(1760/3360/5440 versus 5995/21945/36856 bits), excluding metadata; this is not
measured Python memory reduction. Construction/checking add cost. The handwritten
control outputs field coordinates rather than partition labels, so its timings
do not support an equal-output speedup comparison. There is no Rust kernel
performance claim, universal theorem, or learning-method novelty claim.

C1112 remains in progress: a wider proposal language, campaign integration,
extension fields, repeated independent runs and useful end-to-end benefit are
not established. C1113 remains gated; no application transfer was attempted.
Exact commands, recorded outputs and SHA256SUMS are in the worktree's
`experiments/continuation/` bundle.

## ej+tt closeout / Mystery ledger

The useful negative is that representation compression need not accelerate the
requested query. A next experiment should target recovered-incidence queries,
not keep optimizing adjacency lookups. The observed mixed-clique maximum five
is stronger than the uniform bound used by the paper, but its validity outside
the tested prime fields is unresolved. Adversarial field-family testing is the
next discriminator; no new mathematical assertion is made.

Validated private commits: `529e9f2`, `dff995d`; replay and gate details are in
the C1111 report. No worktree merge or production transfer was performed.
