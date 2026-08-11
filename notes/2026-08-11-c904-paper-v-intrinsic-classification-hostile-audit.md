# C904 Paper V intrinsic classification: hostile structural audit

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** read-only theorem audit; no manuscript or Lean edits

## Verdict

**MAJOR, repairable.**  The lattice and modular tail V.E--V.H is close to
theorem-ready, but V.A--V.D is not yet an intrinsic classification theorem.
The earliest exact failure is the claimed elimination of scalar
automorphisms over every extension (K/\mathbf F_{11}).  The next is a
hidden choice of linear outer lift in the assertion that the module and one
actual chordal generator determine (q), (z), and all markings.

The current axioms also assume two of the central reconstruction conclusions:
the equality of the two recovered six-sets and the triangle identities that
are equivalent to a conference switching class.  Essential surjectivity from
those axioms is therefore largely a decoding theorem, not yet an
inevitability theorem.

The right repair is not to abandon the classification.  It is to separate
three layers:

1. a projective geometric carrier, with honest scheme-theoretic descent;
2. a linearization gerbe or explicit frame that controls central scalars;
3. a finite (C_2) orientation torsor only after the scalar issue is
   removed.

Then reduce the recognition axioms so that the six-set coincidence and
conference equations are proved rather than assumed.

## 1. Earliest counterexample: cubic generators do not kill scalars

Take

\[
                    K=\mathbf F_{11^2}.
\]

Since (|K^\times|=120), choose a nontrivial
\(\zeta\in\mu_3(K)\).  The scalar map

\[
                        f=\zeta I_A
\]

is a (K A_5)-module automorphism.  It commutes with every chosen normalizer
operator (q), fixes every point and subvariety of \(\mathbf P(A)\), and on
cubic forms acts by \(\zeta^{\pm3}=1\).  Consequently it fixes the actual
cubic vectors (h) and (z), their singular schemes, the two chordal lines,
the six nodes, and all triangle coefficients.

Thus the sentence

> carrier rigidity and preservation of actual generators kill hidden scalar
> automorphisms

is false after the advertised scalar extension.  The natural automorphism
group of the declared linear carrier contains central \(\mu_3\)-inertia.

Declaring that morphisms “come only from six-axis bijections and their
induced linear maps” does not solve this intrinsically.  Six projective-frame
points determine a projective transformation, but its lift to (GL(A)) is
only determined up to a scalar.  A cubic normalization determines that lift
only up to \(\mu_3\).  Choosing the identity rather than \(\zeta I_A\) for the
identity axis bijection is an extra linearization convention not contained
in the tuple.

This breaks the asserted full faithfulness and the literal equivalence on
\(K\)-points.  It also shows why a proof over \(\mathbf F_{11}\) does not
automatically extend: the cube map is bijective on
\(\mathbf F_{11}^{\times}\), but acquires a kernel over even-degree finite
extensions.

### Exact repair

Choose one of the following, and state it in the category definition.

1. **Projective repair.**  Use \(\mathbf P(A)\), the projective pencil, and
   projective cubic lines as the intrinsic carrier; use (PGL(A))-morphisms.
   Treat actual cubic normalization as a separate linearization gerbe and
   the orientation as a later (C_2)-torsor.
2. **Rigidified linear repair.**  Add a compatible linear frame or a datum of
   degree coprime to three, for example a determinant trivialization together
   with the cubic normalization.  This kills central \(\mu_3\), but it is a
   genuine marking and must be present in every source groupoid.
3. **Quotient repair.**  Define morphisms modulo the central \(\mu_3\) that
   acts trivially on all declared cubic/projective data.  Then do not call the
   resulting carrier a groupoid of ordinary linear-module isomorphisms.

Restricting to fields with \(\mu_3(K)=1\) would also remove the counterexample,
but it destroys the promised functoriality for every extension and is the
least useful repair.

## 2. The outer action is canonical only after another choice is exposed

The five-dimensional (A_5)-module is invariant under the nontrivial outer
class, but an intertwiner implementing that class is unique only up to a
scalar and an inner representative.  Even after imposing (q^2=1), the two
linear lifts (q) and (-q) remain.  On cubic forms their actions differ by
a minus sign, so their invariant and anti-invariant lines are exchanged.
Therefore the phrase

