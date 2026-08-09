# C894 — TT2 primitive spectral factor and integral golden carrier

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** second-order theorem
extraction; no manuscript or Lean edits

> **Attribution and strength update (2026-08-08).**  The subsequent literature check
> `notes/2026-08-08-c894-cyclotomic-and-golden-literature-check.md` identifies
> the operator below with the standard order-five action on the
> \(A_4\), \(\mathbb Z[\zeta_5]\)-module.  The EJ2 correction
> `notes/2026-08-08-c894-ej2-maximal-golden-order-and-series-impact.md` then
> observes that \(\mathcal J\equiv I\pmod2\), so
> \((I+\mathcal J)/2\) is integral and supplies the **maximal** golden order.
> The “exact conductor-two” interpretation below is superseded; retain
> \(\mathcal J\) only as the intermediate stage of the conductor
> \(4\to2\to1\) ladder.

## Verdict

The decomposition-field theorem has two further free consequences.

First, it determines the entire primitive-character factor of the local
Paley characteristic polynomial, including its exact Frobenius
multiplicities.

Second, at \(q=11\) the local tournament does more than recover the field
\(\mathbb Q(\sqrt5)\). Its signed adjacency operator canonically produces an
**integral conductor-two golden action**:
\[
 \mathcal J=\frac{B^2+5I}{2}
 \quad\text{on}\quad
 L=\{x\in\mathbb Z^5:\textstyle\sum_i x_i=0\},
 \qquad
 \mathcal J^2=5I.
\]
Thus \(L\) is intrinsically a module for \(\mathbb Z[\sqrt5]\). The division
by two is integral on \(L\), not merely rational.  This statement remains
correct, but it is not maximal: EJ2 proves that \((I+\mathcal J)/2\) is also
integral and extends the action to
\(\mathbb Z[(1+\sqrt5)/2]\).

Neither statement should become a third paper headline. The primitive factor
belongs with the collision theorem; the \(q=11\) operator is a compact endpoint
corollary and explanatory series bridge.

## 1. Primitive spectral factor

Continue with
\[
 q=p^n\equiv3\pmod4,\qquad m=(q-1)/2,\qquad
 K=\mathbb Q(\zeta_m),
\]
and let \(\beta\) be one faithful local-Paley eigenvalue. Let
\[
 P_\beta(X)=\operatorname{minpoly}_{\mathbb Q}(\beta),\qquad
 P_{\beta^2}(X)=\operatorname{minpoly}_{\mathbb Q}(\beta^2).
\]
The cyclotomic stabilizer theorem gives
\[
 \deg P_\beta=\frac{\varphi(m)}n,\qquad
 \deg P_{\beta^2}=\frac{\varphi(m)}{2n}.                           \tag{1}
\]

**Corollary 1 (primitive spectral multiplicity).**
\[
 \prod_{\rho\ \mathrm{faithful}}(X-\beta_\rho)
 =P_\beta(X)^n,                                                   \tag{2}
\]
and
\[
 \prod_{\rho\ \mathrm{faithful}}(X-\beta_\rho^2)
 =P_{\beta^2}(X)^{2n}.                                           \tag{3}
\]

**Proof.** The faithful characters form the
\((\mathbb Z/m\mathbb Z)^*\)-orbit of one faithful character. The stabilizer
of \(\beta\) is \(\langle p\rangle\), of order \(n\), so every distinct
Galois conjugate occurs exactly \(n\) times in the left side of (2). The
stabilizer of \(\beta^2\) is \(\langle p,-1\rangle\), of order \(2n\), giving
(3). ∎

Complex conjugation sends \(\beta\) to \(-\beta\), so \(P_\beta\) is even.
The degrees in (1) and the root sets give the sharper identity
\[
 P_\beta(X)=P_{\beta^2}(X^2).                                    \tag{4}
\]
Every conjugate of \(\beta\) is an eigenvalue of a real skew-symmetric matrix
and is therefore purely imaginary. Hence:

**Corollary 2 (CM form).** The decomposition field
\(\mathbb Q(\beta)\) is a CM field, \(\beta\) is a purely imaginary primitive
generator, \(\beta^2\) is totally negative, and
\(\mathbb Q(\beta^2)\) is its maximal real subfield.

This packages the Frobenius collision multiplicity as an ordinary Galois
multiplicity rather than an exceptional graph-spectrum phenomenon.

## 2. The \(q=11\) primitive polynomial

At \(q=11\), \(m=5\) and every nontrivial character of \(S\) is faithful.
The TT calculation
\[
 \beta^2=-5\pm2\sqrt5
\]
gives
\[
 P_{\beta^2}(Y)=Y^2+10Y+5,\qquad
 P_\beta(X)=X^4+10X^2+5.                                        \tag{5}
\]
The trivial character contributes the zero eigenvalue. Therefore the signed
adjacency matrix \(B\) of \(P(11)[S]\) has
\[
 \det(XI-B)=X(X^4+10X^2+5).                                     \tag{6}
\]

No enumeration is hidden here: (6) follows from the field-generation theorem,
the four nontrivial characters of the cyclic group of order five, and the
explicit reduction of one primitive eigenvalue.

## 3. Integral golden operator on the augmentation lattice

Let
\[
 L=\{x\in\mathbb Z^5:\mathbf1^Tx=0\}.
\]
The row sums of \(B\) vanish, so \(L\) is \(B\)-stable. Equation (6) restricts
on \(L\) to
\[
 B^4+10B^2+5I=0.                                                 \tag{7}
\]
Define over \(L\otimes\mathbb Q\)
\[
 \mathcal J=\frac{B^2+5I}{2}.                                   \tag{8}
\]
Equation (7) immediately gives
\[
 \mathcal J^2
 =\frac{B^4+10B^2+25I}{4}
 =5I.                                                            \tag{9}
\]

