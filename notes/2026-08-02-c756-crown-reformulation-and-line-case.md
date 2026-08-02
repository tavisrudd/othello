# C756 — crown reformulation of coherence and the affine-line case (twenty-fifth pass)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
\((R,\gamma)\) split-fiber gate

## Verdict

Four results: a reformulation, a proved configuration, a conditional reduction, and a much larger certified range.

1. **Reformulation.**  A coherent system is exactly an induced *crown graph* in the
   Paley graph of order \(q^2\) whose missing perfect matching is Frobenius
   conjugation; equivalently a \(\pm1\)-valued, Frobenius-odd eigenfunction of that
   Paley graph for the eigenvalue \(-(q+1)/2\), with support exactly \(q+3\).  This
   moves the branch out of arc combinatorics and into the classification of
   small-support Paley eigenfunctions and of maximal cliques of \(P(q^2)\), both of
   which are established literatures.
2. **Affine-line theorem.**  *If a coherent system is contained in an
   \(\mathbb F_q\)-affine line of \(\mathbb F_{q^2}\), then \(q=5\).*  The proof is
   elementary and uniform over every odd prime power: a "more than half the group"
   sumset step against a single Weil-free quadratic character count.  Both \(q=5\)
   frames are contained in a line and sit exactly on the boundary of the inequality,
   which is why they survive and nothing else does.

3. **Reduction and conditional closure.**  A line-free clique of size \((q+3)/2\) in
   \(P(q^2)\) is exactly the regime of the Baker–Ebert–Hemmeter–Woldar maximal cliques.
   Their gap and two-orbit conjecture forces \(q\equiv3\pmod4\) and
   \(Z=a(Q_j\cup\{0\})+b\) (Theorem 3), and that residual two-parameter family is killed
   **unconditionally for \(q\ge83\)** by a Weil bound whose key step is that the relevant
   discriminant is a fixed nonsquare (Theorem 4), with the smaller fields covered by
   direct computation.

4. **Certified range, without the conjecture.**  Recognizing coherence as a clique
   condition in a vertex-transitive graph makes an exhaustive search practical far past
   the old audit: the branch is unconditionally empty for every \(q\equiv3\pmod4\)
   with \(7\le q\le151\), and the two published clique orbits are empty for every
   such \(q\le503\).  This also discharges the standing \(q=27\) extension-field
   item.

What this does and does not buy.  The reduction of item 3 does **not** by itself extend
the unconditional range: the gap conjecture is unproved — Yip states in print that "no partial progress has been
made" on it — and the published orbit-complete clique tables reach only \(q\le47\),
barely past the old exhaustive audit at \(q\le43\).  What item 3 buys is a change of
kind, and what actually moved the certified range is item 4.  The saturated-internal gate stops being an open search over arcs and becomes a
single named, actively studied conjecture in Paley-graph combinatorics, of which we need
only a special case: not "no maximal clique of size \((q+3)/2\)", but "no such clique
that also carries a Frobenius crown".  The extra crown hypothesis is real leverage that
the reduction currently throws away.

## 1. Setup and conventions

\(q\) is an odd prime power, \(\varepsilon\) a fixed nonsquare in \(\mathbb F_q\),
\(\mathbb F_{q^2}=\mathbb F_q(s)\) with \(s^2=\varepsilon\), conjugation
\(z\mapsto z^q\), norm \(N(z)=z^{q+1}\).  Write \(\chi\) for the quadratic character of
\(\mathbb F_{q^2}\) and \(\chi_q\) for that of \(\mathbb F_q\); then
\(\chi(u)=\chi_q(N(u))\).  Set \(t=(q+1)/2\), \(n=t+1=(q+3)/2\), and
\(\delta=(-1)^t\).

A **coherent system** is a set \(Z=\{z_1,\dots,z_n\}\subset
\mathbb F_{q^2}\setminus\mathbb F_q\), no two elements conjugate, with

- (A) \(\chi(z_i-z_j)=\delta\) for all \(i\ne j\);
- (B) \(\chi(z_i-z_j^q)=-\delta\) for all \(i\ne j\).

Two facts used throughout.  First, \(\chi(u)=+1\) for every \(u\in\mathbb F_q^\times\),
because \(N(u)=u^2\).  Second,
\(\chi(z-z^q)=\chi_q(-\varepsilon)=(-1)^{(q+1)/2}=\delta\): conjugate differences fall
in the same class as the (A)-differences, never the (B)-class.

## 2. The crown reformulation

Let \(P_{\mathrm{cross}}\) be the Cayley graph on \(\mathbb F_{q^2}\) with connection
set \(\{u\ne0:\chi(u)=-\delta\}\).  This is the Paley graph of order \(q^2\) when
\(-\delta=+1\) and its complement otherwise; both are isomorphic to \(P(q^2)\), with
spectrum \((q^2-1)/2\) and \((-1\pm q)/2\).

The **crown graph** \(S_n^0\) is \(K_{n,n}\) minus a perfect matching.  Its spectrum is
\(\pm(n-1)\) and \(\pm1\); the \(-(n-1)\)-eigenvector is \(+1\) on one side and \(-1\)
on the other.

> **Theorem 1.**  \(Z\) is a coherent system if and only if the \(q+3\) vertices
> \(Y=Z\sqcup Z^q\) induce in \(P_{\mathrm{cross}}\) the crown graph with parts
> \(Z,Z^q\) and missing matching \(\{z,z^q\}\).  In that case
> \(x=\mathbf 1_Z-\mathbf 1_{Z^q}\), extended by zero, is an eigenfunction of
> \(P_{\mathrm{cross}}\) for the eigenvalue \(\lambda_{\min}=-(q+1)/2\), and
> eigenvalue interlacing is tight: \(\lambda_{\min}(S_n^0)=-(n-1)=-(q+1)/2\).

