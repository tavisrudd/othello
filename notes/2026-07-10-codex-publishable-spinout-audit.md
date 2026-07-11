# Projective-cap program — short publishable-spinout audit

**Date:** 2026-07-10
**Scope:** Rounds 1–7 plus the existing Lean, certificate, classical-variety, order-9-plane,
and `PG(4,3)` results. This was a publication-risk audit, not a new proof campaign. Two scouts
returned; the third was stopped immediately when the user reported low remaining quota. No new
solve or large computation was run.

## Executive verdict

There is one low-risk paper that is already mathematically ready, one promising short
finite-geometry note needing a single generalization and a stronger novelty check, and one
medium-risk formal-methods paper with a very concrete engineering gate.

| rank | package | status | remaining work | risk |
|---:|---|---|---|---|
| 1 | Pairing strategies for Nofil/cap games on finite incidence geometries | **[READY]** | exposition, release freeze, two optional Lean wrappers | low mathematical; medium editorial |
| 2 | Equivariant extension and reconstruction of small arcs | **[ONE-LEMMA]** | general Baer bound + sharpness/novelty audit | low correctness; medium novelty |
| 3 | Proof-carrying exact impartial-game solves | **[ONE-LEMMA]** | indexed orbit-aware checker at nontrivial scale | medium |
| 4 | Order-9 planes and `PG(4,3)` computational atlas | **[FOLD-IN]** | independently checkable solution DAGs | low–medium |

The best decision is **not** to create many small papers. Draft Package 1 as the flagship
mathematics/formalization paper; Package 4 becomes its computational section or companion
artifact. Fund Package 2 only after a short expert-level bibliography gate.

## 1. [READY] Pairing strategies on finite incidence geometries

### Existing theorem package

The common theorem is the Lean-proved capacity-two near-linear mirror principle:

> In a finite partial linear space, if a fixed-point-free involution preserves the line
> relation, then the second player wins the normal-play game of selecting points while placing
> at most two selected points on every line.

Near-linearity is the proof-critical hypothesis: two points determine at most one line, so a
putative mirror-chord obstruction reflects to a previously filled line. The project also proves
the sharp method boundary: this automatic chord argument fails at capacity at least three.

Existing applications include:

- `PG(n,2)` for every `n>=1`;
- `PG(2m-1,q)` for odd q;
- hyperbolic quadrics `Q^+(2m-1,q)` for odd q;
- the capacity-two rook grid, hence `PG(1,q) x PG(1,q)` for odd q;
- by the same proved engine and short conventional geometry, symplectic polar spaces
  `W(2n-1,q)` and Segre products `PG(a,q) x PG(2m-1,q)` for odd q;
- finite-plane mechanism/certificate theorems at q=5,7,11,13.

The reusable engine, the full projective and hyperbolic-quadric families, and the rook-grid base
are already Lean theorems. The general symplectic and higher Segre instantiations have complete
paper proofs and machine gates, but their final geometry-specific Lean wrappers remain optional
work; the manuscript must distinguish these tiers exactly.

### Why this is externally useful

This extends Nofil from Steiner triple systems to collinearity-triple and partial-linear-space
boards and supplies new infinite-family outcomes on projective spaces, quadrics, generalized
quadrangles, and Segre varieties. It also has a clean coding-theory interpretation: building a
plane arc is the game of appending projective parity-check columns while retaining minimum
distance at least four. The code-building dictionary is best used as an application section, not
sold as a separate theorem.

