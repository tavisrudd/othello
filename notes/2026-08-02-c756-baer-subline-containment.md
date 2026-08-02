# C756 — unified Baer-subline containment (twenty-sixth pass, gate 1)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
gate 1 of the exact-mechanism programme

## Verdict

Gate 1's first half is **closed positively and unconditionally**, and it closed far more
cheaply than the ranked programme anticipated.  The remaining container — a Baer subline
not through infinity, i.e. a circle — dies to an exact coboundary identity that uses only
condition (A), needs no Weil bound, no residue class of \(q\), and no case analysis.

> **Theorem 6.**  Let \(q\) be an odd prime power and \(Z\) a coherent system.  Then
> \(Z\) is not contained in any Baer subline of \(\mathbf P^1(\mathbb F_{q^2})\) that
> misses \(\infty\).  More precisely, for every such Baer subline \(B\),
> \(|Z\cap B|\le(q+1)/2<(q+3)/2=|Z|\).

> **Corollary (unified Baer-subline theorem).**  If a coherent system is contained in a
> Baer subline of \(\mathbf P^1(\mathbb F_{q^2})\), then that subline passes through
> \(\infty\) — it is an \(\mathbb F_q\)-affine line — and \(q=5\).

The corollary is the unification gate 1 asked for: Theorem 2 of the twenty-fifth pass
handled Baer sublines through infinity, Theorem 6 handles all the others, and together
they say *deep-hole coherence never survives inside a Baer subline except at \(q=5\).*

Two consequences that change what the programme should do next are in §4 and §5: the
published Baker–Ebert–Hemmeter–Woldar clique family is now *explained* as the exact
extremal configuration for Theorem 6's bound, and gate 1's stability conjecture is
upgraded from "aim at" to *sufficient* — proving it would now close the saturated-internal
branch outright.

## 1. The coboundary identity

Conventions are those of the twenty-fifth pass: \(\mathbb F_{q^2}=\mathbb F_q(\iota)\),
\(\iota^2=\varepsilon\) a fixed nonsquare, \(\chi\) the quadratic character of
\(\mathbb F_{q^2}\), \(\chi_q\) that of \(\mathbb F_q\), \(\chi(u)=\chi_q(N(u))\),
\(t=(q+1)/2\), \(n=t+1=(q+3)/2\), \(\delta=(-1)^{t}\).  Let
\(C=\{z:N(z)=1\}\) be the norm-one circle, \(Q_0\) its index-two subgroup, \(Q_1\) the
other coset, and \(\lambda:C\to\{\pm1\}\) the corresponding character, \(\lambda=+1\) on
\(Q_0\).

