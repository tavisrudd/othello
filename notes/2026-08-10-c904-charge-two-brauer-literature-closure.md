# C904 charge-two Brauer / charge-three index literature closure

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: universal and quasi-universal charge-two sheaves on a cubic
threefold, the moduli-gerbe class, its relation to the Druel--Beauville
compactification, and later work on the charge-three (M_9\to J) fibre

## Executive verdict

This audit used **two primary sources read in full and nine primary
sources read claim-specifically at partial depth**.  The classical literature
does not state that the charge-two moduli-gerbe class is nonzero, calculate
its boundary residue, or identify the index of Voisin's charge-three generic
fourfold.  It supplies all ingredients for, but does not print, the residue
calculation in
`2026-08-10-c904-charge-two-brauer-residue.md`.

The exact state is now:

1. Markushevich--Tikhomirov construct a Poincare bundle only after an etale
   base change.  Their elliptic-quintic map is therefore printed as an
   etale-locally trivial \(\mathbf P^5\)-fibration, not as the projectivization
   of a global rank-six bundle.
2. Druel's ``universal family'' is the tautological quotient on the Quot
   parameter scheme.  His passage to the coarse GIT quotient does not descend
   it.
3. Xu's later theorem claiming that the stable charge-two moduli space is
   fine is incorrect.  The omitted top term
   \(h^3/6=\tfrac12[\mathrm{pt}]\) in
   \(\operatorname{ch}(\mathcal O_X(1))\) changes his Euler value from five
   to six.  Voisin explicitly records this correction.
4. Numerically
   \[
      [E_2]=2([\mathcal O_X]-[\mathcal O_\ell]),
   \]
   so the determinant-weight ideal is \(2\mathbf Z\).  Thus the standard
   determinant construction never produces a weight-one line.  It yields a
   quasi-universal family of similitude two, but by itself does not prove that
   the obstruction is nonzero.
5. The new Luna-slice computation closes that last gap.  At the generic
   divisor \(D=F+F\), its residue is the nontrivial ordering cover
   \(F\times F\to\operatorname{Sym}^2F\).  Hence the generic moduli-gerbe
   class has exact period and index two.  This appears **unpre-empted in the
   bounded audit** below.
6. The compactification does not contradict this.  If
   \(\overline M_2\cong\operatorname{Bl}_FJ\), then standard birational
   invariance gives
   \[
      \operatorname{Br}(\overline M_2)\cong\operatorname{Br}(J)
      \cong(\mathbf Q/\mathbf Z)^{45-\rho(J)}.
   \]
   The charge-two class lives instead on
   \(M_2=J\setminus(F+F)\) and has nonzero residue along the omitted divisor,
   so it does **not** extend to either \(J\) or \(\overline M_2\).  Computing
   the proper Brauer group therefore cannot decide this class.
7. Odd charge removes the ambient gerbe: for
   \(v_3=2[\mathcal O_X]-3[\mathcal O_\ell]\), the Euler weight against
   \(\mathcal O_X\) is \(-1\), so the Huybrechts--Lehn criterion gives a
   universal family on the stable charge-three moduli space.  Nevertheless,
   the charge-two Hecke boundary remains a nonsplit conic of index two.
8. No located later source computes the index, rationality, or stable
   rationality of the geometrically rationally connected four-dimensional
   generic fibre of Voisin's \(M_9\dashrightarrow J\).  The exact open gate is
   an odd intrinsic carrier in \(M_9\), not another charge-two elementary
   modification.

## Classical source boundary

### Markushevich--Tikhomirov

Lemma 5.3 starts with Simpson's etale-local Poincare family
\(\mathcal E\) on \(X\times T\), puts
\(\mathcal G=p_*(\mathcal E(1))\), and identifies the pulled-back Hilbert
family with \(\mathbf P(\mathcal G)\).  Corollary 5.4 concludes only that the
map is smooth projective with \(\mathbf P^5\) fibres and is etale-locally
\(\mathbf P^5\times U\).  It does not assert a global Poincare family, a
global rank-six vector bundle, or triviality of the associated Brauer class.

