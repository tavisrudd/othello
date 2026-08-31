# C1014 — feasibility of a bridge from the m = 2 Gram-shadow coloring to Paper II's quadratic trade

**Lane:** `clebsch`  ·  **Task:** C1014 side-check  ·  **Date:** 2026-08-30

**Owned files.** This report and `notes/clebsch-tasks/c1014_paper_ii_bridge.py`
(with its JSON output). Everything else consulted here was read only:
`papers/clebsch-factorization/clebsch_factorization.tex` (Paper II),
`notes/clebsch-tasks/c1013-gram-discriminant-invariant-hierarchy.md`,
`notes/2026-08-30-c1014-marking-reconstruction.md`, and — as foreign,
`relconic`-owned context — `notes/2026-08-30-c1015-match9-global-obstruction.md`.

Claim labels: **PROVED**, **COMPUTED** (with range), **READ** (with pointer),
**CONJECTURED**.

---

## Executive verdict

**Independent, for a proved representation-theoretic reason.** Paper II's
quadratic-trade generator is the PSL/PGL **sheet sign**: it transforms by the
nontrivial character `chi o det` of `PGL_2(q)/PSL_2(q)` and is nonconstant on
the matching orbit. The m = 2 Gram-shadow coloring `chi(G_{4,4}) = chi(I)` is a
genuine `PGL_2(q)`-**invariant** of unordered 4-subsets, with *even* bracket
weight at every `(m, q)` — C1014's Corollary 1.1 proves there is no `(m, q)` at
which it becomes only `PSL_2`-invariant. A function of the first kind can never
be built out of functions of the second kind, so the trade is not equal to, and
not determined by, the m = 2 coloring. Two independent computational confirmations
are recorded below, plus a measured-negative on the obvious elementary substitute.

The obstruction closes the whole Gram-shadow family, not just the `m = 2` row: a
`chi o det`-twisted member would need `rd` odd, which forces `d` and `r` both odd,
and then `G_{d,r}` vanishes identically because the invariant form on `Sym^d V` is
alternating. No other row, point count, or refinement can be substituted, so the
bridge should be closed as measured-negative.

**One exact identity does link the two objects**, and it is worth recording even
though it is not load-bearing: Paper II's three four-endpoint switch constants
`u, v, w` on a 4-set satisfy the Plücker relation `u - v + w = 0`, and the
apolar invariant of that 4-set is exactly their norm form,

```
    I  =  u^2 - u v + v^2  =  (u^2 + v^2 + w^2)/2 .
```

So the m = 2 coloring *is* the square class of the norm form of Paper II's switch
triple. That is a statement about a single 4-set. It carries no sheet information,
and the switch calculus never connects two matchings inside the same orbit
(COMPUTED: zero switch-adjacent pairs in all three orbits).

**Separately, deliverable 5 is a clear yes.** At q = 9 the m = 2 coloring *is* the
Baer/Miquelian stratum, and it **constructs** the exceptional one-factorization
of `K_10` that C1015's Hesse-tripod lemma has to kill. That contact is exact and
verified, and it is the one place where the two lanes genuinely meet.

---

## 1. Paper II's invariant and its trade moves (exact statements)

All pointers are to `papers/clebsch-factorization/clebsch_factorization.tex`.

### 1.1 The matching quotient

**READ**, `:273-295`. For `2m` marked points `Omega` of `P^1` with fixed vector
representatives, and a perfect matching `M`, the matching product is
`P_M = prod_{{a,b} in M} L_ab` with `L_ab(nu(s:t)) = [a,(s:t)][b,(s:t)]`
(`:250-261`). Proposition 2.1 gives `P_M|_C = P_N|_C` and, after a reference
matching `M_0`,

> `Phi_{M_0}(M) = (P_M - P_{M_0}) / Q  in  H^0(P^2, O(m-2))`   (2.1, `:279-284`)

with the equivariance

> `Phi_{gM_0}(gM) o rho(g) = det(g)^{2m-2} Phi_{M_0}(M)`   (2.2, `:290-291`).

### 1.2 The trade moves

**READ**, `:314-322`. The moves are the *four-endpoint switches*. For four
distinct endpoints the Plücker relation gives

