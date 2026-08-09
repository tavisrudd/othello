# C756 external-deletion aligned split closure

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** (q=53),
external deleted point, aligned split covariance, arbitrary remaining point
types; no manuscript edit

## Verdict

The external-deletion aligned split escape (K\sim C|_{r_0}) is impossible.
The mixed secant/passant geometry has one split-torus normal form, not two.
An exact search of that form leaves 230 normalized eleven-line stars with all
55 nodes internal and no triple concurrency.  Every survivor fails the first
of the eleven rank-two critical equations; hence none can satisfy

\[
 \nabla\mathcal Z(c)=0,
 \qquad
 \partial_i\partial_j\mathcal Z(c)\ne0\quad(i\ne j).
\]

The 230 geometric survivors genuinely have mixed line characters.  Their
(secant, passant) profiles among the eleven remaining polar lines are

\[
 (2,9)^{11},\quad(4,7)^{59},\quad(5,6)^{116},\quad(7,4)^{44}.
\]

Thus geometry alone does not close the branch, and neither an all-secant nor
an all-passant specialization was silently imposed.  The critical moment
system supplies the contradiction uniformly across every surviving profile.

## 1. Unique split normal form

Let the distinguished polar line be (r_0:W=0).  Since the deleted primal
point is external, (r_0) is secant, so choose split coordinates

\[
 Q(U,V,W)=UV-dW^2.
\]

Write a remaining polar line as

\[
 r_i:\ a_iU+b_iV+s_iW=0.
\]

Its point (r_i\cap r_0=[b_i:-a_i:0]) is an arrangement node and hence
internal.  The conic point character gives

\[
 \chi(d,a_ib_i)=-1.                                      \tag{1}
\]

All products (a_ib_i) therefore have one square class.  Rescale each line,
then absorb their common value into one split coordinate.  Equation (1)
reduces every apparent offset square class to

\[
 Q=UV-2W^2,
 \qquad
 r_i:u_iU+u_i^{-1}V+s_iW=0,                               \tag{2}
\]

where (2) is the least nonsquare in (mathbf F_{53}).  The identification
((u_i,s_i)\sim(-u_i,-s_i)) leaves exactly 26 directions.  Since (2) is
nonsquare, no state in (2) is tangent.  Its line character is

\[
 \chi(\Delta_i),
 \qquad \Delta_i=s_i^2-8,                                \tag{3}
\]

with (+1) for a secant and (-1) for a passant.  Each direction has 26
secant and 27 passant offsets.

The collapse to (2) is the main human simplification: unlike the aligned
anisotropic calculation, the split case has no second offset descent.

## 2. Mixed two-factor node character

Put

\[
 T_{ij}=u_i/u_j+u_j/u_i,
 \qquad
 D_{ij}=u_i/u_j-u_j/u_i.
\]

Distinct directions give (D_{ij}\ne0), and direct intersection yields

\[
 Q(N_{ij})=
 \frac{-s_i^2-s_j^2+T_{ij}s_is_j-2D_{ij}^2}{D_{ij}^2}.    \tag{4}
\]

The internal-node condition is (chi(Q(N_{ij}))=+1).  Using
(T_{ij}^2-D_{ij}^2=4), equation (4) has the exact factorization

\[
\begin{aligned}
 -4D_{ij}^2Q(N_{ij})
 &= (2s_i-T_{ij}s_j)^2-D_{ij}^2\Delta_j\\
 &= (2s_i-T_{ij}s_j-D_{ij}\sqrt{\Delta_j})
    (2s_i-T_{ij}s_j+D_{ij}\sqrt{\Delta_j}).              \tag{5}
\end{aligned}
\]

For a secant (r_j), the two factors lie in (mathbf F_{53}).  For a
passant they are conjugate over the quadratic extension, so their product is
a norm.  This is the requested mixed line-character formula; the checker
verifies its polynomial form for every tested pair, without choosing square
roots.

Triple concurrency is separately excluded by

\[
 \det(s_i,u_i,u_i^{-1})_{i\in\{a,b,c\}}\ne0.              \tag{6}
\]

## 3. Coupling to the critical system

For each geometric eleven-state set, intersect its 55 pairs and translate
their centroid to zero.  If the centered offsets are (c_i), aligned split
covariance gives Gram entries

\[
 B_{ij}=T_{ij}.
\]

