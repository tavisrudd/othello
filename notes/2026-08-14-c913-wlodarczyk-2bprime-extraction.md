# C913 Package D — Wlodarczyk Proposition 2(B') source extraction

**Purpose**: source extraction for the orbit-cylinder lemma in the referee revision of
`papers/cubic-stabilization-irrationality`, which cites [Wło00] "Proposition 2(B')".
Verbatim quotes with locators; anything marked *(paraphrase)* is structural summary, not his words.
No interpretation, correction, or extension of the mathematics is attempted here.

## Bibliographic identification

`refs.bib` key `Wlodarczyk` (lines 161–170): Włodarczyk, Jarosław, "Birational cobordisms and
factorization of birational maps", *Journal of Algebraic Geometry* **9** (2000), 425–449,
eprint `arXiv:math/9904074`.

Source consulted: the arXiv v1 eprint (15 Apr 1999), title verified to match the bib entry.
Lit-search cache key **`arXiv:math/9904074`**, status `ok`, 23 pages,
sha256 `ac86c460c3a039284565630ef63a77028af53a71697d4d0deb356574d2b3aa9c`,
fetched 2026-08-13 from `https://arxiv.org/pdf/math/9904074`.
PDF `/tmp/persistent/tavis/lit-search/pdf/arXiv_math_9904074.pdf`;
text `/tmp/persistent/tavis/lit-search/text/arXiv_math_9904074.txt` (poppler `pdftotext`).

**All page numbers below are arXiv v1 preprint pages, not JAG 425–449 pagination.**
Numbered statements (Definition 2, Proposition 2, Lemma 7, ...) are the stable locators.

## (a) Definition of a birational cobordism — Definition 2, p. 2

> **Definition 2:** Let X_1 and X_2 be two birationally equivalent normal varieties. By
> a birational cobordism or simply a cobordism B := B(X_1, X_2) between them we
> understand a normal variety B with an algebraic action of K* such that the sets
> B_− : = {x ∈ B | lim_{t→0} tx does not exist} and
> B_+ : = {x ∈ B | lim_{t→∞} tx does not exist}
> are nonempty and open and there exist geometric quotients B_−/K* and B_+/K* such
> that B_+/K* ≃ X_1 and B_−/K* ≃ X_2 and the birational equivalence X_1 −→ X_2 is
> given by the above isomorphisms and the open embeddings V := B_+ ∩ B_−/K* ⊂
> B_+/K* and V ⊂ B_−/K*.

Convention to note: **the subscript is the limit that FAILS to exist.** `B_−` is where the
`t→0` limit does not exist; `B_+` is where the `t→∞` limit does not exist. The *first*-named
variety `X_1` is the quotient of `B_+`, and `X_2` is the quotient of `B_−`.

Ground field, p. 1: "The ground field K is assumed to be algebraically closed."
Good/geometric quotients are Definition 1, p. 1.

Ordering and collapsibility, Definition 4, p. 5:

> **Definition 4.** Let B be a cobordism. We say that a connected component F of
> the fixed point set is an immediate predecessor of a component F′ iff there exists
> a non-fixed point x such that lim_{t→0} tx ∈ F and lim_{t→∞} tx ∈ F′. We say that F
> precedes F′ and write F < F′ if there exists a sequence of connected fixed point
> set components F_0 = F, F_1, ..., F_l = F′ such that F_{i−1} precedes F_i (see [B-B,S], Def.
> 1.1). We call a cobordism collapsible (see also [Mor]) iff the relation < on its set
> of connected components of the fixed point set is an order. (Here an order is just
> required to be transitive.)

> **Lemma 1.** A projective cobordism is collapsible. (p. 5; proof uses Sumihiro
> equivariant embedding into P^n with semi-invariant homogeneous coordinates.)

Sink/source, Definition 7, p. 6:

> **Definition 7.** Let X be a variety acted on by K*. By a sink (resp. a source) of
> X we mean an irreducible component F of the fixed point set such that F^− (resp.
> F^+) contains an open subset of X.

## (f) "Projective" vs "quasiprojective" — Definition 5, p. 5

Verbatim, including his spelling of the header:

> **Defintion 5.** A cobordism B is projective if B is a quasiprojective variety.

This is the terminology point the manuscript refers to: his "projective cobordism" means the
underlying variety is *quasiprojective*.

## (b) Proposition 2, all parts (p. 13)

> **Proposition 2.** **A.** There exists a projective cobordism B(X, X′) between any
> two birationally equivalent normal projective varieties X and X′.
> **B.** There exists a smooth cobordism B(X, X′) between any birationally equivalent
> smooth varieties X and X′ over a field of characteristic zero.
> **B'.** There exists a smooth projective cobordism B(X, X′) between any birationally
> equivalent smooth projective varieties X and X′ over a field of characteristic zero.
> **C.** For any birational morphism X → X′ of smooth projective varieties over a field
> of characteristic zero which is an isomorphism over U ⊂ X′, there exists a smooth
> projective cobordism B(X, X′)/X′ over X′ which is trivial over U.

## (c) Construction/proof of (B') (p. 13)

> **Proof.**
> In cases A, B', C one can find divisors D and D′ satisfying respectively the
> conditions A, B, C of Lemma 6. In case B we find divisors D and D′ satisfying the
> conditions of Lemma 5.
> [...]
> **B'.** Let L̄(X, D; X′, 0) be a K*-equivariant projective completion of L(X, D; X′, 0).
> Let B̄(X, D; X′, 0) be its canonical K*-equivariant resolution.

