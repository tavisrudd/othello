# C904: exact scope of residual `C3` descent

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: the marked-base mod-two modules, quadratic refinements, cusp inertia,
and the residual integral-Chow descent gate

## Verdict

The `C3` calculation is correct and useful for relative **Picard** descent,
but it does not settle the integral-Chow halving problem.

On the actual exotic principal homology lattice, the residual order-three
generator satisfies

\[
             M^2+M+I=0\qquad\text{on }J[2].
\]

Consequently `J[2]` is fixed-point-free.  Since every symmetric
line-bundle torsor with fixed Neron--Severi class is an affine `J[2]`-torsor,
the vanishing

\[
 H^1(C_3,J[2])=0
\]

gives an invariant quadratic refinement, and `J[2]^{C3}=0` makes it unique.
The exact replay solves and exhaustively checks the fifteen actual divisor
basis torsors.

The stronger slogan “`C3` kills the two-primary obstruction” is false.
For every `F2 C3`-module `M`, odd-order averaging gives `H^1(C3,M)=0`, whether
or not `M` has fixed vectors.  In the modules relevant here, fixed spaces are
often large:

| explicit module `M` | dimension | `dim M^C3` | `dim H^1(C3,M)` |
|---|---:|---:|---:|
| `J[2]` | 10 | 0 | 0 |
| `Alt^2 J[2]=H^2(J,F2)` | 45 | 25 | 0 |
| actual `NS(J)/2` divisor lattice | 15 | 15 | 0 |
| geometric `Br(J)[2]=H^2/(NS/2)` | 30 | 10 | 0 |
| exotic gluing graph heart `H_graph` | 4 | 0 | 0 |
| Rosati norm-square defect `Q(R)` | 4 | 4 | 0 |

In particular, the two four-dimensional hearts are isomorphic as `A5`
modules but are **not** the same `A5 x C3` module.  The residual generator
acts by `omega^2` on the exotic gluing graph and trivially on the Rosati
defect.  Conflating these two incarnations would incorrectly turn a
four-dimensional fixed space into a fixed-free one.

The four cusp widths are also correct on the common twist-plus-sign marked
base:

\[
                         (2,2,6,6).
\]

Their clean derivation is from the actual cover, not from an unexplained
width tuple.  On the twist cover

\[
 T(z)=\frac{27(27z^2+5)}{5(z^2-1)},
\]

the width-one cusp `T=0` has two simple preimages and the width-three cusp
`T=infinity` has two simple preimages.  The exotic sign cover `r^2=T`
ramifies at all four, doubling the widths.  Thus every local parabolic is an
even power of a transvection and acts trivially on mod-two theta data.

## 1. What `H^1(C3,M)=0` actually says

Let `g` generate `C3` and put `N=1+g+g^2`.  For an `F2 C3`-module,

\[
 H^1(C_3,M)=\ker N/(g-1)M.
\]

Because `3=1` in `F2`, the norm is the averaging idempotent.  Hence

\[
 M=M^{C_3}\oplus(g-1)M,
 \qquad
 \ker N=(g-1)M,
\]

and `H^1=0`.  More generally all positive cohomology vanishes on a finite
two-primary module because multiplication by three is invertible.

This has an exact torsor interpretation.  If an affine `M`-torsor is already
the correct geometric parameter space, then its monodromy cocycle is a
coboundary and it has a fixed point.  The fixed points form a torsor under
`M^C3`.  Therefore:

- `H^1=0` proves **existence** of a fixed representative;
- `M^C3=0` proves **uniqueness**;
- neither assertion says that an invariant element of `M` is zero.

The last distinction is visible without abstraction: `Br(J)[2]^C3` has
dimension ten, while `H^1(C3,Br(J)[2])` still vanishes.

## 2. Exact modules

### `J[2]`

Transporting

\[
 m=\begin{pmatrix}-1&-1\\1&0\end{pmatrix}
\]

through the certified exotic principal basis gives the integral Gate V
matrix.  Modulo two it satisfies `M^2+M+I=0`; thus `M-I` has rank ten and the
fixed space is zero.  The norm is zero, while `(M-I)J[2]=J[2]`, so `H^1=0`
directly.

### Quadratic refinements

For each of the fifteen integral NS basis forms `E`, the normalized
quadratic refinements form an affine `J[2]`-torsor.  The replay solves the
ten-variable affine invariance equation and then tests all `2^10` points.
It finds exactly one invariant refinement for every basis form.  Tensoring
gives the unique refinement for every integral horizontal NS class.

This is the precise module calculation supporting Gate V.  “Quadratic
refinements” themselves should not be listed as a vector module: for fixed
polar form they are an affine torsor whose difference module is `J[2]`.

### Divisors and the two hearts

The residual elliptic `C3` acts trivially on every coefficient-matrix divisor
form.  The replay reconstructs the saturated rank-fifteen NS lattice and
checks

\[
                  M E M^t=E
\]

for every basis form.  Thus `NS/2` is the fifteen-dimensional trivial `C3`
module.  Any equivariant quotient of it, including the four-dimensional
Rosati norm-square defect

\[
 Q(R)=R^+/\langle f^\dagger f:f\in R\rangle,
\]

also has trivial residual action.

The gluing heart has different descent data.  Write the exotic graph as
`(x,omega x)`.  Modulo two, `m` sends it to

\[
 (x,\omega x)\longmapsto((1+\omega)x,x)
                     =(\omega^2x,\omega\omega^2x).
\]