The moment functional is the balanced coefficient extractor

\[
 \mathcal Z(C)=
 2\sum_{r=0}^{5}\binom{2r}{r}^{-1}[U^rV^r]
 \prod_{i=1}^{11}(C_i+u_iU+u_i^{-1}V).                   \tag{7}
\]

The degree-ten star-generator contractions are precisely
(partial_i\mathcal Z(c)).  The search evaluates them by the weighted
matching recurrence and cross-checks a surviving geometric state by an
independent direct balanced-coefficient expansion.  All 230 normalized
geometric candidates already have

\[
 \partial_1\mathcal Z(c)\ne0.                            \tag{8}
\]

No Hessian test is therefore needed at a leaf: criticality fails before the
open-separator condition.  This is a stronger bounded failure than finding
only a zero Hessian after all gradient equations pass.

## 4. Exact exhaustion and reproducibility

The canonical search fixes one chosen direction by the split torus and uses
(W\mapsto-W) to select one of the two root-offset signs.  It searches every
remaining state, enforces (4) and (6) incrementally, and uses an exact greedy
color bound.  Duplicates under other choices of normalized direction are
allowed; they do not weaken exhaustiveness.

The exact totals are:

| domain | value |
|---|---:|
| normalized root offsets | 27 |
| graph vertices | 1,378 |
| search nodes | 57,849,196 |
| normalized geometric candidates | 230 |
| candidates passing the first critical derivative | 0 |
| critical candidates | 0 |

The EJ closeout recorded the first-derivative histogram.  It occupies 49 of
the 52 nonzero field values, missing only (22,25,30); there is no small
constant-value or one-square-class compression analogous to the earlier
anisotropic gradient-product phenomenon.

Authority:

- generator/checker:
  `notes/2026-08-09-c756-aligned-split-mixed-search.py`;
- canonical certificate:
  `notes/2026-08-09-c756-aligned-split-mixed-search.json`.

From the repository root, regenerate with

```sh
python3 notes/2026-08-09-c756-aligned-split-mixed-search.py \
  --enumerate --workers 8 \
  --output notes/2026-08-09-c756-aligned-split-mixed-search.json
```

Replay without changing the worktree with

```sh
python3 notes/2026-08-09-c756-aligned-split-mixed-search.py \
  --check notes/2026-08-09-c756-aligned-split-mixed-search.json \
  --workers 8
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-09-c756-aligned-split-mixed-search.py` | 22,835 | `f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f` |
| `2026-08-09-c756-aligned-split-mixed-search.json` | 5,075 | `0a95a104856381e48713180ab8e98ccb6965d22563ceb6e5e4d0af52ffe60ffa` |

The trusted boundary is ordinary Python integer arithmetic, the completeness
of the explicit backtracking search, and the stated (mathbf F_{53}) model.
There is no second independent exhaustive enumerator.  The checker does,
however, verify (5) throughout graph construction and recomputes the critical
carrier by a direct coefficient expansion independent of the matching
recurrence.  The result proves only the external-deletion aligned split
covariance branch at ((q,k)=(53,12)).

## EJ + Tao closeout

The cheap structural gain is the unique split normal form (2): the two
square classes that appeared before normalization are coordinate copies, not
separate cases.  The exact type profiles also show that every geometric
survivor is genuinely mixed; uniform type is absent even before criticality.

The Tao-style question is whether (8) has a short resultant explanation.
The complete histogram argues against a constant or square-class invariant,
so no honest human compression emerged for free.  The bounded certificate is
therefore the correct closure.  The higher-EV continuation is the
character-weighted all-center resultant/norm identity, which can couple
different deleted points rather than humanize a branch already closed.

## Mystery ledger

| feature | status | exact evidence gap or owner |
|---|---|---|
| Number of split offset classes | settled: one | normalization (1)--(2) |
| Mixed secant/passant node character | settled | factorization (5) |
| Aligned split critical branch | settled impossible | 230 candidates, all fail (8) |
| Why the first derivative never vanishes | open but non-load-bearing | no short resultant identity; optional C756 humanization only |
| Uniform point type among geometric survivors | settled negative in this bounded branch | all four exact profiles are mixed |
| Remaining external-deletion covariance | open | anisotropic rows (16) and disjoint-root split rows (17), C756 |
| Global point-type discriminator | open | character-weighted all-center resultant/norm law, next C756 gate |
