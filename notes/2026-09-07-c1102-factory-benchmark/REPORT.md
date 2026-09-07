# C1102 — A bounded operational advantage for the Clebsch cubic resource

Date: 2026-09-07. Lane: `clebsch`. Status: **benchmark acceptance gate passed**;
the separate literature gate remains open, so this is a research report, not manuscript text.
The user's “do it” authorizes this bounded benchmark and the sharper paper structure proposed
in the preceding discussion. It does not launch exact Waring-rank or automorphism searches.

## Result

For the six-qudit resource `|F_7>`, compare the native fourteen-input factory with independent
single-qudit cubic distillation followed by phase-polynomial synthesis. Give the latter the
choice of three explicit Reed–Solomon distillers and arbitrary concatenations of them.
For every `0 < δ ≤ 0.01`, at the **same target block infidelity** achieved by the native
factory:

- With the native factory's **sign-only raw resources**, every separate construction in
  the specified menu costs at least **54** raw resources per output, versus at most
  **16.116** for the native factory: a factor **greater than 3.35**.
- Even granting all weighted cubic types the same unit raw cost, the separate construction
  costs at least **36**: the native advantage remains a factor **greater than 2.23**.
- Feasible separate constructions are supplied, not merely lower bounds. At `δ=0.01`,
  the explicit thirteen-term synthesis after seven-to-one distillation costs **97.633**
  sign-only inputs and meets the target. With the more generous weighted supply, four-to-one
  distillation costs **54.128** and also meets it.

No exact Waring rank is needed. The existing `9 ≤ r(F_7) ≤ 13` bracket decides the comparison.
These are expected **raw cubic-resource counts**, not physical gate counts, latency estimates,
or a claim against unrestricted magic-state protocols.

## 1. Precisely what is compared

Common assumptions: independent input states
`ρ_c=(1-δ)|M_c><M_c|+(δ/6)Σ_{e≠0}Z(e)|M_c><M_c|Z(-e)`, `p=7`,
`M_c|x>=ω^{c x³}|x>`, and ideal stabilizer preparation, Clifford circuits, measurements,
feed-forward, and storage. Nonzero labels are uniform as an explicit noise assumption.
The target is the whole six-qudit `|F_7>` resource; error means block infidelity, not an
error rate per output qudit. Both architectures may retry failed distillation attempts.

The baseline first produces **independent single-qudit cubic resources**, using any of the
modules below and any finite concatenation. It then performs deterministic linear-form
cubic synthesis, with Clifford compute/uncompute and no final postselection. Successful
primitive outputs can be retained individually: the cost is a sum of expected module costs,
not an artificial simultaneous-success penalty. Nonuniform choices of module/concatenation
for different synthesis terms are allowed by the lower bound.

Two resource supplies are distinguished:

1. **Sign-only:** raw `M_1` and `M_-1` states, interconverted by coordinate negation, exactly
   as in the C1090 native protocol. The weighted four-site module below is implemented with
   eight raw injections because `M_3` and `M_-3` each use three sign-only injections.
2. **Weighted relaxation:** every `c≠0` is available with the same raw cost and input error.
   This deliberately favors the baseline; the native factory still uses only signs.

This menu excludes pooled multi-output distillers, joint synthillation, general adaptive
synthesis with final postselection, and circuit-level fault models. The claim is explicitly
about the stated separate architecture, not an optimum over all stabilizer protocols.

## 2. The three baseline modules

In a CSS code, let `S` be the X space and `L=S+<ell>` the evaluation space. An injected
physical weight vector `w` has logical phase `Σ_i w_i(a_i+u ell_i)^3`.
The script checks `Σ_i w_i s_i b_i c_i=0` for every basis triple from `S,L,L`, and checks
that the remaining logical coefficient is `-1`. Coordinate negation supplies `+1`.

| Module | Evaluation points | X space `S` | Logical row `ell` | Physical cubic coefficients | `[[n,1,d]]_7` | Leading primitive error |
|---|---|---|---|---|---|---|
| Weighted four-to-one | `0,1,2,3` | `<1>` | `x` | `(-1,3,-3,1)` | `[[4,1,2]]` | `δ²` |
| QRM six-to-one | `1,2,3,4,5,6` | `<x>` | `1` | all `1` | `[[6,1,2]]` | `(5/2)δ²` |
| RS seven-to-one | all `F_7` | `<1,x>` | `x²` | all `1` | `[[7,1,3]]` | `(35/36)δ³` |

The four-site identity is the third finite difference: its weights kill degrees 0, 1, 2
and give `6=-1` on `x³`. The six-site module is Campbell–Anwar–Browne's `QRM_7(1)`;
the seven-site code is the C1099 Reed–Solomon benchmark. The four-site module is used as an
elementary weighted-evaluation comparator; no novelty claim is made for any module.

