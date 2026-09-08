# Adversity-complete witness cores: research prototype

Prepared September 5, 2026. This is a new reference prototype, not a modification
of the ergodis repository and not a production performance result.

## Run

Python 3.10 or later, standard library only:

    python test_adversity_cores.py

The test runner writes `test_results.json`. Assertions must be enabled.

## Mathematical contract

Let F be a finite family of executable witnesses, with physical support H(x)
contained in a finite universe E, |H(x)| <= r, and a fixed baseline cost w(x).
The prototype accepts integer costs. The mathematical statements permit any
finite real costs. Let min(empty)=infinity.

A subfamily Q is f-complete if, for every J contained in E with |J| <= f,

    min {w(x): x in F, H(x) intersect J is empty}
      = min {w(x): x in Q, H(x) intersect J is empty}.

The universal size bound is binomial(r+f,r). This bound and the weighted
exterior-algebra construction are classical representative-family results,
not a novelty claim. In coding applications, use actual functional labels;
an existing quotient designed only for unit-cost minima is not automatically
sound for this richer contract.

### Adversity theorem

Let U be the union of supports of Q. For any D contained in E such that
|D intersect U| <= f, and any inclusion-monotone function
psi: 2^D -> [0,infinity], the exact optimum of

    w(x) + psi(H(x) intersect D)

is the same over F and Q.

Proof. For any x in F, put J=(D intersect U) minus H(x). By f-completeness,
there is y in Q avoiding J with w(y) <= w(x). Since H(y) is contained in U,
H(y) intersect D is contained in H(x) intersect D. Monotonicity gives the
objective inequality. Taking minima, and using Q subset F, proves equality.

In particular, price increases or failures outside U can be arbitrarily
numerous. The budget concerns changed resources inside U. This is a sufficient
contract, not a claim that Q is wrong whenever that budget is exceeded.
Conversely, preservation of all monotone penalties supported on at most f
resources implies f-completeness by taking an infinite penalty for touching a
forbidden resource. Thus failure-optimum preservation characterizes the
whole monotone-observation class.

### Representative compression is not per-witness equivalence

For f >= 1, any two different physical supports are distinguished by a
single-resource failure: fail an element in their symmetric difference.
Consequently all r-subsets of an n-set are pairwise distinguishable as
individual feasible/infeasible witnesses, although the all-r-subsets family
with equal baseline costs has an f-complete catalog of binomial(r+f,r)
witnesses whenever n >= r+f. Choose any r+f resources and retain all their
r-subsets. For f=1, r+1 witnesses suffice even though none of the original
binomial(n,r) witness states can be merged pairwise.

This separates representative domination of a minimum from equality of
individual witness behaviours. It is not a lower bound against every
portfolio-level contextual quotient or every symbolic representation.

### Sparse-dual completeness

Demand j has a witness family F_j, baseline costs w_j, and an f_j-complete
catalog Q_j with support union U_j. A witness consumes one unit of each resource
in its support. Consider the fractional master problem

    minimize sum_(j,x) w_j(x) z_(j,x)
    subject to sum_x z_(j,x) = 1,
               sum_(j,x: h in H(x)) z_(j,x) <= C_h,
               z >= 0.

First solve it using only Q_j. A resource-price vector p >= 0 and numbers a_j
are dual-feasible for that restricted problem if

    a_j <= w_j(x) + sum_(h in H(x)) p_h       for every x in Q_j.

If |support(p) intersect U_j| <= f_j for every demand, they are also feasible
for the full problem: the adversity theorem says the minimum of each priced
local objective over Q_j equals the minimum over F_j. Therefore a restricted
primal/dual pair with equal objectives certifies the full fractional optimum.
An integral assignment with that same objective certifies the integer optimum.
Without equality to a checked lower bound, no integer optimality follows.

Failures can be included by replacing the sparsity test with
|(failed union support(p)) intersect U_j| <= f_j and filtering failed
witnesses before solving the restricted master.

### Dense prices modulo a conserved grading

