# C904 adjacent-Annals uniform theorem hunt

Date: 2026-08-10
Status: proved-theorem dossier; novelty unaudited; no manuscript or Lean edits
Scope: uniform consequences of the resolved-theta, modular-gluing, divisor,
and deck-norm calculations

## Executive ranking

This pass produced three proved uniform theorems and two reusable structural
tools.
No novelty or priority claim is made here; each crown candidate needs the
full literature-audit protocol before use.

### Crown A: odd-rank Pascal--Wu parity on resolved theta divisors

**Status: proved.**  For any number of perfect index classes, the existence
of one odd virtual rank forces every formal line-twist-invariant
codimension-three Chern polynomial modulo two to be a sum of

\[
             (\text{invariant divisor})(\text{degree-two class})
             +\operatorname{Sq}^2(\text{degree-two class}).
\]

On a smooth resolution of a theta divisor in a `g`-dimensional abelian
variety, `g>=5`, both summands have even theta degree whenever the invariant
divisors lie in the ambient-theta/exceptional span.  This simultaneously
explains the Paper V parity wall and gives an obstruction compiler for other
moduli spaces.

The exact counter-boundary is also proved: if all ranks are even, the formal
degree-three quotient is nonzero, of dimension

\[
 \binom{s}{2}\quad\text{if all ranks are }0\pmod4,
 \qquad
 \binom{s}{2}+1\quad\text{if some rank is }2\pmod4,
\]

for `s` index classes.  Thus the odd-rank hypothesis is structural, not an
artifact of the ranks `(0,0,2,3)`.

### Crown B: Jordan-scalar minimal cycles

**Status: proved for a uniform infinite class.**  Every principally
polarized elliptic-power quotient whose local self-dual gluing is scalar on
each `p`-adic Jordan block of its coefficient Gram matrix has an integral
signed divisor-product representative of its minimal one-cycle class.

For the root--weight matrices

\[
                     G_N=N I_{N-1}-J
\]

this applies to every scalar full-Weyl principal gluing.  The minimal class
is therefore algebraic by an integral signed divisor-product expression.
The proof is local at each prime and works for every elementary-divisor type;
it includes noncyclic gluings and `p=2`.  The exact `N=3,4,5,6,7` census is now
a finite normalization check, not the basis of the theorem.

This is the strongest infinite-family result in the note.  The exotic
`F_4` cubic gluing is not Jordan-scalar, so its separate `7/17` saturation
certificate is not subsumed.  This theorem is not yet a
novelty claim: the precise statement must be audited against the literature
on elliptic-power isogenies, root/weight constructions, and integral minimal
classes.

An immediate priority boundary is already known: Beckmann--de Gaay Fortman
prove minimal-class algebraicity when the underlying abelian variety is
isomorphic to a product of elliptic curves.  The possible new content here is
the explicit integral divisor-product saturation, the Jordan-scalar quotient
scope beyond that product statement, and the contrast with the non-scalar
exotic cubic gluing.  The source audit must determine exactly how much of that
survives.

### Candidate C: exact deck-norm tower bounds

**Status: proved, elementary.**  Every double-cover norm obstruction has
exponent two; a tower of `r` double covers has total norm index dividing
`2^r`, and this bound is sharp.  A single mod-two obstruction proves only an
even lower bound.  Exact `2^r` requires a nonzero obstruction at each stage.

This is highly useful bookkeeping for relative Chow descent, but is not by
itself Annals-level mathematics.

### Candidate D: extension-field gluing versus full Weyl symmetry

**Status: proved in the scalar/simple setting.**  The full `S_N` modular
heart of the root--weight sandwich has scalar commutant.  Hence full Weyl
symmetry permits only rational scalar gluing slopes.  Extension-field slopes
can occur only after symmetry restriction enlarges the modular commutant.
When that commutant is `F_{p^2}`, generic `PGL_2(F_p)` monodromy has the two
orbits

\[
                  p+1,qquad p(p-1)
\]

on `P^1(F_{p^2})`.  The cubic `3+2` packet is the case `p=2`.

### Candidate E: a single-obstruction impossibility algorithm

