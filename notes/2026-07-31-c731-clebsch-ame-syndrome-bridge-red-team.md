# C731 — Clebsch AME syndrome bridge: referee and publication red team

**Date:** 2026-07-31
**Lane:** `ame-lu`
**Status:** complete; narrow adoption recommended

## Verdict

The Clebsch deep-hole theorem gives a correct and useful quantum corollary for
the equal-phase six-qudit state, but not a second headline theorem.  Its
publication value is the exact coexistence of two geometries in one tensor:

- the six parity-check columns form a nonconic arc, so the fixed-party logical
  symplectic image is the split torus; and
- the covering-radius (X)-error syndromes form a nonsingular conic with one
  (C_{10}\times A_5) orbit of 120 nonzero syndromes.

This belongs in the AME--LU paper as one proposition followed by one boundary
remark.  The Clebsch-rigidity paper remains the source of the conic, leader
counts, and automorphism theorem.  Golden already owns the exact statement
that the unlabelled conic is insufficient for its operator construction, so
no new Golden task is justified by this bridge.

## Exact proposition that survives review

Let (C=\ker H\) be the Clebsch ([6,3,4]_{11}) code and

\[
 |\Psi_C\rangle=11^{-3/2}\sum_{c\in C}|c\rangle .
\]

For (e,f\in\mathbb F_{11}^6),

\[
 X(e)|\Psi_C\rangle=X(f)|\Psi_C\rangle
 \quad\Longleftrightarrow\quad e-f\in C,
\]

and distinct cosets give orthogonal states.  The (Z)-type stabilizers with
labels in (C^\perp=\operatorname{row}(H)) measure the (X)-error syndrome
(He^{\mathsf T}).  The minimum number of sites on which an (X)-operator
creating this translated state can act is therefore the coset-leader weight
of (e+C).

The Clebsch deep-hole theorem then gives exactly twelve projective
covering-radius directions, the rational points of a nonsingular conic in
(\operatorname{PG}(2,11)).  Above them lie 120 nonzero syndromes.  Each has
twenty weight-three representatives.  The monomial group
(C_{10}\times A_5) is transitive on the 120 syndromes: (A_5) is transitive
on the twelve rays with point stabilizer (C_5), and (C_{10}) is transitive
on the ten nonzero vectors of each ray.

The defining Clebsch six-arc is nonconic.  The AME--LU logical-phase theorem
therefore gives the split torus (T\) as the fixed-party logical symplectic
image, rather than (\operatorname{SL}_2(11)).  This last sentence is the
non-generic synthesis supplied by the AME--LU paper.

## Referee attacks and required repairs

### 1. This is an immediate dictionary corollary

Correct.  The paper must not advertise the 120-count, conic, or (A_5) orbit
as new AME--LU results.  The contribution is the conjunction with LU rigidity
and the fixed-party logical phase.  A proposition/example is proportionate;
the abstract and main theorem hierarchy should remain unchanged.

### 2. “Quantum syndrome” may overstate the claim

The syndrome is the (X)-only sector measured by the (Z(C^\perp))
stabilizers.  Covering radius three does not say that the associated
([[5,1,3]]_{11}) output code corrects arbitrary weight-three errors.  The
safe operational statement is minimum support among generalized-(X)
operators creating a specified orthogonal translate of the six-leg Choi/AME
state.

### 3. “Twenty representatives” may sound like energy degeneracy

It counts minimum-support (X)-operators in one syndrome coset.  It becomes
an energy degeneracy only after a parent Hamiltonian with a specified energy
function is supplied.  AME--LU should make no Hamiltonian claim.

### 4. The symmetry level is easy to misstate

(A_5) is the projective stabilizer of the six column rays and the
support-permutation quotient of the monomial code automorphism group.  It is
safe to claim an (A_5)-covariant syndrome conic and the exact
(C_{10}\times A_5) monomial action.  It is unsafe to call (A_5) the full
party-moving AME symmetry without reconciling the larger party extensions.
AME--LU already shows that odd party motion may realize the nontrivial Weyl
element and enlarge the transported anchor carrier from (T) to (N(T)).

### 5. “No electric--magnetic duality” is too broad

The proved obstruction is fixed-party: no fixed-label transversal Fourier
symmetry exchanges (X) and (Z).  Party motion or a nontransversal circuit
may still implement such an exchange.  The proposition and its discussion
must retain “fixed-party” at every use.

### 6. The conic is coordinate-dependent

