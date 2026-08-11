# C904 genus-two theta carrier and D5-axis audit

Date: 2026-08-10

Status: quarantined Paper V research; literature and normalization closure, no
manuscript or Lean edits

## Verdict

The proposed odd carrier does **not** work. If $g\in A_5$ is an involution
and $D_g\subset S$ is Roulleau's genus-two curve on the Fano surface, then

\[
 A_g:=\operatorname{im}\bigl(J(D_g)\longrightarrow J(X)\bigr)
 \subset F-F=\Theta
\]

is the two-dimensional $g$-anti-invariant abelian subvariety. The two
$D_5$-axis elliptics indexed by the two $D_5$ subgroups containing $g$
lie in the $g$-**invariant** part and are not contained in $A_g$.

More strongly, on the actual six-axis principal homology lattice,

\[
             \Theta|_{A_g}\equiv 2\Theta_{D_g}.
\]

Consequently **every** curve contained in $A_g\subset\Theta$ has even
ambient theta degree. The two elliptic factors supplied by the centralizer
$V_4=C_{A_5}(g)$ have ambient theta degree $4$, not an odd degree. Thus
the genus-two construction gives a conceptual geometric explanation for the
group-graph parity no-go; it cannot close the primitive-theta gate.

## 1. What Roulleau actually proves

Roulleau, *Genus 2 curve configurations on Fano surfaces*, supplies the exact
geometric maps needed to orient the argument.

- Lemma 6 treats the natural map $J(D_g)\hookrightarrow\operatorname{Alb}(S)$
  as an embedding and identifies its tangent space with the two-dimensional
  subspace underlying the line attached to $D_g$. In the involution model
  this is the $(-1)$-eigenspace of $g$.
- Theorem 11(D), with the proof after Lemma 17, says that for every
  $D_5$-subgroup $H\subset A_5$,

  \[
       F_H=\sum_{h\in H,\ o(h)=2}D_h
  \]

  is a fibre of a morphism
  $\gamma_H:S\to E_H$. Hence, if $g\in H$, the restriction
  $\gamma_H|_{D_g}$ is constant. The induced quotient
  $q_H:J(X)\to E_H$ annihilates $A_g$.

