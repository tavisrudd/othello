# C907 base-ideal framing obstruction

**Lane:** clebsch

**Status:** exact negative theorem for extending line-bundle-framed
strictness naively through a rational-map resolution. Even a packet-empty
base center can create a raw \(K_0\) \(J_3\), because the moving hyperplane
includes the exceptional divisor and does not preserve the old Orlov blocks.

## Linear-projection counterexample

Let \(q:\mathbf P^5\dashrightarrow\mathbf P^2\) be linear projection from a
plane \(\Lambda\simeq\mathbf P^2\). Its graph resolution is

\[
 \mu:R=\operatorname{Bl}_\Lambda\mathbf P^5\longrightarrow\mathbf P^5,
 \qquad f:R\longrightarrow\mathbf P^2.
 \tag{1}
\]

If \(E\) is the exceptional divisor, the resolved base hyperplane is

\[
 L=f^*\mathcal O_{\mathbf P^2}(1)
 =\mu^*\mathcal O_{\mathbf P^5}(1)\otimes\mathcal O_R(-E).
 \tag{2}
\]

Put \(N_L=1-\tau_L\) on \(K_0(R)_{\mathbf Q}\). Since \(f\) is a
\(\mathbf P^3\)-bundle,

\[
 N_L^2=f^*\bigl(1-[\mathcal O_{\mathbf P^2}(1)]\bigr)^2
 =f^*[\mathcal O_q]
 =[\mathcal O_{\mathbf P^3\text{-fibre}}]\ne0,
 \qquad N_L^3=0.
 \tag{3}
\]

Thus the resolved raw \(K_0\) operator contains a \(J_3\), even though
\(\mathbf P^5\) and the surface center \(\Lambda\) both have zero
primitive-sixth packet. Dimension, center-packet vanishing, and the resolved
morphism to \(\mathbf P^2\) do not imply \(J_3\)-freeness before cyclotomic
projection.

## Exact Orlov failure mechanism

For a codimension-two blowup, the sole exceptional functor is

\[
 \Phi_1(F)=i_*\bigl(p^*F\otimes\mathcal O_E(-1)\bigr).
\]

Tensoring by the exceptional correction in (2) gives

\[
 \tau_{\mathcal O_R(-E)}\Phi_1(F)=i_*p^*F,
 \tag{4}
\]

the \(j=0\) term, outside the single exceptional Orlov block. Therefore the
projection-formula block-diagonality for a line bundle pulled back from the
model before blowup does not apply: the moving frame
\(\mu^*L_0(-mE)\) mixes the formal blocks.

Successive codimension-two principalization steps can consequently join
separate \(J_1\) grades into

\[
 e_0\longmapsto e_1\longmapsto e_2\longmapsto0,
\]

although every associated grade is square-zero. This is precisely the
recursive \(K[N]\)-extension obstruction isolated earlier.

## The base-ideal centers are not harmless

Embed a smooth cubic threefold as

\[
 X=\{A=B=0\}\subset\mathbf P^5,
 \qquad \deg A=1,\quad\deg B=3,
\]

and take \(q=[A^4:BC_1:BC_2]\) for general linear forms \(C_1,C_2\). This is
dominant on \(A\ne0\), while generically along \(X\) its base ideal is
\((a^4,b)\). Principalization produces a chain of infinitely-near
codimension-two centers over \(X\), plus lower-dimensional residual loci.
The indeterminacy centers do not yet map to \(\mathbf P^2\), so the relative
curve-fibre square-zero lemma cannot be invoked on them.

Thus a three-section base ideal can contain exactly the arbitrary
threefold-carrier geometry Silver must control.

## Sharp conditional replacement

Let

\[
 Y_0\longleftarrow Y_1\longleftarrow\cdots\longleftarrow Y_s=R
\tag{5}
\]

be a smooth principalization and write
\(L_i=\pi_i^*L_{i-1}(-m_iE_i)\) for the moving frame. A sufficient
base-ideal theorem is an exact cyclotomic packet construction satisfying:

1. every step carries the moving-frame operator \(N_i=1-\tau_{L_i}\);
2. its filtered Orlov comparison is recursively split as an ungraded
   \(K[N]\)-module with the actual component maps;
3. exceptional terms over packet-zero centers vanish;
4. codimension-two terms over threefold centers are \(J_3\)-free; and
5. no cross-stage extension joins successive exceptional grades.

Conditions 2 and 5 are stronger than an associated-graded exceptional-string
formula. Under them, codimension at least three centers have dimension at
most two and vanish, while the remaining codimension-two terms consume
exactly the threefold carrier theorem. Hence the resolved \(\mathbf P^5\)
packet is \(J_3\)-free, and the relative line-bundle-framed theorem handles
the later factorization over \(\mathbf P^2\).

This is not a smaller proof of the carrier theorem: the cubic example shows
it contains the arbitrary cubic-threefold case. It is nevertheless an exact
localization of the missing data to moving-frame exceptional mixing.

## EJ/TT and mystery ledger

- **EJ:** the obstruction is visible in one formula:
  \(\mathcal O(-E)\) moves the exceptional \(j=-1\) block into \(j=0\).
- **TT:** empty center packet does not imply the raw framed \(K_0\) operator
  stays empty; linear projection produces an explicit \(J_3\).
- **Settled:** failure of naive backward extension through base-ideal
  blowups; existence of genuine threefold base centers; the exact
  no-cross-stage-extension replacement.
- **Open:** construct the cyclotomic moving-frame packet and prove recursive
  ungraded splitting for codimension-two principalization over arbitrary
  threefold centers.
