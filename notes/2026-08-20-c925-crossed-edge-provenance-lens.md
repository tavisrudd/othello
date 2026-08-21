# Module 60. The crossed-edge provenance lens

**Packet part:** Module 60. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the upper-triangular algebra and its composition law are proved.
For the completed-window pilots, retaining the moved-to-common cross block
restores the full Spenko--Van den Bergh product coefficient formally; the
order-zero failures in Module 59 are exactly the result of discarding that
block.  This is a relative crossed-edge theorem, not yet a Module 57
eigenrow theorem or an actual QDM source adapter.  Module 61 supplies the
lawful diagonal coefficient trait for every completed pilot.  The
based-loop/common-receiver reindexing and exact fixed-phase Malgrange reader
remain open.

## 60.1 The block identity

Let \(R\) be a commutative ring.  For one oriented edge, suppose

\[
 W_-=C_-\oplus M_-,\qquad W_+=C_+\oplus M_+,
\]

and write its comparison in upper-triangular form

\[
 F=\begin{pmatrix}A&B\\0&D\end{pmatrix},qquad
 A:C_-\to C_+,\quad B:M_-\to C_+,\quad D:M_-\to M_+.         \tag{60.1}
\]

Let the endpoint rows be

\[
 r_-=r_{C,-}\oplus r_{M,-},\qquad
 r_+=r_{C,+}\oplus r_{M,+}.                                 \tag{60.2}
\]

The cross block \(B\) remembers that a common-coordinate output was born
from a moving input.  It is not a new common vector and must not be identified
with a native fixed input before the consumer runs.

### Theorem 60.1 -- crossed moving-row identity

For any scalar \(\lambda\in R\), the full moving-input row law

\[
 r_{C,+}B+r_{M,+}D=\lambda r_{M,-}                           \tag{60.3}
\]

is equivalent to

\[
 \underbrace{(r_{M,-}-r_{M,+}D)}_{\text{plain moving defect}}
 -\underbrace{r_{C,+}B}_{\text{common-output lens}}
       =(1-\lambda)r_{M,-}.                                  \tag{60.4}
\]

**Proof.** Subtract (60.3) from \(r_{M,-}\).  Conversely, rearrange
(60.4).  No splitting beyond (60.1), invertibility, or commutation is used.
\(\square\)

Thus Module 59's plain moving-complement defect is not the full relative
defect.  It omits exactly one typed cross term.

## 60.2 Why an ordinary quotient cannot remember this term

### Proposition 60.2 -- provenance cannot be recovered by a covector

Let \(C\ne0\), and let a consumer \(\ell:C\to R\) be required to kill every
native common input.  Then \(\ell=0\), hence \(\ell B=0\) for every
\(B:M\to C\).  In particular, if the desired crossed law has
\(r_CB\ne0\), no ordinary covector on the untagged carrier \(C\oplus M\) can
simultaneously

1. kill every rank-visible fixed common input, and
2. retain the same common coordinate when it was produced by \(B\).

**Proof.** The first requirement says \(\ell(c)=0\) for every \(c\in C\).
Therefore \(\ell=0\) and \(\ell B=0\). \(\square\)

The obstruction is representational, not numerical.  The same vector of
\(C\) must be treated differently according to its path of origin.  One must
retain either the arrow \(B:M\to C\), an extension/filtration class encoding
it, or an explicit provenance tag.  A quotient of the underlying module has
already erased the needed fact.

## 60.3 The Spenko--Van den Bergh product normal is restored

For the literal traversal variance in Proposition 12.6, let

\[
 z_j=e^{-2\pi i\gamma_j},\qquad d_j=\iota^*(b_j),
 \qquad r_{\eta,\pm}([P_\mu])=\eta^\mu .                    \tag{60.5a}
\]

These are the special Fourier rows on the two window bases; (60.6) below is
not a law for arbitrary rows from Section 60.1.  For traversal from the
source chamber \(C_0\) to the target chamber \(C_2\), Proposition 12.6 uses
the weights negative on the traversal normal,

\[
 J=J_{-C_0,-C_2},\qquad
 A_{\eta,z}=\prod_{j\in J}(1-z_j\eta^{-d_j}).                \tag{60.5}
\]

