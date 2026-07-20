# Clebsch-like gateway objects: search map and application targets

**Lane:** `crowns` with read-only inputs from `clebsch`

**Date:** 2026-07-20

**Status:** standalone research brainstorm; no task allocation, manuscript change, or novelty claim

## Question and scope

Where else should one look for objects that behave like the Clebsch hexagon: small exceptional
configurations whose different presentations preserve enough marking to transport theorems among
finite geometry, codes, groups, algebraic geometry, association schemes, and quantum information?
Where would such objects be especially useful?

This report extends the candidate-chain discussion in
`2026-07-20-clebsch-gateway-chain-brainstorm.md`.  It is deliberately not constrained by the
Clebsch manuscript architecture in `2026-07-20-clebsch-paper-planning.md`; the candidates below
are possible companion projects or independent follow-ups.  The proved local inputs and their
boundaries remain those recorded in `2026-07-19-c373-clebsch-gateway-program.md` and the dated
C-task reports it cites.

The literature pass for this report was targeted rather than exhaustive.  It confirms the
classical endpoints and sharpens cheap tests, but it is not a priority audit or forward-citation
closure.  No statement below of the form “candidate theorem,” “appears,” or “should” is a claim of
novelty or a proved identification.

## What makes a gateway object useful

A famous object is not automatically a gateway.  The useful examples sought here should have most
of the following features.

1. **Several reversible presentations.**  One can move between a code, incidence structure,
   group action, variety, graph, or tensor without discarding all markings.
2. **A small forgotten decoration.**  A matching, sign, sheet, flag, quadratic refinement, or
   orientation is exactly what makes an otherwise many-to-one transform invertible.
3. **An intrinsic carrier.**  An uncoloured graph, face poset, design, or low-rank algebra recovers
   the presentation instead of merely being associated with it.
4. **An exceptional parameter.**  A special field, module, or orbit makes the object rigid and
   computationally finite.
5. **An operational endpoint.**  The transport produces a decoder, canonical form, measurement,
   circuit, sufficient statistic, or arithmetic invariant.
6. **A cheap falsifier.**  A permutation character, stabilizer, incidence rank, or module category
   can reject a shared-name coincidence before a large programme begins.

The most promising search locations are consequently not only the positive Clebsch theorem, but
also its q=7 analogue, its q=19 boundary, the six-label structures forgotten by coarse quotients,
and the q=9 Cayley-octad near miss.

## Executive ranking

| Rank | Candidate gateway | Local entrance | Main use if the first gate is positive |
|:---:|:---|:---|:---|
| 1 | B3/Fano/Klein-quartic/Hoggar corridor | q=7 factorization sheets plus C405's 28 octad pairs | Three-qubit tomography and a measurable cubic-orientation statistic |
| 2 | Regular 11-cell | C379's two 11-element sheets and `(11,5,2)` biplane | A self-dual face/flag calculus for decorated recovery and information loss |
| 3 | 57-cell and Perkel geometry | q=19 H3 boundary and `A5 < PSL_2(19)` | A compact carrier for the q=19 arithmetic phase and a q=11/q=19 theorem |
| 4 | The doily `GQ(2,2)` | Six labels, 15 duads, and 15 synthemes | Outer-`S6` transport among cubic lines, genus-two theta data, and two-qubit Paulis |
| 5 | Paley--Hadamard completions | Bordering the C379 biplane | Optimal frames, ternary Golay/Mathieu transport, and symmetric generation |
| 6 | Hesse--Burkhardt characteristic-three gateway | Possible trace shadow of the q=9 Hermitian octad | Explicit genus-two moduli and qutrit tomography |

The first four are suggested by exact local counts and group actions.  The sixth is a deliberately
more independent search basin.

## G15. B3 matching sheets to Fano anti-flags, bitangents, and the Hoggar SIC

### Structural reason

The B3 member of the C406 factorization-memory theorem is the q=7 counterpart of the H3/q=11
sheet pair.  Its expected two seven-element sheets suggest the unique biplane

```text
2-(7,4,2) = complement of the Fano plane.
```

That biplane has 28 flags, equivalently the Fano plane has 28 point--line anti-flags.  The same
28-object `PSL_2(7)` geometry occurs in three nearby places:

- the 28 bitangents of the Klein quartic;
- the 28 pairs/bitangents of C405's Hermitian Cayley octad; and
- the 28 zero coordinates in each twin-Hoggar SIC probability vector.

