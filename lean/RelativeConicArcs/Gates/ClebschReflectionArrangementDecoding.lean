import RelativeConicArcs.ReflectionArrangementDecoding

/-!
# Reflection-arrangement coordinate and decoding bridge — re-export

This import-only gate re-exports the explicit `ZMod 11` and `ZMod 5` coordinate checks for the
fifteen-line and six-line arrangements, the invertible coordinate map and its contragredient action,
the projective distinctness and incidence spectra of both coordinate tables, the two-sided
frame-join/braid-form correspondence, and the affine-ray theorem relating incidence multiplicity
`0,1,2,3,5` to actual nearest-leader count `20,1,2,3,1`.  The point/scalar map is bijective onto all
nonzero syndromes, and the disjoint incidence-one/incidence-five union is exactly the semantic
one-leader stratum.

The imported modules check coordinate tables and arithmetic.  This gate does not itself identify
the tables with abstract Coxeter arrangements or interpret the integer factorizations as
characteristic-polynomial theorems.
-/
