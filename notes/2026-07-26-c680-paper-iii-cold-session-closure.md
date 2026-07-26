# C680 Paper III cold-session closure brief

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Paper:** `papers/clebsch-passages/`  
**Entering verdict:** `NO-GO` for submission  
**Status:** queued

## Authority and cold-session startup

This brief supersedes the release verdict in
`notes/2026-07-26-c670-paper-iii-independent-release-review.md`. C670
completed the subtractive two-theorem cut, but a later PDF-only cold read
and an isolated-package audit found gaps that its release review missed.

A cold session should:

1. read `AGENTS.md` in the required dedicated command;
2. route `C680` through the live queue and Clebsch handoff;
3. read `papers/style-guide.md`;
4. read this brief in full;
5. inspect only the current Paper III source, its verification directory,
   and the retained sources or formal records named below.

Do not preload the earlier candidate reports. Consult C669 only for a
specific attribution or novelty boundary, and C664 only if deciding whether
to advertise partial Lean support.

## Goal

Close Paper III at four levels:

1. define the Clebsch chart and complete the rational square-class/fibre
   proof at scheme level;
2. make the verification bundle genuinely paper-local and free of deleted
   mathematical branches or workflow identifiers;
3. restore exact statement-to-ledger correspondence and state the Lean
   coverage boundary explicitly; and
4. bring the novelty wording within the recorded literature audit before a
   new context-free PDF-only review.

The harmonic normalization itself is not entering work. Two independent
cold readers accepted \(G=K/13\), its spectrum, the displayed axes, and the
coefficient \(-784000/1247103\); the later reader also reconstructed the
quadratic moment \(2800/351\) from the PDF.

## Blocking mathematical gaps

### 1. The Clebsch inclusion is undefined

`sections/01-introduction.tex` defines
\[
V=\{(y_1,\ldots,y_5):\sum_i y_i=0\}
\]
and then uses \(J_0|_V\), \(D(\sigma_3)\subset\mathbf P(V)\), and the point
\(xyz\) without defining the map \(V\hookrightarrow H\).

Required closure:

- give the exact linear inclusion of the Clebsch four-space into the
  seven-space of harmonic cubics, including the quadratic form,
  polarization, and normalization conventions needed to interpret it;
- identify the parameter corresponding to \(xyz\);
- state whether the inclusion is defined over \(\mathbf Q\) and how the
  \(A_5\)-action on the five coordinates matches Hitchin's action on \(H\);
- cite the exact source location for every imported identification; and
- make \(J_0|_V=16\sigma_3^2\) a well-typed equality rather than notation
  whose map is left implicit.

### 2. The constant-\(5\) fibre step lacks a local comparison theorem

`sections/02-orientation-cover.tex` passes from the generic square class
\[
K(\sqrt{cJ_0})
\]
to the residue algebra of the \(xyz\)-fibre without proving that this
generic normalization agrees locally with the geometric incidence model at
that point.

Required closure:

- state the rational descent or rational equations defining the incidence
  variety used in the proof;
- identify an open neighborhood of \(xyz\) on which the normalization is a
  finite etale double cover;
- prove or cite that Hitchin's two golden configurations are the complete
  reduced scheme-theoretic fibre there, with residue algebra
  \(\mathbf Q(\sqrt5)\);
- explain why specializing \(d=cJ_0g^2\) at the point is legitimate,
  including the local trivialization of the degree-six line bundle and the
  fact that the square factor is a unit; and
- only then conclude that \(c=5\) in
  \(\mathbf Q^\times/\mathbf Q^{\times2}\).

If the available sources or equations do not close this comparison, weaken
the theorem. Do not bridge the gap by calling the two displayed
configurations “the fibre” without the local normalization argument.

### 3. Submission metadata remains explicitly incomplete

`sections/08-verification.tex` says that an immutable archive identifier is
required and “will be added.” The title page also lacks the author's chosen
affiliation/contact metadata.

Required closure:

- insert a real immutable artifact locator before any submission-ready
  verdict; and
- obtain the author's intended affiliation/contact line rather than
  inventing it.

Local mathematical and package repairs may proceed while those
user-controlled inputs are unavailable, but the final verdict must remain
`NO-GO FOR SUBMISSION` until they are supplied.

## Verification-package detritus

