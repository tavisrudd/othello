# C409 — cubic first-memory principle and trade filtration

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; ONE COMMON EXACT-STRENGTH-TWO MOMENT FILTRATION, SHARP ON THE PASCH FAMILY; CLASSICAL/FORMAL NORMALIZATION, NOT A NEW FLAGSHIP`

## Result in one line

C403, C406, and C408 are three instances of the same signed-feature filtration

```text
M_j(epsilon,phi)=sum_omega epsilon(omega) phi(omega)^(tensor j).
```

In each case `M_0=M_1=M_2=0` and `M_3!=0`, so the signed configuration has exact moment-trade
strength two.  Affine changes of feature coordinates preserve that statement, scalar generating
functions acquire a triple root at one, and classical simple `2`-design trades give the incidence-
vector specialization.  The Pasch trade and every common-core extension attain exact strength two,
so cubic first survival is sharp.  It is not universal for all balanced trades: a `3`-trade also
balances through degree two and survives no earlier than degree four.

This is a precise common theorem, but its abstract content is classical/formal.  The value of the
normalization is diagnostic: it identifies the genuinely geometric input in each source theorem as
the proof that its third moment is nonzero, not the general moment filtration itself.

## Unified signed-feature filtration

Let `R` be a commutative ring, `V` an `R`-module, `Omega` a finite set,
`epsilon:Omega -> R` a signed weight, and `phi:Omega -> V` a feature map.  Put

```text
M_0=sum_omega epsilon(omega),
M_j=sum_omega epsilon(omega) phi(omega)^(tensor j) in V^(tensor j),  j>=1.
```

Every `M_j` is fixed by permutation of its tensor factors.  Say that `(epsilon,phi)` is balanced
through degree `s` when `M_0,...,M_s` vanish, and has **exact strength `s`** when additionally
`M_(s+1)` is nonzero.

### Affine covariance lemma

If `M_0,...,M_s=0` and `phi'(omega)=A(phi(omega))+b`, then

```text
M_0(epsilon,phi')=...=M_s(epsilon,phi')=0,
M_(s+1)(epsilon,phi')=A^(tensor (s+1)) M_(s+1)(epsilon,phi).
```

Indeed, expand every factor of `(A phi+b)^(tensor j)`.  Every term containing fewer than `j`
copies of `A phi` is an insertion of a lower moment and vanishes.  Thus exact strength is invariant
under affine coordinate isomorphism.  A noninjective linear quotient may kill the first surviving
tensor, so no stronger convention-independence is claimed.

For `s=2`, this also explains C406's reference independence: translating every quotient form
`Phi_M` by the same form changes `M_3` only by terms involving `M_0,M_1,M_2`.

### Scalar generating-function lemma

When `phi(omega)` is a nonnegative integer `d(omega)`, set

```text
F(x)=sum_omega epsilon(omega)x^d(omega).
```

Then `(x-1)^(s+1)` divides `F(x)` exactly when the falling-factorial moments

```text
sum_omega epsilon(omega) (d(omega))_j,  0<=j<=s,
```

vanish.  The Stirling transforms between falling-factorial and raw powers are unitriangular over
the integers, so this is equivalent to `M_0=...=M_s=0`.  Consequently an exact scalar strength-two
trade has a triple root at one and a nonzero third raw moment.

### Incidence-trade lemma

Let every block `B` of a finite point set have incidence vector `v_B` and let `epsilon(B)` be its
signed multiplicity.  The tensor coordinate of `M_j` indexed by an ordered tuple
`(i_1,...,i_j)` is the signed number of blocks containing the set of distinct entries in that
tuple.  Therefore a classical `t`-trade is exactly an incidence-vector signed configuration
balanced through degree `t`.  It has first survival in degree `t+1` exactly when it is not also a
`(t+1)`-trade.

This formulation uses full symmetric tensors rather than polynomial coefficients, so it introduces
no factorial convention and remains valid in small characteristic.

## Exact normalization of the three mechanisms

