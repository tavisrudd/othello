# Red-team verdict: the birational-invariance candidate has a splitting hole on b3=0 members and demotes to curve-anchored transport; the tail is irreducibly Stokes content

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Red-teams the candidate theorem of
`2026-08-23-c925-fable-marked-block-birational-invariance.md` §2 as its
own note demanded.  Outcome: **not established as stated**; a precise
hole, a salvageable weaker theorem, and a mechanism worth keeping.

## 1. The hole: blow-down inheritance is curve-anchored, not origin-anchored

Iritani's decomposition identifies the blow-up's ledger with the base
summand \(\tau^*\mathrm{QDM}(X)\) — the ledger of \(X\) **along the
specific chain-induced bulk curve \(\tau\)**.  "Marked-free" as defined
quantifies over all of \(X\)'s bulk curves and its origin.  The gap
between the two is exactly **splitting**: a marked \(J_2\) at \(X\)'s
origin that splits along \(\tau\) into two simple sheets is invisible in
the blow-up's ledger (the sheets are simple, hence unmarked), so
markedness at the origin does not transport down the chain.  On
odd-cohomology members the marker note §6e excludes splitting by
Hertling--Manin--Teleman cornering; on \(b_3=0\) members nothing
excludes it — and "no splitting on \(b_3=0\) members" **is** the
(GS-carrier)/H-C obligation.  The candidate therefore does not close the
tail; unwound, it is circular over exactly the open case.

## 2. The mechanism: formal decompositions cannot see gluing

Why no cheap fix exists: one might hope to transport the honest
\(z\)-monodromy (formal data **plus** Stokes) instead of the ledger,
since monodromy is isomonodromy-constant even through confluences.  But
the numerical model kills this: for a semiorthogonal Gram
\(G=\bigl(\begin{smallmatrix}1&b\\0&1\end{smallmatrix}\bigr)\), the
monodromy \(S=G^{-T}G\) has characteristic polynomial
\(t^2-(2-b^2)t+1\) — the eigenvalues depend on the gluing number \(b\)
and are **not** additive over the pieces (this is the confluence rule
\(2\cos2\pi e=2-b^2\) of the marker note §6c, rederived).  Iritani's
isomorphism is formal in the Novikov/bulk variables and commutes with
\(\nabla_{z\partial_z}\), so it transports the **formal** Levelt data
(the ledger) — precisely why the programme uses ledgers — but a formal
isomorphism does not respect Stokes data, and the \(2\times2\) Gram
shows genuine monodromy is not decomposition-additive.  Ledger
statements transport but forget gluing; monodromy statements remember
gluing but do not transport.  The tail lives exactly in the difference:
**the remaining obligation is irreducibly Stokes/Gamma-II content**,
confirming and sharpening the marker note's assessment.

## 3. What survives (and is still useful)

1. **Curve-anchored transport, arbitrary chains, both directions.**
   Along any AKMW factorization (all centres and intermediates smooth),
   the ledger over the chain-induced coefficient fields decomposes step
   by step; point summands are simple, curve summands of every genus
   are unmarked \(\{1/2,1/2\}\).  Hence "no marked block along the
   chain-induced bulk curves" passes both up and down any chain.  This
   is the clean general form of the §6e bookkeeping and is what the
   telescope actually reads.
2. **Rational varieties are unmarked along chosen factorizations.**
   For rational \(X\), a factorization to \(\mathbf P^3\) plus the
   étale-anchor Hensel argument gives: \(X\)'s ledger is unmarked along
   the bulk curves that factorization induces.  What fails is
   curve-independence — the telescope's own curve need not be the
   chosen one — and closing that gap is again exactly no-splitting.
3. **The corrected weak-Fano example stays closed** (its markedness
   along the telescope-relevant curves is controlled by the elliptic
   blow-up decomposition; no origin claim needed).

## 4. Net effect on the programme map

- The candidate theorem is **withdrawn** as a gate-closer; its note's
  §3 consequences do not apply.  The card and handoff are updated.
- The two open rows (b₃=0 tail / three-cycle gate) do not merge into a
  birational-invariance statement; they remain what §6c-§6f said, with
  one clarification gained: any closure must either (i) prove
  no-splitting via Stokes data (Gamma-II: the split pair of a marked
  block carries \(ss'=-1\ne0\), so a *Stokes-decorated* ledger would
  transport — making the decorated ledger rigorous over the chain
  fields is the concrete technical target), or (ii) prove (GS-carrier)
  pointwise per carrier class, as before.
- Risk update: the candidate's failure costs nothing already built
  (nothing consumed it), and the red-team closes the "youth of the
  chain" concern for this particular claim in the cheapest way —
  before anything depended on it.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled (negative) | Birational invariance of origin-anchored markedness is not established; hole = splitting on \(b_3=0\) members; circular over the open case. | §1. |
| settled | Formal decompositions transport ledgers, not Stokes; monodromy is not decomposition-additive (\(t^2-(2-b^2)t+1\)). | §2. |
| settled | Curve-anchored transport along arbitrary AKMW chains, both directions, with any-genus curve centres. | §3.1. |
| open, sharpened | The whole tail = make the Stokes-decorated ledger (\(ss'\) recorded on split pairs) transport along chain fields — non-semisimple Gamma-II, now identified as *the* technical target. | §4(i). |

One theorem died young and cheaply; its autopsy located the exact
technology the tail needs.
