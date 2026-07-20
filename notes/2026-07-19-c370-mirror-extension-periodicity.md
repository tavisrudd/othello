# C370: all-extension periodicity for the full-`PGL2` mirror family

**Date:** 2026-07-19
**Lane:** `crowns`
**Verdict:** **THEOREM; FOUR-PHASE STRUCTURAL BASE CHANGE FOR EVERY ODD-FIELD MIRROR FAMILY**

## Result

Let `k=F_q`, where `q>=5` is odd, and choose a pair `(delta,b)` passing C333's explicit tests.
Write

\[
S=S_{\delta,b}=\{s_0,s_1,s_2,s_3\}
\]

for the four projection involutions attached, in C333's displayed order, to

\[
\{(0,1,1),(\delta,0,1),(1,b,1),(\delta b,\delta^{-1},1)\}.
\]

Thus the six-point set with the two burned conic points is an arc and
`<S>=PGL_2(k)`.  For `K_n=F_(q^n)`, put

\[
D_n(S)=\bigcup_{0\le i<j\le3}\operatorname{Fix}_{\mathbf P^1(K_n)}(s_js_i)
\]

and let `R_n(S)` be the four-coloured graph on
`P1(K_n)\setminus D_n(S)`, with colour-`i` adjacency `x--s_i x`.  Define

\[
B=R_1(S),\qquad
Q=R_{\mathbf P^1(k^2)\setminus\mathbf P^1(k)}(S),\qquad
C=\operatorname{Cay}(\operatorname{PGL}_2(k),S),
\]

where loops and edges incident with deleted vertices are omitted in `B` and `Q`, and `C` uses
the left-action convention.  Finally set

\[
c_n=
\begin{cases}
(q^{n-1}-1)/(q^2-1),&n\text{ odd},\\
(q^{n-1}-q)/(q^2-1),&n\text{ even}.
\end{cases}
\]

Then, for every `n>=1`, there is a colour-preserving decomposition

\[
R_n(S)\cong
\begin{cases}
B\sqcup c_nC,&n\text{ odd},\\
B\sqcup Q\sqcup c_nC,&n\text{ even}.
\end{cases}
\tag{1}
\]

In particular `c_1=c_2=0`.  The exact four-phase extension table is

| `n mod 4` | embedded determinant phase | quadratic block | parity of `c_n` |
|:--:|:--|:--:|:--:|
| `1` | the C333 outer determinant sheet persists | absent | even |
| `2` | every base-field determinant becomes a square | present | even |
| `3` | the C333 outer determinant sheet persists | absent | odd |
| `0` | every base-field determinant becomes a square | present | odd |

Here “parity of `c_n`” is only the periodic component-parity datum; the actual number of regular
blocks is the exact, nonperiodic coefficient above.  Thus the extension tower has a period-two
quadratic boundary phase and a period-four regular-block parity phase.

Let `P_B,P_Q,P_C` be the projected fractional service-rate regions of the four coloured helper
blocks.  C332's repair-port base change specializes exactly to

\[
P_n=
\begin{cases}
P_B+c_nP_C,&n\text{ odd},\\
P_B+P_Q+c_nP_C,&n\text{ even},
\end{cases}
\tag{2}
\]

where `+` is Minkowski sum and `mP` is the `m`-fold sum.  The same formula holds for the integral
scheduling semigroups.  Equation (2), rather than only the parity of `c_n`, is the operational
base-change statement.

## Compatibility proof

C332 is phrased for three projection involutions, but its decomposition proof applies verbatim to
this fixed four-element set once the compatibility maps are made explicit.

First, the C333 six-arc conditions make the four centres distinct.  The projective
point--involution correspondence therefore makes the four `s_i` distinct, so every `s_js_i` with
`i<j` is nonidentity.  Its fixed points are roots of a nonzero quadratic over `k`; hence

\[
D_n(S)\subseteq\mathbf P^1(k^2)\cap\mathbf P^1(K_n).
\]

