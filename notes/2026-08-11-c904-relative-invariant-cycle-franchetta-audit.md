# C904: relative invariant-cycle and Franchetta boundary

Date: 2026-08-11

Status: claim-specific primary-source audit; Paper V research only; no
manuscript or Lean change

## Verdict

The invariant-cycle implication needed for an obstruction is elementary and
integral:

> An algebraic cycle defined over the generic field of a smooth proper
> one-parameter family spreads after shrinking the base, and its integral
> cohomology class is monodromy invariant.

The converse is neither needed nor available integrally. Deligne's global
invariant-cycle theorem is rational, and Arapura--Greer--Zhang now give
one-parameter semistable counterexamples over \(\mathbf Z\).

For C904 this distinction no longer yields a parity theorem. The exact
residual-\(C_3\) replay in
2026-08-11-c904-c3-lefsche-cokernels.md shows that the **whole mixed
Kunneth tensor** has invariant odd classes in both live channels. The
\((1,5)\) invariant space has dimension \(50\), and the \((2,4)\) invariant
space has dimension \(776\). Thus residual monodromy does not force a
generic multisection degree to be even.

The remaining gate is Chow-theoretic and two-local: decide whether one of
those invariant odd integral classes is represented by an integral algebraic
cycle, or prove that every such representation is obstructed. A standard
Franchetta theorem does not do either. It is an injectivity statement for
already-spread cycles with rational coefficients, not a surjectivity or
integral descent theorem.

The rational \((1,5)\) inverse-Lefschetz class is algebraic after all. If
\(b:M\to J\) is the theta-resolution and \(\Lambda_J\) is the algebraic
rational inverse-Lefschetz correspondence on the abelian fivefold, then

\[
             b^*\circ\Lambda_J^2\circ b_*
             \in CH^3(M\times M)_{\mathbf Q}
\]

has the required cohomological degree. Averaging over the
polarization-preserving \(C_3\), if necessary, makes it equivariant without
introducing a two-primary denominator. What is missing is precisely an
integral or \(\mathbf Z_{(2)}\) representative across the ten elementary
divisors two.

No exact precedent was located for this algebraic two-local obstruction on a
theta resolution. The underlying integral symplectic Lefschetz defect is,
however, already treated in much greater generality by Faulkner
Valiente--Miller Eismeier. Their integral Lefschetz filtration and
nonexistence of equivariant splittings pre-empt any claim that the bare Smith
defect is new. The C904-specific content begins with the singular theta
resolution, the residual \(C_3\) tensor calculation, and the algebraic Chow
lifting question.

This report uses no source read cover-to-cover. It uses seven primary
sources at claim-specific theorem depth and one source at
abstract/publisher-preview depth. The negative precedent statement is
bounded by the searches recorded below.

## 1. The direction that is valid integrally

Let \(f:\mathcal Y\to U\) be smooth and proper over a connected complex
curve and let \(Z\in CH^r(\mathcal Y)\). Naturality of the cycle-class map
identifies

\[
            \operatorname{cl}(Z|_{Y_u})
            \in H^{2r}(Y_u,\mathbf Z)
\]

with a global section of \(R^{2r}f_*\mathbf Z\). It is therefore fixed by
\(\pi_1(U,u)\). If \(Z_\eta\) is defined only over
\(K=\mathbf C(U)\), take its closure and shrink \(U\) until it spreads; the
same conclusion holds. This argument uses only functoriality of cycle
classes and topological local triviality. It does not invoke the global
invariant-cycle theorem.

The relative symmetric square is singular along its diagonal, but this does
not change the necessary condition used here. Pull its integral cohomology
class to the ordered cover \(M\times_U M\), which is a smooth proper family
after shrinking. A generic algebraic cycle still gives a monodromy-fixed
integral Kunneth class there.

Vertical corrections introduced by spreading have zero restriction to the
generic fibre. Homologically trivial corrections have zero value under the
top-degree contraction that records multisection degree. They cannot turn a
non-invariant generic class into an invariant one or change its generic
degree.