**Status: proved as a corollary of A and C.**  Rank parity, the invariant
divisor lattice, and one Wu functional suffice to rule out an entire formal
universal-Chern search without enumerating candidate formulas.  For deck
towers, the same mod-two philosophy gives a certified lower bound but cannot
distinguish indices two, four, and higher without renewed tests upstairs.

## 1. The formal Pascal dichotomy

Let

\[
 R=\mathbf F_2[a_i,b_i,c_i:1\le i\le s],
 \qquad \deg(a_i,b_i,c_i)=(1,2,3),
\]

where these variables model the first three Chern classes of virtual
classes of ranks `r_i`.  A simultaneous line twist with first Chern class
`ell` acts through

\[
 c_k(T_i\otimes L)
 =\sum_{j=0}^k{r_i-j\choose k-j}c_j(T_i)\ell^{k-j}.
\]

Write `R_inv^(d)` for the weight-`d` formal invariants, and put

\[
 Q_3(r)=
 \frac{R_{\rm inv}^{(3)}}
 {R_{\rm inv}^{(1)}R_{\rm inv}^{(2)}
  +\operatorname{Sq}^2R_{\rm inv}^{(2)}}.
\]

### Theorem 1: odd-rank vanishing

If some `r_i` is odd, then

\[
                              Q_3(r)=0.
\]

#### Proof

Suppose `r_0` is odd.  Modulo two,

\[
                         a_0\longmapsto a_0+\ell.
\]

Twist formally by `ell=a_0`.  This sets the normalized first Chern class of
`T_0` to zero and gives a slice for the line-twist action.  The invariant
ring through weight three is therefore generated by the normalized Chern
classes other than that eliminated divisor coordinate.

Every weight-three monomial in normalized generators is either a product of
a weight-one and weight-two generator or is linear in a normalized third
Chern class.  For every complex virtual class,

\[
             \operatorname{Sq}^2c_2=c_1c_2+c_3\pmod2.
\]

Thus

\[
                       c_3=\operatorname{Sq}^2c_2+c_1c_2,
\]

which has the required form.  This proves the theorem for any number of
classes, without a monomial census.

There is also no integral-lifting defect in degree one.  If one rank is odd,
the gcd of the rank vector is odd, so reduction of

\[
              \ker(\mathbf Z^s\xrightarrow{(r_i)}\mathbf Z)
\]

surjects onto the mod-two degree-one invariant kernel.

### Theorem 2: all-even counterspace

Assume every rank is even and put

\[
                     \epsilon_i=r_i/2\pmod2.
\]

Then

\[
 \dim Q_3(r)=
 \begin{cases}
   \binom{s}{2},&\epsilon_i=0\text{ for every }i,\\
   \binom{s}{2}+1,&\epsilon_i=1\text{ for at least one }i.
 \end{cases}
\]

#### Proof

All `a_i` are invariant.  The transformations reduce to

\[
\begin{aligned}
 b_i&\longmapsto b_i+a_i\ell+\epsilon_i\ell^2,\\
 c_i&\longmapsto c_i+(1+\epsilon_i)a_i\ell^2.
\end{aligned}
\]

The degree-two invariant space is exactly `Sym^2<a_1,...,a_s>`.  Hence its
products and Steenrod images contribute only pure cubic divisor monomials.
Modulo those, write a degree-three class as

\[
                 \sum_{i,j}x_{ij}a_i b_j+\sum_i y_i c_i.
\]

The coefficient of `ell` forces `x_ii=0` and `x_ij=x_ji`; thus the `x`'s are
edge labels on the complete graph.  The coefficient of `ell^2` gives

\[
                 \sum_jx_{ij}\epsilon_j+y_i(1+\epsilon_i)=0.
\]

If all `epsilon_i=0`, the `y_i` are determined and the free edge labels have
dimension `binomial(s,2)`.  If `t>0` vertices have `epsilon=1`, the equations
on their induced complete graph are the binary incidence equations, of rank
`t-1`; the `t` corresponding `y_i` are free.  The resulting dimension is
`binomial(s,2)-(t-1)+t=binomial(s,2)+1`.

