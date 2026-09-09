# C1130 — runnable WASM Evolve reductions

PRIVATE — NOT TO SHIP. 2026-09-08.

Core commit b5e2210; private implementation 2046e91. Canonical WASM uses the
shared Rust ranked evolution driver through a bounded proposal binding. The
private browser consumer searches integer resource weights, independently checks
necessary resource inequalities, and skips only configurations excluded by those
checks. Baseline answers validate exclusions and remaining answers; they are not
used to discover candidates. Native production kernels and provider payloads are
unchanged.

The 72 CPU/GPU-job model has a 17×17 capacity grid, fixed transfer capacity 36,
and target 36. A run evaluates 57 parameter candidates and admits two bounds:
42 seed exclusions plus 36 additional evolved exclusions, 78/289 total, leaving
211 forward solves. These are capacity configurations, not scheduler DP states.
This discovers parameters within a fixed inequality family, not arbitrary rules.
Browser timings include preparation, discovery, checking and rendering; observed
single-pass comparisons varied from slightly slower to faster. No stable speedup
claim is made.

Preview: http://127.0.0.1:8769/evolve (also 8770). Both servers now bind 0.0.0.0
at user request. Initial view is a clearly labelled saved snapshot; Run comparison
starts fresh WASM execution. Stop preserves partial evidence at query boundaries.
Native telemetry remains separately selectable. Trace import does not itself
recheck mathematical authority.

## Retained evidence and replay

Private `analysis/campaign-console/data/evolve-capacity-comparison.json` SHA256:
835dd91f763ec4b3b124817947a9c56ae126d9240e6d1d4de28382b909e15db2.
Canonical WASM payload SHA256:
b9df85fa7a2f4d9abff378adce198e871858cb217d72cf3fe81267a5aa441903.

From ergodis-private:
```
nix shell nixpkgs#nodejs --command node analysis/campaign-console/mockups/capacity-reduction.test.mjs
nix shell nixpkgs#nodejs --command node analysis/campaign-console/mockups/replay-evolve.mjs
nix shell nixpkgs#nodejs nixpkgs#chromium --command node analysis/campaign-console/mockups/run-smoke.mjs --url http://127.0.0.1:8769/ --shot /home/tavis/.cache/ergodis/application-workspace/evolve-final.png
```

Independent enumeration checks 14,636 excluded cases. Receipt replay rechecks
hashes, model scope, inequalities and 78 disjoint exclusions, not wall-clock time
or provider optimality. Full browser suite passes, including actual live run,
zero-benefit/all-infeasible controls, stop, saved default and existing application
workflows. Final browser log: `/tmp/claude-run-quiet/20260908-205138-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-run-smoke.mjs-url-127.0.0.18/stdout.log`.
Core fmt/clippy/all-feature tests including Python parity, separate WASM binding
native tests/clippy, and canonical wasm-pack release build pass.

Next C1130: campaign integration, reuse of checked discoveries and additional
reduction families. Full WASM parity and production module ABI gates remain open.
