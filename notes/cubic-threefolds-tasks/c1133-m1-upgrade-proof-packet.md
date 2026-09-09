# Quantum Hodge invariants and one-stabilization of Fano threefolds
## Consolidated proof and manuscript-upgrade packet

**Baseline:** `cubic-stabilization-m1`, revision `b156ec6`.  
**Scope:** the one-stabilization paper and its numerical, parity, Hodge, cancellation, and arithmetic upgrades.  
**Prepared:** 9 September 2026.  
**Purpose:** a working mathematical and editorial specification for incorporation into the manuscript, not a substitute for independent review.

The core finite Fano calculations were rerun while assembling this packet. A successful calculation does not verify the completed coefficient maps, their Hodge-equivariant restrictions, or the geometric interpretation of the matrices. The distinction between these tasks is maintained throughout.

## Reading map

| Part | Contents |
|---|---|
| [Part I](#part-i) | Title, abstracts, hierarchy, and principal theorems |
| [Part II](#part-ii) | Dependency map and unresolved integration gates |
| [Part III](#part-iii) | Comparison contract, superalgebra, and persistence |
| [Part IV](#part-iv) | Finite-jet formula, canonical lattices, and GM calculation |
| [Part V](#part-v) | Mixed parity and the surface-vanishing proof |
| [Part VI](#part-vi) | All seventeen inputs and the classification proof |
| [Part VII](#part-vii) | Hodge-fixed comparison and conservation of third cohomology |
| [Part VIII](#part-viii) | Generic cancellation, countability, and arithmetic finiteness |
| [Part IX](#part-ix) | Further filters and the dimensional/integral boundaries |
| [Appendix I](#appendix-i) | Corrected rank-three construction; optional |
| [Appendix II](#appendix-ii) | Uniform odd-cubic calculation; optional |
| [Appendix III](#appendix-iii) | Rational-motive and Grothendieck-group application; optional |
| [Part X](#part-x) | Baseline-specific edits and integration order |
| [Part XI](#part-xi) | Novelty ledger and bibliography |
| [Part XII](#part-xii) | Verification coverage and release checklist |
| [Appendix IV](#appendix-iv) | Standalone exact checker embedded in this file |

For editing, start with Parts I, II, and X. The main mathematical route is Parts III–VIII. Appendices I–III are optional and do not enter the proof of the classification or Hodge conservation.

---

<a id="part-i"></a>

# Part I. Editorial decision and front matter

## 1. Recommended scope

The upgraded paper should have one main narrative:

> Select whole quantum primary factors that cannot occur on a surface, and retain either their canonical residue data or their odd Hodge representation. Quantum blowup comparisons then make the selected data invariant under birational maps of fourfolds. The resulting invariants give a complete one-stabilization classification for Picard-rank-one Fano threefolds and conserve the rational third cohomology of the detected families.

The numerical classification must not depend on the Hodge-valued extension. Neither should depend on the corrected rank-three lattice construction. This separation makes the strongest claims individually auditable and permits a coherent intermediate revision.

Keep the following as the principal results:

1. A surface-vanishing construction and its blowup/projective-bundle formulas.
2. The complete Picard-rank-one Fano threefold classification after one stabilization.
3. Rational Hodge conservation under one-stable birationality for the nine detected families.
4. Very-general cancellation for cubic and quartic threefolds, using published rational generic Torelli.

Place bounded-degree arithmetic finiteness in a short applications section. Keep the basis-free finite-jet formula in the main text: it is the computational mechanism, not merely a certificate. Put the corrected rank-three lattice, the odd-dimensional cubic calculation, and the rational-motive example in appendices or a separate supplementary section.

The rationalization constructions, intrinsic cubic-moduli reconstruction, period-gluing calculations, essential dimension, and detailed pencil-isogeny rigidity belong in the other two papers. The present paper can state their consequences after explicitly importing the relevant theorem. It must not use those papers to prove its numerical or Hodge-valued invariants.

## 2. Title

**Recommended full-upgrade title**

> **Quantum Hodge invariants and one-stabilization of Fano threefolds**

This states the mechanism and the main application without suggesting an all-varieties cancellation theorem or a classification of stable rationality.

**Fallback title if the Hodge comparison is not yet ready**

> **One-stabilization of Fano threefolds**

Retain the cubic theorem as the opening example and a named consequence, but do not retain a cubic-only title for a paper whose main numerical theorem covers all seventeen Picard-rank-one families.

## 3. Suggested abstract

### 3.1 Full target abstract

**Use this version only after the comparison and Hodge-extension gates in Section 8 have been discharged in the manuscript.**

> We construct numerical and Hodge-valued invariants from whole primary factors of quantum cohomology. A canonical rank-two residue and a mixed-parity condition select factors that vanish on all smooth projective surfaces. Compatibility with quantum blowup and projective-bundle decompositions makes the selected data birationally invariant in dimensions three and four. We deduce that a smooth complex Fano threefold of Picard rank one is rational if and only if its product with a projective line is rational. For the nine nonrational deformation families, one-stable birationality preserves the rational third cohomology as a Hodge structure. In particular, it preserves the isogeny class of the intermediate Jacobian. Rational generic Torelli then gives one-stabilization cancellation for very general cubic and quartic threefolds. The construction includes a basis-free finite-jet formula and explicit calculations for all seventeen families. We also obtain countability and arithmetic finiteness statements for one-stable partners of a fixed cubic threefold.

### 3.2 Numerical-only abstract

**Use if the numerical proof is complete but the Hodge-valued extension remains a working supplement.**

> We construct birational obstructions to one stabilization from whole primary factors of quantum cohomology. A canonical rank-two residue retains information beyond formal exponent classes, while a mixed-parity condition detects primary factors carrying odd cohomology. Both constructions vanish on smooth projective varieties of dimension at most two and satisfy blowup and projective-bundle formulas. We deduce that a smooth complex Fano threefold of Picard rank one is rational if and only if its product with a projective line is rational. The obstruction applies to every smooth member of the nine nonrational deformation families, including ordinary and special Gushel–Mukai threefolds. A basis-free finite-jet formula and explicit counting matrices make the calculations independently reproducible. The result concerns one stabilization and does not classify stable rationality after an arbitrary number of stabilizations.

### 3.3 Interim circulation wording

If an essential comparison adaptation has not been proved, do not hide it behind either abstract. Use an explicitly conditional statement in an internal draft:

> Subject to the faithful, parity-preserving quantum comparison statement formulated in Section [...], the construction gives [...]. The Hodge-conservation consequences additionally require the equivariant fixed-base comparison of Section [...].

This is a drafting boundary, not a recommendation to leave the final paper permanently axiomatic.

## 4. Suggested body hierarchy

| Section | Proposed heading | Function |
|---|---|---|
| 1 | Introduction and main results | State the Fano classification, Hodge conservation, and generic cancellation; explain why surface centers are the issue. |
| 2 | Quantum connections and comparison domains | Fix the three base/module conventions, original lattices, faithful center maps, and generic separation. |
| 3 | Cyclic primary factors and canonical rank-two residues | Prove persistence, modification, lattice functoriality, and the finite-jet formula. |
| 4 | Parity and surface vanishing | Prove the super Frobenius lemma, the rank-three odd count, surface vanishing, and birational invariance. |
| 5 | Picard-rank-one Fano threefolds | Give the complete table, explain homogeneity and deformation, and prove the classification. |
| 6 | Hodge-labelled factors | Construct the fixed-base representation-valued refinement and prove Hodge conservation. |
| 7 | Cancellation and arithmetic consequences | Apply rational generic Torelli, countability, bounded-degree isogeny finiteness, and potential reduction. |
| 8 | Scope, sharpness, and limitations | State the dimensional ceiling and the precise relation to the other two papers. |
| Appendix A | Counting data and exact certificates | All seventeen matrices, normalization, zero controls, and executable checks. |
| Appendix B | A corrected rank-three lattice | Independent technical extension; not needed for the classification or HC. |
| Appendix C | Odd-dimensional cubics and motivic separation | Optional additional reuse, if the paper remains readable. |

The old abstract block monoid need not precede the proof. A short abstract transport proposition suffices for the main argument. The Grothendieck-ring extension can follow the applications.

## 5. Main theorem hierarchy

Use distinct theorem labels so downstream papers can cite exactly the input they need.

### Theorem A — Fano one-stabilization classification

Let \(X\) be a smooth complex Fano threefold with \(\rho(X)=1\). Then

\[
X\times\mathbf P^1\text{ is rational}
\quad\Longleftrightarrow\quad
X\text{ is rational}.
\]

The rational families are \(\mathbf P^3\), the smooth quadric threefold, index-two degrees \(4,5\), and index-one genera \(7,9,10,12\). The remaining nine families stay irrational after one stabilization.

For a characteristic-zero field \(k\), any geometrically defined member of one of the nine detected families has non-\(k\)-rational product with \(\mathbf P^1\). The reverse implication for arbitrary forms of the other eight geometric families is not asserted over \(k\).

### Theorem B — One-stable Hodge conservation

Let \(X,Y\) be smooth complex Fano threefolds, each belonging to one of the nine detected Picard-rank-one families. If

\[
X\times\mathbf P^1\sim_{\mathrm{bir}}Y\times\mathbf P^1,
\]

then

\[
H^3(X,\mathbf Q)\cong H^3(Y,\mathbf Q)
\]

as rational Hodge structures. In particular, their intermediate Jacobians are isogenous.

The same-family formulation for cubics is the principal standalone corollary. Retaining the numerical labels additionally excludes cross-family pairs with different signatures.

This theorem is not asserted for all Fano threefolds: rational Fanos can have different \(H^3\), so such a statement would be false.

### Theorem C — Generic cancellation

Let \(X\) be a very general smooth cubic threefold and \(Y\) any smooth cubic threefold. Then

\[
X\times\mathbf P^1\sim_{\mathrm{bir}}Y\times\mathbf P^1
\quad\Longleftrightarrow\quad X\cong Y.
\]

The corresponding statement holds for smooth quartic hypersurfaces in \(\mathbf P^4\), with \(X\) very general and \(Y\) arbitrary in that hypersurface family. The recovery step is Donagi’s rational generic Torelli theorem in Voisin’s formulation [V].

### Theorem D — Arithmetic finiteness for a fixed cubic

Fix a smooth cubic threefold \(X\) over a finitely generated characteristic-zero field \(K\subset\mathbf C\), and an integer \(D\ge1\). Up to geometric isomorphism, only finitely many cubics \(Y\), defined over extensions \(L/K\) of degree at most \(D\), satisfy

\[
X_{\mathbf C}\times\mathbf P^1
\sim_{\mathrm{bir}}
Y_{\mathbf C}\times\mathbf P^1.
\]

This counts geometric classes, not twists. It does not assume a height bound on \(Y\), and it does not provide a numerical bound on the number of partners.

---

<a id="part-ii"></a>

# Part II. Foundations and proof dependencies

## 6. What is imported and what is new

| ID | Input or assertion | Status in this packet |
|---|---|---|
| F0 | Graded, divisor-equation-reduced numerical Novikov domains and formal QDMs | Imported from the baseline and [I], with the exact source rings retained. |
| F1 | Quantum blowup and projective-bundle decompositions | Published inputs [I], [IK]; verify their precise hypotheses, twists, and completed domains. |
| F2 | Faithful identification of each center’s intrinsic generic QDM after the actual comparison | Baseline argument `lem:faithful-center-base-change`; an essential proof obligation, not a consequence of an untagged Novikov map. |
| F3 | Regularity of comparisons and inverses on the original \(z\)-lattices; generic separation of distinct occurrences | Baseline argument and the cited comparison theorems. |
| P1 | Extension from the even module to the full supermodule over the even bulk body | Requires an explicit parity-preserving comparison statement in the upgraded manuscript. |
| H1 | Universal-Hodge-group equivariance and fixed-base restriction | Published equivariance [IH, Proposition 8], [KKP, §§5.2–5.4], plus the fixed-base adaptation of F2–F3. |
| H2 | Constancy and scalar extension of the representation on a selected factor | Supplied below using equivariant projectors and semisimplicity; align with the coefficient convention in [KKP]. |
| Q1 | The seventeen small quantum counting matrices | Published inputs [G], [P68], [PW], cross-checked against [NAB]. |
| D1 | Smooth-deformation transport to every member of each geometric family | Standard deformation invariance plus the classification; document special anticanonical models explicitly. |
| T1 | Rational generic Torelli for cubic and quartic threefolds | Published input [V, Theorem 0.2 and Remarks 0.1, 0.3]. |
| A1 | Arithmetic intermediate Jacobians, isogeny bounds, finite principal polarizations | Published inputs [A], [O, Theorem 5.1], [NN]. |

New proofs below are deductions from these identified inputs. No claim of independent formal verification of F0–F3, H1, or D1 is made.

The framed-monodromy companion’s hypotheses R and T are not used. In particular, no invariance under an arbitrary noninjective specialization of Novikov parameters is needed or claimed.

## 7. Dependency map

```text
Published QDM comparisons + original regular lattices
                  |
         faithful center transport
                  |
       +----------+-------------------------+
       |                                    |
rank-two lattice/residue           full supermodule over even body
       |                                    |
finite-jet formula                  rank-three odd contribution
       |                                    |
       +----------- surface vanishing ------+
                           |
                numerical blowup formulas
                           |
               seventeen-family computation
                           |
                      Theorem A

Hodge-equivariant comparisons + rechecked faithful transport on fixed bases
                           |
            selected odd Hodge representations
                           |
                   surface vanishing
                           |
                      Theorem B
                    /           \
          rational Torelli     arithmetic isogeny theory
                 |                       |
             Theorem C               Theorem D

Corrected rank-three lattice ---- optional appendix, not an input above
Sharpness/moduli constructions -- downstream applications, not inputs above
```

## 8. Explicit integration gates

These are concrete author/referee checks. They must not be replaced by a sentence that “the same argument applies.”

### G1. Full-super comparison

After setting odd bulk coordinates to zero, retain the odd cohomology in the module. Verify that the comparison and its inverse preserve parity and identify the Frobenius pairing on each whole primary factor. A theorem only about the even restricted QDM is not enough for the parity invariant.

### G2. Fixed locus is not the whole even base

For Hodge-valued invariants, restrict the bulk parameters to the universal-Hodge-group-fixed locus. The group need not act fibrewise at a general even-bulk point.

An equivariant formal isomorphism restricts to a formal isomorphism of fixed loci. However, injectivity of an unrelated ring map does not automatically survive quotienting by the nonfixed coordinates. Repeat the faithful-center proof on the reduced fixed-base domains. The independent divisor and unit coordinates survive because they are Hodge-fixed; the other surviving coordinates must be tracked through the invertible fixed-part Jacobian.

### G3. Keep the full even ranks

The selector uses the even rank of a whole primary factor in the **full supermodule**, not the dimension of its Hodge-invariant subspace. Restricting to Hodge-invariant vectors in the fibre would discard the odd Hodge representation one is trying to retain.

### G4. Distinguish the two numerical bases

Write \(\mathcal O_3^{\mathrm{ev}}\) for the invariant over the full even bulk body and \(\mathcal O_3^G\) for its fixed-base analogue. Similarly distinguish the fixed-base lattice spectrum if it is used.

One has

\[
\dim\mathscr H_3(Y)=2\mathcal O_3^G(Y),
\]

not automatically \(2\mathcal O_3^{\mathrm{ev}}(Y)\). A restricted base may have a different generic primary decomposition. The two bases agree at the Picard-rank-one Fano endpoints, since their even cohomology is Tate, and surface vanishing is proved directly on each base. No equality of the two generic decompositions for arbitrary varieties is required.

This convention prevents an implicit identification present in some of the working notes.

### G5. Whole-primary transport before representation decomposition

Apply the even-rank, nilpotence, and residue selector to a whole primary factor first. Only then record or decompose its odd Hodge representation. Splitting into irreducible Hodge representations before applying the rank test changes the invariant.

### G6. Lattice preservation, not only exponent preservation

The resonant cases require preservation of the original lattice and its canonical modification. Meromorphic gauges with independent integral shifts of eigenlines can change the discriminant while preserving exponent classes. A comparison in the punctured connection category alone is insufficient.

### G7. All smooth members

A matrix for a general geometric model proves the all-member assertion only after smooth-deformation transport is justified. For GM threefolds, include the ordinary/special deformation. For the lower-genus families, document special anticanonical presentations instead of silently identifying every member with the general model in the table.

### G8. Rational, not integral, Hodge cancellation

Cancellation takes place in a semisimple rational representation category. The result is a rational Hodge isomorphism and an isogeny. Do not upgrade it to an integral lattice isomorphism, an isomorphism of principally polarized intermediate Jacobians, or all-member cubic cancellation.

### G9. Evidence scope

Record matrix checks as finite algebra. Do not mark new geometric statements as Lean-complete unless the actual formal theorem and all its hypotheses have been checked by the kernel. This packet includes no Lean replay and no rebuild of the manuscript.

---

<a id="part-iii"></a>

# Part III. Common formal setup

## 9. Three constructions, three explicit conventions

Let \(Y\) be smooth projective of dimension \(n\). With \(\mu|_{H^k}=(k-n)/2\), use horizontal equations

\[
\nabla_{\partial_{t^\alpha}}
 =\partial_{t^\alpha}+z^{-1}(\phi_\alpha\star),
\qquad
\nabla_{z\partial_z}
 =z\partial_z-z^{-1}(E_Y\star)+\mu.
\]

Thus

\[
z^2\partial_z y=(U-z\mu)y,
\qquad U=E_Y\star,
\qquad
E_Y=c_1(Y)+\sum_\alpha
\left(1-\frac{\deg\phi_\alpha}{2}\right)t^\alpha\phi_\alpha.
\]

| Construction | Bulk base | Underlying module |
|---|---|---|
| Original rank-two scalar invariant | Even body | \(H^{\mathrm{ev}}(Y)\) |
| Mixed-parity invariant | Even body | Full \(H^*(Y)\), with its super grading |
| Hodge-valued invariant | Hodge-group-fixed bulk locus | Full \(H^*(Y)\), not just its invariant vectors |

The symbol “generic” refers to the relevant quantum coefficient field, not to a general point of variety moduli. Each construction is evaluated over an algebraic closure of that field before counting factors.

Centering at an Euler eigenvalue \(\lambda\) removes the scalar exponential and replaces the leading operator by \(N=U-\lambda\). Scalar centering of the base equations is performed simultaneously. Comparisons preserve the original coordinate \(z\) and its regular lattice; ramification in Novikov variables is different from ramification in \(z\).

## 10. Exact comparison contract

For a smooth center \(Z\subset Y\) of codimension \(c\), the comparison has one ambient occurrence and \(c-1\) center occurrences. For a rank-\(r\) projective bundle it has \(r\) base occurrences. What the proof needs is:

1. Each occurrence is a faithful scalar extension of its intrinsic QDM on the chosen base, followed by the specified formal coordinate change.
2. The connection maps and their inverses are regular on the original \(z\)-lattices and preserve the required paired structure.
3. Different occurrences have disjoint Euler spectra at the generic comparison point.
4. For the parity construction the maps preserve the full supermodule.
5. For the Hodge construction the maps are equivariant on the Hodge-fixed bases, with only the recorded Tate suspensions.

The imported raw center monomial map is not presumed injective. In the divisor-equation-reduced source, the combined generators have the form

\[
X_d=Q_Z^d\exp(\sigma^{(2)}\cdot d).
\]

The actual occurrence map retains independent target divisor coordinates:

\[
X_d\longmapsto
Q^{i_*d}q_{\rm exc}^{-\rho_Z\cdot d/(c-1)}
\exp\bigl((\varsigma_j^{\circ,(2)}+s_j^{(2)})\cdot d\bigr).
\]

The baseline injectivity argument must be retained on the graded reduced source: take the first nonzero Novikov degree, use finiteness in that degree, and distinguish the colliding curve classes by their exponential characters. Source coefficients must not already depend freely on the target divisor coordinates. The full exponentials, rather than a bounded bulk truncation, are part of the argument.

On the Hodge-fixed base, all divisor coordinates in this calculation survive. Repeat the first-nonzero-degree argument with the surviving nondivisor variables and the fixed-part coordinate isomorphism. Do not infer this from injectivity before restriction alone.

Generic separation is a different argument. Independent occurrence-unit variables shift the Euler matrices by independent scalars. The resultant of characteristic polynomials from two occurrences is a nonzero polynomial in their shift difference, so their primary factors do not merge generically.

Each blowup is compared over its own common domain. Weak factorization uses the resulting intrinsic operation formula; it does not require recursively composing incompatible Laurent expansions. The published comparison inputs are [I, Theorem 5.18], [IK, Theorem 5.1], and the Hodge-equivariant refinement [IH, Proposition 8]. The baseline adaptation is `lem:faithful-center-base-change`.

## 11. Whole primary factors and parity

Let \(A\) be the quantum Frobenius superalgebra over the chosen generic field, and let \(U\) be multiplication by the even Euler element. Decompose into whole generalized eigenspaces

\[
A=\bigoplus_\lambda A_\lambda,
\qquad
r_\lambda=\dim A_\lambda^{\mathrm{ev}},\quad
s_\lambda=\dim A_\lambda^{\mathrm{odd}}.
\]

Each factor is a unital ideal, obtained by a polynomial spectral idempotent in the Euler element. The Frobenius pairing is orthogonal between distinct factors and nondegenerate on each. Its restriction to the odd part is alternating, so \(s_\lambda\) is even.

The odd spectrum introduces no eigenvalue absent from the even spectrum. If a polynomial annihilates Euler multiplication on the even algebra, apply it to the unit to obtain an identity for the Euler element. Multiplication by that identity annihilates the entire algebra.

This is why an even counting matrix, together with the full odd dimension, can sometimes determine the odd allocation without a separate odd multiplication calculation.

### Lemma 11.1 — Even rank one excludes odd cohomology

A finite-dimensional supercommutative Frobenius algebra over a characteristic-zero field whose even part is one-dimensional has zero odd part.

**Proof.** Write the even part as \(Ke\), where \(e\) is the unit. If \(a,b\) are odd, then \(ab=ce\). Supercommutativity gives \(a^2=b^2=0\), hence \((ab)^2=-a^2b^2=0\), so \(c=0\). All odd products vanish. The Frobenius pairing of two odd elements is the trace of their product, so it vanishes identically. Nondegeneracy forces the odd space to be zero. \(\square\)

**Consequence.** If the even primary dimensions are \(r+1+\cdots+1\), all odd cohomology lies in the rank-\(r\) factor. In particular this applies to the \(2+1+1\) and \(3+1\) Fano decompositions.

## 12. Cyclic persistence in arbitrary rank

### Proposition 12.1

Over a characteristic-zero complete formal bulk germ, let a rank-\(r\) cluster be separated from its complement. Suppose its centered leading operator is one nilpotent Jordan block at the initial point and its scalar-centered base equations have at most a simple \(z\)-pole. Then it remains a single nilpotent Jordan block throughout that germ.

**Proof.** Write the centered equations as

\[
z\partial_z y=(N/z+A_0+O(z))y,
\qquad
\partial y=(C/z+B_0+O(z))y,
\]

with \(\operatorname{tr}N=0\). A cyclic vector at the initial point extends by Nakayama. Thus the commutant of \(N\) over the complete local ring consists of polynomials in \(N\) of degree at most \(r-1\).

Flatness gives

\[
[N,C]=0,
\qquad
\partial N=-C+[C,A_0]+[B_0,N].
\tag{12.1}
\]

Taking traces shows \(\operatorname{tr}C=0\). Put \(p_j=\operatorname{tr}(N^j)\), with \(p_0=r\), \(p_1=0\). Then

\[
C=\sum_{j=1}^{r-1}q_j\left(N^j-\frac{p_j}{r}I\right).
\]

In tracing (12.1) against \(N^{k-1}\), both commutator terms vanish because \(C\) commutes with \(N\). Hence

\[
\partial p_k
=-k\sum_{j=1}^{r-1}q_j
\left(p_{k+j-1}-\frac{p_jp_{k-1}}r\right),
\qquad 2\le k\le r.
\tag{12.2}
\]

Newton identities and Cayley–Hamilton express the higher traces as polynomials in \(p_1,\ldots,p_r\) with no constant term. Thus the ideal generated by those traces is preserved by every base derivative. If any trace had lowest nonzero total bulk degree \(m>0\), a suitable derivative would have degree \(m-1\), while the right side of (12.2) has degree at least \(m\). Characteristic zero gives a contradiction. All traces vanish identically.

Cayley–Hamilton gives \(N^r=0\), and the continued cyclic vector makes it one Jordan block. \(\square\)

The displayed full flatness identity is preferable to abbreviating it as \(\partial N=-C+[N,B]\) without constructing \(B\). The trace argument is all that is required.

This persistence principle has close precedents in regular \(F\)-manifold theory [DH] and Cai’s quartic argument [CQ]. The new application should not be framed as the discovery that cyclic nilpotent clusters can persist.

Persistence alone does not prove regularity of a higher-rank modified lattice.

<a id="part-iv"></a>

# Part IV. Rank-two residues and the numerical obstruction

## 13. Canonical modification and its functoriality

Let a separated even rank-two block have centered equation

\[
z\partial_z y=(N/z+A_0+zA_1+\cdots)y,
\qquad N^2=0\ne N.
\]

Let \(L=\operatorname{im}N=\ker N\). If \(P(z)=P_0+zP_1+\cdots\) is its nondegenerate horizontal pairing, the first two pairing equations are

\[
N^TP_0=P_0N,
\]
\[
A_0^TP_0+P_0A_0+N^TP_1-P_1N=0.
\]

The line \(L\) is isotropic for \(P_0\), so \(L^\perp=L\). Evaluating the second identity on a vector of \(L\) twice gives \((A_0x,x)=0\). Therefore \(A_0L\subset L\).

In an adapted frame write

\[
N=\begin{pmatrix}0&\nu\\0&0\end{pmatrix},
\quad
A_0=\begin{pmatrix}a&b\\0&d\end{pmatrix},
\quad
(A_1)_{21}=c.
\]

The canonical modified lattice is

\[
E^\sharp=\{s\in E:s\bmod z\in L\}.
\]

Its frame is \((e_1,ze_2)\). With \(S=\operatorname{diag}(1,z)\), the transformed equation is regular singular and has residue

\[
R=S^{-1}AS-S^{-1}z\partial_zS\pmod z
 =\begin{pmatrix}a&\nu\\c&d-1\end{pmatrix}.
\tag{13.1}
\]

The subtraction of one is a derivative term. The entry \(c\) requires the next connection coefficient; simply restricting \(A_0\) to the primary eigenspace is not the residue calculation.

### Proposition 13.1 — Residue invariance

The discriminant

\[
\delta^\sharp=(\operatorname{tr}R)^2-4\det R
\]

is preserved by the permitted formal bulk transport and by regular comparisons of the original paired lattices.

**Proof.** Proposition 12.1 preserves the cyclic nilpotent block. In rank two, a centered leading base coefficient commuting with \(N\) is a scalar multiple of \(N\). After modification, the only possible pole in the base equation is \(kE_{21}/z\). The pole coefficient of flatness is

\[
kE_{21}+[R,kE_{21}]=0.
\]

Its diagonal entries force \(\nu k=0\), hence \(k=0\). The base equation is regular and the residue satisfies a Lax equation

\[
\partial R=[B_\partial,R].
\]

Its characteristic polynomial is constant.

A regular comparison \(G\), with regular inverse, transports \(N\) and \(L\), so carries \(E^\sharp\) to the corresponding modified lattice. The matrix

\[
S_{\mathrm{target}}^{-1}GS_{\mathrm{source}}
\]

and its inverse are regular. Reduction modulo \(z\) conjugates residues. That conjugating matrix need not equal the original \(G(0)\): its lower-left entry can involve the first coefficient of \(G\). \(\square\)

Define

\[
I_{\mathrm{lat}}(Y)=
\#\{E:\operatorname{rank}E=2,\ N^2=0\ne N,\ \delta^\sharp(E)\ne0\},
\]

and retain the spectral version

\[
\mathfrak S_{\mathrm{lat}}(Y)
 =\sum_{E\text{ selected}}e_{\delta^\sharp(E)}.
\]

All factors are whole generic even primary factors. The exponent count is the weaker selector

\[
\delta^\sharp\notin\{m^2:m\in\mathbf Z\}.
\]

A nonzero integer-square discriminant is excluded by the exponent count but retained by the lattice count. This distinction is essential for quartic double solids and GM threefolds. No nonresonance assumption occurs in Proposition 13.1.

## 14. Basis-free finite-jet formula

This proposition is independent finite linear algebra once the preservation hypothesis is supplied.

Consider

\[
z^2\partial_z y=(U+zD+z^2F+O(z^3))y.
\]

Let \(\lambda\) have a whole primary block of algebraic multiplicity two with nonzero square-zero centered operator. Let \(P\) be its spectral projector, \(Q=1-P\), and put

\[
N=(U-\lambda)P,
\qquad
T=\bigl((U-\lambda)|_{\operatorname{im}Q}\bigr)^{-1}Q.
\]

Assume \(PDP\) preserves \(\operatorname{im}N\). Define \(\kappa\) by

\[
[PDP,N]=\kappa N.
\]

### Proposition 14.1

\[
\boxed{
\delta^\sharp=(\kappa+1)^2
 +4\operatorname{tr}(NF)
 -4\operatorname{tr}(NDTD).
}
\tag{14.1}
\]

**Proof.** Use a constant frame separating the selected block \(B\) from the complement \(C\), and center at \(\lambda\). The leading blocks are \(N\) and an invertible \(M\). The first off-diagonal gauge coefficient satisfies

\[
MX_{CB}-X_{CB}N=-D_{CB},
\]

hence

\[
X_{CB}=-M^{-1}D_{CB}-M^{-2}D_{CB}N.
\]

Choose the normalized gauge with zero diagonal coefficients in positive orders. The \(z^2\)-coefficient of the separated \(B\)-block is

\[
F_{BB}+D_{BC}X_{CB}.
\]

The derivative of the first gauge coefficient has zero \(B\)-diagonal block. In an adapted frame as in (13.1), \(\kappa=a-d\), and

\[
\delta^\sharp=(a-d+1)^2+4\nu c.
\]

Multiplication by \(N\) and trace extracts \(\nu c\). The term with \(M^{-2}D_{CB}N\) disappears by cyclicity of trace and \(N^2=0\), leaving

\[
\nu c=\operatorname{tr}(NF)-\operatorname{tr}(NDTD).
\]

This proves (14.1). Higher original coefficients and higher normalized off-diagonal gauge terms do not enter the coefficient being extracted. \(\square\)

### Projectors without splitting the complement

If

\[
\det(tI-(U-\lambda))=t^2\psi(t),\qquad\psi(0)\ne0,
\]

choose \(a(t)\) such that \(a(t)\psi(t)\equiv1\pmod{t^2}\). Then

\[
P=a(U-\lambda)\psi(U-\lambda),
\qquad
T=(U-\lambda+P)^{-1}(1-P).
\]

The calculation uses polynomial inversion modulo \(t^2\), one matrix inverse, commutators, and traces. It needs no complementary eigenvalues and no infinite formal gauge. If \(\lambda\) itself is not in the coefficient field, first make the required algebraic coefficient extension.

For a small QDM in a fixed cohomology basis, \(D=-\mu\) and \(F=0\). A basis involving quantum products can vary with the Novikov variables; its grading matrix must be transformed correctly. Do not combine a multiplication matrix from a moving basis with the diagonal grading matrix of a fixed basis.

## 15. The universal index-two calculation

For

\[
U_{a,b}(q)=
\begin{pmatrix}
0&aq&0&a^2q^2\\
1&0&bq&0\\
0&1&0&aq\\
0&0&1&0
\end{pmatrix},
\qquad
D=\tfrac12\operatorname{diag}(3,1,-1,-3),
\]

put \(s=2a+b\), with \(sq\ne0\). Then

\[
\det(TI-U)=T^2(T^2-sq),
\]

and the zero-primary block has residue

\[
R_{a,b}=
\begin{pmatrix}
-\dfrac{2a+3b}{2s}&1\\[3pt]
-\dfrac{4a^2}{s^2}&\dfrac{b-2a}{2s}
\end{pmatrix},
\qquad
\boxed{\delta^\sharp=\frac{4(b-2a)}{b+2a}.}
\]

The parameters \((a,b)=(240,1248),(48,160),(24,60)\) give degrees \(1,2,3\), respectively, in the anticanonical-power normalization. These formulas are already in the baseline; retain them as the first worked example, followed by GM rather than a second cubic-only diagonalization.

## 16. Worked new application: all smooth GM threefolds

The genus-six matrix in the fixed anticanonical-power basis is

\[
U(q)=
\begin{pmatrix}
0&156q^2&3600q^3&33120q^4\\
1&10q&380q^2&3600q^3\\
0&1&10q&156q^2\\
0&0&1&0
\end{pmatrix},
\qquad D=\tfrac12\operatorname{diag}(3,1,-1,-3).
\]

This is the full even module. The counting input is [P68, Theorem 6.1.1]. Its characteristic polynomial is

\[
(\lambda+6q)^2(\lambda^2-32q\lambda-244q^2).
\]

At \(q=1\), a cyclic chain is

\[
b_1=(-360,-60,-6,1)^T,
\qquad b_2=(-88,-22,1,0)^T,
\]

with \((U+6)b_2=b_1\) and \((U+6)b_1=0\). Formula (14.1) gives

\[
\kappa=-\frac92,
\qquad
\operatorname{tr}(NDTD)=\frac{45}{16},
\qquad
\delta^\sharp=1.
\]

An independent separated-block calculation gives

\[
R_{\mathrm{GM}}=
\begin{pmatrix}-9/4&1\\-45/16&5/4\end{pmatrix},
\qquad \operatorname{Spec}R_{\mathrm{GM}}=\{-1,0\}.
\]

Thus

\[
I_{\mathrm{exp}}(X)=0,
\qquad I_{\mathrm{lat}}(X)=1,
\qquad \mathfrak S_{\mathrm{lat}}(X)=e_1.
\]

This is a substantive resonant application. Its exponent classes coincide, so it cannot be obtained by merely repeating the weaker exponent test.

The calculation is generic in the Novikov variable:

\[
U(q)=qK(q)U(1)K(q)^{-1},
\qquad K(q)=\operatorname{diag}(q^3,q^2,q,1).
\]

The matrix \(K\) commutes with \(D\); rescaling \(N\) by \(q\) rescales the reduced inverse \(T\) by \(q^{-1}\), so (14.1) is unchanged. Proposition 12.1 and residue rigidity then transport the calculation into the formal bulk germ.

A special smooth GM threefold is a quadric section of a suitable linear section of the cone over \(\operatorname{Gr}(2,5)\). Move the linear space off the cone vertex to obtain ordinary GM members. Smoothness is open, giving a smooth local deformation of the starting special member. The connected ordinary family and deformation invariance complete the passage to all smooth members; cite the ordinary/special and moduli descriptions in [Deb].

Surface vanishing and the bundle formula give

\[
\mathfrak S_{\mathrm{lat}}(X\times\mathbf P^1)=2e_1
\ne0=\mathfrak S_{\mathrm{lat}}(\mathbf P^4).
\]

This proves the one-stabilization obstruction, subject to the comparison inputs. The characteristic-zero descent argument is recorded in Section 22.

---

<a id="part-v"></a>

# Part V. Parity, surfaces, and birational transport

## 17. The rank-three odd contribution

On the full supermodule over the generic even bulk body, define

\[
\boxed{
\mathcal O_3^{\mathrm{ev}}(Y)
 =\frac12\sum_{r_\lambda=3}s_\lambda.
}
\]

It is an integer by the alternating pairing on each odd primary part. Define \(\mathcal O_3^G\) identically over the Hodge-fixed base when needed.

If the even decomposition is \(3+1\), Lemma 11.1 gives

\[
\mathcal O_3^{\mathrm{ev}}(Y)=\frac12\dim H^{\mathrm{odd}}(Y).
\]

This is not an assertion that the odd multiplication is trivial. It locates the odd space by the Frobenius algebra structure.

## 18. Surface vanishing, with the degree argument written out

### Proposition 18.1

The original lattice spectrum, the odd-rank-three count, and the Hodge-valued selectors defined in Part VII vanish on every smooth projective variety of dimension at most two, on their respective bases.

**Curves and points.** Their full even dimensions are at most two. For a curve of genus at least two, the quantum product is classical and the rank-two modified residue has equal eigenvalues, hence discriminant zero. For an elliptic curve, the centered Euler operator is zero. For \(\mathbf P^1\), the generic even spectrum is simple. No point or curve supplies a rank-three even factor.

**Rational surfaces.** Their odd cohomology is zero. For the scalar lattice invariant, compare to \(\mathbf P^2\) by surface weak factorization: point centers have zero lattice spectrum, while the generic spectrum of \(\mathbf P^2\) is simple. This uses only point-center vanishing, not the fourfold birational theorem being proved later.

**Geometrically ruled surfaces.** A minimal ruled surface over \(\mathbf C\) is a projective-line bundle over a curve. Its generic factors are the two curve occurrences in the bundle comparison. Each has even rank at most two, and any eligible rank-two curve factor has discriminant zero. Point blowups add rank-one even factors.

**Minimal surfaces with nef canonical divisor.** Let \(S\) be such a surface. Remove the unit scalar from Euler multiplication. Consider a nonzero contribution involving an Euler insertion of complex cohomological degree \(e\ge1\), a class of degree \(p\), and \(k\) nonunit even bulk insertions of degrees \(d_1,\ldots,d_k\ge1\). The dimension constraint gives output degree

\[
p+e+\sum_{i=1}^k(d_i-1)-c_1(S)\cdot\beta.
\tag{18.1}
\]

Because \(K_S\) is nef, \(c_1(S)\cdot\beta\le0\), so the output degree strictly exceeds \(p\). Unit insertions are handled by the string equation and the removed unit shift. The same degree calculation applies on the Hodge-fixed subspace.

Thus the centered Euler operator is degree-raising and nilpotent, with a single primary eigenvalue. Its even rank is

\[
b_2(S)+2\ge3.
\]

It cannot supply an even rank-two selector. It can have even rank three only if \(b_2(S)=1\). Then \(q(S)=0\): a nonzero holomorphic one-form \(\alpha\) would give

\[
\beta=i\alpha\wedge\overline\alpha,
\qquad \beta^2=0,
\]

whose cohomology class is nonzero because \(\int_S\beta\wedge\omega>0\) for a Kähler form \(\omega\). This contradicts the positive square of every nonzero real class in the one-dimensional \(H^2(S,\mathbf R)\). Hence \(H^1(S)=H^3(S)=0\), and the potential rank-three factor has no odd part.

Every smooth projective surface is obtained from the cases above by point blowups. The operation formula completes the proof. \(\square\)

The key conclusion is not that surfaces have little odd cohomology. They can have arbitrarily much. They cannot carry it in this particular whole-primary even-rank-three configuration.

## 19. Operation formulas

For either numerical selector \(I\), the exact comparison contract gives

\[
I(\operatorname{Bl}_Z Y)=I(Y)+(c-1)I(Z),
\qquad
I(\mathbf P_YV)=\operatorname{rk}(V)I(Y).
\tag{19.1}
\]

For \(\mathfrak S_{\mathrm{lat}}\), use canonical-lattice functoriality. For \(\mathcal O_3^{\mathrm{ev}}\), only full parity preservation and whole-primary transport are required. Independent occurrence-unit parameters prevent merger of factors in the external direct sum.

### Proposition 19.1 — Dimensional transport

Suppose an additive invariant with values in an abelian group satisfies (19.1) and vanishes on all smooth projective varieties of dimension at most two. It is birationally invariant among smooth projective varieties of dimension three or four.

**Proof.** In projective weak factorization, a nontrivial smooth center in dimension at most four has dimension at most two. Every blowup contribution is zero. \(\square\)

If its target is torsion-free, \(I(\mathbf P^4)=0\), and \(I(X)\ne0\) for a threefold, then

\[
I(X\times\mathbf P^1)=2I(X)\ne0
\]

rules out rationality. The torsion-free qualification matters for a general abstract target; it is satisfied by the scalar, spectral, and representation groups used here.

---

<a id="part-vi"></a>

# Part VI. The complete Fano calculation

## 20. Input normalization and all seventeen families

Use the anticanonical-power cohomology basis and write

\[
M(a,b,c,d,e,f)=
\begin{pmatrix}
a&c&e&f\\
1&b&d&e\\
0&1&b&c\\
0&0&1&a
\end{pmatrix},
\qquad
D=\tfrac12\operatorname{diag}(3,1,-1,-3).
\]

The table below uses the scalar-shifted counting convention. For the index-one rows, subtract \(aI\) to recover the unshifted small Euler matrix at the normalized Novikov parameter. The shift changes the removed scalar irregular term, not the centered nilpotent block or its residue.

The entries are imported quantum data, not new enumerative computations. Attribute the original matrices to [G], [P68], [PW], as appropriate, and the recent complete characteristic-polynomial comparison to [NAB].

| Family | `(a,b,c,d,e,f)` | $h^{2,1}$ | Even primary ranks | $I_{\rm lat}$ | $\mathcal O_3$ |
|---|---|---:|---|---:|---:|
| Index 1, genus 2 | `(120, 744, 137520, 650016, 119681280, 21690374400)` | 52 | 3+1 | 0 | 52 |
| Index 1, genus 3 | `(24, 104, 3888, 13600, 504576, 18323712)` | 30 | 3+1 | 0 | 30 |
| Index 1, genus 4 | `(12, 42, 792, 2340, 43632, 793152)` | 20 | 3+1 | 0 | 20 |
| Index 1, genus 5 | `(8, 24, 304, 800, 9984, 121088)` | 14 | 3+1 | 0 | 14 |
| Index 1, genus 6 | `(6, 16, 156, 380, 3600, 33120)` | 10 | 2+1+1 | 1 | 0 |
| Index 1, genus 7 | `(5, 12, 96, 216, 1692, 12816)` | 7 | 2+1+1 | 0 | 0 |
| Index 1, genus 8 | `(4, 9, 64, 140, 924, 5936)` | 5 | 2+1+1 | 1 | 0 |
| Index 1, genus 9 | `(4, 8, 48, 96, 576, 3328)` | 3 | 2+1+1 | 0 | 0 |
| Index 1, genus 10 | `(3, 6, 36, 72, 378, 1944)` | 2 | 2+1+1 | 0 | 0 |
| Index 1, genus 12 | `(12/5, 22/5, 24, 44, 198, 880)` | 0 | 1+1+1+1 | 0 | 0 |
| Index 2, degree 1 | `(0, 0, 240, 1248, 0, 57600)` | 21 | 2+1+1 | 1 | 0 |
| Index 2, degree 2 | `(0, 0, 48, 160, 0, 2304)` | 10 | 2+1+1 | 1 | 0 |
| Index 2, degree 3 | `(0, 0, 24, 60, 0, 576)` | 5 | 2+1+1 | 1 | 0 |
| Index 2, degree 4 | `(0, 0, 16, 32, 0, 256)` | 2 | 2+1+1 | 0 | 0 |
| Index 2, degree 5 | `(0, 0, 12, 20, 0, 160)` | 0 | 1+1+1+1 | 0 | 0 |
| Index 3, quadric | `(0, 0, 0, 0, 54, 0)` | 0 | 1+1+1+1 | 0 | 0 |
| Index 4, projective space | `(0, 0, 0, 0, 0, 256)` | 0 | 1+1+1+1 | 0 | 0 |

### Complete characteristic polynomials in the shifted convention

| Family | $\det(tI-M)$ |
|---|---|
| Index 1, genus 2 | $t^{3} \left(t - 1728\right)$ |
| Index 1, genus 3 | $t^{3} \left(t - 256\right)$ |
| Index 1, genus 4 | $t^{3} \left(t - 108\right)$ |
| Index 1, genus 5 | $t^{3} \left(t - 64\right)$ |
| Index 1, genus 6 | $t^{2} \left(t^{2} - 44 t - 16\right)$ |
| Index 1, genus 7 | $t^{2} \left(t^{2} - 34 t + 1\right)$ |
| Index 1, genus 8 | $t^{2} \left(t - 27\right) \left(t + 1\right)$ |
| Index 1, genus 9 | $t^{2} \left(t^{2} - 24 t + 16\right)$ |
| Index 1, genus 10 | $t^{2} \left(t^{2} - 18 t - 27\right)$ |
| Index 1, genus 12 | $\frac{\left(5 t + 8\right) \left(125 t^{3} - 1900 t^{2} - 40 t - 188\right)}{625}$ |
| Index 2, degree 1 | $t^{2} \left(t^{2} - 1728\right)$ |
| Index 2, degree 2 | $t^{2} \left(t - 16\right) \left(t + 16\right)$ |
| Index 2, degree 3 | $t^{2} \left(t^{2} - 108\right)$ |
| Index 2, degree 4 | $t^{2} \left(t - 8\right) \left(t + 8\right)$ |
| Index 2, degree 5 | $t^{4} - 44 t^{2} - 16$ |
| Index 3, quadric | $t \left(t^{3} - 108\right)$ |
| Index 4, projective space | $\left(t - 4\right) \left(t + 4\right) \left(t^{2} + 16\right)$ |

### Rank-two certificates, including the rational zero controls

Here $F=0$, so $\delta^\sharp=(\kappa+1)^2-4\operatorname{tr}(NDTD)$.

| Family | $\kappa$ | $\operatorname{tr}(NDTD)$ | $\delta^\sharp$ |
|---|---:|---:|---:|
| Index 1, genus 6 | $- \frac{9}{2}$ | $\frac{45}{16}$ | $1$ |
| Index 1, genus 7 | $23$ | $144$ | $0$ |
| Index 1, genus 8 | $- \frac{73}{27}$ | $\frac{448}{729}$ | $\frac{4}{9}$ |
| Index 1, genus 9 | $-1$ | $0$ | $0$ |
| Index 1, genus 10 | $- \frac{7}{3}$ | $\frac{4}{9}$ | $0$ |
| Index 2, degree 1 | $- \frac{22}{9}$ | $\frac{25}{324}$ | $\frac{16}{9}$ |
| Index 2, degree 2 | $- \frac{9}{4}$ | $\frac{9}{64}$ | $1$ |
| Index 2, degree 3 | $- \frac{19}{9}$ | $\frac{16}{81}$ | $\frac{4}{9}$ |
| Index 2, degree 4 | $-2$ | $\frac{1}{4}$ | $0$ |

### Cyclicity and genericity

For every displayed matrix,

\[
\det(e_0,Me_0,M^2e_0,M^3e_0)=1.
\]

Thus each repeated eigenvalue gives one cyclic primary block, not several Jordan blocks.

For Fano index \(r\), allow a coefficient extension with \(w^r=q\). The homogeneous matrix is

\[
M(w)=wK(w)M(1)K(w)^{-1},
\qquad K(w)=\operatorname{diag}(w^3,w^2,w,1),
\]

with the corresponding scalar shift removed when required. The entries of an actual degree satisfy the index divisibility, so only the appropriate powers of \(q\) occur. This proves the generic one-Novikov spectrum; the specialization \(q=1\) is not being used as an arbitrary replacement for a multivariable generic point.

Since \(K\) commutes with \(D\), the finite-jet formulas transport the residue computation. A unit linear rescaling of the fibre coordinate is also a way to check the same numerical identity. It is a computational device, not permission to use meromorphic gauges or fractional powers of \(z\) in the comparison theorem.

Proposition 12.1 now carries the repeated clusters into the generic formal bulk germ. The rank-one complements remain rank one. Lemma 11.1 locates all odd cohomology in the nontrivial cluster.

### The four rank-three cases

For index-one genera \(2,3,4,5\), the even dimensions are \(3+1\). Since a Fano threefold has \(H^{\mathrm{odd}}=H^3\),

\[
\mathcal O_3=h^{2,1}=52,30,20,14,
\]

respectively. No rank-three residue calculation is needed for these four obstructions.

### The five positive rank-two cases

\[
\begin{array}{c|c}
\text{family}&\mathfrak S_{\mathrm{lat}}\\\hline
\text{index 2, degree 1}&e_{16/9}\\
\text{index 2, degree 2}&e_1\\
\text{index 2, degree 3}&e_{4/9}\\
\text{index 1, genus 6}&e_1\\
\text{index 1, genus 8}&e_{4/9}.
\end{array}
\]

The zero cases in the table are important controls: the method does not falsely detect the rational degree-four or genus-seven, -nine, and -ten families.

## 21. Proof of Theorem A

The combined invariant

\[
(\mathfrak S_{\mathrm{lat}},\mathcal O_3^{\mathrm{ev}})
\]

is nonzero on exactly the nine indicated families. It doubles under \(\mathbf P^1\), vanishes on \(\mathbf P^4\), and is birationally invariant in dimension four. Hence every member of those families remains irrational after one stabilization.

The other eight families are rational by the classical classification, in the form recalled in [KP, §1.1]. Their products with \(\mathbf P^1\) are therefore rational. This proves the equivalence over \(\mathbf C\).

The finite table does not prove the positive rationality half: cite the geometric rationality results. Likewise, it does not prove that every variety of the indicated numerical invariants is in the required smooth deformation component. Supply the classification/deformation input D1, including special presentations. The quantum calculations themselves are invariant under that smooth deformation. \(\square\)

### Seven distinct numerical signatures

There are at least seven nonzero signatures: four values of \(\mathcal O_3\), and the three labels \(1,4/9,16/9\). Different signatures exclude birationality before or after one stabilization. Equal signatures do not imply birationality, derived equivalence, or equivalent quantum connections.

## 22. Characteristic-zero descent and projective bundles

If a geometrically defined member of one of the nine families over a characteristic-zero field \(k\) had a \(k\)-rational one-stabilization, descend the variety, rational map, inverse map, and their identities to a finitely generated subfield. Enlarge it finitely if needed to realize the geometric family presentation. Embed it in \(\mathbf C\). The rationalization would contradict Theorem A there.

This argument does not assume that the whole field \(k\) embeds in \(\mathbf C\). No rational point is needed for the negative conclusion.

Every rank-two projective bundle over a detected threefold is likewise irrational: its function field is that of \(X\times\mathbf P^1\), and its invariant is twice that of \(X\).

The arithmetic converse for a geometrically rational family requires the appropriate rational-point or curve conditions; see [KP]. Do not rewrite Theorem A as a rationality equivalence over every characteristic-zero field.

<a id="part-vii"></a>

# Part VII. Hodge-labelled factors

## 23. The representation category and fixed base

Use the universal Hodge group in the Tate-periodized convention of [KKP]. For any finite argument, one may pass to a finite-dimensional reductive quotient through which all cohomology representations in the relevant finite sequence of comparisons factor. Use one common group, not unrelated Mumford–Tate groups for the individual varieties.

The group acts on the full cohomology module. Restrict the bulk base to its fixed locus, but do not replace the module by its invariant subspace. The parity element makes the fixed base purely even. Novikov variables, divisor directions, and unit directions are fixed in the periodized convention.

At a fixed-base point, Euler multiplication commutes with the group. Its spectral projectors therefore commute with the group, so every whole primary factor has an odd Hodge representation.

The target can be described as the Grothendieck group of the semisimple category of Tate-periodized polarizable rational Hodge structures, with the algebraic coefficient extension used to split the quantum spectrum. Equivalently use the corresponding representation group in [KKP]. State that convention once and use it consistently.

### Lemma 23.1 — Constancy of the selected representation

A continued equivariant spectral projector on a connected fixed-base germ has constant representation class.

**Proof.** After a splitting coefficient extension, decompose the finite-dimensional original representation into isotypical pieces

\[
V=\bigoplus_i V_i\otimes M_i.
\]

An equivariant idempotent acts as the identity on \(V_i\) tensored with an idempotent on \(M_i\). The image of an idempotent is a direct summand, hence a vector bundle with locally constant rank. Its ranks are constant on the connected germ. Thus the multiplicities of the irreducible representations in its image are constant. The argument is compatible with further field extension. \(\square\)

This lemma concerns a continued whole primary projector. It does not justify carrying a primary decomposition through an arbitrary specialization where eigenvalues merge.

## 24. Equivariant comparison proposition

### Proposition 24.1 — Required upgraded comparison statement

The blowup and projective-bundle decompositions, restricted to the Hodge-fixed bulk bases and to the same faithful reduced-source domains, preserve the representation class of each whole primary factor. For an eligible rank-two factor they also preserve its canonical modified lattice and discriminant. The center representations are those of the intrinsic fixed-base QDM of the center, with the specified Tate suspensions.

**Proof structure to insert in the manuscript.**

1. Invoke [IH, Proposition 8] for equivariance of the blowup base maps and connection isomorphism. Use [KKP, §5.2.5] for the projective-bundle equivariance, together with the regular-lattice comparison [IK]. Do not cite blowup equivariance as if it alone proved projective-bundle equivariance.
2. Restrict the combined equivariant formal coordinate isomorphism and its inverse to fixed loci. Reductivity identifies the fixed tangent coordinates; divisor and unit variables survive, and the combined fixed-part Jacobian is invertible.
3. Redo the baseline reduced-source injectivity proof on these fixed coordinates. Independent divisor characters still distinguish numerical curve classes. Coefficients in the remaining fixed nondivisor directions are transported by the fixed-part coordinate isomorphism. This is the substantive fixed-base adaptation of F2, not an automatic rule about restricting injections.
4. The independent fixed unit shifts give generic separation of the occurrence spectra. Their spectral projectors commute with the group.
5. The comparison maps intertwine the representations, and Lemma 23.1 gives compatibility with continuation. In rank two, Proposition 13.1 transports the canonical lattice and discriminant. Tate suspensions disappear in the chosen target category.

Once the exact ring statements in steps 2–3 are established with the baseline completions, these steps prove the proposition. Until then, this proposition is an explicit integration gate for Theorems B–D; it is not a consequence of the finite matrix checker. No assumption about full analytic Stokes data is involved.

## 25. Hodge-valued selectors

For a nonzero discriminant label \(d\), define on the fixed base

\[
\mathscr H_{2,d}(Y)
 =\sum_{\substack{E\text{ whole primary}\\
\dim E^{\mathrm{ev}}=2,\ N_E^2=0\ne N_E\\
\delta^\sharp(E)=d}}
[E^{\mathrm{odd}}].
\]

Also define

\[
\mathscr H_3(Y)
 =\sum_{\dim E^{\mathrm{ev}}=3}[E^{\mathrm{odd}}].
\]

There is no factor of one half in the representation-valued definitions. Their dimensions recover the fixed-base parity count, not automatically the original full-even-base count.

For an unlabelled conservation theorem one may use the finite sum

\[
\mathscr H_{\mathrm{safe}}(Y)
 =\sum_{d\ne0}\mathscr H_{2,d}(Y)+\mathscr H_3(Y).
\]

Keeping the separate labels yields finer separation but is not required to recover \(H^3\) at the detected endpoints.

### Theorem 25.1 — Hodge-valued operation formulas

For each of these selectors \(\mathscr H\),

\[
\mathscr H(\operatorname{Bl}_Z Y)
 =\mathscr H(Y)+(c-1)\mathscr H(Z),
\]
\[
\mathscr H(\mathbf P_YV)
 =\operatorname{rk}(V)\mathscr H(Y).
\]

**Proof.** Apply Proposition 24.1 occurrence by occurrence. The selector is unchanged under the prescribed regular comparisons, the occurrence spectra are generically disjoint, and representation classes are additive in their direct sum. \(\square\)

### Theorem 25.2 — Surface vanishing and fourfold birational invariance

Every selector above vanishes on smooth projective varieties of dimension at most two, and is birationally invariant in dimensions three and four.

**Proof.** Use Section 18 on the fixed base. Minimal nef-canonical surfaces have one even primary factor of rank at least three. In rank three their odd cohomology is zero. Ruled surfaces give curve factors; eligible rank-two curve residues have discriminant zero. Rational surfaces have no odd part, and point blowups add rank-one even factors. Now apply weak factorization. \(\square\)

The abstract Hodge-atom theory is prior work [KKP]. The additional result being proposed is the surface-vanishing selection rule and its faithful transport with the retained canonical lattice.

## 26. Proof of Theorem B

For a Picard-rank-one Fano threefold, \(H^{\mathrm{odd}}=H^3\), and all even cohomology is algebraic. The full even bulk base therefore coincides with the Hodge-fixed even base at these endpoints.

In the five detected rank-two cases, the even primary dimensions are \(2+1+1\), with nonzero discriminant on the rank-two factor. Lemma 11.1 puts all of \(H^3\) in that factor. In the four remaining cases, the even dimensions are \(3+1\), and the same lemma puts all of \(H^3\) in the rank-three factor. Hence

\[
\mathscr H_{\mathrm{safe}}(X)=[H^3(X,\mathbf Q)]
\]

for every detected endpoint.

If \(X\times\mathbf P^1\sim Y\times\mathbf P^1\), Theorems 25.1–25.2 give

\[
2[H^3(X,\mathbf Q)]=2[H^3(Y,\mathbf Q)].
\tag{26.1}
\]

The representation category is semisimple, so its Grothendieck group is free on simple classes. Cancel the factor two. Equality of the two classes yields an isomorphism in the periodized category.

There are two final points to spell out.

**Recover the weight.** Both endpoints are pure of weight three. A nonzero Tate twist changes the weight, so no nonzero twist can identify their simple constituents. Thus the periodized isomorphism lifts to an ordinary weight-three Hodge isomorphism.

**Recover rational coefficients.** If the argument was carried out after scalar extension, the space of Hodge morphisms is the scalar extension of its rational morphism space. An isomorphism means that the determinant polynomial on this finite-dimensional rational space is not identically zero. Since \(\mathbf Q\) is infinite, it has a rational point where the determinant is nonzero. Thus the isomorphism exists over \(\mathbf Q\).

This proves Theorem B. After a common Tate twist, these are weight-one Hodge structures of the intermediate Jacobians, so the Jacobians are isogenous. \(\square\)

For cubics the labelled equality is specifically

\[
\mathscr H_{2,4/9}(X)=[H^3(X,\mathbf Q)].
\]

The theorem gives no distinguished integral lattice or principal polarization. It is not a claim that arbitrary cubic intermediate Jacobians in the same isogeny class are isomorphic.

---

<a id="part-viii"></a>

# Part VIII. Cancellation and arithmetic consequences

## 27. Generic cancellation: proof of Theorem C

Apply Theorem B to obtain an isomorphism of rational third Hodge structures. For a cubic or quartic hypersurface in \(\mathbf P^4\), this is all the middle primitive cohomology: projective space contributes no degree-three class.

The pairs \((d,n)=(3,4),(4,4)\) are outside the exceptions in [V, Theorem 0.2]. The rational formulation is explicit in [V, Remark 0.3], and the target hypersurface may be any smooth member of the same family. Rational generic Torelli therefore gives \(X\cong Y\). The reverse implication is immediate. \(\square\)

Do not replace “very general” by “general” or “every.” No integral refinement of the quantum invariant has been supplied.

### Exceptional loci

The rational Hodge-isomorphism relation is a countable union of algebraic correspondences; see [V, §1.1]. A non-diagonal component cannot dominate the source moduli space by rational generic Torelli. Its source image has proper closure. Thus nontrivial one-stable partners occur over a countable union of proper algebraic subsets.

For two smooth cubic families over an irreducible base, fibrewise one-stable birationality on a dense open and dominance of the first moduli map force their coarse moduli maps to agree. They agree at very general points and hence everywhere by separatedness.

This does not assert that an arbitrary birational map can be extended through a locally complete deformation. That is why the argument stops short of all-member cancellation.

### Optional infinitesimal illustration

For a cubic \(F\), put \(R=\mathbf C[x_0,\ldots,x_4]/(\partial F)\). The conormal of the period image is identified by the Jacobian-ring multiplication with

\[
\ker(\operatorname{Sym}^2R_1\longrightarrow R_2)
 =\left\langle\frac{\partial F}{\partial x_0},\ldots,
 \frac{\partial F}{\partial x_4}\right\rangle.
\]

This explains how infinitesimal period information recovers gradient quadrics. A sample rank computation is illustrative only; the proof uses the published generic Torelli theorem rather than extrapolation from an example.

## 28. Countability and family isotriviality

### Corollary 28.1

For a fixed smooth complex cubic \(X\), at most countably many cubic isomorphism classes \(Y\) are one-stably birational to \(X\).

**Proof.** Theorem B gives an isogeny of intermediate Jacobians. Every abelian variety isogenous to \(J(X)\) is a quotient of it by a finite subgroup after reversing an isogeny. There are countably many such subgroups. Each target has countably many principal polarizations, and cubic Torelli identifies at most one cubic for each relevant principally polarized target. \(\square\)

Consequently, a finite-type irreducible algebraic family of smooth complex cubics whose members are all one-stably birational to a fixed cubic has constant coarse moduli. Its constructible image cannot be both positive-dimensional and countable.

This is not finiteness of the full complex partner set, nor construction of a moduli quotient for one-stable birational equivalence.

## 29. Bounded-degree arithmetic finiteness: proof of Theorem D

Let \(A=J(X)\), defined over \(K\) by the arithmetic intermediate-Jacobian construction [A]. For any candidate \(Y/L\), Theorem B gives a geometric isogeny \(J(Y)\sim A\). Homomorphisms between abelian varieties over an algebraically closed base do not acquire new parameters on extending algebraically closed fields, so this is an isogeny over \(\overline K\).

By [O, Theorem 5.1], there are constants \(c(A,K)\) and \(\kappa\) such that some geometric isogeny

\[
A\longrightarrow J(Y)
\]

has degree at most

\[
c(A,K)[L:K]^\kappa\le c(A,K)D^\kappa.
\]

A fixed abelian variety has finitely many finite subgroups of bounded order. Indeed, every subgroup of order at most \(N\) lies in the torsion group annihilated by \(\operatorname{lcm}(1,\ldots,N)\). Hence there are only finitely many geometric target abelian varieties.

Each has finitely many principal polarizations up to automorphism by [NN]. Apply cubic Torelli to obtain finitely many geometric cubics. \(\square\)

Use the corrected arXiv version of Orr’s paper, which records and repairs the published proof gap through Proposition 4.A. No effective count of partners follows merely by quoting this theorem.

## 30. Potential reduction as a one-stable obstruction

For cubics over a number field, geometric one-stable birationality forces equality of the eventual semistable toric ranks of their intermediate Jacobians at every finite place.

**Proof.** Theorem B yields an isogeny over a finite extension. After a further extension with semistable reduction, the rational Tate modules are isomorphic. Their monodromy ranks, hence toric ranks, agree. In particular the loci of potentially good reduction agree. \(\square\)

Do not claim equality of conductors or Frobenius polynomials over the original field; the isogeny need not be defined there, and twists can change those data.

### A compact companion application

The sharpness/moduli papers provide the pencil

\[
X_t:(z-x)u^2+6yuv+3(z+x)v^2-z^3
 +\tfrac34(x^2+3y^2)z+t y^3=0.
\]

Their independent geometric calculation gives, for \(t=a/b\in\mathbf Q^*\) in lowest terms and primes \(p\ge5\),

\[
\rho_p(J(X_t))=
\begin{cases}
1,&p\mid a,\\
3,&p\mid(16a^2-27b^2),\\
0,&\text{otherwise}.
\end{cases}
\]

Assuming that companion calculation and the surface upper bound, distinct positive squarefree integers prime to six give products \(X_t\times\mathbf P^1\) that are pairwise nonbirational even over \(\mathbf C\), while every \(X_t\times\mathbf P^2\) is \(\mathbf Q\)-rational.

The role of this paper is precisely the implication from different potential reduction profiles to different one-stable birational classes. Put the factor decomposition, arithmetic twists, local calculations, and effective \(S\)-unit procedure in the companion, not in the proof of Theorem B.

If any finite-field illustrations are retained, use the corrected arithmetic auxiliary factors \(E_t,C_t^{(-3)},H_t^{(-6)}\). The untwisted models give the geometric isogeny decomposition, but not automatically the correct Frobenius traces over \(\mathbf Q\).

## 31. Special-pencil cancellation: a downstream statement only

The moduli paper proposes that, for a very general member of the displayed pencil, geometric isogeny of intermediate Jacobians within the pencil forces \(t'=\pm t\), hence isomorphism of cubics. It proves this through finite isogeny orbits, degeneration ranks, and the splitting field of primitive central projectors.

If that theorem is imported, Theorem B immediately gives cancellation after one stabilization within the special pencil. This is not an application of ambient generic Torelli, since the pencil is a special period locus.

Keep its status and citation explicit. Neither this pencil theorem nor the higher-dimensional moduli reconstruction is an input to the numerical Fano classification or Hodge conservation.

---

<a id="part-ix"></a>

# Part IX. Additional reuse, limitations, and placement

## 32. A general odd-excess filter

For a whole primary factor, write \((r,s)\) for its even and odd dimensions. No smooth projective surface has a generic primary factor with

\[
r\ge3,\qquad s>r.
\]

For minimal surfaces with nef canonical divisor there is one primary factor and

\[
r-s=\chi_{\mathrm{top}}(S)=c_2(S)\ge0.
\]

Use the classification or Chern-number inequalities for the final inequality. Ruled surfaces contribute curve factors with even rank at most two, and point blowups add \((1,0)\).

Thus counting factors satisfying \(r\ge3,s>r\), or retaining their free \((r,s)\)-spectrum, gives another surface-vanishing selector. It uses the same comparison contract but no residue computation.

This is a test for new threefolds, not a classification of all 105 Fano deformation families. Multivariable Novikov genericity must be checked independently in higher Picard rank. Setting all curve variables equal is not a valid substitute.

## 33. Non-cylindricity and affine cones

Every detected threefold is irrational and hence has no open cylinder \(Z\times\mathbf A^1\).

One way to see the implication is to take a smooth projective model of the surface \(Z\). The rationally connected Fano threefold dominates it, so it is rationally connected and therefore a rational complex surface. The cylinder would then make the threefold rational. The standard cylinder criterion is also recalled in [Vir].

For a projectively normal ample embedding, the established cylinder/additive-action correspondence consequently excludes a nontrivial \(\mathbf G_a\)-action on the corresponding affine cone; its coordinate ring has no nonzero locally nilpotent derivation. State the embedding and normality conditions, and cite the correspondence. This is an application of the all-member irrationality statement, not a new cone theorem.

## 34. Why this architecture cannot detect two stabilizations

### Proposition 34.1

Let \(J\) be an abelian-group-valued invariant satisfying

\[
J(\operatorname{Bl}_Z Y)=J(Y)+(c-1)J(Z).
\]

If it is birationally invariant in dimension \(n+2\), then \(J(X)=0\) for every smooth projective \(n\)-fold \(X\).

**Proof.** Blow up \(X\times\mathbf P^2\) along \(X\times\{p\}\), a codimension-two center. Birational invariance gives equality of the values before and after the blowup, while the formula gives their difference as \(J(X)\). \(\square\)

No projective-bundle formula is needed for this limitation. Increasing the set of block types while keeping this globally blowup-additive structure cannot evade it.

This proposition belongs in the main paper: it explains the exact dimensional boundary and prevents the higher-rank appendix from being misread as a route to arbitrary stabilization levels.

## 35. The integral boundary

The current conclusion is a rational Hodge isomorphism. Two separate tasks would be needed for an integral enhancement:

1. Produce a saturated integral object for the selected odd sectors that survives the actual comparison maps.
2. Prove object-level cancellation; an equality of classes in an integral Grothendieck group is not automatically an isomorphism of integral Hodge structures.

Even \(QH(\mathbf P^1)\) has individual spectral projectors

\[
\frac12\left(1\pm\frac h{\sqrt q}\right),
\]

so integral projectors cannot be presumed term by term.

Preserving a rational pairing is also insufficient in general. A cyclic degree-four isogeny of nonisomorphic elliptic curves becomes a rational symplectic Hodge isometry after division by two; its matrix can be \(\operatorname{diag}(2,1/2)\). It does not preserve the integral lattice.

The generic cancellation theorem instead uses the geometry of the hypersurface period locus to rule out alternative rational-Hodge partners. Do not represent it as proof that the quantum invariant already recovers an integral polarized lattice.

---

<a id="appendix-i"></a>

# Appendix I. Corrected rank-three lattice — independent extension

**Placement and status.** This is an optional technical appendix. The Fano classification uses parity for all four rank-three cases and does not need this construction. The finite gauge and flatness identities have been checked. The normalization, functoriality, and formal-induction arguments remain mathematical proofs to audit. General framing theory has substantial precedents [FHYZZ]; do not claim a first general framing theorem.

## I.1 First-order correction

For a separated cyclic rank-three block, choose a regular Jordan frame

\[
N=E_{12}+E_{23},
\qquad
z^2\partial_z y=(N+zA_0+z^2A_1+z^3A_2+\cdots)y.
\]

Pairing horizontality implies

\[
\operatorname{tr}(NA_0)=\operatorname{tr}(N^2A_0)=0.
\]

Indeed, the leading pairing makes \(N\) self-adjoint. The next pairing equation expresses the self-adjoint part of \(A_0\) as a commutator with \(N\). Multiplying by \(N^k\) and taking trace annihilates the commutator. Thus

\[
(A_0)_{31}=0,\qquad(A_0)_{32}=-(A_0)_{21}.
\]

Put

\[
H=-(A_0)_{21}E_{31},\qquad G=I+zH.
\]

Since \(H^2=HNH=0\), the transformed coefficients are

\[
A'_0=A_0+[N,H],
\]
\[
A'_1=A_1+[A_0,H]-H,
\]
\[
A'_2=A_2+[A_1,H]-HA_0H.
\]

The matrix \(A'_0\) is upper triangular. After \(S=\operatorname{diag}(1,z,z^2)\), the equation becomes

\[
z\partial_z y=(fE_{31}/z+R+O(z))y,
\]

where

\[
f=(A'_1)_{31},
\qquad
R=
\begin{pmatrix}
(A'_0)_{11}&1&0\\
(A'_1)_{21}&(A'_0)_{22}-1&1\\
(A'_2)_{31}&(A'_1)_{32}&(A'_0)_{33}-2
\end{pmatrix}.
\]

Thus \(f=0\) is the exact remaining regular-singularity condition for the corrected lattice. The naive modification without the first-order correction can fail; the earlier counterexample to it remains valid.

## I.2 Independence of the normalized frame

Suppose two normalized frames have the same \(N=J_3\) and upper-triangular \(A_0\). For a regular comparison \(G_0+zG_1+\cdots\), the leading term commutes with \(J_3\), hence is upper triangular. The two lower entries in the order-\(z\) comparison identity give \((G_1)_{31}=0\).

These are exactly the possible negative-power entries in \(S^{-1}GS\). The transformed comparison and its inverse are therefore regular. The corrected lattice is independent of the normalized frame and is preserved by the allowed regular comparisons. If \(f=0\), reduction gives conjugate residues, up to the common scalar shifts already recorded in the comparison convention.

## I.3 Persistence of the scalar obstruction

Use Proposition 12.1 to keep \(N=J_3\) over the formal bulk germ. A trace-zero leading base coefficient is \(q_1N+q_2N^2\). Constant-\(N\) flatness, together with upper-triangular \(A_0\), forces the next base coefficient to have zero \((3,1)\)-entry.

After shearing, the base equation is

\[
\partial y=(K/z+B+O(z))y,
\]

where \(K\) is strictly lower triangular. Write

\[
R=\begin{pmatrix}a&1&0\\b&c&1\\d&e&h\end{pmatrix},
\qquad K=xE_{21}+yE_{31}+z_0E_{32}.
\]

The coefficient of \(z^{-1}\) in flatness is

\[
(\partial f)E_{31}=-K+[K,R]+f[B,E_{31}].
\]

Its diagonal and \((2,1)\)-entries give

\[
x=z_0=fB_{13},
\qquad
 y=f\bigl((a-c-1)B_{13}+B_{23}\bigr).
\]

The \((3,1)\)-entry is

\[
\partial f=f\left[
(a-h-1)\bigl((a-c-1)B_{13}+B_{23}\bigr)
+(b-e)B_{13}+B_{33}-B_{11}
\right].
\]

Hence \(f=0\) persists from the initial point by formal coefficient uniqueness. Then \(K=0\), and the constant flatness equation becomes \(\partial R=[B,R]\). The residue characteristic polynomial is constant without a nonresonance assumption.

## I.4 Values and surface vanishing

| Index-one genus | Residue eigenvalues | Characteristic polynomial after subtracting the mean |
|---|---|---|
| 2 | \(-4/3,-1,-2/3\) | \(t(t^2-1/9)\) |
| 3 | \(-5/4,-1,-3/4\) | \(t(t^2-1/16)\) |
| 4 | \(-7/6,-1,-5/6\) | \(t(t^2-1/36)\) |
| 5 | \(-1,-1,-1\) | \(t^3\) |

In all four cases the scalar pole obstruction is zero.

To use the nontrivial centered-polynomial selector birationally, prove its surface vanishing separately. Only a minimal nef-canonical surface with \(b_2=1\) can supply a whole even rank-three factor. If it is cyclic, its centered Euler product is classical: when \(c_1\) is a nonzero multiple of the ample generator, all nonzero effective curve classes have \(c_1\cdot\beta<0\), and the degree/string constraints exclude the relevant quantum corrections; when \(c_1\) is numerically zero, the remaining point term is not cyclic of rank three. In the cyclic case the degree flag and grading \((-1,0,1)\) give modified diagonal \((-1,-1,-1)\). Thus its centered residue polynomial is \(t^3\).

Rational surfaces, ruled surfaces, and point blowups are handled as before. The selector therefore independently detects genera two, three, and four. Genus five remains invisible to this eigenvalue test but is detected by \(\mathcal O_3\).

No arbitrary-rank corrected-lattice theorem follows from this rank-three calculation.

---

<a id="appendix-ii"></a>

# Appendix II. Odd-dimensional cubics and higher-dimensional limits

Let \(X_n\subset\mathbf P^{n+1}\) be a smooth cubic, with \(n\ge3\) odd. Its full even cohomology is ambient. In the basis \(e_i=h^i\), Beauville’s hyperplane multiplication matrix \(H\) has subdiagonal entries one and additional entries

\[
H_{0,n-2}=6q,\qquad H_{1,n-1}=15q,\qquad H_{2,n}=6q.
\]

For \(n=3\), also \(H_{0,3}=36q^2\). There are no quadratic-\(q\) terms for \(n\ge5\), by degree. Set \(k=n-1\), \(U=kH\), and \(D_{ii}=n/2-i\). The input formulas are [B].

Then

\[
\det(tI-H)=t^2(t^{n-1}-27q),
\qquad
\boxed{\delta^\sharp(X_n)=\frac{(n-1)^2}{9}.}
\]

### Uniform proof

The case \(n=3\) is the cubic calculation. For \(n\ge5\), put

\[
u=e_n-6qe_1,\qquad v=e_{n-1}-21qe_0.
\]

Here the symbol \(u\) is a basis vector, not the Novikov variable. Direct multiplication gives \(Hu=0\), \(Hv=u\), and

\[
P=1-\frac{H^{n-1}}{27q},
\]

with

\[
Pe_0=-\frac v{27q},\quad Pe_1=-\frac u{27q},
\quad Pe_{n-1}=\frac29v,\quad Pe_n=\frac79u.
\]

The block of \(PDP\) in \((u,v)\) is

\[
\operatorname{diag}\left(-\frac{5n+4}{18},\frac{5n+4}{18}\right).
\]

Thus \(\kappa=-(5n+4)/9\), and the reduced inverse for \(U\) is

\[
T=\frac{H^{n-2}}{27kq}.
\]

Sparse path multiplication also gives

\[
H^{n-2}Du=-6kq(e_{n-1}+6qe_0),
\qquad
\operatorname{tr}(NDTD)=\frac{4k^2}{81}.
\]

Formula (14.1) yields

\[
\delta^\sharp=\frac{25k^2}{81}-\frac{16k^2}{81}
=\frac{k^2}{9}.
\]

An explicit residue is

\[
R_n=
\begin{pmatrix}
-(5n+4)/18&n-1\\
-4(n-1)/81&(5n-14)/18
\end{pmatrix},
\]

with eigenvalues \(-1/2\pm(n-1)/6\). Persistence gives the generic even-bulk value. Hence

\[
\mathfrak S_{\mathrm{lat}}(X_n)=e_{(n-1)^2/9}.
\]

The exponent count vanishes when \(n\equiv1\pmod3\), while the lattice count is always one.

### What this implies

The spectrum is not generally birationally invariant above dimension four. This calculation does **not** prove irrationality of all odd-dimensional cubics.

It does restrict a proposed weak factorization of \(X_n\dashrightarrow\mathbf P^n\): at least one center must carry the label \((n-1)^2/9\). In dimension five, such a center has dimension at most three, so any factorization rationalizing a cubic fivefold must include a threefold with nonzero \(e_{16/9}\)-component. That center itself remains irrational after one stabilization.

For another use, embed \(X_n\) in \(\mathbf P^{n+2}\) and blow it up. These rational varieties have pairwise distinct spectra as \(n\) varies through odd dimensions. The resulting classes span a split free abelian subgroup of infinite rank in \(K_0(\mathrm{Var}_{\mathbf C})/(\mathbb L-1)\), using the spectral coordinate projections. This illustrates the infinite image of the invariant, not higher-dimensional birational invariance.

---

<a id="appendix-iii"></a>

# Appendix III. Separation beyond rational Chow motives

All motives here have rational coefficients. No integral, polarized, or algebra-object motive isomorphism is asserted.

Let \(X\) be the Fermat cubic threefold and \(E\) the Fermat elliptic curve. The known isogeny \(J(X)\sim E^5\), together with the Fano-threefold motive decomposition, gives

\[
h(X)\cong
\mathbf1\oplus\mathbb L\oplus\mathbb L^2\oplus\mathbb L^3
\oplus\bigl(h^1(E)\otimes\mathbb L\bigr)^{\oplus5}.
\]

Use [GG] for the motive decomposition and [Har, Remark 23 and its references] for the Fermat isogeny. Check the published corrigendum to [GG] when importing its integral auxiliary statements; only the rational motive decomposition is used here.

Choose five distinct points of \(X\) and five disjoint plane-cubic copies \(E_i\subset\mathbf P^3\). The latter exist by general projective translates: two general curves in \(\mathbf P^3\) are disjoint. Set

\[
X'=\operatorname{Bl}_{p_1,\ldots,p_5}X,
\qquad
Y=\operatorname{Bl}_{E_1\sqcup\cdots\sqcup E_5}\mathbf P^3.
\]

A point blowup adds \(\mathbb L\oplus\mathbb L^2\); an elliptic-curve blowup adds

\[
\mathbb L\oplus h^1(E)\otimes\mathbb L\oplus\mathbb L^2.
\]

Therefore

\[
h(X')\cong h(Y)\cong
\mathbf1\oplus\mathbb L^{\oplus6}\oplus(\mathbb L^2)^{\oplus6}
\oplus\mathbb L^3
\oplus\bigl(h^1(E)\otimes\mathbb L\bigr)^{\oplus5}.
\]

But \(Y\) is rational and

\[
\mathfrak S_{\mathrm{lat}}(X')=e_{4/9},
\qquad
\mathfrak S_{\mathrm{lat}}(Y)=0.
\]

Thus \(X'\times\mathbf P^1\) is irrational. This uses the original scalar theorem, not the Hodge-valued upgrade or the moduli paper.

If \(\Delta=[X']-[Y]\), its rational Chow-motive realization vanishes while its lattice spectrum is \(e_{4/9}\). The additive extension factors through \(\mathbb L=1\), giving

\[
\mathbb L^a\Delta\ne0\quad(a\ge0),
\qquad
P(\mathbb L)\Delta=0\Longrightarrow P(1)=0.
\]

This does not require the spectrum to be multiplicative. The general distinction between rational motives and \(\mathbb L\)-equivalence has prior examples [Huy]; the contribution is the explicit threefold pair and its one-stabilization separation.

Universal \(CH_0\)-triviality can be appended if the precise Fermat theorem already used in the baseline is retained and cited. It is not needed for the motive or one-stabilization argument above.

---

<a id="part-x"></a>

# Part X. Concrete manuscript edits and framing

## 36. Changes against `b156ec6`

### `sections/01-introduction.tex`

**Replace the cubic-only lead with the full classification, then immediately give the cubic as the motivating case.** Retain `thm:every-cubic` as a named corollary or compatible label for existing cross-references.

**Replace the global statement that the invariant uses no Hodge structure.** It remains true of the numerical part, but false of the upgraded paper. Suggested wording:

> The numerical obstruction forgets the Hodge structure and uses only whole-primary ranks, parity, and a canonical rank-two residue. A second construction retains the odd Hodge representation of the same surface-vanishing factors. This refinement turns the obstruction into a conservation theorem for rational third cohomology.

**Explain the surface issue before the machinery.** Suggested paragraph:

> A blowup of a fourfold along a surface can contribute the surface’s odd cohomology in precisely the degrees in which a stabilized threefold carries its intermediate Jacobian. We therefore do not try to preserve all third cohomology under fourfold birational maps. Instead we retain only the odd cohomology attached to quantum primary factors that no surface can supply. The selection, rather than cohomology alone, is the obstruction.

**State the method’s relation to prior work accurately.** Suggested paragraph:

> The construction uses the quantum decomposition theorems of Iritani and Iritani–Koto and the equivariant Hodge-atom framework of Katzarkov–Kontsevich–Pantev–Yu. The additional ingredients are a faithful center comparison on the required reduced coefficient domains, a canonical-lattice residue test, and a mixed-parity restriction excluding all complex surface centers. These restrictions are what permit one stabilization. The Hodge-valued version retains the selected odd representation instead of only its dimension.

**Separate quantifiers.** “Every smooth member after one stabilization” and “a very general member after arbitrary stabilization” are different claims. Neither contains the other in full. Do not present the classification as a classification of stable rationality.

### `sections/02-qdm-marker.tex`

Replace the single setup paragraph restricting to even cohomology with the three-row convention table in Section 9. Keep the even restriction for the scalar invariant; do not silently change the meaning of old block ranks.

Retain `prop:generic-spectral-connection-splitting`, `lem:A0preserve`, and the canonical modification. Generalize the cyclic-persistence lemma using the full trace calculation in Section 12, while keeping the rank-two residue-rigidity proposition separate.

Keep `lem:faithful-center-base-change` central. Add explicit parity and Hodge-fixed-base variants adjacent to it. Do not bury the new fixed-base injection statement in an application proof.

Promote the basis-free formula to a labelled proposition immediately after the rank-two lattice theorem. Retain `prop:universal-rank-two-residue` as an example. Add GM as the next worked application.

Move the abstract additive monoid language after the concrete operation formula, or compress it into Proposition 19.1.

### `sections/03-applications.tex`

Upgrade the threefold criterion from a positive exponent count to a positive lattice count or positive odd-rank-three contribution. The exponent criterion remains an immediate special case.

Replace the index-two classification as the final classification theorem with Theorem A. Preserve the old index-two statement as a corollary for continuity of references. Include all seventeen rows and the rational zero controls.

Add a separate section for Hodge conservation; do not insert it as a paragraph that merely says the scalar proof is equivariant. It requires the fixed-base definitions and Proposition 24.1.

State generic cancellation as a corollary of Hodge conservation and [V], not as a new Torelli theorem. Keep countability distinct from arithmetic finiteness.

### `sections/04-motivic.tex`

Retain the additive, not multiplicative, nature of the Grothendieck-ring maps. The quotient \((\mathbb L-1)\) is not the stable-birational quotient \((\mathbb L)\).

Put the dimensional ceiling before any higher-dimensional examples. If the odd-dimensional cubic and rational-motive applications make the paper too long, move their proofs to an appendix rather than weakening the main comparison discussion.

The rank-three correction belongs in its own appendix. It repairs the naive modification but is not a premise of the Fano classification. Preserve the old counterexample to the naive argument as motivation.

### Verification and reviewer documentation

Update the reviewer guide to contain a theorem dependency table, including Hodge-fixed-base gates. Add new statements to the formalization-coverage file as absent, fragmentary, or conditional exactly as the code supports. A numerical script result is not a Lean proof of the geometric application.

Use distinct labels for the numerical classification, the Hodge conservation theorem, generic cancellation, and companion-dependent pencil statements. This prevents an accidental circular reference between the three papers.

## 37. What to leave out of the main narrative

Do not make the core paper depend on the type-\(I_3\) cubic locus, its degree-forty/ten/four maps, the period-gluing theorem, the generic quaternion obstruction, or essential dimension. Those are independent subjects for the moduli paper.

Do not include a Navier–Stokes application claim. It is not involved in these proofs.

Do not advertise a rationality algorithm. The finite-jet routine is a proof-producing obstruction test; a zero output can mean that the test is blind.

Do not claim all-member cancellation, integral Hodge conservation, effective complex isogeny bounds, or invariance after two stabilizations. The packet explicitly stops short of each.

## 38. Recommended integration order

1. Freeze and audit the baseline comparison contract, especially the reduced center ring and regular original lattices.
2. Add the full-super parity statement, cyclic persistence, and surface lemma. Integrate Theorem A and its complete matrix table.
3. Add the Hodge-fixed base as a separate construction; prove Proposition 24.1 and the representation target/cancellation argument. Only then promote Theorem B to the introduction.
4. Add the short Torelli and arithmetic corollaries with exact external hypotheses.
5. Add optional technical appendices after the principal argument is stable. Keep the corrected rank-three construction outside the proof path for Theorems A–D.
6. Finally update title, abstract, theorem numbering, external cross-references, and verification coverage.

This order yields a complete numerical paper even if the Hodge adaptation needs more work, and a complete Hodge paper even if the rank-three appendix is deferred.

---

<a id="part-xi"></a>

# Part XI. Literature and attribution ledger

## 39. Claims of novelty to use and avoid

| Subject | Appropriate framing | Avoid |
|---|---|---|
| Seventeen small spectra | Published quantum input, independently checked here | A new enumeration of Fano quantum spectra |
| Cyclic persistence | A formal trace proof adapted to this comparison problem | Discovery of nilpotent persistence |
| Quartic rank-three block | Use of odd cohomology to exclude complex surface centers | First quantum irrationality argument for quartics |
| Hodge-labelled factors | Surface-vanishing filters inside the existing Hodge-atom framework | Invention of Hodge atoms or universal Hodge equivariance |
| Cubic and quartic cancellation | New one-stabilization application of rational generic Torelli | A new general Torelli theorem |
| Arithmetic finiteness | Consequence of HC plus established isogeny and polarization finiteness | A new Masser–Wüstholz bound |
| Motive example | A specific one-stabilization separation for threefolds | First failure of rational motives to determine \(\mathbb L\)-equivalence |
| Cone rigidity | Application of all-member irrationality through the cylinder correspondence | A new equivalence between cylinders and additive actions |

The targeted source check supports the theorem statements used here. It does not certify priority for the combined construction. Before submission, compare the corrected rank-three lattice with the framing literature and the representation-valued selectors with the precise equivalence relation used for Hodge atoms.

## 40. Bibliography with exact roles

**[M1]** Tavis Rudd, *Irrationality of Cubic Threefolds after One Stabilization*, revision `b156ec6`. Original coefficient comparison, rank-two lattice construction, surface vanishing, and additive extension.  
https://github.com/tavisrudd/cubic-stabilization-m1/tree/b156ec6

**[I]** Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3. Theorem 5.18; graded completions; reduced-source and center-image rings; full supermodule conventions.  
https://arxiv.org/html/2307.13555v3

**[IK]** Hiroshi Iritani and Yuki Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4. Theorem 5.1 and the regular projective-bundle comparison.  
https://arxiv.org/html/2307.03696v4

**[IH]** Hiroshi Iritani, *Notes on the decomposition theorem for blowups*, arXiv:2604.10028v2. Proposition 8 proves universal-Hodge-group equivariance of the formal maps and comparison.  
https://arxiv.org/html/2604.10028v2

**[KKP]** Ludmil Katzarkov, Maxim Kontsevich, Tony Pantev, and Tony Yue Yu, *Birational invariants from Hodge structures and quantum multiplication*, arXiv:2508.05105v2. §§5.2–5.4 for fixed bases, representations, and equivariant operations; the general Hodge-atom framework is prior work.  
https://arxiv.org/html/2508.05105v2

**[G]** Vasily Golyshev, *Classification problems and mirror duality*, arXiv:math/0510287. Counting-matrix tables and their conventions; distinguish predictions in the original account from subsequent proofs of the inputs.  
https://arxiv.org/html/math/0510287

**[P68]** Victor Przyjalkowski, *Gromov–Witten invariants of Fano threefolds of genera 6 and 8*, arXiv:math/0410327v4. Theorem 6.1.1 and counting-matrix normalization.  
https://arxiv.org/html/math/0410327v4

**[PW]** Victor Przyjalkowski, *Quantum cohomology of smooth complete intersections in weighted projective spaces and singular toric varieties*, arXiv:math/0507232. Degree-one and degree-two index-two inputs and weighted models.  
https://arxiv.org/html/math/0507232

**[NAB]** Christian Böhning, Hans-Christian Graf von Bothmer, and Zac Su’a, *Naive atoms of blowups: examples*, arXiv:2606.17884. Section 10 tabulates the seventeen small characteristic polynomials and explains their provenance.  
https://arxiv.org/html/2606.17884

**[CQ]** Jiaji Cai, *The quartic threefold is symplectically irrational*, arXiv:2605.29143. Prior rank-three and persistence argument. Its symplectic threefold-center analysis is not the complex-surface-center statement used here.  
https://arxiv.org/html/2605.29143

**[CC]** Jiaji Cai, *The cubic threefold is symplectically irrational*, arXiv:2608.01577v1. Independent cubic exponent calculation and formal-monodromy obstruction.  
https://arxiv.org/html/2608.01577v1

**[KP]** Alexander Kuznetsov and Yuri Prokhorov, *Rationality of Fano threefolds over non-closed fields*, arXiv:1911.08949v3. §1.1 lists the eight geometrically rational families and distinguishes arithmetic rationality of their forms.  
https://arxiv.org/html/1911.08949v3

**[HT]** Brendan Hassett and Yuri Tschinkel, *On stable rationality of Fano threefolds and del Pezzo fibrations*, arXiv:1601.07074. Very-general stable irrationality and the Fano Hodge-number list. Its quantifier differs from the all-member one-stabilization theorem.  
https://arxiv.org/html/1601.07074v1

**[Deb]** Olivier Debarre, *Gushel–Mukai varieties*, arXiv:2001.03485v2. Ordinary/special models, cohomology, and moduli/deformation background.  
https://arxiv.org/html/2001.03485v2

**[B]** Arnaud Beauville, *Quantum cohomology of complete intersections*, arXiv:alg-geom/9501008. Hyperplane multiplication formulas used in the odd-dimensional cubic calculation.  
https://arxiv.org/html/alg-geom/9501008

**[DH]** Liana David and Claus Hertling, *Regular F-manifolds: initial conditions and Frobenius metrics*, arXiv:1411.4553. Prior regular/cyclic multiplication theory.  
https://arxiv.org/html/1411.4553

**[FHYZZ]** Thorgal Hinault, Tony Yue Yu, Chi Zhang, and Shaowu Zhang, *Decomposition and framing of F-bundles and applications to quantum cohomology*, arXiv:2411.02266. General decomposition and framing context.  
https://arxiv.org/html/2411.02266v1

**[V]** Claire Voisin, *Schiffer variations and the generic Torelli theorem for hypersurfaces*, arXiv:2004.09310v3. Theorem 0.2 and Remarks 0.1, 0.3 give precisely the rational generic Torelli formulation used in Theorem C.  
https://arxiv.org/html/2004.09310v3

**[O]** Martin Orr, *Families of abelian varieties with many isogenous fibres*, arXiv:1209.3653v4. Theorem 5.1 is the bounded-degree isogeny input. The corrected arXiv text includes Proposition 4.A repairing a gap in the published version.  
https://arxiv.org/html/1209.3653v4

**[A]** Jeffrey Achter, *Arithmetic Torelli maps for cubic surfaces and threefolds*, arXiv:1005.2131v4. Arithmetic intermediate Jacobians and smooth-family compatibility.  
https://arxiv.org/html/1005.2131v4

**[NN]** M. S. Narasimhan and M. V. Nori, *Polarisations on an abelian variety*, Proceedings of the Indian Academy of Sciences, Mathematical Sciences 90 (1981), 125–128. Finiteness of principal polarizations up to automorphism. The result is recalled in *Counting polarizations on abelian varieties with group action*, arXiv:2412.01676.  
https://arxiv.org/html/2412.01676v1

**[GG]** Sergey Gorchinskiy and Vladimir Guletskiĭ, *Motives and representability of algebraic cycles on threefolds over a field*, arXiv:0806.0173v3. Theorems 8 and 15 and the rational motive decomposition. Consult the published corrigendum when using any integral auxiliary assertion.  
https://arxiv.org/html/0806.0173v3

**[Har]** Moritz Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds*, Mathematische Zeitschrift, DOI 10.1007/s00209-025-03745-3. Remark 23 and its references for the Fermat intermediate-Jacobian isogeny.  
https://doi.org/10.1007/s00209-025-03745-3

**[Huy]** Daniel Huybrechts, *Motives of isogenous K3 surfaces*, arXiv:1705.04063. Prior context for the distinction between rational Chow motives and \(\mathbb L\)-equivalence.  
https://arxiv.org/html/1705.04063v4

**[Vir]** Nikita Virin, *Cylinders in Fano threefolds of genus 9 and 10*, arXiv:2605.30875. The introduction recalls the cylinder and additive-action statements used in Section 33.  
https://arxiv.org/html/2605.30875

**[WF]** Dan Abramovich, Kalle Karu, Kenji Matsuki, and Jarosław Włodarczyk, *Torification and factorization of birational maps*, Journal of the American Mathematical Society 15 (2002), 531–572. Projective weak factorization. Use the precise form already cited in the baseline.

**[Bit]** Franziska Bittner, *The universal Euler characteristic for varieties of characteristic zero*, Compositio Mathematica 140 (2004), 1011–1032. Additive extension from the blowup presentation of the Grothendieck group.

For the nine all-member statements, retain an explicit source for connected smooth deformation of the relevant geometric families. This is not supplied solely by the characteristic-polynomial table.

---

<a id="part-xii"></a>

# Part XII. Verification handoff

## 41. What was rerun for this packet

Two existing exact scripts were rerun successfully:

- `fano_reuse_checks.py`: all seventeen matrices and cyclicity, nine rank-two residues including zero controls, the four corrected rank-three residues, nonconstant-gauge tests, and the scalar-pole flatness identity.
- `reuse_checks.py`: independent rank-two Sylvester checks, the full Novikov-dependent GM/genus-eight formulas, nonconstant gauge tests, and the odd-cubic projector identities in the recorded dimensions.

The first script is embedded below so that this Markdown packet can be used without recovering an older bundle. The tables in Section 20 were generated from its current output. The arbitrary-dimensional proof is written in Appendix II; testing finitely many dimensions is not its proof.

The following were not performed during consolidation: a Lean kernel replay; a rebuild of the original repository; an independent proof audit of the comparison theorems; a fresh replay of every arithmetic/moduli script; or an exhaustive priority search.

## 42. Extraction and execution

Save the Python block in Appendix IV as `verify_m1_upgrade.py`, then run:

```sh
python -m pip install sympy==1.14.0
python verify_m1_upgrade.py
```

It writes `verify_m1_upgrade.json` next to itself. Run without Python’s `-O` option, since the checks use assertions.

The fixed input tables and the expected output values are explicitly present. The independent invariant calculation, projector identities, and gauge tests provide algebraic checks; the program does not infer that these matrices are the QDM of a variety or prove the comparison theorem.

## 43. Pre-submission release checklist

- [ ] Every operation formula specifies the coefficient base and retained module.
- [ ] The full-super extension is proved, not inferred from the even-only theorem.
- [ ] The Hodge-fixed source map is shown faithful directly; no invalid restriction-of-injections shortcut remains.
- [ ] Original and canonical modified lattices are tracked, with regular inverses.
- [ ] Independent occurrence-unit variables establish generic nonmerger.
- [ ] “Whole primary factor” is used consistently; no Jordan subblock has been counted as an atom.
- [ ] Every Fano input is attributed and its scalar/Novikov normalization displayed.
- [ ] Smooth-deformation coverage includes every claimed special member.
- [ ] Numerical Theorem A is independent of Hodge Proposition 24.1 and Appendix I.
- [ ] Theorem B specifies rational, unpolarized Hodge structures and the cancellation category.
- [ ] Theorem C uses “very general” and an arbitrary smooth target of the same hypersurface type.
- [ ] Theorem D counts geometric classes and cites the corrected isogeny theorem.
- [ ] Companion-dependent consequences are labelled as such and do not enter the core proof.
- [ ] The abstract matches the proof stage actually reached.
- [ ] Verification coverage distinguishes finite algebra, written geometry, and formal proofs.

The packet supplies a consolidated argument and concrete obligations. It must not turn provisional integration steps into established theorems merely by removing their labels.


---

<a id="appendix-iv"></a>

# Appendix IV. Standalone finite checker

This is the exact `fano_reuse_checks.py` used to generate the finite tables. It uses SymPy 1.14.0 and writes a JSON report beside the extracted script. Its assertions check finite algebra; the source identifications and geometric comparison results are outside its scope.

Source SHA-256: `b9a5df0bad96e351a8db278350f5fc1edc5345960f70c1bff1d63a339aecbda9`.

```python
from __future__ import annotations

import json
from pathlib import Path

import sympy as sp

def matrix_polynomial(poly: sp.Poly, matrix: sp.Matrix) -> sp.Matrix:
    result = sp.zeros(matrix.rows)
    for coefficient in poly.all_coeffs():
        result = result * matrix + coefficient * sp.eye(matrix.rows)
    return result.applyfunc(sp.cancel)

def rank_two_discriminant(
    leading: sp.Matrix,
    regular: sp.Matrix,
    eigenvalue: sp.Expr,
    next_coefficient: sp.Matrix | None = None,
) -> dict:
    n = leading.rows
    if leading.cols != n or regular.shape != (n, n):
        raise ValueError("The connection coefficients must be square of equal size.")
    correction = sp.zeros(n) if next_coefficient is None else next_coefficient
    t = sp.Symbol("t")
    centered = leading - eigenvalue * sp.eye(n)
    characteristic = sp.Poly(centered.charpoly(t).as_expr(), t)
    quotient, remainder = sp.div(characteristic, sp.Poly(t**2, t))
    if not remainder.is_zero or quotient.eval(0) == 0:
        raise ValueError("The chosen eigenvalue must have algebraic multiplicity exactly two.")
    inverse = sp.invert(quotient, sp.Poly(t**2, t))
    projector = matrix_polynomial(quotient * inverse, centered)
    complement = sp.eye(n) - projector
    nilpotent = (centered * projector).applyfunc(sp.cancel)
    assert projector**2 == projector
    assert projector.rank() == 2
    assert nilpotent.rank() == 1 and nilpotent**2 == sp.zeros(n)
    reduced_inverse = ((centered + projector).inv() * complement).applyfunc(sp.cancel)
    assert (centered * reduced_inverse - complement).applyfunc(sp.cancel) == sp.zeros(n)
    assert (reduced_inverse * projector).applyfunc(sp.cancel) == sp.zeros(n)
    block_regular = projector * regular * projector
    commutator = block_regular * nilpotent - nilpotent * block_regular
    i, j = next((i, j) for i in range(n) for j in range(n) if nilpotent[i, j] != 0)
    kappa = sp.cancel(commutator[i, j] / nilpotent[i, j])
    assert (commutator - kappa * nilpotent).applyfunc(sp.cancel) == sp.zeros(n)
    off_diagonal_trace = sp.cancel(sp.trace(nilpotent * regular * reduced_inverse * regular))
    correction_trace = sp.cancel(sp.trace(nilpotent * correction))
    delta = sp.factor((kappa + 1)**2 + 4 * correction_trace - 4 * off_diagonal_trace)
    return {
        "characteristic": sp.factor(leading.charpoly(t).as_expr()),
        "kappa": kappa,
        "off_diagonal_trace": off_diagonal_trace,
        "correction_trace": correction_trace,
        "delta": delta,
    }

DATA = {
    'g2': (120, 744, 137520, 650016, 119681280, 21690374400),
    'g3': (24, 104, 3888, 13600, 504576, 18323712),
    'g4': (12, 42, 792, 2340, 43632, 793152),
    'g5': (8, 24, 304, 800, 9984, 121088),
    'g6': (6, 16, 156, 380, 3600, 33120),
    'g7': (5, 12, 96, 216, 1692, 12816),
    'g8': (4, 9, 64, 140, 924, 5936),
    'g9': (4, 8, 48, 96, 576, 3328),
    'g10': (3, 6, 36, 72, 378, 1944),
    'g12': (sp.Rational(12, 5), sp.Rational(22, 5), 24, 44, 198, 880),
    'd1': (0, 0, 240, 1248, 0, 57600),
    'd2': (0, 0, 48, 160, 0, 2304),
    'd3': (0, 0, 24, 60, 0, 576),
    'd4': (0, 0, 16, 32, 0, 256),
    'd5': (0, 0, 12, 20, 0, 160),
    'quadric': (0, 0, 0, 0, 54, 0),
    'projective_space': (0, 0, 0, 0, 0, 256),
}
H21 = {'g2': 52, 'g3': 30, 'g4': 20, 'g5': 14, 'g6': 10,
       'g7': 7, 'g8': 5, 'g9': 3, 'g10': 2, 'g12': 0,
       'd1': 21, 'd2': 10, 'd3': 5, 'd4': 2, 'd5': 0,
       'quadric': 0, 'projective_space': 0}
EXPECTED_DELTA = {'g6': 1, 'g7': 0, 'g8': sp.Rational(4, 9),
                  'g9': 0, 'g10': 0, 'd1': sp.Rational(16, 9),
                  'd2': 1, 'd3': sp.Rational(4, 9), 'd4': 0}


def quantum_matrix(values: tuple) -> sp.Matrix:
    a, b, c, d, e, f = values
    return sp.Matrix([[a, c, e, f], [1, b, d, e],
                      [0, 1, b, c], [0, 0, 1, a]])


def cross_gauge(leading: sp.Matrix, source: sp.Matrix, split: int) -> sp.Matrix:
    locations = [(i, j) for i in range(leading.rows) for j in range(leading.cols)
                 if (i < split) != (j < split)]
    unknowns = sp.symbols(f'x:{len(locations)}')
    gauge = sp.zeros(leading.rows)
    for location, unknown in zip(locations, unknowns):
        gauge[location] = unknown
    equation = leading * gauge - gauge * leading + source
    solutions = sp.solve([equation[location] for location in locations], unknowns, dict=True)
    assert len(solutions) == 1
    return gauge.subs(solutions[0])


def rank_three_jets(leading: sp.Matrix, regular: sp.Matrix) -> list[sp.Matrix]:
    kernel = (leading**3).nullspace()
    vector = next(v for v in kernel if leading**2 * v != sp.zeros(4, 1))
    change = sp.Matrix.hstack(leading**2 * vector, leading * vector, vector,
                             *(leading**3).columnspace())
    u, d = change.inv() * leading * change, change.inv() * regular * change
    assert u[:3, :3] == sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    b0 = sp.diag(d[:3, :3], d[3:, 3:])
    g1 = cross_gauge(u, d, 3)
    assert u * g1 - g1 * u + d == b0
    w1 = d * g1 - g1 * b0 - g1
    g2 = cross_gauge(u, w1, 3)
    b1 = u * g2 - g2 * u + w1
    assert b1[:3, 3:] == sp.zeros(3, 1) and b1[3:, :3] == sp.zeros(1, 3)
    b2 = d * g2 - 2 * g2 - g2 * b0 - g1 * b1
    return [u[:3, :3], b0[:3, :3], b1[:3, :3], b2[:3, :3]]


def corrected_rank_three_residue(jets: list[sp.Matrix]) -> tuple[sp.Expr, sp.Matrix]:
    n, a0, a1, a2 = jets
    assert n == sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    assert sp.trace(n * a0) == 0 and sp.trace(n**2 * a0) == 0
    h = sp.zeros(3)
    h[2, 0] = -a0[1, 0]
    assert h**2 == sp.zeros(3) and h * n * h == sp.zeros(3)
    a0p = a0 + n * h - h * n
    a1p = a1 + a0 * h - h * a0 - h
    a2p = a2 + a1 * h - h * a1 - h * a0 * h
    assert all(a0p[i, j] == 0 for i in range(3) for j in range(i))
    residue = sp.Matrix([[a0p[0, 0], 1, 0],
                         [a1p[1, 0], a0p[1, 1] - 1, 1],
                         [a2p[2, 0], a1p[2, 1], a0p[2, 2] - 2]])
    return sp.factor(a1p[2, 0]), residue.applyfunc(sp.cancel)


def gauge_jets(jets: list[sp.Matrix], gauge: list[sp.Matrix]) -> list[sp.Matrix]:
    degree, n = len(jets) - 1, jets[0].rows
    inverse = [gauge[0].inv()]
    for k in range(1, degree + 1):
        inverse.append(-inverse[0] * sum((gauge[j] * inverse[k-j]
                                         for j in range(1, k+1)), sp.zeros(n)))
    result = []
    for k in range(degree + 1):
        coefficient = sum((inverse[i] * jets[j] * gauge[k-i-j]
                           for i in range(k+1) for j in range(k-i+1)), sp.zeros(n))
        coefficient -= sum((inverse[i] * (k-1-i) * gauge[k-1-i]
                            for i in range(max(0, k-1))), sp.zeros(n))
        result.append(coefficient.applyfunc(sp.cancel))
    return result


def check_rank_three_flatness() -> dict:
    a, b, c, d, e, f, pole = sp.symbols('a b c d e f pole')
    r = sp.Matrix([[a, 1, 0], [b, c, 1], [d, e, f]])
    bmat = sp.Matrix(3, 3, sp.symbols('b0:9'))
    e31 = sp.zeros(3)
    e31[2, 0] = 1
    k21 = pole * bmat[0, 2]
    k32 = k21
    k31 = pole * ((a-c-1) * bmat[0, 2] + bmat[1, 2])
    k = sp.Matrix([[0, 0, 0], [k21, 0, 0], [k31, k32, 0]])
    equation = -k + k * r - r * k + pole * (bmat * e31 - e31 * bmat)
    assert all(sp.expand(equation[i, i]) == 0 for i in range(3))
    assert sp.expand(equation[1, 0]) == 0
    multiplier = ((a-f-1) * ((a-c-1)*bmat[0, 2] + bmat[1, 2])
                  + (b-e)*bmat[0, 2] + bmat[2, 2] - bmat[0, 0])
    assert sp.expand(equation[2, 0] - pole * multiplier) == 0
    assert k.subs(pole, 0) == sp.zeros(3)
    n = sp.Matrix([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
    g = sp.Matrix(3, 3, sp.symbols('g0:9'))
    commutator = n * g - g * n
    assert commutator[1, 0] == g[2, 0]
    assert commutator[2, 1] == -g[2, 0]
    return {'pole_evolution_multiplier': multiplier,
            'normalized_gauge_constraint': 'G1[3,1] = 0',
            'base_pole_vanishes_when_connection_pole_vanishes': True}


def run() -> dict:
    t = sp.Symbol('t')
    grading = sp.diag(sp.Rational(3, 2), sp.Rational(1, 2),
                      sp.Rational(-1, 2), sp.Rational(-3, 2))
    table = {}
    detected = []
    rank_three = {}
    centered_parameter = {'g2': sp.Rational(1, 9), 'g3': sp.Rational(1, 16),
                          'g4': sp.Rational(1, 36), 'g5': 0}
    for name, values in DATA.items():
        u = quantum_matrix(values)
        unit = sp.eye(4)[:, 0]
        cyclic = sp.Matrix.hstack(unit, u*unit, u**2*unit, u**3*unit)
        assert cyclic.det() == 1
        characteristic = sp.factor(u.charpoly(t).as_expr())
        factors = sp.factor_list(characteristic, t)[1]
        dimensions = sorted((multiplicity for factor, multiplicity in factors
                             for _ in range(sp.degree(factor, t))), reverse=True)
        row = {'shifted_counting_matrix': u, 'characteristic': characteristic,
               'primary_even_dimensions': dimensions, 'h21': H21[name]}
        rank_two = []
        for factor, multiplicity in factors:
            if multiplicity == 2:
                for root in sp.solve(factor, t):
                    certificate = rank_two_discriminant(u, grading, root)
                    assert certificate['delta'] == EXPECTED_DELTA[name]
                    rank_two.append(certificate)
        row['rank_two_certificates'] = rank_two
        row['lattice_count'] = sum(int(certificate['delta'] != 0) for certificate in rank_two)
        row['O3'] = H21[name] if dimensions == [3, 1] else 0
        row['detected_after_one_stabilization'] = bool(row['lattice_count'] or row['O3'])
        if row['detected_after_one_stabilization']:
            detected.append(name)
        if dimensions == [3, 1]:
            jets = rank_three_jets(u, grading)
            obstruction, residue = corrected_rank_three_residue(jets)
            assert obstruction == 0 and sp.trace(residue) == -3
            centered = sp.factor((residue + sp.eye(3)).charpoly(t).as_expr())
            assert sp.expand(centered - t*(t**2-centered_parameter[name])) == 0
            n = jets[0]
            gauge = [sp.eye(3)+2*n+3*n**2,
                     sp.Matrix([[1, 2, -1], [3, -2, 4], [2, 1, 3]]),
                     sp.Matrix([[0, 1, 2], [-2, 3, 1], [1, -1, 0]]),
                     sp.Matrix([[1, 0, 3], [2, 1, -1], [-1, 2, 0]])]
            changed_obstruction, changed_residue = corrected_rank_three_residue(gauge_jets(jets, gauge))
            assert changed_obstruction == 0
            assert sp.expand(changed_residue.charpoly(t).as_expr()-residue.charpoly(t).as_expr()) == 0
            rank_three[name] = {'separated_jets': jets, 'pole_obstruction': obstruction,
                                'residue': residue, 'centered_characteristic': centered,
                                'eigenvalues': list(residue.eigenvals()),
                                'nonconstant_gauge_test': True}
        table[name] = row
    assert set(detected) == {'g2', 'g3', 'g4', 'g5', 'g6', 'g8', 'd1', 'd2', 'd3'}
    rational = sorted(set(DATA)-set(detected))
    assert rational == sorted(['g7', 'g9', 'g10', 'g12', 'd4', 'd5', 'quadric', 'projective_space'])
    return {'status': 'all assertions passed',
            'scope': 'Exact finite algebra only; geometric comparison, surface vanishing, and deformation arguments are written proofs.',
            'families': table, 'rank_three': rank_three,
            'rank_three_formal_flatness': check_rank_three_flatness(),
            'nine_detected_families': detected, 'eight_rational_families': rational}


def serializable(value):
    if isinstance(value, sp.MatrixBase):
        return [[str(value[i, j]) for j in range(value.cols)] for i in range(value.rows)]
    if isinstance(value, sp.Basic):
        return str(value)
    if isinstance(value, dict):
        return {str(k): serializable(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return [serializable(v) for v in value]
    return value


if __name__ == '__main__':
    results = run()
    destination = Path(__file__).with_suffix('.json')
    destination.write_text(json.dumps(serializable(results), indent=2) + '\n')
    print(f"{results['status']}; wrote {destination.name}")
```