The current aggregate passes only inside the full private repository. An
isolated copy of `papers/clebsch-passages/` passes statement identity,
manifest structure, and arithmetic checksums, then fails because
`verification/evidence/arithmetic_cover.py` imports
`notes/2026-07-22-c470-golay-hadamard-automorphisms.json`.

The arithmetic bundle still contains deleted Mathieu/Hadamard,
marked-carrier, \(M_4/M_8\), and task-ID material. The release directory
also retains the unused
`klein_relative_position.py`, replay, JSON, and checksum bundle.

Required cleanup:

1. reduce `arithmetic_cover.py`, its independent replay, certificate, and
   checksum to the displayed golden configurations, exchanger, reflection
   decomposition, and nonsquare spinor class actually used by Paper III;
2. remove every dependency on `notes/`, C-task identifiers, Mathieu
   carriers, marked compatibility, and deleted matching geometry;
3. delete the unused Klein bundle from the Paper III release root;
4. update verification prose so it describes exactly the reduced bundle;
5. remove obsolete “orientation bridge” and “harmonic bridge” names where
   they imply a deleted theorem;
6. either remove `WORKPLAN.md` from the public release root or replace it
   with a stable scholarly-facing artifact description and define a
   packaging allowlist; and
7. remove unused TeX macros, theorem environments, and packages after the
   mathematical source stabilizes.

The isolated-package gate must run from a temporary tree containing only the
declared release files. A suitable negative-to-positive regression is:

```text
audit_root=$(mktemp -d)
mkdir -p "$audit_root/papers"
cp -a papers/clebsch-passages "$audit_root/papers/"
python3 "$audit_root/papers/clebsch-passages/verification/verify_release.py"
```

This command must pass without copying `notes/`, `lean/`, or any other
repository subtree.

## Trust-ledger and Lean closure

### Statement correspondence

`verification/verify_scaffold.py` currently validates claim syntax and bans
manuscript-facing `\claimid` tokens, but it no longer maps trust rows to the
four frozen theorem labels. Equal row and statement counts do not establish
correspondence.

Required closure:

- add stable theorem-label fields to the trust rows;
- verify that every label in `statement_identity.json` is covered by at
  least one row and that every referenced label exists;
- permit deliberate row overlap only when the row states which clause it
  covers; and
- reject a manifest whose prose, evidence route, or proof modes drift from
  the frozen theorem.

The public manifest should not use `owner: C...` workflow identifiers.
Replace them with scholarly proof/evidence roles or keep ownership only in
internal notes outside the release package.

### Formal coverage

The current paper makes no Lean claim, and that is honest. Existing Lean
closes only two symbolic mechanisms:

- `RelativeConicArcs.InvolutiveOddUnit` proves the localized involutive
  splitting; and
- `RelativeConicArcs.KneserPairEigenspace.standardEquivPetersenNegTwo` and
  `finrank_petersenNegTwoEigenspace` prove the abstract pair-sum/Petersen
  eigenspace statement.

Their import-only gate is
`RelativeConicArcs.Gates.ClebschOrientationMechanisms`; C664 records its
green axiom audit. The modules have not changed since that record.

Lean does not close the Clebsch inclusion into harmonic cubics, the
\(5J_0\) square class, local fibre comparison, spinor specialization,
face-axis geometry, spherical moments, or Gaunt coefficient.

C680 should choose one of two honest dispositions:

1. keep Lean outside the Paper III release dependency and add an explicit
   `formal_coverage: none claimed` boundary to the manifest; or
2. cite the exact Kneser declarations only for the abstract pair-module
   clause after adding a precise paper-to-Lean correspondence, immutable
   Lean artifact locator, gate result, and axiom statement.

Do not run or edit Lean merely to make the paper look more formal. A new
Lean build is required only if C680 changes the formal coverage claim or a
formal source.

## Literature and novelty boundary

The current eight-item bibliography is internally consistent: every item is
cited, every citation resolves, and C669 records read depth for all eight
sources. The retained attribution boundary is:

- Hitchin owns the degree-two incidence cover, branch sextic, Clebsch
  restriction, and golden configurations;
- Mukai--Umemura own the underlying threefold, but the full original text
  was not reached and no load-bearing formula may be attributed to it;
- Dye owns the square-\(5\) finite-field existence criterion;
- Steinhardt--Nelson--Ronchetti own the standard degree-six bond-order
  invariant; and
