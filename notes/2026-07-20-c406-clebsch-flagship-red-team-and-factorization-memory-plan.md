# C406 — Clebsch flagship red team and Coxeter factorization-memory gate

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `QUEUED; BOUNDED FLAGSHIP-COMPATIBILITY GATE, NO MANUSCRIPT COMMITMENT`

**Decision:** preserve the current C399-led Clebsch paper as the protected baseline while testing
one stronger, tightly bounded candidate spine.  No factorization-memory, equivariant-repair,
Fourier-sign, cubic, quantum, or higher-rank direction enters the manuscript merely because it is
attractive.  Promotion requires an exact theorem, a nonclassical consequence, a claim-specific
source audit, and a shorter or stronger manuscript rather than a larger one.

## Purpose of this report

This is the durable decision record for the 2026-07-20 discussion about the prospective Clebsch
paper.  It captures, in order:

1. the initial assessment of the paper built from the hexagon spine and gateway derisk plan;
2. the first proposal for improving the paper;
3. the red-team objections to that proposal and to the current manuscript architecture;
4. how C399, the later C403 results, and the stabilizer theorem changed the assessment;
5. the stronger Coxeter factorization-memory theorem that emerged from the combined evidence;
6. the bounded work needed to decide whether that theorem is real, novel, and manuscript-worthy;
   and
7. the red/yellow/green paper decisions after the gate.

This is a synthesis and routing document, not a transcript and not a positive theorem report.
Every unproved statement below is labelled as a **target**, **question**, or **promotion gate**.

## Evidence base read for the discussion

The assessment consumed the current theorem and planning records, especially:

- `notes/2026-07-19-clebsch-hexagons-are-the-bestagons-spine.md`;
- `notes/2026-07-19-c373-clebsch-gateway-derisk-plan.md`;
- `notes/2026-07-20-c398-conic-deep-hole-classification.md`;
- `notes/2026-07-20-c398-c402-portable-clebsch-theorem-priority.md`;
- `notes/2026-07-20-c399-coxeter-number-conic-phase.md`;
- `notes/2026-07-20-c399-literature-audit.md`;
- `notes/2026-07-20-c403-arrangement-complement-distance.md`;
- `notes/2026-07-20-c403-c405-c399-successor-portfolio.md`; and
- `notes/handoffs/2026-07-17-crowns.md`.

The discussion assumed excellent exposition and a fully Lean-formalized paper-facing proof spine,
with exact external finite certificates still described honestly at their trusted boundaries.

## I. Initial assessment

### Initial strength verdict

The first assessment was that the proved package already supports a very strong, memorable paper:

- excellent mathematical substance;
- strong family-specific originality after Edge/Dye attribution;
- exceptional verification if the Lean spine is complete;
- clear top-specialist-journal strength; and
- plausible, but not automatic, broad-journal strength.

The original calibration was roughly:

```text
specialist/interdisciplinary paper:                     about 9/10
finite geometry / coding / algebraic combinatorics:     about 8/10
most selective broad pure-mathematics standards:        about 6.5--7/10.
```

The reason for the gap was not rigor.  The main limitation was the ratio of general mechanism to
exceptional-object structure.  Edge and Dye already own the exceptional conic markers, the
`5,14,22` counts, parent ambiguity, and substantial relation geometry.  The standard
arc--MDS, conic--GRS, MDS--AME, and deep-hole--MDS-extension dictionaries also cannot carry
novelty.

### What was already unusually strong

The following exact results were judged independently substantial:

- the all-good-reduction `H3/A5` arithmetic phase;
- the q=11 non-GRS parent whose complete deepest-syndrome locus is a GRS conic child;
- the primitive Fourier-self-dual rank-eight syndrome scheme;
- the full scheme/column-graph automorphism theorem;
- recovery of the six columns, affine addition, `A5`, and unordered chirality torsor from the bare
  code graph;
- the matching-decorated inverse over the complete 22-parent locus;
- the equality of cubic blowdown exchange and code chirality as a quotient character; and
- exact LC/LU separation of the Clebsch `AME(6,11)` state from every six-point GRS class.

