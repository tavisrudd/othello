# C403 free arrangement-code upgrades — cold-start execution plan

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `EXECUTED AS C407; COMPLETE`

**Parent theorem:** `notes/2026-07-20-c403-arrangement-complement-distance.md`

## Routing and ownership

C403 is complete and archived at commit `1a479963`.  This post-close blueprint was executed and
closed as C407 in `notes/2026-07-20-c407-c403-free-arrangement-code-upgrades.md`; it did not reopen
C403.  Do not restore C403 to the live queue, remove its archive row, or reuse its ID.

The execution reserved C407 through the required allocator invocation:

```bash
python3 notes/scripts/allocate_codex_task_ids.py reserve \
  --count 1 \
  --lane crowns \
  --purpose 'execute six C403 free arrangement-code upgrades'
```

The allocation ledger was committed before the C407 queue lifecycle began.  The six upgrades were
kept in one task because they factor through the same line-section profile and require no
independent census.

Allowed execution paths are the new successor's dated `notes/` report/evidence stem, this plan, the
parent C403 report, and the crowns handoff.  The C403 Python/JSON/checksum bundle stays unchanged
unless the executor deliberately adds a new committed replay.  C406 files and evidence are
read-only dependencies.

## Cold-start reading

Read in this order:

1. `../AGENTS.md` in the dedicated command required by the workspace guide.
2. `notes/handoffs/2026-07-17-crowns.md` in full.
3. This plan in full.
4. The following sections of the parent C403 report:
   - `Exact ambient formula`;
   - `Weighted 2-adjoint theorem`;
   - `Free coding corollaries`;
   - `Scope of parent forgetting and the support-transition algebra`;
   - `Nonfactorized dual-support gate: standard GRS stop`;
   - `Evidence and independent replay`; and
   - `Hand-back`.
5. Before proof development, the named-expert context and
   `notes/expert-personas/hirschfeld-thas-storme-ball-lavrauw-projective-arcs.md`.

Do not preload C403's git history, C399/C406 archives, or broad coding-theory literature.  The six
claims below are conventional consequences, not priority claims.  If manuscript-facing novelty or
historical positioning is later requested, run a separate focused audit under the repository's
literature conventions.

## Common notation and reusable interface

Let `A` be an essential arrangement of `N>0` projective lines in `PG(2,q)`.  Let `B` be its spanning
projective complement, `n=|B|`, and `D=D(A)` the projective `[n,3]_q` code whose columns are the
points of `B`.  For every projective line `L`, put

```text
s_L = |B cap L|,
f_s = #{L in PG(2,q)^dual : s_L=s}.
```

If `A_w` is the ordinary Hamming weight distribution of `D`, then projectivity and spanning give

```text
f_s = A_(n-s)/(q-1).
```

Thus the C403 punctured weighted-adjoint polynomial, the Hamming enumerator, and the line-section
size distribution are interchangeable for every claim below.  Preserve the distinction between:

- the original arrangement matroid `M(A)`;
- the weighted 2-adjoint parallel-copy matroid `M(B_A)`; and
- the complement-column matroid `M(B)` represented by the code.

Upgrades 2--6 concern `M(B)`.  They do not repair or strengthen any failed claim that ordinary
invariants of `M(A)` determine the code.

## Execution order

Do the upgrades in the numbered order.  Upgrade 1 is the strongest new packaging statement.
Upgrades 2--4 share one rank-three matroid proof block.  Upgrades 5--6 are operational corollaries.
After each coherent proof block, update the successor report and commit it rather than accumulating
all prose until the end.

## 1. Uniform scalar-extension enumerator

### Target theorem

Assume `A` and its weighted adjoint are represented over `F_q`.  For every `e>=1`, put `Q=q^e`,
extend the same arrangement to `F_Q`, and let `D_Q` be its projective complement code.  Let
`chibar_(B_A)(t,x)` be the fixed coboundary polynomial of the indexed weighted-adjoint hyperplane
list, let `r_B` be its rank, and put `M=sum_X(m(X)-1)`.  Prove

