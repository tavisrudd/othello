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

---

# Follow-up (same day): unconditional bounds on non-line cliques of `P(q^2)`

Numbered **7** rather than 6 because §6 above is already the forward-citation section; the
coordinator's requested title is kept.

## 7. Unconditional bounds on cliques of `P(q^2)` not contained in a line

Setting: a clique of `P(q^2)` is a set `C` with `C - C` inside the squares together with `0`.
"Line" = image `a F_q + b` of the subfield with `chi(a) = 1`, equivalently a line of the affine
plane `AG(2,q)` with square direction; these are exactly the Delsarte cliques, of size `q`.
Question: the best explicit `f(q)` in a theorem "a clique of `P(q^2)` either lies in a line or has
size at most `f(q)`".

### 7.0 Short answer

**`f(q) = q - 1`, and nothing better is known.** That bound is just the contrapositive of
Blokhuis's theorem. Every stability improvement in the literature requires edge density strictly
below `1/2`, i.e. `m >= 3` in `GP(q^2, m)`, and therefore excludes the Paley graph itself. The
authors closest to the problem say so in print, twice, in 2022 and 2023 (quoted in 7.3).

### 7.1 The one unconditional theorem: Blokhuis, and its modern reproofs

A. Blokhuis, "On subsets of `GF(q^2)` with square differences", *Nederl. Akad. Wetensch. Indag.
Math.* **46** (1984), no. 4, 369-372. As restated by Yip (arXiv:2505.04061v2, §1, verbatim):

> The well-known Van Lint-MacWilliams' conjecture states that if `q` is an odd prime power, and
> `A subset F_{q^2}` such that `0, 1 in A`, `|A| = q`, and `a - b` is a square for each `a, b in A`,
> then `A` must be the subfield `F_q`.

and as restated by Brouwer-Goryainov-Shalaginov-Yip (arXiv:2503.09914v2, §1.5, verbatim):

> Blokhuis [4] showed for Paley graphs of square order `q = r^2` that the only cliques of size `r`
> are lines of the underlying affine plane of order `r` (images `aF + b` of the subfield
> `F = F_r`, where `a` is a nonzero square).

Contrapositive, which is the answer to the coordinator's question: a clique of `P(q^2)` not
contained in a line has size at most `q - 1`. This is `f(q) = q - 1` and it is unconditional.

Sziklai's extension (P. Sziklai, "On subsets of `GF(q^2)` with `d`th power differences", *Discrete
Math.* **208/209** (1999) 547-555, Theorem 1.2) covers `d | (q+1)`, `d >= 2`, and gives the same
`|A| = q` conclusion; Goryainov-Shalaginov-Yip state it as their Lemma 1.1
(arXiv:2203.16081v3, p. 2), verbatim:

> **Lemma 1.1** ([3], [21, Theorem 1.2]). Let `q` be an odd prime power and `m` a divisor of
> `(q + 1)` such that `m > 1`, then in the generalised Paley graph `GP(q^2, m)`, the only maximum
> clique containing `0, 1` is the subfield `F_q`; in particular, each maximum clique in
> `GP(q^2, m)` is the image of the subfield `F_q` under an affine transformation.

Two recent reproofs, both still about `|A| = q` exactly and therefore giving nothing below `q`:

- S. Asgarli, C. H. Yip, "Van Lint-MacWilliams' conjecture and maximum cliques in Cayley graphs
  over finite fields", *J. Combin. Theory Ser. A* **192** (2022), Paper No. 105667, 23 pp.;
  arXiv:2106.01522. Theorem 1.3 (verbatim): "Let `n >= 2` be an integer and `epsilon > 0` a real
  number. Let `X = Cay(F^+_{q^2}, S)` be a Peisert-type graph, where `q = p^n` and
  `p > 4.1 n^2 / eps^2`. Suppose that there is a nontrivial multiplicative character `chi` of
  `F_{q^2}`, such that the set `{chi(x) : x in S}` is `eps`-lower bounded. Then in the Cayley graph
  `X`, the only maximum clique containing `0, 1` is the subfield `F_q`."