The strongest narrative asset was the closed conceptual walk

```text
exceptional orbit -> code -> hard errors -> conic -> association algebra
                  -> reconstruction of the original orbit.
```

### Initial manuscript risk

The initial red flag was that the six-clause Hexagon Spine Theorem behaved like an anthology.  It
mixed integral reduction, MDS phases, weak del Pezzo surfaces, matchings, biplanes, association
schemes, graph reconstruction, cubic blowdowns, AME states, and LU invariants.  Excellent exposition
could help, but could not erase the genuinely different proof methods, equivalence categories, and
prior-art literatures.

The first proposed paper hierarchy was therefore:

1. one portable theorem giving the general frame;
2. the q=11 non-GRS-to-GRS deep-hole transform as the flagship exceptional mechanism;
3. intrinsic reconstruction as the conceptual close; and
4. cubic and quantum results as sharp consequences or companions rather than coequal theorem
   clauses.

## II. The initial improvement proposal

The first proposed research path had four parts.

### A. Make the unique full-conic transform conceptual

C398 gives an all-field classification: precisely four non-GRS six-arc classes have nonempty
conic-contained complete deepest-syndrome loci, and the q=11 Clebsch class is the unique full-conic
case.  The proposed upgrade was to replace as much of the residual finite quotient as possible by
a structural proof:

```text
full-conic deepest locus
    -> q=11
    -> ten triple secant concurrences
    -> 6_5,10_3,15_2 incidence
    -> A5/Clebsch configuration.
```

This remains a valuable proof-quality and characterization gate, although the full-conic q=11
configuration itself is classical.

### B. Turn C403 into reusable arrangement-code theory

The initial proposal asked whether the weighted 2-adjoint could become a universal or minimal
invariant for arrangement-complement code enumerators, or extend to generalized Hamming weights in
arbitrary rank.  The intended gain was to prevent C399 from looking like three finite ledgers.

### C. Close the rank-eight scheme identity/separability risk

The paper should not rely on “outside the small-order catalogue” as a novelty verdict.  A clean
exit requires at least one of:

- a definitive identification with a known scheme;
- a proof of novelty within an audited class;
- a uniqueness characterization; or
- separability or a comparably strong intrinsic theorem.

### D. Split rather than accumulate

The proposed publication split was:

- a pure flagship containing the arithmetic/code transform, scheme, and reconstruction;
- a quantum companion built around C374/C375 and later operational gates; and
- at most a short cubic epilogue or separate geometric companion.

The guiding warning was that more Lean, more orbit tables, more famous objects, and more circuit
constructions would improve verification or breadth but not the paper's conceptual tier.

## III. First change of assessment: C399 was already the missing portable theorem

The first proposal undervalued C399.  C399 does not merely add examples around the Clebsch code.
It covers **all** irreducible real rank-three Coxeter types `A3,B3,H3`, with Coxeter number
`h=4,6,10`, and proves

```text
n = (q-h/2)(q-h+1),
d = (q-h/2-1)(q-h+1),
max nonmirror intersection = q-h+1.
```

At `q=h+1=5,7,11`, the complement becomes the full invariant conic and the
`[q+1,3,q-1]` extended GRS code.  Above `q>3h/2-1`, the unmarked complement code recovers the
arrangement.  `B3` has a canonical short-root defect, and every irreducible rank-four candidate
fails the first quadric point-count gate.

Thus C399 already supplies completeness on one classification axis:

```text
all irreducible real rank-three Coxeter arrangements.
```

C398 supplies completeness on an independent coding axis:

```text
all non-GRS six-arcs with nonempty conic-contained complete syndrome locus.
```

Those axes meet uniquely at `H3/F11`.  The revised flagship candidate became a **double
characterization** rather than a single exceptional example:

```text
irreducible rank-three Coxeter conic phases
                    |
                    v
                 H3/F11
                    ^
                    |
full-conic non-GRS six-point deep-hole transforms.
```

