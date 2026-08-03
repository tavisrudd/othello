# C862 — Paper III ceiling and theorem-upgrade research

**Date:** 2026-08-03  
**Lane:** `clebsch` (Paper III stream)  
**Status:** first research-report pass delivered; C862 remains active by user instruction  
**Scope:** research report only; no manuscript, Lean, release, or public-package edit

## Executive verdict

The framing review is directionally right about recognition, the conductor, and the
need for one quotable theorem. Its proposed highest-value mathematical move, however,
is not the marking-invariance theorem L1. C733 already tested that route and found a
real obstruction: the chart lift and the cross-identification of the two five-labelled
systems remain independent inputs. Rephrasing those inputs as invariant would undo the
paper's strongest completed correctness repair.

The better unity theorem is already latent in the paper and appears not to have been
noticed in the review:

> **The golden fibre is the spectral algebra of the conference operator.** Relative
> to the marked operator, and intrinsically up to the common quadratic involution, at
> \([xyz]\), the incidence residue algebra
> \(E=\mathbf Q[t]/(t^2-t-1)\) is isomorphic to the quadratic algebra
> \(\mathbf Q[C]\subset\operatorname{End}_{\mathbf Q}(\mathbf Q^6)\) by
> \(t\mapsto(I+C)/2\). The nontrivial automorphism of \(E\) sends
> \(C\mapsto-C\), exactly as incidence deck exchange does after the golden
> exchanger. Thus the six-axis carrier is a rank-three module over the incidence
> fibre algebra.

This turns the source--shadow chain into one mechanism. After splitting this quadratic
algebra, the two rank-three summands are the golden eigenspaces. The cross block of the
diagonal algebra measures failure of \(E\)-linearity; its determinant has a quadratic
norm, and that norm is the commutator determinant. The oriented square root is the
triangle/Pfaffian cubic. C809 then supplies the reverse direction: nonzero coincidence
of the triangle and Pfaffian shadows recovers the quadratic conference operator on the
sign locus. In compact form:

\[
\text{incidence residue algebra}
\longrightarrow
\text{rank-three golden module}
\longrightarrow
\text{norm/Pfaffian cubic}
\longrightarrow
\text{recognition of the operator}.
\]

That is the Paper-III analogue of yesterday's Paper-II priority judo. Hitchin's
geometric fibre becomes the arithmetic algebra acting on the operator carrier, while
the classical order-six conference normal form becomes a consequence of the shadow
recognition criterion rather than a classification input. HMSV's Segre--Igusa
relations remain credited inputs; no honest reframing swallows them.

A second important finding changes the cost of the integral seam. Ito--Kanemitsu--
Takamatsu--Tanaka (arXiv:2601.10106v1) construct a split Mukai--Umemura
\(V_{22}\)-scheme over \(\mathbf Z[1/10]\), prove existence and uniqueness over every
algebraically closed field of characteristic other than \(2,5\), and construct
Witt-vector lifts. The paper's current statement that an integral Mukai--Umemura model
must first be found is therefore stale as a research plan. What remains is narrower:
identify Paper III's three-skew-form Grassmannian model with that integral model,
compare the chart sections, and prove that the incidence Stein factor commutes with the
needed base changes. Prime \(3\) is now a test case, not an expected geometric bad prime.

This pass consulted nine individually discussed external sources: **three at full-text
depth**, six at partial depth. The three full-text readings and three of the partial
readings are inherited from the recorded C809/C794 audits; the two Hitchin papers and
the 2026 integral-model preprint were inspected directly in this pass. The literature
work is bounded and does not license `first` or an unqualified no-predecessor claim.

## Assessment of the framing review

