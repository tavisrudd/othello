# C412 — modular relative-cubic quotient and depth-plane boundary

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `POSITIVE CANONICAL TATE QUOTIENT; POSITIVE BRAUER-TREE DEPTH QUOTIENT; BOUNDED NEGATIVE FOR THEIR IDENTIFICATION`

## Executive conclusion

The reopened modular attack finds a canonical rank-two quotient that the first C412 phase could
not see.  Put `G=PGL_2(11)` and `M=Sym^3(W) tensor chi`, where `chi` is the outer sign.  Then the
three-dimensional relative-cubic space is `R=M^G`, and the full coinvariant space `M_G` also has
dimension three.  The canonical projection and characteristic-11 group norm form the exact rank pattern

```text
R  --pi-->  M_G  --N-->  R,
rank pi = 2,        rank N = 1,
im pi = ker N,      im N = ker pi.
```

In the frozen relative basis, `ker pi=[1:3:9]`.  It is intrinsic twice over: among all 133
relative-cubic lines it is the unique line of first-flattening rank 9, while the census is
`1 line of rank 1, 1 of rank 9, 131 of rank 10`.  It is not the signed moment line `[1:1:8]`.
Thus `im pi=ker N` is a canonical two-dimensional Tate plane.

There is an independent classical covariant realizing the same quotient.  The full-group
invariant symmetric bilinear-form pencil on `W` has a unique rank-one member, factoring as the
square of an outer-odd covector.  Contracting a relative cubic with that covector gives

```text
R -> (Sym^2 W)^G,       matrix [[8,1,0],[0,8,1]],
```

of rank two with the same kernel `[1:3:9]`.  The target pencil has determinant
`6(b-9a)^9(b-3a)`: its unique rank-one and rank-nine lines are the images of the unique rank-one
source cubic `[1:9:4]` and the signed moment, respectively.

The missing final identification with C411's depth plane still does not follow.  The three
canonical `J`-difference cube sums for the `A4` orbit sizes `1,4,6` span two dimensions, and their
Tate norms recover the orbit weights exactly as `[1,4,6]`; nevertheless their sole source relation
is `[2,9,1]`, whereas the depth profiles obey `[2,8,1]`.  The other two elementary odd cubic
polarizations give relation `[9,10,1]` or span all three coinvariants.  They therefore cannot send
the three labelled orbit classes to the three labelled depth profiles.

The cyclic-defect structure does explain the target rank drop independently.  An 11-point sheet is
the projective permutation cover `P(1)` with Loewy layers `1|9|1`; the depth plane is
`P(1)^A4` modulo its socle.  The full mixed-Hecke kernel is the even three-space plus that odd
socle.  However the canonical divided transfer `B`, satisfying `B^2=11B`, vanishes on all three
balanced integral source relations and fixes the depth socle after division by 11.  Brauer-tree and
Bockstein structure therefore name and separate the two planes, but do not identify them.

Nor does the nonlinear rank flag close the gap.  Matching the ordered rank-one/rank-nine source
flag to the doubled/residual target flag leaves exactly `10` projective (`100` linear)
identifications.  All correctly paired invariant-form correlations have rank at most one; the
canonical rank-nine pairing vanishes for all 22 affine base choices.  The earlier apparent rank-two
correlation was a tensor-coordinate artifact caused by omitting the `1,3,6` symmetric-tensor
multiplicities and is explicitly rejected.

So the strengthened result is positive about the source: C412 now owns a canonical modular
two-plane and two equivalent constructions of it.  It remains a bounded negative about a natural
map to the particular depth plane.  The original common-symmetry and non-descent obstructions also
remain valid.

## The modular Tate plane

For the twisted ambient module `M`, the commutator submodule `[M,G]` has dimension `217`, so
`dim M_G=3`.  The invariant space `R` also has dimension three, but its intersection with the
commutator submodule is the line `[1:3:9]`.  Consequently the invariant-to-coinvariant projection
has rank two.