> every representative of the outer coset induces the same involution on
> the invariant pencil

is false for representatives in the full linear normalizer.  It is true
projectively after quotienting central scalars, or for the distinguished
permutation-normalizer lift supplied by a recovered six-set.

There is a viable intrinsic route, but it is not the one currently stated:

\[
 h\longmapsto R_h\longmapsto\Omega=A_5/D_5
 \longmapsto \text{permutation lift of the outer class}
 \longmapsto q_\Pi.
\]

The permutation lattice of \(\Omega\) removes the sign ambiguity that the
abstract module does not.  Alternatively, among the two linear lifts one may
try to select the lift whose anti-invariant pencil member has six ordinary
nodes; that requires a lemma proving uniqueness and that the other eigenspace
does not have the same singularity type.

The carrier should retain only the induced normalized operator
\(q_\Pi\) on the invariant pencil.  An actual operator \(q\in GL(A)\) is too
much data: different involutions in the outer normalizer coset differ by
inner elements, act identically on \(\Pi\), and need not be isomorphic under
strictly (A_5)-equivariant morphisms.

Until one of these repairs is printed, the claim

\[
       (A,h)\quad\text{determines}\quad q, z=8^{-1}(q-1)h
\]

contains a hidden (S_5)-extension/linearization choice.

## 3. The recognition axioms currently contain the answer

Two axioms are load-bearing but too strong for the advertised theorem.

### 3.1 The six-set coincidence is assumed

Axiom 3 requires the normalizer quotient of the exact-(C_5) divisor to be
canonically identified with the nodal six-set.  That is precisely the main
geometric coincidence in the proposed chain

\[
                 R_h\rightsquigarrow\Omega
                 \quad=\quad\operatorname {Sing}(z).
\]

With this equality in the object definition, the inverse does not recover a
common carrier; it reads one from an axiom.

**Repair.**  Require separately that the nodal scheme is the transitive
six-point (A_5)-scheme and that the quartic has the standard tame
icosahedral action.  Then prove:

- the node stabilizer is (D_5);
- the exact-(C_5) divisor is the full twelve-point orbit;
- its equal-stabilizer quotient is another (A_5/D_5);
- the two are uniquely (A_5)-equivariantly isomorphic because
  (N_{A_5}(D_5)=D_5).

The last uniqueness is structural; it should replace the asserted
identification.

### 3.2 The conference reconstruction is assumed

The three displayed triangle conditions are exactly the recognition
criterion for a symmetric conference switching class: the tetrahedral
condition produces edge signs and pair balance is the off-diagonal equation
in (B^2=5I).  Essential-surjectivity steps 2--3 therefore merely unpack
axiom 5.

**Repair.**  Derive these identities from the (A_5)-invariant nodal cubic
after one coefficient normalization.  The two-dimensional invariant-pencil
calculation and the singular projective frame should force the triangle
line; one hand coefficient can then fix its scalar.  If pair balance must
remain an axiom, call V.A an exact polynomial recognition theorem and lower
the novelty claim accordingly.

With both Axiom 3 and Axiom 5 retained, “intrinsic” is formally true but
mathematically weak: the source matrix is omitted by name while its full
incidence and switching equations are inserted into the definition.

## 4. Field and scheme-theoretic repairs

The phrase “for every (K/\mathbf F_{11})” requires more than base change of
the displayed coefficients.

1. Replace “six reduced ordinary nodes” by a finite etale singular scheme of
   degree six, geometrically ordinary, together with either a proof of
   splitness or an identification with the constant (A_5/D_5)-scheme.
2. Replace “the two chordal lines” by a finite etale degree-two subscheme of
   \(\mathbf P(\Pi)\); a selected (K)-point then splits it.
3. Specify whether “rational normal quartic” means geometrically a rational
   normal quartic or an (A_5)-equivariantly split Veronese
   \(\mathbf P^1_K\hookrightarrow\mathbf P(A)\).  These are not equivalent
   over a general nonclosed field.
4. Define the exact-(C_5) divisor scheme-theoretically as the reduced tame
   fixed-point strata and prove it is finite etale of degree twelve.  One
   point with stabilizer (C_5) gives a twelve-point orbit but does not by
   itself prove that this orbit exhausts the exact-(C_5) locus.
