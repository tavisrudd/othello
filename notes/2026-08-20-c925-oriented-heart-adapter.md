# Module 26. The oriented-heart adapter

**Packet part:** Module 26.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** categorical theorem proved; QDM realization and carrier exponent
remain open

Module 25 isolated the opposite power-Bockstein

\[
\tau_m^{\mathrm{op}}:\ker N_A^m\longrightarrow E
\]

for an oriented short exact sequence

\[
0\longrightarrow E\longrightarrow B\longrightarrow A\longrightarrow0,
\qquad N_E^m=0.
\tag{26.1}
\]

The present module identifies a categorical law which kills this boundary
without adding another source augmentation.

## 26.1 Left-orthogonal exact interfaces

Let \(\mathcal H\) be an abelian category with a natural endomorphism

\[
N:\operatorname{Id}_{\mathcal H}\Rightarrow
\operatorname{Id}_{\mathcal H}.
\]

Let \(\mathcal A,\mathcal E\subseteq\mathcal H\) be full subcategories with

\[
\operatorname{Hom}_{\mathcal H}(A',E')=0
\quad
(A'\in\mathcal A,\ E'\in\mathcal E).
\tag{26.2}
\]

Call this a **left-orthogonal exact interface**.  The name records the
direction needed below; reversing (26.2) does not prove the same theorem.

### Theorem 26.1 -- orthogonality kills opposite leakage

Suppose (26.1) is exact in \(\mathcal H\), with

\[
A\in\mathcal A,
\qquad
E\in\mathcal E,
\qquad
N_E^m=0,
\qquad
\ker N_A^m\in\mathcal A.
\tag{26.3}
\]

Then

\[
\tau_m^{\mathrm{op}}=0
\tag{26.4}
\]

and the quotient map induces a canonical isomorphism

\[
\operatorname{Top}_m(B)
\xrightarrow{\sim}
\operatorname{Top}_m(A),
\qquad
\operatorname{Top}_m(V):=\operatorname{im}N_V^m.
\tag{26.5}
\]

#### Proof

The opposite snake boundary has source \(\ker N_A^m\), which lies in
\(\mathcal A\), and target

\[
\operatorname{coker}N_E^m=E,
\]

which lies in \(\mathcal E\).  Equation (26.2) therefore forces the boundary
to be zero.  The opposite-orientation form of Theorem 25.2 now gives (26.5).
\(\square\)

Only degree-zero Hom orthogonality is used.  No splitting, marking, Gamma
row, Stokes matrix, or full Jordan decomposition enters the proof.

### Corollary 26.1A -- relative exactness of the power image

Drop the hypothesis \(N_E^m=0\).  Instead suppose

\[
\ker N_A^m\in\mathcal A,
\qquad
\operatorname{coker}N_E^m\in\mathcal E.
\tag{26.6}
\]

Then the snake boundary still lies in a zero Hom-space, and

\[
0\longrightarrow\operatorname{Top}_m(E)
\longrightarrow\operatorname{Top}_m(B)
\longrightarrow\operatorname{Top}_m(A)
\longrightarrow0
\tag{26.7}
\]

is exact.

#### Proof

The boundary now has target \(\operatorname{coker}N_E^m\), which belongs to
\(\mathcal E\), so (26.2) kills it.  The power-image exact sequence from the
snake diagram gives (26.7).  \(\square\)

Thus \(\operatorname{Top}_m\) is exact on this oriented orthogonal class of
extensions.  Theorem 26.1 is the specialization in which its exceptional
value is zero.

### Corollary 26.1B -- ordered exceptional filtration

Suppose an ordered tower has exact steps

\[
0\to E_i\to B_i\to B_{i-1}\to0
\qquad(1\le i\le r),
\tag{26.8}
\]

with \(N_{E_i}^m=0\) and

\[
\operatorname{Hom}_{\mathcal H}
  (\ker N_{B_{i-1}}^m,E_i)=0
\tag{26.9}
\]

at every step.  Then

\[
\operatorname{Top}_m(B_r)
\cong\operatorname{Top}_m(B_0).
\tag{26.10}
\]

#### Proof

Apply the local snake-boundary argument at each step and compose the
canonical quotient-induced isomorphisms.  \(\square\)

This is the exact compositional law needed for several ordered exceptional
components.  It does not require them to form a biproduct.

## 26.2 SOD calibration and glued-heart adapter

