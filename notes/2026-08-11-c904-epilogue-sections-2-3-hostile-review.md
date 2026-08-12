# C904 epilogue Sections 2--3 hostile cold review

Date: 2026-08-11
Scope: `papers/cubic-stabilization-epilogue/sections/02-envelope.tex` and
`03-minimal-class.tex`; no manuscript edits  
Verdict: **MINOR**

## Executive verdict

The proof spine survives hostile review.  I found no false theorem, missing
prime, hidden factor of two, or failure of Voisin's application.  In
particular, the mixed-adjugate argument works at (p=2), membership descends
from the unramified splitting ring, local membership globalizes, and the
argument is genuinely fibrewise for every smooth member of the nonstandard
(A_5)-component.

The remaining defects are referee-facing proof compression.  Three bridges
should be printed before this is called submission-ready: (1) identify the
Roulleau fibres with restrictions of the elliptic-quotient divisors and spell
out the Rosati trace calculation; (2) make the Torelli projection through the
central involution explicit; and (3) state the (pB), (B)-self-adjoint form
of the semisimple-slope lemma and give two sentences each for unramified
faithfully-flat descent and local--global membership.  These are precise local
repairs, not changes to statements or strategy.

## 1. Roulleau intersection to Rosati Gram: PASS, one missing bridge

The primary source gives exactly the data used.  Roulleau, Theorem 11(D), says
that the sum of the five involution curves in a (D_5) is a fibre of a map to
an elliptic curve.  The same source gives

\[
D_g^2=-4,\qquad D_gD_h=0,2,1
\]

when (o(gh)=2,3,5), respectively.  In (A_5), the 105 unordered pairs of
involutions split as (15,30,60), so the manuscript's

\[
D_{\rm tot}^2=-60+2(60+60)=180
\]

