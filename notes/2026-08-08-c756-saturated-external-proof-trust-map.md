# C756 — saturated-external proof-trust map

**Lane**: `clebsch` · **Date**: 2026-08-08 · **Scope**: proof audit and
publication triage; no manuscript edits

## Verdict

The saturated-external classification survives an end-to-end claim audit, and
its strongest clean form does not mention conic-filling:

> Let \(q\) be odd, let \(C\) be a nonsingular conic in
> \(\mathrm{PG}(2,q)\), and let \(A\) be an exterior set of \(C\) consisting
> of \((q+1)/2\) exterior points.  If \(A\) is an arc, then
> \(q\in\{3,7,11\}\).  For \(q>3\), both \(q=7\) and \(q=11\) occur, with
> one orbit under the conic stabilizer in each field.

If the secants of \(A\) must additionally cover every point off \(C\), the
\(q=3,7\) cases fail and \(q=11\) gives the Clebsch hexagon.  Thus the
conic-filling theorem is a corollary of a broader extremal exterior-arc
classification.

The proof is all-field and human-readable; finite computation is not used to
deduce the theorem.  Its former four-report chain is now consolidated in
`2026-08-08-c756-saturated-exterior-consolidated-proof.md`.  The load-bearing
primitive-Jacobi line audit repaired its suppressed valuation normalization
and found no mathematical gap, and the exact Segre, Stickelberger, Weil, and
Hasse citations are installed at their points of use.  The mathematical and
citation gates therefore pass; a cold specialist read and the remaining human
MathSciNet/Scopus novelty check are the pre-allocation safeguards.

One fresh extension-field check was replayed at \(q=27\).  It exactly
reproduced the committed all-\(k\) certificate row: \(k_{\min}=9\),
\(m(q)=9\), and no conic-filling arc.  This is an independent finite audit of
the theorem's first unsearched-looking extension-field regime, not a substitute
for the proof.

## 1. Claim-to-proof map

The consolidated proof is
`2026-08-08-c756-saturated-exterior-consolidated-proof.md`, §§1--7.  The
locations below retain the discovery provenance of each step for forensic
review; they are no longer the reader-facing dependency chain.

| step | exact claim | proof location | trust and publication action |
|---|---|---|---|
| A0 | An exterior set of \((q+1)/2\) exterior points that is an arc exhausts the passant pencil at every one of its points; its disjoint tangent pairs therefore form the saturated perfect matching | immediate from the point/line counts used around Lemma 3 of `2026-08-01-c756-all-k-conic-filling.md` | free two-line geometric lemma; put it before the algebra so the headline theorem no longer depends on the covering dictionary |
| A | Saturation forces one of two matching geometries; the external type has \((q+1)/2\) exterior points paired by the passant pencil | `2026-08-01-c756-all-k-conic-filling.md`, Lemma 3 and saturation discussion | elementary incidence proof; consolidate definitions and distinguish exterior points from external/passant lines |
| B | Normalizing a fixed matching edge converts the remaining matching to a permutation of the cyclic square group, and fixed-edge triple determinants make it a complete mapping | `2026-08-01-c756-saturated-matching-attack.md`, §§1–2 | direct determinant calculation; referee should check normalization at \(q=3\) and that every denominator is nonzero |
| C | If \(q\equiv1\pmod4\), no such complete mapping exists because the square group has even order | same report, Proposition 1 | one-line group-sum obstruction; no computation or external theorem |
| D | If \(q\equiv3\pmod4\), Segre's lemma of tangents forces all resultant signs to cohere, so the matching permutation is an automorphism of the Paley tournament induced on the nonzero squares | `2026-08-01-c756-segre-tangent-coherence.md`, Proposition 1 | human proof; load-bearing classical input is Segre's lemma.  Consolidation must state its hypotheses and fix tangent-function scalings explicitly |
| E | Every automorphism of the Paley tournament induced on \(S\) commutes with its single signed adjacency operator \(B\); primitive-character noncollision plus the Frobenius-Sidon property implies that it is \(s\mapsto c s^{p^j}\) | `2026-08-01-c756-paley-bispectral-reduction.md`, §4, one-block rigidity, plus the primitive-collision report | linear algebra plus multiplicative Fourier transform; the second matrix \(C\), anticommutator, and skew square-root machinery are not needed in the final proof |
| F | For conductor \(m=(p^n-1)/2\), equality of the relevant primitive Jacobi values occurs exactly along Frobenius orbits | `2026-08-01-c756-primitive-jacobi-collisions.md`, §§1–3 | line audit passed after equations (3a)--(3b) made the prime choice and the \(p-1\) ramification normalization explicit |
| G | Every nonidentity Frobenius exponent \(j>0\) contradicts a coset character-sum bound | `2026-08-01-c756-segre-tangent-coherence.md`, Proposition 2 | human proof.  The subgroup-size lower bound is elementary; the three-support-point multiplicative Weil bound is standard but needs a precise citation and a clean statement covering all characters in the expansion |
| H | In the scalar branch, a genus-one character sum and Hasse leave \(q\in\{3,7,11\}\); the scalar constructions realize those values.  The covering condition then removes \(q=3,7\), and \(q=11\) is the Clebsch hexagon | `2026-08-01-c756-saturated-matching-attack.md`, Proposition 2 and its endgame | human proof with standard Hasse input; reproduce the small-field endpoint and existence checks directly in the paper rather than citing a certificate |

