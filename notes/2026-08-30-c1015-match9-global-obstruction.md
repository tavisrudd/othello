# C1015 — global obstruction beyond the six-local matching test

**Lane:** `relconic`

**Status:** The ten-point theorem is now universal: every geometrically
transversal one-factorization of (K_{10}) is a pencil, over every field.
For the regular matching design this forces every canonical
one-factorization line, after which Nagy's theorem gives the exact field
boundary. The nine-point extension and broader priority audit remain open;
the closest-seed forward-citation sweep is closed. No manuscript, summary,
mirror, formal, release, or Ergodis source edits are authorized.

Literature depth for the sources added or reused in this report: **two were
read at full-text depth** (Nagy and Korchmaros--Pace--Sonnino); Tohaneanu--Xie,
Dinitz--Garnick--McKay, Gelling, Ziegler, and Kiss--Korchmaros--Romaniello--
Smaldore were read at the explicitly recorded partial depths below. The
priority verdict remains bounded and provisional.

## Starting point

C1003 classified the four simple `MATCH(9,4,1)` designs over arbitrary
fields. Exactly one odd-characteristic representative passes the C1002/C1008
test on every six-set. Seven concurrence equations admit the human reduction

\[
-\frac{2(r-1)^2}{r^2}=0,
\]

where the frame arc inequalities give `r!=0,1`; this also explains the
characteristic-two degeneration. Exact elimination independently yields
`x_8^2(x_8-1)^2`. The replay is
`notes/c1003_match9_rank_three.py`; the publication and literature context is
`notes/2026-08-30-c1003-matching-design-publication-routing.md`.

## Objective

Make the ratio defect projectively intrinsic and determine the strongest
reusable theorem it supports. The preferred outcome is a global compatibility
or holonomy invariant forced by rank-three chord concurrency and strictly
refining all six-local tests.

## Literature correction and priority ceiling

Nagy, _Embeddings of Ree unitals in a projective plane over a field_, proves
that the Ree unital `R(3)` embeds in `PG(2,K)` if and only if `F_8` is a
subfield of `K`, and then the embedding is unique and contained in an
order-eight subplane. In the regular-hyperoval model its 63 dual points are
exactly the 63 perfect-matching centers. Its 28 dual lines are exactly the 28
one-factorizations of `K_10`, each collecting nine matching centers.

The C1003 replay now verifies this intrinsically: the regular matching design
has exactly 28 one-factorizations, each block occurs in four, and each pair of
factorizations shares exactly one block, giving a `2-(28,4,1)` design. The
nonhyperoval class has only one one-factorization. The identification of the
regular incidence design with `R(3)` uses Nagy's external-point/external-line
model; the count and intersection parameters are exact internal computation.

Our realization hypothesis does not assume those nine-point sets collinear;
it assumes only that each perfect matching is realized by concurrent secants.
Thus the first priority question is now the **Ree bridge**:

> Does every rank-three realization of the regular `MATCH(10,5,1)` design, or
> either of its nine-point deletions, force the nine centers in each canonical
> one-factorization to be collinear?

If yes, Nagy's theorem replaces the entire regular-class coordinate
classification and adds uniqueness, admissibility, and subplane containment.
The publishable contribution would be the automatic completion from secant
concurrences to the Ree-unital line structure, not the already classical `F_8`
boundary. Nagy's odd-characteristic factor `2` and characteristic-two cubic
`v^3+v^2+1` closely parallel the C1003 calculation; checking whether the seven
blocks are a literal super O'Nan shadow is mandatory before a novelty claim.

## Landed judo theorem: Hamilton pairs force pencils

Let (K) be a field, let (L_0,\ldots,L_{2m-1}) be lines in
\(\operatorname{PG}(2,K)\) with no three concurrent, and let \(\mathcal F\)
be a one-factorization of (K_{2m}). Suppose that for every factor
\(M\in\mathcal F\) there is a transversal (T_M) containing all (m) star
points (L_i\cap L_j) with (ij\in M).