Suppose a certified identity gives a_j dot 1_H = gamma_j for every witness
of a fixed interface, and p=a_j+d_j with d_j >= 0. Only d_j affects which
witness minimizes the priced objective. Sparse-dual completeness therefore
also applies when |support(d_j) intersect U_j| <= f_j, even if p is dense.
For an exact-cardinality interface |H|=k, a constant price vector contributes
only its constant times k. The conservation identity must hold for the whole
source family, not merely the retained catalog.

### Labelled composition

Assume child physical universes are disjoint, supports compose by union,
baseline costs add, and compatibility is determined by retained semantic
labels. Keep separate portfolios for each label b and exact support size k.
For each compatible child pair, form its support union and lifted witness;
then compress within the resulting label and exact degree. This preserves
f-completeness by replacing each child of a raw feasible combination by a
no-more-expensive representative avoiding the same forbidden set. Labels and
degrees remain unchanged, so the replacement composes and respects the radius.

The retained size per label through radius r is at most

    sum_(k=0)^r binomial(k+f,k) = binomial(r+f+1,r).

At a completed root with a fixed radius, a final compression can forget the
intermediate degree and return at most binomial(r+f,r) witnesses. That step
must not be performed prematurely before further radius-sensitive composition.
This does not bound the number of algebraic labels or the cost of compiling
local coefficient fibres.

### An oracle construction without enumerating F

Assume an exact oracle returning a cheapest witness avoiding a supplied set J,
or a certified infeasibility result. Query at J=empty. At a node J with a
returned witness x, branch to J union {h} for each h in H(x), stopping at depth f.
Collect every returned witness, and compress the collection afterward.
At most 1+r+...+r^f oracle calls are needed (fewer with memoization).

Proof. For any true failure set D of size at most f, follow a branch whose
new element belongs to H(x) intersect D whenever the current x fails. All
forced sets remain subsets of D. Eventually a returned witness avoids D and
is no more costly than its optimum, because it was optimal under a subset of
D. A certified infeasibility node is safe for all extensions of its forced set.

The prototype's oracle wrapper checks returned feasibility, not optimality.
An end-to-end certificate requires optimality evidence for the oracle calls,
or a separately verified exact oracle. The oracle may still be computationally
hard; the theorem bounds its number of invocations, not the cost of a call.

### Integer batch-scheduling consequence

For b demands, each using at most r resources and one unit per used resource,
choose each local representative budget s=f+r(b-1). For any positive integer
capacity vector and at most f failed resources, restricting every demand to its
s-complete catalog preserves the minimum-cost integral schedule.

Proof. In an optimal schedule, freeze every demand except j. Resources already
saturated by the other demands number at most r(b-1). Avoid those and the failed
resources when replacing j by a no-more-expensive representative. The new
schedule stays feasible. Repeat for every j. This preserves an optimum using
only catalogs. This is parameterized by batch size; it is not a claim of a
uniformly small catalog for arbitrary batches.

### Reliability and cost-distribution guarantee

Let D be any random failure set, including correlated failures. Let X and X_Q
be the cheapest surviving baseline costs in F and Q, with infinity allowed.
Then X <= X_Q, and X=X_Q whenever |D intersect U| <= f. Consequently

    total_variation(law(X), law(X_Q)) <= Pr[|D intersect U| > f].

In particular, for every cost threshold t,

    0 <= Pr[X <= t] - Pr[X_Q <= t] <= Pr[|D intersect U| > f].

The same inequality holds for probability of a finite cost, i.e. successful
recovery. It counts availability events once, not recovery witnesses.
Under independent core failures with probabilities epsilon_h, an explicit
upper bound is the elementary symmetric polynomial of degree f+1 in those
probabilities, clipped at 1. Under a common epsilon it is
binomial(|U|,f+1) epsilon^(f+1), also clipped at 1. The exact Poisson-binomial
tail is a stronger bound where available.

