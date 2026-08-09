# C756 nonsaturated point-type ledger

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** exact mixed-type
reduction at the first open fields; no manuscript edit

## Verdict

The nonsaturated star reduction does **not** require an all-internal arc.
For every deleted arc point, polarity gives a mixed secant/passant line
arrangement whose pairwise nodes are nevertheless all internal.  The internal
nonnodes on the deleted point's polar line are exactly the centers coming from
its spare passants.  This yields a type-uniform simultaneous projection
identity.

At the first candidate size \(k=12\), the exact interpolation windows are

\[
\begin{array}{c|c|c|c}
q&\delta=55-q& P\text{ external}&P\text{ internal}\\ \hline
47&8&e_9=e_{10}=e_{11}=0&e_9=\cdots=e_{12}=0\\
49&6&e_7=\cdots=e_{12}=0&e_7=\cdots=e_{13}=0\\
53&2&e_3=\cdots=e_{14}=0&e_3=\cdots=e_{15}=0.
\end{array}                                                \tag{1}
\]

Thus the degree-nine node separators and degree-ten star generators lie in
the forced window at all three fields and for both deleted-point types.  The
consequences differ:

- at \(q=47\), characteristic exceeds the star degrees, so ordinary
  polarization gives a bounded degree-eight moment carrier;
- at \(q=53\), both point types give the same rank-two covariance critical
  system and nonzero separator Hessian; the all-internal hypothesis first
  enters when conic line types and offsets are imposed;
- at \(q=49\), characteristic seven begins exactly at the first forced
  coefficient.  Ordinary polarization loses mixed degree-seven and higher
  moments, so the star contraction needs Hasse/divided-power data.  Copying
  the \(q=53\) moment argument would be invalid.

For an external deleted point at \(q=53\), the fixed-conic restriction is
split rather than anisotropic.  A new exact overlap calculation leaves a
finite Hasse table, rules out covariance sharing exactly one conic root, and
isolates proportional split covariance as the new aligned escape.

This completes the requested point-type equation ledger.  It does not force
uniform type and does not classify the fields: \(k=12\) is their first
candidate layer, not their only nonsaturated size.

## 1. Polarity ledger

Fix an odd \(q\), a nonsingular conic \(C\), and a conic-external \(k\)-arc
\(A=\{P_0,\ldots,P_{k-1}\}\).  Write

\[
 r_i=P_i^\perp,
 \qquad N_{ij}=r_i\cap r_j=(P_iP_j)^\perp.
\]

The standard point-line type dictionary is

| primal point | polar line | passants through the point | internal points on the polar line |
|---|---|---:|---:|
| external | secant | \((q-1)/2\) | \((q-1)/2\) |
| internal | passant | \((q+1)/2\) | \((q+1)/2\) |

Every chord \(P_iP_j\) is a passant.  Its pole \(N_{ij}\) is therefore
internal, independently of the types of \(P_i,P_j\).  The arc condition says
that no three of the \(r_i\) are concurrent.  Consequently polarity turns an
arbitrary-type conic-external arc into

> a mixed secant/passant dual-arc arrangement with every pairwise
> intersection internal.

This is the correct replacement for the all-passant premise.

Fix \(P_0\) and put \(n=k-1\).  The line \(r_0\) contains the \(n\) distinct
internal arrangement points \(N_{0i}\).  Every other internal point
\(L\in r_0\) is the pole of a passant through \(P_0\) which is not a chord,
and conversely.  Hence the exact number of required centers is

\[
 h(P_0)=
 \begin{cases}
 (q-1)/2-(k-1),&P_0\text{ external},\\
 (q+1)/2-(k-1),&P_0\text{ internal}.
 \end{cases}                                               \tag{2}
\]

Let

\[
 S_0=\{N_{ij}:1\le i<j\le n\},
 \qquad |S_0|=\binom{k-1}{2}=q+\delta.                    \tag{3}
\]

