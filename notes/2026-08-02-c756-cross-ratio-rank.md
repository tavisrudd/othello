# C756 — cross-ratio matrix rank and the first angle moment

**Lane**: clebsch · **Date**: 2026-08-02 · **Scope**: saturated-internal
rank attack

## Verdict

The requested all-field obstruction is **not proved**.  The cross-ratio matrix does
have a clean rank-three *displacement*, but its own rank does not separate the
(q=5) frames from the negative character candidates.  Singular negative matrices
occur in every tested field, and at (q=23) some have nullity two.  Thus the first
angle moment

\[
   \mathsf A\mathbf 1=0
\]

is a **kernel-alignment** condition, not a bare rank-deficiency condition.

This pass nevertheless gives the exact matrix identity that the next cofactor attack
must use and closes the proposed nonsingularity shortcut.  In the rank-(k-1) branch,
the remaining condition is that the canonical adjugate kernel line equal the constant
line.  A uniform proof must either globalize that cofactor line or first exclude the
rank-(\le k-2) branch; pairwise resultant character alone does neither.

Evidence:
`notes/2026-08-02-c756-cross-ratio-rank.py` and
`notes/2026-08-02-c756-cross-ratio-rank.json`.

## 1. Exact double-displacement identity

Write

\[
 a_i=z_i,\qquad b_i=z_i^q,\qquad
 \mathsf A_{ij}=
 \frac{(a_i-a_j)(a_i-b_j)}{(b_i-a_j)(b_i-b_j)}\quad(i\ne j),
 \qquad \mathsf A_{ii}=0.
\]

Let (X=\operatorname{diag}(a_i)), (Y=\operatorname{diag}(b_i)), and define

\[
 \Delta_a(M)=YM-MX,\qquad \Delta_b(M)=YM-MY.
\]

The operators commute, and entrywise

\[
 \begin{aligned}
 (\Delta_a\Delta_b\mathsf A)_{ij}
  &=(b_i-a_j)(b_i-b_j)\mathsf A_{ij}\\
  &=(a_i-a_j)(a_i-b_j)\\
  &=a_i^2-a_i(a_j+b_j)+a_jb_j.                         \tag{R1}
 \end{aligned}
\]

The diagonal identity is also valid: both sides are zero.  Put

\[
 \mathbf a=(a_i),\qquad \mathbf s=(a_i+b_i),\qquad
 \mathbf n=(a_ib_i).
\]

Then

\[
 \boxed{
 \Delta_a\Delta_b\mathsf A
 =\mathbf a^{\circ2}\mathbf1^{\mathsf T}
  -\mathbf a\mathbf s^{\mathsf T}
  +\mathbf1\mathbf n^{\mathsf T} }
                                                               \tag{R2}
\]

has rank at most three.  This is the promised Cauchy/displacement structure.
It is an identity over every field of odd characteristic and uses neither counting
nor the bounded census.

If the first angle moment holds, multiplying (R2) by
(\mathbf1) gives the more explicit kernel-propagation equation

\[
 \boxed{
 \mathsf A\mathbf n-Y\mathsf A\mathbf s
 =k\mathbf a^{\circ2}
  -\Bigl(\sum_j s_j\Bigr)\mathbf a
  +\Bigl(\sum_j n_j\Bigr)\mathbf1. }                    \tag{R3}
\]

Since (k=(q+3)/2=3/2) in the ground field, the right side is a fixed
quadratic evaluation vector.  Equation (R3) is the exact low-degree consequence
available from displacement rank.  It does not by itself create a second kernel
vector or a contradiction.

## 2. Why matrix rank alone does not obstruct

The exact audit computes the rank of every normalized pairwise-resultant-character
candidate used by the simultaneous-angle checker.  `zero rows` means rows whose
first angle sum already vanishes.

