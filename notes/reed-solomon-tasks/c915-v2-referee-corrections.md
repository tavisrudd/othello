# C915 — beyond-redundancy-four PRS Version 2 referee correction package

**Lane**: `reed-solomon`

**Date:** 2026-08-16

**Status:** all six edits E1--E6 are applied, verified, and committed, and the
specification's post-edit checklist has been run.  Of its five closing audits,
the characteristic audit and the regression/diff audit were run in full here;
the theorem-dependency, hostile-R10, and primary-source audits are the ones a
second reader should still run, since running them on my own edits is not an
independent check.

**Input specification:** `notes/reed-solomon-tasks/c915-v2-referee-correction-input.md`
(verbatim copy of the external correction package, SHA-256 prefix `a0f64ed87b90`).
Its mandated order is E2, E1, then E3--E6; by explicit user instruction this task
runs bottom-up instead, taking the small local edits first.  The specification's
only hard ordering constraint --- that the two S1 proof obligations not be treated
as discharged by a later theorem depending on them --- is unaffected, since both
remain open and will be done in the specified relative order.

## Applied edits

### E6 (S3) --- Aubry--Perret in place of bare Hasse--Weil

`sections/07-fixed-level-eight-nine.tex`, Lemma *Bottom monodromy and deletion*
(`lem:r8-monodromy`, rendered as Lemma B.4).  The proof establishes that the
bottom ordered-root curve is geometrically integral of arithmetic genus one and
proves no smoothness, so the point count now cites the Aubry--Perret bound for a
reduced geometrically integral projective curve of arithmetic genus one, with
`\cite[p.~468]{AubryPerret1995}`, matching the form used at redundancy five.

Numerical check: the bound is `#C(F_q) >= q+1-2*sqrt(q) = (sqrt(q)-1)^2`, and the
deletion budget is `delta <= 30` from the displayed inequality.  `(sqrt(q)-1)^2 > 30`
requires `q > 41.9`; `q=41` gives `29.2 < 30` and fails, and `42` is not a prime
power, so the printed threshold `q >= 43` is unchanged and sharp among prime
powers.  Aubry--Perret and Hasse--Weil give the identical inequality at genus one,
so only the attribution changes.  PASS.

### E5 (S3) --- terminal-carrier sign convention

`sections/07-recursive-carriers.tex`, Proposition *Reduced terminal carrier*
(`prop:reduced-terminal-carrier`, rendered as Proposition 6.1).  Resolved as the
specification's Option A, after coefficient verification, and the identification
is now printed rather than left implicit.

Verification.  The paper's pairing is coefficient extraction with no binomial
factors, and the associated plain-coefficient quartic uses `z_i = C(4,i) c_i`.
Substituting the parametrization `c = (6u^2, 3uv, v^2+2uw, 3vw, 6w^2)` gives
`z = (6u^2, 12uv, 6v^2+12uw, 12vw, 6w^2)`, which is exactly
`6*(u X^2 + v XY + w Y^2)^2`, all five coefficients matching.  The printed
`-vXY` was wrong under the paper's own convention.  The revised sentence states
the rescaling `z_i = C(4,i) c_i` and the quartic `f_c = sum z_i X^{4-i} Y^i`
before asserting the square, so "on this map" is no longer coordinate-wise
ambiguous.  Dividing `z` by `C(4,i)` and clearing denominators returns the
displayed parametrization, and the rescaled surface is the plain-coefficient
Veronese `[u^2 : 2uv : v^2+2uw : 2vw : w^2]` already printed at
`eq:r8-cyclic-veronese`.  PASS.

### E4 (S2) --- Blokhuis--Pellikaan--Sz\H onyi locators

The bibliography cites the published *Designs, Codes and Cryptography* 90 (2022)
2223--2247 article, while every in-text locator came from arXiv:2103.16904v2.

The published article is hybrid open access under CC BY.  Its PDF was downloaded
from Springer, ingested into the shared literature cache as key
`10.1007/s10623-022-01060-0` (SHA-256
`df47fa06d2beb4b626dd7b7d96ceaaba3332bc3bc0cf03bd40571e4ea3cc840f`, 25 pages),
and every locator below was read in it directly.  The published version carries
one extra section before the old Section 3, so all of these shift by exactly one
section; that shift was confirmed item by item, not assumed.

