# Clebsch discovery track

**Date opened**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Mode**: append-only observation log. This file catches incidental “hmm, interesting” facts,
surprises, failed intuitions, and questions encountered while executing the queued paper repairs.
It is not a task queue, proof ledger, or authority for manuscript claims. Promote an item to the
global queue/report only after scoping and verification; leave the original observation here with a
pointer rather than rewriting its history.

For every new observation, also record the strongest natural question it raises and classify it as
**answer in this paper**, **follow-on**, or **do not pursue yet**. This preserves reader-driven
questions without allowing the discovery log to expand manuscript scope by itself.

## 2026-07-14 — takeover and cheap-upgrade pass

- The two appearances of `252` conceal unrelated sets. The perturbation count is genuinely
  `6·42=252`; the conic-six-subset count is `C(12,6)=924`, while `252` there was only the number of
  concyclic representatives in a particular frame-normalized sweep. Promoted to C165 and the
  takeover audit.
- The local perturbation multiplicities are not arbitrary: the 252 moves form eight `A₅` orbits of
  sizes `30,60,30,30,30,12,30,30`, on which the fixed-conic symmetric differences are respectively
  `18,19,20,20,20,22,22,24`. Promoted to C171.
- Literal global “nearest other embedded six-arc” language fails for a symmetry reason before any
  search: a conic-preserving projectivity produces a distinct Clebsch arc with the same deep-hole
  conic. This suggested minimizing over all conics instead, producing the PGL-invariant `δ(A)` of
  C171.
- The finite residue in “Why q=11” is unexpectedly tiny. Frame-normalized sweeps at q=7,8,9,13
  contain only `70,195,441,4015` representatives and no full-conic uncovered locus. The diagnostic
  result suggests unconditional uniqueness is a seconds-scale computation, not a new research
  program. Promoted to C170.
- The q=13 on-conic six-set behavior is counterintuitive: every six-subset has at least one
  accidental concurrent perfect matching, although q=11 has 264 with none. Thus existence of a
  concurrency-free finite hexagon is nonmonotone at small q. Promoted as the separate C175 question.
- The q=11 identity `t(H)+|U(H)|=82` is not intrinsically an 82: the same double count gives
  `t(H)+|U(H)|=q²-14q+115` for every six-subset of a nonsingular conic. The Mathieu theorem is the
  exceptional q=11 extremal classification inside a family-level identity. Promoted to C174.
- Correcting “deep holes are a conic” may reveal a stronger code-level symmetry statement rather
  than merely weakening the title: scalars move along each of the twelve syndrome rays, `A₅` moves
  between the rays, and code translations move inside a coset. If the exact monomial-group audit
  confirms the expected action, all 159720 received-word deep holes form one natural orbit.
  Promoted to C172.
- The automorphism audit overturned the manuscript's most natural-looking group identification.
  For the displayed normalization the pure coordinate-permutation group is trivial, while the
  projective/support group is the exotic `A₅` and the full monomial group has order 600 with scalar
  kernel of order ten. This is not merely a terminology correction: it makes the actual coding
  symmetry richer (`C10 x A5`) while showing that the outside exotic-`S5` coset used in the old
  chirality proof consists of non-automorphisms. Promoted to C163/C164/C172.
- The first checker replay exposed a second-order terminology failure: `U(A)` is always the
  extension/weight-three syndrome locus, but it is the projective deep-hole syndrome locus only
  when nonempty and hence when the covering radius is three. For the complete q=9 six-arc and the
  complete ten-arc foil, `U(A)=∅` while deep holes still exist at distance two. The old manuscript
  and checker verdicts “no deep holes” were therefore false. Corrected under C163.
- The projective 1/2/3 secant dictionary is itself plane-specific. In higher redundancy the coset
  weight is the least number of parity-check columns spanning the syndrome direction, and an MDS
  extension must avoid hyperplanes spanned by `r-1` columns, not merely secants. The `[6,3]`
  self-dimension coincidence had hidden both distinctions. Corrected under C163.
- “Concyclic arc” and “arc whose extension locus lies on a conic” are independent properties in the
  same proof: 252 normalized representatives have their six vertices on conics, while only six
  Clebsch-class representatives have `U(A)` on a conic. A checker variable named `concyclic`
  silently collapsed them. Renamed and its output contract corrected under C163.
- The Petersen graph on the ten complementary support pairs is not defined by “some representatives
  intersect in two” (that gives `K10`). It appears only after consistently choosing the member from
  one of the two `A5` triple orbits; the other global choice gives the same graph. This makes the
  Petersen structure compatible with, but unable to orient, the unbased chirality torsor.
- The exact normalizer checker identifies the exotic `S5` through its faithful action on the five
  Klein-four subgroups of `A5`. This produces a canonical abstract five-set before Dye's five
  self-polar triangles enter. If each triangle has the corresponding `V4` stabilizer, C173's desired
  map is no longer a blind search: triangles should match the five `V4`s, and complementary support
  pairs should match their two-subsets.
- The five self-polar triangles likely do not partition the ten support-pair objects; C124 already
  rules out an invariant five-pair block system. The more natural relationship is that the ten
  complementary support pairs are the two-subsets of the five triangles, explaining the Petersen
  action. Promoted to C173 for an explicit equivariance test.

### Related questions opened by this pass

- **Answer in this paper:** Is q=11 unique without assuming `A₅`? C170 is designed to close this,
  since the counting lemma reduces it to four tiny residual sweeps.
- **Answer in this paper:** What is the nearest non-Clebsch class to *some* conic, rather than to a
  fixed coordinate conic? C171's PGL-invariant `δ` is the correct formulation.
- **Answer in this paper:** Once the conic is correctly identified as a projective syndrome locus,
  what structure remains on the actual 159720 received words? C172 tests the expected single-orbit
  answer.
- **Answer in this paper:** Which symmetry group belongs to the fixed matrix, to the monomial code,
  and to the six projective column rays? C163 now has an exact tracked answer; C172 should expose the
  resulting syndrome- and received-word-orbit structure without reverting to “permutation group”.
- **Answer in this paper:** Is the chirality a genuinely oriented binary invariant or only an
  unordered two-class decomposition? The group audit points to the latter unless C164/C173 finds a
  geometric orientation independent of the displayed coordinates.
- **Answer in this paper:** Can the paper use one locus notation uniformly when the covering radius
  changes? Yes: reserve `U(A)` for extension/weight-three directions, define
  `D_proj(C)` by the actual covering radius, and identify them only under `U(A)≠∅`.
- **Follow-on:** For the complete q=9 and q=11 ten-arc foils, what geometry do the actual
  distance-two deep-hole directions carry? This is a legitimate comparison question, but it is not
  needed for the Clebsch rigidity spine.
- **Answer in this paper:** What is the dimension-independent form of the arc--coset dictionary?
  State it once as minimum spanning number plus avoidance of `(r-1)`-column hyperplanes, then
  specialize to secants only at redundancy three. C163 now does this.
- **Answer in this paper:** Does the Petersen graph orient the two chirality classes? No: simultaneous
  complementation preserves its adjacency, so the graph descends to complementary pairs but cannot
  choose `O+` over `O-`. Any orientation would need the extra geometry sought by C173.
- **Answer in this paper if explicit, otherwise follow-on:** Are Dye's five triangles the geometric
  realization of the five `V4` subgroups used by the normalizer checker? C173 can test stabilizers
  directly; a positive answer would explain the Petersen ten-set without manufacturing a new
  orientation.
- **Answer in this paper if explicit, otherwise delete:** Do Dye's five triangles geometrically
  explain the Petersen/chirality ten-set? C173 must distinguish an explicit geometric bijection from
  a merely abstract isomorphism of `A₅`-sets.
- **Follow-on:** For which prime powers does a conic admit a six-set with no accidental concurrent
  perfect matching? C175 begins with the nonmonotone q=11/q=13 surprise.
- **Follow-on:** Can the global conic-distance `δ` be bounded or classified uniformly in q once the
  q=11 spectrum is known? Do not put this family question in the present paper without a mechanism.
- **Do not pursue yet:** Is there a higher-dimensional named-variety deep-hole locus? The natural
  dual-variety candidate is already refuted and no replacement construction is visible.

## 2026-07-14 — unconditional small-field closure

- The elementary bound plus an exact nine-field sweep proves more than the old icosahedral
  rationality argument: `U(A)=C(F_q)` for a nonsingular conic forces `q=11` with no automorphism
  hypothesis. The old q=9 subgroup-conjugacy gap disappears rather than needing repair. Promoted
  and closed under C166/C170.
