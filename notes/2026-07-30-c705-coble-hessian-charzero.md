# C705 — characteristic-zero Coble conormal Hessian identity

**Date:** 2026-07-30  
**Status:** exact positive lift  
**Scope:** the fixed rational Burkhardt parameter
\(\alpha=(6,17,1,-7,-19)\)

## Theorem

Let \(V\) be the nine-dimensional Schrödinger coordinate space, let
\[
 F=3G_\alpha\in\operatorname{Sym}^3(V^\vee),
\]
and let \(H\in\operatorname{Sym}^6(V)\) be the equation of the dual Coble
sextic, normalized so that its first nonzero coefficient in the frozen
43-orbit Heisenberg basis is \(1\).  Then, in the coordinate ring of the
Coble cubic \(X=(F=0)\),
\[
 69984\,\nabla H(\nabla F(x))
 +\det\!\operatorname{Hess}(F)(x)\,x=0.                 \tag{1}
\]
Thus the conormal inverse scalar is
\[
 \lambda_H(x)=-\frac1{69984}\det\!\operatorname{Hess}(F)(x). \tag{2}
\]
This lifts the 100-pair mod-\(101\) observation to characteristic zero.
Indeed
\[
 -1/69984=45\pmod {101},
\]
exactly the scalar in the earlier finite-field certificate.

The intrinsic normalization is determinant-valued.  The Hessian
determinant naturally lies in
\[
 \operatorname{Sym}^9(V^\vee)\otimes(\det V^\vee)^{\otimes2}.
\]
Consequently the dual equation has a unique normalization
\[
 \widehat H\in
 \operatorname{Sym}^6(V)\otimes(\det V^\vee)^{\otimes2}
\]
for which
\[
 \nabla\widehat H(\nabla F)=
 \det\!\operatorname{Hess}(F)\,x
 \quad\text{on }X.                                    \tag{3}
\]
In the ordered Schrödinger volume and the orbit normalization above,
\(\widehat H=-69984H\).  Formula (3), rather than the coordinate integer
\(69984\), is the normalization-free statement.

## Exact proof

Nguyen proves that the Coble sextic is the projective dual of the Coble
cubic and that the polar map has generic degree one.  The Heisenberg action
preserves the sextic equation line.  Hence the actual dual equation belongs
to the frozen 43-dimensional degree-six orbit space and vanishes at every
conormal point \((x,\nabla F(x))\).

The primary exact reconstruction starts from the rational cubic point
\[
 (2,-2,-2,-4,2,2,-3,-1,-3).
\]
Deterministic tangent lines through this point produce sixty rational
points of \(X\).  Evaluation of the 43 orbit sums at the first 42 conormals
has rank \(42\) over \(\mathbf Q\).  Therefore its one-dimensional kernel
is the actual dual-sextic equation line, not merely an interpolant.  Three
large-prime nullspaces and rational reconstruction recover its 43 rational
coefficients; eighteen further exact conormals are held out and all vanish.

An independent Singular calculation then works in
\(\mathbf Q[x_0,\ldots,x_8]/(F)\).  It clears the coefficient denominator
by writing \(H_{27}=27H\), constructs the Hessian determinant directly,
and reduces all nine components of
\[
 2592\,\nabla H_{27}(\nabla F)
 +\det\!\operatorname{Hess}(F)\,x.
\]
Every remainder is zero.  Since \(2592\cdot27=69984\), this proves (1).
One exact rational conormal witness independently evaluates the scalar as
\(-1/69984\).

This proof does not infer a characteristic-zero identity from finite
sampling.  Finite rank identifies the already-known invariant dual equation
line; the nine polynomial reductions prove the identity.

## Reproduction

Generate or check the rational reconstruction and the generated Singular
certificate:

```sh
cd /home/tavis/src/othello/rust
nix-shell -p python3 python3Packages.sympy --run \
  'python3 ../notes/2026-07-30-c705-coble-hessian-charzero.py --check'
```

Replay the polynomial identity independently:

```sh
cd /home/tavis/src/othello/rust
nix-shell -p singular --run \
  'Singular -q ../notes/2026-07-30-c705-coble-hessian-charzero.sing'
```

The expected replay line is:

```text
PASS 9 exact characteristic-zero components
```

The JSON certificate records the 43 coefficients, reconstruction primes,
rank \(42\), eighteen held-out checks, the rational scalar witness, and the
mod-\(101\) comparison.  The `.sing` file is generated canonically by the
Python checker.  The adjacent `.sha256` manifest records hashes and byte
counts.  The validated tool versions are SymPy 1.14.0 and Singular 4.4.1.
The trusted inputs are the displayed rational Burkhardt parameter, Nguyen's
duality theorem and Heisenberg invariance, and exact arithmetic in those two
systems.  The computation proves the theorem for this fixed
characteristic-zero Coble pair; it does not assert the same displayed
coordinate scalar for every Burkhardt parameter.

## Literature boundary

The imported geometric facts are from Quang Minh Nguyen,
*Vector bundles, dualities, and classical geometry on a curve of genus two*,
arXiv:math/0702724: §§2.1 and 3.3--3.4, especially Theorem 3.4.1 and
Proposition 3.4.2.  Nguyen proves that the Coble cubic and sextic are dual,
identifies the polar map by the complete Heisenberg system of quadrics, and
proves that the dual map has generic degree one.  Nguyen does not state
(1)--(3).  Cached PDF SHA-256:
`93e0fb99b62a6b5f9c2229791b98b785e2946942e5946935ad7c4282311ab90b`;
the cited sections were read at formula and proof-context level.

## Closeout passes

- **ej:** clearing the orbit denominator turns the sampled proportionality
  into the unexpectedly small integral identity
  \(2592\nabla H_{27}(\nabla F)+\det(\operatorname{Hess}F)x=0\).
  Its reduction recovers \(45\) mod \(101\) without a fitted constant.
- **tt:** the meaningful normalization is not “first orbit coefficient
  equals one.”  Treating the Hessian determinant as a
  \((\det V^\vee)^{\otimes2}\)-valued covariant turns the scalar coincidence
  into the coordinate-free normalization (3).

## Mystery ledger

- **Settled:** the 100-pair finite-field proportionality is a genuine
  characteristic-zero polynomial identity on the fixed Coble cubic.
- **Settled:** the exact orbit-normalized scalar is \(-1/69984\), whose
  mod-\(101\) reduction is \(45\).
- **Settled:** the intrinsic normalization is the determinant-valued dual
  equation \(\widehat H\), for which the scalar is \(1\).
- **Settled negative:** the identity remains conormal.  The prior five
  off-cubic ratios prove that it does not extend as
  \(H(\nabla F)=cF\det(\operatorname{Hess}F)\) on the ambient space.
- **Open, adjacent crown:** determine whether the determinant-valued
  normalization globalizes over the smooth Burkhardt parameter space and
  whether \(69984\) factors into natural theta/Heisenberg determinant-line
  indices.  This is not needed for the fixed-pair theorem.
- **Open, owning C705 frontier:** test the stronger common
  golden/\(E_8\) parent now that the Coble elder-parent normalization is
  exact.
