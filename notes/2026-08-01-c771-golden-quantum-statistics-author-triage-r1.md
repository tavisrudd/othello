# C771 — Author triage of cold referee round 1

**Lane:** `golden`

**Date:** 2026-08-01

**Frozen referee report:**
`notes/2026-08-01-c771-golden-quantum-statistics-cold-referee-r1.md`
at commit `a869f6c1`

**Recommendation received:** major revision; potentially publishable in
Physical Review A.

## Triage verdict

The report is strong and actionable.  Its two central objections are valid:
the submitted PDF does not expose enough of the Golden interface to let a
referee check Theorem 3.5, and its headline language does not always distinguish
the orientation-covariant determinant amplitude from the orientation-blind
filled-fermion probability and the sign inferred by coherent tomography.

The author clarification that the Clebsch papers will all be live materially
reduces the first repair.  The revised note may cite the public Paper III,
*Golden descent and operator realizations of the Clebsch cubic*, for the marked
conference--Joubert--Segre operator theorem and the public Paper I for the
upstream support/two-graph provenance.  It should still state the local
definitions, one explicit conference matrix, the six-protocol indexing and
orientation convention, and a short derivation of the balanced spectrum.  A
central theorem cannot be replaced by a citation alone, even when that citation
is live.

The dependence should be affirmative rather than defensive.  The abstract and
opening should say that the live Clebsch papers construct and prove the Golden
operator and its Joubert--Segre realization, and that the present paper builds
on that foundation to determine what symmetric and antisymmetric exchange
statistics retain, how the marked determinant signs can be read in a calibrated
apparatus, and where the photonic realization stops.  This improves the full
package: source mathematics remains owned and visible in the Clebsch series,
while the present note has a distinct quantum-statistics contribution.

No manuscript change was made in C771.  The immutable
`golden-quantum-statistics-c770-v1` review object remains intact.

## Major-comment dispositions

| referee comment | disposition | revision requirement |
|---|---|---|
| 1. Golden specialization is not self-contained | **ACCEPT** | State explicitly that this paper builds on the live Clebsch series; cite Paper III at exact theorem level and Paper I only for provenance; add an explicit base matrix, define \(T\), markings, path transports, and \(\varepsilon_T\); state and prove the short balanced-spectrum identity locally. |
| 2. Amplitude orientation versus observable probability | **ACCEPT — highest priority** | Rewrite the abstract, introduction, Theorem 3.5 transition, photonic section, and discussion so the determinant *amplitude* is orientation-covariant, \(F_{\rm ext}=|\det K|^2\) is sign-blind, and the precursor infers the sign from calibrated one-particle tomography. Do not claim a direct many-fermion sign measurement. Explain mathematical port gauge versus compiled laboratory frames. |
| 3. Public artifact and APS data statement | **ACCEPT; posting is user-owned** | Add the APS Data Availability Statement and make its distinction between exact artifacts and absent empirical data final. The user will supply the live artifact/preprint locator and handle the Clebsch forward reference; C771 creates no additional gate. |
| 4. Quantitative design-limit derivations | **ACCEPT** | Give compact derivations for the determinant Lipschitz gate, Bonferroni/normal-approximation shot formula and rounding, arbitrary-mixture bias bound, and trace-distance fidelity bound. Keep accepted-trial rates explicitly conditional. |
| 5. Physics significance relative to elementary invariant theory | **ACCEPT IN PART** | Add one paragraph explaining the operational gain of the Golden common spectrum and simplex schedule: protocol-independent calibration, a sharp 20/44 Boolean boundary, and reduced sign readout. Do not open an unsupported survey of competing transfer families. Demote the anomaly instance if it still interrupts this causal line. |

## Minor-comment dispositions

1. **Accept:** define Golden, marked protocol, balanced cut, and Joubert
   coordinate locally.
2. **Accept:** replace the visible comma in
   \(Z_T=\varepsilon_T,10\sqrt5\det K_T\) by explicit multiplication spacing.
3. **Accept:** cite the live Clebsch papers and state their public status.
4. **Accept:** reserve \(B_{\rm sym}\) for the trace/sum and write
   \(B_{\rm sym}/10\) whenever the operational uniform-input average is meant.
5. **Accept:** explain that the dagger notation anticipates the complex
   extension while the Golden construction is real.
6. **Accept:** print the selected three-sign schedule or put it in a compact
   table with an exact public artifact pointer.
7. **Accept in principle:** compress the anomaly instance to a remark or a
   short bounded subsection unless the revised introduction gives it an
   experimental job.  Remove it from the abstract first.
8. **Accept:** mark the omitted ports/postselection directly in Figure 1.
9. **Accept for submission metadata:** recommend PRA Regular Article,
   quantum-information/tomography handling with quantum-optics cross-listing;
   choose exact PhySH terms during the submission pass.
10. **Accept:** use published records and DOIs where available.

## Revision shape

The highest-EV revision is narrow rather than additive:

1. repair the operational claim everywhere;
2. install the citable Clebsch theorem interface plus a local balanced-spectrum
   derivation, with explicit opening credit that this paper builds on that
   source work;
3. expose the quantitative derivations and public trust surface;
4. tighten the abstract and introduction around the benchmark;
5. demote or remove material that does not support that line.

This should remain a Regular Article.  A Letter conversion would compress away
the definitions and trust boundary the referee has correctly requested.

## Official criteria consulted

- Physical Review A, “About Physical Review A”: **partial web read**, current
  page accessed 2026-08-01; scope and acceptance-criteria sections.
- Physical Review, “Guidelines for Referees”: **partial web read**, current page
  accessed 2026-08-01; report structure, originality/significance, rigor, and
  presentation criteria.
- Physical Review A, “Information for Authors”: **partial web read**, current
  page accessed 2026-08-01; Regular Article, audience, cover letter, and Data
  Availability Statement sections.

These official pages supplied review criteria only; they do not support any
mathematical or literature-priority claim.

## `ej` + `tt` closeout and mystery ledger

The cheap extra-value pass asked whether the live Clebsch papers eliminate the
need for local exposition, whether a direct fermionic phase protocol is already
implicit, and whether the anomaly example earns abstract space.  The answers
are no, no, and no under the present causal structure.  Exact public citations
shrink the proof burden, but the note still needs a checkable interface; the
existing experiment measures probabilities and tomography, not a direct
many-fermion sign; and the anomaly vector should be demoted unless it acquires a
specific benchmark role.

| feature | status | exact gap or next gate |
|---|---|---|
| Can exchange statistics expose the determinant phase directly in this architecture? | **Open mathematical-physics mystery** | The present three-copy emulator supplies \(|\det K|^2\). A coherent reference between exterior-sector amplitudes would require a new protocol and is outside the bounded revision. |
| Can the Golden theorem be cited rather than repeated? | **Settled** | Cite live Clebsch Paper III for the full operator theorem, but retain explicit local definitions and the short balanced-spectrum derivation. |
| Does the anomaly instance strengthen the PRA case? | **Settled negatively for the opening** | Remove it from the abstract and demote it unless revision gives it a direct experimental function. |
| Who owns live posting and the Clebsch forward reference? | **Settled** | The user will handle both after the package is ready; no new agent-side gate is added. |

No incidental discovery-track entry was created.  The possible direct phase
protocol arose from the referee's named operational question and belongs to
this task's mystery ledger, not the discovery track.

**Vibe check:** the referee round did its job.  It found no fatal mathematical
error, but it caught the exact point where elegant invariant language had
outrun the observable.  The revision is bounded and should materially improve
the paper.
