# C925 -- non-\(m=2\) categorical dividends and universal sufficient shadows

**Lane:** `cubic-threefolds`

**Status:** three formal consequences promoted; C925 remains active

## Verdict

The categorical framing gives more than a language for the cubic
one-stabilization proof or a possible route to \(m=2\).  It produces a
universal classification of center-null markers, a canonical minimal shadow
for any chosen family of invariants, and an exact joint-descent corollary for
parallel sparse shadows.  These three statements are now Theorems
23.1--23.3 of the modular packet.

The remaining dividends are also useful: minimal hypothesis slicing,
holonomy classification, uniqueness of generic rank, a one-covector leakage
obstruction, exposed-leading-defect separation, and boundary-mutation
invariance.  Their geometric use remains limited by the provider maps they
explicitly name.

No manuscript or Lean source was edited.

## 1. Universal center-null representability

Let \(\mathcal L\) be a lawful commutative-monoid ledger and let \(E_d\)
consist of the actual indexed center classes \(e(C,\chi)\) with
\(\dim C\le d\).  The quotient

\[
q_d:\mathcal L\longrightarrow\mathcal L_d
\]

is the coequalizer which sends every element of \(E_d\) to zero.  Theorem
23.1 proves, naturally in every commutative monoid \(A\),

\[
\operatorname{Hom}_{\mathsf{CMon}}(\mathcal L_d,A)
\cong
\{W:\mathcal L\to A:W(E_d)=0\}.
\]

This promotes the categorified localization of Section 7.7 in two ways.

1. It explicitly retains the specialization label \(\chi\), so it cannot
   replace specialized center vanishing by intrinsic center vanishing.
2. It proves completeness:
   \[
   q_d(x)=q_d(y)
   \Longleftrightarrow
   W(x)=W(y)
   \text{ for every center-null marker }W
   \text{ into every target monoid}.
   \]

The reverse implication uses the universal quotient itself as the target
marker.  Thus the theorem is not a separation assumption.

Nested dimension cutoffs are canonical and idempotent:

\[
d\le e
\quad\Longrightarrow\quad
\mathcal L\to\mathcal L_d\to\mathcal L_e,
\qquad
(\mathcal L_d)_e\cong\mathcal L_e.
\]

The second quotient uses the images of the \(e\)-level center generators in
\(\mathcal L_d\).

When the specialized blowup relation is present in the fixed ledger for
every actual step of a weak factorization and for every resulting \(\chi_j\),
the class in \(\mathcal L_{n-2}\) is birationally invariant for smooth
projective \(n\)-folds, \(n\ge2\).  Every additive center-null invariant
constructed by this compiler is therefore a coordinate of one universal
class.  Geometric existence of a weak factorization does not insert an
omitted relation into the ledger.

For abelian-group-valued markers, the universal difference lies in the group
completion \(G(\mathcal L_{n-2})\).  Vanishing of that difference is
equivalent to vanishing under every group-valued center-null marker.  At the
monoid level one must retain the ordered pair of quotient classes: group
completion can erase a noncancellative distinction which the universal
monoid marker still sees.

### Exact limitation

The theorem classifies consumers of a fixed lawful ledger.  It does not prove
the comparison relations used to construct that ledger, nor does it place
two theories on a common ledger when their provider contracts differ.

## 2. Canonical minimal sufficient shadow

For a small lawful marker family

\[
M_i:\mathcal L\to A_i,
\qquad
M_I=(M_i):\mathcal L\to\prod_iA_i,
\]

define

\[
x\equiv_Iy
\Longleftrightarrow
M_i(x)=M_i(y)\quad\forall i.
\]

Theorem 23.2 identifies

\[
\mathcal S_I:=\mathcal L/{\equiv_I}
\cong\operatorname{im}(M_I).
\]

If \(U:\mathcal L\twoheadrightarrow S\) is any operation-stable shadow
through which every \(M_i\) factors, there is a unique map

\[
S\longrightarrow\mathcal S_I
\]

compatible with the maps out of \(\mathcal L\).  Thus \(\mathcal S_I\) is
the coarsest image-complete monoidal shadow sufficient for the requested
information.

This gives a canonical software-style semantics for “choose what to retain”:

```text
rich ledger -> user-selected sufficient shadow -> minimal marker image
```

The middle object may retain implementation conveniences or future
information.  The terminal object retains exactly the distinctions observed
by the selected marker family and nothing else.

