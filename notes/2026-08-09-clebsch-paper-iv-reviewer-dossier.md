# Clebsch Paper IV reviewer dossier

**Lane:** `clebsch`  
**Date:** 2026-08-09  
**Task:** C901  
**Scope:** likely human-proof and mathematical referees for *Reconstructing
\(\operatorname{PG}(2,13)\), its conic, and polarity from the minimum words
of a binary conic code*.
Formalization, software correctness, package trust, and release engineering are
deliberately out of scope.

> **REVIEW-SUB-AGENT MATERIAL ONLY.** Do not list or load this dossier in a
> lane handoff, startup context, named-expert routing table, ordinary Paper IV
> work, or any Lean task. A parent agent may pass one selected packet directly
> to a Paper IV cold-review sub-agent. The sub-agent reads that packet before
> reading the manuscript. Ordinary remediation receives frozen findings, not
> this dossier.

## Frozen review surface

The dossier was built against the manuscript source last changed at commit
`ff5d4690b4c12ef9a03b9dc75967b462d169d1eb`.

- source: `papers/q13-passant-code/passant_code_q13.tex`, SHA-256
  `12e19dd0c2f4a83e25f2a023ebd23b35bdb8415649cbac993853a0488a2ec033`;
- rendered PDF: `papers/q13-passant-code/passant_code_q13.pdf`, SHA-256
  `715fdb6500c34386f92f61ba6fd328da8fd95a60e657c644e9e5a097e0b73fce`;
- visible length: eleven pages according to the live Paper IV task card.

Cold-read coordination must recheck both hashes. A changed source or PDF is a
new review surface and may not be mixed silently with reports on this freeze.

## Bottom line

Paper IV has no frozen journal target. The two natural routes produce slightly
different editorial forecasts:

1. **JCTA route.** Michel Lavrauw is the current editor-in-chief. The current
   board includes Simeon Ball for finite geometry and codes, Qing Xiang for
   combinatorics, Michael Giudici for permutation groups and symmetry, and
   Ferdinand Ihringer for finite geometry and spectral graph theory. Lavrauw,
   Xiang, or Ball may therefore handle or advise on assignment rather than
   serve as an anonymous referee.
2. **Designs, Codes and Cryptography route.** The journal explicitly welcomes
   algebraic and geometric work joining designs, codes, finite fields, and
   finite geometry. Its current board includes Xiang, Lavrauw, Korchm\'aros,
   Storme, Tonchev, and other adjacent specialists. Xiang or Lavrauw is again a
   plausible subject-level route, but the journal does not publicly expose the
   actual assignment for a hypothetical submission.

The highest-value cold-read personas are:

1. **Junhua Wu** — the closest-prior code and modular-representation reader;
   the null-space convention, Madison--Wu decomposition, Frobenius descent,
   endomorphism field, and priority boundary;
2. **Qing Xiang** — the closest-prior elliptic-scheme reader; orbit labels,
   cross-ratio conventions, intersection numbers, pair reconstruction, and
   scheme automorphisms;
3. **Simeon Ball** — the exact tangent-lemma and arc reader; the weight-eight
   reduction, its sign, and the point at which the PSD certificate replaces
   geometry;
4. **Philippe Tranchida** — the group/incidence critic; involution centers and
   axes, conic polarity, Sylow recovery, involution classes, and the claim that
   the abstract group reconstructs the entire marked plane;
5. **Keith Mellinger**, with **Lijun Ma / Shuxia Liu / Zihong Tian** as a
   focused alternate — the founding LDPC construction, code orientation,
   general distance bounds, exact-q priority, and whether the finite proof is
   explained as mathematics rather than a list of executions.

The first cold-read batch should use **Wu + Xiang + Ball + Tranchida**. Add the
Mellinger persona as a fifth full read if the target is DCC; otherwise use the
Ma--Liu--Tian packet as a focused introduction-and-distance read. If Xiang or
Ball is designated as the simulated handling editor for a venue exercise, do
not also count that same persona as the anonymous referee in that exercise.

