# Shared helpers for Ergodis benchmark, evidence, and A/B scripts.
# Source, do not execute:  . "$(dirname "$0")/lib.sh"
#
# Build artifacts live in one shared out-of-tree target directory per crate,
# declared by that crate's .cargo/config.toml. Never hardcode an in-tree
# target/release path; ask ergodis_bin instead.

ergodis_cache_root() {
  printf '%s\n' "${ERGODIS_CACHE_ROOT:-/home/tavis/.cache/ergodis}"
}

# ergodis_target_dir <crate-dir>
# Resolve the shared target directory for a crate by honouring
# CARGO_TARGET_DIR, then the nearest ancestor .cargo/config.toml build.target-dir,
# then falling back to the in-tree default.
ergodis_target_dir() {
  local dir
  dir=$(cd "${1:?crate dir required}" && pwd)

  if [[ -n ${CARGO_TARGET_DIR:-} ]]; then
    printf '%s\n' "$CARGO_TARGET_DIR"
    return 0
  fi

  local probe=$dir cfg value
  while [[ -n $probe ]]; do
    cfg="$probe/.cargo/config.toml"
    if [[ -f $cfg ]]; then
      value=$(awk '
        /^[[:space:]]*\[/ { section=$0 }
        section ~ /^[[:space:]]*\[build\]/ && /^[[:space:]]*target-dir[[:space:]]*=/ {
          sub(/^[^=]*=[[:space:]]*/, "")
          gsub(/^"|"$/, "")
          print
          exit
        }' "$cfg")
      if [[ -n $value ]]; then
        printf '%s\n' "$value"
        return 0
      fi
    fi
    [[ $probe == / ]] && break
    probe=$(dirname "$probe")
  done

  printf '%s\n' "$dir/target"
}

# ergodis_profile_dir <profile>
# Cargo's directory name for a profile ("dev" and "debug" both land in debug/).
ergodis_profile_dir() {
  case "${1:?profile required}" in
    dev|debug) printf 'debug\n' ;;
    *) printf '%s\n' "$1" ;;
  esac
}

# ergodis_bin <crate-dir> <profile> <bin>
# Echo the executable path for <bin> built from <crate-dir> under <profile>.
# <bin> may be a plain binary name or "examples/<name>".
ergodis_bin() {
  local crate_dir=${1:?crate dir required}
  local profile=${2:?profile required}
  local bin=${3:?binary name required}
  printf '%s/%s/%s\n' \
    "$(ergodis_target_dir "$crate_dir")" \
    "$(ergodis_profile_dir "$profile")" \
    "$bin"
}
