# C489 stage 1 — staged Maslov roof, kill-switch

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `KILL — SHARP NEGATIVE. EVERY PSL_2(11)-INVARIANT QUADRATIC REFINEMENT OF THE BOCKSTEIN–TOR PAIRING ON C471'S RANK-SIX F_3 COMPLEX IS OUTER-EVEN. THE OUTER AUTOMORPHISM IS NOT REALIZED ON THE HINGE CARRIER (ker(H) IS NEITHER SELF-DUAL NOR OUTER-SELF-DUAL), SO NO OUTER-ODD INVARIANT REFINEMENT CAN EXIST. C489 CLOSES NEGATIVE AT STAGE 1; STAGE 2 IS NOT STARTED.`

This is the first falsifier of alt-master-strokes Candidate D ("the decoder's missing bit IS a
secondary quadratic/Maslov invariant"). Stage 1 was the bounded kill-switch: enumerate all
`PSL_2(11)`-invariant quadratic refinements of the pairing and test outer parity. They are all
outer-even, and the reason is structural, so the candidate dies here.

## Result

Work on `V = ker(H mod 3) = im(H^T) = C_12`, C471's rank-six exact complex, with C472's certified
`PSL_2(11)` generators `T` (order 11) and `S` (order 2) acting by the recorded `6x6` matrices. Three
facts, each an exact finite computation, force the negative:

1. **The Bockstein–Tor pairing is a cross-carrier duality, not a symmetric self-pairing.** The only
   nondegenerate, `PSL_2(11)`-equivariant form the divided operator produces is the perfect pairing
   ```text
   P : ker(H^T) x ker(H) -> F_3,   P(x',y) = x' . (H y / 3)   (mod 3),
   ```
   a `6x6` matrix of rank six. It pairs the two *distinct* row/column carriers; it is not a form on a
   single six-space.

2. **There is no `PSL_2(11)`-invariant nondegenerate symmetric self-pairing on `ker(H)`.** The space
   of invariant symmetric bilinear forms on `V` is one-dimensional, spanned by the **rank-one** form
   `b0 = ell0 (x) ell0` supported on the fixed line; its radical is the whole five-space. Equivalently
   `V ≅ 1 (+) 5` with the five-space **not self-dual** (`Hom(V,V*)` has maximal rank one).

3. **The outer automorphism is not realizable on the carrier.** Over `F_3` the two five-dimensional
   constituents `5a, 5b` are still non-isomorphic, and neither carrier realizes the dual/outer twist.
   Concretely `Hom_{PSL_2(11)}(V, V^theta)` has maximal rank one for every outer class-swap
   `theta: T -> T^k` (`k` a non-residue mod 11), i.e. no invertible linear map on the six-space
   induces the outer automorphism.

The refinement torsor has `3^6 = 729` elements; exactly **three** are `PSL_2(11)`-invariant
(`q0`, `q0 + ell0`, `q0 + 2 ell0`, with `q0(x) = 2 ell0(x)^2` the homogeneous refinement and `ell0`
the unique invariant functional). Because the outer automorphism has no linear realization on the
carrier, it induces no map on this three-element set: every invariant refinement is outer-even. The
kill-switch fires.

## Checkpoint A — pinning the pairing, and reconciling the two routes

The card names "the Bockstein–Tor pairing" but no upstream report writes it down; two candidate
constructions had to be reconciled, and they **agree**.

- **Divided-operator route.** The naive self-pairing `b(x,y) = x^T (H y / 3) mod 3` on `ker(H)` is
  **ill-defined**: `H` is not symmetric, and changing the integral lift of `y` by `3 v` shifts the
  value by `(H^T x) . v`; since `x in ker(H)` is *not* in `ker(H^T)`, this is generically nonzero.
  The certificate exhibits an explicit lift change taking the value `1 -> 0`. The same expression
  *is* well-defined when the first argument is taken in `ker(H^T)`, giving exactly the cross pairing
  `P` above.

- **Discriminant/linking-form route.** For the integral lattice `L = H·Z^12` with Gram `H^T H = 12 I`,
  the discriminant group is `(Z/12)^12` with three-part `(Z/3)^12`, carrying a nondegenerate symmetric
  `(1/3)Z/Z`-valued linking form. Its Lagrangian is exactly `ker(H mod 3)` — the self-dual extended
  ternary Golay code — on which the induced self-form **vanishes identically** (verified: the dot
  product is zero on all basis pairs). The nondegenerate datum the linking form induces on the
  Lagrangian is the pairing with the complementary quotient, i.e. again the cross pairing `P`.

Both routes therefore attach the name "Bockstein–Tor pairing" to the same object: the nondegenerate
cross-carrier duality `ker(H^T) x ker(H) -> F_3`, under which `ker(H)` is isotropic. The naive
symmetric self-pairing that Candidate D presupposes on the six-space does not exist invariantly; the
only invariant self-pairing is the rank-one `b0`. The routes give the **same** answer, so there is no
route-dependent ambiguity to report as a load-bearing finding — only the shared conclusion that the
nondegenerate pairing is cross-carrier.

## Checkpoint B — the outer map, and why the negative is not a degenerate-`tau` artifact

The outer element of `PSL_2(11)` is not inner (C480: `N_{M12}(PSL_2(11)) = PSL_2(11)`), so outer
parity must be tested through the row/column duality `H <-> H^T`. The certified outer comparison map
is the canonical Bockstein–Tor duality `tau = P`, which is nondegenerate (rank six) and equivariant.
The outer automorphism acts on the five-dimensional constituents precisely by `5a <-> 5b`
(dualization), so `H <-> H^T` duality *is* the carrier-level outer relationship.

The nontriviality certification required by Checkpoint B is the interesting part, and it is what makes
the negative robust rather than an artifact:

- `tau = P` is a genuine nondegenerate pairing — it is **not** trivial-by-construction.
- Yet the outer relation **cannot** be realized as an invertible self-map of the six-space. The
  would-be invertible outer involution on `ker(H)` is the self-duality `V -> V*`, which has maximal
  rank **one** (`Hom(V,V*)` computation). The carrier is neither self-dual nor outer-self-dual.

So the correct reading of the row/column duality is: it identifies `ker(H)` with the *dual* of
`ker(H^T)`, and the genuine outer twist lives on the module `5b = 5a*` that **neither** Hadamard
carrier realizes. A naive `tau` taken as the plain carrier-swap `ker(H) ≅ ker(H^T)` would be an
*inner* isomorphism (both carriers realize `5a`), and using it as "the outer map" would be exactly the
trivial-by-construction trap Checkpoint B warns against — it would fix every invariant refinement for
the wrong reason. The load-bearing fact is stronger: the outer automorphism has no linear realization
on the carrier at all, so the even-parity verdict is forced by module theory, independent of any
`tau` normalization convention.

This is consistent with C472's own geometry — both `288`-point signed-pair orbits share the same
frozen hinge complement, i.e. no outer exchange is realized on the hinge — and with C472's Tao-style
reframing that "only the demand that [the phase] occur on the frozen `PSL_2(11)` hinge was wrong."
Stage 1 makes that precise for the quadratic-refinement layer: the missing bit cannot live in an
invariant quadratic refinement on the hinge six-space, because the outer automorphism does not act
there.

## Enumeration results

| quantity | value |
|:--|:--|
| refinement torsor `Hom(G,Q/Z)`, `G=(Z/3)^6` | `729` |
| invariant functional space `(V*)^G` | dimension `1` |
| `PSL_2(11)`-invariant refinements (predicted / brute-counted) | `3` / `3` |
| invariant refinements | `q0`, `q0 + ell0`, `q0 + 2 ell0` |
| `tau`-orbit structure on invariants | three singletons (all outer-even) |
| outer-odd invariant refinement | **none** |

Module signature of `V = ker(H)` under `PSL_2(11)`: `End(V)` dimension `2` (so `V = 1 (+) 5`); fixed
line dimension `1`; unique invariant symmetric form of rank `1`; `Hom(V,V*)` and `Hom(V,V^theta)` both
of maximal rank `1` (not self-dual, not outer-self-dual).

**Transpose-carrier cross-check.** The transpose carrier `ker(H^T)` is Bockstein-dual to `ker(H)`; its
faithful stand-in `V*` has the identical structural signature (`End` dimension `2`, one fixed line,
one invariant functional, unique invariant symmetric form of rank `1`), and the transpose cross
pairing `P2 : ker(H) x ker(H^T) -> F_3` is likewise rank six. The picture is symmetric under
`H <-> H^T`, as it must be.

## Stage-2 disposition — closed negative

Stage 2 (express C472's length-eight central word as holonomy in the signed coordinate/row cell
groupoid and compare with the standard Maslov/metaplectic cocycle) was contingent on stage-1 survival.
Stage 1 does not survive: there is no outer-odd `PSL_2(11)`-invariant quadratic refinement to carry a
secondary bit, because the outer automorphism is not realized on the hinge carrier. **Stage 2 is not
started.**

The negative is bounded exactly: it concerns quadratic (Maslov-type) refinements of the Bockstein–Tor
pairing on the frozen `PSL_2(11)` hinge six-space `ker(H mod 3)`. It does **not** speak to the global
signed-Mathieu carrier, where C472 already certifies the full action is irreducible and the central
phase is a global row/column gluing phenomenon (its length-eight central word). Any surviving
metaplectic contact must be sought there, not in an invariant refinement on the hinge — which is the
lane's already-recorded frontier, not new work opened by this task.

## Certificate and reproducibility

The atomic bundle is:

- `notes/2026-07-22-c489-maslov-roof-staged.md`;
- `notes/2026-07-22-c489-maslov-roof-staged.py`;
- `notes/2026-07-22-c489-maslov-roof-staged-replay.py`;
- `notes/2026-07-22-c489-maslov-roof-staged.json`;
- `notes/2026-07-22-c489-maslov-roof-staged.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c489-maslov-roof-staged.py --check
python3 notes/2026-07-22-c489-maslov-roof-staged-replay.py
sha256sum -c notes/2026-07-22-c489-maslov-roof-staged.sha256
```

Intentional regeneration is the primary command without `--check`. It loads only the hash-pinned C471
and C472 certificates, builds the cross pairing, the invariant self-form, the module homomorphism
spaces, and the refinement census, and emits the canonical JSON. The independent replay imports no
primary code: it rebuilds `H` from C469's incidence block formula `H=[[1^T,1],[J-2A,-1]]` and checks
it against the pinned matrix, rebuilds `ker(H mod 3)` and verifies it is Lagrangian, enumerates the
full `660`-element `PSL_2(11)` and computes every invariant by full-group fixed-point kernels (a
distinct method from the primary's per-generator intertwining solve), counts invariant refinements by
direct evaluation of `q` on all `3^6` vectors, and measures the outer-twist and self-duality maximal
ranks.

**Trusted boundary.** Exact `F_3` and integer arithmetic; exhaustive enumeration of the finite
`729`-element refinement torsor, the `660`-element group, and the stated `6x6` homomorphism/form
spaces; hash-pinned C471 and C472 certificates. No literature, no full Mathieu recomputation, no
stage-2 claim, and no assertion beyond the frozen `PSL_2(11)` hinge six-space. This is a bounded
finite negative on a named domain, not an unrestricted nonexistence claim.

## Extra-juice closeout and mystery ledger

- **Settled — the pairing's true type.** The Bockstein–Tor pairing is nondegenerate only as a
  *cross-carrier* duality `ker(H^T) x ker(H)`; on a single six-space the only invariant self-pairing is
  rank one. Both the divided-operator and discriminant/linking-form routes agree, so the "which form
  does the name attach to" ambiguity in the card is resolved with no route disagreement.
- **Settled — why the bit cannot live here.** The outer automorphism acts by `5a <-> 5b`, and neither
  Hadamard carrier realizes the dual constituent, so no invertible outer map exists on the six-space.
  The three invariant refinements are outer-even for this structural reason, not by a convention.
- **Settled — the degenerate-`tau` trap is avoided.** The plain carrier-swap `ker(H) ≅ ker(H^T)` is
  *inner*; only its misuse would have manufactured a spurious outer-odd count. Certifying that the
  genuine outer relation is unrealizable on the carrier is what makes the negative robust.
- **Surprising, and explained — over `F_3` the five-dimensional reps do not merge.** One might expect
  `-11 ≡ 1 (mod 3)` to collapse `5a, 5b` (the quadratic Gauss datum becoming rational mod 3); it does
  not — `V` remains non-self-dual with `Hom(V,V*)` of rank one. The distinction that kills the
  candidate is the module-level `5a ≠ 5a*`, not a field-splitting accident.
- **No open mystery owned by C489.** The three structural facts, the census, and the outer
  non-realizability all pass an independent replay by a distinct route. The only forward frontier —
  the global signed-Mathieu central phase / length-eight central word — is C472's recorded open item,
  not a mystery this task leaves behind. Stage 2 remains closed unless that global object, not a hinge
  refinement, is reopened.
