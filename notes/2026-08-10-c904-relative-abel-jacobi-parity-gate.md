# C904 Annals gate VI: the relative Abel--Jacobi parity boundary

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: quintic and sextic Abel--Jacobi models, determinant weights, the
common line, and odd theta-cut attempts

## Executive verdict

The degree-five route has an exact two-primary ceiling.  The tempting
fine-moduli shortcut is false: Xu's claimed value
\(\chi(E\otimes\mathcal O_X(1))=5\) omits the point term
\(\tfrac12[\mathrm{pt}]\) in
\(\operatorname{ch}(\mathcal O_X(1))\).  The corrected value is

\[
                  \chi(E(1))=6.
\]

For a charge-two rank-two bundle the full determinant-weight ideal is
exactly \(2\mathbf Z\).  Thus the Iliev--Markushevich--Tikhomirov
\(\mathbf P^5\)-fibration carries a genuine order-at-most-two moduli gerbe;
the determinant construction cannot produce a universal sheaf or an odd
lift.  Their pencil of reducible quintics containing a fixed line is a
linear \(\mathbf P^1\) inside every geometric \(\mathbf P^5\).  Over the
generic point it reduces the possible index to \(1\) or \(2\): if the class
is nonzero, one quadratic splitting extension is both sufficient and
minimal.  The common line therefore identifies the exact quadratic gate; it
does not by itself split it.

The degree-six route is arithmetically different and remains live.  Twisting
Voisin's rank-two bundle with \(c_1=2h,c_2=6l\) by \(\mathcal O_X(-1)\)
gives charge three, and

\[
                    \chi(E)= -1.
\]

Hence its determinant-weight ideal is \(\mathbf Z\), so the charge-three
moduli problem is fine.  This removes the first gerbe in the sextic model.
It does **not** yet construct the identity over \(J\): Voisin proves that the
nine-dimensional charge-three moduli space \(M_9\) has maximal rationally
connected quotient \(J\), but does not identify \(M_9\to J\) as a split
projective bundle or give a relative degree-one/odd zero-cycle.  The final
gate has moved from the \(\mathbf P^3\) of sections to the four-dimensional
generic fibre of \(M_9\to J\).

One attractive odd workaround is now ruled out exactly.  The two
twisted-cubic families lie over theta divisors.  Cutting
\(\Theta\times\Theta\) by three relative divisor classes and then using the
degree-three transfers from their projective-plane fibres would give an odd
correspondence only if

\[
        \int_J \Theta^2D_1D_2D_3
\]

could be odd.  On the certified exotic principal lattice, the 680 divisor
triple products span a rank-50 **saturated** lattice, and the ideal of all
these pairings is exactly \(2\mathbf Z\).  Thus no divisor-generated integral
theta cut can supply the missing odd multisection.

The honest current conclusion is therefore:

\[
\boxed{
\begin{array}{c}
\text{quintic model: exact two-primary ceiling;}\\
\text{sextic charge-three model: fine, but }M_9\to J\text{ remains;}\\
\text{all relative-NS theta cuts: even.}
\end{array}}
\]

This is a substantial narrowing, not a proof of the integral relative
identity cycle on the marked base.

## 1. Uniform charge-parity theorem

Let \(X\subset\mathbf P^4\) be a smooth cubic threefold, let \(h\) be the
hyperplane class, and let \(l\) be the class of a line, so \(h^2=3l\) and
\(h\cdot l=[\mathrm{pt}]\).  For a rank-two numerical class with
\(c_1=0,c_2=nl,c_3=0\),

\[
       \operatorname{ch}(E)=2-nl,
       \qquad
       \operatorname{td}(X)=1+h+2l+[\mathrm{pt}].
\]

Since

\[
 \operatorname{ch}(\mathcal O_X(t))
 =1+th+\frac{3t^2}{2}l+\frac{t^3}{2}[\mathrm{pt}],
\]

Riemann--Roch gives the uniform polynomial

\[
 \chi(E(t))
 =2\!\left[\binom{t+4}{4}-\binom{t+1}{4}\right]-n(t+1).
\]

The determinant-weight ideal of the stable-sheaf gerbe is therefore

\[
                  \gcd(2,n)\mathbf Z.
\]

