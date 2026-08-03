# C756 — the invariant half as a clique problem (twenty-eighth pass, gate 1)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
attacking gate 1 (the Baer-subline stability statement)

## Verdict

The pass did not prove the stability statement.  It found something better shaped: the
saturated-internal branch splits cleanly by the residue class of \(q\), and one half of it
falls to an argument that uses **neither** condition (A) **nor** the Paley-eigenfunction
machinery gate 1 was aiming to import.

Drop condition (A) entirely and keep only the \(\mathrm{PGL}(2,q)\)-invariant part of
coherence — chord externality.  What remains is a pure finite-geometry clique problem:

> \(\Gamma_q\): vertices are the \(q(q-1)/2\) internal points of a nonsingular conic in
> \(\mathrm{PG}(2,q)\); two are adjacent when the line joining them misses the conic.
> A coherent system of size \(n=(q+3)/2\) is, in particular, a \(\Gamma_q\)-clique of that
> size.

So \(\omega(\Gamma_q)<n\) kills the branch outright at that field.  The computation says
this happens exactly in one residue class:

| \(q\bmod4\) | \(\omega(\Gamma_q)\) | versus \(n=(q+3)/2\) |
|---|---|---|
| \(3\) | \((q+3)/2\) | equal — the relaxation **cannot** decide this class |
| \(1\), \(q>5\) | \((q+1)/2\) | one short — the branch is **empty**, with no use of (A) |
| \(q=5\) | \(4=(q+3)/2\) | equal — the two frames survive, as they must |

verified for every odd prime power \(q\le49\).  Theorem 10 below proves the mechanism
behind both rows exactly and unconditionally, for the cliques anchored on an external
line; the general bound for \(q\equiv1\pmod4\) is the new gate.

The routing consequence is sharper than the numbers.  The twenty-seventh pass localized the
failure of \(\mathrm{PGL}(2,q)\)-invariance entirely in condition (A) and concluded that
projective tools are available on the bipartite half.  This pass shows what that division of
labour actually buys: the invariant half alone settles \(q\equiv1\pmod4\), and it
**provably cannot** settle \(q\equiv3\pmod4\), because the extremal configuration
— an external line's internal points together with its pole — is a genuine
\((q+3)/2\)-clique there.  Any proof for \(q\equiv3\pmod4\) must use (A) or the arc
condition; no invariant argument will do it.

## 1. The relaxation, and why it is legitimate

Conventions as in the twenty-sixth and twenty-seventh passes:
\(\mathbb F_{q^2}=\mathbb F_q(s)\), \(s^2=\varepsilon\) a fixed nonsquare,
\(t=(q+1)/2\), \(n=t+1=(q+3)/2\), \(\delta=(-1)^t\), and for irrational \(z_i,z_j\),
\(\alpha_{ij}=N(z_i-z_j)\), \(\beta_{ij}=N(z_i-z_j^q)\).  A coherent system is a set
\(Z\) of \(n\) irrational elements with

- (A) \(\chi_q(\alpha_{ij})=\delta\) for \(i\ne j\)  (the independence half);
- (B) \(\chi_q(\beta_{ij})=-\delta\) for \(i\ne j\)  (the bipartite half).

Two elementary observations put \(Z\) into the plane.  First, \(z_j\ne z_i^q\) for \(i\ne j\),
since otherwise \(\beta_{ij}=0\) and (B) fails; so the \(n\) elements give \(n\) **distinct**
conjugate pairs.  Second, a conjugate pair is a point of \(\mathrm{PG}(2,q)\) in the
binary-quadratic model — the monic quadratic \(X^2-\operatorname{Tr}(z)X+N(z)\), read as the
point \([1:-\operatorname{Tr}(z):N(z)]\) — and it is internal exactly because that quadratic
is irreducible.  Third, (A) and (B) together give
\[
  \chi_q(\alpha_{ij}\beta_{ij})=\delta\cdot(-\delta)=-1 ,
\]
and \(\alpha_{ij}\beta_{ij}=\operatorname{Res}(F_i,F_j)\) is exactly the resultant of the two
quadratics.  Writing \(Q\) for the discriminant form and \(B\) for its polarization,
\(\operatorname{Res}(F_i,F_j)=B(v_i,v_j)^2-Q(v_i)Q(v_j)\), which is a quarter of the
discriminant of \(t\mapsto Q(v_i+tv_j)\); so \(\chi_q(\operatorname{Res})=-1\) says precisely
that the line \(v_iv_j\) meets the conic in no rational point.  This is the project's
condition (E), and it is the whole of the \(\mathrm{PGL}(2,q)\)-invariant content of
coherence (twenty-seventh pass, Theorem 9: given (A), condition (B) is
\(\chi_q(1-g_{ij})=-1\)).

