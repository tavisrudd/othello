# C1128: Astra feedback, stabilization extensions, and cubic moduli follow-on

**Lane:** `cubic-threefolds`

**Status:** active; priority 1–3 audit complete, 2026-09-08

## Goal and source

Audit the author's 2026-09-08 Astra/ChatGPT feedback on both
stabilization papers, the proposed stronger invariant and Fano applications,
the torus refinements, and the proposed three-dimensional cubic family with
genus-two level structure. This is one newly allocated task, with separately
gated work packages; allocation does not certify the supplied mathematics.
Author clarification: do the follow-on work as a mathematics/literature audit
first, then decide what, if anything, enters the manuscripts. This task's
current authorization ends at an evidence-backed audit and recommendations.

Detailed intake, formulas, priorities, evidence boundaries, and source pointers:
`notes/2026-09-08-c1128-astra-feedback-intake.md`.
Five verbatim attachments and their SHA-256 manifest:
`notes/cubic-threefolds-tasks/c1128-astra-feedback-inputs/`.

## Ordered work

1. Audit the intrinsic-to-comparison coefficient and lattice theorem. Specify
   source/common rings, maps, derivations, allowed gauges and inverse regularity,
   and grading shifts. Decide whether the stronger resonant count transports.
   Inspect the earlier narrowing from discriminants to exponent classes before
   reinstating any stronger invariant.
2. Independently replay the two supplied checkers and verify their geometric
   and literature inputs. Separate persistence from residue conjugacy; derive
   the rational two-parameter block calculation. Decide degree-one and
   quartic-double-solid applications separately, with the latter gated on (1).
3. Assess editorial changes A–H and possible placement of validated extensions,
   coordinating with the current C978/C956 state. Recommend concrete changes
   only after the mathematics/literature audit; do not edit manuscripts yet.
4. Audit torus lattice identifications, residual action matrices, normalization,
   and exact linearization thresholds. Deduplicate explicit maps against C958
   and algorithmic work against C963/C965/C966.
5. Audit the family theorem and moduli ranks, Galois containment, genus-two
   3-torsion, specialization, and Cremona nonconjugacy. Determine what is new
   and what remains an intrinsic moduli/period problem before recommending a
   separate follow-on manuscript.
6. Assess remaining structural corollaries and research directions; update the
   publication case only from accepted results and a source/novelty audit.

## Scope and coordination

Owned paths are this card, its input directory, dated C1128 reports/checkers,
the cubic lane handoff and task queue. The two authoritative directories
`papers/cubic-stabilization-m1/` and
`papers/cubic-stabilization-irrationality/` are read-only audit inputs for now.
No manuscript, formalization, mirror, or publication change belongs to this
audit phase. Read the reproducibility and literature conventions at their
respective triggers. Any later implementation follows a separate author
decision based on the completed audit.

C978 and C956 stay open by author instruction. C958 retains completion of
explicit ground-field maps. The existing deferred email remains deferred.
Do not silently merge the manuscripts, retitle Paper 2, create a follow-on
paper, or replace existing tasks merely because the supplied assessment
recommends a publication strategy. No push or external message is authorized
by this intake request.

## Acceptance

- Every supplied proposal has a disposition: validated and recommended, conditional
  with its precise missing input, rejected with evidence, already covered, or
  deferred to a named owner/gate.
- The lattice audit is explicit enough to assess the resonant quartic-double-solid
  claim independently of the finite computation; failures must also be checked
  for their effect on the existing exponent-class argument.
- Computational results have committed scripts, exact inputs, compact output,
  replay commands/hashes, and independent replay or an explicit limitation.
- Mathematical source claims, novelty assertions, and family/moduli deductions
  are checked individually; reviewer confidence and journal suggestions are
  recorded as opinions, not evidence.
- The audit finishes before any decision to include results in the manuscripts;
  provide a concise recommendation distinguishing existing-paper extensions,
  potential separate follow-on work, and claims to discard or keep conditional.
- A final report records residual gates, an explicit ej+tt pass, and the
  Mystery ledger required for substantial research work.

## Next action

Audit the universal rational block calculation and the primary quantum
inputs for the degree-one and degree-two Fano applications. The comparison
gate supports a separately defined lattice count; it does not itself verify
those family inputs. Manuscript inclusion still awaits the author's decision.

## Accepted audit chunk: priorities 1–3

Report: `notes/2026-09-08-c1128-comparison-rigidity-audit.md`.
Reviewable exposition proposal:
`notes/2026-09-08-c1128-proposed-proof-presentation.md`.

The primary comparisons preserve the canonical modified lattice; cyclic
persistence, residue regularity and low-dimensional vanishing do not use
nonresonance. Under the already-used geometric inputs this supports I_lat.
The original resonant cubic-fourfold example was not a counted whole primary
block, so it did not supply a counterexample to this stronger invariant.
The audit identifies the graded completed z-enhancement wording and explicit
persistence hypotheses as presentation repairs. Exact local identities and
negative controls pass; source-read depths and hashes are recorded. No
manuscript or Lean source changed, and no new Fano application is yet claimed.
