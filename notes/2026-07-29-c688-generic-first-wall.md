# C688: generic local first-wall checker

**Lane**: `clebsch`

**Date**: 2026-07-29

## Verdict

The field-sized q=169 adapted-dual-Weyl replay has been replaced by a
parameterized local checker.  For every odd prime \(p\), exponent \(e>1\),
and even \(s\) with \(0\le s<p-1\), it constructs only
\[
 S=L(s),\qquad T=L(p-2,1),\qquad
 R=L(p-2-s,1),\qquad Y=L(0,2).
\]
No extension field, \(\operatorname{Sym}^{(p^e-3)/2}V\), symmetric square,
or other field-sized module is constructed.

Put \(r=p-2-s\).  The checker derives the two occurrence packets from
\[
 e(p-1)/2\equiv1+s/2\pmod2,
\]
constructs normalized divided-power Clebsch--Gordan maps for the zeroth
and first Frobenius digits, and constructs the normalized local first-wall
row.  The latter has exactly \(r\) unit trace terms, hence trace coordinate
\(r\), and one normalized nonzero spill coordinate in \(Y\otimes R\).
The middle-factor support enumeration finds the unique adjacent row
\((p-2,1)=T\).

Since \(1\le r<p\), the trace coordinate is nonzero in
\(\mathbb F_p\).  The two witness targets have exact dimensions
\[
 2(s+1)(p-1),\qquad 6(p-1-s).
\]
These are linear in \(p\) and independent of \(e\).

## Local maps

In monomial divided-power normalization, the highest vector for
\[
 L(a+b-2k)\longrightarrow L(a)\otimes L(b)
\]
has coefficients
\[
 c_0=1,\qquad
 c_{j+1}=-\frac{k-j}{j+1}c_j.
\]
The checker generates every column by divided lowering, verifies both
root-operator intertwining equations, and hashes the resulting canonical
sparse map.  C688 uses \((a,b,k)=(r,p-2,r)\) in the zeroth digit and
\((1,1,1)\) in the Frobenius digit.  Sparse entry count may be quadratic,
but the only module records are \(S,T,R,Y\), whose dimensions are linear
in \(p\).

The first specialization collapses further than required.  Vandermonde
cancellation makes it the exact Toeplitz band
\[
 v_m\longmapsto
 \sum_{j=0}^{r}(-1)^j\binom rj\,
 v_j\otimes w_{r-j+m}.                       \tag{T}
\]
Because \(r<p\), every displayed binomial coefficient is nonzero modulo
\(p\).  Thus every source column has exactly \(r+1\) entries and the full
map has exactly \((s+1)(r+1)\) nonzero entries.  The primary recurrence and
independent closed-form replay both verify (T); this gives a formula-level
compression stronger than retaining only the sparse-map hash.

The adjacent-wall theorem remains a human representation-theoretic input:
it identifies the normalized row.  Conditional on that theorem, the
checker verifies the local map, trace, unique spill, Borel gap, and target
dimensions.  It does not replace either the Lucas-socle theorem deciding
occurrence or the exceptional-subgroup calculation deciding PGL outer
parity.

## Occurrence packets and torus gap

The congruence gives exactly
\[
\begin{array}{c|c}
s\bmod4&\text{occurrence condition}\\ \hline
2&e(p-1)/2\equiv0\pmod2,\\
0&e(p-1)/2\equiv1\pmod2.
\end{array}
\]
For \(Y\otimes R\), the coefficient-\(1\) target weights occupy
\([s+2,\,2p-2-s]\), and the coefficient-\((-1)\) weights occupy
\([-(2p-2-s),\,-s-2]\).  Both intervals are strictly separated from
the source interval \([-s,s]\).  The coefficient-\(\pm3\) intervals are
farther away.  For every case except \((p,s,e)=(3,0,2)\), the maximum
source--target difference \(4p-2\) is strictly below \(p^e-1\), so no
equality reappears modulo the split-torus order.

The sole wrap seam is harmless but was absent from C665's compressed
torus paragraph.  At \((3,0,2)\), the torus-fixed subspace has two basis
coordinates of weights \(8\) and \(-8\).  In distinct output coordinates,
\(u(t)-1\) has coefficients \(t\) and \(t^3\), so root-group fixity kills
both coefficients.  Thus
\(\operatorname{Hom}_B(S,Y\otimes R)=0\) uniformly, including the
degenerate trivial head.  Every nontrivial head uses the advertised strict
torus-gap proof without this repair.

## Mandatory specializations

- \((p,s,e)=(11,6,2)\): \(R=L(3,1)\), \(T=L(9,1)\), unique row 34,
  trace scalar \(3\), trace target dimension \(140\), spill target
  dimension \(24\).
