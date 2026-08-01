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

The verification surface is under `verification/`. It currently records the
claim partition and the frozen evidence to extract from Paper I. It is not yet
a release certificate. Release requires paper-owned replay files, a semantic
Lean aggregate gate with an exact axiom audit, an immutable artifact locator,
and a clean isolated replay.
