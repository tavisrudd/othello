# C921 — the integral glued model of the four-dimensional factor, and the Schottky count

**Lane:** `cubic-threefolds` · **Date:** 2026-08-19 · **Task:** C921

## Result

The integral model of the four-dimensional factor `A_b` of the intermediate Jacobian of
the nonstandard `A_5`-pencil is

    L_4 = (A_4(6) tensor M) + K_2 + K_3,

where `A_4(6)` is the `A_4` root lattice with its form multiplied by six,
`M = H_1(E_b, Z)`, `K_2` is the exotic `F_4`-graph in `H_2 tensor E_b[2]`, and
`K_3 = H_3 tensor C` for a monodromy-invariant line `C` in `E_b[3]`. It has rank eight,
determinant `25`, and symplectic type `(1,1,1,5)`.

So the four-dimensional factor is **not principally polarized**. It acquires a principal
polarization only after a choice of one of six order-five subgroups of `E_b[5]`, and the
axis stabilizer `D_5` fixes all six, so nothing in the `A_5`-structure selects one.

With that model the Schottky count is exact and needs no glue exponent at all. The
Hodge bundle of the pencil's elliptic factor has degree two on the compactified base, so
the pulled-back Igusa Schottky form is a section of a line bundle of degree

    32 deg lambda_E = 64

for each fixed choice of principal polarization, and `384` on the six-sheeted five-torsion
cover that carries all six choices at once. The card's standing bounds were `384` under a
glue exponent of six and `46080` under a glue exponent of thirty; both were bounds on the
wrong invariant, since the count never depended on the glue exponent.

## 1. Where the glue sits

Write `Lambda = Z^Omega / Z 1` with the form `kappa` of Gram matrix `6 I_6 - J_6`, `v` for
the class of the chosen axis, and `N = v^perp`.

`kappa(v,v) = 5` is a unit at two and at three. Hence `Lambda` splits orthogonally as
`Zv` perp `N` over `Z_2` and over `Z_3`, and the entire discriminant group
`disc(Lambda) = (Z/6)^4` is carried by `N`. The epilogue's kernel `ker f = K_2 + K_3` of
order `6^4` therefore lies **entirely inside the four-dimensional factor**; none of it
touches the elliptic factor.

Everything that separates the two factors is five-adic instead. `Lambda` is unimodular
over `Z_5`, `v` has norm five, and

    [Lambda : Zv + N] = 5,        [Lambda tensor M : (Zv tensor M) + (N tensor M)] = 25.

That single five is C914's "odd index 25". It is the whole of the index; there is no
two- or three-primary contribution to it.

The lattice `N` itself is exactly six times the `A_4` root lattice: in the basis of the
five axes other than the chosen one,

    N = { x in Z^5 : sum x_i = 0 },     kappa(x,y) = 6 <x,y>,

with determinant `6^4 * 5` and twenty vectors of norm two after dividing the form by six.
This was already recorded on the C921 card as a structural handle; it is now certified.

## 2. The integral model, and its polarization type

`L = H_1(J(X_b), Z)` is the overlattice of `Lambda tensor M` glued along
`K = K_2 + K_3`. The script builds it explicitly from the epilogue's own description of
the two hearts — `H_p = Aug(F_p^Omega)/<1>`, simple of dimension four over `F_p`, with
commutant `F_4` at two and `F_3` at three — and confirms that `L` is integral,
unimodular, `A_5`-stable, and of index `6^4` over `Lambda tensor M`.

Cutting `L` by the two orthogonality conditions gives

    L_1 = L n (Qv tensor M_Q)      rank 2, symplectic type (5),
    L_4 = L n (N_Q tensor M_Q)     rank 8, determinant 25, symplectic type (1,1,1,5),

with `[L : L_1 + L_4] = 25`. The determinant bookkeeping is forced: `L` is unimodular, so
the two determinants multiply to the square of the index, and `L_1` of type `(5)` leaves
`L_4` with determinant `25`.

The exotic and the `F_2`-rational two-primary kernels give the same answer here. Both were
run; both produce type `(1,1,1,5)`. The exotic choice is what blocks the `(1,2,2)`
splitting in C914, and it does not touch the type of the `(1,4)` factor.

## 3. Six principal polarizations, indexed by the five-torsion of the elliptic factor

`disc(L_4) = (Z/5)^2`, and it is glued to `disc(L_1) = M/5M = E_b[5]`, so canonically

    disc(L_4)  =  E_b[5].

