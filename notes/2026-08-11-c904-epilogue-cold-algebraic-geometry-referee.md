# Cold algebraic-geometry referee report: cubic-stabilization epilogue

**Date:** 2026-08-11  
**Artifact read:** `papers/cubic-stabilization-m1/irrationality_after_one_stabilization.pdf`  
**PDF SHA-256:** `22c805a17b50d0038c6477b4ce62c94b45b301abb5bbb4be16b3ec5fb03b9a9b`  
**Repository commit at read:** `ad5c19707a1b63b435c2d464b06e5b419efe3d42`  
**Length:** 12 A4 pages  
**Verdict:** **MAJOR REVISION** (promising and potentially publishable; not a rejection)

## Cold-read protocol and scope

I read the rendered PDF from beginning to end before opening any old epilogue review note or manuscript source. I then inspected representative rendered pages at publication scale. I did not edit the manuscript. This is an internal logical and editorial audit, not a source-by-source verification of the 2025--2026 preprints on which Section 4 depends.

## Executive assessment

The paper has a memorable theorem pair and a remarkably economical architecture:

1. a non-isotrivial family of smooth cubic threefolds is universally `CH_0`-trivial;
2. for every smooth cubic threefold `X`, the fourfold `X x P^1` is irrational.

The title is accurate, the two main theorems are visible on page 2, the scope boundary is unusually honest, and the last weak-factorization argument is clean once its invariant is granted. The integral mixed-adjugate mechanism is also a plausible conceptual contribution rather than a bare computation.

The present obstacle is referee confidence at two interfaces. First, the new sixth-root statistic is defined after Levelt--Turrittin separation, but the paper does not yet dispose of all choice and ramification issues before declaring it an invariant of geometric atom-equivalence classes. The transfer from Cai's rank-two residue calculation to the precise KKP-Yu atom is likewise asserted in a few sentences. Second, the passage from the six geometric elliptic quotients to the actual exotic two-primary kernel of every intermediate Jacobian fibre compresses several load-bearing equivariance and constancy steps. Both interfaces can probably be repaired without changing the theorem, but both carry the headline results and therefore count as major revision.

## Prioritized revision requests

### P0. Make `nu_6` intrinsically defined in the atom category

Definition 4.1 says to take formal-monodromy eigenvalues on regular-singular factors "after the exponential parts have been separated." Lemma 4.2 and Corollary 4.3 address variation in a connected spectral component and isomorphisms over the same `u`-disc. They do not visibly establish independence from the finite formal ramification and choices used in Levelt--Turrittin separation. This is especially exposed by Lemma 4.2 itself beginning "after finite formal ramification," while Corollary 4.3 excludes ramified substitutions only from the later atom equivalences.

Give an intrinsic construction on the original formal `u`-disc--for example, the formal monodromy acting on the full descended sum of exponential factors--or specify a canonical minimal ramification and prove independence under refinement and Galois descent. Then state exactly which morphisms generate geometric atom equivalence and check the statistic against each of them. The proof must make clear why an eigenvalue cannot be replaced by a power through a hidden change of loop coordinate.

This is the single highest-priority issue: without it, applying `nu_6` to the free atom-group identity is not yet formally justified.

### P0. Expand the Cai-to-KKP-Yu bridge and the surface exclusion

Proposition 4.4 is the quantum load-bearing lemma, but its two parts currently read more like an expert memo than a referee-verifiable proof.

- For the cubic, identify the exact connection, base point, block, loop coordinate, and gauge on both sides. Prove or quote at statement level that Cai's rank-two zero block is the *unsplit geometric atom* used in the chemical formula. Explain why passage to maximal big quantum and scalar extension neither splits the block nor changes the relevant formal monodromy. The sentence about integral powers of the loop variable needs either the actual gauge formula or a pinpoint citation.
- For surfaces, distinguish a statement about the monodromy of the total connection from a statement about every constituent atom. Spell out why the parity correction allows only `+/-1` on each atom. A compact case table--point, curve, minimal `kappa >= 0`, `P^2`, ruled surface, point blowups--would make completeness inspectable.
- State the exact analytic/formal hypotheses under which the KKP-Yu chemical formula, blowup formula, and projective-bundle formula are available for all varieties used here. The paper presently assumes this framework more silently than a cross-disciplinary algebraic-geometry reader will tolerate.

The contradiction proving Theorem 1.2 is excellent once these inputs are secured; do not enlarge that final argument.

