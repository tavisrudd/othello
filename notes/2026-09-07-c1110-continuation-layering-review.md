# C1110: exposition layering and accessibility pass

**Lane:** continuation. **Date:** 2026-09-07.

## Audience and style-guide diagnosis

Primary audience: finite-geometry and algebraic-combinatorics researchers.
Adjacent audience: graph-theory and algebra graduate researchers familiar with
finite fields but not tangent-pencil reconstruction. The complete style guide
was read. The previous version presented its theorem promptly, but compressed
three language changes into a formula and delayed the explanation of why the
large cliques identify the desired incidence structures. The introduction's
corollary proof also interrupted the conceptual route.

## Changes and checks

The abstract now describes a frame and tangent traces operationally. The
introduction defines tangent, secant, trace, pencil and semilinear action before
the main theorem. A concrete F13 example illustrates coordinatewise agreement;
the ten-versus-nine and eleven-versus-four gaps explain both intrinsic recovery
steps. A short displayed chain links graph, traces, pencils and coordinates.
Related work and the reading guide have separate jobs. The corollary proof
moved beside the main theorem's proof. Centre recovery and the two algebraic
lemmas now have conceptual entry paragraphs. Recognition is divided into
partition recovery, table completion, field assignment/checking, and cost.

No theorem statement, field range, algorithm, or certificate changed. The new
F13 example was checked directly: 2/3=5, 1/2=7, 2/4=7, 1/3=9 modulo 13.
The size gaps are substitutions into the proved bounds at k=4,q=13. The
diagram is a guide to this frame reconstruction, not a general-arc claim.
Moving the corollary proof preserved its semantic label and added the detached
proof annotation; source checks accept the correspondence.

Authority make check/pdf passed, including deterministic PDF builds and all
existing source, mutation, finite replay and recognition controls. Draft is
12 pages (331605 bytes), up from 11; all pages were visually inspected.
Frozen before/after PDFs are in ~/.cache/continuation-review/layering/;
the before version is also recoverable from authority commit f0964aeba.
Visual closeout identified two minor final polish items: replace the moved
proof's stale word “below”, and keep the census statement opening with its table.
These will be applied after the cold reader finishes the frozen snapshot.

## Independent grading protocol

A fresh sub-agent receives only the revised paper, routing rules and style guide,
not prior reports. Requested dimensions separate specialist clarity, adjacent-field
accessibility, navigation, motivation, proof transparency, definitions, concision,
computational disclosure, literature positioning and overall readiness. Percentiles
are subjective estimates against specialist research preprints with uncertainty
ranges; they are not benchmark measurements or correctness probabilities.
No human blind before/after comparison or novelty clearance is claimed.

## ej+tt closeout / Mystery ledger

The cheap explanatory gain is to show both size gaps in the same F13 model:
this makes their shared mechanism visible without removing their different
incidence hypotheses. The fourth translated quotient explains why multiplication
alone is insufficient. No mathematical mystery is settled by editorial changes;
the q=7,8 computation-free questions and priority diligence remain open.
