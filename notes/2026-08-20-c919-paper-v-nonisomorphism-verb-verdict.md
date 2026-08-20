# C919 verdict — the non-isomorphism sentence stays stative; a numbered remark in Paper V must carry the mod-11 node argument

**Lane:** `clebsch` · **Date:** 2026-08-20 · **Task:** verdict on the verb of the abstract sentence
"over \(\overline{\F}_{11}\) the conference cubic is not projectively isomorphic to either chordal
cubic" in `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.tex`
(commit `cca62972b`). Evidence dossier:
`notes/2026-08-20-c919-paper-v-nonisomorphism-verb-evidence.md`. Read-only task; no manuscript edit
was made.

**Ruling (one line):** Paper V may NOT write the sentence in the first person; the stative sentence
is right and needs no abstract change, but it is currently unsupported in any characteristic-11
sense and must be backed by a new numbered remark in Paper V (drafted below), with the two body
passages that import Paper I's node count repointed to that remark and the word "exactly" at
line 692 softened or separately certified.

## The finding that reframes the dossier's question 3

The dossier describes Paper I's contribution as "a statement about \(\F_{11}\)-rational singular
points." That is not what Paper I proves. I verified the corollary *Nodes, symmetry, and integral
commutant* (`papers/clebsch-rigidity/clebsch_rigidity.tex`, statement at lines 1442–1461, proof
stage "The node frame" at lines 1622–1775):

- The corollary is stated in \(\mathbf P(\mathbf Q^6/\mathbf Q\mathbf 1)\) — characteristic zero,
  not \(\F_{11}\).
- The completeness step (exactly six singular points) is a chart-by-chart Gröbner classification,
  and the manuscript's own certification sentence (lines 1737–1741) scopes the kernel checks as:
  the derivative identity "over any commutative ring containing a root of \(t^2=t+1\)", but the
  classification of singular points only "over any field of characteristic zero containing such a
  root."

So the gap is wider than rational-versus-geometric: Paper V's two imports (lines 489–492 and
691–693) cite a characteristic-zero corollary inside \(\F_{11}\) statements. The gap crosses
characteristic first, and only then the algebraic closure.

## What transfers to characteristic 11, and by what argument

Three ingredients of Paper I's proof are integer identities, hence valid over \(\Z\) and after
reduction mod 11:

1. **Gradient vanishing.** The vanishing of the five gradient quadrics of \(C\) at the integer
   vectors \(\mathbf 1-6e_a\) is an identity of integers, so the six points
   \(p_a=[\mathbf 1-6e_a]\) are singular on \(C=0\) over \(\F_{11}\). They are pairwise distinct
   mod 11 because their coordinates are \(1\) and \(-5\equiv 6\), and \(6\ne 1\) in \(\F_{11}\).
2. **Hessian evaluation.** \(\operatorname{Hess}(C)_{ij}(p_a)=-6c_{aij}\) for
   \(a\notin\{i,j\}\), zero otherwise (Paper I, lines 1751–1758), is an integer identity.
3. **Nondegeneracy.** The nonzero Hessian block is switching-equivalent to a \(5\times5\)
   principal minor \(M\) of \(B\); the block decomposition of \(B^2=5I\) gives \(Mu=0\) and
   \(M^2=5I\) on \(u^\perp\) (Paper I, lines 1760–1772). Over \(\F_{11}\): \(2,3,5\) are units and
   \(\sqrt5=\pm4\), so \(\ker M\) is exactly the \(u\)-line, the induced form on the
   four-dimensional projective tangent space is nondegenerate, and each \(p_a\) is an ordinary
   node. Nondegeneracy of a quadratic form is preserved by field extension, so each \(p_a\) is an
   ordinary node over \(\overline{\F}_{11}\) — in particular an **isolated point of the geometric
   singular locus**.

What does **not** transfer as written: completeness. "Exactly six" over \(\overline{\F}_{11}\)
would need the Gröbner chart classification rerun mod 11 (upper semicontinuity allows the special
fibre of the singular scheme to jump). Paper I's certification does not cover it, and Paper V's
existing checker only "enumerates the rational singular loci" (line 1498), which cannot exclude a
positive-dimensional geometric component with few rational points.

## Answers to the dossier's four questions

