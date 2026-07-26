# C669 Paper III context and literature audit

**Lane:** `clebsch`

**Date:** 2026-07-26

## Verdict

Paper III has a defensible focused-note contribution, but the current
candidate gives two secondary correspondences too much rhetorical weight.
The paper-owned result is the conjunction of:

1. the arithmetic normalization of Hitchin's known degree-two incidence
   cover as
   \[
   \mathbf Q(\mathbf P(H))(\sqrt{5J_0}),
   \]
   obtained by evaluating the remaining rational square class on Hitchin's
   golden \(xyz\) fibre;
2. the self-contained specialization of that explicit fibre and exchanger
   at \(11\), together with the finite signed-cubic identification; and
3. the exact restriction of the degree-six Gaunt cubic on the ten face axes
   to the Clebsch four-space.

Hitchin already owns the incidence cover, its degree, branch sextic,
restriction \(J_0|_V=16\sigma_3^2\), and the two golden icosahedra over
\(xyz\). Dye already owns the square-\(5\) existence criterion for Clebsch
hexagons over general fields. Steinhardt--Nelson--Ronchetti own the standard
degree-six bond-order invariant and its icosahedral use. The order-twelve
Hadamard model, its row--column outer automorphism, the two \(M_{11}\)
classes, and the \(L_2(11)\) subgroup are also classical.

The marked Hitchin--Mathieu torsor is correct but is only the unique
equivariant bijection between two marked free transitive \(C_2\)-sets. It
does not explain the arithmetic square class, the finite cubic bridge, or
the harmonic restriction. C668 should remove it from the focused note
rather than enlarge the group-theory survey around it. The exact carrier
calculation remains a valid archived result.

Likewise, the proposed physical descriptor and its empirical inventory do
not contribute to the harmonic theorem. C668 should retain only the exact
identification with the standard Steinhardt \(W_6\) normalization and delete
the speculative order-parameter paragraph, empirical claim row, and
physical-language keywords.

The audit discusses twelve sources: three were read at `full text` depth,
seven at `partial` depth, one at `abstract/metadata only`, and one at
`secondary only`. The supplementary exact-combination searches found no
predecessor for the \(5J_0\)/mod-\(11\)/degree-six bridge, but the access
gaps below do not license an unqualified priority claim.

## Claim ownership

| claim or mechanism | established source boundary | Paper III disposition |
|---|---|---|
| Mukai--Umemura threefold and Hitchin incidence construction | Mukai--Umemura introduce the threefold; Hitchin gives the skew-form/Grassmannian realization used here | cite both, but use Hitchin for every load-bearing formula |
| generic degree two and sextic branch \(J_0=0\) | Hitchin | prior art |
| \(J_0|_V=16\sigma_3^2\) and two golden parents over \(xyz\) | Hitchin | prior art |
| rational square class \(5J_0\) | inference from Hitchin's branch and golden fibre | paper-owned arithmetic normalization |
| square-\(5\) field criterion for Clebsch hexagons | Dye, Theorem 1 | prior art |
| explicit good reduction of the golden fibre and exchanger at \(11\) | exact substitutions and spinor calculation in the present evidence bundle | paper-owned specialization, not a global integral incidence theorem |
| finite signed tensor lies on \(\langle\sigma_3\rangle\) | explicit bridge and independent replay | paper-owned bridge; Paper III must state its input without requiring Paper II's narrative |
| order-twelve Hadamard model and row--column outer automorphism of \(M_{12}\) | Conway--Elkies--Martin, with Hall as the historical source; ATLAS records the relevant maximal-subgroup classes | classical context |
| marked Hitchin--Mathieu torsor | formal marked \(C_2\)-set identification after the two carriers are chosen | correct but nonessential; remove from focused note |
| standard \(Q_l,W_l\) bond-order invariants and the \(l=6\) icosahedral channel | Steinhardt--Nelson--Ronchetti | prior art |
| Gaunt/\(3j\) conversion | standard spherical-harmonic identity; DLMF \(\S34.3\)(vii) | cite as standard input |
| ten face axes, Petersen four-space, and exact Gaunt scalar | no predecessor located in the bounded search below | paper-owned exact harmonic bridge, with scoped novelty wording only |

## Global square class: exposition required by C668