The checker sums first over the index-two subgroup `PSL_2(11)`; its image is outer-even in the
twisted module, so the full `G`-norm is exactly twice that matrix and has the same kernel and image.
It gives a rank-one map `N:M_G -> R`.  Exact matrix
multiplication verifies `N pi=0`; row reduction verifies both equalities

```text
im pi = ker N,              im N = ker pi = <[1:3:9]>.
```

This is stronger than merely choosing the quotient `R/ker pi`: it places that quotient canonically
as the Tate kernel inside the coinvariants.  In Tate terminology, `ker N` is the degree `-1` plane,
and `R/im N` is the degree-zero plane; `pi` identifies them in this module.

The `A4` double-coset test exposes both the promise and the boundary.  For a positive-sheet
matching `M`, form `delta_M=Phi_M-Phi_(JM)`, sum `delta_M^3` over each positive `A4` orbit, and pass
to coinvariants.  In orbit-size order `1,4,6`, the three classes have rank two and relation

```text
2 q_1 + 9 q_4 + q_6 = 0.
```

Their norm images all lie on `[1:3:9]`, with relative scalars exactly `1,4,6`.  Thus transfer really
does recover the orbit multiplicities, but the depth vectors instead satisfy
`2v_1+8v_4+v_6=0`.  Since the source and target relation lines differ, no label-preserving linear
map sends these canonical classes to the profiles.  Replacing `delta^3` by
`delta odot sigma^2` changes the relation to `[9,10,1]`; cubing the orbit sum has rank three.

## Brauer-tree meaning of the depth rank drop

Fable's general review pointed out the cyclic-defect structure that the first reopened pass had not
named.  On either 11-point `PSL_2(11)` sheet, the permutation module is

```text
Ind_(A5)^PSL 1.
```

The stabilizer has order 60, prime to 11, so this module is projective.  The action is 2-transitive,
and its endomorphism algebra is generated by the identity and all-ones operator `J_11`.  In
characteristic 11, `J_11^2=11J_11=0`, so that algebra is local and the permutation module is
indecomposable: it is the projective cover `P(1)`.  The defining-characteristic Brauer tree gives
Loewy dimensions

```text
1 | 9 | 1,
```

with middle simple `L(8)=Sym^8(F_11^2)`.  The exact geometry independently sees the same layers:
each sheet has affine rank nine, unique all-ones affine dependency, zero vector sum, and the two
sheet-difference spaces are the same nine-dimensional heart.

The positive-sheet `A4` orbits have sizes `1,4,6`, so `P(1)^A4` has dimension three.  In the
orbit-sum basis, the sheet socle is `[1,1,1]`.  The integral depth map on this slice has rank two and
kernel exactly that line.  Thus the profile plane has the named modular description

```text
P ~= P(1)^A4 / soc(P(1)),
```

with the paired negative sheet attaching the outer sign.  On the full six-dimensional mixed
bi-Hecke space, the kernel is the three-dimensional even half plus this one-dimensional odd
socle.  This gives a Brauer-tree second proof of C411's `6 -> 2` rank drop and a modular meaning for
the depth trade.

It does not yet identify `P` with the relative-cubic Tate plane.  The projective cover's ordinary
endomorphisms are `aI+bJ_11` and preserve its socle, so they cannot change the source relation line
into the depth socle line.  Any remaining correction must be derived rather than an ordinary
Brauer-tree endomorphism.

The canonical derived test is also exact.  In the `1,4,6` orbit-sum basis, integral transfer is

```text
B = column(1,1,1) row(1,4,6),             B^2=11B.
```

The three natural rank-two source constructions have balanced integral relation lifts

```text
(-4,1,0),       (2,-2,1),       (-2,-1,1).
```