**Star-factorization interpolation theorem.** Choose defining forms
\(\ell_i,t_M\), put (P=\prod_i\ell_i) and
\(Q=\prod_{M\in\mathcal F}t_M\). There are nonzero scalars (c_i), unique
up to common scaling, such that

\[
 Q=\sum_i c_i\frac{P}{\ell_i}.
\]

For every edge (ij\in M), restriction to (T_M) and cancellation of the
two simple poles at (L_i\cap L_j) give

\[
 t_M\ \doteq\ c_j\ell_i+c_i\ell_j.
\]

Here \(\doteq\) means equality up to a nonzero scalar. Equivalently, after
putting (u_i=\ell_i/c_i),

\[
 t_M\ \doteq\ u_i+u_j \qquad(ij\in M).                 \tag{1}
\]

This is a self-contained degree-((2m-1)) interpolation identity. On (L_i),
(Q) and (P/\ell_i) have the same (2m-1) distinct zeros, so their
restrictions are proportional. Subtracting all resulting terms gives a form
of degree (2m-1) divisible by all (2m) lines, hence zero. None of the
constants vanishes because no transversal can equal a carrier line.

**Hamilton-pair parity theorem.** Suppose (A,B\in\mathcal F) form a
Hamilton cycle. Set (W=\langle t_A,t_B\rangle), start the alternating cycle
at vertex (0), and let (x) have cycle distance (r) from (0). If (M_x)
is the factor containing (0x), normalize its defining form by
\(t_{M_x}=u_0+u_x\). Then

\[
 t_{M_x}\equiv \bigl(1+(-1)^r\bigr)u_0\pmod W.        \tag{2}
\]

Indeed, (1) along each alternating edge says
\(u_{r+1}\equiv-u_r\pmod W\), and the edge (0x) says
\(t_{M_x}\doteq u_0+u_x\). Thus in every characteristic the factor centers
split into two parity layers modulo the pencil generated by (A,B). In
characteristic two the layers collapse, every (t_M\in W), and all
transversals (T_M) are concurrent. Dually, all matching centers are
collinear.

There is also an all-characteristic amplification. Each Hamilton pair forces
the (m) factors indexed by odd-distance vertices onto its pencil. If a
family of these (m)-sets has connected closure under union of sets sharing
two factor labels, then their pencils coincide and **all** transversals are
concurrent over an arbitrary field. This is a purely combinatorial closure
test placed on top of (2).

This has two useful general forms.

1. Every geometrically transversal one-factorization over a field of
   characteristic two that contains a perfect pair has all its transversals
   in one pencil. In particular this holds for every geometrically realized
   perfect one-factorization.
2. Fix vertex (0), label a factor by its partner (k) at (0), and attach
   the triple \(\{i,j,k\}\) whenever (ij\in M_k\). In characteristic two,
   (1) makes the three corresponding transversal forms collinear in their
   parameter plane. Therefore it is enough that these triples have connected
   closure under union of triples sharing two labels. A Hamilton pair implies
   this closure condition, but is not necessary.

The factor (2) in (2) is the invariant mechanism behind the odd/characteristic-
two split seen in the seven-concurrence calculation. It replaces a normalized
ratio accident by a projective parity holonomy.

## Universal order-ten pencil theorem

The Hamilton-pair theorem admits a complete order-ten closure.

> **Theorem.** Let (L_0,\ldots,L_9) be ten lines in
> \(\operatorname{PG}(2,K)\) with no three concurrent. If the edges of
> (K_{10}) admit a one-factorization such that the five star points belonging
> to every factor are collinear, then the nine factor transversals form a
> pencil. This holds over every field and for every one-factorization of
> (K_{10}).

