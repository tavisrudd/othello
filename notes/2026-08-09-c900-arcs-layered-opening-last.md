# C900 layered-opening final gate

**Verdict: NOT GO.**

Cold-read scope: the current abstract and Introduction of
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`, read in
that order as an adjacent combinatorics/coding reader.  No prior C900 review
material, history, diff, or grade was consulted.

## Actionable defects

1. **The abstract does not give operational language at the first use of its
   governing geometric objects (lines 44--48).**  It begins “For an arc in any
   finite projective plane” and immediately invokes “secant moments” and
   “pairs of secants” without saying that an arc has no three collinear points
   or that a secant is the line through two arc points.  The Introduction gives
   exactly the needed gloss at lines 84--88, but an abstract must stand on its
   own for the stipulated adjacent-field reader.  Add a compact gloss at the
   first abstract use, without repeating the later full definition.  The
   matching-design sentence already supplies an adequate operational gloss for
   `MATCH`.

2. **The two structural headline theorem statements are not self-contained at
   their hypotheses/notation boundary.**

   - The prescribed-hole theorem (lines 134--148) uses (m,N,r(x),
     \(\mathcal X_{\mathcal H}(A)\), and (I_{\mathcal H}(A)) only through the
     preceding prose.  More seriously, that prose defines
     \(\mathcal X_{\mathcal H}(A)\) in \(\mathrm{PG}(2,q)\), whereas the theorem
     is stated for an arbitrary projective plane \(\Pi\).  Define the needed
     quantities inside the theorem (or in a immediately preceding general
     setup explicitly over \(\Pi\) that the theorem incorporates by reference).
   - The (q+1)-hole lower-bound theorem (lines 168--184) assumes that (A) is
     “complete outside \(\mathcal H\)” without giving the operational condition
     in the statement, and its conic specialization invokes \(\rho_{\mathcal
     C}(q)\) only via an earlier definition.  State in the theorem that every
     point of \(\Pi\setminus(A\cup\mathcal H)\) lies on a secant of (A), and
     make the conic specialization locally interpretable (either restate the
     minimum or explicitly point to Definition~\ref{def:relative}).

These are local repairs: they do not require moving the results or adding a
new expository layer.

## Gates that pass

- **Analytic / finite / trust split:** lines 194--199 distinguish ordinary
  proofs from finite inputs and separate the kernel-checked order-16 exclusion
  from trusted classifier executions at orders 13, 17, and 19, with
  independently checked witnesses.  The abstract also signals formalization
  without substituting it for the mathematical account.
- **Proof map versus read map:** the proof map at lines 201--211 explains the
  causal mathematical mechanism; the first-pass map at lines 269--277 gives
  dependencies and safe skips.  They have distinct jobs.
- **Optional interfaces:** the coding translation is explicitly labeled a
  dictionary rather than a proof input, and the final reading paragraph marks
  the finite values and other secondary material as independently readable.
- **Literature boundary:** the introduction separates neighboring notions,
  classical secant equations, prior uncovered-locus localization, and matching
  designs without repeating one generic novelty disclaimer.  Each paragraph
  identifies a different boundary and the paper's exact increment.

No manuscript edit was made.
