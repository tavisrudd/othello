# C904 marked charge-two Brauer invariant audit

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: the unramified geometric ambiguity, Hilbert determinant degrees, and
the residual charge-three index gate

## Verdict

The companion boundary-residue calculation in
`2026-08-10-c904-charge-two-brauer-residue.md` is the decisive test for the
charge-two gerbe: at the generic strictly semistable boundary its residue is
the nontrivial ordering double cover of an unordered pair of lines.  Thus the
charge-two class is nonzero.  That proof is not duplicated here.  The
calculation here is supplementary: it answers what the marked `A5` lattice
can and cannot determine after the residue has been fixed.

For an exotic principally polarized intermediate Jacobian `J`,

\[
 \dim_{\mathbf F_2}\operatorname {Br}(J)[2]
 =\binom {10}{2}-\rho(J)=45-15=30.
\]

The exact action on the actual principal homology lattice gives

\[
\begin{aligned}
 \dim \operatorname {Br}(J)[2]^{A_5}&=4,\\
 \dim \operatorname {Br}(J)[2]^{C_3}&=10,\\
 \dim \operatorname {Br}(J)[2]^{A_5\times C_3}&=2.
\end{aligned}
\]

Here `C3` is the residual marked elliptic monodromy.  Hence symmetry alone
leaves four possible unramified corrections to a class with the prescribed
boundary residue.  It cannot identify the full cocycle, and in particular it
could not by itself have proved vanishing or nonvanishing.  All three
nonzero invariant cosets have the same exact alternating-rank profile modulo
`NS/2`; each has minimum rank four.

The canonical Hilbert determinant lines give a second, independent parity
check.  On every geometric quintic `P5` fibre their degree is

\[
 d_m=(m-1)(3m-2),
\]

so every `d_m` is even and their gcd is exactly two.  Thus the natural
Hilbert polarizations see the same exact factor two as the moduli-gerbe
weight calculation.

For charge three, this closes every zero-cycle supported on a fixed-line
Hecke conic: once the charge-two class is nonzero, that conic has index
exactly two.  The associated projective-three-space family of sections in
the sextic Hilbert model also has index two.  This does **not** rule out an
odd zero-cycle elsewhere in the generic fourfold fibre of `M9 -> J`.  No
exact computation found here turns the Hecke obstruction into a global
index theorem for `M9`; that remains the minimal gate.

## 1. Exact geometric Brauer quotient

The Kummer sequence gives

\[
 0\longrightarrow \operatorname {NS}(J)/2
 \longrightarrow H^2(J,\mathbf F_2)
 \longrightarrow \operatorname {Br}(J)[2]\longrightarrow0.
\]

The replay imports the certified exotic principal homology basis and the
fifteen integral divisor forms.  It then constructs:

1. the two standard generators of `A5` on the six-axis augmentation lattice;
2. their transported action on the principal rank-ten homology lattice;
3. the marked order-three elliptic monodromy
   `[-I -I; I 0]`;
4. the induced exterior-square action on the 45 alternating forms; and
5. the quotient by the actual rank-fifteen `NS/2` subspace.

Fixed vectors are computed only after taking the quotient; the calculation
does not assume that taking invariants is exact in characteristic two.  The
image of `A5` on the quotient still has order 60 and element counts

\[
          1,15,20,24
\]

in orders `1,2,3,5`, respectively.  Its Sylow-two subgroup is `V4`; the
fixed dimensions for `C2` and `V4` are 18 and 13.  Thus testing all
two-subgroup types inside `A5` produces no stronger vanishing constraint.

For each of the three nonzero joint-invariant cosets, exhaustive addition of
all `2^15` Neron--Severi representatives gives the same rank histogram:

| alternating rank | representatives |
|---:|---:|
| 4 | 640 |
| 6 | 3,200 |
| 8 | 17,664 |
| 10 | 11,264 |

This identical profile is a useful consistency check, not an identification
of the moduli cocycle.

There is also a logically separate equivariant ambiguity.  The Schur
multiplier `H^2(A5,C^*)` has order two, so the projective `A5` action on a
fibre can carry an equivariant obstruction even when an ordinary Brauer
class is split.  The calculation above concerns the ordinary geometric
Brauer quotient and must not be used to infer that Schur class.

## 2. Determinant degree on the quintic fibre

Let `E` be a charge-two bundle and put `F=E(1)`, so
`h^0(F)=6`.  Over the geometric fibre `P(H^0(F))`, the universal zero curve
has Koszul class

\[
 [\mathcal O_{\mathcal C}(m)]
 =[\mathcal O_X(m)]
 -[F^*(m)\boxtimes\mathcal O(-1)]
 +[\mathcal O_X(m-2)\boxtimes\mathcal O(-2)].
\]

Therefore the determinant-of-cohomology line
`det Rp_* O_C(m)` has relative degree

\[
 d_m=\chi(E(m-1))-2\chi(\mathcal O_X(m-2)).
\]

