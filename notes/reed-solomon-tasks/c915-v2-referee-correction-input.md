# Correction package for `prs-beyond-redundancy-four.pdf`

Manuscript: **Deep holes of projective Reed–Solomon codes beyond redundancy four: recursive carriers and exact classifications through redundancy ten**  
Version audited: **Unrefereed draft, Version 2, August 2026**

This file is deliberately written as an edit specification rather than as prose advice. Apply the edits in the order given. Do not let an editing model infer or invent missing mathematics.

## Severity convention

- **S0 — Fatal:** a headline theorem is false or cannot plausibly be repaired without a substantial change of result.
- **S1 — Major:** a central proof is incomplete or materially under-justified; acceptance should wait for repair.
- **S2 — Moderate:** a genuine but local mathematical/source inconsistency.
- **S3 — Minor:** notation, attribution, or exposition that should be corrected before submission.

No S0 defect was found in the audited PDF. The mandatory repairs below are S1–S3.

## Mandatory edit order

1. Repair/expand Theorem D.10 as specified in **E2**.
2. Supply a complete characteristic-two transverse proof for Proposition D.12 as specified in **E1**.
3. Apply the local mathematical correction in **E3**.
4. Apply the source-locator corrections in **E4**.
5. Resolve the coordinate-sign ambiguity in **E5**.
6. Apply the bound-attribution correction in **E6**.
7. Run every checklist and sanity review at the end of this file.

Do not reorder steps 1–2: D.10 and D.12 are independent mathematical proof obligations, and neither should be treated as established by a later theorem that depends on it.

---

## E1 — S1: Complete the characteristic-two R10 transverse proof

### Location

- PDF **page 60**.
- **Proposition D.12 (R10 fixed-depth escape)**, characteristic-two paragraph.
- Exact anchor starts:

> “In characteristic two the ordered-Hessian base selector requires …”

and continues through:

> “Proposition 6.3 then identifies the sole contained locus in either case as the displayed carrier union.”

### Problem

The paragraph asserts, without a self-contained definition or proof, all of the following items that are essential to the even-characteristic part of Proposition D.12:

1. what the “ordered-Hessian” object is;
2. what the “common-quadratic” and “complementary Fano” rulings are in this argument;
3. why a nonzero selector exists for **every** point off the contained carrier;
4. why its relevant individual root degree is eight;
5. why the selector bound is exactly
   \[
   \min\{(9-4)(9+11)/2+1,\;9(9-4)\}=45;
   \]
6. why the residual curve is a geometrically integral `(2,2)` curve of genus at most one;
7. why the five deletion contributions are exactly `5, 2, 2, 10, 4`;
8. why a surviving rational point gives the required split squarefree witness avoiding all five retained markers.

This is not merely an exposition problem: Corollary D.14 uses Proposition D.12 to close the binary fields `q >= 64` in the headline redundancy-ten theorem.

### Required edit

Insert a new standalone result **immediately before Proposition D.12**. A suitable name is:

> **Lemma D.12a (Characteristic-two ordered-Hessian slice and selector).**

Do not use that exact numbering if it breaks the manuscript's numbering system; choose the next local label and update all references.

The inserted result must contain **all** of the following, in this order.

#### E1.1 Define the object

Give the actual root/marker coordinates and write down the polynomial or matrix whose `(2,2)` residual slice is being used. Define “ordered-Hessian” explicitly. A reader must be able to reproduce the slice from the displayed formulas without consulting source code.

#### E1.2 Define the two ruling failures

Write the exact equations defining:

- the common-quadratic ruling failure; and
- the complementary-Fano ruling failure.

State precisely which ambient parameter space they live in and which upper syndrome/carrier condition each one corresponds to.

#### E1.3 Prove selector nonvanishing

Show that, for a point outside `P_10 \cup M^max_{10,2}`, at least one equation selected from each ruling is nonzero, so their product is a nonzero polynomial on the root/marker parameter space.

