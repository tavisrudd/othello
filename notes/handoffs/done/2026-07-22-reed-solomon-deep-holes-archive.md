# Reed--Solomon deep-hole programme — companion archive (append-only)

Companion to [`../2026-07-22-reed-solomon-deep-holes.md`](../2026-07-22-reed-solomon-deep-holes.md).
Dated session notes and superseded execution material live here; the live handoff retains only the
current context map and frontier.

## 2026-07-22 — Lane creation

The lane was split from the completed C398/C474 Reed--Solomon bridge. C475 was reserved for the
first standard-GRS task: prove the descent of a bounded determinant/coefficient atlas, test exact
orbit separation in the smallest normalized cases, and stop at the first collision to determine
its complete fibre. No C475 mathematical result is claimed at lane creation.

## 2026-07-22 — Cross-paper extraction

The papers index and adjacent theorem banks sharpened the first move. On a Veronese conic the edge
determinant factors into the support bracket and one syndrome bilinear form. Monomial-rescaling
invariance then forces balanced edge ratios, with support-normalized four-cycles as the first atlas.
The live handoff records the exact formula, import order, and stop gate; heavier cocycle, modular,
and higher-order-MDS machinery remains conditional on a genuine atlas collision.

## 2026-07-22 — Gated theorem ladder

C476--C478 were reserved as three bounded successors: a five-field six-support pilot, a
collision-only fibre theorem, and fixed exceptional-family controls. Generic all-field,
semilinear-tower, higher-order-MDS, and modular/category extensions remain unallocated behind
explicit gates.

## 2026-07-22 — C499 sporadic pencil structure (closed)

C499 gave the intrinsic structure of every C491 sporadic deep-hole orbit at q in {7,8,9,11,13,17,19}
from the frozen census representatives (no regeneration). One invariant — the Frobenius orbit type of
the degree-3-cover branch divisor Delta(lambda), refined by j-invariant — sorts all sporadics into
five normal forms. The stab-12 orbits (q=7,13,19) are exactly the equianharmonic (j=0, I(Delta)=0)
pencils with stabilizer A4 (order fingerprint {1:1,2:3,3:8}); the "4 double + 4 irreducible" profile
is each a single stabilizer-orbit on the pencil line. The three q=8 size-252 orbits are one free
Gal(F_8/F_2)=C3 torsor on the a4 cubic-twist label (Frobenius orbit {t,t^2,t^4}), a structural
parallel to C484's colour C3=(0 4 1)(2 5 3) (same Galois group, free/lossy, not Gale/Hilbert-90).
Verdict: uniform structure but sporadicity is a bounded-q accident — the equianharmonic orbit
persists for every q=1 mod 3 (constructed at q=25,31,37,43,49) yet is deep only at q in {7,13,19};
elsewhere it carries totally-split members. Report and evidence bundle:
`../../2026-07-22-c499-sporadic-pencil-structure.md` (+ `.py`, `.json`, `.sha256`). Both C491
discovery-track leads settled.

## 2026-07-23 — C514 modular TRS translation quotient (closed)

C514 turns the modular full-length last-hook translation symmetry into an exact determinant
quotient.  Each support's canonical completion root gives the slice `U=T-r`, `sum(U)=1`;
the Lucas-maximal fixed flag survives projection with no connecting correction.  The hoped-for
C512 recursion fails for two proved reasons: generic annihilator lines are not consecutive-row
polar lines, and valid completion/support collisions lie on C512's forbidden marker divisor.
The report refreshes all three pinned citation graphs and makes no field census or deep-hole
classification claim.

Two subsequent extra-juice rounds add the exact difference identity
`Delta_b F_y=F_{(A_-b-1)y}`, prove that every support translation stabilizer is trivial, and
identify the valid completion-collision boundary as `X^2 Q_V` over the trace-one configuration
space in `G_m`.  These are C515's operator and boundary inputs; root existence and additive trace
classes remain its theorem gate.

## 2026-07-23 — C515 modular TRS Hasse recursion (closed)

C515 derives the complete Hasse/augmentation filtration of the C514 incidence polynomial and the
exact adjoint-kernel trace test at linearized endpoints.  It proves the decisive obstruction:
finite-difference zeros express equality of determinant values and do not lift support zeros,
with the standard fixed syndrome as the terminal counterexample.  The polar-compatible locus is
a ruled surface of dimension at most two, containing the standard direction but excluding every
pure extra Lucas-maximal direction; fixed endpoints become elementary-symmetric tests on
trace-one configurations.  The next possible theorem shape is global geometry of the full
incidence hypersurface, not another local recursion.

A requested Tao audit corrects a potential conflation of Lucas Hasse index with augmentation
depth and adds the multiplicative transfer
`N_y(U)=Res(R^q-R,F_y(R,U))`.  This orbit norm exactly preserves zero incidence while eliminating
the translation coordinate.  At a linearized endpoint it is, up to sign, the kernel-size power
of the image linearized polynomial evaluated at `-c`, making the adjoint-trace obstruction its
exact factor.
