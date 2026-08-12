# Sub-B working certificate: A_5-commutant of Lambda_2 and Lefschetz Smith forms

Scratchpad only. Nothing committed; nothing under `notes/` or `papers/` touched.
Halted early on a quota constraint — see "Status" for what is complete vs in progress.

## Status summary

| Item | What it is | Status |
|---|---|---|
| (a) | `dim_{F_2} End_{F_2[A_5]}(Lambda_2)` and its algebra structure | COMPLETE, run |
| (a-extra) | module structure of Lambda_2; 20-gluing scan | COMPLETE, run |
| (b) | `s`-fixed and `w`-fixed parts of the commutant | COMPLETE, run |
| (b-joint) | joint `S_3 = <w,s>` invariants (the intersection) | IN PROGRESS — code written, NOT run |
| (c) | Smith form of `L_3 : ^3 Lambda -> ^5 Lambda` | COMPLETE, run |
| (d) | Smith form of `L_5 : ^5 Lambda -> ^7 Lambda` | COMPLETE, run |

Everything marked COMPLETE comes from the run recorded in
`subB-lattice-rigidity.out` / `.json`. The single IN PROGRESS item is described
precisely below, including what the already-measured numbers imply.

## 1. Infrastructure found

All under `/home/tavis/src/othello/`.

