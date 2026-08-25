# C969 theorem freeze, normalized schema, and absorbed decoder gates

**Lane:** `reed-solomon` · **Date:** 2026-08-25 · **Status:** first-action gate complete

## Frozen truth boundary

The machine registry is
`notes/reed-solomon-tasks/c969-theorem-domain-v1.json`.  It pins the current
Version 2 theorem map and the load-bearing R5, R6, R7, and binary-R10
certificates to authority commit `9da3651b5f1e0cd390f8fb40f74415e0fedc0b0e`.
The public classifier must fail closed if any pinned hash changes.

The exact code-level classification surface is:

| redundancy | split-free classification | covering-radius promotion | classifier result on the complete range |
|---:|---|---|---|
| 5 | complete for every prime power `q>=7` | `rho=4` on the same range | complete |
| 6 | complete for every prime power `q>=7` | `rho=5` on the same range | complete |
| 7 | complete for every prime power `q>=7` | `rho=6` only for `q>=11` | `UNRESOLVED` on split-free inputs at `q=7,8,9`; complete from 11 |
| 8 | persistent-only for `q>=43` | `rho=7` on the same range | complete from 43; below range unsupported |
| 9 | persistent-only for `q>=53` | `rho=8` on the same range | complete from 53; below range unsupported |
| 10 | persistent-only for `q>=59` | `rho=9` on the same range | complete from 59; below range unsupported |

C620 removes the only former R10 arithmetic residue: every point of the first
higher binary Lucas carrier is shallow for every admissible binary field.
The R10 registry therefore contains no surviving `UNRESOLVED` Lucas family.
The q=16 and q=32 certificates establish local shallowness, not a complete
code classification below 59.

`NOT_DEEP` is witness-driven and may be returned outside a complete structural
range whenever the independent decoder exhibits a smaller support and verifies
its nonzero magnitudes.  `UNSUPPORTED` describes the theorem adapter, not a
failure of the level-independent distance routine.

## Normalization and action contract

The request/result contract is
`notes/reed-solomon-tasks/c969-normalized-schema-v1.json`.

1. A field is represented in a polynomial basis over its prime field.  Elements
   are integers whose base-`p` digits are the basis coefficients.  The modulus
   is monic and stored low coefficient first.  Cross-representation
   canonicalization chooses the lexicographically least monic irreducible
   polynomial and the least encoded root of that polynomial in the supplied
   field; the chosen field isomorphism is certificate data.
2. A syndrome uses divided-power coordinates
   `(s_0:...:s_(r-1))`, with finite columns
   `h(a)=(1,a,...,a^(r-1))` and `h(infinity)=e_(r-1)`.
   Projective normalization scales the first nonzero coordinate to one after
   transport to the canonical field model.
3. A semilinear transporter is `(j,g,lambda)`: apply coefficientwise
   `p^j` Frobenius, then the degree-`r-1` divided-power action of
   `g in PGL(2,q)`, then output scale `lambda`.  Normalize `j` to
   `[0,m)` and scale the first nonzero row-major entry of `g` to one.
4. The canonical artifact is the lexicographically least normalized syndrome
   in the proved structural orbit.  A group-enumeration fallback may inspect
   `m(q^3-q)` transporters, but it must report that cost and never enumerate
   projective syndrome space.  Formula adapters for persistent and theorem-
   generated modular families replace that fallback.
5. A certificate records the pre-normalization field isomorphism, projective
   scale, transporter, family invariants, distance witness or exhaustive
   branch, and separate split-free and radius source locators.

## Hand classifications before implementation choice

These representatives exercise every live branch type.  Coordinates are in
the frozen certificate's field encoding unless a symbolic extension-field
representative is stated.

| branch | field / redundancy | representative | hand verdict and invariant route |
|---|---|---|---|
| persistent tangent | `q=17`, R6 | `(0,0,0,0,1,0)` | `DEEP`; quadratic gcd is a rational square; orbit size 306, stabilizer 16 |
| persistent sigma | `q=17`, R6 | `(0,1,0,3,0,9)` | `DEEP`; quadratic gcd irreducible; orbit size 2448, stabilizer 2 |
| R5 rational osculating | `q=8`, R5 | `(0,0,1,0,0)` | `DEEP`; `q=2 mod 3`; orbit size 36, stabilizer 14 |
| R5 conjugate osculating | `q=7`, R5 | `(1,0,3,0,4)` | `DEEP`; `q=1 mod 3`; orbit size 21, stabilizer 16 |
| R5 characteristic-three nucleus | `q=9`, R5 | `(0,0,1,0,0)` | `DEEP`; fixed PGL orbit, kernel `<T^3,U^3>` |
| R5 characteristic-three wild | `q=9`, R5 | `(0,0,1,0,4)` | `DEEP`; Artin--Schreier nonsquare class; orbit size 40, stabilizer 18 |
| R5 sporadic | `q=9`, R5 | `(1,0,0,1,2)` | `DEEP`; certified gcd-one S3 pencil; orbit size 180, stabilizer 4 |
| R6 binary nucleus | `q=8`, R6 | `(0,0,0,1,0,0)` | `DEEP`; `m=3` odd; orbit size 9, stabilizer 56 |
| R6 sporadic | `q=8`, R6 | `(1,0,1,3,5,2)` | `DEEP`; certified trivial-gcd net; orbit size 168, stabilizer 3 |
| R7 central nucleus | `q=8`, R7 | `(0,0,0,1,0,0,0)` | split-free, but code verdict `UNRESOLVED` because the radius premise is absent |
| R7 sporadic | `q=7`, R7 | `(0,0,0,0,1,0,0)` | split-free certified; code verdict `UNRESOLVED` for the same radius gap |
| R8 persistent tangent | `q=43`, R8 | `e_6` | `DEEP`; persistent rational-square gcd and `rho=7` |
| R9 persistent tangent | `q=53`, R9 | `e_7` | `DEEP`; persistent rational-square gcd and `rho=8` |
| R9 characteristic-seven carrier | `q=7`, geometric R9 | `(0,0,1,0,0,0,1,0,0)` | split-free because `t^4+1` is rootless; `UNSUPPORTED` as a positive-dimension full-length R9 code parameter |
| R10 persistent tangent | `q=59`, R10 | `e_8` | `DEEP`; persistent rational-square gcd and `rho=9` |
| R10 binary Lucas carrier | `q=16`, R10 | `e_4` | `NOT_DEEP`; roots `0,1,2,3,6,7,8,15` give a split degree-eight locator in `x^4+x+1` encoding |

