# C492 — conceptual six-stratum proof and based Ω-level re-foundation

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `CERTIFIED — c=6 IS A TWO-SHEET DOUBLE-COSET THEOREM; THE SIX-LEVEL IS
BASED-GROUPOID FUNCTORIAL, NOT AN UNBASED G-QUOTIENT; B3/H3 EXHAUST THE C434
FINITE-GEOMETRY REALIZATION CLASS`

This report certifies the hand derivation left by C434. It makes no novelty or priority claim.

## The abstract two-sheet theorem

Let `Γ ◁ G` have index two, let `Ω = G/H` with `H ≤ Γ`, and base the action at
`x = H`. The two `Γ`-orbits are the sheets `Ω+` and `Ω-`. Assume the following
based two-sheet data.

1. As an `H`-set,
   `Ω+ = {x} ⊔ H/S0`, with `H/S0` transitive.
2. As an `H`-set,
   `Ω- = H/Sa ⊔ H/Sb`.
3. Both opposite-sheet actions are 2-transitive:
   `#Si\H/Si = 2` for `i ∈ {a,b}`.
4. The two opposite-sheet stabilizers are transverse:
   `H = Sa Sb`, equivalently `#Sa\H/Sb = #Sb\H/Sa = 1`.

Call `(x,y)` a golden pair when `y ∈ Ω-` and the pair is swappable: there
exists an outer element `j` with `jx=y` and `jy=x` (the C434 realization
supplies an outer involution). Then

```text
K = Stab_G(x) ∩ Stab_G(y) = H_y
```

is conjugate in `H` to `Sa` or `Sb`. It has exactly three orbits on each
sheet and hence

```text
#K\Ω = 6.
```

### Proof

Suppose `K = Si` and write `Sj` for the other opposite-sheet stabilizer.
On the opposite sheet,

```text
#K\Ω- = #K\H/K + #K\H/Sj = 2 + 1 = 3.
```

The first term is two because the action on `H/K` is 2-transitive: a point
stabilizer has its fixed point and one orbit on the remaining points. The
second is one because `H = K Sj`. Thus `#K\Ω- = 3`.

Moreover `jKj⁻¹ = K`, because conjugation by a swap exchanges
`Stab_G(x)` and `Stab_G(y)` and therefore preserves their intersection.

Consequently any swap `j` pairs the three `K`-orbits on one sheet with the
three on the other, including their sizes. In particular,

```text
#K\Ω+ = #K\Ω- = 3
```

and, because `x` is the singleton own-sheet orbit,
`#K\H/S0 = 2` follows rather than being an extra axiom. Hence
`#K\Ω = 3 + 3 = 6`. This proves that the earlier
"largest-suborbit avoidance" is only sheet bookkeeping: `jx` lies on
`Ω-`, while the size-`q-1` orbit `H/S0` lies on `Ω+`.

The proof uses only the opposite-sheet double-coset incidence matrix

```text
                 target Sa   target Sb
golden K = Sa         2           1
golden K = Sb         1           2
```

plus swappability. The projective-line 2-transitivity and exact
factorizations are the realization-level explanation of this matrix, not
extra structure needed by the abstract counting lemma.

### Character-theoretic corollary

Let `πi = Ind_Si^H(1)` be the two opposite-component permutation
characters. Mackey's formula identifies their Gram matrix with the
double-coset matrix:

```text
(<πi,πj>) = [[2,1],[1,2]].
```

Transitivity gives `<πi,1>=1`, so `πi=1+χi`; norm `2` forces each `χi` to
be irreducible, and the off-diagonal inner product `1` forces
`<χa,χb>=0`. Thus, in characteristic zero, the two augmentation modules
are distinct irreducibles and the only intertwiner between the two
permutation modules factors through constants. This is the
representation-theoretic content of Borel transversality.

This corollary is deliberately characteristic-zero. Modular reduction can
merge or extend augmentation subquotients, so C439 must test rather than
assume semisimple survival in the radical/Hadamard setting. The full
permutation-module cross-Hom space itself cannot jump; the ej2 pass below
records the exact distinction.

## The four exact small-group tables

