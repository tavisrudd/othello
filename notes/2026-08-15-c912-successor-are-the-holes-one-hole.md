# Are the holes one hole? A framing memo for the C912 successor

**Date:** 2026-08-15
**Lane:** `clebsch`
**Status:** framing only — no result is claimed here
**For:** a fresh session, read cold; nothing else needs loading first

Two questions are posed here, in order of dependence.

1. Must a solution of the one-stabilization case be a collapsed or localized version of
   the general one, or can it be genuinely independent?
2. Is there an invariant *between the holes* in our several conditional proofs — a
   conserved quantity that says the same debt is being presented in different
   resolutions? If there is, it should make predictions, and those predictions should be
   tested rather than admired.

The second question is the substantive one. The first is its sharpest test case.

## State of play, so nothing below is re-derived

**Paid outright.** For the trivial rank-two bundle the Iritani--Koto displacement is
`varsigma_j^circ = 2 lambda_j = +-2 q^{1/2}` exactly, a pure degree-zero shift with no
tail — two independent proofs, one from the sources' formula (5.11) with `c_1(V) = 0`, one
from the product structure, where the summand simply *is* the cubic's connection at a
degree-zero parameter. Degree-zero shifts are exact by the string equation and change no
exponent, so `nu_6(X x P^1, 0) = 4` at the canonical parameter. This is a computed fact.

**Proven, with a domain limit.** The rank-two Jordan block is rigid: it cannot split
(`d_a det N = 2 q_a det N` with zero initial value), no irregularity appears
(`d_a f = f w_a` with zero initial value), and the sheared residue moves by conjugation
(`d_a R = [R, G_a]`), so its characteristic polynomial is constant. Independently
recomputed line by line by a hostile referee. Its domain is the formal bulk germ — the
same domain Cai's gauge argument already gives. Trace of the residue is `-1`, so the count
is nonzero exactly when its determinant is `5/36`. Also proven and unconditional:
multiplicity-one blocks carry no framed monodromy at all.

**Refuted, with reasons — do not re-enter.** Substituting a displaced parameter into the
change of variables: Iritani--Koto's (5.13) makes the invertible map the one in the
*displaced* coordinates `s_j = varsigma_j - varsigma_j^circ` treated as independent formal
variables, Iritani's Lemma 5.15 is the formal inverse function theorem at the origin, and
Iritani states the pullback of functions is ill-defined. Reading the comparison identity in
either direction: same reason. Applying the decomposition identity "at any parameter": every
version in the sources is an isomorphism over a formal germ, not a family of pointwise
statements.

**Unsupported.** Arranging the factorization as a roof, so that one descent reaches both
ends. That is strong factorization, open in general, and it cannot be built by hand here
because the factorization is hypothetical — it exists only under the rationality assumption
being contradicted, so the argument gets exactly the strength of the general theorem, which
is a zigzag.

**Conservation accounting, which localizes everything.** Vertical motion is free: each
blowup relation splits the count exactly, and centres of dimension at most two contribute
nothing, so nothing leaks between varieties. The debt is entirely horizontal — two
parameters of one variety. Consequently, if `X x P^1` were rational, some valley of the
zigzag must have a parameter-dependent count. Slack: four supplied, one needed, so three
eigenvalues may be lost anywhere. The debt cancels at steps whose displacement is degrees
zero and two, at adjacent blowup/blowdown pairs of the same centre, at valleys whose Euler
operator has only multiplicity-one eigenvalues, and at every centre.

## The holes, stated precisely

Each conditional proof has exactly one. State them side by side, because the whole question
is whether they are the same object.

| Route | The hole, as a mathematical assertion |
|---|---|
| Manuscript's own | The count is unchanged when the bulk parameter moves by the comparison's displacement, for an arbitrary block on an arbitrary intermediate fourfold. |
| Atom ledger | The count is well defined across identification of base points within one connected component of the spectral cover. |
| Local m = 1 | The rank-two blocks of `X x P^1` keep at least one primitive-sixth eigenvalue along the accumulated pencil; owed lemmas are per-slot polynomiality, nonvanishing of the nilpotent entry, substitution legitimacy past the first descent, and the low-dimensional lemma restricted to arising parameters. |
| All-m draft | The marked rank row survives the analytic comparison coherently, so that Stokes mixing cannot make rank-zero centre blocks rank-visible. |
| Serre decoration | The decoration's definition in the non-archimedean analytic setting, which the sources defer to forthcoming work. |

## Question 1: must m = 1 be a localization of the general?

The case that it must:

- The reduction that made m = 1 look local — one variety, lower bound only — inherited the
  roof, and the roof is unavailable. Without it, the debt sits at every valley, which is
  arbitrary fourfolds, which is the general statement.
- The displacement m = 1 must survive is not independent of the comparisons; it is
  their composite. A hypothesis asserting that a marked structure survives the comparison
  coherently, along composites, contains the m = 1 statement as the special case where the
  variety is `X x P^1` and the block type is known.