The dependency chain is

\[
 \text{extremal exterior arc}\Rightarrow\text{saturated matching}\Rightarrow
 \begin{cases}
   \text{even square-group order}\Rightarrow\bot,&q\equiv1\pmod4,\\
   \text{Segre coherence}\Rightarrow\text{local Paley automorphism}
   \Rightarrow\text{Jacobi/Frobenius rigidity}
   \Rightarrow\text{scalar Hasse endgame},&q\equiv3\pmod4.
 \end{cases}
\]

For the conic-filling corollary, Lemma 3 supplies the extremal exterior arc;
for the broader theorem, Step A0 supplies the matching directly and covering
is used only at the final endpoint.  No step invokes the finite classifications
below.  Conversely, the certificate does not verify the character-theoretic
collision theorem.

### 1.1 Endpoint orbit closure

The scalar endgame is stronger than the field bound alone.  With the
normalization \(\phi(s)=ns\), direct substitution in
\[
 \chi((r-n)(nr-1))=+1\qquad(r\in S\setminus\{1\})
\]
gives:

| \(q\) | admissible nonsquare \(n\) | action of \(x\mapsto x^{-1}\) |
|---:|---|---|
| \(7\) | \(3,5\) | \(3\leftrightarrow5\) |
| \(11\) | \(2,6\) | \(2\leftrightarrow6\) |

Inversion belongs to the conic stabilizer, fixes the normalized edge
\(\{0,\infty\}\), and sends \(n\) to \(n^{-1}\).  Thus the two normalized
parameters form one orbit in each field.  The \(q=7\) orbit is the
noncovering exterior four-arc; the \(q=11\) orbit is the Clebsch hexagon.
The \(q=3\) two-point case is degenerate and unique.

This endpoint table should be checked inline in the consolidated proof.  It
needs neither a new search nor a certificate.

### 1.2 Hidden master theorem: the local Paley automorphism group

The hard arithmetic step proves a standalone graph theorem.  Let
\(q=p^n\equiv3\pmod4\), let \(P(q)\) be the Paley tournament, and let
\(S=(\mathbb F_q^*)^2\), the out-neighbourhood of \(0\).  Then
\[
 \operatorname{Aut}(P(q)[S])
 =
 \{\,s\mapsto c s^{p^j}:c\in S,\ 0\le j<n\,\}
 \cong S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p).
\]
The \(q=3\) singleton case is interpreted trivially.

The forward inclusion has a three-lemma proof:

1. a local tournament automorphism commutes with the signed adjacency
   convolution \(B\), so it carries a faithful character into the eigenspace
   with the same eigenvalue;
2. the primitive-Jacobi collision theorem says that this eigenspace is exactly
   the span of the Frobenius conjugates;
3. those Frobenius exponents are Sidon modulo \((q-1)/2\), and the pullback of
   a character has pointwise modulus one, so its Fourier support has one term.

Faithfulness then gives \(s\mapsto c s^{p^j}\).  The reverse inclusion is
immediate from
\(\chi(c(t-s)^{p^j})=\chi(t-s)\).

