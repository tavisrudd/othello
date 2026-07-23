# C488 -- QR-ladder q=23 rung of the Modular Gateway (binary Golay [23,12,7])

**Lane**: `crowns`
**Date**: 2026-07-22

## Verdict in one line

Split. The binary Golay `[23,12,7]` clears the pure-`F_2` code flag (gates 1--2); the
perfect-code-as-permutation-sheet **bridge** used in the two proved rows is **blocked** for
`PSL_2(23)` because that group has no degree-23 action (Galois); and the endotrivial **carrier**
itself **does extend** -- the genuine 11-dimensional `PSL_2(23)`-module clears every group-side gate
3--7. So the mechanism recognizes all three nontrivial perfect codes, but the permutation-sheet
packaging exists only for the Galois primes `q in {5,7,11}`.

## What was attempted, and the conventions

The Modular Gateway Theorem (`notes/2026-07-22-c474-modular-gateway-theory.md`, theorem numbering
1--7) recognizes a "perfect code -> simple endotrivial Lagrangian core -> unique nonsplit self-dual
carrier" mechanism. It is proved for two rows: `q=7` binary Hamming `[7,4,3]` over `F_2` and `q=11`
ternary Golay `[11,6,5]` over `F_3`. C488 tests the third and last nontrivial perfect code, the
binary Golay `[23,12,7]` over `F_2` (`q=23`, a binary quadratic-residue prime, `(2/23)=+1`), as a
`q=23` rung.

Load-bearing conventions:

- **Field** `k = F_2`.
- **Code side.** `Omega = Z/23`, the 23 coordinates. `D` = augmented QR code = span of the 23
  cyclic shifts of the quadratic-residue indicator (`dim 12`); `S` = expurgated even-weight subcode
  = span of pairwise shift differences (`dim 11`); `D = <1> (+) S`, `S = D^perp`; `A = ker(epsilon)`
  has `dim 22` and exists only on the odd 23-set.
- **Group side.** `G = PSL_2(23)`, order `6072 = 2^3 * 3 * 11 * 23`, `= <x->x+1, x->-1/x>` acting on
  `P^1(F_23) = 24` points (the point at infinity indexed 23). Sylow-2 is dihedral `D8`.
- **Gate numbering.** Theorem gates 1--7. The C488 queue's "gates 4--7" is shorthand for the
  remaining group-side gates = theorem gates 3--7.

The proved rows realise `S` as a size-`q` transitive `PSL_2(q)`-sheet (the exceptional degree-`q`
action: `q=7` Fano plane, `q=11` the two `A_5`-index actions). That is the "bridge" the third row
needs, and it is exactly where the third row parts from the first two.

## Per-gate verdict

| Gate | Statement | `q=23` result | Key numbers |
|:----:|:----------|:--------------|:------------|
| 1 | `\|Omega\|` nonzero in `k` | arithmetic **PASS** on the code, **BLOCKED** as a `PSL_2(23)`-bridge | `\|Omega\|=23=1` in `F_2`; but no odd-size `PSL_2(23)`-set (min faithful degree 24 `=0` in `F_2`) |
| 2 | `D=k1 (+) S`, `S=D^perp` | **PASS** | `dim(S,D,A)=(11,12,22)`; `[23,12,7]`; even subcode min wt 8 |
| 3 | nonsplitting (`Ext^1 != 0`) | **PASS** (carrier) | witnessed by an explicit nonzero global cocycle in `H^1(G, Hom(S^*,S))`; the even-parity heart `A24/<1>` splits, so it is not the carrier |
| 4 | `End_0(S)` projective on a Sylow | **PASS** (carrier) | `D8` norm-map rank `15 = 120/8`, so `End_0(S)\|D8` is free |
| 5 | `dim Ext^1(S^*,S) = 1` | **PASS** (carrier) | DIRECT global `H^1(PSL_2(23), Hom(S^*,S))` over all 6072 elements: `Z^1=122`, `B^1=121`, `dim = 1` |
| 6 | `S`, `S^*` non-isomorphic simples | **PASS** (carrier) | submodule dims `[0,11]` for `S` and `S^*`; `Hom(S,S^*)=0` |
| 7 | `End_{kG}(S)=End_{kG}(S^*)=k` | **PASS** (carrier) | both commutant dimensions `1` |

