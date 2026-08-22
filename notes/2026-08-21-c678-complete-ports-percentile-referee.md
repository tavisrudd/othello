# C678 complete repair ports — percentile referee assessment

Date: 2026-08-21

## Protocol

The referee read only the 20-page PDF with SHA-256
`73a8148f5f553d8c985e4c6ac821414573c12a495dbd99483c2b61f29edbda45`.
They did not inspect source files, notes, dossiers, Git history, or previous
reports. Percentiles compare the paper with published papers, not submissions.

Population A is annual work in the closest specialty: coding theory and local
repair with finite-geometry and matroid methods. Population B is annual
research mathematics as a whole, restricted to dimensions that transfer
meaningfully across fields.

## Bottom line

- Specialty overall: **75–85th percentile**, best estimate **81**, medium
  confidence.
- General mathematics overall: **58–72nd percentile**, best estimate **65**,
  medium confidence.

The referee judged the paper clearly publishable in its specialty. Its ceiling
is set by demonstrated impact and novelty, not correctness.

## Dimension scores

| Dimension | Specialty percentile | General-math percentile | Confidence |
|---|---:|---:|---|
| Correctness and rigor | 82–92; best 87 | 80–90; best 85 | Medium |
| Theorem novelty | 65–80; best 73 | 45–65; best 56 | Low–medium |
| Conceptual originality | 76–88; best 82 | 62–78; best 70 | Medium |
| Technical depth | 72–85; best 79 | 58–73; best 65 | Medium |
| Proof completeness | 85–94; best 90 | 83–93; best 88 | High |
| Significance within specialty | 66–80; best 73 | N/A | Medium–low |
| Breadth and general relevance | 60–75; best 67 | 48–65; best 57 | Medium |
| Exposition and organization | 78–89; best 84 | 76–88; best 82 | High |
| Examples and computational/formal support | 92–98; best 95 | 90–98; best 94 | Medium–high |
| Reproducibility and trust boundary | 88–96; best 92 | 87–96; best 91 | Medium |
| Overall paper strength | 75–85; best 81 | 58–72; best 65 | Medium |

## Referee rationale

The strongest feature is the exact theorem spine combined with an unusually
clean trust boundary. The exact weighted pointed-confinement theorem isolates
the zero-functional obstruction and nonzero functional-realization cost; the
eventual theorem turns this into necessity, sufficiency, and positive-density
realization. The geometric applications provide structured examples rather
than toy cases, and the formal layer reinforces the chain without absorbing
its named classical inputs.

The limiting factor is significance relative to the amount of machinery. The
port framework coherently unifies coefficient recovery, circuit clutters,
reliability, EXIT, and pointed-matroid structure, but the paper does not yet
derive a major new code bound, optimal construction, classification, or
operational tradeoff. The referee therefore viewed it as a polished synthesis
with several exact new theorems rather than a field-shifting result.

## Venue calibration

The referee considered the current paper a good fit for a solid-to-strong
specialist journal such as *Designs, Codes and Cryptography* or *Finite Fields
and Their Applications*. A combinatorics venue could fit if the geometric
inventories became more central. *IEEE Transactions on Information Theory*
was judged borderline without a sharper operational coding payoff. The paper
was not assessed as a top general-mathematics or flagship broad-combinatorics
paper in its present form.

## Highest-impact improvement

The largest percentile gain would come from a theorem showing that the
complete-port framework forces a new quantitative or structural consequence
unavailable from locality and availability alone: for example, a sharp bound,
classification, optimal reliability separation, or asymptotic phenomenon.
Short of that, narrowing the presentation around weighted transfer and the two
geometric inventories would strengthen the novelty-to-machinery ratio.

## Final referee characterization

**Mathematically sound and impressively audited; clearly publishable in the
specialty, with impact and novelty—not rigor—setting its present ceiling.**

## Prioritized upgrades that both unify and strengthen

The referee identified one intended program that the current paper contains
but does not yet make structurally dominant:

> finite geometry produces a represented port; weighted transfer embeds it at
> positive density; reliability, EXIT, and pointed-Tutte data then become
> asymptotic coding consequences.

The percentile lifts below are rough and non-additive relative to best
estimates 81 in the specialty and 65 across general mathematics.

### 1. Lift the finite pointed-Tutte separation asymptotically

- Expected lift: specialty +4 to +8; general mathematics +2 to +5.
- Effort/risk: low–medium effort; low–medium risk.
- Use the two represented rank-four F7 seeds from Proposition 6.3 with the
  transfer theorem to produce asymptotically good fixed-alphabet families.
