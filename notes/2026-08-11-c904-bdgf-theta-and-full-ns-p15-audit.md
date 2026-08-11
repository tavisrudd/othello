# C904: BdGF theta pullback and the full NS divisor-cube p15 lattice

Date: 2026-08-11

Status: exact no-go theorem and finite lattice certificate; Paper V research
only; no manuscript or Lean change

## Verdict

Two tempting routes close cleanly.

First, the Beckmann--de Gaay Fortman integral cycle with class

\[
                         P^{[3]}=\frac{P^3}{3!}
\]

does pull algebraically to \(M\times M\), but it is not a p15
inverse-Lefschetz correspondence.  Its sole Kunneth bidegree is \((3,3)\).
On the theta-resolution fourfold it acts from \(H^5(M)\) to \(H^3(M)\),
not from \(H^3(M)\) to \(H^1(M)\).  Even granting integral Chow descent to
\(\operatorname {Sym}^2M\), its addition degree is \(-80\), not the desired
degree five.

Second, enlarging from this canonical kernel to the **full** divisor-product
cube lattice on \(J\times J\) still does not produce the primitive p15
projector.  This remains true after adding every mixed divided cube
\(D^2P_T/2\) supplied by the Beckmann--de Gaay Fortman PD structure on
Chow modulo torsion.  Include all 15 divisor directions on each factor and
all 25 integral cross-endomorphism directions.  Both exact p51 action
lattices are

\[
       \boxed{\ \mathcal L_{51}^{\rm div}=2\operatorname {End}(J)\ }.
\]

Equivalently,

\[
 \operatorname {End}(J)/\mathcal L_{51}^{\rm div}
       \cong(\mathbf Z/2)^{25}.
\]

The normalized identity has exact order two in both.  Thus no integral
combination of divisor cubes or their available PD halves, including
arbitrary graph/cross classes from the exotic endomorphism order, realizes
the odd coefficient identity.  The remaining gate is genuinely outside the
divisor-generated PD Chow subring.

## 1. Why the BdGF class has the wrong bidegree

Let \(A=J\), \(p=c_1(\mathcal P)\), and \(b:M\to\Theta\subset A\).  The
BdGF construction supplies an integral algebraic cycle \(K\) on
\(A\times A\) with

\[
                       [K]=p^{[3]}.
\]

Since \(p\) has pure bidegree \((1,1)\), its divided cube has pure bidegree
\((3,3)\).  Pullback by \(b\times b\) preserves Kunneth bidegree.  A
codimension-three correspondence on a fourfold sends \(H^r\) to
\(H^{r-2}\), but its \((3,3)\) component is nonzero only when
\(r+3=8\).  Hence

\[
                    (b\times b)^*K:H^5(M)\longrightarrow H^3(M).
\]

The desired map \(H^3(M)\to H^1(M)\) requires bidegree \((5,1)\), which is
absent.

The same correction can be stated on \(A\).  Although
\(b_*H^3(M)\subset H^5(A)\), the Fourier component \(p^{[3]}\) acts from
\(H^7(A)\) to \(H^3(A)\), not from \(H^5(A)\) to \(H^1(A)\).  Gysin does
not repair the two-degree mismatch.

This failure is cohomological.  Changing the algebraic representative of
the BdGF class by a homologically trivial cycle cannot create a p15
component.

## 2. Symmetry and the half anti-graph

The exact exterior expansion of \(p^{[3]}\) is a \(120\times120\)
skew-unimodular matrix on \(\bigwedge^3H^1(A)\): it has rank 120,
determinant of absolute value one, zero diagonal, and 120 nonzero entries.
Thus its free integral cohomology class is an odd-degree Nakaoka transfer
and has an integral cohomological symmetric-square descent.  The possible
gap is only integral **Chow** descent of the chosen cycle.

That gap cannot help.  On the anti-graph \(j=(1,\iota)\),

\[
             j^*p=-2h,qquad
             j^*p^{[3]}=-8h^{[3]}.
\]

Therefore a descended class would have

