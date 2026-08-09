# C756 \(k=13\) ledger and low-field closure

**Date:** 2026-08-09

**Scope:** exact point-type/window ledger for \(k=13\), with geometric
closure at \(q=47,49,53\)

**Status:** the global \(k=13\) problem is reduced to \(q=59,61\)

## Verdict

For \(k=13\), the 12-line deleted-point star has

\[
 \binom{12}{2}=66
\]

nodes and defect

\[
 \delta=66-q.
\]

The direction bound restricts the new odd-field window to

\[
 q\in\{47,49,53,59,61\}.                                 \tag{1}
\]

Exact geometry eliminates the first three:

\[
 \boxed{\text{No conic-filling }13\text{-arc exists over }
 \mathbf F_{47},\mathbf F_{49},\text{ or }\mathbf F_{53}.} \tag{2}
\]

Consequently the global fixed-size question is reduced exactly to

\[
 \boxed{q=59\quad\text{or}\quad q=61.}                   \tag{3}
\]

Unlike the closed \(k=12\) layer, these two fields retain live geometric and
coefficient systems.

## 1. Exact point-type/window ledger

For a deleted point \(P\), the number of required internal centers is

\[
 h(P)=
 \begin{cases}
 (q-1)/2-12,&P\text{ external},\\
 (q+1)/2-12,&P\text{ internal}.
 \end{cases}                                             \tag{4}
\]

The simultaneous projection argument forces

\[
 E_j=0\qquad
 \left(\delta+1\le j\le h(P)-1\right).                   \tag{5}
\]

Thus:

\[
\begin{array}{c|c|c|c|c|c}
q&\delta&h_{\rm ext}&h_{\rm int}
 &P\text{ external}&P\text{ internal}\\ \hline
47&19&11&12&\text{none}&\text{none}\\
49&17&12&13&\text{none}&\text{none}\\
53&13&14&15&\text{none}&E_{14}=0\\
59&7 &17&18&E_8=\cdots=E_{16}=0&E_8=\cdots=E_{17}=0\\
61&5 &18&19&E_6=\cdots=E_{17}=0&E_6=\cdots=E_{18}=0.
\end{array}                                               \tag{6}
\]

This explains why copying the \(k=12\) carrier is invalid.  At \(q=47,49\)
there is no free interpolation coefficient at all; \(q=53\) has only one,
and only after deleting an internal point.  The strong new carriers begin at
\(q=59,61\).

The split distinguished-line internal-node character is

\[
 \chi(-1)=
 \begin{cases}
 -1,&q=47,59,\\
 +1,&q=49,53,61.
 \end{cases}                                             \tag{7}
\]

Every finite search must retain this residue-class sign.

## 2. Geometry at \(q=47\)

If an arc contains an external point, deleting it requires a twelve-line
mixed secant/passant star in the corrected split graph.  Exact enumeration
gives:

| item | value |
|---|---:|
| states | 1,081 |
| search nodes | 5,078,055 |
| normalized twelve-line stars | 0 |

If every point is internal, all polar lines are passants.  The pinned
\(q=47\) all-passant certificate already has no eleven-line star, hence
cannot contain a twelve-line star.  This proves the \(q=47\) part of (2)
without a coefficient window.

## 3. Geometry at \(q=49\)

The native \(\mathbf F_{49}\) split graph similarly gives:

| item | value |
|---|---:|
| states | 1,176 |
| search nodes | 9,503,210 |
| normalized twelve-line stars | 0 |

The all-passant certificate has no eleven-line star.  Therefore both point
types fail geometrically, proving the \(q=49\) part of (2).

## 4. Geometry at \(q=53\)

For external deletion, the covariance-free mixed graph gives:

| item | value |
|---|---:|
| states | 1,378 |
| search nodes | 32,396,729 |
| normalized twelve-line stars | 0 |

For the all-internal branch, the genuine anisotropic all-passant row gives:

| item | value |
|---|---:|
| states | 702 |
| search nodes | 1,219,168 |
| normalized twelve-line stars | 0 |

Thus even the internal-only equation \(E_{14}=0\) is unnecessary, proving
the \(q=53\) part of (2).

## 5. Why only \(q=59,61\) remain

For a nonsaturated \(13\)-arc,

\[
 66\ge q+2,
\]

so \(q\le64\).  The saturated alternatives would force \(q=25\) or \(q=23\),
already inside the exact \(q\le43\) classification.  Even characteristic is
impossible by the nucleus obstruction.  The odd prime powers in
\((43,64]\) are precisely those in (1).  Sections 2--4 remove the first
three, proving (3).

At \(q=59\), a bounded sequential mixed-star search was stopped after
exceeding the cheap-search budget without either a witness or exhaustion.
That interrupted diagnostic is not evidence.  The next exact pass should
shard the search and test \(E_8,\ldots,E_{16}\) at leaves.  At \(q=61\), the
even stronger \(E_6,\ldots,E_{17}\) window should be inserted from the
outset.

## 6. Exact replay

Bundle:

- notes/2026-08-09-c756-k13-low-field-star-search.py
- notes/2026-08-09-c756-k13-low-field-star-search.json

Replay:

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-k13-low-field-star-search.py \
      --check notes/2026-08-09-c756-k13-low-field-star-search.json \
      --workers 8

The wrapper pins six prior scripts/certificates by SHA-256, changes only the
target star size to twelve, reruns every external-deletion search, and
directly reruns the \(q=53\) all-passant row.  The \(q=47,49\) all-passant
certificates already exclude the smaller size eleven and are consumed as
monotone geometric obstructions.

## EJ3 + TT closeout

**EJ3.**  The useful split is by interpolation strength, not just field
size.  The zero-window fields \(47,49\) and one-equation field \(53\) die at
the raw geometry gate.  Only the fields with long windows survive.

**TT.**  The global synthesis converts three finite computations into the
sharp frontier (3).  There is no reason to revisit \(k=12\), and no reason
to build nonexistent carriers at \(q=47,49\) for \(k=13\).  The next object
is a leaf-aware \(q=59/61\) coefficient search.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| \(k=13\) field window | settled | only \(47,49,53,59,61\) above the known range |
| Point-type coefficient windows | settled | table (6) |
| \(q=47,49,53\) | settled negative | no required twelve-line geometry |
| \(q=59\) | open | shard mixed and all-passant geometry; test \(E_8,\ldots,E_{16}\) |
| \(q=61\) | open | exploit \(E_6,\ldots,E_{17}\), beginning at covariance degree |
| Global \(k=13\) layer | reduced | exactly the two fields \(59,61\) remain |
