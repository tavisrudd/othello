# Family and arithmetic verification

This bundle accompanies `thm:uniform-cubic-family` and
`prop:pencil-local-rank`. All formal coverage is absent. The written
geometry and imported theorems remain separate from symbolic execution.

## Replay

From the paper directory:

```sh
uv run --with sympy==1.14.0 python3 verification/check_family_arithmetic.py --check-output verification/family-arithmetic.json
make check
```

The first command regenerates all twelve jobs in memory and compares the
result to the certificate without writing. Only Python-version metadata is
excluded from comparison; SymPy version and all mathematical data must match.
The recorded run used Python 3.14.3 and SymPy 1.14.0. Assertions must be enabled;
optimized Python is rejected. There is no random sampling. Default bound 240,
recursive sequence length 20, and tangent reconstruction enabled.

To regenerate deliberately:

```sh
uv run --with sympy==1.14.0 python3 verification/check_family_arithmetic.py --output verification/family-arithmetic.json
```

Refresh the three exact file hashes in `family-arithmetic-SHA256SUMS` only after
reviewing the changed source or output. That manifest is checked by the metadata
gate. It pins the script, certificate and actual companion PDF cited here.

## Scope

The program checks the family quadrics and determinant, seed smoothness by
Jacobian ideal membership, moduli ranks 25 and 28, signed-generator group
order, integral weight calculations, tangent reconstruction, pencil
smoothness polynomials, elliptic quotients and j-invariants. Arithmetic
point counts include the necessary twists. It checks 74 squarefree integer
parameters and 466 rational parameters in the specified finite wedge at
bound 240, and local-density counts at 5, 7, 11, 13, 17 and 19.

Some retained checks support optional calculations beyond the manuscript's
main theorem: recursive parameters, rational support reconstruction and
local density factors. Their presence does not assert a height theorem in
the paper. The S-unit check verifies substitution identities, not a solver.

The family program reconstructs eight selected tangent rows. The full gate
therefore also retains the original twenty-quadric Cox derivation and its
independent verifier. The rank-four certificate likewise has a distinct
independent implementation. The new program's entire symbolic calculation
has not been independently reimplemented; it is trusted exact SymPy execution.

The following are not proved by the program: quotient descent, generic
torsor splitting, the Picard representation identification, the Prym
isogeny, semistable reduction, the companion irrationality and Hodge
theorems, and the all-parameter consequences of those results. The source
registry records their hypotheses and how they match the manuscript.

## Source versions

- Tschinkel–Zhang: arXiv:2608.20029v2, Section 4 and Proposition 5.3
  identify the actual signed Picard action. Its stable-permutation property
  survives restriction to any subgroup.
- Casalaina-Martin–Marquand–Zhang: arXiv:2210.14397v2, Theorem 2.9 supplies
  the conic-bundle isogeny; the manuscript identifies its covers explicitly.
- Grothendieck: SGA 7 I, Exposé IX, Proposition 2.2.6 and Corollary 2.2.7
  give isogeny invariance of toric rank; Corollary 3.3 gives identity-component
  base change after semistability, with no tame-ramification restriction.
  Theorem 3.6 supplies semistable reduction after finite extension.
- The bundled September 2026 companion PDF supplies Theorems 1.1 and 1.3.
  This local revision is not represented as an older deposited version.
- Beukers–Schlickewei: author version dated 8 January 2007, Theorem 1.1,
  applies to conjugate S-unit pairs of rank 1+|S_L|. The finite-place set is
  finite, and x=y is excluded before recovering the parameter.

The exact source passages were checked at partial reading depth, not by
claiming cover-to-cover audits. In particular the SGA statements were checked
against the original scanned pages. These checks establish the stated source
interfaces, not an exhaustive priority search or independent reproving of
the imported theorems.