### Druel and Beauville

Druel's Theorem 4.8 identifies the coarse semistable moduli space with a
blow-up of the intermediate Jacobian.  In its proof, the universal family is
explicitly on \(Q_c^{ss}\times X\), before taking the GIT quotient.
Theorem 4.6 gives the local slice at
\(I_{\ell_1}\oplus I_{\ell_2}\); Lemma 4.3 gives one-dimensional cross-Ext
spaces.  These statements determine the local weights but Druel does not
form their Brauer residue.

Beauville's Theorem 6.3 and Corollary 6.4 give
\[
 \overline M_2\cong\operatorname{Bl}_{F_2}J_2(X),\qquad
 M_2\cong J_2(X)\setminus(F+F).
\]
Remark 6.5 proves that \(\operatorname{Sym}^2F\to F+F\) is generically
one-to-one.  Again, this is coarse geometry and contains no fineness or
Brauer-class assertion.

### Xu and Voisin's correction

Xu's Theorem 2.3 invokes Huybrechts--Lehn after computing
\(\chi(c,E)=-4\) and \(\chi(c,\mathcal O_X(1))=5\).  His displayed Chern
character stops before the degree-three term.  The correct character is
\[
 \operatorname{ch}(\mathcal O_X(1))
   =1+h+\tfrac32[\ell]+\tfrac12[\mathrm{pt}],
\]
and the correct second Euler value is six.  Voisin's Remark 0.8 says
explicitly that Xu's proof is incorrect because of this missing term.

Voisin's 2022 paper still poses existence of a universal codimension-two
cycle on a smooth cubic threefold as Question 1.13.  Proposition 1.14 relates
it to a universal zero-cycle on a smooth projective model of the
elliptic-quintic Hilbert family.  Her Remark 1.6 also warns that a
Brauer--Severi fibration can admit such a universal zero-cycle without its
Brauer class vanishing.  Thus nonvanishing of the charge-two gerbe does not
settle the universal-cycle problem or the intrinsic \(M_9\) index.

## Exact interpretation of universal and quasi-universal

On the stable locally free moduli stack, the tautological sheaf is an
\(\alpha\)-twisted rank-two sheaf.  Restriction at a fixed point of \(X\)
gives another \(\alpha\)-twisted rank-two vector bundle.  Tensoring the first
with the dual of the second descends to the coarse moduli space and has fibre
\(E^{\oplus2}\).  Hence a quasi-universal family of similitude two exists.

The generic obstruction vanishes exactly when a genuine universal family
exists.  The nonzero ordering-cover residue now proves that it does not
vanish and that similitude two is minimal.  Two related conics should not be
conflated:

- \(\mathbf P\operatorname{Hom}(E,\mathcal O_m)\) is the elementary-Hecke
  quotient conic;
- \(\mathbf P H^0(E(1)\otimes I_m)\) is the fixed-line elliptic-quintic
  pencil (the vertex of the rank-four determinant quadric).

Both are projectivizations of rank-two twisted vector spaces and represent
the same order-two class, but they are not the same geometric construction.

## Charge-three closure

Voisin constructs a nine-dimensional moduli component \(M_9\) from elliptic
sextics and a dominant rational Abel--Jacobi map
\(M_9\dashrightarrow J(X)\).  Her theorem implies that its geometric generic
fibre is a rationally connected fourfold.  Faenzi's charge-two-to-charge-three
line modification is a divisor in a smooth nine-dimensional instanton
component, and later work of Comaschi--Jardim generalizes this
elementary-transformation mechanism.  Those works do not compute the
Abel--Jacobi image or generic-fibre index of that divisor.

The bounded forward-citation and keyword closure already recorded in
`2026-08-10-c904-charge-three-instanton-literature-closure.md` found no later
paper calculating the birational type, stable rationality, or index of
Voisin's fourfold.  The new exact charge-two residue strengthens the negative
gate: the inherited Hecke conic has index two.  It does not prove that the
ambient fourfold has index two, because a variety can contain a nonsplit
conic and still possess an odd zero-cycle elsewhere.