The discriminant pairing is alternating, so every one of the six order-five subgroups is
isotropic, and each gives a unimodular overlattice of `L_4` — a principal polarization on
an abelian fourfold isogenous to `A_b` by an isogeny of degree five. All six were built
and checked.

The axis stabilizer `D_5` acts on `disc(L_4)` through `+-1`: it preserves `N`, hence acts
on `disc(N)_5 = Z/5` through the automorphisms preserving the discriminant form, which are
`+-1`, and it acts trivially on `M` because the `A_5`-action lives on `Lambda` alone.
So `D_5` fixes each of the six lines and cannot single one out. Verified directly.

A near-miss worth naming and dismissing: the six polarizations form a `P^1(F_5)`, and so do
the six axes, which is how `A_5 = PSL_2(F_5)` enters in the first place. The two hexads are
not identified. `A_5` permutes the axes two-transitively and fixes every one of the six
polarizations, so no equivariant bijection exists.

## 4. Correction to C914

C914's script `notes/2026-08-18-c914-a5-pencil-voisin-locus.py` glues only the two-primary
kernel; its `glue_groups` is documented as returning the `A_5`-stable maximal isotropic
subgroups of the two-primary discriminant, and no three-primary glue appears anywhere in
it. Its `L` therefore has determinant `3^8` rather than one, and the rank-eight elementary
divisors it reports, `(3,3,3,3,3,3,15,15)`, belong to the partially glued lattice. Turning
the three-primary glue back off in this task's script reproduces `(3,3,3,3,3,3,15,15)`
exactly, so the two computations agree about what the difference is.

C914's conclusion is untouched and in fact strengthened. That argument needed the
elementary divisors to be odd, so that the isogeny has odd degree; removing the threes
leaves them odder. What has to change is the description, in two places.

- The four-dimensional factor is of type `(1,1,1,5)`, not principally polarized. C914's
  card and report call it "a four-dimensional principally polarized abelian variety". That
  is true only of the six five-isogenous fourfolds of section 3, not of the factor itself.
- Any statement that quotes `(3,3,3,3,3,3,15,15)` as a property of `H_1(J(X_b), Z)` is
  quoting the partially glued lattice.

The C910 session was told, since it is about to formalize the separation cluster, which
includes `cor:voisin-separation` and `prop:no-elliptic-product`.

## 5. The level structure the pencil is forced to carry

The epilogue's principal gluing packet proposition says the relative kernel `K_p` is a
*section* of the local system of `A_5`-stable maximal isotropic halves. Reading that as a
constraint on the monodromy of `E_b` gives two statements about the pencil that are worth
recording because they are checkable against an explicit Weierstrass model.

**At two.** The halves are the five `F_4`-lines in `F_4 tensor_{F_2} E_b[2]`, and the
monodromy acts `F_4`-linearly through `GL_2(F_2)`. An element of `GL_2(F_2)` fixes an
exotic line exactly when it has an eigenvector with eigenvalue in `F_4 \ F_2`, that is
exactly when its characteristic polynomial is `x^2 + x + 1`, that is exactly when it has
order three. So the stabilizer of the exotic kernel is the cyclic subgroup of order three,
of index two, and the mod-two monodromy image of `E_b` lies inside it. Equivalently: the
discriminant of the elliptic factor is a square in the function field of the base.

**At three.** The halves are `H_3 tensor l` for lines `l` in `E_b[3]`, so a section is a
monodromy-invariant order-three subgroup: the elliptic factor carries a rational
three-isogeny over the base.

**At five,** as soon as one asks for a principal polarization on the fourfold, section 3
adds a monodromy-invariant order-five subgroup, on a six-sheeted cover if not on the base
itself.

## 6. The Schottky count

Igusa's Schottky form is a cusp form of weight eight on `Sp_8(Z)` whose zero divisor in the
moduli of principally polarized fourfolds is the closure of the Jacobian locus. A Siegel
form of weight `k` is a section of the `k`-th power of the determinant of the Hodge bundle.

**The Hodge bundle of the fourfold.** The Hodge structure on `Lambda_Q tensor M_Q` is
trivial on `Lambda` and of weight one on `M`, so `H^{1,0}(A_b) = N_C tensor H^{1,0}(E_b)`
and

    det H^{1,0}(A_b) = lambda_E^4,

