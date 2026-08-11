# C880 item 5 — the regular and conference promise, and the promised anchor

**Date:** 2026-08-11
**Lane:** `clebsch`
**Task:** C880, work item 5 (math and computation only; no manuscript edits)
**Companions:** `notes/2026-08-11-c880-item5-structure-check.py` (+ `.out`)

Everything below is proved by hand. The core is elementary and uses no spectral
theory: the number of aligned four-sets of a two-graph is a quadratic function
of its pair degrees alone. The script is an arithmetic guard on four of the
identities, not evidence for any of them; see **Verification**.

## Summary

The promise is worth a great deal in principle and nothing that anyone can
currently spend.

1. For a pair \(p\), let \(a(p)\) be the number of coherent triples through it
   and \(m(p):=n-2-2a(p)\) its **defect**. Then the number of aligned four-sets
   through a triple \(t\) is \(\lambda_3(t)=\frac14\bigl(n-6+\sigma(t)\sum_{p\subset t}
   m(p)\bigr)\) (Theorem 2), and globally
   \(\lvert A\rvert=\frac1{16}\bigl((n-6)\binom n3+\sum_p m(p)^2\bigr)\)
   (Corollary 3). The aligned family's size depends on nothing but the pair
   degrees.
2. Conference two-graphs are therefore exactly the two-graphs with the
   **fewest** aligned four-sets: \(\lvert A\rvert\ge n(n-1)(n-2)(n-6)/96\) with
   equality iff every pair lies in exactly \((n-2)/2\) coherent triples
   (Theorem 4). The promise restricts the decoder to the sparsest-signal
   instances, not to easier ones.
3. That single inequality proves both halves of the paper's point threshold:
   every two-graph on at least seven points has an aligned four-set, and at six
   points the two-graphs without one are precisely the conference two-graphs
   (Corollary 5). The six-point witness enumeration is explained, not merely
   reproduced.
4. Splitting the aligned family by sign, \(\lvert A_\pm\rvert=\tfrac12\lvert A\rvert
   \pm\tfrac{n-3}{24}\sum_p m(p)\) (Corollary 6). So **every** four-point statistic
   of a two-graph is a function of the defect vector \(m\) alone; and on the
   conference class \(m\equiv0\), so every four-point statistic is constant
   across the entire class. No counting argument at the four-point level can
   distinguish two conference two-graphs — a decoder must use positions.
5. Attainment of the bound in Theorem 4 is an arithmetic condition: it needs a
   symmetric conference matrix of order \(n\), hence \(n\equiv2\pmod4\) **and**
   \(n-1\) a sum of two squares. The first failure of the second condition is
   \(n=22\). Integrality of \(m\) sharpens the bound at every other residue
   (Corollary 8).
6. The aligned family of a regular two-graph has the conference parameter
   \(\lambda_3=(n-6)/4\) exactly when the two-graph is conference.  If both
   coherent and incoherent triples occur, every other regular two-graph has two
   distinct values of \(\lambda_3\) (Corollary 9).  This pins the exact scope of
   the design fact quoted by the task card.
7. A decoder may assume the design law for free, but the law is inert: it cannot
   inflate a decoder's known set by more than a factor \(1+O(1/n)\)
   (Proposition 14). This answers item 5's second question negatively.
8. The promised-anchor variant is worth exactly two bits and therefore changes
   no bound beyond the \(O(1)\) tests the general decoder spends locating an
   anchor (Theorem 10, Corollary 11). That half of item 5 is closed.
9. Every local lower-bound mechanism dies under the conference promise — no
   elementary pair flip stays in the class (Theorem 12) — and the rigidity that
   replaces it certifies only \(O(n)\) of savings (Theorem 13).
10. From below, the conference-promised query complexity **is** the enumeration
    problem for symmetric conference matrices, \(\log_2 N_n - 1\), at least
    \(n\log_2 n - O(n)\) unconditionally. From above there is one route that
    does beat the general decoder: learning \(\Theta(n/\log n)\) full rows and
    solving the resulting \(\pm1\) orthogonality system gives \(O(n^2/\log n)\)
    tests, conditional on a non-degeneracy property of conference matrices that
    is an inverse Littlewood–Offord statement (§6).

## 1. Setup

