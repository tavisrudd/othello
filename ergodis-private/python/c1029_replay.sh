#!/usr/bin/env bash
# C1029 — end-to-end replay of the parametric-certificate bundle.
#
#   bash ergodis-private/python/c1029_replay.sh
#
# Builds the generator out of tree (the `ergodis-private` library does not currently compile and
# this binary needs none of it), regenerates the certificate, compares it byte-for-byte against
# the committed evidence, runs the independent checker, and runs the deliberate-corruption suite.
# Runtime is under a minute on one core.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK="${HOME}/.cache/ergodis/c1029"
EV="${REPO}/ergodis-private/evidence"

mkdir -p "${WORK}/build/src"
cat > "${WORK}/build/Cargo.toml" <<'TOML'
[package]
name = "c1029-build"
version = "0.0.0"
edition = "2021"
publish = false

[[bin]]
name = "c1029_parametric_cert"
path = "src/c1029_parametric_cert.rs"

[profile.release]
opt-level = 3

[workspace]
TOML
ln -sf "${REPO}/ergodis-private/src/bin/c1029_parametric_cert.rs" \
       "${WORK}/build/src/c1029_parametric_cert.rs"
( cd "${WORK}/build" && cargo build --release )

GEN="${WORK}/build/target/release/c1029_parametric_cert"
"${GEN}" --n-max 100000000 --tag replay --out-dir "${WORK}" \
         --ladder-top 3000 --ladder-s-max 203 --ladder-c-max 20

echo "--- byte-identity against the committed evidence ---"
diff <(sed 's/witness_file .*/witness_file X/' "${WORK}/c1029-cert-replay.txt") \
     <(sed 's/witness_file .*/witness_file X/' "${EV}/c1029-cert-n1e8.txt") \
  && echo "certificate identical"
diff "${WORK}/c1029-witnesses-replay.txt" "${EV}/c1029-witnesses-n1e8.txt" \
  && echo "witness file identical"

echo "--- independent checker on the committed certificate ---"
uv run --with sympy --with numpy python3 "${REPO}/ergodis-private/python/c1029_check.py" \
       "${EV}/c1029-cert-n1e8.txt"

echo "--- deliberate-corruption suite ---"
uv run --with sympy --with numpy python3 "${REPO}/ergodis-private/python/c1029_break.py" \
       "${EV}/c1029-cert-n1e8.txt" --out-dir "${WORK}/mutants"
