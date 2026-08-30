# C1005 — extremal-shell reconstruction criterion

**Lane**: `clebsch`

**Status:** Math packet proved; no manuscript edits.  The spectral criterion,
coherent-closure correction, and exact no-go statements are separated below.
The \(q=13\) pair matrix satisfies the strongest spectral criterion, with a
new exact certificate.

## Goal

Prove a precise reconstruction criterion for weighted pair-concurrence matrices of group-stable extremal families. Separate polynomial spectral generation, coherent closure, automorphism recovery, and genuine information-theoretic impossibility.

## Acceptance gate

- State and prove the multiplicity-free spectral-separation theorem over the correct coefficient field.
- Determine when the Hadamard-primitive orbital basis is canonically recoverable.
- Replace the false claim that proper fusion alone forbids reconstruction by sufficient no-go hypotheses such as excess automorphisms or inequivalent refinements with one weighted two-section.
- Test the statements on the q=13 minimum-word shell and at least one Clebsch carrier/failure case.
- Keep standard commutant theory distinct from new applications.

## Publication successor

C1006 owns the later integration-versus-spinoff decision.

## 1. Observation model

Let a finite group \(G\) act on a finite set \(\Omega\), and let
\(\mathcal H\) be a \(G\)-stable uniform family on \(\Omega\).  Its weighted
pair-concurrence matrix is
\[
 M_{xy}=\#\{H\in\mathcal H:\{x,y\}\subseteq H\}\quad(x\ne y).
\]
The diagonal may be set to zero or to the unary degrees; in a transitive
uniform situation the two conventions differ by a scalar matrix and generate
the same unital algebra.

Put \(V=F^\Omega\) and
\[
 \mathcal A=\operatorname{End}_{FG}(V).
\]
As a concrete matrix algebra, \(\mathcal A\) has the orbital matrices of
\(G\) as its canonical \(0\)-\(1\) basis and is closed under ordinary
matrix multiplication, transpose, and Hadamard product.

## 2. Spectral-separation theorem

**Theorem (multiplicity-free spectral reconstruction).**  Let \(F\) be a
splitting field for \(G\), with \(\operatorname{char}F\nmid |G|\), and suppose
the permutation module is multiplicity-free:
\[
 V=V_0\oplus\cdots\oplus V_{r-1},
\]
where the \(V_i\) are pairwise nonisomorphic absolutely irreducible
\(FG\)-modules.  Let \(M\in\mathcal A\), and write
\[
 M|_{V_i}=\theta_i I_{V_i}.
\]
Then the following are equivalent:

1. the scalars \(\theta_0,\ldots,\theta_{r-1}\) are pairwise distinct;
2. \(F[M]=\mathcal A\);
3. every orbital matrix is a polynomial in \(M\).

When these conditions hold, the spectral projectors are explicitly
\[
 E_i=\prod_{j\ne i}\frac{M-\theta_jI}{\theta_i-\theta_j},
\]
so the ordinary power algebra already recovers the full orbital algebra.
The orbital \(0\)-\(1\) matrices are then recovered canonically as the
minimal nonzero Hadamard idempotents of that concrete algebra.

**Proof.**  Maschke and the splitting hypothesis give the displayed direct
sum.  Multiplicity-freeness and Schur's lemma identify
\[
 \mathcal A\cong F^r
\]
by restriction to the \(V_i\).  Under this identification \(M\) is
\((\theta_0,\ldots,\theta_{r-1})\).  Lagrange interpolation shows that this
element generates \(F^r\) exactly when its coordinates are distinct, proving
the first equivalence and the projector formula.  The orbital matrices are a
basis of \(\mathcal A\), proving (3).  Finally, for orbitals \(R,S\),
\[
 A_R\circ A_S=\delta_{RS}A_R.
\]
Every Hadamard idempotent in \(\mathcal A\) is a \(0\)-\(1\) union of
orbitals, so the minimal nonzero ones are exactly the individual orbital
matrices. \(\square\)

For a real symmetric pair matrix, the same theorem is read over
\(\mathbf C\) or a real splitting field.  If it separates all constituents,
then every element of \(\mathcal A=F[M]\) is symmetric; hence all orbitals are
self-paired.  Thus a nonsymmetric multiplicity-free orbital algebra is an
automatic obstruction to a *symmetric* matrix satisfying the distinct-scalar
hypothesis.

## 3. Coherent closure is a different reconstruction route

Let \(\operatorname{CC}(M)\) be the smallest concrete matrix space containing
\(I,J,M\) and closed under ordinary multiplication, Hadamard product, and
transpose.  If \(M\in\mathcal A\), then
\[
 F[M]\subseteq\operatorname{CC}(M)\subseteq\mathcal A.
\]
Consequently:

