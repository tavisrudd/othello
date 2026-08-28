# C973 — review closeout, extra-juice/Tao pass, and mystery ledger

**Lane:** reed-solomon
**Date:** 2026-08-28
**Status:** acceptance rule 8 (independent review) discharged; rule 9 (this
closeout) discharged; paper-successor handoff is the only remaining action

## 1. What the day changed

1. GF(27)/R11 was the last open modular field.  A bounded calibration of the
   two-point affine-plane switch found at least 78 good switches on every
   rank-at-most-one quotient class and identified the extremal orbit as the
   translation orbit of `e_3`.  With user authorization under the C578 `q=64`
   precedent, a full sweep of all 402,321,277 projective classes then closed
   GF(27) at certificate level; the sweep is pointed for free and lifts to
   characteristic-three R12.  `c973-2026-08-28-gf27-switch-probe.md`.
2. Three independent cold reads (geometry, finite-field selection, coding
   promotion) were run and their findings applied:
   - the containment theorem is strengthened to (15'):
     `SplitFree_r(F_q) subset P_r(F_q)` for odd `p` and for `p=2, r>=8`, with
     the maximal Lucas carrier retained only at binary `r in {6,7}`; binary R11
     closes at `q>=56`, so GF(64) is closed by theorem;
   - the one proof gap (level-uniform coherent-Fano induction) is a citation
     repair to C536 §2 (5)--(7), with an algebraic-closure caveat;
   - the GF(64) trace-balance note had two arithmetic errors and one overclaim;
     it is repaired and downgraded to "forced-root surface closed", which no
     longer matters for closure because (15') covers GF(64);
   - the GF(16)/GF(32) certificates used a non-equivariant truncated R10
     action; both are rebuilt under the degree-ten action with fail-closed
     equivariance checks, and the conclusions are unchanged (GF(16) degrees
     315/2, not 307/10).

## 2. Extra juice

- **Free:** (15') retires the GF(64) trace-balance programme as a closure
  route and removes the carrier term from the headline for every odd
  characteristic.  The paper-successor map should present the theorem in the
  (15') form and demote the trace-balance material to an independent partial
  audit.  Done in the notes; the successor owns the manuscript.
- **Free:** GF(27) pointed avoidance and characteristic-three R12 follow from
  the existing sweep outputs with no computation.  Recorded in the probe
  report §8.1.
- **Cheap, not done:** fold an implementation-independent replay into the
  `q=49` characteristic-seven bundle (the seven records were re-verified from
  scratch during review; the bundle's own replay still calls the toolkit).
  Successor item.
- **Doors opened:** the four planes through any affine `F_3`-line are
  canonically indexed by `lambda in {1} cup roots(lambda^3+lambda^2+lambda+2)`,
  so every pencil has Frobenius type `1+3`.  The conjugate triple alone
  saturates every class measured and the distinguished plane never does on the
  extremal orbit.  This is the handle a structural switch proof would use.

## 3. Tao pass

- *What is the actual theorem now?*  Split-free directions at redundancy `r`
  above the threshold are persistent, full stop, except binary `r in {6,7}`.
  The earlier "persistent plus maximal Lucas carrier" statement carried two
  layers of slack (the carrier term and `V(D)` being a counting failure, not a
  witness failure).  The successor should say so in one sentence.
- *Is the threshold sharp?*  No evidence either way.  GF(49) at R11 sits below
  `Q_11=63` and is closed only by certificate; GF(27) below 63 likewise.  A
  sharpness study is a new task, not this one.
- *Where does the structure actually live?*  The `e_3` witness inventory
  shows 6,890 closing nine-sets, of which only 78 are plane switches and none
  are planes or three-line unions; the witnesses are overwhelmingly
  non-additive.  A certificate-free GF(27) proof should look for a
  multiplicative or Frobenius-twisted support family (discovery track,
  2026-08-28).
- *What would a referee still ask?*  Primary-source verification of the
  Seroussi--Roth and Dür hypotheses as invoked (the reviewers checked the
  arithmetic, not the sources), and the `q=49` replay independence.

## 4. Mystery ledger

| Item | Status after this pass | Evidence gap or owner |
|---|---|---|
| Why is `e_3` the unique extremal orbit for the switch count? | open | translation-invariance explains the orbit; no proof that 78 is the minimum |
| Why 78 = 3 free torus orbits, one per conjugate plane? | settled as data, open as theorem | the Frobenius `1+3` pencil type is the visible mechanism |
| Why does the `lambda=1` plane never switch on the extremal orbit? | open | all 156 split candidates collide off-line; no structural reason recorded |
| Is the containment threshold `Q_r` sharp? | open | GF(27), GF(49) below threshold are certificate-closed only |
| Does the `49>48` GF(64) coincidence mean anything? | settled: no | unrelated provenance (Finding-1 verification note) |
| Are the trace-balance note's off-surface strata closable by its own route? | open, moot for closure | `B_3D=0` and the slope-pencil failures on `e_4,e_5,e_7`; covered by (15') |
| Is the level-uniform polar lemma true over finite fields pointwise? | settled: false over `F_2` | `g=e_1+...+e_{n-1}`; quote over the algebraic closure only |

No genuine mystery blocks closure.

## 5. Successor interface

The paper-integration successor (to be reserved) receives:
`c973-2026-08-26-paper-successor-map.md` (updated for evidence levels),
the strengthened statement (15') and pointed (17') in
`c973-2026-08-26-simultaneous-marker-theorem.md`, the three review reports,
and the open items above: primary-source verification of Seroussi--Roth/Dür,
`q=49` replay independence, and the optional certificate-free GF(27) switch
lemma.
