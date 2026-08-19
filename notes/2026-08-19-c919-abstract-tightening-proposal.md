# C919 follow-up — standalone abstract tightening for Clebsch I–V (external proposal)

**Lane:** `clebsch` · **Date:** 2026-08-19 · **Status:** external proposal, under review — nothing applied

**Provenance.** Received from the author's external collaborator ("Sol") on 2026-08-19 and
reproduced here verbatim below the horizontal rule. It is a proposal only. No manuscript edit,
build, or release action follows from this file; per-paper review memos live alongside it under
`notes/2026-08-19-c919-abstract-memos/`.

**Author preference on record:** abstracts should stay tight and short.

---

C919 follow-up — standalone abstract tightening for Clebsch I–V

Date: 2026-08-19
Scope: abstracts only
Status: author-facing edit instructions for Opus
Source basis: current main branches of all five paper repositories, checked against the full TeX structure, main theorem statements, introductions, and conclusions. For Paper III, the included section files were checked as well.

Governing principle

The programme apparatus has now been moved out of the paper fronts. The abstracts should finish the same job: each one must read as the abstract of a standalone paper, with its strongest theorem visible early and without requiring knowledge of the Clebsch programme.

This is not a theorem-editing pass. Do not change theorem statements, proofs, titles, keywords, MSC codes, bibliography, or programme codas. Do not add priority claims. Preserve the papers’ own terminology and qualification level.

The edits below are deliberately conservative: they tighten hierarchy and repetition while retaining every major mathematical claim presently advertised.

────────

Paper I — clebsch-rigidity

Title:

> **Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus**

What to improve

The current abstract is mathematically accurate, but it repeats the reconstruction idea several times:

• deep-hole locus recognizes the code;
• metric boundary recovers geometry;
• conic recovers polarity;
• decoder multiplicities recover further structure;
• ambiguity recovers orientation;
• then “the same syndrome and support data recover both the code and its golden orientation.”

The standalone headline is stronger if the first paragraph gives the recognition theorem cleanly, the second gives the orientation lift, and the last gives the uniform consequence.

Do not lose the distinction between:

• the deep-hole syndrome locus;
• the additional decoder multiplicity/support data used later;
• the exceptional (q=11) recognition theorem;
• the field-uniform conic-filling bound.

Replace the abstract with

```latex
\begin{abstract}
Let \(A\) be a six-arc in \(\PG(2,11)\), and let \(\cU(A)\) be the
projective deep-hole syndrome locus of its associated \([6,3,4]_{11}\)
MDS code, equivalently the projective points lying on no chord of \(A\).
We prove that \(\cU(A)\) lies on a conic if and only if \(A\) is
projectively equivalent to the Clebsch hexagon; in that case
\(\cU(A)\) is exactly a nonsingular conic.  Thus the deep-hole locus is
a recognition invariant for the non-GRS Clebsch code up to monomial
equivalence: its metric boundary recovers the parity-check geometry,
after which the conic determines its polarity and Dye's theorem
identifies the stabilizer as \(A_5\).  Decoder multiplicities further
recover the Brianchon points, self-polar triangles, and an intrinsic
bipartition of the three-coordinate supports.

Nearest-codeword ambiguity then recovers an unordered orientation torsor
on six axes.  Its signed orbital operator satisfies \(B^2=5I\), and
triangle holonomy gives the support cubic
\(c_{ijk}=B_{ij}B_{jk}B_{ki}\); equivalently, this cubic is the sole
nonsymmetric term in the diagonal determinant pencil of \(B\).
Consequently the decoder data recover not only incidence and symmetry
but the golden orientation and the integral quadratic order
\(\mathbf Z[B]\simeq\mathbf Z[\sqrt5]\).

The proof uses a universal chord-defect identity and a partial-cover
bound.  As a uniform consequence, any \(k\)-arc whose uncovered locus
is a nonsingular conic has \(q\) odd and
\[
2k-3\le q\le \frac{k(k-1)+3}{3}.
\]
Hence for each fixed \(k\), the all-field conic-filling existence
problem reduces to finitely many field orders.
\end{abstract}
```

Red-team notes

• Safe: “projective deep-hole syndrome locus … equivalently the projective points lying on no chord” is exactly the redundancy-three MDS dictionary used in the paper.
• Safe: “recognition invariant … up to monomial equivalence” matches the paper’s own conclusion and introduction.
• Safe: the abstract still does not claim the syndrome locus alone supplies all orientation information; the second paragraph says “decoder data,” preserving the manuscript’s use of multiplicities/support ambiguity.
• Safe: the integral order is recovered from the orientation/support data, not from the bare conic.
• Do not strengthen “lies on a conic” to “is a conic” in the hypothesis; forcing containment to equality and nonsingularity is part of the theorem.
• Keep the uniform (k)-arc consequence. It is important to the paper’s standalone scope and prevents the abstract from reading as only an exceptional (q=11) classification.