| source | signed ground set and weight | feature space and feature | balance through degree two | first surviving datum |
|:---|:---|:---|:---|:---|
| C403 | disjoint union of the projective test lines for two realizations, with signs `+1/-1`; equal mirror atoms cancel after puncturing | scalar integer depth `D_A(L)=sum_(X on L)(m(X)-1)` | equal line count and equal singular-weight power sums `a_1,a_2` force `Delta M_0=Delta M_1=Delta M_2=0` | `Delta M_3=6 Delta T_3` when the weight multisets agree; the pinned pairs have `Delta T_3!=0` |
| C406 | the `2q` matching-orbit points, signed by the two `PSL_2(q)` sheets | the quotient form `Phi_M=(P_M-P_0)/Q` in the finite-field conic-ideal image space | the exact certificate proves the signed first and second tensor moments vanish; equal sheet sizes give `M_0=0` | the signed cubic tensor `mu_3` is nonzero and outer-odd |
| C408 | the difference of the two projective weighted-adjoint test-point multisets, pushed forward by depth | scalar depth over the coefficient ring `Z[Q]` | the local depth ledger has zero signed mass, mean, and quadratic moment | `M_3=12(Q-7)` and the generating defect is `(Q-7)x(x-1)^3(x+1)` |

For C403 the line-counting identities are

```text
sum_L D(L)   = (q+1)a_1,
sum_L D(L)^2 = q a_2+a_1^2,
sum_L D(L)^3 = (q-2)a_3+3a_1a_2+6T_3.
```

Thus the common filtration does not replace its incidence theorem: equality of the singular-weight
multiset supplies the first two cancellations, while external collinear triples supply the
nonzero cubic.

For C406 the feature is genuinely vector-valued.  Applying a scalar functional to `Phi_M` gives a
scalar shadow of the same filtration, but an unfortunate functional may annihilate `mu_3`.
Retaining the full tensor is therefore load-bearing.

## C408 as a signed local incidence trade

After removing the common coefficients, the two universal depth ledgers differ only at four depths:

| depth `d` | signed multiplicity divided by `Q-7` |
|---:|---:|
| `1` | `-1` |
| `2` | `+2` |
| `4` | `-2` |
| `5` | `+1` |

This is the compressed signed incidence trade on the test-line/depth bipartite ledger.  Directly,

```text
(-1)+2-2+1=0,
(-1)+2*2-2*4+5=0,
(-1)+2*2^2-2*4^2+5^2=0,
(-1)+2*2^3-2*4^3+5^3=12.
```

Its generating function is therefore

```text
-x+2x^2-2x^4+x^5=x(x-1)^3(x+1).
```

Multiplication by the free-line count `Q-7` gives C408's complete defect.  This proves the factor
from the local ledger without interpolation, extension-field enumeration, or appeal to the already
factored output.  The factor `Q-7` records the base-field collision; the triple root records exact
moment-trade strength two.  These are logically different cancellations.

## Fixed elementary family: Pasch trades with a common core

On six points, take

```text
T_+={123,145,246,356},
T_-={124,135,236,456}.
```

Every point and every pair occurs equally in the two legs, so this is a simple `2-(6,3)` trade and
its incidence-vector moments `M_0,M_1,M_2` vanish.  The `(1,2,3)` coordinate of `M_3` is `+1`,
because `123` occurs only in `T_+`.  Hence its strength is exactly two and cubic survival is forced
by the incidence-trade lemma.

More generally, fix any set `C` disjoint from these six points and replace every block `B` by
`C union B`.  Equal volumes balance subsets inside `C`; point balance handles subsets with one
point outside `C`; pair balance handles subsets with two outside points.  The `(1,2,3)` component
of the cubic tensor remains `+1`.  Thus for every block size `k>=3` the common-core Pasch family is
a simple exact-strength-two `2-(v,k)` trade with first survival in degree three.

This family passes the bounded gate and proves sharpness.  It also supplies the necessary stop:
degree three is the first **possible** memory after quadratic balance, not the first memory of every
such configuration.  Any `3`-trade has `M_3=0`; more generally the first moment that remembers a
trade is one above its exact strength.

## Literature disposition

This pass read **zero external sources in full**, one partially, and three at
abstract/metadata depth; it also reused the source boundaries already recorded by C403 and C406.
The deliverable makes no novelty, priority, or unrestricted absence claim.

- **Ghorbani--Kamali--Khosrovshahi--Krotov, *On the Volumes and Affine Types of Trades*,
  arXiv:1810.02296v2: partial, cached PDF/text, Introduction, Section 2.1, and Lemmas 2--4;
  cache SHA-256 `36cffc0509d205117fa339fde93046cd8f2bcc4eadbb3a9a4b70e47e286ae20b`.**
  It defines `[t]`-trades by equal containment counts through order `t`, identifies classical
  fixed-block-size trades as a special case, and records minimum nonvoid volume `2^t` and its
  product-form family.  This owns the classical trade language behind the Pasch/common-core test.