The exact program checks every rank multiset modulo four for up to five
classes.  Its output agrees with these formulas and independently recovers
the Paper V tuple `(0,0,2,3)` with dimensions

\[
                  (\dim R^1,\dim R^2,\dim R^3,
                    \dim\text{ obvious},\dim Q_3)
                  =(3,10,26,26,0).
\]

## 2. Resolved-theta Wu wall in arbitrary dimension

Let `A` be a complex abelian variety of dimension `g>=5`, let `D` be an
ample divisor with isolated points of multiplicities `m_j`, and suppose the
strict transform

\[
 M\subset\operatorname{Bl}_{\{p_j\}}A
\]

is smooth.  Put `h=pi^*[D]|_M` and let `e_j` be the exceptional divisors on
`M`.

Adjunction gives

\[
 K_M=h+\sum_j(g-1-m_j)e_j,
 \qquad
 w_2(M)=h+\sum_j(g-1-m_j)e_j\pmod2.
\]

Moreover

\[
                         h e_j=0,
 \qquad h^2\in2H^4(M,\mathbf Z).
\]

The first identity holds because the exceptional divisor is contracted to a
point.  The second is the divided-square identity for an integral alternating
two-form on an abelian variety.

### Theorem 3: resolved-theta parity

Let `gamma` be an integral formal line-twist-invariant Chern polynomial of
codimension three in perfect complexes on `M`, one of whose virtual ranks is
odd.  Suppose every invariant determinant divisor occurring in the formal
ring has cohomology class in

\[
                     \mathbf Z h+\sum_j\mathbf Z e_j.
\]

Then

\[
                   \int_M h^{g-4}\gamma\equiv0\pmod2.
\]

#### Proof

Theorem 1 reduces `gamma` modulo two to terms `d z` and `Sq^2 z`, with `d`
an invariant divisor and `z` of codimension two.

For `d=a h+sum b_j e_j`, the exceptional terms vanish after multiplication
by `h^{g-4}`, while

\[
                       h^{g-3}z=0\pmod2
\]

because `g-3>=2` and powers of an integral alternating form carry the
factorial divided-power divisibility.

Put `k=g-4`.  Cartan and Wu give

\[
\begin{aligned}
 \int_Mh^k\operatorname{Sq}^2z
 &=\int_M\operatorname{Sq}^2(h^kz)+k h^{k+1}z\\
 &=\int_Mw_2(M)h^kz+k h^{k+1}z\\
 &=(k+1)\int_Mh^{k+1}z=0\pmod2.
\end{aligned}
\]

Again the exceptional contributions vanish because `k>=1`, and the last
theta power is even.  Notice that the singular multiplicities disappear
from the answer.

This theorem is stronger than the cubic-fivefold instance: it applies to
any smooth point-blowup resolution satisfying the displayed invariant
divisor condition.  Its limitations are exact:

- it concerns formal universal Chern/lambda polynomials;
- without an odd rank, Theorem 2 supplies genuine formal counterclasses;
- a non-tautological codimension-three class is not covered;
- dimension four is outside the stated theorem because no positive theta
  power kills the exceptional contribution automatically.

## 3. Jordan-scalar minimal-class theorem

Let `G` be an integral positive-definite symmetric coefficient matrix of
rank `g`.  At each prime choose a `p`-adic orthogonal Jordan decomposition

\[
                    G\simeq\bigperp_a p^aB_a,
\]

with every `B_a` symmetric unimodular of rank `d_a`.  Call a self-dual
overlattice of the associated two-copy symplectic lattice
**Jordan-scalar** if, on each block, its two multiplicity directions are
uniformly rescaled by

\[
                    p^{-(a-k_a)},\qquad p^{-k_a}
                    \quad(0\le k_a\le a).
\]

> **Jordan-scalar minimal-class theorem.**  Let `(A,Theta)` be the
> principally polarized elliptic-power quotient defined by such a gluing at
> every prime.  Then
> \[
>       \frac{\Theta^{g-1}}{(g-1)!}
>       \in\operatorname{im}\bigl(
>       \operatorname{Sym}^{g-1}\operatorname{NS}(A)
>       \longrightarrow H^{2g-2}(A,\mathbf Z)\bigr).
> \]
> Hence the integral minimal class is algebraic, with a signed
> divisor-product representative.

