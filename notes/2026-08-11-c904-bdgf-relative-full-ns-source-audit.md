# C904 BdGF relative and full-NS source audit

Date: 2026-08-11

## Verdict

The canonical Beckmann--de Gaay Fortman cycle is dead for the proposed
theta-resolution shortcut.  Its class is the pure Kunneth component

\[
\frac{p^3}{3!}\in H^3(J)\otimes H^3(J),
\]

and the exact anti-graph calculation gives quotient degree \(-80\), hence
even.  It neither is nor contains the desired \((1,5)+(5,1)\) block.  This is
a different failure from the older Fano-surface contraction, whose scalar is
four.

There is nevertheless a strong source-backed upgrade.  For the special
fivefold \(J\) in C904, an integral minimal curve on \(J\) forces an
intersection divided-power structure on ordinary Chow modulo torsion.  The
same is true on \(B=J\times J\).  Consequently every divisor cube
\(D^3/3!\) on \(B\), including cubes of graph/Poincare divisors, has an
ordinary integral Chow lift modulo torsion.  This supplies the algebraicity
input for the live full-Neron--Severi search.  It does **not** compute the
integral lattice of the \((1,5)+(5,1)\) components, isolate an odd projector,
or prove integral descent to \(\operatorname{Sym}^2 M\).

The closest later result is Kahn's 2026 construction of canonical divided
powers and explicit mixed theta--Poincare Chow--Kunneth projectors in etale
Chow modulo two-torsion.  Kahn explicitly asks whether the corresponding
projectors are integral already in ordinary Chow, even for Jacobians.  Thus
the exact ordinary-Chow full-NS lattice and odd theta-descent gate is not
pre-empted by that work.

## 1. What BdGF gives over the generic field

Let \((J,\Theta)/K\) be the generic marked C904 intermediate Jacobian, where
\(K=\mathbf C(S)\), and suppose the horizontal minimal cycle gives

\[
c=\frac{\Theta^4}{4!}\in \operatorname{CH}^4(J)_{\mathbf Q}
\]

an integral lift.  Beckmann--de Gaay Fortman Theorem 3.8 is stated for an
abelian variety over an arbitrary field.  Its conditions (5) and (8) imply
that the ideal

\[
\operatorname{CH}^{>0}(J)/\text{torsion}
\]

has divided powers for intersection product.  In particular, for every
divisor class \(d\), the rational class \(d^r/r!\) has an integral ordinary
Chow representative modulo torsion.

The product \(B=J\times J\), with product principal polarization
\(x+y\), also has an integral minimal curve.  Indeed,

\[
\frac{(x+y)^9}{9!}
=\frac{x^4}{4!}\frac{y^5}{5!}
 +\frac{x^5}{5!}\frac{y^4}{4!},
\]

and the intersection PD structure on \(J\) gives integral lifts of
\(x^5/5!\) and \(y^5/5!\), which are degree-one zero-cycle classes.  No
equality with the origin is needed in rational Chow.  This is the
ordinary-Chow generic-field version of the cohomological product stability
stated immediately after BdGF Theorem 1.1.  Applying Theorem 3.8 to \(B/K\)
proves:

> For every \(D\in\operatorname{CH}^1(B)\), the class \(D^3/3!\) admits an
> ordinary integral Chow lift modulo torsion.

This is an existence statement.  The transported intersection PD structure
need not be canonical, and BdGF do not claim its functoriality under every
endomorphism of \(B\).

The PD addition law also gives integral lifts of the symmetric mixed halves

\[
\gamma_3(a+b)-\gamma_3(a)-\gamma_3(b)
=\frac{a^2b+ab^2}{2}
\quad\text{in rational Chow}.
\]

More directly for the live channel, \(x^2/2\) and \(y^2/2\) have integral
lifts, so multiplication by any graph/Poincare divisor \(p_T\) gives
integral lifts of

\[
\frac{x^2p_T}{2}\in H^5(J)\otimes H^1(J),
\qquad
\frac{p_Ty^2}{2}\in H^1(J)\otimes H^5(J).
\]

Thus algebraicity of these pure mixed channels is not the remaining issue.
The remaining issue is their exact integral coefficient lattice and action
after pullback to \(M=\operatorname{Bl}_0\Theta\).

## 2. Relative, swap, and inversion scope

The safe relative procedure is generic-fibre first:

1. apply BdGF Theorem 3.8 over \(K\);
2. choose the finitely many required ordinary Chow representatives;
3. spread those representatives after shrinking the smooth base.

Neither BdGF nor Moonen--Polishchuk prints a general, canonical, integral
intersection-PD structure for an abelian scheme over an arbitrary base.
Kahn Theorem 1.10 supplies a relative etale-Chow construction only after
inverting \(M!p\).  In characteristic zero this still inverts two and cannot
settle the parity gate.