This must be a mathematical proof. Do not replace the derivation with a bare assertion.

#### E1.4 Derive the selector degree and the number 45

Show explicitly why the product has individual root degree at most eight. Then show how that degree gives the quoted selector threshold and the number 45. Define what “parameters” means in the sentence “requires 45 parameters”: field elements, blocks, or candidate root values.

The proof must make it impossible to confuse the bound `45` with a deletion degree or a projective-point count.

#### E1.5 Prove geometric integrality/genus

For the selected base, prove that the normalized residual `(2,2)` curve is geometrically integral and has genus at most one. If this is an Artin–Schreier cover in characteristic two, print the exact nontriviality criterion used to exclude a constant-field or reducible cover.

A bare phrase such as “ordered-Hessian genus-one slice” is insufficient.

#### E1.6 Print the deletion table

Print a table with one row for each of the five contributions

`5, 2, 2, 10, 4`.

For each row give:

- the geometric failure being excluded;
- the defining polynomial/resultant/discriminant;
- its degree on the base line;
- the degree after pullback to the normalized double cover, if different;
- why it is not identically zero on the selected open set.

The sum must visibly equal `23` in the convention actually used in the point bound.

#### E1.7 Finish the lifting argument

State explicitly that a rational point surviving the selector and deletion divisor gives a split squarefree terminal member avoiding all five retained markers, and invoke Equation (4) / Theorem 5.5 to lift it to a split squarefree degree-eight member of the original Hankel kernel.

### Replacement of the current paragraph

After the new lemma is proved, shorten the current characteristic-two paragraph in Proposition D.12 to a dependency statement of the following form:

> “In characteristic two, Lemma D.12a supplies a nonzero base selector with the stated field-size bound and a geometrically integral genus-at-most-one residual cover with deletion degree 23. Its first admissible binary field is `q=64`. Proposition D.11 supplies the five marker-stage budgets, and Proposition 6.3 supplies the contained-component classification. The finite-depth escape theorem therefore applies.”

Adjust wording to the actual lemma and actual quantities proved.

### Fail-safe instruction for Opus

**If the source TeX or author-supplied derivation does not contain enough information to prove E1.1–E1.7, do not generate plausible equations. Output `BLOCKED: E1 requires author-supplied mathematics` and make no theorem-strengthening edit.**

If this proof cannot be supplied, the safe mathematical fallback is to restrict the R10 claim so that the unproved binary transverse range is not asserted.

---

## E2 — S1: Expand the all-field complement argument in Theorem D.10

### Location

- PDF **page 58**, continuing onto page 59.
- **Theorem D.10 (Empty first higher Lucas carrier)**.
- First exact anchor:

> “For the all-field argument, the coefficient map …”

- Critical compressed paragraph begins with:

> “has rank at least three whenever `z_4 != 0` or `z_5 != 0`.”

- Second critical anchor begins:

> “Fix five roots and let `x` be the sixth.”

### Problem

The theorem is a central ingredient of the redundancy-ten classification, but several decisive all-field algebraic claims are stated in compressed form without enough derivation for independent checking:

1. the rank-`>=3` statement for the displayed matrix `M_z`;
2. the exact rank-three/rank-four split;
3. the rank-four nonsquare calculation on `Q=0`;
4. the implication in rank three from “square on every component of `Q=0`” to the displayed derivative relations;
5. the subsequent elimination forcing `z_4=z_5=0`;
6. the exact pseudo-remainder used for the selector;
7. the nonvanishing and degree bounds that lead to the `22` individual-degree grid estimate.

Because the theorem is stated uniformly, the printed mathematics must carry this all-field burden.

### Required edit

Split the current argument into at least three printed lemmas. Suggested organization follows.

### E2.1 Rank lemma

Insert a lemma immediately after Equation (36):

> **Lemma D.10a (Rank of the coefficient map off the invariant block).**

It must prove, by explicit row/column elimination, that the displayed `4 x 6` matrix `M_z` has rank at least three whenever `z_4 != 0` or `z_5 != 0`.