────────

Paper II — clebsch-factorization

Title:

> **Quadratic trade rigidity and cubic orientation in conic matching quotients**

What to improve

This abstract is already structurally strong. The main opportunity is the final paragraph, which currently shifts from theorem content into a dense list of proof machinery.

The key standalone hierarchy is:

1. all-field classification: exactly (B_3/\F_7) and (H_3/\F_{11});
2. the perfect-matching boundary is sharp;
3. quadratic data recover unordered sheets;
4. the first signed nonzero tensor is cubic and restores orientation;
5. Gorenstein/Macaulay interpretation is a consequence, not the premise.

Retain the sentence that the classical one-factorizations are not the novelty; the fixed-line boundary and its unique split point are.

Replace the abstract with

```latex
\begin{abstract}
Restriction to a conic forgets how its marked points were paired into
secants.  Among full \(\operatorname{PGL}_2(q)\)-orbits of perfect
matchings over odd finite fields, we classify those whose
conic-quotient evaluation space has a one-dimensional strength-two
trade---a signed relation annihilating all quadratic coordinate
products---generated by a two-valued vector.  Exactly two occur: the
balanced \(B_3/\F_7\) and \(H_3/\F_{11}\) orbits.  In each case the
trade recovers the two complementary sheets, without assuming
self-association or Gorensteinness.

The restriction to perfect matchings is sharp.  For either surviving
stabilizer, its fixed locus in the ambient conic-product fibre is an
affine line of \(q\) pairwise nonconjugate rational points.  Only the
matching point splits completely into linear factors, although
\(q-2\) nonmatching orbits have the same one-dimensional two-valued
strength-two trade condition; the remaining rational point is the
coalescence parameter.  Thus complete splitting selects the matching
orbit from the fixed line.  The exceptional one-factorizations are
classical; the new boundary is the fixed line and its unique completely
split point.

For the two matching configurations, signed tensor moments vanish
through degree two and the first nonzero signed moment is an
anti-invariant cubic, which orients the recovered sheets.  Their
\(14\)- and \(22\)-point homogenizations are self-associated and
arithmetically Gorenstein, and maximal isotropy identifies this cubic
with the Macaulay inverse system of an Artinian reduction.  General
self-dual-code criteria explain the Gorenstein consequence; the new
configuration-specific content is the all-field orbit classification,
the sharp matching boundary, sheet reconstruction, and cubic
orientation.  Targeted modular detectors, made exhaustive by Faber's
tame subgroup theorem, exclude every other matching orbit without a
field census.
\end{abstract}
```

Red-team notes

• Safe: “signed tensor moments vanish through degree two” matches the theorem and the tensor-syzygy corollary.
• Safe: “the first nonzero signed moment is an anti-invariant cubic” is the paper’s actual orientation mechanism.
• Safe: “unique completely split point” refers to the fixed affine line in the ambient conic-product fibre, not to all points/configurations globally.
• Safe: “all-field orbit classification” means all odd prime powers within the full perfect-matching carrier, exactly as the theorem states. Do not shorten this to “all conic matchings” or “all configurations.”
• Do not say that quadratic data recover the ordered sheets. They recover the complementary halves only up to interchange; the cubic restores the orientation.
• The alternating-cycle/Dickson radial-nonvanishing sentence is omitted from the abstract. It remains fully documented in the introduction/proof and is secondary to the abstract’s theorem hierarchy.

────────

Paper III — clebsch-passages

Title:

> **Golden descent and operator realizations of the Clebsch cubic**

What to improve

The current abstract contains the right results but presents them at nearly equal weight. The paper actually has a clean spine:

1. determine the exact arithmetic square class of Hitchin’s incidence double cover;
2. after a marked bridge datum is fixed, transport a chosen sheet/sign to an oriented order-six conference source;
3. realize the resulting cubic in four exact operator languages and return its relative sign through the degree-six harmonic model;
4. state two independent structural consequences on the same conference carrier.

The marking caveat is essential. Do not let the abstract suggest that a sheet by itself canonically determines the conference labels/source.

The harmonic comparison is also only a relative marked sign comparison between cubics on different spaces. Preserve that qualification.

Replace the abstract with

