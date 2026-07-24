# Adversarial proof and evidence audit

Date: 2026-07-23

## Audit standard

- **Exact finite certificate:** exhaustive executable evidence on a declared
  finite domain, with a completeness identity and replay boundary.
- **Mathematical proof:** a reader-checkable argument in the manuscript,
  including every load-bearing geometric and arithmetic bridge.
- **Mixed-verification theorem:** a theorem whose conceptual proof is
  mathematical and whose explicitly finite residue is certified.
- **Kernel-checked theorem:** a declaration accepted by Lean's kernel with its
  nonformal hypotheses exposed in the type.

These notions are not interchangeable.

Verdicts:

- `Green infrastructure`: exact definitions or reproducibility machinery.
- `Green finite theorem`: a bounded statement completely certified.
- `Green mixed theorem`: full mathematical proof plus an exact finite residue.
- `Green conditional theorem`: valid theorem with all hypotheses explicit.
- `Sharp blocker`: a precisely located missing bridge.
- `Open repair`: expansion or external release work remains.

Formal readiness uses `L1` (interfaces), `L2` (formalizable decomposition), and
`L3` (kernel checked).

## Adversarial attacks

| Attack | Evidence tested | Verdict | Required repair |
|---|---|---|---|
| The contained cases are assumed rather than classified. | Original Theorem 4.1 and its proof | **Rejected through R8 after repair.** | The revision separates polar construction, `CC(n,j)`, and transverse induction.  The rank--nullity, central-lift, collision, and modular calculations close `CC(6,1)` and `CC(7,1)`; the pointed recursion closes `LP(6,1)`.  The later R9 slice/component geometry remains gated. |
| Orbit counts are used as orbit identifiers. | R5--R7 tables | **Survived against the first draft.** | Public records must expose canonical representatives, stabilizers, invariants/histograms, Frobenius fusion, and exhaustion. |
| Split-free is silently promoted to deep. | R7 statement, summary, certificate schema | **Rejected after repair.** | Preserve the separate radius field and the `q>=11` gate. |
| A finite regression is used as a geometric-integrality proof. | Hessian and R9 evidence rows | **Rejected after repair.** | The manuscript and schema now say explicitly that bounded algebra does not replace the geometric proof. |
| C517 proves the full redundancy-nine theorem. | Lean import gate and axiom audit | **Rejected.** | C517 is recorded only as residual algebra plus conditional synthesis, with five geometric/group-theoretic inputs outside Lean. |
| The `q=43` endpoint follows from a mismatched bound. | Abstract, R8 theorem, normalized threshold table | **Rejected after repair.** | Use `(g,delta,kappa)=(1,30,1)` and first prime power 43 everywhere. |
| The `q=53` endpoint is an unexplained rounding artifact. | R9 threshold | **Rejected after repair.** | The strict real cutoff is 49, integer lower bound 50, first prime power 53. |
| The R5 singular curve uses the smooth `+1` convention. | Lemma 3.2 and threshold table | **Rejected after repair.** | R5 is explicitly assigned `kappa=0`. |
| The verification package is externally reproducible. | Repository-relative paths and predecessor manifests | **Survived.** | The release manifest still lacks URL, tag, commit, DOI, hashes, byte counts, and toolchains. |
| The manuscript is proof-complete. | All headline theorem proofs | **Survived.** | R5--R9 proof expansions, the ordered-Hessian proof, and the `e_7` cover proof remain open. |

## Result audit

| ID | Proof/evidence verdict | Readiness | Exact boundary |
|---|---|---|---|
| PF | Green mathematical infrastructure | L2 | Construction and lifting only. |
| TI | Green conditional theorem | L2 | Requires a lower package and proved `CC(n,j)`. |
| R5 | Open mixed theorem | L1 | Normal forms, stabilizers, degenerations, and cubic-cover geometry need expansion; finite residue is certified. |
| R6 | Open mixed theorem | L1 | Degree/containment propositions need expansion; finite bridge is certified. |
| R7 | Green mixed theorem | L1 | The contained and transverse proofs plus finite bridge give the all-field split-free classification; deep-hole promotion is only for `q>=11`. |
| R8 | Green mathematical theorem | L1 | `CC(7,1)` and `LP(6,1)` are closed; the cold read checked the recursive rank/gcd/cyclic/wild/inseparable/branch exhaustion, the geometric-`S3` identity twist, both parameter-degree budgets, the direct gcd-one counts, and the marker-collision bounds. |
| R9 | Green mathematical theorem | L1 | Residual and deletion proofs, six explicit slice polynomials and checked Bezout identity, four multiple-root controls, the rational-base polynomial with degree accounting, and `CC(8,1)` are printed.  The theorem makes no bounded-field claim below 53. |
| R9-kernel | Green kernel-checked conditional theorem | L3 | Does not close geometric hypotheses. |
| Hessian | Sharp blocker | L1 | Geometric strata are separated; root-compatible persistent pullback and the global bad-union degree bound remain open. |
| Lucas | Green mixed supporting theorem, pending cold read | L2 | Distinguished endpoint only. |
| e7 | Green mixed theorem | L1/L2 | The source derives the full collision open, proves geometric Artin--Schreier integrality and the trace law, identifies the connected affine-frame quotient and exact `AGL_3(F_2)` deck group, and gives the direct translated-subspace witness count with no overcount. |

## Cross-cutting findings

1. The fifteen-page format is too short for the theorem inventory.
2. The coherent-polar mechanism is the correct organizing contribution, but
   only after the contained/transverse split is made formal.
3. Public classification data, not orbit-size summaries, are required for
   repeated-size rows.
4. Certificate and Lean transparency are strengths; neither substitutes for
   omitted geometric proofs.
5. A single larger paper remains coherent, provided the ordered-Hessian and
   Lucas sections are integrated as level-specific contained geometry.

## Remaining manuscript work

- Prove one named proposition for every load-bearing degree, genus,
  integrality, ramification, collision, and containment assertion.
- Replace the ordered-Hessian outline and split the `e_7` theorem into three
  proofs.
- Complete the public classification records and field-range bridge records.
- Finish the role-based literature audit and immutable release package.
- Repeat this adversarial audit after expansion; only then may an open result
  row become green.

## Bottom line

The revision repairs the logical presentation of the induction theorem and
the numerical point-bound convention.  It does not yet repair the central
proof-completeness deficit.  The manuscript remains a development draft until
the sharp blockers above are closed.
