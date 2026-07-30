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

There is a second compression inside (T).  Its seed polynomial is
\[
 C_r(z)=(1-z)^r=C_1(z)^{\,r}.                 \tag{G}
\]
Thus every generic first-wall seed is the \(r\)-fold convolution power of
the primitive two-term difference seed \((1,-1)\).  More importantly, the
two apparent wall calculations are consecutive coordinates of this one
polynomial:
\[
 [z^0]C_r=1\quad\text{is the normalized spill coordinate},\qquad
 -[z^1]C_r=r\quad\text{is the trace coordinate}.           \tag{H}
\]
The checker now certifies (G)--(H) independently.  This explains why the
same unique row both has nonzero trace and spills: they are not unrelated
matrix phenomena but the constant and linear coefficients of one bracket
power.

There is an important evidence seam.  The human adjacent-wall theorem
identifies its normalized row with this bracket-power coordinate system;
the checker does not independently derive that representation-theoretic
identification.  What it certifies independently is the exact polynomial
calculus after that identification:
\[
 C_r'(z)=-r(1-z)^{r-1},
\]
together with the constant and linear coordinates in (H).  Thus (G)--(H)
compress and explain the normalized human row, but cannot serve as a
standalone proof that the adjacent-wall differential is that row.

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
torus paragraph.  At \((3,0,2)\), the checker now enumerates all twelve
basis vectors of \(Y\otimes R\), finds exactly two torus-fixed coordinates
of weights \(8\) and \(-8\), and expands their root-group actions.  In
distinct output monomials, \(u(t)-1\) has coefficients \(t\) and \(t^3\);
the resulting \(2\times2\) coefficient matrix is the identity, so
root-group fixity kills both coefficients.  Thus
\(\operatorname{Hom}_B(S,Y\otimes R)=0\) uniformly, including the
degenerate trivial head.  This triple's occurrence bit is false, so the
repair is not load-bearing for C665's pullback theorem; it closes only the
broader uniform Borel statement.  Every nontrivial head uses the advertised
strict torus-gap proof without this repair.

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
| `notes/2026-07-29-c688-generic-first-wall.py` | 15771 | `1743ff995dd9ef21d6869a79a22db5dc160e35d71cf05485b58d9bf54f21fbcd` |
| `notes/2026-07-29-c688-generic-first-wall-independent.py` | 5925 | `b34c6915b963dc8d8d1eeb0089f05d0721e6446faecc9dc6123a1171765ce5eb` |
| `notes/2026-07-29-c688-generic-first-wall.json` | 25444 | `082f0d329ca9cc6b4db1c4879e74f8fc9759b9796a5115ce9d4f4674a62acc84` |

The independent replay regenerates the Clebsch--Gordan maps from the
closed binomial formula rather than the recurrence, reevaluates occurrence,
trace, spill, dimensions, and the degenerate root-group seam, and checks
the committed certificate.  For q=9 it independently enumerates the
torus-fixed basis and separating root-action coefficients rather than
accepting a hard-coded matrix.  The q=121 and q=169 field-sized
calculations are a second, structurally different cross-check.

## Evidence boundary

The certificate proves exact identities about the supplied normalized
local row.  It is not a finite prime sweep and does not prove the human
Lucas-socle or adjacent-wall theorems.  It also does not decide which PGL
outer extension an exceptional subgroup supplies.  These are deliberately
separate inputs, exactly as required by C688.

The generating-polynomial proposal for C689 is likewise heuristic until
one constructs a type-independent radial polynomial and proves that its
specializations are the existing \(B_3\) and \(H_3\) witnesses.

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

At second order, (G)--(H) show that \(r=1\) is universal: every other local
wall seed is its convolution power, while spill and trace are its first
two coefficient functionals.  This suggests a disciplined C689 attack:
seek one radial generating polynomial for the \(B_3\) and \(H_3\)
configurations whose first surviving coefficient specializes to both
finite witnesses.  That is a method proposal only; no C689
radial-nonvanishing claim is imported into C688.

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
| trace and spill appearing as separate phenomena | settled by (H): they are the linear and constant coordinates of \(C_r(z)\) | none |
| variation with \(r\) | settled by (G): every seed is the \(r\)-fold convolution power of \((1,-1)\) | none |
| adjacent-wall/bracket identification | retained explicitly as the human theorem input; polynomial consequences are independently checked | no C688 gap; a standalone derivation would be a different proof task |
| \((3,0,2)\) torus wrap | settled by a full 12-basis local root-action enumeration; occurrence is false there | none |
| occurrence versus spill versus outer parity | kept as three separate logical gates | none |

No genuine C688 mystery remains.  The conceptual radial-nonvanishing
question belongs to C689 and is not part of this replay-compression task.

Vibe check: the large q=169 replay was carrying no essential field-sized
information; the surviving witness is a compact first-wall identity, with
one small degenerate seam now made explicit rather than hidden.