The C492 certificate constructs `S4` and `A5` as permutation groups and
checks every double-coset leg directly. Here `S0` is the stabilizer of the
nonbase own-sheet orbit.

| `H` | `S0` | golden `K` | own-sheet orbits | opposite-sheet orbits | legs `(own,same,cross)` |
|:--|:--|:--|:--|:--|:--|
| `S4` | edge `V4` | `D8` | `1,2,4` | `1,2,4` | `2,2,1` |
| `S4` | edge `V4` | `S3` | `1,3,3` | `1,3,3` | `2,2,1` |
| `A5` | `N(C3) ≅ S3` | `A4` | `1,4,6` | `1,4,6` | `2,2,1` |
| `A5` | `N(C3) ≅ S3` | `D10` | `1,5,5` | `1,5,5` | `2,2,1` |

Thus the two possible `K` types are precisely the point stabilizers in the
two opposite-sheet components. The certificate also checks the exact
factorizations

```text
A5 = A4 D10,          S4 = D8 S3.
```

In both factorizations the two factors meet in order `2`. Thus the
transverse leg has a common order-two gluing seam in both exceptional
models, not merely the same double-coset count. More precisely, each cross
cell is `K/C2`; its sizes are `6,5,4,3` in the four rows above.

This is the promised conceptual explanation of the class-independent
count: changing the outer-involution class changes which Borel is `K` and
changes orbit sizes, but it does not change the `2 + 1` double-coset count
on either relevant decomposition.

## Exact Bruhat statement, including the seam

The opposite sheet is the union of two small projective lines:

```text
A5:  P¹(F4) ⊔ P¹(F5),       5 + 6 = 11,
S4:  P¹(F2) ⊔ P¹(F3),       3 + 4 = 7.
```

The stabilizers are the corresponding Borels:

```text
A4 = B(PSL2(4)),       D10 = B(PSL2(5)),
S3 = B(PGL2(3)),       D8 = pullback of B(PGL2(2)).
```

For a golden `K`, the same-type leg is the rank-one Bruhat decomposition
`#B\H/B = 2`; the cross-type leg is one cell by Borel transversality, i.e.
the exact factorization above. Therefore the opposite sheet is exactly
"two Bruhat cells plus one transverse cell."

The own-sheet leg is deliberately not renamed Bruhat. It is the separate
rank-two incidence consequence `#K\H/S0 = 2`, transported from the
opposite sheet by `j`: in `S4`, `H/S0` is the
six-edge action, and in `A5`, `H/S0` is the ten-point action on Sylow
`3`-subgroups. Both candidate Borels have two orbits in the applicable
action, as the exact certificate independently verifies. Thus the minimal
abstract theorem needs only opposite-sheet 2-transitivity, cross-Borel
factorization, and the golden involution. This closes C434's unresolved
Bruhat seam without overstating it or adding an incidence axiom.

## Ω-level foundation and groupoid invariance

The canonical unbased information maps are

```text
Ω  →  {Γ-sheets}  →  {*},
2q →       2       →   1.
```

They are `G`-equivariant. The middle six-level is different: `K` is not
normal in `G`, so `Ω → K\Ω` is not a quotient of `G`-sets and must not be
presented as one.

Define a based golden-pair object to be `(G,Γ,Ω,x,y)` satisfying the
two-sheet axioms above, with `(x,y)` swappable. No swap is included in the
data. A morphism is a group isomorphism together with an equivariant
bijection carrying `(x,y)` to `(x',y')`. It carries

```text
K = Stab(x) ∩ Stab(y)
```

to `K'` and hence induces a canonical bijection `K\Ω ≅ K'\Ω'`, compatible
with the sheet map.

The involution pairing is also pair-canonical. If `s` and `t` both swap
`x` and `y`, then `t⁻¹s` fixes both points and lies in `K`; every swap
normalizes `K`, and its square lies in `K`. Hence all swaps induce the same
involution on `K\Ω`. Equivalently, the set of swaps is a `K`-bitorsor but
its action on the orbit quotient is unambiguous. Therefore

```text
(G,Γ,Ω,x,y) ↦ (K\Ω → Γ\Ω, swap)
```

