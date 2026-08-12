# C909 — trace-transfer orbit and all-degree closeout

Date: 2026-08-11  
Status: human local algebra; theorem-grade statements are explicitly scoped;
no manuscript, PDF, mirror, Lean, or commit change

## Verdict

Two free upgrades survive hostile checking.

1.  For a fixed unramified algebra `O/R` and coefficient form `C`, labelled
    self-adjoint embeddings are classified by unimodular symmetric `O`-forms
    `h` with `Tr h` isometric to `C`.  The odd rank-one and dyadic hyperbolic
    root cases each have **one local isometry orbit**.  Their stabilizers are
    explicit below.
2.  The finite-etale block theorem gives not only the minimal cofactor.  It
    gives
    
    \[
       \Theta^{[k]}:=\Theta^k/k!\in
       \operatorname{im}\bigl(
          \operatorname{Sym}^k\operatorname{NS}(A)
          \longrightarrow H^{2k}(A,\mathbf Z)
       \bigr)
       \quad(0\leq k\leq g)
       \tag{A}
    \]
    for the **distinguished principal polarization** of every finite-etale
    graph quotient.  This is an ordinary integral product statement in every
    codimension, not a Chow statement.

The second result is not a full divided-power structure on the whole
Neron--Severi ideal.  Finite-etale splitting supplies the needed square-zero
decomposition for the polarization, but the complete divisor lattice can
contain higher-`p` cross-block terms.  No argument below decomposes every such
divisor into square-zero integral divisor classes.

## 1. Orbit dictionary for self-adjoint unramified embeddings

Let `R=Z/p^a`, let `O/R` be an unramified extension of degree `m`, and let
`(M,C)` be a unimodular symmetric `R`-module.  Here `C` is the form for which
the slope must be self-adjoint.  In the graph convention of
`2026-08-11-c909-etale-block-crt-cofactor-theorem.md`, it is **`C=B^{-1}`**
when the source polarization coefficient is `p^aB`.

> **Trace-orbit theorem.**  Labelled embeddings
> \(
> \iota:O\hookrightarrow\operatorname{End}_R(M)
> \)
> whose image is `C`-self-adjoint, modulo isometries of `(M,C)` that
> intertwine the labelled `O`-actions, are in bijection with isometry classes
> of unimodular symmetric `O`-forms `(O^n,h)`, `n=rank_R(M)/m`, satisfying
> \(
>       (M,C)\simeq( O^n,\operatorname{Tr}_{O/R}h).
> \)
> The stabilizer of the labelled embedding is `O(h)(O)`.

Forwards, the perfect trace pairing defines `h` uniquely by

\[
 \operatorname{Tr}_{O/R}(\alpha h(x,y))=C(\alpha x,y)
 \quad(\alpha\in O).
\tag{1}
\]

It is symmetric, `O`-bilinear, and unimodular.  Conversely `Tr h` makes the
multiplication action self-adjoint.  The module is automatically `O`-free:
after reduction it is a vector space over the residue field of `O`; lift a
basis and apply Nakayama, then compare the `R`-lengths.  Thus no projectivity
hypothesis was omitted.

If the embedded subalgebra rather than its labelling is to be classified,
take the further quotient by `Aut_R(O)`.  Before quotienting by coefficient
isometries, the embeddings in a fixed one-orbit labelled fibre form the
finite homogeneous set

\[
            \mathrm O(C)(R)/\mathrm O(h)(O),
\tag{2}
\]

and the unlabelled one has the normalizer in the denominator.  This is a
zero-dimensional finite moduli problem, not a positive-dimensional family.

### Odd rank-one root case

Assume `p` is odd, `n=1`, and `m=rank_R M`.  Write

\[
                 h_c(x,y)=cxy,\qquad c\in O^\times.
\]

Its `O`-isometry class is the squareclass of `c`.  The determinant formula

\[
   \det_R(\operatorname{Tr}h_c)=
   \operatorname{disc}(O/R)N_{O/R}(c)
   \quad\text{modulo squares}
\tag{3}
\]

and the odd-local classification of unimodular symmetric forms by rank and
determinant show that precisely one squareclass of `c` transfers to a fixed
`C`.  Indeed, the norm induces an isomorphism

