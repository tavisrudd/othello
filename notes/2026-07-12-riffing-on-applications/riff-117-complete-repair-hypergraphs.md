# Complete repair hypergraphs for locally repairable codes

Status: exploratory paper agenda  
Primary source: `RIFF_3`, `RIFF_117`–`RIFF_120`  
Existing mathematical base: `FiniteGeom`, `RepairCodes`, the twisted-cubic–axis and
characteristic-matched Roth–Lempel families

## Mathematical spine

- [`MATH_7`](math.md#math_7--repair-tolerance-equals-transversal-number) — repair failure tolerance
  is the repair hypergraph's transversal number.
- [`MATH_8`](math.md#math_8--bounded-repair-confinement-preserves-the-complete-repair-hypergraph) —
  bounded-repair confinement preserves the complete repair hypergraph.
- [`MATH_9`](math.md#math_9--exact-τν-formulas-for-geometric-repair-code-families) — exact geometric
  `τ/ν` formulas are the substantial open target.

## Thesis

Locality, advertised repair-set count, and disjoint availability do not determine the resilience
of a code's bounded repairs. The complete bounded-radius repair hypergraph is the right object: its
matching number `ν`, transversal number `τ`, coordinatewise variation, and behavior under code
composition expose shared dependencies that conventional summaries miss.

## Minimum publishable contribution

1. Define the complete radius-`r` repair hypergraph in a coding-theoretically natural way.
2. Prove at least one infinite family with a nontrivial `τ/ν` separation or coordinatewise
   phenomenon not recoverable from locality and repair count.
3. Prove a transfer/composition theorem preserving the complete bounded-radius repair hypergraph.
4. Demonstrate on small exact instances that representation count or `ν` alone can rank repair
   resilience incorrectly.

The existing `τ>ν` constructions and bounded-repair transfer lemma appear to cover most of this
core, subject to a specialist citation-chain audit and statement review.

## Research agenda

### Phase 1 — Definition and prior-art boundary

- Normalize terminology against LRC availability, stopping sets, repair groups, and recovery sets.
- Determine whether the complete repair hypergraph or the claimed separation has already appeared
  under another name.
- State precisely which claims are structural, extremal, computed-exact, or asymptotic.

### Phase 2 — Exact finite evidence

- Re-run all seed computations from tracked scripts.
- Emit complete hyperedges, `ν`, `τ`, orbit classes, and coordinatewise statistics.
- Add independent brute-force checks for the smallest fields.
- Explain the non-monotonic examples rather than presenting only a table.

### Phase 3 — Infinite constructions and transfer

- Package the twisted-cubic–axis and Roth–Lempel results around one common invariant.
- Prove that the transfer construction preserves every repair of weight at most `r+1`, not merely a
  selected set of advertised repairs.
- Separate what follows from general concatenation from what is special to the seed.

### Phase 4 — Systems-facing interpretation

- Translate hypergraph vertices into failure domains and repair edges into executable repairs.
- Give one synthetic rack/region example showing why repair count exaggerates resilience.
- Avoid claims about deployed storage performance without an implementation benchmark.

## Paper spine

1. **Introduction:** locality is not complete repair resilience.
2. **Repair hypergraphs:** definitions, coordinate restrictions, `ν`, `τ`, and baseline bounds.
3. **Exact separating examples:** smallest witnesses and failure of naive summaries.
4. **Geometric infinite families:** construction and all-symbol separation results.
5. **Bounded-repair transfer:** preservation theorem and asymptotically good families.
6. **Failure-domain interpretation:** what the invariant means operationally.
7. **Computation and verification:** replay scripts and Lean trust chain.
8. **Limits and open problems:** decoding cost, higher-radius repairs, and sharp extremal ratios.

## Shallow literature and novelty check

Closest precedents found:

- Kim and Song construct LRCs from hypergraphs and use disjoint repair sets as availability:
  [Hypergraph-Based Binary Locally Repairable Codes with Availability](https://doi.org/10.1109/LCOMM.2017.2730183).
- The wider LRC literature already treats recovery/repair sets, availability, and hypergraph-based
  constructions; those ingredients are not independently novel.

Preliminary verdict: **promising but terminology-sensitive**. The likely distinct contribution is
not “use a hypergraph for an LRC.” It is to take *all* bounded-weight repairs at each coordinate as
the authoritative hypergraph, study transversal rather than only disjoint availability, exhibit
`τ/ν` separations and non-monotonicity, and prove preservation of that complete object under the
transfer construction.

Required deeper audit:

- stopping-set, recovery-set, availability, cooperative-repair, and batch-code terminology;
- prior use of hitting/transversal numbers on complete repair families;
- whether concatenation or locality-preserving constructions already imply the claimed complete
  bounded-repair preservation theorem.

## Release gates

- Specialist prior-art audit passes.
- Every theorem promoted from the notes has a statement-level Lean adequacy review.
- Exact tables reproduce from tracked inputs and an independent checker.
- The paper never substitutes `τ/ν` for a full deployed-system reliability model.
