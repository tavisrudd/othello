# Verification

Run the complete paper gate from the repository root:

    make check

The gate checks the public claim boundary, rejects internal task language and
unaudited priority phrases, checks the cubic endpoint certificate, lints TeX
spacing, builds the manuscript, and rejects LaTeX warnings.

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
  6ea617521b7259106db62a48cffb42217543dccd424de8767bf86555977ab463,
  10,459 bytes;
- cubic_endpoint_certificate.json: SHA-256
  74a60e24dcb221a40912bae9f3c66140287c6b49e70b1967fd7f84e945cea986,
  10,195 bytes.

The displayed derivation in the manuscript is the independent check of the
script. The artifact does not verify the Barnes asymptotic theorem, quantum
Künneth, virtual localization, complete-neutral continuation, or the
conditional birational transport theorem.
