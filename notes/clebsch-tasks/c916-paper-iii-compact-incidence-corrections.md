# C916 — Paper III compact-incidence and Stein-normality corrections

**Lane:** `clebsch`

**Status:** complete 2026-08-17; all eight required edits applied and proved,
authority commit `3b8e2c11f`, standalone commit `584322b`, nothing pushed.
Report: `notes/2026-08-17-c916-paper-iii-compact-incidence-corrections.md`.
The immutable-locator item and the C876--C878 citation corrections were
excluded by author instruction, and Paper III's release aggregate remains red
only at the pre-existing "Paper III" README vocabulary gate, which is not this
task's to change.

## Objective

Apply the author-supplied referee/red-team correction specification to Paper
III, *Golden descent and operator realizations of the Clebsch cubic*
(`papers/clebsch-passages/`), prove the repaired steps to the manuscript's
printed strength, and forward-commit the result to the standalone repository
`~/src/math-papers/clebsch-passages`.

The mathematical content of the repair is small and already decided by the
specification.  The work is precision editing plus proof verification, not
redesign: the headline arithmetic theorem
\(\mathbf Q(\mathbf P(H))(\sqrt{5J_0})\), \(\mathcal O\oplus\mathcal O(-3)\),
\(z^2=5J_0\) is unchanged.  What is repaired is the conflation of a *compact*
incidence point (a possibly degenerate isotropic three-plane on the
Mukai--Umemura threefold) with a *regular* icosahedral six-axis configuration,
plus one missing height-one normality lemma in the Stein-algebra proof.

## Frozen inputs

- Correction specification, copied verbatim into the repository as
  `notes/2026-08-17-c916-paper-iii-correction-spec.md`; SHA-256
  `97a1ffe70e41971e663030e190bed5e9917e200f4d29cd06e262da0293c113b8`.
  Source of the copy: `/tmp/persistent/tavis/clebsch_opus_correction_spec.md`
  (not git-visible, so the committed copy is the authority).
- Target manuscript state: the 33-page authority PDF
  `papers/clebsch-passages/clebsch_passages.pdf`, SHA-256
  `16bde43e1820b1b9c5b15e6a1bdf1ace804aa80393f46285acf39c1d002306ba`, last
  rebuilt at authority commit `b19233879`.  The specification's page numbers
  refer to exactly this PDF; once pagination moves, use its exact search
  anchors instead.
- Upstream sources the patch may use, and only these: Hitchin,
  *Vector bundles and the icosahedron* (reference `[3]`), §§3--4, §6
  Proposition 2, §8.2, §8.3 Theorem 4, §9 Theorem 5; and Hitchin,
  *Spherical harmonics and the icosahedron* (reference `[2]`), the opening
  example and chart calculations.  No new bibliography item is added.

## Scope: the nine required edits

