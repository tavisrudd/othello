# Complete-ports: Astra follow-up on proofs and positioning

Date: 2026-09-07. Model: GPT-6 Astra. This is a resumed, bounded referee
follow-up, not a fresh cold read or an overall publication/novelty verdict.

## Summary and contribution

The reviewer found the revision more precise about the relationship between
classical recovery, coset minimization, message passing and interface equivalence,
and the paper's labelled, target-normalized formulation for exact composition
and confinement. The three questions organizing related work improve the route
through those connections without asserting unsupported priority.

## Correctness

The explicit rational seeds, finite exclusions, lift conditions and common-prime
reduction close the previously identified completeness concern in the reliability
construction. The reviewer independently checked the seed incidences. The width
proof now distinguishes affine compatibility from realization, states the
optimization invariant, and proves both directions of the child-to-parent
correspondence. Its pair-count bound is separated from arithmetic and compilation
costs.

## Exposition and organization

The reviewer inspected rendered pages 22–25 and 29–30. The seed displays fit;
the generic-lift and finite-field headings divide the construction usefully;
the width assumptions, invariant and cost qualifications remain together. The
running reliability example provides an effective bridge from support choices
to overlap-sensitive probability.

## Major and minor comments

No remaining major comment within this bounded scope. One minor comment was to
replace “identify the first nonconfined support” with “determine the least support
size of a nonconfined recovery equation.” This preserves the distinction between
equation confinement and minimal-support confinement. The parent applied it in
the related-work subsection.

## Scoped recommendation and coverage

Accept this proof-and-positioning pass after the terminology clarification.
This recommendation concerns the reviewed changes only.

Coverage: the revised related-work subsection, the two edited proofs and
surrounding exposition, and the six rendered pages above. The reviewer read
the private literature-audit report but did not independently reread its eleven
partially consulted primary sources, extend the search, run experiments, or
execute Lean. No numerical assessments are included.