All multivariate coefficients through total degree f in the expansion at
zero failure probability agree. They can be obtained by Mobius inversion on
failure subsets of U of size at most f; no low-order coefficient involving
an outside variable is nonzero. This holds for every cost threshold.

The probability bound is sharp: let Q contain every r-subset of an (r+f)-set U,
and let F additionally allow every r-subset after adding r perfectly reliable
outside resources. Give inside resources zero cost and outside resources high
cost. Q is f-complete, F always recovers, and Q fails exactly when more than f
members of U fail.

## Certificate construction

Choose a prime P > |E|+r and vectors

    v_h=(1, alpha_h, ..., alpha_h^(r+f-1))

with distinct alpha_h for all physical resources and r dummy resources. Pad
each support to size r using the first needed dummies. Its feature is the
r-fold exterior product. The feature space has dimension binomial(r+f,r).
Process witnesses in nondecreasing baseline-cost order and retain a feature
only when independent of those already retained.

Each discarded feature is a linear combination of features of retained
witnesses having no greater baseline cost. Wedge that identity with any
forbidden set of size at most f. If the discarded support avoids the forbidden
set, its wedge is nonzero, so at least one of those retained supports also
avoids it. This proves f-completeness.

`compile_core` computes features through determinants of minors.
`verify_core` recomputes them through iterative exterior products and checks
coverage, dependencies, cost inequalities, and field conditions. This is a
separate checking path, not a proof-assistant formalization or an external audit.
The auxiliary feature field is unrelated to the code's field. A feature
identity is not an instruction to linearly combine the recovery witnesses.
The returned witnesses themselves must remain valid concrete recoveries.

These certificates establish completeness relative to the supplied family.
To certify an implicit family, also verify the composition/leaf coverage or
oracle proof tree. No constant-size certificate for arbitrary source-family
completeness is claimed.

## Boundaries and lower bounds

* The binomial number is sharp for an explicit witness catalog: every r-subset
  H of an (r+f)-element universe is uniquely selected by failing its complement.
  It is not a lower bound on arbitrary symbolic representations.
* The example is realized by an MDS scalar code whose target is recoverable
  from any r helpers and no fewer, over a sufficiently large field.
* Arbitrary price decreases destroy any size bound depending only on r and f:
  with r=f=1 and all n singleton witnesses at baseline cost one, discounting
  singleton h to zero makes it the unique optimum. All n witnesses are needed.
* Multiple units of load per resource, coefficient-sensitive perturbations,
  probabilistic witness counting, quantum degeneracy, and unrestricted temporal
  observations are not covered by the binary-support theorem.
* Sparse duality is a verifiable sufficient condition. There is no claim that
  every instance has a sparse optimal price certificate.

## Related work and novelty scope

Fomin, Lokshtanov, Panolan and Saurabh, *Efficient Computation of Representative Sets with
Applications in Parameterized and Exact Algorithms*, arXiv:1304.4626, supplies
the classical weighted representative-family construction. Fomin, Lokshtanov,
Panolan and Saurabh, *Representative Sets of Product Families*, arXiv:1402.3909,
already studies efficient representative-family composition. Representative
families for multiple matroid constraints are also established (van Bevern,
Tsidulko and Zschoche, Discrete Applied Mathematics 298, 2021).

Bentert, Fomin, Golovach and Morelle, *Fault-Tolerant Matroid Bases*,
arXiv:2506.22010, studies minimum-size resilient spanning sets, a different
optimization problem from retaining exact optimal response catalogs.
Choudhary, Kumar and Saggi, *Sensitivity Oracles for Matroid Packing, Matroid
Covering, and Matching Problems with Applications*, arXiv:2609.01283, develops
randomized algebraic sensitivity oracles, including weighted variants and a
prescribed susceptible-set model.

The proposed ergodis-specific research contribution is the combination of
self-localizing monotone-event completeness, sparse-dual certification of
implicit master problems (including conserved-grading price shifts), graded
functional-label composition, and core-local cost-distribution bounds. This
package is proved here but its publication-level novelty is not established.
The prototype measurements are correctness tests, not performance evidence.