This is a forecast from public subject overlap and citation proximity, not
inside information. Cited authors are natural experts but citation alone does
not imply selection. Availability, conflicts, and the editor's network are
unknown.

## Why these people are plausible

### Editorial and venue evidence

JCTA's current public scope includes designs, finite geometries, codes, and
algebraic geometry over finite fields, and says that papers must make a
substantial advance. Its board assigns unusually direct homes to each Paper IV
interface: Ball for finite geometry/codes, Xiang for the exact elliptic scheme,
Giudici for the \(\PGL(2,13)\) reconstruction, and Ihringer for the
spectral certificate. This makes JCTA a coherent but high-significance route.

DCC's public scope is an even more literal subject match: it welcomes papers
joining coding theory with finite geometry and emphasizes algebraic and
geometric mathematics. The founding conic-code paper appeared there. The
likely criticism on this route is less “why does this belong?” and more “does
one exceptional \(q=13\) reconstruction advance the family enough, and are
the exact finite leaves explained and reproducible?”

Public board pages checked 2026-08-09:

- JCTA editorial board:
  <https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a/about/editorial-board>;
- JCTA scope:
  <https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a>;
- DCC editorial board:
  <https://link.springer.com/journal/10623/editorial-board>;
- DCC scope: <https://link.springer.com/journal/10623/aims-and-scope>.

### Referee tier A — very plausible

#### Junhua Wu

Madison and Wu study the exact incidence matrix in the manuscript: passant
lines against internal points of a conic. Their Theorem 6.1 decomposes the
algebraic-closure null module for \(q\equiv1\pmod4\) into pairwise
non-isomorphic simple \(\operatorname{PSL}(2,q)\)-modules of dimension
\(q-1\), and Corollary 6.3 gives the binary nullity. At \(q=13\), this is
three twelve-dimensional constituents. Paper IV adds the Frobenius-orbit
inference, descends to one irreducible thirty-six-dimensional binary module,
identifies its endomorphism field as \(\F_8\), marks the three scalar
operators, and derives spanning by each minimum family.

Expected critical questions:

- Is \(K\) consistently the **column binary null space** of the passant-by-
  internal incidence matrix, rather than the row-span code or a transposed
  convention hidden by polarity?
- Does the Frobenius action really cycle all three absolutely simple
  constituents, with orbit length three and no smaller field of definition?
- Does that descent prove binary irreducibility and
  \(\operatorname{End}_{\F_2G}(K)=\F_8\), or only exhibit one embedded
  cubic field in a potentially larger commutant?
- Which part is Madison--Wu's theorem, which part is the paper's inference,
  and which part is the new marking by \(A_9,A_{10},A_{12}\)?
- The orbit-Gram identities imply spanning only after their images and row
  spaces are related carefully. Is every inclusion written in the correct
  ambient coordinate space?
- Does “every family spans” add a genuinely reconstructed marking, or is the
  unmarked spanning statement immediate from already-known irreducibility?

#### Qing Xiang

Hollmann and Xiang construct the association scheme on elliptic lines of a
conic from the \(\PGL(2,q)\) action. They label orbitals by an **unordered
cross-ratio pair** \(\{r,r^{-1}\}\), prove that type plus this value
determines the ordered-pair orbit, and prove generous transitivity. Paper IV
uses polarity to transport that scheme to internal points and replaces the
extension-field cross ratio by the six-valued invariant
\(\rho(P,Q)=\beta(P,Q)^2/(\Delta(P)\Delta(Q))\).

Expected critical questions:

- Where is the exact dictionary between Hollmann--Xiang's
  \(\{r,r^{-1}\}\) labels and the paper's six values
  \(0,1,3,9,10,12\)? Does a relabeling change any displayed product in the
  mod-two Bose--Mesner algebra?
- Are the six relation matrices all defined on the same internal-point set,
  with the diagonal excluded and polarity's row ordering accounted for?
