# C904 universal-sheaf tautological parity wall

Date: 2026-08-10
Status: exact negative theorem for formal twist-invariant lambda/Chern
expressions through codimension three
Scope: no manuscript or Lean edit

## Verdict

The proposed universal-sheaf `c_3` bypass does not reach the primitive
theta curve class.

Let

\[
 M=M_X(v)=\operatorname {Bl}_0\Theta,
 \qquad
 v=\left(3,-H,-\frac12H^2,\frac16H^3\right),
\]

and let `E` be any universal sheaf on `M times X`.  Form index complexes

\[
                    T_u=R\pi_{M*}(E\otimes u),
                    \qquad u\in K_{\rm alg}(X).
\]

Consider any integral codimension-three lambda/Chern expression in the
`T_u` which is formally unchanged when `E` is replaced by
`E tensor p_M^*L`.  Its mod-two class is a sum of terms of the forms

\[
                         d z,
                 \qquad \operatorname {Sq}^2z,
\]

where `d` is a twist-invariant divisor class and `z` is an integral
codimension-two tautological class.  Every such term has even degree against
the pullback `h` of `Theta`:

\[
                         \int_M h\,dz\equiv0,
                 \qquad \int_M h\,\operatorname {Sq}^2z\equiv0\pmod2.
\]

The minimal curve class pushes to

\[
                          c=\frac{\Theta^4}{4!},
                 \qquad \Theta c=5,
\]

so no class in this universal-sheaf tautological ring can push to `c`.

In particular the apparently promising normalized rank-one class

\[
              \gamma_u=c_3(T_u)+c_1(T_u)c_2(T_u)
\]

is not an escape: modulo two it is exactly

\[
                         \operatorname {Sq}^2c_2(T_u),
\]

and therefore has even theta degree.

This closes the formal universal-sheaf `c_3`/determinant/lambda route.  It
does not classify a polynomial which becomes invariant only after using
unknown evaluated relations on `M`, nor arbitrary non-tautological Chow
correspondences.

## 1. Complete mod-two invariant census

Use the integral numerical `K`-basis

\[
                 O_X,\quad O_H,\quad O_l,\quad O_p.
\]

The corresponding index complexes have virtual ranks

\[
                              (0,0,2,3).
\]

This follows directly from Riemann--Roch; the tensor Euler matrix in this
basis is unimodular, so these four classes exhaust `K_alg(X)` rather than a
finite-index sublattice.

Write `a_i,b_i,c_i` for the first three Chern classes of the four index
complexes.  Under a simultaneous line twist with `ell=c_1(L)`, the standard
formula

\[
 c_k(T_i\otimes L)
   =\sum_{j=0}^k {r_i-j\choose k-j}c_j(T_i)\ell^{k-j}
\]

defines an action on the weighted polynomial ring, with weights one, two
and three on `a_i,b_i,c_i`.

Exact row reduction over `F_2` gives:

| weighted degree | monomials | invariant dimension |
|---:|---:|---:|
| 1 | 4 | 3 |
| 2 | 14 | 10 |
| 3 | 40 | 26 |

The span of all products

\[
      (\text{degree-one invariant})(\text{degree-two invariant})
\]

together with all `Sq^2` images of degree-two invariants already has rank
26.  Hence the residual degree-three invariant quotient is zero.  Divisor
cubes are included in the first family.

This calculation is complete for formal integral lambda-ring expressions:
through codimension three every such expression is an integral polynomial
in the first three Chern classes, and every numerical `K`-class is an
integral combination of the four chosen generators.  An integral invariant
necessarily reduces to one of the mod-two invariants just enumerated.

## 2. The geometric parity identity

Let `f:M->Theta` be the resolution, let `h=f^*Theta`, and let `e` be the
exceptional divisor.  The theta divisor has multiplicity three at the
origin.  In the blowup of the fivefold `J` one has

\[
 K_{\operatorname {Bl}_0J}=4E,
 \qquad [M]=h-3E,
\]

so adjunction gives

\[
                              K_M=h+e.
\]

Thus

\[
                           w_2(M)=h+e\pmod2.
\]

Moreover `h|_e=0`, and `h^2` is divisible by two in integral cohomology:
for a principal symplectic theta class, the square of the integral
alternating form is twice its divided square.

For any integral degree-four class `z`, Cartan and Wu give

\[
\begin{aligned}
 \int_M h\operatorname {Sq}^2z
   &=\int_M\operatorname {Sq}^2(hz)+h^2z\\
   &=\int_Mw_2(M)hz+h^2z\\
   &=\int_M(h+e)hz+h^2z=0\pmod2.
\end{aligned}
\]

The cancellation is not special to the cubic intermediate Jacobian.  If a
theta divisor in a principally polarized `g`-fold has an isolated point of
multiplicity `m` whose blowup strict transform `Y` is smooth, then

\[
 K_Y=h+(g-1-m)e,
 \qquad h|_e=0,
 \qquad h^2\in2H^4(Y,\mathbf Z).
\]

The identical Wu calculation proves

\[
       \int_Y h\operatorname {Sq}^2z=0\pmod2
       \quad\text{for every }z\in H^{2\dim Y-4}(Y,\mathbf Z/2).
\]