| Old (arXiv v2) | Published | Verified statement |
|---|---|---|
| Prop. 3.1  | Prop. 4.1  | five `G_q`-orbits of planes |
| Rem. 3.2   | Rem. 4.2   | alternative view of the plane `[1:c:b:a]` |
| Prop. 5.5  | Prop. 6.5  | one-to-one correspondence used for the pencil-to-line dictionary |
| Rem. 6.12  | Rem. 7.12  | genus-one double point scheme, twelve deletions, threshold `q >= 23` |
| Thm. 7.1   | Thm. 8.1   | line classification `O_1,...,O_8` |
| Prop. 7.4  | Prop. 8.4  | table deciding which classes lie in a three-point plane, `q >= 23` |
| Rem. 7.6   | Rem. 8.6   | confirmation from degree-three permutation rational functions |

Edited sites: `sections/02-overview.tex` (the combined citation in the
literature paragraph), and `sections/04-redundancy-five.tex` at the
finite-geometric criterion, the plane/point convention remark, the class-by-class
correspondence, the prose reference to their remark, and the
Ferraguti--Micheli confirmation.

Trap worth recording: the published article also has a Remark 6.12, with entirely
different content about `p_{i,j,k}`, so the stale locator pointed at a real but
wrong statement rather than at nothing.

Sanity check: the seven literal old locators have zero matches in the TeX sources
and zero matches in the rendered PDF text.  PASS.

`literature-audit.md` now records the published numbering for the whole
load-bearing block, states that both versions were read, and notes the one-section
offset.

### E3 (S2) --- characteristic-five redundancy-nine modular lift is a point

`sections/07-fixed-level-eight-nine.tex`, Proposition *Other modular lifts*
(`prop:r9-other-modular`, rendered as Proposition B.20).  It said the consecutive
Lucas supports leave a line in characteristic five; they leave a single projective
point.

Recomputed from the maximal-Lucas-carrier definition
(`eq:maximal-lucas-carrier`).  At `r=9` the relevant Pascal row is `r-2=7`, and
`C(7,j) mod 5 = (1,2,1,0,0,1,2,1)`.  The simultaneous condition
`C(7,j) = C(7,j-1) = 0 mod 5` holds only at `j=4`, so
`M^max_{9,5} = P<e_4>`, a point.  The proposition statement and its shallowness
sentence now say so, and the proof prints this one-line row computation before
the existing `t^5-t` witness, which is unchanged and whose two Hankel equations
still hold.  The degree-eight contained-components proposition already said "the
characteristic-five point" and was left alone, as the specification requires.
PASS.

Cross-check of the neighbouring redundancy-eight statements, which the
specification did not flag: at `r=8` the row is `r-2=6`, with
`C(6,j) mod 5 = (1,1,0,0,0,1,1)` giving `j=3,4` and hence the line `P<e_3,e_4>`,
and `C(6,j) mod 3 = (1,0,0,2,0,0,1)` giving `j=2,5` and hence `P<e_2,e_5>`.
Both printed R8 claims are correct as they stand.

### E2 (S1) --- all-field complement argument for the empty first higher Lucas carrier

`sections/09-lucas-carriers.tex`, the theorem *Empty first higher Lucas carrier*
(`thm:m9-shallow`, rendered as Theorem D.10).  The compressed all-field paragraph
is replaced by three printed lemmas, as the specification asks, and the theorem
proof now invokes them.  The mathematics is the author's: it is the argument of
C620 sections 1--3 (`notes/2026-08-02-c620-higher-lucas-modular-carriers.md`),
printed in full with the gaps the referee named filled in and every step
recomputed here.

