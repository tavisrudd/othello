# C491 — projective Reed--Solomon redundancy-five classification

**Lane:** `reed-solomon`

## Entry gate

C490 closes the six-point complete-child theorem.  C475--C485 provide the all-characteristic
determinant, quotient, orbit, discriminant, and descent toolkit in redundancy three.  C491 begins
only after a claim-specific current literature audit verifies the status of the projective
Reed--Solomon `PRS(q-4)` / redundancy-five case and the 2019 announced-next-case boundary.

## Exact domain

Projective Reed--Solomon codes of length `q+1` and dimension `q-4` over finite fields for which the
parameters are nondegenerate; geometrically, the quartic normal rational curve
`nu_4(P1(F_q)) subset PG(4,q)` and projective syndrome directions relative to its full rational
point set.  Ordinary full-affine RS and arbitrary redundancy remain outside the theorem.

## Target

Determine the covering-radius/deep-hole statement needed for `PRS(q-4)` and classify all projective
deep-hole classes up to the full projective-semilinear code automorphism group.  Express the answer
intrinsically through binary-quartic/apolar invariants, with exact exceptional characteristics,
stabilizers, and finite-field descent.

## Work package

1. Perform and record the claim-specific literature audit before novelty, priority, or
   “first beyond redundancy four” wording; distinguish a missing source from a negative search.
2. Translate deep syndromes into points of `PG(Sym^4 F^2)` avoiding the spans of every four
   rational normal-curve columns, and settle or state precisely the covering-radius gate.
3. Derive the all-characteristic determinant/apolar factorization and the exact quotient under
   column gauges, `PGL_2`, Frobenius, and the full code stabilizer.
4. Build the binary-quartic invariant atlas—discriminant, catalecticant, splitting/root type, and
   any further covariants actually forced by orbit collisions—and prove its equality criterion.
5. Classify every deep-hole orbit and exceptional fibre algebraically; use bounded finite-field
   controls only after normalization and theorem-derived bounds.
6. Produce an atomic checker/certificate bundle for finite claims and an independent
   implementation or invariant-theoretic replay.

## Long-horizon tool observatory

C491 is the first calibration case for the eventual Cheng--Murray / punctured-normal-rational-curve
completion programme.  Its report must maintain an **NRC bridge ledger** with three columns:

- constructions already functorial in `Sym^(r-1)` or a Grassmannian;
- quartic/rank-five accidents that provably do not scale; and
- exact missing lemmas for the general completion theorem, especially higher projection atlases,
  secant-span covering, and rational points with distinct roots.

When a required C491 proof produces a dimension-free lemma, state and prove the strongest safe
version now.  Do not broaden the task to arbitrary redundancy or claim progress on the famous
conjecture without the separate theorem and literature gates.

## Acceptance

A complete, semilinear orbit classification for `PRS(q-4)`, including its covering-radius premise,
with explicit invariant formulas, exceptional strata, canonical comparison algorithm, current
literature positioning, and atomic evidence.  The NRC bridge ledger must identify at least the
next falsifiable higher-dimensional lemma rather than merely listing analogies.
Report: `notes/2026-07-22-c491-prs-redundancy-five.md`.

## Boundaries

No assumption that the 2019 announced case remains open without audit; no general Cheng--Murray or
MDS-conjecture claim; no extrapolation from small fields; and no reuse of six-point Gale
self-duality where `n=2r` is absent.
