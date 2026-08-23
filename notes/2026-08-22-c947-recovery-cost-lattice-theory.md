# C947 — Recovery-cost lattice laws and three theoretical lenses

**Lane**: complete-ports

**Status**: COMPLETE; EJ/TT AND LITERATURE BOUNDARY PASSED

## Scope

This is a math-only successor to C946. It does not authorize manuscript,
bibliography, README, or formal-boundary edits.

## Executive answer

The best cheap successor question was:

> Is \(A\mapsto\rho_{P,A}(C)\) submodular, or at least polymatroidal, on the
> lattice of demand subspaces?

No. The cost is neither submodular nor supermodular, already for small binary
codes. Its exact standard form is instead a finite-field minimum
joint-row-support problem:

\[
 \rho_{P,A}(C)
 =\min\{|\operatorname{rowsupp}X|:G_JX=-T_A\},
\]

where \(G_J\) is the helper-column matrix and the columns of \(T_A\) form a
basis of \(G_PA\). For a one-dimensional demand this is minimum-weight syndrome
solving; for a higher-dimensional demand it is the multiple-right-hand-side,
jointly sparse version.

The higher categorical result is also exact. For each helper set \(H\), the
assignment of lifts to all presented demands is the representable functor

\[
 \operatorname{Lift}_H(-)
 =
 \operatorname{Hom}_{\mathbf{Vect}_q/\mathbb F_q^P}(-,R_H),
\]

represented by the restricted-dual map
\(R_H:D_C(P,H)\to\mathbb F_q^P\). Yoneda says that the complete unfiltered
coefficient-lift functor determines \(R_H\) up to unique isomorphism over the
target space. C946's transfer theorem is naturally a bounded,
support-filtered version of this statement.

The number-theoretic direction is credible but belongs to a sequel: lift an
integer column configuration and replace helper spans by helper lattices.
Smith normal form then records characteristic-by-characteristic recovery
obstructions, while arithmetic matroids or matroids over rings organize the
ambient data.

## 1. Exact optimization form

Let \(G\in\mathbb F_q^{k\times E}\) generate \(C\), write \(J=E\setminus P\),
and let \(A\leq\mathbb F_q^P\). Choose a basis matrix
\(B_A\in\mathbb F_q^{P\times a}\) for \(A\), and put

\[
 T_A=G_PB_A.
\]

An equation system for this basis has a helper-coefficient matrix
\(X\in\mathbb F_q^{J\times a}\). Its columns are dual words precisely when
\[
 G_JX=-T_A.
\]
Its union of helpers is exactly the row support of \(X\).

### Proposition 1 — joint-sparsity formula

\[
 \boxed{\rho_{P,A}(C)
 =\min_{G_JX=-T_A}|\operatorname{rowsupp}X|}
 =\min\{|H|:G_PA\subseteq\operatorname{span}(G_H)\}.
\]

The value is basis-independent: changing the basis right-multiplies \(T_A\)
and \(X\) by an invertible matrix and preserves row support.

### Corollary 1.1 — scalar cost factors through the message-space demand

