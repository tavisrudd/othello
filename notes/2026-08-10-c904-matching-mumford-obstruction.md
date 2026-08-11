# C904: Mumford obstruction to identifying the two Fano matchings

**Date:** 2026-08-10

**Status:** theorem-grade fixed-fibre certificate; quarantined Annals
research; no manuscript or Lean changes

**Scope:** the two matchings in the apparent degree-15
`Sym^2 Theta` carrier, and the exact role of Voisin's `D_{3,3}` fibres

## Executive verdict

Let \(X/\mathbf C\) be a smooth cubic threefold, let \(F=F(X)\), and use
the Abel--Jacobi embedding \(a:F\hookrightarrow J=J(X)\). Translate it
arbitrarily; all formulas below use only differences. Put

\[
                         \Theta=F-F.
\]

For four Fano points \(a,b,c,d\), the two matchings are

\[
 m_0=\{a-c,b-d\},\qquad m_1=\{a-d,b-c\}
       \quad\text{in }\operatorname {Sym}^2\Theta.
\]

They have the same image under addition to \(J\), but this is much weaker
than rational equivalence in the symmetric square.

> **Matching obstruction theorem.** For very general
> \((a,b,c,d)\in F^4\),
>
> \[
> [m_0]-[m_1]\ne0
>   \quad\text{in }CH_0(\operatorname {Sym}^2\Theta)_\mathbf Q.
> \]

The obstruction is detected after applying the tautological support
correspondence to \(J\). Its image is the Pontryagin rectangle

\[
\begin{aligned}
 R(a,b,c,d)
   &=[a-c]+[b-d]-[a-d]-[b-c]\\
   &=([a]-[b])*([-c]-[-d])\in CH_0(J),
\end{aligned}
\]

and Mumford's induced-two-form argument proves that this rectangle is
nonzero for very general quadruples, even with rational coefficients.

Consequently Voisin's vertical

\[
 \chi:D_{3,3}\longrightarrow\operatorname {Sym}^2\Theta
\]

geometry cannot join the two matchings. A fibre birational to
\(\operatorname {Sym}^2E_3\) creates relations and odd zero-cycles over one
fixed point of \(\operatorname {Sym}^2\Theta\), but it cannot change that
base point. Any proposed rational equivalence between equal-degree
zero-cycles over \(m_0\) and \(m_1\) pushes down to a nonzero multiple of
\([m_0]-[m_1]\), contradicting the theorem.

This closes the generic, componentwise proposed `30 -> 15` division by
matching equivalence. Section 4 records the extra restriction check needed
for the actual degree-15 carrier. The result does not obstruct the separate
common-line/Beauville `2`--`5` support lift, which avoids the second Fano
pair altogether.

## 1. Exact hypotheses and the tautological reduction

Work over \(\mathbf C\). The only cubic-threefold inputs are:

1. \(F\) is a smooth projective surface and its Abel--Jacobi map identifies
   \(\operatorname {Alb}(F)\) with \(J\); in particular invariant one-forms
   on \(J\) pull back isomorphically to \(H^0(F,\Omega_F^1)\);
2. the difference map

   \[
       \delta:F\times F\longrightarrow\Theta,\qquad (x,y)\longmapsto x-y,
   \]

   is dominant and generically finite (in fact of degree six).

No universal-`CH_0` hypothesis, genericity assumption on \(X\), or
`A_5` symmetry is used.

There is a tautological support homomorphism

\[
 s_*:CH_0(\operatorname {Sym}^2\Theta)
       \longrightarrow CH_0(\Theta),\qquad
 s_*[\{x,y\}]=[x]+[y].
\]

It comes from the finite incidence correspondence obtained by symmetrizing

\[
 \Theta^2\longrightarrow\operatorname {Sym}^2\Theta\times\Theta,
 \qquad (x,y)\longmapsto(\{x,y\},x).
\]

Equivalently, a rational family of effective degree-two cycles on \(\Theta\)
gives a rational equivalence of their support cycles. This remains valid on
the diagonal, with multiplicity two. After proper pushforward along
\(\Theta\hookrightarrow J\),

\[
 s_*([m_0]-[m_1])=R(a,b,c,d).
\]

