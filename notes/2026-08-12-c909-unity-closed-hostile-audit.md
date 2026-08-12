# C909 hostile audit: intrinsic certificate stack behind the closed unity theorem

Date: 2026-08-12  
Scope: C909 finite-etale graph saturation, cubic period separation, and the
closed \(A_5\) norm/Prym marking. No C907/C908 or non-Voisin Chow claims.

## Verdict

**GO after two theorem-local MINOR repairs.** The unity theorem is a genuine
corollary of a more intrinsic presentation-stack theorem, not merely a
conjunction of two slogans. The cycle branch now has a real positive-
dimensional \(A_5\) marked lift: the relative norm-axis construction gives
the integral isogeny and actual graph kernel, while the VGY Prym pullback
identifies the actual \(2\)-torsion marking.

Two qualifications must be made explicit:

1. the full assertion
   \(\operatorname{PD}\langle\operatorname{NS}(A)\rangle
   =\) ordinary divisor products is proved for the non-CM coefficient
   elliptic presentation; at CM fibres the safe theorem concerns the
   prescribed graph NS lattice (and still suffices for the polarization
   class), unless an extra CM argument is supplied;
2. the global finite-etale domain is a countable union of fixed-data
   finite-level presentation stacks, not one finite-type closed or special
   substack of \(\mathcal A_g\). “Component” must carry the fixed graph data.

Calling the current unqualified full-NS/CM statement theorem-grade would be
MAJOR; restricting or reformulating it as above is a MINOR repair.

## The more intrinsic theorem

For \(g\ge 2\), fix finite integral graph data \(\tau\): a modular level on an
elliptic curve \(E\), a block-respecting source coefficient polarization,
elementary-divisor depths, self-adjoint graph slopes, and finite-etale
truncated slope algebras at every positive depth. Define the marked
presentation stack \(\mathscr G_{g,\tau}^{\mathrm{fe}}\) by objects
\[
 (E,(A,\Theta),f,\tau),\qquad f:E^g\longrightarrow A,
\]
where \(f\) is the polarized graph quotient with the declared self-dual
finite kernel. For fixed \(\tau\), this is dominated by a finite-level modular
curve; its map to \(\mathcal A_g\) is algebraic. Let
\[
 \mathscr G_g^{\mathrm{fe}}=\coprod_\tau\mathscr G_{g,\tau}^{\mathrm{fe}}
\]
mean the countable union of these fixed-data stacks, not a single finite-type
object.

Let \(N_\tau^1(A)\) denote the coefficient NS lattice supplied by the marked
graph calculation and put
\[
 P_\tau^k(A)=
 \operatorname{im}\!\left(\operatorname{Sym}^kN_\tau^1(A)
 \longrightarrow H^{2k}(A,\mathbf Z)\right).
\]
The intrinsic C909 theorem is:
\[
 \operatorname{PD}\langle N_\tau^1(A)\rangle^k=P_\tau^k(A)
 \qquad(0\le k\le g).
\tag{1}
\]
For non-CM \(E\), \(N_\tau^1(A)=\operatorname{NS}(A)\), so (1) is the
full cohomological \(\operatorname{PD}(\operatorname{NS})\) theorem. At CM
points, (1) is the safe prescribed-lattice statement; extra CM divisor
classes only enlarge the ordinary product target, but equality for the
enlarged full NS lattice is not supplied by the present rank-one proof.

The proof is exactly the arbitrary-depth graph theorem: after finite
unramified splitting, the coefficient lattice is symmetric matrices of
ideals with
\[
 e_{ij}=\max\{a_i,a_j,a_i+a_j-v_p(t_j-t_i)\}
 \ \ge\ \left\lceil\frac{a_i+a_j}{2}\right\rceil.
\]
The DVR criterion gives rank-one generation, rank-one forms pull back to
square-zero divisor classes, and
\[
 D^{[k]}=D^k/k!
   =\sum_{|I|=k}\prod_{i\in I}R_i
\]
descends faithfully from the unramified splitting ring. This theorem is the
real reusable result; the cubic statement is its \(g=5\) period-locus
corollary.

## The cubic separation stack

Let \(\mathscr C_3^{\mathrm{sm}}\to\mathcal A_5\) be the smooth cubic
intermediate-Jacobian period map. For fixed \(\tau\), form
\[
 \mathscr S_\tau=
 \mathscr C_3^{\mathrm{sm}}\times_{\mathcal A_5}
 \mathscr G_{5,\tau}^{\mathrm{fe}}.
\tag{2}
\]
At a marked point of (2), the prescribed-lattice theorem gives
\[
 \Theta_{J(X)}^4/4!\in P_\tau^4(J(X)).
\tag{3}
\]
The right side is an ordinary product of actual divisor classes. Voisin's
cubic criterion then gives universal \(CH_0\)-triviality of \(X\). The
unmarked existential corollary is legitimate:
\[
 J(X)\text{ admits at least one lift to some }\mathscr G_{5,\tau}^{\mathrm{fe}}
 \Longrightarrow X\text{ is universally }CH_0\text{-trivial}.
\tag{4}
\]
The mark is needed for the proof, but the conclusion is a property of \(X\)
and descends through the forgetful map.

