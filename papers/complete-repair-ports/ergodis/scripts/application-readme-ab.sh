#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
cache_root=${ERGODIS_CACHE_ROOT:-/home/tavis/.cache/ergodis}
venv="$cache_root/application-ab-venv"
mkdir -p "$cache_root"

if [[ ! -x "$venv/bin/python" ]]; then
  nix shell nixpkgs#uv --command uv venv --python 3.12 "$venv"
fi
nix shell nixpkgs#uv --command uv pip install --python "$venv/bin/python" \
  'ortools==9.14.6206' 'graphillion==2.1' 'scipy==1.16.1' \
  'pycryptosat==5.14.7'

python3 "$root/python/run_application_readme_ab.py" \
  --ergodis "$root/target/release/bench_kernels" \
  --python "$venv/bin/python" \
  --raw-jsonl "$root/evidence/c985-application-readme-ab.raw.jsonl" \
  --output "$root/evidence/c985-application-readme-ab.json" \
  --rounds "${ROUNDS:-7}" \
  --timeout "${TIMEOUT_S:-10}" \
  --cpu "${CPU:-3}"

python3 "$root/python/check_application_readme_ab.py" \
  --raw-jsonl "$root/evidence/c985-application-readme-ab.raw.jsonl" \
  --summary "$root/evidence/c985-application-readme-ab.json" \
  --ergodis "$root/target/release/bench_kernels" \
  --bench-source "$root/src/bin/bench_kernels.rs" \
  --python-source "$root/python/benchmark_python.py" \
  --runner "$root/python/run_application_readme_ab.py"
