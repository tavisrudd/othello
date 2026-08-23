# Correction II (the weak-Fano example splits) and a candidate theorem: markedness is a birational invariant of smooth threefolds

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

## 1. Correction II: the §2 construction of the weak-Fano note is not minimal

In `2026-08-23-c925-fable-weak-fano-conic-bundle.md` §2, rotate
\((s_0,s_1)\) by the constant matrix sending \((c,d)\mapsto(1,0)\): the
quadratic form becomes
\(A's_0'^2+2B's_0's_1'+C's_1'^2+2s_0's_2\), with symmetric matrix
\(\bigl(\begin{smallmatrix}A'&B'&1\\B'&C'&0\\1&0&0\end{smallmatrix}\bigr)\).
Two consequences, both fatal to the example (not to the search):

1. \(\det=-C'\): the discriminant is the cubic \(E=\{C'=0\}\), and over
   **all** of it the fibre factors as
   \(s_0'\cdot(A's_0'+2B's_1'+2s_2)\) — the two rulings are globally
   labeled.  The line cover **splits**; \(X\) is not relatively minimal.
2. The lower-left \(2\times2\) minor is \(-1\ne0\) everywhere, so the
   rank never drops to one: consistent, since split covers have no
   branch nodes.

Contracting the labeled ruling \(\{s_0'=0\}\)-family (the surface
\(E\times\mathbf P^1\subset X\)) identifies \(X\cong
\mathrm{Bl}_E(\mathbf P^1\times\mathbf P^2)\), \(E\) a smooth plane cubic
in a fibre \(\{pt\}\times\mathbf P^2\); hence \(\rho(X)=3\) and
\(b_3(X)=2g(E)=2\), not \(0\).  The note's "\(\rho(X)=2\) by Lefschetz"
was invalid (the divisor class is not ample), and its \(b_3=0\) claim
used the b3-formula whose minimality hypothesis fails.  The E5-germ
observation survives only as a statement about the ambient
\(\mathbf P(\mathcal O^2\oplus\mathcal O(-3))\).  Genuine class-(a)
members over \(\mathbf P^2\), if any, are elementary transformations of
MM 2-24 along sections; none is exhibited yet.  The ambient-probe
certificate is unaffected (it computed the toric ambient, and its
negative finding about the non-convex twist stands).

## 2. Why the failed example still cannot carry a marked block — and the general principle

\(X\cong\mathrm{Bl}_E(\mathbf P^1\times\mathbf P^2)\): Iritani's
decomposition gives \(\mathrm{QDM}(X)\cong\mathrm{QDM}(\mathbf
P^1\times\mathbf P^2)\oplus\mathrm{QDM}(E)\); the base summand is
ledger-closed (toric) and the elliptic-curve summand is a rank-two
nilpotent block of class \(\{1/2,1/2\}\) — non-semisimple but
**unmarked** (the exponent-class tool verified curve summands at
\(g=0,2\); the grading argument gives \(\{1/2,1/2\}\) for every genus).
So \(X\) carries no \(\{1/6,5/6\}\) block.  Generalizing:

**Candidate theorem (markedness is birational).**  For smooth projective
threefolds, define *marked-free*: the block ledger of the quantum
connection over the coefficient field of any Iritani bulk curve contains
no block of Levelt class \(\{1/6,5/6\}\) (and no marked triple).  Then
marked-freeness is invariant under blow-up **and blow-down** along
points and smooth curves of arbitrary genus, hence — by
Abramovich--Karu--Matsuki--Wlodarczyk weak factorization, whose
intermediate varieties and centres are all smooth — a **birational
invariant**.  In particular every rational threefold is marked-free
(\(\mathbf P^3\) is), and the marked-block count of any threefold equals
that of any smooth birational model.

*Proof sketch and the two load-bearing points.*  (i) Both directions of
inheritance are formal: \(\Phi\) identifies the blow-up's ledger with
the disjoint union of the summands' ledgers, so the blow-up is
marked-free iff the base summand and the centre summand are; the centre
summand of a point is simple sheets, of a genus-\(g\) curve a
\(\{1/2,1/2\}\) block — unmarked for every \(g\), which is why arbitrary
centres are allowed even though ledger-**closedness** (semisimplicity)
is not preserved by \(g\ge1\) centres.  (ii) The chain bookkeeping —
reading all ledgers over compatible bulk-curve coefficient fields as the
factorization alternates ups and downs — is exactly the §6e/H-C
machinery of the marker note (Jacobian invertibility 5.18(7) plus loop
transport); making that composition airtight along an arbitrary AKMW
chain is the one genuinely open verification and the reason this is a
**candidate**, flagged for a dedicated red-team before any consumer
depends on it.

**Consistency checks.**  The cubic threefold (marked) is irrational;
\(V_{14}\) (marked, §6b table) is birational to the cubic — invariance
predicts equal markedness, as observed; \(\mathbf P^3\), quadric,
\(V_5\), \(V_{22}\), all rational and verified unmarked.  The candidate
theorem is not "too strong": it is precisely the abstract form of the
obstruction the telescope programme is building — the \(m=2\) endpoint
comparison *is* an instance of it.

## 3. Consequences if it survives vetting

1. **The \(b_3=0\) tail closes for every rational carrier** — and
   telescope vertex varieties are rational (birational to
   \(B\times\mathbf P^2\)-models), so the vertex side of the tail
   closes entirely; only non-rational centres can still threaten.
2. **The three-cycle centre gate reduces to irrational centres** with
   three cubic-Prym factors (the \(\ge15\)-dimensional pricing), cyclic
   symmetry, and an embedding into the telescope's 5-folds — a very
   thin class.
3. Class (a)/(b)/(c) computations stop being load-bearing for rational
   members and become consistency checks.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled (correction) | The weak-Fano example has split cover: \(X\cong\mathrm{Bl}_E(\mathbf P^1\times\mathbf P^2)\), \(b_3=2\), not class (a); two errors in that note (Lefschetz \(\rho\), minimality) recorded. | §1. |
| settled | \(X\) is nevertheless marked-free via the elliptic-centre decomposition. | §2. |
| candidate, flagged | Markedness is a birational invariant of smooth threefolds; rational \(\Rightarrow\) marked-free. | §2; open point = AKMW-chain field bookkeeping (§6e machinery, to be red-teamed). |
| open | Exhibit a genuine class-(a) member (elm of 2-24) or prove none exists. | §1 end. |

The candidate theorem, if it survives, is the largest single reduction
of the session: the residue would shrink to non-rational centres.
