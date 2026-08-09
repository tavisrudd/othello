# C897 Paper III Greaves focused regrade

**Verdict:** `PASS`

**Artifact audited:** clean standalone commit
`9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`; PDF SHA-256
`a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`.
The standalone worktree was clean, and the PDF had the stated 232,877-byte
extent.

## Frozen PDF-only judgment

The PDF-only verdict was frozen as `PASS` after reading PDF pages 14--16 and
the displayed conference matrix on page 11, and before inspecting any
supplement.

1. The displayed symmetric sign matrix satisfies `C^2=5I`.  Its twenty
   triangle products, in the subset order printed immediately before Table
   (5.1), give the following coefficient words under
   `epsilon_{pT_0}(S)=sgn(p) epsilon_{T_0}(p^{-1}S)`:

   ```text
   r=0  012345  --+++-++--++--+---++
   r=1  012354  ++----++-+-+--++++--
   r=2  012435  +-+-+---++--+++-+-+-
   r=3  012453  -+-+++---+-+++---+-+
   r=4  012534  -++--++-+-+-+--++--+
   r=5  012543  +--+-+-++-+--+-+-++-
   ```

   These agree character-for-character with all six printed rows.  In
   particular, the formerly sensitive `r=2` row is correct.  The odd
   permutations are exactly `r=1,2,5`, so the global sign in the transport
   formula is doing real and correct work rather than being an inert
   convention.

2. The table is self-contained about ordering and action convention: it fixes
   the twenty subset positions, uses one-line notation for every permutation,
   identifies `T_0` with the total attached to the displayed matrix, and
   prints the inverse-image and parity rule.  Thus the matrix, permutations,
   and sign transport determine the table without an unstated scalar or
   orientation choice.

3. For a four-set, the three Hamilton-cycle signs have product `+1`, hence
   their sum is either `3` or `-1`.  The condition `w(K)=3` says that all three
   are positive, equivalently that the four triangle signs are all equal.
   It is therefore exactly the union of the all-coherent and all-incoherent
   four-set fibres.  The PDF now says this explicitly instead of presenting
   `aligned` as standard terminology.

4. The displayed identity `det C[K]=3-2w(K)` consequently sends the aligned
   fibre to determinant `-3`, not determinant `5`.  The cited conference
   design parameter is translated consistently to
   `3-(2d,4,(d-3)/2)`.  No sign swap appears in this bridge.

No false statement, proof gap, citation overreach, normalization ambiguity,
or material exposition defect was found on the assigned surface.

## Supplement check

Only the permitted standalone supplement was inspected after freezing the
PDF judgment: `sections/05-golden-operator.tex` and the paper-local
`orientation_source` certificate, checker, hash manifest, and independent
replay.

- The TeX source agrees with the rendered table and prose.
- The certificate records the same conference matrix, triangle coefficients,
  six coefficient words, exchanger permutation, and representative switches.
- The generator independently derives the words and compares all six with the
  manuscript; the replay independently recomputes them, singles out
  `words[2] == "+-+-+---++--+++-+-+-"`, verifies column balance, and checks
  that exchanger transport sends `C` to `-C` and every triangle coefficient
  to its negative.
- All three recorded SHA-256 checks passed, the tracked certificate passed its
  staleness check, and the independent replay returned `PASS`.

The supplement corroborated the frozen PDF judgment and changed no finding.

## Focused theorem package and contribution

On the assigned surface, the causal chain is complete: the marked order-six
conference representative fixes twenty triangle signs; parity-twisted
permutation transport produces the six outer cubics with exact normalization;
the four-cycle identity partitions four-sets into `w=3` and `w=-1`; and
`det C[K]=3-2w(K)` identifies the former, explicitly renamed `aligned`, with
the determinant-`-3` conference-design fibre.  Relative to the assigned
packet, the contribution is the fully signed, reproducible outer Joubert
frame together with a convention-clean bridge from its local four-set
invariant to the standard conference design.

The assigned surface meets the stated cross-field readability bar: local
terminology is translated at introduction, every action and coefficient order
is printed, and the cited design is attached to the correct determinant
fibre.  This deliberately focused audit does not independently determine the
whole article's significance bar.

## Unresolved findings

None on the frozen PDF pass.

The supplement introduced no unresolved finding.  No issue remains within
the assigned scope; whole-article claims outside that scope were not assessed.
