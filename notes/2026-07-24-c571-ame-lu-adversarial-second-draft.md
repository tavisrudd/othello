# C571 — AME/LU adversarial audit and second draft

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Verdict:** `COMPLETE; THE SECOND DRAFT PASSES THE PROOF/EVIDENCE AUDIT, EVERY FORMAL-COVERAGE FIELD HAS A TWO-WAY SOURCE MAP, THE RENDERED PDF IS CLEAN, AND AN INDEPENDENT MATHEMATICAL COLD READER RETURNS GO`

## Principal outcome

The all-prime-power headline theorem survives unchanged: every
product-unitary intertwiner between equal-phase CSS states of linear
`[6,3,4]_q` MDS codes is local Clifford. The independent cold read judged
the four-party Weyl-axis proof clear and convincing.

The secondary results required substantial repair. The second draft now:

- defines the LC holonomy transitions and proves their covariance and exact
  modular-collision recovery of `z`;
- defines the fixed-party logical kernel, displays its multiplier equations,
  and cites the exact six-point Gale self-association theorem;
- derives the marginal trace/rank and arc/Gale concurrence bridge;
- corrects generic fixed-copy constancy to irreducible components of regular
  constant-dimension generator charts;
- defines the party-dependent systematic matrix `Q_p` in the transport
  operator, quantifies the party assignment existentially, and separates the
  conceptual reduction from the certificate-supported exhaustion, minors, and
  double-coset geometry; and
- ends with the mathematical distinction between covariant Weyl-axis recovery
  and generically blind fixed-copy scalar contractions.

## Release-blocking Frobenius correction

The revised cold read found a genuine counterexample to the previously frozen
extension-field claim. For `q=p^e`, a full single-qudit Clifford induces an
`F_p`-symplectic transformation, not necessarily an `F_q`-linear
`SL_2(q)` block. In particular, the basis permutation

```text
|x> -> |x^p>
```

maps `Psi_t` to `Psi_(t^p)` and sends `z(t)` to `z(t)^p`.

The exact smallest displayed witness is

```text
F_25 = F_5[s]/(s^2-2),   t=s,   u=-s=s^5,
z(s)=3+3s,               z(-s)=3+2s.
```

Both parameters are admitted. Thus the old extension-field
`LU iff LC iff z equality` corollary was false under the manuscript's full
Weyl-normalizer definition of Clifford.

The correction is now synchronized everywhere:

- Theorem 1.1 remains uniform over every prime power.
- Projective/monomial classification by `z` remains valid over every odd
  finite field.
- The quantum `LC iff LU iff z` pencil corollary and the full fixed-party
  `SL_2(q)` versus split-torus theorem are restricted to odd prime fields.
- The manuscript states that extension-field classification needs at least a
  Frobenius quotient and may have further `F_p`-symplectic identifications.

This was a requested audit finding, not an incidental discovery-track item.

## Formal-coverage audit

The five C571 checks are closed.

1. `formal-statement-adequacy.md` maps every manuscript label to exact audited
   declarations and maps every paper-facing audited declaration back to exact
   manuscript wording.
2. Its field-by-field table covers every field of
   `PencilClassificationInputs`, `LogicalPhaseInputs`,
   `MarginalMomentModel`, `MarginalLUSeparatorInputs`,
   `FourCopySeparatorInputs`, `TransportCycleCoverInputs`,
   `TransportRankBridgeInputs`, and `TransportOrbitGeometryInputs`.
3. The full project-owned transitive closure—nine AMELU source modules and all
   AMELU gate/axiom terminals—was reviewed for referee prose, statement names,
   workflow residue, trust disclosures, `sorry`, project axioms, native
   evaluation, and unsafe declarations.
4. The manuscript and ledgers distinguish formalized implications,
   manuscript-constructed hypotheses, certificate-supported hypotheses, and
   inputs having both a prose proof mechanism and an independent replay.
5. C572's release plan includes the exact adequacy ledger and
   `RelativeConicArcs.Gates.AMELUAggregateAxioms`; C572 owns their immutable
   public identities.

