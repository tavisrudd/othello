# Verification

Run the complete paper gate from the repository root:

    make check

The gate checks the public claim boundary, rejects internal task language and
unaudited priority phrases, checks the cubic endpoint certificate, lints TeX
spacing, builds the manuscript, and rejects LaTeX warnings.

The manuscript check builds from a clean temporary copy of the source with a
pinned source date and byte-compares that deterministic result with the tracked
PDF. This makes stale source/PDF pairs fail even when local latexmk auxiliary
files claim the manuscript is current. Use

    make manuscript-update

to refresh the tracked PDF through the same isolated build, then rerun the
complete gate.

The mathematical proofs are human proofs in the manuscript. The verification
script checks release consistency; it is not a substitute for those proofs.

The endpoint checker uses exact rational arithmetic to verify an explicit
basis of \(\operatorname{im}K^2\oplus\ker K^2\) at three nonzero rational
specializations of the displayed cubic matrix, normalize the nilpotent link,
solve the off-block Sylvester equation, and reconstruct the rank-two block
and indicial polynomial in (9.3)--(9.4),
verify the normalized hypergeometric
recurrence through degree 12, check that the Barnes arguments used in (9.7)
are not Gamma poles, and regress the projective-space grading identity through
dimension 64. Run

    nix shell nixpkgs#python3 -c python3 verification/check_cubic_endpoint.py --check

from the paper root. Regenerate the canonical certificate by omitting the
check flag. The exact source hashes and byte counts are:

- check_cubic_endpoint.py: SHA-256
  c85d7b72db2de6450a6885dc58b8e05f2f182430e88e0010214536bc839dbc9f,
  10,499 bytes;
- cubic_endpoint_certificate.json: SHA-256
  fcdeabcb8141f9f0279c56652f8913e11af59218a4db40a4fa6d3ede67aeb8a7,
  10,235 bytes.

The displayed derivation in the manuscript is the independent check of the
script. The artifact does not verify the Barnes asymptotic theorem, quantum
Künneth, virtual localization, complete-neutral continuation, or the
conditional birational transport theorem.