## 2. The invariant-cycle theorem does not give an integral converse

Arapura--Greer--Zhang, Theorem 8.1, restate Deligne's global theorem as

\[
 \operatorname{im}\bigl(H^n(\mathcal Y,\mathbf Q)\to
 H^n(Y_u,\mathbf Q)\bigr)
 =H^n(Y_u,\mathbf Q)^{\pi_1(U,u)}.
\]

Their Theorem 1.7/8.3 constructs a smooth projective threefold over a smooth
projective curve, with a proper semistable map, for which the analogous
surjectivity over \(\mathbf Z\) fails. The smooth open family in their
example still admits integral lifts there; the obstruction is extension
across the singular fibres. Appendix C recovers invariant divisor classes
under a special negative-curve rigidity hypothesis by using the relative
Hilbert scheme. That codimension-one argument supplies no
higher-codimension theta-resolution theorem.

Consequently:

- a generic algebraic cycle always gives an invariant integral class;
- an invariant integral class need not extend across a compactification;
- invariance alone does not produce an algebraic cycle even on the smooth
  open family; and
- rational invariant-cycle surjectivity loses the mod-two information that
  C904 needs.

## 3. Exact \(C_3\) replay: the proposed obstruction fails

Let \(Q_{15}\) be the two-primary cokernel of
\(L:\bigwedge^5\Lambda\to\bigwedge^7\Lambda\), and let \(Q_{24}\) be the
two-primary cokernel of
\(L:\bigwedge^4\Lambda\to\bigwedge^6\Lambda\). The committed primary and
independent replays prove

\[
 Q_{15}=5W,
 \qquad
 Q_{24}=\mathbf 1^{24}\oplus10W,
\]

for the irreducible two-dimensional \(W\) over
\(\mathbf F_2[C_3]\). Although \(Q_{15}^{C_3}=0\), the effective companion
factor is \(Q_{15}^{\vee}\), so

\[
   (Q_{15}^{\vee}\otimes Q_{15})^{C_3}
\]

contains the identity. Its coefficient trace is
\(5\equiv1\pmod 2\). The same averaging argument produces odd invariant
contractions in the \((2,4)\) channel. Exact dimensions are \(50\) and
\(776\).

This is the decisive correction to the proposed argument. Exactness of
\((-)^{C_3}\) over \(\mathbf F_2\) is true because \(3\) is invertible, but
it must be applied to the whole tensor quotient. Fixed-free individual
factors can have a large invariant tensor product.

Therefore no invariant-cycle or Franchetta theorem can convert the present
\(C_3\) calculation into relative index two: the required odd invariant
cohomology classes already exist.

## 4. The remaining Chow obstruction

Even if a geometric algebraic class is monodromy or Galois invariant, three
separate questions remain:

1. **Cycle descent.** Does the invariant class lie in the image of
   \(CH^3(Y_K)\to CH^3(Y_{\bar K})\)? Higher-codimension Chow groups do not
   satisfy formal Galois descent; Diaz gives function-field counterexamples.
2. **Integral algebraization.** Is the invariant integral cohomology class
   represented by an integral cycle, rather than only a rational cycle whose
   denominator is even?
3. **Relation descent.** If a supported cycle \(z\) becomes \(2a\)
   geometrically, does the half \(a\), and the equality \(2a=z\), descend?
   The existing C904 obstruction

   \[
     o_K(z)\in\ker\left(CH_1(D_K)/2\to
                         CH_1(D_{\bar K})/2\right)
   \]

   isolates exactly this last failure.

Restriction--corestriction makes the two-primary boundary sharp. An
odd-degree extension cannot kill a nonzero mod-two Chow obstruction: the
norm of an odd-degree cycle has odd degree downstairs. Conversely, passing
to the exotic quadratic cover makes a class invariant at most; it does not
construct an odd cycle or prove a half relation. A statement that this cover
is minimal therefore needs both a downstairs lower bound and an explicit
odd carrier or complete half upstairs.

## 5. Why a standard Franchetta theorem does not help

