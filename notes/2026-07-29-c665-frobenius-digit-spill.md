# C665: uniform Frobenius-digit spill criterion

**Lane**: `clebsch`

**Date**: 2026-07-29

## Verdict

The \(q=121\) two-component obstruction is the first instance of a
uniform first-wall phenomenon.  It closes C1 for every remaining
extension-field exceptional head.

Put
\[
 q=p^e,\qquad e>1,\qquad d=(q-3)/2,
\]
and write
\[
 a=(p-3)/2,\qquad b=(p-1)/2.
\]
For an even restricted head \(S=L(s)\), with all higher Frobenius digits
zero and \(p>s+1\), the affine socle criterion is
\[
 \operatorname{Hom}_H(S,\operatorname{Sym}^dL(2))\ne0
 \quad\Longleftrightarrow\quad
 eb\equiv1+s/2\pmod2.                         \tag{D}
\]
When it is nonzero, it is one-dimensional.  If the required PGL outer
parity occurs, the quadratic pullback along this occurrence is nonsplit.
If the outer parity is the other one, the exceptional head does not embed
and C1 is vacuous.

Consequently the large-characteristic exceptional rows have the following
complete disposition.

| head | affine-socle occurrence | C1 disposition |
|---|---|---|
| \(A_4:L(6)\) | every \(e\) if \(p\equiv1\pmod4\); even \(e\) if \(p\equiv3\pmod4\) | uniform spill when the outer parity matches; otherwise absent |
| \(S_4:L(8)\) | odd \(e\) and \(p\equiv3\pmod4\) | uniform spill when the outer parity matches; otherwise absent |
| \(A_5:L(12)\) | odd \(e\) and \(p\equiv3\pmod4\) | uniform spill when the outer parity matches; otherwise absent |

All complementary rows have zero affine Hom.  The small-characteristic
digit heads are also absent uniformly: an odd target digit cannot occur in
the square-socle recurrence, and the sole all-even exception,
\(p=5,\ S_4:L(2)\otimes L(2)^{(1)}\), has the sign word
`sym,alt,sym,...`, hence lies in the alternating rather than the symmetric
square.  This includes and explains the earlier \(q=25,49\) zero-Hom
calculations.

There is a useful dichotomy hidden in the table.  Since the right side of
(D) is even for \(s=6\) and odd for \(s=8,12\), the \(A_4\) occurrence and
the \(S_4/A_5\) occurrences are complementary:
\[
 \operatorname{Hom}_H(L(6),F)\ne0
 \quad\Longleftrightarrow\quad
 \operatorname{Hom}_H(L(8),F)
 =\operatorname{Hom}_H(L(12),F)=0
                                                        \tag{E}
\]
whenever the displayed large-characteristic heads are available, with the
reverse pattern for the other parity bit.  Thus no extension field ever
requires simultaneous pullback calculations for the \(A_4\) head and an
\(S_4\) or \(A_5\) head.

More generally, (D) partitions every admissible even restricted head into
two packets:
\[
\begin{array}{c|c}
s\bmod4&\text{occurrence condition}\\ \hline
2&eb\equiv0\pmod2,\\
0&eb\equiv1\pmod2.
\end{array}                                      \tag{F}
\]
The spill proof therefore gives a reusable C1 lemma for any future
subgroup head \(L(s)\) in this range, not just \(s=6,8,12\).

Thus C665's uniform extension-field C1 gate is closed.  This is a Paper II
v2 result and does not alter or hold the frozen v1 release.

## Lucas-socle criterion

Modular Hermite reciprocity gives
\[
 F=\operatorname{Sym}^dL(2)\simeq
 \operatorname{Sym}^2W,\qquad W=\nabla(d).
\]
The distinguished digit in
\[
 d=a+bp+\cdots+bp^{e-1}
\]
is the zeroth one.  Solving the positive-root divided-power equations in
the torus block of a \(q\)-restricted simple gives the following
Lucas-socle rule.  At digit \(j\), a target digit \(c_j\) must have the
form
\[
 c_j=2n_j-2\delta_j-4r_j,\qquad r_j\ge0,       \tag{L}
\]
where \(n_0=a,\ n_j=b\) for \(j>0\), and
\(\delta_j=0,1\) selects respectively a symmetric- or alternating-square
Clebsch--Gordan factor.  The global vector lies in
\(\operatorname{Sym}^2W\), rather than \(\bigwedge^2W\), precisely when
\[
 \sum_j\delta_j\equiv0\pmod2.                 \tag{S}
\]