Each has weighted sum zero over the integers, not merely modulo 11.  Hence transfer and divided
transfer vanish on all three.  The depth socle `s=(1,1,1)` behaves oppositely:
`Bs=11s`, so divided transfer fixes `s`.  The Bockstein therefore distinguishes the source
relations from the depth socle instead of identifying them.  This closes the derived gate.

## The semi-invariant contraction and rank loci

The invariant symmetric-form space on `W` is two-dimensional.  Its pencil has one rank-one member
and one rank-nine member; the other ten projective members have rank ten.  A nonzero row of the
rank-one form is a covector fixed by the three frozen `PSL_2(11)` generators and negated by the
outer element.  Contracting each relative cubic against it lands in the two-dimensional invariant
symmetric-tensor pencil and has matrix

```text
[[8,1,0],
 [0,8,1]].
```

Its kernel is again `[1:3:9]`.  The signed moment maps to pencil line `[1:3]`, the unique rank-nine
member, while the unique flattening-rank-one source cubic `[1:9:4]` maps to `[1:9]`, the unique
rank-one member.  This agreement with the Tate quotient is an exact internal naturality result,
not a fitted source-to-depth matrix.

The determinant of the tensor pencil is

```text
6(b-9a)^9(b-3a).
```

Its ordered singular flag resembles the target cubic's doubled/residual flag, but does not fix a
binary-space isomorphism: exhaustive enumeration leaves ten projective transformations carrying
the ordered source flag to the ordered target flag.  This is the nonlinear rank-locus stop.

## Rejected correlation routes

Correct contraction of symmetric cubic coordinates uses multiplicities `1`, `3`, and `6` for
monomials with three, two, or one distinct indices.  With those factors restored, evaluation
through every invariant nondegenerate form has rank one, and the canonical rank-nine form gives
the zero source-to-depth map for all 22 affine base choices.  Every symmetrization by the target
Hessian/residual weights also remains zero.

The sheet-signed depth quadratic moment is base-independent and has rank two as a map out of the
depth dual, but it does not land in the invariant tensor plane.  Pairing it with that plane through
the full invariant bilinear pencil gives rank at most one.  The unsigned quadratic moment is only
rank one and is base-dependent.  These tests exclude the immediate Radon/incidence and apolar
pairings in the frozen module.

Passing to symmetric-square coinvariants does not rescue this route.  The full and `PSL`-only
coinvariant spaces both have dimension two, and the invariant tensor pencil projects to them with
rank two.  In contrast, both the signed and unsigned depth quadratic moments project with rank one;
the signed map has a three-dimensional kernel rather than the two-dimensional depth-plane
annihilator.

The positive-sheet `PSL` orbital algebra supplies no hidden correction.  The degree-11 action is
2-transitive, so its orbital operators are only the identity and complete off-diagonal adjacency.
On the `A4` orbit-sum basis neither carries the paired-orbit or `J`-difference source relation to
the depth orbit-sum relation; the all-ones component has rank one and annihilates the depth trade.

An invariant third marked point would remove the tenfold projective ambiguity, but the obvious
candidate is unavailable: the affine second-moment form has rank nine yet fails invariance under
all four frozen generators.  The true invariant pencil distinguishes only its rank-one and
rank-nine points; every other projective member has rank ten.  Hasse polarizing its determinant
`(b-9a)^9(b-3a)` can lower the exponent nine to two, but still depends only on those same two
points, so it cannot break their flag stabilizer.

The Brauer-tree identification supplies one derived test for free.  The canonical integral
permutation complex

```text
Z --diagonal--> Z^11 --sum--> Z
```

has composite multiplication by 11; modulo 11 it becomes the heart complex above.  Its divided
composite is therefore a canonical Bockstein, not a coordinatewise Teichmuller lift.  The exact
calculation above shows that it vanishes on the source relations and fixes the depth socle, so it
does not correct `[2,9,1]` to the depth relation.  An affine-cocycle target remains the explicitly
allocated C417 problem.

## The intrinsic target flag

In C411's depth-plane basis `e_1=v_2,e_2=v_3`, the compressed cubic is

