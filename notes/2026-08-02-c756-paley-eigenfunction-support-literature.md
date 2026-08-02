# C756 literature: minimum supports of eigenfunctions of Paley graphs of square order

**Lane**: `clebsch`
**Date**: 2026-08-02
**Task**: C756 literature retrieval (focused; no proof work)

Scope requested: minimum support of eigenfunctions of `P(q^2)` for the non-principal eigenvalues
`(-1+q)/2` and `(-1-q)/2`; classification of the optimal ones; second-minimum / stability results;
Frobenius-anti-invariant and `+/-1`-valued eigenfunctions; crown-graph induced subgraphs; Delsarte
cliques and clique-difference eigenfunctions; maximal cliques of `P(q^2)`; forward citations.

Notation as in the sources: `q` an odd prime power, `P(q^2)` the Paley graph on `F_{q^2}`
(adjacency = difference is a nonzero square), eigenvalues `lambda_0 = (q^2-1)/2`,
`lambda_1 = (-1+q)/2`, `lambda_2 = (-1-q)/2`. `S(f)` / `Supp(f)` is the set of vertices where `f`
is nonzero. "MS-problem" = the minimum-support problem, the survey's name for it.
`theta_1`, `theta_2` in Goryainov et al. 2018 are the same as `lambda_1`, `lambda_2` here.

## Sources fetched and cached

All added to the shared lit cache at `/tmp/persistent/tavis/lit-search/` (blobs stay out of git):

| key | sha256 (prefix) | what |
|---|---|---|
| `arXiv:1801.00438` | `57d2112035aaf7` | Goryainov, Kabanov, Shalaginov, Valyuzhenich 2018 (the min-support paper) |
| `arXiv:2102.11142` | `0a2e06b935f4ad` | Sotnikova, Valyuzhenich, min-support survey |
| `arXiv:2203.16081` | `69ea8bd2aa4305` | Goryainov, Shalaginov, Yip, generalised Paley graphs |
| `arXiv:2407.02780` | `6ff98a990cd54b` | Evans, Goryainov, Shalaginov, strongly regular polar graphs |
| `arXiv:2503.09914` | `048add768ff54d` | Brouwer, Goryainov, Shalaginov, Yip, cliques in `P(q^2)` and Peisert graphs |
| `arXiv:2410.04024` | `5e6c37b6eb7bc0` | Chen, Goryainov, Hu, second largest maximal cliques |
| `arXiv:2102.03822` | `c8f51fcae04942` | Goryainov, Masley, Shalaginov, correspondence between maximal cliques |

Full bibliographic data:

- S. Goryainov, V. V. Kabanov, L. Shalaginov, A. Valyuzhenich, "On eigenfunctions and maximal
  cliques of Paley graphs of square order", *Finite Fields and Their Applications* **52** (July
  2018) 361-369, DOI `10.1016/j.ffa.2018.05.001`; preprint arXiv:1801.00438v1, 1 Jan 2018.
  Cited below as **GKSV18**; page/theorem numbers below refer to the arXiv v1 unless stated.
- E. Sotnikova, A. Valyuzhenich, "Minimum supports of eigenfunctions of graphs: a survey",
  *The Art of Discrete and Applied Mathematics* **4** (2021), no. 2, Paper P2.09, 34 pp.,
  DOI `10.26493/2590-9770.1404.61e`; preprint arXiv:2102.11142. Cited as **SV21**.
- S. Goryainov, L. Shalaginov, C. H. Yip, "On eigenfunctions and maximal cliques of generalised
  Paley graphs of square order", *Finite Fields and Their Applications* **87** (2023) 102150,
  DOI `10.1016/j.ffa.2022.102150`; preprint arXiv:2203.16081v3. Cited as **GSY23**.
- R. J. Evans, S. Goryainov, L. Shalaginov, "Tightness of the weight-distribution bound for
  strongly regular polar graphs", *Journal of Combinatorial Designs* (2025),
  DOI `10.1002/jcd.22001`; preprint arXiv:2407.02780. Cited as **EGS25**.
- A. E. Brouwer, S. Goryainov, L. Shalaginov, C. H. Yip, "Cliques in Paley graphs of square order
  and in Peisert graphs", *Designs, Codes and Cryptography* (2026),
  DOI `10.1007/s10623-026-01850-w`; preprint arXiv:2503.09914v2, 9 Apr 2026. Cited as **BGSY26**.