It therefore induces multiplication by `omega^2` on the graph parameter.
Since `omega^2+omega+1=0`, this heart is fixed-point-free.  The equality
`Q(R) isomorphic to H_graph` is only `A5`-equivariant, not
`A5 x C3`-equivariant.

### `H^2` and the geometric Brauer quotient

The replay induces `M` on all 45 alternating two-forms, embeds the actual
rank-fifteen `NS/2`, and forms the quotient rather than assuming exactness of
invariants.  It obtains

\[
 \dim H^2(J,F_2)^{C_3}=25,
 \qquad
 \dim \operatorname{Br}(J)[2]^{C_3}=10.
\]

This agrees with the independent charge-two Brauer replay.  The earlier
joint computation also gives
`dim Br(J)[2]^(A5 x C3)=2`.  These fixed classes are a concrete warning:
odd-order cohomology vanishing does not rule out a geometric or equivariant
two-primary invariant.

## 3. Cusp calculation and base bookkeeping

On `X0(3)` the Tate fibres at `T=0,infinity` are `I1,I3`, hence have widths
one and three.  The twist-splitting cover is rational with coordinate `z`
as above.  Its numerator and denominator are squarefree quadratics:

\[
 T^{-1}(0)=\{27z^2+5=0\},\qquad
 T^{-1}(\infty)=\{z=1,z=-1\}.
\]

All four valuations of `T` are odd.  Pullback along `r^2=T` therefore has
ramification index two at each point and gives

\[
 2,2\quad\text{over }I_1,
 \qquad
 6,6\quad\text{over }I_3.
\]

The local action on quadratic refinements factors through the mod-two
symplectic action.  A conjugate of `T^w` is the identity modulo two for each
even marked width, so every local theta-characteristic residue is zero.

There are three bases worth keeping distinct:

1. the exotic sign cover of `X0(3)` alone has residual mod-two group `C3`
   and two cusp widths `(2,6)`;
2. the common twist-plus-sign cover still has residual `C3` and has four
   cusp widths `(2,2,6,6)`;
3. pulling the sign cover back to the degree-three root resolvent `X0(6)`
   produces the full two-division splitting cover and the same numerical
   width tuple, but kills the residual `C3`.

Thus the simultaneous `C3` and four-cusp statement belongs to base (2), not
to base (3).  The earlier Gate V wording via the quartic `X0(6)` tuple is
numerically correct but obscures this provenance.

The local conclusion is only about mod-two theta data.  It does not prove
extension of a Chow cycle through a semiabelian compactification.

## 4. The exact residual Chow gate

The unresolved halving/descent problem is not presently an affine
`J[2]`-torsor.  In particular, descent from the exotic marked sheet to the
unmarked base is governed by the order-two deck involution `sigma`, not by
the residual order-three monodromy.  Its natural obstruction group is of the
form

\[
 \widehat H^0\!\left(C_2,
   \operatorname{CH}^k(\mathcal J_{U_{\rm ex}})\right)
 =\operatorname{CH}^k(\mathcal J_{U_{\rm ex}})^{\sigma}/
   (1+\sigma)\operatorname{CH}^k(\mathcal J_{U_{\rm ex}}),
\]

or the corresponding relative/generic-fibre quotient after specifying the
cycle problem.  This group is two-primary precisely where odd averaging is
unavailable.

Abel--Jacobi may map part of this obstruction to a `J[2]`-class, but no
injectivity theorem identifies the full Chow obstruction with `J[2]`.
A homologically trivial or Griffiths-group residue may survive after its
`J[2]` image vanishes.  Brauer and unramified layers are also not excluded;
the explicit ten-dimensional `Br[2]^C3` fixed space shows why `C3` symmetry
alone cannot remove them.

Accordingly the exact proved boundary is:

- **closed:** horizontal NS classes and their symmetric line bundles on the
  common marked smooth base;
- **closed:** all four local mod-two theta residues;
- **not closed:** descent/halving of the chosen integral Chow relation
  through the exotic `C2` deck;
- **not justified:** replacing that Chow obstruction by an element of
  `J[2]` without a separate comparison or injectivity theorem.

## 5. Replay

Run:

```bash
cd /home/tavis/src/othello
diff -u notes/2026-08-10-c904-c3-descent-scope.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-c3-descent-scope.sage").read()))')
```

The certificate imports the exact principal-lattice construction, rebuilds
the residual integral matrix, the full divisor lattice, all quadratic
refinements, `H^2`, the geometric Brauer quotient, both heart actions, and
the marked cusp valuations.  It computes `ker(N)/(g-1)M` rather than merely
appealing to averaging.

Load-bearing artifacts:

| artifact | bytes | SHA256 |
|---|---:|---|
| `2026-08-10-c904-c3-descent-scope.sage` | 7,870 | `4bcb05c0e1539cff232ffa92a62bdf794ba90dade7194a29371c29d754f03a79` |
| `2026-08-10-c904-c3-descent-scope.out` | 695 | `f23fc4a3d0367e62461da028aed991b9ab75eba2e7d3226ec6bab8847d8e5bc8` |

The pre-existing independent Brauer replay
`2026-08-10-c904-charge-two-brauer-invariants-replay.sage` independently
confirms the `Br[2]` fixed dimensions.  The pre-existing SymPy Gate V replay
independently confirms the integral `C3` matrix and all fifteen invariant
quadratic refinements.