for every choice of principal polarization, since an isogeny induces an isomorphism on
one-forms. The pulled-back Schottky form is therefore a section of `lambda_E^{32}`.

**The degree of `lambda_E`.** Let `B` be the pencil `P(V)`, `V` the two-dimensional space
of `A_5`-invariant cubic forms on `W_5`, and let `O_B(1)` be the dual of the tautological
subbundle. For a smooth cubic threefold `X_F` in `P^4`, the Griffiths residue

    A  |-->  Res( A Omega / F^2 )

is an isomorphism from `S_1` onto `H^{2,1}(X_F)`, since the Jacobian ideal starts in degree
two. Replacing `F` by `tF` scales it by `t^{-2}`, so over the pencil this globalizes to

    H^{2,1}  =  W_5^* tensor O_B(2),        det H^{2,1} = O_B(10).

Now `W_5` is self-dual, so `H^{2,1}` is `W_5`-isotypic with multiplicity bundle `O_B(2)`;
and by Hartlieb's decomposition the multiplicity bundle is exactly `lambda_E`. Hence

    deg lambda_E = 2.

Two checks. First, `det H^{2,1}` must be the fifth power of `lambda_E`, and `5` divides
`10`. Second, the same computation for a pencil of plane cubics gives
`H^{1,0} = (S/J)_0 tensor O(1) = O(1)`, degree one, which is the arithmetic genus of a
rational elliptic surface, as it must be.

**The count.** For each fixed choice of principal polarization the pulled-back Schottky
form is a section of a line bundle of degree

    32 deg lambda_E = 64

on the compactified base, and it is not identically zero — that is what the point count of
`../2026-08-19-c921-genus-four-branch.md` establishes, since a family inside the Jacobian
locus would have every member a Jacobian. On the six-sheeted cover carrying all six
polarizations, `lambda_E` pulls back to degree twelve and the count is `384`.

Three qualifications, none of which weakens `64` as an upper bound.

- The zero divisor of the Schottky form is the closure of the Jacobian locus, which
  contains the decomposable fourfolds. So `64` bounds the genus-four locus and the
  decomposable locus together.
- The count is with multiplicity.
- `O_B(2)` is the Griffiths bundle, which agrees with the Hodge bundle over the smooth
  locus of the pencil. Across the singular members the canonical extension can only lose
  degree, and the Schottky form is a *cusp* form, so it vanishes as the fibre degenerates.
  Both effects subtract from the count of exceptional smooth members. `64` is therefore an
  upper bound, and is exact only if the boundary absorbs nothing.

**Consistency with the level structure.** Section 5 gives a subgroup of `PSL_2(Z)` of index
`2 * 4 = 8` at two and three, on which the Hodge bundle has orbifold degree `8/12 = 2/3`.
Our base has `deg lambda_E = 2 = 3 * (2/3)`, so the pencil covers that modular curve three
to one. Adding the five-torsion condition gives index `48` and orbifold degree `4`, and the
six-sheeted cover has degree `12 = 3 * 4`, the same factor of three. This is a check on the
integrality of `deg lambda_E = 2`, not a load-bearing step.

## 7. Evidence bundle

| artifact | bytes | sha256 |
|---|---|---|
| `2026-08-19-c921-integral-glued-model.py`  | 25729 | `ee5a587f06ab39ce97e63ecc10d8c6370cf4278e95641b82f3ddb652e286955a` |
| `2026-08-19-c921-integral-glued-model.txt` |  2727 | `878a96a6968b5f2b49e91f3215503c250b17c1e68fb311d327c229d1ebab8124` |

Manifest: `notes/2026-08-19-c921-integral-glued-model.sha256`, which carries the
authoritative hashes; the table above is a convenience copy.

Replay, from the repository root:

    python3 notes/2026-08-19-c921-integral-glued-model.py \
        > notes/2026-08-19-c921-integral-glued-model.txt
    python3 notes/2026-08-19-c921-integral-glued-model.py --check \
        notes/2026-08-19-c921-integral-glued-model.txt
    (cd notes && sha256sum -c 2026-08-19-c921-integral-glued-model.sha256)

The `--check` mode regenerates in memory and compares against the tracked output without
writing to the worktree. No third-party dependencies; exact integer and rational
arithmetic throughout, with Hermite and Smith normal forms implemented in the script.