For every one of the \(h(P_0)\) centers, the pencil projection of \(S_0\)
meets all \(q\) lines other than \(r_0\).  This is exactly the primal covering
condition on the corresponding spare passant.  The statement uses only that
the nodes are the complete star and that chord poles are internal; the
remaining \(r_i\) may be secants or passants.

## 2. Aggregate type counts

Let \(e\) be the number of external points of \(A\).  Summing (2) gives the
number of ordered deleted-point/spare-passant systems:

\[
 S(A)=k\left(\frac{q+1}{2}-(k-1)\right)-e.                \tag{4}
\]

At \(k=12\), this is \(156-e,168-e,192-e\) for
\(q=47,49,53\), respectively.  Point type is therefore visible before any
choice of covariance or torus.

There is also an exact type-split chord-excess ledger.  Let \(b=\binom k2\)
and let \(d_X\) be the number of chords through an off-conic point \(X\).
A passant contains \((q+1)/2\) external and \((q+1)/2\) internal points,
while the plane has \(q(q+1)/2\) external and \(q(q-1)/2\) internal points.
Therefore

\[
\begin{aligned}
 \sum_{X\ \mathrm{external}}(d_X-1)
   &=\frac{(q+1)(b-q)}2,\\
 \sum_{X\ \mathrm{internal}}(d_X-1)
   &=\frac{(q+1)(b-q)}2+q.                               \tag{5}
\end{aligned}
\]

After removing the arc points themselves, whose excess is \(k-2\), the
\(k=12\) values are

| \(q\) | external nonarc excess | internal nonarc excess | signed difference |
|---:|---:|---:|---:|
| 47 | \(456-10e\) | \(383+10e\) | \(73-20e\) |
| 49 | \(425-10e\) | \(354+10e\) | \(71-20e\) |
| 53 | \(351-10e\) | \(284+10e\) | \(67-20e\) |

These identities do not force \(e\), but any all-type search or masked
moment argument should enforce them.

For a nonarc point \(X\), let

\[
 s_A(X)=\#\{P\in A:\ XP\text{ is a spare passant through }P\}.
\]

The \(d_X\) chord lines through \(X\) use \(2d_X\) arc endpoints, so if
\(p_A(X)\) denotes the number of arc points joined to \(X\) by a passant,
then \(s_A(X)=p_A(X)-2d_X\).  Summing the direction excess \(\delta\) over
all systems in (4) gives the exact global collision identity

\[
 \boxed{
 \delta S(A)=
 \sum_{X\notin A\cup C}(d_X-1)s_A(X).}                  \tag{6}
\]

This retains the deleted-point identity that was lost when the center masks
were collapsed one at a time.

There is an exact character-weighted form.  Put
\(\tau(X)=+1\) on external points and \(-1\) on internal points.  On a spare
passant \(\ell\), scale the nonvanishing conic restriction \(Q_\ell(T)\) so
that \(\chi(Q_\ell(X))=\tau(X)\).  If \(E_{P,\ell}\) is the
degree-\(\delta\) residual direction polynomial, then

\[
 W_{P,\ell}
 =\sum_{t\in\mathbf F_q}
   \operatorname{ord}_t(E_{P,\ell})\chi(Q_\ell(t))        \tag{6a}
\]

is the signed excess on that spare line, and

\[
 \sum_{(P,\ell)}W_{P,\ell}
 =\sum_{X\notin A\cup C}\tau(X)(d_X-1)s_A(X).           \tag{6b}
\]

At defect two, \(E_{P,\ell}\) is either supported at two simple residual
roots or twice at one root.  Hence

\[
 W_{P,\ell}\in\{-2,0,2\}.                                \tag{6c}
\]

Equations (6a)--(6c) are the concrete character refinement of (6).  What is
not yet known is a formula for their total in terms of \(e\).  The natural
next input is the resultant or norm of \(E_{P,\ell}\) against \(Q_\ell\),
which records the product of the two residual characters and distinguishes
the zero-sum case.