Equivalently, every automorphism of the tournament induced on the
out-neighbours of a vertex extends uniquely to the semilinear automorphism
\(x\mapsto c x^{p^j}\) of the full Paley tournament fixing that vertex.
This local-to-global extension form is the cleanest conceptual statement.

This theorem uses neither resultants, complete mappings, Segre coherence,
general position, nor covering.  Those ingredients are only the geometric
pipeline that manufactures a local Paley automorphism and then restricts its
semilinear parameters.  The theorem is therefore the most transferable output
of C756.  The subsequent focused audit in
`2026-08-08-c756-local-paley-rigidity-literature-audit.md` found no predecessor
for this exact automorphism group or its unique local-to-global extension
form.  The closest local predecessor, Javier--Llano--Zuazua (2026), proves
only the prime-field multiplicative-circulant model.  The candidate novelty is
therefore qualified by the remaining MathSciNet/Scopus coverage gap.

### 1.3 EJ2: the general one-block Cayley criterion

The Sidon step abstracts completely from Paley tournaments.

**Flat Sidon lemma.**  Let \(G\) be a finite abelian group, let
\(\Lambda\subset\widehat G\) have distinct nonzero ordered differences, and
write
\[
 F=\sum_{\lambda\in\Lambda}a_\lambda\lambda.
\]
If \(|F(x)|\) is constant on \(G\), then at most one coefficient
\(a_\lambda\) is nonzero.

Indeed, every nontrivial Fourier coefficient of \(|F|^2\) is a single product
\(a_\lambda\overline{a_\mu}\), because the ordered difference
\(\lambda\mu^{-1}\) has a unique representation.  Constancy makes every such
coefficient zero.

This gives a general cyclic-Cayley rigidity criterion.  If a Cayley digraph on
a cyclic group \(G\) has a faithful character \(\rho\) whose adjacency
eigenvalue collision class \(\Lambda\) is Sidon, then every graph automorphism
pulls \(\rho\) into a constant-modulus vector in
\(\operatorname{span}\Lambda\), hence into a single character line.  After a
translation, faithfulness forces the automorphism to be a group multiplier
belonging to that collision class.  Thus one eigenblock can determine the
whole automorphism group without simple spectrum.

For the Paley first subconstituent, \(G=S\), the collision class is
\(\{\rho^{p^j}\}\), and the special inequality
\(|p^i-p^j|<(q-1)/2\) makes it Sidon.  Three exact corollaries follow:

1. \(P(q)[S]\) is a normal Cayley tournament on the cyclic group \(S\), with
   automorphism group of order \(n(q-1)/2\);
2. when \(q\) is prime, its automorphism group is the regular cyclic group
   \(S\), so it is a directed regular representation of \(S\);
3. a faithful primitive eigenblock contains, up to scalar, exactly its
   Frobenius character lines as flat vectors.  Hence it reconstructs the
   cyclic coordinate on \(S\) up to translation and Frobenius.

The flat Sidon lemma is likely standard harmonic-analysis folklore and should
be presented as a reusable proof device, not claimed as new without a source
check.  The exact Paley DRR/normal-Cayley consequences belong in the focused
predecessor audit.  Generalization to other cyclotomic or Peisert local graphs
is a possible successor only after the C756 publication gate; it is not a new
frontier for this task.

## 2. Proof-trust risks

### 2.1 Former highest risk: primitive Jacobi collision

The new lemma is stronger than the theorem needs: a primitive Jacobi value
cannot collide with an imprimitive character, and its complete collision class
is its Frobenius orbit.  The proof translates Stickelberger valuations into a
binary half-carry profile, sums dyadic iterates to recover base-\(p\) digit
weight, and uses the test multipliers \(1\) and \((p+1)/2\) to force a power of
\(p\).  That economy is a strength, but it is also the least standard link.

The subsequent audit in
`2026-08-08-c756-local-paley-proof-consolidation-and-jacobi-audit.md`
checked each of those seams.  It found one major exposition defect and no
mathematical failure: the old report suppressed the cyclotomic prime and the
\(p-1\) ramification factor.  Equations (3a)--(3b) of the repaired collision
report now derive the half-carry valuation from the standard base-\(p\)
digit-sum formula.  Nonunits, rotations, the test multiplier, inverse
collisions, and unique extension all pass.  A specialist cold read remains
desirable before submission, but this is no longer an identified proof gap.

