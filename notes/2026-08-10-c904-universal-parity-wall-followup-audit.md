# C904: determinant-divisor saturation and the exact formal parity scope

Date: 2026-08-10
Status: bounded follow-up; no manuscript or Lean edits
Scope: the two possible loopholes in the universal-sheaf codimension-three
parity wall

## Verdict

The divisor part of the Wu argument has no hidden half-index.  On

\[
             M=\operatorname{Bl}_0\Theta\longrightarrow J
\]

the full integral invariant lattice is

\[
                 H^2(M,\mathbf Z)^{A_5}
                    =\mathbf Z h\oplus\mathbf Z e,
\]

where `h` is the pullback of the principal theta class and `e` is the
exceptional divisor.  This is a saturated direct sum, not merely a
finite-index sublattice of the invariant Neron--Severi group.

The exact determinant-rank calculation is also favorable.  For the four
numerical index classes with ranks `(0,0,2,3)`, the integral degree-one
twist-invariant lattice is

\[
 \ker(0,0,2,3)
 =\langle a_0,a_1,3a_2-2a_3\rangle.
\]

Its reduction modulo two is the entire three-dimensional formal invariant
space `span(a0,a1,a2)`.  Thus every mod-two divisor factor occurring in the
degree-three census has an integral twist-invariant lift, whose NS class is
`a h+b e`.  There is no missing divisor coset that could make the theta
degree odd.

The mod-two normal-form statement is correct with one essential scope word:
it is a theorem about **formal universal Chern polynomials** invariant under
simultaneous line twist.  It does not classify extra classes that become
invariant only after evaluating on `M` and using unknown relations in its
tautological/cohomology ring.  Within its stated formal scope, the two exact
implementations prove

\[
 R^{(3)}_{\rm inv}
 =R^{(1)}_{\rm inv}R^{(2)}_{\rm inv}
   +\operatorname{Sq}^2(R^{(2)}_{\rm inv})
 \quad\text{over }\mathbf F_2.
\]

The degree-two factor need not itself have an integrally twist-invariant
lift.  It only needs an integral polynomial lift as a cohomology class, which
always exists and is enough for Cartan--Wu.  Wording it as an “integral
twist-invariant codimension-two class” would be stronger than the replay
proves and is unnecessary.

## 1. The invariant divisor lattice is saturated

The certified exotic principal lattice gives the actual rank-fifteen
Neron--Severi lattice of the generic marked `A5` intermediate Jacobian.  An
exact integral kernel calculation for the two `A5` generators gives

\[
                     NS(J)^{A_5}=\mathbf Z\Theta,
\]

and the theta vector is primitive in that lattice.

The stronger calculation on all 45 integral alternating two-forms gives

\[
                     H^2(J,\mathbf Z)^{A_5}=\mathbf Z\Theta.
\]

Thus the result does not depend on asserting that the known rank-fifteen
divisor lattice remains the complete NS group after a special
specialization.

For the theta resolution, the integral homology sequence already used in
the resolution audit is

\[
 0\longrightarrow\mathbf Z[\ell]
 \longrightarrow H_2(M,\mathbf Z)
 \longrightarrow H_2(J,\mathbf Z)\longrightarrow0,
\]

where `ell` is a line in the exceptional cubic.  Since
`e.ell=-1`, dualizing gives the integral splitting

\[
 H^2(M,\mathbf Z)=f^*H^2(J,\mathbf Z)\oplus\mathbf Z e.
\]

The `A5` action fixes the contraction and the exceptional divisor.  Taking
invariants and using the exact computation on `J` gives

\[
 H^2(M,\mathbf Z)^{A_5}=\mathbf Z h\oplus\mathbf Z e.
\]

There is no possible class `(h+e)/2`: its pairing with `ell` would be
`-1/2`.  More invariantly, the displayed cohomology decomposition is already
an integral direct sum.  Both generators are primitive: theta is primitive
on the principally polarized lattice, and `e.ell=-1` makes `e` primitive.

Consequently

\[
                  NS(M)^{A_5}=\mathbf Z h\oplus\mathbf Z e
\]

as well.  This includes the generic marked fibre and remains true for the
topological `A5` family even at fibres where non-invariant NS classes jump.

## 2. Which determinant divisors are invariant

Let `T_i=R pi_*(E tensor u_i)` for the numerical `K`-basis
`O_X,O_H,O_l,O_p`.  Its rank vector is `(0,0,2,3)`.  Replacing the universal
family by `E tensor L` sends

\[
                  c_1(T_i)\longmapsto c_1(T_i)+r_i c_1(L).
\]

Therefore an integral determinant combination `sum n_i c1(T_i)` is
independent of the universal-family twist exactly when

\[
                         2n_2+3n_3=0.
\]

The kernel is saturated because `gcd(2,3)=1`, and an exact Smith/kernel
calculation gives the basis

\[
                  a_0,\quad a_1,\quad3a_2-2a_3.
\]

Modulo two these become `a0,a1,a2`, precisely the full degree-one invariant
space in the formal census.  Hence the use of an integral invariant divisor
`d` in the parity proof is justified.

