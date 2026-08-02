# C756 — saturated matching-character attack

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Task**: C756 · **Scope**: research only

## Verdict

The saturated-external branch is now uniformly closed for (q\equiv1\pmod4),
including every odd square field.  For (q\equiv3\pmod4), it reduces to an
orthomorphism of the cyclic square group subject to a Paley-tournament sign
condition.  The scalar (multiplicative) orthomorphism subbranch is uniformly
closed by a genus-one character sum: it exists only for (q=3,7,11); the
(q=7) arc fails covering and (q=11) is the Clebsch hexagon.

The unrestricted (q\equiv3\pmod4) orthomorphism branch remains open.  Thus
this attack does not complete C756, but it removes half the fields outright and
isolates a much narrower exact obstruction than the original perfect-matching
formulation.

## 1. Normal form and the complete-mapping obstruction

Let (M) be a perfect matching of
(\mathbf P^1(\mathbb F_q)) representing a saturated-external candidate, and
assume every two matching edges have nonsquare resultant.  Use
(\mathrm{PGL}(2,q)) to fix one edge as \(\{0,\infty\}\).  Write

\[
  S=(\mathbb F_q^*)^2,\qquad N=\mathbb F_q^*\setminus S,
  \qquad m=|S|=(q-1)/2.
\]

The resultant with \(\{0,\infty\}\) shows that each remaining edge has one
endpoint in (S) and one in (N).  Hence it is the graph of a bijection
(\phi:S\to N).  The corresponding binary quadratics are

\[
  f_s(X)=(X-s)(X-\phi(s))
       =X^2-(s+\phi(s))X+s\phi(s).
\]

The fixed edge is the coefficient point \([0:1:0]\).  A direct determinant
gives

\[
 \det\!\begin{pmatrix}
 0&1&0\\
 1&-(s+\phi(s))&s\phi(s)\\
 1&-(t+\phi(t))&t\phi(t)
 \end{pmatrix}
 =s\phi(s)-t\phi(t).
\]

Therefore the arc condition already forces

\[
 h:S\longrightarrow N,\qquad h(s)=s\phi(s),
\]

to be a bijection.

Choose a primitive element (g), and write

\[
 \phi(g^{2i})=g^{2\pi(i)+1},\qquad i\in\mathbb Z/m\mathbb Z.
\]

Then both \(\pi\) and \(i\mapsto i+\pi(i)\) are permutations of
(\mathbb Z/m\mathbb Z).  In other words, \(\pi\) is a complete mapping of the
cyclic group of order (m).

**Proposition 1.** A saturated-external arc cannot exist when
(q\equiv1\pmod4).

**Proof.** If \(i+\pi(i)\) is a permutation, summing its values modulo (m)
gives

\[
 2\sum_{i=0}^{m-1}i=\sum_{i=0}^{m-1}i\pmod m.
\]

Thus \(\sum_i i=0\pmod m\).  When (q\equiv1\pmod4), (m) is even and
\(\sum_i i=m/2\pmod m\), a contradiction. ∎

