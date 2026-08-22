# Round-four consistency read of the C914 diff

**Date**: 2026-08-19
**Lane**: `cubic-threefolds`
**Task**: C914
**Reviewer role**: independent referee, cold read, exposition and metadata only
**Diff reviewed**: `c914-round4.diff` — `sections/02-envelope.tex`,
`sections/03-minimal-class.tex`, `claim-proof-novelty-ledger.md`,
`lean/verification/claims.json` (all under
`papers/cubic-stabilization-m1/`)

A separate referee is checking the mathematics. Nothing below re-derives a
lattice computation or re-checks an isogeny argument; the findings are about
whether the changed sentences say what the surrounding text, the claim map, and
the ledger say they say.

## Verdict

The diff is a net improvement and nothing in it is wrong in a way that would
have to be reverted. Its mechanical hygiene is clean: the manuscript's own
spacing lint passes, every changed line is inside eighty columns, the two-space
sentence rule holds, every citation in the changed lines carries a pinpoint, and
the new `statement_digest` in `claims.json` recomputes exactly from the edited
proposition. The substantive problems are of two kinds. First, the claim map's
`hypotheses` field for `prop:no-elliptic-product` now says that the last
conclusion needs "odd degree alone", which is a stronger claim than the
proposition makes: the proposition still needs the exotic gluing kernel and the
non-CM elliptic factor for that conclusion, and only the polarization condition
is dropped. Second, the rewritten paragraph in `sections/03-minimal-class.tex`
opens on an undefined noun ("block"), defines "signature" two sentences after
first using it, and packs the Klein-cubic exclusion into a four-clause sentence
with three unresolved pronouns; a cold reader will stall there. A related
smaller problem in `sections/02-envelope.tex` is that the edit moved the
unimodularity of the `P_i` under an explicit "Under the polarization hypothesis"
tag, while the later sentence that reuses that argument still disclaims only
orthogonality, so the reader cannot tell from the page whether the reuse is
licensed. All of these are local prose or field-text fixes.

## Findings, most severe first

### 1. The claim map now understates the hypotheses of the last conclusion

**File**: `papers/cubic-stabilization-m1/lean/verification/claims.json`,
row `prop:no-elliptic-product`, field `hypotheses`.

Quoted text:

> The exotic two-primary gluing kernel of the packet proposition, the elliptic
> factor without complex multiplication at the geometric generic point, odd
> isogeny degree, and an odd multiple of the product polarization; **for the
> last conclusion, odd degree alone.**

What is wrong: the field enumerates four hypotheses and then says the last
conclusion needs "odd degree alone". Read against that enumeration, "alone"
discards the first two as well as the fourth. The proof does not discard the
first two. Its last paragraph says "The argument above through
\(H_2=\bigoplus_iH_2^{(i)}\) with each summand \(\omega\)-stable uses only that
the index is odd, not orthogonality, so it applies" — that is, it *reuses* the
part of the argument built on the exotic two-primary gluing kernel
(`prop:principal-gluing-packet`) and on the elliptic factor having no complex
multiplication, and drops only the polarization condition. The `cautions` field
in the same row confirms this by keeping the complex-multiplication exclusion
unqualified: "members whose elliptic factor has complex multiplication are
excluded by hypothesis." So the row contradicts itself, and the `hypotheses`
side is the stronger and wrong one.

This is the only place among the three artifacts where the result is described
more strongly than the manuscript states it. The ledger's status cell uses the
same words, "odd degree alone already forbids an isogeny from a product of five
elliptic curves", but that cell opens with "UNCONDITIONAL given the paper's own
packet proposition and the non-CM generic elliptic factor", which declares the
two standing hypotheses before the phrase is used. The `hypotheses` field has no
such preamble.

Concrete replacement for the `hypotheses` field:

> The exotic two-primary gluing kernel of the packet proposition, the elliptic
> factor without complex multiplication at the geometric generic point, odd
> isogeny degree, and an odd multiple of the product polarization; the last
> conclusion drops only the polarization condition and keeps the gluing kernel,
> the non-CM elliptic factor, and odd degree.

