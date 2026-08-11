# C904: the Winger carrier does not bypass the two-primary gate

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean promotion
Scope: the twenty-dimensional cubic--Winger carrier, its one-factor
projections, and the proposed odd scalar on the cubic intermediate Jacobian

## Executive verdict

The Winger Jacobian does **not** presently produce an odd scalar on the cubic
intermediate Jacobian. The exact reason is two-primary and matches the
previous \(K_2\) descent gate on the nose.

The current dossier does not contain an integral polarized isogeny
\[
                  J(X)^4\longleftrightarrow A_V(C)^5.
\]
It contains a rational-Chow twenty-dimensional carrier and a power isogeny
up to isogeny after the two quadratic markings. Integral saturation and its
polarization kernel were explicitly left open.

For the thirty \(A_5/C_2\)-orbit generators, the integral
double-augmentation **label lattice** has Smith type
\[
                  (1^4,6,30^{15}).
\]
Its projection to **each one of the four cubic \(J\)-factors** has Smith type
\[
                       (1,6,6,6,6).
\]
Thus every one-factor projection misses four independent halves; over all
four factors the exact defect is \((\mathbf Z/2)^{16}\). This is precisely
four copies of the exotic cubic gluing kernel \(K_2\cong(\mathbf Z/2)^4\).
The corresponding projection to one Winger factor has Smith type
\[
                          (1,5,5,5),
\]
so it has no two-primary defect. The missing halves are entirely on the
cubic side.

Consequently every integral realization of the thirty named cycles that
retains their quotient--axis factorization gives self-correspondences on
\(J^4\) killing \(K_2^4\). If one is a scalar \([m]\), then \(m\) is even.
The canonical Abel curve of the Winger Jacobian does not alter this
factorization: norm, pullback, transpose, and the principal Jacobian
polarization are integral, but none supplies the missing halves on the cubic
axis lattice.

An odd \([3^k]\) would become possible only after adjoining those sixteen
half-combinations. That is exactly primitive descent through \(K_2^4\), not
a new bypass. The earlier equivalence with the universal-cycle gate
therefore survives the Winger carrier.

## 1. The coefficient lattices and their projections

Let
\[
 a_i=6e_i-\mathbf 1_6\quad(1\le i\le6),\qquad
 b_j=5e_j-\mathbf 1_5\quad(1\le j\le5).
\]
The thirty double-augmentation generators are
\[
                           M_{ij}=a_i b_j^{\mathsf T}.
\]
After deleting the last row and column, the ambient lattice is the full
rank-twenty lattice of \(5\times4\) integral matrices. The tracked exact
certificate proves
\[
 \operatorname{SNF}\langle M_{ij}\rangle
                  =(1^4,6,30^{15}).
\]
In particular its two-primary reduction is
\[
                         (1^4,2^{16}).
\]

Fix a column \(c\), corresponding to one of the four \(J\)-factors in the
tensor-power realization. The integers \(b_{j,c}\) include \(-1\), so the
column projection of the orbit lattice is exactly the span of the \(a_i\).
In the first five coordinates, the first five \(a_i\) form
\[
                            6I_5-J_5.
\]
The sixth is their negative sum. Hence
\[
 \operatorname{SNF}\operatorname{pr}_c\langle M_{ij}\rangle
                         =(1,6,6,6,6).
\]
This is a human Smith calculation: \(6I_5-J_5\) has eigenvalue one on the
all-ones line and eigenvalue six on its rank-four complement, and a unit
minor gives the first invariant factor.

Fixing instead one of the five independent cubic rows, corresponding to one
Winger factor, the coefficients \(a_{i,r}\) include \(-1\), and the projected
lattice is the span of the \(b_j\). Its Smith type is
\[
                              (1,5,5,5).
\]

Thus:
\[
\begin{array}{c|c|c}
\text{projection} & \text{Smith type} & \text{two-primary cokernel}\\
\hline
\text{one cubic }J & (1,6^4) & (\mathbf Z/2)^4\\
\text{one Winger }A_V & (1,5^3) & 0\\
\text{full carrier} & (1^4,6,30^{15}) & (\mathbf Z/2)^{16}.
\end{array}
\]

This is exactly the distribution required by four cubic factors and five
Winger factors.

## 2. Identification with the exotic cubic kernel

Let
\[
                         f_X:E^5\longrightarrow J(X)
\]
be the isogeny defined by five of the six \(D_5\) elliptic axes. Its pulled
polarization has matrix
\[
 G_X=6I_5-J_5,\qquad \operatorname{SNF}(G_X)=(1,6,6,6,6).
\]
The isogeny kernel has primary pieces
\[
 K_2\cong(\mathbf Z/2)^4,\qquad
 K_3\cong(\mathbf Z/3)^4.
\]
Equivalently, on rank-ten integral homology the isogeny and its polarized
dual have Smith type
\[
                              (1^6,6^4).
\]