If \(G_PA=G_PA'\), then
\[
 \rho_{P,A}(C)=\rho_{P,A'}(C).
\]
In particular, every demand subspace contained in \(\ker G_P\) has cost zero:
its equations are supported entirely on \(P\). Thus the scalar cost remembers
only the image demand \(U_A=G_PA\), while the full normalized lift functor can
still remember the coefficient presentation and its helper-only gauge fibers.

With \(\rho(0)=0\), the universal laws are
\[
 A'\leq A\Longrightarrow\rho(A')\leq\rho(A)
\]
and
\[
 \max\{\rho(A),\rho(B)\}
 \leq\rho(A+B)
 \leq\rho(A)+\rho(B).
\]
Also \(\rho(A)\geq\dim(G_PA)\), hence
\(\rho(A)\geq\dim A\) when \(G_P|_A\) is injective.

## 2. Failure of submodularity

Work over \(\mathbb F_2\). Let \(C\) have generator columns
\[
 G=(e_1,e_2,e_3\mid e_2,e_1+e_2,e_3,e_1+e_3),
\]
with the first three coordinates targeted, so \(G_P=I_3\). Set
\[
 A=\langle e_1,e_2\rangle,\qquad
 B=\langle e_1,e_3\rangle.
\]
Then
\[
 \rho(A)=2,\quad \rho(B)=2,\quad
 \rho(A+B)=3,\quad \rho(A\cap B)=2.
\]

The first helper pair spans \(A\), the second spans \(B\), and dimension gives
the matching lower bounds. Three helpers span \(A+B=\mathbb F_2^3\), while
fewer cannot. No helper column is \(e_1\), but either paired sum realizes it.
Therefore
\[
 \rho(A+B)+\rho(A\cap B)=3+2>2+2=\rho(A)+\rho(B).
\]
Thus \(\rho\) is not submodular and is not a polymatroid rank. The mechanism
is cancellation: the common line of two cheaply spanned planes need not
itself have a cheap helper.

## 3. Failure of supermodularity

Over \(\mathbb F_2\), take
\[
 G=(e_1,e_2\mid e_1+e_2,e_2),
\]
target the first two coordinates, and set
\(A=\langle e_1\rangle\), \(B=\langle e_2\rangle\). Then
\[
 \rho(A)=2,\quad \rho(B)=1,\quad
 \rho(A+B)=2,\quad \rho(A\cap B)=0.
\]
Consequently
\[
 \rho(A+B)+\rho(A\cap B)=2<3=\rho(A)+\rho(B).
\]
The cost is therefore monotone and subadditive, but has neither lattice
curvature sign in general.

## 4. Third lens: finite-field joint sparsity

The identity \(G_JX=-T_A\) with minimum nonzero-row count is precisely the
noiseless multiple-measurement-vector or joint-sparse inverse problem over a
finite field. Each row is one helper coordinate and is charged once even when
it participates in several equations. Thus union-of-helpers cost is exactly
joint row sparsity, not the sum of individual equation weights.

For \(\dim A=1\), the problem is
\[
 \min\{\operatorname{wt}(x):G_Jx=-t\},
\]
the coset-weight or syndrome-decoding problem.

### Proposition 2 — exact computation is NP-complete

Over \(\mathbb F_2\), deciding whether
\(\rho_{\{x\},\mathbb F_2}(C)\leq r\) is NP-complete. Membership in NP is
immediate. For hardness, take an instance \(Mx=b\) of coset weight and form
\[
 G=(b\mid M),
\]
deleting dependent rows if necessary. A normalized dual word \((1,x)\) with
at most \(r\) helpers exists exactly when \(Mx=b\) has a solution of weight at
most \(r\). The joint-demand decision problem is NP-complete as well because
it contains this one-dimensional restriction.

This viewpoint supplies:

1. the correct expectation that exact inventories are exponential in general;
2. native algorithms from syndrome decoding, meet-in-the-middle search,
   information-set decoding, integer programming, and branch-and-bound;
3. the rank lower bound \(\rho(A)\geq\dim(G_PA)\);
4. a structural explanation for failed submodularity: sparse representations
   use cancellation and change support discontinuously under intersection.

The best next theorem here is parameterized rather than classical: classify
fixed \((r,\dim A,q)\), exploit structured-code instances, and compare
joint-syndrome algorithms with direct dual-word enumeration. Real or complex
group-lasso guarantees do not transfer automatically to finite fields.

## 5. Category theory: the lift object is representable

Fix \(P,H\) and write
\[
 D_H=C^\perp\cap\mathbb F_q^{P\cup H},\qquad
 R_H:D_H\longrightarrow\mathbb F_q^P,\quad w\longmapsto w|_P.
\]
Let \(\mathcal V_P=\mathbf{Vect}_q/\mathbb F_q^P\). Its objects are presented
demands \(\beta:Q\to\mathbb F_q^P\). A morphism \(\beta\to R_H\) is exactly a
map \(s:Q\to D_H\) with \(R_Hs=\beta\), hence a normalized
\(\beta\)-equation system on \(H\).

### Proposition 3 — Yoneda form of all recovery lifts

\[
 \boxed{\operatorname{Lift}_H(\beta)
 =\operatorname{Hom}_{\mathcal V_P}(\beta,R_H).}
\]

The complete lift assignment is the representable presheaf \(y(R_H)\). By
Yoneda, it determines \(R_H\) up to unique isomorphism in the slice category.

This resolves an apparent tension in C946:

- the minimum cost of \(\beta\) depends only on \(\operatorname{im}\beta\);
- the full lift functor does not collapse to image data, because
  \(\ker\beta\) detects helper-only gauge directions through
  \(\operatorname{Hom}(\ker\beta,\ker R_H)\).

Arbitrary presentations do not produce a higher scalar obstruction, but they
are the categorical completion of the coefficient-aware object.

Classical recovery notions are existence shadows:

- \(\beta\) is recoverable from \(H\) iff
  \(\operatorname{Lift}_H(\beta)\neq\varnothing\);
- a demand subspace is recoverable iff its inclusion factors through \(R_H\);
- simultaneous recovery of \(P\) occurs iff
  \(\operatorname{id}_{\mathbb F_q^P}\) lifts through \(R_H\), equivalently
  iff \(R_H\) is surjective, hence split over a field;
- ordinary one-coordinate recovery is the singleton identity demand.

The subspace version is contravariant in \(A\), while enlarging \(H\) is
covariant. The local object is a two-variable diagram on
\[
 \operatorname{Sub}(\mathbb F_q^P)^{\mathrm{op}}
 \times 2^{E\setminus P}.
\]
A nonempty value is an affine torsor under
\(\operatorname{Hom}(A,\ker R_H)\); an empty value records failed recovery.
Helper cardinality supplies the extra filtration.

Under its stated confinement hypothesis, C946's uniform theorem is naturally
a natural isomorphism between the radius-\(r\) truncations of the inner and
concatenated diagrams. This subsumes all individual demands and restriction
maps, but does not strengthen the numerical threshold. No gluing axiom has
been proved, so “representable lift presheaf” is exact while “recovery sheaf”
is not justified.

## 6. Number theory: arithmetic recovery profiles

A genuine number-theoretic upgrade starts with an integral or number-field
representation. Let an integer matrix \(\widetilde G\) lift the target and
helper columns, and put
\[
 L_H=\widetilde G_H\mathbb Z^H\leq\mathbb Z^k.
\]
For an integral target vector \(t\), recovery modulo a prime \(p\) is
equivalent to
\[
 t\in L_H+p\mathbb Z^k.
\]
Equivalently, for \(Q_H=\mathbb Z^k/L_H\),
\[
 [t]\in pQ_H.
\]
For a demand lattice \(U\), require
\(U\subseteq L_H+p\mathbb Z^k\). Smith normal form of
\(\widetilde G_H\), together with the target classes, makes this obstruction
explicit prime by prime. If \(L_H\) has full rank, only primes dividing the
relevant invariant factors can obstruct modular recovery. If the target has a
nonzero class in the free quotient, recovery can occur for only finitely many
primes, subject also to the torsion coordinates.

For \(N=\prod p_i^{e_i}\), the Chinese remainder theorem decomposes both
solvability and the full coefficient-lift fibers prime-power by prime-power.

Established boundaries:

- arithmetic matroids already attach multiplicity and index data to lists in
  finitely generated abelian groups;
- matroids over rings already retain module structure and specialize over
  \(\mathbb Z\) and valuation rings;
- Smith normal form and CRT already give the primewise solvability statements.

The potentially new object is a support-filtered representable lift functor
over modules, together with concatenation confinement that tracks torsion and
non-splitting. This does not follow formally from the field proof: submodules
need not behave like vector subspaces, surjections split only under
projectivity hypotheses, and ring duality needs care.

The cheapest arithmetic successor is computational:

> For one integral represented seed, compute the Smith data of every bounded
> helper lattice and the target residue classes. Which primes change the
> recovery inventory or its coefficient fibers?

That would make characteristic-specific examples into an arithmetic phase
diagram before attempting a general ring-valued transfer theorem.

## 7. Priority order

1. Record the joint-row-support formula and the two lattice counterexamples.
2. Develop parameterized and exact algorithms for joint recovery cost.
3. Use the representable slice-category statement as conceptual compression.
4. Experiment with arithmetic recovery profiles of integral seeds.
5. Defer sheaf language, a general ring transfer theorem, and unsupported
   polymatroid relaxations.

## 8. Literature boundary

Primary references checked:

- M. D'Adderio and L. Moci, *Arithmetic matroids, the Tutte polynomial and
  toric arrangements*, arXiv:1105.3220. Read: abstract, introduction, and
  represented multiplicity definition. It does not state the bounded
  recovery-lift construction. Cached SHA-256:
  ac510581a6e41e48c254a2c6cdf216c0c8d74768348534c11f3ddabe0e81504b.
- A. Fink and L. Moci, *Matroids over a ring*, arXiv:1209.6571. Read: abstract
  and the introduction discussion of information lost by arithmetic
  multiplicities. It does not provide recovery confinement. Cached SHA-256:
  fff1bf1a3ebbbf197d5ea95b04aedaee194732dc7f09ff970a2b43d3e8e1c5f2.
- E. van den Berg and M. P. Friedlander, *Joint-sparse recovery from multiple
  measurements*, arXiv:0904.2051. Read: abstract, setup, row-support
  definition, and main recovery criterion. Proposition 1 is the exact
  finite-field coding translation, not a claim to invent joint sparsity.
  Cached SHA-256:
  a0fedbc338f7be4c3174944d8560a4c4450eb4a38a14a292e760b68f4c63a3e0.
- E. R. Berlekamp, R. J. McEliece, and H. C. A. van Tilborg, *On the inherent
  intractability of certain coding problems*, IEEE Trans. Inform. Theory 24
  (1978), DOI 10.1109/TIT.1978.1055873. Read: publisher/repository abstract
  and bibliographic record. It establishes NP-completeness of general decoding
  and coset weight.

The categorical proposition is a direct specialization of Yoneda, not a
literature-novel category-theory theorem. The paper-specific part is bounded
natural transfer of support-filtered representables.

No source in the prior C946 full-text audit or the focused searches for C947
states the combination of all presented target demands, complete affine
coefficient fibers, union-helper filtration, and sharp concatenation
confinement. This is a bounded-search conclusion, not a global novelty
guarantee.

## 9. TT verdict

### Theorem hierarchy

1. **Paper-bearing theorem remains C946, not C947.** Exact natural transfer of
   the entire bounded demand-lifting diagram under the sharp confinement gate
   is the genuinely structural theorem. C947 does not create a priority
   challenge to the existing paper; it clarifies the best successor language.
2. **Retain as the main C947 bridge:** Proposition 1 and Corollary 1.1. They
   identify exactly which scalar information survives and which
   coefficient-aware information lies above it. The proof is elementary
   generator-matrix algebra, so this is high-utility packaging rather than a
   stand-alone novelty claim.
3. **Retain as sharp negative lemmas:** the two binary examples. They prevent
   a false polymatroid program. Their value is diagnostic, not flagship.
4. **Credit as inherited complexity:** Proposition 2 is a direct specialization
   of classical coset-weight NP-completeness. The coding translation is exact,
   but no new hardness technique should be claimed.
5. **Use as conceptual compression:** Proposition 3 is standard Yoneda applied
   in the correct slice category. The new paper-specific content would be the
   bounded support filtration and its exact transfer, not representability
   itself.
6. **Quarantine as sequel mathematics:** Smith profiles are proved elementary
   arithmetic observations; a module-valued confinement theorem, arithmetic
   Tutte determination, or recovery sheaf is not proved.

### Hypothesis audit

- The counterexamples use \(G_P=I\), so no target-kernel degeneracy causes the
  lattice failures.
- The NP-completeness reduction is binary, uses a generator presentation
  \(G=(b\mid M)\), and preserves the helper-weight threshold exactly.
- Yoneda applies to the unfiltered lift functor at fixed \(H\); the bounded
  support filtration is additional structure and is not itself claimed
  representable.
- The categorical transfer statement is asserted only under C946's stated
  confinement hypothesis.
- The arithmetic claims concern solvability for a fixed integral lift. They do
  not claim that every finite-field represented code has a preferred or
  characteristic-independent integral model.

### Promotion decision

Nothing in C947 should be inserted into the current paper merely to enlarge
its scope. If a sequel is packaged now, lead with exact bounded transfer for
all demand subspaces, use joint row support as the computational model, and
place Yoneda in a short structural subsection. The arithmetic direction earns
promotion only after one integral-seed experiment produces a nontrivial prime
phase diagram.

## Mystery ledger

### Settled

- Submodularity: false, by the binary seven-coordinate example.
- Supermodularity: false, by the binary four-coordinate example.
- Standard optimization object: finite-field minimum joint row support.
- Scalar information loss: \(\rho_{P,A}\) factors through \(G_PA\), whereas
  the full lift functor can retain coefficient-presentation data.
- Generic exact complexity: NP-complete already for one binary demand.
- Categorical completion: the Yoneda representable of the restricted-dual map.
- Noninjective presentations: scalar cost depends only on their image, as in
  C946; their full lift fibers still retain kernel gauge data.

### Open

- Fixed-parameter algorithms in radius, demand dimension, and field size.
- Sharp generalized- or relative-weight bounds for prescribed demands.
- A universal characterization of the bounded filtered representable.
- Prime classification of support and coefficient changes for integral seeds.
- Correct projectivity or Frobenius-ring hypotheses for ring confinement.

## Verdict

The cheap successor succeeded by killing the tempting conjecture. Recovery
cost is not a new polymatroid rank. Its exact optimization home is joint sparse
linear solving over finite fields; its exact categorical home is a
support-filtered representable presheaf; and its credible number-theoretic
extension is an arithmetic family of module-valued lift problems controlled
locally by Smith data. The first is the best immediate research payoff, the
second the cleanest conceptual compression, and the third a promising but
genuinely new sequel.