“Operation-stable” here means stable under the commutative-monoid operation
and every relation already imposed in \(\mathcal L\).  Additional operations
require taking the kernel congruence in their own algebraic theory; the bare
monoid quotient does not automatically preserve them.

If the markers are center-null, this construction occurs after universal
center localization:

\[
\mathcal L\to\mathcal L_d\to\mathcal S_I
\hookrightarrow\prod_iA_i.
\]

This is the correct sense in which the audited Guéré, BFGMP, KKPYY, atomic,
and framed packages form an information order.  A morphism between two of
them exists only after their comparison contracts have been matched.

There is also an exact lattice statement.  Sufficient quotient shadows
correspond to congruences contained in the joint marker kernel.  Adding a
marker intersects kernel congruences, so the new minimal shadow is the
observed image in the product of the previous minimal shadows.  It is the
canonical common refinement and need not be the full product.

## 3. Joint-shadow product descent

For parallel shadows \(U_j:\mathcal L\to S_j\), put

\[
U_J=(U_j):\mathcal L\to\prod_jS_j.
\]

Theorem 23.3 proves that a marker \(M\) descends uniquely to the observed
image of \(U_J\) exactly when

\[
U_j(x)=U_j(y)\ \forall j
\quad\Longrightarrow\quad
M(x)=M(y).
\]

Equivalently,

\[
\bigcap_j\ker_{\mathrm{cong}}U_j
\subseteq\ker_{\mathrm{cong}}M.
\]

Neither an individual shadow nor their product needs to reconstruct the rich
object.

### Exact hostile example

Let

\[
\mathcal L=(\mathbf Z/2)^3,
\quad
U_1(x,y,z)=x,
\quad
U_2(x,y,z)=y,
\quad
M(x,y,z)=x+y.
\]

The marker descends through neither projection separately, but descends
through their product.  The product still forgets \(z\), so the example
separates marker reconstruction from object reconstruction.

The groupoid version uses a descent isomorphism on the Čech groupoid of the
joint projection and the ordinary cocycle on the triple fibre product.  It
yields an actual descended object only under effective descent for the
target.  This is the exact datum to test when combining grading, support,
monodromy, point-row, and path-provenance shadows; the cocycle alone is not an
effectivity theorem.

Theorem 23.3 is the product-shadow specialization of Theorem 20.1, with
additivity proving that the descended function is monoidal.  Its value is the
joint-fibre criterion and countermodel, not logical independence from the
earlier descent theorem.

## 4. Hypothesis slicing

A compiled proof consumes only the subcategory generated by its actual
comparison arrows and coherence cells.  It therefore needs marker laws only
on that subcategory.  Module 22 demonstrates the result concretely:

- 5.7R is quantified only over comparison-generated reconstruction tails;
- 5.7T is consumed only for residual specialized surface centers;
- the conditional projective-bundle operation is absent from the \(m=1\)
  proof because its endpoint uses the unconditional external product.

This is a general method for reducing a global analytic hypothesis to the
smallest proof-indexed provider record.

## 5. Holonomy classifies reconstruction from path state

Theorem 21.8 proves that a compatible lift of a torsor-valued local system
exists exactly when every loop has trivial holonomy.  A tree transports any
chosen initial lift uniquely; a cycle introduces a holonomy condition which
may be obstructed.

In cohomological language the obstruction is a nonabelian
\(H^1\)-class of the comparison path groupoid.  Reader or indexed State can
carry a chosen lift, but cannot turn it into a canonical endpoint without
trivial holonomy or a bridge selecting the endpoint.

## 6. Generic rank is the unique additive boundary-blind shadow

For an integral regular noetherian scheme \(Y\), Theorem 21.12 proves

\[
K_0(Y)/K_0^{\mathrm{proper\ support}}(Y)\cong\mathbf Z
\]

by generic rank.  Hence every additive functional which kills all
proper-supported perfect complexes is a scalar multiple of rank.

This is both a theorem and a no-go principle: every additive boundary-blind
\(K_0\) invariant factors uniquely through rank, so none is independent of
rank.  New information must retain some support layer, extension class, or
nonadditive structure.

## 7. The whole quotient defect is one leakage covector

For exact rows

\[
0\to N_\pm\to V_\pm\xrightarrow{r_\pm}K\to0
\]

and an invertible comparison \(\Phi:V_-\xrightarrow{\sim} V_+\), Proposition
21.13 defines

\[
\delta_\Phi=r_+\Phi|_{N_-}.
\]

