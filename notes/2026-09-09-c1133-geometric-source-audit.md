# C1133 — counting-matrix provenance and deformation inputs

**Date:** 2026-09-09. **Status:** source-comparison checkpoint; full task open.

## Counting matrices

All fifteen index-one and index-two matrices in the packet agree with the
reconstructions distributed with *Naive atoms of blowups: examples*, Zenodo
record [20625923](https://doi.org/10.5281/zenodo.20625923). Both source scripts
were read completely before execution. Their hashes, URLs and read depths are
in the literature source register. They remain in the shared literature cache.

The comparison first verifies every input period coefficient through degree
eight against Coates–Corti–Galkin–Kasprzyk, arXiv:1303.3288v3: closed formulas
in sections 3–7 for index two, and printed regularized coefficients in sections
8–17 for index one, divided by the corresponding factorials. The formulas and
printed coefficients are independently transcribed; this does not independently
prove the underlying Gromov–Witten formulas.

For each source matrix M evaluated at q=1, the packet matrix is exactly

    D^(-1) M^transpose D + a I.

For index one of degree k=2g−2, D=diag(1,1,k,k) and a is the packet's displayed
scalar shift. For index two of degree k, D=diag(1,2,4k,8k) and a=0. The exact
entrywise equalities, individual shifts, and period checks are recorded in the
adjacent checker JSON. This is stronger than matching characteristic polynomials.
Projective space and the quadric are absent from these two archive scripts;
their packet characteristic-polynomial checks already pass, and CCGK sections
1–2 supply their classical quantum-period formulas.

Replay from the repository root:

```sh
uv run --with sympy==1.14.0 python notes/2026-09-09-c1133-matrix-source-check.py
```

The default source directory is `/tmp/persistent/tavis/lit-search/c1133-intake`.
For another machine, obtain the two named scripts from the pinned Zenodo record
and pass `--source-dir DIR`; the checker rejects differing hashes. The checker,
result, imported packet checker and external scripts are hashed together in
`2026-09-09-c1133-matrix-source-manifest.json`. No source program is downloaded
or executed implicitly during replay.

## All-member geometry

CCGK's introduction identifies seventeen rank-one deformation families. Its
section 9 explicitly joins the quartic and special double-cover presentations
as smooth complete intersections of type (2,4) in P(1,1,1,1,1,2). In that model,
adding a nonzero coefficient of the weight-two coordinate to the degree-two
equation yields the quartic presentation by elimination. Smoothness is open,
so this gives a local smooth deformation of a smooth special member. The
smooth locus of the parameter space is connected. This is the auditor's
explicit deformation argument implementing the source's stated equivalence.

For special GM threefolds use the cone presentation in Debarre's survey.
The special linear section passes through the cone vertex, but its smooth
quadric section avoids that vertex. Perturb the linear section to miss the
vertex. Properness and openness of smoothness give, near the starting parameter,
a smooth family with ordinary general members. Ordinary presentations form a
nonempty open set of an irreducible parameter space. This supplies the local
bridge that a statement about an irreducible *coarse* moduli space alone would
not supply. Debarre's Theorem 3.7 separately confirms that its moduli statement
includes both ordinary and special strata.

The degree-one/two index-two weighted hypersurfaces and the sextic double solid
are treated by the weighted formulas in CCGK sections 3, 4 and 8. The complete
intersection families occur in sections 5, 6, 10 and 11, and the other homogeneous
models in sections 7 and 12–17. These are source identifications, not a new proof
of the classification. Transport of the full small quantum product uses smooth
deformation invariance and the marked ample generator; transporting Hodge
representations themselves along a deformation is neither asserted nor needed.
The imported exhaustion and all-family Hodge-number check are recorded below.

## Classification exhaustion and Hodge numbers

Kuznetsov–Prokhorov, *One-nodal Fano threefolds with Picard number one*,
arXiv:2312.13782v2, introduction p. 3, explicitly recalls that there are exactly
seventeen smooth Picard-rank-one deformation families, uniquely determined by
index and genus/degree. This is the smooth classification recalled in their
introduction, not their new classification of singular degenerations. Their
Table 5, p. 13, explicitly applies to all smooth members and supplies the
following values. The table was checked visually against the cached PDF because
the plain text extraction interleaves its index headers.

| Index | Packet family labels, in order | h^(2,1), in the same order |
|---|---|---|
| 1 | g=2,3,4,5,6,7,8,9,10,12 | 52,30,20,14,10,7,5,3,2,0 |
| 2 | d=1,2,3,4,5 | 21,10,5,2,0 |
| 3 | quadric | 0 |
| 4 | projective space | 0 |

These seventeen entries agree with packet section 20. The source uses
anticanonical genus g=4d+1 in its index-two columns; converting those labels is
essential. In particular every one of the nine detected families has nonzero
H^3. Nonzero H^3 alone is not an irrationality test: rational controls g=7,9,10
and d=4 also have nonzero H^3.

The source attributes the classification and its table to Iskovskikh–Prokhorov,
*Fano varieties*, Encyclopaedia of Mathematical Sciences 47 (1999), especially
Table §12.2. That book has not been independently read here; its role is an
explicitly secondary imported source through the inspected KP passages. The
source obligation for exhaustion is satisfied at the level of an established
classification statement, not by a new proof or a claim to have read the entire
classification literature. Combine it with the CCGK family identifications,
smooth deformation invariance, and the special-model bridges above.

For the eight rational controls, KP arXiv:1911.08949v3 §1.1 explicitly lists
P^3, Q^3, V4, V5, X12, X16, X18, X22 as the geometrically rational families;
these are packet d=4,5 and g=7,9,10,12 in addition to P^3 and Q^3. Its Theorem
1.1 concerns forms over nonclosed fields and supplies finer rationality criteria.
Over C the imported geometric rationality statement applies to all smooth
members. We do not use deformation invariance of rationality. The theorem's
proof throughout the remainder of that paper has not been read in full.

Read depth for the new KP source: **partial**, cached v2 (83 pages), introduction
extraction lines 120–151, p. 13 definition (2.5) and Table 5, and bibliography
entry [IP99] lines 5930–5932. PDF SHA-256:
`a5d34feec13bbbe2c65399edbda1d957f4a35363a0d3794ff6fd45b00e0ce9f2`.
The publisher verifies the publication alias DOI 10.4213/im9585e; the
publication PDF has not been read. No forward-citation closure is inferred.

## Two source-positioning corrections

The 2026 author revision of Debarre's survey, section 4.2 and footnote 7,
announces a result for **very general GM fourfolds**. It does not announce
all-member GM-threefold irrationality. The earlier search-snippet lead is
therefore corrected, not treated as a predecessor of the proposed threefold
theorem. Its cached bytes are separately pinned from the older arXiv survey.

Cai's quartic paper, arXiv:2605.29143v2, introduction and section 5, is a direct
predecessor for persistence of the repeated even quantum eigenvalue. Theorem
5.3 proves that claim for quartics; the introduction explains the cyclic
Chern-class method more generally. The packet must credit this precedent
when presenting its trace-based persistence proof. The cited result concerns
symplectic birationality in dimension six; the inspected statements do not
establish the proposed one-stabilization or full-super Hodge claims.

There is also a small numerical inconsistency in Cai's Corollary 5.2: its
displayed algebra relation in Theorem 5.1 factors as
(P+24Q)^3(P−232Q), whereas the subsequent corollary and initial-value sentence
print 256Q for the simple eigenvalue. The repeated eigenvalue −24Q and its
multiplicity are unchanged. This arithmetic observation is not a refutation
of Theorem 5.3. The packet's scalar shifts agree with the algebra relation.

## EJ+TT and Mystery ledger

- **Settled:** the fifteen archive matrices match entrywise, including scalar
  normalization; all input period coefficients used in that reconstruction
  match the independent published source formulas/tables.
- **Settled:** the special quartic presentation has an explicit smooth bridge;
  the cone perturbation gives the analogous GM bridge.
- **Settled:** the GM-announcement lead concerns fourfolds, and Cai supplies
  a persistence precedent that must be credited.
- **Settled:** imported seventeen-family exhaustion and all seventeen Hodge
  numbers; the rational-control input has all-member geometric scope. The
  operation and vanishing proofs are written in the separate transport audit.
- **EJ+TT refinement:** positive Hodge number does not separate rational controls
  from detected families. The selector and retained lattice remain essential.
- **Open:** optional branches and the full literature verdict. Finite
  reconstruction is not a substitute for these gates.

No manuscript or public novelty statement is changed by this checkpoint.
