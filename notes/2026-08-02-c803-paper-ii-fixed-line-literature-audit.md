# C803 — Paper II fixed-line literature and exposition audit

**Date:** 2026-08-02

**Lane:** `clebsch`

**Status:** complete

## Executive verdict

This audit directly read **one individually named source at full-text
depth**, three at partial depth, and four at abstract/metadata depth.  It
found one material attribution collision but no collision with the C798
theorem.

The exceptional one-factorizations are classical.  Cameron--Korchm\'aros
(1993) classify the complete-graph one-factorizations with a doubly
transitive vertex action; their list contains the sporadic \(K_{12}\) case
with full group \(\operatorname{PSL}_2(11)\).  Han (2025) classifies
symmetric factorizations of complete graphs and explicitly lists the
feasible triples

\[
 (\operatorname{PSL}_2(7),S_4,8,7),\qquad
 (\operatorname{PSL}_2(11),A_5,12,11).
\]

Thus Paper II cannot claim the existence or uniqueness of these exceptional
one-factorizations.  No screened source states the paper's actual level-up:

- the affine line of \(K\)-fixed conic-product lifts;
- the unique intersection of that line with the completely reducible Chow
  locus; or
- the \(q-2\) nonmatching \(G\)-orbits on the line with the same exact
  one-dimensional, two-valued Schur-square trade.

The defensible boundary is therefore **classical combinatorial endpoint,
new geometric and coding-theoretic bridge**.  This is a bounded negative,
not a universal priority guarantee.

## Claim-by-claim verdict

| Claim surface | Verdict | Disposition |
|:--|:--|:--|
| Exceptional \(B_3/H_3\) one-factorizations and their groups | **VERIFIED COLLISION / CLASSICAL** | Cite Cameron--Korchm\'aros and Han; make no novelty claim for existence or uniqueness. |
| \(\mathcal A_T^K=P_{M_T}+\mathbf F_qQ^{d/2+1}\), with its \(q\) rational points in distinct \(G\)-orbits of stabilizer \(K\) | **NO COLLISION LOCATED** | Retain.  The invariant-line and subgroup ingredients are classical; their placement in this conic-product fiber is the paper-owned synthesis. |
| The fixed line meets the full completely reducible Chow locus only at \(P_{M_T}\) | **NO COLLISION LOCATED, WITH A CLASSICAL COMBINATORIAL INPUT** | Retain the geometric statement.  The uniqueness of the underlying invariant matching is not advertised separately as new. |
| Exactly \(q-2\) nonmatching orbits satisfy the same exact two-valued quadratic-trade condition | **NO COLLISION LOCATED** | Retain as the sharp counterexample to carrier-free classification. |
| General self-associated/Schur-square/arithmetically-Gorenstein mechanism | **VERIFIED NEAR-EXACT PREDECESSOR** | Continue to credit Rodr\'iguez-Pajares--Ruano--Salizzoni (2025), which imports the geometric bridge from Eisenbud--Popescu. |
| Exact \(B_3/H_3\) matching-carrier classification and sheet-sign cubic | **NO COLLISION LOCATED IN THIS AUDIT OR THE CROSS-PAPER AUDIT** | Retain as the configuration-specific theorem. |

## Internal series overlap

This is not a literature collision, but it matters for unity and claim
ownership.

### C494 / Paper I

C494 already kernel-checks the finite \(B_3/H_3\) middle information
lattices.  It proves that the `(sheet,D')` fibers are the displayed
\(K\)-orbits, that the sheet coordinate is load-bearing, and that the
invariant function-algebra towers have dimensions

\[
 1<2<6<14,
 \qquad
 1<2<6<22.
\]

Paper II should treat these facts as series infrastructure.  C798 does not
duplicate them: it leaves the finite matching set, moves along a new affine
line in the ambient conic fiber, and proves a Chow-selection theorem there.
The new proof neither needs nor reproduces the eleven-orbit census.

### Other Clebsch papers

- Paper I owns recovery of the matching row and its finite information
  lattice from the marked syndrome geometry.
- Paper III consumes the oriented sheet/cubic datum in its arithmetic and
  harmonic realizations; it does not classify the ambient fixed line.
- Paper IV concerns the \(q=13\) passant code and has no theorem-level
  overlap with C798.
- The Golden companion cites Paper II's matching-quotient geometry.  It does
  not independently prove the fixed-line or Chow-intersection result.

No further material internal collision was found.  The series reads most
cleanly if Paper I owns finite recovery, Paper II owns the sharp carrier
boundary and cubic, and Paper III owns transport and realization.

## Sources and read depth

### Full text