- **Delsarte, *Hahn Polynomials, Discrete Harmonics, and t-Designs*, DOI
  `10.1137/0134012`: abstract/metadata only, official SIAM page.**  The accessible record places
  harmonic functions and `t`-designs in one algebraic framework.  No detailed theorem from the
  paper is used here, and the full text was not obtained.
- **Ferroni--Vecchi, *Matroid relaxations and Kazhdan--Lusztig non-degeneracy*,
  arXiv:2104.14531: abstract/metadata only, official arXiv record.**  Circuit-hyperplane relaxation
  is a standard matroid modification but is not the C408 signed incidence trade and supplies none
  of the moment statement used here.
- **Berthome--Cordovil--Forge--Ventos--Zaslavsky, *An elementary chromatic reduction for gain
  graphs and special hyperplane arrangements*, DOI `10.37236/210`: abstract/metadata only,
  official EJC page.**  Its switching is gain-graph switching that preserves the associated bias
  data; it is a terminology collision, not the point/test-line ledger switch in C408.
- **Ardila; Liang--Wang--Zhao; Cai--Fu--Wang: secondary only through the C403 report's recorded
  full/partial primary readings.**  Those sources own the finite-field coboundary, weighted
  parallel-copy, and adjoint/restriction interfaces.  C409 adds no competing attribution.
- **Filmus--Lindzey and Chien--Kang: secondary only through the C406 report's recorded full-text
  readings.**  They delimit matching harmonics and real group-orbit moment designs; C409 does not
  re-open C406's priority boundary.

Exact title/abstract searches covered design trades and Pasch trades, harmonic/design moments,
matroid relaxation and switching, gain-graph arrangement switching, and arrangement realization
moduli.  The searches located the classical trade framework and several unrelated meanings of
“switching,” but no source was used to assert absence of the combined normalization.  MathSciNet,
zbMATH, Google Scholar, and a three-database forward-citation closure were not covered.  The correct
positioning is therefore deliberately modest: the unified lemma is elementary and the three exact
strength-two instances remain the substantive upstream results.

## Evidence and trusted boundary

The proof above is algebraic and incidence-theoretic; C409 adds no generated certificate.  Its
load-bearing computed inputs are the already committed and independently replayed C403, C406, and
C408 bundles:

| input | bytes | SHA-256 | consumed fact |
|:---|---:|:---|:---|
| `notes/2026-07-20-c403-arrangement-complement-distance.json` | `234075` | `1bc47da2bf0f2f07b5e48d7b1242c8bd104b8a98a65174e1023b7119953f6f90` | the pinned scalar moment pairs and nonzero cubic differences |
| `notes/2026-07-20-c406-matching-module.json` | `20547` | `39949eed9e53b414aac1a93e918c78683db067e572952bb51c286921967d8dd0` | `mu_1=mu_2=0`, `mu_3!=0`, reference independence, and exact sheet recovery |
| `notes/2026-07-20-c408-pointed-profile-forgetting-gate.json` | `10089` | `2d29cc235b22944589d813f73660597c12b9745152055cadcee3e2ff0a746ebd` | the four universal depth-coefficient differences |

The displayed tensor, generating-function, C408-ledger, and Pasch-family arguments independently
derive the new synthesis from those facts.  The trusted boundary is elementary tensor expansion,
Stirling change of basis, finite incidence counting, and the three upstream certificates for their
instance-specific nonvanishing claims.  This report does not prove that every geometric quadratic
balance has cubic memory, that the three cubic tensors are naturally isomorphic, or that the common
formalism carries novelty beyond its source theorems.

## Hand-back

C409's research gate is complete.  The answer is a precise but non-flagship theorem: all three
mechanisms are exact-strength-two signed-feature trades, affine normalization preserves the first
surviving tensor, and the Pasch/common-core family proves cubic sharpness.  The normalization also
prevents overstatement: higher-strength trades remember later, and noninjective quotients can erase
the cubic.  C410 may now use `M_0=M_1=M_2=M_3=...=0` coefficientwise as its scalar-tower cancellation
language rather than treating the C408 polynomial as an isolated factorization.