- Are the pair-concurrence table and the one common-neighbor split enough to
  recover the full scheme without importing an unmentioned coherent closure?
- Is the anchor proof of the scheme automorphism group complete, including
  uniqueness of the fourth anchor and injectivity of the four-signature map?
- Does \(\operatorname{Aut}(K)=\operatorname{Aut}(\mathcal H)\) follow at
  exactly the point claimed, or does it depend on the spanning theorem whose
  proof used the scheme data?
- Does the manuscript credit the 1982 Hollmann thesis for the first elliptic
  scheme and reserve novelty for exact minimum words and reconstruction?

#### Simeon Ball

Ball and Lavrauw's Lemma 27 is the coordinate-free lemma of tangents. For an
arc \(A\subset\PG(k-1,q)\), its sign is
\((-1)^{t+1}\), where \(t=q+k-1-|A|\). In Paper IV's hypothetical planar
eight-arc, \(k=3,q=13,|A|=8\), so \(t=7\) and the sign is \(+1\).
That is why the cyclic tangent-product quotient must equal one rather than
minus one.

Expected critical questions:

- Does saturation of all seven passant pencils really show that the seven
  conic secants through each support point are exactly the seven tangent lines
  of the hypothetical eight-arc?
- Is the paper's \(T_P\) the tangent function in the cited lemma, up to a
  scaling that cancels in the cyclic quotient?
- Has the cyclic order been matched to Lemma 27 correctly, including the
  \((-1)^{t+1}\) sign and inversion under reversal?
- The fixed-point graph uses both “passant join” and \(h=1\). Is the claimed
  42-vertex domain exhaustive and is every denominator nonzero?
- Does the rank-28 PSD matrix give only \(\omega\le5\), or are the extra
  claims classifying all five-cliques needed later? If not needed, do they
  distract from the proof?
- Is the characteristic polynomial plus real symmetry a transparent proof of
  positive semidefiniteness, or should the independent rational Schur
  factorization be the primary certificate in the prose?

### Referee tier B — plausible and high-value critics

#### Philippe Tranchida

Tranchida works in exactly the model used at the end of Paper IV:
\(\PGL(2,q)\) is the conic stabilizer in \(\PG(2,q)\), every off-conic point
is the center of a unique projective involution, the involution's axis is the
polar of its center, and internal versus external point type is read from the
involution class. His paper is recent and makes him a particularly useful
cold critic even if he is less predictable as an actual journal selection
than the authors of the established sources.

Expected critical questions:

- Starting from the **abstract recovered group**, why are its fourteen
  Sylow-13 subgroups canonically the conic points rather than merely a
  convenient permutation representation?
- Is the conjugation action on those Sylow subgroups proved sharply
  three-transitive without choosing the standard \(\mathbf P^1(\F_{13})\)
  labeling too early?
- Why are there exactly 169 projective involutions, and why do they biject
  with every off-conic point?
- For distinct involutions \(i,j\), is “\(ij\) is an involution” exactly the
  trace-orthogonality incidence relation, with the projective/scalar and
  characteristic-odd conventions stated?
- Do the three intrinsic incidence rules prove every projective-plane axiom,
  or does the human proof instead identify them with a known trace-polarity
  model? If the latter, is that identification fully constructed?
- Why does the centralizer-28 involution class recover precisely the original
  78 internal coordinates, while the other class has size 91?

#### Keith Mellinger / Ma--Liu--Tian

Droms, Mellinger, and Meyer introduce the exact fixed-conic LDPC family. Their
notation calls disjoint lines “skew” and the paper's code class
\(C_{SkI}\); its coordinates are internal points and its incidence matrix is
used as a parity check. They prove
\((q+3)/2\le d\le q-1\) and construct the upper-bound word from a second
conic. At \(q=13\) this is \(8\le d\le12\). Their dimension was a Magma-based
conjecture, later proved by Madison--Wu. Ma--Liu--Tian's 2024 comparison says
that exact minimum distances in the adjacent quadric/conic families still
need proof.