(In case B the completion is only "a K*-equivariant completion ([Sum], Thm. 3)"; in case A it is
"a K*-equivariant projective completion (see [Sum], Thm. 1)" followed by **normalization**, not
resolution. Only B, B', C use resolution, with "(see [Hir] and [B-M])" cited at case B.)

> Note that in all cases
> L(X, D; X′, D′) ⊂ B̄(X, D; X′, D′).
> (In cases B, B' and C we put D′ = 0.)
> Let S_0 ⊂ O_X(−D) ⊂ L(X, D; X′, D′) be the zero section divisor and S_∞ ⊂
> O_{X′}(D′)^∞ ⊂ L(X, D; X′, D′) be the infinity section divisor.
> Set
> B(X, X′) := B̄(X, D; X′, D′) \ S̄_0 \ S̄_∞.
> Then B(X, X′)_+ = {x ∈ B(X, X′) | lim_{t→∞} tx does not exist} = {x ∈ B(X, X′) ⊂
> B̄(X, D; X′, D′) : lim_{t→∞} tx ∈ S̄_0 ∪ S̄_∞} = {x ∈ B(X, X′) | lim_{t→∞} tx ∈ S̄_∞} =
> B(X, X′) ∩ S̄_∞^− = O_{X′}(D′)^∞ \ S_∞.
> Analogously B_−(X, X′) = O_X(−D) \ S_0.
> In both cases evidently B_+/K* ≃ X′ and B_−/K* ≃ X.

Boundary structure, Remark following the proof (p. 13):

> **Remark.** The above constructed cobordism B between X and X′ is of the form
> B̄ \ X′ \ X where B̄ is a complete variety with a K*-action such that X is its source
> and X′ is its sink. One can prove that each cobordism is of that form (see Lemma
> 7). This makes the analogy between birational cobordism and cobordism in Morse
> theory stronger.

Lemma 7 (p. 14) makes the boundary explicit:

> **Lemma 7. A.** Let B be a normal variety with a K*-action with no fixed points and
> such that the geometric quotient B/K* exists. Then there exists a normal variety
> B^0 = B ∪ (B/K*) (respectively B^∞ = B ∪ (B/K*)) with a K*-action such that
> B^0//K* ≃ B/K* ⊂ B^0 is a source in B^0 (respectively B^∞//K* ≃ B/K* ⊂ B^∞ is
> a sink in B^∞) and the standard projection B^0 → B^0//K* (resp. B^∞ → B^∞//K*)
> is given by x ∈ B^0 ⟶ lim_{t→0} tx (x ∈ B^∞ ⟶ lim_{t→∞} tx).
> **B.** Let B(X, X′) be a cobordism between X and X′. Then there exists a variety
> B̄(X, X′) = B(X, X′) ∪ X ∪ X′ = B(X, X′) ∪_{B(X,X′)_+} (B(X, X′)_+)^∞ ∪_{B(X,X′)_−}
> (B(X, X′)_−)^0 with source X and a sink X′. If X or X′ is complete than B̄(X, X′)
> is also complete.

*(paraphrase)* So the boundary `B̄ \ B` is exactly the two divisors `S̄_0` and `S̄_∞`, whose
non-boundary parts are the zero section over `X` and the infinity section over `X′`; in the
completed picture `X` is the source and `X′` the sink of `B̄`.

**Isomorphism locus of the resolution/completion: not stated explicitly anywhere in the proof of
Proposition 2.** The text says only "canonical K*-equivariant resolution" with the citations
[Hir], [B-M], and does not name a locus over which it is an isomorphism, nor assert that the
completion is an isomorphism over `L(X, D; X′, D′)` beyond the containment
`L(X, D; X′, D′) ⊂ B̄(X, D; X′, D′)` quoted above.

## (d) The common open subset and the cylinder

The cylinder enters as the *gluing locus* of `L`, Lemma 5 and Definition 8, p. 10.

> **Definition 8** ([Nag2]). Let X and X′ be birationally equivalent varieties with
> isomorphic open subsets X ⊃ U ≃ U′ ⊂ X′. Let ∆ : U → X × X′ be the
> induced morphism. By the join X ∗ X′ of X and X′ we mean the closed subvariety
> ∆̄(U) ⊂ X × X′.

> **Lemma 5.** Let D, D′ be effective Cartier divisors on X and X′ respectively such
> that
> V := X ∗ X′ \ (π^{−1}(supp(D)) ∪ π′^{−1}(supp(D′))) ⊆ U.
> Then the open embeddings:
> V × K* ⊂ O_X(−D) and
> V × K* ⊂ O_{X′}(D′)^∞.
> (obtained by the natural multiplication by the sections corresponding to D and D′)
> define the separated set
> L(X, D; X′, D′) := O_X(−D) ∪_{V×K*} O_X(D)^∞.

(The final displayed formula is as printed; the second summand is written `O_X(D)^∞` there while
the two embeddings above it and the rest of the paper use `O_{X′}(D′)^∞`.)

`E^∞` for a line bundle `E` with zero section `s_E` is defined on p. 9/10 as
`E^∞ := ((E \ s_E(X)) × (P^1 \ {0}))/K*` with `t(x, y) = (tx, t^{−1}y)`.

Triviality over an open set, Definition 3, p. 4–5:

> By a birational cobordism over Y between them we understand a
> cobordism B := B(X_1, X_2)/Y) with a K*-equivariant morphism φ : B → Y where
> Y is equipped with the trivial K*-action and such that the following diagrams commute:
> [B_+/K* ≃ X_1 over Y, B_−/K* ≃ X_2 over Y]
> We say that the cobordism B over Y is trivial over an open subset U ⊂ Y iff there
> exists an equivariant isomorphism φ^{−1}(U) ≃ U × K*, where the action of K* on
> U × K* is given by t(x, s) = (x, ts).

So the only *statement* of a cylinder is Proposition 2(C) ("trivial over U"); for (B') the
`V × K*` cylinder appears only inside the construction, as the gluing locus in Lemma 5, and the
text does not restate it as a property of `B(X, X′)` after completion and resolution.

## (e) GIT semistable loci, chambers, weights

**Absent from this eprint.** Searches over the full text for `semistable`, `semi-stable`, `GIT`,
`linearization`, `chamber`, `moment`, `Hilbert`, `stable` return no body-text occurrences: the
only hits are bibliography entries [Mum1] *Geometric invariant theory*, [Mum2], [Tha1]–[Tha3]
(including "Geometric invariant theory and flips"), and the introductory sentence (p. 1):

> The importance of K*-actions in birational geometry and their connection with Mori
> Theory were already discovered by Thaddeus, Reid and many others (see [Tha1],
> [Tha2], [Tha3], [R], [D,H]).

No Hilbert–Mumford-style characterization of `B_±`, no weights of fixed components, and nothing
about GIT chambers for the completion appears in the text.
