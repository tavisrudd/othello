# C756 star collision character identity

**Date:** 2026-08-09

**Scope:** bounded Tao continuation after the complete \(q=53,k=12\) closure

**Status:** exact finite identity and shorter aggregate obstruction; no all-\(k\) theorem

## Outcome

For a finite affine point set \(B\), a center \(c\) on the distinguished line
\(r_0\), and projection fibre sizes \(f_c(t)\), put

\[
 \rho_B(c)=\sum_t\binom{f_c(t)}2.
\]

Every unordered pair of points of \(B\) contributes once, at the point where
its joining line meets \(r_0\).  If \(r_0=I\sqcup E\) is split into internal
and external points, with \(\epsilon=+1\) on \(I\) and \(-1\) on \(E\), then

\[
 \boxed{\sum_{c\in I}\rho_B(c)=N_I(B)},\qquad
 \boxed{\sum_{c\in r_0}\epsilon(c)\rho_B(c)
 =2N_I(B)-\binom{|B|}{2}},                                      \tag{1}
\]

where \(N_I(B)\) counts unordered pairs whose join has internal direction.
This character-weighted all-center collision identity is elementary double
counting, valid independently of the special star geometry.

## The 44 all-passant stars

For each normalized \(q=53\) star, \(B\) consists of the 55 pairwise nodes of
eleven arrangement lines.  Its \(\binom{55}{2}=1485\) node pairs split as

- \(11\binom{10}{2}=495\) pairs sharing an arrangement line, whose joins have
  internal arrangement directions;
- \(3\binom{11}{4}=990\) pairs joining opposite nodes of a four-line
  subarrangement.

The exact audit gives, identically on all 44 stars,

\[
 990=452+538,
\]

with 452 internal and 538 external opposite-node directions.  The diagonal
character sum is therefore \(452-538=-86\).  Adding the 495 shared-line pairs
gives total character sum 409, so (1) becomes

\[
 \sum_{c\in I}\rho_B(c)=\frac{1485+409}{2}=947.                 \tag{2}
\]

Of the 452 internal diagonal pairs, 162 land at one of the eleven used
arrangement centers and 290 at one of the sixteen missing internal centers:

\[
 \boxed{947=657+290}.                                          \tag{3}
\]

The exact energy multisets are

\[
\begin{aligned}
\rho_{\rm used}&=(51,51,58,58,61,62,62,62,62,63,67),\\
\rho_{\rm missing}&=(13,14,15,16,16,16,17,18,18,19,20,20,20,22,22,24).
\end{aligned}                                                   \tag{4}
\]

This is not a one-orbit artifact under the certificate normalization: the 44
records occupy four dihedral orbits, with hit counts \(22,14,6,2\), and all
four have the same profile.

## Aggregate obstruction

A complete projection of 55 points onto all 53 fibres has total excess two.
Its fibre multiplicities are either two double fibres or one triple fibre, so
its collision energy is 2 or 3.  If all sixteen missing internal centers were
complete, their total energy would be at most \(16\cdot3=48\).  Equation (3)
instead gives

\[
 290>48.
\]

Thus one all-center count rejects all 44 leaves.  The earlier center-by-center
span calculation remains stronger diagnostic data but is not needed for this
shorter exact rejection.

## Four-line refinement

For every star the 330 four-line subsets have the same distribution:

\[
\begin{array}{c|rrrr}
\text{internal diagonals}&0&1&2&3\\ \hline
\text{four-line subsets}&48&138&118&26.
\end{array}                                                     \tag{5}
\]

It recovers \(138+2\cdot118+3\cdot26=452\).  The first three signed moments
of the local triple are \(-86,-34,-2\).  These are exact certificate facts,
not a proved symbolic consequence of the six internal vertices of a
four-line complete quadrilateral.

## Relation to the resultant/norm law

The collision identity and residual norm identity operate on opposite sides
of the completeness gate.

- Equation (1) is defined for every projection and counts collisions before
  any quotient \(D=(T^q-T)E\) exists.
- Once a center is complete, the degree-two residual divisor \(E\) exists and
  its character trace/norm obeys
  \(W^2=2(1+\chi(\operatorname{Res}(E,Q)))\); the product over centers gives
  the exact \((Z-1)/(Z+1)\) norm polynomial in the prior all-center report.

Thus (1)--(3) supply an aggregate prefilter.  They do not recover the missing
sign from the scalar residual norm and do not extend that norm formula to
incomplete centers.

## Reproducibility

Exact bundle:

- notes/2026-08-09-c756-star-collision-character.py
- notes/2026-08-09-c756-star-collision-character.json

Replay:

    python3 notes/2026-08-09-c756-star-collision-character.py \
      --check notes/2026-08-09-c756-star-collision-character.json

The checker pins the earlier geometry script and certificate by SHA-256,
reconstructs all 55 affine nodes, identifies internal directions by exact
annihilation against the 27 torus normals, checks the 495 shared-line pairs,
and recomputes every diagonal and projection energy.

## EJ + TT closeout

The extra-juice audit checked

\[
495+990=1485,\quad452+538=990,\quad495+452=947,\quad
495+162=657,\quad162+290=452.
\]

It also checked the common profile separately across all four normalized
dihedral orbits.  The Tao pass compresses the finite rejection to one
character-weighted pair count plus the defect-two bound \(\rho\le3\) at a
complete center.  The explicit stop rule fires here: the bounded pass did not
derive \(-86\), (5), or all-\(q\)/all-\(k\) analogues symbolically.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| All-center collision identity (1) | proved generally | elementary pair-direction double count |
| Common \(q=53\) values \(947,657,290\) | exact finite fact | replay covers all 44 stars and four dihedral orbits |
| Why the diagonal character sum is \(-86\) | genuine structural mystery | derive a four-line character/Jacobi identity or an association-scheme moment |
| Four-line histogram \((48,138,118,26)\) | exact but unexplained | find which moments follow from the internal-node clique equations |
| All-\(k\) obstruction | open | no extrapolation from this \(q=53,k=12\) profile |