\[
 O^\times/(O^\times)^2\ \xrightarrow{\sim}\
 R^\times/(R^\times)^2
\tag{4}
\]

for an unramified odd-local extension.  Hence there is one labelled isometry
orbit.  Its stabilizer is

\[
             \mathrm O(h_c)(O)=\{u\in O^\times:u^2=1\}=\{\pm1\}.
\tag{5}
\]

For the unlabelled subalgebra, every Frobenius automorphism is realized by a
semilinear isometry: `sigma(c)/c` is a square by (4).  Thus its normalizer fits
into

\[
 1\longrightarrow\{\pm1\}\longrightarrow N
 \longrightarrow\operatorname{Gal}(O/R)\longrightarrow1
\]

and has order `2m`.  The extension need not split for an arbitrary even `m`;
it does split in the odd-degree root application used here.

For the odd prime-power root block this applies to `C=B^{-1}`, not merely to
`B`.  Since `B` and `B^{-1}` have the same rank and determinant squareclass
over an odd local ring, they are isometric, so the existing construction is
repaired by making that identification explicit.

### Hyperbolic dyadic root case

Let `p=2`, let `O/R` be unramified of degree `m`, and suppose

\[
                    (M,C)\simeq H^m,
       \qquad H=\begin{pmatrix}0&1\\1&0\end{pmatrix},
\tag{6}
\]

with `n=2`.  Then the one hyperbolic `O`-form

\[
                    h=H\quad\text{on }O^2
\tag{7}
\]

has trace transfer `H^m` (use trace-dual bases).  It is the unique `O`-form
in the trace fibre of (6).

For uniqueness, first `Tr h` even implies `h` even modulo two: if
`hbar(v,v) != 0`, choose a residue scalar `alpha` with
`Tr(alpha^2 hbar(v,v)) != 0`, contradicting evenness of the transfer.  The
mod-two quadratic refinement `h(x,x)/2` has the same Arf sign after trace
transfer.  Indeed, the absolute trace induces an isomorphism from the residue
field's Artin--Schreier quotient to `F_2`; its kernel is exactly the
Artin--Schreier image.  Since `H^m` has Arf zero,
the residual binary `O`-quadratic form has Arf zero.  A primitive residual
isotropic vector Hensel-lifts (its polar pairing with a suitable vector is a
unit); completing it to an isotropic hyperbolic pair proves `h≃H`.

Therefore there is again one labelled orbit, with stabilizer

\[
                      \mathrm O(H)(O/2^a).
\tag{8}
\]

This notation is intentional: in a dyadic quotient it is larger than just
the diagonal/anti-diagonal group.  Exactly, it consists of matrices
`[[r,s],[t,u]]` with

\[
 2rt=2su=0,\qquad ru+st=1\pmod {2^a}.
\tag{9}
\]

For `a>=2`, if the residue field of `O` has cardinality `Q=2^m`, it has
order `2(Q-1)Q^{a+1}`: the diagonal and anti-diagonal components each have
`(Q-1)Q^{a+1}` elements.  Coordinatewise Frobenius preserves (7), so the
unlabelled normalizer is `O(H)(O/2^a)\rtimes Gal(O/R)`.

The dyadic root application still has one external input: the explicit
root-weight residual form must be proved isometric to `H^m`.  Once that
isometry is supplied, (6)--(9) are a complete classification of its
trace-transfer slopes.  They do not claim a classification of arbitrary
dyadic root forms.

## 2. All divided powers of the finite-etale graph polarization

Let `(A,Theta)` be a finite-etale graph quotient as in the block theorem, and
write `P_A^k` for the ordinary integral image of `k`-fold products of divisor
classes in `H^{2k}(A,Z)`.  Then (A) holds.

The divided class in (A) is genuinely integral before this theorem is applied:
the alternating form of a principal polarization has a symplectic integral
basis, and its `k`-th exterior power is `k!` times the sum of the distinct
symplectic wedge monomials.  Thus `Theta^k/k!` belongs to integral cohomology.
Equation (14) below is the stronger assertion that it belongs to the smaller
ordinary divisor-product image.

### Proof

Work at the graph prime over a finite unramified faithfully flat coefficient
extension `R→R'` splitting `R[T]`.  The self-adjoint idempotents give the
orthogonal decomposition

