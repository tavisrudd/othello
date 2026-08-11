# C904 paper-v abstract cold read

**Scope.** Cold read of the abstract only, as an adjacent-field mathematician with no Clebsch-series context. I did not inspect the introduction, notes, Git history, or earlier versions.

## Forced verdict

**MAJOR (abstract exposition and claim precision, not a verdict on the mathematics).** The reconstruction headline is recoverable, but only by supplying several meanings that the abstract does not state. The six-point identity is nearly readable but does not bind all of its notation, and the all-orders lattice theorem and final Frobenius conclusion are not precise enough to test. The needed repair is local to the abstract; it does not require adding background exposition.

## What I can identify from the abstract

1. **Base field.** The geometry is over \(\mathbb F_{11}\), and the reconstruction is claimed to commute with scalar extension from \(\mathbb F_{11}\). It is unclear whether “every scalar extension” means every field extension or arbitrary \(\mathbb F_{11}\)-algebra base change.

2. **Two geometric objects.** They are geometrically inequivalent \(A_5\)-invariant cubic hypersurfaces on a common five-dimensional quadratic representation: a chordal cubic singular along a rational normal quartic, and a cubic constructed from a symmetric conference matrix of order six, with six isolated nodes. The abstract does not state whether the hypersurfaces lie in \(\mathbb P^4\), what “quadratic representation” means, or over which field geometric equivalence is measured.

3. **Question and inverse result.** The question is whether the two apparently lossy constructions determine the same \(A_5\)-marked six-point carrier. From the chordal side, the singular quartic plus twelve Sylow-\(5\)-fixed points recover six axes; an outer permutation of the axes and a difference operator then recover an oriented conference companion. After choosing one of two “chordal lines,” the two reconstructions are claimed to be mutually inverse.

4. **Selected-line hypothesis and residual quotient.** The choice of one of two chordal lines is an essential input to the inverse statement. Forgetting it gives exactly a residual \(C_2\)-quotient. I cannot tell what a chordal line is, why there are exactly two, what \(C_2\) acts on, or whether it exchanges the lines, orientations, reconstructions, or all three.

5. **Six-point recognition theorem.** For a two-graph \(\Delta\) on a six-point ground set, the abstract states
   \[
   16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2,
   \]
   and derives \(A(\Delta)=\varnothing\iff S^2=5I\). I read \(A(\Delta)\) as a set of four-subsets and \(|A(\Delta)|\) as its cardinality; \(S\) is the Seidel matrix and \(I\) the \(6\times6\) identity. The text does not explicitly bind \(x,y\), the range of the sum, or the meaning of \(xy\), and “triple signs” and “signed defect” are descriptions rather than definitions of \(A(\Delta)\) and \(m(xy)\). Thus not all symbols in the displayed identity are actually defined. The conclusion about “twelve labeled switching classes” is also hard to reconcile on first reading with calling the criterion “unmarked”; the equivalence relation and the meaning of the selected “invariant opposite pair” are absent.

6. **Uniform lattice theorem.** I can locate the theorem: for every normalized symmetric conference matrix \(B\) of order \(n\equiv2\pmod4\), \((I+B)/2\) “minimally stabilizes” \(D_n^\vee\), with a split/inert distinction according to \(n\bmod8\). But “normalized,” “minimally stabilizes,” the object that splits or remains inert, and which of \(n\equiv2,6\pmod8\) gives which branch are not stated. This is therefore recognizable as a uniform theorem, but not as a testable theorem. It quantifies over matrices of each order rather than asserting that such matrices exist at every admissible order; any “all-orders” gloss must preserve that distinction.

7. **The \(n=6\) and Frobenius conclusion.** At \(n=6\), normalization before reduction is said to yield the unique nonsplit extension of a trivial \(\mathbb F_4\)-line by the natural \(\mathbb F_4A_5\)-module, and reversal acts by Frobenius. The asserted final relation is stronger: the geometric \(C_2\)-ambiguity and the “integral Frobenius marking” are the same torsor. The abstract supplies no equivariant map identifying the two two-element sets, does not say what is reversed, and does not specify that Frobenius is the nontrivial element of \(\operatorname{Gal}(\mathbb F_4/\mathbb F_2)\) or on which object it acts. “Integral Frobenius marking” is especially misleading because the stated Frobenius action appears only after reduction to \(\mathbb F_4\).

## Friction, overstatement, and density

