# C934 -- integral decomposition complex of the cubic-threefold theta divisor

**Lane:** cubic-threefolds

**Status:** active; bounded theorem-feasibility pass

## Goal

Decide whether the eight-page C928 middle-lattice paper admits a coherent
venue-raising upgrade from one degree to the full integral decomposition
complex of

\[
 \sigma:M=\operatorname{Bl}_0\Theta\longrightarrow\Theta.
\]

Compute the local and global integral groups in every degree, determine
whether the `Z/3` class in degree four of the link survives globally, and
identify the extension data in `R sigma_* Z_M[4]` which Kraemer's rational
skyscraper decomposition suppresses. Do not edit the frozen manuscript until
this theorem gate and a fresh priority audit are positive.

## Initial evidence

- C928 proves the complete degree-three lattice and its mod-two placement.
- The link is the circle bundle of `O_X(-1)`, and its Gysin sequence contains
  `h -> h^2 = 3 ell`, hence a local `Z/3` in degree four.
- Kraemer computes the decomposition only over characteristic zero.
- The 2025 integral Lefschetz filtration owns the abstract symplectic-lattice
  boundary but not this singular-theta decomposition complex.

## Work plan

1. Compute `H^*(link,Z)` with every map, generator, torsion class, and pairing
   fixed.
2. Compute `H^*(U,Z)`, `H^*(M,Z)`, and the Mayer--Vietoris and pair maps in all
   degrees; decide whether the local three-torsion survives.
3. Compute `IH^*(Theta,Z)` from the integral Deligne truncation and identify
   the natural maps from ordinary cohomology and the resolution.
4. Determine the stalkwise and global quasi-isomorphism type of
   `R sigma_* Z_M[4]`, including the exact multiplication-by-three extension,
   or prove that the proposed model is false.
5. Compute the integral duality, pairing, and Bockstein data needed to make the
   result structural rather than a Betti table.
6. Test two secondary upgrades without importing them into the main theorem:
   full Fano-transfer surjectivity and a monodromy-equivariant family form.
7. Run a fresh full-text priority audit before any manuscript claim, then
   decide: merge and re-referee, publish as a companion, or retain the frozen
   Proceedings paper unchanged.

## Acceptance gates

- Every local and global group is computed from exact sequences with named
  maps, not inferred from rational ranks.
- The fate of the link's `Z/3` class is explicit.
- Any claimed integral decomposition complex is given as an actual derived
  extension with its attaching morphism, not as an additive group list.
- The mod-two middle glue and the three-primary local defect are related only
  by proved structure; no rhetorical unification substitutes for a theorem.
- A negative feasibility result preserves the frozen C928 paper unchanged.

## Owned paths

- `notes/cubic-threefolds-tasks/c934-integral-theta-decomposition-complex.md`
- `notes/2026-08-20-c934-*.md`
- the C934 row in the live queue and C934 entry in the cubic-threefolds handoff

Manuscript edits under `papers/blown-up-theta-lattice/` require a positive
theorem gate and a separately frozen remediation plan.