\(V\) is a point set, \(\lvert V\rvert = n\). A two-graph is a map
\(\tau\colon\binom V3\to\mathbf F_2\) with \(\sum_{t\subset Q}\tau(t)=0\) on every
four-set \(Q\); these form an \(\mathbf F_2\)-space \(\mathcal T_n\) of dimension
\(\binom{n-1}2\). A Seidel matrix \(S\) is symmetric with zero diagonal and
\(\pm1\) off it, determined by the two-graph up to switching \(S\mapsto DSD\)
with \(D\) diagonal \(\pm1\); the dictionary is

\[ \sigma(xyz) \;:=\; S_{xy}S_{yz}S_{zx} \;=\; (-1)^{\tau(xyz)} . \]

A triple is **coherent** when \(\tau=1\), i.e. \(\sigma=-1\). A four-set \(Q\) is
**aligned** when \(\tau\) is constant on \(\binom Q3\), equivalently when
\(\sigma\) is; \(A(\Delta)\) is the set of aligned four-sets. Alignment is
invariant under switching and under global complementation \(\tau\mapsto\tau+1\),
which is the ambiguity the faithfulness theorem carries.

For a pair \(p=\{x,y\}\) write \(a(p)\) for the number of coherent triples
containing \(p\) and define its **defect**

\[ m(p) \;:=\; n-2-2a(p) \;=\; \sum_{w\notin p}\sigma(xyw) \;=\; S_{xy}\,(S^2)_{xy}. \]

A two-graph is regular iff \(a(p)\) is constant; the conference two-graphs are
exactly the case \(a\equiv(n-2)/2\), that is \(m\equiv0\), that is
\(S^2=(n-1)I\).

**Lemma 1 (parity).** For every four-set \(Q\), \(\prod_{t\subset Q}\sigma(t)=1\).

*Proof.* Each of the six pairs inside \(Q\) lies in exactly two of the four
triples, so the product telescopes to \(\prod_{\text{pairs}}S_{\cdot\cdot}^2=1\). ∎

This is the four-set parity law in multiplicative form. It is also the reason a
negative answer is uninformative in the way the task card describes: an even
number of the four signs is \(-1\), so "not aligned" means two of them are, in
one of three ways.

## 2. The aligned family is a function of the pair degrees alone

**Theorem 2 (local law).** For every two-graph on \(n\) points and every triple
\(t=\{x,y,z\}\), the number \(\lambda_3(t)\) of aligned four-sets containing
\(t\) is

\[ \boxed{\;\lambda_3(t)\;=\;\frac{\,n-6+\sigma(t)\bigl[m(xy)+m(xz)+m(yz)\bigr]\,}{4}\;} \]

*Proof.* Fix \(w\notin t\) and set \(\alpha=\sigma(xyw)\sigma(t)\),
\(\beta=\sigma(xzw)\sigma(t)\), \(\gamma=\sigma(yzw)\sigma(t)\). By Lemma 1 the
four signs on \(t\cup\{w\}\) multiply to \(1\), so \(\alpha\beta\gamma=1\) and
therefore \(\alpha\beta=\gamma\), \(\beta\gamma=\alpha\), \(\gamma\alpha=\beta\).
Hence

\[ \mathbf 1[\,t\cup\{w\}\text{ aligned}\,]
   =\frac{(1+\alpha)(1+\beta)(1+\gamma)}8
   =\frac{1+\alpha+\beta+\gamma}4 . \]

Summing over the \(n-3\) choices of \(w\) and using
\(\sum_{w\notin t}\alpha=\sigma(t)\bigl(m(xy)-\sigma(t)\bigr)=\sigma(t)m(xy)-1\),
and the same for \(\beta\) and \(\gamma\), gives
\(\lambda_3(t)=\frac{n-3}4+\frac{\sigma(t)\sum_{p\subset t}m(p)-3}4\). ∎

**Corollary 3 (global law).** For every two-graph on \(n\) points,

\[ \boxed{\;\lvert A(\Delta)\rvert\;=\;\frac1{16}\Bigl((n-6)\tbinom n3+\sum_{p}m(p)^2\Bigr)\;} \]

the sum running over all \(\binom n2\) pairs.

*Proof.* Each aligned four-set contains four triples, so
\(4\lvert A\rvert=\sum_t\lambda_3(t)\). Apply Theorem 2 and exchange the order of
summation in the second term: each pair \(p\) contributes
\(m(p)\sum_{t\supset p}\sigma(t)=m(p)^2\), by the definition of \(m(p)\). ∎

**Theorem 4 (the defect bound and its equality case).** For every
two-graph on \(n\) points,

