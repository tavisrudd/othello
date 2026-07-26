# C673 exact pointed confinement and weighted transfer

**Lane:** `complete-ports`

**Status:** COMPLETE — the exact zero-, singleton-, and multisupport-functional
profiles, pointed obstruction formula, confinement theorem, complete-port
transfer, and strict weighted example now have complete human proofs,
paper-facing Lean terminals, field-by-field adequacy checks, and a green
import/axiom gate.  The logical chain uses no fiber enumerator, certificate, or
finite replay.

## Statement and mechanism

For an inner encoder \(e:L\to I\), an ambient inner block \(w\) induces the
functional
\[
 \Phi_I(w)(a)=\langle w,e(a)\rangle.
\]
A block word lies in the concatenated dual exactly when its tuple of induced
functionals annihilates the outer code.  The functional tuple has three
disjoint strata: functional weight zero, one, or at least two.

For a fixed nonzero functional tuple \(\beta\), independent minimization in
the block fibers gives the exact pointed cost
\[
 \mu_x(\beta_j)+\sum_{\ell\ne j}\lambda(\beta_\ell).
\]
In the zero-functional stratum, a pointed nonembedded word is exactly a
pointed inner-dual word in the target block plus a nonzero inner-dual word in
some other block.  Its cost is therefore
\[
 z_x(I)=\mu_x(0)+d(I^\perp),
\]
with infinity for every impossible edge case.  The first pointed
nonembedded-witness cost is the minimum of this zero-sector cost and the
nonzero functional-tuple cost.

If that minimum is greater than \(r+1\), every radius-\(r\) pointed witness is
the zero-extension of an inner repair word in the target block.  Deleting the
target gives one inclusion of complete support ports; zero-extending every
inner repair word gives the reverse inclusion.  Finally,
\(\mu_x(0)\ge d(I^\perp)\) and
\(\mu_x(\beta_j)\ge\lambda(\beta_j)\), which yields the printed sufficient
gate
\[
 r+1<2d(I^\perp),\qquad
 \sum_\ell\lambda(\beta_\ell)\ge r+2
\]
for every nonzero functional-dual tuple.

The manuscript proof now exposes every one of these steps, including
attainment versus empty constrained fibers and the singleton stratum.  It
uses the elementary concatenated-dual pairing identity, not the classical
fiber-enumerator formula.

## Formal correspondence

`RepairPorts.PointedTransfer` adds two paper-facing terminals:

- `RepairPorts.exactFunctionalStrata` packages the exact zero-, singleton-,
  and multisupport-functional profile equivalences under the printed
  two-block and nontrivial-inner-dual hypotheses.
- `RepairPorts.exactPointedConfinementAndTransfer` identifies the pointed
  obstruction with the minimum of the closed zero-sector and nonzero
  fiberwise costs, then derives literal coordinatewise radius-\(r\) support
  port equality from the discrete cost bound \(r+2\).

`RepairPorts.Gates.CompletePorts` now re-exports and audits those declarations
together with the component cost formulas.  It also audits
`RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action`,
whose hypotheses state the regular Singer action, scalar-class equivalence,
and multiplier compatibility explicitly and whose conclusion gives
functional distance five but not six, weighted threshold six, coordinate
surjectivity, and radius-four transfer.

The Lean cost type is `WithTop ℕ`.  Thus the formal theorem is slightly more
uniform than the printed specialization: it handles one-block, trivial-dual,
and empty pointed-fiber cases without assigning an empty minimum the value
zero.  Under the paper's \(|J|\ge2\) hypothesis its closed zero-sector is
exactly \(z_x(I)\), and `↑(r+2) ≤ cost` is exactly `r+1 < cost`.

## Adequacy and trust

The theorem map, formalization ledger, statement-adequacy table, verification
map, claim/proof/novelty ledger, and detailed proof ledger now cite the exact
terminals.  The statement audit matches:

- finite alphabets, inner encoder, outer code, target, and radius;
- the three functional strata and every empty-sector convention;
- the exact pointed minimum and the numeric weighted sufficient gate;
- literal coordinatewise equality of complete bounded support ports; and
- the strict field-nine corollary with Singer regularity exposed as a theorem
  hypothesis.

Every audited transfer declaration reports exactly `propext`,
`Classical.choice`, and `Quot.sound`.  There is no imported mathematical
axiom, `sorry`, native evaluation, generated certificate, or enumerator in
the logical dependency chain.

## Validation

The final checks were:

```text
lean/scripts/guarded-lean RepairPorts/PointedTransfer.lean
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

The first gate run built the module and passed its trace-only aggregate gate.
The second reported the exact target current and passed the aggregate gate.
The manuscript build completed without warnings.

## Closeout: extra value and expert-pressure pass

The extra-value pass made the empty-sector convention part of the public
mathematical interface rather than a proof-side exception: the stronger
`WithTop` theorem remains correct even when the paper's simplifying
two-block/nontriviality assumptions fail.

The expert-pressure pass also tested the singleton stratum against the next
positive-density theorem.  It cannot be deleted from exact transfer in
general.  For the outer families used by C674, however, dual distance at least
two forces every coordinate projection to be surjective: a failed projection
of an \(L\)-linear code is zero and creates a weight-one dual word.  Thus the
singleton stratum is necessary in C673's theorem but disappears automatically
in C674's eventual family.  This is a free bridge, not a new hypothesis.

## Mystery ledger

| Mystery | Closeout verdict | Evidence or successor |
|---|---|---|
| Does the exact pointed theorem conceal a dependence on the classical fiber enumerator? | Settled negatively: the proof uses only the block-pairing characterization and independent minima | Human proof; `exactPointedConfinementAndTransfer` axiom closure |
| Can a singleton functional-dual tuple be silently discarded? | No in general; yes for C674's eventual \(L\)-linear outer families once dual distance is at least two | `exactFunctionalStrata`; elementary projection/weight-one-dual argument for C674 |
| Are empty constrained fibers or a trivial inner dual assigned a false natural minimum? | Settled: `WithTop ℕ` gives infinity and the formal theorem covers all edge cases | `pointedFunctionalFiberCost_eq_top_iff`, zero-sector closed formula |
| Is the strict field-nine conclusion computationally or axiomatically hidden? | Settled: the final declaration has only standard logical axioms and states Singer regularity as an explicit hypothesis | `RepairPorts.Gates.CompletePorts` axiom output |

No genuine C673 mystery remains.  No incidental observation outside the
planned transfer and successor-interface work warranted a discovery-track
entry.