```text
f(x,y) = x^3+7x^2y+5xy^2+9y^3 = (x-y)^2(x-2y).
```

With the ordinary unscaled monomial coefficients, its Hessian determinant is

```text
Hess(f) = 7x^2+8xy+7y^2 = 7(x-y)^2.
```

Therefore the divisor of `f` intrinsically consists of a doubled line `L` and a residual simple
line `R_0`, while its Hessian recovers `2L`.  This statement is basis-independent: a change of
basis transports the factorization divisor and Hessian covariantly.  The first catalecticant has
matrix

```text
[[3,3,5],
 [7,10,5]]
```

and rank two over `F_11`.  It is nondegenerate as a first-polar map, but like the Hessian it is an
operator internal to the binary target `P`; it supplies no input leg from `R`.

## The covariance obstruction

The primary checker reconstructs the ten-dimensional H3 quotient module `W`, its 220-dimensional
symmetric cube, and the three-dimensional relative space `R` from the frozen C406 geometry.  On
the computed basis of `R`, each of three `PSL_2(11)` generators acts by `I_3`, and an outer element
acts by `-I_3`.

On the target, scalar `A4` fixes each oriented depth coordinate and `J` negates every profile, so
its matrices are `I_2` and `-I_2`.  For an arbitrary matrix `A in Mat_(2x3)(F_11)`, the only
available square is therefore

```text
R  --A-->  P
|          |
chi(g)I_3  chi(g)I_2
|          |
R  --A-->  P,
```

which commutes for every `A`.  This is covariance without naturality: it imposes zero equations on
the six coefficients of `A`.

The enumeration sharpens that statement.  A rank-two `2 x 3` matrix has one projective kernel
line.  Direct enumeration of all `11^6` matrices gives

```text
# rank-two maps = (11^3-1)(11^3-11) = 1,755,600,
# kernel lines  = 11^2+11+1          = 133,
# maps per line = |GL_2(11)|         = 13,200.
```

The signed sheet moment has projective coordinates `[1:1:8]` in the checker's relative-space basis.
It is geometrically distinguished by C406's signed moment construction, but the common group acts
scalarly on all of `R`; `GL_3(11)=Aut_(A4 semidirect <J>)(R)` is transitive on its 133 lines.  Making
the signed line the kernel is possible in exactly 13,200 ways and is not characterized by the
covariance data.

## Failure of full-group descent

A stronger commutative square would require the depth quotient itself to be equivariant under
`PSL_2(11)`.  Equivariance through a six-element quotient requires the six fibres to form a block
system: two matchings with one profile must always have images with one profile.

The exact counterexample is:

```text
same source fibre:             matching indices 2,16
first PSL generator images:   matching indices 5,19
image fibre labels:           2,5
```

Thus the six-profile quotient does not admit a descended `PSL_2(11)` action.  The profile plane is
a canonical scalar-`A4` depth object, not a `PSL_2(11)` quotient representation.  There is no
full-group covariance square to constrain a map `R -> P`.

## Hessian, apolarity, and the signed line

The classical binary constructions answer the task's candidate tests negatively:

- the Hessian sends a binary cubic to a binary quadratic and recovers the doubled target line;
- the first polar/catalecticant sends a target vector or covector to a target quadratic;
- apolarity pairs binary forms only after both have been placed in compatible binary form spaces.

None of these binary operations alone accepts the ten-variable source tensor.  The modular and
semi-invariant constructions above do supply an antecedent binary source quotient, but matching
its two-line rank flag to the target flag leaves ten projective maps.  Precomposing the target
operations with any one of those choices still assumes the missing bridge.  The target flag is
therefore an exact output-side constraint, not a complete natural identification.

## Reusable propositions and proofs

The following statements are extracted for reuse and formalization.  The first seven are proved by
the C406--C412 bundle.  The final information-lattice paragraph records the proved H3 example while
keeping its proposed general functor explicitly open.