is a functor on the golden-pair groupoid. Changing the golden pair
conjugates the construction and gives an isomorphic six-set, but after
forgetting the pair there is in general no distinguished six-level. This
is the exact meaning of "portable" for the C434 middle stratum.

There is also an intrinsic sheet readout. The two sheets give the two
`Γ`-conjugacy classes of point stabilizers `H` and `tHt⁻¹`. They are
distinct exactly when `N_G(H)` contains no outer element: equality of the
classes is equivalent to `t⁻¹γ ∈ N_G(H)` for some `γ ∈ Γ`. Hence C434's
`N_G(H)=H` hypothesis makes the sheet bit intrinsic. At `q=5`, an outer
normalizer fuses the two classes; C493 owns that near-miss.

## Completeness of the finite-geometry realization class

For the C434 reflection-parent geometry, `|G/H|=2q` forces

```text
|H| = (q²-1)/2.
```

For `q≥5`, Dickson's subgroup classification reduces the order check to
four families. A Borel has order `q(q-1)/2 < (q²-1)/2`; cyclic and
dihedral candidates have order at most `q+1 < (q²-1)/2`. If
`q=q0^r`, `r≥2`, a proper subfield candidate has order at most
`|PGL2(q0)|=q0(q0²-1)`, and

```text
2q0(q0²-1) < q0^(2r)-1;
```

for `r=2` the difference is `(q0-1)³(q0+1)>0`, and larger `r` only
increases it. Thus none has the required order. The exceptional orders
`12,24,60` leave only

```text
(q,H) = (5,A4), (7,S4), (11,A5).
```

The `q=5` case fails the self-normalizer hypothesis because, under
`PGL2(5) ≅ S5`, its `A4` is normal in an outer `S4`. The C434 certificate
checks the hypotheses and geometric realization at `q=7` and `q=11`.
Thus B3 and H3 are the complete realization class of the C434 theorem.
This does not claim that the abstract two-sheet axioms have no realizations
in other groups.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c492-c434-conceptual-refoundation.py --check
python3 notes/2026-07-22-c492-c434-conceptual-refoundation-replay.py
sha256sum -c notes/2026-07-22-c492-c434-conceptual-refoundation.sha256
```

Intentional regeneration:

```bash
python3 notes/2026-07-22-c492-c434-conceptual-refoundation.py --write
```

The primary checker constructs the four small-group double-coset tables,
all exact factorizations, and every orbit-size list. The independent replay
enumerates double cosets directly with a separate implementation. The
trusted boundary is Python's exact tuple/set arithmetic and the standard
permutation models of `S4` and `A5`. The ambient conic geometry,
outer-involution sweep, and normalizer hypotheses are consumed from C434,
not recomputed here.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker `.py` | 7,673 | `9c46212e0d1ab8ddce7dbbc681ed4a526383dd0a7fb274986734e4cd8061ea95` |
| independent replay `.py` | 3,004 | `333428d4a95d7cb8bf00eb61e74f2caf95a4ea77e42c855ed6498ed1daf6e64f` |
| canonical JSON | 4,430 | `ca0304a2b4e95d51c47da510831565e6e80eaaf66ba00708089eb7304c8017d9` |

Load-bearing C434 inputs:

| input | bytes | SHA-256 |
|:--|--:|:--|
| C434 report | 16,673 | `ec3a0997c883404710ba2d86e29f2cd0848312e2c20bdbbbad84c923a74b6243` |
| C434 canonical JSON | 12,477 | `6d0e0106aa04dfcfe694f74494eaf86743a3254c62c6c1e878000301ec2f0899` |

## Mystery ledger (ej closeout)

Settled:

- The own-sheet `#K\H/S0=2` leg is not a missing Bruhat
  interpretation or an independent axiom. It is forced by the golden
  involution from the opposite-sheet `2+1` count, and is independently
  certified in the six-edge and ten-Sylow-`3` models.
- Equality of the two per-sheet orbit-size lists is forced by
  `jKj⁻¹=K`; it is not an extra numerical coincidence.
- The middle six-set is canonical only over the golden-pair groupoid. The
  unbased `G`-object canonically retains only the `2q → 2 → 1` levels.
