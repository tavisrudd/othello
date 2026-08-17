# C916 — Paper III compact-incidence and Stein-normality corrections

**Date:** 2026-08-17
**Lane:** `clebsch`
**Task card:** `notes/clebsch-tasks/c916-paper-iii-compact-incidence-corrections.md`
**Specification:** `notes/2026-08-17-c916-paper-iii-correction-spec.md`, SHA-256
`97a1ffe70e41971e663030e190bed5e9917e200f4d29cd06e262da0293c113b8`

## Verdict

All eight required mathematical edits are applied to
`papers/clebsch-passages/`, each repaired step is checked against the cited
Hitchin sections, and the manuscript rebuilds warning-free and
deterministically at 33 pages.  The optional immutable-locator item is
excluded by author instruction (the author supplies the locator separately).
The two Paper III corrections owed from the released-paper cluster (wrong
benchmark citation, missing two-graph attribution) are untouched, also by
author instruction.

Input PDF: SHA-256
`16bde43e1820b1b9c5b15e6a1bdf1ace804aa80393f46285acf39c1d002306ba` (33 pages,
authority commit `b19233879`), which is exactly the referee's original PDF the
specification's page numbers refer to.

Output PDF: SHA-256
`234046320443bffd0ccb97df239ecf61f80186110a10d83474474e212504e4a3`, 33 pages,
warning-free, byte-identical to a deterministic scratch rebuild.

## What each edit did

Line numbers are post-edit; the specification's search anchors are the stable
reference.

1. **§2.2, `sections/02-orientation-cover.tex:163`.** After the
   Mukai--Umemura identification and before the incidence scheme \(\mathcal I\)
   is defined, the manuscript now says that over \(\mathbf C\) the open
   \(\operatorname{SO}(3,\mathbf C)/A_5\)-orbit parametrizes nondegenerate
   icosahedral configurations, that its complement is Hitchin's degenerate
   divisor, and that \(\Delta\) is the degree-ten
   \(\operatorname{SO}(3,\mathbf C)\)-invariant whose vanishing detects
   orthogonality to a degenerate isotropic three-plane.  No normalization and
   no square class of \(\Delta\) is claimed, and the degenerate divisor gets
   no symbol.
2. **§2.3 reduced branch cycle, `sections/02-orientation-cover.tex:264`.** The
   old paragraph inferred quasi-finiteness from Hitchin's count of *real
   regular* configurations.  It is replaced by an argument on the compact zero
   scheme: the trichotomy has two-point, one-point, or positive-dimensional
   geometric fibres; the positive-dimensional locus is closed by upper
   semicontinuity; Theorem 4 confines it, inside the Clebsch chart, to a
   degree-six rational curve and six lines of the Clebsch cubic surface, so
   some point of the sextic has a one-point compact fibre and, the sextic
   being irreducible, a general smooth point does.  Only then come
   quasi-finiteness, local finiteness, miracle flatness, ramification, and the
   degree-six exhaustion.
3. **§2.3 local comparison at \(xyz\),
   `sections/02-orientation-cover.tex:356`.** Compact completeness of the
   fibre is now derived from \(J_0(xyz)=(16/25)^2\ne0\) plus Theorem 5 before
   étaleness is used: the trichotomy puts \([xyz]\) in the two-point case, and
   the two regular configurations \(I_t,I_{1-t}\) of Hitchin's earlier paper
   are those two points.  The subsequent properness, normalization,
   étaleness, and \(E=\Q(\sqrt5)\) argument is unchanged.
4. **§2.3 Stein algebra, `sections/02-orientation-cover.tex:402`.** The
   multiplication section \(a\) of \(\mathcal M^{-2}\) is now analyzed at a
   height-one point: trivializing \(\mathcal M\) over the corresponding
   discrete valuation ring \(R\) with uniformizer \(\varpi\) gives
   \(R[z]/(z^2-a)\); if \(v(a)\ge2\) then \(z/\varpi\) is integral, because
   \((z/\varpi)^2=a/\varpi^2\in R\), yet lies outside \(R\oplus Rz\),
   contradicting normality of \(\mathcal N\).  So every height-one zero is
   simple, the multiplication divisor is the reduced sextic, and \(2d=6\).
   The exact algebra \(\mathcal O\oplus\mathcal O(-3)\), \(z^2=5J_0\) is
   unchanged.
