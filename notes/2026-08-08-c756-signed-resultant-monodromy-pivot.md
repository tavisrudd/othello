# C756 — signed-resultant identity and monodromy pivot

**Lane:** `clebsch` · **Date:** 2026-08-08 · **Scope:** first bounded
continuation of the selected \((R,\gamma)\) route; saturated-internal branch
only

## Verdict

Ordinary monodromy is not the missing obstruction. A totally split irrational
quadratic fibre can occur for a polynomial with full symmetric geometric
monodromy: an explicit degree-five example over \(\mathbb F_7\) has monodromy
\(S_5\). Thus neither split-fibre classification alone nor the exceptional-
polynomial list can close the branch.

The character data does yield a new exact identity. For every split quadratic
fibre, the product of the pairwise quadratic resultants in one row is the norm
of the derivative, up to two pure-imaginary norm factors whose quadratic
characters cancel. Consequently the chord-externality condition F2 already
implies the derivative-class condition F1. F1 is a useful cheap filter when
enumerating arbitrary split fibres, but it is not an independent theorem gate
after F2.

The correct successor is therefore not ordinary monodromy of
\(R(X)-R(Y)\). Nor is the pair-resultant sign layer sufficient uniformly: it
remembers only the product of the within-fibre and conjugate-cross-fibre
signs. The successor must retain those two Kummer layers separately, or
equivalently retain the within-fibre triangle holonomy in addition to the
pair resultants.

## 1. The row-resultant identity

Let \(q\) be odd, let \(R\in\mathbb F_q[X]\) be monic and separable of degree
\(n=(q+3)/2\), and suppose
\[
 R^{-1}(\gamma)=Z=\{z_1,\ldots,z_n\}\subset
 \mathbb F_{q^2}\setminus\mathbb F_q
\]
is a simple, conjugation-free fibre for
\(\gamma\in\mathbb F_{q^2}\setminus\mathbb F_q\). Put
\[
 f_i(X)=(X-z_i)(X-z_i^q)\in\mathbb F_q[X],
 \qquad r_{ij}=\operatorname{Res}(f_i,f_j)\in\mathbb F_q^\times.
\]
Write \(N=N_{\mathbb F_{q^2}/\mathbb F_q}\).