Stacey gives the last dictionary explicitly: each zero is a Fano anti-flag.  The Hoggar object is
a 64-line SIC in complex dimension eight, hence an informationally complete measurement for three
qubits; its triple products and its twin are load-bearing, not decorative.  The Hesse and Hoggar
SICs are also two of the three pair-transitive “super-SICs” classified by Zhu.

The candidate chain is therefore

```text
B3 matching-sheet orientation
  -> Fano-complement biplane / 28 anti-flags
  -> Klein-quartic or Cayley-octad bitangents
  -> Hoggar twin zero supports and cubic SIC data.
```

### First exact gates

1. Compute the cross-sheet incidence of the frozen B3 matching fixtures and test the
   `2-(7,4,2)` equations.
2. Compare permutation characters and point stabilizers for

   ```text
   B3 cross-incidences,
   C405 octad pairs,
   Klein-quartic bitangents,
   Hoggar anti-flags.
   ```

3. If the degree-28 `PSL_2(7)` sets agree, test the first richer relations: triples, Aronhold or
   Steiner systems, and the 36 determinantal representations in C405.
4. Push the B3 signed cubic through the equivariant bijection and test whether it equals a Hoggar
   triple-product sign, twin choice, or entropy-minimizing zero-support statistic.

The degree-28 bijection alone is classical infrastructure.  Promotion requires preservation of
the factorization orientation, parent decoration, or cubic statistic.

### Where it would be useful

- **Quantum tomography:** a symmetry-adapted measurement of the orientation that C406 presently
  expresses only as a finite signed tensor.
- **Quantum nonclassicality:** an exact bridge from a geometric parent type to a three-qubit SIC
  or magic-state resource.
- **Code transforms:** a route for transporting C405's octad parent decorations into a quantum
  reconstruction problem.
- **Orbit recovery:** a finite, highly symmetric example in which a degree-two statistic forgets
  a choice and a cubic observable restores it.

This is the strongest new chain because it composes two already-landed gateways and ends at a
genuinely operational object.

## G16. The C379 matching sheets as the self-dual regular 11-cell

### Forced unmarked design

The regular 11-cell is a self-dual locally projective rank-four polytope with 11 vertices, 11
hemi-icosahedral facets, 55 edges, 55 triangular faces, and automorphism group `PSL_2(11)`.  Each
facet contains six vertices, the edge graph is `K_11`, and three facets meet at every edge.
Consequently its vertex--facet incidence is

```text
2-(11,6,3),
```

and complementary vertex--facet incidence is

```text
2-(11,5,2).
```

C379's cross-sheet disjointness design is exactly the unique `(11,5,2)` biplane.  Thus the
unmarked design is forced to be the complementary vertex--facet design of the 11-cell.  The
load-bearing marked question is whether the two C379 one-factorizations can be chosen as the
vertex and facet sides so that the golden outer exchange becomes polytope self-duality.

### First exact gates

1. Construct the 11-cell face poset in the same two degree-11 `PSL_2(11)` actions used by C379.
2. Match complementary vertex--facet incidence with matching disjointness equivariantly, not only
   up to an arbitrary design isomorphism.
3. Reconstruct the 55 edges and 55 triangular faces from matching relations and identify which
   C403 four-endpoint switches are rank-two residues or local flag moves.
4. Test whether a matching-decorated parent is a flag, partial flag, or chamber residue, and
   whether forgetting the matching is a standard face-poset truncation.
5. Compare the golden outer map with the canonical self-duality on all face ranks.

### Where it would be useful

- **Conceptual parent recovery:** decorations become flags rather than auxiliary labels.
- **Information lattices:** the `22 -> 6 -> 2 -> 1` hierarchy may become a sequence of intrinsic
  poset quotients or truncations.
- **Switch calculus:** C403 matching switches could acquire a topological or chamber-system
  interpretation.
- **Finite verification:** a compact regular-polytope certificate may replace several unrelated
  matching tables.

The classical 11-cell and biplane are pre-existing objects.  The possible new result is the marked
commuting diagram carrying parent recovery, cubic orientation, and self-duality.

## G17. The q=19 boundary as the 57-cell and Perkel carrier

### Structural reason

Leemans--Schulte prove that the only rank-four string C-group polytopes with group `L_2(q)` are the
11-cell at q=11 and the 57-cell at q=19.  Monson--Schulte construct the wider `{3,5,3}` and
`{5,3,5}` families by modular reduction over the golden integer ring.  This is unusually close to
the integral H3/A5 arithmetic object already controlling the Clebsch phases.

