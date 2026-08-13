# C907 cubic point / primitive-sixth collision

**Lane:** `clebsch`

**Status:** exact numerical no-go for residual-Serre support vanishing, plus
an A-model leading-block calibration.  A point on a cubic threefold has a
nonzero class in the numerical Kuznetsov component, and that entire rank-two
component has primitive-sixth Serre spectrum.  Therefore the desired
low-support rule cannot be obtained by projecting supported objects to the
cubic residual category.  Identifying it with ambient Gamma primary
projection would face the same collision.

## Numerical Kuznetsov calculation

Let \(X\subset\mathbf P^4\) be a smooth cubic threefold and write
\(H=\mathcal O_X(1)\).  The standard decomposition is

\[
 D^b(X)=\langle\operatorname{Ku}(X),\mathcal O_X,\mathcal O_X(H)\rangle.
 \tag{1}
\]

Riemann--Roch gives

\[
 \operatorname{td}(X)=1+H+\frac23H^2+\frac13H^3,
 \qquad \int_XH^3=3,
\]

and hence

\[
 \chi(\mathcal O(aH),\mathcal O(bH))
 =P(b-a),\qquad
 P(k)=\frac{k^3+3k^2+4k+2}{2}.
 \tag{2}
\]

Inside the rational numerical \(K\)-group, two classes spanning the right
orthogonal to \(\mathcal O,\mathcal O(H)\) are

\[
 v_1=10\mathcal O-5\mathcal O(H)+\mathcal O(2H),
 \qquad
 v_2=41\mathcal O-15\mathcal O(H)+\mathcal O(3H).
 \tag{3}
\]

Using (2), their Euler matrix is

\[
 A=(\chi(v_i,v_j))=
 \begin{pmatrix}-9&-36\\-45&-189\end{pmatrix}.
 \tag{4}
\]

The numerical Serre operator is characterized by
\(\chi(x,y)=\chi(y,Sx)\), so in the basis (3)

\[
 S=A^{-1}A^{\mathsf T}
 =\begin{pmatrix}5&21\\-1&-4\end{pmatrix},
 \qquad
 \det(tI-S)=t^2-t+1.
 \tag{5}
\]

Thus the whole numerical residual lattice is the primitive-sixth primary
sector; there is no residual \(+1\) or \(-1\) line on which a point could hide.

For a closed point \(p\in X\),

\[
 [\mathcal O_p]
 =\frac{-\mathcal O+3\mathcal O(H)-3\mathcal O(2H)
             +\mathcal O(3H)}3
 \tag{6}
\]

numerically.  Its projection to the right orthogonal in (1) is obtained by
subtracting its exceptional Euler coordinates:

\[
 [\operatorname{pr}_{\rm Ku}\mathcal O_p]
 =[\mathcal O_p]+4\mathcal O-\mathcal O(H)
 =-v_1+\frac13v_2\ne0.
 \tag{7}
\]

Equations (5)--(7) prove:

> No additive realization obtained from the Kuznetsov residual projection
> can both realize the cubic primitive-sixth packet and annihilate all
> point-supported objects.

This is stronger than the earlier rank/first-Chern observation that a point
does not lie in the exceptional span: it locates the point explicitly in the
primitive-sixth residual primary sector.

## A-model leading-block calibration

In Cai's basis \((1,H,H^2,H^3)\), write the leading quantum matrix as
\(K=2M\), where

\[
 M=\begin{pmatrix}
 0&6q&0&36q^2\\
 1&0&15q&0\\
 0&1&0&6q\\
 0&0&1&0
 \end{pmatrix}.
\]

Its minimal polynomial is
\(t^2(t^2-27q)\).  Therefore the projector onto the generalized zero
eigenspace of \(K\), which is the rank-two block carrying Cai's fractional
powers, is

\[
 \Pi_0=I-\frac{K^2}{108q}=I-\frac{M^2}{27q}.
 \tag{8}
\]

On the point-class direction \(H^3\),

\[
 \Pi_0(H^3)=
 \begin{pmatrix}0\\-14q/3\\0\\7/9\end{pmatrix}\ne0.
 \tag{9}
\]

Equivalently, \(\Pi_0(H^3)=\frac79(H^3-6qH)\).  In the normalized zero-block
Jordan basis of the existing replay its coordinates are
\((-49q/6,0)\), so the point direction already meets the kernel line.

Cai's decoupling gauge is \(I+O(z)\), so it does not remove this leading
cohomological component.  Equation (9) is not by itself a statement about
the Gamma flat section \(s(\mathcal O_p)\): that requires the central
connection matrix from the large-radius framing to the \(z=0\) formal
decomposition.  It is nevertheless an exact A-model warning that the point
direction is not transverse to the fractional block.

The A-model calculation is contained in the existing atomic C907 evidence
bundle.  From the repository root, its non-writing check is

```sh
nix shell nixpkgs#sage --command sage \\
  notes/2026-08-10-c907-quantum-monodromy-stabilization.sage \\
  --bound 24 \\
  --check notes/2026-08-10-c907-quantum-monodromy-stabilization.json
```

The independent SymPy replay
`notes/2026-08-10-c907-quantum-monodromy-stabilization-independent.py`
contains the displayed projector.  Cai's source matrix is in
arXiv:2608.01577, cached with SHA-256
`06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`.

## Consequence for the support-square route

The divisorial support-square theorem cannot consume the following naive
bridge:

\[
 \text{``take ambient Gamma classes and project them to the residual
 primitive-sixth sector.''}
\]

On the categorical model, (7) disproves its low-support vanishing.  On the
A-model, (9) points in the same direction, while the missing central
connection calculation prevents promoting that warning to an unconditional
formal-QDM counterexample.

The support-square route therefore needs a more delicate statement.  It
must attach the zero primitive-sixth packet **intrinsically to the terminal
surface support** and map its point-kernel action to the ambient packet,
rather than identify that map with residual projection of the ambient
supported object.  Whether such a Gysin map can coexist with Gamma/Orlov
compatibility is now the exact consistency gate.

## AA / EJ / TT and mystery ledger

- **AA:** residual-category projection is closed negatively as the missing
  supported coefficient.  An intrinsic support packet with a separately
  constructed Gysin map remains logically open.
- **EJ:** the Euler calculation gives an exact primitive-sixth point class,
  not merely a generic warning about mutation dependence.  It is a mandatory
  regression for every proposed \(\Phi_6\) construction.
- **TT:** ask what happens to one point before constructing a localizing
  motive.  The most canonical residual projector already sends that point to
  the entire kind of sector the construction was supposed to kill.
- **Settled:** exact point projection and primitive-sixth Serre spectrum of
  the numerical Kuznetsov component; nonzero leading zero-block component in
  Cai's connection matrix.
- **Open:** the central connection image of \(s(\mathcal O_p)\); existence or
  impossibility of an intrinsic-support Gysin map compatible with the general
  blowup Fourier/Gamma comparison.
