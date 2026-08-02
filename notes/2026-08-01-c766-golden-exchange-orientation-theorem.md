# C766 — Exchange-statistics orientation theorem

**Lane:** `golden`

**Status:** complete

## Result

The C765 manuscript now separates a general left--right orbit theorem from
the Golden balanced specialization.

Let (V,W) be real Euclidean spaces of dimension (n\ge2) and
(K:V\to W). The (O(W)\times O(V)) double orbit of (K) is determined by
its singular values. Over an invertible orbit, restriction to
(SO(W)\times SO(V)) gives two orbits distinguished by the sign of the
oriented determinant. On the singular locus the two orbits merge, because a
reflection can be absorbed in a zero singular direction.

The intrinsic object is therefore not a scalar determinant but the top
exterior map

\[
 \bigwedge^nK:\det V\longrightarrow\det W.
\]

Orienting the two determinant lines turns it into a signed scalar. Reversing
one port orientation reverses that scalar. The determinant-zero hypersurface
is exactly the boundary at which this oriented label disappears.

The permanent does not descend even through the special-orthogonal double
orbit. For the universal plane-rotation family,

\[
 \operatorname{per}(R_\theta\oplus I_{n-2})=\cos(2\theta),
 \qquad
 \det(R_\theta\oplus I_{n-2})=1.
\]

Thus a permanent belongs to a calibrated choice of ordered port frames; it is
not a scalar of the unframed Euclidean transfer.

## Complex port gauges

The same statement holds with (U(n)) and (SU(n)). Singular values classify
the full unitary double orbit. On the invertible locus the residual label is
the determinant-line phase, and it disappears on the singular locus. The real
Golden transfer and a coherent phase reference reduce this phase to a sign.

This closes a physical-language gap in the initial scaffold: ordinary optical
port rephasings are unitary, even though the frozen Golden carrier and its
pivot frames are real.

## Exchange-sector completion

For (H=K^\dagger K), the three Schur functors give

\[
 \operatorname{tr}(\operatorname{Sym}^3H)=h_3(H),\qquad
 \operatorname{tr}(S_{(2,1)}(H))=s_{(2,1)}(H),\qquad
 \operatorname{tr}(\bigwedge^3H)=e_3(H).
\]

At every balanced Golden block,

\[
 (h_3,s_{(2,1)},e_3)
 =\left(\frac{313}{125},\frac85,\frac{16}{125}\right),
\]

and Schur--Weyl decomposition gives the exact checksum

\[
 h_3+2s_{(2,1)}+e_3
 =\operatorname{tr}(H)^3=\frac{729}{125}.
\]

The mixed sector completes the exchange decomposition; it does not supply a
second signed bosonic coordinate.

## Terminology audit

- **Orientation:** the choice of generators of the input and output
  determinant lines. A signed scalar determinant is used only after these
  choices are fixed.
- **Intrinsic:** invariant under the explicitly declared full orthogonal or
  unitary port-frame action. Under this action every scalar factors through
  singular values.
- **Calibrated:** defined after ordered, phase-referenced port frames have been
  frozen. Permanents and coherent determinant signs live at this level.
- **Blind:** removed as a stand-alone theorem word. The manuscript now says
  exactly that all full-port-gauge invariants take the same value on the
  balanced blocks and therefore cannot distinguish their marked nodes or
  orientations.

The symmetric-cube trace is described as **a canonical aggregate**, not the
unique basis-independent bosonic observable.

## Proof and trust boundary

The orbit theorem is a human proof from singular-value decomposition, parity
adjustment in the kernel, and functoriality of the top exterior power. The
permanent obstruction is the displayed continuous rotation family. No finite
search or new computation enters C766.

The exact Golden values remain imported from the independently replayed C718
bundle; C767 owns their paper-local evidence integration. The seven-page C765
manuscript passes `make check` without warnings.

## EJ + Tao closeout

The cheap strengthening was to identify the determinant-zero set as the exact
merger of the two oriented orbit chambers. This makes the 44 zero Boolean
controls conceptually part of the orientation boundary rather than merely a
census complement.

The Tao-style checks asked three questions that the first scaffold left
implicit:

1. What is the determinant before bases are chosen? It is the map between
   determinant lines.
2. What changes for physical complex port phases? The sign becomes a
   determinant-line phase under the (U/SU) version.
3. Where is the standard (S_3) exchange type? It is the
   (S_{(2,1)}) sector with trace (8/5), and the full tensor-cube checksum
   closes exactly.

All three upgrades are now in the manuscript.

## Mystery ledger

| feature | state | evidence gap or owner |
|---|---|---|
| the two oriented orbit classes meet exactly at `det K = 0` | settled | singular-value proof in C766 |
| all twenty Golden balanced blocks share one spectrum | proved in the frozen source, paper-local trust import still open | C767 |
| maintaining the coherent phase reference needed to reduce the unitary phase to a real sign | mathematically specified, experimentally open | C769 |
| whether the general theorem alone raises the venue from PRA to *Quantum* | unresolved editorial question; no mathematical defect | C770 cold reads |

No further proof mystery remains inside the C766 boundary.

## Publication assessment

The general theorem gives the paper a genuine conceptual statement beyond the
Golden example, but its ingredients are classical orbit and exterior-power
theory. The publication strength lies in selecting the correct invariant
boundary and joining it to the exact Golden benchmark and hardware audit, not
in claiming a new classification of matrix orbits. This supports the current
`Physical Review A` default. A `Quantum` submission still requires the C770
cold reads to find broader conceptual reach.
