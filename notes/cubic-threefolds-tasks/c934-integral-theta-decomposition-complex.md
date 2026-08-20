# C934 -- integral decomposition complex of the cubic-threefold theta divisor

**Lane:** cubic-threefolds

**Status:** active; paper upgrade and standalone export complete, original
all-degree additive-table gate still open

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
skyscraper decomposition suppresses.  The structural theorem and priority
gates are now positive and have been adopted in the manuscript; the complete
all-degree additive enumeration remains the unclosed part of this goal.

## Current state

- The link and the three intersection blocks `[-1],[-3],[-1]` are computed
  integrally.
- The paper proves
  `R sigma_* Z_M[4] = Z_0[2] + P + Z_0[-2]`, with central attachment
  `Z --(-3)--> Z`, and identifies the mod-three reduction of `P` as the
  canonical nonsplit `delta_0`--`IC`--`delta_0` uniserial object.
- The local order-three class lifts to an infinite-order Fano class; the
  exact index-three sequence and the ordinary-to-intersection comparison in
  degrees at least four are printed.
- The outer relative Lefschetz map is multiplication by three and therefore
  fails modulo three.
- The 11-page manuscript has a 147-token abstract and unanimous A rereview.
  Its clean standalone export is
  `/home/tavis/src/math-papers/blown-up-theta-lattice`.
- Open acceptance debt: enumerate every remaining local/global integral group
  and its torsion in every degree.  The full Fano-transfer and family forms
  remain secondary tests, not paper claims.

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
