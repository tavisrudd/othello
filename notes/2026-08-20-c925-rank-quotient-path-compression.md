# Module 34. Rank-quotient path compression

**Packet part:** Module 34.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** abstract path theorem proved; local fixed-phase QDM edge provider
remains open

## 34.1 The consumed object is a quotient line

For a finite-dimensional \(K\)-space \(V\) with a possibly zero row
\(\rho:V\to K\), put

\[
Q(V,\rho)=V/\ker\rho.
\tag{34.1}
\]

Thus \(Q(V,\rho)\) is zero when \(\rho=0\), and is a one-dimensional
space when \(\rho\ne0\).  The endpoint marker is only

\[
h(V,\rho)=[Q(V,\rho)\ne0].
\tag{34.2}
\]

It forgets the normalization of \(\rho\), the chosen basis of the quotient
line, every exceptional summand, and every lower filtration level.

## 34.2 Local occurrence law

For one blowup occurrence, let

\[
J:V_-\oplus E\overset\sim\longrightarrow V_+
\tag{34.3}
\]

be the typed fixed-phase comparison, with rows \(\rho_\pm\).  The full row
law is

\[
\rho_+J=c(\rho_-\oplus0),
\qquad c\in K^\times.
\tag{34.4}
\]

### Proposition 34.1 -- row law descends to the quotient line

Equation (34.4) induces a canonical isomorphism

\[
\overline J:Q(V_-,\rho_-)\overset\sim\longrightarrow Q(V_+,\rho_+).
\tag{34.5}
\]

The induced map is independent of the exceptional coordinate.  Replacing
\(\rho_-\) or \(\rho_+\) by a nonzero scalar multiple changes neither source
nor target quotient and only rescales a chosen identification with \(K\).

#### Proof