The closest ruleset paper is
[Huggan–Huntemann–Stevens, *The combinatorial game Nofil played on Steiner triple systems*](https://doi.org/10.1002/jcd.21809).
It gives the Nofil framework and small STS computations, but not these geometric families.
[Sieben, *Impartial Hypergraph Games*](https://doi.org/10.37236/11665) supplies the broader
building-avoidance taxonomy, not the outcomes. The closest substantial formal finite-geometry
result located is the cap-set formalization of
[Dahmen–Hölzl–Lewis](https://doi.org/10.4230/LIPIcs.ITP.2019.15), which is extremal rather than
game-theoretic. No Nofil outcome theorem on the listed quadric, polar, or Segre families was
located.

### Smallest submission path

1. Write conventional proofs independently of the Lean code.
2. Freeze a reproducible Lean release and state the natural-language/formal specification map.
3. Either finish the two short symplectic/Segre wrappers or mark them as paper-proved only.
4. Keep q=23 at its true tier: Lean PGL transport plus native checking of 241,627,613 proof-DAG
   records, not an unconditional Lean theorem.
5. Include the all-order-9 and `PG(4,3)` results only after the certificate caveat in Section 3.

No new mathematical conjecture or large solve is needed. A combined mathematics/formalization
submission to the *Journal of Combinatorial Designs* or *Electronic Journal of Combinatorics* is
the natural first attempt. Splitting off a thin formalization paper now would weaken both papers.

## 2. [ONE-LEMMA] Equivariant extension and reconstruction of small arcs

This is the strongest genuinely external spinout created by Rounds 6–7.

**Follow-up:** the completion-core component has since been upgraded to an
exact deletion-distance and circuit-transversal framework, with sharp
applications and a separate publication roadmap. See
[Completion-core rigidity: robustness, transversals, and new settings](2026-07-10-completion-core-rigidity-upgrades.md).

The Baer-equivariant component has likewise been upgraded from a fixed
eight-arc bound to an arbitrary-profile mixed-cover theorem, a quantitative
conjugate-pair extension theorem, and prime-degree/Galois-rank extensions.
See [Baer-equivariant arc extension: orbit completions, mixed covers, and
Galois rank](2026-07-10-baer-equivariant-extension-upgrades.md).

The continuation-graph component now has an exact partial-linear-space
support theorem, intrinsic tangent-trace and centre recovery at explicit
large-order thresholds, low-cardinality obstruction families, and two
precise standalone-paper gates. See [Continuation-graph rigidity: embedded
recovery, intrinsic traces, and semilinear
extension](2026-07-10-continuation-graph-rigidity-upgrades.md).

### Theorem A — continuation-graph rigidity

Let `K` be a k-arc in a projective plane of order q. Let `V_K` be the points extending `K` to a
`(k+1)`-arc, and put

```text
x ~_K y  iff  the line xy contains a point of K.
```

If

```text
q-C(k-1,2) >= 2,             q+2-k > k,
```

then every ambient collineation carrying `(V_K,~_K)` to `(V_L,~_L)` carries `K` to `L`.
In particular, the ambient-collineation automorphism group of the continuation graph is exactly
the setwise collineation stabilizer of `K`.

**Proof already available.** Every tangent through `t in K` has at least
`q-C(k-1,2)` legal points, hence contains an edge of the continuation graph. Its image is a line
through `h(t)` containing a point of `L`. There are `q+2-k>k` such distinct lines, impossible if
`h(t)` lies outside the k-set `L`. For k=8, the first inequality is exactly q>=23.

### Theorem B — completion-core rigidity

The Round-3 anti-Frattini theorem is a companion statement. If

```text
q > C(k-1,2)+1,
```

then the intersection of all complete arcs containing a nonempty k-arc `K` is exactly `K`.
This holds in arbitrary finite projective planes, not only Desarguesian ones.

### Theorem C — Baer-equivariant extension

Round 7 proves: if s is odd and s>=23, every Baer-involution-invariant 8-arc in
`PG(2,s^2)` has a Baer-fixed point extending it to a 9-arc. The q=25 construction

```text
C(F_5) union {(2:w:1),(2:-w:1)},   w^2=2,
```

shows that small orders genuinely behave differently: its secants cover the full fixed Baer
subplane.

### Why this could be a short paper

The results concern arc embeddability, recovery of automorphism groups from extension geometry,
complete arcs/saturating sets, and extendability of the corresponding projective linear codes.
The closest sources located discuss arc extension and classification generally—see the
[Ball–Lavrauw survey](https://arxiv.org/abs/1908.10772)—and Baer-invariant configurations, but no
matching continuation-graph reconstruction or fixed-Baer-point extension theorem was found.

The missing lemma is precise: generalize the Round-7 fixed-secant union calculation from 8-arcs
to k-arcs, obtaining a bound `B_{k,f}(s)` in terms of the number f of fixed selected points, and
derive a lower bound for a Baer-invariant complete arc. Add one sharpness or equality analysis.
Then perform a MathSciNet/monograph-level novelty check. This is a plausible 6–10 page finite-
geometry note, but it is **not yet [READY]** because the existing proofs are short enough that
prior-art risk matters more than correctness risk.

## 3. [ONE-LEMMA] Proof-carrying exact impartial-game solves

The project already has two sound certificate contracts:

- P/N reply DAGs: P rows cover every legal child by N; N rows contain a P witness;
- mex books: every legal child is represented, values below g have witnesses, and no child has
  value g.

The native P/N format scales to q=23. The generic Lean mex checker is proved sound, but literal
list lookup stalls at tiny scale. Proof DAGs and AND/OR solution trees themselves are standard;
the claimable methods result would be the following reusable theorem and artifact:

> If every canonical DAG edge carries a rule-checked move and symmetry transport witness, and
> every local P/N or mex equation checks, then the declared root equals the recursive impartial-
> game value.

The success gate is an indexed or streaming Lean checker handling at least q=13 and one genuinely
large symmetry-reduced certificate without trusting solver recursion. Anything smaller is a good
project artifact but not a paper. Closest neighboring work includes certified finite-state
exploration and proof-DAG checking; therefore novelty must be the orbit-aware impartial-game
checker, not the existence of proof DAGs. A successful artifact fits an ITP/CPP short paper.

Risk is medium and mostly engineering. Do this only after Package 1 is drafted.

## 4. [FOLD-IN] Order-9 planes and `PG(4,3)`

Existing exact results are likely new game data:

- all four projective planes of order 9—Desarguesian, Hall, dual Hall, Hughes—are P;
- `PG(4,3)` is P.

The plane classification and cap classifications are prior art; the novelty is the game outcome
and the evidence that order-9 P-ness is not Desargues-specific. The root outcome does not
distinguish Hall from dual Hall, so “game invariant of planes” is not yet a standalone story.

Export independently checkable solution DAGs. For `PG(4,3)`, each quotient edge should include an
explicit projectivity carrying the actual child to its canonical representative. Then use these
as the computational section of Package 1. A standalone computational atlas would need a larger
family or a stronger invariant and is not currently the low-risk choice.

## 5. Results to reuse but not publish separately

### [KNOWN] Fifteen bielliptic completions

The Round-1 formula

```text
x=(ab-cd)/(a+b-c-d)
```

is useful, and the finite-field strengthening is clean: for every distinguished point of a
five-set over an odd field, at least two pairings give rational fixed-point-free completions.
However, [Lian, Theorem 1.3](https://arxiv.org/abs/1907.08991) already proves that five very
general branch points have exactly fifteen bielliptic sixth points and describes the same
partition/involution construction. The arbitrary-finite-field degeneration lemma belongs as a
proposition or application, not a paper. Collision divisors meet the heavily studied extra-
automorphism strata of binary sextics and are not a low-risk follow-up.

### [KNOWN / FOLD]

- `R_(T union A)=R_T/A` is ordinary hypergraph/link contraction.
- Quotient reconstruction by an `F_2` voltage class is classical gain/cover theory; the pointed
  phase formulation is useful but too small without an infinite SG-separation theorem.
- The polarity, conic-torus, affine-Schreier, and `P^1 x P^1` perspectivity formulas are valuable
  coordinate lemmas, not standalone results.
- The six-vertex signed-lift SG 0/1 pair is an excellent warning against unsigned quotients, but
  one example is not a paper.
- The two-intruder Dawson-path/even-cycle theorem belongs inside the main game paper; the static
  spectrum is substantially owned by existing conical-subset classifications.
- Dataset-specific augmentation traps, selector failures, and autonomy collisions are research
  methodology, not publication units.

## 6. Recommended allocation

1. **Draft Package 1 now.** One writing/proof agent plus one Lean/reproducibility auditor. No
   search computation. Success is a complete manuscript skeleton and theorem-status table.
2. **Run a two-hour expert bibliography gate on Package 2.** If no reconstruction/Baer-extension
   overlap appears, assign one finite-geometer to the general `B_{k,f}(s)` theorem and sharpness
   examples. Stop if the generalization is merely a standard covering bound.
3. **Defer Package 3** until the flagship draft exposes exactly which computational claims need
   kernel-level certificates.

This ordering extracts publishable value without depending on the odd-plane conjecture and
without launching another fixed-q census.
