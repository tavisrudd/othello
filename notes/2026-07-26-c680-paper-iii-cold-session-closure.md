# C680 Paper III cold-session closure brief

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Paper:** `papers/clebsch-passages/`  
**Entering verdict:** `NO-GO` for submission  
**Status:** local mathematical and package closure complete; submission and
fresh-review gates remain open

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

## 2026-07-26 local closure result

The entering rational Clebsch-chart statement was false as written.  For
the standard rational harmonic space, the vanishing four-space of the
golden icosahedron is defined over
\(E=\mathbf Q(\sqrt5)\); Galois conjugation carries it to the distinct
vanishing four-space of the conjugate icosahedron.  The manuscript now
defines
\[
 V_t=\{p\in H_E:p(a)=0\text{ for every }[a]\in I_t\}
\]
and the exact \(A_5\)-equivariant coordinate map
\(\iota_t(y)=\sum_i y_iq_i\).  It identifies
\(xyz\) with \((4,-1,-1,-1,-1)/5\), obtains
\(\sigma_3=4/25\), and records
\(J_0(xyz)=(16/25)^2\).  The main theorem no longer calls this a
\(\mathbf Q\)-defined restriction or a rational constant torsor.

The global square-class theorem survives.  The paper now gives rational
equations for Hitchin's Grassmannian incidence model, shrinks the proper
incidence morphism to a finite neighborhood of \([xyz]\), identifies it
with the normalization in the quadratic generic field, and uses
\(J_0(xyz)\ne0\) to reach the finite etale locus.  Hitchin's two distinct
golden configurations are consequently the complete reduced
scheme-theoretic fibre with residue algebra \(\mathbf Q(\sqrt5)\); a local
generator of \(\mathcal O(3)\) makes the square-unit specialization step
explicit and yields \(c=5\).
An `ej` closeout records the conceptual dividend in the introduction:
the factor \(5\) is precisely the descent obstruction to choosing one of
the two conjugate icosahedral parents (or its Clebsch chart) over
\(\mathbf Q\).  This is an interpretation of the proved fibre, not a new
claim or evidence route.
A subsequent `tt` field-of-definition audit caught the symmetric danger in
the harmonic half: the Petersen coefficient module is rational, but the
displayed zonal embedding uses golden face axes.  The abstract's unsupported
“rational Clebsch four-space” adjective is removed, and the harmonic section
now says exactly that conjugation changes the embedded configuration while
preserving the abstract Petersen incidence and formulas after relabeling.
No rational descent of that displayed embedding is claimed.
The same `tt` pass removes the apparent numerology of the \(q=11\)
sentence.  The reflection proof already works over every odd finite field
of characteristic other than \(5\) in which \(5\) is a square: the
exchanger has spinor class \([2]\), and it lies outside the special
projective subgroup exactly when \(2\) is nonsquare.  The paper now states
this uniform proposition and retains \(q=11\) as the certified
nontrivial specialization; no new computational route is required.
The ensuing `ej` pass isolates the reusable finite-field classification:
\([5]\) governs rationality of the two parents, whereas \([2]\) governs
whether the exchanger lies in the special projective subgroup.  These are
independent arithmetic controls; Dye's Clebsch-hexagon existence theorem
shares the first boundary.  This replaces an isolated numerical
specialization by a structural consequence without changing the trust
surface.
The `tt2` pass then closes the natural geometry question rather than
leaving it for a later version.  The two conjugate golden icosahedra share
no axis, so Hitchin's Proposition 7 gives
\[
 V_t\cap V_{1-t}=E\cdot xyz.
\]
Their reduced union is therefore a \(\mathbf Q\)-descended pair of
conjugate projective three-spaces meeting only at the rational point
\([xyz]\).  This supplies the exact rational geometric object that replaces
the false rational single-chart claim; it is a human consequence of the
primary source and adds no computational dependency.
The `tt3` pass extracts the normalization concealed in this union.  If
\(Z\) denotes its \(\mathbf Q\)-descent, then the normalization of \(Z\)
is \(\mathbf P(V_t)\) viewed over \(\mathbf Q\) through
\(\Spec E\to\Spec\mathbf Q\); after base change it separates the two
conjugate branches, and
\[
 \nu^{-1}([xyz])=\Spec E.
\]
Thus the golden residue algebra is already visible in a nonsplit
two-branch \(\mathbf Q\)-model.  The manuscript states explicitly that this
model explains the descent geometry but does not replace the independent
local comparison with Hitchin's incidence scheme.

The deeper continuation closes the three questions explicitly.