### The surviving \(D_{3,3}\) route

Voisin's proof exhibits one carrier which does not pass through charge two.
Her locus \(D_{3,3}\) of unions of two rational cubics dominates \(M_9\) and
maps to \(\operatorname{Sym}^2\Theta\).  Over the two component
Abel--Jacobi values, its fibre is birational to
\(\operatorname{Sym}^2E_3\), where \(E_3\) is the plane cubic cut out by the
two cubic surfaces.  Consequently this relative fibre has index dividing
three: after a degree-three splitting field for the plane cubic,
\(\operatorname{Sym}^2E_3\) has a point.  The rational-cubic
\(\mathbf P^2\) transfers are likewise at worst three-primary.

Thus the only two-primary gate in this architecture is the generic
threefold fibre of
\[
             \operatorname{Sym}^2\Theta\longrightarrow J,
             \qquad \{a,b\}\longmapsto a+b.
\]
The existing theorem that all *ordered* theta cuts on
\(\Theta\times\Theta\) have even degree does not settle this quotient: a
swap-invariant ordered degree-two carrier could descend to degree one.
The exact next computation is the degree gcd on the integral **descent
lattice** from \(\operatorname{Sym}^2\Theta\), including the diagonal
parity, rather than on the full invariant lattice upstairs.  A gcd of four
upstairs closes \(D_{3,3}\) as even; a descended degree-two class produces
the desired odd carrier after the only-three-primary elliptic and
\(\mathbf P^2\) transfers.

## Read depths

- **Partial:** Stephane Druel, *Espace des modules des faisceaux de rang 2
  semi-stables...*, arXiv:`math/0002058`; Lemma 4.3, Theorems 4.6 and 4.8.
  Cache SHA-256
  `f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654`.

- **Partial:** Arnaud Beauville, *Vector bundles on the cubic threefold*,
  arXiv:`math/0005017`; Sections 5--6, especially Theorem 6.3, Corollary 6.4,
  Remark 6.5.  Cache SHA-256
  `18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f`.

- **Partial:** Dimitri Markushevich and Alexander Tikhomirov, *The
  Abel--Jacobi map of a moduli component of vector bundles on the cubic
  threefold*, arXiv:`math/9809140`; Section 5, Lemma 5.3 and Corollary 5.4.
  Cache SHA-256
  `04242e32b3e8950e310826ce68e903f522c7dd01559bbf2adbc7d01f9de546aa`.

- **Full text:** Ze Xu, *A remark on the Abel--Jacobi morphism for the cubic
  threefold*, arXiv:`1212.6790`, four-page preprint.  Cache SHA-256
  `932444f65a035d16ebba10388239a06eaaa650350c9c9b7f3999bd58d8cfa235`.

- **Partial:** Claire Voisin, *Unirational threefolds with no universal
  codimension 2 cycle*, arXiv:`1312.2122`; introduction through Remark 0.8.
  Cache SHA-256
  `f203f393c6da6c5705392b0123687c33f7c42edf8c7e48768b4bcf790d3481f0`.

- **Partial:** Claire Voisin, *Cycle classes on abelian varieties and the
  geometry of the Abel--Jacobi map*, arXiv:`2212.03046`; introduction,
  Proposition 1.14 and its proof.  Cache SHA-256
  `f61faf4c9b4e9a75ab8a99c749c04df93d858ca29a7057b895ecf56c87c83b43`.

- **Partial:** Claire Voisin, *Abel--Jacobi map, integral Hodge classes and
  decomposition of the diagonal*, arXiv:`1005.5621`; Theorem 2.1 and the
  construction of \(M_9\).  Cache SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

