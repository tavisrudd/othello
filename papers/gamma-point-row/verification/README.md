# Verification

Run the complete paper gate from the repository root:

    make check

The gate checks the public claim boundary, rejects internal task language and
unaudited priority phrases, checks the cubic endpoint certificate, lints TeX
spacing, builds the manuscript, and rejects LaTeX warnings.

The mathematical proofs are human proofs in the manuscript. The verification
script checks release consistency; it is not a substitute for those proofs.

The endpoint checker uses exact rational arithmetic to reconstruct the
rank-two indicial polynomial in (9.4), verify the normalized hypergeometric
recurrence through degree 12, check that the Barnes arguments used in (9.7)
are not Gamma poles, and regress the projective-space grading identity through
dimension 64. Run

    nix shell nixpkgs#python3 -c python3 verification/check_cubic_endpoint.py --check

from the paper root. Regenerate the canonical certificate by omitting the
check flag. The exact source hashes and byte counts are:

- check_cubic_endpoint.py: SHA-256
  d6f3a0cbd42ccf964c886cee1d1d4bc772976843553b9a14e396066162b2940d,
  4,484 bytes;
- cubic_endpoint_certificate.json: SHA-256
  75b01b9ecabd8e28ef95c8e1f8bdccc8003a1e10a13c0d3cf0b09017f1844e50,
  8,952 bytes.

The symbolic derivation in the manuscript is the independent check of the
script. The artifact does not verify the Barnes asymptotic theorem, quantum
Künneth, virtual localization, or the birational transport theorem.
