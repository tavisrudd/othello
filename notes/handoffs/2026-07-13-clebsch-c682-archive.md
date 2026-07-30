# C682 Hitchin--Clebsch working archive

**Lane**: `clebsch`

**Status**: maintained companion archive for the active C682 exploration.
The active work package is
`notes/clebsch-tasks/c682-hitchin-structural-exploration.md`, and the live
program routing authority is `notes/handoffs/2026-07-13-clebsch-paper.md`.
This file owns detailed lookup, chronology, negative gates, and parked
branches. It is intentionally more detailed than the shared Clebsch archive
and may be reorganized as C682 evolves.

## Fast lookup

| theme | settled structure | primary records |
|---|---|---|
| Transvectant/Fano inverse | Rank-four third-transvectant kernels recover the Petersen four-space and the Mukai--Umemura \(U_{22}\); \(V_5\) has the lower kernel inverse. Rank four plus fifth-transvectant isotropy cuts out the smooth compactification. | `notes/2026-07-26-c682-hitchin-structural-question.md`; `notes/2026-07-26-c682-transvectant-ladder.py` |
| Sarkisov and code shadows | The pointed-line map is the KPS double projection with width-three pagoda; the \(q=11\) code shadow has the dual MDS pair and self-dual midpoint. These are structural companions, not yet a functor from the link to codes. | detailed chronology below; exact scripts are linked from the structural report |
| Klein \(E_8\) operator | The primitive third transvectant realizes the three-node matrix factorization; the return algebra first fails at the degree-\(22\) Koszul line. The ordinary mod-\(11\) bridge fails and is repaired by a divided/Bockstein lift. | `notes/2026-07-28-c682-klein-e8-operator-algebra.md`; `notes/2026-07-28-c682-klein-e8-first-failure.md`; `notes/2026-07-28-c682-klein-e8-free-covariant.md`; `notes/2026-07-28-c682-klein-e8-graded-gauge.md`; `notes/2026-07-28-c682-klein-e8-literature-audit.md` |
| Corrected arithmetic bridge | The corrected dodecic class gives an equivariant primitive operator and compatible \(\mathbf Z_{11}\)-tower. The extended normal space maps two-sidedly to the golden incidence parents. | `notes/2026-07-28-c682-invariant-operator-divided-power.md`; `notes/2026-07-28-c682-mod11-transvectant-matching-bridge.md`; `notes/2026-07-28-c682-corrected-bridge-mod-1331.md`; `notes/2026-07-28-c682-transvectant-deformation-map.md` |
| Degree-22 section | The rank-four scheme is reduced of length \(22\), with \(1+5+6+10\) orbits; its target is a transverse anticanonical linear section. The invariant pencil lifts formally and Zariski-locally. | `notes/2026-07-28-c682-rank-four-resolvent.md`; `notes/2026-07-28-c682-u22-linear-section.md`; `notes/2026-07-28-c682-u22-bockstein-pencil.md`; `notes/2026-07-28-c682-zariski-bockstein-orbits.md`; `notes/2026-07-28-c682-kernel-incidence-morphism.md` |
| Classical mate geometry | The \(A_4,D_5,S_3\) maximal subgroups have unique nontrivial icosahedral mates. The \(D_5\) branch gives the exceptional Schläfli six and its functorial polar companion. | `notes/2026-07-28-c682-incidence-moduli.md`; `notes/2026-07-28-c682-maximal-subgroup-mates.md`; `notes/2026-07-28-c682-operator-schlafli.md` |
| Golden \(D_5\)--\(S_3\) incidence | Direct characteristic-zero kernel intersection is empty. The normalized apolar cross-Gram scalar has two \(\mathbf Q(\sqrt5)\)-conjugate values whose fibres are complementary \((6_5,10_3)\) designs; their first-order collision at \(11\) explains the Bockstein shadow. The frozen common marking identifies the stored matrix with \(\lambda_+\), \(\sqrt5=4\). | `notes/2026-07-29-c682-d5-s3-kernel-incidence.md`; `notes/2026-07-29-c682-common-marking-sign.md` |
| Boundary separator | The determinant-line ratio extends as \([c^2:g_Dg_S]\) on the normalized mate correspondence. Both golden values collapse to the same divisor--closed and closed--closed kernel pairs, so no coarse scalar extension exists. | `notes/2026-07-29-c682-boundary-cross-gram.md` |
| Global row swap | The normalized-graph deck exchange is the Schläfli apolar-polar row swap. In each \(D_5\), the two \(A_5\) five-cycle classes give complementary pentagon-side and pentagram-diagonal relations on the ten \(S_3\) labels. | `notes/2026-07-29-c682-normalized-graph-row-swap.md` |
| Integral base | The normalized operator/polar/incidence package has minimal base \(\mathbf Z[1/30]\) and structural bad primes \(2,3,5\). The \(11\)-elementary dodecic lattice removes the apparent \(7,11\) operator failures; only the scalar separator collides at \(11,23\). | `notes/2026-07-29-c682-minimal-integral-base.md` |

## Active and parked frontiers

### Active order

No successor frontier is selected. The integral-model frontier is closed;
C682 remains open until the user selects a parked branch or the new
characteristic-\(23\) divided-separator question.

### Parked independent branches

- **E8:** identify the principal symbol cubic intrinsically and classify later
  McKay-block corner failures.
- **QG:** prove the converse generic-fibre theorem for the rate-half
  MDS-code-to-stabilizer-AME construction.
- **E3:** classify codes whose legal-extension transform is a rational normal
  curve or minimal-degree variety; the all-size full-conic conjecture remains
  open.

## Guardrails

- C682 remains open until the user closes it; Silver results are not an
  automatic stopping condition.
- Paper III remains closed. Promotion of a C682 result requires its own
  source/novelty and release decision.
- Characteristic-zero ordinary operators, divided mod-\(11\) operators, and
  the special-fibre ten-pair pencil are distinct objects; never transfer a
  rank statement between them without the recorded comparison.
- The detailed records below include failed and pre-empted candidate crowns.
  Their correction trails are historical evidence, not live routing.

## Detailed chronology through 2026-07-29

The following record was moved from the live handoff during housekeeping. It
preserves exact report links, negative gates, scope boundaries, and the order
in which the current structure was established.

C682 is an open Hitchin-facing exploration, not a theorem gate.  It ranges
over the rational \(5J_0\) incidence torsor, complete golden fibre,
conjugate Clebsch charts, Petersen module, and Steinhardt/Gaunt realization,
looking for any interesting structural consequence, connection, question,
example, or viewpoint.  It must label proved deductions and conjectural
leads honestly.  Its target is Gold/Platinum-level structure; preserve
genuine Silver results as interim gains, but do not treat Silver as
completion.  It has no preset output shape, negative-close test, or automatic
stopping condition.  If the first proposed bridge is tautological or fails,
the task continues: rotate through deeper Hitchin-style geometric,
invariant-theoretic, arithmetic, and representation-theoretic questions and
look for the next interesting structure.  The user decides when C682 is
done.  This exploration does not reopen or hold the pre-release-green Paper
III bytes unless the user later chooses to promote a finding.