```latex
\begin{abstract}
Let \(H\) be the rational seven-space of harmonic cubics.  Hitchin's
icosahedral incidence variety is generically a degree-two cover of
\(\mathbf P(H)\).  We determine its arithmetic square class exactly:
if \(J_0\) is the rational equation of the reduced branch sextic
normalized by \(\iota_t^*J_0=16\sigma_3^2\) on the Clebsch chart, then
the function field is
\[
\Q(\mathbf P(H))(\sqrt{5J_0}),
\]
and the finite Stein algebra is
\(\mathcal O\oplus\mathcal O(-3)\) with multiplication \(z^2=5J_0\).
The complete reduced fibre over \([xyz]\) has residue algebra
\(\Q(\sqrt5)\) and determines the twist.

After an ordering, chart lift, outer labels, and Petersen labels are
fixed as a marked bridge datum, a chosen sheet selects an order-six
conference source or its opposite; the sheet alone supplies none of
this marking.  The resulting source cubic and its six outer translates
admit four exact descriptions: triangle holonomy, middle-exterior
diagonal, commutator Pfaffian, and oriented cross-golden determinant.
These give the signed Joubert--Segre--Igusa--Clebsch chain.  Under the
marked Petersen pair-sum comparison, the degree-six zonal-harmonic
cubic restricts exactly to
\[
-\frac{784000}{1247103}\,\sigma_3.
\]
This is a relative sign comparison between cubics on different spaces,
not an identification of their ambient harmonic representations.

The same conference carrier has two independent structural
consequences.  Cut-independence of the balanced exchange spectrum
singles out order six.  Aligned four-sets reconstruct every two-graph
on at least seven vertices up to complement, with seven sharp; hence
the determinant-\((-3)\) four-blocks recover every symmetric conference
signing of order at least ten up to switching and global negation.
The characteristic-zero incidence theorem is independent of the
unresolved problem of determining the exact finite set of primes over
which the geometric incidence comparison spreads out.
\end{abstract}
```

Red-team notes

• Safe: the factor (5) is not merely inferred from the branch equation; the complete reduced (xyz)-fibre is used to determine the global square class. The wording reflects this.
• Safe: “chosen sheet selects … source or its opposite” is explicitly conditioned on the marked bridge datum. Never shorten this to “a sheet determines the conference source.”
• Safe: the four operator descriptions are descriptions of the same marked cubic/source family after normalization/marking.
• Safe: the harmonic coefficient is retained exactly, and the abstract explicitly preserves the manuscript’s warning that the two cubics live on different spaces.
• Safe: “every two-graph on at least seven vertices” is genuinely uniform and seven is sharp.
• Safe: for conference matrices the theorem applies from order (n\ge10) and recovers the signing up to diagonal switching and global negation.
• Do not call the two-graph/exchange-spectrum results consequences of Hitchin’s incidence cover. The paper explicitly presents them as independent structural consequences using the conference carrier.
• Keep the spreading-out caveat. It prevents the characteristic-zero incidence statement from being read as an unstated integral/all-prime theorem.

────────

Paper IV — q13-passant-code

Title:

> **Reconstructing (\PG(2,13)), its conic, and polarity from the minimum words of a binary conic code**

What to improve

The present abstract is already good, but the conceptual theorem can be made more visible: the weighted 2-section of the minimum-support hypergraph is a complete invariant of the marked conic-plane presentation, and arity two is exact because unary statistics are constant.

Move that threshold statement forward. Keep the distance/orbit result because it identifies the minimum layer from which reconstruction starts, but compress proof-method details.

Replace the abstract with

```latex
\begin{abstract}
How little of an incidence code is needed to reconstruct the geometry
that produced it?  Let \(K\) be the binary nullspace of the
passant-by-internal incidence matrix of a nonsingular conic in
\(\PG(2,13)\).  We prove that \(K\) has parameters \([78,36,12]_2\)
and exactly \(364\) minimum words.  They form four
\(\PGL(2,13)\)-orbits---one octahedral family and three chord-indexed
punctured-conic families---and every orbit spans \(K\).

The weighted \(2\)-section of the minimum-support hypergraph is a
complete invariant of the marked conic-plane presentation.  Pair
concurrences recover the \(78\) passant incidence rows, the code, and
the six-class elliptic association scheme; pair parity alone recovers
\(K\).  The recovered scheme has automorphism group
\(\PGL(2,13)\), whose Sylow-\(13\) subgroups and involutions reconstruct
all \(183\) points and lines of \(\PG(2,13)\), the distinguished conic,
and its polarity, without coordinates or a projective frame.  Unary
minimum-support statistics are constant, so this reconstruction has
exact arity two.  The binary relation algebra acts on \(K\) through
\(\F_8\), making \(K\) twelve-dimensional over that field.

The minimum-distance proof excludes weight eight by a
positive-semidefinite clique obstruction and weight ten by line-moment
profiles followed by bounded stabilizer exhaustion.  The theorem is
intentionally specific to \(q=13\): it gives complete ambient
reconstruction, not a uniform distance formula.
\end{abstract}
```