Here \(\iota^*\) is the chosen character lift in the source, not the
cocharacter-lattice retraction of Module 61.  The summand indexed by
\(I\subseteq J\) sends the lifted source label \(\mu\) to
\(\mu-\sum_{j\in I}d_j\).  Evaluating all such summands by the target Fourier
row in (60.5a) gives the following identity.

On a moved character generator, the full row of the wall comparison is

\[
 r_+F=(1-A_{\eta,z})r_- .                                    \tag{60.6}
\]

Decomposing each shifted output into its common and moving coordinates turns
(60.6) into (60.3) with \(\lambda=1-A_{\eta,z}\).  Theorem 60.1 therefore gives

\[
 (r_{M,-}-r_{M,+}D)-r_{C,+}B
       =A_{\eta,z}r_{M,-}.                                   \tag{60.7}
\]

Along the formal diagonal substitution \(z_j=q_{\mathrm{coeff}}\), at the wall-factor rank
character \(\eta=1\),

\[
 A_{1,q_{\mathrm{coeff}}}
       =(1-q_{\mathrm{coeff}})^{|J|}.                        \tag{60.8}
\]

Every genuine pilot wall has \(|J|\ge1\).  Hence the **crossed** relative
defect has positive order in every one of the thirty-two directed pilot
transitions, including the blowup--blowdown and mixed directions where the
plain complement has order zero.  Module 61 certifies the diagonal
substitution as an admissible coefficient-torus DVR arc for every completed
unit pilot.  The symbol \(q_{\mathrm{coeff}}\) is not the QDM Novikov
coordinate: identifying its based loop with the actual fixed-phase
Fourier--Laplace/deck path is part of the reader, not notation.

This is not a contradiction with Module 58: native common generators remain
rank-visible and fixed.  The crossed consumer never presents them as moving
inputs.  It retains only common outputs carrying a proof that they arose from
the wall operation on a moving input.

## 60.4 Composition is the upper-triangular Writer law

For composable crossed edges

\[
 F_1=(A_1,B_1,D_1):C_0\oplus M_0\to C_1\oplus M_1,
 \qquad
 F_2=(A_2,B_2,D_2):C_1\oplus M_1\to C_2\oplus M_2,
\]

their composite has

\[
 A_{21}=A_2A_1,qquad
 B_{21}=A_2B_1+B_2D_1,qquad
 D_{21}=D_2D_1.                                               \tag{60.9}
\]

### Theorem 60.3 -- crossed-edge composition

Formula (60.9) is associative and has identity \((1,0,1)\).  If

\[
 r_{C,i+1}A_i=\lambda_i r_{C,i},\qquad
 r_{C,i+1}B_i+r_{M,i+1}D_i=\lambda_i r_{M,i},                \tag{60.10}
\]

then the composite satisfies the same two laws with scalar
\(\lambda_2\lambda_1\).

**Proof.** Associativity and the identity are block-matrix multiplication.
For the moving row,

\[
\begin{aligned}
 r_{C,2}B_{21}+r_{M,2}D_{21}
 &=r_{C,2}A_2B_1+(r_{C,2}B_2+r_{M,2}D_2)D_1\\
 &=\lambda_2(r_{C,1}B_1+r_{M,1}D_1)
  =\lambda_2\lambda_1r_{M,0}.
\end{aligned}
\]

The common-row equation is immediate. \(\square\)

Thus the cross block is a genuine semidirect Writer/cocycle, not arbitrary
history.  A typed path may compose it without reconstructing the full Stokes
matrix.

The scalar clause is not the generic SVdB source law: native common
generators have scalar \(1\), whereas the moved Fourier row has scalar
\(1-A_{\eta,z}\).  What composes without that homogeneous-scalar hypothesis is
the relative defect.  If the common rows are invariant under the \(A_i\), put

\[
 \Delta_i=r_{M,i}-r_{M,i+1}D_i-r_{C,i+1}B_i .               \tag{60.10a}
\]

Then direct substitution in (60.9) gives the source-compatible Writer law