## 3. Type-uniform projection theorem

Take \(r_0\) as the line at infinity and choose its coordinate so that none
of the required centers is the coordinate point at infinity.  Write the
affine nodes as \(v=(x_v,y_v)\), put

\[
 c_v(t)=y_v-tx_v,
 \qquad
 H(t,C)=\prod_{v\in S_0}(C-c_v(t))
       =\sum_{j=0}^{q+\delta}(-1)^je_j(t)C^{q+\delta-j}.  \tag{7}
\]

At a required center \(t\), direction completeness gives

\[
 H(t,C)=(C^q-C)R_t(C),\qquad \deg R_t=\delta.             \tag{8}
\]

The product in (8) has no coefficients in degrees
\(q-1,q-2,\ldots,\delta+2\).  Hence every required center is a root of

\[
 e_j(t)\quad(\delta+1\le j\le q-2).                      \tag{9}
\]

Since \(\deg_t e_j\le j\), the \(h(P_0)\) distinct centers force the binary
form identity

\[
 \boxed{
 e_j\equiv0\quad
 (\delta+1\le j\le\min(q-2,h(P_0)-1)).}                 \tag{10}
\]

This proves (1).  It also explains why \(q=47\) is the first \(k=12\) field
where the whole star ideal enters uniformly.  The star generators have
degree \(k-2=10\) and the single-node separators degree \(k-3=9\).  For an
external deleted point, the generator degree lies in (10) as soon as

\[
 q\ge4k-3,
 \qquad
 q\ge\binom{k-2}{2}+1.                                  \tag{11}
\]

At \(k=12\), the second inequality is \(q\ge46\), so \(q=47\) is the first
odd prime power satisfying both.

The statement is size-local.  At \(q=47,49,53\), a nonsaturated example with
\(k>12\) has a different defect and window and must still be treated.

## 4. What the windows imply

Translate the 55-node centroid to the origin.  This is valid at all three
fields because \(55\ne0\) in characteristics \(47,7,53\).

### \(q=47\): bounded octic carrier

Here \(e_1=0\), the low projection forms \(e_2,\ldots,e_8\) remain, and
\(e_9,e_{10}\) vanish for either point type.  Newton identities express
projection power sums through degree ten in those low forms.  Since
characteristic 47 exceeds ten, ordinary polarization recovers every binary
moment through the star-generator degree.  Thus all eleven generator
contractions and all degree-nine separator values form a bounded system over
the quadratic-through-octic carrier.

This is substantially larger than the rank-two \(q=53\) carrier, but it is
finite and retains the mixed secant/passant star realization.

### \(q=49\): the characteristic-seven wall

Here the low forms are \(e_2,\ldots,e_6\), while \(e_7,\ldots,e_{12}\) or
\(e_{13}\) vanish.  It is tempting to repeat the preceding argument.  That
would be wrong: in characteristic seven,

\[
 (sU+tV)^7=s^7U^7+t^7V^7,                                \tag{12}
\]

so the degree-seven projection power loses every mixed moment.  Higher
degrees through ten remain Frobenius-blind in additional coefficients by
Lucas's theorem.  The ordinary polarized moment functional therefore does
not determine the degree-nine separators or degree-ten generators from
\(e_2,\ldots,e_6\).

The identities \(e_7,\ldots\) themselves remain valid binary-form identities.
The correct carrier must retain their Hasse/divided-power coefficients, or
work directly with the elementary multisymmetric data.  This is a distinct
\(q=49\) branch, not a smaller version of the \(q=47\) carrier.

The wall identifies the first new invariant cleanly.  Centering makes the
seventh power sum vanish automatically,
\(p_7(z)=p_1(z)^7=0\), while the independently forced elementary coefficient
\(e_7(z)=0\) survives.  Thus \(e_7\) is genuinely divided-power information,
not a disguised ordinary moment.

### \(q=53\): covariance and Hessian are type-uniform

