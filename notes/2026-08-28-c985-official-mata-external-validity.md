# C985: official MATA-corpus external-validity benchmark

Date: 2026-08-28

## Verdict

Ergodis' observational compiler now has a genuine external application
benchmark.  On all 169 instances in MATA's published TACAS'24 explicit
Presburger-complement input list, both systems minimized the same derived,
trimmed deterministic automaton.  Ergodis achieved a 2.699x geometric-mean
speedup over MATA's C++ `minimize_hopcroft`, with an instance-level paired-log
`t=26.20`.  It won 158 instances and lost 11.  Every loss had only 2--12 DFA
states; ergodis won every instance with at least 13 states.

This is external validity for exact deterministic contextual minimization, not
an end-to-end claim on MATA's original complement benchmark.  MATA performed
the one-time NFA determinization and trimming for both systems outside the
timed region.  Parsing was also excluded.  The comparison isolates the shared
minimization problem and avoids pretending that ergodis currently replaces
MATA's NFA algorithms.

## Official sources and pinned revisions

- MATA: `e8c9310e389b1e62ece7080956550f70ceeed777`.
- `VeriFIT/nfa-bench`: the exact comparison submodule revision
  `94f2863ec7e76f53236c564e67f2f76b355f00d8`.
- `VeriFIT/mata-comparison`:
  `c6781872ddfa589969d28289e4add73d2359b7d0`.
- Published input list:
  `inputs/bench-single-presburger-explicit-complement.input`, SHA-256
  `145574a179dfde0f5f6daf35866e894c754d65399036b10d84d9ba128dc610fd`.

The official corpus describes automata arising from Presburger/LIA decision
procedures, with inputs sourced from Ultimate Automizer and TPTP.  No instance
was selected or removed: 169 were attempted, 169 prepared, and 169 measured.

## Semantic adapter

`ExplicitMataDfa::parse` is a production library adapter for the explicit
format emitted by MATA.  It maps:

- one DFA state to one ergodis concrete state;
- accepting status to the Boolean observation;
- one alphabet symbol to one unary context generator; and
- absent partial-DFA transitions to one explicit rejecting sink.

Consequently ergodis computes the Myhill--Nerode quotient as an instance of
its more general exact observational quotient.  The parser rejects malformed
sections, multiple initial states, overflow, and nondeterministic transitions.
Only five of the 169 prepared DFAs required the totalizing sink.  For those
instances the checker requires the ergodis quotient to contain exactly one
additional rejecting-sink class; otherwise it requires exact class-count
agreement.

The compiler uses `SplitTranscript`: its timed result includes quotient
construction, compact proof emission, and independent replay.  MATA returns
the minimized automaton without a proof transcript.

## Measurement design

- Both executables consume the identical serialized trimmed DFA.
- NFA parsing, determinization, trimming, and DFA parsing occur before timing.
- Each instance uses enough internal repetitions to target 10 ms, capped at
  10,000 repetitions.
- Fifteen process-level rounds alternate adjacent MATA/ergodis order.
- Each record retains all raw per-operation timings, class counts, source and
  derived hashes, repetition count, geometric-mean speedup, and paired-log
  t-score.
- The suite statistic is the geometric mean of the 169 instance speedups.  Its
  t-score treats instances, rather than repeated timings, as the sampling
  units; corpus correlations still make it supporting evidence rather than a
  universal performance theorem.

## Results

| DFA state stratum | Instances | Ergodis wins | Geometric-mean speedup | Median speedup |
|---|---:|---:|---:|---:|
| 2--12 | 15 | 4 | 0.854x | 0.951x |
| 13--31 | 13 | 13 | 3.310x | 3.398x |
| 32--127 | 10 | 10 | 4.237x | 4.719x |
| 128+ | 131 | 131 | 2.915x | 2.809x |
| **All** | **169** | **158** | **2.699x** | **2.809x** |

The measured speedups span 0.291x--17.339x.  The largest derived automaton has
937 states and 479,744 transitions; ergodis is 17.339x faster on that instance.
The small losses are consistent with fixed transcript construction and replay
overhead dominating tiny automata.  From 13 states onward the exact proof-
carrying path wins every measured instance.

## Reproduction and evidence

Run `scripts/mata-official-ab.sh` with clones at the three pinned revisions.
Derived DFAs and build products stay under `/home/tavis/.cache` by default;
the repository retains only the compact 214,435-byte JSON evidence.

SHA-256:

- evidence: `d9388a99aed96d2e4eebd61d950a732f5c61057cc50d2f25d7e933747fc34bc2`;
- MATA driver source: `452a6e747b88ad7fa713f80666ef92153c4ea457b4707f92be8c66341605c72a`;
- ergodis driver source: `b15f1edc22772c6ff5d555ad66cbe08c50c9d944d2d769db2f30e19c03b4f336`;
- runner: `3ad3181f3d17989b42c0bbbe258799e0ce4af08dc602565212b0ab22d8c709e5`;
- checker: `52ec7aed07f49194ca0828862b74d41aedbf7edb42f04ad4117c5f6d8239fec9`;
- reproduction shell: `2f16194036bbc090041aae1ce8b1c4ba88cf3475f986d60e0389d907f22d1a87`.

## Consequence

The earlier synthetic chain/random comparison established algorithmic and
engineering competitiveness.  This corpus result removes the larger framing
objection: ergodis' shared observational kernel is effective on states and
transition structures produced by an unrelated mature application pipeline.

The next external target should exercise a feature beyond Boolean DFA
minimization—native multi-output machines, restricted context languages, or
weighted/Pareto observations—where ergodis' generalized interface is not only
a proof-carrying implementation of a classical special case.
