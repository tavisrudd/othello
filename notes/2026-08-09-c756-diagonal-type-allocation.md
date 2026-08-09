# C756 secant/passant allocation and the four-point diagonal bridge

## Verdict

Refining the star-blocking moments by line type produces a new exact bridge
from global covering to a four-point statistic.  For every four-subset of the
primal arc, count how many of its three diagonal points are internal.  The sum
of this statistic over all four-subsets is exactly the number of pairs of star
vertices joined by a non-arrangement passant.

Under covering, that number has a forced baseline plus an explicitly bounded
``triple-collision budget.''  At \(q=9\) the budget is zero.  An exact census
finds that every admissible internal all-passant quadrangle has two internal
diagonal points, whereas covering would require an average of one.  This gives
a second, local-to-global exclusion of the \(q=9\) blocking profile and points
to a plausible general mechanism: bound the diagonal-type statistic using the
signed four-point invariants already present in C756.

## 1. Type-refined moments

Use the notation
\[
 q=2m-1,\qquad n=m+1,\qquad
 b=\frac{m(m+1)}2
\]
from the dual star-blocking reduction.  Remove the \(n\) arrangement passants
and the \(2m\) conic tangents.  Assuming the star vertices block every
remaining line, let \(p_j\) and \(s_j\) count the remaining passants and
secants containing \(j\ge1\) star vertices.

Every internal point lies on \(m\) passants and \(m\) secants, while every
star vertex lies on exactly two arrangement passants.  Therefore
\[
\begin{array}{lll}
 \displaystyle\sum p_j=2m(m-2),
 &\qquad&
 \displaystyle\sum j p_j=\frac{m(m+1)(m-2)}2,\\[6pt]
 \displaystyle\sum s_j=m(2m-1),
 &&
 \displaystyle\sum j s_j=\frac{m^2(m+1)}2. \tag{1}
\end{array}
\]

Put
\[
 E_p=\sum_{j\ge1}\binom{j-1}{2}p_j,
 \qquad
 E_s=\sum_{j\ge1}\binom{j-1}{2}s_j. \tag{2}
\]
These nonnegative integers measure precisely the excess beyond one- and
two-vertex ordinary lines.  Using
\(\binom j2=(j-1)+\binom{j-1}{2}\), (1), and the total pair count from the
unrefined profile gives
\[
\begin{aligned}
 P&:=\sum\binom j2p_j
   =\frac{m(m-2)(m-3)}2+E_p,\\
 S&:=\sum\binom j2s_j
   =\frac{m(m-1)(m-2)}2+E_s,\\
 E_p+E_s&=\frac{m(m-2)(m-3)(m-5)}8. \tag{3}
\end{aligned}
\]
Thus the slack polynomial found in the line-profile pass is exactly twice
the total triple-collision budget.

## 2. Four-point interpretation

Label the star vertex \(L_i\cap L_j\) by the edge \(ij\) of \(K_n\).  Two
vertices lie on a non-arrangement line exactly when their labels are disjoint
edges.  Such a pair belongs to a unique four-set
\(A=\{i,j,k,\ell\}\).  In the primal quadrangle, the polar of the joining
line is the intersection of the opposite chords \(P_iP_j\) and
\(P_kP_\ell\), one of the three diagonal points.

Let \(r(A)\in\{0,1,2,3\}\) be the number of internal diagonal points of the
quadrangle on \(A\).  Polarity identifies an internal diagonal point with a
passant joining the corresponding two star vertices, so
\[
 \boxed{\qquad P=\sum_{A\in\binom{Y}{4}}r(A).\qquad} \tag{4}
\]
Combining (3) and (4), covering forces
\[
 \sum_A r(A)=\frac{m(m-2)(m-3)}2+E_p,
 \qquad
 0\le E_p\le\frac{m(m-2)(m-3)(m-5)}8. \tag{5}
\]
This is the desired local-to-global interface.  A theorem that places the
four-point character statistic on the wrong side of (5) rules out covering
without classifying the whole saturated support.

## 3. Exact \(q=9\) endpoint

At \(q=9\), \(m=5\), so (3) forces \(E_p=E_s=0\) and
\[
 P=15. \tag{6}
\]
The exact Sage census in the companion certificate enumerates all 180
four-arcs of internal points whose six joins are passants.  Every one has
\[
 r(A)=2. \tag{7}
\]
Consequently, any hypothetical six-arc assembled from these quadrangles
would have
\[
 P=2\binom64=30,
\]
contradicting (6).  The same census independently finds that no saturated
six-arc exists at all; the diagonal calculation is retained because it tests
the new covering mechanism rather than merely repeating the old clique
exclusion.

> **Proposition 27 (certified \(q=9\) star exclusion).**  A star
> configuration dual to six internal points with pairwise passant joins
> cannot block every non-tangent line in \(\mathrm{PG}(2,9)\).

### Reproduction

From the repository root:

```sh
nix-shell -p sage --run \
  'sage -python notes/2026-08-09-c756-q9-star-profile.py --check'
```

The replay prints
`ok: q=9 saturated-internal star profile reproduced`.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-09-c756-q9-star-profile.py` | 6,792 | `b1e94f931c18051def8c5b5051b4ed97c6a8cb71eb2ff110d54e0ee5ffa101d1` |
| `notes/2026-08-09-c756-q9-star-profile.json` | 517 | `b37526fa936e3c9549f662ce49cb888872ec1d33c86e3d4186e343e1dee76f57` |

The certificate uses SageMath 10.7, constructs \(\mathrm{GF}(9)\) with
Sage's primitive modulus, checks the full projective-plane and conic line-type
counts, enumerates quadrangles and six-arcs independently of the older C756
searchers, and records the diagonal histogram `{2: 180}`.

## EJ + TT closeout

**EJ.**  Equation (4) is the valuable result of this pass.  It reconnects the
new covering-only star gate to the earlier four-point row-transition,
cross-ratio, and diagonal-blocker work, but now with a quantitatively forced
global target rather than a heuristic separator.

**TT.**  The \(q=9\) contradiction is certified and small-field.  The census
does not license a uniform claim that \(r(A)\) has fixed parity or a fixed
value: exploratory prime-field checks show mixed diagonal types in larger
fields.  The next step must express \(r(A)\) as an explicit quadratic-character
function of the four-point cross-ratio and compare its aggregate with (5).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| What is the type-refined blocking slack? | settled | equations (3); it is the triple-collision budget |
| Is the global passant-pair count local? | settled | it is \(\sum_A r(A)\) over four-subsets |
| Does the rigid \(q=9\) profile survive? | settled negative | covering needs \(P=15\), while the exact local census forces \(P=30\) |
| Does a universal parity rule for \(r(A)\) follow? | settled negative empirically | larger prime fields exhibit mixed values; do not pursue parity alone |
| Highest-EV next lemma | open | derive the cross-ratio/character formula for \(r(A)\), then seek an aggregate bound strong enough to violate (5) |

## Next action

Compute \((-1)^{r(A)}\) and, if possible, \(r(A)\) itself from the three
opposite-pair cross-ratio expressions of a normalized quadrangle.  Compare the
result with the signed resultant matrix and the existing four-point transition
invariants.  Stop if the aggregate is just the unconstrained fourth moment
already audited in C756.