- \((p,s,e)=(13,6,2)\): \(R=L(5,1)\), \(T=L(11,1)\), trace scalar \(5\),
  not \(s/2=3\), with target dimensions \(168\) and \(36\).
- \(s=p-3\): \(R=L(1,1)\) and the spill target has its minimum dimension
  \(12\).  The certificate contains both a packet-\(2\) example
  \((5,2,2)\) and a packet-\(0\) example \((7,4,3)\).
- Both \(s\bmod4\) packets occur in the canonical suite, together with an
  absent packet example.

The checker reads the committed q=121 and q=169 certificates as independent
large-module invariants.  It matches q=121's unique nonzero connecting row,
\((R,T)=((3,1),(9,1))\), and scalar \(3\).  It matches q=169's
\((R,T)=((5,1),(11,1))\), scalar \(5\), nonzero spill supports, and zero
torus-fixed cochains.  The historical q=169 checker remains committed but
is no longer the canonical replay.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-29-c688-generic-first-wall.py --check
python3 notes/2026-07-29-c688-generic-first-wall-independent.py --check
sha256sum -c notes/2026-07-29-c688-generic-first-wall.sha256
```

An arbitrary admissible case can be evaluated without constructing
\(\mathbb F_{p^e}\):

```text
python3 notes/2026-07-29-c688-generic-first-wall.py --case 19 6 2
```

The implementation uses only the Python 3 standard library and is
deterministic.  Its canonical JSON has sorted keys, contains no timestamp
or host path, and records hashes rather than dense matrices.
As a non-load-bearing closeout stress test, `--case` also passed all 148
admissible triples with \(p\le31\), \(e\in\{2,3\}\), and even
\(0\le s<p-1\).  The uniform conclusion rests on the formulas, not this
finite sweep.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c688-generic-first-wall.py` | 12743 | `3a8061ccea65733eec77bdca2ab55b74df388ef9b4ae05afdcbae9c80c816d23` |
| `notes/2026-07-29-c688-generic-first-wall-independent.py` | 3850 | `01fc26915f45105744209d6f4135290af5e65fe34a7c5caf2b2c9c9577153052` |
| `notes/2026-07-29-c688-generic-first-wall.json` | 20546 | `21f703a224c0c3b1cdcba87f3718412306980601434482215eeaf744515cc372` |

The independent replay regenerates the Clebsch--Gordan maps from the
closed binomial formula rather than the recurrence, reevaluates occurrence,
trace, spill, dimensions, and the degenerate root-group seam, and checks
the committed certificate.  The q=121 and q=169 field-sized calculations
are a second, structurally different cross-check.

## Evidence boundary

The certificate proves exact identities about the supplied normalized
local row.  It is not a finite prime sweep and does not prove the human
Lucas-socle or adjacent-wall theorems.  It also does not decide which PGL
outer extension an exceptional subgroup supplies.  These are deliberately
separate inputs, exactly as required by C688.

## Extra juice and Tao closeout

The reusable residue is the small `--case P S E` interface: future even
restricted heads receive occurrence, normalized map hashes, trace and
spill data, torus separation, and dimensions without any extension-field
construction.  The q=169 replay has become historical corroboration rather
than a load-bearing field-sized gate.

The closeout also exposes the exact Toeplitz formula (T).  It removes even
the apparent variation among Clebsch--Gordan columns: the entire zeroth
digit map is one nonvanishing binomial band, shifted \(s+1\) times.  This
is cheap reusable structure for any later first-wall head and explains the
certificate's unexpectedly rigid sparsity.

The boundary audit found and closed the only small-parameter wrinkle:
integer interval separation alone does not survive reduction modulo
\(q-1\) at \((3,0,2)\).  The two-coordinate root-group calculation repairs
that seam exactly.  It does not affect any exceptional subgroup head in
C665, all of which have \(s\ge6\).

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| scalar \(3\) at q=121 | settled as \(r=p-2-s\) | none |
| scalar \(5\) at q=169 | settled; distinguishes \(r\) from \(s/2\) | none |
| unique spill row | settled by local middle-factor support | none |
| field-sized replay | settled away by the \(S,T,R,Y\) interface | none |
| extremal \(s=p-3\) | settled with \(R=L(1,1)\) and spill dimension \(12\) | none |
| constant Clebsch--Gordan column sparsity | settled by the Toeplitz band (T), with exactly \((s+1)(r+1)\) entries | none |
| \((3,0,2)\) torus wrap | settled by the two root-group coefficients | none |
| occurrence versus spill versus outer parity | kept as three separate logical gates | none |

No genuine C688 mystery remains.  The conceptual radial-nonvanishing
question belongs to C689 and is not part of this replay-compression task.

Vibe check: the large q=169 replay was carrying no essential field-sized
information; the surviving witness is a compact first-wall identity, with
one small degenerate seam now made explicit rather than hidden.