The dual elliptic embedding $i_H:E_H\hookrightarrow J(X)$ is in the
$H$-fixed line and therefore in the $g$-fixed part. Since each involution
of $A_5$ lies in exactly two $D_5$ subgroups, both tempting axis elliptics
have the wrong eigensign. Roulleau's theorem therefore reverses, rather than
supports, the proposed inclusion $E_H\times E_{H'}\subset J(D_g)$.

## 2. The elliptics that really occur in $J(D_g)$

The centralizer of $g$ in $A_5$ is a Klein four group

\[
 C_{A_5}(g)=\{1,g,h,gh\}.
\]

The degree-five character has values
$\chi(1)=5$ and $\chi(g)=\chi(h)=\chi(gh)=1$. Its restriction to this
$V_4$ is

\[
          2\mathbf 1\oplus\chi_1\oplus\chi_2\oplus\chi_3.
\]

On the $g$-anti-invariant plane, $h$ has eigenvalues $+1,-1$.
Therefore $h$ preserves $D_g$ and is a non-hyperelliptic involution of the
genus-two curve. The quotients by $h$ and $gh$ give the standard paired
degree-two elliptic subcovers, and $J(D_g)$ is $(2,2)$-isogenous to their
product. This is the ordinary bielliptic splitting; it is not the pair of
$D_5$-quotient axes.

For general background on paired elliptic subcovers and the resulting
$(n,n)$-split Jacobian, see Shaska, *Curves of genus 2 with
$(n,n)$-decomposable Jacobians*, especially the general paired-cover
statement. No searched source identifies these two bielliptic factors with
Roulleau's $D_5$ axes, and the eigenspace calculation proves that such an
identification is impossible.

## 3. Exact theta normalization

There are two independent pieces.

### Geometric intersection normalization

Roulleau's *The Fano surface of the Klein cubic threefold*, in the proof of
Theorem 15, recalls the classical identities

\[
  \frac32\,\vartheta^*\Theta\equiv K_S,
  \qquad 3C_s\equiv K_S.
\]

Thus

\[
                 \vartheta^*\Theta\equiv 2C_s.
\]

The genus-two paper computes $C_sD_g=2$. Since the Abel curve $D_g$ is
the canonical theta curve in its Jacobian,

\[
       (\Theta|_{A_g})\cdot\Theta_{D_g}
       =\Theta\cdot D_g=2C_sD_g=4.                 \tag{3.1}
\]

Clemens--Griffiths prove that $F-F$ is the intermediate-Jacobian theta
divisor, so $A_g=D_g-D_g\subset F-F=\Theta$.

### Integral homology normalization

An independent exact replay used the actual exotic $A_5$-stable principal
homology lattice constructed from the six-axis source $6I-J$. For an
involution, the saturated anti-invariant lattice has rank four. The
restricted principal alternating form is integrally equivalent to the matrix

\[
\begin{pmatrix}
0&0&4&-2\\
0&0&-2&2\\
-4&2&0&-2\\
2&-2&2&0
\end{pmatrix}.
\]

Its determinant is $16$, and its elementary divisors are $(2,2)$.
Therefore the class $\Theta|_{A_g}$ is twice an integral principal
polarization $P_g$.

Equation (3.1) gives $P_g\cdot\Theta_{D_g}=2$. Both $P_g$ and
$\Theta_{D_g}$ have square $2$; the Hodge index theorem forces
$P_g\equiv\Theta_{D_g}$. Hence

\[
                  \boxed{\Theta|_{A_g}\equiv2\Theta_{D_g}}.
\]

This also removes a possible normalization ambiguity in the six-axis
picture. The relevant $V_4$-character elliptics are saturated images after
the principal gluing; they must not be assigned the unsaturated source-lattice
length of a formal difference of two $D_5$ axes.

For a degree-two elliptic subcover $D_g\to E$, the elliptic curve embedded
in $J(D_g)$ has $\Theta_{D_g}$-degree $2$. Its ambient degree is thus
$4$. More generally, for every curve $Z\subset A_g$,

\[
                     \Theta\cdot Z=2\Theta_{D_g}\cdot Z
\]

is even.

## 4. Priority boundary

The searched primary literature pre-empts the following ingredients:

1. the fifteen $A_5$-indexed genus-two curves and their intersection table;
2. the $D_5$ fibrations and their elliptic quotients;
3. the embedded Jacobian $J(D_g)\subset\operatorname{Alb}(S)$;
4. the rational isogeny $J(X)\sim E^5$;
5. paired elliptic subcovers and $(2,2)$-split genus-two Jacobians.

No checked source prints the relation
$\Theta|_{J(D_g)}=2\Theta_{D_g}$, the exact anti-invariant elementary
divisors $(2,2)$, the incompatibility with the two incident $D_5$ axes, or
the resulting all-curves-even no-go inside $J(D_g)\subset\Theta$. Those are
plausibly new deductions, but publication-grade absence still requires
MathSciNet/zbMATH and forward-citation closure.

## 5. Sources checked

- Xavier Roulleau, *Genus 2 curve configurations on Fano surfaces*,
  Comment. Math. Univ. St. Pauli **59** (2010), 51--64;
  arXiv:1002.4467. Read Lemmas 5--6, Corollary 8, Lemma 9, Theorem 11, and
  Lemmas 14--19. Cached source SHA-256
  c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd.
- Xavier Roulleau, *The Fano surface of the Klein cubic threefold*,
  J. Math. Kyoto Univ. **49** (2009); arXiv:1001.4853. Read Theorem 13 and
  the proof of Theorem 15, especially the principal polarization and
  canonical/incidence-divisor normalization.
- H. Clemens and P. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Ann. of Math. **95** (1972), 281--356. Used the Albanese and
  difference-map theorems identifying $F-F$ with $\Theta$.
- T. Shaska, *Curves of genus 2 with $(n,n)$-decomposable Jacobians*,
  J. Symbolic Comput. **31** (2001), 603--617; arXiv:math/0312285.
  Used only for the standard paired elliptic-subcover background.