> **Theorem 11 (row-resultant identity).** For every \(i\),
> \[
> \prod_{j\ne i}r_{ij}
> =\frac{N(R'(z_i))N(\gamma-\gamma^q)}{N(z_i-z_i^q)}. \tag{1}
> \]
> Hence
> \[
> \chi_q\!\left(\prod_{j\ne i}r_{ij}\right)
> =\chi_{q^2}(R'(z_i)). \tag{2}
> \]

**Proof.** Let
\[
 G=(R-\gamma)(R-\gamma^q)=\prod_j f_j.
\]
At \(z_i\), differentiation in the two factorizations gives
\[
 G'(z_i)=(\gamma-\gamma^q)R'(z_i)
 =(z_i-z_i^q)\prod_{j\ne i}f_j(z_i).
\]
Since \(f_j\) is rational,
\(r_{ij}=N(f_j(z_i))\). Taking norms proves (1). Both
\(\gamma-\gamma^q\) and \(z_i-z_i^q\) are nonzero trace-zero elements. If
\(s^2=\varepsilon\) with \(\varepsilon\) a nonsquare, the norm of every
nonzero multiple of \(s\) has character
\(-\chi_q(-1)=(-1)^{(q+1)/2}\). Their contributions therefore cancel in
(1), giving (2). \(\square\)

> **Corollary 11.1.** If every pair of internal points is joined by an
> external line, so \(\chi_q(r_{ij})=-1\) for every \(i\ne j\), then
> \[
> \chi_{q^2}(R'(z_i))=(-1)^{n-1}=(-1)^{(q+1)/2}
> \]
> for every \(i\). Thus F2 implies F1 on every split quadratic fibre.

This explains the exact census funnel: at \(q=5\), all ten F2 survivors were
already among the ten F1 survivors; for \(q=7,11,13\), F2 was empty. The
derivative test remains computationally efficient, but it cannot supply
additional theoretical leverage once externality is assumed.

## 2. A full-symmetric split-fibre example

Work over \(\mathbb F_7\), set \(s^2=3\), and take
\[
 R(X)=X^5+4X^4+6X^2+2X,
 \qquad \gamma=5+4s.
\]
Then
\[
 R^{-1}(\gamma)=
 \{s,\ 2+s,\ 4+s,\ 5+2s,\ 6+2s\}. \tag{3}
\]
The five roots are distinct, irrational, and contain no conjugate pair.
Moreover
\[
 R'(X)=5X^4+2X^3+5X+2
\]
has the four distinct roots \(1,3,5,6\), whose critical values under \(R\)
are respectively \(6,4,3,0\), also distinct.

> **Proposition 12.** The geometric monodromy group of
> \(R(X)-T\) over \(\overline{\mathbb F}_7(T)\) is \(S_5\).

**Proof.** The degree-five polynomial cover is tame. Each of the four simple
finite critical points, with its own critical value, contributes an inertia
transposition. Infinity contributes a five-cycle. The cover is connected, and
a five-cycle together with any transposition generates \(S_5\): conjugating
the transposition by the cycle gives the edge transpositions of a connected
circulant graph on five letters. \(\square\)

Thus the implication
\[
 \text{totally split irrational quadratic fibre}
 \Longrightarrow
 \text{cyclic, Dickson, exceptional, or otherwise small monodromy}
\]
is false already at \(q=7\). The exceptional-polynomial classification is
global: it concerns the components of the full fibre product, or permutation
behaviour over infinitely many extensions. One split degree-two place is a
specialization condition and does not provide that hypothesis. This is also
the distinction made in the monodromy setup of Guralnick--Zieve,
arXiv:0707.1835, §1.

## 3. Polynomial reciprocity shadow

The signs have an arithmetic interpretation that makes the next module less
mysterious. For monic irreducible quadratics \(f_i,f_j\), evaluation at a root
of \(f_i\) gives
\[
 \left(\frac{f_j}{f_i}\right)
 =\chi_{q^2}(f_j(z_i))
 =\chi_q(r_{ij}). \tag{4}
\]
Thus the externality matrix is the quadratic-residue-symbol matrix of the
quadratic factors of \(G=\Phi(R)\). Polynomial quadratic reciprocity makes it
symmetric, exactly as the geometric resultant calculation does.

Encode a nonsquare by \(1\in\mathbb F_2\), and complete the diagonal so every
row sums to zero, as in a Rédei matrix. If all off-diagonal resultants are
nonsquares, the resulting matrix is
\[
 \mathcal R_G=
 \begin{cases}
 J_n,&n\text{ even},\\
 J_n+I_n,&n\text{ odd},
 \end{cases}
 \qquad
 \operatorname{rank}_{\mathbb F_2}\mathcal R_G=
 \begin{cases}
 1,&q\equiv1\pmod4,\\
 n-1,&q\equiv3\pmod4.
 \end{cases} \tag{5}
\]
This is a sharp residue-class split. In the \(q\equiv1\pmod4\) branch,
externality forces an almost maximally singular reciprocity matrix, suggesting
a 2-descent or function-field class-group obstruction for the hyperelliptic
curve \(Y^2=\Phi(R(X))\). In the \(q\equiv3\pmod4\) branch the same matrix has
minimal possible nullity, so matrix rank alone is unlikely to close the
problem. No class-group conclusion is asserted here; (4)--(5) are the exact
elementary input for that bounded check.

## 4. Corrected monodromy target

The ordinary cover forgets precisely the data that coherence supplies. A
first signed layer retains square roots of the pair-resultant functions. Its
specialization at the irreducible quadratic place of \(\gamma\) records
\[
 \epsilon_{ij}=\chi_q(r_{ij}).
\]
Externality is the single signature \(\epsilon_{ij}=-1\) for every edge.
Theorem 11 gives the row relation in this Kummer module and shows that the
derivative character is its boundary, not an extra constraint.

This first layer is still too coarse in the \(q\equiv3\pmod4\) branch. The
known line-plus-pole cliques already have \(\epsilon_{ij}=-1\) at the target
size, while the external-line triangle holonomy proves that they cannot
satisfy condition (A). Thus no obstruction expressed only in the
\(r_{ij}\) can close that residue class.

Retain instead
\[
 a_{ij}=\chi_{q^2}(z_i-z_j),
 \qquad b_{ij}=\chi_{q^2}(z_i-z_j^q),
 \qquad \epsilon_{ij}=a_{ij}b_{ij}. \tag{6}
\]
The first two are the separate within- and cross-fibre Kummer layers; the
pair resultant is their product.

> **Theorem 13 (triangle-holonomy reduction).** Put
> \(\delta=(-1)^{(q+1)/2}\). Assume F2, so
> \(\epsilon_{ij}=-1\), and hence by Corollary 11.1
> \(\prod_{j\ne i}a_{ij}=\delta\) for every \(i\). If
> \[
> a_{ij}a_{jk}a_{ki}=\delta \tag{7}
> \]
> for every triple, then there are signs \(\eta_i\) such that
> \(a_{ij}=\delta\eta_i\eta_j\). If \(q\equiv3\pmod4\), all the
> \(\eta_i\) are equal, so (7) plus F2 is equivalent to full coherence.
> If \(q\equiv1\pmod4\), the row identities force only
> \(\prod_i\eta_i=1\), leaving an even switching ambiguity.

**Proof.** Fix vertex \(1\), set \(\eta_1=1\), and for \(i>1\) set
\(\eta_i=a_{1i}/\delta\). Equation (7) on \((1,i,j)\) gives
\(a_{ij}=\delta\eta_i\eta_j\). If
\(E=\prod_i\eta_i\), its \(i\)-th row product is
\[
 \delta^{n-1}E\eta_i^n. \tag{8}
\]
For \(q\equiv3\pmod4\), \(n=(q+3)/2\) is odd, so equality of (8) to
\(\delta\) forces every \(\eta_i\) to be the same; then
\(a_{ij}=\delta\), and F2 gives \(b_{ij}=-\delta\). For
\(q\equiv1\pmod4\), \(n\) is even and (8) yields only \(E=1\).
\(\square\)

> **Theorem 14 (projective recovery of the odd-\(n\) branch).** Under a
> fractional linear transformation \(m\in\mathrm{PGL}(2,q)\), the edge signs
> \(a_{ij}\) change only by vertex switching. Consequently every triangle
> holonomy \(a_{ij}a_{jk}a_{ki}\) is projectively invariant. For
> \(q\equiv3\pmod4\), coherence is therefore equivalent to the projectively
> invariant conjunction
> \[
> \chi_q(r_{ij})=-1\quad(i\ne j),
> \qquad a_{ij}a_{jk}a_{ki}=+1\quad(i,j,k\text{ distinct}). \tag{9}
> \]

**Proof.** Write
\(m(z)=(az+b)/(cz+d)\) and \(\Delta=ad-bc\in\mathbb F_q^\times\). Then
\[
 m(z_i)-m(z_j)=
 \frac{\Delta(z_i-z_j)}{(cz_i+d)(cz_j+d)}.
\]
Every rational nonzero scalar is a square in \(\mathbb F_{q^2}\), so with
\(u_i=\chi_{q^2}(cz_i+d)\) one has
\(a'_{ij}=a_{ij}u_i u_j\). The vertex signs occur twice around a triangle
and cancel. The homogeneous bracket formulation gives the same calculation
when an image is infinity. F2 is chord externality and hence projectively
invariant. When \(q\equiv3\pmod4\), \(\delta=+1\), so Theorem 13 proves the
equivalence with coherence. \(\square\)

The projective invariant can be written entirely in the pair cross-ratios
already isolated in Theorem 9 of the coupled-invariant pass. Put
\[
 d_i=z_i-z_i^q,
 \qquad \alpha_{ij}=N(z_i-z_j),
 \qquad g_{ij}=\frac{d_i d_j}{\alpha_{ij}}\in\mathbb F_q^\times.
\]

> **Theorem 15 (cross-ratio form and colored collisions).** For every triple,
> \[
> a_{ij}a_{jk}a_{ki}
> =-\chi_q(g_{ij}g_{jk}g_{ki}). \tag{10}
> \]
> Moreover F2 is exactly
> \[
> \chi_q(1-g_{ij})=-1. \tag{11}
> \]
> Under coherence there are vertex signs \(\eta_i\) such that
> \[
> \chi_q(g_{ij})=(-\delta)\eta_i\eta_j. \tag{12}
> \]
> Hence a row collision \(g_{ij}=g_{ik}\) can occur only when
> \(\eta_j=\eta_k\).

**Proof.** Since
\[
 \alpha_{ij}\alpha_{jk}\alpha_{ki}
 =N\bigl((z_i-z_j)(z_j-z_k)(z_k-z_i)\bigr),
\]
its character is the left side of (10). On the other hand,
\[
 g_{ij}g_{jk}g_{ki}
 =\frac{d_i^2d_j^2d_k^2}
 {\alpha_{ij}\alpha_{jk}\alpha_{ki}}.
\]
Every nonzero trace-zero \(d_i\) has \(d_i^2\in\mathbb F_q\) nonsquare, so
the numerator has character \(-1\), proving (10). The identity
\(N(z_i-z_j^q)=\alpha_{ij}(1-g_{ij})\) gives (11). Equation (10) and
coherence make the edge signs \(h_{ij}=\chi_q(g_{ij})\) have constant
triangle product \(-\delta\); the same base-vertex switching argument as in
Theorem 13 gives (12). Equality of two \(g\)-values forces equality of their
characters, and (12) then gives \(\eta_j=\eta_k\). \(\square\)

The permitted value counts are exact Jacobi counts:
\[
 \#\{g:\chi_q(g)=u,\ \chi_q(1-g)=-1\}
 =\frac{q-1+u(\chi_q(-1)-1)}4. \tag{13}
\]
Thus for \(q\equiv3\pmod4\) the square and nonsquare capacities are
\((q-3)/4\) and \((q+1)/4\), while for \(q\equiv1\pmod4\) both are
\((q-1)/4\). Every row contains \((q+1)/2\) entries but only
\((q-1)/2\) permitted values, so a collision is forced in every row;
Theorem 15 now localizes every such collision inside one switching-color
class. This is the missing structural refinement of the twenty-seventh
pass's “pigeonhole off by one”: the collision is not arbitrary noise but an
edge of one color in the projective two-graph.

This repairs the most damaging invariance defect in the older crown route.
Condition (A) itself cannot be transported freely by projective
normalization, but its switching-invariant triangle content can; in odd
\(n\), F2 and the row identity recover the lost vertex switching. Thus the
\(q\equiv3\pmod4\) branch may now normalize one base conjugate pair
projectively and express the remaining two-graph through pair and triple
cross-ratio invariants, rather than carrying an affine-only coordinate system.

Theorem 13 bifurcates the programme cleanly:

- for \(q\equiv3\pmod4\), prove that every target-size F2 clique has at
  least one triangle with the wrong holonomy. The existing line-plus-pole
  exclusion is exactly the canonical case of this statement. Theorem 14
  authorizes a projective base-pair normalization for this attack;
- for \(q\equiv1\pmod4\), F2 itself is expected to be impossible for
  \(q>5\), and the rank-one reciprocity matrix (5) is the sharper possible
  2-descent lever. If F2 survives, one additional vertex-level invariant is
  needed to kill the even switching ambiguity.

The bounded decision problem is now:

1. in the \(q\equiv3\pmod4\) branch, use Theorem 14 to projectively
   normalize one base conjugate pair and express the remaining constant
   triangle condition through pair and triple cross-ratios;
2. compute only the residual two-layer Kummer module not fixed by that
   normalization, using the line-plus-pole family as the rejecting control;
3. in the \(q\equiv1\pmod4\) branch, test whether the rank-one Rédei-type
   matrix contradicts the composition \(G=\Phi(R)\); and
4. stop the route if both signatures are permitted generically, otherwise
   lift the obstruction to the degree-two specialization theorem.

This is strictly smaller than classifying all degree-\((q+3)/2\) polynomials:
it is a finite permutation/Kummer-module calculation with a clear stop rule.
It also avoids spending a uniform argument on two residue classes whose
signed linear algebra is provably different.

## 5. Reproducible verification

The exact checker verifies (1), without using characters, on every split-fibre
row in the independent subset census for \(q=5,7\): 1,550 row identities over
314 split pairs, with zero failures. It separately verifies (3), the four
critical points, and their four distinct critical values. The monodromy
conclusion itself is the human branch-cycle proof above, not a software
oracle.

Replay from the repository root:

```sh
python3 notes/2026-08-08-c756-signed-resultant-monodromy-pivot.py --check
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-08-c756-signed-resultant-monodromy-pivot.py` | 6,795 | `3b0d4cecda97e15bc03ea6b7afc2bb209dda9c06016188f7101c8b7f8005dc07` |
| `2026-08-08-c756-signed-resultant-monodromy-pivot.json` | 1,264 | `d3ca4024502f631d448fb849525ff811f6b5f0e5a9f40d0762ba20a7bbd5d724` |
| input `2026-08-02-c756-split-fiber-census.py` | 10,022 | `4a63411717c0e1de2d9de749da26f7cd40e53154c85f4395f04a5d33f5f736e7` |

Trusted boundary: the row check imports the prior independent subset
enumerator and shares its finite-field tables; the displayed theorem has an
independent symbolic proof. The explicit \(S_5\) example is checked by the
same tables, while every field evaluation needed for its human proof is
displayed above. No finite range is promoted to a uniform nonexistence claim.

## EJ + TT closeout

**EJ.** The free upgrade is Corollary 11.1: the old F1/F2/F3 cascade had one
more apparent layer than the mathematics. On a split fibre, F2 already forces
F1, so future searches and proofs should treat the derivative class as a fast
pre-filter only. The identity also exports to any family of irreducible
quadratic factors and may be useful in equality questions for passant
incidence codes. Equations (4)--(5) are the further cheap upgrade: the signed
module is a Rédei-type residue-symbol matrix whose rank flips from \(1\) to
\(n-1\) between the two congruence classes.

**TT.** The skeptical question is whether “monodromy” is seeing the rare
feature at all. Proposition 12 answers no for ordinary monodromy. The rare
feature is not splitting but a prescribed Frobenius sign in a quadratic
extension of the pair resolvent. The next calculation must therefore be in
the Kummer relation module. This retains the promising group-theoretic
spinoff while preventing a long exceptional-polynomial classification from
attacking the wrong invariant.

**TT2.** The further skeptical question is whether even the pair-resultant
module remembers coherence. It does not: \(r_{ij}\) sees only
\(a_{ij}b_{ij}\), and the \(q\equiv3\pmod4\) line-plus-pole cliques are exact
false positives. Theorem 13 identifies the missing datum as triangle
holonomy. It also says not to seek one uniform finisher: odd \(n\) turns
triangle constancy into coherence, while even \(n\) leaves a genuine
switching degree of freedom.

**TT3.** The payoff from passing to triangles is not only lossless compression.
Fractional linear transformations act on the edge signs by vertex switching,
so triangle holonomy is projectively invariant. For \(q\equiv3\pmod4\), the
row identity recovers the switching and makes the full branch projectively
normalizable. This is the first route in the saturated-internal programme
that both couples the two crown halves and restores the full projective group.

**TT4.** The rank-one \(q\equiv1\pmod4\) matrix is not itself a contradiction.
The \(q=5\) quartic control realizes it inside the composition
\(G=\Phi(R)\), and even a hypothetical rational \(4\)-divisible subgroup of
rank \(g-1\), for \(g=(q+1)/2\), fits both the maximal isotropic dimension
and the coarse Hasse size scale once \(q>4\). A useful 2-descent must therefore
use the particular pullback \(Y^2=\Phi(R(X))\), not merely the rank or size of
its torsion. Generic class-group counting is closed as a finisher.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does a split quadratic fibre force small monodromy? | settled negative | explicit \(q=7\), \(S_5\) example |
| Is derivative class F1 independent of chord externality F2? | settled negative | Theorem 11 and Corollary 11.1 |
| Why did every F2 census survivor also pass F1? | settled | row-resultant identity |
| Why should the signed module have arithmetic spinoffs? | settled at the first layer | it is the polynomial quadratic-residue/Rédei-type matrix (4), with exact rank (5) |
| Does the rank-one matrix for \(q\equiv1\pmod4\) contradict the composition \(G=\Phi(R)\)? | open | bounded 2-descent/function-field class-group check |
| Can rank or class-group size alone supply that contradiction? | settled negative | the \(q=5\) control realizes rank one, and coarse isotropic/Hasse bounds permit the expected scale |
| Does the two-layer Kummer module forbid the required joint signature? | open | retain \(a_{ij}\) and \(b_{ij}\) separately and split by residue class |
| Is the pair-resultant module alone sufficient? | settled negative | it loses the factorization \(\epsilon_{ij}=a_{ij}b_{ij}\); line-plus-pole cliques are false positives for \(q\equiv3\pmod4\) |
| What extra datum recovers coherence for \(q\equiv3\pmod4\)? | settled | constant within-fibre triangle holonomy, Theorem 13 |
| Can that triangle datum survive projective normalization? | settled positively | Theorem 14: edge signs switch by vertices, so triangle products are invariant |
| Is the full \(q\equiv3\pmod4\) branch now projectively invariant? | settled positively | F2 plus constant positive triangle holonomy is equivalent to coherence |
| Can triangle holonomy be written in the existing pair invariant? | settled | Theorem 15: \(\tau_{ijk}=-\chi_q(g_{ij}g_{jk}g_{ki})\) |
| Are the forced row collisions arbitrary? | settled negatively | they occur only within one switching-color class; exact capacities are (13) |
| Why does the same reduction not close \(q\equiv1\pmod4\)? | settled | even \(n\) leaves the switching vector \((\eta_i)\) subject only to \(\prod_i\eta_i=1\) |
| Does the \(q=5\) cyclic quartic exhaust the permitted signed signatures? | open | same module plus degree-two specialization constraint |
| Is the saturated-internal branch closed? | no | signed-module gate, then fallback to masked Rédei if generic signature survives |
| Does this affect the nonsaturated branch? | no | the masked Rédei target \(h\ge1\) remains independently necessary for full all-\(k\) |

## Next action

For \(q\equiv3\pmod4\), projectively normalize one base conjugate pair and
rewrite constant triangle holonomy in pair/triple cross-ratio coordinates, with the
line-plus-pole cliques as rejecting controls. Compute only the residual
two-layer Kummer module left after normalization. In parallel, test the
rank-one 2-descent obstruction for \(q\equiv1\pmod4\). Stop the
\((R,\gamma)\) route if both residue-class signatures survive generically.