- H. Chen, S. Goryainov, C. Hu, "Second largest maximal cliques in small Paley graphs of square
  order", arXiv:2410.04024v1, 5 Oct 2024. Cited as **CGH24**.
- S. Goryainov, A. Masley, L. Shalaginov, "On a correspondence between maximal cliques in Paley
  graphs of square order", *Discrete Mathematics* **345** (2022) 112853,
  DOI `10.1016/j.disc.2022.112853`; preprint arXiv:2102.03822v3. Cited as **GMS22**.
- R. D. Baker, G. L. Ebert, J. Hemmeter, A. J. Woldar, "Maximal cliques in the Paley graph of
  square order", *J. Statist. Plann. Inference* **56** (1996) 33-38. Cited as **BEHW96**
  (not fetched; quoted only through GKSV18/BGSY26/CGH24).
- A. Blokhuis, "On subsets of `GF(q^2)` with square differences", *Indag. Math.* **46** (1984)
  369-372. Cited as **Blokhuis84** (not fetched; quoted through GKSV18/BGSY26).
- D. Krotov, I. Mogilnykh, V. Potapov, "To the theory of q-ary Steiner and other-type trades",
  *Discrete Mathematics* **339** (2016), no. 3, 1150-1157. Source of the weight-distribution bound
  (its Corollary 1). Cited as **KMP16** (not fetched; quoted through GKSV18/GSY23).

---

## 1. Minimum support for both non-principal eigenvalues: it is `q+1`, confirmed

### 1a. The lower bound (weight-distribution bound)

GKSV18, Introduction, p. 2, verbatim:

> It follows from [6, Corollary 1] that an eigenfunction of `P(q^2)` corresponding to the eigenvalue
> `theta_2 = (-1-q)/2` has at least `q + 1` non-zero values. Since `P(q^2)` is self-complementary,
> the same bound holds for an eigenfunction of `P(q^2)` corresponding to the eigenvalue
> `theta_1 = (-1+q)/2`.

Reference [6] there is KMP16. The general form of the bound is stated in GSY23 as Lemma 2.2 and,
in the clean strongly-regular form, as Corollary 2.3 (arXiv:2203.16081v3, p. 6), verbatim:

> **Corollary 2.3.** Let `X` be a primitive strongly regular graph with non-principal eigenvalues
> `s` and `r`, such that `s < 0 < r`. Then an eigenfunction of `X` corresponding to the eigenvalue
> `r` has at least `2(r + 1)` non-zeroes, and an eigenfunction corresponding to the eigenvalue `s`
> has at least `-2s` non-zeroes.

For `P(q^2)`: `s = (-1-q)/2` gives `-2s = q+1`; `r = (-1+q)/2` gives `2(r+1) = q+1`. Both bounds
are `q+1`, and the bound is a pure spectral/intersection-array consequence — nothing about
`+/-1`-valuedness or Frobenius behaviour enters it.

### 1b. The upper bound (construction), and the resulting exact value

GKSV18, Section 4, Theorem 2 (arXiv v1, p. 6), verbatim:

> **Theorem 2.** Let `f : F_{q^2} -> R` be a function defined by the following rule.
> `f(gamma) := 1` if `gamma in Q_0`; `-1` if `gamma in Q_1`; `0` otherwise.
> (1) If `q = 1 (mod 4)`, then `f` is an eigenfunction of `P(q^2)` corresponding to the eigenvalue
> `theta_2 = (-1-q)/2` and `|Supp(f)| = q + 1` holds;
> (2) If `q = 3 (mod 4)`, then `f` is an eigenfunction of `P(q^2)` corresponding to the eigenvalue
> `theta_1 = (-1+q)/2` and `|Supp(f)| = q + 1` holds.

Here (GKSV18 Section 2/3; restated in SV21 Section 10, p. 25) `beta` is a primitive element of
`F_{q^2}`, `omega := beta^{q-1}`, `Q_0 := <omega^2>` and `Q_1 := omega<omega^2>`. So
`Q := Q_0 union Q_1 = <omega>` is the norm-1 subgroup of `F_{q^2}^*`, of size `q+1`; GKSV18 treat
it as an **oval** in the affine plane `A(2,q)` (the conic `x^2 - d y^2 = 1`), and `Q_0` is its
index-2 subgroup of squares, `Q_1` the nontrivial coset.