Indeed, pairing with the structure sheaf of a line gives \(2\).  If \(n\)
is odd, pairing with \(\mathcal O_X\) is \(2-n\), so the gcd is one.  If
\(n\) is even, the numerical K-class is

\[
             2\bigl([\mathcal O_X]-(n/2)[\mathcal O_l]\bigr),
\]

so every Euler pairing is even, and the line pairing shows that the gcd is
exactly two.

For charge two this gives

\[
 \chi(E\otimes E)=-4,\qquad
 \chi(E(1))=6,\qquad
 \chi(E\otimes\mathcal O_l)=2.
\]

For charge three, \(\chi(E)=-1\).  Huybrechts--Lehn's determinant criterion
therefore gives a universal family on the charge-three stable locus, whereas
the same construction for charge two stops exactly at similitude two.

This parity theorem is elementary and should be regarded as a uniform
compression of the gate, not as a novelty claim.

## 2. Why Xu's shortcut cannot be used

Xu claimed that the charge-two moduli space is fine by combining the weights
\(-4\) and \(5\).  The displayed Chern character in that proof stops at
codimension two:

\[
  1+h+\frac32l.
\]

On a threefold it must include \(\tfrac12[\mathrm{pt}]\).  The corrected
Euler characteristic is six, leaving gcd two.  Voisin explicitly records
this error in Remark 0.8 of her 2015 Inventiones paper and states that the
universal-cycle problem for a general cubic remains open.

This correction matters twice here:

1. it invalidates the proposed direct relative universal-sheaf construction;
2. it confirms that the factor two in the Fano-incidence correspondence is
   not an artifact of choosing the wrong Abel--Jacobi carrier.

## 3. The common-line index theorem