### All-degree antipodal moment formula

**Proposition.**  Over a field of odd characteristic, the degree-`d` symmetric moment of

```text
nu = sum_i n_i (delta_(v_i) - delta_(-v_i))
```

is

```text
M_d(nu) = (1-(-1)^d) sum_i n_i v_i^(symmetric d).
```

Thus every even moment vanishes.  If `sum_i n_i v_i=0`, degree one also vanishes.

**Proof.**  Homogeneity gives
`(-v_i)^(symmetric d)=(-1)^d v_i^(symmetric d)`; substitution and collection give the formula.
For H3, `(n_1,n_2,n_3)=(1,4,6)` and the exact relation `v_1+4v_2+6v_3=0` kills degree one.
Degree two dies by parity, while the first coordinate in degree three is

```text
2((-6)^3+4(-3)^3+6(3)^3) = 6 mod 11,
```

so the cubic is nonzero.  QED.

### Recovery of the orbit weights from the profile rays

**Proposition.**  The three positive integral H3 profiles have the unique primitive rational
dependence `v_1+4v_2+6v_3=0`.  Hence their unlabeled rays recover the orbit-size multiset
`{1,4,6}` and, for `A4`, the stabilizer-order multiset `{12,3,2}`.

**Proof.**  The profiles span a rank-two plane over `Q`, so their relation space is one-dimensional.
Direct substitution gives `(1,4,6)`.  Its positive entries have gcd one, making it the unique
primitive positive generator.  Orbit--stabilizer gives `12/1,12/4,12/6`.  QED.

### Projective-permutation-cover depth quotient

**Proposition.**  For `k=F_11`, `L=PSL_2(11)`, `H=A5`, and `K=A4`, the permutation module
`k[L/H]` is the projective cover `P(1)` and has Loewy dimensions `1|9|1`.  The C411 depth plane is

```text
P(1)^K / soc(P(1)),
```

with the paired sheet attaching the outer sign.  The kernel on the full six-dimensional mixed
bi-Hecke space is the three-dimensional even half plus the one-dimensional odd socle.

**Proof.**  Since `|H|=60` is prime to 11, its trivial module is projective; induction makes
`k[L/H]` projective.  The degree-11 action is 2-transitive, so its commuting algebra has basis the
identity and all-ones operator `J_11`.  In characteristic 11, `J_11^2=11J_11=0`; the commuting
algebra is local, hence the permutation module is indecomposable.  Its trivial head occurs once,
so it is `P(1)`.  The sum map gives the ten-dimensional radical and the constant vector gives the
one-dimensional socle.  The remaining heart has dimension nine.  The checker generates the full
`9^2=81`-dimensional matrix algebra on it, proving absolute irreducibility by density; it is
`L(8)=Sym^8(k^2)`.

Because `11` does not divide `|K|=12`, taking `K`-fixed points is exact.  The `K`-orbits have sizes
`1,4,6`, hence `dim P(1)^K=3`; in the orbit-sum basis its socle is `(1,1,1)`.  The exact depth matrix
has rank two with precisely this kernel.  Pairing sheets splits the mixed space into even and odd
three-spaces; depth kills the even half and only the socle in the odd half.  QED.

### Tate-cycle criterion for a canonical plane

**Proposition.**  Let equal-dimensional spaces `A,B`, of dimension `n`, have canonical maps

```text
A --pi--> B --N--> A
```

with `N pi=0`, ranks `n-1,1`, and `im(N)=ker(pi)`.  Then `im(pi)=ker(N)`, and `pi` induces
`A/im(N) ~= ker(N)` canonically.

**Proof.**  From `N pi=0`, `im(pi) <= ker(N)`.  Both have dimension `n-1`, so they are equal.  The
first isomorphism theorem gives `A/ker(pi) ~= im(pi)`; substitute the two image/kernel equalities.
QED.  In C412, `n=3` and all hypotheses are verified by exact matrices.

