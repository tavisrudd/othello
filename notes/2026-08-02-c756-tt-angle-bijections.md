# C756 — TT pass: simultaneous angle binomiality

**Lane**: clebsch · **Date**: 2026-08-02 · **Scope**: saturated-internal
proof design and bounded prime-field diagnostic

## Verdict

The saturated-internal reduction used only the product of each forced angle
coset.  The full angle-bijection statement is much stronger: at every arc
point, all intermediate elementary symmetric functions and power sums vanish.

Let

$$
 m=\frac{q+1}{2},\qquad
 \alpha_{ij}=f_j(z_i)^{1-q}\in\mu_{q+1}.
$$

For every saturated-internal arc and every base point $i$,

$$
 \boxed{\prod_{j\ne i}(X-\alpha_{ij})=X^m+1.}             \tag{A1}
$$

The formerly used product constraint is only the constant coefficient of
(A1).  The first unused coefficient is

$$
 \boxed{\sum_{j\ne i}\alpha_{ij}=0\quad\text{for every }i.} \tag{A2}
$$

This is the best new theorem-shaped gate exposed by the Tao pass.  In the
bounded independent prime-field enumeration, (A2) holds in every row of both
$q=5$ frames and fails in at least one row of every one of the 167
pairwise-character candidates at $q>5$.  In five of the six tested fields it
fails in exactly all but one row of every candidate.  This is finite evidence, not an
all-field proof, but it sharply upgrades simultaneous angle bijections from a
vague option to the leading exact-algebra route.

Evidence:
notes/2026-08-02-c756-simultaneous-angle-moments.py and
notes/2026-08-02-c756-simultaneous-angle-moments.json.

## 1. Exact all-field identity

Fix an arc point $P_i=\{z_i,z_i^q\}$.  The circle normal form already proves
that the $m=k-1$ relative angles

$$
 \alpha_{ij}=f_j(z_i)^{1-q},\qquad j\ne i,
$$

are distinct and fill the odd coset of the index-two subgroup of
$\mu_{q+1}$.  That coset is exactly the root set of $X^m+1$: every member
satisfies $\alpha^m=-1$, and $p\nmid m$.  This proves (A1).

Equating coefficients gives, for $1\le r<m$,

$$
 e_r(\alpha_{i1},\ldots,\widehat{\alpha_{ii}},\ldots,
     \alpha_{ik})=0,                                     \tag{A3}
$$

and Newton's identities equivalently give

$$
 \sum_{j\ne i}\alpha_{ij}^r=0
 \qquad(1\le r<m).                                       \tag{A4}
$$

These identities hold simultaneously for all $k=(q+3)/2$ base points.  The
number of displayed row conditions is $k(m-1)$, approximately $q^2/4$,
against a configuration with only $O(q)$ geometric degrees of freedom.  They
are highly dependent, but treating only their constant terms discarded the
most overdetermined part of the saturated problem.

## 2. Cleared-denominator binomiality

Put $a_{ij}=f_j(z_i)$.  Since $a_{ij}^q=f_j(z_i^q)$ and
$\alpha_{ij}=a_{ij}/a_{ij}^q$, (A1) is equivalent to

$$
 \boxed{
 \prod_{j\ne i}\bigl(Xf_j(z_i^q)-f_j(z_i)\bigr)
   =F_i^q(X^m+1),
 }
 \qquad
 F_i=\prod_{j\ne i}f_j(z_i).                             \tag{A5}
$$

The constant coefficient of (A5) recovers
$F_i^{q-1}=(-1)^m$, hence the previously recorded master-polynomial
divisibility.  Every middle coefficient of (A5) is new input.

Coordinate-free interpretation: the closed degree-two point
$D_i=\{z_i,z_i^q\}$ has two conjugate geometric fibres.  Restrict the other
$m$ quadratic factors to those fibres and take their product as a binary form
in the two conjugate evaluations.  Equation (A5) says this binary form has
only its two extreme coefficients.  Thus the real intrinsic object is a
simultaneously binomial first-jet/cofactor section on every component of the
arc divisor, not the single derivative congruence for $G$.

## 3. Bounded prime-field diagnostic

The checker enumerates every normalized pairwise-character candidate in the
audited prime fields and evaluates every base-point row.  It independently
recomputes the candidate sets using the Python field model and checks their
counts against the Rust saturated-internal audit.

| $q$ | candidates | all rows satisfy (A2) | all rows satisfy (A1) | failing-row counts per candidate |
|---:|---:|---:|---:|---|
| 5  | 2  | 2 | 2 | $0^2$ |
| 7  | 5  | 0 | 0 | $4^5$ |
| 11 | 28 | 0 | 0 | $6^{28}$ |
| 19 | 55 | 0 | 0 | $10^{55}$ |
| 23 | 39 | 0 | 0 | $6^{26},12^{13}$ |
| 31 | 17 | 0 | 0 | $16^{17}$ |
| 43 | 23 | 0 | 0 | $22^{23}$ |

For example, $4^5$ means that each of the five candidates has four rows with
nonzero first moment.  At $q=7,11,19,31,43$, exactly one row of every candidate
satisfies (A2).  The $q=23$ split is the only texture: 26 candidates have six
failing rows and 13 have twelve.  No tested candidate first survives (A2)
and then fails only at a higher moment.

The scope excludes extension fields.  In particular, $q=27$ remains part of
the already owed extension-field hygiene and is not silently inferred from
the prime-field pattern.

## 4. Tao attack order

### 4.1 First-moment matrix

Form the $k\times k$ matrix

$$
 \mathsf A_{ij}=\begin{cases}
   \alpha_{ij},&i\ne j,\\
   0,&i=j.
 \end{cases}                                              \tag{A6}