The extension-field correction also sharpens the formal boundary: the Lean
classification and logical-phase packages expose field-linear conditional
interfaces. They coincide with the full quantum Clifford problem only over
prime fields.

## Independent cold read

The reader first saw only the manuscript, not the audit ledgers. The first pass
identified three blockers and eleven major issues. After revision, the reader
found the Frobenius counterexample, the missing logical multiplier equations,
and the missing existential party quantifier. A final read after those repairs
returned:

```text
GO. No remaining blocker or major issue found.
```

The reader separately confirmed that the all-prime-power headline theorem,
prime-field secondary classifications, extension-field nonclaim, and
claim-by-claim trust boundary are mutually consistent and referee-followable.

## Citation and rendered-paper checks

DOI/Crossref metadata was checked for every bibliography entry. Missing issue,
article-number, and DOI fields were repaired. The second draft adds:

- Xander Faber's classification of finite `p`-irregular subgroups of
  `PGL_2(k)` for the H3/GRS involution bound; and
- Howard--Millson--Snowden--Vakil for the six-point
  self-association/conic theorem.

`make check` passes without LaTeX, package, reference, overfull, or underfull
warnings. The final PDF has:

```text
pages: 14
bytes: 155933
SHA-256: 1deacfd0e4536952c4cc184163df33525e66f350eaeef031ab0e5743f72a61fc
```

Every page and table was rendered and inspected. The theorem hierarchy is
visible, the long projectivity and detector tables fit, the new Frobenius
boundary and logical multiplier equations break cleanly, and the references
fit on the final page.

## Evidence replay

From `papers/ame_lu/`:

```text
python3 supplement/verify.py --replay
```

passed all fifteen manifest hashes and regenerated all seven canonical JSON
certificates. The run ended with:

```text
verified 15 evidence artifact(s)
replayed 7 evidence bundle(s)
```

The `q=25` Frobenius counterexample is direct finite-field algebra displayed in
the proof boundary; it is not presented as a computer-assisted claim.

## `ej` / Tao closeout and mystery ledger

The closeout asked what the counterexample says about the mechanism rather than
only how to patch the theorem. The rank-one contraction locus canonically
recovers the additive Weyl axes, which is enough for the full
prime-power LU-to-Clifford theorem. It does not by itself recover the
`F_q`-multiplicative structure inside the `F_p` phase space. This precisely
explains why the prime-field scalar classification works and why Frobenius
escapes it over extensions.

The cheap upgrade was done: the manuscript now includes the exact admitted
`F_25` witness rather than hiding the restriction in a scope table. The next
structural question is already naturally owned by C581's basis-free
phase-space reconstruction gate.

| Feature | Disposition |
|:---|:---|
| Whether the all-prime-power LU-to-Clifford theorem survives | **Settled:** yes; it concludes membership in the full Weyl normalizer and never assumes `F_q`-linearity. |
| Why `z` fails over extension fields | **Settled:** Frobenius basis permutations are full local Cliffords and send `z` to a conjugate value. |
| Small exact witness | **Settled:** the admitted `F_25` pair `s,-s` has unequal conjugate `z` values and exactly related states. |
| Whether the full extension-field orbit relation is just `z` modulo Frobenius | **Open:** the full `Sp_{2e}(p)` normalizer may identify more than the semilinear subgroup. C581 should first test whether the family of shortened marginal planes reconstructs the Desarguesian `F_q`-spread. |
| Whether the logical phase has an extension-field full-Clifford analogue | **Open under the same gate:** the present `SL_2(q)` theorem is only the field-linear phase; C581 owns the basis-free reconstruction prerequisite. |
| Conditional Lean inputs | **Settled as a trust boundary:** every field has an exact prose/evidence owner; no aggregate import is presented as a construction of those fields. |
| Public immutable source, evidence, axiom-audit, and PDF identities | **Open by design:** C572 is the release-candidate owner. |

## Vibe check

Strong, and materially more trustworthy than the first draft. The cold read did
not merely polish exposition: it found and forced correction of a false
extension-field corollary while leaving the headline crown intact. The paper
now has a sharper theorem hierarchy and a mathematically meaningful boundary
that points directly toward the optional basis-free reconstruction program.
