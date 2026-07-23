# C537 — Flatland--Gale multi-view comparison

**Lane:** `reed-solomon` · **Status:** queued after C536; does not displace C531

## Objective

Determine whether C481--C485 resolve the multi-view joint-consistency gap explicitly left open
around Theorem 6 of Agarwal--Connelly--Crannell--Duff--Thomas, or whether the two constructions
have inequivalent inverse inputs despite sharing the labelled six-point `P1` invariant quotient.

## Entry evidence

- Flatland Theorem 6 gives pairwise fundamental-matrix conditions for several planar point
  configurations to share a line image and explicitly warns that pairwise reconstructions need
  not be jointly consistent for three or more cameras.
- Flatland's six-point invariant quotient and C481's atlas are both presented through the labelled
  `P1` GIT quotient.
- C482 proves residual dimensions `2,1,0` for two, three, and four coherent views and a quadratic
  four-view Gale pair; C483 identifies its branch and deck geometry.
- `papers/papers-index.md` assigns complete-child reconstruction to
  `arcs_complete_outside_conic` and continuation reconstruction to
  `continuation-graph-rigidity`.  Those ownership boundaries are hard stops, not paper prompts.

## Work

1. Read the Flatland paper end to end and compare the two functors: scenes, line images, cameras,
   labels, ambient embeddings, admissible degeneracies, and equivalence groups.
2. Translate the fundamental-matrix and Joubert-invariant conditions into C481's bracket
   coordinates on labelled `M_0,6`.
3. Decide whether C481 diagonal compatibility is equal to, strictly refines, or is incomparable
   with Flatland joint consistency.
4. If the functors match, compare Flatland's camera-center cubics with C482's residual surfaces,
   curves, and four-view Gale involution.
5. Consider finite-field descent only after the geometric functors match exactly.

## Exit gates

- **Success:** an exact identification showing that C481--C485 supply the missing joint-consistency
  theorem and identifying the extra finite-field/Gale content.
- **Characterized boundary:** a precise one-way implication with an explicit missing datum.
- **Kill:** incompatible inverse inputs, equivalence relations, or degeneracy domains.
- **Portfolio stop:** even after a match, do not allocate a manuscript if the theorem is already
  owned by the pending `arcs` or `continuation` papers.

No manuscript, ambient census, or displacement of C531 is authorized.

## Owned paths

- `notes/reed-solomon-tasks/c537-flatland-gale-multiview-comparison.md`
- `notes/2026-07-07-codex-task-queue.md`
- `notes/handoffs/2026-07-22-reed-solomon-deep-holes.md`
- the exact comparison report produced by C537
