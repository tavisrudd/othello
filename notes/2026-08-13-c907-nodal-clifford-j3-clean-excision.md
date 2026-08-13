# C907 nodal Clifford socle versus the `J_3` carrier

**Lane:** `clebsch`

**Verdict:** the rank-one nodal Clifford fibre does **not** by itself realize
the endpoint `J_3`.  Its nonzero socle is an ordered composite of two
different branch actions, whereas `J_3` requires one strict Rees endomorphism
with nonzero square.  If the strict value-localized realization factors
support-locally through the clean primitive conic sheaf, then that ordered
composite has zero image.  The remaining gap is exactly the strict
Stokes/Gamma factorization; raw Clifford algebra neither supplies it nor
contradicts it.

## 1. The raw fibre is not yet a `J_3`

At a rank-one node the even Clifford fibre is

\[
 E=\Lambda_A(i,j),\qquad
 i^2=j^2=0,\quad ij=-ji,\quad \mathfrak j=(i,j),
 \quad \mathfrak j^2=A\,ij\ne0.
 \tag{1}
\]

Thus the two branch multiplications have a nonzero ordered composite

\[
 \ell_i\ell_j=\ell_{ij}\ne0. \tag{2}
\]

But this is not the same datum as a single Rees operator `N` with
`N^2!=0`.  In fact every element of the radical has square zero.  If

\[
 a=ri+sj+tij\in\mathfrak j,
 \tag{3}
\]

then anticommutativity and the square-zero relations give `a^2=0`; hence

\[
 \ell_a^2=0\quad\text{on every }E\text{-module}. \tag{4}
\]

The endpoint indexing is

\[
 J_3:\quad N^2\ne0,\ N^3=0,
 \qquad
 J_2:\quad N\ne0,\ N^2=0. \tag{5}
\]

Consequently `ij!=0` says that the *ideal* has Loewy length three; it does
not construct the endpoint `J_3` as a module for one radical multiplication.
To turn (2) into (5), a Stokes/Rees bridge would have to do additional work:
identify the two branch arrows with successive applications of one strict
operator (or otherwise produce a single `N` whose square is the image of
`ij`).  That identification is not contained in the Clifford order,
cohomological amplitude, or its Frobenius pairing.

This is the first obstruction to treating the node socle as a Silver
counterexample.  It is consistent with the stationary Picard--Lefschetz
formal model, where a deliberately chosen algebra has one element `e` with
`e^2=m!=0`; the exterior node algebra has no such radical element.

## 2. Clean primitive excision kills the ordered composite

Let `pi:X->S` be a smooth-total-space conic bundle and let `p` be a rank-one
double-line node.  With `A=Z[1/6]`, set

\[
 P_\pi=\operatorname{coker}
 \bigl(A_S(-1)\longrightarrow R^2\pi_*A_X\bigr). \tag{6}
\]

On each punctured rank-two branch through `p`, `P_pi` is the
component-difference local system.  Transverse monodromy exchanges the two
components, so it acts by `-1`.  Since `2` is invertible in `A`, both its
invariants and coinvariants vanish.  The double-line fibre itself has the
Betti space of one projective line and its ambient hyperplane class spans
`H^2`.  Therefore, writing `i_p` for the node inclusion,

\[
 i_p^*P_\pi=0,\qquad i_p^!P_\pi=0. \tag{7}
\]

Equivalently, the branch local system has clean derived extension at the
node: `Rj_*L=j_!L`, with no node stalk or costalk.  This is stronger than a
dimension or duality argument: there is no primitive target at the support
intersection for the branch product.

Here is the exact conditional statement relevant to C907.

> **Clean-node Rees lemma.**  Suppose a strict value-localized cubic
> Stokes/Gamma realization `Phi` of a conic bundle has positive branch arrows
> which factor through `P_pi`, preserves the Rees operator and Gamma lattice,
> and is support-local in the following sense: the image under `Phi` of a
> composite supported at `p` factors through either `i_p^!P_pi` or
> `i_p^*P_pi`.  Then
> \[
> \Phi(ij)=0.
> \tag{8}
> \]
> In particular no `J_3` block can be produced by this nodal branch pair.

**Proof.**  The branch composite is supported at their intersection.  The
support-local factorization has zero source or target by (7), proving (8).
If the strict Rees square is the image of this composite, it is zero; and if
the individual arrow is radical multiplication, it was already square-zero
by (4). \(\square\)

Together with the smooth-discriminant reduced-radical calculation and the
rank-two-cross calculation, the same hypotheses yield `I_(1/6)^2=0` for the
whole conic branch.  That is stronger than the corrected Silver need
(`ell<=2` suffices): it proves `ell<=1` in this subclass.

## 3. What is and is not settled

The clean-node theorem is a genuine geometric reason for annihilating the
Clifford socle, but only **after** the stated strict realization.  It does not
hold for the regular `E`-module, which retains `ij`, nor for a raw coherent
or de-Rham Clifford model carrying nilpotent-thickening data.  A functor can
also evade (8) by sending the product to a stationary sector unrelated to
the clean primitive sheaf; that is exactly what must be ruled out by
support-locality, not by formal monodromy or self-duality.

The biprojective calibration makes this nonoptional.  For

\[
 V=\{Xu^2+Yv^2+Zw^2=0\}\subset\mathbf P^2\times\mathbf P^2,
 \tag{9}
\]

the first projection has precisely the node algebra (1), while the second
identifies `V` with a `P^1`-bundle over `P^2`.  Under the required strict
projective-bundle formula its cubic packet is zero.  Hence any
presentation-independent strict realization must send this example's `ij`
to zero; a nonzero image would already fail a mandatory regression.

Thus the strongest honest current conclusion is:

\[
 \boxed{\begin{array}{c}
 \text{raw nodal Clifford socle }ij\ne0
 \ \not\Rightarrow\ \text{a strict endpoint }J_3;\\[2pt]
 \text{clean primitive support-local Stokes/Gamma factorization}
 \ \Rightarrow\ \Phi(ij)=0\ \Rightarrow\ \ell\le1
 \text{ for conic nodes.}
 \end{array}} \tag{10}
\]

The unresolved finite analytic input is a comparison which proves that the
actual value-localized Rees product lands in this clean primitive complex,
rather than retaining the order's point-socle or mapping it into an
independent stationary sector.  The nodal conic is therefore a sharp
regression and a clear target, not presently a threefold `J_3` carrier or a
counterexample to the corrected `m=2` theorem.

## EJ/TT and mystery ledger

- **EJ:** distinguish a nonzero two-colour branch product from the square of
  one Rees operator.  This removes the false automatic `J_3` inference.
- **TT:** stalk *and* costalk zero at the double line supplies the exact
  support-theoretic quotient missing from the raw Clifford order.
- **Settled:** the clean primitive factor kills the node socle conditionally;
  the explicit biprojective node must be killed by any invariant strict
  realization.
- **Open:** strict value-localized Stokes/Gamma factorization, its
  support-local product rule, and exclusion of a stationary escape sector.