Changing the parity-check basis acts projectively on the syndrome plane.
The invariant assertion is that the twelve rays form a nonsingular conic,
not that they satisfy one privileged displayed quadratic equation.

### 7. The bare conic does not determine the Golden operator

C727 proves the precise information boundary.  The unlabelled conic has no
preferred Clebsch parent, coordinate six-set, support two-graph, or
orientation.  Golden begins from the monomial parent or its unordered
(10+10) support two-graph.  AME--LU may state this boundary in one sentence
but must not import the conference, Pfaffian, Majorana, Slater, or anomaly
portfolio.

### 8. The physical interpretation can outrun the theorem

The exact implications are perfect-tensor entanglement, minimum (X)-operator
support, symmetry covariance, fixed-party transversal-gate anisotropy, and
exact LU-to-LC equivalence rigidity.  Parent-Hamiltonian spectra, robustness
to approximate calibration, holographic-network behavior, SPT order,
topological order, and gauge-anomaly physics require new constructions.

### 9. Spherically confined icosahedral colloids share the (A_5/C_5) carrier, not the mechanism

De Nijs, Dussi, Smallenburg, et al., *Entropy-driven formation of large
icosahedral colloidal clusters by spherical confinement*, Nature Materials
14 (2015), 56--60, DOI `10.1038/nmat4072`, experimentally and numerically
finds Mackay and anti-Mackay icosahedral clusters of confined hard spheres.
The Mackay cluster comprises twenty deformed FCC tetrahedral domains and
twenty triangular facets; near melting its free energy is reported below the
confined FCC competitor by (0.03\pm0.01,k_BT) per particle.  The selection
mechanism is entropy under spherical confinement, with no attractive
interaction required.

There is an exact representation-theoretic overlap.  The twelve vertices of
an icosahedron form the transitive (A_5/C_5) set.  The twelve Clebsch
syndrome rays have the same stabilizer and hence the same abstract transitive
(A_5)-set; their six paired axes likewise match the six fivefold axes of the
icosahedron.  This makes an icosahedral supraparticle a plausible geometric
carrier for twelve syndrome channels or six signed axis modes.

No dynamical identification follows.  The colloidal paper studies excluded
volume, free energy, twinned FCC domains, and size-dependent crystallization;
it supplies no finite-field syndrome variables, signed conference coupling,
or quantum degrees of freedom.  In particular, its twenty tetrahedral domains
must not be identified with the twenty minimum-weight (X)-representatives
of one syndrome merely because the counts agree.  A publishable bridge would
need an explicit coarse-grained six-axis mode space and a derivation or fit
showing that its entropic Hessian contains the Golden signed operator.  Until
that gate passes, this connection belongs in neither AME--LU nor Golden
manuscript prose.

## Publication placement and gates

The preferred placement is immediately after the six-arc logical-phase
theorem, where both inputs are already defined.  The proof should be a short
composition of the equal-phase stabilizer dictionary, the Clebsch-rigidity
theorem, and the logical-phase theorem.  A following remark should state the
fixed-party/party-moving and bare-conic/marked-parent boundaries.

Adoption requires all of the following:

1. add a stable bibliographic reference to the Clebsch-rigidity paper and
   cite its exact conic, multiplicity, and automorphism results;
2. keep the AME--LU abstract, title, and principal theorem unchanged;
3. add no new numerical computation or duplicate evidence bundle;
4. update the theorem, novelty, verification, and formal-adequacy ledgers so
   the imported human proof is not described as Lean-checked;
5. check the party-action terminology against the q=11 extension table;
6. pass the paper's warning-free build, release manifest, visual inspection,
   and standalone-mirror synchronization gates.

If the Clebsch-rigidity paper lacks a stable public identifier at adoption
time, use an explicitly identified companion-manuscript citation or defer the
cross-paper proposition.  Do not cite an internal report in public prose.

## Queue decision

C732 owns the bounded manuscript adoption.  No Golden task is allocated:
C727 already proves and documents the only Golden-facing correction needed
here, and the colloidal comparison currently supplies only a common
(A_5/C_5) carrier.  Any explicit many-body Hamiltonian, tensor-network
realization, colloidal mode model, or fermionic laboratory model should first
pass a separate pre-allocation theorem gate rather than enter either
manuscript as interpretation.

## Vibe check

Good bridge, low proof risk, moderate wording risk.  Its value comes from the
nonconic-encoder/conic-error-shell contrast; expanding it into speculative
physics would weaken both papers.