It proves

\[
\delta_\Phi=0
\Longleftrightarrow
\Phi(N_-)=N_+
\Longleftrightarrow
r_+\Phi=c_\Phi r_-,\qquad c_\Phi\in K^\times.
\]

Zero-leakage comparisons form a subgroupoid.  Thus a full-matrix naturality
problem reduces to one canonical covector, independently of any
stabilization endpoint.

## 8. Exposed leading defects cannot be repaired from below

For a finite group-algebra support over a domain and an additive weight,
Theorem 21.5 makes initial form a multiplicative filtered shadow on
\(K[\Gamma]\).  A nonzero exposed leading leakage cannot be cancelled by
lower-weight terms.  Calling this a categorical filtered-monoidal
specialization additionally requires a specified category and compatible
action; no such functor is inferred from the scalar theorem.

This is immediately relevant to the framed \(m=1\) hypotheses: it suggests
testing only the leading primitive-sixth defect of reconstruction or tagging,
rather than proving equality of the whole formal connection.  That
application still requires an identification of the scalar channel with the
marker defect.

## 9. Boundary-supported mutations are invisible after common-open localization

In algebraic recollement for \(j:U\hookrightarrow Y\), a morphism whose cone
is supported on the boundary \(Y\setminus U\) becomes an isomorphism after
restriction to the fixed common open.  Every marker factoring through that
quotient is therefore unchanged by boundary-supported mutations and their
composites.  Unlike restriction to the generic point, restriction to a fixed
\(U\) does not kill a proper-supported object whose support meets \(U\).

The formal result applies to ordinary flop windows and related mutations.
An analytic QDM conclusion still needs the Gamma/common-open naturality
bridge; recollement alone does not provide it.

## Validation

The finite Python law model works exhaustively over \((\mathbf Z/2)^3\) and
adds checks for:

1. factorization of center-null weights through the universal quotient and
   compatibility of nested cutoffs;
2. completeness of the universal quotient for all center-null weights in the
   finite model;
3. the terminal factor from a richer sufficient shadow to the joint marker
   image; and
4. joint marker descent when neither individual shadow suffices and the rich
   object is still not reconstructed.

The model checks only the categorical algebra.  External comparison
theorems remain inputs.

## EJ / TT closeout

### Settled cheaply

- The universal center quotient is not merely initial notation: it represents
  and jointly detects every center-null marker equality.
- “Minimal retained information” has a canonical answer relative to a marker
  family: the image of the joint marker.
- Parallel projections should be fused by taking their observed product
  image, not by assuming that one projection is privileged or that the full
  object must be reconstructed.
- Sufficient quotient shadows form a congruence lattice; adding observations
  is exactly intersection of kernel congruences.
- Specialization labels belong in the universal center generator; erasing
  them would repeat the intrinsic-versus-specialized center error.

### Highest-value next extraction

Build the actual information-order diagram among the five audited packages
only on their largest common lawful comparison subcategory.  This gives a
finite family of comparison questions, but an individual kernel-congruence
inclusion need not admit a finite verification unless the common ledger is
finitely presented.  Record where an inclusion is proved and where a
provider mismatch prevents even forming the morphism.

## Mystery ledger

| mystery | status | exact gate |
|---|---|---|
| Is there one universal recipient for center-null markers? | **settled** | Theorem 23.1 and the coequalizer universal property |
| What is the least operation-stable shadow retaining chosen markers? | **settled** | Theorem 23.2: the joint marker image |
| Must one projection reconstruct the marker? | **settled: no** | Theorem 23.3 and the \((\mathbf Z/2)^3\) countermodel |
| Must the joint projection reconstruct the rich object? | **settled: no** | the unused \(z\)-coordinate in the same countermodel |
| Do all five audited packages live on one common ledger? | **open** | intersect their provider contracts; generic-bulk and framed-small theories differ |
| Can a numerical marker detect every nonzero group-completed universal class? | **open in a fixed restricted target class** | unrestricted monoid targets are complete by Theorem 23.1; fixed targets such as \(\mathbf N\) need residual finiteness/separation |
| Can leading-defect separation remove 5.7R or residual 5.7T? | **open** | identify and compute the relevant primitive-sixth scalar leakage channel |

## Boundary

Theorems 23.1--23.3 are formal theorems of the modular compiler.  They do not
claim literature novelty, prove a new QDM comparison, remove the framed
hypotheses, or solve a new birational endpoint by themselves.  C925 remains
active.