- **Undefined or misleading words:** “lossy invariants” (the antecedent seems to be two cubics, not named invariants), “marked carrier,” “six axes,” “outer permutation,” “oriented conference companion,” “difference operator,” “chordal lines,” “triple signs,” “signed defect,” “unmarked criterion,” “opposite pair,” “rank-five augmentation lattice,” “rank-six \(D\)-type lattice,” “binary heart,” “normalized,” “minimally stabilizes,” “split/inert,” “normalization before reduction,” “reversal,” and “integral Frobenius marking.” Several may be standard locally, but their combined load is too high for an abstract.
- **Theorem overstatement:** “commute with every scalar extension” is broader than the likely intended field-extension claim unless the constructions are genuinely scheme-theoretic over all \(\mathbb F_{11}\)-algebras. “Hence ... are the same torsor” does not follow for the reader merely from “reversal acts by Frobenius”; it needs the actual equivariant identification. “Unique nonsplit extension” also needs the category and equivalence notion.
- **Density:** the abstract contains three theorem families—geometric reconstruction, two-graph recognition, and integral/modular lattice structure—without one plain sentence giving their causal chain. Each paragraph introduces a new language, and the last paragraph compresses at least four undefined objects into its final three sentences. This is not just specialist vocabulary; it hides hypotheses and logical arrows.
- **Invisible headline:** the memorable claim appears to be an equivariant, base-change-compatible reconstruction equivalence between the chordal and conference geometries, with the sole ambiguity a \(C_2\) that becomes Frobenius after the integral/modular passage. The abstract never states that as one precise theorem. Instead, the inverse theorem is split across procedural sentences and the geometric–arithmetic identification appears only as an unsupported final “Hence.” A reader cannot tell whether the all-orders lattice theorem is the mechanism for the reconstruction, an independent strengthening, or a second headline.

## Exact minimal repairs

1. **Replace the first two sentences by one typed setup.** Name the common ambient space and representation, specify the equivalence convention, and name the two cubics. For example, use the form: “Let \(V\) be [precise five-dimensional \(A_5\)-representation] over \(\mathbb F_{11}\). In \(\mathbb P(V)\), the chordal cubic \(X_{\mathrm{ch}}\), singular along a rational normal quartic, and the conference cubic \(X_{\mathrm{cf}}\), with six nodes, are not [precise notion] equivalent.” Fill the brackets from the theorem; do not leave “quadratic representation” unexplained.

2. **State the reconstruction theorem in one sentence rather than as a procedure.** Name the two marked-data spaces and the maps, then say: choosing either of the two [one-clause definition] chordal lines makes the maps inverse over every **field extension** of \(\mathbb F_{11}\); forgetting the choice quotients by the involution that [explicit action]. If arbitrary algebra base change is genuinely proved, say “base change along every \(\mathbb F_{11}\)-algebra” and keep the stronger wording.

3. **Make the six-point identity self-contained.** Introduce the ground set \(X\); write \(\sum_{\{x,y\}\in\binom X2}\); state that bars mean cardinality; and give the actual formula for the triple sign and for \(m(xy)\), not merely the phrase “signed defect.” Define the Seidel convention before the iff, and replace “unmarked ... twelve labeled switching classes” by an explicit count modulo a named equivalence. Define “opposite pair” or omit that refinement from the abstract.

4. **Turn the lattice sentence into a proposition with ordinary verbs.** Define normalization in a parenthesis, replace “minimally stabilizes” by the exact inclusion/equality/index statement, and spell out both residue branches: what object splits for \(n\equiv[2\text{ or }6]\pmod8\), and what is inert in the other case. Keep “for every matrix \(B\)” so as not to imply existence at every order.

5. **Make the final implication exact.** Specify the category in which the \(\mathbb F_4A_5\)-extension is unique; say what reversal acts on; identify Frobenius as \(z\mapsto z^2\); and add the map that intertwines the chordal-line involution with Frobenius. Then conclude that the two explicitly named two-element sets are isomorphic \(C_2\)-torsors. Replace “integral Frobenius marking” by “the marking induced after reduction to \(\mathbb F_4\)” unless an integral action has actually been defined.

6. **Add one causal headline and cut compensating jargon.** After the setup, add: “Our main result identifies these two marked geometries functorially; the only ambiguity is the involution exchanging [X], which reduction identifies with \(\mathbb F_4/\mathbb F_2\)-Frobenius.” To hold the length, delete “by one difference operator,” the augmentation/\(D\)-lattice contrast sentence unless it is essential to that implication, and the twelve-class refinement unless it is a principal result.

