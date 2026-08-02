# C756 — the known Paley-clique orbits never give a coherent system

**Lane**: `clebsch`. Date: 2026-08-02.

## Verdict

**Zero passes.** Across every `q = 3 (mod 4)` prime power with `7 <= q <= 503`, and every member
of the two published maximal-clique orbits — `Z = a*S_j + b` with `chi(a) = 1`, `b in F_{q^2}`,
`j in {0,1}` — not a single `Z` satisfies the crown condition (B). Total orbit members tested:
**1,686,529,824**; total passing: **0**.

Independently, and much more strongly, a complete clique search over the coherence graph found
**no coherent system at all** for every `q = 3 (mod 4)` prime power with `7 <= q <= 151`
(that is `7, 11, 19, 23, 27, 31, 43, 47, 59, 67, 71, 79, 83, 103, 107, 127, 131, 139, 151`).
That search does not depend on the published clique classification, so for that range it settles
nonexistence outright rather than only for the two orbits.

The only coherent systems seen anywhere in this run are the two known `q = 5` four-frames, which
appear as positive controls and are recovered by both the direct tester and the clique search.

## Setup and conventions

`q = p^m` odd. `F_q` is built from the lexicographically first monic irreducible polynomial of
degree `m` over `F_p` (little-endian digit order, digit `i` = coefficient of `x^i`); an element is
the integer whose base-`p` digits are its coefficients. `eps` is the least nonsquare of `F_q` in
that encoding. `F_{q^2} = F_q(s)` with `s^2 = eps`; the element `x + y*s` is encoded as the index
`x*q + y`. Conjugation is `(x + y s)^q = x - y s`, the norm is `N(z) = z^{q+1} = x^2 - eps*y^2`,
and `chi(u)` is the quadratic character of `N(u)` in `F_q`. Then `t = (q+1)/2`, `k = t + 1 =
(q+3)/2`, `delta = (-1)^t`; for `q = 3 (mod 4)` this gives `delta = +1`.

A coherent system is `Z` inside `F_{q^2} \ F_q` with `|Z| = k`, no two elements conjugate, and
`chi(z_i - z_j) = delta` and `chi(z_i - z_j^q) = -delta` for all `i != j`, together with
`chi(z_i - z_i^q) = delta`.

`C = {z : N(z) = 1}` is the norm-one circle, `Q_0 = {z in C : z^{(q+1)/2} = 1}` its index-2
subgroup, `Q_1 = C \ Q_0`, and `S_j = Q_j ∪ {0}`.

## Setup validation

For every one of the 53 fields in range the run checked, and confirmed, all of:

- `|C| = q + 1` and `|Q_0| = |Q_1| = (q+1)/2`, so `|S_j| = (q+3)/2 = k`;
- `S_0` and `S_1` are cliques in `P(q^2)`: every difference of two distinct elements is a nonzero
  square of `F_{q^2}`;
- `S_0` and `S_1` are maximal: no vertex of `F_{q^2}` outside `S_j` is `chi = +1`-adjacent to all
  of `S_j` (checked against all `q^2` vertices);
- `chi(-1) = +1` in `F_{q^2}`, which is what makes the crown condition symmetric in `i, j`.

No failure occurred at any `q`, so nothing in the run contradicts
Goryainov–Kabanov–Shalaginov–Valyuzhenich (2018) or Baker–Ebert–Hemmeter–Woldar (1996).

### The `b`-reduction was verified, not assumed

Differences `z_i - z_j = a(u_i - u_j)` do not involve `b`, and `z_i - z_j^q = a u_i - a^q u_j^q + c`
with `c = b - b^q`. The Rust run checks per `q` that the map `b -> b - b^q` has image exactly the
`q` trace-zero elements `s*F_q`, with every fibre of size exactly `q`, and that for a deterministic
sample of `(a, j, b, b')` with `b - b^q = b' - b'^q` the full `k x k` matrices of
`chi(z_i - z_j)` and `chi(z_i - z_j^q)` agree. The Python cross-check instead enumerates all
`q^2` values of `b` outright, so its counts are `q^2/q = q` times larger and depend on no
reduction at all. Both give zero passes.

## Results