The C399 literature audit still imposes a strict ownership boundary.  Edge and Dye own the
individual configurations, `5,14,22` marker fibres, parent ambiguity, and much relation geometry.
The literature-surviving C399 headline is the uniform nonmirror maximum, distance law, common
Coxeter-number code phase, and its recovery/deep-hole consequences.

## IV. Second change of assessment: C403 supplied exact information loss

C403 first strengthened the paper by proving a sharp negative-and-repair theorem:

```text
characteristic polynomial / freeness / original lattice / original Tutte data
    do not determine complement-code distance;

punctured weighted 2-adjoint coboundary depth
    determines the complete Hamming enumerator and distance.
```

It then added an all-degree line-product theorem.  At a C399 conic phase, let

```text
Omega = Q(F_q) ~= P^1(F_q),
r = (q+1)/2.
```

Every perfect matching `M` of the `q+1` conic points gives a product of `r` secants.  With the
canonical conic parametrization, its restriction is independent of `M`:

```text
product_{ {i,j} in M } L_ij |_Q
    = product_i (t_i s-s_i t)
    ~ s^q t-s t^q.
```

Four-endpoint switches generate the matching augmentation kernel, and their plane lifts are
explicit multiples of the conic equation.  At `2r=q+1`, the common restricted section is nonzero
but evaluates to the zero word on every rational conic point.

This made the information-loss mechanism exact:

> Conic evaluation forgets the secant pairing, not merely the Coxeter name of the parent.

The all-degree rank/kernel formulas themselves are standard conic/GRS material.  Their value for
the flagship lies in composing this exact pairing-forgetting kernel with C379's matching-decorated
parent recovery.

## V. Third change of assessment: the C403 stabilizer theorem forces the rank-eight passport

The later stabilizer-stratified C403 theorem changed the manuscript assessment again.  It classifies
every projective test-line orbit by weighted-adjoint depth and exact parent-group stabilizer type.
The number of projective lines with trivial parent stabilizer is

```text
A3/B3: q^2-8q+15-8 epsilon_3,
H3:    q^2-14q+45-20 epsilon_3-12 epsilon_5.
```

Consequently, every projective word at the three Coxeter conic phases has nontrivial stabilizer
under its **chosen Coxeter parent**, while the trivial-stabilizer proportion tends to one in the
large-field regime.  This is not an if-and-only-if characterization of `q=h+1`: additional small
symmetry-saturated fields, including `A3/F7`, must remain explicit.

The strongest free consequence is the exact bridge to C372.  At `H3/F11`, the seven projective
line orbits have stabilizers and sizes

| class | stabilizer | projective orbit | scalar-lift valency |
|:---|:---:|---:|---:|
| deepest exceptional | `D10` | 6 | 60 |
| depth-three exceptional | `S3` | 10 | 100 |
| depth four | `C5` | 12 | 120 |
| mirrors | `V4` | 15 | 150 |
| remaining three | `C2` | `30,30,30` | `300,300,300` |

Together with zero, these are exactly C372's valencies

```text
1,60,100,120,150,300,300,300.
```

The paper should therefore prove the compatibility square

```text
C403 projective test-line orbit
          | invariant H3 polarity
          v
C372 projective syndrome orbit
          | scalar lift
          v
rank-eight affine relation.
```

This makes the rank-eight scheme structurally forced by the Coxeter word-orbit theorem rather than
introduced by an independent affine census.  The natural package is a parent-equivariant,
Burnside-ring-valued projective weight enumerator

```text
W_{T,q}(z) = sum_orbits [G_T/Stab(ell)] z^{wt(ell)}.
```

Its cardinality shadow is the ordinary projective weight enumerator; multiplying orbit sizes by
`q-1` gives the nonzero scalar words.  A focused terminology/source check is required before
claiming novelty for this packaging.

### Other stabilizer-era upgrades considered

The discussion also ranked four immediate continuations and fixed their disposition.

