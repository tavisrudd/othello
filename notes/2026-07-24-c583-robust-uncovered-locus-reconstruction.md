# C583 robust uncovered-locus reconstruction

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete.  A field-uniform line-union theorem and a separate
rank-three vertex-recovery step now give quantitative reconstruction in the
manuscript.

## Result

Let \(A,B\) be \(k\)-arcs in \(\operatorname{PG}(2,q)\), and put
\[
 N=\binom{k}{2},\qquad
 \delta=q+1-N\ge1,\qquad
 t=|U(A)\mathbin{\triangle}U(B)|.
\]
Let \(r\) be the number of secants of \(A\) that are not secants of \(B\);
the number gained on the other side is also \(r\).  If \(\delta\ge2\), set
\(s=\lfloor t/2\rfloor\).  Then
\[
 r\le
 \left\lfloor\frac{s(s-1)}{\delta(\delta-1)}\right\rfloor.
\]
Writing \(h=\lfloor(k-1)/2\rfloor\), the parent arcs satisfy
\[
 |A\mathbin{\triangle}B|
 \le 2\left\lfloor\frac{2r}{h}\right\rfloor.
\]
There are two sharper arc-specific inequalities.  If \(e_A(x)\) is the
degree of \(x\) in the lost-secant graph and
\(\phi(0)=0,\ \phi(j)=\binom{j-1}{2}\) for \(j\ge1\), then
\[
 d_A\ge r\delta-\binom r2+\sum_{x\in A}\phi(e_A(x)),
\]
with the analogous bound for the gained-secant graph on \(B\).  If
\(a=|A\setminus B|\), then
\[
 2r\ge a\bigl(k-1-\min\{a,\lfloor k/2\rfloor\}\bigr).
\]
For the entire exact-reconstruction range, including the boundary
\(\delta=1\),
\[
 t<2\delta\quad\Longrightarrow\quad A=B.
\]
Thus \(t=o(\delta\sqrt N)\) forces agreement of all but \(o(N)\) secants
and all but \(o(k)\) vertices.  No assumption on the characteristic or on
the relative growth of \(k\) and \(q\) is suppressed.

## Deterministic line threshold

The line-recovery step is independent of arc structure.  For two \(N\)-line
families \(\mathcal L,\mathcal M\), let
\[
 X=\bigcup\mathcal L,\qquad Y=\bigcup\mathcal M,\qquad
 d_X=|X\setminus Y|,\qquad d_Y=|Y\setminus X|,
\]
and let \(r=|\mathcal L\setminus\mathcal M|
=|\mathcal M\setminus\mathcal L|\).  Every lost line contains at least
\(\delta=q+1-N\) points of \(X\setminus Y\).  Bonferroni and the uniqueness
of the line through two points give the complementary bounds
\[
 d_X,d_Y\ge r\delta-\binom r2
\]
and, for \(\delta\ge2\),
\[
 r\binom{\delta}{2}
 \le
 \min\left\{\binom{d_X}{2},\binom{d_Y}{2}\right\}.
\]
The second inequality is the useful global estimate: the unordered point
pairs contributed by two distinct lost lines cannot coincide.

The comparison with adverse arrangements is exact.  Suppose the two
families share \(N-r\) lines and all \(N+r\) lines have no triple
concurrence.  When \(N+r\le q+1\), such a family can be selected from a
dual \((q+1)\)-arc, and
\[
 d_X=d_Y=r\delta-\binom r2.
\]
This attains the Bonferroni bound.  A pencil is less adverse: its common
centre merges only \(r-1\) points, whereas general position realizes all
\(\binom r2\) pairwise repetitions.  Hence no arbitrary-line argument can
improve the first-order scale; an improvement must use the secant
realization.

## Vertex recovery

The second step uses projective rank-three compatibility rather than the
line-union count.  If \(a\in A\setminus B\), then every common secant
through \(a\) is a secant of \(B\) through a nonvertex.  Such secants use
disjoint pairs of the \(k\) vertices of \(B\), so at most
\(\lfloor k/2\rfloor\) can pass through \(a\).  At least
\[
 (k-1)-\lfloor k/2\rfloor=\lfloor(k-1)/2\rfloor=h
\]
of the secants through \(a\) are therefore lost.  Summing lost degrees
over \(A\setminus B\) yields
\[
 h|A\setminus B|\le2r,
\]
which is the displayed vertex bound.  This step is logically separate from
line recovery and is the required geometric compatibility input.

## Defect boundary

C558's bad-edge inequality was not needed to prove the robust inverse.  It
controls failures of maximum matching concurrence in one prescribed-hole
configuration; it does not by itself compare two rank-three secant
realizations.  The remaining manuscript problem now asks whether combining
that defect with the secant realization can improve the arbitrary-line
scale.  The no-triple-concurrence example shows exactly what such an
improvement must overcome.

## Manuscript integration

`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` now
contains:

- the deterministic line-union perturbation lemma;
- the robust uncovered-locus reconstruction proposition;
- the scale and adverse-arrangement remark;
- updated abstract, introduction, and conclusion language; and
- a narrowed open problem asking for a genuinely rank-three,
  defect-coupled strengthening.

