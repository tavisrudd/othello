# Formal threefold obstruction after one projective-line stabilization

**Lane:** `cubic-threefolds`
**Owner:** C978 follow-up; C978/C956 remain open by author instruction.

## Change

Added the public terminal
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.threefold_projectiveLine_irrationality_of_positive_count`
in
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/PaperInterface/Introduction.lean`.
It proves both nonrationality of the projective-line product and nonrationality
of the selected threefold. Its input is a positive natural-number additive
count, rather than the special cubic count one.

The rank-two projective-bundle formula supplies smoothness, dimension four
and count doubling. Positivity of the product is proved from positivity of
the base count. The dimension-four weak-factorization provider and
low-dimensional occurrence nullity then equate the count with that of
projective four-space if the product were rational, contradicting its zero
count. Rationality persistence under the product yields the unstabilized
conclusion. Every center occurrence remains indexed.

The older dimension-three endpoint theorem is retained. The manuscript
corollary now names both terminals. The primary claim remains a fragment:
varieties and QDMs are not constructed, and the geometric comparison,
factorization, center-vanishing and rationality data remain typed premises.
Matching the stronger conclusion is not complete geometric formalization.

## Validation

The guarded Introduction build passed:
`/home/tavis/.cache/othello-lean-build/run-20260908-002311-71dd915c`.
The target compiled in 27.79 seconds with peak 2,037,280 kB after the
runner restored Mathlib cache. Its aggregate trace check passed.
The full axiom audit and source/PDF/export checks are recorded below after
completion.

## Source review

The complete modified Introduction module was read, including all unchanged
public statements. The added docstring states the mathematical domain and
trust boundary; no private workflow identifier or assumed conclusion is
introduced. The existing occurrence-indexed provider and projective-bundle
structure were inspected at their definitions and use sites. The theorem
uses the natural-number count, where multiplication by two preserves
positivity, rather than silently assuming this for every additive group.
The axiom-audit addition is a print command for the exact public terminal.
The source-only gate scans the bundled sources and registration boundaries;
this work does not claim a fresh specialist semantic audit of every old
geometric interface in the 186-source package.

## Mystery ledger — ej + tt

The cheap extension is the unstabilized conclusion from the same
four-dimensional proof, using rationality persistence; it is included.
The nontrivial boundary is the target monoid: doubling need not preserve
nonzero values in an arbitrary group with torsion. Choosing the actual
natural-number count closes that issue without adding a cancellation
hypothesis unrelated to the manuscript. No unexplained algebraic step
remains. The next formalization target is the connection from the main
persistence argument to the existing formal-germ cluster theorem, whose
geometric input boundary is recorded in the preceding audit.

## Kernel audit result

The full reviewer audit built successfully through the guard at
`/home/tavis/.cache/othello-lean-build/run-20260908-002510-5b39f70f`
(11.70 seconds; peak 2,067,320 kB), with its aggregate trace check passed.
The captured output reports 319 terminals. The new terminal's exact axiom
list is `propext, Classical.choice, Quot.sound`; all 318 existing lists
match the prior expected file. The expected row was populated from the
observed kernel output, not inferred from the proof tactics.

Both source-only and captured-axiom-log correspondence checks pass:
186 sources, 319 reviewer terminals, 62 claims, 83 machinery terminals;
coverage counts remain 9 absent, 25 fragment, 27 conditional, 1 complete.
Only `cor:threefold-marker` required a reviewed terminal-digest refresh.
No manuscript hypotheses or printed conclusions changed.

Captured audit output SHA-256: `3a5ae22f32ea1b41ec1cae6bc803541a8888e05c07fc4d0e43114715e6001fea`.
Its exact path is `/home/tavis/.cache/othello-lean-build/run-20260908-002510-5b39f70f/logs/TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit.quiet/20260908-002511-2ab13640/20260907-172518-taskset-c-20-23-choom-n-1000-time-v-nix-develop-command-bash-lc-export-LEAN_NUM_T/stdout.log`.