\[ \lvert A(\Delta)\rvert \;\ge\; \frac{(n-6)\binom n3}{16}\;=\;\frac{n(n-1)(n-2)(n-6)}{96}, \]

with equality **iff** \(m\equiv0\) — that is, iff every pair lies in exactly
\((n-2)/2\) coherent triples, iff \(S^2=(n-1)I\), iff \(S\) is a symmetric
conference matrix and \(\Delta\) is a conference two-graph. Equality is therefore
possible only when \(n\equiv2\pmod 4\).

*Proof.* Immediate from Corollary 3, since \(\sum_p m(p)^2\ge0\) with equality iff
every defect vanishes. The equivalence \(m\equiv0\iff S^2=(n-1)I\) is the
definition of \(m\) together with \((S^2)_{xx}=n-1\), and the congruence is the
classical existence condition for symmetric conference matrices. ∎

Thus, whenever a conference two-graph of order \(n\) exists, the conference
two-graphs are exactly the minimisers.  At orders where none exists, the finite
minimum lies strictly above the displayed bound.

This is the structural content of item 5's first question, and it points the
opposite way from the one the task card anticipated. The conference promise does
not hand the decoder extra local statistics to exploit; it pins the instance to
the unique extreme point at which alignment tests say "yes" as rarely as the
parity law permits. The mechanism is visible in Corollary 3: alignment is a
second-order statistic of the pair degrees, and regularity is exactly the
condition that kills it.

**Corollary 5 (the point threshold, both halves, in one inequality).** For
\(n\ge7\) the right-hand side is strictly positive, so **every** two-graph on at
least seven points has an aligned four-set. At \(n=6\) the bound reads
\(\lvert A\rvert\ge0\) with equality exactly at the conference two-graphs, so the
six-point two-graphs invisible to alignment tests are precisely the conference
ones. For \(4\le n\le5\) the bound is negative and says nothing.

The six-point half matches the enumeration in
`notes/2026-08-07-c880-alignment-separation.md` exactly: twelve labelled
two-graphs with empty aligned family, six complement pairs. That report
established the fact; Theorem 4 says why it happens and why it happens only
there. The \(n\ge7\) half is a two-line proof of anchor existence, currently
obtained in the development by a different route
(`exists_distinct_alignedAnchor`); see §8 for the handoff.

**Corollary 6 (the complete four-point statistics).** Let \(A_+\) and \(A_-\) be
the aligned four-sets on which \(\sigma\equiv+1\) and \(\sigma\equiv-1\). Then

\[ \lvert A_\pm\rvert \;=\; \tfrac12\lvert A\rvert \;\pm\; \frac{n-3}{24}\sum_p m(p). \]

*Proof.* Put \(s(Q)=\sum_{t\subset Q}\sigma(t)\), which by Lemma 1 lies in
\(\{4,0,-4\}\) and is \(\pm4\) exactly on \(A_\pm\). Then
\(4(\lvert A_+\rvert-\lvert A_-\rvert)=\sum_Q s(Q)=(n-3)\sum_t\sigma(t)
=\frac{n-3}3\sum_p m(p)\), the last step because each triple has three pairs. ∎

Every four-point statistic of a two-graph is therefore a function of the defect
vector \(m\) alone: the two counts \(\lvert A_\pm\rvert\) exhaust the four-point
patterns, \(\lvert A\rvert\) is quadratic in \(m\) and \(\lvert A_+\rvert-\lvert
A_-\rvert\) is linear in it. On the conference class \(m\equiv0\), so **every
four-point statistic is constant across the entire class** — the aligned family
always has \(n(n-1)(n-2)(n-6)/96\) members, split evenly by sign, and is always a
\(3\)-\((n,4,\frac{n-6}4)\) design. No counting argument at the four-point level
can separate two conference two-graphs. A decoder must use which four-sets answer
yes, and the first statistic that can vary lives on five points.

Read in reverse, Theorem 4 and Corollary 6 are the equality case of a
quasirandomness statement: \(\sum_p m(p)^2\) is a discrepancy, and the conference
two-graphs are the exactly quasirandom two-graphs, the ones whose four-point
counts hit the random values on the nose. The alignment oracle measures
quasirandomness deficiency and nothing else.

**Corollary 7 (spectral form).** Since
\(\sum_p m(p)^2=\frac12\bigl(\operatorname{tr}(S^4)-n(n-1)^2\bigr)\),