### P1. Expose the geometric realization of the discriminant packet

Propositions 2.3 and 2.4 contain the main hidden dependency on the cycle side. Add a proposition or diagram that displays, for an actual fibre,

`E^5 -> J(X)`, its pulled-back polarization, the induced discriminant pairing, the two primary parts of the kernel, and the relevant group actions.

In particular:

- explain the "missing trivial constituent" implication `d + 5m = 0`;
- show the precise trace/intersection calculation that turns `F_H . F_H' = 24` into `d^2 - m^2 = 24`;
- justify that an `F_2`-rational gluing gives a faithful polarization-preserving `S_6`-action on the quotient, and state the exact strong-Torelli step that converts this to the forbidden cubic action;
- explain why the generic exotic alternative persists over the whole connected smooth locus, including special fibres with extra endomorphisms or Neron--Severi classes;
- either prove/cite the asserted `Gamma_0(3)` monodromy or delete it from the main proposition, since the later proof explicitly needs only scalarity at three.

At present, the sentence "The intermediate Jacobian ... uses the latter pair" bears too much weight relative to its proof.

### P1. State the local mixed-adjugate theorem in the exact generality used

Theorem 3.3 is stated for a graph quotient of the `p I_g` source, then applied after an orthogonal decomposition `U_0 orthogonal-sum p U_1` with a general unimodular form. Promote the later "applies verbatim" paragraph into the theorem or a corollary.

Also make explicit:

- that symmetry/self-adjointness of the slope is relative to the coefficient form;
- how the eigenspace idempotents and divisor classes are lifted after the unramified extension;
- why faithful flatness descends membership in the *image of the divisor-product map*, not just membership in ambient cohomology;
- the local-to-global lattice statement used in Theorem 3.5;
- the scaling that identifies the mixed adjugate of the pulled-back polarization with the pullback of `Theta^(g-1)/(g-1)!`.

These are short additions, but they will prevent the central integral normalization from looking like a factorial has disappeared by assertion.

### P2. Simplify the abstract and remove series provenance from the proof line

The first and third abstract paragraphs work. The middle paragraph is too compressed to orient even an algebraic geometer: "oriented six-set," "symplectic envelope," "five principal two-primary gluings," "golden orientation," "exotic slope," and "mixed-adjugate" arrive before any common picture. Replace most of it by two sentences: six elliptic quotients give an isogeny of type `(1,6,6,6,6)`; the exotic local gluing makes the primitive minimal class an integral divisor product. Keep the prime-two/prime-three mechanism for the introduction.

The "Relation with the reconstruction series" subsection and the last paragraph of the paper introduce sparse-shadow reconstructions, a companion cubic, a finite marked carrier, and maximal golden normalization without defining them. The manuscript says this provenance is not a premise, and Theorem 3.5 uses only the unordered exotic pair. For a standalone journal submission, remove these passages or quarantine them in one brief, fully cited remark after the mathematics. At present they make the paper look dependent on an unpublished series precisely where it wants to look standalone.

### P2. Correct several opening and theorem-legibility points

- The opening says that universal `CH_0`-triviality "obstructs stable rationality" and then speaks of "its vanishing." This reverses the logic. Failure of universal `CH_0`-triviality is the obstruction; satisfaction of the condition need not imply rationality.
- In Theorem 1.1, write the total family as `mathcal X -> B^circ`; "Let X -> B^circ be the smooth locus" is grammatically and notationally ambiguous.
- Say once whether `B^circ` is connected and what "family is non-isotrivial" means (coarse isomorphism class, polarized intermediate Jacobian, or period map).
- In Proposition 2.1, "unique rank-ten symplectic `A_5`-module" is rational uniqueness, while the title "Universal envelope" and the final integral sentence can sound like uniqueness of an integral lattice. Separate those claims.
- Define "axis" operationally at first use or consistently say "elliptic quotient." The former is reconstruction vocabulary, not standard cubic-threefold terminology.

## Title, abstract, and theorem legibility

**Title:** Keep it. It is specific, mathematically accurate, and carries the central contrast. If a more literal alternative is desired, "Universally `CH_0`-trivial cubic threefolds with irrational `P^1`-stabilization" is clearer but less elegant. The present title is better once the abstract immediately says the universal-`CH_0` statement is for a particular non-isotrivial family.

**Abstract:** The result and consequence are immediately legible, but the cycle-side mechanism is written at specialist-after-the-proof density. The quantum paragraph is substantially clearer.

