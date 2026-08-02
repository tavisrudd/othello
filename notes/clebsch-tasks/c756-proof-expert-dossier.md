# C756 proof-expert routing dossier

**Lane**: `clebsch` · **Load policy**: optional; load only when C756 is stuck or
its proof state is being reviewed.

This supplements the general finite-projective-arcs persona.  It records only who
matches the remaining proof interfaces and what to ask them; it is not a biography,
literature audit, or restatement of C756.

## Escalation order

1. **Simeon Ball — first call, whole proof.**  His arc-associated matrices,
   coordinate-free Segre tangent equations, and tangent tensors match the passage from
   rowwise angle identities to a global section.  Ask whether the distinguished
   kernel line of the angle matrix is a specialization of the standard arc tangent
   tensor, and whether full angle binomiality forces nullity one.
2. **Aart Blokhuis — polynomial obstruction.**  His Rédei/lacunary-polynomial work
   and the Blokhuis--Marino--Mazzocca prime-field classification of generalized
   hyperfocused arcs are the closest match to forcing a four-point endpoint.  Ask for
   a hyperfocused or lacunary reformulation of constant-kernel alignment, initially
   over prime fields.
3. **Christian Krattenthaler — adjugate/compound calculation.**  Give him the
   rank-three double-displacement identity, not the geometry.  Ask for an explicit
   adjugate-kernel recurrence in the nullity-one branch and a second-compound formula
   in the nullity-two branch, using Cauchy double-alternant or confluent techniques.
4. **Michel Lavrauw — globalization and extension fields.**  Ask whether Ball--Lavrauw
   arc tensors globalize the cofactor line on the degree-$q+3$ arc divisor and which
   Frobenius/inseparability exceptions prevent a prime-field proof from extending to
   $q=p^h$.
5. **Bence Csajbók — local Segre upgrade.**  Ask whether the full angle-binomial rows,
   combined with the coordinate-free lemma of tangents, force a four-point identity
   that excludes the nullity-at-least-two branch or permits an inclusion-matrix descent.
6. **Amin Shokrollahi — structured-kernel bridge.**  Ask for a finite-field
   interpolation or decoding interpretation of the iterated displacement equation,
   especially a short generator for its kernel and compounds.  He is a matrix/coding
   bridge, not the first choice for the final conic geometry.

**Best collaboration shapes:** Ball alone; Ball--Blokhuis for the theorem;
Ball--Blokhuis--Krattenthaler if the adjugate remains opaque.  Prokofev--Zabrodin's
elliptic Cauchy factorization work is a high-variance technical fallback only.

## What a useful expert response must supply

- an intrinsic meaning for the adjugate kernel line, not another ordinary-rank bound;
- a clean split between nullity one and the second-compound branch;
- a degree, lacunarity, or local-pattern contradiction that uses all rows
  simultaneously; and
- an explicit audit of the prime-power boundary.

Do not spend an expert interaction rederiving sign coherence, spectral tightness, or
the bounded rank profiles.  Send the cross-ratio rank report and the TT angle-bijection
report as the minimal technical packet.

## Abstracts scanned

- Ball: [matrix bounds for extending arcs](https://arxiv.org/abs/1603.05795).
- Ball--Lavrauw: [coordinate-free planar arcs](https://arxiv.org/abs/1705.10940),
  [arc tangent tensors](https://arxiv.org/abs/1904.12800), and
  [general Segre-tangent survey](https://arxiv.org/abs/1908.10772).
- Blokhuis: [Rédei/lacunary polynomials](https://arxiv.org/abs/math/0304463);
  Blokhuis--Marino--Mazzocca:
  [generalized hyperfocused arcs](https://arxiv.org/abs/1304.3617).
- Ball--Csajbók: [reformulations of Segre's lemma](https://doi.org/10.1016/j.endm.2018.06.003).
- Krattenthaler: [determinant calculus](https://arxiv.org/abs/math/9902004) and
  [its complement](https://arxiv.org/abs/math/0503507).
- Olshevsky--Shokrollahi:
  [displacement methods for algebraic-code kernels](https://www2.math.uconn.edu/~olshevsky/papers/shokrollahi_f.pdf).
- Prokofev--Zabrodin:
  [elliptic Cauchy determinant, inverse, product, and factorization identities](https://arxiv.org/abs/2305.02837).

These are abstract-level routing signals, not novelty evidence or claims that any named
person has considered C756.

## Next-session protocol

**Objective:** decide whether the Ball--Lavrauw tangent tensor globalizes the
distinguished kernel line of the angle matrix.  This is a bounded interface test, not
a general literature pass.

1. Load only the cross-ratio rank report, the TT angle-bijection report, and the
   tangent-tensor/system-of-equations sections of *Planar arcs* and *Arcs and tensors*.
2. Freeze the parameter dictionary.  Their planar-arc convention
   $|A|=q+2-t$ gives $t=(q+1)/2$ for the saturated-internal family, exactly the
   degree of the canonical tangent polynomial already constructed in C756.
3. Express the first middle coefficient of the cleared angle binomial, or equivalently
   the adjugate kernel line in the nullity-one branch, as a contraction or
   specialization of their tangent tensor.  Keep the construction over the ground
   field; record every Frobenius or Hasse-derivative seam.
4. **Positive gate:** obtain either (a) one intrinsic nonzero section of degree below
   $q+3$ whose vanishing on the arc divisor is equivalent to all first row moments,
   or (b) a tensor-rank argument showing that full angle binomiality forces nullity
   one.  Only then open the adjugate/compound calculation.
5. **Stop condition:** if the tensor merely repackages the separate tangent
   polynomials or the rowwise cofactor identity without lowering degree or coupling
   different base points, close this route in one paragraph; do not read further arc
   surveys.
6. As a cheap independent check, spend at most one short pass testing whether polarity
   produces the blocker set required by the generalized-hyperfocused-arc definition.
   If no canonical $k-1$ blockers cover all secants, discard that analogy.  Do not
   invoke the prime-field four-point theorem without this exact hypothesis.

**Deliverable:** a one-page dictionary-and-verdict note.  A positive verdict must name
the global section and its degree; a negative verdict must name the precise tensor
slot that fails to couple the rows.