At q=19,

```text
|PSL_2(19)| / |A5| = 3420 / 60 = 57.
```

Thus the distinguished H3 `A5` is of exactly the right order to be a vertex or facet stabilizer in
the self-dual 57-cell.  Its graph shadow is the 57-vertex Perkel geometry.  The q=19 code should
therefore be searched for a 57-object quotient even though its full deep-hole count is 140 and it
does not fill a conic.

### First exact gates

1. Identify the C399 q=19 `A5` embedding with a standard vertex/facet stabilizer in the 57-cell.
2. Form the 57 cosets and compare the induced orbital graph with the Perkel relation.
3. Project q=19 deep-hole, uncovered-point, and secant data onto those cosets and test whether any
   nontrivial relation factors through the 57-cell face poset.
4. Compare the q=11 and q=19 constructions before generalizing: do the two local arithmetic phases
   recover the only two exceptional `L_2(q)` rank-four polytopes by the same recipe?

### Where it would be useful

- **Compression:** a 57-vertex intrinsic carrier for a much larger q=19 syndrome or point set.
- **Arithmetic phase detection:** a geometric explanation of why q=19 is structured but not a
  q=11 conic-filling copy.
- **Graph reconstruction:** a second exact benchmark for G8, with different local geometry and
  the same golden source.
- **Regular-complex extensions:** only after the finite carrier is exact, covers and boundary maps
  could be tested as sources of symmetric chain complexes or homological codes.

The last application is late-stage.  No homological-code claim follows from the shared polytope
name.

## G18. The six-label core as the doily `GQ(2,2)`

### Structural reason

Six labels canonically produce 15 duads, the unordered pairs, and 15 synthemes, the partitions of
the labels into three pairs.  Duad containment in a syntheme is the self-dual generalized
quadrangle `GQ(2,2)`, also called the Cremona--Richmond configuration or doily.  Its full
automorphism group is `S6`, and exchanging duads and synthemes realizes the exceptional point--line
duality behind outer-`S6` combinatorics.

The same doily is the commutation geometry of the 15 nonidentity two-qubit Pauli observables:
points are observables and lines are maximal commuting triples.  Genus-two Jacobian 2-torsion also
has 15 nonzero points, each represented by a difference of two of the six Weierstrass points.

The Clebsch data already contains the necessary raw objects:

- the 15 cubic-surface lines `L_ij`;
- six `E_i` and six `Q_i` forming the double-six;
- 15 pairs and ten complementary `3+3` partitions of the six code labels; and
- the code/cubic outer character certified by C376.

### First exact gates

1. Label the `L_ij` as duads and construct the 15 synthemes from the same six labels.
2. Test whether C376 blowdown exchange induces doily point--line duality, rather than only the
   correct outer coset on labels.
3. Express the C373 `10+10` sheet cover as quadratic refinements, theta characteristics, or Arf
   data on the associated four-dimensional symplectic `F_2` space.
4. Compare C403 four-endpoint switches with doily lines, grids, and ovoids.
5. Only after these finite identifications, construct the corresponding genus-two/Kummer point or
   two-qubit Pauli marking.

### Where it would be useful

- **Outer-`S6` explanation:** one finite self-dual carrier could unify the cubic-surface and
  Segre--Igusa--Kummer routes.
- **Two-qubit information:** the chirality choice may become a Clifford orbit, contextuality sign,
  or commuting-context orientation.
- **Genus-two arithmetic:** a precise 2-torsion marking may provide the canonical moduli point
  missing from the current Kummer satellite.
- **Canonicalization:** the doily offers a tiny intrinsic structure on which all relevant label
  automorphisms can be checked exactly.

Raw duad--syntheme and Pauli dictionaries are classical.  Value requires transporting the actual
C373/C376 torsor or C406 cubic memory.

## G19. Paley biplane completions: frames, Hadamard/Golay, and `J_1`

### Three classical completions

Once the C379 biplane is retained with its two-sheet marking, it has several strong classical
completions.

1. A cyclic Paley orientation produces conference/tournament data and complex equiangular tight
   frames.  For 11 points the relevant Paley construction gives 11-vector ETFs in dimensions five
   and six.
2. Bordering the design gives the order-12 Hadamard matrix.  Its ternary code is the extended
   ternary Golay code, tied to the Steiner system and `M_12`.
