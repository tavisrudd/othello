# C897 Paper III first sealed cold-read synthesis

**Lane:** `clebsch`

**Date:** 2026-08-09

**Status:** first sealed batch complete at overall **MAJOR**; C897 remains
active as remediation and sealed-regrade owner

## Frozen review surface

The batch manifest is
`notes/2026-08-09-c897-paper-iii-first-batch-manifest.md`.  All four reads used
standalone commit `7208275e6b5f979fea487d2130943bbd979aed37`, the clean
thirty-page PDF with SHA-256
`6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`,
and persona dossier SHA-256
`12fd05f3ace288282075432a303214ea37d606b658e9967540e4b316efe7f8f8`.

Each reader froze a PDF-only report before consulting the permitted
supplement.  No reader received a lane handoff, task card, ordinary Paper III
notes, prior review, or another persona report.  The coordinator opened no
report until all four were frozen.

The report files and final SHA-256 hashes are:

- Hitchin:
  `notes/2026-08-09-c897-paper-iii-hitchin-cold-read.md`,
  `1bd3d4d861f5dc68763e952337dcc3d77bb94d31bada375f0d9767abca232e54`;
- Greaves:
  `notes/2026-08-09-c897-paper-iii-greaves-cold-read.md`,
  `e66afb4a80bcbfa37accfbbd423ff468f406ccfa29cf01b9927d8d5553608fde`;
- Snowden:
  `notes/2026-08-09-c897-paper-iii-snowden-cold-read.md`,
  `b443f8f6c0bab4b0713015b37e1f667d3e9d42efc9a8208179a7156ecdc3cd52`;
- Si Kaddour:
  `notes/2026-08-09-c897-paper-iii-si-kaddour-cold-read.md`,
  `0e2c80fed71899059d0c046e00edf08fe175d4910f127f08c710504193b83de2`.

All four reports contain categorical verdicts and no numerical grades.

## Independent verdicts

| persona | verdict | earliest unsupported implication |
|---|---|---|
| Hitchin | **MAJOR** | Section 2.3 promotes Hitchin's real/complex geometric count and sextic locus to the exact reduced branch divisor of the rational finite Stein cover without a finite-flat local ramification or discriminant argument. |
| Greaves | **MINOR** | Table (5.1), row `r=2`, does not follow from the printed transport rule: six signs are wrong, breaking both the four-point identity and `sum_T Z_T=0`. |
| Snowden | **MINOR** | Theorem 5.5(1) compresses the nonformal complementary-minor/triangle-holonomy bridge into “two dihedral representatives and complementation” without stating the orbit reduction or representative calculations. |
| Si Kaddour | **MINOR** | The reconstruction proof itself closes; the first unsupported imported step is Remark 5.4's unconditional use of Holtz--Sturmfels Theorem 6 without its strict nondegeneracy hypothesis. |

The batch verdict is **MAJOR** because the Hitchin finding is a premise of the
headline arithmetic equation, not an isolated secondary branch.  Three
section-local MINOR verdicts do not average away one load-bearing MAJOR.

## Convergent findings

### 1. The rational Stein equation is not proved at printed strength

The manuscript constructs a rational incidence model and has a credible
generic degree-two count, but it does not prove that the normalized finite
cover is ramified with multiplicity one exactly on the reduced divisor
`J_0=0`, nor that the fibre at `xyz` lies in a finite etale neighbourhood and
is the complete reduced fibre.  The cited Hitchin papers do not supply those
rational scheme-theoretic conclusions.  These missing implications feed the
square-class form, the specialization to `[5]`, and the global algebra
`O plus O(-3)` with `z^2=5J_0`.

The exact scale of `J_0` is a second load-bearing issue.  Hitchin's analytic
surface-integral invariant and the appendix calculation after rescaling to
`lambda=4` are not shown to be the same rational polynomial normalization.
The paper needs one internal rational definition and separate proofs of its
relation to the analytic sign invariant and its exact Clebsch pullback
`16 sigma_3^2`.

The supplement confirms that both matters remain human boundaries.  It does
not repair either proof.

### 2. Table (5.1) has a real six-sign error

Greaves independently transported all six words and found that the printed
row for `r=2`, `p=012435`,

```text
-+-+---++--++-+-+-+
```

must be

```text
-+-+---++--+++-+-+-
```

with the entries at `135,145,234,235,245,345` reversed.  The printed row
fails the four-point two-graph identity on eight four-sets and leaves six
nonzero coefficients in `sum_T Z_T`; the corrected row passes both tests.
The theorem's intended outer frame is present in the formal map, so this is a
local manuscript and release-comparison repair, not a collapse of the outer
construction.

### 3. The conference, exchange, and reconstruction mathematics survives

Greaves independently reproduced the determinant fibre and every design
parameter, the closed-four-walk coefficient `32c_Y`, the second exchange
moment and variance, and the order-ten `36/90` cut split.  There is no
determinant-fibre reversal, inclusion-rank mismatch, or unrealized-order
mistake in the assigned theorem.

Si Kaddour found the seven-point complement convention fully propagated: a
triple in every six-point overlap forces adjacent local bits to agree, and
Johnson-graph connectedness makes the bit global.  The fixed nonadaptive and
adaptive query models are distinguished correctly, and the current benchmark
wording accurately separates the ordinary-graph four-local theorem from the
arbitrary three-uniform-hypergraph threshold five.

### 4. The remaining human-proof and exposition repairs are local

The complementary-minor/triangle identity is true in all twenty cases, but
its printed proof needs the actual dihedral orbits and representative
computations, or a uniform pentagon-gauge determinant calculation.
Holtz--Sturmfels needs its strict hypothesis stated and checked, or the paper's
own elementary order-three-minor argument should carry the claim.  The
adaptive decoder needs one displayed rooted-xor identity.  At first use,
“aligned” should be translated as the union of coherent and incoherent
four-set types.

