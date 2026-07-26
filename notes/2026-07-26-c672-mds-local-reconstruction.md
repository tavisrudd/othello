# C672 MDS local reconstruction

**Lane:** `complete-ports`

**Status:** COMPLETE — the coefficient-port object, intrinsic reconstruction
radius, support/coefficients bridge, code-duality recovery, pointed-port
isomorphism invariance, prescribed-support MDS relation lemma, generic support
clutter, minimum-radius spanning theorem, and exact radius theorem are proved in
Lean and pass the paper-facing import/axiom gate.

## Statement

Let \(C\leq \mathbf F^E\) be an \([n,k]\) MDS code with \(k>0\), let
\(x\in E\), and normalize every dual repair word \(y\in C^\perp\) by
\(y_x=1\).  The radius-\(r\) coefficient port is
\[
 \mathcal P_x^{\leq r}(C)=
 \{y\in C^\perp:y_x=1,\ |\operatorname{supp}(y)\setminus\{x\}|\leq r\}.
\]
It reconstructs at radius \(r\) when its linear span is \(C^\perp\); the
reconstruction radius is the least such \(r\), or infinity when none exists.

Using the standard dual characterization of an MDS code,
\[
 \dim C^\perp=n-k,\qquad d(C^\perp)=k+1,
\]
the theorem is
\[
 \operatorname{span}\mathcal P_x^{\leq k}(C)=C^\perp,\qquad
 \rho_x(C)=k.
\]
The support projection is the complete \(k\)-uniform clutter on
\(E\setminus\{x\}\).  Thus the support layer depends only on \((n,k)\), while
the normalized coefficient words retain the represented code.

## Human proof

First take any \(T\subseteq E\) with \(|T|=k+1\).  Restrict \(C^\perp\) to
\(E\setminus T\).  The domain has dimension \(n-k\), while the codomain has
dimension \(n-k-1\), so the restriction has a nonzero kernel vector \(y\).
It is supported on \(T\).  Since every nonzero dual word has weight at least
\(k+1\), its support is exactly \(T\).  If \(x\in T\), then \(y_x\neq0\), so
there is a target-normalized word on \(T\).

This proves that every \(k\)-subset of the helper coordinates is a minimum
repair support.  Conversely, a normalized repair using at most \(k\) helpers
has total weight at most \(k+1\); the dual-distance bound forces equality.
Hence the support-only port is precisely the complete \(k\)-uniform clutter.

It remains to show that the normalized minimum words span.  Choose
\(Q\subseteq E\setminus\{x\}\) with \(|Q|=k-1\), and put
\[
 U=E\setminus(\{x\}\cup Q).
\]
Then \(|U|=n-k=\dim C^\perp\).  For each \(t\in U\), choose the normalized
minimum dual word \(y_t\) with support
\(\{x,t\}\cup Q\).  At coordinate \(t\), the word \(y_t\) is nonzero, whereas
every \(y_s\) with \(s\neq t\) vanishes.  Evaluating a linear relation among
the \(y_t\) at each \(t\) proves that they are linearly independent.  Their
number is \(\dim C^\perp\), so they form a basis.  All belong to the
radius-\(k\) coefficient port.

No smaller radius contains a normalized word: such a word would have weight
at most \(k\), contradicting \(d(C^\perp)=k+1\).  Therefore the reconstruction
radius is exactly \(k\).

## Formal correspondence

The current modules are:

- `FiniteGeom.CodeDuality`, proving that the standard coordinate pairing is
  nondegenerate, \(C^{\perp\perp}=C\), and the dual-code operation is injective;
- `RepairPorts.CoefficientPort`, defining `coefficientPort`,
  `coefficientPortSpan`, `ReconstructsAt`, `reconstructionRadius`, and
  `PointedCoefficientPortIso`, and proving that reconstruction recovers the
  original code and is invariant under intrinsic pointed-port isomorphism;
- `RepairPorts.MDSReconstruction`, defining the exact dual-parameter MDS
  interface and proving prescribed minimum relations, the generic support
  clutter, reconstruction at radius \(k\), and exact reconstruction radius; and
- `RepairPorts.Gates.CompletePorts`, the import-only paper-facing axiom gate.

The Lean hypothesis `HasMDSDualParameters C k` records the standard equivalent
dual description of an \([n,k]\) MDS code.  It avoids treating the term “MDS”
as an opaque label: the proof consumes exactly nontriviality, dual dimension
\(n-k\), and dual distance at least \(k+1\).

## Validation

The missing `RepairPorts` Lake library root was added; the touched build
manifest's private reverse references were removed.  The guarded and serialized
builds passed:

```text
lean-build-queue.py run FiniteGeom.CodeDuality \
  RepairPorts.CoefficientPort RepairPorts.MDSReconstruction
lean-build-queue.py run RepairPorts.Gates.CompletePorts
lean-build-queue.py run RepairPorts.Gates.CompletePorts
```

The last run was an exact-current no-build confirmation followed by the
trace-only aggregate gate.  Every paper-facing declaration reports exactly
`propext`, `Classical.choice`, and `Quot.sound`; there is no imported
mathematical axiom, native execution, generated record, or certificate in the
closure.

## Closeout: extra value and expert-pressure pass

The spanning proof gives a sharper mechanism than an anonymous dimension
count.  Fixing one target and a common \((k-1)\)-helper core \(Q\), the
\(n-k\) minimum relations obtained by adding one distinct outside helper have
private pivot coordinates.  They form a basis of \(C^\perp\).  Thus a small
star inside the complete coefficient port already contains the code's whole
local memory.

Two free general upgrades also closed.  First, at any coordinate used by some
dual word, the full normalized coefficient fiber spans the entire dual code, so
the reconstruction radius is finite without an MDS hypothesis.  Second,
nondegeneracy of the coordinate pairing proves that spanning the dual really
reconstructs the original code rather than merely a chosen parity-check
presentation.

## Mystery ledger

| Mystery | Closeout verdict | Evidence or successor |
|---|---|---|
| Does the minimum MDS coefficient port genuinely reconstruct the code, or only its support matroid? | Settled: the common-core star is a basis of \(C^\perp\), and double duality recovers \(C\) | `HasMDSDualParameters.reconstructsAt`, `FiniteGeom.dualCode_dualCode` |
| Is reconstruction radius intrinsic under the correct pointed equivalence? | Settled: an ambient linear equivalence carrying every normalized bounded fiber and the full dual space preserves reconstruction at every radius and preserves the infimum | `PointedCoefficientPortIso.reconstructsAt_iff`, `.reconstructionRadius_eq` |
| Why is the support-only port generic? | Settled: restriction dimension supplies a word on every prescribed \(k+1\)-set and dual distance forces exact support | `.repairHypergraph_eq_powersetCard` |
| Is the hypothesis \(k>0\) cosmetic? | No.  At \(k=0\), one target's radius-zero relation need not span a multi-coordinate full dual space.  The positive-dimension hypothesis is the sharp paper boundary | exact theorem hypothesis and the basis construction |
| Does the standard primal `IsMDS` name need to enter the paper-facing theorem? | Settled editorially: the paper states the equivalent dual-parameter characterization explicitly, which is exactly the Lean structure consumed by the proof | statement-adequacy row; no opaque `MDS` label |

No genuine C672 mystery remains.  No incidental discovery outside the planned
reconstruction problem was found.