3. The 11-point biplane and its `PSL_2(11)` action support Curtis's symmetric generation of the
   smallest Janko group `J_1` by eleven involutions.

None of these endpoints is new.  The candidate contribution is that the Clebsch sheets may supply
the signs, sides, or generators canonically and carry parent recovery into the completion.

### First exact gates

1. Determine whether a chosen C406 sheet and cubic sign canonically orient the Paley difference
   set or merely select an isomorphism class already fixed by the biplane.
2. Border the exact C379 incidence matrix with all signs tracked and test the resulting Hadamard
   matrix, ternary row code, weight-six supports, and automorphism inclusion.
3. Identify what the golden sheet exchange does in the Hadamard and ternary-Golay presentations.
4. For `J_1`, test whether a matching decoration selects one of Curtis's symmetric generators and
   whether four-endpoint switches satisfy a meaningful short-word relation.

### Where they would be useful

- **Frames and sensing:** an optimal low-coherence measurement or reconstruction frame whose
  conjugate/oriented form records Clebsch chirality.
- **Error correction and designs:** transport into the exceptionally rigid ternary Golay/Mathieu
  package.
- **Group recognition:** compact symmetric normal forms and multiplication algorithms for `J_1`.
- **Information loss:** a concrete comparison of what survives design incidence, frame Gram data,
  code span, and sporadic completion.

There is an important lattice boundary.  Calderbank--Sloane's original claim that a naive
`Z/9Z` lift of the ternary Golay code gives the Coxeter--Todd lattice was corrected: the stated
lattice is not Coxeter--Todd.  No Coxeter--Todd branch should be advertised without a different,
verified construction.

## G20. Hesse and Burkhardt as an independent characteristic-three gateway

### Structural reason

The Hesse configuration and pencil already form a proven gateway among elliptic curves with
level-three structure, finite affine geometry, the qutrit Heisenberg group, and the Hesse SIC.
The Burkhardt quartic is a closely related higher-dimensional gateway: it compactifies the moduli
of principally polarized abelian surfaces with full level-three structure, and its distinguished
planes carry Hesse pencils used to construct universal genus-two data.

This is not yet a canonical consequence of the Clebsch hexagon.  The possible entrance is C405's
q=9 Hermitian Cayley octad and self-dual MDS child.  Restriction of scalars from `F_9` to `F_3`
could expose a symplectic quotient or Hesse incidence, but shared characteristic three is not
evidence by itself.

### First exact gates

1. Trace-restrict the frozen C405 Hermitian module to `F_3` and compute its invariant alternating
   and quadratic forms.
2. Search only that small module for a canonical Hesse `9_4` configuration or the relevant
   level-three symplectic incidence.
3. Compare group characters with the Hesse/Burkhardt actions before constructing any moduli map.
4. If the module gate is positive, ask whether the octad discriminant curve or its 36 determinantal
   representations defines a Burkhardt point or distinguished plane.

### Where it would be useful

- **Explicit arithmetic geometry:** universal genus-two curves, twists, and level-three Galois
  data.
- **Qutrit tomography:** Hesse-SIC measurements and symmetry-adapted reconstruction.
- **Cross-characteristic comparison:** a controlled test of which decorated-transform structures
  survive restriction of scalars.

This candidate should remain independent unless the trace/module gate produces a canonical
incidence.

## Cross-chain compositions worth preserving

The most valuable compositions are now

```text
B3 balanced sheets
  -> Fano anti-flags
  -> C405/Klein bitangents
  -> Hoggar cubic/twin statistic.

H3 q=11 matching sheets
  -> Paley biplane
  -> 11-cell face poset
  -> flag interpretation of decorated recovery.

H3 q=11 11-cell
  <-> golden modular reduction
  <-> H3 q=19 57-cell
  -> arithmetic-phase carrier.

six labels / double-six
  -> doily point-line duality
  -> genus-two 2-torsion or two-qubit Pauli geometry.

C379 biplane plus chosen orientation
  -> Paley frame or Hadamard/Golay completion
  -> operational measurement or rigid code.
```

The move order remains load-bearing.  Exact `G`-set and module gates precede moduli or quantum
claims; a classical famous-object identification is only infrastructure until it transports a
Clebsch marking, decoration, recovery predicate, or cubic statistic.

## Lower-priority temptations and stop rules

### Klein cubic threefold

