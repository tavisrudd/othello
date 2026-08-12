# C909 — equal-depth finite-etale graphs: full NS and PD theorem

Date: 2026-08-11  
Status: bounded equal-depth local theorem; unequal elementary divisors are
explicitly excluded; no manuscript, PDF, mirror, Lean, or commit change

## Verdict

For one equal-depth block `G=p^aB`, the full finite-etale graph
Neron--Severi coefficient lattice is generated, after finite unramified
splitting, by **actual rank-one square-zero divisor classes**.  Consequently
the ordinary product image equals the divided-power envelope of the complete
local NS lattice in every degree.  This holds at `p=2` and for non-diagonal
unimodular `B`.

This theorem does **not** address a source polarization with unequal
`p`-elementary-divisor exponents.  The simple one-extra-`p^a` cross-block
calculation below uses a common graph denominator `p^a`; it must not be
imported into that situation.

## 1. Exact cross-eigenblock lattice

Let `R=Z/p^a`, let `B` be unimodular on `M_R`, and let the graph slope `T`
satisfy the finite-etale condition.  Work after a finite unramified
coefficient extension `R→S` splitting `R[T]`.  Its primitive idempotents give

\[
 M_S=\perp_{\lambda\in\Lambda}L_\lambda,
 \qquad B=\perp_\lambda B_\lambda,
 \qquad T|_{L_\lambda}\equiv t_\lambda\pmod {p^a}.
\tag{1}
\]

For distinct labels the residues of `t_lambda` are distinct, hence

\[
                         t_\lambda-t_\mu\in S^\times
                         \quad(\lambda\ne\mu).
\tag{2}
\]

Write a divisor coefficient in the graph formula as `A=(A_{lambda mu})`.
The exact integrality calculation is

\[
 A=A^t,\qquad A\in p^a\operatorname{Sym}(M_S^*),
 \qquad AT^t-TA\equiv0\pmod {p^{2a}}.
\tag{3}
\]

On the `(lambda,mu)` entry, (3) reads

\[
 p^aX_{\lambda\mu}(t_\mu-t_\lambda)
             \equiv0\pmod {p^{2a}}.
\tag{4}
\]

Thus (2) gives `X_{lambda mu}∈p^a`, while diagonal entries have no further
restriction.  Conversely these valuations plainly make (3) integral.
Therefore the complete coefficient lattice is exactly

\[
 \boxed{\quad
 \mathcal N_S=
   \bigoplus_\lambda p^a\operatorname{Sym}(L_\lambda^*)
   \ \oplus\!
   \bigoplus_{\lambda<\mu}p^{2a}
       (L_\lambda^*\otimes L_\mu^*)_{\mathrm{sym}}.
 \quad}
\tag{5}
\]

Here the off-diagonal summand denotes the symmetric coefficient matrix
determined by a rectangular bilinear coefficient.  Formula (5) is independent
of a non-diagonal `B_lambda`: `A` is the symmetric bilinear coefficient in
the graph calculation, while `B` determines the self-adjoint convention that
led to (3).  The common exponent is essential.

## 2. Rank-one generation, including at two

Every form in (5) is an integral linear combination of rank-one elements
that themselves belong to (5).

* Within `L_lambda`, the forms `p^a uu^t` span
  `p^a Sym(L_lambda^*)`.
* For `u∈L_lambda^*`, `v∈L_mu^*`, `lambda!=mu`, the cross generator is
  
  \[
  p^{2a}(uv^t+vu^t)
   =p^{2a}(u+v)(u+v)^t-p^{2a}uu^t-p^{2a}vv^t.
  \tag{6}
  \]

The three terms on the right lie in (5): their diagonal coefficients are
allowed at depth `p^a`, and the first term has cross coefficient `p^{2a}`.
There is no division by two in (6), so this works unchanged for `p=2`.
Choosing bases proves the assertion for every rectangular coefficient.

Each rank-one element `p^bww^t` in this construction is an actual divisor
class in the graph NS lattice, by the exact iff in (3).  Its pullback to the
elliptic power is the decomposable alternating form

\[
          p^b(e^*\otimes w)\wedge(f^*\otimes w),
\tag{7}
\]

so its square vanishes.  Pullback by the isogeny is injective on integral
cohomology: its composite with pushforward is multiplication by the degree,
and the cohomology of an abelian variety is torsion-free.  Hence every
rank-one generator in (5) is square-zero already on the graph quotient.

## 3. Full divided-power consequence

Let `N_S^1` be the divisor lattice represented by (5), and put

\[
 P_S^k=\operatorname{im}
 \left(\operatorname{Sym}^kN_S^1\to H^{2k}(A,S)\right).
\]

For every `D∈N_S^1`, write `D=sum_i c_iR_i` using the square-zero rank-one
classes just constructed.  Since degree-two classes commute,

\[
 \frac{D^k}{k!}=
 \sum_{|I|=k}\left(\prod_{i\in I}c_i\right)\prod_{i\in I}R_i
 \in P_S^k.
\tag{8}
\]

The class on the left is integral independently: an integral alternating
two-form has integral divided exterior powers (equivalently use its integral
skew-normal form).  Formula (8) proves the stronger product membership.
Because ordinary products are products of first divided powers, it follows
that

\[
 \boxed{\quad
 \operatorname{PD}\langle N_S^1\rangle^k=P_S^k
 \qquad(0\le k\le\operatorname{rank}M).
 \quad}
\tag{9}
\]

This means the divided-power envelope inside integral cohomology generated
by the **full equal-depth graph NS lattice**; it is neither a Chow statement
nor a claim that all Hodge classes are divisor products.

For a presentation defined over `R`, (9) descends locally to `R`: the graph
NS coefficient lattice and the finite product image are base changes of the
specified `R`-lattices, so faithful flatness applied to
`H^{2k}/P_R^k` sends the membership in (8) back to `P_R^k`.  Equivalently,
every `D∈N_R^1` has `D^[k]∈P_R^k`; this yields
`PD<N_R^1>^k=P_R^k`.  This descent concerns the prescribed cohomological
NS/product lattice.  It does not descend potentially new geometric Picard
classes acquired over a field extension.

## Boundary and mystery ledger

* **Settled:** in the equal-depth finite-etale case, cross-eigenblock entries
  have exact valuation `p^{2a}` in the symmetric coefficient `A`, versus
  `p^a` on a diagonal eigenblock.
* **Settled:** those cross terms do not obstruct rank-one generation; (6) is
  the square-zero resolution, valid dyadically.
* **Settled:** full `PD(NS)=ordinary-product image` holds locally in all
  cohomological degrees for this equal-depth presentation.
* **Excluded:** unequal exponent blocks, where the graph basis has different
  denominators and (4)--(6) no longer give the exact valuation lattice.
* **Excluded:** nilpotent/non-etale slope algebras, Chow identities, and an
  arbitrary bare ppav without its marked equal-depth graph presentation.
