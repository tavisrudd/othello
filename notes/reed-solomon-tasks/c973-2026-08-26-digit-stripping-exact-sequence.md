# C973 digit-stripping exact sequence for Lucas carriers

Date: 2026-08-26  
Status: proved; strongest current multi-digit structural theorem

## 1. Setup

For an integer `d>=0`, define two characteristic-`p` `GL_2`-stable coordinate
modules:

```
Z_d = <e_j in Gamma^d E : binom(d,j)=0 mod p>,
C_d = <e_j in Gamma^(d+1) E :
                         binom(d,j)=binom(d,j-1)=0 mod p>.
```

Here `Z_d` is the normal-rational-curve nucleus module and `P(C_d)` is the
maximal adjacent-zero Lucas carrier at redundancy `r=d+2`.  Coefficients
outside `0,...,d` are interpreted as zero.  Write `( )^(1)` for Frobenius
twist and `det` for the determinant character.

Write the least-significant base-`p` digit separately:

```
d = pD+a,              0 <= a <= p-1.
```

## 2. Digit-stripping theorem

If `D>=1` and `0<=a<=p-2`, there is a natural exact sequence of `GL_2`
modules

```
0 -> det^(a+2) tensor Gamma^(p-a-3) E tensor (Gamma^(D-1) E)^(1)
  -> C_(pD+a)
  -> Gamma^(a+1) E tensor (Z_D)^(1)
  -> 0.                                                    (1)
```

The first term is interpreted as zero when `a=p-2`.

For the terminal digit `a=p-1`, there is instead a natural exact sequence

```
0 -> det tensor Gamma^(p-2) E tensor (Z_D)^(1)
  -> C_(pD+p-1)
  -> (C_D)^(1)
  -> 0.                                                    (2)
```

The nucleus recursion is uniform for every least digit `0<=a<=p-1`:

```
0 -> det^(a+1) tensor Gamma^(p-a-2) E tensor (Gamma^(D-1) E)^(1)
  -> Z_(pD+a)
  -> Gamma^a E tensor (Z_D)^(1)
  -> 0.                                                    (3)
```

Again the first term is zero when its divided-power exponent is `-1`, which
occurs at `a=p-1`.

Thus every maximal Lucas carrier can be stripped one base-`p` digit at a
time, and the accompanying nucleus recursion also strips one digit.  The only
directly persistent carrier quotient occurs when the stripped digit is
`p-1`; otherwise it passes to the recursively controlled nucleus module.

Equation (1) specializes to the one-carry theorem when `Z_D=0`.  In
particular, for `1<=D<p`, it recovers the explicit standard tensor module on
the part of the carrier arising from every high digit position, and accounts
exactly for the additional full blocks when row `D` itself has zero entries.

## 3. Coordinate proof for 0<=a<=p-2

Write an index as `j=ph+b`, with `0<=b<p`.  Lucas gives

```
binom(pD+a,ph+b) = binom(D,h) binom(a,b) mod p.            (3)
```

For `b>0`, both the coefficient at `j` and the coefficient at `j-1` vanish
exactly in either of the following cases:

```
binom(D,h)=0;                         or
binom(D,h)!=0 and b>=a+2.
```

For `b=0`, the preceding low digit is `p-1>a`, so both coefficients vanish
exactly when `binom(D,h)=0`.  Therefore the carrier support is the disjoint
union

```
A = {ph+b : 0<=h<=D-1, a+2<=b<=p-1},
B = {ph+b : binom(D,h)=0, 0<=b<=a+1}.                     (4)
```

The span of `A` is a submodule.  Put

```
s=a+2,   m=p-a-3,
g_(k,h)=binom(s+k,k)e_(ph+s+k),
0<=k<=m, 0<=h<=D-1.
```

For translation `t -> t+u`, Lucas and factorial cancellation give

```
g_(k,h) -> sum_(l>=k,h'>=h)
  binom(l,k) binom(h',h) u^((l-k)+p(h'-h)) g_(l,h').      (5)
```

This is the tensor action on

```
det^s tensor Gamma^m E tensor (Gamma^(D-1) E)^(1).
```

The determinant twist records the common low-index shift `s`.  Scaling has
exactly the corresponding weights.  Inversion sends

```
(k,h) -> (m-k,D-1-h).
```

The identity

```
binom(s+k,k)=(-1)^k binom(m,k) mod p
```

shows that its common scalar is the one supplied by `det^s`.  This proves the
left term of (1).

Modulo that submodule, the surviving basis is `B`.  The zero-coordinate span
`Z_D` is stable: if `binom(D,h)=0`, `binom(D,h')!=0`, and `h' >= h`, then
Lucas forces `binom(h',h)=0`.  Translation on the quotient consequently
factors as

```
binom(b',b) binom(h',h),
```

with `0<=b,b'<=a+1` and `h,h'` in `Z_D`.  Scaling and inversion factor in the
same way; inversion sends `(b,h)` to `(a+1-b,D-h)`.  This identifies the
quotient with `Gamma^(a+1) E tensor (Z_D)^(1)` and proves (1).

## 4. Coordinate proof for a=p-1

Now every low digit occurs in a nonzero high block.  The carrier support is

```
A' = {ph+b : binom(D,h)=0, 1<=b<=p-1},
B' = {ph : binom(D,h)=binom(D,h-1)=0}.                    (6)
```

The first span is stable.  With

```
g_(k,h)=(k+1)e_(ph+1+k),        0<=k<=p-2,
```

the same Lucas calculation identifies it with

