# Paper IV's octahedral--toric correspondence

**Date:** 2026-08-04  
**Task:** C682  
**Lane:** `clebsch`  
**Status:** Exact research bundle; no manuscript, Lean, or release file changed

## Result

The one-octahedral/three-toric decomposition of the minimum words in Clebsch
Paper IV does not come from a compactified pencil of conics.  It has a stronger
discrete replacement.

Put

\[
G=\operatorname{PGL}(2,13).
\]

Let \(\mathcal O\) be the orbit of ninety-one octahedral minimum supports,
with point stabilizer \(S_4\), and let \(\mathcal T_5\) be the orbit of
ninety-one punctured-conic minimum supports with parameter \(r=5\), with point
stabilizer \(D_{24}\).  Define an incidence relation by

\[
 O\sim T
 \quad\Longleftrightarrow\quad
 \left|\operatorname{Stab}_G(O)\cap\operatorname{Stab}_G(T)\right|=8.
\]

The intersection has element-order profile
\(1^1 2^5 4^2\), hence is dihedral of order eight.  This relation is a
connected, flag-transitive cubic bipartite coset geometry

\[
 S_4\longleftarrow D_8\longrightarrow D_{24}
\]

on \(91+91\) vertices.  An incident pair of vertex stabilizers generates all
of \(G\).

For every \(O\in\mathcal O\), let \(T_1,T_2,T_3\) be its three neighbors.
For every \(T\in\mathcal T_5\), let \(O_1,O_2,O_3\) be its three neighbors.
Then the support identities are

\[
 \boxed{O=T_1\mathbin\triangle T_2\mathbin\triangle T_3},
 \qquad
 \boxed{T=O_1\mathbin\triangle O_2\mathbin\triangle O_3}.
\]

Each incident octahedral--toric pair meets in four coordinates.  Thus the
octahedral word, which lies on no conic, is the characteristic-two
superposition of three canonically adjacent punctured-conic words.

Let \(N_O,N_5\) be the two \(91\)-by-\(78\) support matrices and let \(C\)
be the \(91\)-square incidence matrix of the correspondence, with rows indexed
by \(\mathcal O\).  Over \(\mathbf F_2\), the preceding identities are

\[
 CN_5=N_O,
 \qquad
 C^{\mathsf T}N_O=N_5.
\]

Consequently \(C\) and \(C^{\mathsf T}\) restrict to mutually inverse
neighbor-sum transforms on the two thirty-six-dimensional support-incidence
images.  In particular,

\[
 \boxed{N_O^{\mathsf T}N_O=N_5^{\mathsf T}N_5=A_9}.
\]

This explains the previously unexplained Gram collision: the octahedral and
\(r=5\) toric families are two nonconjugate homogeneous binary frames for the
same elliptic relation operator, related by an intrinsic double-coset Radon
transform.

The bipartite graph has \(273\) edges, girth twelve, and binary adjacency rank
\(77\), hence nullity fourteen.  Distinct vertices on one side have at most
one common neighbor: \(273\) pairs have one and \(3822\) have none.

## The corrected three-plus-one structure

The three toric families give the Frobenius packet

\[
 T_5,T_2,T_{11}\longmapsto A_9,A_{10},A_{12}.
\]

On the canonical operator field \(K\cong\mathbf F_8^{12}\), these are the
three Frobenius-conjugate nontrivial scalars
\(\alpha,\alpha^2,\alpha^4\).  The octahedral family is a second homogeneous
factorization over the \(A_9\) member, connected to \(T_5\) through the
\(D_8\)-amalgamated transform.  The accurate organization is therefore

\[
 \boxed{
 \text{three toric Frobenius Gram classes}
 \; + \;
 \text{one octahedral lift over }A_9.}
\]

This is an algebraic unification, not a geometric degeneration.  It fits the
series' recurrent mechanism: extremal support data reconstruct an incidence
correspondence, an operator algebra, and a marking of one of its spectral
classes.  It should not be described as a new appearance of the Clebsch
*cubic* merely because the correspondence graph has degree three.

## Why the compactified-pencil proposal fails

The literal version of route 2 is excluded in the exact searched domain.

- Each toric support lies on a unique conic and has quadratic-evaluation rank
  five.  The octahedral support lies on no conic and has rank six.  Since lying
  on a conic is closed, the latter cannot be a boundary specialization of the
  former.
- A fixed-chord pencil retains dihedral stabilizer type and cannot acquire the
  nonisomorphic octahedral stabilizer by a tame twist.
