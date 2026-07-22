# C471 — Hadamard degeneration complex and puncture/shorten bridge

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `GREEN — THE ORDER-12 HADAMARD FACTORIZATION REDUCES TO A RANK-SIX EXACT COMPLEX; ITS ORIENTED KERNEL/IMAGE IS THE EXTENDED TERNARY GOLAY CODE, AND PUNCTURE/SHORTEN RECOVER C465 LITERALLY`

## Result

Let `H` be C469's displayed integral `12x12` Hadamard matrix, with the coordinate carrier indexing
columns and the Hadamard-row carrier indexing rows.  Exact integer arithmetic gives

```text
H H^T = H^T H = 12 I_12,       det(H)=-12^6=-2,985,984.
```

Reducing modulo three gives the exact two-periodic complex

```text
... -> F_3^12 --H^T--> F_3^12 --H--> F_3^12 --H^T--> F_3^12 -> ...,
```

with the literal identities

```text
rank(H)=rank(H^T)=6,
ker(H)=im(H^T),
ker(H^T)=im(H).
```

The first orientation is exactly C469's self-dual extended ternary Golay code:

```text
C_12 = ker(H) = im(H^T) = C_12^perp.
```

The transpose orientation `ker(H^T)=im(H)` is a second self-dual six-space and is distinct from
`C_12` in the displayed coordinates.  This is not a defect: C470 identifies rows and columns as
the two outer-related twelve-point carriers.  The complex is naturally an alternating map between
those labelled carriers, not a canonically chosen endomorphism of one permutation module.

## Structural exactness: the divided operator

The rank-half result does not depend on matrix exhaustion.  If `x` represents an element of
`ker(H mod 3)`, then `Hx` is integrally divisible by three.  Put

```text
y = Hx/3 mod 3.
```

The integral factorization gives

```text
H^T y = H^T Hx/3 = 4x = x mod 3.
```

Thus every kernel vector has a canonical divided-integral preimage under `H^T`; transposing proves
the other equality.  Equivalently,

```text
beta_H : ker(H) -> F_3^12/im(H),       x |-> [Hx/3]
```

is inverse to the map induced by `H^T`, and similarly with `H,H^T` exchanged.  The JSON records
these preimages on both RREF kernel bases, while the independent replay checks the formula on all
`729+729` kernel vectors.

There is also a determinant-only cross-check.  Since `HH^T=0 mod 3`, the image of `H^T` is
isotropic and `rank(H)<=6`.  But `v_3(det H)=v_3(12^6)=6`, so the mod-3 nullity is at most six.
Both inequalities force rank six.  In Smith-language, the 3-primary elementary divisors consist
of exactly six copies of `3` and no higher 3-power; the divided map explains why.

### Full integral shadow

The same argument determines the complete Smith normal form, not only its 3-primary part:

```text
SNF(H) = diag(1,2,2,2,2,2,6,6,6,6,6,12),
coker(H) ~= (Z/2)^5 direct-sum (Z/6)^5 direct-sum Z/12.
```

Indeed `H^T=12H^{-1}` and transposition preserves Smith factors, so ordered invariant factors
satisfy `d_i d_(13-i)=12`.  Modulo two every sign is one, hence `rank(H mod 2)=1`; modulo three the
rank is six.  These ranks, the divisibility chain, and the pairing relation force the displayed
list.  In particular

```text
coker(H)_(3) ~= (Z/3)^6,
coker(H)_(2) ~= (Z/2)^10 direct-sum Z/4.
```

This answers the natural integral question behind the code.  Standard tensor/Tor reduction gives

```text
ker(H mod 3) = Tor_1(coker(H),F_3),
coker(H) tensor F_3 = coker(H mod 3),
```

and the divided operator canonically identifies these two six-dimensional shadows.  Thus the
extended Golay carrier is the 3-primary degeneration of one integral cokernel, not merely a code
whose dimension happens to equal half the Hadamard order.

### General simple-bad-prime lemma

The mechanism is uniform at exactly the right level.  If integral square matrices `A,B` satisfy

```text
AB=BA=p u I,                 p prime, u nonzero mod p,
```

then their reductions form an exact two-periodic complex.  For `Ax=0 mod p`, the integral vector
`y=Ax/p` satisfies `By=u x mod p`; multiplication by `u^{-1}` supplies the preimage.  Exchange
`A,B` for the other half.  C471 is the instance `(A,B,p,u)=(H,H^T,3,4)`.

The hypothesis `v_p(pu)=1` is load-bearing.  It sharply blocks two tempting transfers:

- an order-eight binary Hadamard model has `v_2(8)=3`, as well as losing its sign encoding because
  `+1=-1`; C471 therefore gives no q=7 exact complex;
