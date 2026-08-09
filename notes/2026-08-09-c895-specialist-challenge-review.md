# Review-sub-agent-only memo: C895 modular and tame-group repair challenge

**Date:** 2026-08-09  
**Role:** hostile modular-representation/group-theory referee  
**Packet verdict:** **MINOR / conditional pass**  
**Current-manuscript verdict:** remains **MAJOR** until the false universal
socle assertion is removed and the targeted repair is installed

This memo is review-sub-agent material only. It is not routing, handoff,
manuscript, or Lean material.

## Material checked

I treated the following six C895 memos as a closed proposed-repair packet:

- `notes/2026-08-09-c895-preclassification-interface.md`;
- `notes/2026-08-09-c895-steinberg-source-hom.md`;
- `notes/2026-08-09-c895-extension-field-linear-detectors.md`;
- `notes/2026-08-09-c895-prime-field-fischer-detectors.md`;
- `notes/2026-08-09-c895-tame-subgroup-exhaustion.md`; and
- `notes/2026-08-09-c895-q9-extra-hom-and-repair.md`.

I compared them with the complete current Paper II source, SHA-256
`8349caa13468a4d08b9d191d1b6428df7a066a3f0aedb0609e7ece68b40ad0cf`.
That manuscript is unchanged from the cold read and still contains the false
“if and only if” Lucas-socle statement.

I checked the load-bearing external replacements against:

- S. Doty and A. Henke, *Decomposition of tensor products of modular
  irreducibles for SL2*, arXiv:math/0205186, primary PDF SHA-256
  `8fb52434afec7149a85783fbc791f17cb2f7c539312bc3aec94a14ada10f4d6f`,
  especially Lemmas 1.1, 1.3, 1.4 and Theorem 2.1; and
- X. Faber, *Finite p-Irregular Subgroups of PGL(2,k)*,
  arXiv:1112.1999 / *La Matematica* 2 (2023), primary PDF SHA-256
  `2c32c6ec0cef4f6a5d92fba5cf899e67d16c2413ccbb517df1c03be5ab3f1e00`,
  Theorem C.

I did not inspect or run Lean, Lake, generators, falsifier code,
certificates, or builds. The explicit (q=9) catalecticant map in the packet
is enough to falsify the manuscript's universal assertion without trusting
the computation that found it.

## Executive verdict

The revised architecture is mathematically viable. I tried to break all five
requested interfaces and found no new counterexample. In particular:

1. the Steinberg source really is (T(2q)), with exactly the two claimed
   Weyl sections, and the filtration does imply the desired Hom vanishing;
2. the degree-(q-1) root argument really makes the two **linear-channel**
   finite maps algebraic;
3. the digitwise Cartan/Frobenius construction gives an injective
   (L(q-7)\hookrightarrow F), and multiplication by the discriminant has
   the determinant-normalized parity;
4. the prime-field Fischer decomposition, multiplicity-one retractions, and
   contraction scalars are correct; and
