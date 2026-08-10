# C902 Paper III cheap-upgrade red-team report

Date: 2026-08-09

This is a sequence of competence-separated adversarial passes by the C902
auditor.  It is not an external human review and does not satisfy either open
C894 safeguard.

## Pass 1: algebra and hypothesis audit

**Recognition theorem.**  Re-expanded the translation coefficient and checked
that it is `a_ij(A^2)_ij`, with no missing factor that affects vanishing.
Checked that the commutation step uses every off-diagonal entry being nonzero.
The theorem must require nonzero proportionality, because a vanishing
Pfaffian shadow otherwise creates false positives.  The degree comparison must
be included explicitly; it is what forces `n=6`.  The safe base field for the
stated nonzero scalar is a subfield of the reals.  Over a general field one may
conclude only `A^2=lambda I` without asserting `lambda != 0` absent an extra
hypothesis.

**Sign classification.**  Root switching reduces the five remaining vertices
to a 2-regular graph, necessarily a 5-cycle.  The ratio signs `+4` and `-4`
encode the two relative orientation classes.  Global matrix negation is not an
explanation for the two ratios: it changes both cubic shadows by the same sign.

**Determinant norm.**  Recomputed `(2 sqrt(5))^6=64*125=8000`.  For two
three-dimensional blocks, the block-determinant sign is positive.  The result
is a determinant-line norm until bases are selected; scalar wording must retain
that qualification.

**Spectral compatibility.**  `Q[C]=Q[-C]` is literal equality of generated
unital subalgebras.  It does not identify the marked generators and does not
turn deck exchange into the identity.

Outcome: packets A--C survive after the field and marking qualifications above.

## Pass 2: literature and novelty audit

The recognition search found neighboring conference-matrix, two-graph,
principal-minor, and zero-diagonal orthogonal-matrix literature, but no exact
predecessor.  That negative result is not publication-grade: MathSciNet review
text, Scopus, Google Scholar, and some Seidel survey material were not covered,
and one inherited forward-citation branch was incomplete.  All novelty and
priority adjectives are therefore forbidden.  “We prove” is sufficient.

The cyclic-cover, determinant-line, Gaunt, and generated-algebra observations
are standard mechanisms or interpretations.  None should be sold as a new
theorem merely because it helps exposition.

Candidate 6 remains blocked by its own stronger safeguards.  The C902 search
does not substitute for the institutional tournament-square/lattice query or
the external finite-geometry/character-sum specialist.

Outcome: candidate 2 survives without novelty language; candidates 3 and 4
survive only as exposition; candidate 6 remains deferred.

## Pass 3: architecture, marking, and claim-inventory audit

The Paper III first-pass route is source, shadow, then return.  The converse
recognition theorem belongs directly after the existing operator-shadow
theorem, where it reads as a converse rather than as a new front-loaded topic.
It needs no new figure and no abstract sentence.

The norm paragraph belongs inside the existing “Why determinant” discussion
and should retain the permanent counterexample.  A separate proposition would
flatten the section into a theorem inventory.

The compatibility observation belongs immediately after the existing sentence
that deck exchange changes `C` and `Z_C` to their negatives.  It must mention
both halves of the distinction: unchanged unmarked algebra, changed marked
generator.  A bare sentence `Q[C]=Q[-C]` would risk a marking regression.

The already-landed conductor, discoverability, and portfolio items should not
be duplicated.  The existing Gaunt paragraph is already the right rhetorical
weight.  No second figure, abstract expansion, new section, or rearrangement of
the paper's source--shadow--return path is warranted.

Outcome: one theorem, one replacement paragraph, and one sentence survive.

## Pass 4: exact-claim and mirror-safety audit

Checked each survivor against the current Paper III source and the C809/C862
proof authority:

- The recognition statement does not claim the weighted converse beyond
  `A^2=lambda I`, does not absorb the zero-support locus, and does not imply a
  local deformation theorem.
- The norm statement preserves the determinant-line type and makes the
  trivialization-dependent sign explicit.
- The spectral sentence preserves deck exchange and the relative marking.
- No recommendation alters the cover theorem, the four-shadow inventory, the
  principal-minor reconstruction boundary, or the Gaunt multiplicity-one
  explanation.

The eventual integration must be made once in the canonical Paper III source,
then propagated through the repository's normal mirror/export process by the
owning lane.  C902 deliberately edits neither source nor mirror, avoiding a
split authority.

Outcome: all three survivors are safe recommendations at their stated scope.

## Final red-team disposition

| Candidate | Final disposition |
|---|---|
| 1 | Already landed; no-op |
| 2 | Survives as one narrowed theorem |
| 3 | Survives as one unnumbered replacement paragraph |
| 4 | Survives as one marking-aware sentence |
| 5 | Already landed; no-op |
| 6 | Deferred; safeguards open |
| 7 | Proposition promotion rejected |
| 8 | Already landed; no-op |

The recommendation set is intentionally smaller than the candidate set.  No
manuscript wording outside candidates 2--4 survives.
