# 2026-08-20 — C816 work items 3 and 4: the shorter exchange-rigidity proof, and the abstract decision

**Task:** C816 (lane `clebsch`), work items 3 and 4.
**Manuscript:** `papers/clebsch-passages/`.
**Companion reports from the same pass:**
`notes/2026-08-20-c816-recognition-theorem-literature-audit.md` (work item 1),
`notes/2026-08-20-c816-theorem-d-table.md` (work item 2),
`notes/2026-08-20-c816-extremal-minor-census.md` (the census bundle).

## Work item 3 — the shorter balanced exchange rigidity proof, applied

The closing paragraph of `thm:balanced-exchange-rigidity` now runs the argument frozen in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md`. Two things leave the proof and one
thing enters it.

**Out: the switching normalization and the Ramsey bound.** The old proof switched \(C\) so that every
edge at one vertex was positive, read the four-set weight on a rooted four-set as \(xy+xz+yz\), and
split into a monochromatic case excluded by a row inner product and a triangle-free case excluded by
\(R(3,3)=6\). None of that is needed. The Ramsey equality stays in the paper, at the aligned-design
anchor, where its citation is unaffected.

**Out as a dependency, kept as attribution: the inclusion-matrix rank formula.** The proof previously
turned on Jolliffe's full-column-rank theorem for the characteristic-zero inclusion matrix from
four-sets to \(d\)-sets. The text now derives the only consequence it uses — constancy of the aligned
indicator on four-sets — from a one-element exchange and a descent on subset size, and cites Jolliffe
for the general formula rather than for the step. This matches the Lean surface, where the swap
descent is proved and the rank formula is not used.

**In: the whole-matrix fourth-trace pin.** Applying the closed-walk count to \(C\) rather than to a
half gives \(\operatorname{tr}(C^4)=2d(2d-1)^2\) on one side and
\(2d(2d-1)+12\binom{2d}3+8w\binom{2d}4\) on the other, and the two collapse to \((2d-3)w=-3\). Since
\(w\in\{3,-1\}\), that leaves \(2d=2\) and \(2d=6\). The gain over the old proof is not brevity — the
replacement is a little longer in source and costs one page — but that the same equation which
excludes the large orders identifies the surviving one: at order six every four-set carries weight
\(-1\), so the order-six conference matrix has no aligned four-set at all.

The closed-walk identity was checked before the edit was applied, on the order-six conference matrix,
on the Paley conference matrices of orders fourteen and eighteen, and on a hollow sign matrix that is
not a conference matrix; it holds in every case, the weights lie in \(\{3,-1\}\) as the text says,
and the order-six weights are all \(-1\). That check was a guard on the transcription, not a
paper-facing claim, so it is not retained as a bundle.

**The trust manifest was already ahead of the manuscript.** Row `OPER-3` describes this claim as
"order-six uniqueness by swap descent and the whole-matrix fourth-trace pin", and its proof role
already recorded the Lean coverage of the one-element swap descent and the weight pin
\((N-3)w=-24\). Until this edit the manuscript prose and its own evidence map described different
proofs. They now agree.

## Work item 4 — the abstract decision: necessity stated, spine unchanged

**Decision: the recognition theorem is stated in the abstract as a characterization, and the paper's
theorem hierarchy is not restructured.**

The reasoning. The abstract presented the source cubic as having "four exact descriptions", a
statement of coincidence, and said nothing about necessity; the natural question a reader forms at
that sentence is whether the coincidence characterizes, and the paper now answers it with a proof and
with an auditable priority boundary in row `OPER-5`. Leaving that out of the abstract understated a
result the paper contains. Promoting the recognition theorem to the paper's principal theorem is the
other extreme and would be wrong: Paper III's spine is the source--shadow--return argument from
Hitchin's cover through the conference carrier to the harmonic return, and the recognition theorem
characterizes the carrier rather than standing on that route. Making it the headline would set it
competing with the main line, which the style guide warns against directly.

What changed, in three places and nowhere else:

- **Abstract.** After the four-descriptions sentence: the coincidence is a characterization;
  proportionality of the commutator Pfaffian to the triangle cubic forces order six and a scalar
  square, with local rigidity at either oriented golden representative; and on the sign locus the
  identity is equivalent to nondegeneracy of the twenty complementary three-by-three minors.
- **Introduction.** A paragraph after the operator-stage paragraph, naming
  `thm:triangle-pfaffian-recognition`, `thm:golden-equality-rigidity`, and
  `prop:nonsingular-complementary-minors` and saying what each contributes.
- **Conclusion.** The sentence that lists the four descriptions now says that their agreement
  identifies the carrier, with the three consequences in one clause each.

What did not change: the source--shadow--return figure, the reading map, the section order, the
placement of the two standalone structural consequences, and the claim identifiers. No novelty
adjective was introduced anywhere; `OPER-5` licenses "we prove" and "we have not located" and nothing
stronger, and the new sentences state mathematics rather than priority.

## A defect this pass introduced and fixed

Landing Theorem D added two labelled statements, `thm:golden-equality-rigidity` and
`prop:nonsingular-complementary-minors`, without registering them. The paper-local scaffold gate does
not catch that, and it passed; `verification/extract_statement_identity.py --check`, which the
release aggregate runs, does catch it, and the intermediate commit left that gate red. Three repairs:

1. `EXPECTED_LABELS` in `verification/extract_statement_identity.py` now lists both new labels in
   source order.
2. Row `OPER-1` in `verification/trust_manifest.json` covers them. They are refinements of that row's
   synthesis claim, not a separate claim: the row already owned the recognition theorem, and its
   declarations already cover the conference-square and triangle mechanisms the new statements use.
   Giving them a new claim row would have meant inventing a formal-map row with borrowed Lean
   terminals for statements that have no Lean coverage at all. Two clauses and a statement and
   proof-role extension record what the new statements add and that the rank statement is not
   formalized.
3. `verification/statement_identity.json` regenerated, so the frozen digests match the current
   statements.

Two release-vocabulary violations came from the same landing and are also fixed. The `OPER-5` row in
`literature-boundaries.md` cited repository `notes/` paths, which the release gate forbids because
that directory is not in the released package; the pointers are now prose referring to the source
archive, matching how `OPER-4` records its own search record. And the phrase "the C816 bundle" in the
extended `OPER-1` proof role tripped the numbered-workflow-identifier check once it propagated into
`statement_identity.json`; it now reads "a dated evidence bundle retained in the source archive".

The lesson worth keeping: adding a labelled statement to this paper is a four-file operation, and the
scaffold gate alone does not tell you so.

## Gates

| Gate | Result |
|---|---|
| `verification/verify_scaffold.py` | OK; eleven sections, nine claims, `local_release_ready=true` |
| `verification/extract_statement_identity.py --check` | CHECK OK |
| `verification/check_manuscript_build.py` in the pinned manuscript shell | PASS, thirty-eight pages, warning-free |
| `verification/verify_release.py` in the pinned manuscript shell | exit 0; Lean gates UNCHECKED without `--lean-root` |
| `notes/2026-08-20-c816-theorem-d-table.py --check` | OK |
| `notes/2026-08-20-c816-extremal-minor-census.py --check` | OK |

The pinned page count moved from thirty-seven to thirty-eight for the page the exchange-rigidity
replacement costs. The abstract page was rendered and read. The release aggregate now passes in full
locally, including the README vocabulary gate the lane handoff had recorded as red.

## Still open on C816

The review and release items the card lists beyond the paper-local gates: theorem-level red team on
the new statements, a Milnor--Serre exposition pass over every passage this session touched, a fresh
context-free cold read of the revised PDF with repair and regrade, and downstream synchronization of
the standalone paper repository. The Lean items the C815 report proposes remain unowned and
unreserved.
