# C756 — linear coordinatization of the direction matchings (twenty-sixth pass, gate 2)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
gate 2 of the exact-mechanism programme

## Verdict

Gate 2 is **advanced but not closed**.  The complete-mapping endgame asked for the
derangements of Theorem 5 to be computed algebraically rather than combinatorially.  They
now are: each direction matching is an equality of two \(\mathbb F_q\)-linear functionals,
which converts the whole Latin square into a family of scalar coordinate systems on \(Z\).

That conversion pays for itself immediately — it yields a moment theorem that is
prime-power-general, stronger than the twenty-fourth pass's digit tower, and proved in
half a page — but it does **not** yield the obstruction gate 2 was aiming at.  Worse for
the route, it explains *why* the earlier wall sits where it does, and the explanation says
the wall is intrinsic to this method rather than an artifact of the prime-field argument
that first hit it.

## 1. The matching is linear

Fix \(c\) on the norm-one circle \(C\) and set
\[
  \varphi_c(z)=z^q-cz,\qquad \psi_c(z)=z-cz^q .
\]

> **Theorem 7.**  For \(z,w\in\mathbb F_{q^2}\) with \(z\ne w^q\), the direction of
> \(z-w^q\) equals \(c\) if and only if \(\varphi_c(z)=\psi_c(w)\).

*Proof.*  Put \(u=z-w^q\).  Then \(u^q=z^q-w\), so \(u^{q-1}=c\) is
\(z^q-w=c(z-w^q)\), i.e. \(z^q-cz=w-cw^q\). \(\square\)

Both maps are \(\mathbb F_q\)-linear on \(\mathbb F_{q^2}\), which is two-dimensional over
\(\mathbb F_q\), and both are singular:
\(\ker\varphi_c=L_c:=\{z:z^{q-1}=c\}\cup\{0\}\) and \(\ker\psi_c=L_{c^{-1}}\), each an
\(\mathbb F_q\)-line, because \(z\mapsto z^{q-1}\) maps \(\mathbb F_{q^2}^\times\) onto
\(C\).  So each has a one-dimensional image, and from
\(\varphi_c(z)^q=-c^{-1}\varphi_c(z)\) that image is the common line
\(M_c=\{w:w^{q-1}=-c^{-1}\}\cup\{0\}\).

Choose a generator \(d_c\) of \(M_c\) and define the scalar coordinate
\(x_c(z)=\varphi_c(z)/d_c\in\mathbb F_q\).  Since \(\psi_c=-c\,\varphi_{c^{-1}}\), we get
\(\psi_c(z)/d_c=\rho(c)\,x_{c^{-1}}(z)\) with
\(\rho(c)=-c\,d_{c^{-1}}/d_c\in\mathbb F_q^\times\).  Theorem 7 becomes

> **Corollary 7.1.**  \(\pi_c(i)=j\iff x_c(z_i)=\rho(c)\,x_{c^{-1}}(z_j)\).  Hence, for
> every \(c\) in the good direction set \(G\), the two \(n\)-element subsets of
> \(\mathbb F_q\)
> \[
>   X_c=\{x_c(z_i)\},\qquad \rho(c)\,X_{c^{-1}}
> \]
> **coincide**, and \(\pi_c\) is the bijection they induce.

The coordinates are automatically injective on \(Z\): \(x_c(z_i)=x_c(z_j)\) would put
\(z_i-z_j\) in \(L_c\), i.e. give it direction \(c\) of class \(-\delta\), contradicting
condition (A).  So \(X_c\) really has \(n=(q+3)/2\) distinct elements — more than half of
\(\mathbb F_q\), which is the same over-half regime that drives Theorem 2.

A bookkeeping point that cost one debugging cycle and is worth stating: the class of a
direction is *not* \(\chi\) of the corresponding circle element, since every circle element
has norm one.  It is the order-two character \(\lambda\) of the cyclic group \(C\) — the
same \(\lambda\) as in gate 1 — under \(\chi(u)=\lambda(u^{q-1})\).  So
\(G=\{c\in C:\lambda(c)=-\delta\}\), of size \((q+1)/2\), closed under inversion, with
\(1\in G\) exactly when \(q\equiv1\pmod4\) and \(-1\notin G\) always.

## 2. The moment theorem

> **Theorem 8 (mixed-moment rationality).**  Let \(Z\) be a coherent system over any odd
> prime power \(q\), and let \(1\le m<(q+1)/2\).  Then every mixed sum
> \[
>   M_{r,m-r}=\sum_{i}z_i^{\,r}\,(z_i^{q})^{\,m-r},\qquad 0\le r\le m,
> \]
> lies in \(\mathbb F_q\).