Hence: **every coherent system is a \(\Gamma_q\)-clique of size \((q+3)/2\)**, and the
converse fails only by the amount of information carried by (A).  \(\Gamma_q\) is regular of
degree \((q^2-1)/4\): an internal point lies on \((q+1)/2\) external lines, each carrying
\((q+1)/2\) internal points.

The relaxation is worth taking because \(\Gamma_q\) is a classical object with no arithmetic
normalization in it, so the projective machinery the twenty-seventh pass unlocked applies
without caveat.

## 2. Theorem 10 — the external line and its pole

The obvious large cliques are the external lines.  If \(\ell\) misses the conic it carries
\((q+1)/2\) internal points \(C_\ell\), and any two of them are joined by \(\ell\) itself, so
\(C_\ell\) is a clique.  Thus \(\omega(\Gamma_q)\ge(q+1)/2\) for every odd \(q\), with no
work at all.  The whole question is whether one more point fits.

> **Theorem 10.**  Let \(q\) be an odd prime power, \(\ell\) an external line with pole
> \(P_0=\ell^{\perp}\), and \(P\) an internal point not on \(\ell\).  Then \(P\) is joined
> to every point of \(C_\ell\) by an external line if and only if
> \(P=P_0\) and \(q\equiv3\pmod4\).
>
> Consequently a \(\Gamma_q\)-clique containing a whole \(C_\ell\) has size at most
> \((q+3)/2\) for \(q\equiv3\pmod4\), attained only by \(C_\ell\cup\{P_0\}\), and at most
> \((q+1)/2\) for \(q\equiv1\pmod4\).

*Proof.*  Work in the three-dimensional quadratic space \((V,Q)\) of binary quadratic forms,
normalizing every internal point to a vector of norm exactly \(\varepsilon\) — possible since
\(Q(\lambda v)=\lambda^2Q(v)\) and internal means \(Q(v)\in\varepsilon(\mathbb F_q^\times)^2\).
For two such vectors set \(b(u,v)=B(u,v)/\varepsilon\), so that
\(\operatorname{Res}=\varepsilon^2(b^2-1)\) and adjacency reads
\[
  \chi_q\bigl(b(u,v)^2-1\bigr)=-1. \tag{2.1}
\]

*The pole.*  \(\ell=v_0^{\perp}\), so \(b(v_0,w)=0\) for every \(w\in C_\ell\), and (2.1)
becomes \(\chi_q(-1)=-1\), i.e. \(q\equiv3\pmod4\).  This is case (i), and it is uniform in
\(w\): the pole is joined to *all* of \(C_\ell\) externally, or to none of it.

