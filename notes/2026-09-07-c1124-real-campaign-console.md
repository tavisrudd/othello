# C1124 — Real-workload Ergodis campaign console

Date: 2026-09-07. Lane: `ergodis`. Status: complete.
Private commits: `10a465b`, `9d75d53`, `de4f4fd`.
Current native core built: `67d929b0bf8f0be371911dd8d9cc52b193cd3d28`.

## Result and user direction

The user supplied the older Ergodis Campaign Console artifact, asked for that
operator interface instead of the infographic-style demo, and explicitly
required real problems rather than toy examples. The recovered console is now
the documented private demo entry. Launch from `ergodis-private` with
`make -C analysis/campaign-console demo`; choose PORT when its default is busy.
It builds current native binaries, creates a new bounded research campaign,
and serves the console with the controller connected. Ctrl-C closes its owned
services. No core, solver, WASM or old tutorial source was changed by this task.

The existing C1031 source was recovered from committed branch
`c1031-ergodis-viz` at `ae22d015b9153551ab052990d66fc83730f138ad`, exact
`tools/c1031-viz` files. Its reader, evaluator comparison, static/live browser
gates and template were carried forward. The 17 MiB browser export supplied
by the user was a visual reference, not imported current evidence.

Owned implementation: private `analysis/campaign-console/` plus the two private
README entry pointers. Root task routing/report/handoff files are also owned.
The console offers Lineage, Archive, Space, Cascade and Replay, with campaign
context, operator/counter rail, selected-plan inspector, filtering and zoom.
The next-generation hindsight fragments/compositions are exposed separately
in Archive with their original replay obligations. A built/finished view says
saved run; a successful read-only native controller connection says connected.
Transport epoch, source checkout, executable hash and corpus identity remain
explicit. Daemon-reported unknown commit is not overwritten with a checkout ID.

## Real workload and observed result

Input: C1016 order-2092 Hadamard g=133 exact q2 excluded-cell corpus, v4.
225 computed cells, 30 named features, 15,724,800 weighted roots; the originating
report records 352,512 weighted exclusions. Exact input bytes and provenance
are committed under `analysis/campaign-console/data/`, with SHA-256 values in
its README. This task preserves the precomputed research corpus; it does not
regenerate or independently certify the C1016 mathematical labels.

The current native engine starts from ten mechanically generated comparison
seeds over the actual named fields. The accepted demonstration run evaluated
19,997 candidates under a 20,000-candidate/12-generation/beam-64 bound. It
recorded 178 behavior classes, 626 corpus-perfect candidates, 64 supplemental
hindsight records, and two evaluator traces. The selected plan is
`base_sumset_pairs == hole_covered_pairs`, found at generation one. Its score
is 15,724,800 of 15,724,800 weighted roots, versus a 97.8% majority baseline.
The browser's independently implemented evaluator matches that recorded score
with zero cell disagreements. No held-out batch is supplied for this workload.

These are demonstration-run observations over this corpus, not a new theorem,
benchmark ranking, generalization claim, pruning admission or solution of the
order-2092 existence problem. The g41 cascade/cost data retained from the old
console is a named historical reference, not this run's performance evidence.

## Validation and compatibility fixes

`make -C analysis/campaign-console check RUN=<fresh persistent directory> PORT=<free port>`
builds the current native binaries and runs all gates. Final accepted run:
`/home/tavis/.cache/ergodis/c1124-final`. Logs, launch responses, generated seeds,
full engine evidence and executable hashes live there and are regenerable from
committed source/input. The current dynamic preview uses port 8767 because
8765 was already occupied; the other service was left untouched.

Passed:

- Data reader: 20/20 adversarial and sampling checks, including incomplete tails,
  damaged middle records, no-candidate records, empty evidence, ancestry closure,
  class preservation and full-file aggregates. Copies now use persistent cache.
- Current Rust VM differential: 178 generated plans agree, zero disagreements;
  22 are refused by Rust (13 empty-scope admission errors and nine overflows).
  Nine overflows also reject in the page. This is evaluator agreement on
  admitted plans, not an assertion of identical front-end admission surfaces.
- Actual Chromium static and live pages: every tab, selected-plan recomputation,
  current workload/provenance, correct transport epoch, saved/connected state,
  hindsight records and both trace panels pass. No page errors or horizontal
  overflow. The final live-preview gate also passes after all changes.
- The final graph draws 3,199 of 19,997 candidates with 3,194 drawn edges; the
  archive contains all 178 classes and Space evaluates all 225 objects.
- `git diff --check` passes. No Rust source changed, so no solver performance,
  native core parity or WASM rebuild gate is claimed. Cache GC passed dry-run;
  nothing deleted. The source, input corpus and documentation are committed.

The adapter had to distinguish current evidence headers/summary/hindsight rows
from normal candidate rows; evidence discovery now uses schema instead of an
old filename prefix. It preserves the actual returned launch bounds rather than
assuming requested bounds. The launcher checks `ok` on controller envelopes,
requests bounded larger status responses, and uses row indexes for trace calls.
Those repairs exposed and removed formerly silent partial status/trace failures.

Final principal run-quiet captures:
`20260907-161339-make-C-campaign-console-check-c1124-final-PORT8766` (full gate),
`20260907-161446-...datatest...` (persistent-cache reader),
`20260907-161816-...bake_run...` (closeout static), and
`20260907-161842-...smoke...` (closeout served preview).
Exact replay commands and bounded parameters are in the private console README
and Makefile. The raw generated page/evidence is outside Git; committed inputs,
runner and gates are the reproducibility authority for this software demo.

## Closeout and remaining demo work

Visual closeout caught two inherited sampled-count errors: the headline candidate
denominator and inspector class membership used drawn nodes instead of the full
evidence file. They now use full counts; per-node children are explicitly drawn
children, and generation captions identify the drawn subset. Both static and
served browser tests now assert the full-count behavior; fixed in `de4f4fd`.

Mystery ledger: no mathematical mystery or incidental discovery arose. The
initial one-class mismatch occurred in an evidence-byte-limited pilot; its precise
internal cause was not audited; the final
accepted run has 178 logged classes and 178 daemon-reported classes. Those
sources remain separately labelled. The task does not audit engine stop-policy
or claim a new insight from rediscovering the corpus's exclusion relation.

The task-owned preview is at `http://127.0.0.1:8767/`, serving the final saved run.
Its current PID is recorded in `c1124-final/preview.pid`; startup/request output
is in `preview.log`. It is read-only and intentionally remains running for user
review. `make demo` runs a new campaign and keeps a current controller connected.

Recommended successor: select and allocate a second real application workload,
preferably a recovery/helper-cost or QEC decoding case demonstrating a capability
other than predicate discovery. That is a pre-allocation gate, not an invented
C-ID. C1124 already supplies the live candidate-lineage demonstration previously
listed as C1033's next step; do not rebuild that same slice in a notebook merely
because it remained on an older task card.

Operational correction: an initial `head` of the minified outer artifact exceeded
the output budget. That output was not inspected; bounded iframe extraction and
browser rendering replaced it. Source remained on disk; the command-shaping
failure was also recorded in `demo-reference/read-failure.txt`.