*Proof.*  (A) says \(Z\) is independent in \(P_{\mathrm{cross}}\), and applying
Frobenius says the same for \(Z^q\).  (B) says every \(z_i\) is adjacent to every
\(z_j^q\) with \(j\ne i\), while \(\chi(z_i-z_i^q)=\delta\) says the conjugate pairs are
non-adjacent.  That is exactly the crown.  Conversely the induced crown returns (A) and
(B).  The eigenvector claim is the crown's \(-(n-1)\)-eigenvector, and it extends by
zero because every vertex outside \(Y\) would need \(\sum\) over its neighbours in \(Y\)
to vanish — which is Lemma 1 of the twenty-fourth pass
(`2026-08-02-c756-digit-tower-composition.md`), the Parseval argument showing
\(\chi*x=q\delta x\) globally. \(\square\)

Three consequences worth recording.

- \(Z\) is a **clique of size \((q+3)/2\)** in the Paley graph on the class \(\delta\).
  Since the clique number of \(P(q^2)\) is \(q\) with maximum cliques exactly the
  \(\mathbb F_q\)-lines (Blokhuis), \(Z\) is roughly a half-size clique.
- \(x\) is a \(\pm1\)-valued eigenfunction of \(P(q^2)\) with **support exactly
  \(q+3\)** for the eigenvalue \(-(q+1)/2\), and it is Frobenius-**odd**:
  \(x(z^q)=-x(z)\), hence \(\hat x(w^q)=-\hat x(w)\) and \(\hat x\) vanishes on
  \(\mathbb F_q\).
- Tight interlacing is not an accident to be exploited further: it is equivalent to the
  eigenfunction statement, so no additional spectral bound can be extracted here.  This
  is the precise reason the "tight balance theorem" of the earlier passes could not
  finish the branch.

## 3. The affine-line theorem

> **Theorem 2.**  Let \(Z\) be a coherent system contained in an \(\mathbb F_q\)-affine
> line \(L=a+b\,\mathbb F_q\subset\mathbb F_{q^2}\).  Then \(q=5\), and \(Z\) is a line
> \(b\,\mathbb F_q^\times\) through a rational point with \(Z=b\cdot\mathbb F_q^\times\)
> after translation.  Both \(q=5\) frames are of this shape.

The only external input is the following elementary lemma.

> **Lemma (more than half).**  If \(A,B\) are subsets of a finite group \(G\) with
> \(|A|+|B|>|G|\), then \(AB=G\).

*Proof of Theorem 2.*  Lines split into two types by their direction.

**Case (a): \(b\in\mathbb F_q^\times\), so \(L=a+\mathbb F_q\) with \(a\notin\mathbb F_q\).**
Write \(Z=a+U\) with \(U\subseteq\mathbb F_q\), \(|U|=n\).  Differences inside \(Z\) are
differences inside \(U\), hence rational, hence \(\chi=+1\); so (A) forces
\(\delta=+1\).  Put \(c=a-a^q=ds\) with \(d\in\mathbb F_q^\times\).  For \(i\ne j\),
\[
  z_i-z_j^q=c+w,\qquad w=u_i-u_j\in\mathbb F_q,
\]
and \(N(c+w)=(w+c)(w-c)=w^2-\varepsilon d^2\).  So (B) reads
\(\chi_q(w^2-\varepsilon d^2)=-1\) for every nonzero \(w\in U-U\).  Since
\(\varepsilon d^2\) is a nonsquare the quadratic \(w^2-\varepsilon d^2\) is irreducible,
so \(\sum_{w\in\mathbb F_q}\chi_q(w^2-\varepsilon d^2)=-1\) and the admissible set
\(T_a=\{w:\chi_q(w^2-\varepsilon d^2)=-1\}\) has size exactly \((q+1)/2\).  But
\(|U|=(q+3)/2>q/2\), so by the lemma applied in \((\mathbb F_q,+)\) we get
\(U-U=\mathbb F_q\), forcing \(q-1=|\mathbb F_q^\times|\le|T_a|=(q+1)/2\), i.e.
\(q\le3\).  Case (a) is empty.

**Case (b): \(b\notin\mathbb F_q\).**  Then \(L\) meets \(\mathbb F_q\) in exactly one
point \(r\); translating by \(-r\) (a rational translation, which preserves both (A) and
(B)) we may take \(L=b\,\mathbb F_q\).  Since \(bu\in\mathbb F_q\) only for \(u=0\), we
have \(Z=bU\) with \(U\subseteq\mathbb F_q^\times\), \(|U|=n\).  Scaling \(b\) by
\(\mathbb F_q^\times\) changes nothing, so write \(b=\beta+s\).

Differences inside \(Z\) are \(b(u_i-u_j)\), so \(\chi=\chi(b)\) and (A) is just the
normalization \(\chi(b)=\delta\).  All the content is in (B).  With \(u=u_i\),
\(v=u_j\),
\[
  N(bu-b^qv)=N(b)(u^2+v^2)-\operatorname{Tr}(b^2)\,uv
  =v^2\,g(u/v),\qquad
  g(r)=N(b)(r^2+1)-\operatorname{Tr}(b^2)\,r,
\]
so \(\chi(z_i-z_j^q)\) depends only on the **ratio** \(r=u_i/u_j\).  Here
\(N(b)=\beta^2-\varepsilon\) and \(\operatorname{Tr}(b^2)=2(\beta^2+\varepsilon)\), and
the discriminant of \(g\) is \(16\varepsilon\beta^2\).  If \(\beta=0\) then
\(g(r)=-\varepsilon(r+1)^2\) and \(\chi_q(g(r))=\delta\) for every \(r\ne-1\), so (B)
would force \(u_i+u_j=0\) for all \(i\ne j\), impossible for \(n\ge3\).  Hence
\(\beta\ne0\), the discriminant is a nonsquare, \(g\) is irreducible, and
\(\sum_{r\in\mathbb F_q}\chi_q(g(r))=-\chi_q(N(b))\).  Consequently the admissible ratio
set
\[
  T_b=\{r\in\mathbb F_q^\times:\chi_q(g(r))=-\delta\}
\]
has \(|T_b|\le(q+1)/2\).  Note \(g(1)=-4\varepsilon\), so \(\chi_q(g(1))=\delta\) and
\(1\notin T_b\), consistent with \(r=1\) being the diagonal.