- The groupoid needs only the swappable pair `(x,y)`, not a chosen outer
  involution. The swap set is a `K`-bitorsor and induces one canonical
  involution on `K\Ω`.
- The sheet bit itself is the two-class stabilizer torsor and is intrinsic
  exactly under the no-outer-normalizer condition.
- Both cross-type factorizations meet in `C2`; the two exceptional
  projective-line structures share one uniform order-two transverse seam.

No genuine C492 mystery remains. The `q=5` loss of the stabilizer-class
readout and the possible existence of a decorated geometric avatar are the
explicitly allocated C493 question, not residue of this proof.

## Tao stress test (2026-07-23)

The stress test found one genuine over-marking and one presentation
compression, both now repaired:

- A chosen `j` was unnecessary structure. The correct base is a swappable
  golden pair; its entire swap bitorsor induces the same quotient
  involution.
- The abstract theorem is the `[[2,1],[1,2]]` opposite-sheet incidence
  matrix plus swappability. Bruhat theory explains the diagonal `2`s and
  Borel transversality explains the off-diagonal `1`s in B3/H3.

Opportunities now exposed:

- The matrix formulation is the right interface for C439 and any future
  realization: it asks only for four double-coset ranks and a swapping
  transporter, without importing conics or exceptional isomorphisms.
- As a permutation-character Gram matrix, `[[2,1],[1,2]]` proves that the
  two characteristic-zero augmentation modules are distinct irreducibles
  and share only constants. C439 gets a sharp modular-survival pretest.
- The swap `K`-bitorsor cleanly separates two objects that Paper 1 should
  not conflate: the pair-canonical middle partition and the external
  sheet torsor. This gives a sharper "one torsor, one swap" formulation.
- The cross cells are homogeneous spaces `K/C2`; any reconstruction
  theorem can seek its missing decoration as a point of this local
  homogeneous space rather than as an arbitrary `K`-coset label.

No new task is needed for the first two: they are theorem-interface and
exposition upgrades landed here. Exploiting `K/C2` to shrink the
reconstruction decoration is a real successor only if C439's application
sweep finds a consumer; it should not be allocated speculatively.

## Second-order extra juice (2026-07-23)

The modular boundary is sharper than the Tao paragraph initially stated.
For any field `k`,

```text
dim_k Hom_{kH}(k[H/Si], k[H/Sj]) = #Si\H/Sj.
```

This is orbit-basis linear algebra, not semisimplicity. Hence the
off-diagonal Hom space remains one-dimensional in every characteristic;
it cannot acquire an extra cross-intertwiner after reduction.

Write `Pi=k[H/Si]`, let `εi:Pi→k` be coordinate sum, and
`ηi:k→Pi` send `1` to the all-ones vector. The unique cross map, up to
scalar, is

```text
Tji = ηj εi.
```

It annihilates the augmentation kernel `Ai=ker εi` in every
characteristic. Therefore any modular map between augmentation
subquotients must be non-liftable to `Pi→Pj`; this is the exact place where
extension data, rather than a new double coset, can enter.

Set `Ei=ηi εi` and write `ni=|H/Si|`. The unique maps form an integral
rank-one Morita context with relations

```text
Ei² = ni Ei,
Tij Tji = nj Ei,
Tji Tij = ni Ej.
```

The elementary degeneration is therefore completely explicit:

```text
εi ηi = |H/Si|,
```

so the constant line lies inside `Ai` exactly when the characteristic
divides the component degree. The bad-prime ledger is consequently

| realization | opposite degrees | possible nonsemisimple incidence primes |
|:--|:--|:--|
| B3 / `S4` | `3,4` | `2,3` |
| H3 / `A5` | `5,6` | `2,3,5` |

The two degrees in each row are consecutive and hence coprime. At every
bad prime exactly one `Ei` becomes square-zero and exactly one of the two
cross compositions vanishes; the other remains a nonzero multiple of the
nilpotent `Ei`. Thus every incidence degeneration is one-sided. This is
an oriented extension diagnostic, not merely a bad-prime list.