`family size` is the number of `(a, c, j)` triples swept, `= q(q^2 - 1) = 2 * ((q^2-1)/2) * q`.
`coherent systems` counts `k`-cliques of the coherence graph through the fixed vertex `s`; by the
transitivity argument below, `0` there means no coherent system exists anywhere over that `q`.
Timings are from one run on the development host and are indicative only.

| q | p^m | eps | k | family size | passes | orbit sweep (s) | exhaustive vertices | coherent systems | exhaustive (s) |
|---|---|---|---|---|---|---|---|---|---|
| 7 | 7 | 3 | 5 | 336 | 0 | 0.00 | 42 | 0 | 0.00 |
| 11 | 11 | 2 | 7 | 1320 | 0 | 0.00 | 110 | 0 | 0.00 |
| 19 | 19 | 2 | 11 | 6840 | 0 | 0.00 | 342 | 0 | 0.00 |
| 23 | 23 | 5 | 13 | 12144 | 0 | 0.00 | 506 | 0 | 0.00 |
| 27 | 3^3 | 2 | 15 | 19656 | 0 | 0.00 | 702 | 0 | 0.00 |
| 31 | 31 | 3 | 17 | 29760 | 0 | 0.00 | 930 | 0 | 0.00 |
| 43 | 43 | 2 | 23 | 79464 | 0 | 0.00 | 1806 | 0 | 0.02 |
| 47 | 47 | 5 | 25 | 103776 | 0 | 0.00 | 2162 | 0 | 0.04 |
| 59 | 59 | 2 | 31 | 205320 | 0 | 0.01 | 3422 | 0 | 0.13 |
| 67 | 67 | 2 | 35 | 300696 | 0 | 0.01 | 4422 | 0 | 0.25 |
| 71 | 71 | 7 | 37 | 357840 | 0 | 0.01 | 4970 | 0 | 0.28 |
| 79 | 79 | 3 | 41 | 492960 | 0 | 0.01 | 6162 | 0 | 0.60 |
| 83 | 83 | 2 | 43 | 571704 | 0 | 0.02 | 6806 | 0 | 0.87 |
| 103 | 103 | 3 | 53 | 1092624 | 0 | 0.03 | 10506 | 0 | 4.74 |
| 107 | 107 | 2 | 55 | 1224936 | 0 | 0.04 | 11342 | 0 | 6.46 |
| 127 | 127 | 3 | 65 | 2048256 | 0 | 0.06 | 16002 | 0 | 36.84 |
| 131 | 131 | 2 | 67 | 2247960 | 0 | 0.14 | 17030 | 0 | 55.23 |
| 139 | 139 | 2 | 71 | 2685480 | 0 | 0.13 | 19182 | 0 | 62.47 |
| 151 | 151 | 3 | 77 | 3442800 | 0 | 0.10 | 22650 | 0 | 135.36 |
| 163 | 163 | 2 | 83 | 4330584 | 0 | 0.13 | — | — | — |
| 167 | 167 | 5 | 85 | 4657296 | 0 | 0.14 | — | — | — |
| 179 | 179 | 2 | 91 | 5735160 | 0 | 0.17 | — | — | — |
| 191 | 191 | 7 | 97 | 6967680 | 0 | 0.21 | — | — | — |
| 199 | 199 | 3 | 101 | 7880400 | 0 | 0.24 | — | — | — |
| 211 | 211 | 2 | 107 | 9393720 | 0 | 0.28 | — | — | — |
| 223 | 223 | 3 | 113 | 11089344 | 0 | 0.34 | — | — | — |
| 227 | 227 | 2 | 115 | 11696856 | 0 | 0.36 | — | — | — |
| 239 | 239 | 7 | 121 | 13651680 | 0 | 0.42 | — | — | — |
| 243 | 3^5 | 2 | 123 | 14348664 | 0 | 0.44 | — | — | — |
| 251 | 251 | 2 | 127 | 15813000 | 0 | 0.48 | — | — | — |
| 263 | 263 | 5 | 133 | 18191184 | 0 | 0.56 | — | — | — |
| 271 | 271 | 3 | 137 | 19902240 | 0 | 0.61 | — | — | — |
| 283 | 283 | 2 | 143 | 22664904 | 0 | 0.69 | — | — | — |
| 307 | 307 | 2 | 155 | 28934136 | 0 | 0.87 | — | — | — |
| 311 | 311 | 11 | 157 | 30079920 | 0 | 0.92 | — | — | — |
| 331 | 331 | 2 | 167 | 36264360 | 0 | 1.09 | — | — | — |
| 343 | 7^3 | 3 | 173 | 40353264 | 0 | 1.24 | — | — | — |
| 347 | 347 | 2 | 175 | 41781576 | 0 | 1.26 | — | — | — |
| 359 | 359 | 7 | 181 | 46267920 | 0 | 1.42 | — | — | — |
| 367 | 367 | 3 | 185 | 49430496 | 0 | 1.55 | — | — | — |
| 379 | 379 | 2 | 191 | 54439560 | 0 | 1.62 | — | — | — |
| 383 | 383 | 5 | 193 | 56181504 | 0 | 1.99 | — | — | — |
| 419 | 419 | 2 | 211 | 73559640 | 0 | 2.21 | — | — | — |
| 431 | 431 | 7 | 217 | 80062560 | 0 | 2.43 | — | — | — |
| 439 | 439 | 3 | 221 | 84604080 | 0 | 2.57 | — | — | — |
| 443 | 443 | 2 | 223 | 86937864 | 0 | 2.59 | — | — | — |
| 463 | 463 | 3 | 233 | 99252384 | 0 | 3.01 | — | — | — |
| 467 | 467 | 2 | 235 | 101847096 | 0 | 3.04 | — | — | — |
| 479 | 479 | 13 | 241 | 109901760 | 0 | 3.33 | — | — | — |
| 487 | 487 | 3 | 245 | 115500816 | 0 | 3.55 | — | — | — |
| 491 | 491 | 2 | 247 | 118370280 | 0 | 3.65 | — | — | — |
| 499 | 499 | 2 | 251 | 124251000 | 0 | 3.87 | — | — | — |
| 503 | 503 | 5 | 253 | 127263024 | 0 | 3.99 | — | — | — |