$$

Then (A2) is simply $\mathsf A\mathbf1=0$.  Each entry is the cross-ratio

$$
 \alpha_{ij}=
 \frac{(z_i-z_j)(z_i-z_j^q)}
      {(z_i^q-z_j)(z_i^q-z_j^q)}.                         \tag{A7}
$$

The first proof target is therefore concrete:

> Evaluate or control the determinant/rank of the cross-ratio matrix
> $\mathsf A$ under the pairwise resultant-character and conjugation
> conditions, and prove that $\mathbf1$ cannot lie in its kernel for $q>5$.

The entries in (A7) are products of two Cauchy-type ratios.  Cauchy--Binet,
Borchardt-type determinant identities, or displacement-rank methods are more
appropriate here than another Paley eigenvalue estimate.

### 4.2 Global cofactor interpolation

For each middle coefficient in (A5), construct the corresponding cofactor
section on the reduced arc divisor $D=\operatorname{div}(G)$.  The vanishing
at every $D_i$ should be expressed as divisibility by $G$.  The desired win is
a degree comparison: a nonzero global covariant of degree below $\deg G=q+3$
cannot vanish on all of $D$.

The technical point is to remove the vanishing factor $f_i$ canonically.
The correct home is the conormal/first-jet line of $D_i$, not an ad hoc
division by $f_i$.  This is the precise Hasse--Cartier interface left open by
the coordinate-free pass.

### 4.3 Sparse signed Paley trade

The coherent indicator
$x=\mathbf1_Z-\mathbf1_{Z^q}$ is a sparse integral eigenvector of the Paley
operator.  It should be treated as a signed trade or equitable two-cell
partition, not merely as an equality case of interlacing.  The needed theorem
would classify $\{0,\pm1\}$ eigenvectors of support $q+3$ with conjugate
positive and negative supports.  Integrality, support minimality, and higher
autocorrelation moments are the unused constraints; raw entropy has already
been falsified as too weak.

### 4.4 Do not force a global Moore divisor

On the nonsaturated side, the TT conclusion from the coordinate-free pass is
negative but useful.  The residual divisors live canonically only over the
Frobenius-fixed fibres.  Aggregate on the Frobenius graph or fixed-locus
incidence space; do not interpolate them into an ordinary divisor on the
whole blow-up.  A trace/norm over all rational fibres is more plausible than
a nonexistent geometric family.

## 5. Replay and trust boundary

Run from rust/:

    python3 ../notes/2026-08-02-c756-simultaneous-angle-moments.py --check
    sha256sum ../notes/2026-08-02-c756-simultaneous-angle-moments.{py,json}

| artifact | bytes | SHA-256 |
|---|---:|---|
| notes/2026-08-02-c756-simultaneous-angle-moments.py | 5,039 | b179ffa6f85e019993cc101d10a04bd96b2d03096c1f0b054991bbd517b8532a |
| notes/2026-08-02-c756-simultaneous-angle-moments.json | 2,505 | 951d78982ec9238106d7a22b3fa298e4a027fd7fd5b1124baa48ffdd31862c30 |
| input notes/2026-08-01-c756-probability-cheap-tests.py | 20,904 | 34fe706268e51f4ed09a95ec64424430e11f46d9e03fae320ca16eac0580fff2 |
| input notes/2026-08-01-c756-saturated-internal-audit.json | 3,842 | acabee2fa04d61e6673c60a5cc429ba11f9e294e233a96c53d8451d91f6104d7 |

The all-field identities (A1)--(A5) are human consequences of the proved
angle-coset bijection.  The computation certifies only the stated normalized
candidate sets in seven prime fields.  It does not prove that (A2) is
impossible for every $q>5$, classify extension fields, or establish any
novelty claim.

## 6. EJ + TT verdict and mystery ledger

**EJ.**  The free upgrade was to test the first discarded coefficient before
building machinery for all of (A1).  It already separates the two positive
frames from every tested negative candidate.  The row-count profile also
shows that the obstruction is not a fragile one-row normalization: except at
$q=23$, all but one row of every negative candidate fail.  Hence higher angle
moments should remain parked until the first-moment matrix route is exhausted.

**TT.**  Stop treating spectral tightness as the whole saturated structure.
It explains why the support size is possible, but the simultaneous odd-coset
rows impose a much more rigid cross-ratio design.

The saturated branch is no longer best viewed as “classify a tight Paley
double clique.”  That description explains the second moment but hides the
stronger geometry.  The more rigid statement is:

> classify configurations whose cross-ratio matrix has every row equal, as a
> multiset, to the full odd norm-one coset.

This gives two algebraic handles—matrix rank and simultaneous binomial
cofactors—that genuinely use all base points.

| mystery | status | exact gap |
|---|---|---|
| Was only the product of the angle coset being used? | settled | yes; (A1)--(A5) recover all discarded coefficients |
| Does the first new coefficient have empirical force? | settled boundedly | it separates both $q=5$ frames from all 167 tested $q>5$ prime-field candidates |
| Is (A2) uniformly impossible for $q>5$? | open | prove cross-ratio matrix nonsingularity on $\mathbf1$, or globalize the first cofactor below degree $q+3$ |
| Why does $q=23$ have two failing-row profiles? | open | identify the two candidate orbit types; this is diagnostic texture, not yet a separate task |
| Do higher moments add anything after (A2)? | open but secondary | no tested candidate survives (A2); defer higher moments until an all-field first-moment analysis stalls |
| Does this change full-theorem odds? | saturated crown improves, full crown does not yet | it is the strongest new exact saturated gate since coherence, but the nonsaturated branch remains independent |