For each pair of factors and each choice of base carrier, (2) places the
factors indexed by the odd vertices of the base cycle on one line in the
parameter plane of transversal forms. Exact canonical enumeration of all 396
one-factorizations gives the following dichotomy.

- In 395 classes, these parity subsets have connected two-point-overlap
  closure on all nine factors, so the pencil conclusion is immediate.
- The unique remaining class has no Hamilton pair: every factor pair has
  cycle type (4+6). Its parity constraints are the twelve triples of the
  Steiner triple system (AG(2,3)) on the nine factor forms. Adding any other
  collinear triple makes the two-point closure all nine, so a non-pencil
  realization would have to be an exact projective representation of
  (AG(2,3)). Ziegler's classical coordinatization says that such a
  representation exists precisely when the field contains a root of
  \(\omega^2-\omega+1\); it is not restricted to characteristic three.
  The exceptional factorization itself has the transparent affine form
  \[
  M_a=\{\{\infty,a\}\}\cup
      \{\{x,y\}:x+y=-a\},\qquad a\in\mathbf F_3^2,
  \]
  and automorphism-group order 432. Thus the appearance of the affine-plane
  shadow is structural, not an accidental isomorphism found after the census.
  Substituting his nine Hesse points into the 45 lift equations
  \(u_i+u_j=\lambda_{ij}t_M\) gives a 135-by-75 matrix over
  \(\mathbf Z[\omega]\). Exact elimination selects a full minor with
  determinant

  \[
  -8(1+\omega),\qquad
  N\bigl(-8(1+\omega)\bigr)=192=2^6\cdot3.
  \]

  Therefore the lift has only the zero solution in every characteristic
  except possibly 2 and 3. Characteristic two is already eliminated by the
  universal characteristic-two triple closure. In characteristic three,
  standard affine coordinates \(t=(a,b,1)\) give rank 74 and a unique
  projective nullvector with

  \[
  u_0=0,\qquad \{u_1,\ldots,u_9\}
    =\{(a,b,-1):a,b\in\mathbf F_3\}.
  \]

  The zero defining form is impossible for a carrier line. Hence the
  non-pencil branch dies in the remaining characteristic as well.

The census is independently normalized by two classical totals: 396
unlabelled classes and 1,225,566,720 labelled factorizations. The latter is
recovered from the computed automorphism orders. This also detects and avoids
the erroneous 1,255,566,720 count repeated in some secondary sources.

For the regular Ree factorization, the nine non-Hamilton pairs form three
disjoint triangles, so its Hamilton-pair graph is (K_{3,3,3}). These are
exactly the three diagonal-triple packets found in the preliminary
quadrangle calculation. The 27 cross-part Hamilton pairs supply the global
glue that the local characteristic-two argument lacked.

## Nine-point completion as a balanced-gain problem

The deletion problem has a frame-free reduction that is substantially smaller
than the original concurrence system. Let (L_1,\ldots,L_9) be the carrier
lines, and index the nine near-perfect matching blocks so that (M_h) misses
vertex (h). Let (T_h) be its four-star-point transversal and put

\[
P=\prod_{i=1}^9\ell_i,\qquad Q=\prod_{h=1}^9t_h.
\]

On (L_h), the degree-eight forms (Q/t_h) and (P/\ell_h) have the same
eight simple zeros. Hence there are nonzero constants (c_h) and a constant
(c) such that

\[
Q=cP+\sum_{h=1}^9 c_h t_h\frac{P}{\ell_h}.       \tag{3}
\]

Indeed the indicated choice makes the difference vanish on every (L_h), so
the degree-nine difference is a scalar multiple of (P). This is the exact
nine-carrier analogue of star interpolation; its coefficients are linear
forms (c_ht_h), rather than the constants available with ten carriers.

For an edge (ij\in M_h), write uniquely up to common scale

\[
t_h=A_{ij}\ell_i+B_{ij}\ell_j,
\qquad \gamma_{ij}=B_{ij}/A_{ij},\qquad
\gamma_{ji}=\gamma_{ij}^{-1}.                    \tag{4}
\]