\[
 \lambda=\frac12j^*p^{[3]}=-4h^{[3]},
 \qquad
 d=\int_Mh\lambda=-4\frac{\int_Mh^4}{3!}=-80.
\]

Here \(\int_Mh^4=120\).  If only twice the class descends in Chow, the
degree is \(-160\).  Either way it is even and cannot close the index-one
gate.

## 3. The full NS divisor-cube and divided-cube lattices

For the generic non-CM exotic coefficient model,

\[
 \operatorname {rk}\operatorname {NS}(A)=15,
 \qquad
 \operatorname {rk}\operatorname {End}(A)=25,
\]

so

\[
 \operatorname {rk}\operatorname {NS}(A\times A)=15+15+25=55.
\]

The script obtains the full integral endomorphism order by intersecting the
25-dimensional rational coefficient-endomorphism space with integral
endomorphisms of the actual exotic principal homology lattice.  A cross
endomorphism \(T\) supplies the Poincare block
\(\Omega T^t\).

Only one type of triple divisor product contributes in bidegree \((5,1)\):
two divisors on the first factor and one cross divisor.  Thus the complete
generating set has

\[
              \binom{15+1}{2}\cdot25=120\cdot25=3000
\]

elements.  For a surface product \(S=D_iD_j\), its action on the Lefschetz
copy \(LH^1\subset H^3(M)\) is computed from

\[
        \int_A\Theta^2\,x\,D_iD_j\,u
\]

followed by the cross-endomorphism matrix.

The resulting ordinary-product lattice has rank 25 inside the full integral
endomorphism order.  Its inclusion Smith form has 25 nonunit elementary
divisors, all equal to two.  Hence its quotient is exactly
\((\mathbf Z/2)^{25}\), not merely a group of that order, and the image
equals \(2\operatorname {End}(A)\).

BdGF Theorem 3.8 gives the PD operations on Chow modulo torsion.  Applied on
\(A\times A\), this supplies the 375 mixed divided classes

\[
                         \frac{D_i^2P_T}{2}
             \qquad(1\leq i\leq15,\ 1\leq T\leq25).
\]

Arbitrary integral \(D\) adds no further generator: polarizing
\((D_i+D_j)^2P_T/2\) produces the already present ordinary product
\(D_iD_jP_T\).  The script adjoins all 375 halves to the 3000 ordinary
generators.  The enlarged lattice still has inclusion Smith form

\[
                       (2,2,\ldots,2)\quad(25\text{ times}).
\]

Thus the PD-divided image is also exactly \(2\operatorname {End}(A)\), and
the identity again has exact order two.  Chow torsion cannot change this
cohomological action or any addition degree because the target integral
cohomology is torsion-free.

The primitive identity is therefore absent, while \(2I\) is present.  In
the odd p15 coefficient normalization, identity would contribute degree
five and \(2I\) contributes degree ten.  Symmetrizing a p51 divisor-cube
class with its transpose cannot change this parity.

## 4. Independent normalization and parity checks

There are three checks independent of the Smith calculation.

1. Every generator contains \(\Theta^2=2\Theta^{[2]}\) in the contraction
   formula, so every p51 action is even.  This proves
   \(\mathcal L_{51}^{\rm div}\subseteq2\operatorname {End}(A)\)
   conceptually.
2. For the canonical surface \(S=\Theta^2/2\) and the identity Poincare
   cross class, the calculation returns \(-12I\), agreeing with
   \(\int_Mh^2S/5=12\) up to the fixed Poincare sign.  This checks the
   action normalization independently of the quotient SNF.
3. For a divided generator \(D^2P_T/2\), both
   \(\Theta^2=2\Theta^{[2]}\) and \(D^2=2D^{[2]}\) contribute a factor four
   before the single division by two.  Hence every PD-divided action is
   still even.  This conceptually proves containment in
   \(2\operatorname {End}(A)\) for the enlarged lattice.

