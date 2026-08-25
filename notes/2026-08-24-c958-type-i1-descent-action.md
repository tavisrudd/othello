# C958 type-I1 descent action

**Lane:** `cubic-threefolds`

## Result

The type-`I_1` Galois action in Tschinkel--Zhang Proposition 5.1 has been
placed explicitly in the marked Cox coordinate system used by C956.  In the
odd-subset model of the sixteen Cox generators, the script enumerates all
1920 elements of `W(D5)` and finds 48 conjugations of the type-`I_1` subgroup
into the type-`I_3` subgroup used by the quotient certificate.  Its
lexicographically first choice is the pure permutation

```text
1 -> 1, 2 -> 2, 3 -> 5, 4 -> 3, 5 -> 4.
```

Pulling the C956 quotient window back through this permutation gives the four
selected blocks

```text
L14,L24,L34       L15,L25,L35
E1,E2,E3          L12,L13,L23
```

and boundary

```text
E4,E5,L45,Q.
```

The order-twelve group acts transitively and freely on the twelve selected
coordinates.  It acts on the four boundary coordinates, and on the four
selected blocks, through a quotient of order four with kernel of order three.
Thus the selected coordinates are the regular `G`-set and the boundary and
block sets are `G/C3`.

This identifies the underlying permutation descent datum.  If `L/K` is the
degree-twelve splitting extension and `M=L^C3`, then after the scalar cocycle
of the Cox generators has been normalized, the affine Cox coordinate module
has the compact descended form

```text
Res_{L/K}(A1) + Res_{M/K}(A1).
```

The last sentence is a strategy statement, not yet a certified normalization:
the present computation determines the permutations but does not construct a
rational universal-torsor point or remove the semilinear scalar factors.

## Method and provenance

An element `(p,F)` of `W(D5)=C2^4 semidirect S5` sends an odd subset `I` of
`{1,...,5}` to `p(I) symmetric-difference F`.  The five singleton subsets,
the ten complementary triples, and the full subset label `E_i`, `L_ij`, and
`Q`.  The program generates the two subgroups from the displayed generators,
checks their orders 12 and 24, tries every Weyl element, and verifies the
coordinate, block, orbit, and stabilizer assertions directly.

The type-`I_1` generators are those in Tschinkel--Zhang Proposition 5.1; the
type-`I_3` marking and quotient blocks are the ones retained in the C956
certificate.  The consulted Tschinkel--Zhang source is cached as
`arXiv:2608.20029`, SHA-256
`be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## Replay and trust boundary

From the repository root:

```text
uv run python3 notes/2026-08-24-c958-type-i1-descent-action.py \
  --check notes/2026-08-24-c958-type-i1-descent-action.json
sha256sum -c notes/2026-08-24-c958-type-i1-descent-action.sha256
```

The script is a self-contained standard-library implementation.  It certifies
the finite Weyl-group calculation and the resulting permutation sets.  It
does not certify scalar normalization of the Cox generators, a ground-field
tangent or orbit-test point, signed-minor formulas over `K`, inverse tangent
elimination, or maps for either cubic product.  There is no independent second
implementation of this finite calculation yet.

Files:

- generator: SHA-256
  `a5719a9afe2465d8135b89d5d7242bb7f695d33030dd47f595806cc768dda8c7`;
- certificate: SHA-256
  `8755c5cf2d3acce3c670558ea3bee26fcad0691301a2e40231b41cf40e87ee25`.

**Vibe:** the type-`I_1` descent is now structurally small; the remaining
difficulty is the semilinear scalar normalization, not the permutation action.

## Next step

For the Proposition 5.1 generic fibre, write

```text
L = K1(e1),        M = L^C3 = K(sqrt(discriminant(c)), e1),
```

where `K1` is the splitting field of
`c(t)=t^3-3a^2 t-beta`.  Construct trace coordinates for the regular `G`-set
and `G/C3`, then normalize the Cox generators at a rational universal-torsor
point so that the finite permutation action above becomes the actual
semilinear descent action.  Descend the four block evaluations before
expanding the tangent hyperplanes.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why do the twelve selected coordinates form one orbit? | settled | the exact stabilizer calculation has order one |
| Why do both the boundary and block actions have four elements? | settled | both have kernel `C3`; the certificate computes the full action image |
| Is the descended affine module really `L + M` without a twist? | open | requires removal of the Cox scalar cocycle using a rational universal-torsor point |
| Can the four block evaluations be written over `M` without radicals? | open, next | construct the trace-coordinate model over the quartic etale algebra `M` |
| Does this already give a parametrization of `X_1 x P2`? | no | tangent descent, inverse graph, contraction, and composite identities remain |