For the original BdGF class the symmetry is exact.  If \(Z\) is a minimal
cycle and

\[
\tau=j_{1*}Z+j_{2*}Z-\Delta_*Z,
\]

then factor swap fixes \(\tau\), and Moonen--Polishchuk functoriality of
Pontryagin divided powers fixes \(\tau^{[7]}\) in Chow.  Simultaneous
inversion also fixes it when \([-1]_*Z=Z\) in Chow; that hypothesis holds for
the C904 minimal cycle because it is built from symmetric line bundles.  All
these symmetries survive pullback along \(M\times M\to J\times J\).

For a general BdGF intersection divided-power lift, exact swap invariance is
not automatic from invariance of its cohomology class.  A useful special case
avoids this ambiguity: choose a lift \(u\) of \(x^2/2\), define its second
factor mate by swap, and use a Rosati-self-adjoint graph divisor \(p_T\).
Then

\[
p_T\bigl(u+\sigma^*u\bigr)
\]

is an exact ordinary-Chow swap-invariant lift of
\(p_T(x^2+y^2)/2\).  Whether it has odd anti-graph degree, and whether it
descends integrally rather than only after pushforward by two, is a finite
lattice/intersection question not answered by the sources.

## 3. Why the canonical Poincare cube is dead

BdGF Lemma 3.5 and Theorem 3.8, using the Moonen--Polishchuk Pontryagin
divided powers, turn a minimal cycle into an integral cycle with class
\(p^3/3!\).  That class is pure \((3,3)\).  Pullback to \(M^2\) therefore
acts from \(H^5(M)\) to \(H^3(M)\); it cannot be the desired
\(H^3(M)\to H^1(M)\) inverse-Lefschetz block.

The exact theta-resolution anti-graph normalization is

\[
j^*\frac{p^3}{3!}=-8\frac{h^3}{3!},
\qquad \int_M h^4=120.
\]

Hence a hypothetical quotient half has degree

\[
-4\frac{120}{6}=-80,
\]

while the automatic integral pushforward has degree \(-160\).  Both are
even.  This closes the BdGF symmetric-theta shortcut independently of any
integral-descent ambiguity.

The older Fano calculation contracts the same Poincare cube after restriction
to \(F\times F\) and obtains scalar four on \(H^1\).  That scalar-four failure
must not be used as the normalization of the theta-resolution calculation:
the latter fails already by Kunneth channel and has exact degree \(-80\).

## 4. Closest prior art for the full-NS gate

Kahn Theorem 1.2 constructs canonical intersection divided powers in etale
Chow modulo two-torsion over a separably closed field and proves pullback
functoriality for homomorphisms of abelian varieties.  Proposition 11.6 then
prints explicit mixed correspondences whose self-compositions are
self-conjugate Deninger--Murre projectors for a principally polarized abelian
variety.  The displayed correspondences are sums of products

\[
\gamma_a(\pi_1^*\Theta)\,
\gamma_b(p)\,
\gamma_c(\pi_2^*\Theta).
\]

This is the precise existing precedent for mixed theta--Poincare projector
polynomials.  It is not an ordinary-Chow result: the target is etale Chow
modulo two-torsion.  Kahn Question B.8 asks whether the corresponding
projectors are integral in ordinary Chow even for Jacobians.  Question B.3
also leaves compatibility between the geometric ordinary-Chow Pontryagin
divided powers and the etale divided powers open.

Kahn therefore gives two useful boundaries:

- mixed divisor-product projector formulas are classical rationally and now
  canonical etale-integrally modulo two-torsion;
- lifting the needed mixed projector to ordinary Chow with exact two-primary
  control remains open in the stated generality.

The 2025--26 Engel--de Gaay Fortman--Schreieder results show that divided
minimal classes fail to be algebraic on very general ppav's and on a very
general cubic-threefold intermediate Jacobian.  They do not obstruct this
special C904 Jacobian, where an explicit algebraic minimal class is part of
the input.  They do rule out presenting the full-NS mechanism as a theorem
for arbitrary ppav's.

## 5. Exact priority boundary

Pre-empted:

- producing \(p^3/3!\) integrally from an algebraic minimal class;
- algebraicity, on this special \(J\) and \(J^2\), of divisor divided powers
  such as \(D^3/3!\);
- rational mixed theta--Poincare Chow--Kunneth formulas;
- canonical etale-Chow versions modulo two-torsion.

Not found in the bounded primary-source audit:

