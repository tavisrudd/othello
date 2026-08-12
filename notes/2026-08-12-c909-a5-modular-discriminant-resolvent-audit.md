# C909 — the `A_5` discriminant-resolvent gluing curve, and the period-curve no-go

Date: 2026-08-12

Status: theorem-grade modular **gluing** construction and hostile no-go for a
stronger identification of the `A_5` cubic intermediate-Jacobian period curve.
This is strictly C909: finite-etale graph data, its marked Hecke locus, and
its cohomological divided-power consequence.  No manuscript, PDF, mirror,
Lean, or commit change.

## Verdict

There is an explicit modular curve inside the marked finite-etale
elliptic-Hecke stack, but the existing C904 record does not identify it with
the full `A_5` cubic period curve.

More precisely, the two-primary exotic choices define the discriminant
resolvent of the universal `X_0(3)` two-torsion local system.  On the usual
coarse coordinate it is

\[
 \mathscr R_{\rm ex}:\quad r^2=T
 \longrightarrow X_0(3)\simeq\mathbf P^1_T.
\tag{1}
\]

Over the smooth modular open it is a connected finite-etale double cover;
its compactification is `P^1_r -> P^1_T`, `T=r^2`, ramified only at the two
cusps `0,infinity`.  The `A_5` discriminant heart canonically has the same
two-point **sign local system**, up to its unavoidable deck involution.
Consequently (1) parametrizes an explicit one-dimensional family of marked
finite-etale self-dual gluing quotients of `(E^5,6I_5-J_5)`.  It maps to
`H_5^et`, so C909 gives ordinary-product saturation of all polarization
divided powers on every fibre.

This is already a clean object-level strengthening of the marked Hecke
separation locus.  It must not be recast as the theorem that the marked
`A_5` cubic period curve *is* `R_ex`, or that the full five-packet is a
global modular/quartic period packet.  Those identifications require the
missing integral period and boundary comparison.

## 1. The exact finite discriminant packet

Let

\[
 H=\operatorname{Aug}(\mathbf F_2^6)/\langle\mathbf 1\rangle,
 \qquad D=\operatorname{End}_{\mathbf F_2 A_5}(H)=\mathbf F_4.
\tag{2}
\]

For the hyperbolic two-primary coefficient module `H\oplus H`, the
`A_5`-stable principal halves are exactly

\[
 \mathscr P=\mathbf P^1(D)=\mathbf P^1(\mathbf F_4).
\tag{3}
\]

Restriction to the full simplex symmetry gives the canonical decomposition

\[
 \mathscr P=
 \underbrace{\mathbf P^1(\mathbf F_2)}_{\mathscr P_{\rm cl},\;3\ \rm points}
 \sqcup
 \underbrace{\bigl(\mathbf P^1(\mathbf F_4)
          \setminus\mathbf P^1(\mathbf F_2)\bigr)}_{\mathscr P_{\rm ex},\;2\ \rm points}.
\tag{4}
\]

The elliptic mod-two monodromy group

\[
 \operatorname{GL}_2(\mathbf F_2)\simeq S_3
\tag{5}
\]

acts with orbit split `3+2`.  On the exotic pair its action is precisely the
sign quotient `S_3 -> C_2`; equivalently an odd permutation exchanges the
two embeddings

\[
 \mathcal O_3/2\simeq\mathbf F_4
 \longrightarrow D,
 \qquad t\longmapsto\omega\ \text{or}\ \omega^2.
\tag{6}
\]

Equations (2)--(6) are the actual theorem behind the slogan
“`P^1(F_4)` five-packet.”  It is a finite discriminant-module classification,
not a Bruhat--Tits link of the rational `A_5` commutant and not, by itself, a
collection of five global ppav families.

## 2. The two resolvents are exact

Let `U` be the modular open on which the universal `X_0(3)` elliptic
two-torsion local system is etale, and use its C904 Tate coordinate `T`.
The discriminant of the two-division polynomial is

\[
 16T(T+27)^8.
\tag{7}
\]

Its square class is `T`.  The sign torsor of the `S_3` local system is
therefore (1).  Since (4) carries the same `S_3`-set through sign, the exotic
gluing-marking cover is isomorphic to `R_ex` as a `C_2`-torsor after choosing
one identification of its two fibres.  There are exactly two such
identifications, differing by the deck involution.  Thus the **cover** is
intrinsic; a literal choice `Gamma_omega` is not.

The complementary degree-three root resolvent is also explicit:

\[
 T=-\frac{(4y+3)(y+3)^2}{(y+1)^2}.
\tag{8}
\]

It chooses a classical `F_2` slope and is the `X_0(6)` root cover in the C904
normalization.  The fibre product of (1) and (8) is the full `S_3`
two-division splitting cover, with one rational parametrization

\[
 T=\frac{u^2(9-u^2)^2}{(1-u^2)^2},
 \qquad r=\frac{u(9-u^2)}{1-u^2}.
\tag{9}
\]

These are resolvent statements for the elliptic two-torsion system.  The
cusps `T=0,infinity`, of widths `1,3` downstairs, acquire widths `2,6` on
the compactified sign cover.  No claim of etaleness at those compactification
points is intended.

