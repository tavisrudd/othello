# C930 independent referee report

**Lane:** `cubic-threefolds`

**Scope:** phase-1 proof memo only; strictly \(m=1\); no manuscript edits

**Material required by instruction:**
`notes/cubic-threefolds-tasks/c907-solver-dossier.md`

## Verdict

**Major revision required before manuscript work.**  The unconditional atomic
direct-QDM proof survives review and the proposed deletions can materially
shorten the paper.  The advertised common categorical theorem is nevertheless
too strong for the framed specialization: it requires an equality in a free
block monoid, while 5.7R and 5.7T supply certified equalities only after the
framed marker has been applied.  Thus the two proofs are not yet literal
instances of the theorem as stated.

## Findings

### 1. Blocker -- the framed provider does not inhabit Theorem A

The memo requires a block-level blowup equality in (C930.2), at
`notes/2026-08-20-c930-categorical-direct-qdm-proof-memo.md:60`--`69`, and
uses it in Theorem A at lines 93--108.  It then treats 5.7R as providing that
equality for the framed carrier at lines 252--278.

C925 states a weaker and exact interface.  The two conditional arrows are
marker-level certified edges, not isomorphisms of the full ambient or center
QDM (`notes/2026-08-19-c925-conditional-m1-specialization.md:99`--`109`).
The framed blowup law is an equality only after applying \(\nu_6\), at lines
159--167.  The current epilogue states the same boundary in
`papers/cubic-stabilization-epilogue/sections/05-framed-monodromy.tex:448`--`462`.

A hostile pair is
\[
 [\zeta_6]+[1],\qquad [\zeta_6]+[-1].
\]
These multisets are unequal in \(\operatorname{Sym}(\Pi_{\mathrm{fr}})\) but
have the same \(\nu_6\)-value.  Marker-level reconstruction invariance cannot
therefore prove the memo's (C930.2).

**Required repair.**  State the common compiler with a certified
\(A\)-valued blowup ledger, or localize the block monoid by the kernel
congruence of the selected marker.  The atomic provider may inhabit the ledger
through its stronger block isomorphism; the framed provider inhabits it
directly at marker level.

### 2. Major -- center localization must retain occurrences

The common composite at memo lines 79--91 uses an unindexed center quotient.
The framed proof must retain every actual occurrence label \((C,\chi)\), as in
`notes/2026-08-19-c925-conditional-m1-specialization.md:114`--`136` and
196--216.  Two noninjective specializations of the same center may give
distinct framed blocks; killing an intrinsic \(\mathcal B(C)\) need not kill
either specialized contribution.

**Required repair.**  Define the quotient by the actual certified center
occurrences \((C,\chi)\), not by unindexed center objects.

### 3. Major -- the atomic/framed fork is typed too broadly

C925 Diagram 22.9 displays an unrestricted
\(\mathsf{RankTwoExponentFrame}\), while its prose limits the common refinement
to the isolated cubic packet
(`notes/2026-08-19-c925-conditional-m1-specialization.md:254`--`278`).  A
general rank-two exponent frame need not identify squared exponent difference
with the modified-residue discriminant without the normalized
regular-singular comparison.

**Required repair.**  Type the top vertex as the normalized cubic rank-two
exponent frame and state the comparison lemma next to the diagram.

### 4. Major -- the 5.7R surface boundary is misstated once

Memo lines 273--276 first list Hirzebruch surfaces as direct and then say that
ruled surfaces use 5.7R.  The exact split is:

- Hirzebruch surfaces are direct; and
- only ruled surfaces over positive-genus curves use 5.7R.

This is C925 Module 22, lines 145--157, and the epilogue's framed section,
lines 1128--1144.

### 5. Major -- the chemical-formula instance needs the generalized compiler

Memo lines 312--325 call the chemical formula an exact instance of simplified
Theorem A.  The actual construction passes through probes, an atomizer, a
presented thin groupoid, and a dimension filtration
(`notes/2026-08-19-c925-audits-and-final-statement.md:507`--`553`).  Its exact
home is the probe-indexed subsumption theorem at lines 555--590.

**Required repair.**  State it as a sibling instance of the repaired
generalized compiler.  Do not suggest that the thin groupoid creates natural
morphisms or that the compiler supplies its carrier theorems.

### 6. Minor -- atomic center copies are not canonically intrinsic

Memo lines 67--69 say that unindexed center copies canonically identify with
the intrinsic block.  C925 proves equality of the retained class after
faithful scalar extension and formal reparametrization
(`notes/2026-08-19-c925-rank-two-and-adapters.md:269`--`328`).

Say instead that the copies determine the same class in the localized indexed
groupoid.

### 7. Minor -- the shortening target needs the repaired theorem

The deletion ledger removes the large unused branches, and the 23--29-page
section estimate is plausible.  The existing atomic and framed sections are
still 1,191 and 1,725 lines.  Reaching 1,600--2,000 lines requires actually
replacing their duplicate setup and transport with the repaired common
marker-ledger theorem, not compressing each proof independently.

## LaTeX diagram verdict

C925 contains usable LaTeX sources, but they should not be copied unchanged.
The paper needs exactly two categorical diagrams.

1. **Occurrence-indexed descent square.**  Combine the compiler pipeline,
   center quotient, and framed descent into one theory-parameterized square.
   Its relations are the certified actual occurrences \((C,\chi)\), and its
   rightmost arrow is the chosen marker-level ledger.  This replaces C925
   Diagram 7.2, Diagram 9.4, and (22.7), which would otherwise duplicate one
   another.
2. **Normalized cubic fork.**  Retain a corrected version of (22.9), with the
   top vertex restricted to the normalized cubic rank-two exponent frame and
   with the comparison lemma stated beside it.

Both can be written with `amscd`; no TikZ dependency is necessary.  The first
diagram is load-bearing.  The second explains how the same cubic calculation
feeds the atomic and framed markers.

## Positive findings

The unconditional route has no detected circularity.  Its direct-sum and
blowup adapters are stated in C925 Module 8, its weak-factorization
conservation in Module 9, and its complete center and endpoint contradiction
in Modules 11--13.  The current deletion plan also correctly removes the
large branches unused by either \(m=1\) proof.

## Recommendation

Do not begin manuscript prose yet.  First revise the memo so that:

1. Theorem A accepts marker-level certified ledgers;
2. the center congruence is occurrence-indexed;
3. the common descent square and normalized cubic fork are written in LaTeX;
4. the exact ruled-surface boundary is corrected; and
5. the chemical-formula instance is routed through the generalized compiler.

Then run a short second independent referee pass on those statements.  If that
passes, phase 2 can refound the manuscript around the repaired spine.