These six edits are the minimum because they repair the object types, the inverse theorem’s hypothesis and quotient, every symbol in the displayed identity, the quantifiers and branches of the uniform theorem, and the logical content of the Frobenius headline without adding an abstract-level tutorial.

## 2026-08-11 revised-abstract repair verdict

**Forced verdict: MINOR.** The revision discharges the major structural objection: the ambient representation is typed, the reconstruction theorem is stated before its quotient, the six-point identity is operational, the lattice theorem gives exact inclusions and mod-eight branches, and the ending now identifies conference orientation with Frobenius rather than vaguely identifying every geometric ambiguity with Frobenius. What remains can be fixed locally, without restructuring the abstract.

### Audit of the six demanded repairs

1. **Typed setup — mostly discharged.** The abstract now defines \(\Omega\), the augmentation module \(V\), its quadratic form, the cubic pencil in \(\mathbb P(V)\), and the node/singular-locus distinction. One convention remains: “These hypersurfaces are not projectively isomorphic” should say whether this compares the conference cubic with either chordal cubic (rather than asserting all three are pairwise nonisomorphic) and whether isomorphism is over \(\mathbb F_{11}\) or \(\overline{\mathbb F}_{11}\).

2. **Inverse theorem, selected line, and free quotient — partly discharged.** The text now states inverse reconstruction functors, restricts base change to field extensions, and gives the free involution. It still does not define “chordal line,” \(h\), or \(c\), and \(q\) is named but not typed. More importantly, the separate \(C_2\)-actions are only inferable from the fact that the displayed free involution fixes \(c\). Say what \(c\) is and state that this free quotient forgets the chordal lift while fixing the conference orientation; it is **not** the conference-orientation/Frobenius torsor of the final sentence.

3. **Six-point identity — almost discharged.** The revision defines \(X\), \(\sigma\), \(m\), \(A\), and the summation range. The sole formal mismatch is that \(A(\Delta)\) uses an undefined \(\Delta\). Write “let \(\Delta\) be the two-graph represented by \(S\)” or rename it \(A(S)\). For a genuinely self-contained convention, add “zero diagonal and \(\pm1\) off diagonal” after “Seidel matrix.”

4. **Uniform lattice theorem — almost discharged.** Stabilization, minimality, the quadratic relation, and both mod-eight branches are now explicit. Replace “positive first row” by “all off-diagonal entries in the first row equal to \(+1\),” since a conference matrix has zero diagonal. Define \(\bar\varphi\) as the endomorphism induced on the intended mod-two quotient (presumably \(D_n^\vee/2D_n^\vee\)); at present the carrier of \(\mathbb F_2[\bar\varphi]\) is unstated. “No smaller over-lattice” is safest as “\(D_n^\vee\) is the least \(\varphi\)-stable lattice containing \(\mathbb Z^n\).”

5. **Exact Frobenius implication — mostly discharged, with a needed separation.** Frobenius is now explicitly \(z\mapsto z^2\), and the claim correctly names the **conference-orientation/Frobenius** torsor. State that the nonsplit extension is unique up to isomorphism in the category of \(\mathbb F_4A_5\)-modules, and name the two two-element sets or the equivariant bijection between them. The final sentence must also say “separately from the free chordal-line quotient above,” or the preceding quotient must explicitly say it fixes conference orientation. Otherwise “outer involution,” “outer normalizer,” and two nearby \(C_2\)-actions invite the false identification that the revision is meant to avoid.

6. **Causal headline and density — discharged.** “They nevertheless encode the same marked carrier” now gives the geometric headline, each later paragraph has one theorem family, the exact twelve-class refinement has been removed, and the final paragraph supplies the arithmetic consequence. No further structural shortening is required for this repair gate.

### Remaining exact edits

1. Qualify the projective-isomorphism claim by the compared cubics and base field.
2. Define the chordal line and the symbols \(q,h,c\); explicitly say the free quotient fixes conference orientation and is distinct from the conference-orientation/Frobenius torsor.
3. Bind \(\Delta\) to \(S\) (or use \(A(S)\)) and give the Seidel entry convention.
4. Change “positive first row” to “positive off-diagonal first row,” define the quotient carrying \(\bar\varphi\), and phrase minimality as a least stable lattice.
5. Give the module category/equivalence for “unique,” and name the equivariant bijection realizing the final principal \(C_2\)-torsor identification.
