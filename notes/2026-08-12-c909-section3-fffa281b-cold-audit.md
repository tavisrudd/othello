# C909 — cold hostile reread of committed Section 3 (`fffa281b`)

Date: 2026-08-12

Status: **MAJOR — do not treat the Section 3 replacement as closed yet.**
The mathematical package is coherent, and the local rank-one identity and
the six-axis support list survive the reread.  But two load-bearing claims are
not presently theorem-grade in print: the graph-adjoint normalization is
ambiguous, and the full integral-Hodge conclusion is compressed past the
point at which a reader can exclude a lower Pluecker combination.  This note
audits the committed file only; it makes no manuscript, PDF, mirror, Lean, or
ledger edit.

## Checked surface and verdict

The checked text is
`fffa281b:papers/cubic-stabilization-m1/sections/03-minimal-class.tex`.
The verdict by component is:

| component | verdict | exact disposition |
|---|---|---|
| marked finite-etale graph theorem | **MAJOR repair** | fix the adjoint convention and separate the unit block before (3.3) |
| matrix-ideal/rank-one proof | **GO after that repair** | (3.6)--(3.7) are the valid signed, dyadic-safe straightening argument |
| all-degree divided-power descent | **MINOR repair** | say precisely that the split terms are coefficient-extended classes and descend equality of image lattices, not line bundles |
| actual six-axis four-slot calculation | **MAJOR proof-surface repair** | print the weighted two-matching bases and the Hodge as well as product scales |
| non-CM six-axis full Hodge equality | **MAJOR proof-surface repair** | include the integral invariant/multidegree lemma and the direct codimension-three-to-five reduction |
| five-distinct-root quotient | **MAJOR repair** | add non-CM, exact two-generator Smith lattice, direct-support argument, and (if wanted) the theta-complement calculation |
| citations and priority hedge | **GO with one locator repair** | the prose does not overclaim priority; make the DCEP pointer theorem-specific |

There is also a literal typesetting error at current line 67:
`\max(a_i,a_j)geq` must be `\max(a_i,a_j)\geq`.

## 1. Exact graph normalization: a theorem-statement gate

At lines 39--44, ``(T) ... is self-adjoint for (B)'' is not a usable
matrix hypothesis in the convention employed by (3.5).  The established
graph convention has source coefficient (p^aB), coefficient forms (A),
and slope adjointness for (B^{-1}):

\[
 T^{\mathsf t}B^{-1}=B^{-1}T,
 \qquad\text{equivalently}\qquad BT^{\mathsf t}=TB.
\tag{A}
\]

Writing only ``(B)-self-adjoint'' is dangerous because the more usual
matrix convention is (T^{\mathsf t}B=BT), which is different for a
non-orthonormal unimodular block.  The correction is to define (A) at the
first use, then say that the finite-etale idempotents are self-adjoint for
that form and hence give the stated orthogonal splitting.  At line 78, call
(A=A^{\mathsf t}) a *symmetric coefficient bilinear form in this
normalization*.  Do not identify it with an arbitrary transpose-symmetric
endomorphism of a non-diagonal (B)-block.

There is a second, smaller scope gap.  Lines 53--54 keep (M_0) as one
unit block and impose no etaleness there, but then define (\delta_{ij}) and
state (3.3) as if scalar lifts (t_i) existed for every block.  The displayed
formula should be declared for (i,j>0); add separately

\[
 e_{0j}=a_j\qquad(j>0).
\tag{B}
\]

The proof of (3.3) then uses (T_i=t_i+p^{a_i}S_i) only where it has been
hypothesized.  Formula (B) is exactly what the off-diagonal integrality
blocks give, and retains the no-etaleness-on-(M_0) feature.

With (A)--(B), the computation in lines 73--99 gives

\[
 e_{ij}=\max\{a_i,a_j,a_i+a_j-v_p(t_j-t_i)\}
 \geq\max\{a_i,a_j\}\geq
 \left\lceil(a_i+a_j)/2\right\rceil
\]

on positive-depth split blocks.  This is the exact finite-etale,
block-respecting marked-presentation theorem.  It is not a condition on an
unmarked ppav or an arbitrary symplectic coordinate chart.

## 2. Rank-one and all-degree proof

Lines 106--137 are sound after the preceding normalization.  In particular,
the construction

\[
 p^t(p^ru+p^sv)(p^ru+p^sv)^{\mathsf t}
 -p^xuu^{\mathsf t}-p^yvv^{\mathsf t}
 =p^e(uv^{\mathsf t}+vu^{\mathsf t})
\]

uses no division by \(2\).  The parity choice exists because the interval
\(a_i\leq x\leq2e-a_j\) is nonempty and (x+(2e-x)) is even.  Unit multiples
are supplied by (O)-linearity.  Specify that (u,v) are coordinate vectors
in distinct split blocks and that a rank-one coefficient form is the actual
rank-one divisor class under the elliptic-power coefficient dictionary.