> `L_ab L_cd - L_ac L_bd = [a,d][b,c] Q`   (2.3, `:320-321`),

and any two perfect matchings of `Omega` are joined by a sequence of such
switches (`:323-329`). Multiplying (2.3) by the secants common to the two
matchings shows a single switch moves `Phi` by `[a,d][b,c]` times a fixed
product of the untouched secants.

### 1.3 The invariant that is preserved / obstructed

**READ**, `:1465-1469`. The definition, verbatim:

> A *field-valued strength-two trade* is a weight `tau in k^Omega` satisfying,
> for all `f, g in L`, `sum_{M in Omega} tau(M) f(M) g(M) = 0`,

where `L` is the space of affine-linear functions on the quotient configuration
`{x_M = Phi_{M_T}(M)}` and `Omega` is a full `PGL_2(q)`-orbit of matchings.

The rigidity theorem then identifies that space. Proposition 4.2
(radical–Hadamard recovery, `:1486-1515`) proves

> `(L^{o2})^perp = k(1_{Omega_+} - 1_{Omega_-})`   (4.2, `:1510-1511`)
>
> Consequently every field-valued strength-two trade is a scalar multiple of the
> sheet sign.   (`:1513-1514`)

Here `Omega_+ sqcup Omega_-` is the splitting of the full `PGL_2(q)`-orbit into
its two `PSL_2(q)`-orbits, i.e. the two one-factorization sheets (`:1438-1447`).
The main theorem's clause (i) (`:126-131`) asks for exactly which orbits this
trade space is one-dimensional and two-valued; the answer is `B_3/F_7` and
`H_3/F_11` only.

**The key structural fact, stated by the paper itself**: Theorem 4.4
(`:1768-1797`), clause (iii), records

> `Stab_G(mu_3) = G^+`,  `Stab_G(F_q mu_3) = G`   (4.6, `:1789-1790`)

with `G = PGL_2(q)`, `G^+ = PSL_2(q)`, and `mu_3` the first nonvanishing signed
moment. So the object Paper II calls "cubic orientation" is precisely a
`chi o det`-anti-invariant: `PSL_2` fixes it, the outer coset negates it. The
sheet sign, the trade generator, and the cubic orientation are three names for
data of odd determinant weight.

---

## 2. The m = 2 coloring (recap, with pointers)

**READ**, `notes/clebsch-tasks/c1013-gram-discriminant-invariant-hierarchy.md:109-162`
and `notes/2026-08-30-c1014-marking-reconstruction.md:76-200`.

- `G_{4,4} = 16 Delta I` with `Delta = lambda^2(1-lambda)^2` and
  `I = lambda^2 - lambda + 1`; `Delta` is a square on distinct rational points, so
  `[det Gram] = [I(F)]` in `K^*/K^{*2}` (c1013:`121-158`).
- **Corollary 1.1 (PROVED, c1014:`125-136`)**: `G_{d,r}` has bracket weight
  `det(g)^{rd}` and rescaling representatives multiplies it by a square; at
  `r = 4` the weight `det(g)^{4d}` is *always* a square. Hence
  `S |-> chi(G_{d,4}(S))` is a well-defined function on unordered 4-subsets,
  invariant under the **full** `PGL_2(F_q)`, for every `d` and every odd `q`.
  The report states explicitly: "There is no `(m, q)` for which the four-point
  coloring is only `PSL_2`-invariant" (c1014:`135-136`), and the first twisted case
  in the family would need `r d` odd, which `r = 4` never achieves (c1014:`138-142`).
- **Theorem 4 (PROVED mod CFSG, c1014:`417-431`)**: the coloring's automorphism
  group is `Sym(q+1)` when the coloring is constant, and `PGammaL_2(F_q)` otherwise.
- At `m = 2` the coloring is `chi(I)`; at `q = 11` its positive class is the
  harmonic-quadruple `3-(12,4,3)` design, 165 of 495 blocks (c1014:`371-381`).

---

## 3. The one exact identity: switch constants carry the apolar invariant

**PROVED (symbolic, sympy) and COMPUTED-EXACT (all 4-subsets, q = 7, 9, 11, 13).**