Fu--Laterveer Definition 2.1 says that a smooth projective family has the
Franchetta property in codimension \(i\) when a cycle already defined on the
total family restricts to zero in rational Chow if and only if its fibrewise
rational cohomology class is zero. Definition 2.3 reformulates this as
injectivity of

\[
  GDCH^*_{B}(Y_b)\longrightarrow H^*(Y_b,\mathbf Q),
\]

where \(GDCH\) is the image of cycles on the total family. Their convention
throughout is rational coefficients.

Thus Franchetta can control the kernel of the cycle-class map on cycles that
have already spread. It does not assert that a monodromy-invariant class is
generically defined, does not produce an algebraic lift of a Hodge class, and
cannot see whether a rational lift needs a factor \(1/2\). A hypothetical
integral or \(\mathbf Z_{(2)}\) Franchetta theorem could prove uniqueness of a
spread half or kill a homologically trivial difference, but it would still
need a separate existence/descent theorem.

## 6. Rational inverse Lefschetz is algebraic; integrality is the gate

Milne's Theorem 5.9 and Remark 5.11 give rational-equivalence Lefschetz
cycles inducing the inverse hard-Lefschetz correspondences on an abelian
variety (building on Lieberman and Kleiman). In the present dimensions,

\[
 H^3(M)\xrightarrow{\,b_*\,}H^5(J)
 \xrightarrow{\,\Lambda_J^2\,}H^1(J)
 \xrightarrow{\,b^*\,}H^1(M)
\]

is induced by a codimension-three rational algebraic correspondence on
\(M^2\). The graph Gysin raises degree by two, the two inverse-Lefschetz
operators lower it by four, and pullback preserves degree. The composite is
\(C_3\)-equivariant after odd-order averaging.

This corrects the earlier source verdict that rational algebraicity of the
\((1,5)\) Hodge tensor was unsupported. It also makes the obstruction
cleaner: the Smith form of \(L:\Lambda^5\to\Lambda^7\) has ten elementary
divisors two, and no audited source supplies an integral or
\(\mathbf Z_{(2)}\) algebraic refinement of this composite.

Beckmann--de Gaay Fortman's integral Fourier-transform theorem is nearby but
does not close the gap. Its integral Fourier transform is equivalent to
having an algebraic minimal class on the abelian variety; it does not
preserve support on the theta resolution or supply the needed integral
codimension-three correspondence on \(M^2\).

## 7. Prior-art boundary for the integral Lefschetz defect

Faulkner Valiente--Miller Eismeier study
\(\bigwedge^*\mathbf Z^{2g}\) with its standard symplectic form. Their
Theorem 1.1 constructs an \(Sp(2g)\)-invariant integral Lefschetz filtration.
Theorem 1.2 computes the associated graded of

\[
 \operatorname{coker}\left(\omega^i/i!:
 \bigwedge^{g-i}\mathbf Z^{2g}\to
 \bigwedge^{g+i}\mathbf Z^{2g}\right).
\]

For \(g=5,i=1\), it recovers the two-primary rank \(44\) of the C904
\(\bigwedge^4\to\bigwedge^6\) cokernel and the additional factor three
(hence the observed extension
\((\mathbf Z/2)^{43}\oplus\mathbf Z/6\)). Their Lemmas 2.12--2.13 show that
the relevant integral Lefschetz filtration does not admit the expected
\(Sp(2g)\)-equivariant splitting.

This is direct precedent for the **integral linear-algebra obstruction**.
It is not a theorem about algebraic cycles, theta divisors, the singular
cubic-threefold theta resolution, residual \(C_3\), or relative Chow
descent. The safe priority boundary is therefore:

- pre-empted: general integral symplectic Lefschetz filtration, Smith defects,
  and failure of full symplectic-equivariant splitting;
- not located in the bounded search: the \(C_3\)-equivariant mixed-Kunneth
  calculation on the cubic theta resolution and its two-local
  algebraic-cycle lifting obstruction.

## 8. Surface-base lifting and the degree-five route

