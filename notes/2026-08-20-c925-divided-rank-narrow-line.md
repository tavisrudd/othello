# Module 46. The narrow rank row is divided equivariant rank

**Packet part:** Module 46.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** an equivariant Thom presentation makes the narrow rank row the
ordinary equivariant rank divided by its universal zero
\((1-q^{-1})^r\).  Therefore every rank-preserving comparison which carries
the narrow image onto the narrow image preserves the divided row; after
exact specialization and pairing preservation it also preserves the dual
shifted-point line.  For a toric canonical completion this removes the
separate marked-line calculation after the occurrence, fixed-phase, Thom,
pairing, and exact-base-change identifications have been supplied.

## 46.1 Dividing the universal Thom zero

Let \(R\) be a domain equipped with a distinguished non-zero-divisor

\[
                         s=1-q^{-1}.                            \tag{46.1}
\]

The intended example is the unramified local ring of the fibre-scaling
torus at \(q=1\).  Let \(A\) be an \(R\)-module with an \(R\)-linear
equivariant-rank map

\[
                         \rho:A\longrightarrow R.              \tag{46.2}
\]

Suppose \(Y=\operatorname{Tot}(E^\vee)\) for an equivariant vector bundle
\(E\) of rank \(r\ge1\) on a smooth proper base \(X\).  The fibre-scaling
torus acts trivially on \(X\), and (46.2) is the \(R\)-valued generic rank on
\(K^0(X)\otimes R\), transported to \(Y\) by equivariant vector-bundle
homotopy invariance.  Suppose the chosen compact-support theory has the
equivariant Thom presentation

\[
 K^0_c(Y;R)\cong K^0(X;R),\qquad
 N:=\operatorname{im}\bigl(K^0_c(Y;R)\to K^0(Y;R)\bigr)
      =\theta_E K^0(X;R),                                      \tag{46.3}
\]

where, after identifying \(K^0(Y;R)\cong K^0(X;R)\),

\[
              \theta_E=\lambda_{-1}(q^{-1}E).                 \tag{46.4}
\]

This is the equivariant zero-section self-intersection class.  Its rank is

\[
                         \rho(\theta_E)=s^r.                   \tag{46.5}
\]

Consequently

\[
                         \rho(N)\subseteq s^rR.                \tag{46.6}
\]

### Proposition 46.1 -- the divided-rank row

There is a canonical \(R\)-linear row

\[
 \rho^{\mathrm{div}}:N\longrightarrow R,
 \qquad
 \rho^{\mathrm{div}}(x)=\frac{\rho(x)}{s^r}.                  \tag{46.7}
\]

For \(b\in K^0(X;R)\),

\[
                  \rho^{\mathrm{div}}(\theta_Eb)=\rho_X(b).  \tag{46.8}
\]

In particular \(\rho^{\mathrm{div}}\) is split surjective, and its coimage

\[
 L^{\mathrm{div}}
    :=N/\ker\rho^{\mathrm{div}}\xrightarrow{\ \sim\ }R       \tag{46.9}
\]

is a canonical free rank-one quotient.

#### Proof

Equation (46.6) gives existence in (46.7), and the non-zero-divisor
hypothesis on \(s\) gives uniqueness.  Additivity and \(R\)-linearity follow
after multiplying the proposed equations by \(s^r\).  Multiplicativity of
rank and (46.5) give (46.8).  Taking \(b=1\) proves surjectivity and (46.9).
\(\square\)