Expected critical questions:

- Does the introduction translate “skew”/“passant,” generator/parity-check,
  row/column null space, and polarity conventions before comparing results?
- Is the exhibited toric word just the classical second-conic upper-bound
  construction in a sharper normalization, and is that ancestry credited?
- What exactly is new at \(q=13\): distance 12, all 364 minimum words, four
  orbit geometries, weighted-pair reconstruction, or all of these?
- Does the finite exhaustion prove completeness of the four families, or only
  confirm that four generated orbits consist of words?
- Are the enormous fixed-point domains reduced by a mathematically described
  syndrome index, or does the reader receive only input counts and a PASS
  claim?
- Do the weight-ten moment and its four plus thirty-three stabilizer leaves
  explain why the computation is complete and independent of representatives?
- Is the JCTA-level significance claim carried by a reusable reconstruction
  mechanism, or is the result honestly presented as a sharp exceptional
  instance more naturally suited to DCC?

### Useful alternates, lower selection probability

- **Michael Giudici.** Strong editorial/adversarial persona for the
  \(\PGL(2,13)\) action, stabilizers, involution classes, and exact
  automorphism group. He is more plausible as a JCTA subject editor than as
  the anonymous referee in the same simulated route. Use Packet T plus the
  manuscript's automorphism section.
- **Ferdinand Ihringer.** Strong spectral critic for the rank-28 clique
  certificate, association-scheme algebra, and pair-count reconstruction.
  He is a current JCTA board member and may be a handler. No persona-specific
  source was read for this dossier, so do not invent an “Ihringer convention”;
  give him Packets B and H only.
- **Leo Storme or G\'abor Korchm\'aros.** Plausible DCC finite-geometry
  alternates for the conic, arc, and polarity layers. They are less directly
  tied to the exact code and scheme than Ball, Xiang, or Mellinger.
- **Lijun Ma, Shuxia Liu, or Zihong Tian.** Useful current priority readers for
  the general-family comparison and exact-distance boundary. Their 2024 paper
  concerns a related quadric incidence code rather than proving Paper IV's
  result, so a focused read is preferable to treating them as the primary
  referee.

## Cross-persona criticals, ranked

1. **The finite leaves must prove exhaustion, not merely verify examples.**
   Weight ten, the fixed-point minimum layer, the octahedral family, the pair
   table, and the four-anchor rigidity each use exact execution. The human
   exposition must state the domain, symmetry reduction, rejection rule,
   deduplication, and passage from local to global.
2. **The Madison--Wu boundary must be exact.** Their theorem already supplies
   the three absolutely simple twelve-dimensional constituents. Paper IV owns
   the Frobenius orbit inference, binary descent, marking of the three
   operators, and recovery from pair data. It must not present unmarked
   irreducibility or every-family spanning as wholly new.
3. **The reconstruction chain changes mathematical languages four times.**
   Minimum supports give weighted pairs; weighted pairs give scheme and code;
   the scheme gives \(\PGL(2,13)\); Sylow subgroups and involutions give the
   plane. Every arrow needs an intrinsic equivalence convention and a complete
   proof, not only a coordinate replay.
4. **The tangent sign is a single-point failure mode.** The weight-eight
   exclusion depends on applying the coordinate-free lemma with the correct
   tangent functions and sign \(+1\). A mismatch would change the local graph
   and invalidate the PSD certificate's relevance.
5. **The toric parity proof is terse at its boundary.** The claim that odd
   intersection forces a double root requires excluding roots at zero and
   infinity and degenerate linear cases using the fact that a passant cannot
   contain a chord endpoint. A specialist may demand this sentence.
6. **“Canonical \(\F_8\)” has two strengths.** The paper directly constructs
   an \(\F_8\) image of the binary Bose--Mesner algebra. Calling it the full
   endomorphism field additionally uses the representation-theoretic descent.
   Those claims and their sources must not slide into each other.