- The smallest fields are more rigid than the original narrative suggested. There are no
  frame-normalized six-arcs at q=2 or q=3; the unique normalized q=4 arc and all three normalized
  q=5 arcs are complete, with `U=empty`. The first nonempty extension loci in this census occur at
  q=7, but have only two points.
- The six q=11 conic matches are six frame-normalized representatives, not six projective classes.
  The q=11 rigidity census collapses all six into the single Clebsch orbit. This is a useful warning
  against reading normalization multiplicity as classification multiplicity.
- An adversarial audit found a test-coverage surprise: the characteristic-two nonsingularity
  routine was mathematically correct but unreachable from the original census because no q=4 or
  q=8 uncovered locus had size `q+1`. Explicit standard-conic, line-pair, and double-line sanity
  cases now exercise the branch at q=2,4,8.

### Related questions opened by the unconditional theorem

- **Answer in this paper:** Is the q=11 conclusion conditional on icosahedral symmetry? No; state
  the unconditional theorem and disclose the finite census. This is now landed under C170.
- **Answer in this paper:** Are the six q=11 matches six new configurations? No; say explicitly
  that they are normalized representatives in one PGL orbit.
- **Follow-on:** Is there a conceptual, classification-free reason that the small-field residue
  singles out q=11, perhaps through an identity constraining the secant overlap multiplicities?
  The current proof is exact and fast but computational after the elementary bound.
- **Follow-on:** Can the complete small-q extension-locus spectra be classified geometrically, in
  particular the two-point q=7 and four-point q=8 loci? They are reader-visible byproducts, not
  needed for the Clebsch spine.

## 2026-07-14 — coding-level orbit structure

- Translating projective rigidity back to codes is exact and costs no new census: projective
  equivalence of parity-check rays is monomial equivalence of the codes. Thus the Clebsch code is
  unique up to monomial equivalence among `[6,3,4]_11` codes with covering radius three and a
  conic projective deep-hole syndrome locus. Promoted and closed under C172.
- The `1200+1200` chirality split is not the orbit decomposition under `MAut(C)`. The 2400 leaders
  form four free orbits of 600, with two orbits in each chirality. Over one syndrome, its order-five
  stabilizer has four leader orbits of five, again two per chirality. The manuscript must continue
  to call chirality an invariant bipartition, not “the two orbits.”
- Code translations change representatives inside a fixed syndrome coset and are therefore the
  missing symmetry at the received-word level. Together with `MAut(C)` they make all 159720 deep
  holes one orbit under a group of order 798600; a word stabilizer is cyclic of order five.

### Related questions opened by the orbit computation

- **Answer in this paper:** Is projective uniqueness also uniqueness of the code? Yes, up to
  monomial equivalence; C172 now states the short parity-check-column proof.
- **Answer in this paper:** Are the 120 deep-hole cosets or the 159720 received deep holes split by
  chirality? No. The cosets are one monomial orbit and the received words one affine-isometry orbit;
  chirality belongs to the minimum-weight leader/support structure.
- **Answer in this paper:** Are the two chirality classes themselves monomial orbits? No. Each is
  the union of two regular 600-orbits; the exact checker now guards the distinction.
- **Follow-on:** Can the cyclic order-five stabilizer of an individual deep hole be identified
  canonically with one of the six five-fold-axis subgroups in the Clebsch geometry? The order and
  abstract type are automatic; a coordinate-free identification may illuminate the code/icosahedron
  bridge but is not needed for this paper.

## 2026-07-14 — computation-source hardening

- The second `252` now has its own fail-closed certificate. Exactly 252 frame-normalized six-arcs
  have their vertices on a conic, with extension-locus histogram
  `{18:30,19:60,20:90,22:72}`. This has no set-theoretic relation to the 252 one-point neighbors in
  C165, whose histogram includes 24 and uses a fixed-conic discrepancy instead of `|U|`.
- “Tracked file exists” was too weak a reproducibility gate: five legacy scripts printed the right
  values without asserting them, and four had replayed working-tree changes absent from the index.
  All named scripts are now fail-closed and their exact current sources are Git-indexed.

### Related questions opened by the source audit

- **Answer in this paper:** Are the two occurrences of 252 the same orbit or construction? No. Keep
  the normalized-concyclic census and local replacement graph explicitly separate; their exact
  histograms now make accidental conflation mechanically visible.
- **Answer in this paper:** Which formal artifact certifies the base q=11 coding facts? Name the
  tracked root `lean/RelativeConicArcs/Q11Coding.lean`, not only a vague companion development.
- **Do not pursue yet:** Can every decorative classical-invariant claim be turned into a checker?
  C167 should first delete claims that do not support the paper's spine; C128 certifies only the
  reduced syzygy material that survives that cut.

## 2026-07-14 — global nearest-conic geometry

- Minimizing over all 160930 nonsingular conics produces a genuine projective invariant. On the 15
  PGL classes its exact histogram is `{0:1,12:2,13:1,14:3,15:1,16:4,17:2,18:1}`. The Clebsch
  class is the unique zero, so the sharp non-Clebsch gap is 12. Promoted and closed under C171.
- The two classes at global distance 12 reach it by different mechanisms. C01 has `|U|=20` and a
  unique nearest conic meeting `U` in ten points; C11 has `|U|=16` and nine nearest conics, each
  meeting `U` in eight points. “The nearest competitor” is therefore not a single geometric type.
- Nearest-conic multiplicity varies sharply even at similar `|U|`: from one for C01/C15 to sixty
  for C04. This multiplicity is a new class invariant exposed for free by the exhaustive search.
- The local 252-neighbor histogram resolves into eight `A5` orbits. Two use replacement points on
  the conic: the size-60 orbit uses secant deleted--replacement lines, whereas the size-12 orbit is
  polar/tangent. The other six are size-30 off-conic orbits, and every deleted--replacement line
  contains exactly one other base vertex. The checker freezes these incidence fingerprints.
- Global `delta` and local fixed-conic `d_C` answer different questions. The sharp global
  non-Clebsch bound is 12; the local neighbor bound remains 18. Neither number implies the other.

### Related questions opened by the global census

- **Answer in this paper:** Is there a true projectively invariant replacement for the false global
  nearest-embedded-arc gloss? Yes: nearest-conic discrepancy, with unique zero and sharp gap 12.
- **Answer in this paper:** Why does the local histogram have its particular multiplicities? The
  eight `A5` move orbits recover it exactly; the manuscript now states the orbit sizes.
- **Follow-on:** Can the two distance-12 classes C01 and C11 be characterized synthetically from
  their unique-versus-nine nearest conics, rather than by canonical coordinates?
- **Follow-on:** Does nearest-conic multiplicity encode a known cubic-surface or arc invariant, or
  does it refine the classical 15-class table genuinely? The values `1..60` suggest more structure
  than the distance spectrum alone.
- **Answer in this paper if concise, otherwise follow-on:** Do the secant/tangent/polar fingerprints
  give conceptual names to all eight local move orbits? Two conic-replacement orbits already have
  clean descriptions; the six off-conic rows may need a second invariant to avoid coordinate labels.

## 2026-07-14 — Klein provenance and the single-spine edit

- The old Klein computation was not merely unstaged; its executable source existed only at a
  session scratchpad path. The C125 note preserved a transcript while saying the script was
  reproduced. This is a useful stronger failure mode for C168: a detailed prose transcript is not a
  reproducible artifact.
- The reduced syzygy is correct, but proving it exposed a sharp trust boundary. It certifies the
  three coefficient reductions and polynomial identity, not the reduced icosahedral group,
  conjugator, diagonal pairing, or pole correspondence that surrounded it in the manuscript.
- The robust Lean proof is more informative than a final coefficient comparison: it first proves
  the exact integer syzygy, maps coefficients through `Z → ZMod 11`, and then proves equality with
  the displayed canonical reductions. This guards both the classical coefficient transcription
  used by the paper and the modular arithmetic.
- A small formalization surprise: `reduce_mod_char` did not reduce numerals at the inherited
  `Polynomial (ZMod 11)` characteristic in this toolchain. Mapping the integer identity and proving
  the scalar reductions explicitly avoided relying on tactic pattern matching and made the proof's
  trust boundary clearer.
- The standalone Klein and Further remarks sections were removable without touching any theorem or
  proof. Their own opening admitted they were unused. Removing them cut roughly 180 manuscript
  lines and three bibliography entries while preserving the q=19 same-construction foil, which is
  the comparison that actually tests the headline mechanism.