| proposal | verdict | reason and exact boundary |
|---|---|---|
| one headline equivalence of four orientation torsors | **revise substantially** | A displayed synthesis is useful, but the incidence-to-conference and incidence-to-harmonic sign maps are relative to the marked datum and partly normalization conventions. Calling them an intrinsic four-way equivalence would overstate C733. Use the spectral-algebra theorem as the mathematical headline; retain a smaller equivariant sign diagram as exposition. |
| re-center the forward version on recognition | **accept** | C809 supplies exact operator recognition; C799 supplies general two-graph reconstruction; C810 supplies the sharp robustness boundary; C812/C822 show the first multi-class statistical separator. These form a genuine third movement if ordered by logical strength rather than by task chronology. |
| sell the conductor rather than the constant | **accept, already mostly proved** | The local pinching subsection already proves that \(5\) is the discriminant square class of the two branches. The abstract still leads with determining a constant, so the mathematical content and the advertised content are misaligned. |
| elevate the Gaunt factorization | **accept as hierarchy, not new mathematics** | The factorization and the explanation of prime \(11\) already appear in the introduction and harmonic proof. A named proposition or corollary would make it findable, but C813 is required for a genuine isolation/family theorem. |
| J1: complete arithmetic obstruction package \([5],[2]\) | **reject as stated; salvage a precise pair-of-characters theorem** | The paper proves two independent quadratic characters attached to the golden fibre. It does not define an obstruction group in which they are complete, and the open integral seam contradicts an unqualified completeness claim. State exactly the descent and spinor characters, or prove a classification theorem before using “complete.” |
| J2: integral completion | **promote in EV after new literature** | The 2026 \(V_{22}\) work supplies the split Mukai--Umemura scheme over \(\mathbf Z[1/10]\). The remaining comparison is smaller and more concrete than the memo says. This is now a plausible bounded theorem task rather than an open-ended model-construction program. |
| J3: extract aligned faithfulness | **retain in Paper III by default** | The reverse theorem is the third movement's general source-recovery statement. Extraction would remove the cleanest bridge from order-six recognition to general tomography. The C794 audit found no exact predecessor but is not publication-grade closure. |
| J4: operational uniqueness of order six | **accept locally, do not make the physics citation load-bearing** | The theorem is already mathematically strong. Operational language is helpful, but the paper should first state the exact cut-independent spectrum theorem; the Golden companion remains locator-gated. |
| J5: Paper-I integral cross-anchor | **strengthen** | The basic shared fact is sharper than a visual analogy: \(\mathbf Z[C]=\mathbf Z[\sqrt5]\) is the conductor-two order in \(\mathcal O_E=\mathbf Z[(1+\sqrt5)/2]\). The maximal generator \((I+C)/2\) is not integral on the raw coordinate lattice. This identifies the prime-two seam on the operator lattice and matches Paper I's conductor-two phenomenon. |
| L1: marking-invariance theorem | **negative in the proposed strength** | C733's Tao pass already found no quotient that recovers an intrinsic sign. Coordinated relabelling and switching are equivariances; chart normalization and cross-labelling remain data. The positive replacement is an equivariant groupoid statement plus the marking-independent algebra \(\mathbf Q[C]=\mathbf Q[-C]\). |
| L2: harmonic isolation | **high upside, genuinely new research** | The existing statement is a one-channel evaluation. C813 must decide family versus isolation before Paper III promises either. Do not gate the current forward release on C813 unless its cheap tables already show a theorem with a short proof. |
| L3: shadows as functors | **partly available without crossing lanes** | The spectral-algebra/norm formulation follows from formulas already owned by Paper III and does not require importing the Golden lane's C704 corpus. A broader intrinsic Segre--Igusa functorial diagram still needs the stated lane-boundary decision. |
| L4: arithmetic seam | **now more feasible and more urgent** | The external integral \(V_{22}\) model removes the largest existence uncertainty. The exact comparison, especially at prime \(3\), is now a crisp theorem-shaped problem. |

## The strongest theorem-ready upgrade: spectral realization of the fibre

Let \(C\) be the rational order-six conference matrix already displayed in Paper III.
Since \(C^2=5I\) and \(x^2-5\) is irreducible over \(\mathbf Q\),

\[
 A_C:=\mathbf Q[C]\cong\mathbf Q[s]/(s^2-5)
\]

is a quadratic field. If \(E=\mathbf Q[t]/(t^2-t-1)\), then

\[
 \Phi:E\stackrel{\sim}{\longrightarrow}A_C,
 \qquad t\longmapsto\frac{I+C}{2}
\]

is an isomorphism, because

\[
 \left(\frac{I+C}{2}\right)^2
 =\frac{3I+C}{2}
 =\frac{I+C}{2}+I.
\]

