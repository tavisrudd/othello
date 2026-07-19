import RelativeConicArcs.Q25MinimumClassification
import RelativeConicArcs.Q25Exhaustion
import RelativeConicArcs.Q25SemanticExhaustion

/-!
# Q25 exceptional-minimum validation gate for the `alt-orbit-repair` lane

Import-only gate for the C151/C331 paper-facing terminals.

C151 supplies the semantic lower bound `f2_card_globalLegalPairs_ge_32`, which carries `≥ 32` to
every invariant eight-arc in `PG(2,25)` with exactly two fixed points, and the normalized-row
exhaustion terminals `mem_minimumOrbitUnion_of_normalized_card_eq_32` and
`card_ge_33_of_not_mem_minimumOrbitUnion`, which place every normalized row attaining `32` in the
`1600`-element union of the five certified minimizer orbits.

C331 lifts exhaustion itself to semantic arcs: `f2_normalizes_into_minimumOrbitUnion` places every
invariant eight-arc attaining `32` into that union under a base-field collineation, and
`f2_card_globalLegalPairs_ge_33_of_not_normalizing` is its contrapositive.  With the lower bound
already lifted, `32` is the exact semantic minimum and the five orbits are the complete extremal set.

This is a separate gate from `AlternateOrbitRepairQ25` for the reason recorded there: independently
compiled terminals collide on synthesized instance names when imported into one environment.
-/