7. **Exact arity two needs a category.** Unary constancy proves that unary
   data cannot distinguish coordinates, and weighted pairs reconstruct the
   object. The paper should keep clear whether arity is attached to the marked
   code presentation, the hypergraph, or an isomorphism class with no ordered
   frame.
8. **The significance gate is venue-sensitive.** DCC is a native fit. JCTA
   will ask whether an eleven-page, single-field theorem substantially
   advances reconstruction rather than closing one parameter. The clearest
   answer is the exact arity-two recovery of the full marked plane, not the
   parameter table or the existence of an \(\F_8\) action already latent in
   the cited decomposition.

Items 1--5 can produce a **major** human-proof finding. Items 6--8 are likely
minor-to-major depending on the precision of the current exposition.

## Prerequisite extracts for review sub-agents

These are paraphrases keyed to exact source portions. They orient a cold
reader but do not replace the assigned pages.

### Extract M1 — Madison--Wu's exact theorem and the descent seam

Source: Madison--Wu, *On Binary Codes from Conics in PG(2,q)*, Introduction,
Section 2.1, Theorem 6.1(i), and Corollary 6.3.

Their matrix has passant lines as rows and internal points as columns. The
binary code \(L\) is its **column null space**. They pass to an algebraic
closure \(F\) of \(\F_2\), identify the matrix with an
\(F\operatorname{PSL}(2,q)\)-homomorphism \(\phi:F^I\to F^I\), and decompose
\(\ker\phi\) using characteristic-two block theory.

For \(q\equiv1\pmod4\), Theorem 6.1(i) states that the kernel is a direct sum
of \((q-1)/4\) pairwise non-isomorphic simple modules, each of dimension
\(q-1\). Corollary 6.3 obtains binary nullity \((q-1)^2/4\). Thus at \(q=13\)
the imported theorem yields three distinct twelve-dimensional constituents
over the algebraic closure and binary dimension thirty-six.

Retain before reading Paper IV:

- the source works first with \(H=\operatorname{PSL}(2,q)\), not the whole
  \(\PGL(2,q)\);
- it does not name \(\F_8\), mark the three constituents by
  \(A_9,A_{10},A_{12}\), or reconstruct those operators from minimum words;
- binary irreducibility follows only after proving that Frobenius has one
  orbit of length three on the constituents; and
- identifying the **full** endomorphism field needs the descent/commutant
  argument, not merely an irreducible cubic satisfied by one operator.

Paper-IV comparison test: split every sentence in the abstract and operator
section into imported decomposition, Frobenius inference, operator marking,
and minimum-word reconstruction. Verify each implication separately.

### Extract H1 — elliptic-scheme labels and orbit conventions

Source: Hollmann--Xiang, *Association schemes from the action of PGL(2,q)
fixing a nonsingular conic in PG(2,q)*, Sections 3--4, especially Definition
4.2, Theorem 4.3, and Corollary 4.4.

An elliptic line meets the conic over \(\F_{q^2}\) in a conjugate pair
\(\{\alpha,\alpha^q\}\). The source identifies the action on elliptic lines
with the \(\PGL(2,q)\) action on those unordered pairs. For two non-tangent
lines, its orbital label is the unordered pair \(\{r,r^{-1}\}\) obtained
from the four-point cross ratio. Type plus this unordered value determines
the ordered-pair orbit. The action is generously transitive, so the resulting
elliptic orbital configuration is a symmetric association scheme.

Retain before reading Paper IV:

- the cross-ratio value is unordered up to inversion;
- polarity transports elliptic/passant lines to internal points, but a row
  ordering is still a choice;
- Paper IV's rational invariant \(\rho(P,Q)\) is a relabeling of orbitals,
  not literally the source's cross ratio; and
- an intersection-number identity must be checked after that relabeling.

Paper-IV comparison test: build a six-row dictionary from the source orbital
to each \(A_r\) used in the manuscript. Recompute the mod-two products and
the \(A_{10}^2\) common-neighbor split under that dictionary.

### Extract B1 — the tangent lemma's sign