5. **Proposition 1.2, `sections/01-introduction.tex:202`.** The claim that
   \(D(\sigma_3)\) carries two distinct icosahedral configurations is replaced
   by: the pulled-back finite cover is split étale there with two distinct
   compact incidence points; away from the degree-ten degeneracy locus both
   are regular six-axis configurations; on that locus with \(\sigma_3\ne0\)
   the fixed \(U_t\)-branch is regular and the other point is degenerate.  The
   equations \(z=\pm4\sqrt5\,\sigma_3\) and the disjointness of the
   normalization are untouched.
6. **§3.1, `sections/03-orientation-source.tex:29`.** Hitchin's chart
   classification sentence is replaced by the definition
   \(\Delta_t=\iota_t^*\Delta\) after base change to \(\mathbf C\), the
   split-étale statement for the pulled-back cover on \(D(\sigma_3)\), the
   everywhere-disjointness of \(B_+\amalg B_-\), the identification of
   \(\{\Delta_t=0\}\) from §8.2, and the exact two-regular locus
   \(D(\sigma_3\Delta_t)\).  The forced magnitude \(4\sqrt5\) sentence follows
   unchanged.
7. **§3.2, `sections/03-orientation-source.tex:115`.** The relative source
   labels are now attached to the normalized components rather than to a
   pointwise regular-six-axis marking, and are said to extend across both
   \(\sigma_3=0\) and \(\Delta_t=0\).  The surrounding warnings that no global
   marking on \(B_-\) is asserted and that the \([xyz]\) calculation is not
   used for pointwise conference labeling elsewhere are preserved.
8. **Introduction attribution, `sections/01-introduction.tex:262`.** Hitchin
   is credited with the generic degree and the compact isotropic-subspace
   trichotomy, the sextic locus, the chart and its restriction, and the two
   regular configurations over \(xyz\); the compact completeness used here is
   pointed at Section 2.3 with Theorem 5 and \(J_0(xyz)\ne0\).

## Deliberate deviations from the specification text

1. **Theorem 4 attribution clause (edit 2).** The specification's replacement
   sentence reads that Theorem 4 "gives one-point compact fibres at points of
   the Clebsch cubic away from a degree-six rational curve and six lines."
   Theorem 4 as printed says only that a cubic containing one or infinitely
   many icosahedral sets lies on the Clebsch cubic surface, and that the
   infinite case lies on the degree-six rational curve or the six lines; the
   one-point conclusion needs Theorem 5 as well, which the preceding sentence
   of the same paragraph supplies.  The manuscript therefore says Theorem 4
   *confines the positive-dimensional case* to that curve and those lines, so
   a point of the surface off them has a one-point compact fibre.  Same
   mathematics, attribution at the strength the source actually carries.
2. **Two stable subsection labels.** `sec:rational-incidence-model` (§2.2) and
   `sec:arithmetic-main-proof` (§2.3) were added so that the new cross
   references from Proposition 1.2 and the introduction point at the exact
   subsections named in the specification rather than at Section 2 as a whole.
   No prose in those subsections changed beyond the specified edits.
3. **Appendix B locator omitted.** Author instruction on 2026-08-17: the
   locator is handled outside this task.  No text changed for that item, and
   nothing was invented.

## Proof checks

**Sources.** Every imported statement was checked against the cached PDF text
of Hitchin, *Vector bundles and the icosahedron*
(`/tmp/persistent/tavis/lit-search/text/arXiv_0906.4208.txt`, cache key
`arXiv:0906.4208`; published as Contemporary Mathematics 522, reference `[3]`).
Section numbering in that file matches the numbers cited: §6.1--6.2 are the
degenerate-icosahedra subsections containing Proposition 2, §8.2 is *The
trisecant surface*, §8.3 is *The three cases for* \(\mathbf P^3\) containing
Theorem 4, and §9 is *The trichotomy for* \(\mathbf P(V)\) containing
Theorem 5.

- Proposition 2 reads: a harmonic cubic \(f\) is orthogonal to a degenerate
  isotropic subspace if and only if \(\Delta(f)=0\) for a certain
  \(\operatorname{SO}(3,\mathbf C)\)-invariant polynomial \(\Delta\) of degree
  ten.  This is exactly the strength used in §2.2.