For any redundancy, a sigma representative can be produced without choosing
coordinates over an algebraic closure: choose an irreducible quadratic with
root `alpha` in `F_(q^2)` and take the projective trace of `nu_(r-1)(alpha)`.
Its catalecticant rank is two and its quadratic gcd is the chosen irreducible
quadratic.  The persistent discrete invariant is the class in
`T/T^(r-1)`, modulo inversion and Frobenius; the tangent invariant is the
normalized cocycle `z -> z+(r-1)u`.

## Reconciled C607/C608 interface gates

The unified engine has four layers.

1. `locator_system(t)` builds the two-chart homogeneous degree-`t` Hankel
   system.  It must prove the equivalence among support weight at most `t`, a
   rational atomic moment representation, rational NRC rank, and a split
   locator.  Exact weight additionally requires a squarefree locator and
   nonzero recovered magnitudes; padding and repeated roots belong only to the
   monotone at-most-`t` decision.
2. `distance` tests increasing `t`, selects and factors a split locator, solves
   the Vandermonde system, removes zero magnitudes, and verifies the syndrome.
   Infinity is a homogeneous root, never an affine sentinel hidden from the
   proof.
3. `classify` runs only after exact distance.  A distance at most `r-2` yields
   a witness-backed `NOT_DEEP`.  A split-free result reaches `DEEP` only when a
   registry row supplies both exhaustive family classification and covering
   radius; otherwise it returns `UNRESOLVED` or `UNSUPPORTED`.
4. `canonicalize` and `verify-certificate` are independent of locator search.
   The verifier recomputes field/action normalization, syndrome transport,
   family invariants, witness support and magnitudes, and both halves of a
   positive deep certificate.

The absorbed concrete kernel dimensions are retained as assertions, not
optimization folklore: the R5 terminal cubic system is a pencil; R6's
intermediate quartics form a projective plane; R7 uses the quartic plane and
quintic projective three-space.  The terminal hyperplane solver must cover
both infinity charts, its bilinear last-two-root equation, the collision
divisor, and a bounded small-field branch.  Failure through degree `r-1`
must prove that the final `r`-column basis solution has no zero coefficient.

The proposed R5/R6/R7 operation counts remain hypotheses until that solver is
proved: `O(q)`, `O(q^2)`, and `O(q^3)` field operations, respectively, plus
fixed-degree factorization.  The generic deterministic theorem and the
constructive implementation have different cost claims.  Kayal supplies the
candidate `F(r) poly(log q)` decision route only after a uniform exponent is
extracted; unconditional explicit recovery may use
`F(r) q poly(log q)` self-reduction.  No implementation benchmark may present
the generic parameter function as practical.

## Implementation decision

The schema and representative audit make exact extension-field arithmetic,
canonical serialization, certificate replay, and the existing Rust evidence
the dominant engineering constraints.  The implementation should therefore
be a separate Rust crate, not an extension of the Othello crate and not a Sage-
dependent query path.  Its first executable slice is the field/projective/
Hankel core plus witness verifier; structural adapters follow only after that
slice reproduces the hand classifications above.

## Implementation checkpoint

`rust/prs_classifier` now implements the field/projective/Hankel core.  Its
compact finite-exception data is regenerated from the frozen C491, C498, and
C509 certificates by
`notes/reed-solomon-tasks/c969-build-frozen-orbit-registry.py`; the generated
registry has 338 semilinear rows and retains family, canonical representative,
orbit size, and stabilizer order.  No ambient syndrome record is copied into
the query path.

The green tests cover prime and extension-field arithmetic, both locator
charts, a weight-two decode and independent replay, the q=16 R10 Lucas witness,
the frozen R6 tangent/sigma representatives, semilinear action and transporter
canonicalization, an R5 wild exception, and the R7 `UNRESOLVED` radius gap.
The current deep result is classification-only: the terminal `r-1` locator and
nearest-word witness remain an explicit open gate, so the crate is not yet an
accepted C969 decoder.
