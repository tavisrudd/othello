# Verification

Run the complete paper gate from the repository root:

    make check

The gate checks the public claim boundary, rejects internal task language and
unaudited priority phrases, lints TeX spacing, builds the manuscript, and
rejects LaTeX warnings.

The mathematical proofs are human proofs in the manuscript. The verification
script checks release consistency; it is not a substitute for those proofs.
