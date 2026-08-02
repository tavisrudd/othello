# C756 — defect-two intercept-subresultant probe

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

**Negative gate, with an exact structural formula for the obstruction.**
For a direction-covering configuration, the first subresultant
\(S_1=S_{1,1}(T)\,U+S_{1,0}(T)\) of
\(\mathcal H(U,T)=\prod_i(U+x_iT-y_i)\) and
\(\partial\mathcal H/\partial U\) factors as

\[
 \boxed{\;S_1=\pm E_P(T)^2\bigl(G(T)\,U-N(T)\bigr),\qquad
 G=\sum_{m=1}^n\Phi_m^2,\quad N=\sum_{m=1}^n r_m\Phi_m^2,\quad
 \Phi_m=\frac{T^q-T}{w_m},\;}
\]

with \(r_m=y_m-x_mT\) and \(w_m=\prod_{i\ne m}(r_m-r_i)\).  The only
**uniformly forced** factor is \(E_P^2\), the square of the degree-\(\delta\) concurrence
divisor.  The Moore form \(T^q-T\) does **not** divide \(S_{1,1}\) at all
— it cannot even fit, since \(\deg S_{1,1}=(n-1)(n-2)=2\delta+2(q-n+1)<2q\)
— and after the \(E_P^2\) cancellation the intercept rational function
\(U^*(T)=N(T)/G(T)\) has

\[
 \deg G=2(q-n+1),\qquad \deg N=2(q-n+1)+1,\qquad \gcd(G,N)=1
\]

(measured trivial gcd on every instance; degree drop at most one, and only
by the accidental vanishing of the leading coefficient
\(\sum_m v_m^{-2}\), \(v_m=\prod_{i\ne m}(x_m-x_i)\)).  The residual degree
is therefore \(\Theta(q)=\Theta(n^2)\), not \(O(\delta)\): at fixed
\(\delta=2\) it grows \(16\to26\) from \(q=13\) to \(q=19\), exactly as
\(2(q-n+1)\), and at the first unclassified boundary \((q,k)=(53,12)\) it
would be \(2(53-11+1)=86\).  The interpolation degree of the intercept
*function* on the unique-chord directions is also maximal (or one below) in
every instance, so none of the tested natural representations of the intercept data
— polynomial, rational, or functional — lives at scale \(O(\delta)\).  **The last
identified small-degree Weil route at defect two is closed.**

The structural reason is clean.  Covering makes every pencil polynomial
\(w_m\) — whose \(n-1\) roots are the chord directions through \(P_m\),
rational and distinct — an exact divisor of \(T^q-T\).  The Moore form is
thereby *distributed* into the \(n\) summands as the complementary
cofactors \(\Phi_m\), and a sum of squares of distinct cofactors has no
common Moore factor.  What survives cancellation is not the defect but the
complement of each point's direction pencil, of size \(q-(n-1)\).  The
direction polynomial \(D_P\) concentrated the covering into one product and
could shed its forced \(q\) roots at once; the intercept datum is spread
over the \(n\) points, and each point only ever "sees" its own \(n-1\)
directions.

Status of each claim: the factorization above and the degree formula are
**proved** given the classical first-subdiscriminant identity (§1), which is
verified symbolically at \(n=3\) and by exact seeded specialization at
\(n=5,6,7,10\); the triviality of \(\gcd(G,N)\) and the maximality of the
interpolation degree are **measured** on six covering instances and there is
no visible mechanism that could force them otherwise; the nonexistence of a
\((10,43)\), slack-two covering configuration is only a **bounded search
negative** (stop condition in §3).

## 1. The subresultant in root form

\(\mathcal H=\prod_m(U-r_m)\) is monic in \(U\) with roots
\(r_m=y_m-x_mT\); the double root of \(\mathcal H(\cdot,t)\) at a
unique-chord direction \(t\) is the intercept of that chord, since the
chord through \((x_i,y_i),(x_j,y_j)\) with slope \(t\) has intercept
\(y_i-tx_i=r_i(t)\).  The classical first-subdiscriminant / Sylvester
double-sum formula gives, up to sign,

\[
 S_1(U,T)=\pm\sum_{m=1}^n\,(U-r_m)
 \!\!\prod_{\substack{i<j\\ m\notin\{i,j\}}}\!\!(r_i-r_j)^2. \tag{1}
\]