There is a small equivariance nuance.  A universal sheaf need not carry a
chosen `A5` linearization, and choosing an individual line in the numerical
`K`-basis can change a determinant bundle by `Pic^0`.  What is canonical and
needed here is the **NS/cohomology class** of an integrally twist-invariant
combination.  Numerical `K(X)` is fixed by `A5`; the ambiguity of the
universal family contributes the rank vector and cancels in the kernel.
Thus its NS class is `A5`-invariant and lies in `Zh+Ze`.  A possible `Pic^0`
translation has zero first Chern class and cannot affect the theta-degree
pairing.  One should not claim that every individual nonzero-rank
determinant line is canonically `A5`-linearized.

## 3. Independent assessment of the mod-two normal form

Let `R` be the weighted polynomial algebra over `F2` on

\[
 a_i=c_1(T_i),\qquad b_i=c_2(T_i),\qquad c_i=c_3(T_i),
\]

of weights one, two and three.  The symbolic line-twist substitution is the
standard splitting-principle identity

\[
 c_k(T_i\otimes L)
 =\sum_{j=0}^k {r_i-j\choose k-j}c_j(T_i)\ell^{k-j}.
\]

The primary bitset implementation and the independent Sage polynomial-ring
implementation both compute:

| weight | monomials | invariant dimension |
|---:|---:|---:|
| 1 | 4 | 3 |
| 2 | 14 | 10 |
| 3 | 40 | 26 |

They then form all products of a weight-one invariant with a weight-two
invariant and all `Sq^2` images of weight-two invariants.  This span has rank
26, equal to the full invariant subspace.  The residual quotient is zero.

The implemented Steenrod formulas are the standard ones for reductions of
integral Chern classes:

\[
 \operatorname{Sq}^2c_2(V)=c_1(V)c_2(V)+c_3(V),
\]

and, by Cartan,

\[
 \operatorname{Sq}^2(xy)=x^2y+xy^2
 \quad(x,y\text{ integral divisor reductions}).
\]

They cover every weight-two monomial (`c2` or a product of two `c1`'s), so
there is no omitted formal operation in degree three.

Now start with an **integral formal** degree-three Chern/lambda polynomial
which is invariant under every line twist.  Reducing modulo two places it in
the enumerated 26-dimensional invariant space.  Each degree-one factor has
the integral twist-invariant lift proved in Section 2.  Each degree-two
polynomial has a tautological integral lift obtained by using coefficients
zero or one; it need not be twist-invariant over the integers.  Steenrod
squares and the parity pairing depend only on its mod-two class.

This proves exactly the normal form required by the Wu argument.  It does
**not** prove either of the following stronger statements:

1. every class in the evaluated degree-three tautological cohomology of `M`
   that happens to be invariant is represented by a formally invariant
   polynomial;
2. every non-tautological codimension-three algebraic class on `M` has this
   normal form.

Unknown relations after evaluation could enlarge the first invariant set.
The current no-go should therefore retain the qualifier “formal
twist-invariant integral lambda/Chern expression.”

## 4. Wu parity after the saturation check

Adjunction on the blowup gives

\[
                         K_M=h+e,
 \qquad w_2(M)=h+e\pmod2.
\]

Also `he=0` integrally because `h` is pulled back from the class contracted
at the exceptional divisor, and `h^2=0 mod 2` because the square of an
integral alternating theta form is twice its divided square.

For `d=ah+be` and any degree-four mod-two tautological class `z`,

\[
                 \int_M hdz=0\pmod2.
\]

For the Steenrod term, Cartan and Wu give

\[
\begin{aligned}
 \int_M h\operatorname{Sq}^2z
 &=\int_M\operatorname{Sq}^2(hz)+h^2z\\
 &=\int_M(h+e)hz+h^2z=0\pmod2.
\end{aligned}
\]

No half-integral invariant divisor is available to undermine either line.
Thus the parity theorem survives this follow-up intact within its formal
scope.

## 5. Exact replay

New divisor-lattice certificate:

```bash
cd /home/tavis/src/othello
diff -u notes/2026-08-10-c904-universal-determinant-divisor-invariants.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-10-c904-universal-determinant-divisor-invariants.sage").read()))')
```

It reconstructs the full exotic principal lattice, proves both
`NS(J)^A5=Z Theta` and `H^2(J,Z)^A5=Z Theta` integrally, and checks that the
integral determinant kernel surjects onto the entire degree-one mod-two
invariant space.

| new artifact | bytes | SHA256 |
|---|---:|---|
| `2026-08-10-c904-universal-determinant-divisor-invariants.sage` | 4,812 | `a5df80b7b3a872227d9859e89ccb7e7db4421d92a7ee535542909bbd43015b21` |
| `2026-08-10-c904-universal-determinant-divisor-invariants.out` | 396 | `f0b5ab19943a62058ff32551a3f38e878e8f2fff25a6a76d140985407df76228` |

The independent formal invariant-ring replays remain:

```bash
uv run python notes/2026-08-10-c904-universal-sheaf-twist-invariants.py

nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-universal-sheaf-twist-invariants-replay.sage").read()))'
```

The exact caveat is therefore geometric, not finite-algebraic: an evaluated
or non-tautological invariant outside the formal universal polynomial ring
is not covered.