Source: Ball--Lavrauw, *Arcs in finite projective spaces*, Section 7,
Definition (6) and Lemma 27.

For an arc \(A\subset\PG(k-1,q)\), a set \(S\) of size \(k-2\) has a tangent
function \(f_S\), the product of the \(t=q+k-1-|A|\) tangent hyperplanes
through \(S\). Reordering \(S\) changes its normalization by
\((-1)^{s(\sigma)(t+1)}\). Lemma 27 states the cyclic three-point identity
with overall sign \((-1)^{t+1}\).

For the Paper IV case, \(k=3\), \(D=\varnothing\), and \(|A|=8\), hence
\(t=7\) and the sign is \(+1\). Independent rescaling of a tangent line
equation must cancel between numerator and denominator of the cyclic quotient.

Paper-IV comparison test: reconstruct the tangent set at one support point
from parity, match \(T_P\) to \(f_{\{P\}}\), compute the sign, and only then
inspect the 42-vertex graph and PSD certificate.

### Extract D1 — the founding conic-code convention and bounds

Source: Droms--Mellinger--Meyer, *LDPC codes generated by conics in the
classical projective plane*, Section 4, especially the class \(C_{SkI}\),
Lemma 4.8, and Theorem 4.9.

The source calls conic-disjoint lines “skew lines.” Its \(C_{SkI}\) class
uses the skew-line/internal-point incidence matrix as a parity check. The
length is \(q(q-1)/2\). The dimension formula was conjectural there. A second
conic supplies a word of weight \(q-1\) when its non-conic points are all
internal, and pencil counting supplies the lower bound
\((q+3)/2\). Thus at \(q=13\), the established interval is
\(8\le d\le12\).

Retain before reading Paper IV:

- “generated by an incidence matrix” in the paper's family-level prose must
  not be confused with the null-space code defined by that matrix as a parity
  check;
- “skew” in this source is “passant” in Paper IV;
- the upper-bound word already comes from a second conic; and
- exact distance, minimum-word classification, weighted-pair reconstruction,
  and ambient-plane recovery are not supplied by this source.

Paper-IV comparison test: translate the two definitions into one matrix
equation, then compare the toric punctured-conic construction with the
source's second-conic word before judging priority language.

### Extract T1 — involutions, centers, axes, and polarity

Source: Tranchida, *Triples of involutions in PGL(2,q) and their incidence
geometries*, Section 2.1 and the opening of Section 3.

The conic stabilizer in \(\PGL(3,q)\) is \(\PGL(2,q)\). Every involution in
this action is a perspectivity. Its center is off the conic, its fixed axis is
the polar of its center, and every off-conic point is the center of a unique
involution. For odd \(q\), internal/external type is reflected by whether the
involution has zero or two fixed conic points; which class lies in
\(\operatorname{PSL}(2,q)\) depends on \(q\bmod4\).

At \(q=13\equiv1\pmod4\), the exterior involutions lie in
\(\operatorname{PSL}(2,13)\) and the internal ones in the other projective
class. The involution's axis is exactly the conic polar of its center.

Retain before reading Paper IV:

- involutions are projective classes of traceless linear representatives;
- “center,” “axis,” “polar,” and “pole” have distinct roles;
- the source begins with a known embedded conic stabilizer, whereas Paper IV
  claims to reconstruct that plane from an abstract recovered group; and
- the manuscript must therefore build the trace model, not cite the
  center/involution correspondence as though it already supplied the abstract
  reconstruction.

Paper-IV comparison test: starting with \(G=\operatorname{Aut}(\mathcal H)\),
construct \(\Omega\), the involution set, all three incidence cases, and the
original 78 coordinates without importing a labeled plane.

### Extract P1 — the 2024 priority boundary

Source: Ma--Liu--Tian, *The binary codes generated from quadrics in projective
spaces*, conclusion and Table 1.

