# Paper III assertion inventory — "Golden descent and operator realizations of the Clebsch cubic"

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

Sentence-level inventory of every mathematical assertion in
`papers/clebsch-passages/`. Grouped by section in document order. Line numbers
refer to the cited source file at the time of writing. The `external` column
records an attribution made by the paper itself (author/year or key as written);
blank means the paper presents the assertion as its own.

Kinds: definition, main-theorem-clause, proof-step, displayed-identity,
exact-constant, example, verification-claim, literature-attribution.

## Front matter and abstract (`clebsch_passages.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| abs-twist-determined | clebsch_passages.tex:46 | prose (abstract) | The rational twist of Hitchin's degree-two incidence cover over the projective space of rational harmonic cubics is determined. | main-theorem-clause | Hitchin (cover construction) |
| abs-function-field | clebsch_passages.tex:48 | prose (abstract) | The function field of that incidence cover equals \(\Q(\mathbf P(H))(\sqrt{5J_0})\), where \(J_0\) is Hitchin's invariant sextic. | main-theorem-clause | |
| abs-golden-fibre-fixes-5 | clebsch_passages.tex:48-49 | prose (abstract) | The complete golden fibre over the rational point \([xyz]\) determines that the square-class constant is \(5\). | main-theorem-clause | |
| abs-chart-pullback-16 | clebsch_passages.tex:49-50 | prose (abstract) | The Clebsch chart satisfies \(\iota_t^*J_0=16\sigma_3^2\). | displayed-identity | |
| abs-marking-attaches-sign | clebsch_passages.tex:50-51 | prose (abstract) | Fixing the marked bridge datum attaches the chosen deck sign to an order-six conference operator \(C\). | main-theorem-clause | |
| abs-C-squared-5I | clebsch_passages.tex:51 | prose (abstract) | The order-six conference operator satisfies \(C^2=5I\). | displayed-identity | |
| abs-four-descriptions | clebsch_passages.tex:53-55 | prose (abstract) | The oriented cubic has four equivalent descriptions: triangle holonomy, the diagonal of \(*\!\bigwedge^3C\), a commutator Pfaffian, and a cross-golden determinant. | main-theorem-clause | |
| abs-outer-translates-joubert | clebsch_passages.tex:55-56 | prose (abstract) | The six outer translates of the oriented cubic are the signed Joubert coordinates on the Segre cubic. | main-theorem-clause | |
| abs-centered-squares-polar | clebsch_passages.tex:56-57 | prose (abstract) | Centered squares of those translates give the Segre--Igusa polar map. | main-theorem-clause | |
| abs-coordinate-section-clebsch | clebsch_passages.tex:57 | prose (abstract) | A coordinate section of the Segre cubic gives the diagonal Clebsch cubic. | main-theorem-clause | |
| abs-order-six-unique | clebsch_passages.tex:57-59 | prose (abstract) | Order six is the unique nontrivial symmetric conference order whose balanced exchange spectrum is independent of the cut. | main-theorem-clause | |
| abs-aligned-four-sets | clebsch_passages.tex:59-60 | prose (abstract) | Aligned four-sets reconstruct every two-graph on at least seven vertices up to complement. | main-theorem-clause | |
| abs-seven-sharp | clebsch_passages.tex:60 | prose (abstract) | The vertex bound seven in the aligned four-set reconstruction is sharp. | main-theorem-clause | |
| abs-det-minus-three-recovery | clebsch_passages.tex:61-62 | prose (abstract) | Marked determinant-\((-3)\) blocks recover every symmetric conference signing of order at least ten, up to switching and global negation. | main-theorem-clause | |
| abs-sign-comparisons-relative | clebsch_passages.tex:64-65 | prose (abstract) | The sign comparisons are relative to the marked datum and are not an identification of the ambient harmonic representations. | definition (scope) | |
| abs-petersen-embeds | clebsch_passages.tex:66-68 | prose (abstract) | The Petersen \((-2)\)-eigenspace of coefficient vectors on the ten icosahedral face axes embeds as the Clebsch four-space inside degree-six zonal harmonics. | main-theorem-clause | |
| abs-normalized-cubic-value | clebsch_passages.tex:68-69 | prose (abstract) | The normalized spherical cubic restricts to the exact multiple \(-784000\sigma_3/1247103\). | exact-constant | |
| front-msc | clebsch_passages.tex:77-78 | prose | The subject classification of the work is 14G25, 14J30, 20C20, 51E20. | literature-attribution | |

## Section 1, Introduction (`sections/01-introduction.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| intro-H-definition | 01-introduction.tex:3-8 | prose | \(H\) is the kernel of the Laplacian \(\partial_x^2+\partial_y^2+\partial_z^2\) from rational cubics to rational linears, and it is a seven-dimensional \(\Q\)-vector space. | definition | |
| intro-polarization-normalization | 01-introduction.tex:10-13 | prose | The polarization pairing on cubics is normalized by \(\langle p,(a\cdot x)^3\rangle=p(a)\). | definition | |
| intro-pairing-nondegenerate | 01-introduction.tex:14 | prose | The restriction of the polarization pairing to \(H\) is nondegenerate. | proof-step | |
| intro-hitchin-two-configs | 01-introduction.tex:14-18 | prose | Hitchin associates to a general \([f]\in\mathbf P(H)\) two icosahedral six-axis configurations, equivalently two Mukai--Umemura isotropic three-planes \(U\subset H\) with \(f\perp U\). | literature-attribution | Hitchin (HitchinIcosahedron, HitchinBundles) |
| intro-incidence-degree-two | 01-introduction.tex:18-20 | prose | The incidence variety of pairs \(([f],U)\) is generically a degree-two cover of \(\mathbf P(H)\). | proof-step | Hitchin |
| intro-marked-sign-conference | 01-introduction.tex:21-24 | prose | On the six-axis carrier the marked sign determines a conference operator whose Pfaffian, determinant, and middle-exterior shadows give the classical Joubert, Segre, Igusa, and diagonal Clebsch models. | main-theorem-clause | |
| intro-ten-face-axes-gaunt | 01-introduction.tex:24 | prose | On the ten icosahedral face axes the oriented cubic returns as the degree-six Gaunt cubic. | main-theorem-clause | |
| fig-cover-equation | 01-introduction.tex:39-41 | figure 1 caption/box | The finite Stein normalization of Hitchin's cover is given by \(z^2=5J_0\). | displayed-identity | |
| fig-gaunt-integral | 01-introduction.tex:51-53 | figure 1 box | The degree-six harmonic return satisfies \(\frac1{4\pi}\int F_y^3=-\frac{784000}{1247103}\sigma_3(y)\). | exact-constant | |
| fig-branches-compare-only | 01-introduction.tex:62-65 | figure 1 caption | The lower branches of the source--shadow--return scheme compare the chosen sign only; they neither identify the displayed cubics nor define a map between their ambient harmonic spaces. | definition (scope) | |
| intro-J0-normalization | 01-introduction.tex:69-72 | prose | \(J_0\) denotes Hitchin's irreducible invariant sextic with the normalization of the displayed definition preceding his main theorem and the matching final formula of his appendix. | literature-attribution | Hitchin, opening theorem and Appendix final displayed formula |
| intro-V-definition | 01-introduction.tex:74-76 | prose | \(V=\{(y_1,\dots,y_5):\sum_i y_i=0\}\) is the Clebsch four-space. | definition | |
| intro-sigma3-definition | 01-introduction.tex:76 | prose | The invariant cubic on \(V\) is \(\sigma_3(y)=\frac13\sum_i y_i^3\). | definition | |
| intro-Dsigma3 | 01-introduction.tex:79-80 | prose | \(D(\sigma_3)\) denotes the principal open set \(\{\sigma_3\ne0\}\). | definition | |
| intro-J0-section-degree-six | 01-introduction.tex:81 | prose | \(J_0\) is a section of \(\mathcal O_{\mathbf P(H)}(6)\). | proof-step | Hitchin |
| intro-sqrt-shorthand | 01-introduction.tex:81-87 | prose | For \(K=\Q(\mathbf P(H))\), the symbol \(K(\sqrt{cJ_0})\) means \(K(\sqrt{cj_s})\) for \(j_s=J_0/s^2\) with \(s\) a nonzero rational section of \(\mathcal O_{\mathbf P(H)}(3)\). | definition | |
| intro-sqrt-well-defined | 01-introduction.tex:87-88 | prose | Replacing the section \(s\) changes \(j_s\) by a square, so the quadratic extension \(K(\sqrt{cj_s})\) is unchanged. | proof-step | |
| thm1-function-field | 01-introduction.tex:92-95 | Theorem 1.1 (thm:arithmetic-main) | The function field of Hitchin's incidence cover is \(\Q(\mathbf P(H))(\sqrt{5J_0})\). | main-theorem-clause | |
| thm1-stein-algebra | 01-introduction.tex:96-100 | Theorem 1.1 | If \(\mathcal N\to\mathbf P(H)\) is the finite Stein normalization of the incidence cover, then after normalizing the anti-invariant summand its algebra is \(\mathcal O\oplus\mathcal O(-3)\) with multiplication \(z^2=5J_0\). | main-theorem-clause | |
| thm1-chart-pullback | 01-introduction.tex:101-106 | Theorem 1.1 | For the Clebsch chart \(\iota_t:\mathbf P(V_{\Q(\sqrt5)})\to\mathbf P(H_{\Q(\sqrt5)})\) one has \(\iota_t^*J_0=16\sigma_3^2\). | displayed-identity | |
| thm1-chart-not-rational | 01-introduction.tex:107-108 | Theorem 1.1 | The Clebsch chart \(\iota_t\) is not defined over \(\Q\), and Galois conjugation carries it to the chart of the conjugate icosahedron. | main-theorem-clause | |
| thm1-golden-fibre-complete | 01-introduction.tex:108-110 | Theorem 1.1 | The fibre of the incidence cover over the rational point \([xyz]\) is a complete reduced fibre with residue algebra \(\Q(\sqrt5)\). | main-theorem-clause | |
| intro-galois-exchange-classical | 01-introduction.tex:113-115 | prose | The Galois exchange of the two conjugate icosahedra is classical, and the present theorem identifies its occurrence with the square class of Hitchin's incidence cover. | literature-attribution | HMSV, Section 1.3 (HMSVOuter) |
| intro-descent-meaning-of-5 | 01-introduction.tex:117-120 | prose | The cubic \([xyz]\) and its unordered geometric fibre are rational, but choosing either icosahedral configuration (equivalently either conjugate Clebsch chart through that point) requires \(\Q(\sqrt5)\). | proof-step | |
| intro-choice-global | 01-introduction.tex:122-124 | prose | The sign choice can be retained globally after normalizing the pullback to the Clebsch chart, but its comparison with the conference and harmonic signs is relative to a marking. | definition (scope) | |
| intro-marked-datum-def | 01-introduction.tex:124-130 | prose | A marked bridge datum \(\mathfrak m\) consists of an ordering of the six golden projective axes, a labelling of the five plane triples with \(q_1=xyz\) and \(\sum q_i=0\), and the resulting normalized linear lift \(\iota_t(y)=\sum_i y_iq_i\). | definition | |
| intro-marked-datum-ten-faces | 01-introduction.tex:130-132 | prose | The marked bridge datum also identifies the ten face axes with the two-subsets of the five plane-triple labels. | definition | |
| intro-conference-from-reps | 01-introduction.tex:132-134 | prose | Normalized representatives of the six projective axes give a conference matrix \(C_{\mathfrak m}\). | definition | |
| intro-switching-freedom | 01-introduction.tex:134-135 | prose | A different choice of normalized axis representatives switches \(C_{\mathfrak m}\) by a diagonal sign matrix. | proof-step | |
| intro-triangle-cubic-def | 01-introduction.tex:135-139 | prose | The switching-invariant triangle cubic is \(Z_{\mathfrak m}(x)=\sum_{i<j<k}(C_{\mathfrak m})_{ij}(C_{\mathfrak m})_{jk}(C_{\mathfrak m})_{ki}x_ix_jx_k\). | definition | |
| intro-Z-translation-invariant | 01-introduction.tex:140-144 | prose | The triangle cubic \(Z_{\mathfrak m}\) is translation-invariant and hence lies in \(\operatorname{Sym}^3((\Q^6/\Q\mathbf1)^*)\). | proof-step | |
| intro-switch-fixes-Z | 01-introduction.tex:146-148 | prose | Changing auxiliary representatives by \(a_i\mapsto d_ia_i\) sends \(C_{\mathfrak m}\) to \(DC_{\mathfrak m}D\) and fixes \(Z_{\mathfrak m}\). | proof-step | |
| intro-opposite-source | 01-introduction.tex:148-149 | prose | The opposite marked source is represented by the pair \((-C_{\mathfrak m},-Z_{\mathfrak m})\). | definition | |
| intro-sign-retained | 01-introduction.tex:149-151 | prose | The sign of the cubic generator is retained, so the bracket \([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}\) is not projective notation. | definition (scope) | |
| intro-relabelling-equivariance | 01-introduction.tex:151-152 | prose | Relabelling is equivariant only when all labelled objects are transported together; the labelling is not quotiented silently. | definition (scope) | |
| prop2-pullback-splits | 01-introduction.tex:156-161 | Proposition 1.2 (thm:orientation-source) | The normalization of the pullback of Hitchin's incidence normalization along \(\iota_t:B=\mathbf P(V_E)\to\mathbf P(H_E)\), with \(E=\Q(\sqrt5)\), is a disjoint union \(B_+\amalg B_-\). | main-theorem-clause | |
| prop2-plane-selects-component | 01-introduction.tex:162-163 | Proposition 1.2 | The fixed isotropic plane selects the component \(B_+\), and incidence deck exchange interchanges \(B_+\) and \(B_-\). | main-theorem-clause | |
| prop2-branch-equations | 01-introduction.tex:163-169 | Proposition 1.2 | For an odd generator normalized on \(B_+\), the two components have equations \(z=4\sqrt5\,\sigma_3\) and \(z=-4\sqrt5\,\sigma_3\). | displayed-identity | |
| prop2-two-configs-on-Dsigma3 | 01-introduction.tex:170-171 | Proposition 1.2 | On \(D(\sigma_3)\) the two components correspond to the two distinct icosahedral configurations. | main-theorem-clause | |
| prop2-branches-meet-on-cubic | 01-introduction.tex:171-172 | Proposition 1.2 | On the Clebsch cubic \(\sigma_3=0\) the unnormalized branches meet while the normalization remains disjoint. | main-theorem-clause | |
| prop2-source-assignment | 01-introduction.tex:174-176 | Proposition 1.2 | Relative to \(\mathfrak m\), the component \(B_+\) carries the source \([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}\) and \(B_-\) carries its deck-opposite. | definition | |
| prop2-exchanger-identifies-opposite | 01-introduction.tex:176-180 | Proposition 1.2 | At \([xyz]\) the golden exchanger identifies the deck-opposite source with the conjugate configuration and with the representative \((-C_{\mathfrak m},-Z_{\mathfrak m})\). | main-theorem-clause | |
| prop2-beta-definition | 01-introduction.tex:180-184 | Proposition 1.2 | The marked primitive pair-sum map is \(\beta:V\to\Q^{\binom52}\) with \(\beta(y)_{ij}=y_i+y_j\). | definition | |
| prop2-fixes-degree-six-sign | 01-introduction.tex:185-186 | Proposition 1.2 | The same relative convention fixes the sign of the degree-six cubic of the harmonic theorem. | main-theorem-clause | |
| prop2-component-does-not-determine-m | 01-introduction.tex:187 | Proposition 1.2 | The normalized component alone is not asserted to determine the marked bridge datum \(\mathfrak m\). | definition (scope) | |
| intro-Z-vs-sigma3-domains | 01-introduction.tex:190-192 | prose | \(Z_{\mathfrak m}\) and \(\sigma_3\) are different cubics on spaces of dimensions five and four, and the proposition compares their orientations without identifying their polynomial domains. | definition (scope) | |
| intro-outer-translates-four-ways | 01-introduction.tex:194-197 | prose | The six outer translates of \(Z_{\mathfrak m}\) are simultaneously triangle cubics, middle-exterior diagonals, commutator Pfaffians, and cross-golden determinants. | main-theorem-clause | |
| intro-joubert-on-segre | 01-introduction.tex:197-198 | prose | The Joubert coordinates of those translates land on the Segre cubic. | main-theorem-clause | |
| intro-segre-sections-clebsch | 01-introduction.tex:198 | prose | Coordinate sections of the Segre cubic are diagonal Clebsch cubic surfaces. | literature-attribution | HMSV, Sections 2.1--2.2 |
| intro-centered-squaring-polar | 01-introduction.tex:198-200 | prose | Centered squaring is the classical Segre--Igusa polar map. | literature-attribution | HMSV, Sections 2.1--2.2 |
| intro-order-six-unique-preview | 01-introduction.tex:201-205 | prose | Order six is the unique nontrivial symmetric conference order whose balanced exchange spectrum is independent of the cut. | main-theorem-clause | |
| intro-higher-order-moments | 01-introduction.tex:205-207 | prose | At orders above six the classical determinant-\((-3)\) design still fixes the mean and the variance of the first nonconstant exchange moment. | main-theorem-clause | |
| intro-aligned-sharp-preview | 01-introduction.tex:207-210 | prose | From seven vertices onward the aligned four-sets of a two-graph recover it up to complement, and this is sharp. | main-theorem-clause | |
| intro-conference-order-ten | 01-introduction.tex:210-212 | prose | For conference matrices, from order ten onward the marked design recovers the signing up to switching and global negation. | main-theorem-clause | |
| intro-quadratic-family-suffices | 01-introduction.tex:211-212 | prose | A quadratic family of selected determinant tests already suffices for that recovery. | main-theorem-clause | |
| intro-proof-three-steps | 01-introduction.tex:216-221 | prose | The arithmetic proof has three steps: Hitchin's degree and branch-sextic calculation reduces the generic extension to \(K(\sqrt{cJ_0})\); the complete etale fibre at \([xyz]\) with residue algebra \(\Q(\sqrt5)\) forces \(c=5\); and the explicit projective orthogonal transformation between the two configurations has spinor class \([2]\). | proof-step | |
| intro-harmonic-proof-outline | 01-introduction.tex:221-223 | prose | The harmonic proof identifies the pair-sum coefficients with the Petersen \((-2)\)-eigenspace and determines the invariant cubic from one exact spherical-moment calculation. | proof-step | |
| intro-hitchin-supplies | 01-introduction.tex:228-232 | prose | Hitchin proves the generic degree, identifies the branch sextic, constructs the Clebsch chart, computes its restriction, and classifies the fibre over \(xyz\). | literature-attribution | Hitchin, HitchinIcosahedron §§2--4,7--10; HitchinBundles §§4--5 |
| intro-new-contribution | 01-introduction.tex:232-234 | prose | The arithmetic theorem fixes the remaining rational constant in Hitchin's square class and computes the spinor class of the explicit specialization. | main-theorem-clause | |
| intro-mukai-umemura-source | 01-introduction.tex:234-237 | prose | The Mukai--Umemura threefold supplies the original threefold, and Hitchin supplies the incidence construction and every formula used. | literature-attribution | Mukai--Umemura; Hitchin |
| intro-dye-criterion | 01-introduction.tex:237-239 | prose | Dye's finite theorem gives the complementary square-\(5\) criterion for Clebsch hexagons. | literature-attribution | Dye (DyeClebsch) |
| intro-integral-etale-locus | 01-introduction.tex:239-241 | prose | The abstract equation \(z^2=5J_{\mathbf Z}\) is etale on \(D(10J_{\mathbf Z})\), but its comparison with the geometric incidence variety is proved only after inverting an unspecified integer. | main-theorem-clause | |
| intro-harmonic-independent | 01-introduction.tex:243-244 | prose | The numerical harmonic restriction is logically independent of the incidence cover. | definition (scope) | |
| intro-bond-order-observable | 01-introduction.tex:246-248 | prose | The classical degree-six bond-order observable is the rotationally invariant cubic formed from degree-six harmonic coefficients. | literature-attribution | Steinhardt--Nelson--Ronchetti (SNR1981, SNR1983) |
| intro-coefficient-factorization | 01-introduction.tex:249-253 | prose | The coefficient factors exactly as \(-\frac{784000}{1247103}=-\frac{400}{46189}\cdot\frac{1960}{27}\). | exact-constant | |
| intro-gaunt-factor | 01-introduction.tex:254-256 | prose | The first factor \(400/46189\) is the universal \((6,6,6)\) Gaunt coupling, the square of the Wigner 3j symbol with all magnetic quantum numbers zero. | exact-constant | |
| intro-restriction-scalar-factor | 01-introduction.tex:256 | prose | The second factor \(1960/27\) is the restriction scalar of the marked Petersen embedding. | exact-constant | |
| intro-prime-11-origin | 01-introduction.tex:257-259 | prose | The prime \(11\) in the denominator belongs to the universal angular-momentum normalization rather than to the golden descent. | proof-step | |
| intro-relation-via-A5-module | 01-introduction.tex:259-261 | prose | The paper relates the incidence and harmonic constructions through their common four-dimensional \(A_5\)-module and invariant polynomial \(\sigma_3\), not by a rational map between their ambient harmonic spaces. | definition (scope) | |
| intro-icosahedral-decomposition-classical | 01-introduction.tex:263-266 | prose | The decomposition of spherical harmonics under icosahedral symmetry, including the degree-six symmetry types used here, is classical. | literature-attribution | Meyer; Cohan (MeyerHarmonics, CohanHarmonics) |
| intro-degree-six-lowest-channel | 01-introduction.tex:266-267 | prose | Modern applications treat degree six as the lowest nonconstant even icosahedral channel. | literature-attribution | Dharmavaram (DharmavaramCapsids) |
| intro-what-is-new-harmonic | 01-introduction.tex:267-270 | prose | The present calculation fixes a particular labelled ten-face-axis zonal map, identifies its Petersen four-space, and evaluates the cubic on that map, claiming no priority for the ambient icosahedral decomposition or for the bond-order invariant. | definition (scope) | |

