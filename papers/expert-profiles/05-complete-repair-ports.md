# Expert proof persona — complete bounded repair ports

**Scope guard:** Required only for proofs in `papers/complete-repair-ports/`. Do not preload it for
other coding, reliability, or finite-geometry papers.

Predicted questions and “tears” are editorial inferences from public work, not quotations.

## Proof room

The paper joins complete normalized repair equations, exact weighted trace-dual transfer,
positive-density realization, reliability/EXIT, pointed Tutte structure, and finite-geometric
fingerprints. No one referee spans it. The closest single lead is **Alberto Ravagnani**, who would
ask what the invariant remembers beyond refined support data. The compact team is:

- **Ravagnani + Thomas Britz** — code invariants, duality, matroids, Tutte theory;
- **Michel Lavrauw** — finite geometry, arcs, normal rational curves, MDS codes;
- **Eitan Yaakobi or Itzhak Tamo** — operational storage/LRC meaning;
- **Svante Janson + Ryan O'Donnell** — reliability, influence, Poisson windows;
- **Henning Stichtenoth or Chaoping Xing** — asymptotically good AG outer codes.

## Lenses

| Lens | Mastery | Required question | Elegant close |
| --- | --- | --- | --- |
| Ravagnani / Britz | MacWilliams duality, support weights, matroid polynomials, deletion–contraction | Is the coefficient port stronger than known support data, and why does the unfiltered perspective forget radius? | A universal transform plus symbolic filtration counterexample |
| Lavrauw | projective arcs, orbit geometry, MDS codes | Are the cubic and harmonic ports intrinsic or coordinate censuses? | One projective mechanism producing the fingerprints |
| Yaakobi / Tamo | locality, availability, access, bandwidth, storage bounds | What operational guarantee follows from coefficient equality? | A compositional repair theorem using exactly the transported layers |
| Janson / O'Donnell | dependency graphs, \(p\)-biased analysis, pivotality, Russo–Margulis | Are the blocker constant, overlap error, EXIT sign, and threshold claim exact? | One finite multilinear identity feeding the asymptotics |
| Stichtenoth / Xing | AG codes, trace duality, towers, asymptotic bounds | What is the minimal outer interface, and which explicit family meets it? | Rate, distance, and diverging dual distance instantiated from one tower |

**Tears (inference):** exact trace-dual confinement transports a coefficient-bearing finite
fingerprint at positive density in a good family, while reliability and pointed Tutte theory appear
as canonical but strictly coarser shadows.

## Hard-proof routing

- C675 reliability and bounded EXIT: Janson–O'Donnell.
- C676 pointed Tutte and filtration boundary: Britz–Ravagnani.
- C677 harmonic port: Lavrauw plus Simeon Ball/Daniele Bartoli.
- Final coding significance: Yaakobi/Tamo; include Frédérique Oggier for repair-tolerance priority.
- Explicit outer family: Stichtenoth/Xing.
- Lean implementation: relevant lens plus a mathlib maintainer; definitions follow the conceptual
  proof, and finite computation only checks.

## Proof boundary and external reading when stuck

- Keep the manuscript definitions, exact confinement/transfer, prescribed density, and the
  theorem/proof ledger. Never upgrade support equality to coefficient equality or bounded EXIT to
  MAP/capacity.
- **Invariant/Tutte:** Greene, Las Vergnas perspectives, Wei weights, and Britz,
  [“MacWilliams Identities and Matroid Polynomials”](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v9i1r19).
- **Reliability:** O'Donnell,
  [*Analysis of Boolean Functions*](https://www.cs.cmu.edu/~odonnell/papers/Analysis-of-Boolean-Functions-by-Ryan-ODonnell.pdf);
  Janson–Łuczak–Ruciński on thresholds and Poisson approximation.
- **Geometry:** Ball–Lavrauw on arcs; cited twisted-cubic orbit and harmonic cross-ratio literature.
- **Asymptotics:** Stichtenoth; exact Garcia–Stichtenoth/TVZ input; trace pairing and restriction.
- **Storage:** Oggier's repair-tolerance predecessor; locality/availability; access and bandwidth.

## Referee mix

Use one of Ravagnani/Britz, one of Yaakobi/Tamo, and one of Lavrauw/Van de Voorde. Add a probability
or AG specialist only when that section is load-bearing. Closest-prior authors are
priority-sensitive and should not be sole novelty referees.

The proof standard is: Ravagnani asks what is forgotten; Britz asks for the universal minor law;
Lavrauw asks for intrinsic geometry; Yaakobi/Tamo asks what the system gains; Janson/O'Donnell asks
for the exact finite identity; Stichtenoth/Xing asks where the outer input enters.
