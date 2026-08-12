# C907: the degree-five Fano threefold has no primitive-sixth support

**Lane:** `clebsch`

**Status:** theorem-grade small-even calculation; cold-source and independent
formal-asymptotic replays pass.

Let $V_5$ be the Picard-rank-one index-two degree-five Fano threefold, the
intersection of three hyperplanes in $\operatorname{Gr}(2,5)$.  Coates--Corti--
Galkin--Kasprzyk, arXiv:1303.3288, Section 7, ``The Fano manifold B5'', give
the unit component of its small $J$-function.  The terminating double sum is
the factorial-normalized Apéry-ζ(2) sequence

\[
 G(s)=\sum_{n\ge0}a_ns^n,
 \qquad
 a_n={1\over(n!)^2}\sum_{k=0}^n
 {n\choose k}^2{n+k\choose k}.
\]

Its recurrence is

\[
 (n+1)^4a_{n+1}-(11n^2+11n+3)a_n-a_{n-1}=0,
\]

so the cyclic rank-four scalar small quantum equation is

\[
 L=\theta^4-s(11\theta^2+11\theta+3)-s^2,
 \qquad s=q/z^2.
\tag{1}
\]

Put $x=s^{1/2}=q^{1/2}/z$ and $D=x\partial_x$.  Then

\[
 16L=D^4-44x^2D^2-88x^2D-48x^2-16x^4.
\]

For a formal branch $e^{\lambda x}x^\alpha(1+O(x^{-1}))$, the two leading
orders give

\[
 \lambda^2=22\pm10\sqrt5,
 \qquad \alpha=-{3\over2}.
\]

Thus all four branches are irregular and unramified as functions of $z$:
$x=q^{1/2}/z$ contains an ordinary integral $z^{-1}$, not a ramified
power of $z$.  Their scalar $z$-residue is $3/2$; the threefold framed
companion shift subtracts $3/2$.  Hence every framed residue is zero and

\[
 \chi^{\mathrm{fr}}_{V_5}(T)=(T-1)^4,
 \qquad \nu_6(V_5)=0.
\tag{2}
\]

The full-QDM bridge is independent of the numerical-period inference.  Van
der Put, *SIGMA* 11 (2015), 036, Sections 4.1--4.2, first defines the quantum
differential equation as the vector system for quantum multiplication, states
that a cyclic vector produces its scalar equation of full cohomological order,
and then lists (1) explicitly as the quantum differential equation of $V_5$.
Since $H^{\mathrm{even}}(V_5)$ has rank four, this directly identifies (1)
with the full small-even QDM, not a proper scalar submodule.  No claim is made
about odd or big quantum sectors.

## Implication

The first non-complete-intersection index-two Picard-one Fano is not merely
below the length-two admission bound: it has no primitive-sixth packet at all.
The weighted-CI theorem and this calculation therefore push the finite Fano
scan to the remaining non-WCI prime families, while arbitrary non-Fano and
non-nef weak-factorization centers remain untouched.

## Source record

- Coates--Corti--Galkin--Kasprzyk, *Quantum Periods for 3-Dimensional Fano
  Manifolds*, arXiv:1303.3288, Section 7 ``The Fano manifold B5'', Theorem
  F.1, and the definition of the quantum period as the unit component of $J$.
- Marius van der Put, *The Stokes Phenomenon and Some Applications*, SIGMA
  11 (2015), 036, Sections 4.1--4.2: vector-QDM definition, cyclic scalarization,
  and the exact $V_5$ operator (1); arXiv:1501.05205, cached SHA-256
  `a60119e4088ccf4625a113b7cc0584a302d731e56d61ae91401f1242ce5646ec`.
- Cached source-tarball SHA-256:
  `fe01aedde30aec17ad6da442b82d9c15ff2c2fc5cdef0c7a6d15e87fa0573143`.

## Mystery ledger

- **Settled:** $V_5$ has ν₆ equal to zero; rank four and self-duality do
  not force even one primitive-sixth pair.
- **Open:** whether the remaining non-WCI prime Fanos share the stronger
  all-irregular/integral-residue mechanism, or whether one first reaches
  ν₆ equal to two.  A value four would be the first small-even admission
  candidate, not yet a carrier construction.
