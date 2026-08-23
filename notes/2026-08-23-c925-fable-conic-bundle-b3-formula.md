# b3 of a minimal conic bundle is twice the sum of (p_a - 1) over discriminant pieces: the P^2 residue is empty, and the true frontier is elliptic-configuration discriminants

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Executes the verification gate (caveats (i)–(ii)) of
`2026-08-23-c925-fable-conic-bundle-residue-anatomy.md` §3 — and the
verification **refutes that note's nodal-rational lead** while proving a
stronger classification.  The anatomy note's §3 was explicitly gated on
this check and asserted nothing; this note replaces it.

## 1. The formula

**Proposition.**  Let \(V\to S\) be a relatively minimal conic bundle,
\(V\), \(S\) smooth projective, \(S\) rational, with discriminant
\(\Delta=\bigsqcup_k\Delta_k\) (connected pieces).  Then
\[
  b_3(V)\;=\;2\sum_k\bigl(p_a(\Delta_k)-1\bigr).
\]

*Proof.*  For \(V\) smooth, \(\Delta\) has only ordinary double points,
the fibre over a smooth point of \(\Delta\) is a pair of distinct lines
(Euler number 3), and the fibre over each of the \(\delta\) nodes is a
double line (topologically \(\mathbf P^1\), Euler number 2) — the rank of
the conic drops to one exactly at the singular points of \(\Delta\)
(classical; a rank-two degeneration has smooth discriminant locally).
Stratifying,
\(e(V)=2e(S\setminus\Delta)+3e(\Delta\setminus\mathrm{Sing})+2\delta
=2e(S)+e(\Delta)-\delta\).
Since \(V\) is simply connected with
\(b_2(V)=b_2(S)+1\) (relative minimality) and \(e(S)=2+b_2(S)\),
\[
  b_3(V)=2+2b_2(V)-e(V)=-e(\Delta)+\delta
  =\sum_i(2\tilde g_i-2)+2\delta
  =2\sum_k(p_a(\Delta_k)-1),
\]
using \(e(\Delta)=\sum_i(2-2\tilde g_i)-\delta\) over the irreducible
components and \(p_a\) of a connected nodal curve
\(=\sum\tilde g_i+\delta-(\#\text{components}-1)\).  \(\square\)

This is the topological face of Beauville's admissible-cover Prym: the
line cover \(\widetilde\Delta\to\Delta\) is branched over the nodes (one
point above each), which is exactly Beauville's allowability condition,
so the Prym is an **abelian** variety of dimension \(\sum(p_a-1)\) — the
node cycles do not produce a multiplicative part that could hide from
\(H^3\).  Nodes count fully; geometric genus zero buys nothing.

## 2. Consequences

1. **The anatomy note's §3 lead is dead.**  There is no nodal-rational
   escape: a nodal quintic discriminant over \(\mathbf P^2\) gives
   \(b_3=2(p_a-1)=10\) regardless of its nodes — as it must, since the
   generic quintic conic bundle is the cubic threefold blown up along a
   line (\(b_3=10\), one marked block: the calibration row).
2. **Class (a) over \(\mathbf P^2\) is empty.**  \(b_3=d^2-3d\) vanishes
   only at \(d=3\), i.e. \(p_a=1\): the MM 2-24 family, closed.  Combined
   with the minimality filter (degrees \(\le2\) support no minimal conic
   bundle), **every relatively minimal conic bundle over \(\mathbf P^2\)
   with \(b_3=0\) is ledger-closed.**
3. **The true frontier: elliptic-configuration discriminants.**
   \(b_3=0\) forces every connected piece of \(\Delta\) to have
   \(p_a=1\): a smooth genus-one curve, a one-nodal rational curve, or a
   cycle of rational curves — with an irreducible line cover (étale
   two-torsion choice in the smooth case; branched-at-the-node covers in
   the nodal cases, automatically irreducible for the one-nodal rational
   piece).  On \(\mathbf P^2\) only one such piece fits (\(d=3\)); on
   general rational bases several disjoint \(p_a=1\) pieces can coexist —
   the canonical non-Fano examples are conic bundles over an elliptic
   rational surface (\(\mathrm{Bl}_9\mathbf P^2\)) whose discriminant is
   a disjoint union of \(k\) fibres of the elliptic pencil.  These, plus
   the analogous configurations over other rational surfaces, are the
   complete class (a) over rational bases, and the objects on which
   (GS-carrier) must be tested.
4. **Quantitative input to the three-cycle gate.**  For the \(b_3\ne0\)
   side (marker note §6f), the formula prices the danger scenario: three
   loop-conjugate cubic-type blocks need three five-dimensional
   cubic-Prym isogeny factors, hence
   \(\sum(p_a(\Delta_k)-1)\ge15\) — over \(\mathbf P^2\) a discriminant
   of degree \(\ge7\) at minimum, with the whole \(\ge15\)-dimensional
   Prym decomposing into three cyclically permuted cubic-type factors.
   The cyclic symmetry must come from a decktransformation-like
   automorphism of the pair \((S,\Delta)\) — a strong constraint to
   exploit next.

## 3. Status of class (a) after this note

| base | residue |
| --- | --- |
| \(\mathbf P^2\) | empty (2-24 closed; nothing else exists) |
| general rational \(S\) | conic bundles with disjoint-union-of-\(p_a=1\) discriminants and irreducible covers — first family: fibre-discriminants over \(\mathrm{Bl}_9\mathbf P^2\) |
| non-rational \(q=0\) \(S\) | untouched (Enriques sliver, carried) |

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | \(b_3=2\sum(p_a-1)\) for minimal conic bundles over rational bases; elementary Euler-characteristic proof; matches Beauville's abelian admissible Prym. | §1. |
| settled (negative) | The nodal-rational-discriminant lead of the anatomy note is refuted; its gated §3 is superseded. | §2.1. |
| settled | Class (a) over \(\mathbf P^2\) is empty beyond the closed 2-24 family. | §2.2. |
| open, sharpened | Class (a) = elliptic-configuration discriminants over non-minimal rational bases; first test family named (elliptic-fibre discriminants over \(\mathrm{Bl}_9\mathbf P^2\)). | §2.3. |
| open, new lever | Three-cycle gate now priced: \(\deg\Delta\ge7\) over \(\mathbf P^2\) plus a cyclic symmetry of \((S,\Delta)\) permuting three cubic-Prym factors. | §2.4. |

One genuine surprise, resolved: nodes never reduce \(b_3\) — Beauville's
allowability is precisely the mechanism that forbids the escape the
anatomy note hoped for.
