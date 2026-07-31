# C706 — equivariant Clebsch--Clifford phase lift

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** complete

## Outcome

The ordinary gauge-trivial Clebsch sign system has a genuine equivariant
refinement, but only on the golden subgroup.

1. The two-qubit Clifford extension modulo scalar phases
   \[
   1\longrightarrow \mathbf F_2^4
   \longrightarrow \operatorname{Cliff}_2/U(1)
   \longrightarrow \operatorname{Sp}_4(\mathbf F_2)
   \longrightarrow1
   \]
   does not split.  Under
   \(\operatorname{Sp}_4(\mathbf F_2)\cong S_6\), its obstruction is a
   nonzero class in
   \[
   H^2(S_6,\mathbf F_2^4).
   \]
2. Its restriction to the golden conference stabilizer
   \(A_5\subset S_6\) does split.  There are exactly \(64\) splittings,
   forming four orbits of size \(16\) under Pauli conjugation.  Therefore
   \[
   H^1(A_5,\mathbf F_2^4)\cong\mathbf F_2^2
   \]
   on this lift torsor.
3. The conference edge rephasing \(c(v_{ij})=[C_{ij}<0]\) has the property
   that
   \[
   \ell_g(v)=c(v)+c(gv)
   \]
   is linear in \(v\) exactly for the \(60\) elements of the golden
   \(A_5\), and for no other element of \(S_6\).  Hence it twists an
   \(A_5\) Clifford splitting to another splitting.  The two splittings
   lie in different Pauli-conjugacy orbits, so
   \[
   [\ell]\ne0\in H^1(A_5,\mathbf F_2^4).
   \]
4. The remaining scalar projective multiplier on this \(A_5\) is trivial.
   Exact four-dimensional intertwiners initially satisfy
   \[
   U_a^5=iI,\qquad U_b^2=I,\qquad(U_aU_b)^3=iI.
   \]
   Replacing \(U_a\) by \(-iU_a\) and \(U_b\) by \(-U_b\) makes all three
   \(A_5\) presentation relations equal to \(I\).
5. The order-\(120\) conference switching normalizer
   \(S_5=A_5\rtimes C_2\) is the exact boundary between the Clifford
   extension and the distinguished conference phase.  The Clifford
   extension still splits on this \(S_5\): it has \(32\) splittings in two
   Pauli-conjugacy classes.  However, the nonzero conference class on
   \(A_5\) is one of the two \(A_5\) classes that do **not** extend to
   \(S_5\).  Orientation reversal destroys the distinguished phase even
   though it does not destroy all Clifford complements.

Thus C706 is positive: the golden conference phase is invisible to
ordinary contextuality but survives as a nonzero *equivariant*
\(A_5\)-lift class.  It does not extend to a full-\(S_6\) Clifford
section.

## Exact Clifford model

Encode a Hermitian two-qubit Pauli observable by
\[
 v=(x,z)\in V=\mathbf F_2^4,\qquad
 P(v)=i^{x\cdot z}X^xZ^z.
\]
Write
\[
 P(u)P(v)=i^{c(u,v)}P(u+v).
\]
For a symplectic map \(g\), a Clifford lift modulo scalar phase acts by
\[
 P(v)\longmapsto(-1)^{q_g(v)}P(gv).
\]
Compatibility with multiplication is equivalent to
\[
 q_g(u+v)+q_g(u)+q_g(v)
 =
 \frac{c(gu,gv)-c(u,v)}2
 \pmod2.                                      \tag{1}
\]
The right side is defined because \(g\) preserves the commutator pairing.
Equation (1) always has \(16\) solutions; any two differ by a linear form
on \(V\), equivalently by Pauli conjugation.

Composition is
\[
 (g,q_g)(h,q_h)
 =
 \bigl(gh,\;q_h+q_g\circ h\bigr).             \tag{2}
\]
Equations (1)--(2) give a completely finite model of the Clifford
extension, with no floating-point unitary choices.

