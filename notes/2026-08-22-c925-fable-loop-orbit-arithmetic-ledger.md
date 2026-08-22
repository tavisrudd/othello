# C925 parallel ledger: loop-orbit arithmetic, prime reduction, closed lenses

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-22
**Branch/worktree:** `c925-fable` (parallel to Sol's indirect-strategy work; all
files carry a `-fable-` slug or a new Lean module name to avoid collisions).

This is a hypothesis-and-source ledger for one bounded direct-route pass on the
live frontier (task card `Next` item 3: the row-free loop-stabilizer
centre-exclusion theorem).  Each claim lists what it assumes, where the
assumption is sourced, and what Lean checks.

## 1. Prime reduction of the all-`m` exclusion

**Claim.**  To prove irrationality of \(B\times\mathbf P^m\) for every
\(m\ge1\) it suffices to prove it for every \(m\) with \(\ell=m+1\) prime; and
for such \(m\), the only correction-ledger points that can share the source
stabilizer are those whose *internal* (centre-side) period is exactly
\(\ell\).  The Kummer index can never carry the prime.

**Hypotheses and sources.**

| Tag | Hypothesis | Source / status |
|-----|------------|-----------------|
| H1 | Rationality of \(B\times\mathbf P^m\) implies rationality of \(B\times\mathbf P^{m'}\) for all \(m'\ge m\). | Elementary (\(\mathbf P^{m'}\) is birational to \(\mathbf P^m\times\mathbf P^{m'-m}\)). Already used by the card ("any unbounded stabilization subsequence implies all m"). |
| H2 | A correction point is indexed by an internal index and a Kummer index, and the transported source loop acts diagonally on the pair. | Iritani, arXiv:2307.13555v3, Thm 5.18 (\(r-1\) centre factors over \(\mathbf C[z]((q^{-1/s}))[[Q,\tilde\tau]]\), root denominator (5.11)); dossier D3. The *diagonal* form of the loop action is an assumption of the consumer, not a theorem. |
| H3 | The Kummer-index period of a correction point is at most \(s\le 2(r-1)\) and, for a centre carrying a marked block, is never the prime \(\ell=m+1\). | Weak factorization centres in an \((m+3)\)-fold have \(\dim Z\le m+1\) (AKMW, dossier D4); marked blocks need \(\dim Z\ge3\) (C924 audit: curves have \(\delta^\sharp=0\); surfaces are simple, ruled, or nef-\(K\) with even rank \(\ge3\)). Hence \(r-1\le m-1<\ell\). Iritani's Theorem 5.18 indexes the centre factors by \(j=0,\dots,r-2\) with maps \(\varsigma_j\) landing in \(H^*(Z)((q^{-1/(r-1)}))[[Q,\tilde\tau]]\), so the Kummer orbit has order dividing \(r-1\); the denominator \(s=2(r-1)\) for odd \(r\) (5.11) only reflects \(\deg q=2(r-1)\) in the coefficient ring. Checked against `/tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt` (statement of Thm 5.18 and (5.11)). |
| H4 | Stabilizer/period equality is preserved by the equivariant stable-ledger bijection. | `TwoLayerDescentPacket.sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods` (kernel-checked consumer). |

**Lean.** `Comparison/LoopOrbitArithmetic.lean`
(namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.LoopOrbitArithmetic`):

- `hasPowerFixednessPeriod_prod` — diagonal pair period is `Nat.lcm p s`.
- `period_eq_of_hasPowerFixednessPeriod` — periods are unique.
- `left_eq_prime_of_lcm_eq_prime` — \(\operatorname{lcm}(p,s)=\ell\) prime, \(s\ne\ell\) ⟹ \(p=\ell\).
- `internal_period_eq_prime_of_pair_period_prime` — the consumer form.

**What this changes.**  The residual geometric gate for the all-\(m\) theorem
becomes, for one prime \(\ell\) at a time:

> (\(\ell\)-cycle exclusion) No smooth projective \(W\) with \(\dim W\le\ell\)
> carries a marked block \((2,N\ne0,\delta^\sharp=4/9)\) whose internal period
> under the transported source loop is divisible by \(\ell\).

For \(\ell=3\) this is the card's "absence of a correction three-cycle".  The
reduction does not make the gate easier in kind, but it removes every mixed
internal/Kummer coincidence and every composite-period case from the target.

## 2. Sheet-count coincidence at `m = 5`

**Claim.**  A centre of the form (marked threefold)\(\times\mathbf P^k\) of
codimension \(r=m-k\) in an \((m+3)\)-fold contributes \((k+1)(r-1)=(k+1)(m-k-1)\)
marked sheets; the source contributes \(m+1\).  These agree exactly when
\(m=5\), \(k\in\{1,2\}\): the centres \(B\times\mathbf P^1\) (codimension 4,
Kummer order 3) and \(B\times\mathbf P^2\) (codimension 3, Kummer order 2)
inside an 8-fold both carry six marked sheets, and \(\mu_2\times\mu_3\cong\mu_6\)
is cyclic.  Sheet counts and cyclicity alone therefore cannot separate the
ledgers at \(m=5\); the exclusion there must use which loop acts.

**Lean.** `mul_eq_add_add_one_iff` and `centre_sheet_count_eq_source_iff`
(same module): the equation \((k+1)(m-k-1)=m+1\) with \(k+2\le m\) holds iff
\(m=5\wedge k\in\{1,2\}\).

**Consequence.** Choosing \(\ell=m+1\) prime (Section 1) removes this case:
for \(\ell\) prime, \((k+1)(m-k-1)=\ell\) forces \(k=0\) or \(k=m-2\), both
impossible.

## 3. Closed lens: the grading cocharacter as a canonical loop

**Idea tested.**  Arbitrary Novikov loops do not transport coherently through
the telescope, but the grading does: Iritani's comparison is homogeneous
(Prop. 5.1, dossier D3).  Could the anticanonical cocharacter serve as the
canonical loop carrying the source period?

**Why it fails.**

1. Every Euler eigenvalue is homogeneous of degree one, so the full grading
   loop \(q\mapsto e^{2\pi i\,\deg q}\,q\) acts trivially on every sheet of
   every variety.  It carries no period.
2. A fractional cocharacter \(c_1/d\) exists only when \(c_1\) is divisible by
   \(d\); for \(B\times\mathbf P^m\), \(c_1=2H_B+(m+1)h\) has divisibility
   \(\gcd(2,m+1)\), which is 1 for even \(m\).  Divisibility is not preserved
   under blow-up (\(c_1(\tilde X)=\pi^*c_1(X)-(r-1)E\)), so the fractional
   loop is not telescope-canonical either.
3. By homogeneity the \(z\)-loop equals the inverse grading loop; its action
   on the marked block is the formal monodromy with exponents
   \(-1/6,-5/6\) (residue trace \(-1\), determinant \(5/36\); C924 audit).
   That is exactly the existing marker \(\delta^\sharp=(2/3)^2=4/9\), not a new
   invariant.

**Status.** Closed. Do not reopen without a cocharacter that is both
telescope-canonical and fractional on the source.

## 4. Why period arithmetic alone cannot close the residual gate

For a prime \(\ell\) the residual gate asks for a \(\le\ell\)-fold with a
marked block of internal period divisible by \(\ell\).  Period arithmetic does
not exclude this: if marked blocks arise only as (cubic block)\(\otimes\)(a
semisimple sheet of a cofactor \(Y\)), a toric \(Y\) of dimension \(\ell-3\)
with a cyclic \(\ell\)-orbit of sheets under *some* loop exists for every
\(\ell\ge5\).  The exclusion must therefore use the specific transported loop,
i.e. the coherence datum the card already identifies as the open provider.
Nothing in this ledger changes that diagnosis.

## 5. Incidental observations (not logged to the shared discovery track yet)

Recorded here to avoid a concurrent edit of the shared append-only log; promote
or log after merge.

- **Kuznetsov-component shadow.** The marked block's formal exponents
  \(-1/6,-5/6\) and rank 2 match the Kuznetsov component
  \(\mathcal Ku(B)\) of a cubic threefold: numerical \(K_0\) of rank
  \(4-2=2\), and Serre functor with \(S^3\cong[5]\) (fractional
  Calabi–Yau dimension \(5/3\)). The \(m+1\) marked sheets of
  \(B\times\mathbf P^m\) then shadow the \(m+1\) components
  \(\mathcal Ku(B)\boxtimes\mathcal O(i)\), cyclically permuted by
  \(\otimes\mathcal O_{\mathbf P^m}(1)\), which is the Gamma-framing
  large-radius monodromy.  Not checked against the lane's dossiers; the
  Serre-functor statement needs a pinpoint citation before use.
- **Fibrewise contrast.** \(B\times\mathbf P^m\) rational is strictly weaker
  than \(B_{\mathbf C(\mathbf P^m)}\) being rational over
  \(\mathbf C(\mathbf P^m)\); the fibrewise statement follows from the
  Clemens–Griffiths method over non-closed fields (Benoist–Wittenberg), the
  stable statement does not.  The loop-stabilizer route is, in effect, an
  attempt to recover the \(\mathbf P^m\)-direction that a non-fibrewise map
  discards.  Orientation only; no new lever.

## 6. Validation and replay

- Single-file elaboration (smoke-level: against the main tree's built
  dependencies, no gate build):
  `lean/scripts/guarded-lean --root papers/cubic-stabilization-irrationality/lean papers/cubic-stabilization-irrationality/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/LoopOrbitArithmetic.lean`
  — exit 0, no warnings, run
  `~/.cache/othello-lean-build/guarded-lean/20260822-080721-*`.
- Not yet registered in `lakefile.toml` roots, the reviewer target, or
  `Verification/AxiomAudit.lean`: those files carry uncommitted foreign edits
  in the main tree at the time of writing. Register at merge, then rerun the
  guarded aggregate and axiom audit.

## 8. Explicit loop transport along one edge (derived, unverified in Lean)

Iritani's ring extension (1.1) is monomial:
\(e^{\tilde d}\mapsto Q^{\varphi_*\tilde d}q^{-[D]\cdot\tilde d}\) on the
ambient side and \(Q_Z^{d}\mapsto Q^{\iota_*d}q^{-\rho_Z\cdot d/(r-1)}\) on
the centre side, with \(q\) the class of a line in the exceptional divisor
\(D\) and \(\rho_Z=c_1(N_{Z/X})\).  A cocharacter
\(\gamma\in H^2(\tilde X,\mathbf Z)\) therefore acts on every summand through
explicit restricted cocharacters:

| Edge | Decomposition | Ambient summand sees | Centre summand sees | Kummer shift |
|------|---------------|----------------------|---------------------|--------------|
| blow-up \(X\to\tilde X=\mathrm{Bl}_ZX\), loop \(\gamma\) on \(X\) | \(\tilde\gamma=\pi^*\gamma\) | \(\gamma\) | \(\iota^*\gamma\) | \(0\) |
| blow-down \(\tilde X\to X'\), loop \(\gamma\) on \(\tilde X\) | \(\gamma=\pi^*\gamma'+aE\) | \(\gamma'\) | \(\iota^*\gamma'+\tfrac{a}{r-1}\rho_Z\) (fractional) | \(a \bmod (r-1)\) |

Since \(H^2(\tilde X)=\pi^*H^2(X')\oplus\mathbf ZE\), the source loop
\(\gamma_0=h\) (the \(\mathbf P^m\) hyperplane cocharacter) descends
canonically through the whole telescope; no choice is made at any edge.  The
Kummer deck generator acts on the centre's inner packet by the monodromy of
the fractional cocharacter \(\rho_Z/(r-1)\), which is trivial exactly when
\(\rho_Z\cdot d\equiv0\pmod{r-1}\) for all \(d\) (e.g. trivial normal
bundle, as in the \(B\times F_1\) test); the dossier's "triviality of the
external Kummer action on the inner packet" (D3, NOT PROVIDED) is thus not
a hypothesis to assume but a computable quantity.

**Hypotheses this rests on.**

| Tag | Hypothesis | Source / status |
|-----|------------|-----------------|
| T1 | \(\Psi\) intertwines Euler eigenvalue functions, so Puiseux exponents of marked sheets match across the edge. | Thm 5.18(1) (commutes with the quantum connection) and (3) (homogeneity of degree 0 on the ambient, \(-r\) on the centre summand). Derived; the exponential shift on centre factors is the Kummer term. |
| T2 | \(\Psi\) is equivariant for the semilinear inertia action of \(q\mapsto e^{2\pi i}q\) (the Kummer deck), with the centre factors permuted \(j\mapsto j+1\). | Expected from uniqueness of \(\Psi\) given its initial conditions (Thm 5.18, §5.8.1) and the canonical maximal-F-bundle characterization (KKPYY Thm 4.1, 4.5): the conjugate of \(\Psi\) by the deck is another comparison with the same characterization.  **Unverified**: the uniqueness statement must be checked to cover semilinear conjugates. |
| T3 | Marked sheets are intrinsic (spectral-extension uniqueness). | Existing: C924 / dossier D3 marked-projector square. |

## 9. The \(\ell=3\) gate after Sections 1 and 8

For \(m=2\) (ambient 5-fold) a correction point with period 3 must come from a
blow-down centre \(Z\) with \(\dim Z\le3\) and a marked block, hence
(C924 audit) \(\dim Z=3\), \(r=2\), no Kummer index at all.  Its marked
sheets must contain a 3-orbit under the integral cocharacter
\(\iota^*\gamma'+a\rho_Z\in H^2(Z,\mathbf Z)\), so \(Z\) has at least three
marked rank-2 blocks and \(b_{\rm even}(Z)=2+2b_2(Z)\ge6\), i.e.
\(b_2(Z)\ge2\).  Blow-ups of a threefold along points and curves add only
unmarked sheets (rank-one sheets, and \(\delta^\sharp=0\) curve blocks), and
the loop projects along the blow-down, so the 3-orbit descends to a marked
3-orbit on a Mori fibre space \(W_{\min}\) with \(b_2(W_{\min})\ge2\):

1. a Fano threefold with \(\rho\ge2\) (Mori–Mukai, finitely many families),
   with a multi-parameter small quantum product exhibiting three conjugate
   marked \(J_2\) blocks under one integral cocharacter;
2. a del Pezzo fibration over \(\mathbf P^1\) with \(\rho=2\); or
3. a conic bundle over a surface \(S\) with \(\rho(W)=\rho(S)+1\).

Case 1 is a finite check in principle but needs the full multi-parameter
small quantum product, not the one-variable quantum period (the grading loop
is trivial on sheets, Section 3).  Cases 2–3 have no general quantum
product computation; the cubic itself is a conic bundle over \(\mathbf P^2\),
so case 3 contains the source geometry.  This is the exact residue of the
\(\ell=3\) instance of the card's open provider; the Mori shortcut closed in
dossier D12 is not reopened, since nothing here asserts a length-three ray.

## 10. Suggested next step on this branch

With H3 settled, Section 1 holds for every prime \(\ell=m+1\) under H2 and
H4.  The remaining work is the \(\ell\)-cycle exclusion itself, which is the
card's open geometric provider restated for one prime.  The cheapest test of
the diagonal-action hypothesis H2 is the \(B\times F_1\) finite source test in
the card's `Next` item 3, now with the prime \(\ell=3\): its exceptional
factor is Hensel-unramified over \(F[[t]]\) and the codimension is 2, so
once the marked correction block is identified as \(U_B\otimes L_{\rm exc}\)
(the card's tensor-projector input) both its Kummer and internal periods are
1, and `internal_period_eq_prime_of_pair_period_prime` excludes it.
