# C688 — generic local first-wall checker

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** queued as the replay-compression successor to completed C665;
Paper II v2 only.

## Objective

Replace the q=169 field-sized adapted-dual-Weyl checker by a generic local
checker for every odd prime \(p\) and even restricted head \(s\) with
\(p>s+1\).  The checker must construct only the first-wall data
\[
S=L(s),\quad T=L(p-2,1),\quad
R=L(p-2-s,1),\quad Y=L(0,2),
\]
not \(W=\operatorname{Sym}^{(p^2-3)/2}V\), its symmetric square, or any
module whose size grows with \(q=p^e\).

## Acceptance gate

The canonical replay must:

1. derive the two even-head occurrence packets from
   \(e(p-1)/2\equiv1+s/2\pmod2\);
2. construct normalized local Clebsch--Gordan and first-wall maps;
3. compute the trace coefficient \(p-2-s\) exactly and prove it nonzero;
4. prove that the same unique row spills into \(Y\otimes R\);
5. certify that
   \(\operatorname{Hom}_B(S,Y\otimes R)=0\);
6. report the exact target dimensions
   \(2(s+1)(p-1)\) and \(6(p-1-s)\);
7. specialize identically to the committed q=121 and q=169 certificates;
   and
8. ship a deterministic `--check` bundle with pinned inputs, compact
   output, and an independent formula-level or second-implementation
   replay.

The q=169 checker remains historical corroboration until the generic
replacement passes.  Do not delete it, weaken C665's human proof, edit
Paper II v1, or turn a bounded prime sweep into the uniform claim.

## Source theorem

`notes/2026-07-29-c665-frobenius-digit-spill.md`.

The replacement is evidence compression and conceptual exposition, not a
new premise for the already-closed C665 theorem.

## Tao and extra-juice design pass

The checker must keep three logically different statements separate:

- the human Lucas-socle theorem decides whether the head occurs;
- the local checker verifies the first-wall trace and spill conditional on
  that occurrence; and
- the exceptional-subgroup calculation decides whether the required PGL
  outer parity is present.

A prime sweep cannot replace any of these.  The generic implementation
should work from divided-power/Clebsch--Gordan formulas over
\(\mathbb F_p\), taking \((p,s)\) as inputs.  It need not construct
\(\mathbb F_{p^2}\): the extension exponent enters only through the
occurrence parity bit.

The compact certificate should contain only:

1. \(r=p-2-s\), the two occurrence packets, and the assertion
   \(1\le r<p\);
2. hashes of the normalized local maps;
3. the trace coordinate \(r\);
4. one nonzero spill coordinate and the proof that its row is unique;
5. the two strict torus-weight intervals excluding a fixed cochain; and
6. the two target dimensions.

Mandatory seams are:

- \((p,s)=(11,6)\), recovering row 34 and scalar \(3\);
- \((p,s)=(13,6)\), recovering the separating scalar \(5\), not \(s/2\);
- the extremal family \(s=p-3\), where \(R=L(1,1)\) and the spill target
  has its minimum dimension \(12\); and
- both \(s\bmod4\) occurrence packets.

The independent replay should evaluate the closed formulas or use a
second divided-power recurrence, not repeat the same sparse matrices.
Sparse work may have quadratic entry count, but no constructed module
dimension may grow with \(q\) or \(e\).

The extra reusable value is a small first-wall checker interface for
future even restricted heads.  Extract that interface only if it falls
out naturally; do not expand C688 into a general modular-plethysm library.
