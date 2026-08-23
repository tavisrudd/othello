# Carrier structure theorem: the non-Fano b3=0 tail reduces by smooth MMP to discriminantal conic bundles, low-degree del Pezzo fibrations, and two named boundary classes

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Attacks the sole remaining tail item of
`2026-08-23-c925-fable-b3zero-enumeration-closure.md` §3: non-Fano
\(b_3=0\) carriers.  The tool is the closure-class lemma of that note
(ledger-closedness closed under E1/E2 blow-ups and projectivizations over
ledger-closed bases) combined with Mori's classification of extremal rays
on smooth threefolds.  The result is not a full closure but a structure
theorem that shrinks "all smooth \(b_1=b_3=0\) threefolds" to four named
classes, two of which converge with the threefold-centre residue of
`2026-08-23-c925-fable-marker-is-levelt-exponent.md` §6f.

## 1. Two free corollaries of the closure-class lemma

**Corollary A (all rational surfaces).**  Every smooth projective rational
surface is ledger-closed.  *Proof.*  Minimal rational surfaces are
\(\mathbf P^2\) and the Hirzebruch surfaces \(\mathbf F_n\).
\(\mathbf P^2\) and \(\mathbf P^1\) have small quantum algebras
\(\mathbf C[h]/(h^3-q)\) and \(\mathbf C[h]/(h^2-q)\), étale on the whole
punctured torus (discriminants \(-27q^2\), \(4q\)); the anchor lemma is
dimension-free.  \(\mathbf F_n=\mathbf P(\mathcal O\oplus\mathcal O(n))\)
is a projective bundle over \(\mathbf P^1\), hence ledger-closed by
Iritani--Koto — no étale computation on \(\mathbf F_n\) itself is needed,
which matters because \(\mathbf F_n\) is not Fano for \(n\ge2\).  Every
rational surface is an iterated blow-up of one of these at points, and
point blow-ups preserve ledger-closedness by Iritani's decomposition,
which is stated in arbitrary dimension.  \(\square\)

**Corollary B (P^1-bundles).**  Every \(\mathbf P(E)\) with \(E\) a rank-2
bundle over a rational surface — equivalently every conic bundle with empty
discriminant over a rational base — is ledger-closed, by Iritani--Koto over
Corollary A.  Likewise every \(\mathbf P^2\)-bundle over \(\mathbf P^1\)
(the degree-9 "del Pezzo fibrations").

## 2. The reduction theorem

**Theorem.**  Let \(V\) be a smooth projective threefold with
\(b_1=b_3=0\).  Then exactly one of the following holds:

1. **(closed)** \(V\) is an iterated blow-up, along points and smooth
   rational curves, of a ledger-closed threefold base — a \(b_3=0\) Fano
   threefold of any Picard rank (all 59 families closed by the
   enumeration), a \(\mathbf P^1\)-bundle over a rational surface, or a
   \(\mathbf P^2\)-bundle over \(\mathbf P^1\) (Corollary B; rational
   surfaces enter only as bundle bases).  Then \(V\) is ledger-closed.
2. **(conic-bundle residue)** the recursion terminates in a Mori fibre
   space \(V_0\to S\) of relative dimension one — a conic bundle over a
   surface \(S\) with \(q(S)=0\) — with either nonempty discriminant
   \(\Delta\ne\emptyset\), or a non-rational base (Enriques or other
   \(q=0\) non-rational \(S\); for rational \(S\) with
   \(\Delta=\emptyset\) Corollary B closes it).  \(b_3(V_0)=0\) forces the
   total Prym of \(\widetilde\Delta\to\Delta\) to vanish.
3. **(del Pezzo residue)** the recursion terminates in a del Pezzo
   fibration \(V_0\to\mathbf P^1\) of fibre degree \(\le8\) with
   \(b_3(V_0)=0\) (degree 9 is Corollary B; the base is \(\mathbf P^1\)
   because \(b_1=0\)).
4. **(boundary classes)** the recursion cannot be continued in the smooth
   category: either some stage has every extremal ray of divisorial type
   E3, E4, or E5 (contractions to singular points: quadric or Veronese
   cone germs), or \(K_V\) is nef from the start (a non-uniruled smooth
   threefold with \(b_1=b_3=0\); no telescope example is known, but the
   class is not vacuous a priori and is recorded rather than assumed
   empty).

