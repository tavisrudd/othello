# Module 35. Point-line duality compression

**Packet part:** Module 35.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** pairing-dual equivalence proved; Gamma-to-formal point-line
calibration remains open

## 35.1 Dual-sector typing

The rank row on a primitive character sector need not be represented inside
that same sector.  Let

\[
\beta_Y:W_Y\times V_Y\longrightarrow K
\tag{35.1}
\]

be the perfect flat pairing between the fixed-phase \(\chi^{-1}\)-sector
\(W_Y\) and the \(\chi\)-sector \(V_Y\).  Let \(p_Y\in W_Y\) be the
primitive projection of the Gamma point section and define

\[
\rho_Y(v)=\beta_Y(p_Y,v).
\tag{35.2}
\]

The point-period calculation audited in Module 33 says, on each inverse
primitive branch \(\chi^{-1}\), that \(p_X\ne0\) and that (35.2) is the
nonzero ambient-rank row on the paired \(\chi\)-branch.

For one blowup occurrence, suppose there are perfect exceptional pairings

\[
\beta_E:E_W\times E_V\longrightarrow K
\tag{35.3}
\]

and comparison isomorphisms

\[
J_V:V_Y\oplus E_V\overset\sim\longrightarrow V_{\widetilde Y},
\qquad
J_W:W_Y\oplus E_W\overset\sim\longrightarrow W_{\widetilde Y}
\tag{35.4}
\]

satisfying

\[
\beta_{\widetilde Y}(J_W(w,f),J_V(v,e))
=\beta_Y(w,v)+\beta_E(f,e).
\tag{35.5}
\]

This is the exactly typed pairing-compatible direct-sum interface.  A
pairing on \(V_Y\) alone would have the wrong character variance.

## 35.2 Row transport is one point-line equation

Let \(p_{\widetilde Y}\in W_{\widetilde Y}\) represent the upstairs rank row.

### Theorem 35.1 -- point-line/row equivalence

For \(c\in K^\times\), the following are equivalent:

1. the rank-row law

   \[
   \rho_{\widetilde Y}\circ J_V
   =c(\rho_Y\oplus0);
   \tag{35.6}
   \]

2. the dual point-vector law

   \[
   J_W^{-1}(p_{\widetilde Y})=c(p_Y,0).
   \tag{35.7}
   \]

After forgetting normalization, (35.6) is therefore equivalent to transport
of the projective line

\[
Kp_{\widetilde Y}
=J_W(Kp_Y\oplus0).
\tag{35.8}
\]

#### Proof

Write \(J_W^{-1}(p_{\widetilde Y})=(w,f)\).  By (35.2) and (35.5),

\[
\rho_{\widetilde Y}(J_V(v,e))
=\beta_Y(w,v)+\beta_E(f,e).
\tag{35.9}
\]

If (35.7) holds, (35.9) is (35.6).  Conversely, (35.6) says that

\[
\beta_Y(w-cp_Y,v)+\beta_E(f,e)=0
\]

for every \(v,e\).  Perfectness of \(\beta_Y\oplus\beta_E\) gives
\(w=cp_Y\) and \(f=0\), which is (35.7).  Quotienting by \(K^\times\)
gives (35.8).  \(\square\)

Thus every exceptional row scalar in (33.8) is packaged into the single
statement that the transported point vector has zero exceptional
coordinate.

## 35.3 Why the point line is geometrically natural

Along one chosen finite weak factorization, choose a closed point \(y\) in
the common open on which every vertex is identified and every center is
absent.  Its realization at each vertex is the same point; in particular,
for one blowup its inverse image is
\(\widetilde y\in\widetilde Y\setminus E\), and algebraically

\[
L\pi^*[\mathcal O_y]=[\mathcal O_{\widetilde y}].
\tag{35.10}
\]

Moreover, for every line bundle \(L\),

\[
\mathcal O_y\otimes L\cong\mathcal O_y.
\tag{35.11}
\]

Iritani's Gamma identity therefore gives

\[
s(\mathcal O_y)(\tau-2\pi i\,c_1(L),z)
=s(\mathcal O_y)(\tau,z).
\tag{35.12}
\]

So the **full** Gamma point section is intrinsically invariant under the
large-radius line-bundle monodromy.  Its primitive fixed-phase projection is
invariant provided the typed primitive projector commutes with that
monodromy, as required in the common operation-framed sector of Modules
29--34.  Without that commutation, invariance of the full section does not
descend to its projection.  No choice of a Beilinson basis is needed to
define the full point line.