\[ \lvert A(\Delta)\rvert \;=\; \frac14\binom n4 \;+\;
   \frac{\operatorname{tr}(S^4)-n(n-1)(2n-3)}{32}. \]

*Proof.* \(m(p)^2=\bigl((S^2)_{xy}\bigr)^2\), and summing over unordered pairs
gives \(\frac12\bigl(\sum_{x,y}((S^2)_{xy})^2-\sum_x((S^2)_{xx})^2\bigr)
=\frac12(\operatorname{tr}(S^4)-n(n-1)^2)\). Substitute into Corollary 3. ∎

So the aligned-family size is an affine function of the fourth spectral moment
of the Seidel matrix, and Theorem 4 is the statement that the moment is
minimised at a flat spectrum. One consequence worth recording: a uniformly
random alignment test is an unbiased estimator of
\(\operatorname{tr}(S^4)\) up to known affine constants, so in aggregate the
answers to random tests carry the fourth moment and nothing else. Any decoder
beating the counting bound must exploit *which* four-sets answer yes, never how
many.

**Corollary 8 (integrality, and the arithmetic obstruction to attainment).** Every
defect satisfies \(m(p)\equiv n\pmod 2\). Hence the bound of Theorem 4 sharpens
off the residue \(n\equiv2\pmod4\):

- \(n\) odd: every \(\lvert m(p)\rvert\ge1\), so
  \(\lvert A\rvert\ge\frac1{16}\bigl((n-6)\binom n3+\binom n2\bigr)\);
- \(n\equiv0\pmod4\): \(m\equiv0\) would exhibit a symmetric conference matrix of
  order \(n\), which cannot exist, so some \(\lvert m(p)\rvert\ge2\) and
  \(\lvert A\rvert\ge\frac1{16}\bigl((n-6)\binom n3+4\bigr)\).

At \(n=7\) this raises the bound from \(2.19\) to \(3.5\), so \(\lvert A\rvert\ge4\)
against a true minimum of \(5\); at \(n=8\), from \(7\) to \(7.25\), so
\(\lvert A\rvert\ge8\) against a true minimum of \(10\); at \(n=9\), from
\(15.75\) to \(18\).

Even on the residue \(n\equiv2\pmod4\) the bound is attained only when a
symmetric conference matrix of order \(n\) exists, and by the classical necessary
condition of Belevitch and of van Lint and Seidel that requires \(n-1\) to be a
sum of two squares. The first \(n\equiv2\pmod4\) failing it is \(n=22\), where
\(21=3\cdot7\) is not a sum of two squares; the next are \(n=34,58,70\). So the
minimum number of aligned four-sets on \(n\) points is controlled by a
number-theoretic condition on \(n-1\), and at those sizes every two-graph carries
a forced quasirandomness deficiency. What that minimum is at \(n=22\) is not
known here.

## 3. The design law and exactly where it fails

**Corollary 9.** Let \(\Delta\) be a regular two-graph, so that
\(S^2=\varsigma S+(n-1)I\) with \(\varsigma=\rho_1+\rho_2\); equivalently
\(m\equiv\varsigma\). Then

\[ \lambda_3(t)=\frac{n-6+3\,\varsigma\,\sigma(t)}{4}
   \qquad\text{and}\qquad
   \lvert A\rvert=\frac{n(n-1)\bigl(n^2-8n+12+3\varsigma^2\bigr)}{96}. \]

Consequently \(A(\Delta)\) is a \(3\)-\((n,4,\tfrac{n-6}4)\) design **iff**
\(\varsigma=0\), i.e. iff \(\Delta\) is a conference two-graph.  If both
coherent and incoherent triples occur and \(\varsigma\ne0\), the two displayed
values of \(\lambda_3\) are distinct, so the aligned family is not a
3-design.  The constant two-graphs are the degenerate exception to that last
sentence: their aligned family is complete.

*Proof.* Theorem 2 and Corollary 3 with \(m\equiv\varsigma\); the constant
\(\varsigma\) is the two-graph's eigenvalue sum because \((S-\rho_1I)(S-\rho_2I)=0\)
and \(\operatorname{tr}(S^2)=n(n-1)\) with \(\operatorname{tr}S=0\) force
\(\rho_1\rho_2=-(n-1)\). ∎

This corrects the scope of the design fact as the task card stated it. It holds
for conference two-graphs, not for regular two-graphs in general, and among
regular two-graphs the aligned count is again minimised at \(\varsigma=0\).