- C455's raw Fourier scalar is `1331=11^3`, so dividing once by 11 leaves zero modulo 11 and the
  same Bockstein inverse does not survive.

This valuation test is a stronger boundary than saying only that the normalizations look different.

## Literal incidence formula

Let `A` be C469's frozen `11x11` disjointness incidence matrix.  In the exact row and coordinate
orders of the certificate,

```text
H = [[1^T, 1],
     [J-2A, -1]].
```

Modulo three, subtracting the top Hadamard row from lower row `i` gives precisely the parity
extension of incidence row `A_i`.  Thus the Golay carrier is not recognized only by parameters:
the generator rows are read directly off the degenerate operator.

## Puncture and shorten

Use coordinate `11` (zero-based), C469's appended parity coordinate, and define

```text
P(x_0,...,x_11)=(x_0,...,x_10),
E(x_0,...,x_10)=(x_0,...,x_10,-sum_i x_i).
```

The certificate contains the literal `11x12` and `12x11` matrices and verifies

```text
P E = I_11,       E P|C_12 = I_C12.
```

C465 and C469 retained different frozen orders on the eleven matching coordinates.  Reconstructing
both ordered matching sheets gives the exact relabelling, old C469 index to new C465 index,

```text
[0,7,6,5,2,8,3,1,4,10,9].
```

After this certified relabelling,

```text
P(C_12) = D_11,                                      dim 6,
P({c in C_12 : c_11=0}) = S_11,                      dim 5,
```

where `D_11` is C465's disjoint-row Golay span and `S_11` is its shared-edge simple core.  Both
equalities are equality of canonical RREF bases, not code-parameter matching.  The extension and
projection squares commute with C469's frozen translation and inversion generators; the JSON
records both permutation matrices and all restricted action matrices.

The operator immediately yields

```text
D_11 = S_11 direct-sum <1>,
S_11 = D_11^perp,
S_11 < 1^perp with dim(S_11)=5=dim(1^perp)/2.
```

Hence `S_11` is the stable Lagrangian in the ten-dimensional augmentation and the coordinate form
identifies the quotient `1^perp/S_11` with `S_11^*`.

## Exactly where the retraction computation remains necessary

The Hadamard factorization, puncture, and shorten maps derive the orthogonal flag, but they do not
by themselves exclude an invariant complementary copy of `S_11^*` inside `1^perp`.  Two further
C465 facts are logically required:

1. exhaustive cyclic-submodule generation proves that `S_11` is simple;
2. the equivariant-retraction system has 50 unknowns and 125 equations, with coefficient rank 50
   and augmented rank 51.

The C471 checker reconstructs the second system from the puncture/shorten model and C469's two
generators and reproduces the `50/51` obstruction exactly.  Only after adjoining these facts does
one obtain

```text
0 -> S_11 -> 1^perp -> S_11^* -> 0              nonsplit,
soc(1^perp)=rad(1^perp)=S_11,
soc(F_3^11)=D_11,       rad(F_3^11)=S_11.
```

This separates what the operator proves from what still genuinely uses representation theory.

## C470 equivariance upgrade

C470's two standard signed `M12` lifts already record coordinate permutations/signs and induced
Hadamard-row permutations/scalars.  Converting those arrays to literal integral monomial matrices
`R` and `M`, C471 verifies for both generators

```text
R H^T = H^T M,
H R^T = M^T H,
M H R^T = H.
```

Thus the integral pairing and its mod-3 adjoint factorization respect C470's signed row/coordinate
transport.  This is an operator-level consequence of the already-certified C470 lifts.  It is not
a new automorphism census, does not classify the frozen signed preimage, and makes no genuine-Weil
claim; those discriminators remain C472's boundary.

The divided maps retain this equivariance.  For the two recorded standard generators, the first
adjoint identity gives, integrally on a lift of `x in ker(H mod 3)`,

```text
beta_H(R^T x) = [H R^T x/3]
              = [M^T Hx/3]
              = M^T beta_H(x)
              in F_3^12/im(H).
```

Similarly `R H^T=H^T M` gives

```text
beta_Ht(Mx)=R beta_Ht(x)       in F_3^12/im(H^T).
```

The JSON records the resulting `6x6` action matrices in each kernel basis and the corresponding
Bockstein-cokernel basis; the matrices agree literally.  The independent replay reconstructs both
orientations from C470's signed arrays and verifies the divided identities over the integers.
Consequently C472 receives a canonical signed six-dimensional transport, not merely two
six-spaces of matching dimension.  What remains for C472 is to determine the frozen preimage,
central scalar, and genuine-Weil character—not to invent an intertwiner between the carriers.

## Comparison with C455

The common exact pattern is normalization of a raw transform by the square root of its
orthogonality scalar:

```text
C471: H H^T=12I,             normalized operator 12^(-1/2)H;
C455: hat-hat=1331R,         normalized Fourier operator 11^(-3/2)hat.
```