"(carrier)" means the gate is certified on the genuine `PSL_2(23)`-module `S = C/<1>`, where `C` is
the extended binary Golay `[24,12,8]` on `P^1(F_23)` -- the module that actually carries the
dihedral `D8` Sylow -- rather than on a size-23 code sheet, which does not exist for `PSL_2(23)`.

### The bridge obstruction (gate 1, group side)

A size-23 transitive `PSL_2(23)`-set would need a subgroup of index 23, i.e. order
`6072 / 23 = 264`. Exhausting the subgroups of order at most 264 that contain a fixed Sylow-2 (every
subgroup contains a conjugate of the Sylow-2, so an index-23 subgroup would appear here up to
conjugacy) yields overgroup orders `{8, 24}` only -- no order-264 subgroup. Corroboration: Galois'
theorem, `PSL_2(p)` has an index-`p` subgroup only for `p in {5,7,11}`. Hence no degree-23 action,
and the only natural size-23 symmetry group of the Golay coordinates, the affine `23:11` of odd
order 253, makes `F_2[23:11]` semisimple (Maschke) so every extension splits there -- the
endotriviality gates collapse. The perfect-code bridge is genuinely unavailable at `q=23`.

### The carrier survives (gates 3--7)

The extended Golay `C` (`dim 12`, contains the all-ones vector) is `PSL_2(23)`-invariant on the 24
points, and `S = C/<1>` is an 11-dimensional `PSL_2(23)`-module with the true `D8` Sylow. On it:
`S` and `S^*` are non-isomorphic simple (submodule lattices `[0,11]`, `Hom(S,S^*)=0`); each
endomorphism ring is `F_2`; and the trace-zero endomorphisms `End_0(S)` restrict freely to the `D8`
Sylow (norm-map rank `15 = 120/8`, the projectivity criterion for a 2-group).

Gates 3 and 5 are certified **directly and globally**, not by a local-to-global inference. A
from-scratch computation of `H^1(PSL_2(23), Hom(S^*,S))` -- the correct coefficient module for
`Ext^1(S^*,S)`, with action `F -> g F g^T` -- over all 6072 group elements via the Cayley-graph
`Z^1`/`B^1` rank route gives `Z^1 = 122`, `B^1 = 121`, so

> `dim Ext^1_{F_2 PSL_2(23)}(S^*, S) = 1`.

This certifies both **existence** of a nonsplit extension (gate 3; an explicit nonzero cocycle is
recorded in the certificate) and its **uniqueness** up to isomorphism (gate 5), unconditionally.

The local `D8` cohomology `H^1(D8, Hom(S^*,S)) = 2`, with the `q=7`-style fusion geometry (every
class trivial on the central `C2`, one class in the fused-reflection kernel, the central involution
`G`-fused to a reflection), is recorded as **corroborating structure only**. It is not the
load-bearing certificate: see the local/global caution below.

**Bonus.** `H^1(PSL_2(23), End(S)) = 0` (`Z^1 = B^1 = 120`), so `S` has no self-extensions.

### The even-parity heart, and why it is not the carrier

On the odd rows (`q=7,11`) the augmentation `A = ker(epsilon)` is the nonsplit carrier. At even
parity `|Omega| = 24 = 0` in `F_2`, so `A` in that exact form does not appear; the natural middle
module is the **heart** `H = A24/<1>` (`dim 22`), where `A24 = ker(epsilon)` on `P^1(F_23)` has
`dim 23` and contains the all-ones vector. Since every extended-Golay codeword has even weight,
`<1> < C < A24`, giving `S = C/<1>` inside `H` with quotient `H/S` isomorphic to `S^*`, i.e. the
sequence `0 -> S -> H -> H/S -> 0`.

Running the same equivariant-retraction solver used for the proved rows' gate 3, a `G`-equivariant
retraction `H -> S` **does exist**, and `End_G(H) = 2`: the heart **splits**, `H = S (+) S^*`. So
the even-parity middle module realises the zero (split) class, not the carrier. The nonsplit carrier
still exists -- the global `dim Ext^1 = 1` above guarantees it -- but it is not this canonical
module. This is the theory's odd/even split made explicit: the even, extended objects sit outside
the augmentation packaging. In sharp contrast with the proved rows, where the canonical augmentation
module **is** the unique nonsplit carrier, at `q=23` the canonical candidate splits and the
certified-existent nonsplit extension has no identified canonical permutation-module home.

