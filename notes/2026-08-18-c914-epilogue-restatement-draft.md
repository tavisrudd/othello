# C914 — prepared epilogue restatement, not applied

**Lane:** `cubic-threefolds` · **Date:** 2026-08-18 · **Task:** C914

## Why this is a draft

The epilogue manuscript was under active concurrent edit while this pass ran:
`sections/05-framed-monodromy.tex`, `sections/06-synthesis.tex`,
`lean/verification/claims.json`, `verification/README.md`,
`verification/imported-sources.json`, `verification/evidence.json`,
`sections/01-introduction.tex` and several Lean sources all carried
uncommitted changes, with write timestamps seconds old. Editing the
introduction, the claim map and the evidence registry at the same time would
have collided with that session, so nothing was applied. The evidence-registry
entry that had been added was reverted, and the bundle files that had been
copied under `papers/cubic-stabilization-epilogue/verification/` were removed
again; the paper tree carries no C914 change.

Everything needed to apply the pass is below. The mathematics and the
computation are committed: report
`2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`, scripts
`2026-08-18-c914-a5-pencil-eckardt.py` and
`2026-08-18-c914-a5-pencil-voisin-locus.py` with their tracked outputs.

## Apply order

1. Copy the evidence bundle into the paper:

        cp notes/2026-08-18-c914-a5-pencil-eckardt.py \
           papers/cubic-stabilization-epilogue/verification/a5_pencil_eckardt.py
        cp notes/2026-08-18-c914-a5-pencil-eckardt.txt \
           papers/cubic-stabilization-epilogue/verification/a5-pencil-eckardt.txt
        cd papers/cubic-stabilization-epilogue/verification && \
          sha256sum a5_pencil_eckardt.py a5-pencil-eckardt.txt \
          > a5-pencil-eckardt.sha256

   Rewrite the script's replay docstring to the paper-relative commands:
   `python3 verification/a5_pencil_eckardt.py --sing a5-pencil-eckardt.sing`
   then
   `nix shell nixpkgs#singular --command Singular -q a5-pencil-eckardt.sing`.

2. Register the bundle in `verification/evidence.json` (entry below) and widen
   the file's `note`, which currently says the spine rests on one computation.

3. Insert the two statements below, add their claim-map rows, refresh their
   digests with `python3 lean/verification/refresh_claim_digests.py LABEL`, and
   run `make check`.

4. Replace the closing sentence of the cycle-side paragraph in the
   introduction, as given below.

5. Add the novelty-ledger rows.

## Evidence registry entry

```json
"a5-pencil-eckardt": {
  "role": "Builds the nonstandard A_5-invariant cubic pencil in two independent models of the five-dimensional irreducible A_5-module -- the sum-zero subspace of the permutation module on the six points of P^1(F_5) over Q, and the monomial model induced from a cubic character of a point stabilizer over Q(w) -- verifying in each that the invariant cubics form a pencil, and computes for explicit members the dimension of the affine cone cut out by the equation together with the three-by-three minors of its Hessian.  Cone dimension zero certifies that the member is smooth with empty Eckardt scheme.  Five members of the first model and three of the second come out smooth and Eckardt-free; the Fermat cubic threefold, which lies in the pencil, returns its thirty Eckardt points in both models, and two members of the coprime-degree normal form of Yang, Yu and Zhu return nonempty Eckardt schemes.  It does not compute the finite exceptional set of the pencil, and it certifies nothing about singular members.",
  "checksum_manifest": "verification/a5-pencil-eckardt.sha256",
  "commands": [
    "python3 verification/a5_pencil_eckardt.py --sing a5-pencil-eckardt.sing",
    "nix shell nixpkgs#singular --command Singular -q a5-pencil-eckardt.sing"
  ]
}
```

## Statement for `sections/02-envelope.tex`

Insert after the paragraph beginning "For the cycle-theoretic argument, the
unordered pair is enough", which is where the exotic kernel has just been
pinned down.