C682's first Gold result is proved and exactly cross-checked.  For an
icosahedral invariant \(I\in\mathcal H_6^{A_5}\), the unique
Clebsch--Gordan coupling
\(\mathcal H_3\otimes\mathcal H_6\to\mathcal H_6\), equivalently the third
binary transvectant, gives an \(A_5\)-map \(T_I\) of rank four.  Its kernel
is the nonmatching \(V_{3'}\), and its image is the unique \(V_4\), hence
the Petersen four-space.  At the Klein dodecic the kernel is also
pairwise isotropic for the fifth transvectant, so the kernel construction
identifies the binary-dodecic and Grassmannian \(PSL_2/A_5\) models on
their open orbit.  The rank-four locus has projective tangent dimension
three at the Klein point, so the Mukai--Umemura closure is its local
component there.  Both boundary-orbit representatives retain rank four
with exactly Hitchin's isotropic weight-space kernels; the closed orbit has
one extra rank-locus tangent direction, so isotropy remains essential.
After primitive normalization the integral map has rank four modulo \(11\)
and rank two modulo \(5\), opening a genuine bridge to C651's finite
matching cubic while respecting the Gaunt-scalar obstruction.  The `ej2`
portfolio pass also isolates exact or actionable compositions with
complete-port reconstruction, AME--LU reduction, Kneser defect spectra,
PRS catalecticant flags, and Frobenius replacement graphs.  The exact
matrix, proof, reproducibility boundary, algorithm landscape, cross-paper
disposition, conjectural \([5]\)-descent refinement, and mystery ledger are in
`notes/2026-07-26-c682-hitchin-structural-question.md`.  C682 remains open.
The highest-EV cheap gate is the C651 contraction through the primitive
mod-\(11\) map; globally, determine whether rank four plus isotropic kernel
characterizes the full Mukai--Umemura compactification.  Exact
Euclidean/binary normalization, conjugate-map descent, and targeted
primary-source audit precede any manuscript promotion.

C682's portfolio `ej` pass finds a Platinum three-paper candidate.  With
the frozen Paper II normalization
\(c_{\mathrm{match}}=4\sigma_3\) over \(\mathbf F_{11}\) and Paper III's
\(J_0|_V=16\sigma_3^2\),
\[
c_{\mathrm{match}}^2=J_0|_V,\qquad
w=\pm4c_{\mathrm{match}}\quad(w^2=5J_0).
\]
These are exact identities in C651's selected coordinates, not yet an
intrinsic equality: its \(V_4\) scalar was chosen inside a
three-dimensional Hom-space, and no morphism yet identifies the matching
sheet torsor with the incidence torsor.  Paper I supplies a potential
inverse-problem front end by reconstructing the Clebsch class and \(A_5\),
but not the required five-point marking or characteristic-zero lift.  The
resulting \(2\)-\(3\)-\(6\) target is quadratic reconstruction, cubic
orientation, and sextic forgetting by squaring, with the odd transvectant
as the proposed degree-three-to-degree-six map.  Promotion needs one
marked Paper I--II--III diagram, one C651/transvectant scalar comparison,
equivariance of the two \(C_2\)-actions, and wording restricted to the
abstract mod-\(11\) orientation algebra rather than global geometric good
reduction.  The full red-team verdict is in the C682 report.

C682's next `ej` pass closes one of C373's old common-duality kill tests.
For the ordered golden \(3\times6\) axis matrix \(A_t\), an exact Gale
kernel \(K_t\) and invertible \(H\) satisfy
\[
A_tK_t^{\mathsf T}=0,\qquad HK_t=-tA_{1-t}.
\]
Thus six-point Gale association is exactly Paper III golden Galois
conjugation on this marked fibre, and the two golden codes are dual:
\(\operatorname{row}(A_t)^\perp=\operatorname{row}(A_{1-t})\).
This does not yet identify Paper II's global factorization-sheet
involution with that operation.
The exact characteristic-zero certificate and an independent mod-\(11\)
replay are in the C682 evidence bundle.  A further Gold composition puts
Paper I's twenty oriented support triples over the same ten-vertex
Petersen carrier as Paper III's face axes.  The exact marked test is now
complete: one Paper I support orbit is precisely the ten supports of
icosahedron face pairs, the complementary orbit gives a second signed-sum
decomposition of the same ten face axes, and
\((T_0,\ldots,T_4)\mapsto(1,5,2,4,3)\) matches the displayed Paper III
labels.  A literature-triggered correction fixes the conjugate edge
branch: the conjugate icosahedron has edge inner product
\(-\bar t=t-1\), so its face supports are the complementary Paper I
orbit.  Support complementation, Gale association, and golden Galois
exchange are therefore the same marked \(C_2\), as the classical
opposite-icosahedron description predicts.  The Paper I support sheets
also have equal
moments through degree two and first differ cubically, exactly paralleling
Paper II's recovery/orientation mechanism.  However, the obvious
syntheme-quadratic followed by the Clebsch cubic is not the square of that
support cubic; two exact witnesses falsify the scalar identity.  The
`ej` invariant-span pass finds the corrected theorem on the augmentation
module:
\[
375C^2-12\sigma_3(q)
=6000p_6-4350p_4p_2-2125p_3^2+705p_2^3.
\]
The \(A_5\), outer-even \(S_5\), and fully symmetric \(S_6\) sextic spaces
have dimensions \(7,5,4\).  Hence the exotic outer-even quotient is
one-dimensional, and \(C^2\) and \(\sigma_3(q)\) have projective ratio
\(4:125\) there.  This is the surviving quadratic--cubic--sextic
composition: the Paper I orientation square and the common Paper II/III
Clebsch cubic agree after the syntheme quadratic map modulo universal
symmetric information.  Paper II's outer sheet placement and an intrinsic
interpretation of the four symmetric correction terms remain open.

The focused literature audit removes the proposed Platinum crown.
Howard--Millson--Snowden--Vakil's Joubert/Segre coordinates \(Z_T\) are
the support cubics \(C_T\), and their classical Segre--Igusa dual
coordinates are
\[
W_T=Z_T^2-\frac16\sum_U Z_U^2
   =\operatorname{center}(C_T^2).
\]
Kraft likewise treats the lowest-degree outer-\(S_6\) Joubert covariant
and its sextic Tschirnhaus application.  Hence uniqueness, outer
covariance, and the generic resolvent application are preempted.  The
surviving formula-level Gold candidate is the compact identity
\[
125W_T=4\,\operatorname{center}\bigl(\sigma_3(q_T)\bigr),
\]
which computes the classical dual coordinate from the five syntheme
quadratics using one Clebsch cubic.  A bounded exact-phrase audit did not
locate this presentation, but that is not an absence claim; compare it
term-by-term with the classical explicit \(W_T\) formulas before
promotion, and require a consequence beyond Segre--Igusa duality for any
general-journal claim.

C682's TR Platinum track is now proved in characteristic zero.  On the
Mukai--Umemura threefold, the dodecics annihilating a universal isotropic
three-plane under the third transvectant form a line bundle: exact ranks
on Hitchin's three orbits are uniformly \(12\).  The Borel lower bound then
makes the dodecic-to-kernel and plane-to-annihilator constructions inverse
scheme-valued functors.  Consequently the stable rank-four locus is exactly
the icosahedral orbit, while rank four plus fifth-transvectant kernel
isotropy cuts out its entire smooth compactification with no remote
component.  The construction is the degree-\(22\) projection of the
anticanonical \([1+\Phi_{12}]\) model from its invariant coordinate.
Three exact rational orbit rows, all tangent spaces, and a separately
written mod-\(101\) replay pass.  A bounded source audit did not locate the
explicit inverse.  Mukai's 1992 *Fano 3-folds* triangulates the same
compactification through polar six-sides/VSP, and his 1995/2002 Fano survey
explicitly identifies its genus-\(12\) net-of-skew-forms model with
\(SL_2/A_5\), but neither states a dodecic transvectant inverse.  The 1983
paper remains available here only through the user's page images, and the
broader databases remain uncovered, so novelty and manuscript promotion
are not yet claimed.

C682's beyond-threefold `ej` pass now places TR in a precise
transvectant-isotropic ladder.  For odd \(r\), the rank-two locus
\[
X_{m,r}=\{E\in Gr(2,\operatorname{Sym}^m):(E,E)_r=0\}
\]
has expected dimension \(2r-3\) and anticanonical index \(2r-m\).
The two uniform smooth Fano rows are
\(X_{r,r}=IGr(2,r+1)\) and the codimension-three invariant section
\(X_{r+1,r}\); all later positive-index rows lose transversality at the
unique Borel-fixed plane.  Solving the corresponding positive-index
threefold balance leaves exactly \(Q^3\), \(V_5\), a nontransverse
genus-eight near-miss, and \(U_{22}\).  Moreover \(V_5\) has the exact
lower kernel inverse
\[
I_6\longmapsto
\ker((\,\cdot\,,I_6)_2:\operatorname{Sym}^4\to\operatorname{Sym}^6),
\]
with rank three, third-transvectant-isotropic kernel of dimension two,
and annihilator line on all three orbits.  The exact audit is
`notes/2026-07-26-c682-transvectant-ladder.py`.  The highest-EV
genuinely beyond-variety continuation is to write the Sarkisov link
\(V_{22}\dashrightarrow V_5\) between the two kernel transforms and test
whether it exposes the branch divisor of the rational-quartic
Hilbert-scheme double cover.

C682 now resolves that pointed Sarkisov graph scheme-theoretically.
The seventh-polar formula is the complete system
\(|H-2L_\lambda|\): its ambient center is exactly the span of the first
infinitesimal neighborhood of \(L_\lambda\).  Hence its graph is the KPS
double-projection graph as a closed subscheme, not only a rational map
with the same reduced exceptional image.  The entering integral-closure
guess was false.  On the open pointed-line chart the exact base ideal is
the integrally closed ideal
\[
 (u^2,uv,v^5)\subsetneq(u,v)^2.
\]
After blowing up \(L_\lambda\), the residual ideal is \((r,v^3)\), its
Rees equation is \(rB=v^3A\), and three ordinary section blowups give
the width-three Reid-pagoda resolution of the unique flop.  KPS
Proposition 5.4.3 supplies the global special-line facts:
\(N_{L/X}=\mathcal O(1)\oplus\mathcal O(-2)\), no other line meets
\(L\), and the target flopping curve is the strict transform of the
unique tangent bisecant \(B_\lambda\).  The exact audit and independent
10,201-point mod-\(101\) replay are folded into the existing C682
Sarkisov-kernel bundle.  The next geometric gate is the inverse pointed
kernel formula, followed by the quartic branch equation; C682 remains
open until the user closes it.

C682's instance audit separates the universal construction from the
Clebsch special fibre.  The complete system \(|H-2L|\) is general for a
line on any smooth \(V_{22}\), but the local ideal
\((u^2,uv,v^5)\) and width-three pagoda belong to the special
Mukai--Umemura pointed chart.  The nearest comparisons are the
distinguished special-line links on the additive and multiplicative
large-automorphism \(V_{22}\)'s.  A second published link, centered on a
smooth conic, gives \(V_{22}\dashrightarrow Q^3\); together with the
line link and the transvectant classification, this places
\(Q^3,V_5,U_{22}\) in one exact two-edge diagram.  The next cheap
falsifiable experiment is the relative Rees algebra in the \(G_m\)-pencil
at its Mukai--Umemura parameter \(u=-1/4\), testing whether the
width-three pagoda is a collision of ordinary flop data.  The
highest-payoff calculation remains the \(PGL_2\)-constrained branch
equation of the rational-quartic Hilbert double cover.  A single
equivariant master correspondence explaining the three kernel nodes, both
links, the double conic of lines, and the pagoda is an explicit conjectural
target, not a proved conclusion.

C682's opposite-code audit finds an exact \(q=11\) midpoint pattern.
Evaluating the binary-form modules \(U_4,U_5,U_6\) on all twelve points
of \(\mathbf P^1(\mathbf F_{11})\) gives extended GRS codes
\[
 [12,5,8],\qquad[12,6,7],\qquad[12,7,6].
\]
The outer codes are dual and the middle code is self-dual.  These are
precisely the modules of the \(V_5\) kernel model, the normal-quintic
Sarkisov center \(\lambda U_5\), and the \(U_{22}\) kernel model.  Thus the
line link has an exact object-level code shadow: a dual MDS pair with a
rate-half self-dual MDS center, and hence an
\(\operatorname{AME}(12,11)\) midpoint.  The original Clebsch
\([6,3,4]_{11}\) seed instead has duality exchanging its two golden
forms, while its complete legal-extension port is the conic
\([12,3,10]_{11}\).  No functor from the Sarkisov graph to these code
objects is yet proved.

The conic-edge finite test is now exact.  Kuznetsov--Prokhorov's sextic
\((t_0^6:t_0^5t_1:t_0^3t_1^3:t_0t_1^5:t_1^6)\) gives
\[
 C_\Gamma=[12,5,6]_{11},\qquad
 C_\Gamma^\perp=[12,7,4]_{11};
\]
both Singleton defects are two.  It is the degree-six extended RS code
with precisely the \(t^2,t^4\) rows deleted, so
\[
0\to C_\Gamma\to R_6\to\mathbf F_{11}^2\to0,\qquad
0\to R_4\to C_\Gamma^\perp\to\mathbf F_{11}^2\to0.
\]
The code has \(24\) projective minimum words; the dual has \(15\), supported
on exactly fifteen rational four-secant planes in three five-element
orbits.  Its \(PGL_2(\mathbf F_{11})\) parameter stabilizer is exactly the
dihedral group of order \(20\), matching \(G_m\rtimes C_2\).  The
certificate exhausts all \(11^5\) codewords and \(1320\) projectivities,
and a separately implemented replay agrees.  This code is fixed throughout
the \(G_m\)-pencil and does not isolate the Mukai--Umemura parameter.

The `tt` pass makes the code statement uniform.  For every odd prime power
\(q\ge7\),
\[
C_\Gamma(q)=[q+1,5,q-5]_q,\qquad
C_\Gamma(q)^\perp=[q+1,q-4,4]_q;
\]
both Singleton defects are always two.  The dual RS endpoint is
\(R_{q-7}\), so it equals the lower Sarkisov module \(R_4\) uniquely when
\(q=11\); residue duality then exchanges degrees \(4,6\) and fixes degree
\(5\).  Geometrically, the omitted \(t^2,t^4\) coordinates are the
second-jet lines at the two torus-fixed points, with centered weights
\(2,-2\).  Their omission gives vanishing sequence
\((0,1,3,5,6)\) at both points and raises the two tangent contacts from
order two to order three.  Kuznetsov--Prokhorov identify precisely those
two 3-tangent lines as the complete Reid-pagoda flopping locus.  Thus the
two code defects, missing weights, jet gaps, and flop components are one
pair of objects.  The remaining categorical gate is a
base-change-compatible Rees-algebra construction from the two jet quotient
lines.

C682's Klein \(E_8\) operator-algebra gate is resolved through the first
non-multiplicity-free McKay weight.  For the normalized third
transvectant and its positive Fischer adjoint, the first two return words
saturate the full binary-icosahedral commutants in degrees \(6,12,18\):
\[
\mathbf C^2,\qquad \mathbf C^4,\qquad
\mathbf C^3\oplus M_2(\mathbf C).
\]
At degree eighteen their commutator has rank eight on the doubled
four-vertex; the exact positive spectrum starts with singular value
\(30\sqrt7/551\).  The separate \(SL_2\)-apolar adjoint refines the
Mukai--Umemura orbit picture: transvectant rank stays four on all three
orbits, but the apolar return is a nonzero scaled projector on the open
orbit and vanishes on both boundary orbits.  Kramer's generalized Casimir
has rank-eight commutator with the first return at degree eighteen, ruling
out a polynomial identification.  The exact proof, primary certificate,
independent replay, source-depth boundary, and mystery ledger are in
`notes/2026-07-28-c682-klein-e8-operator-algebra.md`.  The next \(E_8\)
gate was all-weight commutant saturation or its first failure.

That gate now closes negatively at the first actual obstruction.  The two
shortest returns saturate every integer weight through \(21\), but at weight
\(22\)
\[
\operatorname{Sym}^{22}|_{2.A_5}
\simeq3^{\oplus2}\oplus5^{\oplus2}\oplus3'\oplus4
\]
has commutant dimension ten and return-algebra dimension eight.  This is a
failure of the full graded corner, not only the two-return generating set:
the doubled \(3\) has adjacent multiplicities \(0,2,1\) in weights
\(16,22,28\), so every downward excursion vanishes and every upward
excursion factors through one multiplicity line.  Thus all closed words act
through \(\operatorname{span}\{I,A^\dagger A\}\) on that block and cannot
generate \(M_2\).  Exact rational closure through weight \(22\), two
independent modular replays, the general bottleneck lemma, and the mystery
ledger are in
`notes/2026-07-28-c682-klein-e8-first-failure.md`.  The next \(E_8\)
`ej` pass identifies the two degree-\(22\) \(3\)-covariants as
\(H_{20}\operatorname{Sym}^2\) and
\(\Phi_{12}\operatorname{Pol}_2(\Phi_{12})\).  The dark line is the exact
\(5/11\) graph killed by \(\Delta\), while the bright target is
\(\operatorname{Pol}_2(T_{30})\).  The full Molien-numerator audit proves
that weight \(22\) is the unique all-weight bottleneck of local type
\(0,m,1\).  Primitive normalization turns the dark coupling into
\(110=2\cdot5\cdot11\); ordinary second polars vanish modulo \(11\) while
the primitive Hessian survives, isolating a concrete divided-power bridge
question without yet identifying C651's finite map.  The next \(E_8\)
frontier has now closed for the complete \(3\)-covariant block.  Over
\(\mathbf Q[F,h]\) it is free on degrees \(2,10,12,18,20,28\), and
\(\mathcal D=(\,\cdot\,,F)_3/132\) is a primitive integral
\(6\)-by-\(6\), order-three Weyl operator with complete off-diagonal
\(3+3\) support.  Its degree-\(22\) row is the Koszul map
\(100(-\partial_h,\partial_F)\), so the dark line is \(hg_2+Fg_{10}\).
All principal entries share
\[
p=2F\xi^3+5h\xi^2\eta-8000F^3\eta^3,
\qquad
\det\sigma_3(\mathcal D)=-10^6p^6t^6,
\]
where \(t^2=1728F^5-h^3\).  Thus the characteristic locus has exactly the
cotangent cubic and Klein branch components.  The exact presentation,
two-prime replay, proof, and mystery ledger are in
`notes/2026-07-28-c682-klein-e8-free-covariant.md`.  The next \(E_8\)
frontier is to identify \(p\) intrinsically and test whether the other eight
McKay blocks share it, then use the finite matrices to classify all later
corner failures.

The bounded C682 literature audit subtracts two apparent novelty claims.
Suter prints the exact \(3\)-node numerator
\(t^2+t^{10}+t^{12}+t^{18}+t^{20}+t^{28}\), and the McKay module is a
classical maximal-Cohen--Macaulay covariant module.  More decisively, direct
multiplication of the principal blocks gives
\[
AB=BA=-100(h^3-1728F^5)I_3,
\]
so they lie in the classical \(E_8\) matrix-factorization classification.
The surviving paper candidate is that the primitive third transvectant
realizes this factorization as its principal symbol, with common scalar
cubic \(p\), and that its return algebra first fails at the degree-\(22\)
Koszul line.  No predecessor for that combined result was located in the
quick pass, but source-deep priority closure remains open.  The exact
claim disposition, read depths, cache hashes, and uncovered literature are
in `notes/2026-07-28-c682-klein-e8-literature-audit.md`.  The next audit gate
was an explicit graded gauge equivalence with the tabulated length-three
\(E_8\) factorization.

That gate is now closed.  Under the rational base change
\(Y=-h/12,\ Z=F\), compatible degree-zero gauges identify C682's two
principal blocks with the unprimed tabulated three-node pair
\((\psi_3,-172800\phi_3)\).  The bases have degrees
\((2,10,18)\) and \((12,20,28)\), both maps have degree \(30\), and the
potential has degree \(60\).  The equivalence is defined over
\(\mathbf Z[1/30]\), so it survives modulo \(11\); prime \(11\) remains an
operator/lattice issue rather than a matrix-factorization obstruction.  The
exact proof, symbolic certificate, independent two-field replay, and mystery
ledger are in
`notes/2026-07-28-c682-klein-e8-graded-gauge.md`.  The next \(E_8\) gate is
the source-deep invariant-differential-operator audit, with the mod-\(11\)
divided-power comparison to C651 as the arithmetic branch.

That audit and arithmetic branch are now closed.  Dixmier's 1992
full-text paper is the direct predecessor for binary-polyhedral
transvectants, including the exact Klein dodecic and isotypic vanishing;
Olver--Sanders supplies the full omega-process/operator background.
Neither source contains C682's finite Weyl realization, scalar-symbol
\(E_8\) factorization, or degree-\(22\) Koszul failure, so the combined
claim survives with “to our knowledge.”  At \(11\), the primitive operator
is exactly the Bockstein/Hasse transvectant
\[
\overline{\mathcal D}(f)=
\sum_{i=0}^3(-1)^i\frac{i!(3-i)!}{2}
\partial_X^{[3-i]}\partial_Y^{[i]}f
\left(\frac{\partial_X^{[i]}\partial_Y^{[3-i]}F}{11}\bmod11\right).
\]
On \(\operatorname{Sym}^6\) it is \(9\) times the primitive rank-four
matrix.  The proposed marked C651 bridge closes negatively: for the
standard order-\(60\) subgroup, all three generator defects have rank four,
and the primitive image is disjoint from the unique equivariant target
four-space.  Multiplicity one therefore cannot fix a nonexistent scalar.
The closeout computes the cause: each defect is exactly the third
transvectant with
\((\det(g)F(g^{-1}z)-F)/11\bmod11\), the mod-\(121\) lift cocycle of the
stored C651 generator.  The subsequent `tt` pass repairs the incompatibility:
for
\[
K=10X^{10}Y^2+5X^9Y^3+7X^8Y^4+8X^7Y^5+2X^6Y^6+
3X^5Y^7+7X^4Y^8+6X^3Y^9+10X^2Y^{10},
\]
the divided operator attached to \(F+11K\bmod121\) is fully
\(A_5\)-equivariant and the marked source-to-target map is scalar \(5\).
The correction is unique modulo
\(\langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle\), whose ordinary third
derivatives vanish modulo \(11\).  The `ej` pass identifies this ambiguity
intrinsically as \(V^{(1)}\otimes V\), simultaneously the complete
right-slot kernel of \((\,\cdot\,,K)_3\) and the raw infinitesimal
\(GL_2\)-orbit of the Dickson form.  Hence the repair is a canonical class
in the nine-dimensional quotient
\(\operatorname{Sym}^{12}/(V^{(1)}\otimes V)\).
The source records, exact certificate, independent replay, and mystery
ledger are in
`notes/2026-07-28-c682-invariant-operator-divided-power.md`.  The next
\(E_8\) mathematical frontier is the intrinsic meaning of \(p\) and the
other McKay blocks; the arithmetic frontier is now a conceptual
mod-\(11^3\) test for an \(11\)-adic tower of the corrected lift.

That arithmetic frontier is now positive.  A determinant-one Hensel lift
of the marked binary \(A_5\), normalized invariant dodecic modulo
\(11^3\), and independently replayed divided transvectant give an
equivariant operator modulo \(11^2\).  The first correction is the
previous \(K\)-class, differing only by \(4XY^{11}\) in the declared
Frobenius gauge; the second digit is explicit.  The marked scalar is
\(115\bmod121\), and a target-line rescaling congruent to one restores
the scalar \(5\).  The rank-five smooth presentation gate and exact
Reynolds averaging for \(11\nmid120\) upgrade the finite test to existence
of the full compatible \(\mathbf Z_{11}\)-tower.  The operator
kernel-to-cokernel Bockstein is zero, so no hidden \(11\)-torsion channel
appears: the \(V_4/V_{3'}\) rank-four splitting is flat through modulus
\(121\).  Intrinsically, \([K]\) is the normal direction of the
\(A_5\)-invariant line away from the maximally symmetric Dickson fibre,
modulo its full coordinate-and-scalar tangent space.  A further `ej2`
composition identifies the presentation root itself with the golden
sheet:
\(s=2\operatorname{tr}(ST)+1\) satisfies \(s^2=5\), and its two
mod-\(1331\) values \(1258,73\) reduce to the marked incidence scalars
\(\pm4\).  Thus the corrected tower and incidence cover have the same
quadratic character algebra and \(C_2\)-exchange.  A direct equality of
their tangent classes is ill-typed until the third-transvectant
kernel/annihilator morphism is constructed.  The report, primary
certificate, independent replay, and mystery ledger are in
`notes/2026-07-28-c682-corrected-bridge-mod-1331.md`.  The local lift
equation is closed; its intrinsic relation to the global incidence cover
or golden-fibre integral model remains open.

C682 now closes the marked special-fibre deformation map.  The ordinary
nine-dimensional dodecic normal quotient is insufficient because the
primitive Bockstein operator lies outside the ordinary third-transvectant
image.  Adjoining that one direction gives a ten-dimensional extended
normal space and a homogeneous kernel map to isotropic three-planes.  The
selected line \((1,[K])\) and its exchanger-conjugate map to two distinct
parents whose apolar four-planes meet in
\[
 \langle X^6+6X^4Y^2+6X^2Y^4+Y^6\rangle,
\]
exactly the binary line representing \(xyz\).  The known finite-etale
degree-two theorem makes these the complete marked incidence fibre, with
orientation scalars \(4,-4\).  Conversely, annihilating either parent in
the extended operator space uniquely recovers its normal line.  Thus the
correct bridge is a two-sided kernel--apolar--incidence diagram, not the
ill-typed equality \([K]=d(5J_0)\).  The proof, exact certificate,
independent replay, trust boundary, and mystery ledger are in
`notes/2026-07-28-c682-transvectant-deformation-map.md`.  The remaining
integral question is to globalize this Bockstein extension as a formal
normal-cone or first-jet map over \(\mathbf Z_{11}\).
The subsequent `ej` pass identifies the entire extended normal space with
C651's ten-pair module
\(P_{10}=\mathbf1\oplus V_4\oplus V_5\): the Bockstein coordinate is the
missing radial summand and its all-ones vector is the corrected \(K\)-line.
The exchanger line has a five-point \(A_5/A_4\) orbit of reduced isolated
rank drops.  Intersecting their five parent-annihilator four-spaces with
the fixed one recovers a complete Clebsch frame
\(q_1+\cdots+q_5=0\), with \(q_1=xyz\).

The proposed six-point exhaustiveness statement is now closed negatively,
with a stronger exact replacement.  The full projective rank-four scheme
of the ten-pair pencil is reduced of length \(22\), all of its points are
\(\mathbf F_{11}\)-rational, all kernels are fifth-transvectant-isotropic,
and the kernel map is injective.  It has the explicit split presentation
\[
 \mathbf F_{11}[t,s]/(t^{11}-t,s^2-1)
\]
and \(A_5\)-orbit decomposition \(1+5+6+10\).  The original six points
remain canonical: they are scheme-theoretically exactly the linear section
by \(\mathbf P(\mathbf1\oplus V_4)\), the star-sum subspace of the ten-pair
module.  A further `ej` pass proves that the split coordinate \(s\) is the
canonical invariant quadratic
\[
 7(\sum p_e)^2+9\sum p_e^2+10\sum_{e\sim f}p_ep_f;
\]
its idempotents split the scheme into the two stable length-eleven sheets
\((1+10)\) and \((5+6)\).  Exact Macaulay ranks \(1980/2002\) and \(4983/5005\), invertible
Bockstein multiplication, the explicit \(22\)-point parameterization, and
an independent invariant replay prove exhaustiveness and reducedness.  The
proof and mystery ledger are in
`notes/2026-07-28-c682-rank-four-resolvent.md`.

The target-side question is now closed scheme-theoretically.  In the
anticanonical Plücker carrier
\[
\ker(c_{(\,\cdot\,,\,\cdot\,)_5})
\simeq\mathbf1\oplus\operatorname{Sym}^{12}
\simeq2\mathbf1\oplus V_3\oplus V_4\oplus V_5,
\]
the \(22\) kernel planes are exactly the complementary \(\mathbf P^{10}\)
section obtained by killing the multiplicity-one \(V_3\).  In the frozen
binary basis it is
\[
p_{012}=p_{013}+p_{356}=p_{456}=0.
\]
All \(22\) intersections are transverse.  The restricted Plücker ideal has
Hilbert values \(21,22,22\) in degrees \(2,3,4\), and invariant-coordinate
multiplication is an isomorphism from degree three to four, so the Hilbert
function stays \(22\) and proves scheme-theoretic exhaustiveness directly;
this realizes \((-K_{U_{22}})^3=22\).  The two invariant target coordinates
\(u=5p_{036}+8p_{045}\) and
\(v=10p_{013}+p_{356}\) satisfy \(u^2=v^2\), recover the source sheet by
\(s=u/v\), and split the section into the length-eleven hyperplane halves
\((1+10)\) and \((5+6)\).  The exact certificate, independent replay,
proof boundary, and mystery ledger are in
`notes/2026-07-28-c682-u22-linear-section.md`.  The remaining target-side
gate is to globalize this marked \(\mathbf F_{11}\) section and invariant
pencil over the corrected \(11\)-adic tower or a characteristic-zero
family, then compare \(u/v\) with the local incidence orientation
coordinate.

The formal \(11\)-adic gate is now closed.  The complementary
\(\mathbf P^{10}\) is the kernel of the integral Bockstein contraction
\[
 Q_I=\frac1{11}B_{11}(\pi_{12}(-),I),
 \qquad
 \pi_{12}:\Lambda^3\operatorname{Sym}^6\to\operatorname{Sym}^{12},
\]
and the invariant pencil globalizes as the alternating scalar
\(\epsilon\) together with
\(\eta_I=B_{12}(\pi_{12}(-),I)/11\).  All \(22\) transverse points lift
finite-etale over \(\mathbf Z_{11}\).  Modulo \(121\), the ratio
\(r=(8\epsilon)/(7\eta_I)\) takes four values of multiplicities
\(1,5,10,6\), so the generic pencil separates the four \(A_5\)-orbits
whose reductions collide into the two length-eleven sheets.  On the two
golden incidence parents \(r_+=100,r_-=43\), while
\(\sqrt5=48\bmod121\); the exact orientation coordinate is
\[
 w=\sqrt5\,\frac{2r-r_+-r_-}{r_+-r_-},
 \qquad w=4u/v\bmod11.
\]
The nonzero midpoint \(11\bmod121\) falsifies an uncentered all-order
scalar identity.  The proof, primary certificate, independent reverse-chart
replay, scope boundary, and mystery ledger are in
`notes/2026-07-28-c682-u22-bockstein-pencil.md`.  The remaining
globalization gate is characteristic-zero and Zariski-local; the local
formal comparison is complete.

C682 now closes that Zariski globalization gate.  On an actual smooth
marked-presentation neighborhood over \(\mathbf Z_{(11)}\), Reynolds
averaging gives the invariant dodecic line and covariance makes the
order-\(11\) and order-\(12\) contractions vanish along the entire Dickson
special orbit.  Flatness therefore divides them algebraically by \(11\),
not merely in the completion.  The transverse \(22\)-section spreads to a
finite-etale degree-\(22\) family, and its tame \(A_5\)-quotient is
finite etale of degree four with stabilizers
\(A_5,A_4,D_5,S_3\).  In the split completion its complete first-order
normal form is
\[
 s^2=1,\qquad b(b-(3+2s))=0,\qquad r=s+11(4+b),
\]
giving the four orbit values \(100,43,54,45\) on orbit sizes
\(1,5,6,10\).  The within-sheet splitting speeds are \(5\) and \(1\);
their ratio \(5\) survives congruent pencil-coordinate changes, whereas
the golden-pair midpoint \(11\) does not.  The exact proof, quotient
certificate, normalization boundary, and mystery ledger are in
`notes/2026-07-28-c682-zariski-bockstein-orbits.md`.

The coordinate-free global gate is now closed.  Pulling the universal
rank-three kernel to the finite-etale \(22\)-section and projectivizing its
apolar rank-four annihilator gives exactly the base change of Hitchin's
incidence bundle.  On the radial/\(A_4\) golden pair, the common annihilator
line descends and identifies the quadratic sheet cover with the pullback of
the incidence Stein cover.  Relative trace sends the centered Bockstein
separator \(b=5e_1+e_6\) to \(5s\) in its deck-odd line:
the orbit degrees force
\(1\cdot5+6\cdot1=11=0\).  Equivalently the two split values of
\(\delta=3+2s\) are \(5,1\) and
\(\operatorname{Nm}(\delta)=5\).  This identifies the tangent factor with
the reduction of the \(5J_0\) discriminant character; the frozen pencil
normalization fixes the literal ratio \(5/1\).  The proof and scope
boundary are in
`notes/2026-07-28-c682-kernel-incidence-morphism.md`.  The remaining
geometric frontier was a canonical flattening of the operator-side kernel
map across non-constant-rank degenerations or a classical moduli meaning
for the \(D_5/S_3\) branches.

The classical moduli frontier is now closed.  The six \(D_5\) kernels are
the nonradial common-fivefold-axis mates of the marked icosahedron; their
common-annihilator pencils are exactly the exceptional Schlaefli six on the
Clebsch cubic surface.  The ten \(S_3\) kernels are the opposite-face-axis
mates over the centered pentahedral edge points
\(q_\alpha+q_\beta\), not the adjacent Eckardt differences
\(q_\alpha-q_\beta\).  Thus the complete \(1+5+6+10\) section is the
maximal-subgroup incidence star of a marked icosahedron.  Exact
reconstruction and an independent apolar replay agree.  The proof, source
boundary, and mystery ledger are in
`notes/2026-07-28-c682-incidence-moduli.md`.  The remaining geometric
frontier is the canonical flattening or a single characteristic-zero
correspondence producing all three \(A_4,D_5,S_3\) mate components
intrinsically.

C682 now supplies that characteristic-zero correspondence.  For
\(G=\operatorname{PGL}_2\), a marked \(A_5=A<G\), and
\(H=A_4,D_5,S_3\), the ambient normalizer doubles \(H\):
\[
 N_G(H)=S_4,D_{10},D_6,\qquad N_G(H)/H=C_2.
\]
The unique nontrivial coset therefore defines the symmetric correspondence
\(G/H\rightrightarrows G/A\), and the diagonal plus its three components
has degree \(1+5+6+10=22\).  Equivalently, every maximal subgroup
\(H<A\) lies in exactly two icosahedral subgroups: the marked one and its
unique mate.  This selects the distinguished \(D_5\) point from the
common-axis curve without Bockstein input and descends with the rational
icosahedral homogeneous space.  Exact \(\mathbf F_{11}\) enumeration
proves that its finite shadow is precisely the existing reduced four-orbit
section.  An `ej` upgrade cuts out the finite \((6_5,10_3)\) incidence
intrinsically: a \(D_5\) kernel and an \(S_3\) kernel are incident exactly
when their three-planes meet in dimension one.  The theorem, proof,
certificate, independent replay, scope boundary, and mystery ledger are in
`notes/2026-07-28-c682-maximal-subgroup-mates.md`.  The remaining geometric
question from that report was an operator realization and a natural source
for the complementary Schläfli six.

That operator and complementary-six gate is now closed.  Pulling the
ordinary rank-four third-transvectant map
\(F\mapsto T_F=((\,\cdot\,,F)_3)\) along the maximal-subgroup mate
correspondence realizes all four characteristic-zero components.  On the
\(D_5\) component, a mate pair has
\(U_F\cap U_{F_i}=\langle q_i^3\rangle\).  If
\(\mathcal T_i=q_i^2\operatorname{Sym}^2\) is the tangent plane to the
cubic Veronese there, then
\[
 E_i=V_F\cap\mathcal T_i=V_F\cap V_{F_i},
 \qquad
 E_i'=V_F\cap\mathcal T_i^\perp .
\]
The second cut is exactly Hitchin's pencil of cubics singular at the
\(i\)-th axis.  Over \(\mathbf Q(\zeta_5)\), the six axes
\(XY\) and \(X^2+bXY-b^2Y^2\), \(b^5=1\), give the full double-six
intersection matrix: lines in either row are pairwise skew, while
\(E_i\) meets \(E_j'\) exactly for \(i\ne j\).  Thus the complementary
six is a functorial apolar-polar companion of the \(D_5\) operator branch,
not a second mate component and not merely an externally imposed outer
automorphism.  The exact characteristic-zero certificate and independent
two-prime replay are in
`notes/2026-07-28-c682-operator-schlafli.md`.
C682 now closes the characteristic-zero \(D_5\)--\(S_3\) incidence
frontier with a necessary correction.  The literal finite kernel-rank
equation does not lift: all sixty ordinary characteristic-zero kernel pairs
are transverse.  Instead their normalized apolar cross-Gram invariant takes
exactly
\[
 \lambda_\pm=(54781\pm24288\sqrt5)/820125.
\]
Each golden level is one thirty-edge \((6_5,10_3)\) design, and Galois
conjugation exchanges it with the complementary design.  Equivalently the
centered invariant is exactly \(\pm\sqrt5\), so the incidence choice is the
golden torsor itself.  Since \(24288=11\cdot2208\), the levels coalesce at
\(5\) modulo \(11\) and their divided centered first digits are
\(\pm5\); this explains why the finite shadow is recovered by the
Bockstein operator rather than ordinary reduction.  The exact
characteristic-zero certificate, two-prime independent replay, proof, and
mystery ledger are in
`notes/2026-07-29-c682-d5-s3-kernel-incidence.md`.
The common-marking sign is now fixed. Map
\(a=\operatorname{diag}(\zeta_5^2,1)\) and its displayed compatible
involution to the frozen stored \((5,2,3)\)-generator pair. Transporting all
six \(D_5\) and ten \(S_3\) stabilizers then identifies the stored
mod-\(11\) matrix exactly with the \(\lambda_+\) fibre, with
\(\sqrt5=4\). All five compatible involutions give the same sign, while
the outer order-five-class swap gives the complementary \(\lambda_-\)
fibre. The exact certificate, compact replay, convention audit, and mystery
ledger are in `notes/2026-07-29-c682-common-marking-sign.md`. The remaining
mysteries are a vector-bundle extension of the cross-Gram separator over the
compactification, a global row-swap involution, and the minimal integral
base.

The boundary extension is now exact, with a necessary change of target. If
\(g_D,g_S\) are the two self-Gram determinants and \(c\) is the cross-Gram
determinant of the tautological kernel bundles, then \(c^2\) and \(g_Dg_S\)
are sections of one line bundle and satisfy
\[
 (820125c^2-54781g_Dg_S)^2
 =5\cdot24288^2(g_Dg_S)^2.
\]
The saturated graph coordinate \([c^2:g_Dg_S]\) extends on the
normalization of both mate-component closures with values
\([\lambda_\pm:1]\). It cannot descend to the coarse kernel-pair boundary.
Under \(\operatorname{diag}(1,t)\), the unique divisor \(D_5\) kernel and
all ten closed \(S_3\) kernels have the same limiting pair
\((U_{\mathrm{div}},U_{\mathrm{cl}})\), yet five pairs have each golden
value. The projectively normalized determinant orders are \(10,12,11\),
so the ratio has valuation zero while all three Gram determinants vanish.
The exact proof, certificate, independent two-field replay, and mystery
ledger are in `notes/2026-07-29-c682-boundary-cross-gram.md`.

The normalized-graph row-swap gate is now closed. A \(D_5\) row contains one
Sylow-five subgroup; its two pairs of nonidentity generators
\(\{g,g^{-1}\}\) and \(\{g^2,g^{-2}\}\) belong to the two \(A_5\)
five-cycle classes and trace complementary pentagon-side and
pentagram-diagonal sets on the ten \(S_3\) edge labels. In the pentahedral
Clebsch marking these are exactly the five Eckardt points on \(E_D\) and the
complementary five on its polar companion \(E_D'\). Thus the apolar-polar
row swap exchanges the same two size-thirty diagonal \(A_5\)-orbits as the
golden deck involution. Equality on the dense homogeneous locus extends
uniquely over the normalized saturated graph; no coarse kernel-pair
involution is asserted. The proof, exact certificate, independent group
replay, and mystery ledger are in
`notes/2026-07-29-c682-normalized-graph-row-swap.md`.

The integral frontier is now closed. The correct dodecic lattice is the
\(11\)-elementary \(SL_2\)-stable neighbor
\[
 \langle e_0,e_1,11e_2,\ldots,11e_{10},e_{11},e_{12}\rangle .
\]
Its primitive third-transvectant tensor has rank four at the open,
divisor-boundary, and closed-boundary representatives in every
characteristic outside \(2,3,5\), including \(7\) and \(11\). Combining
the \(\mathbf Z[1/10]\) Mukai--Umemura model with the perfect apolar
polarity gives the minimal base \(\mathbf Z[1/30]\); \(2,5\) are
geometrically forced and \(3\) is forced by the radical of the degree-six
apolar form. The raw inverse annihilator equations gain one torsion
direction at the two characteristic-\(7\) boundary orbits, but the flat
graph retains the unique integral line. The normalized golden cover
remains good at \(11,23\), although its cross-Gram scalar values coalesce
at both primes because \(24288=2^5\cdot3\cdot11\cdot23\). The exact proof,
certificate, independent replay, and mystery ledger are in
`notes/2026-07-29-c682-minimal-integral-base.md`.

C682's remaining Platinum track is:

1. **QG:** prove that the generic fibre of the rate-half MDS-code to
   stabilizer-AME functor is exactly a monomial/Gale orbit.  Code duality
   is Gale association and local Fourier transform identifies the two
   equal-phase states; the new content must be the converse fibre theorem.

The independent Gold-to-Platinum fallback E3 classifies codes whose
deep-hole/legal-extension transform is a rational normal curve or
minimal-degree variety.  At \(q=11\), Clebsch simultaneously has the
smallest legal extension port \(12\) (next \(16\)), largest projective
stabilizer \(60\) (next \(12\)), least containing degree \(2\) (next
\(4\)), and discrepancy zero (next \(12\)); its minimum port is itself
the complete conic/GRS object.  The all-size full-conic conjecture says
only the \(\mathbf F_5\) frame and \(\mathbf F_{11}\) Clebsch hexagon
occur.  The report records exact gates and falsifiers.  The highest-EV TR
follow-ups are a source-deep priority audit and a divided-power/Weyl
integral model: naive reduction of the ordinary-derivative tensor has
extra degeneracies at \(3,7,11\) and does not yet recover the sharp
Mukai--Umemura bad-prime set \(2,5\).  Independently, the next QG gate is
the generic \(m=3\) local-symplectic component test.

The characteristic-\(23\) divided-separator mystery is now closed.  If
\(\chi=(54781+24288\sqrt5)/820125\), then locally
\[
 \mathbf Z_{23}[\chi]
 =\mathbf Z_{23}+23\mathbf Z_{23}\sqrt5
 \subset\mathbf Z_{23}[\sqrt5].
\]
This index-\(23\) order has conductor \(23\), dual-number special fibre,
and inert étale normalization \(\mathbf F_{529}\).  The divided trace-zero
coordinate \((820125\chi-54781)/23\) reduces to
\(-2\sqrt5\), satisfies \(T^2+3=0\), and is exchanged with its negative by
Frobenius.  It is exactly the missing normalization generator.  Thus the
primes \(11\) and \(23\) express one conductor phenomenon with split and
inert special fibres respectively; only at \(11\) does the divided
coordinate select a rational incidence sheet.  Globally over
\(\mathbf Z[1/30]\), the scalar image is the conductor-\(253\) order
\(R+253R\sqrt5\), so these are exactly its two normalization defects.
The exact proof, compact
certificate, independent finite-algebra replay, and mystery ledger are in
`notes/2026-07-29-c682-characteristic-23-divided-separator.md`.

The intrinsic Klein \(E_8\) symbol gate is now closed.  On
\(R=\mathbf Q[F,h]\), the odd output of the primitive third transvectant
defines the scalar radial operator
\[
 \frac{((\,\cdot\,,F)_3/132)}t
 =20F\partial_F^3+50h\partial_F^2\partial_h
  -80000F^3\partial_h^3+55\partial_F^2.
\]
Its principal symbol is \(10p\).  On the primitive three-node basis,
\(A/10,B/10\) are exactly multiplication by \(t\), not merely
gauge-equivalent factorization matrices.  The top Leibniz term therefore
gives the uniform theorem
\(\sigma_3(\mathcal D|_{M_\rho})=10p\,m_t\) on every McKay covariant block:
one radial cubic selects all nine classical \(E_8\) factorizations.  Its
binary-cubic discriminant is \(-4\,000\,000F^3t^2\).  The exact proof,
certificate, two-prime independent replay, and mystery ledger are in
`notes/2026-07-29-c682-intrinsic-e8-symbol.md`.

The later McKay-corner sweep is closed through degree \(72\), with an
explicit all-weight boundary.  Put
\[
 U_1=\Delta^\dagger\Delta,\qquad
 U_2=(\Delta^2)^\dagger\Delta^2,\qquad
 L_1=\Delta_{n-6}\Delta_{n-6}^\dagger.
\]
For every \(0\le n\le72\), \(n\ne22\), these three local returns generate
the full \(2.A_5\)-commutant.  The upward pair alone has fifteen later
deficits, at
\[
 26,30,31,41,42,46,50,51,60,61,62,66,70,71,72,
\]
and every one is repaired by \(L_1\).  At degree \(22\), \(L_1\) has no
\(3\)-component because the lower multiplicity is zero, so the exact
\(8<10\) bottleneck persists.  Modular rank at two large primes and exact
rational checks at the first three repairs certify the result.  No
all-weight uniqueness claim is made.  The report, generator, replay, and
mystery ledger are in
`notes/2026-07-29-c682-later-mckay-corners.md`.

The all-weight corner frontier is now reduced to finite symbolic families.
All fourteen strict multiplicity peaks in degrees \(73\) through \(112\)
saturate at two large primes, hence in characteristic zero.  Combined with
the preceding certificate, this checks all twenty-one representatives in
\(60\le n<120\).  The Kostant numerators prove that the eventual strict
peaks are \(60\)-periodic and occur only in the \(1,2,3,3'\) modules, at
residues modulo \(20\)
\[
 \{0,12\},\quad\{1,11\},\quad\{2,10\},\quad\{6\},
\]
respectively.  This does not make the return matrices periodic: the exact
remaining gate is nonvanishing of twenty-one mixing-minor families along
\(n=n_0+60q\), together with an off-peak exclusion.  The report,
certificate, replay, and mystery ledger are in
`notes/2026-07-29-c682-all-weight-corner-frontier.md`.

The global two-sided defect route is now reduced to its exact structural
core.  For
\[
 K_n=\ker(\Delta_n,\Delta_{n-6}^\dagger),
\]
the only nonzero degrees through \(300\) are
\[
0,1,2,6,10,11,12,20,21,22,32,40,52.
\]
Two large primes agree on the complete range, every exception is checked
exactly over \(\mathbf Q\), and degree \(22\) is the unique defect whose
dimension can occupy a repeated isotypic summand: the doubled standard
\(\mathbf3\).  A noncircular propagation lemma proves that a full lower
hyperplane plus a nonzero self-adjoint cross block generates the next full
corner.  At the ambient coefficient level, all three Klein shifts are
congruent modulo \(5\), so \(Q_n\) splits into five explicit tridiagonal
chains.  The all-weight gate is therefore the common-boundary continuant
for those chains, together with upper-support mixing at the
codimension-two peak geometry.  The plan, exact certificate, independent
replay, proof, `ej`/`tt` closeout, and mystery ledger are in
`notes/2026-07-29-c682-global-defect-module-plan.md` and
`notes/2026-07-29-c682-global-defect-first-pass.md`.

The finite defect boundary is now replaced by an all-weight theorem.  On
each of the five coefficient chains, the upper and Fischer-adjoint lower
recurrences at centers \(j\) and \(j+5\) give a local four-by-four
determinant.  At \(j=5,6,7,8,9\), each determinant factors into linear
roots at degrees at most \(52\) and one nonlinear integer polynomial with
no root modulo a small prime.  Hence all five determinants are nonzero for
every integer \(n>52\), force four initial coefficients to vanish, and
propagate zero to the right boundary.  Therefore
\[
\ker(\Delta_n,\Delta_{n-6}^\dagger)=0
\quad\text{for every }n>52.
\]
The complete exceptional list is
\(0,1,2,6,10,11,12,20,21,22,32,40,52\); degree \(22\) is the unique
repeated-isotypic defect in all weights.  The exact standard-library
factorization certificate, separately implemented transvectant/Fischer
replay, proof, `ej`/`tt` closeout, and mystery ledger are in
`notes/2026-07-29-c682-all-weight-defect-theorem.md`.  The remaining
full-corner gate is upper-support mixing at codimension-two peaks plus
off-peak propagation.

The maximal-rank/multiplicity-induction route has now been executed to its
first exact obstruction.  A two-prime sweep through degree \(300\), with an
alternate-prime replay, finds that every McKay block of \(\Delta_n\) has
maximal rank throughout the frontier.  The finite-dimensional lemma is
also proved: full supported algebras on two spanning nonorthogonal
subspaces generate the full matrix algebra.  Nevertheless the proposed
outer induction is circular.  In the trivial module, degrees
\[
118,124,130,136,142,148,154,160
\]
have multiplicities
\[
1,2,2,2,2,2,2,3.
\]
Square maximal-rank edges transport fullness within the multiplicity-two
plateau but do not anchor it; its left boundary supplies only a line and
its right boundary has larger multiplicity.  This pattern repeats after
degree \(60\).  The revised highest-EV gate is therefore plateau-entry
mixing in the trivial family \(n=64+60q\), followed by the \(2,3,3'\)
families.  The exact frontier certificate, independent replay, proof,
`ej`/`tt` closeout, and Mystery ledger are in
`notes/2026-07-29-c682-full-corner-induction-audit.md`.

The first unanchored plateau family is now closed.  At every trivial-module
entrance \(n=64+60q\), \(q\ge1\), the first upward return alone mixes the
incoming hyperplane with its missing line.  In the invariant basis
\(F^{2+5j}h^{2+3(q-j)}\), a boundary covector sees only four return
coordinates.  Their degree-\(15\) dependence and the degree-\(3\) incoming
recurrence give one rational mixing scalar; after \(q=r+6\), its numerator
has only negative coefficients and its denominator only positive
coefficients, while \(q=1,\ldots,5\) are exact nonzero witnesses.  The
report, exact certificate, independent two-prime out-of-sample replay,
`ej`/`tt` closeout, and Mystery ledger are in
`notes/2026-07-29-c682-trivial-plateau-controllability.md`.  The next
controllability gate is the \(2,3,3'\) Kostant modules.

The `ej2` pass removes a large artificial recurrence factor from that
witness.  The raw degree-\(33\)-over-degree-\(21\) expression has a common
degree-\(18\) factor; the reduced scalar has degrees \(15\) and \(3\).
After \(q=r+6\), both reduced polynomials are strictly
ultra-log-concave and exactly real-rooted.  Sturm arithmetic places all
fifteen numerator roots and all three denominator roots strictly at
\(q<1\), upgrading the integer-family proof to nonvanishing on the full
real ray \(q\ge1\).  The remaining mystery is the module-uniform
Pólya-frequency or total-positivity mechanism suggested by this pattern.

The `ej3` Sturm refinement shows that the continuous wall is sharp.  The
reduced numerator has one root in \(0<q<1\), thirteen in
\(-2<q<-1\), and one in \(-3<q<-2\); the denominator has one pole in
\(-2<q<-1\) and two in \(-3<q<-2\).  Thus \(q\ge1\) is the maximal
root-free nonnegative ray.  The \(1|13|1\) zero clustering points more
specifically toward a finite Jacobi-matrix or orthogonal-polynomial model
for the boundary transfer.

The `tt` pass sharpens and limits that interpretation.  The reduced
denominator is exactly
\((10q+17)(10q+22)(10q+27)/2\), so the witness is a degree-\(12\)
polynomial bulk term plus a proper three-pole boundary correction.  The
three exact residue signs are \(-,+,-\), ruling out a positive
Stieltjes or diagonal-Weyl model.  The correct target is the
symmetrizable three-term transfer pencil already present in the boundary
annihilator, with the witness as an off-diagonal Green function.  Its
block-Jacobi analog is the proposed uniform route for \(2,3,3'\).

The scalar pencil is now constructed canonically, with one correction to
that preliminary interpretation.  For the reduced pair \(W=N/D\), the
Bezout form \(\operatorname{Bez}(N,D)\) symmetrizes the numerator companion
and has exact inertia \((8,7,0)\); this is the intrinsic signed boundary
structure.  Unsigned wall counts do not follow from that indefinite form
alone, which retains only oriented Cauchy data.  The positive Hermite forms
\(\operatorname{Bez}(N,N')\) and \(\operatorname{Bez}(D,D')\) supply the
missing half: exact endpoint inertias derive the consecutive zero and pole
counts \(1|13|0|1\) and \(2|1|0|0\), independently of the scalar polynomial
Sturm chain.  The exact construction, replay, `ej`/`tt` closeout, and
Mystery ledger are in
`notes/2026-07-29-c682-signed-boundary-pencil.md`.  The \(2,3,3'\) target
is correspondingly sharpened to block boundary Bezout symmetrizers plus
positive block Hermite forms.