Column totals: 1,686,529,824 orbit members tested, 0 passes; orbit sweep 51.8 s wall clock over all
53 fields, exhaustive search 303.3 s over the 19 fields where it was run. No exhaustive search hit
its 400-second-per-field budget, so every `completed` flag in the certificate is `true`.

## The exhaustive search and why fixing one vertex is legitimate

Build the graph `G` on the `q^2 - q` irrational elements of `F_{q^2}`, with `z ~ w` iff
`chi(z - w) = delta` and `chi(z - w^q) = -delta`. Because `chi` is conjugation-invariant and
`chi(-1) = +1`, the second condition is symmetric in `z` and `w`, and a coherent system is exactly
a `k`-clique of `G`.

The affine maps `z -> a z + b` with `a in F_q^*` and `b in F_q` fix `F_q` pointwise, so they
commute with conjugation and scale both `z - w` and `z - w^q` by `a`, whose character is
`chi(a) = legendre(a^2) = +1`. They are therefore automorphisms of `G`, and they act transitively
on the irrational elements (`x + y s -> s` via `a = y^{-1}, b = -x/y`). The run verifies both facts
computationally per `q`: `transitive` checks the orbit of `s` is the whole vertex set, and
`aut_verified` checks edge preservation over all vertex pairs for the generators `z -> g z`
(`g` a primitive element of `F_q`) and `z -> z + 1`. Both are `true` at every `q` searched. Hence
searching only cliques containing `s` loses nothing.

Note that the full Paley automorphism group `z -> a z^{p^i} + b` with `chi(a) = 1` does **not**
preserve condition (B) — that is exactly why the orbit sweep has to range over `a` and `c` at all.

## Controls

- **Positive, tester.** The two known `q = 5` four-frames `{s, 1+4s, 2+2s, 4+3s}` and
  `{s, 4+4s, 1+3s, 3+2s}` (with `eps = 2`, `t = 3`, `k = 4`, `delta = -1`) are both reported
  coherent by the generic tester, in Rust and in Python.
- **Positive, clique search.** Run at `q = 5`, the exhaustive clique search finds exactly two
  coherent systems through the vertex `s` — the two known frames — confirming the search is not
  vacuously returning zero.