Markushevich--Tikhomirov prove that the quintic Hilbert open is etale-locally
the projectivization of a rank-six bundle over the charge-two moduli open.
Iliev--Markushevich then prove that for any line \(l\subset X\), every
geometric \(\mathbf P^5\) Abel--Jacobi fibre contains a unique linear pencil
\(\mathbf P^1\) of reducible curves \(C'+l\).

For a family with a relative line, this construction globalizes over the
generic charge-two moduli point.  The resulting twisted linear
\(\mathbf P^1\) has the same Brauer class as the ambient twisted
\(\mathbf P^5\).  Consequently its index divides two.  Thus:

> **Common-line index dichotomy.**  The generic quintic Abel--Jacobi fibre
> over the marked family has index \(1\) or \(2\).  If its moduli-gerbe class
> is nonzero, every splitting field has even degree and a quadratic splitting
> field exists.

The theorem computes the minimal possible base change conditional on
nontriviality.  It does not prove that the special \(A_5\) class is nonzero.
An integral universal zero-cycle can exist even when the Brauer class is
nonzero, so splitting the projective bundle is sufficient but not logically
necessary for the desired cubic correspondence.

## 4. Degree six: the surviving odd route

Voisin associates to a general degree-six elliptic curve a stable rank-two
bundle with \(c_1=2h,c_2=6l\) and four sections.  After twisting by
\(\mathcal O_X(-1)\), this is the charge-three class.  The fine-moduli result
therefore makes the first map

\[
        M_{6,1}\dashrightarrow M_9
\]

an honest projective-three-space construction on a dense open, rather than a
hidden two-primary Brauer--Severi construction.

Voisin's theorem proves that the maximal rationally connected quotient of
\(M_{6,1}\), equivalently of the relevant component of \(M_9\), is \(J\).
The proof uses the boundary loci of type \((3,3)\) and \((5,1)\), theta
geometry, and a non-uniruledness argument.  It is not an explicit birational
description of the generic fourfold fibre of \(M_9\to J\).  No odd index is
printed there.

The next high-EV question is therefore precise:

> Does the common line define a charge-two/charge-three Hecke correspondence
> whose projection to the fourfold fibre of \(M_9\to J\) has odd degree?

If yes, the resulting odd correspondence combines with the already proved
relative \([2]\) Fano-incidence cycle by Bezout.  If every such Hecke carrier
has even degree, its parity class should identify the same two-primary gerbe
as the quintic pencil and produce a sharp impossibility theorem.

## 5. Exact no-go for divisor theta cuts

Take the fifteen-element integral Neron--Severi basis on the exotic principal
quotient.  Its degree-three divisor monomials give
\(\binom{17}{3}=680\) rows in
\(\bigwedge^6\mathbf Z^{10}\).  Exact lattice saturation gives

\[
 \operatorname{rank}L_3=50,
 \qquad
 L_3=(L_3\otimes\mathbf Q)\cap\bigwedge^6\mathbf Z^{10}.
\]

On this saturated lattice the functional

\[
          z\longmapsto \int_J\Theta^2z
\]

has image \(2\mathbf Z\).  In particular every product
\(D_1D_2D_3\) has even pairing, and saturation introduces no hidden odd
class.

This rules out the specific proposed construction: cut
\(\Theta\times\Theta\) to a five-cycle by three classes coming from the
globalized relative Neron--Severi lattice, lift the two theta coordinates by
twisted cubics, and hope for an odd transfer.  The addition degree is even
before the projective-plane transfers are applied.

The computation does not rule out a non-divisor algebraic codimension-three
class outside the divisor-generated rational Hodge subspace, nor an odd
carrier intrinsic to \(M_9\).

## 6. Paper V and series fit

This gate should **not** be inserted into the current Paper V manuscript as a
claimed universal-cycle theorem.

Its proper role is now clear:

- the marked Clebsch reconstruction still supplies the series culmination;
- the Annals upgrade supplies an integral modular boundary bridge and a
  primitive relative minimal class;
- the Abel--Jacobi audit explains why those achievements do not automatically
  produce a relative cubic identity cycle: all visible quintic, Fano, Prym,
  and theta-cut routes meet the same factor two;
- charge three is the one surviving geometric route to an odd lift.

If the \(M_9\) Hecke gate closes, it belongs as the final theorem of a
rearchitected flagship Paper V: sparse reconstruction selects the marked
family, the marking rigidifies the primitive minimal class, and the odd/even
Abel--Jacobi pair reconstructs the integral universal cubic motive.  If it
does not close, Paper V should retain the recognition theorem and the
boundary/minimal-class upgrade, while this parity theorem and the exact
obstruction become the opening of a sequel.

## 7. Literature audit

### Full text read

- Ze Xu, *A remark on the Abel--Jacobi morphism for the cubic threefold*,
  C. R. Math. 351 (2013), 63--67, DOI
  `10.1016/j.crma.2012.12.002`.  Read: complete five-page paper, especially
  Theorems 2.1--2.3.  Cache SHA-256
  `a3da147d0004942fd72faa1827f02fa2684108295530808aa9ab5f949ca851e1`.

- Claire Voisin, *Unirational threefolds with no universal codimension 2
  cycle*, Invent. Math. 201 (2015), 207--237, arXiv:1312.2122.  Read:
  introduction through Remark 0.8 and the cited universal-cycle boundary;
  source then searched completely for Xu/universal-cycle occurrences.  Cache
  SHA-256
  `f203f393c6da6c5705392b0123687c33f7c42edf8c7e48768b4bcf790d3481f0`.

### Claim-specific partial reads

- D. Markushevich and A. Tikhomirov, *The Abel--Jacobi map of a moduli
  component of vector bundles on the cubic threefold*, arXiv:math/9809140.
  Read: introduction, relative Serre construction, Lemmas 5.1--5.3 and the
  projective-fibre theorem.  Cache SHA-256
  `04242e32b3e8950e310826ce68e903f522c7dd01559bbf2adbc7d01f9de546aa`.

- A. Iliev and D. Markushevich, *The Abel--Jacobi map for a cubic threefold
  and periods of Fano threefolds of degree 14*, arXiv:math/9910058.  Read:
  Theorem 3.2, Corollary 3.3, Lemma 3.4, its proof, and the relative
  irreducibility passage.  Cache SHA-256
  `bd141b86f38ba1b90e5f3a91f963125d897da147ea3ec4c3c041cf0251ce1405`.

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:1005.5621.  Read: Theorem 2.1 and its full proof
  spine through the construction of \(M_9\), plus Theorem 2.11.  Cache
  SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

- Claire Voisin, *Cycle classes on abelian varieties and the geometry of the
  Abel--Jacobi map*, arXiv:2212.03046.  Read: complete Sections 3.1--3.3 and
  the Brauer--Severi obstruction discussion.  Cache SHA-256
  `f61faf4c9b4e9a75ab8a99c749c04df93d858ca29a7057b895ecf56c87c83b43`.

### Search boundary

Targeted searches covered the exact Xu title, universal sheaves/fine moduli
for charge-two cubic instantons, the printed \(M_9\) invariants, charge-three
cubic instantons, and the degree-six Abel--Jacobi map.  No later primary
source was located that computes the generic index of \(M_9\to J\), gives a
common-line odd Hecke multisection, or repairs Xu's charge-two argument.
This is a bounded search statement, not a global novelty claim.

## 8. Reproducibility

Primary replay:

```text
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-abel-jacobi-parity-gate.sage
```

Independent replay:

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-abel-jacobi-parity-replay.py
```

The primary certificate reconstructs the principal lattice and full integral
Neron--Severi lattice, proves rank 50 and saturation index one, and computes
the pairing ideal.  The independent Fraction/SymPy replay imports only the
previously committed principal/NS constants, reconstructs all 680 products,
checks rank 50 modulo five independent primes, and recomputes the pairing
gcd.  The full Smith computation was not duplicated in SymPy because its
680-by-210 dense implementation exceeded the machine's memory; the
independent replay therefore checks the inputs and rank/parity flank while
Sage carries the exact saturation proof.

| artifact | SHA-256 |
|---|---|
| `2026-08-10-c904-abel-jacobi-parity-gate.sage` | `70ab2f880828d7b68b958ee9e43a6d5c1a18f03689e72b1b5d5b3c0df36025ac` |
| `2026-08-10-c904-abel-jacobi-parity-gate.out` | `9a441172ecb519b8a42f86f4dac042b9c798a4341c7841f9bdde81bc3c40b7f8` |
| `2026-08-10-c904-abel-jacobi-parity-replay.py` | `7c938f1ac92698554cd5037a7343d0af010bb1aa6e051d42f0ae242b4f4bb95b` |
| `2026-08-10-c904-abel-jacobi-parity-replay.out` | `7fb981905571cd0f977f7109c371b79e3df01d887cada4a1303f748b9911a656` |

## 9. EJ + TT closeout

### EJ

The clean theorem is not ``the quintic gerbe is annoying.''  It is the
uniform charge-parity law

\[
  \text{determinant-weight ideal}=\gcd(2,n)\mathbf Z.
\]

It explains in one line why charge two repeatedly produces the Fano/Prym
factor two and why charge three is the unique adjacent escape.

### TT

The strongest attempted shortcut was the theta-pair construction: two
degree-three transfers times an odd addition multisection.  Exact saturation
reverses it.  Every divisor-generated addition cut has even degree.  The
failure is not a poor choice of basis or three divisors; it is the image ideal
of the full saturated rank-50 lattice.

### Overconstraint

Three independent parity detectors now agree:

1. charge-two determinant weights generate \(2\mathbf Z\);
2. the common-line pencil has index at most two and no forced odd point;
3. the full relative-NS theta-cut lattice pairs with \(\Theta^2\) in
   \(2\mathbf Z\).

The odd degree in charge three is therefore not cosmetic.  It is the only
nearby place where the parity obstruction actually disappears.

## 10. Mystery ledger

- **Does the charge-two gerbe vanish on the special marked \(A_5\) family?**
  Open.  The determinant lattice and common-line pencil show that the only
  possibilities are split or exact order two; they do not distinguish them.
- **Does a nontrivial gerbe preclude the desired universal zero-cycle?**
  No.  Voisin explicitly warns that a Brauer--Severi fibration may admit a
  universal zero-cycle without splitting.
- **Does charge three close the relative identity?**  Open and now sharply
  localized to an odd cycle/multisection on the fourfold fibre of
  \(M_9\to J\).
- **Can twisted-cubic theta geometry close it using only relative divisors?**
  No: the exact pairing ideal is \(2\mathbf Z\).
- **Could a non-divisor codimension-three class or common-line Hecke cycle be
  odd?**  Open.  These are the two surviving concrete flanks.