Normalize a 4-set to `(infty, 0, 1, lambda)` with Paper II's representatives
`(1,0), (0,1), (1,1), (lambda,1)`. The three matchings of the 4-set give the
three switch constants of (2.3):

```
   u = [inf,0][1,lambda] = 1 - lambda
   v = [inf,1][0,lambda] = -lambda
   w = [inf,lambda][0,1] = -1
```

Then

```
   u - v + w = 0                    (Plücker; the three matchings are affinely collinear)
   u^2 - u v + v^2 = lambda^2 - lambda + 1 = I
   u^2 + v^2 + w^2 = 2 I
```

Consequences worth recording:

1. **The m = 2 coloring is the square class of the norm form of Paper II's switch
   triple.** `u^2 - uv + v^2` is the norm form of `Z[zeta_6]`; it vanishes exactly
   when `u/v` is a primitive sixth root of unity, i.e. on the equianharmonic orbit.
2. **In the matching quotient, the three re-pairings of one 4-set are collinear.**
   Multiplying (2.3) by the untouched secants, the three points
   `Phi(M_{ab|cd}), Phi(M_{ac|bd}), Phi(M_{ad|bc})` differ by `u R, v R, w R` for
   one fixed `R`, so they lie on a line in `W_T` with affine ratio `u : v : w`,
   i.e. determined by the cross-ratio. The m = 2 coloring is the square class of the
   norm form of that ratio. (PROVED; direct from (2.3) and the identity above.)
3. `lambda^2 - lambda + 1` also appears as Ziegler's coordinatization criterion in
   the foreign C1015 note (`:196-197`, READ): the `AG(2,3)` representation exists
   iff the field contains a root of `omega^2 - omega + 1`. Same form, three
   appearances — see section 6.

This identity is real but **not a bridge**: it lives on a single 4-set and is
blind to the pairing (all three re-pairings share the same `I`, since `I` is an
`S_4`-invariant of the quartic).

---

## 4. Verdict and proof: independent

### 4.1 The parity/weight obstruction (PROVED)

**Proposition.** Let `Omega_T` be a full `PGL_2(q)`-orbit of perfect matchings of
`P^1(F_q)` splitting into `PSL_2(q)`-orbits `Omega_+ sqcup Omega_-`, and let
`f: Omega_T -> A` be any function obtained by a `PGL_2(q)`-equivariant
construction from the m = 2 coloring `c(S) = chi(G_{4,4}(S))` — for instance the
multiset of colors of the 4-sets spanned by pairs of matching edges, any weighted
count of them, or any statistic of the induced colored hypergraph. Then `f` is
constant on `Omega_T`. The trade generator `tau = 1_{Omega_+} - 1_{Omega_-}` is
not. Hence `tau` is not a function of the m = 2 coloring.

*Proof.* By C1014 Corollary 1.1, `c(gS) = c(S)` for every `g in PGL_2(q)`. If `f`
is built equivariantly from `c` and from the matching's own combinatorics, then
`f(gM) = f(M)` for every `g`. Since `PGL_2(q)` is transitive on `Omega_T`, `f` is
constant. By Paper II (4.2) and (4.6), `tau(gM) = chi(det g) tau(M)` and `tau` is
nonconstant on `Omega_T`. A nonconstant function is not a constant one. QED

The gap is a **determinant-weight parity mismatch**, and it is intrinsic, not an
artifact of the chosen encoding: the coloring has even bracket weight at *every*
`(m, q)` by C1014 Theorem 1, whereas the trade generator spans the `chi o det`
isotypic line. Nothing of even weight generates something of odd weight.

### 4.1a The obstruction is family-wide, not specific to r = 4 (PROVED)

The natural escape — look for some other member `chi(G_{d,r})` of the
Gram-shadow family that *is* `chi o det`-twisted, and feed that to the trade — is
closed outright.

By C1014 Theorem 1 the `r`-point degree-`d` shadow is twisted by `chi o det`
exactly when `rd` is odd, which forces both `r` and `d` odd. But C1013 section 4
(READ, `notes/clebsch-tasks/c1013-gram-discriminant-invariant-hierarchy.md:213-224`)
records that the invariant form on `Sym^d(V)` is
alternating for odd `d`, so `G_{d,r} = 0` whenever `d` and `r` are both odd. One
line for `r = 3`: the hollow determinant is
`([1,2][2,3][3,1])^d + ([1,3][2,1][3,2])^d = (1 + (-1)^{3d})([1,2][2,3][3,1])^d`,
which vanishes for odd `d`. And for `d` odd with `r` even, `G_{d,r}` is a Pfaffian
square, so its character is identically `+1`.

