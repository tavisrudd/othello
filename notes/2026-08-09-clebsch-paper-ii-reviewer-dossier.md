# Clebsch Paper II reviewer dossier

**Lane:** `clebsch`  
**Date:** 2026-08-09  
**Scope:** likely human-proof and mathematical referees for *Quadratic trade
rigidity and cubic orientation in conic matching quotients*.  Formalization,
software, and artifact-trust review are deliberately out of scope.

> **REVIEW-SUB-AGENT MATERIAL ONLY.**  Do not list or load this dossier in a
> lane handoff, startup context, named-expert routing table, ordinary paper
> work, or any Lean task.  A parent agent may pass the relevant extracted
> packet directly to a Paper II cold-review sub-agent.  The sub-agent must read
> that packet before reading the manuscript.

## Bottom line

For the planned JCTA submission, the most plausible editorial route is Michel
Lavrauw as editor-in-chief to Michael Giudici as subject editor.  Giudici is on
the current JCTA board under permutation groups and symmetries of combinatorial
structures, and the manuscript uses his maximal-subgroup theorem at its final
classification step.  If he handles the paper, he is not the anonymous referee.

The highest-value cold-read personas are:

1. **Mark Wildon or Eoghan McDowell** — the modular-
   \(\mathrm{SL}_2\) proof, especially the passage from modular Hermite
   reciprocity to a finite-group Hom calculation and the first-wall extension;
2. **Hua Han** — the exact relationship between the manuscript's full matching
   carrier and the existing classifications of symmetric one-factorizations;
3. **Gábor Korchmáros** — the conic geometry, exceptional one-factorizations,
   projective equivalence, and priority boundary;
4. **Michael Giudici** — as an editorial/adversarial persona even if he is more
   likely to handle than referee: subgroup exhaustion, outer fusion, and every
   small or subfield case;
5. **Flavio Salizzoni** (or Diego Ruano / Gonzalo Rodríguez-Pajares) — the
   self-associated, Schur-square, arithmetically Gorenstein, and inverse-system
   conclusions.

One reviewer is unlikely to command all three languages.  The realistic pair is
one finite-group/finite-geometry referee and one modular-representation or
commutative-algebra referee.  The first cold-read batch should therefore use
**Giudici + Wildon + Korchmáros** personas; add **Salizzoni** as a focused read
of Section 4 rather than a full primary read.

This is a forecast, not inside information.  Availability, conflicts disclosed
to the journal, and the handling editor's network can change the names.

## Why these people are plausible

### Editorial assignment

- **Michel Lavrauw** is the current JCTA editor-in-chief and a finite geometer.
  JCTA explicitly lists finite geometry, codes, and algebraic geometry over
  finite fields in scope.
- **Michael Giudici** is a current JCTA board member whose listed subjects are
  permutation groups, graph symmetry, and symmetries of combinatorial
  structures.  He is also cited twice in the proof, for the maximal-subgroup
  list and exceptional-class fusion.  This combination makes him the most
  natural subject editor.
- **Marco Buratti** is the alternate board-level route because his listed area
  is combinatorial designs with rich automorphism groups.  He is less close to
  the modular proof than Giudici.

Current board source:
<https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a/about/editorial-board>.

### Referee tier A — very plausible

#### Mark Wildon / Eoghan McDowell

Their paper *Modular plethystic isomorphisms for two-dimensional linear groups*
is the manuscript's exact source for modular Hermite reciprocity.  Corollary
1.5 carefully distinguishes upper and lower symmetric powers in positive
characteristic and records the restricted range in which they coincide.  That
is precisely the convention seam a referee will test in the manuscript's
Lucas-socle and outer-parity argument.

Wildon is the more likely senior referee; McDowell is the more likely reader to
check the maps line by line.  Use one persona at a time, not a blended one.

Expected critical questions:

- Does Corollary 1.5 actually imply the module identification used in the
  manuscript, with the same upper/lower symmetric-power convention?
- Where does the argument pass from an algebraic-group or polynomial-functor
  isomorphism to the exact finite-group Hom space?
- When torus weights alias modulo \(q-1\), has the manuscript proved that the
  coefficient relations recover the claimed Hom basis rather than only a list
  of possible composition factors?
