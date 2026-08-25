# C956 result inventory

This document ranks only the proved results relevant to the replacement
manuscript. It is an editorial map, not part of the mathematical argument.

## The paper's theorem spine

### 1. Exact level for two explicit cubic threefolds

For each displayed smooth cubic threefold `X/Q`,

`ell_Q(X) = ell_C(X_C) = 2`.

Equivalently, `X_C x P1` is irrational and `X x P2` is rational over `Q`.
This is the title theorem: it is sharp, immediately legible, and directly
answers the level-of-stable-rationality question for explicit smooth cubic
threefolds.

The lower bound is the separately cited theorem that every smooth complex
cubic threefold remains irrational after multiplication by `P1`. The upper
bound is proved in this paper.

### 2. Two-variable rationality for quartic del Pezzo surfaces

Let `k` have characteristic zero and let `S/k` be a smooth quartic del Pezzo
surface. If `S(k)` is nonempty and `Pic(S_bar)` is a stably permutation
Galois module, then `S x A2` is `k`-rational. In particular, this holds for
every stably `k`-rational smooth quartic del Pezzo surface.

This is the strongest general geometric theorem in the paper. It turns the
existence of a stable-permutation decomposition into a uniform bound of two
variables by a nonlinear quotient construction.

### 3. Rational quotients from tangent sections

Let a rank-`r` torus act projectively linearly and generically freely on a
variety parametrized by generic tangent projection. A descended
codimension-`r` tangent section is a rational section of the action when it
retains `r+1` weight blocks whose differences form an integral basis and its
coefficient matrix has nonzero maximal minors. Hence the Rosenlicht quotient
is rational.

This is the most reusable theorem in the paper. The proof is constructive:
signed maximal minors compute the orbit correction and the inverse graph
computes the birational parametrization. It applies independently of the
quartic-del-Pezzo setting when its geometric and descent hypotheses can be
verified.

### 4. A descended tangent section for the four Galois types

For each of the four hereditary-`H1` Galois types of a minimal quartic del
Pezzo surface, the projective Cox model has the saturated rank-three subtorus
and descended tangent section required by the quotient theorem.

This is the technical bridge between the general quotient criterion and the
surface theorem. The main text explains the incidence and descent argument;
the appendix and exact-arithmetic certificate verify the four-witness cover.

## Consequences retained in the paper

### Both cubic series in every dimension

For every `r >= 0` and each of the two explicit series,
`X_{j,r} x P2` is rational over `Q`. The proof is an identity of function
fields over the generic-fibre base and uses no specialization argument.

The smoothness, quartic-del-Pezzo fibrations, and Galois-type computations are
imported from Tschinkel--Zhang Propositions 5.1 and 5.2. The surface theorem
then gives their stable-rationality conclusions with the uniform `P2` bound.

### Rationality after affine-line stabilization

For `Y = X x P1`, where `X` is either displayed cubic threefold, `Y` is a
smooth projective nonrational fourfold over `Q`, remains nonrational over `C`,
and `Y x A1` is rational over `Q`.

This is the most memorable secondary consequence. It answers the question
raised by Tschinkel--Zhang on p. 13 asking for a nonrational variety `Y` with
`Y x A1` rational. It is a birational rationality statement after affine-line
stabilization, not an assertion about isomorphic affine cylinders.

### Variation in cubic-threefold moduli

The function `ell_C` takes the value two on every isomorphism class represented
by the displayed examples and is infinite at a very general point, using the
cited very-general stable-irrationality theorem. This places the explicit
calculation in the geometry of the smooth cubic-threefold moduli space without
asserting that the two displayed complex points are distinct or saying
anything about all special points.

A bounded review of C925 found no proved pointwise stable-irrationality
theorem for every smooth member of a positive-dimensional cubic family.  Its
all-members result concerns auxiliary `b_3=0` Fano carrier families, and its
candidate origin-anchored marked-block invariant was withdrawn after a
splitting gap.  The adjacent `A_5` pencil is universally `CH_0`-trivial, so it
does not supply the desired diagonal obstruction.  Such a family theorem is a
separate research problem and is not part of this manuscript.

## Essential proof repair retained

The visible sign cocharacters span an index-two sublattice. Passing to its
saturation adds the half-sum cocharacter and removes the apparent projective
`mu_2` kernel. The integral-basis hypothesis in the quotient theorem is what
distinguishes a rational section from a finite orbit cover.

## Independent follow-up

The calculations also isolate a rational five-dimensional torus with CARAT
character class `(5,232,15)` whose dual class `(5,232,14)` is reported as not
retract rational in the cited classification. This is mathematically
independent of the cubic paper and should be developed, source-audited, and
released separately if pursued.

## Final hierarchy

| Role | Result |
|---|---|
| Title and abstract | exact level two for the two explicit cubic threefolds |
| General geometric theorem | `S x A2` rational for the stated quartic del Pezzo surfaces |
| Reusable mechanism | rational torus quotient from a unimodular tangent section |
| Main series consequence | both explicit cubic series are rational after `P2` |
| Memorable secondary consequence | a nonrational projective fourfold rational after `A1` stabilization |
| Moduli context | level two at explicit points and infinite very generally |
| Separate follow-up | rational torus with non-retract-rational dual |

## Final review and replay state

The full one-stabilization manuscript was read as context, including its
complete QDM-marker proof. It supplies only the cited universal lower bound;
the present paper does not import its proof mechanism or suggest an unproved
second-stabilization consequence.

Three hostile specialties now clear the mathematics. The final quotient and
computation audit mutation-tested both artifact values and macro placement.
The generator constructs the actual evaluation-kernel slice through the
orbit-test point, verifies that its coefficient matrix annihilates
`(1,1,1,1)^t`, checks all maximal minors, derives the branch table and
coprimality arithmetic, and renders every computation-derived manuscript
value into a checksum-bound TeX artifact. Lean coverage for the new theorems
is honestly absent; the tracked paper-facts audit is current.

Authority commits:

- `f966149e5`: final mathematical, computational, README, metadata, and
  portfolio-summary repairs;
- `91f619b28`: corresponding standalone-export rewrite repair.

Local forward exports:

- paper mirror `/home/tavis/src/math-papers/cubic-stabilization-irrationality`
  at `4255cbc`, with standalone `nix develop --command make check` and exporter
  verification green;
- portfolio mirror `/home/tavis/src/math-papers/math-papers-summary` at
  `01b7fb0`, with the authority and mirror README hashes identical.

## Next fresh session

Do not reopen the retired conditional all-stabilizations route. The local
manuscript and both local exports are the canonical release candidates.
Before public publication, make three explicit author-side archival decisions:

1. push the two local mirror commits only when the author approves publishing;
2. replace the obsolete GitHub About description and clearly mark the old
   releases/tags as superseded without erasing the history;
3. create a new Zenodo concept DOI for this mathematically different paper and
   mark `10.5281/zenodo.21937490` superseded or withdrawn rather than adding a
   seventh version to that retired concept.

The current arXiv DOI for Tschinkel--Zhang is
`10.48550/arXiv.2608.20029`; no publisher DOI was found in the bounded final
audit. No manuscript DOI is claimed in the repository until a new deposit
exists.