### Local data does not determine the global dimension (caution)

`End(S)` (action `F -> g F g^{-1}`) and `Hom(S^*,S)` (action `F -> g F g^T`) have **identical** local
`D8` profiles -- both give `H^1(D8) = 2`, every class trivial on the central `C2`, exactly one class
in the fused-reflection kernel -- yet their **global** dimensions differ: `H^1(G, End S) = 0` while
`H^1(G, Hom(S^*,S)) = 1`. So the local fusion line alone does not determine the global Ext
dimension; the global computation is required. (An earlier draft of this bundle mis-fed `End(S)` as
the gate-5 coefficient module and inferred `dim = 1` from the local line; that inference is invalid,
as this very pair shows, and gate 5 is now the direct global computation.)

## Theorem-shaped conclusion

> The endotrivial-carrier half of the Modular Gateway extends to `q=23`: the 11-dimensional
> `PSL_2(23)`-module from the extended binary Golay `[24,12,8]` is a simple, rigid, `D8`-endotrivial
> module `S` with `S^*` its non-isomorphic dual and `dim Ext^1(S^*,S)=1`. The perfect-code
> permutation-sheet packaging of that carrier, present in the `q=7` and `q=11` rows, does **not**
> extend to `q=23`: `PSL_2(23)` has no degree-23 action, so no odd-size `G`-set carries the
> `[23,12,7]` flag.

Consequently the two-example statement does not become a "one family, one uniform construction"
theorem over all three nontrivial perfect codes. It splits into two statements with different
scope: the endotriviality mechanism is available for all three codes, while the perfect-code
permutation realisation is available only at the Galois primes `q in {5,7,11}` (of which only `q=7`
is binary). The risk-adjusted claim stays the construction/criterion, not the objects: the
carrier modules here are classical (subquotients of the Golay code).

## Alternative attacks considered (aa)

The failed gate is the group-realizability of gate 1 for `PSL_2(23)`. Distinct routes around it:

1. **Decouple the carrier from the odd `Omega` (executed, above).** Test gates 3--7 on the genuine
   11-dimensional `PSL_2(23)`-module `S = C/<1>` with its real `D8` Sylow. Outcome: all pass. This
   is the decisive route -- it shows the endotriviality survives and isolates the bridge as the sole
   failure.
