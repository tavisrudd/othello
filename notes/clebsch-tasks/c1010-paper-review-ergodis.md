# C1010 — Ergodis review of Papers I, III, and IV

**Lane:** `clebsch`

**Status:** Reported 2026-08-30; theorem packets and exact evidence frozen.
No manuscript, Lean, sparse-shadow, or Ergodis source file was edited.

## Executive result

The review found two further theorem-grade strengthenings.

1. At (q=13), pair-concurrence **parity alone** reconstructs the binary
   code, the full elliptic scheme, and hence the marked plane, conic, and
   polarity. More generally, every nonconstant Boolean predicate of the five
   observed concurrence values recovers the full scheme under coherent
   refinement.
2. The uncovered-locus obstruction admits a component-count refinement using
   the Aubry--Perret/Serre bound for absolutely irreducible curves and a
   Bézout bound for relatively irreducible components. Its linear coefficient
   depends on the number of rational geometric components, not their total
   degree.

Paper III's remaining quantitative questions are already owned by C880. The
review found no honest non-overlapping theorem that should bypass that lane.

## 1. Paper IV: parity-only reconstruction

Let (c(P,Q)) denote minimum-support pair concurrence and form the simple
graph (Gamma_{m odd}) on the 78 internal points by

\[
 P\sim Q\quad\Longleftrightarrow\quad c(P,Q)\equiv1\pmod2.
\]

In the paper's elliptic notation its adjacency matrix is

\[
P=A_{10}+A_{12};
\]

it is 28-regular. For two distinct vertices, adjacency and the number of
common neighbors give the following exact signatures.

| relation | adjacent in Γodd | common neighbors |
|---:|:---:|---:|
| rho=0 | no | 12 |
| rho=1 | no | 8 |
| rho=3 | no | 14 |
| rho=9 | no | 11 |
| rho=10 | yes | 8 |
| rho=12 | yes | 7 |

All six ordered pairs are distinct. Therefore one common-neighbor refinement
of the parity graph recovers every elliptic relation. In particular it recovers
(A_0), whose neighborhoods are the 78 passant incidence rows.

Over (mathbf F_2), exact elimination gives

\[
\operatorname{rank}P=36,qquad
\operatorname{rank}A_0=42,qquad A_0P=0.
\]

Hence

\[
\boxed{\operatorname{im}P=\ker A_0=K.}
\]

Thus the same one-bit pair shadow recovers both the code and the full scheme.
Paper IV currently separates these statements: parity recovers (K), while
weighted concurrence recovers the scheme. The table above closes that gap.

### Consequence

The marked geometry is determined by the unlabeled graph
(Gamma_{m odd}). Its coherent closure recovers the scheme; the paper's
group reconstruction then recovers (operatorname{PG}(2,13)), its conic,
and polarity. This is stronger than C1008's rho-zero graph theorem because
the input is merely the parity of the pair counts and its binary adjacency
matrix simultaneously has image (K).

## 2. Paper IV: one-bit universality

The observed pair-concurrence values are

\[
\{6,7,8,9,12\},
\]

where concurrence 6 fuses rho=1 and rho=3. Let (S) be any nonempty proper
subset of these five values and retain only the bit

\[
b_S(P,Q)=1_{c(P,Q)\in S}.
\]

Then the coherent closure of this unweighted graph is the complete
seven-class elliptic Bose--Mesner configuration (six off-diagonal relations
and the diagonal).

There are 30 nonconstant predicates. Complementary graphs have the same
coherent closure, so the exact certificate checks 15 representatives. Every
one recovers all six relations within three refinement rounds; several do so
in one round. This includes each single concurrence fibre as well as every
fusion of fibres.

This statement is certificate-assisted and fixed-field. The parity theorem
above is the preferred human-facing result because its six signatures are a
complete one-line witness.

The result cleanly illustrates C1005's distinction between ordinary algebra
generation and coherent closure. Some fusion adjacency matrices have minimal
polynomial degree six and do not generate the seven-dimensional algebra by
ordinary powers, yet their coherent closure still recovers every relation.

## 3. Paper I: component-count uncovered-locus envelope

Let

\[
N=\binom{k}{2},\qquad
\beta_k=N-k+\frac6{\lfloor k/2\rfloor}\binom{k}{4}.
\]

C1001 gives

\[
|U(A)|\ge q^2-(N-1)q+\beta_k+1. \tag{1}
\]

Assume (q) is odd and a reduced plane curve containing (U(A)) has:

- (s) rational line components;
- (a) nonlinear absolutely irreducible components (C_i), of degree
  (e_i), geometric genus (g_i), and arithmetic genus
  (pi_i=(e_i-1)(e_i-2)/2); and
- relatively irreducible but not absolutely irreducible components (D_j)
  of degrees (f_j).

Put (m_q=lfloor2sqrt q\rfloor) and

\[
E=\sum_i(g_i m_q+pi_i-g_i)
  +\sum_j\left\lfloor\frac{f_j^2}{4}\right\rfloor.
\]

Then containment forces

\[
\boxed{
q^2-(N+s+a-1)q+eta_k+1+s(k-1)-a-E\le0.
} \tag{2}
\]

### Proof

C1007 bounds each rational line component by (q-k+1) uncovered points.
For each absolutely irreducible component, the singular-curve
Aubry--Perret/Serre bound gives

\[
\#C_i(mathbf F_q)\le q+1+g_i m_q+pi_i-g_i.
\]

For an (mathbf F_q)-irreducible but not absolutely irreducible plane curve
of degree (f_j), every rational point lies in two conjugate components, so
Bézout gives at most (lfloor f_j^2/4\rfloor) points. Summing these bounds,
discarding overlap savings, and comparing with (1) proves (2).