- §8.2 proves the trisecant surface is irreducible of degree ten, cut out by
  \(\Delta\), and is "the locus of cubics which pass through a nondegenerate
  icosahedral set \([a_1],\dots,[a_6]\) and a degenerate one."  That sentence
  is what licenses the §3.1 and Proposition 1.2 statement that on
  \(\{\Delta_t=0\}\) with \(\sigma_3\ne0\) one branch is regular and the other
  degenerate.
- Theorem 4 reads: a generic point of \(\mathbf P^3\) defines a cubic
  containing precisely two icosahedral sets; if it contains one or infinitely
  many it lies on the Clebsch cubic surface \(S\), and in the latter case on
  the degree-six rational curve \(\tilde R\subset S\) or on the six lines
  \(E_1,\dots,E_6\).  See deviation 1 for how the manuscript uses it.
- Theorem 5 reads: a generic point of \(\mathbf P(V)\) defines a cubic
  containing precisely two icosahedral sets; it contains one or infinitely
  many if and only if it lies on the hypersurface \(J_6=0\).  This gives both
  the two-point case at \([xyz]\) and the identification of the
  one-or-positive-dimensional locus with the sextic.
- No stronger statement was imported.  In particular the manuscript claims no
  formula and no normalization for \(\Delta\) or \(\Delta_t\); Hitchin's own
  relation \(J_{10}=2^{-12}\Delta\) was deliberately not used.

**Branch-cycle argument.** The dependency order is canonical class
\(\pi_*R=6h\), then compact trichotomy, then quasi-finiteness, then local
finiteness, then miracle flatness, then ramification from a single geometric
support point, then degree-six exhaustion.  Nothing in the chain uses the
conclusion that \(J_0=0\) is the branch divisor.  The step from the chart
evidence to a general point of the sextic is sound because the
positive-dimensional locus is closed and the sextic is irreducible: exhibiting
one sextic point outside that locus puts it in a proper closed subset.  Inside
the chart, \(\{J_0\circ\iota_t=0\}=\{\sigma_3^2=0\}\) is the Clebsch cubic
surface, so the points Theorem 4 supplies do lie on the sextic.

**Miracle flatness.** The hypotheses hold as used: \(\mathcal I\) is smooth,
being a projective bundle over the smooth threefold \(X\); \(\mathbf P(H)\) is
regular; both have dimension six, since \(\mathcal F\) has rank four; and the
fibre dimension is zero at the point in question because quasi-finiteness was
established first.

**Height-one normality lemma.** The section \(a\) is nonzero because the cover
is generically a quadratic field extension.  Localizing at a height-one point
of \(\mathbf P(H)\), finiteness makes \(f_*\mathcal O_{\mathcal N}\otimes R\)
the integral closure of \(R\) in the total fraction ring, so it is integrally
closed.  If \(v(a)\ge2\), then \(z/\varpi\) satisfies \(T^2-a/\varpi^2\) with
\(a/\varpi^2\in R\) and is not in \(R\oplus Rz\), contradicting that.  Hence
\(v(a)\in\{0,1\}\).  Conversely \(v(a)=1\) makes the local extension
ramified and \(v(a)=0\) makes it unramified, so the divisor of \(a\) is
exactly the reduced branch divisor.  Since the branch divisor is the sextic,
\(2d=6\).

**Independent \(xyz\) check (not inserted in the manuscript).** The
specification's transversality computation was rerun by hand: \(xyz=0\) meets
\(Q:x^2+y^2+z^2=0\) in the six distinct points \([0:1:\pm i]\),
\([1:0:\pm i]\), \([1:\pm i:0]\); at \([0:1:i]\) the gradients \((i,0,0)\) and
\((0,2,2i)\) are independent, and the rest follow by symmetry.  So all six
intersections are transverse and \(\Delta(xyz)\ne0\): no degenerate compact
incidence point sits above \(xyz\).  This is consistent with the compact
trichotomy repair and is not used as a completeness argument.

## Specification sanity checks

**A, compactness and regularity.** §2.2 states the degenerate divisor;
\(\Delta=0\) is described only as orthogonality to a degenerate isotropic
three-plane; \(J_0=0\) remains the sextic branch and trichotomy locus; no
occurrence of \(D(\sigma_3)\) anywhere in the manuscript now claims the
two-regular locus — the surviving occurrences say "split" (§2.1),
"split étale" (Proposition 1.2, §3.1), or appear inside
\(D(\sigma_3\Delta_t)\) and \(D(\sigma_3)\cap\{\Delta_t=0\}\); the
two-regular locus is stated as \(D(\sigma_3\Delta_t)\) after base change to
\(\mathbf C\); \(B_+\amalg B_-\) is still disjoint everywhere including
\(\sigma_3=0\); and it is the pulled-back cover, not its normalization, that
is called split étale.