## Human proof of the full-\(S_6\) obstruction

Use the five adjacent transpositions
\[
 s_0,\ldots,s_4
\]
in the six odd-theta labels.  Their induced maps on \(V\) generate
\(\operatorname{Sp}_4(\mathbf F_2)\).  Fix one solution of (1) for each
\(s_i\).  Every other possible lift is obtained by adding a linear form,
so the five lifts have \(5\cdot4=20\) binary phase variables.

Impose the Coxeter relations
\[
s_i^2=1,\qquad
(s_is_j)^2=1\quad(|i-j|>1),\qquad
(s_is_{i+1})^3=1.
\]
Using (2), these become a linear system over \(\mathbf F_2\).  Exact
elimination gives
\[
\operatorname{rank}M=15,\qquad
\operatorname{rank}[M\mid b]=16.
\]
There is also a five-equation contradiction certificate.  The five left
rows, encoded in the \(20\) phase variables, are
\[
2,\quad256,\quad196608,\quad257,\quad196611.
\]
Their XOR is \(0\), while all five right sides are \(1\), whose XOR is
\(1\).  Hence no choice of the five Clifford lifts satisfies the Coxeter
presentation.  The extension is nonsplit.

This is stronger than a nontrivial scalar Schur multiplier: the
obstruction already survives after quotienting the Clifford group by all
scalar phases and takes values in the Pauli kernel \(V\).

## Human proof on the golden \(A_5\)

The even conference switching stabilizer has order \(60\).  It is generated
on the six odd characteristics by
\[
\begin{aligned}
a&=(0,2,4,1,5,3),\\
b&=(1,0,3,2,4,5),
\end{aligned}
\]
with
\[
a^5=b^2=(ab)^3=1.
\]
There are eight binary linear-phase variables for possible lifts of
\(a,b\).  Applying (2) to these three relations gives a consistent system
of rank \(2\), hence \(2^{8-2}=64\) splittings.  Direct generation verifies
that every solution maps isomorphically onto the \(60\)-element \(A_5\).

Conjugating a splitting by one of the \(16\) Pauli elements gives an orbit
of size \(16\).  The \(64\) splittings therefore form four such orbits.
Equivalently, the torsor of splittings modulo Pauli conjugacy has four
elements, giving the displayed two-dimensional \(H^1\).

Now let \(c(v_{ij})=[C_{ij}<0]\).  For every golden \(g\), conference
switching gives
\[
C_{g(i)g(j)}=s_i(g)s_j(g)C_{ij}.
\]
Under the odd-theta/Pauli dictionary, the edge function
\([s_i(g)s_j(g)<0]\) is linear in \(v_{ij}\).  Thus
\(\ell_g=c+c\circ g\) is a linear Pauli correction and satisfies the
one-cocycle identity.  Exhaustion of all \(720\) permutations proves the
converse: this difference is linear for exactly those \(60\) golden
elements.

The class is not a coboundary.  Computationally, twisting the base
splitting assignment \(48\) by the generator corrections \((1,4)\) gives
assignment \(113\), and these lie in different Pauli-conjugacy orbits.
Conceptually, if \(\ell\) were a coboundary, then \(c\) would differ from
a linear form by an \(A_5\)-invariant point function.  The golden \(A_5\)
is transitive on the fifteen nonzero vectors, so that invariant is
constant; direct inspection shows that \(c\) is not affine-linear.

## Exact \(S_5\) boundary

Adjoin the lexicographically first orientation-reversing conference
switching symmetry
\[
t=(0,1,4,5,3,2),\qquad t^4=1.
\]
The permutations \(a,b,t\) generate the full order-\(120\) switching
group.  Possible lifts satisfying the individual orders leave
\(16\cdot4\cdot8=512\) assignments.  Exact subgroup generation gives the
complete census
\[
\begin{array}{c|c}
\text{generated lift group}&\text{assignments}\\ \hline
S_5\text{ complement of order }120&32\\
V\rtimes S_5\text{ of order }1920&480.
\end{array}
\]
The \(32\) complements form two Pauli-conjugacy orbits of size \(16\), so
\[
H^1(S_5,V)\cong\mathbf F_2.
\]
Restriction to \(A_5\) hits exactly two of its four splitting classes.
The base class extends; the conference-twisted class does not.