The nontrivial automorphism \(t\mapsto1-t\) carries \((I+C)/2\) to
\((I-C)/2\), hence sends \(C\) to \(-C\). This is exactly the transformation
proved in the golden-exchanger calculation. Switching and relabelling conjugate the
embedded algebra, while global sign does not change the subalgebra at all:
\(\mathbf Q[C]=\mathbf Q[-C]\). Therefore the un-oriented algebra bridge survives
precisely the choice that prevents an intrinsic oriented-sign bridge.

The six-dimensional rational axis space is automatically a three-dimensional vector
space over \(A_C\). After extension to \(E\), the algebra splits as
\(E\otimes_{\mathbf Q}E\cong E\times E\), and the axis space splits into the
\(C\)-eigenspaces \(V_+\oplus V_-\). For the diagonal operator \(D_x\), put

\[
 B_x=P_-D_xP_+:V_+\longrightarrow V_-.
\]

Galois conjugation exchanges the two summands and carries \(B_x\) to its transpose.
Consequently the determinant of the commutator is, with the paper's normalization,

\[
 \det[D_x,C]
 =8000\det(B_x)^2
 =8000\,N_{E/\mathbf Q}(\det B_x),
\]

while

\[
 \operatorname{Pf}[D_x,C]=4Z_C(x),
 \qquad
 Z_C(x)=\pm10\sqrt5\det B_x.
\]

Thus the determinant is not merely basis-free, as C764 explains. It is the norm of
the determinant of the failure of the diagonal algebra to preserve the rank-three
module over the incidence residue field. This one sentence joins arithmetic descent,
the two golden eigenspaces, the determinant-line explanation, and the rational square
of the cubic.

### Exact integral refinement

The rational isomorphism exposes a useful integral mismatch:

\[
 \mathbf Z[C]\cong\mathbf Z[\sqrt5]
 \subsetneq
 \mathcal O_E=\mathbf Z\!\left[\frac{1+\sqrt5}{2}\right].
\]

The index is two. On the raw coordinate lattice, \((I+C)/2\) is not integral, so
the displayed conference matrix carries the conductor-two order rather than the
maximal order. This is an exact, low-cost explanation of why prime \(2\) appears in
the lattice comparison. It also gives J5 a mathematical statement: Paper I's
conductor-two golden order and Paper III's conference lattice are two realizations of
the same nonmaximal order. Any stronger claim about an integral isomorphism of the
full paper-specific lattices still needs an explicit lattice map.

### Recommended theorem shape

The manuscript-sized statement should have three clauses:

1. the golden incidence fibre algebra is the spectral algebra \(\mathbf Q[C]\), with
   deck involution \(C\mapsto-C\);
2. the axis carrier has rank three over that algebra, and the commutator determinant
   is the norm of the determinant of its diagonal-linearity defect;
3. on the sign locus, nonzero equality of the triangle and Pfaffian cubics recognizes
   this quadratic action up to switching, relabelling, and outer orientation.

Clauses 1--2 are a synthesis of existing Paper-III proofs. Clause 3 is C809. Together
they are stronger than a four-way sign-identification theorem because the forward map
has an algebraic reason and the reverse map is a recognition theorem.

## The actual priority-judo moves

### PJ1 — shadow coincidence makes the classical conference normal form a conclusion

The current operator section introduces the classical unique order-six conference
two-graph and then develops its shadows. C809 reverses that order. For a symmetric
zero-diagonal sign matrix \(B\), nonzero proportionality of the triangle cubic and the
commutator-Pfaffian cubic forces \(B^2=5I\). In the gauge with the root row positive,
the balance equations force a pentagon on the other five vertices. The conference
normal form is therefore derived from the shadow condition.

This is the closest analogue of Paper II's successful move. The classical object is
recovered as the output of the paper's own criterion. Bussemaker--Mathon--Seidel remain
the historical source for the switching class and its automorphism group, but the
paper no longer needs their classification to prove the normal form used in the
headline theorem.

The exact boundary matters. C809 does not recover HMSV's Segre relations from the
shadow criterion, nor does it classify every remote weighted real or complex solution.
Those inputs and gaps remain.

### PJ2 — Hitchin's golden fibre becomes the operator's coefficient algebra

