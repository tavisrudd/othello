# C900 layered opening / first-pass gate

**Verdict: NO-GO.**

Scope: context-clean review of the current
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`, after
reading `papers/style-guide.md` in full.  I read the abstract and introduction
sequentially and did not consult C900 notes, reviews, dossier, synthesis,
handoff, grades, or Git history/diff.

## Actionable defect

The headline theorem is not self-contained and is presently ungrammatical
(source lines 128--147).  Its opening reads

> Let \(A\) be a \(k\)-arc, \(k\ge3\), in a projective plane \(\Pi\) of
> \(r(x)\) to be ...

The statement has lost at least the order and transition before the definition
of \(r(x)\).  Consequently \(q\), which occurs in
\(N(q-1)\), is undefined.  It also uses \(\mathcal H\),
\(\mathcal X_{\mathcal H}(A)\), and \(I_{\mathcal H}(A)\) without ever
quantifying \(\mathcal H\) or requiring \(\mathcal H\subseteq\Pi\setminus A\).
The later setup makes the intended hypotheses clear, but a reader must not
repair the principal theorem from a later section.

Repair the opening along the lines of: let \(\Pi\) be a projective plane of
order \(q\), let \(A\) be a \(k\)-arc with \(k\ge3\), let
\(\mathcal H\subseteq\Pi\setminus A\), and let \(r(x)\) denote the number of
secants through \(x\in\Pi\setminus A\).  Then recheck the complete statement
against the body theorem.

## Criteria otherwise met in the opening

- Arc and secant are defined operationally at first use.  The introduction
  operationalizes Kneser adjacency, maximum-matching concurrency blocks, the
  matching-design condition, the rank-three projective realization, and the
  dual star--matching incidence realization.
- The universal projective-plane result and the Desarguesian/conic
  specializations are visibly separated.
- Ordinary proofs, the kernel-checked order-16 exclusion, trusted classifier
  executions for orders 13, 17, and 19, and independently checked witnesses
  have a concise, explicit trust split.
- The proof map explains the mathematical mechanism; the later first-pass map
  instead gives dependencies and safe skips.  Their jobs are distinct.
- The coding translation is clearly labeled optional and explicitly disclaimed
  as a proof input.
- The literature boundary is concise and distinguishes saturating sets,
  almost-complete conic subsets, hyperfocused arcs, complete exterior sets,
  prior subgeometry localization, classical moment equations, and matching
  designs from the present prescribed-hole remainder.

No manuscript edit was made.  Re-run the opening gate after repairing the
headline theorem statement.
