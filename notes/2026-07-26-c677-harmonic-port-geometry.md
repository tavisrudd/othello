# C677 harmonic quartic--nucleus port geometry

**Lane:** `complete-ports`

**Status:** READY — task card created 2026-08-21; proof and formalization work has not started.

## Objective

Replace the quartic--nucleus flagship's mixed prose/certificate chain by uniform human proofs and
statement-adequate Lean declarations.  The admitted body result must establish the code parameters,
harmonic-circuit design, pointed radius-four ports, nucleus-gate closure mechanism, and the
reliability consequences that follow formally from those ports.  Exact field-nine rows and finite
propagation witnesses remain appendix-only evidence.

## Frozen mathematical statement

Let (q=3^h\geq9),

\[
V(t)=(1,t,t^2,t^3,t^4),\qquad V(\infty)=e_4,\qquad N=e_2,
\]

and let (S_q=\{V(t):t\in\mathbb P^1(\mathbb F_q)\}\cup\{N\}).  For the row code
(Q_q) on these columns, prove:

1. (Q_q) has parameters ([q+2,5,q-3]_q) and (d(Q_q^\perp)=5).
2. The circuits of size at most five are exactly (\{N\}\cup B), where (B) is a
   harmonic quadruple of (\mathbb P^1(\mathbb F_q)).
3. The harmonic quadruples form the characteristic-three Steiner system (S(3,4,q+1)).
4. The radius-four nucleus repairs are the blocks (B); the radius-four repairs of a curve target
   (x\in B) are (\{N\}\cup(B\setminus\{x\})).
5. Every curve-target radius-four repair has the compulsory helper (N), whereas the nucleus has a
   parallel family of four-helper repairs.  State only reliability and bounded-EXIT consequences
   already implied by the general port theorems.
6. If (D(S)) closes a curve set under harmonic completion, then

   \[
   \operatorname{cl}_4(S)=S
   \quad\text{when (S) contains no harmonic block},
   \]

   \[
   \operatorname{cl}_4(S)=\{N\}\cup D(S)
   \quad\text{otherwise},
   \qquad
   \operatorname{cl}_4(S\cup\{N\})=\{N\}\cup D(S).
   \]

The classical normal-rational-curve nucleus theorem and any standard
(\operatorname{PGL}(2,q)) orbit/design result used must be identified at theorem or section level,
with field, coordinate, and normalization conventions reconciled explicitly.

## Human-proof obligations

The proof must expose the following mechanisms rather than citing the field-nine certificate.

- Compute the determinant of four quartic columns together with (N).  For four finite parameters
  (a,b,c,d), isolate the condition (e_2(a,b,c,d)=0); with (\infty) present, isolate
  (a+b+c=0).
- Prove unique harmonic completion of every triple, including the (e_1=0) branch and every triple
  containing (\infty), and prove that the completion is distinct from the original triple.
- Deduce the Steiner (S(3,4,q+1)) property and reconcile this coordinate definition with the
  harmonic (\operatorname{PGL}(2,q))-orbit convention.
- Prove that five curve columns are independent, that (\{N\}\cup B) is a circuit exactly for a
  harmonic block, and that no smaller circuit occurs.
- Prove the sharp hyperplane intersection bound of five points on (S_q), including its equality
  case.  Deduce rank five, primal distance (q-3), and dual distance five without finite
  enumeration.
- Translate circuits to pointed repair sets and derive the series/parallel contrast and closure
  identities directly.

The proof must treat the characteristic-three parity/nucleus boundary explicitly.  It must not
silently generalize the theorem to other characteristics or to (q=3).

## Lean target

Add a referee-facing module under `lean/RepairPorts/`, provisionally
`RepairPorts/HarmonicQuartic.lean`, and import it from
`RepairPorts.Gates.CompletePorts`.  Stable public declarations should cover, at minimum:

- the quartic-column determinant identities for finite parameters and for a triple with infinity;
- unique, distinct harmonic completion of a projective triple in characteristic three;
- the resulting Steiner unique-block property;
- the circuit characterization and absence of circuits of size below five;
- the code rank and distance conclusions, with every classical input exposed in the theorem type
  if it is not re-proved;
- the nucleus and curve-target radius-four port descriptions;
- the compulsory-nucleus/parallel-block contrast; and
- the abstract harmonic-completion closure identities.

Formal definitions should follow the intrinsic geometry: projective triples and harmonic blocks
first, coordinates only for the proof.  Do not encode the task ID, manuscript section, private
paths, or workflow status in Lean names or comments.  The exact module placement and API shape must
be settled before the first public declaration if existing `FiniteGeom` abstractions make the
provisional `RepairPorts` location inappropriate.

## Statement-adequacy gate

Before body admission, compare the manuscript theorem and every Lean terminal field by field:

| Field | Required match |
| --- | --- |
| Ambient field | finite field, characteristic three, (q=3^h\geq9) |
| Point set | (q+1) quartic normal-rational-curve points plus the displayed nucleus |
| Code | row span of the displayed projective columns |
| Parameters | exact length, dimension, primal distance, and dual distance |
| Circuits | iff classification through harmonic quadruples, including minimality |
| Design | every projective triple has one distinct completion |
| Ports | exact radius-four nucleus and curve-target families |
| Closure | all three displayed closure identities |
| Reliability | only consequences of the formal port identities and existing general theorems |
| Trust | printed axioms and all classical inputs named explicitly |

Surrogate finite sets, assumed circuit inventories, or a theorem specialized only to (q=9) do
not satisfy this gate.

## Computation and appendix boundary

The field-nine facts ((\nu,\tau)=(2,5)) at the nucleus, 30 nucleus repairs, 12 repairs at each
curve target, exact Bernstein/EXIT rows, and the block-free five-set propagation witness are
appendix-only.  Existing exact certificates may illustrate them, but no body theorem or Lean
terminal may depend on those certificates.  Any retained finite claim must keep its exact replay,
hashes, checked domain, and trust boundary.

## Owned paths

- `notes/2026-07-26-c677-harmonic-port-geometry.md`;
- `notes/handoffs/2026-07-17-complete-ports-paper.md` and the live/archive queue at closeout;
- `papers/complete-repair-ports/complete_repair_ports.tex` and its tracked PDF;
- the C677 rows in `papers/complete-repair-ports/` control ledgers;
- a new harmonic module under `lean/RepairPorts/` and the corresponding additions to
  `lean/RepairPorts/Gates/CompletePorts.lean`, `lean/RepairPorts/TRUST.md`, and the
  `complete_ports` trust registry/fact; and
- existing field-nine evidence only when a necessary appendix relabel or reproducibility repair is
  identified and recorded first.

Do not edit cubic, Clebsch, shared build-system, generated certificate, or other lane-owned sources.

## Acceptance gates

1. Complete human proof with the field and projective conventions explicit.
2. Matching Lean declarations elaborate without warnings.
3. The manuscript and all five complete-ports control ledgers agree field by field.
4. `RepairPorts.Gates.CompletePorts` passes through the guarded build queue.
5. The printed axiom audit and `complete_ports` trust-spine audit pass with every classical input
   accounted for.
6. The private manuscript rebuilds without TeX warnings.
7. Every retained field-nine claim is visibly appendix-only and its existing replay remains green.
8. The required extra-value and expert-pressure closeout is recorded with a mystery ledger.
9. Task lifecycle closeout archives C677, removes it from the live queue, advances the handoff to
   C678, and commits only task-owned paths.

## First proof move

Derive and normalize the two determinant identities, then prove unique distinct harmonic completion
for all projective triples.  This is the common source of the Steiner design, the circuit
classification, and the nucleus-gate closure rule; no downstream code or reliability statement
should be formalized before this lemma is stable.
