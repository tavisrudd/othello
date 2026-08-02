# C771 — Cold referee report, round 1

**Manuscript:** *Orientation and exchange statistics in a Golden six-mode
transfer*

**Venue assessed:** Physical Review A, Regular Article

**Review object:** ten-page PDF in
`golden-quantum-statistics-c770-v1`

**Cold-read boundary:** this report was written from the submitted PDF and the
current Physical Review referee and PRA scope criteria.  Development reports,
source files, certificates, and author-side explanations were not consulted
during the read.

## I. Comments to the author and editor

### Summary and overall assessment

The manuscript studies a real six-mode transfer built from the two
three-dimensional eigenspaces of a symmetric conference matrix.  Its general
observation is that the determinant is a relative invariant of the oriented
left--right port action, whereas a permanent does not descend through the same
change of frames.  For a distinguished six-member Golden family, the authors
then state a common singular spectrum on all balanced Boolean controls, derive
exact symmetric-, mixed-, and exterior-power statistics, construct a calibrated
determinant-sign code, give one arithmetic filter, and compile the transfer into
a photonic circuit.  Direct three-fermion emulation is correctly separated from
the coherent and bosonic precursor because it requires a presently external
antisymmetric three-qutrit source.

The paper contains a good organizing idea.  The determinant-line formulation is
clean, the distinction between intrinsic and frame-calibrated quantities is
useful, and the authors are admirably explicit about the experimental boundary.
The manuscript is also concise and generally well written.  The topic is within
PRA's quantum-optics and quantum-information scope.

I cannot recommend acceptance in the present form.  The theorem that supplies
most of the paper's nontrivial content is not self-contained: the Golden family,
its marking, and the identity that yields the common spectrum are not given in a
form a referee can verify.  In addition, the operational status of the
determinant sign needs sharper wording.  The directly quoted fermionic quantity
is a probability and loses the sign; the sign is instead inferred from coherent
one-particle tomography after orienting calibrated port frames.  This is an
interesting distinction, but several headline sentences currently attribute
more operational information to exchange statistics than the stated experiment
measures.

My recommendation is **major revision**.  I would be willing to review a revised
version.  The core need not be enlarged, but it must become independently
checkable and its principal physical claim must match its actual readout.

### Major comments

1. **Define and prove the Golden specialization in the submitted paper.**  On
   pages 1--2 the manuscript introduces “six coherently marked conference
   matrices,” later writes (C_T), (Q_{T,\pm}), (arepsilon_T), and “six
   marked protocols,” but never supplies a base matrix, the set indexed by
   (T), the path permutations, or the orientation convention.  The claimed
   Joubert realization is deferred to an uncited “companion operator paper.”
   The proof of Theorem 3.5 on page 4 begins, “The Golden conference identity
   gives the displayed spectrum,” without stating or proving that identity.
   This leaves the common spectrum, the 20-mask sufficiency, the six sign words,
   and all later exact numbers resting on an unavailable assertion.  At minimum,
   give one explicit (C), define all six protocols and their markings, state
   the algebraic identity from which the balanced spectrum follows, and provide
   either a short proof or a precise accessible citation.  The reader should be
   able to reproduce Theorem 3.5 without reverse-engineering the verification
   files.

2. **Separate determinant-line covariance from an observed exchange-statistics
   signal.**  Theorem 3.1 correctly says that (det K) becomes a signed scalar
   only after orientations are chosen.  The filled-fermion probability used in
   Theorem 3.5 is (F_{\rm ext}=|\det K|^2), which is orientation-blind.  The
   experimental section then obtains a sign from coherent transfer tomography
   and explicitly says this is not a direct many-fermion phase observation
   (page 7).  Please reconcile this with the title, the abstract's statement
   that antisymmetric statistics “retain the orientation,” and the analogous
   conclusion on page 9.  Either give an operational interferometric protocol
   in which a relative top-exterior phase is measured as a fermionic/emulated
   many-particle observable, or consistently state that antisymmetrization
   supplies an orientation-covariant amplitude while the proposed precursor
   infers its sign from calibrated one-particle tomography.  Also explain why
   (O(3)\times O(3)) is a gauge of the mathematical Golden object but not of
   the laboratory apparatus once eigenport frames are physically compiled.

