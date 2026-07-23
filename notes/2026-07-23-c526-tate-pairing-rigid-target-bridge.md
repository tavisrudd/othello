# C526 — canonical Tate pairing versus the rigid C433 target

**Lane:** `crowns`

**Status:** `QUEUED`

**Date:** 2026-07-23

## Goal

Answer the one exact bridge question left by C412/C433:

> Does C412's canonical relative-cubic Tate two-plane carry a natural pairing for which its
> ordered rank-one/rank-nine flag is isometric to C433's rigid depth/Fourier target package?

The target is solved input.  It consists of the depth plane, divided-Fourier radical, contraction
`h`, valency metric, and ordered doubled/residual cubic flag.  Its projective automorphism group is
trivial.  C526 must therefore prove one forced source-to-target isometry or a conceptual
obstruction; it must not enumerate or fit C412's ten residual flag maps.

## Inputs

Read only what the gate needs:

- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`
- `notes/2026-07-20-c412-relative-cubic-depth-plane.py`
- `notes/2026-07-20-c412-relative-cubic-depth-plane.json`
- `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.md`
- `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.json`
- if a pairing-descend lemma genuinely needs it, C417's unique affine-cocycle report as a
  read-only ambient-extension input.

Do not preload the manuscript, unrelated modular dossiers, or another finite-group census.

## Gate order

1. **Canonical source pairing inventory.**  Reconstruct C412's exact Tate cycle

   ```text
   R --pi--> M_G --N--> R
   ```

   and derive, rather than choose, every pairing induced by the frozen `PGL_2(11)`-invariant
   bilinear data on the ambient module.  Test invariant-form descent, the canonical
   invariant/coinvariant evaluation pairing, and the Tate-duality pairing.  Quotient out overall
   scalar immediately.
2. **Descent and nondegeneracy.**  Determine which candidates are well-defined on
   `R/im(N)` or pair it perfectly with `ker(N)`.  A candidate that depends on a section, affine
   base, basis, or one of the ten fitted maps is inadmissible.
3. **Exact invariant comparison.**  For every admissible source form compute:

   - rank and determinant square class;
   - isotropic/anisotropic type;
   - adjoint behavior of the Tate projection/norm maps;
   - Gram data of the ordered rank-one/rank-nine source flag.

   Compare these with C433's target valency form and ordered doubled/residual flag.
4. **Naturality and subgroup boundary.**  Verify outer-sign covariance and that restriction to the
   characteristic-11 semisimple `A5` Mackey interface introduces no extra choice.  Keep the ambient
   `PSL_2(11)` extension distinct from an `A5` incidence augmentation.
5. **Uniqueness or obstruction.**  If the metric/flag invariants agree, construct the unique
   projective isometry and verify compatibility with `pi`, `N`, the C433 quotient row, and the
   ordered flags.  If they disagree—or no natural nondegenerate source form descends—state the
   exact obstruction and close.

## Acceptance and stops

Positive exit:

- one coordinate-free source pairing construction;
- one projectively forced source-to-target isometry;
- compatibility with the Tate cycle, outer action, and semisimple `A5` restriction.

Negative exit:

- a proof that every natural candidate is zero, degenerate, section-dependent, has the wrong
  square class/type, or sends the ordered source flag to the wrong target orbit.

Stop immediately if the remainder is any of:

- choosing among C412's ten fitted projective maps;
- another decomposition-number or rank-drop census;
- a field-by-field search;
- manuscript novelty wording.

## Reproducibility and hand-backs

Any matrix or finite-field claim requires one atomic report/script/canonical-JSON/checksum bundle
with an independent replay, exact input hashes, and `--check` mode.  The output stem is
`notes/2026-07-23-c526-tate-pairing-rigid-target-bridge`.

Hand back the final yes/no theorem to:

- C433's report and the crowns handoff;
- C439 as a solved modular-seam input;
- C527 for Paper-2 wording and the exact Lean theorem boundary.

No literature absence or priority claim is part of C526.