```text
n_Q = chi_A(Q)/(Q-1),

P_(A,Q)(x)
  = (Q^(3-r_B) chibar_(B_A)(Q,x)-x^M)/(Q-1),

Z_(A,Q)(x) = P_(A,Q)(x)-N x^(N-1),

W_(D_Q)(z)
  = 1 + (Q-1)N z^n_Q
      + (Q-1) sum_delta [x^delta]Z_(A,Q)(x)
          z^(n_Q-Q-1+N-delta).
```

One fixed characteristic polynomial and one fixed weighted-adjoint coboundary polynomial therefore
determine the complete Hamming enumerator over every finite scalar extension.

### Proof obligations

1. Matrix ranks and the represented intersection lattices do not change under scalar extension.
2. The base complement `B(F_q)` is contained in `B(F_Q)` and already contains a vector-space basis,
   so the extension complement still spans.
3. Ardila's finite-field coboundary identity applies to the same indexed parallel-copy list over
   `F_Q`.
4. The zero-vector removal, projectivization by `Q-1`, and intrinsic mirror puncture remain exactly
   the three displayed operations.
5. State that the quotient expression has integer coefficients at every `Q=q^e`.  Claim polynomial
   divisibility by `t-1` only if it is proved symbolically from the coboundary identity.

### Checks and boundaries

- At `e=1`, recover the parent C403 formula verbatim.
- Substitute the three C399 conic-phase fixtures as examples, but do not enumerate extension
  fields or reopen their parent-marker questions.
- Distinguish scalar extension in a fixed characteristic from integral good-reduction variation
  across characteristics.
- Compare conceptually with C389, but claim neither its exact-degree layer theorem nor a new
  rational zeta function.

No new checker is required for this conventional proof.  If an extension-field replay is added,
use a proper finite-field implementation, commit it with its canonical output, and do not fake
`F_(q^e)` with modular arithmetic modulo `q^e`.

## 2. Complete generalized Hamming-weight hierarchy

### Target theorem

Write `d=d_1(D)`.  Prove for the projective dimension-three code

```text
d_1(D)=d,  d_2(D)=n-1,  d_3(D)=n.
```

If `n>3`, Wei duality then gives, for `1<=j<=n-3`,

```text
d_j(D^perp) =
  j+2,  when 1<=j<=n-d-2,
  j+3,  when n-d-1<=j<=n-3.
```

Empty ranges are allowed.  At the conic/GRS phase `d=n-2`, the first range is empty and
`d_j(D^perp)=j+3` throughout.

### Proof obligations

1. Use the projective-system formula
   `d_r=n-max |B cap Pi|` over projective subspaces of codimension `r`.
2. For `r=2`, the relevant subspaces are projective points; distinct projective columns give the
   maximum intersection size one.
3. For `r=3`, the relevant projective subspace is empty.
4. Apply Wei duality carefully: the sets
   `{d_i(D)}` and `{n+1-d_j(D^perp)}` partition `{1,...,n}`.
5. Check the jump between `n-d` and `n-d+2`; the missing integer is forced by `d_1(D)=d`.

### Boundaries

This closes generalized Hamming weights only for the rank-three projective complement code.  Do not
claim that a single weighted 2-adjoint determines generalized weights in arbitrary rank.  That
would require higher-codimension section data and is a separate, source-audited problem.

## 3. Complete circuit and minimal dual-support counts

### Target theorem

The simple rank-three matroid `M(B)` has circuits only of sizes three and four.  Prove that their
numbers are

```text
C_3 = sum_s f_s binom(s,3),

C_4 = binom(n,4)
      - sum_s f_s (binom(s,4)+binom(s,3)(n-s)).
```

Each circuit supports a unique projective dual word.  Hence the numbers of nonzero minimal dual
words of weights three and four are `(q-1)C_3` and `(q-1)C_4`.

### Proof obligations

1. Every collinear triple lies on a unique projective line, proving the `C_3` formula.
2. A four-set fails to be a circuit exactly when all four points are collinear or exactly three
   are collinear.
3. A four-set with exactly three collinear points is counted uniquely by choosing the containing
   line, its triple, and the fourth point outside that line.
4. A four-circuit has rank three and a one-dimensional dependency with no zero coefficient.
5. At the conic phase `f_s=0` for `s>=3`, recover `C_3=0` and `C_4=binom(q+1,4)`.

### Independent consistency check