- The general invariant refines the primitive-sixth packet, so preservation of the general
  marked Boolean implies the m = 1 lower bound. The implication runs the right way.

The case that it need not:

- m = 1 needs only a lower bound and only for blocks of one known type, whereas the general
  statement needs an equality for arbitrary blocks. Slack of three is available.
- The centres at m = 1 are surfaces, which are classified, so the rank refinement that the
  general route exists to provide buys nothing here.
- The general hypothesis is Stokes-level; the m = 1 obligation is formal. Nothing formal can
  prove the general one, but the converse gap does not obviously exist.

**The test that separates these.** Restrict the general hypothesis to `X x P^1` and the one
accumulated pencil, and ask what it becomes. If it reduces exactly to the four owed lemmas,
m = 1 is a localization and should be proved as one. If it reduces to something strictly
stronger than those lemmas, m = 1 has genuinely independent content and should be proved
independently and kept unconditional.

## Question 2: an invariant between the holes

The conjecture worth testing is a trade rather than a quantity. Every decoration that has
been tried sits somewhere on three axes:

- **separating** — does it distinguish the cubic's block from everything of dimension two
  less;
- **parameter-robust** — is it well defined without a transport statement;
- **formally checkable** — can it be computed and compared without Stokes or integral data.

Observed positions. Undecorated atoms: robust and formal, not separating — which is why the
lane recorded them as too coarse. Framed formal monodromy: separating and formal, not
robust — hence every transport hole above. The Serre automorphism: separating and robust,
not formal — well defined across a component by rigidity of representations of a
proreductive group, at the cost of an integral-structure definition. The Gamma rank row:
separating and robust if it is read from the integral local system, not formal — hence the
Stokes hypothesis.

**Conjecture.** No decoration is all three at once, and each hole above is the price of the
missing axis. If so, the holes are one hole presented in different resolutions, and the
invariant is simply which axis has been given up.

This is a conjecture about our proof strategies, not about mathematics, so it must earn its
place by predicting rather than by explaining. It does explain the record — every refuted
route was an attempt to have all three — but retrodiction is weak evidence and should be
labelled as such.

## Predictions, and what would falsify each

**P1. The semisimple coalescence is not formally rigid.** At a generic caustic the Euler
operator becomes scalar on the block, so the nilpotent part vanishes — exactly the case the
rigidity theorem excludes. The conjecture predicts that no formally checkable argument makes
the exponents stable there, and that any stability proof will import Stokes or integral
data. *Falsified by*: a formal proof of rigidity at a semisimple coalescence. That would be
the best possible outcome and would also close m = 1 locally.

**P2. Restriction of the general hypothesis lands exactly on the owed lemmas.** *Falsified
by*: finding that the restriction is strictly stronger, which would show m = 1 is not a
localization and the holes are not one hole.

**P3. No decoration in the literature has all three axes.** Check the sources' enhanced
atoms — Euler pairings, Serre automorphisms, integral structures — and any decoration in
adjacent work. *Falsified by*: exhibiting one, which would immediately be the right
invariant to use and would end the programme by solving the problem.

**P4. Any newly proposed route will have its hole predicted by the missing axis.** Apply
before investing: identify which axis a proposal gives up, and predict the shape of its hole
in advance. *Falsified by*: a route whose hole is of a different kind than the axis it drops.

## Method notes for the fresh session

Numerical experiments on quantum products need a validity check built in. The `P^2` caustic
hunt returned a plausible answer that was noise: a caustic at `s ~ 1.96`, exponents
`-1/2 +- 0.30i`, all of it produced by summing a divergent tail. Associativity is the
diagnostic — the truncated product commutes to machine precision only out to about `s = 1`,
and the failure grows with more terms rather than shrinking. Test associativity first, work
only inside the region where it holds, and prefer a model whose product converges where its
eigenvalues collide.

Do not re-derive the paid items, and do not re-enter the refuted ones; both lists are above
with their reasons.

## Where things are

- Analysis and proofs: `2026-08-15-c912-frame-transport-memo.tex` and its PDF — Section 8 is
  the rigidity theorem, Section 9 the atom assembly and its gap, Section 10 the endpoint and
  the conservation accounting.
- Adversarial record: `2026-08-15-c912-section10-hostile-referee.md`.
- Substitution verdict and debt-location ledger: `2026-08-15-c912-change-of-variables-continuity.md`.
- Source assessment of the atom spine: `2026-08-15-c912-atom-spine-source-assessment.md`.
- Route map and status ledger, published page: `2026-08-15-c912-debt-ledger.html`.
- Caustic experiment and its validity check: `p2_caustic.py`, `p2_exponents.py`, `p2_assoc.py`.
- Live task card: `clebsch-tasks/c912-cubic-stabilization-referee-foundations.md`.

A task ID must be reserved through `notes/scripts/allocate_codex_task_ids.py reserve` when
this is picked up; none is allocated here.