This separates two phenomena that would otherwise look identical:

- the Clifford extension class restricts trivially to the conference
  \(S_5\);
- the distinguished golden conference \(H^1\)-class exists only on its
  orientation-preserving \(A_5\).

The full-\(S_6\) obstruction therefore appears only after leaving the
maximal conference \(S_5\), while the golden phase is lost one step
earlier, on crossing \(A_5\subset S_5\).

### Six local Clifford charts

The conference \(S_5\) is self-normalizing in \(S_6\), so it has exactly
six conjugates.  Exact enumeration gives
\[
\#\{S_5^{(i)}\}=6,\qquad
|S_5^{(i)}\cap S_5^{(j)}|=24\quad(i\ne j);
\]
every pairwise overlap is an \(S_4\).

Because the Clifford extension splits on one conference \(S_5\), conjugacy
shows that its \(H^2\)-class restricts to zero on all six.  Nevertheless
the six local complements cannot be chosen compatibly: a compatible
choice would generate a global \(S_6\) complement, contradicting the
five-row Coxeter certificate.

This gives a useful local-to-global form of the obstruction:
\[
\left.[\omega]\right|_{S_5^{(i)}}=0\quad(1\le i\le6),
\qquad
[\omega]\ne0\in H^2(S_6,V).
\]
These six charts must not be identified directly with C705's golden
six-pack.  Under the fixed conference \(S_5\), conjugation on the charts
has orbit decomposition \(1+5\): the subgroup fixes itself.  By contrast,
C705's six polarities form a transitive orbit under that \(S_5\), with
point stabilizer of order \(20\).  Hence there is no conference-\(S_5\)
equivariant chart-to-polarity bijection.

The correct candidate bridge for C708 is an *exchange*.  The two six-sets
are the two inequivalent degree-six actions associated with the ordinary
and exceptional \(S_5\) classes in \(S_6\).  An exceptional outer
automorphism exchanges those classes, just as a \(W_{10}\) polarity
exchanges the duad and syntheme halves.  The actual Segre--Igusa operator
should therefore be tested as an outer exchange between the chart
six-set and the axis six-set, not as one distinguished chart.

## Scalar phase

For completeness, the certificate records exact Gaussian-rational
intertwiners \(U_a,U_b\), each with denominator \(2\).  Integer Gaussian
matrix multiplication verifies
\[
U_a^5=iI,\quad U_b^2=I,\quad(U_aU_b)^3=iI.
\]
The rephasing \((U_a,U_b)\mapsto(-iU_a,-U_b)\) satisfies the presentation
strictly.  Therefore the nonzero C706 class is the
\(\mathbf F_2^4\)-valued conference twist in \(H^1\), not a residual
\(U(1)\)-valued multiplier.

## What the class controls

The class controls exactly the integral conference marking:

- the edge signs \(C_{ij}\);
- their triangle coboundary
  \(C_{ij}C_{jk}C_{ki}=K_{SS}/4\);
- the golden \(A_5\) phase convention inside the two-qubit Clifford
  extension.

It does **not** control:

- the full-\(S_6\) signed Joubert tensor, because the Clifford extension
  does not split on \(S_6\);
- the Segre--Igusa polar itself, which is already an ordinary
  \(S_6\)-equivariant polynomial construction;
- the field \(\mathbf Q(\sqrt5)\), since the class and all its certificates
  are defined over \(\mathbf F_2\) from integral signs.

Thus the positive invariant belongs to the conference/\(K\) marking, not
to a new contextuality class or a new source of the Joubert system.