No choice of a preimage under \(\theta_E\) enters (46.7).  Equivalently, if
\(\theta_Eb=\theta_Eb'\), then (46.5) gives
\(s^r(\rho_X(b)-\rho_X(b'))=0\), hence the two ranks agree.

## 46.2 Rank transport already transports the narrow row

Let \((A_\pm,N_\pm,\rho_\pm)\) be two packages as above, with the same rank
\(r\) and the same primitive parameter \(s\).  Let

\[
                     F:A_-\xrightarrow{\sim}A_+               \tag{46.10}
\]

be an \(R\)-linear isomorphism such that

\[
             F(N_-)=N_+,
 \qquad
             \rho_+F=u\rho_-                                  \tag{46.11}
\]

for a unit \(u\in R^\times\).

### Theorem 46.2 -- divided-rank transport

The restriction \(F_N:N_-\to N_+\) satisfies

\[
              \rho^{\mathrm{div}}_+F_N
                         =u\rho^{\mathrm{div}}_-.              \tag{46.12}
\]

It therefore induces an isomorphism of rank quotient lines

\[
 \overline F:
 L_-^{\mathrm{div}}\xrightarrow{\sim}L_+^{\mathrm{div}}.      \tag{46.13}
\]

No Euler-intertwining equation
\(F(\theta_-b)=\theta_+\Phi(b)\) is required.

#### Proof

For \(x\in N_-\), multiply the desired equality by \(s^r\):

\[
 s^r\rho^{\mathrm{div}}_+(F_Nx)
   =\rho_+(Fx)
   =u\rho_-(x)
   =s^ru\rho^{\mathrm{div}}_-(x).
\]

Cancel the non-zero-divisor \(s^r\).  Since \(u\) is a unit, \(F_N\) carries
the two kernels onto one another, giving (46.13).  \(\square\)

This is strictly weaker than the Euler square in Module 44.  The comparison
may mix Thom representatives by arbitrary divided-rank-zero terms.

### Corollary 46.2A -- lawful parameter reindexing

Suppose instead that the two primitive parameters satisfy

\[
                         s_+=v s_-                             \tag{46.13a}
\]

in one common unramified trait, for a unit \(v\in R^\times\).  If the two
Thom ranks are \(s_\pm^r\) and \(\rho_+F=u\rho_-\), then

\[
             \rho^{\mathrm{div}}_+F_N
                    =uv^{-r}\rho^{\mathrm{div}}_-.             \tag{46.13b}
\]

Thus inversion or a unit change of the primitive fibre coordinate changes
only the lawful Writer scalar.  A ramified change is different: it changes
the vanishing order and requires the correspondingly reindexed exponent.

#### Proof

The equality
\(s_+^r\rho_+^{\mathrm{div}}F_N
  =u s_-^r\rho_-^{\mathrm{div}}\), followed by (46.13a), gives (46.13b).
\(\square\)

## 46.3 Exact specialization and the shifted point

Let \(k=R/(s)\).  Assume \(N_\pm\) and their coimage lines have exact base
change at \(s=0\), and that the resulting state spaces are identified with
Shoemaker's narrow state spaces:

\[
 \overline N_\pm=N_\pm\otimes_Rk
      \cong H^*_{\mathrm{nar}}(Y_\pm).                         \tag{46.14}
\]

Then (46.7) specializes to a nonzero row

\[
 \overline\rho^{\mathrm{div}}_\pm:
 H^*_{\mathrm{nar}}(Y_\pm)\longrightarrow k.                 \tag{46.15}
\]

The Chern character of the closed Thom class is not literally its top
Euler class.  If \(x_1,\ldots,x_r\) are the Chern roots of \(E\), then

\[
 \left.\operatorname{ch}(\theta_E)\right|_{q=1}
   =\prod_i(1-e^{x_i})
   =e(E^\vee)\,U_E,
 \qquad
 U_E:=\prod_i\frac{e^{x_i}-1}{x_i},                            \tag{46.16}
\]

and \(U_E\) is invertible with degree-zero term one.  Thus, writing
\(\beta=U_E\operatorname{ch}(b)\), one has \(\beta_0=\operatorname{rk}(b)\),
and the Thom/Chern-character identification gives

\[
 \overline\rho^{\mathrm{div}}(e(E^\vee)\beta)=\beta_0.         \tag{46.17}
\]

This is Module 44's descended narrow rank row.  Any additional Todd or
Gamma unit is part of the exact framing identification assumed below; its
degree-zero unit must be retained in the row normalization.

Suppose in addition that the specialized comparison
\(\overline F_N\) preserves the narrow pairing, and let \(p_\pm\) be the
shifted Thom point classes representing (46.15):

\[
 \langle p_\pm,x\rangle_{\mathrm{nar},\pm}
                 =\overline\rho^{\mathrm{div}}_\pm(x).        \tag{46.18}
\]

### Corollary 46.2B -- the shifted line is automatic

Writing \(\bar u\in k^\times\) for the specialization of \(u\),

\[
                       \overline F_N(p_-)
                              =\bar u^{-1}p_+.                 \tag{46.19}
\]

In particular a rank-preserving comparison (\(u=1\)) carries the shifted
point exactly.

#### Proof

For \(y=\overline F_Nx\), pairing preservation and (46.12) give

\[
 \langle\overline F_Np_-,y\rangle_+
  =\langle p_-,x\rangle_-
  =\overline\rho_-^{\mathrm{div}}(x)
  =\bar u^{-1}\overline\rho_+^{\mathrm{div}}(y)
  =\langle\bar u^{-1}p_+,y\rangle_+.
\]

Nondegeneracy of the narrow pairing proves (46.19).  \(\square\)

Under the reindexing of Corollary 46.2A, replace
\(\bar u^{-1}\) in (46.19) by \(\bar u^{-1}\bar v^r\).

## 46.4 The normal jet and the narrow row are the same sparse shadow

For a line bundle, \(r=1\).  On the rank quotient,

\[
 \rho\bigl((1-q^{-1}[E])b\bigr)
       =(1-q^{-1})\rho_X(b)=s\rho_X(b).                        \tag{46.20}
\]

Thus Module 42's first normal jet and Module 44's narrow rank row are two
presentations of (46.7):

\[
 \boxed{
 \text{normal coefficient of equivariant rank}
   =\text{divided rank on the narrow image}
   =\text{row paired with the shifted Thom point}.}            \tag{46.21}
\]

The equality is only on the consumed rank quotient.  It does not identify
the full jet module with the full narrow QDM, and it does not make the raw
special-fibre map invertible.

## 46.5 Canonical-completion consequence

Combine Modules 43 and 45.  For one canonical-completion occurrence, assume:

1. a primitive unramified fibre parameter \(q\), canonical \(R\)-flat
   equivariant K-lattices, and the Thom presentation (46.3), with exact
   narrow/coimage base change;
2. one proper Fourier--Mukai comparison \(F=\operatorname{FM}_{\mathrm{CIJ}}\)
   which is also identified, through a common window or a commutative
   comparison square, with Module 43's rank-preserving map, includes the
   fibre-scaling torus, and carries \(N_-\) onto \(N_+\);
3. every realization, narrow-preserving, Gamma-framing, spanning, parameter,
   and pairing hypothesis of Theorem 45.3, with the specialization of this
   same \(F\) identified with \(\Theta_{\mathrm{nar}}\); and
4. an occurrence-level fixed primitive-phase adapter identifying the
   specialized divided-rank row and shifted point with the actual endpoint
   packet and row.

Then Theorem 46.2 and Corollary 46.2B prove the marked-line equation

\[
             \Theta_{\mathrm{nar}}(p_{X,-})=p_{X,+}.           \tag{46.22}
\]

Therefore the completed algebraic/QDM comparison needs no independent
Euler-intertwining calculation and no independent scalar computation after
items 1--4 are proved.  Item 4 remains load-bearing: neither a full toric
QDM nor a full narrow QDM automatically identifies the selected cubic
primitive phase or its occurrence reindexing.

## 46.6 Failure modes

Each hypothesis has a sharp role.

- Without \(F(N_-)=N_+\), the divided row is not even in the target type.
- Without rank preservation, \(F\) may shear the quotient line by a
  nonunit or kill it.
- Without a common primitive \(s\), ramification changes the division order;
  if \(s=ut^e\), the correct order is \(er\), not \(r\).
- Without exact coimage base change, the generic divided row need not equal
  the closed narrow row.  The model \(R\xrightarrow{s}R\) has a nonzero
  divided row but zero raw closed-fibre map.
- Without pairing preservation, row transport does not imply transport of
  its representing vector.  On \(k^2\) with row \((x,y)\mapsto x\), standard
  pairing, and \(p=(1,0)\), the shear
  \(\left(\begin{smallmatrix}1&0\\a&1\end{smallmatrix}\right)\) preserves the
  row but sends \(p\) to \((1,a)\).
- Without the fixed-phase adapter, (46.22) is only a statement in the full
  narrow receiver, not in the primitive packet consumed by the birational
  proof.

## 46.7 Source and scope audit

The equivariant Thom/self-intersection presentation (46.3)--(46.5) is the
rank-\(r\) form of the zero-section calculation audited in Module 42; for a
line it is exactly \(1-q^{-1}[E]\).  Module 43 supplies the common-window
rank equation, while Module 45 supplies preservation of the
compact-to-ordinary K-theory image by the proper Fourier--Mukai
correspondence and the conditional narrow-QDM realization.  Shoemaker's
narrow pairing and shifted Thom class are used only after the exact
realization/base-change hypotheses in Section 46.3.  No cited source is read
as identifying the actual cubic primitive phase; that remains item 4 of
Section 46.5.

## 46.8 EJ/TT and mystery ledger

**EJ.** Modules 42 and 44 were not competing augmentations.  On the minimal
rank consumer they are the same conormal/divided-rank shadow.  Module 45
supplies functoriality of the narrow image; Module 43 supplies rank
preservation.  Together they force the marked shifted line.

**TT.** Divide only the scalar row, not the object.  Attempting to divide the
whole quantum-Serre map asks for a nonexistent raw inverse at \(q=1\).
Divisibility of rank is canonical and is exactly all the final consumer uses.

| question | status | exact evidence or gate |
|---|---|---|
| Is the divided row well-defined? | **yes** | Proposition 46.1 |
| Does narrow-image plus rank transport preserve it? | **yes** | Theorem 46.2 |
| Does the paired comparison preserve the shifted line? | **yes after exact specialization** | Corollary 46.2B |
| Is an Euler-intertwining square still needed? | **no for this quotient-line consumer** | (46.12) |
| Are the jet and narrow routes distinct on the rank line? | **no** | (46.20)--(46.21) |
| What remains geometric? | **the occurrence/fixed-phase adapter** | item 4 of Section 46.5 |

## Boundary

The divided-rank theorem closes the separate completed-model marked-line
calculation.  It does not construct a toric occurrence for an AKMW overlap,
identify the actual cubic primitive phase inside the narrow QDM, or provide
adjacent reindexing along a weak factorization.  Those are now the only
completed-route gates; no local scalar, Euler-square, or first-jet value
remains to be computed once their typed realizations exist.

**Successor.**  Module 47 proves that a single-valued horizontal realization
automatically transports every generalized primitive sector.  Thus the
fixed-phase part of item 4 reduces to identifying the actual packet with one
common loop or typed deck path and its explicit character reindexing.
