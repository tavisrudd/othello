# C545 degree-nine e7 proof expansion and cold read

Date: 2026-07-23

## Result

Gate P7 is closed.  The manuscript now gives separate, complete proofs for
the framed Artin--Schreier quotient, the connected additive affine-frame
cover, and the direct shallowness/count theorem for the full `PGL2` orbit of
`e_7`.

## Proof audit

### Framed quotient

For roots `0,1,a,b,c,d,u,v`, the two missing-coefficient equations are
derived rather than asserted:

- the first gives `u+v=h`;
- the second gives `uv=p`;
- scaling `u` by `h` gives `y^2+y=p/h^2`.

The proof names every collision divisor.  Along `h=0`, the order-two pole has
leading coefficient

`D=1+bc+bd+cd+B+B^2`.

Over the algebraic-constant residue field, its nonzero `b`-derivative proves
that `D` is not a square.  An Artin--Schreier coboundary with an order-two
pole would have a square leading coefficient, so the class remains nonzero
after every algebraic constant extension.  This proves geometric
integrality and exact geometric monodromy `C2`; the finite-field trace
criterion then gives the rational lifting law.

### Additive cover

The subspace-polynomial recursion

`L_(U+<w>) = L_U^2 + L_U(w)L_U`

produces precisely the exponents `8,4,2,1`, and the nonzero linear
coefficient proves separability.  The open affine-frame space is
geometrically integral.  A generic polynomial's roots are an affine
three-space, and its ordered frames are one free orbit of
`F_2^3 semidirect GL_3(F_2)`.  Hence the normalization is connected, its
generic degree is `8*168=1344`, and its exact deck group is
`AGL_3(F_2)`.

### Direct shallowness and count

Every field `F_(2^m)` with `m>=3` contains a three-dimensional `F_2`
subspace.  Its subspace polynomial lies in `W_(e_7)` and is split
squarefree.  Projective transport supplies a witness on the whole orbit.
There are

`(q-1)(q-2)(q-4)/168`

three-spaces and `q/8` affine cosets of each.  A root coset recovers its
difference space, so the product

`q(q-1)(q-2)(q-4)/1344`

has no overcount.

The manuscript now states the logical boundary explicitly: the direct
shallowness proof does not assume that the generic Artin--Schreier cover has
a rational point.

## Validation

- Certificate e7 generator check: pass.
- Certificate e7 structurally independent replay: pass on all ten recorded
  field controls.
- The manuscript warning-gated build passes after expansion.
- The claim ledger, adversarial audit, second-draft plan, and C545 checklist
  all mark P7 green while retaining the unclassified non-`e_7`
  degree-nine carrier strata outside the claim.

## Extra-juice and Tao closeout

The strongest simplification is logical rather than computational.  The
large `AGL_3(F_2)` cover explains why the earlier `AGL_1(F_8)` order-three
phenomenon is only a proper linear section, but the orbit's shallowness is
settled by a direct rational construction.  This separates geometric
structure from arithmetic existence and removes any temptation to infer
deepness from a nonsplit generic cover.

The count also shows that the `F_8`-linear witnesses, when present, are a
quadratically vanishing proportion of all additive witnesses.  No additional
enumeration is needed for the `e_7` orbit.

## Mystery ledger

- **Settled:** whether the Artin--Schreier cover is geometrically constant or
  split.  The pole-leading-coefficient argument proves that it is not.
- **Settled:** whether the `AGL_3(F_2)` label is only a permutation
  heuristic.  The connected frame-space quotient proves the exact deck
  group.
- **Settled:** whether translations or repeated parameterizations inflate
  the witness count.  Root cosets recover their difference spaces, giving
  exact no-overcount.
- **Outside the claim:** the other intrinsic strata of the full degree-nine
  Lucas carrier remain owned by C531 and are not a C545 proof gap for the
  stated `e_7` theorem.