The two point bounds are documented in
[Aubry--Iezzi](https://arxiv.org/abs/1501.03676) and the elementary conjugate-
component argument appears explicitly in
[Rodríguez Villegas--Voloch](https://www.math.canterbury.ac.nz/~f.voloch/Pdfs/ferpol3.pdf).

### Geometrically irreducible specialization

If the containing curve is absolutely irreducible of degree (d), geometric
genus (g), and arithmetic genus (pi=(d-1)(d-2)/2), then

\[
\boxed{
q^2-Nq+eta_k-gm_q-pi+g\le0.
} \tag{3}
\]

Since (g\lepi), the genus-free consequence is

\[
\boxed{
q^2-Nq+eta_k-pi\lfloor2\sqrt q\rfloor\le0.
} \tag{4}
\]

Unlike the Serre degree-(d) envelope, the coefficient of (q) in (3) is
independent of (d). Degree enters only through a square-root error.

For six-arcs, use the sharper concurrence-spectrum lower constant
(|U(A)|\ge q^2-14q+45), i.e. replace (eta_6=39) by 44. For an absolutely
irreducible conic or cubic, (4) excludes every integer (q\ge12). Hence

\[
\boxed{
\text{an absolutely irreducible degree-at-most-three container for a
six-arc forces }q\le11.
}

This does not supersede C1001's all-cubic theorem, which also handles every
reducible cubic. It supplies a broader component-sensitive theorem and a
shorter first branch of that proof.

## 4. Paper III review

Paper III's alignment observable already has a mature dedicated programme in
C880:

- adaptive leading constant (1/2) is settled;
- the nonadaptive interval is (0.616n^2) to (9n^2/8+O(n));
- (g(8)=17) is exact; and
- the remaining lower-bound route is explicitly the alignment code's distance
  distribution.

The current Ergodis row-classifier is not a natural engine for that remaining
problem. Adaptive reconstruction states are sets of candidate two-graphs and
queries split those sets; flattening them into independent scalar rows would
erase the minimax structure. A useful Ergodis extension would be a dedicated
finite decision-tree campaign adapter with state hashes, query-orbit features,
and independently replayable split certificates. Until that exists, creating a
parallel C880 search would duplicate active work rather than strengthen the
paper.

## 5. Controlled-search record and Ergodis improvements

The protected campaign classified which of the 15 canonical observable
fusion graphs generate the full scheme by ordinary matrix powers. `ceiling`
found no feature collision. `evolve` tested 794 candidates, produced 68
observational classes, and found no perfect small rule (best 10/15). This is
useful negative evidence: ordinary power generation has a less natural
boundary than coherent generation, which succeeds for all 15 graphs.

The run also sharpened the product notes:

1. `synthesize` reproduced the Boolean result-sort failure on a third, tiny,
   unrelated dataset: `plan result sort does not match its declared output`.
   This is now clearly systematic rather than campaign-specific.
2. Campaigns support only Boolean labels. Direct searches for recovery of six
   relation labels require one-vs-rest encodings or offline work. A bounded
   multiclass diagnostic mode would fit coherent-configuration searches.
3. The engine cannot declare complement-equivalent hypotheses or row
   involutions, so graph/complement cases are duplicated unless canonicalized
   offline.
4. Graph intersection counts and refinement signatures must correctly remain
   offline, but their generator identity still is not bound into the campaign
   presentation. The feature-generator digest proposed in C1008 would solve
   this provenance gap.
5. The new campaign again recorded `code_commit: "unknown"` in a Git checkout.

## 6. Publication routing and draft language

### Paper IV

The parity theorem is strong enough to change the abstract-level description:
“weighted pair concurrences” can be replaced, for the reconstruction headline,
by “the parity graph of pair concurrences.” The universal Boolean-fusion result
belongs later as a robustness proposition or remark. C1006 should compare this
one-bit universality with C968's other four adapters before deciding whether it
supports a separate sparse-shadow synthesis.

> Let (Gamma) join two coordinates when their minimum-support concurrence is
> odd. The six elliptic relations have distinct pairs consisting of adjacency
> in (Gamma) and common-neighbor number, so one coherent refinement recovers
> the full association scheme. Moreover, over (mathbf F_2), the adjacency
> matrix of (Gamma) has image exactly (K). Thus a single unweighted graph
> reconstructs the code, the elliptic scheme, and the marked conic plane.

### Paper I / arcs successor

Equation (2) should travel with C1001/C1007/C1009 into C1004. It is a natural
component-sensitive subsection, not presently a standalone paper. A standalone
route would require equality/stability theory or applications beyond uncovered
loci.

> Factoring a containing curve before applying a point bound replaces total
> degree by rational component count in the coefficient of (q). Rational
> lines are charged by the uncovered-line lemma, absolutely irreducible
> components by the Aubry--Perret bound, and relatively irreducible components
> by Bézout. This yields the component envelope (2); for one geometrically
> irreducible degree-(d) component it reduces to (3).

## Evidence

~~~sh
cd /home/tavis/src/othello
python3 notes/clebsch-tasks/c1010-paper-review-ergodis.py \
  --check notes/clebsch-tasks/c1010-paper-review-ergodis.json
sha256sum -c notes/clebsch-tasks/c1010-paper-review-ergodis.sha256
~~~

| file | bytes | SHA-256 |
|---|---:|---|
| `c1010-paper-review-ergodis.py` | 9704 | `143037e02db6d770e937973d6c321adec0b328c56383669eda4fa3d1158602fd` |
| `c1010-paper-review-ergodis.json` | 7121 | `55197a29490a188563cedf593441ffd489b1fbffbf7e54f993e89319f2d39583` |
