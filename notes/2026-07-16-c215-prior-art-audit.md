# C215 prior-art audit: quotient weights, coset leaders, and pointed fibers

**Lane:** `repairports`
**Status:** bounded targeted audit complete; novelty boundary narrowed.

## Verdict

The ordinary functional-fiber cost is classical structure. Under the surjection

```text
Phi_I : F^K -> V*,       ker(Phi_I) = I^perp,
```

the value

```text
lambda_I(beta) = min { wt(w) : Phi_I(w) = beta }
```

is exactly the Hamming weight induced on the quotient `F^K / I^perp`, transported to `V*`.
Equivalently, it is the coset-leader or syndrome weight of `beta`. Its coordinatewise additive
extension and the minimum distance of an outer code under that extension are likewise standard
quotient-metric constructions. C215 must not claim novelty for `lambda_I`, its triangle/additivity
properties, the basic fiber decomposition, or the resulting unpointed weighted minimum distance.

The plausible contribution boundary is narrower:

- the coordinate-pointed cost
  `min { wt(w) : Phi_I(w) = beta, w_x != 0 }`, including the possibility `top`;
- the exact separation of zero- and nonzero-functional sectors after excluding the embedded
  one-block inner-dual word;
- the use of those target-conditioned quantities to classify the first obstruction to literal
  repair-port preservation under concatenation.

This audit found adjacent support/split enumerators and unequal-error-protection separation vectors,
but no source identifying that specific constrained-coset cost or the repair-hypergraph
application. That is a bounded negative search result, not proof of novelty.

## Source findings

### Induced quotient weights subsume the ordinary cost

Eimear Byrne defines, for a weight `w` on a module `M` and submodule `K`, the induced quotient
weight

```text
w_hat(x + K) = min { w(z) : z in x + K }.
```

The paper also transports this weight across any epimorphism with kernel `K` and extends a symbol
weight additively to words. Taking `M = F^K`, `K = I^perp`, `w = wt_H`, and the epimorphism
`Phi_I` gives `lambda_I` verbatim. Consequently `functionalTupleCost` is the standard additive word
weight and the minimum over the nonzero outer functional dual is its minimum distance.

Source: E. Byrne, *Induced Weights on Quotient Modules and an Application to Error Correction in
Coherent Networks*, arXiv:1611.09616v2, especially Definitions 2--3 and the additive extension
immediately following them. Cached full text: key `arXiv:1611.09616`, SHA-256
`ff2ac306e6bb8f777b1c9383660ff95c8dd3dac0ca43275faf67f82ef61dad05`.

### Coset-leader and syndrome language is exact, not merely analogous

Jurrius and Pellikaan define the weight of a coset as the minimum Hamming weight in that coset and
identify it with syndrome weight: the minimum number of parity-check columns needed to represent
the syndrome. Thus the C215 cache's ordinary table is a syndrome/coset-leader table for `I^perp`,
with `blockFunctional` serving as the syndrome map up to the chosen isomorphism with `V*`.

Source: R. Jurrius and R. Pellikaan, *The coset leader and list weight enumerator*, Contemporary
Mathematics 632 (2015), Definition 3.1 and Definition 3.10. Cached full text: DOI
`10.1090/conm/632/12631`, SHA-256
`99a2c5d1625af85d4c5560276b45728acaba347dd13f88d789d49b792f714b95`.

The same literature emphasizes that generic coset-leader enumeration is difficult and that even
rich ordinary weight data need not determine coset-leader data. This supports treating tractable
inner families and symmetry reduction as substantive algorithmic questions rather than assuming a
generic polynomial-time evaluator.

### Weighted-Hamming work is adjacent but different

Bitzer, Ravagnani, and Weger assign fixed multipliers to coordinate blocks,
`sum_l lambda_l wt_H(a_l)`, and build generalized concatenated codes tailored to those block
weights. C215 instead assigns a symbol-dependent induced quotient weight to each element of `V*`
and then sums it across outer coordinates. The recent paper therefore reinforces that weighted
metrics and generalized concatenation are active prior art, but its metric does not subsume the
pointed constrained-coset cost.

Source: S. Bitzer, A. Ravagnani, and V. Weger, *Weighted-Hamming Metric: Bounds and Codes*,
arXiv:2601.12998v1, Sections II and IV. Cached full text: key `arXiv:2601.12998`, SHA-256
`021016a31868e638fdc035f1dc4791441809579e591079f3c93b5c87d42f84a8`.

### Enumerator and separation-vector overlap

The full fiber enumerator identity

```text
sum_beta product_j W_(beta_j)(z)
```

is the direct coset-enumerator/complete-enumerator substitution associated with the dual fiber
decomposition. It is useful bookkeeping and can transfer refined data, but the formal sum-product
identity alone is not a novelty claim. A contribution would require a new closed form, transform,
or consequence for a nontrivial repair family.

Unequal-error-protection separation vectors minimize output weight subject to a chosen message
coordinate being nonzero. This is conceptually adjacent to pointed costs, but the constraint is on
an input/message coordinate of an encoder, whereas C215 constrains a specified coordinate of a
representative inside a fixed syndrome coset. Support and split weight enumerators similarly retain
coordinate information without, in the sources inspected, isolating C215's constrained minimum.

Primary historical anchor: L. A. Dunning and W. E. Robbins, *Optimal Encodings of Linear Block
Codes for Unequal Error Protection*, Information and Control 37 (1978), 150--177. Repository-backed
secondary full-text check: W. J. van Gils, *On Linear Unequal Error Protection Codes*, Eindhoven
University of Technology thesis (1982/1986 repository record).

## Claim policy

- Call the ordinary cost an induced quotient Hamming weight, coset-leader weight, or syndrome
  weight, with citation.
- Present the cached evaluator as a verified simultaneous syndrome-table construction augmented by
  pointed minima, not as invention of syndrome decoding.
- Treat the fully fiberwise formula as an exact specialization to repair-port obstructions.
- Reserve novelty language for the pointed/nonembedded classification and a strict natural
  application, subject to a later referee-grade search.
- Do not promote C215 without the strict natural example required by the handoff.

## Evidence boundary

This was a targeted search over induced quotient weights, coset-leader and coset weight enumerators,
weighted-Hamming metrics, generalized concatenation, separation vectors, and support/split
enumerators. It was not a systematic review of every generalized-concatenation or unequal-error-
protection reference. The positive identification of `lambda_I` as an induced quotient weight is
definition-level and decisive. The absence of a pointed analogue is only provisional.

## Next step

Construct a strict natural inner/outer pair for which the ordinary outer functional-support gate
fails but the induced quotient-weight criterion proves the required repair-port preservation. The
example must derive its gain from nonconstant syndrome weights, not from a synthetic boundary case.