*Any other point.*  Let \(U=v_0^{\perp}\), a two-dimensional space; \(\ell\) external means
\(Q|_U\) is anisotropic, so \(U\cong\mathbb F_{q^2}\) with \(Q|_U=\mu N\) for some
\(\mu\in\mathbb F_q^\times\), and \(B|_U(x,y)=\tfrac{\mu}{2}\operatorname{Tr}(xy^q)\).  Then
\(C_\ell\) is the norm-sphere \(\{w:N(w)=\varepsilon/\mu\}\), of size \(q+1\) as vectors and
\((q+1)/2\) as points.  Write \(v=\beta v_0+v'\) with \(v'\in U\), so
\(Q(v')=\varepsilon(1-\beta^2)\); put \(\lambda=1-\beta^2\), and note \(P\notin\ell\) means
\(\beta\ne0\), while \(P\ne P_0\) means \(\lambda\ne0\).  Fixing \(w_0\) with
\(N(w_0)=\varepsilon/\mu\) and putting \(\xi=v'w_0^q\), the numbers \(b(v,w)\), as \(w\) runs
over \(C_\ell\), are
\[
  b=\tfrac{\mu}{2\varepsilon}\operatorname{Tr}(\zeta),\qquad
  \zeta\ \text{ranging over}\ \{N(\zeta)=\nu\},\qquad
  \nu=N(\xi)=\varepsilon^2\lambda/\mu^2 .
\]
Set \(k=\mu/(2\varepsilon)\) and \(\rho=k^{-2}=4\varepsilon^2/\mu^2\); \(\rho\) is a square,
say \(\rho=r^2\), and \(4\nu=\rho\lambda\).  Substituting \(\tau=\operatorname{Tr}(\zeta)=r\sigma\)
turns \(\chi_q(\tau^2-4\nu)\) into \(\chi_q(\sigma^2-\lambda)\) and the adjacency condition
\(\chi_q(k^2\tau^2-1)=-1\) into \(\chi_q(\sigma^2-1)=-1\).  The traces actually attained by
\(\{N(\zeta)=\nu\}\) are exactly the \(\tau\) with \(\chi_q(\tau^2-4\nu)=-1\), together with
\(\tau=\pm2\sqrt\nu\) when \(\nu\) is a square.  So adjacency to all of \(C_\ell\) is
\[
  S_\lambda\subseteq S_1,\qquad S_\theta:=\{\sigma:\chi_q(\sigma^2-\theta)=-1\},
  \tag{2.2}
\]
together with \(\chi_q(\lambda-1)=-1\) in case \(\chi_q(\nu)=\chi_q(\lambda)=+1\).

Now \(|S_\theta|=(q-1)/2\) if \(\chi_q(\theta)=+1\) and \((q+1)/2\) if \(\chi_q(\theta)=-1\),
by \(\sum_\sigma\chi_q(\sigma^2-\theta)=-1\).  Since \(|S_1|=(q-1)/2\), (2.2) forces
\(\chi_q(\lambda)=+1\) and then \(S_\lambda=S_1\).  Write \(\lambda=m^2\).  Equality of the
two sets gives two facts: \(m\notin S_\lambda\) (as \(\chi_q(0)=0\)) hence \(m\notin S_1\)
hence \(\chi_q(\lambda-1)=+1\); and \(1\notin S_1\) hence \(1\notin S_\lambda\) hence
\(\chi_q(1-\lambda)=+1\).  But \(\chi_q(\lambda)=+1\) also triggers the second requirement
of (2.2), namely \(\chi_q(\lambda-1)=-1\), contradicting the first fact.  So no \(P\) other
than the pole qualifies, for any odd prime power. \(\square\)

Two remarks.  The contradiction is exact — an equality of two integers \((q\pm1)/2\) and then
a sign clash — in the style the branch requires, with no character-sum tail.  And the two
facts \(\chi_q(\lambda-1)=\chi_q(1-\lambda)=+1\) would on their own force
\(\chi_q(-1)=+1\), i.e. \(q\equiv1\pmod4\); the rational-trace requirement is what removes
that residue class as well.  Dropping it would leave a genus-one sum
\(\sum_\sigma\chi_q((\sigma^2-1)(\sigma^2-\lambda))=q-4\) and a Weil bound giving only
\(q\le16\), so the exact route is strictly stronger than the analytic one.  Empirically the
set condition \(S_\lambda=S_1\) alone does have solutions — two of them at \(q=9\) — and the
rational-trace clause is exactly what kills them; the verification records both.

## 3. The residue-class dichotomy

\(\omega(\Gamma_q)\), computed exhaustively (vertex-transitive, so anchored at one vertex):

| \(q\) | \(q\bmod4\) | internal points | \(\omega(\Gamma_q)\) | \((q+1)/2\) | \(n=(q+3)/2\) | branch |
|---:|---:|---:|---:|---:|---:|---|
| 5  | 1 | 10   | 4  | 3  | 4  | survives (the two frames) |
| 7  | 3 | 21   | 5  | 4  | 5  | undecided by \(\Gamma\) |
| 9  | 1 | 36   | 5  | 5  | 6  | **empty** |
| 11 | 3 | 55   | 7  | 6  | 7  | undecided by \(\Gamma\) |
| 13 | 1 | 78   | 7  | 7  | 8  | **empty** |
| 17 | 1 | 136  | 9  | 9  | 10 | **empty** |
| 19 | 3 | 171  | 11 | 10 | 11 | undecided by \(\Gamma\) |
| 23 | 3 | 253  | 13 | 12 | 13 | undecided by \(\Gamma\) |
| 25 | 1 | 300  | 13 | 13 | 14 | **empty** |
| 27 | 3 | 351  | 15 | 14 | 15 | undecided by \(\Gamma\) |
| 29 | 1 | 406  | 15 | 15 | 16 | **empty** |
| 31 | 3 | 465  | 17 | 16 | 17 | undecided by \(\Gamma\) |
| 37 | 1 | 666  | 19 | 19 | 20 | **empty** |
| 41 | 1 | 820  | 21 | 21 | 22 | **empty** |
| 43 | 3 | 903  | 23 | 22 | 23 | undecided by \(\Gamma\) |
| 49 | 1 | 1176 | 25 | 25 | 26 | **empty** |

Both residue classes and four extension fields \(9,25,27,49\) are covered, so the law is
about \(q\bmod4\) and not about primality.  In every \(q\equiv3\pmod4\) row the maximum is
attained by \(C_\ell\cup\{P_0\}\) — Theorem 10 case (i) — and the pole extension works for
every one of the \(q(q-1)/2\) external lines.  It is not the *only* maximum clique beyond
\(q=7\): the counts of maximum cliques are \(21,220,855,759\) at \(q=7,11,19,23\) against
\(21,55,171,253\) external lines, so further orbits exist and a classification of the
extremal configurations is not in hand.

In the \(q\equiv1\pmod4\) rows the maximum is \((q+1)/2\), so \(C_\ell\) itself is extremal;
at \(q=17\) the maximum cliques are exactly the \(136\) external lines, while at \(q=13\)
there are \(1716\), so again the extremal family is not a single orbit.

## 4. What this closes, and what it does not

**Closes.**  For every \(q\equiv1\pmod4\) with \(5<q\le49\), the saturated-internal branch is
empty by an argument that never mentions condition (A), the Paley graph, Baer sublines, or
the Baker–Ebert–Hemmeter–Woldar conjecture.  That is a new *mechanism*, not new *range*: the
twenty-fifth pass's exhaustive coherence search already covers \(q\le151\) unconditionally.
The value is that the surviving general statement,
\[
  \omega(\Gamma_q)\le(q+1)/2\quad\text{for }q\equiv1\pmod4,\ q>5,
\]
is a clean question about internal points and external lines in \(\mathrm{PG}(2,q)\), with no
arithmetic normalization, and it would close half the branch for **all** fields at once.
Currently \(q\equiv1\pmod4\) is closed only under the gap and two-orbit conjectures
(twenty-fifth pass, Theorem 3).

**Does not.**  It says nothing about \(q\equiv3\pmod4\), and Theorem 10 explains why in a way
that is itself worth having: the configuration \(C_\ell\cup\{\ell^{\perp}\}\) really is a
\((q+3)/2\)-clique there, so no invariant argument can reach a contradiction.  For that class
the branch needs condition (A) — which is exactly what the pole configuration should be tested
against, since a coherent system for \(q\equiv3\pmod4\) that happened to be line-anchored
would have to *be* \(C_\ell\cup\{\ell^{\perp}\}\).  That is a bounded, concrete successor test
and it is not run here.

**A boundary that should be stated plainly.**  \(\Gamma_q\)-cliques ignore the arc condition
(no three points collinear), and the maximum \(\Gamma_q\)-cliques are as far from arcs as
possible — \((q+1)/2\) collinear points plus one.  Imposing the arc condition collapses the
maximum drastically: the largest conic-external set of internal points with no three collinear
is \(4,3,4,5,6,6,6,6\) at \(q=5,7,9,11,13,17,19,23\), consistent with the project's recorded
\(m(q)=\sqrt{2q}+O(1)\).  Nothing here is a route to bounding *that* quantity in general — the
difficulty of the branch has always been that no general bound on conic-external arcs is
available, and this pass does not supply one.  What it does supply is the observation that
half the residue classes do not need one.

**Gate 1's framing, corrected in one respect.**  The Baer-subline stability statement is
sufficient for the branch, as the twenty-sixth pass established.  It is also *necessary* if
the branch is true, hence vacuous for \(q>5\), so it is not a logical weakening of the target
— its value is entirely methodological, as an invitation to import eigenfunction-support
technique.  Two facts limit that import.  First, the Baker–Ebert–Hemmeter–Woldar cliques
\(a(Q_j\cup\{0\})+b\) have size \((q+3)/2\) and lie on no Baer subline (twenty-sixth pass,
§5), so condition (A) alone can never yield the stability conclusion; any proof must use (B).
Second, the twenty-sixth pass's own table shows an (A)+(B) configuration places at most about
\(\sqrt q\) points on any circle, so for \(q\ge7\) the only realizable container is an affine
line, already closed by Theorem 2.  Gate 1 is therefore not "one small lemma away".  The
\(\Gamma_q\) bound above is proposed as a replacement target for the \(q\equiv1\pmod4\) half:
same sufficiency, but classical, invariant, and with its extremal configurations already
identified.

## 5. Verification

`2026-08-02-c756-invariant-half-clique.py` checks, for every odd prime power \(q\le49\):

- the two models agree — the conjugate-pair model on \(\mathbb F_{q^2}\) built from
  \(\chi_q(\alpha\beta)=-1\) and the binary-quadratic model of \(\mathrm{PG}(2,q)\) built
  from \(\chi_q(B^2-QQ')=-1\) give the same degree sequence and the same clique number;
- \(|\text{internal}|=q(q-1)/2\) and \(\Gamma_q\) is regular of degree \((q^2-1)/4\);
- \(\omega(\Gamma_q)\) by an exhaustive coloured branch-and-bound anchored at one vertex;
- every external line's internal points form a clique of size \((q+1)/2\);
- the pole extends that clique for **all** external lines when \(q\equiv3\pmod4\) and for
  **none** when \(q\equiv1\pmod4\);
- no non-pole internal point off \(\ell\) ever extends \(C_\ell\) — Theorem 10's second case,
  brute-forced over all pairs \((\ell,P)\);
- the set condition \(S_{m^2}=S_1\), recorded separately: empty except at \(q=9\), where the
  two solutions are killed by the rational-trace clause, as the proof predicts;
- at \(q=5\), that all ten coherent systems are \(\Gamma_5\)-cliques of size four;
- the arc-constrained maximum quoted in §4, for \(q\le23\).

```sh
cd notes
python3 2026-08-02-c756-invariant-half-clique.py
```

Artifacts and hashes:

- `2026-08-02-c756-invariant-half-clique.py`
  `2e04d757e958fcd67628b3cba472aaaeaa2575ea4f925bf6390fbc6c569435cf`
- `2026-08-02-c756-invariant-half-clique.json`
  `f678ae7ba15c33a437679e67e3a185151e323ca10edf99bd1e3e0d78bc093659`

The independent replay is the twenty-fifth pass's exhaustive coherence search
(`2026-08-02-c756-clique-orbit-crown-check.md`), which found no coherent system for
\(5<q\le151\) by an unrelated method and is consistent with every row above; and, inside this
script, the cross-model agreement, since the two graphs are built from different formulas in
different ambient objects and are compared only through their outputs.

## 6. EJ + TT closeout

**EJ.**  Three things came free and are taken.

*The knife-edge is explained, not just observed.*  Three earlier passes ended on integer
inequalities that are tight exactly at \(q=5\): Theorem 2's \(q-2\le(q+1)/2\), Theorem 6's
coset bound, and Corollary 9.2's forced collision.  Theorem 10 supplies the reason they keep
being tight by one: the saturated size \((q+3)/2\) is *exactly* the clique number of the
invariant relaxation in half the residue classes.  The branch is not accidentally hard near
the boundary; the boundary is where the relaxation stops distinguishing.

*A second reading of Corollary 9.2.*  In the chart \(\varphi_i(x)=(x-z_i)/(x-z_i^q)\) sending
the conjugate pair \((z_i,z_i^q)\) to \((0,\infty)\), one has the exact identity
\(N(\varphi_i(z_j))=\alpha_{ij}/\beta_{ij}=1/(1-g_{ij})\).  The level sets of
\(j\mapsto g_{ij}\) are therefore the circles of the elliptic pencil with limit points
\(z_i,z_i^q\), and condition (B) says every other point of \(Z\) lands on a pencil circle of
**nonsquare** norm — \((q-1)/2\) available circles for \((q+1)/2\) points.  That derives the
twenty-seventh pass's Jacobi count geometrically, and it explains its \(\approx q\)-point
collision fibres: a pencil circle has \(q+1\) points.

*A sign-product identity.*  Comparing \(\operatorname{Res}(P,\bar P)=(\gamma-\gamma^q)^n\)
with its factorization \((2s)^n(\prod_ic_i)(-1)^{\binom n2}\prod_{i<j}\beta_{ij}\), and using
\(\chi_q(-1)=-\delta\), gives \(\prod_i\chi_q(c_i)=\chi_q(-\gamma_1)^{(q+3)/2}\) where
\(\gamma-\gamma^q=-2s\gamma_1\) is the composition normal form's parameter.  This ties
Theorem 9's signs \(\eta_i=\chi_q(c_i)\) to the normal form; it is recorded, not used, and it
inherits the normal form's prime-only status.

**TT.**  The Tao question is *why did dropping a hypothesis help?*  Every pass since the
twenty-fifth has added structure to coherence — the crown, the coboundary, the cross-ratio —
and each addition made the object more special and the available tools narrower, because the
extra structure is arithmetic and non-invariant.  Removing (A) goes the other way: it lands on
an object with a name, a symmetry group, and classical extremal configurations, and it turns
out to be strong enough in half the cases.  The general lesson for the branch is to price a
relaxation by *which* symmetry it restores, not by how much information it discards.

The obvious skeptical check is whether the \(q\equiv1\pmod4\) rows are an artefact of small
fields, since \(\omega\) and \(n\) differ by exactly one.  Two things argue against it: the
gap is realized at four extension fields as well as eight primes, and Theorem 10 proves the
mechanism — the unique candidate extension of the obvious extremal clique is the pole, and it
fails for exactly this residue class, by a sign and not by a margin.  What is *not* established
is that maximum cliques must be line-anchored; at \(q=13\) most are not, so the general bound
does not follow from Theorem 10 and is stated as the open gate, not as a corollary.

## 7. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Does the invariant half alone decide the branch? | **settled: half of it** | empty for \(q\equiv1\pmod4\), \(5<q\le49\); provably undecidable by \(\Gamma\) for \(q\equiv3\pmod4\) |
| Why is \((q+3)/2\) the recurring knife edge? | **settled** | it is \(\omega(\Gamma_q)\) for \(q\equiv3\pmod4\); Theorem 10 |
| Which internal points extend an external line's clique? | **settled** | exactly the pole, and only when \(q\equiv3\pmod4\); Theorem 10, unconditional for all odd prime powers |
| \(\omega(\Gamma_q)\le(q+1)/2\) for \(q\equiv1\pmod4\), \(q>5\) | **open — the new gate** | proved for line-anchored cliques; the general case needs a bound with no line hypothesis |
| Are maximum \(\Gamma_q\)-cliques a single \(\mathrm{PGL}(2,q)\)-orbit? | open, and **no** as stated | counts \(21,220,855,759\) at \(q=7,11,19,23\) exceed the external-line counts; a classification would let (A) be tested against a finite list |
| Does \(C_\ell\cup\{\ell^{\perp}\}\) satisfy (A) for \(q\equiv3\pmod4\)? | open — cheap successor | not run here; a negative answer closes the line-anchored part of that residue class |
| Bounding conic-external **arcs** in general | untouched | unchanged; the arc condition collapses the maximum to \(\approx6\) empirically but has no general bound, and this pass supplies none |
| Gate 1's Baer-subline stability statement | reframed, not advanced | sufficient but vacuous for \(q>5\); any proof must use (B), and the only realizable container is an affine line |
| Saturated-internal branch as a whole | open | \(q\equiv3\pmod4\) needs (A) or arcs; \(q\equiv1\pmod4\) needs the \(\Gamma\) bound |