**Rank lemma** (`lem:m9-rank`).  The coefficient matrix display moves out of the
proof into the lemma, keeping its label so existing cross-references stand.  The
six column equations of a left kernel vector are printed, and the proof splits
into the two cases the old one-sentence argument compressed: a kernel vector with
first two coordinates zero, and a kernel projecting isomorphically onto the first
two coordinates.  Both force `z_2 = z_3 = z_4 = z_5 = 0`, so off the invariant
block the rank is three or four.  The lemma also states the dichotomy the referee
asked for: at rank four the affine map onto the four coefficients is surjective;
at rank three the image is the affine hyperplane cut by the unique left kernel
vector, with the constant `kappa = l_2 z_7 + l_3 z_6`.

**Nonsquare lemma** (`lem:m9-nonsquare`).  Prints `N = A_1 Delta / A_3` and
`N Delta = (A_1/A_3) Delta^2` on `Q = 0`, so the double pole reduces exactly when
`A_1/A_3` is a square on a component.  At rank four the quadric is smooth in
characteristic two (its partials are the four coordinates), hence irreducible, and
`div(A_1/A_3)` is computed to be the difference of the two planes `A_0 = A_1 = 0`
and `A_2 = A_3 = 0`, each with multiplicity one; odd multiplicity rules out a
square.  At rank three the proof first shows a component exists on which `A_2` and
`A_3` are independent --- otherwise the restricted quadric would be a polynomial in
`A_2, A_3` alone, contradicting the explicit elimination of `A_0` or `A_1` --- then
derives the referee's displayed slice
`A_1/A_3 = (kappa + l_2 A_2 + l_3 A_3)/(l_0 A_2 + l_1 A_3)`, differentiates it in
both variables, and gets `l_0 kappa = l_1 kappa = 0` and `l_1 l_2 = l_0 l_3`
exactly.  The elimination that turns those equalities into `z_4 = z_5 = 0` is
printed in all three branches, including the Borel branch where scaling `l_0 = 1`
gives `z_3 = a z_2`, `z_4 = (a^2+b) z_2`, `z_5 = a(a^2+b) z_2` and the last two
columns give `(a^2+b)^3 z_2 = 0`.  Two cases the compressed text left implicit are
now printed: the degenerate relation `l_0 = l_1 = 0`, where `A_1` is a coordinate
and the derivative in `A_1` is `1/A_3`, with `A_3` identically zero forcing the
last matrix row to vanish; and the check that the chosen component is not inside
`Delta = 0`, since `Q = Delta = 0` with `A_3` nonzero is the irreducible cone over
the twisted cubic, which cannot lie in the affine hyperplane.  The conclusion is
geometric, not one-field: the purely transcendental passage to the coefficient
space and the finite separable ordering of roots both preserve nonsquareness,
since adjoining a square root in characteristic two is purely inseparable.

**Selector lemma** (`lem:m9-selector`).  With `A_j = B_j + x B_{j+1}` the
quadratic `Q = q_2 x^2 + q_1 x + q_0` has `q_2 = B_1 B_4 + B_2 B_3` and
`q_1 = Q' = B_0 B_4 + B_2^2`.  Both are shown nonzero as polynomials by naming
the exact monomials: for `q_1` the coefficients of `g_0^2, g_4^2, g_2^2, g_1^2,
g_3^2, 1` are `z_2^2, z_6^2, z_4^2 + z_2 z_6, z_3^2, z_5^2 + z_3 z_7, z_7^2`, and
for `q_2` the coefficients of `g_0g_1, g_1g_2, g_1g_4, g_3g_4` are `z_2^2, z_3^2,
z_4^2 + z_3 z_5 + z_2 z_6, z_5^2 + z_3 z_7`; read in those orders they kill every
`z_i`.  (The C620 note gave the monomial order but not the coefficients; the two
cross terms were recomputed here.)  The pseudo-remainder is now defined and
printed: `q_2^3 R = S Q + rho` with
`rho_1 = q_2^3 R_1 + q_2^2 q_1 R_2 + (q_2^2 q_0 + q_2 q_1^2) R_3 + q_1^3 R_4` and
`rho_0 = q_2^3 R_0 + q_2^2 q_0 R_2 + q_2 q_1 q_0 R_3 + (q_2 q_0^2 + q_1^2 q_0) R_4`,
obtained by three pseudo-division steps.  Since `q_2` is invertible in the
fraction field, `rho = 0` would mean `Q | R`, which the nonsquare lemma excludes.
The degree accounting is per root coordinate: `B_j` multi-affine, `q_i` at most
two, each `R_i` at most eight, each `rho_i` at most `6 + 8 = 14`, and the
Vandermonde four, giving `14 + 2 + 2 + 4 = 22`.  The grid lemma is stated and
proved in one line (fix all but one variable; a nonzero univariate polynomial of
degree at most `d` has at most `d` roots), so any `q > 22` --- hence any binary
`q >= 32` --- has a good base.  PASS on every step.