1. **Minimum-word and stabilizer-refined enumerators.**  These are nearly free consequences of the
   stabilizer table and worth packaging inside the parent-equivariant enumerator.  The main coding
   corollary should identify which stabilizer types attain minimum weight, not print every mass in
   the introduction.
2. **Extension-tower periodicity.**  Replacing `epsilon_m(q)` by `epsilon_m(q^n)` gives periodic
   extension-degree phases and rational generating functions.  This is attractive packaging but
   likely standard roots-of-unity splitting behavior; it is an appendix or companion unless a new
   arithmetic consequence appears.
3. **Equivariant repair schedules.**  This was the strongest suggested new operational door, but it
   has a category risk: locality and repair are coordinate/target properties, whereas the new
   stabilizer classifies codewords.  A future separately allocated scout must first define a
   codeword-dependent repair object, such as the repair hypergraph of a shortening or puncturing on
   the word support, then falsify whether equal `(weight,stabilizer type)` can have different repair
   polytopes.  No repair theorem is implicit here.
4. **Nonfactorized dual supports.**  Bare dual-support data at the conic phase is expected to factor
   through standard GRS geometry.  The existing C403 gate remains a single bounded falsifier and
   stops at the first such factorization.

## VI. The stronger candidate that emerged

### Governing observation

At the full matching boundary, C403 has much more structure than “the conic child forgets its
parent.”  It supplies one canonical zero-evaluation section with many plane factorizations:

| type | conic points | all perfect matchings | classical Coxeter-parent markers |
|:---|---:|---:|---:|
| `A3/F5` | 6 | 15 | 5 |
| `B3/F7` | 8 | 105 | 14 |
| `H3/F11` | 12 | 10,395 | 22 |

For `H3`, C379 already constructs 22 obstruction matchings, proves that each has stabilizer exactly
its parent `A5`, and proves that the matching-decorated child recovers the parent.  These matchings
split into two `PSL_2(11)` one-factorizations exchanged by the outer coset.

The new question is whether the classical `5,14,22` parent markers admit one uniform algebraic
description:

> Are the Coxeter parents precisely the exceptional symmetry-maximal secant factorizations of the
> canonical Frobenius section at `q=h+1`?

This is not proved and is not assumed by the manuscript.

### Target Coxeter Factorization and Memory Theorem

The strongest target exposed by the discussion is:

> **Target.** For `T=A3,B3,H3`, put `q=h+1` and identify the Coxeter complement with
> `Q(F_q)`.  Every perfect matching of `Q(F_q)` determines a secant factorization of the
> canonical Frobenius section `s^q t-s t^q`, and all such factorizations define the same zero
> evaluation word.  Four-endpoint Pluecker exchanges generate the matching kernel.  Among these
> factorizations, a canonically characterized `PGL_2(q)` orbit has stabilizer the projective
> Coxeter group and size respectively `5,14,22`; this orbit is equivariantly identified with the
> Coxeter-parent fibre.  Its factorization differences generate a specified module inside the
> conic ideal.  For `H3/F11`, the matching decoration recovers the unique non-GRS Clebsch parent,
> and the difference of the two `PSL_2(11)` factorization sheets realizes a nontrivial
> chirality/Fourier consequence.

Every clause after the general C403 matching identity is a gate, not a current claim.

### Why this could be substantially stronger

If the full target passes and is novel, the classical `5,14,22` counts would cease to be isolated
orbit indices.  They would classify symmetry-selected factorizations in the kernel of one canonical
evaluation map.  The theorem would provide:

1. a canonical section rather than an empirical table;
2. one construction across all irreducible real rank-three Coxeter types;
3. an exact algebraic account of information loss;
4. a parent-recovery theorem;
5. a representation module carrying the forgotten data;
6. a possible bridge from the H3 factorization-sheet sign to C378's signed Fourier sector; and
7. the unique C398 specialization where the child is the complete deep-hole transform of a
   non-GRS six-point parent.

The estimated strength if all structural clauses pass was:

```text
specialist/interdisciplinary:                         about 9.7/10
finite geometry / coding / algebraic combinatorics:  about 9--9.5/10
broad pure mathematics:                              about 8.5--9/10.
```

That estimate requires a conceptual proof and a clean novelty audit.  Three finite orbit tables or
a translation of Edge's markers into matching notation would be a useful corollary, not a tier
change.

## VII. Further hidden structures exposed by the stronger target

### A. The Coxeter factorization-difference module

Let the distinguished parent matchings span their permutation module.  Since all matching products
have the same restriction to `Q`, their differences lie in

```text
Q * R_{r-2}.
```

The bounded questions are:

- Do the distinguished parent differences span the full `Q*R_{r-2}` layer?
- What is the kernel of the map from the `5`-, `14`-, or `22`-point augmentation module?
- What are its irreducible constituents under `PGL_2(q)` and the Coxeter subgroup?
- Does any constituent intrinsically encode parent choice, orientation, or chirality?

A positive span/decomposition theorem would prevent “symmetry-maximal matching orbit” from being
mere orbit--stabilizer bookkeeping.

### B. The H3 sheet-sign vector

For the two C379 eleven-matching sheets, define

```text
Xi = sum_{M in F_+} [M] - sum_{M in F_-} [M].
```

It is `PSL_2(11)`-fixed and negated by the outer `PGL_2(11)/PSL_2(11)` coset.  The bounded question
is what the factorization-difference map does to `Xi`:

- zero by a new canonical kernel relation;
- `Q` times a distinguished quartic;
- a carrier of the C378 chirality-odd Fourier sector; or
- no consequence beyond the obvious quotient character.

Only the first three outcomes with an exact reconstruction or algebra consequence can promote the
sheet-sign calculation.

### C. A complete Coxeter memory-phase theorem

C399 plus C403 already suggest the portable phase diagram

```text
empty complement
    -> conic/GRS phase with expanded symmetry and parent ambiguity
    -> stable parent recovery
    -> asymptotically generic parent-asymmetry.
```

This is a strong fallback even if the factorization-module theorem fails.  It must classify every
additional small symmetry-saturated field and retain the `B3` root-length defect.

### D. A multi-characterization theorem for the Clebsch code

The following should be tested as exact equivalent characterizations, with each equivalence
category named:

1. the reduced `H3` fivefold-axis hexagon over `F_11`;
2. the unique non-GRS six-arc with full-conic complete deepest-syndrome locus;
3. the conic child equipped with an appropriate `A5`-stabilized obstruction matching;
4. the six-column quotient graph with automorphism group
   `F_11^3 semidirect (F_11^* x A5)`;
5. the rank-eight scheme with the certified valency passport; and
6. the `6_5,10_3,15_2` secant-concurrence structure with unordered `10+10` triple torsor.

This characterization is a possible main-theorem form even if the uniform A3/B3 factorization
module does not survive.

## VIII. Red-team failure modes

The factorization-memory candidate is **red** if any load-bearing failure below occurs.

1. **Classical renaming.** Edge or Dye already gives the same factorization orbit, kernel, or
   parent-recovery diagram, not merely the markers and counts.
2. **No uniform object.** The A3 triangle, B3 octahedral marker, and H3 obstruction matching do not
   admit the same child-side matching/factorization definition.
3. **Orbit bookkeeping only.** The `5,14,22` result reduces to
   `|PGL_2(q)|/|G_T|` with no new module, inverse, or coding consequence.
4. **No intrinsic selection.** The distinguished factorizations cannot be recognized from the
   child plus its factorization geometry without supplying the parent.
5. **Trivial module.** The difference space is an obvious polynomial space with no useful kernel,
   decomposition, equality, or reconstruction theorem.
6. **False chirality unification.** The sheet sign only restates the quotient character, or is
   incorrectly identified with C378's rank-four fusion; C378's fixed algebra has dimension 12 and
   cannot be collapsed to one forgotten bit.
7. **Computational anthology.** The proof remains three unrelated finite decompositions rather
   than one construction.
