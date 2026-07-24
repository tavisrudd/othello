# C540 — Lean closure for PRS redundancy five

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

The redundancy-five paper boundary is formalized in an algebra module, a finite-table module, and
a synthesis wrapper specialized to the certificate-validation predicates:

- `RelativeConicArcs.PRSRedundancyFive` defines five-coordinate divided-power syndromes, ordinary
  binary cubics, homogeneous linear factors, the characteristic-free `2 x 4` Hankel kernel,
  completely split squarefree cubic semantics including the point at infinity, and the concrete
  split-free dictionary.
- `RelativeConicArcs.PRSRedundancyFiveCertificate` records seventeen candidate sporadic-orbit
  rows over `q in {7,8,9,11,13,17,19}` and the nineteen-field comparison summaries.
- `RelativeConicArcs.PRSRedundancyFiveCertified` fixes the generic finite-evidence parameter of the
  synthesis theorem to the exact `CertificateValidation` interface.
- `RelativeConicArcs.Gates.PRSRedundancyFive` is the import-only paper gate, with
  `RelativeConicArcs.Gates.PRSRedundancyFiveAxiomAudit` as its exact audit.

The algebra leaf proves:

- the affine three-root and two-affine-plus-infinity span-to-Hankel identities over every
  commutative ring;
- invariance of every Hankel-kernel member and of split-freeness under nonzero projective scaling;
- the exact split-free/no-three-column-span equivalence from one visible converse-span input;
- disjoint tangent, conjugate-secant, rational/conjugate osculating-pair, characteristic-three
  nucleus, wild Artin--Schreier, and sporadic family synthesis;
- the three exact total-count formulas, including twice-cardinality forms that are uniform in
  characteristic;
- the five exact nonsporadic `PGL2/PGammaL2` orbit-count cases and their certified sporadic
  additions.

The post-gate strengthening binds the numerical field data to the actual formal field:
`q = Fintype.card K` and `CharP K p`. It also checks that the algebra and certificate leaves use
the identical finite bridge `q in {7,8,9,11,13,16,17,19}`.

## Certificate semantics

The kernel reduces the transcribed compact table and proves its internal arithmetic:

- sporadic point totals `644 / 756 / 900 / 990 / 728 / 1224 / 570`;
- sporadic projective/semilinear orbit counts
  `(5,5) / (3,1) / (3,2) / (2,2) / (2,2) / (1,1) / (1,1)`;
- every orbit-size/stabilizer identity against `|PGL2(q)| = q(q^2-1)`;
- every member histogram totals `q+1`;
- every Frobenius target has the same field, size, stabilizer, and histogram;
- absence of sporadics at `q=16` and throughout the certified comparison band `23..49`;
- agreement of each field summary with the compact sporadic records and Frobenius fusion.