Their paper studies a different but adjacent quadric incidence construction,
determines dimensions, and gives upper bounds for minimum distances. Its
conclusion explicitly lists exact minimum distances of the relevant
\(\PG(2,q)\) codes as requiring further proof. The table summarizes the
earlier conic-code results, including Droms--Mellinger--Meyer and
Madison--Wu.

Retain before reading Paper IV:

- this is corroboration that the exact-distance problem remains active, not a
  proof that no earlier isolated \(q=13\) computation exists;
- the construction is adjacent and its matrix orientation must be checked
  before transferring a bound; and
- Paper IV's strongest contribution is reconstruction from the minimum layer,
  not merely filling one cell of a parameter table.

## Reading packets

### Packet M — Wu / closest-prior code and module reader

Read Extract M1 first, then:

1. Madison--Wu, Introduction, Sections 2.1 and 6, especially Theorem 6.1(i)
   and Corollary 6.3. Cached full text: `arXiv:1104.0324`, SHA-256
   `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
2. Droms--Mellinger--Meyer, Section 4.3 and Theorem 4.9, only to lock the
   matrix and code convention. Cached published full text:
   `10.1007/s10623-006-0022-6`, SHA-256
   `26ee7b8336eb6e26d5a38c97ca0735d562484e5dc59c70df634d46487fb47337`.

Then read the Paper IV abstract, introduction, the operator-field proposition
and spanning proof. Stop before ambient-plane recovery. Report the earliest
unsupported descent or ambient-space identification.

### Packet H — Xiang / elliptic-scheme reader

Read Extract H1 first, then Hollmann--Xiang Sections 3--5, especially
Definition 4.2, Theorem 4.3, Corollary 4.4, orbital valencies, and the elliptic
intersection parameters. Cached preprint full text: `arXiv:math/0503573`,
SHA-256
`c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.

Then read Paper IV's exact arity-two reconstruction and hidden-field sections.
Require an explicit orbital-label dictionary and check every mod-two scheme
identity used in the proof.

### Packet B — Ball / finite-geometry tangent reader

Read Extract B1 first, then Ball--Lavrauw Section 7 through Lemma 29. Cached
full text: `arXiv:1908.10772`, SHA-256
`00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.

Then read Paper IV Section 2 through the end of the weight-eight subsection,
plus the proof-boundary table's weight-eight row. Do not inspect the
verification source. Check the geometric reduction and whether the prose
specifies enough exact certificate data to justify the claimed conclusion.

### Packet T — Tranchida / abstract group-to-plane reader

Read Extract T1 first, then Tranchida Sections 2.1, 2.2, and 3 through
Proposition 3.2. Cached full text: `arXiv:2411.10299`, SHA-256
`3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.

Then read Paper IV's automorphism proof and ambient-plane recovery only. Start
from the unlabeled group stated there. List every place where the argument
uses a chosen standard representation and decide whether it is a proof of
intrinsic recovery or only a verification in one model.

### Packet D — Mellinger / finite-code and computation-exposition reader

Read Extracts D1 and P1 first, then:

1. Droms--Mellinger--Meyer, Introduction and Section 4.3, including Theorem
   4.9. Cached published full text and hash as in Packet M.
2. Ma--Liu--Tian, conclusion and Table 1. Cached published full text:
   `10.3934/math.20241421`, SHA-256
   `47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984`.

Then read Paper IV from the introduction through minimum geometry, plus the
proof-boundary section. Focus on matrix conventions, priority, finite-domain
completeness, and whether a reader can reproduce the causal argument without
opening code.

## Cold-read protocol

Each persona receives only the frozen PDF, its packet above, and this neutral
question set. It does **not** receive C761, C831, C832, C834, C857, the Clebsch
handoff, earlier reviews, another persona report, or the verification source.

1. State the strongest theorem you believe the manuscript proves.
2. Reconstruct the causal human-proof spine without following implementation
   filenames or trusting the final table as a substitute for proof.
3. Identify the earliest implication you cannot independently justify from
   the manuscript and assigned sources.