```latex
\begin{proposition}[No elliptic-product route]
\label{prop:no-elliptic-product}
\coverage{absent}%
\uses{prop:principal-gluing-packet, lem:relative-six-axis,%
  prop:six-axis-polarization}%
Let \(J\) be the intermediate Jacobian of the geometric generic fibre of the
nonstandard \(A_5\)-pencil and let
\[
 \mu:\prod_{i=1}^{k}(A_i,\Theta_i)\longrightarrow(J,\Theta)
\]
be an isogeny of odd degree from a product of principally polarized abelian
varieties with \(\mu^*\Theta=m\sum_i\Theta_i\) and \(m\) odd.  Then either
\(k=1\), or \(k=2\) and the two factors have dimensions one and four.  The
second case occurs: every axis \(H\in\Omega\) produces such a \(\mu\), with
\(A_1\) an elliptic curve isogenous to \(\mathcal E\).  In particular \(J\) is
not odd-degree isogenous to a product of five elliptic curves, although
\(J\sim\mathcal E^5\).
\end{proposition}

\begin{proof}
Write \(N=\mathbf Z^\Omega/\mathbf Z\mathbf1\) with the form \(6I_6-J_6\) of
Proposition~\ref{prop:six-axis-polarization}, let \(M=H_1(\mathcal E,\mathbf
Z)\) with its symplectic form \(\sigma\), and put \(L=H_1(J,\mathbf Z)\), so
that \(f_*\) identifies \(H_1(\mathcal A,\mathbf Z)\) with \(N\otimes M\) and
\eqref{eq:six-axis-polarization-pullback} makes \(L/(N\otimes M)=\ker f\).

At the geometric generic point \(\mathcal E\) has no complex multiplication, so
the endomorphism algebra of the weight-one Hodge structure \(M_{\mathbf Q}\) is
\(\mathbf Q\).  With \(H_1(J,\mathbf Q)=W_5\otimes M_{\mathbf Q}\) and
polarization form \(q\otimes\sigma\), every sub-Hodge structure is therefore
\(U\otimes M_{\mathbf Q}\) for a subspace \(U\subseteq W_5\), and an orthogonal
decomposition into sub-Hodge structures comes from a \(q\)-orthogonal
decomposition of \(W_5\).

The image \(L'=\mu_*\bigl(\bigoplus_iH_1(A_i,\mathbf Z)\bigr)\) is a sublattice
of odd index which is the orthogonal direct sum of the
\(L\cap(U_i\otimes M_{\mathbf Q})\), each carrying \(m\) times a unimodular
alternating form.  Since \(m\) is odd, each summand is unimodular at two.
Localized at two, therefore, both \(N\) and \(N_1=N^\vee\cap\tfrac12N\) split
along the \(U_i\), and so does the coefficient heart \(H_2=N_1/N\).

By Proposition~\ref{prop:principal-gluing-packet} the two-primary kernel is one
of the exotic graphs: two-adically an element of \(L\) is a pair \((a,b)\) of
vectors of \(N_1\) whose classes satisfy \([b]=\omega^{\pm1}[a]\).  If it lies
in \(U_i\otimes M\) then both classes lie in the summand \(H_2^{(i)}\), so
\(\omega H_2^{(i)}\subseteq H_2^{(i)}\): each summand is an \(\F_4\)-subspace
and has even dimension over \(\F_2\).

The decomposition \(H_2=\bigoplus_iH_2^{(i)}\) is orthogonal for
\(b(x,y)=\operatorname{Tr}_{\F_4/\F_2}\det(x,y)\).  An \(\F_4\)-line
\(\ell=\F_4x\) is totally isotropic, because \(\det(x,ax)=a\det(x,x)=0\), and
\(b\) is nondegenerate, so \(\ell^\perp=\ell\).  Two \(\F_4\)-lines orthogonal
to one another therefore coincide and cannot be complementary.  As \(H_2\) has
\(\F_4\)-dimension two, one summand must carry all of it.  The discriminant
group of a lattice of rank \(r\) needs at most \(r\) generators, so that
summand has \(\dim U_i\ge4\), leaving \(k=1\) or \(k=2\) with dimensions four
and one.

For the second case let \(v\in N\) be the class of an axis, so \(q(v,v)=5\).
Since \(5\) is a unit at two, \(N\otimes\mathbf Z_2\) is the orthogonal sum of
\(\mathbf Z_2v\) and \(N\cap v^\perp\), and the first summand is unimodular, so
the whole coefficient heart is carried by the second.  Hence, two-adically,
\(L\) is the orthogonal sum of \(L\cap(\mathbf Qv\otimes M)\) and
\(L\cap(v^\perp\otimes M)\), both unimodular; the index of that sum in \(L\) is
odd, and shrinking each summand by an odd index makes both forms \(m\) times a
unimodular one for one odd \(m\).  The first summand has rank two and gives an
elliptic curve isogenous to \(\mathcal E\); the second has rank eight.
\end{proof}

\begin{remark}
\label{rem:voisin-route}
\coverage{absent}%
Voisin's components of codimension at most three are produced by an odd-degree
isogeny to the Jacobian of a possibly reducible curve
\cite[proof of Theorem~4.5]{Voisin}.  A principally polarized abelian variety
of dimension at most three is such a Jacobian, so the route is automatic for a
family whose intermediate Jacobian splits off factors of dimension at most
three.  Proposition~\ref{prop:no-elliptic-product} closes that route here: the
only splitting available carries a four-dimensional factor, and the route would
need it to be the Jacobian of an irreducible curve of genus four.  Whether it
is remains open.
\end{remark}
```

