# C458 — Weil-roof battery M0 addendum: golden-sheet-frame conventions freeze

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — GOLDEN SHEET FRAME FROZEN AS A CO-EQUAL SHEET-CARRYING OBJECT; TWO-FRAME THEOREM VERIFIED; M2 CLAIM 3 BOUND TO A FROZEN ANTECEDENT (M2 AMBER→GREEN)`

The M0 addendum of the Weil-roof verification battery
([`2026-07-21-clebsch-weil-roof-program.md`](2026-07-21-clebsch-weil-roof-program.md)), required by
M2/C442 ([`2026-07-21-c442-antipodal-singleton-reduction.md`](2026-07-21-c442-antipodal-singleton-reduction.md)).
M2 proved that M0's frozen Klein binary form is **sheet-blind**: it is the correct integral model of
the vertex *set*, but its `A5` is normalized by the full Galois group, so its reduction is
prime-independent and it cannot carry the sheet bit. This addendum promotes the sheet-*carrying*
object — the golden six-arc over `Q(phi)`, its invariant anisotropic conic, and its polar-pair
matching (already frozen de facto in C379's replay module) — to a **co-equal frozen object** under
M0's JSON discipline, states the two-frame theorem, and records the bridge between the frames.

This is a convention **extension, not a change**: nothing frozen in M0 (C440) becomes wrong, and
M1's certificate (C441) is untouched. It binds master-stroke claim 3 to a frozen antecedent, so M2
moves from AMBER to GREEN.

Independently reviewed at the two-frame-theorem Fable gate
([`2026-07-21-c458-m0-addendum-fable-review.md`](2026-07-21-c458-m0-addendum-fable-review.md)): the
mathematics of the two-frame theorem, the bridge, and the binding of claim 3 was confirmed by an
independent from-scratch computation, and the wording/witness fixes it required are folded into this
bundle. The review also surfaced a one-line prose erratum in the C440 report (the `z -> -1/z` label;
C440's JSON is unaffected), applied there.

## What is frozen (the co-equal sheet-carrying object)

**Field and conic.** The golden six-arc `S` lives in `P^2` over `Q(phi) = Q(sqrt5)`
(`phi^2 = phi + 1`, ring `Z[phi]`), with its invariant **anisotropic** conic `x^2 + y^2 + z^2 = 0`.
Over `Q(phi)` that definite conic is inequivalent to M0's isotropic standard conic `XZ - Y^2`; the
two frames agree only after reduction mod `q`. The golden `A5` already has order 60 over `Q(phi)` in
this frame (projective trace field `Q(sqrt5)`), whereas Klein's binary-form `A5` needs `Z[zeta5]`.

**The six-arc** (normalized vectors over `Q(phi)`, `tau = phi`, `tau - 1 = -1 + phi`):

```
[0, 1, -1+phi]   [0, 1, 1-phi]   [1, -1+phi, 0]   [1, 0, -phi]   [1, 0, phi]   [1, 1-phi, 0]
```

Its golden conjugate `sigma(S)` is the disjoint six-arc obtained by `phi -> 1 - phi`.

**The polar-pair matching.** Each golden axis is polar (w.r.t. the anisotropic conic) to a conjugate
point-pair on the conic; the six pairs form the **unique** `A5`-invariant perfect matching (the
antipodal matching; uniqueness is M2 clause (i), vertex-pair `A5`-orbits `6/30/30`). This one golden
matching has two prime-reductions above 11 — **the two C406 singleton depth fibres**:

| prime | `phi ->` | `sqrt5` | sheet stabilizer | matching (point labels `0..10, inf`) | C406 singleton |
|:------|:--------:|:-------:|:-----------------|:---------------------------------------------|:---------------|
| `pi`    | 8 | 4 | `a5(8)` | `{0,1}{2,5}{3,7}{4,9}{6,8}{10,inf}` | base   |
| `pibar` | 4 | 7 | `a5(4)` | `{0,10}{1,inf}{2,7}{3,5}{4,8}{6,9}` | J-mate |

the nontrivial element `sigma` of `Gal(Q(sqrt5)/Q)` exchanges the two reductions
(`reduce_pi(sigma(g)) = reduce_pibar(g)`), so the two singletons are the two prime-reductions of
**one** golden object (master-stroke claim 3, exhibited).

## The two-frame theorem

> Klein's rational binary form and the golden six-arc carry the **same** 12 icosahedral vertices, but
> only the golden frame is sheet-faithful. The rational binary form is normalized by the full Galois
> group, so its reduction is prime-independent (**sheet-blind**); the golden `A5`-embedding lives over
> `Q(phi)`, so golden conjugation `sigma` moves it and its reduction distinguishes the two primes
> above 11 (**sheet-faithful**). The sheet bit lives exactly in the golden `A5`-embedding.

**Rational binary-form frame — sheet-blind.** `f = xy(x^10 + 11 x^5 y^5 - y^10)` has integer
coefficients, hence is `sigma`-invariant; `sigma` normalizes the char-0 Klein `A5`
(`sigma(S) = S^2 in A5`, `sigma(T) in A5`), so it fixes the unique `A5`-invariant matching and the
two prime-reductions **coincide** (one matching `M0`; its `PGL_2(11)`-stabilizer is exactly the
reduced golden `A5`, order 60, `⊂ PSL`; `PGL`-orbit 22, `PSL`-orbit 11). In this frame the two
singletons are not two reductions: one is the prime-independent reduction, the other its char-11
outer image (under the frame identification conjugating the reduced Klein `A5` onto a sheet
stabilizer; under the naive label identification the binary-frame matching is neither singleton).

**Golden six-arc frame — sheet-faithful.** The char-0 golden reflection closure has order 60 and
permutes `S`; `sigma` carries `S` to the disjoint conjugate six-arc and `a5(8)` to `a5(4)`; the polar
matching reduces at `pi` to base and at `pibar` to J-mate — the two distinct singletons
(`a5(8) != a5(4)`, intersection order 12, the common `A4`).

Every witness above is recomputed in the certificate by re-executing the hash-pinned M2 (C442)
constructions over the hash-pinned frozen modules (guardrail 1: compute, never recall).

## The bridge (how the frames relate)

- **A single rational rotation implements the Galois swap.** `Rz = [[0,-1,0],[1,0,0],[0,0,1]]` (90°
  about `z`, integer entries, det 1) maps `S` onto the conjugate six-arc and conjugates `a5(8)` onto
  `a5(4)`; its spinor norm is 2. So the swap element is **not** characteristic-11 — it is the shadow
  of a rational rotation.
- **Char-11 makes the shadow outer.** `Rz` reduces mod 11 to an outer `PGL_2(11)` element (in C406's
  `J`-transporter coset) of determinant 2; the swap is outer precisely because **2 is a nonsquare
  mod 11** (`legendre(2,11) = -1`), the mod-11 image of `Rz`'s spinor norm 2.
- **What is purely char-11.** The **collision** — the disjoint char-0 golden and conjugate 12-vertex
  sets are forced onto the *same* `P^1(F_11)` at `q = h + 1 = 11` — and the **finite closure**
  `⟨a5(8), a5(4)⟩ = PSL_2(11)` (order 660): the two reduced sheets generate `PSL`, not `PGL`.
- **Why two frames must coexist (mechanism; structural/classical, not machine-verified here).** Over
  `Q(sqrt5)` the binary icosahedral `2.A5` has quaternionic Schur index 2, so `A5` has no split `P^1`
  model there — its `K`-home is the
  anisotropic conic frame — while the split `P^1` (binary form) frame lives over `Q(zeta5)`, where the
  full cyclotomic Galois group normalizes the Klein `A5` (which is exactly why that frame is
  sheet-blind). Reduction at the split prime 11 splits the quaternion algebra into `PGL_2(F_11)`; the
  char-11 gluing is the splitting of the icosahedral quaternion (Schur-index-2) obstruction at 11.

## Covariation binding (clause (iii) / T1)

With the golden matching frozen, the oriented invariant *"`mu_3` with `epsilon = +1` on the sheet
containing the reduction of the golden antipodal matching"* is independent of the choice of prime
above 11 (a corollary of C406 plus this freeze). The `mu_3` `D`-profiles covary as one bit:
`base = [-6, 0, 12, -12]`, `jmate = [6, 0, -12, 12] = -base`.

## What this settles, and what it hands forward

- **M2 (C442) AMBER → GREEN.** M2 was AMBER solely because claim 3's object had no frozen antecedent:
  in M0's frozen binary-form frame the sentence "the two singletons are the two prime-reductions of
  one antipodal matching" is false-by-coincidence. This addendum freezes the correct antecedent — the
  golden six-arc's polar matching — so claim 3 binds.
- **Downstream consume this frame by SHA.** M3/C443 (`mu_1, mu_2, mu_3` commuting-with-reduction; the
  golden-`-1` tensor with `±6 mod-pi` shadow) reduces `mu_3` against this sheet-carrying object; M4/C444
  must specify the B3/A3 analogues **against the disanalogy** (for B3 the group is sheet-blind and the
  form is silver — the bit-carrier dualizes, so the H3 template does not transfer); M5/C445 states the
  char-11 gluing, for which the bridge's collision, `PSL` closure, and quaternion mechanism are the
  candidate germs.

## Artifacts and independent replay

Run from the repository root:

```bash
uv run python3 notes/2026-07-21-c458-golden-sheet-frame-freeze.py --check      # verify tracked artifacts
uv run python3 notes/2026-07-21-c458-golden-sheet-frame-freeze-replay.py       # independent reduction
```

Intentional regeneration is `... .py` with no flag. The primary generator hash-pins and re-executes
the frozen M0/M1/M2/C379/C399/C406 constructions and asserts every load-bearing fact (the asserts
*are* the verification certificate); `--check` regenerates the JSON in memory, compares it
byte-for-byte against the tracked artifact and the sha256 manifest, and leaves the worktree
unchanged. The **independent replay** is a separate code path: it imports only the C379 replay module
and the C399 conic module (not C442, not the primary), rebuilds `a5(8)`/`a5(4)` as permutation
groups, and re-derives — with its own pair-orbit, matching, and closure implementations — that each
sheet's unique invariant matching equals both C379's reduced polar matching and C406's base/J-mate
singleton, that the two sheets are distinct order-60 groups meeting in order 12, and that they
generate exactly `PSL_2(11)` (order 660). It then compares those against the frozen JSON.

| artifact | bytes | SHA-256 |
|:---------|------:|:--------|
| primary generator/checker `.py` | 26,597 | `eaf9a6ab6a1df254925057f163fa49547f532313358b1bd3216993baca2360f3` |
| independent replay `.py`        |  7,855 | `fceb0f8ce91f090ee18877d1fbb4f66060a5f9f686e64656ef9d3b0bbb47b86b` |
| canonical certificate `.json`   | 13,379 | `9e93de4567443726896bf613971d2b7e3c7054874b4bf4810ca74a08384ff620` |

Consumed frozen inputs are hash-pinned against their own committed manifests inside the certificate:
C440 (`.py`/`.json`), C441 (`.py`), C442 (`.py`/`.json`), C379 replay (`.py`), C399 (`.py`), C406
(`.json`). A drift in any antecedent fails the build loudly.

Trusted boundary: exact arithmetic in `Q(phi)`/`Q(zeta5)` (the frozen M0/M1/M2 field code) and prime
field `F_11`; all groups, six-arcs, reflection closures, conic points, matchings, and the finite
closure are recomputed, not assumed. The reduced sheet-carrying facts have two independent
constructions (primary via the hash-pinned C442 char-0 exhibition; replay via C379/C399 alone). The
char-0 `sigma`-action (sheet-faithfulness upstairs) and the binary-form sheet-blindness are verified
in the primary via the hash-pinned C442 constructions and, independently, in C442's Fable review
([`2026-07-21-c442-m2-fable-review.md`](2026-07-21-c442-m2-fable-review.md)); they are outside the
reduced replay's boundary.

## Boundary — what C458 does NOT certify

- commuting-with-reduction of the quotient constructions `mu_1, mu_2, mu_3` and the denominator set
  `N`, and the integral `Z[phi]` lift of `mu_3` as a golden-`-1` tensor with `±6 mod-pi` shadow
  (**M3 / C443**);
- the B3 `sqrt2` and A3 inert-fusion sheet reduction theory — whose H3 template does **not** transfer
  (**M4 / C444**);
- the integral char-11 gluing statement of the two sheets into one `PGL_2(11)` orbit (**M5 / C445**);
- the `(2/p)` sheet-fidelity law's general proof and the `Q`-forms descent classification (T6
  territory; **C459**).

## Literature and claim boundary

No novelty or priority claim. The golden reduction of icosahedral structure mod split primes, the
anisotropic-conic vs binary-form dichotomy, the quaternionic Schur index of `2.A5`, and the
`PSL_2(11)` closure are classical territory (Klein, Edge, Kostant, Serre; the C377 audit boundary
applies). C458 is convention-fixing plus verification: it freezes the sheet-carrying object and
records the two-frame theorem and bridge that M2 established, so downstream tasks have a single frozen
antecedent to consume.
