# C909 — Gamma-hat versus the cubic middle lattice

Date: 2026-08-12
Status: math-only audit; no manuscript, PDF, mirror, bibliography, ledger, or
Lean file was changed.

## Verdict

**Partial positive bridge, but no Gamma-hat unification.** Iritani's standard
integral structure is the image of topological \(K^0(X)\) under the Gamma map,
not the bare integral even cohomology lattice. Iritani's optional parity
extension uses \(K^*(X)=K^0_{\rm top}(X)\oplus K^1_{\rm top}(X)\), and does give a
canonical K-theoretic lattice in the cubic's \(H^3\). This is the strongest
theorem-grade bridge available from Gamma data alone. It does not select a
Hodge subspace, an elliptic-power marking, a finite-etale graph, or the
six-axis lattice. Cai's primitive-sixth small-even block is therefore not
canonically a detector of \(H^3(X)\) or \(J(X)\).

## Cubic Gamma class

Let \(h=c_1(\mathcal O_X(1))\) for a smooth cubic threefold
\(X\subset\mathbb P^4\). The normal sequence gives

\[
 c(TX)=\frac{(1+h)^5}{1+3h}=1+2h+4h^2-2h^3.
\]

Consequently

\[
 c_1=2h,\qquad c_2=4h^2,\qquad c_3=-2h^3,
\]
\[
 \operatorname{ch}_2(TX)=-2h^2,
 \qquad
 \operatorname{ch}_3(TX)=-\frac{11}{3}h^3.
\]

Iritani's convention is

\[
 \widehat\Gamma_X
 =\exp\!\left(-\gamma c_1+
 \sum_{k\ge2}(-1)^k\zeta(k)(k-1)!\operatorname{ch}_k(TX)\right).
\]

Truncation in dimension three therefore gives

\[
 \widehat\Gamma_X
 =1-2\gamma h+(2\gamma^2-\pi^2/3)h^2
 +\left(-\frac43\gamma^3+\frac{2\gamma\pi^2}{3}
 +\frac{22}{3}\zeta(3)\right)h^3.
\tag{G}
\]

The \(\zeta(3)h^3\) term is top cohomological degree \(H^6(X)\); it is not a
class in the middle group \(H^3(X)\). Since \(H^1(X)=H^5(X)=0\),

\[
 h\smile H^3(X)=0,
 \qquad
 \widehat\Gamma_X\smile\alpha=\alpha
 \quad(\alpha\in H^3(X)).
\tag{G3}
\]

This is the key parity obstruction.

## Which integral lattice is actually used

For \(n=3\), the standard even Gamma-integral map is

\[
 \mathfrak s_X(V)=L(\tau,z)z^{-\mu}z^{c_1(X)}
 (2\pi)^{-3/2}\widehat\Gamma_X(2\pi i)^{\deg/2}\operatorname{ch}(V),
 \qquad V\in K^0_{\rm top}(X).
\tag{I0}
\]

The integral structure is the image of \(K^0_{\rm top}(X)\) under (I0),
not \(H^{\rm ev}(X,\mathbb Z)\) with its cup-product basis. The cubic has

\[
 H^{\rm ev}(X,\mathbb Z)\cong\mathbb Z^4,
 \qquad H^3(X,\mathbb Z)\cong\mathbb Z^{10},
\]

and the torsion-free Atiyah--Hirzebruch spectral sequence gives

\[
 K^0_{\rm top}(X)/\mathrm{tors}\cong\mathbb Z^4,
 \qquad
 K^1_{\rm top}(X)/\mathrm{tors}\cong\mathbb Z^{10}.
\]

The Chern character identifies these with rational cohomology, but its
integral image is the \(K\)-theory lattice; it should not be silently replaced
by the bare cohomology lattice (in particular \(h^2\) and the integral
codimension-two generator need not be the same normalization).

Iritani also records an optional full-parity extension. After choosing a
square root of \(2\pi i\), one uses \(K^*_{\rm top}(X)\) and odd Chern
character. On a cubic the odd part is supported only in \(H^3(X)\), and (G3)
shows that the Gamma factor does nothing there. Thus the odd lattice is,
up to the fixed universal \((2\pi)\)-normalization and branch scalar,