Verification: fully symbolic at \(n=3\) (ratio exactly \(-1\) against
sympy's subresultant PRS over \(\mathbb Z[x_i,y_i]\)); exact random
specialization mod \(2^{61}-1\) at \(n=5,6,7,10\), where the independent
subresultant PRS agrees with (1) up to one scalar (certificate:
`2026-08-01-c756-intercept-subresultant-generic.json`).  At a direction
\(t\) with the single collision \(r_p(t)=r_q(t)\), only the terms
\(m=p,q\) survive in (1) and both are multiples of \(U-r_p(t)\); hence
\(U^*(t)=-S_{1,0}(t)/S_{1,1}(t)\) is the intercept, confirming the standard
double-root property used throughout.

Generic degrees, without any covering condition (measured; also the a
priori determinant bound, so exact):

\[
 \deg_T S_{1,1}=(n-1)(n-2),\qquad \deg_T S_{1,0}=(n-1)(n-2)+1,
\]

with \(\gcd(S_{1,1},S_{1,0})=1\) and \(\gcd(S_{1,1},D_P)=1\) generically,
where \(D_P=\prod_{i<j}(r_i-r_j)\).  So before covering there is no
cancellation at all: the intercept ratio is genuinely \(\Theta(n^2)\).

## 2. What covering forces — and what it cannot force

Assume covering: \(D_P=(T^q-T)E_P\) with \(\deg E_P=\delta\).  Fix \(m\).
The roots of \(w_m=\prod_{i\ne m}(r_m-r_i)\) are the \(n-1\) chord
directions through \(P_m\); they lie in \(\mathbb F_q\) (rational
coordinates, distinct \(x_i\)) and are pairwise distinct (two parallel
chords through \(P_m\) would be one line containing three points).  Hence

\[
 w_m\mid T^q-T,\qquad
 \Phi_m=\frac{T^q-T}{w_m}\in\mathbb F_q[T],\qquad
 \deg\Phi_m=q-n+1, \tag{2}
\]

and the inner product in (1) is \(D_P^2/w_m^2=E_P^2\Phi_m^2\).  This proves
the boxed factorization, and with it:

- **\(E_P^2\) divides both coefficients.**  This exactly accounts for the
  vanishing of \(S_1\) at exceptional directions, where
  \(\gcd_U(\mathcal H,\partial_U\mathcal H)\) has degree \(\ge2\) and the
  first subresultant must vanish identically.
- **Covering costs the subresultant no degree.**
  \(\deg S_{1,1}=(n-1)(n-2)=2\delta+2(q-n+1)\) exactly as in the generic
  case; the covering condition only reorganizes the factorization.
- **No Moore factor.**  \(\gcd(S_{1,1},T^q-T)\) is exactly the radical of
  \(E_P\) (the \(s_P\le\delta\) exceptional directions), measured in every
  instance; \(G\) itself has at most one accidental \(\mathbb F_q\)-root.
  As a function on \(\mathbb F_q\),
  \(G(t)=\sum_{m:\,t\in\operatorname{dirs}(m)}w_m'(t)^{-2}\) is supported
  on all of \(\mathbb F_q\) — the functional form of the same fact.
- **Segre link.**  The leading coefficient of \(G\) is
  \(\sum_m v_m^{-2}\) with \(v_m=\prod_{i\ne m}(x_m-x_i)\) — the same
  affine Vandermonde values that exhaust the Segre normalization in the
  defect-two comparison report.  It vanishes only accidentally (once in six
  instances, at \(q=7\)), dropping \(\deg G\) by exactly one.

## 3. Covering instances (measured)

Instances: deterministic seeded in-script search for the four small cases;
seeded Rust annealer (seed 20260801) for \((9,31)\) and \((10,41)\), with
the found points pinned in the Python script and **re-verified from
scratch** (general position and covering) before use.  For each instance
the full subresultant PRS over \(\mathbb F_q[T]\) is computed independently
of (1), then compared with the formula, the divisibility claims, the
pointwise intercepts on every unique direction, and the interpolation
degree of the intercept function.  All checks pass on all six instances
(certificate: `2026-08-01-c756-intercept-subresultant-cover.json`).

| \(n\) | \(q\)  | \(\delta\) | \(\deg S_{1,1}\) | \((n{-}1)(n{-}2)\) | \(\deg G\) | \(2(q{-}n{+}1)\) | \(\deg\gcd(G,N)\) | residual den | interp deg (max) |
|-------|--------|------------|------------------|--------------------|------------|------------------|-------------------|--------------|------------------|
|  5    |  7     | 3          | 11               | 12                 |  5         |  6               | 0                 |  5           |  3 (3)           |
|  6    | 13     | 2          | 20               | 20                 | 16         | 16               | 0                 | 16           | 10 (10)          |
|  7    | 19     | 2          | 30               | 30                 | 26         | 26               | 0                 | 26           | 16 (16)          |
|  7    | 17     | 4          | 30               | 30                 | 22         | 22               | 0                 | 22           | 11 (12)          |
|  9    | 31     | 5          | 56               | 56                 | 46         | 46               | 0                 | 46           | 25 (25)          |
| 10    | 41     | 4          | 72               | 72                 | 64         | 64               | 0                 | 64           | 36 (36)          |

(The \(q=7\) row shows the one accidental leading-coefficient vanish,
\(\sum v_m^{-2}=0\) in \(\mathbb F_7\); every other degree is exactly the
predicted value.  The \(q=17\) interpolation degree is one below maximal,
again accidental.)

The decisive measurement: at fixed \(\delta=2\) the residual denominator
degree moves \(16\to26\) as \(q\) moves \(13\to19\); across all six
instances it equals \(2(q-n+1)\) up to the single accidental \(-1\), while
\(\delta\) wanders \(2\ldots5\).  The residual tracks \(q\sim n^2/2\), not
\(\delta\).

Search negative: at \((n,q)=(10,43)\), i.e. slack \(\delta=2\) with \(45\)
chords over \(43\) directions, the seeded Rust annealer (targeted +
uniform moves, reheating) exhausted \(8\) seeds \(\times\)
\(3\times10^7\) moves without finding a covering configuration, and a
parabola-restricted variant (ten-element subset of \(\mathbb Z/43\) whose
pairwise sums cover every residue) also failed.  This is a bounded search
negative with the stated stop condition, not a nonexistence claim.  It does
not weaken the measurement: the degree identity of §2 is proved, so the
\((10,43)\) residual degree is the evaluation \(2(43-10+1)=68\) of a proved
formula, and the neighboring instances \((9,31)\), \((10,41)\) close the
growth series empirically.

## 4. Consequence for C756

This is the coordinate realization of the first bounded dual-pencil probe.
After normalizing the spare line, a chord pole's position along its line of the
pencil through \(\ell^\perp\) is exactly the intercept \(U^*(t)\), while internality
is the conic character \(\chi(g(t,U^*(t)))=-1\).  Thus the calculation answers the
proposed low-degree conic-norm question negatively; it does **not** classify the
all-internal near-transversals themselves.

The replacement gate posed by the defect-two Segre comparison report is
answered negatively.  Externality of the unique chord in direction \(t\) is
the condition \(\chi\bigl(g(t,\,U^*(t))\bigr)=-1\) for the fixed conic's
tangent-discriminant form \(g\); with \(U^*=N/G\) of degree
\(2(q-n+1)\approx 2q-2\sqrt{2q}\), the resulting character sum has degree
\(\Theta(q)\) and a Weil bound is vacuous — the same failure mode, for the
same reason, as the raw chord product before the Moore quotient.  The
direction defect was compressible because the covering concentrated all
\(q\) forced roots in one polynomial; the intercept defect is not, because
each arc point carries only its own \(n-1\approx\sqrt{2q}\) directions and
the Moore mass fragments into per-point cofactors.

What would be needed instead, made precise by the formula: a carrier in
which the \(n\) cofactors \(\Phi_m\) recombine — e.g. an identity for
\(\sum_m\Phi_m^2\) modulo low-degree data, or a change of the underlying
polynomial \(\mathcal H\) whose per-root pencils are not the point pencils.
No such carrier is currently identified.  Together with the earlier
closure of the saturated-external branch and of \(\delta\le1\), defect
\(\delta\ge2\) now has **no identified small-degree algebraic route**; the
open frontier reverts to genuinely new structural input (the dual
internal-node blocking formulation, or a second-order count uniform in
\(k\)).  The task file's existing 5–10% full-theorem estimate should now be
read at its low end for the algebraic-compression family of attacks.

Adjacent-literature note: no novelty or priority claim is made here.  The
subresultant identity (1) is classical (first subdiscriminant / Sylvester
double sums); the use made of it is routine once (2) is observed.

## 5. EJ + TT closeout

Cheap upgrades taken during the pass:

- The factorization of §2 is exact, not asymptotic, so it was verified as
  a polynomial identity per instance (PRS versus root formula, one scalar),
  which is a far stronger acceptance check than degree bookkeeping.
- \(\gcd(S_{1,1},T^q-T)=\operatorname{rad}(E_P)\) in every instance: the
  *only* rational roots covering forces on the subresultant are the
  exceptional directions themselves.  This is the sharpest form of "no
  Moore factor" and is worth quoting whenever this route is revisited.
- The Segre–Vandermonde link (\(\operatorname{lc}(G)=\sum v_m^{-2}\))
  connects the two 2026-08-01 defect-two reports: the same normalization
  data that exhausts Segre reciprocity reappears as the leading obstruction
  coefficient here.  Neither report can see the other's residual — a
  consistent picture of *why* defect two resists degree reduction.

Tao-style observations (opportunities, not manufactured mysteries):

- The intercept function's interpolation degree is maximal.  A cheaper
  probe would have measured this first: it already rules out every
  low-degree functional representation before any subresultant machinery.
  Recorded for future gate design.
- The fragmentation mechanism suggests where a genuinely different attack
  must live: any usable compression has to couple *different* arc points'
  pencils.  Two pencils share exactly one direction (that of the chord
  \(P_mP_{m'}\)), so \(\gcd(\Phi_m,\Phi_{m'})\) has the large degree
  \(q-(2n-3)\), yet the sum of squares \(G\) retains none of this pairwise
  overlap as a global factor.  A resultant
  or norm construction over the *pair* structure, rather than the point
  structure, is the only unexplored shape in this family.
- The \((10,43)\) search resistance is itself interesting: slack-two
  direction-covering ten-sets over \(\mathbb F_{43}\) may not exist, which
  would be a small standalone combinatorial fact adjacent to the
  Ng–Wild line-cover framework.  Logged as a bounded negative only; a
  promotion would need its own C-ID through the normal process.

## 6. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Forced factor of the intercept subresultant | settled | exactly \(E_P^2\); proved via \(w_m\mid T^q-T\) and formula (1), verified on all six instances |
| Moore square extraction | settled negatively | \(T^q-T\) does not divide \(S_{1,1}\) (degree obstruction \(+\) measurement); its mass fragments into the per-point cofactors \(\Phi_m\) |
| Residual intercept degree | settled | \(2(q-n+1)\) exactly (one accidental \(-1\)); \(\Theta(n^2)\), not \(O(\delta)\); the defect-two Weil route is closed |
| \(\gcd(G,N)\) | measured trivial, not proved trivial | a proof would need a mechanism; none visible, and triviality only strengthens the negative verdict |
| Accidental degree drops (\(\sum v_m^{-2}=0\), interp \(-1\) at \(q=17\)) | understood as accidental | leading-coefficient vanish over small fields; never forced; no effect on the \(\Theta(n^2)\) conclusion |
| Existence of slack-two covering ten-sets over \(\mathbb F_{43}\) | open, bounded negative | \(8\times3\times10^7\) annealing moves + parabola variant found none; nonexistence unproven; possible small standalone question |
| A defect-two contradiction | open | requires structural input outside the algebraic-compression family: pair-structure carrier, dual internal-node blocking, or a second-order count uniform in \(k\) |

No genuine mystery remains inside the gate itself: every measured quantity
is either proved or identified as an accidental small-field vanish.

## Artifacts

Replay commands (from the repository root `~/src/othello`):

```
rustc -O notes/2026-08-01-c756-intercept-subresultant-search.rs \
    -o /tmp/c756-search
/tmp/c756-search \
    > notes/2026-08-01-c756-intercept-subresultant-search-output.txt
python3 notes/2026-08-01-c756-intercept-subresultant-cover.py \
    > notes/2026-08-01-c756-intercept-subresultant-cover.json
uv run --with sympy notes/2026-08-01-c756-intercept-subresultant-generic.py \
    > notes/2026-08-01-c756-intercept-subresultant-generic.json
```

All runs are deterministic (seeds recorded in the scripts and JSON; the
Rust annealer seeds are 20260801–20260808).

| artifact                                                | bytes | SHA-256 |
|---------------------------------------------------------|-------|---------|
| `2026-08-01-c756-intercept-subresultant-cover.py`        | 14888 | `e1d0c320b488b57844c30aa13b89b08cb9d103501f051b33647e25a97264e921` |
| `2026-08-01-c756-intercept-subresultant-cover.json`      |  6910 | `fdc54d4465892e4010717e30d9986a88a8a0eef8b679e8c1c0b839cc0e67c335` |
| `2026-08-01-c756-intercept-subresultant-generic.py`      |  5673 | `63fc198b83917ba10030dd37fbddf0df6ebb8344281d20eac660739890b55fc8` |
| `2026-08-01-c756-intercept-subresultant-generic.json`    |  2667 | `ed3ea80a8d78e070e0ac79769a90077b1406e5e3761162ef2581a2b00f4e8b3b` |
| `2026-08-01-c756-intercept-subresultant-search.rs`       |  6558 | `929898d4203f55e07cceb1bccbd5360459ece58abc5814582754cded0c99e383` |
| `2026-08-01-c756-intercept-subresultant-search-output.txt` | 815 | `98f3f9c5c22affee6187034e2306dbe114f13593a40816171b480229eda80962` |

No manuscript files were edited; all files above are new.