- Is the adjacent-wall extension unique, nonsplit, and of the asserted outer
  parity, or is one of those properties inferred from a character calculation?
- Are prime fields, proper extension fields, and the \(q=9\) wall separated
  without silently importing semisimplicity?

#### Hua Han

Han's *Symmetric factorisations of complete graphs* is the nearest recent
classification in the paper's own bibliography.  It proves that symmetric
one-factorizations occur only for orders \(6,12\), or powers of two, and places
the \(\operatorname{PSL}_2(5)\) entry explicitly in its table.  Han is likely
to ask whether the new “full perfect-matching orbit” condition is genuinely a
different input or a repackaging of symmetric/homogeneous factorization.

Expected critical questions:

- Define “full perfect-matching orbit” before using it as the carrier of the
  classification.  Is the orbit on matchings, factors, or edges, and under
  which group?
- Which existing one-factorization theorem already gives the \(K_6\) and
  \(K_{12}\) objects and their full automorphism groups?
- Does the two-valued trade theorem classify a new property of already known
  objects, or reclassify the objects themselves?  The title, abstract, and
  theorem must agree on that boundary.
- Why is the \(q=5\) configuration excluded while \(q=7,11\) survive, stated
  in factorization language rather than only outer-normalizer language?
- Is the fixed affine line of nonmatching placements outside the definitions
  used in the factorization literature, and is “Chow point” the minimum
  machinery needed to say so?

### Referee tier B — plausible and high-value

#### Gábor Korchmáros

Korchmáros coauthored the classical doubly-transitive one-factorization
classification with Peter Cameron and later the JCTA paper constructing
one-factorizations from ovals in finite planes.  He remains active in finite
geometry.  He is the strongest persona for whether the projective-conic
formulation is intrinsic and whether the priority account is generous enough.

Expected critical questions:

- Matching products depend initially on chosen vector representatives and a
  reference matching.  Which statements are genuinely projective, and where
  is that independence proved?
- Are the Edge/Dye \(A_3,B_3,H_3\) configurations and the Cameron–Korchmáros
  sporadic one-factorizations identified with the manuscript's exact labeled
  objects, rather than only by matching parameters and group names?
- Does the four-endpoint switch prove all claimed conic-ideal independence,
  including repeated use across a complete matching orbit?
- Are there overlooked subfield, semilinear, or exceptional conic actions in
  odd prime-power order?
- Is the “new boundary” really the fixed-line/Chow selection theorem, and is
  the preceding literature search broad enough to support that sentence?

#### Michael Giudici

Use Giudici as an editorial cold-read persona even if he is predicted to handle
the submission.  His Theorem 2.2 lists the maximal subgroups of
\(\operatorname{PSL}_2(q)\), with explicit exceptional and subfield clauses;
Lemma 2.3 says exactly when paired classes are fused in an almost simple
overgroup.  The paper derives more than those results state, so every descent
step must remain visible.

Expected critical questions:

- Why must the sheet stabilizer be a \(p'\)-subgroup, and why is it contained
  in one of the listed maximal subgroups in every small case?
- Do the Borel, cyclic, dihedral, subfield, \(A_4,S_4,A_5\) branches exhaust
  the manuscript's stabilizers, including nonmaximal subgroups?
- Are the hypotheses for the two-class fusion lemma met before the outer
  diagonal automorphism is used?
- Does the final passage from \(J\cap G^+\) to the full stabilizer exclude an
  outer normalizer in every case, especially \(q=5,7,9,11\)?
- Is “Dickson's subgroup theorem, in the form recorded by Giudici” a precise
  enough attribution for each consequence actually used?

#### Flavio Salizzoni / Diego Ruano / Gonzalo Rodríguez-Pajares

Their 2025 preprint is the closest current work on the paper's
self-associated/Schur-square/Gorenstein consequence.  Salizzoni has the
broadest adjacent geometry-and-codes portfolio; Ruano is the senior coding
theorist; Rodríguez-Pajares is the best choice for a literal theorem-comparison
read.

Expected critical questions:

- Does the signed Gale matrix prove self-association over the field and with
  the equivalence convention used in their paper?
- Are the hypotheses “self-dual code” and “no proportional columns” actually
  established for the homogenized configurations before their criterion is
  invoked?
- Is indecomposability needed, proved, or bypassed by the manuscript's direct
  maximal-isotropic argument?
- Does the perfect pairing prove the full arithmetically Gorenstein conclusion
  over \(\mathbb F_7\) and \(\mathbb F_{11}\), including descent after base
  change?
- In positive characteristic, does degree-three polarization identify the
  Macaulay dual generator with \(\mu_3\) under the paper's symmetric/divided
  power convention?
- Does the introduction accurately call the classification a “reverse
  direction” without implying that their theorem is logically inverted?

### Referee tier C — useful alternates, lower selection probability

- **Gabriele Nebe or Tobias Braun.** Their defining-characteristic
  \(\mathrm{SL}_2(q)\) paper is cited for the type of invariant forms and is
  useful for the Fischer-module and orthogonality language.  The cited result
  is too peripheral to make either the first reviewer choice.
- **Joan Elias or Maria Evelina Rossi.** Their *Inverse system of Gorenstein
  points in projective space* is a strong context for the Macaulay-dual claim.
  It works over an algebraically closed field of characteristic zero, so this
  persona would be especially alert to the manuscript's positive-
  characteristic polarization and descent.  They are plausible only if the
  editor seeks a commutative-algebra second report.
- **Peter Cameron.** He is an obvious intellectual ancestor and a useful
  persona, but Han or Korchmáros is a more likely active specialist assignment.
- **Gábor Korchmáros's coauthors Nicola Pace or Angelo Sonnino.** Strong
  alternates for the oval/one-factorization interface, less close to the
  modular classification core.

## Cross-persona criticals, ranked

These are the objections most likely to determine the report, independent of
the referee's specialty.

1. **The all-\(q\) bridge is the paper.**  The projective-trade pullback,
   finite-group Hom basis, first-wall parity, prime-field cocycle, and subgroup
   exhaustion must read as one complete implication.  Any one of them reduced
   to “standard” or inferred from a computation makes the headline theorem
   conditional.
2. **The literature theorem is narrower than the manuscript's use.**
   McDowell–Wildon provide modular Hermite reciprocity; they do not provide the
   finite-group Hom basis or first-wall nonsplitting.  Giudici supplies maximal
   subgroups and fusion; he does not supply the preceding modular reduction.
3. **The classification is relative to a sharp carrier.**  The abstract must
   make it impossible to read the result as a new classification of the
   exceptional one-factorizations themselves.  The new claim is recognition by
   a quadratic trade inside the full matching carrier, plus the off-carrier
   fixed-line/Chow boundary.
4. **All exceptional cases must stay in view.**  The proof must visibly dispose
   of \(q=5,7,9,11\), subfield groups, semilinear extensions, the two exceptional
   conjugacy classes, and the outer normalizer.  A generic Dickson citation does
   not cover this bookkeeping.
5. **Intrinsicity must survive choices.**  Scaling marked conic points,
   choosing the reference matching, translating the quotient configuration,
   and exchanging sheets must not change the hypothesis or conclusion except
   by the stated equivalence.
6. **The Gorenstein paragraph carries its own characteristic conventions.**
   The direct perfect-pairing proof is stronger evidence than a bare appeal to
   the recent code criterion, but the Macaulay-generator sentence must say why
   degree-three polarization is valid in characteristics \(7\) and \(11\).
7. **Priority and citation depth are vulnerable.**  The bibliography is short
   for a paper joining four literatures.  A referee may request exact sources
   for self-association/Gale duality, Macaulay inverse systems, the subgroup
   theorem actually used, and the relationship among Cameron–Korchmáros, Han,
   and the manuscript's matching objects.
8. **JCTA's significance gate is high, especially at 43 pages.**  The journal
   says long papers face a higher standard.  The appendices must support the
   classification rather than make the article look like a dossier of one
   \(H_3\) example.  A likely editorial criticism is to shorten or separate the
   six-profile, modular-depth, arithmetic-gluing, and relative-cubic material.

The first five are potential **major** findings.  Items 6–8 are likely
**minor-to-major** depending on how cleanly the current PDF answers them.

## Prerequisite extracts for review sub-agents

These extracts are the minimum context a review sub-agent must absorb before
opening Paper II.  They are paraphrases keyed to exact results, not substitutes
for the assigned source pages.  The parent should pass only the packet selected
for that review persona.

### Extract G1 — Giudici's subgroup and fusion boundary

Source: Michael Giudici, *Maximal subgroups of almost simple groups with socle
PSL(2,q)*, Theorem 2.2 and Lemma 2.3, preprint pp. 4–5.

Let \(q=p^f\geq5\), with \(p\) odd.  Theorem 2.2 gives the maximal subgroups
of \(T=\operatorname{PSL}_2(q)\) in eight families:

1. the point stabilizer \(C_p^f\rtimes C_{(q-1)/2}\);
2. \(D_{q-1}\) for \(q\geq13\);
3. \(D_{q+1}\) except at \(q=7,9\);
4. \(\operatorname{PGL}_2(q_0)\) when \(q=q_0^2\), in two
   \(T\)-classes;
5. \(\operatorname{PSL}_2(q_0)\) when \(q=q_0^r\) for an odd prime
   \(r\);
6. \(A_5\) under the stated congruence and prime/square conditions, in two
   classes;
7. \(A_4\) for the stated prime congruences; and
8. \(S_4\) for \(q=p\equiv\pm1\pmod 8\), in two classes.

The source writes
\(\operatorname{Out}(T)=\langle\delta\rangle\times\langle\phi\rangle\),
where \(\delta\) is the diagonal outer automorphism and \(\phi\) is field
Frobenius.  Lemma 2.3 says that, when \(T\) has two classes of maximal
subgroups of the same type, those classes fuse in an intermediate
\(T\leq G\leq\operatorname{P\Gamma L}_2(q)\) exactly when the image of
\(G/T\) has nontrivial \(\delta\)-component.  Field automorphisms alone do
not supply the fusion in the form used by Paper II.

Retain before reading Paper II:

- this is a **maximal-subgroup** theorem, not by itself a classification of
  all \(p'\)-subgroups or all transitive sheet stabilizers;
- the Borel branch contains \(p\)-torsion and has to be excluded or reduced
  separately if the manuscript has already proved its stabilizer is \(p'\);
- \(q=7,9\) are exceptions in the dihedral list;
- subfield groups split into square and odd-prime-extension cases; and
- fusion requires checking the actual almost simple overgroup's diagonal
  component.

Paper-II comparison test: starting at the first assertion that a sheet
stabilizer is \(p'\), reconstruct every reduction from an arbitrary stabilizer
to the cyclic, dihedral, subfield, \(A_4,S_4,A_5\) branches.  Do not credit
Giudici with any modular-Hom or extension claim.

### Extract G2 — what the factorization literature already classifies

Sources: Cameron–Korchmáros 1993; Hua Han 2025; Giudici–Li–Potočnik–Praeger
2006.

**Cameron–Korchmáros.**  Their theorem classifies one-factorizations of
\(K_n\) whose automorphism group is doubly transitive on vertices.  The
possibilities are the affine line-parallelisms of \(\operatorname{AG}(d,2)\)
and three sporadic examples at \(n=6,12,28\).  Their full automorphism groups
are respectively \(\operatorname{AGL}(d,2)\),
\(\operatorname{PGL}_2(5)\), \(\operatorname{PSL}_2(11)\), and
\(\operatorname{P\Gamma L}_2(8)\).  Thus the \(K_{12}\)/icosahedral
one-factorization in Paper II is classical; the \(K_8\) object sits on the
affine power-of-two side rather than the sporadic list.

**Han.**  A factorization is a partition of the graph's edge set into
spanning parts.  It is symmetric when one group is transitive on edges and on
the factors and each factor stabilizer is vertex-transitive.  Han proves that
all but two symmetric factorizations of complete graphs are homogeneous; the
two exceptions are one-factorizations of \(K_6\) and \(K_{12}\).  In
particular, \(K_n\) has a symmetric one-factorization exactly when
\(n\in\{6,12\}\) or \(n\) is a power of two.  The displayed almost-simple
table includes

- \(\operatorname{PSL}_2(5)\), point stabilizer \(A_4\), degree \(6\),
  five factors;
- \(\operatorname{PSL}_2(7)\), point stabilizer \(S_4\), degree \(8\),
  seven factors; and
- \(\operatorname{PSL}_2(11)\), point stabilizer \(A_5\), degree \(12\),
  eleven factors.

**Giudici–Li–Potočnik–Praeger.**  A homogeneous factorization is organized by
groups \(M<G\): \(M\) is vertex-transitive and fixes every factor, while
\(G\) preserves and transitively permutes the factor set.  Their generic
construction shows that this group-normal-subgroup architecture is not a
Paper-II novelty.

Retain before reading Paper II:

- Paper II's \(B_3\) and \(H_3\) matching orbits have \(14\) and \(22\)
  matchings, split into complementary sheets of \(7\) and \(11\); the
  classical one-factorizations live at the sheet level;
- “the exceptional one-factorizations are classical” must remain distinct
  from the claimed new classification by a quadratic-trade property; and
- the manuscript must translate its full orbit, sheet, factor, and factor
  stabilizer vocabulary into the standard definitions without changing the
  equivalence relation.

Paper-II comparison test: after the abstract and main theorem, write one
sentence containing only the new input and output.  If that sentence merely
recovers the existence or group of the \(K_8\) or \(K_{12}\)
one-factorization, the priority boundary is not yet stated sharply enough.

### Extract K1 — the conic/oval one-factorization boundary

Sources: Dye 1991; Korchmáros–Pace–Sonnino 2018.

**Dye.**  The assigned source is the primary reference for the exceptional
hexagon/conic/\(A_5\)/\(\operatorname{PSL}_2(K)\) geometry used to identify
the \(H_3\) configuration.  The sub-agent must use the cached OCR only to
locate the relevant pages and verify the actual group, orbit, and conic
statements against the authoritative scans.  The point of this read is not to
import Paper II's quadratic trade, which Dye does not formulate, but to decide
which geometric identifications and uniqueness assertions are already
classical.

**Korchmáros–Pace–Sonnino.**  Their construction starts with an oval in a
finite projective plane and represents a one-factorization of the complete
graph on the oval by a partition of the oval's external points.  Each part has
half the relevant order and meets each tangent in one point.  The paper's
central dictionary is therefore “one-factorization as a partition of external
conic/oval geometry,” not Paper II's quotient of secant products by the conic
equation.

Retain before reading Paper II:

- conics, external points, secants, and one-factorizations already have a
  geometric dictionary;
- equality of restricted secant products and division by the conic equation is
  the candidate new quotient mechanism;
- labeled marked points, chosen vector representatives, and projective
  equivalence are different levels of structure and cannot be conflated; and
- matching the parameters and group name does not alone identify Paper II's
  labeled orbit with Dye's or Cameron–Korchmáros's object.

Paper-II comparison test: check Proposition 2.1 and the four-endpoint switch,
then trace every later claim of reference-matching and representative
independence.  Separately list which \(A_3,B_3,H_3\) identifications are proved
in the manuscript and which are imported.

### Extract W1 — modular Hermite reciprocity and its convention trap

Source: McDowell–Wildon, *Modular plethystic isomorphisms for
two-dimensional linear groups*, Corollary 1.5, Section 5, Lemma 6.9, and
Proposition 6.10.

The source distinguishes the lower symmetric power, formed by symmetric
tensors, from the ordinary upper symmetric power, formed as a quotient.
Corollary 1.5 states, over an arbitrary field \(K\), the characteristic-free
isomorphism
\[
 \operatorname{Sym}_{m}(\operatorname{Sym}^{\ell}E)
 \simeq
 \operatorname{Sym}_{\ell}(\operatorname{Sym}^{m}E),
\]
with the upper/lower placement essential.  Its proof composes the Wronskian
isomorphism, the complementary-partition exterior-power isomorphism, and
duality.  It is an isomorphism of polynomial \(\operatorname{GL}_2(K)\)-
representations; it does not compute a socle or a finite-group Hom space.

Lemma 6.9 describes the failure of upper and lower powers to agree using
Lucas carry-free digits.  Under the stated field-size bound, the lower power
has every defect index \(0,\ldots,\ell\), while the upper power retains only
indices whose binomial coefficient is nonzero modulo \(p\).  Proposition
6.10 then says that upper and lower \(\ell\)-th symmetric powers are
isomorphic exactly when \(\ell<p\) or \(\ell=p^e-1\), again under its
field-size hypothesis.  The canonical map multiplies the weight-\(a\) basis
vector by \(\binom{\ell}{a}\), so Lucas vanishing is the obstruction.

Retain before reading Paper II:

- Paper II uses reciprocity to identify
  \(\operatorname{Sym}^{d}L(2)\) with
  \(\operatorname{Sym}^{2}\nabla(d)\); the replacement of the lower second
  power by the upper second power is valid because \(p\) is odd and
  \(2<p\);
- no cited result says which simple modules occur in the **socle** of that
  finite-group restriction;
- no cited result proves the manuscript's parity under the diagonal outer
  automorphism; and
- a highest-weight or composition-factor calculation is weaker than the
  asserted basis of
  \(\operatorname{Hom}_{\operatorname{PSL}_2(q)}(L(c),F)\).

Paper-II comparison test: treat the sentence citing Corollary 1.5 as the end
of imported knowledge.  Independently verify the coefficientwise root-group
argument, the use of the degree bound \(\leq q-1\), the negative-root/Weyl
step, the Frobenius-digit tensorization, and the proof that the resulting maps
span the actual finite-group Hom space.

### Extract W2 — irreducibles and fields of definition

Source: Braun–Nebe, *Orthogonal representations of SL2(q) in defining
characteristic*, Facts 3.1–3.2 and Remark 3.3.

For \(\operatorname{SL}_2(p)\), the irreducible modules in defining
characteristic are \(W_k=\operatorname{Sym}^k(V)\),
\(0\leq k\leq p-1\), with dimension \(k+1\).  For \(q=p^f\), every
irreducible over the splitting field has the Steinberg digit form
\[
 W(k_0,\ldots,k_{f-1})=
 W_{k_0}\otimes W_{k_1}^{(1)}\otimes\cdots\otimes
 W_{k_{f-1}}^{(f-1)},
\]
where every \(k_i\in\{0,ldots,p-1\}\).  Frobenius cyclically permutes the
digits.  The minimal field of definition is determined by the period of that
cyclic digit string.

Retain before reading Paper II:

- a digit tuple classifies a simple module over the splitting field, but the
  tuple's Frobenius period controls descent;
- extension-field arguments must track twists and cannot be inferred from the
  prime-field module alone; and
- orthogonality or self-duality of the simple does not supply the
  manuscript's extension class or its outer \(\operatorname{PGL}_2\) parity.

Paper-II comparison test: for every detecting module in Lemma 3.2, record its
digit tuple, field of definition, and diagonal-outer extension.  Check that the
extension-field and prime-field branches use the correct one of these three
pieces of data.

### Extract S1 — the exact PRS theorem and what it does not say

Source: Rodríguez-Pajares–Ruano–Salizzoni, *A combinatorial description of
when a self-associated set of points fails to be arithmetically Gorenstein*,
Theorem 3.11 and Corollaries 3.12–3.13, pp. 7–8.

For a self-dual code \(C\subseteq K^{2k}\), let \(\operatorname{nb}(C)\)
be its number of indecomposable blocks.  Theorem 3.11 states
\[
 \dim C^{(2)}=2k-\operatorname{nb}(C).
\]
The proof decomposes \(C\) as an orthogonal direct sum of indecomposable
codes, uses compatibility of the Schur square with that sum, and applies the
indecomposable formula to each block.  Corollary 3.12 identifies the
Gorenstein defect as \(\operatorname{nb}(C)-1\).  Corollary 3.13 says the
associated projective point set is arithmetically Gorenstein exactly when
\(C\) is indecomposable, within the paper's standing hypotheses connecting a
self-dual code with no proportional columns to a self-associated set.

Retain before reading Paper II:

- PRS begins with a self-dual code; it does not reconstruct self-duality or a
  hidden sheet partition from a quadratic relation;
- the theorem computes the **dimension** of the Schur square from block
  decomposition;
- it does not classify matching orbits, identify \(B_3/H_3\), or construct a
  signed cubic; and
- applying the corollary requires checking the code/point correspondence and
  the no-proportional-columns condition.

Paper-II comparison test: divide Section 4 into (a) the direct signed-Gale and
maximal-isotropic proof and (b) the contextual PRS consequence.  The headline
classification must not depend on (b), and the manuscript must not present
PRS's forward block criterion as though Paper II literally proves its
converse.

### Extract S2 — inverse systems in the closest adjacent source

Source: Joan Elias and Maria Evelina Rossi, *Inverse system of Gorenstein
points in projective space*, Theorem 3.14 and Proposition 5.1.

The source works over an algebraically closed field of characteristic zero.
For a reduced point set \(X=\{P_1,\ldots,P_r\}\) in an affine chart, of
socle degree \(s\), with corresponding linear forms \(L_i\), Theorem 3.14
characterizes arithmetic Gorensteinness by the existence of
\(F=\sum_i\alpha_iL_i^s\) such that the degree-\((s-1)\) weighted sum
vanishes and the inverse-system span generated by \(F\) has dimension at
least \(r\).  In the Gorenstein case the \(\alpha_i\) are nonzero and unique
up to a common scalar.  Proposition 5.1 characterizes when an Artinian
Gorenstein algebra is the reduction of such a point set using the same sum of
powers and lower-moment condition.

Retain before reading Paper II:

- this source's factorial-normalized inverse-system formulas assume
  characteristic zero;
- it supplies useful geometry for “weighted sum of cubes as an Artinian dual
  generator,” but it is not a direct finite-characteristic citation for Paper
  II;
- Paper II works in characteristics \(7\) and \(11\) with socle degree three,
  so \(2\), \(3\), and \(3!\) are invertible; and
- the manuscript's direct perfect-pairing proof must establish the Artinian
  reduction and one-dimensional socle before polarization identifies
  \(\mu_3\) as the generator.

Paper-II comparison test: verify, in order, regularity of the homogenizing
coordinate, the graded pieces of the quotient, nondegeneracy of the
degree-1/degree-2 pairing, the one-dimensional degree-three socle, and only
then the polarization step.  Do not import characteristic-zero descent from
Elias–Rossi.

## Reading packets

### Packet G — Giudici / finite-group handler

Read Extracts G1 and G2 first, then the source portions in this order:

1. Michael Giudici, *Maximal subgroups of almost simple groups with socle
   PSL(2,q)*, especially Theorem 2.2 and Lemma 2.3.  Cached full text:
   `arXiv:math/0703685`, SHA-256
   `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.
2. Hua Han, *Symmetric factorisations of complete graphs*, DOI
   `10.3934/mfc.2023046`, especially the definitions, main classification, and
   \(n=6,12\) table.  The publisher HTML is available at
   <https://www.aimsciences.org/article/doi/10.3934/mfc.2023046>.
3. Cameron–Korchmáros, *One-factorizations of complete graphs with a doubly
   transitive automorphism group*, DOI `10.1112/blms/25.1.1`; read the theorem
   and the \(n=6,12,28\) identifications.
4. Giudici–Li–Potočnik–Praeger, *Homogeneous factorisations of graphs and
   digraphs*, DOI `10.1016/j.ejc.2004.08.003`, for terminology and the normal
   subgroup/factor action architecture.

Then read manuscript Sections 2–3 only, without the verification appendix or
prior review notes.

### Packet W — Wildon / modular-representation referee

Read Extracts W1 and W2 first, then:

1. McDowell–Wildon, *Modular plethystic isomorphisms for two-dimensional
   linear groups*, Introduction, Corollary 1.5, Sections 2–5, and the negative
   examples in Section 6.  Cached full text: `arXiv:2105.00538`, SHA-256
   `8e9012cea77b2eca5aecf03238fd0565155a6941c89c98c422533d94aa94a890`.
2. Steinberg, *Representations of algebraic groups*, Theorems 1.1 and 7.4 as
   cited by the manuscript.
3. Braun–Nebe, *Orthogonal representations of SL2(q) in defining
   characteristic*, especially Fact 3.1.  Cached full text:
   `10.1007/s13366-024-00763-w`, SHA-256
   `4c43806863b35eea67a3b03cdb4321016d85e21d61f64a47f5d30b6d6ff4762e`.

Then read manuscript subsections 3.1–3.4 and stop immediately after Theorem
3.4.  The report should identify the earliest unsupported implication, not
merely confirm the final dimensions.

### Packet K — Korchmáros / finite-geometry referee

Read Extracts G2 and K1 first, then:

1. Cameron–Korchmáros 1993, above.
2. R. H. Dye, *Hexagons, conics, A5 and PSL2(K)*.  Use the authoritative page
   scans under `/tmp/persistent/tavis/lit-search/dye-1991/`; use OCR only for
   search and verify quotations and formulas against the images and
   `SHA256SUMS`.
3. Korchmáros–Pace–Sonnino, *One-factorisations of complete graphs arising
   from ovals in finite planes*, JCTA 160 (2018), 62–83, DOI
   `10.1016/j.jcta.2018.06.006`.
4. Hua Han 2025, above.

Then read the abstract, introduction, Sections 2–3, and Theorem 4.3.  Ask for a
precise sentence separating the classical objects from the new recognition
property.

### Packet S — Salizzoni / Gorenstein second referee

Read Extracts S1 and S2 first, then:

1. Rodríguez-Pajares–Ruano–Salizzoni, *A combinatorial description of when a
   self-associated set of points fails to be arithmetically Gorenstein*, full
   text with special attention to Theorem 3.11 and Corollaries 3.12–3.13.
   Cached full text: `arXiv:2512.16766`, SHA-256
   `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
2. Elias–Rossi, *Inverse system of Gorenstein points in projective space*,
   Introduction, Theorem 3.14, and Section 5.  Cached full text:
   `arXiv:2301.07056`, SHA-256
   `552e849bd8e079782bcb11217559d16a14df33f57bfb875409536d51c4b2a9c4`.

Then read manuscript Section 4 only.  Require the reader to distinguish what
is proved directly from what is attributed to the code criterion.

## Cold-read protocol

Each persona receives only the current PDF, its packet above, and this neutral
question set; it does **not** receive C749, C892, the trust manifest, earlier
reviews, or another persona's response.

1. State the strongest theorem you believe the manuscript proves.
2. Reconstruct the causal proof spine without following cross-references.
3. Identify the earliest step you cannot independently justify from the text
   or the packet.
4. Check every field, group, orbit, equivalence, and exceptional-case
   hypothesis at that step.
5. Separate false statements, proof gaps, missing citations, and exposition
   friction.
6. Give `GO`, `MINOR`, or `MAJOR`, with at most five findings ranked by effect
   on the headline theorem.
7. State what is genuinely new relative to the packet in one sentence.  If
   that sentence cannot be written, explain why.

Run the first three reads independently.  Only after freezing their reports
should a synthesis compare overlaps and contradictions.  The Salizzoni read is
focused and can run in the same batch without seeing the other reports.

## Existing internal evidence, withheld from the personas

The 2026-08-02 adversarial human-proof sequence already found four seams:
incomplete divided-power relations, asserted transitive-dihedral and endpoint
actions, an unstated identification of the prime-field cocycle with the
point-vector extension, and an underived passage from Giudici's maximal
subgroups to the needed \(p'\)-subgroup list.  Repairs were made and a final
context-free reader returned GO.  These are priors for selecting personas, not
evidence to show them.  If a persona independently rediscovers one, treat that
as a high-confidence finding and compare it against the current manuscript,
not the old repair report.

## Recommendation

Start with four reads:

1. Giudici persona, full Sections 2–3;
2. Wildon persona, modular core only;
3. Korchmáros persona, abstract through classification plus carrier boundary;
4. Salizzoni persona, Section 4 only.

The acceptance target is not unanimous GO.  It is: no two readers identify the
same unresolved major seam; the Wildon reader can verify the finite-group Hom
and first-wall step; the Giudici reader can verify complete subgroup
exhaustion; and the Korchmáros and Salizzoni readers agree that the priority
boundary is exact.
