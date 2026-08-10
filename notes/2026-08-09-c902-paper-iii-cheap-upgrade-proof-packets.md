# C902 Paper III cheap-upgrade proof packets

Date: 2026-08-09

These packets support recommendations only.  They do not alter the Paper III
claim inventory.  Each packet records the smallest safe mathematical statement
and its failure boundary.

## Packet A: triangle--Pfaffian recognition

Let `k` be a subfield of the real numbers, let `n >= 4` be even, and let
`A=(a_ij)` be a symmetric `n`-by-`n` matrix with zero diagonal and every
off-diagonal entry nonzero.  Put

```
T_A(x) = sum_{|S|=3} (product_{i<j in S} a_ij) product_{i in S} x_i,
H_A(x) = Pf[D_x,A],
```

where `D_x=diag(x_1,...,x_n)` and `[D_x,A]=D_xA-AD_x`.  If
`H_A=mu T_A` for a nonzero scalar `mu`, then `n=6` and `A^2=lambda I` for some
nonzero `lambda`.

### Proof

The polynomial `H_A` is homogeneous of degree `n/2`.  Because all off-diagonal
entries of `A` are nonzero, `T_A` is a nonzero cubic.  Nonzero proportionality
therefore forces `n/2=3`, hence `n=6`.

The commutator is invariant under diagonal translation:

```
[D_{x+t1},A]=[D_x,A].
```

Thus `T_A(x+t1)=T_A(x)`.  For distinct `i,j`, the coefficient of `t x_i x_j`
in the left side is

```
a_ij sum_{r != i,j} a_ir a_rj = a_ij (A^2)_ij.
```

Translation invariance and `a_ij != 0` give `(A^2)_ij=0`; hence `A^2` is
diagonal.  Since every matrix commutes with its square, writing
`A^2=diag(d_1,...,d_n)` gives

```
0=[A,A^2]_ij=a_ij(d_j-d_i).
```

Again all `a_ij` are nonzero, so all `d_i` are equal.  Therefore
`A^2=lambda I`.  Moreover
`lambda=(A^2)_ii=sum_{r != i} a_ir^2>0` over the stated real base field.

For the intended characteristic-zero sign specialization, write `A=sB`, where
`s != 0` and `B` has zero diagonal and off-diagonal entries in `{+1,-1}`.  The
diagonal entries give `B^2=5I`.  Switch so that the entries incident with a
chosen root vertex are all `+1`.  The root-to-vertex off-diagonal equations in
`B^2=5I` say that each vertex in the remaining five-vertex signed graph has two
neighbors of one sign and two of the other.  The positive-edge graph (or its
complement, depending on the sign convention) is therefore 2-regular on five
vertices, hence a pentagon.  This is the standard order-six symmetric
conference matrix up to switching and relabeling.

The existing direct calculation in Paper III then supplies the converse and
normalization: on that sign orbit, the Pfaffian shadow and triangle shadow are
proportional with ratio `+4` or `-4`.  The two signs are the two relative
orientation classes; they are not obtained by globally negating `B`, which
leaves every triangle product and every cubic Pfaffian term with the same
common sign change.

### Required hypotheses and boundary

- `mu != 0` is essential: there are gauge signings for which the Pfaffian
  shadow vanishes, so the zero-proportionality locus does not recognize the
  conference orbit.
- All off-diagonal entries must be nonzero for the coefficient and commutation
  divisions above.
- The degree argument is part of the theorem: it is what forces order six.
- The pentagon classification is only the equal-magnitude sign specialization.
  The theorem does not classify the remote weighted locus `A^2=lambda I`.
- Do not infer a local Jacobian theorem, a deformation-rigidity theorem, or a
  global classification of weighted solutions.
- Do not attach a novelty or priority claim; the literature audit does not
  support one.

### Recommended status

Numbered theorem, placed immediately after the proof of the existing
four-shadow theorem.  This is the only survivor that earns theorem status.

## Packet B: determinant-line norm

Let `E=Q(sqrt(5))`, let `P_+` and `P_-` be the spectral projectors for the two
eigenspaces `V_+` and `V_-` of the marked conference operator, and let

```
B_x = P_- D_x P_+ : V_+ -> V_-.
```

Then `det(B_x)` is naturally an element of
`det(V_-) tensor det(V_+)^{-1}`, rather than a scalar until bases are chosen.
Galois exchange swaps `V_+` and `V_-`; the symmetric pairing identifies the
conjugate determinant map with its transpose.  Thus the product with its
conjugate is a rational determinant-line norm.

Relative to `V_+ direct-sum V_-`, the commutator has block form

```
[D_x,C] = [ 0                 -2 sqrt(5) B_x^t ]
           [ 2 sqrt(5) B_x    0                 ].
```

Both blocks have size three.  The block determinant identity therefore gives

```
det[D_x,C] = (2 sqrt(5))^6 det(B_x)^2
           = 8000 N_{E/Q}(det B_x).
```

Combining this with the paper's existing identity
`det[D_x,C]=16 Z_C(x)^2` yields, after compatible determinant-line
trivializations,

```
Z_C(x) = +/- 10 sqrt(5) det(B_x).
```

The sign depends on the same relative orientation choice already tracked in
the manuscript.

### Boundary

This is a basis-free interpretation of an existing determinant identity.  It
does not construct an integral determinant line, a global relative moduli
object, or a canonically signed scalar determinant.  It should not be promoted
to a separate theorem, and it carries no novelty claim.

### Recommended status

Replace the opening of the current unnumbered “Why determinant” paragraph with
the norm explanation, then retain the existing permanent counterexample.

## Packet C: marked spectral compatibility

The manuscript already computes that deck exchange sends the marked operator
`C` to `-C` and the alternating cubic `Z_C` to `-Z_C`.  Since a unital algebra
does not distinguish a generator from its negative,

```
Q[C]=Q[-C].
```

This equality expresses the safe compatibility: the unmarked quadratic
spectral algebra survives deck exchange, while the chosen marked generator and
the relative orientation data change sign.

### Boundary

Do not state a new theorem `E \cong Q[C]`: once the minimal polynomial is fixed,
that identification is formal and adds no content.  Do not say that the
marking disappears, that the two sheets become canonically identified, or that
deck exchange acts trivially.  The point is precisely the distinction between
the unchanged unmarked algebra and the sign-changed marked generator.

### Recommended status

One sentence following the existing deck-exchange computation in the
orientation-source section.
