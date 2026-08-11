# C904 ordered-pair cover: numerical insufficiency on the sparse cycle

Date: 2026-08-10
Status: exact finite numerical audit; connectedness remains geometric
Scope: restriction of `F x F -> D_+=F+F` to the 16-term relative minimal cycle

## Verdict

The divisor lattice detects one useful odd component but cannot certify that
the ordered-pair double cover is nontrivial on it.

For the sixteen monomials in the sparse expression for `Z_min`, exact
intersection with `[D_+]=3Theta` gives fifteen even degrees and one odd
degree:

`D1 D2 D12 D13 . D_+ = 21`.

Its coefficient in `Z_min` is `-171`, also odd.  The total identity has

`Theta . Z_min=5`, and `D_+ . Z_min=15`,

as required.  Hence any effective signed expansion has at least one
odd-`D_+` contribution.  This is the strongest mod-two fact visible in the
3,060-monomial numerical lattice.

The odd monomial contains no rank-one six-axis divisor.  Its four factors
`D1,D2,D12,D13` are all indefinite (ranks `5,5,5,2` respectively), so it
does not come with a canonical effective Abel--Jacobi subvariety on which
the two sheets could be read off.  The unique numerical target is therefore
also precisely the component for which the existing axis geometry gives no
shortcut.

It does **not** determine whether the pullback of the ordered-pair cover is
connected.  Trivial and nontrivial etale double covers have identical
degree, norm, discriminant, Hilbert-polynomial, and intersection data.  A
connectedness certificate must compute the actual two-torsion class or its
monodromy, not merely Neron--Severi or intersection numbers.

## 1. Exact component degrees

The theta degrees and `D_+` degrees are:

| monomial | coefficient | `Theta` degree | `D_+` degree | mod 2 |
|---|---:|---:|---:|---:|
| `D0 D1^3` | -787 | 0 | 0 | 0 |
| `D0 D1^2 D2` | 3253 | -12 | -36 | 0 |
| `D0 D1^2 D4` | 2167 | 12 | 36 | 0 |
| `D0 D1^2 D6` | -219 | 4 | 12 | 0 |
| `D0 D1^2 D7` | 3095 | -4 | -12 | 0 |
| `D0 D1^2 D12` | 1043 | 4 | 12 | 0 |
| `D0 D1 D2 D3` | 861 | 2 | 6 | 0 |
| `D0 D1 D2 D6` | -2285 | -4 | -12 | 0 |
| `D0 D1 D12 D13` | -749 | -10 | -30 | 0 |
| `D0 D2 D12 D13` | 1245 | 0 | 0 | 0 |
| `D1^3 D2` | -428 | -6 | -18 | 0 |
| `D1^3 D3` | 114 | -18 | -54 | 0 |
| `D1^2 D2 D3` | -599 | -10 | -30 | 0 |
| `D1^2 D2 D5` | -599 | 6 | 18 | 0 |
| `D1 D2 D3 D5` | -1027 | -2 | -6 | 0 |
| `D1 D2 D12 D13` | -171 | 7 | 21 | 1 |

Negative values are expected: most of the chosen divisor classes are
indefinite, so these are signed Chow monomials rather than effective
surfaces with negative cardinalities.  After replacing relative line
bundles by signed differences of effective divisors, the visible irreducible
components change, but the total parity `15 mod 2` remains.

## 2. Why norm and discriminant cannot decide the cover

Let `C` be a smooth component of an intersection with the branch-free open
of `D_+`, and let

`q:C'->C`

be the pulled-back ordered-pair cover.  It is represented by a class
`eta in Pic^0(C)[2]`:

`q_*O_(C') = O_C + eta^(-1)`.

The cover is split exactly when `eta=0`; when `C` is connected, a nonzero
`eta` gives a connected double cover.  But every numerical invariant listed
below forgets `eta`.

1. **Discriminant/branch.**  The cover is etale on the chosen open, so its
   branch divisor and numerical discriminant both have degree zero whether
   or not `eta` vanishes.  The diagonal locus has codimension two inside
   `D_+`; a general relative intersection curve avoids it.
2. **Norm.**  `eta^2=O_C`, and `c_1(eta)=0` numerically.  For any divisor
   `L` on `C`, one has `deg(q^*L)=2deg(L)` and
   `Nm(q^*L)=L^2` in both the split and connected cases.