The scalar qualification is essential: the gluing must split along the
chosen Jordan blocks and rescale each entire block uniformly.  An
extension-field slope which acts non-scalarly on a discriminant heart is
outside the theorem.

### Root--weight corollary and exact census

For `N>=3`, set `g=N-1` and

\[
                       G_N=N I_g-J_g.
\]

Its Smith form is

\[
                       (1,N,\ldots,N),
\]

with `N` repeated `N-2` times.  At `p^a||N`, put

\[
 R=\mathbf Z/p^a,
 \qquad
 K_{p,k}=p^kR\times p^{a-k}R,
 \quad0\le k\le\lfloor a/2\rfloor.
\]

This is an isotropic subgroup of `R^2` of order `p^a`.  Up to swapping the
two multiplicity directions, these are the elementary-divisor types of
scalar local Lagrangians.  Tensoring them with the `N-2`-dimensional
root--weight discriminant module produces the scalar full-Weyl principal
overlattices.

The exact census reconstructs, for every tested case:

1. the principal integral symplectic lattice;
2. the full integral coefficient-matrix NS lattice;
3. every `(g-1)`-fold divisor monomial;
4. the lattice they generate in `H^{2g-2}`; and
5. the order of `Theta^{g-1}/(g-1)!` modulo that product lattice.

| axes `N` | local types | NS rank | divisor monomials | Hodge-span rank | minimal order |
|---:|---|---:|---:|---:|---:|
| 3 | `3:0` | 3 | 3 | 3 | 1 |
| 4 | `2:0` | 6 | 21 | 6 | 1 |
| 4 | `2:1` | 6 | 21 | 6 | 1 |
| 5 | `5:0` | 10 | 220 | 10 | 1 |
| 6 | `2:0,3:0` | 15 | 3,060 | 15 | 1 |
| 7 | `7:0` | 21 | 53,130 | 21 | 1 |

The independent replay uses a different algorithm: instead of enumerating
all symmetric monomials, it repeatedly wedges an integral HNF basis of the
current product lattice with the divisor basis.  It independently confirms
all cases through `N=6`, including both `N=4` types.

### Exact local proof

Let `N_K` be the integral NS lattice of a scalar Weyl gluing.  Under
Poincare duality, the product map is the mixed-adjugate polarization of the
determinant:

\[
 \operatorname{Sym}^{g-1}N_K
 \longrightarrow H^{2g-2}(A,\mathbf Z).
\]

> **Root--weight corollary.**  Let `N>=3`, `g=N-1`, and let
> `A_K` be any principally polarized integral symplectic lattice obtained
> from the root--weight sandwich with Gram matrix `G_N` by a scalar
> full-Weyl Lagrangian gluing of elementary type `K_{p,k}` at every
> `p^a||N`.  Then
> \[
>          \frac{\Theta^{g-1}}{(g-1)!}
>          \in \operatorname{im}\bigl(
>          \operatorname{Sym}^{g-1}\operatorname{NS}(A_K)
>          \longrightarrow H^{2g-2}(A_K,\mathbf Z)\bigr).
> \]
> In particular the integral minimal class has a signed
> divisor-product representative.

The proof reduces to the following local calculation.  Fix `p^a||N` and
write `d=N-2`.  Since `u=N-1` is a `p`-adic unit, Schur complementation in
the first coordinate gives

\[
 G_N\simeq \langle u\rangle\perp p^aB,
 \qquad
 B=\frac{N}{p^a}\bigl(I_d-u^{-1}J_d\bigr),
\]

where `B` is symmetric and unimodular over `Z_p`.  The scalar gluing
`K_{p,k}` replaces the two defective summands by

\[
              p^{-(a-k)}\mathbf Z_p^d,
              \qquad p^{-k}\mathbf Z_p^d.
\]

Consequently integrality of a symmetric coefficient matrix forces its
common--defect block to be divisible by `p^{a-k}` and its defect block by
`p^a`.  In particular the local Neron--Severi lattice contains