Local variable collision avoided: the quadratic's coefficients are named
`q_2, q_1, q_0` and the Borel parameters `lambda, mu`, since `a, b, c, d` already
name the rank-two syndrome and the normalized slice in this section.

### E1 (S1) --- characteristic-two ordered-Hessian slice at redundancy ten

`sections/09-lucas-carriers.tex`, immediately before the proposition *R10
fixed-depth escape* (`prop:r10-escape`, rendered as Proposition D.12).  The
compressed characteristic-two paragraph asserted eight things without proof; it
is replaced by a dependency statement, and a new lemma
`lem:r10-hessian` proves them.

The mathematics comes from C620's predecessor work on the characteristic-two
Hessian layer: `notes/2026-07-23-c525-ordered-hessian-arf-pullback.md` and the
manuscript section `sections/08-ordered-hessian.tex`, which is present in the
repository but was dropped from the build during the Version 1 scope cut.  That
is exactly why the referee found the paragraph unsupported: the proposition
depended on machinery no longer printed anywhere in the manuscript.  The lemma
restores it in the specialization the proposition actually uses, at syndrome
degree nine.

What the lemma prints, in the specification's order:

1. **The object.**  For a squarefree `R` of degree five, the contracted pencil
   `l_{f,R}` of divided cubics; the observation that the Hankel kernel of a
   degree-three divided syndrome `(A,B,C,D)` is spanned by its signed maximal
   minors `(BD+C^2, AD+BC, AC+B^2)`, which are the divided Hessian coefficients;
   the three coefficient quadratics `P_0, P_1, P_2` in the pencil parameter; and
   the ordered-Hessian incidence `P_0 X^2 + P_1 XY + P_2 Y^2 = 0` on
   `P^1 x P^1`, of bidegree `(2,2)` and arithmetic genus one, with
   Artin--Schreier class `P_0 P_2 / P_1^2` off `P_1 = 0`.  Writing the incidence
   as the kernel quadratic rather than its coordinate reversal keeps it
   consistent with the paper's own Hankel convention; the source note used the
   reversed form, which has the same Artin--Schreier class.
2. **The two ruling failures.**  Both are written by equations in the
   Grassmannian of lines of `P(Gamma^3 E)`, in Plucker coordinates: the
   common-quadratic Veronese surface by the `2x2` minors of the printed
   symmetric matrix, whose member attached to a quadratic `Q` is the line of
   cubics `c` with `H_c Q = 0`; the tangent ruling and the complementary Fano
   ruling of the quadric `AD_3 + BC = 0` by their own linear and quadratic
   equations.  The parametrization `[a^2 : ab : ac : b^2+ac : bc : c^2]` was
   checked to satisfy both the printed minors and the Plucker relation, and the
   complementary ruling was checked against the Plucker relation as well.
3. **Selector nonvanishing.**  Proved, not asserted: if every pulled-back
   Veronese minor vanished identically in `R`, the generic root-line lies in the
   common-quadratic surface, and the contained-flag argument returns the
   persistent rank-two carrier or, in the modular case, the Lucas nucleus flags;
   if every pulled-back equation of the complementary ruling vanished, the two
   consecutive identities `h_{-1}^2 = h_{-2} h_0` and `h_1^2 = h_0 h_2` hold
   identically by density of split forms, unique factorization makes the five
   contraction forms proportional, and proportional rows put `f` in the
   rank-at-most-two catalecticant scheme.  Both land in the excluded union.
