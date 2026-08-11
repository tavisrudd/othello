# C904: residual C3 action on the dyadic Lefschetz cokernels

Date: 2026-08-11

Status: exact finite theorem and replay; Paper V research only; no manuscript
or Lean change

## Verdict

The residual order-three monodromy on the common twist-plus-sign marked base
does **not** close either middle-Kunneth escape by itself.

Let \(\Lambda=H^1(J,\mathbf Z)\), let \(L=\Theta\wedge-\), and use the actual
exotic principal lattice and Gate V residual monodromy

\[
 g=B\begin{pmatrix}-I&-I\\ I&0\end{pmatrix}^{t}B^{-1}.
\]

On the two-primary Lefschetz cokernels, the exact module structures are

\[
 \begin{aligned}
 Q_{15}&=\operatorname {coker}(L:\Lambda^5\to\Lambda^7)_{(2)}
       \cong (\mathbf F_2)^{10}=5W,\\
 Q_{24}&=\operatorname {coker}(L:\Lambda^4\to\Lambda^6)_{(2)}
       \cong (\mathbf F_2)^{44}=\mathbf 1^{24}\oplus10W,
 \end{aligned}
\]

where \(W\) is the irreducible two-dimensional \(\mathbf F_2[C_3]\)-module.
Consequently

\[
             \dim Q_{15}^{C_3}=0,
             \qquad \dim Q_{24}^{C_3}=24.
\]

The first vanishing is not an obstruction to an invariant Kunneth class.
The residual perfect pairings identify the effective companion modules with
the duals of these cokernels.  Their diagonal invariant tensor spaces have
dimensions

\[
 \dim(P_{15}\otimes Q_{15})^{C_3}=50,
 \qquad
 \dim(P_{24}\otimes Q_{24})^{C_3}=776.
\]

Both contain tensors with odd half-anti-graph contraction.  Thus a
fixed-vector-only descent argument would incorrectly discard the \((1,5)\)
channel: its odd class can live in the pairing of two nontrivial
\(C_3\)-isotypic factors.

For the \((2,4)\) channel the actual rank-fifteen Neron--Severi lattice is
pointwise fixed modulo two.  Its Lefschetz image has rank fourteen, and its
pairing with \(Q_{24}^{C_3}\) has rank fourteen.  Hence fixed residual
classes with odd half-anti-graph degree really do exist already against
actual divisor directions.  The principal-polarization vector itself is
the one-dimensional kernel: \(L(\Theta)=\Theta^2=0\pmod2\).  It does not
detect the residual quotient.

## Exact computation

The primary computation uses increasing-subset bases for all exterior
powers.  It checks the integral Smith forms

\[
 \operatorname {coker}(L:\Lambda^5\to\Lambda^7)
      \cong(\mathbf Z/2)^{10},
\]

and

\[
 \operatorname {coker}(L:\Lambda^4\to\Lambda^6)
      \cong(\mathbf Z/2)^{43}\oplus\mathbf Z/6.
\]

It then transports the exterior action through explicit quotient bases and
checks the fixed dimensions above.  The residual pairings

\[
 \operatorname {im}(L:\Lambda^1\to\Lambda^3)\times Q_{15}\to\mathbf F_2,
 \qquad
 \operatorname {im}(L:\Lambda^2\to\Lambda^4)\times Q_{24}\to\mathbf F_2
\]

have ranks ten and forty-four.  To certify odd invariant contraction, the
script starts with any paired pure tensor and averages its three translates.
The contraction is multiplied by three and therefore remains one modulo
two.  This is checked directly in both channels.

The independent replay does not use minors or the primary quotient-basis
routine.  It expands exterior products with bit masks and computes fixed
quotient classes as preimages of \(\operatorname {im}L\) under \(g-1\).  It
independently obtains \((10,0)\), \((44,24)\), and the actual NS ranks
\((15,14)\).

## What this proves and does not prove

This is a complete computation of the residual \(C_3\)-module and parity
data on the named integral lattice.  It proves that residual \(C_3\)
monodromy supplies no cohomological parity obstruction to the two escape
channels.

It does **not** algebraize any odd invariant tensor.  In particular, the
fifty-dimensional \(C_3\)-invariant \((1,5)\) space is much larger than the
actual Hodge/algebraic subspace.  The generic coefficient-identity tensor
from the full-Kunneth audit has odd coefficient trace, but identifying an
integral codimension-three algebraic inverse-Lefschetz correspondence
remains exactly the open gate.  Likewise, rank fourteen in the \((2,4)\)
test says that odd numerical pairings exist; it does not produce the
required non-split algebraic surface correspondence.

There is a sharp residual inside the fixed \((2,4)\) quotient:
\(Q_{24}^{C_3}\) has dimension twenty-four, while actual NS detects only
fourteen dimensions.  The remaining ten-dimensional annihilator is the
only part invisible to all actual divisor factors in this computation.

## Reproduction

From the repository root:

```sh
nix shell nixpkgs#sage -c sage notes/2026-08-11-c904-c3-lefsche-cokernels.sage \
  --output notes/2026-08-11-c904-c3-lefsche-cokernels.out
nix shell nixpkgs#sage -c sage notes/2026-08-11-c904-c3-lefsche-cokernels-replay.sage \
  --output notes/2026-08-11-c904-c3-lefsche-cokernels-replay.out
```

Load-bearing input:

- `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`: 21,199 bytes,
  SHA-256
  `d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734`.

Bundle hashes:

- `notes/2026-08-11-c904-c3-lefsche-cokernels.sage`: 9,850 bytes,
  SHA-256
  `c5e1097185a795d7e63e5af8685ab878013bb261aa1fb92b0f0e6268999d01a6`;
- `notes/2026-08-11-c904-c3-lefsche-cokernels.out`: 485 bytes,
  SHA-256
  `36014547174644e05012b0f81f7f6f675fd4ed74fc875d6fa421b81a07553857`;
- `notes/2026-08-11-c904-c3-lefsche-cokernels-replay.sage`: 4,950 bytes,
  SHA-256
  `c38f93d28df243adac1dd010d557c7133e11e0c73ac97c2dcf36048c0ed73d5a`;
- `notes/2026-08-11-c904-c3-lefsche-cokernels-replay.out`: 150 bytes,
  SHA-256
  `31461c3d45eb76b649128dbbafbc4bd235922c1390afccd34347a9135f0ef073`.

## EJ + TT closeout / mystery ledger

- **Settled:** the fixed-free ten-dimensional \((1,5)\) quotient does not
  imply fixed-free Kunneth tensors.  Pairing two copies of the irreducible
  \(C_3\)-module leaves fifty invariant dimensions and odd contraction.
- **Settled:** \(Q_{24}^{C_3}\) has dimension twenty-four; actual divisors
  detect fourteen of them with odd pairings.
- **Settled:** the polarization direction is exactly the mod-two Lefschetz
  kernel, so it cannot by itself detect the \((2,4)\) residue.
- **Open:** which part of the fifty-dimensional invariant \((1,5)\) space
  is realized by integral algebraic codimension-three correspondences.
  Owner: the primitive-theta/inverse-Lefschetz gate.
- **Open:** whether the ten-dimensional fixed \((2,4)\) annihilator contains
  an algebraic non-split correspondence.  The present calculation is only
  cohomological and supplies neither a construction nor a no-go theorem.

Vibe: exact and useful negative result--the proposed C3 obstruction fails,
but it fails in a sharply quantified way that isolates the surviving
ten-dimensional and inverse-Lefschetz gates.