1. Stein factorization of the normal incidence scheme gives its finite
   normalization \(\mathcal N\).  For the fixed parent \(I_t\), polarization
   identifies \(V_t=U_t^\perp\), so the chart has a tautological
   fixed-parent section.  The conjugate sections descend to
   \(Z^\nu\to\mathcal I\to\mathcal N\), identifying \(\Spec E\) with the
   golden incidence fibre on the local finite-etale neighborhood.
2. The completed local ring is
   \[
   \widehat{\mathcal O}_{Z,[xyz]}
   =
   \frac{\mathbf Q[[a_1,a_2,a_3,b_1,b_2,b_3]]}
   {(a_i b_j-a_j b_i,\ b_i b_j-5a_i a_j)}.
   \]
   Its normalization is \(E[[x_1,x_2,x_3]]\), its conductor is the maximal
   ideal, and the normalization quotient is \(E/\mathbf Q\).  Thus \(5\)
   is intrinsically the splitting class of the completed two-branch model.
3. Two-transitivity on the five plane triples makes the commutant on the
   sum-zero module scalar.  Hence the abstract arithmetic-to-Petersen
   comparison is uniquely projective; it is
   \(y\mapsto(y_i+y_j)\), with inverse
   \(y_i=\frac13\sum_{j\ne i}a_{ij}\).  Preserving \(\sigma_3\) forces the
   scalar to be one over \(E\).  This is a canonical abstract comparison,
   not an ambient harmonic-space map.

The release artifact is now paper-local.  The arithmetic certificate was
reduced to the displayed golden configurations, all twenty three-point
determinants, the exchanger, its mod-\(11\) reduction, and the nonsquare
spinor representative.  The private Mathieu/Hadamard input, matching
matrices, marked carrier, and complete unused Klein bundle were removed.
`WORKPLAN.md` was replaced by `ARTIFACT.md`; `release_files.json` is the
27-file packaging allowlist; and a local `Makefile` lets the aggregate
build without the repository's parent `papers/Makefile`.

The four trust rows now name exact theorem labels and clause boundaries.
The frozen statement identity includes the complete trust-row prose,
proof-mode, and evidence-route snapshot and its SHA-256 digest.  The
manifest states `formal_coverage: none claimed`, has no workflow owner
fields, and records the two external submission blockers separately from
the green local release gate.  The aggregate rejects C-IDs, the superseded
programmatic paper name, and every `notes/` reference in packaged text.
The unlicensed word “new” and the manuscript's archive placeholder were
deleted.

### Reproducibility

Run from `papers/clebsch-passages/`:

```text
python3 verification/evidence/arithmetic_cover.py --check
python3 verification/evidence/arithmetic_cover_replay.py
sha256sum -c verification/evidence/arithmetic_cover.sha256
python3 verification/verify_release.py
```

The primary generator is deterministic and uses exact
\(\mathbf Q[t]/(t^2-t-1)\) arithmetic; the replay independently works
modulo \(11\).  The certificate does not check Hitchin's incidence degree,
branch divisor, local normalization comparison, or invariant restriction;
those remain human arguments from the cited primary source.

| file | bytes | SHA-256 |
|---|---:|---|
| `arithmetic_cover.py` | 6872 | `b3e3496f3b78de1881adcf71a90c0ab3d7c518867b66da15a6d5505185388bf4` |
| `arithmetic_cover_replay.py` | 2723 | `22f55a9c4b781bb028e64f4544c7dfa7145bb325cc49c0ee43fb256c2dc330a6` |
| `arithmetic_cover.json` | 1151 | `c0e338960cd0a12a7eab85a7f000847349327564142178af97a03a54aef23c41` |

The ordinary aggregate and a copy of the paper directory under a fresh
temporary root both pass all thirteen checks, including the warning-free
ten-page build.  Visual inspection of the title, chart/local-proof pages,
and harmonic-comparison page found no layout defect; PDF text contains no workflow identifier,
repository-note reference, stale paper name, or archive placeholder.

## Mystery ledger
## Fresh context-free PDF-only verdict

An ephemeral independent `gpt-5.6-sol` referee session at high reasoning
received only the regenerated PDF, its direct `pdftotext` extraction, and
ten direct page renders.  It received no repository source, prior report,
review feedback, or internet source.  The reviewed PDF has SHA-256
`4f303beeea42979abea013b01c5c907021519d18b5d859cd7b1816716e7e6b36`.

The referee returned `GO`, with no blocker and no material minor.  It found
the theorems coherent, the attribution and rational/integral/finite-field
boundaries explicit, the two Clebsch-module realizations properly
distinguished, and the exposition and page formatting submission-quality.