## Statements for `sections/03-minimal-class.tex`

Insert before `prop:A5-nonseparated`.

```latex
\begin{lemma}[Eckardt criterion]
\label{lem:eckardt-rank}
\coverage{absent}%
Let \(X=\{F=0\}\subset\PP^4\) be a smooth cubic threefold and let \(p\in X\).
The tangent hyperplane section \(T_pX\cap X\) is a cone with vertex \(p\) if
and only if the Hessian matrix of \(F\) at \(p\) has rank at most two.  Two
families always contain such a point: a smooth cubic threefold whose defining
form is a sum of cubic forms in pairwise disjoint nonempty groups of at most
three variables, and every member of the family of \cite[Theorem~3.3]{YYZ}.
\end{lemma}

\begin{proof}
Choose coordinates with \(p=[1:0:0:0:0]\) and write
\(F=x_0^2L+x_0Q+C\) with \(L\), \(Q\), \(C\) in \(x_1,\dots,x_4\).  Smoothness
at \(p\) makes \(L\) nonzero, and the tangent hyperplane is \(\{L=0\}\); the
section is a cone with vertex \(p\) exactly when \(Q\) vanishes on
\(\{L=0\}\), that is when \(Q\in(L)\).  The second polar of \(F\) at \(p\) is
the quadric \(4x_0L+2Q\), whose matrix is the Hessian at \(p\).  If \(Q=LM\)
that quadric is \(L(4x_0+2M)\), of rank at most two.  Conversely a quadric of
rank at most two is a product of two linear forms; the coefficient of
\(x_0^2\) vanishes, so at most one factor involves \(x_0\), and if neither did
then \(L\) would vanish.  Comparing the terms linear in \(x_0\) shows the other
factor is proportional to \(L\), so \(Q\in(L)\).

For the separated-variable form, the parts of a partition of five into parts of
size at most three either include a part of size two or consist of parts of
sizes three and one and one, or of five parts of size one; in the last two
cases there are at least two parts of size one.  If a part has size two, its
binary cubic has a nonzero root, and the corresponding point of \(\PP^4\) lies
on \(X\); if two parts have size one, say with cubic coefficients \(c\) and
\(c'\), both nonzero by smoothness, take a point whose only nonzero
coordinates \(a,b\) satisfy \(ca^3+c'b^3=0\).  At such a point every diagonal
block of the Hessian belonging to another part vanishes, because a cubic form
has vanishing Hessian at the origin, so the rank is at most two.

For the family of \cite[Theorem~3.3]{YYZ} take \(p=[1:0:0:0:0]\).  It lies on
the threefold, the tangent hyperplane there is \(\{x_3=0\}\), and the
restriction of the equation to that hyperplane does not involve \(x_1\), so the
section is a cone with vertex \(p\).
\end{proof}

\begin{proposition}[Finite coprime-degree intersection]
\label{prop:A5-not-coprime}
\coverage{absent}%
\uses{lem:eckardt-rank}%
\evidence{a5-pencil-eckardt}%
Only finitely many points of \(M_{H_1}\) are represented by smooth cubic
threefolds projectively equivalent to a member of the family of
\cite[Theorem~3.3]{YYZ}.
\end{proposition}

\begin{proof}
Inside \(B^\circ\times\PP^4\) the locus of pairs \((b,p)\) with \(p\in X_b\)
and \(\operatorname{rank}\operatorname{Hess}F_b(p)\le2\) is closed, and the
projection to \(B^\circ\) is proper, so the set of parameters whose member
carries an Eckardt point is closed.  It is not everything: the members
\((1,1)\), \((1,2)\), \((1,3)\), \((2,1)\) and \((0,1)\) of the six-coordinate
model, and \((1,1)\), \((1,2)\) and \((1,-3)\) of the monomial model, are
smooth with empty Eckardt scheme.  Hence that set is finite.  Carrying an
Eckardt point is invariant under projective equivalence, and by
Lemma~\ref{lem:eckardt-rank} every member of the family of
\cite[Theorem~3.3]{YYZ} carries one.
\end{proof}
```