4. **Degree eight and the number 45.**  Plucker coordinates are quadratic in the
   coefficients of `R`, the ruling equations are quadratic in those, and each
   coefficient of `R` is multi-affine in the five roots, so each selected
   equation has degree at most four per root and the product at most eight.
   Schwartz--Zippel with the Vandermonde needs `q > 8*5 + 10 = 50`; five
   pairwise disjoint nine-element blocks need `q >= 45`.  The lemma says
   explicitly that `45 = 9*5` counts available field elements used as candidate
   root values, so it cannot be read as a deletion degree or a point count.
5. **Integrality and genus.**  The degeneracy classification is printed with its
   normal-form proof: vertical factors are exactly the intersections with the
   twisted cubic, horizontal factors force a chord or tangent line, and after
   removing them a separable factorization must be `(1,1)+(1,1)`, whose
   projectivity comparison forces `c^2+c+1=0` and lands in the common-quadratic
   surface, while the unipotent case is contradictory.  Inseparability is
   exactly `P_1 = 0`, that is a line on the quadric, so off the selector the
   curve is geometrically integral, its normalization has genus at most one, and
   the Artin--Schreier class is nonconstant.
6. **The deletion table.**  Five rows with their equations: `R(lambda) = 0`
   (degree 5), `P_0(lambda) = 0` (2), `P_1(lambda) = 0` (2),
   `Res_X(h_lambda, R) = 0` (10), `h_lambda(lambda) = 0` (4), total 23.  The
   degree-10 row is the resultant of a quadratic with a quintic, degree two in
   the coefficients of `R` and five in those of `h_lambda`, whose coefficients
   are quadratic in the parameter.  Each row is shown not to vanish identically,
   in every case because an integral `(2,2)` curve contains no horizontal line
   and no diagonal.  With at most two points over each deleted parameter and two
   over infinity, at most `2*23 + 2 = 48` rational points are lost.
7. **The lift.**  A surviving point gives a rational `lambda` off the markers and
   a rational root of `h_lambda`, hence both roots rational and distinct; since
   `h_lambda` spans the Hankel kernel of the contracted syndrome, six
   applications of the lift identity give `R lambda h_lambda` in `W_f`, of
   degree `5 + 1 + 2 = 8`, split and squarefree, with all eight roots distinct
   from each other and from the five markers.

The escape proposition now states the dependency and the arithmetic: the
selector needs 45 field elements, the slice deletes at most 48 rational points,
`64 + 1 - 2 sqrt 64 = 49 > 48`, and 64 is the first binary field with at least
45 elements, so `q = 64` is the first admissible binary field for both
conditions at once.  PASS on every item.

## Post-edit checklist

Section A (build and reference integrity): both builds compile warning-free with
no undefined reference or citation; all theorem references resolve through
labels, so inserting four lemmas renumbers rendered statements without breaking
any reference; the seven stale Blokhuis--Pellikaan--Szonyi locators have zero
matches in the TeX and in the rendered PDF text.

Sections D and E (Lucas supports and threshold arithmetic) were recomputed from
the definition rather than read off the prose, by
`notes/reed-solomon-tasks/c915-checklist-arithmetic.py`.  Replay:

```text
python3 notes/reed-solomon-tasks/c915-checklist-arithmetic.py
```

All eight supports agree with the manuscript --- R6 binary `P<e2,e3>`, R7 binary
central point `P<e3>`, R8 characteristic three `P<e2,e5>`, R8 characteristic five
`P<e3,e4>`, R9 characteristic five the point `P<e4>`, R9 characteristic seven
`P<e2,...,e6>`, R10 characteristic two `P<e2,...,e7>`, R10 characteristic seven
`P<e3,e4,e5,e6>` --- and every threshold holds at the quoted field, with the
first prime power reported next to the first integer.  One item needed care: at
redundancy five the manuscript quotes the integer threshold 20 while the first
prime power satisfying the inequality is 23; there is no prime power between
them, so the two describe the same set of fields, and the checklist item itself
asks for the integer threshold.  The script prints both to keep that
unambiguous.

