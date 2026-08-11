# C904 Paper V alignment-import synthesis

**Lane:** `clebsch`

**Date:** 2026-08-11

**Final manuscript commit:** `597dcc75`

**Final PDF SHA-256:**
`83f51b6f79bea157ab0f394750242f40910e27c12cf8711a918e073706a2586b`

**Final source SHA-256:**
`9cfd59d6b93e53548f7113c17bb7ad5bafa8afc5bcd1cb03c07cdea01738ec3e`

## Imported theorem

For a two-graph on six points, represented by a Seidel matrix $S$, put

$$
 \sigma(xyz)=S_{xy}S_{yz}S_{zx},\qquad
 m(xy)=\sum_{z\notin\{x,y\}}\sigma(xyz).
$$

If $A(\Delta)$ is the family of four-sets on which the four triangle signs
are constant, then

$$
                    16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2.
$$

Hence $A(\Delta)=\varnothing$ exactly when $S^2=5I$.  The result
recognizes the unmarked conference locus; it does not select one of the
twelve labeled switching classes.  The recovered $A_5$-action selects the
unique invariant opposite pair used by Paper V's outer-difference theorem.

## Red-team boundary

The broad C880 package was not imported.  The general-$n$ extremal theorem,
regular-design refinements, promised-anchor bounds, and query-complexity
consequences remain in C880/Paper III.  Paper V imports only the order-six
identity that strengthens conference recognition and explains the empty
alignment fibre at Paper III's sharp six-point boundary.

The red team corrected three source-level formulations before promotion:

1. conference two-graphs are exact minimizers only at orders where they
   exist;
2. the low-order negative-bound sentence has natural scope $4\le n\le5$;
3. constant two-graphs are a degenerate exception to the claim that every
   nonconference regular two-graph has a non-3-design aligned family.

Those corrections landed with the expanded C880 package in commit
`f7558fc5`.

## Attribution

The bounded precedence audit is
`notes/2026-08-11-c880-item5-six-point-recognition-literature-audit.md`,
commit `88603127`.  It found no exact predecessor under explicitly recorded
coverage gaps.  Paper V makes no standalone novelty claim.  It credits:

- Iranmanesh--Askari Farsangi for the classical fourth-power conference
  equality criterion;
- Gillespie for coherent/incoherent four-set counts in regular two-graphs;
- Bussemaker--Mathon--Seidel and Goethals--Seidel for the classical order-six
  class and conference conventions.

## Manuscript integration

- the abstract states both the empty-alignment recognition and its unmarked
  twelve-class limitation;
- the introduction places the sum-of-squares identity between carrier recovery
  and the $A_5$-selected outer bridge;
- the new lemma has a complete four-line indicator/summation proof, with Seidel,
  switching, and complement conventions explicit;
- the Paper III seam names *Aligned-design faithfulness* and restricts the new
  result to the empty-alignment fibre at the six-point boundary;
- the pre-existing normalization-order ambiguity was repaired: Paper-II
  placement fixes the pivot generator, and the later outer-action proposition
  proves the full conference normalization rather than assuming it;
- the conclusion records alignment recognition as a distinct unmarked stage
  before outer difference restores orientation.

No groupoid object, morphism, fibre, $uq$-quotient, lattice theorem, modular
extension, or Paper-IV comparison changed.

## Validation and review

- `make check`: pass under the repository Nix manuscript environment;
- TeX spacing lint and evidence replay: pass;
- final PDF: twenty-two pages, 180474 bytes;
- TeX log: no warnings, undefined references, overfull boxes, or underfull
  boxes;
- outer review: GO;
- blind review: GO after normalization-order repair;
- conference/lattice review: GO after convention and six-point-scope repair;
- series review: GO after the Paper III boundary was restricted to the
  empty-alignment fibre.

The final external-review artifact remains
`papers/clebsch-round-trip/golden_companion_reconstruction.pdf`, with the hash
recorded above.

## Mystery ledger

- **Settled — why the six-point boundary is special.**  At six points the
  constant term in the general defect count vanishes, leaving the pure sum of
  squares $16|A|=\sum m^2$.  Empty alignment therefore forces conference
  regularity without spectral theory.
- **Settled — why recognition does not orient.**  Empty alignment leaves twelve
  labeled switching classes, in six complement pairs.  The recovered
  $A_5$-action, not the defect identity, selects the invariant opposite pair;
  the selected chordal line and outer difference then orient it.
- **Settled — whether the broader C880 theorem belongs in Paper V.**  It does
  not.  General extremality, design parameters, arithmetic nonexistence, and
  query complexity belong to Paper III/C880.  Their import would add a second
  narrative without strengthening V's classification theorem.
- **Open evidence boundary — precedence.**  No exact predecessor was located,
  but MathSciNet, direct zbMATH results, three rate-limited Semantic Scholar
  queries, and the 2015 publisher PDF remain uncovered as recorded in the
  audit.  Paper V therefore makes no independent novelty sentence for the
  identity.  No mathematical mystery remains for the imported lemma.