- **Partial:** Daniele Faenzi, *Even and odd instanton bundles on Fano
  threefolds of Picard number one*, arXiv:`1109.3858`; Theorem 3.1,
  Steps 2--3.  Cache SHA-256
  `0024a632f2ca141eb4f3c09c43c65a3464646fd72fd951417abb2a3a9db90e8f`.

- **Full text:** Kalyan Banerjee, *Universal codimension two cycle on a very
  general cubic threefold*, arXiv:`2509.06013v1`, 12-page preprint.  Cache
  SHA-256
  `24d992d6eb0d8b0e0a6bbb6a531a87a7c24e866e2eb55cf0238173b8d7d753ca`.
  It claims nonexistence for the very general cubic, but is an unrefereed
  preprint and its argument does not provide a safe published input for the
  charge-two gerbe or \(M_9\) index.

- **Partial:** Philip Engel, Olivier de Gaay Fortman and Stefan Schreieder,
  *Matroids and the integral Hodge conjecture for abelian varieties*,
  arXiv:`2507.15704v3`; introduction and Theorem 1.3/Corollaries 1.4--1.5.
  Cache SHA-256
  `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee`.
  Their even-minimal-class theorem proves stable irrationality of the very
  general cubic, not nonexistence of a universal cycle or nonvanishing of the
  charge-two moduli gerbe.

- **Partial:** Daniel Huybrechts and Manfred Lehn, *The Geometry of Moduli
  Spaces of Sheaves*, second edition; Section 4.6 through Theorem 4.6.5,
  read from an online PDF.  The PDF was not added to the shared cache.

## Forward-citation and search boundary

The new residue calculation depends on an absence-of-prior-work verdict.
Three independent graphs were therefore checked for the two closest pinned
seeds.

| Seed | Crossref | OpenAlex | Semantic Scholar | Largest screened |
|---|---:|---:|---:|---:|
| Xu, DOI `10.1016/j.crma.2012.12.002` | 1 | 2 | 2 | Semantic Scholar, 2 |
| Druel, DOI `10.1155/S1073792800000519` | 32 | 57 | 48 | OpenAlex, 57 |
| Beauville, DOI `10.1090/conm/312/04987` | 23 | 49 | 58 | Semantic Scholar, 58 |

The Xu set consisted of Voisin's correction paper and *Lines, conics, and
all that*.  The 57 Druel and 58 Beauville records were screened over title,
abstract, year and external identifiers with the discriminator

```text
Brauer|universal sheaf|fine moduli|quasi-universal|gerbe|
elliptic quintic|cubic threefold|Pfaffian|matrix factori
```

Promoted hits were the Xu paper, the ACM/Pfaffian papers, the later
skew-matrix compactification papers, and the universal-cycle papers.  None
states the ordering-cover residue, proves the charge-two gerbe nonzero, or
computes the charge-three generic-fibre index.  Successful HTTP responses,
returned array lengths, and the service-reported totals distinguished empty
sets from request failures.

Additional exact searches run on 2026-08-10 were:

```text
"F+F" cubic threefold Brauer class moduli sheaves
"Sym^2 F" Brauer cubic threefold instanton
Druel Brauer cubic threefold moduli sheaves
elliptic quintics Brauer-Severi cubic threefold
"M_9" cubic threefold Voisin
"c_2=3" instanton cubic threefold Abel-Jacobi
charge three instanton cubic threefold
elliptic sextics cubic threefold Abel-Jacobi fibre
```

No explicit predecessor was located.  MathSciNet and Google Scholar were not
covered; the published versions were not all separately read.  The correct
claim remains the bounded one: **no predecessor was located in this audit**.

## Remaining mathematical gate

The exact charge-two class is closed: it is nonzero, ramified, and of generic
period/index two, including after the marked-family base change.  The
charge-three target is fine, but its fourfold fibre may still have index one
or two.  To decide it one needs either:

1. an intrinsic odd multisection/zero-cycle in \(M_9\), avoiding the inherited
   one-line Hecke carrier; or
2. a new obstruction showing that every zero-cycle on a proper generic model
   has even degree.

No located primary source supplies either result.