- The complete internal fixed-chord levels are
  \(r=2,3,5,9,11,12\), with a size-six boundary at \(r=0\).  Exactly
  \(r=2,5,11\) have zero passant syndrome; there is no fourth codeword fibre.

The new correspondence supersedes that failed architecture rather than
repairing it.

## Companion delegated probes

The route-1 result now has its own committed exact bundle at
`notes/2026-08-04-c682-paper-ii-octahedral-transfer.md`; route 3 remains
advisory until its finite-field construction receives a separate bundle.

### Route 1: common octahedral carrier

The Paper-II \(B_3/\mathbf F_7\) family and Paper IV's octahedral family are
two faithful decorations of the moduli of self-normalizing octahedral
subgroups, but not literal specializations of one matching.

- At \(q=7\), \(S_4\) acts on the eight conic points as \(S_4/C_3\) and
  fixes one perfect matching, the cube-antipodal \(B_3\) matching.
- At \(q=13\), the conic points split into octahedral orbits of sizes six and
  eight, while the minimum support is the unique zero-syndrome internal orbit
  \(S_4/C_2\), the twelve-edge cube set.
- Paper IV's matching tensor avoids the antipodal relation used by Paper II.
  Thus the common object is the octahedral marking, with distinct vertex and
  edge covariants in the two papers.

### Route 3: golden refinement over \(\mathbf F_{169}\)

The proposed \(A_5/C_5\) norm--pole construction is false, although its group
completion premise is correct.

- A rational \(A_4\) has two Frobenius-conjugate \(A_5\) completions over
  \(\mathbf F_{169}\), their intersection is exactly \(A_4\), and the
  surrounding \(S_4\) exchanges them.
- But \(5\mid169+1\), not \(169-1\).  The order-five elements are nonsplit,
  so there is no twelve-point \(A_5/C_5\) orbit on
  \(\mathbf P^1(\mathbf F_{169})\).  It first appears over
  \(\mathbf F_{169^2}\), where the \(\mathbf F_{13}\)-Frobenius orbits have
  length four rather than two.  The proposed rational-chord norm is therefore
  unavailable.
- Nearby \(A_5/C_3\) and \(A_5/C_2\) norm shadows have nonzero syndrome and
  the wrong matching profiles.
- A weaker positive shadow survives: the two regular \(A_5\) orbits have
  norm--pole images whose common components include the Paper-IV octahedral
  orbit, and that orbit is the unique zero-syndrome component common to the
  relevant shadows.  This is computationally real but currently lacks the
  conceptual force of the failed \(A_5/C_5\) proposal.

## Evidence and replay

The committed checker constructs the two \(G\)-orbits from Paper IV's tracked
representatives, computes all vertex stabilizers, defines the correspondence
from the stabilizer-intersection order, and verifies both symmetric-difference
identities coordinate by coordinate.  It independently recomputes both Gram
matrices from the support rows and compares them with the \(\rho=9\) relation
matrix.  It also checks degrees, connectedness, girth, binary rank, common-
neighbor counts, the edge-stabilizer order profile, and generation of all
\(2184\) elements of \(G\).

Replay from the repository root:

```sh
python3 notes/2026-08-04-c682-paper-iv-orbit-correspondence.py --check
sha256sum -c notes/2026-08-04-c682-paper-iv-orbit-correspondence.sha256
```

The computation is deterministic, uses no randomness and only the Python
standard library, and takes about five seconds on the present host.  Its
load-bearing input is
`papers/q13-passant-code/verification/verify_minimum_geometry.py`, whose
representatives and exact finite-field operations are reused rather than
copied.  The JSON certificate records the bounded output.

This is one implementation with several independent invariant checks, not two
independent implementations.  It proves the stated facts for the explicitly
exhausted \(q=13\) group action.  A human double-coset proof of the two XOR
identities remains desirable.  No novelty claim is made; the cubic coset graph
and the associated Hecke/Radon transform require a literature audit before
paper promotion.

## Open questions

1. Give a coordinate-free double-coset proof of the two neighbor-sum
   identities.
2. Identify the fourteen-dimensional kernel of \(C\).  Its dimension equals
   the number of conic points, but no module identification is asserted.
3. Decide whether the full minimum hypergraph canonically selects \(A_9\) and
   thereby rigidifies the Frobenius ambiguity of the recovered \(\mathbf F_8\).
4. Determine whether the \(182\)-vertex cubic coset graph is classical.
5. Decide whether the weaker regular-orbit golden norm shadow has a conceptual
   formulation worth retaining after the stronger octahedral--toric transform.
