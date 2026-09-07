# Cubic pair: exposition and notation after the extensions

**Lane:** `cubic-threefolds`
**Owners:** C978 and C956; both remain open by author instruction.

## Purpose

Preserve the original cubic headlines while making the upgraded papers
readable across the quantum/birational interface. The author explicitly
requires a terminology and symbol audit and, after drafting, the full-paper
cold-read sub-referee protocol on both papers. Earlier cold reads do not
review these revised drafts. Email remains deferred through that cycle.

## One-stabilization paper

- The abstract now leads with the cubic theorem and the dimension-four
  blowup mechanism. Detailed nilpotent/residue hypotheses are introduced in
  the body; the Grothendieck-group extension has one concluding sentence.
- Immediately after the main theorem, a short reduction displays values
  1,2,0, the occurrence-indexed blowup formula, low-dimensional vanishing,
  and the dimension-five boundary. This is an overview of the existing
  proof, not a replacement for the coefficient comparison.
- The introduction defines genericity in quantum parameters explicitly,
  distinguishes it from generality in cubic moduli, and leaves secondary
  corollaries beside their proofs in the consequences section. All five
  corollary statements and their scope are retained.
- A concrete 2-by-2 calculation explains the canonical modification,
  its residue, the role of A1 and the integer shift before the abstract
  lattice definition. Resonant and nonresonant pairs are contrasted.
- The block definition distinguishes whole primary spectral summands from
  individual Jordan blocks. The unused groupoid notation and its table row
  are replaced by finite multisets of regular-isomorphism classes.
- The small-to-generic bridge explicitly points to the cyclic-centralizer
  persistence proof before using the computed small residue generically.

Terminology and symbols:

- "Exponent count" denotes the particular numerical construction; "additive
  invariant" denotes the general monoid-valued assignment. Printed "marker"
  vocabulary is removed, while stable source labels and Lean names remain.
- "Marked" is replaced by "counted" where no extra marking is involved.
  The unneeded reference to a loop framing is removed from the definition.
- K_Y remains the generic coefficient field. The cubic Euler matrix is U_X,
  its grading term D_X, and a regular gauge is G(z). Solutions use y; the
  elementary-modification matrix keeps S=diag(1,z).
- The cubic rank-two coefficients are N,A0,A1, matching the general local
  model instead of requiring translation from J0,D0,E0.
- Standard terms such as primary summand, formal exponents, elementary
  modification, regular singular connection and Lax equation are retained
  with their mathematical definitions. No new mathematical claim is inferred
  from a vocabulary change.

The six affected statement records were reviewed against unchanged terminal
scopes and refreshed explicitly: cor:threefold-marker, thm:marker-ledger,
prop:qdm-operation-ledgers, prop:cubic-block-data,
prop:hodge-marker-separation, cor:factorization-spectrum. Their changes are
terminology or matrix-symbol substitutions, not hypotheses or conclusions.
No Lean source or terminal signature is changed.

## Sharpness paper

- The abstract and headline cubic statements remain focused on exact level
  two and the surface upper bound. The finite-index extension stays after
  the main proofs and consequences.
- The introductory strategy displays the two descriptions of Z/T3 together
  and records dimensions 7,5,3. This exposes why the remaining rational
  factor has dimension two.
- The effective rank-one action illustrating index d is moved before the
  quotient theorem. It explains uniqueness before the cofactor calculation.
- The quotient proof separates orbit intersection/descent from rationality
  of the section, retaining the complete hypotheses and inverse identities.
- The descent discussion begins by distinguishing nonempty geometric
  conditions from particular coordinate witnesses descending individually.
- The certificate appendix explains uniformity in surface parameters and
  walks through the role of the first row's points, Jacobian, evaluation
  determinant and smoothness minor.
- "Limits of the Cox-weight criterion" replaces the heading that could
  suggest a rank-four construction had actually been achieved.

The sharpness statement bodies, geometric hypotheses and certificate inputs
are unchanged in this exposition pass. The standard vocabulary of saturated
sublattices, affine projective-weight actions, slices, tangent projection,
isogenies and Rosenlicht quotients is retained. The descent and tangent
hypotheses remain in the main text.

## Review and validation status

Both final authority `make check` gates pass. The m=1 PDF has 18 pages;
the sharpness PDF has 17. Rendered inspection covered the m=1 opening,
local matrix model and cubic calculation, and the sharpness quotient
overview and certificate walkthrough. No clipping or notation-rendering
defect was found on these pages.

- m=1 gate: `/tmp/claude-run-quiet/20260907-163455-make-C-cubic-stabilization-m1-check/`.
- Sharpness gate: `/tmp/claude-run-quiet/20260907-164002-make-C-cubic-stabilization-irrationality-check/`.
- m=1 PDF SHA-256: `a4d957b8acd89b49bf73e46ddd4b625b2356123f81e900a4ce74763ab6e4b395`.
- Sharpness PDF SHA-256: `c097d691430810c1c0bafc7b31e1754fc429f3f6c3e8fbd8dca87e6c393532b7`.

Mirror provenance will be recorded after guarded synchronization. No
cold-read acceptance is claimed here.
The location of the governing sub-referee protocol has been requested from
the author while drafting continues; prior review reports were located but
not the governing instructions.

## Mystery ledger — ej + tt

This pass does not introduce a new research claim. The useful post-upgrade
check is that increased scope need not enlarge the main proof path: the
birational reduction and quotient construction remain complete before the
extensions begin. The symbol audit also removed an actual ambiguity between
the coefficient field and the cubic Euler matrix, and between connection
matrices and gauges. Full-paper cold readers still need to test whether the
resulting first-reading route works for its intended audiences.