SV21, Section 10, p. 25-26, states this as Theorem 9 (`= [45, Theorem 2]`) and then draws the
conclusion explicitly, verbatim:

> Since the Paley graph `P(q^2)` is self-complementary, Theorem 9 implies that for any `i in {1,2}`
> `P(q^2)` has `lambda_i`-eigenfunction `f` such that `|S(f)| = q + 1`. On the other hand, by the
> weight distribution bound we obtain that a `lambda_2`-eigenfunction of `P(q^2)` has at least
> `q + 1` non-zero values. Since `P(q^2)` is self-complementary, the same bound holds for a
> `lambda_1`-eigenfunction of `P(q^2)`. Thus, the minimum cardinality of the support of a
> `lambda_i`-eigenfunction of `P(q^2)`, where `i in {1,2}`, is `q + 1`.

And earlier, SV21 p. 25:

> In [45] Goryainov et al. for `i in {1,2}` proved that the minimum cardinality of the support of a
> `lambda_i`-eigenfunction of `P(q^2)`, where `q` is an odd prime power, is `q + 1`.

**Verdict on item 1: your recollection of `q+1` is correct, for both non-principal eigenvalues,
and it is exactly the weight-distribution bound.** Note the parity twist: the explicit
`Q_0`/`Q_1` function realises `lambda_2 = (-1-q)/2` only when `q = 1 (mod 4)`; for `q = 3 (mod 4)`
that same function realises `lambda_1`, and the `lambda_2` case is obtained indirectly, by
self-complementarity of `P(q^2)` (complementation swaps `lambda_1` and `lambda_2` and preserves
supports). No explicit `q = 3 (mod 4)`, `lambda_2 = (-1-q)/2` optimal function is written down in
GKSV18 or SV21 — only its existence, via the self-complementary argument.

*Applies to support exactly `q+3` with a Frobenius-odd `+/-1` function?* No. This settles only the
minimum (`q+1`) and exhibits one optimal family; it says nothing that forbids or classifies
support `q+3`. It does give the hard floor: any eigenfunction has support `>= q+1`, so `q+3` is
above the floor and not excluded by the bound.

## 2. Characterization of the optimal eigenfunctions: OPEN in the literature

SV21, Section 12 (Open problems), p. 30, verbatim:

> MS-problem for the Paley graph `P(q^2)` is solved for both non-principal eigenvalues. We formulate
> the following problem for optimal eigenfunctions.
>
> **Problem 11.** Characterize optimal `lambda_1`-eigenfunctions and `lambda_2`-eigenfunctions of
> the Paley graph `P(q^2)`.

I found no paper solving Problem 11. Checked: every forward citation of GKSV18 in OpenAlex
(10 works) and Semantic Scholar (17 works) as of 2026-08-02 (lists in Section 6), plus an arXiv
abstract search; none announces a characterization of optimal eigenfunctions of `P(q^2)`. The
nearest thing in print is a characterization for a *different* graph family:

EGS25, Theorem 1 (arXiv:2407.02780, p. 1), verbatim:

> **Theorem 1.** Let `X` be a strongly regular (affine) polar graph. Then the following statements
> hold.
> (1) Let `C_0, C_1` be two distinct Delsarte cliques in `X` such that the size of the intersection
> of `C_1 cap C_2` is maximum possible. Let `T_0 = C_0 \ C` and `T_1 = C_1 \ C`, where
> `C = C_0 cap C_1`. Then the function `f : V(X) -> R` taking value `1` on the vertices from `T_0`,
> value `-1` on the vertices from `T_1`, and value `0` otherwise is an eigenfunction of `X`
> corresponding to the positive non-principal eigenvalue, with the support meeting the
> weight-distribution bound.
> (2) Let `g` be an eigenfunction of `X` corresponding to the positive non-principal eigenvalue,
> with the support meeting the weight-distribution bound. Then `g = c f` for some eigenfunction `f`
> from item (1) and a real number `c`.

`P(q^2)` is not a polar graph, so Theorem 1 does not apply to it; it is quoted here because it is
the template a Paley-case answer to Problem 11 would follow (optimal = signed difference of two
maximum cliques), and because it shows the shape the community expects.

The one general structural statement that *does* apply is the equality condition of the
weight-distribution bound. SV21, Section 4, p. 10, verbatim:

> Indeed for every distance-regular graph admitting a so-called Delsarte pair the existence of a
> `lambda_D`-eigenfunction `f` achieving the weight distribution bound is equivalent to the
> existence of an isometric distance-regular subgraph induced on the non-zero values of `f`
> (see Corollary 2 from [66]).

