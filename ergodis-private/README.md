# Private Ergodis research adapters

This unpublished sibling package contains domain-specific research adapters,
campaign fixtures, and benchmark drivers used to test the public Ergodis core.
It is not part of the Ergodis release tree or distribution manifest.

The dependency direction is one-way: this package may depend on the Ergodis
package under `papers/complete-repair-ports`; Ergodis must never depend on this
package.

Current adapters are the projective grid-game scout and the live
alignment-attachment campaign controller.  Their project-specific geometry,
features, fixtures, and research evidence stay here; only reusable mechanisms
may cross into Ergodis core.

Private certificate-to-theorem experiments also live here.  The current
generic primitives lift checked constraint and finite-field rank cores into
semantic groups, and `hall_core` provides an allocation-free repeated
bipartite matcher returning either a saturating assignment or an exact
alternating-reachable Hall-deficient set.  Domain-specific predicates and
private research identifiers must remain outside the public Ergodis package.