### 2.2 Classical inputs that need exact citations

The consolidated proof should state and cite, rather than merely name:

1. Segre's lemma of tangents in the odd-order planar-arc form actually used;
2. the Gauss/Jacobi product identity and the exact Stickelberger valuation
   formula with the chosen normalization;
3. the multiplicative-character Weil bound for three distinct support points;
4. Hasse's bound for the nonsingular cubic in the scalar endgame.

Exact installation targets are now recorded: Ball--Lavrauw, Lemma 11, DOI
`10.1016/j.jcta.2018.06.015`; Evans--Hollmann--Krattenthaler--Xiang,
Theorem 3.4 and (3.2), DOI `10.1006/JCTA.1998.2950`;
Lidl--Niederreiter, Theorem 5.41, DOI
`10.1017/CBO9780511525926`; and Hasse, DOI
`10.1515/crll.1936.175.55`.  The remaining action is to install
them in the consolidated geometric proof, not to search for the statements.

### 2.3 Integration risks

- The archive alternates among “external,” “exterior,” and “passant.”  The
  paper should reserve **exterior point** for point type, **passant line** for a
  line disjoint from the conic, and **exterior set of a conic** for the
  pairwise-join property.
- The bispectral report first presents simple spectrum as a partial result;
  the later one-block proposition plus the Jacobi-collision report is what
  removes that hypothesis.  A consolidated proof must not inherit the earlier
  conditional wording.
- The theorem is only the saturated-exterior branch.  Saturated-internal and
  nonsaturated fillings remain open and must not be swept into its conclusion.
- The \(q=3\) normalization and the \(q=7\) noncovering endpoint should be
  handled explicitly even though they are computationally trivial.

## 3. Reproducibility replay

From the repository root, the committed matching certificate passed:

```sh
python3 notes/2026-08-01-c756-saturated-matching-analysis.py \
  --check notes/2026-08-01-c756-saturated-matching-analysis.json
```

The explicit extension-field audit used:

```sh
python3 notes/2026-08-01-c756-all-k-conic-filling.py \
  --q 27 --out /tmp/persistent/tavis/c756-q27.2j6iUT/q27.json
```

Its sole row is byte-semantically equal, after JSON parsing, to the \(q=27\)
row of the committed full certificate:

```json
{
  "conic_filling": [],
  "excluded_by_counting": false,
  "kmin": 9,
  "kmin_line": 9,
  "kmin_lp": 9,
  "m_q": 9,
  "n_conic_filling": 0,
  "q": 27
}
```

Evidence hashes at replay time:

| artifact | SHA-256 |
|---|---|
| `2026-08-01-c756-all-k-conic-filling.py` | `51fc9df59502d7669a147e7ade5ce47137cf2514948ed79b179171f15a39da99` |
| `2026-08-01-c756-all-k-conic-filling.json` | `5c9b62c2e9a5ea942a5d8c0f438b62827e852235b90397dc715d4d892ef2ba4b` |
| fresh \(q=27\) JSON | `9a54fef298e9a0a09c0136bbbc987ae606cf3b313552f1a8b9c01ab43bfdc9d6` |
| `2026-08-01-c756-saturated-matching-analysis.py` | `de2e6022767e92f4256e3ffd92e51a68812ce81a7a94e825a346ca669916e711` |
| `2026-08-01-c756-saturated-matching-analysis.json` | `6a0ae705337791d4910dacd955c8f436e22bf9d4fb55197a8263bc56edc6485e` |

The finite evidence supports the integration audit and guards against a hidden
small extension-field exception.  Publication claims should still label the
all-\(q\) theorem as proved by Steps A–H, not “computer verified.”

## 4. Publication decision and next action

The mathematical proof-trust and citation gates are **passed**: no logical
hole was found, the extension-field replay agrees, the primitive-Jacobi seam
was repaired and audited, and Steps A0--H plus the endpoint orbit check now
appear in one theorem-proof document with exact citations.

The highest-value next pass is a cold specialist/referee read of that
consolidated document, especially the Segre normalization and the
Stickelberger half-carry derivation.  In parallel, a human MathSciNet/Scopus
check should test the qualified local-Paley novelty claim.  If no defect or
predecessor appears, allocate a separate unnumbered companion-paper task with
a frozen claim inventory.  Do not draft under C756, return to theta fitting,
or run another finite-field sweep.