([66] is KMP16.) This constrains the *induced subgraph on the support* of a minimum-support
eigenfunction, not the support of a larger one.

*Applies to support exactly `q+3` with a Frobenius-odd `+/-1` function?* No. The characterization
question is open even at the minimum `q+1`, so there is no published classification to compare a
`q+3` family against.

## 3. Second minimum support, stability, and sizes `q+2 .. 2q`: nothing in the literature

This is the decisive item, and the answer is negative. I found **no** result of any of the
following kinds for `P(q^2)`:

- a second-minimum-support theorem (the smallest support exceeding `q+1`);
- a stability/gap theorem of the form "every `lambda_i`-eigenfunction with `|S(f)| < C q` has the
  following form";
- any classification, construction, or non-existence statement for supports of size `q+2`, `q+3`,
  ..., `2q`.

Verification, with exact searched domain and stop condition, is in "What is NOT in the literature"
below. SV21's own open-problem list for `P(q^2)` contains exactly one item (Problem 11, the
characterization at the minimum) and no second-minimum or stability problem, which is consistent
with the topic being untouched for Paley graphs. Second-minimum/stability work in this school
exists only for Hamming-type graphs and hypercubes (Valyuzhenich-Vorob'ev, "Minimum supports of
functions on the Hamming graphs with spectral constraints", *Discrete Mathematics* **342** (2019)
1351-1360, arXiv:1807.09139; Valyuzhenich, "Optimal functions with spectral constraints in
hypercubes", *Discrete Mathematics* (2023), DOI `10.1016/j.disc.2023.113816`, arXiv:2303.10995),
where the generalization goes to eigenspace *sums* `U_{[i,j]}` rather than to larger supports in a
single eigenspace.

The only support sizes above `q+1` for which a `P(q^2)` eigenfunction is explicitly exhibited
anywhere I found are multiples-of-lines constructions with support `2q`; see item 5c.

*Applies to support exactly `q+3` with a Frobenius-odd `+/-1` function?* This is precisely the gap:
`q+3` is neither realized nor excluded anywhere in the retrieved literature.

## 4. Frobenius-anti-invariant, off-subfield, and `+/-1`-valued eigenfunctions

**`+/-1`-valued:** yes, and it is the standard case. Both known optimal families are `+/-1`-valued
(GKSV18 Theorem 2, quoted above; GSY23 Theorem 4.3, quoted below). No paper singles out
`+/-1`-valuedness as a hypothesis or proves anything conditional on it for Paley graphs; it just
happens to be how the extremal examples come out. The related general theory is the
eigenfunction/bitrade correspondence in KMP16, discussed in SV21 Sections 2-4 — a `+/-1`-valued
eigenfunction is the signed indicator of a bitrade `(T_0, T_1)` — but SV21 develops that only for
Hamming/Johnson-type graphs, not for Paley.

**Frobenius `z -> z^q` behaviour:** I found **no** paper that imposes, studies, or even names
invariance or anti-invariance of a Paley eigenfunction under the subfield Frobenius. The Frobenius
appears in this literature only as an element of `Aut(P(q^2))` (Carlitz's theorem, quoted in
BGSY26 Section 1.4: the automorphisms are `x -> a x^sigma + b` with `a` a nonzero square and
`sigma = p^i`), and inside clique constructions (BEHW96's `q = 3 (mod 4)` clique
`{x, x^q} union (x^perp cap C)`, quoted in BGSY26 Section 1.6).

Derived observation, flagged as mine and not from any source: the known optimal support
`Q = <omega>` is the norm-1 subgroup, on which `z^q = z^{-1}`; `Q_0 = <omega^2>` is a subgroup and
hence inversion-closed, so `f(z^q) = f(z)`. The GKSV18/GSY23 optimal eigenfunctions are therefore
Frobenius-**even**, not Frobenius-odd. Also `Q cap F_q = {1, -1}`, so their support meets the
subfield in two points rather than avoiding it. No source states either fact; both are immediate
from the definitions quoted above.

**Supported off the subfield `F_q`:** no result found either way.

## 5. Related structural literature

### 5a. Maximum and maximal cliques of `P(q^2)`

BGSY26, Section 1.5, verbatim:

> Blokhuis [4] showed for Paley graphs of square order `q = r^2` that the only cliques of size `r`
> are lines of the underlying affine plane of order `r` (images `aF + b` of the subfield
> `F = F_r`, where `a` is a nonzero square). That is, `F_r` is the only subset of size `r` of
> `F_{r^2}` containing `0, 1` in which any two elements differ by a square. More generally,
> Sziklai [18] showed for `r` a prime power and `d | (r + 1)` that `F_r` is the only subset of size
> `r` of `F_{r^2}` containing `0, 1` in which any two elements differ by a `d`-th power.

So the Delsarte cliques of `P(q^2)` are exactly the `(q+1)/2` parallel classes of lines of
`AG(2,q)` with "square" direction — `q(q+1)/2` cliques of size `q` in total. BGSY26 Section 1.6:

> In any strongly regular graph, if `C` is a clique with a size meeting the Delsarte-Hoffman bound,
> every point `x` outside `C` has the same number of neighbors inside. In the case of a net graph
> this number is `m - 1`. In particular, for Paley or Peisert graphs of order `q = r^2`, each point
> `x` outside an `r`-clique `C` has `(r-1)/2` neighbors inside. Now `{x} union (x^perp cap C)` is
> an `(r+1)/2`-clique. Baker et al. [2] showed that these cliques are maximal in `P(r^2)` when
> `r = 1 (mod 4)`, and that `{x, x^r} union (x^perp cap C)` is maximal in `P(r^2)` when
> `r = 3 (mod 4)` and `C = F_r`.
>
> One conjectures that this size (`(r+1)/2` if `r = 1 (mod 4)` or `(r+3)/2` if `r = 3 (mod 4)`) is
> the second largest size for cliques in `P(r^2)`, and that there are only two orbits of cliques of
> this size when `r >= 25`. This conjecture has been checked for `r <= 109`.

GKSV18 Theorem 1 (arXiv v1, p. 5; restated as SV21 Theorem 10) verbatim:

> **Theorem 1.** Let `q` be an odd prime power and let `beta` be a primitive element of the finite
> field `F_{q^2}`. Then the following statements hold.
> 1. If `q = 1 (mod 4)`, then `Q_0` and `Q_1` are maximal cocliques of size `(q+1)/2` in the graph
> `P(q^2)`.
> 2. If `q = 3 (mod 4)`, then `Q_0 union {0}` and `Q_1 union {0}` are maximal cliques of size
> `(q+3)/2` in the graph `P(q^2)`.

BGSY26 restates the same result as its Propositions 1.1 and 1.2 (Section 1.6, p. 4), with the conic
description made explicit: `<omega>` is the set of points on the conic `x^2 - d y^2 = 1`, and `Q` is
half of them. Proposition 1.2 gives the linear-fractional map
`z -> eps^{-1}(1 + 2/(z-1))` carrying `Q` (resp. `Q union {0}`) onto the Baker et al. clique
`{x} union (x^perp cap L)` (resp. `{x, x^r} union (x^perp cap L)`) with `x = eps^{-1}`; that map is
the correspondence proved in GMS22.

Note for terminology: the maximal-clique size `(q+3)/2` appearing throughout this literature is
**not** the same number as the eigenfunction support `q+3` you are asking about. They are
unrelated quantities that happen to share the digits.

GKSV18, end of Section 3 (arXiv v1, p. 6), verbatim:

> An exhaustive computer search shows that the maximal cliques presented in [1] and the maximal
> cliques given by Theorem 1 are not the only maximal cliques of size `(q+1)/2` (`(q+3)/2`,
> respectively) in `P(q^2)`.

CGH24 is devoted to exactly those extras. Its abstract, verbatim:

> There is a conjecture that the second largest maximal cliques in Paley graphs of square order
> `P(q^2)` have size `(q+eps)/2`, where `q = eps (mod 4)`, and split into two orbits under the full
> group of automorphisms whenever `q >= 25` (a symmetric description for these two orbits is
> known). However, some extra second largest maximal cliques (of this size) exist in `P(q^2)`
> whenever `q in {9, 11, 13, 17, 19, 23}`. In this paper we analyse the algebraic and geometric
> structure of the extra cliques.

CGH24, Introduction, on the Baker et al. gap conjecture, verbatim:

> They proposed a conjecture that there are no maximal cliques of size `s` in `P(q^2)`, where
> `(q+eps)/2 < s < q` for `q = eps (mod 4)`.

### 5b. Induced structure on the oval `Q`: complete bipartite, not a crown graph

GKSV18, Lemma 8 (arXiv v1, p. 5), verbatim:

> **Lemma 8.** The following statements hold.
> (1) If `q = 1 (mod 4)`, then the graph induced by `Q` is a complete bipartite with parts `Q_0` and
> `Q_1`;
> (2) If `q = 3 (mod 4)`, then the graph induced by `Q` is a disjoint union of cliques `Q_0` and
> `Q_1`.

So the support of the known optimal eigenfunction induces `K_{(q+1)/2,(q+1)/2}` (for
`q = 1 (mod 4)`) or `2 K_{(q+1)/2}` (for `q = 3 (mod 4)`). Both are exactly the "isometric
distance-regular induced subgraph" that KMP16's equality condition predicts.

**Crown graphs (`K_{m,m}` minus a perfect matching, i.e. the bipartite double cover of `K_m`, also
called a cocktail-party complement) as induced subgraphs of `P(q^2)`: I found nothing.** Searched
domain and stop condition in the negatives section. What is in the literature is the *complete*
bipartite case above, plus general work on induced subgraphs of Paley graphs with prescribed
degree parity: Q. Li, Y. Zhou, "On induced subgraphs with degree parity conditions in Paley graphs
and Paley tournaments", arXiv:2512.19312, 22 Dec 2025 — that paper counts even/odd induced
sub(di)graphs and links them to MDS self-dual codes; it treats `P_q` for general `q`, has no
eigenfunction-support content, and does not mention crown graphs.

### 5c. Clique-difference eigenfunctions, and the `2q` support family

BGSY26, Section 1.3 ("Nets"), verbatim:

> The eigenvalues of a strongly regular net graph are `m(n-1)`, `n-m` and `-m` with multiplicities
> `1`, `m(n-1)` and `(n+1-m)(n-1)`, respectively. A basis for the `(n-m)`-eigenspace is given by
> the vectors `n chi_L - 1` (where `chi_L` is the characteristic function of the line `L`, and `1`
> the all-1 vector), if we pick `n-1` lines from each parallel class.

and, same section,

> The Paley graphs of order `r^2`, and the Peisert graphs of order `r^2` with `r = 3 (mod 4)` are
> special cases of this construction (with `m = (n+1)/2`).

For `P(q^2)` this means `n = q`, `m = (q+1)/2`, so the net eigenvalue `n - m = (q-1)/2` is exactly
`lambda_1 = (-1+q)/2`. Consequence (my arithmetic, from BGSY26's basis statement, not stated as a
theorem anywhere I found): differences `chi_{L_1} - chi_{L_2}` of two lines in the same parallel
class are `lambda_1`-eigenfunctions with support `2q`, and the whole `lambda_1`-eigenspace is
spanned by such line-indicator combinations. This is the only explicitly available family with
support strictly between `q+1` and `2q+1` that I located, and it sits at the top of your range.

The Delsarte-clique-pair recipe of EGS25 Theorem 1(1) does not produce anything smaller for
`P(q^2)`: two distinct lines of `AG(2,q)` meet in `0` or `1` point, so `|T_0| + |T_1|` is `2q` or
`2q-2`, both well above `q+1`. (Again my arithmetic from the quoted theorem; EGS25 does not
discuss Paley graphs.)

### 5d. Generalised Paley graphs

GSY23 extends the picture to `GP(q^2, m)` with `m | (q+1)`. Its abstract, verbatim:

> Let `GP(q^2, m)` be the `m`-Paley graph defined on the finite field with order `q^2`. We study
> eigenfunctions and maximal cliques in generalised Paley graphs `GP(q^2, m)`, where `m | (q+1)`.
> In particular, we explicitly construct maximal cliques of size `(q+1)/m` or `(q+1)/m + 1` in
> `GP(q^2, m)`, and show the weight-distribution bound on the cardinality of the support of an
> eigenfunction is tight for the smallest eigenvalue `-(q+1)/m` of `GP(q^2, m)`. These new results
> extend the work of Baker et. al and Goryainov et al. on Paley graphs of square order. We also
> study the stability of the Erdos-Ko-Rado theorem for `GP(q^2, m)` (first proved by Sziklai).

GSY23, Theorem 4.3 (arXiv:2203.16081v3, p. 16), verbatim:

> **Theorem 4.3.** Let `m >= 3` and `m | (q+1)`. The function `f_{Q_{i_1}, Q_{i_2}}` is a
> `(-(q+1)/m)`-eigenfunction of `GP(q^2, m)`, which has cardinality of support `2(q+1)/m` and thus
> meets the weight-distribution bound in view of Corollary 3.5.

where `f_{Q_{i_1},Q_{i_2}}` is `+1` on `Q_{i_1}`, `-1` on `Q_{i_2}`, `0` elsewhere, and
`Q_0, ..., Q_{m-1}` are the cosets of `<omega^m>` in the norm-1 group `<omega>`. Same shape as the
`m = 2` Paley case. The word "stability" in that abstract refers to stability of the
Erdos-Ko-Rado theorem (near-maximum independent sets), **not** to stability of eigenfunction
supports; do not read it as an answer to item 3.

*Applies to support exactly `q+3` with a Frobenius-odd `+/-1` function?* No; `2(q+1)/m` never
equals `q+3` for `m >= 2`.

## 6. Forward citations of GKSV18

Queried 2026-08-02.

**OpenAlex** (`W2781998433`, DOI `10.1016/j.ffa.2018.05.001`), `filter=cites:` — count 10:

| year | DOI | title |
|---|---|---|
| 2019 | `10.1016/j.disc.2019.01.015` | Minimum supports of functions on the Hamming graphs with spectral constraints |
| 2020 | `10.1016/j.disc.2020.112228` | Eigenfunctions and minimum 1-perfect bitrades in the Hamming graph |
| 2022 | `10.1016/j.disc.2022.112853` | On a correspondence between maximal cliques in Paley graphs of square order |
| 2022 | `10.1007/s10801-021-01113-y` | On maximal cliques of Cayley graphs over fields |
| 2023 | `10.1016/j.ffa.2022.102150` | On eigenfunctions and maximal cliques of generalised Paley graphs of square order |
| 2023 | `10.1016/j.disc.2023.113816` | Optimal functions with spectral constraints in hypercubes |
| 2024 | `10.1016/j.jcta.2024.105887` | Extremal Peisert-type graphs without the strict-EKR property |
| 2024 | `10.1090/proc/17035` | Distribution of power residues over shifted subfields and maximal cliques in generalized Paley graphs |
| 2025 | `10.1016/j.jalgebra.2025.07.016` | Positivity preservers over finite fields |
| 2025 | `10.1002/jcd.22001` | Tightness of the weight-distribution bound for strongly regular polar graphs |

**Semantic Scholar** (same DOI, `/citations`) — 17 citing papers, a strict superset of the
OpenAlex list once preprints are matched. The extra ones, all arXiv:

| year | arXiv | title |
|---|---|---|
| 2021 | 2102.11142 | Minimum supports of eigenfunctions of graphs: a survey |
| 2021 | 2103.09438 | Gauss sums and the maximum cliques in generalized Paley graphs of square order |
| 2023 | 2304.07157 | Do K33-free Latin squares exist? |
| 2024 | 2410.04024 | Second largest maximal cliques in small Paley graphs of square order |
| 2025 | 2503.09914 | Cliques in Paley graphs of square order and in Peisert graphs |
| 2025 | 2512.19312 | On induced subgraphs with degree parity conditions in Paley graphs and Paley tournaments |

**Crossref**: the `/works` route rejects `filter=reference.doi` ("filter-not-available"), so Crossref
cannot answer a cited-by query directly; **OpenCitations COCI** returned a non-JSON body (service
unavailable at query time). So the citation closure rests on two independent indexes, not three.
Given that the Semantic Scholar list strictly contains the OpenAlex list and adds all six known
recent Paley preprints, I consider the closure adequate but not triple-confirmed.

I opened or abstract-checked every one of the 17. None addresses second-minimum support,
stability of supports, or a classification of supports in `P(q^2)` above `q+1`.

---

## What is NOT in the literature

Each negative below lists the exact domain searched and the stop condition.

1. **A characterization of the minimum-support (`q+1`) eigenfunctions of `P(q^2)`.**
   Domain: SV21's own open-problem list (Problem 11, verbatim above, published 2021); the full
   forward-citation closure of GKSV18 from OpenAlex (10) and Semantic Scholar (17), each entry's
   title and abstract inspected; arXiv API abstract search
   `abs:"Paley" AND abs:"eigenfunction"`, all time, 16 hits, of which only arXiv:1801.00438 and
   arXiv:2203.16081 are on topic. Stop condition: no citing or independent work claims a solution;
   Problem 11 stands open as of 2026-08-02.

2. **Any second-minimum-support result for `P(q^2)`** (the smallest support strictly above `q+1`).
   Domain: as in (1), plus the arXiv full-text search
   `all:"Paley graph" AND all:"minimum support"` (0 hits) and targeted web searches on
   "second minimum support" with the Valyuzhenich/Vorob'ev/Krotov author set. Stop condition: the
   only second-minimum-style work in this school is for Hamming graphs and hypercubes via eigenspace
   sums `U_{[i,j]}`, never for Paley graphs; SV21's Paley open-problem list contains no such
   problem.

3. **Any stability or gap theorem** of the form "every `lambda_i`-eigenfunction of `P(q^2)` with
   `|S(f)| < C q` has the following form". Domain: as in (2). Stop condition: the only occurrence of
   "stability" in the retrieved Paley corpus is GSY23's Erdos-Ko-Rado stability (near-maximum
   independent sets in `GP(q^2,m)`), a different statement; no eigenfunction-support stability
   result exists for any Paley graph.

