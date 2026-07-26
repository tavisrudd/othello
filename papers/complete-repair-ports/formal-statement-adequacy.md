# Formal statement adequacy

The adequacy test compares the printed theorem with its Lean terminal field by
field.  `PENDING` means the result is not admitted to the main proof spine.

| Paper label | Domain and quantifiers | Hypotheses | Conclusion | Trust boundary | Status |
|---|---|---|---|---|---|
| `def:complete-port` | Finite field, finite coordinate type, linear code, target, radius | Actual dual witnesses; target coefficient normalized to one | Exact support/coefficient bridge and recovery of the original code from the coefficient span | `propext`, `Classical.choice`, `Quot.sound` | `PASS` support/coefficient; survival event awaits C675 |
| `def:reconstruction-radius` | Pointed linear code over a finite field | Intrinsic isomorphism is an ambient linear equivalence carrying the dual space and every bounded normalized fiber exactly | Least coefficient radius determining the code; invariance at every radius and at the infimum | `propext`, `Classical.choice`, `Quot.sound` | `PASS` C672 |
| `thm:mds-reconstruction` | Finite field, finite coordinate type, \(k>0\), fixed target | Explicit dual MDS parameters: nonzero dual, \(\dim C^\perp+k=n\), \(d(C^\perp)\ge k+1\) | Every \(k\)-helper support occurs; the minimum coefficient port spans \(C^\perp\); it recovers \(C\); reconstruction holds iff \(k\le r\); radius equals \(k\) | `propext`, `Classical.choice`, `Quot.sound` | `PASS` C672 |
| `thm:transfer` | Finite block and inner-coordinate types, field, finite-dimensional inner message space, inner encoder, outer code, target, radius | The printed \(|J|\ge2\) identifies the zero-sector closed cost with \(z_x(I)\); the Lean terminal also handles empty edge cases with `WithTop`.  The transfer gate is exactly cost at least \(r+2\), equivalent to cost greater than \(r+1\). | Exact zero/singleton/multisupport profile formulas; exact pointed zero/nonzero minimum; literal coordinatewise equality of complete bounded support ports | `propext`, `Classical.choice`, `Quot.sound`; no enumerator, certificate, native evaluation, or mathematical axiom | `PASS` C673 |
| `cor:strict-transfer` | Nine-element characteristic-three field, completed cubic--axis inner seed, five-block generalized SPC outer code | A regular action on 820 projective functional classes, scalar-class compatibility, and multiplier equivariance state the cited Singer input explicitly | Functional distance five but not six, weighted threshold six, coordinate surjectivity, and exact radius-four transfer at every target | `propext`, `Classical.choice`, `Quot.sound`; Singer regularity is a theorem hypothesis rather than a Lean axiom | `PASS` C673 |
| `thm:prescribed` | Finite separable extension \(L/\F_q\), fixed inner encoder, length-\(N\) \(L\)-linear outer family, fixed target and radius | Outer dual distance tends to infinity; \(r+1<z_x(I)\).  Positive rate/distance is supplied separately by the named random-GV or AG/TVZ family input | Eventual confinement iff the zero-sector inequality; exact support and normalized coefficient-port copies in every block; target density \(1/m\); exact dimension and multiplicative distance bounds | `propext`, `Classical.choice`, `Quot.sound`; outer-family existence is an explicit literature input, not a Lean axiom | `PASS` C674 |
| `thm:reliability` | Every finite complete port with independent helper survival variables | Explicit target-unavailable convention | Reliability recurrence, influence derivative, and blocker expansion | Standard logical axioms | `PENDING` C675 |
| `prop:bounded-exit` | Every radius filtration of a finite port | Extrinsic erasure convention | Truncated recurrence and cheapest-radius distribution | Standard logical axioms | `PENDING` C675 |
| `thm:tutte` | Finite representable pointed matroid/code | Exact deletion/contraction and variable specialization conventions | Full reliability specialization and pointed duality | Named Las Vergnas theorem only if not reproved from ranks | `PENDING` C676 |
| `prop:filtration-boundary` | Explicit finite pointed examples or a general construction | Same unfiltered pointed invariant | Distinct bounded-radius reliability filtrations | Standard logical axioms | `PENDING` C676 |
| `thm:cubic` | Characteristic three and the exact stated lower field-size range | Displayed cubic--axis point system | Code parameters and retained exact port invariants | Standard logical axioms | `PENDING` aggregate terminal C678 |
| `thm:harmonic` | Exact even-characteristic field range | Quartic normal-rational curve and its nucleus | Code parameters, harmonic radius-four circuits, and retained port contrast | Named classical nucleus/design inputs if imported | `PENDING` C677 |

## Trust summary

No `PENDING` row may be described as formally verified in the manuscript.
Finite scripts and certificates are excluded from this table because they
cannot establish statement adequacy for a body theorem.