For every module, an error `e` is accepted exactly when `e∈S^⊥`, and is harmless exactly
when `e∈L^⊥`. Direct enumeration and independent MacWilliams transforms agree on both
enumerators. Nonzero logical error labels have equal probabilities because multiplying all
physical error labels by a nonzero field element preserves their joint distribution and
permutes the logical labels. This remains true for the unequal physical error rates in the
sign-only implementation of the four-site module.

Three raw injections compose to error
`δ_3=(6/7)[1-(1-7δ/6)^3]`. Thus that implementation uses physical rates
`(δ,δ_3,δ_3,δ)`, costs `8/P_acc`, and is **not** silently assigned the four-input error formula.

## 3. The lower bound that makes exact Waring rank unnecessary

### An unpurified synthesis term cannot hide its error by cancellation

For a nonzero linear form `a·u`, injection noise is a random logical Pauli `Z(ea)`.
For `δ≤0.01`, its largest probability mass is `1-δ`. The final label is the sum of these
independent labels. For probability measures on the additive logical-label group,

```
||μ*ν||_∞ ≤ ||μ||_∞.
```

Indeed, each convolution value is an average of values of `μ`. Consequently, if any
synthesis term uses an unpurified raw input, the final probability of the zero error label
is at most `1-δ`, even allowing cancellations and a fixed Pauli correction. The `Z(eta)|F>`
states are orthogonal because cubic-phase states have uniform computational amplitudes.
Therefore the final block error is at least `δ`.

Below we prove that the native target is strictly less than `δ` on the whole interval.
Every baseline synthesis term must therefore be purified. Each independent purification
tree consumes at least four raw leaves in the weighted relaxation, or six in the sign-only
menu; retries only increase this. C1090's Waring lower bound requires at least nine terms.
The baseline costs are consequently at least `4·9=36` and `6·9=54`, respectively, regardless
of the chosen decomposition, mixed module assignments, concatenation depth, or cancellations.

**Clifford-frame strengthening.** A final Clifford may also be allowed when the state before
it is a homogeneous cubic-phase state on the same six qudits. The Pauli-modulus histogram
is Clifford invariant, and recovers `N_r` by dividing the multiplicity of `7^{-r/2}` by
`7^r`. Thus any such cubic preimage has the same minimum Hessian rank and the same eight
projective minimum-rank points. The C1090 argument excluding rank eight applies unchanged:
rank eight would require 56 such points. Hence the nine-term lower bound survives this
Clifford-frame freedom. This does not claim an arbitrary ancilla-assisted circuit lower bound.

For a weaker entirely local check, the script verifies rank six of the first-derivative
flattening. Even replacing nine by six leaves a positive weighted-menu advantage, a factor
greater than 1.48. The stronger numerical factor uses the banked census-based bound.

## 4. Proof on an interval, not just at sample points

Write `a=1-δ`, `P=P_native`, and `q=q_native`. All one-error events are rejected. All
accepted weight-two events are harmful, with total probability `(91/6)δ²a^12`.
For any specified support of size at least two, the last nonzero error label is determined
by the sum-zero acceptance check, so at most one of its six possibilities can accept.
The union bound on pairs therefore gives

```
a^14 ≤ P ≤ 1-14δa^13,
(91/6)δ²a^12/P ≤ q ≤ (91/6)δ²/a^14.
```

For `0<δ≤1/100`, Bernoulli's inequality gives

```
a^12(1+14δa) ≥ (1-12δ)(1+14δ-14δ²)
             = 1+δ(2-182δ+168δ²) ≥ 1.
```

Hence `a^12 ≥ 1-14δa^13 ≥ P`, yielding `q ≥ (91/6)δ²`. Also
`q/δ ≤ (91/600)/(0.99)^14 < 1`. This proves the below-raw target condition.
Native expected consumption satisfies

```
C_native=14/P ≤ 14/(0.99)^14 < 16.116.
C_separate/C_native ≥ 36(0.99)^14/14 > 2.23     [weighted supply],
C_separate/C_native ≥ 54(0.99)^14/14 > 3.35     [sign-only supply].
```

Feasibility at the same target also holds over the interval. For the four-site weighted
module, `q_4≤δ²/a^4`, so thirteen such primitives give final error at most
`13δ²/(0.99)^4 < (91/6)δ² ≤ q`. For the seven-site module every harmful accepted error has
weight at least three; thus `q_7≤35δ³/a^7`, and thirteen primitives give error at most
`455δ³/a^7 ≤ [4.55/(0.99)^7]δ² < (91/6)δ² ≤ q`.
The known thirteen-term signed decomposition supplies both circuits.

These elementary bounds prove the continuum statement. The script verifies their rational
endpoint constants; the three sample points below are additional exact computations, not
the proof of the interval claim.

## 5. Exact numerical comparison

For the thirteen nonzero rows `a_j` of the banked `E_7`, the compiled error is
`Σ_j e_j a_j`. Let `A_w` enumerate the words `(a_j·v)_j` as `v` ranges over `F_7^6`.
If each distilled primitive has error `ε`, the exact good-output probability is

```
7^-6 Σ_w A_w (1-7ε/6)^w.
```

