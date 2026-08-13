# C910 partial Lean release checkpoint

## Verdict

The cubic-stabilization Lean companion is suitable for an explicitly partial
public checkpoint.  It is not a complete formalization of the paper and makes
no such claim.  Its value at this stage is a kernel-checked algebraic spine plus
a rejecting, manuscript-wide account of everything still outside Lean.

The authoritative package is
`papers/cubic-stabilization-epilogue/lean/`.  No duplicate shared Lean source
tree was created.

## Exact coverage

The checker inventories every labelled theorem-like manuscript environment and
currently reports:

- 23 manuscript claims;
- 28 reviewer-facing terminals;
- 7 absent claims;
- 13 fragmentary claims;
- 3 conditional deductions;
- 0 complete claims.

Every non-absent row records the represented objects, hypotheses, conclusion,
and cautions.  Every conditional application exposes its external geometric or
quantum input in its theorem type.  The checker rejects missing or duplicate
manuscript labels, unresolved or multiply registered terminals, stale public
coverage counts, mismatches between interface terminals and axiom commands,
and mismatches between those terminals and the expected axiom table.

## Kernel-checked surface

The current fragments establish:

- division-free two-coordinate rank-one assembly from the midpoint inequality;
- the factorial square-zero divided-power expansion;
- the `6I-J` eigenspace calculation, explicit two-sided integral Smith
  transformations to `diag(1,6,6,6,6)`, and exact depth one at two and three;
- primitive-sixth multiplicity for supplied finite framed-monodromy matrices;
- compatible pro-Laurent gauge and characteristic-polynomial inverse systems;
- characteristic-polynomial transport under coefficient extension and
  invertible conjugacy;
- the matrix consequence of a supplied formal base-shift comparison;
- finite numerical-Novikov fibers and additive coefficient pushforward;
- the algebraic/topological core of strict Novikov admissibility and injective
  divisor-tag pairing;
- rank scaling and block additivity of primitive-sixth multiplicity;
- typed blowup and blowdown links with explicit center contributions, their
  dimension-four vanishing telescope, and the downstream conditional
  irrationality deductions;
- factorization of Cai's displayed rank-two indicial polynomial and the two
  resulting primitive-sixth framed eigenvalues.

## Acceptance evidence

- All 17 declared Lean roots passed as separate guarded build targets.
- A detached clean worktree at commit `a3c726bf` built the aggregate library
  and axiom-audit target from an empty package build directory; both source and
  transcript checks then passed, and the worktree remained clean.
- The public source-only gate passed with the exact counts above.
- The captured `#print axioms` transcript passed exact comparison against all
  28 expected rows.
- Kernel dependencies are limited to the explicitly recorded standard Lean and
  Mathlib principles `propext`, `Classical.choice`, and `Quot.sound`; there are
  no project axioms.
- The source checker rejects `sorry`, `admit`, project `axiom`, `opaque`,
  `unsafe`, `native_decide`, `implemented_by`, and kernel-skipping declarations,
  and requires docstrings on public declarations.
- TeX spacing lint passed.  The user's pre-existing uncommitted introduction
  and PDF changes were neither modified nor staged by this checkpoint.

## Referee boundary

The release remains partial precisely where `lean/verification/claims.json`
says it does.  In particular it does not formalize the relative intermediate
Jacobian or six-axis geometry, the full DVR and graph-lattice descent theorem,
the Voisin universal-`CH_0` implication, the quantum differential-module base
change constructions, Iritani's comparison theorems, low-dimensional
vanishing, Cai's block diagonalization, or Kuznetsov's geometry.

## `ej` + `tt` closeout

The closeout found and implemented one free trust upgrade: public coverage
counts are now checked against the live claim map and terminal set, so the
interim README cannot silently overstate later coverage.  It also separated
the arithmetic content of Cai's rank-two block from the still-unformalized
integral-`z` block diagonalization, avoiding an easy but serious attribution
overreach.

The strongest unexpected value is that the explicit Smith reduction removes
all computational ambiguity from the five-axis type and both bad-prime depth
counts.  The remaining obstruction on that side is geometric identification,
not integer linear algebra.  On the quantum side, a coherent reusable finite
matrix layer has emerged, but its input matrices still have to be constructed
from differential modules.

## Mystery ledger

- **Settled — Smith arithmetic.** Explicit integral two-sided inverses certify
  type `(1,6,6,6,6)` and exact depth one at two and three.
- **Settled — release-status drift.** The checker now rejects stale public
  claim and terminal counts.
- **Open — full DVR criterion.** Necessity, arbitrary matrix size, and the
  exact rank-one-generation equivalence remain owned by C910.
- **Open — graph descent.** Localization, prescribed graph-divisor membership,
  finite bad-prime assembly, and faithfully flat descent remain owned by C910.
- **Open — geometric six-axis bridge.** Rosati identification, actual kernel
  slopes, relative persistence, and the universal-`CH_0` consequence require
  exact formal geometric interfaces or foundational proofs in C910.
- **Open — quantum construction bridge.** Differential constants, compatible
  bulk gauges, completed divisor tagging, operation comparisons,
  low-dimensional vanishing, and Cai's full block decomposition remain owned by
  C910.  The present finite-matrix theorems do not discharge these inputs.
- **Settled for the monorepo checkpoint — clean replay.** A detached worktree
  replay built the library and audit and passed both exact check modes without
  changing the checkout.
- **Open — public locator and paper mirror.** This partial checkpoint is
  prepared for a monorepo GitHub push, but the push and byte-for-byte
  paper-repository export have not occurred.  Those remain release actions,
  not mathematical proof gaps, and the final C910 mirror gate is still open.
