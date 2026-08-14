# C907 — AKMW pi-nonsingular elementary circuits have unit coefficients

Date: 2026-08-13

Status: exact combinatorial/source theorem.  Morelli pi-nonsingularity forces
every coefficient of an elementary projected circuit to be `+1` or `-1`.
Therefore the smooth projective elementary pieces in the AKMW
pi-desingularized cobordism are semi-free unit-coefficient standard walls
(or blowups/down), not index-two weighted walls.  Combined with the
fivefold standard-wall portfolio, this closes the remaining **geometric
coverage** gate for Gold.  It does not close the analytic adjacent-receiver
coherence gate for discrepant walls.

## 1. Exact source definition

Let `N^+=N+Z v_0` and let

\[
 \pi:N^+_\mathbf Q\longrightarrow N_\mathbf Q
\]

be projection along `v_0`.  A cone is `pi`-independent when `pi` is
injective on its span.  Wlodarczyk, *Simple Constructive Weak
Factorization*, Definition 3.6.1, recalls Morelli's definition:

> an independent cone `tau` is pi-nonsingular iff `pi(tau)` is a nonsingular
> cone; a fan is pi-nonsingular iff all its independent cones are
> pi-nonsingular.

For a dependent cone, every independent face must therefore project to a
regular cone.  Wlodarczyk's Lemma 3.6.2 writes the unique primitive relation
among the primitive projected rays and shows that the induced common ray
gives nonsingular star subdivisions on both boundaries.

AKMW Theorem 2.7.1 applies Morelli pi-desingularization to the whole
toroidal cobordism.  It states that each elementary piece of the resulting
pi-nonsingular cobordism is a toroidal blowup followed by a toroidal blowdown
between nonsingular toroidal embeddings, with nonsingular centers; when the
endpoints are projective the intermediate varieties can be chosen
projective.

## 2. Cofactor lemma

Let `sigma=<v_1,...,v_k>` be a circuit and let `w_i` be the primitive
generator of the ray `pi(v_i)`.  There is a primitive relation

\[
 \sum_{i=1}^k r_iw_i=0,\qquad \gcd(r_1,\ldots,r_k)=1.               \tag{1}
\]

Every proper face of a circuit is independent.  In particular, for each
`i`, the `k-1` vectors `{w_j:j ne i}` span a regular cone.  Let

\[
 L=N\cap\operatorname{span}_\mathbf Q(w_1,\ldots,w_k).
\]

The complementary `k-1` vectors form a saturated rank-`k-1` sublattice of
`N`, and their rational span is `L_Q`; hence they form a `Z`-basis of `L`.

The coefficients of the primitive relation (1) are, up to one common sign,
the maximal cofactors of the matrix with columns `w_i`.  Computing those
cofactors in the lattice `L`, every complementary determinant is `+1` or
`-1`.  Therefore

\[
 \boxed{|r_i|=1\quad\text{for every }i.}                            \tag{2}
\]

No coefficient two can occur in a pi-nonsingular circuit.

## 3. Geometric consequence

Separate the circuit rays by the sign of (1):

\[
 I_+=\{i:r_i=1\},\qquad I_-=\{i:r_i=-1\}.                          \tag{3}
\]

The two boundary fans differ by the bistellar move replacing the simplex on
`I_+` with the simplex on `I_-`.  Equation (2) gives the ordinary
unit-coefficient local wall:

\[
 P_S(V_+)\subset X_+,qquad P_S(V_-)\subset X_-,
\]

with

\[
 N_{P_S(V_+)/X_+}=\psi_+^*V_-\otimes O(-1),
 \qquad
 N_{P_S(V_-)/X_-}=\psi_-^*V_+\otimes O(-1).                        \tag{4}
\]

Here `S` is the smooth toroidal stratum of the elementary piece; toroidal
normal directions globalize the local ray coordinates to the indicated
normal bundles.  If one sign set has one element, (4) is a smooth blowup or
blowdown.  Otherwise it is exactly a semi-free standard wall.  A finite
disconnected stratum is split into its elementary connected components.

Equivalently, the circuit character supplies a primitive relative wall
polarization of degree one on every projective-space fibre.  The local
section algebra is generated in degrees `+1` and `-1`, and the ideal generated
by nonzero degrees is the prime ideal of the smooth wall stratum.  Thus the
wall also satisfies Gu--Yu--Yu Lemma 6.9.  This formulation avoids requiring
the original AKMW master itself to be the smooth master used by Gu--Yu--Yu:
their lemma reconstructs one from the unit-graded wall algebra.

In particular, for the fivefold point `(1,3)` row, the restriction index `d`
of `2026-08-13-c907-point-13-standard-wall-index-dichotomy.md` is one.  The
index-two/root-stack alternative cannot be produced by an AKMW
pi-nonsingular elementary circuit.

## 4. Gold consequence and boundary

After pi-desingularization, the elementary direct-wall chain has smooth
projective chamber varieties and only the standard types in the dimension
five portfolio:

- blowups/down;
- ordinary projective-bundle flops;
- discrepancy-one curve `(1,2)` walls;
- index-one point `(1,3)` walls;
- point `P^2` flops.

The ordinary walls have the intrinsic C907 point-row theorem.  The
discrepant walls have Gu--Yu--Yu's full pairing-compatible QDM decomposition
and the C907 fixed-sector Gamma-rank identity.  Hence there is no remaining
weighted, singular-quotient, or nonstandard **geometric** wall in this
chosen pi-desingularized factorization.

Gold is nevertheless not proved.  On a discrepant wall the Gamma-rank
identity still lives in that wall's fixed exceptional-parameter/sector
receiver.  At an adjacent wall, the same intermediate variety is realized
through another receiver, and no theorem proves that the transition
stabilizes its primitive-sixth packet and rank row.  Unit circuit
combinatorics does not supply this analytic Stokes/central-connection datum.

Thus the campaign has one remaining gate, not three:

> construct a coherent intrinsic rank-row realization for consecutive
> discrepant unit walls, or prove that their incident Stokes transition fixes
> the rank Boolean.

## EJ / TT / AA

- **EJ:** pi-nonsingularity is exactly the determinant-one hypothesis: all
  circuit cofactors are units, so every wall weight is `+/-1`.
- **TT:** AKMW's earlier locally toric quotients can have cyclic
  singularities.  The unit conclusion applies only after the explicit
  Morelli pi-desingularization of Theorem 2.7.1.
- **AA:** do not spend further work on weighted AKMW coverage for Gold.
  Attack the incident-receiver transition on the now finite unit-wall chain.

## Sources

- Wlodarczyk, *Simple Constructive Weak Factorization*,
  arXiv:math/0601649v1, Definition 3.6.1 and Lemma 3.6.2.
- Abramovich--Karu--Matsuki--Wlodarczyk, *Torification and factorization of
  birational maps*, arXiv:math/9904135, Theorem 2.7.1; cached SHA-256
  `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`.
- The cofactor/unit-circuit argument and the Gu--Yu--Yu criterion application
  are the derivations of this note.
