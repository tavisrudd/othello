# C459 — `Q`-forms of the golden six-arc

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `GREEN — UNIQUE Q(sqrt5)-SPLIT DESCENT CLASS; EXPLICIT S3 FORM; PROPOSED D5 FORM DOES NOT EXIST`

## Result

Let `K=Q(phi)`, `phi^2=phi+1`, and let `S/K` be C458's frozen golden six-arc with its
anisotropic conic and unique polar-pair matching. There is exactly **one** isomorphism class of
`Q`-descent of this decorated object that splits over `K`. Its rational projective stabilizer is
`S3` (order 6). Thus the `S3` form exhibited during the C442 review is not one example among
several quadratic descents: it is the complete `K/Q` answer.

The proposed pentagonal `D5` (dihedral order 10) form does not occur. The exact transporter
enumeration gives no second `K/Q` class, and there is also a characteristic-zero structural
obstruction to a `D5`-rational form of this geometric object: a Galois action on the geometric
`A5` fixing `D5` pointwise would be trivial, because the centralizer of a natural `D5` in
`Aut(A5)=S5` is trivial. That would make the full `A5` rational, impossible for this projective
three-dimensional icosahedral representation (its two degree-three characters have field
`Q(sqrt5)`).

The descent boundary is sharp:

- the unordered six-point configuration descends as a degree-six `Q`-subscheme;
- the anisotropic conic descends;
- its unordered six polar-pair divisors (the matching decoration) descend;
- only the fixed `S3` part of the geometric `A5` action is rational;
- the golden labeling does **not** descend: choosing `S` rather than `sigma(S)` is equivalently
  choosing a prime above 11 and hence one of C458's two reduced singleton sheets.

This pins C417's impossibility boundary to the labeling/section, not the underlying decorated
configuration. C467's quantum equivalences are downstream and play no role in this geometric
descent proof.

## Explicit cocycle and Hilbert 90

Write `sigma(phi)=1-phi`. In C458's sum-of-squares coordinates, the following rational projective
matrix maps `sigma(S)` to `S` and satisfies the exact (not merely projective) cocycle equation:

```text
u = [ 0  0  1 ]                 u sigma(u) = I.
    [ 0 -1  0 ]
    [ 1  0  0 ]
```

A constructive Hilbert-90 witness is

```text
h = [   phi       0  1 ]
    [     0   sqrt5  0 ]       h = u sigma(h),
    [ 1-phi       0  1 ]       u = h sigma(h)^(-1).
```

Putting `Y=h^(-1)S` gives the following Galois-stable sextuple (coordinates are pairs under
`sigma`, not six individually rational points):

```text
[1, phi-1, phi-1]       [1, -phi, -phi]
[1, 0, -4+2phi]         [1, 0, -2-2phi]
[1, phi, -phi]          [1, 1-phi, phi-1].
```

The descended conic has rational Gram matrix

```text
G = h^T h = [ 3  0  1 ]
              [ 0  5  0 ]
              [ 1  0  2 ].
```

For each `y in Y`, the line `(Gy)^T z=0` cuts the conic in its polar pair. The six such lines form
a Galois-stable set, giving the descended matching without choosing or labeling a golden sheet.
All six points and all six polar lines, in canonical `Q(phi)` pair encoding, are in the JSON
certificate.

Two rational matrices generating the stabilizer are

```text
s = [ 1 -1/2  1/2 ]      r = [ 1 -1/2  1/2 ]
    [ 0  1/2  1/2 ]          [ 0 -1/2 -1/2 ]
    [ 0  3/2 -1/2 ],         [ 0  3/2 -1/2 ],

s^2=r^3=(sr)^2=1.
```

The full rational stabilizer has element-order multiset `1,2,2,2,3,3`, hence is `S3`.
It fixes the rational point `[1:0:0]`; its polar under `G` is the rational line `3x+z=0`.
Thus the descended `S3` representation is visibly `1+2`, and the form carries a canonical rational
pole--polar flag even though none of its six arc points is individually rational.

## Completeness certificate

C442 proves that the decorated geometric stabilizer is exactly `A5`, of order 60. Once the one
transporter `u` is fixed, every transporter `sigma(S)->S` is therefore uniquely `a u` with
`a in A5`. The primary checker reconstructs all 60 and imposes

```text
(a u) sigma(a u) = 1 in PGL3(K).
```

Exactly 10 projective transporters satisfy the cocycle condition. It then applies the full gauge
action

```text
u' = a u sigma(a)^(-1),        a in A5,
```

and obtains one orbit, of size 10. Its stabilizer has order `60/10=6` and is the rational `S3`
displayed above. This is exhaustive over the exact 60-element transporter torsor, not a sampled
search. The certificate records all ten normalized cocycle matrices and their raw cocycle scalars.

The independent replay uses a separate `Q(phi)` implementation, rebuilds the 15 reflection axes,
the order-60 projective group, the six-arc, all transporters and gauge orbits, and independently
recovers the Hilbert-90 representative, rational Gram matrix, polar matching, and `S3` order
distribution.

## Free conceptual upgrade: why `10 -> 1 -> S3`

The exhaustive counts have a uniform nonabelian-cohomology proof. Identify
`Aut(A5)=S5`; the Galois action on the geometric `A5` is the outer involution
`tau(a)=t a t^(-1)` for a transposition `t`. A cocycle `a in A5` obeys

```text
a tau(a)=1  iff  (a t)^2=1.
```

But `a t` is odd, and the only odd involutions in `S5` are its ten transpositions. Gauge
equivalence becomes conjugacy by `A5`, which is transitive on those ten transpositions. Hence
`H^1(<sigma>,A5_tau)` has one point, while the fixed group is
`C_A5(t) ~= S3`, of order 6. This explains, without coordinate enumeration, all three certificate
numbers: ten cocycles, one form, and rational stabilizer `S3`.