The coefficients are nonzero in a faithful realization. Regard
(\gamma) as a multiplicative gain on the oriented edges of (K_9).
Then the following are equivalent.

1. The gain is balanced: its product around every cycle is one; it is enough
   to test the 28 triangles through a fixed vertex.
2. There are nonzero vertex weights (a_i), unique up to common scale, with
   \(\gamma_{ij}=a_i/a_j\), equivalently
   \(t_h\doteq a_j\ell_i+a_i\ell_j\) for every (ij\in M_h\).
3. The degree-eight star-adjoint
   \[
   F=\sum_i a_i\frac{P}{\ell_i}
   \]
   contains, at every star point (L_i\cap L_j), the length-two local
   intersection of (P=0) with its assigned transversal (T_h).
4. Under the expected-incidence hypothesis (no accidental extra
   carrier/transversal incidences), the nine diagonal points
   \(R_h=L_h\cap T_h\) are collinear, so their line is the missing tenth
   carrier and the realization completes geometrically.

The equivalence of (1) and (2) is ordinary gain-graph gauge exactness. At
(L_i\cap L_j), only the (i,j) summands of (F) have linear terms, namely
(a_i\ell_j+a_j\ell_i), which proves (2) equivalent to (3). Finally (P=Q=0)
is a degree-((9,9)) complete intersection. The 36 assigned star contacts
have total length 72 and lie on (F=0) of degree eight. Since all (a_i\ne0),
(F) shares no carrier component with (P), so those contacts exhaust the
degree-((9,8)) complete intersection (P=F=0) by Bezout. The complete-
intersection ideal is ((P,F)); because (Q) contains it and has degree nine,
the AF+BG form is

\[
Q=cP+\ell_0F
\]

for a linear form (\ell_0). On (P=0), the remaining nine intersections
therefore lie on (\ell_0=0). Conversely, a completion supplies (2) from the
ten-carrier interpolation theorem.

Thus the nine-point frontier is now exact: it asks whether the prescribed
matching concurrences force this edge-gain to be balanced. A single triangle
with nonunit holonomy is a projectively intrinsic obstruction; no coordinate
normalization or field-specific elimination is needed to state it. Accidental
incidences require the scheme-theoretic version of the residual statement and
remain to be checked before promoting the criterion without the faithful-
realization qualifier.

## Application to the Ree bridge

Exact enumeration gives 28 one-factorizations in the regular
`MATCH(10,5,1)` design. Every one has exactly 27 Hamilton pairs (out of 36),
and the 27 resulting five-factor pencil sets have connected two-point-overlap
closure. The theorem therefore forces the nine centers of every
one-factorization to be collinear over **every field**, not only in
characteristic two. Consequently
the 63 matching centers automatically acquire all 28 lines of the canonical
`2-(28,4,1)` incidence design identified with the Ree unital `R(3)`. Nagy's
embedding theorem now supplies the full conclusion directly: a rank-three
realization exists only when (K) contains \(\mathbf F_8\), and then it is
unique, admissible, and contained in an order-eight subplane. In particular,
odd characteristic is excluded without the seven-equation calculation. The
new step is precisely the missing implication from matching concurrence alone
to Nagy's line hypothesis.

The nonhyperoval class has one one-factorization and no Hamilton pair, although
its full triple-overlap closure is still connected; the second form of the
theorem would force its nine centers collinear if such a characteristic-two
realization existed. Its nonexistence remains supplied by the C1003 algebra.

This proves the full ten-point Ree bridge. It does **not** yet prove that an
arbitrary nine-point deletion realization reconstructs the missing tenth
carrier line, so the deletion version remains a distinct extension problem.

## Exact finite certificate

