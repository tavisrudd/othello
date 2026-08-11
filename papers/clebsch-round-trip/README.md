# The Golden Companion Correspondence

[Read the paper (PDF).](golden_companion_reconstruction.pdf)

Paper II of the *Clebsch: Rigidity from Sparse Shadows* series produces a
signed cubic from a matching quotient. This paper identifies its canonical
five-dimensional residue and proves that it is a chordal companion—not the
conference cubic reconstructed in Papers I and III—in the same
two-dimensional \(A_5\)-invariant pencil.

The chordal cubic is singular along a rational normal quartic. Its twelve
\(\mathbf F_{11}\)-points form \(A_5/C_5\); the stabilizer quotient recovers
the original six-axis carrier \(A_5/D_{10}\). The normalized outer action
then gives an exact oriented round trip between a selected chordal line and
the conference line. Without the selected line this is a residual double
cover, not an equivalence.

The recovered six-set also distinguishes the rank-five augmentation lattice
from the rank-six \(D\)-type weight lattice while identifying their common
binary heart. A uniform conference-saturation theorem explains the
split/inert mod-eight residue dichotomy. In order six the normalized golden
operator produces the unique nonsplit \(\mathbf F_4A_5\)-extension, and
golden reversal becomes Frobenius. Thus the geometric and integral residual
markings are the same \(C_2\)-torsor.

This is Paper V of the five-paper series. Papers I--III supply the marked
inputs, while Paper IV is an independent minimum-word reconstruction branch.

## Building and checking

The manuscript is golden_companion_reconstruction.tex. From this directory:

    make check

This replays the exact evidence program, builds the PDF, and fails on any
LaTeX warning. The checker uses only the Python standard library; the PDF
build uses a Nix-pinned TeX environment.

## Verification surface

The proof is human and structural. The program under
verification/evidence/ independently replays only the Paper-II normalization
leaf: the finite-field tensor placement and its forward/reverse identities.
The singular-locus, stabilizer, groupoid, lattice-saturation, extension, and
Frobenius arguments are printed in the paper and do not depend on the
program. See verification/README.md for the trust boundary. The adjacent
icosahedral-tower files are exploratory evidence for a separately gated
successor theorem and are not used by the manuscript check.

## License

CC BY 4.0. See LICENSE.