Hitchin proves the existence and geometry of the two icosahedra. Paper III computes
their rational residue field. The spectral-algebra theorem composes that result with
the conference construction: the fibre is no longer merely where the constant is
evaluated; it is the coefficient field acting on the six-axis carrier. Hitchin's
Galois exchange is realized by the algebra involution of the operator.

This is composition judo, not a swallow. Hitchin's degree, branch, and fibre theorems
remain indispensable inputs. The new conclusion is the arithmetic module structure
and its norm cubic.

### PJ3 — general one-fibre reconstruction lemma

The proof of the arithmetic theorem already contains a reusable statement. Over a
field of characteristic not two, let a normal base have no two-torsion in its Picard
group, and let a normal quadratic cover have irreducible branch divisor cut by a
section \(J\). Then its generic field is \(K(\sqrt{cJ})\) for a constant square class
\(c\). One rational unramified point whose fibre is a quadratic field determines
\(c\). On projective space, the branch degree also determines the anti-invariant line
bundle and hence the complete Stein algebra.

Stating this lemma before the Hitchin application would change “we computed the
constant” into “one arithmetic fibre reconstructs every rational quadratic twist with
this branch divisor.” It is broader than the present special-case proof and costs
little. It does not make Hitchin's theorem a corollary; it makes Hitchin's complex
geometry the input to a general arithmetic reconstruction principle.

### Moves that are not priority judo

- Renaming the Gaunt scalar is exposition, not a predecessor reversal.
- The exact order-26 moment values supersede no classical theorem; they distinguish
  imported construction classes.
- Calling \([5]\) and \([2]\) “complete obstruction data” without defining and
  computing the obstruction group would manufacture a stronger theorem.
- The centered-square Segre--Igusa formula is HMSV/van der Geer territory and remains
  an attributed input.

## Rebuilding the paper's third movement

The Paper-II framing review sharpens the standard: the successful paper asks one
question, gives a uniform theorem whose clauses form an arc, and turns failures into
sharp boundary theorems instead of caveats. Paper III's corresponding question should
be stated explicitly:

> **What arithmetic datum distinguishes Hitchin's two icosahedra, how does that datum
> act on the golden carrier, and how much shadow data recovers it?**

Recognition can answer the last clause and unify the forward version if its results
appear in causal order:

1. **Exact order-six operator recognition.** Shadow coincidence recovers the golden
   conference class and its outer orientation.
2. **General combinatorial reconstruction.** From seven vertices onward, aligned
   four-sets recover any two-graph up to complement; for conference matrices this is
   determinant-block tomography.
3. **Sharp robustness boundary.** At seven vertices the certificate has minimum
   distance two: it detects one substituted bit and corrects one erasure, but corrects
   no unknown substitution.
4. **First nonunique conference fingerprint.** At order 26, the first multi-class
   order, a third centred cut moment separates the four classes, and C822 reduces it to
   coherent-pentad/spanning-hexad counts and then to intercalates/Pasches.

The first two belong in the theorem hierarchy. The distance result is an honest sharp
boundary in exactly the Paper-II fixed-line/Chow sense: failure becomes the theorem,
with detection and one-erasure correction as the nearest positive result. The order-26
separator is closer to Paper II's trailing refinement suite than to its uniform spine.
It should be a one-paragraph corollary, an appendix theorem, or evidence-facing example,
not a new movement. This changes the provisional C824 preference to **A versus a
one-paragraph B-lite**, with A favored unless a blind reader says the local-count
separator materially changes the meaning of reconstruction. In either case, order 26
stays out of the abstract and introduction theorem list.

Extraction of aligned faithfulness would break this sequence. It should remain in
Paper III unless a concrete combinatorics venue offers enough additional readership to
outweigh the loss of the recognition movement.

## Marking: the exact positive replacement for L1

C733's negative should be used, not fought. There are two different levels:

- The **un-oriented quadratic algebra** is intrinsic up to conjugacy:
  \(\mathbf Q[C]=\mathbf Q[-C]\), and switching/relabeling only conjugate its
  embedding.
- The **oriented comparisons** still need the marked bridge datum: chart scale,
  plane-triple/Petersen cross-labels, and determinant-line orientations.