Do not leave the proof as the sentence “a two-dimensional left kernel either …”. Write the two cases and the successive column equations that force the contradiction.

Also state precisely when rank is three and when it is four, or state only the dichotomy if an explicit classification is unnecessary.

### E2.2 Artin–Schreier nonsquare lemma

Insert a second lemma:

> **Lemma D.10b (Geometric nontriviality of the final-pair Artin–Schreier cover).**

Treat rank four and rank three separately.

#### Rank four: print the core calculation

When `A_0,A_1,A_2,A_3` are independent and

\[
Q=A_0A_3+A_1A_2,
\]

work on the dense chart `A_3 != 0`. On `Q=0`, derive

\[
A_0=A_1A_2/A_3.
\]

With

\[
\Delta=A_1A_3+A_2^2,\qquad N=A_1^2+A_0A_2,
\]

compute

\[
N=\frac{A_1\Delta}{A_3},\qquad
N\Delta=\frac{A_1}{A_3}\Delta^2.
\]

Then explain why `A_1/A_3` is not a square in the function field of the quadric `Q=0`. This supplies the printed nonsquare leading coefficient for the double-pole reduction.

This calculation is short and removes a major audit ambiguity.

#### Rank three: expand the derivative argument

Let the unique affine relation be

\[
\sum_i \ell_i A_i=\kappa.
\]

Write the actual rational function whose square class is being tested on every irreducible component of `Q=0`. Then:

1. differentiate the assumed square relation;
2. derive the displayed relations
   \[
   \ell_0\kappa=\ell_1\kappa=0,\qquad \ell_1\ell_2=\ell_0\ell_3;
   \]
3. print the six column relations obtained from Equation (36);
4. eliminate the `\ell_i` and `\kappa` explicitly enough to show they force `z_4=z_5=0`.

Conclude geometric nontriviality of the Artin–Schreier class, not merely arithmetic nontriviality over one finite field.

### E2.3 Selector/degree lemma

Insert a third lemma:

> **Lemma D.10c (Good-base selector and degree bound).**

Starting from `A_j=B_j+xB_{j+1}`, define the exact pseudo-remainder used when testing the Artin–Schreier numerator against `Q`. Print its coefficients or a formula from which they can be reproduced.

Then give a degree table containing at least:

- `Q'`;
- `[x^2]Q`;
- every coefficient of the quadratic pseudo-remainder;
- the five-root Vandermonde;
- their individual degrees in each root coordinate.

Show that the chosen product is nonzero and has individual degree at most

\[
14+2+2+4=22.
\]

Then state the finite-field grid lemma being used and explain exactly why it supplies a rational good base for every binary `q >= 32`.

### Fail-safe instruction for Opus

**If any algebraic implication in E2.1–E2.3 cannot be reconstructed exactly, output `BLOCKED` with the missing implication and do not paraphrase it into a stronger-looking proof.**

---

## E3 — S2: Correct the characteristic-five R9 modular lift from “line” to “point”

### Mathematical check

At redundancy `r=9`, Equation (5) uses adjacent zeros in Pascal row `r-2=7`. Modulo 5,

\[
\binom{7}{j}_{j=0}^7=(1,2,1,0,0,1,2,1)\pmod 5.
\]

The simultaneous condition

\[
\binom 7j=\binom 7{j-1}=0\pmod 5
\]

holds only for `j=4`. Hence

\[
M^{\max}_{9,5}=\mathbb P\langle e_4\rangle,
\]

a single projective point, not a line.

### Location 1

- PDF **page 49**.
- **Proposition B.20 (Other modular lifts)**.
- Exact text:

> “The consecutive Lucas supports leave a line in characteristic five and the quartic carrier above in characteristic seven; no other characteristic has a nonzero coherent lift. The former line is shallow for every `q > 5`.”

### Replace with