*Proof.*  Take \(m\)-th power sums of the two equal sets of Corollary 7.1:
\(\sum_i x_c(z_i)^m=\rho(c)^m\sum_i x_{c^{-1}}(z_i)^m\).  Expanding
\(\varphi_c(z)^m=\sum_r\binom mr(-c)^r z^{r}z^{q(m-r)}\), clearing \(d_c^m\), and using
\(\rho(c)^m=(-c)^m d_{c^{-1}}^m/d_c^m\), the identity reduces after the substitution
\(r\mapsto m-r\) on one side to
\[
  \sum_{r=0}^{m}\binom mr(-1)^r c^r N_r=0,\qquad N_r=M_{r,m-r}-M_{r,m-r}^{\,q}.
\]
This holds for every \(c\in G\).  The left side is a polynomial in \(c\) of degree at most
\(m<(q+1)/2=|G|\), so it is identically zero, and every \(N_r=0\). \(\square\)

Three readings.

*It reproves and generalizes the digit tower.*  The twenty-fourth pass proved, for **prime**
\(q\) by a Lucas/binomial argument, that the signed power sums vanish through the critical
level.  Those signed power sums are exactly the \(N_r\).  Theorem 8 gets the same vanishing
for every odd **prime power**, covers *mixed* sums rather than pure power sums, and takes
half a page instead of a digit-carry analysis.  The extension-field hygiene item that gate 1
already discharged for the containment argument is now discharged for the moment tower too.

*It explains the critical level.*  The twenty-fourth pass found the tower stops at
\(t=(q+1)/2\) and had to verify that the boundary case closes by a reflection identity.
Theorem 8 says why that number: \((q+1)/2\) is \(|G|\), the number of available directions,
hence the number of linear conditions, and a degree-\(m\) polynomial is forced to vanish
precisely while \(m<|G|\).  The critical level is not arithmetic in origin; it is a count of
directions.

*It is free normalization.*  At \(m=1\) the polynomial is \((1+c)(S^q-S)\) with
\(S=\sum z_i\), and \(-1\notin G\), so \(S\in\mathbb F_q\).  Since
\(0<n<q\), translating by a rational constant normalizes \(S=0\).

## 3. Verification

`2026-08-02-c756-direction-coordinatization.py` checks, over \(q=5,7,11,13\):
that \(\chi(u)=\lambda(u^{q-1})\) at every nonzero \(u\); that \(G\) has size \((q+1)/2\)
and is inversion-closed; Theorem 7 pointwise, as an equivalence, over all irrational pairs
in a bounded window; the identity \(\psi_c/d_c=\rho(c)x_{c^{-1}}\) at every irrational
point with \(\rho(c)\in\mathbb F_q^\times\); and the reduction of the power-sum comparison
to the \(N_r\) polynomial as an algebraic identity on random configurations, which does
**not** assume coherence and so tests the algebra independently of the (empty) solution set
for \(q>5\).

At \(q=5\) it brute-forces the coherent systems and confirms Theorem 5's Latin square,
Corollary 7.1's set identity, rationality of \(S\), and Theorem 8's mixed sums.  It finds
10 coherent systems as labelled sets, forming exactly 2 orbits under the rational affine
group — the two known four-frames.

```sh
cd notes
python3 2026-08-02-c756-direction-coordinatization.py
```

| \(q\) | \(|G|\) | Thm 7 | \(\psi_c\) identity | \(N_r\) reduction | \(q=5\) controls |
|---:|---:|---|---|---|---|
| 5  | 3 | ok | ok | ok | 10 systems / 2 affine orbits; Latin, set identity, \(S\), moments all ok |
| 7  | 4 | ok | ok | ok | — |
| 11 | 6 | ok | ok | ok | — |
| 13 | 7 | ok | ok | ok | — |

Artifacts:

- `2026-08-02-c756-direction-coordinatization.py`
  `55c6d48ce82653666f639ce3bba426ef4c874b172d303fa06d97409ce4eec6d3`
- `2026-08-02-c756-direction-coordinatization.json`
  `3d610abce244d49323e04a5083de2ad08dfcec0fa80c1522970c513aef260ee6`

## 4. Why this does not yet close gate 2

