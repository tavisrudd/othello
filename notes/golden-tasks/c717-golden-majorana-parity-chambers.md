# C717 — Golden Majorana parity chambers

**Lane:** `golden`

**Status:** complete 2026-07-31; research only, no manuscript edit

## Objective

Classify the real control-space chamber structure cut out by the six
Majorana gap walls
\(\operatorname{Pf}[D_x,C_T]=4Z_T(x)=0\), and determine what the Segre
relations force about simultaneous parity switches.

## Gates

1. Fix the physical control domain, projective compactification, and the
   distinction between Pfaffian zero, spectral gap closing, and ground-state
   parity after an orientation convention.
2. Determine irreducible wall components, singular strata, pairwise and
   higher intersections, and their ranks/zero-mode multiplicities.
3. Classify the chambers meeting the real cube, their sign vectors, and
   adjacency across a generic wall.  Derive constraints from
   \(\sum_T\operatorname{Pf}A_T=
   \sum_T(\operatorname{Pf}A_T)^3=0\).
4. Locate the 20 balanced optima, 44 null Boolean controls, Segre nodes, and
   C709 rank-two dimers in the chamber complex without relying on brute-force
   enumeration.
5. Test loops around singular strata for monodromy, synchronized parity
   switching, or a parity pump.  State a negative obstruction if no
   protected topological invariant exists in this zero-dimensional family.
6. Compare with established class-D parity-switch and interferometric
   readout literature before using topological language.

## Acceptance

- A structural chamber/adjacency theorem or a sharp obstruction identifying
  why such a theorem cannot be canonical.
- Exact low-dimensional witnesses and independent replay for the real
  chamber census.
- A proof-level separation of algebraic Pfaffian constraints from genuine
  topological protection.

## Boundary

No Majorana-zero-mode or topological-qubit claim follows merely from a
finite skew Hamiltonian and a Pfaffian sign.

## Dependencies

C720 freezes the paper interface; C707 and C709 are complete.  This task
may run independently of C715.

## Resolution

The oriented real control sphere, equivalently the translation quotient of
the physical cube, has exactly 860 connected gapped chambers.  The 50
allowed parity vectors have weights two, three, or four.  Every unbalanced
vector has 24 chambers; every balanced vector has seven, with the balanced
Boolean optimum in its unique large chamber.  The generic adjacency graph
is connected of diameter ten, has 2,160 edges, and has degree distribution
\(3^{720},12^{120},36^{20}\).
It is exactly the coset-incidence graph of a regular \(S_6\)-orbit with
balanced stabilizers
\(S_3\times S_3,S_3\times S_2,S_3\times S_2\); the two 60-vertex pole
orbits are exchanged by the antipodal control involution.  The subgroup
factor width is five, explaining the graph diameter ten.
The 140 balanced incidence vectors form the Young permutation module
\(M^{(3,3)}\oplus2M^{(3,2,1)}\).  Their exact incidence Gram operator has
rank 138; its kernel consists only of the two differences among the three
orbitwise constant vectors.  Thus there is no hidden balanced-incidence
relation, and the full spectrum reduces to the six Specht multiplicity
spaces recorded in the report and certificate.  Exact central-character
moments label every block, including the otherwise ambiguous
\(S^{(5,1)}\) and \(S^{(3,3)}\) factors.
On the standard block, the antipode gives a canonical \(2+3\) splitting.
The even block has characteristic polynomial \(X^2-20X+48\); the odd block
has an eigenvalue-four dark line, and its quotient spectrum is exactly three
times the even spectrum.  This explains the shared splitting field
\(\mathbf Q(\sqrt {13})\) by the marked coset-intersection operator.
The threefold copy lifts to an integral intertwiner \(Q^-T=3TQ^+\).
All such intertwiners form a binary quadratic lattice of discriminant 52;
adjoining the eigenvalue-four dark line has minimum index 26, with an exact
mod-13 dependence.  Thus 13 is also the integral gluing obstruction between
the antipode sectors.

Exactly one, two, four, or six Hamiltonians can close simultaneously.  The
common six-wall locus is the fifteen-line unstable base scheme; its generic
points have rank four in every sister and its six vertices are the rank-two
C709 dimers.  No protected monodromy or parity pump survives: each gapped
six-Majorana class-D parity component is
\(SO(6)/U(3)\cong\mathbf P^3(\mathbf C)\), hence simply connected.
The sign-vector restriction also generalizes: for any nonzero real vector
with vanishing first and third moments, each sign occurs at least twice, and
every such sign pattern is realizable.

Full report and exact evidence bundle:
`notes/2026-07-31-c717-golden-majorana-parity-chambers.md` and
`notes/golden-tasks/c717-golden-majorana-parity-chambers.{py,json,sha256}`,
with independent replay
`notes/golden-tasks/c717-golden-majorana-parity-chambers-replay.py`.