A short naturality proposition can say that the full construction is equivariant under
axis switching and coordinated relabelling, and that chart reversal, deck exchange,
and golden Galois conjugation act by the same involution on the oriented output. This
packages the ambiguity ledger positively. It must not say that the sheet determines the
marking or that the harmonic and conference signs are intrinsic without it.

The spectral-algebra theorem therefore settles the largest part of the reading tax:
the arithmetic/operator comparison is intrinsic before an orientation is chosen. Only
the final generator and cross-module identification remain relative. That is a stronger
and more accurate unity gain than the memo's proposed global invariance claim.

## The integral seam after arXiv:2601.10106

The 2026 preprint changes the research frontier materially.

### What is now available

Ito--Kanemitsu--Takamatsu--Tanaka prove, in the portions inspected:

- a unique Mukai--Umemura \(V_{22}\)-variety over an algebraically closed field exists
  exactly in characteristics other than \(2,5\) (Theorem 5.2);
- Mukai--Umemura varieties in positive characteristic admit Witt-vector lifts
  preserving type (Corollary 5.3);
- a split Mukai--Umemura scheme is constructed over \(\mathbf Z[1/10]\) (Lemma 5.4);
- relative two-ray games over connected excellent Dedekind schemes commute with
  generic and special fibres (Propositions 4.19--4.20).

These results do **not** directly prove Paper III's incidence theorem. They do remove
the need to invent an integral Mukai--Umemura model and prove its basic smoothness from
scratch.

### The revised exact task

The expensive branch should now be split into three gates:

1. **Model identification.** Compare the three-skew-form zero locus in
   \(\operatorname{Gr}(3,H)\) with the split \(V_{22}\)-scheme over
   \(\mathbf Z[1/10]\). Determine whether the comparison holds over
   \(\mathbf Z[1/10]\) or only after also inverting \(3\).
2. **Incidence and Stein base change.** Form the universal orthogonality incidence,
   prove the needed flatness/normality, and show its finite Stein factor and
   anti-invariant summand commute with base change on the proposed open base.
3. **Chart compatibility.** Extend the two conjugate chart sections and identify their
   pinching fibre with the integral golden order, keeping the conductor-two lattice
   distinction explicit.

Characteristic \(3\) is the decisive cheap gate. The underlying split
Mukai--Umemura variety exists and is smooth there by the new source. If Paper III's
harmonic/Grassmannian presentation fails at \(3\), that failure belongs to the chosen
representation lattice or incidence map, not to the Fano threefold itself. This is a
substantive correction to treating \(2,3,5\) as one undifferentiated expected bad set.

### EV judgment

The integral completion moves from fourth to roughly third among mathematical
upgrades: behind spectral-algebra/recognition and the already-routed C816 theorem, but
competitive with C813. It has a clearer external input and a sharper falsifier than it
did when the framing review was written. It should still be separately allocated before
manuscript integration because it changes the arithmetic theorem and bibliography.

## Harmonic endpoint

The memo correctly diagnoses the harmonic section as an evaluation theorem rather
than an isolation theorem. Two cautions govern C813:

1. “Degree six is the lowest nonconstant even icosahedral channel” does not itself
   imply that the Petersen four-module restriction or its invariant cubic is isolated
   at degree six. Different representation-theoretic questions must not be merged.
2. Multiplicity one ensures that each surviving restriction is a scalar multiple of
   \(\sigma_3\), but it does not force the scalar to be nonzero or unique in degree.

The cheap C813 tables therefore remain the right gate. A positive family or a clean
selection rule would materially lift Paper III; a long irregular list would not. The
current forward release should not wait for C813 unless that gate yields a theorem with
a short causal proof. The already-proved factorization of the degree-six scalar can be
named now without prejudging the research outcome.

## Ranked recommendation

### Tier 1 — theorem-ready and low disruption

1. **Add the spectral-realization theorem** \(E\cong\mathbf Q[C]\), rank-three module,
   deck/Galois involution, and norm determinant. This is the highest unity gain found in
   this pass.
2. **Make C809's recognition equivalence the principal operator theorem and priority-
   judo statement.** Derive the pentagon conference normal form from shadow equality;
   retain BMS attribution as history and context.