Let a stable category have a semiorthogonal pair

\[
\mathcal D=\langle\mathcal E,\mathcal A\rangle,
\qquad
\operatorname{Hom}_{\mathcal D}(A,E[k])=0
\quad(k\in\mathbf Z).
\tag{26.11}
\]

Suppose a heart \(\mathcal H\subseteq\mathcal D\), the operation \(N\), and
an actual comparison sequence satisfy all of the following:

1. (26.1) is short exact in \(\mathcal H\);
2. \(A\in\mathcal A\cap\mathcal H\) and
   \(E\in\mathcal E\cap\mathcal H\);
3. \(\ker N_A^m\in\mathcal A\cap\mathcal H\); and
4. \(N_E^m=0\).

Then (26.11) implies (26.2), hence Theorem 26.1 applies.

This corollary has an important boundary.  The standard Orlov decomposition

\[
\langle\text{exceptional},\text{ambient}\rangle
\]

provides ambient-to-exceptional orthogonality, but it does **not** by itself
construct the opposite exact sequence (26.1) in an analytic QDM heart.  Its
usual projection triangle may have the other orientation.  Mutation, a
recollement heart, or a direct analytic construction must supply the exact
orientation, and must preserve the same operation \(N\).

Moreover, if the two heart objects are fully embedded in the same derived
semiorthogonal components, (26.9) also kills
\(\operatorname{Ext}^1_{\mathcal H}(A,E)\).  An opposite extension which
really lives there is then split.  The genuinely weaker nonsplit form of
Theorem 26.1 belongs to an oriented exact or recollement heart where the
degree-zero Hom vanishing survives but the relevant \(\operatorname{Ext}^1\)
need not vanish.

## 26.3 Upper-triangular/glued-heart specialization

For any abelian category \(\mathcal C\) with a natural endomorphism \(N\),
the arrow category

\[
\operatorname{Arr}(\mathcal C)
=\operatorname{Rep}_{\mathcal C}(1\longrightarrow2)
\]

is abelian.  Its vertex-one objects \((A\to0)\) are left-orthogonal to its
vertex-two objects \((0\to E)\), and kernels of \(N^m\) preserve the
vertex-one class.  Hence every arrow \(\delta:A\to E\) gives the exact
interface below.  This is a genuine general glued-heart specialization, not
only a finite toy.

For the nilpotent-module calibration, let

\[
\mathcal H=\operatorname{Rep}_{K[t]}(1\longrightarrow2)_{\mathrm{nil}}
\]

and let \(N\) be multiplication by \(t\) at both vertices.  Define

\[
\mathcal A=\{(A\to0)\},
\qquad
\mathcal E=\{(0\to E)\}.
\]

Every morphism from an \(\mathcal A\)-object to an \(\mathcal E\)-object is
zero.  For any \(K[t]\)-linear map \(\delta:A\to E\), the representation

\[
B_\delta=(A\xrightarrow{\delta}E)
\]

fits into

\[
0\to(0\to E)\to B_\delta\to(A\to0)\to0.
\tag{26.12}
\]

This sequence splits if and only if \(\delta=0\).  Nevertheless, if
\(t^mE=0\), then

\[
\delta t_A^m=t_E^m\delta=0
\]

and

\[
\operatorname{Top}_m(B_\delta)
=(t^mA\to0)
=\operatorname{Top}_m(A\to0).
\tag{26.13}
\]

Thus heart-level orthogonality may kill the retained leakage while allowing
a genuinely nonsplit extension.

At \(m=2\), take

\[
A=J_3,
\qquad E=J_2,
\qquad \delta:J_3\twoheadrightarrow J_2.
\]

Then (26.12) is nonsplit, but its retained top is the single line
\(t^2J_3\).  The finite Python model checks the intertwining equation,
exponent bound, and retained top rank.  The Hom calculation and nonsplitting
criterion are the preceding hand proof, not executable evidence.

After forgetting the two vertex labels, (26.12) becomes the split
\(K[N]\)-module \(A\oplus E\).  Thus this adapter does not evade the
load-bearing split of an extension component into the retained high
\(K[N]\)-block.  Its genuine saving is narrower: the richer gluing or Stokes
datum may remain nonsplit after the operator-level high piece has become
harmless.

### Load-bearing hypotheses

Three small countermodels prevent weakening Theorem 26.1 by slogan.

