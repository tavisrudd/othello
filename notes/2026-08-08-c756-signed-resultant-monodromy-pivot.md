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
\(R(X)-R(Y)\). It is the **signed/Kummer resolvent** of the off-diagonal fibre
product, which remembers the quadratic characters of the pair resultants.

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

The ordinary cover forgets precisely the data that coherence supplies. The
next bounded object should retain, over the off-diagonal fibre product, square
roots of the pair-resultant functions. Its specialization at the irreducible
quadratic place of \(\gamma\) records the sign matrix
\[
 \epsilon_{ij}=\chi_q(r_{ij}).
\]
Externality is the single signature \(\epsilon_{ij}=-1\) for every edge.
Theorem 11 gives the row relation in this Kummer module and shows that the
derivative character is its boundary, not an extra constraint.

The bounded decision problem is now:

1. compute the \(\mathbb F_2[S_n]\)-module of square-class relations among the
   pair-resultant functions for a tame Morse polynomial;
2. determine whether the all-negative specialization signature is permitted
   after the rational-coefficient and degree-two-place constraints; and
3. if it is permitted generically, close the monodromy route negatively and
   move to the masked Rédei target; if it is forbidden except in the cyclic
   degree-four case, convert that obstruction into the saturated-internal
   classification.

This is strictly smaller than classifying all degree-\((q+3)/2\) polynomials:
it is a finite permutation/Kummer-module calculation with a clear stop rule.

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

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does a split quadratic fibre force small monodromy? | settled negative | explicit \(q=7\), \(S_5\) example |
| Is derivative class F1 independent of chord externality F2? | settled negative | Theorem 11 and Corollary 11.1 |
| Why did every F2 census survivor also pass F1? | settled | row-resultant identity |
| Why should the signed module have arithmetic spinoffs? | settled at the first layer | it is the polynomial quadratic-residue/Rédei-type matrix (4), with exact rank (5) |
| Does the rank-one matrix for \(q\equiv1\pmod4\) contradict the composition \(G=\Phi(R)\)? | open | bounded 2-descent/function-field class-group check |
| Does signed/Kummer monodromy forbid the all-negative edge signature? | open | compute the pair-resultant square-class module |
| Does the \(q=5\) cyclic quartic exhaust the permitted signed signatures? | open | same module plus degree-two specialization constraint |
| Is the saturated-internal branch closed? | no | signed-module gate, then fallback to masked Rédei if generic signature survives |
| Does this affect the nonsaturated branch? | no | the masked Rédei target \(h\ge1\) remains independently necessary for full all-\(k\) |

## Next action

Compute the signed pair-resultant Kummer module first for the generic tame
Morse cover and for the cyclic quartic control, including the bounded
2-descent interpretation of the rank-one \(q\equiv1\pmod4\) matrix. Stop the
\((R,\gamma)\) route if the all-negative signature survives generically;
otherwise lift the module obstruction to the degree-two specialization
theorem.