- C. H. Yip, "Van Lint-MacWilliams' conjecture and maximum cliques in Cayley graphs over finite
  fields, II", *J. Combin. Theory Ser. A* (2026); arXiv:2505.04061v2, 14 Jan 2026. Theorem 1.1
  (verbatim): "Let `S subset F*_{q^2}` with `S = -S` such that
  `|SSSS^{-1}S^{-1}S^{-1}| <= (q^2-1)/2` or `|SS^{-1}S^{-1}F*_q| <= (q^2-3)/2`. If
  `A subset F_{q^2}` with `|A| = q` and `0, 1 in A` such that `A - A subset S union {0}`, then `A`
  is the subfield `F_q`." Corollary 1.3 recovers Blokhuis and Sziklai. Every hypothesis fixes
  `|A| = q`; there is no statement about `|A| < q`, and the words "stability", "second largest" and
  "Baker" do not occur in the paper (verified by grep over the full text).

Also checked and not applicable: C. H. Yip, "Maximality of subfields as cliques in Cayley graphs
over finite fields", *Algebraic Combinatorics* **6** (2023), no. 4, 901-905,
DOI `10.5802/alco.291` — proves `F_q` is a *maximal* clique in various graphs, i.e. a lower-bound
direction, not an upper bound on other cliques.

### 7.2 Hanson-Petridis: prime order only, does not touch square order

B. Hanson, G. Petridis, "Refined estimates concerning sumsets contained in the roots of unity",
*Proc. London Math. Soc.* (3) **122** (2021), no. 3, 353-358, DOI `10.1112/plms.12322`; preprint
arXiv:1905.09134v3. Abstract, verbatim:

> We prove that the clique number of the Paley graph is at most `sqrt(p/2) + 1`, and that any
> supposed additive decompositions of the set of quadratic residues can only come from co-Sidon
> sets.

This is the Paley graph of **prime** order `p`, where the clique number is conjecturally around
`log p` and the trivial bound is `sqrt(p)`. For square order `q^2` the clique number is exactly
`q = sqrt(q^2)`, so the Hanson-Petridis inequality is an equality there and carries no information;
it gives no bound on non-line cliques. Their *method* (Stepanov / polynomial-method style estimates
for sumsets in roots of unity) is what Asgarli-Yip adapted in arXiv:2106.01522, and that adaptation
lands exactly on the `|A| = q` statement quoted in 7.1 — not below `q`.

Related and also not applicable: C. H. Yip, "Gauss sums and the maximum cliques in generalized
Paley graphs of square order", arXiv:2103.09438v2 (published in *Finite Fields Appl.*), whose
result is that the trivial bound `sqrt(q)` on `omega(GP(q,d))` is tight **iff** `d | (sqrt(q) + 1)`
— a statement about when maximum cliques of size `q` exist at all, not about the next size down.
C. H. Yip, "On the clique number of Paley graphs of prime power order" concerns non-square orders
and gives no `P(q^2)` content.

### 7.3 The stability literature, and why every piece of it excludes `m = 2`

This is the decisive negative, and it is stated explicitly by the authors themselves.

**(a) Sziklai's stability theorem needs `m >= 3`.** Goryainov-Shalaginov-Yip, Lemma 1.2
(arXiv:2203.16081v3, p. 2), verbatim:

> **Lemma 1.2** ([21, Theorem 1.3]). Let `q` be an odd prime power and `m` a divisor of `(q + 1)`
> such that `m >= 3`. If `C` is a clique in the generalised Paley graph `GP(q^2, m)`, such that
> `0, 1 in C`, and `|C| > q - (1 - 1/m) sqrt(q)`, then `C subset F_q`.

Reference [21] is Sziklai (1999), Theorem 1.3. Note the hypothesis `m >= 3`. If one formally
substituted `m = 2` the threshold would read `|C| > q - sqrt(q)/2`. The next paragraph of GSY23
(p. 3) says in terms exactly on point, verbatim:

