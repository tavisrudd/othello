# C815 two-hour closure attempt

## Result

The two-hour target did not finish C815, the Paper III export, and the C968
adapter.  The initial status description understated C815: its live acceptance
surface still contained an analytic integral theorem, three geometric/arithmetic
interfaces, a weighted-Jacobian bridge, and aggregate manifest closure.  Those
are independent proof obligations, not export formatting.

Two coherent formal advances landed:

1. Commit `0613bfa6e` completes the paused spherical-cubic continuation.  The
   generic theorem
   `RelativeConicArcs.CubicEqualityPattern.sum_coefficient_mul_of_sum_eq_zero`
   proves that an equality-pattern cubic contracts on the sum-zero hyperplane
   as `(a-3b+2c) Σ yᵢ³`.  The Paper III harmonic module uses its reversed-index
   corollary to prove the exact rational general-weight Clebsch identity.
2. Commit `281d08b9a` introduces
   `RelativeConicArcs.TraceSplitQuadraticAlgebra`.  It formalizes
   `R[z]/(z²-d)`, its generator equation, evaluation at the split roots after
   `d=a²`, and surjectivity onto the split pinching algebra when two is
   invertible.

No `sorry`, `admit`, native decision, generated certificate, project axiom, or
manual `lean`/`lake` invocation was introduced.  Unrelated staged and trust-map
work in the shared tree was left untouched.

## Validation

All Lean work used the repository guards.

```sh
lean/scripts/guarded-lean RelativeConicArcs/CubicEqualityPattern.lean
lean/scripts/lean-build-queue.py build RelativeConicArcs.CubicEqualityPattern --cores 20-23
lean/scripts/guarded-lean RelativeConicArcs/SphericalCubicRestriction.lean
lean/scripts/lean-build-queue.py build RelativeConicArcs.SphericalCubicRestriction --cores 20-23
lean/scripts/guarded-lean RelativeConicArcs/TraceSplitQuadraticAlgebra.lean
lean/scripts/lean-build-queue.py build RelativeConicArcs.TraceSplitQuadraticAlgebra --cores 20-23
```

The final runs were warning-free and green.  The corresponding build-queue
run identifiers were `20260826-044420-a095fb0b`,
`20260826-045239-335a6f56`, and `20260826-051535-4a2b9bee`.

## Rejected proof shape

The restored harmonic continuation initially expanded all `5³` coefficient
terms.  Lean reached a deterministic kernel timeout after nine minutes even
with a local one-million-heartbeat budget.  That shape was removed.  The landed
proof separates the all-distinct, pair-equality, and all-equal sectors and
factors their sums symbolically; no enlarged heartbeat setting remains.

## Exact remaining gates

1. Prove that `normalizedMean` agrees with normalized surface integration.
2. Instantiate the trace-split algebra at `z²=5J0` and formalize the chart
   comparison used by the manuscript.
3. Formalize the complete reduced fibre and a definition-level spinor API.
4. Formalize the normalized marked incidence pullback and its deck/geometric
   identification.
5. Kernel-check the reduced eight-by-five weighted-Jacobian calculation and its
   equivariant bridge.
6. Attach the new modules to the Paper III gates; regenerate and replay the
   source closures, axiom reports, formal maps, and release verifier.
7. Only then generate the paper-owned sparse-shadow export and implement the
   Paper III C968 adapter.

The current formal manifests and note-local finite censuses are not a substitute
for the missing paper-owned export.  No export or Rust Paper III implementation
was emitted in this attempt.

## One-hour extension

The follow-on hour tested the paper-specific ARITH-1 continuation.  The chosen
interface specialized the green trace-split core to `5 J0`, proved the chart
coefficient identities

```text
5 J0 |chart = 80 sigma3^2 = (4 sqrt(5) sigma3)^2,
```

and reused the core split comparison at the final square.  An earlier,
stronger experiment also constructed evaluation after an arbitrary ring-map
base change.  That stronger presentation was discarded because its dependent
pinching codomain elaborated poorly; a product-ring variant was tested as
well.

None of these experimental declarations landed.  Every prescribed guarded
check ended with process exit `137` and no Lean diagnostic.  The serialized
build-queue retry, run `20260826-062836-d2ba0876`, was likewise killed with
exit `137` while reporting a peak of roughly 439 MB.  During these runs the
host reported about 25 GiB used out of 26 GiB with no swap.  The unchecked
source was removed rather than committed.  This is a transient validation
resource failure, not a mathematical counterexample and not a claim that
ARITH-1 is closed.

The extension therefore did not change the exact remaining-gates list above.

## `ej` + `tt` closeout

The harmonic failure exposed a reusable invariant-theory lemma: the computation
was a power-sum identity over every finite type and commutative ring, not a
five-coordinate calculation.  Formalizing that stronger statement both removed
the timeout and made the coefficient convention explicit.  The arithmetic pass
likewise separated the universal quadratic-algebra/pinching mechanism from the
still-unproved geometric assertion at `5J0`; this prevents an algebraic model
from impersonating the manuscript's Stein comparison.

The task should not again be estimated as “create the export, then wire Rust.”
Its critical path is formal proof closure followed by a paper-owned authority
bundle.  The next highest-value move is the analytic sphere-integral bridge,
because the prescribed C815 order keeps the harmonic cluster ahead of the
paper-specific arithmetic and gate edits.

## Mystery ledger

- **Why the paused HARM-2 proof timed out:** settled.  It expanded 125 terms;
  the equality-sector/power-sum proof replaces it and is green.
- **Whether the factor `a-3b+2c` is five-point-specific:** settled.  The theorem
  holds for every finite index type over every commutative ring.
- **What ARITH-1 already proves:** settled.  The universal trace-split algebra
  and split pinching comparison are formal; the geometric `5J0` identification
  is still open and is not claimed.
- **Why the Paper III export remains absent:** settled.  paper-local manifests
  and note-local census files do not form the required authoritative combined
  branch-fibre/aligned-four-set export.
- **Remaining genuine mysteries:** the analytic identification and geometric
  chart/fibre/orientation comparisons remain exact C815 proof gaps.  They are
  owned by C815; no external person or service blocks them.