3. **Fundamental class and intersections.**  `q_*[C']=2[C]`; every
   intersection number pulled back from `C` doubles.  Modulo two they all
   vanish.
4. **Euler characteristic.**  Since a nontrivial degree-zero two-torsion
   line bundle has the same Chern character as `O_C`, both cases satisfy
   `chi(O_(C'))=2chi(O_C)`.  Even the arithmetic genus/Hilbert polynomial
   does not distinguish them.
5. **Odd base intersection.**  The degree 21 above proves only that the base
   multisection is odd.  The split cover has two degree-21 components; the
   connected cover has one degree-42 component.  Both have total degree 42
   and identical numerical pushforward.

Connectedness is detected instead by

`h^0(C,q_*O_(C'))=2` in the split case and `1` in the connected case,

or equivalently by the nonzero class
`eta in H^1(C,Z/2)`.  This is Picard/monodromy data, not numerical divisor
data.

The insufficiency is formal: on any positive-genus curve, the split cover
`C disjoint-union C` and the connected cover associated with any nonzero
`eta in Pic^0(C)[2]` give two covers with identical values for every
numerical invariant above.  Therefore no algorithm whose input is only the
Neron--Severi lattice, divisor products, degrees, norms of pulled divisors,
and discriminant divisor can certify nontriviality.

If “norm/discriminant” is retained as an actual Picard-valued invariant
rather than reduced to its numerical class, it does decide the question:
`det(q_*O_(C'))=eta^(-1)`.  Computing that two-torsion line is exactly the
missing Picard/monodromy calculation.  The insufficiency theorem concerns
the presently available lattice/numerical shadow of this line, which is
always zero.

## 3. What would certify nontriviality

Any successful finite-component test must add at least one genuinely
non-numerical input:

1. compute the restriction of the ordered-pair class
   `eta_D in H^1(D_+^sm,Z/2)` to the normalization of the degree-21
   component;
2. exhibit a loop on that component whose two ordered lifts are exchanged;
3. specialize to a controlled boundary where the two sheets can be tracked
   and prove the resulting monodromy persists;
4. prove a Lefschetz theorem making the component's fundamental group
   surject onto that of `D_+^sm` (this needs an actual sufficiently ample
   effective component, not the present indefinite virtual monomial);
5. compute `h^0(eta|C)` or an equivalent theta-characteristic invariant.

The degree-21 monomial is the unique first target, but its oddness alone is
not the desired certificate.

## 4. Relative-rigidification correction

The fifteen Neron--Severi line bundles used by the sparse identity already
rigidify uniquely over the smooth exotic marked base by Gate V.  Residual
mod-two monodromy is `C3`, has no fixed vectors on `J[2]`, and kills the
torsor obstruction for symmetric representatives; the affine base has
trivial Brauer group.  Thus `Z_min` is already a relative signed Chow cycle.

The remaining problem is not descent of those line bundles.  It is choosing
and analyzing effective signed representatives well enough to compute the
ordered-pair two-torsion class on their intersection curves.

## 5. Replay

```sh
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-ordered-pair-numerical-replay.py
```

The replay reconstructs the fifteen integral divisor forms and all 3,060
monomials using the independent Python/SymPy implementation, computes all
sixteen theta and `D_+` degrees, and verifies the weighted totals.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-ordered-pair-numerical-replay.py` | 2,740 | `46083fc98bd800b3ca5202b66a28edb78d758c718c51a6ec52c2a86ca0662881` |
| `notes/2026-08-10-c904-ordered-pair-numerical-replay.out` | 1,424 | `703affa44ffeab2f3eadd398962fc6610afabda4e009480141c6b4660a0adead` |

## Mystery ledger

- **Settled:** exactly one of the sixteen virtual monomials has odd
  `D_+` degree, namely `D1 D2 D12 D13`, of degree 21.
- **Settled:** norm, discriminant, degree, Euler characteristic, and all
  pulled-back intersection numbers are incapable of detecting whether the
  restricted etale double cover is split.
- **Settled:** all fifteen line bundles already rigidify relatively on the
  exotic marked base.
- **Open:** the actual restriction of the ordered-pair class to the
  degree-21 component, requiring monodromy/Picard rather than numerical data.
