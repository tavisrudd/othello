# C909 hostile audit: trace-orbit closeout, Section 1

Date: 2026-08-11  
Scope: only Section 1 of
`notes/2026-08-11-c909-trace-orbits-all-degree-closeout.md`; no manuscript,
PDF, mirror, Lean, or commit change

## Verdict: MINOR repairs; core orbit dictionary survives

The trace-orbit bijection is correct.  For a fixed labelled finite etale
unramified action (O\hookrightarrow\operatorname{End}_R(M)), perfect trace
duality gives a unique unimodular symmetric (O)-form (h) with

    C(x,y) = Tr_O/R(h(x,y)),

and (O)-isometries of (h) are exactly the stabilizer of the labelled
embedding.  Freeness of (M) over the local unramified ring (O) follows by
lifting a residue-field basis and comparing (R)-lengths.  Thus the stated
orbit classification is sound, including the stabilizer (O(h)(O)).

The odd rank-one norm-squareclass argument is also correct, as is the exact
order of the dyadic hyperbolic orthogonal group.  Two broader statements need
precise correction:

1. the odd unlabelled normalizer has an exact sequence and order (2m), but
   need not split as `{+/-1} semidirect Gal(O/R)` for even (m);
2. the assertion that an even-degree trace can erase a nonzero dyadic Arf
   invariant is false.  The trace on the Artin–Schreier quotient is an
   isomorphism for every finite field extension, not only odd degree.

The root applications are unaffected: odd-prime root degree (d=p^a-2) is
odd, and the dyadic root degree (m=2^{a-1}-1) is odd.

## 1. Trace-orbit bijection

Let (R=\mathbf Z/p^a), (O/R) unramified of degree (m), and (C) a
perfect symmetric (R)-form.  A (C)-self-adjoint (O)-action defines (h)
uniquely from

    Tr(alpha h(x,y)) = C(alpha x,y).

The self-adjointness and symmetry identities imply (O)-bilinearity and
symmetry.  Trace duality identifies the (O)-dual with the (R)-dual, so
unimodularity transfers in both directions.  Since (O) is local, a basis of
(M/pM) over the residue field lifts to an (O)-surjection (O^n\to M);
the (R)-lengths agree, hence it is an isomorphism.  This proves the stated
classification by (O)-form isometry classes.

For one form (h), the orbit is (O(C)(R)/O(h)(O)).  If several (O)-form
isometry classes have the same trace form, the full labelled moduli set is the
disjoint union of these homogeneous orbits; the “one orbit” assertion must be
reserved for the odd rank-one and dyadic hyperbolic cases.

## 2. Odd rank one: norm and stabilizers

For (h_c(x,y)=cxy), (O)-isometry classes are (c\bmod (O^*)^2).  For
odd (p), principal units are squares and both unit squareclass groups have
order two.  The norm on residue fields is surjective and carries a nonsquare
to a nonsquare, so

    O^*/(O^*)^2  ->  R^*/(R^*)^2

is an isomorphism.  The determinant identity

    det_R(Tr h_c) = disc(O/R) * Norm(c)

therefore gives exactly one (c)-squareclass over a fixed (C).  The labelled
stabilizer is exactly

    O(h_c)(O) = {u in O^*: u^2=1} = {+1,-1}.

For the unlabelled subalgebra, every Frobenius automorphism is realized by a
semilinear isometry because sigma(c)/c is a square.  Consequently the
normalizer fits into

    1 -> {+1,-1} -> N -> Gal(O/R) -> 1

and has order (2m).  The displayed semidirect-product notation in the source
note is too strong without a splitting argument.  For even (m), a
nonsquare (c) can give a lift of Frobenius whose square is (-1), producing a
cyclic-type extension rather than `{+/-1} x Gal`.  For odd (m), including the
odd-prime root degree, a Frobenius-fixed squareclass representative gives the
expected split form.  The order (2m), which is all the orbit count needs,
is correct in every case.

The switch from (B) to (C=B^{-1}) in the graph convention is also sound:
over an odd local ring, (B) and (B^{-1}) have the same rank and determinant
squareclass, hence are isometric by the unimodular odd-local classification.

## 3. Dyadic uniqueness: conclusion correct, stated proof needs repair

The parity step is correct.  If the trace transfer is even and the residual
(O/2)-form has a vector (v) with (h(v,v)\ne0), Frobenius bijectivity and
nondegenerate trace supply an alpha with

    Tr(alpha^2 h(v,v)) != 0,

contradicting evenness of the transfer.

The source sentence that “even-degree trace can erase the nonzero Arf
invariant” is false.  For (k=\mathbf F_{2^m}), the Arf invariant of a
nondegenerate binary quadratic form lies in the Artin–Schreier quotient

    k / {z^2+z}.

The absolute trace induces an isomorphism

    k / {z^2+z}  ->  \mathbf F_2,

for every (m): its kernel is exactly the Artin–Schreier image.  Therefore
the Arf sign of the restriction-of-scalars trace form detects the nonzero
Arf class for even (m) as well.  The Gauss-sum sentence should say this
explicitly; “the same sum before and after restriction” is not a sufficient
proof because the additive character is composed with the field trace.

Once the residual (O)-form has Arf zero, a primitive residual isotropic vector
has a unit polar partner.  Hensel-correcting the vector solves the quadratic
equation because the derivative in the partner direction is a unit; after an
integral isotropic vector is obtained, adjust its partner by

    w -> w - (h(w,w)/2) v

to obtain an integral hyperbolic pair.  Thus (h\simeq H), and the uniqueness
claim is valid for all (m), not only odd (m).  The dyadic root case remains
valid.

## 4. Exact dyadic orthogonal-group order

For (S=O/2^a), residue-field size (Q=2^m), and (a\ge2), an isometry

    A = [[r,s],[t,u]]

of (H) satisfies

    2rt = 2su = 0,    ru+st = 1.

Modulo 2 these equations force either the diagonal component or the
anti-diagonal component.  On the diagonal component, (r) is a unit,
(u=r^{-1}), while (s,t\in\operatorname{Ann}(2)), each with (Q) choices.
There are ((Q-1)Q^{a-1}) choices for (r), hence

    (Q-1) Q^(a+1)

elements in that component.  The anti-diagonal component has the same size,
so

    |O(H)(O/2^a)| = 2(Q-1)Q^(a+1)

is exact for (a\ge2).  At (a=1) the formula changes; the source correctly
restricts the formula to (a\ge2).  Notationally, if (O) already denotes
the truncated unramified ring over (R=\mathbf Z/2^a), write (O(H)(O)), or
otherwise define (O) as the untruncated DVR before writing (O/2^a).

Coordinatewise Frobenius preserves (H), so the dyadic unlabelled normalizer
does split as (O(H)(O/2^a)\rtimes\operatorname{Gal}(O/R)).

## Final audit status

- **GO:** trace-orbit bijection, odd norm-squareclass uniqueness, stabilizers,
  and dyadic group-order formula.
- **MINOR repair:** replace the odd normalizer semidirect-product claim by an
  exact sequence/order statement; replace the false odd-degree-essential Arf
  sentence by the Artin–Schreier trace argument.
- **No root-case obstruction:** both applications have odd residue degree, so
  the repaired statements preserve their claimed local orbit conclusions.