- `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage` — the load-bearing
  input, loaded verbatim with `sys.argv = ["...", "--export-constants"]` under a
  `redirect_stdout(StringIO())` (the c908 files' idiom, their lines 58-62).
  Provides:
  - `axis_action(permutation)` (line 14) — action on `v1..v5` with
    `v6 = -(v1+...+v5)`, i.e. the six-axis lattice `L`, `gram = 6I - J`.
  - `mobius_generators()` (line 26) — `A_5 = PSL_2(F_5)` on `P^1(F_5) =
    {0,1,2,3,4,inf}` via `T: x -> x+1` (`[1,2,3,4,0,5]`) and `S: x -> -1/x`
    (`[5,4,2,3,1,0]`).
  - `generated_axis_group()` (line 33) — asserts order 60.
  - `commutant_basis` / `exotic_endomorphism` (lines 62, 77) — the F_4 structure
    on the 4-dimensional mod-2 quotient action; `omega` with
    `omega^2 + omega + 1 = 0`.
  - `principal_lattice(two_slope="omega", three_slope=1)` (line 93) — returns
    `(gram, omega, basis, symplectic)`. `basis` is the 10x10 rational
    principal-lattice basis (rows = lattice vectors in ambient dual-square
    coordinates); `symplectic` = the unimodular Gram `S` (`|det| = 1` asserted).
  - `two_form` (line 202) and `wedge` (line 209) — the exterior machinery;
    `Theta = two_form(symplectic)` in `^2 Lambda`.
- `notes/2026-08-11-c908-m-cross-m-exceptional-residue.sage` — reused verbatim:
  `basis_form` (line 65), `lefschetz_matrix(theta, source_degree)` (line 69),
  `elementary_divisor_counts` (line 81), and the `Theta = two_form(symplectic)`
  construction at line 115. Its committed result: `L_5` has divisors `1^110 2^10`.
- `notes/2026-08-11-c908-unmarked-closure-and-w-twist.sage` — the rank-25
  integral endomorphism order `End(J)` via `integral_endomorphism_lattice(basis)`
  (line 65), and `f2_matrix_of` (line 88). **Not used** in the end: an explicit
  integral A_5 action was available (below), so (a) did not need the fallback.
- `notes/2026-08-11-c904-exotic-deck-kunneth-residuals.sage` lines 16-22 — the
  corpus *model* `g = diag(companion)^5`, `s = diag(swap)^5` on `F_2^10` with
  `g^3 = 1`, `s^2 = 1`, `s g s = g^2`. This is an abstract `F_4^5` model, not
  attached to the actual `Lambda_2`; my `w` and `s` are built on the real lattice
  instead.

### Explicit integral A_5 action on Lambda — YES, it exists

No file in the corpus stored two 10x10 integral A_5 matrices directly, but they
are one line away from `principal_lattice`, and I verified integrality:

For an axis matrix `M` (from `axis_action`), the ambient action is
`A = block_diagonal_matrix(M, M)` on the dual-square, and the induced action on
`Lambda` in the `basis` coordinates is

    rho = basis * A.transpose() * basis.inverse()

(the exact convention of `integral_endomorphism_lattice`, c908 line 74). Verified
for both Moebius generators on the exotic gluing `principal_lattice("omega", 1)`:

- `rho` is **integral** (denominator 1),
- `rho * S * rho^t == S`, i.e. the action is symplectic,
- the generated matrix group has order **60**, and the source permutation group
  is isomorphic to `AlternatingGroup(5)`.

**So (a) uses the genuine A_5, not a fallback group.**

Character cross-check (trace by element order): `1 -> 10`, fifteen involutions
`-> 2`, twenty order-three `-> -2`, twenty-four order-five `-> 0`. That is twice
the rational 5-dimensional character of A_5, so `Lambda (x) Q = W + W` with `W`
the rational 5-dimensional irreducible, and `End_{Q[A_5]}(Lambda_Q) = M_2(Q)`
(measured dimension 4, matching).

The outer element `x -> 2x` of `PGL_2(F_5) \ PSL_2(F_5)` does **not** stabilize
`Lambda` integrally (measured: `outer_element_x_to_2x_is_integral_on_Lambda =
False`) — it moves the omega-gluing to the omega^2-gluing. Mod 2 it still exists
as a twisted intertwiner, which is how `s` is constructed.

## 2. Results

### (a) The commutant is NOT F_4 — it is 4-dimensional and noncommutative

`dim_{F_2} End_{F_2[A_5]}(Lambda_2) = 4`, not 2.

So **`Lambda_2` is not absolutely irreducible over F_4 as an A_5-module.** In
fact it is not irreducible at all.

Measured algebra structure of the commutant `A` (16 elements):

- 12 units, exactly 2 idempotents (`0` and `1`) — so `A` is **local**;
- 4 nilpotents forming a 2-dimensional square-zero ideal `J` (`J^2 = 0`);
  all three nonzero elements of `J` have rank 4;
- `A / J = F_4 = F_2[w]`, and there are 8 solutions of `x^2 + x + 1 = 0`
  (the two classes `w`, `w^2` each lifting in 4 ways);
- **noncommutative**, and the exact obstruction is a Frobenius twist:
  `w * e == e * w^2` for every nonzero `e` in `J`, and `w * e != e * w`.

Presentation:

    A  =  F_4<e> / ( e^2,  e*lambda - lambda^2 * e )

i.e. the Frobenius-twisted dual numbers over F_4: local, residue field F_4,
square-zero radical `F_4.e` of F_2-dimension 2. An F_2-basis is
`{1, w, e, w e}`; the explicit matrices are in the JSON under
`a_commutant_mod_two.commutant_basis_rows` and `.w_matrix`.

`w` is symplectic mod 2 (`w S w^t = S`) and has order 3.

Module structure of `Lambda_2` (measured by exhaustive cyclic-submodule scan over
all 1023 nonzero vectors):

- A_5-fixed subspace has dimension **0**;
- cyclic submodule dimensions: 15 vectors generate a 4-dimensional submodule,
  48 generate 5-dimensional ones, 960 generate all of `Lambda_2`;
- hence a **unique minimal submodule**, the 4-dimensional absolutely-irreducible
  F_4-module (15 = 2^4 - 1 nonzero vectors, all generating the same thing), three
  intermediate 5-dimensional submodules, and composition factors `4, 1, 4, 1`
  (consistent with `Lambda_Q = W + W`, `W mod 2 = [4, 1]`).
- The unique minimal submodule is exactly what forces `End` to be local.

Gluing cross-check over all 20 principal gluings (`two_slope` in
`infinity/zero/one/omega/omega2` x `three_slope` in `infinity/0/1/2`): every
gluing is A_5-stable; commutant dimensions take only the values **4 and 5**, and
**all 20 are noncommutative**. So the failure of "commutant = F_4" is structural
for this pencil, not an artefact of the exotic gluing. (Per-gluing dimensions are
in the JSON at `a_gluing_scan.entries`; the printed per-gluing detail line was
added in the final unrun edit.)

### (b) s exists on the real Lambda_2; F_4-part fixed by s is exactly {0,1}

Construction of `s`: solve `rho(p) E = E rho(theta(p))` over F_2 for both
generators, where `theta` is conjugation by the outer element `x -> 2x`. Results:

- the twisted intertwiner space has F_2-dimension **4** (same size as the
  commutant, as expected for a torsor over it), with **12 invertible** elements;
- searching `t * a` over the 12 invertible twisted intertwiners and the 60 group
  elements gives **30 involutions `s`** with `s^2 = 1` and `s^{-1} w s = w^2`;
- **all 30 are symplectic mod 2** (`s S s^t = S`);
- each such `s` fixes exactly **4** elements of the 16-element commutant, an
  F_2-subalgebra of dimension 2, namely `F_2[e_0] = F_2[x]/(x^2)` for one
  rational line `e_0` in the radical (it contains `1`, contains one nonzero
  nilpotent, and does **not** contain `w`);
- across the 30 involutions there are **3 distinct** such fixed subalgebras
  (matching the 3 lines in the 2-dimensional radical);
- **the F_4 = F_2[w] subalgebra fixed by s is exactly `{0, 1}`** — the
  conjectured statement, confirmed.

**Correction to the framing of (b).** The task's expected reasoning was
"conjugation by g is trivial because the commutant is F_4, so only s matters".
Both halves of that are wrong here, and they fail in compensating directions:

1. The commutant is not F_4 (it is 4-dimensional), so `s` alone does **not** cut
   it down to `{0,1}` — it cuts it to a 2-dimensional `F_2[x]/(x^2)`.
2. Conjugation by `w` is **not** trivial, precisely because the commutant is
   noncommutative. Measured: the centralizer of `w` in the commutant is exactly
   **4 elements**, i.e. `F_4 = F_2[w]` itself, since the radical is
   Frobenius-twisted (`w e = e w^2`, so no nonzero radical element commutes
   with `w`).

So the two S_3 generators do genuinely different work, and the joint invariants
are the intersection

    (centralizer of w) cap (centralizer of s)  =  F_4 cap F_2[e_0]  =  {0, 1} = F_2.

**IN PROGRESS / NOT RUN:** the code computing this intersection explicitly for
each of the 30 involutions was written into the script (keys
`joint_S3_invariant_element_counts_over_all_such_s` and
`joint_S3_invariants_are_exactly_zero_and_identity_for_every_s`) but the run was
halted before executing it. The conclusion `{0,1}` is a two-line consequence of
two *measured* facts already in the completed run — `|centralizer of w| = 4` with
that centralizer equal to `F_4`, and `|s-fixed| = 4` with `w` not in it, so the
intersection is a proper subalgebra of `F_4` containing `1`, hence `{0,1}` — but
it is an inference, not a certified measurement. Re-run to certify.

### (c) L_3 = Theta ^ (-) : ^3 Lambda -> ^5 Lambda

Matrix shape **120 x 252**, rank **120**, elementary divisors **`1^110 2^10`**.
Matches the conjecture exactly. Cokernel-relevant reading: the 2-torsion has
rank 10, same as for `L_5`.

### (d) L_5 = Theta ^ (-) : ^5 Lambda -> ^7 Lambda (cross-check)

Matrix shape **252 x 120**, rank **120**, elementary divisors **`1^110 2^10`**.
Reproduces the committed C908 certificate
(`notes/2026-08-11-c908-m-cross-m-exceptional-residue.sage`, key
`lefschetz_5_to_7`) independently.

Control, also recomputed: `L_1 : ^1 Lambda -> ^3 Lambda` has divisors `1^10`
(image saturated), matching the committed `lefschetz_1_to_3`.

## 3. Files, replay, hashes

Script (self-contained, no randomness, canonical enumeration):

    /tmp/claude-1000/-home-tavis-src-othello-rust/2039083e-cf57-4bba-9c45-4b748965e4f2/scratchpad/subB-lattice-rigidity.sage

Replay command (must be run from the repository root — the script `load()`s the
c904 file by relative path; `sage` is not on bare PATH):

    cd /home/tavis/src/othello && SC=/tmp/claude-1000/-home-tavis-src-othello-rust/2039083e-cf57-4bba-9c45-4b748965e4f2/scratchpad && nix shell nixpkgs#sage -c sage $SC/subB-lattice-rigidity.sage --json $SC/subB-lattice-rigidity.json --out $SC/subB-lattice-rigidity.out

Runtime of the completed run: a few minutes, dominated by the 20-gluing scan and
the two Smith forms. No downscaling was needed.

SHA-256:

| File | SHA-256 |
|---|---|
| `subB-lattice-rigidity.sage` (current, with the unrun (b-joint) edit) | `8ba4997713fb246695c3ac5f773badd5840e4e9b996b2e6ee145775b73e3f3e2` |
| `subB-lattice-rigidity.out` (from the immediately preceding revision) | `720443354f81f9071cf4bd764224b95221c526a8967a0d9c813ffce893db7632` |
| `subB-lattice-rigidity.json` (same run as the `.out`) | `e826474a46b9e5e1db82e12ef81f73260ea22f2aa2125d9e2e29562367b449f4` |
| `probe2.sage` (structure probe: radical, twist, involution search) | `e8d30ef941271e3727d09092bfbb8a5b1c07cd20e7a446f475d8a69ba3d0d5ba` |
| input `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage` | recorded in the JSON under `inputs` |

**Hash caveat, stated plainly:** the `.out` and `.json` were produced by the
revision *immediately before* the last edit. The only differences in the current
script are the added joint-`S_3`-invariant computation and two extra printed
lines; nothing that could change any result already reported. Re-running the
current script regenerates both artefacts and makes the hashes consistent. All
results marked COMPLETE above are quoted from that `.out`/`.json` pair.

Sage preparse debris (`*.sage.py`) has been deleted.

## 4. Verbatim output of the completed run

```
Sub-B lattice rigidity: A_5-commutant of Lambda_2 and Lefschetz Smith forms
group: matrix order=60; source is A_5=True; traces={'order1': {'10': 1}, 'order5': {'0': 24}, 'order2': {'2': 15}, 'order3': {'-2': 20}}; outer x->2x integral on Lambda=False
(a) dim_F2 End_F2[A_5](Lambda_2)=4; equals F_4=False; commutative=False; units=12; idempotents=2; nilpotents=4; solutions of x^2+x+1=8
(a) radical dim=2; square-zero ideal=True; Frobenius-twisted over F_4=True; radical element ranks=[4]; w symplectic=True
(a) presentation: F_4<e>/(e^2, e*lambda - lambda^2 * e): local, residue field F_4 = F_2[w], square-zero radical F_4.e of F_2-dimension two, with e*lambda = Frobenius(lambda)*e; hence noncommutative and strictly larger than F_4
(a) module: A_5-fixed subspace dim=0; cyclic submodule dims (vector counts)={'4': 15, '5': 48, '10': 960}
(a) gluing scan over all 20 principal gluings: commutant dims=[4, 5]; noncommutative cases=20
(b) twisted intertwiners dim=4; invertible=12; involutions s with s w s = w^2=30; all symplectic mod 2=True
(b) commutant fixed by w: 4 of 16; fixed by s: 4 (F_2-dim 2); distinct fixed subalgebras=3; F_4-part fixed by s = {0,1}: True
(c) L_3: Lambda^3 -> Lambda^5 shape=[120, 252] rank=120 divisors={'1': 110, '2': 10}
(d) L_5: Lambda^5 -> Lambda^7 shape=[252, 120] rank=120 divisors={'1': 110, '2': 10}
control L_1: Lambda^1 -> Lambda^3 divisors={'1': 10}
PASS
```

## 5. Things worth deciding before this is folded into a committed note

1. The headline (a) answer is a **negative** for the "absolutely irreducible over
   F_4" framing, but a sharper positive replaces it: the commutant is the
   Frobenius-twisted dual numbers over F_4, and `Lambda_2` has a unique minimal
   submodule (the 4-dimensional F_4-irreducible) with composition factors
   `4,1,4,1`. Any rigidity argument that assumed `End = F_4` needs the extra
   radical direction handled.
2. Because all 20 gluings give a noncommutative commutant of dimension 4 or 5,
   "commutant = F_4" cannot be recovered by choosing a different gluing. It could
   only be recovered by passing to a subquotient — the natural candidate being the
   4-dimensional socle, where the commutant genuinely is F_4 (that is what
   `commutant_basis(action_two)` of dimension 2 in the c904 file already records
   at line 101).
3. (b) reaches the conjectured `{0,1}` but by a different mechanism than
   conjectured; the write-up should not repeat "conjugation by g is trivial".
   Certify the intersection by re-running before asserting it.