\[
                         \Delta_{21}=\Delta_1+\Delta_2D_1.  \tag{60.10b}
\]

Thus Theorem 60.3 remains the homogeneous special case, while (60.10b) is
the law actually used before closed specialization in the SVdB pilots.

### Corollary 60.3A -- closed crossed defects telescope

Let \(R\) be a local ring with ideal \(\mathfrak m\).  Along a finite typed
path, assume the common rows are invariant, every block map is \(R\)-linear,
and

\[
             \Delta_i\in\mathfrak m\,\operatorname{Hom}_R(M_i,R).
                                                               \tag{60.10c}
\]

Then the composite crossed defect also lies in
\(\mathfrak m\operatorname{Hom}_R(M_0,R)\), hence vanishes after reduction
modulo \(\mathfrak m\).

**Proof.** Formula (60.10b) preserves the indicated submodule because
precomposition by the integral map \(D_1\) preserves
\(\mathfrak m\)-divisibility.  Induct on the path length. \(\square\)

Thus once the actual reader is built edgewise, no new global Stokes matrix
or path-level cancellation theorem is required.

## 60.5 Making the illegal erasure unrepresentable

The companion Haskell replay uses distinct promoted origins

```haskell
data Origin = Native | FromMoving
data Common (o :: Origin) a where
  NativeCommon   :: a -> Common 'Native a
  ProducedCommon :: a -> Common 'FromMoving a
data EdgeOut c m = EdgeOut (Common 'FromMoving c) m
```

and an endpoint-, arc-, and phase-indexed `RelativeEdge`.  The mathematical
API must hide the constructors `ProducedCommon` and `RelativeEdge`, exposing
only trusted smart constructors and an eliminator reading `EdgeOut`; such an
abstract API has no coercion

```text
Common 'Native c  ->  Common 'FromMoving c.
```

Composition requires the target occurrence of the first edge to equal the
source occurrence of the second and requires the same arc and phase indices.
It transports the origin tag by (60.9).  Erasing the tag before applying the
crossed reader is therefore not a well-typed program.

The companion now splits a constructor-hiding API module from its client.
The client can construct native values and lawful crossed outputs only
through exported audited fixture values.  Both the `Moving` constructor and
the produced-common constructor are hidden, so erasing a native value to its
raw carrier cannot make it a moving input, and the client cannot spell a
NativeCommon-to-ProducedCommon function.  This checks the promoted indices,
block composition, origin separation, and abstraction boundary.  The trusted API
implementation can still lie about geometry, so provenance of its witnesses
remains a software trust-boundary obligation, not a mathematical theorem.

This enforces only syntax and composition.  The trusted source boundary must
still prove that the geometric comparison really supplies the declared
\((A,B,D)\), that the coefficient arc is lawful, and that the fixed-phase
Malgrange/QDM realization reads the same rows.  Types cannot certify that
provenance after inspecting the desired answer.

## 60.6 Direct conditional consumer

### Theorem 60.4 -- crossed-edge source adapter

Fix an actual directed occurrence.  Assume:

1. an occurrence-, traversal-, phase-, character-, and DVR-arc-indexed
   crossed edge (60.1), carrying the same-index crossed row law
   \[
      r_{C,+}B+r_{M,+}D=(1-A_{\eta,z})r_{M,-};
   \]
2. a lawful coefficient-torus arc for which
   \(A_{\eta,z}=a u\), with \(a\) in the maximal ideal and \(u\) a unit;
3. an exact closed reader identifying the incoming actual Malgrange packet
   with the moving-source type and the outgoing can/variation component maps
   with \(B,D\), together with an explicit orientation sign
   \(\epsilon\in\{\pm1\}\) for which the actual directed projected row is
   \[
      \epsilon\bigl((r_{M,-}-r_{M,+}D)-r_{C,+}B\bigr);
   \]
4. exact base change of those packet, map, row, path, and direction data.

Then the directed projected row consumed by Module 54 is zero on the closed
fibre.

**Proof.** Equation (60.7) is \(a u r_{M,-}\).  Exact base change sends \(a\)
to zero, and multiplication by the orientation sign does not change zero.
The componentwise reader identifies that signed crossed row with the actual
directed projected variation. \(\square\)