*Proof.*  If \(K\) is not nef, Mori's classification of extremal rays on a
smooth projective threefold (Mori, *Threefolds whose canonical bundles are
not numerically effective*, Ann. of Math. 116 (1982)) lists the
possibilities: fibre type C1/C2 (conic bundle over a surface), D1--D3
(del Pezzo fibration over a curve), Fano (\(\rho=1\)), or divisorial
E1--E5, with E1 the inverse of a blow-up along a smooth curve in a smooth
threefold, E2 the inverse of a point blow-up, and E3/E4/E5 contractions
onto singular targets.  No small (flipping) ray occurs on a smooth
threefold.  If some ray is E1 or E2, contract it: the target is smooth,
still has \(b_1=0\), and \(b_3(\mathrm{Bl}_CV')=b_3(V')+2g(C)\) with
\(b_3(V)=0\) forces both \(g(C)=0\) and \(b_3(V')=0\), so the recursion
invariant holds and the blow-up step is of exactly the type the
closure-class lemma admits.  The recursion terminates (each E1/E2 step
drops \(\rho\) by one).  At termination, either some ray is of fibre type
— giving case 2, 3, or a Fano of any Picard rank, which is case 1 by the
enumeration ("Fano" as an MFS over a point includes every \(\rho\)) — or
every ray is E3/E4/E5, or \(K\) has become nef, giving case 4.  The base
invariants in cases 2 and 3: \(q(S)=b_1(V_0)/2=0\), and for a fibration
over a curve \(B\), \(b_1(B)\le b_1(V_0)=0\) forces
\(B=\mathbf P^1\).  \(\square\)

**Remark (what this fixes in §6f).**  The marker-note §6f proposition
covered E1/E2 chains over a Picard-rank-one base and stated the residue as
del Pezzo fibrations and conic bundles.  The theorem above makes two
silent gaps explicit: the E3--E5-only stage (the smooth MMP can leave the
smooth category before reaching a Mori fibre space) and the \(K\)-nef
boundary.  Both are now named classes rather than omissions.  For the
E3--E5 stage the natural tool is a decomposition theorem for blow-ups of
mildly singular targets (the E5 germ is \(\tfrac12(1,1,1)\), the E3/E4
germs are quadric cones); the lane's own discrepancy-one flip note and the
Shen--Shoemaker line of results are the closest known technology, and this
is logged as the successor question rather than assumed.

## 3. Convergence of the two open gates

After this reduction the two residual quantum obligations of the
\(m=2\) programme live on the **same geography**:

- the **\(b_3=0\) carrier tail** (this note): classes 2--4 above, with the
  *no marked block at all* target;
- the **threefold-centre three-cycle gate** (marker note §6f): del Pezzo
  fibrations over \(\mathbf P^1\) and conic bundles over surfaces with
  arbitrary \(b_3\), with the weaker *no loop-conjugate marked
  three-cycle* target.

A single family of exponent-class computations on conic bundles
(discriminantal, over rational bases, stratified by the components of
\(\Delta\) and their Pryms) and on low-degree del Pezzo fibrations would
feed both.  The cubic threefold itself — a conic bundle over
\(\mathbf P^2\) with quintic discriminant and one marked block — is the
calibration point; the marker note's dictionary predicts marked blocks
count Prym-type odd cohomology, so on class 2 with vanishing total Prym
the prediction is *no marked block*, exactly the converse-HMT instance
(GS-carrier) needs.  The irregular-Hodge lead
(`2026-08-23-c925-fable-b3zero-tail-a2-reduction.md` §4) remains the
candidate uniform mechanism behind that prediction.

## 4. Residue after this note

1. Conic bundles with \(\Delta\ne\emptyset\), \(q=0\) base, vanishing
   total Prym (and the non-rational-base sliver, starting with
   \(S_{\mathrm{Enriques}}\times\mathbf P^1\)-type bundles, where even the
   base surface's ledger status is unknown).
2. Del Pezzo fibrations over \(\mathbf P^1\) of degree \(\le8\) with
   \(b_3=0\).
3. E3--E5-only stages (singular-target decomposition technology).
4. The \(K\)-nef boundary class (possibly empty among actual carriers; a
   telescope-side argument that carriers are uniruled would delete it).

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Every rational surface, and every \(\mathbf P^1\)/\(\mathbf P^2\)-bundle over one, is ledger-closed. | §1, dimension-free anchor + Iritani + Iritani--Koto. |
| settled | The non-Fano \(b_3=0\) tail reduces by smooth MMP to four named classes; rational centres and \(b_3=0\) propagate automatically down the recursion. | §2 theorem, Mori 1982. |
| settled | §6f's dichotomy had two silent gaps (E3--E5-only stages, \(K\)-nef boundary); now recorded. | §2 remark. |
| open, converged | Discriminantal conic bundles and degree \(\le8\) del Pezzo fibrations now carry BOTH open gates; exponent-class computations there feed both at once. | §3. |
| open | Uniruledness (or better) of actual telescope carriers — would delete class 4 and restrict class 2's bases to rational. | §4.4. |

No manufactured mysteries: the residue is §4's four items, of which the
first two are the mathematical core.
