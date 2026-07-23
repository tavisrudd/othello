# C512 — persistent-or-arithmetically-bounded polar flags

**Lane:** `reed-solomon` · **Date opened:** 2026-07-23 · **Gate:** claim-specific literature audit
and an abstract polar-induction statement before any new field computation

## Objective

Turn the C498/C509 first-polar method into a general theorem for split-free Hankel systems.
For fixed redundancy \(r\), a binary \((r-1)\)-ic syndrome \(f\) has the coherently parameterized
first-polar line
\[
\ell_f=\mathbf P\langle(a_0,\ldots,a_{r-2}),(a_1,\ldots,a_{r-1})\rangle
\]
in the redundancy-\((r-1)\) syndrome space, with the same parameter naming the forbidden repeated
factor.  Iteration gives a catalecticant polar flag.

Prove an effective persistent-or-arithmetically-bounded principle:

> after removing explicitly classified contained catalecticant and modular-nucleus polar flags,
> a split-free Hankel system can exist only over fields bounded effectively in terms of the fixed
> redundancy and the degree/monodromy data of the lower splitting incidence.

The theorem may begin with explicit geometric hypotheses on the lower splitting covers, but those
hypotheses must be intrinsic, checkable, and verified on C498/C509 rather than hiding their
casework.

## Required inputs

- `notes/2026-07-22-c498-prs-redundancy-six.md`, especially the polar-line re-foundation and
  "Transfer to other Deep Hole strata";
- `notes/2026-07-23-c509-prs-redundancy-seven.md`, especially the exact pointed contraction,
  contained-line theorem, q=19 transient pointed orbit, and mystery ledger;
- C417's scalar additive-cocycle tangent lemma: \(u\star z=z+du\), with transitivity for
  \(d\ne0\) and the fixed/nonzero split when \(p\mid d\);
- the C491 exceptional-cover/point-count mechanism as the base arithmetic splitting-cover model.

Do not preload unrelated Reed--Solomon archaeology.  Before developing a nontrivial proof, follow
the named-expert routing rule in `AGENTS.md`.

## Work packages

1. **Intrinsic pointed polar functor.**  Formulate contraction, the forbidden diagonal, infinity,
   base change, and iterated catalecticant polar flags without a coordinate chart.
2. **Contained versus transverse theorem.**  Define the lower bad incidence scheme and prove that
   a polar flag is either contained in a classified component or meets it in an effective
   bounded-degree divisor.
3. **Persistent and modular components.**  Recover catalecticant rank-two tangent/sigma families,
   \(T/T^{r-1}\) with inversion/Frobenius, the Borel scalar cocycle, and nucleus components caused
   by modular representation degeneration.
4. **Arithmetic finiteness.**  State sufficient absolute-irreducibility/monodromy hypotheses for
   the residual splitting cover and derive an explicit \(Q(r)\) from point counts and deletion
   budgets.  Separate proved uniform bounds from hypotheses requiring a lower-cover theorem.
5. **Flag-coherence falsifier.**  Use C509's q=19
   \(W=\langle1,t^3,t^4\rangle\) orbit to prove that bad individual contractions are not the right
   inductive object; the theorem must retain the parameterized flag.
6. **Base-case recovery.**  Derive the logical shapes of C498 and C509 from the abstract theorem,
   including their persistent/modular/sporadic trichotomy and exact tangent split.

## Acceptance gate

- claim-specific literature audit for general split-free binary-form systems, polar/apolar
  incidence, and effective exceptional-cover finiteness;
- a field-independent theorem with explicit hypotheses and an effective bound, not merely a
  programme or analogy;
- contained-component and modular-cocycle clauses stated intrinsically and checked on C498/C509;
- the q=19 transient orbit handled as a theorem-level coherence test;
- exact statement of every remaining monodromy or absolute-irreducibility gap;
- no redundancy-eight census unless the abstract theorem itself exposes one bounded falsifier;
- report, mystery ledger, handoff, and any symbolic certificate committed atomically.

## Boundaries

This task does not classify all linear systems of binary forms, settle arbitrary-redundancy
Reed--Solomon deep holes, or replace missing monodromy by field tables.  A conditional theorem is
acceptable only when its hypotheses are natural and its verification in the two proved base cases
is complete.  Redundancy eight is evidence and a falsifier, not the deliverable.

## Status

Complete.  The field-independent theorem, base-case verification, exact remaining monodromy gaps,
and mystery ledger are in
`notes/2026-07-23-c512-general-polar-flag-theorem.md`; the claim-specific audit is
`notes/2026-07-23-c512-general-polar-flag-literature-audit.md`.
