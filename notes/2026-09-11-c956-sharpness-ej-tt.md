# C956 — extra-juice and Tao-style pass after the sharpness audit

Date: 2026-09-11. Lane: `cubic-threefolds`.

This pass extracts consequences and proof-design choices from the audited packet. It does not claim a new literature result or attribute an opinion to Terence Tao. No external work was newly read; source depths and the limits of the two companion imports remain those in `2026-09-11-c956-sharpness-upgrade-audit.md` and its referee reports. No manuscript integration or new numerical claim is made.

## 1. The clean combined phenomenon is loss of infinitely many distinctions

Let T be the positive squarefree integers prime to six, and let `Y_t=X_t×P¹` for the packet's rational cubic pencil. Its already-audited assertions combine as follows:

- The surface/family construction gives `Y_t×P¹` rational over Q: use birationality of `P¹×P¹` and `P²`.
- The companion lower bound makes every `Y_t` irrational, even over C.
- The packet's local isogeny separation, together with companion Hodge conservation, makes the `Y_t` pairwise nonbirational even over C.

Thus infinitely many distinct irrational fourfolds become birational to the same projective space after one additional projective-line factor. This is already contained in the packet, not an extra proof burden. It communicates more of the upgrade than simply another list of exact-level examples. Retain the cubic construction as the proof's opening, and use this combined consequence to explain why arithmetic separation matters. Do not call this an isomorphism cancellation counterexample for affine cylinders.

## 2. Separate certified representatives from finite fibres

The squarefree family gives an explicit set with no repeated geometric isogeny class, and hence, using Hodge conservation, no repeated one-stable birational class. The repaired S-unit appendix says something different: each fixed geometric isogeny class meets the entire rational pencil in only finitely many parameters, without a height bound on those parameters.

Indeed, for a fixed t, choose the finite set S consisting of 2, 3 and its primes of positive potential toric rank. Every geometric isogeny partner u has the same potential rank at every prime and hence is potentially good outside S. The packet embeds all such u in the finite set of conjugate S-units `x+y=1`, with `x≠y`, via its explicit inverse formula. The same finiteness holds for complex-birational first-stabilization partners with rational pencil parameter, using Hodge conservation.

This consequence needs no exact identification of the partner set and no generic Torelli theorem. It does not say each fibre has one member, does not extend to all complex parameters, and does not bound all partners outside this pencil. It also does not give a birationality decision algorithm: the finite set contains necessary candidates, not certified affirmative partners. An effective enumeration theorem is not an implemented solver.

Editorial decision: this is the strongest reason to retain a short S-unit appendix. If retained, name its consequence “finiteness of rational pencil partners” before explaining the unit equation. The main integer-family theorem does not depend on it.

## 3. The reusable arithmetic statement is smaller than the decomposition

For the applications, package the outcome of the five-factor calculation as one proposition: for reduced `t=a/b` and p≥5, potential toric rank is one at numerator primes, three at primes dividing `16a²−27b²`, and zero elsewhere. Explain that isogenies preserve this rank. The complete elliptic formulas prove the proposition but need not interrupt each downstream argument.

The proof does not require the five elliptic factors to be pairwise nonisogenous, generic independence of their j-invariants, or a product principal polarization. Factor coincidences do not spoil additivity of toric rank. These are absent hypotheses to keep absent. The valuation proof and the integer separation already cover exceptional coincidences.

Do not replace the rank invariant by an unordered set of elliptic factors without a separate argument: distinct displayed factors can lie in the same isogeny class. The rank proof avoids that classification problem entirely.

## 4. Highest-value restraint

The three-dimensional family and the one-dimensional arithmetic pencil perform complementary jobs. The first establishes geometric breadth; the second supplies explicit separation. There is no need to classify all geometric partners in the three-dimensional family before the paper has a coherent endpoint.

The optional quadratic coefficient-height count is stronger quantitatively but introduces a sieve theorem. The integer theorem gives a positive-density sequence through elementary squarefree counting. Put it first. Retain the short square-to-sector transfer lemma already proved in the audit if the height result stays.

The exact relation to previously studied decomposable Jacobian loci is a worthwhile later comparison, not an assumed novelty fact. Identifying those loci could improve attribution or simplify formulas; failure to do so currently does not invalidate the local separation proof. No claim that the pencil is new should be based on this pass.

## Mystery ledger and next gate

| Question | Status | Consequence or exact gap |
|---|---|---|
| Do coincident elliptic factors break separation? | Settled | Toric rank is additive with multiplicity; no independence hypothesis is used. |
| Does the arithmetic input explain more than infinitely many examples? | Settled | It supplies explicit distinct representatives; optional S-units give finite rational-parameter fibres. |
| Does finite candidate enumeration solve birational classification? | No | Affirmative identification of surviving partners is unproved and unnecessary here. |
| Can the analytic sieve leave the main theorem? | Yes | The squarefree integer subfamily already gives the principal separation result. |
| Is this pencil a previously studied special locus in different coordinates? | Open comparison | Requires an explicit identification or bounded source investigation before any priority claim; do not infer an answer from j-formulas alone. |

No further unexplained mathematical obstruction was exposed. The highest-value next step remains the short geometry/domain repairs and precise reduction citation, followed by restrained integration. Do not delay those repairs for a new moduli-classification project.