It also explains why the tempting pentagonal `D5` guess points in the wrong direction. Quadratic
descent selects an **edge of the five-letter model** (a transposition), not a five-cycle or its
normalizer. The ten raw cocycles are canonically the ten edges of `K5`; the descent class forgets
which edge was used.

## Second-order upgrade: the quadratic `A5` taxonomy and an Eisenstein shadow

The same two-line calculation classifies every quadratic Galois-action type on an `A5`-object:

| action on geometric `A5` | cocycle orbits | rational fixed groups |
|:--|:--|:--|
| inner (equivalently, after twisting, trivial) | `1 + 15` | `A5`, `V4` |
| outer | `10` | `S3` |

For the trivial action, cocycles are the identity and the single conjugacy class of 15 double
transpositions; their centralizers have orders 60 and 4. For the outer action, the preceding
transposition argument gives the unique class with centralizer order 6. Thus the complete list of
rational automorphism groups for a quadratic-split `A5` form is

```text
A5, V4, S3.
```

In particular `D5` is not merely absent from this coordinate search: it is absent from the entire
quadratic `A5` taxonomy. The geometric automorphism group of the C459 object does descend over
`Q`, but as the outer-twisted finite `A5` group, not the constant group; its `Q`-rational points are
exactly `S3`. This is the clean group-action version of “the full golden `A5` does not descend.”

There is also an unexpected arithmetic residue. The canonical `S3`-fixed pole is `[1:0:0]`, and
its polar line is `3x+z=0`. Restricting the descended conic to that line gives

```text
5(y^2+3x^2)=0.
```

Hence its two conic points live over `Q(sqrt(-3))`; they are the eigenpoint pair of the unique
normal `C3` in `S3`. The golden quadratic descent therefore leaves a canonical **Eisenstein**
pair on the rational form. This is a concrete candidate bridge to the programme's cubic/`mu_3`
layer, but no identification with C417's cubic moment is certified here; Phase 3 may test that
comparison without reopening C459.

## Third-order upgrade: the rational `S3` resolvent recovers the golden bit

The six geometric points of the descended arc form three Galois-conjugate pairs. Their three
secants are rational and, in the frozen descended coordinates, are exactly

```text
y-z=0,       y=0,       y+z=0.
```

All three concur at the canonical `S3`-fixed pole `[1:0:0]`. The rational `S3` acts as the full
permutation group on these three degree-two closed points (and on their three concurrent secants).
On geometric points it has two orbits of size three, exchanged by `sigma`; equivalently, the
degree-six étale algebra is

```text
K x K x K,       K=Q(sqrt5),
```

with `S3` permuting the three factors. Taking invariants therefore gives

```text
(K x K x K)^S3 = K,
```

so the quotient of the rational six-arc by its rational `S3` is canonically `Spec K`. It has no
`Q`-point and hence no rational section.

This sharpens the descent boundary again: the golden two-sheet object is not discarded by Hilbert
90. It is intrinsically recoverable from the descended configuration-with-action as its `S3`
quotient; what fails is exactly a rational **choice of one sheet**. The result gives a concrete
finite resolvent model of C417's section obstruction, without invoking a moduli stack. The
three-line concurrent pencil is also a natural candidate geometric avatar of C444's rational
`S3` seam, but that coordinate comparison remains for Phase 3 and is not asserted here.

## Scope and boundary

The completeness statement is for forms of the frozen decorated six-arc split by the specified
quadratic field `K/Q`, exactly the descent problem posed by the golden conjugation. It is not a
classification of the unrestricted nonabelian set `H^1(Q,Aut(S_Qbar))` over every possible
splitting field, and it constructs no broad moduli or stack. The separate `D5` impossibility is
global for a `Q`-form of this geometric decorated object, by the pointwise-centralizer argument
above.

No novelty or priority claim is made. The inputs are C442's exact stabilizer/descent frame,
C458's frozen decorated object, C379's six-arc formulas, and C417's labeling obstruction boundary.
The computation certifies the bounded classification and representatives; the standard facts
`Aut(A5)=S5`, the centralizer of the natural `D5` in `S5`, and the character field of the
icosahedral degree-three representations are the trusted group-theoretic boundary.

## Reproducibility

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c459-golden-six-arc-q-forms.py --check
python3 notes/2026-07-21-c459-golden-six-arc-q-forms-replay.py
sha256sum -c notes/2026-07-21-c459-golden-six-arc-q-forms.sha256
```

Intentional regeneration is the primary command with `--write`. Outputs are deterministic,
timestamp-free, and canonically sorted. The primary hash-verifies its load-bearing C442 Python
input against C442's committed manifest; C442 in turn hash-pins the frozen C379/C399/C406 inputs.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary generator/checker `.py` | 17,523 | `7a06bce791c6f94cd6eff0f105c8f6a55842ece680b48fef780a16e5a6c409da` |
| independent replay `.py` | 7,667 | `75fba5f9211326bb8872e93df026028f7a9115e7e61c8a08b28e42f361738ba0` |
| canonical certificate `.json` | 16,791 | `9d8f7fbbd7642acf274700e3891a8006f0277a91cfdc9b26cae64c9c94f1225d` |

Trusted computational boundary: exact rational arithmetic in the pair model
`Q(phi)=Q[phi]/(phi^2-phi-1)`, exact projective normalization, and exhaustive finite closure of the
60-element stabilizer. No floating point, randomness, external CAS, or recalled coordinate data is
used.