The bundle `c1015_ree_bridge.py`, `c1015_ree_bridge.json`, and
`c1015_ree_bridge.sha256` independently enumerates the contained
one-factorizations, counts Hamilton pairs both by component traversal and by
the product of the two matching involutions, checks the odd-distance
five-factor pencil closures, and checks the more general characteristic-two
triple-overlap closure. Replay from the repository root with

```text
python3 notes/c1015_ree_bridge.py --check
```

It certifies exactly the two tracked ten-point designs: the regular class has
28 factorizations, each with 27 Hamilton pairs and one nine-label closure; the
27 five-factor sets also close to all nine factor labels in every regular
factorization. The nonhyperoval class has one factorization, zero Hamilton
pairs, and one characteristic-two nine-label triple closure. The finite check
does not prove the interpolation or parity theorem; those are the human
argument above. The pre-existing C1003 enumerator provides an independent
check of the counts and canonical hashes, while the two Hamilton tests
cross-check each other.

The second bundle `c1015_k10_factorization_closure.py`,
`c1015_k10_factorization_closure.json`, and
`c1015_k10_factorization_closure.sha256` performs independent canonical
augmentation of colored incidence graphs through all nine factors. It checks
the 396-class and labelled-count census, every parity closure over all ten
base vertices, the universal characteristic-two triple closure, the unique
(AG(2,3)) sparse-shadow dichotomy, the generic Hesse lift determinant, and the
final rank-74 ternary specialization. Replay with

```text
uv run --with pynauty python notes/c1015_k10_factorization_closure.py --check
```