- The designated positive-density coordinate classes should retain the same
  full pointed-Tutte data but have different radius-three reliability,
  `2s^3-s^6` versus `2s^3-s^5`.
- This is the highest-value revision because it joins transfer, reliability,
  the bounded filtration, and pointed-Tutte theory in one theorem.

### 2. Rebuild the narrative around one pipeline

- Expected lift: specialty +3 to +6; general mathematics +2 to +4.
- Effort/risk: medium effort; low mathematical risk.
- Organize the paper as port/coefficient reconstruction, exact transfer,
  bounded versus full pointed structure, geometric seeds, then reliability and
  EXIT consequences for transferred families.
- Sections 5–6 currently risk reading as parallel mini-surveys; they should be
  visibly downstream tools for the geometric and transferred ports.

### 3. Add a simultaneous-consequence bridge corollary

- Expected lift: specialty +2 to +4; general mathematics +1 to +3.
- Effort/risk: low effort; very low risk.
- Collect the consequences already implicit in Theorems 3.1 and 4.1: transfer
  of every smaller support filtration, normalized decoder, matching and
  transversal data, blocker leading terms, multivariate reliability, and
  bounded-EXIT differences; at full radius, include the pointed-Tutte
  specialization.
- This would state the actual payoff of transferring a complete port in one
  named result.

### 4. Make the geometric contrast an asymptotic reliability theorem

- Expected lift: specialty +3 to +6; general mathematics +1 to +4.
- Effort/risk: medium effort; low risk if confined to existing blocker data.
- Transfer the cubic target's high failure order and the quartic curve
  target's compulsory-helper failure order to positive-density coordinate
  classes in asymptotically good families.
- The strongest version matches or controls global rate and distance, turning
  the two flagships into opposite ends of one construction theory.

### 5. Add a concrete support-versus-coefficient separation

- Expected lift: specialty +3 to +6; general mathematics +2 to +4.
- Effort/risk: medium–high effort; medium risk.
- Exhibit same-parameter represented MDS codes with identical minimum support
  ports but inequivalent normalized coefficient ports, preferably with
  different functional-cost spectra or weighted-transfer behavior.
- This would connect the opening reconstruction theorem directly to the
  operational transfer theorem.

### 6. Compute coefficient fibers for one geometric flagship

- Expected lift: specialty +2 to +5; general mathematics +1 to +3.
- Effort/risk: medium–high effort; medium risk.
- Give normalized repair equations or a symmetry classification for the
  completed cubic-axis or quartic-nucleus seed.
- The geometry sections would then illustrate the coefficient-level thesis,
  not only support-clutter diversity.

### 7. Cut classical material not used downstream

- Expected lift: specialty +2 to +4; general mathematics +1 to +2.
- Effort/risk: low–medium effort; low risk.
- Move standard deletion-contraction, pivotality, and Russo-Margulis proofs to
  an appendix or cite them after proving only the paper-specific form.
- Move the beta-integral/area identity unless it is applied, and compress the
  general Las Vergnas derivation to what Proposition 6.3 uses.

### 8. Clarify novelty and reduce certificate bulk

- Expected lift: specialty +2 to +5 for literature positioning; +1 to +2 for
  moving bulk. General mathematics +1 to +3.
- Separate new theorems, new interpretation, classical inputs, and formal or
  computed evidence in a contribution ledger.
- Move the 35-entry determinant rows and most terminal-name inventories to
  supplements while retaining matrices, dependent sets, hashes, and the trust
  boundary in the paper.

### High-upside directions

1. Construct matched asymptotically good families with the same conventional
   local data and full pointed-Tutte profile but different bounded reliability
   or cheapest-repair distributions. Estimated lift: specialty +7 to +12,
   general mathematics +4 to +8.
2. Prove geometry-to-reliability tunability over a fixed characteristic-three
   alphabet, ideally matching global rate and distance while producing a
   `p^(q-1)` versus `p` local-failure contrast. Estimated lift: specialty +6
   to +10, general mathematics +3 to +7.

### Referee's three-step strategy

1. Prove the asymptotic lift of Proposition 6.3.
2. Rebuild the manuscript around the seed-to-transfer-to-stochastic-consequence
   pipeline, add the simultaneous-consequence corollary, and cut unused
   classical calculus.
3. Turn the geometric contrast into an operational positive-density
   reliability theorem, matching global parameters if feasible.

The referee emphasized that further formalization, finite tables, or general
reliability identities would not materially raise the paper's ceiling. A
single asymptotic separation theorem unifying the existing modules would.
