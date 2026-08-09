# C756 — saturated-external proof-trust map

**Lane**: `clebsch` · **Date**: 2026-08-08 · **Scope**: proof audit and
publication triage; no manuscript edits

## Verdict

The saturated-external classification survives an end-to-end claim audit:

> Let (C\) be a nonsingular conic in \(\mathrm{PG}(2,q)\).  If an arc (A)
> consists of exterior points of (C\), has the saturated size
> \((q+1)/2\), every secant of (A\) is passant to (C\), and those secants
> cover every point off (C\), then (q=11\) and (A\) is projectively the
> Clebsch hexagon.

The proof is all-field and human-readable; finite computation is not used to
deduce the theorem.  Its logic is nevertheless spread across four C756
reports, and the load-bearing extension-field step uses a new primitive-Jacobi
collision lemma.  The result is suitable as the headline of the scoped
specialist companion only after the proof is consolidated into one text and
the standard character-sum inputs are cited at version-of-record quality.

One fresh extension-field check was replayed at (q=27\).  It exactly
reproduced the committed all-(k\) certificate row: (k_{\min}=9\),
(m(q)=9\), and no conic-filling arc.  This is an independent finite audit of
the theorem's first unsearched-looking extension-field regime, not a substitute
for the proof.

## 1. Claim-to-proof map

| step | exact claim | proof location | trust and publication action |
|---|---|---|---|
| A | Saturation forces one of two matching geometries; the external type has ((q+1)/2\) exterior points paired by the passant pencil | `2026-08-01-c756-all-k-conic-filling.md`, Lemma 3 and saturation discussion | elementary incidence proof; consolidate definitions and distinguish exterior points from external/passant lines |
| B | Normalizing a fixed matching edge converts the remaining matching to a permutation of the cyclic square group, and fixed-edge triple determinants make it a complete mapping | `2026-08-01-c756-saturated-matching-attack.md`, §§1–2 | direct determinant calculation; referee should check normalization at (q=3\) and that every denominator is nonzero |
| C | If (q\equiv1\pmod4\), no such complete mapping exists because the square group has even order | same report, Proposition 1 | one-line group-sum obstruction; no computation or external theorem |
| D | If (q\equiv3\pmod4\), Segre's lemma of tangents forces all resultant signs to cohere, so the matching permutation is an automorphism of the Paley tournament induced on the nonzero squares | `2026-08-01-c756-segre-tangent-coherence.md`, Proposition 1 | human proof; load-bearing classical input is Segre's lemma.  Consolidation must state its hypotheses and fix tangent-function scalings explicitly |
| E | The signed matching satisfies two fixed matrix equations; a primitive-character noncollision statement implies that every such local Paley automorphism is (s\mapsto c s^{p^j}\) | `2026-08-01-c756-paley-bispectral-reduction.md`, §§1–4, especially one-block rigidity | linear algebra plus multiplicative Fourier transform; audit the inverse convention and the passage from a faithful character to equality of field elements |
| F | For conductor (m=(p^n-1)/2\), equality of the relevant primitive Jacobi values occurs exactly along Frobenius orbits | `2026-08-01-c756-primitive-jacobi-collisions.md`, §§1–3 | new human proof using the Gauss/Jacobi product and Stickelberger valuations; highest referee-risk step.  Recheck the base-(p\) half-carry lemma for composite (m\), imprimitive competitors, and (n=1\) edge cases |
| G | Every nonidentity Frobenius exponent (j>0\) contradicts a coset character-sum bound | `2026-08-01-c756-segre-tangent-coherence.md`, Proposition 2 | human proof.  The subgroup-size lower bound is elementary; the three-support-point multiplicative Weil bound is standard but needs a precise citation and a clean statement covering all characters in the expansion |
| H | In the scalar branch, a genus-one character sum and Hasse leave (q\in\{3,7,11\}\); the covering condition removes (q=3,7\), and (q=11\) is the Clebsch hexagon | `2026-08-01-c756-saturated-matching-attack.md`, Proposition 2 and its endgame | human proof with standard Hasse input; reproduce the small-field endpoint checks directly in the paper rather than citing a certificate |

The dependency chain is

\[
 \text{saturation}\Rightarrow\text{matching}\Rightarrow
 \begin{cases}
   \text{even square-group order}\Rightarrow\bot,&q\equiv1\pmod4,\\
   \text{Segre coherence}\Rightarrow\text{local Paley automorphism}
   \Rightarrow\text{Jacobi/Frobenius rigidity}
   \Rightarrow\text{scalar Hasse endgame},&q\equiv3\pmod4.
 \end{cases}
\]

