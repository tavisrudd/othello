# C1016: additive repair, transferable guidance and remaining structure discovery

Private native work. Order 2092 is a hard test, not the sole target. The August
668 construction provides a known-feasible lower-order control; no published
solution coordinates enter search. The adapter supplies the bordered circulant
model and four additive response groups. Group discovery is not implemented.

## What landed

Private worktree `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`, branch
`c1016-full-2092-campaign`: b1166b6 implements a generic exact finite additive
residual-table optimizer; 258f93c adds cached ranking and alternative region
policies; cd23113 hardens replay and records CPU-budget semantics; 2ac6ab3 banks
453 witnesses, counter samples, source hashes, run manifests and the report.
No public core, WASM demo, production tabu loop or foreign lane was changed.

The kernel minimizes squared norm of a base residual plus one option from each
finite group. Suffix interval bounds safely prune completions. Search is
iterative and allocation-free; response compilation is cold and still allocates.
The adapter generates balanced random inputs and enumerates balanced local
reassignments, using the same code across orders 28–2092.

## Transfer and performance evidence

- All 24 cold starts at orders 28, 44 and 76 solved and independently verified.
- At order 124, three later starts solved: random seeds 202/205 and mixed seed
  201. Pure residual/gain guidance solved none in the eight-seed CPU comparison.
  Twenty-seven verified matrices means successful runs, not inequivalent classes.
- At 668/716/2092, guided policies reduce residual much more than random regions
  under the tested CPU budget, but none solved. At 668 median scores were
  random 4040, residual 1624, gain 1520, mixed 1792 (eight starts, 300 CPU ms).
  At 2092 they were 345872, 32256, 30920 and 70728. These are objective values,
  not distances or existence bounds.
- Widening 20^4 to 70^4 local combinations was worse on 668 at a 500 ms budget.
  Between-round CPU checks allow one-round overrun: maximum 346.96 ms for the
  300 ms comparison and 1089.75 ms for the wide 500 ms probe.
- Three interleaved counter pairs on retained executables: interval pruning
  saved 18.8%/18.1% cycles at one/twelve workers, preserving exact witnesses.
  Caching ranking keys saved a separate 27.3%/24.6%, also identical trajectories.
  These are local busy-host measurements with 82–83% counter running coverage,
  not production confidence or ratios to multiply together.

Full release gate: 772 passed, zero failed, one intentional ignored perf driver.
Latest driver metadata: five scoped tests passed. Generic property tests compare
against an independent Cartesian oracle; an allocation counter checks the solve
loop. All 453 saved outputs independently replay; 27 full matrices verify.
Sixteen malformed mutations reject under normal Python and Python -O.

The standalone private evidence report owns detailed domains, limitations,
commands, hashes and witnesses:
`ergodis-private/evidence/residual-repair/REPORT.md`.
Replay from that worktree:

```
python3 -O analysis/residual-repair/replay.py evidence/residual-repair/witnesses.jsonl
python3 analysis/residual-repair/test_replay.py evidence/residual-repair/witnesses.jsonl
sha256sum -c evidence/residual-repair/SHA256SUMS
```

These runs preserve row sums only. They do not preserve the historical exact
q18/q29 margins, and do not pass the separate randomized-fibre 14,800 gate.
No negative coverage follows from a heuristic miss.

## Next general capability gates

The tested alternatives vary region selection, not discovery of the construction
or additive groups. The next structural comparisons should be explicit:

1. Preserve vector residual IR before squaring. Derive disjoint components from
   term supports and invariant scopes; verify separability or fall back. Validate
   on non-Hadamard models and relabelings, including dense negative controls.
2. Derive coupled invariant-preserving moves from linear maps (circuit-style),
   with small exhaustive controls. Do not assume nonlinear descent guarantees.
3. Turn exact failed local repairs into scope-bound explanations to guide later
   regions. Do not extrapolate a local failure into a global exclusion.
4. Learn useful residual projection directions, but check their Cauchy–Schwarz
   lower bounds exactly. Combine arbitrary bounds by maximum, not addition;
   summation needs an orthogonality/Gram argument.

Price discovery, compilation and checking separately and together. Compare
matched CPU, held-out seeds/orders, success rate and objective quality. An
adaptive portfolio must retain exploration: pressure guidance's larger-order
advantage did not translate into the 124 endgame successes. Wider regions should
be selected only when the expected gain can pay for the exact round.

## Mystery ledger — ej / tt

Settled: repeated ranking calculation was avoidable overhead; wider exact repair
is not automatically better. Open: why pressure misses the small endgame, how to
escape 668/716 plateaus, automatic response-group extraction, and strict-margin
fibre recovery. These are distinct gates; the controls now separate them.
No Hadamard identity, published row payload or source-specific answer was added
to the general table solver. Supplied model structure remains disclosed.