Anchors resolved against the current sources (line numbers will move; the
specification's exact search strings are authoritative):

1. §2.2 *A rational incidence model*, `sections/02-orientation-cover.tex` near
   the Mukai--Umemura identification — insert the compact degenerate boundary
   and Hitchin's degree-ten \(\Delta\) before the incidence scheme \(I\) is
   defined.
2. §2.3 *The reduced branch cycle*, `sections/02-orientation-cover.tex` —
   replace the regular-only quasi-finiteness argument by the compact
   trichotomy argument, preserving the order canonical class \(\pi_*R=6h\) →
   general one-point compact fibre → quasi-finite/finite → miracle flatness →
   ramified → degree six exhausts the cycle.
3. §2.3 *The local comparison at \(xyz\)*, `sections/02-orientation-cover.tex`
   — derive compact completeness of the \(xyz\) fibre from
   \(J_0(xyz)\ne0\) plus `[3, Theorem 5]` before any use of étaleness.
4. §2.3 *The Stein algebra*, `sections/02-orientation-cover.tex` — add the
   discrete-valuation-ring normality lemma showing every height-one zero of
   the multiplication section is simple, so the multiplication divisor is the
   reduced sextic and \(d=3\).
5. Proposition 1.2, `sections/01-introduction.tex` — replace the claim of two
   regular configurations on all of \(D(\sigma_3)\) by the split-étale
   pulled-back cover statement with the degeneracy-locus caveat.
6. §3.1 *Normalization over the Clebsch chart*,
   `sections/03-orientation-source.tex` — define \(\Delta_t=\iota_t^*\Delta\)
   after base change to \(\mathbf C\) and state the two-regular locus as
   \(D(\sigma_3\Delta_t)\).
7. §3.2 *The golden involution*, `sections/03-orientation-source.tex` —
   attach the relative source labels to the normalized components rather than
   to a pointwise regular marking.
8. Introduction source-attribution paragraph, `sections/01-introduction.tex`
   — citation hygiene separating "two regular golden configurations" from
   "complete compact fibre".
9. Appendix B archive locator (optional, `sections/08-verification.tex`) —
   add an immutable public locator **only if a real one already exists**.
   Inventing a digital object identifier, URL, commit hash, or checksum is
   prohibited; if none exists, make no change for this item.

## Hard prohibitions carried from the specification

- Make only the specified edits.  Preserve all theorem and proposition
  numbering and the notation \(H,J_0,\iota_t,\sigma_3,E,B,B_\pm,C_m,Z_m,\beta\).
- \(\Delta\) enters with no scalar normalization and no explicit formula; only
  its zero locus is used.  Never identify \(\Delta\) or \(\Delta_t\) with
  \(J_0\), \(\sigma_3\), a Vandermonde product, or any power or product of
  those, and never use \(\Delta_t\) in the arithmetic square-class argument.
- Do not use the letter \(D\) for the degenerate divisor; \(D(\sigma_3)\) and
  the square-class divisor already own that letter.
- Do not infer quasi-finiteness from a count of regular icosahedra, and do not
  use the branch theorem to prove itself.
- Leave untouched every item in the specification's global-prohibition list,
  including Theorem 1.1, \(\iota_t^*J_0=16\sigma_3^2\),
  \(J_0(xyz)=(16/25)^2\), \(z^2=80\sigma_3^2\), \(4\sqrt5\,\sigma_3\),
  \(C^2=5I\), \(\operatorname{Pf}[D_x,C]=4Z\), \(\det[D_x,C]=16Z^2\),
  \(Z=10\sqrt5\det B\), \(-784000/1247103\), Theorems 5.2--5.4 and 6.1, the
  Petersen material, the finite-field spinor class, and the
  integral/finite-field caveats.
- Do not amend the abstract or conclusion merely to mention \(\Delta\).

## Proofing the repaired steps

Editing to the specification is necessary but not sufficient; each repaired
step must be checked as mathematics before the paper is exported.

1. Verify against the cited Hitchin sections that each imported statement is
   used in the form actually available there — in particular that the compact
   trichotomy, the degree-ten invariant's characterization, and the
   chart-level positive-dimensional confinement are quoted at the right
   strength and not silently generalized.
2. Check the branch-cycle proof's dependency order for circularity, and check
   that upper semicontinuity plus `[3, §8.3, Theorem 4]` really does exclude
   the positive-dimensional case at a general smooth sextic point.
3. Check the miracle-flatness application's hypotheses (source smooth, target
   regular of the same dimension, local finiteness already established).
4. Check the new discrete-valuation-ring argument as written: the local
   algebra \(R[z]/(z^2-a)\), the integrality of \(z/\varpi\) when
   \(v(a)\ge2\), the failure of \(z/\varpi\) to lie in \(R\oplus Rz\), and the
   conclusion \(v(a)\in\{0,1\}\) at every height-one point.
5. Run the specification's independent transversality check at \(xyz\) as a
   consistency test on \(\Delta(xyz)\ne0\), without promoting it to a proof of
   fibre completeness and without inserting it into the manuscript unless the
   author asks.
6. Run every item of the specification's sanity checks A--E and the final
   author checklist, and record each answer.

## Validation and export gates

- The manuscript rebuilds warning-free and deterministically, and the page
  count and pagination change is accounted for.
- The paper-only aggregate is green:
  `cd papers/clebsch-passages && python3 verification/verify_release.py`.
- Statement-identity, formal-companion, and trust/release surfaces are
  reconciled with the edited prose: any hash or printed-statement pin that
  moves because Proposition 1.2 or the §2.2/§2.3/§3.1/§3.2 prose changed is
  updated deliberately, never suppressed, and no theorem statement outside
  Proposition 1.2 changes identity.
- Only after the authority repository is edited, validated, and committed,
  forward-commit the synchronized change to
  `~/src/math-papers/clebsch-passages` and validate there.  Read
  `notes/export-and-mirror-conventions.md` completely first; preserve that
  repository's history; do not re-export destructively.
- No push, release, deposit, or version bump without explicit author
  authority.  Paper III already has released v1 and v2, so this correction is
  a forward version, not an amendment of a published artifact.

## Boundaries

C916 owns `papers/clebsch-passages/` prose and the verification/trust surfaces
that its edits move, the dated C916 report, and the one-way synchronization to
`~/src/math-papers/clebsch-passages`.  It does not touch Lean sources, the
formal companion export chain (still blocked by the unresealed base manifest
recorded in the lane handoff), or any other paper root.

Two Paper III corrections owed from the released-paper cluster are *not* in
C916's scope: the wrong benchmark citation and the missing two-graph
attribution to Higman, Taylor, and Seidel via Brouwer and Van Maldeghem
(handoff cluster C876--C878, still cardless).  They would land naturally in the
same edit-and-export pass; folding them in is an author decision, and until it
is made C916 leaves them alone.

## Deliverable

A dated report `notes/2026-08-17-c916-paper-iii-compact-incidence-corrections.md`
(or the date the work actually runs) recording, per specification item, the
exact edit made, the proof check performed, every sanity-check answer, the
rebuilt PDF's SHA-256 and page count, the authority commit, and the standalone
commit it synchronized to.
