# C362: publication extraction from the C348 deep-hole theorem

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `PUBLICATION-READY SECTION; STANDARD ENUMERATOR REDUCTION; NOVELTY IN INFINITY COMPLEX`

## Signed decision

C348 has clear publication value as a theorem section in the combined C329/C330/C336/C337 paper,
but a post-extraction matroid audit corrects its attribution boundary.  The scalar-extension formula
is a rank-three specialization of Jurrius--Pellikaan's derived-arrangement theorem, not a new general
enumerator reduction.  The defensible architecture-specific synthesis is:

> In the four-layer non-GRS MDS family, the standard derived-arrangement enumerator specializes to
> one recoverable base-field deep-hole invariant; that invariant decomposes into an additive-orbit
> term and an explicit infinity term, and the complete infinity locus supports a classified
> rank-two complex of one- and two-column non-GRS MDS extensions.

This is strong enough for a substantial final paper section without an evaluated affine quotient.
C361 does not supply that evaluation, but C364 gives the complementary positive upgrade: after
C337 recovery, the ten C361 correspondences form an intrinsic complete coset-leader decoder for
every individual syndrome through four trace gates and six bounded-degree root problems.

## Paper-ready setup

Let `F=GF(Q)`, where `Q=2^r`, `r` is odd, and `Q>=2^45`, and let `E=GF(Q^2)`.  Let
`A subset PG(2,E)` be a three-distinct-carrier C329 arc on the repair-conic coincidence stratum,
with `n=|A|=4Q`.  Its columns are a parity-check matrix for the non-GRS MDS code

```text
C_A : [n,n-3,4]_E.
```

The non-GRS assertion is intrinsic by C337: the projective system meets three distinct conics in
the common-point/common-tangent pencil, and its dimension-three dual has Schur-square dimension
six rather than the GRS value five.

Put `q=|E|=Q^2`, `B=binom(n,2)`, and define

```text
h(A)=|{P in PG(2,E) : P lies on no A-secant}|.
```

For a scalar extension `K/E` of degree `m`, put `T=|K|=q^m`.  Let `alpha_i(T)` be the number of
cosets of the scalar-extended code whose minimum Hamming weight is `i`, and for `i>0` put
`a_i(T)=alpha_i(T)/(T-1)`.

## Proposition A: derived-arrangement specialization

