# C366: intrinsic recognition-to-decoding for the layered C329 code

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; UNMARKED RECOVERY COMPOSES WITH EVERY-SYNDROME DECODING`

## Signed decision

C336's degree-one evaluation code, C337's intrinsic recovery theorem, and C364's complete
coset-leader decoder compose without an extra marking or oracle.  From an arbitrary unmarked
`3 x 4Q` generator of the degree-one code—or, equivalently, an arbitrary `3 x 4Q` parity-check
matrix of its dual—one recovers the complete gauge-free layered equivalence class and then returns
a minimum-weight leader for every syndrome of the dual.  The one-time preprocessing is Las Vegas
expected-linear in the block length, with a deterministic `O(N^6)` fallback; after preprocessing,
each syndrome is decoded deterministically in `O(m^2)` base-field operations by four trace gates
and six bounded-degree fiber problems.

The composition is specifically for the dual of the degree-one member `C_1(A)` of C336's five-code
tower.  It does not supply complete decoders for the degree-two through degree-five rows.  It also
does not recover C314's prescribed empty conic or common height; the proof below shows that neither
is consumed by the decoder.

## End-to-end theorem

Let `F=GF(Q)`, where `Q=2^m`, `m` is odd, and `Q>=2^45`; let `E=GF(Q^2)` and `N=4Q`.
Let `A` be a member of the three-distinct-carrier C329 subfamily selected in C336.  Write

```text
B=C_1(A)=[N,3,N-2]_E,
D=B^perp=[N,N-3,4]_E.
```

Suppose that `H in E^(3 x N)` is an unmarked full-rank matrix whose row space is a monomially
equivalent copy of `B`; equivalently, `H` is an arbitrary parity-check matrix for the corresponding
copy of `D`.  Its row basis, nonzero column multipliers, and column order are arbitrary.  Under the
promise that the input belongs to this C329 subfamily, there is a preprocessing algorithm that
returns:

1. the three intrinsic carriers with support sizes `2Q,Q,Q`, the intrinsic split of the doubled
   carrier, the simultaneous four-orbit `F^+` action, and the association of every recovered point
   with its original input coordinate;
2. the complete gauge-free invariant

   ```text
   I(A)=[rho;{a,b}],
   ```

   modulo seed interchange and

   ```text
   (rho,a,b) -> (rho^-1,a/rho^2,b/rho^2)
   ```

   under repair interchange; and
3. for every `s in E^3`, a sparse vector `e in E^N` satisfying `He^T=s` and having minimum
   Hamming weight among all vectors with that syndrome.

The recovered invariant decides projective/monomial equivalence by the two displayed finite
relabelings and semilinear equivalence by additionally testing the `2m` Frobenius automorphisms of
`E`.  Preprocessing takes expected `O(N)` `E`-field operations by C337's Las Vegas five-point
sampler.  Its lexicographic five-subset fallback is deterministic and takes `O(N^6)` operations.
After either preprocessing route, one syndrome takes a constant number of `E` operations, at most
four absolute-trace tests, and six fiber solves whose main polynomials have degrees respectively
`5,2,8,8,8,8`, together with their recorded degree-at-most-two exceptional-divisor equations.
C364's Frobenius-gcd and trace-splitting routine makes all root finding deterministic in `O(m^2)`
`F`-operations, or `O(m^2 M(m))` bit operations with multiplication cost `M(m)`.  Thus `T`
syndromes cost expected `O(N+T m^2)` field operations after the Las Vegas route, or deterministically
`O(N^6+T m^2)`, apart from sparse output and the stated field-arithmetic conversion.

This is a promise-family theorem.  C337's intrinsic fingerprint rejects malformed presentations,
but without the C329 promise it does not replace a separate general-purpose MDS certificate or a
cubic all-minors check.

## Compatibility of the three theorems

### C336 to C337: the matrix is exactly the recovered projective system

C336 proves that degree-one evaluation is injective and that `B` has parameters
`[4Q,3,4Q-2]_E`.  In the monomial basis given by the three homogeneous coordinates, a generator
matrix has one column for each point of `A`.  Row-basis changes act by `GL(3,E)`, nonzero column
multipliers disappear on projectivization, and a column permutation only forgets the historical
evaluation order.  This is precisely C337's input model, not a new identification imposed after
recognition.  Duality gives C364's `[4Q,4Q-3,4]_E` code `D` with the same `3 x 4Q` matrix as a
parity check.

C336's other four rows are not silently imported.  Their dimensions are `6,10,15,21`, so C337's
three-dimensional heavy-conic recognizer and C364's redundancy-three syndrome geometry do not
apply to them as stated.

### C337 to C364: retain the coordinate change and column scalars

C337's pencil normalization is a sequence of projective linear changes.  Choose and retain a
linear representative `U in GL(3,E)` for their product.  For the input column `h_j`, recovery also
retains the unique nonzero scalar `kappa_j` relative to the chosen normalized representative:

```text
U h_j = kappa_j P_j,
P_j=P(c_j omega+t_j,k_j)
```

with `P_j` in C337's four-layer normal form.  Computing `U`, the original-coordinate association,
and every `kappa_j` uses only the constant-size linear algebra and projectivization already present
in C337; it is not an additional marking.

For an input-basis syndrome `s`, apply C364 to `s'=Us`.  If its normalized leader has coefficients
`f_j`, then