## 4. The promised anchor is worth exactly two bits

**Theorem 10.** For any four-set \(Q_0\), the set of two-graphs in which \(Q_0\) is
aligned is a subgroup of \(\mathcal T_n\) of index exactly \(4\).

*Proof.* Restriction \(\rho_{Q_0}\colon\mathcal T_n\to\mathcal T(Q_0)\cong\mathbf F_2^3\)
is \(\mathbf F_2\)-linear, and surjective because any two-graph on \(Q_0\) extends
by taking the descendant graph to be supported inside \(Q_0\). Alignment of
\(Q_0\) says \(\rho_{Q_0}(\Delta)\) lies in the two-element subgroup of constant
functions, which has index \(4\) in \(\mathbf F_2^3\). ∎

**Corollary 11.** The anchor promise multiplies the candidate count by \(1/4\) and
so lowers every counting bound by exactly two: the promised-anchor counting
bound is \(\binom{n-1}2-3\). The entropy bound is likewise unchanged to leading
order. For any four-set \(Q\) with \(\lvert Q\cap Q_0\rvert\le2\) the joint
restriction \(\mathcal T_n\to\mathcal T(Q_0)\oplus\mathcal T(Q)\) is still
surjective, so conditionally on the promise such a test answers yes with
probability exactly \(1/4\); only the \(4(n-4)+1\) four-sets meeting \(Q_0\) in
three or four points are exempt, and they contribute at most one bit each. Hence
any promised-anchor family of size \(k\) satisfies
\(k\ge\bigl(\binom{n-1}2-3\bigr)/H(1/4)-O(n)=0.616\,n^2-O(n)\).

Since the exhibited family of \(3n^2-23n+45\) tests already solves the
promised-anchor problem, the promised-anchor variant has the same nonadaptive
bracket and the same \(\binom n2+O(n)\) adaptive complexity as the general
problem. **The anchor promise changes nothing beyond the \(O(1)\) tests the
general decoder spends locating an anchor.** Item 5's second special case is
closed, negatively, and the closure is a point in the manuscript's favour: the
paper's decoder solves the easier promised problem, and even that one needs
\(\Omega(n^2)\) tests nonadaptively.

## 5. The class is rigid, and the rigidity is worth \(O(n)\)

