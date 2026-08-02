# C756 — coordinate-free upgrades and retained roadmap

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research architecture,
no manuscript edits

## Verdict

Four coordinate-heavy parts of C756 now have intrinsic formulations:

1. the exceptional missing-set curves are canonical kernel lines in a
   projective evaluation map;
2. the Moore quotient is the residual divisor of the chord arrangement on a
   spare line;
3. the divisibility (E_P^2\mid(A,B)) is vanishing of the relative first
   subresultant section along twice that residual divisor; and
4. a saturated-external configuration is intrinsically a perfect matching of
   the conic carrying a quadratic-character two-graph.

The first three are not merely coordinate-free restatements of objects: their
factorizations and multiplicities are now statements about divisors or bundle
sections and therefore survive every projective change of coordinates.  The
fourth packages the completed saturated-external proof without its temporary
fixed-edge and cyclic-coordinate normalizations.

The saturated-internal Cartier/torus reformulation, the dual-node
near-transversal, and the prefix-container state space still require real
design choices.  Their exact interfaces are frozen in §6 so a fresh session
does not need to reconstruct them.

## 1. Common projective ambient space

Let (V) be a two-dimensional vector space over (mathbf F_q), and write

\[
  \Pi=\mathbf P(\operatorname{Sym}^2V).
\]

The discriminant cuts out a nonsingular conic
(C\subset\Pi), canonically isomorphic to (mathbf P(V)) by the Veronese
map.  Polarization of the discriminant gives the conic polarity

\[
  \perp_C:\Pi\longrightarrow\Pi^\vee.
\]

This is the natural ambient language for all C756 branches.  A point of
(Pi) is a binary quadratic up to scale, the external/internal type is its
discriminant square class, chord poles are obtained from (perp_C), and
(operatorname{PGL}(V)) is exactly the conic-preserving projective group.

## 2. Missing-set curves as canonical kernel lines

For an arc (A\subset\Pi(mathbf F_q)\setminus C(mathbf F_q)), let

\[
  \mathcal L_A=\bigcup_{\{a,b\}\subset A}\overline{ab}
\]

be its chord arrangement, and give the finite missing set

\[
  S_A=\bigl(\Pi(\mathbf F_q)\setminus C(\mathbf F_q)\bigr)
      \setminus\mathcal L_A(\mathbf F_q)
\]

the reduced subscheme structure.  Define the degree-(d) missing-set kernel

\[
 K_d(A)=\ker\!\left(
 H^0(\Pi,\mathcal O_\Pi(d))
 \longrightarrow H^0(S_A,\mathcal O_{S_A}(d))
 \right).                                                   \tag{CF1}
\]

This construction is functorial:

\[
  K_d(gA)=g_*K_d(A)\qquad(g\in\operatorname{PGL}(V)).       \tag{CF2}
\]

Consequently, whenever (dim K_d(A)=1), its zero curve is determined by the
pair ((C,A)) without coordinates.  The exact C756 extraction proves

\[
 \begin{array}{c|ccc}
 q&13&29&31\\ \hline
 d&4&7&6\\
 \dim K_d(A)&1&1&1\\
 \operatorname{Stab}_{\operatorname{PGL}(V)}K_d(A)
   &S_3&D_{10}&A_5.
 \end{array}                                                \tag{CF3}
\]

Thus all three kernel curves—not only the (q=31) sextic—are already
coordinate-free.  The larger degree-(d) stabilizer-character spaces at
(q=13,29), of dimensions four and six, show why no analogue of the
six-axis formula is forced by the stabilizer alone: the evaluation kernel in
(CF1) supplies the extra canonical condition.

For (q=31), let (O_6\subset\Pi\setminus C) be the unique six-point orbit
of the (A_5) stabilizer.  If (Q) is any equation of (C), then in the
frozen coefficient normalization the curve has the intrinsic equation

\[
 F_A=\prod_{u\in O_6}\operatorname{polar}_Q(u)+5Q^3.       \tag{CF4}
\]

Changing representatives of the six polar lines rescales the first product;
the projective pencil it spans with (Q^3), and the selected member defined
by (CF1), are intrinsic.  The complete finite pencil census and its three
singular parameters are recorded in
notes/2026-08-01-c756-kernel-curves.md.

