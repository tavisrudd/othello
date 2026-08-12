# C909 reconciliation: actual \(K[2]\), exotic packet, and graph-coordinate descent

Date: 2026-08-12  
Status: hostile reconciliation of fd1ee425 versus 8e36c3f7; no manuscript,
PDF, mirror, or Lean edit.

## Final verdict

The objection in fd1ee425 is correct against the bare inference

\[
 \text{actual }K_2+\text{ exotic unordered pair}
 +\bigl(E_{\rm axis}[2]\simeq E_T[2]\bigr)
 \Longrightarrow r^2=T\text{ for actual }K_2.
\]

An elliptic \(2\)-torsion isomorphism alone does not identify a subgroup of
\(E[2]^5\). However, the missing step is a short, formal naturality lemma
for the \(A_5\)-stable graph packet, together with the finite-level descent
on which the axes are labelled. It is not a new period or integral-lattice
theorem.

Thus:

* **GO** for identifying the actual exotic-packet torsor with \(r^2=T\),
  after printing the graph-packet naturality/descent lemma below;
* **MINOR** for the current proof architecture, because 8e36c3f7 uses
  this lemma implicitly but does not state it;
* **MAJOR** if the manuscript continues to assert that an abstract
  \(E[2]\)-isomorphism by itself identifies the chosen graph or gives a
  globally selected sheet on the unmarked \(T\)-line.

The honest conclusion is an identification of the **unordered actual
exotic packet and its degree-two marking torsor**. A selected member requires
the signed/level cover and one orientation convention.

## The missing formal lemma

Let \(H_2=\operatorname{Aug}(\mathbf F_2^6)/\langle\mathbf1\rangle\) be the
constant \(A_5\)-heart and
\[
 D=\operatorname{End}_{\mathbf F_2A_5}(H_2)=\mathbf F_4.
\]
Let \(V\) be a rank-two symplectic \(\mathbf F_2\)-local system. The
two-primary discriminant module of the six-axis source is
\[
 \mathcal M_2(V)=H_2\otimes_{\mathbf F_2}V
\]
with its standard \(A_5\)-invariant hyperbolic alternating form. Define
\(\mathcal P(V)\) to be the finite étale local system of
\(A_5\)-stable maximal isotropic halves of \(\mathcal M_2(V)\).

