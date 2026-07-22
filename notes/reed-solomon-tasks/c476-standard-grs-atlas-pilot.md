# C476 — bounded standard-GRS atlas pilot

**Lane:** `reed-solomon`

## Entry gate

C475 has proved the invariant quotient and supplied a canonical comparison procedure.

## Exact domain

For each `q in {5,7,8,9,11}`, enumerate every `PGammaL_2(q)` orbit of six-subsets
`S subset P1(F_q)`. For each support, enumerate its projective deepest syndromes and their orbits
under the full semilinear stabilizer of `S`.

Order cases by `(q, canonical support, canonical syndrome)`. The `q=5` full-conic support is a
zero/terminal control, not permission to change the length.

## Work package

1. Prove exhaustive support and stabilizer enumeration by frame rigidity.
2. Compute the C475 atlas on every deepest-syndrome orbit.
3. Compare atlas fibres with exact semilinear orbits.
4. At the first collision, finish the entire fibre and support orbit, then stop before the next
   support. If none occurs, finish the stated five-field domain.

## Acceptance

- Exact counts of support classes, syndrome orbits, and atlas fibres for the searched prefix.
- Independent orbit/fibre replay and a hash-pinned compact certificate.
- Either the lexicographically first complete collision fibre or an exact no-collision theorem on
  the whole stated domain.
- Report: `notes/2026-07-22-c476-standard-grs-atlas-pilot.md`.

## Boundaries

No other length, field, random sampling, or extrapolation. A collision activates C477; separation
through `q=11` does not by itself imply an all-field theorem.
