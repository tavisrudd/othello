# C361: affine deep-hole quotient and complete C329 enumerator

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** queued; paper-upgrade gate after C348

## Publication framing

C348 is a strong section of a combined C329/C336/C337 paper, not yet a standalone complete
deep-hole classification.  C361 owns the one result that can change that assessment: classify the
affine deep-hole `F^+`-orbits as a function of C337's intrinsic invariant `[rho;{a,b}]`, and thereby
turn C348's conditional extended-enumerator formula into an exact parameter-sensitive theorem.

The intended paper story is construction, exact evaluation-code hierarchy, intrinsic recognition,
and complete decoding/extension geometry.  The generic deep-hole/MDS-extension dictionary,
projective-syndrome interpretation, and orbit-counting language are prior mechanisms.  Novelty must
rest on an exact theorem for this new non-GRS layered family.

## Inputs and fixed reduction

Consume C329, C330, C337, and C348 read-only.  In C337's normal form,

```text
A={P(t,a):t in F} union {P(t,b):t in F}
  union {P(omega+t,0):t in F} union {P(rho*omega+t,0):t in F}.
```

C348 proves

```text
h(A)=Q M(rho,a,b)+u(rho,a,b),
```

where `M` counts affine deep-hole orbits in the quotient coordinates

```text
(xi,eta)=(u^Q+u,v+u^2) in F x E,
```

and `u=Q^2-|D(A)|` is the exact infinity-hole count from C330's seven reciprocal images.  Once
`h(A)` is known, C348 gives every coefficient of the scalar-extension coset-leader enumerator.

## Headline target

Prove one of the following, in descending value:

1. a closed formula for `M(rho,a,b)` and `u(rho,a,b)` on every admitted C329 invariant class;
2. a finite intrinsic stratification of `[rho;{a,b}]` with a closed formula on each stratum; or
3. a structural character-sum or quotient-curve formula with explicit, mechanically decidable
   strata and exact exceptional-field ledger.

The theorem must then state the complete extended coset-leader enumerator and exact one- and
two-column extension counts.  Determine the full simultaneous-extension complex only if the same
symbolic classification controls higher faces; do not substitute an uncontrolled clique census.

## First hard gate

Derive the secant-coverage condition directly in `(xi,eta)` quotient coordinates for each of the ten
layer-pair types, reduced to the seven C330 direction families where appropriate.  Identify the
actual algebraic objects governing uncovered affine orbits and prove their dimensions, degrees,
separability, and component structure before invoking Hasse--Weil or character sums.

The Blokhuis--Pellikaan--Szonyi irreducible simple-morphism double-point theorem is not importable:
C348 proved that its hypotheses fail for the selected reducible carrier.  A new componentwise or
correspondence theorem is required.

## Falsifiers and stop rules

- Replay C348's three `Q=32` fixtures with affine orbit counts `4,5,3` and total deep-hole counts
  `936,965,900`; any proposed parameter-free formula must fail on this data.
- Freeze a bounded second field only after the symbolic quotient equations exist.  No larger census
  is authorized merely to collect more counts.
- Stop a proposed invariant if two fixtures agree on it but have different exact affine counts.
- Stop the standalone-paper claim if the result remains an unevaluated sum over `Q^3` orbit
  representatives, an asymptotic estimate, or a formula depending on unrecovered presentation data.
- A bounded negative must identify the minimal missing invariant or irreducible counting bottleneck;
  it does not reopen C348 or weaken its infinity-extension theorem.

## Literature and novelty gate

Begin from the pinned C348 matrix: Blokhuis--Pellikaan--Szonyi on extended coset-leader enumerators,
Kaipa on redundancy-three RS deep holes, Wu--Ding--Chen on MDS extensions, Li--Lu--Ling--Lam on
non-GRS extension frameworks, and the 2025--2026 twisted/extended-GRS deep-hole papers.  Close
forward citations and MathSciNet/zbMATH as available before a paper-facing priority claim.

Do not claim novelty for the syndrome/projective-system dictionary, the equality between deep holes
and one-column MDS extensions, scalar-extension enumerator polynomials, or additive orbit reduction.
The defensible crown is the exact invariant-stratified affine count and the complete extension
geometry of the C329 family.

## Exit and publication value

**Pass:** an exact theorem that upgrades the combined C329/C336/C337/C348 package from a strong
construction-and-recognition paper with an extension section to a headline complete-enumerator and
decoding-geometry paper.

**Narrow:** a finite intrinsic stratification and exact formulas on a substantive infinite subfamily;
publish it inside the combined paper and state the excluded strata exactly.

**Stop:** no symbolic compression beyond the `Q^3` quotient or only field-by-field counts.  Retain
C348 as the publication endpoint and do not market C361 as a standalone contribution.

## Evidence contract

Any computation must land as an atomic report/script/canonical-output/checksum bundle with exact
commands, byte counts, hashes, checked domains, and an independent incidence or direct-syndrome
replay.  The large-field theorem must be proof-driven; finite fields are falsifiers and exceptional-
case certificates, not extrapolation evidence.
