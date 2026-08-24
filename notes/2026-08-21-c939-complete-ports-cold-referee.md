# C939 complete repair ports — cold correctness referee

Date: 2026-08-21

## Reading protocol and verdict

I first read only the frozen 22-page PDF, without consulting manuscript
sources, Git history, earlier reviews, task notes, proof ledgers, or replay
artifacts. I formed the provisional verdict below before reading the C939
referee dossier. I then read only that dossier to make sure that I had answered
each prescribed falsification attempt.

- PDF: `papers/complete-repair-ports/complete_repair_ports.pdf`
- SHA-256: `62fdcd7f0a9875e3b8d7a17dce415cedd0c7937b8aea5b83b64155b1d5eab7be`
- Verdict: **MINOR**
- Blockers: **none**
- Major correctness defects: **none found**
- Required correction: one terminology clarification in the central
  pointed-profile claim, described below.

The main theorem chain is correct as presented. In particular, the two
field-seven seeds have the same pointed rank-triple *multiplicity enumerator*
(equivalently, the displayed full pointed-perspective polynomial), different
radius-three repair clutters, exact zero-functional cost eight, and hence
distinct reliability laws on density-`1/7` target classes after concatenation
with one common asymptotically good outer family.

## Principal mechanism and first unresolved point

The principal mechanism is Theorem 3.1 together with Theorem 4.1: decompose a
concatenated dual word by its induced block functionals, minimize each fiber
with the exact costs `lambda` and `mu_x`, and keep the all-zero functional
sector separate. This produces both the exact weighted nonzero-functional
cost and the persistent pointed obstruction
`z_x(I) = mu_x(0) + d(I^perp)`. In the zero sector, outer
dual distance can eliminate bounded nonzero-functional tuples but can never
eliminate a pointed inner-dual word in the target block plus an inner-dual word
in another block. The resulting eventual iff in Theorem 4.1 is substantially
stronger and cleaner than a support-distance-only sufficient condition.

My first confidence drop was at Corollary 3.2 (page 6). The strict weighted
example compresses the Singer-action argument into a short paragraph, and
the direction of the translated unit-cost class set is easy to reverse. On
checking it, the counting is sound: the 20 projective coordinate-functional
classes are distinct, at most `20^2 = 400` of the 820 regular group elements
cause an intersection, and a weight-five realization would force a forbidden
intersection between the unit-cost set and its chosen translate. This is not
an error, but explicitly naming the two sets and the action direction would
make the check faster.

The first actual issue is terminological, at Lemma 6.3 and its downstream
uses: “complete pointed subset-rank profile” can naturally mean the labeled
function

`A |-> (r_M(A), r_M(A union {x}), |A|)`.

That labeled function cannot be the same for these seeds (even up to helper
relabeling), because it records the target circuit-hyperplanes and therefore
their disjoint-versus-overlapping intersection pattern. What Lemma 6.3 proves,
and what Proposition 6.4 uses, is equality of the **multiplicity distribution**
of rank triples, equivalently equality of the displayed pointed polynomial.
The mathematics is correct; the headline terminology should be made
unambiguous.

## Findings by category

### Correctness

No correction to a formula, theorem, or proof implication is required.

1. **Minor terminology correction — pages 1–2, 12–14; Abstract, Lemma 6.3,
   Proposition 6.4, Theorem 6.5.** Replace or explicitly define “same
   complete/full pointed subset(-rank) profile” as “same pointed rank-triple
   multiplicity enumerator” or “same full pointed-perspective polynomial.”
   Preserve the explicit statement that the different target
   circuit-hyperplane intersections are not retained by this enumerator. This
   avoids the false labeled-profile reading without changing any result.

### Missing proof

None found. The body contains enough argument for every link in the promoted
field-seven/asymptotic chain. The determinant ledger in Appendix A.1 is also
sufficient to check the finite seed facts without trusting the named replay
script.

### Scope

No overclaim found after applying the terminology correction. The paper
carefully limits:

- positive-density realization to represented ports and the stated fixed-inner
  linear-concatenation regime;
- exact full pointed-profile equality to the finite seeds, not the large
  concatenated codes;
- finite-radius EXIT to a bounded-query decoder rather than full MAP or a
  capacity statement;
- transfer of availability to literal port equality, while explicitly noting
  that the two seeds' availability values are not matched; and
- harmonic closure to deterministic identities, without a threshold claim.

### Formal correspondence

No mismatch is visible between the mathematical statements proved in the body
and the formal terminals described on pages 18–19. The formal claims themselves
were not replayed in this deliberately PDF-only review. This is not a
correctness gap because Theorems 3.1 and 4.1, the reliability identities, and
the finite seed argument are proved on paper rather than outsourced to Lean.

### Reproducibility

No PDF-level defect. Appendix A.1 prints all 35 four-column determinant values
for each seed, names the replay files, and records a certificate hash. I also
independently recomputed from the two displayed matrices (without consulting
repository sources) the three circuit-hyperplanes, independence of every
triple, primal distance three by exhaustive row-code enumeration, and equality
of the rank-triple multiplicity distributions. The public replay and formal
gate remain release checks rather than results of this cold review.

### Exposition

