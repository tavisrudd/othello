#!/usr/bin/env bash
set -euo pipefail

optimized_bin=${1:?usage: observational-composition-ab.sh OPTIMIZED_BIN [ROUNDS] [CPU] [CACHE_ROOT]}
rounds=${2:-11}
cpu=${3:-2}
cache_root=${4:-${ERGODIS_BENCH_CACHE:-${XDG_CACHE_HOME:-/var/tmp}/ergodis}}
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ergodis_root=$(cd -- "${script_dir}/.." && pwd)
repo_root=$(git -C "${ergodis_root}" rev-parse --show-toplevel)
relative_root=${ergodis_root#"${repo_root}"/}
patch_file=${ergodis_root}/benches/disable_composition_reduction.patch
target_dir=${cache_root}/composition-baseline-target

if [[ ! -x ${optimized_bin} || ${relative_root} == "${ergodis_root}" ]]; then
  echo "expected an optimized executable inside the ergodis repository" >&2
  exit 2
fi
mkdir -p "${cache_root}" "${target_dir}"
snapshot=$(mktemp -d -p "${cache_root}" composition-baseline-source.XXXXXXXX)
case ${snapshot} in
  "${cache_root}"/composition-baseline-source.*) ;;
  *) echo "unsafe snapshot path" >&2; exit 2 ;;
esac
cleanup() { rm -rf -- "${snapshot}"; }
trap cleanup EXIT

git -C "${repo_root}" archive HEAD "${relative_root}" | tar -x -C "${snapshot}"
baseline_root=${snapshot}/${relative_root}
patch -s -d "${baseline_root}" -p1 < "${patch_file}"
CARGO_TARGET_DIR=${target_dir} cargo build --quiet --release \
  --manifest-path "${baseline_root}/Cargo.toml" --example observational_sota_driver
baseline_bin=${target_dir}/release/examples/observational_sota_driver

printf 'implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional\n'
for ((round = 0; round < rounds; round++)); do
  taskset -c "${cpu}" "${baseline_bin}" composed 131072 16 1 2 adaptive-deferred
  taskset -c "${cpu}" "${optimized_bin}" composed 131072 16 1 2 adaptive-deferred
done