> “The consecutive Lucas supports leave the point `\(\mathbb P\langle e_4\rangle\)` in characteristic five and the quartic carrier above in characteristic seven; no other characteristic has a nonzero coherent lift. The characteristic-five point is shallow for every `q>5`.”

If the source uses a different basis index convention, first recompute Equation (5) in that convention; in the Version-2 convention the index is `e_4`.

### Location 2

- PDF **page 50**.
- **Proposition B.21 (Degree-eight contained components)** already says “the characteristic-five point”.

**Do not change B.21 from point to line.** Instead make B.20 agree with it.

### Proof wording

In the proof of B.20, make the witness sentence explicitly refer to the unique characteristic-five projective point. The existing witness construction using the homogenization of `t^5-t` may remain if its two Hankel equations are unchanged.

---

## E4 — S2: Update every BPS22 locator to the published numbering

### Problem

The bibliography cites the **published 2022 Designs, Codes and Cryptography article** by Blokhuis–Pellikaan–Szőnyi, but the in-text proposition/theorem/remark numbers are from an earlier manuscript numbering. The mathematical source alignment is good; the locators are wrong for the bibliographic item actually cited.

### Primary-source mapping

Use the published Springer numbering:

| Current manuscript locator | Published locator |
|---|---|
| `BPS22, Prop. 3.1` | `BPS22, Prop. 4.1` |
| `BPS22, Rem. 3.2` | `BPS22, Rem. 4.2` |
| `BPS22, Prop. 5.5` | `BPS22, Prop. 6.5` |
| `BPS22, Rem. 6.12` | `BPS22, Rem. 7.12` |
| `BPS22, Thm. 7.1` | `BPS22, Thm. 8.1` |
| `BPS22, Prop. 7.4` | `BPS22, Prop. 8.4` |
| `BPS22, Rem. 7.6` | `BPS22, Rem. 8.6` |

### Required replacements by page

#### PDF page 6

Anchor:

> `[BPS22, Thm. 7.1, Prop. 7.4 and Rem. 6.12]`

Replace with:

> `[BPS22, Thm. 8.1, Prop. 8.4 and Rem. 7.12]`

#### PDF page 8

Anchor:

> `[BPS22, Prop. 3.1 and Rem. 3.2]`

Replace with:

> `[BPS22, Prop. 4.1 and Rem. 4.2]`

#### PDF page 14

Anchor:

> `[BPS22, Prop. 5.5]`

Replace with:

> `[BPS22, Prop. 6.5]`

Second anchor on page 14:

> `[BPS22, Thm. 7.1 and Prop. 7.4]`

Replace with:

> `[BPS22, Thm. 8.1 and Prop. 8.4]`

#### PDF page 15

Anchor in prose:

> “their Remark 6.12 reaches the threshold …”

Replace `Remark 6.12` with `Remark 7.12`.

Second anchor:

> `[BPS22, Rem. 7.6]`

Replace with:

> `[BPS22, Rem. 8.6]`

### Sanity check

Search the final TeX/PDF for the literal strings:

- `BPS22, Prop. 3.1`
- `BPS22, Rem. 3.2`
- `BPS22, Prop. 5.5`
- `BPS22, Rem. 6.12`
- `BPS22, Thm. 7.1`
- `BPS22, Prop. 7.4`
- `BPS22, Rem. 7.6`

All must have zero matches unless the bibliography is deliberately changed to cite a prepublication version instead.

---

## E5 — S3: Resolve the sign/convention ambiguity in Proposition 6.1

### Location

- PDF **page 23**.
- **Proposition 6.1 (Reduced terminal carrier)**.
- Parametrization (6):

\[
[u:v:w]\mapsto[6u^2:3uv:v^2+2uw:3vw:6w^2].
\]

- Exact following anchor:

> “the locus of syndrome quartics that are scalar multiples of squares of binary quadratics: on this map `f_c = 6(uX^2-vXY+wY^2)^2`.”

### Problem

