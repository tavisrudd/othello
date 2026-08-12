# C904: Eisenstein \(3\)-fiber versus the scalar graph slope

## Verdict

There is a useful root-collision analogy at \(3\), but no exact
identification of the Eisenstein fiber with the scalar \(3\)-primary graph
gluing. The Eisenstein fiber is a ramified, nonreduced quadratic algebra; the
scalar graph block is a reduced \(\mathbf F_3\)-slope and its proved
divisor-product construction is primitive. The certified order-three graph
defect is instead a height-three nilpotent operator. Thus the analogy can
organize the vocabulary (“coalesced root”, “nilpotent carry”), but it does not
explain the cycle defect or supply a common theorem.

## Exact Eisenstein local algebra

Put \(\mathcal O=\mathbf Z[\omega]\), \(\omega^2+\omega+1=0\), and
\(\pi=1-\omega\). Then

\[
  \pi^2=-3\omega,
  \qquad (3)=(\pi)^2,
\]

up to the unit \(-\omega\). Hence \(\mathcal O\otimes\mathbf Z_3\) is the
ramified quadratic extension of \(\mathbf Z_3\), with \(e=2,f=1\), and

\[
 \mathcal O/(3)
   \simeq \mathbf F _3[\bar\omega]/(\bar\omega^2+\bar\omega+1)
   \simeq \mathbf F _3[\varepsilon]/(\varepsilon^2),
 \qquad \bar\omega=1+\varepsilon.
\]

Thus the canonical residue root is \(1\), a double root; \(\varepsilon\) is
the nonzero square-zero tangent. In the basis \((1,\omega)\), multiplication
by \(\omega\) is

\[
 M_\omega=\begin{pmatrix}0&-1\\1&-1\end{pmatrix},
 \qquad (M_\omega-I)^2=0\pmod 3,
 \quad M_\omega\ne I\pmod 3.
\]

This gives a genuine height-two Jordan realization of the ramified fiber. It
is self-adjoint for the trace pairing
\(\operatorname{Tr}_{\mathcal O/\mathbf Z}(xy)\), by commutativity. It is
not a scalar operator.

The local picture is therefore

\[
 \mathcal O_3\supset (3)=(\pi)^2
 \longrightarrow
 \mathcal O/(3)=\mathbf F _3[\varepsilon]/(\varepsilon^2)
 \longrightarrow \mathcal O/(\pi)=\mathbf F _3,
 \quad \omega\mapsto 1+\varepsilon\mapsto1.
\]

## Comparison with the graph lattices

For a scalar graph block the reduced slope is \(T=\lambda I_d\), with
\(\lambda\in\mathbf F _3\). Its coefficient algebra is just the reduced
algebra \(\mathbf F _3[T]=\mathbf F _3\) (on one scalar block); the
commutator carry is zero. The blockwise symmetric coefficient lattice and
mixed-adjugate identities in
notes/2026-08-11-c904-semisimple-graph-slope-primitivity.md give the
primitive integral minimal class. Taking \(\lambda=1\) matches only the closed
residue root of the Eisenstein fiber, not its nilpotent tangent
\(\varepsilon\).

One can put \(M_\omega\) on a two-dimensional graph block and obtain the
same operator shape \(\mathbf F _3[u]/(u^2)\), but this is a nonscalar
height-two slope and requires an explicit trace-form/polarization embedding.
No such embedding is part of the C904 scalar construction. The current
height-filtration notes only suggest (and small computations support) that an
odd-prime height-two block can remain primitive; this does not produce the
order-three defect.

The exact triadic defect recorded in
notes/2026-08-11-c904-graph-stabilization-base-certificates.out has \(p=3,g=4\),
characteristic polynomial

\[
 x^4+2x^3+2x+1=(x-1)^4\quad(\bmod 3),
\]

and nilpotent index three (minimal factor \((x-1)^3\)). Its primary operator
therefore has a height-three \(\mathbf F _3[u]/(u^3)\)-type quotient, not the
height-two Eisenstein algebra \(\mathcal O/(3)\). The exact order-three class
is the divisor-product Bockstein from the integral graph congruence lattice;
it is not the trace/norm class of the Eisenstein order.

The two mechanisms should consequently remain separate:

\[
\begin{array}{c|c|c}
\text{local object}&\text{reduction}&\text{known consequence}\\ \hline
\mathcal O/(3)&\mathbf F _3[\varepsilon]/(\varepsilon^2)&
\text{ramified root collision; no graph-cycle statement}\\
T=\lambda I&\mathbf F _3&
\text{scalar graph; primitive divisor-product minimal class}\\
\text{triadic height }3&T=I+N,\ N^3=0&
\text{certified order-3 divided-power defect}
\end{array}
\]

Finally, the separate Eisenstein norm calculation used in the M9/Bridgeland
audit—\(n^2+nm+m^2\equiv0,1\pmod3\), hence no norm \(8\)—is an arithmetic
dimension obstruction. It shares the prime and the root-of-unity order but
does not descend to, or explain, the graph divisor-product Bockstein.

**Safe integration sentence:** “At \(3\), Eisenstein root collision provides a
ramified quadratic model for a height-two nilpotent carry, while the C904
scalar graph slope is the reduced (primitive) special case and the first
certified graph obstruction occurs only at height three. The resemblance is
structural, not an established identification.”