The Klein cubic threefold is a natural level-11 object with automorphism group `PSL_2(11)` and a
faithful five-dimensional representation.  It would open intermediate-Jacobian and polarized
abelian-variety geometry.  However, the degree-11 two-transitive permutation module coming from
the biplane is `1 + 10`, not a canonical `1 + 5 + 5`.  A route therefore needs an explicit
functorial covariant producing the five-dimensional Klein module from matching or biplane data.
Without that covariant, the common group and prime are insufficient.

### Bring curve and genus-four tritangents

The Bring-curve/120-tritangent direction remains attractive because the Clebsch shell also has 120
vectors, but it is already isolated behind the C387 test in the existing brainstorm.  No new route
is added here.  The same rule applies: construct the canonical curve and transport the marking
before comparing 120-element sets.

### Octonionic, Jordan, and icosian routes

C382's category and character obstruction remains decisive for the proposed marked icosian
comparison.  Hoggar's known octonionic associations do not reopen that route.  They matter only if
the C405 28-bitangent action passes the direct Hoggar gate above.

### Coxeter--Todd lattice

Do not infer this lattice from the ternary Golay code by the corrected `Z/9Z` construction.  Any
lattice endpoint needs its own exact generator, determinant, minimum, and automorphism check.

## Recommended unallocated experiment order

These are experiments, not queue rows or task allocations.

1. **B3 cross-incidence:** verify or reject the Fano-complement biplane and its cubic orientation.
2. **C405/Hoggar character gate:** compare the 28-point actions and first triple relations.
3. **11-cell equivariant incidence:** match C379's two sheets to vertices and facets, then recover
   edges/faces.
4. **q=19 coset carrier:** compare the distinguished H3 `A5` action with the 57-cell/Perkel action.
5. **Doily transport:** test C376 blowdown exchange against duad--syntheme duality and the
   `10+10` torsor against quadratic refinements.
6. **Paley completion:** only after the 11-cell marking is fixed, test ETF/Hadamard signs and the
   ternary code.
7. **Characteristic-three trace gate:** run the Hesse/Burkhardt module check last.

The first, third, and fourth are finite permutation/incidence calculations.  They should be cheap
enough to decide whether the candidate is a theorem path or only a famous-object coincidence.

## Bounded novelty check on ranks 1--3

### Scope and bottom line

This check covers only G15--G17 and only the proposed seams joining the local C405/C406/C379/C399
objects to the named classical carriers.  It is not a forward-citation closure or an unrestricted
priority audit.  Of the six individually discussed sources below, **zero were read at `full text`**:
five were read `partial` (one through publisher HTML) and one `abstract/metadata only`.  The
verdicts therefore license experiment triage and conservative claim boundaries, not a
paper-facing "first" claim.

| Candidate | Bounded verdict | What is already pre-empted | Narrow seam that survives |
|:---|:---|:---|:---|
| G15 B3/Fano/Klein/Hoggar | **PARTLY PRE-EMPTED; MARKED CUBIC SEAM SURVIVES** | Stacey explicitly passes from the 28 zero entries of a twin-Hoggar probability vector to Fano anti-flags and from the same binary odd-pairing equation to the 28 bitangents of a plane quartic.  A bare 28-object anti-flag/bitangent/Hoggar dictionary is therefore prior art. | No predecessor was located in the bounded coverage for an equivariant map from the frozen B3 sheet orientation or the C405 parent decoration to a Hoggar triple-product sign, twin choice, or other measurable cubic statistic.  Klein-quartic specialization alone is not enough. |
| G16 C379 sheets/11-cell | **CLASSICAL UNMARKED CORE; MARKED COMMUTING DIAGRAM SURVIVES** | The self-dual 11-cell, its two degree-11 `PSL_2(11)` actions, and the `2-(11,5,2)` biplane are classical.  From the published face counts and local incidences, the complementary vertex--facet design is the biplane; that identification should not carry novelty wording. | No predecessor was located for identifying the *specific C379 one-factorization sheets* with the vertex/facet sides while also transporting golden exchange, parent recovery, C403 switches, or cubic orientation through the face poset. |
| G17 q=19/57-cell/Perkel | **FIRST TWO GATES PRE-EMPTED; CODE TRANSPORT REMAINS OPEN** | Leemans--Schulte and Monson--Schulte give the self-dual 57-cell with group `PSL_2(19)` from the golden modular-reduction setting.  The 57-vertex `A5`-coset action and its valency-six Perkel coset graph are also explicit in the graph literature.  Thus identifying the C399 `A5` merely as a vertex stabilizer and recovering the Perkel orbital are normalization checks, not new results. | No predecessor was located for a nonconstant q=19 deep-hole, uncovered-point, secant, or code relation factoring through the 57-cell face poset, nor for one construction producing both the q=11 and q=19 carriers from the C399 arithmetic phases. |

