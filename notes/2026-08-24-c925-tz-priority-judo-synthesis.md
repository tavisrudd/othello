# C925: Tschinkel--Zhang priority-judo synthesis

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Verdict

The level-two theorem yields two solid consequences beyond merely lowering a
numerical bound.

1. **The type-\(I_1\) stable-rationality application is quantitatively
   subsumed.** For every type-\(I_1\) quartic del Pezzo surface in the
   Tschinkel--Zhang setting,

   \[
   S\times\mathbf A^2\text{ is rational}.
   \]

   Hence the type-\(I_1\) part of their Corollary 4.3 and the stable
   rationality conclusion of Proposition 5.1 are corollaries. This does not
   subsume their universal-torsor rationality theorem: the proof uses their
   OADP Lemma 3.2 and tangent-projection Theorem 2.4 as inputs.

2. **Their stated birational \(\mathbf A^1\)-cancellation construction
   problem gets a single identified answer.** For the explicit cubic
   threefold \(X/\mathbf Q\) in Proposition 5.1,

   \[
   (x_4-2x_3)x_1^2+3(x_4+2x_3)x_2^2
   +3x_3^2x_4-x_4^3+x_5^3=0,
   \]

   \[
   Y=X\times\mathbf P^1
   \]

   is smooth projective and nonrational, while

   \[
   Y\times\mathbf A^1
   \]

   is rational. Nonrationality is the C925 \(m=1\) theorem after base change
   to \(\mathbf C\); rationality follows from
   \(\mathbf Q(Y\times\mathbf A^1)=\mathbf Q(X\times\mathbf P^2)\).

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

- The explicit type-\(I_1\) cubic has exact stabilization threshold
  \(s(X)=2\) over both \(\mathbf Q\) and \(\mathbf C\).
- The type-\(I_1\) quartic-del-Pezzo stabilization level is at most two,
  improving the uniform eleven-dimensional construction in
  Tschinkel--Zhang's “Levels of stable rationality” paragraph.
- The old type-\(I_0\) level-two result and the new type-\(I_1\) theorem now
  place both types at level at most two; types \(I_2\) and \(I_3\) remain the
  natural quantitative frontier.
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

The returned results contained no direct predecessor for either the
identified cancellation example or the unimodular-window theorem. This was
only a bounded title/snippet screen, not a full novelty audit; MathSciNet,
zbMATH, and the three forward-citation graphs were not closed. Accordingly
this report makes no global first-priority claim.

As of the same check, the only DOI located for the new paper is the arXiv
DataCite DOI

\[
\texttt{10.48550/arXiv.2608.20029}.
\]

No publisher DOI was located.

## Evidence

- theorem and certificates:
  notes/2026-08-24-c925-type-i1-level-two-rationality.md;
- general quotient theorem:
  notes/2026-08-24-c925-adjacent-weight-oadp-quotient-theorem.md;
- corrected saturation record:
  notes/2026-08-24-c925-rank-three-boundary-peeling-frontier.md.

## Mystery ledger

| status | feature | evidence or remaining gate |
|---|---|---|
| settled | Does the result do more than lower \(m\)? | Yes: identified cancellation example and stronger type-\(I_1\) theorem. |
| settled | Which TZ statements become corollaries? | Type-\(I_1\) Corollary 4.3 application and Proposition 5.1 stable rationality. |
| settled | Does it subsume TZ torsor rationality? | No; their OADP results are inputs. |
| open | Global priority | Full database and citation-graph audit. |
| open | Types \(I_2,I_3\) at level two | Requires new invariant subtori or quotient geometry. |