\[
       \mathbf Z_p E_{00}\ \oplus\ p^a\operatorname{Sym}_d(\mathbf Z_p).
\]

The polarization matrix is `diag(u,p^aB)`, whose cofactor is

\[
 \operatorname{diag}\bigl(p^{ad}\det B,
                  u p^{a(d-1)}\operatorname{adj}B\bigr).
\]

Both blocks lie in the mixed-adjugate image of the displayed
Neron--Severi sublattice.  Indeed the degree-`d` mixed determinant on
`Sym_d` contains scalar `1` via

\[
                         E_{11}\cdots E_{dd},
\]

and the degree-`d-1` mixed-adjugate map surjects integrally onto
`Sym_d`: it gives `E_{ii}` from

\[
                         \prod_{r\ne i}E_{rr}
\]

and gives `-(E_{ij}+E_{ji})` from

\[
              (E_{ij}+E_{ji})\prod_{r\ne i,j}E_{rr}.
\]

Multiplying these primitive identities by `det B` and the entries of
`u adj(B)` constructs the two cofactor blocks.  The cross block is zero.
This proof does not divide by `2`, so it also covers `p=2`, and it is
independent of `k`.

For normalization, if `omega_C` is the alternating two-form attached to
`C`, then

\[
 \omega_{C_1}\cdots\omega_{C_d}
 = [t_1\cdots t_d]\,\frac{(\sum t_i\omega_{C_i})^d}{d!}.
\]

Thus the squarefree mixed-determinant coefficient is the actual divisor
product: there is no residual factorial.  The off-diagonal construction has
coefficient `-1` in each symmetric position, not `-2`.  The direct Leibniz
script and independent polynomial-ring replay certify these identities
through `d=6`; the formulas above prove them for every `d`.

For the general Jordan-scalar theorem, the same calculation is blockwise.
The cross block from Jordan exponent `a` to exponent `b` must be divisible
by

\[
 p^{\max\{a-k_a+k_b,\ b-k_b+k_a,\ 0\}},
\]

but these cross blocks are unnecessary: the local Neron--Severi lattice
always contains

\[
                    \bigoplus_a p^a\operatorname{Sym}_{d_a}(\mathbf Z_p).
\]

On the target block `a`, the cofactor of `G` is

\[
 \left(\prod_{b\ne a}p^{bd_b}\det B_b\right)
 p^{a(d_a-1)}\operatorname{adj}B_a.
\]

Fill every non-target block with its primitive degree-`d_b` diagonal
mixed-determinant product, and fill the target with the primitive
degree-`d_a-1` mixed-adjugate units above.  Disjoint support introduces no
multinomial coefficient.  Summing over target blocks constructs
`adj(G)`.  The argument works unchanged for non-diagonal unimodular
`B_a` and for `p=2`.

At primes where `G` is unimodular the local statement is immediate.
Membership at every localization implies integral membership in the global
product lattice, proving the Jordan-scalar theorem and its root--weight
corollary.

The former local gate is therefore closed:

> **Prime-power mixed-adjugate lemma.**  For every `p^a||N` and every
> elementary type `K_{p,k}`, the integral image of the polarized determinant
> on the local NS congruence lattice contains the identity cofactor, i.e. the
> local minimal class.

The exact `N=4,k=1` calculation remains the first noncyclic finite check and
passes.  The earlier dense `N=8` HNF attempt was stopped, but is now
unnecessary: the local proof covers `N=8` and all higher `N` symbolically.
A literature audit is required before presenting the theorem as new; the
root/weight lattice and determinant formalism themselves are classical.

## 4. Full Weyl symmetry and extension-field slopes

The full permutation heart explains why the exotic cubic packet is a
symmetry-restriction phenomenon.

For `p|N`, let

\[
 H_{N,p}=\{(x_1,\ldots,x_N):\sum x_i=0\}/\langle(1,\ldots,1)\rangle.
\]

It has dimension `N-2`.  The elementary centralizer calculation gives

\[
                  \operatorname{End}_{S_N}(H_{N,p})=\mathbf F_p.
\]

