# C375: exact Clebsch `AME(6,11)` circuit and the fixed-layout `A5` obstruction

## Verdict

**THEOREM; THREE TWO-SITE GATES FROM THREE BELL PAIRS; EXACT `A5`-COVARIANT FAMILY,
BUT NO STRICTLY `A5`-FIXED BELL-TRIANGLE LAYOUT.**

In the fixed C374 convention, the Clebsch state has the explicit Pozsgay--Wanless factorization

```text
three Bell pairs + A_(4,5) + B_(4,6) + C_(5,6),
```

where the three gates are linear permutation unitaries over `F_11`.  Thus the state needs only
three arbitrary two-site unitaries after the Bell resources, or six in the source paper's model
when each Bell pair is itself created by one arbitrary two-site unitary.  This is an exact upper
bound, not a claim of global minimality in an arbitrary gate library.

The fixed state has an exact monomial `A5` action.  That action transports the displayed circuit
through a 20-layout covariant family, but no single Bell-triangle layout is fixed by all of `A5`.
The complete linear census has 120 oriented layouts: 100 factor and 20 do not.  Their six `A5`
orbits have sizes

```text
10, 10, 20, 20, 30, 30.
```

The two size-10 orbits are precisely the nonfactorable ones.  Consequently every factorable
layout has `A5` stabilizer of order at most three.  This is a topology-level obstruction to a
single strict fixed-layout intertwiner; it is not a lower bound against ancillas, coherent layout
registers, nonlinear tensors, or other circuit architectures.

The exact evidence is
[`2026-07-19-c375-clebsch-ame-circuit.py`](2026-07-19-c375-clebsch-ame-circuit.py),
[`2026-07-19-c375-clebsch-ame-circuit.json`](2026-07-19-c375-clebsch-ame-circuit.json), and
[`2026-07-19-c375-clebsch-ame-circuit.sha256`](2026-07-19-c375-clebsch-ame-circuit.sha256).

## Fixed state and circuit convention

Use C374's Pauli convention and its systematic generator

```text
G = [ I_3 | P ],                 P = [ 3  7  1 ]
                                         [ 3  1  7 ]
                                         [ 1 10 10 ].
```

The state is

```text
|Psi_C> = 11^(-3/2) sum_(u in F_11^3) |u, uP>.
```

Start with the standard Bell pairs on `(1,4)`, `(2,5)`, and `(3,6)`, so their common labels are a
column vector `a=(a_1,a_2,a_3)^T`.  On parties `4,5,6`, in the displayed order, apply the linear
permutation gates

```text
A_(4,5) = [ 1  1 ],     B_(4,6) = [ 3  1 ],     C_(5,6) = [ 8 10 ].
            [10  1 ]                 [ 7  1 ]                 [ 3 10 ]
```

Each matrix acts on the two computational labels of its named parties.  Their embedded product is

```text
C_(5,6) B_(4,6) A_(4,5)
    = [ 3 3  1 ]
      [ 7 1 10 ]
      [ 1 7 10 ]
    = P^T.
```

The resulting support is therefore exactly `(a,P^T a)`, which is the column-vector form of
`(u,uP)`.  The checker compares all `11^3=1331` resulting rows with the fixed Clebsch code, not
merely the product matrix.  Every entry and determinant of each `2 x 2` gate is nonzero, so each
gate is itself a four-leg perfect tensor in the linear finite-field sense used by
Pozsgay--Wanless.

This improves the direct systematic Clifford preparation

```text
3 one-site Fourier gates + 9 weighted SUM gates
```

to three arbitrary two-site gates once Bell pairs are supplied.  These counts use different gate
models and must not be compared as hardware costs without a chosen native library.

## Exact factorization test

For a chosen ordered gate side and matched Bell side, write `M` for the `3 x 3` linear transition
map.  The right-facing factorization

```text
M = C_(2,3) B_(1,3) A_(1,2)
```

exists exactly when

```text
Delta_right(M)
 = m11*m22*m33 + m12*m23*m31 - m11*m23*m32 - m12*m21*m33
```

is nonzero.  Reflection gives the corresponding left-facing criterion.  These are equations
`(4.5)` and `(5.1)--(5.13)` of Pozsgay and Wanless.  Every transition map here is superregular,
because it is a flattening of the fixed minimal-support AME state.

An oriented layout consists of a three-site gate side `T` and a bijection from `T` to its
three-site complement specifying the Bell pairs.  There are

```text
binom(6,3) * 3! = 120
```

such layouts.  For each, the checker tests all six simultaneous orderings of the pairs and both
factorization directions: `120*6*2=1440` directed tests.  The exact profile is:

| layouts | right passes | left passes | orderings passing either | factorable? |
|---:|---:|---:|---:|:---:|
| 20 | 0 | 0 | 0 | no |
| 40 | 3 | 3 | 6 | yes |
| 60 | 2 | 2 | 2 | yes |

Thus 480 directed tests pass, covering 360 layout/order pairs after taking the union of the two
directions.  Every passing test reconstructs the factors from the closed formulas and directly
multiplies them back to `M`.

## Precise `A5` action and intertwining condition

Let `d_i` be the six ordered Clebsch parity-check columns.  The C341 projective `A5` has a unique
determinant-one lift here because cubing is bijective on `F_11^*`.  For every lifted matrix `M_g`,
write

```text
M_g d_i = lambda_i(g) d_(pi_g(i)).
```

This defines a six-party monomial unitary on the computational basis by

```text
R_g |x_1,...,x_6> = |y_1,...,y_6>,
y_(pi_g(i)) = lambda_i(g) x_i.
```

The checker verifies all 60 matrices, all `60*1331` codeword images, and all `60^2` composition
laws.  Hence `g -> R_g` is an exact linear action and

