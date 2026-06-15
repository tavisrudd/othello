#!/usr/bin/env bash
# Build the native bitboard extension. Requires gcc and Cython (via uvx).
set -euo pipefail
cd "$(dirname "$0")"
INC=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
EXT=$(python3 -c "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX'))")
uvx --from cython cython -3 othello/_bitboard.pyx -o othello/_bitboard.c
gcc -shared -fPIC -O3 -march=native -I"$INC" othello/_bitboard.c -o "othello/_bitboard${EXT}"
echo "built othello/_bitboard${EXT}"