Thus the full Weyl group sees only scalar rational slopes.  If a subgroup
`G` makes the heart simple with

\[
                  \operatorname{End}_G(H)=\mathbf F_{p^2}
\]

and the field acts self-adjointly for the discriminant pairing, the simple
transverse `G`-stable maximal isotropics are `P^1(F_{p^2})`.  The subgroup
`PGL_2(F_p)` has two orbits:

\[
 P^1(\mathbf F_p),\quad
 P^1(\mathbf F_{p^2})\setminus P^1(\mathbf F_p),
\]

of sizes `p+1` and `p(p-1)`.  The replay verifies this for
`p=2,3,5,7` and verifies scalar full-Weyl commutants for every `p|N`,
`4<=N<=12`.

### Building-language correction

The five `P^1(F4)` gluings are **not literally** the link of a vertex in the
Bruhat--Tits building of the rational `A5` centralizer.  The rational
five-dimensional `A5` representation remains absolutely irreducible at two,
so its rational commutant is `Q2`, whose ordinary rank-two building link has
`P^1(F2)`, not `P^1(F4)`.

The `F4` appears only in the modular commutant of the discriminant heart.
Therefore the exact object is a finite discriminant-module gluing geometry,
or a residue correspondence for `A5`-stable self-dual lattices, not the full
link of a group over an unramified quadratic coefficient field.  The
inclusion

\[
                    P^1(F2)\subset P^1(F4)
\]

and the interpretation of the exotic pair as the two points outside the
full-Weyl triple are correct combinatorially.  Calling all five points a
literal 2-adic building link would overstate the rational structure.

## 5. Deck norms and the limitation of one mod-two obstruction

Let `q:X->Y` be a finite flat double cover.  On Chow groups,

\[
                     q_*q^*=2.
\]

Hence

\[
                 \operatorname{CH}(Y)/q_*\operatorname{CH}(X)
\]

has exponent at most two.  If `sigma` is the deck involution, then upstairs

\[
                     q^*q_*=1+\sigma,
\]

and the invariant norm-halving obstruction lies in

\[
 \widehat H^0(C_2,\operatorname{CH}(X))
 =\operatorname{CH}(X)^\sigma/(1+\sigma)\operatorname{CH}(X),
\]

also of exponent two.

For a tower of `r` double covers, the total push-pull identity is

\[
                       q_*q^*=2^r.
\]

Thus every norm index divides `2^r`.  The bound is sharp already for the
trivial module `Z` with each norm equal to multiplication by two.  More
generally every pattern of successive binary obstructions can be realized
by direct sums of trivial and induced modules.

This gives an exact algorithm for a finitely generated explicit cycle
lattice:

1. compute the deck action and the norm matrix;
2. use Smith form to decide the class in the exponent-two Tate quotient;
3. if it vanishes, choose a lift and repeat at the next stage.

A single mod-two functional can prove that the first obstruction is nonzero,
and therefore that the total index is even.  It cannot distinguish exact
index two from four or higher: the modules with norm matrices `[2]` and
`[4]` have the same first mod-two vanishing image but different integral
indices.  Higher bounds require a fresh obstruction after each lift.

For Paper V this means residual `C3` averaging and a single `J[2]` class
cannot settle descent through the exotic order-two deck.  The obstruction
must be computed in the actual Chow/norm quotient or in a realization known
to inject on its Tate cohomology.

## 6. Algorithmic impossibility compiler

Theorem 1 and Theorem 3 give a short decision procedure for universal-sheaf
searches in codimension three.

Input:

1. virtual ranks `r_i`;
2. the image of the integral degree-one twist kernel in `H^2(M,Z)/2`;
3. a mod-two linear functional `lambda` on `H^6(M,F2)`;
4. checks that `lambda(dz)=0` for invariant divisors and
   `lambda(Sq^2z)=0` for all degree-two classes.

If one rank is odd, the output is a proof that `lambda` annihilates every
formal integral twist-invariant codimension-three Chern expression.  No
degree-three invariant enumeration is required.  If all ranks are even,
Theorem 2 gives the exact dimension of the residual search space that still
must be tested.