### Rank-one semi-invariant contraction

**Proposition.**  If a covector `ell in W*` and a cubic tensor both transform by a quadratic
character `chi`, contraction sends the cubic to an invariant quadratic tensor:

```text
i_ell : Sym^3(W)_chi -> Sym^2(W)^G.
```

If `k ell` is uniquely characterized by a rank-one invariant form `ell^2`, the map is canonical up
to overall scalar.

**Proof.**  Contraction is functorial.  Acting by `g` contributes one factor `chi(g)` from the cubic
and one from `ell`; their product is one.  Uniqueness of `ell^2` makes the covector line intrinsic.
For C412 the matrix is `[[8,1,0],[0,8,1]]`, of rank two with kernel `[1:3:9]`, the Tate kernel.
QED.

### Unique-rank-locus recognition of a quotient kernel

**Proposition.**  If an intrinsic three-space `R <= Sym^3(W)` has exactly one projective line of a
specified exceptional flattening rank, every automorphism preserving `R` and the tensor
construction fixes that line.  It may therefore define an intrinsic quotient kernel.

**Proof.**  Flattening rank is invariant under invertible coordinate changes, so automorphisms
permute each projective rank stratum; a singleton stratum is fixed.  C412's complete 133-line census
is one rank-one line, one rank-nine line, and 131 rank-ten lines.  The unique rank-nine line is
`[1:3:9]`, directly verified as the common kernel of invariant projection and semi-invariant
contraction.  QED.

### Divided-transfer obstruction

**Proposition.**  Let positive orbit sizes `n_1,...,n_r` sum to a prime `p`, put
`s=(1,...,1)^T`, and define the integral transfer `B=s(n_1,...,n_r)`.  Then `B^2=pB`.  Divided
transfer kills every integral relation `a` with `sum_i n_i a_i=0`, but fixes the socle vector `s`.
It therefore cannot identify such a balanced relation line with the socle.

**Proof.**  Writing `n` for the orbit-size column,

```text
B^2=s(n^T s)n^T=(sum_i n_i)sn^T=pB.
```

Also `Ba=s(n^T a)=0`, whereas `Bs=s(n^T s)=ps`; division by `p` fixes `s`.  For `(1,4,6)`, the
three natural source relations lift to `(-4,1,0)`, `(2,-2,1)`, and `(-2,-1,1)`, each with integral
weighted sum zero.  The depth socle `(1,1,1)` has weighted sum 11.  QED.

### Information lattice: proved example and open abstraction

The bundle proves the concrete lattice

```text
22 matchings -> 6 A4 double-coset profiles -> 2 PSL sheets -> 1 undecorated conic.
```

The first arrow is the exact `K\G/H` orbit partition, the second forgets fine profile data while
retaining sheet sign, and the last forgets that sign.  C411/C412 prove these fibres and rank drops
for H3.  A functor assigning such a lattice to general subgroup data `K<G>H` remains an **open
abstraction**: mixed-Hecke coordinates need not separate double cosets and can have additional
modular kernels, so no general proof is claimed here.

## Paper-bearing recommendation

These reusable results are valuable to the Clebsch paper, but they should be integrated
selectively rather than promoted at equal weight.

**Main text.**  Promote the all-degree antipodal moment formula and the unique primitive
`1:4:6` dependence.  The first upgrades “cubic-first memory” from a degree-three observation to a
complete parity theorem with essentially the same proof.  The second shows that the profile rays
intrinsically recover the `1,4,6` orbit sizes and stabilizer orders `12,3,2`, strengthening the
paper's reconstruction narrative.  These are short, geometric, and directly support the central
Clebsch story.

**Compact modular subsection, if space permits.**  State the projective-cover result

```text
P ~= P(1)^A4 / soc(P(1))
```

