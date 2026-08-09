# C756 complete \(q=47,k=12\) closure

**Date:** 2026-08-09

**Scope:** every point type in the first \(q=47\) nonsaturated size layer

**Status:** exact negative classification at \(k=12\); no claim for \(k>12\)

## Verdict

\[
 \boxed{\text{No conic-filling }12\text{-arc exists in }
 \mathrm{PG}(2,47).}
\]

The point-type split closes before any generic elimination:

- deleting an external arc point leaves exactly 22 normalized
  covariance-free mixed secant/passant stars; none satisfies even the first
  forced octic-carrier equation \(E_9=0\), and none has one complete center;
- if every arc point is internal, the genuine all-passant normalization has
  no eleven-line geometric star at all.

This settles only \(k=12\).  Higher nonsaturated sizes over \(\mathbf F_{47}\)
have different defects and interpolation windows.

## 1. The residue-class sign

The \(q=53\) geometric engines cannot be specialized by changing the field
size alone.  In the split model

\[
 C:UV=\nu W^2,\qquad \nu=5,\qquad r_0:W=0,
\]

an internal direction is represented by
\([u^{-1}:-u:0]\), whose conic value is \(-1\).  Because
\(47\equiv3\pmod4\),

\[
 \chi(-1)=-1.
\]

Likewise an affine node \([U:V:1]\) is internal exactly when

\[
 \boxed{\chi(UV-\nu)=-1}.                                \tag{1}
\]

This is the opposite sign from the \(q=53\) split engine.  The exact wrapper
therefore pins the old source but replaces its graph edge predicate by (1).
An initial diagnostic run with the unchanged \(q=53\) sign was discarded
before commit and supplies no evidence here.

## 2. External deleted point

Suppose a hypothetical arc contains an external point \(P_0\).  Its polar
\(r_0\) is secant.  Every chord pole \(N_{0i}\) is internal, so after split
torus normalization the other eleven polar lines have equations

\[
 r_i:u_iU+u_i^{-1}V+s_iW=0,\qquad u_i\sim-u_i.            \tag{2}
\]

There are 23 direction classes.  Since
\(4\nu=20\) is nonsquare, \(s_i^2-4\nu\ne0\) for every
\(s_i\in\mathbf F_{47}\); hence every direction has all 47 nontangent
offsets.  This gives 1,081 states.

Edges impose (1), while the forbidden-triple mask imposes dual-arc
nonconcurrency.  Split-torus multiplication fixes one direction and
\(W\mapsto-W\) restricts its offset to \(0,\ldots,23\).  Exhausting those
24 shards gives:

| item | value |
|---|---:|
| states | 1,081 |
| search nodes | 8,655,142 |
| normalized geometric stars | 22 |

Their remaining-line type profiles are

\[
 11\cdot(2\text{ secants},9\text{ passants})
 \quad\text{and}\quad
 11\cdot(5\text{ secants},6\text{ passants}).             \tag{3}
\]

Thus the search retains arbitrary remaining point types rather than imposing
an all-passant hypothesis.

### Octic-window rejection

Translate the 55 star-node centroid to zero and form the elementary binary
projection forms \(E_j\).  The twelve required internal centers force

\[
 E_9=E_{10}=E_{11}=0.                                   \tag{4}
\]

For every one of the 22 geometric leaves, \(E_9\) is already a nonzero
binary form.  Consequently

\[
 \boxed{\text{no external-deletion leaf enters the octic carrier}.}       \tag{5}
\]

As an independent stronger leaf predicate, the twelve missing internal
directions were tested directly.  No leaf has even one complete center.
Every leaf has minimum projection span 36; eleven have maximum span 40 and
eleven have maximum span 41.

Therefore a \(q=47,k=12\) conic-filling arc cannot contain an external point.

## 3. All-internal branch

It remains to suppose all twelve arc points are internal, so all twelve polar
lines are passants.  Put the distinguished passant \(r_0\) at infinity and
write

\[
 C:N(x)=W^2
\]

over \(\mathbf F_{47^2}\).  This loses no conic geometry: for
\(N(x)=dW^2\), norm-surjectivity supplies \(\beta\) with \(N(\beta)=d\), and
\(x=\beta x'\) followed by scalar rescaling sends the equation to the
displayed \(d=1\) model.  The normal norm class transforms simultaneously;
it must not be frozen while \(d\) is changed.

An internal direction has an annihilating normal of nonsquare norm.  Choose
\(N(\alpha_0)=5\), write

\[
 r_i:\operatorname{Tr}(\alpha_0u_i x)+s_iW=0,\qquad N(u_i)=1,             \tag{6}
\]

and identify \((u_i,s_i)\sim(-u_i,-s_i)\).  This gives 24 internal direction
classes and 552 passant states.  Direct enumeration with internal node
character \(-1\) gives

| item | value |
|---|---:|
| states | 552 |
| search nodes | 349,889 |
| normalized eleven-line stars | 0 |

The checker independently enumerates the 48 affine conic points and verifies
that every state in (6) is a passant.  It also checks directly that the
kernel direction has internal character \(-1\).

Thus the all-internal branch fails before projection completeness or the
octic carrier is needed.

## 4. Exact bundles

External-deletion bundle:

- notes/2026-08-09-c756-q47-external-deletion-search.py
- notes/2026-08-09-c756-q47-external-deletion-search.json

All-passant bundle:

- notes/2026-08-09-c756-q47-all-passant-search.py
- notes/2026-08-09-c756-q47-all-passant-search.json

Replay:

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-q47-external-deletion-search.py \
      --check notes/2026-08-09-c756-q47-external-deletion-search.json \
      --workers 8

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-q47-all-passant-search.py \
      --check notes/2026-08-09-c756-q47-all-passant-search.json

Both wrappers pin their earlier geometry engines by SHA-256.  The external
checker reconstructs and centers every node, computes \(E_1,E_9,E_{10},
E_{11}\) as binary forms, evaluates all twelve missing-direction supports by
both sets and bit masks, and checks line/node/triple predicates directly.
The all-passant checker verifies the line type independently by conic
intersection before running the exact clique search.

## EJ + TT closeout

**EJ.**  The decisive audit was the \(\chi(-1)\) sign.  It prevented an
invalid direct specialization from \(q=53\), after which both corrected
point-type branches became small exact searches.  The external branch is
rejected twice—first by \(E_9\), then by direct support—while the internal
branch has no geometric leaf.

**TT.**  The octic carrier did not need elimination.  Its first absent
coefficient \(E_9\) is the right leaf invariant, and the point-type split is
the right outer decomposition.  The resulting proof is simply:

\[
 \text{external point}\Rightarrow E_9\ne0,\qquad
 \text{all internal}\Rightarrow\text{no star}.            \tag{7}
\]

No covariance normal form, resultant sign, or degree-above-eight calculation
enters.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| \(q=47\) internal-node sign | settled | \(-1\), forced by \(47\equiv3\pmod4\) |
| External-deletion geometry | settled | 22 normalized mixed-type stars |
| External-deletion octic window | settled negative | every leaf has \(E_9\ne0\) |
| All-internal geometry | settled negative | no genuine all-passant star |
| Full \(q=47,k=12\) layer | settled negative | point types exhausted |
| Higher \(k\) over \(q=47\) | open | different defect and center window |
| \(q=49,k=12\) | open | characteristic-seven Hasse/divided-power carrier |
