# Clebsch rigidity paper

Working root for the focused rigidity/decoder manuscript provisionally titled
*Deep-hole rigidity of the Clebsch hexagon code*.

- Owner: `clebsch` lane. C576 built the candidate; C320 now owns its
  verification/release surface.
- Base: the exact older focused manuscript snapshot pinned by C575.
- Scope: rigidity, quantitative gaps, decoding, automorphisms, support bipartition,
  Brianchon reconstruction, `q=11` uniqueness, the `4 <= k <= 7` classification,
  and their verification architecture.
- Boundary: no factorization-memory development beyond an optional compact `H_3`
  explanation approved by C575.

The manuscript is `clebsch_rigidity.tex`. It was populated from the exact
17-page source at `7d258dcd6cda9f54c330d4b705d553a975749014` and then given
only the C575-approved Paper I backports. The broad fallback in
`../clebsch-hexagon-code/` remains unchanged.

This is the active Clebsch manuscript. Build it from `papers/` with
`make -B clebsch-rigidity`; the `clebsch` target builds the preserved
mega-paper fallback.