Red-team notes

• Safe: “weighted (2)-section … complete invariant” is exactly the main theorem/conclusion’s information-threshold claim.
• Safe: “pair parity alone recovers (K)” matches (\operatorname{im}R_{\mathcal H}=K); do not extend it to saying parity alone recovers the full plane.
• Safe: full plane reconstruction proceeds through the recovered relation scheme/group and its Sylow-(13) subgroups and involutions.
• Safe: “without coordinates or a projective frame” matches the paper’s intrinsic reconstruction claim. The paper explicitly does not claim to canonically recover an ordered projective frame, field labeling, or conic equation.
• Safe: “exact arity two” is only about the specified minimum-support statistics/reconstruction problem; do not universalize it to arbitrary code invariants.
• Keep the fixed-(q=13) caveat. It is an important statement of scope.
• The detailed two-profile description of weight ten can stay in the body; the abstract only needs enough to show that the minimum-distance assertion is proved rather than assumed.

────────

Paper V — chordal-conference-reconstruction

Title:

> **Chordal and Conference Cubics: Reconstruction and a Residual (C_2)-Torsor**

What to improve

The current abstract is already fully standalone after C919 and should not be rebuilt from programme vocabulary. It has the right opening: inequivalent cubic shadows can retain the same source information.

The main improvement is compression and hierarchy. The first two paragraphs are the paper’s headline:

• conference and chordal members of one (A_5)-invariant pencil are geometrically distinct;
• the singular quartic recovers the six-axis carrier;
• selecting a chordal line yields mutually inverse normalized reconstruction;
• forgetting that choice leaves the precise free (C_2)-quotient.

The two-graph recognition identity and integral (\F_4)-normalization are independent secondary theorems and should remain, but can be stated more compactly.

Replace the abstract with

```latex
\begin{abstract}
Different lossy invariants of the same source need not have the same
geometry.  Let \(\Omega\) be the six Sylow-\(5\) subgroups of \(A_5\),
and let \(V\) be the five-dimensional augmentation module of
\(\F_{11}^{\Omega}\) with its standard quadratic form.  The
\(A_5\)-invariant cubic pencil in \(\PP(V)\) contains a conference
cubic with six isolated nodes and two chordal cubics, each singular
along a rational normal quartic.  Over \(\overline{\F}_{11}\), the
conference cubic is not projectively isomorphic to either chordal
cubic.  We prove that they nevertheless recover the same marked
six-axis carrier.

The singular quartic recovers the constant double cover
\(A_5/C_5\to\Omega=A_5/D_{10}\).  If either chordal line \(L\) in the
invariant pencil is selected, the outer involution \(q\) gives
mutually inverse reconstruction functors between a normalized chordal
generator \(h\in L\) and an oriented conference generator \(c\), for
neutral scalar extensions over every field extension of \(\F_{11}\).
Forgetting \(L\) is exactly the free quotient
\[
(L,h,c)\longmapsto(qL,-qh,c),
\]
a residual \(C_2\)-torsor distinct from the conference-orientation
torsor.  Thus the two invariant cubic lines remain genuinely distinct
while retaining equivalent marked-source information.

The conference locus also has an intrinsic six-point recognition
criterion.  If \(S\) represents a two-graph \(\Delta\) on a six-set
and \(m(xy)\) is its signed pair defect, then
\[
16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2,
\]
so \(A(\Delta)=\varnothing\) exactly when \(S^2=5I\).
Finally, for every normalized symmetric conference matrix \(B\) of
order \(n\equiv2\pmod4\), the least
\(\varphi=(I+B)/2\)-stable lattice containing \(\Z^n\) is
\(D_n^\vee=\Z^n+\Z\mathbf1/2\).  At \(n=6\), its binary heart is the
natural \(\F_4A_5\)-module, and conference reversal acts by Frobenius,
giving an equivariant identification of the corresponding principal
\(C_2\)-torsors.
\end{abstract}
```

Red-team notes

