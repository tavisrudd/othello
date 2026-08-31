# C1015 — global obstruction beyond the six-local matching test

**Lane:** `relconic`

**Status:** Strong gate reached for the ten-point regular class: a general
star-configuration theorem forces every canonical one-factorization line in
characteristic two. The nine-point extension and final priority audit remain
open. No manuscript, summary, mirror, formal, release, or Ergodis source edits
are authorized.

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

## Application to the Ree bridge

Exact enumeration gives 28 one-factorizations in the regular
`MATCH(10,5,1)` design. Every one has exactly 27 Hamilton pairs (out of 36),
so the theorem forces the nine centers of every one-factorization to be
collinear in every characteristic-two rank-three realization. Consequently
the 63 matching centers automatically acquire all 28 lines of the canonical
`2-(28,4,1)` incidence design identified with the Ree unital `R(3)`. Nagy's
embedding theorem then supplies the classical field boundary, uniqueness,
admissibility, and containment in an order-eight subplane. The new step is
precisely the missing implication from matching concurrence alone to Nagy's
line hypothesis.

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
the product of the two matching involutions, and checks the more general
triple-overlap closure. Replay from the repository root with

```text
python3 notes/c1015_ree_bridge.py --check
```

It certifies exactly the two tracked ten-point designs: the regular class has
28 factorizations, each with 27 Hamilton pairs and one nine-label closure; the
nonhyperoval class has one factorization, zero Hamilton pairs, and one
nine-label closure. The finite check does not prove the interpolation or
parity theorem; those are the human argument above. The pre-existing C1003
enumerator provides an independent check of the counts and canonical hashes,
while the two Hamilton tests cross-check each other.

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/c1015_ree_bridge.py` | 7,316 | `0136784443e9ccc9a07ab251a136a56ece4acae5b0d7d4457bbab5d2313dc4f6` |
| `notes/c1015_ree_bridge.json` | 947 | `425dacafe2dd1fdd066b90f7167ed7ef20a4bebca40c547e0a10c769e034173b` |
| `notes/c1015_ree_bridge.sha256` | 317 | `dd5f62c14fe2c9c4ff13a1d67ed3c5644bdbdc03797e24557748ed3864d7c33b` |
| tracked input JSON | 79,326 | `c2c3619a1c074bd28a9e0b967a4ac1762496589ede0cc636431f484d67fba357` |

## Literature position of the move

The interpolation input is classical star-configuration algebra: for a
codimension-two star configuration, Tohaneanu--Xie, Lemma 3.1, records that
the ideal is generated in degree (s-1) by the products omitting one defining
linear form (arXiv:1906.08346, cached PDF SHA-256
`9f5515d754ef1d818a9fe8dd8695827300df9f4f25826b7be702f0f1bda77ece`).
The proof above specializes this standard generator statement and extracts
the edgewise residue relation (1).

Perfect pairs and perfect one-factorizations are classical graph-theoretic
notions. Korchmaros--Pace--Sonnino (JCTA 160 (2018), 62--83,
doi:10.1016/j.jcta.2018.06.006) explicitly study geometric
one-factorizations arising from ovals, but the accessible abstract describes
a construction in finite planes of odd order, not the characteristic-two
automatic-pencil converse here. Nagy (2021) remains the exact priority
ceiling after the pencil has been produced: his theorem assumes the Ree-unital
line structure rather than deriving it from the 63 matching concurrences.

Searches for `one-factorization star configuration projective plane`,
`perfect one-factorization projective geometry transversals`,
`one-factorization secants concurrent projective plane`, and
`one-factorization characteristic two geometry` found the adjacent literatures
but no statement of (1), (2), or the automatic-pencil consequence. This is a
bounded provisional novelty result, not yet a final priority verdict: the 2018
JCTA article and its forward citations still require full-text closure before
manuscript language such as "new" or "to our knowledge" is justified.

## Work programme

1. **Landed:** replace the normalized substitution chain by the frame-free
   star-interpolation identity and Hamilton-pair parity holonomy.
2. **Landed for ten points:** all 28 canonical one-factorizations have
   Hamilton pairs, so their nine centers are forced collinear in
   characteristic two. Determine whether a nine-point realization itself
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
- **Strong — landed for ten points:** a frame-free interpolation identity,
  parity invariant, replayable finite certificate, and the Ree bridge giving
  all 28 one-factorization lines from matching concurrences.
- **Priority-judo — provisionally landed:** a general global compatibility theorem for rank-three
  matching-design realizations from which the nine-point exclusion and a
  classical abstract-oval fact both follow, or which answers a representation
  question absent from the subsequent literature. Final status awaits the
  full-text priority closure recorded above.

## Publication decision after proof

The uniform Hamilton-pair theorem clears the prior threshold for a standalone
representation note, especially if the literature closure stays clean. It
also strengthens the arcs equality paper by replacing the regular
characteristic-two coordinate classification with automatic Ree completion
plus Nagy's theorem. Reassess final placement after the nine-point extension
and priority audit; the result is no longer merely a boundary lemma. A
standalone note is strongest if the invariant excludes an infinite family or
yields a structural
classification beyond the four order-eight pointed classes.