## 3. The Moore quotient as a residual Cartier divisor

Let (A) be a nonsaturated conic-filling (k)-arc, choose (P\in A), and
let (ell) be a spare external line through (P).  Put
(B=A\setminus\{P\}).  The chord arrangement is the effective divisor

\[
  D_A=\sum_{\{a,b\}\subset A}\overline{ab}
\]

on (Pi).  For (X\in\ell(mathbf F_q)\setminus\{P\}), let (mu_X) be
the number of chords of (B) meeting (ell) at (X).  Covering gives
(mu_X\ge1), and the arc condition says that the corresponding chords form
a matching.

Restriction of Cartier divisors to (ell) gives the exact intrinsic identity

\[
 D_A|_\ell=
 \sum_{X\in\ell(\mathbf F_q)}[X]+(k-2)[P]+R_{P,\ell},      \tag{CF5}
\]

where

\[
 R_{P,\ell}=
 \sum_{X\in\ell(\mathbf F_q)\setminus\{P\}}(\mu_X-1)[X],
 \qquad
 \deg R_{P,\ell}=\binom{k-1}{2}-q=\delta.                 \tag{CF6}
\]

The first term of (CF5) is the rational-point divisor of (ell); in binary
coordinates its canonical section is the Moore form
(U^qV-UV^q).  The factor (L_P^{k-2}) merely adjusts the Moore
multiplicity one at (P) to the actual chord multiplicity (k-1).
Therefore the old polynomial (E_P), or homogeneous
(R_{P,\ell}), is exactly a local equation for the residual divisor in
(CF6).  Complete splitting, defect localization, and the two defect-two
shapes become the intrinsic assertions

\[
 \operatorname{Supp}R_{P,\ell}\subset\ell(\mathbf F_q),
 \qquad
 |\operatorname{Supp}R_{P,\ell}|\le\delta,
 \qquad
 R_{P,\ell}=2[X]\ \text{or}\ [X]+[Y]\quad(\delta=2).      \tag{CF7}
\]

No affine slope coordinate is part of (CF5)--(CF7).  The divisor-valued map

\[
  \ell\longmapsto R_{P,\ell}                              \tag{CF8}
\]

on the pencil of spare lines through (P) is the correct global carrier of
the nonsaturated defect.

## 4. The first subresultant on the incidence ruled surface

The intercept coordinate also has a coordinate-free home.  Let

\[
 \mathscr I_\ell=
 \{(X,m)\in\ell\times\Pi^\vee:X\in m\},
 \qquad
 \pi:\mathscr I_\ell\to\ell.                             \tag{CF9}
\]

This is a (mathbf P^1)-bundle: its fibre over (X) is the pencil of lines
through (X).  Every point (b_i\in B) defines a canonical section

\[
 \sigma_i(X)=(X,\overline{Xb_i}),                         \tag{CF10}
\]

and their sum

\[
 \mathscr D_B=\sum_i\sigma_i                              \tag{CF11}
\]

is a relative degree-(|B|) divisor on (mathscr I_\ell).  Two sections
(sigma_i,sigma_j) meet over (X) exactly when the chord (b_ib_j) meets
(ell) at (X).  Because (B) is an arc, every collision is a transverse
pair collision in the fibre; if (mu_X>1), the (mu_X) colliding pairs are
disjoint and occur at distinct points of (pi^{-1}(X)).

Choose any local base parameter (T) at (X) and any fibre coordinate (U).
Then (CF11) has a local equation

\[
 \mathcal H(U,T)=\prod_i(U-\rho_i(T)).                    \tag{CF12}
\]

The relative first subresultant of (mathcal H) and its vertical derivative
is a section (mathfrak s_1) of a rank-two coefficient bundle on (ell).
In the chosen trivialization it is

\[
  \mathfrak s_1=A(T)U+B(T).                               \tag{CF13}
\]

Equivalently, its coefficient ideal is the relevant determinantal/Fitting
ideal of the relative Sylvester map for
((\mathcal H,\partial_U\mathcal H)).  This description is independent of
both local coordinates; changing (T) or (U) only changes the
trivialization of the base and coefficient bundles.