The trusted boundary is `pynauty` canonical labeling plus exact finite graph
closure and row reduction over \(\mathbf Q(\omega)\) and \(\mathbf F_3\). The
output is cross-checked against Gelling's 396 classes, the classical labelled
total, the independently enumerated regular-design factorizations, and two
separate Hamilton-cycle tests. The row reduction is exact rational-pair
arithmetic, not floating point. A handwritten presentation should replace
the 72-extra-triple and determinant checks by short coordinatization lemmas
before manuscript insertion.

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/c1015_ree_bridge.py` | 10,728 | `7b60af8c3583a754db5ddc28d75cc065ca8d8906443e4b4f66903284e60fb123` |
| `notes/c1015_ree_bridge.json` | 1,263 | `1545f49a4d66d33d5d90d0ee99d5eaf39640c0170c99db2a7b6e78697a279b50` |
| `notes/c1015_ree_bridge.sha256` | 317 | `249bd54b32d954d1fd1c3751b99638219af40b905cbeedd7b85c0cc598fdd9b1` |
| `notes/c1015_k10_factorization_closure.py` | 20,513 | `150be14fe54832e15bce7b6ca7d89ef5442cd1cf698f54970ea06d07bf7e3941` |
| `notes/c1015_k10_factorization_closure.json` | 5,899 | `3f36a331e308ae2960c579b6d064925d070d7ccba064a887c10dcdc7a9bef9d1` |
| `notes/c1015_k10_factorization_closure.sha256` | 216 | `b68b6419275ed372cf5cff5a2d32b6407cadb44a604a96286dcdc19eb107ab0b` |
| tracked input JSON | 79,326 | `c2c3619a1c074bd28a9e0b967a4ac1762496589ede0cc636431f484d67fba357` |

## Literature position of the move

The interpolation input is classical star-configuration algebra: for a
codimension-two star configuration, Tohaneanu--Xie, Lemma 3.1, records that
the ideal is generated in degree (s-1) by the products omitting one defining
linear form. Read depth: `partial`, arXiv v1, Lemma 3.1 and its surrounding
setup; cache key `arxiv:1906.08346`, cached PDF SHA-256
`9f5515d754ef1d818a9fe8dd8695827300df9f4f25826b7be702f0f1bda77ece`).
The proof above specializes this standard generator statement and extracts
the edgewise residue relation (1).

Perfect pairs and perfect one-factorizations are classical graph-theoretic
notions. Korchmaros--Pace--Sonnino (JCTA 160 (2018), 62--83,
doi:10.1016/j.jcta.2018.06.006) explicitly study geometric
one-factorizations arising from ovals. Read depth: `full text`, published
version, all sections; cache key `10.1016/j.jcta.2018.06.006`, SHA-256
`30399d2ed0aee41d37cac7c184a7f512aabc4919ddd49dfb917d2b8bf947e401`.
Section 2 represents a factor either by an external line or by a chord plus
one exceptional pole, poses the broad all-lines Problem 1, and says uniqueness
of its easy solution is out of reach. It also records the stronger known
negative answer for all-external-line solutions in Desarguesian odd-order
planes via Segre's tangent lemma. The paper contains no Hamilton-pair,
star-interpolation, parity-layer, or automatic-pencil theorem; Section 7's
sporadic highly symmetric cases are (K_{12}) and (K_{28}), not (K_{10}).
Thus this closest full-text threat does not pre-empt the present converse.

The forward-citation closure of that exact seed was run on 2026-08-30 using
the pinned DOI `10.1016/j.jcta.2018.06.006`. The independent counts were
OpenAlex 5 (`W2808718921`), Crossref 3 (`is-referenced-by-count`), and
Semantic Scholar 6 (`ffcc31a9bff1e2ef3a5fe9b4246963746c608a5c`). All three
requests returned HTTP success and the matching seed DOI/title, so none of
the counts is an error-coded empty response. The load-bearing queries were:

```text
https://api.openalex.org/works/https://doi.org/10.1016/j.jcta.2018.06.006
https://api.crossref.org/works/10.1016/j.jcta.2018.06.006
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016%2Fj.jcta.2018.06.006?fields=title,citationCount,citations.title,citations.abstract,citations.year,citations.externalIds,citations.url
```

The largest set, Semantic Scholar's six citing works, was screened over title,
year, external identifiers, and every available abstract. The mechanical
discriminator was whether the metadata asserted a converse, classification,
concurrency/pencil theorem, projective representation theorem, or a result on
all-line transversals rather than another construction of one-factorizations.
Five works were construction papers (hyperbolae, odd square orders,
circular-linear factorizations, parabolas, and the Lee metric) and did not pass
that discriminator.

The sixth work did pass and was promoted: Kiss--Korchmaros--Romaniello--
Smaldore, _A Note on Parabolic and Linear One-Factorizations of the Complete
Graph (K_{p+1})_ (CEUR Workshop Proceedings 3792, 2024). Read depth:
`partial`, published proceedings PDF, abstract, introduction, Definitions
3.4--3.6, all of Section 4, and references; cache key
`ceur:3792:paper16`, SHA-256
`273b4319bc8435b013642f6e90d435765784a481637e1adc8a25118d49f2e9c4`.
Its Theorem 4.1 proves that an all-line representation on a conic over odd
(\mathbf F_q\), (q\ge5), must use at least one chord representative; it does
not derive a pencil and its chord factors do not put all edge/star points on
one line. Thus it strengthens the adjacent conic-specific negative result but
does not contain the arbitrary-carrier, all-field automatic-pencil theorem.

Ziegler, _Matroid representations and free arrangements_ (Trans. AMS 320
(1990), 525--541), Example 4.1, gives the exact representation condition for
the exceptional sparse shadow: (AG(2,3)) is representable over (K) if and
only if (K) contains a root of \(\omega^2-\omega+1\), together with the
nine Hesse coordinates used above. Read depth: `partial`, published author
scan, Example 4.1 and its two following cases; the load-bearing formula was
verified against the page image. Cache key
`10.1090/S0002-9947-1990-0986703-7`, SHA-256
`6e1c8ed5d8373a6693c2e0f08862d085e27926b94ba86c3c81c7d52c1a5b1785`.

Dinitz--Garnick--McKay, _There are 526,915,620 nonisomorphic
one-factorizations of K12_ (1994), supplies the classical 396-class and
1,225,566,720 labelled (K_{10}) totals used only as external census checks.
Read depth: `partial`, published paper, introduction and the (K_{10}) census
passage; cache key `10.1002/jcd.3180020406`, SHA-256
`f54a59d8e91729f69ec125d99a16ffb30c574e4000943c6ddbe42801e61ada3a`.
Gelling's 1973 thesis is an earlier source for the 396 representatives. Read
depth: `partial`, published scan, appendix pages 61--82 inspected through OCR
with representative tables checked against page images; cache key
`gelling:1973:k10`, SHA-256
`64614781270098af2f1086df5e5684f9a2e98bb3661be35bef1e90243cee93a4`.
The computation here does not import either classification.

Nagy (2021) remains the exact priority ceiling after the pencil has been
produced: his theorem assumes the Ree-unital line structure rather than
deriving it from the 63 matching concurrences. Read depth: `full text` for
arXiv v3, all sections, cache key `arxiv:2007.10464`, SHA-256
`e268f76c7f01a40dd07d59f2077b0fb14a3b8c654041432d1dbf2296ea021f61`;
Sections 1--5 of the published version (DOI
`10.1016/j.ffa.2021.101875`) were also checked, SHA-256
`99e5b60d981c80fe358bad28ebbfe5d6cf18b4f19a50fe8480966c74477aed30`.

Searches for `one-factorization star configuration projective plane`,
`perfect one-factorization projective geometry transversals`,
`one-factorization secants concurrent projective plane`, and
`one-factorization characteristic two geometry` found the adjacent literatures
but no statement of (1), (2), or the automatic-pencil consequence. The 2018
JCTA full-text threat and its three-graph forward-citation set are now closed.
This remains a bounded provisional novelty result rather than a categorical
global priority verdict: MathSciNet and Google Scholar were not covered, and
the topical search was bounded rather than an exhaustive MSC sweep.
Manuscript language such as "new" or "to our knowledge" is not yet authorized.

## Work programme

1. **Landed:** replace the normalized substitution chain by the frame-free
   star-interpolation identity and Hamilton-pair parity holonomy.
2. **Landed universally for ten points:** 395 of the 396 one-factorizations
   close from their Hamilton parity shadows; the affine (AG(2,3)) exception
   is killed by the Hesse lift determinant and its characteristic-two/three
   specializations. Determine whether a nine-point realization itself
   reconstructs the missing tenth carrier line.
3. Determine the actual carrier of the obstruction: seven displayed blocks,
   their vertex/block incidence shadow, or a smaller invariant subdiagram.
4. Test relabellings and deletions to decide whether the certificate is a
   nine-point phenomenon or the first instance of a uniform seven-/eight-/
   nine-local compatibility law.
5. Formulate a characteristic-sensitive invariant whose odd-characteristic
   specialization forces the contradiction and whose characteristic-two
   degeneration explains the `F_8` survivor.
6. Audit primary literature on representations/embeddings of abstract ovals,
   abstract hyperovals, hyperfactorizations, and `pg(5,7,3)` for such global
   compatibility laws, following `notes/literature-audit-conventions.md`.
7. Use Ergodis only through its control interface, if useful, to rank or
   compress candidate identities. Record control/provenance improvements but
   do not edit Ergodis source.

## Success gates

- **Base — landed:** a human derivation of `-2(r-1)^2/r^2=0` from the seven
  displayed concurrences, with every division and characteristic exception
  explicit.
- **Strong — landed universally for ten points:** a frame-free interpolation
  identity, parity invariant, replayable 396-class certificate, and the Ree
  bridge giving all 28 one-factorization lines from matching concurrences.
- **Priority-judo — provisionally landed:** the universal (K_{10}) pencil
  theorem answers the order-ten instance of the geometric-transversal problem
  at a level above the Ree field boundary. Final priority status awaits the
  broader topical closure; the exact Korchmaros--Pace--Sonnino seed, its
  forward citations, and the later 2024 linear-factorization theorem have now
  been checked convention by convention.

## Extra-juice and Tao-style closeout

The cheap structural upgrade is the affine description of the sole census
exception. It explains simultaneously its automorphism order 432, its twelve
parity triples, and the Hesse representation space. The determinant norm
(2^6\cdot3) then isolates exactly the two characteristics in which the
generic obstruction might degenerate; independent combinatorial and ternary
arguments close them. This is the strongest current theorem, not merely a
regular-Ree corollary.

The most valuable conceptual compression still available is to replace the
exact Hesse row reduction by an (AGL(2,3))-module or Fourier calculation.
The affine rule suggests a higher-order family on
(\{\infty\}\cup\mathbf F_p^d), with factors pairing (x) to
(2a-x). Determining whether the parity-shadow/Hesse dichotomy is the first
case of a uniform affine-round-robin obstruction is a genuine successor,
not needed for the order-ten theorem.

### Mystery ledger

- **Why 27 Hamilton pairs in the regular Ree factorization — settled.** The
  nine non-Hamilton pairs are three disjoint triangles, so the Hamilton graph
  is (K_{3,3,3}); these are the three diagonal packets from the local
  quadrangle calculation.
- **Why the unique zero-Hamilton class produces (AG(2,3)) — settled.** It is
  exactly the affine factorization
  (M_a=\{\infty a\}\cup\{xy:x+y=-a\}), with automorphism order 432; its
  twelve parity triples are the affine lines.
- **Why only characteristics 2 and 3 survive the generic Hesse test — settled
  computationally, not conceptually.** The exact full minor is
  (-8(1+\omega)), of norm 192. The missing evidence is a short
  (AGL(2,3))-equivariant decomposition deriving these factors without row
  reduction.
- **Nine-point deletion completion — reduced, still open.** The missing line
  exists exactly when the 36 edge gains (4) are balanced; 28 fixed-base
  triangle products are a complete frame-free test. AF+BG then constructs the
  missing line from the degree-eight star adjoint. The remaining evidence gap
  is to prove that the prescribed matching concurrences force balance, or to
  realize one nonunit triangle holonomy as a counterexample. Accidental extra
  incidences also require the scheme-theoretic cleanup stated above.
- **Higher affine round-robin family — open successor.** The evidence gap is
  a general parity-shadow closure/representation theorem for
  (K_{p^d+1}), beginning with the midpoint factorization above.
- **Closest-seed priority — settled; global priority remains bounded.** The
  Korchmaros--Pace--Sonnino full text and its largest three-graph citing set
  are cleared, including the 2024 characterization paper. MathSciNet and
  Google Scholar remain uncovered, and no exhaustive MSC sweep has been run.
- **Ergodis lessons — recorded, source untouched.** A useful future control
  interface should ingest small incidence hypergraphs and exact finite-field
  rank features, generate base-point-invariant rather than fixed-base
  shadows, track algebraic parameter rings and exceptional-prime norms, and
  force specialization checks before accepting characteristic claims. The
  initial fixed-base undercount and mistaken characteristic-three inference
  are concrete regression tests for those features.

## Publication decision after proof

The universal (K_{10}) pencil theorem clears the threshold for a short
standalone representation paper if the priority audit stays clean. Its spine
would be interpolation, parity pencils, the 396-class sparse-shadow dichotomy,
and the Hesse obstruction; Ree rigidity would be the marquee application.
It also strengthens the arcs equality paper by replacing the regular
characteristic-two coordinate classification with automatic Ree completion
plus Nagy's theorem. The best integration decision should follow the
nine-point completion attempt and priority audit, but the theorem no longer
needs an infinite-family extension to justify standalone treatment.