This proposition is the rank-three arc specialization of Jurrius--Pellikaan's general
[derived-arrangement formula](https://doi.org/10.1090/conm/632/12631), especially Theorem 5.3 and
Examples 5.10--5.11.  It is included with a self-contained proof as an interface to the
family-specific geometry below, not claimed as new enumerator theory.

For every `m>=1`, the complete coset-leader weight enumerator is

```text
alpha_0(T) = 1,
a_1(T)     = n,
a_2(T)     = B(T-q) + q^2+q+1-n-h(A),
a_3(T)     = T^2+(1-B)T+Bq-q^2-q+h(A),
alpha_i(T) = (T-1)a_i(T),                         i=1,2,3.
```

There are no cosets of minimum weight greater than three.  In particular, at the base field,

```text
alpha_1(q)=(q-1)n,
alpha_2(q)=(q-1)(q^2+q+1-n-h(A)),
alpha_3(q)=(q-1)h(A).
```

### Proof

Let `S_A` be the central arrangement in `E^3` of the `B` planes spanned by pairs of columns of the
parity-check matrix.  Projectively, these are the secant lines of `A`; because `A` is an arc, they
are distinct and the arrangement is essential.  A syndrome has leader weight three exactly when
it avoids every member of `S_A`.  The finite-field characteristic-polynomial identity, equivalently
Jurrius--Pellikaan's Theorem 5.3 for the derived code, therefore gives

```text
alpha_3(T)=chi_{S_A}(T).
```

A central rank-three arrangement with `B` hyperplanes has

```text
chi_{S_A}(T)=(T-1)(T^2+(1-B)T+C).
```

At the base field its projective complement has `h(A)` points, so
`chi_{S_A}(q)=(q-1)h(A)` and hence `C=Bq-q^2-q+h(A)`.  This gives `a_3(T)`.
The columns give `a_1(T)=n`; subtracting `a_1(T)` and `a_3(T)` from
`|PG(2,K)|=T^2+T+1` gives `a_2(T)`.  Any three columns form a basis, so no larger leader weight
occurs.  Multiplication by `T-1` restores nonzero scalar syndromes.  `square`

## Proposition B: intrinsic additive quotient and moduli boundary

In C337's recovered normal form, the group

```text
T_mu[X:Y:Z]=[X:Y+mu X:Z+mu^2 X],       mu in F,
```

preserves `A`, fixes the line at infinity pointwise, and acts freely on affine points.  Therefore

```text
h(A)=Q M(A)+u(A),
```

where `M(A)` is the number of affine deep-hole `F^+`-orbits and `u(A)` is the number of infinity
deep holes.  For an affine point `[1:u:v]`, the pair

```text
(xi,eta)=(u^Q+u, v+u^2) in F x E
```

is invariant under `T_mu` and separates its affine orbits.  Thus the unknown affine classification
is an intrinsic `Q^3` quotient problem rather than a `Q^4` point census.

The C348 fixtures show that this residual invariant cannot be suppressed in the normalized
four-layer architecture.  At `Q=32`, three arcs with different recovered parameters have
respectively

```text
h(A)=936, 965, 900,
```

with affine contributions `128,160,96`.  These fixtures prove architectural moduli dependence and
disprove a `Q`-only formula on that normalized parameter space.  They lie below C329's sufficient
large-field existence threshold, so they do not prove that C329's Chebotarev-selected large-field
tail realizes three different enumerators.

## Theorem C: exact rank-two infinity extension complex

Let `D(A) subset E` be C330's exact union of the seven finite-direction images, and put

```text
U(A)={[0:1:t] : t in E\D(A)},
u(A)=|U(A)|=Q^2-|D(A)| >= Q^2-7Q+2.
```

Then the extension complex induced on `U(A)` is exactly

```text
X_infinity(A)={S subset U(A) : |S|<=2}.
```

Equivalently:

1. for each `s in U(A)`, `A union {s}` is an arc and gives a non-GRS
   `[4Q+1,4Q-2,4]_E` MDS code;
2. for each pair of distinct `s,t in U(A)`, `A union {s,t}` is an arc and gives a non-GRS
   `[4Q+2,4Q-1,4]_E` MDS code; and
3. no three points of `U(A)` extend `A` to an arc.

Consequently the construction supplies exactly `u(A)` labelled one-column extensions and
`binom(u(A),2)` labelled two-column extensions supported at infinity.  These counts are not claims
about monomial-equivalence classes.

### Proof

By the definition of `U(A)`, each of its points lies on no secant of `A`, so adjoining one preserves
the arc property.  For distinct `s,t in U(A)`, their joining line is the line at infinity, which
contains no point of the affine set `A`; hence adjoining both also preserves the arc property.
Every three members of `U(A)` are collinear, so no triple is admissible.  If either extended code
were GRS or extended GRS, shortening at the new coordinate or coordinates would make `C_A` GRS or
extended GRS, contrary to C337.  `square`

## Corollary D: the obstruction becomes an extension resource

C330 proves that the C329 arc is not complete relative to the prescribed infinity carrier.  In the
coding interpretation this is a positive result: every C329 code has at least

```text
Q^2-7Q+2
```

explicit one-column non-GRS MDS extensions and at least

```text
binom(Q^2-7Q+2,2)
```

explicit labelled two-column non-GRS MDS extensions supported on the same carrier.  The second
bound is simultaneous rather than a count obtained by independently reusing single extensions.

## Submission-ready positioning paragraph

The derived-arrangement formula for extended coset-leader enumerators is known; specializing it to
a rank-three arc expresses all scalar-extension coefficients through the base complement count
`h(A)`.  The general deep-hole/MDS-extension dictionary and preservation of non-GRS status under
shortening are known as well.  Our contribution is the family-specific geometry: for this explicit
additive four-layer non-GRS family, `h(A)` splits into a recoverable `F^+`-orbit term and an exact
infinity term; seven rational direction maps determine the entire infinity locus; and its
simultaneous extension complex is the full rank-two complex and no larger.  The residual affine
count varies across the normalized parameter space, so the result records rather than hides the
family's moduli.  This source-level comparison does not assert exhaustive MathSciNet or zbMATH
priority closure.

The first sentence must cite Jurrius--Pellikaan, Theorem 5.3 and Examples 5.10--5.11; their derived
secant arrangement, not the original uniform column matroid `U_{3,n}`, controls the coset-leader
enumerator.  The next sentence delimits the overlap with Wu--Ding--Chen's general extension criterion
and Li--Lu--Ling--Lam's shortening framework.  Blokhuis--Pellikaan--Szonyi's twisted-cubic result is
the closest explicit enumerator model, but its irreducible simple-morphism double-point argument
does not apply to the selected reducible three-conic carrier.  Kaipa and the recent
twisted/extended-GRS deep-hole papers belong in related work, not in the novelty sentence.

## Recommended paper integration

| paper location | imported result | editorial role |
|---|---|---|
| construction theorem | C329 | establishes fresh `4Q` arcs on the odd tower `Q>=2^45` |
| evaluation-code section | C336 | gives the exact five-code tower, locality, and extremal curves |
| intrinsic recognition section | C337 | recovers the layers and `[rho;{a,b}]`, and certifies non-GRS status |
| complete-decoding section | C364 | turns the recovered geometry into an every-syndrome minimum-weight leader algorithm |
| transition to extensions | C330 | reframes the infinity-direction obstruction as an explicit deep-hole carrier |
| final main-results section | C362 Proposition A and Theorem C | cites the standard enumerator specialization and states the new simultaneous extension complex |
| computational/limitations appendix | C348 certificate | proves architectural moduli dependence and records the large-field boundary |

Suggested section title:

> **Deep-hole moduli and simultaneous non-GRS MDS extensions**

Suggested abstract sentence:

> The resulting non-GRS MDS codes admit a completely classified quadratic-size family of
> simultaneous one- and two-column extensions, while their scalar-extension coset-leader
> enumerators reduce to a single intrinsic deep-hole invariant that exhibits genuine moduli
> dependence.

The abstract must not say that the full enumerator is explicitly evaluated.  The introduction
should call Theorem C an exact extension-complex theorem, not a count of inequivalent codes.

## C361/C364 upgrade disposition

C361 leaves the symbol `M(A)` unevaluated, so nothing in Proposition A or Theorem C changes and the
present section remains the sharp boundary of explicit counting.  C364 is nevertheless a separate
paper-facing theorem: insert it after C337 and before this section.  It decides the weight of every
individual syndrome and reconstructs a leader without summing the joint Frobenius distribution.
Thus complete decoding and closed enumeration are correctly separated rather than treating either
one as a surrogate for the other.

## Evidence inheritance and trusted boundary

No new computational claim is introduced here.  The finite moduli statement is inherited from the
tracked C348 bundle:

```text
python3 notes/2026-07-18-c348-c329-coset-leader-enumerator.py --check
```

The script is 12,374 bytes with SHA-256
`ac4a01a6e3b68682fc917771ee3f773c3634d2112dea211ae7f358b4f31d7863`; the canonical JSON is
4,749 bytes with SHA-256
`ecc8881e02de212ed89479f8b0fa564f6db652d74a10ff65a3bf206f6a5d3eee`.  Its independent incidence
moments and C330 direction-image reconstruction are the computational cross-checks.  C329's
existence theorem, C330's exact direction locus, C336's code tower, and C337's intrinsic recovery
and non-GRS certificate remain separate proved inputs; this extraction changes none of them.

## Publication verdict

This is a strong paper section and a credible coding-theoretic payoff for the combined construction.
It is probably too narrow for a high-impact standalone paper without C361 or another theorem that
classifies the affine quotient.  Proposition A is standard derived-arrangement machinery.  The safe
novelty claim is the explicit additive/infinity decomposition and exact rank-two simultaneous
infinity extension complex for this recoverable four-layer non-GRS family.  Search absence is not
used as proof of global priority.

## Vibe check

Good extraction.  C330's apparent completeness failure becomes a quadratic-size constructive
asset, C337 makes the remaining enumerator parameter intrinsic, and C348 supplies a clean theorem
section now rather than a speculative promise contingent on C361.