The finite-component reduction changes the earlier base-dimension verdict.
The relative divisor-product cycle has finitely many supporting components
\(S_i\), each a complex surface. De Jong--He--Starr Corollary 12.2 is
therefore dimensionally applicable to a proper model over \(S_i\). It would
give a rational section if, after deleting codimension two, the family had
geometrically irreducible fibres and a relative ample line bundle, and if the
geometric generic fibre satisfied Hypothesis 6.8 (rational simple
connectedness by the specified free-line chains) and contained a very
twisting surface.

No audited source verifies these hypotheses for the charge-three
Abel--Jacobi fourfold. Rational connectedness or unirationality alone is
insufficient.

Harris--Roth--Starr Corollary 8.6 proves, for a fixed smooth cubic threefold
over \(\mathbf C\), that the general fibre of
\(u_{5,1}:H_{5,1}(X)\to J(X)\) is an irreducible unirational fivefold. The
paper explicitly works over \(\mathbf C\). Its proof first chooses a general
quartic rational curve \(C\) in the relevant Abel--Jacobi fibre, constructs a
unirational cover using points on \(C\times X\), and then produces sections
of the auxiliary elliptic and quartic families after that base change. It
does not state a uniform \(K(S_i)\)-unirational parametrization or a
\(K(S_i)\)-point. Using the construction over \(K(S_i)\) requires the
initial curve/section that the proposed application is meant to produce, so
the available proof is circular for descent.

Nor does Corollary 8.6 prove the de Jong--He--Starr free-line evaluation,
chain irreducibility, or very-twisting-surface hypotheses on the charge-three
fourfold. The degree-five route is therefore revived only as a concrete
research program: make the HRS construction uniform over \(S_i\), or prove
the required rational simple connectedness independently. It is not a
current section theorem.

## 9. Sources and read depth

1. Donu Arapura, Francois Greer, Yilong Zhang, *Failure of the invariant
   cycle theorem over Z*, arXiv:2602.07302v2. Read depth:
   **claim-specific partial**, Introduction, Section 8, and Appendix C.
   Cached PDF SHA-256
   3ca6b0233b6ad3e41b568a0a31347014a77ba3f2693c565e69c063f891bf5f06.

2. Lie Fu, Robert Laterveer, *Special Cubic Four-Folds, K3 Surfaces, and the
   Franchetta Property*, arXiv:2112.02437v1 / IMRN 2023. Read depth:
   **claim-specific partial**, coefficient convention and Definitions
   2.1--2.3. Cached PDF SHA-256
   28bdc6b924b2c027ef4412f2fd94c2e0f07b521b683781f9015bb3231bf4eddf.

3. Analisa Faulkner Valiente, Mike Miller Eismeier, *A Lefschetz
   decomposition over Z, and applications*, arXiv:2507.00844v1. Read
   depth: **claim-specific partial**, Introduction, Theorems 1.1--1.2,
   Corollary 2.10, and Lemmas 2.12--2.13. Cached PDF SHA-256
   3a3ef5208198526fdfcdeaabc00abbae77650b2015bce5806cce92e3d8a0ac91.

4. A. J. de Jong, Xuhua He, Jason Michael Starr, *Families of rationally
   simply connected varieties over surfaces and torsors for semisimple
   groups*, arXiv:0809.5224 / Publ. Math. IHES 114 (2011). Read depth:
   **claim-specific partial**, Introduction, Corollaries 1.1/12.2,
   Hypothesis 6.8, and the very-twisting-surface hypotheses. Cached PDF
   SHA-256
   44e7af4595261743df7d310274682bb69010f93377977da857be0d4936b1cc68.

5. Joe Harris, Mike Roth, Jason Starr, *Abel-Jacobi maps associated to
   smooth cubic threefolds*, arXiv:math/0202080. Read depth:
   **claim-specific partial**, Introduction, Sections 7--8, Lemma 8.1 and
   Corollary 8.6 with proof. Cached PDF SHA-256
   fae17135016e77425060e8c0860c9938facda3144ac1cd091a853d34c337d3ec.