is correct.  Each involution is in two (D_5)'s, hence
(sum_HF_H=2D_{\rm tot}).  The degree-six (A_5)-action is two-transitive,
so all 30 ordered cross terms agree and (F_HF_{H'}=720/30=24).

The last numerical passage is also correct.  If
(D_H=q_H^*[0]in\operatorname{NS}(J)), then the Albanese restriction is
(D_H|_S=F_H), and its Rosati endomorphism is (N_H=i_Hq_H).  With coherent
identifications, (q_Hi_H=d) and (q_Hi_{H'}=m).  Thus

\[
\operatorname{tr}N_H=d,\qquad
\operatorname{tr}(N_HN_{H'})=m^2,
\]

and polarizing the determinant/Riemann--Roch identity gives
(F_HF_{H'}=d^2-m^2).  The missing trivial constituent gives
(d+5m=0), so positivity forces ((d,m)=(5,-1)).  Therefore
(G_6=6I-J), and a principal (5\times5) minor has Smith form
((1,6,6,6,6)).

**Precise repair.** Insert the two identities
(F_H=D_H|_S) and (N_H=i_Hq_H), followed by the displayed trace
calculation above.  Also say that the invariant sum of the six axis maps
vanishes because the relevant five-dimensional (A_5)-constituent has no
trivial summand.  As printed, “turns the last intersection into” asks the
reader to reconstruct all three facts.

## 2. Principal gluing packet and Torelli selection: PASS, one precision repair

The packet calculation is sound.  At two, the discriminant is
(H_2\otimes\mathbf F_2^2), with (H_2) simple and
(\operatorname{End}_{A_5}(H_2)=\mathbf F_4).  Its simple half-submodules are
therefore the five points of (\mathbf P^1(\mathbf F_4)).  The manuscript's
form

\[
b(x,y)=\operatorname{Tr}_{\mathbf F_4/\mathbf F_2}\det(x,y)
\]

makes the vertical line and every scalar graph isotropic; the self-adjointness
calculation is correct in characteristic two.  The three rational points are
(S_6)-stable.  Fixing an exotic graph forces (mathbf F_4)-linearity and
determinant one, hence gives (operatorname{SL}_2(4)=A_5); the odd normalizer
coset applies Frobenius and exchanges the pair.  At three, the same Schur
argument gives (mathbf P^1(mathbf F_3)); after a multiplicity-coordinate
change every chosen point is a scalar graph, and the Borel monodromy selects
one line.

The Torelli exclusion is correct but compressed.  Hartlieb recalls the exact
automorphism statement

\[
\operatorname{Aut}(J(X),\Theta)\cong
\operatorname{Aut}(X)\times\langle-1\rangle.
\]

If the kernel were one of the three rational points, the (S_6)-action on the
six-axis source would descend faithfully to the ppav.  Its projection to
(operatorname{Aut}(X)) is still injective: the kernel lies in the central
order-two factor, while (S_6) has no nontrivial normal subgroup of order at
most two.  This contradicts the generic automorphism group (A_5) on the
nonstandard component.  The finite kernel local system then cannot jump from
the exotic pair to a rational point on the connected smooth locus.

**Precise repair.** Replace “Strong Torelli would then give an (S_6)-action”
by the preceding two-sentence argument, and cite the exact generic-(A_5)
statement/table in Hartlieb/Wei--Yu rather than Section 5 as a whole.  This
also disposes explicitly of the ubiquitous polarization involution (-1).

## 3. Semisimple slopes and mixed adjugates: PASS, including (p=2)

The normalization is correct.  With coefficient rather than divided
polarization,

* (operatorname{Mdet}(E_{11},\ldots,E_{dd})=1);
* the diagonal mixed cofactor is (E_{ii});
* inserting (E_{ij}+E_{ji}) gives
  (-E_{ij}-E_{ji}), with no factor two.

These identities are exactly what ordinary products of divisors require:
the coefficient of (t_1\cdots t_g) in the determinant is the unnormalized
intersection product, and pairing the mixed adjugate with the final
coefficient matrix recovers that coefficient.

For squarefree slope, a finite unramified residue extension splits the minimal
polynomial.  Distinct self-adjoint eigenspaces are orthogonal; since their sum
is the whole nondegenerate residual space, each is nondegenerate.  They can be
lifted successively by unimodular orthogonal complements.  This uses inversion
of unimodular Gram matrices only, not (1/2), so it remains valid for
(p=2), including alternating residual blocks.  The lifts need not be
invariant under an integral lift of the slope: the graph overlattice depends
only on the slope modulo (p), where each block is scalar.

On a scalar block the graph congruence contains every
(p\operatorname{Sym}_d(O)) coefficient divisor.  Filling every non-target
block with a primitive mixed determinant and the target block with primitive
mixed adjugates constructs the corresponding block of
(operatorname{adj}(\perp pB_\lambda)).  Summing target blocks gives the
full cofactor.  Disjoint support means no multinomial coefficient appears.
Thus the proof has neither a factorial defect nor an off-diagonal factor-two
defect.

**Precise repair.** Promote the sentence after the theorem to a stated
variant for a source form (pB).  In that variant the slope is
(B)-self-adjoint and the graph congruence is written invariantly (in standard
coordinates, (D\widetilde T-\widetilde T^{\mathsf t}D\equiv0\pmod p)).
The present theorem is stated only for (pI), while the application says the
(pB) form works “verbatim”; at (p=2) a referee should not be asked to infer
this change of adjoint convention.

## 4. Descent and local--global: PASS, but print the module argument

Let (P\subset H) be the local divisor-product image.  All lattices and the
product map commute with the finite unramified scalar extension
(O/\mathbf Z_p).  If the class of (gamma_A) in (H/P) dies after tensoring
with (O), faithful flatness makes (H/P\to(H/P)\otimes O) injective, so it
already dies over (mathbf Z_p).  This is scalar extension of explicit
coefficient lattices, not a claim that individually chosen eigenspace divisors
geometrically descend.

At primes away from the isogeny degree the pullback identifies the integral
homology, Neron--Severi, and product lattices.  Since the relevant lattice
quotient is finitely generated, membership is equivalent to membership after
tensoring with every (mathbf Z_q).  The six-axis application therefore has
only the (2)- and (3)-primary checks printed in the manuscript.

**Precise repair.** Add the (H/P) faithful-flatness sentence and the finite
cokernel/localization sentence.  “Membership descends” and “local membership
globalizes” are correct, but too terse at the load-bearing integral step.

## 5. Six-axis application and every-fibre quantifier: PASS

For (G=6I_5-J_5), the vector (e_1) is a unit line at (p=2,3), and its
orthogonal complement has matrix

\[
\frac65(5I_4-J_4).
\]

Since (det(5I_4-J_4)=5^3), this is exactly a unit line plus (p) times a
unimodular rank-four block at both primes.  At two the exotic slope has
squarefree polynomial (t^2+t+1); at three an (A_5)-stable half is scalar
after choosing a graph chart.  The unit line has no kernel, and the blockwise
determinant/adjugate fill gives the full rank-five cofactor.  There are no
other bad primes.

The every-fibre claim is justified.  On the connected smooth locus, the
isogeny kernel is a finite sub-local-system and remains in the same exotic
pair at two and scalar class at three.  Special fibres with extra
Neron--Severi classes only enlarge the divisor-product image.  No horizontal
cycle or relative decomposition of the diagonal is required for this
fibrewise conclusion.

## 6. Voisin application: PASS exactly as stated

Voisin's Corollary 4.4 says verbatim that a smooth complex cubic threefold has
a Chow-theoretic decomposition of the diagonal, equivalently universally
trivial (CH_0), if and only if the class
(	heta^4/4!) is algebraic on its intermediate Jacobian.  A class in the
image of (operatorname{Sym}^4\operatorname{NS}(J)) is represented by an
ordinary product (and integral sum) of divisor classes, hence is algebraic in
Voisin's sense.  The manuscript therefore proves universal (CH_0)-triviality
for every smooth member, not merely a very general member and not merely after
an odd multiple.

It would be harmless to insert “complex” in the corollary statement to keep
the ground field visible, but no mathematical qualification is missing in the
present context.

## Source ledger

Primary cached sources actually read:

* Roulleau, arXiv:1002.4467, SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`:
  Theorem 11 and the involution-curve intersection table.
* Grieve, arXiv:1603.06425, SHA-256
  `29e4b19bee5a63bbb531d696adc4e4c211132eba97b19ecde1d72a1404fe8b0a`:
  Theorem 4.1 and Corollary 4.2.
* Hartlieb, arXiv:2304.03214, SHA-256
  `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`:
  Theorem 3.1, Section 5, Proposition 5.7, and Remark 5.8.
* Voisin, arXiv:1407.7261, SHA-256
  `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`:
  Corollary 4.4 and its proof.

The source texts support the imported claims at their stated strength.  The
semisimple-slope theorem is manuscript-internal; its integral proof was
checked directly and against the exact argument and independent-certificate
boundary recorded in
`notes/2026-08-11-c904-semisimple-graph-slope-primitivity.md`.

## EJ + TT closeout and mystery ledger

The cheap extra-strength check is positive: the local theorem does not use a
diagonal coefficient polarization and is naturally a theorem for every
unimodular symmetric (B), including dyadic (B).  Printing that form both
closes the application and makes the main integral mechanism easier to reuse.
The Tao-style stress question is where geometry actually enters.  The answer
is now sharp: geometry selects the exotic finite kernel; after that, the
minimal-class proof is a lattice theorem, and Voisin converts its conclusion
back to geometry fibre by fibre.

Mystery ledger:

* **Settled:** why no factor two appears in the off-diagonal mixed adjugate.
* **Settled:** why unramified splitting is safe at two and why the lifted
  summands need not be invariant under an integral slope lift.
* **Settled:** why an (S_6)-stable kernel contradicts generic (A_5), even
  though every intermediate Jacobian also has the central involution (-1).
* **Settled:** algebraicity of the divisor-product class is exactly Voisin's
  hypothesis, with no effectiveness, horizontality, or odd-multiple condition.
* **No genuine mathematical mystery remains inside Sections 2--3.**  The three
  open items are exposition obligations listed above, not evidence gaps or
  successor research problems.

## Acceptance gate

**MINOR.** Accept the mathematics and the universal-(CH_0) conclusion.
Before freezing, apply the three proof-compression repairs above.  None changes
a theorem statement, numerical constant, prime range, or fibre quantifier.

## Fresh re-review after printed repairs

Date: 2026-08-11
Regrade: **GO**

I re-read the current Sections 2--3 after the four requested repairs.  Each
now closes the corresponding objection without changing a normalization,
prime range, or fibre quantifier.

1. **Rosati passage closed.**  The proof now defines
   `D_H = q_H^*[0]` and `N_H = i_H q_H`, identifies `D_H|_S = F_H`,
   and derives `tr(N_H) = d` and `tr(N_H N_H') = m^2`.  The invariant
   axis sum supplies `d + 5m = 0`.  Together with `F_H F_H' = 24`, this
   gives exactly `(d,m) = (5,-1)`; no sign or trace-degree ambiguity
   remains.

2. **Torelli selection closed.**  The text now uses
   `Aut(J,Theta) = Aut(X) x <-1>` and proves that projection of the
   descended `S_6` remains faithful, because its kernel would be a normal
   subgroup of `S_6` of order at most
   two.  This handles the polarization involution and makes the contradiction
   with generic automorphism group `A_5` valid as printed.

3. **Unimodular `pB` form closed, including `p=2`.**  The new corollary
   states the exact local form used by the six-axis lattice: a unit block plus
   `pB`, a `B`-self-adjoint squarefree slope, and trivial kernel on the
   unit block.  Its invariant graph congruence is the correct one for
   coefficient forms.  On residual scalar eigenspaces it contains every
   block-supported `pD`.  Unimodular orthogonal complements require no
   division by two, and the mixed-adjugate construction therefore still has
   coefficient one on dyadic off-diagonal units.

4. **Descent and local--global closed.**  The proof now names the local image
   `P`, tensors the quotient `H/P` with the finite unramified faithfully
   flat ring, and records the resulting injection.  It then uses finite
   generation of the global cokernel to test membership over every
   `Z_q`.  This is the needed module argument; it does not pretend
   that individual eigenspace divisors descend geometrically.

5. **Application and Voisin quantifier unchanged and valid.**  The local
   chart remains the actual six-axis coefficient lattice, the exotic dyadic
   polynomial remains squarefree, and the three-primary graph remains scalar
   after a suitable chart choice.  The finite kernel sub-local-system carries
   this presentation across the connected smooth locus.  Voisin's
   Corollary 4.4 then applies fibrewise, so the conclusion is still every
   smooth complex member universally `CH_0`-trivial.

Residuals: **none load-bearing**.  The citation to Hartlieb's Section 5 could
optionally be narrowed to the exact family/classification statement, and the
application could cite only the new corollary rather than both the theorem and
corollary.  These are editorial improvements, not acceptance conditions.

Final closure verdict: **GO**.

## TT/EJ upgrade review: cofactor-saturation package

Date: 2026-08-11
Scope: current uncommitted abstract, introduction, and Section 3 additions only
Verdict: **MINOR**

### Mathematical value

The local theorem is genuinely useful and is not a tautological restatement of
the desired conclusion.  Its hypothesis is degree-one saturation of each
orthogonal Jordan block in the pulled-back divisor lattice.  Its conclusion is
membership of the distinguished degree-((g-1)) cofactor.  The primitive mixed
determinant and mixed-adjugate identities are exactly the nontrivial integral
bridge between those degrees; in particular, they prevent factorial and
off-diagonal factor-two losses.

The global corollary also adds a reusable statement: it separates the local
squarefree graph calculation at primes dividing the isogeny degree from the
formal local--global passage.  It remains honestly limited to elliptic-power
coefficient isogenies and to the `U_0` plus `pB` graph charts; it does not claim
an intrinsic classification of arbitrary Lagrangian gluings.

The six-axis application remains valid.  Its Smith type supplies precisely the
unit-line plus `pB` local forms at two and three; the exotic dyadic slope is
squarefree, the three-primary slope is scalar and therefore squarefree, and no
other prime divides the isogeny degree.

### Exact repairs

1. **Make the coefficient extraction in the local proof explicit.**  The
   phrase “fill ... with its primitive mixed determinant” produces coefficient
   one, not automatically `det(B_b)`; likewise the primitive mixed adjugates
   produce matrix units, not automatically `adj(B_a)`.  The claimed displayed
   block is nevertheless in the image because the determinant image is all of
   `Z_p` and the mixed-adjugate entries span `Sym_d(Z_p)`.

   Exact replacement after the first sentence of the proof:

   > By Lemma `lem:primitive-mixed` and `Z_p`-linearity, the mixed determinants
   > on block `b` realize the scalar `det(B_b)`, while the mixed adjugates on
   > block `a` realize every entry of `adj(B_a)`.  Scaling the available
   > coefficient divisors by `p^b` and `p^a` therefore gives ...

   Then retain the displayed formula.  Without this sentence, the formula is
   asserted rather than derived from the cited primitive identities.

2. **State the base-ring variant used by the next theorem.**  Local cofactor
   saturation is stated over `Z_p`, but the semisimple-slope proof invokes it
   only after passing to a finite unramified extension `O`.  The proof is
   unchanged over `O`, but this needs to be licensed in print.

   Exact edit: state the theorem over `R = Z_p` or the ring of integers of a
   finite unramified extension, replacing `Z_p` by `R` in its hypothesis; or
   add immediately after the theorem statement:

   > The same statement and proof hold after finite unramified extension of
   > `Z_p`.

3. **Do not advertise scalar slopes as a second mechanism independent of
   semisimplicity.**  A scalar slope is a special squarefree semisimple slope,
   while “scalar Jordan gluing” can be misread as a nonsemisimple Jordan slope.
   The manuscript proves one slope mechanism and uses its scalar special case
   at three.

   Exact abstract/introduction edit:

   > squarefree graph slopes, including scalar slopes on the relevant Jordan
   > blocks, force this saturation.

   Replace both occurrences of “semisimple graph slopes and scalar Jordan
   gluings are two sufficient mechanisms” by that formulation.

### Quantifier and dictionary audit

* The polarization dictionary occurs before the new local theorem, so the
  order of explanation is correct.
* The local theorem constructs the completed local product image, not actual
  individually descended global divisors; the later faithfully-flat and
  finitely-generated-cokernel arguments use exactly that quantifier.
* The global corollary quantifies only over primes dividing `deg(f)` and
  correctly treats all other primes by the isogeny-induced lattice
  identification.
* “Coefficient isogeny from an elliptic power” keeps the scope visible.  No
  arbitrary-ppav or arbitrary-maximal-isotropic claim has slipped in.
* The abstract's fibrewise Voisin conclusion remains justified.

Final TT/EJ verdict: **MINOR** pending the three exact prose/proof repairs.
No theorem statement, application, or headline conclusion needs withdrawal.
