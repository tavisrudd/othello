# C907 solver dossier

**Lane:** `clebsch`

Load with `c907-quantum-monodromy-stabilization.md`.  Proof-design context,
not attribution or outreach.

## Target

Prove `X x P^2` irrational for every smooth cubic threefold `X`.

Required package:

\[
 \ell_{1/6}(X\times\mathbf P^2)=3,
 \qquad \ell_{1/6}(Z)\le1
\]

for every smooth threefold center `Z`, plus strict codimension-two blow-up
additivity of the Stokes/Rees/Gamma packet.  Weak factorization then cannot
build the endpoint length-three block from center blocks of length at most one.

V1 (`X x P^1`) is closed directly by framed formal monodromy.  Do not reopen
the failed atomwise-HLT or undeveloped enhanced-Serre proofs.

## Needed solver

| Lens | Brings |
| --- | --- |
| Iritani | Master-space Fourier map, toric thimbles, Gamma lattice, Orlov residual subgroup. |
| Sabbah/Mochizuki | Strict Stokes/irregular-Hodge gluing and rescaling. |
| Yu/Zhang | Topological Laplace transform and vanishing-cycle decomposition. |
| Kuznetsov | Cubic residual category, mutations, Serre/Rees extensions. |
| Kollar | Arbitrary threefold centers; MMP/Mori-fibre scope control. |
| Cai | Exact cubic `+/-1/6` packet and small-to-big bridge. |

Closest composite: Iritani for the analytic comparison, Sabbah/Mochizuki for
strictness, Yu/Zhang for topology, Kuznetsov plus Kollar for the carrier bound.

## Active gates

1. **Toric order zero.**  For `Bl_(P^3)P^5`, the local saturated finite-value
   atlas has no unclassified tangent circuit: the zero/infinity,
   translated/infinity, and joint `y`/Rees-infinity sectors close empty/free
   or at the four marked residual points.  Assemble one finite common fan,
   verify every overlap and
   completeness, prove product-pair excision, and transport the residual
   `P^3+ZU` system.  Then fix the hyperplane-equivariant Gamma/Orlov seed.  The
   remaining point-class shear cannot change the Stokes matrix, only individual
   labels.
2. **Positive order.**  After order zero passes, compute the first
   Rees/Stokes extension class and test the non-toric center `Bl_XP^5`.
3. **Threefold carrier.**  Formal grading and duality fail: an exact
   self-dual length-two model exists.  Prove geometric vanishing of
   \[
   0\to(V_{1/6}\oplus V_{-1/6})(1)\to\mathcal R_e
   \to V_{1/6}\oplus V_{-1/6}\to0
   \]
   for every non-nef threefold, or realize `e != 0` and kill the programme.
4. **Assembly.**  Only after 1--3: operation-framed Krull--Schmidt object,
   composition coherence, and positive weak-factorization telescope.

## Rejection tests

- ordinary atom multiplicity;
- a global cubic rank-two submodule;
- Euler/Serre data without strict Rees/Stokes placement;
- Fano tables as an exhaustion of threefold centers;
- critical-value matching without directed thimble transport;
- Iritani's Orlov subgroup presented as an individual Beilinson marking;
- `K_0` subtraction in place of a positive biproduct identity.

## Source spine

- Iritani, arXiv:2307.13555, Theorem 5.18 and §5.8.
- Iritani, arXiv:1906.00801, Theorems 7.5, 7.31, 7.33 and Remark 1.4(3).
- Yu--Zhang, arXiv:2405.19549.
- Hinault--Yu--Zhang--Zhang, arXiv:2411.02266.
- Sabbah, arXiv:1511.00176.
- KKPYY, arXiv:2508.05105.