• Safe: the conference cubic and two chordal cubics are members of the same (A_5)-invariant pencil on the fixed metric five-space.
• Safe: the paper proves non-projective-isomorphism over the algebraic closure, so “geometrically distinct” is justified.
• Safe: the six-axis carrier recovered from the singular quartic is the marked (A_5/D_{10}) carrier; the text does not claim the two cubics are isomorphic.
• Safe: the reconstruction functors require a selected chordal line and normalized generators/metric setting. Do not collapse this to “each cubic reconstructs the other” without the marking/normalization qualification.
• Safe: the free involution displayed here is not the same torsor as conference orientation; preserve that sentence.
• Safe: the lattice theorem is genuinely uniform in every symmetric conference order (n\equiv2\pmod4); the (\F_4A_5)-module/Frobenius statement is specifically the (n=6) specialization.
• The older abstract’s detailed split between (\F_4) for (n\equiv6\pmod8) and (\F_2\times\F_2) for (n\equiv2\pmod8) is omitted here only for compression. If the author considers that mod-8 dichotomy a headline theorem, retain the existing final paragraph instead of the compressed one. Do not accidentally imply the (\F_4) conclusion holds for every admissible order.

────────

Cross-paper red-team checks

Before committing, compare every replacement abstract with the current theorem statements, not only with the previous abstract.

Claims that must remain carefully scoped

1. Paper I
  • Bare deep-hole locus recognizes the Clebsch geometry.
  • Orientation/integral order use richer decoder/support ambiguity.
  • Conic containment is the hypothesis; equality/nonsingularity are conclusions.
  • Uniform (k)-arc theorem is a bounded-field-window theorem, not a classification.
2. Paper II
  • Classification is over full (\PGL_2(q))-orbits of perfect matchings over odd finite fields.
  • Quadratic data recover sheets only up to interchange.
  • Cubic restores orientation.
  • The fixed affine line contains nonmatching points satisfying the same trade condition; complete splitting is the extra boundary.
  • Gorensteinness is not assumed and the general Schur-square mechanism is not claimed as new.
3. Paper III
  • Arithmetic incidence-cover theorem is characteristic zero/rational.
  • Exact spread-out primes remain unresolved.
  • A chosen sheet alone does not supply the marked bridge datum.
  • Operator and harmonic cubics are compared relatively and live on different spaces.
  • Two-graph and exchange-spectrum theorems are independent of Hitchin’s cover.
4. Paper IV
  • Full reconstruction is fixed-field (q=13).
  • Weighted pair data, not unary data, are the exact threshold.
  • Pair parity recovers the code; weighted pair concurrences carry the richer scheme/geometry.
  • Reconstruction is up to isomorphism and does not canonically choose coordinates/frame/field labels.
  • (\F_8)-structure is a relation-algebra action on the binary code, not a claim that the original incidence matrix is naturally (\F_8)-linear before reconstruction.
5. Paper V
  • Cubics are genuinely nonisomorphic over (\overline{\F}_{11}).
  • Reconstruction equivalence is on the fixed metric/marked carrier with a selected chordal line and normalized generators.
  • Forgetting the chordal line leaves one (C_2)-torsor; conference orientation is another.
  • The six-point alignment identity is an intrinsic conference-recognition theorem, not the full marked-carrier theorem.
  • General lattice theorem and (n=6) (\F_4A_5) specialization must not be conflated.

────────

Style / implementation instructions

• Replace only the abstract environments.
• Preserve existing TeX macros (\F, \PG, \PGL, \PP, etc.) in each repository rather than introducing new notation.
• Do not add references/citations to the abstracts unless the existing house style requires them; none are needed for these replacements.
• Do not add programme numbering, “Paper I–V,” companion-paper references, or the programme name to any abstract.
• Do not add claims of novelty beyond the source’s existing attribution language.
• Keep each abstract on page 1 with the existing title/keywords/MSC layout. If a replacement causes a page break or materially worsens title-page balance, report it before shortening mathematical content.
• Rebuild all five PDFs and inspect page 1 visually.
• Run each repository’s existing manuscript/build/statement-identity checks.
• Confirm theorem-statement hashes are unchanged.

────────

Completion report requested

For each paper report:

1. whether the replacement was used verbatim or required a TeX-only adjustment;
2. resulting abstract word count versus the old one;
3. whether page-1 layout changed materially;
4. any claim you declined to use because the current theorem/source did not support it;
5. clean-build / statement-identity status.

Do not make collateral prose edits during this pass. If reading the abstract against the body exposes a separate manuscript issue, report it rather than fixing it.