3. **Reframe the abstract around discriminant/conductor and recognition.** The factor
   five is forced by residue-field pinching, not fitted from a value.
4. **Package marking naturality positively but narrowly.** State equivariance and the
   intrinsic un-oriented algebra; do not claim independence of lift/cross-label data.
5. **Name the Gaunt factorization.** Keep it out of the main headline unless C813 adds a
   family or isolation theorem.

### Tier 2 — routed integration choices

6. **Keep aligned faithfulness in Paper III** and use it as the general reconstruction
   theorem following exact order-six recognition.
7. **Use C824 B-lite in the body, A in the abstract.** Include the distance boundary and
   compare A against only a one-paragraph C822 corollary; favor A if the separator reads
   as a refinement suite. Leave catalogue data and full profiles outside the prose spine.
8. **Add the conductor-two cross-anchor to Paper I** only with an explicit lattice-level
   statement and citations. The rational algebra statement is already exact.

### Tier 3 — separate research gates

9. **Integral comparison against the 2026 split \(V_{22}\) model.** Test
   characteristic \(3\) first, then pursue Stein/chart compatibility.
10. **C813 harmonic family/isolation.** Preserve its cheap-stop discipline.
11. **Global weighted shadow locus.** Decide whether the saturated projective equality
    locus contains remote components beyond the two golden orientations. This is a high-
    risk algebraic-classification crown, not needed for C816's sign-locus theorem.

## Literature record

This is a bounded research audit, not publication-grade novelty closure. Every external
source named below carries its read depth.

### Directly inspected in this pass

1. **Nigel Hitchin, _Spherical harmonics and the icosahedron_.** DOI
   `10.1090/crmp/047/14`; cached preprint bytes, arXiv `0706.0088v1`.
   **Read depth: partial.** Read the introduction; harmonic/icosahedron/Clebsch setup;
   Pfaffian/vector-bundle and icosahedron-counting sections; the global double-cover
   argument; and the invariant appendix portions used for \(J|_V=\sigma_3^2\).
   Cache key `10.1090/crmp/047/14`, SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
   Used to verify that Hitchin proves the real/complex geometric degree, fibre, and
   restriction statements but not Paper III's rational square class or integral model.
2. **Nigel Hitchin, _Vector bundles and the icosahedron_.** DOI
   `10.1090/conm/522/10292`; cached arXiv `0906.4208v1` preprint.
   **Read depth: partial.** Read the introduction, representation/Pfaffian setup,
   isotropic-space and Mukai--Umemura construction, the Clebsch model, and the
   trichotomy portions relevant to the incidence geometry. Cache key
   `10.1090/conm/522/10292`, SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
3. **Tetsushi Ito, Akihiro Kanemitsu, Teppei Takamatsu, and Yuuji Tanaka,
   _Fano threefolds of genus 12 with large automorphism group in positive and mixed
   characteristic_.** arXiv `2601.10106v1`.
   **Read depth: partial.** Read the abstract and introduction, Proposition 4.20,
   Theorem 5.2, Corollary 5.3, Lemma 5.4, Theorem 5.6, and their immediate proofs and
   definitions. Cache key `arXiv:2601.10106`, SHA-256
   `0e2caea7c0eaf78f2105fc796a8d302443b1af337e9f7dbda24b4572f43af788`.
   Used only for the exact integral-model and characteristic statements recorded above.

### Inherited source records used for the aligned-design boundary

These depths and hashes are inherited from
`notes/2026-08-02-c794-aligned-design-faithfulness-literature-audit.md`; the sources
were not reread in this pass.

4. **Greaves--Suda, _Constructions of \(t\)-designs from weighing matrices and
   association schemes_.** arXiv `2402.17528v2`.
   **Read depth: partial** in C794: introduction, Sections 2.1--2.2 through Examples
   2.3--2.4 and Tables 1--4, and concluding questions. SHA-256
   `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`.
5. **Neil Gillespie, _Equiangular lines, incoherent sets and quasi-symmetric
   designs_.** arXiv `1809.05739v3`.
   **Read depth: partial** in C794: Sections 2.2 and 4.1, Proposition 4.1, Theorem 4.2,
   and full-text terminology searches. SHA-256
   `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`.
