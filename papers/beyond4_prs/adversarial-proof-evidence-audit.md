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
| The contained cases are assumed rather than classified. | Original Theorem 4.1 and its proof | **Rejected through R9 after repair.** | The revision separates polar construction, `CC(n,j)`, and transverse induction.  The rank--nullity, central-lift, collision, and modular calculations close `CC(6,1)`, `CC(7,1)`, and `CC(8,1)`; the pointed recursion closes `LP(6,1)`; and the universal R9 good-base open closes the residual carrier. |
| Orbit counts are used as orbit identifiers. | R5--R7 tables | **Rejected after repair.** | The generated public records expose canonical representatives, stabilizers, invariants/histograms, Frobenius fusion, separate status flags, and exact exhaustion identities. |
| Split-free is silently promoted to deep. | R7 statement, summary, certificate schema | **Rejected after repair.** | Preserve the separate radius field and the `q>=11` gate. |
| A finite regression is used as a geometric-integrality proof. | Hessian and R9 evidence rows | **Rejected after repair.** | The manuscript and schema now say explicitly that bounded algebra does not replace the geometric proof. |
| C517 proves the full redundancy-nine theorem. | Lean import gate and axiom audit | **Rejected.** | C517 is recorded only as residual algebra plus conditional synthesis, with five geometric/group-theoretic inputs outside Lean. |
| The `q=43` endpoint follows from a mismatched bound. | Abstract, R8 theorem, normalized threshold table | **Rejected after repair.** | Use `(g,delta,kappa)=(1,30,1)` and first prime power 43 everywhere. |
| The `q=53` endpoint is an unexplained rounding artifact. | R9 threshold | **Rejected after repair.** | The strict real cutoff is 49, integer lower bound 50, first prime power 53. |
| The R5 singular curve uses the `+1` constant without controlling singular points. | The \(S_3\) lemma and threshold table | **Rejected after repair.** | The text quotes the Aubry--Perret arithmetic-genus bound, deletes the at-most-one rational singular point, and records `(g,delta,kappa)=(1,13,1)`; the R6/R7 marked budgets are correspondingly `(1,19,1)` and `(1,25,1)`. |
| The singular-point deletion moves the R6 threshold past \(q=29\). | The definition of \(\mathcal H_\kappa\), Table 6, and the R6 synthesis | **Rejected after repair.** | The definition is \(1+\lfloor(g+\sqrt{g^2+\delta-\kappa})^2\rfloor\); hence \(\mathcal H_1(1,19)=29\), and the text checks \(30-2\sqrt{29}>19\) explicitly. |
| The R7 proof invokes a one-step theorem twice without a second lower package. | The R7 transverse propositions and synthesis | **Rejected after repair and cold confirmation.** | Proposition 6.10 prints the second-marker parameter scheme: secant \(3\), cyclic/wild \(4\), self-collision \(6\), old-marker equality \(1\), and fixed-old-marker gcd \(2\), total \(16\). It then treats both bottom strata, with deletion \(12\) for the pointed linear-gcd graph and \((g,\delta,\kappa)=(1,25,1)\) for the \(S_3\) cover. The next reader independently reconstructed the package and verified the fixed-factor exclusion. |
| A lower fixed gcd may equal a retained marker. | R6 and R7 linear-gcd branches | **Rejected after repair.** | The shared collision lemma identifies three readings of one subspace: every section through the marker is double, the contracted system has that marker as fixed root, and the marker lies on the collision divisor.  It replaces the duplicated R6/R7 minor arguments.  In Proposition 6.10, equality with the old marker \(x\) is still excluded by the displayed degree-at-most-two fixed-factor minors, while equality with the new marker \(s\) is the shared lemma. Definition 5.4 places both in the unavailable scheme. |
| The verification package is externally reproducible. | Repository-relative paths and predecessor manifests | **Survived.** | The release manifest still lacks URL, tag, commit, DOI, hashes, byte counts, and toolchains. |
| The mathematical manuscript is proof-complete at its stated boundaries. | All headline theorem proofs | **Rejected after repair.** | The proposition-level assertion-map cold read is green through R9, ordered Hessian, and `e_7`; the aggregate formal reconciliation is also green.  The independent final reader, clean export, metadata, and author/venue confirmation remain release gates rather than hidden proof hypotheses. |

## Result audit

| ID | Proof/evidence verdict | Readiness | Exact boundary |
|---|---|---|---|
| PF | Green mathematical infrastructure | L2 | Construction and lifting only. |
| SC | Green manuscript theorem | L2 | The catalecticant-rowspace closure eliminates retained markers; irreducibility and the explicit bottom-component ledger prove `SC(j)` for all `j>=6`.  Certificate SC checks the polynomial, saturation, and vertical-fibre algebra. |
| TI | Green unconditional theorem | L2 | Requires a lower package; the now-proved `SC(j)` theorem, collision bounds, and modular pullback degrees make the displayed all-level threshold unconditional. |
| R5 | Green mixed theorem | L1 | Gcd strata, cyclic/wild normal forms, stabilizers, degenerations, off-diagonal integrality/genus/deletion, and the finite bridge are printed; the certificate is used only for the declared low-field residue. |
| R6 | Green mixed theorem | L1 | Persistent orbit law, secant intersection degree, cyclic and ramification degrees, modular contained components, nucleus arithmetic, and the finite bridge are named and proved. |
| R7 | Green mixed theorem | L1 | The contained proof, independently confirmed two-step transverse package, and finite bridge give the all-field split-free classification; deep-hole promotion is only for `q>=11`. |
| R8 | Green mathematical theorem | L1 | `CC(7,1)` and `LP(6,1)` are closed; the cold read checked the recursive rank/gcd/cyclic/wild/inseparable/branch exhaustion, the geometric-`S3` identity twist, both parameter-degree budgets, the direct gcd-one counts, and the marker-collision bounds. |
| R9 | Green mathematical theorem | L1 | Residual and deletion proofs, six explicit slice polynomials and checked Bezout identity, four multiple-root controls, the rational-base polynomial with degree accounting, and `CC(8,1)` are printed.  The theorem makes no bounded-field claim below 53. |
| R9-kernel | Green kernel-checked conditional theorem | L3 | Does not close geometric hypotheses. |
| Hessian | Green mathematical theorem | L1 | The reduced root-compatible pullback is proved to be the persistent/Lucas union, the complementary ruling is excluded, vertical factors are removed before reduction, and a product of two nonzero component equations gives the honest degree-eight global bad polynomial and revised threshold. |
| Lucas | Green mixed supporting theorem | L2 | Distinguished endpoint only; no claim about the remaining degree-nine carrier strata. |
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

## Remaining release work

- Obtain the independent final-reader signoff.
- Split the source, execute the public replays in a clean paper-only export,
  and fill the immutable manifest.
- Confirm authorship and the selected venue policy immediately before any
  upload.

## Bottom line

The mathematical proof boundary is green, including the mixed finite
residues.  The object remains a pre-release development draft because the
literature, formal aggregate, clean-export, immutable-manifest, and external
confirmation gates are still open.
