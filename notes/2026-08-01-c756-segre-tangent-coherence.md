# C756 — Segre tangent closure of the sign-coherence gate

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The sign-coherence gate left by the saturated-matching attack is now proved.
For every odd prime power (q\equiv3\pmod4), a resultant-compatible perfect
matching whose coefficient points form an arc necessarily has

\[
 \chi\bigl((s-t)(\phi(s)-\phi(t))\bigr)=-1
 \qquad(s\ne t\in S).
\]

The proof uses Segre's lemma of tangents.  Saturation identifies the tangent
lines of the matching arc exactly with the lines meeting the fixed conic; their
product has an explicit two-evaluation formula.  The fixed edge
\(\{0,\infty\}\) removes every scaling ambiguity in Segre's lemma, forcing the
desired signs pair by pair.

After writing \(\phi=-f\), sign coherence says that (f:S\to S) is an
automorphism of the tournament induced by the Paley tournament on its nonzero
squares.  If this local automorphism is semilinear, (f(s)=c s^{p^j}), then a
second uniform character-sum argument eliminates every (j>0); (j=0) is the
scalar branch already closed by the genus-one/Hasse argument.  Thus the exact
remaining saturated-external gate is only the following local rigidity lemma:

> Every automorphism of the first Paley subconstituent on (S) that occurs in
> a resultant-compatible complete matching is induced by multiplication and
> Frobenius.

No source located in this pass states that half-domain theorem.  The usual
Carlitz--McConnel theorem classifies automorphisms on the whole field and cannot
be substituted for it.

## 1. Setup

Fix the matching edge (e_0=\{0,\infty\}).  Put

\[
 S=(\mathbb F_q^*)^2,\qquad m=|S|=(q-1)/2,
\]

and orient every other edge as

\[
 e_s=(s,\phi(s)),\qquad s\in S,
\]

where \(\phi:S\to N\) is a bijection.  For distinct (s,t\), abbreviate

\[
 A_{s,t}=(s-t)(\phi(s)-\phi(t)),\qquad
 B_{s,t}=(s-\phi(t))(\phi(s)-t).
\]

The cross-resultant condition is

\[
 \chi(A_{s,t}B_{s,t})=-1. \tag{1}
\]

The coefficient points form an arc of size

\[
 k=m+1=(q+1)/2.
\]

An external point of the conic lies on exactly (m) passants.  The (k-1=m)
joins from any arc point to the other arc points are distinct passants, so they
exhaust all passants through that point.  Consequently the combinatorial
tangents to the arc at that point are exactly the

\[
 t=q+2-k=m+2=(q+3)/2
\]

lines through it that meet the conic.  Since (q\equiv3\pmod4), both (m) and
(t) are odd.

## 2. The canonical tangent product

Represent a point of the parameter conic by a vector (a\in\mathbf P^1), and
write \([x,a]\) for the homogeneous bracket.  For an ordered matching edge
(e=(a,b)), let

\[
 f_Q(a)=[a,c][a,d],\qquad f_Q(b)=[b,c][b,d]
\]

when (Q) is the coefficient point of the edge \(\{c,d\}\).  The two factors
are the evaluations at (a,b) of a binary quadratic representing (Q).

Define

\[
 T_e(Q)=f_Q(a)f_Q(b)
       \bigl(f_Q(a)^m-f_Q(b)^m\bigr). \tag{2}
\]

This is a homogeneous polynomial of degree (m+2=t) in (Q).  Its zero lines
in the pencil through the coefficient point (P_e) are exactly the lines
meeting the conic:

* either one evaluation vanishes, giving one of the two conic tangents through
  (P_e); or
* both are nonzero and their quotient is a square, equivalently their product
  (the resultant) is a square, giving a secant of the conic.

There are exactly (t) such lines, all with multiplicity one.  Hence (2) is a
tangent function of the arc at (P_e), up to a nonzero scalar.

For another matching edge the resultant is nonsquare, so the two evaluations
in (2) have opposite character.  Euler's criterion gives

\[
 T_e(Q)=2\operatorname{Res}(e,Q)\,\chi(f_Q(a)), \tag{3}
\]

after choosing (a) as the first endpoint.

