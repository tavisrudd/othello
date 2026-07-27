# C675 reliability and bounded EXIT

**Lane:** `complete-ports`

**Status:** COMPLETE — the human proof, paper-facing Lean terminals, manuscript reconciliation,
aggregate replay, and trust registration are green.

## Result

For a finite helper universe \(U\), a finite port \(\mathcal H\), and independent survival
parameters \(s_v\), the success probability is the multilinear finite-subset average
\[
 R_{\mathcal H}(s)=
 \sum_{A\subseteq U}\mathbf 1_{\{\exists E\in\mathcal H:E\subseteq A\}}
 \prod_{v\in A}s_v\prod_{v\notin A}(1-s_v).
\]
Partitioning this sum at one helper proves deletion--contraction.  Its coordinate derivative is the
conditional contract-minus-delete difference, which is the pivotal probability.  Restricting to
the homogeneous diagonal and applying the finite chain rule gives Russo--Margulis.

In failure variables, failed sets are transversals.  If their minimum size is \(\tau\), the
homogeneous failure polynomial has no coefficient below \(\tau\), its degree-\(\tau\) coefficient
is the number \(b_\tau\) of minimum blockers, and it factors exactly as
\[
 b_\tau p^\tau+p^{\tau+1}Q(p).
\]
This is the formal algebraic content of
\(b_\tau p^\tau+O(p^{\tau+1})\).

For the cardinality filtration \(\mathcal H^{(\le r)}\), the event that the cheapest available
repair has size \(r\ge1\) is success at radius \(r\) minus success at radius \(r-1\).  Equivalently,
its mass is \(h^{(\le r-1)}-h^{(\le r)}\).  The no-repair event is exactly the extrinsic erasure
failure probability.  No finite-radius MAP or capacity claim is made.

## Human proof and body boundary

The manuscript now gives the complete finite-subset partition, differentiation, transversal, and
radius-event arguments.  The previous one-paragraph appeal to conditioning and inclusion--exclusion
no longer carries the theorem.

Exact field-nine Bernstein rows, EXIT deficits, and Poisson approximations were removed from the
body theorem chain.  They remain computational refinements rather than premises for reliability,
bounded EXIT, or the geometric parallel/series contrast.

## Formal correspondence

The new module `RepairPorts.Reliability` supplies:

- `subsetAverage_delete_contract`;
- `hasDerivAt_update_subsetAverage`;
- `portReliability_delete_contract`;
- `hasDerivAt_portReliability_update`;
- `hasDerivAt_homogeneous_portReliability`;
- `erasureFailureProbability_delete_contract`;
- `noRepairProbability_eq_erasureFailure`;
- `truncatePort_mono`;
- `cheapestRepairRadiusProbability`;
- `cheapestRepairRadiusProbability_eq_failure_sub`;
- `blockerCount_eq_minimalBlockerCount_at_minimum`; and
- `blockerFailurePolynomial_eq_minimum_term_add_remainder`.

The import-only gate `RepairPorts.Gates.CompletePorts` imports the module and prints the axioms of
the paper-facing terminals.  Every audited declaration reports exactly `propext`,
`Classical.choice`, and `Quot.sound`; there is no certificate, native evaluation, generated finite
record, or mathematical axiom in these closures.

The closure is registered as the `complete_ports` trust area in
`lean/trust/areas/complete_ports.toml`, with its human boundary in `lean/RepairPorts/TRUST.md`.
The registry enumerates every terminal printed by the aggregate gate, including the shared
`FiniteGeom` and `RepairCodes` conclusions used by the paper.  A clean detached replay produced
`lean/trust/facts/RepairPorts.Gates.CompletePorts.json`, so the registry records observed rather
than merely expected closures and axiom sets.

## Validation

Completed checks:

```text
lean/scripts/guarded-lean RepairPorts/Reliability.lean
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
python3 lean/scripts/lean-trust-spine.py audit --area complete_ports
git diff --check -- <C675-owned paths>
```

The single-file elaboration is warning-free.  The private PDF rebuilt without TeX warnings.  The
aggregate `RepairPorts.Gates.CompletePorts` queue run passed, and its immediate exact-current replay
skipped the current target before passing the trace-only aggregate gate.  The trust spine accounts
for all 36 printed terminals; `audit --area complete_ports` reports zero findings.

## Closeout: extra value and expert-pressure pass

The Janson--O'Donnell pressure test exposed two cheap statement-adequacy upgrades.  First, the formal
failure convention now identifies the averaged no-repair indicator with extrinsic erasure failure,
so the \(L=\infty\) clause is not left as notation.  Second, the blocker theorem now identifies
minimum-cardinality transversals with inclusion-minimal blockers and produces an exact
\(p^{\tau+1}\)-divisible remainder, rather than leaving the printed \(O\)-term to an informal
coefficient gloss.

## Mystery ledger

| Mystery | Closeout verdict | Evidence or boundary |
|---|---|---|
| Does coordinate differentiation really equal pivotal probability, rather than only a formal contract-minus-delete difference? | Settled by monotonicity of the port indicator and `discreteDerivative_portSuccessIndicator` | `hasDerivAt_portReliability_update` |
| Does the homogeneous derivative sum every coordinate influence? | Settled by induction on the finite helper universe | `hasDerivAt_homogeneous_portReliability` |
| Does \(b_\tau\) count inclusion-minimal blockers, and is the remainder genuinely of order \(\tau+1\)? | Settled by the minimum-cardinality/minimality bridge and exact polynomial factorization | `blockerCount_eq_minimalBlockerCount_at_minimum`; `blockerFailurePolynomial_eq_minimum_term_add_remainder` |
| What survives outside the body proof chain? | Exact finite profiles and unformalized Poisson approximations only | Appendix-computation boundary in the manuscript and ledgers |

No genuine C675 mystery remains.  No incidental observation outside the planned reliability,
bounded-EXIT, and statement-adequacy work warranted a discovery-track entry.