The source is the public artifact
`papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`0a6c4066dff9983a9c2124bca27fbbe4e273b9868125a04c30071df3783b6725`.
Lean does not identify the rows as the sporadic orbits or rerun the external finite-field
enumeration. The `CertificateValidation` structure therefore keeps representative, stabilizer,
histogram, Frobenius, and exhaustive-domain checking as separate visible fields.

## External theorem boundary

No literature theorem or geometric classification is a Lean axiom. The paper-facing terminal
requires:

- Seroussi--Roth completeness in the exact `q>=7` range, cited in the module by title, DOI,
  Theorem 1, Corollary 2, and pages;
- the Aubry--Perret arithmetic-genus point bound in the exact `q>=23` branch, cited by title, DOI,
  Theorem 4, and pages;
- the separable cubic-cover stratum classification;
- the concrete converse projective span criterion;
- genuine group-action derivation of the numerical orbit counts;
- the semantic finite-certificate validation above.

The low finite branch does not require the Aubry--Perret hypothesis. Covering-radius promotion
remains separate from split-free classification, and the terminal cannot identify a split-free
table with a code-deep-hole table without the Seroussi--Roth range proof.

## Validation

Independent guarded leaf elaborations passed before the aggregate gate. Serialized run
`run-20260724-053426-0f5fb543` passed:

- `RelativeConicArcs.PRSRedundancyFive`;
- `RelativeConicArcs.PRSRedundancyFiveCertified`;
- `RelativeConicArcs.Gates.PRSRedundancyFiveAxiomAudit`;
- the trace-only aggregate `RelativeConicArcs.Gates.PRSRedundancyFive`.

The preceding full run `run-20260724-053129-e35862df` also built the certificate leaf explicitly.
The audit contains only the standard Lean/mathlib dependencies `propext`, `Classical.choice`, and
`Quot.sound`; several finite terminals are axiom-free. There are no project-specific axioms,
native evaluators, imported oracles, or `sorry`.

The referee-prose audit then corrected descriptions of scaling invariance, numerical hypotheses,
orbit semantics, classical logic, certificate semantics, and the coding dictionary without
changing declarations or proofs. Serialized run `run-20260724-054636-85d031dd` rebuilt the
certificate, main theorem, certified wrapper, all three PRS gates and axiom audits, and passed the
trace-only redundancy-five aggregate. Foundation, contraction, and redundancy nine were already
current from the immediately preceding guarded run. That preceding run stopped cleanly after those
targets when it observed a foreign Lean process; it had no proof failure.

The implementation commits are `5bf1facb`, `e66d82f5`, and `ab994bac`; the prose-audit commits are
`c99dbac5` and `bd991816`. Final source hashes:

```text
b6d8ee2e752b8d97c96b7c80b66dbcef0e533a9c9cd40c69ec3a6d005fa07319  PRSRedundancyFive.lean
60e121847cdfd9f2c64b2fb1f192f2eeada1df9c997a77357b081e1f1effeb4a  PRSRedundancyFiveCertificate.lean
283066bdeb71c15f1607a6a35f75ccc93192adf249d40eed2d80deacb3e2e107  PRSRedundancyFiveCertified.lean
db56c6d7a27ec796b8ca57c195aa4c96577c7edbd079ac3a6ed593e7d02803a6  Gates/PRSRedundancyFive.lean
9189ee87bfcea82eebcf3947a3db9d7ed54624777c5bc4658d63bc61c4862d2a  Gates/PRSRedundancyFiveAxiomAudit.lean
```

An initial attempt to display the complete public Markdown record exceeded the command-output
target. All subsequent evidence extraction used field-scoped `jq` projections against the public
JSON; no conclusion depends on truncated output.

## Extra-juice and Tao closeout

The first cheap upgrade was projective descent: nonzero scaling now preserves the concrete Hankel
kernel and split-free predicate by checked algebra rather than by a supplied compatibility field.

The certificate leaf initially checked the sporadic table in isolation. The closeout added the
stronger base-plus-sporadic identities for every certified total `PGL2/PGammaL2` orbit count, so
the Frobenius fusions at `q=8,9` are checked in the same table as the high-field absence rows.

The post-gate Tao question was whether the terminal could be instantiated with an arbitrary number
called `q` or an unrelated characteristic label. It could. The final interface now requires the
actual finite-field cardinality and `CharP` witness, closing that mismatch without strengthening
any imported theorem.

## Mystery ledger

Settled:

- **Does the binary-cubic semantics omit infinity?** No. Homogeneous linear factors and the
  two-affine-plus-infinity Hankel identity cover the projective root.
- **Can the theorem silently use an unrelated finite certificate?** No. The paper terminal fixes
  its evidence type to `CertificateValidation`, and the two finite-bridge lists are definitionally
  equal.
- **Can `q` or the characteristic label drift from the formal field?** No. The final structure
  contains `q = |K|` and `CharP K p`.
- **Do repeated sporadic orbit sizes collapse distinct orbits?** No. Canonical indices,
  stabilizers, histograms, and Frobenius targets remain part of every record.

Open, with exact evidence boundary:

- **Converse projective span theorem:** the two characteristic-free forward Hankel identities and
  projective scaling invariance are kernel checked, while the converse that every split squarefree
  Hankel member yields a three-column span remains the named
  `HankelSpanCriterionInput.span_iff_hasSplitSquarefreeKernelMember` field. This is a formal
  coordinate-bridge limitation, not a hidden axiom.
- **External geometry and enumeration:** Seroussi--Roth, Aubry--Perret, cubic-cover component
  classification, actual group actions, and exhaustive certificate validation remain the named
  assumptions listed above. No genuine unexplained numerical mystery remains inside the checked
  table.

No incidental observation met the discovery-track discriminator; the closeout upgrades above were
all direct obligations or strengthenings of this task.
