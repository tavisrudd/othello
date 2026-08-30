# C1009 — exact and parity-linear bounded-degree windows

**Lane:** `relconic`

**Status:** Reported 2026-08-30; no manuscript or ergodis source edits.

## Result

Retain the notation from C1001:
\[
 N=\binom{k}{2},\qquad r=\lfloor k/2\rfloor,\qquad
 \beta_k=N-k+\frac6r\binom{k}{4}.
\]
If the uncovered locus of a \(k\)-arc is contained in a degree-\(d\)
plane curve, with \(1\le d\le q\), C1001 proves
\[
 q^2-(N+d-1)q+\beta_k\le0. \tag{1}
\]

Put \(a=N+d-1\).  Equation (1) gives the exact upper window
\[
\boxed{
q\le
\left\lfloor\frac{a+\sqrt{a^2-4\beta_k}}2\right\rfloor .
} \tag{2}
\]
If \(a^2-4\beta_k<0\), no such containment exists at any field order in
the stated Serre range.  This strictly sharpens the coarse C1001 consequence
\(q\le N+d-2\) whenever the upper root lies below \(a-1\).

There is a clean linear specialization.

**Parity-linear window.**  Suppose
\[
1\le d\le r-2.
\]
Then:
\[
\boxed{
\begin{array}{ll}
k=2r:&q\le N+d-k+1,\\[2mm]
k=2r+1:&q\le N+d-k.
\end{array}}
\tag{3}
\]
Thus in this low-degree range the old bound improves by \(k-3\) for even
\(k\) and by \(k-2\) for odd \(k\).

## Proof

Equation (1) is equivalent to
\[
q(a-q)\ge\beta_k.
\]
Put \(t=a-q\).  Then \(t\ge1\) and
\[
t(a-t)\ge\beta_k. \tag{4}
\]
On the small-\(t\) range used below, \(t(a-t)\) is increasing.

Let \(k=2r\).  Direct simplification gives
\[
\beta_k=4r^3-10r^2+8r-3.
\]
At the last value below \(k-2\),
\[
\begin{split}
\beta_k-(2r-3)\bigl(a-(2r-3)\bigr)
  &=(2r-3)(r-1-d)\\
  &>0
\end{split}
\]
when \(d\le r-2\).  Hence no \(t\le2r-3\) satisfies (4), so
\[
t\ge2r-2=k-2.
\]
Therefore
\[
q=a-t\le N+d-1-(k-2)=N+d-k+1.
\]

Let \(k=2r+1\).  Here
\[
\beta_k=2r(2r+1)(r-1),
\]
and
\[
\begin{split}
\beta_k-(2r-1)\bigl(a-(2r-1)\bigr)
 &=r(2r-3)-d(2r-1)\\
 &\ge2r-2>0
\end{split}
\]
for \(d\le r-2\).  Thus \(t\ge2r=k-1\), giving
\[
q\le N+d-1-(k-1)=N+d-k.
\]

Equation (2) is simply the upper root of (1).

## Examples

- \(k=6,d=1\): \(q\le11\), rather than the coarse \(q\le14\).
- \(k=8,d=2\): \(q\le23\), rather than \(q\le28\).
- \(k=10,d=3\): \(q\le39\), rather than \(q\le46\).
- \(k=6,d=3\) lies outside the linear range, but the exact root gives
  \(q\le14\), exactly the characteristic-free cutoff used in C1001's cubic
  tail.

## C1007 component-envelope refinement

The same root extraction applies branchwise to C1007.  In odd order, if a
degree-\(d\) containing curve has rational linear factors of total
multiplicity \(s\) and a positive-degree residual, use
\[
a=N+d-2,\qquad B=\beta_k+s(k-1)
\]
in
\[
q\le\left\lfloor\frac{a+\sqrt{a^2-4B}}2\right\rfloor.
\]
For a completely split curve, use
\[
a=N+d-1,\qquad B=\beta_k+1+d(k-1).
\]
These are exact numerical envelopes for the already-proved component
inequalities; no new geometric input is required.

## Ergodis-controlled discovery

The experimental control interface was fed the exact upper-branch predicate
for \(6\le k\le100\) and \(1\le d\le100\), for \(9500\) rows.  The candidate
plan
\[
d\le r-2
\]
classified all rows exactly: \(9500/9500\), with no false positive or false
negative and outcome hash
`8c4c1a9502882f220766a1f6a8f9c37d433e60341bd0038d677a591d5e3cdd42`.
That bounded run suggested (3); the symbolic proof above is load-bearing.

## Evidence

Replay:

~~~sh
cd /home/tavis/src/othello
python notes/2026-08-30-c1009-bounded-degree-window-refinement.py \
  --check notes/2026-08-30-c1009-bounded-degree-window-refinement.json
sha256sum -c notes/2026-08-30-c1009-bounded-degree-window-refinement.sha256
~~~

The checker verifies the exact-root arithmetic and the parity-range
equivalence on all \(9500\) rows.  It is an independent bounded check, not the
proof of the universally quantified theorem.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-08-30-c1009-bounded-degree-window-refinement.py` | 4369 | `14b697957ef312dd7c8ad192ef2d5820cc5ed8c4ce0c3d5b89d33dd2870767c5` |
| `2026-08-30-c1009-bounded-degree-window-refinement.json` | 1637 | `b0063dc12c811e911d9e0a9c47289f7138e86c483c05f15928129793faa94a5e` |

## Publication routing

C1004 should treat (2) as the natural theorem statement and (3) as its
readable low-degree corollary.  This strengthens the existing C1001/C1007
packet but does not change the prior recommendation: integrate with the
bounded-degree result unless a later equality theory creates standalone
scope.

### Manuscript-ready draft language (not integrated)

> Solving the quadratic obstruction rather than discarding its constant gives
> the exact upper field window
> \[
> q\le\left\lfloor
> \frac{N+d-1+\sqrt{(N+d-1)^2-4\beta_k}}2
> \right\rfloor.
> \]
> In particular, if \(1\le d\le\lfloor k/2\rfloor-2\), then
> \(q\le N+d-k+1\) for even \(k\), and \(q\le N+d-k\) for odd \(k\).