The current proof is correct but too compressed for the paper's central
arithmetic claim. C668 should expose the following chain as a lemma and a
short proof rather than a single paragraph.

1. Hitchin's integral incidence variety gives a quadratic extension of
   \(\mathbf Q(\mathbf P(H))\).
2. Its branch divisor is the irreducible sextic \(J_0=0\).
3. Since \(\operatorname{Pic}(\mathbf P(H))\) has no two-torsion, a
   quadratic extension with that branch has square class \(cJ_0\) for a
   unique \(c\in\mathbf Q^\times/\mathbf Q^{\times2}\).
4. Hitchin's two points over \(xyz\) are defined by
   \(t^2-t-1=0\), hence their residue algebra is
   \(\mathbf Q(\sqrt5)\).
5. Hitchin's restriction \(J_0|_V=16\sigma_3^2\) makes \(J_0(xyz)\) a
   nonzero rational square in the chosen normalization, so the fibre fixes
   \(c=5\).
6. On \(D(\sigma_3)\subset\mathbf P(V)\), dividing the odd generator by
   \(4\sigma_3\) identifies the restriction with the constant golden
   torsor.

This is a rational function-field argument. It neither constructs an
integral Mukai--Umemura incidence model nor proves good reduction of that
global comparison at \(11\). The explicit golden fibre has its own integral
equations and therefore supports the stated specialization independently.

## Bibliography repair

The candidate's six references omitted the source of the
Mukai--Umemura name, any reference for the Mathieu/Hadamard paragraph, and
the standard Gaunt/\(3j\) identity. The manuscript bibliography now adds:

- Mukai--Umemura for the original threefold;
- Conway--Elkies--Martin for a direct order-twelve Hadamard construction
  and the row--column outer automorphism;
- the online ATLAS for the two \(M_{11}\) classes and the \(L_2(11)\)
  maximal subgroup; and
- DLMF \(\S\S14.30,34.3\) for spherical-harmonic conventions and the
  Gaunt/\(3j\) formula.

These additions make the current candidate accurately sourced. C668 should
remove the two Mathieu citations together with the marked carrier section;
their addition here is not a reason to retain that branch. The focused
revision should keep the Mukai--Umemura and DLMF citations.

The title page in the current source already names Tavis Rudd. The external
review's missing-author finding therefore applies to an earlier rendered
version or export; C670 must check the author visually in the regenerated
PDF.

## Source audit

1. **Nigel Hitchin, _Spherical harmonics and the icosahedron_.**
   Read depth: `full text`, arXiv v1, cache key `arXiv:0706.0088`,
   SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
   Sections 3--4 and 9--10 supply the Clebsch chart, the two golden
   configurations, the sextic branch, and the restriction
   \(16\sigma_3^2\). Published DOI: `10.1090/crmp/047/14`.

2. **Nigel Hitchin, _Vector bundles and the icosahedron_.**
   Read depth: `full text`, cached arXiv version, cache key
   `arXiv:0906.4208`, SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
   Sections 4--5 establish the zero locus and Chern-number-two incidence;
   Sections 7--9 give the trichotomy and binary-sextic model. Published
   DOI: `10.1090/conm/522/10292`.

3. **R. H. Dye, _Hexagons, conics, \(A_5\) and
   \(\operatorname{PSL}_2(K)\)_.**
   Read depth: `full text`. The OCR reconstruction was read and
   load-bearing text was checked against the authoritative scans of pages
   271, 272, 275, and 279, as recorded in C653. Reconstruction SHA-256:
   `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`.
   Theorem 1 owns the characteristic-not-\(2\), square-\(5\) criterion.
   DOI: `10.1112/jlms/s2-44.2.270`.

4. **V. Krishnamoorthy, T. Shaska, and H. Völklein,
   _Invariants of Binary Forms_.**
   Read depth: `partial`, arXiv Sections 1--3.4, cache key
   `arXiv:1209.0446`, SHA-256
   `33a6b9c20c469d89f21cbbc1e8e4cb3af3934332b7301d1957161dc30ec7620a`.
   The cited sections give the characteristic-\(>5\) binary-sextic
   invariant presentation.

