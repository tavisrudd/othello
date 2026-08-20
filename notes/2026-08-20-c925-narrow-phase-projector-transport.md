# Module 47. Horizontal narrow transport carries the primitive phase

**Packet part:** Module 47.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** a single-valued horizontal narrow comparison automatically
intertwines monodromy and hence transports every generalized character
sector.  After the independent divided-rank and pairing laws of Module 46
are attached, it also transports the restricted row and pairing-dual
inverse-character point.  No multiplicity-one eigenspace is required.  The
remaining input is the occurrence-level identification of the actual cubic
primitive packet with one common geometric loop or typed deck path.

## 47.1 Generalized sectors are functorial

Let \(K\) be a field, let \(V_\pm\) be finite-dimensional \(K\)-spaces, and
let

\[
 T_\pm\in\operatorname{GL}(V_\pm),\qquad
 F:V_-\xrightarrow{\sim}V_+                                  \tag{47.1}
\]

satisfy

\[
                           FT_-=T_+F.                           \tag{47.2}
\]

Choose a splitting field \(L/K\) for the two minimal polynomials, fix
\(\chi\in L^\times\), and write a subscript \(L\) for scalar extension.
For any \(D\ge\max(\dim V_-,\dim V_+)\), define the generalized character
sector

\[
 V_{\pm,\chi}:=\ker(T_{\pm,L}-\chi)^D
          \subset V_{\pm,L}.                                  \tag{47.3}
\]

### Proposition 47.1 -- generalized-character transport

Equation (47.2) restricts to an isomorphism

\[
              F_{L,\chi}:V_{-,\chi}\xrightarrow{\sim}V_{+,\chi}.
                                                                    \tag{47.4}
\]

If the minimal polynomials split into coprime primary factors, \(F\) also
intertwines the corresponding polynomial spectral idempotents:

\[
                    F_LP_{-,\chi}=P_{+,\chi}F_L.               \tag{47.5}
\]

#### Proof

Polynomial functional calculus in (47.2) gives

\[
          F_L(T_{-,L}-\chi)^D=(T_{+,L}-\chi)^DF_L.
\]

Thus \(F\) maps the kernel in (47.3) into the target kernel.  The same
argument for \(F^{-1}\) gives equality and (47.4).  A primary idempotent is
a polynomial in \(T\), so the same functional calculus proves (47.5).
\(\square\)

This theorem concerns the whole generalized sector.  It neither assumes nor
proves that its eigenspace or fixed space is one-dimensional.

## 47.2 The divided row restricts without a new law

Let \(N_\pm\subseteq V_\pm\) be \(T_\pm\)-stable subspaces, and suppose \(F\)
carries \(N_-\) onto \(N_+\).  Let

\[
 r_\pm:N_\pm\longrightarrow K,\qquad
                         r_+F=c\,r_-                           \tag{47.6}
\]

for \(c\in K^\times\).  Extend \(N_\pm,r_\pm,F\) to \(L\) and define

\[
 N_{\pm,\chi}=N_{\pm,L}\cap V_{\pm,\chi},\qquad
 r_{\pm,\chi}=r_{\pm,L}|_{N_{\pm,\chi}}:
                         N_{\pm,\chi}\longrightarrow L.        \tag{47.7}
\]

### Corollary 47.1A -- phase-restricted row transport

The map (47.4) carries \(N_{-,\chi}\) onto \(N_{+,\chi}\) and satisfies

\[
                 r_{+,\chi}F_{L,\chi}=c\,r_{-,\chi}.           \tag{47.8}
\]

Consequently the zero/nonzero marker and the row coimage line are preserved
on the \(\chi\)-sector; the coimage is zero or one-dimensional.  This
remains true when either restricted row is zero.

#### Proof

Sector transport follows from Proposition 47.1 and
\(F_L(N_{-,L})=N_{+,L}\).
Equation (47.8) is the restriction of (47.6).  Since \(c\ne0\), the two
restricted rows vanish simultaneously and \(F_{L,\chi}\) carries their kernels
onto one another.  \(\square\)

The whole phase specialization is the commutative diagram

\[
\begin{CD}
 N_{-,L} @>{F_L}>> N_{+,L}\\
 @V{P_{-,\chi}}VV @VV{P_{+,\chi}}V\\
 N_{-,\chi} @>{F_{L,\chi}}>> N_{+,\chi}\\
 @V{r_{-,\chi}}VV @VV{r_{+,\chi}}V\\
 L @>{\times c}>> L .
\end{CD}                                                       \tag{47.8a}
\]