The native characteristics `7` and `11` divide neither `|H|` nor the
component degrees. Maschke therefore applies, and the
characteristic-zero decomposition `Pi=1⊕χi` survives unchanged in the
actual B3/H3 fields. C439 need investigate this interface only when it
reduces the small-group permutation modules at `2,3,5`, or when its
carrier is not one of these permutation modules.

The `K/C2` observation also closes more sharply: it is not merely a
candidate compression. It is the optimal homogeneous decoration on each
cross cell, because `C2` is exactly its point stabilizer. Further
compression would identify distinct points unless an application supplies
an additional quotient invariant.

No new mystery or successor remains in C492. The only live opportunity is
the already allocated C439 test of whether its modular carriers realize a
non-liftable augmentation-subquotient map with the predicted one-sided
orientation at one of the small bad primes.

## Third-order extra juice (2026-07-23)

The one-sided special fibre has a canonical extension-theoretic meaning.
For any transitive finite `H`-set `X`, put `P=k[X]`, `A=ker ε`, and
`n=|X|`. The augmentation sequence

```text
0 → A → P --ε→ k → 0
```

splits as a `kH`-module exactly when `n` is invertible in `k`. Indeed, an
`H`-fixed preimage of `1` must be `c·1_X`, whose augmentation is `cn`.
Thus when `char(k)` divides `n`, the constant line
`L=k·1_X` lies inside `A` and the displayed sequence is canonically
nonsplit.

Apply this to the two opposite components. Their degrees are coprime, so
at every bad prime exactly one augmentation sequence is nonsplit and the
other splits. If `p|ni` and `p∤nj`, then

```text
Li = im(ηi) ⊂ Ai,
Tij : Pj ↠ Li,
Tji Tij = 0,
Tij Tji = nj Ei ≠ 0,      (nj Ei)² = 0.
```

Hence the incidence special fibre carries a canonical oriented radical
arrow into `Li` and a nonzero square-zero return composition. This is the
precise one-sided extension carrier suggested by the ej2 Morita-context
relations.

The claim is intentionally bounded: it proves that the permutation
augmentation extension class is nonzero, not that its ambient
`Ext¹_{kH}(k,Ai)` is one-dimensional. That dimension, and any
identification with C439's radical/Hadamard carrier, remain application
gates. A match would require:

1. the same bad prime and affected component;
2. an identification of C439's radical line with `Li`;
3. agreement of the oriented cross map with `Tij`; and
4. non-liftability through the full permutation module.

This is a cheap four-part falsifier for C439. Failure at any line kills the
bridge without a module census. No separate successor should be
allocated; C439 already owns the only possible consumption.

### Prime arithmetic of the special fibre

In both C434 realizations the two opposite-component degrees are

```text
n- = (q-1)/2,       n+ = (q+1)/2.
```

Consequently

```text
gcd(n-,n+) = 1,
n- n+ = (q²-1)/4 = |H|/2.
```

These identities explain three features that previously looked
case-specific.

First, the common cross stabilizer is forced:

```text
|Sa ∩ Sb| = |H|/(n- n+) = 2.
```

Thus the `C2` seam is exactly the factor missing between the product of
the two orbit degrees and `|H|`; it is not an exceptional-group
coincidence.

Second, the bad primes are precisely

```text
Bad(q) = {ℓ : ℓ | (q²-1)/4}
       = {prime divisors of |H|}.
```

Every bad prime divides exactly one component degree. For odd `ℓ`, its
orientation is cyclotomic:

```text
ℓ | n-  iff q ≡  1 (mod 2ℓ),
ℓ | n+  iff q ≡ -1 (mod 2ℓ).
```

For `ℓ=2`, the lower component is affected when `q≡1 (mod 4)` and the
upper when `q≡3 (mod 4)`. The defining characteristic `p|q` is never bad,
since `gcd(q,q²-1)=1`; native semisimplicity is therefore automatic for
any realization with `|H|=(q²-1)/2`, not an accident special to `7` and
`11`.

Third, the integral thickness is measured exactly by

```text
vℓ(n-) = vℓ(q-1) - [ℓ=2],
vℓ(n+) = vℓ(q+1) - [ℓ=2].
```