The former source TODO has been removed.
`arcs_complete_outside_conic_proof_audit.md` records the complete proof
boundary and notes that no computation or defect estimate enters the
theorem.

## Validation

The repository paper target passes:

```text
make -C papers arcs
```

The final XeLaTeX pass produces a 27-page PDF with no undefined references,
undefined citations, or overfull boxes.  The only layout message is the
pre-existing underfull bibliography paragraph.  A rendered-text inspection
of pages 19--22 checked every displayed bound, the separation between the
line and vertex steps, the sharpness remark, and the revised conclusion.

## `ej` + `tt` closeout

The cheap strengthening is the gap theorem
\(t<2(q+1-\binom{k}{2})\Rightarrow A=B\): robust inversion is locally
constant on an explicit Hamming ball, even at \(\delta=1\), where the
quadratic rich-line estimate itself degenerates.  Keeping both the
Bonferroni and point-pair inequalities also records the honest line-only
boundary instead of presenting one convenient but scale-blind estimate.

The Tao-style discriminator is where geometry first becomes indispensable.
General-position lines, not pencils, minimize the visible one-sided
difference to first order.  An improvement must exploit that the lines are
the edges of two complete graphs realized in one projective plane.  The
vertex estimate supplies one such compatibility step; C558's bad-edge
count does not yet supply another.

## Post-completion `ej` upgrade

The explicit extra-juice pass found that the arbitrary-line Bonferroni
obstruction is not the end of the proof-only story.  The lost secants form
an edge set on the \(k\) vertices of \(A\).  If \(e\) lost edges meet at one
arc vertex, their union pays overlap \(e-1\), not \(\binom e2\); if that
vertex lies in the comparison union, it pays no one-sided overlap there.
Either way the secant realization restores at least
\(\binom{e-1}{2}\) points relative to the unrestricted Bonferroni bound.
Summing gives the degree-sequence correction displayed above.  It is
strict as soon as a lost-edge degree reaches three.

The same pass sharpens vertex recovery.  A common secant through
\(x\in A\setminus B\) is a matching edge on \(B\), but it cannot use two
vertices of \(A\cap B\), since that would put three points of \(A\) on its
line.  Every such matching edge therefore consumes a distinct point of
\(B\setminus A\), so there are at most
\(\min\{a,\lfloor k/2\rfloor\}\) of them.  This yields the nonlinear
inequality above and improves the linear vertex estimate whenever the two
arcs are already close.

## Cold-read cut disposition

The independent cold read recommends a 4.5--5.5 page reduction.  The
strongest cuts have the following honest destinations.

- The Clebsch hexagon's rigidity, automorphisms, projective deep-hole
  syndrome locus, decoding consequences, support bipartition, and
  factorization memory already belong to
  `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex`.  The arcs
  manuscript now foreshadows that companion explicitly and should retain
  only the \(U(A)=\mathcal C(\mathbf F_{11})\) consequence and the shortest
  code/coset corollary needed here.
- The optional icosahedral extension complex does not occur in that focused
  companion.  If removed from the arcs manuscript, preserve it as a
  bounded Clebsch extension note: independence polynomial
  \(1+12t+36t^2+20t^3\), the \(6\) maximal two-column and \(20\) maximal
  three-column extensions, the absence of a ten-arc extension, and the
  six-colour perfect-matching augmentation.  This is a note candidate, not
  an allocated successor or a promised paper.
- Detailed \(q=16\) commands, hashes, generator/checker boundaries, and
  exceptional-leaf data belong in the existing paper supplement and trust
  map.  The body should retain only the completeness contract, terminal
  profile, and mathematical leaf obstruction.
- Raw witness coordinates and field encodings belong in the source
  supplement.  The paper needs only a compact witness table and a stable
  pointer.
- The neighboring-notion and priority detail removed from the introduction
  remains recoverable from the C349 and C558 reports; it should not be
  advertised as future mathematical work.
- The robust inverse, its sharpness example, and its degree correction stay
  in this paper as the inverse counterpart to the forward defect identity.
  Only a future defect-coupled strengthening remains an open problem; no
  companion theorem is currently claimed.

## Mystery ledger

- **Field-uniform robust inverse:** settled.  The theorem gives explicit
  secant and vertex bounds for every \(q,k,t\) with
  \(q+1>\binom{k}{2}\), and a gap theorem throughout that exact range.
- **Adversarial concurrency:** settled.  Pencils are not extremal;
  no-triple-concurrence line families attain the Bonferroni bound.
- **Arc-specific improvement:** partially settled by the post-completion
  `ej` pass.  Lost-edge degrees at least three force a positive concurrence
  correction, and the vertex loss obeys the sharper nonlinear inequality.
  What remains open is a restriction on maximum-degree-two lost-edge sets
  (disjoint paths and cycles), where the degree correction vanishes.
- **Defect coupling:** open at the same gate.  C558 bounds combinatorial bad
  edges inside one realization and does not compare two realizations.
- **Computational evidence:** no mystery remains.  The theorem is
  proof-only and uses no finite census, symbolic identity, or trusted
  execution.
