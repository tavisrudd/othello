# C907 — relevance of the C908 blown-up-theta integral lattice

Date: 2026-08-13

Status: exact use boundary.  The C908 theorem is a strong structural asset,
but its bare integral lattice is not a stable-irrationality obstruction for
C907.  It is uniform for smooth cubic threefolds, whereas the known
minimal-theta/decomposition-of-diagonal obstruction can fail on special
smooth cubics.  A Gold application therefore needs one additional theorem
linking stable-rational correspondences to a forbidden splitting or depth
reduction of the C908 lattice.

## 1. The asset

For the blowup `M=Bl_0 Theta` of the theta divisor of the intermediate
Jacobian of a smooth cubic threefold, C908 provides:

- a split short exact sequence of free abelian groups
  `0 -> wedge^3 Lambda -> H^3(M,Z) -> H^3(X,Z) -> 0`, together with a
  canonical **non-product gluing** under `(b_*,e_X^*)`;
- the exact saturation
  `L_3 wedge^3 Lambda + Theta^[2] wedge Lambda`, of index `2^10`;
- integral surjectivity from the Fano-surface degree-six model;
- a free rank-ten escape group in degree five, with exceptional depth two;
- natural identification of all four mod-two shadows with
  `H^3(X,Z) tensor F_2`.

These statements remove matrix ambiguity and make the defect functorial
under deck action and symplectic monodromy.  They are therefore excellent
inputs to any future correspondence theorem.

## 2. Why the lattice alone cannot close Gold

The construction and its lattice invariants are topological/Hodge-theoretic
features of every smooth cubic in the stated scope.  In contrast, the
algebraicity of the minimal theta class—and hence the decomposition-of-the-
diagonal obstruction—can change on special loci.  Therefore no criterion
depending only on the abstract extension, its `2^10` index, or its mod-two
shadow can distinguish the very-general stably irrational cubic from every
special cubic.

In particular, the following implications are not supplied by C908:

\[
 X\times P^2\text{ rational}
 \Longrightarrow \rho\text{ vanishes (or the canonical gluing becomes a product)},
\]

or

\[
 X\times P^2\text{ rational}
 \Longrightarrow E\text{ loses its depth-two quotient}.
\]

Without one of these bridges, nonsplitting and the index `2^10` are
interesting invariants of the theta resolution, not stable-birational
obstructions to the fivefold.

## 3. The viable C907 experiment

The smallest useful attack is conditional and falsifiable:

1. start with a putative stable-rational decomposition/correspondence for
   `X`;
2. push it through the Abel--Jacobi/Fano-surface realization used by C908;
3. prove that it induces either an integral retraction of the canonical
   `H^3(X)` extension or an odd-depth lift of the rank-ten escape quotient;
4. contradict the closed-form gluing or depth-two theorem.

The first hostile regression is a smooth cubic on a known special
universal-`CH_0`-trivial locus.  If the proposed correspondence implication
already follows from universal `CH_0` triviality, it is false, because the
C908 lattice remains nonsplit there.  A successful bridge must use a
strictly stronger consequence of stable rationality than the currently known
minimal-class criterion.

## EJ / TT / AA

- **EJ:** the four `(Z/2)^10` phenomena are one canonical mod-two shadow, so
  future arguments should target the integral extension map, not count four
  independent obstructions.
- **TT:** a uniform topological lattice cannot by itself detect an
  algebraicity locus which varies in moduli.
- **AA:** try to force a retraction compatible with `(b_*,e_X^*)`, not a
  mere abstract splitting (which already exists); test it immediately on
  the special universal-`CH_0` loci before investing in a general proof.