- **Negative, random.** 8000 deterministic pseudorandom size-`k` subsets of the irrational
  elements, with no two conjugate, over `q = 5, 7, 11, 27`: 2 coherent, both at `q = 5`
  (where coherent systems genuinely exist and are dense enough to hit by chance), and 0 at
  `q = 7, 11, 27`.
- **Negative, deterministic.** In Python, `{s, 1+s, 2+s, 3+s}` at `q = 5` is rejected.
- **Cross-check against the earlier certified audit.** That audit found no coherent system at
  `q = 7, 11, 19, 23`. The exhaustive search here reproduces that independently, and the orbit
  sweep is consistent with it.
- **Cross-language.** The Python program reproduces the `q = 7, 11, 19, 23` rows (setup
  validation, clique and maximality of `S_0`, `S_1`, zero orbit passes, zero coherent systems)
  with independently written code: `Q_0` is computed as `{z^2 : z in C}` rather than by the
  `z^{(q+1)/2} = 1` test, and the orbit family is swept over all `b in F_{q^2}` rather than over
  the reduced parameter `c`.

## What this does and does not certify

Certified:

- For each `q = 3 (mod 4)` prime power with `7 <= q <= 503`, no member of the two published
  maximal-clique orbits of `P(q^2)` is a coherent system.
- For each `q = 3 (mod 4)` prime power with `7 <= q <= 151`, no coherent system exists at all.
  This is a full nonexistence result over that finite range, independent of the clique
  classification.

Not certified:

- Nothing about `q = 1 (mod 4)`, where `delta = -1` and condition (A) is not a Paley-clique
  condition. The `q = 5` material here is a control, not a sweep.
- Nothing beyond `q = 503`, and no infinite-family statement. Finite exhaustion is not a theorem.
- For `109 < q <= 503` (indeed for `151 < q <= 503`) the rows test only the two known orbits. The
  two-orbit classification of maximal `(q+3)/2`-cliques in `P(q^2)` is computer-verified in the
  literature only for `q <= 109`; above that it is conjectural. So those rows are **not** by
  themselves a nonexistence proof — they become one only conditional on the conjecture.
- The trusted boundary is the field construction, the quadratic-character table, and the clique
  search in this program. Both implementations agree at `q = 7, 11, 19, 23`, and the field layer is
  independently exercised by the `q = 5` positive controls.

## Replay

Working directory `/home/tavis/src/othello`. Scratch directory `SCRATCH` may be any writable path;
nothing is written to the `rust/` crate.

```
rustc -O -o "$SCRATCH/c756" notes/2026-08-02-c756-clique-orbit-crown-check.rs
"$SCRATCH/c756" --max 503 --exhaustive-max 151 --exhaustive-budget 400 \
    --out notes/2026-08-02-c756-clique-orbit-crown-check.json
python3 notes/2026-08-02-c756-clique-orbit-crown-check.py
```

The Rust program writes the certificate and prints one bounded progress line per `q` on stderr.
Wall-clock is host-dependent and is therefore omitted from the certificate (`"seconds": null`);
pass `--timings` to include it, which makes the output non-canonical. With the default flags the
output is byte-identical across runs — verified by regenerating into a scratch path and comparing.
The Python program prints its table and exits `0` when every assertion holds.

Toolchain used: `rustc 1.93.1 (01f6ddf75 2026-02-11)`, `Python 3.13.12` (standard library only).
Total run time: about 6 minutes for the Rust sweep, about 4 seconds for the Python cross-check.

### Hashes

| file | bytes | sha256 |
|---|---|---|
| `notes/2026-08-02-c756-clique-orbit-crown-check.rs`   | 31799 | `34b672be7e04f6a1fa0a1088ad676c6d80add1ade35e9d8fbc7622b1b16ef8bd` |
| `notes/2026-08-02-c756-clique-orbit-crown-check.py`   |  8337 | `631dc3fda2518137bc035e4ceff4128f3f3a03ad935623d2604426d9e6bd53e7` |
| `notes/2026-08-02-c756-clique-orbit-crown-check.json` | 18311 | `dd23b16c7329651baa83cc30a0a26f7a21259566cac9498d1502cceec60a8d19` |
