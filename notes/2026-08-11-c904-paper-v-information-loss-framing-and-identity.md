# Paper V information-loss framing and publication identity

Date: 2026-08-11
Lane: `clebsch`

## Outcome

Paper V now leads with the portable inverse problem: two geometrically
inequivalent cubic invariants may retain the same marked source information.
The selected-line equivalence, exact unselected `C2` quotient, six-point
recognition identity, and uniform conference-saturation theorem are visible
before the series provenance.

The publication identity is:

- title: *Chordal and Conference Cubics: Reconstruction and a Residual
  \(C_2\)-Torsor*;
- monorepo root and repository slug: `chordal-conference-reconstruction`;
- manuscript/PDF stem: `chordal_conference_reconstruction`;
- paper identity: `chordal_conference_reconstruction`.

The previous *Golden Companion Correspondence* wording survives only as
historical terminology.  It is no longer the publication title.

## Editorial evidence

The PDF-only blind A/B review read the revised framing first, then the prior
version, without source or review access.  It preferred the revised version
on every requested dimension:

| measure | prior | revised |
|---|---:|---:|
| specialist confidence | 9.0 | 9.3 |
| generalist accessibility | 7.2 | 8.4 |
| opening clarity/portability | 7.0 | 8.8 |
| standalone inverse-theorem reading | 7.1 | 8.8 |
| precision/overclaim control | 8.8 | 9.4 |

The three-reader blind title panel was unanimous on the title architecture.
The geometry and generalist readers independently chose the adopted title;
the combinatorics reader chose the synonymous ending “up to a residual
involution.”  All three chose `chordal-conference-reconstruction` as the short
form and rejected the old title as memorable but externally opaque.

An abstract-only adjacent-field cold read initially returned MAJOR because the
first rewrite left object types, two distinct `C2` actions, and the uniform
lattice theorem under-specified.  The repaired abstract now:

- types the carrier, field, cubics, and base-change range;
- defines the chordal line and the free `uq` action, which fixes conference
  orientation;
- defines every symbol and summation range in the pair-defect identity;
- states the least stable lattice, induced residue algebra, and both mod-eight
  branches;
- gives the explicit equivariant map from conference orientation to the two
  primitive `F4` scalars.

The same reviewer returned PASS and confirmed that the free reconstruction
quotient is not conflated with the conference-orientation/Frobenius torsor.

## Validation

From `papers/chordal-conference-reconstruction/`:

```sh
make check
```

passes, including evidence, TeX lint, deterministic manuscript build, and the
zero-warning gate.  The rendered first page was inspected at full resolution;
the title and 311-word abstract fit on one page without crowding or overflow.

- pages: 22
- source SHA-256:
  `47a9bc87827197b29c96c28c3e0d20eb5feb94c0718efddd1e84a28d54292df0`
- PDF SHA-256:
  `893043ca18855aa1792803269751b1763d6765968368a2fb83f841d660869034`
- PDF size: 187,932 bytes

The standalone checkout was renamed in place to
`~/src/math-papers/chordal-conference-reconstruction`, preserving its Git
history, and its unpublished remote now names the new slug.  Content sync is
performed only after the committed authority passes the exporter audit.

## Prepared back patches

The four earlier numbered papers still cite the historical title by explicit
author instruction not to apply back patches yet.  The exact title-only edits
are recorded in
`notes/2026-08-11-c904-paper-v-title-backpatches.md`.

## Mystery ledger

- **Settled by the A/B pass:** the information-loss framing is a material
  editorial upgrade rather than a dilution of the theorem.
- **Settled by the title panel:** the publication title should name the two
  cubics and the residual torsor; “golden companion” is not sufficiently
  discoverable.
- **Settled by the abstract cold read:** all three general theorem headlines
  can coexist in one self-contained abstract without merging the two `C2`
  actions.
- **Open by scope, not mathematics:** the title-only bibliography back patches
  to Papers I--IV remain unapplied until the coordinated series patch round.

No mathematical mystery was created by this editorial revision.
