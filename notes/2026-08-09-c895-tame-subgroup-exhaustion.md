# C895 tame subgroup exhaustion

**Date:** 2026-08-09  
**Task:** C895  
**Status:** positive exact corollary; group-theory challenge pending

## Claim

Let `K` be the stabilizer in `H=PSL_2(q)` of a perfect matching of
`P^1(F_q)`.  Once the elementary unipotent argument proves that `p` does not
divide `|K|`, the exhaustive abstract list is

\[
 K\text{ cyclic, dihedral, }A_4,S_4,\text{ or }A_5.      \tag{G1}
\]

No recursive descent through subfield groups is needed.

## Proof

Embed

\[
 K\le PSL_2(q)\le PGL_2(\overline{F}_p).
\]

The group `K` is finite and `p`-regular.  Faber's Theorem C classifies finite
`p`-regular subgroups of `PGL_2(k)` over a separably closed field of
characteristic `p`: up to conjugacy they are cyclic, dihedral, `A_4`, `S_4`,
or `A_5`.  Applying it over the algebraic closure gives (G1) immediately.

This argument applies to an arbitrary `K`; it neither places `K` in a
maximal subgroup nor assumes that `K` begins inside `PSL_2(q_0)`.  In
particular the square-subfield `PGL_2(q_0)` branch that obstructed the
manuscript's recursive use of Giudici never arises as a separate case.  A
subfield group has order divisible by `p`; any `p'` subgroup inside it is
already classified directly by the tame theorem.

## How it enters Paper II

Use (G1) at the start of uniform sheet exclusion.  The existing detector
case split then applies:

- cyclic and dihedral groups are separated by their action on the endpoint
  line, with the full nonsplit normalizer treated as the sole transitive
  residual;
- exceptional groups use the displayed `A_4,S_4,A_5` invariant averages;
- transitive exceptional groups are disposed of by `q+1` dividing
  `12,24,60` together with the `p'` condition.

Giudici's maximal-subgroup theorem remains appropriate later, after sheet
size `q` gives a stabilizer of the exact order `(q^2-1)/2`.  That later use
classifies maximal overgroups and performs the final small-field reduction;
it should not be presented as the source of (G1).

## Source checked

X. Faber, *Finite p-Irregular Subgroups of PGL(2,k)*, Theorem C (finite
`p`-regular subgroups), arXiv:1112.1999; published in *La Matematica* 2
(2023), 479--522.  Cached primary PDF SHA-256:

`2c32c6ec0cef4f6a5d92fba5cf899e67d16c2413ccbb517df1c03be5ab3f1e00`.

The theorem statement and its hypotheses were checked in the primary text.
This is a positive citation use, not a novelty or absence claim.

## Audit boundary

The specialist challenge should verify only that the matching stabilizer is
indeed `p'` before Theorem C is invoked and that the subsequent cyclic,
dihedral, and exceptional detector arguments depend only on the conjugacy
type supplied by (G1).  Rational conjugacy over `F_q` is not asserted or
needed at this stage.
