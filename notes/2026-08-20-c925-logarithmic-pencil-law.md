# Module 31. The logarithmic pencil law for exceptional corrections

**Packet part:** Module 31.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** commuting-unipotent theorem proved; geometric mixed-composite
vanishing open

## 31.1 From multiplicative line bundles to an additive pencil

Let \(K\) be a characteristic-zero field and let \(V\) be finite
dimensional.  Suppose \(A,C\in\operatorname{GL}(V)\) are commuting
unipotent operators.  Put

\[
X=\log A,\qquad Y=\log C.
\tag{31.1}
\]

The logarithms are finite polynomials, \(X,Y\) are commuting nilpotents, and

\[
A\,C^a=\exp(X+aY)
\tag{31.2}
\]

for every integer \(a\).

### Theorem 31.1 -- exact logarithmic pencil law

For

\[
N_a=1-A\,C^a,\qquad Z_a=X+aY,
\tag{31.3}
\]

and every \(m\ge0\),

\[
\operatorname{im}N_a^m=\operatorname{im}Z_a^m,
\qquad
\ker N_a^m=\ker Z_a^m.
\tag{31.4}
\]

In particular \(N_a\) and \(Z_a\) have the same Jordan partition.

#### Proof

Because \(Z_a\) is nilpotent,

\[
1-e^{Z_a}=-Z_a\,u(Z_a),
\qquad
u(t)=\frac{e^t-1}{t},
\qquad
u(0)=1.
\tag{31.5}
\]

The finite polynomial \(u(Z_a)\) is invertible and commutes with \(Z_a\).
Therefore

\[
N_a^m=(-1)^mZ_a^m u(Z_a)^m,
\]

and multiplication by the commuting invertible factor changes neither
image nor kernel.  Equality of all power-kernel dimensions determines the
Jordan partition.  \(\square\)

This theorem is stronger than a first-order approximation.  It loses no
nilpotent/Jordan information.

## 31.2 Cheap consequences

### Corollary 31.1A -- pure exceptional multiplicity is irrelevant

If \(A=1\), then for every nonzero integer \(a\),

\[
\operatorname{im}(1-C^a)^m=\operatorname{im}Y^m,
\qquad
\ker(1-C^a)^m=\ker Y^m.
\tag{31.6}
\]

Thus a nonzero exceptional multiplicity changes no ExactTop threshold of a
pure correction.  Only the distinction \(a=0\) versus \(a\ne0\) remains.

### Corollary 31.1B -- generic constancy

For fixed \(m\), the function

\[
a\longmapsto\operatorname{rank}(X+aY)^m
\tag{31.7}
\]

is constant on a nonempty Zariski-open subset of \(\mathbf A^1_K\).
Over an infinite field its drop locus is finite.

#### Proof

The matrix entries of \((X+aY)^m\) are polynomials in \(a\).
Choose a nonzero minor of maximal size over \(K(a)\).  Its nonvanishing
defines the maximal-rank open set; in one variable its zero set is finite.
\(\square\)

This gives a lawful cofinite specialization of the mobile multiplicity, but
it does not say that an actual geometric integer \(a\) avoids the finite
drop set.

## 31.3 The exact \(m=2\) cross-composite

### Corollary 31.1C -- square-zero factors

Assume

\[
X^2=0,\qquad Y^2=0.
\tag{31.8}
\]

Then

\[
Z_a^2=(X+aY)^2=2a\,XY,
\tag{31.9}
\]

because \(X\) and \(Y\) commute.  Hence, for \(a\ne0\),

\[
\operatorname{Top}_2(N_a)=0
\quad\Longleftrightarrow\quad
XY=0.
\tag{31.10}
\]

On a sector or correction quotient satisfying both square-zero hypotheses,
the moving-frame \(m=2\) problem is therefore one mixed composite, not a
family indexed by the positive integer \(a\).

This is exactly the “kill second composites, not first extensions”
principle from C907/Module 25 in multiplicative line-bundle coordinates.
The linear-projection counterexample of Module 30 proves that \(XY\) need
not vanish on raw \(K_0\).

### Corollary 31.1D -- one-sided square-zero

If only \(Y^2=0\), then

\[
Z_a^m=X^m+maX^{m-1}Y
\tag{31.11}
\]

for every \(m\ge1\).  Thus once \(X^m=0\), the entire threshold-\(m\)
correction is the single mixed term \(X^{m-1}Y\).

If instead \(X^2=0\), the exact symmetric formula is

\[
Z_a^m=a^mY^m+ma^{m-1}XY^{m-1}.
\tag{31.11a}
\]

## 31.4 General mixed-word compression

Because \(X,Y\) commute,

\[
Z_a^m
=
\sum_{k=0}^{m}\binom{m}{k}a^kX^{m-k}Y^k.
\tag{31.12}
\]

Suppose separate carrier or support arguments kill the pure terms
\(X^m\) and \(Y^m\).  Then every possible threshold leakage lies in the
finite family

\[
X^{m-k}Y^k,\qquad 1\le k\le m-1.
\tag{31.13}
\]

This is a smaller provider interface than a full split packet:

\[
\mathsf{MixedTop}_m(X,Y)
:=
\left(X^{m-1}Y,\ldots,XY^{m-1}\right).
\tag{31.14}
\]

