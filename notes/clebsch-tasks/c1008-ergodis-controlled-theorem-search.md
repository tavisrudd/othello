# C1008 — Ergodis-controlled sparse-shadow theorem search

**Lane:** `clebsch`

**Status:** Reported 2026-08-30; human proofs and exact certificates frozen.
No manuscript or Ergodis source files were edited.

## 1. Scalar six-local realizability obstruction

Let \(G\) be the concurrence graph induced on a six-set and write \(T(G)\)
for its number of triangles. Then

\[
\boxed{
D(G):=\sum_{v\in V(G)}\deg(v)^2-2|E(G)|-6T(G)
=2\,\#\{\text{induced }P_3\text{ in }G\}.
}
\]

Consequently, \(D(G)=0\) if and only if \(G\) is a disjoint union of
cliques. Moreover, such a graph has an odd-order clique component if and
only if it has an even-degree vertex. Thus C1002's odd-characteristic
six-local condition has the scalar form

\[
\boxed{D(G)=0\quad\text{and}\quad
\#\{v:\deg(v)\equiv0\pmod2\}>0.}
\]

### Proof

The number of wedges in \(G\) is

\[
\sum_v\binom{\deg(v)}2
=\frac12\left(\sum_v\deg(v)^2-2|E(G)|\right).
\]

Every triangle contributes three closed wedges, while every remaining wedge
is an induced \(P_3\). Subtracting \(3T(G)\) proves the identity. A graph has
no induced \(P_3\) exactly when every connected component is complete. In a
clique of order \(s\), every vertex has degree \(s-1\), which is even exactly
when \(s\) is odd.

This is more useful computationally than recognizing a list of graph
patterns. A single positive integer \(D(G)\), or the parity failure when
\(D(G)=0\), is a compact local nonrealizability certificate. In particular,
the \(3K_2\) graph used in C1002 has \(D=0\), but all six degrees are odd, so
the parity scalar detects precisely the remaining obstruction.

The exact enumeration checked all \(2^{15}=32768\) labelled graphs on six
vertices. There are 203 cluster graphs and 172 satisfying the additional
odd-component condition. The controlled predicate matched every row.

## 2. One unweighted relation reconstructs the \(q=13\) scheme

Let \(A_0\) be the adjacency matrix of the rho-zero elliptic relation on the
78 exterior points at \(q=13\). It is an unweighted 7-regular graph. Exact
integer arithmetic gives

\[
\boxed{
A_0^7=-504I+72A_0+686A_0^2-161A_0^3-124A_0^4+26A_0^5+6A_0^6.
}
\]

The seven matrices \(I,A_0,\ldots,A_0^6\) are linearly independent: on the
canonical first-row coordinates

\[
(0,0),(0,1),(0,3),(0,5),(0,7),(0,8),(0,15)
\]

their determinant is \(-74240\). Since the elliptic Bose--Mesner algebra has
dimension seven and contains \(A_0\), it follows that

\[
\boxed{\mathbb Q[A_0]=\mathcal B.}
\]

This strictly strengthens C1005's weighted-generator statement: one
unweighted relation graph already recovers every relation as a polynomial
and Hadamard atom. Hence its automorphism group equals that of the full
scheme, \(\operatorname{PGL}(2,13)\), and Paper IV's existing reconstruction
then recovers the marked plane, conic, and polarity from this graph alone.

For comparison, the exact minimal-polynomial degrees of the six relation
graphs are

| rho | 0 | 1 | 3 | 9 | 10 | 12 |
|---:|---:|---:|---:|---:|---:|---:|
| degree | 7 | 7 | 7 | 6 | 7 | 7 |

Thus every relation except rho=9 is individually a generator of the full
seven-dimensional algebra. The evidence file records an exact entrywise
power identity and a nonzero pivot minor for each relation.

## 3. Bounded all-\(q\) reconnaissance

For every odd prime \(5\le q\le199\), the script built the elliptic
association algebra and computed the degree of the rho-zero relation modulo
1000003. Full modular degree proves characteristic-zero generation. A
modular deficit does **not** prove characteristic-zero nongeneration and is
retained only as reconnaissance.

Twelve of the 44 rows had a modular deficit, at

\[
q=29,37,61,73,89,97,101,109,149,157,181,193.
\]

The coarse arithmetic features
\(q\bmod12,\chi_q(2),\chi_q(3),\chi_q(5),\chi_q(7)\) cannot characterize the
observed boundary: \(q=13\) and \(q=157\) have identical feature vectors but
opposite labels. The next credible general theorem therefore needs actual
eigenvalue or character-sum input, not a small congruence rule.

## 4. What the control run contributed

The control interface was useful as a bounded conjecture engine and exact
predicate auditor:

- `try` verified the six-local scalar classifier on all 32768 graphs;
- `ceiling` proved that the selected coarse arithmetic features incur at
  least two errors on the 44-row relation dataset;
- `evolve` searched 881 small candidates without finding a perfect
  arithmetic classifier; and
- C1009's separate run found the exact low-degree window predicate on all
  9500 sampled \((k,d)\) rows.

The universal claims above rest on the displayed human proofs or exact
linear-algebra certificates, not on the controller's bounded search.

## 5. Ergodis improvement ledger

No source changes were made. The run exposed the following product issues:

1. The private campaign documentation's build command points naturally at
   the private tree, but the control-plane feature and binaries live under
   the public manifest. The documented command should name that manifest.
2. `synthesize` rejected valid Boolean-predicate datasets, both default and
   bounded, with `plan result sort does not match its declared output`, while
   `try`, `ceiling`, `evolve`, and `shutdown` worked.
3. Campaign manifests recorded `code_commit: "unknown"` inside a Git
   checkout. Commit discovery should either cross the public/private boundary
   or report why provenance is unavailable.
4. Separate CLI invocations reused `request_id: 1`. Globally monotone or
   client-qualified request identifiers would make ledger correlation safer.
5. The schema binds a presentation hash but not the identity and version of
   an offline feature generator. A generator digest/provenance field would
   make derived graph, group, and matrix features reproducible.
6. The public build emitted an unused-constant warning for
   `HUGE_LOGICAL_WORDS` in `src/css_distance.rs`.

The relational/grouped feature boundary itself is reasonable; the missing
piece is provenance for the required offline derivation rather than moving
domain-specific mathematics into the controller.

## 6. Publication routing

- The scalar six-local criterion strengthens C1002 and should be included in
  C1003's publication decision as the preferred theorem statement and solver
  certificate format. It is not independently a paper.
- The single-relation \(q=13\) theorem is a material Paper IV strengthening:
  the full weighted 2-section is unnecessary. Its clean headline is “one
  unweighted 7-regular graph reconstructs the marked geometry.” C1006 should
  test whether analogous one-relation results occur in C968's other families
  before deciding between Paper IV integration and a broader sparse-shadow
  spinoff.
- The all-\(q\) relation problem is a credible successor only after the
  eigenvalues are expressed in a form amenable to collision analysis. The
  present modular census is not a theorem of nongeneration.

### Manuscript-ready draft language (not integrated)

> The weighted pair-concurrence matrix contains redundant information at
> \(q=13\). Let \(A_0\) be the 7-regular graph joining exterior-point pairs
> in elliptic relation rho=0. Then \(I,A_0,\ldots,A_0^6\) are linearly
> independent and \(A_0\) satisfies the displayed degree-seven identity.
> Consequently \(\mathbb Q[A_0]\) is the full elliptic Bose--Mesner algebra.
> Thus this single unweighted relation graph determines the association
> scheme and, through the reconstruction theorem, the marked projective
> plane, conic, and polarity.

> For a six-set concurrence graph \(G\), odd-characteristic realizability
> forces
> \(\sum_v\deg(v)^2-2|E(G)|-6T(G)=0\) and at least one even-degree vertex.
> The first scalar is twice the number of induced three-vertex paths, so the
> condition is exactly that \(G\) be a union of cliques with an odd component.

## Evidence

~~~sh
cd /home/tavis/src/othello
python3 notes/clebsch-tasks/c1008-ergodis-controlled-theorem-search.py \
  --check notes/clebsch-tasks/c1008-ergodis-controlled-theorem-search.json
sha256sum -c \
  notes/clebsch-tasks/c1008-ergodis-controlled-theorem-search.sha256
~~~

| file | bytes | SHA-256 |
|---|---:|---|
| `c1008-ergodis-controlled-theorem-search.py` | 14098 | `b5877a61b3425cfb66cdb9f540eb9c95f313d13f373939105eba08ef31c8f40a` |
| `c1008-ergodis-controlled-theorem-search.json` | 8906 | `e38293aefbc51402ef00fd386de3d6aaf66ecf7ae39a84170e0f248b6973fc61` |