The same PDF-only metadata audit found:

- author name: Tavis Rudd;
- affiliation: missing;
- contact email: missing; and
- immutable artifact locator: missing.

Thus the fresh PDF gate is green, while submission readiness remains
`NO-GO` solely on the three missing user-controlled metadata fields.

## Requested grading and expanded-evidence review

The PDF-only grade pass assigned overall scientific and manuscript grades
of `B+`.  Its strongest marks were `A+` for scope discipline, `A` for
typesetting, and `A-` for theorem architecture, exposition, and the visible
trust boundary.  It assigned `B+` for significance, originality, rigor,
literature positioning, and specialist-journal readiness; `B` for
self-containedness; `B-` for broad-journal readiness; and `D` for missing
submission metadata.

A separate pass applying `papers/style-guide.md` returned `REVISE` and an
overall exposition grade of `B+`, with no submission-blocking expositional
finding.  Its five material-minor recommendations were to add a causal proof
roadmap, separate the finite-field specialization from the headline theorem,
consolidate repeated scope boundaries, gloss the disciplinary interfaces,
and regularize the configuration/sheet terminology.

The requested source-and-Lean expansion then found a mathematical defect
that the PDF-only verdict missed.  In
`sections/02-orientation-cover.tex`, the local argument at lines 188--212 is
sound after the standard branch-locus justification: proper plus
quasi-finite permits a finite neighborhood, normal finite birational models
agree, and the local generator of \(\mathcal O(3)\) makes specialization
legitimate.  But lines 168--186 write \(d/J_0\) as though the homogeneous
sextic \(J_0\) were already a rational function and incorrectly conclude
that the resulting divisor class is two-torsion.  The required repair is to
choose a rational section \(s\) of \(\mathcal O(3)\), set
\(j=J_0/s^2\in K^\times\), and run the square-class argument with \(j\);
equivalently, formulate the double cover through
\(\mathcal O\oplus\mathcal O(-3)\).

The expanded review therefore revised rigor from `B+` to `B`, architecture
and reproducibility from `A-` to `A`, kept the scientific grade at `B+`,
and revised the manuscript grade from `B+` to `B`.  The inspected Lean files
prove only the abstract involutive odd-unit splitting and the
four-dimensional Petersen \((-2)\)-eigenspace/pair-sum equivalence.  They do
not cover the incidence scheme, square class, local fibre comparison,
Clebsch charts, harmonic embedding, or spherical moments, exactly matching
the manifest's `formal_coverage: none claimed` boundary.

Accordingly, the fresh PDF-only `GO` remains an accurate record of that
blind review, but it no longer closes the mathematical release gate.
Submission is `NO-GO` pending the square-class repair, a refreshed PDF-only
review of the repaired bytes, the immutable locator, and affiliation/contact
metadata.


| feature | status | closure gate |
|---|---|---|
| factor-\(13\) Gram normalization | settled | preserve \(G=K/13\) and exact replay |
| Clebsch chart inside \(H\) | settled by correction and deep closeout | exact \(E\)-defined conjugate charts, intersection \(E\cdot xyz\), completed conductor model, and canonical map to the incidence normalization; no false rational inclusion |
| extraction of \(c=5\) from one fibre | reopened at the global square-class step | choose \(s\in\operatorname{Rat}\mathcal O(3)\), replace \(J_0\) by \(J_0/s^2\in K^\times\), and revalidate the local specialization |
| abstract arithmetic--harmonic comparison | settled | unique projective \(A_5\)-map; \(\sigma_3\)-normalization fixes the scalar; no ambient map claimed |
| artifact self-containment | settled | ordinary and isolated-package replay green |
| statement-to-ledger identity | settled | label/clause map and frozen row digest |
| Lean coverage | settled | explicit `none claimed` |
| standalone harmonic novelty | settled subtractively | unlicensed “new” deleted |
| immutable locator and author metadata | external blocker | user-supplied affiliation, contact email, and immutable artifact locator |
| fresh context-free PDF-only referee read | superseded as a release gate | independent `GO` on PDF SHA-256 `4f303beeea42979abea013b01c5c907021519d18b5d859cd7b1816716e7e6b36`, followed by source-aware discovery of the \(\mathcal O(6)\) trivialization defect |

Vibe check: the mathematical repair is stronger than the entering draft
because it discovered and removed a false descent claim while preserving
the global \(5J_0\) theorem.  The local artifact is now clean; the only
remaining gates require an independent reader and user-controlled
submission metadata.
