# C442 — Weil-roof battery M2: antipodal-matching uniqueness and singleton identification

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `AMBER — CLAIM 3 CONFIRMED AND EXHIBITED IN THE GOLDEN FRAME; M0 FREEZE IS SHEET-BLIND BY THEOREM; M0 ADDENDUM (C458) REQUIRED TO BIND`

M2 of the Weil-roof verification battery
([`2026-07-21-clebsch-weil-roof-program.md`](2026-07-21-clebsch-weil-roof-program.md)), absorbing
T1. It certifies master-stroke claim 2 (antipodal uniqueness) and adjudicates claim 3 (the two
singleton depth fibres as the two prime-reductions of one antipodal matching), running T1's
covariation as the corollary. It consumes the frozen M0 conventions
([`2026-07-21-c440-conventions-freeze.md`](2026-07-21-c440-conventions-freeze.md)) and M1 bijection
([`2026-07-21-c441-vertex-reduction-bijection.md`](2026-07-21-c441-vertex-reduction-bijection.md))
and the frozen C406 certificate, introducing no conventions of its own (program guardrail 2).

Independent review (Fable), which verified every load-bearing fact by its own construction and
supplied the char-0 exhibition and the corrected wording:
[`2026-07-21-c442-m2-fable-review.md`](2026-07-21-c442-m2-fable-review.md).

## What is certified

**Clause (i) — antipodal uniqueness (GREEN).** The 66 vertex-pairs of the icosahedron fall into
exactly three `A5`-orbits of sizes `6 / 30 / 30` (antipodal axes / edges / short diagonals). An
`A5`-invariant perfect matching is a union of pair-orbits that is a perfect matching, and only the
size-6 orbit is one; hence the antipodal matching is the **unique** `A5`-invariant perfect matching.

**Clause (ii) — the two singletons ARE the two reductions of one golden antipodal matching, exhibited
directly (claim 3 confirmed in the golden frame; the M2 falsifier did NOT trigger).** The result
splits by frame, and both outcomes are recorded per the M2 spec:

- **Golden six-arc frame (claim 3, exhibited at char 0).** C379's reflection/six-arc formulas read
  at `tau = phi` are a char-0 golden object over `Q(phi)`: the projective reflection closure has
  order 60 and permutes the golden six-arc; its reduction at `phi -> 8` is `a5(8)` element-by-element
  and at `phi -> 4` is `a5(4)`. The polar pairing of the six-arc on the 12 conic points is the unique
  `A5`-invariant matching, and **it reduces at pi (`phi -> 8`) to C406's base matching
  `{0,1}{2,5}{3,7}{4,9}{6,8}{10,inf}` and at pibar (`phi -> 4`) to C406's J-mate
  `{0,10}{1,inf}{2,7}{3,5}{4,8}{6,9}`** — the two singleton depth fibres. `sigma =
  Gal(Q(sqrt5)/Q)` carries the golden six-arc/`A5` to the disjoint conjugate six-arc/`a5(4)` and
  exchanges the two reductions (`reduce_pi(sigma(g)) = reduce_pibar(g)`). So the two singletons are
  the two prime-reductions of **one** golden antipodal matching.

- **M0's frozen rational binary-form frame (sheet-blind by theorem).** Klein's `f = xy(x^10 + 11
  x^5 y^5 - y^10)` has integer coefficients, hence is `sigma`-invariant; `sigma` normalizes its
  char-0 `A5` (`sigma(S) = S^2 in A5`, `sigma(T) in A5`), so it fixes the unique invariant matching.
  Therefore the two prime-reductions of the binary-form antipodal matching **coincide** (both equal
  one matching `M0`, whose `PGL_2(11)`-stabilizer is exactly the reduced golden `A5`, order 60,
  `⊂ PSL`; `PGL`-orbit 22, `PSL`-orbit 11). In this frame the two singletons are not two reductions:
  one is the prime-independent reduction, the other its char-11 outer image. This is not a failure
  of the theorem — it is a proof that the rational vertex model cannot carry the sheet bit, which
  lives entirely in the golden `A5`-embedding (upgrading M0's own hardening note from hedge to
  theorem).

- **Claim 4, re-scoped.** The sheet-swap element is not characteristic-11: it is the reduction of the
  **rational** rotation `Rz` (90° about z, spinor norm 2), which over `Q` carries the golden frame to
  its Galois conjugate; its mod-11 image is an outer `PGL_2(11)` element (Möbius `(x+10)/(x+1)`, det
  `2`) precisely because 2 is a nonsquare mod 11, lying in C406's `J`-transporter coset. What is
  purely char-11 is the **collision** (the disjoint char-0 golden and conjugate 12-point vertex sets
  are forced onto the *same* `P^1(F_11)` at `q = h+1`) and the **finite closure**
  `⟨a5(8), a5(4)⟩ = PSL_2(11)` (order 660). The char-11 gluing is the splitting of the icosahedral
  quaternion (Schur-index-2) obstruction at 11.

