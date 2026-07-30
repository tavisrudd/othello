# C689 — shared radial nonvanishing

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** ready as the C665 conceptual successor after completed C688;
Paper II v2 only.

## Objective

Close the shared radial-nonvanishing question.  Iterated apolar trace
already extracts the deepest radial Fischer summand uniformly, but the
current proof establishes its nonvanishing by two conspicuously
type-specific witnesses:

- the \(B_3\) common-secant square over \(\mathbb F_7\); and
- the \(H_3\) second-trace witness over \(\mathbb F_{11}\).

Find one geometric reason that forces the relevant radial component to be
nonzero in both configurations.  This should remove the final impression
that the uniform theorem terminates in two unrelated scalar checks.

## Acceptance gate

A positive closure must:

1. use one invariant geometric construction in the matching/conic quotient
   for both \(B_3\) and \(H_3\);
2. identify its radial Fischer projection and prove that this projection
   is the existing load-bearing component in each type;
3. prove nonvanishing from shared incidence, apolar, Gorenstein, or
   one-factorization geometry, without evaluating separate case-specific
   scalars as premises;
4. recover the two old witnesses as specializations or corollaries;
5. state exactly which hypotheses are genuinely common and where
   \(B_3/H_3\) first diverge; and
6. retain exact q=7 and q=11 replay as corroboration, not as the human
   proof.

If no honest shared mechanism exists, close sharply by proving the
obstruction: identify the invariant that forces the two radial components
to arise from essentially different geometric data.  A renamed pair of
scalar calculations, a direct-sum statement with two clauses, or a finite
search does not pass either disposition.

## Guardrails

- Do not reopen C665's uniform extension-field C1 theorem or C688's replay
  compression.
- Do not change or hold Paper II v1.
- Do not infer nonvanishing from a composition factor, dimension count, or
  the fact that both finite scalar witnesses happen to be nonzero.
- Preserve the existing q=7 and q=11 certificates until a replacement
  theorem and its replay are committed.
- Keep a v2 theorem only if the common mechanism is conceptually shorter
  and stronger than the two current witnesses.

## Starting seam

The radial extraction itself is already uniform.  The only open input is
geometric nonvanishing.  The highest-EV first attacks are:

1. express both witnesses as the same apolar pairing of the
   one-factorization incidence tensor with its radial projection;
2. test whether Gale self-duality or the arithmetically Gorenstein
   resolution forces that pairing to be perfect; and
3. seek a common secant-energy interpretation in which positivity is
   replaced, in finite characteristic, by a nondegenerate incidence
   pairing rather than an ordered-field argument.

Source record:
`notes/2026-07-26-c665-balanced-matching-completeness.md`.