1. G. Rodr\'iguez-Pajares, D. Ruano, and F. Salizzoni, *A combinatorial
   description of when a self-associated set of points fails to be
   arithmetically Gorenstein*, arXiv:2512.16766v1 (2025).  Full text read,
   especially Theorem 3.11 and Corollaries 3.12--3.13.  Cached PDF and text;
   SHA-256
   `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
   Theorem 3.11 gives
   \(\dim C^{(2)}=2k-nb(C)\); Corollary 3.13 characterizes the Gorenstein
   column configurations by indecomposability.  It contains no
   \(S_4/A_5\) matching, fixed-line, or Chow-selection result.

### Partial

2. H. Han, *Symmetric factorisations of complete graphs*, *Mathematical
   Foundations of Computing* 8 (2025), no. 3, 372--378,
   DOI `10.3934/mfc.2023046`.  Read the official metadata, abstract, complete
   displayed Table 1, and indexed proof passages; the publisher PDF endpoint
   returned no PDF, so this is not a full-text reading.  The abstract gives
   the classification of symmetric one-factorizations, and Table 1 contains
   both exact triples used above.  Official version accessed 2026-08-02.

3. H. D. L. Hollmann and Q. Xiang, *Association schemes from the action of
   PGL(2,q) fixing a nonsingular conic in PG(2,q)*,
   arXiv:math/0503573v1 (journal version DOI
   `10.1007/s10801-006-0005-8`).  Read the abstract, introduction, action and
   cross-ratio setup, and a full-text term scan.  Cached PDF and text;
   SHA-256
   `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.
   This is the closest conic-action neighbor, but it studies pair relations
   and association schemes, not perfect-matching products, Chow
   intersections, or Schur-square trades.

4. P. Brookfield, *Completely Reducible Ternary Cubic Forms*,
   arXiv:2107.02325 (2022 version).  Read the abstract, introduction,
   Theorem 9.2, and a full-text discriminator scan.  Cached PDF and text;
   SHA-256
   `523b9144598c83ae39463a36d53ff5d347bd3d726e2657282e7f4ce63b8ccdb3`.
   It gives invariant criteria for complete reducibility of ternary cubics
   over characteristic zero, not the degree-four/six finite-field fixed
   lines in Paper II.

### Abstract/metadata only

5. P. J. Cameron and G. Korchm\'aros, *One-factorizations of complete
   graphs with a doubly transitive automorphism group*, *Bull. London Math.
   Soc.* 25 (1993), 1--6, DOI `10.1112/blms/25.1.1`.  The bibliographic
   record and complete abstract were read through Crossref and OpenAlex;
   the cached DOI response is an HTML interstitial rather than the article,
   SHA-256
   `ac32a4ec5756b879b87b13ae58e1f4f61b853ca25dd0cac7c71ecd0366f0b3d8`.
   Because no article text was obtained, the read depth is
   abstract/metadata only.

6. A. Bernardi, E. Carlini, M. V. Catalisano, A. Gimigliano, and A. Oneto,
   *The Hitchhiker Guide to: Secant Varieties and Tensor Decomposition*,
   and the OpenAlex Chow/secant results headed by *Equations for secant
   varieties of Chow varieties* (arXiv:1602.04275) and *All secant varieties
   of the Chow variety are nondefective for cubics and quaternary forms*
   (arXiv:2005.12436), were screened at title/abstract/metadata depth only.
   They concern general secant geometry and do not state the finite
   exceptional intersection used here.  They are not relied on for a
   positive claim.

## Screened sets

All searches were run on 2026-08-02.  For each returned set, the first 25
records were screened in title and available abstract/metadata.  The
discriminator was applied verbatim as follows:

> Promote a record only if its title or abstract contains one exact group
> term (`PSL(2,7)`, `PGL(2,7)`, `S4`, `PSL(2,11)`, `PGL(2,11)`, or `A5`)
> together with at least one mechanism term (`matching`, `one-factor`,
> `conic`, `Schur`, `Chow`, or `fixed line`), or if it states a general
> theorem about symmetric/doubly-transitive one-factorizations.

### OpenAlex

| Query | Reported count | Screened outcome |
|:--|--:|:--|
| `PGL(2,11) A5 conic matching` | 0 | exact empty result |
| `PGL(2,7) S4 conic matching` | 0 | exact empty result |
| `self-associated Schur square two-valued trade` | 1,447 | first 25 screened; token-OR noise dominated; RPRS promoted by direct title/claim search |
| `perfect matching secant products conic Chow` | 4 | all four screened; none passed |
| `fixed line Chow locus icosahedral quartic` | 9 | all nine screened; generic Wiman/icosahedral and birational neighbors, none passed |

The two zero results are genuine API results: the same requests returned
valid metadata and ordinary results for the broader queries.

### Crossref

The same first four queries were run with `query.bibliographic`, 25 rows
each.  Crossref reported 6,026,536; 209,500; 4,784,804; and 737,220 results,
respectively.  These counts expose broad token matching rather than useful
exact-hit counts.  The first 25 of each set were screened with the stated
discriminator.  Hollmann--Xiang was promoted from both group/conic queries;
no fixed-line, Chow-selection, or exact-trade predecessor was promoted.