## `ej` + `tt` closeout

The first unexpected cheap gain is the exact subgroup detector:
\[
\{g\in S_6:c+c\circ g\text{ is linear}\}=A_5.
\]
So the conference cochain recovers its golden orientation-preserving
stabilizer internally from Clifford compatibility, without referring to
the matrix switching calculation.

The second gain is the two-stage obstruction filtration
\[
A_5\subset S_5\subset S_6.
\]
The Clifford extension splits on the first two groups but not the third;
the conference phase class exists only on the first.  This locates both
failures minimally and prevents “orientation reversal” from being blamed
for the full Clifford nonsplitting.

The third gain is the six-chart local-to-global description.  The global
\(H^2\) class is invisible on every conjugate conference \(S_5\), and is
detected only by their incompatible gluing.  This puts the six-axis
phenomenon and the Clifford obstruction in the same exact incidence
framework.

### `tt` stabilizer audit

The stabilizers rule out the naive identification: charts restrict as
\(1+5\) under the fixed conference \(S_5\), whereas the golden polarity
six-pack is transitive.  What remains viable is exactly the exceptional
outer exchange between the two inequivalent six-point actions.  This
turns C708's question from “which chart is the polar operator?” into “does
the polar operator implement the outer exchange carrying local Clifford
charts to conference axes, with compatible \(S_4\)/order-\(20\)
incidence?”  That formulation has different input and cannot be answered
by matching labels alone.

The structural closeout separates three extension layers:

1. ordinary context gauge, trivial by C705;
2. Pauli-valued Clifford equivariance, nontrivial on \(S_6\) and split but
   nonuniquely on \(A_5\);
3. scalar unitary phase, trivial on the selected \(A_5\).

This prevents the positive \(H^1\) class from being overstated as a Mermin
class, a Schur multiplier, or a \(\sqrt5\)-descent invariant.

## Reproducibility

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c706-equivariant-clifford-lift.py --check
python3 notes/2026-07-30-c706-equivariant-clifford-lift-replay.py
```

The primary generator constructs all \(720\) symplectic maps, derives the
Hermitian-Pauli sign equations, checks the full Coxeter system, enumerates
the \(64\) golden splittings and their four Pauli-conjugacy classes, tests
all \(720\) conference phase differences, and verifies the exact unitary
relations over the Gaussian integers.

The independent replay checks the five-row nonsplitting contradiction,
the non-affine golden cocycle, and the exact scalar relations from
hard-coded data.

Checksums are recorded in
`notes/2026-07-30-c706-equivariant-clifford-lift.sha256`.

## Mystery ledger

- **Settled:** the full-\(S_6\) Clifford lift is obstructed by a nonzero
  class in \(H^2(S_6,\mathbf F_2^4)\).
- **Settled:** the golden \(A_5\) restriction splits in \(64\) ways and
  has four Pauli-conjugacy classes.
- **Settled:** the conference rephasing selects a nonzero
  \(H^1(A_5,\mathbf F_2^4)\) class.
- **Settled:** the conference \(S_5\) has \(32\) Clifford splittings in two
  Pauli-conjugacy classes, but the golden conference class is
  nonextendable across \(A_5\subset S_5\).
- **Settled:** the global \(S_6\) obstruction is locally trivial on six
  self-normalizing conference \(S_5\) charts with fifteen pairwise
  \(S_4\) overlaps.
- **Settled negatively:** the chart six-set is not equivariantly the
  golden polarity six-pack; their fixed-\(S_5\) orbit structures are
  \(1+5\) and \(6\), respectively.
- **Open in C708:** whether the actual polar operator realizes the
  exceptional outer exchange between the chart six-set and the axis
  six-set.
- **Settled:** the scalar projective class on \(A_5\) is trivial.
- **Settled:** the class controls the conference marking and \(K\), not
  Joubert or the golden eigenfield.
- **No genuine C706 mystery remains.**
