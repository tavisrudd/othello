# C900 layered specialist read: Arcs complete outside a conic

## Verdict

**MINOR**

The manuscript now has a sound specialist/adjacent-expert layering.  The main
mechanism is visible before the proofs, the changes from projective geometry to
Kneser/matching language and from incidence counting to chord involutions are
given useful roadmaps, and the body does not repeatedly interrupt arguments with
verification detail.  The general-plane, Desarguesian, characteristic-two, and
finite-computation hypotheses remain visible.  The verification appendix is
explicitly skippable and still adequate: it separates ordinary proof,
kernel-checked certificate, trusted execution, and external classification,
then states completeness contracts and residual trust.

## Exact actionable findings

1. **First avoidable specialist slowdown: move or cut the coding translation at
   lines 116--121.**  The MDS/deep-hole paragraph arrives before the main theorem,
   is not used in the proof map or later argument, and delays the governing
   secant-index mechanism.  If the coding interface is worth retaining, make it
   an explicitly optional remark after the main theorem (or in related work),
   with one sentence saying what later statement it translates; otherwise
   delete it.

2. **Compress the contribution restatements at lines 224--264.**  Lines 228--230,
   240--243, and 253--264 each reannounce some combination of the exact local
   remainder, equality/stability, and prescribed-conic specialization already
   stated in the theorems and proof map at lines 139--207.  Keep the source
   boundary in each literature paragraph, but reduce each to the precise
   comparison with that literature; one final sentence can state the paper's
   contribution across the interfaces.  This will preserve the useful novelty
   account while removing the first substantial repetition.

3. **Make the headline defect theorem self-contained at line 140.**  Replace
   “For every \(k\)-arc \(A\) with \(k\ge3\) and prescribed hole \(\cH\)” by an
   explicit hypothesis matching Theorem~\ref{thm:defect}: \(A\) is a \(k\)-arc
   in a projective plane of order \(q\), and
   \(\cH\subseteq\Pi\setminus A\).  The current meaning is recoverable from
   lines 131--137, but the principal theorem should expose its exact domain and
   disjointness assumption without relying on nearby prose.

4. **Expose the parity-to-tangent bridge in the characteristic-two roadmap at
   lines 893--896.**  Besides correcting “secant of (A)” to “secant of \(A\),”
   say that parity first excludes \(\nu\in A\) and then forces
   \(r(\nu)=m\), hence a tangent secant.  Those are the proof-changing facts at
   lines 916--926; naming them makes the roadmap transfer the mechanism rather
   than merely announce its output.

## Appendix and trust-path assessment

The reading map at lines 266--273 correctly lets a mechanism-only reader stop
after the main body while directing readers who want the headline exact finite
values to Appendix~\ref{sec:examples}.  The remaining appendices identify their
secondary roles locally.  In particular, the verification appendix's opening
at lines 1869--1873 makes the skip safe, while its evidence table and the
following contracts retain enough detail to assess completeness and trust.