as the conceptual explanation of the mixed-Hecke `6 -> 2` rank drop.  Its proof can be compressed
to projectivity from the `A5` stabilizer, locality of the degree-11 orbital algebra, the `1|9|1`
Loewy structure, and exactness of `A4`-fixed points.  This gives “cubic-first memory” a genuine
modular-representation-theoretic meaning.  If that language interrupts the main narrative, place
the proposition in an appendix and cite it from the depth-map theorem.

**Technical appendix or certificate discussion.**  Combine the Tate-cycle criterion,
semi-invariant contraction, and unique rank-locus characterization into one source-naturality
proposition: two independent constructions produce the same canonical two-plane and the same
kernel `[1:3:9]`.  Their value is intrinsicity and verification strength, not another headline.

**Boundary remark only.**  Give the divided-transfer obstruction in one paragraph.  It explains
why the natural source and depth planes remain distinct: divided transfer kills the balanced source
relations but fixes the depth socle.  This is useful protection against an overclaim, but should not
be presented as a principal negative theorem.

**Do not promote yet.**  Keep the general `K\G/H` information-lattice functor as a future direction.
Only its H3 instance is proved, and a broad formulation would make the paper appear to claim a
general modular-Hecke theory that the current bundle does not establish.

The recommended paper hierarchy is therefore: parity theorem and primitive dependence in the main
line; one compact Brauer-tree proposition; source-naturality machinery in an appendix; divided
transfer as a boundary remark; general information lattices deferred.

## Claim-specific literature gate

This report inherits the C406 priority audit's **six full-text sources** and C411's recorded
double-coset/Hecke source boundary.  It adds **zero newly full-read sources**, three sources at
partial depth, one secondary-only chain, and one source at abstract/metadata depth.  The result does not depend on an absence-of-prior-work
claim: its positive modular statements and remaining boundary are exact internal calculations.  No
forward-citation negative is used.

- Abraham Broer and Jianjun Chuai, *Modules of covariants in modular invariant theory*,
  arXiv:0709.0703v3: **partial**; cached arXiv PDF, Abstract, Introduction, Section 1.1, and the
  opening of Section 1.2 read.  Cache key `arXiv:0709.0703`, SHA-256
  `e8b7e4504c1acfe005fc2087259c93de95e987d8a6d24bd7dc78eff82309ac7e`.  It defines a module of
  covariants as `(k[V] tensor M)^G`, identifies semi-invariants as one-dimensional covariant types,
  and emphasizes the modular/nonmodular boundary.  It supports the category used here but does not
  discuss the C406/C411 representations.
- Peter J. Olver, *Classical Invariant Theory*, Chapter 2, DOI
  `10.1017/CBO9780511623660.003`: **abstract/metadata only**; official Cambridge chapter page,
  bibliographic metadata and publisher summary read.  The summary explicitly places binary cubics,
  Hessians, resultants, discriminants, invariants, covariants, and syzygies in the chapter's
  classical scope.  The full chapter was paywalled and was not read, so no internal negative rests
  on it.
- **ATLAS of Group Representations, `L_2(11)`:** **partial**; official representation index and
  characteristic-11 representation listings read.  It records the primitive degree-11 actions and
  absolutely irreducible modules of dimensions `3,5,7,9,11`, supporting the named nine-dimensional
  heart.  The checker independently proves absolute irreducibility by obtaining matrix-algebra
  dimension `81`.
- Tobias Braun and Gabriele Nebe, *Orthogonal representations of `SL_2(q)` in
  defining characteristic*, DOI `10.1007/s13366-024-00763-w`: **partial**; publisher HTML through
  Section 3.1 Fact 3.1 and references read.  It states that the defining-characteristic simple
  modules are the symmetric powers and points to Brauer--Nesbitt and Burkhardt for the decomposition
  theory.
- R. Burkhardt, *Die Zerlegungsmatrizen der Gruppen `PSL(2,p^f)`*, J. Algebra 40 (1976), 75--96:
  **secondary only**; bibliographic data and role obtained through the Braun--Nebe reference
  list and ATLAS bibliography.  The paper itself was not read, so no internal theorem is attributed
  beyond that secondary chain.