3. **Make the computational evidence available to a referee and add the APS
   data-availability statement.**  The Verification section names a local
   directory, checker, manifests, and replay command, but gives no public or
   submission-supplement locator.  A referee cannot inspect the claimed
   certificate, the pivot convention, the six sign words, or the Givens
   compilation from the PDF.  Deposit the exact artifact at a stable accessible
   locator or include it as Supplemental Material; cite the archived version in
   the paper and state precisely which claims it checks.  Add the Data
   Availability Statement required for an APS submission.  The statement must
   distinguish exact mathematical artifacts from empirical data, of which the
   paper reports none.

4. **Support the quantitative design-limit claims with derivations at the point
   of use.**  Pages 8--9 quote the determinant perturbation thresholds, four
   simultaneous-coverage trial counts, and two pairs of adversarial fidelity
   gates.  The assumptions are listed, but the formulas producing the tabulated
   integers and fidelity bounds are absent.  These values help justify the
   paper's “design-limit” identity and therefore should not be accepted solely
   through a checker that the reader cannot see.  Give the confidence
   allocation and rounding rule for the shot counts, derive the determinant
   Lipschitz bound under the stated contraction hypotheses, and show how the
   mixture and trace-distance models yield the fidelity inequalities.  Make
   especially clear that “accepted trials per second” is not a source or
   detector rate.

5. **Clarify the paper's physics contribution relative to elementary invariant
   theory.**  Theorem 3.1 and Proposition 3.2 are useful but fairly elementary.
   The paper's significance therefore rests on the explicit Golden realization
   and on what it enables experimentally.  The introduction should state why
   this six-mode family is a useful quantum-statistics benchmark beyond giving
   exact values: which competing transfer families fail to have the common
   spectrum or sign-code property, and which proposed measurement becomes
   cheaper or more discriminating because of it?  A bounded comparison would
   suffice.  Without it, the exact arithmetic instance on page 6 and the
   decoder read as mathematically interesting appendages rather than parts of a
   single AMO result.

### Minor comments

1. Define “Golden,” “marked protocol,” “balanced cut,” and “Joubert coordinate”
   operationally at first use.  These are not standard terms for a general PRA
   reader.
2. The formula on page 2 appears as
   (Z_T(x)=\varepsilon_T,10\sqrt5\det K_T(x)).  Replace the comma by an
   unambiguous multiplication or spacing symbol.
3. The companion operator paper mentioned on pages 1--2 needs a bibliographic
   citation and a clear status.  If it is unpublished, the present manuscript
   must not depend on it for a central proof.
4. On page 3, distinguish (B_{\rm sym}), which is a trace/sum, from the
   operational uniform-input average (B_{\rm sym}/10) consistently in the
   abstract, theorem, and later physical discussion.
5. State explicitly whether (K^\dagger K) is retained only to anticipate the
   complex extension; the constructed transfer is real and most formulas use
   transposes.
6. Explain how the three selected signs are chosen and whether the selection is
   fixed for all six protocols.  “Economical” readout should be accompanied by
   the actual schedule or a precise artifact pointer.
7. The arithmetic anomaly example is carefully bounded, but its connection to
   the quantum-optics question is weak.  Consider shortening it to a remark
   unless it is used by the experimental design.
8. The figure is legible and color-independent.  Its upper line, however, may
   be read as a three-input/three-output device rather than a selected block of
   a six-mode device; label the unshown ports or emphasize the postselection in
   the diagram itself.
9. Give the section classification proposed for PRA and appropriate PhySH terms
   in the cover letter.  Quantum information/tomography and quantum optics both
   appear plausible.
10. Where published versions exist, prefer the published bibliographic record
    and DOI to an arXiv-only entry, while retaining an arXiv link if useful.

## II. Recommendation

**Major revision.**  The manuscript is potentially publishable in Physical
Review A after the Golden theorem becomes self-contained, the operational
orientation claim is narrowed or directly measured, and the computational and
quantitative evidence becomes accessible and auditable.

## III. Confidential comments to the editor

The manuscript is in scope and has a coherent idea, but the general theorem by
itself is not a sufficiently significant PRA contribution.  Publication weight
comes from the exact Golden family and the design-limit application.  At
present, the former is asserted through an undefined family and a one-line
proof invoking an unstated identity, while the latter sometimes blurs a
determinant amplitude inferred by classical tomography with an observable
fermionic sign.  I do not see evidence of a fatal error, and the authors are
more careful than usual about the unavailable antisymmetric source.  I
therefore recommend major revision rather than rejection.  A revised paper
should be sent back to a referee rather than accepted editorially.

The most natural PRA handling appears to be a Regular Article in quantum
information science/tomography or quantum optics, not a Letter.  The arithmetic
anomaly section should not influence the editorial decision unless the authors
connect it more tightly to the AMO experiment.