5. **Shigeru Mukai and Hiroshi Umemura, _Minimal rational threefolds_.**
   Read depth: `abstract/metadata only`. DOI metadata and later primary
   bibliographies identify Lecture Notes in Mathematics 1016 (1983),
   pages 490--518, DOI `10.1007/BFb0099976`. The full text was not
   reachable. No formula in Paper III is attributed to this unread source;
   Hitchin supplies the load-bearing construction.

6. **P. J. Steinhardt, D. R. Nelson, and M. Ronchetti,
   _Icosahedral Bond Orientational Order in Supercooled Liquids_.**
   Read depth: `partial`, published PDF abstract, order-parameter
   definition, and numerical discussion. Cache key
   `10.1103/PhysRevLett.47.1297`, SHA-256
   `762f38490ed9b29e6bec0d67113fc3e35d4493759ca3dbfa5798cae04f187eef`.

7. **P. J. Steinhardt, D. R. Nelson, and M. Ronchetti,
   _Bond-Orientational Order in Liquids and Glasses_.**
   Read depth: `partial`, published PDF introduction, Section II,
   equations (1.1)--(2.6), Figure 2, and Table I. Cache key
   `10.1103/PhysRevB.28.784`, SHA-256
   `0efaad674f48c98b716e6732c63e2b04b0d5339c0844c733e72d09d58d041fc5`.
   These sections define \(Q_l,W_l\) and the \(l=6\) icosahedral channel.

8. **John H. Conway, Noam D. Elkies, and Jeremy L. Martin,
   _The Mathieu group \(M_{12}\) and its pseudogroup extension
   \(M_{13}\)_.**
   Read depth: `partial`, arXiv v1 Sections 3--4, cache key
   `arXiv:math/0508630`, SHA-256
   `05dc75d74c729b1c1edc85542ae970a1b1f843fcbe0111043463e2a435c47c94`.
   Section 4 constructs the order-twelve Hadamard model and proves that
   exchanging point and line actions gives the outer automorphism.

9. **Peter J. Cameron, _Hadamard matrices_.**
   Read depth: `partial`, _Encyclopedia of Design Theory_ PDF, Sections
   3--4, accessed at
   `https://maths.qmul.ac.uk/~pjc/design/encyc/topics/had.pdf`.
   No DOI/cache key was available. Page 4 summarizes Hall's theorem:
   uniqueness at order twelve, automorphism quotient \(M_{12}\), and the
   row--column outer automorphism.

10. **R. A. Wilson, R. A. Parker, and J. N. Bray,
    _ATLAS of Finite Group Representations: Mathieu group \(M_{12}\)_.**
    Read depth: `partial`, online group page, maximal-subgroup table and
    generator records, accessed at
    `https://brauer.maths.qmul.ac.uk/Atlas/v3/spor/M12/`.
    It records two \(M_{11}\) maximal subgroups and one \(L_2(11)\)
    maximal subgroup. It does not by itself establish the intersection of
    the two specific manuscript carriers.

11. **NIST Digital Library of Mathematical Functions.**
    Read depth: `partial`, Release 1.2.7 of 2026-06-15,
    \(\S14.30\) and \(\S34.3\)(vii), accessed at
    `https://dlmf.nist.gov/`. These sections fix the spherical-harmonic
    convention and state the Gaunt coefficient in terms of \(3j\)-symbols.

12. **Marshall Hall, Jr., _Note on the Mathieu group \(M_{12}\)_.**
    Read depth: `secondary only` through Cameron's partially read survey
    and Conway--Elkies--Martin's partially read paper. The original
    _Archiv der Mathematik_ 13 (1962), 334--340 was not reached and is not
    used as a load-bearing manuscript citation.

## Search coverage

The negative is narrow: no consulted work states the combined arithmetic
normalization, \(p=11\) signed-cubic specialization, and exact degree-six
face-axis restriction. It is not a claim that these component subjects or
their standard constructions are new.

Queries run on 2026-07-26:

- OpenAlex `search=Clebsch cubic icosahedral harmonic&per-page=20`
  returned 43 metadata results. The first 20 were screened by title,
  abstract, year, and DOI; Hitchin's vector-bundle paper was the only
  close result, and it does not contain the degree-six face-axis theorem.
- OpenAlex
  `search=Hitchin Clebsch Mathieu M12 golden icosahedron&per-page=20`
  returned zero results, distinguished from an error by a valid response
  with `meta.count=0`.