4. **Any construction, classification, or non-existence statement for eigenfunction supports of
   size `q+2`, `q+3`, ..., `2q-1` in `P(q^2)`, for either non-principal eigenvalue.**
   Domain: as in (2), plus full-text grep of the seven cached PDFs for support-size statements.
   Stop condition: the only support cardinalities appearing anywhere are `q+1` (GKSV18 Theorem 2,
   optimal), `2(q+1)/m` for `GP(q^2,m)` (GSY23 Theorem 4.3), and `2q` implicit in BGSY26's net
   eigenbasis. Nothing in between is discussed. **Support `q+3` is neither realized nor forbidden
   in the retrieved literature.**

5. **Any treatment of eigenfunctions of `P(q^2)` that are anti-invariant under the subfield
   Frobenius `z -> z^q` (`f(z^q) = -f(z)`), or invariant, or supported off `F_q`.**
   Domain: full-text grep of the seven cached PDFs for `Frobenius`, `z^q`, `x^r`, `subfield`, plus
   the searches in (1)-(3). Stop condition: `grep -i frobenius` over the seven cached extractions
   returns zero hits in GKSV18, GSY23, CGH24 and GMS22, five hits in SV21 that are all
   "Perron-Frobenius" or the bibliography entry for G. Frobenius, and one hit in BGSY26 that reads
   "or that of Frobenius groups" — i.e. no occurrence in the relevant sense anywhere. The Frobenius
   map itself appears only as an element of `Aut(P(q^2))` (Carlitz) and inside the BEHW96 clique
   `{x, x^q} union (x^perp cap C)`; no source imposes a symmetry condition on an eigenfunction. The observation that the known optimal
   function is Frobenius-*even* is my derivation from the quoted definitions, not a cited result.