Vanishing of (31.14) implies ExactTop-nullity for every exceptional
multiplicity \(a\).  Conversely, if \(Z_a^m=0\) for at least \(m+1\)
distinct scalars \(a\), polynomial interpolation forces every coefficient
in (31.12), hence every mixed word (31.13), to vanish.

The converse uses independently lawful specializations at fixed \(X,Y\).
Replacing one geometric occurrence by unrelated occurrences with different
\(X\) or \(Y\) would be hypothesis smuggling.

## 31.5 Mobile-line-bundle specialization

For a blowup occurrence in Module 30, set on a common invariant
\(\chi\)-sector

\[
A=\tau_{\pi^*L},
\qquad
C=\tau_{\mathcal O(-E)}.
\tag{31.15}
\]

Line-bundle tensor actions commute.  When their restrictions to the chosen
finite sector are unipotent, Theorem 31.1 applies and the moving frame

\[
\tau_{\widetilde L}=A\,C^a
\tag{31.16}
\]

is controlled exactly by \(X+aY\).

On the whole ambient packet one must not impose \(X^2=0\): its nonzero
base image is precisely the obstruction being transported.  First assume
the Module 29 pure-pullback identification has typed

\[
\Psi X\Psi^{-1}=X_L\oplus X_E,
\qquad
X_E^2=0,
\tag{31.17a}
\]

where the second clause is the independent exceptional exponent
certificate.  If also \(Y^2=0\), the exact formula upstairs is

\[
(X+aY)^2=X^2+2aXY.
\tag{31.18}
\]

The desired statement is that the image of (31.18) projects
isomorphically to \(\operatorname{im}X_L^2\) by Module 28's graph
criterion.  Together with (31.17a) and \(Y^2=0\), the strong condition
\(XY=0\) is sufficient but not necessary.

In an actual oriented exact realization, Module 25's snake boundary for the
total nilpotent \(N_a\) remains the canonical defect.  The literal operator
\(XY\) represents its cross block only after additional block typing:
\(X\) must have the named diagonal restrictions/quotients, \(Y\) must have
the appropriate strict triangular form with \(Y^2=0\), and the
invertible factors relating \(N_a^2\) to \(Z_a^2\) must be carried through
the relevant image and quotient.  Without that calculation, (31.18)
supplies only the Module 28 graph test, not an identification of \(XY\)
with the snake boundary.  Corollary 31.1C applies literally only after
passing to a correction/quotient on which both pure squares vanish.

This decomposition is conditional on the common sector, operation
realization, and a typed projection or oriented exact sequence.  Theorem
31.1 constructs none of them.

## 31.6 Category-theoretic interpretation

Commuting unipotent automorphisms form a prounipotent Picard action.  Over
characteristic zero, logarithm sends this multiplicative action to an
additive representation of its abelian Lie algebra:

\[
\langle A,C\rangle
\xrightarrow{\log}
\langle X,Y\rangle.
\tag{31.17}
\]

The mobile Writer coefficient \(a\) becomes scalar multiplication on the
second Lie generator.  ExactTop factors through the finite polynomial
consumer \(Z\mapsto\operatorname{im}Z^m\).

This is the appropriate imported categorical machinery here: not a generic
monad law, but linearization of a Picard-group action followed by a
polynomial functor.  It explains why the path's exceptional multiplicities
compose additively after logarithm.

## 31.7 Finite calibration

The shared finite replay checks the logarithmic-pencil law on commuting
Jordan polynomials, including:

1. equality of the ranks of \((1-AC^a)^m\) and \((X+aY)^m\);
2. independence of nonzero \(a\) for a pure correction; and
3. the square-zero identity \(Z_a^2=2aXY\).

These tests are finite linear algebra only.  They do not verify the common
\(\chi\)-receiver or any geometric mixed-composite vanishing.

## 31.8 EJ/TT audit

**EJ.** The infinite family of exceptional multiplicities compresses to
one nilpotent pencil.  At \(m=2\), every positive multiplicity has exactly
the same yes/no cross-composite gate.

**TT.** The pencil law does not make the cross term vanish.  The raw
linear-projection model proves the opposite.  The geometric opportunity is
to kill \(XY\) only after primitive-character/support projection, where the
raw hostile string may disappear.

## 31.9 Mystery ledger

| question | status | exact evidence or gate |
|---|---|---|
| Does logarithm lose Jordan/ExactTop data? | **settled: no** | Theorem 31.1 |
| Does nonzero pure exceptional multiplicity matter? | **settled: no** | Corollary 31.1A |
| What survives at \(m=2\) after both squares vanish? | **settled** | the single mixed composite \(XY\) |
| Can \(XY\) be nonzero raw? | **settled: yes** | Module 30/C907 linear-projection example |
| Does primitive-character projection kill the class of \(XY\) modulo retained ambient top? | **open central gate** | construct common receiver and compute the graph/boundary defect |
| What replaces \(XY\) for all \(m\)? | **settled algebraically** | finite mixed-word family (31.13) |
| Can lawful multiplicity interpolation be realized geometrically? | **open** | need \(m+1\) specializations of one fixed occurrence |

## Boundary

Theorem 31.1 and Corollaries 31.1A--D are proved.  They compress
exceptional-twist transport to a finite mixed-word interface and isolate
one cross-composite at \(m=2\).  They do not prove its projected geometric
vanishing, so no unconditional stabilization theorem follows.
