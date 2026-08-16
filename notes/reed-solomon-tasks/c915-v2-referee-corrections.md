# C915 — beyond-redundancy-four PRS Version 2 referee correction package

**Lane**: `reed-solomon`

**Date:** 2026-08-16

**Status:** in progress.  The four local edits E3--E6 are applied, verified, and
committed.  The two S1 proof repairs E1 (characteristic-two R10 transverse proof
for the R10 fixed-depth escape proposition) and E2 (all-field complement argument
in the recursive-carrier theorem cited as D.10) are open.

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

## Validation

Both manuscript builds pass warning-free after the edits: `make check` (canonical,
64 pages) and `make tit-check` (TIT single-column, 45 of 50 pages).  No undefined
reference or citation.  The specification's full post-edit checklist and its five
closing audits are deferred until E1 and E2 are done, since both touch the same
theorem chain.

## Open

- **E2 (S1)** --- expand the all-field complement argument in the recursive-carrier
  theorem rendered as D.10.
- **E1 (S1)** --- supply the self-contained characteristic-two transverse proof for
  the R10 fixed-depth escape proposition rendered as D.12, covering all eight
  sub-facts the current paragraph asserts.
- Full post-edit checklist and the five closing audits.

## Adjacent observation, not part of the package

`sections/09-lucas-carriers.tex` invokes Hasse--Weil in the rank-two
Artin--Schreier descent after calling the cover "the smooth double cover", while
the sentence two lines earlier concludes only that the cover is geometrically
integral with at most two reduced simple poles, hence of genus at most one.  The
smoothness needed for Hasse--Weil there is asserted, not proved.  The referee did
not flag it; the same Aubry--Perret substitution used for E6 would remove the
dependence at no numerical cost.  Raised for a decision rather than edited.