Sections B, C and H (coding logic, redundancy-five terminal model, source
alignment) were checked against the source and are unchanged by this task: the
split-witness count `#Y_f = 6 N_f + 3 d_2 + d_3`, the branch budgets
`d_2 + 2 d_3 <= 4` and binary `d_2 + d_3 <= 2`, the thresholds `q >= 20` and
`q >= 16`, the forced `q = 17, 19` statement, the Kaipa--Pradhan denominator-6
diagnosis, the `q = 7, 8, 9` split-free-only status, and the remark separating a
deep hole (span of no `r-2` columns, radius `r-1`) from a one-column extension
(span of no `r-1` columns) all stand as before.  Sections F and G are the
checklists for E2 and E1 and are satisfied item by item as recorded above.

## Validation

Both manuscript builds pass warning-free after each edit, with no undefined
reference or citation.  Page counts grew as the printed mathematics went in:
canonical 64 then 67 then 70; TIT single-column 45, 47, then 49 of the
Makefile's hard 50.

The supplement verifier `python3 supplement/verify.py` passes.  Two of its
fail-closed guards had to be brought in line with the four new statements, which
is the intended workflow for adding theorem-like environments rather than a
loosening of any gate:

- `supplement/LEAN-STATEMENTS.md` gains one row per new label, each recording
  "no direct declaration" and naming the manuscript argument that carries it.
  The verifier requires set equality between manuscript labels and mapped
  labels, and that equality holds again.
- `supplement/verify.py` carries a hard-coded adopted-label count, raised from
  80 to 84.  The count is a drift alarm; the real gate is the set equality above.
- `supplement/EVIDENCE-MANIFEST.json` and `supplement/EVIDENCE-ROWS.md` were
  regenerated with `package_evidence_bundle.py --write`, because the manifest
  hashes the two supplement files just edited, and the release-manifest local
  PDF rows were refreshed with `verify.py --write-local-manifest`.

## Page budget

The TIT submission build now stands at 49 of its 50-page gate, one page of
headroom.  Any further printed mathematics in this appendix needs either a
compression pass or a decision about the gate.  Flagging rather than acting.

## Closing audits

Two of the specification's five audits were run here in full.

The characteristic audit is the script above: every Lucas support recomputed
from the Pascal row rather than the prose, including the redundancy-nine
characteristic-five object that E3 corrected, which is the point `P<e4>`.

The regression audit is a diff of the whole task against the pre-task commit
`a0868c26e`.  Outside the Lucas-carriers section the only changes are the six
citation locators, the terminal-carrier sign sentence, the Aubry--Perret
sentence, the redundancy-nine modular-lift statement with its added row
computation, and the literature-audit row.  Inside it, the only removed text is
the two passages E2 and E1 replace.  No other equation, field range, orbit size,
support basis, hypothesis, or citation-backed conclusion changed; in particular
the Kaipa--Pradhan denominator diagnosis, the algebraic-closure convention in
the geometric-coefficient-field proposition, and the `q = 7, 8, 9` radius status
are untouched.

The theorem-dependency audit, the hostile redundancy-ten re-derivation, and the
primary-source citation audit remain for a second reader.  Running them against
my own edits would not be an independent check, and the third one in particular
means reopening Kaipa 2017, the earlier projective Reed--Solomon classification,
Kaipa--Pradhan, Aubry--Perret, Gmainer--Havlicek and Wang--Wu--Hu at theorem
level.  This task verified the Blokhuis--Pellikaan--Szonyi locators against the
published article directly and the Aubry--Perret usage against its stated
hypotheses; the rest were last checked in the C885 full review.

## Adjacent observation, not part of the package

`sections/09-lucas-carriers.tex` invokes Hasse--Weil in the rank-two
Artin--Schreier descent after calling the cover "the smooth double cover", while
the sentence two lines earlier concludes only that the cover is geometrically
integral with at most two reduced simple poles, hence of genus at most one.  The
smoothness needed for Hasse--Weil there is asserted, not proved.  The referee did
not flag it; the same Aubry--Perret substitution used for E6 would remove the
dependence at no numerical cost.  Raised for a decision rather than edited.
