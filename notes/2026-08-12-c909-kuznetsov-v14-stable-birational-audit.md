# C909 primary-source audit: Kuznetsov's \(V_{14}\)--cubic flop

**Date:** 2026-08-12  
**Lane:** C909 / clebsch  
**Scope:** theorem-locus check only; no manuscript, PDF, mirror, or Lean edit.

## Verdict

The proposed \(V_{14}\) leaf is source-exact over \(\mathbb C\). For every
smooth prime Fano threefold \(V\) of genus \(8\) (Kuznetsov's \(V_{14}\)), the
paper constructs a smooth Pfaffian cubic threefold \(Y\), an honest rank-two
bundle \(U\) on \(V\), and an honest rank-two instanton bundle
\(\mathcal E=E(-1)\) on \(Y\). The two smooth projective fourfolds

\[
  \mathbb P_V(U)\quad\text{and}\quad \mathbb P_Y(E^*)
\]

are related by a flop. Consequently
\[
  V\times\mathbb P^1\dashrightarrow Y\times\mathbb P^1
\]
is a direct function-field corollary. The paper itself also records the
stronger fact that \(V\) and \(Y\) are already birational (Remark 2.19).

## Exact source loci

Primary source: A. Kuznetsov, *Derived categories of cubic and \(V_{14}\)
threefolds*, arXiv:math/0303037v1, 24-page PDF:
<https://arxiv.org/pdf/math/0303037>. The published metadata is Math. Inst.
Steklov 246 (2004), 183--207 (English translation 171--194):
<https://www.mathnet.ru/eng/tm155>.

Page numbers below are the 1-indexed arXiv PDF pages, which avoid journal
pagination ambiguity.

* In §2, p. 3, the setup says \(X_f=\mathbb P(f(A)^\perp)\cap
  \operatorname{Gr}(2,V)\) is a \(V_{14}\), and explicitly says that every
  \(V_{14}\) can be realized as some \(X_f\).
* Theorem 2.2, p. 4, associates to a regular net \(f\) a cubic \(Y_f\) and a
  rank-2 **locally free** theta sheaf \(E_f\). It also proves
  \(\operatorname{sing}(X_f)=\operatorname{sing}(Y_f)\), hence \(Y_f\) is
  smooth iff \(X_f\) is smooth. Thus no genericity restriction remains for
  a smooth \(V_{14}\).
* Definition 2.4, p. 4, defines an instanton on a cubic as a locally free
  rank-2 stable sheaf with \(c_1=0\) and \(H^1(Y,\mathcal E(-1))=0\).
  Proposition 2.6, p. 5, identifies \(\mathcal E=E(-1)\) for the theta
  bundle with a charge-2 instanton. Therefore \(E\), \(E^*\), and
  \(\mathcal E\) are honest vector bundles.
* Proposition 2.11, p. 6, constructs
  \(p_X:\mathbb P_X(U)\to X\), where \(U\) is the restriction of the
  tautological rank-2 subbundle on \(\operatorname{Gr}(2,6)\), and proves the
  small contraction to the quartic \(Q\).
* Proposition 2.15, p. 7, constructs
  \(p_Y:\mathbb P_Y(E^*)\to Y\) and the second small contraction to the same
  \(Q\).
* Theorem 2.17, p. 8, says
  \(\theta=\phi^{-1}\circ\psi:\mathbb P_Y(E^*)\dashrightarrow
  \mathbb P_X(U)\) is a flop (and its inverse is the opposite flop).
  Theorem 2.18, p. 8, summarizes this for **every smooth \(V_{14}\)**.
* Remark 2.19, p. 8, says that a hyperplane section of \(Q\) is birational to
  both \(X\) and \(Y\), and therefore the Pfaffian cubic \(Y\) is birational to
  \(X\). This is an independent, stronger base-level statement; it is not
  needed for the projective-bundle argument below.

## Smooth/projective check

The \(V_{14}\) \(V=X_f\) is a smooth projective threefold by hypothesis.
The bundle \(U\) is locally free of rank 2 as a restriction of the
Grassmannian tautological subbundle. Theorem 2.2 gives \(Y=Y_f\) smooth when
\(V\) is smooth and gives \(E=E_f\) locally free of rank 2. Hence
\(\mathbb P_V(U)\) and \(\mathbb P_Y(E^*)\) are smooth projective fourfolds,
each a genuine Zariski-locally-trivial \(\mathbb P^1\)-bundle. Theorem 2.17's
flop is therefore a birational relation between smooth projective varieties,
not a statement only in a derived or singular category.

## Stable birational consequence

The flop gives an isomorphism of function fields. Since a rank-2 projective
bundle is generically \(\mathbb P^1\),
\[
 k(\mathbb P_V(U))=k(V)(t),\qquad
 k(\mathbb P_Y(E^*))=k(Y)(s).
\]
Thus \(k(V)(t)\cong k(Y)(s)\), which is exactly
\(V\times\mathbb P^1\dashrightarrow Y\times\mathbb P^1\). This is an
elementary corollary of the flop, not a theorem explicitly formulated by
Kuznetsov; it does not claim that either bundle is globally a product or that
the flop descends to a map of bases. In this paper, Remark 2.19 even gives
the stronger \(V\dashrightarrow Y\), hence product birationality also follows
immediately from that remark.

## The \(\nu_6\) conclusion and its exact dependency

Assume the already-closed C907 invariant has:

1. \(\nu_6\) invariant under birational maps of smooth projective varieties in
   dimensions at most four (the weak-factorization/zero-center theorem in
   notes/2026-08-11-c907-v1-framed-fractional-support.md); and
2. the projective-bundle formula
   \(\nu_6(\mathbb P_Z(F))=\operatorname{rk}(F)\nu_6(Z)\).

Theorem 2.17 then gives, with both total spaces smooth fourfolds,
\[
 2\nu_6(V)
 =\nu_6(\mathbb P_V(U))
 =\nu_6(\mathbb P_Y(E^*))
 =2\nu_6(Y).
\]
Therefore the exact cubic input \(\nu_6(Y)=2\) implies
\[
  \boxed{\nu_6(V)=2}.
\]
No direct quantum differential-equation calculation for \(V_{14}\) is
needed. If one uses the paper's Remark 2.19, ordinary threefold birational
invariance alone gives the same equality even without the rank-2
projective-bundle formula; the displayed argument is the requested
projectivization-only route.

The equality \(\nu_6(Y)=2\) is an input from the C907 cubic theorem, not a
claim proved by Kuznetsov. If only the cubic lower bound \(\nu_6(Y)\ge2\) is
available, Kuznetsov's paper yields only \(\nu_6(V)\ge2\); the equality needs
the separate cubic upper bound. Once equality is available,
\[
 \nu_6(V\times\mathbb P^1)=2\nu_6(V)=4>0,
\]
so C907's rational-fourfold vanishing also gives irrationality of every
\(V\times\mathbb P^1\). This is a formal corollary, not an assertion in
Kuznetsov's paper.

## Safe manuscript wording

“For every smooth \(V_{14}\) \(V\), Kuznetsov constructs a smooth Pfaffian
cubic \(Y\) and rank-two bundles \(U\) on \(V\), \(E^*\) on \(Y\), such that
\(\mathbb P_V(U)\) and \(\mathbb P_Y(E^*)\) are related by a flop
([Kuznetsov, §2, Thms. 2.17--2.18, arXiv PDF p. 8]). Hence
\(V\times\mathbb P^1\) and \(Y\times\mathbb P^1\) are birational. Combining
this with the C907 projective-bundle and four-dimensional birational-invariance
lemmas gives \(\nu_6(V)=\nu_6(Y)=2\), assuming the already-proved cubic
equality.”

Do not attribute the \(\nu_6\) statement, the function-field stabilization,
or the irrationality conclusion to Kuznetsov; they are formal corollaries of
his geometric theorem plus the separate C907 inputs.
