# Verification surface

This directory is the paper-owned trust boundary for *The golden conference
operator and its shadow sisters*.

The manuscript distinguishes:

1. human proofs written in the paper;
2. classical theorems imported by citation;
3. exact finite computations with committed generators and certificates;
4. independent replays; and
5. formal results, if a later Golden Lean package is added.

No manuscript theorem relies solely on a computation.  The finite clauses
below have committed generators, certificates, and independent replays; the
surrounding quotient and operator statements have human proofs in the paper.

## Frozen source bundles to import

| family | frozen report | intended trust mode |
|---|---|---|
| exterior/Segre/Cartan and bounded sister census | notes/2026-07-30-c704-functorial-operator-shadows.md | human proof plus exact checker and independent replay |
| assembled adjugate and exceptional parents | notes/2026-07-30-c705-adjugate-segre-igusa-polar.md and C705 companions | human proof; exact scalar/rank witnesses where stated |
| Clifford obstruction | notes/2026-07-30-c706-equivariant-clifford-lift.md | cochain proof plus finite contradiction certificate |
| ETF, Slater, optimum, and anomaly interface | notes/2026-07-31-c707-golden-etf-quantum-measurements.md | human proof plus exact replay |
| doily codes and polarities | notes/2026-07-30-c708-doily-codes-and-outer-exchange.md | structural proof plus exact finite tables |
| Majorana family | notes/2026-07-30-c709-majorana-k6-lift.md | human proof plus phase/spectral checks |
| \(E_8\)--Hamming obstruction and hyperbolic repair | notes/2026-07-30-c710-e8-hamming-marking.md | two conceptual obstructions, one exhaustive root certificate, and explicit construction |
| pure-spinor boundary, frustration, decoder, and \(S_{10}\) | notes/2026-07-31-c720-spinor-dimer-tests.md | human classification plus exact checker and independent replay |
| determinant/dimer coefficient equivalence | notes/2026-07-31-c720-ej2-sextic-dimer-equivalence.md | complete symbolic proof; no computation required |
| rational anomaly inverse, height boundary, and success optimum | notes/2026-07-31-c715-golden-anomaly-inverse.md | GIT and alternating-polynomial proofs plus exact height/Sturm certificate and independent replay |
| two-\(U(1)\) anomaly lines and Fano-component marking | notes/2026-07-31-c716-golden-two-u1-lines.md | imported Fano classification plus exact 21-family certificate and independent Pfaffian replay |

For C715, from the repository root run

```text
python3 notes/2026-07-31-c715-golden-anomaly-inverse.py --check
python3 notes/2026-07-31-c715-golden-anomaly-inverse-replay.py
```

Six distinct centered integers cannot have height below three.  The height
search therefore checks all \(7P6=5040\) ordered distinct sextuples in
\([-3,3]^6\).  It does not claim minimality for another arithmetic height.
The Sturm check certifies and compares all seven real pole domains; the
unique real optimum is only a supremum on the rational suborbit.

For C716, run

```text
python3 notes/2026-07-31-c716-golden-two-u1-lines.py --check
python3 notes/2026-07-31-c716-golden-two-u1-lines-replay.py
```

The generator reconstructs the frozen outer cubics, all fifteen
duad--syntheme markings, rational families on all 21 Fano components, and
the six source-to-path component labels.  The replay hard-codes the cubic
tables and independently checks the anomaly, chirality, marking, and base
Pfaffian identities.  The classical 21-component Fano classification is
imported by citation rather than certified computationally.

The existing C712 Lean package covers only the sub-700 source interface.  The
paper must not describe the post-700 propagation theorem as Lean-verified
unless a separate Golden formalization and axiom report are added here.