6. **Pouzet--Si Kaddour--Trotignon, _Claw-freeness, 3-homogeneous subsets of a
   graph and a reconstruction problem_.** arXiv `1309.1835v2`.
   **Read depth: partial** in C794: abstract, Theorems 1.1--1.2, reconstruction
   discussion, Lemma 2.2, and Section 2.3. SHA-256
   `a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`.

### Inherited source records used for the four-shadow boundary

These depths and hashes are inherited from
`notes/2026-08-02-c809-four-shadow-characterization.md`; the sources were not reread
in this pass.

7. **Goethals--Seidel, _Orthogonal matrices with zero diagonal_.** DOI
   `10.4153/CJM-1967-091-8`. **Read depth: full text** in C809, published version,
   all sections. SHA-256
   `68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734`.
8. **Delsarte--Goethals--Seidel, _Orthogonal matrices with zero diagonal II_.** DOI
   `10.4153/CJM-1971-091-x`. **Read depth: full text** in C809, published version,
   all sections. SHA-256
   `ff5a4a7c1deba6937a653829cb0699abfb44638eece05e021e3f131770a69a18`.
9. **Et-Taoui, _Complex conference matrices, complex Hadamard matrices and complex
   equiangular tight frames_.** arXiv `1409.5720v1`. **Read depth: full text** in
   C809, all sections. SHA-256
   `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`.

### Search record for this pass

Web discovery queries run verbatim on 2026-08-03:

- `two-graph determined by coherent 4-subsets aligned four sets reconstruction switching class`
- `two-graph principal 4x4 minors reconstruct switching class conference matrix determinant -3`
- `Pfaffian diagonal commutator symmetric matrix triangle polynomial conference matrix`
- `Hitchin spherical harmonics icosahedron arithmetic incidence cover square class Stein algebra`
- `"aligned" "two-graph" four-subsets`
- `"coherent" 4-subsets two-graph`
- `regular two-graph 3-design four subsets coherent triples`
- `switching class determined by principal minors signed complete graph`
- `Mukai Umemura threefold integral model over Z good reduction`
- `Mukai-Umemura threefold arithmetic integral model`
- `Mukai Umemura variety reduction modulo p`
- `icosahedron harmonic cubics finite fields Mukai Umemura`
- `"Fano threefolds of genus 12" "positive and mixed characteristic" Mukai-Umemura`
- `site:arxiv.org Mukai-Umemura positive mixed characteristic genus 12 Fano`
- `"Mukai-Umemura type" characteristic 2 5 Fano genus 12`

The first two query groups recovered no exact aligned-faithfulness or
triangle--Pfaffian recognition predecessor among the displayed results; that is discovery
only, not an exhaustive screened set. The Mukai--Umemura queries promoted arXiv
`2601.10106`, which was already present in the shared cache but absent from the paper
and framing review.

Coverage gaps remain: MathSciNet and Google Scholar were not covered; zbMATH Open was
not exhaustively screened; Seidel's second survey remains unavailable at full-text depth
in the inherited C794 audit; no subject-expert check was performed; no forward-citation
closure was attempted. These gaps prohibit `first` and unqualified absence claims.

## Explicit extra-juice and Tao pass

The extra-juice pass asked which displayed constants or choices are shadows of a single
object. It settled three items:

- \(5\) is simultaneously the incidence discriminant and the minimal polynomial of the
  conference action because the incidence residue field acts on the carrier;
- the commutator determinant is a quadratic norm, which upgrades C764's basis-invariance
  explanation to an arithmetic explanation; and
- the conductor-two order on the raw operator lattice is the exact integral seam shared
  with Paper I.

The Tao pass asked which arrows can be reversed and which choices survive quotienting.
It settled that the shadow arrow reverses on the sign locus by C809, while the oriented
incidence-to-harmonic comparison does not descend past the chart lift and cross-labels.
It also exposed the correct quotient: the algebra \(\mathbf Q[C]\), unlike the chosen
generator \(C\), is unchanged by global sign. Finally it asked whether the integral seam
still requires construction of a Mukai--Umemura model; arXiv:2601.10106 shows that it
does not.

## Mystery ledger