## 3. Sign coherence from Segre's lemma

Segre's lemma of tangents says that the tangent functions may be scaled by
nonzero constants \(\lambda_e\) so that

\[
 \lambda_e T_e(Q)=(-1)^{t+1}\lambda_QT_Q(P_e)
 \tag{4}
\]

for distinct arc points.  Here (t) is odd, so the sign in (4) is (+1).
The scaled coordinate-free form and proof are reviewed by Ball--Lavrauw,
[*Arcs in finite projective spaces*](https://arxiv.org/abs/1908.10772).

Order the fixed edge as (e_0=(0,\infty)), and every finite edge as
(e_s=(s,\phi(s))).  Put (h_s=s\phi(s)\in N).  Directly from (2),

\[
 T_{e_0}(P_{e_s})
   =h_s(h_s^m-1)=-2h_s.
\]

In the other direction the evaluations of the fixed quadratic at the two
endpoints are (-s) and (-\phi(s)).  Their characters are respectively
(-1) and (+1), so

\[
 T_{e_s}(P_{e_0})=-2h_s. \tag{5}
\]

Both sides are nonzero.  Applying (4) to (e_0,e_s) and using (5) gives
(\lambda_{e_s}=\lambda_{e_0}) for every (s\in S).  Thus all scale factors
are equal, and (4) becomes the unscaled symmetry

\[
 T_{e_s}(P_{e_t})=T_{e_t}(P_{e_s}). \tag{6}
\]

The two resultants in (3) are equal.  Comparing the first-endpoint evaluation
characters in (6) gives

\[
 \chi\!\left(
  \frac{(s-t)(s-\phi(t))}
       {(t-s)(t-\phi(s))}
 \right)
 =\chi(B_{s,t})=+1.
\]

Equation (1) now forces \(\chi(A_{s,t})=-1\).

**Proposition 1 (sign-coherence theorem).**  Every saturated-external
resultant-compatible arc over every prime power (q\equiv3\pmod4) has empty
sign-incoherence graph.  Equivalently, with (f=-\phi:S\to S),

\[
 \chi\bigl((s-t)(f(s)-f(t))\bigr)=+1
 \qquad(s\ne t\in S). \tag{7}
\]

Thus (f) is an automorphism of the tournament induced on the out-neighbours
(S) of (0) in the Paley tournament.

## 4. Conditional elimination of every nontrivial Frobenius branch

Assume the remaining local rigidity statement and write

\[
 f(s)=c s^r,\qquad c\in S,\quad r=p^j,\quad 0\le j<n.
\]

The fixed-edge determinants say that (s\mapsto sf(s)) is a permutation of
(S), hence

\[
 \gcd(r+1,m)=1. \tag{8}
\]

Since \(\phi=-f\), the already proved condition \(\chi(B_{s,t})=+1\) becomes

\[
 \chi\bigl((s+c t^r)(c s^r+t)\bigr)=-1. \tag{9}
\]

Set (s=xt), with (x\in S\setminus\{1\}), and put

\[
 H=S^{r-1},\qquad d=c t^{r-1}\in cH.
\]

As (t) varies, (9) gives

\[
 \chi\bigl((x+d)(1+d x^r)\bigr)=-1
 \qquad(d\in cH). \tag{10}
\]

The two roots in (d) are (-x) and (-x^{-r}).  They are distinct by (8)
and lie in (N), while (cH\subset S), so no zero occurs in (10).  Therefore
the character sum over the coset is exactly (-|H|).

Let (e=[\mathbb F_q^*:H]).  Expanding the indicator of (cH) using the
(e) multiplicative characters trivial on (H) expresses this coset sum as
an average of sums

\[
 \sum_{d\in\mathbb F_q^*}
 \psi(d/c)\chi(d+x)\chi(d+x^{-r}).
\]

The trivial term has absolute value (2).  Every other term is a
three-factor multiplicative-character sum with three distinct support points,
and the standard Weil bound is at most (2\sqrt q).  Consequently

\[
 |H|\le 2\sqrt q. \tag{11}
\]

Suppose (j>0), put (g=\gcd(n,j)), (Q=p^g), and (L=n/g).  Since
(q\equiv3\pmod4), the integers (n,g,L) are odd, (Q\equiv3\pmod4), and
(L\ge3).  Also

\[
 \gcd(p^j-1,q-1)=Q-1.
\]

Because (m) is odd while (Q-1) has exactly one factor of (2),

\[
 \gcd(p^j-1,m)\le (Q-1)/2.
\]

It follows that

\[
 |H|=\frac{m}{\gcd(p^j-1,m)}
 \ge\frac{q-1}{Q-1}
 =1+Q+\cdots+Q^{L-1}>2Q^{L/2}=2\sqrt q,
\]

contradicting (11).

**Proposition 2 (conditional semilinear closure).**  If every automorphism in
(7) has the form (c s^{p^j}), then necessarily (j=0).  Hence
(\phi(s)=ns) with (n=-c\in N), and the genus-one argument in the preceding
C756 report forces (q\in\{3,7,11\}).  Covering removes (q=7), while (q=11)
is the Clebsch hexagon.

## 5. Exact audit

The deterministic analyser
`notes/2026-08-01-c756-segre-coherence-analysis.py` checks two independent
finite shadows of the proof over prime fields:

1. every normalized resultant-compatible matching is enumerated, and no arc
   violates \(\chi(B_{s,t})=+1\); and
2. the full automorphism stabilizer of (1) in the induced tournament on (S)
   is enumerated by compatibility backtracking.

| (q) | matchings | arcs | coherent | arc but not coherent | \(|\operatorname{Aut}(P(q)[S])|\) | stabilizer of (1) |
|---:|---:|---:|---:|---:|---:|---:|
| 7  | 5   | 2 | 2 | 0 | 3  | 1 |
| 11 | 12  | 2 | 2 | 0 | 5  | 1 |
| 19 | 54  | 0 | 0 | 0 | 9  | 1 |
| 23 | 121 | 0 | 0 | 0 | 11 | 1 |
| 31 | 31  | 0 | 0 | 0 | 15 | 1 |
| 43 | 21  | 0 | 0 | 0 | 21 | 1 |

Thus in every audited prime field the local automorphism group consists only
of multiplication by squares.  This is evidence for the remaining lemma, not
an all-field proof.

Replay from the repository root:

```sh
python3 notes/2026-08-01-c756-segre-coherence-analysis.py \
  --check notes/2026-08-01-c756-segre-coherence-analysis.json
```

Evidence hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-segre-coherence-analysis.py` | 7,041 | `a16445d7ee5ea9257233379c12e0d171bbaaab022bde11f01d91499a00e14ce4` |
| `notes/2026-08-01-c756-segre-coherence-analysis.json` | 2,070 | `b347931ed7c19578d6529088c2613f2bbaee3c8d645ebc7f6667bcd5da69c867` |

## 6. Literature boundary and next gate

The whole-field Paley tournament has the expected affine semilinear
automorphism group; see Goldberg,
[*The group of the quadratic residue tournament*](https://doi.org/10.4153/CMB-1970-010-8),
and the Carlitz--McConnel theorem gives the analogous difference-character
classification on all of \(\mathbb F_q\).  Neither result automatically extends
an automorphism of the induced tournament on (S).  The 2026
Carlitz--McConnel extensions of Xiong--Yip likewise concern full-domain
direction sets, not this first subconstituent
([arXiv:2604.04126](https://arxiv.org/abs/2604.04126)).

The remaining object is the circulant tournament

\[
 \operatorname{Cay}\!\left(S,
   D=\{u\in S:\chi(u-1)=+1\}\right).
\]

The highest-value next attacks are now:

1. prove that its regular cyclic subgroup (S) is normal in the full
   automorphism group and identify the multiplier stabilizer of (D) as the
   Frobenius group;
2. prove the same statement through separation of the Jacobi-sum Fourier
   eigenvalues, whose only expected coincidences are Frobenius conjugacies; or
3. use the extra complete-mapping condition (s\mapsto sf(s)) to avoid a full
   automorphism classification.

This is strictly narrower than the former sign-coherence problem.  Once it is
proved, Proposition 2 and the existing Hasse argument close the entire
saturated-external branch.

No manuscript files were edited.
