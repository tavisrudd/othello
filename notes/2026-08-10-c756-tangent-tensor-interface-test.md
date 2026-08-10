# C756 tangent-tensor interface test

**Date:** 2026-08-10

**Scope:** saturated-internal branch; bounded Ball--Lavrauw globalization test

**Verdict:** the tangent tensor does not globalize the distinguished
cross-ratio kernel line at a lower degree; this route stops at its prescribed
negative gate

## Parameter dictionary

Write \(q=2m-1\).  A saturated-internal candidate is a planar arc \(A\) of
size

\[
 |A|=m+1=\frac{q+3}{2}=q+2-t,
 \qquad t=m=\frac{q+1}{2}.
\]

This is exactly the parameter \(t\) used by Ball and Lavrauw.  At each
\(P\in A\), their tangent function \(f_P(X)\) is the degree-m product of the
m tangent lines to A through P.  The other m lines through P are the m secants
\(PQ\), \(Q\in A\setminus\{P\}\).  In C756's quadratic-extension pencil
coordinates, the latter directions are the roots of the angle binomial

\[
 \prod_{Q\ne P}(X-\alpha_{PQ})=X^m+1.
\]

Thus the tangent-function and angle-binomial descriptions are complementary
halves of the same pencil.  The parameter match is exact; the issue is whether
the tangent tensor couples different base points more strongly than the
already known rowwise identities.

## The socle degenerates to the whole arc

For every \(P\in A\), and for every \(Q\in A\setminus\{P\}\), choose a line
through Q which avoids P.  The product of those m line equations is a degree-m
form which vanishes on \(A\setminus\{P\}\) and not at P.  Hence evaluation of
degree-m plane forms on A has full rank \(|A|=m+1\).  Equivalently, every
m-socle of A is all of A.

Ball--Lavrauw's planar tangent-polynomial theorem therefore gives an
\((m,m)\)-form \(F(X,Y)\) with

\[
 F(X,P)=f_P(X)\qquad(P\in A),
\]

but its interpolation set is already the entire arc.  It creates no new
off-arc value and no smaller set from which the rows are forced.  The general
tangent tensor has the same boundary: its uniqueness is only modulo
\(\Phi_m\) in every variable, where \(\Phi_m\) is the large space of degree-m
forms vanishing on A.

Concretely, adding a term \(H(X)\phi(Y)\) with \(\phi\in\Phi_m\) changes any
ambient Y-coefficient or contraction while preserving every specialized
tangent row.  The scaled coordinate-free lemma fixes the symmetry
\(f_P(Q)=(-1)^{m+1}f_Q(P)\); it does not canonically choose a representative
of the quotient by \(\Phi_m\).

## Why the apparent degree saving is false

The first middle angle coefficient is naturally defined only after removing
the factor belonging to P and comparing the two conjugate fibres
\(z_P,z_P^q\).  The tangent tensor supplies neither that conormal division nor
a canonical lift through \(\Phi_m\).  Moreover the map from a root z to the
rational pole represented by \(\{z,z^q\}\) contains the q-power Frobenius; it
is not a quadratic parametrization over the algebraic closure.  Pulling an
arbitrary degree-m Y-form back to z therefore does not produce a section of
degree \(2m=q+1\).  The tempting comparison with the degree-\(q+3\) arc
divisor is invalid.

The precise failed tensor slot is consequently

\[
 F(-,P)\in V_m/\Phi_m:
\]

it records the separate tangent polynomial at P, whereas the distinguished
adjugate line of the cross-ratio matrix needs a canonical simultaneous
conormal coefficient across all P.  No degree is lowered and no new row
coupling is obtained.

## Verdict and next structural gate

The Ball--Lavrauw tensor is the correct intrinsic package for the tangent
rows, but at C756's half-size parameter its socle theorem is interpolation on
all of A.  It repackages the rowwise tangent functions and Segre symmetry; it
does not globalize the adjugate kernel line.  Per the proof-dossier stop rule,
this route closes here rather than opening more arc-tensor machinery.

The next bounded structural check is the generalized-hyperfocused analogy:
under polarity, determine whether a canonical set of \(|A|-1=m\) blockers on
one line covers every secant of A.  Without exactly that hypothesis, the
prime-field four-point theorem is inapplicable.

## EJ + TT closeout

**EJ.**  The negative result removes a seductive but false degree argument:
the Frobenius pair map is not a quadratic algebraic parametrization.  It also
identifies the missing object sharply—a canonical lift through
\(V_m/\Phi_m\), not another tangent tensor.

**TT.**  The useful structural split is now clear.  Tangent tensors organize
the complementary pencil half, while the C756 obstruction lives in the
secant cross-ratio matrix plus a conormal removal.  A successful proof must
add polarity or Rédei lacunarity before interpolation; pure tangent symmetry
cannot supply the coupling.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| parameter match \(t=m\) | settled | exact at \(|A|=(q+3)/2\) |
| tangent-tensor globalization of separate rows | settled positively | Ball--Lavrauw biform/tensor supplies it modulo \(\Phi_m\) |
| lower-degree globalization of the adjugate kernel line | settled negatively for this route | m-socle is all A and the lift modulo \(\Phi_m\) is noncanonical |
| naive degree-\(q+1\) pullback to the root parameter | settled invalid | the rational pole uses the q-power Frobenius |
| generalized-hyperfocused blocker analogy | open bounded check | require a canonical m-point blocker set on one line |

## Sources read

- Ball--Lavrauw, *Planar arcs*, arXiv:1705.10940, sections 5--6;
  cached PDF SHA-256
  `e9f316f5759f310c829489471b41c84972459482236df5023fb6e1f463c55872`.
- Ball--Lavrauw, *Arcs and tensors*, arXiv:1904.12800, sections 2--3;
  cached PDF SHA-256
  `3237c740af7e4b068f27030677887354dc1bf2605b8f1a56e883fc417bdcd2d9`.
