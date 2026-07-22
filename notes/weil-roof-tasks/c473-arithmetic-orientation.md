# C473 — arithmetic orientation of the frozen lower-Weil core

**Context:** queued after C471 and C472. C465 determines the simple core only up to the Galois swap
of the lower Weil pair. The common parameter `m=(q+1)/4` splits `x^2+x+m` modulo `m`; C469's
Hadamard sign normalization may select one of the two residue primes canonically.

## Dependencies

- C471 puncture/shorten intertwiners and normalized Hadamard operator
- C472 signed-lift cocycle and central-action disposition
- C450 lower-Weil period conventions and frozen sheet orientation

## Task

1. Fix integral period generators for `Q(sqrt(-7))` and `Q(sqrt(-11))` and record the two primes
   above `2` and `3` without table-label ambiguity.
2. Determine whether the frozen sheet, minority-symbol convention, Hadamard sign choice, or signed
   lift canonically selects one residue root of `x^2+x+m` and hence one lower constituent.
3. Give an exact intertwiner from the selected reduction to the simple Hamming/Golay core, or prove
   that every proposed orientation retains a torsor/sign ambiguity.
4. State the q=7 and q=11 comparison uniformly and delimit dependence on arbitrary row, sign, and
   projective normalizations.

## Acceptance

Return exact prime ideals/residue maps, frozen-basis matrices, intertwiner or obstruction
certificate, normalization-change table, checksums, and independent replay.

## Boundaries

- No unqualified canonical orientation if it changes under an allowed frozen gauge.
- Literature is needed only if a priority or standard integral-lattice claim enters the verdict;
  finite arithmetic and intertwiners must still be computed.
