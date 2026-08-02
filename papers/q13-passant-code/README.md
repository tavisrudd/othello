# Paper IV: the q=13 passant code

This is the authoritative manuscript root for Paper IV of the Clebsch program.
Its working title is *A binary [78,36,12] code from the passant lines of a
conic over F13*.

Paper IV owns the standalone coding theorem extracted from the computational
companion to Paper I: the minimum distance, the four minimum-word orbits,
reconstruction of the passant incidence geometry from the minimum layer, the
span of the code by each orbit, and the exact coordinate-permutation
automorphism group. Paper I may summarize and cite this theorem, but future
versions should not retain a second full proof.

The manuscript is `passant_code_q13.tex`. Build and check it with:

    make check

The proof is human and structural. The verification surface under
`verification/` records discovery provenance and checks only finite leaves
that resist further conceptual compression. Paper-owned replay files and the
semantic Lean aggregate gate are green, with an exact axiom audit and a scope
strictly narrower than the main theorem. Release still requires replacing the
Lean package's repository-relative semantic-library dependency with a pinned
public dependency, replaying both bundles from fresh isolated checkouts, and
inserting their immutable artifact locators.
