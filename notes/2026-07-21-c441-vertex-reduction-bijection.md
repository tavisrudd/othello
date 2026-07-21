# C441 — Weil-roof battery M1: vertex-reduction bijection onto `P^1(F_q)`

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — VERTEX SET REDUCES BIJECTIVELY ONTO P^1(F_q) AT EVERY PRIME ABOVE q FOR H3/B3/A3; A5-EQUIVARIANT AT q=11; TWIST FALSIFIER NOT TRIGGERED`

M1 of the Weil-roof verification battery
([`2026-07-21-clebsch-weil-roof-program.md`](2026-07-21-clebsch-weil-roof-program.md)), the
critical path. It certifies claim 1 — "the load-bearing miracle" — of the integral golden model
([`2026-07-21-clebsch-master-stroke-integral-golden-model.md`](2026-07-21-clebsch-master-stroke-integral-golden-model.md)):
the polytope vertex set reduces **bijectively onto the full conic phase** `P^1(F_q)` at the Coxeter
prime `q = h+1`. It consumes the frozen M0 conventions
([`2026-07-21-c440-conventions-freeze.md`](2026-07-21-c440-conventions-freeze.md)) verbatim and
introduces no conventions of its own (program guardrail 2).

## What is certified

For each rank-3 Coxeter polytope, the reduction of its `h+2 = q+1` char-0 vertices onto `P^1(F_q)`
is a **bijection** at every prime above `q`:

| case | polytope | `h` | `q` | vertices | primes above `q` | bijection |
|:-----|:---------|:---:|:---:|:--------:|:-----------------|:----------|
| H3   | icosahedron | 10 | 11 | 12 | `11 = π π̄` in `Z[φ]` (split) | onto `P^1(F_11)` at **both** π, π̄ |
| B3   | cube        | 6  | 7  | 8  | `7 = (3−√2)(3+√2)` in `Z[√2]` (split) | onto `P^1(F_7)` at **both** primes |
| A3   | octahedron  | 4  | 5  | 6  | `5` (fused: inert in the spin ring `Z[√2]`) | onto `P^1(F_5)` (one vertex sheet) |

The explicit per-root bijection tables (12 / 8 / 6 rows, both prime columns) are in the certificate
JSON. The load-bearing rows for H3 at prime π (`τ=8`, `√5=4`):
poles `v0→0`, `v∞→∞`; α-pentagon (roots with `x^5 = α`) `→ {2,6,7,8,10}` (the non-residues);
β-pentagon `→ {1,3,4,5,9}` (the residues). At π̄ (`τ=4`, `√5=7`) the two pentagons **swap** targets.

## Two independent bijection certificates (compute, never recall)

- **Equivariant certificate (q=11).** The 12 icosahedral roots of Klein's `f` lie in `Q(ζ5)` (M0
  computes them as the `A5`-orbit of `[0:1]` with exact `Q(ζ5)` arithmetic), so reduction at a
  degree-1 prime above 11 is realized by the ring map `ζ5 → 3` (π) resp. `ζ5 → 9` (π̄) and sends
  each root **directly** to a point of `P^1(F_11)` — no fifth-root / splitting-field ambiguity. The
  golden `A5` reduces to a subgroup of `PGL_2(F_11)` of the same order **60** (good reduction; 11 ∤
  |A5|), and `reduce(g·r) = reduce(g)·reduce(r)` is checked element-by-element on the generators for
  all 12 roots. An `A5`-equivariant self-map of the transitive `A5`-set `A5/C5` is a bijection, so
  the 12 roots hit 12 **distinct** points — exactly surjectivity onto `P^1(F_11)`.
- **Separability certificate (all cases).** The reduced binary form is separable of full degree
  `q+1` with root set all of `P^1(F_q)` — `f mod 11 = xy(x^10−y^10)`, `W mod 7 = 4xy(x^6−y^6)`,
  `t mod 5 = xy(x^4−y^4)`, each factoring into `q+1` distinct linear factors. The char-0 form is
  also separable of degree `q+1`, so `q` does not divide its discriminant and reduction is a
  bijection of the two 0-dimensional root schemes.

The two certificates are mutually independent (one group-equivariant, one a
discriminant/separability statement on the forms).

## The `h+2 = q+1` identity (the reason it is a bijection at all)

`|P^1(F_q)| = q+1 = h+2 = #vertices` holds exactly when `q = h+1` (octahedron 6 at q=5, cube 8 at
q=7, icosahedron 12 at q=11). It is this Coxeter-number coincidence — the numerical spine of the
whole program — that makes the reduction a bijection (equal finite cardinalities) rather than merely
an injection. Recorded per case in the certificate.