- The Mathieu paragraph's conclusion was negative (“unrelated to its blocks”), and the ten-arc
  paragraph inferred “generic” behavior from one orbit. Both were scope liabilities, not supporting
  evidence. The dual-code and Schreier facts remain valid tracked byproducts but belong in a data
  note or companion paper rather than this rigidity argument.

### Related questions opened by the provenance and scope pass

- **Do not add to this paper:** Can the C125 group/conjugator/diagonal computation be reconstructed as
  a tracked checker? Yes, probably cheaply, but the resulting claim is historical ancestry rather
  than support for rigidity. Restore it only in a follow-on devoted to the Klein reduction.
- **Follow-on:** Do the reduced face and edge forms have projective stabilizer exactly `A₅` over
  `F₁₁`, even though the reduced vertex divisor has the full `PGL₂(11)` symmetry? A positive exact
  answer would isolate which invariant first remembers the icosahedral subgroup.
- **Follow-on:** Can one classify the good primes at which a Platonic vertex form fills all of
  `PG(1,p)` and determine when the accompanying higher invariants retain the original group? This is
  the conceptual family question the deleted multi-prime paragraph was gesturing at but did not
  answer.
- **Follow-on:** Is there a concise homogeneous Lean formulation of the degree-60 binary identity?
  It would close a minor formal trust boundary, but it would not improve the main paper's theorem.
- **Answer in this paper only after the gem result stabilizes:** Can the q=11 extension-count
  spectrum be summarized by `t(H)+|U(H)|=82` without importing the separate Mathieu
  characterization? C167 should add exactly that seam once C155/C174 owns a citable proof.
- **Follow-on/data note:** Isoduality, the Schreier icosahedron, and the complete ten-arc orbit are
  three correct views of the same symmetry. Is there a short “Clebsch code atlas” that presents
  them as computed structure without asking them to carry a rigidity paper?

## 2026-07-14 — the gem seam is a general six-arc identity

- The queued conic formula `t(H)+|U(H)|=q²-14q+115` does not use a conic at all. It holds for every
  six-arc in every finite projective plane. The proof is just the first two classical secant-index
  moments plus the fact that an off-arc point lies on at most three chords. This is a genuine free
  upgrade and simultaneously a novelty demotion: the identity is stronger, cleaner, and more
  classical than expected.
- The exact correction term is the accidental triple-concurrence count `c(H)`:
  `t=60+c` and `|U|=q²-14q+55-c`. At q=11 the two quantities sum to 82, so the four on-conic
  extension values `{18,19,20,22}` are simply the reverse of `t={64,63,62,60}`.
- The gap at `t=61` is not a general combinatorial prohibition. At q=13, exactly 2184 of the 3003
  conic six-subsets have `(t,|U|)=(61,41)`. The missing 61 at q=11 therefore really comes from the
  four `PGL₂(11)` stabilizer types, not from the index equations.
- Two small-field boundary rows are unexpectedly uniform: the unique q=5 subset has `(70,0)`, and
  all 28 q=7 subsets have `(64,2)`. They are good controls for any conceptual orbit explanation.
- Manifest replay found that a tracked C147 proof script printed “HOLDS/FAILS” but never asserted
  the result, so exit zero did not certify its headline. Its arbitrary orbit representative also
  sometimes printed `t=None` because a tuple key depended on label order. Both scripts are now
  fail-closed on the full spectrum and use order-independent keys. “Tracked” and “replayed” remain
  insufficient unless the expected result is asserted.

### Related questions opened by the six-arc identity

- **Answer in this paper:** Can the on-conic `|U|` spectrum be explained without importing a second
  Mathieu spine? Yes. State only `t+|U|=82`, cite the separate note, and say explicitly that the
  design characterization is not used. C167 now does exactly this.
- **Follow-on:** For every `k≤7`, off-arc secant multiplicity is at most three, so the same truncated
  inclusion--exclusion gives a closed formula. Is there a useful uniform `k`-arc statement, or is
  `k=6` the sole value where an extremal row meets a named design?
- **Follow-on:** For `k≥8`, can higher secant-index moments organize the full inclusion--exclusion
  correction? This may give a principled language for the q=23 octad failure without suggesting a
  nonexistent Mathieu tower.
- **Follow-on:** Why are the q=7 conic six-subsets all in one concurrence/extension row, while q=13
  immediately realizes four rows including defect one? A `PGL₂(q)` orbit analysis at these two
  controls may isolate what is special about q=11's `0,2,3,4` defect spectrum.
- **Reader question worth answering in C155:** Which part is genuinely new once the orbit table and
  secant equations are classical? The answer must be the bridge from concurrent matchings to
  fixed-point-free stabilizing involutions, and from that bridge to the Mathieu design—not the raw
  identity or orbit sizes.

## 2026-07-14 — the five triangles really do explain Petersen

- The feared five-versus-ten mismatch has a canonical resolution. The five self-polar triangles
  are the five perfect matchings in the unique `A5`-invariant synthematic total. An unordered pair
  of matchings is an alternating six-cycle, and its two colour classes are one complementary pair
  of three-supports. Thus ten objects arise as `C(5,2)`, not as a nonexistent five-pair partition.
- The Petersen adjacency is exactly disjointness of triangle pairs, so the graph is visibly
  `KG(5,2)`. Pairs sharing a triangle give its six-regular complement. This supplies the conceptual
  statement that the earlier exhaustive orbit certificate was missing.
- The coordinate identification is not merely abstract: the invariant total is unique, and exact
  polarity arithmetic verifies that all five matching-triangles for the displayed columns are
  self-polar for `XZ=Y²`.
- The full normalizer `S5` acts on the five triangles and on all ten pairs. Its odd coset still
  exchanges the two chirality classes, so the five-object explanation sharpens the geometry without
  manufacturing a preferred sign.

### Related questions opened by the triangle-pair model

- **Answered in this paper:** Do the five classical triangles index a natural code object? Yes:
  their two-subsets index the complementary weight-three support pairs and explain Petersen.
- **Follow-on:** Is choosing one chirality class equivalent to a coherent orientation of all ten
  alternating cycles, and can the obstruction to extending that choice from `A5` to the normalizer
  be expressed as a concrete sign cocycle rather than only an orbit swap?
- **Follow-on:** Do the ten triangle pairs coincide geometrically with Dye's ten Brianchon points,
  giving a direct triangle-pair → support-pair → Brianchon-point dictionary? The shared cardinality
  and `A5` action make this plausible, but the present certificate does not identify the incidence
  map.
- **Follow-on:** Does the five-triangle action organize the four size-five leader orbits inside a
  fixed deep-hole coset, or are those `C5` orbits dependent on the chosen syndrome in a way the
  synthematic total cannot see?
- **Reader question worth one sentence:** Why is the total canonical? Among the six synthematic
  totals on the coordinates, exactly one is stabilized by the exotic `A5`; its stabilizer is the
  full `S5` normalizer.

## 2026-07-14 — exterior-set ancestry changes the novelty boundary, not the theorem

- The closest classical object is 35 years earlier than the draft acknowledged. Edge's 1956
  `q=11` Clebsch hexagon already has the six external vertices, fifteen external joins, order-60
  stabilizer, five synthematic triangles, and two systems of eleven hexagons. Dye remains the
  general-field synthetic source, not the finite configuration's first source.
- The vocabulary distinction is mathematically clarifying: a complete exterior set constrains the
  joins to avoid the conic, while the deep-hole statement says those same joins cover every point
  outside the arc and conic. The latter is stronger and is exactly the part not found in the
  accessible classical sources.
- There is a prior coding connection, but to LDPC stopping sets for sets without tangents. It does
  not anticipate the MDS syndrome/deep-hole interpretation. Saying this directly is stronger than
  implying no coding literature exists.
- Edge's two systems of eleven hexagons are genuinely exchanged by the non-PSL operations, but they
  are not the paper's two support-chirality orbits. The shared two-class motif is worth citing only
  with that object-level distinction explicit.

### Related questions opened by the exterior-set rebase

- **Submission gate:** Do either of the two BSW originals state that the fifteen joins miss exactly
  the rational conic, or an equivalent complement/coverage formula? C153 must answer this from the
  originals; the current priority claim is deliberately conditional.
- **Answer in this paper:** What is new beyond the classical exterior set? The all-six-arc rigidity
  characterization, global/local quantitative gaps, chirality/code-orbit structure, and
  unconditional isolation of `q=11` remain even if the single-hexagon covering identity collides.
- **Follow-on:** Is there an internal-point analogue of a no-three-collinear exterior set whose
  joins avoid a conic? The literature sweep found only much weaker all-internal sets without
  tangents; the exact arc analogue appears untreated.