5. Faber Theorem C legitimately replaces the arbitrary-(p') recursive
   subfield descent at the abstract-type stage.

The safe revision is not yet the current paper. Two important scope defects
must be repaired in promotion:

- “finite maps are algebraic” must remain restricted to the linear targets
  whose root degree is at most (q-1); it does not replace the root-defect
  construction for the quadratic target; and
- deleting the false universal Lemma 3.2(i) must preserve and restate the
  detector-specific opposite-parity Hom calculations for the prime-field
  simples and (L(q-7)). The six-memo packet repairs the Steinberg member of
  that family, but it does not itself restate all the other quadratic-target
  checks now embedded in the manuscript's long lemma.

Subject to those guards and the exact repairs below, I would downgrade my
original modular objection from major to minor.

## 1. Steinberg source (T(2q)) and Hom vanishing

### Attempted break

Let (q=p^e),

\[
 \operatorname{St}=L(q-1),\qquad
 Y_1=L(1)\otimes L(1)^{(e)}.
\]

I checked separately the two possible failure points: the tilting
identification and the inference from a Weyl filtration to Hom vanishing.

Steinberg gives

\[
 L(q-1)=\bigotimes_{j=0}^{e-1}L(p-1)^{(j)}.
\]

Doty--Henke Lemma 1.3 says
(L(p-1)\otimes L(1)=T(p)), with no second summand. Their Lemma 1.4 gives
the unique canonical tilting factorization. The canonical digits of (q)
are

\[
 (p,p-1,\ldots,p-1),
\]

so

\[
 \operatorname{St}\otimes L(1)
 =T(p)\otimes\bigotimes_{j=1}^{e-1}T(p-1)^{(j)}
 \simeq T(q).
\]

Appending (T(1)^{(e)}) gives the canonical digits
((p,p-1,\ldots,p-1,1)) of (2q). Therefore

\[
 \operatorname{St}\otimes L(1)\otimes L(1)^{(e)}\simeq T(2q)
\]

is correct, including (e=1).

Doty--Henke Lemma 1.1 gives (T(p)) the two Weyl sections
(Delta(p)) and (Delta(p-2)). Multiplication by the other simple tilting
digits yields

\[
 \operatorname{ch}T(2q)
 =\operatorname{ch}\Delta(2q)
  +\operatorname{ch}\Delta(2q-2).
\]

Because a tilting module has a Weyl filtration and Weyl characters are
triangularly independent, these are exactly its two sections, once each.
For any target with top weight at most (2q-6), both
(operatorname{Hom}(\Delta(2q),M)) and
(operatorname{Hom}(\Delta(2q-2),M)) vanish. Applying the contravariant
Hom functor to either orientation of the two-step filtration injects or
restricts (operatorname{Hom}(T(2q),M)) between zero spaces. The conclusion
is valid; no Ext vanishing is being silently assumed.

### Verdict

**Pass.** This completely repairs the manuscript's invalid inference from a
high simple head alone.

### Safe textual repair

Cite Doty--Henke Lemmas 1.1, 1.3, and especially 1.4 explicitly. State the
canonical digit string and the two Weyl sections. The character calculation
is a useful check, but Lemma 1.4 is the actual tensor-factorization source.

## 2. Automatic algebraicity from the root-degree bound

### Attempted break

For a finite (Gamma=\operatorname{SL}_2(q))-map
(phi:S\to F), set

\[
 D(t)=u_F(t)\phi-\phi u_S(t).
\]

On (F=\operatorname{Sym}^{(q-3)/2}L(2)), every root-matrix entry has
degree at most (q-3). For (S=L(q-1)) or (L(q-7)), the source root
degrees are at most the corresponding highest weights. Hence every entry of
(D(t)) has degree at most (q-1). It vanishes on all (q) elements of
(mathbb F_q), so it is the zero polynomial. A polynomial of degree
(q-1) cannot have (q) distinct roots unless zero; there is no
(t^q-t) ambiguity.

The finite Weyl element then supplies the full negative root subgroup, and
the two algebraic root subgroups generate (mathbf G=\operatorname{SL}_2(k)).
Central actions are trivial because all relevant highest weights are even.
Thus

\[
 \operatorname{Hom}_{\operatorname{SL}_2(q)}(S,F)
 =\operatorname{Hom}_{\mathbf G}(S,F)
\]

is correct in these channels.

### Verdict

**Pass with a mandatory scope restriction.** The same sentence is false as
a blanket repair for maps into (M=\operatorname{Sym}^2F): its target root
degree is (2q-6), and the defect may be divisible by (t^q-t). The
manuscript's separate root-defect/(Y_1) injection remains necessary for
opposite-parity quadratic Hom spaces.

### Safe textual repair

Title the statement “algebraicity of the two linear detector channels,” not
“finite maps are algebraic.” Put the degree bound in the theorem statement.

## 3. The (L(q-7)) detector and outer normalization

### Attempted break

Assume (q\equiv3\pmod4) and (e>1). Then (p\equiv3\pmod4), (e) is odd,
and (q-7) has even base-(p) digits:

- (p-7,p-1,\ldots,p-1) if (p\ge7);
- (2,0,2,\ldots,2) if (p=3).

Writing (q-7=\sum 2r_jp^j) gives
(sum r_jp^j=(q-7)/2=d-2), without carry.

For (2r_j\le p-1), the highest-weight Cartan map

\[
 L(2r_j)\longrightarrow\operatorname{Sym}^{r_j}L(2)
\]

is nonzero. Its source is simple, so it is injective. After Frobenius twist,
the multiplication map

\[
 \bigotimes_j\left(\operatorname{Sym}^{r_j}L(2)\right)^{(j)}
 \longrightarrow \operatorname{Sym}^{d-2}L(2)
\]

is injective on the full tensor product: in the three coordinate exponents,
each digit is at most (r_j<p), so distinct tensor monomials have distinct
base-(p) exponent triples. This closes the possible cancellation objection
to the memo's shorter injectivity sentence.

Multiplication by the discriminant (Q) is injective in the symmetric
algebra, giving

\[
 L(q-7)\hookrightarrow\operatorname{Sym}^{d-2}L(2)
 \xrightarrow{\cdot Q}F.
\]

As a covariant polynomial (GL_2)-module, the source has degree (q-7), the
target degree (q-3), and (Q) transforms by (det^2). Thus the map is
(GL_2)-equivariant from (L(q-7)\otimes\det^2) to (F). After normalizing
the target by (det^{-d}), the source twist is

\[
 \det^{2-d}=\det^{-(q-7)/2},
\]

which is exactly the determinant-normalized projective extension. The other
finite (PGL_2(q))-extension differs by
(det^{(q-1)/2}) and is absent from the linear target because every finite
map in this channel is algebraic.

### Verdict

**Pass.** I found no carry, injectivity, or parity defect.

### Exact minor defects

1. The memo should explicitly define the Cartan map as the submodule
   generated by the highest vector ((X^2)^{r_j}); its injectivity then
   follows from simplicity of (Delta(2r_j)=L(2r_j)).
2. State whether the manuscript uses the covariant or contragredient
   (GL_2)-action at this point. The exponent changes sign under dualization,
   but the determinant-normalized parity does not. Writing the normalization
   calculation above will prevent a convention mismatch.
3. The assertion that the (q=9) specialization is precisely the displayed
   catalecticant map under Hermite reciprocity is explanatory, not needed for
   the exclusion, and is not derived in the memo. Either show the
   identification or weaken it to “accounts for an (L(2,0)) occurrence.”

## 4. Prime-field Fischer detectors and contraction

### Attempted break

Let (p\ge5), (d=(p-3)/2<p), and
(F=\operatorname{Sym}^dL(2)). Since (d!) is invertible, the ordinary
symmetrizer makes (F) a direct summand of (L(2)^{\otimes d}). Tilting
modules are closed under tensor products and direct summands, so (F) is
tilting.

The character identity

\[
 \operatorname{ch}F
 =\sum_{0\le j\le\lfloor(p-3)/4\rfloor}\chi_{p-3-4j}
\]

follows directly from the weights (2,0,-2). Every displayed highest
weight is at most (p-3), hence its indecomposable tilting module is the
simple (L(p-3-4j)). Uniqueness of tilting decomposition proves the direct,
multiplicity-one Fischer decomposition and the required retractions.

For the cohomology support statement, the omitted standard steps are sound.
On (L(m)), (0\le m\le p-3), the root subgroup (U=C_p) is one Jordan
block, its norm is zero, and (H^1(U,L(m))) is its coinvariant line.
Hochschild--Serre for the (p')-torus gives the Borel invariants. The torus
weight is (a^{-(m+2)}), fixed exactly for (m=p-3). Restriction
(H^1(H,L(m))\to H^1(B,L(m))) is injective because
(operatorname{cor}\circ\operatorname{res}=[H:B]=p+1\ne0) in
characteristic (p). Thus the affine class is supported only on the top
Fischer factor.

The contraction formula gives ((s+1)[c]) on a lower summand and
((s+2)[c]) on the top. In the top case (s=p-3), so the latter scalar is
(p-1\ne0). In every lower detector range (s+1\ne0\pmod p). Together with
the manuscript's explicit nonzero root coefficient for ([c]), the
contradiction follows.

### Verdict

**Pass, with minor exposition debt.** Add the Hochschild--Serre and
restriction/corestriction sentences; do not leave “the torus acts on that
line” as the entire cohomology proof. Cite a standard source for closure of
tilting modules under tensor products and summands if this is not established
nearby.

## 5. Faber Theorem C and rational-conjugacy dependence

### Attempted break

The preclassification argument proves (K\le\operatorname{PSL}_2(q)) and
(p\nmid|K|) before any classification output: a nontrivial (p)-element is
unipotent and cannot stabilize a perfect matching. Embedding

\[
 K\le\operatorname{PGL}_2(\overline{\mathbb F}_p)
\]

therefore meets Faber Theorem C exactly. Over a separably closed field, every
finite (p)-regular subgroup is conjugate to a cyclic group, a dihedral
group, (A_4), (S_4), or (A_5). This proves the **abstract type list** for
the actual (K) and avoids all recursive subfield descent.

The later detector arguments do not require an (mathbb F_q)-rational
conjugating element:

- intransitivity is tested on the actual action of (K) on
  (mathbb P^1(\mathbb F_q));
- a transitive cyclic/dihedral subgroup is analyzed inside its actual
  rational split or nonsplit torus normalizer;
- exceptional invariant dimensions may be computed after algebraic-closure
  conjugacy, since they are dimensions of fixed spaces of rational
  (mathbf G)-modules and depend only on the algebraic representation
  restricted to the conjugate subgroup; and
- the transitive exceptional exclusion uses only (q+1\mid|K|) and the
  orders (12,24,60).

Thus Faber is sufficient at this stage. Giudici remains necessary later,
after the exact stabilizer order has been derived, for maximal overgroups and
outer class fusion.

### Verdict

**Pass with a rationality guard.** The rewritten paper must say that Faber
supplies abstract type/algebraic-closure conjugacy only. It must not use the
standard matrices in Faber to place (K) in a chosen rational torus or to
identify one of the two rational exceptional classes. Those later facts must
come from the actual (K\le PSL_2(q)), elementary rational-torus theory, or
Giudici as appropriate.

## R0 logical-order audit

I found no use of a forbidden R0 output in the repair packet.

- Projectivity of (k[H/K]) uses only (p\nmid|K|).
- The intransitive Steinberg detector uses only the number of endpoint
  orbits.
- The residual transitive dihedral analysis obtains the full nonsplit
  normalizer from the actual rational action and order, not from survivor
  data; its (q\equiv3\pmod4) condition comes from the outer-stabilizer
  calculation.
- Prime-field detector types and ranges use the tame abstract list and
  character averages, not sheet size (q).
- The (q=9) calculation is used only to falsify the universal lemma and
  motivate a targeted replacement.

In particular, the packet does not use one-factorization, regular sheet
translations, the Paley carrier, (q=7,11), survivor stabilizers, or C894.

## Remaining exact defects and coverage gap

### Defect 1: the manuscript still states a false theorem

Current Lemma 3.2(i) says its digit criterion is an “if and only if” basis of
the actual finite-group Hom space. At (q=9), the explicit catalecticant
minors give a second simple (L(2,0)=L(q-7)), contradicting that statement.
This clause must be deleted, not merely supplemented by the repair memos.

### Defect 2: quadratic-target scope must be preserved

The repair's linear algebraicity result does not prove opposite-parity
absence from (operatorname{Sym}^2F). The manuscript's root-defect injection

\[
 \operatorname{Hom}_{PGL_2(q)}(S^\square,\operatorname{Sym}^2F)
 \hookrightarrow
 \operatorname{Hom}_{\mathbf G}(S\otimes Y_1,\operatorname{Sym}^2F)
\]

must remain, together with a complete proof of its divided-power seam.

### Defect 3: the packet explicitly repairs only the Steinberg member of the
quadratic detector family

The current manuscript also contains targeted vanishing calculations for:

- the prime-field sources (L(s\pm1,1));
- (L(q-7)) when (p\ge7); and
- (L(q-7)) when (p=3).

I found no contradiction in those calculations during the cold read, but
they are not restated in these repair memos. A rewrite that deletes the long
universal lemma must transplant them into a new detector-specific quadratic
lemma rather than cite the six-memo packet as though it covers all R2
channels.

### Defect 4: exact convention and cohomology details remain prose repairs

The determinant normalization and Borel support calculations are correct,
but the manuscript revision should display the normalization and the
Hochschild--Serre/restriction-corestriction steps. These are minor, not new
mathematical gaps.

## Safe repair plan

1. Delete Lemma 3.2(i)'s universal Lucas-socle statement and every later
   appeal to it.
2. Replace the linear part by two short lemmas:
   - the degree-(q-1) algebraicity and Steinberg absence; and
   - the digitwise (L(q-7)) inclusion with determinant normalization.
3. Replace the quadratic part by a detector-specific lemma retaining the
   root-defect injection and four target checks:
   - Steinberg via (T(2q)) and its two Weyl sections;
   - the prime-field (L(s\pm1,1)) socle exclusion;
   - (L(q-7)), (p\ge7); and
   - (L(q-7)), (p=3).
4. State the prime-field Fischer decomposition as its own lemma, then give
   the Borel support and contraction scalar computation.
5. Invoke Faber Theorem C only for the abstract (p')-type list. Preserve
   the later Giudici citation for exact-order maximal overgroups and class
   fusion.
6. Add (q=9) as a one-sentence falsification warning or omit it after the
   false theorem is deleted; do not turn a bounded check into a premise.

## Final assessment

The C895 packet finds the right repair: narrow the argument to the modules
the exclusion actually uses. The main mathematical replacements survive
hostile review. The revision is **medium-sized but local to the modular
core**: it should shorten the paper and remove a false universal statement,
without changing the classification spine or using any forbidden survivor
output.

I recommend promotion only after Defects 1--3 are visibly resolved in the
human manuscript. At that point the remaining issues are minor citation,
normalization, and exposition repairs rather than threats to the headline
theorem.
