# C923 — a structural proof that the pencil's Eckardt locus is the Fermat pair

**Lane:** `cubic-threefolds`

**Status:** active

**Objective:** prove, without a Gröbner elimination, that the only smooth
members of the nonstandard `A_5`-cubic pencil carrying an Eckardt point are the
two Fermat members.

## Why this is worth doing

C921 established the statement by elimination over `Q`, and the epilogue now
carries it as `prop:A5-not-coprime`, with `prop:A5-nonseparated` inheriting the
dependency. That is the manuscript's only computation-dependent moduli
statement, and it is the reason `thm:separation-family` still says "all but
finitely many" rather than naming the single exceptional point: sharpening the
theorem would put a headline result behind a trusted computer-algebra run.

A structural proof removes the dependency and lets the theorem sharpen for free.
It would also let `verification/README.md` go back to describing a spine with no
symbolic program in it, apart from the Section 5 spectral input.

## What is already known

In the six-point model the pencil is `F_b = p_3 + b T_1` on the sum-zero
subspace of `Q^6`. By elimination:

- the Eckardt locus is `b(b^2+3b+9)`, and `b = 0` is the Segre cubic, singular;
- the reduced locus of singular parameters is `b(b+6)(b^2-3b-9)(7b^2+3b+9)`;
- each Fermat member carries exactly thirty Eckardt points, the Fermat count;
- the Fermat members' elliptic factor has complex multiplication by `Q(sqrt -3)`,
  and the Eckardt quadratic's discriminant is `-27`, generating the same field.

Report and evidence: `../2026-08-19-c921-pencil-level-structure-and-eckardt.md`
and `../2026-08-19-c921-integral-glued-model.md`. The paper-side bundle is
`papers/cubic-stabilization-epilogue/verification/a5-pencil-eckardt-locus.*`.

## The mechanism to try first

The Eckardt locus, the complex-multiplication locus and the locus of members
with automorphisms beyond `A_5` are the same two points. That is unlikely to be
a coincidence, and it suggests the proof:

1. An Eckardt point of a smooth cubic threefold `X` gives an involution of `X`
   — reflection in the tangent hyperplane section's vertex. So a member with an
   Eckardt point has an automorphism group strictly larger than the `A_5` acting
   on the whole pencil, unless that involution is already in `A_5`, which has no
   element acting as such a reflection on `W_5`.
2. The `A_5`-stable Eckardt scheme is then a union of `A_5`-orbits; thirty is
   the orbit size with stabilizer of order two, which is the reflection's own
   stabilizer. Pin the orbit structure.
3. Members of the pencil with automorphisms beyond `A_5` should be classifiable
   directly from Hartlieb's automorphism classification of `A_5`-invariant
   cubic threefolds (Theorem 2.1 and Lemma 5.5 there), which the epilogue
   already cites for a different purpose.

If that chain closes, it proves the statement with no computation and explains
why it is true, rather than only that it is.

## Acceptance

- A proof that needs no symbolic program, checkable by a referee by hand.
- `prop:A5-not-coprime` restated with the computation demoted to a
  cross-check rather than a premise, and its `\evidence` annotation dropped or
  re-scoped accordingly.
- Then, and only then, `thm:separation-family` may name the Fermat point; that
  edit also requires C910 to sharpen `Applications.SeparationFamilyConclusion`,
  since the Lean conclusion would otherwise be strictly weaker than the
  manuscript's and the row would fall to `fragment`.

## What this task does not own

The genus-five branch of C921, the Schottky degeneration count, and the closed
form for Hartlieb's elliptic factor. Those stay with C921 and its successors.