The non-obvious point is integrality. Modulo two, every off-diagonal entry of
\(B\) is one and every diagonal entry is zero. If
\(E=\mathbf1\mathbf1^T\), then
\[
 B\equiv E-I\pmod2.
\]
Since \(E^2=5E\equiv E\pmod2\),
\[
 B^2+5I\equiv(E-I)^2+I\equiv E\pmod2.                            \tag{10}
\]
For \(x\in L\), \(Ex=(\mathbf1^Tx)\mathbf1=0\). Thus
\((B^2+5I)x\) is coordinatewise even, and (8) defines an endomorphism
\[
 \mathcal J\in\operatorname{End}_{\mathbb Z}(L).                 \tag{11}
\]

Equations (9)--(11) prove:

**Endpoint calculation (intrinsic conductor-two golden carrier).** The integral
augmentation lattice of \(P(11)[N^+(0)]\) carries a canonical action of
\[
 \mathbb Z[T]/(T^2-5)\cong\mathbb Z[\sqrt5]
\]
through \(T\mapsto\mathcal J\). Its characteristic polynomial on \(L\) is
\[
 (X^2-5)^2.
\]
The construction is invariant under relabelling and under reversing every
tournament edge, because it depends only on \(B^2\).

The order \(\mathbb Z[\sqrt5]\) has conductor two in
\(\mathcal O_{\mathbb Q(\sqrt5)}\). It is visible as an intermediate order in
the integral local-Paley carrier; it is not the full endomorphism order exposed
by the cyclic augmentation structure.

## 4. Why the factor \(1/2\) matters

The raw eigenvalue square \(\theta=\beta^2=-5\pm2\sqrt5\) generates
\[
 \mathbb Z[\theta]=\mathbb Z[2\sqrt5],
\]
whose polynomial \(Y^2+10Y+5\) has discriminant \(80\). It is the
conductor-four order in the field of discriminant \(5\).

Centering and halving gives
\[
 \frac{\theta+5}{2}=\pm\sqrt5,
\]
which generates the conductor-two order. Equation (10) explains why that
halving is nevertheless integral on the augmentation lattice. The parity of
the complete signed tournament, not an arbitrary normalization choice,
performs the conductor improvement.

This is the structural surprise of TT2: spectral centering plus the
augmentation parity upgrades conductor four to conductor two.

## 5. Relation to the Clebsch series

The result licenses one precise connection:

> After fixing a matching edge of the \(q=11\) Clebsch hexagon, the induced
> local Paley tournament has an intrinsic augmentation-lattice endomorphism
> squaring to five, and hence carries the conductor-two golden order.

This explains why the same integral quadratic order can appear in the local
matching carrier and in the golden orientation/operator papers.

It does **not** prove that the rank-four lattice \(L\) is canonically the
rank-six conference lattice or any of its golden eigenspaces. Their module
ranks and geometric markings differ. Claim only the common intrinsic order,
unless a later separately allocated comparison constructs an actual functorial
map.

At the level of exposition:

- put the CM/decomposition-field corollary after the primitive collision
  theorem;
- put the integral golden carrier as a short \(q=11\) endpoint proposition or
  remark;
- cite the existing Clebsch paper only for the occurrence and role of the
  conductor-two golden order;
- make no independent novelty claim for the five-cycle calculation.

## 6. TT2 compression

The local theorem now has three mutually reinforcing readings:

1. **group:** restriction of the full Paley stabilizer is an isomorphism;
2. **spectral:** one primitive factor has exactly Frobenius multiplicity \(n\);
3. **arithmetic:** one eigenvalue generates the decomposition CM field and its
   square generates the real subfield.

At \(q=11\), the arithmetic reading has an integral lift:
\[
 \text{directed local pentagon}
 \longmapsto B
 \longmapsto \frac{B^2+5I}{2}\bigg|_L
 \longmapsto \mathbb Z[\sqrt5].
\]

This diagram is a better series connection than matching the local \(C_5\)
with a Sylow-\(5\) subgroup of \(A_5\): it is canonical, integral, and proved
from the local operator alone.

## 7. Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| What is the primitive characteristic factor? | settled | \(P_\beta(X)^n\), with \(P_\beta(X)=P_{\beta^2}(X^2)\) |
| Why does primitive spectral multiplicity equal \(n\)? | settled | it is the order of the decomposition group \(\langle p\rangle\) |
| Is the decomposition field CM? | settled positive | conjugation sends the primitive generator to its negative |
| Does \(q=11\) yield an integral golden action? | settled positive | \(\mathcal J=(B^2+5I)/2\) preserves the augmentation lattice and squares to five |
| Why is division by two integral? | settled | \(B^2+5I\equiv E\pmod2\), and \(E\) kills the augmentation lattice |
| Which golden order appears before centering? | settled | raw \(\beta^2\) gives conductor four; centered halving gives conductor two |
| Is the local rank-four golden lattice canonically the conference rank-six lattice? | no identification proved | a comparison would require a separately allocated cross-paper theorem |
| Is the integral-pentagon construction itself new? | deliberately not claimed | likely elementary/folklore; use only as an explanatory corollary |
| Does this justify broadening C894 into a golden-operator paper? | settled negative | one endpoint proposition suffices; retain the two-theorem title |
| What attribution search changes? | explicit | add CM/decomposition-field and primitive-characteristic-factor terms to the human packet |

## 8. Next action

Add Corollaries 1--2 and the intrinsic conductor-two endpoint proposition to
the claim--proof--citation matrix. Keep the q11 calculation concise and
ring-fence every stronger comparison with the existing golden operator as
future work.
