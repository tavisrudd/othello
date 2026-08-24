# C925: Tschinkel--Zhang priority-judo synthesis

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Verdict

The level-two theorem yields two solid consequences beyond merely lowering a
numerical bound.

1. **The four-type stable-rationality application is quantitatively
   subsumed.** For every quartic del Pezzo surface in the
   Tschinkel--Zhang \(I_0,I_1,I_2,I_3\) setting,

   \[
   S\times\mathbf A^2\text{ is rational}.
   \]

   Hence the four-type stable-rationality implication in their Corollary 4.3
   and the conclusions of Propositions 5.1 and 5.2 are corollaries. This does not
   subsume their universal-torsor rationality theorem: the proof uses their
   OADP Lemma 3.2 and tangent-projection Theorem 2.4 as inputs.

2. **Their stated birational \(\mathbf A^1\)-cancellation construction
   problem gets identified answers.** The Proposition 5.1 example is

   \[
   (x_4-2x_3)x_1^2+3(x_4+2x_3)x_2^2
   +3x_3^2x_4-x_4^3+x_5^3=0,
   \]

   The Proposition 5.2 example is

   \[
   x_4(x_1^2+2x_1x_2)+x_3(x_1^2+x_1x_2+x_2^2)
   +x_3^3-x_3^2x_4+x_4^3+2x_5^3=0.
   \]

   For either explicit cubic threefold \(X/\mathbf Q\), \(Y=X\times\mathbf P^1\)

   is smooth projective and nonrational, while

   \[
   Y\times\mathbf A^1
   \]

   is rational. Nonrationality is the C925 \(m=1\) theorem after base change
   to \(\mathbf C\); rationality follows from
   \(\mathbf Q(Y\times\mathbf A^1)=\mathbf Q(X\times\mathbf P^2)\).
   These are explicit smooth projective fourfold counterexamples to
   birational \(\mathbf A^1\)-cancellation.

The first consequence is the clean general-theorem judo. The second is the
strongest direct implication relative to the new paper's own list of open
questions.

## Structural theorem

The mechanism is the higher-rank unimodular-window OADP quotient theorem.
For a generically free rank-\(r\) torus action on an OADP variety, a descended
tangent codimension-\(r\) section leaving \(r+1\) weight blocks whose
differences form a lattice basis is a rational one-point quotient slice.

The type-\(I_1\) three-sign subtorus has such a window only after saturating
its cocharacter lattice. The residual quotient torus has rank two and is
rational. This separates the reusable theorem from the special Cox-weight
calculation and makes future applications to other torsors possible.

## Further implications

- Both explicit cubics have exact stabilization threshold \(s(X)=2\) over
  both \(\mathbf Q\) and \(\mathbf C\).
- All four quartic-del-Pezzo types have stabilization level at most two,
  improving the uniform eleven-dimensional construction in
  Tschinkel--Zhang's “Levels of stable rationality” paragraph.
- The full-\(I_3\) saturated subtorus restricts to \(I_0,I_1,I_2\), so the
  same theorem treats the complete four-type list uniformly.
- Any every-smooth \(m=2\) cubic-threefold irrationality theorem is false.
  A quantum obstruction at level two must exclude the type-\(I_1\) family or
  detect a hypothesis that fails there.

## Source audit and exact scope

Zero sources were read at full-text depth; one source was read at partial
depth:

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1, submitted 2026-08-20.
  **Read depth: partial** — cached PDF key arXiv:2608.20029, SHA-256
  be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6;
  read Theorem 2.4, Lemma 3.2, Theorem 3.4, Corollary 3.5, Proposition 4.1,
  Lemma 4.2, Corollary 4.3, the “Levels of stable rationality” paragraph, and
  Proposition 5.1 with proof.

The source explicitly states that constructing a nonrational \(Y\) with
\(Y\times\mathbf A^1\) rational remains open. The identified \(Y\) above is
therefore a direct answer relative to that source.

A bounded web screen on 2026-08-24 used the exact queries

- "It remains open to construct a nonrational variety" "A1" rational;
- "nonrational variety" "times A1" rational stable rationality;
- arXiv 2608.20029 DOI Tschinkel Zhang universal torsors quartic del Pezzo;
- "unimodular" torus quotient OADP variety tangent projection.
- site:arxiv.org algebraic variety "A1" "nonrational" rational cancellation;
- site:zbmath.org nonrational variety affine line rational stable rationality;
- site:projecteuclid.org nonrational variety product affine line rational;
- site:arxiv.org OADP torus quotient tangent projection rational.

The two screens returned 45 displayed results in total. Titles and snippets
were screened for either (a) birational rationality of a nonrational
\(Y\times\mathbf A^1\), or (b) an OADP tangent section giving a rational torus
quotient from a unimodular weight window. No result met either discriminator.
This was only a bounded title/snippet screen, not a full novelty audit;
MathSciNet, a systematic zbMATH query, and the three forward-citation graphs
were not closed. Accordingly this report makes no global first-priority
claim.

The forward-citation probe used the pinned DOI on 2026-08-24:

- OpenAlex resolved it to W7203907824 and returned
  cited_by_count \(=0\); the successful JSON response distinguished an empty
  citing set from an error.
- Crossref's exact DOI endpoint returned HTTP 404, so Crossref supplied no
  citing-set count.
- Semantic Scholar's exact arXiv endpoint returned HTTP 429, so Semantic
  Scholar supplied no citing-set count.

Because only one of the three required graphs returned a count, this licenses
no forward-citation-closure claim.

As of the same check, the only DOI located for the new paper is the arXiv
DataCite DOI

\[
\texttt{10.48550/arXiv.2608.20029}.
\]

No publisher DOI was located.

## Evidence

- theorem and certificates:
  notes/2026-08-24-c925-uniform-level-two-rationality.md;
- general quotient theorem:
  notes/2026-08-24-c925-adjacent-weight-oadp-quotient-theorem.md;
- corrected saturation record:
  notes/2026-08-24-c925-rank-three-boundary-peeling-frontier.md.

## Mystery ledger

| status | feature | evidence or remaining gate |
|---|---|---|
| settled | Does the result do more than lower \(m\)? | Yes: identified cancellation example and stronger type-\(I_1\) theorem. |
| settled | Which TZ statements become corollaries? | Four-type Corollary 4.3 implication and Propositions 5.1--5.2 stable rationality. |
| settled | Does it subsume TZ torsor rationality? | No; their OADP results are inputs. |
| open | Global priority | Full database and citation-graph audit. |
| settled | Types \(I_2,I_3\) at level two | Full-\(I_3\) saturated rank-three window. |
