# C894 — TT cyclotomic compression and rigidity cascade

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** cheap theorem
extraction and conceptual proof compression; no manuscript or Lean edits

## Verdict

The primitive collision theorem has a stronger invariant meaning that the
current architecture did not expose:

> A faithful local-Paley eigenvalue is a primitive generator of the
> decomposition field of \(p\) in
> \(\mathbb Q(\zeta_{(q-1)/2})\), and its square generates the maximal real
> subfield of that decomposition field.

This is free from the proved collision classification. It sharpens the
arithmetic engine, gives the human novelty search a standard algebraic-number-
theory formulation, and creates a genuine connection to the golden Clebsch
series: at \(q=11\), the square of a primitive local eigenvalue generates
\(\mathbb Q(\sqrt5)\).

The paper should retain two main headlines. This cyclotomic statement belongs
as a theorem/corollary inside the local-Paley section, not as a third topic in
the title.

## 1. Exact field-generation theorem

Let
\[
 q=p^n\equiv3\pmod4,\qquad m=(q-1)/2,
\]
and assume \(q>3\). Put \(K=\mathbb Q(\zeta_m)\). For a faithful character
\(\rho\in\widehat S\), where \(S=(\mathbb F_q^*)^2\), define
\[
 \beta_\rho=\sum_{u\in S}\rho(u)\chi(u-1).
\]

**Theorem.**
\[
 \mathbb Q(\beta_\rho)=K^{\langle p\rangle},
 \qquad
 [\mathbb Q(\beta_\rho):\mathbb Q]
 =\frac{\varphi(m)}{n}.                                          \tag{1}
\]
Moreover,
\[
 \mathbb Q(\beta_\rho^2)=K^{\langle p,-1\rangle},
 \qquad
 [\mathbb Q(\beta_\rho^2):\mathbb Q]
 =\frac{\varphi(m)}{2n}.                                         \tag{2}
\]
The field in (1) is the decomposition field of \(p\) in \(K\), and the field
in (2) is its maximal real subfield.

**Proof.** Identify
\[
 \operatorname{Gal}(K/\mathbb Q)
 \cong(\mathbb Z/m\mathbb Z)^*.
\]
For \(t\) in this group, the cyclotomic automorphism \(\sigma_t\) sends
\(\rho\) to \(\rho^t\), hence
\[
 \sigma_t(\beta_\rho)=\beta_{\rho^t}.                             \tag{3}
\]
The audited primitive collision theorem says
\[
 \beta_{\rho^t}=\beta_\rho
 \quad\Longleftrightarrow\quad
 t\in\langle p\rangle.                                           \tag{4}
\]
Therefore the Galois stabilizer of \(\beta_\rho\) is exactly
\(\langle p\rangle\). The order of \(p\) modulo \(m\) is \(n\), so the Galois
correspondence gives (1). In a cyclotomic field the decomposition group of
the unramified prime \(p\nmid m\) is precisely \(\langle p\rangle\), giving
the stated interpretation.

Complex conjugation is \(\sigma_{-1}\), and the skew inversion identity gives
\[
 \sigma_{-1}(\beta_\rho)=\beta_{\rho^{-1}}=-\beta_\rho.            \tag{5}
\]
The eigenvalue is nonzero. If
\(\sigma_t(\beta_\rho^2)=\beta_\rho^2\), then in characteristic zero
\(\sigma_t(\beta_\rho)=\pm\beta_\rho\). The positive case is (4). In the
negative case, inversion followed by \(\sigma_t\) fixes \(\beta_\rho\), so
\(-t\in\langle p\rangle\). Thus the stabilizer of \(\beta_\rho^2\) is exactly
\(\langle p,-1\rangle\).

Since \(n\) is odd, \(-1\notin\langle p\rangle\), so this group has order
\(2n\). This proves (2). Its fixed field is exactly the complex-conjugation
fixed subfield of \(K^{\langle p\rangle}\). ∎

The \(q=3\), \(m=1\) singleton is separate and carries no cyclotomic content.

## 2. Golden specialization

At \(q=11\), \(m=5\), \(n=1\), and
\[
 \mathbb Q(\beta_\rho)=\mathbb Q(\zeta_5),\qquad
 \mathbb Q(\beta_\rho^2)=\mathbb Q(\sqrt5).                       \tag{6}
\]
For a generator \(\zeta=\zeta_5\) and the cyclic ordering of
\(S=\{1,3,9,5,4\}\), one primitive eigenvalue is
\[
 \beta=-\zeta-\zeta^2+\zeta^3+\zeta^4,
\]
and direct reduction by
\(1+\zeta+\zeta^2+\zeta^3+\zeta^4=0\) gives
\[
 \beta^2=-5-2\sqrt5;                                              \tag{7}
\]
the other square is its golden conjugate \(-5+2\sqrt5\).