Independently, the all-smooth-cubic carrier theorem gives irrationality of
\(X\times\mathbf P^1\) for every smooth cubic. Thus the honest separation
statement is the two-certificate implication
\[
\begin{array}{c}
\text{marked finite-etale graph presentation}\\
\Downarrow\\[-2pt]
\Theta^4/4!\text{ is an integral divisor product}
\Downarrow\ \text{Voisin}\\[-2pt]
X\text{ universally }CH_0\text{-trivial}
\end{array}
\qquad
\text{and independently}\qquad
\text{every smooth }X:\ X\times\mathbf P^1\text{ irrational}.
\tag{5}
\]
There is no arrow from the Hecke condition to the quantum conclusion.

## What the \(A_5\) closure now proves

The relative norm/Roulleau comparison supplies a genuine relative
\[
 f:E^5\longrightarrow J,\qquad f^*\Theta=6I_5-J_5,
\]
with its actual finite self-dual kernel. The VGY degree-five Prym pullback
has norm composition \([5]\), image equal to the \(C_5=D_5\) fixed norm axis,
and hence identifies its \(2\)-torsion with the actual coefficient elliptic
curve. The primitive axis polarization even forces the Prym-to-axis map to
have degree one. Therefore, after the finite graph/level marking, the signed
\(A_5\) pencil really maps to one fixed-data stack \(\mathscr G_{5,\tau}\);
this was previously only a conditional lift.

At two, the graph packet is
\[
 \mathbf P^1(\mathbf F_4)
 =\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\}.
\]
The exotic pair is the sign quotient of the elliptic \(S_3\) two-torsion
monodromy. The VGY/Tate comparison transfers it to the actual kernel, and
the normalized modular coordinate has
\[
 r^2=T,\qquad T=81t^2,\qquad r=\pm9t.
\]
Thus the \(A_5\) family is a genuine positive-dimensional substack of (2)
for its fixed \(\tau\), after the finite marking cover. It should not be
called a component of the unbounded union \(\mathscr G_5^{\mathrm{fe}}\) or
of its bare image in \(\mathcal A_5\) without specifying the closure and
generic degree.

## Proof compression and intrinsic reach

The unity theorem is best advertised as a corollary of (1)--(2):
\[
\text{finite-etale presentation stack}
\Rightarrow\text{all-degree Lefschetz PD saturation}
\Rightarrow\text{cubic minimal class}
\Rightarrow\text{Voisin universal }CH_0.
\tag{6}
\]
The independent carrier theorem is then a second certificate on the same
fibre product. This is more intrinsic than the original special-family
cofactor proof and materially broadens the quantifier from “the \(A_5\)
pencil” to every smooth cubic admitting one marked presentation.

For each fixed \(\tau\), the source is modular dimension at most one, so a
positive-dimensional intersection with the cubic period locus is a shared
modular/cubic curve, not a generic high-dimensional phenomenon. Strong
Torelli identifies the normalization of the shared period image once the
marked map is constructed. Consequently the theorem predicts a precise
finite-or-shared-component dichotomy for every fixed graph datum:
\[
\dim(\mathscr S_\tau)>0
\quad\Longleftrightarrow\quad
\text{a modular graph curve is a shared cubic period component}.
\]
This is an exact moduli consequence, not a claim that other components exist.

The phrase “Hecke--Shimura” should be used carefully. Fixed \(\tau\) gives a
finite-level Hecke/presentation correspondence and a modular curve; the
countable union need not be a Shimura subvariety, closed locus, or canonical
PEL stratum. “Marked finite-etale elliptic-power presentation stack” is the
safe theorem name.

## Venue reach

The closed norm/Prym step raises the package from a special lattice
calculation to a reusable integral saturation theorem with an explicit
nonempty cubic separation component. This is a real top-tier-strengthening:
the cycle conclusion is no longer tied logically to one hand-built fibre,
and the \(3+2\) modular resolvent is the exact marking of the actual kernel.

The strongest novelty claim is the integral all-degree finite-etale
PD-to-product theorem plus its cubic-period application. The finite
\(\mathrm{PGL}_2(\mathbf F_p)\) orbit language is classical mechanism, not a
standalone headline. A top-tier submission is substantially more defensible,
but an Annals-level crown still lacks a classification of all shared cubic
components or a second moving component, and the two certificates remain
independent rather than one common invariant.

## Mystery ledger

### Settled

* The intrinsic general object is the fixed-data marked finite-etale
  presentation stack, with countable Hecke union.
* All-degree cohomological \(\operatorname{PD}\)-saturation follows from
  the finite-etale matrix-of-ideals/rank-one theorem.
* The \(A_5\) norm construction and VGY odd Prym comparison give the actual
  relative graph lift and \(r^2=T\) kernel marking.
* The cubic separation corollary is an existential marked-lift theorem;
  the quantum irrationality certificate is independent and universal.
* Fixed graph data have the finite-or-shared-component period intersection
  dichotomy.

### Open or requiring explicit theorem-local wording

* Extend full \(\operatorname{PD}(\operatorname{NS})\) equality to CM fibres,
  or state (1) for the prescribed graph NS lattice and reserve full-NS
  language for non-CM points.
* Record the fixed \(\tau\), finite-level marking, and stack inertia whenever
  calling the \(A_5\) curve a component.
* Classify which fixed \(\tau\) share a positive-dimensional cubic period
  component; no second moving component is currently established.
* Decide whether the Eisenstein \( \mathbf Z[\zeta_3]\) analogy can be
  upgraded to a genuine functorial comparison; current unity does not need
  this and should not claim it.

No relative Chow, diagonal, or unmarked cycle descent is part of this audit.
