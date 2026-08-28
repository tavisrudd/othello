#!/usr/bin/env bash
set -euo pipefail

ergodis_bin=${1:?usage: observational-sota-ab.sh ERGODIS_BIN MATA_BIN [ROUNDS] [REPETITIONS] [CPU]}
mata_bin=${2:?usage: observational-sota-ab.sh ERGODIS_BIN MATA_BIN [ROUNDS] [REPETITIONS] [CPU]}
rounds=${3:-7}
repetitions=${4:-1}
cpu=${5:-2}

for binary in "${ergodis_bin}" "${mata_bin}"; do
  if [[ ! -x ${binary} ]]; then
    echo "not an executable: ${binary}" >&2
    exit 2
  fi
done
export LC_ALL=C

cases=(
  "chain 131072 1 2"
  "random 131072 4 2"
  "colors 131072 4 256"
)

run_one() {
  local implementation=$1 family=$2 states=$3 generators=$4 outputs=$5 round=$6
  local binary
  case ${implementation} in
    ergodis) binary=${ergodis_bin} ;;
    mata) binary=${mata_bin} ;;
    *) return 2 ;;
  esac
  echo "BEGIN ${implementation} ${family} round=${round}" >&2
  taskset -c "${cpu}" "${binary}" \
    "${family}" "${states}" "${generators}" "${repetitions}" "${outputs}"
  echo "END ${implementation} ${family} round=${round}" >&2
}

printf 'implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional\n'
for case_spec in "${cases[@]}"; do
  read -r family states generators outputs <<<"${case_spec}"
  for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
      run_one ergodis "${family}" "${states}" "${generators}" "${outputs}" "${round}"
      run_one mata "${family}" "${states}" "${generators}" "${outputs}" "${round}"
    else
      run_one mata "${family}" "${states}" "${generators}" "${outputs}" "${round}"
      run_one ergodis "${family}" "${states}" "${generators}" "${outputs}" "${round}"
    fi
  done
done

echo OBSERVATIONAL_SOTA_AB_DONE >&2