The intersection identity

\[
K_n\cap k^2=\mathbf F_{q^{\gcd(n,2)}}
\]

therefore puts all deletion in the base orbit when `n` is odd and in the base plus the single
quadratic orbit when `n` is even.  Adding a fourth colour changes neither this degree bound nor the
orbit support of deletion.

Second, C333 proves `<S>=H=PGL_2(k)`.  Every point of
`P1(K_n)\setminus P1(k^2)` has trivial `H`-stabilizer, so each remaining `H`-orbit is regular.
For a chosen point `x` in such an orbit, the map

\[
H\longrightarrow Hx,\qquad h\longmapsto hx,
\]

takes the colour-`i` Cayley edge `h--s_i h` to the residual edge `hx--s_i hx`.  This is the
required four-colour compatibility map.  Counting the points outside the base and, in even degree,
the quadratic orbit gives precisely `c_n` regular `H`-orbits.  This proves (1).

Third, the repair interpretation assigns colour `i` to target `i`'s radius-two recovery matching.
Because generators preserve `H`-orbits and all deleted helpers lie in the base/quadratic blocks,
both recovery edges and helper capacities are block diagonal under (1).  Feasible allocations on
disjoint helper sets add, proving the fractional Minkowski formula and its integral-semigroup
counterpart in (2).

Finally, for every `a in k^*`,

\[
\chi_{K_n}(a)=\chi_k(a)^n.
\]

When `chi_k(-1)=-1`, C333 uses `det(A_0)=-1` as its outer-sheet witness; when
`chi_k(-1)=1`, its test `chi_k(b-1)=-1` makes `det(A_2)=b-1` the witness.  Either witness remains
nonsquare exactly for odd `n`; for even `n`, every element of `k^*` is a square in `K_n` and the
embedded copy of `PGL_2(k)` lies in `PSL_2(K_n)`.  This changes no `H`-orbit or block count: the
acting group in (1) is still the embedded base group `H`, not `PGL_2(K_n)`.  Since `q` is odd,
reducing the displayed geometric sums for `c_n` modulo two gives the stated `n mod 4` table.

## Scope and value boundary

The same character identity says that C333's nonsquare mirror discriminants stay nonsquare in odd
degree and become square in even degree.  Thus even extensions acquire mirror fixed/adjacency
points and cannot inherit the base mirror certificate unchanged.  This report makes **no**
extension-field Grundy or P/N claim, including in odd degree: it does not evaluate the quadratic
block or isolate and prove a value for the regular four-generator Cayley block.  In particular it
does not reopen C294 or convert component parity into a game outcome.

Nor does (2) assert an improvement over the homogeneous oval service region.  It is an exact
restriction/base-change law for the coloured repair interface and its integral scheduling
semigroup.

## What the composition adds

C332 supplies the general base/quadratic/regular orbit decomposition and blockwise repair law but
not an explicit all-field family.  C333 supplies an explicit full-`PGL2` mirror family for every
odd `q>=5` but only over its construction field.  Their composition gives, uniformly for every
passing `(delta,b)` in every such field, the exact all-extension formula (1), the operational
formula (2), and the determinant/quadratic/component-parity phase table.  No new classical
`PGL_2` orbit classification, base-field mirror theorem, or game value is claimed.

## Evidence boundary

This corollary is a proof-level instantiation and creates no new computational artifact.  Its
load-bearing inputs are C332's theorem and exact replay bundle and C333's theorem and exact replay
bundle:

- `notes/2026-07-18-c332-all-extension-subfield-descent.md`;
- `notes/2026-07-18-c333-all-odd-q-mirror-locus.md`.

C332's checker independently exercises the base/quadratic/regular orbit decomposition and deletion
support for representative prime-field extensions.  C333's checker independently exercises the
six-arc, mirror, determinant, subfield, and full-group certificates in ten odd fields.  Neither
checker evaluates the regular or quadratic scar value, and C370 does not add such an evaluation.