For an external deleted point, (10) gives \(e_3,\ldots,e_{14}=0\); for an
internal point it gives one further coefficient.  The common range through
degree fourteen already contains everything used in the singular-covariance
proof, the degree-ten generator contractions, the degree-nine separator
Hessian, and the degree-eleven partition polynomial.  Therefore, for **either
deleted-point type**:

\[
 \operatorname{rank}M=2,
 \qquad \nabla\mathcal Z(c)=0,
 \qquad \partial_i\partial_j\mathcal Z(c)\ne0\quad(i\ne j). \tag{13}
\]

The arrangement lines may still be mixed.  The all-internal hypothesis is
needed later, when every line is parameterized as a passant and its conic
offset and node characters are imposed.  The previously certified aligned
search remains correct for that all-passant specialization.

## 5. The \(q=53\) conic-overlap ledger by deleted-point type

### Deleted point internal

Then \(r_0\) is a passant and the conic restriction \(C|_{r_0}\) is
anisotropic.  Its 27 internal directions split into 16 required centers and
11 arrangement nodes.  The existing elliptic-overlap proof applies without
assuming that the remaining \(r_i\) are passants:

- nonaligned anisotropic covariance has trace \(-10\) or \(-14\) and at
  least ten nonsquare arrangement diagonal values;
- split covariance lies in the seven recorded trace/zero rows and has at
  least nine nonsquare arrangement diagonal values;
- covariance proportional to \(C|_{r_0}\) is the aligned anisotropic escape.

The later offset descent must still distinguish which of the remaining lines
are secants and which are passants.

### Deleted point external

Now \(r_0\) is a secant.  Scale its split conic restriction \(C\) so that
\(\chi(C)=+1\) on its 26 internal nonconic points.  These split exactly into
15 required centers and 11 arrangement nodes.

Let \(K\) be the nonsingular covariance quadratic and put

\[
 S(C,K)=\sum_{L\in\mathbf P^1(\mathbf F_{53})}\chi(C(L)K(L)). \tag{14}
\]

When \(C,K\) have four distinct geometric roots, the double cover
\(W^2=CK\) is elliptic and \(|S(C,K)|\le14\).

If \(K\) is anisotropic, let
\(T_C=\sum_{C(L)=0}\chi(K(L))\in\{-2,0,2\}\).  The number \(I\) of internal
directions with square covariance is

\[
 I=\frac{52-T_C+S(C,K)}4.                                \tag{15}
\]

Since the 15 centers are counted by \(I\), the Hasse and integrality rows are

\[
\begin{array}{c|c|c}
T_C&S(C,K)&I\\ \hline
-2&6,10,14&15,16,17\\
0&8,12&15,16\\
2&10,14&15,16.
\end{array}                                               \tag{16}
\]

Thus at least nine of the eleven arrangement values are nonsquares.

Suppose \(K\) is split.  If its roots are disjoint from those of \(C\), put

\[
 T_K=\sum_{K(L)=0}\chi(C(L))\in\{-2,0,2\}.
\]

The number \(J\) of internal directions on which \(K\) is square or zero is

\[
 J=\frac{54-T_C+T_K+S(C,K)}4.                            \tag{17}
\]

Hence \(15\le J\le18\), with
\(54-T_C+T_K+S\) divisible by four.  At least eight arrangement values are
nonsquares.

If \(C\) and \(K\) share exactly one rational root, write
\(a=\chi(C)\) at the other root of \(K\) and
\(b=\chi(K)\) at the other root of \(C\).  The degenerate character sum is
\(S\in\{-1,1\}\), and the favorable internal count is

\[
 J=\frac{53+a-b+S}{4}\le14.                              \tag{18}
\]

This cannot contain all 15 centers.  Sharing exactly one root is therefore
impossible.  Sharing both roots means \(K\sim C\), the **aligned split
escape**, on which all 26 internal directions are favorable and Hasse gives
no restriction.

