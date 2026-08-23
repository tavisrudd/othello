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
| T2 | \(\Psi\) is equivariant for the semilinear inertia action of \(q\mapsto e^{2\pi i}q\) (the Kummer deck), with the centre factors permuted \(j\mapsto j+1\). | Expected from uniqueness of \(\Psi\) given its initial conditions (Thm 5.18, §5.8.1) and the canonical maximal-F-bundle characterization (KKPYY Thm 4.1, 4.5): the conjugate of \(\Psi\) by the deck is another comparison with the same characterization.  Iritani §5.8 (text before Remark 5.19, and §5.8.1) states that \(\Psi,\tau(\tilde\tau),\varsigma_j(\tilde\tau)\) are uniquely reconstructed from their initial conditions at \(Q=\tilde\tau=0\) and the genus-zero invariants of \(X\) and \(Z\); the initial condition (5.44) is built from integer powers \(q^{-k}\) and the root-indexed \(\varsigma_j\).  Hence the deck conjugate satisfies the initial condition with \(j\mapsto j+1\), and uniqueness gives equivariance.  **Remaining check:** write out that (5.44) is deck-covariant with exactly that permutation (the \(\mathrm{FT}_{Z,j}\) depend on \(q^{1/(r-1)}\) through the choice of root). |
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

## 11. Creative pass: reformulation, toric cycle lemma, falsification experiment

### 11.1 Loop-independent form of the residual gate

