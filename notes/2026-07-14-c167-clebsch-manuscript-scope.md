# C167 — Clebsch manuscript single-spine rewrite

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: REPORTED. The internal scope rewrite is complete. C146/C153 and C131/C161 remain
separate external-source priority gates; they are not paper-scope defects that this rewrite can
resolve locally.

## Outcome

The manuscript now has one spine:

1. the Clebsch six-arc and exact projective syndrome locus;
2. coding semantics and monomial/affine orbit structure;
3. the five-way rigidity theorem;
4. global and local quantitative gaps;
5. the unbased chirality bipartition;
6. the unconditional finite-field isolation of q=11, with q=19 as the same-recipe failure.

Everything after that endpoint was removed. Roughly 180 source lines disappeared without changing a
theorem or proof.

## Cuts

- **Standalone Klein section:** removed. C128 proves the exact reduced forms and syzygy, but the
  section's group/conjugator/diagonal claims depended on an untracked scratchpad computation and the
  whole section admitted it was non-causal and unused.
- **Schreier/icosahedron aside:** removed from this paper. It is correct and kernel-checked in the
  companion development, but duplicated companion infrastructure and carried no present theorem.
- **Higher-redundancy open question:** removed. It named no candidate and reopened the refuted
  dual-variety program.
- **Dual code paragraph:** removed. Exact isoduality is a valid computed byproduct, not evidence for
  the rigidity theorem.
- **Mathieu transversality paragraph:** removed. Its conclusion was negative (“unrelated to its
  blocks”), and it risked importing the gem lane as a third paper spine.
- **Ten-arc foil:** removed. A different-length complete orbit does not support the six-arc theorem,
  and the paragraph's inference about “generic” covering-radius behavior from one orbit was invalid.
- The now-unused BDMP, Dickson, and Elkies bibliography entries were removed with these sections.

The q=19 section remains because it applies the same six-axis recipe and quantifies exactly how the
headline construction fails (`20+120` projective syndrome directions). It is a genuine mechanism
test rather than decorative adjacency.

## Claim calibration

- The abstract no longer promises that the code is literally the mod-11 reduction of Klein's six
  axes. It says only what the paper proves and sources: the Clebsch hexagon is an icosahedral six-arc
  with stabilizer `A₅`.
- The introduction no longer promises an unused Klein-invariant section.
- “These results appear nowhere else” was replaced by the checkable statement that they do not
  appear in the companion arcs paper, with broader priority handled in the rigidity literature
  comparison.
- The abstract and introduction no longer assign the raw extension-count spectrum categorically to
  Hirschfeld--Sadeh while C131 is unresolved. They call the census classical, recompute the numbers,
  and claim no priority on the raw spectrum.
- Searches for the removed Bayes/error-floor/latent-variable prose found that it had already been
  deleted; C167 did not revive it.

## Cross-lane seam

C174 turned the gem identity into a stronger theorem for every six-arc in every finite projective
plane:

\[
t(H)+|U(H)|=q^2-14q+115.
\]

The Clebsch manuscript imports exactly its q=11 specialization `t(H)+|U(H)|=82` to explain the four
on-conic extension values. It explicitly says that the separate Mathieu characterization of the
extremal row is not part of this paper. The working-note citation points to the drafted C155 note;
no hexad theorem or two-system claim enters the Clebsch proof.

## Reproducibility effect

The cited executable surface is now seven paper-package scripts rather than ten:

- `check_rigidity_degenerate_conic.py`;
- `check_code_automorphisms.py`;
- `check_chirality.py`;
- `check_global_conic_gap.py`;
- `check_perturbation_gap.py`;
- `check_small_q_uniqueness.py`;
- `check_q19_nonexample.py`.

The removed dual, Mathieu, and ten-arc scripts remain hardened and Git-indexed as byproducts, but
they no longer belong to the submission manifest. C128's new strict-kernel source remains a durable
historical artifact rather than a manuscript premise.

## Validation

- Tectonic build after the final seam: exit 0, no citation, reference, or layout warning; PDF size
  138.79 KiB.
- `git diff --check` on the manuscript and C128 source: clean.
- C128 Lean validation: exit 0; axiom profile `[propext, Classical.choice, Quot.sound]`, no
  `sorryAx`, no `native_decide`.
- C174/C155 computation manifest replay caught and repaired two fail-open C147 checks; the exact
  hardened sources and hashes are Git-indexed.

## Remaining submission blockers, not hidden by the rewrite

- **C146/C153:** land Edge/BSW/Clebsch exterior-set vocabulary and citations; read the two BSW
  originals to settle the last headline collision risk.
- **C131/C161:** settle Sadeh ownership and the earliest source for the stabilizer equivalence.
- **C168:** produce the final clean-source hash/command/output manifest, replay it, audit the PDF and
  companion numbering, and prune the live handoff.

These gates affect attribution and submission confidence. They do not require restoring any of the
cut secondary spines.
