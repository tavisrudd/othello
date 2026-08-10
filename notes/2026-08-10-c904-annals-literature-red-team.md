# C904 Paper V: Annals-ceiling literature red team

Date: 2026-08-10
Scope: literature, theorem ceiling, and proof obligations only. No manuscript or Lean edits.

Literature depth: twelve primary sources were read partially from their full
PDFs at the sections stated below; zero were read cover to cover for this
audit.  The priority verdict is therefore bounded by those sections and the
explicit coverage gaps.

## Bottom line

The rational statements are substantially pre-empted. Roulleau already constructs the relevant $D_5$-elliptic fibrations on the Fano surface and already states that the Albanese/intermediate Jacobian of an $A_5$-cubic is isogenous to $E^5$. General group-algebra decompositions, Kanev/Schur correspondences, and motivic decompositions of Fano threefolds also make a bare rational $E^5$ or $h^3(X)\simeq h^1(E)^{\oplus 5}(1)$ theorem classical in mechanism.

The strongest genuinely open-looking package is instead **integral, relative, and geometric**:

1. recover the six $D_5$-marked elliptic quotient maps from Roulleau's fifteen genus-two curves;
2. determine their exact principal-polarization Gram matrix and isogeny degree;
3. identify the common rank-two variation with the Winger $V_4$-multiplicity variation after the explicit quadratic boundary cover;
4. construct the bridge by algebraic correspondences, with the quadratic character as the exact descent obstruction; and
5. make Fricke/Hecke into geometric correspondences on the cubic family, including their action at the boundary.

That is a plausible high-end theorem program. “The multiplicity space is a modular curve” or “the intermediate Jacobian is $E^5$” is not.

## The decisive priority correction: Roulleau 2010

Roulleau, *Genus 2 curve configurations on Fano surfaces* (2010), is the closest prior source found.

- Theorem 11(D): a $D_5$-type Fano surface has five genus-two curves $D_1,\ldots,D_5$, pairwise intersecting in $1$, and $D_1+\cdots+D_5$ is a fiber of a morphism to an elliptic curve.
- Lemma 17 proves the analogous $D_3$ assertion through the Albanese; the text says the $D_5$ and $D_6$ assertions are proved in the same way. Thus every $D_5\subset A_5$ supplies an elliptic quotient of $\operatorname{Alb}(S)=J(X)$.
- The $A_5$ discussion explicitly states that $\operatorname{Alb}(S)$ is isogenous to $E^5$.
- The paper gives the complete genus-two intersection rule
  \[
  D_g^2=-4,\qquad
  D_gD_h=0,2,1\quad\text{when }o(gh)=2,3,5.
  \]

There are six $D_5$ subgroups of $A_5$, permuted 2-transitively. Each contains five involutions; every involution lies in two of them. Roulleau does **not** appear to print the six quotient maps as one polarized isogeny, their mutual Rosati Gram matrix, their Smith form, or their kernel. That is exactly where the new integral theorem can begin.

Hartlieb's Remark 5.8 also states $J(X)\sim E^5$, using the rational $A_5$-representation and Birkenhake--Lange. Roulleau's statement predates it and should receive explicit priority. The searched texts of Hartlieb and van Geemen--Yamauchi do not expose the six-map polarization calculation below.

## Exact six-axis polarization calculation

This calculation survives red-team normalization checks, subject to the explicitly listed inputs.