Four exact OpenAlex searches were run over title/metadata, screening every returned title when the
count was at most ten and the first ten otherwise:

| exact query | total | screened | disposition |
|:---|---:|---:|:---|
| `modular PSL2 relative invariant covariant` | 9 | 9 | relevance failure; no matching modular finite-group construction |
| `binary cubic Hessian apolar covariant` | 19 | 10 | classical apolar/covariant records; no C406/C411 interface |
| `association scheme eigenspace covariant invariant theory` | 74 | 10 | relevance failure dominated by unrelated modular/physics uses |
| `PSL(2,11) symmetric cube characteristic 11 invariant` | 4 | 4 | no matching relative-space/depth-plane construction |

The first ten titles of a broad result set do not license a global negative.  MathSciNet and Google
Scholar were not accessible, and zbMATH was not closed claim-by-claim.  Those gaps are recorded but
do not qualify the exact obstruction theorem.  The safe literature disposition is positive and
limited: modular covariant modules and binary Hessian/apolar machinery are classical; C412 does not
claim a new general invariant-theory theorem.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c412-relative-cubic-depth-plane.py --check
python3 notes/2026-07-20-c412-relative-cubic-depth-plane-replay.py
sha256sum -c notes/2026-07-20-c412-relative-cubic-depth-plane.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c412-relative-cubic-depth-plane.py --write
```

The primary checker reconstructs the H3 quotient module, the 220-dimensional symmetric cube,
invariants, coinvariants, group norm, exact Tate rank pattern, semi-invariant contraction, both
rank pencils, all 133 relative lines, the paired-orbit polarizations, the degree-11 orbital algebra,
the symmetric-square coinvariant tests, depth fibres, and the non-descent witness.  It also checks
the binary factorization, Hessian, catalecticant, and original map census.  The independent replay
separately checks the finite linear algebra around the Tate cycle, orbit-weight norm, determinant
divisor, quadratic-coinvariant and orbital stops, ten residual flag maps, and directly enumerates
all `11^6` rank-two matrices and their kernel multiplicities.

The trusted boundary is exact Python integer/`F_11` arithmetic, the frozen C406 matching-module and
C411 double-coset certificates, standard invariant/coinvariant and group-norm constructions, and
the classical tensor meanings of contraction, determinant, Hessian, and catalecticant.  The
canonical integral permutation complex is asserted only for the 11-point sheet/projective cover;
no coordinatewise integral lift of the full ten-dimensional affine realization is assumed.
Affine-cocycle-valued bridges and twisted Fourier targets remain allocated to C417 and C416.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 75,580 | `b0bc0cdcd1fd547c05f04930ec1dad2875db5254059eb4d82e0a07cefd2b46ae` |
| independent replay | 8,500 | `c5c6b30445fa1a2d3cdd70ecba48860fffc1de8e184625afb9f5c994ca3e12bf` |
| canonical JSON | 81,411 | `01aaf1169e7747724c51969a78234e9fe0a3c62061f557d19e9f7b5d7ce11c84` |

## Disposition

C412 closes after the bounded derived gate.  The canonical invariant-to-coinvariant projection,
Tate norm, unique rank-nine flattening line, and rank-one semi-invariant contraction identify the
same intrinsic two-dimensional source quotient.  Separately, the Brauer-tree calculation identifies
the C411 depth plane as the `A4`-fixed projective-cover slice modulo its socle and explains the
four-dimensional mixed-Hecke kernel.

Ordinary orbital, quadratic-coinvariant, invariant-correlation, and nonlinear flag operations do
not identify those two planes.  Neither does the divided transfer/Bockstein from the integral
degree-11 permutation complex: it kills each natural source relation and fixes the depth socle.
Affine-cocycle work remains C417.  No fitted identification or manuscript edit is authorized.