For Module 46, \(r_\pm\) is the specialized divided-rank row.  Thus a
monodromy intertwiner consumes no additional row normalization after the
full narrow row law has been proved.  Transport of its representing point
additionally requires the pairing-preserving same-map hypothesis of
Proposition 47.2.

## 47.3 Pairing and inverse-character variance

Let \(W_\pm\) carry operators \(S_\pm\), and suppose there are perfect
pairings

\[
 \beta_\pm:W_\pm\times V_\pm\longrightarrow K                \tag{47.9}
\]

such that

\[
                  \beta_\pm(S_\pm w,T_\pm v)=\beta_\pm(w,v).
                                                                    \tag{47.10}
\]

Let \(G:W_-\to W_+\) and \(F:V_-\to V_+\) preserve the pairings and
intertwine \(S_\pm\) and \(T_\pm\).  Extend
\(W_\pm,S_\pm,G,\beta_\pm\) to the same splitting field \(L\), and set
\[
 W_{\pm,\chi^{-1}}
   :=\ker(S_{\pm,L}-\chi^{-1})^D.
\]
Then the scalar extension of (47.10) pairs \(W_{\pm,\chi^{-1}}\)
perfectly with \(V_{\pm,\chi}\).

Suppose \(p_\pm\in W_{\pm,\chi^{-1}}\) represent the restricted rows:

\[
              r_{\pm,\chi}(v)=\beta_{\pm,L}(p_\pm,v).          \tag{47.11}
\]

### Proposition 47.2 -- the dual phase line

Under (47.6), (47.9)--(47.11), and pairing preservation,

\[
                              G_Lp_-=c^{-1}p_+.                \tag{47.12}
\]

#### Proof

For \(y=F_Lv\in V_{+,\chi}\),

\[
 \beta_{+,L}(G_Lp_-,y)
   =\beta_{-,L}(p_-,v)
   =r_{-,\chi}(v)
   =c^{-1}r_{+,\chi}(y)
   =\beta_{+,L}(c^{-1}p_+,y).
\]

Perfectness on the paired primary sectors gives (47.12).  \(\square\)

This is the generalized-sector form of Module 35's point-line/row
equivalence.  It does not use a unique monodromy-fixed line.

## 47.4 Horizontal gauges supply the intertwiner

Let \(\mathcal N_\pm\) be narrow flat local systems on a common punctured
base, and let

\[
                  \Theta:\mathcal N_-\xrightarrow{\sim}\mathcal N_+
                                                                    \tag{47.13}
\]

be a single-valued horizontal isomorphism.  For a based loop \(\gamma\),
write \(T_\pm(\gamma)\) for monodromy.

### Theorem 47.3 -- common-loop phase transport

One has

\[
                 \Theta T_-(\gamma)=T_+(\gamma)\Theta.         \tag{47.14}
\]

Therefore \(\Theta\) transports every generalized
\(\chi\)-sector of the common loop.  If \(\Theta\) also satisfies Module
46's divided-rank and pairing laws, it transports the restricted row
coimage (zero or one-dimensional); in the nonzero case it transports the
rank quotient line and the dual inverse-character shifted point line.

#### Proof

Horizontal naturality around the based loop gives (47.14); this is Theorem
29.1 applied to the narrow local systems.  Proposition 47.1, Corollary
47.1A, and Proposition 47.2 give the remaining statements.  \(\square\)

Thus the Coates--Iritani--Jiang gauge in Module 45 does not need a separate
commutation-with-the-primitive-projector calculation if the primitive
projector is the primary projector for a loop already in its common
single-valued domain.

## 47.5 Deck paths and mapped characters

A ramified phase may be represented by a path whose endpoint lies on a
different sheet.  Let
\[
 D_\pm:\mathcal N_{\pm,\gamma(0)}
             \xrightarrow{\sim}\mathcal N_{\pm,\gamma(1)}
\]
be the chosen deck endpoint identifications and define the based operators

\[
              T_\pm^{\mathrm{deck}}
                 :=D_\pm^{-1}\operatorname{PT}_\pm(\gamma).    \tag{47.15}
\]

Theorem 47.3 applies only after the comparison is compatible with the two
endpoint identifications:

\[
       \Theta_{\gamma(1)}D_-=D_+\Theta_{\gamma(0)}.             \tag{47.16}
\]