8. **Manuscript inflation.** Even a true theorem lengthens the paper without replacing weaker
   clauses or simplifying the central proof.

The candidate is **yellow** if the matching orbit and parent bijection are exact but classical,
tautological, or module-theoretically empty.  Yellow results may supply a concise explanatory
corollary to C399/C403 but do not change the title or paper spine.

The candidate is **green** only if it supplies a literature-surviving algebraic mechanism:

- one intrinsic factorization construction across the three types;
- an exact equivariant parent identification;
- a nontrivial difference-module, reconstruction, or Fourier consequence; and
- a conceptual proof shorter and stronger than the three individual marker stories.

## IX. C406 bounded work programme

### Gate 0 — freeze conventions and ownership

1. Use C399's fixed conic coordinates and projective Coxeter groups.
2. Use C403's canonically normalized secants and factorization map.
3. Use C379's fixed q=11 obstruction matchings and two sheets without regenerating or editing
   their evidence.
4. State the correct equivalence categories: conic child, matching factorization, parent subgroup,
   projective parent configuration, and code.
5. Treat Edge/Dye marker geometry and the `5,14,22` counts as classical from the outset.

### Gate 1 — cheap exact matching-orbit scout

For `A3/F5`, `B3/F7`, and `H3/F11`:

1. enumerate the full perfect-matching set `15/105/10,395` canonically;
2. compute `PGL_2(q)` orbits and exact stabilizers;
3. identify whether there is a unique orbit of size `5/14/22` with stabilizer
   `S4/S4/A5`;
4. match that orbit, by an explicit child-side construction, with Edge's/Dye's marker and the C399
   parent fibre; and
5. independently replay the orbit--stabilizer and factorization identities.

**Stop red** if A3/B3 do not share the H3 matching interface or if the only statement is the
already classical marker orbit.

### Gate 2 — factorization-difference module

For the distinguished orbit in each type:

1. map its augmentation module into `Q*R_{r-2}` by subtracting a fixed factorization;
2. compute and then prove image rank, kernel dimension, and group-module decomposition;
3. test whether the image is the full conic-ideal layer;
4. identify a uniform Coxeter/exponent/root-length description; and
5. record exactly which structures the module recovers.

**Stop yellow** if the image is nonzero but has no uniform structure or consequence beyond
straightening.

### Gate 3 — H3 sheet sign and Fourier compatibility

1. construct `Xi` from the frozen two one-factorizations;
2. compute its exact factorization-module image;
3. prove its `PSL_2/PGL_2` transformation law;
4. compare it with C378's signed four-dimensional Fourier block and C373's unordered chirality
   torsor through explicit maps, not equal dimensions or group names; and
5. require a reconstruction, eigenvector, kernel, or commutative-square consequence.

**Stop yellow** if the result is only the obvious one-dimensional outer sign.

### Gate 4 — C403/C372 structural compatibility

Independently of Gates 1--3, prove the low-cost compatibility already exposed by the stabilizer
theorem:

1. invariant polarity identifies each q=11 test-line orbit with the corresponding syndrome orbit;
2. stabilizer type and weighted-adjoint depth give the relation label;
3. scalar lifting gives exactly the seven nonzero valencies; and
4. the parent-equivariant weight enumerator specializes to the rank-eight orbit passport.

This compatibility may enter the baseline paper even if the factorization-memory flagship gate is
red, provided its terminology/source boundary is closed.

### Gate 5 — claim-specific source audit

Only after an exact theorem statement survives Gates 1--3:

1. reread the directly load-bearing Edge and Dye passages for factorization-level content;
2. audit perfect-matching modules, synthemes, canonical triangles, octahedral structures, Clebsch
   hexagons, Frobenius binary forms, secant-factorization identities, and equivariant weight
   enumerators;
3. close MathSciNet, zbMATH, Google Scholar, and forward citations under the repository literature
   conventions; and
4. write manuscript-safe ownership language before promotion.

### Gate 6 — Lean and reproducibility exit

