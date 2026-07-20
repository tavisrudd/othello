# C407 — six free arrangement-code upgrades

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `ACTIVE; UPGRADE 1 PROVED`

**Parent:** `notes/2026-07-20-c403-arrangement-complement-distance.md`

## Scope and notation

Let `A` be an essential arrangement of `N>0` projective lines in `PG(2,q)`.  Its
projective complement `B` is assumed to span the plane, `n=|B|`, and `D=D(A)` is the
projective `[n,3]_q` code whose columns are the points of `B`.  For a projective line
`L`, write

```text
s_L=|B cap L|,   f_s=#{L:s_L=s}.
```

If `A_w(D)` is the ordinary Hamming distribution, then

```text
f_s=A_(n-s)(D)/(q-1).
```

The statements below concern the complement-column matroid `M(B)`, except for the
scalar-extension theorem, which also uses C403's weighted 2-adjoint parallel-copy
matroid `M(B_A)`.  They do not make any invariant of the original arrangement matroid
`M(A)` determine the complement code.

## 1. Uniform scalar-extension enumerator

Let the arrangement equations and the indexed weighted-adjoint hyperplane list be
extended from `F_q` to `F_Q`, where `Q=q^e` and `e>=1`.  Denote the resulting
projective complement code by `D_Q`, put

```text
M=sum_X(m(X)-1),
```

and let `r_B` and `chibar_(B_A)(t,x)` be respectively the rank and coboundary
polynomial of the fixed indexed parallel-copy list.  Then, with `chi_A(t)` the fixed
characteristic polynomial,

```text
n_Q=chi_A(Q)/(Q-1),

P_(A,Q)(x)
  =(Q^(3-r_B) chibar_(B_A)(Q,x)-x^M)/(Q-1),

Z_(A,Q)(x)=P_(A,Q)(x)-N x^(N-1),

W_(D_Q)(z)
  =1+(Q-1)N z^n_Q
     +(Q-1) sum_delta [x^delta]Z_(A,Q)(x)
        z^(n_Q-Q-1+N-delta).
```

Consequently one characteristic polynomial and one weighted-adjoint coboundary
polynomial determine the complete Hamming enumerator over every finite scalar
extension of the fixed characteristic.

### Proof

Choose defining matrices over `F_q`.  The rank of every submatrix is the largest size
of a nonzero minor.  A minor belonging to `F_q` is nonzero over `F_q` exactly when it
is nonzero in `F_Q`; hence every subset rank, and therefore both represented
intersection lattices and `r_B`, are unchanged by scalar extension.  The finite-field
method applied over `F_Q` therefore gives the first displayed formula.

Because `B(F_q)` spans, it contains three projectively independent points.  Their
representatives remain independent and avoid every extended arrangement hyperplane,
so `B(F_Q)` still spans and `D_Q` still has dimension three.

For `v in F_Q^3`, let `h(v)` be the number of indexed weighted-adjoint hyperplanes
containing `v`, counted with their parallel-copy multiplicities.  Ardila's
finite-field coboundary identity for that same indexed list gives

```text
Q^(3-r_B) chibar_(B_A)(Q,x)=sum_(v in F_Q^3) x^h(v).
```

The zero vector has depth `M`.  Each nonzero projective point has exactly `Q-1`
representatives of the same depth.  Removing the zero term and projectivizing proves
the formula for `P_(A,Q)`.  Every one of the `N` original mirrors has weighted depth
`N-1`: on that mirror, `sum_X(m(X)-1)` counts each of the other mirrors exactly once.
Subtracting those indexed mirror points therefore gives `Z_(A,Q)`; this subtraction
does not assume that no other point has depth `N-1`.

For a nonmirror test line of depth `delta`, C403's incidence identity over `F_Q`
gives section size `Q+1-N+delta` and hence codeword weight
`n_Q-Q-1+N-delta`.  Every projective kernel line represents `Q-1` nonzero scalar
codewords.  The `N` mirror kernels have empty complement section and give the
full-weight term.  Summing the remaining depth classes proves the enumerator formula.

The quotient defining `P_(A,Q)` has integer coefficients for every actual
`Q=q^e`, because its coefficients count projective points after removal of the zero
vector.  No symbolic divisibility assertion by `t-1` is needed or claimed.

At `e=1` these four displays are exactly C403's base-field formulas.  For the three
C399 arrangements they give, uniformly in the fixed good characteristic,

| type | `N` | scalar-extension length `n_Q` | conic-phase base case |
|:---|---:|:---|:---|
| `A3` | 6 | `(Q-2)(Q-3)` | `q=5`, `n_q=6` |
| `B3` | 9 | `(Q-3)(Q-5)` | `q=7`, `n_q=8` |
| `H3` | 15 | `(Q-5)(Q-9)` | `q=11`, `n_q=12` |

The corresponding fixed weighted-adjoint coboundary polynomial supplies every
coefficient of each extension enumerator through the displayed specialization.  This
is scalar extension in one characteristic, not variation of an integral model across
good characteristics.  It also neither refines points by exact Frobenius degree nor
asserts the curve/zeta and exact-degree layer theorem of C389.

## Attribution and claim boundary

The proof uses the conventional finite-field method and Ardila's indexed
parallel-copy coboundary identity already source-closed in C403.  No novelty or
priority claim is made for this scalar-extension packaging, generalized weights,
matroid formulas, covering terminology, or minimal-codeword consequences.

