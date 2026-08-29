#!/usr/bin/env bash
# C997 phase 2: corrected passant formulation (code = kernel of the incidence
# matrix) plus a longer-capped control run of the unbroken global gross model.
set -u
cd "$(dirname "$0")" || exit 1

CPU="${CPU:-20}"
GROSS="uv run --with mip --with bposd --with numpy python gross_distance_experiment.py"
PASS="uv run --with mip --with numpy python passant_distance_experiment.py"

echo "=== passant group check ==="
taskset -c "$CPU" $PASS --mode check-group --out results_passant_group_check.json --log-dir logs

echo "=== passant baseline ==="
taskset -c "$CPU" $PASS --mode baseline --out results_passant_baseline.json \
    --log-dir logs --max-seconds 1800

echo "=== passant symbreak ==="
taskset -c "$CPU" $PASS --mode symbreak --out results_passant_symbreak.json \
    --log-dir logs --max-seconds 1800

echo "=== passant symbreak2 ==="
taskset -c "$CPU" $PASS --mode symbreak2 --out results_passant_symbreak2.json \
    --log-dir logs --max-seconds 1800

echo "=== gross global control, longer cap ==="
taskset -c "$CPU" $GROSS --mode global --out results_gross_global.json \
    --log-dir logs --max-seconds 2400

echo "=== done ==="
