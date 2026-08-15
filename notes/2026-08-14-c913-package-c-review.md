# C913 Package C review — hypothesis architecture vs current draft

**Lane**: `clebsch` · **Date**: 2026-08-14 · **Scope**: read-only review of
remediation Package C against the full current draft of
`papers/cubic-stabilization-irrationality/`, cross-checked against referee
Majors 1 and 2 from the most recent cold read.

## Numbering map (verified against section order)

Definition 8.1 = `def:gauged-admissible`; Remark 8.6 = `rem:neutral-boundary`
(Aleshkin–Liu / González–Woodward boundary); Theorem 8.7 =
`thm:tailwise-derived`; Remark 8.9 = `rem:two-tail-threshold-obstruction`;
Definition 8.10 = `def:finite-dual-cyclic-rees`; Hypothesis 8.11 =
`hyp:marked-threshold`; Theorem 8.14 = `thm:birational-point-primary`.
Referee's Major 1/2/3/4 targets match these labels exactly.

## Bullet-by-bullet status

### C1 — separate assumptions + one-paragraph clause account: HALF DONE

Done: the two inputs are separated at every headline site. The abstract, the
statement of Theorem 1.1 (`thm:intro-cubic-conditional`), Theorem 1.3
(`thm:intro-birational-conditional`), Theorem 8.14, and scope item (7) all
name gauged-admissibility (Definition 8.1) and marked threshold compatibility
(Hypothesis 8.11) as distinct hypotheses.  Definition 8.1 closes with "These
are assumptions on the gauged completion, not consequences of smooth
projectivity alone."