**1. Does the characteristic-zero classical fact make first person an overclaim?**
Yes, but not for the GIT reason. The Casalaina-Martin–Grushevsky–Hulek–Laza footnote (chordal cubic
as the unique semistable cubic threefold with non-isolated singularities, attributed to Allcock's
Theorem 1.3(iii)) is a characteristic-zero GIT statement and neither proves nor is needed for the
\(\F_{11}\) claim; citing it for the abstract sentence would misattribute. The real reason first
person overclaims is elementarity: once the nodes are known to persist mod 11, the non-isomorphism
is a two-line invariant comparison. Over \(\C\) nobody would cite Allcock for it — the
singular-locus dimensions differ. "We show" would headline either a classical restatement or a
two-line remark; it is neither a contribution nor classical-with-citation. No citation, no first
person.

**2. Does the singular-locus-dimension argument settle it in any characteristic?**
Yes, in the sharper isolated-point form, in every characteristic where the node argument runs
(invertibility of \(2,3,5\) suffices; \(\F_{11}\) qualifies). The clean statement avoids
completeness entirely: an ordinary node is an isolated point of the singular scheme; each chordal
cubic's singular scheme is a rational normal quartic — Paper V's own Lemma
`lem:hankel-singular-locus` proves the saturated Jacobian ideal equals the Hankel-minor ideal by
exact polynomial identities, so the statement base-changes, and a smooth irreducible curve has no
isolated point after any extension; a projective isomorphism carries singular scheme to singular
scheme. One node suffices; "exactly six" is never used. The second chordal cubic is covered by the
displayed projectivity \(U(h_M)=8H\) (line 483). Consequence for the abstract: the sentence needs
neither a citation nor a verb — its own first half ("six isolated nodes" against "singular along a
rational normal quartic") already displays the reason. The stative construction is correct as
written.

**3. Does the geometric-versus-rational gap need closing first?**
Yes — and it is a characteristic gap before it is a rationality gap; see the finding above. As the
manuscript chain stands, even the stative sentence is unproved: no statement in Paper I or Paper V
asserts nodality of the conference cubic in characteristic 11, geometric or rational. The
geometric statement does follow, by the integer-identity reduction in the previous section, but
that argument appears nowhere. This is exactly what the numbered remark must close. Until it
exists, lines 489–492 ("six isolated nodes by \cite{RuddRigidity2026}") and 691–693 ("exactly six
ordinary nodes in projective-frame position") both lean on a characteristic-zero corollary for
\(\F_{11}\) conclusions.

**4. The numbered remark: statement, sketch, and home.**
It belongs in **Paper V**. Paper V is where the characteristic-11 claims live; Paper I's corollary
is deliberately a characteristic-zero statement and reopening a released paper to serve one
importer is the wrong trade. The remark is self-contained given that Paper I's Hessian evaluation
is an identity of integer matrices. Suggested placement: in Section "The singular quartic recovers
the axes", after Lemma `lem:hankel-singular-locus`, or adjacent to the placement proposition; then
lines 489–492 and 691–693 cite the remark instead of citing \cite{RuddRigidity2026} directly for
the mod-11 conclusion.

Draft (labels to be fitted to Paper V's conventions):

> **Remark (Nodes persist in characteristic eleven).** Let \(c(x)=\sum c_{ijk}x_ix_jx_k\) be a
> conference generator, \(c_{ijk}=B_{ij}B_{jk}B_{ki}\) with \(B^2=5I\). The six points
> \(p_a=[\mathbf 1-6e_a]\) are distinct in \(\PP(V)\) and each is an ordinary node of \(c=0\) over
> \(\overline{\F}_{11}\): the gradient and Hessian evaluations in the corollary *Nodes, symmetry,
> and integral commutant* of \cite{RuddRigidity2026} are identities of integer matrices, the
> Hessian block at \(p_a\) is switching-equivalent to a principal \(5\times5\) minor \(M\) of
> \(B\), and \(B^2=5I\) gives \(Mu=0\) and \(M^2=5I\) on \(u^\perp\) for the deleted row \(u\);
> since \(2\), \(3\), and \(5\) are invertible in \(\F_{11}\), the induced form on the projective
> tangent space is nondegenerate, and nondegeneracy survives field extension. Each \(p_a\) is
> therefore an isolated point of the singular scheme. By
> Lemma~\ref{lem:hankel-singular-locus} and the projectivity \(U(h_M)=8H\), each chordal cubic is
> singular exactly along a rational normal quartic after any base change — a smooth curve with no
> isolated point. A projective isomorphism preserves the singular scheme, so over
> \(\overline{\F}_{11}\) the conference cubic is not projectively isomorphic to either chordal
> cubic.

## Exactly what must change

1. **Abstract:** no change. The stative sentence stands once the remark exists.
2. **Add the numbered remark above to Paper V** and make it the stated ground of the abstract
   sentence.
3. **Line 489–492:** repoint — "six isolated nodes by \cite{RuddRigidity2026}" becomes a citation
   of the new remark (which itself cites Paper I for the integer identities).
4. **Line 691–693:** same repointing, and drop "exactly" from "exactly six ordinary nodes", since
   completeness in characteristic 11 is uncertified. Alternative that keeps "exactly": extend the
   paper-owned checker (`verification/evidence/paper_ii_chordal_axis.py`) with a mod-11 Gröbner
   dimension-and-degree check of the conference Jacobian ideal — the singular scheme commutes with
   base change, so a zero-dimensional degree-six result over \(\F_{11}\) certifies the geometric
   count. Cheap, but optional: nothing in Paper V's arguments uses exactness.
5. **No citation** of Casalaina-Martin–Grushevsky–Hulek–Laza or Allcock for this sentence. If
   characteristic-zero context is wanted anywhere, it belongs in prose as background ("over \(\C\)
   this separation is classical"), not as support for the \(\F_{11}\) claim.

## Sources named, with read depths

Conventions read in full: `notes/literature-audit-conventions.md`. No new literature searches were
run for this verdict; no new source was fetched. Zero sources were read at full text for this
verdict; the manuscript sources below were read directly, the literature sources only through the
evidence dossier.

- Paper V, `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.tex` at
  `cca62972b` — **partial**: abstract (lines 50–95), introduction (96–114), placement proof tail
  (470–500), Hankel lemma with proof (504–542), two-graph section (614–697), verification and
  conclusion (1482–1526).
- Paper I, `papers/clebsch-rigidity/clebsch_rigidity.tex` — **partial**: the theorem *Support
  cubic and golden continuation* and corollary *Nodes, symmetry, and integral commutant*
  (1352–1461) and their joint proof through "Frame symmetry" (1463–1796), plus targeted greps for
  characteristic and node statements.
- Casalaina-Martin, Grushevsky, Hulek, Laza, "Complete moduli of cubic threefolds and their
  intermediate Jacobians" (arXiv:1510.08891) — **secondary only**, through the evidence dossier
  `notes/2026-08-20-c919-paper-v-nonisomorphism-verb-evidence.md`, whose own depth is partial
  (extraction lines 296–303, 392–412).
- Allcock, "The moduli space of cubic threefolds" — **secondary only**, through the same dossier's
  record of the Casalaina-Martin–Grushevsky–Hulek–Laza footnote; the chain bottoms out at partial.
- Cheltsov, Tschinkel, Zhang (arXiv:2401.10974, and the CTZ2025 citation inside Paper I) —
  **secondary only**, through the dossier (partial) and Paper I's own citation sentence
  (lines 1360–1372); used here only as context for the six-nodal model, nothing load-bearing.
- Hassett–Tschinkel, Proposition 10 as characterized inside Paper I (lines 1743–1749) —
  **secondary only**, through Paper I; explicitly non-load-bearing there and here.

Coverage for the absence claims (no positive-characteristic source for the separation, none for
the \(A_5\)-pencil over \(\F_{11}\)) is owned by the dossier's coverage statement; this verdict
adds no width to it and inherits its limits (MathSciNet NOT COVERED, zbMATH not queried). The
verdict does not rest on those negatives: the ruling is grounded in elementarity, not novelty.

## Mystery ledger

- **Settled:** why Paper V's two body passages stop at "the lines are distinct" — the available
  citation only supports a characteristic-zero statement, and the drafters evidently did not
  bridge the characteristic. The bridge is the integer-identity reduction recorded above.
- **Settled:** the dossier's rational-versus-geometric framing understated the gap; the corollary
  it worried about is characteristic-zero to begin with. No blame attaches — the corollary's
  statement over \(\mathbf Q\) reads as generic until its certification sentence is checked.
- **Open, with owner:** completeness of the conference singular locus over
  \(\overline{\F}_{11}\) ("exactly six") is uncertified. Owner: Paper V's checker if exactness is
  ever wanted (item 4 above); no current claim needs it once "exactly" is dropped.
- No other genuine mystery remains: the invertibility conditions (\(2,3,5\)) are exactly the
  primes visible in the Hessian identity, and \(11\nmid 30\) is not a coincidence the paper needs
  to explain.