## The block → coset swap = the golden/silver sheet swap

Each vertex form's finite roots split into two blocks whose product of "radii" is `−1` (α·β = `−1`
for H3; the two cube triangles `x^3 = √2/4, −2√2` with product `−1`). Each block reduces onto one
Legendre coset (H3) / cube-power coset (B3) of `F_q^*`, and the two blocks **swap cosets between the
two primes above `q`**. This is C377/C379's golden sheet swap `σ = Gal(Q(√5)/Q)` realized directly
as reduction at the two primes — the silver `√2` analogue holds for B3. The block labels are
prime-independent char-0 data; only their reduced targets swap. (Within one sheet there is a residual
`C2 = N(C5)/C5` from the two `Z[ζ5]`-primes above each `Z[φ]`-prime, `ζ5 → ζ5^{-1}`; it relabels
roots but fixes the point set and the block→coset map. `ζ5 → 3, 9` are M0's frozen representatives.)

## Twist-search falsifier — does not trigger

The "quadratic twist of the embedding" is the choice of spin square root = choice of prime above
`q` (the sheet). The **only** spin-dependent coefficient of each vertex form is its **middle**
coefficient — `11` (H3), `7√2` (B3), `0` (A3) — and each is `≡ 0 mod q`. Hence the reduced vertex
form is **independent of the twist**, every twist yields the same bijection, and no twist is needed
to repair anything. The search is run over both sheets in each split case and recorded: `repairing
twist needed: false`. Master-stroke claim 1 holds in the frozen normalization, untwisted.

## Artifacts

- Generator/checker:
  [`2026-07-21-c441-vertex-reduction-bijection.py`](2026-07-21-c441-vertex-reduction-bijection.py)
- Canonical certificate:
  [`2026-07-21-c441-vertex-reduction-bijection.json`](2026-07-21-c441-vertex-reduction-bijection.json)
- Hash manifest:
  [`2026-07-21-c441-vertex-reduction-bijection.sha256`](2026-07-21-c441-vertex-reduction-bijection.sha256)

**Replay** (from the repository root):

```
uv run python3 notes/2026-07-21-c441-vertex-reduction-bijection.py --check
```

`--check` regenerates the JSON in memory, compares it byte-for-byte against the tracked artifact and
the sha256 manifest, and leaves the worktree unchanged. The script imports the M0 machinery and
hash-verifies both the M0 JSON and the M0 script against M0's committed manifest before use (frozen
inputs referenced by SHA). No inputs beyond the two scripts; deterministic, no timestamps. Trusted
boundary: exact arithmetic in `Q(ζ5)`, `Q(i)`, `Q(√2,ω)` (M0's field code) and the prime fields
`F_11, F_7, F_5`. The two bijection certificates (equivariant, separability) are the independent
cross-check.

## Boundary — what M1 does NOT certify

- uniqueness of the antipodal `A5`-invariant matching, and the identification of the two C406
  singleton depth fibres with the two prime-reductions (**M2**);
- commuting-with-reduction of the quotient constructions `μ1, μ2, μ3` and the denominator set `N`
  (**M3**);
- the B3 `√2` and A3 inert-fusion **sheet** reduction theory in full (**M4**);
- the characteristic-11 gluing of the two sheets into one `PGL_2(11)` orbit (**M5**).

No novelty or priority claim is made. The bijective reduction of icosahedral/octahedral vertices
onto `P^1(F_q)` at `q = h+1` is classical territory (Klein, Edge, Kostant; dossier register row 33);
M1 is verification, not a research result. The candidate-new content of the integral golden model
remains the identification of the factorization-memory spine with the reduction data — untouched by
M1 and pursued in M2–M5.
