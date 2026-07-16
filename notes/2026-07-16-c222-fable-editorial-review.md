# C222 — Fable editorial review and disposition

**Lane:** `clebsch`

**Date:** 2026-07-16

## Fresh-reader review

The following review was supplied by the author after a fresh Fable read of the current manuscript.

> **Exposition — B (unchanged, one small regression).** All prior issues stand: dense abstract,
> terminology proliferation for `U(A)`, “chirality” overpromising relative to what Proposition 5.3
> proves, “secant index” defined mid-statement. The Proposition 6.5 proof is now more correct but
> also more cluttered: it interleaves the mathematical argument with two verification-artifact
> citations (a Python script and a Lean file) inside the proof body, which mixes registers even more
> than before.
>
> **Resolved since the prior copy (no action needed):** the all-characteristics validity of the
> `H3` ledger in Proposition 6.5, and the empty kernel-checked cell for the arrangement synthesis.
>
> **Still outstanding from the prior copy:**
>
> - Rewrite the abstract around the single main theorem before the cascade of secondary claims;
>   fix “maximumdistance.”
> - Standardize one name/symbol for the deep-hole locus (suggest `U(A)`, “uncovered locus,” with the
>   coding synonym stated once).
> - Reconsider “chirality”: Proposition 5.3 itself concedes neither class has a canonical sign, so
>   “invariant support bipartition” is the accurate name. If kept, define it before Section 5.
> - Lemma 4.2: add the one-sentence justification that chords through distinct vertex pairs meet
>   the disjoint line at distinct points, so the `K5` chromatic-index argument applies.
> - Proposition 3.1: the ledger table asserts fixed-point counts for `A4`, `D5`, `S3`, `V4` without
>   argument (only the cyclic cases are derived from eigenvalues); add a line each or a pointer.
> - Remark 4.6: exhibit the genus-three quartic and the class realizing it, or cite the specific
>   certificate.
> - Remark 4.1: cite the source of the `{18,19,20,22}` claim for conic-inscribed six-arcs.
> - Theorem 4.3: expand the two-sentence description of the frame-normalization/class-key scheme,
>   since the numerical clause depends on it.
> - Add a data/code availability statement with the repository location for
>   `lean/RelativeConicArcs/` and the scripts. This remains the single highest-value addition given
>   how much Tables 1–2 carry.
> - Table 3’s exponent notation is mangling in production; define `m^r` in the caption and check the
>   typesetting.
> - Unify chord/secant/edge/join terminology for the fifteen lines.
> - Verify references [11] (page range 33–45 looks short for that survey) and [5] (page 336 pinpoint).
>
> **New, specific to this revision:**
>
> - Proposition 6.5, proof: move both verification citations
>   (`check_reflection_arrangements.py`, `ReflectionArrangements.lean`) out of the proof body into a
>   footnote or a pointer to Section 7 — the mathematical argument now stands on its own and reads
>   better without them. Apply the same convention paper-wide.
> - The phrase “twice a unit” deserves one clarifying clause: state that the determinants equal
>   `2u` with `u in Z[tau]^x`, and that any specialization to a field containing `tau` with
>   characteristic not two sends this to a nonzero element.
> - “the lattice-faithful but nonsemisimple characteristic-five reduction” is a load-bearing aside
>   (`F5` is one of the two exceptional fields) delivered in nine words. Since
>   `ReflectionArrangements.lean` now checks the `F5` spectrum, say in one or two sentences what
>   fails semisimply at five and why the intersection lattice nevertheless survives.
> - Table 1: with the `A3/H3` row filled, the two remaining dashes now stand out. Add a footnote to
>   the table explaining why those two results are covered by executable checks only.
> - Conclusion: the new sentence is fine but slightly repeats Section 6.1’s closing paragraph
>   (“the arrangements organize... the separate geometry that makes the complements nonsingular
>   conics”). Consider trimming one of the two.

## Editorial assessment and disposition

The review identifies a worthwhile accessibility pass without changing the theorem structure.

### Apply now

- shorten the abstract after its already-clear main theorem and replace the unexplained abstract
  use of “chirality” by “an invariant unordered bipartition of leader supports”;
- make `U(A)` / “uncovered locus” the primary term after the coding dictionary, define secant index
  before its proposition, and state the contextual chord/secant/edge/join convention;
- add the missing collision sentence in the disjoint-line case of Lemma 4.2;
- clarify how the noncyclic subgroup fixed-point entries in Proposition 3.1 are obtained;
- give direct verification pointers for the conic-inscribed count and the genus-three quartic;
- expand the frame-normalization and canonical-class-key description;
- move verification filenames out of the Proposition 6.5 proof and into the verification section;
- spell out the `2u` specialization argument;
- replace the potentially ambiguous “nonsemisimple representation” wording by the precise fact
  that characteristic five divides the reflection group order, so Maschke’s semisimplicity
  guarantee fails, while direct coordinates retain the full lattice;
- explain the intentionally executable-only dashes in the formalization table; and
- correct Ball--Lavrauw to pages 133--172 and add DOI `10.4171/EMSS/33`.

### Defer or decline

- “maximumdistance” is a text-extraction artifact; the TeX source already has
  “maximum-distance.”
- Table 3 already defines `m^r` in its caption and the current PDF/log show no production defect.
- The conclusion callback was deliberately added after a separate cold read and is not excessive.
- A public data/code URL is gated on C182, the immutable archive task. Do not invent a local-only or
  placeholder URL; add the final availability statement when the DOI exists.
- Clebsch’s article metadata are correct, and the page-336 mathematical pinpoint remains in the
  final primary-scan audit rather than being changed from suspicion alone.

The [official EMS record](https://ems.press/journals/emss/articles/16705) confirms that
Ball--Lavrauw occupies pages 133--172, not 33--45. The
[EuDML record](https://eudml.org/doc/156535) confirms the Clebsch article’s bibliographic range
284--345.

## Post-edit cold read

An independent sub-agent found no structural or theorem-level blocker. Its small corrections were
applied: the abstract now credits the necessary small-field exclusions; the subgroup ledger uses
common projective eigenlines rather than “fixed eigenspaces”; the terminology convention includes
“join”; the characteristic-five paragraph names the reflection group `W(H3)`; and the executable
table no longer attributes the rigidity checker to the `A5` orbit ledger. The introduction now also
states explicitly that the frame-normalized replay is independent of Sadeh’s thesis.

## Final small-items follow-up

Fable's final pass found no structural issue and isolated five production-level nits. They were
handled as follows:

- the misleading `c12` suffix was removed from the Singular source and fail-closed wrapper, both of
  which cover C02, C04, and C12;
- Table 2 now says explicitly that it is organized by replay rather than row-for-row with Table 1,
  and the duplicate rigidity-checker entry was consolidated into its syndrome-and-census row;
- Remark 4.1 now names clause (iii) of Theorem 4.3 below rather than using a bare forward `(iii)`;
- the repeated arrangement-versus-conic sentence at the end of Section 6.1 was reduced to the
  factorization conclusion; and
- a disabled C182 data-and-code-availability paragraph now sits at the start of Section 7, ready
  to activate once the immutable DOI exists.

The two remaining uses of “projective deep-hole syndrome locus” are deliberate coding-register
uses, not competing primary terminology: the manuscript otherwise standardizes on `U(A)` and
“uncovered locus.” The Clebsch page-336 pinpoint remains assigned to the final primary-scan audit.