### Semantic Scholar and other indexes

Semantic Scholar returned HTTP 429 before a result set was delivered; it is
**not covered**, not an empty search.  Automated Google Scholar and
MathSciNet were not covered.  The public publisher pages, Crossref,
OpenAlex, arXiv, and ordinary exact-phrase web searches were covered.  No
citation graph was used, so the three-graph citing-set rule is inapplicable.

## Manuscript changes

The authoritative Paper II source now:

- replaces the long method-led abstract by a three-step theorem narrative:
  classification on the matching carrier, sharp failure on the fixed line,
  and recovery by the Chow condition;
- says there that the exceptional one-factorizations are classical and
  places novelty in their conic-quotient geometry and signed moments;
- cites Cameron--Korchm\'aros and Han at the first definition of the
  matching configurations;
- introduces the conic-product affine fiber and the completely reducible
  Chow locus in plain language before the theorem;
- retitles the result *The fixed line and its Chow point*; and
- adds one compact carrier-boundary diagram displaying the classification,
  the \(q-2\) nonmatching false positives, and the unique Chow point; and
- replaces the workflow language “quarantined,” “deliberately fails,” and
  “proof spine” by a short mathematical remark about the unused
  coalescence rank.

This is the Milnor/Serre pass: definitions precede the theorem, classical
inputs are separated from the new assertion, and the proof retains only the
four structural moves—invariants, stabilizers, factorization, and radial
translation.  No orbit table enters the manuscript.

The regenerated statement identity contains 29 statements and the trust
manifest contains 14 evidence bundles.  The full aggregate release gate
passed every primary check, independent replay, guarded Lean gate and axiom
allowlist, warning scan, and PDF build.  The result is a warning-free
41-page PDF.  Pages 1--3 and 22--23 were visually inspected; the abstract,
carrier diagram, theorem opening, and page break are clean.

## Effect on paper strength and venue

The literature collision lowers the novelty of the combinatorial starting
object but not the mathematical grade of the new theorem.  C798 improves
Paper II more than the collision costs: it converts a necessary carrier
hypothesis into a sharp theorem and supplies a faithful observable that
selects the intended configuration.

- **Mathematics:** roughly a half-grade improvement over the pre-C798
  version.  The paper now has a clean negative classification boundary and
  a positive Chow-rigidity replacement, rather than an unexplained
  hypothesis.
- **Unity:** a full-grade improvement.  The same radial sheet coordinate now
  explains classification, failure outside the carrier, and why complete
  reducibility repairs the failure.
- **Venue:** the change strengthens the case for a solid specialist journal
  in finite geometry, coding theory, or algebraic combinatorics.  It does
  not by itself turn the paper into a broad top-tier result: the theorem is
  still exceptional-field and representation-specific, and the general
  Schur-square/Gorenstein mechanism is imported.  The best pitch is the
  exact bridge among exceptional one-factorizations, modular Schur-square
  trades, and Chow rigidity.

## Vibe check

The paper now feels less like an exceptional classification followed by a
list of consequences and more like one argument about information loss:
the trade recovers the sheets, fails at one precisely described enlargement,
and complete reducibility repairs that failure.  The price is honest and
small—the exceptional one-factorizations are credited as classical.  The
gain is a cleaner reason for the paper to exist.

## Extra-juice / Tao closeout

The strongest free consequence is negative: the two-valued trade is not a
faithful observable even with the stabilizer fixed.  The full completely
reducible Chow condition is faithful on exactly the ambiguity line produced
by that failure.  This is stronger and cleaner than merely exhibiting
counterexamples, and it uses no census.

Two tempting enlargements were rejected.  The signed cubic distinguishes
the rational fixed-line points computationally but supplies no intrinsic
matching selector.  The coalescence point also retains square corank one in
the exact census, but no structural explanation is presently needed.  Both
would lengthen the paper without strengthening its current classification
boundary.

## Mystery ledger

- **Settled — published priority of the one-factorizations.** Cameron--
  Korchm\'aros and Han own the classical combinatorial endpoint.
- **Settled — relation to C494.** C494 owns the finite sheet/profile
  information lattice; it does not own the ambient fixed line or its Chow
  intersection.
- **Settled — nearest conic and Chow neighbors.** Hollmann--Xiang concerns
  the conic association scheme; Brookfield and general Chow/secant papers
  concern reducibility or secant geometry without the exceptional finite
  bridge.
- **Open coverage gap.** MathSciNet, automated Google Scholar, the full Han
  text, and the full Cameron--Korchm\'aros text were not obtained.  The
  no-collision verdict for C798 remains bounded accordingly.
- **Open but non-load-bearing.** A conceptual explanation of the
  coalescence-point square rank and an intrinsic selector from the cubic
  family remain outside the theorem.