More generally, work over a splitting field in which the orders of the
finite abelian deck groups are invertible.  Let
\(\varphi:G_-\xrightarrow{\sim}G_+\) be a group isomorphism and suppose

\[
                         Fg=\varphi(g)F.                        \tag{47.17}
\]

Then a character \(\chi_-\) is transported to

\[
                         \chi_+=\chi_-\circ\varphi^{-1}.        \tag{47.18}
\]

Indeed, for the standard character idempotents,

\[
                    F_LP_{\chi_-}=P_{\chi_+}F_L.               \tag{47.19}
\]

Equation (47.18) is the required path-mapping function: a lawful
reindexing may rename a phase, but it cannot silently forget which phase was
transported.

## 47.6 Exact \(m=2\) occurrence gate

After Modules 45--46, a completed overlap occurrence closes if it supplies:

1. the typed toric/Shoemaker narrow realization and exact equivariant Thom
   base change from Module 46;
2. one single-valued horizontal comparison \(\Theta\) whose Gamma square
   realizes the same rank-preserving Fourier--Mukai map \(F\) used there;
3. a based loop, or a deck path with (47.16), whose generalized
   \(\zeta_6\)-sector is identified at both ends with the actual primitive
   cubic packet;
4. the inverse-character pairing identification for the shifted point; and
5. occurrence and adjacent-path reindexing, using (47.18) whenever the deck
   generator changes; and
6. an incoming certificate \(r_{-,\zeta_6}\ne0\), audited at the path
   source and propagated through preceding typed edges.

Then Theorem 47.3 transports the primitive divided-rank quotient line.
Module 34 telescopes it along the chosen weak factorization.

Items 3--6 are geometric typing and endpoint data, not consequences of
crepancy.  In
particular, equality of two eigenvalue multisets does not identify their
primary sectors, and a lifted path without its deck endpoint map is not a
based loop.

## 47.7 Failure modes

- If \(\Theta\) is multivalued, its endpoint value can conjugate the
  monodromy and (47.14) is not the displayed equation without that
  conjugation.
- If the two geometric loops differ, horizontality does not compare their
  monodromies.
- If a deck path changes sheets and no endpoint identification is supplied,
  its monodromy is ill-typed.
- If \(F\) only matches spectra but does not intertwine operators, it may
  exchange or shear equal-dimensional primary sectors arbitrarily.
- If the primitive projector is constructed only after a non-exact
  specialization, its image need not commute with base change.
- If the restricted divided row is zero, phase transport is valid but gives
  no obstruction; source nonvanishing remains an endpoint certificate.

## 47.8 Source and scope audit

The horizontal-monodromy equation is Theorem 29.1 restricted to the narrow
local systems.  Module 35 supplies the inverse-character pairing variance,
Module 45 supplies the conditional horizontal paired narrow comparison,
and Module 46 supplies its divided-rank row.  The Coates--Iritani--Jiang
theorem is used only through the explicitly required Gamma square realizing
the same Fourier--Mukai map.  No cited source is read as identifying its
geometric loop or deck operator with the actual cubic primitive-sixth
formal sector.

## 47.9 EJ/TT and mystery ledger

**EJ.** The fixed-phase commutation law is not a new analytic estimate.  It
is functoriality of generalized eigenspaces under the horizontal narrow
comparison already supplied by Module 45.

**TT.** Do not seek a multiplicity-one selector when the consumer is a row
coimage.  Transport the whole generalized sector and then quotient by the
restricted row kernel.  Multiplicity disappears after the lawful zero-or-line
coimage quotient.

| question | status | exact evidence or gate |
|---|---|---|
| Does a horizontal gauge transport primary sectors? | **yes** | Proposition 47.1 and Theorem 47.3 |
| Must the primitive eigenspace be one-dimensional? | **no** | Corollary 47.1A |
| Which dual sector contains the point? | **the inverse character** | Proposition 47.2 |
| Can a lawful path rename the character? | **yes, by an explicit group isomorphism** | (47.17)--(47.19) |
| What remains? | **identify the actual cubic packet with one common loop/deck sector and type the reindexing** | Section 47.6 |

## Boundary

Module 47 removes a separate projector-commutation proof once a common
single-valued loop or typed deck path has been identified.  It does not
construct that geometric loop, prove that its \(\zeta_6\)-primary sector is
the actual cubic packet, or supply occurrence-to-occurrence deck
reindexing.  Those are now the entire fixed-phase content of the completed
narrow route.
