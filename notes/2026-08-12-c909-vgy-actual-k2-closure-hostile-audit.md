# C909 hostile audit: VGY Prym pullback and the actual \(K[2]\) torsor

Date: 2026-08-12  
Scope: VGY degree-five quotient, Roulleau \(D_5\)-axis, and the marked
two-primary graph; no manuscript/PDF/mirror/Lean edit.

## Verdict

**GO on the common marked smooth base, with a MINOR level/marking
qualification.** The degree-five quotient really gives an odd Prym
isogeny onto the actual \(D_5\)-norm axis. Consequently it identifies the
elliptic two-torsion local systems. After the already computed
quadratic-twist comparison with the Tate model, the unordered exotic
two-primary graph packet has the same sign torsor \(r^2=T\). A chosen
exotic graph is identified only after the corresponding degree-two marking
(on the signed cubic line this is \(r=\pm9t\)); the unmarked statement must
refer to the unordered packet/torsor.

## Source and exact map

Use van Geemen--Yamauchi, arXiv:1506.05346v3 (cached SHA-256
\`f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed\`),
Propositions 2.1, 3.1, and 3.2. Their degree-five diagram is

\[
\begin{array}{ccc}
 \widetilde H&\xrightarrow{\pi,\;5:1}&
 \overline{\widetilde H}=\widetilde H/\widetilde\alpha _5\\
 \downarrow&&\downarrow\\
 H&\xrightarrow{\bar\pi,\;5:1}&\overline H=H/\alpha _5.
\end{array}
\]

The vertical maps are étale double covers and the right-hand Prym is the
explicit elliptic \(E''\) of their equation (3.2). Let
\[
 P=\operatorname{Prym}(\widetilde H/H)=J(X),\qquad
 P_0=\operatorname{Prym}(\overline{\widetilde H}/\overline H)=E''.
\]
Since \(\pi\) commutes with the involutions, Jacobian pullback and norm
restrict to
\[
 \phi=\pi^*:P_0\longrightarrow P,\qquad
 \nu=\operatorname{Nm}_\pi:P\longrightarrow P_0,\qquad
 \nu\phi=[5].
\]
Thus \(\ker\phi\subset P_0[5]\). The map is nonzero (otherwise
\(\nu\phi=[5]\) would vanish), so its image is an elliptic subvariety.

## Image and polarization checks

Because \(\widetilde\alpha _5\pi^*=\pi^*\), the image is contained in the
connected \(C_5\)-fixed component
\[
 E_{C_5}=\ker(\widetilde\alpha _5^*-1)^0\subset P.
\]
VGY Proposition 1.5 identifies this component as the one-dimensional
elliptic factor. In the \(D_5\) representation on \(H^0(\Omega_S)\), the
two nontrivial \(2\)-dimensional summands have no \(C_5\)-fixed vectors and
the remaining line is \(D_5\)-trivial. Hence the \(C_5\)-fixed and
\(D_5\)-fixed rational lines coincide. Connected abelian subvarieties
with the same rational \(H_1\)-line coincide, so
\[
 \operatorname{Im}(\phi)=E_{C_5}=E_{D_5}=E_{\rm axis}.
\]
This is image equality, not an assertion that VGY printed a particular
integral normalization.

For the optional degree refinement, if \(\Xi_P,\Xi_{P_0}\) are the
principal Prym polarizations, functoriality of the Jacobian polarizations
and \(i^*\Theta_J=2\Xi\) for an étale double cover give
\[
 \phi^*\Xi_P=5\Xi_{P_0}.
\]
Writing \(d=\deg(\Xi_P|_{E_{\rm axis}})\) and
\(n=\deg(E''\xrightarrow{\phi}E_{\rm axis})\) gives \(nd=5\). Thus
\(n=1\) or \(5\), in particular odd. If the independently proved
Roulleau/norm computation \(d=5\) is invoked, then \(n=1\); this stronger
degree-one claim is not in VGY and is unnecessary for mod-two comparison.

More precisely, the \(d=5\) calculation does force an actual elliptic
scheme isomorphism, not merely an odd isogeny. Factor
\(\phi=i\circ\bar\phi\), where \(i:E_{\rm axis}\hookrightarrow J\) is the
primitive norm-axis inclusion. With the canonical principal polarization
\(\Xi_{\rm axis}\) on that elliptic scheme, the norm calculation is the
line-bundle identity
\[
 i^*\Theta_J=5\Xi_{\rm axis}.
\]
(The \(\Theta_J\) here is the principal polarization of the intermediate
Jacobian/Prym \(P\), not the ambient genus-eleven Jacobian theta.) The Prym
pullback identity is \(\phi^*\Theta_J=5\Xi_{E''}\), so
\[
 5\,\bar\phi^*\Xi_{\rm axis}=5\Xi_{E''}.
\]
As polarization homomorphisms, elliptic endomorphism groups are torsion-free,
so cancellation of \(5\) gives
\(\bar\phi^*\Xi_{\rm axis}=\Xi_{E''}\). Pullback of a principal elliptic
polarization by an isogeny has degree equal to the isogeny degree; hence
\(\deg\bar\phi=1\), and \(\bar\phi\) is an origin-preserving isomorphism.
This conclusion is valid only after the primitive axis identity
\(i^*\Theta_J=5\Xi_{\rm axis}\) has been established; it is not a
consequence of VGY Proposition 3.2 alone. If one uses ambient Jacobian
thetas instead, both sides carry the usual étale-Prym factor \(2\), which
cancels and gives the same result.

## Consequence for \(E[2]\) and the graph packet

Since \(\ker\phi\) is killed by \(5\), restriction gives an isomorphism of
finite étale local systems
\[
                 \phi[2]:E''[2]\xrightarrow{\sim}E_{\rm axis}[2].
\]
It is symplectic for the principal elliptic polarizations modulo \(2\): the
pullback multiplier is the odd integer \(n\) (equal to \(1\) or \(5\)).
The \(A_5\)-stable graph packet is functorial in this symplectic coefficient
local system. In particular
\[
 \mathbf P^1(\mathbf F_4)
 =\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\}
\]
is transported to the actual axis packet, and the action on the exotic pair
is the sign quotient of the \(S_3\) monodromy of \(E[2]\). Therefore this
argument concerns the actual ppav kernel \(K_2=K\cap E^5[2]\), not merely an
abstract elliptic isogeny, once the six-axis graph map has been constructed.

On the \(A_5\) line, the specialized VGY equation (3.2) is a quadratic
twist of the Tate elliptic model by
\[
                    D(T)=(T+27)(T-729/5).
\]
Quadratic twisting by \([-1]\) leaves the \(2\)-torsion local system
unchanged. The Tate \(2\)-division sign character over the normalized
\(X_0(3)\) coordinate is the quadratic extension
\[
                         r^2=T.
\]
Hence \(r^2=T\) is the sign torsor of the **actual** unordered exotic
kernel packet. Pulling to the signed cubic parameter \(T=81t^2\) gives
\(r=\pm9t\); choosing a member requires choosing that sheet.

## Pitfalls that must be stated

1. VGY Proposition 3.2 itself says only “isogenous.” The odd-kernel lemma
   is the derived pullback/norm calculation above, not a quotation from VGY.
2. Do not say that the quotient degree makes the Prym isogeny degree \(5\).
   The pullback multiplier is \(5\), while the map degree is \(1\) or \(5\)
   (and degree \(1\) uses the separate \(d=5\) axis calculation).
3. The construction is over the common smooth base carrying the \(D_5/C_5\)
   quotient marking. Descent to an unmarked base retains the unordered
   exotic pair/sign torsor; a selected graph needs the degree-two level cover.
4. Equality of \(j\)-maps or rational periods alone would not identify
   \(K[2]\). Here the actual map \(\pi^*\) supplies the odd two-torsion
   isomorphism, and the twist comparison supplies the Tate identification.

Thus the proposed closure is sound in marked-family form. The honest global
sentence is: *the actual \(K[2]\) exotic packet has sign torsor \(r^2=T\),
and the signed cubic cover selects one of its two sheets.*