## Section 2, The rational incidence cover (`sections/02-orientation-cover.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| cover-E-definition | 02-orientation-cover.tex:6 | prose | \(E=\Q[t]/(t^2-t-1)=\Q(\sqrt5)\). | definition | |
| cover-It-definition | 02-orientation-cover.tex:7-12 | prose | \(I_t\) is the six-point set \(\{[0:t:1],[0:t:-1],[1:0:t],[-1:0:t],[t:-1:0],[-t:-1:0]\}\subset\mathbf P^2_E\). | definition | |
| cover-It-are-icosahedral-axes | 02-orientation-cover.tex:14 | prose | The points of \(I_t\) are the six axes of the standard icosahedron. | definition | |
| cover-Vt-definition | 02-orientation-cover.tex:15-18 | prose | \(V_t=\{p\in H_E: p(a)=0\ \text{for every}\ [a]\in I_t\}\subset H_E\). | definition | |
| cover-Vt-dim-four | 02-orientation-cover.tex:19-21 | prose | \(V_t\) has dimension four. | literature-attribution | Hitchin, §§2--4 |
| cover-rotation-permutes-triples | 02-orientation-cover.tex:21-23 | prose | The rotation group of \(I_t\) permutes the five triples of mutually orthogonal symmetry planes. | literature-attribution | Hitchin, §§2--4 |
| cover-qi-definition | 02-orientation-cover.tex:23-25 | prose | \(q_1,\dots,q_5\) are the products of the three linear equations in the five plane triples, with \(q_1=xyz\) and relative scalars chosen so that \(\sum_i q_i=0\). | definition | |
| cover-iota-isomorphism | 02-orientation-cover.tex:26-31 | prose | The map \(\iota_t:V_E=\{(y_i)\in E^5:\sum_i y_i=0\}\to V_t\), \((y_i)\mapsto\sum_i y_iq_i\), is an \(A_5\)-equivariant isomorphism. | literature-attribution | Hitchin, §§2--4 |
| cover-y-circ | 02-orientation-cover.tex:32-35 | prose | The parameter of \(xyz=q_1\) is \(y^\circ=\frac15(4,-1,-1,-1,-1)\). | displayed-identity | |
| cover-sigma3-y-circ | 02-orientation-cover.tex:35 | prose | \(\sigma_3(y^\circ)=\frac4{25}\). | exact-constant | |
| cover-pullback-16 | 02-orientation-cover.tex:38-42 | prose | With the fixed polarization and sextic normalization, \(\iota_t^*J_0=16\sigma_3^2\). | displayed-identity | Hitchin, Appendix final displayed formula |
| cover-J0-xyz-value | 02-orientation-cover.tex:41 | prose | \(J_0(xyz)=(16/25)^2\). | exact-constant | Hitchin, Appendix final displayed formula |
| cover-16-forced-by-lift | 02-orientation-cover.tex:44-46 | prose | The coefficient \(16\) is fixed by the chosen lift and not by a further geometric parameter: at \(y^\circ\) the ratio of \(J_0(xyz)\) to \(\sigma_3(y^\circ)^2\) is exactly \(16\). | exact-constant | |
| cover-chart-over-E-only | 02-orientation-cover.tex:48 | prose | The Clebsch chart is defined over \(E\) and not over \(\Q\). | proof-step | |
| cover-conjugation-carries-chart | 02-orientation-cover.tex:48-51 | prose | The nontrivial automorphism \(t\mapsto1-t\) carries \(I_t\) and \(V_t\) to the distinct conjugate icosahedron and its vanishing space, with transport given by the matrix \(R\). | proof-step | |
| cover-not-rational-inclusion | 02-orientation-cover.tex:51-52 | prose | \(\iota_t\) is not a literal rational inclusion \(V\hookrightarrow H\). | proof-step | |
| cover-no-common-axis | 02-orientation-cover.tex:53 | prose | The two displayed icosahedra \(I_t\) and \(I_{1-t}\) have no common axis. | proof-step | |
| cover-Vt-intersection | 02-orientation-cover.tex:53-57 | prose | \(V_t\cap V_{1-t}=E\cdot xyz\). | literature-attribution | Hitchin, Proposition 7 |
| cover-union-descends | 02-orientation-cover.tex:59-62 | prose | The reduced union \(\mathbf P(V_t)\cup\mathbf P(V_{1-t})\) descends to \(\Q\), and over \(E\) it is a pair of conjugate projective three-spaces meeting only at the rational point \([xyz]\). | proof-step | |
| cover-Z-normalization | 02-orientation-cover.tex:62-67 | prose | The descended scheme \(Z\) has normalization \(\nu:Z^\nu\to Z\) with \(Z^\nu=\mathbf P(V_t)\) regarded as a \(\Q\)-scheme via \(\Spec E\to\Spec\Q\), and after base change to \(E\) this normalization is the disjoint union of the two conjugate components. | proof-step | |
| cover-nu-fibre | 02-orientation-cover.tex:67-70 | prose | \(\nu^{-1}([xyz])=\Spec E\). | displayed-identity | |
| pinch-setup | 02-orientation-cover.tex:74-82 | prose (Quadratic pinching) | For a separable quadratic extension \(E/k\), \(A=E[[x_1,\dots,x_n]]\) with \(n\ge1\) and maximal ideal \(\mathfrak m\), the fibre product \(R=A\times_E k=k+\mathfrak m\) is defined. | definition | |
| pinch-normalization | 02-orientation-cover.tex:82 | prose | The pinching ring \(R=k+\mathfrak m\) has normalization \(A\). | proof-step | |
| pinch-conductor | 02-orientation-cover.tex:82 | prose | The pinching ring has conductor \(\mathfrak m\). | proof-step | |
| pinch-defect | 02-orientation-cover.tex:82-84 | prose | The pinching ring has defect \(A/R\simeq E/k\) as a \(k\)-vector space. | proof-step | |
| pinch-two-planes | 02-orientation-cover.tex:84-86 | prose | After completed base change to \(E\), \(\Spec R\) is the union of two formal \(n\)-planes meeting at their origins. | proof-step | |
| pinch-A-finite-over-R | 02-orientation-cover.tex:88-89 | prose | For \(\alpha\in E\setminus k\) one has \(A=R+R\alpha\), so \(A\) is finite and hence integral over \(R\). | proof-step | |
| pinch-same-fraction-field | 02-orientation-cover.tex:89-91 | prose | \(A\) and \(R\) have the same fraction field, because \(\alpha=(\alpha x_1)/x_1\). | proof-step | |
| pinch-A-is-normalization | 02-orientation-cover.tex:91-92 | prose | Since \(A\) is normal, it is the normalization of \(R\). | proof-step | |
| pinch-conductor-computation | 02-orientation-cover.tex:92-95 | prose | An element of the conductor has residue \(c\in k\); multiplication by constants of \(E\) forces \(cE\subset k\) hence \(c=0\), and conversely \(\mathfrak m A\subset\mathfrak m\), so the conductor is \(\mathfrak m\). | proof-step | |
| pinch-defect-mod-m | 02-orientation-cover.tex:94-95 | prose | Reduction modulo \(\mathfrak m\) gives \(A/R\simeq E/k\) as \(k\)-vector spaces. | proof-step | |
| pinch-tensor-splits | 02-orientation-cover.tex:95-97 | prose | \(E\otimes_kE\simeq E\times E\), and the fibre-product description gives the two conjugate branches after completed base change. | proof-step | |
| cover-transverse-meeting | 02-orientation-cover.tex:99-101 | prose | The two projective three-spaces meet transversely, so the completed local ring of \(Z\) at \([xyz]\) is the pinching ring with \(k=\Q\), \(E=\Q(\sqrt5)\), and \(n=3\). | proof-step | |
| cover-invariants-forced | 02-orientation-cover.tex:101-104 | prose | The normalization, conductor, and defect \(E/\Q\) of that local ring are forced by residue-field pinching and do not depend on a six-variable presentation. | proof-step | |
| cover-5-is-discriminant-class | 02-orientation-cover.tex:104-105 | prose | The value \(5\) is the discriminant square class of the two branches, not merely a value recovered from the sextic. | proof-step | |
| cover-local-model-scope | 02-orientation-cover.tex:105-106 | prose | The local pinching model explains the descent geometry but does not replace the comparison with Hitchin's incidence scheme. | definition (scope) | |
| cover-pullback-split-over-E | 02-orientation-cover.tex:107-109 | prose | After base change to \(E\), the pullback of the incidence double cover to \(D(\sigma_3)\) is split. | proof-step | |
| cover-galois-exchanges-both | 02-orientation-cover.tex:108-109 | prose | Galois conjugation exchanges both the two components of the split cover and the two conjugate charts. | proof-step | |
| cover-omega-definition | 02-orientation-cover.tex:113-119 | prose | For \(W=\Q^3\) with the quadratic form \(Q\) and \(a\in W\), infinitesimal rotation about \(a\) acts on \(H\), and \(\omega_a(p,q)=\langle a\cdot p,q\rangle\) defines a skew form. | definition | |
| cover-X-definition | 02-orientation-cover.tex:120-124 | prose | \(X=\{U\in\operatorname{Gr}(3,H):\omega_a|_U=0\ \text{for all}\ a\in W\}\) is a closed subscheme cut out by three rational skew forms. | definition | |
| cover-X-is-MU | 02-orientation-cover.tex:125-127 | prose | \(X_{\mathbf C}\) is the Mukai--Umemura threefold; in particular \(X\) is geometrically integral and smooth. | literature-attribution | Hitchin, HitchinBundles §§4--5 |
| cover-I-definition | 02-orientation-cover.tex:127-131 | prose | The incidence scheme is \(\mathcal I=\{([f],U)\in\mathbf P(H)\times X:\langle f,U\rangle=0\}\). | definition | |
| cover-I-projective-bundle | 02-orientation-cover.tex:132-134 | prose | The first projection \(\pi:\mathcal I\to\mathbf P(H)\) makes \(\mathcal I\) a projective bundle over \(X\), so \(\mathcal I\) is normal and integral, and all displayed equations are defined over \(\Q\). | proof-step | |
| cover-mukai-hitchin-credit | 02-orientation-cover.tex:134-136 | prose | Mukai and Umemura introduced the underlying threefold and Hitchin supplies the Grassmannian model and the incidence calculation. | literature-attribution | Mukai--Umemura; Hitchin |
| cover-N-definition | 02-orientation-cover.tex:138-142 | prose | \(\mathcal N=\operatorname{Spec}_{\mathbf P(H)}\pi_*\mathcal O_{\mathcal I}\). | definition | |
| cover-stein-factorization | 02-orientation-cover.tex:143-147 | prose | Stein factorization gives \(\mathcal I\to\mathcal N\to\mathbf P(H)\), and since \(\mathcal I\) is normal with quadratic generic field, \(\mathcal N\) is the normalization of \(\mathbf P(H)\) in that field. | proof-step | |
| cover-Vt-is-Ut-perp | 02-orientation-cover.tex:148-153 | prose | For Hitchin's isotropic three-plane \(U_t\in X(E)\) attached to \(I_t\), one has \(V_t=U_t^\perp\). | literature-attribution | Hitchin, §§2--5 |
| cover-section-into-I | 02-orientation-cover.tex:153-155 | prose | The assignment \([p]\mapsto([p],U_t)\) defines a section \(\mathbf P(V_t)\to\mathcal I_E\). | proof-step | |
| cover-descended-morphism | 02-orientation-cover.tex:155-159 | prose | The two conjugate sections descend to a morphism \(Z^\nu\to\mathcal I\to\mathcal N\) over \(\mathbf P(H)\). | proof-step | |
| cover-local-comparison-iso | 02-orientation-cover.tex:160-162 | prose | Over the finite etale neighborhood of \([xyz]\), that morphism carries \(\nu^{-1}([xyz])=\Spec E\) isomorphically onto the golden incidence fibre. | proof-step | |
| pf1-chern-number-two | 02-orientation-cover.tex:166-170 | proof of Theorem 1.1 | The Mukai--Umemura threefold is the zero locus of the three skew forms on \(\operatorname{Gr}(3,H)\), and the top Chern number of the dual universal bundle is \(2\), so a general \(f\) is orthogonal to two isotropic three-planes. | literature-attribution | Hitchin, HitchinBundles §§4--5 |
| pf1-generic-quadratic | 02-orientation-cover.tex:170-172 | proof of Theorem 1.1 | The incidence variety is a projective bundle over the integral Mukai--Umemura threefold, hence integral, so its generic function field is a quadratic extension of \(K\). | proof-step | |
| pf1-quadratic-form-sqrt-d | 02-orientation-cover.tex:175-177 | proof of Theorem 1.1 | In characteristic zero every quadratic extension of \(K=\Q(\mathbf P(H))\) has the form \(K(\sqrt d)\). | proof-step | |
| pf1-odd-valuations-are-branch | 02-orientation-cover.tex:177-178 | proof of Theorem 1.1 | The prime divisors at which \(d\) has odd valuation are exactly the branch divisors. | proof-step | |
| pf1-branch-is-sextic | 02-orientation-cover.tex:178-179 | proof of Theorem 1.1 | The branch hypersurface is the irreducible invariant sextic \(J_0=0\). | literature-attribution | Hitchin, §§9--10 |
| pf1-js-odd-valuations | 02-orientation-cover.tex:181-187 | proof of Theorem 1.1 | For \(j_s=J_0/s^2\), the odd valuations of \(j_s\) occur exactly along \(J_0=0\), because the divisor of \(s^2\) is even. | proof-step | |
| pf1-div-even | 02-orientation-cover.tex:187-190 | proof of Theorem 1.1 | \(\operatorname{div}(d/j_s)=2D\) for a divisor \(D\) on \(\mathbf P(H)\). | displayed-identity | |
| pf1-D-two-torsion-principal | 02-orientation-cover.tex:191-193 | proof of Theorem 1.1 | The class of \(D\) is two-torsion, and since \(\operatorname{Pic}(\mathbf P(H))=\mathbf Z\), \(D\) is principal. | proof-step | |
| pf1-d-form | 02-orientation-cover.tex:194-200 | proof of Theorem 1.1 | Therefore \(d=cj_sg^2\) for some \(g\in K^\times\) and a unique \(c\in\Q^\times/\Q^{\times2}\), so the incidence extension is \(K(\sqrt{cJ_0})\). | proof-step | |
| pf1-two-configs-over-xyz | 02-orientation-cover.tex:202-205 | proof of Theorem 1.1 | Over \([xyz]\) there are exactly the two distinct configurations \(I_t\) and \(I_{1-t}\). | literature-attribution | Hitchin, §§3, 7--9 |
| pf1-pi-quasi-finite | 02-orientation-cover.tex:205-206 | proof of Theorem 1.1 | The projection \(\pi\) is quasi-finite over \([xyz]\). | proof-step | |
| pf1-finite-neighborhood | 02-orientation-cover.tex:206-208 | proof of Theorem 1.1 | Because \(\pi\) is proper, there is a Zariski neighborhood \(B\) of \([xyz]\) on which \(\pi\) is finite. | proof-step | |
| pf1-birational-iso | 02-orientation-cover.tex:208-211 | proof of Theorem 1.1 | The normal finite scheme \(\pi^{-1}(B)\) is birational to the normalization \(\widetilde B\) of \(B\) in \(K(\sqrt{cJ_0})\) and hence isomorphic to it. | proof-step | |
| pf1-etale-after-shrinking | 02-orientation-cover.tex:211-213 | proof of Theorem 1.1 | Since \(J_0(xyz)\ne0\), shrinking \(B\) away from the branch divisor \(J_0=0\) makes the finite normalization etale. | proof-step | |
| pf1-complete-reduced-fibre | 02-orientation-cover.tex:213-218 | proof of Theorem 1.1 | The two distinct geometric points form the complete reduced scheme-theoretic fibre, whose residue algebra is \(E=\Q[t]/(t^2-t-1)=\Q(\sqrt5)\). | proof-step | |
| pf1-local-equation | 02-orientation-cover.tex:220-223 | proof of Theorem 1.1 | For a local generator \(e\) of \(\mathcal O_{\mathbf P(H)}(3)\) at \([xyz]\) and \(j_e=J_0/e^2\), the normalization is locally \(w^2=cj_e\). | proof-step | |
| pf1-unit-square-change | 02-orientation-cover.tex:223-224 | proof of Theorem 1.1 | Changing the local generator \(e\) multiplies \(j_e\) by a unit square. | proof-step | |
| pf1-je-vs-J0-square | 02-orientation-cover.tex:224-226 | proof of Theorem 1.1 | The value \(j_e(xyz)\) differs from \(J_0(xyz)=(16/25)^2\) by a rational square. | proof-step | |
| pf1-c-equals-5 | 02-orientation-cover.tex:226-228 | proof of Theorem 1.1 | Specialization gives residue algebra \(\Q(\sqrt c)\), and comparison with the golden fibre proves \(c=5\) in \(\Q^\times/\Q^{\times2}\). | proof-step | |
| pf1-evaluation-legitimate | 02-orientation-cover.tex:228-231 | proof of Theorem 1.1 | Evaluating the generic square class at \([xyz]\) is legitimate because that point lies in the finite etale locus and the change from \(j_s\) to \(j_e\) is a unit square there. | proof-step | |
| pf1-involution-extends | 02-orientation-cover.tex:234-235 | proof of Theorem 1.1 | The quadratic field involution extends to the normalization \(\mathcal N\). | proof-step | |
| pf1-eigendecomposition | 02-orientation-cover.tex:235-239 | proof of Theorem 1.1 | Since \(2\) is invertible, \(f_*\mathcal O_{\mathcal N}=\mathcal O\oplus\mathcal M\) is the decomposition into invariant and anti-invariant summands. | proof-step | |
| pf1-invariant-summand-O | 02-orientation-cover.tex:239-241 | proof of Theorem 1.1 | The invariant summand is \(\mathcal O\), because its relative spectrum is finite and birational over the normal space \(\mathbf P(H)\). | proof-step | |
| pf1-M-reflexive | 02-orientation-cover.tex:241-243 | proof of Theorem 1.1 | Normality makes \(f_*\mathcal O_{\mathcal N}\) an \(S_2\) module over the regular base, so the summand \(\mathcal M\) is a rank-one reflexive sheaf. | proof-step | |
| pf1-reflexive-is-line-bundle | 02-orientation-cover.tex:243-245 | proof of Theorem 1.1 | Every rank-one reflexive sheaf on projective space is a line bundle, so \(\mathcal M\simeq\mathcal O(-d)\). | proof-step | |
| pf1-multiplication-section | 02-orientation-cover.tex:247-249 | proof of Theorem 1.1 | Multiplication on the anti-invariant summand is a section of \(\mathcal M^{-2}\simeq\mathcal O(2d)\). | proof-step | |
| pf1-d-equals-3 | 02-orientation-cover.tex:248-250 | proof of Theorem 1.1 | The zero divisor of that multiplication section is the branch divisor \(J_0=0\) of degree six, hence \(d=3\) and multiplication is \(cJ_0\) for some \(c\in\Q^\times\). | proof-step | |
| pf1-c5-mod-square | 02-orientation-cover.tex:250-251 | proof of Theorem 1.1 | The function-field calculation and the golden fibre give \(c=5\) modulo a rational square. | proof-step | |
| pf1-exact-algebra | 02-orientation-cover.tex:251-258 | proof of Theorem 1.1 | Rescaling the isomorphism \(\mathcal M\simeq\mathcal O(-3)\) absorbs the square and gives the exact algebra \(f_*\mathcal O_{\mathcal N}\simeq\mathcal O\oplus\mathcal O(-3)\) with \(z^2=5J_0\). | displayed-identity | |
| pf1-remaining-freedom | 02-orientation-cover.tex:259-261 | proof of Theorem 1.1 | After Hitchin's scale for \(J_0\) and an isomorphism \(\mathcal M\simeq\mathcal O(-3)\) with multiplication \(5J_0\) are fixed, the remaining choices differ by the deck involution \(z\mapsto-z\). | proof-step | |
| pf1-algebra-not-just-fields | 02-orientation-cover.tex:262-263 | proof of Theorem 1.1 | The equation used on the Clebsch chart is an equation of finite algebras, not only of their function fields. | proof-step | |
| int-lattice-scaling | 02-orientation-cover.tex:266-268 | prose (Integral boundary) | There is a full lattice \(\Lambda\subset H\) and a nonzero integer \(a\) such that \(J_{\mathbf Z}=a^2J_0\) has integral coefficients. | proof-step | |
| int-algebra-flat-degree-two | 02-orientation-cover.tex:268-274 | prose | The algebra \(\mathcal O_{\mathbf P(\Lambda)}\oplus\mathcal O_{\mathbf P(\Lambda)}(-3)\) with \(z^2=5J_{\mathbf Z}\) is finite locally free of degree two over \(\mathbf Z\) and has the function field of the arithmetic theorem. | proof-step | |
| int-etale-locus | 02-orientation-cover.tex:274-276 | prose | That integral algebra is finite etale on \(D(10J_{\mathbf Z})\). | proof-step | |
| int-bad-primes-2-and-5 | 02-orientation-cover.tex:276-278 | prose | The primes \(2\) and \(5\) are forced bad primes: in characteristic \(2\) the equation \(z^2=5J_{\mathbf Z}\) is inseparable and in characteristic \(5\) it is generically \(z^2=0\). | proof-step | |
| int-no-integral-incidence-thm | 02-orientation-cover.tex:280-281 | prose | The abstract integral algebra does not by itself give an integral incidence theorem. | definition (scope) | |
| int-sources-over-C | 02-orientation-cover.tex:282-284 | prose | The cited Mukai--Umemura and Hitchin constructions are over \(\mathbf C\), and the available binary-sextic formulae justify their classical invariant presentation only after inverting \(30\). | literature-attribution | Mukai--Umemura; Hitchin |
| int-spreading-out-N | 02-orientation-cover.tex:284-289 | prose | Spreading out the rational incidence isomorphism gives some \(\mathbf Z[1/N]\) with \(2,3,5\mid N\) after enlarging \(N\), but neither the sources nor the present equations determine the other prime divisors of \(N\) or prove there are none. | proof-step | |
| int-finite-field-restriction | 02-orientation-cover.tex:286-290 | prose | Every finite-field icosahedral-incidence interpretation in the paper is restricted to an unspecified cofinite set of primes. | definition (scope) | |
| int-abstract-algebra-no-exception | 02-orientation-cover.tex:290-291 | prose | The formula for the abstract quadratic algebra itself has no extra prime exception beyond \(2\) and \(5\). | proof-step | |
| int-missing-assertion | 02-orientation-cover.tex:293-299 | prose | Closing the integral gap requires identifying an integral harmonic lattice and its three-skew-form Grassmannian zero locus with an integral Mukai--Umemura model, proving flatness and normality, and showing that Stein formation and the chart sections commute with the required base changes; until then extra divisors of \(N\) are evidence gaps rather than predicted bad primes. | definition (scope) | |

