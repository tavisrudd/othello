# C447 Fable review — cap knife edge

**Lane:** `crowns`

**Date:** 2026-07-21

**Reviewed commit:** `66d87e37`

**Gate:** **AMBER — the `SHARP_NEGATIVE` identification verdict is sound; narrow the X3 consequence and mechanically justify the asserted group-type labels.**

## Checks and judgment

All advertised commands pass: canonical regeneration agrees with the tracked JSON, the independent
replay passes, and every checksum verifies.  Direct inspection confirms that the cap dump has
exactly classes 4 and 7 with the stated seven on-conic children and `2P+5N` splits.  The two
hyperbola equations and both cap-to-standard matrices carry all ten affine points and the two
points at infinity to `XZ-Y^2=0`; composition with the frozen C406 matrix gives the recorded H3
projectivities.

The equivariance obstruction is valid and is stronger than the coordinate-level nonincidence.
Each cap frame stabilizer has order 10, determinant-square split `5+5`, and element-order
distribution `1^1 2^5 5^4` (hence `D10`).  Each singleton-matching stabilizer has order 60 and lies
in `PSL_2(11)`, so determinant character, which is conjugacy invariant in `PGL_2(11)`, forbids
conjugating the cap stabilizer into it.  The unordered singleton-pair stabilizer has order 24 and
element-order distribution `1^1 2^9 3^8 4^6` (hence `S4`), so it contains no subgroup of order
10.  Exhaustion over all 1,320 projectivities correctly returns zero compatible maps.  Conversely,
the 120 unframed maps to an edge of either singleton show exactly why mere incidence would be a
coordinate choice.  Therefore register row 35 may close **sharp negative in the explicitly
equivariant sense**; the bundle correctly does not claim that arbitrary unframed incidence is
impossible.

## Exact AMBER findings

1. The primary JSON writes `abstract_type: "D10"` and assigns `"S4"` to
   `unordered_singleton_pair_stabilizer_type`, but the primary and replay scripts establish only the respective orders (plus determinant
   data), not the element-order distributions or presentations that distinguish the abstract
   types.  The distributions above independently confirm both labels, so this does not threaten
   the verdict; nevertheless guardrail 1 requires those group facts to be derived in the
   certificate rather than asserted.  Add the distributions/checks in the next bundle revision,
   or make the obstruction statement use only the already-certified order/determinant facts.

2. The report and JSON say X3 retains *only* its abstract orbit-valued-selector statement.  That is
   too broad: C447 removes row 35's cap-to-golden identification and therefore forbids causal
   wording, but C460's positive 15-point cloud selector and unordered-sheet recovery remain exact
   geometric inputs to X3.  The warranted consequence is: **X3 keeps its abstract obstruction and
   C460 orbit-valued positive geometry; the cap-lane comparison is consistency only, not
   causation.**

The additional projectivity `g=(0,1;4,10)` sends the class-4 frame
`{inf,0,2,3,5}` to the class-7 frame `{inf,0,7,8,10}` and `{1,4}` to `{3,4}`.  This is a useful
strengthening showing the two knife-edge configurations are one `PGL_2(11)` orbit, but it is not
needed for the negative verdict and its absence does not itself block GREEN after the two findings
above are addressed.

## Boundary

This review validates only the bounded q=11 reconstruction and equivariance obstruction.  It does
not re-solve the cap game, infer P/N values from symmetry, or identify the two cap classes with the
two golden sheets.