On the Winger side, the five \(A_4\) quotient axes have coefficient
polarization
\[
 G_W=3(5I_4-J_4),\qquad
 \operatorname{SNF}(G_W)=(3,15,15,15).
\]
Its discriminant is odd at two. Therefore the Winger quotient, norm, Abel,
and principal-Jacobian correspondences introduce no two-primary
overlattice capable of cancelling \(K_2\).

For four cubic factors, the exact forced two-primary homology profile is
\[
                            (1^{24},2^{16}).
\]
This agrees with the two-primary part of the coefficient-carrier Smith
form. The agreement is structural: the sixteen missing coefficient halves
are \(K_2^4\), not an artifact of the chosen orbit basis.

## 3. Factorization of every named cycle

Let
\[
 u_j:E_{W,j}\longrightarrow A_V(C)\subset J(C)
\]
be the five Winger quotient axes, let
\[
 v_i:E_{X,i}\longrightarrow J(X)
\]
be the six cubic axes, and let
\(\psi:E_{W,j}\to E_{X,i}\) be the marked elliptic isogeny. The named
correspondence has realization
\[
                         z_{ij}=v_i\psi u_j^\dagger.
\]
Its transpose is
\[
                         z_{ij}^\dagger
                         =u_j\psi^\dagger v_i^\dagger.
\]
All the maps \(v_i^\dagger\) are coordinate components of the polarized
dual
\[
                          f_X^\dagger:J(X)\to E^5.
\]
Therefore every integral linear combination of the \(z_{ij}^\dagger\)
factors through \(f_X^\dagger\). For four copies,
\[
                 (K_2^\vee)^4\subset\ker(\text{combined transpose}).
\]

Let \(F:A_V(C)^5\to J(X)^4\) be any integral map assembled from the thirty
named correspondences, and use the same integral cycles for \(F^\dagger\).
Then
\[
                         K_2^4\subset\ker(FF^\dagger).
\]
If \(FF^\dagger=[m]\) on \(J(X)^4\), multiplication by \(m\) kills
\(K_2^4\), so \(m\) is even. In particular \(m\ne3^k\).

This conclusion is independent of the odd part of \(\deg\psi\) and of the
choice of bases in the four- and five-fold products.

## 4. Exact frame scalars

The axis Gram matrices give
\[
\begin{aligned}
 u_j^\dagger u_j&=[12],
 &\sum_{j=1}^5u_ju_j^\dagger&=[15]_{A_V},\\
 v_i^\dagger v_i&=[5],
 &\sum_{i=1}^6v_iv_i^\dagger&=[6]_J.
\end{aligned}
\]
Put \(\psi\psi^\dagger=\psi^\dagger\psi=[d]\). Then direct composition gives
\[
 \boxed{\sum_{i,j}z_{ij}z_{ij}^\dagger=[360d]_J},
\qquad
 \boxed{\sum_{i,j}z_{ij}^\dagger z_{ij}=[450d]_{A_V}}.
\]
The traces agree:
\[
                        5\cdot360d=4\cdot450d.
\]

For the modular bridge \(d\) is an odd three-power after the chosen
normalization. The cubic scalar remains
\[
                  360d=2^3\cdot5\cdot3^{2+\nu_3(d)}.
\]
To obtain the attractive odd scalar
\([9d]\) from this tight frame, one would have to divide the factorization
by \(40\). Its factor \(8\) is exactly forbidden by the \(K_2\) calculation.
Equality of endomorphisms after rational division does not supply an
integral codimension-two cycle realizing that divided factorization.

These are frame scalars, not the multiplier of a presently constructed
twenty-dimensional polarized isogeny. No such integral isogeny has yet been
frozen, so a global multiplier and full homology Smith form are not defined.
What is defined independently of every odd normalization is the forced
two-primary Smith profile \((1^{24},2^{16})\). Any future polarized
similitude built from this carrier must therefore have even multiplier.

## 5. What “projection to one \(J\)” means

There are two different assertions:

1. If an integral map \(F:A_V^5\to J^4\) has already been constructed, then
   ordinary coordinate projection \(\operatorname{pr}_cF\) is of course
   integral.
2. The projection of the **rational power correspondence** to one cubic
   factor, normalized so that its transpose-composition is odd, is not
   integral. Its coefficient image has Smith type \((1,6^4)\), so four
   halves must be adjoined.

Only the second assertion is relevant to the proposed Bezout argument.
Calling the rational power isogeny “integral” before these halves are
constructed assumes the entire two-primary gate.

The canonical Abel curve in \(J(C)\) does not repair this. It makes the
Jacobian polarization and the maps \(u_j,u_j^\dagger\) integral, but the
one-\(J\) projection still lands in the index-\(6^4\) cubic axis lattice.
The missing \(2^4\) is downstream of the Winger Jacobian and survives every
canonical curve operation.

