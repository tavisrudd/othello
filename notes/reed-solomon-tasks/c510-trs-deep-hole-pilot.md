# C510 — twisted Reed--Solomon deep-hole audit and geometry pilot

**Lane:** `reed-solomon` · **Date queued:** 2026-07-23 · **Gate:** after C509 entry theorem

## Objective

Run a bounded pilot, not an “all TRS” programme:

1. read at full text and reconcile notation/regimes in Fang--Xu--Zhu,
   `arXiv:2403.11436`, and Gu--Wang--Zhang, `arXiv:2509.08526`;
2. refresh their citation/author streams under `notes/literature-audit-conventions.md`;
3. identify the first residual one-twist family where a complete deep-hole classification is both
   open and structurally adjacent to the PRS lane;
4. derive its parity-check/syndrome geometry and determine whether it is a rank-one deformation of
   an NRC/Hankel system;
5. test one small field or symbolic normal form; and
6. return a go/no-go verdict for a theorem task, with no broad allocation unless the deformation
   retains a usable kernel, symmetry group, or polar recursion.

## Current evidence

The 2024 paper gives the covering radius and standard deep holes for a general one-twist family,
then excludes other deep holes in a high-rate range and completely determines the full-length
family in its top redundancies.  The 2025 paper treats a different multiplicative-evaluation
one-twist family, with a syndrome criterion, high-rate exclusion range, and a complete
even-characteristic top-redundancy result.  These statements are currently **abstract/metadata
only** and must not be sharpened until full text is read.

The PRS polar recursion may transfer only if the twist leaves the parity-check columns on a
controlled projection or rank-one deformation of an NRC.  Loss of full \(PGL_2\) symmetry is the
main anticipated obstruction; a surviving affine/dihedral subgroup may still make a fixed family
tractable.

## Deliverable

Task report: `notes/2026-07-23-c510-trs-deep-hole-pilot.md`.  The report must state exactly what is
already classified, name one bounded residual target, and either prove a reusable syndrome
reduction or close the pilot with a precise obstruction.