| (q) | size (k) | profile ((\operatorname{rank}\mathsf A,\text{ zero rows})^{\#}\) |
|---:|---:|---:|
| 5  | 4  | ((3,4)^2) |
| 7  | 5  | ((4,1)^5) |
| 11 | 7  | ((6,1)^{28}) |
| 19 | 11 | ((10,1)^{11},(11,1)^{44}) |
| 23 | 13 | ((11,7)^{26},(12,1)^{13}) |
| 31 | 17 | ((16,1)^{17}) |
| 43 | 23 | ((22,1)^{23}) |

Both (q=5) frames have (\ker\mathsf A=\langle\mathbf1\rangle).  No tested
(q>5) candidate contains the constant vector in its kernel, recovering the earlier
first-moment separation.  But rank (k-1) is the generic profile at
(q=7,11,31,43), and negative rank-(k-2) examples occur at (q=23).
Consequently:

1. “(\mathsf A) is singular only at (q=5)” is false even on the bounded
   pairwise-character domain;
2. proving (\operatorname{rank}\mathsf A\ge k-1) would not prove the desired
   obstruction; and
3. a first-adjugate argument is not uniform until the full arc axioms are shown to
   exclude nullity at least two.

The isolated zero-row phenomenon is also systematic: every negative candidate in
the audit has at least one zero row, and 26 of the (q=23) candidates have seven.
Thus a local row or principal-minor argument cannot simply be iterated without using
the simultaneous geometry.

## 3. Correct cofactor target

Suppose first that (\operatorname{rank}\mathsf A=k-1).  Then
(\operatorname{adj}(\mathsf A)) has rank one, and any nonzero column spans the
right kernel.  Hence

\[
 \mathsf A\mathbf1=0
 \quad\Longleftrightarrow\quad
 \text{one (equivalently every) nonzero adjugate column is constant}.       \tag{R4}
\]

The surviving all-field target is therefore not a determinant evaluation but a
**cofactor-ratio theorem**: compute the adjugate kernel line from (R2), and prove that
it can be the constant line only for the (q=5) four-frame.

If (\operatorname{rank}\mathsf A\le k-2), all first cofactors vanish and (R4)
contains no information.  This branch needs either a theorem that full angle
binomiality forces rank (k-1), or a second-compound version of the same
displacement argument.  The (q=23) profile is an exact warning that this is a real
logical branch, not a technicality removable from the pairwise-character hypotheses.

## 4. Replay and trust boundary

Run from `rust/`:

```sh
python3 ../notes/2026-08-02-c756-cross-ratio-rank.py --check
sha256sum ../notes/2026-08-02-c756-cross-ratio-rank.{py,json} \
  ../notes/2026-08-02-c756-simultaneous-angle-moments.py
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-02-c756-cross-ratio-rank.py` | 5,746 | `7e1e4c076a6acf46cf0eec938203a2532f4f64bf5746b39452aa7d7c53f8c157` |
| `notes/2026-08-02-c756-cross-ratio-rank.json` | 2,453 | `294ab708516dd8c635b724356da4f0b5005394050433e3c54a4da209a77e1106` |
| input `notes/2026-08-02-c756-simultaneous-angle-moments.py` | 5,039 | `b179ffa6f85e019993cc101d10a04bd96b2d03096c1f0b054991bbd517b8532a` |

The checker uses exact arithmetic in the independent pair model
(\mathbb F_q[\sqrt\epsilon]), verifies (R1) entrywise, row-reduces each matrix,
checks explicit kernel bases, and records the joint rank/zero-row profile.  The
underlying candidate enumeration is the already tracked independent Python replay of
the Rust audit.  This certifies only the seven displayed prime fields and the stated
normalized candidate domain.  It does not exclude extension fields, prove a uniform
rank bound, or prove the saturated-internal classification.

## 5. EJ + TT closeout and mystery ledger

**EJ.**  The free gain is (R3): a hypothetical constant kernel forces a quadratic
evaluation vector into the two-step displacement image.  Any successful cofactor
globalization should preserve this three-dimensional target instead of expanding the
determinant blindly.

**TT.**  The matrix should be treated as a displacement-rank-three object with a
distinguished kernel line, not as a generically nonsingular matrix.  The negative
candidates already realize the maximal-rank singular boundary, while (q=23) realizes
the next compound boundary.  The proof must classify kernel alignment across all rows.

| mystery | status | exact gap |
|---|---|---|
| Does the cross-ratio matrix have low ordinary rank? | settled negatively | it has low displacement rank, while ordinary rank is (k,k-1), or (k-2) in the bounded domain |
| Can singularity alone isolate the (q=5) frames? | settled negatively | singular negative candidates occur in every tested field |
| What exactly is the first-moment condition at rank (k-1)? | settled | equality of the adjugate kernel line with the constant line, equation (R4) |
| Can a genuine full-angle system have nullity at least two? | open | pairwise character permits it at (q=23); full binomiality may still exclude it |
| Can (R2)--(R3) globalize the cofactor line? | open | derive cofactor ratios or a second-compound identity below the arc-divisor degree |