Apart from the required “profile” clarification, the exposition explicitly
distinguishes degenerate ports, singleton functional-dual tuples, exact versus
coarse transfer gates, and seed-level versus concatenated claims. An optional
improvement on page 6 would define the unit-cost projective set `S` and write
the chosen disjointness relation explicitly (`S cap a^*S = empty`, with the
paper's chosen action convention).

## Required falsification attempts

1. **Can two circuit-hyperplane counts determine the pointed profile? —
   survives, with the terminology qualification.** In a rank-`r` sparse-paving
   matroid, subsets below size `r` are independent, subsets above size `r`
   have full rank, and the only exceptional `r`-subsets are
   circuit-hyperplanes. For helper subsets `A`, exceptions split exactly into
   circuit-hyperplanes `A` avoiding `x` and circuit-hyperplanes `A union {x}`
   containing `x`. Their two counts determine the multiplicity of every rank
   triple and hence the pointed polynomial. They do not determine the labeled
   subset-rank function; that is the minor wording issue.

2. **Do the minors prove primal distance three and dual distance four? —
   survives.** Every triple extends to a nonzero four-minor, so every triple is
   independent. A displayed dependent four-set then gives matroid girth, hence
   dual-code distance, exactly four. Every set of at least five columns
   contains a nonzero four-minor, so no hyperplane contains five columns; a
   circuit-hyperplane contains four. Thus the largest hyperplane section has
   size four and the `[7,4]` row code has distance `7-4=3`. Independent direct
   recomputation agreed with both circuit lists and `d=3`.

3. **Does a target circuit-hyperplane give `mu_0(0)=4`, not merely an upper
   bound? — survives.** It supplies a weight-four inner-dual word nonzero at
   the target, so `mu_0(0) <= 4`. Triple independence gives
   `d(I^perp)=4`, hence every nonzero inner-dual word, including every word in
   the pointed zero fiber, has weight at least four. Therefore equality holds.

4. **Is the transfer inequality correctly translated? — survives.** A
   radius-`r` repair witness has total dual-word weight at most `r+1`, so exact
   confinement requires the least nonembedded pointed weight to be strictly
   greater than `r+1`. Eventual outer dual distance removes the nonzero
   functional sector and leaves the exact threshold `r+1 < z_0`. Here
   `r=3`, `z_0=4+4=8`, and `4<8` clears the gate with room to spare.

5. **Can one outer family serve both encoders with matched formulas? —
   survives.** Both inner codes have the same `[m,k,d]=[7,4,3]_7`
   parameters and the same message alphabet `L = F_(7^4)`. For a common
   `L`-linear outer code of length `N`, dimension `K_N`, and distance `D_N`,
   both concatenations therefore have length `7N`, base-field dimension
   `4K_N`, and the same proved distance lower bound `3D_N`. The transfer
   proof uses only the common outer dual-distance divergence plus each
   inner code's separately verified `z_0=8`.

6. **Does exact port equality preserve the reliability polynomials? —
   survives.** Zero-extension is a support-preserving bijection and relabels
   the helper ground set. Reliability is the probability of the upward closure
   of that support family, so it is invariant under this relabeling. The two
   target repair clutters are two disjoint triples and two triples meeting in
   one helper, giving by inclusion-exclusion `2s^3-s^6` and `2s^3-s^5`.

7. **Is seed equality accidentally promoted to a large-code full invariant? —
   survives.** The Abstract and pages 2, 13, 14, and 18 consistently attach
   full pointed-polynomial/profile equality to the two seeds. Theorem 6.5
   claims only matched global parameter formulas and exact radius-three ports
   on the designated classes. It does not claim equality of the full pointed
   invariant of the concatenated codes.

8. **Does Corollary 6.6 transfer anything not functorially determined by the
   exact bounded port? — survives.** Truncation by helper count commutes with
   zero-extension. Matching, transversal number, blockers, reliability, the
   leading failure term, and bounded EXIT are all determined by the resulting
   support clutter; normalized scalar decoders are carried by coefficient-port
   equality. The corollary makes no claim about global Tanner stopping sets,
   full MAP beyond the transferred radius, or whole-code pointed-Tutte data.

## Skippability map

For checking the paper's central matched asymptotic separation, the following
are **non-skippable**:

- Section 2's support/coefficient definitions (especially Definitions 2.1,
  2.3, and 2.5);
- Theorems 3.1 and 4.1 and Proposition 4.2;
- Lemma 6.3, Proposition 6.4, Theorem 6.5, and Corollary 6.6; and
- Appendix A.1, unless the reader independently recomputes the displayed
  field-seven matrices.

The following are **skippable for that central chain**, though not dispensable
to the paper's broader contribution:

- Theorem 1.1 and Corollaries 4.3–4.4 (MDS/Clebsch coefficient fingerprints);
- Corollary 3.2 (the strict weighted field-nine example);
- most of Section 5 beyond the reliability definition and the elementary
  inclusion-exclusion used in Proposition 6.4;
- Theorem 6.1 and Corollary 6.2, if equality of the explicitly displayed
  pointed polynomial is accepted directly; and
- Section 7 and Appendix A.2 (the two geometric flagship inventories).

For evaluating the claimed *full paper* rather than only the promoted C939
chain, Sections 5, 6.1–6.2, and 7 are non-skippable because they substantiate
the reliability/EXIT, pointed-Tutte, and finite-geometric parts of the title.

## Bottom line

The promoted theorem chain withstands the prescribed adversarial checks. The
strict weighted-functional decomposition and the exact zero-sector obstruction
are convincing, and the field-seven pair turns that mechanism into a clean
positive-density asymptotic separation. After making the pointed-profile
terminology explicitly enumerative rather than labeled, I see no mathematical
obstacle to release, subject to the dossier's separate formal/replay and hash
consistency gates.
