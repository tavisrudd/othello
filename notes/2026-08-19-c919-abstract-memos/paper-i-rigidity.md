# Paper I — clebsch-rigidity: abstract-replacement review

**Date:** 2026-08-19 · **Task:** C919 follow-up, external abstract proposal review (read-only)
**Target:** `papers/clebsch-rigidity/clebsch_rigidity.tex` (abstract at lines 42–72)

**Verdict:** The proposal is mathematically sound and already shorter than the current abstract (228 vs 257 words); every claim checks against the body, no undefined macros. Recommend a further-tightened 220-word variant below (inline math, `$…$` delimiters, merged proof/consequence paragraph) rather than the proposal verbatim.

## 1. Word counts

| Version                        | Words |
|--------------------------------|-------|
| Current abstract               | 257   |
| Proposal replacement           | 228   |
| Recommended (this memo, §5)    | 220   |

Note: the task framing said the proposals run long; for Paper I the proposal is actually 29 words *shorter* than the current abstract. The remaining win is stylistic (inline vs display math, one merged paragraph), not bulk.

## 2. Claim-by-claim check of the proposed replacement

All line references are to `/home/tavis/src/othello/papers/clebsch-rigidity/clebsch_rigidity.tex`.

1. **"projective deep-hole syndrome locus … equivalently the projective points lying on no chord."** Supported. Definition/dictionary: current abstract lines 43–45; redundancy-three MDS dictionary in the introduction, lines 115–121 (weight 1/2/3 by arc/secant/neither); arc–coset dictionary applied without GRS hypothesis at lines 887–891. The proposal reverses the paper's definitional order (paper defines the chord-free locus first, then identifies it); the equivalence itself is exactly the paper's dictionary, so either order is faithful.
2. **"lies on a conic iff projectively equivalent to the Clebsch hexagon; then exactly a nonsingular conic."** Supported verbatim by the Rigidity theorem, lines 141–151: (i) containment in some possibly degenerate conic ⟺ (ii) $\cU(A)$ exactly the $\F_{11}$-points of a nonsingular conic ⟺ (iii) PGL(3,11)-equivalence to the Clebsch hexagon.
3. **"recognition invariant for the non-GRS Clebsch code up to monomial equivalence."** Supported. Non-GRS: lines 878–885 (columns off every conic, determinant 3; dual-of-GRS argument). Projective equivalence of column sets ⟺ monomial equivalence of codes: lines 687–691. "Recognition" framing: introduction lines 88–91 ("output of a recognition theorem, not part of its input") and lines 202–204.
4. **"metric boundary recovers the parity-check geometry, after which the conic determines its polarity and Dye's theorem identifies the stabilizer as $A_5$."** Supported: proof text line 668 ("Dye's stabilizer theorem identifies the stabilizer with $A_5$"); polarity via the five self-polar triangles, line 318; overview lines 159–167.
5. **"Decoder multiplicities … Brianchon points, self-polar triangles, intrinsic bipartition of the three-coordinate supports."** Supported: Corollary "The decoder reconstructs the Brianchon configuration", lines 1278–1285; Proposition "Invariant support bipartition", lines 1294–1311 (also ties the bipartition to the self-polar triangles and Brianchon points); ambiguity-strata summary lines 162–164; complete syndrome oracle lines 1092–1113.
6. **"Nearest-codeword ambiguity then recovers an unordered orientation torsor on six axes."** Supported: Theorem "Support cubic and golden continuation", lines 1396–1445 ("The syndrome locus reconstructs an unordered orientation torsor…").
7. **"$B^2=5I$", "$c_{ijk}=B_{ij}B_{jk}B_{ki}$", "sole nonsymmetric term in the diagonal determinant pencil."** Supported: theorem lines 1412–1431 (boxed identities; "the support cubic is the sole nonsymmetric term in the diagonal determinant pencil of the golden operator").
8. **"decoder data recover … the golden orientation and the integral quadratic order $\mathbf Z[B]\simeq\mathbf Z[\sqrt5]$."** Supported: Corollary "Nodes, symmetry, and integral commutant", lines 1447–1466 ($\operatorname{End}_{\mathbf Z A_5}(L^-)=\mathbf Z[B]\cong\mathbf Z[\sqrt5]$); conclusion lines 1979–1980 ("decoder support data recover a nontrivial integral endomorphism order"). Switching "coset-leader ambiguity" (current) to "decoder data" (proposal) is a faithful loosening, not a strengthening.
9. **"universal chord-defect identity and a partial-cover bound."** Supported: Theorem "Universal chord defect", lines 437–454; partial-cover use in the window theorem's proof, lines 730–739; conclusion lines 1953–1955.
10. **Uniform $k$-arc consequence: $q$ odd, $2k-3\le q\le(k(k-1)+3)/3$; fixed $k$ ⇒ finitely many field orders.** Supported verbatim: Theorem "Conic-filling window and six-arcs", lines 704–716 (including "$q$ is odd" from the even-$q$ nucleus argument at lines 736–739); conclusion lines 1953–1959. "All-field conic-filling existence problem" is a faithful (and better standalone) name — conclusion line 1959 and lines 1965–1966 use exactly the conic-filling framing.