> **Lemma 6.1.**  For distinct \(c,c'\in C\),
> \[
>   \chi(c-c')=\delta\,\lambda(c)\,\lambda(c').
> \]

*Proof.*  Parametrize \(C\) by \(c(t)=(t-\iota)/(t+\iota)\), a bijection
\(\mathbf P^1(\mathbb F_q)\to C\) with \(c(t)^q=c(-t)\).  Directly,
\[
  c(t)-c(t')=\frac{2\iota\,(t-t')}{(t+\iota)(t'+\iota)} .
\]
Now \(\chi(t-t')=+1\) because \(t-t'\in\mathbb F_q^\times\) and \(\chi\) is trivial on
\(\mathbb F_q^\times\); \(\chi(2)=+1\) for the same reason; and
\(\chi(\iota)=\chi_q(-\varepsilon)=-\chi_q(-1)=\delta\).  Finally
\(N(t+\iota)=t^2-\varepsilon\), so \(\chi(t+\iota)=\chi_q(t^2-\varepsilon)\), which is
exactly \(\lambda(c(t))\): the standard fact
\(c(t)\in Q_0\iff\chi_q(t^2-\varepsilon)=+1\), with \(t=\infty\mapsto c=1\in Q_0\).
Multiplying the three characters gives the identity. \(\square\)

Counting confirms the bookkeeping: \(\sum_{t\in\mathbb F_q}\chi_q(t^2-\varepsilon)=-1\)
because the quadratic is irreducible, so \(\lambda=+1\) at \((q-1)/2\) finite parameters
plus \(t=\infty\), and \(\lambda=-1\) at \((q+1)/2\).  Hence
\(|Q_0|=|Q_1|=(q+1)/2\).

Lemma 6.1 is a one-line rederivation of Goryainov–Kabanov–Shalaginov–Valyuzhenich's
Lemma 8 — the statement that \(C\) induces \(K_{m,m}\), \(m=(q+1)/2\), in the Paley
graph of order \(q^2\), which is what makes their minimum-support eigenfunction work.
Reading it as a *coboundary* rather than as a bipartite-graph statement is what makes it
usable here.

## 2. Proof of Theorem 6

Every Baer subline of \(\mathbf P^1(\mathbb F_{q^2})\) missing \(\infty\) has the form
\(aC+b\) with \(a\in\mathbb F_{q^2}^\times\), \(b\in\mathbb F_{q^2}\).  Counting:
there are \(|\mathrm{PGL}(2,q^2)|/|\mathrm{PGL}(2,q)|=q(q^2+1)\) Baer sublines in all;
those through \(\infty\) are exactly the \(q(q+1)\) \(\mathbb F_q\)-affine lines (compose
with an element of \(\mathrm{PGL}(2,q)\) to fix \(\infty\), leaving an affine map); so
\(q(q^2+1)-q(q+1)=q^2(q-1)\) miss \(\infty\).  Meanwhile the orbit of \(C\) under
\(z\mapsto az+b\) has size \(q^2(q^2-1)/(q+1)=q^2(q-1)\), since \(aC+b=C\) forces
\(b=0\) and \(a\in C\).  The two counts agree, so the orbit is everything.

Now let \(z_1,\dots,z_m\) be distinct points of \(Z\) lying on \(aC+b\), \(m\ge3\), and
write \(z_i=ac_i+b\) with \(c_i\in C\).  Then \(z_i-z_j=a(c_i-c_j)\), so by Lemma 6.1
condition (A) reads
\[
  \chi(a)\,\lambda(c_i)\,\lambda(c_j)=1\qquad\text{for all }i\ne j .
\]
Multiplying the relations for the pairs \((i,j)\) and \((i,k)\) and dividing by the one
for \((j,k)\) gives \(\chi(a)=1\); the relations then say \(\lambda(c_i)\lambda(c_j)=1\)
for all \(i\ne j\), i.e. all \(\lambda(c_i)\) coincide.  So the \(c_i\) lie in a single
coset \(Q_j\), whence \(m\le|Q_j|=(q+1)/2\).  Since \(|Z|=(q+3)/2>(q+1)/2\), the whole of
\(Z\) cannot lie on \(aC+b\).  For \(m\le2\) the bound \(m\le(q+1)/2\) is trivial.
\(\square\)

Condition (B) is never used.  That is the structural content: on a circle, the
*independence* half of the crown already overdetermines the configuration, whereas on a
line (Theorem 2, case (b)) the independence half is a bare normalization \(\chi(b)=\delta\)
and all the work falls on the bipartite half.  The two containers are therefore *not*
"the same argument run twice", as the ranked programme conjectured — they are opposite
extremes, and the circle is by far the easier one.

## 3. Verification

`2026-08-02-c756-baer-subline-containment.py` checks every step over the prime fields
\(q\le23\): the coboundary identity for all pairs on the circle; the parametrization
\(c(t)\), its conjugation rule, and \(\lambda(c(t))=\chi_q(t^2-\varepsilon)\); the coset
sizes \((q+1)/2\); the identity \(\chi(z-z^q)=\delta\) at every irrational \(z\); the
orbit count \(q^2(q-1)\) for \(aC+b\) as distinct sets; and, exhaustively over *all*
\(q^2(q-1)\) circles, the maximum clique inside a single circle under (A) alone and under
(A) and (B) together.

```sh
cd notes
python3 2026-08-02-c756-baer-subline-containment.py
```

| \(q\) | \(\delta\) | \(n=(q+3)/2\) | \((q+1)/2\) | max (A)-clique in a circle | max (A)+(B)-clique in a circle | circles checked |
|---:|---:|---:|---:|---:|---:|---:|
| 5  | \(-1\) | 4  | 3  | 3  | 2 | 100 |
| 7  | \(+1\) | 5  | 4  | 4  | 3 | 294 |
| 11 | \(+1\) | 7  | 6  | 6  | 4 | 1,210 |
| 13 | \(-1\) | 8  | 7  | 7  | 4 | 2,028 |
| 17 | \(-1\) | 10 | 9  | 9  | 4 | 4,624 |
| 19 | \(+1\) | 11 | 10 | 10 | 5 | 6,498 |
| 23 | \(+1\) | 13 | 12 | 12 | 5 | 11,638 |

Artifacts and hashes:

- `2026-08-02-c756-baer-subline-containment.py`
  `13264e07a303ad36ffda95587de1ae743500ef3f10be97c22cde87f2abbcd0d7`
- `2026-08-02-c756-baer-subline-containment.json`
  `b1281aa593c97b37b819e65784641e7a8f9e03054d9b9f59cf9a88def6bf0f14`

The independent replay is the twenty-fifth pass's exhaustive coherence search
(`2026-08-02-c756-clique-orbit-crown-check.md`), which found no coherent system for
\(5<q\le151\) by an unrelated method; Theorem 6 is consistent with it and explains one
structural reason for the shape of the survivors at \(q=5\).

## 4. The published clique family is exactly extremal

The (A)-only column reproduces the bound \((q+1)/2\) exactly at every field, so
Theorem 6's inequality is sharp and the extremal configuration is a full coset
\(aQ_j+b\).  This retro-explains the shape of the Baker–Ebert–Hemmeter–Woldar maximal
cliques \(S_j=Q_j\cup\{0\}\), which the twenty-fifth pass had to import from the
literature and then kill with a Weil bound (Theorem 4).  A clique of size \((q+3)/2\)
built from a circle *must* consist of a full \(\lambda\)-coset plus exactly one point off
the circle, because the coset saturates Theorem 6's bound and one more point is needed.
The published family is not one candidate among many; it is the unique way to be extremal
for this bound.

The (A)+(B) column is the genuinely new quantitative fact.  Once the bipartite half of the
crown is imposed, the maximum drops from \((q+1)/2\) to \(2,3,4,4,4,5,5\) — apparently
\(O(\sqrt q)\), against a required \(n=(q+3)/2\).  So a coherent system does not merely
fail to fit inside a circle; for \(q\ge11\) it cannot place more than about five of its
points on any circle at all.  This is empirical, not proved, and turning it into a theorem
would need a clique bound for a character-sum graph, which reintroduces a
\(\sqrt q\) error term and hence fails exactly where the small fields live.  It is
recorded as structure, not as a route.

## 5. What this does and does not buy

**Does.**  Gate 1's first half is finished, unconditionally and for every odd prime power.
Both Baer-subline containers are now closed by exact arguments with no error term: the
line by the integer inequality \(q-2\le(q+1)/2\) of Theorem 2, the circle by the coset
inequality \((q+3)/2>(q+1)/2\) of Theorem 6.

The upgrade that matters is to gate 1's second half.  The programme proposed aiming at a
stability statement — *the support of a \(\pm1\)-valued, Frobenius-odd
\(\lambda_{\min}\)-eigenfunction of support at most \(q+3\) lies on a Baer subline* — and
listed it as one step of a longer chain.  With the corollary above, that statement is now
**sufficient on its own**: if the support lies on a Baer subline, the corollary forces
\(q=5\), and the saturated-internal branch closes.  Gate 1 is therefore one theorem away
from closing the branch rather than two, and the target is a single clean statement in
the Paley-eigenfunction literature rather than anything about arcs or conics.

**Does not.**  Theorem 6 does not close the branch and does not extend the certified
range.  A coherent system for \(q>5\) is now known to be line-free (Theorem 2) and
circle-free (Theorem 6) — that is, contained in *no* Baer subline — but nothing yet forces
it to be contained in one.  The supporting evidence for the stability statement remains
what it was: the known minimum-support eigenfunction, of support \(q+1\), is supported
exactly on a Baer subline (Lemma 6.1 is precisely why), and nothing is known for supports
\(q+2,\dots,2q-1\).

**Correction to the ranked programme.**  The task card's gate 1 describes Theorems 2 and 4
as "the same argument run on the two kinds of Baer subline".  That reading is wrong in a
way worth recording, because it mispriced the work.  Theorem 4's container \(aS_j+b\) is
not a Baer subline — it is half a Baer subline plus one point — and Theorem 2's and
Theorem 6's proofs load onto opposite halves of the crown.  The genuine unification is
Theorem 2 plus Theorem 6, and Theorem 4 is a separate statement about the extremal
configuration of Theorem 6.

## 6. EJ + TT closeout

**EJ.**  Three things came free and are taken here.

*The Baker et al. clique family stops being an imported black box.*  §4 derives its shape
from Theorem 6 rather than from the two-orbit classification.  This does not remove the
gap conjecture from Theorem 3's reduction, but it means the residual family in the
\(q\equiv3\pmod4\) case is now independently motivated: any coherent system meeting some
circle in more than \((q+1)/2 - O(\sqrt q)\) points would have to be of that shape.

*The identity is reusable on the nonsaturated branch.*  The masked Rédei target has the
same circle parametrization available, and Lemma 6.1 says a quadratic character of a
difference of two circle points factors as a coboundary.  Any condition of the form
"\(\chi\) of a difference of circle points is constant" therefore collapses immediately
to a coset condition rather than needing a character sum.  This is a sharper tool than the
twenty-fifth pass's reusable Theorem 4 mechanism, and it should be tried on the
nonsaturated direction theorem before any Weil estimate is set up.

*The eigenfunction comparison gets sharper.*  The twenty-fifth pass observed that C756's
object is the "immediate neighbour" of the known minimum-support eigenfunction.  Lemma 6.1
says more: the known one is supported on a Baer subline and is Frobenius-even because
\(\lambda\) is a coboundary there, while C756's is Frobenius-odd and now provably lies on
no Baer subline.  The two objects are separated by a structural property, not just by a
support count of two.

**TT.**  The Tao question here is *why did the expected difficulty evaporate?*  The answer
is that the ranked programme measured difficulty by the container's size — both containers
have about \(q\) points, both are being met in about \(q/2\) — and that is the wrong
invariant.  The right one is which half of the crown the container's own geometry
constrains.  A circle carries a nontrivial quadratic-character coboundary, so it
constrains the independence half for free; a line carries none, so it constrains nothing
for free and the whole burden falls on the bipartite half.  That distinction predicts
in advance which containment problems are cheap, and it suggests the general question
worth asking: for which point sets \(S\subseteq\mathbb F_{q^2}\) does \(\chi(u-v)\)
restrict to a coboundary on \(S\)?  Baer sublines do; the answer being "essentially only
those" would itself be close to the stability statement gate 1 needs.

The sharpest skeptical check is whether Theorem 6 could be vacuous — whether the
\(q\equiv1\pmod4\) and \(q\equiv3\pmod4\) cases hide a sign error that makes the (A)
condition unsatisfiable on a circle for trivial reasons.  It does not: the (A)-only column
of §3 attains \((q+1)/2\) at every tested field in both residue classes, so the
configuration Theorem 6 excludes is excluded by one point, not by a wide margin, and the
verification exercises both signs of \(\delta\).

## 7. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Can a coherent system live on a Baer subline? | **settled negatively** except \(q=5\) | Theorem 2 (through \(\infty\)) plus Theorem 6 (missing \(\infty\)); no conjecture used |
| Why does the published maximal-clique family have the shape \(Q_j\cup\{0\}\)? | **settled** | §4: a full \(\lambda\)-coset saturates Theorem 6's bound, so exactly one extra point off the circle is forced |
| Are the line and circle cases one argument? | settled negatively; programme corrected | §5: they load on opposite halves of the crown; the card's gate-1 framing is amended |
| Why is the (A)+(B) circle maximum \(O(\sqrt q)\) rather than \((q+1)/2\)? | open, recorded as structure only | proving it needs a character-sum clique bound, whose \(\sqrt q\) tail fails at small \(q\) — the same wall as Theorem 4; not promoted to a route |
| Does gate 1 still need two theorems? | **settled: one** | the stability statement alone now closes the branch, via the corollary |
| Is a coherent system contained in *some* Baer subline? | open — this is now the whole of gate 1 | the stability conjecture for \(\pm1\)-valued Frobenius-odd \(\lambda_{\min}\)-eigenfunctions of support \(\le q+3\) |
| Saturated-internal branch as a whole | open | unchanged: either the stability statement (gate 1) or the complete-mapping endgame (gate 2) |
| Nonsaturated branch | untouched | unchanged; Lemma 6.1 is offered to it as a new tool |