**Clause (iii) — T1 covariation (GREEN), stated convention-free.** Choosing `sqrt5 = 4` (`tau = 8`,
pi) vs `sqrt5 = 7` (`tau = 4`, pibar) simultaneously selects the sheet (`a5(8)` vs `a5(4)`), its
reference singleton (base vs J-mate), and the `mu_3` sign (leading depth coordinate `-6` vs `+6`,
`D(jmate) = -D(base)`): sheet labeling and `mu_3` sign covary as one bit — the chirality torsor is
the Kummer torsor of the spin discriminant `sqrt5`. The canonical, convention-free form (Fable
ruling D): *the oriented invariant "`mu_3` with `epsilon = +1` on the sheet containing the reduction
of the golden antipodal matching" is independent of the choice of prime above 11* — a corollary of
C406 (GREEN) plus this task. There is no inconsistency with "`sigma` fixes the binary-frame matching":
that is a sheet-blind-frame statement, and in the golden frame `sigma` moves the matching and flips
the labeling coherently.

## Corrected paper-facing wording (feeds Phase 3; supersedes master-stroke claims 3–4)

> Let `S` be the golden six-arc in `P^2` over `Q(sqrt5)` — the vertex-axis arc of the icosahedron —
> with its invariant anisotropic conic; the polar pairing of `S` on the 12 conic points is the
> unique `A5`-invariant perfect matching (the antipodal matching). Reduction at the two primes above
> 11 carries this one golden object to the two singleton depth fibres: `pi` gives the base matching
> with stabilizer `a5(8)`, `pibar` gives its J-mate with stabilizer `a5(4)`, and the nontrivial
> element `sigma` of `Gal(Q(sqrt5)/Q)` exchanges the two reductions. The exchange is implemented
> over `Q` by a single rational rotation of spinor norm 2, whose reduction is an outer element of
> `PGL_2(11)` precisely because 2 is a nonsquare mod 11; the two sheets themselves generate only
> `PSL_2(11)`. Klein's rational binary form carries the same 12 vertices over `Q`, but its `A5` is
> normalized by the full Galois group, so its reduction is prime-independent: the rational vertex
> model is sheet-blind, and the sheet bit lives exactly in the golden `A5`-embedding.

## Findings opened during the review (Fable) — recorded here per lane direction

These were surfaced while reviewing M2. Each is verified in the Fable review note
([`2026-07-21-c442-m2-fable-review.md`](2026-07-21-c442-m2-fable-review.md)); their follow-ups are
either queued as new tasks or cross-referenced into the downstream task that owns them, so none is
lost.

1. **The `(2/p)` sheet-fidelity law.** At a prime `p` split in `Q(sqrt5)`, the two Galois-conjugate
   `A5`-reductions are exchanged by `Rz`, whose det class is the class of 2 mod `p`; hence the two
   sheets are `PSL_2(p)`-**distinct iff 2 is a nonsquare mod `p`** (`p = ±3 mod 8`). Verified at
   `p = 11, 19, 29, 31, 41, 59`: distinct at `11, 19, 29, 59`; **fused inside `PSL` at `31` and
   `41`**. So `q = 11` is special three times over — 11 splits in `Q(sqrt5)`, 2 is a nonsquare mod
   11, and `q = h+1`. The natural composite condition (splits in `Q(sqrt5)` and 2 nonsquare) is a
   Chebotarev class in `Q(sqrt2, sqrt5)`. Note the H4/600-cell cliffhanger prime **31 is a fusion
   prime at the H3 level**. *Follow-up: cross-referenced into the T6 spec (law evaluations at
   13/19/31 and the H4 gate) and the Phase-3 cliffhanger in the program.*
2. **The six-arc descends to `Q`.** The reduced six-arc's full `PGL_3(F_11)`-stabilizer has order 60
   (so the char-0 stabilizer is exactly `A5`), and constructive Hilbert 90 produces an explicit
   `sigma`-stable `Q`-rational sextuple with rational conic Gram matrix. So the configuration lives
   over `Q`; what does not exist over `Q` is a golden *labeling* (equivalently a canonical prime
   above 11) — exactly C417's impossibility, with its sharpest boundary. *Follow-up: queued as
   **C459** (Q-forms classification); cross-referenced into P2e / C417 positioning.*
