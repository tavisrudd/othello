# C907 line-bundle-framed Jordan strictness

**Lane:** `clebsch`

**Status:** exact \(K_0\)-level strictness lemma plus a conditional
localization of the Silver analytic gate. Once the cyclotomic packet is
functorially selected from line-bundle-framed \(K\)-theory, blowup
block-diagonality of the candidate nilpotent is formal. The unresolved work
is constructing that selection and transporting the framing through the
indeterminacy of the rational \(\mathbf P^2\)-map.

## The exact \(K_0\) lemma

Let \(Y\) be smooth projective, let \(Z\subset Y\) be a smooth center of
codimension \(r\), and put

\[
 \pi:\widetilde Y=\operatorname{Bl}_Z Y\longrightarrow Y.
\]

For \(L\in\operatorname{Pic}(Y)\), write \(\tau_L\) for tensoring by \(L\).
In Orlov's blowup decomposition, use the ambient functor \(\pi^*\) and the
exceptional functors

\[
 \Phi_j(F)=i_*\bigl(p^*F\otimes\mathcal O_E(-j)\bigr),
 \qquad 1\le j\le r-1.
\]

The projection formula gives canonical intertwining identities

\[
 \tau_{\pi^*L}\pi^*=\pi^*\tau_L,
 \qquad
 \tau_{\pi^*L}\Phi_j=\Phi_j\tau_{L|Z}.
 \tag{1}
\]

Consequently the induced operator on rational \(K_0\) is block diagonal:

\[
 \bigl(K_0(\widetilde Y)_{\mathbf Q},\tau_{\pi^*L}\bigr)
 \cong
 \bigl(K_0(Y)_{\mathbf Q},\tau_L\bigr)
 \oplus\bigoplus_{j=1}^{r-1}
 \mathsf T^j\bigl(K_0(Z)_{\mathbf Q},\tau_{L|Z}\bigr).
 \tag{2}
\]

Here \(\mathsf T\) records an exceptional Tate position and is not the tensor
operator. The Chern character sends \(1-[L]\) to
\(1-e^{c_1(L)}\), which has positive Chow degree; hence
\((1-[L])^{\dim Y+1}=0\) in rational \(K_0\).  Thus every polynomial in
\(\tau_L\), in particular

\[
 N_L=1-\tau_L,
 \tag{3}
\]

is block diagonal with the actual Orlov component maps on \(K_0\). Thus all
recursive \(\operatorname{Ext}^1_{K[N]}\) obstruction classes vanish for this
framed operator. This is stronger than an abstract equality of Jordan forms.
No numerical-\(K\) direct-sum claim is needed.

## Endpoint and carrier calculations over \(\mathbf P^2\)

Let \(f:Y\to\mathbf P^2\) and take \(L=f^*\mathcal O(1)\). In
\(K_0(\mathbf P^2)_{\mathbf Q}\), put \(x=1-[\mathcal O(1)]\).
Then \(x^3=0\), while \(\operatorname{ch}(x^2)=h^2\ne0\); consequently
\(1,x,x^2\) form one Jordan block of length three and

\[
 N_L^3=0.
 \tag{4}
\]

With projective/Kunneth compatibility, the one-dimensional generalized
\(\zeta_6\)-sector of \(X\) tensored with \(K_0(\mathbf P^2)\) therefore
carries exactly \(J_3\) on \(X\times\mathbf P^2\).

Every blowup of a model already mapping to \(\mathbf P^2\) inherits \(L\),
and (1)--(3) make its \(K_0\)-operator comparison strictly split. On a smooth
threefold center \(Z\), choose a general point \(q\in\mathbf P^2\) with
smooth curve fibre \(i:F=f^{-1}(q)\hookrightarrow Z\). The Koszul resolution
of \(q\) gives, up to a line-bundle unit acting trivially on the point class,

\[
 (1-[\mathcal O(1)])^2=[\mathcal O_q].
\]

Hence

\[
 N_L^2(x)=x\cdot f^*[\mathcal O_q]=i_*Li^*(x).
 \tag{5}
\]

If the cyclotomic realization respects this support factorization and every
curve has zero primitive-sixth packet, (5) forces \(N_L^2=0\) on the center
packet. Thus the same bridge would prove both strictness and the no-\(J_3\)
carrier theorem for centers already mapping to \(\mathbf P^2\).
Support-locality is essential; it does not follow from a vector-space
embedding in \(K_0\).

## The conditional cyclotomic bridge

Rational \(K_0\) is not itself the C907 invariant. To consume the lemma, one
needs all of:

1. an exact additive packet functor, or a \(\tau_L\)-stable projector,
   selecting the whole generalized \(\zeta_6\) packet and preserving the
   Orlov idempotents and component maps in (1)--(2); a bare stable subquotient
   can mix the blocks and is insufficient;
2. a Gamma/formal comparison supplying that functorial selection;
3. Tate shifts preserving the chosen cyclotomic sector;
4. projective/Kunneth compatibility identifying the cubic
   \(\zeta_6\)-line tensored with \(K_0(\mathbf P^2)\) with the entire
   endpoint packet;
5. presentation independence on the operation-framed category used by weak
   factorization; and
6. for the carrier conclusion, support-local compatibility with
   \(i_*Li^*\) in (5).

Under these hypotheses, (2) supplies the strict \(K[N]\)-biproduct directly,
and item 6 makes (5) supply the no-\(J_3\) center theorem on relative arrows.

## Where the difficulty localizes

If \(X\times\mathbf P^2\) were birational to \(\mathbf P^5\), projection to
\(\mathbf P^2\) would induce only a rational map
\(\mathbf P^5\dashrightarrow\mathbf P^2\). After resolving its base ideal,
the hyperplane framing becomes a line bundle and the exact lemma applies to
all subsequent arrows over \(\mathbf P^2\). It does not automatically apply
to the resolution steps creating that line bundle: on the unresolved model
the datum is a movable linear system or Cartier \(b\)-divisor.

This localizes, but does not by itself shrink, the analytic gate:

> extend the cyclotomic tensor operator to the Rees resolution of the
> three-section linear system, and prove that its exceptional base-ideal
> terms contain no \(J_3\) and no nonsplit cyclotomic extension.

The smooth centers introduced by the base-ideal resolution can still be
arbitrary threefolds, so this does not evade the universal carrier theorem
without extra structure. An alternative is a relative weak-factorization
theorem in which the movable framing and its Gamma realization are part of
the object.

## EJ/TT and mystery ledger

- **EJ:** tensor by a framed hyperplane already has the endpoint \(J_3\) and
  is exactly block diagonal under Orlov blowups; the full Stokes matrix is
  not logically needed after the cyclotomic projector exists.
- **TT:** ask where the line bundle ceases to exist. Descended arrows are
  formally strict; new information is concentrated in the base ideal of the
  rational \(\mathbf P^2\)-map.
- **Settled:** strict \(K_0\) component-map compatibility, the endpoint
  calculation, the curve-support factorization of its square, and the exact
  hypotheses needed to descend them to the cyclotomic packet.
- **Open:** the Gamma/cyclotomic projector, projective compatibility, Rees
  transport through the base-ideal resolution, presentation independence,
  and universal support-local center-square vanishing.