\[
 (2\pi)^{-3/2}(2\pi i)^{3/2}\operatorname{ch}\bigl(K^1_{\rm top}(X)\bigr)
 \subset H^3(X,\mathbb C).
\tag{I1}
\]

This is a genuine positive bridge: \(K^1\) supplies a canonical integral
topological lattice in the middle cohomology, and Iritani's odd pairing is the
K-theoretic index pairing, corresponding to the cup/symplectic pairing up to
the displayed fixed scalar. It is not a six-axis decomposition.

## Why Cai's block cannot see \(H^3\)

The small quantum connection with even parameters preserves

\[
 H^{\rm ev}(X)\oplus H^3(X).
\]

For the cubic, \(h\star H^3(X)=0\): the degree constraint would require a
half-integral curve degree for the only possible odd output. Associativity then
makes every even multiplication on \(H^3\) scalar (for example, any quantum
correction in \(h\star h\) contributes only a scalar multiple of the identity
on \(H^3\)). At the small point, \(E\star H^3=2h\star H^3=0\), and the
grading operator satisfies

\[
 \mu|_{H^3}=\frac{3}{2}-\frac{3}{2}=0.
\]

Hence the odd \(z\)-connection is a rank-ten scalar block with formal
monodromy \(1\) (scalar exponential factors are single-valued in the original
\(z\)-disc). Cai's rank-two zero-exponential block with eigenvalues
\(e^{\pm\pi i/3}\) lies wholly in the rank-four even connection. No canonical
operator in that connection acts on, or pairs with, the odd \(K^1/H^3\) block.

## Exact no-go for the six-axis packet

The intermediate Jacobian is

\[
 J(X)=H^3(X,\mathbb C)/(F^2H^3(X)+H^3(X,\mathbb Z)),
\]

and a six-axis presentation requires extra integral polarized data, for example
a map (or finite-index isogeny)

\[
 H^1(E,\mathbb Z)\otimes M
 \longrightarrow H^3(X,\mathbb Z)
\]

preserving the symplectic form and the varying Hodge filtration, together
with the specified finite graph/kernel marking. Neither (G) nor (I0)--(I1)
constructs this map. Gamma classes are characteristic classes of \(TX\), so
they are constant in a smooth cubic deformation, while the period/Hodge
filtration and \(J(X)\) vary. The small-even quantum connection likewise has
the same even deformation data across the smooth cubic family. Therefore a
Gamma-only construction cannot detect membership in the special elliptic-power
Hecke locus, much less choose six axes.

A positive unification would need a separate polarized integral comparison of
the \(K^1/H^3\) lattice with the elliptic multiplicity system, plus a proof
that it respects \(F^2\) and the finite-etale graph kernel. Even then it would
be an added B-model/Abel--Jacobi marking theorem, not a consequence of Cai's
even primitive-sixth block or of \(\widehat\Gamma\) itself.

## ej + tt closeout / mystery ledger

* **Settled:** the apparent \(\zeta(3)\) route is top-degree \(h^3\in H^6\), not
  middle \(H^3\); it cannot encode \(J(X)\).
* **Settled:** the positive canonical bridge is \(K^1\to H^3\) in Iritani's
  optional parity extension, but Gamma acts trivially on that odd sector.
* **Settled:** Cai's sixth-root block is even and parity-separated from the
  odd sector; no hidden rank-two \(H^3\) packet exists in the small-even QDM.
* **Open/owning gate:** an integral polarized \(K^1/H^3\)-to-elliptic-power
  comparison respecting \(F^2\), finite graph kernel, and six-axis labels. This
  belongs to the C909 relative integral-isogeny gate, not to the quantum
  epilogue.

## Source record

Hiroshi Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938
v1: relevant text read from the cached full-text extraction at
arXiv_2307.15938, SHA-256
462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a; the
definition of \(\widehat\Gamma\), the \(K^0\) map (1.6), and the optional \(K^*\)
extension in Remark 1.2 were checked. No new manuscript source was read.