> Lemma 1.2 is a consequence of the stability of the direction set determined by point sets in the
> affine plane `AG(2, q)` (see [22, Theorem 4] and [21, Theorem 3.1]). It is conjectured that the
> lower bound on `|C|` can be improved significantly. In particular, when `m = 2`, it is conjectured
> in [4, 10, 11] that there is no maximal clique with size between `(q+3)/2` and `q` (exclusive).
> Equivalently, in the case `m = 2`, it is conjectured that the lower bound on `|C|` can be improved
> to `(q+3)/2`; **however, even the weaker bound `q - sqrt(q)/2` stated in Lemma 1.2 is not known to
> be true.**

(Emphasis mine.) So the `m = 2` case of the Sziklai-type stability bound — `f(q) = q - sqrt(q)/2`,
which would be the weakest imaginable improvement on `q - 1` — is open. `[4]` is Baker-Ebert-
Hemmeter-Woldar, `[10]` is GKSV18, `[11]` is GMS22.

**(b) Yip says no partial progress exists.** C. H. Yip, "Erdős-Ko-Rado theorem in Peisert-type
graphs", *Canad. Math. Bull.* (2023); arXiv:2302.00745v3, §1, p. 2, verbatim (he writes `ST(k)`
for "each clique of size at least `q - k` is contained in a canonical clique"):

> One widely open conjecture, due to by Baker, Ebert, Hemmeter, and Woldar [3], states that the
> second largest maximal clique in the Paley graph with order `q^2` has size `(q + r(q))/2`, where
> `r(q) = 1` or `3`, depending on `q` modulo 4. In other words, Paley graphs of order `q^2` has the
> property `ST((q - r(q))/2 - 1)`. **To the best knowledge of the author, no partial progress has
> been made for this conjecture.** For `d`-Paley graphs of order `q^2` with `d >= 3`, Sziklai
> [19, Theorem 1.3] showed they have the property `ST(c sqrt(q))` for some positive constant `c`
> (depending on `d`); we refer to [2, Corollary 4.4] and [13, Section 6] for some generalization and
> improvement on his results. **However, all known results in this direction assume the edge density
> of the graph being strictly less than 1/2.** In general, such type of stability questions is
> widely open for Peisert-type graphs.

(Emphasis mine.) `P(q^2)` has edge density exactly `1/2`, so it falls outside every result named
there. This is a 2023 peer-reviewed statement by the most active author in the area, and I found
nothing published since that changes it.

**(c) The two named improvements, checked individually against `m = 2`.**

- Asgarli-Yip, arXiv:2106.01522, Corollary 4.4, verbatim: "Under the same assumptions as in
  Theorem 1.3, if `|S| < (q^2-1)/2`, then for any clique `C` in `X` with
  `|C| > q - 1 - (sqrt(q))/(m) sqrt(q)`" — the OCR of the displayed fraction is unreliable, but the
  gating hypothesis is unambiguous: `|S| < (q^2-1)/2`. For `P(q^2)` the connection set is the set of
  nonzero squares, `|S| = (q^2-1)/2` exactly, so the hypothesis fails. Excluded.
- Goryainov-Shalaginov-Yip, §6 "Stability of canonical cliques". Theorem 6.1
  (arXiv:2203.16081v3, p. 29), verbatim: "Let `m | (q+1)` and `2 <= m <= (q+1)/3`. If `C'` is a
  maximal clique in the generalised Paley graph `GP(q^2, m)` which is not maximum, then
  `|C'| <= ((q+1)/m - 1)^2`; moreover, if `p` does not divide `(m-1)` and `m <= (q+1)/4`, then
  `|C'| <= 1 + (q+1)/m ((q+1)/m - 3)`." Corollary 6.2, verbatim: "Assume `m > (q+1)/sqrt(q+1)` and
  `m | (q + 1)`. If `C` is a clique in the generalised Paley graph `GP(q^2, m)` such that
  `0, 1 in C` and `|C| > ((q+1)/m - 1)^2`, then `C subset F_q`. Moreover, if `p` does not divide
  `(m-1)` and `m <= (q+1)/4`, then the previous statement holds for `|C'| > 1 + (q+1)/m((q+1)/m-3)`."

  Theorem 6.1 *does* formally admit `m = 2`, but it is vacuous there: with `w = (q+1)/m = (q+1)/2`
  the bound `(w-1)^2 = ((q-1)/2)^2` is quadratic in `q`, far above the trivial `q`, and the refined
  `1 + w(w-3)` is likewise quadratic (my arithmetic from the quoted statement). Corollary 6.2, the
  useful one, requires `m > sqrt(q+1)`, which excludes `m = 2` for every `q >= 4`. GSY23 says this
  in its own words on p. 3, verbatim: "We provide a significant improvement on Lemma 1.2 in
  Corollary 6.2, provided that `m > sqrt(q)`." So GSY23 contributes nothing to `P(q^2)`.
