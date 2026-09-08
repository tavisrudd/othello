# C1128: remaining structural deductions

Date: 2026-09-08. Lane: `cubic-threefolds`.

## Verdict and boundary

The rational polynomial spectrum, additive-method ceiling, residual and product
stabilization bounds, diagonal-torsion bound, and spreading of fixed upper
bounds pass with the hypotheses specified below. These are deductions from
the previously audited inputs, not independent proofs of the manuscripts'
geometric foundations. The polynomial spectrum needs an explicit rational
coefficient model; merely replacing C by Q in the final sentence is inadequate.

Five external sources were read **partially**, zero at full text. Exact passages,
versions and cached-byte hashes are in `2026-09-08-c1128-structural-sources.json`.
There is no novelty or priority verdict here. The algorithmic source is a
positive attribution check, not a benchmark comparison. No manuscript, Lean,
mirror or executable parametrization was changed.

## 1. Rational coefficient model and spectrum

Fix a smooth projective complex variety Y. It need not be defined over Q.
Choose a homogeneous rational basis of H^ev(Y,Q), containing the unit and a
rational basis of divisor classes. Choose integral divisors whose pairings
separate the numerical curve lattice. Use the same numerical reduction,
effective monoid, ample filtration and graded completion as in the manuscript,
but put

\[
 R_{Y,\mathbf Q}^{\rm red}
 =\mathbf Q[[X_d,\sigma']]_{\rm gr}[\sigma^0],\qquad
 K_{Y,\mathbf Q}=\operatorname{Frac}(R_{Y,\mathbf Q}^{\rm red}).
\]

The notation includes the monoid relations X_d X_e=X_(d+e); it does not
introduce algebraically independent variables for all effective classes.
Numerical reduction aggregates classes as in the existing construction.
Bounded ample degree has finite numerical support. The nondivisor variables
are the remaining even coordinates; divisor exponentials are incorporated
into X_d. The connection is constructed over this rational model before
taking coefficientwise scalar extension into the complex completed model.
Do not assert an ordinary tensor-product identity for these completions.

Iritani §2.1 explicitly defines invariants with rational insertions by pairing
with a rational virtual fundamental class and records their values in Q.
The inverse Poincare matrix is rational, as are c1 and the degree grading.
String/divisor equations and factorial coefficients preserve rationality.
Thus the even quantum multiplication and connection matrices have coefficients
in the indicated rational model and its z-enhancement. This concerns the
cohomological coefficient field, not a model of the variety over Q.
[Iritani, §§2.1–2.3](https://arxiv.org/html/2307.13555v3).

The relevant derivations on the z-free coefficient field are

\[
 D_i(X_d)=(D_i\cdot d)X_d,\qquad
 \partial_{\sigma^j},\quad\partial_{\sigma^0}.
\]

Their common constants are Q. Here is the completed-ring argument with the
constant field exposed. If f/g is constant under the ordinary partials, it
is also constant under the corresponding coordinate Euler derivations.
Together with the divisor derivations these distinguish every full monomial
index (numerical curve class and bulk exponents). Formal simultaneous
rescaling gives f(e^t x)g(x)=f(x)g(e^t x). In bounded ample-plus-bulk pieces,
the finitely many distinct exponential characters are independent. For each
index a, comparison yields f_a g=g_a f after cancelling its monomial.
Choose an index with g_a nonzero. Then f/g=f_a/g_a belongs to Q. This is the
same argument as `lem:constant-residue-spectrum`, using its actual graded
support conditions, now with rational coefficients. Ordinary partials alone
on an unrestricted Novikov ring would not suffice.

Let L/K_(Y,Q) be a finite algebraic extension needed for the projectors and
the finite residue jet. All derivations extend uniquely in characteristic
zero. If alpha in L is killed by them and p(T) is its monic minimal
polynomial, then (partial p)(alpha)=0. Since partial p has smaller degree,
it is zero; every coefficient of p is a constant of K_(Y,Q), hence rational.
Therefore alpha is algebraic over Q. An algebraic extension can enlarge
constants from Q to a number field; it must not be said to keep them equal
to Q. For each eligible block the previously audited Lax equation gives

\[
 \delta^\sharp(E)\in\overline{\mathbf Q}.
\]

There is a particularly direct descent argument for the entire polynomial.
Work in an algebraic closure of K_(Y,Q). Its automorphisms over K_(Y,Q)
permute whole generic primary summands. Rank, nonzero square-zero leading
term and the canonical modification are intrinsic, so eligibility is
preserved. Both exclusion rules are defined over Q: delta=0 for I_lat,
or delta in {n^2:n in Z} for I_exp. Consequently

\[
 P_Y(T)=\prod_{E\text{ counted}}(T-\delta^\sharp(E))
 \in K_{Y,\mathbf Q}[T].
\]

Each coefficient is also killed by every derivation, so it lies in Q.
This avoids presupposing that individually selected blocks descend to Q.
It also proves the claimed Galois invariance of the multiset of algebraic
discriminants. Multiplicity matters: the polynomial is not squarefree in
general. The empty product is 1.

The complex comparison theorems need not themselves be re-proved over Q
for this deduction. The polynomial is intrinsically rational; the already
audited complex comparisons preserve the same numerical discriminants,
and hence give identities between rational polynomials:

\[
 P_{\operatorname{Bl}_Z Y}=P_Y P_Z^{c-1},\qquad
 P_{\mathbf P_Y(V)}=P_Y^{\operatorname{rk}V}.
\]

For each counted delta its minimal polynomial divides P_Y. Thus

\[
 [\mathbf Q(\delta):\mathbf Q]\leq\deg P_Y
 =I_\bullet(Y)\leq\tfrac12\dim H^{\rm ev}(Y,\mathbf Q).
\]

In particular, one counted block has rational discriminant. This is a finite
encoding of the full counted multiset, not a claim that arbitrary quantum
cohomology input is algorithmically obtainable. A finite residue jet does
not by itself give a uniform finite bound on the Novikov/bulk coefficients
needed to discover every generic block.

**Placement:** a short arithmetic proposition after the spectrum construction,
with the rational-model proof in supporting material if it interrupts the
main argument. It is not needed for either stabilization headline.

## 2. A ceiling requiring only the blowup formula

Let J take values in an abelian group and satisfy, for smooth projective
centers of codimension c,

\[
 J(\operatorname{Bl}_Z Y)=J(Y)+(c-1)J(Z).
\]

Suppose it is birationally invariant on smooth projective (n+2)-folds.
Blow up Y=X times P^2 at Z=X times {p}, where X is any smooth projective
n-fold. The center has codimension two. Birational invariance gives
J(Y)=J(Y)+J(X); group cancellation gives J(X)=0. No torsion-freeness,
projective-bundle formula or nonzero projective-space value is needed.

This prevents detecting an n-fold with this global blowup-additive architecture
while demanding birational invariance in dimension n+2. It does not rule out
nonadditive, marked, embedding-dependent or other comparison mechanisms.
It is a structural explanation of the limitation, not a lower bound for any
new example. **Placement:** one short proposition or remark near the existing
dimension-five failure, replacing redundant discussion.

## 3. Stabilization bounds

Throughout this section varieties are geometrically integral over k and
ell denotes the least number of independent rational variables giving a
purely transcendental function field over k. All displayed levels used as
numbers are finite; rationality persists when more variables are adjoined.

### Residual factors

If Q is k-birational to Y times R, dim R=d, ell(R)=a and ell(Q)=b, put
m=max(a,b). Then Q times A^m is rational, while R times A^m is birational
to A^(d+m). Consequently Y times A^(d+m) is rational, proving

\[
 \ell(Y)\leq d+\max(a,b).
\]

This allows certified stably rational residual tori and quotients. It is an
upper bound from the stated inputs, not an optimality theorem or an algorithm
for determining a or b. **Placement:** a single quantitative remark in a
future general quotient treatment; defer to the C963/C965/C966 work program
instead of expanding the present surface proof.

### Products and powers

Let dim X=n_X, dim Y=n_Y and s_X=ell(X), s_Y=ell(Y). With
m=max(s_X,s_Y-n_X), rationalize X using the m added variables. This leaves
Y with n_X+m rational variables, at least s_Y, and therefore rationalizes
the product. Interchanging X and Y proves

\[
 \ell(X\times Y)\leq
 \min\{\max(s_X,s_Y-n_X),\max(s_Y,s_X-n_Y)\}.
\]

In particular ell(X^r)<=ell(X) for every positive integer r, by induction.
This does not assert equality or furnish an obstruction to other constructions
of higher finite levels. **Placement:** research note supporting the search
strategy, not another main-text subsection.

## 4. Slice indices bound diagonal torsion

Let Qbar be a smooth proper geometrically integral model in the sharpness
paper's `cor:finite-index-chow`, and let D=gcd(d_1,...,d_s). That corollary
already supplies a k-point q and annihilation of A0(Qbar_F) by D for every
extension F/k. The point follows from a nonempty open parametrization domain
over the infinite characteristic-zero ground field; no extra rational-point
assumption is being introduced silently.

Take F=k(Qbar), with generic point eta. The degree-zero class eta-q_F obeys
D(eta-q_F)=0. The direct-limit description of CH0(Qbar_F), followed by Chow
localization, yields a dense open U in Qbar where
D Delta-D(Qbar times q) restricts to zero. Thus in CH_n(Qbar times Qbar),

\[
 D[\Delta_{\overline Q}]=D[\overline Q\times q]+Z,
 \qquad\operatorname{supp}Z\subset D'\times\overline Q,
 \quad D'=\overline Q\setminus U\ne\overline Q.
\]

This generic-point/localization mechanism is already explicit in Voisin's
introduction for multiplier one. The argument is unchanged after multiplying
by D. Chatzistamatiou–Levine Definition 1.1(4) and Lemma 1.3(2) identify the
result with torsion order dividing D; their convention interchanges the two
factors, so transpose the displayed identity when citing them. The order need
not equal D, just as parametrization degree need not equal lattice index.
[Voisin, introduction](https://arxiv.org/html/1407.7261v2);
[Chatzistamatiou–Levine, Definition 1.1 and Lemma 1.3](https://arxiv.org/pdf/1605.01913v3).

Conversely, any certified torsion-order divisor must divide every admissible
slice index. D=1 is precisely the already stated universal-CH0 consequence.
The refinement adds useful language and an obstruction to candidate indices;
it does not give a new example. **Placement:** one paragraph after the existing
zero-cycle corollary, with this proof in a note if space is tight.

## 5. Spreading fixed upper bounds

For a fixed smooth cubic over Q with a Q-rationalization of X times P^2,
choose rational formulas for the map and its inverse and nonempty open sets
on which they are inverse isomorphisms. The equations, coefficients, inverse
identities and nonvanishing conditions use finite data. Clearing denominators
and excluding finitely many primes preserves these identities, nonempty dense
domains, and smooth geometrically integral fibers. Thus the reductions are
rational after two variables at every remaining prime. This is a direct
finite-presentation deduction, not a spread of quantum cohomology.

An existence theorem over Q suffices for the existential statement that some
integer N works. It does not compute N. An effective list of excluded primes
requires the actual forward/inverse maps and their opens, still owned by C958.
No claim of exact level two, one-variable irrationality, or arbitrary
characteristic lower bounds follows. **Placement:** roadmap only, until an
explicit arithmetic application earns the space.

## 6. Source normalization and computational directions

Cai v1, page 4, displays K=2U_(6,15) but gives nonzero eigenvalues without
the outer factor two. The earlier Fano bundle establishes
det(T-U_(6,15))=T^2(T^2-27q); scaling the 4-by-4 matrix gives
det(T-K)=T^2(T^2-108q). The correct values are therefore
plus/minus 6 sqrt(3) q^(1/2). The following Jordan matrix on the same source
page also retains its outer factor two. The supplied external-typo observation
is confirmed; it is not a manuscript error. Cite the displayed matrix and
keep any explanatory normalization note brief.
[Cai, §3, page 4](https://arxiv.org/pdf/2608.01577v1).

The proposed benchmark source is now identified precisely: Duff,
Korotynskiy, Pajdla and Regan, *Using monodromy to recover symmetries of
polynomial systems*, arXiv:2312.12685v1. Section 5.2 builds a matrix of shifted
exponent vectors and uses Smith normal form to detect continuous and discrete
scalings; §2 explicitly attributes earlier integer-linear-algebra detection.
Its stated examples include camera geometry and a four-bar mechanism. This
supports its relevance as a comparison source, not a measured advantage for
the present proposed implementation. No software or experiment was replayed.
[Duff et al., §§1–2 and 5.2](https://arxiv.org/html/2312.12685v1).

Certified symmetry reduction remains a research program: compare complete
forward/inverse maps, exceptional loci, branch degrees, expression size,
elimination cost, checking cost and conditioning on the same tasks. C958 owns
the missing concrete maps; C963/C965/C966 own the algorithmic continuation.
The residue-library proposal is likewise research infrastructure. A quantum
period sequence is not automatically a verified full connection and lattice.
No commercial, cryptographic or quantum-computing conclusion has been proved
by these mathematical results. Keep such positioning outside both papers.

## 7. Explicit ej+tt closeout

After the preceding deductions passed, the closeout asked whether their
targets or hypotheses could be simplified without adding a new research task.

**ej:** The polynomial is a lossless encoding of the finite spectrum, since
factorization over Qbar recovers the roots with multiplicities. For virtual
classes, pass from monic polynomials to their multiplicative group completion,
the group of ratios of monic Q-polynomials. The existing Bittner argument then
gives a group homomorphism from K0(Var_C)/(L-1) to that subgroup of Q(T)^times.
Addition of variety classes becomes multiplication of rational functions;
negatives become reciprocals. This is not a ring homomorphism and has not
become a stable-birational invariant. It can replace a cumbersome target
description rather than create another independent construction. This is an
inference from the already audited additive extension, not a new attribution
to Bittner or a reread of Bittner's theorem.

**tt:** What assumptions actually carry the conclusions? The ceiling needs
only one codimension-two blowup and group cancellation. The diagonal-torsion
claim is repackaging an existing universal statement at its function field.
The arithmetic model does not need Y/Q or Q-defined comparison gauges. None
of these refinements supplies the missing higher-stabilization obstruction.
These clarifications are incorporated above; no extra computational search
would test the remaining geometric foundations.

## Mystery ledger

| Feature | Disposition and exact remaining gap |
|---|---|
| Algebraic residue constants despite a complex variety | Settled here from rational GW coefficients, completed-ring constants and finite algebraic jets; independent of a model Y/Q. |
| Individual blocks need not descend | Settled by permutation descent of the entire polynomial, retaining multiplicity. |
| Finite target versus finite algorithm | Separated: the polynomial is finite, but certified generic connection input and a terminating input-recovery procedure are not supplied. Residue-library gate. |
| Failure after two stabilizations | Architectural ceiling settled; existence of cubic levels above two remains an open research direction, not an inference from the ceiling. |
| Lattice indices versus diagonal torsion | Divisibility settled, equality neither claimed nor implied. Explicit examples with informative indices remain a construction gate. |
| Good-reduction primes | Existence of a finite exceptional set settled; computing it remains behind C958's complete maps and open conditions. |

## Validation and provenance

All new mathematical arguments in this note are symbolic proofs written above;
there is no new finite experiment that purports to certify them. The Cai
normalization uses the committed universal-matrix identity in the Fano bundle,
not an untracked calculation. Earlier independent scripts and their exact
replays remain the computational evidence for the Fano, torus and family
claims; this closeout does not reclassify them as geometric proof verification.
The adjacent SHA-256 manifest records this note, source metadata, final
dispositions and the inherited report/checker manifests. Structural proof
review here is by the same auditor, without an independent specialist or
kernel check. The residual review boundary is explicit rather than hidden
behind a numerical test.

Closeout validation rehashed all 27 file entries in the four inherited
mathematical bundles, all five newly recorded primary-source PDFs and the
three current manuscript input snapshots. They agree with their manifests.
The C1128 live-row count is zero and archive-row count is one. Scoped diff
whitespace checks pass. Unchanged mathematical suites were not rerun.