Thus the normalized local Paley spectrum intrinsically recovers the same
golden quadratic field that appears throughout the Clebsch orientation and
conference-operator papers. This is stronger than the earlier observation
that the local \(C_5\) is compatible with a Sylow-\(5\) subgroup of the
Clebsch \(A_5\): it recovers the arithmetic field, though still not the full
projective \(A_5\)-action.

Publication use must remain restrained:

- cite Paper I for the Clebsch hexagon and its golden orientation;
- describe (6) as a direct arithmetic bridge supplied by the new local
  spectrum;
- do not claim that the local tournament reconstructs the entire Clebsch
  configuration or its full symmetry group.

## 3. Tao proof compression

The whole paper can be presented as a four-stage rigidity cascade:

\[
\begin{array}{c}
\text{Stickelberger valuations}\\
\Downarrow\\
\text{exact Galois stabilizer of one primitive eigenvalue}\\
\Downarrow\quad\text{flat Sidon}\\
\text{every local permutation is semilinear}\\
\Downarrow\quad\text{Segre tangent symmetry}\\
\text{every extremal exterior arc enters that local group}\\
\Downarrow\quad\text{Weil and Hasse}\\
\text{Frobenius collapses to a scalar and }q\in\{3,7,11\}.
\end{array}
\]

This is the conceptual spine. Each stage converts a soft symmetry into a
smaller algebraic object:

1. many spectral collisions become one Galois orbit;
2. a whole eigenspace becomes one character line;
3. an arbitrary perfect matching becomes a semilinear map;
4. a semilinear family becomes one scalar and then three fields.

The introduction should explain this cascade before presenting technical
notation. It is more informative than a chronological proof roadmap and makes
the graph theorem and exterior-arc application feel like one paper.

## 4. Refined theorem hierarchy

The EJ hierarchy remains correct, with one insertion:

1. flat Sidon lemma;
2. one-block normal-Cayley criterion;
3. primitive Paley collision theorem;
4. **cyclotomic decomposition-field corollary, equations (1)--(2);**
5. Paley restriction-is-an-isomorphism;
6. extremal exterior-arc classification;
7. Clebsch filling corollary.

The one-block proposition should be stated in its exact normality form:
if the faithful collision class is a Sidon orbit under a known subgroup
\(M\le\operatorname{Aut}(G)\) that preserves the Cayley connection set, then
\[
 \operatorname{Aut}(\operatorname{Cay}(G,D))=G\rtimes M.
\]
This makes normality the output of the criterion rather than a Paley-specific
afterthought.

## 5. Human-search packet upgrade

In addition to the existing graph queries, search:

- “Jacobi sum generates decomposition field”;
- “Galois stabilizer Jacobi sum Frobenius”;
- “field generated by Jacobi sums”;
- “distinct conjugates Jacobi sums”;
- “Paley tournament eigenvalue cyclotomic field”;
- “Gaussian period decomposition field”;
- the exact degree \(\varphi((q-1)/2)/n\).

A predecessor for (1) would change attribution of the arithmetic engine but
would not pre-empt restriction-is-an-isomorphism or the exterior-arc theorem.
Until this search is recorded, equations (1)--(2) are proved corollaries with
no independent novelty sentence.

## 6. Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| What field does one primitive local eigenvalue generate? | settled | the decomposition field \(K^{\langle p\rangle}\) |
| What field does its square generate? | settled | the maximal real subfield \(K^{\langle p,-1\rangle}\) |
| Why are Frobenius collisions the only spectral multiplicity? | settled conceptually | they are exactly the decomposition group of \(p\) |
| Does the \(q=11\) local spectrum recover the golden field? | settled positive | equation (7) gives \(\mathbb Q(\beta^2)=\mathbb Q(\sqrt5)\) |
| Does it recover the full Clebsch \(A_5\)? | settled negative | the spectrum supplies the golden field and local \(C_5\), not the projective completion |
| Is the decomposition-field generator theorem already in Jacobi-sum literature? | open attribution | targeted human MathSciNet/Scopus search with the terms in §5 |
| Is a more general conductor-\((p^n-1)/d\) theorem available by the same half-carry proof? | genuinely open | post-C894 successor only; do not generalize inside this paper |
| What is the clean conceptual proof order? | settled | Galois stabilizer → flatness → Segre → Weil/Hasse rigidity cascade |

## 7. Next action

Put the decomposition-field theorem and the four-stage cascade into the
claim--proof--citation matrix. Add the §5 terms to the human safeguard packet.
Do not widen C894 to other cyclotomic conductors.