This is the useful algorithmic application of the “single obstruction”:
one Wu functional rules out an infinite family of formulas.  Its hard limit
is equally clear.  It says nothing about non-tautological cycles, and in a
deck tower it gives only the first two-adic bit.

## 7. A5-invariant and exotic-deck presentation gates

Two proposed 3,060-monomial compressions are **not completed**:

1. whether the minimal class has a primitive `A5`-invariant preimage in
   `Sym^4 NS` under cup product;
2. whether the fixed integral divisor presentation can be chosen invariant
   under the exotic deck exchange `omega <-> omega^2`.

The existing fourth-power orbit scan only gives multiples
`72c,432c,1440c`; it does not compute the full mixed-monomial invariant
image.  A brute-force Reynolds-norm attempt on all mixed monomials was
stopped as unbounded and removed from the artifact set.

The universal-sheaf formal parity wall does **not** kill the second question:
it concerns Chern expressions on the theta resolution, whereas deck
invariance of the already-proved divisor identity is a different integral
descent problem.  The deck presentation gate therefore remains open.  A
correct next computation should work representation-theoretically in the
mixed-adjugate image or solve the invariant-domain lattice via modular
decomposition, not average 3,060 dense wedge products naively.

## 8. Replay bundle

Commands:

```bash
cd /home/tavis/src/othello

diff -u notes/2026-08-10-c904-pascal-parity-classification.out \
  <(uv run python notes/2026-08-10-c904-pascal-parity-classification.py)

diff -u notes/2026-08-10-c904-weyl-heart-extension-gluing.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-weyl-heart-extension-gluing.sage").read()))')

diff -u notes/2026-08-10-c904-root-weight-minimal-class.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-root-weight-minimal-class.sage").read()))')

diff -u notes/2026-08-10-c904-root-weight-minimal-class-replay.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-root-weight-minimal-class-replay.sage").read()))')

diff -u notes/2026-08-10-c904-root-weight-local-mixed-adjugate.out \
  <(uv run python \
    notes/2026-08-10-c904-root-weight-local-mixed-adjugate.py)

diff -u notes/2026-08-10-c904-root-weight-local-mixed-adjugate-replay.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-root-weight-local-mixed-adjugate-replay.sage").read()))')
```

The primary root--weight certificate enumerates every symmetric divisor
monomial.  Its replay uses degree-by-degree integral HNF closure, providing
an independent product-generation algorithm through `N=6`.
The local mixed-adjugate certificate uses the Leibniz formula directly; its
independent replay extracts squarefree coefficients in a Sage polynomial
ring.  Both verify the primitive diagonal and off-diagonal normalization
through block rank six.  The general proof is the matrix-unit identity
printed in Section 3, not an extrapolation from this finite check.

| artifact | bytes | SHA256 |
|---|---:|---|
| `2026-08-10-c904-pascal-parity-classification.py` | 7,529 | `33145fda74c9f19ceffb8d9f0a8b324291631a1ed4f05768399e3f6dc26c04b3` |
| `2026-08-10-c904-pascal-parity-classification.out` | 1,135 | `4d1fd0e2900e1c9a207f32c58c94a87feb913104f8454a60a02955c01da9b74a` |
| `2026-08-10-c904-weyl-heart-extension-gluing.sage` | 4,768 | `43dde21085a195efd1fd8654e7899419d2d8ac991a7772cd817f63fa36fe3980` |
| `2026-08-10-c904-weyl-heart-extension-gluing.out` | 466 | `57e1ef348f16bf3dc9252813e5b37906002a4e68fc065c397d9cb6e91627f958` |
| `2026-08-10-c904-root-weight-minimal-class.sage` | 7,217 | `a10f611ddc9a5eeecfc9b15ed1b0e7f77b36dd4dc317386c1653b35976cb7cae` |
| `2026-08-10-c904-root-weight-minimal-class.out` | 610 | `144bdc178e18d9b9de374c26d5bfd3fa52d1dd0c5392f3d682f9a749407d499c` |
| `2026-08-10-c904-root-weight-minimal-class-replay.sage` | 3,333 | `26bd0db292a78d153134f926c9cff4df72eeb9d05b5fbee7f21b3a962bb143bc` |
| `2026-08-10-c904-root-weight-minimal-class-replay.out` | 250 | `1221d3ca781fce2592b582df168d59e1bf65a1ac21f2805986798037245c5c58` |
| `2026-08-10-c904-root-weight-local-mixed-adjugate.py` | 3,632 | `d06959a9b7b09993b6a48d0390453de85d762ee5e55ae21eb56a2df9fc5946a3` |
| `2026-08-10-c904-root-weight-local-mixed-adjugate.out` | 374 | `07b40586c76b50a0e3c7a91a251017beef1ae1dbdd4917e205cb3bcd3851b27e` |
| `2026-08-10-c904-root-weight-local-mixed-adjugate-replay.sage` | 2,297 | `7d5d029241e51bdfe9abbc21694c501f43ff8a2091ca937976016796d5e05143` |
| `2026-08-10-c904-root-weight-local-mixed-adjugate-replay.out` | 355 | `0b9e89eaa96e6f02e82272508b65d539aab1e0682334c41da659bd7c6904b31e` |