## 3. A finite-type modular substack of the C909 locus

Define `G_ex` over `U` to have objects

\[
 (E,\langle P_3\rangle, f:E^5\to A,
   K_3,K_2),
\tag{10}
\]

where `E` carries the cyclic level-three datum, `f^*Theta_A` has coefficient
matrix `6I_5-J_5`, `K_3` is the monodromy-selected scalar three-primary
graph, and `K_2` is an `A_5`-stable exotic graph in `P_ex`.  The source
kernel is the product of those transverse primary graphs and `A=E^5/K` has
the descended principal polarization.

The preceding local classification gives a finite-etale map

\[
 \mathscr G_{\rm ex}\longrightarrow\mathscr R_{\rm ex}
\tag{11}
\]

which is an isomorphism on the coarse two-primary marking after the
level-three datum has been fixed.  More importantly, the quotient construction
gives a finite-type map

\[
 \mathscr G_{\rm ex}\longrightarrow\mathfrak H_5^{\rm et}.
\tag{12}
\]

At two the literal graph algebra is `F_4`, the etale algebra
`F_2[t]/(t^2+t+1)`; at three it is scalar.  Thus this lies in the finite-etale
regime, including at `p=2`, with no trace-denominator issue.  The C909
graph-saturation theorem consequently gives

\[
 \operatorname{PD}\langle\operatorname{NS}(A)\rangle^k=P_A^k
 \quad(0\leq k\leq5),
 \qquad
 \frac{\Theta_A^k}{k!}\in P_A^k.
\tag{13}
\]

This is the correct strengthened locus theorem: `G_ex` is an explicit,
finite-type modular test curve in the otherwise degree-indexed union
`H_5^et`.  It is independent of any cubic period realization.

## 4. What the C904 cubic geometry establishes

The C904 six-axis record supplies the following fibrewise facts for the
irreducible `A_5` cubic component:

1. the six elliptic axes have coefficient form `6I_5-J_5` and give an
   elliptic-power isogeny to the intermediate Jacobian;
2. the three-primary graph is the monodromy-selected scalar line;
3. strong Torelli and generic automorphism group `A_5` exclude the three
   `S_6`-stable two-primary halves, forcing the exotic unordered pair; and
4. the exotic selector has square class `T`, while the rank-two elliptic
   multiplicity factor has the stated `X_0(3)` coarse `j`-map.

Therefore the cubic family has the correct **fibrewise marked-Hecke type**
and, after a local-system/lattice identification, pulls back the torsor (1).
In the commonly used cubic chart, `T=81t^2`; hence its pullback of (1) is
split by `r=9t`.  This is excellent evidence for the desired marked lift,
but it is not an identification of principally polarized period curves.

The following three gates remain, exactly as the C904 hostile audits state:

* construct the relevant integral `A_5` symplectic local system and the
  actual family of principal graph quotients, rather than only its rational
  multiplicity factor and fibrewise kernels;
* identify the normalization of the ppav period-image closure and compute
  the generic degree of the cubic parameter map; and
* match the boundary compactifications and their markings.

Without these, the theorem-grade sentence is only

\[
 \text{cubic period map lands in the exotic marked-Hecke sheet and is nonconstant},
\tag{14}
\]

not `C_{A_5}^{mark}=R_ex`, not a Hauptmodul identification, and not a modular
description of the full intermediate-Jacobian variation.  Formula
`T=81t^2` supplies a rational map and a splitting of its pulled-back sign
torsor; a rational map between parameter lines does not settle the three
gates above.

## 5. Quartic boundary

The three classical points in (4) and their root resolvent (8) are exact
finite discriminant geometry.  It is safe to call (8) the classical
two-division `X_0(6)` resolvent.  It is not yet safe to promote all five
points, all ten fibrewise Hecke edges, or the `PGL_2(F_4)` symmetry to a
single global quartic--cubic period-packet theorem: that requires compatible
ppav family maps, normalization/generic-degree statements, and boundary
extension.  The C904 common genus-three cover additionally concerns a
separate multiplicity-twist character `D(T)`; it must not be confused with
the discriminant cover (1).

Accordingly the modular substack (10)--(13), rather than a claimed global
quartic pentad, is the clean C909 object to use in the marked-Hecke
separation theorem.

## EJ + TT closeout / mystery ledger

**EJ settled:** the exotic `C_2` marking has an exact modular avatar: the
discriminant resolvent `r^2=T`.  Together with the finite-etale `F_4` graph it
produces the explicit substack (12) and the all-degree cohomological
consequence (13).

**TT correction:** `P^1(F_4)` is a local discriminant packet with a `3+2`
monodromy split.  It is not itself a proof that the cubic period line, the
sign cover, and the quartic root cover are mutually identified modular
curves.

**Open gates:** integral family-level cubic graph presentation; period-image
normalization and degree; compactified boundary comparison.  None is supplied
by C909 saturation, by the square class `T`, or by the parameter relation
`T=81t^2` alone.
