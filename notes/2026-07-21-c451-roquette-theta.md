# C451 / T4 — Roquette matching Lagrangians and the theta judgment gate

**Lane:** `crowns`

**Date:** 2026-07-21

**Status:** pre-theta computations complete; mandatory theta-model judgment gate not crossed

## Exact pre-gate result

For the smooth hyperelliptic curve

```text
C_q : y^2 = x^q - x,                 q in {5,7,11},
```

the branch set is `B=P^1(F_q)`, of size `q+1=2g+2`, where `g=(q-1)/2`.  The certificate uses the
standard model

```text
J(C_q)[2] = {even subsets of B} / (S ~ B-S),
<S,T> = |S intersect T| mod 2.
```

For every frozen perfect matching `M`, the classes of its edges span a `g`-dimensional isotropic
subspace `L_M`, hence a Lagrangian.  The only relation among the `g+1` edge classes is their sum,
the class of all of `B`.  Every frozen `PSL_2(q)` sheet is therefore a packing of `q`
matching-Lagrangians whose distinguished Weierstrass pair classes partition all
`binom(q+1,2)` pairs exactly once.

The complete packing-incidence calculation is:

| type | `q` | genus | sheets | unordered pairs within each sheet by `dim(L_M intersect L_N)` |
|:---|---:|---:|:---:|:---|
| A3 | 5 | 2 | one of size 5 | `0^10` |
| B3 | 7 | 3 | two of size 7 | `1^21` on each sheet |
| H3 | 11 | 5 | two of size 11 | `1^55` on each sheet |

Thus the A3 factorization gives five pairwise-transverse Lagrangians.  In B3 and H3, every two
same-sheet matchings have a two-component alternating union, and their Lagrangians meet in the
line represented by either component.  Linear algebra in the even-subset quotient and the
independent alternating-cycle formula agree on every pair.

For the Cartier--Manin computation, write `m=(q-1)/2`.  The support of

```text
(x^q-x)^m = sum_(k=0)^m binom(m,k)(-1)^(m-k) x^(m+(q-1)k)
```

contains no exponent `qi-j` with `1 <= i,j <= m`: modulo `q-1`, such an equality would require
`i-j` to equal `m`, but `|i-j| <= m-1`.  In the convention

```text
H[i,j] = coefficient of x^(q(i+1)-(j+1)),
```

the Cartier--Manin matrices are therefore the zero matrices of sizes `2`, `3`, and `5` at
`q=5,7,11`.  Each Jacobian has `p`-rank zero and `a`-number `g`; equivalently it is superspecial,
and in particular supersingular.

## Mandatory theta-model judgment gate

Mumford, *Tata Lectures on Theta II*, Chapter IIIa, Proposition 6.1, pp. 106--108 of the
[author-hosted PDF](https://www.dam.brown.edu/people/mumford/alg_geom/papers/Tata2.pdf), gives the
hyperelliptic subset model proposed for the post-gate calculation.  In present notation its theta
characteristics are

```text
kappa_T = sum_(b in T) W_b + ((g-1-|T|)/2) L,
|T| = g+1 mod 2,                       T ~ B-T,
```

and, after replacing `T` by its complement so that `|T| <= g+1`,

```text
h^0(kappa_T) = (g+1-|T|)/2.
```

Mumford's displayed proof is divisor-theoretic; its use here requires only the separable
hyperelliptic double cover in odd characteristic.  The proposed marked judgment is:

1. accept this algebraic subset/divisor model over the algebraic closure of `F_q`;
2. for odd `g` (`q=7,11`), use the full-branch-symmetry-invariant characteristic `kappa_empty`;
3. use its Riemann--Mumford quadratic refinement
   `Q([S])=h^0(kappa_S)+h^0(kappa_empty)=|S|/2 mod 2`;
4. record that at `q=5`, where `g+1` is odd, no empty-subset characteristic and hence no
   full-`PGL_2(5)`-invariant origin exists; A3 has only one packing and supplies no sheet test.

If this gate is marked approved, the final certificate will enumerate the quadratic identity and
Arf invariant, evaluate `Q` on every packing intersection and Lagrangian restriction, and issue the
literal row verdict.  The anticipated finite values are deliberately not certified before the
gate.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c451-roquette-theta.py --check
sha256sum -c notes/2026-07-21-c451-roquette-theta.sha256
```

Intentional regeneration is the same checker with `--write`.  The checker independently rebuilds
`PSL_2(q)` and `PGL_2(q)` from prime-field matrices, reconstructs the frozen matching orbits, and
checks the packing incidences both by quotient-space rank and by alternating-union components.  It
computes the Cartier--Manin coefficients directly and also checks their vanishing.  Its
load-bearing frozen input is C406's canonical matching-orbit certificate, pinned by SHA-256 in the
output.  No theta parity is computed while `theta_gate.crossed` is false.

The trusted boundary is exact prime-field and binary linear algebra, the frozen C406 endpoint/base
matching conventions, the standard even-subset description of hyperelliptic `J[2]`, and the
Cartier--Manin coefficient formula.  The bundle does not yet certify a theta parity, an Arf value,
or a row-survives/row-dies verdict.