**B, branch proof.** Quasi-finiteness now comes from the compact trichotomy of
`[3]`, not the real count in `[2]`; the positive-dimensional case is stated to
be non-generic; \(\pi_*R=6h\) is untouched; the sextic is not assumed to be
the branch divisor anywhere before it is proved; and the one-point flat
degree-two fibre is called ramified, not reduced.

**C, golden fibre.** Completeness of the compact fibre over \([xyz]\) is
proved first, from \(J_0(xyz)\ne0\) and Theorem 5; the two points are then
identified with \(I_t,I_{1-t}\); étaleness and reducedness come only after
local finiteness and the branch calculation; the residue algebra is still
\(\Q(\sqrt5)\); and the square class is still \(c=5\).

**D, Stein algebra.** The lemma sits after \(\mathcal M\simeq\mathcal O(-d)\)
is established, uses normality of \(\mathcal N\), works with
\(R[z]/(z^2-a)\), concludes multiplicity one at height one, gives \(2d=6\) and
\(d=3\), and leaves \(z^2=5J_0\) unchanged.

**E, signs and scalars.** The diff touches only the eight anchors and the two
new labels; deletions in it are exactly the replaced anchor text.  Every
listed constant is still present and unmodified: \(16\sigma_3^2\),
\(80\sigma_3^2\), \(4\sqrt5\,\sigma_3\), \((16/25)^2\), \(C^2=5I\), the
transports \(C\mapsto-C\) and \(Z_C\mapsto-Z_C\), \(\operatorname{Pf}\) and
determinant identities, \(Z=10\sqrt5\det B\), and
\(-784000/1247103\).  Sections 04 through 09 are untouched, so Theorems
5.1--5.4, 6.1, the Petersen material, the spinor class, and the
integral/finite-field caveats are unchanged.

## Validation

Replay commands, from `papers/clebsch-passages/`:

```sh
python3 verification/lint_tex_spacing.py clebsch_passages.tex sections
python3 verification/extract_statement_identity.py --check
python3 verification/verify_scaffold.py
python3 verification/verify_formal_companion.py --no-loose-commits
sha256sum -c verification/evidence/arithmetic_cover.sha256      # and the other two stems
python3 verification/evidence/arithmetic_cover.py --check       # and the other two stems
python3 verification/evidence/arithmetic_cover_replay.py        # and the other two stems
nix develop .#manuscript --command python3 verification/check_manuscript_build.py
python3 verification/verify_release.py
```

Results: spacing lint OK; statement identity CHECK OK after regeneration;
scaffold OK (`local_release_ready=true`); formal companion PASS with the
shared-library pin unchanged; all three evidence stems pass hash, primary and
independent replay; manuscript build PASS at 33 pages, warning-free, with the
tracked PDF byte-identical to a deterministic scratch build.

**Statement identity.** Exactly one statement hash moved,
`thm:orientation-source` (Proposition 1.2), which is the one statement the
specification edits.  The other eight statement hashes and the trust-row hash
are unchanged.  Regenerating the file also resealed drift that predated this
task: the committed `verification/statement_identity.json` was already stale at
`b19233879` for `clebsch_passages.tex` and for
`sections/05-golden-operator.tex`, `sections/08-verification.tex`, and
`sections/10-references.tex`, none of which C916 edited.

**Pre-existing aggregate failure, not repaired here.**
`verification/verify_release.py` fails at its public-vocabulary gate with
`superseded paper name in README.md`.  The gate rejects the string "Paper III"
in any released file, while `README.md` has said "Paper III of the five-paper
*Clebsch: Rigidity from Sparse Shadows*" since commit `d2917f94d`
(2026-08-09), when the series identity was adopted.  So the gate encodes the
pre-series vocabulary and has been red since that commit, independently of
C916; every other check in the aggregate passes.  Changing a release gate needs
explicit authority and the README wording belongs to the series-identity work,
so neither was touched.  This is the one open item blocking a green aggregate
for Paper III.