6. **Any result treating `+/-1`-valuedness of a Paley eigenfunction as a hypothesis.**
   Domain: as in (5). Stop condition: all known extremal Paley eigenfunctions are `+/-1`-valued as
   an output of the construction; the bitrade framework that would make `+/-1`-valuedness a
   hypothesis (KMP16, SV21 Sections 2-4) is developed only for Hamming/Johnson-type graphs.

7. **Crown graphs (`K_{m,m}` minus a perfect matching) as induced subgraphs of `P(q^2)`.**
   Domain: web search on the combination of "Paley graph" with "crown graph",
   "K_{m,m} minus a perfect matching", and "cocktail party"; full-text grep of the seven cached
   PDFs for `crown`, `cocktail`, `matching`, `bipartite`. Stop condition: the only induced bipartite
   structure named in this corpus is the *complete* bipartite `K_{(q+1)/2,(q+1)/2}` on the oval
   `Q` (GKSV18 Lemma 8(1)); `grep -i "crown\|cocktail"` returns zero hits across all eight cached
   extractions (the seven above plus arXiv:2512.19312), and the term does not occur in any
   retrieved Paley source.

8. **Triple-index confirmation of the forward-citation count.** Crossref's `/works` route does not
   support `filter=reference.doi`, and OpenCitations COCI was unreachable at query time, so the
   closure in Section 6 is two-index (OpenAlex + Semantic Scholar), not three. Treat the "no work
   solves Problem 11" claim as strong but not exhaustively index-confirmed.