**Theorems:** Theorems 1.1 and 1.2 are easy to find and understand. Theorem 1.2 is especially crisp. The honest sentence excluding stable irrationality is excellent. Theorem 3.3 needs its actual coefficient-form generality in the statement. Proposition 4.4 needs to be promoted rhetorically: it is the true quantum interface theorem, not a routine supporting computation.

## Exposition and rendered presentation

The PDF is visually clean: no apparent overfull text, broken formula, orphaned heading, or unreadable matrix on the inspected pages. The typography is conservative and suitable for a research journal. Page 2 is dense but navigable; pages 5, 7, and 10 are the points where a reader is asked to accept the most compressed mathematics.

The introduction's "How the two proofs meet" section is useful. The later "Proof map" largely repeats it and can be reduced to one sentence. Section 3 has the best exposition in the paper: the coefficient normalization is motivated before the theorem, and the no-factorial issue is treated directly. Section 4 is terser exactly where the disciplinary interface is least standard.

## Overclaim and scope audit

The paper is commendably restrained about stable irrationality, higher stabilizations, relative cycles, and the fibrewise nature of the minimal class. Keep all of those boundaries.

The claims that are currently too strong relative to the written support are not the headline theorem statements but bridge phrases:

- "the sixth-root multiplicity is atomic" before the ramification choices are closed;
- "the same block is the unsplit cubic zero atom" without a full comparison;
- "the intermediate Jacobian ... uses the latter pair" before the geometric kernel packet is fully exhibited;
- "the same pair persists throughout" without a precise local-system/special-fibre argument.

These should be proved more explicitly, not hedged. Conversely, do not weaken Theorems 1.1 or 1.2 if the interfaces can be supplied.

## Likely venue

As written, this is a strong arXiv research note but not yet ready for external submission because both main halves rely on compressed interfaces to recent specialist work. After the P0/P1 repairs, the natural targets are **Algebraic Geometry** or **IMRN**: the paper is short, theorem-driven, and genuinely connects cubic-threefold geometry to a new birational invariant. **Compositio Mathematica** becomes plausible if the quantum comparison receives independent expert validation and the six-axis-to-kernel realization is made completely transparent. A more conservative fit is **Mathematische Zeitschrift**. **JAG** is less natural at the current length and dependency profile unless the atom invariant is developed as a result of independent lasting interest.

## Acceptance gate

I would change the verdict to **MINOR** when a cold reader can answer all four questions from the paper alone:

1. What exactly is the monodromy operator whose primitive sixth roots are counted, before and after formal ramification?
2. Why is Cai's rank-two block precisely one unsplit KKP-Yu geometric atom with the same loop coordinate?
3. Why does every low-dimensional weak-factorization center contribute zero to that count atom by atom?
4. Why is the actual principal kernel of every smooth fibre the exotic two-primary gluing to which the mixed-adjugate theorem applies?

The likely repairs are local and additive. The paper does not need a new organizing idea; it needs its two disciplinary interfaces written at referee-verification resolution.

## Vibe check

Excellent theorem shape and unusually good scope discipline; blocked for submission by two concentrated, repairable proof-interface gaps rather than by diffuse exposition or an implausible main argument.

---

# Second-round cold generalist reread

**Date:** 2026-08-11
**Repaired artifact read:** `papers/cubic-stabilization-m1/irrationality_after_one_stabilization.pdf`
**PDF SHA-256:** `f488b00aa125e19400d05ac3e0158c5be03b61f0af7eae30df62478569a967ba`
**Length:** 13 A4 pages
**Verdict:** **MINOR REVISION**

## Protocol

I reread the repaired PDF from beginning to end and inspected the rendered title page, opening theorem page, load-bearing pages 5, 8, 10, and 11, conclusion, and final reference page before rereading the first-round report. I did not inspect the source diff and did not edit the manuscript.

## Bottom line

The major editorial objections are repaired. A generalist reader can now recover the four answers in the previous acceptance gate from the paper itself:

1. Definition 4.1 puts formal monodromy on the original `u`-disc and describes descent from a minimal Levelt--Turrittin ramification; refinement and fixed-coordinate invariance are then addressed explicitly.
2. Lemma 4.2 exhibits the bulk gauge, records its integral `u`-powers, tracks the spectral projector, and Proposition 4.4 places Cai's rank-two even block inside the unsplit zero atom without overclaiming equality; the weakened conclusion `nu_6(alpha_X) >= 2` is exactly what the proof needs.
3. Proposition 4.4 now gives a complete low-dimensional case split and makes the `+/-1` monodromy bound visible before applying the free atom-group identity.
4. Propositions 2.3--2.4 now expose the trace/intersection calculation and the strong-Torelli argument, while Corollary 3.4 states the unimodular-coefficient generality actually used and Theorem 3.3 supplies faithful-flat and local--global descent.