- **Follow-on:** Can Edge's two systems of eleven hexagons be seen directly in the 15-class
  nearest-conic census or in the monomial-code equivalence classes, without conflating them with
  chirality?
- **Reader question worth answering after C153:** Does the BSW complete-exterior-set conjecture
  interact with the stronger covering property, or is `q=11` the only known point where an
  exterior-set extremum also saturates every off-conic point?

## 2026-07-15 — the strongest remaining route from A− to A/A+

- C174 turns the q=11 rigidity condition into a classical Brianchon-extremality question. For any
  six-arc in `PG(2,11)`, write `c` for the number of accidental concurrent perfect matchings, or
  equivalently off-arc Brianchon points. The general identity gives

  ```text
  |U(A)| = 22 - c.
  ```

  Dye's accessible self-recap says a hexagon has at most ten Brianchon points and that equality
  characterizes the Clebsch hexagon up to projectivity. If the primary theorem has exactly that
  scope in characteristic 11, then `c≤10` gives `|U(A)|≥12`; containment of `U(A)` in a nonsingular
  conic gives the reverse bound `|U(A)|≤12`; hence `c=10`, and Dye's equality case identifies the
  Clebsch class. This would replace the main nonsingular-conic census proof by three conceptual
  lines.
- Two honest gaps remain in that route. The primary Dye theorem must be read and its hypotheses
  checked, and the manuscript's stronger allowance of a degenerate containing conic needs a
  structural line-pair exclusion. The current computation proves the degenerate exclusion, but an
  A/A+ upgrade requires a short lemma rather than silently retaining that half of the census.
- The same identity suggests a conceptual all-field isolation. If the full uncovered locus is a
  nonsingular conic of size `q+1`, then

  ```text
  c = q² - 15q + 54 = (q-6)(q-9).
  ```

  Combining this with a field-uniform Brianchon bound collapses the possible orders to a handful of
  small fields. Structural exclusions at `q=4,5,9` could then replace C170's nine-field census and
  make “why 11” a theorem of geometry rather than enumeration. Characteristic two and the exact
  range of Dye's theorem must be handled explicitly.
- C153 is potentially constructive, not merely defensive. If BSW's characterization of complete
  exterior sets identifies the q=11 equality object, it may supply an independent structural bridge
  from “all joins avoid the conic” to the Edge/Clebsch orbit. Even a priority collision could
  therefore improve the proof while narrowing the novelty claim.
- The next-best moderate upgrade is to characterize the two sharp `δ=12` classes and the eight
  local move orbits synthetically. The exact gap is already strong; names or incidence criteria for
  its minimizers would turn a table into geometry without changing the paper's spine.
- The cheapest conceptual upgrade is the missing ten-object dictionary: test whether the ten
  unordered pairs of self-polar triangles map naturally to the ten Brianchon points, and then to
  the ten support-pair/Petersen vertices. A positive map would unify C173's code chirality with the
  classical hexagon rather than merely matching their `A5`-sets.
- C175 and the uniform `k≤7` moment formula are attractive family questions, but they strengthen the
  gem/hexad program or a follow-on. Pulling them into the Clebsch paper without a concise theorem
  would recreate the multi-spine problem C167 removed.

### Grade threshold

- **A is realistically reachable** by closing the source gates, replacing the nonsingular rigidity
  census with the Brianchon equality proof, proving the degenerate line-pair exclusion, and giving
  at least one synthetic explanation of the sharp gap or Brianchon/Petersen correspondence.
- **A+ requires a qualitative theorem, not more census rows:** either a classification-free proof
  of both rigidity and all-field q=11 isolation, or a genuinely uniform family theorem in which the
  Clebsch code is the exceptional equality case. Extra exact tables, another foil, or restored Klein
  material will not plausibly supply that jump.

### Questions to answer next

- Does Dye 1991 prove `c≤10` for every relevant field and classify `c=10`, or does the accessible
  recap suppress characteristic or nondegeneracy hypotheses?
- Can `U(A)⊂L₁∪L₂` be ruled out from secant-index equations and line intersections alone?
- Can the small candidate fields forced by `c=(q-6)(q-9)` be excluded without a frame census?
- Does BSW's original characterization provide the missing exterior-set classification at q=11?
- Is the sharp nearest-conic gap `δ=12` controlled by a Brianchon defect such as `10-c`, together
  with one additional incidence invariant?
- Are Dye's ten Brianchon points canonically the ten two-subsets of the five self-polar triangles,
  and does that map agree with C173's ten complementary support pairs?

## 2026-07-15 — Pascal twins and generalized-hexagon reguli

- The missing ten-object dictionary is exact, not merely an `A5`-set cardinality match. For two
  self-polar triangles in the invariant synthematic total, their union is an alternating Hamiltonian
  six-cycle. The cycle's bipartition is C173's complementary support pair, while its antipodal
  perfect matching gives three Clebsch chords concurrent at one Brianchon point. The ten triangle
  pairs give all ten non-total matchings and ten distinct Brianchon points. Promoted to C176; the
  checker must still freeze concurrence, the `10×3+15×1` cross-intersection multiplicities, and
  geometric equivariance before the manuscript uses it.
- Halbeisen--Hungerbühler's 2024 Pascal-twin class `e1` is the 60-element `S6`-set of undirected
  Hamiltonian cycles, with stabilizer `D12`. On the Clebsch `A5` it splits `10+20+30`; the size-ten
  orbit is exactly the cycles formed by pairs of the five self-polar triangles. This is a useful
  modern home for the cycle construction, not a collision with the paper's exterior-arc, coding,
  or uncovered-locus results. The computed degeneration signatures of all three orbits remain
  follow-on evidence unless separately certified in a tracked checker.
- De Wispelaere's generalized hexagons are not six-point plane hexagons and do not collide with the
  Clebsch paper. The surprise is instead at q=11: every point regulus is a 12-point conic, so it
  locally carries the two Mathieu hexad systems. The `B2` blocks of her `2-(1332,12,5)` design come
  from point reguli; if the 264 local hexads are independent of the three regulus representatives
  of a repeated block, they glue to a simple `2-(1332,6,240)` design. A `PSU3(11)`-equivariant
  choice of one system would give `2-(1332,6,120)`. Promoted to the gem-mining follow-on C177.
- Wu's 2013 paper is a genuine fixed-conic internal-point neighbour, but not a code-level collision.
  Her blocks are the length-`q+1` orbits of an internal-point stabilizer in `PSL2(q)`; each is a
  conic consisting entirely of internal points, and every passant line meets it in zero or two
  points. At q=11 this gives 12-point conics among the 55 internal points and a binary incidence
  code of length 55 and dimension 31, not the `[6,3,4]_11` MDS code. Dye is cited only for
  transitivity of `PSL2(q)` on the four internal/external point/line classes. The cheap unresolved
  test is whether one of these structured internal conics contains a six-set whose fifteen joins
  are all passant. Promoted to C178.
- Madison--Wu 2012 exposes a related-work omission in the Clebsch manuscript. It proves that the
  binary nullspace of the passant-line versus internal-point incidence matrix has length
  `q(q-1)/2` and dimension `(q-1)^2/4`, hence `[55,25]` at q=11, and describes it as a
  `PSL2(q)`-module generated geometrically by internal-neighbour relations. Wu's 2013 twelve-conic
  block rows lie inside that LDPC code, while the nullspace of the conic-versus-internal incidence
  matrix is `[55,31]` at q=11. This does not touch the `[6,3,4]_11` MDS/deep-hole result, but it is a
  more direct fixed-conic coding lineage than the manuscript's current stopping-set sentence admits.
  Promoted to the bounded literature rebase C179.

### Related questions opened by these sources

- **Answer in this paper:** Does the triangle-pair map simultaneously recover the Brianchon point,
  complementary support pair, and Petersen vertex? C176 is the exact certificate-and-prose task.
- **Answer in this paper only with careful attribution:** Is the non-total-matching description of
  the ten Brianchon points already explicit in Dye or Edge? Treat it as classical-compatible until
  the primary texts settle wording; the code-support compatibility remains the new contribution.
- **Follow-on:** What geometric invariant explains the `10+20+30` degeneration of the Pascal-twin
  `e1` orbit under the Clebsch `A5`, and do the other three Pascal-twin classes carry named
  Clebsch/cubic-surface structures?
- **Follow-on:** Do the local Mathieu systems on `D_Hex(11)` glue without orientation, and does
  `PSU3(11)` preserve or exchange their two-system torsor? C177 owns the representative-independence
  and group-action checks.
