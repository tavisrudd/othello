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
  19fb6fb78e2c8c48cda7b2c1260a8428613dd5cd1b276609d8dd921c2f8c78f1,
  10,536 bytes;
- cubic_endpoint_certificate.json: SHA-256
  50f0fc5b61a5e47dfbf1cde6b0a812095b3b011144d1d6349741cd2d48b00837,
  10,272 bytes.

The displayed derivation in the manuscript is the independent check of the
script. The artifact does not verify the Barnes asymptotic theorem, quantum
Künneth, virtual localization, the rank-one derived clutching theorem, marked
threshold compatibility, or the conditional birational transport theorem.