Independent enumeration of the kernel of the synthesis matrix gives the same probability
by summing the product noise law. Both include all error cancellations.

| Input error | Native error | Native expected inputs | Weighted 4-to-1 + 13-term synthesis: error / inputs | Sign-only 7-to-1 + 13-term synthesis: error / inputs |
|---:|---:|---:|---:|---:|
| `0.0001` | `1.51748e-7` | `14.0196` | `1.30032e-7 / 52.0208` | `1.26433e-11 / 91.0637` |
| `0.001` | `1.52477e-5` | `14.1973` | `1.30317e-5 / 52.2085` | `1.26832e-8 / 91.6396` |
| `0.01` | `0.00159853` | `16.0894` | `0.00133141 / 54.1275` | `1.30920e-5 / 97.6325` |

All comparators shown satisfy the native error requirement. The six-to-one/thirteen-term
route fails it at all three sample points; its entries, and the correctly costed eight-input
implementation of the weighted module, remain in the certificate. We do not mistake the
explicit routes for globally optimal baselines: the universal menu lower bounds are separate.

## 6. What this adds to the paper, and what it does not

This supplies the operational comparison previously missing. It shows why joint preparation
and purification can be worthwhile for this particular coupled cubic resource. The advantage
is not exclusive to Clebsch symmetry; the proof combines the native protocol's noise law with
the target's synthesis complexity and the chosen separate-distillation menu.

The crisp paper spine is now fixed as an editorial plan:

1. Known signed-moment dictionary, then the geometric construction and invariant logical cubic.
2. Hessian-rank resource theorem, exact spectrum and Clifford-product separation.
3. This explicitly delimited same-target factory comparison, with one table.
4. A short chordal-shadow proposition explaining the Paper V torsors.

Put full source classifications, alternative conic examples, complete enumerators, the
distance-three exhaustion, and replay details in appendices/artifacts. The all-primes
translation trade is a concise control example: it prevents an exceptional-parameters claim.
The mystery of why the conic source stops is an outlook question, not a drafting dependency.
No manuscript wording is written before the existing literature gate passes.

## 7. Evidence and replay

From repository root:

```
python3 notes/2026-09-07-c1102-factory-benchmark/benchmark.py --write
python3 notes/2026-09-07-c1102-factory-benchmark/benchmark.py --check
```

Python standard library only; deterministic integer enumeration and `fractions.Fraction`,
no random seed or floating-point decisions. Decimal values are display-only. `certificate.json`
contains all enumerators, code rows, exact fractions, costs, sample-point comparisons, and
interval constants. `SHA256SUMS` pins byte counts and hashes of the exact generator, output,
banked matrix input, Waring-bound report, and native-protocol memo.

Independent checks: native primal/dual word enumeration versus MacWilliams; each primitive
acceptance/good enumerator versus its MacWilliams transform; synthesis dual-kernel enumeration
versus the Fourier formula; native acceptance versus its closed form. The existing Waring
lower bound is imported with an exact source hash, not presented as a fresh census. No Lean,
hardware, large new search, or library-dependent symbolic calculation is involved.

Prior work used: Campbell–Anwar–Browne arXiv:1205.3104v2, **partial**, sections III.D and
IV.C–D, equations (32)–(34), Definitions 9–10 (cached hash in the citation audit); C1090's
protocol memo §7; C1099's RS benchmark §3.3. This is a proved comparison of specified
constructions, not a priority claim; it does not discharge the literature gate. The routed
expert index was consulted: no listed exact-paper or subject dossier applies to this new
companion's elementary probability/CSS comparison, so none was imported from another paper.

## 8. `ej` + `tt` closeout and Mystery ledger

After the exact comparator and interval gates passed, the closeout asked whether the result
relied on a weak baseline, ignored cancellations, or smuggled in equal-cost cubic types.
The cheap upgrades are included: the four-site weighted distiller, a separate sign-only
implementation with eight injections and its correct noise convolution, exact synthesis
cancellations, arbitrary module concatenations in the lower bound, the weaker census-free
rank-six check, and the Clifford-frame extension of the rank-nine argument.

- **Settled:** exact Waring rank is unnecessary for this benchmark; its lower bound already
  separates costs, and the known upper decomposition supplies a feasible comparator.
- **Settled:** cancellations cannot rescue an unpurified primitive in deterministic
  phase-polynomial synthesis; the maximum-mass convolution bound proves it.
- **Settled:** the weighted-input cost ambiguity is exposed and calculated under both supplies.
- **Open, outside this benchmark:** can pooled or different primitive distillers erase the
  advantage? The exact missing evidence is an expanded baseline optimization, not more
  digits in the existing comparison. No universal practical-advantage claim is licensed.
- **Open gate:** literature adjudication still controls drafting; Wang–Li primary access is now resolved through the complete cached user scan set.

No additional mathematical mystery is needed to complete this bounded comparison. All these
observations answer the user's upgrade request; none is incidental discovery-track material.
