# Expert proof persona — local-unitary rigidity of stabilizer AME states

**Scope guard:** Required only for proofs in `papers/ame_lu/`. Do not preload it for classical
MDS, Clebsch, or general stabilizer-state work.

Predicted questions and “tears” are editorial inferences, not quotations.

## Proof room

The paper proves LU-to-LC rigidity for additive stabilizer AME states, factorwise Clifford
rigidity for transversal encoder conversions, and exact logical Clifford groups for MDS–CSS
specializations. The best lead is **Maarten Van den Nest** for the LU/LC boundary. The compact team
is:

- **Van den Nest + David Gross** — stabilizer-state equivalence and phase-space structure;
- **Markus Grassl + Felix Huber** — AME/QMDS codes and code–entanglement translation;
- **Martin Rötteler / Markus Grassl** — code automorphisms and transversal logical gates;
- **Simeon Ball or Michel Lavrauw** — six-arc/MDS geometry in the concrete applications.

## Lenses

| Lens | Mastery | Required question | Elegant close |
| --- | --- | --- | --- |
| Van den Nest / Gross | stabilizer normal forms, LU/LC equivalence, Clifford phase space | Why does AME force a local unitary intertwiner to normalize each Pauli factor? | Reconstruct local Pauli axes from minimum-support marginals |
| Grassl / Huber | AME states, QMDS bounds, stabilizer and CSS codes | Are state, code, and encoder formulations exactly equivalent? | One Choi/stabilizer theorem covering all three |
| Grassl / Rötteler | automorphisms, logical Clifford gates, fault-tolerant code actions | Is the claimed projective transversal group exact, not merely contained? | Kernel/image computation with scalar quotient explicit |
| Ball / Lavrauw | MDS arcs, GRS/non-GRS loci, projective stabilizers | Which logical phases are geometric and which are quantum conventions? | Derive the dichotomy from diagonal isoduality of the arc |

**Tears (inference):** maximal entanglement makes the local Pauli geometry observable from reduced
states, forcing every LU equivalence into the Clifford normalizer and turning an analytic symmetry
problem into finite symplectic geometry.

## Hard-proof routing

- General LU-to-LC theorem: Van den Nest–Gross.
- AME/QMDS/CSS equivalences and Choi transport: Grassl–Huber.
- Exact transversal logical group and scalar quotient: Grassl–Rötteler.
- Six-party pencil, GRS locus, and finite-arc applications: Ball–Lavrauw.
- Extension-field or additive-code subtleties: add an expert in finite symplectic modules; do not
  extrapolate an odd-prime argument.

## External reading when stuck

- Van den Nest–Dehaene–De Moor on LU versus LC equivalence, including the known global failure
  boundary.
- Stabilizer formalism over prime powers, local Clifford/symplectic correspondence, and Choi
  transport.
- Grassl/Huber on QMDS codes and AME states.
- Eastin–Knill/transversal-gate context only for positioning; the exact finite group here must be
  proved directly.
- MDS–CSS, diagonal isoduality, and six-arc projective equivalence for the concrete specialization.

## Referee mix

Use one LU/LC specialist (Van den Nest school), one AME/QMDS reader (Grassl or Huber), and one
transversal-gate or finite-geometry reader according to emphasis. Close-source authors are
priority-sensitive and should not be the sole novelty referees.

The proof standard is: state the class restriction in every headline—this is stabilizer-AME
rigidity, not a revival of the false global LU–LC conjecture.