- Asgarli, Goryainov, Lin, Yip, "The EKR-Module Property of Pseudo-Paley Graphs of Square Order",
  *Electron. J. Combin.* **29** (2022), no. 4, Paper 4.33, Corollary 8, as quoted in Yip
  arXiv:2302.00745v3 Theorem 2.2, verbatim: "If `q > (m - 1)^2`, then all maximum cliques [in a
  Peisert-type graph of type `(m,q)`] are canonical." For `P(q^2)`, `m = (q+1)/2` and
  `q > ((q-1)/2)^2` fails for `q >= 5`. Excluded, and in any case it is again a statement about
  maximum cliques only.

### 7.4 The one unconditional structural partial result I did find

Brouwer-Goryainov-Shalaginov-Yip, arXiv:2503.09914v2, Theorem 2.1 (§2, p. 6), verbatim:

> **Theorem 2.1** Let `r` be a power of the prime `p`, and consider a Desarguesian net of order `r`
> and degree `m`. If `L` is a line and `x` a point outside, then the clique `{x} union (x^perp cap L)`
> in the collinearity graph of the net is contained in a unique maximal clique `C_{x,L}`. Moreover,
> when `p` does not divide `(m - 1)`, if `{x} union (x^perp cap L)` is not maximal, then `C_{x,L}`
> is contained in the union `L union M` of two lines, where `M` is a unique line passing through `x`.

and Proposition 2.5 (§2, p. 8), verbatim:

> **Proposition 2.5** Let `2 < m < r - 1`. One has `|C_{x,L}| = m - 1 + h p^f` where `h` is a
> positive integer such that `h | gcd(r - 1, m - 2, p^f - 1)`, and `f` is a nonnegative integer such
> that `p^f | gcd(r, m - 1)`.

Specialization to `P(r^2)` (my arithmetic, not stated in the paper): the Paley graph is the
Desarguesian net of order `r`, degree `m = (r+1)/2`, so `m - 1 = (r-1)/2`; since `r` is a power of
`p` we have `gcd(r, (r-1)/2) = 1`, forcing `p^f = 1`, hence `|C_{x,L}| = (r-1)/2 + h` with
`h | gcd(r-1, (r-3)/2)`. Also `p` never divides `m - 1 = (r-1)/2` for `r` a power of `p`, so the
second clause of Theorem 2.1 always applies to the Paley case. Taking `h = 1` and `h = 2` recovers
the Baker et al. sizes `(r+1)/2` and `(r+3)/2`.

This is unconditional and explicit, but it constrains only maximal cliques that contain a whole
configuration `{x} union (x^perp cap L)` — a point together with all `(r-1)/2` of its neighbours on
some line. It says nothing about a clique that meets every line in fewer points. It is the only
thing I found that could reasonably be called partial progress toward the gap conjecture, and even
BGSY26 does not present it as such.

### 7.5 What exactly is proved, versus computer-verified

**Proved:**
- A clique of `P(q^2)` of size `q` is a line (Blokhuis 1984; reproved by Asgarli-Yip 2022 and Yip
  2026). Hence non-line cliques have size `<= q - 1`.
- `{x} union (x^perp cap C)` for `x` outside a line `C` is a maximal clique of size `(q+1)/2` when
  `q = 1 (mod 4)`, and `{x, x^q} union (x^perp cap C)` is maximal of size `(q+3)/2` when
  `q = 3 (mod 4)` and `C = F_q` (Baker-Ebert-Hemmeter-Woldar 1996; alternative proof in BGSY26 §2).