If \(v-v'\in\ker\rho_-\), then (34.4) gives
\(\rho_+J(v-v',0)=0\), so \(J(v,0)\) and \(J(v',0)\) define the same target
class.  The induced map is nonzero because \(c\ne0\) and \(\rho_-\ne0\)
whenever the source quotient is nonzero.  Both nonzero quotients are lines,
so it is an isomorphism.  If the source quotient is zero, (34.4) and the
fact that \(J\) is onto force \(\rho_+=0\), so both sides are zero.  The
remaining claims are immediate from the quotient definition.  \(\square\)

The same statement applies to a blowdown by using
\(\overline J^{-1}\).  No new inverse-comparison theorem is required.

## 34.3 Free typed paths

Let a chosen weak-factorization path have vertices

\[
s_0\xrightarrow{e_1}s_1\xrightarrow{e_2}\cdots
\xrightarrow{e_n}s_n.
\tag{34.6}
\]

At each vertex choose one occurrence-indexed row package
\((V_i,\rho_i)\).  At each edge choose a local certificate (34.5), in the
direction of the path.  The shared vertex type is load-bearing: the target
package of edge \(e_i\) is literally the source package of edge \(e_{i+1}\),
or comes with an explicit reindexing isomorphism \(R\) satisfying

\[
\rho'R=d\rho,\qquad d\in K^\times,
\tag{34.6a}
\]

and hence inducing its own quotient-line isomorphism.

For each \(i\), let \(T_i\) denote the edge quotient isomorphism followed,
when necessary, by the induced reindexing isomorphism into the chosen
package at \(s_i\).

### Theorem 34.2 -- one-path quotient telescope

The composite

\[
T_n\cdots T_1:
Q(V_0,\rho_0)\overset\sim\longrightarrow Q(V_n,\rho_n)
\tag{34.7}
\]

is an isomorphism.  Consequently \(h(V_0,\rho_0)=h(V_n,\rho_n)\).

#### Proof

Composition of the typed edge and reindexing line isomorphisms gives (34.7).
Isomorphic vector spaces are simultaneously zero or nonzero.  \(\square\)

This theorem needs no comparison assigned to the composite geometric path,
no equality between two different paths, no Beck--Chevalley square, and no
trivial loop holonomy.  Those structures are required only to promote the
assignment to a path-independent functor.  A contradiction along one chosen
weak factorization consumes none of them.

## 34.4 Scalar Writer data are observationally irrelevant

On the nonzero-marker component, use the row-induced identification
\(Q(V_i,\rho_i)\to K\), \([v]\mapsto\rho_i(v)\).  Each edge or nontrivial
reindexing is then multiplication by a scalar
\(a_k\in K^\times\), and (34.7) is multiplication by

\[
c_{\mathrm{path}}=\prod_k a_k^{\epsilon_k},
\qquad \epsilon_k\in\{1,-1\},
\tag{34.8}
\]

where \(\epsilon_k=-1\) for a transport traversed through its inverse.
The Writer value \(c_{\mathrm{path}}\) can have nontrivial holonomy around a
cycle.  Since the marker (34.2) observes only zero versus nonzero, every
value in \(K^\times\) is observationally equivalent.  Holonomy is therefore
a potential obstruction to a normalized row functor, but not to the
irrationality telescope.

On the all-zero component the quotient spaces are zero and there is a unique
transport; no \(K^\times\) Writer scalar is attached there.

## 34.5 Weakened conditional all-\(m\) gate

### Corollary 34.2A -- local rank-line transport suffices

Use the audited source and endpoint inputs of Theorem 33.3.  For every
hypothetical birational map

\[
X\times\mathbf P^m\dashrightarrow\mathbf P^{m+3},
\tag{34.9}
\]

it is enough to choose one weak factorization and provide:

1. one common fixed phase and occurrence-indexed rank row at each vertex;
2. row-compatible adjacent reindexing (34.6a) at every shared vertex;
3. for every edge, the quotient-line isomorphism (34.5) induced by its
   actual fixed-phase comparison certificate, not an arbitrary line
   isomorphism; and
4. row-compatible endpoint certificates identifying the first package with
   the audited product-source row and the last with the empty projective
   sector in that same transported phase.

Then \(X\times\mathbf P^m\) is irrational.  If these local providers exist
for every \(m\), every stabilization is irrational.

#### Proof

The source quotient line is nonzero by (33.4) and the product input.  The
projective endpoint quotient is zero.  Theorem 34.2 says they must be
isomorphic, a contradiction.  \(\square\)

This is strictly weaker than asking for a pseudofunctorial fixed-phase
Gamma/Orlov comparison on the whole weak-factorization groupoid.  At one
edge, (34.5) is the canonical linear witness supplied by the row law.  The
logically weakest Boolean consumer would retain only the biconditional
\(h_-=h_+\), but proving it from geometry still requires an actual
comparison-side certificate.

## 34.6 What remains analytic

Module 34 removes global coherence from the proof target; it does not prove
the local edge law.  For one edge, sufficient analytic data remain:

1. an actual fixed-phase decomposition
   \(J_\pi:V_\chi(Y)\oplus E_\pi\overset\sim\to V_\chi(\widetilde Y)\);
2. ambient rank calibration;
3. zero rank on every sectorially continued exceptional branch, including
   the scalar regressions (33.8); and
4. a common endpoint/reindexing identification with the next edge.

Items 1--3 imply (34.4); item 4 makes consecutive quotient maps composable.
Independent edgewise phases with no reindexing witness do not suffice.

## 34.7 Executable calibration

The shared finite replay checks over all words of length at most six in the
nonzero scalars \(\{1,-1,2,1/2\}\) that forward composition multiplies the
transport scalars, reversing a transport inverts its scalar, nonzero remains
nonzero, and zero remains zero.  This is a bounded Writer-law calibration,
not a row/reindexing/endpoint-coherence model, not the proof of Theorem 34.2,
and not evidence for any QDM edge provider.

## 34.8 EJ/TT and mystery ledger

**EJ.** The unavoidable scalar ambiguity of fixed-phase continuation is
harmless for the actual consumer.  We may retain it as Writer output without
normalizing it or killing its holonomy.

**TT.** Ask for coherence only at the granularity used by the proof.  Shared
typed endpoints are load-bearing; equality of unrelated paths is not.

| question | status | exact evidence or gate |
|---|---|---|
| Do local row laws compose? | **settled** | Proposition 34.1 and Theorem 34.2 |
| Must edge scalars be normalized to one? | **no** | Boolean marker forgets \(K^\times\) Writer output |
| Must loop holonomy vanish? | **no for one-path irrationality** | (34.8) remains nonzero |
| May adjacent edges use unrelated phase rows? | **no** | shared endpoint/reindexing type in (34.6) |
| Is the local QDM edge law proved? | **open** | four analytic items in Section 34.6 |

## Boundary

The quotient-line and one-path composition theorems are proved.  They
strictly reduce the global coherence demanded by the conditional rank route,
but they do not construct one local fixed-phase QDM comparison.  No
unconditional \(m=2\) or all-\(m\) theorem follows.