\[
 M_{R'}=\perp_\lambda L_\lambda,
 \qquad p^aB=\perp_\lambda p^aB_\lambda,
\tag{10}
\]

and the exact graph Neron--Severi calculation contains every block-supported
form

\[
                    p^a\operatorname{Sym}(L_\lambda^*).
\tag{11}
\]

No diagonalization of `B_lambda` is needed, including at two.  On a free
module with basis `e_i`, the rank-one matrices `vv^t` span its symmetric
forms over **every** coefficient ring: diagonals are `e_ie_i^t`, and

\[
 (e_i+e_j)(e_i+e_j)^t-e_ie_i^t-e_je_j^t
       =e_ie_j^t+e_je_i^t.
\tag{12}
\]

There is no division by two in (12).  Applying (12) to each `p^aB_lambda`
writes the pullback coefficient of `Theta` as a finite sum of rank-one forms
from (11).  Let `D_1,...,D_s` be the corresponding elements of
`NS(A)⊗R'`.  Their sum is `Theta` because pullback along the graph isogeny is
injective on the torsion-free cohomology lattice.

Each `D_i` has square zero.  Indeed, its pullback to the elliptic power is a
rank-one coefficient form.  In exterior-algebra terms it is the decomposable
alternating two-form

\[
             p^a(e^*\otimes v)\wedge(f^*\otimes v),
\tag{13}
\]

so its square is zero.  Pullback is injective: pushforward followed by
pullback is multiplication by the isogeny degree, and abelian-variety
cohomology is torsion-free.  This proves `D_i^2=0` already on the quotient.
The argument is valid for `O`-linear `v`; no geometric `O`-endomorphism of
the elliptic curve is being asserted.

Since divisor classes have even degree, they commute.  Therefore

\[
 \frac{\Theta^k}{k!}
   =\frac{(D_1+\cdots+D_s)^k}{k!}
   =\sum_{\substack{I\subset\{1,\ldots,s\}\\|I|=k}}
       \prod_{i\in I}D_i
   \quad\text{in }H^{2k}(A,R').
\tag{14}
\]

Every term is an ordinary product of `k` divisor classes.  This proves
`Theta^[k]∈P_A^k⊗R'`.  Formation of the product image commutes with the finite
free flat base change, and faithful flatness reflects zero in the quotient
`H^{2k}(A,R)/P_A^k`.  Thus (14) descends without a trace multiplier.  At the
other primes the graph isogeny is integral-local invertible, and the same
rank-one expansion on the elliptic power proves the local assertion.  Local
membership at all primes proves (A) over `Z`.

For `k=g-1`, (14) recovers the former mixed-adjugate cofactor theorem.  It
also proves `k=g` (the top divided power) and every intermediate degree.

## 3. Boundary: not a full divided-power theorem

The proof uses the block-diagonal coefficient of the distinguished
polarization in (10).  A general graph divisor satisfies a commuting
condition; between distinct etale blocks it may have cross-block coefficients
only after an extra factor `p^a`.  The block-rank-one divisors in (11) do not
by themselves decompose all such classes.  Hence this note proves:

* the complete sequence `Theta^[k]` in the ordinary product image; and
* the same statement for any divisor known separately to have a decomposition
  into the block-supported square-zero classes.

It does **not** prove a PD structure on `NS(A)`, simultaneous mixed divided
powers for arbitrary divisor classes, a Chow identity, or a full saturation
calculation in every degree.

## Mystery ledger

* **Settled:** labelled nonsplit trace-transfer slope orbits are exactly
  trace-form isometry classes; the two root cases above are single-orbit.
* **Settled:** the finite-etale theorem upgrades from the minimal cofactor to
  all divided powers of the distinguished principal polarization.
* **TT correction:** graph self-adjointness uses `B^{-1}` in the established
  matrix convention; the trace form has to model that form.
* **Open:** prove or cite the required `I+J≃H^m` root-weight dyadic lattice
  isometry in the exact modulus needed by the construction.
* **Open:** determine whether the higher-depth cross-block divisors admit a
  different square-zero resolution, which would be required for a genuine
  full Neron--Severi PD theorem.