Now \(|U|=(q+3)/2>(q-1)/2=|\mathbb F_q^\times|/2\), so the lemma gives
\(U\cdot U^{-1}=\mathbb F_q^\times\): *every* \(r\in\mathbb F_q^\times\) is a ratio of
two elements of \(U\), and every \(r\ne1\) is a ratio of two *distinct* elements.  Hence
\(\mathbb F_q^\times\setminus\{1\}\subseteq T_b\), giving
\(q-2\le(q+1)/2\), i.e. \(q\le5\).

At \(q=5\) the inequality is an equality: \(|U|=4=|\mathbb F_5^\times|\) forces
\(U=\mathbb F_5^\times\), the required ratio set is
\(\mathbb F_5^\times\setminus\{1\}=\{2,3,4\}\) of size \(3=(q+1)/2\), and \(T_b\) must be
exactly that set.  Both frames realize it. \(\square\)

Restated: for \(q>5\) a coherent system is **line-free**.  In the crown picture, the
clique \(Z\) of size \((q+3)/2\) in \(P(q^2)\) cannot be a subset of an
\(\mathbb F_q\)-line, so it lies inside a maximal clique that is not a line.

**Scope caveat.**  Conditions (A) and (B) are stated in the canonical orientation and
normalization of the earlier passes; they are not invariant under the Möbius action of
\(\mathrm{PGL}(2,q)\) on \(\mathbb F_{q^2}\setminus\mathbb F_q\) — that action twists
\(\chi(z_i-z_j)\) by the coboundary \(\lambda_i\lambda_j\),
\(\lambda_i=\chi(cz_i+d)\), and \(\lambda\) is genuinely non-constant on the \(q=5\)
frames.  Only the triple products (the two-graph) are invariant.  Consequently
"contained in a line" is a condition on the normalized model and Theorem 2 must not be
transported through \(\mathrm{PGL}(2,q)\) to Baer sublines without redoing the twist.

## 4. Coherence expressed on the fiber (gate 2)

The twenty-fourth pass proved the composition normal form: over prime \(q\), every
coherent system is \(Z=R^{-1}(\gamma)\) for monic \(R\in\mathbb F_q[X]\) of degree
\(n=(q+3)/2\) and \(\gamma\in\mathbb F_{q^2}\setminus\mathbb F_q\), with
\(G=(R-\gamma)(R-\gamma^q)\).  Gate 2 asked for (A) and (B) as conditions on
\((R,\gamma)\).  They are conditions of *total splitting after a quadratic twist* on two
explicit resultants.