Optional, and recommended separately: the same lemma reproves
`prop:A5-nonseparated` in two lines, which would remove that proof's reliance
on the closedness and irreducibility statements of \cite{Hartlieb}. Its
statement, and therefore its claim-map digest, is unchanged.

## Introduction

In the cycle-side paragraph, replace

> We do not claim that the \(A_5\)-curve is generically disjoint from the
> coprime-degree locus of \cite{YYZ} or from every other previously known part
> of Voisin's algebraic-minimal-class locus.

by

> Proposition~\ref{prop:A5-not-coprime} places all but finitely many moduli
> points of that pencil outside the coprime-degree locus of \cite{YYZ} as well:
> every member of their normal form carries an Eckardt point, and the general
> member of the pencil carries none.  On the Voisin side,
> Proposition~\ref{prop:no-elliptic-product} shows that the intermediate
> Jacobian of the geometric generic fibre admits no odd-degree isogeny from a
> product of elliptic curves, although it is isogenous to \(E^5\); the
> construction of Voisin's components therefore does not reach this pencil
> through a product of factors of dimension at most three.  We do not claim
> that the pencil is disjoint from Voisin's locus, which would need the
> four-dimensional factor of Proposition~\ref{prop:no-elliptic-product} not to
> be a curve Jacobian.

## Claim-map rows

Three rows, all `absent`, no declarations.

- `lem:eckardt-rank` — objects: smooth cubic threefolds in projective
  four-space, their tangent hyperplane sections, the Hessian of the defining
  form, the separated-variable class of Colliot-Thélène and the coprime-degree
  normal form of Yang, Yu and Zhu. Hypotheses: smoothness. Conclusion: the cone
  condition at a point equals rank at most two for the Hessian there, and both
  named families contain such a point. Cautions: not formalized; the argument
  is a coordinate computation with the ambient projective geometry outside the
  companion's scope.
- `prop:A5-not-coprime` — objects: the coarse-moduli image of the pencil and
  the coprime-degree family. Hypotheses: smoothness of the members, and the
  computed emptiness of the Eckardt scheme of the listed members. Conclusion:
  the pencil meets the coprime-degree locus in at most finitely many moduli
  points. Cautions: not formalized; rests on the registered evidence bundle,
  which does not identify the finite exceptional set.
- `prop:no-elliptic-product` — objects: the intermediate Jacobian of the
  geometric generic fibre, the six-axis source lattice with the form
  \(6I_6-J_6\), its coefficient heart with the commutant \(\F_4\), and
  odd-degree isogenies from products of principally polarized abelian
  varieties. Hypotheses: the exotic two-primary gluing kernel, the non-CM
  elliptic factor, and odd degree with an odd polarization multiple.
  Conclusion: at most two factors, of dimensions one and four, and that
  splitting exists. Cautions: not formalized; the statement is about the
  lattice model established earlier in the paper, and the CM fibres are
  excluded by hypothesis.

## Novelty-ledger rows

Two rows: the coprime-degree separation of the pencil (new here; the Eckardt
criterion itself is classical), and the closure of the elliptic-product route
into Voisin's components (new here, and dependent on this paper's own packet
proposition).