Thus the Steenrod-square parity wall is a uniform resolved-theta lemma; the
special C904 computation is the invariant-ring statement forcing all
universal-sheaf candidates into its scope.

Every determinant divisor obtained from a numerical class on `X` is
`A_5`-invariant.  The invariant Neron--Severi lattice on the marked generic
fibre is generated by `h` and `e`: the only `A_5`-invariant Rosati-symmetric
class on `J` is the principal polarization, and the blowup adds the
exceptional class.  Hence `d=ah+be`, and

\[
                    \int_M hdz
                       =a\int_Mh^2z+b\int_Mhez=0\pmod2.
\]

The same conclusion holds after specialization because the determinant
classes and the displayed cohomological identities are relative.  No
claim is made for a manually adjoined special-fibre divisor outside the
numerical universal-sheaf tautological ring.

`2026-08-10-c904-universal-parity-wall-followup-audit.md` checks both
integral points exactly: `H^2(M,Z)^A5=Zh+Ze` is saturated, and the integral
degree-one twist kernel for ranks `(0,0,2,3)` reduces onto the entire
three-dimensional mod-two degree-one invariant space.  Thus no hidden
half-divisor or missing integral determinant coset can evade the argument.

## 3. Replay

Primary replay, from `/home/tavis/src/othello`:

```sh
uv run python notes/2026-08-10-c904-universal-sheaf-twist-invariants.py
```

Independent Sage replay:

```sh
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-universal-sheaf-twist-invariants-replay.sage").read()))'
```

The primary implementation uses sparse bitsets and a hand-written binary
row reduction.  The independent implementation uses a Sage polynomial ring
and Sage matrix kernels.  Both enumerate all 4, 14 and 40 weighted
monomials and return the same invariant dimensions and zero residual
quotient.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-universal-sheaf-twist-invariants.py` | 8,083 | `883bb7446c8e4e1eb19c973e3afb7803bd46a964990ec03716283f90e4832993` |
| `notes/2026-08-10-c904-universal-sheaf-twist-invariants.out` | 258 | `f7dc7d68ca5c0855cc6b673fd04ecd91db69b09f9b71c3c5aa0dbbdef58f4ce7` |
| `notes/2026-08-10-c904-universal-sheaf-twist-invariants-replay.sage` | 4,731 | `322b1aacaec6b7642305633102bdd1aba3841b8b7e85ec8069a8bc639b8ec9ef` |
| `notes/2026-08-10-c904-universal-sheaf-twist-invariants-replay.out` | 258 | `f7dc7d68ca5c0855cc6b673fd04ecd91db69b09f9b71c3c5aa0dbbdef58f4ce7` |

The outputs are compared byte-for-byte with the tracked expected outputs.
The computation certifies the formal invariant-ring statement; the Wu
parity deduction is the proof above, not a finite enumeration of Chow
classes.

An auxiliary exact SymPy diagnostic reconstructs the unimodular numerical
`K`-lattice and the external-product matrix for the universal Ext complex,
then expands the bidegree `(1,3)` part of `c_4(-W)`.  It confirms the rank
vector `(0,0,2,3)` and the exact coefficient relation `C2=3Q`, `C3=-2Q`.
This calculation is not load-bearing for the parity theorem; it records why
the direct diagonal expansion also exposes the same factor two.

```sh
uv run --with sympy python \
  notes/2026-08-10-c904-universal-ext-bidegree.py
```

| auxiliary file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-universal-ext-bidegree.py` | 4,159 | `909f5ee38c041edaf9086e46ee92e0d9b3f105d9724b60f1577b69cae075593f` |
| `notes/2026-08-10-c904-universal-ext-bidegree.out` | 648 | `7fbf0c0c082a8d2893d84c98bf2096d7d906b74e9d42eb6a7b1b5284477003f4` |

There is no second implementation of this diagnostic expansion: its only
inputs are the four printed Riemann--Roch matrices, and none of its
coefficient-content conclusions is used to prove the invariant-ring or Wu
statements, both of which have independent checks above.

## 4. Consequence for the Annals gate

The universal-sheaf idea was the last natural way to remove the factor two
using only integral `c_3` and determinant normalization.  It dies for a
structural reason: the codimension-three invariant ring is generated,
modulo two, by precisely the two operations annihilated by the theta-degree
Wu identity.

The primitive-theta gate therefore remains genuinely non-tautological.  A
successful class must use primitive theta cohomology, an intrinsic Chow
correspondence not generated by index Chern classes, or an actual odd
descent of the fixed-fibre Shen/Fano carrier.

## Mystery ledger

- **Settled:** the normalized rank-one `c_3` candidate has even theta degree.
- **Settled:** no other formal twist-invariant integral lambda/Chern
  expression through codimension three evades that parity.
- **Settled:** the factorial two in the standard Chern-character argument
  reflects a genuine mod-two Wu wall, not merely a poor normalization.
- **EJ/TT settled:** the Wu cancellation is uniform for smooth blowup
  resolutions of isolated theta singularities; C904 is special only in the
  invariant-ring generation that makes the lemma exhaustive.
- **Open:** non-tautological primitive theta cycles and relative Chow
  descent of the fixed-fibre unordered Shen carrier.
