# Paper V series cold referee — Packets IV/T

**Verdict: MAJOR**

## Source control and reading record

I verified the SHA-256 of the frozen manuscript
`golden_companion_reconstruction.pdf` as
`c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`
and read manuscript PDF pages 1–18 in full. I then read only the assigned
dossier ranges: lines 193–211 and 389–482.

For the series-import audit I consulted these exact predecessor locations:

- Paper I, `clebsch_rigidity.pdf`, PDF pp. 19–20, §8, Theorem 8.1 and
  Corollary 8.2.
- Paper II, `clebsch_factorization.pdf`, PDF p. 15, Theorem 3.9; pp. 19 and
  23, §4 and Theorem 4.6. Targeted text extraction also surfaced pp. 36, 41,
  and 43 (Appendices C, E, and §G); none supplies the missing Paper-V bridge
  calculation discussed below.
- Paper III, `clebsch_passages.pdf`, PDF pp. 4–5, Proposition 1.2.
- Paper IV, `passant_code_q13.pdf`, PDF pp. 9–11, the end of §3 and §4,
  especially Proposition 4.1 and its descent paragraph.

I treated executable checks and their outputs as deleted. I did not use them
as evidence.

## 1. Earliest unsupported implication

The earliest unsupported implication is the abstract's claim on manuscript
p. 1 that the classification places Paper II's signed cubic on a chordal line
and returns the retained outputs of Papers I–III exactly. The first attempted
support is Proposition 2.1 and its proof on pp. 5–6, but that proof does not
print enough input to check the asserted placement or either scalar. It prints
the matrices $T$ and $U$, while omitting the coordinates of the projected
tensor \(\nu\), the source generator matrices needed to check the intertwining
relations, the resulting axis cubic \(h_M\), the conference generator used in
the coefficient comparison, and the actual coefficient comparison producing
the pivot 3 and outer-difference coefficient 8.

This is a mathematical/trust defect, not a request for a longer computation.
The named Paper-II imports establish the quotient and the nonzero cubic-first
signed moment, but they do not determine which point of the two-dimensional
invariant cubic pencil its five-isotypic projection occupies. That is exactly
the new bridge Paper V must prove.

## 2. Smallest ambiguity witnessing the failure

After retaining only the named Paper-II results imported on p. 5, the projected
signed moment is a nonzero $A_5$-invariant cubic in a two-dimensional pencil.
Those imports alone do not distinguish the claimed chordal line from another
point of the pencil, nor do they fix the claimed scalars 3 and 8. Thus the
smallest ambiguity is replacement of the unprinted projected cubic by another
nonzero invariant cubic satisfying the stated imported properties. The text
provides no manuscript-visible calculation that excludes this ambiguity.

The verification discussion on p. 16 confirms rather than closes the gap: it
assigns precisely this placement and normalization to the Python/JSON leaf,
while also claiming that the replay is not a premise. With that leaf deleted,
the advertised source-placement conclusion has no checkable proof in the
paper.

## 3. Does the theorem survive a local repair?

The intrinsic core survives. Conditional on starting with a normalized metric
chordal shadow, the singular-quartic recovery, selected-line bridge,
information-loss analysis, uniform $D_n^\vee$ theorem, and Paper-IV
Frobenius comparison do not require the Paper-II coordinate leaf.

The headline series theorem does not survive merely by deleting one sentence.
A satisfactory repair is nevertheless localized: print a self-contained
finite certificate for Proposition 2.1 (enough source coordinates and the
resulting normalized cubic/coefficient identities to permit hand or
independent reimplementation), or weaken every Paper-II placement/return claim
to an explicit conditional statement. Merely citing the repository checker is
not a repair under Packet T's trust test.

## 4. Downstream scope requiring re-read

Repair of Proposition 2.1 requires re-reading every claim in its causal chain:

- the abstract and series perspective (pp. 1–2);
- Theorem 1.2(iii) and the Paper-II source arrow (pp. 3–4);
- Proposition 3.2's sentence identifying the recovered quotient with the
  original Paper-II six-set (p. 7), insofar as it presupposes placement;
- Proposition 4.1's normalized coefficient and Corollary 4.2 (pp. 8–9);
- the Paper-II row and inverse formula in Corollary 6.1 (pp. 11–12);
- the trust-boundary claims (p. 16) and the Paper-II sentence in the conclusion
  (p. 17).

The abstract groupoid result for an already normalized chordal input and the
integral results of §§7–10 need not be re-proved solely because of this repair.

## 5. Novelty boundary

The stated novelty boundary remains credible after the repair. The manuscript
does not inflate Paper IV into a geometric descendant: §10 explicitly keeps
the groups, modules, bases, and geometries separate and claims only a common
Frobenius-orbit mechanism. The uniform conference-lattice result also has a
printed, script-free proof and supplies a genuine statement beyond the order-six
example. The needed repair concerns proof/interface completeness, not priority.

## Other controlling findings

1. **The classification groupoids are not defined precisely enough to support
   the exact fibre claims.** Definition 1.1 (p. 3) and Definition 5.1 (p. 9)
   refer to “exactly” or “explicitly” allowed coordinated relabelings without
   listing them or defining how they act on the fixed $G$-module. This matters:
   §5.1 (p. 11) says $q$ is a morphism only when coordinated outer relabeling
   is allowed, while Proposition 5.2's full-faithfulness argument (p. 10) treats
   every allowed relabeling as already present. Until the morphism sets and the
   quotient by $uq$ are formalized, the claimed $C_2$ and Klein-four fibres
   are persuasive object counts but not a checkable equivalence of groupoids.
   This can be repaired locally by giving action-groupoid definitions and a
   source-by-source list of admitted relabelings; the geometric constructions
   need not change.

2. **The upper-branch application of the Frobenius lemma skips its hypotheses.**
   Lemma 10.1 itself is correctly stated and its descent conclusion does not
   assume the desired field. Paper IV's side is supported by its Proposition
   4.1 and descent paragraph (Paper IV pp. 10–11). On manuscript p. 16, however,
   the upper-branch sentence simply asserts that $H_{\Omega_0}$ has commutant
   $\mathbf F_4$ and two constituents. The preceding text shows an
   $\mathbf F_4$-action and simplicity as an $\mathbf F_4A_5$-module, but it
   does not explicitly prove simplicity over $\mathbf F_2$, the
   multiplicity-free two-constituent scalar extension, or equality of the full
   binary commutant with $\mathbf F_4$. A short representation-theoretic
   verification would close this local gap and make the advertised common
   mechanism follow from Lemma 10.1 rather than merely resemble it.

3. **The Paper-IV import lacks the stable result name required by the series
   interface.** Section 10 cites only “[12]” for simplicity, the three
   constituents, the commutant, and the operators. These claims do occur in
   Paper IV §4, Proposition 4.1 and its immediately following descent argument
   (pp. 10–11). Naming that result in Paper V is a small editorial repair. The
   Paper-I, II, and III imports checked here do have identifiable named sources.

In short: the Paper-IV bridge is appropriately modest and basically sound, and
the manuscript has a coherent series punchline. The present MAJOR verdict is
controlled by the non-self-contained Paper-II placement/normalization and by
the still-informal morphism categories on which the advertised exact return and
fibre statements depend.