Changing this field does not change the `statement_digest`, which hashes the
manuscript statement, so no refresh is needed.

### 2. "block" is used before it is introduced

**File**: `papers/cubic-stabilization-m1/sections/03-minimal-class.tex`,
first added sentence of the rewritten paragraph.

Quoted text:

> At least one block has size one or two, since the defining form of a smooth
> cubic threefold involves all five variables and five is not a multiple of
> three.

What is wrong: "block" has no antecedent. The paragraph's only preceding
sentence is "The order-three signatures give the same finiteness by a route that
uses no computation", which introduces no blocks. The nearest description of the
objects meant is in the *statement* of `prop:A5-nonseparated`, about twenty
lines up, where they are called "pairwise disjoint nonempty groups of at most
three variables" — "groups", not "blocks". The proof of `lem:eckardt-rank`
earlier in the same section calls them "parts" ("every diagonal block of the
Hessian belonging to another part vanishes"), where "block" already means
something else, a block of the Hessian matrix. So the section now carries three
words — groups, parts, blocks — for one notion, and the added sentence chooses
the one that collides with an existing use.

Concrete replacement:

> Write a separated-variable form, as in
> Proposition~\ref{prop:A5-nonseparated}, as a sum of cubic forms in pairwise
> disjoint groups of variables. At least one group has size one or two, since
> the defining form of a smooth cubic threefold involves all five variables --
> otherwise the threefold is a cone and singular -- and five is not a multiple
> of three. Multiplying the variables of such a group by \(\zeta_3\) fixes the
> form, so such a cubic admits ...

and then "such a group" in place of "such a block" in the next sentence.

### 3. "the two decompositions just obtained" has two candidate antecedents

**File**: `papers/cubic-stabilization-m1/sections/02-envelope.tex`, last
paragraph of the proof of `prop:no-elliptic-product`.

Quoted text:

> The argument above through \(H_2=\bigoplus_iH_2^{(i)}\) with each summand
> \(\omega\)-stable uses only that the index is odd, not orthogonality, so it
> applies. Each \(U_i\) is now a line, so **the two decompositions just
> obtained** force \(\Lambda_1\cap U_i\) and \(\Lambda\cap U_i\) to have rank
> one, ...

What is wrong: there are two readings and the wrong one is the nearer.

Reading A, the intended one: the pair
\(\Lambda_1\otimes\mathbf Z_2=\bigoplus_i(\Lambda_1\cap U_i)\otimes\mathbf Z_2\)
and
\(\Lambda\otimes\mathbf Z_2=\bigoplus_i(\Lambda\cap U_i)\otimes\mathbf Z_2\),
obtained in the "Apply the displayed description ... in two ways" paragraph,
roughly forty lines above.

Reading B, the nearer one: \(L\otimes\mathbf Z_2=\bigoplus_iP_i\) and
\(H_2=\bigoplus_iH_2^{(i)}\), the latter named in the immediately preceding
clause. Only reading A supports the rank-one conclusion. "Just obtained" points
the reader at B.

Concrete replacement:

> Each \(U_i\) is now a line, so the decompositions
> \(\Lambda_1\otimes\mathbf Z_2=\bigoplus_i(\Lambda_1\cap U_i)\otimes\mathbf Z_2\)
> and \(\Lambda\otimes\mathbf Z_2=\bigoplus_i(\Lambda\cap U_i)\otimes\mathbf Z_2\)
> force \(\Lambda_1\cap U_i\) and \(\Lambda\cap U_i\) to have rank one, ...

### 4. The reuse disclaimer no longer covers everything the edit quarantined

**File**: `papers/cubic-stabilization-m1/sections/02-envelope.tex`, proof
of `prop:no-elliptic-product`.

The edit rewrote the construction of \(L'\) so that three consequences are now
explicitly tagged as conditional on the polarization hypothesis:

> Under the polarization hypothesis that sum is moreover orthogonal, each
> summand of \(L'\) carries \(m\) times a unimodular alternating form, and each
> \(P_i\) is unimodular.

Before the edit, orthogonality and unimodularity were asserted flatly, as part
of the construction. The later paragraph that reuses this material was not
changed to match:

> The argument above through \(H_2=\bigoplus_iH_2^{(i)}\) with each summand
> \(\omega\)-stable uses only that the index is odd, **not orthogonality**, so
> it applies.

What is wrong: the disclaimer releases one of the three tagged consequences and
is silent about the other two. A referee reading the reuse sentence has to go
back, re-read the intervening two paragraphs, and satisfy himself that the
projection-and-comparison step never touched the unimodularity of the \(P_i\).
That is exactly the kind of held-in-mind bookkeeping the paragraph was rewritten
to remove, and the edit made it worse rather than better by making the
conditionality explicit in one place and not the other.

Concrete replacement for the reuse sentence:

> The argument above through \(H_2=\bigoplus_iH_2^{(i)}\) with each summand
> \(\omega\)-stable uses only that the index is odd -- neither the orthogonality
> of the \(P_i\) nor their unimodularity enters it -- so it applies.

### 5. "that sum" is ambiguous between two sums in the same sentence pair

**File**: `papers/cubic-stabilization-m1/sections/02-envelope.tex`, same
paragraph as finding 4.

Quoted text:

> ... localizing at two turns those inclusions into equalities:
> \(L\otimes\mathbf Z_2=\bigoplus_iP_i\) with
> \(P_i=\bigl(L\cap(U_i\otimes M_{\mathbf Q})\bigr)\otimes\mathbf Z_2\). Under
> the polarization hypothesis **that sum** is moreover orthogonal, each summand
> of \(L'\) carries \(m\) times a unimodular alternating form, and each \(P_i\)
> is unimodular.

What is wrong: two direct sums are live. One is \(\bigoplus_iP_i\), in the
display immediately before. The other is the direct-sum decomposition of \(L'\)
itself, announced two sentences earlier ("It is the direct sum of sublattices of
the sub-Hodge structures ..."), and it is the one the same sentence goes on to
talk about ("each summand of \(L'\)"). The sentence therefore switches referent
mid-clause without saying so. The intended reading is \(\bigoplus_iP_i\), on the
strength of the closing clause about the \(P_i\), but the reader has to
back-solve it.

Concrete replacement:

> Under the polarization hypothesis the decomposition
> \(L\otimes\mathbf Z_2=\bigoplus_iP_i\) is moreover orthogonal and each \(P_i\)
> is unimodular, and each summand of \(L'\) carries \(m\) times a unimodular
> alternating form.

### 6. The inserted relative clause separated "Each" from its antecedent

**File**: `papers/cubic-stabilization-m1/sections/03-minimal-class.tex`.

Quoted text, with the added clause in bold:

> Gonz\'alez-Aguilera--Liendo identify these two signatures as their families
> \(T_3^1\) and \(T_3^2\) \cite[Theorem~2.5]{GonzalezAguileraLiendo}, **whose
> union therefore contains every point of \(M_{H_1}\) represented by a cubic
> projectively equivalent to a separated-variable form.** Each is the image in
> moduli of \(U^G/N_{\operatorname{GL}_5(\C)}(G)\), for \(U^G\) the locus of
> smooth cubics fixed by the relevant group \(G\), under a finite morphism,
> hence closed \cite[Lemmas~2.6--2.7]{Hartlieb}.

What is wrong: before the edit, "Each" sat directly after "their families
\(T_3^1\) and \(T_3^2\)" and read unambiguously. The inserted clause now
interposes "every point of \(M_{H_1}\)", "a cubic", and "a separated-variable
form" between "Each" and the families, and "Each" is left with three nearer
plural or generic candidates. The fix is to break the sentence rather than
subordinate the new content.

Concrete replacement:

> Gonz\'alez-Aguilera--Liendo identify these two signatures as their families
> \(T_3^1\) and \(T_3^2\) \cite[Theorem~2.5]{GonzalezAguileraLiendo}. The union
> of the two families therefore contains every point of \(M_{H_1}\) represented
> by a cubic projectively equivalent to a separated-variable form. Each family
> is the image in moduli of \(U^G/N_{\operatorname{GL}_5(\C)}(G)\), ...

While making that edit it is worth naming the normalizer, since
\(N_{\operatorname{GL}_5(\C)}(G)\) is never glossed: "for \(U^G\) the locus of
smooth cubics fixed by the relevant group \(G\) and
\(N_{\operatorname{GL}_5(\C)}(G)\) its normalizer". The gloss is missing in
unchanged text, so this is optional here, but the sentence's subject was
rewritten by this diff and the whole sentence will be reflowed anyway.

### 7. "signature" is defined two uses after its first use, and the definition has a loose clause

**File**: `papers/cubic-stabilization-m1/sections/03-minimal-class.tex`.

Quoted text:

> ... so such a cubic admits an order-three automorphism of signature
> \((0,0,0,0,1)\) or \((0,0,0,1,1)\); a signature is the tuple of exponents of
> \(\zeta_3\) in a diagonalization of a linear lift of the automorphism, well
> defined up to permutation of the coordinates, replacement of **the chosen
> generator** by its inverse, and multiplication of the lift by **a scalar**.

Three problems in one clause.

First, placement. The word "signature" is used in the paragraph's opening
sentence ("The order-three signatures give the same finiteness ...") and again
in this sentence's own main clause, and is defined only afterwards, in a
trailing semicolon clause. A reader meeting the term cold reads two uses before
the definition arrives.

Second, "the chosen generator" has no antecedent. Nothing earlier has been
called a generator. The intended object is \(\zeta_3\) as a chosen primitive
cube root of unity, but \(\zeta_3\) was introduced as a multiplier for
variables, not as a generator of anything.

Third, "multiplication of the lift by a scalar" is too loose to be read once:
an arbitrary scalar destroys the property that the eigenvalues are cube roots of
unity, so the exponent tuple is no longer defined. The intended ambiguity is
multiplication by a cube root of unity, which is also what makes the cyclic
permutation of multiplicities in the next sentence correct.

Concrete replacement, moved to the head of the paragraph:

> The order-three signatures give the same finiteness by a route that uses no
> computation. Fix a primitive cube root of unity \(\zeta_3\). The signature of
> an order-three automorphism of a smooth cubic threefold is the tuple of
> exponents of \(\zeta_3\) in a diagonalization of a linear lift of the
> automorphism to \(\operatorname{GL}_5(\C)\); it is well defined up to
> permutation of the entries, replacement of \(\zeta_3\) by \(\zeta_3^2\), and
> multiplication of the lift by a cube root of unity.

and then delete the trailing clause from the sentence where it now sits.

### 8. The Klein-cubic exclusion is one sentence with three unresolved pronouns

**File**: `papers/cubic-stabilization-m1/sections/03-minimal-class.tex`.

Quoted text:

> The multiplicities of the eigenvalues \(1,\zeta_3,\zeta_3^2\) are \((2,2,1)\)
> for **that signature** and \((4,1,0)\) and \((3,2,0)\) for **the two above**,
> while **a scalar shift** permutes the multiplicities cyclically and
> **inversion** transposes the last two, so no such move identifies **them**:
> the Klein cubic lies in neither family.

What is wrong, item by item. "That signature" is \((0,0,1,1,2)\), four lines
back, past an intervening citation and an automorphism group. "The two above"
has at least three candidates in the paragraph — the two signatures
\((0,0,0,0,1)\) and \((0,0,0,1,1)\), the two families \(T_3^1\) and \(T_3^2\),
and the two moduli loci — and only the first makes the arithmetic true. "A
scalar shift" and "inversion" are new names, coined here, for two of the three
ambiguities the previous sentence had just listed under different names
("multiplication of the lift by a scalar" and "replacement of the chosen
generator by its inverse"); a reader has to match them up. "Identifies them"
does not say what is being identified with what: the reading needed is that no
move carries \((2,2,1)\) to \((4,1,0)\) or to \((3,2,0)\). And the whole thing
is one sentence with four clauses and a colon.

The underlying argument is also simpler than the sentence makes it look: all the
moves permute the entries of the triple, \((2,2,1)\) has no zero entry, and both
of the others do. Saying that outright removes the need to track which
permutations are available.

Concrete replacement:

> Attach to a signature the triple of multiplicities of the eigenvalues
> \(1,\zeta_3,\zeta_3^2\). It is \((2,2,1)\) for \((0,0,1,1,2)\), and
> \((4,1,0)\) and \((3,2,0)\) for \((0,0,0,0,1)\) and \((0,0,0,1,1)\).
> Permuting the coordinates leaves the triple fixed, multiplying the lift by a
> cube root of unity permutes its entries cyclically, and replacing \(\zeta_3\)
> by \(\zeta_3^2\) transposes its last two entries, so all three ambiguities act
> by permutations of the entries. The triple \((2,2,1)\) has no zero entry and
> the other two do, so the Klein cubic lies in neither family.

### 9. The finiteness step now stands twice in the same section with two different justifications

**File**: `papers/cubic-stabilization-m1/sections/03-minimal-class.tex`.

The added sentence:

> The preimage in \(B^\circ\) of each of the two loci under the moduli map is
> closed and omits a parameter of the Klein cubic, hence is a proper closed
> subset of **the irreducible curve \(B^\circ\), a nonempty open subset of a
> \(\PP^1\)**, and therefore finite; \(M_{H_1}\) is the image of \(B^\circ\), so
> each locus meets it in a finite set.

The proof of `prop:A5-not-coprime`, about sixty lines above, runs the same step:

> ... it is a proper subset, and \(B^\circ\) is **a connected curve**, so it is
> finite; \(M_{H_1}\) is the image of \(B^\circ\), so finitely many of its
> points are covered.

Two problems.

First, the two passages describe the same curve differently and justify the same
inference differently. The new passage says "irreducible" and supplies a ground
for it ("a nonempty open subset of a \(\PP^1\)"); the older one says "connected"
and supplies none. Since a proper closed subset of a merely connected curve need
not be finite, the new passage is the correct one, and it silently leaves the
earlier passage looking weaker than it needs to be. The cheap repair is to make
the earlier proof say the same thing, or to have the new passage cite it: "by
the same descent as in the proof of Proposition~\ref{prop:A5-not-coprime}".
Either way the two should not disagree on the adjective. Note that the
introduction, at `sections/01-introduction.tex` around line 170, calls
\(B^\circ\) the "connected smooth locus" of the pencil, so if one adjective is
to win it should be introduced there and used consistently in both places.

Second, the appositive misparses. "a proper closed subset of the irreducible
curve \(B^\circ\), a nonempty open subset of a \(\PP^1\), and therefore finite"
puts "a nonempty open subset of a \(\PP^1\)" in a position where it can attach
to "a proper closed subset" as easily as to \(B^\circ\), and the reader has to
try both. Split the sentence.

Concrete replacement:

> \(B^\circ\) is a nonempty open subset of a \(\PP^1\), hence an irreducible
> curve. The preimage in \(B^\circ\) of each of the two loci under the moduli
> map is closed and omits the parameter of the Klein cubic, so it is a proper
> closed subset of \(B^\circ\) and therefore finite. Since \(M_{H_1}\) is the
> image of \(B^\circ\), each locus meets \(M_{H_1}\) in a finite set.

Two small points folded into that replacement: "a parameter of the Klein cubic"
becomes "the parameter", since the Klein cubic is a single member of the pencil;
and "the moduli map" is left as is, but it would read better as "under
\(B^\circ\to M_{H_1}\)", since that map is only ever referred to obliquely, as
"\(M_{H_1}\) is the image of \(B^\circ\)".

### 10. The ledger's literature cell pins a hypothesis the proposition does not have, in a sentence that does not close

**File**: `papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md`,
row "No elliptic-product route into Voisin's components", literature-posture
cell.

Quoted text:

> ... the obstruction here is about realizing such a splitting by an odd-degree
> isogeny: matching the polarizations when the factors have dimension at most
> three, and nothing beyond odd degree when there are five elliptic factors.

Two problems.

First, grammar. "The obstruction ... is about realizing such a splitting by an
odd-degree isogeny" is a complete predicate; the colon then introduces two noun
phrases, "matching the polarizations" and "nothing beyond odd degree", which do
not attach to it. The reader has to invent the missing verb.

Second, content. "when the factors have dimension at most three" is not a
hypothesis of `prop:no-elliptic-product`. The proposition's polarized half
allows a product of principally polarized abelian varieties of any dimensions,
subject only to \(\mu^*\Theta=m\sum_i\Theta_i\), and concludes that \(k=1\) or
that \(k=2\) with dimensions one and four. The "dimension at most three"
restriction belongs to the *application* to Voisin's route, stated in the prose
before the proposition in `sections/02-envelope.tex` and correctly attributed in
this ledger's own "Position of the pencil" text. As written this cell describes
the proposition more weakly than the manuscript states it, and a reader checking
the cell against the proposition will find no such hypothesis there.

Concrete replacement:

> ... the obstruction here is about realizing such a splitting by an odd-degree
> isogeny. For a product of principally polarized factors under which the
> polarization pulls back to an odd multiple of the product polarization, only
> the shapes one and one-plus-four survive, which already rules out every factor
> having dimension at most three; for a product of five elliptic curves nothing
> beyond odd degree is assumed.

### 11. The claim map's conclusion drops two assertions the proposition makes

**File**: `papers/cubic-stabilization-m1/lean/verification/claims.json`,
row `prop:no-elliptic-product`, field `conclusion`.

The edited proposition asserts, in its statement, both that the two-factor case
is realized "with \(A_1\) an elliptic curve isogenous to \(E\)" and that "\(J\)
is isogenous to \(E^5\)". The `conclusion` field records neither: it says only
"the second case is realized by every axis", and stops at "receives no
odd-degree isogeny from a product of five elliptic curves".

The second omission is the one that matters. That \(J\) is isogenous to \(E^5\)
is what makes the negative result surprising rather than routine, and the ledger
status cell does carry it ("although the intermediate Jacobian is isogenous to
`E^5`"), as does the introduction's cycle-side paragraph. Only the claim map
lacks it, which makes the three artifacts disagree on the content of the same
sentence.

Concrete replacement for the tail of the `conclusion` field:

> ... and, with no condition imposed on the pulled-back polarization, the
> intermediate Jacobian receives no odd-degree isogeny from a product of five
> elliptic curves, even though it is isogenous to the fifth power of that
> elliptic curve.

Again this does not affect `statement_digest`.

### 12. The proposition's last sentence carries a mid-sentence override of its own standing hypothesis

**File**: `papers/cubic-stabilization-m1/sections/02-envelope.tex`,
statement of `prop:no-elliptic-product`.

Quoted text:

> Moreover \(J\) receives no odd-degree isogeny at all from a product of five
> elliptic curves, with no condition imposed on the pulled-back polarization,
> although \(J\) is isogenous to \(E^5\).

The new wording is more accurate than what it replaced ("whatever polarizations
those factors carry" named the wrong object, since the condition being dropped
is on \(\mu^*\Theta\), not on the factors' own polarizations). But the sentence
still asks the reader to hold a retraction in mind: the proposition's setup
paragraph fixed \(\mu\) with \(\mu^*\Theta=m\sum_i\Theta_i\), and this sentence
silently introduces a different isogeny while cancelling that condition in a
mid-sentence aside. On a first cold read it is not obvious whether "no condition
imposed" cancels the setup or merely adds emphasis to it.

Concrete replacement:

> Finally, no product of five elliptic curves admits an odd-degree isogeny onto
> \(J\) at all, for any pullback of \(\Theta\), even though \(J\) is isogenous
> to \(E^5\).

The corresponding sentence in the proof already handles this correctly ("For the
last assertion drop the polarization hypothesis and let
\(\mu:\prod_{i=1}^5E_i\to J\) be any isogeny of odd degree"), so the statement is
the only place that needs the change.

### 13. Small wording points in the ledger status cell

**File**: `papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md`,
row "No elliptic-product route into Voisin's components", proof-status cell.

Quoted text:

> The five-elliptic-factor conclusion drops the polarization hypothesis
> entirely: odd degree alone already forbids an isogeny from a product of five
> elliptic curves, although the intermediate Jacobian is isogenous to `E^5`.

"Forbids an isogeny from a product of five elliptic curves" has no target until
the following clause supplies one, so on a first read the sentence appears to
forbid such isogenies outright rather than onto this particular Jacobian. And
"drops the polarization hypothesis entirely" plus "odd degree alone" says the
same thing twice, which is what makes the phrase portable into the claim map,
where it became finding 1.

Concrete replacement:

> The five-elliptic-factor conclusion drops the polarization hypothesis: no
> product of five elliptic curves admits an odd-degree isogeny onto the
> intermediate Jacobian, even though that Jacobian is isogenous to `E^5`.

## Checked and found clean

**Mechanical hygiene.** The manuscript's own spacing lint,

    nix shell nixpkgs#python3 -c python3 ../scripts/lint_tex_spacing.py \
      cubic_stabilization_m1.tex sections/*.tex

run from `papers/cubic-stabilization-m1`, reports `TeX spacing-command
lint: 7 files: CHECK OK` and exits zero.

**Line width.** The longest changed line is 78 columns in
`sections/02-envelope.tex` and 77 in `sections/03-minimal-class.tex`, against
the eighty-column rule. Both files contain over-long lines elsewhere -- fifteen
in `02-envelope.tex` and three in `03-minimal-class.tex` -- but every one of
them is outside the diff and so outside this review.

**Sentence spacing.** Every sentence-ending period in the changed ranges is
followed by two spaces or a line break. No violations.

**Citations.** The changed lines contain
`\cite[Theorem~2.5]{GonzalezAguileraLiendo}`,
`\cite[Lemmas~2.6--2.7]{Hartlieb}`,
`\cite[Lemmas~2.6--2.7 and Proposition~5.7]{Hartlieb}` and
`\cite[Proposition~2.6]{GonzalezAguileraLiendo}`. Every one carries a pinpoint,
and no numeral appears outside a pinpoint or a mathematical expression. All
numeric quantities in the new prose are spelled out ("five is not a multiple of
three", "size one or two").

**Statement digest.** The new `statement_digest`
`04ed2c378b09dce46e2c96d4c4b5b0587caa352aeb36b6dfc708fb556ff95e8a` in the
`prop:no-elliptic-product` row was recomputed independently, by extracting the
proposition body from `sections/02-envelope.tex` and applying the checker's own
`statement_digest` normalization -- annotation macros stripped, comments
stripped, whitespace collapsed -- and it matches exactly. The digest therefore
does correspond to the edited statement.

The full source check, `python3 lean/verification/check_formal_artifact.py
--source-only`, could not be used as the verification path: it aborts before
reaching the digest comparison on a pre-existing Lean docstring failure,
`BlockSylvesterSolvability.lean:97 public declaration
blockDiagonalProjection_apply has no immediately preceding docstring`. That
failure is in Lean sources this diff does not touch and is outside this review's
scope, but it means the gate is currently red for reasons unrelated to the diff,
and whoever lands this will need it green before the digest change is actually
enforced.

**Symbols introduced before use.** In `sections/02-envelope.tex` every symbol
appearing in the changed sentences -- \(\Lambda\), \(\Lambda_1\), \(M\), \(L\),
\(L'\), \(U_i\), \(P_i\), \(H_2\), \(H_2^{(i)}\), \(\omega\), \(b\), \(m\),
\(\mu\), \(J\), \(E\) -- is bound earlier in the same proof or in the
proposition statement. In particular \(\Lambda_1=\Lambda^\vee\cap\tfrac12\Lambda\)
is defined at the head of the proof, which is what licenses the newly added
reason "it is killed by two because \(\Lambda_1\subseteq\tfrac12\Lambda\)"; that
addition is an improvement, since the previous text asserted the two-torsion
without a ground. \(P_i\) is now defined at its first use rather than after it.

In `sections/03-minimal-class.tex`, \(M_{H_1}\) is introduced at line 436 of the
same section, and \(B^\circ\) at `sections/01-introduction.tex` line 170 ("its
projectivization is a pencil with connected smooth locus \(B^\circ\)"), so the
new prose's use of \(B^\circ\) outside a proof is legitimate even though the
only prior occurrence in this section is inside the proof of
`prop:A5-not-coprime`. \(U^G\) is glossed in the same sentence that uses it.
The one symbol with no gloss anywhere, \(N_{\operatorname{GL}_5(\C)}(G)\), sits
in unchanged text; see finding 6.

**Consistency with `prop:A5-nonseparated` above.** The rewritten paragraph
establishes exactly the first sentence of that proposition -- that only finitely
many points of \(M_{H_1}\) are represented by cubics projectively equivalent to
a separated-variable form -- by a route that does not pass through the Eckardt
computation. It makes no claim about the "Consequently" clause, which runs
through `cor:universal-ch0` and is independent of how the finiteness was
obtained. No contradiction, and the closing sentence of the paragraph ("The
finiteness of the separated-variable locus therefore does not depend on the
registered computation") is a correct summary of what was just printed.

The claim map already anticipates this. The `prop:A5-nonseparated` row's
`hypotheses` field ends "the order-three signature route printed after the proof
gives the same finiteness without any computation", and its `cautions` field
ends "the computation-free route is recorded after it". Both remain accurate
after the rewrite, and that row's `statement_digest` is correctly left untouched,
since the proposition statement itself did not change.

**Consistency with the pointer paragraph below.** The paragraph beginning "All
but finitely many moduli points of the pencil escape the separated-variable
mechanism of \cite{CT} by Proposition~\ref{prop:A5-nonseparated}" is unaffected:
it attributes the finiteness to the proposition, which remains true whichever
route proves it, and it correctly says that none of the three results asserts
disjointness from Voisin's locus. No conflict.

**Duplication against `prop:A5-not-coprime`.** The rewritten paragraph does
repeat the descent step of that proof -- proper closed subset of \(B^\circ\)
hence finite, then push forward along \(B^\circ\to M_{H_1}\) -- nearly word for
word, but the repetition is not a logical conflict: the two arguments feed that
step from different inputs, the Eckardt computation in one case and the Klein
cubic's order-three signature in the other, which is the whole point of printing
the second. The only real problem is the adjective disagreement recorded in
finding 9; a back-reference to the earlier proof would also shorten the new
paragraph.

**Agreement of the strengthened statement across artifacts.** The phrase "with
no condition imposed on the pulled-back polarization" appears verbatim in all
three of the proposition statement, the claim map's `conclusion` field, and the
ledger's "Position of the pencil" text. Apart from finding 1, on the claim map's
`hypotheses` field, and finding 10, on the ledger's literature cell, the three
artifacts describe the result at the same strength.

**The unchanged introduction is already correct for the strengthened
statement.** `sections/01-introduction.tex` around line 328 says the intermediate
Jacobian "receives no odd-degree isogeny from a product of elliptic curves,
although it is isogenous to the fifth power of an elliptic curve", with no
polarization qualifier at all. That was already the polarization-free form, so
the strengthening in Section 2 does not create a conflict with it and no
introduction edit is needed.

**Arithmetic in the new Klein-cubic passage.** The multiplicity triples printed
in the changed text are right for the signatures they are attached to:
\((0,0,1,1,2)\) gives \((2,2,1)\), \((0,0,0,0,1)\) gives \((4,1,0)\), and
\((0,0,0,1,1)\) gives \((3,2,0)\). The new opening claim that at least one group
of variables has size one or two also follows from what the sentence itself
offers: the groups have size at most three and partition all five variables, and
five is not a multiple of three. Finding 8 is about how these are said, not
about whether they are true.

**Cautions field.** The `cautions` text for `prop:no-elliptic-product` was not
changed and remains accurate for the edited statement: the complex-multiplication
exclusion it records still applies to all three conclusions, which is precisely
what finding 1 says the `hypotheses` field now contradicts.