- DLMF supplies the Gaunt/\(3j\) formula and normalization.

The sentence “The harmonic theorem is new” is not licensed. C669's negative
covered only the former combined arithmetic--finite--harmonic bridge, which
C670 deleted. C669 explicitly did not license unqualified novelty of the
component constructions.

Required closure:

- delete the word “new” and state only the mathematical independence and
  exact result; or
- perform a new targeted literature audit of the standalone face-axis
  Petersen/Gaunt theorem under
  `notes/literature-audit-conventions.md`, including read depths, screened
  sets, access gaps, and qualified wording.

The cheap and preferred disposition is deletion. Do not broaden the
bibliography merely to defend an unnecessary priority adjective.

Also revise the Mukai--Umemura sentence so the unread source is credited
only for the threefold's origin; use Hitchin for the incidence construction
and every load-bearing formula.

## Stale records to repair

- `papers/clebsch-passages/WORKPLAN.md` still says C670 is in progress.
- The live Clebsch handoff still contains the superseded
  “seven-statement, nine-row” and “C670 owns the independent release gate”
  sentences.
- `notes/2026-07-26-c670-paper-iii-independent-release-review.md` states
  that no retained route depends outside the release package; the isolated
  replay disproves that statement. Preserve it as the C670 historical
  verdict, but make this C680 brief and the live handoff authoritative.

## Allowed paths

C680 owns:

- `papers/clebsch-passages/`;
- this report;
- the Clebsch live handoff and its companion archive if history must move;
- the exact C680 live queue row and eventual lifecycle archive row.

Treat all Lean sources, other paper roots, the mega-paper fallback, and
other lanes as read-only unless the user explicitly expands scope.

## Cold-session execution order

1. Snapshot the four current theorem statements and trust rows.
2. Define and source the Clebsch inclusion \(V\hookrightarrow H\).
3. Prove the local normalization/fibre comparison or weaken the arithmetic
   theorem.
4. Remove the unlicensed novelty sentence.
5. Strip the arithmetic bundle to paper-owned claims and delete unused
   Klein/Mathieu artifacts.
6. Add statement-label correspondence and an explicit formal-coverage
   boundary to the trust manifest and checker.
7. Clean stale workflow prose, unused TeX declarations, and release-root
   packaging.
8. Regenerate certificates, checksums, statement identity, manifest, PDF,
   and artifact documentation.
9. Run the ordinary aggregate and the isolated-package aggregate.
10. Inspect the rendered PDF, including author metadata and the absence of
    placeholders.
11. Obtain a fresh context-free PDF-only referee read that receives no C670
    or C680 feedback.

## Acceptance gates

C680 closes only when:

- the Clebsch inclusion and \(xyz\) parameter are explicit;
- the local fibre argument is scheme-theoretically valid or the theorem is
  weakened to exactly what is proved;
- no release-critical script reads outside the declared package;
- no deleted Klein, Mathieu, finite matching, task-ID, or workflow branch
  remains in the public artifact;
- every frozen statement is mapped to an exact trust row;
- every row states its conceptual, classical, certificate, replay, and
  formal boundary accurately;
- the novelty wording is licensed by C669 or a new conforming audit;
- ordinary and isolated release replays both pass;
- the PDF is warning-free and contains no placeholder;
- a fresh PDF-only reviewer returns `GO`; and
- the immutable locator and author metadata are present before the verdict
  is called submission-ready.

## Entering mystery ledger

| feature | status | closure gate |
|---|---|---|
| factor-\(13\) Gram normalization | settled | preserve \(G=K/13\) and exact replay |
| Clebsch chart inside \(H\) | open blocker | explicit rational inclusion and normalization |
| extraction of \(c=5\) from one fibre | open blocker | local normalization and complete reduced fibre |
| artifact self-containment | open blocker | isolated-package replay |
| statement-to-ledger identity | open blocker | label-level manifest validation |
| Lean coverage | bounded but implicit | explicit no-claim or exact partial correspondence |
| standalone harmonic novelty | unsupported wording | delete “new” or run targeted audit |
| immutable locator and author metadata | external blocker | user-supplied submission data |

Vibe check: the harmonic half is healthy and the arithmetic result still
looks worth saving, but the next session must treat the scheme-theoretic
fibre and release-package isolation as proof obligations, not editorial
polish.