The SNF then proves the reverse inclusion and exact equality.  There is no
second implementation of the 3000-generator HNF/SNF calculation; the
conceptual even containment and canonical scalar check independently verify
the two load-bearing normalizations.

## 5. Consequences and exact boundary

- The existing BdGF cycle is integral and algebraic but belongs to the p33
  channel.  It cannot be repurposed as p15 by restriction to \(M\).
- Integral cohomological symmetric descent of \(p^{[3]}\) is not the issue;
  the class has degree \(-80\) even under the best descent scenario.
- Every p15 class obtained from the full divisor-generated PD ring on
  \(A\times A\), including exotic graph classes and all BdGF mixed divided
  cubes, has even coefficient.
- The available PD halves do not halve the p15 action lattice.  Algebraizing
  the missing half therefore remains precisely the non-split
  inverse-Lefschetz problem, not a consequence of BdGF.
- No relative identity or odd multisection follows.

## Reproduction

From the repository root:

```sh
nix shell nixpkgs#sage -c sage notes/2026-08-11-c904-bdgf-theta-p15-bidegree-audit.sage \
  --output notes/2026-08-11-c904-bdgf-theta-p15-bidegree-audit.out
nix shell nixpkgs#sage -c sage notes/2026-08-11-c904-full-ns-cube-p15-lattice.sage \
  --output notes/2026-08-11-c904-full-ns-cube-p15-lattice.out
```

The optimized full-NS script caches the left contraction once for each of
the 120 surface products, then applies the 25 cross matrices.  Replay leaves
only Sage's generated `.sage.py` translation, which must be removed; the
committed bundle is debris-free.

Load-bearing input:

- `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`: 21,199 bytes,
  SHA-256
  `d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734`.

Bundle hashes:

- `notes/2026-08-11-c904-bdgf-theta-p15-bidegree-audit.sage`: 4,748 bytes,
  SHA-256
  `bf2e2537376bac3aa11838ddc50d16894106d9a64cfe832e2bb7a57b6b7b1e9d`;
- `notes/2026-08-11-c904-bdgf-theta-p15-bidegree-audit.out`: 418 bytes,
  SHA-256
  `9d935202aecf81407b4e4e07a41d270acd274751484c1416c594912bf805a011`;
- `notes/2026-08-11-c904-full-ns-cube-p15-lattice.sage`: 7,168 bytes,
  SHA-256
  `3417088e84d81961796f2bb12d16ad9f1b0a33e3a7f2fce462142c2799eec15a`;
- `notes/2026-08-11-c904-full-ns-cube-p15-lattice.out`: 511 bytes,
  SHA-256
  `fbb7d316fa991b9f947d12eb0fd1f7870c0073d8374576ebdf508b28af5dc2f8`.

## EJ + TT closeout / mystery ledger

- **Settled:** the BdGF class is pure p33, not p15; its best-case addition
  degree is \(-80\).
- **Settled:** its integral cohomology class already has primitive
  symmetric-square descent, so the failure is not a hidden cohomological
  transfer factor.
- **Settled:** the full p15 divisor-cube image, including every exotic cross
  endomorphism, is exactly \(2\operatorname {End}(J)\).
- **Settled:** adjoining all 375 BdGF mixed divided-square cubes leaves the
  image unchanged at \(2\operatorname {End}(J)\).
- **Settled:** the normalized identity has exact order two, so graph classes
  do not evade the parity wall.
- **Open:** integral Chow descent of the specific BdGF pullback.  It cannot
  affect the no-go because every possible descended degree is even.
- **Open and sole live gate:** a genuinely non-divisor-generated algebraic
  half of the p15 inverse-Lefschetz correspondence.
- **Mystery:** the equality with the *entire* doubled endomorphism order is
  unexpectedly sharp.  The even containment is formal from
  \(\Theta^2=2\Theta^{[2]}\); the exact surjectivity after division by two
  may admit a conceptual proof from the earlier mixed-adjugate theorem.

Vibe: decisive closure.  BdGF hits the wrong Kunneth component, and even the
maximal divisor-cube enlargement stops at the exact factor-two wall.