**Therefore no nonzero member of the `G_{d,r}` family carries a `chi o det`
twist, at any `(d, r, q)`.** The even-weight obstruction of section 4.1 is not a
feature of the `m = 2` row or of `r = 4`; it is a property of the whole
Gram-shadow construction. There is no refinement, no other row, and no other
point count that repairs the bridge.

### 4.2 Computational confirmation (COMPUTED-EXACT)

`notes/clebsch-tasks/c1014_paper_ii_bridge.py`, section B. Orbits built as the
full `PGL_2(q)`-orbit of Paper II's base matchings (3.1, `:355-364`), with sheets
labelled by `chi(det)`:

| orbit    | m | orbit size | splits | sheets  | distinct m=2 color profiles | switch-adjacent pairs |
|----------|---|------------|--------|---------|-----------------------------|-----------------------|
| `A_3/F_5`  | 3 | 5          | no     | —       | 1                           | 0                     |
| `B_3/F_7`  | 4 | 14         | yes    | 7 + 7   | 1                           | 0                     |
| `H_3/F_11` | 6 | 22         | yes    | 11 + 11 | 1                           | 0                     |

Two readings:

1. **One color profile per orbit.** Every matching in `B_3` has the same multiset
   of m = 2 colors over the `C(m,2)` 4-sets spanned by pairs of its edges, and
   likewise in `H_3`. The coloring cannot even distinguish two matchings in the
   same orbit, let alone the two sheets. This is the Proposition, verified.
