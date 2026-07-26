# Expert proof persona — Clebsch factorization memory

**Scope guard:** Required only for proofs in `papers/clebsch-factorization/`. Do not load it for
Clebsch rigidity or Clebsch passages.

Predicted questions and “tears” are editorial inferences, not quotations.

## Proof room

The paper studies quadratic recovery and cubic orientation in conic matching quotients, with ranks
\(3,6,10\), self-associated arithmetically Gorenstein evaluation sets, modular depth, and arithmetic
splitting. No one field owns it. The compact proof room is:

- **David Eisenbud + Frank-Olaf Schreyer** — Gorenstein schemes, syzygies, self-association;
- **Igor Dolgachev + Laurent Manivel** — classical invariant theory and representation geometry;
- **Michel Lavrauw** — finite conic/matching geometry;
- **Anne Henke / Alison Parker** — defining-characteristic modular structure when that appendix is
  load-bearing.

## Lenses

| Lens | Mastery | Required question | Elegant close |
| --- | --- | --- | --- |
| Eisenbud / Schreyer | Gorenstein ideals, Gale duality, Hilbert functions, free resolutions | Why do matching quadrics recover the set, and exactly where is one-factorization used? | A resolution or apolarity theorem forcing ranks \(3,6,10\) |
| Dolgachev / Manivel | invariant theory, homogeneous representations, classical configurations | Is cubic orientation canonical or a coordinate sign choice? | Identify it as the unique equivariant cubic line |
| Lavrauw | conics, matchings, projective actions, finite fields | Which quotient statements are geometric and field-uniform? | Derive the quotient basis from orbit/incidence structure |
| Henke / Parker | modular representations, projective covers, Frobenius phenomena | Which depth/splitting claims survive extension fields? | A block-theoretic criterion replacing prime-by-prime cases |

**Tears (inference):** the combinatorial one-factorization, the Gorenstein resolution, and the
unique cubic orientation become the same representation-theoretic object.

## Hard-proof routing

- Quadratic recovery and Hilbert symmetry: Eisenbud–Schreyer.
- Cubic orientation and invariant line: Dolgachev–Manivel.
- Finite conic quotient and orbit statements: Lavrauw.
- Extension-field block support and modular depth: Henke–Parker.
- Arithmetic gluing: add Brian Conrad only for the exact descent/localization step.

## External reading when stuck

- self-associated point sets, Gale duality, Cayley–Bacharach, and arithmetically Gorenstein schemes;
- Buchsbaum–Eisenbud structure and the relevant minimal-free-resolution calculations.
- Classical invariant theory of the Clebsch/icosahedral representations.
- Keep the paper's quotient convention and exact one-factorization hypothesis in immediate context;
  do not infer completeness from a finite profile table.

## Referee mix

Use one commutative algebraist (Eisenbud/Schreyer school), one invariant geometer
(Dolgachev/Manivel), and one finite geometer (Lavrauw or Van de Voorde). Add a modular specialist
only if the depth appendix remains in the theorem spine.

The proof standard is: explain the ranks and orientation structurally before presenting matrices.