- **Follow-on:** What is the clique spectrum of the passant-join graph induced on Wu's internal
  conics, beginning at q=11? A six-clique would be a structured all-internal exterior-set analogue;
  nonexistence would quantify exactly why Wu's `0/2` line-intersection condition is weaker. C178
  owns the first cell.
- **Answer in this paper:** What prior coding theory already uses the same internal/external conic
  partition? C179 should name the binary LDPC/incidence codes and state the object-level difference
  before preserving the narrower MDS covering/deep-hole novelty claim.
- **Do not add to this paper:** De Wispelaere's two-weight codes and generalized-hexagon chromatic,
  spread, and ovoid conjectures are genuine but use different geometries and do not strengthen the
  Clebsch rigidity spine.

## 2026-07-15 — dictionary and Wu-cell closure

- C176 is exact and landed. The ten antipodal matchings are precisely the ten perfect matchings
  outside the invariant synthematic total. Their chord intersections are exactly ten points of
  multiplicity three and fifteen points of multiplicity one; the triangle-pair, Brianchon-point,
  complementary-support, and Petersen labellings commute in all `600` geometric `A5` cases. This
  is now a proposition in the Clebsch manuscript, with Edge credited for the classical
  concurrences and the code-support compatibility presented as the new dictionary.
- C178 closes the first Wu cell negatively but nontrivially. There are exactly 110 distinct
  length-12 internal orbit conics over `F_11`, split into two `PSL2(11)`-orbits of 55. Their
  passant-join graphs are 12-vertex 6-regular dihedral Cayley graphs with clique numbers 4 and 3.
  Thus even the strongest structured `0/2`-intersection family in this source contains no
  all-passant six-set.
- **Follow-on question:** identify those two Cayley graphs synthetically and prove `omega=4,3`
  without enumeration. This is a cleaner explanatory target than extending the raw `q=11` census.
- C179 closes the reader-facing literature omission. The fixed-conic binary incidence codes and
  orbit-conic codes now appear in the manuscript with their exact `[55,25]_2` and `[55,31]_2`
  specializations, making the object-level boundary around the `[6,3,4]_11` MDS result explicit.

## 2026-07-15 — recovered Klein/Clebsch open-problem scout

The synchronized `asg` record recovered the completed
`/root/klein_clebsch_open_local` sub-agent report. Its important distinction is between genuine
published open problems and questions newly posed by this project.

- **Strongest published object-specific problem:** the BSW complete-exterior-set conjecture. For
  `q ≡ 3 (mod 4)`, the conjectural exceptional non-collinear exterior sets of size `(q+1)/2`
  occur only at `q=7,11`; the `q=11` object is the Clebsch hexagon. This is the natural surrounding
  open problem, but the present paper does not solve it. C153 still owns the primary-source gate.
- **Published but less specific:** the minimum sets-without-tangents problem, and the classical
  Segre/Thas complete-arc extension problems. They are useful context, not claims that the paper
  closes.
- **Best current-paper question:** replace the nonsingular part of the rigidity census by Dye's
  Brianchon extremality `c ≤ 10`, equality only for Clebsch, combined with
  `|U(A)|=22-c`; separately prove that `U(A)` cannot lie in a degenerate conic. This remains the
  best route from a strong A-minus paper to a conceptual A paper.
- **Cleanest A-plus lever:** derive `c=(q-6)(q-9)` from a conic-filling locus and combine a uniform
  Brianchon bound with geometric small-field exclusions, replacing the nine-field census by a
  classification-free explanation of `q=11`.
- **Klein follow-on:** modulo 11 the vertex form reduces to `x^11-x` and acquires full
  `PGL2(11)` symmetry. Compute the projective stabilizers of the reduced face and edge forms: do
  they first recover exactly `A5`? More generally, classify primes where a Platonic vertex divisor
  fills `PG(1,p)` while higher invariants retain the original group. This is a project-generated
  question, not a known published open problem, and does not belong back in the current paper.
- **Clebsch-cubic / `E6` follow-on:** only after the now-landed Brianchon--support dictionary, test
  whether the ten code-support/Brianchon objects extend to Eckardt points or detect the 27 lines
  and a `W(E6)/S5` quotient. The direct 27-point cap template is already dead, so the credible route
  is incidence detection rather than another arc construction.
- The scout's proposed Brianchon--Petersen question is no longer open: C176 has answered it exactly.
  Its internal-point analogue has also advanced: C178 rules out Wu's two structured `q=11`
  orbit-conic families, but not arbitrary all-internal six-arcs.

### First progress on the classification-free small fields

- The `q=4` and `q=5` candidates in `c=(q-6)(q-9)` require no census. A six-arc at `q=4` is a
  hyperoval; its 15 secants cover all 15 off-arc points exactly three times. A six-arc at `q=5` is
  the full conic, whose secants cover every off-conic point. In both cases `U` is empty, not a
  conic.
- The real residue is `q=9`. A hypothetical conic-filling six-arc would have `c=0` and would be six
  internal points relative to the uncovered conic, every pair joined by an external line. At each
  vertex those five joins exhaust the five external lines through the internal point. Explaining
  why this equality configuration cannot exist is now the entire small-field problem in C181.

### Conceptual degenerate-conic exclusion found

- For any six-arc in `PG(2,q)` over odd characteristic, every line contains at most `q-5`
  uncovered points, hence at most six when `q=11`. A
  line through an arc vertex reduces to `chi'(K5)=5`. For a line disjoint from the arc, five
  covered chord-intersection points would be a 1-factorization of `K6`; after sending the line to
  infinity, three triangular-prism factor classes force the incompatible parallelism equations
  `a(b-1)=-1` and `a(b-1)=1`.
- Hence a line pair contains at most 12 uncovered points. At `q=11`, Dye's `c<=10` and
  `|U|=22-c` force equality and `c=10`; Dye then gives the Clebsch class, whose nonsingular
  12-point uncovered conic cannot lie in a line pair. This removes the mathematical obstacle in
  C180 without enumeration. Only the exact field/descent hypotheses on Dye 1991 p.275 remain to
  be sourced before the proof enters the manuscript.

### The q=9 residue is an exact-distance Sylvester problem

- Relative to the hypothetical uncovered conic in `PG(2,9)`, the six arc vertices must be
  internal and every chord must be passant. The internal-point conjugacy graph under conic
  polarity is the 36-vertex Sylvester graph; passant joins are its exact-distance-two relation.
  Thus the forbidden arc would be a six-clique in the exact square.
- Abiad--Jabal Ameli--Reijnders (2025), Table 1, gives the published exact value
  `eq_2(Sylvester)=5`. This is exactly the missing numerical obstruction, not merely a spectral
  upper bound of six. C181 now gives the finite-geometry identification, cites the uniqueness of
  the displayed intersection array, and ships a from-scratch exact checker; the manuscript uses
  this conceptual proof and retains the nine-field census only as verification.
- **Interesting equality question:** classify the maximum five-sets at pairwise distance two in
  the Sylvester graph. The five internal points on a passant line supply one class; if every
  maximum set is of this form, the q=9 obstruction has a sharper geometric stability statement
  suitable for a follow-on.
- **Quantifier issue resolved more cheaply:** Dye's sharp `c<=10` is unnecessary for field
  isolation. Each concurrence belongs to one of only 15 perfect matchings, hence universally
  `c<=15`; then `c=(q-6)(q-9)` rules out every `q>=12`, including all characteristic-two fields
  above `q=4`. Thus C181 is independent of C180 and the Sylvester identification really is the one
  remaining bridge; that bridge has now landed.

### Dye/BSW source-access forensics

- No prior `asg` session or current web route directly reached Dye 1991 p.275 or the five-page BSW
  1992 body. The earlier claims all resolve to proxy sources, not a forgotten local copy.
- Dye's own 1997 self-recap and signed zbMATH review form a very strong chain for `F_11`: at most
  ten Brianchon points, equality unique up to `PGL3(K)`, existence when `char(K)!=2` and `5` is a
  square. This makes C180 highly likely to land unchanged, but the exact page remains a real
  primary-source gate.
- The detailed review of BSW 1992 says nonlinear complete exterior sets occur at
  `q=7,11,19,23,27,31`; the sharper “only 7 and 11” claim is correct only after adding the
  noncollinear/arc qualifier. Van de Voorde's open restatement supplies that distinction.
- Neither the BSW abstract, detailed review, nor Van de Voorde's close restatement mentions the
  stronger conclusion that the joins cover every point off the conic. This is meaningful negative
  evidence (roughly 0.8--0.85 confidence), not enough to close C153 without the original body.
- BSW 1991 is instead the tangent-free-set lower-bound paper. Its correct bibliography is Giessen
  volume 201 (1991), 39--44; an older Blokhuis list's 210/1990 entry is erroneous.
