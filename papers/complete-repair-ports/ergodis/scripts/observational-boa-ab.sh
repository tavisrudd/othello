#!/usr/bin/env bash
set -euo pipefail

ergodis_bin=${1:?usage: observational-boa-ab.sh ERGODIS_BIN BOA_SOURCE [ROUNDS] [CPU] [FIXTURE_DIR]}
boa_source=${2:?usage: observational-boa-ab.sh ERGODIS_BIN BOA_SOURCE [ROUNDS] [CPU] [FIXTURE_DIR]}
rounds=${3:-7}
cpu=${4:-2}
fixture_dir=${5:-${ERGODIS_BENCH_CACHE:-${XDG_CACHE_HOME:-/var/tmp}/ergodis}/boa-fixtures}
ergodis_policy=${ERGODIS_CERTIFICATE_POLICY:-transcript}
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ergodis_root=$(cd -- "${script_dir}/.." && pwd)
fixture_generator=${ergodis_root}/benches/boa_observational_fixture.py
timing_patch=${ergodis_root}/benches/boa-kernel-timing.patch

if [[ ! -x ${ergodis_bin} || ! -d ${boa_source}/.git ]]; then
  echo "expected an ergodis executable and a Boa git checkout" >&2
  exit 2
fi
if [[ ${ergodis_policy} != transcript && ${ergodis_policy} != adaptive \
  && ${ergodis_policy} != adaptive-deferred && ${ergodis_policy} != multiway \
  && ${ergodis_policy} != quotient ]]; then
  echo "ERGODIS_CERTIFICATE_POLICY must be transcript, adaptive[-deferred], multiway, or quotient" >&2
  exit 2
fi
if [[ $(git -C "${boa_source}" rev-parse HEAD) != 54a556448169a83a369e039b5fa3ba27323ccfde ]]; then
  echo "Boa checkout is not the pinned revision" >&2
  exit 2
fi
if ! git -C "${boa_source}" apply --check "${timing_patch}" 2>/dev/null \
  && ! rg -q -m 1 'algorithm_time_s' "${boa_source}/src/main.rs"; then
  echo "Boa source is neither pristine nor patched with the timing boundary" >&2
  exit 2
fi
if git -C "${boa_source}" apply --check "${timing_patch}" 2>/dev/null; then
  git -C "${boa_source}" apply "${timing_patch}"
fi

mkdir -p "${fixture_dir}"
export LC_ALL=C
cases=(
  "chain 131072 1 2"
  "random 131072 4 2"
  "colors 131072 4 256"
)

boa_bin=${boa_source}/target/release/boa
if [[ ! -x ${boa_bin} ]]; then
  cargo build --release --manifest-path "${boa_source}/Cargo.toml"
fi

for case_spec in "${cases[@]}"; do
  read -r family states generators outputs <<<"${case_spec}"
  text_fixture=${fixture_dir}/${family}-${states}-${generators}-${outputs}.boa.txt
  binary_fixture=${text_fixture%.txt}
  if [[ ! -f ${binary_fixture} ]]; then
    nix shell nixpkgs#python3 --command python3 "${fixture_generator}" \
      "${family}" "${states}" "${generators}" "${outputs}" "${text_fixture}"
    "${boa_bin}" convert "${text_fixture}" >/dev/null
  fi
done

printf 'implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional\n'
run_ergodis() {
  taskset -c "${cpu}" "${ergodis_bin}" "$1" "$2" "$3" 1 "$4" "${ergodis_policy}"
}
run_boa() {
  local family=$1 states=$2 generators=$3 outputs=$4 result seconds classes
  result=$(taskset -c "${cpu}" "${boa_bin}" nlogn \
    "${fixture_dir}/${family}-${states}-${generators}-${outputs}.boa")
  seconds=$(awk '/^algorithm_time_s:/ {print $2}' <<<"${result}")
  classes=$(awk '/^n_states_min:/ {print $2}' <<<"${result}")
  awk -v family="${family}" -v states="${states}" -v generators="${generators}" \
    -v outputs="${outputs}" -v seconds="${seconds}" -v classes="${classes}" \
    'BEGIN {printf "boa\t%s\t%s\t%s\t%s\t1\t%.0f\t%s\t-\n", family, states, generators, outputs, seconds * 1e9, classes}'
}

for case_spec in "${cases[@]}"; do
  read -r family states generators outputs <<<"${case_spec}"
  for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
      run_ergodis "${family}" "${states}" "${generators}" "${outputs}"
      run_boa "${family}" "${states}" "${generators}" "${outputs}"
    else
      run_boa "${family}" "${states}" "${generators}" "${outputs}"
      run_ergodis "${family}" "${states}" "${generators}" "${outputs}"
    fi
  done
done