Missing: the one-paragraph account of which clauses are standard
gauged-theory conditions versus genuinely open.  Referee Major 2(ii) asks for
exactly this ("which of conditions (i)–(iii) are expected from existing
properness results for gauged maps versus genuinely open").  Neither the
introduction nor Section 8 discusses the clauses individually.  Proposed
labeling for the author to confirm (do not let me over-claim on Woodward's
properness scope):

- (iii) numerical separation + pointed infinity-side semigroup: mild;
  expected from equivariant projectivity of the completion (ample equivariant
  divisors separate degrees).  Closest to provable-in-general.
- (ii) proper DM polarization master stacks with Woodward's relative POTs and
  coefficientwise large-area localization: expected from Woodward's
  properness/localization theory at sufficiently large area, but not proved
  at this generality for an arbitrary Włodarczyk completion — the real
  frontier clause.
- (i) stable = semistable + free extreme quotients: a genuine position
  assumption on the chosen completion/polarizations; standard genericity in
  VGIT but not automatic for the completion Włodarczyk hands us.
- (iv) the marked class: constructed via the orbit cylinder (this is why the
  referee's Major 2 says "(i)–(iii)"), but its proof is the target of
  Major 3, owned by Package D.  Keep the Package C sentence consistent with
  whatever Package D does there (lemma vs fold into admissibility).

### C2 — displayed, named implying conjecture: NOT DONE

The one-object Gamma/window comparison exists only in prose, in the paragraph
after Hypothesis 8.11 ("A one-object Gamma/window comparison compatible with
all structures in Hypothesis 8.11 would imply it: a window mutation is
supported on the wall, whereas the skyscraper of a point in the common open
is unchanged and Euler-orthogonal to wall-supported objects").  Referee
Major 1(b) confirms this gap verbatim.  Required:

- Add a `conjecture` theorem environment to the preamble (none exists).
- Display a named conjecture (e.g. "Marked Gamma/window continuation") and
  label it explicitly as a conjecture new to this manuscript, not sourced
  from the literature (remediation requirement).
- Two clauses mirroring the hypothesis split (see Major 1 below): at each
  sign/stability threshold a one-object window-type comparison in the fixed
  common input-and-derivative frame carrying the marked row; at each
  zero-mode threshold a marked meromorphic family whose window comparison
  degenerates to the strict reduced-nearby-cycle specialization.  The
  existing prose implication argument (wall-supported mutation ⊥ common-open
  skyscraper) becomes a short displayed proof that the conjecture implies
  Hypothesis 8.11; the zero-mode clause of the implication needs the
  meromorphic family explicitly (draft already notes the zero-mode unproved
  assertion has two parts, after the hypothesis).

### C3 — endpoint-only form: NOT DONE

No statement anywhere that Theorem 1.1 needs the two inputs only for
birational maps `X × P^m ⇢ P^(m+3)`.  Referee Major 2(i) asks for this at
Definition 8.1.  Quantifier care for the edit:

- Correct form: for every m ≥ 0 and **every** birational map
  `φ: X × P^m ⇢ P^(m+3)`, **some** Włodarczyk completion of φ is
  gauged-admissible and satisfies Hypothesis 8.11.  Rationality supplies an
  unknown map, so the universal quantifier over maps with these endpoints
  must stay; only the quantifier over endpoint pairs is dropped.
- Anti-vacuity (acceptance gate 3): say plainly that the family is still
  infinite (all m, all maps between the fixed endpoints, all Artin levels,
  degrees, neutral directions, thresholds); the weakening is material, not
  trivializing.
- Placement: numbered remark or corollary directly after Definition 8.1
  (where the referee asked), one sentence in the introduction after
  Theorem 1.1, and one sentence in the abstract (the referee explicitly
  flags the abstract's "every smooth projective birational map"
  quantification).

## Major 1 (pasted mid-review) — also Package C material

Referee's minimal fix: split Hypothesis 8.11 into 8.11a (sign/stability
thresholds) and 8.11b (zero modes), plus a short remark stating the implying
conjecture and the verification obstruction.  Assessment:

- The split is not in Package C's text but is fully compatible with it and
  cheap: the current hypothesis runs ~90 source lines with the zero-mode
  machinery (var/can triangle, `V_t` saturation, reduced nearby cycles,
  strict specialization) inlined.  The `V_t`/reduced-nearby-cycle
  construction can be factored into a definition beside Definition 8.10,
  leaving 8.11b short.  Downstream references to update: Lemma 8.13
  (finite threshold gluing — its proof already treats the two threshold
  types in separate sentences, so it splits cleanly), Theorem 8.14's proof,
  scope item (7), abstract, and the introduction's global-transport
  paragraph.
- Major 1(c) (verification status/obstruction remark): the content already
  exists but is scattered across Remark 8.6 and the two calibration
  paragraphs after Hypothesis 8.11.  Consolidate into one named remark:
  verified — the crepant-toric neutral calibration (Coates–Iritani–Jiang
  gauge + Woodward's I-function identification) at the QDM/I-function level,
  and the nonneutral blowup marking calibration; obstruction — no one-object
  comparison is known in the fixed common input-and-derivative frame on an
  actual Włodarczyk master (even the rank-two-torus → rank-one-cobordism
  reduction for the blowup is itself the missing common-frame comparison);
  Aleshkin–Liu is linear-abelian with window data the nonlinear fixed graphs
  do not carry; González–Woodward is distributional without a convergence
  input.  All four points are already in the draft's prose — this is
  consolidation, not new mathematics.
- Keep the non-goal guard: the remark must not present either calibration as
  a verification of any instance of 8.11 for a projective master (draft is
  currently careful about this; preserve the "calibrates conventions, not an
  instance of the load-bearing neutral hypothesis" sentence).

## Ordered edit plan (for the implementation pass)

1. Preamble: add `\newtheorem{conjecture}[theorem]{Conjecture}`.
2. Split Hypothesis 8.11 → 8.11a/8.11b; factor the `V_t` construction into a
   definition; update Lemma 8.13, Theorem 8.14 proof, scope item (7).
3. Displayed named conjecture + short implication proof, replacing the
   prose-only paragraph.
4. Consolidated verification-status/obstruction remark (Major 1(c)).
5. Endpoint-only remark after Definition 8.1 + intro sentence + abstract
   sentence (Major 2(i), C3), with the quantifier form above.
6. Clause-status paragraph for Definition 8.1(i)–(iii) in the introduction
   or directly after the definition (Major 2(ii), C1) — author to confirm
   the expected-vs-open labels before they go in.

Renumbering ripple: the split shifts every 8.x label after 8.11; the
revision letter should carry an old→new map for the referee.

## What Package C does NOT owe

Majors 3 and 4 (orbit-cylinder lemma; Theorem 8.7 expansion/appendix) are
Package D. Nothing in the above changes the theorem architecture, so no
author-approval gate under acceptance point 4 is triggered by Package C
itself — except the expected-vs-open labels in item 6, which need Tavis's
sign-off as they are mathematical judgments about unproved properness scope.