The novelty-adjusted order remains G15, G16, G17, but for a stricter reason than the executive
ranking: each survives only if it transports the *forgotten decoration or operational statistic*.
G17 suffered the largest collision.  Its first novelty-bearing computation is current gate 3, not
gates 1--2.  G15 should likewise skip any claim based only on the degree-28 set and go directly to
the richer triple/cubic relations.

### Candidate-specific findings

#### G15

Stacey's equations (116)--(117) are a direct collision with the corridor's unmarked middle.  The
odd symplectic pairing labels both quartic bitangents and Fano anti-flags, and each zero in the four
displayed twin-Hoggar probability vectors is identified with an anti-flag.  The same paper treats
Hoggar triple products and the twin as substantive quantum data, but does not identify the local
B3 factorization sheets, the q=9 C405 octad parents, or a Klein-specific marked cubic transport.
This leaves a plausible theorem seam, but it is substantially narrower than the original chain:

```text
not novel: 28 zeros <-> Fano anti-flags <-> general-quartic bitangent labels
still live: B3/C405 parent orientation -> a specified Hoggar cubic or twin statistic
```

The query screen found the expected classical `PSL_2(7)` action on Klein-quartic bitangents, so an
agreement of degree-28 permutation characters would still be infrastructure.  Promotion should
require preservation of the B3 signed cubic or a C405 parent relation, exactly as the existing stop
rule says.

#### G16

Leemans--Schulte record that the self-dual 11-cell has 11 facets, 11 vertices, 55 edges, 55
triangular faces, and complete vertex graph `K_11`.  Martín--Singerman separately identify the
simplest biplane on eleven points and its automorphism group `PSL_2(11)`.  Together with the local
hemi-icosahedral incidence, this makes the complementary vertex--facet `2-(11,5,2)` design a
classical consequence, not the target theorem.

The bounded searches did not locate any source connecting a pair of `K_12` one-factorizations to
the two face ranks of the 11-cell, or interpreting four-endpoint matching switches as residues or
flag moves.  Accordingly, the useful exact gate is not "is the biplane the same?" but "does the
fixed C379 equivariant identification extend to edges, faces, self-duality, and the retained parent
decoration?"  That is still a clean and cheap finite test.

#### G17

The classical collision is stronger here.  Leemans--Schulte's classification fixes the 57-cell as
the q=19 rank-four `L_2(q)` polytope; Monson--Schulte obtain it from the `Z[tau]` modular-reduction
family; and Xiao--Zhang--Zhang explicitly construct the 57-vertex valency-six coset graph from
`PSL_2(19)` with vertex stabilizer `A5`.  This is the Perkel carrier.  Hence the order calculation
`3420/60=57`, the coset set, and the standard orbital graph cannot support novelty.

The surviving question is more interesting and more falsifiable: does any *C399-defined* q=19
incidence or syndrome statistic descend nontrivially to that already-known coset geometry?  A
constant or purely group-orbital pushforward closes G17.  A nonconstant relation with a q=11
analogue would be the first result not located in this pass.

### Search record

The general web index was queried in three batches and all 71 displayed title/snippet records were
screened.  The mechanical discriminator was: retain a work only if its title or snippet mentioned
at least two named endpoints of the candidate seam, or one endpoint together with the load-bearing
group/action term.  The exact queries were:

```text
Hoggar SIC Klein quartic bitangents Fano anti-flags PSL(2,7) cubic orientation
regular 11-cell biplane one-factorization K12 PSL(2,11) self-duality
57-cell Perkel graph geometry PSL(2,19) A5 vertex stabilizer code
H3 modular reduction 57-cell q=19 coding theory deep holes
site:arxiv.org "11-cell" biplane PSL_2(11) vertices facets incidence
site:doi.org 11-cell biplane PSL(2,11) one-factorization
site:arxiv.org Hoggar lines "Klein quartic" bitangents
site:arxiv.org Perkel graph code PSL(2,19) 57-cell
"11-cell" "2-(11,5,2)"
"11-cell" biplane "one-factorization"
"PSL(2,11)" biplane regular 11-cell vertices facets
"57-cell" code "deep hole"
```