6. Thorsten Beckmann, Olivier de Gaay Fortman, *Integral Fourier transforms
   and the integral Hodge conjecture for one-cycles on abelian varieties*,
   arXiv:2202.05230. Read depth: **claim-specific partial**, Sections
   3.1--3.3, Proposition 3.11, and Corollary 4.3, as recorded in the earlier
   relative-Shen audit. Cached PDF SHA-256
   ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc.

7. J. S. Milne, *Lefschetz classes on abelian varieties*, Duke Mathematical
   Journal 96 (1999), 639--675. Read depth: **claim-specific partial**,
   Section 5, especially Proposition 5.7, Theorem 5.9, and Remark 5.11.
   Theorem 5.9 proves that the inverse-Lefschetz correspondences are
   Lefschetz; Remark 5.11 supplies representatives modulo rational
   equivalence. Cached PDF SHA-256
   28ae245e58748438b7070680cac83f8b2f695c43f1643b59cde21eb94077fe53.
   Milne cites Lieberman and Kleiman for the classical input; their originals
   were not accessed in this pass.

Humberto Diaz, *On the failure of Galois descent for Chow groups*, Journal
of Algebra 667 (2025), 203--210, was used only for the higher-Chow descent
warning. Read depth: **abstract/metadata and publisher preview only**, as
recorded in
2026-08-11-c904-relative-shen-descent-and-m9-polarization-audit.md.
The PDF was not accessible and is not cached.

## 10. Search boundary

Bounded web searches on 2026-08-11 used the exact queries:

    "integral Lefschetz" theta divisor monodromy correspondence
    "theta resolution" "integral" cohomology Lefschetz
    "Franchetta property" theta divisor abelian variety integral
    "equivariant" "Lefschetz" abelian variety integral Hodge
    "A Lefschetz decomposition over Z, and applications"
    site:arxiv.org "Lefschetz decomposition over" "applications" integral
    site:arxiv.org theta divisor "integral Lefschetz"

They recovered the ambient integral-Fourier literature, Milne's account of
Lieberman, the rational Franchetta literature, and the 2025 integral
Lefschetz-filtration preprint. No result located in this bounded screen
treated the singular cubic theta resolution together with finite-group
monodromy and integral algebraic correspondences. This licenses only the
bounded wording "no exact precedent was located," not an exhaustive absence
claim. MathSciNet and zbMATH were not covered; Google Scholar's automated
interface was not used. No forward-citation count is claimed.

## Propagation checklist

- Updated this focused audit, the relative-Shen source audit, the symmetric
  theta Kunneth audit, and the theta-resolution topology/projector audit.
- The exact \(C_3\) computation and its negative verdict live in the
  committed replay report named above.
- No manuscript, claim--proof--novelty ledger, result snapshot, handoff, or
  public summary currently states the rejected \(C_3\)-vanishing claim, so
  none required an edit.

## Mystery ledger

- **Settled negatively:** residual \(C_3\) does not kill either mixed
  Kunneth escape; odd invariant tensors exist in both.
- **Settled:** rational algebraicity of the \((1,5)\) lowering operator
  follows from Milne's abelian inverse-Lefschetz correspondence.
- **Settled:** standard Franchetta and rational invariant-cycle theorems do
  not address the integral existence/descent gate.
- **Settled:** the bare integral symplectic Lefschetz defect is prior art;
  C904 must not claim it as new.
- **Corrected:** the de Jong--He--Starr theorem is dimensionally relevant on
  the surface components \(S_i\), though none of its geometric hypotheses is
  established for the charge-three fibre.
- **Open:** integral or \(\mathbf Z_{(2)}\) algebraization of an odd invariant
  \((1,5)\) or nonsplit \((2,4)\) class.
- **Open:** a uniform \(K(S_i)\)-defined degree-five parametrization, or a
  proof of free-line rational simple connectedness and a very twisting
  surface for a proper polarized charge-three model.

Vibe: the monodromy obstruction is dead, but the failure is mathematically
clean. The surviving crown is an explicitly isolated two-local
algebraic-correspondence problem, with a credible surface-base RSC fallback
whose missing hypotheses are now exact.
