#!/usr/bin/env bash
# Build the native extensions. Requires gcc and Cython (via uvx).
set -euo pipefail
cd "$(dirname "$0")"
INC=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
EXT=$(python3 -c "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX'))")
for mod in _bitboard _search; do
    uvx --from cython cython -3 "othello/${mod}.pyx" -o "othello/${mod}.c"
    gcc -shared -fPIC -O3 -march=native -I"$INC" "othello/${mod}.c" -o "othello/${mod}${EXT}"
    echo "built othello/${mod}${EXT}"
done