- `Q_0` (resp. `Q_0 union {0}`) is a maximal coclique of size `(q+1)/2` (resp. maximal clique of
  size `(q+3)/2`) (GKSV18 Theorem 1), and the two families correspond under an explicit linear
  fractional map (GMS22; BGSY26 Propositions 1.1-1.2).
- The structural results of BGSY26 §2 quoted in 7.4.

**Not proved, only conjectured:** that `(q + r(q))/2` is the second largest clique size, i.e. that
there is no maximal clique of size strictly between `(q + r(q))/2` and `q`; and that there are
exactly two orbits at that size for `q >= 25`. CGH24, §1, gives the original form, verbatim:

> They proposed a conjecture that there are no maximal cliques of size `s` in `P(q^2)`, where
> `(q + eps)/2 < s < q` for `q = eps (mod 4)`.

**Computer verification — exactly what, by whom, over what range:**

1. BEHW96 themselves ran an exhaustive search; GKSV18 (arXiv v1, p. 1) reports only its conclusion,
   verbatim: "an exhaustive computer search done by them showed that these cliques are not the only
   cliques of such size". No range is given in the text I read.
2. GKSV18 (published FFA version) used **Magma**. I did not see this in the arXiv v1; it is reported
   by CGH24, §1, verbatim: "By Magma [3], they found that for `25 <= q <= 83`, the graph `P(q^2)`
   contains exactly two non-equivalent (under the action of the automorphism group) maximal cliques
   of size `(q+eps)/2` for `q = eps (mod 4)`, and these cliques are the second largest."
   **Evidence boundary:** this is a second-hand attribution; I read the arXiv v1 of GKSV18, not the
   published FFA text, so I did not verify the `25 <= q <= 83` range at source.
3. CGH24 computed the number of orbits of maximal cliques of size `(q+eps)/2` for `q <= 23` (citing
   GKSV18 for the table) and analysed the extra orbits, which occur exactly for
   `q in {9, 11, 13, 17, 19, 23}` — note this range includes the prime powers `9` and `27` is
   outside it, so the small-`q` exceptions are a mix of primes and one prime power.
4. BGSY26, §1.6, verbatim: "One conjectures that this size (`(r+1)/2` if `r = 1 (mod 4)` or
   `(r+3)/2` if `r = 3 (mod 4)`) is the second largest size for cliques in `P(r^2)`, and that there
   are only two orbits of cliques of this size when `r >= 25`. This conjecture has been checked for
   `r <= 109`." **The paper gives no attribution, no method, and no software for the `r <= 109`
   check, and does not say whether `r` ranges over prime powers or only primes.** Its published
   tables are smaller: §3.1 tabulates all maximal clique sizes with orbit counts only for
   `r <= 47`, and the smallest-maximal-clique table runs to `r <= 73`. Both tables do include prime
   powers (`9, 25, 27, 49` appear), so the convention in the paper is prime powers; I could not
   confirm that the `109` figure follows the same convention.

The §3.1 table of BGSY26 is worth recording directly, because it answers the `q = 1 (mod 4)` case
of your question empirically. Sizes of maximal cliques in `P(r^2)`, exponents = number of
inequivalent orbits under the full automorphism group (verbatim transcription of BGSY26 Table,
§3.1, for the `r = 1 (mod 4)` rows):

| `r` | maximal clique sizes (exponent = orbit count) | `(r+1)/2` | is `(r+3)/2` present? |
|---|---|---|---|
| 5 | `3^1, 5^1` | 3 | 4: no |
| 9 | `5^3, 9^1` | 5 | 6: no |
| 13 | `5^10, 7^4, 13^1` | 7 | 8: no |
| 17 | `5^3, 7^41, 9^9, 17^1` | 9 | 10: no |
| 25 | `7^405, 8^226, 9^49, 13^2, 25^1` | 13 | 14: no |
| 29 | `7^410, 8^1584, 9^2104, 10^148, 11^46, 13^1, 15^2, 29^1` | 15 | 16: no |
| 37 | `7^103, 8^2505, 9^21556, 10^14002, 11^5712, 12^219, 13^222, 19^2, 37^1` | 19 | 20: no |
| 41 | `7^168, 8^7801, 9^104495, 10^62070, 11^9583, 12^149, 13^128, 14^19, 21^2, 41^1` | 21 | 22: no |