| feature | status after this pass | exact remaining gate or owner |
|---|---|---|
| Why the same \(5\) appears in incidence descent and \(C^2=5I\) | **settled conceptually** | state and prove the spectral-algebra isomorphism in any future integration task |
| Why the cross-golden determinant is the right scalar | **settled more strongly** | present it as the norm determinant of the diagonal-linearity defect; determinant-line orientations still choose its sign |
| Whether the incidence sheet intrinsically fixes conference/harmonic signs | **settled negatively** | C733; only the un-oriented quadratic algebra descends without the full marked datum |
| Whether the order-six conference normal form must be imported | **settled for the paper's use** | C809 derives it from nonzero shadow coincidence; BMS attribution remains historical |
| Exact geometric bad-prime set | **sharply narrowed, not settled** | compare the harmonic Grassmannian/incidence model with the split \(V_{22}\)-scheme over \(\mathbf Z[1/10]\); test characteristic \(3\) first |
| Whether degree six is isolated or part of a harmonic family | **open** | C813's bounded branching/kernel/scalar gate |
| Global weighted triangle--Pfaffian equality locus | **open** | saturated-ideal or global inequality classification; C809 proves only sign-locus globality and weighted local rigidity |
| Publication-grade novelty of aligned faithfulness | **open audit gap** | C816/C824 publication audit: full Seidel survey, database gaps, subject expert if available |
| Whether the order-26 separator belongs in the main spine | **architecture judgment, provisionally settled** | compare A against one-paragraph B-lite and favor A unless a blind reader finds a conceptual gain; final C824 blind comparison owns the decision |

## Disposition

This reporting pass is complete, but **C862 is deliberately not closed**. No queue row is
archived or removed, no handoff is archived, and no manuscript promotion is authorized by
this report. The first continuation has now been delivered as
`notes/2026-08-03-c862-paper-iii-spectral-descent-recognition-theorem-packet.md`,
including the determinant-line norm formulation, exact scalar normalization, converse
recognition proof, and promotion boundary. The next bounded research continuation is a
characteristic-three feasibility read of the Ito--Kanemitsu--Takamatsu--Tanaka model
before deciding whether to allocate the integral comparison task.

Vibe check: the paper's ceiling is higher than the framing memo estimated. The main
gain is not more material; it is discovering that the arithmetic fibre already acts on
the operator carrier, so descent, determinant, and recognition are one theorem-shaped
mechanism. The integral seam also just became materially more tractable because a 2026
source supplies the missing global model over \(\mathbf Z[1/10]\).

## Genre-appropriate significance language for future Paper III integration

At the user's direction, Paper III remains unedited in this exposition pass.
C816 should make three already-proved or theorem-ready implications explicit
in the abstract, introduction, and conclusion.

First, the rational twist is not merely the determination of a constant.  At
the golden fibre the incidence residue algebra is the operator's coefficient
algebra:

> At the golden fibre, the incidence residue algebra is the spectral algebra
> \(\mathbf Q[C]\) of the conference operator, so the six-axis carrier is a
> rank-three module over the arithmetic fibre itself.

Second, the determinant square has an arithmetic cause rather than being one
more formula:

> After splitting the quadratic algebra, the cross block measures the failure
> of the diagonal algebra to preserve this rank-three module; the commutator
> determinant is the quadratic norm of its determinant, and the oriented
> Pfaffian cubic is its square root.

Third, C809 reverses the operator-to-shadow passage:

> Conversely, nonzero coincidence of the triangle and Pfaffian shadows forces
> the quadratic conference relation; on the sign locus it recovers the unique
> order-six conference class and its outer orientation.

The general aligned-four-set theorem should be described as local-to-global
reconstruction from quadratic determinant data: four-local tests recover a
global two-graph switching class, with arity seven sharp.  The harmonic
constant remains a return/corollary rather than a competing headline.

The conclusion's causal sentence should be:

> The arithmetic cover, conference operator, and cubic shadows are therefore
> not parallel realizations: the fibre supplies the operator's coefficient
> algebra, its norm produces the shadows, and the shadows recognize the
> operator back.

All of this language remains relative to the marked bridge where required.
It does not claim that a sheet reconstructs the chart lift or cross-labelling,
identify the ambient harmonic representations, or classify remote weighted
solutions.