- Crossref
  `query.bibliographic=Clebsch cubic icosahedral harmonic&rows=10`
  returned a broad result set; the first ten title/DOI records were
  screened and were irrelevant. This query licenses no exhaustive
  negative.
- Web title/phrase searches used
  `"Clebsch cubic" spherical harmonics degree six`,
  `"Clebsch cubic" "Wigner" icosahedron`,
  `"Petersen" "face axes" icosahedron harmonic`,
  `"Steinhardt" "Clebsch" cubic`,
  `"row-column duality" M12 Hadamard`, and
  `"Hadamard" "two conjugacy classes" M11 M12`.
  They recovered Hitchin, the standard Steinhardt literature, the
  Conway--Elkies--Martin construction, Cameron's survey, and ATLAS, but no
  combined bridge.
- The arXiv API query
  `all:"Clebsch cubic" AND all:icosahedron` did not return before the
  bounded client timeout. It is recorded as NOT COVERED, not as a zero.

MathSciNet and Google Scholar were not covered. No forward-citation
closure is claimed, so citation-graph counts are not used. The inaccessible
Mukai--Umemura and Hall originals remain access gaps. Any novelty sentence
must therefore be restricted to the consulted literature and to the exact
combined bridge.

## C668 handoff

C668 should:

1. aim at algebraic geometers and invariant theorists who can read the
   spherical-harmonic calculation, rather than simultaneously courting a
   sporadic-group or materials audience;
2. expand the six-step rational square-class argument above;
3. make the finite tensor input self-contained at theorem/interface level
   and cite Paper II only for its geometric origin;
4. delete the marked Mathieu subsection and consequence;
5. delete the speculative \(C_4\) descriptor, empirical claim row, and
   research-inventory paragraph;
6. retain the exact Steinhardt normalization as mathematical context; and
7. preserve the three distinct integral boundaries: the abstract quadratic
   algebra, the nonmodular invariant presentation, and the geometric
   incidence comparison over an unspecified localization.

No new computational result is introduced by C669.

## Validation

The four citation additions leave all nine theorem-like statements
mathematically unchanged. The statement identity was regenerated from the
edited source, and the full Paper III aggregate passed all thirteen checks,
including the primary and independent arithmetic, finite-tensor, and
harmonic routes plus the warning-free manuscript build.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-passages/verification/statement_identity.json` | 9,787 | `a7dd50d6bb2e92c9a6890ff73e51537f410f3df7cd19cb92434ec393ddfc16d6` |
| `papers/clebsch-passages/clebsch_passages.pdf` | 118,464 | `31d9cb2ae4f597e3cfbf62d419a2ba01c1942b8c8905573cb40564b100be8561` |

## Extra-juice and Tao closeout

The closeout sharpens the editorial decision. The marked Mathieu statement
does not merely lack motivation; after the two carriers are constructed, its
proof uses only the universal fact that a marking determines a unique map
between free transitive \(C_2\)-sets. Removing it therefore loses no
mechanism from either leg of the main theorem. This is stronger evidence for
deletion than a judgment about audience alone.

The author-name finding was also resolved cheaply: the current TeX source
already contains `\author{Tavis Rudd}`. It is a stale-export or rendering
finding, not an unimplemented source edit. C670 should verify the regenerated
title page visually.

## Mystery ledger

- **Settled:** the exact paper-owned bridge is the rational \(5J_0\)
  normalization plus the mod-\(11\) and degree-six realizations; none of the
  component classical constructions should be claimed as new.
- **Settled:** the marked Mathieu carrier is correct but mathematically
  detachable and should be removed by C668.
- **Settled:** the physical descriptor is an untested application proposal,
  not part of the exact harmonic theorem, and should be removed by C668.
- **Settled:** the current source has an author name; only PDF/export
  verification remains.
- **Open but already bounded:** the minimal bad-prime set for the geometric
  incidence comparison requires an explicit integral incidence model and is
  not owned by C668.
- **Open but outside this revision:** an intrinsic integral explanation of
  the Gaunt denominator, especially its factor \(11\), has no allocated
  successor and is not needed for equality of the cubic line.
- **No further C669 mystery remains.**