```text
R_g |Psi_C> = |Psi_C>.
```

For C375, a **strict fixed-layout Bell-triangle intertwiner** means a three-gate decomposition in
which the `A5` action can be pushed through the network using local/virtual basis gauges while
preserving the same physical Bell matching, gate side, and triangle incidence.  Preserving that
layout is a necessary condition independent of the gate entries.  Equivalently, the layout must
have `A5` stabilizer 60.

The 60 induced party permutations were constructed twice: from the C341 reflection matrices and
independently by testing all `6!` projective permutations of the six arc points.  They agree.  The
120 layouts then split as follows:

| two conjugate orbits | orbit size | layout stabilizer | factorization profile |
|---|---:|---:|---|
| first pair | 10 | 6 | `(0,0,0)`; impossible |
| second pair | 20 | 3 | `(3,3,6)`; factorable |
| third pair | 30 | 2 | `(2,2,2)`; factorable |

There is no orbit of size one, even before imposing factorization.  More sharply, the largest
stabilizer among factorable layouts has order three.  The displayed circuit lies in a size-20
orbit and realizes that maximum.

There is nevertheless an exact **covariant family**: applying `R_g` transports a circuit at layout
`L` to a locally dressed circuit at layout `gL`.  Factorability is constant on every orbit.  Thus
the obstruction is to choosing one globally fixed minimal layout, not to `A5` covariance of the
family.

C373's outer normalizer character is visible without adding an assumption.  The degree-six action
has normalizer order 120, and its canonical outer element exchanges the two size-10 orbits, the two
size-20 orbits, and the two size-30 orbits.  It preserves the factorability verdict while swapping
each chiral partner.  This is compatibility with the existing chirality torsor, not a new general
outer-symmetry theorem.

## Free encoder and perfect-tensor upgrades

The same fixed state gives six explicit five-leg encoders.  For any chosen logical leg `j`, define

```text
V_j |a> = 11^(-1) sum_(c in C, c_j=a) |c with coordinate j deleted>.
```

Each fiber has `11^2` words.  For every one of the six choices and every one of the ten two-site
erasure sets, the checker verifies the diagonal uniformity and the vanishing off-diagonal
Knill--Laflamme terms.  Therefore every `V_j` is a pure quantum-MDS encoder with parameters
`[[5,1,3]]_11`.

If one of these encoders were locally unitarily equivalent, including a logical-leg unitary, to a
six-point GRS encoder, their normalized Choi states would be LU equivalent.  C374 excluded that
possibility even after all six party permutations.  The six encoders therefore inherit the same
bounded non-GRS LU separation.

Likewise every `3|3` split gives an explicit permutation unitary

```text
U_T |x> = |M_T x>.
```

The certificate checks all 20 oriented source triples and records their nonzero determinants.
This is the exact multiunitary/perfect-tensor form of the Clebsch state; it does not claim a new
general AME--perfect-tensor dictionary.

## Evidence, replay, and trusted boundary

From the repository root:

```bash
python3 notes/2026-07-19-c375-clebsch-ame-circuit.py --check
sha256sum -c notes/2026-07-19-c375-clebsch-ame-circuit.sha256
```

The generator is deterministic, writes canonically sorted JSON only under `--write`, and under
`--check` regenerates into a temporary directory and byte-compares with the tracked artifact.  It
depends on the committed C341 checker with SHA-256
`4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be`.

The manifest records:

| artifact | bytes | SHA-256 |
|---|---:|---|
| Python checker | 23,500 | `5e75029ccc6b2c4135ca841bbc6e0d9a72bfe8c7c4726feae51f470c53ad3b7b` |
| canonical JSON | 8,047 | `44413bc24cb41aa914dd6f50a3db3292be4c7a5e22a4ee86ffe8d7044d27afa7` |

The exact trusted boundary is:

- the fixed circuit is checked on all 1,331 support rows;
- the linear factorization census covers exactly the 120 Bell-triangle layouts and the published
  necessary-and-sufficient linear equations;
- the strict equivariance negative uses the stated fixed-layout definition and the complete
  induced degree-six `A5` action;
- no result here rules out nonlinear three-gate decompositions at the 20 failed layouts, circuits
  with another topology, ancilla/coherent-layout intertwiners, or a two-gate construction;
- no claim is made about native-gate minimality, noise, experiments, or holography.

## Literature boundary

The load-bearing external source is Pozsgay and Wanless,
[*Tensor network decompositions for absolutely maximally entangled states*](https://doi.org/10.22331/q-2024-05-08-1339),
arXiv `2308.07042v3`.  This task read the abstract and Sections 3.1--6.3, including equations
`(3.4)`, `(4.5)`, and `(5.1)--(5.13)`, plus Appendix B's graph-state gate-count comparison, from
the cached PDF/text with SHA-256
`75ce8acc1988534ceb941d134bbc0e3b7ec75f01b05fcd200c0facdba6611038`.
Their paper already proves the general linear factorization criterion and supplies examples for
all finite fields of order at least five.  C375 contributes only the exact fixed Clebsch instance,
its complete `A5` layout census, and the resulting bounded intertwiner statement.  No priority
wording is used.  The general AME--MDS--QECC dictionary remains prior art as recorded in C371 and
C374.

## Ownership and hand-back

- C374 continues to own LC/LU separation from all six-point GRS AME classes.
- C375 owns the displayed circuit, the 120-layout linear census, the strict fixed-layout
  equivariance obstruction, and the encoder/perfect-tensor corollaries above.
- The lane discovery companion records only the ancillary/coherent-layout and nonlinear-obstruction
  leads that fall outside this bounded gate; they are not allocated work.
- Nothing here opens holographic design or an experimental-performance claim.