After choosing a symplectic basis of \(V\),
\[
 \mathcal P(V)\cong\mathbf P^1(D)=\mathbf P^1(\mathbf F_4),
\]
and the three rational points and two exotic points form the invariant
decomposition
\[
 \mathcal P(V)=\mathbf P^1(\mathbf F_2)\sqcup
 \mathcal P_{\rm ex}(V),\qquad |\mathcal P_{\rm ex}(V)|=2.
\]
Changing the basis by \(g\in\operatorname{GL}_2(\mathbf F_2)\) changes the
slope by the usual fractional-linear \(g\)-action on
\(\mathbf P^1(\mathbf F_4)\). Consequently this construction descends from
the frame bundle of \(V\), and every symplectic local-system isomorphism
\[
 u:V'\xrightarrow{\sim}V
\]
induces canonically
\[
 1\otimes u:\mathcal M_2(V')\xrightarrow{\sim}\mathcal M_2(V),
 \qquad
 \mathcal P_{\rm ex}(V')\xrightarrow{\sim}\mathcal P_{\rm ex}(V).
\tag{N}
\]

This is the graph-coordinate descent/naturality lemma. It is just the
\(\mathbf P^1(\mathbf F_4)\) classification plus its
\(\operatorname{PGL}_2(\mathbf F_2)\)-equivariance; no choice of slope
coordinate survives in (N). The two possible identifications
\(D\simeq\mathbf F_4\) exchange the two exotic points, so only the unordered
packet is canonical.

## Exact logical diagram

Work over the common smooth labelled base \(B^\circ\), then pass to a finite
étale cover \(B^\ell\) labelling the five axes and the relevant \(2\)- and
\(3\)-level data. Let
\[
 V_{\rm ax}=E_{\rm axis}[2],\qquad V_T=E_T[2].
\]
The degree-one VGY/Prym comparison and the quadratic-twist comparison give a
relative symplectic isomorphism
\[
 \eta:V_T\xrightarrow{\sim}V_{\rm ax}.
\tag{1}
\]
The naturality lemma gives the upper horizontal arrow below:

\[
\begin{array}{ccc}
 \mathcal P_{\rm ex}(V_T)
   &\xrightarrow{\ \mathcal P_{\rm ex}(\eta)\ }&
 \mathcal P_{\rm ex}(V_{\rm ax})\\[2mm]
 \Big\Vert && \Big\Vert\\[-1mm]
 \text{Tate exotic packet}
   &\xrightarrow{\ \mathrm{id}_{H_2}\otimes\eta\ }&
 \text{axis exotic packet containing }K_2 .
\end{array}
\tag{2}
\]

For the Tate model, the left packet is the discriminant/sign torsor:
\[
 \mathcal P_{\rm ex}(V_T)
 \cong \operatorname{Spec}\mathcal O_{B^\circ}[r]/(r^2-T).
\tag{3}
\]
The actual norm-axis isogeny supplies
\[
 f:E_{\rm axis}^5\to J,\qquad
 K=\ker f,\qquad K_2\subset\mathcal M_2(V_{\rm ax}).
\]
The relative \(A_5\)-equivariance of \(f\) makes \(K_2\) an
\(A_5\)-stable maximal isotropic. Generic Torelli excludes the rational
three-point packet, and connectedness of \(B^\circ\) keeps \(K_2\) in
\(\mathcal P_{\rm ex}(V_{\rm ax})\). Thus (2) transports the *actual*
unordered packet, not merely an auxiliary elliptic system.

On the signed cubic cover,
\[
 T=81t^2,\qquad r=\pm9t.
\tag{4}
\]
After choosing one fibrewise symplectic orientation, the actual section
\(K_2\) is one of the two sheets, conventionally \(r=9t\). Reversing that
orientation gives \(r=-9t\). Before this signed/level refinement, the
correct object is the unordered packet and its quadratic torsor, not a
globally chosen graph.

## What each ingredient does, and what it does not do

1. **Actual relative \(K\).** Supplies an actual subgroup scheme and,
   after level/axis labelling, a section of the actual graph-packet local
   system. It does not identify the packet with Tate coordinates.
2. **Torelli exoticity.** Places that section in the two-point exotic
   sub-local system rather than the rational three-point sub-local system.
   It does not identify those two points with the Tate discriminant roots.
3. **\(E_{\rm axis}[2]\simeq E_T[2]\).** Supplies the coefficient-local-system
   isomorphism. By itself it does not act on \(E[2]^5\)-subgroups.
4. **Naturality (N).** Applies the coefficient isomorphism to the full
   \(A_5\)-stable graph module and is the exact bridge from (1)--(3) to the
   actual packet torsor.
5. **Finite-level descent.** Ensures the axes, graph subgroup, and the map
   to a fixed presentation stack are algebraic over one common finite étale
   base. It is unnecessary to descend a selected sheet to the unmarked
   \(T\)-line; that sheet is precisely the quadratic cover.

The relative norm construction and VGY comparison already supply items
1--3. Item 4 is the omitted formal line in 8e36c3f7; item 5 is the
base/marking qualification that fd1ee425 correctly demanded.

## Corrected claim

Replace

> “The Tate discriminant cover \(r^2=T\) is the marking of the actual
> \(K[2]\)-graph”

by

> “The natural \(\mathbf P^1(\mathbf F_4)\) graph-packet functor transports
> the actual \(A_5\)-stable exotic \(K_2\)-packet along
> \(E_T[2]\simeq E_{\rm axis}[2]\). Hence its unordered degree-two marking
> torsor is \(r^2=T\). On the signed, axis-levelled cubic cover, a chosen
> graph is the sheet \(r=\pm9t\), after one orientation convention.”

This formulation fully answers the source objection while retaining the
closed norm/Prym gain. It does not claim a canonical choice of
\(\omega\) versus \(\omega^2\) on the unmarked base.

## Mystery ledger

**Settled after insertion of (N):** actual \(K_2\), Torelli exoticity, and
coefficient \(2\)-torsion comparison determine the actual exotic packet
torsor, not merely an auxiliary Prym resolvent.

**Still required in a theorem proof:** print the \(H_2\otimes V\) module,
the \(\mathbf P^1(\mathbf F_4)\) classification, and its
\(\operatorname{GL}_2(\mathbf F_2)\)-equivariance; state the finite étale
axis/level base on which \(K_2\) is a section.

**Not claimed:** a globally selected exotic graph on the unmarked
\(X_0(3)\) line, extension across cusps, or a new classification of all
\(A_5\)-stable graph subgroups.

## Hostile audit of the fixed-\(\tau\) normalization claim

The sentence
\[
 \mathbf C(M_\tau)=\mathbf C(T,r)=\mathbf C(t)
\]
is not automatic for the \(\tau\) described in the fixed-graph
normalization note. If \(\tau\) includes a full nonzero-\(2\)-torsion label,
then it adds the degree-three root cover \(X_0(6)\); if it includes a
nonconstant ordering/axis or auxiliary level torsor, it adds the
corresponding finite extension as well. The sign cover alone has
\[
 \mathbf C(T,r)=\mathbf C(t),\qquad T=81t^2,\ r=9t.
\]

The minimal datum for this equality is therefore:

* the cyclic \(\Gamma_0(3)\) level already used by the Tate model, with the
  monodromy-selected scalar \(3\)-graph;
* one oriented member of the exotic \(2\)-packet, equivalently the sign
  cover \(r^2=T\);
* a fixed \(A_5\!/D_5\) group marking and one fixed ordered five-axis choice
  treated as constant labels, not a varying permutation torsor; and
* no additional choice of a nonzero \(2\)-torsion root or full linear
  \(2\)-level.

Call this \(\tau_{\min}\). On a connected normalized smooth component,
\[
 \mathbf C(M_{\tau_{\min}})=\mathbf C(T,r)=\mathbf C(t).
\]
If one labels a nonzero \(2\)-torsion point, the resulting field is instead
a degree-three extension of \(\mathbf C(t)\) (the compositum with the
\(X_0(6)\) root cover). Full level or a genuinely nonconstant axis-label
torsor gives further finite extensions. Constant choices of axis names only
produce disjoint copies and do not enlarge the function field.

The safe general statement is the following. Let
\(\widetilde M_\tau\) be the normalization of a connected fixed-data modular
component after all auxiliary labels, and let \(U_t\) be the signed smooth
\(A_5\) line. There is a finite-level morphism
\[
 \widetilde U_\tau\longrightarrow\widetilde M_\tau
\]
where \(\mathbf C(\widetilde U_\tau)\) is a finite extension of
\(\mathbf C(t)\) exactly accounting for the extra labels. For
\(\tau_{\min}\), \(\widetilde U_{\tau_{\min}}=U_t\) generically and the map
is birational. After removing the finite boundary/degeneracy set and
rigidifying generic elliptic inertia, a representable quasi-finite
birational map of normal curves is an open immersion onto a dense open.
For larger \(\tau\), only this finite-cover/birational-after-base-change
statement is safe; equality with \(\mathbf C(t)\) requires proving that the
extra label torsor is constant or that the \(A_5\) family has been pulled
back to its splitting cover.

Thus the fixed-graph note should say “a birational presentation curve for
\(\tau_{\min}\)” (and “finite cover after added labels” for general \(\tau\)),
not unconditionally identify the full fixed-\(\tau\) function field with
\(\mathbf C(t)\).
