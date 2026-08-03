# Theorem adoption map

This map is internal. It records the results owned by Paper II and separates
the one imported Paper I dependency.

| Result | Owner/status | Exact boundary | Evidence |
|---|---|---|---|
| `thm:lu-lc-rigidity`, `cor:transversal-clifford`, `lem:pauli-phase-correction` | Paper I; imported with citation | arbitrary additive stabilizer `AME(2m,q)`, every prime power, `m>=2` | companion manuscript and its named formal cores; no Paper II certificate |
| `thm:dictionary` | Paper II; adopted | linear `[6,3,4]_q` code/six-arc/CSS/AME dictionary | conceptual proof; unconditional Lean dictionary |
| `prop:diagonal-multiplier-line` | Paper II; adopted | every finite field and exact half-dimensional MDS pair | conceptual MDS proof; unconditional Lean multiplier-space theorem |
| `cor:diagonal-isodual-transversal-group` | Paper II headline; adopted | odd prime `q`, `m>=2`, linear `[2m,m,m+1]_q` MDS code, fixed parties | conceptual construction and imported Clifford exclusion; conditional exact-carrier Lean interface |
| `lem:six-arc-self-association`, `thm:logical-phase`, `cor:six-arc-fixed-party-group` | Paper II; adopted | odd-prime-field six-arcs | manuscript Gale/conic proof and conditional logical-phase interface |
| `thm:lc-pencil`, `cor:lu-lc-pencil` | Paper II; adopted | projective/monomial over odd finite fields; LC/LU only over odd prime fields on the admitted non-GRS locus | exact symbolic quotient, certificate-checked holonomies, imported rigidity |
| `prop:frobenius-sector-divisors` | Paper II; adopted | every odd finite field and field automorphism; no full extension-field Clifford classification | unconditional Lean scalar algebra |
| `lem:coset-syndrome-charts`, `prop:clebsch-x-syndrome`, `rem:clebsch-x-syndrome-boundary` | Paper II worked application; adopted | `q=11`, generalized-X sector with stated projective and group boundaries | manuscript composition, unconditional syndrome Lean core, cited Clebsch theorem |
| `thm:fixed-copy-boundary` | Paper II; adopted | irreducible regular code charts, each fixed copy degree | conceptual contraction-rank proof |
| `thm:lu-h3-grs`, `thm:q13-lu`, `thm:transport-divisor` | Paper II appendices; adopted | exact finite domains in their statements | manifest-pinned generators, certificates, and independent replay |
| `cor:computed-party-splitting` | Paper II appendix; adopted | exactly twelve listed rows | certificate-checked complements; abstract splitting consequences in Lean |

The paper deliberately excludes Paper I's quantitative rounding, partial-Weyl
recognition, two-uniform stability, robust atlas, and minimum-support
classification theorems except for the one cited rigidity/no-go input.
