# C550 — four-copy permutation-cover holonomy theorem

**Lane:** `crowns`

**Date:** 2026-07-23

**Status:** queued; highest-EV conceptual successor to C548

## Goal

Replace C548's 720-matrix rank-drop proof by one intrinsic four-sheeted cover theorem.  The six
party permutations define six perfect matchings between four ket-copy vertices and four bra-copy
vertices.  Equip this bipartite multigraph with the rank-three data carried by the six code
columns.  Prove that the contraction kernel is its space of global sections, with the universal
three-dimensional diagonal kernel as the constant sections.

Use this object to derive, rather than recognize afterward,

```text
(z-2)(9z-4)=0
```

and the tetrahedral/octahedral double-coset multiplicities `96/192`.

## Required proof shape

The proof must transfer the mechanism, not merely shorten the computation.

1. Begin with one concrete four-sheeted cover and show how its constant sections produce the
   universal kernel.
2. State the section-obstruction theorem before introducing coordinates.  A reader should know at
   this point what structural feature can create one extra section.
3. Gauge away the constant sections, decompose the remaining equations by cycles or transport
   paths, and reduce the obstruction to the smallest natural holonomy blocks.
4. Read `z=2,4/9` from those blocks.  Then classify the corresponding cover automorphisms and
   obtain `96/192`; do not present the counts before the objects they count.
5. Put the 720-term certificate in a verification paragraph or appendix whose only role is to
   check the conceptual reduction and exceptional fibres.

The successful exposition should let an adjacent expert answer, without consulting the checker:
why four sheets are the first useful size, why there are two resonances, why their multiplicities
differ by a factor of two, and why characteristic 7 merges them.

## Acceptance gate

1. Define the cover or linear sheaf functorially under common copy relabelling, party relabelling,
   and projective code equivalence.  Prove that its section operator is row/column equivalent to
   C548's `24 x 21` quotient matrix.
2. Identify the intrinsic cover types supporting an extra section.  Recover their automorphism
   groups and seams as

   ```text
   (S4 x C2, D8 x C2; C2^3)
   and
   (S4, S4 x C2; S3),
   ```

   and derive `48*16/8=96` and `24*48/6=192`.
3. Reduce the section obstruction to small cycle-transport or holonomy blocks and derive the two
   resonance values `z=2,4/9` without using the 720 maximal-minor calculations as the
   load-bearing proof.
4. Explain the signed `4/9` sheets, the common `A4` quotients `8/16`, and the characteristic-7
   merger from the same construction.  Keep boundary and ramification phenomena separate from
   the reduced `z`-line theorem.
5. Give an exact verification bridge back to C548's certificate.  Follow
   `papers/style-guide.md`: lead with the cover and theorem, expose the point where understanding
   is won, and keep verification mechanics out of the conceptual proof.  The acceptance judgment
   is based primarily on whether the proof clarifies the mechanism.

## Stop rule

Stop positively when one intrinsic cover/holonomy theorem implies both the divisor and the
multiplicities.  Stop sharply negatively if the proposed cover language only renames the original
matrix or if the constants still require the full Fitting computation.

Do not launch a larger contraction census, higher-copy search, general AME classification, or
paper rewrite.  Four-copy minimality and the uniform `LU iff LC iff equal z` conjecture remain
separate gated successors.

## Frozen inputs

- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.md`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.py`
- `notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.json`
- `notes/2026-07-23-c397-ame-perfect-tensor-physics.md`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- `papers/style-guide.md`

Any new paper-facing computation must use a report/script/canonical-certificate/checksum bundle.