For a $D_5$ subgroup $H\subset A_5$, put
\[
F_H=\sum_{g\in H,\ o(g)=2}D_g.
\]
Roulleau gives $F_H^2=0$, and $F_H$ is a fiber of $S\to E_H$. Let $D_{\mathrm{tot}}=\sum_gD_g$, over all fifteen involutions. Among the $105$ unordered pairs of distinct involutions in $A_5$, the product has order $2,3,5$ in respectively $15,30,60$ cases. Hence
\[
D_{\mathrm{tot}}^2=15(-4)+2(30\cdot2+60\cdot1)=180.
\]
Since $\sum_HF_H=2D_{\mathrm{tot}}$, and 2-transitivity makes $F_HF_{H'}$ constant off the diagonal,
\[
30(F_HF_{H'})=(2D_{\mathrm{tot}})^2=720,
\qquad F_HF_{H'}=24 \quad(H\ne H').
\]

Now let $(J,\Theta)$ be the principally polarized intermediate Jacobian, $q_H:J\to E_H$ the quotient, and $i_H:E_H\to J$ its Rosati dual. Over the generic non-CM point, transport the six $E_H$'s to one elliptic curve $E$. The stabilizer $D_5$ acts trivially on the fixed line in the $W_5$-carrier, so the transports can be chosen as an honest $A_5$-orbit, not merely a projective signed orbit. Write
\[
q_Hi_H=[d],\qquad q_Hi_{H'}=[m]\quad(H\ne H').
\]
The diagonal copy of $E$ in $E^6$ maps to the trivial $A_5$-type, absent from $H^1(J)$. Therefore
\[
d+5m=0.
\]

Let $\alpha_H=q_H^*[0]$ and $N_H=i_Hq_H=\Phi_\Theta(\alpha_H)$. The Abel--Jacobi image of the Fano surface has minimal class $[S]=\Theta^3/3!$. Roulleau's Klein-cubic paper records this explicitly and cites Clemens--Griffiths for it. For two divisor classes on a principally polarized abelian $g$-fold,
\[
\frac{\alpha\beta\Theta^{g-2}}{(g-2)!}
=\operatorname{tr}(N_\alpha)\operatorname{tr}(N_\beta)
-\operatorname{tr}(N_\alpha N_\beta).
\]
Here $\operatorname{tr}(N_H)=d$ and $\operatorname{tr}(N_HN_{H'})=m^2$, so
\[
F_HF_{H'}=d^2-m^2=24.
\]
Together with $d+5m=0$, integrality and $d>0$ give
\[
d=5,\qquad m=-1.
\]
Thus the six-axis Rosati matrix is exactly
\[
G_6=6I_6-J_6,
\]
with radical the diagonal vector. Choosing any five axes gives
\[
G_5=6I_5-J_5,
\qquad \operatorname{SNF}(G_5)=(1,6,6,6,6),
\qquad \det G_5=6^4.
\]
Consequently the induced five-axis isogeny $E^5\to J$ has degree $6^4=1296$. The pullback polarization has type $(1,6,6,6,6)$.

### Check on the mixed-intersection identity

No factor of $2$ or factorial is missing. Grieve's Theorem 4.1 and Corollary 4.2 identify the normalized top self-intersection with the reduced-norm polynomial under the Neron--Severi/Rosati map. For a non-CM power $E^5$, his section 7.1 identifies that polynomial with the ordinary determinant. Polarizing
\[
\frac{(\Theta+t\alpha+s\beta)^g}{g!}
=\det(I+tN_\alpha+sN_\beta)
\]
and comparing the coefficient of (ts) gives exactly the displayed formula. This short proof is preferable to importing an opaque intersection lemma.

### What is not yet proved by this calculation

- The abstract group scheme structure of the isogeny kernel does not follow from the degree alone. It is a maximal isotropic subgroup of the kernel of the pulled-back polarization; identifying it as a particular product of cyclic group schemes needs a separate integral argument, especially in characteristics (2) and (3).
- The generic argument uses $\operatorname{End}(E)=\mathbb Z$. Extension across CM fibers should be proved in the family or by specialization, not asserted fiberwise from the generic calculation.
- The relation $d+5m=0$ requires the honest, untwisted six-axis $A_5$-orbit. This is supported by the trivial $D_5$-fixed line in $W_5|_{D_5}=1\oplus\rho_1\oplus\rho_2$, but a manuscript proof should spell it out.
- The input $[S]=\Theta^3/3!$ should be cited to the classical Fano-surface/intermediate-Jacobian theory.

## What the general machinery does and does not buy

### Group-algebra decompositions

Carocca--Rodriguez construct rational idempotents and isotypical decompositions for abelian varieties and, more geometrically, Jacobians with finite-group actions. Their Proposition 5.1 makes the rational factor the image of a primitive rational idempotent. This pre-empts novelty for a merely rational $A_5$-factorization. It does not determine the integral lattice, the principal polarization gluing, or the six Roulleau quotient maps.

### Kanev/Schur and Prym--Tyurin correspondences

Lange--Rojas attach Schur and Kanev correspondences to a Galois cover, an absolutely irreducible integral $G$-module, and a weight; Theorem 3.5 relates the two and yields the same abelian subvariety. This is a natural source of techniques for an $A_5$-marked curve cover and for exponent computations. It does not automatically produce a correspondence between the Fano surface/cubic motive and the Winger family. The current bridge still needs an actual common parameterized cover or an algebraic cycle.

### Motives of cubic threefolds

Gorchinskiy--Guletskii Theorems 8 and 15 give the Chow--Kunneth decomposition of a Fano threefold, with middle motive $M^1(J)\otimes\mathbb L$. Hence an individual rational Chow-motive splitting
\[
h^3(X)\simeq h^1(E)^{\oplus5}(1)
\]
is largely a corollary of $J\sim E^5$. Novelty would require a **relative, equivariant, arithmetic, and preferably integral** factorization with explicit cycles and boundary behavior.

### Modular and Hecke language

Looijenga--Zi prove that the Winger multiplicity local system has rank two, monodromy $\Gamma_1(3)$, and period base $X_1(3)$; they also print the six-axis integral model
\[
0\to\mathbb Z\to\mathbb Z^{\mathcal L}\to W_0\to0
\]
for the six order-five axes. Hartlieb proves the $A_5$-cubic intermediate-Jacobian locus is a one-dimensional PEL special subvariety. Those facts make the existence of modular/Hecke correspondences structurally unsurprising. A new theorem must be the explicit cubic parameter formula, geometric correspondence, exact polarization, and boundary interpretation--not the abstract existence of Hecke operators on a special curve.

## A hard obstruction that should become part of the theorem

There is no nonzero $A_5$-equivariant linear map $W_5\to V_4$: the irreducibles are inequivalent. Therefore a fully $A_5$-invariant one-axis algebraic correspondence between cubic $H^3$ and the Winger $V_4$-piece must vanish on carriers.

The bridge can exist only after one of the following changes:

- mark a $D_5$ axis, for which $W_5|_{D_5}=1\oplus\rho_1\oplus\rho_2$ and $V_4|_{D_5}=\rho_1\oplus\rho_2$, so the canonical map is “drop the fixed line”;
- package all six marked correspondences as an $A_5$-orbit; or
- let the cycle itself transform in a nontrivial $A_5$-representation.

This is not a defect. It explains why the six elliptic quotients and the Winger fourfold complement are the correct geometry. It also gives a crisp impossibility statement against overclaiming an unmarked direct bridge.

## The most plausible Annals-level statement

A realistic ceiling would be a theorem of the following form.

> Over the natural quadratic cover of the common $X_0(3)$-base, the $A_5$-cubic family and the Winger family admit six $D_5$-marked algebraic correspondences. On integral variations they identify the Winger $V_4$-multiplicity system with the four-dimensional kernels of the six Roulleau elliptic quotients of the intermediate Jacobian. The six quotient embeddings have Rosati Gram matrix $6I-J$, polarization type $(1,6,6,6,6)$, and isogeny degree $6^4$. The only obstruction to descent is the explicitly computed quadratic character $\chi_D$. Under this identification the Fricke involution and degree-three Hecke correspondence are induced by geometric correspondences on the cubic family and extend with described action over the boundary.

The “Annals” part is not the modular formula by itself. It is the simultaneous construction of algebraic cycles, the integral polarized comparison, exact descent, and a conceptual boundary theorem. Without those four ingredients, the work is more plausibly a strong specialist-journal paper.

## Proof gates and required imports

1. **Roulleau-to-Jacobian map:** define each $q_H$ and $i_H$ functorially in the family, not only analytically on one complex fiber.
2. **Polarization theorem:** cite the minimal class of the Fano surface, prove the mixed-intersection identity as above, and prove the untwisted six-axis relation.
3. **Integral kernel:** determine the finite kernel scheme and monodromy action; the Smith form alone is not enough.
4. **Bridge cycle:** construct an algebraic cycle, not merely an equality of Picard--Fuchs equations or period maps.
5. **Descent:** prove the quadratic twist is the exact obstruction and exclude an additional constant or integral character.
6. **Boundary:** compare limiting mixed Hodge structures/Neron models at $I_1,II,I_0^*,I_3$; a match of $j$-maps is insufficient.
7. **Hecke geometry:** exhibit the degree-three correspondence on the cubic parameter space and prove its action on the relative motive.
8. **Arithmetic field of definition:** track $A_5$-markings, quotient elliptic curves, and cycles over the claimed base field.

## Rational elliptic surface priority

The fiber configuration $I_1+II+I_0^*+I_3$ is classical. Miranda--Persson list the configuration (their `*II31` entry), and Herfurtner classifies elliptic surfaces with four singular fibers. The equation/configuration must not be sold as new. The possible novelty is its forced appearance as the Prym/multiplicity surface for the $A_5$-cubic pencil and its compatibility with the Winger/Fricke bridge.

## Search coverage and negative result

Exact-title/keyword searches were run for $A_5$ cubic threefolds with $X_0(3)$, Winger/cubic correspondences, Hecke correspondences on cubic-threefold intermediate Jacobians, the four-fiber rational elliptic surface, and six $D_5$ elliptic quotients/polarizations. No direct predecessor for the complete integral-relative bridge was found.

Forward-citation checks on the three closest modern seeds returned valid records (not API errors):

- van Geemen--Yamauchi: OpenAlex 2, Crossref 2, Semantic Scholar 4;
- Looijenga--Zi: OpenAlex 1, Crossref 1, Semantic Scholar 3;
- Hartlieb: 0 in all three.

The returned citing titles/abstracts did not disclose the cubic--Winger $X_0(3)$/Fricke bridge. Google Scholar and MathSciNet were not covered. This is therefore a strong lead audit, not yet a publication-grade proof of absence; a final audit should add zbMATH/MathSciNet and citation chasing from Roulleau, Hartlieb, and Looijenga--Zi.

## Source ledger

Every source below has read depth **partial**: the listed portions were read
from the full PDF, but the paper was not read cover to cover.

- **Partial:** Xavier Roulleau, *Genus 2 curve configurations on Fano surfaces*, arXiv:1002.4467, later Comment. Math. Univ. St. Pauli 59 (2010), 51--64. Read: Theorem 11, Lemmas 14--19, $A_5$ construction, intersection table, references. Cache key `arXiv:1002.4467`; SHA-256 `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
- **Partial:** Xavier Roulleau, *Quotients of Fano Surfaces*, arXiv:1103.4724 / Rend. Lincei Mat. Appl. 23 (2012). Read: $D_5$ quotient representation and Proposition 29. Cache key `arXiv:1103.4724`; SHA-256 `05178050d23f80d364b9db789efb0d17bd8b94a777f15d75c89884cfba7deb4e`.
- **Partial:** Xavier Roulleau, *The Fano surface of the Klein cubic threefold*, arXiv:1001.4853 / J. Math. Kyoto Univ. 49 (2009). Read: introduction and the fiber-intersection calculation around Theorem 15, which explicitly use $[S]=\Theta^3/3!$ and cite Clemens--Griffiths. Cache key `arXiv:1001.4853`; SHA-256 `4e36a22bdeb3ac6746f0162eab01c47914f1c9df88ee968ba2ae9e11ff0e4a84`.
- **Partial:** Moritz Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds*, arXiv:2304.03214, Math. Z. (2025). Read: Theorem 0.5, Proposition 5.7, Remark 5.8, $A_5$ section. Cache key `arXiv:2304.03214`; SHA-256 `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.
- **Partial:** Bert van Geemen and Takuya Yamauchi, *On intermediate Jacobians of cubic threefolds admitting an automorphism of order five*, arXiv:1506.05346 / PAMQ 12 (2016). Read: introduction and the decomposition/Prym propositions. Cache key `arXiv:1506.05346`; SHA-256 `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
- **Partial:** Eduard Looijenga and Yunpeng Zi, *Monodromy and period map of the Winger pencil*, arXiv:2109.01810 / JLMS 108 (2023). Read: Theorem 1.1, integral models in Examples 2.2--2.4, monodromy section. Cache key `arXiv:2109.01810`; SHA-256 `d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`.
- **Partial:** Nathan Grieve, *Reduced norms and the Riemann--Roch theorem for Abelian varieties*, arXiv:1603.06425. Read: sections 2.6--2.7, Theorem 4.1, Corollary 4.2, section 7.1. Cache key `arXiv:1603.06425`; SHA-256 `29e4b19bee5a63bbb531d696adc4e4c211132eba97b19ecde1d72a1404fe8b0a`.
- **Partial:** Angel Carocca and Rubi E. Rodriguez, *Jacobians with group actions and rational idempotents*, arXiv:math/0305328. Read: introduction, section 5, Propositions 5.1--5.2. Cache key `arXiv:math/0305328`; SHA-256 `54a796249c83ee5035b77155892c6219c2336956dbc8cc4bce043a5b2f77681b`.
- **Partial:** Herbert Lange and Anita M. Rojas, *A Galois-theoretic approach to Kanev's correspondence*, arXiv:0707.2441. Read: introduction, Theorem 3.5 and invariant/exponent discussion. Cache key `arXiv:0707.2441`; SHA-256 `cc2039dee8d02550661578c62923cc21b4fedce7d4e8f186f42dbc0ab73825c9`.
- **Partial:** S. Gorchinskiy and V. Guletskii, *Motives and representability of algebraic cycles on threefolds over a field*, arXiv:0806.0173. Read: Theorems 8 and 15 and the intermediate-Jacobian proof. Cache key `arXiv:0806.0173`; SHA-256 `4b6f0ddf962a05eb88864ea5d6c03b10e3b3229069aad5a9cf46590c1caf6f10`.
- **Partial:** Rick Miranda and Ulf Persson, *On extremal rational elliptic surfaces*. Read: classification/list entry for `*II31`; cached primary PDF key `miranda-persson-list`, SHA-256 `aea519eda176148d6d486b93103b481cc4c71a76772650d6b7fe4fcb3dc0f4aa`.
- **Partial:** Stephan Herfurtner, *Elliptic surfaces with four singular fibres*, Math. Ann. 291 (1991), DOI 10.1007/BF01445211. Read: classification theorem and relevant table context from the full preprint. Cached primary PDF SHA-256 `31ca1ba95de600b26f174b016ba5963090a6a6031a24c9c0791204e8944dc814`.

## Recommendation

Promote the six-axis polarization theorem to the immediate target: it is exact, geometric, and apparently absent from the closest sources. Treat the Winger/cubic correspondence as the Annals gate. Do not frame the rational isogeny, the four-fiber surface, or abstract modularity as headline novelty.