- \(F[M]=\mathcal A\) is the sharp criterion for **ordinary spectral
  generation**;
- \(\operatorname{CC}(M)=\mathcal A\) is the sharp criterion for recovery by
  **coherent refinement**;
- \(F[M]\subsetneq\mathcal A\) does not imply reconstruction failure, because
  Hadamard splitting followed by multiplication may still recover every
  orbital;
- even \(\operatorname{CC}(M)\subsetneq\mathcal A\) only defeats this
  particular algebraic route.  It is not, by itself, an information-theoretic
  impossibility theorem: global nonlinear invariants can distinguish objects
  that coherent refinement does not.

This is the precise correction to the old proposed “proper fusion means no
reconstruction” converse.

## 4. Exact information-theoretic no-go criteria

Let \(X\) be a target marked structure on \(\Omega\), and suppose its shadow
\(\Phi(X)=M\) is isomorphism-equivariant.

**Indistinguishable-refinement obstruction.**  If there are nonisomorphic
targets \(X,X'\) with permutation-isomorphic shadows
\(\Phi(X)\cong\Phi(X')\), then no procedure taking only the unlabeled shadow
can reconstruct the target up to isomorphism.  This is the exact fibre
criterion: reconstruction is possible precisely when the induced observation
map on target isomorphism classes is injective.

**Excess-automorphism obstruction.**  Any intrinsic reconstruction
\(R(M)\cong X\) forces
\[
 \operatorname{Aut}(M)\le \operatorname{Aut}(X).
\]
If the shadow is canonically derived from \(X\), the reverse inclusion also
holds, so equality is necessary.  Therefore
\(\operatorname{Aut}(M)\supsetneq\operatorname{Aut}(X)\) rules out intrinsic
reconstruction.  An arbitrary algorithm may choose one refinement by a
label-dependent tie break, but that is not recovery from the unlabeled
shadow.

These two statements are genuinely stronger logically than “the shadow lies
in a proper fusion algebra”: they identify either an actual collision of
isomorphism classes or a symmetry that the observation cannot break.

## 5. The \(q=13\) minimum-word shell

Let \(M\) be Paper IV's \(78\times78\) pair-concurrence matrix, with zero
diagonal.  Its off-diagonal values are
\[
\begin{array}{c|rrrrrr}
\rho&0&1&3&9&10&12\\ \hline
c&8&6&6&12&7&9.
\end{array}
\]
The raw value coloring fuses \(A_1\) and \(A_3\), but the existing coherent
closure separates them in one refinement, so
\(\operatorname{CC}(M)\) is the full seven-dimensional elliptic
Bose--Mesner algebra.

The stronger spectral statement also holds:
\[
 \boxed{\mathbf Q[M]=\mathcal A_{\rm ell}.}
\]
Indeed \(I,M,\ldots,M^6\) are linearly independent, while
\(\dim\mathcal A_{\rm ell}=7\).  The exact checked identity is
\[
\begin{split}
M^7={}&568M^6+29775M^5-98533M^4-17583384M^3\\
     &-164334272M^2-342870528M.
\end{split}
\]
A canonical \(7\times7\) entry minor of the first seven powers has nonzero
determinant
\[
-588032627033324735474759106560.
\]
Since \(M\) is real symmetric, its minimal polynomial has degree seven and it
has seven distinct eigenvalues.  Thus Paper IV is not merely an example where
coherent closure repairs a raw fusion: the single weighted pair matrix is a
cyclic generator of the entire rational relation algebra.

This yields two conceptually independent reconstruction routes:

1. value colors, one common-neighbor refinement, and Hadamard atoms;
2. ordinary powers of \(M\), followed by the Hadamard atoms of
   \(\mathbf Q[M]\).

The existing unary no-go is exactly the excess-automorphism criterion.
Every coordinate has degree \(56\), so the unary shadow has automorphism group
\(S_{78}\), while the reconstructed marked geometry has automorphism group
\(\operatorname{PGL}(2,13)\) of order \(2184\).  Unary reconstruction is
therefore impossible for a structural, not merely algorithmic, reason.

### Reproducibility

The task-owned checker constructs the internal points and \(M\) from the
intrinsic \(\rho\)-relation formula and the proved concurrence table.  It does
not enumerate minimum supports.  It verifies the pair distribution, selects
the lexicographically first independent entry rows modulo \(1000003\), checks
their determinant exactly, solves for the degree-seven identity over
\(\mathbf Q\), and verifies that identity entrywise.

Replay:

~~~sh
cd /home/tavis/src/othello
python notes/clebsch-tasks/c1005-q13-spectral-generation.py \
  --check notes/clebsch-tasks/c1005-q13-spectral-generation.json
~~~

| file | bytes | SHA-256 |
|---|---:|---|
| notes/clebsch-tasks/c1005-q13-spectral-generation.py | 8589 | db2c96b34c7fa1579c77f55a7e520bd4aa69aba6c6ba2c80984031152ea52116 |
| notes/clebsch-tasks/c1005-q13-spectral-generation.json | 1379 | 6a5c67341a61db407ac151d4b7f8b41261f8ef53e084add279141938d819637b |

The independent support-orbit checker
papers/q13-passant-code/verification/verify_pair_reconstruction.py
(13388 bytes, SHA-256
20f3d8050fe801050d85dd41b022f653487a8f39abeb30a4a19710d2eb4ecf5f)
produces the same concurrence distribution in
pair_reconstruction.json (1645 bytes, SHA-256
cb9c1da169cef5f23402bb87d28d4f5885ddecb9ae7d92f784803a2d9d8d0ae6).
The two routes share the proved relation/concurrence dictionary but not the
minimum-support enumeration.

The certificate proves generation for this integral \(q=13\) matrix.  It
does not prove a uniform statement for other elliptic schemes or other
extremal shells.

## 6. Clebsch carrier and failure case

Paper II's quadratic-trade observation is not literally a weighted
pair-concurrence matrix, so it should be used as a test of the no-go logic,
not advertised as an instance of the spectral theorem.

On the matching carrier, the one-dimensional two-valued quadratic trade
recovers the unordered pair of factorization sheets in the \(B_3/\mathbf F_7\)
and \(H_3/\mathbf F_{11}\) cases; the first nonzero signed cubic orients the
pair.  Off the carrier, each relevant fixed affine line contains \(q-2\)
nonmatching orbits with the same sheet-sign trade type, and the matching point
is only the unique completely split Chow point.  Thus:

- the reduced trade observation has nontrivial fibres once the carrier is
  forgotten, instantiating the indistinguishable-refinement obstruction;
- the Chow/splitting condition restores the carrier;
- the cubic is a minimal enrichment for orientation after the unordered
  sheets have been recovered.

This is the correct existence/impossibility lesson.  It does not support the
stronger false claim that membership in a proper fusion algebra alone
prevents reconstruction.

## 7. Manuscript-ready draft language (not integrated)

For a possible Paper IV proposition:

> **Proposition (the pair matrix generates the elliptic relation algebra).**
> Let \(M\) be the zero-diagonal weighted pair-concurrence matrix of the
> \(364\) minimum supports.  Then
> \(\mathbf Q[M]\) is the seven-dimensional Bose--Mesner algebra of the
> elliptic scheme.  Equivalently, \(M\) has seven distinct eigenvalues and
> every elliptic relation matrix is a rational polynomial in \(M\).
>
> **Proof.**  The relation/concurrence table places \(M\) in the elliptic
> Bose--Mesner algebra.  Exact entrywise arithmetic shows that
> \(I,M,\ldots,M^6\) are linearly independent; the displayed degree-seven
> identity closes their span.  Since the elliptic algebra has dimension
> seven, equality follows.  Its orbital matrices are the minimal nonzero
> Hadamard idempotents of this concrete algebra.

For a reusable general lemma:

> In a split semisimple multiplicity-free permutation representation, an
> invariant matrix generates the full orbital algebra exactly when its Schur
> scalars on the irreducible constituents are pairwise distinct.  Proper
> ordinary spectral generation is not an information-theoretic no-go:
> coherent closure can be larger.  Genuine impossibility follows instead
> from a collision of target isomorphism classes under the observation map,
> or from excess automorphisms of the shadow.

## 8. Publication assessment for C1006

The abstract algebra is standard commutant/association-scheme theory.  Its
value here is the sharp separation of four notions often conflated:
spectral generation, coherent closure, automorphism recovery, and
information-theoretic identifiability.

On present evidence this is **not yet a standalone paper**.  The new
\(q=13\) cyclic-generator fact is a clean strengthening of Paper IV, and the
general lemma is useful series-level language.  A standalone reconstruction
paper becomes credible only after C1006/C968 identify several nontrivial
families where the criterion either succeeds or yields exact no-go fibres.
Until then the best deliverables are:

1. the general theorem/no-go packet above;
2. the exact \(q=13\) certificate;
3. the manuscript-ready proposition as an optional Paper IV strengthening;
4. a cross-series table classifying examples by
   \(F[M]\), \(\operatorname{CC}(M)\), \(\operatorname{Aut}(M)\), and fibre
   injectivity.