No step invokes the finite classifications below.  Conversely, the certificate
does not verify the character-theoretic collision theorem.

## 2. Proof-trust risks

### 2.1 Highest risk: primitive Jacobi collision

The new lemma is stronger than the theorem needs: a primitive Jacobi value
cannot collide with an imprimitive character, and its complete collision class
is its Frobenius orbit.  The proof translates Stickelberger valuations into a
binary half-carry profile, sums dyadic iterates to recover base-(p\) digit
weight, and uses the test multipliers (1\) and ((p+1)/2\) to force a power of
(p\).  That economy is a strength, but it is also the least standard link.

Before submission, rewrite it as a standalone lemma with every quantifier and
conductor convention local, then have an independent finite-fields reader
check: valuation normalization, the treatment of nonunits, the rotation/digit
identification, and the implication from equality of Jacobi sums to equality
of all required valuations.  Pomerance--Ulmer and Hoshi are neighboring
frameworks, not substitutes for this proof.

### 2.2 Classical inputs that need exact citations

The consolidated proof should state and cite, rather than merely name:

1. Segre's lemma of tangents in the odd-order planar-arc form actually used;
2. the Gauss/Jacobi product identity and the exact Stickelberger valuation
   formula with the chosen normalization;
3. the multiplicative-character Weil bound for three distinct support points;
4. Hasse's bound for the nonsingular cubic in the scalar endgame.

These are standard inputs, but citation imprecision here would obscure which
parts of the argument are new.  The predecessor audit does not yet supply this
version-of-record bibliography.

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
- The (q=3\) normalization and the (q=7\) noncovering endpoint should be
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

Its sole row is byte-semantically equal, after JSON parsing, to the (q=27\)
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
| fresh (q=27\) JSON | `9a54fef298e9a0a09c0136bbbc987ae606cf3b313552f1a8b9c01ab43bfdc9d6` |
| `2026-08-01-c756-saturated-matching-analysis.py` | `de2e6022767e92f4256e3ffd92e51a68812ce81a7a94e825a346ca669916e711` |
| `2026-08-01-c756-saturated-matching-analysis.json` | `6a0ae705337791d4910dacd955c8f436e22bf9d4fb55197a8263bc56edc6485e` |

The finite evidence supports the integration audit and guards against a hidden
small extension-field exception.  Publication claims should still label the
all-(q\) theorem as proved by Steps A–H, not “computer verified.”

## 4. Publication decision and next action

The proof-trust gate is **provisionally passed**: no logical hole was found,
and the extension-field replay agrees.  The package is not manuscript-ready
because the proof is fragmented and its standard inputs have not received a
version-of-record citation audit.

The highest-value next pass is therefore bounded and nonexploratory:

1. consolidate Steps A–H into a single theorem-proof document;
2. independently line-audit the primitive-Jacobi lemma and extension-field
   conventions;
3. attach exact primary citations for Segre, Stickelberger, Weil, and Hasse;
4. only if those checks pass, allocate a separate unnumbered companion-paper
   task and begin manuscript work.

Do not return to theta fitting or to a new finite-field sweep during this gate.
Neither attacks the remaining proof-trust risk.

## 5. EJ + TT closeout

**EJ.**  The free strengthening is conceptual: the all-field classification
does not require simple spectrum of the local Paley matrix and does not require
classifying all Jacobi blocks.  One faithful primitive block, together with
the exact collision lemma, forces the entire local automorphism to be
multiplication followed by Frobenius.

**TT.**  The shortest publishable route is to suppress the historical sequence
of conditional gates.  Present Segre coherence, one-block rigidity, primitive
Jacobi collision, and the Weil/Hasse endgame as one forward proof.  Keep the
Gaussian/Pfaffian obstruction and other superseded partial closures out of the
main theorem.

## 6. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Does the saturated-exterior theorem depend on finite enumeration? | settled negative | Steps A–H are human proofs; certificates are corroboration only |
| Does extension-field Frobenius create an unhandled spectral branch? | settled, conditional on the Jacobi lemma audit | the primitive collision class is exactly Frobenius; the coset Weil step removes every (j>0\) |
| Is simple spectrum required? | settled negative | one primitive block suffices |
| Is the proof presently referee-readable end to end? | no | it is distributed across four reports with superseded conditional language |
| Which new lemma carries the most risk? | settled | primitive Jacobi collision / half-carry digit argument |
| Is another computational sweep the next move? | settled negative | consolidate and independently audit the human proof first |
| May manuscript editing begin under C756? | no | pass the citation and consolidated-proof audit, then allocate a separate unnumbered task |
