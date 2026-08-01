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
| recovery, minimal marking, and centered-square fibres | notes/2026-07-31-c727-cross-paper-recovery-propagation.md | human orbit-incidence, invariant-theory, and fibre proofs; exact coefficient identity imported from the C720 ej2 proof |
| synchronized pure-spinor quotient | notes/2026-07-31-c728-synchronized-pure-spinor-geometry.md | human equivariant proof plus exact character/elimination checker and independent replay |
| \(6\to10\) simplex--conference factorization | notes/2026-07-31-c729-simplex-conference-factorization.md | complete human Gram/incidence proof; finite normalization checked in the C729 bundles |
| higher cut moments and reflection boundary | notes/2026-07-31-c729-conference-cut-moments.md and notes/2026-07-31-c729-cut-moments-reflection-audit.md | sequel material; exact generators, compact certificates, and an independent replay |
| marked lift rigidity, collision filtration, and canonical return | notes/2026-07-31-c739-golden-cubic-lift-rigidity.md | human multiplicity-one, pole-descent, and subgroup-incidence proofs; exact character/cycle certificates; one-CAS boundary for the nilpotent Jacobian refinement |
| unmarked target and cross-block Fitting obstruction | notes/2026-07-31-c742-golden-reconstruction-degeneracy.md | human rank, stabilizer-orbit, descent, and Fitting proofs; exact full-permutation character certificate and independent class replay |

For the central exterior, commutator, golden-compression, and assembled-polar
claims, run

```text
python3 notes/2026-07-30-c704-segre-igusa-operator-shadow.py --check
python3 notes/2026-07-30-c704-segre-igusa-operator-shadow-replay.py
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar.py --check
python3 notes/2026-07-30-c705-adjugate-segre-igusa-base-locus.py --check
python3 notes/2026-07-30-c705-adjugate-segre-igusa-polar-replay.py
```

The C704 replay checks the polynomial identities independently over a grid
larger than the individual degree bound.  The C705 replay checks all 25
entries of the normalized identity
\(\operatorname{adj}A=6\widehat Wq^{\mathsf T}\) over 59,049 points.  These
finite-field replays corroborate the characteristic-zero human proofs; they
do not replace the marked-covariance or two-kernel arguments.

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

For the synchronized-spinor claims, run

```text
python3 notes/2026-07-31-c728-synchronized-pure-spinor-geometry.py --check
python3 notes/2026-07-31-c728-synchronized-pure-spinor-replay.py
```

The first command invokes Singular for the sharpened radical and
minimal-prime statement.  The representation-theoretic uniqueness and the
identification of the top cubics are proved in the text; Singular is
load-bearing only for reducedness of the fifteen-line base scheme.

For the order-ten factorization and the outward higher-cut boundary, run

```text
python3 notes/2026-07-31-c729-cut-moments.py --check
python3 notes/2026-07-31-c729-cut-moments-replay.py
python3 notes/2026-07-31-c729-conference-cut-moments.py --check
```

The manuscript's \(6\to10\) theorem has a complete Gram and cut-incidence
proof.  These commands check its frozen sign tables and the sequel-only
order-ten, order-fourteen, and order-eighteen cut data.  The replay starts
from the displayed Paley order-ten matrix and uses an independent determinant
path.

For the C739 placement, run

```text
python3 notes/2026-07-31-c739-representation-audit.py --check
python3 notes/2026-07-31-c739-representation-audit-replay.py
nix shell nixpkgs#singular --command Singular -q notes/2026-07-31-c739-degeneracy-audit.sing
python3 notes/2026-07-31-c739-cycle-audit.py --check
```

The marked rigidity and `36 -> 6` return have independent human proofs in
the manuscript.  The representation multiplicities also have a separately
implemented synthematic-total replay.  The reduced collision supports agree
with the GIT argument and the inherited C728 replay.  The nilpotent defect at
the ten `3+3` points still has only the exact Singular implementation, so the
appendix states that trust boundary and no central theorem depends on it.

For the unmarked target obstruction, run

```text
python3 notes/2026-07-31-c742-unmarked-target-audit.py --check
python3 notes/2026-07-31-c742-unmarked-target-audit-replay.py
```

The primary audit constructs the outer six-set as the six synthematic totals
and enumerates all 720 permutations.  The replay uses conjugacy classes and
the hard-coded outer class map.  Both give multiplicities one for the
ordinary product target and zero for its signed twist.  The rank-two
Pfaffian-zero conclusion, exceptional-action reconstruction, and Fitting
obstruction have human proofs in the manuscript; the certificate does not
replace them.

The existing C712 Lean package covers only the sub-700 source interface.  The
paper must not describe the post-700 propagation theorem as Lean-verified
unless a separate Golden formalization and axiom report are added here.
