# C531 — degree-nine Lucas-carrier \(PGL_2\) strata

**Lane:** `reed-solomon` · **Status:** complete at the nonconstant-cover/positive-moduli stop

## Objective

Classify the intrinsic \(PGL_2\)-strata of the characteristic-two degree-nine Lucas carrier
\[
\mathcal M_9=\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle
\]
and compute arithmetic deepness on every stratum whose ordered-root cover admits a bounded
normalization.  Begin with proper stabilizer-enhanced orbit strata; do not attack the generic
positive-dimensional quotient until the smaller strata and C530's \(e_7\) orbit are closed.

Eventual report:
`notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.md`.

## Outcome

The invariant tensor block has exactly three geometric strata.  Both rank-one strata are
uniformly shallow; the rank-two stratum has finite \(A_5\)-twist classes but a geometrically
integral nonconstant Artin--Schreier root cover.  The complementary carrier quotient has dimension
two.  These are the task's exact authorized obstruction boundaries.

## Entry gate

C530 must supply the exact normalized quotient cover and Frobenius law for the distinguished
\(e_7\) orbit, or its proved first obstruction.  Import that result without regenerating its
evidence.

## Execution order

1. Compute the invariant ring/covariant separators needed to stratify \(\mathcal M_9/PGL_2\).
2. Determine stabilizers, orbit dimensions, closure incidences, and Frobenius transport.
3. Normalize ordered-root covers on zero-dimensional and proper special strata first.
4. Proceed to the generic quotient only if its moduli dimension and cover degree remain bounded.
5. Translate every rational component into exact split-squarefree/deepness semantics.

## Acceptance gates

- Intrinsic normal-form and stabilizer stratification, including closure relations.
- Exact cover/monodromy/Frobenius calculation for every claimed arithmetic stratum.
- Clear separation of closed strata from unresolved positive-dimensional moduli.
- No ambient projective syndrome census.
- Atomic evidence bundle for every paper-facing computation.

## Stop rules

- Stop at the first positive-dimensional moduli or extra-monodromy obstruction that prevents a
  finite intrinsic classification.
- Do not open redundancy-ten synthesis before the carrier theorem boundary is explicit.
- Do not open C500.

## Owned paths

- `notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata*`
- `notes/reed-solomon-tasks/c531-degree-nine-lucas-carrier-pgl2-strata.md`
- the `reed-solomon` handoff, archive, discovery track, and task lifecycle rows