Crossref `query.bibliographic` screens used the exact strings `Hoggar Klein quartic bitangents`,
`Hoggar Fano anti flags`, `regular 11-cell biplane one-factorization`, and
`57-cell Perkel graph code deep hole`.  Crossref reported respectively 183,473; 670,196;
9,598,152; and 5,240,615 loose matches.  The top ten metadata records from each set were screened;
all forty were single-endpoint or lexical false positives and none described a proposed seam.
These enormous counts are search-noise measures, not coverage claims.

OpenAlex default-search controls were also run.  The most selective useful result was
`"Perkel graph" code`: ten records, all ten screened, with no q=19 deep-hole/code transport.
The supposedly exact `"Hoggar" "Klein quartic"` and `"Hoggar" "anti-flags"` controls returned
zero, despite Stacey's known full-text collision, while the cell queries were polluted by
biological uses of "cell".  OpenAlex default search is therefore demonstrably not a reliable
negative for these seams and carries no verdict weight.  Semantic Scholar returned HTTP 429 for
all four attempted seam queries, so it is **NOT COVERED**, not a zero-result search.

No forward-citation enumeration was used to support a negative, so the three-graph
OpenAlex/Crossref/Semantic-Scholar citing-count rule was not triggered.  MathSciNet, zbMATH Open,
Google Scholar, and citation-graph closure remain **NOT COVERED**.  Google Scholar was not queried
because automated access is blocked; MathSciNet requires unavailable institutional access.

### Sources consulted for this bounded check