- Best access actions: ILL for Dye 1991 pp.270--286 and BSW 1992 pp.143--147; institutional
  OUP/Wiley and Springer access; then author-copy requests to Newcastle Mathematics for Dye and to
  Aart Blokhuis (`a.blokhuis@tue.nl`) for BSW. There is no relevant “Bichara--Scherk” source here;
  that name was a conflation with other finite-geometry threads.

### Updated grade forecast and the A/A+ frontier

- C181 materially raises the paper: “why 11” is now explained by a universal defect identity and a
  named graph obstruction, with the census demoted to verification. Relative to the takeover
  baseline, the conceptual-depth component moves from `A-` toward `A`.
- If C180 lands after direct verification of Dye p.275, the main rigidity theorem also becomes an
  equality argument rather than a 1548-representative classification. With C153 and C131/C161
  clean, the predicted overall grade is **A, about 9.2/10**, with a plausible **A+** from a reviewer
  who values the Clebsch--Brianchon--Petersen--coding synthesis. This is stronger than the earlier
  A-minus forecast because both formerly computational headline theorems would then have
  conceptual spines.
- The best remaining A-to-A+ upgrade is therefore C180 itself. The next best is a synthetic
  classification of the maximum five-sets in the exact square of the Sylvester graph, showing they
  are precisely the internal points on passants; that would sharpen q=9 from nonexistence to an
  equality/stability statement, but is not needed in this paper.
- C153 and C131/C161 are not glamour upgrades; they are ceiling protection. A BSW covering
  collision lowers the likely result to `A-`, even if every proof is correct, while clean originals
  make `A/A+` defensible. No further decorative Klein, cubic-surface, or generalized-hexagon spine
  should be added to chase the grade.

### Lean coverage audit after the conceptual upgrades

- The existing Lean development certifies the base Q11 witness, `[6,3,4]_11`, covering radius
  three, all twelve conic deep-hole directions, the twenty leaders over a fixed direction,
  extension spectra, the chord one-factorization, and the residual icosahedral graph. It does not
  yet certify C174, C176, C180, or C181; the current q=9 Lean examples concern a different witness.
- The best cheap strict-kernel upgrades are the generic chord-defect spine and the finite C176
  Brianchon/Petersen ledger. The q=9 Sylvester obstruction is also practical because a kernel-checked
  `GF9` already exists, but the clique upper bound should use a reflected branch-and-bound
  certificate rather than naive powerset reduction.
- Full C180 formalization divides sharply. The new line-pair implication can be formalized with Dye's
  statements as explicit hypotheses, or Q11 rigidity can be certified by a generated 1548-class
  census. A strict conceptual proof including Dye's equality classification is a major new
  formal-geometry project, not a cheap paper closeout. C183 records the staged route and trust gate.
- **Incidental correction:** formalization exposed that the generic C180 line lemma yields
  `|U(A) cap ell| <= q-5`, not a field-independent bound of six. It is six at `q=11`, so the paper's
  intended application is unchanged; the report and this log now state the correct quantifier.

### Formalization frontier: Dye versus finite-field closure

- Searches of the pinned mathlib tree and the public Rocq `projective-geometry` archive found no
  Brianchon, Clebsch, conic, Pascal, or Dye development. The Rocq archive supplies incidence-plane,
  duality, Desargues, and matroid foundations only; it does not contain a hidden equality
  classification that can be imported. Web searches of Lean, Rocq/Coq, Isabelle/AFP, Mizar, and
  Agda likewise found general projective-geometry work but no discoverable formalization of Dye's
  ten-point theorem.
- There are therefore two genuinely different projects. The paper can reach strict finite-field
  closure over `F_11` by reflecting the normalized 1548-class census, while a formalization of
  Dye's general equality classification would require the primary proof plus substantial conic,
  projective-normalization, and group-action infrastructure. The first is a practical certificate;
  the second would be a publishable formal-geometry project in its own right.
- For this paper the honest high-EV boundary is an explicit imported Dye axiom, with every new
  finite and combinatorial bridge below it kernel-checked and every manuscript-facing theorem
  audited by `#print axioms`. This makes the sole classical trust seam visible instead of allowing
  it to diffuse through coordinate computations.
- **Certificate-design surprise:** the first q=9 no-`K_6` formalization compared all 1320 triangle
  pairs and was OOM-killed despite being mathematically tiny. A bounded-memory reformulation fixes
  one triangle and searches only its five-or-six common neighbours for a second triangle. This is
  more than an engineering patch: it exposes the actual local obstruction behind the clique bound
  and should yield a clearer semantic proof than the global all-pairs table once validated.
- **Follow-on question:** can the same local common-neighbour analysis classify every maximum
  five-clique, proving directly that the extremal sets are exactly the five internal points on a
  passant? If so, the strict certificate and the proposed Sylvester stability theorem share one
  proof object rather than two unrelated computations.

### Low-degree curve loci across all fifteen classes

- The proposed claim that Clebsch is the only class whose uncovered set is the full rational locus
  of an irreducible curve is **false**. The exact evaluation-rank audit nevertheless finds a sharper
  and more interesting low-degree distinction: every non-Clebsch class has injective cubic
  evaluation (rank ten), while the Clebsch class alone has a quadratic kernel of dimension one.
  Thus Clebsch is uniquely contained in any plane curve of degree at most three.
- Two unexpected companion loci appear. Class C02 (`|U|=18`, stabilizer order six) is exactly the
  `F_11`-rational point set of its unique vanishing quartic. Class C04 (`|U|=19`, stabilizer order
  three) is exactly the rational point set of a vanishing quintic selected from its
  three-dimensional kernel. Exhaustive tests against all 133 rational lines and all 177156
  rational quadrics find no divisor; for degrees four and five this proves `F_11`-irreducibility.
  Their many rational points then rule out a nontrivial Galois-conjugate geometric factorization,
  so both are absolutely irreducible.
- Exact degree-at-most-five enumeration finds only the Clebsch conic, C02 quartic, and C04 quintic
  as full rational loci. C12 first vanishes in degree six (kernel dimension six); among all 177156
  projective sextics in that kernel, exactly sixteen have rational zero set equal to its 22-point
  uncovered locus. Singular factors the first witness as irreducible over `F_11`. An
  `F_11`-irreducible but geometrically reducible sextic would be a Galois orbit of two cubics, three
  conics, or six lines, forcing every rational point into pairwise intersections of size at most
  nine, four, or one; 22 points rule out all three. Thus C12 is a fourth absolutely irreducible
  exact minimal locus. C184 now tracks both the 133-point equality checker and a deterministic
  Singular 4.4.1 factorization replay for its normalized witness.
- **Potential paper upgrade:** the verified low-degree uncovered-locus hierarchy is more valuable
  than the originally proposed conic-to-arbitrary-curve uniqueness, because it is true and reveals
  previously invisible companion geometry. C184 supplies the tracked checker, full fifteen-class
  rank table, normalized equations, exhaustive quartic/quintic factor tests, and absolute-
  irreducibility argument; only manuscript disposition remains.
- **New questions:** why do exact minimal loci occur in the degree pattern `2,4,5,6` for classes
  C15, C02, C04, and C12, with no cubic? Do the quartic, quintic, and sextic have recognizable
  automorphism groups or classical names, and do the arc stabilizers give their full rational
  automorphism groups? Are C12's sixteen exact sextics one structured orbit or pencil? These are
  plausible follow-on results even if manuscript scope admits only the uniquely-degree-at-most-three
  Clebsch statement.
- **Companion-curve geometry:** the tracked Jacobian replay shows that C02 is a smooth genus-three
  plane quartic and the displayed C12 witness is a smooth genus-ten plane sextic. C04 has one
  geometric singularity, rational at `(10:3:1)`; its local tangent cone is
  `X^2+4XY+5Y^2`, whose nonsquare discriminant makes it an ordinary nonsplit node, so its
  normalization has genus five. This turns the accidental-looking degree ladder into three concrete
  moduli questions: identify the genus-three quartic, the nodal genus-five normalization, and the
  orbit of smooth genus-ten sextics under the corresponding arc stabilizers.

### Candidate decoding and orbit upgrades awaiting attached replay

- A PDF-only independent computation proposes a complete syndrome-distance oracle: after computing
  `s=Hv^T`, distance three is exactly the nonzero conic equation
  `s_1*s_3-s_2^2=0`; distance one is membership in an arc direction; all remaining nonzero
  syndromes have distance two. At a deep hole every one of the twenty coordinate triples is a
  valid nonzero weight-three support, since every three columns are independent and a zero
  coefficient would contradict distance three. This looks like the cheapest substantial coding
  upgrade, but its attached 1330-syndrome checker has not yet been received or replayed.