On C455's even restrictions `R=I`, so the normalized Fourier operator is an involution.  C471's
`H` is instead an isometry between distinct row and coordinate carriers, with inverse `H^T/12`;
no symmetry or endomorphism identification is assumed.

The central discriminator remains decisive.  C455's genuine Gauss-sum linearization is
`rho(w)=iF` and has central action `rho(-I_6)=-I` on the certified even spaces.  The Hadamard
factorization supplies no `SL_2(11)` action or central scalar.  Rank six, outer duality, and the
Fourier-style normalization therefore do not turn the C469/C465 permutation carrier `1+5` into a
genuine degree-six Weil module.

There is also a separate valuation obstruction to transferring the exact-complex mechanism:
`v_3(12)=1`, while `v_11(1331)=3`.  The simple-bad-prime lemma applies only in the first case.

## Certificate and reproducibility

The atomic bundle is:

- `notes/2026-07-22-c471-hadamard-degeneration-complex.md`;
- `notes/2026-07-22-c471-hadamard-degeneration-complex.py`;
- `notes/2026-07-22-c471-hadamard-degeneration-complex-replay.py`;
- `notes/2026-07-22-c471-hadamard-degeneration-complex.json`;
- `notes/2026-07-22-c471-hadamard-degeneration-complex.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c471-hadamard-degeneration-complex.py --check
python3 notes/2026-07-22-c471-hadamard-degeneration-complex-replay.py
sha256sum -c notes/2026-07-22-c471-hadamard-degeneration-complex.sha256
```

Intentional regeneration is the primary command without `--check`.  It hash-pins C465, C469,
C455, the user-directed C470 result, and the two upstream matching-order certificates needed to
make the C465/C469 relabelling literal.  It checks both integer factorizations, both mod-3 exact
sequences, divided preimages, puncture/shorten maps, generator intertwiners, the retraction rank
gap, and the C470 signed adjoint identities.

The independent replay imports no primary code.  It rebuilds `H` from C469's eleven selected
supports, enumerates all `3^12=531,441` ambient vectors, reconstructs both 729-element kernels and
images, checks every divided preimage, independently rebuilds the matching-coordinate relabelling,
compares the punctured and shortened word sets with C465, reconstructs the `50/51` retraction
system, and verifies C470's signed generator identities.

Trusted boundary: exact integer and prime-field arithmetic, exhaustive enumeration of the stated
finite spaces, and the hash-pinned input certificates.  No literature, novelty, automorphism-group,
signed-preimage, q=7, or full Weil-module conclusion is made.

## Extra-juice closeout and mystery ledger

- **Settled — why rank is exactly half.** The divided identity `H^T(Hx/3)=4x` proves exactness
  structurally; determinant valuation gives an independent one-line rank proof.  Rank six is not
  an unexplained computational coincidence.
- **Settled by the second extra-juice pass — the integral object behind the code.** The full Smith
  form is `1,2^5,6^5,12`; its 3-primary cokernel is `(Z/3)^6`, and the Golay kernel is its Tor
  shadow, canonically matched to the tensor shadow by the divided operator.
- **Settled — how far the mechanism generalizes.** The exactness proof works for every integral
  matrix factorization of `p u I` with `u` a unit modulo `p`.  It does not transfer to the q=7
  order-eight sign model or C455's `11^3` Fourier scalar, because both primes occur to higher order.
- **Settled — where the Golay generators come from.** The block formula
  `H=[[1^T,1],[J-2A,-1]]` makes every extended incidence row a lower-row difference modulo three.
- **Settled from C470 — why the transpose carrier differs.** Rows and columns are outer-related
  labelled carriers.  Under the displayed but noncanonical identification their two self-dual
  codes meet in one line and span an eleven-space; this diagnostic is recorded but is not promoted
  to an invariant statement.
- **Settled by the signed-equivariance pass.** C470's recorded lifts preserve the integral pairing
  through the three literal adjoint identities above, so the exact complex is compatible with the
  known signed carrier geometry.
- **Settled after cross-check — the signed six-space transport is canonical.** The divided
  Bocksteins intertwine `R^T` with `M^T` and `M` with `R`, with explicit equal `6x6` kernel/cokernel
  action matrices.  C472 inherits this transport and only needs to classify its frozen signed and
  Weil structure.
- **Open, with exact owner — frozen signed/Weil interpretation.** C471 does not decide the central
  preimage of frozen `PSL_2(11)` or compare its six-space with the genuine Weil Brauer constituent.
  C472 owns that discriminator.
- **No other genuine C471 mystery remains.** Exactness, carrier orientation, relabelling,
  puncture/shorten recovery, the operator-derived flag, and the precise residual need for the
  retraction obstruction all have literal certificates and an independent replay.