Thus rational equivalence of the two matching points implies \(R=0\) in
\(CH_0(J)\). More generally, torsion of order \(n\) implies \(nR=0\).

## 2. The induced two-form of the rectangle

Let \(B=F^4\), and let

\[
\begin{array}{ll}
 f_{ac}(a,b,c,d)=a-c, & f_{bd}(a,b,c,d)=b-d,\\
 f_{ad}(a,b,c,d)=a-d, & f_{bc}(a,b,c,d)=b-c.
\end{array}
\]

The family of degree-zero cycles \(R\) is represented by the signed graph
correspondence

\[
        Z_R=\Gamma_{f_{ac}}+\Gamma_{f_{bd}}
             -\Gamma_{f_{ad}}-\Gamma_{f_{bc}}
              \quad\text{on }B\times J.
\]

For an invariant holomorphic two-form
\(\omega\in H^0(J,\Omega_J^2)\), its induced form on \(B\) is

\[
 \Omega_R=f_{ac}^*\omega+f_{bd}^*\omega
              -f_{ad}^*\omega-f_{bc}^*\omega.
\]

Regard \(B=(F\times F)\times(F\times F)\). For tangent vectors
\(u=(u_1,u_2)\) and \(v=(v_1,v_2)\) to these two blocks, put

\[
 x=d\delta(u_1),\quad y=d\delta(u_2),\qquad
 x'=d\delta(v_1),\quad y'=d\delta(v_2).
\]

Direct expansion of the four pullbacks gives the cross-term formula

\[
                       \Omega_R(u,v)
                =-\omega(x,y')-\omega(y,x').       \tag{2.1}
\]

All terms contained entirely in one \(F\times F\) block cancel. This is
the differential shadow of
\(R=([a]-[b])*([-c]-[-d])\).

## 3. Nonvanishing

Choose two general points of \(F\times F\). Since the difference map is
generically finite onto the fourfold \(\Theta\), the images

\[
 H=d\delta(T_{(a,b)}F^2),\qquad
 H'=d\delta(T_{(c,d)}F^2)
\]