**Nothing in the proposal is strengthened beyond the theorems.** Nothing load-bearing is dropped. Two deliberate drops, both acceptable:

- **"none of this geometry is assumed"** (current lines 52–53). Emphasis, not a scope qualification; "recognition invariant" plus "recovers" already carries the inverse-statement point, and the introduction states it at lines 136–139. Acceptable cut.
- **"secondary"** before "uniform consequence" (current line 68; body line 182 calls it "a secondary general theorem"). Mild promotion of the window theorem's billing. My version restores the subordination implicitly by deriving it from the rigidity proof's tools ("which give a uniform consequence").
- **"decoder ambiguity and the orbital pentagon for orientation"** (current line 67). Proof-method detail only; the orbital pentagon is a proof stage (line 1470, 1476–1479), not an advertised claim. Acceptable cut.

## 3. Macro check (this paper's preamble, lines 28–32)

Defined: `\PG` (line 28), `\F` (line 29), `\cC` (line 30), `\cU` (line 31), `\A` (line 32).

The proposed Paper I abstract uses only `\PG`, `\cU`, `$A_5$` (literal), `\mathbf Z`, `\frac` — all fine. **However:** the proposal's global style note lists `\PGL` and `\PP` as macros to preserve; **neither is defined in this paper** (the body writes `\mathrm{PGL}(3,11)` literally, e.g. line 149). Not a problem for the Paper I block as written, but any hand-edit introducing `\PGL` or `\PP` here would fail to compile. Also cosmetic: the proposal uses `\( \)`/`\[ \]` delimiters while the entire manuscript uses `$ … $`; and it puts the window bound in display math, which the current abstract keeps inline — display math in the abstract eats title-page vertical space (the proposal's own style instruction 6 asks to avoid layout regressions).

## 4. Judgment on the proposal's red-team notes

All six notes are correct; one is stricter than it needs to be.

1. *Dictionary equivalence safe* — right (lines 115–121, 887–891).
2. *Recognition invariant up to monomial equivalence matches conclusion/introduction* — right (lines 687–691, 88–91).
3. *"Abstract does not claim the syndrome locus alone supplies all orientation information"* — the caution is safe but over-conservative: Theorem line 1398 literally opens "The syndrome locus reconstructs an unordered orientation torsor", and presentation (ii) (lines 1407–1418) builds $B$ from the locus's five-valent orbitals alone. The *support-sign* presentation and the Brianchon/bipartition data do need decoder multiplicities, so "decoder data" remains the right umbrella for the paragraph's full claim list. No change needed.
4. *Integral order from orientation/support data, not bare conic* — right (lines 1447–1466, 1979–1980).
5. *Do not strengthen "lies on a conic" to "is a conic"* — right and important: hypothesis (i) is containment in a possibly degenerate conic (lines 132–134, 144–146); equality and nonsingularity are the conclusion (ii).
6. *Keep the uniform $k$-arc consequence* — right; it is the paper's only field-uniform theorem (lines 704–716) and the conclusion leads with it (lines 1953–1959).

## 5. Recommended abstract (paste-ready)

