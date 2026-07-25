# C602: full AME--LU Lean and trust audit

**Lane:** `ame-lu`

**Status:** complete

## Result

The length-generic AME--LU formal closure now supports every topological
claim made by Corollary 3.3 at the strength stated in the manuscript.

- Both fixed-party and party-permuted scalar-torus inclusions are continuous
  group homomorphisms.
- The scalar subgroup of the one-site Clifford matrix group is closed.  Its
  intrinsic adjoint quotient is therefore Hausdorff; its independently proved
  finiteness makes the quotient topology discrete.
- Every connected component of either product-unitary automorphism group is a
  left translate of the scalar torus.  Explicit finite sets of representatives
  cover the two groups by these connected components.
- The realized party-permutation theorem is described consistently as a
  homomorphic-right-inverse splitting criterion.  Neither the Lean source nor
  the paper now calls it an extension-class or cohomological obstruction.

`RelativeConicArcs.Gates.AMELUAggregateAxioms` audits the new declarations.
Each depends only on `propext`, `Classical.choice`, and `Quot.sound`.

## Trust-graph and release audit

The release verifier previously pinned only the original nine six-party AME
modules despite claiming the completed length-generic formal companion.  Its
formal allowlist is now computed as the recursive project-owned import closure
of all AME--LU modules and gates.  The resulting graph has 72 artifacts:

- five pinned toolchain, Lake, and Nix build-identity files;
- 41 `RelativeConicArcs.AMELU` modules;
- 15 AMELU import and axiom-audit gates; and
- 11 transitive project modules owned by other lanes.

An independent import scan found zero missing project-owned imports.  The
release manifest now binds all 72 files, rather than the former partial
companion.  The theorem map, statement-adequacy map, formalization ledger,
verification map, adversarial audit, release plan, and Sections 3 and 8 use
the same closure and splitting boundary.

## Foreign-closure blockers

The AME--LU-owned 41-module and 15-gate layer contains no task IDs, temporary
paths, workflow references, `TODO`/`FIXME`, hidden `sorry`, project axiom, or
unsafe declaration.  The recursive read-only closure has exactly two
referee-prose defects:

1. `lean/RelativeConicArcs/Plane.lean:7` reverse-references
   `papers/arcs_complete_outside_conic`.
2. `lean/FiniteGeom/Code.lean:16` cites
   `notes/handoffs/2026-07-11-lean-formalization-plan.md` and calls it
   “Phase 0 next-step 1.”

Both files are foreign-owned and outside the `ame-lu` allowlist.  They remain
byte-pinned and are disclosed in the public-export plan and adversarial audit.
They do not change any elaborated statement or axiom dependency, but the
formal companion must not be called referee-prose ready until their owners
remove those references.

## Validation

- Warning-free guarded elaboration of
  `RelativeConicArcs.AMELU.AutomorphismExactSequence`.
- Measured single-thread builds of the exact-sequence module and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms`, followed by the trace-only
  aggregate gate:
  `/home/tavis/.cache/othello-lean-build/run-20260725-230844-c1ecca6e`.
- Exact no-build probes and the aggregate gate passed.
- The warning-free manuscript build produced a 19-page, 180,174-byte PDF.
  Pages 6 and 15, containing the revised corollary and verification boundary,
  passed visual inspection.  Its SHA-256 is
  `9868b229f134bafea387499dbcb7a07204bdcfaf7baef10569ed03c211d62c7b`.
- All 15 evidence artifacts verified and all seven evidence bundles replayed.
- The release verifier passed with 35 public artifacts and all 72 formal
  companion artifacts.  The formal tree SHA-256 is
  `b81b4a50d33bdfecc3dbe56d5e5ab7215451e86bad11d59b294bb6e2ea75ebf0`.

## `ej` and Tao closeout

The cheapest structural strengthening was to expose components, not merely
the identity component.  Translating the scalar-torus identity-component
theorem gives every component exactly; finite projective quotients then give
explicit finite component covers.  This is now formal and paper-facing.

The highest-value audit question was whether the release identity actually
bound the theorem closure it advertised.  It did not.  Recursive project
import closure both repaired that defect and made the two remaining foreign
prose failures visible.  No additional theorem should be added here:
section-free outer actions, factor sets, and genuine extension obstructions
change the mathematical shape and remain correctly assigned to C618.

## Mystery ledger

| Feature | Closeout status | Evidence gap or owner |
|---|---|---|
| Are the scalar inclusions continuous maps in the short exact sequences? | **Settled:** both are `ContinuousMonoidHom`s. | none |
| Is the intrinsic Clifford quotient genuinely Hausdorff and discrete? | **Settled:** the scalar kernel is closed, the quotient is Hausdorff, and finiteness gives the discrete topology. | none |
| Does the identity-component theorem expose the whole component structure? | **Settled:** every component is a scalar-torus coset and finitely many cover each automorphism group. | none |
| Does `splits_iff` compute an extension obstruction? | **Settled negatively:** it is exactly a right-inverse criterion. | C618 owns the outer action, factor set, and change-of-section law |
| Does the release manifest pin the complete project closure? | **Settled:** independent replay finds 72 artifacts and zero missing project imports. | none |
| Is the complete formal companion referee-prose clean? | **Open, foreign-owned:** two exact reverse/workflow references remain. | `RelativeConicArcs/Plane.lean:7` and `FiniteGeom/Code.lean:16` |

**Vibe check:** the mathematical and trust ledgers are now aligned, and the
release identity finally matches the formal claims.  The two remaining defects
are small but real scholarly-packaging blockers in foreign source comments,
not defects in the AME--LU theorems.