1. Without Hom orthogonality,
   \[
   0\to J_1\to J_2\to J_1\to0
   \]
   has nonzero threshold-one boundary.
2. Without \(N_E^m=0\), even the split object \(A\oplus E\) retains
   \(\operatorname{Top}_m(E)\), so its top need not equal that of \(A\).
3. Objectwise \(\operatorname{Hom}(A,E)=0\) does not replace kernel closure.
   In \(\operatorname{Rep}_{K[t]/(t^2)}(1\to2)\), let
   \[
   C=(R\xrightarrow{1}R),
   \quad
   A=(R\xrightarrow{q}K),
   \quad
   E=(0\to tR),
   \]
   where \(q:R\to K=R/(t)\).  Then
   \(0\to E\to C\to A\to0\) is exact and
   \(\operatorname{Hom}(A,E)=0\), but
   \(\ker(t:A\to A)=(tR\to K)\) has zero arrow and maps nontrivially to
   \(E\).  The boundary has rank one and
   \(\operatorname{Top}_1(C)\to\operatorname{Top}_1(A)\) is not an
   isomorphism.

The finite replay includes the third countermodel.  Nonflat specialization
can likewise destroy kernel/image compatibility, so occurrence base change
must be exact or separately strict.

## 26.4 What is and is not an augmentation

For the ExactTop source, the retained data

\[
(\chi,N,N^{m+1}=0,N^mV\ne0)
\tag{26.14}
\]

together with diagonal-product compatibility are sufficient.  Another
point row, deck marking, or full Stokes marking is not consumed by the
endpoint proof.

The additional datum in Theorem 26.1 is provider-side typing:

\[
(\mathcal H,\mathcal A,\mathcal E,\text{orientation},N,m).
\tag{26.15}
\]

It belongs naturally in the Reader/path environment.  Forgetting (26.15) to
plain nilpotent \(K[N]\)-modules erases the Hom orthogonality: any two
nonzero finite nilpotent \(K[N]\)-modules admit a nonzero map.  No lens can
recover that erased component label without a comparison back to the richer
environment.

The parallel rank-row route is different.  There the Gamma/point row is the
retained quotient itself, so it is a genuine augmentation rather than
provider typing.

## 26.5 Exact geometric gate

For the operation-framed \(m=2\) route, Theorem 26.1 reduces the new provider
to three independent statements for every actual blowup occurrence:

1. construct the opposite-oriented exact cyclotomic QDM sequence in one
   enriched heart;
2. place its ambient kernel and exceptional term in the required
   Hom-orthogonal components; and
3. prove \(N^2E=0\) for the actual exceptional term after every occurrence
   specialization.

If these hold, boundary vanishing is formal.  None is presently supplied by
the algebraic Orlov decomposition alone.  If the heart is only a receiver
for the QDM realization, that realization must also be exact, commute with
\(N\), kernels, and images, and reflect the nonzero retained endpoint
shadow.  Merely relabeling packets as ambient or exceptional, or defining a
receiver by quotienting out the offending boundary, would be circular.

## 26.6 Mystery ledger

| question | status | exact reason or gate |
|---|---|---|
| Does the source need another augmentation? | **settled: no for ExactTop** | (26.12) is the complete endpoint input |
| Is provider-side component typing dispensable? | **settled: no for the orthogonality route** | forgetting it destroys the Hom vanishing |
| Can zero boundary coexist with a nonsplit heart extension? | **settled: yes** | quiver sequence (26.12) |
| Is closure under \(\ker N^m\) cosmetic? | **settled: no** | the rank-one quiver boundary in the load-bearing countermodel |
| Can component labels be added after the fact? | **settled: no** | an exact faithful/conservative QDM realization must independently supply them |
| Does standard Orlov automatically supply (26.1)? | **open/no formal implication** | exact orientation and analytic heart are missing |
| Does a fully embedded SOD give a nonsplit opposite extension? | **settled: no** | full shifted orthogonality kills its \(\operatorname{Ext}^1\) class |
| Does the adapter prove the carrier exponent? | **settled: no** | the actual occurrence-indexed \(N^2E=0\) theorem remains independent |

## Boundary

The left-orthogonal adapter, its composition law, and the quiver model are
proved.  The QDM exact-heart realization and exceptional exponent are open.
No manuscript or Lean source is edited, and no unconditional (m=2) or
stable-irrationality claim is made.