| Source | Read depth and access | Audit use |
|:---|:---|:---|
| B. C. Stacey, [*Geometric and Information-Theoretic Properties of the Hoggar Lines*](https://arxiv.org/abs/1609.03075) | `partial`: arXiv version; §§VI and the bitangent/Fano anti-flag discussion around equations (116)--(117). Cache key `arXiv:1609.03075`, SHA-256 `20486414437b34dcd0609b539fd4af92a14b9e8174f5cfda6ae2f68b37db3db3`. | Direct pre-emption of the unmarked Hoggar-zero/Fano-anti-flag/general-quartic-bitangent dictionary; confirms triple products and the twin as richer data. |
| D. Leemans and E. Schulte, [*Groups of type `L_2(q)` acting on polytopes*](https://arxiv.org/abs/math/0606660) | `partial`: arXiv version; introduction, classification argument as needed, and Theorem 4/§ "The 11-cell and 57-cell". Cache key `arXiv:math/0606660`, SHA-256 `80a87dddf2549f3a16feaf2fb13b859680bfafc7b78103cea95f167a0df20b11`. | Exact q=11/q=19 classification, self-duality, face counts, and local projective types. |
| B. Monson and E. Schulte, [*Modular Reduction in Abstract Polytopes*](https://arxiv.org/abs/0805.1479) | `partial`: arXiv version; introduction and the q=11/q=19 singular reductions in the `[3,5,3]` and `[5,3,5]` sections. Cache key `arXiv:0805.1479`, SHA-256 `149eeb36d30adc3cba20813bc7dad33d7a42cc0f39de0f3f3b9e6ab501c019ee`. | Golden-integer construction of the 11-cell and 57-cell; pre-empts the raw arithmetic-polytope corridor. |
| M. E. Fernandes, C. A. Piedade, and O. Reade, [*String C-group representations of transitive Groups: a case study with degree 11*](https://arxiv.org/abs/2302.11943) | `partial`: arXiv version; abstract, introduction, and the theorem-level uniqueness/self-duality statements for the 11-cell. Cache key `arXiv:2302.11943`, SHA-256 `ccff111253ad5a5a9c17d5eb6648f7e8b77dc297f57c03584ccb6ac88a6d5b9a`. | Modern control on the degree-11 string-C-group interpretation; no C379 matching decoration found. |
| P. Martín and D. Singerman, [*The geometry behind Galois' final theorem*](https://doi.org/10.1016/j.ejc.2012.03.022) | `abstract/metadata only`: publisher page for the published version; PDF/full text not read and no cache blob. | Confirms that the eleven-point biplane and its `PSL_2(11)` action are explicit classical geometry. |
| R. Xiao, X. Zhang, and H. Zhang, [*On Edge-Primitive Graphs of Order as a Product of Two Distinct Primes*](https://doi.org/10.3390/math11183896) | `partial`: published open-access HTML, §2 Example 3 and its coset-graph setup; the PDF endpoint returned HTTP 429, so no cache blob was created. | Explicit `PSL_2(19)/A5` 57-vertex, valency-six coset graph; pre-empts G17 gates 1--2 at the unmarked graph level. |

The earlier targeted literature table remains the source record for the other classical endpoints.
Nothing in this bounded check licenses a novelty verdict for G18--G20.

## Targeted literature record

The sources below were used to verify the classical endpoints and formulate gates.  Read depth is
limited to the abstract and the directly relevant theorem or construction unless otherwise noted.

| Source | Read depth | Use in this report |
|:---|:---|:---|
| D. Leemans and E. Schulte, [*Groups of type `L_2(q)` acting on polytopes*](https://arxiv.org/abs/math/0606660) | Abstract and main classification statement | Only q=11 and q=19 give the rank-four `L_2(q)` polytopes; identifies 11-cell and 57-cell |
| B. Monson and E. Schulte, [*Modular Reduction in Abstract Polytopes*](https://arxiv.org/abs/0805.1479) | Abstract and introduction | Golden-integer modular reduction of `{3,5,3}` and `{5,3,5}` families |
| B. Stacey, [*Geometric and Information-Theoretic Properties of the Hoggar Lines*](https://arxiv.org/abs/1609.03075) | Abstract, SIC setup, twin construction, and Fano anti-flag section | 28 twin zeros as Fano anti-flags; cubic/triple-product and tomography meaning |
| H. Zhu, [*Super-symmetric informationally complete measurements*](https://arxiv.org/abs/1412.1099) | Abstract and classification theorems | Tetrahedral, Hesse, and Hoggar objects are the three pair-transitive SICs |
| F. Dalla Piazza, A. Fiorentino, and R. Salvati Manni, [*Plane quartics: the matrix of bitangents*](https://arxiv.org/abs/1409.5032) | Abstract | Reconstruction from 28 bitangents and the role of 36 determinantal representations |
| R. Pellikaan, [*The Klein Quartic, the Fano Plane and Curves Representing Designs*](https://ruudp.win.tue.nl/paper/32.pdf) | Metadata, introduction, and coding/design context | Classical Klein/Fano/code bridge |
| M. Saniga et al., [*The Veldkamp Space of Two-Qubits*](https://arxiv.org/abs/0704.0495) | Abstract | Two-qubit Pauli operators as the doily `GQ(2,2)` |
| J. M. Renes, [*Equiangular Tight Frames from Paley Tournaments*](https://arxiv.org/abs/math/0408287) | Abstract | Paley frames and the 11-vector dimension-five/six endpoint |
| J. H. Conway, N. D. Elkies, and J. L. Martin, [*The Mathieu group `M_12` and its pseudogroup extension `M_13`*](https://arxiv.org/abs/math/0508630) | Abstract | Ternary Golay, order-12 Hadamard, and Mathieu completion |
| R. T. Curtis, [*Symmetric Presentations II: The Janko Group `J_1`*](https://doi.org/10.1112/jlms/s2-47.2.294) | Abstract/metadata | `J_1` symmetric-generation endpoint from the 11-point action |
| N. Bruin and B. Nasserden, [*Arithmetic aspects of the Burkhardt quartic threefold*](https://arxiv.org/abs/1705.09006) | Abstract | Level-three abelian-surface moduli, distinguished planes, Hesse pencils, and universal genus-two curve |
| A. R. Calderbank and N. J. A. Sloane, [correction to the claimed ternary-Golay/Coxeter--Todd construction](https://neilsloane.com/doc/kay_correct.pdf) | Full correction note | Decisive negative boundary for the naive lattice branch |

No forward citations, MathSciNet, zbMATH, or claim-specific absence search was completed for these
new chains.  Any theorem or manuscript claim requires its own literature audit under
`literature-audit-conventions.md`.

## Overall assessment

The strongest lesson is that further Clebsch-like gateways are most likely to be found in the
**exceptional biplane and self-duality sequence at q=7,11,19**, not by adding unrelated exceptional
names.  The q=7 anti-flag chain has the best operational endpoint; the q=11 11-cell identification
has the cleanest structural inevitability; and the q=19 57-cell has the highest chance of turning a
current boundary case into a second member of a uniform theorem.

The doily and Paley completions are valuable because they offer very small carriers and cheap
tests.  Hesse--Burkhardt is worth protecting as a separate characteristic-three search basin, but
it should not be merged with the Clebsch programme until restriction of scalars produces a
canonical module or incidence.
