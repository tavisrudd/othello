# C440 — Weil-roof battery M0: shared conventions freeze

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — INTEGRAL GOLDEN VERTEX MODEL FROZEN AND VERIFIED; NO FALSIFIER TRIGGERED`

M0 of the Weil-roof verification battery
([`2026-07-21-clebsch-weil-roof-program.md`](2026-07-21-clebsch-weil-roof-program.md)). It fixes,
once, the dictionary every downstream M-/T-task consumes, and verifies every named object by direct
computation (guardrail 1 — no recalled formula is trusted). The falsifier ("no integral form
compatible with C377 exists") did **not** trigger: a compatible integral golden vertex model exists
and is exhibited.

## What is frozen

**Ring.** `Z[phi]`, `phi^2 = phi + 1`; golden conjugation `sigma(phi) = 1 - phi` is the nontrivial
element of `Gal(Q(sqrt5)/Q)`; `sqrt5 = 2 phi - 1`. Silver ring `Z[sqrt2]` for B3/A3.

**Conic and P^1 dictionary.** The C406 Gate-1 standard conic is `Q = X Z - Y^2`; the `P^1 -> conic`
projectivity is the discriminant Veronese `[s:t] |-> [s^2 : s t : t^2]`. Its `F_q` points are the
`q+1` conic points. Recorded subtlety: the C341/C377 six-arc frame carries the *anisotropic*
invariant conic `X^2+Y^2+Z^2 = 0` (its A5 is order 60 already over `Q(phi)`), which over `Q(phi)`
is inequivalent to the isotropic `X Z - Y^2` (definite vs isotropic). The two frames agree only
after reduction mod `q`; the standard `X Z - Y^2` is the finite-field normalization. The integral
golden model is therefore the **binary-form frame** — Klein's `f` a binary form, the conic its
discriminant.

**The three integral vertex forms** (`q = h+1`, vertex count `h+2 = q+1`):

| case | polytope | `h` | `q` | vertices | vertex form | field | group | spin field | at `q` |
|:-----|:---------|:---:|:---:|:--------:|:------------|:------|:------|:-----------|:-------|
| H3   | icosahedron | 10 | 11 | 12 | `f = xy(x^10 + 11 x^5 y^5 - y^10)` | `Z` | `A5` (60) | `Q(sqrt5)` | split |
| B3   | cube        | 6  | 7  | 8  | `W = xy(4 x^6 + 7 sqrt2 x^3 y^3 - 4 y^6)` | `Z[sqrt2]` | `O=S4` (24) | `Q(sqrt2)` | split |
| A3   | octahedron  | 4  | 5  | 6  | `t = xy(x^4 - y^4)` | `Z` | `O=S4` (24) | `Q(sqrt2)` | inert (fused) |

Uniform reduction principle: each form is `xy * g` with `g` reducing mod `q` to `x^{q-1} - y^{q-1}`,
so the root set reduces to `{0, inf} u F_q^* = P^1(F_q)`. The middle coefficient is `11` (H3),
`7 sqrt2` (B3), and `0` (A3) — all `= 0 mod q`.

## What was verified computationally (exact, element-by-element)

- **H3 / Klein's `f`.** Explicit golden generators `S = diag(zeta5, zeta5^{-1})` (order 5, in
  `SL2(Z[zeta5])`) and Klein's `T` (order 2; inverts only the spin prime `sqrt5`, never 11) generate
  a `PGL_2` group of order exactly **60** (`A5`). `f` is invariant (up to scalar) under **all 60**
  elements. Its **12** roots form a single `A5`-orbit (`= orbit of [0:1]`), all lying on `f = 0`. The
  antipodal involution `z -> -1/z` fixes `f` and pairs the 12 roots into exactly **6** pairs.
  Every projective trace invariant `tr^2/det` lies in `Q(sqrt5) = Q(phi)` — the group is golden.

  > **Erratum (2026-07-21, from the C458 / M2 Fable review).** The `z -> -1/z` pairing above is *not*
  > the `A5`-invariant "antipodal matching" that M2/C458 use downstream: the unique `A5`-invariant
  > matching of the reduced Klein `A5` (identical at both primes) is `{0,inf}{1,6}{2,4}{3,7}{5,8}{9,10}`
  > (the same-phase pairing), whereas `z -> -1/z` reduces to a different, non-invariant matching. No
  > Möbius involution can induce the invariant matching. The `alpha*beta = -1` coefficient identity is
  > unaffected, and the C440 JSON records only the pair count and that identity, so nothing frozen
  > changes — this corrects the parenthetical label only.
- **B3 / cube and A3 / octahedron.** Building the group as the full set of projectivities permuting
  the vertex root set gives order exactly **24** in each case; each recorded form vanishes on all
  vertices and is invariant (up to scalar) under all 24 elements. (The cube form's roots are `{0,
  inf}` plus two triangles at stereographic radii `1/sqrt2` and `sqrt2`; the octahedron's are
  `{0, inf, +-1, +-i}`.)
- **Reductions.** `f mod 11 = xy(x^10 - y^10)`, `W mod 7 = 4 xy(x^6 - y^6)` (with `sqrt2 = 3`),
  `t mod 5 = xy(x^4 - y^4)`; each root set is verified to equal all of `P^1(F_q)`.
- **C377 compatibility.** With `zeta5 -> 3` mod 11, `phi -> 8` and `sqrt5 -> 4` — exactly C377/C379's
  `tau=8` sheet; the golden-conjugate reduction gives `phi -> 4`, `sqrt5 -> 7` (`tau=4`). The two
  fifth-power pentagons `{x^5 = alpha}` and `{x^5 = beta}` (`alpha = 10`, `beta = 1` at `tau=8`) are
  swapped by `sigma` — i.e. `sigma` (`= C377's J` at the Galois level) is the sheet swap.

