# Icosahedral MDS / deep-holes archive

## 2026-07-14 — C132 adversarial correction

The finite Valentiner and Hesse claims from C132 were independently reconstructed with a durable
standard-library verifier. It confirmed projective Valentiner group order 360, orbit/triple data
`(36,240),(45,660),(60,1260),(60,1560),(180,44340)`, and that the 12 Hesse secants cover all 57
points of `PG(2,7)`.

The review found that the original 27-line rejection conflated finite-geometric models. The
classical model is `GQ(2,4)=Q⁻(5,2) ⊂ PG(5,2)`, with 27 quadric points and 36 external points, not a
27-point `PG(5,4)` model with no complement. Its 45 contained lines still make it non-cap, so the
specific arc/MDS target remains negative. C132 was narrowed from a claimed structural exhaustion to
a closed four-target spike; no global uniqueness or exhaustion of genus-zero examples is asserted.

## 2026-07-15 — C180 equality-case extraction completed

The last internal C180 seam was closed in Lean. A canonical labelling sends each of the fifteen
chords of a six-arc to its intersection with a disjoint five-covered-point line. Equality of
colours on adjacent chords forces equality of the chord lines, so this is a proper five-edge-
colouring of `K6`. A field-free semantic argument turns the colouring into a one-factorization;
the finite certificate then exposes three distinct named colour classes on the nine edges of the
standard triangular prism. Transporting those classes back supplies the incidence prism witness,
and the existing projective affine obstruction proves that the equality case forces
characteristic two.

Focused builds of `RelativeConicArcs.SixVertexOneFactorization` and
`RelativeConicArcs.OddSixArcPrismExtraction`, followed by a joint `--no-build` freshness probe,
passed with `LEAN_NUM_THREADS=1` and `choom -n 500`. The manuscript-facing results
`properFiveEdgeColoring_extract_prism_edges`, `incidencePrismWitness_of_five`, and
`card_coveredOnLine_ne_five` report only `propext`, `Classical.choice`, and `Quot.sound`.
