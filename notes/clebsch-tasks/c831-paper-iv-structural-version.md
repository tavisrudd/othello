# C831 — Paper IV structural version

**Lane:** `clebsch`

**Status:** complete 2026-08-02; structural manuscript, evidence, Lean,
warning-free PDF, visual, and adversarial gates green; returned to C761

## Objective

Rebuild Paper IV around the longer title

> *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary
> conic code*

and integrate the successful C817 mathematics into one structural theorem
chain.  The new version must replace the weight-eight and weight-ten brute
finite leaves, make weighted-pair/full-plane recovery the headline, replace
representative orbit labels by toric--octahedral geometry, retain only the
compact \(\mathbf F_8\)-module core needed to explain spanning, and tighten
all proofs and exposition in the Milnor--Serre style.

## Adopted mathematical package

1. Replace the 111,930-subset weight-eight closure by the exact rank-28
   positive-semidefinite theta certificate and equality classification.
2. Replace both syndrome-disjointness searches in weight ten by the global
   line-intersection moment and the four \(D_{14}\)/thirty-three \(D_{28}\)
   stabilizer leaves.
3. Strengthen reconstruction to exact arity two: weighted pair concurrence
   directly recovers the passant rows, code, and elliptic relations.
4. Recover the full marked \(\operatorname{PG}(2,13)\), its conic and polarity
   from the minimum layer through the reconstructed group, Sylow-13
   subgroups, and involutions.
5. State the four minimum-word families intrinsically as one octahedral and
   three chord-indexed toric families.
6. Include the compact theorem \(K\cong\mathbf F_8^{12}\), with the three
   rank-36 relation operators acting as Frobenius-conjugate scalars, only to
   explain the Gram operators and orbit spanning.  Defer the longer
   nonsplit-torus/cuspidal and Schur-field development.

## Proof and exposition architecture

The manuscript must follow the causal order

\[
 \text{distance}\longrightarrow
 \text{minimum geometry}\longrightarrow
 \text{weighted pairs}\longrightarrow
 \text{ambient conic plane},
\]

with the binary association algebra placed after reconstruction as the
explanation of orbit spanning.  Definitions precede use; every computation
has a stated mathematical input/output boundary; workflow prose, historical
detours, and repeated trust disclaimers are removed or consolidated.

## Evidence and Lean requirements

C832 owns the formal implementation and paper-owned Lean certificate gates;
C831 owns their manuscript/trust integration and aggregate paper replay.

- Vendor the four adopted C817 exact generators/certificates into the
  paper-owned verification surface with stable schemas, hashes, independent
  replay where available, and one aggregate entry point.
- Retire the superseded weight-eight subset and weight-ten syndrome claims
  from the theorem-facing evidence and trust table without deleting useful
  historical scripts unless the paper-owned verifier no longer needs them.
- Extend the shared/paper-owned Lean surface for the theta implication,
  weight-ten moment reduction and finite stabilizer leaves, exact pair-row
  recovery, intrinsic conic-plane reconstruction, toric--octahedral support
  constructions, and compact \(\mathbf F_8\)-module theorem.
- State every remaining classical, human, native-evaluation, and trusted
  execution boundary exactly; regenerate the axiom audit and theorem map.

## Novelty boundary

The conic stabilizer, elliptic association scheme, binary incidence module,
and involution/off-conic-point/polar-axis dictionary are prior art.  The paper
may claim only the exact recovery of those structures from the q=13 minimum
layer and weighted pair data, subject to a claim-specific audit.  Tranchida's
involution--polarity formulation must be cited if the full-plane theorem is
retained.  No all-q minimum-distance, uniform toric-minimum, or cuspidal
representation claim enters this version.

## Acceptance

1. The longer title, abstract, main theorem, introduction, proof order, and
   conclusion all lead with weighted-pair recovery of the full conic plane.
2. Every C817 result selected above appears with a compact human proof and an
   exact trust boundary; all superseded brute-force prose is removed.
3. The public verification aggregate, Lean gates, theorem map, statement
   identities, hashes, and manuscript trust table agree.
4. The complete evidence, Lean, warning-free PDF, source-hygiene, visual,
   adversarial-proof, and fresh context-free cold-read gates pass.
5. C761's release surface is updated to the structural theorem, but external
   publication remains separately authority-gated.