The external-deletion covariance branches are therefore:

1. anisotropic covariance in the seven rows (16);
2. split covariance with disjoint roots and the finite constraint (17);
3. aligned split covariance \(K\sim C\).

## 6. Exact search ledger

An all-type search at a fixed \((q,k)\) must retain:

1. the external-point count \(e\);
2. the equitable conic-external graph partition by point type;
3. the arc/no-three-collinear condition;
4. full off-conic covering;
5. the type-split excess identities (5);
6. all \(S(A)\) deleted-point/spare-passant quotient systems, not one selected
   center;
7. for \(k=12\), the coefficient windows (1);
8. at \(q=49\), Hasse/divided-power rather than ordinary moment variables.

The existing exhaustive program already starts once from each conic point
orbit and therefore does not assume uniform type.  It has not been run or
certified at \(q=47,49,53\), and its \(q=43\) runtime makes an unchanged
extension a poor first move.  Type-profile and quotient-window pruning should
be inserted before a new certified run.

## 7. Consequences for the live route

1. Withdraw the statement that the \(q=53\) moment/separator/covariance
   system itself is all-internal.  It is type-uniform.
2. Keep the existing all-passant aligned certificate with its correct narrow
   quantifier: it closes the all-internal aligned offset specialization.
3. Treat the conic-overlap and offset stages by deleted-point type.  Internal
   deletion uses the old anisotropic table; external deletion uses (16)--(18).
4. Promote \(q=47\) to a bounded octic star-carrier problem.
5. Treat \(q=49\) as a characteristic-seven divided-power problem.
6. Do not call any one \(k=12\) analysis a classification of the whole field;
   higher nonsaturated sizes remain.

The highest-EV next exact branch is the \(q=53\) external-deletion aligned
split escape \(K\sim C\).  It is the split-torus counterpart of the closed
aligned anisotropic calculation and is the cheapest place to seek a forced
node-character collision or zero separator Hessian for arcs containing an
external point.

## Mystery ledger

- **Settled — point-type location:** type affects the polar line and the
  center count, but not internality of star nodes or the projection identity.
- **Settled — \(q=53\) covariance scope:** rank two, criticality, and open
  separator Hessian hold for either deleted-point type.
- **Settled — external distinguished-line overlap:** one shared conic root is
  impossible; the remaining branches are (16), (17), and aligned split.
- **Unsettled — uniform type:** none of (2), (4)--(6), or (10) forces
  \(e\in\{0,k\}\).
- **Unsettled — \(q=49\) carrier:** ordinary polarization fails at the exact
  first forced degree.  A Hasse/divided-power star contraction is required.
- **Unsettled — higher sizes:** the first-size ledgers do not propagate to
  \(k>12\).
- **Unsettled — cross-deletion compatibility:** one arc supplies a critical
  system for every deleted point, but no transition law between their
  centroids and covariance forms is recorded.
- **EJ + Tao closeout lead:** equation (6) is the first global identity that
  retains every deleted point and every spare line.  Equations (6a)--(6c)
  settle its exact local character refinement; the cheapest remaining
  discriminator is a resultant/norm law for its total, split by
  external/internal \(X\).

## Authorities

- Universal and bounded foundation:
  `notes/2026-08-01-c756-all-k-conic-filling.md`.
- Direction quotient:
  `notes/2026-08-01-c756-nonsaturated-direction-reduction.md`.
- Original all-internal star formulation:
  `notes/2026-08-09-c756-defect-two-star-near-transversal.md`.
- Moment collapse and separator proof:
  `notes/2026-08-09-c756-tt-star-moment-collapse.md`.
- Rank-two partition function:
  `notes/2026-08-09-c756-ej2-torus-contraction.md`.
- Original anisotropic overlap table:
  `notes/2026-08-09-c756-ej3-elliptic-overlap-squeeze.md`.
- Conditional all-passant aligned closure:
  `notes/2026-08-09-c756-aligned-critical-closure.md`.
