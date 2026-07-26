# Nonstabilizer AME rigidity: cheap kill tests

## Scope and replay

This bounded exact computation tests candidate local-unitary invariants on
the logical Bloch sphere of the perfect five-qubit code,
\[
 |\psi_t\rangle =
 \frac{|0_L\rangle+t|1_L\rangle}{\sqrt{1+|t|^2}}.
\]
Every point is an \(\operatorname{AME}(5,2)\) state, while a generic point is
nonstabilizer.  The script uses only the Python standard library and exact
Gaussian-rational arithmetic.

Replay from the repository root:

```text
python3 notes/2026-07-26-ame-lu-nonstabilizer-kill-tests.py
```

Script SHA-256:
`668ca12ccbf55c2df35fe5d3568fa0e5718ee80c1edf15182140e91a77a80f14`.

## Definitions

- **Projective Lie stabilizer.** Realify the sixteen columns
  \(-i\sigma_a^{(j)}|\psi_t\rangle\), for \(j=1,\dots,5\) and
  \(a=X,Y,Z\), together with \(i|\psi_t\rangle\).  Its kernel is the
  traceless local projective stabilizer.
- **Marginal spectral moments.** Compute
  \(\operatorname{tr}(\rho_S^k)\) for \(k=1,\dots,4\) and
  \(|S|=1,2,3\).
- **Triple mode Gram.** For
  \(T_S(a,b,c)=\langle\psi_t|\sigma_a\sigma_b\sigma_c|\psi_t\rangle\),
  contract two modes to form each \(3\times3\) mode Gram matrix.  Record
  \((\operatorname{tr}G,e_2(G),\det G)\).
- **Cross-triple contraction.** For distinct triples sharing two parties,
  contract their two common Pauli indices and record the singular-spectrum
  data of the resulting \(3\times3\) matrix.
- **Tangent leakage.** Add a logical code-coordinate tangent
  \(|1_L\rangle\) to the real span of all local orbit tangents, the radial
  vector, and the phase vector; record the rank increment.

## Exact outputs

The five exact sample points are \(t=0,\frac12,1,i,\frac{1+i}{2}\).
At all five:

- Lie rank is `16/16`, so the projective Lie kernel has dimension zero.
- Orbit-plus-radial rank is `17`; the logical tangent raises it by one.
- One-party moments are
  \((1,\frac12,\frac14,\frac18)\).
- Two- and three-party moments are
  \((1,\frac14,\frac1{16},\frac1{64})\).
- Every one of the thirty distinct-triple cross contractions has signature
  \((0,0,0)\).

For all thirty triple-mode Gram matrices at a given sample:

| \(t\) | \((\operatorname{tr}G,e_2(G),\det G)\) |
|---|---|
| \(0,1,i\) | \((1,0,0)\) |
| \(\frac12\) | \((1,\frac{144}{625},0)\) |
| \(\frac{1+i}{2}\) | \((1,\frac8{27},\frac{16}{729})\) |

Three further exact checks at
\(t=\frac23+\frac15i,-\frac34+\frac27i,\frac56-\frac49i\) verify that
the mode-Gram spectrum is
\[
 \{r_x^2,r_y^2,r_z^2\},\qquad
 (r_x,r_y,r_z)=
 \frac{(2\Re t,\,2\Im t,\,1-|t|^2)}{1+|t|^2}.
\]
These extra samples also have Lie rank 16, orbit-plus-radial rank 17, and
logical tangent rank increment one.

## Kill-test verdict

- **Killed as classifiers:** Lie-stabilizer dimension, ordinary marginal
  spectra, and the lowest distinct-triple cross contractions are constant
  on stabilizer and generic nonstabilizer samples.
- **Survives strongly:** a single three-body correlation tensor's mode-Gram
  spectrum recovers the unordered squared logical Bloch coordinates.
  Generically its three orthogonal rank-one Segre axes are intrinsic; the
  degeneracy walls are \(r_i=0\) or \(|r_i|=|r_j|\).
- **Survives locally:** the logical sphere is transverse to the
  product-unitary orbit.  Structurally, distance three gives
  \(P\sigma_a^{(j)}P=0\), while a nonradial logical tangent lies inside the
  code space.

The raw Segre intersection of a three-party marginal support was not pursued:
it requires a larger elimination computation and duplicates the cleaner
orthogonally decomposable correlation-tensor signal.
