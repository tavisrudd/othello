# C705 — ordered-sheet computation and the Lie-\(E_8\) mechanism

## Verdict

The residual C705 package is complete.

- Intrinsically, a Vinberg trivector marks only one Weierstrass point, so
  it cannot canonically recover C704's ordering of all six; the exact
  obstruction is the residual \(S_5\)-torsor.
- After adding the minimal missing level-\(2\) marking, the sheetwise
  comparison exists and is now computed on all \(720\) sheets.
- The apparent Lie-group gap is closed by the order-three Vinberg grading
  of \(E_8\) together with the Rains--Sam inverse-orbit theorem.  The
  trivector, its Pfaffian Coble cubic, the frozen genus-two curve, and the
  Segre--Igusa fixed section belong to one reconstructed
  \(\operatorname{PGL}_9\)-orbit.

The distinction matters: the *ordered* equality requires a choice, but
the underlying Lie-\(E_8\)/Coble/Segre--Igusa mechanism does not remain
conjectural.

## Computation first

### Characteristic-zero marked form

The preceding exact certificate starts with the frozen Burkhardt point
\[
 \alpha=(6:17:1:-7:-19)
\]
and its primitive branch sextic \(f_\alpha\).  It proves
\(\operatorname{Gal}(f_\alpha/\mathbf Q)=S_6\).  For a root \(r\), put
\[
 K=\mathbf Q[r]/(f_\alpha(r)),\qquad D=f_\alpha'(r).
\]
The change
\[
 t=-D/(x-r),\qquad X=yt^3/D
\]
gives the Rains--Sam normal form
\[
 X^2+t^5+c_6t^4+c_{12}t^3+c_{18}t^2+c_{24}t+c_{30}=0
\]
with
\[
\begin{aligned}
c_6&=-f_\alpha''(r)/2,&
c_{12}&=Df_\alpha'''(r)/6,\\
c_{18}&=-D^2f_\alpha^{(4)}(r)/24,&
c_{24}&=D^3f_\alpha^{(5)}(r)/120,\\
c_{30}&=-D^4f_\alpha^{(6)}(r)/720.
\end{aligned}
\]
This yields an explicit stable \(\gamma_r\in\Lambda^3K^9\).  No auxiliary
square root is needed.

### Completely split exact fiber

The good prime \(p=1447\) splits \(f_\alpha\) completely:
\[
 (r_1,\ldots,r_6)=(449,773,775,878,1238,1321).
\]
The new certificate performs the following exact finite-field calculation.

1. It evaluates C704's frozen six Joubert cubics on every one of the
   \(6!=720\) orderings of these roots after centering.
2. The \(720\) ordered Joubert vectors are all distinct.
3. Every vector satisfies
   \[
   \sum_TZ_T=0,\qquad \sum_TZ_T^3=0.
   \]
4. For
   \[
   W_T=6Z_T^2-\sum_UZ_U^2,
   \]
   every sheet satisfies
   \[
   \sum_TW_T=0,\qquad
   \left(\sum_TW_T^2\right)^2=4\sum_TW_T^4.
   \]
5. For each of the six choices of marked root \(r_i\), the derivative
   formulas construct \(\gamma_{r_i}\), and the five finite roots of its
   marked quintic are exactly
   \[
   -f_\alpha'(r_i)/(r_j-r_i),\qquad j\ne i.
   \]
   Thus the one-point Vinberg marking and the full ordered level-\(2\)
   marking are connected on every sheet, not merely counted abstractly.
6. For \(\gamma_{r_1}\), contraction gives a \(9\times9\) alternating
   matrix \(\Phi_\gamma(x)\).  Its nine signed principal \(8\times8\)
   Pfaffians satisfy
   \[
   (-1)^i\operatorname{Pf}\Phi_\gamma(x)_{\widehat i}
   =x_i\,F_\gamma(x)
   \]
   for one cubic \(F_\gamma\).  The certificate records all \(31\) terms
   of this Coble cubic.

The modular calculation is a split-fiber replay of the characteristic-zero
construction, not the sole evidence for it.  The root-to-infinity identity
is already verified coefficientwise in
\(\mathbf Q[r]/(f_\alpha)[t]\), while the Joubert and Segre--Igusa
identities are C704's integral polynomial identities.  The split fiber
checks that all markings, permutations, normalizations, and Pfaffian signs
meet correctly in one explicit example.

## Mechanism second

Let \(V\) have dimension \(9\).  The split Lie algebra of type \(E_8\)
has the order-three Vinberg grading
\[
 \mathfrak e_8
 =
 \mathfrak{sl}(V)\oplus\Lambda^3V\oplus\Lambda^6V.
\]
The fixed group is \(\operatorname{SL}(V)/\mu_3\), and the marked
trivector \(\gamma_r\) lies in the degree-one eigenspace
\(\Lambda^3V\).

Contracting \(\gamma_r\) with \(x\in V^\vee\) produces
\(\Phi_\gamma(x)\in\Lambda^2V\).  The rank-\(\le6\) orbital degeneracy
locus is the cubic \(F_\gamma=0\); its rank-\(\le4\) locus is the
singular abelian surface.  This is the Coble cubic construction.  Thus the
Pfaffian calculation above is literally the passage from the \(E_8\)
degree-one piece to the Coble parent, not an analogy based only on matching
dimensions.

Rains--Sam Theorem 5.5 identifies stable
\(\operatorname{PGL}(V)\)-orbits in
\(\mathbf P(\Lambda^3V)\) with triples
\[
 (C,P,\psi),
\]
where \(C\) is genus two, \(P\) is a marked Weierstrass point, and
\(\psi\) is the relevant \(3\)-covering class.  For the Jacobian Coble
cubic the torsor is trivial, \(\psi=0\).  Proposition 5.4 says that two
stable trivial-class trivectors with isomorphic marked curves are in the
same \(\operatorname{PGL}_9\)-orbit.  Lemma 5.3 makes this constructive:
the nine-dimensional space of alternating forms and the kernels of ten
generic rank-eight members recover the required linear identification up
to one scalar.

Consequently the marked normal-form trivector \(\gamma_r\) and the
trivector underlying the frozen Heisenberg Coble cubic are not merely
moduli-equivalent: they are in the same projective \(9\)-dimensional orbit
over the marked field.  An explicit \(9\times9\) change-of-basis matrix is
a choice of theta basis reconstructed by Lemma 5.3; it is not additional
geometric data and is not needed to identify the orbit.

Finally, the frozen level-\(3\) theta structure supplies Nguyen's
\(\tau^+\) fixed \(\mathbf P^4\).  Restriction of the Coble cubic gives the
Segre cubic, its polar gives the Igusa quartic, and the added ordered
level-\(2\) marking identifies the six coordinates with C704's signed
Joubert tensor.  Differentiating the universal potential
\[
 \mathscr P(x,\eta)=\langle\eta,Z(x)\rangle
\]
recovers C705's matrix \(A=dZ\) and the two null projections \(q,W\);
hence
\[
 \operatorname{adj}(A)=6Wq^{\mathsf T}.
\]

The completed mechanism is therefore
\[
\boxed{
\Lambda^3 9\subset\mathfrak e_8
\longrightarrow
\text{Coble cubic}
\longrightarrow
\tau^+\text{ Segre--Igusa section}
\longrightarrow
(Z,A,q,W).
}
\]
Full ordering is an external level-\(2\) trivialization of this diagram,
and its \(S_6\)-equivariance is exactly what permits the unordered diagram
to descend.

## Human proof

Here is a proof that does not use enumeration of the \(720\) sheets.

**Theorem.**  After adjoining an ordered set of Weierstrass points of the
frozen Burkhardt curve, the frozen Coble/Segre--Igusa operator diagram is
the fixed-section shadow of a stable vector in the degree-one piece
\(\Lambda^3 9\) of the order-three \(E_8\) grading.  Changing the ordering
acts through C704's signed outer \(S_6\)-action.  The unordered diagram
descends to \(\mathbf Q\), but no ordering does.

**Proof.**

1. Let \(r\) be one branch point and \(D=f_\alpha'(r)\).  Taylor's formula
   gives
   \[
   \frac{t^6}{D^2}
   f_\alpha\!\left(r-\frac D t\right)
   =
   -t^5-c_6t^4-c_{12}t^3-c_{18}t^2-c_{24}t-c_{30},
   \]
   with the five derivative formulas displayed above.  This proves
   directly that the root-to-infinity change of variables gives the
   Rains--Sam marked genus-two normal form.  Substitution in Proposition
   2.1 gives \(\gamma_r\in\Lambda^3K^9\).  The curve is smooth, so
   Proposition 2.13 makes \(\gamma_r\) stable.

2. Contract \(\gamma_r\) with the variable covector \(x\).  This gives an
   odd alternating matrix \(\Phi_\gamma(x)\), and alternating contraction
   gives
   \[
   \Phi_\gamma(x)x=0.
   \]
   For any odd alternating matrix, the vector of its signed maximal
   Pfaffians lies in its kernel.  On the dense rank-eight locus the kernel
   here is the line \(Kx\).  Hence
   \[
   (-1)^i\operatorname{Pf}
   \Phi_\gamma(x)_{\widehat i}=x_iF_\gamma(x)
   \]
   for one common polynomial.  The left side has degree four, so
   \(F_\gamma\) is cubic.  Equality on the dense locus is a polynomial
   identity and therefore holds everywhere.  This proves the common-Coble
   Pfaffian assertion without calculating its \(31\) coefficients.

3. Gruson--Sam--Weyman identify \(F_\gamma=0\) as the Coble cubic and its
   rank-four locus as the associated \((3,3)\)-polarized abelian surface.
   Rains--Sam Theorem 5.5 classifies the stable projective trivector orbit
   by \((C,P,\psi)\).  Both the normal-form construction and the Jacobian
   Coble model have the same marked curve \((C_\alpha,r)\) and trivial
   covering class \(\psi=0\).  Proposition 5.4 therefore places them in
   the same \(\operatorname{PGL}_9\)-orbit.  Lemma 5.3 reconstructs a
   representative change of basis from the kernels of generic rank-eight
   forms, so this is an effective orbit identification rather than an
   appeal to matching numerical invariants.  The frozen Burkhardt point
   also supplies the symplectic level-\(3\) structure.  Under the
   Rains--Sam identification the stabilizer contains the corresponding
   \(J(C)[3]\).  The two theta groups are therefore the same finite
   Heisenberg extension after this level-\(3\) identification, and their
   irreducible nine-dimensional Schrödinger representations have a unique
   intertwiner up to scalar.  We may consequently choose the reconstructed
   projective change of basis to align the frozen Heisenberg action, not
   just the abstract Coble cubic.

4. An ordering \((r_1,\ldots,r_6)\) is precisely the additional full
   level-\(2\) marking.  C704's Joubert tensor is an integral polynomial
   covariant of six ordered entries.  Its already-proved identities
   \[
   \sum_TZ_T=\sum_TZ_T^3=0
   \]
   put \(Z\) on the Segre cubic, and its centered-square identity puts
   \(W\) on the Igusa quartic.  These are polynomial identities, so they
   hold for the six branch points over the splitting algebra.  C704 also
   proves
   \[
   g\cdot Z_T=\operatorname{sgn}(g)Z_{gT}
   \qquad(g\in S_6).
   \]
   Consequently a comparison on one ordered sheet determines the
   comparison on every sheet; squaring removes the sign in the Igusa
   coordinates.  No \(720\)-case enumeration is needed.

5. Nguyen's \(\tau^+\) restriction of the Heisenberg Coble cubic is the
   Segre cubic, and projective duality gives the Igusa quartic.  The
   Heisenberg-equivariant choice in Step 3 carries the relevant involution
   and hence its \(\tau^+\) eigenspace to the frozen one.  Step 4 then
   fixes the ordered outer coordinates, so this is the same Segre--Igusa
   pair as C704's.  Differentiating
   \(\mathscr P(x,\eta)=\langle\eta,Z(x)\rangle\) gives \(A=dZ\).
   C705's two kernel identities then force
   \[
   \operatorname{adj}(A)=6Wq^{\mathsf T}.
   \]

6. Finally, \(\operatorname{Gal}(f_\alpha/\mathbf Q)=S_6\).  After
   adjoining \(r_1\), the remaining Galois group is its point stabilizer
   \(S_5\), which acts faithfully on \(r_2,\ldots,r_6\).  Thus no ordering
   is defined over the one-point field.  Nevertheless the equations in
   Steps 4--5 are \(S_6\)-equivariant, so their unordered projective
   diagram descends to \(\mathbf Q\).

This proves the theorem.  The \(p=1447\) run independently checks all
coordinate conventions, signs, and normalizations; it is not a substitute
for the proof.

## Scope of the result

The completion proves existence and projective-orbit identity, including a
constructive recovery mechanism.  It deliberately does not canonize a
theta basis: doing so would contradict the certified \(S_5\) residual
marking torsor.  Nor does it claim that the affine-\(E_8\) paired-McKay
parent and the Lie-\(E_8\) Vinberg parent are the same representation.
They are two exact parents meeting at the same Joubert/Coble operator
diagram.

## `ej` + `tt` closeout

The cheap extra value is the principal-Pfaffian quotient itself.  It turns
the abstract orbital-degeneracy statement into a direct computation:
each of nine quartics visibly contains its omitted coordinate, and the
nine quotients are the same cubic after the alternating sign correction.
This gives a compact diagnostic for future trivector specializations.

The structural closeout asks what an explicit \(9\times9\) matrix would
actually add.  Lemma 5.3 reconstructs such a matrix from kernels of generic
rank-eight forms, but different theta bases change it.  Because the
level-\(2\) ordering already has a certified torsor, promoting one matrix
to “the” Lie-\(E_8\) identification would add a false canonicity without
strengthening the orbit theorem.  The invariant endpoint is therefore the
projective orbit plus its explicit reconstruction procedure, exactly the
level proved here.

## Literature

- Eric Rains and Steven Sam, *Invariant theory of
  \(\bigwedge^3(9)\) and genus 2 curves*, arXiv:1702.04840, especially
  Proposition 2.1, the grading (2.5), Lemma 5.3, Proposition 5.4, and
  Theorem 5.5.  Cached PDF SHA-256:
  `4c46b1edef9252cae1917d9d4fbc91607ae792aafa895ccfae47d5b39dc56296`.
- Laurent Gruson, Steven Sam, and Jerzy Weyman, *Moduli of Abelian
  varieties, Vinberg theta-groups, and free resolutions*,
  arXiv:1203.2575, §5.  Cached PDF SHA-256:
  `507bf9fd46c564859b8083bc46386d8808b4e847abdac7e8c89612060de50948`.
- Nils Bruin and Brett Nasserden, *Arithmetic aspects of the Burkhardt
  quartic threefold*, arXiv:1705.09006, Proposition 2.5 and §§7.4--7.5.
  Cached PDF SHA-256:
  `e4d84263b04294adea81aecce0232e359c4a0ed03855c00e57315c5a4224bc3a`.

This is a mechanism and exact-specialization result, not a novelty or
priority claim.

## Reproducibility

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-burkhardt-e8-marking.py --check
python3 notes/2026-07-30-c705-lie-e8-sheet.py --check
python3 notes/2026-07-30-c705-lie-e8-sheet-replay.py
```

The first command verifies the characteristic-zero marked normal form and
the \(S_6\) Galois certificate.  The second performs the full \(720\)-sheet
split-fiber and Pfaffian calculation.  The independent replay hard-codes
the six Joubert coefficient rows and rechecks all \(720\) ordered images
without importing the C704 generator.

Checksums are in
`notes/2026-07-30-c705-lie-e8-completion.sha256`.

## Mystery ledger

- **Settled:** the missing Lie group is the split \(E_8\) with its
  order-three Vinberg grading; the Coble cubic is its Pfaffian orbital
  degeneracy locus.
- **Settled:** the marked normal form and the frozen Heisenberg Coble model
  are the same projective orbit, by the inverse-orbit theorem and the
  trivial \(3\)-covering class.
- **Settled:** all \(720\) ordered level-\(2\) sheets meet C704's Joubert
  and Segre--Igusa identities in the completely split fiber.
- **Settled:** the residual \(S_5\) is a genuine obstruction to a canonical
  ordered equality, not a gap in the parent mechanism.
- **No genuine C705 mystery remains.**  A literal theta-basis matrix would
  record one noncanonical trivialization already classified by the torsor;
  it would not strengthen the theorem.