## Section 3, The marked orientation source (`sections/03-orientation-source.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| src-normalization-intrinsic | 03-orientation-source.tex:4-7 | prose | The normalization of the chart pullback is intrinsic, while its comparison with the golden six-axis data and the Petersen coefficient module is relative to the marked bridge datum \(\mathfrak m\). | definition (scope) | |
| src-chart-algebra-factorization | 03-orientation-source.tex:11-20 | prose | On \(B=\mathbf P(V_E)\) the pulled-back Stein algebra satisfies the equality of finite \(\mathcal O_B\)-algebras \(z^2=5\iota_t^*J_0=80\sigma_3^2=(z-4\sqrt5\,\sigma_3)(z+4\sqrt5\,\sigma_3)\). | displayed-identity | |
| src-pinching-lemma | 03-orientation-source.tex:21-25 | prose | For a normal domain \(S\) with \(2\) invertible and \(0\ne a\in S\), the algebra \(S[z]/(z^2-a^2)\) maps to \(S\times S\) by \(z\mapsto(a,-a)\), its image is the pairs congruent modulo \(a\), its normalization is \(S\times S\), its conductor is \((a)\times(a)\), and it is split etale where \(a\) is a unit. | proof-step | |
| src-apply-with-a | 03-orientation-source.tex:25-28 | prose | Applying that lemma with \(a=4\sqrt5\,\sigma_3\) gives the normalization \(B_+\amalg B_-\) and locates the entire failure of normality on the Clebsch cubic \(\sigma_3=0\). | proof-step | |
| src-components-source | 03-orientation-source.tex:28-29 | prose | The constant isotropic plane \(U_t\) supplies one normalized component and deck exchange supplies the other. | proof-step | |
| src-Dsigma3-two-configs | 03-orientation-source.tex:29-30 | prose | \(D(\sigma_3)\) is exactly the locus of two distinct regular icosahedral configurations. | literature-attribution | Hitchin (chart classification) |
| src-magnitude-forced | 03-orientation-source.tex:31-33 | prose | The magnitude \(4\sqrt5\) is forced by the product of the descent class \(5\) and the chart factor \(16\), and choosing its sign is exactly choosing one normalized component. | exact-constant | |
| src-sign-normalization | 03-orientation-source.tex:35-37 | prose | The sign of \(z\) is normalized by declaring that the component supplied by \(U_t\) has \(z=4\sqrt5\,\sigma_3\). | definition | |
| src-no-integral-strengthening | 03-orientation-source.tex:37-39 | prose | That sign normalization does not strengthen the integral statement; comparison with the geometric incidence model still holds only over an unspecified \(\mathbf Z[1/N]\). | definition (scope) | |
| src-gram-form | 03-orientation-source.tex:45-58 | prose | The Gram matrix of the displayed normalized axis representatives is \(G=(t+2)I+tC\) with the displayed six-by-six zero-diagonal sign matrix \(C\). | displayed-identity | |
| src-equiangular-classical | 03-orientation-source.tex:59-61 | prose | The description of the six icosahedral vertex axes as equiangular lines with a signed Gram or Seidel matrix up to diagonal switching is classical. | literature-attribution | Godsil, §3 (GodsilProblems) |
| src-new-is-sign-tracking | 03-orientation-source.tex:61-62 | prose | What is new here is the tracking of the sign of the specific marked triangle cubic under the golden exchanger. | definition (scope) | |
| src-frame-operator-scalar | 03-orientation-source.tex:63-65 | prose | The frame operator \(\sum_i a_ia_i^{\mathsf T}\) commutes with the irreducible three-dimensional \(A_5\)-action and is therefore scalar. | proof-step | |
| src-frame-value | 03-orientation-source.tex:65-66 | prose | The frame operator has trace \(6(t+2)\) and equals \(2(t+2)I_3\). | exact-constant | |
| src-G-squared | 03-orientation-source.tex:66-67 | prose | \(G^2=2(t+2)G\). | displayed-identity | |
| src-C-squared-5I | 03-orientation-source.tex:67-69 | prose | Substituting \(G=(t+2)I+tC\) and using \((t+2)^2=5t^2\) gives \(C^2=5I\). | displayed-identity | |
| src-switching-fixes-Z | 03-orientation-source.tex:69-70 | prose | Changing signs of axis representatives switches \(C\) to \(DCD\) but leaves every triangle product and hence \(Z_C\) unchanged. | proof-step | |
| src-pair-balance | 03-orientation-source.tex:70-73 | prose | The off-diagonal entries of \(C^2=5I\) give \(\sum_{k\ne i,j}C_{ij}C_{jk}C_{ki}=0\). | displayed-identity | |
| src-Z-descends | 03-orientation-source.tex:74-76 | prose | The directional derivative of \(Z_C\) along \(\mathbf1\) vanishes, so \(Z_C(x+u\mathbf1)=Z_C(x)\) and the cubic descends to \(\Q^6/\Q\mathbf1\). | proof-step | |
| src-exchanger-action | 03-orientation-source.tex:78-85 | prose | Direct substitution gives \(Ra_i=t\,d_i\,a'_{p(i)}\) with permutation \(p=(0,1,5,4,2,3)\) and signs \((d_i)=(1,-1,1,1,1,1)\). | displayed-identity | |
| src-transported-sign-identity | 03-orientation-source.tex:86-89 | prose | Using \(t^2(1-t)=-t\) one obtains \(d_id_jC_{p(i)p(j)}=-C_{ij}\). | displayed-identity | |
| src-conjugation-negates | 03-orientation-source.tex:90-92 | prose | At the golden fibre, conjugation transported by \(R\) changes \(C\) to \(-C\) and \(Z_C\) to \(-Z_C\). | proof-step | |
| src-lone-negative-irrelevant | 03-orientation-source.tex:92-93 | prose | The single negative sign \(d_i\) is only a change of axis representatives and does not cause the reversal, since switching alone leaves the triangle cubic fixed. | proof-step | |
| src-no-global-marking | 03-orientation-source.tex:95-97 | prose | No global marking of the varying configurations on \(B_-\) is needed or asserted, and the fixed section \(U_t\) selects \(B_+\) without by itself choosing \(\mathfrak m\). | definition (scope) | |
| src-relative-attachment | 03-orientation-source.tex:97-100 | prose | After \(\mathfrak m\) is fixed, the constant source \([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}\) is attached to \(B_+\) and the deck-opposite source to \(B_-\), meaning the normalized odd generator changes sign. | definition | |
| src-xyz-agreement | 03-orientation-source.tex:100-102 | prose | The calculation at \([xyz]\) proves that the relative convention agrees with the actual conjugate golden configuration there, and it is not used to infer a pointwise conference labeling elsewhere. | proof-step | |
| src-labels-extend-over-sigma3-zero | 03-orientation-source.tex:103-105 | prose | Since the normalized components remain disjoint above \(\sigma_3=0\), the two relative source labels extend there even though the literal two-configuration interpretation fails. | proof-step | |
| src-Rq-identity | 03-orientation-source.tex:109-114 | prose | Since \(R(xyz)=-xyz\), equivariance and irreducibility of the four-dimensional module give \(Rq_i^{(t)}=-q_i^{(1-t)}\) after transporting the five plane-triple labels. | displayed-identity | |
| src-lift-normalization | 03-orientation-source.tex:115-117 | prose | The lift on \(B_+\) is normalized by \(q_1=xyz\), and the deck-opposite source carries the lift \(-\iota_t\). | definition | |
| src-lift-agrees-at-xyz | 03-orientation-source.tex:117-120 | prose | The exchanger calculation shows this lift normalization agrees with golden conjugation at \([xyz]\), so the lift is part of the oriented source datum rather than a global marking of the second family. | proof-step | |
| src-beta-lands-in-eigenspace | 03-orientation-source.tex:122-126 | prose | The primitive integral map \(\beta(y)_{ij}=y_i+y_j\) lands in the Petersen \((-2)\)-eigenspace. | proof-step | |
| src-beta-norm-identity | 03-orientation-source.tex:126-131 | prose | \(\sum_{i<j}(y_i+y_j)^2=3\sum_i y_i^2\). | displayed-identity | |
| src-beta-inverse | 03-orientation-source.tex:126-131 | prose | \(y_i=\frac13\sum_{j\ne i}\beta(y)_{ij}\). | displayed-identity | |
| src-multiplicity-one-unique | 03-orientation-source.tex:132-133 | prose | Multiplicity one makes the comparison unique once the five labels and the normalization are fixed. | proof-step | |
| src-reversal-chain | 03-orientation-source.tex:133-135 | prose | Reversing the chart lift reverses \(y\), the zonal harmonic \(F_y\), and its cubic integral. | proof-step | |
| src-two-signs-select | 03-orientation-source.tex:134-136 | prose | The two signs in the normalized incidence cover select the two signs of the exact Gaunt cubic relative to \(\mathfrak m\). | proof-step | |

## Section 4, Arithmetic specialization (`sections/04-arithmetic-specialization.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| ar-exchange-visible | 04-arithmetic-specialization.tex:4-6 | prose | The two icosahedral six-axis configurations attached to the cubic \(xyz\) are Galois conjugate over \(\Q(\sqrt5)\). | proof-step | |
| ar-exchanger-def | 04-arithmetic-specialization.tex:6-7 | prose | The exchanger is the projective orthogonal transformation carrying one configuration to the other. | definition | |
| ar-spinor-class-preview | 04-arithmetic-specialization.tex:7-9 | prose | Over a finite field where the configurations become rational, the exchanger has spinor class \([2]\), and modulo \(11\) this class is nontrivial. | main-theorem-clause | |
| ar-config-means-six-set | 04-arithmetic-specialization.tex:15-18 | prose | The six projective points of \(I_t\) are its axes through opposite vertices, so an icosahedral configuration here means the unordered six-set \(I_t\). | definition | |
| ar-cover-point-records-six-set | 04-arithmetic-specialization.tex:17-19 | prose | A point of the incidence cover records one chosen six-set, and the two points over \(xyz\) correspond to the two conjugate configurations. | definition | |
| gf-on-xyz | 04-arithmetic-specialization.tex:21-22 | Proposition 4.1 (prop:golden-fibre) | The points of \(I_t\) lie on the cubic \(xyz=0\). | main-theorem-clause | |
| gf-common-norm | 04-arithmetic-specialization.tex:21-22 | Proposition 4.1 | The displayed representatives of \(I_t\) have a common nonzero norm. | main-theorem-clause | |
| gf-normalized-inner-product | 04-arithmetic-specialization.tex:21-22 | Proposition 4.1 | The points of \(I_t\) have normalized squared inner product \(1/5\). | exact-constant | |
| gf-six-arc | 04-arithmetic-specialization.tex:22 | Proposition 4.1 | The six points of \(I_t\) form a six-arc, that is, every three of them are independent. | main-theorem-clause | |
| gf-conjugate-over-E | 04-arithmetic-specialization.tex:22-28 | Proposition 4.1 | The two configurations are conjugate geometric configurations defined over \(\Q[t]/(t^2-t-1)=\Q(\sqrt5)\) and are exchanged by its nontrivial automorphism. | main-theorem-clause | |
| gf-complete-fibre | 04-arithmetic-specialization.tex:28-29 | Proposition 4.1 | In Hitchin's incidence cover the two configurations form the complete fibre over \([xyz]\). | main-theorem-clause | Hitchin (classification) |
| gfp-zero-coordinate | 04-arithmetic-specialization.tex:33 | proof of Prop 4.1 | Every displayed representative vector has one zero coordinate. | proof-step | |
| gfp-norm-value | 04-arithmetic-specialization.tex:33-35 | proof of Prop 4.1 | Since \(t^2=t+1\), each displayed representative has squared norm \(t^2+1=t+2\). | exact-constant | |
| gfp-inner-product-pm-t | 04-arithmetic-specialization.tex:35-37 | proof of Prop 4.1 | The inner product of two distinct displayed representatives is \(\pm t\), and one squared inner-product check suffices because the \(A_5\)-action is transitive on pairs of distinct projective axes. | proof-step | |
| gfp-t-plus-2-squared | 04-arithmetic-specialization.tex:37-39 | proof of Prop 4.1 | \((t+2)^2=5(t+1)=5t^2\). | displayed-identity | |
| gfp-ratio-one-fifth | 04-arithmetic-specialization.tex:40-41 | proof of Prop 4.1 | The normalized squared inner product is \(1/5\). | exact-constant | |
| gfp-gram-determinant | 04-arithmetic-specialization.tex:41-47 | proof of Prop 4.1 | For any triple with triangle sign \(\epsilon=\pm1\), the signed Gram determinant equals \((t+2)^3-3(t+2)t^2+2\epsilon t^3\), which is \(4t^4\) when \(\epsilon=1\) and \(4t^2\) when \(\epsilon=-1\). | displayed-identity | |
| gfp-triples-independent | 04-arithmetic-specialization.tex:48 | proof of Prop 4.1 | The Gram determinant is nonzero, so every triple of the six axes is independent. | proof-step | |
| gfp-twenty-reduce-to-one | 04-arithmetic-specialization.tex:40-41 | proof of Prop 4.1 | The twenty three-point checks reduce to one signed Gram determinant. | proof-step | |
| ar-six-arc-char-not-two | 04-arithmetic-specialization.tex:53-54 | prose | The six-arc conclusion remains valid after reduction in every characteristic other than \(2\). | proof-step | |
| ar-metric-excludes-five | 04-arithmetic-specialization.tex:54-56 | prose | The metric interpretation additionally excludes characteristic \(5\), where \(t^2-t-1\) is inseparable and the common norm \(t+2\) vanishes. | proof-step | |
| ar-complete-fibre-not-extended | 04-arithmetic-specialization.tex:56-59 | prose | The comparison with Hitchin's geometric incidence cover is available in characteristic zero and, after spreading out, only away from an unspecified finite set of primes. | definition (scope) | |
| ar-R-matrix | 04-arithmetic-specialization.tex:63-71 | prose | The exchanger is the matrix \(R=\begin{pmatrix}1&0&0\\0&0&-1\\0&1&0\end{pmatrix}\). | definition | |
| ar-R-carries-configs | 04-arithmetic-specialization.tex:72-76 | prose | The relation \(1-t=-1/t\) gives \(R(I_t)=I_{1-t}\), \(R^2=\operatorname{diag}(1,-1,-1)\), and \(R^4=1\). | displayed-identity | |
| ar-R-negates-xyz | 04-arithmetic-specialization.tex:77-78 | prose | \(R(xyz)=-xyz\), so \(R\) fixes the projective cubic \(xyz=0\) and exchanges its two configurations. | proof-step | |
| ar-finite-field-splitting | 04-arithmetic-specialization.tex:82-85 | prose | If \(k\) is a finite field of odd characteristic other than \(5\) in which \(5\) is a square, then \(t^2-t-1\) has two distinct roots in \(k\) and the displayed equations give two rational configurations exchanged by \(R\). | proof-step | |
| sp-spinor-class-two | 04-arithmetic-specialization.tex:88 | Proposition 4.2 (prop:spinor-specialization) | The spinor class of \(R\) is \([2]\in k^\times/k^{\times2}\). | main-theorem-clause | |
| sp-identification | 04-arithmetic-specialization.tex:88-94 | Proposition 4.2 | Under \(\operatorname{SO}_3(k)/\Omega_3(k)\cong\operatorname{PGL}_2(k)/\operatorname{PSL}_2(k)\), the exchanger lies outside \(\operatorname{PSL}_2(k)\) exactly when \(2\) is a nonsquare in \(k\). | main-theorem-clause | |
| sp-mod-11 | 04-arithmetic-specialization.tex:95-99 | Proposition 4.2 | Over \(\F_{11}\) the exchanger represents the nontrivial element of \(T_{11}=\operatorname{PGL}_2(11)/\PSL_2(11)\). | main-theorem-clause | |
| spp-reflection-spinor | 04-arithmetic-specialization.tex:103-104 | proof of Prop 4.2 | For \(Q(x,y,z)=x^2+y^2+z^2\), reflection in a vector \(v\) has spinor class \(Q(v)\). | proof-step | |
| spp-factorization | 04-arithmetic-specialization.tex:104-107 | proof of Prop 4.2 | On the \(yz\)-plane, \(R=s_{e_2}s_{e_2-e_3}\). | displayed-identity | |
| spp-theta-value | 04-arithmetic-specialization.tex:107-112 | proof of Prop 4.2 | \(\theta(R)=Q(e_2)Q(e_2-e_3)=2\) in \(k^\times/k^{\times2}\). | exact-constant | |
| spp-standard-isos | 04-arithmetic-specialization.tex:113-120 | proof of Prop 4.2 | The standard identifications \(\operatorname{SO}_3(k)\cong\operatorname{PGL}_2(k)\) and \(\Omega_3(k)\cong\operatorname{PSL}_2(k)\) identify the spinor quotient with the projective quotient. | proof-step | |
| spp-mod-11-roots | 04-arithmetic-specialization.tex:120-122 | proof of Prop 4.2 | The roots of \(t^2-t-1\) modulo \(11\) are \(4\) and \(8\), and \(2\) is a nonsquare modulo \(11\). | exact-constant | |
| ar-class-forced-by-conjugacy | 04-arithmetic-specialization.tex:125-127 | prose | The class \([2]\) is forced by the orthogonal conjugacy class of the quarter-turn on the \(yz\)-plane, and the two reflections merely evaluate its spinor norm. | proof-step | |
| ar-two-characters | 04-arithmetic-specialization.tex:129-133 | prose | The degree-two parameter algebra \(k[t]/(t^2-t-1)\) with deck involution \(t\mapsto1-t\) has discriminant class \([5]\), and its two configurations are rational exactly when that torsor splits. | proof-step | |
| ar-R-realizes-deck | 04-arithmetic-specialization.tex:133-134 | prose | The rational orthogonal element \(R\) realizes the deck involution on the configurations and has spinor character \([2]\). | proof-step | |
| ar-dye-same-boundary | 04-arithmetic-specialization.tex:134-135 | prose | Dye's existence criterion for Clebsch hexagons has the same \([5]\) boundary. | literature-attribution | Dye, Theorem 1 (DyeClebsch) |
| ar-point-count | 04-arithmetic-specialization.tex:138-143 | prose (Integral boundary) | Over a finite field of characteristic different from \(2\) and \(5\), the fibre of \(z^2=5J(f)\) over a rational point \(f\) satisfies \(\#\mathcal Q_f(\F_q)=1+\chi_q(5J(f))\). | displayed-identity | |
| ar-geometric-interp-limited | 04-arithmetic-specialization.tex:143-148 | prose | The geometric interpretation of that point count over finite fields is proved only away from an unspecified finite set of primes, and the finite exceptional set is not replaced by \(p\ne2,5\). | definition (scope) | |

## Section 5, The golden operator and its cubic shadows (`sections/05-golden-operator.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| op-three-operations | 05-golden-operator.tex:4-9 | prose | Applying middle exterior power, commutator with the diagonal algebra, and centered squaring to the marked conference operator produces the Joubert, Segre, Igusa, and diagonal Clebsch models in one calculation. | main-theorem-clause | |
| op-AX-definition | 05-golden-operator.tex:15-16 | prose | For the ordered six-axis set \(X\), the carrier space is \(A_X=\Q^X/\Q\mathbf1\). | definition | |
| op-outer-six-set | 05-golden-operator.tex:16-18 | prose | The outer six-set \(\mathcal T\) consists of the six synthematic totals, that is, the six labelled one-factorizations of the fixed labelled graph \(K_X\). | definition | |
| op-mystic-pentagons | 05-golden-operator.tex:19 | prose | The six synthematic totals are the classical mystic pentagons. | literature-attribution | classical (HMSV) |
| op-epsilon-definition | 05-golden-operator.tex:19-23 | prose | Each total \(T\) has a complementary triangle colouring assigning signs \(\epsilon_T(S)\in\{\pm1\}\) to three-subsets \(S\subset X\), with the global sign fixed by the marked outer orientation. | definition | |
| op-epsilon-four-point | 05-golden-operator.tex:23 | prose | The signs \(\epsilon_T\) obey the four-point two-graph identity. | proof-step | |
| op-epsilon-equivariance | 05-golden-operator.tex:23-27 | prose | \(\epsilon_{gT}(gS)=\operatorname{sgn}(g)\epsilon_T(S)\) for \(g\in S_X\). | displayed-identity | HMSV, Sections 1.1--1.2, 1.6 |
| op-conference-two-graph-classical | 05-golden-operator.tex:30-32 | prose | The order-six conference two-graph is classical: its switching class has the pentagon-plus-isolated-vertex form and automorphism group \(A_5\). | literature-attribution | Bussemaker--Mathon--Seidel (BMS) |
| op-four-point-reconstructs | 05-golden-operator.tex:33-35 | prose | The four-point identity reconstructs from each \(\epsilon_T\) a switching class of symmetric zero-diagonal sign matrices, and it is the unique order-six conference class. | proof-step | |
| op-CT-square | 05-golden-operator.tex:35-37 | prose | For representatives \(C_T\) whose triangle products are \(\epsilon_T\), with Hodge orientations transported by the ordered axis basis, \(C_T^2=5I\). | displayed-identity | |
| op-coherent-outer-marking | 05-golden-operator.tex:37-39 | prose | These choices constitute the coherent outer marking, and the incidence sheet supplies only its orientation bit, not the outer labels or representatives. | definition (scope) | |
| op-JT-definition | 05-golden-operator.tex:41-45 | prose | \(J_T(x)=\sum_{|S|=3}\epsilon_T(S)x_S\) with \(x_S=\prod_{i\in S}x_i\). | definition | |
| op-table-51 | 05-golden-operator.tex:54-66 | Table (5.1) | The six coefficient words displayed in table (5.1), for \(p_r\in\{012345,012354,012435,012453,012534,012543\}\) and the fixed triple ordering \(012,\dots,345\), are exactly the sign patterns of \(J_{T_r}\). | example | |
| op-table-derivation | 05-golden-operator.tex:69-73 | prose | The identity \(\epsilon_{pT_0}(S)=\operatorname{sgn}(p)\epsilon_{T_0}(p^{-1}S)\), applied to the twenty triangle products of the displayed conference matrix, gives the six rows of table (5.1). | proof-step | |
| op-table-is-joubert-frame | 05-golden-operator.tex:72-76 | prose | The six rows of table (5.1) are the signed coloured-triangle Joubert frame, so the cited source supplies no unstated scalar or sign convention and its six coordinates are exactly the forms \(J_T\). | literature-attribution | HMSV, Sections 1.1--1.2, 1.6 |
| op-conference-definition | 05-golden-operator.tex:81-83 | prose | A symmetric conference matrix of order \(2d\) is a symmetric zero-diagonal matrix with off-diagonal entries in \(\{\pm1\}\) satisfying \(C^2=qI\) with \(q=2d-1\). | definition | |
| op-two-eigenspaces | 05-golden-operator.tex:83-84 | prose | The zero trace of a symmetric conference matrix of order \(2d\) gives two eigenspaces of dimension \(d\). | proof-step | |
| op-cut-block-form | 05-golden-operator.tex:84-88 | prose | For a balanced half \(Y\), ordering coordinates by \((Y,Y^c)\) writes \(C\) in blocks \(\begin{pmatrix}A&R\\R^{\mathsf T}&E\end{pmatrix}\). | definition | |
| op-HY-definition | 05-golden-operator.tex:89-95 | prose | With \(D_Y\) the diagonal sign involution of the cut, \(P_\pm=(I\pm C/\sqrt q)/2\), and an isometry \(Q_+:\mathbf R^d\to\operatorname{im}P_+\), the balanced exchange operator is \(H_Y=Q_+^{\mathsf T}D_YP_-D_YQ_+\). | definition | |
| ber-spectrum-formula | 05-golden-operator.tex:99-105 | Theorem 5.1 (thm:balanced-exchange-rigidity) | \(\Spec(H_Y)=\Spec(\frac1qRR^{\mathsf T})=\{1-\alpha_1^2/q,\dots,1-\alpha_d^2/q\}\) where \(\alpha_1,\dots,\alpha_d\) are the eigenvalues of the block \(A\). | main-theorem-clause | |
| ber-independence-iff | 05-golden-operator.tex:105-107 | Theorem 5.1 | The spectrum of \(H_Y\) is independent of the balanced half \(Y\) if and only if \(d\le3\). | main-theorem-clause | |
| ber-order-six-unique | 05-golden-operator.tex:107-108 | Theorem 5.1 | Order six is the unique nontrivial realized symmetric conference order with cut-independent balanced exchange spectrum. | main-theorem-clause | |
| ber-order-six-spectrum | 05-golden-operator.tex:108-111 | Theorem 5.1 | The order-six exchange spectrum is \(\{1/5,4/5,4/5\}\). | exact-constant | |
| ber-aligned-definition | 05-golden-operator.tex:113-115 | Theorem 5.1 | For a four-set \(K\), \(w(K)\) is the sum of its three signed Hamilton-cycle products, \(K\) is aligned when \(w(K)=3\), and \(c_Y\) counts the aligned four-sets contained in \(Y\). | definition | |
| ber-trace-one | 05-golden-operator.tex:116-118 | Theorem 5.1 | \(\operatorname{tr}(H_Y)=d^2/q\). | displayed-identity | |
| ber-trace-two | 05-golden-operator.tex:116-123 | Theorem 5.1 | \(\operatorname{tr}(H_Y^2)=(F_d+32c_Y)/q^2\) where \(F_d=dq^2-2qd(d-1)+d(d-1)+12\binom d3-8\binom d4\). | displayed-identity | |
| ber-moment-conclusion | 05-golden-operator.tex:124-125 | Theorem 5.1 | The first exchange moment is universal, whereas the second is cut-independent exactly in the stated small orders. | main-theorem-clause | |
| berp-commutator-anticommutes | 05-golden-operator.tex:129-131 | proof of Thm 5.1 | With \(Q=C/\sqrt q\) and \(L=[D_Y,Q]\), the commutator anticommutes with \(Q\), and on the positive eigenspace \(Lv=2P_-D_Yv\). | proof-step | |
| berp-L-block-form | 05-golden-operator.tex:131-135 | proof of Thm 5.1 | In cut coordinates \(L=\frac2{\sqrt q}\begin{pmatrix}0&R\\-R^{\mathsf T}&0\end{pmatrix}\). | displayed-identity | |
| berp-4H-is-LstarL | 05-golden-operator.tex:136-138 | proof of Thm 5.1 | \(4H_Y\) is \(L^*L\) restricted to the positive eigenspace, so \(H_Y\) has the squared singular values of \(R/\sqrt q\). | proof-step | |
| berp-block-identity | 05-golden-operator.tex:138-142 | proof of Thm 5.1 | The \(Y\)-principal block of \(C^2=qI\) gives \(RR^{\mathsf T}=qI-A^2\). | displayed-identity | |
| berp-classical-block-relations | 05-golden-operator.tex:142-143 | proof of Thm 5.1 | Complementary principal-block spectral relations of this kind are classical. | literature-attribution | Haemers--Parsaei Majd (HaemersParsaeiMajd) |
| berp-trA2 | 05-golden-operator.tex:145-147 | proof of Thm 5.1 | Since \(A\) is a zero-diagonal sign matrix, \(\operatorname{tr}(A^2)=d(d-1)\). | exact-constant | |
| berp-trA4 | 05-golden-operator.tex:147-151 | proof of Thm 5.1 | Sorting closed four-walks by support gives \(\operatorname{tr}(A^4)=d(d-1)+12\binom d3+8\sum_{K\subset Y,|K|=4}w(K)\). | displayed-identity | |
| berp-w-values | 05-golden-operator.tex:152-153 | proof of Thm 5.1 | Every edge occurs twice in the product of the three cycle signs, so \(w(K)\in\{3,-1\}\). | proof-step | |
| berp-closed-walk-credit | 05-golden-operator.tex:154-156 | proof of Thm 5.1 | The closed-walk organization used here is the exact finite version of the one used for conference-frame subensembles. | literature-attribution | Magsino--Mixon--Parshall (MagsinoMixonParshall) |
| berp-inclusion-rank | 05-golden-operator.tex:158-163 | proof of Thm 5.1 | If \(d\ge4\) and the second exchange moment is \(Y\)-independent, then the sums of the aligned-four-set indicator over all balanced halves are equal, and full column rank of the characteristic-zero four-set-to-\(d\)-set inclusion matrix forces the indicator to be constant on four-sets. | proof-step | Jolliffe, Theorem 1 (JolliffeInclusion) |
| berp-switch-rooted | 05-golden-operator.tex:163-167 | proof of Thm 5.1 | After switching \(C\) so that all edges at a vertex \(\infty\) are positive, the four-set \(\{\infty,i,j,k\}\) with remaining edge signs \(x,y,z\) has \(w=xy+xz+yz\). | displayed-identity | |
| berp-value-3-contradiction | 05-golden-operator.tex:168-170 | proof of Thm 5.1 | If the common value of \(w\) is \(3\), every triangle on the other \(2d-1\) vertices is monochromatic, making the inner product of two conference rows equal to \(2d-2\), a contradiction. | proof-step | |
| berp-value-minus1-ramsey | 05-golden-operator.tex:170-173 | proof of Thm 5.1 | If the common value of \(w\) is \(-1\), the two-colouring has no monochromatic triangle, so \(R(3,3)=6\) gives \(2d-1\le5\), a contradiction. | proof-step | classical Ramsey \(R(3,3)=6\) |
| berp-d1-d2 | 05-golden-operator.tex:175-176 | proof of Thm 5.1 | For \(d=1\) the conclusion is immediate, and for \(d=2\) every two-by-two principal sign block squares to \(I\). | proof-step | |
| berp-d3-identity | 05-golden-operator.tex:176-180 | proof of Thm 5.1 | For \(d=3\) with \(\tau\) the product of the three edge signs, \(A^2=2I+\tau A\). | displayed-identity | |
| berp-d3-charpoly | 05-golden-operator.tex:181-183 | proof of Thm 5.1 | For \(d=3\), \(\det(tI-A)=t^3-3t-2\tau\), which factors as \((t-2)(t+1)^2\) or \((t+2)(t-1)^2\), so \(A^2\) always has spectrum \(\{4,1,1\}\). | proof-step | |
| berp-d3-exchange-spectrum | 05-golden-operator.tex:183-184 | proof of Thm 5.1 | For \(d=3\) the spectral formula gives exchange spectrum \(\{1/5,4/5,4/5\}\). | exact-constant | |
| op-greaves-suda-design | 05-golden-operator.tex:187-190 | prose | The determinant-\((-3)\) four-subsets of a symmetric conference matrix form a \(3\)-\((2d,4,(d-3)/2)\) design. | literature-attribution | Greaves--Suda, Example 2.3 (GreavesSuda) |
| op-det-w-identity | 05-golden-operator.tex:190-191 | prose | The identity \(\det C[K]=3-2w(K)\) identifies the determinant-\((-3)\) blocks with the aligned four-sets. | displayed-identity | |
| op-two-graph-parameters | 05-golden-operator.tex:192-193 | prose | The regular-two-graph parameters give the same identification of blocks with aligned four-sets. | literature-attribution | Gillespie, Section 2.2 and Prop 4.1 (GillespieTwoGraph) |
| op-expectation-cY | 05-golden-operator.tex:193-201 | prose | For a uniformly chosen balanced half and \(d\ge4\), \(\mathbf E c_Y=\rho\binom d4\) with \(\rho=(d-3)/(2(2d-3))\). | displayed-identity | Johnson-scheme inclusion calculus (IntersectionMatrices, Section 8) |
| op-variance-cY | 05-golden-operator.tex:193-202 | prose | For a uniformly chosen balanced half and \(d\ge4\), \(\operatorname{Var}(c_Y)=\frac{\binom{2d}4\binom{2d-8}{d-4}}{\binom{2d}d}\rho(1-\rho)\). | displayed-identity | Johnson-scheme inclusion calculus |
| op-complement-invariance | 05-golden-operator.tex:203 | prose | The moment formulas also hold modulo complementation because \(c_Y=c_{Y^c}\). | proof-step | |
| op-order-ten-moments | 05-golden-operator.tex:204-206 | prose | At order ten, \(\mathbf E c_Y=5/7\) and \(\operatorname{Var}(c_Y)=10/49\), hence \(\mathbf E[c_Y(c_Y-1)]=0\). | exact-constant | |
| op-cY-zero-or-one | 05-golden-operator.tex:206-207 | prose | Since \(c_Y\) is a nonnegative integer with vanishing second factorial moment at order ten, it is \(0\) or \(1\) on every cut. | proof-step | |
| op-126-split | 05-golden-operator.tex:207-208 | prose | The 126 projective cuts at order ten split into 36 with \(c_Y=0\) and 90 with \(c_Y=1\). | exact-constant | |
| op-design-fixes-second-moment-only | 05-golden-operator.tex:208-209 | prose | The known design fixes this second-moment split without making the complete higher-order spectrum uniform. | proof-step | |
| op-two-graph-definition | 05-golden-operator.tex:213-219 | prose | A two-graph on a finite set \(V\) is a function \(\tau:\binom V3\to\mathbf F_2\) with \(\sum_{S\in\binom Q3}\tau(S)=0\) for every four-set \(Q\). | definition | |
| op-A-tau-definition | 05-golden-operator.tex:219-221 | prose | \(\mathcal A(\tau)\) is the family of four-sets on which all four values of \(\tau\) are equal, and complementing \(\tau\) preserves this family. | definition | |
| adf-determines-up-to-complement | 05-golden-operator.tex:225-226 | Theorem 5.2 (thm:aligned-faithfulness) | If \(|V|\ge7\), then \(\mathcal A(\tau)\) determines \(\tau\) up to complement. | main-theorem-clause | |
| adf-conference-order-ten | 05-golden-operator.tex:228-231 | Theorem 5.2 | For a symmetric conference matrix of order \(n\ge10\), the marked family of principal four-subsets with determinant \(-3\) determines its signing up to diagonal switching and global negation. | main-theorem-clause | |
| adf-query-count | 05-golden-operator.tex:231-235 | Theorem 5.2 | After one aligned four-set \(Q\) is known, the \(1+4(n-4)+6\binom{n-4}2=3n^2-23n+45\) tests on four-sets meeting \(Q\) in at least two points suffice. | displayed-identity | |
| adf-anchor-twenty | 05-golden-operator.tex:236-237 | Theorem 5.2 | An aligned anchor is found deterministically with at most twenty tests, so the complete marked reconstruction uses \(O(n^2)\) selected determinants. | main-theorem-clause | |
| adf-triangle-calibration | 05-golden-operator.tex:238 | Theorem 5.2 | One calibrated triangle product selects between the two global orientations. | main-theorem-clause | |
| adfp-rooted-graph | 05-golden-operator.tex:242-246 | proof of Thm 5.2 | For a fixed root \(r\), the graph \(G_r\) on \(V\setminus\{r\}\) with edges \(ij\) when \(\tau(rij)=1\) satisfies \(\tau(ijk)=\tau(rij)+\tau(rik)+\tau(rjk)\). | displayed-identity | |
| adfp-aligned-iff-clique | 05-golden-operator.tex:247-249 | proof of Thm 5.2 | The four-set \(\{r,i,j,k\}\) is aligned exactly when \(ijk\) is a clique or an independent triple of \(G_r\). | proof-step | |
| adfp-ramsey-anchor | 05-golden-operator.tex:248-249 | proof of Thm 5.2 | The equality \(R(3,3)=6\) supplies an aligned anchor on every seven-set. | proof-step | classical Ramsey |
| adfp-normalized-cut | 05-golden-operator.tex:251-259 | proof of Thm 5.2 | After fixing an aligned \(Q=\{1,2,3,4\}\), complementing if necessary, and switching so both candidates vanish on \(Q\) and each outside vertex has zero edge to vertex \(4\), each outside point \(x\) determines a uniquely normalized cut \(p_x=(e_{1x},e_{2x},e_{3x},e_{4x})\in\mathbf F_2^4\) with \((p_x)_4=0\). | proof-step | |
| adfp-signature-table | 05-golden-operator.tex:260-269 | proof of Thm 5.2, table | The four tests meeting \(Q\) in three points have the displayed complete signature table: cut \(0000\) gives aligned triples \(123,124,134,234\); \(1000\) gives \(234\); \(0100\) gives \(134\); \(0010\) gives \(124\); \(1110\) gives \(123\); and \(1100\), \(1010\), \(0110\) give none. | example | |
| adfp-balanced-ambiguity | 05-golden-operator.tex:270-272 | proof of Thm 5.2 | Those tests recover \(p_x\) except that the three balanced cuts \(B_{12}=1100\), \(B_{13}=1010\), \(B_{14}=0110\) share the same empty signature. | proof-step | |
| adfp-criterion-52 | 05-golden-operator.tex:274-282 | proof of Thm 5.2, eq (5.2) | For outside points \(x,y\) with \(p=p_x\), \(s=p_y\), \(e=e_{xy}\), a pair \(ij\subset Q\) lies in \(\mathcal B(p,s,e)\) if and only if \(p_i+s_i=p_j+s_j\) and \(e=p_j+s_i\). | displayed-identity | |
| adfp-known-cuts-recover-e | 05-golden-operator.tex:283-286 | proof of Thm 5.2 | If \(p\) and \(s\) are known, some pair satisfies \(p_i+s_i=p_j+s_j\) and exactly one value of \(e\) makes that pair aligned. | proof-step | |
| adfp-one-balanced-table | 05-golden-operator.tex:286-298 | proof of Thm 5.2, table | The displayed six-row table of \(\mathcal B(p,s,0)\) and \(\mathcal B(p,s,1)\) for \(p\in\{0000,1000\}\) and \(s\in\{B_{12},B_{13},B_{14}\}\) recovers both the balanced cut and \(e\). | example | |
| adfp-two-balanced-table | 05-golden-operator.tex:299-311 | proof of Thm 5.2, table | The displayed table for unordered pairs of balanced cuts has pairwise distinct rows. | example | |
| adfp-only-order-lost | 05-golden-operator.tex:311-314 | proof of Thm 5.2 | The sole loss of information is the order of two distinct balanced cuts, since interchanging \(p\) and \(s\) preserves the six pair tests and leaves \(e\) fixed. | proof-step | |
| adfp-three-outside-points | 05-golden-operator.tex:315-322 | proof of Thm 5.2 | With three outside points, assuming one cut changes between two candidates forces the other two cuts to be equal to the changed cut and yields a contradiction, so no cut changes. | proof-step | |
| adfp-edges-recovered | 05-golden-operator.tex:321-322 | proof of Thm 5.2 | Once no cut changes, criterion (5.2) recovers every outside edge, so the two candidates agree after the initial possible complement. | proof-step | |
| adfp-johnson-glue | 05-golden-operator.tex:324-327 | proof of Thm 5.2 | For larger \(V\), adjacent seven-sets in the connected Johnson graph share six vertices, and on any triple in that intersection the two restrictions cannot choose opposite complement conventions, so complement choices agree globally. | proof-step | |
| adfp-decoder | 05-golden-operator.tex:328-337 | proof of Thm 5.2 | The proof is also a decoder: testing the twenty four-sets formed by a root and a triple of six other vertices finds an anchor, querying four-sets meeting the anchor in at least two points reconstructs one seven-set, and each remaining vertex is handled by the same tables, so the number of selected tests is exactly the quadratic count of the theorem. | proof-step | |
| adfp-conference-transfer | 05-golden-operator.tex:339-344 | proof of Thm 5.2 | For a conference signing, \(\det C[Q]=3-2w(Q)\) identifies the determinant-\((-3)\) family with \(\mathcal A(\tau)\); rooting and switching recovers every matrix entry from rooted triangle values; the remaining complement sends \(C\) to \(-C\), which one triangle product fixes. | proof-step | |
| op-four-hypomorphy | 05-golden-operator.tex:347-350 | prose | On four vertices a two-graph has zero, two, or four triples, so equality of aligned families is exactly four-hypomorphy up to complementation within the class of two-graphs. | proof-step | |
| op-dammak-graphs | 05-golden-operator.tex:349-352 | prose | The analogous four-local reconstruction theorem for ordinary graphs is known. | literature-attribution | Dammak, Lopez, Pouzet, Si Kaddour (DammakGraphHypomorphy) |
| op-pouzet-five | 05-golden-operator.tex:352-354 | prose | For arbitrary 3-uniform hypergraphs the least local size yielding eventual reconstruction is five. | literature-attribution | Pouzet--Si Kaddour (PouzetHypergraphIsomorphy) |
| op-parity-lowers-threshold | 05-golden-operator.tex:354-356 | prose | The two-graph parity axiom lowers that general threshold from five to four, with ambient order seven sharp. | main-theorem-clause | |
| op-homogeneous-triples-credit | 05-golden-operator.tex:356-358 | prose | The homogeneous-triple analysis of ordinary graphs supplies the one-anchor viewpoint, and the away-from-anchor tests here remove its balanced-cut ambiguity. | literature-attribution | Pouzet (PouzetHomogeneousTriples) |
| op-novelty-oper4 | 05-golden-operator.tex:360-363 | prose | The sharp two-graph specialization was not located in the bounded literature audit, whose search depth and access gaps are recorded in ledger row OPER-4; no priority is claimed for the general hypomorphy framework or the homogeneous-triple method. | verification-claim | |
| op-spectral-monomorphy-neighbor | 05-golden-operator.tex:365-368 | prose | The neighboring framework is spectral monomorphy of principal submatrices, whereas here only the squared spectrum is assumed constant. | literature-attribution | Attas; Boussairi (AttasSpectralMonomorphy, BoussairiTwoGraphs) |
| op-novelty-oper3 | 05-golden-operator.tex:368-371 | prose | The balanced singular-spectral classification was not located in that literature within the bounded search recorded in ledger row OPER-3, while the block identity, closed-walk expansion, inclusion rank, and aligned design are credited to their sources. | verification-claim | |
| op-invariant-forgets-signs | 05-golden-operator.tex:373-377 | prose | The exchange invariant sees only \(A^2\), equivalently \(RR^{\mathsf T}\), so cut-independent squared singular spectrum, determinant orientation, and the cubic shadows are distinct claims. | definition (scope) | |
| op-KT-ZT-definitions | 05-golden-operator.tex:381-387 | prose | \(K_T=*\!\bigwedge^3C_T\), \(Z_T(x)=\frac14\sum_{|S|=3}(K_T)_{SS}x_S\), and \(D_x=\operatorname{diag}(x)\). | definition | |
| op-hodge-transport | 05-golden-operator.tex:388-391 | prose | The Hodge orientation is transported with the ordered axis basis, so an odd relabelling or switching transports both \(K_T\) and the sign of its diagonal; switching the matrix while holding the old Hodge convention fixed is not legitimate. | definition (scope) | |
| fig2-four-formulas | 05-golden-operator.tex:405-414 | Figure 2 boxes | The four normalized formulas \(\sum_S\epsilon_T(S)x_S\), \(\frac14\sum_S(K_T)_{SS}x_S\), \(\frac14\operatorname{Pf}[D_x,C_T]\), and \(\pm10\sqrt5\det B_T(x)\) all equal \(Z_T\), and \(Z_T=J_T\). | displayed-identity | |
| fig2-segre-relations | 05-golden-operator.tex:422-423 | Figure 2 box | The six outer coordinates satisfy \(\sum_TZ_T=\sum_TZ_T^3=0\), the Segre cubic. | displayed-identity | |
| fig2-orientation-selects-sign | 05-golden-operator.tex:437-438 | Figure 2 caption | The transported determinant-line orientation selects the sign in the cross-golden determinant formula. | definition (scope) | |
| os-hodge-diagonal | 05-golden-operator.tex:446-450 | Theorem 5.3 (thm:operator-shadows), part 1 | For \(S=\{i,j,k\}\), \((K_T)_{SS}=4(C_T)_{ij}(C_T)_{jk}(C_T)_{ki}=4\epsilon_T(S)\). | displayed-identity | |
| os-Z-equals-J | 05-golden-operator.tex:450-451 | Theorem 5.3, part 1 | \(Z_T=J_T\) is the switching-invariant orientation cubic on \(A_X\). | main-theorem-clause | |
| os-recover-switching-class | 05-golden-operator.tex:452-454 | Theorem 5.3, part 1 | The four-point two-graph identity and pair balance recover the conference switching class, and after fixing a vertex the negative edges on the other five vertices form a pentagon. | main-theorem-clause | |
| os-pfaffian | 05-golden-operator.tex:455-460 | Theorem 5.3, part 2 | \(\operatorname{Pf}[D_x,C_T]=4Z_T(x)\). | displayed-identity | |
| os-determinant-square | 05-golden-operator.tex:458-460 | Theorem 5.3, part 2 | \(\det[D_x,C_T]=16Z_T(x)^2\). | displayed-identity | |
| os-BT-definition | 05-golden-operator.tex:461-464 | Theorem 5.3, part 2 | Over \(E=\Q(\sqrt5)\), with \(P_{T,\pm}=(I\pm C_T/\sqrt5)/2\), the cross-golden operator is \(B_T(x)=P_{T,-}D_xP_{T,+}\). | definition | |
| os-cross-golden-determinant | 05-golden-operator.tex:464-466 | Theorem 5.3, part 2 | After orienting the two determinant lines, \(Z_T(x)=\pm10\sqrt5\det B_T(x)\). | displayed-identity | |
| os-linear-relation | 05-golden-operator.tex:467-470 | Theorem 5.3, part 3 | The six coordinates satisfy \(\sum_TZ_T=0\). | displayed-identity | |
| os-cubic-relation | 05-golden-operator.tex:467-470 | Theorem 5.3, part 3 | The six coordinates satisfy \(\sum_TZ_T^3=0\). | displayed-identity | |
| os-joubert-segre-map | 05-golden-operator.tex:471-475 | Theorem 5.3, part 3 | The six coordinates are the signed Joubert coordinates and define the classical map from six labelled points to the Segre cubic \(\{[z]\in\mathbf P^5:\sum_Tz_T=\sum_Tz_T^3=0\}\). | main-theorem-clause | |
| os-clebsch-section | 05-golden-operator.tex:476-478 | Theorem 5.3, part 3 | Inside the hyperplane \(z_T=0\) of the Segre cubic, the remaining linear relation cuts the ambient space to \(\mathbf P^3\) and the remaining cubic equation is the diagonal Clebsch cubic surface. | main-theorem-clause | |
| os-WT-definition | 05-golden-operator.tex:479-483 | Theorem 5.3, part 4 | The centered determinants are \(W_T=Z_T^2-\frac16\sum_UZ_U^2=\frac1{16}\operatorname{center}_T\det[D_x,C_T]\). | displayed-identity | |
| os-W-linear-relation | 05-golden-operator.tex:484-489 | Theorem 5.3, part 4 | The centered determinants satisfy \(\sum_TW_T=0\). | displayed-identity | |
| os-W-igusa-relation | 05-golden-operator.tex:484-489 | Theorem 5.3, part 4 | The centered determinants satisfy \((\sum_TW_T^2)^2=4\sum_TW_T^4\). | displayed-identity | |
| os-W-is-polar-map | 05-golden-operator.tex:490 | Theorem 5.3, part 4 | The map \(W\) is the Segre--Igusa polar map. | main-theorem-clause | |
| osp-tight-frame | 05-golden-operator.tex:495-496 | proof of Thm 5.3 | The tight-frame argument gives \(C_T^2=5I\). | proof-step | |
| osp-pair-balance | 05-golden-operator.tex:496-499 | proof of Thm 5.3 | The off-diagonal entries of \(C_T^2=5I\) are the pair-balance identities \(\sum_{k\ne i,j}(C_T)_{ij}(C_T)_{jk}(C_T)_{ki}=0\). | displayed-identity | |
| osp-triangle-invariance | 05-golden-operator.tex:500-502 | proof of Thm 5.3 | Triangle products are unchanged by diagonal switching and obey the four-point identity because every edge of a four-set occurs twice. | proof-step | |
| osp-negative-graph-pentagon | 05-golden-operator.tex:502-505 | proof of Thm 5.3 | In the gauge \((C_T)_{0i}=1\), pair balance forces every vertex among the other five to have two negative incident edges, so the negative graph is a five-cycle, recovering the classical switching-class normal form without enumeration. | proof-step | |
| osp-pfaffian-expansion | 05-golden-operator.tex:507-512 | proof of Thm 5.3 | Expanding the Pfaffian of \([D_x,C_T]\) over perfect matchings, the coefficient of \(x_S\) is the complementary three-minor of \(C_T\), which the Hodge convention makes \((K_T)_{SS}\); two dihedral representatives and complementation give \((K_T)_{SS}=4(C_T)_{ij}(C_T)_{jk}(C_T)_{ki}\), so the Pfaffian is \(4Z_T\) and squaring gives the determinant identity. | proof-step | |
| osp-block-form | 05-golden-operator.tex:514-522 | proof of Thm 5.3 | Relative to the projector splitting, \([D_x,C_T]=\begin{pmatrix}0&-2\sqrt5\,B_T(x)^{\mathsf T}\\2\sqrt5\,B_T(x)&0\end{pmatrix}\). | displayed-identity | |
| osp-Z-squared-500 | 05-golden-operator.tex:522-525 | proof of Thm 5.3 | Comparison with \(16Z_T^2\) gives \(Z_T^2=500\det(B_T)^2\), and the chosen determinant-line orientation fixes the displayed sign. | exact-constant | |
| osp-coefficientwise | 05-golden-operator.tex:527-530 | proof of Thm 5.3 | The matching expansion gives \(Z_T=J_T\) coefficient by coefficient, so table (5.1) identifies the six operator cubics with the signed Joubert coordinates including their normalization and the rule \(gZ_T=\operatorname{sgn}(g)Z_{gT}\). | proof-step | |
| osp-segre-classical | 05-golden-operator.tex:530-532 | proof of Thm 5.3 | The Segre relations \(\sum Z_T=\sum Z_T^3=0\) for Joubert coordinates are classical. | literature-attribution | HMSV, Sections 2.1--2.2 |
| osp-set-one-zero | 05-golden-operator.tex:532-533 | proof of Thm 5.3 | Setting one coordinate to zero gives \(\sum_{U\ne T}Z_U=\sum_{U\ne T}Z_U^3=0\), the diagonal Clebsch cubic. | proof-step | |
| osp-igusa-classical | 05-golden-operator.tex:534-536 | proof of Thm 5.3 | The centered-square formula and the symmetric Igusa equation are the classical Segre--Igusa duality map. | literature-attribution | HMSV, Section 2.2, following van der Geer |
| osp-new-identification | 05-golden-operator.tex:536-537 | proof of Thm 5.3 | The determinant identity of the theorem identifies the classical polar vector with the centered commutator determinants. | main-theorem-clause | |
| op-determinant-basis-free | 05-golden-operator.tex:541-543 | prose (Why the determinant) | The map \(B_T(x):V_{T,+}\to V_{T,-}\) is defined without choosing bases, so its determinant is a map between determinant lines and becomes a scalar once those lines are oriented. | proof-step | |
| op-permanent-not-invariant | 05-golden-operator.tex:544-548 | prose | A permanent has no basis-free meaning: changing orthonormal frames sends \(B\) to \(R_-^{\mathsf T}BR_+\), and already for \(B=I_3\) right multiplication by a rotation through \(\theta\) in a coordinate plane changes the permanent from \(1\) to \(\cos(2\theta)\), so the permanent supplies no further cubic shadow. | example | |
| op-no-physical-interpretation | 05-golden-operator.tex:550-552 | prose | No physical or exceptional-group interpretation is used, and the retained chain is incidence descent, conference carrier, classical cubics, and the harmonic return. | definition (scope) | |

## Section 6, The degree-six harmonic realization (`sections/05-harmonic-realization.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| hr-H6-definition | 05-harmonic-realization.tex:4-5 | prose | \(\mathcal H_6\) denotes the real degree-six spherical harmonics on \(S^2\). | definition | |
| hr-section-role | 05-harmonic-realization.tex:5-9 | prose | The marked pair-sum map carries the relative orientation to the Petersen coefficient module, after which the construction passes from icosahedral face axes to \(\mathcal H_6\). | definition (scope) | |
| hr-phi | 05-harmonic-realization.tex:11 | prose | \(\phi=(1+\sqrt5)/2\). | definition | |
| hr-face-axis-vectors | 05-harmonic-realization.tex:14-28 | eq (6.1) face-axis-labels | The ten displayed vectors \(v_{12},\dots,v_{24}\) each have squared norm \(3\), and their projective classes are the ten axes through opposite icosahedral faces. | displayed-identity | |
| hr-unit-representatives | 05-harmonic-realization.tex:29 | prose | The unit representatives are \(u_{ij}=v_{ij}/\sqrt3\). | definition | |
| hr-adjacency-rule | 05-harmonic-realization.tex:29-31 | prose | Two labels are adjacent when the pairs are disjoint, giving the Petersen graph \(KG(5,2)\). | definition | |
| hr-inner-product-dichotomy | 05-harmonic-realization.tex:31-38 | prose | For distinct axes, \((u_{ij}\cdot u_{kl})^2=5/9\) when the label pairs are disjoint and \(1/9\) otherwise, so the labeling is geometric. | exact-constant | |
| hr-conjugate-configuration | 05-harmonic-realization.tex:39-42 | prose | Replacing \(\phi\) by its conjugate gives the conjugate embedded configuration, with abstract Petersen incidence and the displayed formulas unchanged after relabeling; the displayed embedding of the four-space is not claimed to be defined over \(\Q\). | definition (scope) | |
| hr-L-definition | 05-harmonic-realization.tex:44-48 | prose | The zonal map is \(L:\mathbb R^{10}\to\mathcal H_6\), \(L(a)(\omega)=\sum_{i<j}a_{ij}P_6(u_{ij}\cdot\omega)\). | definition | |
| hr-P6-formula | 05-harmonic-realization.tex:49-53 | prose | \(P_6(s)=\frac1{16}(231s^6-315s^4+105s^2-5)\). | displayed-identity | |
| hr-inner-product-normalization | 05-harmonic-realization.tex:54-57 | prose | \(\mathcal H_6\) is equipped with the normalized spherical inner product \(\langle f,g\rangle=\frac1{4\pi}\int_{S^2}fg\,d\omega\). | definition | |
| hm-Fy-definition | 05-harmonic-realization.tex:61-65 | Theorem 6.1 (thm:harmonic-main) | \(F_y(\omega)=\sum_{i<j}(y_i+y_j)P_6(u_{ij}\cdot\omega)\) for the explicitly labelled unit face axes. | definition | |
| hm-petersen-eigenspace | 05-harmonic-realization.tex:66-67 | Theorem 6.1 | The coefficient vectors \((y_i+y_j)_{i<j}\) form the Petersen \((-2)\)-eigenspace. | main-theorem-clause | |
| hm-injective-copy | 05-harmonic-realization.tex:67-68 | Theorem 6.1 | Their zonal harmonics give an injective copy of \(V\) inside \(\mathcal H_6\). | main-theorem-clause | |
| hm-cubic-value | 05-harmonic-realization.tex:69-73 | Theorem 6.1 | \(\frac1{4\pi}\int_{S^2}F_y(\omega)^3\,d\omega=-\frac{784000}{1247103}\sigma_3(y)\). | exact-constant | |
| hmp-kernel-matrix | 05-harmonic-realization.tex:78-84 | proof of Thm 6.1 | The reproducing-kernel matrix satisfies \(K_{ef}=P_6(u_e\cdot u_f)=\frac1{243}(196I+47J-112A)\). | displayed-identity | |
| hmp-P6-values | 05-harmonic-realization.tex:85-86 | proof of Thm 6.1 | \(P_6(1)=1\), \(P_6(\sqrt5/3)=-65/243\), and \(P_6(1/3)=47/243\). | exact-constant | |
| hmp-coefficient-consistency | 05-harmonic-realization.tex:87-88 | proof of Thm 6.1 | The three matrix coefficients contain no further data, since \(196+47=243\) on the diagonal and \(47-112=-65\) on Petersen edges. | proof-step | |
| hmp-addition-theorem | 05-harmonic-realization.tex:89-94 | proof of Thm 6.1 | The addition theorem for spherical harmonics gives \(G_{ef}=\langle P_6(u_e\cdot-),P_6(u_f\cdot-)\rangle=\frac1{13}K_{ef}\). | displayed-identity | classical addition theorem |
| hmp-G-not-K | 05-harmonic-realization.tex:95 | proof of Thm 6.1 | \(G\), not \(K\), is the Gram matrix for the normalized spherical inner product. | proof-step | |
| hmp-two-orbits | 05-harmonic-realization.tex:96-99 | proof of Thm 6.1 | Only two off-diagonal evaluations occur because \(A_5\) is transitive on pairs of two-subsets with intersection zero and with intersection one, so the eigenvalues follow from the Petersen eigenvalues \(3,-2,1\) rather than a ten-by-ten diagonalization. | proof-step | |
| hmp-gram-eigenvalues | 05-harmonic-realization.tex:100-106 | proof of Thm 6.1 | The eigenvalues of \(G\) on \(\mathbb R^{10}\simeq\mathbf1\oplus V_4\oplus V_5\) are \(110/1053\), \(140/1053\), and \(28/1053\) respectively. | exact-constant | |
| hmp-L-injective | 05-harmonic-realization.tex:107 | proof of Thm 6.1 | The Gram eigenvalues are positive, so \(L\) is injective. | proof-step | |
| hmp-petersen-eigenvalues | 05-harmonic-realization.tex:109-110 | proof of Thm 6.1 | The Petersen eigenvalues are \(3,-2,1\) on \(\mathbf1,V_4,V_5\). | exact-constant | classical |
| hmp-eigen-computation | 05-harmonic-realization.tex:110-117 | proof of Thm 6.1 | For \(a_{ij}=y_i+y_j\) with \(\sum_i y_i=0\), \((Aa)_{ij}=\sum_{\{k,l\}\cap\{i,j\}=\varnothing}(y_k+y_l)=-2(y_i+y_j)\), so these vectors form the four-dimensional \((-2)\)-eigenspace. | displayed-identity | |
| hmp-two-transitive-scalar | 05-harmonic-realization.tex:119-123 | proof of Thm 6.1 | Since \(A_5\) acts two-transitively on five letters, an endomorphism of \(\Q^5\) commuting with \(A_5\) has one constant diagonal and one constant off-diagonal entry, so its restriction to \(V\) is scalar. | proof-step | |
| hmp-comparison-is-pair-sum | 05-harmonic-realization.tex:123-128 | proof of Thm 6.1 | Once the five plane triples are identified, every \(A_5\)-equivariant comparison between the arithmetic coordinate module and the Petersen coefficient module is a scalar multiple of \(y\mapsto(y_i+y_j)_{i<j}\). | proof-step | |
| hmp-inverse-formula | 05-harmonic-realization.tex:129-132 | proof of Thm 6.1 | The inverse on the image is \(y_i=\frac13\sum_{j\ne i}a_{ij}\). | displayed-identity | |
| hmp-scalar-cube-one | 05-harmonic-realization.tex:133-135 | proof of Thm 6.1 | Requiring the comparison to preserve \(\sigma_3\) forces the scalar to have cube one, hence to equal one over \(\Q(\sqrt5)\). | proof-step | |
| hmp-comparison-unique | 05-harmonic-realization.tex:135-137 | proof of Thm 6.1 | The abstract comparison is unique with the stated labels and normalization, it supplies no map between the two ambient harmonic spaces, and the selected linear lift fixes its sign. | proof-step | |
| hmp-no-covariant | 05-harmonic-realization.tex:139-145 | proof of Thm 6.1 | If a rotation-equivariant polynomial covariant \(\Phi:H_{\mathbb R}\to\mathcal H_6\) restricted to the displayed Clebsch four-space as the nonzero linear comparison, its degree-one part would have the same restriction, but \(\operatorname{Hom}_{SO_3}(H_{\mathbb R},\mathcal H_6)=0\) since these are nonisomorphic irreducible rotation modules. | proof-step | |
| hmp-A5-is-right-level | 05-harmonic-realization.tex:145-149 | proof of Thm 6.1 | The marked \(A_5\)-intertwiner is exactly the level at which a linear comparison can exist, and no ambient rotation-equivariant polynomial covariant restricts to it. | proof-step | |
| hmp-cubic-invariant-line | 05-harmonic-realization.tex:151-153 | proof of Thm 6.1 | The cubic integral is \(A_5\)-invariant on \(V_4\) and the invariant cubic line is generated by \(\sigma_3\), so one nonzero value determines the scalar. | proof-step | |
| hmp-fixed-line-vector | 05-harmonic-realization.tex:153-155 | proof of Thm 6.1 | The vector \(y=(4,-1,-1,-1,-1)\) spans the fixed line of a point stabilizer and, relative to the marked labels, fixes the scale and sign of the one-vector normalization. | proof-step | |
| hmp-quadratic-ratio | 05-harmonic-realization.tex:155-162 | proof of Thm 6.1 | Pair-sum tightness and the \(V_4\) Gram eigenvalue give \(\langle F_y,F_y\rangle/\sum_i y_i^2=3\cdot(140/1053)=140/351\). | exact-constant | |
| hmp-quadratic-value | 05-harmonic-realization.tex:157-162 | proof of Thm 6.1 | \(\frac1{4\pi}\int F_y^2=2800/351\) for \(y=(4,-1,-1,-1,-1)\). | exact-constant | |
| hmp-cubic-fixed-line | 05-harmonic-realization.tex:163-168 | proof of Thm 6.1 | On the fixed line, \(\frac1{4\pi}\int F_y^3=-15680000/1247103\) and \(\sigma_3(y)=20\). | exact-constant | |
| hmp-moment-formula | 05-harmonic-realization.tex:169-178 | proof of Thm 6.1 | \(\frac1{4\pi}\int_{S^2}\omega_1^{2a}\omega_2^{2b}\omega_3^{2c}\,d\omega=\frac{(2a-1)!!(2b-1)!!(2c-1)!!}{(2a+2b+2c+1)!!}\), and monomials with an odd exponent integrate to zero. | displayed-identity | classical |
| hr-coefficient-factorization | 05-harmonic-realization.tex:180-185 | prose | \(-\frac{784000}{1247103}=-\left(\frac{400}{46189}\right)\left(\frac{1960}{27}\right)\). | exact-constant | |
| hr-first-factor-3j | 05-harmonic-realization.tex:186-187 | prose | The first factor \(400/46189\) is the square of the Wigner 3j symbol \(\begin{pmatrix}6&6&6\\0&0&0\end{pmatrix}\). | exact-constant | |
| hr-46189-factorization | 05-harmonic-realization.tex:188-189 | prose | \(46189=11\cdot13\cdot17\cdot19\) is the universal degree-six Wigner denominator. | exact-constant | |
| hr-second-factor-meaning | 05-harmonic-realization.tex:189-190 | prose | The second factor \(1960/27\) is the one-vector restriction scalar after the unit-axis and primitive pair-sum normalizations have been fixed. | exact-constant | |
| hr-multiplicity-one-reduces | 05-harmonic-realization.tex:191-193 | prose | Multiplicity one is what reduces the whole cubic calculation to the marked fixed line, so \(1960/27\) is a normalization scalar rather than an experimental coincidence. | proof-step | |
| hr-primes-unrelated | 05-harmonic-realization.tex:193-195 | prose | The denominator primes arise from the stated spherical and pair-sum normalizations and are unrelated to the incidence-cover square class. | proof-step | |
| hr-quadratic-factor-3 | 05-harmonic-realization.tex:195-196 | prose | In the quadratic identity, \(3=\|\beta(y)\|^2/\|y\|^2\). | exact-constant | |
| hr-1053-factor-13 | 05-harmonic-realization.tex:196-198 | prose | The second factor in the quadratic identity is the spherical Gram eigenvalue on \(V_4\), and the factor \(13\) in \(1053=13\cdot81\) is \(\dim\mathcal H_6\). | exact-constant | |
| hr-W6-definition | 05-harmonic-realization.tex:200-208 | Remark 6.2 | In the orthonormal Condon--Shortley convention with \(F=\sum_m q_{6m}Y_{6m}\), the bond-order invariant is \(W_6(F)=\sum_{m_1+m_2+m_3=0}\begin{pmatrix}6&6&6\\m_1&m_2&m_3\end{pmatrix}q_{6m_1}q_{6m_2}q_{6m_3}\). | definition | |
| hr-3j-value | 05-harmonic-realization.tex:209-211 | Remark 6.2 | \(\begin{pmatrix}6&6&6\\0&0&0\end{pmatrix}=-20/\sqrt{46189}\). | exact-constant | classical (DLMF) |
| hr-gaunt-conversion | 05-harmonic-realization.tex:211-215 | Remark 6.2 | The Gaunt formula gives \(\int_{S^2}F^3\,d\omega=-\frac{130}{\sqrt{3553\pi}}W_6(F)\). | displayed-identity | |
| hr-standard-invariant | 05-harmonic-realization.tex:216-217 | Remark 6.2 | \(W_6\) is the standard unnormalized degree-six bond-order invariant. | literature-attribution | Steinhardt--Nelson--Ronchetti; DLMF |
| hr-W6-restriction | 05-harmonic-realization.tex:218-223 | Remark 6.2 | \(W_6(F_y)=\frac{313600\pi^{3/2}}{4563\sqrt{3553}}\sigma_3(y)\). | exact-constant | |
| hr-3553-4563 | 05-harmonic-realization.tex:224-226 | Remark 6.2 | \(3553=46189/13\) and \(4563=27\cdot13^2\), both forced by converting the universal Gaunt factor from the normalized spherical inner product to the Condon--Shortley convention. | exact-constant | |

## Section 7, Conclusion (`sections/09-conclusion.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| concl-charts-over-E | 09-conclusion.tex:3-4 | prose | Hitchin's two conjugate Clebsch charts live over \(\Q(\sqrt5)\), where the branch sextic becomes \(16\sigma_3^2\). | main-theorem-clause | |
| concl-xyz-etale | 09-conclusion.tex:4-5 | prose | The common rational point \([xyz]\) of the two charts lies in the finite etale locus of the rational incidence model. | main-theorem-clause | |
| concl-nonsplit-singularity | 09-conclusion.tex:6-7 | prose | The descended union of the two charts has a nonsplit two-branch singularity at \([xyz]\), and its normalization fibre and conductor recover \(\Q(\sqrt5)/\Q\). | main-theorem-clause | |
| concl-sections-map-canonically | 09-conclusion.tex:7-10 | prose | The fixed-configuration sections map the normalization model canonically to the incidence normalization, whose complete reduced fibre determines the remaining rational square class. | main-theorem-clause | |
| concl-specialization-at-11 | 09-conclusion.tex:11-12 | prose | The explicit configurations have a well-defined specialization at \(11\) without requiring a global integral incidence model there. | main-theorem-clause | |
| concl-open-prime-set | 09-conclusion.tex:13-17 | prose | Determining the exact finite set of primes that must be inverted for the geometric incidence comparison remains the integral identification, flatness, normality, and Stein-base-change problem, and is not a defect of the quadratic algebra \(z^2=5J_0\). | definition (scope) | |
| concl-sign-determines-source | 09-conclusion.tex:19-21 | prose | After the outer marking and determinant-line orientations are fixed, the chosen incidence sign determines the oriented conference source on the six axes. | main-theorem-clause | |
| concl-tight-frame-C2 | 09-conclusion.tex:21-22 | prose | The tight frame forces \(C^2=5I\). | displayed-identity | |
| concl-four-same-cubic | 09-conclusion.tex:21-23 | prose | Triangle holonomy, the diagonal of \(*\!\bigwedge^3C\), the commutator Pfaffian, and the cross-golden determinant are the same cubic. | main-theorem-clause | |
| concl-joubert-segre | 09-conclusion.tex:23-24 | prose | The six outer translates are the Joubert coordinates on the Segre cubic. | main-theorem-clause | |
| concl-centered-igusa | 09-conclusion.tex:24-25 | prose | The centered determinants of those translates are the Segre--Igusa polar coordinates. | main-theorem-clause | |
| concl-section-clebsch | 09-conclusion.tex:25-26 | prose | A coordinate section of the Segre cubic is the diagonal Clebsch cubic surface. | main-theorem-clause | |
| concl-order-six-characterized | 09-conclusion.tex:26-28 | prose | The cross-block calculation characterizes order six as the unique nontrivial symmetric conference order whose balanced exchange spectrum is cut-independent. | main-theorem-clause | |
| concl-higher-order-design | 09-conclusion.tex:28-30 | prose | In higher orders the classical aligned-four-set design fixes the second-moment mean and variance but not the individual spectrum. | main-theorem-clause | |
| concl-recovery-from-ten | 09-conclusion.tex:30-32 | prose | The marked blocks recover every conference signing from order ten onward, up to switching and global negation, using quadratically many selected determinant tests. | main-theorem-clause | |
| concl-triangle-calibration | 09-conclusion.tex:33 | prose | One triangle calibration chooses the orientation used by the cubic shadows. | main-theorem-clause | |
| concl-conference-remembers | 09-conclusion.tex:34-35 | prose | The conference stage remembers the incidence choice relative to exactly the marking data displayed in the theorem. | definition (scope) | |
| concl-harmonic-return | 09-conclusion.tex:37-38 | prose | The degree-six face-axis construction returns to \(\sigma_3\): the normalized spherical cubic restricts to it on the Petersen four-space. | main-theorem-clause | |
| concl-sign-transport-chain | 09-conclusion.tex:39-43 | prose | After the golden axes, outer marking, plane triples, chart lift, and Petersen labels are fixed, the selected sheet is assigned the relative source, deck exchange gives its opposite, and the primitive Petersen map carries its sign to the degree-six Gaunt cubic. | main-theorem-clause | |
| concl-sheet-insufficient | 09-conclusion.tex:43 | prose | The sheet alone does not determine the marking or lift. | definition (scope) | |
| concl-relative-not-equal | 09-conclusion.tex:43-46 | prose | The result is a relative comparison of orientation sources, not an equality between \(Z_{\mathfrak m}\) and \(\sigma_3\) or a map between their ambient harmonic spaces. | definition (scope) | |
| concl-summary | 09-conclusion.tex:46-49 | prose | One marked golden source has four operator descriptions, its six outer coordinates recover the classical cubic models, and its Petersen image returns to the same invariant \(\sigma_3\). | main-theorem-clause | |

## Appendix A, Marking ambiguities (`sections/07-marking-ambiguities.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| ma-complete-action | 07-marking-ambiguities.tex:4-5 | prose | The displayed table lists the complete action of the auxiliary choices on the relative formulation. | definition (scope) | |
| ma-axis-switching | 07-marking-ambiguities.tex:12-14 | table row | Axis switching sends \(C\mapsto DCD\) while fixing every triangle product and \(Z\), and is the equivalence already built into the marked source. | definition | |
| ma-axis-relabelling | 07-marking-ambiguities.tex:15-17 | table row | Axis relabelling simultaneously permutes rows and columns of \(C\) and the variables of \(Z\), and the proposition transports equivariantly without choosing an order. | definition | |
| ma-five-label-relabelling | 07-marking-ambiguities.tex:18-21 | table row | Five-label relabelling simultaneously permutes the \(q_i\), the coordinates \(y_i\), and the two-subset labels, fixing \(\sigma_3\) and keeping \(\beta\) equivariant; relabelling only one side changes \(\mathfrak m\). | definition | |
| ma-chart-scaling | 07-marking-ambiguities.tex:22-25 | table row | Chart scaling rescales the linear identification and the transported cubic generator while leaving the projective chart fixed, is not quotiented since \(q_1=xyz\) fixes the normalization, and scaling by \(-1\) reverses the generator. | definition | |
| ma-galois-conjugation | 07-marking-ambiguities.tex:26-28 | table row | Golden Galois conjugation, after transport by \(R\), sends \(C\), \(Z\), and the normalized chart lift to their negatives at the golden fibre. | proof-step | |
| ma-deck-exchange | 07-marking-ambiguities.tex:29-32 | table row | Incidence deck exchange interchanges \(B_+\) and \(B_-\) and negates the odd generator, and relative to \(\mathfrak m\) the attached source and harmonic generator are negated by definition. | definition | |
| ma-switching-relabelling-neutral | 07-marking-ambiguities.tex:37-40 | prose | Switching and coordinated relabelling do not change the comparison, while lift normalization and the cross-identification of the two five-labelled systems remain visible inputs for which no descent claim is made. | definition (scope) | |
| ma-no-degree-3-6-map | 07-marking-ambiguities.tex:42-44 | prose | There is no nonzero rotation-equivariant linear comparison between harmonic degrees three and six, since they are nonisomorphic irreducible rotation modules of dimensions seven and thirteen. | proof-step | |
| ma-unique-intertwiner | 07-marking-ambiguities.tex:44-47 | prose | The linear comparison used is the unique marked \(A_5\)-intertwiner on the chosen Clebsch four-space, and it stops at the relative marked source class \([C_{\mathfrak m},Z_{\mathfrak m}]_{\rm or}\). | main-theorem-clause | |

## Appendix B, Reproducibility and data availability (`sections/08-verification.tex`)

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| vf-human-proofs | 08-verification.tex:4-6 | prose | The square-class argument and both specialization propositions are proved in the text from Hitchin's incidence calculation and the displayed equations. | verification-claim | |
| vf-bundle-one | 08-verification.tex:6-8 | prose | A paper-local exact-arithmetic bundle independently checks the golden configurations, the exchanger, and its spinor decomposition. | verification-claim | |
| vf-twenty-minors-regression | 08-verification.tex:8-10 | prose | The human six-arc proof uses one Gram-determinant formula indexed by the triangle sign, so the stored twenty minors are regression data rather than twenty proof obligations. | verification-claim | |
| vf-bundle-two | 08-verification.tex:12-16 | prose | A second paper-local bundle reconstructs the ten axes over \(\Q(\sqrt5)\), distinguishes the reproducing kernel from the normalized spherical Gram matrix, verifies the Petersen labeling, and evaluates the quadratic and cubic moments. | verification-claim | |
| vf-independent-replay-two | 08-verification.tex:16-18 | prose | The independent replay of the harmonic bundle uses a separate dense polynomial representation and checks the Wigner 3j conversion. | verification-claim | |
| vf-no-floating-point | 08-verification.tex:18 | prose | Neither the arithmetic nor the harmonic calculation uses floating-point arithmetic. | verification-claim | |
| vf-symmetry-reduction | 08-verification.tex:18-19 | prose | The proof uses symmetry to reduce the kernel matrix to its two Petersen relations and uses only one point-stabilizer-fixed vector to normalize the invariant cubic line. | verification-claim | |
| vf-bundle-three | 08-verification.tex:21-24 | prose | A third bundle checks, for the displayed marking, the conference square, the golden exchanger and its transport of \(C\) and \(Z_C\), the scalar factorization of the pulled-back cover, and the primitive Petersen pair-sum identities. | verification-claim | |
| vf-bundle-three-reuse | 08-verification.tex:24-26 | prose | The third bundle reuses the canonical harmonic certificate only through its pinned digest and exact witness values. | verification-claim | |
| vf-human-normalization | 08-verification.tex:26-27 | prose | Normalization of the pulled-back incidence scheme and its extension across the branch divisor remain human arguments. | verification-claim | |
| vf-lean-operator-mechanisms | 08-verification.tex:29-33 | prose | The conference, triangle, two-graph, middle-exterior square and diagonal, support recovery, and golden-descent mechanisms of the operator theorem are checked by the pinned golden-return formal gate. | verification-claim | |
| vf-lean-pfaffian | 08-verification.tex:33-35 | prose | The same gate proves symbolically that the fixed conference commutator Pfaffian is four times its triangle cubic, and checks the three-vertex signed-matrix identity used in the order-six exchange-spectrum converse. | verification-claim | |
| vf-human-inclusion-ramsey | 08-verification.tex:35-36 | prose | The unrestricted inclusion-rank and Ramsey exclusion argument is a human proof. | verification-claim | |
| vf-lean-reconstruction | 08-verification.tex:36-39 | prose | The formal gate covers rooted recovery of triangle signs, the normalized seven-point cut signatures, the distinct-balanced-cut ambiguity, and its symbolic elimination by the third outside point. | verification-claim | |
| vf-lean-additional | 08-verification.tex:39-43 | prose | The gate also checks complement consistency on overlapping local restrictions, the conference-signing switching transport, the identity \(\det C[Q]=3-2w(Q)\), the selected-query polynomial, and the count of twenty possible anchor tests. | verification-claim | |
| vf-human-ramsey-inputs | 08-verification.tex:41-44 | prose | The classical Ramsey input \(R(3,3)=6\), the finite-set extension to seven vertices, and the passage from arbitrary labels to normalized cut coordinates remain human combinatorial steps. | verification-claim | |
| vf-human-outer-family | 08-verification.tex:44-47 | prose | Coherence of the outer six-family, the cross-golden determinant comparison, and the classical Joubert--Segre--Igusa identifications remain human proofs with primary literature inputs and are not inferred from a finite matrix check. | verification-claim | |
| vf-directory-contents | 08-verification.tex:49-52 | prose | The distributed verification directory contains the exact programs, canonical certificates, checksums, toolchain requirements, aggregate replay command, and the exact claim-to-evidence correspondence. | verification-claim | |
| vf-paper-specific-gate | 08-verification.tex:52-56 | prose | A paper-specific formal gate proves the abstract pinching and conductor mechanisms, involutive splitting, golden discriminant and reflection characters, tight-frame conference mechanism, marked relative sign transport, Petersen eigenspace and two-orbit kernel calculation, and fixed-line cubic normalization. | verification-claim | |
| vf-partial-coverage | 08-verification.tex:56-58 | prose | The declaration map records partial mechanism coverage only: no complete geometric manuscript row is declared formally proved at its full geometric strength. | verification-claim | |
| vf-human-remainders | 08-verification.tex:58-61 | prose | The global incidence and Stein identifications, scheme-theoretic chart correspondence, geometric golden-fibre identification, face-axis addition theorem, and raw spherical moment remain human inputs. | verification-claim | |
| vf-audits-independent | 08-verification.tex:61-62 | prose | The exact-arithmetic audits are independent checks rather than hidden proof steps. | verification-claim | |

## README.md

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| rd-logically-independent | README.md:7-8 | prose | The shared series progression is expository and this manuscript is logically independent of the other two papers. | verification-claim | |
| rd-function-field | README.md:12-14 | prose | The paper determines the rational twist in Hitchin's double cover of the projective space of harmonic cubics as \(\mathbb Q(\mathbf P(H))(\sqrt{5J_0})\). | main-theorem-clause | |
| rd-golden-fibre-and-marking | README.md:14-16 | prose | A complete golden fibre fixes the factor \(5\), and a marked bridge datum turns the deck sign into the sign of an order-six conference operator \(C\) with \(C^2=5I\). | main-theorem-clause | |
| rd-four-descriptions | README.md:18-20 | prose | The oriented cubic is simultaneously triangle holonomy, the diagonal of the middle exterior power, a commutator Pfaffian, and a cross-golden determinant. | main-theorem-clause | |
| rd-joubert-igusa | README.md:20-21 | prose | The outer translates of the oriented cubic are Joubert coordinates on the Segre cubic, and centered squares give the Segre--Igusa polar map. | main-theorem-clause | |
| rd-balanced-rigidity | README.md:22 | prose | Balanced exchange rigidity characterizes order six. | main-theorem-clause | |
| rd-aligned-four-sets | README.md:22-23 | prose | Aligned four-sets reconstruct every two-graph on at least seven vertices up to complement. | main-theorem-clause | |
| rd-petersen-embedding | README.md:24-25 | prose | With the same marking, the Petersen eigenspace embeds as the Clebsch four-space in degree-six zonal harmonics. | main-theorem-clause | |
| rd-charts-conjugate-not-rational | README.md:27-29 | prose | The fixed-icosahedron Clebsch charts of the first theorem are conjugate charts over \(\Q(\sqrt5)\) and are not presented as rational subspaces of the standard rational harmonic space. | definition (scope) | |
| rd-mod-11-scope | README.md:55-57 | prose | The mod-\(11\) assertion concerns the displayed golden fibre and its integral exchanger, and does not assert that the full geometric incidence comparison has good reduction at \(11\). | definition (scope) | |

## ARTIFACT.md

| key | source file:line | label | assertion | kind | external |
|---|---|---|---|---|---|
| art-release-surface | ARTIFACT.md:6-9 | prose | The release surface contains the manuscript source and PDF, the eight-statement identity, the nine-row trust map, three paper-local exact certificate bundles, and the aggregate runner. | verification-claim | |
| art-no-parent-reads | ARTIFACT.md:9-10 | prose | No program in the release surface reads a parent directory or another repository subtree. | verification-claim | |
| art-gate-checks | ARTIFACT.md:18-20 | prose | The aggregate gate checks statement and trust-row identity, evidence checksums, an independent replay for each exact bundle, the release allowlist, and a warning-free manuscript build. | verification-claim | |
| art-toolchain | ARTIFACT.md:20-21 | prose | Python 3.11 or later, GNU `sha256sum`, and the TeX Live environment selected by the local Makefile are required to run the gate. | verification-claim | |
| art-arithmetic-scope | ARTIFACT.md:23-25 | prose | The arithmetic programs audit only the displayed golden configurations, their exchanger, and the mod-\(11\) spinor representative. | verification-claim | |
| art-human-arguments | ARTIFACT.md:25-27 | prose | The incidence degree, branch divisor, local normalization comparison, and Clebsch-chart identity remain human arguments using the cited primary sources. | verification-claim | |
| art-orientation-bundle | ARTIFACT.md:27-31 | prose | The orientation-source bundle checks, for the displayed marking, the cover's scalar factorization, golden involution, conference signs, and Petersen comparison, but does not prove normalization of the incidence scheme. | verification-claim | |
| art-lean-partial | ARTIFACT.md:31-35 | prose | The separately released formal artifact supplies partial structural coverage only, and no complete manuscript claim uses it as a proof premise. | verification-claim | |
| art-supplemental-coverage | ARTIFACT.md:35-38 | prose | The supplemental golden-return map and axiom report cover the fixed-conference middle-exterior and commutator-Pfaffian mechanisms and the three-vertex signed-matrix square used by the operator theorems. | verification-claim | |
| art-current-map-coverage | ARTIFACT.md:38-41 | prose | The current-paper map additionally covers the normalized aligned-design cut classifier, third-point disambiguation, overlap consistency, switching transport, determinant identity, and query polynomial. | verification-claim | |
| art-human-boundaries | ARTIFACT.md:41-43 | prose | The higher-order inclusion/Ramsey classification, classical Ramsey and finite-set inputs to aligned-design faithfulness, outer-family coherence, cross-golden determinants, and the classical six-point quotient remain human proof boundaries. | verification-claim | |
| art-commit-mismatch | ARTIFACT.md:47-51 | prose | The public commit `f1d81641827fd037fcbd8363a6f9cd5abf3767cf` matches the complete base formal map but not the supplemental golden-return source map, so submission still requires an immutable release containing those supplemental sources. | verification-claim | |

## Ambiguous scope or quantifiers

These assertions have a scope or quantifier that the prose does not pin down; each needs an explicit formal quantifier before it can be matched to a statement.

- `abs-four-descriptions` / `intro-outer-translates-four-ways`: the abstract says the oriented cubic "has four equivalent descriptions" while the introduction says the *six outer translates* are simultaneously all four things. Whether the claim is per-total (for each \(T\in\mathcal T\)) or for the distinguished \(Z_{\mathfrak m}\) alone is not stated in the same sentence.
- `ber-independence-iff` vs `ber-order-six-unique`: "if and only if \(d\le3\)" is a statement about all symmetric conference matrices of order \(2d\); "the unique nontrivial realized symmetric conference order" additionally quantifies over existence of conference matrices (order 2 and 4 cases, and which orders count as "nontrivial" and "realized"). Neither "nontrivial" nor "realized" is defined in the text.
- `adf-anchor-twenty`: "at most twenty tests" is stated for the deterministic anchor search but the underlying assumption \(|V|\ge7\) and the choice of root/six vertices is only made explicit later in the proof.
- `adf-query-count` / `adfp-decoder`: the theorem says the quadratic family of tests "already suffices"; the proof says the count is "exactly the quadratic count." Whether the claim is an upper bound or an exact query count is stated both ways.
- `op-CT-square` and `op-coherent-outer-marking`: \(C_T^2=5I\) is asserted for representatives chosen with transported Hodge orientations; whether it holds for every representative of every outer total, or only after the coherent marking, is not separated.
- `os-cross-golden-determinant`: the sign in \(Z_T=\pm10\sqrt5\det B_T(x)\) is said to be fixed "after orienting the two determinant lines", but the theorem statement retains the \(\pm\), so the formal statement must decide whether the sign is existentially or constructively determined.
- `int-spreading-out-N` / `ar-geometric-interp-limited`: "an unspecified finite set of primes" and "some \(\mathbf Z[1/N]\)" are existential over \(N\), and the paper never fixes whether \(N\) is claimed to exist for the whole comparison or only pointwise.
- `hm-injective-copy`: "an injective copy of \(V\)" — injectivity is proved for the full ten-dimensional \(L\), and the restriction to the pair-sum image is the actual claim; the two are not distinguished in the theorem sentence.
- `hmp-scalar-cube-one`: "forces the scalar to have cube one, hence to equal one over \(\Q(\sqrt5)\)" — the ground field over which the scalar lives is not stated in the same sentence as the uniqueness claim.
- `ma-complete-action`: the appendix asserts the table gives "the following complete action of the auxiliary choices"; completeness of the list of auxiliary choices is asserted but never enumerated as a closed set.
- `op-order-ten-moments` / `op-126-split`: the split 36/90 is asserted for "the 126 projective cuts" at order ten, but conference matrices of order ten are not unique up to switching, and whether the split is claimed for every such matrix or for one is not stated.
- `vf-partial-coverage`: "no complete geometric manuscript row is declared formally proved at its full geometric strength" quantifies over the rows of a ledger that is not reproduced in the manuscript.

## Strength words requiring matching formal statements

Exact quoted phrases, with location.

- "We **determine** the rational twist" — clebsch_passages.tex:46.
- "A **complete** golden fibre over \([xyz]\) **determines** the factor \(5\)" — clebsch_passages.tex:48-49.
- "four **equivalent** descriptions" — clebsch_passages.tex:53.
- "the **unique** nontrivial symmetric conference order with cut-independent balanced exchange spectrum" — clebsch_passages.tex:58-59.
- "**every** two-graph on at least seven vertices up to complement, and seven is **sharp**" — clebsch_passages.tex:59-60.
- "recover **every** symmetric conference signing of order at least ten" — clebsch_passages.tex:61-62.
- "restricts to the **exact** multiple \(-784000\sigma_3/1247103\)" — clebsch_passages.tex:68-69.
- "the marked sign **determines** a conference operator" — 01-introduction.tex:21-22.
- "This is the **exact** inclusion used below." — 02-orientation-cover.tex:19.
- "the ratio of \(J_0(xyz)\) to \(\sigma_3(y^\circ)^2\) is **exactly** \(16\)" — 02-orientation-cover.tex:45-46.
- "meeting **only** at the rational point \([xyz]\)" — 02-orientation-cover.tex:60-62.
- "a **unique** \(c\in\Q^\times/\Q^{\times2}\)" — 02-orientation-cover.tex:198-199.
- "the **complete** reduced scheme-theoretic fibre" — 02-orientation-cover.tex:213-215.
- "gives the **exact** algebra" — 02-orientation-cover.tex:252-253.
- "there is a **canonical** link from the chart model to the finite incidence cover" — 02-orientation-cover.tex:138-139.
- "The missing assertion is **precise**." — 02-orientation-cover.tex:293.
- "the **complete** fibre over \([xyz]\)" — 04-arithmetic-specialization.tex:28-29.
- "Hitchin's **classification** of the two icosahedral sets" — 04-arithmetic-specialization.tex:49-50.
- "the exchanger lies outside \(\operatorname{PSL}_2(k)\) **exactly when** \(2\) is nonsquare" — 04-arithmetic-specialization.tex:94-96.
- "**exactly** the locus of two distinct regular configurations" — 03-orientation-source.tex:29-30.
- "The magnitude \(4\sqrt5\) is **forced**" — 03-orientation-source.tex:31-32.
- "**Multiplicity one** makes this comparison **unique**" — 03-orientation-source.tex:132-133.
- "it is the **unique** order-six conference class" — 05-golden-operator.tex:34-35.
- "The following table **fixes every sign**." — 05-golden-operator.tex:46.
- "this citation supplies **no unstated** scalar or sign convention" — 05-golden-operator.tex:74-76.
- "independent of the balanced half \(Y\) **if and only if** \(d\leq3\)" — 05-golden-operator.tex:105-107.
- "the **unique** nontrivial realized symmetric conference order with this property" — 05-golden-operator.tex:107-108.
- "the second is cut-independent **exactly** in the stated small orders" — 05-golden-operator.tex:124-125.
- "\(\mathcal A(\tau)\) **determines** \(\tau\) up to complement" — 05-golden-operator.tex:225-226.
- "**determines** its signing up to diagonal switching and global negation" — 05-golden-operator.tex:229-231.
- "the **complete** marked reconstruction uses \(O(n^2)\) selected determinants" — 05-golden-operator.tex:236-237.
- "the following **complete** signature table" — 05-golden-operator.tex:260-261.
- "This criterion gives a **complete classification**." — 05-golden-operator.tex:282-283.
- "The **sole** loss of information is the order of two distinct balanced cuts" — 05-golden-operator.tex:312-313.
- "with ambient order seven **sharp**" — 05-golden-operator.tex:355-356.
- "the labeling is **geometric**" — 05-harmonic-realization.tex:31-32.
- "This identifies the abstract bridge **uniquely**." — 05-harmonic-realization.tex:119.
- "**every** \(A_5\)-equivariant comparison ... is a scalar multiple of" — 05-harmonic-realization.tex:123-128.
- "The abstract comparison is therefore **unique** with the stated labels and normalization." — 05-harmonic-realization.tex:135-136.
- "**Exact** evaluation on this fixed line" — 05-harmonic-realization.tex:163-164.
- "both are **forced** by converting the universal Gaunt factor" — 05-harmonic-realization.tex:224-226.
- "the following **complete** action of the auxiliary choices" — 07-marking-ambiguities.tex:4-5.
- "the **unique** marked \(A_5\)-intertwiner on the chosen Clebsch four-space" — 07-marking-ambiguities.tex:44-46.
- "it **characterizes** the six-axis case: it is the **unique** nontrivial symmetric conference order whose balanced exchange spectrum is cut-independent" — 09-conclusion.tex:26-28 (as written: "also characterizes the six-axis case").
- "recover **every** conference signing from order ten onward" — 09-conclusion.tex:30-32.
- "The conclusion is therefore relative but **exact**" — 09-conclusion.tex:46.
- "Balanced exchange rigidity **characterizes** order six" — README.md:22.
- "reconstruct **every** two-graph on at least seven vertices up to complement" — README.md:22-23.