For completeness, this is an \(H\)-socle calculation, not an inference
from composition factors.  A root-group intertwining equation is a
polynomial in the translation parameter of degree at most \(q-3\).
Vanishing on \(\mathbb F_q\) therefore makes every coefficient vanish.
Lucas's theorem then separates those coefficient equations digit by
digit.  The one-digit kernels are the usual bottom-alcove symmetric and
alternating Clebsch--Gordan lines, giving (L); the tensor flip gives (S).
Conversely their Lucas products give the indicated embeddings.  Hence the
rule computes the finite-group Hom space itself.

For \(c=(s,0,\ldots,0)\), the signs are unique:
\[
 \delta_0\equiv a-s/2,\qquad
 \delta_j\equiv b\quad(j>0)\pmod2.
\]
Condition (S) becomes
\[
 a-s/2+(e-1)b
 \equiv eb-1-s/2\equiv0\pmod2,
\]
which is (D).  The same uniqueness proves that the nonzero Hom space is a
line.

## The uniform spill

Assume (D), and retain the unique sign word in all digits after the first
two.  The first modular-Hermite wall contains the three simple factors
\[
 T=L(p-2,1,0,\ldots,0),\qquad
 R=L(p-2-s,1,0,\ldots,0),\qquad
 Y=L(0,2,0,\ldots,0).                         \tag{W}
\]
Here \(T\) is the torus-normalized affine \(H^1\)-channel.  The Lucas
coefficient of the affine cocycle in this channel is \(1\); every other
cohomological channel is above a later wall.  Both \(T\) and \(R\) occur in
the middle tensor layer because their two displayed digits are odd
Clebsch--Gordan factors.  The factor \(Y\) occurs in the lower square
layer: its two local signs agree, so their contribution to (S) is even.

There is a unique degree-two connecting row
\[
 R\otimes T
\]
that can cancel the pullback in \(S\otimes T\).  Projecting the adjacent
dual-Weyl block to the indicated Lucas factors and taking the categorical
trace gives
\[
 \operatorname{tr}_S(d_1|_{R\otimes T})=p-2-s. \tag{C}
\]
This is nonzero because \(p>s+1\).  Formula (C) is the general version of
the scalar \(3\) in the \(q=121,\ s=6\) calculation.  More intrinsically,
it is the zeroth Frobenius digit of \(R\).  It cannot vanish in any
admissible row: \(p\) is odd and \(s\) is even, so
\(p-2-s\) is a positive odd integer strictly below \(p\).

The same row has a second component in
\[
 Y\otimes R.                                  \tag{P}
\]
Its coefficient is the same normalized first-wall coefficient and is
nonzero.  Lucas support makes this row unique: a middle factor crosses
the first wall into \(Y\) only when its two local digits are
\((p-2,1)\), namely \(T\).  Therefore no other degree-two correction can
cancel (P).

Finally (P) admits no torus-fixed cochain from \(S\).  Its weights are
\[
 p(2-2j)+(p-2-s-2k)+p(1-2\ell),
\]
where \(0\le j\le2\), \(0\le k\le p-2-s\), and \(0\le\ell\le1\).
When the coefficient of \(p\) is \(1\), the smallest weight is \(s+2\);
when it is \(-1\), the largest is \(-s-2\); the coefficients \(3,-3\)
are farther away.  Thus none is a weight of \(S\).  Their differences
have absolute value below \(p^2-1\), and hence below \(q-1\), so equality
cannot reappear modulo the split-torus order.

A putative Borel coboundary would therefore have to use the unique
\(R\otimes T\) coefficient forced nonzero by (C), while (P) forces that
same coefficient to vanish.  The coefficient and augmented ranks are
\(1\) and \(2\).  Since
\[
 [H:B]=q+1\equiv1\pmod p,
\]
restriction on \(H^1\) is injective.  The pullback is nonsplit over \(H\).

The certificate is uniformly small.  Its trace and spill targets have
dimensions
\[
\dim(S\otimes T)=2(s+1)(p-1),\qquad
\dim(Y\otimes R)=6(p-1-s),                     \tag{Z}
\]
respectively.  These are linear in \(p\) and independent of \(e\), even
though the original field-sized symmetric square grows with \(q=p^e\).