Prove or directly verify the weight-four identity

```text
A_4(D^perp)/(q-1)
  = C_4 + (q-3) sum_s f_s binom(s,4).
```

For four collinear projective points, the two-dimensional dependency code is `[4,2,3]` MDS and has
exactly `q-3` projective full-support words.  Four-sets with exactly one collinear triple have no
full-support dependency.  Compare the result with the already certified MacWilliams coefficient.

### Boundary

The formulas count supports; they do not canonically identify or orbit-classify them from the
one-variable polynomial.  Do not reopen the conic dual-support orbit census closed by C403.

## 4. Full Tutte polynomial of the complement-column matroid

### Target theorem

Prove that, for a spanning projective rank-three system, the ordinary Hamming enumerator determines
the full Tutte polynomial of `M(B)`, not merely Greene's usual specialization.  Put

```text
R_k = sum_s f_s binom(s,k).
```

Then derive the explicit formula

```text
T_(M(B))(x,y)
  = (x-1)^3 + n(x-1)^2
    + sum_(k=2)^n R_k (x-1)(y-1)^(k-2)
    + sum_(k=3)^n (binom(n,k)-R_k)(y-1)^(k-3).
```

### Proof obligations

1. The empty set has rank zero and the `n` singletons have rank one.
2. Every rank-two subset of size at least two lies on a unique projective line, so there are
   exactly `R_k` such `k`-subsets.
3. Every remaining subset of size at least three has rank three.
4. Insert those counts into the subset definition of the Tutte polynomial.
5. Explain the converse direction through Greene's theorem, yielding an equivalence between the
   Hamming enumerator, the line-section size distribution, and `T_(M(B))` in this restricted
   rank-three projective category.

### Checks and boundaries

- Check `T(1,1)=binom(n,3)-C_3`, the number of bases.
- Check `T(2,1)=1+n+binom(n,2)+binom(n,3)-C_3`, the number of independent subsets.
- Explicitly state that this is the Tutte polynomial of the complement columns.  It does not make
  the original arrangement Tutte polynomial determine distance.
- Make no general claim that one-variable code enumerators recover full Tutte polynomials outside
  simple rank three.

## 5. Covering radius two, quasi-perfect duals, and coset leaders

### Target theorem A: the large-complement criterion

Assume `PG(2,q)\B` is nonempty and `n>q+1`.  Prove that every excluded projective point lies on a
secant of `B`.  Consequently

```text
rho(D^perp)=2.
```

The proof is one pigeonhole step: the `q+1` lines through an excluded point partition the `n`
complement points, so one line contains at least two of them.

### Target theorem B: the conic boundary

For odd `q`, prove separately that every point outside a nonsingular conic lies on a secant.  Hence
the conic-phase dual also has covering radius two even though `n=q+1`.

### Exact coset-leader distribution

In either case, every nonzero syndrome direction in `B` has leader weight one and every direction
outside `B` has leader weight two.  Therefore the coset-leader enumerator is

```text
1 + (q-1)n z + (q-1)(q^2+q+1-n) z^2.
```

Since a nonzero projective `[n,3]` parity-check system has dual minimum distance three or four, these
dual codes are quasi-perfect.

### Checks and boundaries

1. Check that the displayed coefficients sum to `q^3`, the number of syndromes/cosets.
2. At the conic phase use `n=q+1` and `d(D^perp)=4`.
3. In the stable C399 cases verify `n>q+1` and the existence of excluded mirror points before
   invoking the criterion.
4. Present `n>q+1` as sufficient, not necessary.  Do not classify all smaller saturating sets.
5. Do not claim a new decoder; the result gives the exact leader-radius profile and a natural
   two-column syndrome search interface.

## 6. Exact minimal primal codewords

### Target theorem

For the nonzero projective codeword whose kernel line is `L`, prove

```text
the codeword is minimal  iff  s_L>=2.
```

Consequently

```text
# minimal nonzero codewords = (q-1) sum_(s>=2) f_s.
```

### Proof obligations

1. `supp(c_M)` is properly contained in `supp(c_L)` exactly when
   `B cap M` properly contains `B cap L`.
2. If `s_L>=2`, no distinct projective line can contain `B cap L` because two points determine a
   unique line.