If green:

1. commit one deterministic script/canonical certificate/checksum bundle with an independent
   replay;
2. formalize the generic conic restriction, four-point switch, and factorization-difference
   interfaces;
3. expose finite orbit/module leaves through checked schemas rather than large opaque `decide`
   proofs;
4. add an import-only paper gate; and
5. audit all terminals for `sorryAx` and project-local axioms.

No Lean work begins before the mathematical interfaces and certificate schema freeze.

## X. Paper decisions after C406

### Red outcome

Keep the protected C399-led paper.  Use only:

- C399's Coxeter-number phase;
- C398's unique full-conic classification as a qualified synthesis;
- C403's weighted-adjoint theorem as a companion or short proof interface;
- the C403/C372 stabilizer-to-scheme compatibility if source-safe;
- C379's H3 matching recovery; and
- C373's bare-code reconstruction.

Do not mention a uniform factorization-memory theorem.

### Yellow outcome

Add a short section or corollary:

> At the conic phase, the classical Coxeter markers admit a common secant-factorization
> interpretation, and the matching kernel makes parent forgetting explicit.

Retain C399 as the only portable headline.  Do not move cubic, quantum, or module tables into the
main theorem.

### Green outcome

Reframe the pure paper around **symmetry, forgetting, and memory**:

1. Coxeter memory phases and equivariant word symmetry;
2. the canonical Frobenius zero-section factorization;
3. the `5/14/22` symmetry-selected parent factorizations;
4. the unique `H3/F11` non-GRS full-conic transform;
5. matching-decorated parent recovery;
6. the equivariant rank-eight syndrome algebra; and
7. bare-code reconstruction of the hexagon and chirality torsor.

The cubic and AME theorems then become short corollaries or separate papers.  The factorization
theorem must replace weaker exposition; it may not simply become a seventh large clause.

Possible green titles include:

- *Symmetry, forgetting, and reconstruction in Coxeter complement codes*;
- *Coxeter conic phases and the Clebsch memory theorem*; and
- *The Clebsch deep-hole transform and its factorization memory*.

## XI. Other directions deliberately not selected by C406

C406 does not allocate or authorize:

- a general arbitrary-rank weighted-adjoint tower;
- C401's cubic uncovered-locus classification;
- C405's rational-normal-curve pilot;
- C402's all-field LU separator;
- equivariant repair scheduling beyond one separately allocated falsifier;
- a renewed C404 parent-fibre census;
- Bring, `E8`, icosian, moduli-stack, or holographic expansions; or
- a manuscript merger of the pure, cubic, circuit, and quantum theorem families.

The first nonfactorized dual-support C403 layer remains a hard falsifier only: continue it under
C403 only if a parent-, matching-, chirality-, or fine-scheme-sensitive invariant survives after
forgetting factorization and marking.  Otherwise close that door without a census.

## XII. Cold-start reading and hand-back

A cold C406 session should read, in order:

1. `notes/handoffs/2026-07-17-crowns.md`;
2. this report;
3. `notes/2026-07-20-c399-coxeter-number-conic-phase.md`, only for fixed conic/group conventions;
4. the matching and parent-forgetting sections of
   `notes/2026-07-20-c403-arrangement-complement-distance.md`;
5. the matching recovery and two-sheet statements in
   `notes/2026-07-19-c379-clebsch-deep-hole-extension.md` and
   `notes/2026-07-19-c379-one-factorization-biplane-companion.md`;
6. `notes/2026-07-20-c399-literature-audit.md` for the classical ownership boundary; and
7. C378/C372 only after Gate 3 or Gate 4 requires the Fourier comparison.

The task hand-back must contain one of:

- a red theorem-level obstruction and exact stop;
- a yellow exact compatibility statement with no promotion; or
- a green theorem, source disposition, certificate bundle, Lean exit plan, and a proposed
  replacement manuscript spine.

No outcome silently edits the main paper.  Manuscript promotion remains a separate explicit
decision after the C406 evidence is reviewed.