**Theorem 12 (no local move stays in the class).** Let \(S\) be a symmetric
conference matrix of order \(n\ge4\) and let \(S'\) negate the single pair
\(\{x,y\}\). Then for every \(z\neq x,y\),
\((S'^2)_{xz}=(S^2)_{xz}-2S_{xy}S_{yz}=-2S_{xy}S_{yz}\neq0\), so \(S'\) is not a
conference matrix.

The elementary pair flip is the move behind every local lower-bound argument in
the unpromised problem — it is what the non-bipartite-link criterion is about —
and it never survives the promise. Any lower bound for the promised problem must
therefore come from pairs of genuine conference two-graphs, not from
perturbations.

**Theorem 13 (support rigidity).** Let \(S,S'\) be symmetric conference matrices
of order \(n\) and let \(H\) be the graph of pairs on which they differ, with
support size \(s\). If \(H\neq\emptyset\) then (i) whenever \(s<n\), every
\(H\)-degree on the support is even and positive; and (ii) \(s\ge\sqrt n\).

*Proof.* Write \(S'_{xk}=\varepsilon_{xk}S_{xk}\) with \(\varepsilon=-1\) exactly
on \(H\). Subtracting \((S^2)_{xz}=0\) from \((S'^2)_{xz}=0\) gives, for all
\(x\neq z\),
\(\sum_{k\in N_H(x)\triangle N_H(z)}S_{xk}S_{kz}=0\). Take \(x\) in the support
and \(z\) outside it: the index set is \(N_H(x)\), of size \(t=\deg_H(x)\ge1\),
and a \(\pm1\) sum of \(t\) terms vanishes only for \(t\) even, which is (i). For
(ii), set \(u=\sum_{k\in N_H(x)}S_{xk}e_k\) and \(v=Su\). Then
\(\lVert v\rVert^2=u^{\mathsf T}S^2u=(n-1)t\), while \(v_z=0\) for every \(z\)
outside \(\operatorname{supp}(H)\cup\{x\}\) and \(\lvert v_z\rvert\le t\)
elsewhere, so \((n-1)t\le(s+1)t^2\) and \(s+1\ge(n-1)/t\). As \(t\le s-1\) this
forces \(s^2\ge n\); and if \(s=n\) the claim is trivial. ∎

So two distinct conference two-graphs never agree on all pairs outside a set of
fewer than \(\sqrt n\) points. Read as a decoder saving, that is: the promise
lets a decoder omit the pairs inside one set of size \(\lceil\sqrt n\rceil-1\)
and recover them, worth fewer than \(n/2\) tests against a budget of
\(\binom n2\). The rigidity is real and its cash value is \(O(n)\).

## 6. What this settles about query complexity

**Item 5(b) — may the decoder assume the design property?** Yes, and it gains
nothing by doing so.

**Proposition 14 (the design law is inert).** Suppose a decoder knows the design
law \(\lambda_3\equiv(n-6)/4\) and uses it to infer unasked answers: whenever
\(n-4\) of the \(n-3\) four-sets through some triple are known, the last is
determined. Let \(K\) be the asked set, \(\lvert K\rvert=k\), and \(\bar K\) its
closure under repeated inference. Then \(\lvert\bar K\rvert\le
k\,(n-4)/(n-8)\) for \(n>8\).

*Proof.* Each four-set lies in four triples, so
\(\sum_t\lvert\bar K\cap\operatorname{pencil}(t)\rvert=4\lvert\bar K\rvert\). Every
triple that ever fires has at least \(n-4\) of its pencil in \(\bar K\), so the
number of firing triples is at most \(4\lvert\bar K\rvert/(n-4)\), and each
contributes at most one new four-set. Hence \(\lvert\bar K\rvert\le k+
4\lvert\bar K\rvert/(n-4)\). ∎

The design law therefore inflates a decoder's knowledge by a factor
\(1+O(1/n)\) and cannot move the leading term of any bound. The reason is
structural rather than accidental: the law is a statement about \(\binom n3\)
global counts, and no individual answer is pinned until all but one test in a
pencil has been spent, which no \(O(n^2)\)-budget decoder ever does.

**Item 5(a) — does the class need fewer tests?** The lower bound drops and the
upper bound does not move.

*From below.* Any decoder correct on every labelled conference two-graph on
\(n\) points needs at least \(\log_2 N_n-1\) tests, where \(N_n\) is their
number; the \(-1\) is exactly right, because the complement of a conference
two-graph is again one (its regularity parameter is \((n-2)-a=a\)), so the
complement ambiguity is intrinsic to the class and no larger. For \(n=q+1\) with
\(q\equiv1\pmod4\) a prime power, the Paley conference two-graph has
\(\lvert\operatorname{Aut}\rvert=\lvert P\Sigma L(2,q)\rvert=O(n^3\log n)\), so
\(N_n\ge n!/O(n^3\log n)\) and the bound is at least \(n\log_2 n-O(n)\)
unconditionally.

*The reduction.* Whether the promise actually lowers the \(\Theta(n^2)\)
requirement is exactly the question whether \(\log_2 N_n=o(n^2)\) — the
enumeration problem for symmetric conference matrices, which is open. If the
count is \(2^{\Theta(n\log n)}\) then the promise is worth a factor
\(\Theta(n/\log n)\) in the lower bound, but no proof is available in either
direction, and the constructions were not audited: the C880 literature audit did
not search conference-matrix enumeration, so nothing here should be read as a
claim about what is known. This is the cleanest statement of what
item 5(a) is: **from below, the conference-promised query complexity is the
conference-matrix counting problem.**

*From above, the mechanisms that do not work.* Theorem 4 places the promised
instance at the minimum of yes-answers; Corollary 6 says every four-point
statistic is constant across the class, so the promise pins in advance
everything a counting decoder could learn; Theorem 12 removes every local
mechanism; Theorem 13 certifies \(O(n)\) of savings; Proposition 14 makes the
design law inert.

*From above, the one mechanism that does work.* The promise is a system of
\(\binom n2\) orthogonality relations, and a decoder can spend tests on part of
the matrix and solve for the rest. Suppose it learns \(k\) full rows of \(S\), at
one test per pair by the attachment mechanism, so \(\approx kn\) tests. For each
remaining point \(y\), orthogonality of row \(y\) against those \(k\) rows gives
\(k\) linear equations over \(\mathbf Z\) whose unknown is the \(\pm1\) vector of
the still-unknown part of the row. Each such equation cuts the number of
surviving \(\pm1\) vectors by a factor of order \(\sqrt n\), by the local central
limit theorem, so \(k=\Theta(n/\log n)\) equations should determine the row
outright and the decoder pays

\[ \Theta(n^2/\log n) \]

tests in total — the first bound under the promise that beats the general
decoder's \(\binom n2+n-4\). What makes this a conjecture rather than a theorem
is the worst case: the \(\sqrt n\) factor is the generic behaviour, and a
conference matrix whose rows carry arithmetic structure could admit many
spurious \(\pm1\) solutions. Ruling that out is exactly an inverse
Littlewood–Offord statement in the sense of Tao and Vu — few solutions unless the
coefficient vector has additive structure — applied to the rows of a conference
matrix. Theorem 13 is the \(k=0\) case of the same mechanism: there the vanishing
of \(Su\) outside the difference support is precisely the orthogonality system,
and the crude \(\ell_2\) count gives \(\sqrt n\) where the Littlewood–Offord
count should give \(\Theta(n/\log n)\).

So the gap is from \(\Omega(n\log n)\) to \(O(n^2/\log n)\) conditionally, and to
\(O(n^2)\) unconditionally.

*The one route that could close it.* If the promise is narrowed from "some
conference two-graph" to "some labelled copy of a fixed quasirandom conference
two-graph" — Paley, say — the problem becomes recovery of an unknown labelling,
and a counting argument suggests \(\Theta(n\log n)\) nonadaptive tests: a random
family of \(Cn\log n\) tests should separate all relabellings, because a
permutation moving \(k\) points changes the alignment of a \(\Theta(k/n)\)
fraction of four-sets while only \(n^{O(k)}\) such permutations exist. Making
that rigorous needs a quantitative discrimination bound of the form
"\(\Delta\) and \(\Delta^\pi\) differ on \(\Omega(k/n)\binom n4\) four-sets",
which for Paley is a character-sum estimate; Corollary 3 reduces it to a
statement about how far \(\pi\) moves the pair-defect profile. That is the
concrete next move if item 5 is continued, and it would produce the first
genuine separation between the promised and unpromised problems.

## 7. Handoff notes (no manuscript edits made)

- Corollary 5 gives a two-line proof that every two-graph on at least seven
  points has an aligned four-set, together with the exact six-point exceptions.
  If Paper III's anchor-existence route is longer than this, the substitution is
  a cheap upgrade — but promotion is C816's, and the Lean statement is C815's
  while its modules remain open. Nothing here was carried into either.
- Theorem 4 and Corollary 5 also supply the missing "why" for the six-point
  witness the manuscript already quotes, which is a stronger sentence than the
  present enumeration-only one.
- Corollary 9 corrects the scope of the design fact as the task card stated it:
  the 3-design property holds for conference two-graphs, not for regular
  two-graphs generally.

## Verification

The identities were checked exhaustively at the sizes where exhaustion is
possible. This is an arithmetic guard, not evidence: every claim above is
proved.

Replay:

```
uv run --with numpy python notes/2026-08-11-c880-item5-structure-check.py
```

| Artifact                                         | SHA-256                                                            |
| ------------------------------------------------ | ------------------------------------------------------------------ |
| `notes/2026-08-11-c880-item5-structure-check.py`  | `e73552411b8d1f8fd2beeb05df5f0b9ec5a2b1843abccbde6561724ef6689eaa` |
| `notes/2026-08-11-c880-item5-structure-check.out` | `0d1cc520edafcdc3ddd89310c4c2a215aed763d6aef79a07a3cdc8971931c129` |

Results: the pair-degree law of Corollary 3, the spectral form of Corollary 7 and
the signed split of Corollary 6 all hold for every one of the
\(2^{\binom{n-1}2}\) two-graphs at the sizes tested, with no mismatch; the
minimisers of \(\lvert A\rvert\) at \(n=6\) are twelve in
number and all twelve satisfy \(S^2=5I\), while at \(n=5,7,8\) — where
\(n\not\equiv2\pmod4\) — none do and the minimum sits strictly above the bound
(\(5>4\) at \(n=7\), \(10>8\) at \(n=8\) against the sharpened bounds of
Corollary 8); and the Paley conference two-graph on ten points has
\(\lvert A\rvert=30\) as predicted, with \(\lambda_3\equiv1\), a
\(3\)-\((10,4,1)\) design whose five-set profile is the degenerate one — 72
five-sets carry no aligned four-set and 180 carry exactly one.

No independent replay exists. None is owed: the script checks proved identities
rather than establishing them, and a disagreement would falsify the arithmetic
in §2–§3 directly.

## Mystery ledger

- **Settled — why six points fail.** Previously an enumeration result with no
  mechanism. Theorem 4 identifies the failures as the equality cases of a
  sum of squares of pair defects, and the count of twelve labelled exceptions is
  forced.
- **Settled — the design property's scope.** It was carried as a fact about
  regular two-graphs; Corollary 9 gives the conference parameter exactly in the
  conference case and computes the two-valued \(\lambda_3\) whenever both
  triple signs occur in a nonconference regular two-graph.
- **Settled — what the answers carry in aggregate.** The task card flagged the
  asymmetry between yes and no answers as the place a stronger lower bound should
  come from. Corollary 6 closes that off completely: every four-point statistic
  is a function of the defect vector, and on the conference class the defect
  vector is zero, so all of them are constant across the whole class. No counting
  argument at the four-point level can separate two conference two-graphs, and
  the first statistic that can vary lives on five points.
- **Settled — what kind of statement Theorem 4 is.** It is the equality case of a
  quasirandomness theorem. \(\sum_p m(p)^2\) is a discrepancy, conference
  two-graphs are the exactly quasirandom two-graphs, and the alignment oracle
  measures quasirandomness deficiency and nothing else. The usual Chung–Graham–
  Wilson equivalences are asymptotic; this one is exact, which is the surprise.
- **Settled — whether the promises help.** The anchor promise is worth two bits
  (Theorem 10); the design law is worth a factor \(1+O(1/n)\) (Proposition 14);
  the rigidity is worth \(O(n)\) tests (Theorem 13). None changes a leading term.
- **Open — is \(\log_2 N_n=o(n^2)\)?** The whole lower-bound content of the
  conference promise reduces to this count of symmetric conference matrices. No
  gate inside this lane can settle it; it is a question about conference
  matrices, and the literature audit in
  `notes/2026-08-07-c880-literature-audit.md` did not search it.
- **Open — is the \(\sqrt n\) of Theorem 13 tight?** The proof balances
  \(\lVert v\rVert^2=(n-1)t\) against \(s+1\) coordinates of size at most \(t\),
  which is tight only if the difference vector is flat. No example approaching
  \(\sqrt n\) is known, and the parity constraint (i) already rules out the
  natural candidate, a complete block flip on an odd-sized set. The truth may be
  \(\Omega(n)\), which would matter: it would say the promise certifies no
  savings at all.
- **Open — the extremal structures when \(n\not\equiv2\pmod4\).** At \(n=7\)
  there are 3024 minimisers with \(\lvert A\rvert=5\) and at \(n=8\) there are
  4200 with \(\lvert A\rvert=10\), against the sharpened bounds \(4\) and \(8\)
  of Corollary 8. By Corollary 3 these are the two-graphs minimising
  \(\sum_p m(p)^2\), the two-graphs as close to regular as the congruence
  permits. Their classification is not needed for C880 and is logged to the
  discovery track rather than pursued.
- **Open — the minimum at the arithmetically obstructed sizes.** Corollary 8
  shows the bound of Theorem 4 is attained only when \(n-1\) is a sum of two
  squares, so at \(n=22,34,58,70\) every two-graph carries a forced
  quasirandomness deficiency. How large it is at \(n=22\) — the smallest such
  size — is not known here, and neither is whether the minimisers there are the
  regular two-graphs with the smallest \(\lvert\varsigma\rvert\). This is a
  genuinely arithmetic constraint on a purely combinatorial reconstruction
  quantity, and it is the one place where item 5 touches the lane's own subject.
- **Open — does the five-point profile carry the labelling?** Corollary 6 says
  the signal starts at five points. At \(n=10\) it is degenerate: every five-set
  contains \(0\) or \(1\) aligned four-sets (72 and 180 of them), forced by
  \(\lambda_3=1\) rather than informative. The first size where the profile can
  vary is \(n=14\), where \(\lambda_3=2\). Whether it separates labelled copies
  is untested and is the cheapest experiment left in item 5.
- **Open — the conditional \(O(n^2/\log n)\) decoder.** The row-solving route in
  §6 needs an inverse Littlewood–Offord bound for the rows of a conference
  matrix. If it holds, the promise buys a \(\log n\) factor and Theorem 13's
  \(\sqrt n\) is far from tight; if some conference matrix is degenerate enough
  to defeat it, that matrix is itself an interesting object.