- The proposed nearest-codeword multiplicity distribution is
  `{1:960, 2:150, 3:100, 20:120}`. The ten triple-ambiguity directions should be precisely the ten
  Brianchon points: three competing secants through an off-arc point necessarily have disjoint
  supports and hence form a perfect matching. If the ten matchings are exactly the complement of
  Edge's synthematic total, the bounded-distance decoder reconstructs the five self-polar triangles
  from its ambiguity table alone. This is conceptually stronger than presenting the triangles as
  decorative geometry.
- The claimed chirality interpretation needs weaker wording. A fixed deep-hole direction has
  stabilizer `C5`, with four size-five orbits on its twenty leaders; therefore five, not ten, is the
  minimum size of an equivariant set-valued decoder. Each chirality half is a natural union of two
  such orbits and gives an equivariant `20 -> 10` halving, but it is not the coarsest or smallest
  equivariant selection. Whether one of the four five-orbits is canonically selectable under the
  full monomial action must be checked carefully.
- An orbit-theoretic proof of the uncovered conic is plausible but requires more than `c>=10`.
  The ten classical Brianchon points must be shown to form the invariant 10-orbit contained in the
  full triple-point set. With `c<=15`, no second off-arc orbit can then be added, forcing `c=10`;
  `|U|=12` and uniqueness of the off-arc 12-orbit identify the conic. The claimed plane-orbit
  decomposition `[6,10,12,15,30,30,30]` and the order-five fixed-point count must be derived or
  independently certified before this can replace Proposition 3.1's finite check.
- For seven-arcs the same two moment counts give
  `|U|=q^2-20q+120-n_3`, because the 105 disjoint chord pairs contribute
  `n_2+3n_3=105`. A conic-filling locus would require
  `n_3=q^2-21q+119`, and `n_3<=105` leaves only prime powers `q<=19`. Unlike the six-arc case this
  is a bounded finite classification program, not an immediate uniqueness theorem. It is a
  potentially strong follow-on, but should not expand the present paper until its candidate cases
  are sized.

### Correction and small-k family from the exact second moment

- The provisional seven-arc bound above used only `n_3<=105`; the exact second moment is
  `n_2+3n_3=105`, so the correct bound is `n_3<=35`. After imposing conic size,
  `n_1=3(q^2-14q+42)` as well. These two nonnegativity constraints eliminate every field except
  `q=11,13`, with forced spectra `(27,78,9)` and `(87,60,15)`. C187's live report now carries the
  corrected result.
- The same calculus produces a genuine smaller sibling. For four-arcs,
  `|U|=(q-2)(q-3)`, so conic size forces `q=5`; the standard quadrilateral's uncovered six-set is
  the nonsingular invariant conic
  `X^2+Y^2+Z^2+XY+XZ+YZ=0`. Every four-arc is projectively equivalent to the frame. This should be
  literature-checked against the classical `PG(2,5)`/six-points/outer-`S6` circle before any
  novelty language.
- Five-arcs are uniformly impossible: `n_2=15` and
  `|U|=q^2-9q+21`, while conic size would require the rootless integer equation
  `q^2-10q+20=0`. If the `q=11,13` seven-arc searches are closed, the paper can state a complete
  `k<=7` classification rather than presenting Clebsch as an isolated six-point miracle.

### Decoding replay landed and chirality meaning sharpened

- C185's hardened paper-package checker independently replays all 1330 nonzero syndromes and the
  full 600-element monomial action. The complete ambiguity enumerator
  `1^960 2^150 3^100 20^120`, the Brianchon triple-ambiguity locus, all twenty deep-hole supports,
  and four global equivariant size-five decoders now pass fail-closed assertions. This supersedes
  the provisional attached-script status above.
- The exact meaning of chirality is now clear. Five is the minimum list size for an arbitrary
  full-monomial-equivariant set-valued decoder, and four such size-five decoders exist. If a rule is
  required to be **support-determined**, independent of the syndrome coefficients/direction, its
  selected support family must be invariant under the projective `A5`; the only proper nonempty
  choices are the two ten-element support orbits `O+` and `O-`. Thus chirality is the unordered
  two-choice (`Z/2`-torsor) of nontrivial support-local halvings, not the equivariant minimum.

### Companion-curve geometry

- Exact Singular Jacobian-ideal checks add geometric structure to C184's companion loci. The C02
  quartic is smooth of genus three, and the displayed C12 sextic is smooth of genus ten. The C04
  quintic has exactly one geometric singular point, rational at `(10:3:1)`; its quadratic tangent
  cone has nonsquare discriminant seven, so it is an ordinary nonsplit node and the normalization
  has genus five. These facts belong in the discovery/follow-on layer until their concise relevance
  to the current paper is clear.

### Seven-arc Step 2 claim awaiting local artifact

- A second independent run reports zero conic-filling seven-arcs at both surviving fields. Its
  claimed exhaustive counts are `30696/3=10232` distinct frame-normalized seven-arcs at `q=11` and
  `161880/3=53960` at `q=13`: each frame-containing seven-arc is generated three times by deleting
  one of its three nonframe points. The run also reports the q=13 six-arc histogram
  `{36:85,38:210,39:480,40:1080,41:1800,42:360}` as a preflight cross-check.
- This would complete the classification for `4<=k<=7`: only the projective frame in `PG(2,5)`
  and the Clebsch six-arc in `PG(2,11)` have conic-filling uncovered loci. The correct classical
  name is a projective frame (equivalently the four vertices of a complete quadrangle), not a
  “complete quadrilateral.”
- The reported `q2_step2.py` and `flags.py` are not yet present in `../notes`, so the zero result,
  counts, and support-local partition experiment remain **provisional** until the exact artifacts
  appear, are hardened into the paper package, and replay locally. No large search has been
  launched from this lane on the strength of prose alone.

### Beyond seven points

- At `k=8`, chord concurrency can reach four and the first two moments leave two parameters
  (`n_3,n_4`); the claimed residual range `q<=22` is a finite but materially larger classification
  program, not a free corollary. It is a natural follow-on only after the `k<=7` theorem closes.
- A proposed large-arc endgame invokes a Segre theorem forcing sufficiently large odd-order arcs
  onto a conic. Once `A` lies on a conic `C'`, its uncovered locus cannot equal a full conic:
  equality with a distinct conic conflicts with the at-most-four intersection bound, while equality
  with `C'` conflicts with `U(A) cap A = empty`. The exact threshold
  `k > q - sqrt(q)/4 + 25/16`, field hypotheses, and primary source have not been verified and are
  a literature gate, not yet a manuscript claim.
- The honest open territory is therefore a middle-range program between the small fixed-`k`
  moment classifications and the large-arc conic-forcing regime. This is a better closing question
  than suggesting the Clebsch phenomenon simply stops at q=11.

## 2026-07-15 — C187 finite settlement and downstream consumers

- The provisional seven-arc result above is now settled by the tracked, fail-closed
  `check_small_k_conic_filling.py`. It reproduces the complete q=11 and q=13 six-arc histograms,
  constructs `30696/3=10232` and `161880/3=53960` distinct frame-normalized seven-arcs respectively,
  verifies every generated set is an arc with multiplicity three, and finds zero quadratic
  containment hits among the `140` and `1680` cases with `|U|=q+1`. Together with the exact chord
  moments, conic-filling uncovered loci for `4<=k<=7` occur only for `(k,q)=(4,5)` and `(6,11)`.
- The q=5 survivor is the projective frame (the four vertices of a complete quadrangle), whose six
  continuations are exactly a nonsingular conic. Its truth is settled; its classical priority and
  safest attribution remain open.
- Two cross-lane consequences are deliberately consumers, not new Clebsch ownership. C188
  (`relconic`) will use the q=5 frame to prove and formalize `rho_C(5)=L2(5)=4`, while citing C187
  for the bounded classification. C189 (`cap`, carrying the Nofil deliverable) will certify the
  six-point continuation graph as `K6` minus a perfect matching, hence octahedral, and derive the
  antipodal-copycat P-position beside the existing q=11 icosahedral example.
- This bounded classification does not advance or reformulate the odd-q `(ON)` conjecture. It
  proves only that, for `4<=k<=7`, equality `U(A)=C(F_q)` has the two classified solutions. It does
  not exclude proper-subset containment `U(A)⊂C(F_q)` or another localization; `(ON)` needs only
  one P-valued on-conic child and remains logically weaker.
