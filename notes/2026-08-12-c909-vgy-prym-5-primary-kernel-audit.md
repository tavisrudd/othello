# C909 focused audit: the VGY elliptic Prym map has 5-primary kernel

Date: 2026-08-12

No manuscript/PDF/mirror/Lean edit. Source checked from the cached full PDF:
Bert van Geemen--Takuya Yamauchi, arXiv:1506.05346v3,
SHA-256
\`f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed\`.

## Exact source locations

* Proposition 1.5, printed p. 4: \(J(X)\sim E\times B^2\), where the
  elliptic factor is the connected component
  \(\ker(\alpha_X^*-[1])^0\).
* Proposition 2.1, printed pp. 8--9: the genus-six discriminant curve
  \(H_{a,b}\), its genus-eleven étale double cover
  \(\mathcal H_{a,b}\), and
  \[
    J(X_{a,b})\cong
    \operatorname{Prym}(\mathcal H_{a,b}/H_{a,b})
  \]
  as principally polarized abelian varieties.
* Section 3.2 and Proposition 3.1, printed pp. 10--11: the degree-five
  quotient diagram
  \[
  \begin{array}{ccc}
  \mathcal H_{a,b}&\xrightarrow{\pi\, (5:1)}&
  \overline{\mathcal H}_{a,b}:=\mathcal H_{a,b}/\widetilde\alpha _5\\
  \downarrow 2&&\downarrow 2\\
  H_{a,b}&\xrightarrow{\bar\pi\, (5:1)}&
  \overline H_{a,b}:=H_{a,b}/\alpha _5,
  \end{array}
  \]
  with genus \(3\) and \(2\) quotient curves. The right vertical double
  cover is étale and its Prym is the explicit elliptic curve
  \(E''_{a,b}\), represented by equation (3.2).
* Proposition 3.2, printed p. 11: \(E''_{a,b}\) is isogenous to the
  elliptic factor \(E_{a,b}\), but the proposition does **not** print the
  degree or a two-torsion map.

## Pullback respects Pryms

Section 2.6 explicitly says that the order-five automorphisms
\(\widetilde\alpha _5,\alpha _5\) commute with the covering involutions
\(\iota_l,\iota\). Therefore \(\pi\) is a map of the two étale double-cover
diagrams. Write
\[
 P=\operatorname{Prym}(\mathcal H/H),\qquad
 P_0=\operatorname{Prym}(\overline{\mathcal H}/\overline H)=E''.
\]
Pullback and norm on Jacobians restrict to
\[
 \phi:=\pi^*:P_0\longrightarrow P,\qquad
 \psi:=\operatorname{Nm}_\pi:P\longrightarrow P_0.
\]
The restriction follows from anti-invariance:
\[
 \iota_l^*\pi^*=\pi^*\iota^*,\qquad
 \iota^*\operatorname{Nm}_\pi=\operatorname{Nm}_\pi\iota_l^*.
\]
The standard Jacobian identity for a degree-five finite map gives
\[
 \psi\phi
 =(\operatorname{Nm}_\pi\circ\pi^*)|_{P_0}
 =[5]_{P_0}.
\]
Thus \(\ker(\phi)\subset P_0[5]\). In particular the kernel is 5-primary,
and \(\deg(\phi)\) is a power of \(5\) (for elliptic \(P_0\), at most
\(5^2\)). This is the decisive parity conclusion; it does not require
knowing the exact subgroup of \(P_0[5]\).

## Image equals the C5-fixed elliptic factor

Because \(\pi\) is the quotient by \(\widetilde\alpha _5\),
\[
 \widetilde\alpha _5^*\pi^*=\pi^*.
\]
Hence \(\operatorname{Im}(\phi)\) lies in
\[
 P^{\widetilde\alpha _5}
 :=\ker(\widetilde\alpha _5^*-[1])^0.
\]
The identity \(\psi\phi=[5]\) shows that \(\phi\) is nonzero and has
one-dimensional image, since \(P_0\) is elliptic. Proposition 1.5 says that
the connected fixed component above is exactly the elliptic factor
\(E_{a,b}\). Therefore
\[
 \operatorname{Im}(\phi)=E_{a,b}.
\]
This also supplies the missing justification behind the “isogenous” claim:
the particular isogeny is the Prym pullback \(\phi:E''_{a,b}\to E_{a,b}\),
with 5-primary kernel.

## Identification with the D5 norm axis

Roulleau's cached arXiv:1002.4467v1, Theorem 11(D), gives for a \(D_5\)-type
Fano surface a connected elliptic fibration whose fibre is the sum of the
five genus-two curves indexed by the involutions in \(D_5\). Its Albanese
quotient is the dual of the corresponding \(D_5\)-fixed elliptic subvariety.

The representation printed near the end of Roulleau's paper is
\[
 H^0(\Omega_S)\simeq V_5^1\oplus V_5^2\oplus T,
\]
where \(T\) is the trivial one-dimensional \(D_5\)-representation. Thus
the \(C_5\)-fixed line is precisely the \(D_5\)-fixed line: the two
two-dimensional \(V_5^i\) have no \(C_5\)-invariants, and the reflection acts
trivially on \(T\). Consequently the elliptic factor \(E_{a,b}\) above is
the rational \(D_5\)-norm axis; the Roulleau Albanese quotient and the VGY
C5-fixed factor have the same connected elliptic image. Any stronger
integral “same primitive inclusion” statement should still be phrased as a
comparison of the two induced homomorphisms, but the representation-theoretic
image equality is clear.

## Optional exact degree refinement

The 5-primary argument is source-safe and sufficient for two-torsion. A
degree \(1\) versus \(5\) refinement follows by polarization, but requires
keeping track of the Prym normalization. For an étale double cover, the
Jacobian polarization restricts to twice the principal Prym polarization.
For the degree-five \(\pi\), the full Jacobian identity gives
\[
 (\pi^*)^*\lambda_{\mathcal H}=5\lambda_{\overline{\mathcal H}},
\]
hence on Pryms
\[
 \phi^*\Xi_P=5\Xi_{P_0}.
\]
If \(d=\deg(\Xi_P|_{E_{a,b}})\) and \(n=\deg(\phi)\), then
\[
 nd=5.
\]
Thus \(n\in\{1,5\}\) and \(d\in\{5,1\}\). The independent six-axis Rosati
calculation gives \(d=5\) for the Roulleau axis, which would force \(n=1\).
That last degree-one conclusion depends on matching the VGY factor with the
primitive Roulleau axis polarization and is not printed by VGY. The
5-primary conclusion does not depend on this refinement.

## Two-torsion consequence

Any odd-degree isogeny induces an isomorphism on finite étale 2-torsion:
\[
 E''_{a,b}[2]\xrightarrow{\sim}E_{a,b}[2].
\]
The explicit \(A_5\)-specialization of VGY's equation (3.2) is a quadratic
twist of the Tate model, with twist class
\[
 D(T)=(T+27)(T-729/5).
\]
The twist is by \([-1]\), which is trivial on 2-torsion. Hence the VGY
Prym, the C5/D5 norm axis, and the Tate elliptic scheme have the same
2-torsion local system. The discriminant sign cover is therefore
\[
 r^2=T.
\]

## Safe wording

> VGY's degree-five quotient diagram induces a Prym pullback
> \(E''_{a,b}\to E_{a,b}\). Because norm after pullback is multiplication by
> \(5\), its kernel is killed by \(5\), hence the isogeny has odd degree.
> The image is the connected \(C_5\)-fixed elliptic factor, which is the
> \(D_5\)-norm axis under the printed \(D_5\)-representation. VGY state only
> “isogenous”; degree \(1\) requires the separate primitive polarization
> comparison.

