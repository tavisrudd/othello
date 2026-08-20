# Module 36. Unipotent point-line uniqueness no-go

**Packet part:** Module 36.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** commuting-unipotent no-go proved; filtered/semisimple selector
remains open

## 36.1 One unipotent operation is never enough

The uniqueness criterion in Module 35 asks for an operation whose upstairs
fixed space is exactly the Gamma point line.  Large-radius line-bundle
monodromy cannot have this property when the exceptional sector is nonzero.

### Proposition 36.1 -- exceptional fixed vector

Let \(E\ne0\) be finite-dimensional and let \(U:E\to E\) be unipotent.
Then

\[
\ker(U-1)\ne0.
\tag{36.1}
\]

#### Proof

The nilpotent operator \(U-1\) on a nonzero finite-dimensional space has
nonzero kernel.  \(\square\)

Consequently, if a comparison intertwines

\[
U_{\widetilde Y}J_W=J_W(U_Y\oplus U_E)
\tag{36.2}
\]

and \(p_Y\ne0\) is fixed by \(U_Y\), then

\[
\dim\ker(U_{\widetilde Y}-1)
\ge2
\tag{36.3}
\]

whenever \(E_W\ne0\): one fixed line comes from \(p_Y\), and another comes
from (36.1) in \(E_W\).  Thus the one-dimensional criterion of Section 35.5
cannot be instantiated by that monodromy.

## 36.2 Parallel Picard monodromies do not repair uniqueness

Adding more commuting line-bundle operations still does not isolate the
ambient point line.

### Theorem 36.2 -- common fixed vector for commuting unipotents

Let \(U_1,\ldots,U_r\) be commuting unipotent operators on a nonzero
finite-dimensional space \(E\).  Then

\[
\bigcap_{i=1}^r\ker(U_i-1)\ne0.
\tag{36.4}
\]

#### Proof

Put \(N_i=U_i-1\).  The \(N_i\) are commuting nilpotents.  Start with
\(E_0=E\).  Inductively let

\[
E_i=E_{i-1}\cap\ker N_i.
\]

Because the operators commute, \(E_{i-1}\) is \(N_i\)-stable.  The
restriction of \(N_i\) to the nonzero space \(E_{i-1}\) is nilpotent, hence
has nonzero kernel.  Thus every \(E_i\ne0\), and \(E_r\) is the intersection
in (36.4).  \(\square\)

### Corollary 36.2A -- no commuting-unipotent Reader selector

Suppose a finite family of line-bundle monodromies is transported
componentwise through (35.4), fixes the ambient point line, and acts
unipotently on a nonzero exceptional dual sector.  Its simultaneous fixed
space upstairs contains both the ambient point line and a nonzero
exceptional line.  Therefore the family cannot prove (35.8) by
simultaneous-fixed-line uniqueness.

This applies equally to one line bundle, several independent Picard
directions, or a Reader environment retaining the whole finite commuting
Picard action.  The failure is algebraic, not a shortage of marked paths.

Pointwise on one finite-dimensional \(E\), the same conclusion holds for an
arbitrary commuting family: the descending intersections of kernels
stabilize after finitely many members.  This does not by itself produce a
fixed subbundle or section in a varying geometric family.

## 36.3 Formal character does not separate the fixed lines

Assume the primitive projector commutes with every Picard operation, so the
exceptional \(\chi^{-1}\)-sector is invariant under their restrictions.
Restricting to that character does not repair this specific defect when the
exceptional sector is nonzero and has the same character.  Semisimple formal
monodromy acts there by the same scalar, while the commuting line-bundle
parts remain unipotent.  The exceptional common fixed vector from Theorem
36.2 therefore survives inside that character sector.  If the full formal
monodromy, including its unipotent part, is added to the commuting selector
algebra, that part must also commute and be included in the common-kernel
argument.

The character projector is still necessary to remove unrelated sectors; it
is simply insufficient to choose the ambient point line among same-character
ambient and exceptional blocks.

## 36.4 What kind of selector could work

Theorem 36.2 rules out fixed-line/eigencharacter uniqueness using only the
commuting unipotent Picard algebra: every polynomial selector normalized to
fix the ambient common line also fixes the exceptional common line.  It does
not rule out filtrations or quotients built from kernels and images of those
same nilpotents.  Viable sufficient abstract shapes include:

1. an Orlov-component idempotent whose distinguished character is present
   on the ambient point line and absent on \(E_W\);
2. a strict Stokes/Rees filtration in which the retained ambient graded
   piece is one-dimensional and every exceptional fixed vector occupies a
   different graded position;
3. a **corrected intrinsic** support/generic-point operation whose
   exceptional realization is zero, not the ordinary Gamma/residual Gysin
   ruled out by Module 33;
4. a semisimple operation with an ambient character absent on the
   exceptional sector and a one-dimensional retained ambient eigenspace; or
5. a noncommuting operation whose joint representation has a unique
   ambient invariant line.

Each option needs an independently constructed operation-framed comparison.
Declaring the ambient/exceptional splitting itself as the selector would be
circular.

## 36.5 Consequence for the provider search

Module 35 remains useful: it reduces row transport to a point-line equation.
Module 36 closes only the cheapest proposed proof of that equation.

A sufficient local provider shape is now:

\[
\boxed{
\text{pairing-compatible point line}
+
\text{one selector or filtration quotient separating all exceptional fixed lines}.
}
\tag{36.5}
\]

This is smaller than a full Stokes/Gamma/Orlov equivalence, but strictly
larger than the QDM source plus commuting line-bundle monodromy.

## 36.6 Executable calibration

The shared replay enumerates commuting nilpotent shift operators on bounded
tensor products of Jordan strings and checks that their common kernel is
nonzero.  It is a finite witness for Theorem 36.2, whose proof is the
invariant-kernel induction above.

## 36.7 EJ/TT and mystery ledger

**EJ.** The no-go prevents an unproductive search over larger Picard
markings: every finite commuting unipotent enlargement retains an
exceptional fixed line.

**TT.** A fixed-line/eigencharacter selector must change representation
type, not merely add more operators of the same unipotent kind.  A
filtration-quotient consumer is the distinct admitted alternative.

| question | status | exact evidence or gate |
|---|---|---|
| Can one line-bundle monodromy uniquely select the point line? | **no if the exceptional sector is nonzero** | Proposition 36.1 |
| Can finitely many commuting Picard directions do so? | **no** | Theorem 36.2 |
| Does the primitive character alone remove same-character fixed lines? | **no** | Section 36.3 |
| What sufficient extra structure could work? | **open** | one independently realized selector or filtration quotient from (36.5) |

## Boundary

The commuting-unipotent uniqueness route is closed negatively.  The theorem
does not rule out a Stokes-filtered, semisimple-character, support-local, or
noncommuting selector, and it does not prove the point-line transport law.
No unconditional \(m=2\) or all-\(m\) theorem follows.