## Free hardenings folded in (still M0-scope: they strengthen the freeze, not M1+ deliverables)

- **Group reduction, not just field reduction.** The golden `A5` *itself* — `S, T` reduced with
  `zeta5 -> 3` — is a subgroup of `PGL_2(F_11)` of order exactly **60** (good reduction: `11` does
  not divide `|A5|`). So C377-compatibility holds at the level of the whole group action, not merely
  `phi -> 8`, `sqrt5 -> 4`. (Matching it to C379's *specific* `tau=8` `A5` up to `PGL_2(11)`
  conjugacy is left to M1/M4.)
- **The projective trace field is *exactly* `Q(sqrt5)`.** `S` witnesses `tr^2/det = 2 - phi` (not
  rational). H3 is the only case whose *projective* (`PGL_2`) trace field is already the spin field;
  for B3/A3 the projective trace field is `Q`, and `Q(sqrt2)` appears only in the `SL_2` spin cover
  `2.S4` — a clean statement of why H3 is the sharpest of the three.
- **Sheet-independence of the vertex reduction (de-risks M1).** Because `f` has integer coefficients,
  the vertex-to-conic reduction is identical for both `sqrt5` choices; the sheet bit lives entirely
  in the `A5` embedding, never in the vertex/root set. M1's bijection therefore need not track sheets.
- **The antipodal pairing is in `f`'s coefficients.** `alpha*beta = (121-125)/4 = -1`, so the two
  pentagon radii are reciprocal-up-to-sign — the antipodal matching is forced by the form itself.

## Frozen per-prime labeling (deliverable iii)

Poles `v0 -> 0`, `vinf -> inf` at every prime. At `q = 11`, frozen `sqrt5 = 4` (`= tau=8`):
`alpha`-pentagon `-> {2,6,7,8,10}`, `beta`-pentagon `-> {1,3,4,5,9}`; the golden-conjugate sheet
(`sqrt5 = 7`) swaps these targets. The full per-root bijection table is M1's deliverable, not M0's.

## Artifacts

- Generator/checker: [`2026-07-21-c440-conventions-freeze.py`](2026-07-21-c440-conventions-freeze.py)
- Canonical certificate: [`2026-07-21-c440-conventions-freeze.json`](2026-07-21-c440-conventions-freeze.json)
- Hash manifest: [`2026-07-21-c440-conventions-freeze.sha256`](2026-07-21-c440-conventions-freeze.sha256)

**Replay** (from the repository root):

```
uv run python3 notes/2026-07-21-c440-conventions-freeze.py --check
```

The script's assertions *are* the verification certificate; `--check` regenerates the JSON in
memory, compares it byte-for-byte against the tracked artifact and the sha256 manifest, and leaves
the worktree unchanged. No inputs beyond the script; deterministic, no timestamps. Trusted boundary:
exact rational arithmetic in `Q(zeta5)`, `Q(i)`, `Q(sqrt2, omega)`, and prime fields `F_q`; the
polytope groups are the full sets of projectivities permuting the vertex root sets, so
form-invariance is exhibited, not assumed. No independent reimplementation exists yet; the internal
cross-checks (group order via closure, root orbit via BFS, invariance via substitution, reduction
via direct root enumeration) are mutually independent.

## Boundary — what M0 does NOT certify

- the bijectivity of the vertex-to-conic reduction and the explicit per-root table (**M1**);
- uniqueness of the antipodal `A5`-invariant matching (**M2**);
- commuting-with-reduction of the quotient constructions `mu1, mu2, mu3` and the denominator set `N`
  (**M3**);
- the B3 `sqrt2` and A3 inert-fusion reduction theory in full (**M4**);
- the characteristic-11 gluing of the two sheets into one `PGL_2(11)` orbit (**M5**).

No novelty or priority claim is made here (golden reduction of icosahedral structure is classical
territory — Klein, Kostant, Serre; the C377 audit boundary applies). M0 is convention-fixing plus
verification, not a research result.
