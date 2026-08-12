# C909: etale graph saturation and the higher-exponent gate

Date: 2026-08-11  
Status: elementary-prime theorem proved; higher-exponent generalization
quarantined  
Scope: ordinary integral divisor products on polarized quotients of non-CM
elliptic powers; no manuscript, PDF, mirror, or Lean edit

## Exact positive theorem

Let `f:E^g -> (A,Theta)` be a polarized elementary `p`-isogeny from a
non-CM elliptic power.  Write its coefficient polarization as `pB`, with
`B` symmetric unimodular, and suppose its maximal isotropic kernel is
transverse to one of the two elliptic rulings.  In such a ruling the kernel
is the graph of a `B`-self-adjoint operator

\[
                         T\in\operatorname{End}(M/pM).
\]

Call the presented kernel **etale** when `F_p[T]` is finite etale, equivalently
when the minimal polynomial of `T` is squarefree.

> **Etale graph cofactor saturation.**  If the presented kernel is etale,
> then
> \[
>   \frac{\Theta^{g-1}}{(g-1)!}
>   \in\operatorname{im}\left(
>     \operatorname{Sym}^{g-1}\operatorname{NS}(A)
>       \longrightarrow H^{2g-2}(A,\mathbf Z)\right).
> \]

The conclusion is membership in the ordinary integral divisor-product
lattice, not merely algebraicity of the minimal class.

## Structural proof

Choose a finite unramified extension `O/Z_p` that splits the etale slope
algebra.  Its self-adjoint primitive idempotents give an orthogonal
decomposition

\[
                   M\otimes O=\mathop\perp_\lambda M_\lambda
\]

with unimodular restricted forms `B_lambda`, and `T` acts by a scalar on
each residue block.  The graph integrality calculation then supplies every
block-supported divisor coefficient in

\[
                   p\operatorname{Sym}_{B_\lambda}(M_\lambda,O).
\]

The mixed determinant contains `1`, while the mixed adjugates span the full
self-adjoint coefficient lattice with coefficients `+/-1`.  By `O`-linearity
these primitive identities realize `det(B_mu)` on every non-target block and
all entries of `adj(B_lambda)` on a target block.  Filling one target block
at a time constructs the full cofactor of the pulled-back polarization.
There is no factorial and no off-diagonal factor two.

If `P` is the local divisor-product image and `H` its ambient integral Hodge
lattice, the constructed membership says that the class in `H/P` dies after
tensoring with `O`.  Faithful flatness makes

\[
                         H/P\longrightarrow(H/P)\otimes O
\]

injective.  Thus membership descends without a trace and without multiplying
by the residue degree.  Away from `p`, the isogeny identifies the integral
homology, Neron--Severi, and product lattices, so localization gives the
global result.

## Exact intrinsic scope

Changing the transverse elliptic ruling replaces `T` by a fractional-linear
transform

\[
                         T'=(c+dT)(a+bT)^{-1}.
\]

The inverse transform expresses `T` in `T'`, and Cayley--Hamilton makes the
inverse denominator polynomial in `T`.  Hence `F_p[T]=F_p[T']`.  Coefficient
isometries only conjugate this algebra.

Thus etaleness is intrinsic to the **marked elliptic-power presentation** and
independent of its transverse graph chart.  It is not intrinsic to the bare
ppav or to an arbitrary symplectic presentation of its kernel.  General
symplectic shears can send a squarefree graph to a nilpotent one; allowing
them would make the condition vacuous.

## Strict reach beyond scalar gluing

For every `g>=3`, the dyadic slope

\[
 T_g=\begin{pmatrix}0&1\\1&1\end{pmatrix}\oplus0_{g-2}
\]

has etale algebra `F_4 x F_2`.  Its graph is nonsplit over `F_2`, but the
theorem constructs the primitive minimal class after trace-free unramified
splitting and descent.  This gives an infinite nonscalar family and shows
that the theorem is not merely a repackaging of scalar Jordan blocks.

Squarefree is sufficient, not necessary.  At `p=5,g=3`, take
`T=uu^t` with `u=(1,2,0)^t`.  Then `T` is nonzero and `T^2=0`, but the
factorial threshold `p>g-1` makes every prime-five gluing primitive.  Passing
to primary semisimplification cannot repair necessity: it forgets precisely
the integral carry that distinguishes primitive from defective nilpotent
examples.

## Why the naive higher-exponent theorem is not yet proved

At level `R_a=Z_p/p^a`, two extra issues are load-bearing.

1. Divisor coefficients must be `B`-self-adjoint endomorphisms.  For source
   form `p^aBD`, the graph condition is
   \[
                            [D,T]\equiv0\pmod {p^a},
   \]
   not a raw transpose-symmetry condition in an arbitrary basis.
2. Squarefree reduction of `T` modulo `p` does not imply that `R_a[T]` is
   finite etale.  For example, `T=p\begin{psmallmatrix}0&1\\1&0\end{psmallmatrix}`
   over `Z/p^2` reduces to the scalar zero slope but generates a nonflat
   algebra with a `p`-torsion summand.

The safe higher-level statement is currently conditional: if a compatible
Jordan block quotient is known to contribute the full lattice

\[
             p^a\operatorname{Sym}_{B_a}(M_a,\mathbf Z_p),
\]

then the mixed-adjugate theorem constructs its cofactor.  Proving that a
geometric kernel supplies this lattice requires a finite-etale, flat
`R_a`-algebra and an exact graph-integrality audit.  This is the next C909
gate; it is not silently inferred from squarefree reduction.

Likewise, root-weight coefficient matrices supply the right local Jordan
blocks, but an unconditional new family requires explicit compatible local
kernels, CRT globalization, and self-duality.  A statement quantifying over
already-etale kernels is a criterion, not a construction.

## Strength and boundary

The elementary theorem is a real structural compression and a strict reach
upgrade over the cubic application.  It is plausibly a strong component of a
broader paper, but is not an Annals crown by itself.  The crown remains an
intrinsic arbitrary-gluing classification or an exact higher-level defect
formula, owned primarily by C908.

## Mystery ledger

- **Settled:** elementary semisimple slopes and scalar elementary slopes are
  one finite-etale mechanism.
- **Settled:** unramified splitting and descent lose no multiplier.
- **Settled:** the condition is chart-independent at the level of the marked
  elliptic-power presentation, and no further.
- **Settled:** squarefree is not a converse.
- **Open:** prove the corrected flat finite-etale theorem over `Z/p^a`.
- **Open:** construct and globalize a natural nonscalar higher-level family.
- **Open:** classify the nilpotent carry; owned by C908.