2. **Zero switch-adjacent pairs.** No two matchings of `Omega_T` differ by a single
   four-endpoint switch. The m = 2 fiber of the switch calculus — the object the
   identity of section 3 lives on — never touches a Coxeter orbit, which the paper
   itself anticipates ("A selected Coxeter orbit need not contain every perfect
   matching or every intermediate switch", `:334-335`). This is a *second*,
   independent structural gap: even the identity's carrier is disjoint from the
   theorem's carrier.

### 4.3 Measured negative on the obvious elementary substitute

Since the coloring cannot supply odd weight, the natural next candidate for an
elementary formula for the trade generator is the matching's own bracket product,
`s(M) = chi( prod_{{a,b} in M} [a,b] )`. It fails, in two different ways, and the
failure is instructive.

- **Representative-cocycle lemma (COMPUTED-EXACT, all of `PGL_2(q)` for
  q = 7, 9, 11, 13; zero mismatches).** With the paper's representatives
  (`a -> (1,a)`, `infty -> (0,1)`), write `g . rep(a) = c_a(g) rep(ga)`. Then
  `chi( prod_{a in P^1(F_q)} c_a(g) ) = chi(det g)`. Consequently
  `s(gM) = chi(det g)^{m-1} s(M)`.
- **q = 1 mod 4: well-defined but constant.** Here `chi(-1) = +1`, so `s` does not
  depend on edge orientation, and `2m = q+1` forces `m` odd, so `m - 1` is even and
  `s` is `PGL_2`-invariant. COMPUTED at q = 13 on a 1092-element matching orbit that
  splits 546 + 546: `s = +1` on both sheets.
- **q = 3 mod 4: not even well-defined.** Here `chi(-1) = -1`, so swapping the two
  endpoints of one edge flips `s`; fixing a total order on `P^1(F_q)` makes `s`
  deterministic but destroys equivariance. COMPUTED at q = 7 and q = 11 (both
  orderings, forward and reversed): `s` takes both values *within each sheet*.
  `B_3` and `H_3` are exactly the `q = 3 mod 4` cases.

So there is no elementary square-class formula of this shape for the trade
generator, at any `q`. This is a positive explanation of why Paper II needs its
modular-detector architecture (`:422-502`, `:2131-2494`) rather than a one-line
arithmetic argument: the natural square-class candidates are either invariant
(hence blind to the sheets) or ill-defined.

### 4.4 Answer to the deliverable-2 translation question

The task asked whether, under the translation "a matching pair = 4-set", the
trade obstruction on a quadratic trade's support equals the m = 2 color of that
support. Two things go wrong, both proved above:

- **The support is wrong.** Paper II's trade is one weight vector supported on
  the *entire* orbit (all 14 or 22 matchings), not on a 4-set. The paper's own
  4-set object is the switch identity (2.3), which is a *move*, not a trade.
- **The move-level version is inconsistent as well.** A hypothetical rule "the
  sheet flips across a switch on `S` according to `c(S)`" cannot exist for
  `Z/2`-valued data: the three re-pairings of one 4-set `S` are pairwise joined by
  switches on the *same* `S`, so a color-determined increment `eps` would need
  `eps + eps = eps` in `Z/2`, forcing `eps = 0`. (PROVED.) The failure is exactly
  that `c` is a function of the unordered 4-set and forgets the pairing.

---

## 5. Deliverable 4: the precise structural gap

State the negative like this.

> The m = 2 Gram-shadow coloring is an even-weight `PGL_2(q)`-invariant of
> unordered 4-subsets of `P^1(F_q)` (C1014 Corollary 1.1). Paper II's
> strength-two trade generator spans the `chi o det` isotypic line of the
> permutation module on a full matching orbit (Paper II (4.2), (4.6)). Every
> `PGL_2`-equivariant statistic built from the coloring is therefore constant on
> the orbit, while the trade generator is not; and the coloring, being a function
> of the unordered 4-set, cannot even orient a single four-endpoint switch. No
> member of the family `chi(G_{d,r})` repairs this: the twist needs `rd` odd,
> which forces `d` and `r` both odd, and then `G_{d,r} = 0` because the invariant
> form on `Sym^d(V)` is alternating.

Consequently deliverable 3's derivation path — "reconstruction dichotomy +
C1015 universal pencil theorem ⇒ Paper II trade rigidity" — is **not available**,
and it fails at the first step rather than at a missing lemma. For completeness,
the three separate reasons:

1. **Weight parity** (section 4.1): the dichotomy is a statement about the
   automorphism group of a `PGL_2`-invariant coloring; it produces no odd-weight
   data, and the trade generator is entirely odd-weight.
2. **Carrier mismatch**: C1015's theorem hypothesizes ten lines of `PG(2,K)` in
   general position whose one-factorization has collinear star points, and
   concludes the nine factor transversals form a pencil (READ, C1015:`176-181`).
   Paper II's carrier is products of secants of a conic passed through the conic
   ideal. The one-factorizations coincide as abstract objects only at `q + 1 = 10`,
   i.e. q = 9 — which is precisely a `q` that Paper II's classification *excludes*.
3. **Statement mismatch**: C1015 concludes a pencil (a rank-one incidence
   conclusion); Paper II concludes one-dimensionality of a trade space plus a
   two-valued generator. Neither implies the other even where the carriers agree.

**Estimated saving to Paper II's proof chain: zero.** No detector calculation
(`:2131-2494`), no uniform sheet exclusion (`:682-898`), and no item of the
verification architecture (`:3380-`) is displaced. The bridge idea should be
closed as **measured-negative**.

---

## 6. Deliverable 5: q = 9 Baer/Miquelian coloring vs C1015's pencil geometry

**Verdict: yes, an exact contact — and it is stronger than "contact". At q = 9 the
m = 2 coloring constructs C1015's exceptional one-factorization of `K_10`.**
All statements in this section are COMPUTED-EXACT at q = 9 unless labelled otherwise;
the C1015 statements they are compared against are READ, and nothing in C1015's
lane is claimed, edited, or reopened here.

At q = 9 the exponent reduction gives `r = 2m mod (q-1) = 4 = p + 1`, so the m = 2
row *is* the Baer stratum of C1014 Theorem 3 (c1014:`311-342`). Verified: of the
210 four-subsets of `P^1(F_9)`, 30 have color 0 and 180 have color `+1`; the color
`-1` never occurs. The 30 color-0 sets are the Baer sublines, i.e. the circles of
the Miquelian inversive plane of order 3 (c1014 Corollary 3.1, `:344-358`).

**(a) Circles through a point are the affine plane `AG(2,3)`.** COMPUTED: exactly
12 circles contain `infty`, and the map `S |-> S \ {infty}` sends them bijectively
onto the 12 lines of `AG(2,3)` on `F_9` (equivalently, the triples summing to 0).

**(b) C1015's exceptional factorization is the residual-pair factorization of the
inversive plane.** C1015 records (READ, `:199-204`) the exceptional non-pencil
class in the affine form

```
   M_a = { {infty, a} }  u  { {x,y} : x + y = -a },     a in F_3^2 .
```

Since three distinct points of `AG(2,3)` are collinear iff they sum to zero, and
by (a), the finite edges of `M_a` are *exactly* the residual pairs of the four
circles through `infty` and `a`. Restated coordinate-free:

> For any two points `P != Q` of `P^1(F_9)`, the four circles through `P` and `Q`
> have residual pairs partitioning the remaining eight points; setting
> `F_{P,Q} = {{P,Q}} u {residual pairs}` gives a one-factor, and
> `{ F_{P,Q} : Q != P }` is a one-factorization of `K_10`.

COMPUTED for all 10 choices of root `P`: each is a genuine one-factorization
(nine factors, five edges each, all 45 edges once). COMPUTED for `P = infty`: the
resulting factorization is set-equal to C1015's `M_a` family, and every pair of
its factors has cycle type `4 + 6` — the defining property of C1015's exceptional
class (READ, C1015:`190-191`).

**(c) The orbit is exactly the ten roots.** COMPUTED:
`|Stab_{PGL_2(9)}(factorization)| = 72`, of which 36 lie in `PSL_2(9)`; and
`720/72 = 10`, so the `PGL_2(9)`-orbit of the exceptional factorization consists
precisely of the ten rooted inversive factorizations, one per base point. The
Frobenius fixes `infty` and preserves the coloring, so the `PGammaL_2(9)`
stabilizer has order 144.

**(d) Within a factor.** COMPUTED: for each of the nine factors, the ten 4-sets
spanned by pairs of its edges split as 6 color-0 and 4 color-`+1`, identically for
all nine — the four pairs involving the `infty`-edge are circles by construction,
and exactly two of the six finite pairs are.

**Interpretation, stated exactly.** The class that C1015's Hesse-tripod lemma has
to exclude is not an accident of the `K_10` census: it is the Miquelian inversive
plane of order 3, i.e. the q = 9 member of the C1014 coloring family, in its
rooted residual-pair form. C1015 already says the affine-plane shadow is
"structural, not an accidental isomorphism found after the census" (READ,
`:203-204`); this identifies the structure. The recurrence of
`lambda^2 - lambda + 1` is likewise not coincidence-shaped but I have **not**
proved a common cause: it is the apolar invariant in C1013/C1014, the norm form of
the switch triple in section 3, and Ziegler's `AG(2,3)` coordinatization criterion
in C1015 (READ, `:196-197`). All three are the equianharmonic/sixth-root-of-unity
condition, so a common cause is plausible; calling it proved would overstate.

**What this does not do.** It gives Paper II nothing (q = 9 is excluded there), and
it does not touch C1015's proof, which is already complete and field-universal.
Its value is descriptive and, potentially, expository for whoever owns C1015.
Raising it to the `relconic` lane owner is the appropriate action; this report
takes no further step.

---

## 7. Replay and provenance

```
uv run --with sympy python3 notes/clebsch-tasks/c1014_paper_ii_bridge.py
```

Writes `notes/clebsch-tasks/c1014_paper_ii_bridge.json`. Runtime under two
minutes. Sections: A switch-constant identity (symbolic + F_q sweep), B the three
Coxeter orbits, C the q = 13 odd-`m` control, D the q = 9 Baer contact, E the
representative-cocycle lemma, the sheet-sign controls, and the rooted inversive
one-factorizations.

```
0fcf0a8d70d8ae51c8a00f6a461dcf00401d5fb9444bb34c771c8e39fbb670cf  c1014_paper_ii_bridge.py
a63a20855bebbe746b8c0718e0cb7607df884d2c88ebfee27135857a5edcc070  c1014_paper_ii_bridge.json
```

Independent replay: none yet. The B-section orbit sizes (5, 14, 22) and sheet
splits (7+7, 11+11) reproduce Paper II (3.2) at `:395-396` and `:1443-1445`; the
q = 9 color counts reproduce C1014 Theorem 3 and Corollary 3.1; the q = 11 m = 2
counts of C1014 section 2.5 are reproduced in A's 495-set sweep. Those are the
cross-checks available without new work.

---

## 8. Mystery ledger

**Settled by this pass.**

1. *Is Paper II's trade the m = 2 coloring?* No — settled by the determinant-weight
   parity argument (section 4.1), confirmed by the single-color-profile computation
   (4.2), and reinforced by the `Z/2` cocycle obstruction at move level (4.4).
2. *Why does Paper II need heavy modular machinery for what looks like a
   square-class statement?* Because the natural square-class candidate is either
   `PGL_2`-invariant (q = 1 mod 4, hence constant) or orientation-dependent
   (q = 3 mod 4, hence ill-defined), and `B_3`, `H_3` are both q = 3 mod 4
   (section 4.3). This was previously unexplained.
3. *Do the m = 2 four-sets and Paper II's switch constants have anything to do with
   each other?* Yes, exactly: `I = u^2 - uv + v^2` (section 3). Settled as an
   identity, and settled as non-load-bearing.
4. *Does the q = 9 Baer coloring touch C1015?* Yes, exactly: it constructs the
   exceptional `K_10` factorization as the rooted residual-pair factorization of the
   inversive plane of order 3 (section 6).
5. *Could some other row of the Gram-shadow family carry the odd weight the trade
   needs?* No, and this closes the question for the whole family rather than for
   `m = 2` alone: a `chi o det` twist needs `rd` odd, which forces `d` and `r` both
   odd, and then `G_{d,r}` vanishes identically because the invariant form on
   `Sym^d V` is alternating (section 4.1a, using C1013 section 4). This was the only
   route not already killed, and it is dead on arithmetic grounds.

**Open.**

6. *Common cause for the three appearances of `lambda^2 - lambda + 1`* (apolar
   invariant, switch-triple norm form, Ziegler's `AG(2,3)` criterion). Plausibly the
   single fact that `Z[zeta_6]` is the ring where the three re-pairing constants of a
   4-set become proportional, but this is **CONJECTURED**. Evidence gap: a statement
   relating the Hesse configuration's realizability to the equianharmonic locus of a
   4-set of the *same* projective line. Owner: `relconic` (C1015 owns the Hesse side);
   not actionable from the `clebsch` lane without cross-lane approval.
7. *`Aut` of the q = 9 exceptional factorization vs `PGammaL_2(9)`.* C1015 records
   automorphism-group order 432 (READ, `:204`); this report computes the
   `PGL_2(9)` stabilizer as 72 and hence the `PGammaL_2(9)` stabilizer as 144. If
   both figures are right, the factorization has symmetry of index 3 beyond
   `PGammaL_2(9)`, even though it is constructed from a `PGammaL_2(9)`-canonical
   structure. Evidence gap: an independent computation of the full `Sym(10)`
   stabilizer. Owner: `relconic`. Flagged, not pursued.
8. *Where does Paper II's odd weight actually come from, if not from any bracket
   determinant?* The trade generator exists — Paper II proves it — so some
   construction supplies the `chi o det` isotypic line, and by item 5 it is not a
   Gram/bracket invariant of point subsets. Reading the proof, it comes from the
   *matching product* `P_M` itself, whose equivariance weight `det(g)^{2m-2}`
   (Paper II (2.2)) is even, combined with the group-theoretic `PSL_2`-orbit
   splitting — that is, from the carrier's group structure rather than from any
   arithmetic of the marked points. Making that precise (an explicit odd-weight
   covariant of a matching, or a proof that none exists and the sheet sign is
   irreducibly group-theoretic) is the one question this pass raises and does not
   answer. Evidence gap: no candidate covariant tested beyond section 4.3's bracket
   product. Owner: `clebsch`, unallocated.

**No manufactured mystery.** Items 1–5 are genuinely closed; 6–8 have stated
evidence gaps and named owners.

---

## Status: complete