Lines 148--165 should replace their final two sentences by the exact flat
statement:

\[
 (P^k_{\rm gr}\otimes_OO')
 =\operatorname{im}\!\left(\operatorname{Sym}^k
 (N_{\rm gr}\otimes_OO')\longrightarrow H^{2k}\otimes_OO'\right).
\]

The (R_i) are coefficient-extended divisor classes, so (3.8) is an
(O')-linear combination of ordinary products, not a new collection of
descended line bundles.  Faithful flatness of (O'/O) then descends the
quotient of these two finite lattices.  This is denominator-free and works
at two.  The theorem remains cohomological; at CM points it concerns only
(N_{\rm gr}), as lines 168--173 correctly say.

## 3. Six-axis local Hodge calculation: what must be printed

The six-axis support types at lines 276--281 are correct, but the table is
not yet an exact lattice calculation.  Before (3.11), define (X_i,Y_i) as
a symplectic cohomology basis and write the *integral* divisor as

\[
 D_{ij}=p^{e_{ij}}\Omega_{ij},\qquad
 \Omega_{ij}=p^{-a_i-a_j}(t_j-t_i)X_iX_j
              +p^{-a_i}X_iY_j+p^{-a_j}X_jY_i.
\]

Calling (\Omega_{ij}) itself an ``off-diagonal divisor'' is false whenever
it has denominators.  State the actual dyadic ideals after the unramified
split:

\[
 e_{0i}=1,\quad e_{A_1A_2}=e_{B_1B_2}=1,\quad
 e_{A_iB_j}=2.
\tag{C}
\]

The printed table must say that its entries are **both the Hodge lattice and
the ordinary-product lattice**, with named bases.  The minimum required
content is:

* on (A_1A_2B_1B_2), (r_{AA\mid BB}) and (r_{AB\mid AB}) have
  scales (p^2,p^4); the former has no all-(X) term, the latter has a
  nonzero all-(X) term, so the latter cannot be lowered by adding the
  former;
* on (0A_iB_1B_2), and symmetrically (0B_iA_1A_2), the two named
  directions have scales (p^2,p^3), by the same leading-term argument;
* at three, for four primary slots and for (0) plus three primary slots,
  the two one-(Y) coefficient rows have a unit triangular minor at scale
  (p^2).  This is essential because the all-(X) argument is not the
  proof there.

The Pluecker relation has coefficients (\pm1), including at two, so those
two directions are a basis of the integral four-slot invariant lattice.  In
that form the result really is (I_J=P_J) on every support.  The current
``repeated-root matching'' mnemonic (lines 285--291) gives the outline but
does not exhibit the weights or rule out the remaining combination; this is
the first exact proof gap in the full-Hodge theorem.

The second proof gap is lines 257--262.  Add the literal integral
invariant/multidegree lemma: on a non-CM elliptic power, every multidegree is
of form \((2^{k-\ell},1^{2\ell})\); its integral invariant lattice is a
primitive diagonal-volume factor times the squarefree (2\ell)-slot
matching lattice, whose standard noncrossing matching basis has integral
Pluecker straightening.  Then state directly:

* \(\ell=0,1\) are product-saturated;
* in dimension five the only nontrivial \(\ell=2\) blocks are exactly the
  four-slot blocks above;
* in codimension three, \((2,2,2)\) and \((2,2,1,1)\) are saturated and
  \((2,1,1,1,1)\) is the primitive diagonal factor times a four-slot
  block;
* the degree-four and top multidegrees are directly saturated by the same
  primitive-volume argument.

This proves all degrees without Poincare duality and is the minimum
printable bridge from local four-slot data to (3.10).

## 4. The distinct-root proposition needs an exact hypothesis and Smith form

At line 307 add ``(E) is non-CM'' (or the equivalent exact diagonal
\(\mathrm{SL}_2\)-Hodge hypothesis).  Otherwise extra CM Hodge classes may
enlarge (I_A^k), and (3.13) is false as stated.  Also say ``one-depth
finite-etale marked graph presentation'' and retain ``after finite
unramified splitting.''

For each four-set (J), print the exact local two-matching lattices

\[
 I_J=O\,p^{3a}h_J\oplus O\,p^{4a}r_J,
 \qquad
 P_J=O\,p^{4a}h_J\oplus O\,p^{4a}r_J,
\tag{D}
\]

where a one-(Y) coefficient with a unit root difference is the pivot
establishing exactness.  The all-(X) cancellation alone proves existence
of (p^{3a}h_J), not that a second, lower Smith factor is absent.  Explain
that the five four-sets are direct slot-multidegree summands.  The primitive
volume factor on the complementary slot then gives the five independent
codimension-three summands, directly rather than by duality.

If the intended strengthened formulation includes it, add the compatible
assertion

\[
 \Theta\smile-:Q_A^2\xrightarrow{\sim}Q_A^3,
\]

whose split calculation is the complement map: its diagonal complementary
term is a unit and all remaining theta terms land in already product-
saturated multidegrees.  The current committed proposition establishes the
abstract equal quotients but does not state or prove this theta-complement
refinement.

## 5. Citation and priority hedge

The priority language is presently safe: it makes no ``first'' or
no-predecessor claim in the manuscript and keeps the C909 assertion narrower
than rational Lefschetz generation, Chow divided powers, and full integral
Hodge equality.  Keep that separation.

One concrete citation repair is needed at line 260: use
`\cite[Theorem~11.1]{DCEP}` for integral standard-monomial/Pluecker
straightening, and do not cite it as a source for the weighted graph Smith
calculation.  Line 102 correctly presents Yu only as the tropical valuation
shadow.  Lines 175--180 correctly label the Milne, Moonen--Polishchuk, and
Beckmann--de Gaay Fortman material as comparison/context, not as proofs of
the new ordinary-product assertion.

This is not a new novelty verdict.  Source records inherited for this
citation-scope check (two full texts) are:

| source | read depth / version / access / cache |
|---|---|
| De Concini--Eisenbud--Procesi, *Hodge algebras* | **full text**, Numdam scan, Astérisque 91 (1982), all 88 pages; especially §11, Theorem 11.1; key `AST_1982__91__1_0`, SHA-256 `fa857ea1c610f15d008f49e2b99966454ba4892b0a4d9bf34903e27731b8425f` |
| Yu, *The tropical positive semidefinite cone* | **full text**, arXiv `1309.6011v1`, all 5 pages; key `arXiv:1309.6011`, SHA-256 `ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6` |
| Milne, *Lefschetz classes on abelian varieties* | **partial**, author-hosted published PDF, Introduction and Theorem 3.2; key `10.1215/S0012-7094-99-09620-5`, SHA-256 `28ae245e58748438b7070680cac83f8b2f695c43f1643b59cde21eb94077fe53` |
| Moonen--Polishchuk, *Divided powers in Chow rings and integral Fourier transforms* | **partial**, arXiv `0904.3995v1`, Introduction and §3; key `arXiv:0904.3995`, SHA-256 `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4` |
| Beckmann--de Gaay Fortman, *Integral Fourier transforms and the integral Hodge conjecture for one-cycles on abelian varieties* | **partial**, arXiv `2202.05230v2`, abstract, Introduction, Theorems 1.1 and 3.8, Corollary 4.1; key `arXiv:2202.05230`, SHA-256 `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc` |

No source was searched anew, no citation graph was used, and no literature
negative is issued by this note.  The owning novelty rows remain the C909
cycle rows already recorded in the epilogue ledger and the authenticated
closure packet.

## Required repair order

1. Define the (B^{-1})-adjoint convention and repair the depth-zero clause;
   correct the missing `\geq`.
2. Tighten the coefficient-extension/faithfully-flat image-lattice sentence.
3. Print (C), the full four-support weighted matching table, and the
   leading/minor argument.
4. Print the integral multidegree/primitive-volume reduction.
5. Add non-CM and (D) to the distinct-root proposition; add theta complement
   only with its direct calculation.
6. Make the DCEP theorem locator exact.

After these repairs, the cycle-side integration is **GO**.  Until then,
the all-degree marked graph theorem is close but ambiguously normalized, and
the claimed six-axis Hodge equality is not yet supported by a complete
printed proof.

## EJ + TT closeout: the cheap proof compression

The useful surprise is that the six-axis repair has no dependency on the
unresolved arbitrary-rank filtered-web/jet Smith program.  In dimension five,
the direct multidegree decomposition has only \(\ell\leq2\): the only
nontrivial squarefree invariant component is four-slot.  Thus the proposed
literal invariant lemma plus the table in §3 is both a complete proof route
and shorter than any general web theorem.  This is the highest-value next
move: replace the present five-line assertion by that self-contained
two-page argument, rather than attempting a general all-rank formula.

There is no new structural theorem to extract from this audit.  The exact
remaining gate is purely presentational: display the two matching bases,
their weights, and their decisive leading/minor coefficients so that the
claimed local Smith equality is reproducible by hand.

## Mystery ledger

* **Settled:** the signed rank-one identity is valid over a DVR at (p=2)
  and does not use trace denominators or diagonalization of a unimodular
  (B)-block.
* **Settled:** the actual six-axis support list is exactly the dyadic
  (A_1A_2B_1B_2), (0A_iB_1B_2), (0B_iA_1A_2), and the two scalar
  three-adic types; there is no extra four-slot type.
* **Open only as a manuscript-proof obligation:** write the weighted
  two-matching/Hodge-lattice calculation and the multidegree reduction.  No
  new mathematical obstruction was found.