5. Construct the quotient by the fixed-point-free normalizer involution as a
   finite etale quotient, not as a pairing of geometric points.
6. State the action convention on \(\operatorname {Sym}^3(A^*)\).  The sign
   of the matrix for (q) and the scalar (8) depend on whether forms are
   transported by pullback or inverse pullback.

Reynolds idempotents do prove that the invariant pencil commutes with scalar
extension because (11\nmid|A_5|\).  They do not settle the central inertia,
splitness, descent, or normalization issues above.

The clean uniform theorem is an equivalence of algebraic groupoids/stacks
over \(\mathbf F_{11}\).  A theorem stated only as separate equivalences on
all (K)-points must still prove compatibility with descent and the changing
automorphism groups.

## 5. The marking poset is not a Boolean poset of the listed data

Several proposed markings determine one another:

- an actual nonzero (h) determines (L=Kh);
- choosing (h) already chooses its sign;
- once (q_\Pi) and the normalization are fixed, (h) determines
  (z=8^{-1}(q_\Pi-1)h);
- (z) determines its nodal six-set, while (h) determines the quartic
  normalizer quotient.

Therefore a vertex that remembers (h) but forgets (L) is isomorphic to
the original vertex, and “actual generator” and “its sign” are not two
independent markings.  Conversely, forgetting an unnormalized actual vector
while retaining its line has fibre (K^\times), not (C_2).  It becomes a
two-point fibre only after an explicit quadratic normalization has been
defined and proved to be nondegenerate.

**Repair.**  First define a closure operator on markings: a set of retained
data is replaced by everything it canonically determines.  V.D should be the
Hasse diagram of closed marking sets, not the power set of the bullet list.
For every normalized-generator edge, print the actual normalization equation
and its group scheme of solutions.  Only then identify a fibre with
\(\mu_2\) or a constant (C_2\).

The central \(\mu_3\)-inertia from Section 1 must be included in every
stabilizer table until it is quotiented or rigidified.  Otherwise the claimed
principal (C_2)-cover in V.F is not the whole residual marking groupoid.

## 6. Further proof-level corrections

### MAJOR

1. **V.A full faithfulness:** blocked by the projective/linear mismatch and
   \(\mu_3\)-inertia.
2. **V.A essential surjectivity:** currently tautological at the conference
   and common-six-set gates.
3. **V.B minimality:** blocked until the permutation lift or nodal-eigenline
   rule canonically selects (q_\Pi).
4. **V.C naturality:** cannot be formulated before the actual categories and
   their central inertia are fixed.
5. **V.D/V.F torsors:** the dependency lattice and stabilizers are presently
   mis-specified.

### MINOR

1. The character calculation proves that the invariant cubic space has
   dimension two.  It does **not** make every (A_5)-equivariant map into
   that space multiplicity-one; multiplicity one appears only after the
   normalized outer eigenspaces are specified.  Character theory also cannot
   label one eigenspace as chordal and the other as nodal, or determine the
   scalar (8) and pivot (3).  One exact geometric discriminator and one
   coefficient calculation remain load-bearing.
2. The determinantal lemma must prove
   \(H^0(\mathcal I_R^{(2)}(3))\) is one-dimensional, with the intended
   symbolic/saturated Jacobian scheme.  Equality of singular sets is not
   enough.
3. The exact-(C_5) argument needs the fixed-point count described above,
   not transitivity from one point alone.
4. In V.G, distinguish “the operator satisfies the displayed quadratic”
   from “its generated coefficient algebra is isomorphic to the displayed
   quadratic algebra.”  The latter also needs a short proof that the
   reduction of \(\varphi_B\) is not scalar.  The common-column argument
   should supply it.
5. In V.H, “canonical nonsplit sequence” is canonical relative to the
   selected \(\mathbf F_4\)-sheet and endpoint identifications.  The existing
   warning about the three rigidified Ext vectors must remain next to the
   theorem, not only in a later remark.