- C190 has completed the gem-mining ownership seam: C159 imports C184's q=11 degree/rank atlas,
  and C160 retains only the q=5 priority search. Neither C155 nor the BSW exterior-set conjecture
  changes status.

## 2026-07-15 — the line bound has a plane-axiom/coordinate fault line

- Formalizing C180 isolates a reusable statement stronger than the immediate `PG(2,11)`
  application: in any finite projective plane, every six-arc satisfies the full `q-5`
  uncovered-points-per-line bound provided only that the five-covered-point equality case is
  impossible on disjoint lines. All counting, chord, tangent, and case-split work is purely
  incidence-theoretic. Desarguesian coordinates and odd characteristic enter solely in excluding
  that equality case via the triangular prism.
- **Question — follow-on:** which non-Desarguesian odd-order planes, if any, admit the exceptional
  five-direction one-factorization configuration? This should not widen the current paper, but the
  formal boundary makes the question precise and reusable.
- The finite equality object is exceptionally small: `K6` has 15 perfect matchings but only six
  labelled one-factorization totals, all one relabelling orbit. This makes the triangular-prism
  extraction a transparent six-witness kernel certificate rather than a large search. **Disposition
  — answer in this paper:** use the normal form in the conceptual proof; keep the labelled count in
  the verification note unless it improves exposition.
- The affine obstruction itself is field-generic and sharper than the q=11 application: a common
  point at infinity converts projective concurrence directly into a zero direction determinant,
  and the prism then forces `2=0`. **Question — follow-on:** in characteristic two, classify the
  realizable five-direction equality configurations rather than treating failure of the odd proof
  as merely exceptional.
- The normalized contradiction needs no division and hence no hidden nonzero-coordinate side
  conditions beyond distinctness: the two third-direction determinants differ by `2*x*y`, with
  `x,y != 0` forced by injectivity. This is the cleanest manuscript proof form and makes the exact
  characteristic-two failure visible.

## 2026-07-15 — the five-direction seam closes internally

- The five covered points do more than merely index five `pairsThrough` fibers: chord intersection
  defines a canonical proper five-edge-colouring of the labelled `K6`. Properness has a short
  projective proof—two adjacent chords with the same colour share both an arc vertex and their
  direction point, hence are the same line and therefore the same arc pair.
- A semantic endpoint count shows that any proper five-colouring of `K6` is automatically a
  one-factorization. This removes the need to assume the equality fibers partition the chords as a
  separate geometric lemma; it is forced by properness and the five colours.
- The finite certificate can expose three *named* colour classes and all nine prism-edge equations,
  rather than only membership in an image of a relabelled total. That stronger interface makes the
  geometry transport direct and is likely the most readable proof architecture for the paper.
- The complete odd-characteristic equality exclusion is now Lean-certified without a Dye axiom.
  Dye remains relevant only for the separate `c≤10`/equality-classification step in the conceptual
  rigidity theorem and for historical attribution.
- **Follow-on:** the proof boundary suggests studying proper chord-direction colourings for larger
  even arcs. For six vertices, five colours force the unique one-factorization orbit; for `2m`
  vertices, equality cases should be controlled by one-factorizations of `K_{2m}` together with
  which factor subfamilies admit projective direction realizations.

## 2026-07-15 — Dye primary theorem recovered

- Dye's original pp.270--276 removes the remaining classification ambiguity. His “hexagon” is
  exactly a six-arc, a Brianchon point is a nonvertex triple-edge concurrence, and equality at ten
  defines a Clebsch hexagon. In characteristic different from two he proves the sharp ten-point
  bound by the complementary-quadrangle diagonal-point argument.
- The equality result is stronger and cleaner than the proxy summaries suggested: Theorem 1(ii)
  states directly that `PGL_3(K)` is transitive on the Clebsch hexagons when they occur, and its
  coordinate proof stays over `K`. There is no algebraic-closure descent issue at `F_11`.
- The upper bound needs only `char(K) != 2`; the “5 is a square” condition is forced by equality
  and characterizes existence. At `F_11`, `4^2=5`, so both the bound and classification apply.
- **Manuscript discipline:** do not conflate Dye's basic Clebsch hexagon with his later, stronger
  “Clebsch hexagon of a conic,” defined using five self-polar triangles. C180 uses only the basic
  equality classification.

## 2026-07-15 — BSW 1992 primary text closes the exterior-set priority gate

- Blokhuis--Seress--Wilbrink define a complete exterior set of a nonsingular conic in
  `PG(2,q)` to be exactly `(q+1)/2` exterior points such that every pair-join is a passant. Thus
  their condition says that every chord of the point set misses the conic: in the uncovered-locus
  notation, `C(F_q) subset U(A)`.
- Their final remarks explicitly report all computer-found examples for `q=7,11,19,23,27,31`.
  At `q=11` there are, up to isomorphism, two complete exterior configurations: one six-arc and
  one Pasch configuration. They credit the `q=7` four-arc and `q=11` six-arc to Korchmaros and the
  isomorphism classification to Andries Brouwer.
- The paper does **not** state that the fifteen joins of the `q=11` six-arc cover every point off
  the conic. “Complete” is part of their fixed-cardinality exterior-set definition, not a chord-cover
  maximality assertion. Consequently BSW owns the six-arc relative to the conic and the inclusion
  `C subset U(A)`, but not the reverse inclusion or equality `U(A)=C` used for the deep-hole theorem.
- Together with Dye's q=11 non-secant-edge statement, the priority ledger is now unconditional:
  the classical sources supply `C subset U(A)`; the companion computation supplies the genuinely
  additional off-conic coverage `U(A) subset C`.
- BSW conjecture that for `q>31` no nonlinear complete exterior sets exist and report Brouwer's
  nonexistence search through `q=131`. This is adjacent to, but does not settle, either the fixed
  six-arc conic-filling problem or the odd-q Nofil conjecture: their set size is `(q+1)/2`, so it is
  six specifically at `q=11`.

## 2026-07-15 — older referee questions after the rigidity upgrades

- The formerly central request for a non-enumerative conic-rigidity proof is closed at theorem
  level: C180 replaces the conic-containment census implication by the odd-characteristic line
  bound, chord defect, and Dye's equality classification; C186 independently derives the `A5`
  point-orbit geometry. A still more intrinsic construction of `A5` directly from the quadratic
  locus would be elegant, but is no longer a correctness or submission gate.
- Literal low-degree containment among all fifteen q=11 six-arc classes is closed by C184: Clebsch
  is uniquely contained in a curve of degree at most three. C185 also recovers the
  Brianchon/Petersen matching dictionary from decoder ambiguity, so this geometry is observable
  from the code rather than merely imported from the displayed coordinates.
- Three distinct high-value questions remain and are queued. C206 asks for a conceptual source of
  the sharp discrepancy gap and a general stability theorem. C207 asks for an intrinsic chirality
  torsor and the algebraic meaning of the non-lifting `S5` normalizer coset. C208 asks for the
  all-field `A5` orbit decomposition of `U(A)`, beginning with the q=19 split `20+120`.
- Broader searches for non-GRS MDS codes with low-degree deep-hole varieties and a universal
  coherent-configuration theory remain cross-paper agenda questions, not additional Clebsch
  manuscript promises.

## 2026-07-16 — C211 incidental surprises

- The apparently suspect characteristic-five specialization is not a bad arrangement reduction:
  all `15` mirrors and the `6_5,10_3,15_2` lattice survive even though the modular reflection
  representation is no longer semisimple. The actual H3 bad prime is two, where the signs coalesce.
  **Question — follow-on:** for noncrystallographic arrangements, which modular reductions retain
  the lattice after the reflection representation itself degenerates?
- The spurious algebraic root `q=4` in the H3 conic-size equation is not an unexplained second
  geometry; it lands exactly at that bad characteristic-two reduction. **Disposition — answer in
  this paper:** state the reduction boundary next to the factorization so the extra root explains
  rather than distracts.
- The novelty search unexpectedly found that Jurrius--Pellikaan already built the general
  derived-arrangement machinery for coset-leader and list-weight enumerators, including planar MDS
  secant arrangements. **Question — follow-on:** C212 must now seek a reconstruction or
  classification theorem beyond their enumerator formalism; a general arrangement--decoder
  dictionary alone would duplicate prior art.
- Edge's icosahedral construction and Calvo's mirror configuration make the H3 provenance of the
  Clebsch joins classical in substance even though the exact phrase “Clebsch hexagon = H3” was not
  found. **Disposition — answer in this paper:** present H3 as a recognition/application, not a new
  geometric discovery.