2. **Change the group to the full automorphism group `M23` (open).** `M23` acts on the 23 Golay
   coordinates (`\|Omega\|=23` odd, gate 1 arithmetic holds) with the even subcode as an
   `F_2 M23`-module. Its Sylow-2 has order 128, a larger and different mechanism outside the
   `PSL_2(q)` family; gates 6/7/3 are cheap there but gate 4 (order-128 Sylow projectivity) is the
   selective unknown. Left unallocated: it answers a different question ("does the gateway recognize
   the Golay via its full aut group") than the `PSL_2(q)` ladder.
3. **Use the extended code / even side directly (ruled out by parity).** `G=PSL_2(23)` on
   `P^1(F_23)`, extended Golay `[24,12,8]`: `\|Omega\|=24=0` in `F_2`, gate 1 fails at the
   semisimple line, and the odd-set augmentation `A` degenerates. This is the theory's own
   odd/even split: the extended objects live outside the gateway.
4. **The whole binary QR ladder has one permutation rung.** The bridge needs `q` both binary
   (`q = +-1 mod 8`) and Galois (`q in {5,7,11}`); the unique such prime is `q=7`. So `q=31`,
   `q=47`, ... all hit the same `PSL_2(q)`-realizability wall; only the carrier-side (route 1)
   can travel further up the ladder.

## Mystery ledger

- **`m=(q+1)/4` at `q=23` is composite (`m=6`), yet the Sylow/fusion gates pass on the carrier.**
  Settled by route 1 above: this is the **first horn** of the designed experiment
  (`notes/2026-07-22-c472-c474-publication-value-review.md`). The `m`-coincidence ("period
  polynomial and Gram both degenerate at `m`") is **decorative**. The load-bearing mechanism is
  local endotriviality (`D8`-Sylow projectivity), which is characteristic-driven and independent of
  `m`; `m = p` prime in the two proved rows (`m=2` at `q=7`, `m=3` at `q=11`) is a numerical shadow,
  not a hypothesis. The independent obstruction that fails at `q=23` is Galois-primality of `q`, not
  the arithmetic of `m`. No open gap remains on this row.
- **Why the two phenomena coincided at `q=7,11`.** At those primes `PSL_2(q)` happens to be both
  Galois (a degree-`q` sheet exists) and the code's realisation group; at `q=23` the two come apart.
  Settled: they are logically separate and only accidentally simultaneous at the small primes.
- **OPEN -- the nonsplit carrier has no identified canonical home at `q=23`.** At `q=7` and `q=11`
  the unique nonsplit carrier is precisely the canonical augmentation module. At `q=23` the analogous
  canonical candidate, the heart `H = A24/<1>`, instead **splits** as `S (+) S^*` (evidence: an
  equivariant retraction `H -> S` exists, `End_G(H) = 2`), while the unique nonsplit extension of
  `S^*` by `S` is nonetheless certified to exist (global `dim Ext^1(S^*,S) = 1`). So that extension
  is real but is not realised by any canonical permutation-module construction found here; its
  natural home is unidentified. This does not block the SPLIT verdict. Owning successor: the
  unallocated `q=31` binary rung and the `M23`-route probe (routes 2 and 4 of the alternative
  attacks), where the same question -- which module carries the certified class -- recurs. Not
  allocated here.

## What is and is not certified

Certified (exact, deterministic, no randomness): the `[23,12,7]` flag over `F_2`; the order of
`PSL_2(23)` and its dihedral `D8` Sylow; the non-existence of an index-23 subgroup by exhaustive
overgroup enumeration above a fixed Sylow-2; and, on the extended-Golay module `S`, the submodule
lattices, commutants, `S !~= S^*`, the `D8` norm-rank projectivity of `End_0(S)`, the **direct
global** `dim H^1(PSL_2(23), Hom(S^*,S)) = 1` (with an explicit nonzero cocycle) and
`dim H^1(PSL_2(23), End S) = 0`, and the even-parity heart `A24/<1>` with its splitting
(equivariant retraction exists, `End_G(H) = 2`, `H/S ~= S^*`).

Both gate 3 (existence) and gate 5 (`dim = 1`) are established by the global computation over all
6072 elements, not by a local-to-global inference; the local `D8` cohomology and fusion profile are
recorded as corroborating structure only. The certificate also records the `End(S)` vs `Hom(S^*,S)`
local/global caution: identical local `D8` data, different global Ext (`0` vs `1`).

Not certified: the `[23,12,7]` code as an `M23`-module (route 2, unallocated).

**Trusted checker boundary.** Exact `F_2` linear algebra (bit-integer codewords in the generator,
dense tuple vectors in the replay); complete deterministic enumeration of `PSL_2(23)` from two
generators; the abort-at-264 closure (sound: an order-264 subgroup is reached through its own
smaller subgroups, none aborted); the norm-rank free-module criterion for a 2-group; and the
Cayley-graph `Z^1`/`B^1` rank computation of global group cohomology.

## Reproduce

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c488-qr-ladder-q23-rung.py            # regenerate the certificate
python3 notes/2026-07-22-c488-qr-ladder-q23-rung.py --check    # regenerate in a tempdir, verify hashes
python3 notes/2026-07-22-c488-qr-ladder-q23-rung-replay.py     # independent replay (no shared code)
sha256sum -c notes/2026-07-22-c488-qr-ladder-q23-rung.sha256
```

The generator and the independent replay use disjoint implementations (bit-integer vs dense
tuple-vector linear algebra, and a different Sylow-2 element choice) and agree on every load-bearing
number.

## Hashes

See `notes/2026-07-22-c488-qr-ladder-q23-rung.sha256` for SHA-256 and byte counts of the generator,
the replay, the certificate JSON, and this report.