- the ordinary integral lattice generated by the mixed classes
  \(x^2p_T/2\) and \(p_Ty^2/2\) for the full endomorphism order of this
  \(A_5\)-special \(J\);
- an ordinary integral mixed divisor-product correspondence whose pullback
  to \(M^2\) realizes the primitive \((1,5)+(5,1)\) block with odd trace;
- exact swap descent of such a class to \(\operatorname{Sym}^2M\) with odd
  anti-graph degree.

The strongest defensible new theorem target is therefore not an integral
Fourier-transform theorem.  It is a special finite-lattice theorem:

> On the marked \(A_5\) intermediate Jacobian, the full graph-divisor
> divided-cube lattice contains (or does not contain) an exact
> swap-invariant ordinary algebraic representative of the primitive
> \((1,5)+(5,1)\) inverse-Lefschetz block; in the positive case its pullback
> to the theta resolution has odd anti-graph degree.

An existence proof must print the divisor combination, its integral Chow
construction, its action matrix, and its descent normalization.  A negative
result should compute the saturation index of this full-NS lattice.  Either
would be genuinely new relative to the sources checked here.

## 6. Source ledger and bounded search

Primary sources consulted:

1. Thorsten Beckmann and Olivier de Gaay Fortman, *Integral Fourier
   transforms and the integral Hodge conjecture for one-cycles on abelian
   varieties*, Compositio Math. 159 (2023), arXiv:2202.05230.  Read depth:
   partial, Theorem 1.1, Lemma 3.5, Theorems 3.7--3.8, Proposition 3.11 and
   proofs.  Cached text SHA-256
   `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`.
2. Ben Moonen and Alexander Polishchuk, *Divided powers in Chow rings and
   integral Fourier transforms*, Adv. Math. 224 (2010), arXiv:0904.3995.
   Read depth: partial, introduction, Proposition 1.5, Theorem 1.6 and
   Corollary 1.7.  Cached text SHA-256
   `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4`.
3. Bruno Kahn, *Divided powers on abelian varieties*, arXiv:2602.11135v2.
   Read depth: partial, introduction, Theorems 1.2 and 1.10, Proposition
   11.6, Questions B.3 and B.8.  Consulted the primary arXiv HTML on
   2026-08-11.
4. Philip Engel, Olivier de Gaay Fortman and Stefan Schreieder, *Matroids
   and the integral Hodge conjecture for abelian varieties*,
   arXiv:2507.15704v3.  Read depth: abstract and stated main result only.
5. Philip Engel, Olivier de Gaay Fortman and Stefan Schreieder, *Optimality
   of the Prym--Tyurin construction for A_6*, arXiv:2512.04902v1.  Read
   depth: abstract and stated main result only.

Direct searches, recorded verbatim:

- `integral Lefschetz algebra abelian varieties divided powers divisor cubes Poincare bundle`
- `Neron Severi lattice divided powers Chow ring abelian variety Fourier transform integral`
- `graph correspondences Poincare divisor cube inverse Lefschetz abelian variety integral`
- `abelian variety mixed Poincare bundle divided powers Chow projector`
- `abelian variety Scholl's formula Poincare divisor theta projector integral`
- `integral Fourier transform Poincare bundle Chow abelian`

The bounded search covered arXiv primary records and the forward source Kahn
2026.  It did not cover MathSciNet or a complete citation-graph export.  The
negative statements above are correspondingly bounded; no global absence
claim is made.

## 7. EJ/TT closeout and mystery ledger

- **Settled negatively:** the canonical BdGF \(p^3/3!\) route is pure
  \((3,3)\), has exact quotient degree \(-80\), and cannot be the p15
  projector.
- **Settled positively:** BdGF supplies ordinary algebraicity modulo torsion
  for every full-NS divisor cube on this special \(J^2\); algebraicity of the
  candidate mixed channels is not itself a blocker.
- **Surprise:** Kahn's 2026 explicit mixed theta--Poincare projector formula
  reaches exactly the relevant shape, but only in etale Chow modulo
  two-torsion; his Question B.8 marks ordinary integrality as open even for
  Jacobians.
- **Live mystery:** whether graph-divisor mixed halves span an odd primitive
  p15 operator on this special endomorphism lattice.  Exact evidence gap:
  the finite integral action/saturation calculation.
- **Live mystery:** whether an exact swap-invariant ordinary lift descends
  without the automatic factor two.  Exact evidence gap: a quotient-Chow
  descent computation, even after an odd cohomological action is found.

**Vibe:** the universal shortcut is dead, but the source audit substantially
improves the live route: full-NS mixed candidates are already known to be
ordinary algebraic on this special product.  The crown now rests on a sharp,
finite two-primary lattice and descent calculation rather than on a new
general Fourier theorem.