## 5. EJ + TT closeout

**EJ.**  The main free strengthening is theorem-level.  An exterior set of
\((q+1)/2\) exterior points that is an arc already exhausts the passant pencil
at each point and yields the perfect matching.  The proof therefore classifies
these extremal exterior arcs before covering is imposed: only
\(q\in\{3,7,11\}\) occur, and covering then selects the Clebsch case at
\(q=11\).  This removes the bespoke conic-filling condition from the headline
and connects the result directly to the established exterior-set literature.

A second free strengthening is conceptual: the all-field classification does
not require simple spectrum of the local Paley matrix or classification of all
Jacobi blocks.  One faithful primitive block, together with the exact collision
lemma, forces the entire local automorphism to be multiplication followed by
Frobenius.

**TT.**  The archive hid its best reusable theorem inside the matching proof:
the exact automorphism group of the Paley first subconstituent.  Lead the hard
part with the single operator \(B\), one faithful eigenspace, the exact Jacobi
collision class, and the Sidon/unit-modulus argument.  The second operator
\(C\), anticommutator, skew square root, simple-spectrum branch, and
Gaussian/Pfaffian obstruction are discovery scaffolding, not final proof.

The resulting paper has a clean two-layer spine: first a standalone
local-to-global Paley rigidity theorem; then an exterior-arc application in which elementary
matching reduction, Segre coherence, coset Weil, and scalar Hasse each appear
once.  Whether the Paley theorem should lead the title is a novelty decision,
not yet a mathematical one.

## 6. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Is the local Paley automorphism theorem genuinely new? | no predecessor located in the focused covered sources | candidate novelty is the exact group/unique extension, not the already known prime-field circulant model; retain “to our knowledge” pending a human MathSciNet/Scopus check |
| Do local automorphisms extend to the full Paley tournament? | settled positive and uniquely | the classified map extends as \(x\mapsto c x^{p^j}\); distinct parameters act distinctly on \(S\) |
| Is the harmonic step specifically Paley? | settled negative | isolate the flat Sidon lemma and the one-faithful-eigenblock Cayley criterion |
| What does the exact group say for prime \(q\)? | settled | the local tournament is a cyclic directed regular representation |
| Does a primitive eigenblock recover coordinates? | settled up to the natural ambiguity | its flat lines are exactly the Frobenius character lines, giving cyclic coordinates up to translation and Frobenius |
| Should Peisert or higher cyclotomic local graphs be pursued now? | no | possible successor only after the C756 paper gate; do not expand this task |
| Does the local Paley theorem require the matching, resultant, or covering hypotheses? | settled negative | its proof uses only \(BP=PB\), one primitive collision class, Sidon, and pointwise modulus one |
| Is the bispectral anticommutator needed in the final proof? | settled negative | retain only the single Paley convolution \(B\); archive \(C,K\), simple-spectrum, and Pfaffian branches |
| Is covering genuinely needed for the headline classification? | settled negative | the extremal exterior-arc condition already gives saturation; covering is needed only to discard \(q=3,7\) |
| Are the \(q=7\) and \(q=11\) extremal exterior arcs unique up to the conic stabilizer? | settled positive | the admissible scalar pairs are inverse under the stabilizer map \(x\mapsto x^{-1}\) |
| Does the saturated-exterior theorem depend on finite enumeration? | settled negative | Steps A–H are human proofs; certificates are corroboration only |
| Does extension-field Frobenius create an unhandled spectral branch? | settled | the audited primitive collision class is exactly Frobenius; the coset Weil step removes every \(j>0\) |
| Is simple spectrum required? | settled negative | one primitive block suffices |
| Is the proof presently referee-readable end to end? | yes, pending a cold read | the consolidated theorem-proof removes the four-report dependency chase and superseded conditional language |
| Which new lemma carried the most risk? | settled after repair and line audit | primitive Jacobi collision / half-carry digit argument; a specialist cold read remains desirable, but the audit found no mathematical gap |
| Is another computational sweep the next move? | settled negative | consolidate and independently audit the human proof first |
| May manuscript editing begin under C756? | no | pass the citation and consolidated-proof audit, then allocate a separate unnumbered task |