Define, over \(\mathbb F_{q^2}[Y]\),
\[
  \Delta(Y)=\frac{\operatorname{Res}_X\bigl(R(X)-\gamma,\;R(X+Y)-\gamma\bigr)}{Y^{\,n}},
  \qquad
  \Delta^{*}(Y)=\operatorname{Res}_X\bigl(R(X)-\gamma,\;R(X+Y)-\gamma^q\bigr),
\]
\[
  D(Y)=\operatorname{Res}_X\bigl(R(X)-\gamma,\;Y-(X^q-X)\bigr).
\]
The roots of \(\Delta\) are the \(n(n-1)\) pairwise differences \(z_j-z_i\); the roots of
\(\Delta^{*}\) are the \(n^2\) differences \(z_j^q-z_i\), of which the \(n\) roots of
\(D\) are the conjugate-pair differences.  Fix \(\nu,\nu'\in\mathbb F_{q^2}^\times\) with
\(\chi(\nu)=\delta\) and \(\chi(\nu')=-\delta\).  Then

- (A) holds \(\iff\) \(\Delta(\nu Y^2)\) splits completely over \(\mathbb F_{q^2}\);
- (B) holds \(\iff\) \((\Delta^{*}/D)(\nu' Y^2)\) splits completely over
  \(\mathbb F_{q^2}\).

A useful low-degree necessary consequence, obtained by differentiating
\(G=\Phi\circ R\) with \(\Phi(Y)=(Y-\gamma)(Y-\gamma^q)\): at every \(z\in Z\),
\(G'(z)=(\gamma-\gamma^q)R'(z)\) and also
\(G'(z)=(z-z^q)\prod_{j\ne i}f_j(z)\), whence

> **Derivative-class condition.**  \(\chi\bigl(R'(z)\bigr)=\delta\) for every
> \(z\in R^{-1}(\gamma)\); equivalently
> \(\operatorname{Res}_X(R-\gamma,\;Y-R'(X))\) evaluated at \(\nu Y^2\) splits.

This is implied by (A) alone and costs \(O(n)\) work per candidate, so it is the natural
first filter in any \((R,\gamma)\) census.  The chord-externality condition of the
earlier passes is recovered as
\(\chi_q\bigl(\operatorname{Res}(f_i,f_j)\bigr)=-1\), the product of the (A) and (B)
characters.

The Dickson window remains as recorded: the pure power/Dickson mechanism requires
\(\mu_{(q+3)/2}\subset\mathbb F_{q^2}\), i.e. \((q+3)/2\mid8\), i.e.
\(q\in\{5,13\}\), and \(q=13\) is excluded by the certified audit.

### 2a. The known minimum-support eigenfunction is the neighbouring member

The minimum support of an eigenfunction of \(P(q^2)\) for either non-principal
eigenvalue is \(q+1\) (Goryainov–Kabanov–Shalaginov–Valyuzhenich, *Finite Fields Appl.*
52 (2018) 361–369, Thm 2), and the known optimal one is supported on the norm-one
circle \(C=\{z:z^{q+1}=1\}\), splitting as \(Q_0\sqcup Q_1\) with induced graph
\(K_{(q+1)/2,(q+1)/2}\) (their Lemma 8).  Its interlacing is also tight:
\(\lambda_{\min}(K_{m,m})=-m=-(q+1)/2\).

So the object C756 needs to exclude is the immediate neighbour of a known object.  Put
side by side, in the Paley graph of order \(q^2\):

| support | induced graph | \(\lambda_{\min}\) | Frobenius | status |
|---|---|---|---|---|
| \(q+1\) | \(K_{m,m}\), \(m=(q+1)/2\) | \(-m=-(q+1)/2\) | even (\(Q_0,Q_1\) each stable) | exists; the known minimum |
| \(q+3\) | \(K_{m',m'}\) minus a perfect matching, \(m'=(q+3)/2\) | \(-(m'-1)=-(q+1)/2\) | odd (matching = conjugation) | C756's saturated-internal gate |

Both realize \(\lambda_{\min}\) exactly, so both are as spectrally tight as an induced
subgraph can be.  The classification of the minimum-support eigenfunctions is itself
an open problem in that literature (Sotnikova–Valyuzhenich survey, Problem 11), and no
result exists for any support size between \(q+2\) and \(2q-1\).  A proof that the
second row is empty for \(q>5\) is therefore new in the eigenfunction literature as
well as decisive for C756.

## 5. Consequence: the branch reduces to two classified clique orbits

Theorem 1 makes \(Z\) a clique of size \((q+3)/2\) in a Paley graph of order \(q^2\), and
Theorem 2 says it is not inside an \(\mathbb F_q\)-line.  The clique literature then
takes over.  The relevant published statements are quoted verbatim in
`2026-08-02-c756-paley-eigenfunction-support-literature.md`, §5a; in brief:

- **Blokhuis (1984).**  The only cliques of size \(q\) in \(P(q^2)\) are the lines
  \(a\mathbb F_q+b\) with \(\chi(a)=1\).
- **Baker–Ebert–Hemmeter–Woldar (1996), Goryainov–Kabanov–Shalaginov–Valyuzhenich
  (2018, Thm 1).**  With \(C=\{z:z^{q+1}=1\}\) the norm-one circle, \(Q_0\) its
  index-two subgroup and \(Q_1\) the other coset: for \(q\equiv3\pmod4\),
  \(S_j=Q_j\cup\{0\}\) are maximal cliques of size \((q+3)/2\); for
  \(q\equiv1\pmod4\), \(Q_0,Q_1\) are maximal *cocliques* of size \((q+1)/2\).
- **Gap and two-orbit conjecture (Baker et al.; restated in Brouwer–Goryainov–
  Shalaginov–Yip).**  There is no maximal clique of size \(s\) with
  \((q+\epsilon)/2<s<q\) where \(q\equiv\epsilon\pmod4\), and for \(q\ge25\) the
  second-largest maximal cliques form exactly two orbits.  Extra second-largest maximal
  cliques occur only for \(q\in\{9,11,13,17,19,23\}\) (Chen–Goryainov–Hu), all inside
  the certified \(q\le43\) audit.
  **Verification status matters here and is weaker than it first appears.**  The
  conjecture is proved for no \(q\).  Brouwer et al. assert a check to \(r\le109\) with
  no attribution or method; their published orbit-complete table stops at \(r\le47\)
  (prime powers included), and it shows no maximal clique of size \((q+3)/2\) for any
  \(q\equiv1\pmod4\) up to \(41\) — data, not a theorem.  Yip (*Canad. Math. Bull.*
  2023) writes that on the gap conjecture "no partial progress has been made".  Full
  sourcing, including the failure of every published stability result to apply at Paley
  density, is in the literature report, §6.

> **Theorem 3.**  Assume the gap and two-orbit conjecture for the field \(q\).  Then a
> coherent system with \(q>5\) exists only if \(q\equiv3\pmod4\) and
> \(Z=a\,S_j+b\) for some \(j\in\{0,1\}\), \(\chi(a)=1\), \(b\in\mathbb F_{q^2}\).

*Proof.*  \(Z\) is a clique of size \((q+3)/2\) in \(P(q^2)\) (for
\(q\equiv1\pmod4\), after the isomorphism \(z\mapsto\nu z\), \(\chi(\nu)=-1\), from the
complement; this map carries lines to lines, so Theorem 2 survives it).  Its size lies
strictly between \((q+1)/2\) and \(q\).  If \(Z\) is not maximal it lies in a maximal
clique of larger size, which by the gap conjecture must have size \(q\), hence is a
line by Blokhuis, and Theorem 2 gives \(q=5\).  So \(Z\) is maximal, which for
\(q\equiv1\pmod4\) contradicts the gap conjecture outright (there the second-largest
maximal size is \((q+1)/2<(q+3)/2\)), and for \(q\equiv3\pmod4\) puts \(Z\) in one of
the two orbits.  Finally \(Q_j\) is stable under \(z\mapsto z^{p^i}\), so the orbit of
\(S_j\) under \(\operatorname{Aut}P(q^2)=\{z\mapsto az^{p^i}+b:\chi(a)=1\}\) is
\(\{aS_j+b\}\). \(\square\)

The residual family is tiny.  \(Q_j\) is conjugation-stable (conjugation is inversion
on \(C\)), so \(Z^q=a^qS_j+b^q\) and every crown condition reads
\[
  \chi\bigl(as-a^qs'+c\bigr)=-\delta,\qquad s,s'\in S_j,\ s'\ne s^q,
  \qquad c=b-b^q\in s\,\mathbb F_q .
\]
Thus \(b\) enters only through \(c\), and the entire family is parametrized by
\((a,c,j)\): about \(q^3/2\) cases, exhaustively testable far beyond the current
\(q\le43\) audit.  That check is reported in
`2026-08-02-c756-clique-orbit-crown-check.md`.

### 5a. The residual family dies unconditionally for large \(q\)

> **Theorem 4.**  Let \(q\equiv3\pmod4\) and suppose \(Z=aS_j+b\) is a coherent system,
> \(\chi(a)=1\).  Then \(q\) is bounded: the quadratic-character sum below forces
> \(q\le79\).  Together with an exhaustive check of the family for \(q\le109\), no
> coherent system of this shape exists for any \(q>5\).

*Proof.*  Write \(\mathbb F_{q^2}=\mathbb F_q(\iota)\), \(\iota^2=\varepsilon\), and
parametrize the circle by \(c(t)=(t-\iota)/(t+\iota)\), a bijection
\(\mathbb F_q\cup\{\infty\}\to C\) with \(c(t)^q=c(-t)\) and
\[
  c(t)\in Q_0\iff\chi_q(h(t))=+1,\qquad h(t)=t^2-\varepsilon .
\]
Let \(\xi_j=\pm1\) select \(Q_j\) and \(T_j=\{t:\chi_q(h(t))=\xi_j\}\), so
\(|T_j|=(q\mp1)/2\).  Since \(Q_j\) is conjugation-stable, \(Z^q=a^qS_j+b^q\) and every
crown condition is \(\chi(a\,s-a^q s'+\kappa)=-1\) with \(\kappa=b-b^q=\iota g\),
\(g\in\mathbb F_q\).  For \(s=c(t)\), \(s'=c(t')\) with \(t,t'\in T_j\), clearing the
denominator \((t+\iota)(t'+\iota)\) — whose character is
\(\chi_q(h(t))\chi_q(h(t'))=+1\) — gives \(\chi(W(t,t'))=-1\) with
\[
  W=a(t-\iota)(t'+\iota)-a^q(t+\iota)(t'-\iota)+\kappa(t+\iota)(t'+\iota),
\]
a bilinear form \(W=P(t)\,t'+Q(t)\) over \(\mathbb F_{q^2}\), where with
\(a=a_0+\iota a_1\),
\[
  P=\iota(2a_1+g)\,t+\bigl(\varepsilon g-2\iota a_0\bigr),\qquad
  Q=\bigl(\varepsilon g+2\iota a_0\bigr)t+\iota\varepsilon(g-2a_1).
\]
The condition is \(\chi_q(F(t,t'))=-1\) on \(T_j\times T_j\), where
\[
  F=W\,W^q=N(P)\,t'^2+\operatorname{Tr}(PQ^q)\,t'+N(Q)\in\mathbb F_q[t,t'].
\]

**Key point.**  Because \(F\) is a norm of a form *linear in \(t'\)*,
\[
  \operatorname{disc}_{t'}F=\bigl(PQ^q-P^qQ\bigr)^2=\varepsilon\,L(t)^2,
  \qquad L(t)=2\varepsilon g\bigl[(2a_1+g)t^2-4a_0t+\varepsilon(2a_1-g)\bigr],
\]
using \(PQ^q-P^qQ=\iota L\) with \(L\in\mathbb F_q[t]\).  So whenever \(L(t)\ne0\) the
discriminant is \(\varepsilon\) times a nonzero square, i.e. a **nonsquare**, and
\(F(t,\cdot)\) is an *irreducible* quadratic in \(t'\).  Moreover \(L\equiv0\) forces
\(g=0\) (the bracket cannot vanish identically without \(a=0\)), and \(g=0\) is already
excluded: \(\kappa=0\) makes the condition at \(s'=0\) read \(\chi(as)=-1\) for
\(s\in Q_j\), while \(N(s)=1\) gives \(\chi(s)=+1\) and hence \(\chi(a)=-1\),
contradicting \(\chi(a)=1\).

Therefore \(L\not\equiv0\), and for all but at most five values of \(t\) — the at most
two roots of \(L\), the at most one root of \(N(P)\), and the at most two \(t\) with
\(F(t,\cdot)\) proportional to \(h\) — the polynomials \(F(t,\cdot)\) and
\(F(t,\cdot)h\) are squarefree of degrees \(2\) and \(4\).  Weil then bounds the inner
sums, so with the indicator \((1+\xi_j\chi_q(h))/2\),
\[
  \Bigl|\sum_{(t,t')\in T_j\times T_j}\chi_q(F)\Bigr|
  \le (q-5)\cdot\tfrac{1+3\sqrt q}{2}+5q .
\]
But the coherence condition makes every term \(-1\) except on the antidiagonal
\(t'=-t\) (the conjugate matching), so the same sum has absolute value at least
\(|T_j|^2-2|T_j|\ge (q-1)^2/4-(q+1)\).  Comparing,
\(q^2/4\lesssim\tfrac32q^{3/2}+6q\), which fails for \(q\ge83\). \(\square\)

The proof is uniform in \(j\) and uses only Weil's bound for one-variable quadratic
character sums; the two-variable sum never has to be estimated directly, because the
norm structure makes the inner discriminant a fixed nonsquare.  Note also where
\(q\equiv3\pmod4\) enters: it is what puts \(Z\) in \(P(q^2)\) itself, so that
\(S_j=Q_j\cup\{0\}\) is the relevant maximal clique.

### 5b. What remains

The saturated-internal branch now rests on exactly one external statement.

- For \(q\equiv1\pmod4\): the Baker et al. gap conjecture alone finishes it, since a
  clique of size \((q+3)/2\) would be a maximal clique of forbidden size or would lie
  in a line (Theorem 2).
- For \(q\equiv3\pmod4\): the gap plus two-orbit classification puts \(Z\) in the
  family \(aS_j+b\), and Theorem 4 plus the bounded check kills that family.

So: **modulo the Baker–Ebert–Hemmeter–Woldar gap and two-orbit conjecture, no coherent
system exists for \(q>5\) and the saturated-internal branch is closed.**  The
unconditional range is unchanged in substance — the exhaustive audit at \(q\le43\),
extended to \(q\le47\) if one leans on the published orbit-complete clique table — so
the gain is structural, not numerical.

The unconditional target to aim at is therefore *not* the full gap conjecture, which is
open with no partial progress, but its crown-restricted special case: no maximal clique
of size \((q+3)/2\) in \(P(q^2)\) is completely joined, outside a perfect matching, to
its Frobenius image.  Every published stability result fails at Paley's edge density of
exactly \(1/2\), so a proof will have to use that extra hypothesis rather than a density
argument.

The previous route via the composition normal form is not superseded but is now the
fallback: what follows records it for completeness.

### 5c. The earlier Weil sketch on the fiber side

Parametrize the circle by \(s(t)=(t-\theta)/(t-\theta^q)\), \(t\in\mathbb F_q\cup\{\infty\}\),
for a fixed \(\theta\in\mathbb F_{q^2}\setminus\mathbb F_q\).  Then
\(s(t)\in Q_0\iff\chi_q(h(t))=+1\) with \(h(t)=N(t-\theta)\) an irreducible quadratic,
so \(Q_j\) corresponds to a character-selected set \(T_j\subset\mathbb F_q\) of size
\(\approx q/2\).  Taking \(s'=0\) in the crown condition and writing
\(\alpha=a+c\), \(\beta=a\theta+c\theta^q\), \(P(t)=N(\alpha t-\beta)\),
\[
  \chi\bigl(as(t)+c\bigr)=\chi_q\bigl(P(t)\bigr)\,\chi_q\bigl(h(t)\bigr),
\]
so the condition becomes \(\chi_q(P(t))=-\xi_j\) for every \(t\in T_j\), where
\(\xi_j=\pm1\) selects \(T_j\).  Summing against the indicator
\((1+\xi_j\chi_q(h))/2\) gives
\[
  \tfrac12\sum_t\chi_q(P)+\tfrac{\xi_j}{2}\sum_t\chi_q(Ph)=-\xi_j\bigl(|T_j|-O(1)\bigr).
\]
The right side has size \(\approx q/2\); the left side is \(O(\sqrt q)\) by Weil unless
\(P\) or \(Ph\) is a constant times a square.  Both degeneracies are explicit:
\(Ph\) is a square exactly when \(c=0\), which forces \(\chi(a)=-1\) and is excluded;
\(P\) is a square exactly when \(\beta/\alpha\in\mathbb F_q\).  The surviving
degenerate branch is a single explicit one-parameter family
\(a=-c\,(\theta-\lambda)^{q-1}\), \(\lambda\in\mathbb F_q\), and closing it needs the
genuinely two-variable condition: with both \(s,s'\ne0\) the crown condition becomes
\(\chi_q\bigl(N(M)(t,t')\bigr)=-\delta\) on \(T_j\times T_j\) for an explicit bidegree
\((2,2)\) form \(N(M)\), where the same indicator expansion produces four two-variable
Weil sums of size \(O(q^{3/2})\) against a required \(\approx q^2/4\).

This is the concrete finisher for the saturated-internal branch: an unconditional
character-sum argument for \(q\) above an explicit bound, with the small fields covered
by the certified audit.  It is not yet carried out — the degenerate-locus bookkeeping
for the two-variable sums is the remaining work — and it still rests on the gap
conjecture for the reduction of Theorem 3.

## 6. Verification and replay

`2026-08-02-c756-line-case-verification.py` checks every quantitative step of
Theorem 2 over the prime fields \(q\le43\): the identity \(\chi(s)=\delta\); that
\(g\) has no rational root and \(1\notin T_b\) for every admissible direction; that
\(|T_a|,|T_b|\le(q+1)/2\); and, exhaustively for \(q\le19\), the largest \(U\) whose
ratios (resp. differences) all lie in the admissible set.  The exhaustive maxima are
strictly below the arc size \((q+3)/2\) for every \(q>5\) and equal to it at \(q=5\).
Both frames are exhibited inside their line with \(U=\mathbb F_5^\times\),
\(T_b=\{2,3,4\}\).

`2026-08-02-c756-weil-discriminant-check.py` independently verifies every algebraic
step of Theorem 4 over \(q=7,11,19,23,31,43\): that \(c(t)\) is a bijection onto the
circle with \(c(t)^q=c(-t)\); that \(c(t)\in Q_0\iff\chi_q(t^2-\varepsilon)=+1\); that
the stated \(P,Q\) reproduce \(W\) at every \((t,t')\); that
\(\operatorname{disc}_{t'}F=\varepsilon L(t)^2\) with the stated \(L\); that
\(F(t,\cdot)\) is irreducible whenever \(L(t)\ne0\) and \(N(P(t))\ne0\); and that
\(L\equiv0\) exactly when \(g=0\).  It also counts the exceptional \(t\) at which the
Weil step needs care (\(L(t)=0\), \(N(P(t))=0\), or \(F(t,\cdot)\propto h\)): with
\(g\ne0\) the observed maximum is \(3\), against the \(5\) assumed in the proof.  All
parameters are swept for \(q\le11\) and deterministically sampled above.

```sh
cd notes
python3 2026-08-02-c756-line-case-verification.py
python3 2026-08-02-c756-weil-discriminant-check.py
```

- `2026-08-02-c756-line-case-verification.py`
  `ac31b1d0c6a94b0b3ea0fe64a97fe0a0f1eb28d1d5c0aa2f0f96a1f9d0d6b6a7` (recomputed in the JSON)
- `2026-08-02-c756-line-case-verification.json`

## 6a. TT addendum: the direction map is a Latin square

Directions — classes of \(\mathbb F_{q^2}^\times\) modulo \(\mathbb F_q^\times\) — form
a cyclic group \(C_{q+1}\), and \(\chi\) is constant on each direction, so
\(\chi\) descends to the unique order-two character of \(C_{q+1}\).  This gives a
constraint that uses the bipartite half of the crown, which Theorems 3 and 4 discard.

> **Theorem 5.**  Let \(Z\) be a coherent system, \(n=(q+3)/2\).  Then the array
> \(d(i,j)=\)direction of \(z_i-z_j^q\) is a **Latin square of order \(n\)**: its
> diagonal is constantly the direction of \(s\), and its off-diagonal entries range
> over the \(n-1\) directions of class \(-\delta\), each occurring exactly once in
> every row **and** exactly once in every column.

*Proof.*  Fourier-analytically, \(\hat x\) vanishes on the whole dual line
\(b'\mathbb F_q\) if and only if \(x\) sums to zero on every coset of the line of
direction \(s/b'\).  Now \(\hat x\) vanishes on the nonsquare class (Lemma 1 of the
twenty-fourth pass) and, by Frobenius-oddness \(\hat x(w^q)=-\hat x(w)\), also on the
rational frequencies \(\mathbb F_q\).  Dualizing, the directions along which all line
sums vanish are exactly the \(n-1\) directions of class \(-\delta\) together with the
direction of \(s\) — that is, \(n\) directions in all.

Fix a direction \(b\) with \(\chi(b)=-\delta\) and a line \(\ell\) in that direction.
Any two points of \(Y=Z\sqcup Z^q\) on \(\ell\) differ by an element of class
\(-\delta\).  But differences inside \(Z\), inside \(Z^q\), and across a conjugate pair
all have class \(\delta\).  So \(\ell\) carries at most one point of \(Z\) and at most
one of \(Z^q\), and these are not conjugate; vanishing of the signed sum then forces
\(\ell\cap Y\) to be empty or a pair \(\{z_i,z_j^q\}\) with \(i\ne j\).  Hence each
such \(b\) induces a fixed-point-free perfect matching between \(Z\) and \(Z^q\).  The
\(n-1\) directions give disjoint matchings totalling \((n-1)n\) pairs, which is exactly
the number of cross pairs, so they partition them.  Every direction therefore occurs
once per row and once per column, and \(z_i-z_i^q\in s\mathbb F_q\) gives the constant
diagonal. \(\square\)

Three remarks, one of them a correction to a first version of this claim.  Writing
directions multiplicatively via \(D(i,j)=(z_i-z_j^q)^{q-1}\) in the norm-one circle,
one has unconditionally \(z_j-z_i^q=-(z_i-z_j^q)^q\) and hence
\(D(j,i)=D(i,j)^{-1}\), while the good set \(G\) is closed under inversion.  So the
**column condition follows formally from the row condition** and is not independent
content; only the row condition carries information.  What *is* new is that the row
condition here follows from coherence alone by the Fourier argument, whereas the forced
angle bijection of the twenty-second pass concerned the different quantity
\(f_j(z_i)^{1-q}\) and had to invoke the arc condition.  Its geometric reading is
clean: **no point of \(Z\) lies on an \(\mathbb F_q\)-line containing two points of
\(Z^q\)**.  Third, the obvious group obstruction is already
satisfied and so gives no cheap kill: the product of a row is
\(\prod_{j\ne i}(z_i-z_j^q)=(\gamma-\gamma^q)/(z_i-z_i^q)\in\mathbb F_q^\times\), i.e.
the trivial direction, and the product of all class-\(-\delta\) directions in
\(C_{q+1}\) is indeed trivial in both residue classes of \(q\) modulo 4.

`2026-08-02-c756-direction-latin-square-check.py` verifies the whole statement on both
\(q=5\) frames, including that the line sums vanish on exactly those \(n\) directions
and that rows and columns are both Latin.  Writing this check is what caught the
omission of the \(s\)-direction from a first version of the argument.

**Why this matters.**  This is the internal-branch analogue of the complete-mapping
structure that closed the saturated-*external* branch: there, fixing one matching edge
forced a complete mapping of the cyclic square group, and a group-sum obstruction plus
a Weil/Hasse argument finished it.  The same endgame is now available here, and it does
**not** route through the Baker et al. gap conjecture.  That makes it the highest-value
open attack this pass produces.

## 6b. What the bounded split-fiber census contributes

Full report: `2026-08-02-c756-split-fiber-census.md`.  Three things bear on the
argument above.

- **Theorem 1 is verified empirically, not just proved.**  Across all 119,384
  split-fiber pairs at \(q=5,7,11,13\), the crown characterization agrees with
  coherence in every single case, with zero disagreements.  The census also confirms,
  rather than assumes, that a totally split fiber automatically has distinct irrational
  roots with no conjugate pair.
- **The \(q=5\) solutions have a pure-power normal form.**  Up to the affine group the
  two frames are \((R,\gamma)=(X^4,\zeta)\) with \(\zeta\) a primitive sixth root of
  unity in \(\mathbb F_{25}\).  Since \(X^4=X^{q-1}\) and \(n=q-1\) only at \(q=5\),
  this is a third \(q=5\) coincidence, alongside \(t+1=p-1\) and \((q-1)^2/2=q+3\), and
  it is the same Dickson/power-map window that the fiber route reached from the other
  side.
- **Externality, not the derivative class, does the killing.**  Condition (F2), the
  chord-externality product, already has zero survivors at every \(q\ge7\), while the
  derivative-class filter (F1) still passes 42, 660 and 2106 pairs at \(q=7,11,13\).
  So the derivative-class condition of §4, though free, is the weaker gate.

One incidental correction the census makes to this pass's framing: the naive Poisson
estimate for split-fiber counts overcounts by about \(2.4\times\) and does not converge
to \(1\), because a split fiber can contain no rational element and no conjugate pair.
The corrected model matches all four exact fields and both sampled ones.  The \(q=23\)
and \(q=29\) samples are uninformative rather than negative: the expected hit counts are
\(0.17\) and \(8.5\times10^{-5}\), so uniform sampling is the wrong instrument there.

## 6c. The certified range, extended without the conjecture

Full report: `2026-08-02-c756-clique-orbit-crown-check.md`.  The orbit sweep was run as
specified — every member of the two published maximal-clique orbits \(Z=aS_j+b\) for
every prime power \(q\equiv3\pmod4\) with \(7\le q\le503\), 1,686,529,824 orbit members
in all, zero passes — and every setup assertion about \(C\), \(Q_j\) and the maximality
of \(S_j\) held at all 53 fields.

The more valuable outcome is that the check made the conjecture unnecessary over a large
range.  A coherent system is precisely a clique of size \((q+3)/2\) in the graph on
irrational elements where \(z\sim w\) iff \(\chi(z-w)=\delta\) **and**
\(\chi(z-w^q)=-\delta\); the maps \(z\mapsto az+b\) with \(a\in\mathbb F_q^\times\),
\(b\in\mathbb F_q\) are automorphisms of that graph and act transitively on its
vertices, so a search through the single vertex \(s\) is exhaustive.  That search
returns nothing for every \(q\equiv3\pmod4\) with \(7\le q\le151\), including the prime
powers \(27\), and it recovers exactly the two frames at \(q=5\) as a positive control.

So for \(q\equiv3\pmod4\) the branch is now **unconditionally empty through \(q\le151\)**,
with no dependence on Blokhuis, on the two-orbit classification, or on the gap
conjecture, and with the \(q=27\) extension-field hygiene item discharged along the way.
Theorems 3 and 4 remain the only route to *all* \(q\), but they are no longer what
certifies the small fields.  The corresponding sweep for \(q\equiv1\pmod4\) is queued;
until it lands, that residue class is certified only through the earlier \(q\le43\)
audit.

## 6d. Replacing the census with an exact mechanism

Exhaustive search is the only thing covering the small fields, and small \(q\) is where
character-sum arguments fail: every Weil bound leaves a tail of order \(\sqrt q\), which
is why Theorem 4 reaches down only to \(q\ge83\).  Any structural replacement must
therefore be **exact**, in the style of Theorem 2, whose chain ends in the integer
inequality \(q-2\le(q+1)/2\).  The ranked programme is recorded on the task card; its
two load-bearing observations are:

- Theorems 2 and 4 are one argument on two containers.  A line and the norm-one circle
  are both Baer sublines of \(\mathbf P^1(\mathbb F_{q^2})\), and the known
  minimum-support eigenfunction (support \(q+1\)) is supported exactly on one.  The
  unifying target is that a coherent system inside any Baer subline forces \(q=5\), and
  beyond it the stability conjecture that a \(\pm1\)-valued Frobenius-odd
  \(\lambda_{\min}\)-eigenfunction of support at most \(q+3\) is supported on a Baer
  subline.
- **Both remaining C756 obstructions are now direction theorems.**  Theorem 5 makes the
  saturated branch a statement about a \((q+3)\)-point set meeting every line in
  \((q+1)/2\) directions evenly, and the nonsaturated branch's surviving target is
  already a masked Rédei theorem.  A single Rédei–Szőnyi-type tool for point sets with
  character-restricted differences could close both, which should be weighed before
  choosing where the next pass goes.

## 7. EJ + TT closeout

**EJ.**  Four upgrades came free with this pass and were taken here.

*The route is field-general.*  The composition normal form of the twenty-fourth pass
needed \(q\) prime (its binomial expansion is a prime-field argument).  Theorems 1, 2
and 4 use only \(\mathbb F_q\) arithmetic and Weil's bound, so they hold for every odd
prime power, and the published clique statements are stated for prime powers as well.
The standing \(q=27\) extension-field hygiene item is therefore no longer a gap in this
branch's argument, only in the older fiber-side one.

*"Why \(q=5\)" now has a one-line answer.*  Theorem 2's chain ends in
\(q-2\le(q+1)/2\).  That is an equality precisely at \(q=5\), where the arc must use
every element of \(\mathbb F_5^\times\) as a line coordinate and the admissible ratio
set is exactly the complement of the identity.  The four-frame is not an accident found
by search; it is the unique solution of an inequality that is tight at one field.

*The reformulation is exportable.*  Theorem 1 states C756's saturated gate entirely
inside Paley-graph spectral combinatorics, where the minimum support is known
(\(q+1\)) but its classification is an open problem in that literature and nothing at
all is known for supports \(q+2,\dots,2q-1\).  A proof that support \(q+3\) is empty is
a contribution there on its own terms, independent of arcs and conics.

*The Theorem 4 mechanism is reusable.*  Whenever a condition has the shape "a quadratic
character of a bilinear expression in two circle parameters is constant", the norm
structure makes \(\operatorname{disc}_{t'}\) equal to a nonsquare times a square, so
irreducibility of the inner quadratic is automatic and the two-variable sum never has
to be estimated.  The nonsaturated masked-Rédei target has the same circle
parametrization available and should be re-examined with this tool.

**TT.**  The Tao question — *what is the bounded object?* — has moved twice.  It was
\(G\) of degree \(q+3\); the twenty-fourth pass made it the pair \((R,\gamma)\) of
description length \(O(q)\); it is now the pair \((a,\kappa)\), three field elements,
against \(\Theta(q^2)\) conditions.  That is the real reason a character sum finishes
the job: the overdetermination is finally by a factor of \(q^2\) rather than a constant.

The sharpest skeptical check is whether the reformulation quietly discards a hypothesis.
It does not, and in the safe direction: coherent systems are a *relaxation* of genuine
saturated-internal arcs — Segre's lemma of tangents forces every arc into coherent
form, not conversely — so excluding coherent systems is strictly stronger than needed.

The Tao question about where the argument is wasteful has a clear answer: the reduction
to two clique orbits uses only that \(Z\) is a clique, discarding the whole bipartite
half of the crown.  Acting on that produced Theorem 5 (§6a): the cross-direction array
is a Latin square of order \(n\) with constant diagonal.  Its informative half is the
row condition, obtained from coherence alone rather than from the arc condition as in
the earlier angle bijection — the column half turns out to follow formally.  Decisively,
the resulting family of \(n-1\) derangements is the internal analogue of the complete-mapping structure that
closed the saturated-external branch, so it offers an endgame that bypasses the gap
conjecture entirely.  A second Tao-style reading worth recording: the master polynomial
\(G=(R-\gamma)(R-\gamma^q)\) of the fiber route is precisely the Rédei polynomial of
the clique \(Z\sqcup Z^q\), so the fiber route and the clique route are not
alternatives but one object seen twice — which means Blokhuis' polynomial proof of
\(\omega(P(q^2))=q\) is the natural template to re-run at size \((q+3)/2\) with the
crown as the extra hypothesis.

## 8. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Why does a coherent system exist at \(q=5\) and nowhere else? | settled | Theorem 2: \(q-2\le(q+1)/2\) is tight exactly at \(q=5\) |
| Are coherent systems confined to a line? | settled negatively for \(q>5\) | Theorem 2; for \(q>5\) they must be line-free |
| Is the residual clique-orbit family nonempty? | settled negatively for \(q\ge83\) | Theorem 4, plus the bounded check for smaller \(q\) |
| Can the Baker–Ebert–Hemmeter–Woldar gap conjecture be avoided? | open, and it must be | it is the sole external dependency and has no partial progress in print; the unused crown/bipartite structure is the only visible lever |
| Is there an unconditional bound on non-line cliques of \(P(q^2)\)? | settled negatively | none exists below \(q\); every stability theorem needs edge density \(<1/2\) and Paley sits at exactly \(1/2\).  So \(q\equiv1\pmod4\) does not close unconditionally by any published route |
| Extension fields | settled for this route | Theorems 1, 2, 4 are prime-power-general; only the older fiber-side tower is prime-only |
| Which \(R\) admit totally split irrational quadratic fibers? | superseded as the gate | retained as the fallback route; see the split-fiber census |
| Nonsaturated branch (\(\delta\ge2\), masked Rédei \(h\ge1\)) | untouched | unchanged by this pass; still the blocker for the full all-\(k\) theorem |

Companion computations from this pass are reported separately:
`2026-08-02-c756-split-fiber-census.md` (bounded \((R,\gamma)\) census and the crown
cross-check) and `2026-08-02-c756-paley-eigenfunction-support-literature.md`
(minimum-support and maximal-clique literature).