4. Check every matrix orientation, field, group action, orbital label,
   polarity, equivalence, and exceptional-case hypothesis at that point.
5. For an exact finite step, state whether the paper specifies the complete
   domain, symmetry quotient, rejection criterion, deduplication, and
   local-to-global transport.
6. Separate false statements, proof gaps, missing citations, unexplained
   computations, convention mismatches, and exposition friction.
7. Give `GO`, `MINOR`, or `MAJOR`, with at most five findings ranked by effect
   on Theorem 1.1.
8. State what is genuinely new relative to the packet in one sentence. If
   that sentence cannot be written, explain why.

Run the first four reads independently and freeze their reports before any
synthesis. The D/Mellinger read may run in the same batch but must not see
those reports. Synthesis should compare the earliest unsupported implication
from each reader before comparing verdict labels.

## Existing internal evidence, withheld from personas

The live programme records that earlier adversarial work accepted the
structural version and that later audits corrected the priority account for
Madison--Wu and Hollmann's thesis. Those facts selected the present personas;
they are not evidence to show the cold readers. A reviewer who independently
finds the same credit or descent seam supplies a high-confidence recurrence
that must be checked against the frozen manuscript rather than dismissed as
already known internally.

## Source ledger

### Full text read for this dossier

| source | version and locator | portions used | SHA-256 |
|---|---|---|---|
| Madison--Wu, *On Binary Codes from Conics in PG(2,q)* | arXiv v1, `arXiv:1104.0324`; published EJC version not separately read | Introduction, conic/polarity convention, Section 2.1, Theorem 6.1(i), Corollary 6.3 | `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343` |
| Hollmann--Xiang, *Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)* | arXiv preprint, `arXiv:math/0503573`; published JACO version not separately read | introduction, cross-ratio convention, Sections 3--4 and elliptic orbital setup | `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b` |
| Droms--Mellinger--Meyer, *LDPC codes generated by conics in the classical projective plane* | archived published PDF, DOI `10.1007/s10623-006-0022-6` | code definitions and Section 4.3 | `26ee7b8336eb6e26d5a38c97ca0735d562484e5dc59c70df634d46487fb47337` |
| Ball--Lavrauw, *Arcs in finite projective spaces* | arXiv full text, `arXiv:1908.10772` | Section 7, tangent-function normalization, Lemma 27 | `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4` |
| Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries* | arXiv full text, `arXiv:2411.10299` | Sections 2.1 and 3, involution/center/axis/polarity conventions | `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656` |
| Ma--Liu--Tian, *The binary codes generated from quadrics in projective spaces* | published AIMS PDF, DOI `10.3934/math.20241421` | conclusion and Table 1 | `47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984` |

### Public current-state evidence

- JCTA board and scope: official ScienceDirect pages, checked 2026-08-09.
- DCC board and scope: official Springer pages, checked 2026-08-09.
- Tranchida's current ULB/FNRS position and publication list: public personal
  page, checked 2026-08-09; this supports current activity only, not a
  mathematical convention.
- Xiang's 2026 association-scheme activity is visible in a public 2026 seminar
  announcement and the current boards; the dossier's mathematical convention
  comes only from the full-text Hollmann--Xiang paper.

No availability, conflict, willingness to review, or private editorial role
was checked or inferred.

## Recommendation

Start with four cold reads:

1. Wu persona — abstract, introduction, hidden field, and spanning;
2. Xiang persona — weighted pairs, scheme, and automorphisms;
3. Ball persona — weight-eight human proof and certificate exposition;
4. Tranchida persona — automorphism-to-ambient-plane reconstruction.

Add one Mellinger persona read over distance, minimum geometry, and proof
boundary. The acceptance target is: no repeated unresolved major seam; Wu can
separate imported decomposition from binary descent and marking; Xiang can
reconstruct the relation dictionary; Ball accepts the tangent sign and PSD
handoff; Tranchida accepts intrinsic plane recovery from the abstract group;
and Mellinger can state both the exact novelty and the finite exhaustion route
without opening the verification source.
