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
  b7b6e54b49d258169d2e30a971288a937ca013d0af7812ba166162b8187a5e57,
  10,481 bytes;
- cubic_endpoint_certificate.json: SHA-256
  54d391961fcb6360b5e5757b8cc1103818ce2ad45ea814fe1828ab1febe3d224,
  10,217 bytes.

The displayed derivation in the manuscript is the independent check of the
script. The artifact does not verify the Barnes asymptotic theorem, quantum
Künneth, virtual localization, complete-neutral continuation, or the
conditional birational transport theorem.