This is an elementary arc-level counterpart to the stronger theorem of
Blokhuis--Seress--Wilbrink: for (q\equiv1\pmod4), every complete exterior
set is the collinear set of exterior points on a passant
([DOI 10.1007/BF01204717](https://doi.org/10.1007/BF01204717)).  The argument
above needs only one fixed edge and one family of collinearity determinants.
It also eliminates every odd field of square order, since an odd square is
(1\pmod4).

## 2. The exact odd branch

Assume (q\equiv3\pmod4), so (m) is odd and cyclic complete mappings are no
longer excluded.  For distinct (s,t\in S), put

\[
 A_{s,t}=(s-t)(\phi(s)-\phi(t)),\qquad
 B_{s,t}=(s-\phi(t))(\phi(s)-t).
\]

The resultant condition is

\[
 \chi(A_{s,t}B_{s,t})=-1.
\]

Consequently exactly one of (A_{s,t},B_{s,t}) is a nonsquare.  The graph on
(S) whose edges are the pairs with \(\chi(A_{s,t})=+1\) is the exact
**sign-incoherence graph**.  Its complement records uniform reversal between
the Paley tournament on (S) and the tournament transported by \(\phi\);
after rescaling (N) by any fixed nonsquare, that reversal becomes agreement.

The remaining problem is therefore:

> classify complete mappings \(\pi\) of \(\mathbb Z/m\mathbb Z\) whose
> associated matching has nonsquare cross-resultant for every pair, and then
> impose the remaining three-point determinants and covering condition.

This is substantially smaller than an arbitrary Paley-type clique problem:
the arc condition supplies the second permutation (i+\pi(i)), which was not
present in the first C756 formulation.

## 3. Uniform closure of the scalar subbranch

The coherent scalar family has

\[
 \phi(s)=ns\qquad(s\in S),\qquad n\in N.
\]

Here (h(s)=ns^2), which is a bijection (S\to N) because (m) is odd.  The
coefficient points lie on the affine conic

\[
 AC=\frac{n}{(1+n)^2}B^2
\]

when (n\ne-1), and adjoining \([0:1:0]\) still gives an arc because the
constant coefficients (ns^2) are distinct.  Thus only the character
condition remains.  Dividing two square endpoints by one of them shows that
it is equivalent to

\[
 \chi\bigl((r-n)(nr-1)\bigr)=+1
 \quad\text{for every }r\in S\setminus\{1\}.
 \tag{1}
\]

**Proposition 2.** If (1) holds, then (q\in\{3,7,11\}).

**Proof.** The case (n=-1) is impossible for (q>3), because the left side
of (1) is then \(\chi(-(r+1)^2)=-1\).  Assume (n\ne-1).  Let

\[
 P(r)=(r-n)(nr-1),\qquad
 B=\sum_{r\in\mathbb F_q}\chi\bigl(rP(r)\bigr).
\]

Since (P) is a separable quadratic with nonsquare leading coefficient,

\[
 \sum_{r\in\mathbb F_q^*}\chi(P(r))=2.
\]

Using the indicator \((1+\chi(r))/2\) of (S),

\[
 \sum_{r\in S}\chi(P(r))=1+\frac B2.
\]

At (r=1), \(\chi(P(1))=\chi(-(n-1)^2)=-1\), while (1) makes every other
term (+1).  Hence the left side is (m-2), so

\[
 B=q-7.
\]

The cubic \(y^2=r(r-n)(nr-1)\) is nonsingular, and Hasse's bound gives

\[
 q-7=|B|\le2\sqrt q.
\]

Therefore (q<15).  Among prime powers congruent to (3\pmod4), only
(3,7,11) remain. ∎

These three values occur in the scalar character condition: one may take
(n=-1\) over \(\mathbb F_3\), (n=3\) over \(\mathbb F_7\), and (n=2\) over
\(\mathbb F_{11}\).

At (q=7) this gives the known saturated exterior four-arc, which fails the
covering bound.  At (q=11) it gives the Clebsch hexagon.  Thus the scalar
subbranch contributes exactly the desired saturated-external example.

## 4. Covering duality

Polarity gives a second, independent shape for the covering condition.  The
arc points dualize to (m+1=(q+1)/2) secants (p_i) whose endpoints partition
the conic.  Pairwise nonsquare resultants say that every intersection
(p_i\cap p_j) is internal; the arc condition says that no three (p_i) are
concurrent.  Each (p_i) contains exactly ((q-1)/2) internal points, so its
intersections with the other (p_j) exhaust them.

Let

\[
 X=\{p_i\cap p_j:i<j\},\qquad |X|=\binom{(q+1)/2}{2}=\frac{q^2-1}{8}.
\]

Then the original chord covering condition is equivalent to:

> (X), a set entirely of internal points, meets every secant and every
> external line of the conic.

The general lower bound for such a blocking set is (q+1) for odd (q\ge5)
(Patra--Sahoo--Sahu, [DOI 10.1016/j.disc.2016.01.010](https://doi.org/10.1016/j.disc.2016.01.010)).
Applied here it gives \((q^2-1)/8\ge q+1\), hence (q\ge9), independently
excluding the (q=7) saturated arc.  More importantly, it identifies the
unused structure: (X) is not an arbitrary blocking set, but the complete
node set of a secant arrangement that fills the internal points of every
member line.

## 5. Exact finite invariant audit

The analyser
`notes/2026-08-01-c756-saturated-matching-analysis.py` independently
enumerates every normalized saturated-external character matching over the
prime fields

\[
 q=5,7,11,13,17,19,23,29,31,37,41,43.
\]

For each matching it records whether (h(s)=s\phi(s)) is a bijection, the
complete collinear-triple count, and the sign-incoherence degree sequence.
The compact certificate is
`notes/2026-08-01-c756-saturated-matching-analysis.json`.

| (q) | normalized character matchings | complete mappings | arcs |
|---:|---:|---:|---:|
| 5 | 2 | 0 | 0 |
| 7 | 5 | 2 | 2 |
| 11 | 12 | 2 | 2 |
| 13 | 6 | 0 | 0 |
| 17 | 8 | 0 | 0 |
| 19 | 54 | 0 | 0 |
| 23 | 121 | 0 | 0 |
| 29 | 14 | 0 | 0 |
| 31 | 31 | 0 | 0 |
| 37 | 18 | 0 | 0 |
| 41 | 20 | 0 | 0 |
| 43 | 21 | 0 | 0 |

Thus, throughout this exact domain, the one determinant family through the
fixed edge already detects every failure of the arc condition; only (q=7,11)
survive, and their transported Paley tournaments are fully sign-coherent.
This is finite evidence, not a proof that complete mapping forces coherence.

The older independent searcher
`notes/2026-08-01-c756-all-k-conic-filling-saturated.py` uses a separate
implementation and agrees on the normalized character-matching and arc
counts through (q=23).  The determinant displayed in Section 1 is an
independent algebraic check of the new complete-mapping flag.  No independent
implementation of the full sign-degree distribution was made; that
distribution is diagnostic and is not used in Propositions 1 or 2.

Replay from the repository root:

```sh
python3 notes/2026-08-01-c756-saturated-matching-analysis.py \
  --check notes/2026-08-01-c756-saturated-matching-analysis.json
```

The enumeration is deterministic, fixes \(\{0,\infty\}\), uses the prime
field's Euler character, and performs no quotient by the residual stabilizer.
The certificate therefore counts normalized solutions, not projective
orbits.

Evidence hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-saturated-matching-analysis.py` | 5,457 | `de2e6022767e92f4256e3ffd92e51a68812ce81a7a94e825a346ca669916e711` |
| `notes/2026-08-01-c756-saturated-matching-analysis.json` | 8,105 | `6a0ae705337791d4910dacd955c8f436e22bf9d4fb55197a8263bc56edc6485e` |

## 6. AA + TT + EJ closeout

The three genuinely distinct next attacks are:

1. **Sign-coherence route.**  Prove that a complete mapping compatible with
   all nonsquare cross-resultants has empty sign-incoherence graph.  In
   tournament language, after a nonsquare rescaling the transported Paley
   tournament on (S) must agree with the original one.  This would reduce
   the problem to an automorphism question for the quadratic-residue
   subtournament.
2. **Cyclotomic-orthomorphism route.**  Classify automorphisms of that induced
   tournament which are also complete mappings.  The expected semilinear
   forms \(s\mapsto c s^{p^j}\) turn the remaining condition into a bounded
   character sum; the scalar (j=0) case is Proposition 2.  Recent
   Carlitz--McConnel extensions clarify the ambient rigidity but do not, as
   stated, classify this half-domain orthomorphism
   ([arXiv:2604.04126](https://arxiv.org/abs/2604.04126)).
3. **Node-blocking route.**  Strengthen the (q+1) blocking bound using the
   fact that (X) is the double-node set of ((q+1)/2) secants and exhausts
   every internal point on each member line.  This route uses covering
   directly and can bypass classification of all complete exterior sets.

The Tao-style question is whether the local sign choices can be converted
into an energy increment: a nonempty incoherence graph should create either a
collision in (h) or a low-complexity cyclotomic factor.  The cheap extra
value already realized is the genus-one reduction: once a scalar factor is
forced, Hasse gives a constant field bound rather than an asymptotic one.

## 7. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Every (q\equiv1\pmod4) saturated-external candidate fails already at the fixed-edge triples | settled | complete-mapping sum obstruction; no gap |
| The (q=7,11) normalized arc matchings are scalar and fully sign-coherent | settled in the exact audit | prove that any complete mapping compatible with the resultant signs is coherent, or exhibit a counterexample |
| The scalar family stops at (q=11) | settled uniformly | genus-one sum and Hasse bound |
| In every audited prime field, `complete_mapping` is equivalent to the full arc condition | unexplained | only the forward implication “arc implies complete mapping” is proved; reverse implication needs the other triple determinants |
| The (q=31) nonlinear complete exterior configuration has no complete-mapping representative | settled computationally | structural reason should emerge from the sign-incoherence graph or node arrangement |
| The internal node set has size ((q^2-1)/8) and blocks every non-tangent line only at (q=11) in the surviving scalar branch | partly settled | a structure-sensitive blocking theorem is the highest-EV remaining route |

No manuscript files were edited.

## 8. Third-pass update: the sign-coherence gate is closed

The successor report `notes/2026-08-01-c756-segre-tangent-coherence.md`
proves that every saturated-external resultant-compatible arc over
\(q\equiv3\pmod4\) is sign-coherent. Segre's lemma of tangents supplies the
missing implication: the canonical tangent products are symmetric because
their scale factors are all pinned by the fixed edge \(\{0,\infty\}\).

The remaining saturated-external gate is no longer item 1 of Section 6. It is
the narrower first-subconstituent rigidity problem: classify the automorphisms
of the Paley tournament induced on \(S\). If they are the expected maps
\(s\mapsto c s^{p^j}\), the same successor report proves by a coset Weil bound
that every \(j>0\) is impossible; the scalar \(j=0\) case is already closed by
Proposition 2 above.