Nor can the complementary \(E_6=3\oplus3'\) constituent of the full Winger
Jacobian hide the halves. Looijenga--Zi prove that
\(V_0\otimes\operatorname{Hom}_{\mathbf Z A_5}(V_0,H_1(C,\mathbf Z))\)
has torsion-free cokernel in \(H_1(C,\mathbf Z)\), and the Winger coefficient
polarization has odd determinant at two. Hence the \(V_4\) part is a
self-dual direct summand over \(\mathbf Z_2\). Its complementary constituent
cannot enlarge the \(V_4\) lattice by a half-vector. The unexplained \(E_6\)
coefficient summand in \(W_5\otimes V_4\) is therefore not a two-primary
saturation mechanism.

## 6. Strongest honest theorem

> **Winger no-bypass theorem.** The integral double-augmentation label
> lattice of the thirty cubic--Winger orbit correspondences has exact
> one-cubic-factor Smith type
> \((1,6^4)\) and full two-primary defect
> \((\mathbf Z/2)^{16}\). Every quotient--axis realization of a transpose
> factors through the cubic axis dual and hence kills \(K_2^4\).
> Consequently any scalar self-map of \(J(X)^4\) obtained integrally by this
> construction is even. Producing an odd
> \([3^k]\) requires adjoining exactly four half-combinations per cubic
> factor, equivalently primitive descent through \(K_2^4\).

Thus the Winger carrier does not change the previous equivalence. It gives a
beautiful rational and three-primary bridge, but its odd-scalar upgrade is
the same universal-cycle obstruction in a larger coefficient package.

The only genuine positive route left here is to prove that the rational
thirty-cycle carrier has an integral saturation strictly larger than its
orbit-generated lattice by the exact subgroup
\((\mathbf Z/2)^{16}\). Such a theorem would be new information, not a
formal consequence of the Winger Jacobian.

## 7. Evidence and source boundary

No new broad computation is used. The full carrier Smith form and the
subgroup-pair orbit are certified by the tracked bundle

- 2026-08-10-c904-cubic-winger-correspondence-certificate.py;
- 2026-08-10-c904-cubic-winger-correspondence-certificate.out;
- 2026-08-10-c904-cubic-winger-correspondence-replay.g; and
- 2026-08-10-c904-cubic-winger-correspondence-replay.out.

The one-factor Smith forms follow directly from the displayed simplex
matrices \(6I-J\) and \(5I-J\). The kernel identification uses the tracked
exotic-gluing certificate in
2026-08-10-c904-kernel-v4.py and its independent replay. The frame scalars
are the two-line Gram calculation in Section 4.

Primary sources retained from the parent C904 audit:

- Looijenga--Zi, *Monodromy and period map of the Winger pencil*,
  arXiv:2109.01810, full text, especially Section 2.2, Proposition 3.5,
  Remark 3.6, and Corollary 3.9; cache SHA-256
  d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1.
- Roulleau, *Genus 2 curve configurations on Fano surfaces*,
  arXiv:1002.4467, full text, for the six \(D_5\) elliptic axes and their
  \(6I-J\) polarization; cache SHA-256
  c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd.
- van Geemen--Yamauchi, *On intermediate Jacobians of cubic threefolds
  admitting an automorphism of order five*, arXiv:1506.05346v3, full text,
  for the algebraic Fano/Prym bridge; cache SHA-256
  f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed.

No novelty sentence is licensed by this note. No manuscript, Lean source,
handoff, or task card was changed.

## 8. EJ + Tao closeout and mystery ledger

The closeout settled:

1. the “integral twenty-dimensional isogeny” premise is stronger than the
   current dossier;
2. one cubic projection has exact Smith defect \((1,6^4)\);
3. the four-factor two-primary defect is exactly \(K_2^4\);
4. the full orbit frame gives \([360d]\), not an odd scalar; and
5. the full Winger Jacobian and its \(E_6\) complement cannot supply hidden
   half-vectors.

Mysteries still open:

| mystery | exact evidence gap |
|---|---|
| Does the rational thirty-cycle carrier saturate by \((\mathbf Z/2)^{16}\) in integral Chow? | construct sixteen integral half-combinations; this is the \(K_2^4\) descent gate |
| What is the full integral power-isogeny Smith form? | first construct the integral map, then fix the odd \(3\)- and \(5\)-primary normalizations |
| Can a non-axis geometric correspondence evade the factorization? | it must add a new integral \(V_4\to W_5\) lattice direction, not merely repackage the quotient projectors |
| Does edge-cycle divisibility at three help? | it controls the common \(3\)-heart but supplies no two-primary saturation |

The highest-EV positive move is therefore not another composition. It is a
direct construction or obstruction for those sixteen half-combinations.