3. If `s_L=1`, spanning supplies a second complement point off `L`; the line joining it to the
   unique point of `B cap L` gives a strict zero-set enlargement.
4. If `s_L=0`, any line meeting `B` gives a strict zero-set enlargement.

### Corollaries and boundaries

- At the conic phase the minimal projective codewords are exactly the secant-kernel words, so there
  are `(q-1)binom(q+1,2)` nonzero minimal words.
- When every nonmirror has section size at least two, all nonmirror-kernel words are minimal and
  mirror-kernel full-weight words are not.
- Mention the standard secret-sharing interface only as an application hook.  Do not assert a
  minimal access structure until a distinguished coordinate and the usual normalization are fixed.

## Evidence strategy

The six results are algebraic corollaries of the existing C403 interface.  The preferred evidence
mode is a conventional proof plus independent specialization checks against the committed C403
certificate.  Do not modify the existing generated JSON merely to restate formulas already
recoverable from its weight distributions.

Minimum validation:

```bash
cd /home/tavis/src/othello
python3 -B notes/2026-07-20-c403-arrangement-complement-distance.py --check
sha256sum -c notes/2026-07-20-c403-arrangement-complement-distance.sha256
```

Also perform exact hand checks on one conic fixture and one nonconic q=11 fixture for:

- the Wei-duality hierarchy;
- `C_3`, `C_4`, and the weight-four MacWilliams identity;
- `T(1,1)`;
- the coset-leader coefficient sum; and
- the minimal-codeword count.

If these checks are implemented rather than written out algebraically, extend or create a checker
under the successor stem, emit canonical compact JSON, add SHA-256 and byte counts, and provide a
`--check` mode.  Do not cite an untracked scratch computation in the report.

## Literature and terminology boundary

Use conventional attribution rather than novelty wording:

- Wei duality for generalized Hamming weights;
- Greene's code--matroid Tutte specialization;
- projective-system and rational-normal-curve/GRS terminology;
- saturating-set and quasi-perfect-code terminology for covering radius; and
- minimal-codeword terminology for the final corollary.

The scalar-extension packaging should be derived from the already consulted Ardila finite-field
method and indexed parallel-copy theorem.  Before fetching anything, use the shared literature
cache as required by `../AGENTS.md`.  A focused forward-citation audit is unnecessary unless the
successor report seeks a priority or manuscript-heading claim.

## Explicit non-goals

This package does not authorize:

- arbitrary-rank generalized Hamming weights or a tower of higher adjoints;
- classification of all saturating arrangement complements;
- dual-support orbit censuses at a conic phase;
- C406's restricted matching-module or H3 sheet-sign Gate 2;
- a new decoder implementation or secret-sharing construction;
- changes to C399/C406 manuscripts, Lean gates, or evidence; or
- a claim that the original arrangement Tutte polynomial determines the complement code.

Record any one of those as a separately gated question rather than expanding the successor task.

## Completion checklist

The successor closes only when:

1. all six theorem statements appear with complete proofs and hypotheses;
2. the extension theorem is stated uniformly for every `Q=q^e`;
3. the generalized-weight ranges and empty-range edge cases are checked;
4. circuit counts agree with the weight-three and weight-four dual coefficients;
5. the displayed Tutte formula passes its basis and independent-set checks;
6. the covering-radius statement distinguishes the `n>q+1` criterion from the conic boundary;
7. the minimal-codeword theorem is not overstated as a secret-sharing classification;
8. existing C403 evidence remains green, and any new computation is committed atomically;
9. the report makes no novelty or priority claim without a dedicated audit; and
10. the live queue, archive, crowns handoff, discovery-track review, and commit follow the workspace
    completion invariant.

## Hand-back target

The desired final hand-back is a compact theorem package:

```text
one weighted-adjoint coboundary polynomial
  -> every scalar-extension Hamming enumerator
  -> the full rank-three generalized-weight hierarchy
  -> every minimal dual-support count
  -> the full complement-matroid Tutte polynomial
  -> exact quasi-perfect coset-leader data
  -> exact minimal primal-codeword counts.
```

That package strengthens C403 as reusable arrangement-code theory while leaving the conic parent
forgetting result, the C406 matching-module gate, and all novelty boundaries unchanged.