At \(p=11,s=6,e=2\), (W) is exactly
\[
 T=L(9,1),\quad R=L(3,1),\quad Y=L(0,2),
\]
so this specializes to row \(34\) and the committed q=121 witness.

## Reproducibility and evidence boundary

From the repository root:

```text
python3 notes/2026-07-29-c665-frobenius-digit-spill.py --check
sha256sum -c notes/2026-07-29-c665-frobenius-digit-spill.sha256
nix shell nixpkgs#sage -c sage -python \
  notes/2026-07-29-c665-q169-wall-check.sage --check
sha256sum -c notes/2026-07-29-c665-q169-wall-check.sha256
```

The checker audits all twelve parity classes for
\(s=6,8,12\), the local factor support, uniqueness of the adjacent block,
the torus-weight gap, and nonvanishing of \(p-2-s\) in representative
admissible characteristics.  It is a bookkeeping replay, not a finite
search standing in for the Lucas-socle or adjacent-wall proofs above.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c665-frobenius-digit-spill.py` | 5770 | `c3a86a05979f84a70da911c5f9c541299b28a45c91ce0f63fbf9a4d28bde4e97` |
| `notes/2026-07-29-c665-frobenius-digit-spill.json` | 6403 | `7f3f32d8a8aefe96c78afb3079730be6d8be69b04aa8c7bad3309a00f28efc4c` |
| `notes/2026-07-29-c665-q169-wall-check.sage` | 7491 | `b6d645f2ff67f19bd59220f57946f2e9c0bfac08212986a662dc218a3d356ee0` |
| `notes/2026-07-29-c665-q169-wall-check.json` | 702 | `3f2cb54900c15976968f6244157aa54dd61e7aa55976bde58a00d8a3e134ba62` |

The q=169 checksum manifest also pins all four imported q=121 support
scripts.  The checker mutates only their field parameters in memory and
does not read a prior certificate as evidence for its q=169 outputs.

The independent invariant check is the pre-existing full \(q=121\)
calculation: its two-component quotient ranks are \(1\to2\), with precisely
the specialization displayed above.  The earlier exact \(q=25,49\)
zero-Hom certificates independently check the two first small-prime
specializations.  The new \(q=169\) replay distinguishes the uniform
formula from the accidental q=121 equality: for \(p=13,s=6\), its trace
scalar is \(5=p-2-s\), not \(3=s/2\); both spill-generator supports are
nonzero, their block ranks are two, and the spill target again has no
torus-fixed cochain.  No field census is used in the uniform conclusion.

## Extra juice and Tao closeout

The useful upgrade is that the spill theorem also computes the entire
exceptional affine-socle occurrence table.  The previous decision tree no
longer needs a field-by-field Hom gate: one parity bit decides absence,
and every surviving bit is closed by the same first-wall obstruction.
The same bit partitions the exceptional types as in (E), so at most one
of the \(A_4\) route and the \(S_4/A_5\) route ever reaches the pullback
gate.
Equations (F) and (Z) are the broader residue: every even restricted head
belongs to one of two parity packets, and every surviving pullback has a
two-component certificate whose dimensions do not grow with the extension
degree.

The fragile seam is not a high-order contraction.  It is the incompatibility
between one required adjacent-wall coefficient and a lower component with
no torus weight.  This explains why every ordinary contraction could be
Borel-blind while the original pullback remained nonsplit.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| q=121 row-34 spill | settled uniformly as \(R\otimes T\to Y\otimes R\) | none |
| scalar \(3\) | settled as the specialization \(p-2-s\); q=169 separates it from \(s/2\) | none |
| exceptional affine-socle occurrences | settled by \(eb\equiv1+s/2\pmod2\) and the small-digit sign rule | none |
| apparent coexistence of exceptional heads | settled negatively: \(A_4\) and \(S_4/A_5\) occupy opposite values of the same parity bit | none |
| field-sized growth of the original pullback | settled away: the two witness targets have dimensions \(2(s+1)(p-1)\) and \(6(p-1-s)\), independent of \(e\) | none |
| higher Frobenius digits | settled: they contribute the unique tail sign word and cannot alter the first-wall torus gap | none |
| uniform extension-field C1 | settled | Paper II v2 integration only; v1 remains frozen |

Vibe check: the q=121 computation was not an isolated lucky matrix.  Its
two factors are the unavoidable first-wall pair, and the remaining
extension-field problem collapses to one Frobenius-parity bit.
