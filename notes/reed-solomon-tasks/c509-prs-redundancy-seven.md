# C509 — deep holes of PRS(q−6) (redundancy seven) via the sextic NRC in PG(6,q)

**Lane:** `reed-solomon` · **Date opened:** 2026-07-23 · **Gate:** claim-specific literature audit
and pointed C498 polar reduction

## Objective

Classify the deepest syndromes of redundancy-seven projective Reed--Solomon codes.  For a binary
sextic syndrome \(f=(a_0,\ldots,a_6)\), its Hankel kernel is a projective web of binary quintics.
Choosing one rational factor contracts \(f\) to the C498 syndrome
\[
b(r)=(a_1-ra_0,\ldots,a_6-ra_5),
\]
and these points trace the first-polar line
\[
\ell_f=\mathbf P\langle(a_0,\ldots,a_5),(a_1,\ldots,a_6)\rangle
\subset\mathbf P^5.
\]

The entry theorem must:

1. prove the pointed lifting criterion: a split quartic in the C498 net at \(b(r)\) can be chosen
   not to contain \(r\);
2. classify first-polar lines contained in C498's persistent quadratic-gcd variety and its
   characteristic-two \(3\)-nucleus line;
3. bound all remaining intersections with the classified C498 exceptional strata;
4. derive the redundancy-seven persistent and modular orbit families, including
   \(T/T^6\) stabilizer arithmetic; and
5. only then choose a feasible orbit-reduced small-field calibration.

Task report: `notes/2026-07-23-c509-prs-redundancy-seven.md`.

## Entry gate — literature audit

The deliverable depends on absence of a prior redundancy-seven classification, so
`notes/literature-audit-conventions.md` binds.  Reuse C498's pinned coding forward tree and
full-text sources; refresh only the new discriminators and objects:

- `PRS(q-6)`, redundancy seven, sextic NRC in `PG(6,q)`;
- totally split squarefree members of webs of binary quintics;
- pointed split-member counts with one forbidden root;
- `PGL2(q)` orbits of binary sextics and Hankel webs of binary quintics.

The audit must distinguish the already-known scalar covering-radius range from the orbit/deep-set
classification, record read depth for every named source, and retain qualified novelty wording
where MathSciNet is unavailable.

## Acceptance gate

- claim-specific audit passed or the crown narrowed after bounded extraction;
- exact pointed polar-line equivalence proved, including the factor at infinity;
- contained-line and prescribed-root collision loci stated intrinsically;
- one replayable symbolic or finite-field calibration checks every asserted degree/orbit formula;
- report, mystery ledger, handoff, and evidence bundle validated and committed.

## Status

Allocated and started.  C498 supplies the all-field downstairs exceptional inventory and exact
fifth-power orbit law.  The first active step is the claim-specific literature audit, followed by
the pointed lifting lemma; no \(\mathbf P^6\) exhaustive census is authorized before orbit reduction.
