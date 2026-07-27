# Claim-level evidence report

All commands below run from `supplement/` in the standalone repository.  The
single full replay command is

```text
python3 verify.py --replay
```

It first checks the byte count and SHA-256 digest of every load-bearing file,
then invokes each generator with `--check`.  Each generator reconstructs its
canonical JSON certificate in memory and requires byte-for-byte equality with
the tracked certificate.  No randomness, floating point, network access, or
external computer-algebra package is used.

The integrity-only command ends with
`verified 17 evidence artifact(s)`.  A successful full run additionally ends
with `replayed 8 evidence bundle(s)`; each generator reports a successful
comparison with its tracked certificate.

## Imported bundles

| Result | Exact paper-facing domain | Generator and certificate | Independent replay or invariant check |
|---|---|---|---|
| `thm:dictionary`, Clebsch/GRS separation | The displayed Clebsch `AME(6,11)` state versus every six-point GRS-derived state, allowing all party permutations; no classification of other non-GRS states | `2026-07-19-clebsch-ame-equivalence.{py,json}` | CSS shortening is checked against direct shortening of the full Lagrangian; all 924 GRS evaluation sets are enumerated, and a separate 950,400-candidate anchored LC test checks the standard extended-RS representative. |
| `thm:lc-pencil`, `cor:lu-lc-pencil` input | The admitted non-GRS pencil over odd finite fields, with the exact excluded factors and exceptional branch/recovery collisions stated in the manuscript | `2026-07-23-holonomy-completeness.{py,json}` plus the hash-pinned pencil-arithmetic input | Symbolic bracket and holonomy identities carry the all-field claim; canonical classes, direct pairwise projectivity, explicit projectivities, direct-Lagrangian holonomy, and marginal moments are replayed over eight prime fields and four extension fields. |
| `thm:logical-phase`, `thm:q13-lu` | The fixed-party logical group in the theorem's odd-field six-arc domain, and the exact pair of q=13 classes in the collision bucket | `2026-07-23-ame-perfect-tensor-physics.{py,json}` | Candidate symplectic maps are checked against full Lagrangian row spaces; generators are independently closed; symbolic Gale identities are replayed at q=11,13,101; the q=13 copy contractions exhaust all 720 party permutations and independently sum the full orbit. |
| `thm:lu-h3-grs` | Every odd good non-GRS H3 reduction versus the GRS locus; bad and GRS reductions are excluded | `2026-07-23-h3-ame-uniform-lu-separation.{py,json}` | Exact arithmetic in `Q(tau)` and exact `S_6` closure prove the formula; an independent q=19 replay compares chord-concurrency determinants with direct ranks of sums of shortened Pauli Lagrangians. |
| H3 orientation boundary | Every odd H3 reduction in the stated domain; this identifies the LC-forgettable pentad orientation and does not classify the fixed-permutation LU kernel | `2026-07-23-h3-pentad-orientation-lu.{py,json}` | Integral isoduality and complete q=11/q=19 projective permutation lists are checked computationally; the finite-Fourier code-duality lift follows independently from character orthogonality. |
| Four-copy rank-drop divisor | The admitted pencil, with characteristics 3/5 as boundary coincidences, 7 as component merger, and 11/13/41 as ramification phenomena | `2026-07-23-contraction-rank-drop-divisor.{py,json}` | Exact quotient-field row reduction and integral maximal-minor witnesses exclude extra components; direct finite-field Gaussian elimination independently replays every admitted parameter for q=7,11,13,17,19,23,29,31. |
| `thm:transport-divisor` | The four-copy contraction and its two divisor components, double-coset multiplicities, and stated exceptional arithmetic | `2026-07-23-four-copy-cover-holonomy.{py,json}` | A signed cycle-cover ledger and fraction-free determinant give independent determinant paths; a third replay compares the `24 x 21` section and `9 x 9` transport kernels for all 720 party assignments at six exact `(q,t)` pairs. |
| `cor:computed-party-splitting` | Exactly the twelve prime-field pencil, GRS, enhanced-symmetry, and split-prime H3 rows named in the corollary; no arbitrary-six-arc, all-good-reduction, or extension-field splitting claim | `2026-07-25-ame-lu-party-extension-examples.{py,json}` | The checker exhausts all 720 party permutations per row after a complete fixed-kernel anchor normalization, checks the full CSS Lagrangian, records every normalized factor, and verifies explicit complements and parity actions. The six q=11 fixed-kernel, party-image, and total-group orders are independently compared with the separate perfect-tensor census. |

## Certificate and trust boundary

The JSON files certify the exact bounded enumerations, identities, ranks,
histograms, group closures, and finite-field replays described in the table.
They do not enlarge the theorem domains stated in the manuscript, prove a global
LU--LC conjecture, classify arbitrary minimal-support AME tensors, or show that
four copies are globally minimal.

The trusted computational boundary is Python 3 integer arithmetic, exact
rational and polynomial arithmetic implemented by the generators, deterministic
finite-field Gaussian elimination, canonical JSON serialization, and the
standard Pauli/stabilizer and copy-contraction dictionaries used in the paper.
The conceptual all-field arguments and the correspondence between these
computations and the manuscript statements remain mathematical proof
obligations in the text.

## Lean claim crosswalk

The Lean 4 companion uses toolchain `v4.32.0-rc1`.  The aggregate terminals
are `RelativeConicArcs.Gates.AMELUAggregate` and
`RelativeConicArcs.Gates.AMELUAggregateAxioms`.

- `StabilizerAMESupport`, `StabilizerAMERigidity`, and the generic marginal
  and diagonal-tensor modules prove the arbitrary-additive support squeeze,
  minimum-support generation, full-Weyl marginal and axis-recovery cores, and
  the LU-to-LC composition.  The physics-facing realization input is the
  stabilizer-projector partial-trace expansion.
- The generic transition and holonomy modules prove atlas equivalence and the
  abstract centralizer mechanism.  The extension-field form retains the
  propagated `Sp_{2e}(F_p)` membership conditions; the prime-field normal
  subgroup specialization gives the pure `SL_2(q)` centralizer.
- `EncoderTransversal`, `DiagonalIsoduality`, `StabilizerDictionary`, and the
  automorphism/extension modules prove the Choi inverse-transpose bridge,
  Clifford closure, the arbitrary-length multiplier and nullity theorems,
  stabilizer-character phase correction, scalar-torus quotients, the
  section-free outer action, and abstract splitting consequences.
- The pencil geometry, exact logical propagation, marginal trace/incidence
  bridges, finite contraction ranks, twelve concrete complements, and
  transport determinant/double-coset inputs occur as named hypotheses of
  formalized implications.  They are supplied by manuscript proofs or the
  exact certificates listed above, not by unconditional Lean declarations.

No aggregate module uses `sorry` or unsafe declarations.  Ordinary
kernel-checked declarations use only `propext`, `Classical.choice`, and
`Quot.sound`; three finite graph cardinalities use `native_decide` and are
reported separately by the axiom terminal.