If \(\ell\nmid r-1\), the \(\ell\)-part of a point's period under the
fractional cocharacter \(\iota^*\gamma'+\tfrac a{r-1}\rho_Z\) equals its
\(\ell\)-part under the integral cocharacter \((r-1)\iota^*\gamma'+a\rho_Z\)
of \(Z\)'s own torus (pullback along a degree prime to \(\ell\) cannot create
or destroy \(\ell\)-torsion in a Kummer orbit).  Hence, under T1–T3 and H1–H4,
the all-\(m\) theorem for \(m+1=\ell\) prime is **equivalent** to:

> **Marked prime-cycle dimension bound (conjecture).** If a smooth projective
> \(d\)-fold has, under some integral cocharacter of its Novikov torus, a
> cyclic orbit of prime length \(\ell\) consisting of marked
> \((2,N\ne0,\delta^\sharp=4/9)\) blocks, then \(d\ge\ell+2\).

\(B\times\mathbf P^{\ell-1}\) saturates the bound.  This removes every
reference to the transported loop from the gate: it is now a statement about
one variety and its own Novikov torus.  The transport (Section 8) is what
justifies dropping the loop.

### 11.2b Rotation orders of del Pezzo mirrors avoid every prime at least five

This supersedes the loose formulation in 11.2 below and is the structural
statement behind the scan of 11.3.

Let \(W=\sum_i a_ix^{v_i}\) be a Laurent mirror of a del Pezzo surface of
degree at least three; its Newton polygon \(P\) is reflexive, the origin is
its unique interior lattice point, and the origin is not in the support
(Coates–Corti–Galkin–Kasprzyk, Minkowski polynomials).  A cocharacter is a
height function on the support; the critical points cluster over the cells of
the induced regular subdivision, and over a cell \(C\) the leading behaviour
is governed by \(W_C=\sum_{v_i\in C}a_ix^{v_i}\).

If the support points of \(C\) span a sublattice of index \(m\) in \(N\), the
dual \(\mu_m\)-action on the torus scales \(W_C\) by a primitive \(m\)-th root
of unity, so it permutes the critical values of \(W_C\) in orbits of size
\(m\): the boundary monodromy has \(m\)-cycles over \(C\).  Two consequences
sharpen this into a usable bound.

1. **Only the central cell rotates.**  The support omits only the origin, so
   for a cell not containing the origin the support points are all of its
   lattice points, and the lattice points of a lattice polygon span \(N\);
   such a cell contributes no rotation.  At most one cell of a subdivision has
   the origin in its interior, so at most one cell of any boundary limit
   produces cycles.
2. **The available orders are 3-smooth.**  Enumerating every reflexive polygon
   and, inside each, every sub-polygon with the origin in its interior
   (`notes/cubic-threefolds-tasks/c925-fable-reflexive-cell-bound.py`): with
   the full support in the cell the orders realized are exactly \(1,2,3\);
   in the worst case, where only the cell's vertices lie in the support, they
   are \(1,2,3,4,6,8,9\).  **No order in either list is divisible by 5, 7, 11,
   or 13.**  Every realizable order has the form \(2^a3^b\).

So the first-order rotation of a del Pezzo boundary limit can never have order
divisible by a prime \(\ell\ge5\).  This is the conceptual reason the scan of
11.3 sees only cycle lengths \(1,2,3,4\), and it predicts that 6, 8 and 9 will
appear in larger boxes while 5 and 7 never will.

**What is still open.**  A cycle length is the product of the rotation orders
of the successive Newton–Puiseux stages, and stages after the first are not
governed by a reflexive polygon; the observed 4 is exactly such a product
\(2\times2\).  The enumeration above bounds the first stage only.  The
multiplicity certificate of 11.3 bounds all stages at once but is a finite
check on one box.  A proof of the surface case at every prime needs either a
reflexivity statement for the later stages or a direct argument that the total
ramification of the spectral cover of a del Pezzo is 3-smooth.  The mirror
identification itself (Givental's theorem for del Pezzos, and the tropical
clustering statement) is quoted, not verified here.

### 11.2c The dimension bound is Kobayashi–Ochiai

The enumeration of 11.2b says more than "no prime at least five".  With the
full support in the cell the realized orders are exactly \(1,2,3\), and
\(3=\dim+1\) for a surface.  That is not a coincidence: for the whole polygon
the rotation order is the index of the Gorenstein toric Fano with that fan
polytope, and \(3\) is attained only by \(\mathbf P^2\).

This identifies the governing classical theorem.  Kobayashi–Ochiai: a Fano
manifold of dimension \(d\) has index \(r\le d+1\), with \(r=d+1\) only for
\(\mathbf P^d\) and \(r=d\) only for a quadric; the same bound holds for
Gorenstein canonical Fanos.  Reading the rotation order at a boundary limit as
the index of the limiting Fano therefore gives

> a boundary limit with rotation order \(\ell\) needs a limiting Fano factor
> of index \(\ell\), hence of dimension at least \(\ell-1\), with equality
> only for \(\mathbf P^{\ell-1}\).

Combined with the marked block, this **derives the dimension bound conjectured
in 11.1 and gives its extremal case**: a marked \(\ell\)-cycle needs the cubic
factor, which contributes dimension 3, tensored with an index-\(\ell\) factor,
which contributes dimension at least \(\ell-1\).  Total dimension at least
\(\ell+2\), attained by \(B\times\mathbf P^{\ell-1}\) and by nothing else of
that dimension.  The tensor form \(U_B\otimes L_i\) is the same one the task
card already uses for the \(B\times F_1\) source test.

**The bound closes every \(m\) at once.**  Combine it with the prime reduction
of Section 1.  Take \(m\) with \(\ell=m+1\) prime.  The ambient variety along
the factorization has dimension \(m+3\), so a smooth blow-up centre has
dimension at most \(m+1\).  A correction point sharing the source stabilizer
must carry a marked \(\ell\)-cycle, which by the bound needs dimension at
least \(\ell+2=m+3\).  Since \(m+1<m+3\), no admissible centre can carry it,
and the source and target ledgers are separated.  The remaining \(m\) follow
because rationality of \(B\times\mathbf P^m\) propagates upward, so the primes
suffice.

For \(m=2\) this is the exclusion of a correction three-cycle that the task
card records as the open local gate: the only 5-fold carrying a marked
3-cycle is \(B\times\mathbf P^2\) itself, and a centre in a 5-fold has
dimension at most 3.  The same sentence, with \(\ell\) in place of 3, is the
all-\(m\) statement; the argument is not specific to \(m=2\), so \(m=2\) and
all-\(m\) now stand or fall together on the gap below.

**Confirmation on the cubic itself.**  The identification can be tested where
it matters most.  The marked block of the cubic threefold has characteristic
polynomial \(\chi_K=T^2(T^2-108q)\) (audit of the direct-QDM proof,
`../2026-08-19-c924-direct-qdm-proof-audit.md`), whose nonzero roots are
\(\pm\sqrt{108q}\).  Their Puiseux exponent in \(q\) is \(1/2\), so the
boundary monodromy of the marked sheets has ramification exactly 2 — and the
Fano index of a cubic threefold is exactly 2.  The prediction "rotation order
equals the index" is therefore verified on the one marked block the whole
programme depends on.  Likewise \(B\times\mathbf P^m\): the projective factor
contributes rotation order \(m+1\), giving the \((m+1)\)-cycle of marked
blocks that is the source ledger's defining feature.

**Borderline case, and why it still closes.**  The dimension count assumes the
marked and the rotating structure sit on different tensor factors.  They can
coincide only if one variety is both marked and of rotation order \(\ell\).
For \(\ell=3\) and a threefold centre this needs index 3 in dimension 3, and
Kobayashi–Ochiai says index equal to dimension forces a quadric.  The quadric
threefold is already on record as unmarked: Pech–Rietsch's quantum Chevalley
table gives \(H^4=4qH\), so \(Q^3\) carries rank-one semisimple sheets and not
the rank-two marked atom (D12 of the no-Stokes dossier).  So even the
borderline case is excluded, by classification rather than by the count.

**Gap to close.**  Three steps are quoted rather than proved: that the
boundary rotation order of the spectral cover equals the index of the limiting
Fano (proved above only in the toric mirror picture, and only for the first
Newton–Puiseux stage); that stage orders multiply to give the total cycle
length, so that a prime \(\ell\) in the total forces \(\ell\) in some stage;
and that the marked and rotating factors of a tensor block can be separated as
the card's \(B\times F_1\) argument separates them.  The first is the
substantial one.  None of this is formalized.

### 11.2 Toric sheet cycles are cell torsion (unmarked analogue)

*Superseded by 11.2b: the torsion must be computed from the support points in
the cell, not from all its lattice points, and only the cell containing the
origin can contribute.  The \(F_3\) caution below stands.*


For a smooth Fano toric \(Y\) the Euler sheets are the critical points of the
mirror Laurent polynomial \(W=\sum_i x^{v_i}\) over the fan polytope, and a
cocharacter \(\beta\) is a height function \(v_i\mapsto\beta_i\).  Along the
loop in \(\beta\) the critical points cluster over the cells of the induced
regular subdivision; on a cell \(C\) with affine heights the rescaling
\(x\mapsto x\,t^{u}\) with \(\langle u,v\rangle+\beta(v)\) constant on \(C\)
solves \(u\in N\otimes\mathbf Q\), and the monodromy permutes the cell's
critical points through the class of \(u\) in the finite group
\(N/\langle v-v'\colon v,v'\in C\rangle\).  So prime cycle lengths are element
orders of these cell-torsion groups: for \(\mathbf P^d\) the simplex gives
\(\mathbf Z/(d+1)\); for the five toric del Pezzos every lattice triangle on
rays has normalized area \(\le3\) and non-simplicial cells have trivial
torsion, so no prime cycle exceeds 3.  **Caution:** the picture fails outside
the Fano range — for \(F_3\) the triangle
\(\{(1,0),(0,1),(-1,-3)\}\) has area 5 but \(\chi(F_3)=4\); the Jacobian
ring of \(W\) overcounts the sheets when \(-K\) is not nef.  Status: derived,
not formalized; the Fano-range claim should be checked against Givental's
mirror theorem before any use.

### 11.3 Falsification experiment for the strategy at \(\ell=5\)

A rational surface \(Y\) with a cyclic 5-orbit of Euler sheets under an
integral cocharacter would make \(Z=B\times Y\) a 5-fold carrying a marked
5-orbit (tensor with the cubic block; \(\delta^\sharp\) is shift-invariant).
For \(m=4\) the ambient is a 7-fold and \(Z\) has codimension 2, so it is an
admissible blow-down centre with no Kummer index.  The stabilizer ledger then
cannot separate that correction from the source, and the conjecture in 11.1
fails at \(\ell=5\) with \(d=5<7\).  Toric del Pezzos are safe (11.2).  The
open test is the non-toric del Pezzos \(\mathrm{Bl}_k\mathbf P^2\),
\(4\le k\le8\): their small quantum products follow from genus-zero
invariants (Göttsche–Pandharipande recursion), and one must decide whether any
integral cocharacter of the rank-\((k+1)\) Novikov torus has a 5-cycle on the
\(k+3\) sheets.  A 5-cycle would show that the loop-stabilizer route needs an
embedding or normal-bundle argument for every prime \(\ge5\); no 5-cycle
(and none for 7 on \(k\le8\)) would support 11.1 for surfaces.

**Run (this branch).**  The small quantum product of \(\mathrm{Bl}_k\mathbf P^2\)
needs only classes with \(c_1\cdot\beta\in\{1,2,3\}\); by adjunction and
connectedness these are the \((-1)\)-classes, the conic classes
(\(\beta^2=0\)), and the line-type classes (\(\beta^2=1\)), each with
invariant 1 (Göttsche–Pandharipande; the counts are classical).  Scripts:
`notes/cubic-threefolds-tasks/c925-fable-dp-sheet-cycles.py` (class
enumeration, product matrices, numeric boundary-monodromy tracker),
`c925-fable-dp-puiseux-check.py` (exact lower Newton polygon of the
characteristic polynomial of \(c_1\ast\) along \(z_j=z_{0,j}t^{b_j}\), edge
factorization, one further Newton–Puiseux step at rational repeated roots),
and `c925-fable-dp-newton-scan.py` (the exact method over a box of
cocharacters).  Sanity: \(F_1\) reproduces the 3-cycle and the pair of
2-cycles; class counts for \(k=4\) are \(10/5/5\).

Findings so far:

- The numeric tracker with a large-radius fallback reported 5-cycles on
  \(\mathrm{Bl}_4\mathbf P^2\) for \(b=(0,1,1,0,-1)\) and on
  \(\mathrm{Bl}_5\mathbf P^2\) for \(b=(-1,0,-1,-1,0,0)\) and
  \(b=(0,-1,1,0,1,-1)\).  All three are **refuted exactly**: the Newton
  polygons have edges of lengths \(3,3,1\) (resp. \(3,5\); \(3,4,1\)) with
  slopes \(2/3,1,2\) (resp. \(2/3,1\); \(2/3,1,2\)), and every integral-slope
  edge polynomial splits into distinct rational linear factors, so those
  branches are unramified.  The true cycle types are \((3,1^4)\) and
  \((3,1^5)\).  Large-radius loops cross the discriminant; the exact method is
  authoritative.
- Exact scan, box \(|b_j|\le1\): certified cycle lengths on resolved edges are
  \(\{1,2,3\}\) for \(k=4\); edges whose edge polynomial has a repeated root
  at fractional slope, or a repeated algebraic root, are listed as
  unresolved (they need a further Puiseux step over an algebraic extension).
  No edge with denominator \(\ge5\) has appeared.  Coverage is therefore
  partial: "no 5-cycle on the resolved part of the box" is the current
  statement, not a theorem.
- Validated numeric scan (nearest-neighbour tracking accepted only when two
  radii \(10^{-2},3\cdot10^{-3}\) and two step counts \(3200,12800\) agree),
  box \(|b_j|\le1\), seed 1:
  \(k=4\): 222/242 resolved, types \((1^7),(2,2,1^3),(3,1^4),(4,1^3)\);
  \(k=5\): 669/728 resolved, types \((1^8),(2,2,1^4),(3,1^5),(3,2,1^3),(4,1^4)\).
  The remaining cocharacters are exactly those whose Newton polygon has a
  repeated edge root.  No cycle of length \(\ge5\) on any resolved
  cocharacter.  Outputs: `c925-fable-dp-cycle-scan-output.txt`.

**Exact closure of the flagged cases.**  A deeper Puiseux step is not needed
to exclude long cycles.  Write an edge of slope \(p/q\) in lowest terms as
\(E(\lambda)=\lambda^{r}\widetilde E(\lambda^{q})\).  A root of
\(\widetilde E\) of multiplicity \(\mu\) carries \(\mu q\) Puiseux branches
whose ramification indices are multiples of \(q\) summing to \(\mu q\), so
every cycle length over that root is at most \(\mu q\).  Hence

\[
  \max(\text{cycle length at }b)\;\le\;
  \max_{\text{edges}}\ \max_{\text{roots of }\widetilde E}\ \mu\cdot q ,
\]

computable from the first-stage data alone by factoring \(\widetilde E\) over
\(\mathbf Q\) (distinct irreducible factors have disjoint roots, so factor
exponents are root multiplicities).  Run on \(\mathrm{Bl}_4\mathbf P^2\),
box \(|b_j|\le1\), all 242 cocharacters: the bound is 1 for 61, 2 for 84,
3 for 37, and 4 for 60 cocharacters, and **never reaches 5**.  So on that box
the del Pezzo of degree five has no boundary-monodromy cycle of length
\(\ge5\) at all — not merely none among the resolved cocharacters.
Sanity: on \(F_1\) the same certificate gives bound 4, matching the observed
4-cycles.
- **Correction for \(k=6\).**  The adjunction filter \(\beta^2=c-2\) captures
  only smooth rational curves; nodal rational curves also contribute.  The
  bound \(\beta^2\le c^2/(9-k)\) excludes them for \(k\le5\) (so the
  \(k=4,5\) results stand; their products commute to \(10^{-16}\)), but at
  \(k=6\) the anticanonical class \(3L-\sum E_i\) (\(c_1\cdot\beta=3\),
  \(\beta^2=3\)) enters with two-point invariant 12, the number of singular
  members of a pencil of plane cubics.  Without it the \(k=6\) product fails
  to commute at relative size 0.3 at order \(z_0^3\); with it, commutators are
  \(10^{-16}\).  \(k=7,8\) need the Göttsche–Pandharipande recursion for
  higher-nodal classes and are out of scope for these scripts.

### 11.4 Closed lens: Frobenius as a canonical extra symmetry

A \(p\)-adic Frobenius structure (Bai–Pomerleano–Seidel, dossier D11) would
act on any Kummer index \(q^{1/n}\mapsto q^{p/n}\), i.e. by multiplication by
\(p\) on \(\mathbf Z/n\), on source and correction alike; it is
telescope-coherent by the same uniqueness argument as T2 but distinguishes
nothing that the cyclic structure does not already.  Closed.

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