## 9. Recommended next order

1. Run the literature audit for the Jordan-scalar minimal-class theorem,
   especially integral minimal cycles on elliptic-power isogeny quotients.
   The proof is closed; novelty is now the decisive gate.
2. Audit the odd-rank Pascal dichotomy and resolved-theta Wu theorem.  Their
   ingredients are standard, but the combined obstruction statement may be
   useful and possibly new.
3. Classify how far the minimal-class argument extends beyond Jordan-scalar
   gluings.  The exotic `F_4` cubic pair is the first exact non-scalar test.
4. Treat the `A5`-invariant and exotic-deck presentations by modular
   invariant-domain linear algebra.  Do not return to dense Reynolds wedge
   enumeration.

The broadest current proved theorem in this note is the Jordan-scalar
minimal-class theorem; the sharpest uniform obstruction is the odd-rank
Pascal--Wu theorem.

## 10. `ej` + `tt` closeout and mystery ledger

The closeout pass changed the priority order twice.  First it turned the one
cubic-threefold parity calculation into the exact odd-rank/all-even Pascal
dichotomy.  Then the cofactor viewpoint closed the prime-power gate and
lifted the root--weight census to the Jordan-scalar theorem.  The next
Tao-style question is where the scalar hypothesis actually breaks: classify
the non-scalar discriminant gluings for which the same primitive cofactor
still lies in the divisor-product image.

- **Settled:** one odd virtual rank annihilates the formal degree-three
  obstruction quotient.  **Mystery:** which all-even residual classes are
  realized by geometric universal families?  The exact evidence gap is the
  absence of a realization map from the formal invariant ring to Chow.
- **Settled uniformly:** every Jordan-scalar elliptic-power principal quotient
  has an integral divisor-product preimage of the minimal class.  This covers
  every scalar root--weight gluing, including `N=8` and all higher `N`; the
  stopped dense `N=8` census is unnecessary.  **Mystery:** novelty and the
  optimal hypothesis.  The exact gates are the literature audit and the
  first non-scalar local classification.
- **Settled:** `P^1(F_4)` is discriminant-module gluing geometry, not literally
  the Bruhat--Tits link of the rational `A5` commutant.  **Mystery:** whether
  analogous extension-field packets recur uniformly after restricting Weyl
  symmetry.  The missing input is a classification of modular heart
  commutants and self-dual lifts.
- **Open and separate:** an `A5`-invariant `Sym^4 NS` preimage and an
  exotic-deck-invariant presentation of the 3060-monomial certificate were
  not computed.  The formal universal-sheaf parity wall does not decide this
  divisor-descent question.  The owning next method is modular
  invariant-domain linear algebra, not another dense Reynolds enumeration.
- **Sharp limitation:** a single mod-two norm obstruction sees only the first
  bit of a double-cover tower.  Distinguishing index `2` from `4` or higher
  requires a successive-stage lift/Bockstein or integral Smith computation;
  no stronger conclusion follows from the present parity functional alone.