Equations (35.10)--(35.12) do **not** prove (35.8).  They identify the
geometric and monodromy-normalized candidate line; the blowup comparison
still has to transport its fixed-phase primitive projection without an
exceptional Stokes correction.

## 35.4 Formal comparison is point-normalized

The audited initial-condition formula in Iritani's formal blowup comparison
sends the distinguished ambient top/point solution to

\[
J_{W,\mathrm{form}}^{-1}
\left(s_{\mathrm{pt}}^{\widetilde Y,\mathrm{form}}\right)
=s_{\mathrm{pt}}^{Y,\mathrm{form}}\oplus0.
\tag{35.13}
\]

Pairing compatibility then makes the formal rank row horizontal.  The
remaining discrepancy is not the Orlov algebra or the formal direct sum.
It is the identification

\[
\left[\text{fixed-phase Gamma point line}\right]
=
\left[\text{formally normalized point line}\right]
\tag{35.14}
\]

through the same sectorial continuation used by the blowup comparison.
An exceptional Stokes correction to (35.14) is exactly the vector form of
the scalar defects (33.8).

### Corollary 35.1A -- cheaper local provider

Under the pairing-compatible occurrence data (35.3)--(35.5), the local
rank-line certificate consumed by Module 34 follows from the single
projective-line identity (35.8).  It is unnecessary to verify the rank row
separately on every exceptional branch.

This is an equivalence, not a proof of (35.8).

## 35.5 One-dimensional uniqueness criterion

Let \(M_Y,M_E,M_{\widetilde Y}\) be operations intertwined by \(J_W\), and
suppose:

1. \(M_Yp_Y=p_Y\), \(M_{\widetilde Y}p_{\widetilde Y}=p_{\widetilde Y}\),
   and both point vectors are nonzero;
2. \(M_{\widetilde Y}J_W=J_W(M_Y\oplus M_E)\); and
3. \(\ker(M_{\widetilde Y}-1)\) is one-dimensional.

Then (35.8) follows automatically.

Indeed, both \(p_{\widetilde Y}\) and the nonzero vector \(J_W(p_Y,0)\) lie
in the one-dimensional upstairs fixed space.  They therefore span the same
line.

This gives a concrete alternative to direct Stokes calculation: find an
operation whose fixed line is exactly the point line in the dual
fixed-phase sector.  Large-radius monodromy fixes the point line by
(35.12), but uniqueness is not automatic on an intermediate blowup because
exceptional blocks can contribute additional fixed lines.  Any proposed
operation must eliminate those extra fixed directions without smuggling in
the desired ambient/exceptional splitting.

## 35.6 Executable calibration

The shared finite replay uses a two-dimensional ambient space and a
one-dimensional exceptional space with perfect diagonal pairings.  Over a
bounded grid of dual vectors, test vectors, nonzero scalars, and both a zero
and nonzero point vector, it checks that all pairing evaluations satisfy the
row identity (35.6) exactly when the dual vector is \(c(p_Y,0)\).  The
replay is a finite linear-algebra calibration only.

## 35.7 EJ/TT and mystery ledger

**EJ.** Pairing turns a family of exceptional scalar tests into transport of
one projective point line.  The full Gamma point section is invariant under
every line-bundle monodromy because a point sheaf is unchanged by tensoring;
the fixed-phase projection inherits this after the typed commutation law.

**TT.** The next useful uniqueness theorem must be stated on the dual
\(\chi^{-1}\)-sector and must account for every exceptional fixed line.
Uniqueness on the ambient cubic block alone proves nothing upstairs.

| question | status | exact evidence or gate |
|---|---|---|
| Is row transport equivalent to one dual-vector equation? | **yes** | Theorem 35.1 |
| Is normalization of the point vector needed? | **no** | projective line (35.8) |
| Is the full Gamma point line monodromy-invariant? | **yes** | \(\mathcal O_y\otimes L\cong\mathcal O_y\), (35.12) |
| Is its primitive projection invariant? | **conditional** | primitive projector must commute with the monodromy |
| Does the formal comparison have the desired point shape? | **yes formally** | audited initial condition (35.13) |
| Are the Gamma and formal point lines identified sectorially? | **open** | equation (35.14) |
| Can operation-fixed-line uniqueness prove it? | **open** | exclude exceptional fixed directions without circular splitting |

## Boundary

The pairing-dual equivalence and monodromy invariance of the full Gamma
point line are proved from the audited inputs.  Descent to the primitive
projection uses the typed commutation law.  The fixed-phase
Gamma-to-formal point-line identity (35.14) remains open.  No unconditional
\(m=2\) or all-\(m\) theorem follows.