At a fibre with (mu_X) collision pairs, every Vandermonde minor contributing
to (CF13) retains at least (mu_X-1) transverse collision factors.  The
subresultant uses their squares.  Hence

\[
 \operatorname{ord}_X\mathfrak s_1\ge2(\mu_X-1),          \tag{CF14}
\]

and globally

\[
 \boxed{\mathfrak s_1\in
 H^0\!\left(\ell,\mathcal E_1(-2R_{P,\ell})\right)}.       \tag{CF15}
\]

Here (mathcal E_1) is the rank-two bundle in which the unscaled first
subresultant lives.  Formula (CF15) is precisely the coordinate-free content
of

\[
  E_P^2\mid A,B.                                          \tag{CF16}
\]

When (mu_X=1), the fibre of (mathfrak s_1) is nonzero and its linear
factor cuts out the unique colliding line (overline{b_ib_j}) in the pencil
(pi^{-1}(X)).  Therefore (mathfrak s_1) does not vanish along the full
rational-point divisor of (ell): this is the intrinsic reason the Moore
factor cannot divide the first-subresultant coefficients.

This formulation preserves both direction (X) and intercept
(overline{b_ib_j}).  It also makes the proved negative result durable:
after removing (2R_{P,ell}), the remaining subresultant bundle still has
degree (Theta(q)), so no choice of affine coordinates can restore the hoped
(O(\delta)) compression.

## 5. Saturated-external arcs as matching two-graphs

An external point (a\in\Pi\setminus C) has two rational tangent lines to
(C); their contact points form an unordered pair
(e_a=\{x_a,y_a\}\subset C(\mathbf F_q)).  Thus a saturated-external set of
((q+1)/2) points is intrinsically a perfect matching

\[
 \mathcal M_A=\{e_a:a\in A\}
\]

of (C(\mathbf F_q)), or equivalently a fixed-point-free involution of that
projective line.

For two matching edges represented by binary quadratics (f_e,f_{e'}), set

\[
 \epsilon(e,e')=\chi\!\left(\operatorname{Res}(f_e,f_{e'})\right). \tag{CF17}
\]

Rescaling either quadratic changes the resultant by a square, so (CF17) is
well defined.  It is also (operatorname{PGL}(V))-invariant.  Consequently
the pairwise conic-external condition is a quadratic-character two-graph on
the edges of the matching, not a coordinate sign table.

The completed saturated-external theorem can therefore be stated without a
fixed matching edge:

> Classify fixed-point-free involutions of (C(mathbf F_q)) whose matching
> edges form the required resultant-character clique and whose chord-node set,
> under conic polarity, blocks every non-tangent line.

The complete-mapping coordinate, Paley anticommutator, Jacobi collision lemma,
and Hasse bound are proof charts on this intrinsic object.  They do not belong
in its statement.  This repackaging changes no mathematical gate, but it gives
the closed branch a reusable theorem interface.

## 6. Retained coordinate-free roadmap

The following items are deliberately not claimed as completed.  Each entry
records the proposed intrinsic object, the precise missing step, and a stop
condition.

| item | intrinsic formulation to build | missing theorem / stop condition |
|---|---|---|
| saturated-internal double clique | use the norm-one torus (T=\operatorname{Res}^1_{\mathbf F_{q^2}/\mathbf F_q}\mathbf G_m); oriented representatives form a torsor over (T/\{z\sim z^{-1}\}), and coherence is a switching class on two conjugate Paley cliques | prove the only balanced coherent section is the (q=5) frame; stop if the torus formulation merely restates the existing eigenvector equation |
| master-polynomial divisibility | regard (G=\prod_i f_i) as the section cutting out the arc divisor in (Pi); replace the chart derivative by a Hasse derivative or Cartier operator between explicitly named line bundles | construct an equivariant operator whose local expression is (G'^q-(-1)^{(q+3)/2}G'); if no such operator exists without choosing a tangent direction, record that dependence rather than calling the formula intrinsic |
| dual conic-weighted pencil | apply (perp_C) to every chord, obtaining internal nodes on the pencil through (ell^\perp); this is a defect-(delta) near-transversal retaining the ruled-surface fibre point | classify all-internal defect-two near-transversals or derive a bounded-degree norm; stop if the Moore mass again fragments to degree (Theta(q)), as in the completed intercept probe |
| prefix-container classes | treat a prefix as an object of the action groupoid of (operatorname{PGL}(V)) on partial conic-external arcs; label it by secant divisor, point types, pencil multiplicities, cross-ratio/norm cosets, and stabilizer orbit | test all maximum-witness orbits, not one selected witness; stop if equal extension counts split across unboundedly many intrinsic labels |
| (q=13,29) compact orbit products | search inside the four- and six-dimensional stabilizer-character spaces for short sums of polar-orbit products | exposition only: (CF1) is already canonical; stop unless a formula reveals a new incidence interpretation |
| (q=31) classical identification | compare the six-axis pencil under full (operatorname{PGL}(3,31)) and only then run a bounded literature audit | no priority claim from the current computation; stop if the comparison is merely a change of equation |