```text
s' = sum_j f_j P_j
   = sum_j (f_j/kappa_j) U h_j.
```

Consequently `e_j=f_j/kappa_j` satisfies `He^T=s`.  Every `kappa_j` is nonzero, so this descent
preserves support and weight in both directions.  A normalized leader is minimum if and only if
its descended input-coordinate leader is minimum.  This proves the missing compatibility map;
merely citing projective equivalence would not have been enough for syndrome coefficients.

The C337 normal form is exactly the C364 presentation

```text
A = L(0,a) union L(0,b) union L(1,0) union L(rho,0).
```

Seed interchange and repair interchange merely reorder the same ten secant gates.  Replacing
`omega` by `omega+1` leaves the two repair cosets unchanged.  C364 enumerates the full reconstructed
candidate set and breaks ties by the lexicographically least original-coordinate support and
coefficients, so no recovered layer name affects the returned answer.

## Exhaustive decoder branches

After transforming the syndrome by `U`, the composed decoder uses C364's following disjoint and
exhaustive branches.

- The zero syndrome returns the empty leader.  A projectivized column hash handles weight one and
  records its input-coordinate scalar.
- An affine syndrome first tests the four repeated-layer secants by their absolute-trace gates.
  The `tau=0` degree-drop branch uses the recorded closed formula rather than dividing by zero.
- When the affine omega-coordinate is zero, the seed-vertical component uses the two columns
  `P(u,a),P(u,b)` and their explicit coefficients.
- The six cross-layer gates solve one quintic, one quadratic, and four octics.  Roots reconstruct
  both endpoints and both nonzero coefficients.  Every root of a cleared equation is checked back
  in the uncleared omega equation; the roots of `M_1`, residual quadratics, degree drops, and
  zero-polynomial cases use C364's fixed finite list of admissible `r` values.
- An ordinary infinity syndrome solves `s=p+K/p` inside the appropriate reconstructed affine
  `F`-coset.  The vertical infinity point uses the seed-vertical pair.
- If the column and all ten secant gates fail, the syndrome is a deep hole.  Any fixed three
  recovered columns form a basis because `A` is an arc; the resulting `3 x 3` solve has no zero
  coefficient, and hence gives a minimum weight-three leader.

The MDS parity-check rank bounds every coset-leader weight by three, while failure of the column and
secant tests excludes weights one and two.  This proves both exhaustiveness and minimum weight; the
decoder is not just a bounded-distance routine.

## No-marking and no-oracle audit

The common conic-pencil height removed by C337's normalization is exactly C314's unrecoverable
prescribed-conic marking.  C364 uses only the relative heights `a,b`, the repair ratio `rho`, the
reconstructed affine parameter on each selected layer, and the input-basis map `(U,kappa_j)`.
Changing the common height is absorbed into `U`; it never appears in a fiber equation.

The construction therefore consumes none of the following:

- the deleted prescribed empty conic or its common height;
- the historical seed/repair names, evaluation order, C329 Chebotarev skeleton, or factor-type
  witness;
- a supplied secant table, syndrome table, deep-hole list, or the unevaluated C361 global count;
- a field scan, a column-pair scan, a random polynomial factorizer, or a root-finding oracle.

The unique subfield `F` is intrinsic in `E` as the fixed field of `x -> x^Q`, and the deterministic
Frobenius-gcd/trace routine supplies all bounded-degree roots.  Randomness occurs only in C337's
Las Vegas carrier sampler: every accepted carrier is verified, and the deterministic `O(N^6)`
fallback removes even that randomness.  Thus no unrecorded marking or oracle remains.

## What is new in the composition

C336 supplies the exact degree-one code and its dual parameters; C337 supplies intrinsic recovery
and equivalence from an unmarked matrix; C364 supplies complete decoding after a recovered normal
form.  The new statement is the explicit descent through `(U,kappa_j)`: the individual outputs and
inputs really compose, so the unmarked matrix itself supports every-syndrome minimum-leader
decoding while also yielding its complete gauge-free equivalence class.

No new computational claim is made here.  C336's interpolation replay and C364's exhaustive
`3,148,803`-syndrome, `98,304`-fiber replay remain the convention checks for the consumed theorems;
the load-bearing new step is the algebraic compatibility proof above.  C364's citation-graph and
subscription-database closure remains open, so any manuscript priority sentence for the combined
recognize-then-decode theorem must retain “to our knowledge.”

## Paper integration

Place this corollary immediately after C337's intrinsic-recognition theorem, with C364's complete
decoder as its proof input and before C362's global-enumerator section.  A copy-ready abstract
sentence is:

> From an unmarked parity-check matrix, we recover the complete gauge-free equivalence class and
> deterministically decode every syndrome after expected-linear one-time preprocessing, with no
> prescribed conic, layer labels, secant table, or factorization oracle.

## Vibe check

Excellent low-cost upgrade: the strongest algorithmic results really do meet at the same
degree-one code, and the only subtle interface—the row/column-scalar descent back to the original
syndrome basis—is explicit and weight preserving.  The boundary is equally clean: this crowns the
degree-one dual, not the other four evaluation-code rows.