So for `q = 1 (mod 4)` and `q <= 41`, `P(q^2)` contains **no maximal clique of size `(q+3)/2` at
all** — and since every clique extends to a maximal one, no clique of that size that is not inside
a larger one; the sizes present jump from a band around `sqrt(q)`-ish values straight to `(q+1)/2`
and then to `q`. This is data, not a theorem. BGSY26 also notes for the `r = 3 (mod 4)` rows: "For
`r = 3 (mod 4)` this confirms the values from Kiermaier & Kurz [13]."

### 7.6 What is NOT in the literature (this section's negatives)

9. **Any theorem "a clique of `P(q^2)` either lies in a line or has size at most `f(q)`" with
   `f(q) < q - 1`.** Domain: Blokhuis 1984 and both modern reproofs (arXiv:2106.01522,
   arXiv:2505.04061); Sziklai 1999 Theorems 1.2 and 1.3 as restated in GSY23 Lemmas 1.1-1.2 and in
   Yip arXiv:2302.00745 §1; GSY23 §6 in full; Asgarli-Yip Corollary 4.4; Asgarli-Goryainov-Lin-Yip
   Corollary 8; Hanson-Petridis 2021; Yip's Gauss-sums paper; Yip's `alco.291`. Stop condition: two
   independent explicit statements by the authors of the field that nothing better is known — GSY23
   p. 3 ("even the weaker bound `q - sqrt(q)/2` ... is not known to be true") and Yip
   arXiv:2302.00745 p. 2 ("no partial progress has been made for this conjecture ... all known
   results in this direction assume the edge density of the graph being strictly less than 1/2").

10. **A Blokhuis-type stability statement "cliques of size `> c q` in `P(q^2)` lie in a line" for
    any explicit `c < 1`.** Domain: as in (9). Stop condition: the only thresholds that exist are
    `q - (1 - 1/m) sqrt(q)` for `m >= 3` (Sziklai), which is of the form `q - O(sqrt q)` rather than
    `c q`, and is unavailable at `m = 2`. No result of the form `c q` with `c < 1` exists for any
    `m`, let alone for Paley.

11. **A stability or second-largest version of Sziklai's `d`-th power theorem covering `d = 2`.**
    Domain: Sziklai 1999 Theorem 1.3 as restated in GSY23 Lemma 1.2 and Yip arXiv:2302.00745 §1;
    GSY23 §6; Asgarli-Yip Corollary 4.4. Stop condition: every restatement carries the hypothesis
    `m >= 3` / `d >= 3` / density `< 1/2`. I did not read Sziklai's 1999 paper at source (Discrete
    Math. 208/209, not open access, not in the cache); the `m >= 3` hypothesis is taken from two
    independent restatements by different author sets, which agree.

12. **An unconditional partial result toward the Baker et al. gap conjecture in BGSY26.** Domain:
    full text of arXiv:2503.09914v2. Stop condition: its §2 results (Theorem 2.1, Propositions
    2.2-2.6, Theorems 2.7 and 2.10, Corollary 2.8) all concern the specific maximal cliques
    `C_{x,L}` built from a point plus its neighbours on a line, and its §1.6 presents the gap
    statement as a conjecture "checked for `r <= 109`", not as a theorem.

### Answer to the closing question

**Is there an unconditional theorem forbidding a non-line clique of size `(q+3)/2` in `P(q^2)` for
`q = 1 (mod 4)`?** No — the best unconditional bound on a non-line clique is `q - 1` (Blokhuis's
theorem, contrapositive), every stability improvement in print requires edge density strictly below
`1/2` and so excludes the Paley graph, and Goryainov-Shalaginov-Yip state in print that even the
much weaker threshold `q - sqrt(q)/2` is not known for `m = 2`; the non-existence of such a clique
is supported only by the Baker-Ebert-Hemmeter-Woldar conjecture and by exhaustive computation
(orbit-complete for `r <= 47` in BGSY26 §3.1, and asserted without attribution for `r <= 109`).
