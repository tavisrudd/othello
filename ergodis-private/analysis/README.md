# Analysis surfaces

Two ways to look at Ergodis work from outside the Rust: SQL over the evidence
that already exists, and a notebook that can start a search, watch it, and steer
it. Both are read-and-drive layers, not new instrumentation: nothing here adds a
line to the Ergodis core, and nothing here is evidence for a paper-facing claim.

## SQL over the evidence tree

    analysis/ergodis-sql                        # interactive shell
    analysis/ergodis-sql -c "select * from ab_summary"

`ergodis_catalog.sql` defines read-only DuckDB views over `evidence/`,
`examples/data/`, and any campaign run directory. DuckDB comes from nixpkgs
through `nix shell`; nothing is installed into the profile and nothing in the
tree is written.

| View | What it covers |
|-------------------------|---------------------------------------------------------------|
| `bench_raw`, `bench`    | every interleaved benchmark TSV, one canonical seconds column  |
| `ab_slots`, `ab_pairs`  | the two arms of each comparison, paired observation by observation |
| `ab_summary`            | geometric-mean time/cycle/instruction ratio and paired `t`      |
| `campaign_batch_lines`  | every line of every campaign JSONL under `examples/data/`       |
| `campaign_batch_header` | the feature-batch headers                                       |
| `campaign_batch_row`    | the labelled feature rows                                       |
| `certificates`          | each JSON certificate as a JSON value                           |
| `certificate_index`     | candidate, parameters, certified distance, conclusion, boundary |
| `native_scale`          | the native scaling JSONL records                                |
| `run_ledger`, `run_manifest` | macros over a campaign run directory, live or finished     |

In `ab_summary`, a `time_geomean` below one means `arm_b` was the faster arm.
Arms are named in every row, so the direction never has to be inferred.

## The notebook

    analysis/ergodis-notebook

Opens JupyterLab on `analysis/notebooks` with the `ergodis_notebook` package
importable. Dependencies come from `uv`, so the first run resolves them into
uv's cache and later runs start immediately.

`analysis/notebooks/solve-monitor.ipynb` is the worked example: it starts a
campaign, runs the C880 aligned-attachment search under it, watches the search
live, activates an ordering plan while the search is still running, and then
reads the run back as SQL.

The package itself:

* `Campaign.launch` / `Campaign.attach` -- the control plane, with every control
  op available as a method and the ledger readable while the run is live;
* `alignment_search` and `Solve` -- start a search that attaches to a campaign
  and streams progress snapshots; `run_json` for ordinary one-shot workflows;
* `Monitor` -- one updating cell, and the collected snapshots afterwards as a
  flat DataFrame;
* `plan` -- build candidate plans and lower them to the bytecode the socket
  accepts; and
* `open_catalog` -- the same DuckDB views as the shell, from the same SQL file.

Run the whole path without a notebook:

    uv run --with duckdb python3 analysis/check_notebook_integration.py

## Three things that bite

**Run directories must be short.** A controlled search binds its watcher
datagram socket *inside* the run directory, and Unix socket paths are capped at
108 bytes. A run directory under a deep working path makes the search fail at
startup with "the optional search controller rejected a safe-point operation",
which says nothing about paths. `Campaign.launch` checks the length up front;
the default run root is under `$XDG_RUNTIME_DIR`.

**The socket accepts bytecode plans only.** A plan document exists in a readable
expression form and a flat stack-machine form, but `candidate-try` and
`candidate-apply` deserialize the bytecode form and reject the expression form
with "unknown field `expr`". `plan.plan(...)` lowers expressions on the client
side, with the same node and depth limits as the core.

**A scope mask is a membership bitset**, indexed by the field's value, not a
bitwise AND mask. Scoping to `root_orbit == 6` sets bit 6, giving mask 64 --
under the AND reading it would mean the opposite. Pass values to
`plan.plan(scope=("root_orbit", [6]))` and let it build the mask.
