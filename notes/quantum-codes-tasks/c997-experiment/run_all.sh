#!/usr/bin/env bash
# C997 experiment driver. Every solve is pinned to one core and one solver
# thread, so wall times are comparable and CBC is deterministic.
set -u
cd "$(dirname "$0")" || exit 1

CPU="${CPU:-20}"
GROSS="uv run --with mip --with bposd --with numpy python gross_distance_experiment.py"
PASS="uv run --with mip --with numpy python passant_distance_experiment.py"

# wait for any already-running baseline to finish
while pgrep -f gross_distance_experiment.py >/dev/null 2>&1; do sleep 10; done

echo "=== gross global (no symmetry breaking) ==="
taskset -c "$CPU" $GROSS --mode global --out results_gross_global.json \
    --log-dir logs --max-seconds 600

echo "=== gross symbreak ==="
taskset -c "$CPU" $GROSS --mode symbreak --out results_gross_symbreak.json \
    --log-dir logs --max-seconds 600

echo "=== passant group check ==="
taskset -c "$CPU" $PASS --mode check-group --out results_passant_group_check.json \
    --log-dir logs

echo "=== passant baseline ==="
taskset -c "$CPU" $PASS --mode baseline --out results_passant_baseline.json \
    --log-dir logs --max-seconds 600

echo "=== passant symbreak ==="
taskset -c "$CPU" $PASS --mode symbreak --out results_passant_symbreak.json \
    --log-dir logs --max-seconds 600

echo "=== passant symbreak2 ==="
taskset -c "$CPU" $PASS --mode symbreak2 --out results_passant_symbreak2.json \
    --log-dir logs --max-seconds 600

echo "=== done ==="