## 7. Fresh-session state

The cheap coordinate-free work is complete at the level needed by C756:

- use (CF1) for all missing-set curves and (CF4) for the special (A_5)
  sextic;
- use the divisor equality (CF5), never the affine factorization
  (D_P=(T^q-T)E_P), as the primary statement;
- use the ruled surface (CF9) and bundle vanishing (CF15), never raw
  coefficient divisibility, as the primary subresultant statement; and
- state the saturated-external theorem as a matching-two-graph
  classification, with complete-mapping coordinates confined to its proof.

Highest-EV mathematics remains the saturated-internal coherent-double-clique
classification.  Within the nonsaturated branch, the global masked-direction
gap (h\ge1) remains primary and intrinsic prefix labels are the next bounded
diagnostic.  None of the coordinate-free rewrites proves either open gate.

Source reports:

- notes/2026-08-01-c756-nonsaturated-direction-reduction.md;
- notes/2026-08-01-c756-subresultant-moment-obstruction.md;
- notes/2026-08-01-c756-intercept-subresultant-probe.md;
- notes/2026-08-01-c756-saturated-matching-attack.md;
- notes/2026-08-01-c756-kernel-curves.md.

No new computational claim is introduced here.  Equations (CF1)--(CF17) are
human reformulations and local valuation proofs of results already supported
by the cited evidence bundles.

## 8. EJ + TT closeout and mystery ledger

**EJ.**  The ruled-surface construction is the main free gain.  It shows that
the repeatedly lost intercept was not intrinsically absent: direction and
intercept are the base and fibre coordinates of one canonical
(mathbf P^1)-bundle.  The old subresultant already lived there; only its
presentation had projected the geometry into two large coefficient
polynomials.

**TT.**  The useful coordinate-free move is not to erase coordinates from a
formula but to identify the moduli object on which the formula is a section.
That criterion separates the completed upgrades from the roadmap: the kernel
line, residual divisor, ruled-surface subresultant, and matching two-graph now
have named functorial homes; the Cartier operator and prefix state space do
not yet have closed theorem interfaces.

| mystery | status | exact residual gap |
|---|---|---|
| Is the missing-set curve intrinsic? | settled | it is the unique line (mathbf P K_d(A)) in the three extracted cases |
| What is (E_P) without a slope coordinate? | settled | it is the effective residual divisor (R_{P,ell}) in (CF5)--(CF6) |
| What is (A(T)U+B(T)) without (T,U)? | settled | the relative first-subresultant section of the section divisor (mathscr D_B) on (mathscr I_ell) |
| Why exactly (E_P^2)? | settled | each excess matching collision remains in every relevant Vandermonde minor and the subresultant uses its square |
| Can the saturated-internal derivative be made intrinsic? | open | construct the line-bundle/Hasse--Cartier operator in §6 or prove that the tangent chart is essential |
| Can intrinsic prefix labels explain count compression? | open | requires all maximum-witness orbits and a bounded groupoid invariant catalogue |
| Does coordinate freedom itself improve the full-theorem odds? | settled negatively | it cleans and unifies the carrier but supplies no new obstruction; the two open uniform gates are unchanged |