3. **The rational skeleton of the golden pair is octahedral (B3 inside H3).** The compound of the two
   conjugate six-arcs is stabilized by an order-24 projective `S4` (the cube group, rational) — the
   silver-case group is literally the sheet-blind core of the golden case. But the mechanism does
   **not** transfer to B3 naively: for B3 the group (`S4`) is rational/sheet-blind while the form
   (`7 sqrt2` middle coefficient) is silver — the bit-carrier dualizes from group-embedding to
   form/labeling. *Follow-up: cross-referenced into the M4 spec — M4 must be specified against this
   disanalogy, not by copying the H3 template.*
4. **The perpendicularity pairing.** Each golden axis is perpendicular to exactly one conjugate axis;
   this bijection is `sigma`-stable, hence reduces prime-independently — a canonical char-0 pairing
   between the two sheets' axis systems, available before any char-11 choice. *Follow-up:
   cross-referenced into the M5 spec as a candidate germ for the gluing certificate.*
5. **Two-frame necessity (mechanism).** Over `Q(sqrt5)` the binary icosahedral `2.A5` has
   quaternionic Schur index 2, so `A5` has no split `P^1` model there; its `K`-home is the
   anisotropic conic frame, while the split `P^1` (binary form) frame lives over `Q(zeta5)` where the
   full cyclotomic Galois group normalizes the Klein `A5` — which is exactly why that frame is
   sheet-blind. Reduction mod the split prime splits the quaternion algebra into `PGL_2(F_11)`.
   *Follow-up: cross-referenced into the M5 spec and the M0 addendum task (**C458**).*

## Queued follow-ups

- **C458 `[crowns]`** — M0 addendum: promote the golden six-arc + invariant anisotropic conic +
  polar-pair matching (already frozen de facto in C379) to a co-equal frozen sheet-carrying object
  under M0's JSON discipline, state the two-frame theorem (rational frame sheet-blind by
  Galois-normalization; golden frame sheet-faithful), and record the bridge. This is a convention
  **extension** (nothing frozen becomes wrong; M1 is untouched) required to move M2 from AMBER to
  GREEN.
- **C459 `[crowns]`** — classify the `Q`-forms of the six-arc (descent classes; the exhibited one has
  `S3` rational symmetry; a `D5` form plausibly exists), pinning C417's impossibility boundary.

## Artifacts

- Generator/checker:
  [`2026-07-21-c442-antipodal-singleton-reduction.py`](2026-07-21-c442-antipodal-singleton-reduction.py)
- Canonical certificate:
  [`2026-07-21-c442-antipodal-singleton-reduction.json`](2026-07-21-c442-antipodal-singleton-reduction.json)
- Hash manifest:
  [`2026-07-21-c442-antipodal-singleton-reduction.sha256`](2026-07-21-c442-antipodal-singleton-reduction.sha256)

**Replay** (from the repository root):

```
uv run python3 notes/2026-07-21-c442-antipodal-singleton-reduction.py --check
```

`--check` regenerates the JSON in memory, compares it byte-for-byte against the tracked artifact and
the sha256 manifest, and leaves the worktree unchanged. It imports M0/C441 and hash-verifies the M0
JSON and script against M0's manifest, and consumes the frozen C406 JSON and the C379/C399 modules
(hashes recorded in the certificate). Deterministic; no timestamps. Trusted boundary: exact
arithmetic in `Q(zeta5)` and `Q(phi)` (`Fraction`), exact prime-field arithmetic, and the frozen
conventions of C399/C406/C440/C441; all groups, root sets, reflection closures, and conic points are
recomputed, not assumed. The independent cross-check is the Fable review's separate construction of
the same facts.

## Boundary — what M2 does NOT certify

- the M0 addendum itself (the frozen co-equal golden object) — that is **C458**;
- commuting-with-reduction of the quotient constructions `mu1, mu2, mu3` and the denominator set `N`
  (**M3 / C443**); the covariation of clause (iii) becomes automatic once M3 proves the `sqrt5`-lift;
- the full B3 `sqrt2` and A3 inert-fusion sheet reduction theory, whose H3 template does **not**
  transfer (finding 3) (**M4 / C444**);
- the integral char-11 gluing statement (**M5 / C445**), for which the perpendicularity pairing
  (finding 4) and the quaternion-splitting mechanism (finding 5) are candidate germs;
- the `Q`-descent classification (**C459**) and the `(2/p)` law's general proof (T6 territory);
  only the six listed primes are machine-checked here.

No novelty or priority claim is made. The golden reduction of icosahedral structure mod split
primes is classical territory (Klein, Edge, Kostant; C377 audit boundary); M2 is verification, and
the candidate-new content remains the identification of the factorization-memory spine with the
reduction data, now pinned to the golden `A5`-embedding.