The main proofs no longer rest on an unexplained interface sentence. My verdict therefore moves from **MAJOR** to **MINOR**, not merely provisionally but because the paper has crossed the prior acceptance gate.

## Remaining exact repairs

### M1. Remove or source the unused `Gamma_0(3)` monodromy assertion

Proposition 2.4 still states that `Gamma_0(3)` multiplicity monodromy selects one scalar graph, and its proof states that reduction modulo three is the upper-triangular Borel. The next paragraph and Theorem 3.6 explicitly say that only scalarity is used. The first-round request was to prove/cite this finer statement or delete it. It remains unsupported by a citation and is unnecessary. The clean repair is deletion from the proposition and proof; otherwise give a precise source or a short derivation of the family monodromy.

### M2. Make the fibrewise persistence sentence one notch more explicit

After proving that the generic two-primary kernel is exotic, Proposition 2.4 says that the kernel is a finite sub-local-system, "so the same pair persists" on the connected smooth locus. This is now credible and sufficient in context, but one extra clause would close the special-fibre point completely: the rational three-set and exotic two-set are distinct monodromy-stable orbits in the discrete five-element packet, so a locally constant kernel cannot cross between them. This would also make clear that extra endomorphisms at a special fibre do not change the inherited kernel class.

### M3. Replace the chapter-wide formal-classification citation by a pinpoint

Definition 4.1 cites van der Put--Singer, Chapter 3, for the intrinsic descended formal-monodromy construction and invariance under ramified refinement. Because this definition creates the paper's new numerical detector, cite the exact theorem/section establishing the formal solution-space/deck-action construction, or add one sentence specifying the canonical conjugacy class being invoked. The written argument is now mathematically intelligible; this is a verification and citation repair, not a structural gap.

No other P0/P1 item remains open at generalist-editor resolution. A quantum-connections specialist should still check the claims imported from Cai and KKP-Yu against those recent sources before submission, especially the parity-preserving inclusion of Cai's block in the unsplit zero atom and the scope of Claim 6.15. That is ordinary expert source validation, not a reason to retain a major-revision verdict.

## Title, abstract, and opening

The title should be retained. The abstract is substantially improved: the isogeny type, local gluing behavior, mixed-adjugate consequence, and quantum obstruction now appear at the right level of compression. The opening logical reversal has been corrected. Theorems 1.1 and 1.2 are cleanly visible on page 2; the family notation, connectedness of `B^circ`, and coarse-moduli meaning of non-isotriviality are now explicit. The stable-irrationality boundary remains exemplary.

The introduction is dense but well ordered. The short proof map is slightly redundant after "How the two proofs meet," yet it costs only four lines and is not a revision condition.

## Thirteen-page density

The added page is justified by proof content. The paper remains acceptably dense for a specialist research note:

- pages 1--2 provide a complete first-pass route;
- pages 5 and 8 are algebraically dense but typographically legible;
- pages 10--11 are the hardest spread, appropriately so because they now expose the quantum trust boundary;
- no inspected page has an overfull line, broken display, orphaned heading, or unreadable matrix.

Page 13 contains only the final reference and is visually wasteful, but this is a harmless pagination artifact rather than excessive mathematical density. It can be recovered during venue typesetting or by a tiny bibliography-layout adjustment; do not compress the new interface proofs merely to return to 12 pages.

## Venue ceiling

**Current realistic ceiling:** **IMRN** or **Algebraic Geometry**, after the three minor repairs and a specialist source check of Section 4. The theorem shape and now-visible interfaces justify that level.

**Stretch ceiling:** **Compositio Mathematica** if an independent quantum-connections referee validates the Cai/KKP-Yu bridge and the author sharpens the paper's independent conceptual contribution beyond the combination of recent inputs. The 13-page length is not an obstacle. Without that specialist validation, Compositio would be an unnecessarily high-risk first submission.

## Second-round vibe check

The repair succeeded: compact, ambitious, and now referee-legible. What remains is citation hygiene and one discrete-family sentence, not reconstruction of either proof spine.
