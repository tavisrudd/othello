# Two-variable rationalization and sharp stabilization of cubic threefolds
## Consolidated proof and manuscript-upgrade packet

**Baseline:** `cubic-stabilization-irrationality`, revision `f46624d`.  
**Companion interface:** the numerical cubic lower bound and the Hodge-conservation theorem in the consolidated `m1_upgrade_proof_packet.md`.  
**Prepared:** 9 September 2026.  
**Purpose:** a mathematical and editorial specification for upgrading the sharpness manuscript. This packet is not a substitute for independent review of the surface construction or the imported quantum comparison theorems.

The embedded checker was run while assembling this packet. It reconstructs the selected Cox tangent calculations, the uniform polynomial cover, the character lattices, the cubic-family calculations, the elliptic quotient identities, and the arithmetic certificates. The geometric descent, the identification of Galois actions with Picard actions, the intermediate-Jacobian comparison, and the imported one-stabilization theorems remain written proofs or external inputs. They are not certified by the program.

## Reading map

| Part | Contents |
|---|---|
| [I](#part-i) | Title, abstracts, hierarchy, main theorem statements, and framing |
| [II](#part-ii) | Dependency map, release gates, and division between the three papers |
| [III](#part-iii) | General torus-quotient criterion, unique orbit normalization, and explicitness contract |
| [IV](#part-iv) | Cox-model lattice, tangent section, uniform certificate, descent, and surface theorem |
| [V](#part-v) | Function-field transfer, the three-parameter cubic family, and exact levels |
| [VI](#part-vi) | The explicit pencil, uniform smoothness, Prym factors, and arithmetic twists |
| [VII](#part-vii) | Local isogeny certificates, positive-density families, and coefficient-height counts |
| [VIII](#part-viii) | Fano fourfolds, relative rationalization, and exact torus-linearization thresholds |
| [IX](#part-ix) | Retained generalizations, finite-index slices, and limitations |
| [X](#part-x) | Targeted edits against `f46624d`, integration order, and theorem ownership |
| [XI](#part-xi) | Attribution ledger and references |
| [XII](#part-xii) | Verification coverage and release checklist |
| [Appendix A](#appendix-a) | Exact Cox certificate data |
| [Appendix B](#appendix-b) | Optional recursive sequence and effective arithmetic candidate sets |
| [Appendix C](#appendix-c) | Standalone executable SymPy checker |

Start with Parts I, II, and X for editing. The independent rationalization proof is Parts III–V. The strongest arithmetic applications use Parts VI–VIII and import only the precisely stated cubic Hodge-conservation theorem, not the full moduli reconstruction package.

---

<a id="part-i"></a>
# Part I. Editorial scope and front matter

## 1. The paper's independent contribution

The central construction is:

> A saturated rank-three subtorus of the rank-five projective Cox torus admits a rational quotient. The quotient is simultaneously birational to the quartic del Pezzo surface times a rational two-dimensional torus. Thus two added variables suffice.

Lead with the surface theorem. The proof is geometric and independent of the quantum paper. Its strongest applications then combine this upper bound with two separately named inputs from the one-stabilization paper:

- the numerical lower bound, which proves exact level two;
- Hodge conservation, which separates different one-stabilizations.

The intended progression is

\[
\text{a uniform surface rationalization}
\ \Longrightarrow\
\text{families of two-variable rationalizations}
\ \Longrightarrow\
\text{sharp, arithmetically separated examples}.
\]

Do not recast the paper as a second proof of the lower bound. Do not make its independent construction depend on the moduli paper's inverse constructions, period gluing, essential dimension, or generic isogeny rigidity.

## 2. Recommended title

**Full-upgrade title**

> **Two-variable rationalization and sharp stabilization of cubic threefolds**

This retains the recognizable subject while putting the new construction first. The abstract must state that the uniform surface theorem is the independent main result and that only the specified cubic families are rationalized.

**Upper-bound-only title**

> **Two-variable rationalization of quartic del Pezzo surfaces**

Use this if the revised quantum lower bound is not ready to cite as an established theorem. The upper bound, its fibration consequences, and the explicit cubic family still form a complete paper.

The existing title is not mathematically wrong, but it makes the paper sound subordinate to the lower-bound manuscript. The new title should not suggest that every cubic threefold becomes rational after two variables, or that every stably rational quartic del Pezzo surface has exact level two.

## 3. Abstracts

### 3.1 Full target abstract

**Use after the surface proof and the cited lower-bound and Hodge-conservation inputs have been incorporated and audited.**

> We prove that a smooth quartic del Pezzo surface over a field of characteristic zero becomes rational after adjoining two variables whenever it has a rational point and its geometric Picard lattice is stably permutation. The construction uses a saturated rank-three subtorus of the projective Cox torus and a descended tangent section whose orbit normalization is given by maximal minors. Applying the theorem to a three-parameter family of cubic threefolds gives two-variable rationalizations over the fields of definition. The one-stabilization obstruction proved in a companion paper makes this bound sharp. For an explicit rational pencil, we compute the potential toric ranks of the intermediate Jacobians and obtain a positive-density set of integral parameters whose one-stabilizations are pairwise nonbirational even over the complex numbers, although every member becomes rational over the rationals after two stabilizations. The birational separation uses the companion paper's Hodge-conservation theorem. We also give a quadratic lower bound by displayed coefficient height, exact trivial-stabilization thresholds for rational torus actions, and a finite-index extension of the quotient criterion.

Keep the height clause only if the binary-form squarefree sieve is fully cited with its sector and congruence adaptation. The positive-density integral family alone is a strong principal application.

### 3.2 Exact-level abstract without Hodge conservation

> We prove that a smooth quartic del Pezzo surface over a field of characteristic zero becomes rational after adjoining two variables whenever it has a rational point and stably permutation geometric Picard lattice. We construct a saturated rank-three subtorus of the projective Cox torus and a rational quotient by a descended tangent section. The orbit normalization is explicit in maximal minors, and its nonemptiness is certified uniformly over the smooth surface parameter locus. The theorem gives two-variable rationalizations of the cubic series of Tschinkel and Zhang and of a three-parameter cubic family. Combining these constructions with the one-stabilization obstruction of a companion paper gives exact stabilization level two for every smooth member of the displayed family, over every characteristic-zero field extension. We deduce examples of nonrational Fano fourfolds that become rational after one further variable, and give extensions to fibrations and finite-index torus slices.

This version must not say that different fourfolds are pairwise nonbirational. Exact level and pairwise separation are different conclusions.

### 3.3 Upper-bound-only abstract

> Let \(S\) be a smooth quartic del Pezzo surface over a field of characteristic zero. We prove that \(S\times\mathbf P^2\) is rational if \(S\) has a rational point and its geometric Picard lattice is stably permutation. The new ingredient is a saturated rank-three subtorus of the rank-five projective Cox torus. A descended tangent section gives a rational quotient, while a generic equivariant trivialization identifies the same quotient with \(S\) times a two-dimensional torus. We provide exact certificates for the tangent section and apply the theorem to explicit surface fibrations, including a three-parameter family of smooth cubic threefolds. We also prove a finite-index version in which the degree of a rational parametrization divides the character-lattice index.

## 4. Suggested body hierarchy

| Section | Heading | Main purpose |
|---|---|---|
| 1 | Main results and stabilization levels | Surface theorem first; exact cubic levels; separated arithmetic family; dependency labels. |
| 2 | Rational quotients from tangent sections | Cofactors, unimodularity, descent, actual inverse on an isomorphism open. |
| 3 | A rank-three quotient of the Cox model | Saturation, Galois-stable weight spaces, uniform tangent-open argument. |
| 4 | Two-variable surface rationalization | Equivariant generic torsor splitting, residual torus, nonminimal reduction. |
| 5 | Surface fibrations and cubic families | TZ series, three-parameter family, uniform generic-fibre calculation, exact levels. |
| 6 | An arithmetic pencil | Smoothness, the minimum Prym calculation needed, five elliptic factors, potential toric ranks. |
| 7 | Sharp families and rational torus actions | Positive-density separation, height-count optional, fourfolds, exact linearization. |
| 8 | Further constructions and scope | Other base varieties, the two-quadrics application, finite-index slices, limits of the method. |
| Appendix A | Exact Cox and family certificates | Constants and independently executable checks. |
| Appendix B | Optional arithmetic and quotient extensions | Recursive prime sequence; S-unit candidates; zero-cycles; residual-bound optimization. |

Move the full intrinsic cubic-moduli theory to the new paper. In particular, do not reproduce the degree-40/10/4 moduli maps, two-curve Torelli, polarized degree-144/432 gluing, generic automorphism proofs, Brauer-gerbe calculation, essential dimension, or the special-pencil finite-correspondence rigidity proof here.

## 5. Main theorem hierarchy

### Theorem A — Two-variable surface rationalization

Let \(k\) have characteristic zero and let \(S/k\) be a smooth quartic del Pezzo surface. If

\[
S(k)\ne\varnothing,
\qquad
\operatorname{Pic}(S_{\bar k})\text{ is a stably permutation Galois lattice},
\]

then

\[
S\times\mathbf A^2\sim_k\mathbf P^4.
\]

In particular, every stably \(k\)-rational smooth quartic del Pezzo surface satisfies this conclusion.

**Dependencies:** the quotient construction in this paper, TZ's Cox geometry and type classification, and rationality of two-dimensional tori. No result from the quantum paper.

### Theorem B — A uniform family of exact level-two cubics

For a characteristic-zero field \(k\), let

\[
B(x,y)=\lambda x^3+\mu x^2y+\nu y^3
\]

and define

\[
\begin{aligned}
X_B:\quad &(z-x)u^2+6yuv+3(z+x)v^2-z^3\\
&\qquad+\frac34(x^2+3y^2)z+B(x,y)=0.
\end{aligned}
\tag{F}
\]

For every smooth member,

\[
X_B\times\mathbf P^2\sim_k\mathbf P^5.
\]

If the cubic one-stabilization lower bound [M1-LB] is used, then for every extension \(K/k\),

\[
\ell_K((X_B)_K)=2.
\]

The smooth parameter locus is nonempty and its image in complex cubic-threefold moduli has dimension three. The rationalization theorem does not require the moduli-dimension assertion.

### Corollary B.1 — Optimality also for surfaces over function fields

Let \(S/k(a)\) be the quartic del Pezzo generic fibre associated with a smooth \(X_B\) as in Part V. Assuming [M1-LB],

\[
\ell_{k(a)}(S)=2.
\]

Indeed, a rationalization of \(S\) after at most one variable over \(k(a)\) would rationalize \(X_B\) after at most one variable over \(k\). Thus the uniform surface bound itself is attained, for example over \(\mathbf C(a)\). This is an application of the cubic lower bound, not an independent surface obstruction, and it does not assert that every surface satisfying Theorem A has exact level two.

### Theorem C — Explicit pairwise separation after one stabilization

For \(t\in\mathbf Q^*\), let \(X_t\) denote (F) with \(B=t y^3\). Let

\[
\mathcal T=\{n\in\mathbf Z_{>0}:n\text{ squarefree},\ (n,6)=1\}.
\]

The intermediate Jacobians \(J(X_n)\), \(n\in\mathcal T\), are pairwise nonisogenous over \(\overline{\mathbf Q}\). Assuming [M1-HC],

\[
X_m\times\mathbf P^1\not\sim_{\mathbf C}X_n\times\mathbf P^1
\quad(m\ne n),
\]

while, independently of [M1-HC],

\[
X_n\times\mathbf P^2\sim_{\mathbf Q}\mathbf P^5.
\]

Assuming also [M1-LB], each cubic has exact level two and each fourfold \(X_n\times\mathbf P^1\) has exact level one.

### Theorem D — Quadratically many separated classes by displayed coefficient height

For reduced \(t=a/b>0\), impose

\[
1\le a\le H,\quad a/4<b<a/2,\quad a\equiv1\pmod6,\quad b\text{ odd},
\]

and require \(a(16a^2-27b^2)\) to be squarefree. These parameters give

\[
cH^2+o(H^2),\qquad c>0,
\]

pairwise nonisogenous intermediate Jacobians and hence, under [M1-HC], pairwise nonbirational one-stabilizations. After clearing denominators, the displayed cubic coefficients have height \(O(H)\).

**Dependencies:** Theorem A, the explicit intermediate-Jacobian factor calculation, standard local reduction theory, and the binary-form squarefree sieve. Use an intrinsic moduli-height claim only after a separate height comparison is proved.

### Corollary E — Exact rational-action thresholds

The arithmetic family produces infinitely many rational \(\mathbf G_m\)-actions on \(\mathbf A^5_{\mathbf Q}\), pairwise nonconjugate even in \(\operatorname{Cr}_5(\mathbf C)\), which become conjugate to a fixed diagonal action after adjoining one invariant variable. These statements use [M1-HC] for pairwise separation and [M1-LB] for exactness. The underlying rational-action construction and its upper linearization bound use Theorem A.

These are rational actions. Do not claim regular polynomial actions or regular conjugacy on affine space.

## 6. Suggested introduction paragraphs

> We study the number of independent variables needed to rationalize a stably rational variety. Our independent result is a uniform bound of two for quartic del Pezzo surfaces with a rational point and stably permutation geometric Picard lattice. The construction makes the two variables visible: a rank-three quotient of the seven-dimensional projective Cox model is rational, and a second description of the same quotient leaves a two-dimensional residual torus over the surface.

> The surface theorem supplies the upper bounds throughout the paper. Exactness comes from a separate one-stabilization obstruction for cubic threefolds. A further Hodge-conservation theorem from that companion paper is used only to distinguish different one-stabilizations. The geometric construction and all upper bounds are independent of either comparison theorem.

> An explicit rational pencil makes the separation quantitative. Its intermediate Jacobian is geometrically isogenous to a product of five elliptic curves. The potential toric ranks at finite primes record the numerator and a quadratic expression in the parameter. These ranks separate a positive-density set of integral parameters and a quadratic-size set of rational parameters, although all corresponding cubics become rational after two stabilizations.

> The construction is effective in the sense that the torus normalization and inverse graph are specified. The paper does not claim expanded rationalization formulas over every number field, a uniform elimination complexity bound, or an algorithm deciding stable rationality.

---

<a id="part-ii"></a>
# Part II. Dependencies, proof obligations, and release boundaries

## 7. Two imports from the one-stabilization paper

Use two explicit labels. The second is not a consequence of the first.

**[M1-LB] Cubic lower bound.** For every smooth complex cubic threefold \(X\), \(X\times\mathbf P^1\) is irrational. The characteristic-zero version follows by finitely generated descent. This is the input for exact level two.

**[M1-HC] Cubic Hodge conservation.** For smooth complex cubic threefolds \(X,Y\),

\[
X\times\mathbf P^1\sim_{\mathbf C}Y\times\mathbf P^1
\ \Longrightarrow\
H^3(X,\mathbf Q)\cong H^3(Y,\mathbf Q)
\]

as rational Hodge structures. Therefore \(J(X)\) and \(J(Y)\) are isogenous. No preservation of the principal polarization or integral lattice is assumed.

For varieties over a number field, a complex isogeny of their intermediate Jacobians descends to a finite extension of that number field. This follows from invariance of homomorphisms of abelian varieties under extension of algebraically closed characteristic-zero fields. It is what permits the local reduction test. Do not assume the isogeny is defined over the original number field.

The quantum packet distinguishes full-even and Hodge-fixed bulk bases. That comparison issue belongs there. Sharpness must cite the final theorem, not reconstruct its proof or suppress that distinction.

## 8. Dependency diagram

```text
TZ Cox geometry + tangent projection + Picard classification
                         |
character lattice + uniform slice certificate + descent
                         |
               surface theorem A
                  /             \
      generic-fibre family     finite-index/fibration extensions
                |
         two-variable upper bounds --------> relative rationalizations
          /                 \
      M1-LB              Prym + elliptic quotients
        |                         |
  exact level two           local nonisogeny certificates
                                  |
                                M1-HC
                                  |
                     pairwise one-stable separation
                                  |
                     fourfold and Cremona applications
```

The genus-two moduli correspondence, the degree-four map, essential dimension, and finite-isogeny-orbit theorems are absent from this diagram deliberately. None is needed for the headline arithmetic family.

## 9. Integration gates

| Gate | Required proof or check | What fails if omitted |
|---|---|---|
| S1 | Use tangent projection on an actual isomorphism open; the Cox model may be singular. | A merely generically injective restriction need not be birational in arbitrary characteristic. |
| S2 | Distinguish saturation from a finite-kernel parametrization; use a genuine subtorus. | Root extraction can masquerade as a rational section. |
| S3 | Prove the selected sum and its complement are Galois-stable, not each individual weight space. | The geometric section may not descend. |
| S4 | The four certificate opens cover the complete smooth surface-parameter locus. | A generic computation does not prove a uniform theorem. |
| S5 | Intersect the evaluation open with the relative tangent-projection isomorphism locus, then use rational-point density. | A splitting-field witness does not provide a rational pair over the ground field. |
| S6 | Use an equivariant generic trivialization of the universal torsor before quotienting. | Rationality of a total space or of a torus alone does not rationalize the quotient. |
| F1 | Identify the signed component action with the quartic-del-Pezzo Picard action and use subgroup containment. | A group-order check does not establish the Picard-lattice hypothesis. |
| J1 | Identify the genus-four component cover with the \(S_3\) Galois closure and invoke the exact Prym theorem. | A fixed elliptic curve on a cubic is not automatically an intermediate-Jacobian factor. |
| J2 | Distinguish geometric factorization from arithmetic models; record the \(-3\) and \(-6\) twists. | Untwisted finite-field traces can be wrong. |
| A1 | Use potential toric rank, not conductor or Frobenius equality over the original field. | A geometric isogeny may only exist after extension. |
| H1 | Cite an established [M1-HC] with its fixed-base comparison proved. | Nonisogenous Jacobians do not by themselves rule out one-stable birationality. |
| C1 | State the exact squarefree-value theorem, local factors, congruence restrictions, and sector adaptation. | The claimed quadratic density is not established by finite enumeration. |

S1–S6 are the existing surface proof's principal audit points. This packet reorganizes and makes them explicit; it does not replace them by the checker. F1 and J1 are written geometric arguments. H1 is an imported obligation. If H1 remains unsettled, retain the isogeny-separation statements but label their birational consequences conditional or omit them from the abstract.

## 10. What can be released independently

**Upper-bound revision:** Theorem A, the family upper bound, the TZ higher-dimensional series, the two-quadrics application, and the fibration theorem.

**Exact-level revision:** add [M1-LB], exact levels of smooth cubic members and their generic surface fibres, and nonrational fourfolds rationalized by one additional variable.

**Separated-family revision:** add J1–J2, the local-rank proof, and [M1-HC]. The squarefree integer family requires no analytic number-theoretic theorem beyond the elementary squarefree count.

**Optional full arithmetic revision:** add the binary-form sieve, the coefficient-height theorem, and the S-unit appendix. These should not delay the first three stages if their presentation would make the main proof less transparent.

No proof in the sharpness paper should cite the moduli paper for Theorem A or the cubic upper bound. If the minimal Prym argument is first written here, the moduli paper can cite it; if it is housed there, reproduce its short unpolarized argument here to avoid an unnecessary dependency on the full moduli theorem.

---

<a id="part-iii"></a>
# Part III. The quotient criterion and constructive content

## 11. Statement with an isomorphism-open hypothesis

Let \(k\) be infinite, let \(Z\subset\mathbf P(V)\) be geometrically integral of dimension \(n\), and let a rank-\(r\) torus \(T\) act projectively linearly and generically freely on \(Z\). Suppose tangent projection from a suitable smooth \(p\in Z(k)\) is birational onto \(\mathbf P^n\). Write

\[
\pi_p:Z\dashrightarrow\mathbf P(V/\widehat T_pZ),
\]

and choose \(k\)-defined opens \(U_p,V_p\) such that \(\pi_p:U_p\to V_p\) is an isomorphism.

Over a separable closure choose a diagonal lift of the projective action and \(r+1\) nonzero weight spaces \(V_{w_0},\ldots,V_{w_r}\). Require:

\[
w_1-w_0,\ldots,w_r-w_0
\quad\text{is a basis of }X^*(T_{k^{\mathrm s}}).
\]

Require also that

\[
W=\bigoplus_{j=0}^rV_{w_j},\qquad
\widehat B=\text{sum of the other weight spaces}
\]

descend to complementary subspaces of \(V\). Individual summands of \(W\) need not descend.

Let \(\Lambda\subset\mathbf P(V)\) be a \(k\)-linear codimension-\(r\) subspace containing both the embedded tangent space at \(p\) and \(\mathbf P(\widehat B)\). Write its equations as \(\lambda_1,\ldots,\lambda_r\). Suppose some geometric point \(x\in\Lambda\cap U_p\) lies in the free locus and, on writing \(x=\sum x_j+x_B\), the matrix

\[
A(x)_{ij}=\lambda_i(x_j)
\]

has rank \(r\) and all its maximal minors are nonzero. Then

\[
Z/T\sim_k\mathbf P^{n-r}.
\]

In characteristic zero this is the criterion used throughout. If the statement is retained over arbitrary infinite fields, its proof must use the actual isomorphism open, rather than the invalid general inference “generically injective, hence birational.”

## 12. Cofactor proof, including descent

For a variable point \(q=\sum q_j+q_B\), set

\[
\kappa_j(q)=(-1)^j\det A(q)_{\widehat j},
\qquad j=0,\ldots,r.
\]

On the open where all these cofactors are nonzero,

\[
A(q)(\kappa_0(q),\ldots,\kappa_r(q))^{\mathsf t}=0.
\]

Because the equations vanish on \(\widehat B\), the condition \(tq\in\Lambda\) is equivalent to

\[
A(q)(\chi^{w_0}(t),\ldots,\chi^{w_r}(t))^{\mathsf t}=0.
\]

The basis condition gives a unique solution

\[
\chi^{w_j-w_0}(t(q))=\frac{\kappa_j(q)}{\kappa_0(q)},
\qquad j=1,\ldots,r.
\tag{Q1}
\]

Its coordinates are Laurent monomials in the cofactor ratios. There is no extraction of a root. The point

\[
s(q)=t(q)q
\]

is the unique orbit intersection on this open. The incidence problem is defined over \(k\); Galois conjugation preserves it, and uniqueness shows that \(s\) descends. It is invariant along orbits.

Let \(C\) be the closure of the relevant slice component. At the given \(x\), the vector \((1,\ldots,1)\) spans the kernel, so \(s(x)=x\), and the relevant component meets \(U_p\). The quotient and \(C\) have the same function field.

The image of \(\Lambda\) under the ambient linear projection is a \(k\)-linear \(L\cong\mathbf P^{n-r}\). Since \(\Lambda\) contains the projection centre,

\[
\Lambda\cap U_p\cong L\cap V_p.
\]

The right side is a nonempty open in \(L\). This proves that the relevant component is rational and that its map to \(L\) is birational. It also identifies the inverse on an actual open, eliminating separability ambiguity.

Translations of every projective weight by the same character do not change (Q1). Reordering the chosen weights does not change the intrinsic orbit intersection. Those two observations should appear in the proof rather than being left to a convention in the certificate.

## 13. Inverse graph and what “explicit” means

Choose linear forms \(\rho_0,\ldots,\rho_{n-r}\) giving coordinates on \(L\). The quotient map is

\[
[q]\longmapsto[\rho_0(s(q)):\cdots:\rho_{n-r}(s(q))].
\]

If \(R_\alpha\) are homogeneous equations for \(Z\), its inverse graph is obtained on the selected component by

\[
R_\alpha(x)=0,\qquad \lambda_i(x)=0,\qquad
Y_j\rho_0(x)-Y_0\rho_j(x)=0.
\tag{Q2}
\]

Use the component meeting \(U_p\), with the nonvanishing conditions from that open. The isomorphism \(U_p\to V_p\) proves that both composites are identities. Merely eliminating the equations without specifying this component can retain extraneous components.

An executable rationalization over a specified number field requires the following data in addition to (Q1)–(Q2): an actual descended tangent pair, the chosen slice forms, an explicit generic torsor section, rational coordinates on the residual torus, and the composed maps with domains. The existence proof provides these objects abstractly. Neither the certificate nor this packet supplies expanded formulas for the resulting \(\mathbf P^5\dashrightarrow X_B\times\mathbf P^2\).

## 14. The simplex has an intrinsic torus interpretation

Let \(\Omega\) be the Galois set of \(r+1\) selected projective weights and let \(E/k\) be the corresponding étale algebra. Common translations disappear in

\[
\ker(\mathbf Z[\Omega]\xrightarrow{\sum}\mathbf Z)
\longrightarrow X^*(T),\qquad
(n_w)\longmapsto\sum n_ww.
\]

Unimodularity makes this an isomorphism. Hence

\[
T\cong\operatorname{Res}_{E/k}\mathbf G_m/\mathbf G_m.
\]

Its underlying variety is the norm-nonzero open in \(\mathbf P(E)\), so it is rational. This explains the selected simplex, but it does not prove rationality of \(Z/T\). That still uses the tangent section.

---

<a id="part-iv"></a>
# Part IV. Cox model, uniform tangent section, and the surface theorem

## 15. Imported Cox geometry

For a smooth quartic del Pezzo surface \(S\), choose the universal torsor \(\mathcal T\to S\) whose fibre above a selected rational point is trivial. Its Néron–Severi torus \(T\) has character lattice \(\operatorname{Pic}(S_{\bar k})\) of rank six. The anticanonical cocharacter acts by a common scalar on the sixteen Cox generators. Thus

\[
T_0=T/\mathbf G_m,
\qquad \operatorname{rk}T_0=5,
\]

acts on the seven-dimensional projective Cox model

\[
Z_{\bar k}=\operatorname{Proj}\operatorname{Cox}(S_{\bar k})
\subset\mathbf P^{15}_{\bar k}.
\]

TZ supply the one-apparent-double-point property, the tangent-projection theorem applicable to this possibly singular model, rational-point density for the relevant torsor, and the minimal-type classification [TZ, Lemmas 2.1 and 3.2, Theorem 2.4, Corollary 3.5, Proposition 4.1 and Lemma 4.2]. These are inputs, not consequences of the new lattice calculation.

For a minimal quartic del Pezzo surface, the stable-permutation hypothesis places the Galois image in one of the four types \(I_0,I_1,I_2,I_3\). Up to marking, the first three embed in the fourth. This is a statement about the relevant minimal Picard actions, not a classification of all subgroups of \(W(D_5)\).

## 16. The saturated rank-three lattice

Write \(H,E_1,\ldots,E_5\) for the standard Picard marking and use

\[
b_i=E_i-E_5\ (1\le i\le4),\qquad b_5=H-3E_5
\]

as a basis of \(X^*(T_0)=(-K_S)^\perp\). Let \(e_i\) be the dual cocharacters. The desired saturated lattice is

\[
N_3=\mathbf Z e_3\oplus\mathbf Z e_4\oplus\mathbf Z e_5.
\]

The character matrices of the full \(I_3\) generators are

\[
A=\begin{pmatrix}
-1&0&0&-1&-1\\
1&1&1&0&2\\
0&0&-1&-1&-1\\
0&0&0&0&1\\
0&0&0&1&0
\end{pmatrix},\qquad
B=\begin{pmatrix}
0&1&1&1&2\\
-1&-1&0&0&-1\\
0&0&1&0&0\\
0&0&0&1&0\\
0&0&-1&-1&-1
\end{pmatrix}.
\]

Their cocharacter actions on \(N_3\) are

\[
\begin{pmatrix}-1&0&0\\-1&0&1\\-1&1&0\end{pmatrix},
\qquad
\begin{pmatrix}1&0&-1\\0&1&-1\\0&0&-1\end{pmatrix}.
\]

Thus \(N_3\) defines a rank-three \(k\)-subtorus \(T_3\subset T_0\).

The three visible sign vectors \((0,1,1),(1,0,1),(1,1,0)\) span an index-two sublattice. They parametrize the same torus with kernel \(\mu_2\); they do not provide its full cocharacter lattice. Use the saturation throughout. The extra degree from those parameters is not a degree of the Rosenlicht quotient.

## 17. Selected weight spaces and actual normalization

After a common translation, the four chosen weights and spaces are

| Weight | Cox generators spanning the weight space |
|---|---|
| \(011\) | \(L_{13},L_{23},L_{35}\) |
| \(101\) | \(L_{14},L_{24},L_{45}\) |
| \(110\) | \(E_1,E_2,E_5\) |
| \(111\) | \(L_{12},L_{15},L_{25}\) |

Their complement is

\[
B=\mathbf P\langle E_3,E_4,L_{34},Q\rangle.
\]

The four selected spaces are permuted as a set by Galois, and the complement is stable. The three differences from \(011\) form an integral basis. These are two separate facts: Galois stability proves descent, while the determinant-one statement proves uniqueness of normalization and generic freeness.

In splitting-field coordinates the cofactor correction is

\[
(t_1,t_2,t_3)
=
\left(\frac{\kappa_3}{\kappa_0},
      \frac{\kappa_3}{\kappa_1},
      \frac{\kappa_3}{\kappa_2}\right).
\tag{C1}
\]

Only the corrected point must descend. The individual coordinates in (C1), or the individual weight spaces, need not be defined over \(k\).

The selected Galois set identifies

\[
T_3\cong\operatorname{Res}_{E_4/k}\mathbf G_m/\mathbf G_m.
\]

The residual character lattice is generated by \(b_1,b_2\), with matrices

\[
\begin{pmatrix}-1&0\\1&1\end{pmatrix},\qquad
\begin{pmatrix}0&1\\-1&-1\end{pmatrix}.
\]

They permute \((0,1),(1,-1),(-1,0)\), whose only relation is their sum. Thus

\[
T_0/T_3\cong\operatorname{Res}^{1}_{E_3/k}\mathbf G_m
\]

for a cubic étale algebra \(E_3\). Rationality also follows directly from the general theorem on two-dimensional tori [V]. Both identifications restrict to smaller Galois images.

## 18. Tangent section: three distinct arguments

### 18.1 Geometric nonemptiness

For a smooth \(p\in Z\), let \(H_p\) be the space of tangent hyperplanes containing \(B\). Consider pairs \((p,x)\) for which

\[
\dim H_p=4,
\qquad
\operatorname{ev}_{p,x}:H_p\longrightarrow\bar k^4,
\quad\lambda\longmapsto(\lambda(x_0),\ldots,\lambda(x_3))
\]

is an isomorphism. These conditions define an open locus \(\mathcal E_{\rm ev}\).

The standard smooth blowup-parameter chart is

\[
\Delta=ab(a-1)(b-1)(a-b)\ne0.
\]

Appendix A gives four explicit choices with Jacobian minors \(M_i\) and evaluation determinants \(D_i\). The products \(D_iM_i\) have no common zero on this chart. Therefore the evaluation open is geometrically nonempty for every smooth quartic del Pezzo parameter, not only generically in \((a,b)\).

The coordinate formulas parametrize points on the Cox model. The eight selected quadrics suffice to certify tangent rank on the stated minor charts, but do not replace the full twenty-quadric model. The repository's all-quadrics check must be retained. The embedded independent checker tests the eight printed rows and the four-determinant cover; its scope is narrower.

### 18.2 Meet the tangent-projection isomorphism locus

Over a dense open \(G\subset Z_{\rm sm}\), generic tangent projection is birational. Use the relative tangent projection over \(G\), shrink its domain, and obtain a relative isomorphism on an open

\[
\mathcal U\subset G\times Z.
\]

The open \(\mathcal E_{\rm ev}\cap\mathcal U\) is nonempty: both conditions meet the integral product over the generic tangent point. Its projection contains a nonempty open \(G_0\subset G\). For \(p\in G_0\), it gives a nonempty open of suitable \(x\)'s in \(Z\).

This is why the finite witness table need not itself consist of points in the final isomorphism locus. It establishes an open condition; the relative argument then meets it with the other required open.

### 18.3 Arithmetic descent and density

The spaces \(W\), \(\widehat B\), and the relevant incidence conditions descend. The universal torsor chosen above a rational surface point has dense \(k\)-points by TZ; so does its projective Cox model. Choose

\[
p\in G_0(k),\qquad
x\in(\mathcal E_{\rm ev}\cap\mathcal U)_p(k).
\]

The functional \(H_p\to k\), \(\lambda\mapsto\lambda(x)\), is nonzero. Its kernel has dimension three; take a \(k\)-basis \(\lambda_1,\lambda_2,\lambda_3\) to define \(\Lambda\).

Under the evaluation isomorphism, this kernel is the hyperplane in \(k^4\) on which the coordinate sum is zero. The resulting \(3\times4\) coefficient matrix has kernel spanned by \((1,1,1,1)\), so all four maximal minors are nonzero. This proves the quotient criterion's hypothesis over \(k\).

No individual displayed witness is claimed to descend. Restriction from \(I_3\) to its relevant subgroups preserves the open conditions and the lattice data.

## 19. Proof of Theorem A

In the minimal case the preceding construction gives

\[
Z/T_3\sim_k\mathbf P^4.
\tag{C2}
\]

The stable-permutation identity for the Picard lattice gives

\[
T\times Q\cong Q'
\]

for quasi-trivial tori \(Q,Q'\). Hilbert 90 then implies

\[
H^1(F,T)=0\qquad\text{for every extension }F/k.
\]

In particular, the universal torsor over the generic point of \(S\) is trivial. A rational section provides a **\(T\)-equivariant** birational isomorphism

\[
S\times T\dashrightarrow\mathcal T.
\]

Quotient first by the scalar torus, then by \(T_3\). The resulting map remains equivariant, and

\[
Z/T_3\sim_k S\times(T_0/T_3).
\tag{C3}
\]

Since the residual torus is rational of dimension two, (C2) and (C3) prove

\[
S\times\mathbf A^2\sim_k\mathbf P^4.
\]

The dimension accounting is

\[
\dim(Z/T_3)=7-3=4=2+2.
\]

For a nonminimal \(S\), contract a \(k\)-defined union of disjoint exceptional curves to a del Pezzo surface of degree at least five. Its rational point makes it rational by the classical theorem; therefore \(S\) is already rational.

Finally, stable rationality over the infinite field \(k\) supplies a rational point, and the stable birational Picard obstruction makes the geometric Picard lattice stably permutation. This proves the last assertion of Theorem A [Manin; TZ, Corollary 4.3].

The proof uses generic triviality, not a global trivialization of the universal torsor. It neither constructs a nontrivial global isogeny self-cover of the universal torsor nor asserts that the torsor bundle is globally a product.

---

<a id="part-v"></a>
# Part V. Function fields, uniform cubic families, and exact levels

## 20. Transfer through a surface fibration

Let \(Y\dashrightarrow B\) be a dominant rational map of geometrically integral characteristic-zero varieties, with generic fibre birational over \(K=k(B)\) to a surface satisfying Theorem A. Then

\[
k(Y)(u,v)\cong K(z_1,z_2,z_3,z_4),
\]

so

\[
Y\times\mathbf A^2\sim_k B\times\mathbf A^4.
\tag{F1}
\]

For every \(W\) and \(a\ge0\),

\[
\ell_k(W\times\mathbf A^a)=\max\{\ell_k(W)-a,0\},
\]

including the value infinity. Hence

\[
\boxed{\max\{\ell_k(Y)-2,0\}=\max\{\ell_k(B)-4,0\}.}
\tag{F2}
\]

If \(B\) is rational, \(\ell_k(Y)\le2\). If \(\ell_k(B)\le4\), the same conclusion holds. If \(4<\ell_k(B)<\infty\), then \(\ell_k(Y)=\ell_k(B)-2\). Do not subtract two without the truncation in (F2).

The argument takes place over \(k(B)\) and gives a rational map over \(k\). It does not require a simultaneous choice of rational points on every closed fibre.

## 21. The three-parameter family: explicit generic fibre

Use (F) with

\[
B(x,y)=\lambda x^3+\mu x^2y+\nu y^3.
\]

Let \(a=x/y\), put \(A=a^2+3\), \(\beta=B(a,1)\), and work over \(K=k(a)\). The generic cubic-surface fibre is birational to

\[
S=\{Q_1=Q_2=0\}\subset\mathbf P^4_{[u:v:w:z:h]},
\]

where

\[
\begin{aligned}
Q_1&=-au^2+6uv+3av^2+\beta w^2-zh,\\
Q_2&=u^2+3v^2+\frac34Aw^2-z^2+wh.
\end{aligned}
\tag{F3}
\]

Indeed, \(wQ_1+zQ_2\) eliminates \(h\) and gives the cubic-surface equation. On \(w\ne0\), \(Q_2\) recovers \(h\) uniquely. The point

\[
[0:0:0:0:1]\in S(K)
\]

is rational; the two gradients there are independent.

Set

\[
c(T)=T^3-\frac34AT-\beta.
\]

The pencil determinant is

\[
\det(Q_1+TQ_2)=\frac34(T^2-A)c(T).
\tag{F4}
\]

Here determinants use symmetric matrices, with off-diagonal entries equal to half the corresponding cross coefficients.

## 22. Smoothness of the generic del Pezzo surface

The roots of (F4) are distinct. First,

\[
\operatorname{disc}(c)=\frac{27}{16}A^3-27\beta^2.
\]

The polynomial \(A=a^2+3\) has simple zeros over \(\bar k\), so \(A^3\) is not a square in \(k(a)\). Thus the discriminant does not vanish. If \(s^2=A\), then

\[
c(s)c(-s)=\beta^2-\frac1{16}A^3\ne0.
\]

The quadratic factor also has two distinct roots. The intersection of quadrics is therefore a smooth quartic del Pezzo surface.

This argument is uniform in the coefficient parameters. It uses a divisor-valuation obstruction to a rational-function square, not a claim that \(A\) is nonsquare in the field of constants.

## 23. The component calculation proves Galois containment

The associated conic bundle is

\[
(T-a)u^2+6uv+3(T+a)v^2=c(T)w^2.
\tag{F5}
\]

Let \(\rho_1,\rho_2,\rho_3\) be the roots of \(c\), and use cyclic differences

\[
d_1=\rho_2-\rho_3,\quad d_2=\rho_3-\rho_1,\quad d_3=\rho_1-\rho_2.
\]

The coefficient relations give

\[
d_i^2=3(A-\rho_i^2).
\]

At \(T=\rho_i\), the two components have equations

\[
(\rho_i-a)u+(3\pm d_i)v=0.
\tag{F6}
\]

These are actual nonzero equations in the chosen three-parameter family. Indeed,

\[
c(a)=\frac14a^3-\frac94a-\beta
\]

is not identically zero because \(\beta=\lambda a^3+\mu a^2+\nu\) has no term of degree one. Thus no root \(\rho_i\) equals \(a\).

**Do not silently extend this exact chart argument to arbitrary binary cubics.** An \(xy^2\)-coefficient can make \(c(a)=0\) identically, in which case one of the displayed equations may vanish and a second factor chart is required. The three-parameter family and pencil used in this paper avoid that issue. A full four-coefficient version can be added with the missing chart explicitly supplied.

For the remaining two fibres choose

\[
e_+^2=(s-a)c(s),\qquad e_-^2=(-s-a)c(-s).
\]

Their components are

\[
(s-a)u+3v=\pm e_+w,
\qquad
(-s-a)u+3v=\pm e_-w.
\tag{F7}
\]

The compatibility identity is

\[
\boxed{e_+^2e_-^2=\frac{\operatorname{disc}(c)}9
       =\frac{(d_1d_2d_3)^2}{9}.}
\tag{F8}
\]

Choose signs so that \(e_+e_-=d_1d_2d_3/3\). An even permutation of the three roots permutes the \(d_i\); an odd permutation also negates all three. Relation (F8) forces the corresponding parity on the exchanges in the last two fibre pairs. The square root \(s\) can also be exchanged with \(-s\).

Label the fibre pairs by \(\rho_1,\rho_2,\rho_3,s,-s\), and let \(c_i\) exchange the two components in pair \(i\). The action is contained in

\[
H=\langle(4\,5),\ c_4c_5,\ (1\,2\,3),\
       c_1c_2c_3c_5(2\,3)\rangle\subset W(D_5).
\tag{F9}
\]

TZ identify this signed action with their \(I_3\) Picard action [TZ, Proposition 5.3]. Retain that identification explicitly: the components encode the five pairs of conic-pencil classes on the contracted quartic del Pezzo surface. The checker verifies that the displayed group has order 24 and even sign parity; those checks alone do not identify its Picard representation.

The Picard lattice for \(H\) is stably permutation by [TZ, Lemma 4.2]. This property survives restriction to any subgroup. Therefore the actual Galois image need not be all of \(H\), at either a special parameter or after field extension.

Theorem A now applies over \(K=k(a)\). Since \(k(X_B)=K(S)\), (F1) proves

\[
X_B\times\mathbf P^2\sim_k\mathbf P^5.
\]

## 24. Exact level and its field quantifier

Assume [M1-LB]. If \(X_B\times\mathbf P^1\) were rational over a characteristic-zero field \(K\), its equation, rationalization, inverse, and their composition identities would descend to a finitely generated subfield. Embed that field into \(\mathbf C\). Smoothness is preserved and [M1-LB] gives a contradiction.

Combining with the upper bound proves \(\ell_K(X_B)=2\), after every characteristic-zero extension of the original coefficient field.

Apply the same argument to the generic surface in (F3). If it were rational after at most one variable over \(k(a)\), then \(k(X_B)\) would become purely transcendental over \(k\) after at most one variable. Thus \(\ell_{k(a)}(S)=2\). This is a concise proof that the two-variable surface bound is uniformly optimal over the class of characteristic-zero ground fields.

Do not extend this exact-level conclusion to the higher-dimensional cubic series solely because their upper bound is also two. [M1-LB] is a threefold theorem.

## 25. A genuine three-dimensional locus and relative rationalization

At \((\lambda,\mu,\nu)=(0,0,1)\), the homogeneous Jacobian ideal contains the sixth powers of all five variables. Thus the seed is smooth. In the 35-dimensional space of cubic forms, the coordinate-orbit tangent has rank 25; adjoining

\[
x^3,\quad x^2y,\quad y^3
\]

raises the rank to 28. The map to cubic moduli has rank three. Since the parameter space has dimension three, its moduli image has dimension exactly three and the map is generically finite to that image.

This assertion does not need an intrinsic identification of the image with any genus-two moduli space. That identification belongs in the moduli paper.

Apply the upper-bound construction over the coefficient field \(k(\lambda,\mu,\nu)\). The rationalization and its inverse use finitely many coefficients and denominators. After shrinking the smooth parameter space \(T\), they spread to a birational map over \(T\):

\[
\mathcal X\times\mathbf P^2\sim_T\mathbf P^5\times T.
\]

This is a birational map on relative dense opens. It is not a regular trivialization, and it need not specialize to the chosen map on every closed fibre. Separately, the all-parameter argument gives a rationalization for each smooth fibre over its own field.

Under [M1-HC], no positive-dimensional subfamily with nonconstant cubic moduli can become birationally isotrivial after only one stabilization. If all such products were birational to a fixed product, their intermediate Jacobians would lie in one isogeny class. There are only countably many principally polarized abelian varieties in a fixed complex isogeny class; cubic Torelli then gives a countable moduli image, incompatible with a positive-dimensional constructible image.

This statement does not construct a moduli space of one-stable birational equivalence classes. It is a statement about algebraic families and their ordinary cubic moduli maps.

## 26. Retain the TZ applications and add the two-quadrics upper bound

The original equations

\[
\begin{aligned}
X_1:&\ (x_4-2x_3)x_1^2+3(x_4+2x_3)x_2^2
      +3x_3^2x_4-x_4^3+x_5^3=0,\\
X_3:&\ x_4(x_1^2+2x_1x_2)+x_3(x_1^2+x_1x_2+x_2^2)
      +x_3^3-x_3x_4^2+x_4^3+2x_5^3=0
\end{aligned}
\]

and the series obtained by adding \(\sum w_i^3\) remain useful named applications. TZ supply the generic fibres, rational points, smoothness, and Galois types. Theorem A upgrades their stable rationality to rationality after exactly two added variables as an upper bound; exactness is asserted for the threefold members using [M1-LB].

For [TZ, Example 5.2], let

\[
\begin{aligned}
q_1&=2x_1^2-6x_2^2+3x_3^2-3x_3x_4+x_5^2-x_4x_6,\\
q_2&=x_1^2+3x_2^2-x_4^2-x_3x_6.
\end{aligned}
\]

The smooth intersection \(Y=\{q_1=q_2=0\}\subset\mathbf P^5_{\mathbf Q}\) has a type-\(I_1\) quartic-del-Pezzo generic fibre over \(\mathbf Q(a)\). Theorem A gives

\[
Y\times\mathbf P^2\sim_{\mathbf Q}\mathbf P^5,
\]

hence also over \(\mathbf R\). TZ prove \(Y\) nonrational over both fields, so its level is either one or two there. Nothing here proves its exact level is two. Over \(\mathbf C\), this smooth intersection of two quadrics is rational.

The reference in Example 5.2(2) should point to the pair of quadrics immediately following their equation (5.1), not to the cubic surface (5.1) itself. Cite the geometric generic fibre rather than perpetuating that local cross-reference ambiguity.

---

<a id="part-vi"></a>
# Part VI. The explicit pencil and its arithmetic isogeny factors

## 27. The pencil and its complete smoothness condition

Set

\[
X_t:\ (z-x)u^2+6yuv+3(z+x)v^2-z^3
+\frac34(x^2+3y^2)z+t y^3=0.
\tag{P1}
\]

In characteristic different from two and three, it is smooth exactly when

\[
t(16t^2-27)\ne0.
\tag{P2}
\]

In particular every nonzero rational parameter is smooth.

Write \(F=\mathbf w^{\mathsf t}M\mathbf w+g\), with \(\mathbf w=(u,v)^{\mathsf t}\) and

\[
M=\begin{pmatrix}z-x&3y\\3y&3(z+x)\end{pmatrix},
\quad
g=-z^3+\frac34(x^2+3y^2)z+t y^3.
\]

The determinant conic is \(Q:z^2=x^2+3y^2\).

If \(M\) is invertible at a singular point, the derivatives in \(u,v\) force \(u=v=0\), so the point is singular on the plane cubic \(E_t:g=0\). If \(M\) has rank one and \(\mathbf w\ne0\), its adjugate is a nonzero scalar multiple of \(\mathbf w\mathbf w^{\mathsf t}\). The remaining derivatives imply that \(E_t\) and \(Q\) are not transverse there. If \(M\) has rank zero, then \(x=y=z=0\); along that fixed line the three derivatives

\[
-u^2+3v^2,\quad 6uv,\quad u^2+3v^2
\]

cannot vanish simultaneously at a projective point.

The linear substitution

\[
[X:Y:Z]=[-12ty:36tx:z]
\]

identifies \(E_t\), for \(t\ne0\), with

\[
Y^2Z=X^3-27X^2Z+1728t^2Z^3.
\]

In short Weierstrass form this is

\[
E_t:\quad Y^2=X^3-243X+(1728t^2-1458).
\tag{P3}
\]

Its discriminant is \(-2^{12}3^9t^2(16t^2-27)\). Thus \(E_t\) is smooth under (P2).

Parametrize \(Q\) by

\[
x=r^2-3s^2,\quad y=2rs,\quad z=r^2+3s^2.
\]

The restriction of \(4g\) is

\[
32t r^3s^3-(r^2+3s^2)^3.
\]

Its sextic discriminant is

\[
2^{26}3^{12}t^4(16t^2-27).
\]

Therefore \(E_t\cap Q\) is transverse under (P2), proving smoothness of \(X_t\). Conversely, a singular point of \(E_t\) gives a singular point of \(X_t\) on the fixed plane. At \(t=0\), that plane cubic is reducible and singular; at the other excluded values its Weierstrass discriminant vanishes. This proves the claimed exact smooth locus.

This uniform argument is the proof. Sample Gröbner checks in the program are independent tests, not a replacement for it.

## 28. The minimum intermediate-Jacobian input

The following argument is sufficient for the arithmetic applications. It avoids the full moduli reconstruction and the polarized degree-144/432 calculations.

Projection from the pointwise fixed line realizes the conic discriminant as \(E_t\cup Q\). Projecting \(E_t\) from \([0:0:1]\) gives a degree-three map

\[
f:E_t\longrightarrow\mathbf P^1.
\]

Under (P2), it has six simple branch values. Its Galois closure \(W\to\mathbf P^1\) is an \(S_3\)-cover, with

\[
g(W)=4,\quad W/A_3=C_t,\quad W/\langle\text{transposition}\rangle=E_t,
\]

where geometrically

\[
C_t:\quad \eta^2=16t^2-(x^2+3)^3.
\tag{P4}
\]

To identify \(W\) with the component cover over \(E_t\), take \(z\) as one root of the elliptic cubic equation. The difference of the other two roots satisfies

\[
(z_2-z_3)^2=3(x^2+3y^2-z^2).
\]

This is the same square class that splits the binary quadratic form over \(E_t\). Thus the genus-four cover in the conic-bundle theorem is the \(S_3\) Galois closure, not an unrelated double cover of the same genus.

The conic-component double cover is geometrically

\[
H_t:\quad \xi^2=32tx^3-(x^2+3)^3.
\tag{P5}
\]

The general Prym theorem [CMZ, Theorem 2.9] gives an isogeny

\[
\bigl(J(W)/f_2^*J(E_t)\bigr)\times J(H_t)\longrightarrow J(X_t).
\]

The \(S_3\)-action on \(W\) gives

\[
J(W)\sim J(C_t)\times J(E_t)^2.
\]

For example, the invariant part under \(S_3\) has dimension zero, the sign-isotypic part has dimension two, and the remaining standard part has dimension two; the transposition-invariant elliptic quotient identifies the latter with two isogenous elliptic factors. Passing to the quotient by one elliptic factor yields

\[
\boxed{J(X_t)\sim E_t\times J(C_t)\times J(H_t).}
\tag{P6}
\]

All statements in (P6) are geometric isogenies. They are sufficient for potential reduction, because the isogenies and factor maps are defined after a finite extension. They do not assert a product principal polarization.

## 29. Arithmetic twists: retain the correction

For finite-field computations over \(\mathbf Q\), the component curves corresponding to (P6) are

\[
E_t,\qquad C_t^{(-3)},\qquad H_t^{(-6)},
\tag{P7}
\]

where \(C^{(d)}\) means multiplication of the displayed hyperelliptic right-hand side by \(d\).

The cubic-polynomial discriminant is square-equivalent to \(-3C_t\). On the conic parametrization above, the binary quadratic form is \(6(su+rv)^2\), while \(g=H_t/4\). Its component square class is \(-H_t/24\), equivalent to \(-6H_t\).

These twists do not affect geometric isogenies, elliptic \(j\)-invariants, or potential toric ranks. They do affect Frobenius traces over the original finite field. The checker verifies the corrected trace identity against direct cubic point counts at several primes. Do not reuse the un-twisted traces as arithmetic factors over \(\mathbf Q\).

The algebraic correspondences, not the agreement of a finite number of point counts, establish the decomposition. The trace checks are consistency tests of its arithmetic normalization.

## 30. Five explicit elliptic factors

The two maps from \(C_t\) are

\[
(x,\eta)\mapsto(x^2,\eta),
\qquad
(x,\eta)\mapsto(x^2,x\eta).
\]

They give

\[
E_0:\ Y^2=16t^2-(U+3)^3,
\qquad
E_2:\ Y^2=U\bigl(16t^2-(U+3)^3\bigr).
\]

The pullbacks of their regular differentials span the differential space of \(C_t\), so

\[
J(C_t)\sim E_0\times E_2.
\]

Here \(j(E_0)=0\), and write \(E_1=E_t\).

Put

\[
s=\frac{4t}{3\sqrt3},\qquad k_0=8s.
\]

After a geometric scaling, \(H_t\) has equation \(y^2=(x^2+1)^3-k_0x^3\). Its two elliptic quotient maps are

\[
U=x+x^{-1},\qquad V_\pm=\frac{y(x\pm1)}{x^2},
\]

with equations

\[
E_\pm:\quad V_\pm^2=(U\pm2)(U^3-k_0).
\]

Their differential pullbacks are again independent. Consequently

\[
\boxed{J(X_t)\sim E_0\times E_1\times E_2\times E_+\times E_-.}
\tag{P8}
\]

The exact \(j\)-invariants are

| Factor | \(j\) |
|---|---|
| \(E_0\) | \(0\) |
| \(E_1\) | \(432/[s^2(1-s^2)]\) |
| \(E_2\) | \(-6912s^2/(s^2-1)^2\) |
| \(E_+\) | \(6912s/(s+1)^2\) |
| \(E_-\) | \(-6912s/(s-1)^2\) |

If \(c=j(E_2)\), then

\[
j(E_+)+j(E_-)=4c,
\qquad
j(E_+)j(E_-)=6912c.
\tag{P9}
\]

The local-rank computation uses (P8)–(P9); it does not need generic pairwise nonisogeny of the factors or the finite-correspondence rigidity theorem of the moduli paper.

---

<a id="part-vii"></a>
# Part VII. Arithmetic signatures and separated sharp families

## 31. Exact potential toric rank

For \(t=a/b\in\mathbf Q^*\) in lowest terms, \(b>0\), write

\[
D_t=16a^2-27b^2.
\]

For a prime \(p\), let \(\rho_p(t)\) be the torus dimension in semistable reduction of \(J(X_t)\) after a sufficiently large finite extension of \(\mathbf Q_p\). This eventual rank is unchanged by further finite extension and by geometric isogeny.

For every \(p\ge5\),

\[
\boxed{
\rho_p(t)=
\begin{cases}
1,&p\mid a,\\
3,&p\mid D_t,\\
0,&\text{otherwise}.
\end{cases}}
\tag{A1}
\]

The two nonzero cases are disjoint, and denominator primes have rank zero.

### Proof

In terms of \(a,b\),

\[
j(E_1)=-\frac{19683b^4}{a^2D_t},
\qquad
c=j(E_2)=-\frac{2985984a^2b^2}{D_t^2}.
\]

The remaining two \(j\)-invariants are the roots of

\[
Z^2-4cZ+6912c=0.
\]

At \(p\ge5\), if \(c\) is integral, both roots are integral. If \(v_p(c)<0\), the Newton polygon gives root valuations \(0\) and \(v_p(c)\). Exactly one of \(E_+,E_-\) then has potentially multiplicative reduction. The constant factor \(E_0\) is potentially good.

An elliptic curve is potentially good precisely when its \(j\)-invariant is integral. Therefore (P8) gives

\[
\rho_p(t)=\mathbf1_{v_p(j(E_1))<0}
          +2\mathbf1_{v_p(c)<0}.
\]

If \(p\mid a\), then \(D_t\) is a unit and only the first summand contributes. If \(p\mid D_t\), both \(a,b\) are units and all three indicated factors contribute. If \(p\mid b\), \(D_t\) is a unit and both displayed invariants are integral. The remaining case is immediate. This proves (A1).

The geometric nature of the test is essential. A complex isogeny between abelian varieties defined over \(\mathbf Q\) descends to a finite extension of \(\mathbf Q\); embed that extension at \(p\). Semistable toric rank is preserved after that extension. Thus a discrepancy in (A1) rules out an isogeny even over \(\mathbf C\).

Do not replace \(\rho_p\) by the conductor, the original-field reduction type, or a claim that Frobenius polynomials agree over \(\mathbf Q\). Those are not the invariants being used.

## 32. Positive-density integral parameters

Let \(\mathcal T\) be the positive squarefree integers prime to six. If \(m,n\in\mathcal T\) are distinct, there is a prime \(p\ge5\) dividing exactly one of them. Suppose it divides \(m\). Then

\[
\rho_p(m)=1,
\qquad
\rho_p(n)\in\{0,3\}.
\]

So \(J(X_m)\) and \(J(X_n)\) are not geometrically isogenous. [M1-HC] gives pairwise nonbirationality of their one-stabilizations. Theorem A and the family argument give rationality after two variables, over \(\mathbf Q\), for every member.

The elementary squarefree sieve gives

\[
\#\{n\le H:n\in\mathcal T\}
=\frac3{\pi^2}H+O(\sqrt H).
\]

This is the preferred first arithmetic theorem: its local separation proof is short and its parameter set is nonrecursive. Keep the earlier recursive prime construction as a minimal-input appendix, not as a competing main family.

## 33. Reconstruction of selected rational parameters

Assume

\[
a>0,\quad (a,6)=1,\quad b>0\text{ odd},\quad
D_t>0,\quad aD_t\text{ squarefree}.
\tag{A2}
\]

Let

\[
S_1(t)=\{p\ge5:\rho_p(t)=1\},
\qquad
S_3(t)=\{p\ge5:\rho_p(t)=3\}.
\]

The arithmetic restrictions ensure that neither \(a\) nor \(D_t\) has a factor two or three. Equation (A1) recovers them exactly:

\[
\boxed{
a=\prod_{p\in S_1(t)}p,
\qquad
D_t=\prod_{p\in S_3(t)}p,
\qquad
b=\sqrt{\frac{16a^2-D_t}{27}}.
}
\tag{A3}
\]

Thus the complete potential-rank profile determines \(t\) within (A2). For example,

\[
S_1=\{19\},\qquad S_3=\{61,73\}
\]

gives \(a=19\), \(D_t=4453\), \(b=7\), and \(t=19/7\).

This is not a recovery theorem for targets outside (A2). Potential rank records support and the values one or three, not the multiplicities of prime factors.

## 34. Quadratic coefficient-height growth

Take

\[
1\le a\le H,\qquad a/4<b<a/2,
\qquad a\equiv1\pmod6,
\qquad b\equiv1\pmod2,
\]

and impose squarefreeness of

\[
F(a,b)=a(16a^2-27b^2).
\]

The sector makes \(D_t>0\). Squarefreeness forces \((a,b)=1\). The congruences make \(F(a,b)\) prime to six.

The largest degree of an irreducible factor of \(F\) over \(\mathbf Q\) is two. The unconditional binary-form squarefree theorem applies [Greaves; Xiao, Theorem 1.1]. The fixed sector and congruence conditions are handled by the same local sieve: finite-prime counts use lattice points in the sector, and the large-prime tail is bounded by the corresponding encompassing-box estimate.

For \(p\ge5\), put

\[
\ell_p=\begin{cases}3,&(3/p)=1,\\1,&(3/p)=-1.\end{cases}
\]

There are \(\ell_p\) distinct lines in the reduction of \(F=0\) away from the origin. Counting lifts to \(\mathbf Z/p^2\) gives

\[
\#\{(a,b)\bmod p^2:F(a,b)=0\}
=p^2+\ell_pp(p-1).
\]

The normalized sector area is \(1/8\), and the congruence density is \(1/12\). Hence

\[
\#\{(a,b)\text{ as above}\}
=cH^2+o(H^2),
\]

where

\[
\boxed{c=\frac1{96}\prod_{p\ge5}
\left(1-\frac{\ell_p+1}{p^2}+\frac{\ell_p}{p^3}\right)>0.}
\tag{A4}
\]

Every local factor is positive, and the Euler product converges positively. The checker verifies the local counts at several primes; it does not prove the global sieve theorem.

Multiplying (P1) by \(4b\) gives integral coefficients bounded by a constant times \(H\). Distinct reduced parameters in the sector have distinct rank profiles by (A3), so the count is a lower bound for geometric one-stable birational classes under [M1-HC]. It is a count in this displayed coefficient convention, not a claim about a canonical height on cubic moduli or rationalization maps.

## 35. Arithmetic verification should produce negative certificates

For two parameters in the integral family, a separating certificate consists of a prime dividing exactly one parameter and the corresponding two ranks from (A1). For parameters in (A2), list \(S_1,S_3\) and check (A3).

The output proves geometric nonisogeny through the written reduction argument. Its conversion into nonbirationality uses [M1-HC]. It does not prove that identical profiles imply isogeny, and still less that they imply one-stable birationality.

This is a certificate-producing construction on a specific pencil, not a general stable-rationality or isogeny algorithm.

---

<a id="part-viii"></a>
# Part VIII. Fourfolds, families, and rational torus actions

## 36. Fano fourfolds rationalized by one additional variable

For any of the smooth cubic members, let

\[
Y_t=X_t\times\mathbf P^1.
\]

It is a smooth Fano fourfold with geometric Picard rank two. The anticanonical class is the sum of pullbacks of ample anticanonical classes, hence ample. The cubic Picard group has rank one and the projective-line factor adds one.

Theorem A gives

\[
Y_t\times\mathbf P^1\sim_{\mathbf Q}\mathbf P^5
\]

for rational parameters. [M1-LB] gives irrationality of \(Y_t\) over \(\mathbf C\), so its exact level is one. [M1-HC] and Part VII give pairwise geometric nonbirationality for the indicated arithmetic sets.

This is birational stabilization. It is not a statement about isomorphic affine cylinders or the Zariski cancellation problem for affine varieties.

## 37. The family-level statement

The three-parameter family gives a three-dimensional moduli locus with two-variable rationalizations defined over its coefficient field. On a dense coefficient open, these spread to a relative birational trivialization after two variables.

Assuming [M1-HC], each one-stable birational class contains at most countably many cubic isomorphism classes. Thus this locus contains continuum many pairwise nonbirational products \(X_B\times\mathbf P^1\), all rationalized after one further variable.

The interpretation is that algebraic variation in cubic moduli cannot become birationally isotrivial after the first stabilization, while the generic family admits a common rationalization after the second. Avoid saying that a moduli space of stable birational classes has been constructed, or that an individual relative rational map specializes without exception.

The stronger intrinsic description of this locus is not needed here. Retain at most a short pointer to the moduli paper.

## 38. A general field-theoretic linearization lemma

Let \(V/k\) have dimension \(n\) and exact finite stabilization level \(s\). Choose a rationalization

\[
k(V)(u_1,\ldots,u_s)\cong k(z_1,\ldots,z_{n+s}).
\]

Transport the split torus \(\mathbf G_m^s\)-action scaling the \(u_i\) to the rational variety on the right. Its invariant field after \(m\) added variables fixed by the torus is

\[
k(V)(v_1,\ldots,v_m).
\]

A linear action of a split torus has rational invariant field: diagonalize the action and choose a basis of the kernel of the character map on the exponent lattice. Therefore trivial-variable birational linearization forces \(m\ge s\). At \(m=s\), rationalize the invariant field and retain the \(u_i\) as diagonal coordinates. Thus the threshold is exactly \(s\).

More generally, a rank-\(r\) subtorus has invariant field

\[
k(V)(v_1,\ldots,v_{s-r}),
\]

after a unimodular monomial change of coordinates. Its exact trivial-variable linearization threshold is \(r\). This is a direct refinement of the invariant-field mechanism in [Popov], not a new general existence theorem for nonlinearizable tori.

For \(s=2\), every rank-one restriction requires one additional variable, while the full rank-two action requires two. Over \(\mathbf C\), quotienting by any finite subgroup leaves a finite-index rank-two invariant monomial lattice, so the quotient field is \(k(V)(v_1,v_2)\), rational by the chosen two-variable rationalization.

## 39. Pairwise nonconjugate one-dimensional tori over \(\mathbf Q\)

For the arithmetic pencil choose

\[
\mathbf Q(X_t)(u,v)\cong\mathbf Q(z_1,\ldots,z_5).
\]

Let \(\mathbf G_m\) scale \(u\), fixing \(\mathbf Q(X_t)(v)\). The invariant field is the function field of \(Y_t=X_t\times\mathbf P^1\).

If two such torus subgroups were conjugate in \(\operatorname{Cr}_5(\mathbf C)\), their invariant fields would be isomorphic over \(\mathbf C\), contradicting Part VII under [M1-HC]. Thus the positive-density parameter set gives infinitely many geometrically nonconjugate subgroups defined over \(\mathbf Q\).

After adjoining one invariant variable \(w\), the field \(\mathbf Q(X_t)(v,w)\) is rational. Using it as the invariant coordinate field makes every action conjugate over \(\mathbf Q\) to the same diagonal subgroup of \(\operatorname{Cr}_6\). [M1-LB] proves that this extra variable is necessary.

These actions are explicitly specified at the function-field level. Expanded conjugating formulas are not among the computations supplied. Do not attribute a coefficient-height bound to the action formulas on the basis of the height count for the cubic equations.

---

<a id="part-ix"></a>
# Part IX. Retained extensions and limits

## 40. Projective bundles and partner constructions

A projective bundle \(\mathbf P_X(V)\) of rank \(r\) is birational to \(X\times\mathbf P^{r-1}\), by trivializing \(V\) over a dense open. Thus

\[
\ell_k(\mathbf P_X(V))=\max\{\ell_k(X)-(r-1),0\}.
\]

For a level-two cubic, rank-two bundles have exact level one, and rank-three bundles are rational. These are projective bundles of vector bundles, not arbitrary Severi–Brauer fibrations.

Retain the existing partner application only with its precise correspondence hypothesis: if \(W\times\mathbf P^1\) is birational to \(X\times\mathbf P^1\) for one of the level-two cubics, then \(W\) has exact level two. The genus-eight Fano/Pfaffian cubic application must require the relevant correspondence over the ground field; it is not a statement about all genus-eight Fanos.

## 41. Finite-index version of the quotient construction

Keep the hypotheses of Part III in characteristic zero but replace unimodularity by

\[
M'=\sum_{j=1}^r\mathbf Z(w_j-w_0)\subset M=X^*(T_{k^{\mathrm s}}),
\qquad [M:M']=d<\infty.
\]

Then the component \(C\) determined by \(\Lambda\cap U_p\) is geometrically integral and \(k\)-rational. It dominates \(Z/T\) with degree

\[
\boxed{e\mid d.}
\]

### Proof details to retain

Because \(\Lambda\) contains the projection centre,

\[
\Lambda\cap U_p\cong L\cap V_p,
\]

where \(L\cong\mathbf P^{n-r}\). This chooses a descended geometrically integral component, rather than an arbitrary component of \(\Lambda\cap Z\).

The inclusion \(M'\subset M\) defines an isogeny of tori with finite étale kernel \(H\), of order \(d\). At the chosen witness, the derivative of the orbit-incidence equations has rank \(r\): the cofactor condition and the étale character map give transversality. Thus \(T\times C\to Z\) is dominant.

On a generic orbit, the incidence equations have \(d\) points forming an \(H\)-torsor. After extending the constant field to \(\bar k\), the finite group \(H\) is constant. Its translations permute the generic incidence components transitively and give equal degrees; their degrees divide \(d\). Since \(C\) is geometrically integral, its degree remains \(e\) after that constant extension. Hence \(e\mid d\).

Geometric integrality matters in the degree argument. An arbitrary irreducible factor of an equation for a nonsplit finite group scheme does not automatically have degree dividing the order of the group.

The index can exceed the parametrization degree; the baseline's index-two, degree-one scroll example should remain as a short negative control. Do not replace “divides” by “equals.”

## 42. Zero-cycles and the diagonal

Suppose a smooth proper model \(Q\) of a quotient admits rational parametrizations of degrees \(e_i\mid d_i\) from the preceding finite-index constructions. Then

\[
D=\gcd(d_1,\ldots,d_s)
\]

annihilates \(A_0(Q_F)\) for every extension \(F/k\).

Resolve a parametrization from a rational variety. Move degree-zero cycles into an open over which the map is finite flat. Pullback to the rational source, whose degree-zero Chow group vanishes, and pushforward: multiplication by \(e_i\), hence by \(d_i\), kills the original class. A Bézout combination gives the assertion for \(D\).

The rational source also supplies a \(k\)-point of \(Q\). Apply the universal annihilation over \(k(Q)\) to the generic point minus that point, and spread the equality by Chow localization. This gives

\[
D[\Delta_Q]=D[Q\times q]+Z,
\qquad
\operatorname{supp}Z\subset D'\times Q,
\quad D'\subsetneq Q.
\]

Thus the diagonal torsion order divides \(D\). If \(D=1\), the model is universally \(CH_0\)-trivial. Neither conclusion proves rationality, and the packet does not supply a new nonrational coprime-index example. This is a reusable criterion for future constructions; cite the diagonal-torsion conventions used [CL].

## 43. Optimizing a residual stabilization bound

A useful optional abstraction is the following. Suppose

\[
Q\sim_k Y\times R,
\qquad\dim R=d,
\qquad\ell_k(R)=a<\infty,
\qquad\ell_k(Q)=b<\infty.
\]

For \(m=\max\{a,b\}\), both \(Q\times\mathbf A^m\) and \(R\times\mathbf A^m\) are rational. Therefore

\[
\ell_k(Y)\le d+\max\{a,b\}.
\]

This lets a search over subtori optimize a certified bound without requiring every intermediate quotient and residual torus to be rational outright. It is an elementary consequence of the product identification, not a new classification theorem for tori.

## 44. The precise rank-four limitation

For the full \(I_3\) action in this Cox embedding, the unique rank-four subtorus corresponds to the primitive character

\[
m=(-1,-1,-3,-3,3),\qquad Am=-m,\quad Bm=m.
\]

The four stacked sign systems have ranks \((5,4,5,5)\). Modulo \(\mathbf Zm\), the sixteen Cox weights are distinct and have Galois orbit sizes four and twelve. No set of five weight spaces descends. Although 1,992 of the 4,368 five-subsets are unimodular, none is Galois-stable.

This rules out applying the stated weight-simplex criterion at rank four; rank five also fails its descent cardinality. It does not rule out a nonlinear section, another embedding, a different quotient construction, or smaller Galois images. It must not be used as a proof that every surface needs two stabilizations.

The actual optimality statement comes from Corollary B.1 and [M1-LB], not from this restricted failure of a construction.

## 45. Positive characteristic and forms

For a fixed rational member, the rationalization and its inverse spread over \(\mathbf Z[1/N]\). Outside finitely many primes, their reductions give the corresponding two-variable rationalization wherever the stated opens remain nonempty. This is a statement about spreading fixed rational maps.

It does not transport the characteristic-zero one-stabilization obstruction, establish exact level two in positive characteristic, or prove a uniform theorem for every quartic del Pezzo surface in positive characteristic.

Similarly, geometric membership in the cubic moduli locus does not ensure that every form over an arbitrary field satisfies the Picard-lattice hypothesis used by the construction. The coarse moduli and Brauer-gerbe issue belongs to the moduli paper. This paper's arbitrary-field theorem is for the displayed equations and for surfaces satisfying its explicit hypotheses.

---

<a id="part-x"></a>
# Part X. Targeted edits and integration sequence

## 46. Changes against `f46624d`

### A. Promote the surface theorem

Move `thm:two-variable` ahead of `thm:cubic-level` in the introduction. Explain the quotient in two lines:

\[
Z/T_3\sim_k\mathbf P^4,
\qquad
Z/T_3\sim_k S\times(T_0/T_3).
\]

The dimension calculation \(7-3=2+2\) belongs immediately here. Put the historical torsor context after the independent theorem, not after a long list of cubic consequences.

### B. Split the companion imports

Replace the single broad use of `RuddM1` with two named interfaces `[M1-LB]` and `[M1-HC]`. The lower bound proves exactness; Hodge conservation proves pairwise separation. The latter is not present in the old baseline merely because the new numerical invariant is.

Pin the companion citation to the revision containing the theorem actually used. Do not cite a new theorem under an older DOI/version that lacks it. In a working draft, keep a visible conditional marker until that theorem is in the companion's numbered statements.

### C. Repair the quotient proof's birationality sentence

In `thm:torus-quotient`, replace

> “is dominant and generically injective, hence birational”

by

> “Since the tangent projection is an isomorphism on \(U_p\), its restriction identifies \(\Lambda\cap U_p\) with a nonempty open in the linear \(\mathbf P^{n-r}\). The corresponding component is therefore birational to \(\mathbf P^{n-r}\).”

The stronger hypothesis is already present. This removes the purely inseparable counterexample to the old general implication and makes the inverse construction part of the proof rather than an afterthought.

### D. Separate descent from the determinant-one calculation

After identifying \(T_3\), replace the transition beginning “The determinant ... Consequently ... defined over the ground field” with:

> “The selected sum and its complementary subspace descend by Galois stability. The determinant-one calculation independently gives the integral-basis condition and uniqueness of orbit normalization.”

### E. Retain the improved arithmetic geometry of the tangent argument

Keep the three distinct steps: geometric nonemptiness, intersection with the relative isomorphism locus, and rational-point density. Do not shorten them to “choose a generic rational witness.” The certificate's role is only the first step.

Retain the residual character matrices and the explicit three-ratio correction. These make the construction substantially more accessible and should not be moved entirely into code.

### F. Upgrade the cubic applications to the full three-parameter family

Add (F3)–(F9) as a single proposition and proof. State Galois containment, not equality. Keep the absence of the \(xy^2\) term explicit when using (F6). Add the exact-level corollary for the generic surface over \(k(a)\): this shows that the uniform surface bound is genuinely attained.

Keep the original two named TZ cubics and higher-dimensional series as recognizable applications, but no longer make the abstract sound as though the construction only applies to two equations.

### G. Add the minimal Prym calculation before arithmetic separation

Add Part VI's unpolarized factor argument. It is short enough to avoid importing the full moduli paper. Explicitly state that the five elliptic factors are sufficient for local potential reduction and that no product principal polarization is claimed.

Correct the arithmetic component curves to \(C_t^{(-3)}\) and \(H_t^{(-6)}\). All finite-field comparison tables must indicate whether they use geometric models or actual ground-field twists.

### H. Lead with the positive-density parameter set

Use the squarefree positive integers prime to six as the main separated family. It has a shorter proof and a more transparent parameter set than the recursive prime sequence. Retain the recursive construction in an appendix as a minimal-input alternative that uses only the single elliptic factor and good reduction of predecessor cubics.

The coefficient-height theorem is a second arithmetic result, not a prerequisite for the infinite-family theorem. State the height convention and the squarefree sieve's exact role.

### I. Update the fourfold and action corollaries

Replace two isolated fourfolds by the separated arithmetic family. Distinguish three assertions in their proof: rationality after the extra variable, nonrationality before it, and pairwise nonbirationality. They use different inputs.

For torus actions, distinguish existence of a rational conjugation from an expanded coordinate formula. Retain Popov attribution and the qualification that the actions are rational, not necessarily regular.

### J. Keep the scope of the optional sections narrow

Retain `prop:fibration-level`, `thm:finite-index-slice`, the zero-cycle criterion, and the full-\(I_3\) rank-four limitation. They show reusability of the construction. Move lengthy finite-index examples to an appendix if the arithmetic section makes the main paper too long.

Do not add a Navier–Stokes application, a general commercial-computation claim, an all-cubics cancellation statement, or a theorem about arbitrary arithmetic forms of the moduli locus.

### K. Update the coverage and references honestly

The baseline records no full Lean formalization of the new geometric results. Preserve that boundary. A passing SymPy check is not a proof of descent or a kernel-checked theorem.

Update the coverage guide so every new theorem lists its exact dependency set. The journal-facing author disclosure should state only review actions actually completed by the author; do not automatically copy a declaration that all new arguments and references have already been checked.

The Zhang in [TZ] is **Zhijia Zhang**. The Zhang in [CMZ] is **Zheng Zhang**. Keep these authors distinct in the bibliography and prose.

## 47. Suggested new labels

| Label | Statement |
|---|---|
| `thm:two-variable` | Preserve the independent surface theorem label. |
| `thm:uniform-cubic-family` | The three-parameter upper bound, then an exact-level clause with [M1-LB]. |
| `cor:surface-bound-sharp` | Exact level two for the generic surfaces over \(k(a)\). |
| `prop:pencil-smoothness` | The complete smooth locus of (P1). |
| `prop:pencil-jacobian-factors` | The minimal \(S_3\)/Prym proof of (P6). |
| `prop:five-elliptic-factors` | Explicit quotient maps and \(j\)-invariants. |
| `thm:potential-toric-ranks` | Formula (A1), independent of HC. |
| `thm:separated-sharp-family` | Squarefree integral parameters, with HC cited for birational separation. |
| `thm:coefficient-height-count` | The optional quadratic count. |
| `cor:separated-fourfolds` | Pairwise nonbirational level-one Fano fourfolds. |
| `cor:separated-one-tori` | The \(\operatorname{Cr}_5\) classes merging in \(\operatorname{Cr}_6\). |
| `prop:s-unit-candidates` | Optional effective arithmetic candidate set. |

Avoid introducing multiple labels for the same lower-bound import in different sections. In particular, every statement of “exact level” should point back to one clearly formulated citation.

## 48. Integration order

**First pass:** repair the two baseline proof transitions, preserve the certificate/decent split, and promote the surface theorem.

**Second pass:** add the generic-fibre family proposition, the moduli-rank calculation, relative upper bounds, and the exact-surface-level corollary. This yields a self-contained upper-bound upgrade and, with [M1-LB], its sharpness statements.

**Third pass:** add the unpolarized Prym factor argument and local-rank formula. At this stage the arithmetic nonisogeny theorems are independent geometric/arithmetic results.

**Fourth pass:** import [M1-HC] at its final theorem label and add pairwise one-stable separation, fourfolds, and the strengthened action consequences.

**Fifth pass:** decide whether the height count and S-unit material improve the paper enough to justify the added length. Neither is needed for the main construction or for an explicit infinite set of separated examples.

## 49. Theorem ownership across the series

| Material | Primary home | Sharpness's use |
|---|---|---|
| Surface-vanishing quantum filters, Fano classification, Hodge conservation | One-stabilization paper | Precisely stated imports only. |
| Rank-three Cox quotient and two-variable surface theorem | Sharpness | Main independent theorem. |
| Three-parameter cubic upper bound | Sharpness | Main construction; moduli paper can cite it. |
| Short \(S_3\)/Prym factorization needed for arithmetic | Sharpness or a clearly shared preliminary | Include its proof here to avoid depending on full polarized reconstruction. |
| Potential toric ranks, separated arithmetic sets, exact rationalization applications | Sharpness | Main applications. |
| Intrinsic degree-40/10/4 maps, two-curve Torelli, period gluing, generic gerbe | Moduli paper | At most a brief pointer. |
| Pencil isogeny rigidity via finite correspondences and essential dimension | Moduli paper | Optional cited consequences; not dependencies of the separated family. |
| Generic ambient cancellation and bounded-degree arithmetic finiteness | One-stabilization paper | Short context, not a second full proof. |

Do not count the same combined theorem as an independent principal contribution in all three abstracts. Give the separated explicit family one main home here; the companion papers can state it as an application of the joint inputs.

---

<a id="part-xi"></a>
# Part XI. Attribution and bibliography

## 50. Novelty ledger

| Ingredient | Attribution and framing |
|---|---|
| Rationality of universal torsors over quartic del Pezzo surfaces, OADP Cox geometry, relevant Galois types | TZ. The new construction reduces the residual dimension to two. |
| Tangent projection for OADP varieties | Ciliberto–Mella–Russo in the smooth setting; use TZ's stronger form for the Cox model. |
| Stable-permutation Picard obstruction | Classical Manin theory; recall its precise form through TZ. |
| Rationality of every two-dimensional torus | Voskresenskii. The residual lattice description is an explicit instance. |
| Type-\(I_0\) two-variable bound | Shepherd-Barron, as discussed by TZ. Do not claim all four types were previously untreated. |
| Three-parameter component-splitting family and its rank-three moduli image | The present family extension; compare priority separately. It applies TZ, rather than replacing their theorem. |
| Exact lower bounds and one-stable Hodge conservation | The one-stabilization paper, separately cited. |
| General non-Eckardt involution/Prym decomposition | Casalaina-Martin–Marquand–Zheng Zhang. The identification with this \(S_3\)-cover and the resulting explicit elliptic factors are the specialized calculation used here. |
| Potential good elliptic reduction and isogeny-invariance of potential toric rank | Standard reduction theory. The exact pencil formula and parameter certificates are the application. |
| Squarefree density and effective S-unit bounds | Established analytic/Diophantine theorems. The local form, sector, and partner reduction are specialized here. |
| Rational torus-action invariant-field mechanism | Popov. Exact thresholds and the arithmetically separated classes are the present applications. |
| Degree bounds on zero-cycles and the diagonal | Classical push-pull and localization; cite the stated conventions. No claim of a new general theorem about decomposition of the diagonal. |

The targeted source check for this packet verifies the imported theorem roles. It is not an exhaustive priority search for every newly combined statement.

## 51. References and exact roles

**[Baseline]** Tavis Rudd, *Sharpness of Irrationality after One Stabilization for Cubic Threefolds*, repository revision `f46624d`. Main TeX and reviewer guide:

- <https://github.com/tavisrudd/cubic-stabilization-irrationality/tree/f46624d>
- <https://raw.githubusercontent.com/tavisrudd/cubic-stabilization-irrationality/f46624d/cubic_stabilization_irrationality.tex>
- <https://raw.githubusercontent.com/tavisrudd/cubic-stabilization-irrationality/f46624d/REVIEWER_GUIDE.md>

The manuscript's twenty-quadric source, generated certificate values, independent verifiers, and negative controls remain the authoritative baseline data. The packet adds a separate finite check, not a replacement verification target.

**[M1-LB], [M1-HC]** Tavis Rudd, proposed upgraded *Quantum Hodge invariants and one-stabilization of Fano threefolds*. Use the consolidated file `m1_upgrade_proof_packet.md` as the integration specification and cite the final manuscript theorem numbers once present. The old `b156ec6` baseline contains the numerical obstruction framework, not automatically every later Hodge theorem:

<https://github.com/tavisrudd/cubic-stabilization-m1/tree/b156ec6>

**[TZ]** Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo surfaces and stable rationality*, arXiv:2608.20029v2.

<https://arxiv.org/html/2608.20029v2>

Relevant locations: Lemma 2.1; Remark 2.2; Theorem 2.4; Lemma 3.2; Corollary 3.5; Proposition 4.1; Lemma 4.2; Corollary 4.3; Propositions 5.1 and 5.3; Example 5.2. Respect the distinction between the type classification and the additional quotient argument.

**[CMR]** Ciro Ciliberto, Massimiliano Mella, Francesco Russo, *Varieties with one apparent double point*, Journal of Algebraic Geometry 13 (2004), 475–512. Corollary 4.2 supplies the smooth tangent-projection theorem.

<https://doi.org/10.1090/S1056-3911-03-00355-2>

**[Manin]** Yuri Manin, *Rational surfaces over perfect fields*, Publications Mathématiques de l'IHÉS 30 (1966), 55–113. Stable birational Picard-module obstruction; use the formulation quoted in TZ for the specific implication here.

<https://doi.org/10.1007/BF02684357>

**[V]** Valentin Voskresenskii, *On two-dimensional algebraic tori. II*, Mathematics of the USSR-Izvestiya 1 (1967), 691–696.

<https://doi.org/10.1070/IM1967v001n03ABEH000580>

**[VA]** Anthony Várilly-Alvarado, *Arithmetic of del Pezzo surfaces*, in *Birational Geometry, Rational Curves, and Arithmetic* (2013), 293–319. Theorem 2.1 gives the degree-at-least-five rationality input.

<https://doi.org/10.1007/978-1-4614-6482-2_12>

**[SB]** Nicholas Shepherd-Barron, *Stably rational irrational varieties*, in *The Fano Conference* (2004), 693–700. Retain the prior type-\(I_0\) bound acknowledged by TZ.

**[BCTSSD]** Arnaud Beauville, Jean-Louis Colliot-Thélène, Jean-Jacques Sansuc, Peter Swinnerton-Dyer, *Variétés stablement rationnelles non rationnelles*, Annals of Mathematics 121 (1985), 283–318. Historical torsor method.

<https://doi.org/10.2307/1971174>

**[CMZ]** Sebastian Casalaina-Martin, Lisa Marquand, Zheng Zhang, *The moduli space of cubic threefolds with a non-Eckardt type involution via intermediate Jacobians*, arXiv:2210.14397v2. Theorem 2.9 gives the exact involution/Prym decomposition used in Part VI. It does not by itself identify the component cover with our elliptic triple cover's Galois closure.

<https://arxiv.org/html/2210.14397>

**[Achter]** Jeffrey Achter, *Arithmetic Torelli maps for cubic surfaces and threefolds*, arXiv:1005.2131v4. Theorem 3.4 supplies the intermediate-Jacobian abelian-scheme input for the optional good-reduction sequence.

<https://arxiv.org/html/1005.2131v4>

**[Reduction]** The Néron–Ogg–Shafarevich criterion, semistable reduction for abelian varieties, and the criterion that an elliptic curve is potentially good exactly when its \(j\)-invariant is integral. Cite a standard text, for example Silverman's *The Arithmetic of Elliptic Curves*, Chapter VII, together with a standard semistable abelian-variety reference for potential toric rank. The argument uses geometric isogenies after finite extension; it does not require equality of conductors over the original field.

**[Greaves]** George Greaves, *Power-free values of binary forms*, Quarterly Journal of Mathematics 43 (1992), 45–65.

**[Xiao]** Stanley Xiao, *Power-free values of binary forms and the global determinant method*, arXiv:1505.05587v2, Theorem 1.1. The maximum irreducible-factor degree here is two; the squarefree theorem is unconditional in this range.

<https://arxiv.org/html/1505.05587v2>

**[Popov]** Vladimir Popov, *Some subgroups of the Cremona groups*, arXiv:1110.2410v4. The invariant-field linearization criterion and prior nonlinearizable torus examples are already there.

<https://arxiv.org/html/1110.2410v4>

**[CTC]** Jean-Louis Colliot-Thélène and Daniel Coray, *L'équivalence rationnelle sur les points fermés des surfaces rationnelles fibrées en coniques*, Compositio Mathematica 39 (1979), 301–332. Lemma 6.2 and Propositions 6.3–6.4 for the degree argument.

<https://www.numdam.org/item/CM_1979__39_3_301_0/>

**[CL]** André Chatzistamatiou and Marc Levine, *Torsion orders of complete intersections*, arXiv:1605.01913v3. Match the orientation of the diagonal decomposition and the torsion-order convention.

<https://arxiv.org/abs/1605.01913>

**[BS]** Frits Beukers and Hans Peter Schlickewei, *The equation \(x+y=1\) in finitely generated groups*, Acta Arithmetica 78 (1996), 189–199. The bound used is \(2^{8(r+1)}\) for a subgroup of rank \(r\). A modern explicit statement of the characteristic-zero theorem appears in the introduction to Koymans–Pagano, arXiv:1610.08377v4; do not confuse it with their positive-characteristic result.

<https://arxiv.org/html/1610.08377v4>

**[EGS]** Jan-Hendrik Evertse, Kálmán Győry, Cameron Stewart, *Mahler's work on Diophantine equations and subsequent developments*, arXiv:1806.00355v1, Section 5. Effective \(S\)-unit methods and original references.

<https://arxiv.org/html/1806.00355v1>

**[EGFS, optional]** Philip Engel, Olivier de Gaay Fortman, Stefan Schreieder, *Matroids and the integral Hodge conjecture for abelian varieties*, arXiv:2507.15704v3. Retain the baseline's contrast with very-general stable irrationality only with the precise corollary cited there. It does not prove a finite-level dichotomy for every cubic.

**[Kuznetsov, optional]** Alexander Kuznetsov, *Derived categories of cubic and \(V_{14}\) threefolds*, Proceedings of the Steklov Institute 246 (2004), 171–194; arXiv:math/0303037. Use the actual birational projective-bundle correspondence, not a general inference from derived equivalence.

---

<a id="part-xii"></a>
# Part XII. Verification and release checklist

## 52. What was rerun for this packet

The standalone checker in Appendix C was executed with SymPy 1.14.0. With default options it reports:

| Check | Exact result |
|---|---|
| Saturated selected simplex | determinant \(\pm1\); the visible unsaturated parameter lattice has index two |
| Cox rank-four systems | ranks \((5,4,5,5)\), primitive character \((-1,-1,-3,-3,3)\) |
| Cox rank-four five-subsets | 4,368 total; 1,992 unimodular; Galois orbits of sizes four and twelve |
| Four Jacobian minors | all agree with the printed \(M_i\) |
| Four evaluation determinants | agree with the printed \(D_i\) up to nonzero rational constants |
| Localized surface-cover cases | six empty, two residual cases excluded by the fourth witness |
| Generic cubic-family determinant and splitting identities | exact equality over rational polynomial/function fields |
| Smooth seed and cubic moduli tangent | sixth-power Jacobian reductions zero; ranks 25 and 28 |
| Pencil discriminants and elliptic transformation | exact symbolic identities |
| Five elliptic quotient maps and \(j\)-invariants | exact symbolic identities |
| Ground-field twists | corrected factor traces match direct cubic counts in the tested reductions |
| Integer family, bound 240 | 74 parameters; every tested pair separated locally |
| Rational reconstruction sector, bound 240 | 466 distinct reconstruction certificates |
| Recursive prime alternative | first twenty exact certificates |
| Local squarefree densities | exact counts modulo \(p^2\) for the tested primes |
| \(S\)-unit change of variables | exact sum, conjugation, norm, and inverse identities |

The second, auxiliary genus-two moduli-rank calculation is retained as a regression check from the earlier family note. It is not used to prove an intrinsic moduli identification in this packet.

## 53. What the checker does not verify

It does not replay the full repository gate, certify all twenty Cox equations independently, run Lean, prove the rationality theorem for the possibly singular Cox model, prove the type classification, supply ground-field tangent witnesses, prove generic torsor splitting, or prove [M1-LB]/[M1-HC].

It does not prove the Prym correspondence from point-count agreement, implement a complete \(S\)-unit solver, supply expanded two-variable rationalizations, establish the squarefree asymptotic by enumeration, or decide birationality for a pair with matching local profiles.

The extracted checker must be run without Python optimization, because its assertions are part of the verification. It rejects `-O`. It can skip the independent tangent reconstruction only with an explicit flag; that omission is recorded in the JSON and should not be described as a full default run.

## 54. Release checklist

Before making the full target abstract public:

- The surface theorem's descent and isomorphism-open proof are complete, with the uniform certificate linked to the exact Cox model.
- The repository's all-twenty-quadrics certificate and independent verifier have been rerun after edits; their negative controls still fail as intended.
- The family statement uses subgroup containment and either retains the three-parameter restriction or supplies the missing full-binary-cubic factor chart.
- The minimal \(S_3\)/Prym factor proof is present, with the arithmetic twists distinguished from geometric models.
- [M1-LB] and [M1-HC] point to the versions and theorem numbers that actually contain them. Pending HC is not silently treated as a consequence of the numerical obstruction.
- The local invariant is explicitly potential toric rank, with the \(p\ge5\) restriction.
- The height theorem names its displayed coefficient convention and its imported squarefree-value theorem.
- Every exactness claim has a lower-bound dependency; every pairwise-separation claim has an HC dependency; the two-quadrics example remains only an upper bound of two.
- The formal-coverage guide reflects the new statements without promoting symbolic checks to formal proofs.
- The paper has one coherent principal theorem and applications sequence, rather than reproducing the moduli paper's full research programme.

The intended completed result is a geometric rationalization theorem with sharp, arithmetically separated applications. Its strength does not require treating every possible extension as a new main theorem.

---

<a id="appendix-a"></a>
# Appendix A. Exact Cox certificate data

This appendix fixes the conventions needed to reproduce the finite part of Part IV. The original twenty-quadric Cox presentation and its full verifier remain in the baseline repository. The formulas here reconstruct the independent eight-row tangent test and the uniform cover.

## A.1 Coordinates and witnesses

Order the sixteen Cox coordinates as

\[
E_1,E_2,E_3,E_4,E_5,
L_{12},L_{13},L_{14},L_{15},L_{23},L_{24},L_{25},L_{34},L_{35},L_{45},Q.
\]

For a plane point \(z=(z_1,z_2,z_3)\), use

\[
\begin{aligned}
\ell_{12}&=z_3,& \ell_{13}&=z_2,& \ell_{14}&=z_2-z_3,&
\ell_{15}&=bz_2-az_3,\\
\ell_{23}&=z_1,&\ell_{24}&=z_1-z_3,&\ell_{25}&=bz_1-z_3,&
\ell_{34}&=z_1-z_2,\\
\ell_{35}&=az_1-z_2,&
\ell_{45}&=(b-a)z_1+(1-b)z_2+(a-1)z_3,\\
q(z)&=b(1-a)z_1z_2+a(b-1)z_1z_3+(a-b)z_2z_3.
\end{aligned}
\]

The first point is \(p(z)\), with \(E_i=1\), \(L_{ij}=\ell_{ij}(z)\), \(Q=q(z)\). For the second point, take

\[
E_i=e_i,\qquad L_{ij}=\frac{\ell_{ij}(z')}{e_ie_j},
\qquad Q=\frac{q(z')}{e_1e_2e_3e_4e_5}.
\]

| Witness | \(z\) | \((e_1,e_2,e_3,e_4,e_5)\) | \(z'\) |
|---|---|---|---|
| 1 | \((1,3,7)\) | \((2,3,5,7,11)\) | \((2,4,9)\) |
| 2 | \((2,5,11)\) | \((3,4,7,13,17)\) | \((1,6,10)\) |
| 3 | \((3,8,13)\) | \((5,7,11,17,19)\) | \((2,9,15)\) |
| 4 | \((4,9,17)\) | \((2,5,11,19,23)\) | \((3,10,18)\) |

The eight chosen quadrics are

\[
\begin{gathered}
E_2L_{12}-E_3L_{13}+E_4L_{14},\qquad
aE_2L_{12}-bE_3L_{13}+E_5L_{15},\\
E_1L_{12}-E_3L_{23}+E_4L_{24},\qquad
E_1L_{12}-bE_3L_{23}+E_5L_{25},\\
E_1L_{13}-E_2L_{23}+E_4L_{34},\qquad
E_1L_{13}-aE_2L_{23}+E_5L_{35},\\
(b-1)E_1L_{14}+(a-b)E_2L_{24}+E_5L_{45},\\
aL_{23}L_{45}+(a-b)L_{24}L_{35}-E_1Q.
\end{gathered}
\]

For \(M_i\), take their Jacobian in the ordered columns

\[
E_1,E_2,E_5,L_{12},L_{13},L_{14},L_{15},L_{23}.
\]

To compute \(D_i\), take the kernel of the conormal rows restricted to \(E_3,E_4,L_{34},Q\), then evaluate on the four selected weight groups in Part IV. Bases of this kernel can change the determinant by a nonzero scalar; the open condition is unchanged.

## A.2 Four determinants and four minors

Up to nonzero rational factors for the evaluation determinants,

\[
D_1=(8a-27)^2(3968a-1349b-2619),
\]

\[
\begin{aligned}
D_2={}&568453977a^3-373279764a^2b-1658788404a^2\\
&+59068867ab^2+976763788ab+925668016a\\
&-128537024b^2-359163728b-10185728,
\end{aligned}
\]

\[
\begin{aligned}
D_3={}&1643918400a^3-1105797420a^2b-7261914240a^2\\
&+154718524ab^2+3804690316ab+9944961600a\\
&-282623593b^2-3443769343b-3454184244,
\end{aligned}
\]

\[
\begin{aligned}
D_4={}&35068545a^3+2864538a^2b-236376549a^2\\
&-5350827ab^2+24417420ab+469658574a\\
&+14536855b^2-90750394b-214068162.
\end{aligned}
\]

The Jacobian minors are

\[
\begin{aligned}
M_1&=-4(a-1)(b-7)(3a-b-2)(2ab+7a-9b),\\
M_2&=-9(a-1)(2b-11)(3a-b-2)(4ab+11a-15b),\\
M_3&=-25(a-1)(3b-13)(2a-b-1)(3ab+13a-16b),\\
M_4&=-(a-1)(4b-17)(13a-5b-8)(32ab+85a-117b).
\end{aligned}
\]

For the independent nullspace bases used by the embedded checker, the four ratios of the reconstructed evaluation determinants to \(D_i\) are

\[
-\frac{17}{15093540},\quad
-\frac1{2575198080},\quad
-\frac3{109985779750},\quad
-\frac7{63572575}.
\]

The Jacobian minors agree exactly.

## A.3 Uniform cover of the smooth parameter locus

Let \(\Delta=ab(a-1)(b-1)(a-b)\). The assertion is

\[
\{\Delta\ne0\}\subseteq\bigcup_{i=1}^4\{D_iM_i\ne0\}.
\]

The converse containment is not asserted. If the first three products vanish, choose one vanishing factor from each and work in the localized ring represented by

\[
\mathbf Q[a,b,h]/(h\Delta-1).
\]

The first six cases below have unit ideal:

| Vanishing factors | Result after localization |
|---|---|
| \(D_1,D_2,D_3\) | empty |
| \(D_1,D_2,M_3\) | empty |
| \(D_1,M_2,D_3\) | empty |
| \(D_1,M_2,M_3\) | empty |
| \(M_1,D_2,D_3\) | empty |
| \(M_1,D_2,M_3\) | empty |
| \(M_1,M_2,D_3\) | \(3a-b-2=0\), \(q_0(b)=0\) |
| \(M_1,M_2,M_3\) | \(3a-b-2=0\), \((3b-26)(3b-13)=0\) |

Here

\[
q_0(b)=31223016b^2-435944529b+1306078948,
\]

and put

\[
q_4(b)=83246b^2-872181b+2185995.
\]

On \(a=(b+2)/3\),

\[
D_4M_4=-\frac8{27}(b-1)^4(4b-17)(16b-85)q_4(b).
\]

The values

\[
q_0(17/4)=69121705/4,\qquad
q_0(85/16)=-4117757269/32,
\]

\[
q_4(26/3)=7918133/9,\qquad
q_4(13/3)=-272530/9
\]

exclude the relevant linear factors. Finally,

\[
\begin{aligned}
&(2265746679974131615-377042650728395274b)q_0(b)\\
&\quad +(141417109727495582904b-1342668830289072756147)q_4(b)\\
&=24176690547344887359179755.
\end{aligned}
\]

Thus the two remaining cases are excluded by \(D_4M_4\ne0\). The baseline repository retains explicit Nullstellensatz identities for the six unit-ideal cases; preserve them. The independent embedded checker recomputes those Gröbner bases and checks the displayed residual and Bézout calculations.

---

<a id="appendix-b"></a>
# Appendix B. Optional arithmetic extensions

## B.1 A recursive sequence using only one elliptic factor

The strongest positive-density result uses all five elliptic factors. A useful lower-dependency alternative uses only \(E_t\) from (P3).

Set \(t_1=1\). Given \(t_1,\ldots,t_n\), let \(t_{n+1}\) be the least prime \(p\ge5\) such that

\[
p\nmid6\prod_{i=1}^nt_i(16t_i^2-27).
\]

At this prime every preceding cubic has smooth reduction and hence its intermediate Jacobian has good reduction [Achter, Theorem 3.4]. But

\[
j(E_p)=-\frac{19683}{p^2(16p^2-27)}
\]

has valuation \(-2\). The new intermediate Jacobian has an elliptic isogeny factor that is not potentially good. It cannot be geometrically isogenous to any predecessor.

The first twenty parameters are

\[
1,5,7,13,17,19,23,29,31,37,41,43,47,53,61,67,71,73,79,83.
\]

The existence of each new prime is elementary. A certificate records that prime, all nonzero predecessor residues, and the new \(j\)-valuation. Under [M1-HC] this gives an explicit infinite one-stably separated family; the upper rationalizations and exactness have the same dependencies as before.

This is a useful fallback if the five-factor local-rank section is not yet integrated. It needs the elliptic-factor part of the Prym argument, not the genus-two quotient computations or the binary-form sieve.

## B.2 Effective rational candidate sets through one \(S\)-unit equation

Fix \(t_0\in\mathbf Q^*\). Let \(S\) contain two, three, and every prime with positive potential toric rank for \(J(X_{t_0})\). Put

\[
L=\mathbf Q(\sqrt3),
\]

and let \(S_L\) be the finite places over \(S\).

For a rational parameter \(u\) potentially good outside \(S\), set

\[
w=\frac{3\sqrt3}{4u},\qquad
x=\frac{1+w}{2},\qquad y=\frac{1-w}{2}.
\]

Then

\[
x+y=1,\qquad
x,y\in\mathcal O_{L,S_L}^{*},\qquad
\sigma(x)=y,
\tag{B1}
\]

where \(\sigma\) is the nontrivial automorphism of \(L/\mathbf Q\).

To check the unit condition, work outside \(S\). Formula (A1) implies \(v(u)\le0\), so \(w\) is integral. If \(v(w)>0\), both \(1+w\) and \(1-w\) are units. If \(v(w)=0\), then

\[
1-w^2=\frac{16u^2-27}{16u^2}
\]

is a unit, so both factors are units again.

Conversely, a solution of (B1) with \(x\ne y\) gives

\[
\boxed{u=\frac{3\sqrt3}{4(x-y)}\in\mathbf Q^*,}
\]

and reverses the argument. Thus (B1) parametrizes exactly the rational pencil parameters potentially good outside \(S\).

Any geometric isogeny partner, hence under [M1-HC] any rational one-stable partner of \(X_{t_0}\) in this pencil, belongs to this finite set. Classical effective \(S\)-unit methods enumerate it [EGS]. After enumeration, filter by the full profile (A1), then by necessary geometric isogeny tests between elliptic factors.

The group \(\{(v,\sigma v):v\in\mathcal O_{L,S_L}^{*}\}\) has rank \(1+|S_L|\). The Beukers–Schlickewei theorem gives the deliberately coarse bound

\[
\#\{\text{candidate parameters}\}\le2^{8(|S_L|+2)}.
\]

No height bound on \(u\) is required. The checker verifies the substitutions, not an implementation of a complete unit-equation solver. Surviving every necessary isogeny filter does not prove one-stable birationality.

## B.3 Optional cross-paper cancellation corollary

The proposed moduli-paper rigidity theorem states that, for a very general parameter \(t\) in this pencil, a geometric isogeny \(J(X_t)\sim J(X_u)\) with another smooth pencil member forces \(u=\pm t\). The two signs give isomorphic cubics.

Once that theorem is independently established there, [M1-HC] gives cancellation within this pencil. Its proof uses finite isogeny orbits, degeneration ranks, and monodromy of the primitive central factors; it is not included as a dependency of any main theorem in this packet.

Do not substitute ambient very-general cubic Torelli: this pencil lies in a special decomposable period locus. Do not state all-members cancellation or identify the finite exceptional partner sets without a separate proof.

---

<a id="appendix-c"></a>
# Appendix C. Standalone exact checker

The code below is self-contained apart from SymPy. It combines the independent baseline lattice/tangent checks with the family, pencil, and arithmetic calculations. It imports no neighbouring project file and accesses no network resource.

Install the environment and run:

```sh
python -m venv .venv
. .venv/bin/activate
python -m pip install sympy==1.14.0
python sharpness_upgrade_checks.py --output sharpness_upgrade_checks.json
```

Save the following Python block as `sharpness_upgrade_checks.py`. The default run includes the independent tangent reconstruction, checks rational parameters through bound 240, and emits twenty recursive-prime certificates. `--skip-tangent` explicitly records an incomplete baseline reconstruction; it is not the default. Run without `-O`.

<!-- BEGIN SHARPNESS CHECKER -->
```python
from __future__ import annotations

import argparse
import itertools
import json
import sys
from fractions import Fraction
from itertools import combinations_with_replacement
from math import gcd, isqrt, prod
from pathlib import Path

import sympy as sp


def check(condition: bool, message: str) -> None:
    if not condition:
        raise ArithmeticError(message)

def coefficient_vector(poly: sp.Expr, variables: tuple, monomials: list) -> sp.Matrix:
    polynomial = sp.Poly(poly, *variables)
    return sp.Matrix([polynomial.coeff_monomial(m) for m in monomials])

def signed_permutation_group(generators: tuple[tuple[int, ...], ...]) -> set:
    identity = tuple(range(1, len(generators[0]) + 1))
    group, pending = {identity}, [identity]
    while pending:
        element = pending.pop()
        for generator in generators:
            product = tuple(
                (1 if i > 0 else -1) * generator[abs(i) - 1] for i in element
            )
            if product not in group:
                group.add(product)
                pending.append(product)
    return group

def family_checks() -> dict:
    u, v, x, z, y = sp.symbols("u v x z y")
    variables = (u, v, x, z, y)
    cubic_monomials = [
        sp.prod(variables[i] for i in indices)
        for indices in combinations_with_replacement(range(5), 3)
    ]
    seed = (
        (z - x) * u**2 + 6*y*u*v + 3*(z + x)*v**2 - z**3
        + sp.Rational(3, 4)*(x**2 + 3*y**2)*z + y**3
    )
    derivatives = [sp.diff(seed, variable) for variable in variables]
    jacobian_basis = sp.groebner(derivatives, *variables)
    pure_power_remainders = [jacobian_basis.reduce(variable**6)[1] for variable in variables]
    check(all(remainder == 0 for remainder in pure_power_remainders), "Seed smoothness check failed")
    deformations = (x**3, x**2*y, y**3)
    orbit = sp.Matrix.hstack(*(
        coefficient_vector(variable*derivative, variables, cubic_monomials)
        for variable in variables for derivative in derivatives
    ))
    family_directions = sp.Matrix.hstack(*(
        coefficient_vector(monomial, variables, cubic_monomials)
        for monomial in deformations
    ))
    cubic_ranks = (orbit.rank(), orbit.row_join(family_directions).rank())
    check(cubic_ranks == (25, 28), "Cubic moduli rank check failed")

    a, t, s, beta, w, h = sp.symbols("a t s beta w h")
    A = a**2 + 3
    c = t**3 - sp.Rational(3, 4)*A*t - beta
    discriminant = sp.factor(sp.discriminant(c, t))
    expected_discriminant = sp.Rational(27, 16)*A**3 - 27*beta**2
    check(sp.expand(discriminant - expected_discriminant) == 0, "Cubic discriminant failed")
    e_plus_sq = (s-a)*c.subs(t, s)
    e_minus_sq = (-s-a)*c.subs(t, -s)
    norm_remainder = sp.rem(sp.expand(e_plus_sq*e_minus_sq-discriminant/9), s**2-A, s)
    check(norm_remainder == 0, "Component splitting norm identity failed")

    Q1 = -a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2 - z*h
    Q2 = u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2 - z**2 + w*h
    pencil_matrix = sp.hessian(Q1+t*Q2, (u, v, w, z, h))/2
    pencil_determinant = sp.factor(pencil_matrix.det())
    check(sp.expand(pencil_determinant-sp.Rational(3, 4)*(t**2-A)*c) == 0,
          "Quadrics pencil determinant failed")
    generic_cubic = (
        w*(-a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2)
        + z*(u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2-z**2)
    )
    check(sp.expand(w*Q1+z*Q2-generic_cubic) == 0, "Birational projection identity failed")
    point = {u: 0, v: 0, w: 0, z: 0, h: 1}
    check(Q1.subs(point) == 0 and Q2.subs(point) == 0, "Rational point failed")

    r1, r2 = sp.symbols("r1 r2")
    r3 = -r1-r2
    root_A = sp.Rational(4, 3)*(r1**2+r1*r2+r2**2)
    check(sp.expand((r2-r3)**2-3*(root_A-r1**2)) == 0, "Root-difference identity failed")
    generators = (
        (1, 2, 3, 5, 4),
        (1, 2, 3, -4, -5),
        (2, 3, 1, 4, 5),
        (-1, -3, -2, 4, -5),
    )
    group = signed_permutation_group(generators)
    check(len(group) == 24, "Signed permutation group order failed")
    check(all(sum(i < 0 for i in g) % 2 == 0 for g in group), "Group not in W(D5)")

    sextic = 16*y**6-(x**2+3*y**2)**3
    sextic_monomials = [x**i*y**(6-i) for i in range(7)]
    binary_variables = (x, y)
    sextic_orbit = sp.Matrix.hstack(*(
        coefficient_vector(q*sp.diff(sextic, r), binary_variables, sextic_monomials)
        for q in binary_variables for r in binary_variables
    ))
    sextic_directions = sp.Matrix.hstack(*(
        coefficient_vector(32*y**3*m, binary_variables, sextic_monomials)
        for m in deformations
    ))
    genus_two_ranks = (sextic_orbit.rank(), sextic_orbit.row_join(sextic_directions).rank())
    check(genus_two_ranks == (4, 7), "Genus-two moduli rank failed")
    affine_sextic = sextic.subs({x: a, y: 1})
    sextic_gcd = sp.gcd(affine_sextic, sp.diff(affine_sextic, a))
    check(sextic_gcd == 1, "Seed genus-two curve is not smooth")

    return {
        "sympy_version": sp.__version__,
        "all_checks_passed": True,
        "scope": "Finite algebraic checks only; the geometric argument and its dependencies are stated in the proof packet, Part V.",
        "seed_cubic": str(seed),
        "seed_smoothness": {
            "sixth_power_remainders": dict(zip(map(str, variables), map(str, pure_power_remainders))),
            "jacobian_groebner_basis": [str(p.as_expr()) for p in jacobian_basis.polys],
        },
        "cubic_moduli": {
            "orbit_rank": cubic_ranks[0],
            "augmented_rank": cubic_ranks[1],
            "independent_directions": list(map(str, deformations)),
            "direction_remainders": [str(jacobian_basis.reduce(m)[1]) for m in deformations],
        },
        "quartic_del_pezzo": {
            "quadrics": [str(Q1), str(Q2)],
            "pencil_determinant": str(pencil_determinant),
            "cubic_discriminant": str(discriminant),
            "component_norm_identity_remainder": str(norm_remainder),
        },
        "type_I3": {"generators": generators, "group_order": len(group)},
        "genus_two": {
            "seed_sextic": str(sp.expand(sextic)),
            "squarefree_gcd": str(sextic_gcd),
            "orbit_rank": genus_two_ranks[0],
            "augmented_rank": genus_two_ranks[1],
        },
    }

def lattice_checks():
    A = sp.Matrix([[-1,0,0,-1,-1],[1,1,1,0,2],[0,0,-1,-1,-1],[0,0,0,0,1],[0,0,0,1,0]])
    B = sp.Matrix([[0,1,1,1,2],[-1,-1,0,0,-1],[0,0,1,0,0],[0,0,0,1,0],[0,0,-1,-1,-1]])
    ranks = [sp.Matrix.vstack(A-e*sp.eye(5), B-f*sp.eye(5)).rank() for e,f in itertools.product((-1,1), repeat=2)]
    m = sp.Matrix([-1,-1,-3,-3,3])
    assert A*m == -m and B*m == m
    weights = {f'E{i+1}': tuple(int(j == i) for j in range(4))+(0,) for i in range(5)}
    for i,j in itertools.combinations(range(5),2):
        weights[f'L{i+1}{j+1}'] = tuple(-int(k in (i,j)) for k in range(4))+(1,)
    weights['Q'] = (-1,-1,-1,-1,2)
    restriction = lambda w: (w[1]-w[0],w[2]-3*w[0],w[3]-3*w[0],w[4]+3*w[0])
    reduced = {name: restriction(w) for name,w in weights.items()}
    assert len(set(reduced.values())) == 16
    unimodular = sum(abs(int(sp.Matrix.hstack(*(sp.Matrix(reduced[n])-sp.Matrix(reduced[sub[0]]) for n in sub[1:])).det())) == 1 for sub in itertools.combinations(reduced,5))
    affine_actions = []
    weight_to_name = {w:name for name,w in weights.items()}
    for g in (A,B):
        candidates=[]
        for shift in weights.values():
            images={name: tuple(g*sp.Matrix(w)+sp.Matrix(shift)) for name,w in weights.items()}
            if set(images.values()) == set(weight_to_name):
                candidates.append({name:weight_to_name[w] for name,w in images.items()})
        assert len(candidates)==1
        affine_actions.append(candidates[0])
    unseen=set(weights)
    orbits=[]
    while unseen:
        orbit={min(unseen)}
        while True:
            new=orbit | {g[name] for g in affine_actions for name in orbit}
            if new==orbit:
                break
            orbit=new
        unseen-=orbit
        orbits.append(sorted(orbit))
    N3=sp.eye(5)[:,2:]
    cocharacter_actions=[g.inv().T[2:,2:] for g in (A,B)]
    for g,h in zip((A,B),cocharacter_actions):
        assert g.inv().T*N3==N3*h
    expected=(sp.Matrix([[-1,0,0],[-1,0,1],[-1,1,0]]),sp.Matrix([[1,0,-1],[0,1,-1],[0,0,-1]]))
    assert tuple(cocharacter_actions)==expected
    residual_vectors={(0,1),(1,-1),(-1,0)}
    for g in (A,B):
        assert {tuple(g[:2,:2]*sp.Matrix(v)) for v in residual_vectors}==residual_vectors
    assert ranks==[5,4,5,5] and unimodular==1992
    assert sorted(map(len,orbits))==[4,12]
    return {'stacked_ranks':ranks,'primitive_character':list(m),'five_subsets':4368,'unimodular_subsets':unimodular,'orbits':orbits,'rank_three_cocharacter_actions_verified':True,'residual_norm_one_lattice_verified':True}

def certificate_polynomials():
    a,b,h=sp.symbols('a b h')
    D=[
      (8*a-27)**2*(3968*a-1349*b-2619),
      568453977*a**3-373279764*a*a*b-1658788404*a*a+59068867*a*b*b+976763788*a*b+925668016*a-128537024*b*b-359163728*b-10185728,
      1643918400*a**3-1105797420*a*a*b-7261914240*a*a+154718524*a*b*b+3804690316*a*b+9944961600*a-282623593*b*b-3443769343*b-3454184244,
      35068545*a**3+2864538*a*a*b-236376549*a*a-5350827*a*b*b+24417420*a*b+469658574*a+14536855*b*b-90750394*b-214068162,
    ]
    M=[
      -4*(a-1)*(b-7)*(3*a-b-2)*(2*a*b+7*a-9*b),
      -9*(a-1)*(2*b-11)*(3*a-b-2)*(4*a*b+11*a-15*b),
      -25*(a-1)*(3*b-13)*(2*a-b-1)*(3*a*b+13*a-16*b),
      -(a-1)*(4*b-17)*(13*a-5*b-8)*(32*a*b+85*a-117*b),
    ]
    delta=a*b*(a-1)*(b-1)*(a-b)
    q0=31223016*b*b-435944529*b+1306078948
    q4=83246*b*b-872181*b+2185995
    bezout=(2265746679974131615-377042650728395274*b)*q0+(141417109727495582904*b-1342668830289072756147)*q4
    assert sp.expand(bezout)==24176690547344887359179755
    evaluations=[q0.subs(b,sp.Rational(17,4)),q0.subs(b,sp.Rational(85,16)),q4.subs(b,sp.Rational(26,3)),q4.subs(b,sp.Rational(13,3))]
    assert evaluations==[sp.Rational(69121705,4),sp.Rational(-4117757269,32),sp.Rational(7918133,9),sp.Rational(-272530,9)]
    line_factor=-(b-1)**4*(4*b-17)*(16*b-85)*q4
    ratio=sp.factor((D[3]*M[3]).subs(a,(b+2)/3)/line_factor)
    assert ratio.is_Rational and ratio != 0
    result={}
    for choices in itertools.product((0,1),repeat=3):
        equations=[(D,M)[choice][i] for i,choice in enumerate(choices)]
        gb=sp.groebner(equations+[h*delta-1],h,a,b,domain=sp.QQ)
        name=''.join(('D','M')[choice]+str(i+1) for i,choice in enumerate(choices))
        expected_empty=choices not in ((1,1,0),(1,1,1))
        assert (list(gb)==[1])==expected_empty
        if not expected_empty:
            assert gb.reduce(3*a-b-2)[1]==0
            residual=q0 if choices==(1,1,0) else (3*b-26)*(3*b-13)
            assert gb.reduce(residual)[1]==0
            target=sp.groebner([3*a-b-2,residual,h*delta-1],h,a,b,domain=sp.QQ)
            assert all(target.reduce(p.as_expr())[1]==0 for p in gb.polys)
        result[name]='empty' if expected_empty else str(sp.factor(residual))
    return {'localized_cases':result,'bezout_constant':str(sp.expand(bezout)),'line_restriction_factor':str(ratio),'linear_root_exclusion_values':list(map(str,evaluations)),'scope':'Checks printed polynomial cover; does not reconstruct tangent determinants from Cox quadrics.'}

def tangent_checks() -> dict:
    a,b=sp.symbols('a b')
    names='E1 E2 E3 E4 E5 L12 L13 L14 L15 L23 L24 L25 L34 L35 L45 Q'.split()
    symbols=sp.symbols(' '.join(names))
    coords=dict(zip(names,symbols))
    E1,E2,E3,E4,E5,L12,L13,L14,L15,L23,L24,L25,L34,L35,L45,Q=symbols
    equations=[E2*L12-E3*L13+E4*L14,
        a*E2*L12-b*E3*L13+E5*L15,
        E1*L12-E3*L23+E4*L24,
        E1*L12-b*E3*L23+E5*L25,
        E1*L13-E2*L23+E4*L34,
        E1*L13-a*E2*L23+E5*L35,
        (b-1)*E1*L14+(a-b)*E2*L24+E5*L45,
        a*L23*L45+(a-b)*L24*L35-E1*Q]
    def point(z,e):
        z1,z2,z3=z
        lines=[z3,z2,z2-z3,b*z2-a*z3,z1,z1-z3,b*z1-z3,z1-z2,a*z1-z2,(b-a)*z1+(1-b)*z2+(a-1)*z3]
        indices=[(0,1),(0,2),(0,3),(0,4),(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)]
        conic=b*(1-a)*z1*z2+a*(b-1)*z1*z3+(a-b)*z2*z3
        values=list(map(sp.Integer,e))+[sp.sympify(line)/(e[i]*e[j]) for line,(i,j) in zip(lines,indices)]+[conic/sp.prod(e)]
        return dict(zip(symbols,values))
    witnesses=[((1,3,7),(2,3,5,7,11),(2,4,9)),((2,5,11),(3,4,7,13,17),(1,6,10)),((3,8,13),(5,7,11,17,19),(2,9,15)),((4,9,17),(2,5,11,19,23),(3,10,18))]
    D=[(8*a-27)**2*(3968*a-1349*b-2619),568453977*a**3-373279764*a*a*b-1658788404*a*a+59068867*a*b*b+976763788*a*b+925668016*a-128537024*b*b-359163728*b-10185728,1643918400*a**3-1105797420*a*a*b-7261914240*a*a+154718524*a*b*b+3804690316*a*b+9944961600*a-282623593*b*b-3443769343*b-3454184244,35068545*a**3+2864538*a*a*b-236376549*a*a-5350827*a*b*b+24417420*a*b+469658574*a+14536855*b*b-90750394*b-214068162]
    M=[-4*(a-1)*(b-7)*(3*a-b-2)*(2*a*b+7*a-9*b),-9*(a-1)*(2*b-11)*(3*a-b-2)*(4*a*b+11*a-15*b),-25*(a-1)*(3*b-13)*(2*a-b-1)*(3*a*b+13*a-16*b),-(a-1)*(4*b-17)*(13*a-5*b-8)*(32*a*b+85*a-117*b)]
    groups=['L13 L23 L35','L14 L24 L45','E1 E2 E5','L12 L15 L25']
    group_indices=[[names.index(n) for n in group.split()] for group in groups]
    minor_indices=[names.index(n) for n in 'E1 E2 E5 L12 L13 L14 L15 L23'.split()]
    boundary_indices=[names.index(n) for n in 'E3 E4 L34 Q'.split()]
    jac=sp.Matrix(equations).jacobian(symbols)
    out=[]
    for i,(z,e,zp) in enumerate(witnesses):
        p=point(z,(1,1,1,1,1)); x=point(zp,e)
        assert all(sp.expand(f.subs(p))==0 and sp.expand(f.subs(x))==0 for f in equations)
        J=jac.subs(p)
        minor=sp.factor(J[:,minor_indices].det(method='domain-ge'))
        assert sp.expand(minor-M[i])==0
        kernel=J[:,boundary_indices].T.nullspace()
        assert len(kernel)==4
        H=sp.Matrix.vstack(*(v.T*J for v in kernel)).applyfunc(sp.cancel)
        assert H[:,boundary_indices]==sp.zeros(4)
        ev=sp.Matrix(4,4,lambda r,c:sum(H[r,j]*x[symbols[j]] for j in group_indices[c]))
        determinant=sp.factor(ev.det(method='domain-ge'))
        ratio=sp.factor(determinant/D[i])
        assert ratio.is_Rational and ratio!=0, (i,ratio)
        out.append({'witness':i+1,'jacobian_minor_matches':True,'evaluation_determinant_ratio':str(ratio),'eight_quadrics_vanish_at_both_points':True})
    result={'revision':'f46624d','checks':out,'scope':'Independent reconstruction from the eight printed Cox quadrics. This does not replay the separate all-twenty-quadrics certificate.'}
    return result

def require(condition: bool, message: str) -> None:
    if not condition:
        raise ArithmeticError(message)

def elliptic_and_smoothness_checks() -> dict:
    t, x, y, z, u, v, r, X, Y, Z = sp.symbols('t x y z u v r X Y Z')
    q = x*x + 3*y*y
    g = -z**3 + sp.Rational(3, 4)*q*z + t*y**3
    cubic = (z-x)*u*u + 6*y*u*v + 3*(z+x)*v*v + g
    weierstrass = Y*Y*Z - X**3 + 27*X*X*Z - 1728*t*t*Z**3
    transformed = weierstrass.subs({X: -12*t*y, Y: 36*t*x, Z: z}, simultaneous=True)
    require(sp.expand(transformed - 1728*t*t*g) == 0, 'Elliptic coordinate change failed')
    a, b = -243, 1728*t*t-1458
    discriminant = sp.factor(-16*(4*a**3+27*b*b))
    c4 = -48*a
    j = sp.factor(c4**3 / discriminant)
    require(discriminant == -2**12*3**9*t*t*(16*t*t-27), 'Elliptic discriminant failed')
    require(j == -sp.Rational(19683)/(t*t*(16*t*t-27)), 'j-invariant failed')
    sextic_C = 16*t*t-(r*r+3)**3
    sextic_H = 32*t*r**3-(r*r+3)**3
    disc_C = sp.factor(sp.discriminant(sextic_C, r))
    disc_H = sp.factor(sp.discriminant(sextic_H, r))
    require(sp.factor(disc_C/(t**8*(16*t*t-27))).is_Integer, 'Unexpected C branch factors')
    require(sp.factor(disc_H/(t**4*(16*t*t-27))).is_Integer, 'Unexpected H branch factors')
    require(sp.factor(disc_C/(t**8*(16*t*t-27))) != 0, 'C discriminant identically zero')
    require(sp.factor(disc_H/(t**4*(16*t*t-27))) != 0, 'H discriminant identically zero')
    variables = (u, v, x, y, z)
    smooth_samples = []
    for value, prime in [(1, 5), (1, 7), (5, 7), (7, 13)]:
        F = sp.expand(4*cubic.subs(t, value))
        basis = sp.groebner([sp.diff(F, w) for w in variables], *variables, modulus=prime)
        remainders = [basis.reduce(w**6)[1] for w in variables]
        require(all(a == 0 for a in remainders), 'Sample cubic geometric smoothness check failed')
        smooth_samples.append({'parameter': value, 'prime': prime, 'sixth_powers_in_jacobian_ideal': True})
    return {
        'cubic': str(cubic), 'elliptic_plane_cubic': str(g),
        'weierstrass_equation': 'Y^2 Z = X^3 - 27 X^2 Z + 1728 t^2 Z^3',
        'coordinate_change': {'X': '-12*t*y', 'Y': '36*t*x', 'Z': 'z'},
        'short_weierstrass_a': a, 'short_weierstrass_b': str(b),
        'c4': c4, 'discriminant': str(discriminant), 'j': str(j),
        'C_discriminant': str(disc_C), 'H_discriminant': str(disc_H),
        'smoothness_samples': smooth_samples,
        'scope': 'Uniform smoothness and the geometric elliptic factor are proved in the note.'
    }

def prime_sequence(length: int) -> list[int]:
    if length < 1:
        raise ValueError('Sequence length must be positive')
    values = [1]
    while len(values) < length:
        candidate = 5
        while any(a*(16*a*a-27) % candidate == 0 for a in values):
            candidate = int(sp.nextprime(candidate))
        values.append(candidate)
    return values

def prime_certificates(length: int) -> dict:
    values = prime_sequence(length)
    certificates = []
    for index, prime in enumerate(values[1:], start=1):
        require(sp.isprime(prime) and prime >= 5, 'New parameter not a permitted prime')
        old_residues = [int(a*(16*a*a-27) % prime) for a in values[:index]]
        require(all(old_residues), 'A predecessor has a bad reduction factor at the new prime')
        require((16*prime*prime-27) % prime != 0, 'Unexpected extra j-denominator valuation')
        require(19683 % prime != 0, 'Numerator changes the j-valuation')
        certificates.append({
            'parameter': prime, 'separating_prime': prime,
            'predecessor_good_reduction_residues': old_residues,
            'new_elliptic_j_valuation': -2
        })
    return {'parameters': values, 'certificates': certificates,
            'scope': 'Certifies the elementary local conditions; invokes written reduction and Hodge arguments for nonbirationality.'}

def quartic_j(f: sp.Expr, x: sp.Symbol) -> sp.Expr:
    a, b, c, d, e = sp.Poly(f, x).all_coeffs()
    i = 12*a*e - 3*b*d + c*c
    j = 72*a*c*e + 9*b*c*d - 27*a*d*d - 27*b*b*e - 2*c**3
    return sp.factor(6912*i**3 / (4*i**3-j*j))

def elliptic_quotients() -> dict:
    x, t, k, z, v, s = sp.symbols('x t k z v s')
    c = 16*t*t - (x*x+3)**3
    c_plus = 16*t*t-(z+3)**3
    c_minus = z*(16*t*t-(z+3)**3)
    assert sp.expand(c_plus.subs(z, x*x)-c) == 0
    assert sp.expand(c_minus.subs(z, x*x)-x*x*c) == 0
    c_j = quartic_j(c_minus, z)
    assert sp.factor(c_j + 2**12*3**6*t*t/(16*t*t-27)**2) == 0

    h = (x*x+1)**3-k*x**3
    for sign in (1, -1):
        target = (z+2*sign)*(z**3-k)
        lhs = h*(x+sign)**2/x**4
        assert sp.factor(lhs-target.subs(z, x+1/x)) == 0
        expected = sign*55296*k/(k+sign*8)**2
        assert sp.factor(quartic_j(target, z)-expected) == 0

    js = [sp.Integer(0), 432/(s*s*(1-s*s)),
          -6912*s*s/(s*s-1)**2,
          6912*s/(s+1)**2, -6912*s/(s-1)**2]
    degree = lambda f: max(sp.degree(q, s) for q in sp.fraction(sp.cancel(f)))
    assert [degree(j) for j in js[1:]] == [4, 4, 2, 2]
    assert sp.factor(js[2].subs(s, 1/s)-js[2]) == 0
    for j in js[3:]:
        assert sp.factor(j.subs(s, 1/s)-j) == 0
    assert sp.factor(js[3].subs(s, -s)-js[4]) == 0
    assert sp.factor(js[3]+js[4]-4*js[2]) == 0
    assert sp.factor(js[3]*js[4]-6912*js[2]) == 0
    r = sp.symbols('r')
    c_r = -6912*r/(r-1)**2
    assert sp.factor(c_r*(c_r-1728)-3456**2*r*(r+1)**2/(r-1)**4) == 0
    return {
        'C_second_quotient_j': str(c_j),
        'normalized_five_j_invariants': [str(sp.factor(j)) for j in js],
        'nonconstant_j_map_degrees': [4, 4, 2, 2],
        'quotient_map_identities': True,
        'H_j_pair_equation': 'Z^2 - 4*c*Z + 6912*c = 0',
        'factor_splitting_field': 'C(r)(sqrt(r)), r=16*t^2/27',
        'pole_supports': [[], ['0', '-1', '1'], ['-1', '1'], ['-1'], ['1']],
    }

def point_count(coefficients: list[int], p: int, degree: int) -> int:
    def chi(a: int) -> int:
        a %= p
        return 0 if a == 0 else (1 if pow(a, (p-1)//2, p) == 1 else -1)

    if degree == 1:
        result = p
        for x in range(p):
            value = 0
            for c in coefficients:
                value = (value*x+c) % p
            result += chi(value)
        return result + (1 if len(coefficients) % 2 == 0 else 1+chi(coefficients[0]))

    if degree != 2:
        raise ValueError('Only F_p and F_(p^2) are implemented.')
    n = next(i for i in range(2, p) if chi(i) == -1)
    result = p*p
    for x, y in itertools.product(range(p), repeat=2):
        a, b = 0, 0
        for c in coefficients:
            a, b = (a*x+n*b*y+c) % p, (a*y+b*x) % p
        result += chi(a*a-n*b*b)
    return result + (1 if len(coefficients) % 2 == 0 else 2)

def frobenius(f: sp.Expr, x: sp.Symbol, p: int) -> sp.Expr:
    f = sp.Poly(f, x)
    coeff = [int(c) % p for c in f.all_coeffs()]
    assert coeff[0] != 0
    assert sp.Poly(f, modulus=p).gcd(sp.Poly(sp.diff(f.as_expr(), x), x, modulus=p)).degree() == 0
    n1 = point_count(coeff, p, 1)
    a1 = p+1-n1
    T = sp.Symbol('T')
    if f.degree() in (3, 4):
        return T*T-a1*T+p
    n2 = point_count(coeff, p, 2)
    numerator = n2-p*p-1+a1*a1
    assert numerator % 2 == 0
    return T**4-a1*T**3+(numerator//2)*T*T-p*a1*T+p*p

def cubic_points(t: int, p: int) -> int:
    count = 0
    for first in range(5):
        for tail in itertools.product(range(p), repeat=4-first):
            u, v, x, y, z = (0,)*first+(1,)+tail
            f = 4*(z-x)*u*u+24*y*u*v+12*(z+x)*v*v-4*z**3+3*(x*x+3*y*y)*z+4*t*y**3
            count += f % p == 0
    return count

def finite_field_checks() -> list[dict]:
    p = 13
    sqrt3 = next(x for x in range(p) if x*x % p == 3)
    assert any(x*x % p == (-27) % p for x in range(p))
    x, T = sp.symbols('x T')
    rows = []
    for t in (1, 2, 4, 5):
        assert t*(16*t*t-27) % p
        c = 16*t*t-(x*x+3)**3
        c1 = 16*t*t-(x+3)**3
        c2 = x*(16*t*t-(x+3)**3)
        cpol = frobenius(c, x, p)
        c1pol, c2pol = frobenius(c1, x, p), frobenius(c2, x, p)
        assert sp.expand(cpol-c1pol*c2pol) == 0
        k = 32*sqrt3*pow(9, -1, p)*t % p
        h = 2*((x*x+1)**3-k*x**3)
        h1, h2 = 2*(x+2)*(x**3-k), 2*(x-2)*(x**3-k)
        hpol = frobenius(h, x, p)
        h1pol, h2pol = frobenius(h1, x, p), frobenius(h2, x, p)
        assert sp.expand(hpol-h1pol*h2pol) == 0
        e = x**3-243*x+1728*t*t-1458
        epol = frobenius(e, x, p)
        trace = -sum(int(sp.Poly(q, T).coeff_monomial(T)) for q in [epol,c1pol,c2pol,h1pol,h2pol])
        n = cubic_points(t, p)
        assert n == 1+p+p*p+p**3-p*trace
        rows.append({'p':p, 't':t, 'five_elliptic_factors':[str(q) for q in [epol,c1pol,c2pol,h1pol,h2pol]],
                     'C_factorization':True, 'H_factorization':True, 'cubic_point_count':n,
                     'five_factor_trace_matches_cubic':True, 'normalized_H_quadratic_twist':2})
    for p in (5,7,11,13):
        for t in (1,2,4):
            if t*(16*t*t-27) % p == 0:
                continue
            e=x**3-243*x+1728*t*t-1458
            c=-3*(16*t*t-(x*x+3)**3)
            h=-6*(32*t*x**3-(x*x+3)**3)
            pol=[frobenius(f,x,p) for f in (e,c,h)]
            trace=-sum(int(sp.Poly(f,T).coeff_monomial(T**(sp.degree(f,T)-1))) for f in pol)
            n=cubic_points(t,p)
            assert n==1+p+p*p+p**3-p*trace
            rows.append({'p':p,'t':t,'Q_defined_factors':[str(f) for f in pol],
                         'twists':{'C':-3,'H':-6},'cubic_point_count':n,
                         'Q_defined_trace_matches_cubic':True})
    return rows

def toric_rank(t: Fraction, p: int) -> int:
    if p < 5 or not sp.isprime(p):
        raise ValueError('The certificate requires a prime p >= 5.')
    a, b = t.numerator, t.denominator
    if a == 0:
        raise ValueError('The parameter must be nonzero.')
    if a % p == 0:
        return 1
    if b % p != 0 and (16*a*a-27*b*b) % p == 0:
        return 3
    return 0

def squarefree(n: int) -> bool:
    return n != 0 and all(e == 1 for e in sp.factorint(abs(n)).values())

def certificate(t: Fraction) -> dict:
    a, b = t.numerator, t.denominator
    if a <= 0 or b % 2 == 0 or gcd(a, 6) != 1:
        raise ValueError('The reconstruction chart requires a > 0 coprime to 6 and b positive odd.')
    d = 16*a*a-27*b*b
    if d <= 0 or not squarefree(a*d):
        raise ValueError('The reconstruction chart requires a*(16a^2-27b^2) positive and squarefree.')
    s1 = sorted(int(p) for p in sp.factorint(a))
    s3 = sorted(int(p) for p in sp.factorint(d))
    assert all(p >= 5 for p in s1+s3)
    assert set(s1).isdisjoint(s3)
    assert all(toric_rank(t,p) == 1 for p in s1)
    assert all(toric_rank(t,p) == 3 for p in s3)
    aa, dd = prod(s1), prod(s3)
    b2 = (16*aa*aa-dd)//27
    bb = isqrt(b2)
    assert 27*b2 == 16*aa*aa-dd and bb*bb == b2
    assert Fraction(aa,bb) == t
    return {'parameter':str(t), 'a':a, 'b':b, 'D':d, 'rank_1_primes':s1, 'rank_3_primes':s3,
            'reconstructed_parameter':str(Fraction(aa,bb))}

def arithmetic_checks(bound: int) -> dict:
    integers = [n for n in range(1,bound+1) if gcd(n,6)==1 and squarefree(n)]
    for i,a in enumerate(integers):
        for b in integers[:i]:
            pa, pb = set(sp.factorint(a)), set(sp.factorint(b))
            p = int(min(pa ^ pb))
            assert toric_rank(Fraction(a),p) != toric_rank(Fraction(b),p)
    rational_rows = []
    for a in range(1,bound+1,6):
        for b in range(1,(a-1)//2+1,2):
            if 4*b <= a or gcd(a,b)!=1:
                continue
            d=16*a*a-27*b*b
            if squarefree(a*d):
                rational_rows.append(certificate(Fraction(a,b)))
    assert len({(tuple(r['rank_1_primes']),tuple(r['rank_3_primes'])) for r in rational_rows}) == len(rational_rows)
    return {'bound':bound, 'squarefree_integer_count':len(integers), 'first_integer_parameters':integers[:35],
            'all_integer_pairs_locally_separated':True,
            'rational_reconstruction_count_in_wedge':len(rational_rows),
            'sample_rational_certificates':rational_rows[:20]}

def s_unit_identities() -> dict:
    t = sp.symbols('t', nonzero=True)
    root = sp.sqrt(3)
    w = 3*root/(4*t)
    x, y = (1+w)/2, (1-w)/2
    assert sp.simplify(x+y-1) == 0
    assert sp.simplify(3*root/(4*(x-y))-t) == 0
    assert sp.factor(x*y-(16*t*t-27)/(64*t*t)) == 0
    assert sp.simplify(x.xreplace({root:-root})-y) == 0
    return {'x':str(x), 'y':str(y), 'sum':1,
            'norm_x':'(16*t^2 - 27)/(64*t^2)',
            'recovery':'t = 3*sqrt(3)/(4*(x-y))',
            'conjugation_identity':True,
            'unit_equation_solver_implemented':False,
            'rank_bound':'2^(8*(number_of_finite_places_above_S + 2))'}

def simplex_checks() -> dict:
    weights = [sp.Matrix(w) for w in ((0,1,1),(1,0,1),(1,1,0),(1,1,1))]
    differences = sp.Matrix.hstack(*(w-weights[0] for w in weights[1:]))
    visible = sp.Matrix.hstack(*(sp.Matrix(w) for w in ((0,1,1),(1,0,1),(1,1,0))))
    require(abs(differences.det()) == 1, 'Selected simplex is not unimodular')
    require(abs(visible.det()) == 2, 'Unsaturated parametrization has unexpected index')
    k0,k1,k2,k3 = sp.symbols('k0 k1 k2 k3', nonzero=True)
    t1,t2,t3 = k3/k0,k3/k1,k3/k2
    require(sp.cancel(t1/t2-k1/k0) == 0, 'First correction ratio failed')
    require(sp.cancel(t1/t3-k2/k0) == 0, 'Second correction ratio failed')
    require(sp.cancel(t1-k3/k0) == 0, 'Third correction ratio failed')
    return {'difference_determinant':int(differences.det()),
            'unsaturated_index':abs(int(visible.det())),
            'orbit_correction_verified':True}


def local_density_checks() -> list[dict]:
    rows=[]
    for p in (5,7,11,13,17,19):
        modulus=p*p
        actual=sum(a*(16*a*a-27*b*b)%modulus == 0
                   for a in range(modulus) for b in range(modulus))
        lines=3 if sp.legendre_symbol(3,p)==1 else 1
        expected=p*p+lines*p*(p-1)
        require(actual==expected, f'Local density failed at {p}')
        rows.append({'p':p,'zero_count_mod_p_squared':actual,'lines':lines})
    return rows


def main() -> None:
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',type=Path,default=Path('sharpness_upgrade_checks.json'))
    parser.add_argument('--bound',type=int,default=240)
    parser.add_argument('--length',type=int,default=20)
    parser.add_argument('--skip-tangent',action='store_true')
    args=parser.parse_args()
    if not __debug__:
        parser.error('Run without -O; assertions are part of the verification.')
    if args.bound < 20 or args.length < 1:
        parser.error('--bound must be at least 20 and --length must be positive.')
    jobs=[('family',family_checks),('simplex',simplex_checks),
          ('lattices',lattice_checks),('uniform_cover',certificate_polynomials)]
    if not args.skip_tangent:
        jobs.append(('tangent_reconstruction',tangent_checks))
    jobs += [('smooth_pencil',elliptic_and_smoothness_checks),
             ('elliptic_quotients',elliptic_quotients),('finite_field_twists',finite_field_checks),
             ('local_certificates',lambda:arithmetic_checks(args.bound)),
             ('recursive_sequence',lambda:prime_certificates(args.length)),
             ('local_densities',local_density_checks),('s_unit_identities',s_unit_identities)]
    result={'sympy_version':sp.__version__,'python_version':sys.version.split()[0],
            'baseline':'f46624d','tangent_reconstruction_skipped':args.skip_tangent}
    for name,job in jobs:
        result[name]=job()
        print(f'Passed: {name}',flush=True)
    result['all_requested_checks_passed']=True
    result['scope']=(
        'Exact finite algebra only. The Cox check reconstructs eight tangent rows, '
        'not the complete twenty-quadric ideal or the repository verification target. '
        'The surface geometry, Galois identification, descent, Hodge conservation, '
        'Prym comparison, reduction theory and squarefree/S-unit theorems are separate '
        'written arguments or imported results. No expanded rationalization or full '
        'S-unit solver is produced.')
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2,default=str)+'\n',encoding='utf-8')
    print(f'All requested checks passed. Output: {args.output}',flush=True)


if __name__=='__main__':
    main()

```
<!-- END SHARPNESS CHECKER -->