## Conflicts and coordinator resolution

### Printed outer row

Greaves and Snowden disagreed on whether Table (5.1) already contains the
correct `r=2` word.  Their computations do not disagree: Snowden computed
exactly Greaves's corrected string, but then called it the printed row.  The
frozen source at `sections/05-golden-operator.tex:62` contains Greaves's bad
printed string.  Greaves's verdict on this point is therefore accepted.

This is a useful failure of the sealed design: an otherwise strong outer-
invariant-theory read missed the final source comparison, while the
conference-design reader's parity and linear-relation tests caught it.

### Cross-golden sign

Snowden considered the marked convention sufficient to remove normalization
ambiguity.  Greaves observed that the theorem still prints
`Z_T=plus-or-minus 10 sqrt(5) det B_T` immediately after saying that the two
determinant lines are oriented.  The mathematical determinant-line mechanism
is accepted, but the printed theorem does not state which transported
orientation selects which sign.  This remains an exposition/normalization
clarification, not a second MAJOR.

### Headline arithmetic theorem

The three MINOR readers did not audit the rational branch argument at Hitchin
packet depth.  Their neutral summaries repeat it as an input; they provide no
independent evidence against the Hitchin MAJOR.  There is no true
cross-persona conflict here, only deliberately different scopes.

## Repair routing

The first sealed batch made no manuscript, Lean, trust, release, or mirror
change.  By explicit author instruction after the synthesis, C897 itself owns
all remediation and the sealed regrade; none of these findings is handed to a
successor task.

1. C897 must close the rational finite-flat
   branch calculation, reduced `xyz` fibre, and exact rational `J_0`
   normalization.  These are statement-strength obligations, not candidates
   for narrowing the theorem.
2. C897 owns the human manuscript repairs: the branch proof, corrected Table
   (5.1), expanded complementary-minor bridge, Holtz--Sturmfels hypothesis,
   aligned terminology, decoder identity, and a sharper separation of
   independent consequences.
3. C897 must compare all 120 printed table signs
   against the formal outer words and reconcile the manuscript appendix with
   the public formal-coverage map.  A generated table or a rejecting
   coefficientwise comparison is the natural regression gate.
4. No focused Haemers fifth read is triggered.  The Greaves packet already
   independently reproduced the exchange and design calculation and returned
   MINOR; the dossier's “survives but remains hard to assess” condition is
   false.

No new C-ID is allocated by this review.  C897 stays active until the
authoritative manuscript and verification surfaces are repaired, the intended
standalone changes are synchronized through the normal guarded chain, and the
fresh sealed regrade is clean.

## Advances-level significance and readability

All four readers judged the theorem package capable of meeting an *Advances in
Mathematics* significance bar after repair.  It does not currently clear a
submission gate: the rational cover equation is the arithmetic headline and
is underproved at scheme-theoretic strength.

The common marked source--shadow--return mechanism is visible, but the
balanced-exchange and four-local reconstruction theorems are independent
consequences rather than causal steps in the arithmetic-to-harmonic chain.
The abstract and roadmap should say that directly.  Three readers independently
called cross-field readability borderline; the remedy is hierarchy and one or
two expanded bridges, not more audit prose.

## `ej` + `tt` closeout

The cheap extra-value pass compared the reports at their exact disagreements
rather than counting verdicts.  It exposed the Table (5.1) error that one
specialist missed, identified the missing release comparison that allowed it,
and discharged the proposed fifth exchange read as unnecessary.

The Tao-style question is: which single implication would a skeptical reader
have to grant before the rest of the headline becomes inevitable?  It is not
one of the 120 signs or the exchange moment.  It is the local algebra showing
that the rational degree-two incidence field has reduced order-one branch
exactly `J_0=0`, together with the complete reduced golden fibre and one fixed
rational scale for `J_0`.  Those calculations should be isolated as named
lemmas before any further synthesis prose is polished.

No incidental discovery-track entry is created.  Every observation above was
an explicit target of the reviewer packets or the required cross-comparison.

## Mystery ledger

- **Open — reduced branch divisor.**  Evidence gap: no local differential,
  discriminant, or finite-flat ramification calculation at the generic sextic.
  Gate: a human algebraic proof at the exact rational scheme strength.
- **Open — complete golden fibre.**  Evidence gap: the two displayed geometric
  configurations are not yet shown to be the complete reduced fibre in a
  finite etale neighbourhood.  Gate: local quasi-finiteness, reducedness, and
  residue-algebra calculation at `xyz`.
- **Open — exact `J_0` scale.**  Evidence gap: no conversion between Hitchin's
  analytic normalization and the rescaled appendix polynomial.  Gate: one
  internal rational formula with both comparison identities.
- **Settled — outer table.**  The exact six-sign correction is known, and the
  parity and Segre-linear tests reject the printed row.
- **Settled — exchange/design constants.**  Independent recomputation agrees
  with the manuscript throughout the assigned range; no fifth specialist is
  needed.
- **Settled — complement propagation and query models.**  The seven-set
  overlap proof, sharp six-point failure, fixed-family count, and adaptive
  distinction survive the cold read.
- **Open — printed cross-golden sign.**  Evidence gap: the theorem retains a
  plus-or-minus after determinant-line orientations are declared.  Gate: state
  the transported orientation and selected sign, or explicitly retain the
  residual choice.
- **Open — article hierarchy.**  Evidence gap: adjacent readers still read the
  paper as one central chain plus two independent theorem packages without a
  sufficiently explicit hierarchy.  Gate: a repaired abstract/roadmap tested
  by a fresh geometric and combinatorial cold pair after the proof repairs.

No other genuine mystery remains inside the first sealed batch.