Gate 2's stated missing step is the cycle structure of \(\sigma_c\sigma_{c'}^{-1}\) as a
field-arithmetic invariant.  Corollary 7.1 makes the composite completely explicit —
\(\pi_{c'}^{-1}\pi_c\) is "read the coordinate \(x_c\), rescale by \(\rho(c)\), look the
value up in \(x_{c^{-1}}\), then invert the same recipe at \(c'\)" — but explicit is not
the same as invariant, and **no cycle-structure obstruction has been extracted**.  Stating
that plainly is the result: the algebraic computation gate 2 requested is done, and it does
not by itself produce the group-sum-style contradiction that closed the external branch.

The reason is visible in Theorem 8.  All the leverage of the direction family is spent by
degree \(|G|=(q+1)/2\), because that is how many linear conditions there are.  Beyond that
level the polynomial has degree at least \(|G|\) and is no longer forced to vanish, so the
method stops exactly where the twenty-fourth pass's tower stopped.  The two walls are the
same wall, now seen to be a dimension count rather than two coincidences.  Any continuation
of gate 2 must therefore add information that is not a symmetric function of a single
coordinate system \(X_c\) — the natural candidates being the *joint* distribution of two
coordinates \((x_c,x_{c'})\) on \(Z\), which is what a genuine cycle-structure invariant
would measure, or the interaction with condition (A), which Theorem 5 and everything above
never uses.

That last point is worth flagging as the sharpest available lever: Theorem 5, Theorem 7,
Theorem 8 and the whole coordinatization follow from the *bipartite* half of the crown
alone.  Gate 1's Theorem 6 followed from the *independence* half alone.  Nothing in the
pass yet uses both halves at once, and the two known frames are the configurations where
both are simultaneously tight.

## 5. EJ + TT closeout

**EJ.**  Two upgrades taken here, one declined.

*Taken: prime-power generality of the moment tower.*  Theorem 8 removes the prime-field
restriction from the twenty-fourth pass's central structural result at no cost.  Combined
with gate 1, every load-bearing statement of the saturated-internal branch except the
composition normal form is now prime-power-general, so the extension-field caveat that has
been carried since the twenty-third pass can be retired from the branch's argument as a
whole rather than piecemeal.

*Taken: the normalization \(S=0\).*  Free, and it removes one of the three parameters in
any future \((a,\kappa)\)-style census.

*Declined: pushing to \(m\ge(q+1)/2\).*  At and above the critical level the polynomial
identity survives but is one relation among \(m+1\) unknowns, so it constrains rather than
determines.  Chasing it reproduces the twenty-fourth pass's boundary bookkeeping and, by
§4, cannot escape the dimension count.  Recorded as closed for this method, not attempted.

**TT.**  The Tao question — *what is the real reason the argument stalls at the same place
twice?* — now has an answer, and it reframes the branch.  The saturated-internal object is
overdetermined by roughly \(q^2\) conditions on \(O(1)\) parameters, which is why the
twenty-fifth pass expected a character sum to finish it.  But every tool applied so far
extracts information through a single one-parameter family — directions in gate 2,
containers in gate 1 — and a one-parameter family carries only \(O(q)\) independent linear
conditions.  The gap between \(q^2\) available and \(q\) extracted is the whole difficulty.
The frames survive because they are simultaneously extremal for both halves of the crown;
an argument that separates them from everything else has to couple the halves, and no
current gate does.

The skeptical check: could Theorem 8 be vacuous because coherent systems do not exist for
\(q>5\)?  It is not vacuous as a proof, since the derivation is unconditional and the
\(q=5\) controls exercise it nontrivially, but it *is* untestable above \(q=5\), and the
\(N_r\) reduction is therefore verified separately on random non-coherent configurations so
that the algebra is checked where the hypothesis is not available.

## 6. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Can the Theorem 5 derangements be computed algebraically? | **settled** | Theorem 7 and Corollary 7.1: each matching is an equality of two linear functionals |
| Why does the digit tower stop at level \((q+1)/2\)? | **settled** | §2: that level is \(|G|\), the number of directions, hence the number of linear conditions; it is a dimension count, not arithmetic |
| Is the moment tower prime-only? | **settled negatively** | Theorem 8 holds for every odd prime power |
| Does gate 2 produce a complete-mapping obstruction? | **open; not produced** | no cycle-structure invariant extracted; §4 states the exact remaining step |
| Can any single-parameter family finish the branch? | settled negatively | §4/§5: a one-parameter family yields \(O(q)\) conditions against a degree wall at \(|G|\) |
| Do any current arguments use both halves of the crown? | **no — newly identified lever** | gate 1 uses independence only, gate 2 uses the bipartite half only; the frames are extremal for both |
| Saturated-internal branch as a whole | open | gate 1's stability statement is now sufficient on its own; gate 2 needs a two-coordinate invariant |