V.E's rank-five/rank-six lattice separation is sound and important.  V.G's
quadratic identity follows formally from (B^2=(n-1)I), and the proposed
minimal-lattice proof is plausible.  V.H's Ext dimension and uniqueness of
the unrigidified nonsplit middle module already have exact independent
certificates and a bounded source audit.  These later theorems should not be
held hostage to an overstrong V.A--V.D.

## 7. Novelty and preemption boundary

This review makes no new global literature-absence claim.  The bounded
priority audit in
`2026-08-11-c904-golden-extension-priority-placement.md` already establishes
the safe boundary for V.G--V.H: conference lattices over quadratic orders and
the relevant nonsplit characteristic-two (A_5)-modules have classical
predecessors.  The candidate novelty is their exact composition with the
recovered golden orientation, not either ingredient alone.

The same discipline is needed for V.A--V.D:

- the chordal cubic as the secant cubic of a rational normal quartic is
  classical geometry;
- the map (A_5/C_5\to A_5/D_5) is elementary subgroup theory;
- vanishing cohomology of a simplex gives the switching reconstruction
  formally;
- homotopy fibres and rigidification torsors are categorical language, not a
  theorem by themselves.

Accordingly, the genuinely auditable new claim is narrow:

> one minimal projective (A_5)-chordal carrier forces the specific nodal
> six-set, conference switching class, normalization lattice, and residual
> Frobenius sheet, with a sharp computation of every remaining marking
> fibre.

The current five axioms do not yet prove that statement because they encode
its two most surprising middle arrows.  Before venue language such as
Advances or Compositio is retained, the reduced-axiom theorem needs its own
claim-specific primary-source audit.  The earlier component audits do not
establish novelty of the combined intrinsic recognition theorem.

## 8. Prioritized repair order

1. **Fix the category first.**  Decide projective carrier plus gerbe,
   rigidified linear carrier, or quotient by \(\mu_3\).  Rewrite morphisms and
   scalar extension accordingly.
2. **Define (q_\Pi), not an arbitrary (q\in GL(A)\).**  Derive its
   normalized lift from the recovered permutation six-set or prove the
   unique nodal-eigenline rule.
3. **Remove Axiom 3's asserted identification.**  Prove the unique
   (A_5/D_5\)-isomorphism from stabilizers.
4. **Remove or demote Axiom 5.**  Derive triangle signs and balance from the
   nodal invariant cubic; otherwise advertise only polynomial recognition.
5. **Replace the marking power set by the closed dependency lattice.**  Add
   \(\mu_3\)-inertia and exact normalization group schemes to the table.
6. **State the theorem as a stack/base-change equivalence.**  Print finite
   etale and splitness hypotheses for nodes, chordal parameters, and the
   exact-(C_5) quotient.
7. **Only then prove units, counits, and triangle identities.**  They become
   formal after genuine full faithfulness, not before it.
8. **Keep V.E--V.H moving independently.**  They need only the recovered
   oriented six-set and conference operator, not the maximal V.A--V.D claim.

## 9. EJ + TT closeout / mystery ledger

- **Settled:** the all-field full-faithfulness claim has an explicit
  \(\mathbf F_{11^2}\) counterexample through central \(\mu_3\).
- **Settled:** the linear outer lift is not representation-theoretically
  canonical from (A) alone; the recovered permutation six-set can repair
  it.
- **Settled:** the proposed marking list contains redundant data and does not
  yet define finite fibres.
- **Open:** whether the nodal-eigenline property uniquely selects the correct
  lift of the outer projective involution.  Exact gate: compute the
  singularity schemes of both eigenlines.
- **Open:** whether Axiom 5 follows from the minimal geometric carrier.
  Exact gate: derive the normalized triangle coefficients and pair balance
  from (A_5)-invariance plus one scalar calculation.
- **Open:** whether the exact-(C_5) locus and nodal scheme form split finite
  etale schemes over every (K/\mathbf F_{11}\).  Exact gate: a tame
  fixed-locus and descent lemma.
- **Open:** the priority of the reduced-axiom intrinsic classification.
  Exact gate: a dedicated primary-source audit after its theorem statement is
  stable.

Vibe: the architecture has a strong theorem inside it, but the current
version hides one gerbe, one outer-lift choice, and two conclusions in its
axioms.  Repairing those four points would turn V.A--V.D from polished
repackaging into a real classification theorem.