Under the usual plain-coefficient/binomial-rescaled identification, the displayed positive odd coordinates in (6) correspond to the square with `+vXY`, whereas the following formula uses `-vXY`. Replacing `v` by `-v` gives the same image variety, so this does not appear to change the geometric component, but “on this map” is coordinate-wise ambiguous unless `f_c` includes an unstated alternating-sign convention.

The manuscript itself correctly warns elsewhere that divided-power syndrome coordinates must not be naively factored in small characteristic, so this convention should be explicit here.

### Required edit

Do **one** of the following after inspecting the source convention.

#### Option A — intended plain/binomial-rescaled coefficient identification

If `f_c` is literally the quartic with the displayed rescaled coefficients, change

> `6(uX^2-vXY+wY^2)^2`

to

> `6(uX^2+vXY+wY^2)^2`

and verify all five coefficients against (6).

#### Option B — intended apolar/alternating-sign identification

If the minus sign is intentional, insert an explicit definition immediately before the sentence, e.g. the exact formula identifying `(c_0,...,c_4)` with `f_c`, including all signs and binomial factors. Then demonstrate in one line that parametrization (6) maps to the stated square under that convention.

### Fail-safe instruction for Opus

Do not choose A or B from typography alone. Inspect the TeX definitions and neighboring coordinate identifications. If the convention is not recoverable, mark `BLOCKED: E5 sign convention requires author confirmation`.

---

## E6 — S3: Use Aubry–Perret rather than bare Hasse–Weil in Lemma B.4 unless smoothness is proved

### Location

- PDF **pages 41–42**.
- **Lemma B.4 (Bottom monodromy and deletion)**.
- The proof establishes that the bottom ordered-root curve is “geometrically integral” and has “arithmetic genus one”.
- Exact anchor on PDF page 42:

> “Hasse–Weil supplies a surviving rational point for every `q >= 43`.”

### Problem

At this point the printed proof does not separately establish smoothness. Earlier in the paper, the same type of estimate is deliberately taken from Aubry–Perret for reduced geometrically integral possibly singular curves of arithmetic genus one. The numerical inequality is unchanged; the attribution should match the stated hypotheses.

### Required edit

If no smoothness lemma is inserted, replace:

> “Hasse–Weil supplies a surviving rational point for every `q >= 43`.”

with:

> “The Aubry–Perret bound for a geometrically integral projective curve of arithmetic genus one supplies a surviving rational point for every `q >= 43`.”

Add `[AP95, p. 468]` if the local citation style calls for a citation at this occurrence.

If you instead prove that the curve is smooth in this stratum, then retaining “Hasse–Weil” is mathematically fine, but print the smoothness argument before invoking it.

---

## Primary-source guardrails: claims that should **not** be “corrected”

These items were independently checked against the cited primary sources and should be preserved unless a new source/version changes them.

### G1 — Kaipa / Roth–Seroussi / Dür radius gate

The manuscript's use of the high-rate nonextendability range and the separate radius gate is aligned with Kaipa's presentation of Roth–Seroussi and Dür. Preserve the logical separation

`split-free classification + radius r-1 => deep-hole classification`.

Do not let an editor turn a finite split-free census into a covering-radius proof.

### G2 — ZWK20 scope

The statement that the previous PRS classification reaches redundancy four and leaves the next case `k=q-4` for later work is aligned with the primary paper. Preserve this historical framing.

### G3 — KP25 denominator typo diagnosis

**Do not remove the manuscript's diagnosis of the printed denominator in KP25.**

The primary source's displayed Theorem 1.3(3) prints denominator `3`, but its own Proposition 4.5(3), Theorem 5.1, and proof combine to give denominator `6`:

\[
|S\cap O_3|=(\nu_L-\eta_L)/3,
\qquad
\nu_L=(\#E_L(\mathbb F_q)-\eta_L)/2,
\]
so
\[
|S\cap O_3|=(\#E_L(\mathbb F_q)-3\eta_L)/6.
\]

The Version-2 manuscript is correct to call the displayed `/3` a typographical slip.

### G4 — WWH26 endpoint

The use of Wang–Wu–Hu only for the projective-subline/Lucas-block endpoint is properly scoped. Their primary result gives nonemptiness for `q=p^e`, `k=p^m+1` exactly when `m|e`. Preserve the manuscript's statement that the adjacent-zero carrier, coherent nesting, and its Hankel splitting arithmetic are paper-owned steps.

### G5 — Proposition D.2 PDF overbar

Do not “fix” Proposition D.2 on the basis of plain-text extraction. The rendered PDF correctly uses the algebraic closure in the phrase “geometric coefficient field”. The apparent statement `k=F_2` in text extraction loses the overbar.

---

# Opus edit prompt

Copy the following prompt verbatim into the editing model after giving it the **source TeX** and this correction package.

```text
You are editing a mathematical research paper. Correctness takes priority over fluent prose.

AUTHORITATIVE INPUTS
1. The source TeX for “Deep holes of projective Reed–Solomon codes beyond redundancy four: recursive carriers and exact classifications through redundancy ten”, Version 2, August 2026.
2. The correction specification prs_referee_edits.md.
3. The primary sources named in the bibliography when a citation locator or imported theorem is being changed.

RULES
- Apply prs_referee_edits.md in the stated order.
- Never invent a lemma, equation, elimination identity, source locator, or field bound.
- For E1 and E2, a polished paraphrase is NOT a repair. The requested algebra/equations must be reconstructed exactly from the author’s mathematics and printed in the paper.
- If any required mathematical step cannot be reconstructed exactly, stop that edit and output `BLOCKED`, quoting the precise missing implication. Do not fill the gap with plausible prose.
- Preserve the distinction among (a) split-free geometry, (b) covering-radius gates, and (c) deep-hole classifications.
- Never infer a covering radius from a split-free classification.
- Do not change any q-threshold until you have recomputed its displayed inequality and checked the first relevant prime power.
- Do not remove the manuscript’s KP25 denominator-typo diagnosis: it has been checked against KP25 Proposition 4.5, Theorem 5.1, and its proof.
- Do not alter Proposition D.2 because of PDF text extraction: the rendered PDF’s algebraic-closure bar is intentional.
- For E3, the characteristic-five R9 maximal Lucas support is the single projective point P<e4> in the Version-2 convention. Verify this from Equation (5) before editing.
- For E4, use the published BPS22 numbering listed in the specification unless you deliberately change the bibliography to a prepublication version.
- For E5, do not guess the sign convention. Inspect the exact definition of the syndrome-quartic identification and choose Option A or B only after coefficient verification.
- Compile after each logically independent edit and do not proceed through a compilation/reference error.

WORKFLOW
A. Make a working copy of the TeX.
B. Apply E2, compile, and re-derive every D.10 rank/square-class/selector step from the revised printed equations.
C. Apply E1, compile, and re-derive every D.12 selector/integrality/deletion/lifting step from the revised printed equations.
D. Apply E3–E6 one at a time, compiling after each.
E. Run the full checklist and all five sanity reviews in prs_referee_edits.md.
F. Produce a final change log with one row per edit: edit ID, exact TeX locations changed, and PASS/FAIL for the corresponding mathematical sanity check.

OUTPUT CONSTRAINT
If any S1 item is BLOCKED, do not report the paper as corrected. Report the exact blocked item and leave theorem statements no stronger than what is proved.
```

---

# Post-edit checklist

## A. Build and reference integrity

- [ ] The TeX compiles from a clean checkout with no undefined references.
- [ ] Every theorem/lemma/proposition number cited in text resolves to the intended object after inserting new D.10/D.12 lemmas.
- [ ] Every bibliography key resolves.
- [ ] All BPS22 locators use the published numbering, or the bibliography has explicitly been changed to the exact prepublication version matching the old numbering.
- [ ] Search confirms no stale BPS22 old-number locators remain.

## B. Core coding logic

- [ ] Every place that says “deep hole” has either a local radius hypothesis or a cited radius gate.
- [ ] R7 at `q=7,8,9` remains split-free only unless a new independent radius proof is supplied.
- [ ] The one-column MDS-extension discussion still distinguishes spans of `r-1` columns from the split-free `r-2` condition.

## C. R5 terminal model

- [ ] Proposition 4.6 still reads `#Y_f(F_q)=6N_f+3d_2+d_3`.
- [ ] The branch budget still gives `d_2+2d_3<=4` and binary `d_2+d_3<=2`.
- [ ] The general S3 threshold recomputes to `q>=20`.
- [ ] The binary S3 threshold recomputes to `q>=16`.
- [ ] The forced `q=17,19` invariant statement is unchanged unless supported by a new calculation.
- [ ] The KP25 comparison uses denominator `6` in the derived incidence formula.

## D. Lucas-support arithmetic

Recompute Equation (5) directly in each relevant characteristic. Do not trust prose labels.

- [ ] R6 binary support agrees with `P<e2,e3>` at the stated stage.
- [ ] R7 binary coherent lift agrees with the central point stated in Appendix A.
- [ ] R8 characteristic-three support agrees with `P<e2,e5>`.
- [ ] R8 characteristic-five support agrees with `P<e3,e4>`.
- [ ] R9 characteristic-five support is exactly `P<e4>` — a point.
- [ ] R9 characteristic-seven support is the stated binary-quartic carrier.
- [ ] R10 characteristic-two support is `M9=P<e2,...,e7>`.
- [ ] R10 characteristic-seven support agrees with `P<e3,e4,e5,e6>`.

## E. Threshold arithmetic

Re-evaluate numerically and then check the first relevant prime power, not merely the first integer.

- [ ] `q=16`: `q+1-2sqrt(q)=9>6` for the binary R5 bound.
- [ ] general R5: `q+1-2sqrt(q)>12` first forces the claimed `q>=20` integer threshold and leaves the listed prime-power bridge.
- [ ] R6: `30-2sqrt(29)>19`.
- [ ] R7: `38-2sqrt(37)>25`.
- [ ] R8: `44-2sqrt(43)>30`.
- [ ] R9: `54-2sqrt(53)>36`.
- [ ] R10 odd: `60-2sqrt(59)>42`.
- [ ] D.10 complement: `65-2sqrt(64)=49>48`.
- [ ] B.16 selector still requires `q>102`; for characteristic seven the first relevant power above that is `343`.
- [ ] Any new binary D.12 selector calculation reproduces `q=64` as the first binary field satisfying **all** selector and point-count conditions.

## F. Theorem D.10

- [ ] Equation (36) is unchanged unless a verified algebra correction is made.
- [ ] The rank-`>=3` claim is now proved by printed elimination.
- [ ] Rank-four nonsquare calculation prints `NDelta=(A1/A3)Delta^2` on `Q=0` (up to the paper's exact notation).
- [ ] Rank-three derivative relations are derived, not asserted.
- [ ] The six column relations used in the rank-three contradiction are printed or unambiguously enumerated.
- [ ] The pseudo-remainder in the good-base selector is explicitly defined.
- [ ] Its nonzero coefficient and degree bound are justified.
- [ ] The grid bound reproduces the claimed rational-good-base range.

## G. Proposition D.12 / R10 binary transverse branch

- [ ] “ordered-Hessian” has a precise definition.
- [ ] The common-quadratic ruling is written by equations.
- [ ] The complementary-Fano ruling is written by equations.
- [ ] Selector nonvanishing is proved for every point off `P_10 union M^max_{10,2}`.
- [ ] Individual root degree eight is derived.
- [ ] The number 45 is derived and its meaning is explicit.
- [ ] The residual `(2,2)` curve is proved geometrically integral.
- [ ] Genus at most one is proved.
- [ ] The five deletion terms `5,2,2,10,4` are individually derived.
- [ ] Their total convention matches the point bound `23`.
- [ ] Five-marker avoidance is explicit in the final lift.
- [ ] Corollary D.14 cites the completed D.12 proof rather than an opaque assertion.

## H. Source alignment

- [ ] Kaipa/Roth–Seroussi/Dür is used only in its stated parameter regime.
- [ ] ZWK20 is not credited with redundancy-five classification.
- [ ] Published BPS22 numbering has been updated throughout.
- [ ] KP25 typo discussion remains consistent with its proof and not only its erroneous displayed theorem.
- [ ] WWH26 is used only for the endpoint/projective-subline result actually supplied by that paper.
- [ ] Statements presented as paper-owned (adjacent-zero carrier, coherent nesting, final-pair arithmetic) are not accidentally attributed to WWH26 or another source.
- [ ] Aubry–Perret is cited where singular geometrically integral genus-one curves are allowed.

---

# Sanity-check review prompts

Run each prompt on the **post-edit PDF plus TeX**. Require concrete PASS/FAIL findings with exact locations.

## Review 1 — theorem dependency audit

```text
Audit every headline theorem in the revised manuscript as a dependency DAG. For each theorem, list every lemma/proposition/radius gate used, and recursively list their assumptions. Mark FAIL if an assumption is introduced only in prose after it is used, if a conclusion is stronger than the printed hypotheses justify, or if split-free is promoted to deep without a radius gate. Give exact PDF pages and theorem numbers for every failure. Do not suggest stylistic edits.
```

## Review 2 — adversarial characteristic audit

```text
Recompute every characteristic-dependent Lucas support directly from Equation (5), using Pascal/Lucas arithmetic rather than trusting the prose. Check p=2,3,5,7 at R6 through R10. Compare the computed projective dimensions and basis indices with every proposition that names a nucleus/Lucas carrier. In particular verify that the R9 p=5 object is P<e4>, not a line. Report PASS/FAIL with the binomial rows you computed.
```

## Review 3 — R10 proof audit

```text
Act as a hostile algebraic-geometry referee for Theorem D.10, Proposition D.12, and Corollary D.14 only. Re-derive every rank, square-class, geometric-integrality, selector-degree, deletion-degree, and finite-field-existence claim from the printed equations. Any sentence of the form “calculation shows”, “selector gives”, or “ruling implies” without enough printed algebra to reproduce the implication is FAIL. For each FAIL, quote the exact sentence and state the missing derivation.
```

## Review 4 — primary-source citation audit

```text
For every citation in Sections 1, 4, 6, and Appendix D that supplies a mathematical input, open the exact primary source/version named in the bibliography and verify: (1) theorem/lemma number, (2) hypotheses including characteristic and q range, and (3) conclusion used by the manuscript. Do not rely on secondary sources. Specifically check Kaipa 2017, ZWK20, published BPS22, KP25, Aubry–Perret, Gmainer–Havlicek, and WWH26. Report stale locator numbers even when the underlying claim is correct.
```

## Review 5 — regression/diff audit

```text
Compare the revised manuscript against Version 2. Ignore intended edits E1–E6 and flag every other mathematical change. For each changed equation, q-bound, orbit size, field range, support basis, theorem hypothesis, or citation-backed conclusion, demand an explicit mathematical justification. Mark any unexplained mathematical change FAIL. Also confirm that no edit accidentally changed the KP25 denominator correction, Proposition D.2's algebraic-closure convention, or the R7 q=7,8,9 radius status.
```

---

# Final acceptance gate for the editing pass

The editing pass is complete only if all of the following are true:

- [ ] E1 is mathematically proved in print, or the affected R10 binary claim is weakened.
- [ ] E2 is mathematically expanded enough for independent reproduction.
- [ ] E3–E6 are resolved.
- [ ] All post-edit checklist items pass or have an explicit author-approved exception.
- [ ] All five sanity reviews return PASS on the mathematical issues they target.
- [ ] A fresh referee can reconstruct the R10 binary argument without access to an unstated calculation.