This is strictly an alternative to promoting the relative edge to Module
57's global eigenrow.  It avoids the impossible requirement that the full
rank row kill native common fixed vectors.  It does not remove the actual
reader or lawful-arc gates.

## 60.7 Source audit

- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  [arXiv:2007.04924](https://arxiv.org/abs/2007.04924), Proposition 12.6,
  supplies the finite subset expansion and literal traversal variance used
  in (60.5)--(60.8).  It does not supply the lawful resonance trait or the
  fixed-phase QDM/Malgrange reader.
- Module 59 supplies the exhaustive five-signature pilot decomposition and
  identifies exactly which summands land in the common and moving character
  blocks.
- Module 55 owns the closed source types.  The new `CrossedEdgePhase` is a
  direct projected-variation source, not an `EigenrowLaw` constructor.

## 60.8 Reproducibility

Companion files:

- `notes/cubic-threefolds-tasks/C925CrossedEdgeLensToy.hs`;
- `notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy.hs`;
- `notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy-output.txt`.

Exact replay from `/home/tavis/src/othello`:

```sh
nix shell nixpkgs#ghc --command sh -c \
  'runghc -inotes/cubic-threefolds-tasks \
       notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy.hs \
   | diff -u \
       notes/cubic-threefolds-tasks/c925-crossed-edge-lens-toy-output.txt -'
```

The toy checks one hostile one-weight wall: the native common generator has
rank one, the plain moving defect has order zero, and the provenance-tagged
crossed defect is \(1-q_{\mathrm{coeff}}\), of order one (the Haskell
polynomial variable named q represents \(q_{\mathrm{coeff}}\)).  It also checks the typed
upper-triangular composition law.  It is not evidence for the geometric
source reader.

| artifact | bytes | SHA-256 |
|---|---:|---|
| constructor-hiding API | 5170 | `aef6cc1e5f0ab75682d08fc70509a74ee5707233e028cafe48571365e362c8f7` |
| Haskell client | 1648 | `d5b32ee44b3e950aee3bc29f07e7e446f9095389144c5104233d54beb08ccc21` |
| expected output | 149 | `a0b4091501f21fff97c9fa4ee2832c6bb789578f23fcc18c65cf52f7962889be` |

## 60.9 EJ/TT and mystery ledger

**EJ.** The order-zero failures were useful: they identify the precise extra
state needed by the source.  It is one cross arrow \(B:M\to C\), not a full
Stokes matrix, and it composes by a closed semidirect law.

**TT.** The fixed/common summand is not noise to quotient away.  It is a
workspace whose meaning depends on provenance.  The correct sparse shadow is
an arrow-category object or filtered extension, and the correct consumer is
relative.  Test the actual source against that smaller interface before
trying another projector.

| question | status | evidence or remaining gate |
|---|---|---|
| What restores the product normal lost by the moving complement? | **exactly the cross term \(r_CB\)** | Theorem 60.1 |
| Can an ordinary row kill native common inputs but read the same untagged common outputs? | **no** | Proposition 60.2 |
| Does the crossed pilot coefficient have positive formal diagonal order? | **yes for every directed pilot transition** | (60.8) and \(|J|\ge1\) |
| Does this compose along paths? | **yes as a typed upper-triangular Writer law** | Theorem 60.3 and Haskell replay |
| Do closed crossed defects require a new global cancellation theorem? | **no** | Corollary 60.3A |
| Is the diagonal substitution a lawful SVdB/GKZ trait? | **yes on all five completed pilots** | Module 61 |
| Is the crossed edge the actual fixed-phase Malgrange/QDM packet map? | **open** | occurrence-indexed exact reader in Theorem 60.4 |

## Boundary

The source-side algebra no longer needs a global eigenrow on the full window,
a quotient rank row, or a two-wall Stokes matrix.  A provenance-tagged
relative edge retains exactly the forgotten common-output term and restores
the full product normal.  Module 61 supplies its pilot trait.  The remaining
theorem is geometric/analytic: build that typed edge and based loop inside
the actual fixed-phase packet reader.
