# Aligned-design faithfulness formalized at the manuscript's quantifier range

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815 (continuing)
**Paper:** III (`papers/clebsch-passages`), Theorem `thm:aligned-faithfulness`

## What is now proved

`RelativeConicArcs.AlignedTwoGraph.exists_complementBit_of_alignedFamily_eq`, in the new module
`lean/RelativeConicArcs/AlignedFamilyFaithfulness.lean`, states: let `tau` and `sigma` be
triangle-bit functions on a finite type with at least seven elements, each invariant under
permuting its three arguments and each satisfying the four-set parity law; if they have the same
aligned four-sets on pairwise-distinct quadruples, then there is one bit `epsilon` with
`sigma a b c = xor (tau a b c) epsilon` for every triple of pairwise-distinct points. With
`aligned_complement_iff`, which gives the converse direction, this is exactly the manuscript's
statement that the aligned family determines the two-graph up to complement for `|V| >= 7`.

This closes items 3 and 4 of gap class C of
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`: the faithfulness statement is no
longer restricted to the normalized seven-point data type, and the globalization theorem
`global_agreement_of_common_seven_restrictions` is no longer conditional on an assumed
co-containment and local-faithfulness hypothesis, because that hypothesis is now discharged.

Two intermediate theorems are also audited. `sevenPoint_agreement` is the index-level statement on
seven points carrying an anchor normalized for both two-graphs; `exists_complementBit_on_seven`
is the same statement for an arbitrary seven-element `Finset`, with the anchor produced inside the
proof.

## Mechanism

The formal proof follows the manuscript proof, with one simplification that removes the switching
step entirely. Rooting at a point `q3` of an aligned four-set whose common triangle bit is zero
already makes all six graph edges inside that four-set vanish: the rooted edge bits are
`tau q3 u v`, the three anchor pairs are zero because the four-set is aligned with value zero, and
every edge from the root is zero by construction. So no switching is needed to normalize, and the
normalized cut of an outside point `x` is read directly off the triangle bits
`(tau q3 q0 x, tau q3 q1 x, tau q3 q2 x)`.

Under that normalization the parity law turns each selected aligned test into a Boolean predicate
in the cut coordinates and the mutual edge bit. The four tests meeting the anchor in three points
become `anchorSignature`, and the six tests meeting it in two points become `pairSignature`, in the
exact form those functions already had. Equality of the aligned families therefore gives equality
of all normalized seven-point signatures, and `normalizedSevenSignature_injective` returns equality
of the three cuts and the three outside edges. Those are the rooted edge bits, so the parity law
rebuilds every triangle bit on the seven points.

For larger point sets, any two triples span at most six points and extend to a seven-point subset;
the seven-point result gives one complement bit valid on both triples, and
`global_agreement_of_common_seven_restrictions` matches those bits globally against a fixed base
triple.

The distinctness obligation that was previously listed as a human step is discharged as part of
this: the seven points are the elements of a `Finset` of cardinality seven, and injectivity of the
indexing follows from surjectivity onto that set by counting, rather than from a case analysis.

## Trust boundary

Every new declaration depends only on `propext`, `Classical.choice` and `Quot.sound`; two of them
(`aligned_xorBit_iff`, `normalizedAnchor_of_aligned`) depend on no axiom at all. Nothing in the
module uses compiled evaluation, generated data, an external program, or a project axiom. The two
finite classifications it rests on, `anchorSignature_eq_false_iff_balanced` and
`pairSignature_classification`, are kernel-decided in `AlignedTwoGraph` over eight and 16,384
cases respectively.

The `ClebschPassages` gate now audits fifty-six terminals, six of which depend on no axiom.

What remains human in manuscript row OPER-4: the identification of the marked
determinant-\((-3)\) family of a symmetric conference matrix with the aligned family, and the
sufficiency of the selected query family for a decoder working from one anchor.

## The query family

`AlignedTwoGraph.selectedQueryFamily`, in `lean/RelativeConicArcs/AlignedQueryFamily.lean`, is the
family of four-point subsets meeting a fixed four-point anchor in at least two points, and
`card_selectedQueryFamily` proves that its cardinality is `3n^2 - 23n + 45` for `n` points. The
proof splits a four-set into its anchor part and its outside part; that is a bijection onto pairs
of a `k`-subset of the anchor and a `(4-k)`-subset of the complement, so the three fibres have
sizes `6*C(n-4,2)`, `4(n-4)` and `1`. Because the count is the cardinality of an explicitly
described family, the tests it counts are distinct by construction, which is what the earlier
`selectedQueryCount_eq` identity did not supply. This closes item 1 of gap class C.

The manuscript says more than the count: that this family of tests suffices for a decoder working
from a single anchor. That is not formalized, and the faithfulness proof above does not establish
it, since each of its seven-point restrictions locates its own anchor rather than reusing a global
one.

## Records updated

`papers/clebsch-passages/sections/08-verification.tex` said that distinctness, the finite-set
extension, and the label normalization remain human combinatorial steps. That is now false and the
paragraph is rewritten to the actual surface. The `AlignedTwoGraph` module header still described
its two classifiers as compiled evaluation, which the 2026-08-04 gate-hardening round had already
replaced by kernel decision; it now names the actual method.

`passages_formal.json`, `passages_axioms.txt`, `passages_source_closure.json`,
`trust_manifest.json`, `statement_identity.json`, the tracked gate log, and the tracked PDF are
regenerated or re-pinned. The row's `coverage` field keeps the enumerated value
`partial mechanism; no full row claim`, which the release scaffold requires of every row and which
is still accurate, and the two remaining human inputs are named in its `excluded` field.

## Replay

```sh
lean/scripts/lean-build-queue.py build RelativeConicArcs.Gates.ClebschPassages --cores 20-23

cd papers/clebsch-passages
python3 verification/verify_passages_lean.py --lean-root ../../lean --source-only
python3 verification/verify_passages_lean.py --lean-root ../../lean \
  --axiom-log verification/evidence/gate_stdout/passages.stdout.txt
nix develop --command python3 verification/verify_release.py --lean-root ../../lean
```

The gate build, both paper-local replay modes, and all twenty release checks pass. The tracked gate
log for the axiom report is the standard output of build run
`run-20260805-033610-e983d3b4`.