220 words. Differences from the proposal: house `$…$` delimiters; window bound kept inline (protects page-1 layout); definitional order restored to the paper's own (chord-free locus first, deep-hole identification as apposition — saves the "equivalently" clause); proof-method sentence merged with the uniform consequence so the window theorem reads as a byproduct of the rigidity tools, preserving the body's "secondary" billing without the word.

```latex
\begin{abstract}
Let $A$ be a six-arc in $\PG(2,11)$ and let $\cU(A)$ be the projective
points on no chord of $A$: the projective deep-hole syndrome locus of the
associated $[6,3,4]_{11}$ MDS code.  We prove that $\cU(A)$ lies on a conic
if and only if $A$ is projectively equivalent to the Clebsch hexagon, and
then $\cU(A)$ is exactly a nonsingular conic.  The deep-hole locus is thus
a recognition invariant for the non-GRS Clebsch code up to monomial
equivalence: its metric boundary recovers the parity-check geometry, the
conic determines its polarity, and Dye's theorem identifies the stabilizer
as $A_5$.  Decoder multiplicities further recover the Brianchon points, the
self-polar triangles, and an intrinsic bipartition of the three-coordinate
supports.

Nearest-codeword ambiguity then recovers an unordered orientation torsor on
six axes.  Its signed orbital operator satisfies $B^2=5I$, and triangle
holonomy gives the support cubic $c_{ijk}=B_{ij}B_{jk}B_{ki}$, the sole
nonsymmetric term in the diagonal determinant pencil of $B$.  The decoder
data thus recover not only incidence and symmetry but the golden
orientation and the integral quadratic order
$\mathbf Z[B]\simeq\mathbf Z[\sqrt5]$.

The rigidity proof rests on a universal chord-defect identity and a
partial-cover bound, which give a uniform consequence: any $k$-arc whose
uncovered locus is a nonsingular conic has $q$ odd and
$2k-3\le q\le(k(k-1)+3)/3$, so for each fixed $k$ the all-field
conic-filling existence problem reduces to finitely many field orders.
\end{abstract}
```

**What I cut and why.**
- "none of this geometry is assumed" — emphasis already carried by "recognition invariant"/"recovers"; stated in the introduction (lines 136–139).
- "Thus the same syndrome and support data recover both the code and its golden orientation" (current lines 61–62) — the exact repetition the proposal targets; the closing sentence of paragraph two carries it.
- "decoder ambiguity and the orbital pentagon for orientation" — proof staging, not a claim.
- "equivalently" framing of the pencil identity compressed to an apposition — the equivalence itself (theorem lines 1424–1431) is retained as "the sole nonsymmetric term…".
- Display math for the window bound — inline preserves title-page balance; identical formula.

**What I refused to cut.**
- The containment-vs-equality asymmetry ("lies on a conic" hypothesis, "exactly a nonsingular conic" conclusion) — theorem structure, lines 143–150.
- "non-GRS" and "up to monomial equivalence" — the coding-theoretic scope of the recognition claim (lines 687–691, 878–885).
- The full decoder-recovery list (Brianchon, self-polar triangles, bipartition) — each is a stated corollary/proposition (lines 1278–1311).
- The determinant-pencil characterization — a boxed theorem identity (lines 1427–1431).
- The uniform $k$-arc window with both bounds, $q$ odd, and the finiteness consequence — the paper's field-uniform theorem (lines 704–716); per red-team note 6 it keeps the abstract from reading as a $q=11$-only classification.
- The integral quadratic order $\mathbf Z[B]\simeq\mathbf Z[\sqrt5]$ — corollary lines 1460–1465 and the conclusion's final claim (lines 1979–1980).

## 6. Separate manuscript issues (not fixed; report only)

1. **Stale label prefixes on two theorems:** the Universal chord defect *Theorem* carries `\label{lem:chord-defect}` (line 438) and the Conic-filling window *Theorem* carries `\label{cor:conic-filling-window}` (line 705). Harmless to compilation and cross-references, but the prefixes misdescribe the environments — presumably left over from promotions. Any prose that says "Lemma/Corollary" near a `\ref` to these should be double-checked if the labels are ever renamed.
2. **Minor delimiter inconsistency risk:** the proposal's blocks use `\(…\)`/`\[…\]` while the manuscript is uniformly `$…$`; if any proposal text is pasted verbatim elsewhere, it will introduce mixed math-delimiter style.