| `q` | `n-` | `n+` | oriented prime powers |
|--:|--:|--:|:--|
| `7` | `3` | `4` | `3¹` lower; `2²` upper |
| `11` | `5` | `6` | `5¹` lower; `2¹·3¹` upper |

The q=7 upper component is therefore the only certified case with
higher-than-first-order bad-prime thickness (`v2=2`). A mod-2 comparison
cannot see that distinction; an integral or mod-4 carrier comparison can.
This is a concrete caution for C439, not a reason to start an independent
2-adic task.

Numerically, `n-` and `n+` are also the split and nonsplit maximal-torus
orders in `PSL2(q)`. C492 proves the arithmetic equality only. It does not
claim a canonical geometric map from the two `H`-components to ambient
torus classes; such a claim would need an equivariant construction and an
actual downstream consumer.

### Reusable proof mechanism: the Mackey–swap row-sum lemma

The C492 argument does not fundamentally require two opposite components.
Let

```text
Ω- = ⨆_{j=1}^t H/Sj
```

and define the Mackey matrix

```text
Mij = #Si\H/Sj.
```

If a golden point lies in component `i`, its point stabilizer is conjugate
to `Si`. Therefore the number of its stabilizer's orbits on `Ω-` is the
`i`th row sum:

```text
#Si\Ω- = Σj Mij.
```

If the golden pair is swappable, the same number occurs on `Ω+`, so

```text
#Si\Ω = 2 Σj Mij.
```

This is the **Mackey–swap row-sum lemma**. Type-independent stratum count
is equivalent to constant row sums of `M`; no exceptional-group
interpretation is needed for that conclusion.

C492 is the smallest nontrivial instance:

```text
M = [[2,1],[1,2]],       row sum = 3,       c = 2·3 = 6.
```

More generally, `t` pairwise transverse 2-transitive actions give
`M=I_t+J_t`, row sum `t+1`, and `c=2(t+1)`. In characteristic zero their
permutation characters are `1+χi` with the `χi` pairwise orthogonal
irreducibles. Over arbitrary fields, the matrix still gives the exact
full permutation-module Hom ranks; the component-degree vector controls
which augmentation extensions become nonsplit.

This yields a portable proof workflow:

1. identify the opposite-sheet `H`-orbits and stabilizers;
2. compute one bounded Mackey matrix, or only its relevant row sums;
3. prove existence of a pair swap and double the row count;
4. only then seek an intrinsic statistic realizing the orbit fibres; and
5. treat homogeneous-space decoration and reconstruction separately.

The separation in steps 4–5 is load-bearing. The row-sum lemma proves the
number of strata, but it does not manufacture C434's shared-edge profile
or its inversion theorem.

Concrete hand-backs:

- **C493:** normalizer-class fusion can destroy the intrinsic sheet
  readout without changing the abstract Mackey row sum. If a q=5 avatar
  exists, test swappability and `M` separately from geometric decoration.
- **C439:** use the field-independent Hom ranks, affected-component prime,
  nonsplit augmentation class, and arrow orientation as successive
  falsifiers before any module census.
- **C433:** characteristic `11` is native and semisimple for the
  `A5` incidence modules of degrees `5,6`. Its `1|9|1` socle must therefore
  be constructed in the ambient `PSL2(11)` block; restriction to `A5`
  should match the semisimple Mackey interface, not a nonsplit
  augmentation model.
- **C386:** evaluate the orthogonal intersection code on the existing six
  H3 `K`-strata first. Equality with `(sheet,D')` triggers its
  already-stated renaming stop; a strict split identifies exactly the new
  orthogonal information. Cross-cell reconstruction uses `K/C2`.
- **C494:** the Lean core can be three generic finite-action lemmas
  (row-sum orbit count, swap-induced orbit equivalence, augmentation
  splitting iff degree is invertible), leaving the four small-group
  entries as finite certificates.

Future crown searches can use constant Mackey row sum as a cheap
mechanism-level pretest. A large orbit census without a swap or without an
intrinsic fibre statistic still does not qualify.

No genuine C492 mystery remains after ej3. What remains unknown is not a
feature of the six-stratum theorem, but whether an already allocated
external carrier realizes its canonical nonsplit special fibre.