Independent replay: the two-primary half of the construction is an independent
implementation of the same objects as C914's script, and the two agree — this script
reproduces C914's `(3,3,3,3,3,3,15,15)` exactly when its three-primary glue is switched
off. The `A_5`-module facts it uses, that `H_p` is simple of dimension four with commutant
`F_4` at two and `F_3` at three, are the epilogue's own Lemma on the six-point hearts,
recomputed here from the permutation action rather than imported.

## 8. What this does not prove

- It does not decide C921. The genus-five route is untouched.
- The count `64` is an upper bound on the exceptional set, not its value, and does not
  locate a single exceptional member.
- `deg lambda_E = 2` is a statement about the Griffiths bundle on the projective pencil.
  Turning the upper bound into an exact count needs the vanishing orders of the Schottky
  pullback at the pencil's singular members.
- Section 5's two predictions about the elliptic factor are derived from the epilogue's
  gluing packet proposition. They have not been checked against an explicit Weierstrass
  model of `E_b`, which would need Hartlieb's construction rather than the lattice side.

## 9. Extra juice, and what the closeout pass exposed

**The count can plausibly be driven to zero, which would upgrade the genus-four verdict
from "all but finitely many" to "every".** The Schottky form is a cusp form, and the pencil
degenerates at its singular members. If the vanishing orders of the pullback at those
members already total `64`, then no smooth member of the pencil has a four-dimensional
factor in the closure of the Jacobian locus, for any of the six principal polarizations.
That is a finite, local computation at each singular member — the type of degeneration of
`E_b` there, and the order of vanishing of the Schottky form along the corresponding
boundary stratum of the moduli of fourfolds. It is the single highest-value follow-up this
task exposes, it is bounded, and it would close the genus-four branch outright rather than
up to a finite set.

**The Fermat member is the one place to look first if the count is not zero.** Its elliptic
factor has complex multiplication, which is exactly where C914's argument stops, and CM
points are where extra endomorphisms and hence unexpected Jacobian coincidences occur.

**The `E tensor A_4` question is now sharper.** The card's suggested literature search was
for lattices `L` with `E tensor L` a Jacobian. The correct object is not `E tensor A_4` but
its glued overlattice, and the polarization to ask about is one of the six of section 3,
not the naive product. Anyone running that search should carry the type `(1,1,1,5)` and the
five-torsion choice into the query.

**Cheap upgrade taken here.** The claim that the four-dimensional factor is principally
polarized was inherited from C914 and used unexamined by the genus-four report's Schottky
section. It is false, it changes the count by the factor of six, and it changes what the
genus-four question even asks. Fixing it was free once the integral model was built.

## Mystery ledger

- **Why the glue avoids the elliptic factor entirely.** Settled by this task. It is not a
  coincidence of the kernel but a consequence of `kappa(v,v) = 5` being a unit at two and
  three, which makes `Lambda` split orthogonally at both primes with the whole discriminant
  group on the `N` side. The separation between the two factors is purely five-adic.
- **Why the count never needed the glue exponent.** Settled. The card framed the count as
  `32 deg lambda_E` with `deg lambda_E` to be recovered from a modular index, which is why
  the glue exponent looked load-bearing. But the family is a pencil with an explicit
  Griffiths bundle, so `deg lambda_E` is a direct computation on the base and the modular
  index is only a consistency check. The glue matters for something else entirely: which
  level structure the pencil is forced to carry, section 5.
- **The exceptional set is now bounded by 64 and still not located.** Open. The evidence
  gap is the vanishing order of the Schottky pullback at the pencil's singular members;
  the owning move is the degeneration computation of section 9, which would either locate
  the exceptional members or eliminate them.
- **Two hexads that are not the same hexad.** Open but probably empty. The six principal
  polarizations and the six axes are both `P^1(F_5)`, and `A_5 = PSL_2(F_5)` acts
  two-transitively on the second while fixing every element of the first. So there is no
  equivariant identification, and the shared cardinality traces to two unrelated
  appearances of five: `disc(A_4) = Z/5` on one side, `|P^1(F_5)| = 6` on the other. I do
  not claim a mystery here; it is recorded so the coincidence is not rediscovered.
- **The two predictions of section 5 are unverified against a model.** Open. Square
  discriminant and a rational three-isogeny for `E_b` follow from the gluing packet
  proposition, but nothing here confronts them with Hartlieb's explicit construction. A
  disagreement would be a defect in the packet proposition, not in this task, which makes
  the check worth its cost.