are four-dimensional hyperplanes in the five-dimensional tangent space
\(T_0J\). Choose independent vectors \(x\in H\) and \(y'\in H'\). There is
an alternating form \(\omega_0\in\bigwedge^2T_0^*J\) with
\(\omega_0(x,y')\ne0\). On an abelian variety every such alternating form
extends uniquely to an invariant holomorphic two-form. Taking \(u\) only in
the first block and \(v\) only in the second block, equation (2.1) gives

\[
                           \Omega_R(u,v)
                         =-\omega(x,y')\ne0.
\]

Hence the rectangle correspondence has a nonzero induced holomorphic
two-form.

Mumford proves that a family of rationally equivalent zero-cycles has zero
induced two-form. Applied to a pair of effective families \(P,Q\), the exact
statement needed here is

\[
       P_s\sim_{\rm rat}Q_s\text{ on a dense open}
       \quad\Longrightarrow\quad \Omega_P=\Omega_Q.
\]

Indeed, on a component of Mumford's rational-equivalence relation there are
an auxiliary effective family \(G\) and a rational family joining \(P+G\)
to \(Q+G\). Functoriality along the rational family and his additivity
Lemma 2 give
\(\Omega_P+\Omega_G=\Omega_Q+\Omega_G\). This also handles the signed
rectangle without pretending that it is itself an effective symmetric-power
map.

Mumford's Section 1 starts with an arbitrary smooth variety, a finite
quotient, and an invariant \(q\)-form. Although Section 2 states the main
theorem for zero-cycles on a surface, the part used here extends verbatim to
a smooth projective variety carrying a holomorphic two-form: the proof uses
only symmetric powers, the countable-closed description of rational
equivalence, functoriality of induced forms, and the absence of one-forms on
\(\mathbf P^1\). No surface-dimension argument enters until Mumford's final
isotropic-dimension corollary.

Therefore \(R(a,b,c,d)\) cannot be rationally constant on a dense open of
\(F^4\). Mumford's countable-closed lemma also says that the locus on which
\(R=0\) is a countable union of closed subvarieties. Since no one of them
dominates \(F^4\),

\[
                      R(a,b,c,d)\ne0
                         \quad\text{for very general }(a,b,c,d).
\]

The same argument applies to every nonzero multiple of \(Z_R\), because its
induced form is the same multiple of \(\Omega_R\). Thus \(R\ne0\) in
\(CH_0(J)_\mathbf Q\). Applying the tautological support map proves the
matching obstruction theorem.

### What “very general” means here

The conclusion holds outside a countable union of proper closed
subvarieties of \(F^4\). The argument does not assert that every special
quadruple is obstructed. The obvious diagonals \(a=b\) and \(c=d\) make the
two matchings equal and make \(R\) vanish. Other special vanishing loci are
not classified.

## 4. Restriction to the degree-15 carrier

The very-general theorem on \(F^4\) has the following sharper restricted
form. Let \(C\subset\operatorname {Sym}^2F\) be an irreducible curve, pass
to an irreducible component \(\widetilde C\) of its ordering cover, and
write a point as \((a,b)\). If

\[
             \rho:\widetilde C\longrightarrow\Theta,\qquad
             (a,b)\longmapsto a-b
\]

is nonconstant, then the same two-form calculation on
\(\widetilde C\times F^2\) is nonzero. At a point where
\(d\rho=x\ne0\), choose \(y'\) in the four-dimensional image of the second
difference map and choose \(\omega\) with \(\omega(x,y')\ne0\). Thus the
two matching sheets are not rationally equivalent over a very general point
of this component.

The only escape is a component on which \(a-b=r\) is constant. Its sum
map on the ordered normalization is \(2a-r\). If
\(A=a_*[\widetilde C]\) is the resulting one-cycle on \(F\), then
\([D_+]=3\Theta\), \([2]^*\Theta=4\Theta\), and
\(a^*\Theta=2C_s\) give

\[
             D_+\cdot[2]_*A
               =3[2]^*\Theta\cdot A
               =24\,C_s\cdot A.
\]

This is divisible by 24 on the ordered normalization. Passing to the
unordered component divides by at most the degree-two ordering cover, so
its downstairs contribution is still divisible by 12 and in particular
even. The total signed base degree in the proposed carrier is 15. Hence the
odd part cannot be supported entirely on constant-difference components:
at least one odd-contributing component has nonconstant \(\rho\), and on it
the matching sheets are obstructed by the two-form.

This rules out halving the canonical degree-30 carrier by a componentwise
rational equivalence of its two matching sheets. It does not prove that an
unrelated global Chow combination of several components cannot be divisible
by two.

## 5. Exact consequence for `D_{3,3}`

Voisin constructs a surjective morphism

\[
       \chi:D_{3,3}\longrightarrow\operatorname {Sym}^2\Theta.
\]

For a general theta pair \(m\), the fibre is described by two rational cubic
curves moving in their two \(\mathbf P^2\) linear systems and meeting in a
degree-two divisor on a complete-intersection elliptic curve \(E_3\). The
fibre is birational to \(\operatorname {Sym}^2E_3\). This is a statement
over one fixed point \(m\) of the `chi` base.

Let \(m_0,m_1\) be the two matching points above, and let \(z_i\) be
zero-cycles of the same positive degree \(e\), with \(z_i\) supported in
\(\chi^{-1}(m_i)\). If

\[
                         z_0\sim_{\rm rat}z_1
                         \quad\text{on }D_{3,3},
\]

then proper pushforward gives

\[
                         e[m_0]=e[m_1]
                 \quad\text{in }CH_0(\operatorname {Sym}^2\Theta).
\]

For a very general Fano quadruple this is impossible even over
\(\mathbf Q\). The conclusion persists on any proper resolution or
compactification to which \(\chi\) extends, by applying the extended proper
map.

In particular:

- rational curves contained in a `chi` fibre are vertical and keep \(m\)
  fixed;
- chains of such vertical curves cannot move from \(m_0\) to \(m_1\);
- a hypothetical nonvertical rational equivalence upstairs would still
  push down to \(e([m_0]-[m_1])\), so it is also excluded very generally;
- the degree-three zero-cycle coming from the plane cubic is useful for
  multiplying a carrier already placed over one \(m\), but it cannot choose
  or identify the two different matchings.

The addition map
\(\operatorname {Sym}^2\Theta\to J\) sends \(m_0\) and \(m_1\) to the same
point. Voisin's map `chi` does not identify its fibres through addition.
Confusing an addition fibre with a `chi` fibre is precisely the failed step.

## 6. Bounded independent checks

The audit used three independent checks.

1. **Cycle check.** Expanding the Pontryagin product gives

   \[
   ([a]-[b])*([-c]-[-d])
     =[a-c]+[b-d]-[a-d]-[b-c].
   \]

   Its degree and Albanese sum are both zero, so ordinary degree or
   Albanese cannot detect it; a higher holomorphic form is genuinely needed.
2. **Differential check.** The four pullbacks were expanded independently.
   Pure terms cancel, leaving exactly (2.1). On a tangent slice with
   \(y=x'=0\), it evaluates to \(-\omega(x,y')\), proving that the sign or a
   missing factor cannot accidentally force zero.
3. **Functoriality check.** Any proposed relation upstairs in `D_{3,3}`
   was pushed first to `Sym^2 Theta` and then through the tautological
   support correspondence to \(J\). The resulting obstruction is \(eR\), so
   the argument rules out not only a rational curve but every equal-degree
   Chow relation between the two fibres.

The search was bounded to the three load-bearing primary sources below and
the exact cited sections. No secondary theorem is used in the proof.

## 7. Primary-source ledger

1. **David Mumford, _Rational equivalence of 0-cycles on surfaces_, J.
   Math. Kyoto Univ. 9 (1968/69), 195--204.** Read depth: **full text**.
   Used Section 1 on induced differentials for arbitrary smooth quotients,
   Section 2's main theorem, Lemma 2 (additivity), Lemma 3 (the
   countable-closed rational-equivalence relation), and the proof of the main
   theorem. The final surface-specific isotropic-dimension corollary is not
   used. Cached translated full text SHA-256
   `23b980e0d0e9b14867ddb7ae897f3e29c60daa90fa48ad5fc526c0101fe598bb`.
2. **C. Herbert Clemens and Phillip A. Griffiths, _The intermediate
   Jacobian of the cubic threefold_, Ann. of Math. 95 (1972), 281--356.**
   Read depth: **claim-specific partial**. Used the Albanese/Abel--Jacobi
   identification for the Fano surface and Section 13, Theorem 13.4 and its
   proof, for \(\Theta=F-F\) and the generic degree-six difference map.
   Cache key `10.2307/1970801`; SHA-256
   `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.
3. **Claire Voisin, _Abel--Jacobi map, integral Hodge classes and
   decomposition of the diagonal_, arXiv:1005.5621v2.** Read depth:
   **claim-specific partial**, Section 2 at the construction of
   \(D_{3,3}\), the morphism `chi`, the description of its general fibre,
   and Lemma 2.4 with proof. ArXiv source archive SHA-256
   `7d7594bd1aaf79eb152c33b590e56693288c56aded266c19abc47ad767f624e5`;
   previously cached PDF SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

## 8. Boundary of the result

- **Closed:** the two very general Fano matchings are not rationally
  equivalent, even over \(\mathbf Q\).
- **Closed:** vertical `D_{3,3}` fibres cannot identify distinct
  `chi`-base points; their odd plane-cubic cycles only relay a carrier already
  on the base.
- **Closed:** the canonical degree-30 matching correspondence cannot be
  halved componentwise to degree 15 by pairing its two sheets through
  rational equivalence; constant-difference components contribute only
  even base degree (in fact a multiple of 12 downstairs).
- **Not claimed:** no special quadruple can have equivalent matchings.
- **Not claimed:** every conceivable global Chow combination of the
  degree-30 cycle is indivisible by two.
- **Unaffected positive route:** the common-line inclusion
  \(\operatorname {Sym}^2F\subset\operatorname {Sym}^2\Theta\) and the
  Beauville `2`--`5` lift of Shen's support use only one Fano pair and do not
  encounter this obstruction.

**Vibe:** the missing factor two is not hidden in Voisin's ruled fibres. It
is already visible as a nonzero second-order Pontryagin rectangle on the
intermediate Jacobian.