On a cubic threefold, Riemann--Roch gives

\[
 \chi(E(t))=t(t+1)(t+2),\qquad
 2\chi(\mathcal O_X(k))=k^3+3k^2+4k+2.
\]

Substitution yields

\[
 d_m=3m^2-5m+2=(m-1)(3m-2).
\]

The two factors have opposite parity, so `d_m` is always even; `d_0=2`
shows that the gcd is exactly two.  This proves parity for the standard
Hilbert determinant sublattice.  It does not by itself prove that this
sublattice is the full relative Picard group, so it is corroboration rather
than the nonvanishing proof.

## 3. Consequence and remaining M9 gate

Let `K=C(J)` and let `B/K` be the common-line Severi--Brauer conic.  At the
`M9` level, `B` parametrizes the fixed-line elementary transforms.  The
boundary residue proves `ind(B)=2`.  Above it, in the sextic Hilbert model,
the resolved section carrier is `P_B(W)` for a rank-four bundle `W`, hence

\[
              \operatorname {ind}(\mathbf P_B(W))=2.
\]

This is stronger than determinant-line parity on these fixed-line carriers:
every closed point and every zero-cycle on either has even degree.

The statement has an exact boundary.  A proper generic fourfold `V/K`
containing an index-two Hecke curve can still have an odd closed point away
from that curve.  Proving `ind(V)=2` would require one of:

- a specialization/retraction from all of `V` to the Hecke boundary;
- a computation of `CH_0(V)` or an unramified invariant detecting degree
  parity; or
- a generation theorem showing every degree class is represented on the
  Hecke boundary.

None of those three inputs is presently available.  Thus the exact result is
"all licensed boundary carriers are even," not "the generic M9 fibre has
index two."

## 4. Replay

From `/home/tavis/src/othello`, run

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-charge-two-brauer-invariants.py
```

The script is deterministic.  It exhausts all `3 * 2^15=98,304`
Neron--Severi representatives in the nonzero invariant cosets.  The
load-bearing imported lattice constants are in
`2026-08-10-c904-minimal-class-divisor-replay.py`.

An independent implementation using Sage's native finite-field matrices and
kernel routines checks the invariant dimensions, quotient `A5` image, and
determinant gcd:

```text
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-charge-two-brauer-invariants-replay.sage").read()))'
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-10-c904-charge-two-brauer-invariants.py` | 12,429 | `32d82d9946e5235de4d05e6d73ab8a4d5f63976f533017d11ff1759331f7975c` |
| `2026-08-10-c904-charge-two-brauer-invariants.out` | 653 | `47179abc77067293633efa90d0f7beab431e0f5d3c3e48dad25ff5d689929c45` |
| `2026-08-10-c904-charge-two-brauer-invariants-replay.sage` | 5,089 | `054419e9772df0cc6f8db0a66a35e95a457ead8a426de81b0f65c28e79619653` |
| `2026-08-10-c904-charge-two-brauer-invariants-replay.out` | 253 | `fa183e90e394fbff66a6313510d5230e44201770f769c0b2faabde9d42b79d0d` |
| imported principal/NS replay | 7,124 | `0c069348f457af232c5ab77173a1aedb6c188a00a23f832b9cf0935ce43f0d16` |

The independent replay uses the same certified principal/NS input constants
but a separate matrix implementation.  The exhaustive rank profiles are
checked only in the primary script; they are diagnostic and not load-bearing.

## 5. Primary-source boundary

- Markushevich--Tikhomirov, arXiv:math/9809140, Lemma 5.3 and Corollary
  5.4: the quintic Hilbert open is etale-locally the projectivization of a
  rank-six bundle, constructed from etale-local Poincare bundles.  Cache
  SHA-256 `04242e32b3e8950e310826ce68e903f522c7dd01559bbf2adbc7d01f9de546aa`.
- Druel, arXiv:math/0002058, Theorem 4.8: the compact charge-two moduli is
  the blowup of `J` along a translate of the negative Fano surface; the
  proof uses a universal family on the Quot parameter space, not on the
  coarse moduli.  It also identifies the strictly semistable divisor as
  generically finite over its image and the non-locally-free divisor as the
  contracted exceptional divisor.  Cache SHA-256
  `f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654`.

These sources do not state the marked invariant dimensions or the Hilbert
determinant formula above.

## 6. Mystery ledger

- **Settled:** the marked lattice does not force an unramified invariant to
  vanish; exactly two binary degrees of freedom survive.
- **Settled:** all canonical quintic Hilbert determinant degrees are even
  with gcd two.
- **Settled elsewhere by the boundary residue:** the actual charge-two
  gerbe is nonzero.
- **Open:** which of the four invariant unramified corrections gives the
  globally normalized marked cocycle after its residue is prescribed.
- **Open and highest value:** whether an odd zero-cycle exists in the
  interior of the generic charge-three `M9` fourfold.  The fixed-line Hecke
  carrier cannot supply one.