```
det tensor Gamma^(p-2) E tensor (Z_D)^(1).
```

Modulo this span, only the low digit zero remains.  Translation, scaling, and
inversion act on its high index exactly as on `C_D`, with every parameter
raised to its `p`th power.  The quotient is therefore `(C_D)^(1)`, proving
(2).

## 5. Consequences for the research programme

For completeness, (3) follows from the same calculation.  The zero support in
row `pD+a` is the disjoint union

```
{ph+b : 0<=h<=D-1, a+1<=b<=p-1}
union
{ph+b : binom(D,h)=0, 0<=b<=a}.
```

Rescaling the first block by
`binom(a+1+k,k)` identifies it with the determinant-twisted left term of (3),
and the second block modulo the first is
`Gamma^a E tensor (Z_D)^(1)`.  Translation, scaling, and inversion factor
exactly as in the proof of (1).

The theorem replaces an unstructured all-digit carrier problem by two coupled
recursive objects:

```
Pascal nucleus Z_D, governed by (3),
adjacent-zero carrier C_D, governed by (1) and (2).
```

Iterating these sequences gives a finite filtration determined solely by the
base-`p` digits of `d`; every subquotient is an explicit determinant twist of
a tensor product of divided powers and Frobenius twists.  The structure
problem is therefore closed at the filtered-module level.

There is also a closed dimension formula.  Write

```
d = sum_i d_i p^i,
nu(d) = product_i (d_i+1).
```

Let `t` be the first digit position with `d_t<p-1`.  If it exists, put

```
eta(d) = product_(i>t) (d_i+1);
```

and put `eta(d)=1` when every digit is `p-1`.  Lucas' nonzero positions form
exactly `eta(d)` consecutive runs: trailing `p-1` digits fill intervals, the
first smaller digit separates them, and the higher digit box indexes them.
There are `d+1-nu(d)` zero positions and `eta(d)-1` zero runs.  Therefore

```
dim Z_d = d+1-nu(d),
dim C_d = d+2-nu(d)-eta(d).                               (7)
```

Formula (7) gives an immediate digit-level complexity discriminator before
any finite-field search is attempted.

The remaining hard operation is arithmetic rather than representation
identification: determine whether pointed shallow-witness abundance passes
through these extensions.  A proof that it does, with controlled loss in the
number of forbidden roots, would eliminate whole base-`p` digit families and
is the natural all-level successor to the simultaneous-marker theorem.

For software, the recursion gives a canonical input reduction:

1. strip the least digit of `r-2`;
2. record whether the syndrome lies in the explicit tensor submodule or maps
   nontrivially to the nucleus/carrier quotient;
3. canonicalize the smaller quotient before searching marker supports; and
4. retain the extension coordinate only when the quotient does not already
   yield a pointed locator.

This should be substantially more useful than adding fixed R14/R15 handlers.

## 6. Proof boundary and next gate

The exact sequences are representation-theoretic structure only.  They do
not assert that shallow witnesses lift across an arbitrary module extension,
and they do not classify `PGL_2(F_q)` orbits in high-degree tensor factors.
The next proof gate is one of:

- a geometric pointed-abundance lemma stable under (1) and (2); or
- a counterexample showing that the extension class carries new split-free
  arithmetic not visible in either subquotient.

The proof is structural and does not depend on computation.  As a bounded
falsification and regression check,
`notes/reed-solomon-tasks/c973-digit-stripping-check.py` verifies all support
partitions, submodule triangularity, and rescaling identities for
`p in {2,3,5,7,11,13}` and `1<=D<=24`.  Run it and verify its pinned source by

```bash
python3 notes/reed-solomon-tasks/c973-digit-stripping-check.py
cd notes/reed-solomon-tasks
sha256sum -c c973-digit-stripping-check.sha256
```

The 4,655-byte checker has SHA-256
`44f7bf4d79a61768abd82a5578face2b33601b9e0b49f5e0165074c239cd4cc9`.
Its bounded range is not evidence for the universal quantifier; equations
(3)--(6) are the proof.

No manuscript edit is authorized in C973.  If used in the paper, this theorem
should replace digit-by-digit carrier prose and precede the one-carry
corollary.

## 7. Mystery ledger

The explicit `ej` pass added the nucleus sequence (3) and the closed dimension
formula (7), completing the coupled filtered-module recursion.  The `tt` pass
tested whether an unproved direct-sum decomposition had slipped into the
argument.  It had not: the theorem asserts exact sequences only, and every
application that would require splitting remains outside the claim.

- Settled: later digit blocks are not unrelated coordinate spans; they admit
  a canonical least-digit filtration.
- Settled: a terminal digit `p-1` is the unique source of recursive carrier
  persistence.
- Settled: all other least digits pass to the lower Pascal nucleus rather than
  directly to another carrier.
- Open: whether pointed abundance is extension-stable.
- Open: the precise extension class in (1) and when the sequence splits as a
  finite-group module; splitting is not needed for the theorem above.
- Settled: `Z_D` has the parallel exact sequence (3), so the coupled
  filtered-module recursion terminates on the base-`p` digits.
- Open: independent representation-theory review of the determinant twists
  and quotient equivariance before manuscript integration; the coordinate
  proof and bounded checker are author-side evidence only.
- Owner: C973 mathematical continuation; computational canonicalization is a
  future software successor only after the quotient strategy is proved useful.

Vibe: the arbitrary-digit geometry now has a recursion; the obstruction has
moved from finding the carrier to transporting shallow witnesses through its
extensions.
