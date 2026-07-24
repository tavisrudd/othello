# C578 — degree-nine rank-two Artin--Schreier avoidance

**Lane:** `reed-solomon` · **Status:** queued; highest EV after C532

## Objective

Resolve the first characteristic-two residue left by C531/C532: the
rank-two stratum of
\[
U=\langle e_2,e_3,e_6,e_7\rangle
\simeq \det^2\otimes(E^{(4)}\otimes E).
\]
Prove uniform rational avoidance on C531's geometrically integral
Artin--Schreier six-root cover across every rational \(A_5\)-twist in the
admissible binary coding range, or isolate the exact field/twist obstruction.

Eventual report:
`notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance.md`.

## Entry gate

C531's rank-two normal form, twist classification, cover equation, and
deletion boundary are frozen.  C532's redundancy-ten synthesis is complete
and identifies this stratum as the highest-EV proper subproblem of its
characteristic-two residue.

## Execution order

1. Descend C531's six-root cover and deletion divisor uniformly over each
   even- and odd-degree \(A_5\)-twist.
2. Normalize the cover enough to compute a valid genus/different bound and
   every collision, repeated-root, and chart deletion degree.
3. Derive the first valid power-of-two threshold from the exact point bound.
4. Close smaller admissible fields only through the twist quotient and a
   compact certificate where theorem arithmetic does not suffice.
5. Transport the conclusion under \(PGL_2/P\Gamma L_2\) and update C532's
   residual cardinality formula.

## Acceptance gates

- Every rational rank-two twist is covered.
- Exact rational-point and deletion theorem with a first valid binary field
  threshold.
- Either uniform shallowness or an explicit surviving field/twist obstruction.
- Exact effect on C532's residual set and semilinear orbit law.
- Atomic evidence bundle for every bounded computation.
- No ambient syndrome or carrier census.

## Stop rules

- Do not infer rational points from geometric integrality without an effective
  avoidance bound.
- Do not replace the nonconstant cover by its finite \(A_5\)-twist label.
- Do not open the two-dimensional complement
  \(\mathbf P(\mathcal M_9)\setminus\mathbf P(U)\).
- Fire an obstruction exit if normalization produces a new positive-genus
  component or constant-field class not controlled by the stated point bound.

## Owned paths

- `notes/2026-07-24-c578-degree-nine-rank-two-artin-schreier-avoidance*`
- `notes/reed-solomon-tasks/c578-degree-nine-rank-two-artin-schreier-avoidance.md`
- the `reed-solomon` handoff, archive, discovery track, and task lifecycle rows
