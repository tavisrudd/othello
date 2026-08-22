# Hypothesis 4.7H evidence ledger

**Evidence audit for the red-team pass** · **Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

Audits the evidence base for Hypothesis 4.7H ("Reconstruction-displacement
invariance"), stated in
`papers/cubic-stabilization-m1/sections/04-one-step.tex` lines 409-425.
This is an audit, not an argument for or against the hypothesis.

Every evidence item and every attack carries four named fields: **PROVENANCE**
(file + line range or labelled statement; for imports, the pinned external source
and exact locator; and the dependency chain), **MECHANISM** (why a referee should
believe it, and what breaks it), **VALIDITY CLASS**, and **SCOPE DELTA** (what it
proves minus what the hypothesis needs). Evidence items additionally carry
**FRAME DATA**. Where I could not reconstruct a mechanism from the documents, the
item is marked `UNRECONSTRUCTED` and the missing part is named.

Validity classes used: `PROVED-UNCONDITIONAL`,
`PROVED-UNDER-STATED-HYPOTHESES`, `VERIFIED-COMPUTATIONALLY`,
`CONSISTENCY-CHECK-ONLY`, `ASSERTED-WITHOUT-PROOF`, `IMPORTED-UNVERIFIED`.

Contents: A the exact obligation · B positive evidence · C frame-alignment audit
· D attacks landed · E live attack surface · F what an independent proof needs.

---

## A. The exact obligation

### A.0 The hypothesis text (04-one-step.tex:409-425)

> Consider only the positive-filtration bulk displacements that occur in the
> arguments below: (1) after the unit term and the fixed divisor term are
> separated from the reconstruction coordinates in the blowup and
> projective-bundle decompositions used in Proposition~\ref{prop:framed-operations};
> and (2) in the divisor-tagging family used in Lemma~\ref{lem:divisor-tagging}.
> After the coefficient specialization displayed in the relevant construction,
> replacing zero bulk by any one of these positive-filtration bulk displacements
> does not change the algebraic multiplicities of \(e^{\pi i/3}\) and
> \(e^{-\pi i/3}\) in framed formal monodromy on the original \(z\)-disc.
>
> No invariance under an arbitrary bulk displacement is asserted.

What is asserted is equality of exactly two algebraic multiplicities. Not
equality of characteristic polynomials, not conjugacy of operators. Both
directions of the equality are consumed downstream (see A.6).

### A.1 What the machinery delivers without the hypothesis

`lem:formal-base-shift` (04-one-step.tex:270-304) is the unconditional engine.
Given a bulk coordinate \(a_0\mathbf 1+a_2^\circ+\eta\) with
\(a_2^\circ\in H^2(T)\otimes F^0B\), \(\eta\in F^1B\widehat\otimes H^{\rm ev}(T)\),
it produces a normalized pro-Laurent gauge \(G\) killing \(\eta\) and concludes
only (lines 300-303):

> conjugating the divisor-substituted small framed matrix through \(G\) defines a
> comparison-transported matrix. Its characteristic polynomial is equal to the
> divisor-substituted small framed characteristic polynomial in
> \(\widetilde{\mathscr L}_{B,F}[X]\).

This is an algebraic conjugacy statement in a **nonfield** pro-Laurent algebra,
disclaimed as more at 04-one-step.tex:248-250 ("No assertion about intrinsic
framed monodromy over the nonfield inverse-limit algebra is made here") and again
at 364-367 ("the inverse-limit gauge need not lie in a Laurent-series field over
which Levelt--Turrittin theory is available"). The gap is stated verbatim at
04-one-step.tex:367-370:

> In the applications below, identifying the comparison-transported matrix with
> the intrinsic framed operator at the positive-filtration bulk point is exactly
> the content of Hypothesis 4.7H.

**The obligation is an identification of two objects, not a continuity statement
about one object.** Object 1: the comparison-transported matrix
\(GM^{\rm small,shifted}_{\mathrm f,V}G^{-1}\) over
\(\widetilde{\mathscr L}_{B,F}\). Object 2: the intrinsic framed operator at the
displaced bulk point, defined by `def:framed-sixth-multiplicity` over a universal
exponential field. 4.7H says their primitive-sixth multiplicities agree.

### A.2 Use site (1a): blowup, centre summands

Proof of `prop:framed-operations`, 04-one-step.tex:459-639.

- **Displacement element.** (4.4) at lines 477-483:
  \(\varsigma_j=\varsigma_j^\circ+s_j\),
  \(\varsigma_j^\circ=-(c-1)\lambda_j+h_{C,j}+O(u)\), \(u=q^{-1/(c-1)}\).
  After the unit twist \(-(c-1)\lambda_j\) (line 530-531) and the fixed divisor
  \(h_{C,j}\) (line 629-632) are removed, the residual displacement is the
  \(O(q^{-1/(c-1)})\) tail **plus** the bulk directions \(s_j\).
- **Ring.** \(R_j\) = image of \(Q_C^d\mapsto Q^{i_*d}u^{\rho_C\cdot d}\) with
  \(u\) and \(s_j\) adjoined;
  \(J_j=(u,\{Q^{i_*d}u^{\rho_C\cdot d}:d\ne0\},\text{components of }s_j)\);
  \(B_j=\varprojlim_N R_j/J_j^N\), \(F^NB_j=\ker(B_j\to R_j/J_j^N)\)
  (lines 484-494).
- **Filtration degree.** \(\ge1\), not a pure degree: lines 523-527 assert the
  residual target bulk coordinate "lies in \(J_jH^*(C)\)", and \(u\) and every
  component of \(s_j\) get weight 1 (line 508).
- **Specialization consumed.** \(\nu_6(C;\chi_j)\), \(\chi_j\) the numerical
  Novikov specialization of the \(j\)-th centre summand (lines 444-446).
- **Invariance consumed**, verbatim (lines 633-637): "Hypothesis 4.7H identifies
  the primitive-sixth multiplicities at the resulting positive-filtration bulk
  point with those at zero bulk, after the displayed centre specialization."

### A.3 Use site (1b): blowup, ambient summand

04-one-step.tex:637-638, one sentence: "The same applies to the ambient summand,
which uses \(\tau=\tau^\circ+t\) with \(\tau^\circ=O(q^{-1})\)." The concrete
element is Iritani's \(\tau^\circ=q^{-1}[Z]+O(q^{-2})\) (Theorem 5.18(6)). No
separate ring or filtration is displayed; (4.4a) at lines 547-552 refers to "the
analogous scaled components on the ambient summand" without writing them.
**Thinnest-documented use site in the manuscript.**

### A.4 Use site (1c): projective bundle

04-one-step.tex:652-796.
\(\varsigma_j^\circ=r\lambda_j-\tfrac{2\pi i j}{r}c_1(V)+O(u)\), \(u=q^{-1/r}\)
(lines 690-697). \(R_j\) = image of \(Q_T^d\mapsto Q^du^{c_1(V)\cdot d}\) with
\(u,s_j\); same \(J_j,B_j,F^\bullet\) (lines 657-667). Filtration \(\ge1\) via
Iritani--Koto Proposition 5.6 (lines 686-689). Invariance consumed at lines
773-776.

### A.5 Use site (2): divisor tagging

Proof of `lem:divisor-tagging`, 04-one-step.tex:837-954.

- **Displacement element.** (4.6) at lines 844-849:
  \(\chi_{\boldsymbol t}(Q^d)=\chi(Q^d)\exp(\sum_i t_i(D_i\cdot d))\), the \(D_i\)
  integral divisors whose pairings separate \(N_1(T)\).
- **Ring.** \(B=k_\chi[[\boldsymbol t]]\),
  \(k_\chi=\overline{\operatorname{Frac}A}\) (lines 894, 922-923), \(A\) the
  target of a strictly Novikov-admissible \(\chi\) (`def:strict-novikov-admissible`,
  lines 804-815: complete separated valued domain with domain associated graded).
- **Filtration degree — the only place a degree is named.** Lines 920-923: "the
  **degree-two** positive-filtration bulk pullback of the \(\chi\)-specialized
  module". Applied with \(a_0=0\), \(a_2^\circ=0\), so (4.1) is the identity here
  (lines 924-927).
- **Invariance consumed** (lines 929-933): identifies the multiplicities in
  \(p^{\rm tag}\) with those encoded by \(p^{\rm spec}\).
- Surviving unconditional half: (4.6a) \(p^{\rm tag}=p^{\rm int}\), lines 910-919.

### A.6 Are the use sites one statement? No — three instances, of two difficulty classes

Common schema: bulk coordinate \(a_0\mathbf 1+a_2^\circ+\eta\) with \(\eta\in F^1\),
base-shift gauge \(G\) killing \(\eta\), assertion that primitive-sixth
multiplicity is unchanged. Differences that decide whether evidence transfers:

1. **Base ring.** Tagging: \(k_\chi[[\boldsymbol t]]\), formal power series over an
   *algebraically closed field*. Reconstruction: \(B_j=\varprojlim R_j/J_j^N\)
   with \(R_j\) a Novikov monoid image ring — not a field, which is why
   `rem:pro-laurent-concrete` and the Hahn receiver (4.4c) exist at all.
2. **Displacement shape.** Tagging: \(\eta=\sum t_iD_i\), purely cohomological
   degree two, linear in genuinely formal parameters. Reconstruction:
   \(O(u)+s_j\) mixes a Novikov tail in \(u=q^{-1/(c-1)}\) (or \(q^{-1/r}\)) with
   bulk components \(s_j\) ranging over all of \(H^*(C)\) resp. \(H^{\rm ev}(T)\).
3. **Deformability.** \(\boldsymbol t\) is an honest deformation parameter with a
   \(t=0\) endpoint; the \(O(u)\) tail is a fixed geometric quantity with no
   deformation family of its own.
4. **What sits on the other side.** Tagging compares \(p^{\rm tag}\) with
   \(p^{\rm spec}\) over one \(k_\chi\)-receiver. Reconstruction compares a matrix
   in \(\mathscr R_j\) with the intrinsic invariant of a *different variety* \(C\).

**Direction of use.** `lem:divisor-tagging` consumes 4.7H in the direction
"intrinsic count zero \(\Rightarrow\) specialized count zero", i.e. an upper
bound on the specialized count. (4.2) and (4.3) are equalities and are consumed
in both directions by `thm:nu6-birational-invariance`. This matters because the
endpoint argument as re-derived in `section10-hostile-referee.md` needs only a
**lower** bound ("only a **lower** bound is needed: if the two cubic-type blocks
keep their exponents at \(\hat\tau_L\) then \(\nu_6\ge4>0\) and the contradiction
closes"). **The manuscript's uses of 4.7H are strictly stronger than what the
endpoint theorem needs.**

---

## B. Positive evidence

### B1. Comparison isomorphisms are outside the gap (Lemma 4.1A)

- **STATEMENT.** Iritani's \(\Psi\) and Iritani--Koto's \(\Phi\), and their
  inverses, use only integral powers of \(z\); hence they lie in
  \(\mathrm{GL}_n(F((z)))\) for the Laurent coefficient field \(F\), the turn
  fixes them, and framed monodromy transports across them with no receiver
  machinery.
- **PROVENANCE.** Manuscript Lemma 4.1A (inserted after Definition 4.1;
  `2026-08-15-c912-hypothesis-4-7h-conditionalization.md` lines 64-74) and its
  applications at 04-one-step.tex:452-455, 467-468, 627-629, 771-773. Source
  reading: `2026-08-15-c912-framing-compatibility-checks.md` §2 finding 1d
  (lines 120-134). Imports, pinned in that file's §1 table: Iritani, *Quantum
  cohomology of blowups*, arXiv 2307.13555 v3, Theorem 5.18 (cached PDF SHA-256
  `c16f56b2…a934b`); Iritani--Koto, *Quantum cohomology of projective bundles*,
  arXiv 2307.03696 v4 dated 31 Jan 2026, Theorem 5.1(6) (SHA-256
  `5139f8e0…b57624`).
  Chain: **Iritani Thm 5.18 / IK Thm 5.1(6) (\(z\)-integrality) → Lemma 4.1A →
  removes the comparison step from the obligation**, leaving the bulk gauge as
  the sole residue.
- **MECHANISM.** The turn \(\sigma\) acts on \(z\) only and fixes the coefficient
  field pointwise, so \(\sigma(G)=G\) for any \(G\in\mathrm{GL}_n(K((z)))\); then
  \(\sigma(GY)=G\sigma(Y)=(GY)M_{\mathrm f}\), so the framed matrix is unchanged
  in the transported frame. Breaks if the map used a fractional power of \(z\),
  or if it were not invertible in the same ring.
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL` for the lemma;
  `IMPORTED-UNVERIFIED` for the source \(z\)-integrality at this audit's level —
  read at the locator by `framing-compatibility-checks.md`, not re-read here.
  **Correction on record:** `section10-hostile-referee.md` COSMETIC bullet 1 —
  \(\Psi,\Phi\) are *power series* in \(z\) (Iritani Remark 1.5:
  \(\mathbf C[q^{\pm1/s}][[Q,\tilde\tau]][[z]]\); IK Remark 5.3), not polynomial;
  judged "harmless for the transport theorem — a unit of \(\Omega[[z]]\) is still
  fixed by the turn". The manuscript says "only integral powers of \(z\)", which
  is the property actually needed, so the manuscript is not damaged; the memo's
  "polynomial in \(z\)" wording is.
- **FRAME DATA.** Loop frame: unsheared, integral \(z\)-powers, original
  \(z\)-disc. Base point: none — it is a statement about the maps, valid over the
  whole formal base \(\mathbf C[z]((q^{-1/s}))[[Q,\tilde\tau]]\). Novikov roles:
  \(q\) inverted (unit), \(Q\) and \(\tilde\tau\) formal. Parity: even
  connections only, which the manuscript checks separately (04-one-step.tex:786-795).
- **SCOPE DELTA.** Discharges the comparison-transport half of the old blocker.
  It discharges **none** of 4.7H: the residual bulk gauge is exactly what remains
  (`framing-compatibility-checks.md` §5).

### B2. The residual gap, stated exactly (a scoping result, not evidence for)

- **PROVENANCE.** `2026-08-15-c912-framing-compatibility-checks.md` §5, lines
  197-209, quoted verbatim in A of this ledger's companion reading:

  > Let `T` be smooth projective, `∇` its quantum connection, `τ^•` a bulk
  > parameter lying in the positive filtration — `τ^∘ = q^{-1}[Z] + O(q^{-2})` on
  > the ambient summand (Iritani Theorem 5.18(6)), the `O(q^{-1/(c-1)})` tail of
  > `ς_j^∘` plus `s_j` on a centre summand. Show that the framed formal monodromy
  > of `∇|_{τ = τ^•}` has the same primitive-sixth multiplicity as `∇|_{τ = 0}`.
  >
  > Everything else in `prop:framed-operations` is either proved or reduced to a
  > regular gauge. `lem:divisor-tagging` inherits the same single gap and nothing
  > else.

- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL` as a reduction (it is the
  conjunction of B1 with the manuscript's own accounting).
- **SCOPE DELTA.** None claimed; this is the target statement, restated.

### B3. Simple blocks carry nothing

- **STATEMENT.** Every multiplicity-one block of \(E\star\) has zero residue,
  trivial framed monodromy, and contributes nothing to \(\nu_6\); hence \(\nu_6\)
  is carried entirely by coalesced blocks.
- **PROVENANCE.** `notes/2026-08-15-c912-frame-transport-memo.tex`,
  `thm:simple-blocks` lines 1009-1037 and `cor:coalesced-only` lines 1039-1043.
  Independently re-derived as Lemma "the pairing kills simple blocks" in
  `2026-08-15-c912-framing-compatibility-checks.md` §6 item 3 ("now proved").
  Chain: **Frobenius property of \(\star\) → \(U\) self-adjoint, \(\mu\)
  anti-self-adjoint → \(\mu_i=P_i\mu P_i\) anti-self-adjoint → \(\mu_i=0\) in
  rank one → simple blocks invisible → only coalesced blocks need control**.
- **MECHANISM.** \((a\star b,c)=(a,b\star c)\) makes \(U=E\star\) self-adjoint for
  the Poincaré pairing, so distinct generalized eigenspaces are orthogonal and the
  pairing restricts nondegenerately to each; the pairing is nonzero only in
  complementary cohomological degrees, so \(\mu\) is anti-self-adjoint; an
  anti-self-adjoint operator on a one-dimensional space is zero. Then formal
  decoupling adds only \(z^{\ge1}\) terms to a scalar block (the \(z^0\)
  contribution \(-[g_1,U]_{ii}=[U_i,g_{1,ii}]=0\) in rank one), so the solution is
  \(e^{-u_i/z}\) times a single-valued formal unit. Breaks if the pairing failed
  to restrict nondegenerately, i.e. if the eigenspaces were not orthogonal.
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL`.
- **FRAME DATA.** Loop frame: unsheared, \(z^2\partial_z Y=(U-z\mu)Y\). Base
  point: any point at which the block decomposition exists — the argument is
  pointwise and uses no germ. Novikov roles: irrelevant; the statement is about
  the pairing. Parity: even connection.
- **SCOPE DELTA.** Reduces the class of blocks the hypothesis must control, from
  all blocks to coalesced blocks. It proves nothing about displacement invariance
  of a coalesced block.

### B4. Block evolution: \(D_aU_i=C_{a,i}+[C_{a,i},\mu_i]\)

- **PROVENANCE.** memo `lem:flatness-ids` lines 903-915 and `thm:block-evolution`
  lines 936-984. Chain: **flatness \([\nabla_a,\nabla_{z\partial_z}]=0\) →
  \([U,C_a]=0\) and \(\partial_aU=C_a+[C_a,\mu]\) → Kato block frame →
  \(D_aU_i=C_{a,i}+[C_{a,i},\mu_i]\) → input to `thm:no-splitting` (B6)**.
- **MECHANISM.** Expand \([\nabla_a,\nabla_{z\partial_z}]=0\): the \(z^{-2}\)
  term is \([U,C_a]\), zero by commutativity and associativity of \(\star\); the
  \(z^{-1}\) term gives \(\partial_aU=C_a+[C_a,\mu]\). Compressing by
  \(P_i(\cdot)P_i\) in Kato's frame, \(C_a\) commutes with \(P_i\) so the first
  term is \(C_{a,i}+[C_{a,i},\mu_i]\), and \(U\) commutes with \(P_i\) so
  \(P_i[U,T_a]P_i=[U_i,P_iT_aP_i]=0\). The memo notes explicitly: "No perturbation
  formula is used, so this identity holds whatever the nilpotent parts."
- **VALIDITY CLASS.** `PROVED-UNDER-STATED-HYPOTHESES` — the theorem's standing
  assumption is that "the eigenvalues \(u_j\) of \(U\) are pairwise distinct as
  scalars, so that each difference \(u_i-u_j\) is invertible" (line 938-939).
- **FRAME DATA.** Unsheared; Kato block frame; \(\mu\) constant; no base point
  needed. Sign convention: memo's \(\nabla_{z\partial_z}=z\partial_z-z^{-1}U+\mu\),
  \(z^2\partial_zY=(U-z\mu)Y\).
- **SCOPE DELTA.** Gives the exact motion of the block leading operator; gives
  **no** control of the exponents, because the compressed pair \((U_i,\mu_i)\)
  does not determine them (see D1, the regression test).
- **CAUTION on record.** memo `rem:sylvester-correction` lines 986-1001: the
  companion clean form \(D_a\mu_i=[C_{a,i},S_i]\) is valid only when the block
  itself is semisimple — an error in an earlier version, corrected. The blocks
  carrying \(\nu_6\) are exactly the ones where it fails.

### B5. The decoupling gauge is a Poincaré isometry

- **PROVENANCE.** memo `lem:duality-gauge` lines 1358-1388; independently derived
  as Lemma 1 of `2026-08-15-c912-det-r-pairing-and-serre-lattice.md` §1 (lines
  54-78). Chain: **Frobenius + degree-complementarity → duality relation
  \(\mathcal A(-z)^TG+G\mathcal A(z)=0\) → uniqueness of the normalized decoupling
  gauge → \(g(-z)^TGg(z)=G\) → parity rule (8.5) → `thm:h2-automatic` (B7)**.
- **MECHANISM.** Define the involution \(\sigma:\mathcal A\mapsto
  -G^{-1}\mathcal A(-z)^TG\); a direct computation gives
  \((g\cdot\mathcal A)^\sigma=h\cdot(\mathcal A^\sigma)\) with
  \(h=G^{-1}g(-z)^{-T}G\). Since the generalized eigenspaces of a
  \(G\)-self-adjoint operator are \(G\)-orthogonal, \(G\) is block diagonal and
  \(\widetilde{\mathcal A}^\sigma\) is block diagonal whenever
  \(\widetilde{\mathcal A}\) is; and \(h=I+O(z)\). So \(h\) is a second normalized
  gauge achieving block-diagonalization, and **uniqueness of the decoupling gauge
  forces \(h=g\)**, which is the isometry claim. Breaks if the decoupling gauge
  were not unique, or if \(G\) failed to restrict nondegenerately to a block.
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL` (given `lem:decouple`'s uniqueness,
  which holds because the eigenvalue differences are units — (H1)'s second
  clause).
- **FRAME DATA.** Unsheared, before the shear of Step 4; the twist by
  \(\exp(u_0/z)\) is shown insensitive because the subtracted term is odd in \(z\)
  and self-adjoint. Base point: pointwise on \(B=\Lambda[[\tau]]\).
- **SCOPE DELTA.** Infrastructure; discharges nothing on its own.

### B6. No splitting: \(\det N\equiv0\) on the formal germ

- **STATEMENT.** For a rank-two coalesced block, the nilpotent part stays
  nilpotent at every point of the formal bulk germ, so the block keeps one
  eigenvalue of multiplicity two and stays a single Jordan block.
- **PROVENANCE.** memo `thm:no-splitting` lines 1248-1276. Chain: **B4 →
  \(D_aN=q_aN+q_a[N,\mu_0]\) → \(\partial_a d=2q_ad\) for \(d=\det N\) → lowest
  homogeneous order argument → \(d\equiv0\) → the falsifier of `sec:not-yet`
  (the block cannot split) is answered on the germ**.
- **MECHANISM.** For a traceless \(2\times2\) matrix, \(\operatorname{adj}(N)=-N\)
  and \(N^2=-dI\); therefore
  \(\partial_ad=\operatorname{tr}(\operatorname{adj}(N)D_aN)
  =-q_a\operatorname{tr}(N^2)-q_a\operatorname{tr}(N[N,\mu_0])=2q_ad\), the second
  trace vanishing by cyclicity. If \(d\ne0\), its lowest nonzero homogeneous part
  \(d_m\) (\(m\ge1\), since \(d(0)=0\) by (H1)) satisfies \(\partial_ad_m=0\) for
  every \(a\), forcing \(d_m=0\) — contradiction. \(d\) is basis independent, so
  no block frame enters. Breaks if \(d(0)\ne0\), i.e. if (H1) fails at the base
  point.
- **VALIDITY CLASS.** `PROVED-UNDER-STATED-HYPOTHESES` — (H1), memo lines
  1174-1178: "\(U(0)\) has an eigenvalue \(u_0\) whose generalized eigenspace
  \(H_0\) has rank two and on which the nilpotent part is nonzero; every other
  eigenvalue differs from \(u_0\) by a unit of \(\Lambda\)."
  Independently recomputed: `section10-hostile-referee.md` R4 —
  "\(\mathrm{adj}(N)=-N\) and \(N^2=-dI\) for traceless \(2\times2\);
  \(\mathrm{tr}(N[N,\mu_0])=0\) by cyclicity; so \(\partial_ad=2q_ad\) with
  \(d(0)=0\), and the lowest-order argument gives \(d\equiv0\). Correct."
- **FRAME DATA.** Loop frame: unsheared decoupled block, \(z^{-1}N+A_0'+zA_1'+\cdots\).
  Base point: \(\tau=0\) on the formal even bulk germ \(B=\Lambda[[\tau]]\), with
  \(\Lambda\) the coefficient field of the small connection containing
  \(r=(3q)^{1/2}\) — so \(q\) is a **unit** with a square root adjoined, and
  \(\tau\) is the formal-nilpotent direction. Parity: even connection.
- **SCOPE DELTA.** Proves the block does not split, for **rank-two nonderogatory
  coalesced blocks satisfying (H1), at points of the formal bulk germ**. 4.7H
  needs the multiplicity fixed for **arbitrary block type, at the displaced
  reconstruction point, for every centre \(C\) and every intermediate variety of
  a weak factorization**. Missing: \(m\ge3\), derogatory, and semisimple-coalesced
  blocks (see B10), and the passage from germ to displaced point (see C-J1).

### B7. The sheared block is regular singular ((H2) is automatic)

- **PROVENANCE.** memo `thm:h2-automatic` lines 1404-1417; independently derived
  as Theorem 2 of `det-r-pairing-and-serre-lattice.md` §2 (lines 94-118), ledger
  row C912-M23 `resolved`. Chain: **B5 (isometry) → parity rule (8.5)
  \(N^TG_0=G_0N\), \((A_p')^TG_0=(-1)^{p+1}G_0A_p'\) → B6 (\(N^2=0\)) →
  \(\operatorname{im}N\) isotropic → \(f=(A_0')_{21}=0\)**.
- **MECHANISM.** \(N\) is \(G_0\)-self-adjoint and \(N^2=0\), so
  \((Nx,Ny)=(x,N^2y)=0\): the image of \(N\) is isotropic, hence \((e_1,e_1)=0\)
  and nondegeneracy forces \((e_1,e_2)\ne0\). \(A_0'\) is \(G_0\)-anti-self-adjoint,
  which for a symmetric form gives \((A_0'x,x)=0\) for all \(x\); taking \(x=e_1\)
  and expanding \(A_0'e_1=\alpha e_1+fe_2\) gives \(f(e_2,e_1)=0\), hence \(f=0\).
  Breaks if the Frobenius property is unavailable (a non-quantum connection), in
  which case the memo's fallback is the differential route \(\partial_af=fw_a\)
  with \(f(0)=0\) carried as a hypothesis (memo `remark` lines 1458-1466).
- **VALIDITY CLASS.** `PROVED-UNDER-STATED-HYPOTHESES` — (H1) only; **pointwise**,
  with no germ and no differential equation. This is a genuine strengthening over
  earlier memo versions, which assumed it (memo lines 1182-1189).
- **FRAME DATA.** Proved on the unsheared decoupled block; consumed to show the
  **sheared** frame \(S=\operatorname{diag}(1,z)\) has no pole. The bridge is the
  shear bookkeeping at memo lines 1288-1307, \(A_{-1}=fE_{21}\).
- **SCOPE DELTA.** Rank two only. `prop:size-m-duality` (memo lines 1809-1837)
  shows the same duality kills only the deepest sub-diagonal for \(m\ge3\).

### B8. No irregularity, and rigidity of the formal type

- **STATEMENT.** \(k_a\equiv0\), so the sheared bulk connection has no \(z\)-pole;
  and \(\partial_aR=[R,G_a]\), so \(\det(XI-R)\) is constant in \(\tau\) and the
  primitive-sixth multiplicity of the block is constant on the germ.
- **PROVENANCE.** memo `thm:no-irregularity` lines 1427-1456 and `thm:rigidity`
  lines 1470-1487. Chain: **B7 (\(f\equiv0\)) → \(k_a=fh_a\equiv0\) →
  \(A_{-1}=K_a=0\) → the \(z^0\) coefficient of flatness collapses to
  \(\partial_aR=[R,G_a]\) → \(\partial_a\det(XI-R)=0\) → constant exponents mod
  \(\mathbf Z\) → constant \(\nu_6\) on the germ**.
- **MECHANISM.** Expanding the flat-pair identity (8.1) for the sheared pair: the
  \(z^{-2}\) coefficient is vacuous; the \(z^{-1}\) coefficient, compared on the
  diagonal, gives \(k_a\nu=-f([E_{21},G_a])_{11}\) with \(\nu\) a unit, hence
  \(k_a=fh_a\); with \(f\equiv0\) from B7 this gives \(k_a\equiv0\). Then the
  \(z^0\) coefficient is \(\partial_aA_0=[A_{-1},H_a]+[A_0,G_a]+[A_1,K_a]\), which
  collapses to \(\partial_aR=[R,G_a]\). A matrix moving by infinitesimal
  conjugation has constant characteristic polynomial because
  \(\operatorname{adj}(XI-R)\) is a polynomial in \(R\), so the derivative of the
  determinant is a trace of a commutator. Breaks if \(f\not\equiv0\) or if the
  bulk connection retained a pole after shearing.
- **VALIDITY CLASS.** `PROVED-UNDER-STATED-HYPOTHESES` — (H1). Independently
  recomputed in `section10-hostile-referee.md` R4: "I re-derived
  \([R,E_{21}]=\begin{pmatrix}\nu&0\\\delta-\alpha&-\nu\end{pmatrix}\) and the
  \(z^{-1}\) flatness coefficient ... Correct, and the \((2,2)\) comparison is
  consistent because a commutator is traceless"; and "\(\partial_aR=[R,G_a]\) and
  \(\mathrm{adj}(XI-R)\) is a polynomial in \(R\), so
  \(\partial_a\det(XI-R)=0\). Correct."
- **FRAME DATA.** **Sheared** frame \(S=\operatorname{diag}(1,z)\); the residue is
  \(R\) of (8.2). Base point \(\tau=0\) on \(B=\Lambda[[\tau]]\). Exponent
  bookkeeping: "shearing changed the exponents by integers only, which \(\nu_6\)
  does not see" (line 1485-1486) — valid because \(\operatorname{Exp}_V(\rho)
  =e^{2\pi i\rho}\) is \(\mathbf Z\)-periodic.
- **SCOPE DELTA.** Proves \(\tau\)-constancy of the primitive-sixth count for
  rank-two coalesced blocks on the formal bulk germ. 4.7H needs it at the
  displaced reconstruction point. The corollary that bridges these is attacked;
  see D8 and C-J1.

### B9. The cubic block numbers, and their agreement with the manuscript

- **PROVENANCE.** memo lines 1322-1334 (\(\nu=2\), \(A_0'=D_0=\operatorname{diag}(-19/18,19/18)\),
  \((A_1')_{21}=-8/81\), giving \(f=0\),
  \(R=\begin{pmatrix}-19/18&2\\-8/81&1/18\end{pmatrix}\),
  \(\operatorname{tr}R=-1\), \(\det R=5/36\), char. poly. \(\rho^2+\rho+5/36\),
  roots \(-1/6,-5/6\)). Manuscript side: 04-one-step.tex:1139-1140 (\(D_0\),
  \(E_0=\begin{pmatrix}0&-14/(81r^2)\\-8/81&0\end{pmatrix}\)), 1250-1256
  (\(L_s=\begin{pmatrix}s+19/18&-2\\8/81&s-1/18\end{pmatrix}\),
  \(\det L_s=(s+\tfrac16)(s+\tfrac56)\)), 1188 (\(\rho=-\tfrac16,-\tfrac56\)),
  1276 (\(\nu_6(X)=2\), unconditional per line 1058).
- **MECHANISM / cross-check performed in this audit.** \(L_s=sI-R\) exactly:
  \(\det(sI-R)=\begin{vmatrix}s+19/18&-2\\8/81&s-1/18\end{vmatrix}=L_s\), and
  \((\rho+\tfrac16)(\rho+\tfrac56)=\rho^2+\rho+\tfrac5{36}\). So the memo's sheared
  residue and the manuscript's Frobenius recursion are the **same object in the
  same normalization**; the manuscript's ansatz
  \(\widetilde S_3=z^\rho\sum a_nz^n\), \(\widetilde S_4=z^{\rho+1}\sum b_nz^n\)
  (line 1243-1244) already carries the shear implicitly, in the relative \(z^1\).
- **VALIDITY CLASS.** `VERIFIED-COMPUTATIONALLY` at the arithmetic level —
  recomputed independently in `section10-hostile-referee.md` R4
  ("\(\mathrm{tr}R=-19/18+1/18=-1\) and \(\det R=-19/18\cdot1/18+2\cdot8/81
  =-19/324+16/81=45/324=5/36\) ... Arithmetic verified") and again in this audit.
  The manuscript's \(\nu_6(X)=2\) is `PROVED-UNCONDITIONAL` (04-one-step.tex:1058).
- **FRAME DATA / normalization check.** Exponents \(-1/6,-5/6\) give monodromy
  \(e^{-\pi i/3}\) and \(e^{-5\pi i/3}=e^{\pi i/3}\) — both primitive sixth roots,
  \(\nu_6=2\). Cai's Proposition 6 states \(\rho\equiv\pm1/6\bmod\mathbf Z\)
  (`section10-hostile-referee.md` R5, quoting Cai3 lines 494-503); \(-1/6\equiv
  -1/6\) and \(-5/6\equiv+1/6\), so the two statements agree exactly.
  **Discrepancy found, minor:** `framing-compatibility-checks.md` §6 item 3 writes
  "the draft's indicial roots \(1/6\) and \(5/6\)" — a dropped sign relative to
  the manuscript's (4.9i) \(\rho=-1/6,-5/6\). The monodromy multiset
  \(\{e^{\pi i/3},e^{-\pi i/3}\}\) is conjugation-closed, so \(\nu_6=2\) either
  way; the note's transcription is nonetheless wrong and should be corrected.
- **SCOPE DELTA.** Fixes the value at one point (the small/intrinsic point) for
  one variety. Says nothing about displacement.

### B10. What Section 8 does NOT cover — the memo's own scope statement

- **PROVENANCE.** memo `sec:jordan-size`, lines 1728-1876.
- **\(m\ge3\):** Steps 1-3 extend (`prop:size-m-steps`, lines 1741-1791: commutant
  is \(B[N]\), all power traces vanish by Newton's identities plus the same
  lowest-order argument, so the block stays a single Jordan block). Step 5 does
  not: `prop:size-m-duality` lines 1809-1837 shows the reflection preserves each
  sub-diagonal and conjugation by \(P\) acts trivially only on the deepest one, so
  duality kills \((A_p')_{m1}\) for even \(p\) and nothing else. Verbatim, lines
  1839-1844: "duality removes exactly one pole coefficient, the deepest ... for
  \(m\ge3\) it is one condition out of a growing family. The expectation that the
  rank-two mechanism extends as it stands was therefore too optimistic at exactly
  this step". Proposed replacement (the \(\mu\)-grading, since \([\mu,U]=U\) makes
  \(N\) raise \(\mu\)-weight by one) is explicitly **not carried out**: "What must
  be supplied ... is that the decoupling gauge of Step 1 respects the grading on
  the zero block ... that triangular structure is a computation this memo has not
  done" (lines 1858-1870). **VALIDITY CLASS for \(m\ge3\): `ASSERTED-WITHOUT-PROOF`
  (as a programme), with Steps 1-3 `PROVED-UNDER-STATED-HYPOTHESES`.**
- **Derogatory blocks:** "the commutant is larger than \(B[N]\) and
  Proposition 8.9 fails at its first step" (lines 1872-1874). Not covered.
- **Semisimple coalesced blocks:** "the \(z^{-1}\) equation instead reads
  \((I+\operatorname{ad}_R)(C_{a,0}-p_aI)=0\) and a **resonance**
  \(\rho_i-\rho_j=-1\) must be excluded before the same conclusion follows"
  (lines 1874-1876). Not excluded anywhere in the audited set.

### B11. The \(H^0\) part of any displacement is exactly invariant (string equation)

- **PROVENANCE.** `2026-08-15-c912-section10-hostile-referee.md`, second pass,
  "The string equation is exact here, and needs no smallness". Also used by the
  manuscript for the unit term, 04-one-step.tex:307-311.
- **MECHANISM.** The string equation gives
  \(\langle1,\gamma_1,\dots,\gamma_n\rangle_{0,n+1,d}=0\) except for
  \((n+1,d)=(3,0)\), so \(\star_{\tau+c\mathbf1}=\star_\tau\) identically, for any
  \(c\) in the coefficient ring, with no substitution and no convergence. The
  Euler field gains exactly \(c\mathbf1\), so \(E\star_{\tau+c1}=E\star_\tau+c\,\mathrm{id}\);
  adding a scalar to \(U\) translates every exponential factor by the same \(c/z\)
  and leaves every spectral projector, block and residue untouched. Nothing breaks
  it — it is an identity, not an estimate.
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL`. The referee marks it as the one
  place where "exact and needs no smallness" is literally true.
- **FRAME DATA.** Any frame; any base point; \(c\) may be a unit of the Novikov
  ring (this is the point — no nilpotence is required).
- **SCOPE DELTA.** Disposes of the \(H^0\) component of the displacement, in all
  three reconstruction use sites. Leaves the \(H^2\) component (handled separately
  by the divisor substitution, B13) and the \(H^{\ge4}\) tail plus \(s_j\)
  (untouched — this is the live part of the obligation).

### B12. For \(X\times\mathbf P^1\) the whole reconstruction displacement is an \(H^0\) shift (Claim A)

- **STATEMENT.** For \(V=\mathcal O_B^{\oplus r}\), \(\varsigma_j^\circ=r\lambda_j\)
  **exactly** — no \(H^2\) term, no \(H^{\ge4}\) tail. Combined with B11 this gives
  \(\nu_6(X\times\mathbf P^1,\hat\tau=0)=4\) with no use of 4.7H.
- **PROVENANCE.** `section10-hostile-referee.md`, second pass, CLAIM A: SURVIVES.
  Imports, with locators as recorded there: Iritani--Koto arXiv 2307.03696,
  §5.3 stationary phase (IK text lines 2451-2540), the QRR asymptotic (lines
  1285-1290), \(\lambda_j=e^{2\pi ij/r}q^{1/r}\) (line 2354), (5.11) (line 3251).
  Chain: **trivial \(V\) → all Chern roots vanish → \(\widetilde\Delta^\lambda_V\)
  is a scalar with only non-negative \(z\)-powers → \(F_j(1)\) is a scalar →
  \([z^{-1}]\log(q^{c_1(V)/(rz)}F_j(1))=0\) → IK (5.11) gives
  \(\varsigma_j^\circ=r\lambda_j\) → B11 → \(\nu_6(X\times\mathbf P^1,0)=4\)**.
- **MECHANISM, proof 1.** For a trivial bundle every Chern root is \(0\), so the
  modified QRR operator is a scalar function of \((\lambda,z)\) containing no
  class of \(B\); Stirling gives it as an exponential of
  \(\sum_{n\ge1}\frac{B_{2n}}{2n(2n-1)}\lambda^{1-2n}z^{2n-1}\), i.e. strictly
  non-negative \(z\)-powers. Then \(L(s,\lambda_0)\) is a scalar (the
  \(e^{-uc_1(V)/z}\) factor is 1), \(\lambda_j^{-(r-1)/2}\) carries no \(z\), and
  the stationary-phase \(z\)-count (\(\phi_{\ge3}\) gives \(s\)-degree \(\ge3\)
  per \(z^{-1}\); the Gaussian \(e^{z\partial_s^2/(2r)}\) at \(s=0\) turns \(s^m\)
  into \(z^{m/2}\); net exponent \(\ge m/2-a\ge a/2\ge0\)) closes it.
- **MECHANISM, proof 2 (independent).** \(\mathbf P(\mathcal O_X^{\oplus2})=X\times\mathbf P^1\);
  small quantum cohomology of a product is the tensor product, so
  \(E\star=E_X\star\otimes1+1\otimes E_{\mathbf P^1}\star\) and the generalized
  eigenspace at \(r\lambda_j\) is \(H^*(X)\otimes v_j\). The compressed grading
  operator is \(\mu_X+\operatorname{tr}(P_j\mu_{\mathbf P^1})\), and the numbers
  \(\operatorname{tr}(P_j\mu)\) are degree-zero, permuted by the deck action
  \(q^{1/r}\mapsto e^{2\pi i/r}q^{1/r}\), hence all equal, and sum to
  \(\operatorname{tr}\mu=0\), hence each is \(0\). So the \(j\)-th summand is
  \(QDM(X)\) at bulk parameter \(r\lambda_j\cdot1\in H^0\). Since the spectral
  summands are canonical (generalized eigenspaces, not a choice), this pins
  \(\varsigma_j^\circ\) with no appeal to \(F_j\).
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL` for the trivial rank-two bundle,
  by two independent routes; the reviewer's own verdict: "Two independent routes
  agreeing is as much as I can ask of a claim I was trying to break."
- **FRAME DATA.** Base point \(\hat\tau=0\), the **canonical** parameter, inside
  the germ where IK Theorem 5.1 lives — the reviewer stresses "No inversion, no
  displaced evaluation, no Hypothesis 4.7H." Novikov: \(q\) a unit with an
  \(r\)-th root adjoined, \(Q\) formal. Symbol note: here \(r\) is the IK
  **rank** (=2), not \(\Lambda\)'s \((3q)^{1/2}\).
- **SCOPE DELTA.** Covers the projective-bundle use site (1c) **only for
  \(c_1(V)=0\) and \(V\) trivial**. For \(c_1(V)\ne0\) the exponential factor is
  present and the QRR operator is cohomology-valued, so neither proof runs. Covers
  nothing of the blowup centre or ambient use sites.
- **Also on record:** this **strikes** an earlier pessimistic memo claim (lines
  771-774, that even \(X\times\mathbf P^1\) carries an \(O(q^{-1/r})\) tail) —
  "an inference from the \(O(\cdot)\) symbol ... It carries no information either
  way about \([z^{-1}]\log\). So the memo's earlier claim was never supported; it
  should be struck."

### B13. The fixed-divisor substitution does not change \(\nu_6\)

- **PROVENANCE.** Manuscript 04-one-step.tex:629-632 and 769-770; (4.1) at
  lines 293-297. Source-level confirmation:
  `framing-compatibility-checks.md` §3 Check 2 (ledger row C912-M17,
  `resolved`), citing HYZZ Theorems 5.20(2)/5.24(2), Proposition 4.31, and
  Iritani--Koto (5.11)-(5.12), Iritani §5.8.1.
- **MECHANISM.** \(Q^d\mapsto e^{\langle a_2^\circ,d\rangle}Q^d\) is a
  \(z\)-constant coefficient automorphism fixing \(\mathbf C\), so it cannot move
  a characteristic polynomial's roots-of-unity multiplicities. Well-definedness on
  the image monoid follows because \(h_{C,j}\) is a scalar multiple of \(\rho_C\)
  (blowup) resp. the displayed \(u\)-exponent factors (projective bundle).
  Check 2 adds that the residual base-map ambiguity of HYZZ is itself such a
  character (\(q\mapsto cq\) is \(Q^d\mapsto c^{E\cdot d}Q^d\)), and that the
  sources' explicit initial conditions pin it anyway.
- **VALIDITY CLASS.** `PROVED-UNCONDITIONAL`.
- **SCOPE DELTA.** Disposes of the \(H^2\) component. **Owed:** the note records
  that "A manuscript sentence citing (5.11)-(5.12), respectively Section 5.8.1, as
  the normalization that fixes the logarithmic constant ... closes this check.
  That sentence is cheap and should be written whichever repair route wins" — it
  has not been written.

### B14. \(X\times\mathbf P^1\): (H1) holds, the carrier is one component, and the germ is caustic-free

- **PROVENANCE.** `2026-08-15-c912-m1-ambiguity-computation.md`, Propositions 1-4.
  Script `notes/2026-08-15-c912-xp1-spectral-check.py`, SHA-256
  `20b937ccc9fdc20df3d3b4c2f47ee8895071420ea6c5acbf31f3f940e04e31a7`; committed
  output `notes/2026-08-15-c912-xp1-spectral-check.out`, SHA-256
  `58d347697b0f0610e32b6ef651f572535e900acd7d5cb3abfde8662f44f68c11`; replay
  `uv run --with sympy python notes/2026-08-15-c912-xp1-spectral-check.py`.
  External inputs (not replayed): Beauville's presentation
  \(QH_{\rm even}=L[x]/(x^4-27q_1x^2)\) for the cubic threefold, and
  \(QH_{\rm even}(\mathbf P^1)=L[y]/(y^2-q_2)\).
  Chain: **Beauville presentation + product formula → script items 1-3 → (H1)
  verified for \(X\times\mathbf P^1\) → B6/B7/B8 apply → Proposition 4 (no
  collision on the germ) → count constantly 4 on the germ**.
- **MECHANISM.**
  - *Prop 1* (script items 1-2): char. poly. of \(U\) is \((4q_2-\lambda^2)^2\)
    times an irreducible quartic; sheets \(\pm2s\) with multiplicity two
    (\(s=q_2^{1/2}\)) plus four simple sheets \(\pm6r\pm2s\); at \(\pm2s\) the
    block is a single rank-two Jordan block with nonzero nilpotent part. This
    *is* (H1) for the variety the endpoint needs. Cross-check on the
    normalization: the eigenvalue list reproduces the manuscript's independently
    derived \(K_0\) spectrum \(0,0,\pm6r\) for \(E\star=2H\star\).
  - *Prop 2* (script item 3): over \(L_0=\mathbf C((q_1,q_2))\) the spectral
    algebra has exactly two connected components; both rank-two Jordan blocks lie
    in one, the four simple sheets in the other. Both \(x^2-27q_1\) and
    \(y^2-q_2\) are irreducible over \(L_0\).
  - *Prop 3* (two independent proofs): **Galois** — the connection is defined over
    \(L_0\supset\mathbf C\), so the nontrivial element of \(\operatorname{Gal}(K_2/L_0)\)
    fixes \(\mathbf C\) and carries the exponents of one block to those of the
    other; the exponents \(-1/6,-5/6\) are rational, hence fixed. **Künneth** —
    the block at \(\pm2s\) is the cubic's zero block tensored with a
    multiplicity-one \(\mathbf P^1\) eigenline, which by B3 has trivial framed
    monodromy.
  - *Prop 4*, the load-bearing one: "a collision at some point of the germ would
    force \(27q_1e^{t_1}=4q_2e^{t_2}\), and comparing leading terms in the
    \(\tau\)-adic filtration gives \(27q_1=4q_2\), an equality between two
    distinct monomials of the Novikov ring. The non-divisor directions only add
    positive-filtration terms to each eigenvalue and cannot cancel a unit."
- **VALIDITY CLASS.** `VERIFIED-COMPUTATIONALLY` for Props 1-2 (script + committed
  output + hashes); `PROVED-UNCONDITIONAL` for Props 3-4 given those inputs;
  `IMPORTED-UNVERIFIED` for the Beauville presentation and the product formula
  ("No independent replay of the two external inputs was run in this pass").
- **FRAME DATA.** Base point: \(\tau=0\) on the formal even bulk germ
  \(B=L[[\tau]]\) at the large-radius point, over \(L_0=\mathbf C((q_1,q_2))\) —
  so **both Novikov variables are units**, and \(\tau\) is the only nilpotent
  direction. Loop frame: unsheared for the spectral data, sheared for the residue
  via B8. Symbol note: here \(r=(3q_1)^{1/2}\) and \(s=q_2^{1/2}\), neither is a
  rank.
- **SCOPE DELTA.** Establishes germ-constancy of the count for
  \(X\times\mathbf P^1\), the one variety the endpoint theorem needs. It does
  **not** reach the reconstruction displacement point (see C-J1), it covers no
  centre summand, no general \(T\), and no intermediate variety of a weak
  factorization. The report says so itself: "Nothing here removes Hypothesis 4.7H
  from the manuscript."

### B15. Cai-style formal-germ constancy — the item closest to use site (2)

- **PROVENANCE.** memo `thm:bulk-constancy` lines 1911-1948, credited to Cai's
  Proposition 6 (import: Cai, cubic threefold, arXiv 2608.01577, Proposition 6,
  read at Cai3 lines 494-503 by `section10-hostile-referee.md` R5). Chain:
  **solve \(\partial_{t_i}M=-z^{-1}P_iM\), \(M|_{t=0}=I\) → \(M\) has integral
  \(z\)-powers → \(\sigma(M)=M\) → \(\sigma(MY)=(MY)M_{\mathrm f}\) → framed
  monodromy constant on the formal germ**.
- **MECHANISM.** The recursion gives \(M_n\in\operatorname{End}(H)\otimes
  \Lambda[z,z^{-1}]\) with \(z\)-order bounded below by \(-|n|\) at each fixed
  bulk degree; \(M=I+O(t)\) is automatically invertible;
  \(M^{-1}\nabla_{t_i}M=\partial_{t_i}\) and commutation with \(\nabla_z\) makes
  \(M^{-1}\nabla_zM\) bulk-independent, equal to the connection at \(b\) since
  \(M|_{t=0}=I\). Every entry is a Laurent series in **integral** powers of \(z\),
  so the turn fixes \(M\) and the framed matrix is literally the same in the
  transported solution frame. Breaks the moment the bulk parameter is specialized
  to something with Novikov coefficients: then the sum over bulk degrees loses its
  lower bound in \(z\) and \(M\) is not a gauge in any ring where the turn
  argument runs (memo lines 1962-1970 say exactly this).
- **VALIDITY CLASS.** `PROVED-UNDER-STATED-HYPOTHESES` — bulk parameters formal;
  comparison along a formal germ only; no Novikov specialization. Accepted by the
  hostile referee: "its Theorem `thm:bulk-constancy` is Cai's formal-germ argument
  correctly generalized". **One sub-step is `ASSERTED-WITHOUT-PROOF`:** the memo
  says the transport theorem "applies with the bulk variables as formal
  parameters" (line 1527), an extension of `thm:transport` to
  \(\Omega_V((z))[[t]]\) that is not proved in the audited set.
- **FRAME DATA.** Unsheared; base point \(b\), compared along the formal germ at
  \(b\); \(t\) formal-nilpotent, \(\Lambda\) the coefficient field with \(q\) a
  unit; the turn acts on \(z\) alone (this is what makes \(\nu_6\) additive across
  ramified summands — `section10-hostile-referee.md` R3).
- **SCOPE DELTA — and why this is the item to watch for use site (2).** The
  tagging displacement is \(\eta=\sum t_iD_i\) over \(k_\chi[[\boldsymbol t]]\)
  with \(\boldsymbol t\) genuinely formal over an algebraically closed field.
  That is *exactly* this theorem's hypothesis, and none of the topological
  objections (D5-F1) apply, because no Novikov specialization of the bulk
  parameter occurs. **Two gaps stop this from discharging use site (2) today:**
  (a) the transport theorem's extension to formal parameters is asserted; (b) the
  theorem is stated for the A-model \(F\)-bundle of a smooth projective \(T\),
  whereas use site (2) needs it for the \(\chi\)-specialized module — no document
  states that base change along a strictly Novikov-admissible \(\chi\) preserves
  the hypotheses. The manuscript itself does **not** invoke this route; it invokes
  4.7H directly at 04-one-step.tex:929-933.

### B16. The unconditional halves of the manuscript's own arguments

- **Injectivity of the tagging map (4.6).** 04-one-step.tex:850-892.
  MECHANISM: the degree-\(\mu\) initial form is a finite combination of distinct
  exponential characters; substituting \(t_i=a_is\) for \(a\in\mathbf Z^\rho\)
  off the finitely many hyperplanes where two dot products agree makes the
  exponents distinct integers, and their derivatives at \(s=0\) form a Vandermonde
  matrix with nonzero integer determinant, invertible over
  \(\operatorname{Frac}(\operatorname{gr}_vA)\) in characteristic zero. The
  manuscript states precisely where the domain hypothesis on
  \(\operatorname{gr}_v(A)\) is used and that it is used exactly twice (lines
  882-892). `PROVED-UNCONDITIONAL`.
- **(4.6a) \(p^{\rm tag}=p^{\rm int}\).** 04-one-step.tex:910-919, 935-939. This is
  the surviving half after (4.6b) was deleted
  (`hypothesis-4-7h-conditionalization.md`, "Downgraded claims", line 98-101).
  `PROVED-UNCONDITIONAL`.
- **Separation \(\bigcap_NJ_j^N=0\) and injectivity \(R_j\to B_j\to\mathscr L_{B_j,F}\).**
  04-one-step.tex:499-517 and 668-685. MECHANISM: an additive integer weight on
  the ambient Laurent monomial lattice respects every relation in the image
  monoid; every generator of \(J_j\) has weight \(\ge1\), so \(J_j^N\) has weight
  \(\ge N\), while Novikov finite-below support gives every nonzero element a
  finite lowest weight. Confirmed by the red team, §5(a) "Pro-Laurent gain —
  CONFIRMED". `PROVED-UNCONDITIONAL`.
- **Parity of both decompositions.** 04-one-step.tex:786-795; the
  projective-bundle half is checked in the manuscript because no source states it.
  `PROVED-UNCONDITIONAL`.
- **The residual target bulk coordinate lies in \(J_jH^*(C)\).**
  04-one-step.tex:523-527, resting on Iritani (5.45), (5.47) and the initial
  asymptotics (5.27)-(5.30). `IMPORTED-UNVERIFIED` at this audit's level — not
  read at the source here, and not covered by any of the audited notes.

### B17. HYZZ Lemma 2.24 as a published precedent for divisor tagging

- **PROVENANCE.** `framing-compatibility-checks.md` §4. Import: Hinault--Yu--Zhang--Zhang,
  arXiv 2411.02266 as cached 2026-08-10, SHA-256
  `a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd`, Lemma 2.24
  with Assumption 2.22 and Lemma 2.23.
- **MECHANISM.** They prove the collapsed potential \(\Phi_\omega\) determines the
  full Gromov--Witten potential by using the divisor axiom to expand in the
  \(H^2\) bulk directions and separating curve classes by their intersection
  numbers with an \(H^2\) basis — the same mechanism as `lem:divisor-tagging`.
- **VALIDITY CLASS.** `CONSISTENCY-CHECK-ONLY`, and the note says so explicitly:
  "It does not close divisor tagging: Lemma 2.24 works at the level of the
  potential over a base retaining all \(H^2\) directions, while the manuscript
  needs the separation at the level of a framed operator at a fixed bulk point,
  and the manuscript's collapse is by the pair \((i_*,\rho_C\cdot)\) rather than
  by a single nef class."
- **SCOPE DELTA.** Makes the *shape* of the tagging argument a cited one. Owed to
  the manuscript: one sentence and a bibliography entry. Discharges nothing.

### B18. The Serre-lattice identification and the genus-six test

- **PROVENANCE.** `2026-08-15-c912-det-r-pairing-and-serre-lattice.md` §4, script
  `notes/2026-08-15-c912-serre-lattice-check.py` SHA-256
  `ac6e9c30a0d73755878c0963afe62c9c2328435f18e749086274409065c05350`, committed
  output `.out` SHA-256
  `81569e4cfde41cd78a8565e0a8e4fdc924c92509fce22be0e3a818ac3a861db1`, replay
  `uv run --with sympy python notes/2026-08-15-c912-serre-lattice-check.py`.
  Follow-up test: `2026-08-15-c912-gm-genus-six-serre-test.md`, script
  `notes/2026-08-15-c912-gm-genus-six-serre-check.py` with committed `.out`.
  Chain: **Euler form of \(Ku(X)\) → \(S=E^{-1}E^T\) → char. poly. \(\Phi_6\),
  \(S^3=-I\) → count 2 → *conjectural* identification with framed monodromy →
  discreteness of the exponent → displacement invariance would be automatic**.
- **MECHANISM (the computation).** \(D^b(X)=\langle Ku(X),\mathcal O,\mathcal O(1)\rangle\),
  so the residual component has numerical Grothendieck group of rank two, matching
  the rank-two block, while the two exceptional objects match the two simple
  blocks at \(\pm6r\), which by B3 carry nothing. From
  \(E=\begin{pmatrix}-1&-1\\0&-1\end{pmatrix}\) and \(\chi(a,b)=\chi(b,Sa)\),
  \(S=\begin{pmatrix}0&-1\\1&1\end{pmatrix}\), char. poly. \(\lambda^2-\lambda+1=\Phi_6\),
  \(S^3=-I\). Basis-free: rank two, integrality and \(S^3=-I\) leave only
  \(\{-1,-1\}\) or the conjugate pair, and the trace excludes the first.
- **MECHANISM (the test).** The genus-six Gushel--Mukai threefold's Kuznetsov
  component has numerical Grothendieck group \(\langle-1\rangle\oplus\langle-1\rangle\)
  with a **symmetric** Euler form, so \(S=\mathrm{id}\), eigenvalues \(1,1\),
  count zero — matching the lane's independent provisional \(\nu_6(V_{10})=0\).
  The sweep reproduces \(\nu_6=2\) at genera four and eight and \(0\) at genera
  two, three, five, six, seven, nine, ten and twelve, with polynomial-level
  agreement at genera two through five.
- **VALIDITY CLASS.** `VERIFIED-COMPUTATIONALLY` for the lattice computations and
  the census match. **`ASSERTED-WITHOUT-PROOF` for the identification itself**,
  and the source says so: "That the formal monodromy of an atom matches the Serre
  operator of the corresponding semiorthogonal component is the expected
  correspondence in the Katzarkov--Kontsevich--Pantev--Yu programme, not something
  proved here or in the manuscript." Ledger row C912-M25 is `open`.
- **FRAME DATA — and a live convention problem, see C-J5.** The Serre computation
  is in the **K-group grading**, where a shift \([k]\) acts by \((-1)^k\). The
  formal monodromy is in the **cohomological grading**. The recorded sign
  convention is \(\lambda\mapsto-\lambda\) (gm-test verdict 3: "the characteristic
  polynomial of the Serre operator is \(R\) with `lam` replaced by `-lam` in every
  case. This pins the sign convention that was previously implicit"), which the
  memo ties to the half-parity gauge \(u^g\) (memo lines 1578-1586).
- **SCOPE DELTA.** If the identification were proved, it would give discreteness
  of the exponent and hence local constancy for free (`det-r` §6). It is not
  proved, so it discharges nothing; its present value is that it is a second,
  independent computation agreeing with the count at every tested target.

---

## C. Frame-alignment audit

A piece of evidence discharges an obligation only if the frame, base point,
Novikov roles, parity convention and exponent normalization at the point of proof
are the same as at the point of use. This section checks each junction. Junctions
that do **not** line up are carried forward into section E and ranked.

### C.0 Reference table of frames in play

| Object | Loop frame | Base point | Novikov roles | Parity convention |
|---|---|---|---|---|
| Manuscript `def:framed-sixth-multiplicity`, \(\nu_6\) | original \(z\)-disc, turn on \(z\) alone | intrinsic small point (bulk 0) | \(Q\) formal; \(q\) formal in the cubic packet (\(\mathbf C[[Q^\ell]]=\mathbf C[[q]]\), 04-one-step.tex:1281-1283) | even connection only |
| Manuscript `lem:formal-base-shift`, comparison-transported matrix | unsheared, pro-Laurent \(\mathscr L_{B,F}\), unbounded negative \(z\)-order | displaced by \(\eta\in F^1B\) | \(u=q^{-1/(c-1)}\) or \(q^{-1/r}\) given **weight 1** by the manuscript's own \(w\), hence in \(J_j\) | even |
| Manuscript cubic packet | Frobenius ansatz with relative \(z^1\) (= sheared) | small point | \(q\) formal-nilpotent; \(r=(3q)^{1/2}\) adjoined | even |
| memo Section 8 rigidity | **sheared** \(S=\operatorname{diag}(1,z)\), residue \(R\) | \(\tau=0\) on \(B=\Lambda[[\tau]]\) | \(q\) a **unit** in \(\Lambda\), \(r=(3q)^{1/2}\) a unit; \(\tau\) nilpotent | even |
| memo `thm:bulk-constancy` (Cai) | unsheared, \(M\) with integral \(z\)-powers | formal germ at \(b\) | bulk \(t\) formal; \(q\) a unit | even |
| Iritani / Iritani--Koto comparison theorems | \(z\)-power-series module maps | germ at \(Q=\tilde\tau=0\) (resp. \(\hat\tau=0\)) | \(q\) **inverted, a unit** in the graded completion; \(Q,\tilde\tau\) formal | even after odd bulk set to zero |
| HYZZ Theorem 4.34 / §4.4 | F-bundle framing normal form | closed point \(b:q=t=0\), quantum product = cup product | both collapsed; \(K\) nilpotent | — |
| KKPY Claim 6.15 | after the half-parity gauge \(u^g\) | rigid point of \(B_X^{ev}\), \(H^0\)-coordinate zero, \(H^{\ge4}\) coordinates in an **open unit polydisk** | analytic, \(|p|\) in a narrow annulus | half-parity shift by \(\tfrac12\deg\) |
| Serre-lattice computation | none (a lattice, not a connection) | none | none | K-group grading, \([k]\mapsto(-1)^k\) |

### C-J1. Section 8's germ vs the reconstruction displacement point — **GENUINE BREAK**

Section 8 proves \(\tau\)-constancy on the formal even bulk germ
\(B=\Lambda[[\tau]]\). `cor:cubic-closed` (memo lines 1489-1505) extends this to
"any bulk parameter \(\tau^\bullet\) in the positive filtration", justified by
"evaluation at a topologically nilpotent \(\tau^\bullet\) is legitimate".

`section10-hostile-referee.md` R4 rejects the extension:

> That the characteristic polynomial is \(\tau\)-constant removes the need to
> *transport* it, but it does not put \(\tau^\bullet\) inside the germ. So Section
> 8 proves constancy on the formal even bulk germ — which is what Cai's gauge
> argument already gives — with the genuine gain that no pro-Laurent gauge is
> used, and with no gain at all in the domain of validity.

and F1 supplies the reason \(\tau^\bullet\) is not topologically nilpotent **in
the sources' topology**: under Iritani Remark 1.3 and §2.2 (graded completion is
a direct sum over degrees) and IK Remark 5.3, \(q^{\pm1/s}\) is a **unit**, so the
\(H^0\) part \(\propto q^{1/r}\), the \(H^2\) constant \(h_{Z,j}\), and the
\(H^{\ge4}\) tail in negative powers of \(q\) all fail topological nilpotence.

**Auditor's finding, flagged as my inference:** the manuscript does not use
Iritani's graded completion for its filtration. It defines its own additive
weight with \(w(u)=1\), \(w(s_{j,\ell})=1\),
\(w(Q^{i_*d}u^{\rho_C\cdot d})=L(H\cdot i_*d)+\rho_C\cdot d\ge1\)
(04-one-step.tex:499-514), under which \(u=q^{-1/(c-1)}\) **is** in \(J_j\) and
hence topologically nilpotent in \(B_j\) by construction. So the manuscript and
F1 are working in two different topologies on overlapping objects, and Iritani's
invertibility and pullback statements are proved in the topology where \(q\)'s
roots are units. Nothing in the audited set reconciles the two. This is the
single highest-value normalization statement owed.

Ranking: **genuine break** as regards importing Section 8 to discharge 4.7H, and
**repairable by a stated normalization only if** the manuscript's \(w\)-topology
can be shown compatible with the sources' graded completion — which is the open
question, not a bookkeeping matter.

### C-J2. HYZZ's base point vs the point \(\nu_6\) uses — **GENUINE BREAK (already fatal)**

HYZZ Theorem 4.34 and its applications evaluate at \(b:q=t=0\), where "the
quantum product reduces to the classical cup-product" and \(K_{\rm split}\) is
nilpotent. \(\nu_6\) is evaluated over the Novikov field where the eigenvalues of
\(c_1\star\) genuinely separate — for the cubic, the block with \(r=(3q)^{1/2}\)
and indicial roots \(\pm1/6,\pm5/6\). "At \(Q=0\) that separation collapses to a
nilpotent \(K\), and the exponential blocks the framed operator is built from do
not exist" (`framing-compatibility-checks.md` §2, 1a). HYZZ supply no transport
between the two base points. This break already killed Check 1.

### C-J3. KKPY Claim 6.15's base point vs the manuscript's use — **REPAIRABLE, but currently unstated**

KKPY Claim 6.15 requires (i) \(K_X\) nef, (ii) a **vanishing \(H^0\) coordinate**,
(iii) \(b\) a **rigid point** of \(B_X^{ev}\) with \(H^{\ge4}\) coordinates in an
open unit polydisk (`section10-hostile-referee.md` R1, with KKPY line locators
2182-2206 and 6317-6344). The manuscript's `prop:low-dimensional-vanishing`
(04-one-step.tex:968-995) invokes `\cite[Claim~6.15]{KKPYY}` "coefficient by
coefficient over the small numerical Novikov ring" and carries the nef hypothesis
in prose. **Conditions (ii) and (iii) are not carried in the manuscript.**
Condition (ii) is repairable by B11 (the \(H^0\) shift is exactly invariant), which
the referee endorses but says "deserves a displayed lemma, since it is what lets
Claim 6.15's hypothesis (ii) be met at a parameter whose \(H^0\) part is
\(r\lambda_j\propto q^{1/r}\)". Condition (iii) is the polydisk, and the referee's
own independent re-derivation of the degree argument
(\(\sum_k(\deg\phi_{i_k}-2)-2c_1\cdot d\) from the genus-zero dimension axiom)
supports the conclusion "at any such parameter" with \(H^0\) vanishing — but that
re-derivation is the referee's, marked "This is my own verification, not a source
claim". Ranking: **repairable by stating the normalization and adding the
\(H^0\)-shift lemma**, with the caveat that the polydisk condition is discharged
only by an unpublished re-derivation.

### C-J4. The half-parity gauge \(u^g\) — **ALIGNED, and correctly handled in both places**

KKPY's statements are made after the gauge \(u^g\), \(g=\mathrm{Gr}+\tfrac12T_d\),
which "shifts exponents by half the cohomological degree, multiplying monodromy
eigenvalues by a parity-dependent sign: primitive sixth roots become primitive
cube roots and \(\pm1\) swap" (memo lines 1578-1586). Both consumers undo it
explicitly: the manuscript's `prop:low-dimensional-vanishing` sets
\(g=\mathrm{Gr}+\tfrac12E\) with \(E\) the parity operator and then says "Undoing
the half-parity correction permits only the monodromy eigenvalues 1 and \(-1\)"
(04-one-step.tex:974-995); the memo's `thm:low-dim` says "Undoing that gauge
shifts the exponents by the eigenvalues of \(g\), which lie in \(\tfrac12\mathbf Z\)"
(lines 2054-2059). The memo also records the invariance that makes it safe: "Every
separation used below distinguishes roots of unity of order at most two from roots
of order three or six, which the gauge preserves." **No defect. Should still be
stated in the manuscript where Claim 6.15 is cited.**

### C-J5. The Serre convention — **CONVENTION BREAK, unresolved, and the identification is unproved anyway**

Two separate offsets sit on this junction.

1. **Which relation.** KKPY Example 6.21 records \(S^5=[3]\); Kuznetsov's
   fractional Calabi--Yau relation for the same category is \(S^3=[5]\). On the
   numerical Grothendieck group these predict \(S^5=-I\) and \(S^3=-I\); "the
   Serre operator computed from Riemann--Roch satisfies the first exactly and
   fails the second" — i.e. only \(S^3=[5]\) yields \(\Phi_6\) and primitive sixth
   roots (memo lines 1563-1576; `det-r` §5). Ledger row C912-M26 is **open**. The
   memo calls the offset "systematic rather than a slip" (their Example 6.20 gives
   \(S^3=[4]\) for the cubic fourfold), attributes it to two different objects —
   the Serre automorphism of a Hodge atom in the cohomological \(\mathbf Z\)-grading
   versus the categorical Serre functor on a K-group — and says "a citation should
   follow the object it is about".
2. **The sign.** The recorded convention is \(\lambda\mapsto-\lambda\) between the
   prime-Fano classification's polynomial \(R\) and the Serre side (gm-test verdict
   3), which the memo identifies with the half-parity gauge (lines 1578-1586).

**Finding:** the identification is stated in the K-group grading with the
\(S^3=[5]\) relation and consumed against a cohomological-grading formal
monodromy, with the \(\lambda\mapsto-\lambda\) offset recorded but not proved to
be the right bridge. Ranking: **repairable by stating the convention and reading
Example 6.21 at the source** — but since the identification itself is
`ASSERTED-WITHOUT-PROOF` (B18), fixing the convention would not by itself
discharge anything.

### C-J6. Exponent normalization: memo \(-1/6,-5/6\) vs Cai \(\pm1/6\) vs the manuscript — **ALIGNED; one transcription error found in the notes**

Checked in this audit (see B9): the memo's sheared residue \(R\) satisfies
\(\det(sI-R)=L_s\) exactly, where \(L_s\) is the manuscript's Frobenius recursion
matrix (04-one-step.tex:1250-1256) with \(\det L_s=(s+\tfrac16)(s+\tfrac56)\); the
manuscript's roots are \(\rho=-\tfrac16,-\tfrac56\) (4.9i, line 1188). Cai's
\(\rho\equiv\pm1/6\bmod\mathbf Z\) matches, since \(-5/6\equiv+1/6\). The shear
shifts exponents by integers only, which \(\operatorname{Exp}_V(\rho)=e^{2\pi i\rho}\)
does not see. **So the sheared and unsheared statements are the same statement.**

**Error found:** `framing-compatibility-checks.md` §6 item 3 writes "the draft's
indicial roots \(1/6\) and \(5/6\)" — signs dropped relative to the manuscript's
\(-1/6,-5/6\). Since \(\{e^{\pi i/3},e^{-\pi i/3}\}\) is conjugation-closed,
\(\nu_6=2\) either way, so nothing downstream moves; the note should still be
corrected.

### C-J7. Symbol reuse of \(r\) — **REPAIRABLE, but a real referee hazard**

At least four meanings are in simultaneous use across the audited set, two of them
inside the same manuscript section:

- \(r=(3q)^{1/2}\), an element of the coefficient field — memo Section 8 (line
  1158-1159), `m1-ambiguity` (\(r=(3q_1)^{1/2}\)), and the manuscript's own cubic
  packet (04-one-step.tex:1095-1141, 1212 "Put \(R=\mathbf C[r,r^{-1}]\)").
- \(r\) = rank of \(V\) — Iritani--Koto and the manuscript's `prop:framed-operations`
  (04-one-step.tex:430, 652-657), with \(r'\) the adjoined root.
- \(r\) = codimension of the blowup centre — Iritani's blowup paper, where the
  manuscript writes \(c\); this is why the hostile-referee quotes read
  \(-(r-1)\lambda_j+h_{Z,j}+O(q^{-1/(r-1)})\) where the manuscript reads
  \(-(c-1)\lambda_j+h_{C,j}+O(q^{-1/(c-1)})\).
- \(R\) = the sheared residue (memo) versus \(R=\mathbf C[r,r^{-1}]\) (manuscript
  line 1212) versus \(R_j\) the monoid image ring (manuscript lines 484, 657)
  versus \(R\) the prime-Fano classification's polynomial (`det-r` §5).

Also colliding: \(E\) is the exceptional divisor (04-one-step.tex:644), the parity
operator (line 977), \(E_0\) the \(z^2\) coefficient (line 1140), and \(E\star\)
the Euler operator (memo). And \(e\) is the ramification index, the exponent
\(s_c/(c-1)\in\{1,2\}\) (line 541-542), and a basis vector.

Ranking: **repairable by renaming**; low mathematical risk, high probability of a
referee complaint, and it is the mechanism by which a frame confusion would go
unnoticed.

### C-J8. Novikov roles of \(q\) — **THREE ROLES, and this is where C-J1 lives**

- Cubic packet: \(N_1(X)=\mathbf Z\ell\), numerical Novikov ring
  \(\mathbf C[[Q^\ell]]=\mathbf C[[q]]\) (04-one-step.tex:1281-1283) — \(q\) is
  **formal-nilpotent**.
- \(X\times\mathbf P^1\) spectral computation: \(L_0=\mathbf C((q_1,q_2))\)
  (`m1-ambiguity` Prop 2) — both \(q_i\) are **units**.
- Comparison chart: \(u=q^{-1/(c-1)}\), a **negative fractional power** of the
  exceptional Novikov variable, made filtration-**positive** by the manuscript's
  weight \(w\) but a **unit** in Iritani's graded completion.

Ranking: **repairable by stating which ring each statement lives in, at each use**
— and that statement is exactly what C-J1 needs, so writing it is also the first
step of the real repair.

### C-J9. Ramification bookkeeping \(s_c\), \(r'\), \(v^e=u\) — **ALIGNED**

Manuscript lines 469-473: the comparison field adjoins \(q^{-1/s_c}\) with
\(s_c=c-1\) for even \(c\) and \(2(c-1)\) for odd \(c\), while the reconstruction
coordinate is \(u=q^{-1/(c-1)}\); lines 541-542 set \(v=q^{-1/s_c}\) with
\(v^e=u\), \(e=s_c/(c-1)\in\{1,2\}\). Projective bundle: \(q^{-1/r'}\),
\(r'=r\) if \(r-1\) even, \(2r\) if odd, with \(u=q^{-1/r}\) (lines 653-656,
704-705). The manuscript states in both places that this is "a coefficient
extension in the Novikov direction, not a ramification of \(z\)", which is what
keeps Lemma 4.1A applicable. Consistent, and consistent with the red team's
observation that a genuine \(z\)-ramification would cost a factor \(e\) in the
splitting rate (red team §5(b)(1)).

### C-J10. Sheared vs unsheared at the point of import — **ALIGNED, but must be stated**

If Section 8 is ever imported to discharge 4.7H, note that it freezes the
**sheared** residue \(R\), whereas `lem:formal-base-shift`'s gauge \(G\) and the
comparison-transported matrix live in the **unsheared** pro-Laurent frame. The
bridge is that the shear changes exponents by integers only, and \(\nu_6\) reads
exponents modulo \(\mathbf Z\) via \(\operatorname{Exp}_V(\rho)=e^{2\pi i\rho}\).
The import must therefore be at the level of exponent classes, never of the
operator. Correct as stated in the memo (line 1485-1486); not stated in the
manuscript, which does not currently import Section 8 at all.

### C-J11. Turn acts on \(z\) alone, hence \(\nu_6\) is additive across ramified summands — **ALIGNED, and load-bearing**

`section10-hostile-referee.md` R3: the summands are indexed by \(j\) through
\(\lambda_j=e^{2\pi ij/r}q^{1/r}\), and the deck transformation
\(q^{1/r}\mapsto e^{2\pi i/r}q^{1/r}\) permutes them cyclically. "If the 'turn' ...
acted on the ramified *coefficient* \(q^{1/r}\) as well as on \(z\), the framed
operator would be block-cyclic across summands and \(\nu_6\) would not be
additive. It is additive only because the memo's \(\sigma\) fixes
\(\mathcal H=\Omega_V((z))\) pointwise, i.e. the turn is in \(z\) alone." The
manuscript's definition does act on \(z\) alone, and it repeatedly stresses that
the Novikov root "is a coefficient extension ... not a ramification of \(z\)"
(04-one-step.tex:469-472, 655-656). **Aligned — but the referee is right that it
should be said, because the direct-sum additivity step (04-one-step.tex:638-639,
776-778) is exactly where a reader will suspect a cyclic framing.**

---

## D. Attacks already landed

Each attack: **PROVENANCE**, **WHY THE ATTACK IS VALID**, **WHAT IT KILLS**.
Attacks on proposed *proofs* and *routes* are separated from attacks on the
hypothesis itself (D14).

### D1. The compressed pair does not determine the exponents — the regression test

- **PROVENANCE.** memo `sec:not-yet`, lines 1080-1112.
- **WHY VALID.** The draft's own reduced rank-two block is
  \(z^2\partial_z(\widetilde S_3,\widetilde S_4)^T=[J_0+zD_0+z^2E_0+O(z^3)](\cdots)\)
  with \(J_0=\begin{pmatrix}0&2\\0&0\end{pmatrix}\),
  \(D_0=\operatorname{diag}(-19/18,19/18)\), and \(E_0\) carrying \(-8/81\). The
  ansatz gives \(\rho^2+\rho+\tfrac5{36}=0\), \(\rho=-\tfrac16,-\tfrac56\).
  **Setting the \(-8/81\) entry to zero** leaves \(c(\rho+1)=\tfrac{19}{18}c\),
  whose solutions are \(\rho=1/18\) and \(\rho=-19/18\), i.e. \(\pm1/18\) mod
  \(\mathbf Z\) — eighteenth roots of unity, contributing **nothing** to
  \(\nu_6\).
- **WHAT IT KILLS.** Any deformation theory that tracks only \(U_i\) and
  \(P_i\mu P_i\). It is not an attack on 4.7H, but it is the sharpest calibration
  in the file: a perturbation of the block data at order \(z^2\) drops the count
  from 2 to 0. Any proposed proof of 4.7H must reproduce this example — the memo
  calls it "the regression test". Section 8 meets it by construction, because the
  shear folds \((A_1')_{21}\) into \(R\) (memo lines 1509-1516).

### D2. The transport theorem has no verified instances in the application

- **PROVENANCE.** `frame-transport-memo-red-team.md` §4, flagged there as "the
  most important finding of the review".
- **WHY VALID.** The theorem needs both \(G\in\mathrm{GL}_n(\mathcal H)\) and a
  fundamental matrix over \(\mathcal U_e\). If \(\Gamma=0\) then
  \(\mathcal H=\Omega_V((z))\) and solutions exist, but the pro-Laurent gauge has
  unbounded negative \(z\)-order and is not in \(\mathrm{GL}_n(\mathcal H)\). If
  \(\Gamma\ne0\) with the draft's order, the gauge is in \(\mathcal H\), but
  \(\mathcal H\) is not a formal Laurent series field over its constants and
  Levelt--Turrittin is unavailable — with an explicit counterexample showing the
  \(e_z\)-component of the Hahn valuation is not a valuation
  (\(f=x^{(0,0)}+x^{(1,-100)}\), \(g=-x^{(0,0)}\):
  \(\pi_{e_z}v(f)=\pi_{e_z}v(g)=0\) but \(\pi_{e_z}v(f+g)=-100\)) and that the
  bounded-\(z\)-order subring is not a field (\(f=1-zx^{-\gamma}\) has inverse
  \(-\sum_{k\ge1}z^{-k}x^{k\gamma}\)).
- **WHAT IT KILLS.** The receiver route as a proof of 4.7H. The reviewer's
  reframing is worth carrying: "an abstract Picard--Vessiot ring for any module
  over \(\mathcal H\) does exist ... so the missing ingredient is *not* a solution
  algebra: it is a canonical Levelt--Turrittin normal form singling out which
  element of the differential Galois group is 'the turn'."

### D3. The Constants Lemma is false in the intended range

- **PROVENANCE.** `frame-transport-memo-red-team.md` §3.
- **WHY VALID.** For \(\varphi=x^\gamma w^{-1}\) with \(\gamma\in\Gamma\),
  \(\gamma>0\) — "the shape of every actual quantum exponential factor, since
  \(\lambda\sim q^{1/2}\) has positive Novikov weight" — solving
  \(\theta_w(c)=\theta_w(\varphi)c\) gives
  \(c=\sum_{n\ge0}\frac{(-1)^n}{n!}x^{n\gamma}w^{-n}\), whose support
  \(\{(n\gamma,-n/e)\}\) is increasing, hence well ordered, hence \(c\in\mathcal H_e\).
  So \(cE(\varphi)\) is a nonzero \(\theta_w\)-constant outside \(\mathcal C\).
  The false step in the original proof is the domination argument
  \(v(\theta_w\varphi)<0\), which **reverses** when the exponential factor carries
  Novikov coefficients of positive weight.
- **WHAT IT KILLS.** The proposition "framed operator is the matrix of the turn"
  in the regime that matters. Corollary the reviewer draws: "over the draft's
  order the exponential factors are units, not symbols, and the entire
  irregularity cost sits in the Gevrey-divergent unit part."

### D4. Scale invariance of the convergence criterion is refuted; the criterion is \(L\)-dependent

- **PROVENANCE.** `frame-transport-memo-red-team.md` §5(c) and §6.
- **WHY VALID.** The draft fixes \(w(u)=w(s_{j,\ell})=1\) *independently of \(L\)*
  (04-one-step.tex:508) and sets
  \(w(Q^{i_*d}u^{\rho_C\cdot d})=L(H\cdot i_*d)+\rho_C\cdot d\) (lines 502-506).
  Hence \(\varepsilon=\min\) generator weight \(=w(u)=1\) always, while the weight
  of the Novikov generator whose root gives \(\Delta\lambda\) grows linearly in
  \(L\). So \(w(\Delta\lambda)/\varepsilon\) is \(L\)-dependent and the draft's
  instruction "choose an integer \(L\) so large that ..." drives it up.
- **WHAT IT KILLS.** The claim that \(L\) is not a free parameter, and with it the
  memo's assessment of where the criterion holds. Consequences stated: "With the
  draft's \(L\), the criterion fails at essentially *every* comparison that has
  two distinct exponential factors, including the cubic endpoint"; with the
  minimal admissible \(L\) it can hold. Surviving \(L\)-independent core:
  \(c_1\cdot d_0\ge2\) is necessary under any admissible weight (§6, CONFIRMED).
  Corrected criterion: \(L(H\cdot i_*d_0)+\rho_C\cdot d_0<c_1\cdot d_0\).
- **NOTE.** This attack is directly relevant to the manuscript, because the
  manuscript's own \(w\) is the object being criticized. It does not falsify any
  manuscript claim (the manuscript does not assert the criterion), but it means
  the manuscript's "choose \(L\) so large" is the worst choice for any future
  convergence-based repair.

### D5. \(w(\Delta\lambda)\) is not controlled by the Fano index when \(\rho(C)>1\)

- **PROVENANCE.** `frame-transport-memo-red-team.md` §5(b)(3) and §6 closing.
- **WHY VALID.** Two eigenvalues homogeneous of the same quantum degree can have
  leading terms that cancel in \(w\), because \(w\) and the quantum grading are
  different functionals on the exponent lattice; then
  \(w(\Delta\lambda)\gg w(\lambda)\).
- **WHAT IT KILLS.** The Fano-index reading of where the gap is confined. "The
  summary sentence ... is too optimistic on two counts: the \(L\)-dependence
  above, and item 5(b)(3)."

### D6. Structural non-existence of the product \(GP\) for \(C\ge1\)

- **PROVENANCE.** `frame-transport-memo-red-team.md` §7, third bullet ("stronger
  than the memo argues").
- **WHY VALID.** The \(z^n\)-coefficient of \(GP\) is \(\sum_mg_mp_{n+m}\), whose
  terms have weight \(\ge m(1-C)-nC\); for \(C\ge1\) infinitely many terms have
  bounded weight, so the coefficient is undefined "in *any* completion, ordered or
  not".
- **WHAT IT KILLS.** The hope that a better-ordered receiver removes the
  criterion. It makes the obstruction structural rather than an artifact of
  proving transport through an ordered receiver.

### D7. The HYZZ framing route fails, three independent ways

- **PROVENANCE.** `framing-compatibility-checks.md` §2, Check 1, findings 1a-1c;
  ledger row C912-M16.
- **WHY VALID.** (1a) Domain mismatch — HYZZ §4.4 and Theorems 5.16/5.22 evaluate
  at \(b:q=t=0\) where the quantum product is the cup product; \(\nu_6\) is not
  evaluated there, and no transport between the two base points is supplied.
  (1b) Hypothesis mismatch — §4.4 assumes the generalized eigenspaces "all have
  same dimensions", while the blowup summands have different dimensions whenever
  \(\dim H^*(Z)\ne\dim H^*(X)\); HYZZ write \(\Phi_{1,1}\in\operatorname{End}(H^*(X))\)
  and \(\Phi_{i,i}\in\operatorname{End}(H^*(Z))\) themselves, so the mismatch is
  explicit in their own notation. Theorem 5.22 asserts existence and Theorem 5.24
  uniqueness, but neither is derived from Theorem 4.34. (1c) Even where Theorem
  4.34 applies, its conclusion is gauge-equivalence to the target based at
  \(\Delta(a)\) — "That shift is exactly the object the pro-Laurent gauge ...
  exists to undo. The framing route therefore relocates the bulk displacement; it
  does not remove it."
- **WHAT IT KILLS.** The framing route as a replacement for the pro-Laurent gauge.
  The projective-bundle half of HYZZ is genuinely covered (eigenspaces are \(m\)
  copies of \(H^*(X)\), Lemma 5.8); the blowup half — equation (4.3), the half the
  headline theorem needs — "gains nothing from Theorem 5.22 beyond what Iritani's
  own theorem already supplies".
- **BONUS FINDING (in 4.7H's favour, C-J-relevant).** Finding 1c also records a
  **normalization consistency check that passes**: HYZZ's \(\Delta(a)\) and
  Iritani's \(\varsigma_j^\circ\) put the displacement in the same place, with
  HYZZ's cohomology-valued \(\lambda_i\) carrying the \(H^{\ge4}\) content that
  Iritani's scalar \(\lambda_j\) pushes into the \(O(q^{-1/(c-1)})\) tail. "Same
  content, different bookkeeping. The manuscript's split of \(\varsigma_j^\circ\)
  into 'unit twist + fixed divisor + positive-filtration tail' is therefore
  right."

### D8. The memo's diagnosis of the cause was wrong

- **PROVENANCE.** `framing-compatibility-checks.md` §5, ledger row C912-M15.
- **WHY VALID.** Iritani--Koto's own reconstruction (their §5.8) transports along
  \(M=\bigoplus_je^{-\varsigma_j^\circ/z}M_B(\varsigma_j^\circ+s_j;Qq^{-c_1(V)/r})\),
  described in their footnote 11 as "a fundamental solution for
  \(QDM(B)^{\boxplus r}_{\rm ext,loc}\) with respect to the variables
  \((Q,s_0,\dots,s_{r-1})\) (but not for \(q\) and \(z\))", satisfying
  \(M=\mathrm{id}+O(z^{-1})\) and lying in
  \(\operatorname{End}(H^*(B)^{\oplus r})[z^{-1}]((q^{-1/r}))[[Q,s]]\). Per bulk
  degree it is a polynomial in \(z^{-1}\) — exactly the manuscript's own bound
  (4.1a) — unbounded only after summing bulk degrees.
- **WHAT IT KILLS.** The claim that the unbounded negative loop order is "the
  manuscript's choice, not something the comparison theorems impose". **This is
  evidence in the manuscript's favour**: its pro-Laurent object is the sources'
  own fundamental solution. The sources handle it by Birkhoff factorization
  (\((\Phi^\circ)^{-1}\circ M=M'\circ\Phi^{-1}\)), not an ordered receiver, and
  the note says "Any repair should be measured against that, not against a
  receiver."

### D9. The endpoint / Section 10 route is fatal

- **PROVENANCE.** `2026-08-15-c912-section10-hostile-referee.md`, findings F1-F5.
- **WHY VALID, F1.** Under Iritani Remark 1.3 ("\(\mathbf C((q^{-1/(r-1)}))[[Q]]\)
  is the same as \(\mathbf C[q^{\pm1/(r-1)}][[Q]]\) since \(q\) has positive
  degree") and §2.2 (graded completion is a **direct sum** over degrees), and IK
  Remark 5.3 (\(\mathbf C[z]((q^{-1/r'}))_{\hom}\) "consists of finite sums of
  homogeneous elements"), \(q^{\pm1/s}\) is a **unit**. So none of the three
  pieces of the displacement is topologically nilpotent.
- **WHY VALID, F2.** The sources' invertibility is germ-to-germ in *displaced*
  coordinates (Iritani after Lemma 5.15; IK (5.13)). And Iritani states outright:
  "Due to the constant term \(h_{Z,j}\) in the change of variables ... the
  pullback of functions \(\sigma_j^*\) ... is ill-defined. However, the pullback of
  connections is well-defined due to the Divisor Equation." IK footnote 10 says
  the same for the \(H^0\) term. The false step is borrowing string/divisor — the
  device that legalizes the **forward** pullback of connections — to legalize an
  **inverse** substitution: "Nothing analogous exists in the reverse direction,
  because there is no structural equation that undoes a substitution."
- **WHY VALID, F3/F5.** A weak factorization has steps of both orientations, so
  the ledger must at some step invert the refuted map; and no source supplies the
  decomposition identity "at any parameter" — Iritani Theorem 5.18 and IK Theorem
  5.1 are germ statements, and KKPY Theorem 4.5's analytic domains come with
  Lemma 4.6's two-sided convergence bound and \(|y_i|\in[0,\epsilon)\), which the
  demanded parameter is outside by construction.
- **WHAT IT KILLS.** The claim that Section 10 makes 4.7H unnecessary. The
  referee's own summary, F4: "Choosing the parameter instead of transporting the
  invariant only moves the demand from 'evaluate \(\nu_6\) at a displaced
  parameter' to 'invert a formal map at a displaced target'. The second demand is
  not weaker than the first; by F1-F2 it is strictly outside what the sources
  establish." And: "the accurate statement of the current position is the one in
  F4: the theorem holds if \(\nu_6\) of the cubic threefold is 2 at the displaced
  parameter \(\varsigma_j^\circ\), which is Hypothesis 4.7H."

### D10. `cor:cubic-closed` overreaches

- **PROVENANCE.** `section10-hostile-referee.md` R4. Quoted in full at C-J1.
- **WHY VALID.** Steps 1-6 construct \(g\), the frame \((e_1,e_2)\) and the shear
  over \(B=\Lambda[[\tau]]\); \(\tau\)-constancy of the characteristic polynomial
  removes the need to *transport* it but does not place \(\tau^\bullet\) inside the
  germ.
- **WHAT IT KILLS.** The claim that Section 8 is a route around F1. It leaves
  Section 8's genuine gain intact: no pro-Laurent gauge is used anywhere in it.

### D11. Claim B — per-slot polynomiality does not rescue Cai's gauge

- **PROVENANCE.** `section10-hostile-referee.md`, second pass, CLAIM B.
- **WHY VALID.** Per Novikov slot the gauge is fine (at \(Q^0\),
  \(M^{(0)}=\exp(-tz^{-1}\delta\cup)\) terminates by nilpotency; at \(Q^d\) a term
  has at most \(N(d)\le\omega\cdot d/\omega_{\min}\) quantum factors and
  \(z\)-order \(\gtrsim-(1+\dim)N(d)\)). But the bound degrades **linearly in
  \(\omega\cdot d\)**, so summed over Novikov degrees the \(z\)-order of
  \(M|_{t=1}\) is unbounded below: \(M|_{t=1}\in\operatorname{End}(H)\otimes
  \Lambda_{\rm Nov}[[z^{-1}]]\), not \(\operatorname{End}(H)\otimes\Lambda_{\rm Nov}((z))\).
  "Claim B has changed the index of summation from bulk degree to Novikov degree
  and left the divergence where it was."
- **WHAT IT KILLS.** The claim that this route avoids "any Hahn field, any
  receiver, or the weight criterion". The referee names the repair: run Section
  8's machine along the same pencil instead, because its objects
  (\(g=I+O(z)\), \(S=\operatorname{diag}(1,z)\)) are on the **positive** side of
  the loop coordinate and lie in \(\mathrm{GL}(\Lambda((z)))\).
- **What survives of it, and it is useful.** Two ingredients are real: the three
  shapes of the displacement are supported by the sources (Iritani Theorem 5.18(6)
  gives \(\tau^\circ=q^{-1}[Z]+O(q^{-2})\), which is **purely** the \(H^{\ge4}\)
  shape, with no \(H^0\) and no \(H^2\) part at all in the ambient displacement);
  and per-slot polynomiality in \(t\) is real, though "the reason given is not the
  reason" — the real mechanism is the dimension axiom, a degree-\(\ge4\) insertion
  costing at least 2, which also explains why the \(H^2\) part must be removed by
  the divisor equation first.

### D12. `lem:low-dim-pointwise` overstates its scope

- **PROVENANCE.** `section10-hostile-referee.md` R1; see C-J3.
- **WHY VALID.** KKPY Claim 6.15's proof consumes three hypotheses, quoted at the
  source; the memo's Lemma as literally written ("every even bulk parameter") is
  false.
- **WHAT IT KILLS.** The unrestricted phrasing only. The referee could not break
  the degree argument and re-derived it independently, so the conclusion survives
  with the restrictions attached. **Carried into the manuscript's
  `prop:low-dimensional-vanishing`, which does not state conditions (ii) or (iii)
  — flagged in C-J3.**

### D13. Proof-level errors with surviving conclusions

- **PROVENANCE.** `frame-transport-memo-red-team.md` §§1, 2, 4, 5(a), 7, 8, 9.
- **WHY VALID / WHAT EACH KILLS.**
  - Freeness of \(\mathcal U_e\): the stated proof says both groups are
    torsion-free, but \(\Omega_V/\mathbf Z\) contains \(\mathbf Q/\mathbf Z\),
    "which is all torsion" — "Since the rational residue exponents are exactly the
    ones \(\nu_6\) counts, this is not a harmless slip in the surrounding
    context." Conclusion survives by base change along
    \(\mathcal H_e[t,t^{-1}]\to\mathcal H_e\).
  - Range of \(\rho\): \(\operatorname{Exp}_V\) is defined only on \(K=\mathbf C\oplus V\),
    not on \(\Omega_V\), so \(\sigma(w^\rho)=\operatorname{Exp}_V(\rho/e)w^\rho\)
    is undefined for \(\rho\in\Omega_V\setminus K\).
  - \(\sigma\)-\(\theta_w\) commutation: holds, but not because "both are diagonal
    in the basis" — \(\sigma(\ell)=\ell+2\pi i/e\) and \(\theta_w(\ell^m)=m\ell^{m-1}\)
    are not diagonal; the direct check is one line.
  - Inverse of \(M\): the stated \(Y^{-1}\sigma(Y^{-1})^{-1}\) *is* \(M\); the
    inverse is \(\sigma(Y^{-1})Y\).
  - \(GMG^{-1}\) is not the matrix of the turn in the original frame of \(D'\);
    that frame differs from \(GY\) by \(C_0\in\mathrm{GL}_n(\mathcal C)\), giving
    \(C_0^{-1}MC_0\). The reviewer notes this is "precisely the conflation the
    memo accuses the draft of committing at (4.1c)".
  - Finite-tensor objection: false on both counts — the pro-Laurent gauge lies
    entirely in \(H_{{\rm tot},j}\), and the splitting gauge's coefficients lie in
    one finite extension of \(H_{0,j}\). "The obstruction is therefore entirely
    the support condition."
  - Levelwise wording: \(\Delta\lambda\) is a fractional power of an image Novikov
    monomial, so it is not in \(J_j\); a power of it is, which suffices.
  - Placement: the memo's own plan renumbers Section 4, so its references by
    number would name the wrong objects; edits must be by label. Also: "the
    identical obstruction hits Lemma 4.9 (divisor tagging, p.23) ... Whatever
    repair the receiver gets, that lemma needs the same treatment."

### D14. Attacks on the hypothesis itself — none succeed

No document in the audited set exhibits a counterexample to Hypothesis 4.7H as
stated, and none claims to. The closest approaches are catalogued in section E.
The nearest thing to a negative on record is D1 (a perturbation of the block data
that drops the count from 2 to 0 — but it is a truncation of the connection, not
a bulk displacement) and the two discriminant loci of E3 (where the count can
change, but which are absent from the formal germ).

### D15. Attacks that landed in 4.7H's favour

- The memo's pessimistic claim that even \(X\times\mathbf P^1\) carries an
  \(O(q^{-1/r})\) tail is **struck** (B12).
- Standing hypothesis (H2) of the rigidity theorem is **deleted and replaced by a
  theorem** (B7; ledger row C912-M23 `resolved`).
- The base-map ambiguity of HYZZ Theorems 5.20/5.24 is **resolved** as a Novikov
  character, hence the manuscript's own divisor substitution (B13; C912-M17
  `resolved`).
- The frame-transport receiver problem is **resolved** as belonging to the bulk
  gauge alone, not the comparison (B1; C912-M14 `resolved`).

---

## E. Live attack surface — what could still make 4.7H FALSE

Ranked by how close each is to a genuine falsification, not by how much work it
would take to settle.

### E1. Block splitting or coalescence dropping \(\nu_6\) by two — the named primary danger

**Statement of the danger, verbatim** (memo lines 1135-1140):

> a coalesced block can *split* under the displacement, the splitting being
> governed by \(D_aU_i\), and if the rank-two block carrying \(\pm1/6\) split into
> simple blocks those would carry residue \(0\) by Theorem
> \ref{thm:simple-blocks} and \(\nu_6\) would drop by two. Proving that the
> reconstruction displacement does not do that, or does it in a count-preserving
> way, is the residual problem.

Status: **closed for rank-two coalesced blocks satisfying (H1), on the formal bulk
germ** (B6). **Open** for: (a) Jordan size \(m\ge3\), where the pole coefficients
below the deepest sub-diagonal are uncontrolled (B10); (b) derogatory blocks,
where the commutant argument fails at its first step; (c) semisimple coalesced
blocks; (d) any point not in the formal germ, including the reconstruction
displacement point itself if C-J1 is not repaired; (e) the locus where the
nilpotent part degenerates to zero, which memo lines 1980-1983 says "neither
[theorem] excludes".

Since a centre summand is an arbitrary smooth projective \(C\), (a)-(c) are not
edge cases for use site (1a): nothing restricts a centre's blocks to rank two.

### E2. Resonance in a semisimple coalesced block

memo lines 1874-1876: "nor a semisimple block, where the \(z^{-1}\) equation
instead reads \((I+\operatorname{ad}_R)(C_{a,0}-p_aI)=0\) and a resonance
\(\rho_i-\rho_j=-1\) must be excluded before the same conclusion follows."

No document in the audited set excludes this resonance, or checks whether it can
occur for the quantum connection of a smooth projective variety. A resonance is
exactly the mechanism by which a formal type changes discontinuously, so this is a
live route to falsity, not merely to unprovability.

A second resonance-flavoured item is on record as **passing**: the manuscript's
own cubic computation notes "The roots in (4.9i) are distinct modulo \(\mathbf Z\),
so \(L_{\rho+n}\) is invertible for every \(n\ge1\)" (04-one-step.tex:1262-1264) —
i.e. the cubic block is non-resonant. The red team asks for the general version:
"The regular-singular claim is unproved. 'Residue differences offset by integers …
are nonzero constants and cost nothing' is verified only in the cubic block, where
\(\det L_s=(s+1/6)(s+5/6)\) is constant. In general it needs the homogeneity
argument (residue eigenvalues are rational because the connection is graded);
state it." (§5(b)(2)).

### E3. The two discriminant loci, and the one place a count can RISE

`2026-08-15-c912-m1-ambiguity-computation.md` §4, computed exactly by the
committed script (script item 4):

- **\(4q_2=27q_1\).** "Here \(+2s\) collides with \(6r-2s\), and symmetrically
  \(-2s\) with \(-6r+2s\). This is the only place the carrier block meets another
  sheet. Crossing it, the carrier becomes a rank-three block and the rigidity
  theorem's hypotheses lapse." Ledger row C912-M20 `confirmed`; the crossing
  question is item 1 of that report's "Next, in order" and is **undecided**.
- **\(q_2=27q_1\).** "Here the two *simple* sheets \(6r-2s\) and \(-6r+2s\)
  collide, both at the value zero. This does not touch the carrier, but it creates
  a new coalesced block out of two blocks that carried nothing, so it is a place
  where the count could **rise** rather than fall. For the one-stabilization
  argument, which needs a lower bound, that is harmless; for the equality form of
  birational invariance of the count it is not." Ledger row **C912-M21, `open`**.

**This is the sharpest live threat to 4.7H specifically**, because 4.7H is stated
as an *equality* of multiplicities and both of the manuscript's operation formulas
(4.2) and (4.3) are equalities consumed in both directions. A locus where the
count rises is a documented mechanism for the equality to fail even where the
lower bound survives.

Both loci are **absent from the Novikov germ** by the filtration argument of B14
Prop 4 — they equate two distinct Novikov monomials — so they materialize only
after the Novikov parameters are specialized to numbers. Whether the manuscript's
use sites live on the germ side or the specialized side is exactly C-J1.

### E4. The topology mismatch (C-J1) — could make the hypothesis ill-posed rather than false

If the manuscript's \(w\)-filtration on \(B_j\) is not compatible with the graded
completion in which Iritani's and Iritani--Koto's change-of-variables and pullback
statements are proved, then "the positive-filtration bulk point" is not a point of
the space over which those theorems assert anything, and 4.7H is a statement about
an object whose existence the sources do not underwrite. Ranking: **the highest-value
item to settle**, because it decides whether the hypothesis is false, true, or
not-yet-well-posed. Repairable in principle by a lemma of exactly the shape the
hostile referee asks for (F1 below).

### E5. Use site (1b), the ambient summand, is undefended

The manuscript gives it one sentence (04-one-step.tex:637-638). Iritani's Theorem
5.18(6) gives \(\tau^\circ=q^{-1}[Z]+O(q^{-2})\), which by
`section10-hostile-referee.md` (CLAIM B, "What is right in it") is **purely** the
\(H^{\ge4}\) shape — no \(H^0\), no \(H^2\) — so neither the string-equation
invariance (B11) nor the divisor substitution (B13) touches any of it. Every
mitigating mechanism in the file applies to the parts of the displacement that are
already handled; the ambient displacement is entirely the unhandled part. Ranking:
**genuine gap, and the least defended of the four use sites.**

### E6. Accumulated displacement along a factorization chain

`section10-hostile-referee.md`, second pass, caveat at the end of the Claim A
discussion: "at each step past the first, the base parameter is
\(\tau_{i+1}(\cdot)\) evaluated at the accumulated parameter, not at \(0\). That
substitution is legitimate for the same reason Iritani's own pullback is — the
accumulated parameter has only \(H^{\ge4}\) components, each insertion costs at
least 2 in the dimension axiom, so only finitely many insertions survive per
Novikov degree — but it is a lemma, and it should be stated and proved rather than
assumed." Also: "Whether the *accumulated* displacement keeps the three shapes is
not in any source and does need the lemma noted above." Ranking: **repairable, but
unproved**; it bears on `thm:nu6-birational-invariance` rather than on 4.7H
directly.

### E7. Composite coefficient fields along a chain

`section10-hostile-referee.md`, "What I could not check": "Each blowup step
localizes at its own exceptional variable \(q_i\) ... and each projective-bundle
step introduces its own root \(q^{1/r}\). The memo never names the field
\(\Lambda\) at each step. I believe this is harmless for \(\nu_6\) (multiplicity
of a root of unity is stable under field extension) but I did not check that the
successive localizations are simultaneously realizable." Ranking: **probably
harmless, unverified.**

### E8. \(L\)-dependence of the manuscript's own weight

D4 shows the manuscript's instruction to "choose an integer \(L\) so large that ..."
maximizes the ratio \(w(\Delta\lambda)/\varepsilon\), which is precisely the wrong
direction for any convergence-based repair. This does not falsify 4.7H — the
manuscript asserts no convergence criterion — but it means the manuscript's chosen
normalization is the least favourable one for the most obvious future repair, and
that a repair may require changing the manuscript's own construction.

### E9. Frame junctions that do not line up (from section C), ranked

| Junction | Verdict | Rank |
|---|---|---|
| C-J1 Section 8 germ vs the displacement point | genuine break | 1 — decides whether any of B6-B8/B14 transfers at all |
| C-J8 three roles of \(q\) | repairable by naming; is the bookkeeping half of C-J1 | 2 |
| C-J3 KKPY Claim 6.15's polydisk + \(H^0\) conditions absent from the manuscript | repairable by stating them and adding the \(H^0\)-shift lemma | 3 |
| C-J5 Serre \(S^5=[3]\) vs \(S^3=[5]\) and the \(\lambda\mapsto-\lambda\) offset | convention break, unresolved (C912-M26 open); moot while the identification is unproved | 4 |
| C-J7 symbol reuse of \(r\), \(R\), \(E\), \(e\) | repairable by renaming; referee hazard | 5 |
| C-J10 sheared vs unsheared at import | aligned; must be stated if Section 8 is ever imported | 6 |
| C-J2 HYZZ base point | genuine break; already fatal to a route that has been abandoned | — |
| C-J4 half-parity gauge | aligned, handled in both places | — |
| C-J6 exponent normalization | aligned; one transcription error found in a note | — |
| C-J9 ramification bookkeeping | aligned | — |
| C-J11 turn on \(z\) alone | aligned; should be stated where additivity is used | — |

---

## F. What an independent proof would require

Verbatim where the documents give a list.

### F1. From `section10-hostile-referee.md`, "What a repair would have to establish"

> Not a rewrite request --- just the shape of the missing statement, so that the
> next version does not repeat the move:
>
> 1. A lemma saying exactly which elements may be substituted for
>    \(\widetilde\tau\) in Iritani's and Iritani-Koto's change of variables, proved
>    from the graded completion of §2.2 rather than from the word "invertible".
> 2. A separate lemma that \(\nu_6\) is invariant under \(H^0\) and \(H^2\) shifts
>    of the bulk parameter (string and divisor), stated as an invariance of the
>    framed monodromy, not as a normalization.
> 3. Solvability of the resulting reduced system in the negative-degree
>    coordinates only, with the convergence of the inverse substitution proved
>    degree by degree.

Item 2 is available today (B11 for \(H^0\), B13 for \(H^2\)); it needs writing as
a displayed lemma. Item 1 is C-J1/E4, the highest-value missing statement. Item 3
is the one the referee could not settle, with a tentative negative reading:
"homogeneity forces every order of the inverse series into the same \((Q^d,q^k)\)
slot, so convergence needs the Taylor coefficients of the inverse to vanish beyond
some order, and I found no mechanism in the sources that forces this. My tentative
reading is that it does *not* converge, but I would not stake the refutation on
it".

### F2. From `framing-compatibility-checks.md` §5 — the gap as a single statement

Quoted in full at B2. The operative demand is: show that the framed formal
monodromy of \(\nabla|_{\tau=\tau^\bullet}\) has the same primitive-sixth
multiplicity as \(\nabla|_{\tau=0}\), for \(\tau^\bullet\) the ambient
\(q^{-1}[Z]+O(q^{-2})\) or the centre \(O(q^{-1/(c-1)})\) tail plus \(s_j\).

### F3. From the memo's own route list (`framing-compatibility-checks.md` §6)

> 1. **Birkhoff route.** The identity \((\Phi^\circ)^{-1}\circ M=M'\circ\Phi^{-1}\)
>    of Iritani--Koto Section 5.8 (and Iritani Section 5.8.2) already factors the
>    bulk transport into a \(z\)-regular factor and an \(\mathrm{id}+O(z^{-1})\)
>    factor. The \(z\)-regular factor transports framed monodromy by the memo's
>    theorem. What has to be shown is that the \(\mathrm{id}+O(z^{-1})\) factor
>    does not change the primitive-sixth multiplicity — a \(z=\infty\)-side
>    statement about a \(z=0\) invariant, so it is not automatic, but it is a
>    sharply posed and standard-shaped question, unlike the receiver inequality.

The blockwise route (item 2 there) has since been carried out for rank two and is
B6-B8; item 3 has been proved and is B3.

### F4. What the size-\(m\) extension needs (memo `sec:jordan-size`, lines 1858-1876)

Verbatim:

> What must be supplied to turn this into a proof is that the decoupling gauge of
> Step 1 respects the grading on the zero block: the analogue of
> Lemma \ref{lem:duality-gauge} with \(\mu\) in place of \(G\). Uniqueness is
> again the device, but the argument is not verbatim, because the
> \(\mathbf C^\times\) action generated by \(\mu\) scales the nonzero eigenvalues
> of \(U\) rather than fixing them, so it moves the other blocks and the
> equivariance has to be stated for the whole decoupling problem before
> restricting to \(H_0\). With the base point settled that way, propagation over
> the germ should be Theorem \ref{thm:no-irregularity}'s flatness argument applied
> to the pole coefficients in order of depth; the shape to expect is that each
> satisfies a linear equation whose remaining terms involve only deeper
> coefficients, already known to vanish, but that triangular structure is a
> computation this memo has not done.
>
> None of this covers a derogatory block, where the commutant is larger than
> \(B[N]\) ... nor a semisimple block, where ... a resonance \(\rho_i-\rho_j=-1\)
> must be excluded before the same conclusion follows.

### F5. From `det-r-pairing-and-serre-lattice.md` §6, "Next, in order"

> 1. Run the genus-six test of Section 4. — **DONE and passed**
>    (`2026-08-15-c912-gm-genus-six-serre-test.md`).
> 2. Resolve the `S^3 = [5]` versus `S^5 = [3]` reading at the source. — **OPEN**
>    (C912-M26).
> 3. If the identification survives, restate step (iii) of the atom route in its
>    terms: no atom of a smooth projective surface carries a primitive-sixth Serre
>    eigenvalue.
> 4. Delete (H2) from the memo's rigidity section and record Theorem 2 there, and
>    carry out the size-`m` extension the scope remark asks for. — item 4's first
>    half is **DONE**; the size-\(m\) extension is F4 and is **OPEN**.

Also recorded there, and it bounds one whole family of attacks:
**Proposition 3, a no-go.** "After the shearing \(S=\operatorname{diag}(1,z)\) the
pairing becomes \(G^{(z)}=zcJ+O(z^2)\) ... The duality relation at leading order
reads \(R^TJ+JR=-J\), that is, \(R+I/2\) lies in \(\mathfrak{sp}(2)\). Since
\(\mathfrak{sp}(2)=\mathfrak{sl}(2)\), this is exactly \(\operatorname{tr}R=-1\)
and imposes no condition on \(\det R\)." Ledger row C912-M24 `confirmed`. So the
whole primitive-sixth count reduces to the single scalar \(\det R\), and **no
purely formal pairing argument can pin it**: "Any formula for it must import
something beyond the flat structure."

### F6. From `m1-ambiguity-computation.md` §8, "Next, in order"

> 1. Decide the crossing question at `4 q_2 = 27 q_1`. At that locus the carrier
>    is a rank-three block with a known degeneration, and the finite computation is
>    of the same shape as the rigidity section's: shear, check that no irregularity
>    appears, and read the residue. This is the last piece of the one-stabilization
>    base-point statement.
> 2. Pointwise vanishing over the components of atoms of surfaces, curves and
>    points. This is where the ledger's other side is, and it is not helped by
>    anything above.
> 3. Only then revisit the Serre decoration ...

Note item 1 requires the \(m=3\) machinery, which by B10/F4 does not yet exist.

### F7. The two reframings that attack the hypothesis rather than the route

Both from `m1-ambiguity-computation.md`'s addendum, and both still unattempted.

1. **Replace the equality by an identity with a nonnegative remainder.** "The
   one-stabilization theorem consumes only a lower bound ... Making that
   accounting an exact identity with a nonnegative defect term would change what
   has to be proved from invariance to one-sidedness, and would deliver a
   stability statement as a by-product. This is the highest-value reframing
   available, because it attacks the hypothesis rather than the route to it."
   This audit's A.6 supports it: 4.7H as stated is stronger than the endpoint
   needs, and E3's `q_2=27q_1` locus threatens only the equality direction.
2. **State the theorem relative to a marked datum and publish the ambiguity
   ledger** — "a chosen sheet of the spectral cover, equivalently a chosen square
   root of the Novikov variable — and ... record the residual ambiguity
   explicitly. Section 2 above supplies the first entry of that ledger, and it is
   trivial."

**A recorded negative, so it is not re-entered** (same addendum): the naive
integral-lattice route to discreteness fails, because "the eigenvalues of the
topological monodromy are not those of the formal monodromy once the Stokes
matrices are nontrivial. In rank two with exponential factors \(e^{\pm1/z}\) and
trivial formal monodromy, the Stokes matrices \(\begin{pmatrix}1&a\\0&1\end{pmatrix}\)
and \(\begin{pmatrix}1&0\\b&1\end{pmatrix}\) give topological monodromy of trace
\(2+ab\), not \(2\)."

### F8. Items this audit marks UNRECONSTRUCTED

- **04-one-step.tex:523-527**, that after removing the unit and fixed divisor the
  target bulk coordinate lies in \(J_jH^*(C)\). Rests on Iritani (5.45), (5.47)
  and (5.27)-(5.30). Not read at the source in this audit and not covered by any
  audited note. This is the step that makes use site (1a) a *positive-filtration*
  displacement at all, so it is load-bearing for the hypothesis's own statement.
- **The extension of `thm:transport` to formal bulk parameters** (memo line 1527).
  Asserted; the missing part is the verification that the theorem's two hypotheses
  survive adjoining \([[t]]\) to the coefficient field.
- **Base change of `thm:bulk-constancy` along a strictly Novikov-admissible
  \(\chi\)** — needed to point B15 at use site (2). No document addresses it.
- **The manuscript's compatibility of its \(w\)-filtration with the sources'
  graded completion** (C-J1/E4). Not stated anywhere; the missing part is a lemma
  of the shape F1 item 1.
