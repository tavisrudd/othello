# C1133 — independent editorial referee on the A/B integration plan

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Object reviewed:** `2026-09-10-c1133-ab-integration-plan.md`, frozen at
`dcaf82257`; the working file was checked equal to that version.
**Recommendation:** adopt architecture P after the concrete revisions below,
then reassess it against an assembled B section. This is approval of a
direction for revision, not acceptance of an assembled manuscript or
certification of the new theorems.

## Summary and contribution

The plan proposes to retain the unconditional theorem that every smooth
complex cubic threefold has irrational first stabilization, extend the
numerical argument to rationality after one stabilization for all seventeen
smooth complex Picard-rank-one Fano families (A), and add conservation of
rational third-cohomology Hodge structures for one-stably birational members
of the nine detected families (B). It places cancellation and arithmetic
finiteness consequences (C/D) after B.

This is a coherent mathematical progression. The cubic is an effective
entry point because it exposes the obstruction created by surface centers
and admits a small explicit rank-two calculation. A shows the reach and the
limits of that calculation: resonant rank-two cases require the canonical
lattice, while four other families require a rank-three selector using odd
cohomology. B then retains information that the numerical argument discards.
That progression gives the reader a reason to continue beyond the cubic,
without requiring B in order to understand the first theorem.

The strongest feature of the plan is its identification of faithful
transport of actual connections and their lattices as mathematical content.
It also correctly refuses to infer the fixed-base Hodge construction by
restricting an already injective map. These are appropriate organizing
principles, substantially better than presenting the enlarged result as a
longer table of quantum calculations.

## Significance and scope

The proposed conclusions address different questions. A is a uniform
rationality statement about a classified set of families. B is a structural
constraint on partners, including comparisons between allowed families, and
does not require the varieties to be very general. C is a narrower
cancellation consequence with an extra Torelli input. D is a finiteness
statement with arithmetic inputs. They should not receive equal prominence
or be merged into one theorem with a long list of qualifications.

The cubic theorem should remain first. Although it is logically a special
case of A, presenting it first is honest and useful provided that the text
explicitly says this and the subsequent cubic proof is genuinely complete.
A and B deserve exact statements in the introduction. C/D can be identified
in a short paragraph there, with their full statements at the point of use.
Neither the scope of C/D nor any conditional pencil result may qualify the
unconditional cubic theorem, A, or B.

I make no novelty verdict and no venue prediction. The existing introduction
already gives the relevant conceptual comparison with Hodge atoms and
earlier cubic work. The revised introduction must update that account for B:
the current sentence that the invariant “uses no Hodge structure” describes
the numerical branch only. The additional equivariant/isogeny precedents
should be credited proportionately, from the audited sources, without
turning the opening into a literature register.

## Correctness of the proposed hierarchy and dependencies

The main hierarchy is sound at the level inspected. The specialized P¹
argument supplies exactly the endpoint and ruled-surface results needed by
the core, so general projective-bundle reconstruction need not precede the
cubic theorem. Its removal from the core does not remove that dependency
from stronger retained statements. In particular, the current
`cor:threefold-marker` covers arbitrary smooth projective complex
threefolds, and its present proof invokes a general projective-bundle
formula. The new nine-family endpoint lemma does not by itself reprove that
corollary. It needs an explicit retained proof or a deliberate scope
disposition, rather than a changed citation beside the old statement.

There are three hierarchy points needing correction or clarification.

1. **A requires a second numerical mechanism.** Section 3 cannot establish
   vanishing of every selector used by A before Section 5 has introduced
   its rank-three odd selector. State the rank-two transport and vanishing
   results first. Section 5 should then introduce the additional selector,
   give its operation formula and the short additional center-vanishing
   argument, and only then apply the family table. This uses odd fiber
   dimensions but does not require B's Hodge-group transport. Calling all
   of Part I an even-fiber rank-two count would conceal this distinction.
2. **B is not obtained by merely decorating the numerical invariant.** Its
   parameters lie on the Hodge-fixed base while its fiber remains full
   cohomology. Full even primary ranks are tested before odd representations
   are extracted. Algebraic divisor directions must survive the fixed-base
   construction; an injection need not survive an arbitrary restriction.
   The plan states these boundaries correctly, but its body-proof allowance
   is too permissive: “proofs or explicit complete proof pointers” should
   not allow the whole new argument to disappear from Section 6.
3. **The arrows B→C/D omit independent premises.** Replace them by
   B + rational Torelli → C and B + arithmetic intermediate Jacobian,
   bounded-degree isogeny finiteness, polarization finiteness, and cubic
   Torelli → D, with the exact hypotheses on each imported result. These
   additions need not make the diagram large. They prevent a reader from
   mistaking either conclusion for formal cancellation in a representation
   group alone.

The actual-map note supports the intended distinction between a small
tensor calculation and continuation over all even bulk directions. Its
elliptic ruled-surface calculation also gives a concrete reason that the
exception must be retained: the centered nilpotent is identically zero,
so a persistence argument that assumes a nonzero cyclic nilpotent cannot
cover that case. I have not independently certified the cited comparison
theorems or all-member geometric inputs in this editorial review.

## Exposition and organization

The current introduction is effective at moving from surface-center
cohomology to a numerical obstruction, then to the canonical-residue
refinement. Preserve that causal sequence. The current large quantum
section mixes definitions, comparisons, cubic computation, surface
vanishing, and an abstract additive formulation. Splitting it by reader
outputs is justified, but the proposed new sections must not each repeat
the same explanation of weak factorization.

I recommend the following concrete refinement of P:

- **Introduction:** cubic, precise A, precise B; one mechanism paragraph
  and one reading map. State which cases require more than the cubic model.
- **Numerical construction:** whole primary factors, original lattice,
  rank-two modification and residue, then the exact operation interface.
- **Centers and fourfolds:** actual blowup comparison and faithful reduced
  parameters; curve/surface vanishing; fourfold invariance. Include the
  noncircular point-blowup reduction for ruled surfaces.
- **Cubic:** retain the displayed residue calculation and the exact full-bulk
  P¹ continuation lemma, ending with the contradiction. This is a complete
  first stopping point.
- **All seventeen families:** introduce the rank-three odd selector and
  its additional proof obligations, give the nine detected inputs and a
  compact account of the eight rational controls, and prove A. This is a
  second complete stopping point.
- **Hodge conservation:** a focused body section proving B, with calculations
  and completion bookkeeping in appendices. Avoid a new general theory
  unless a stated theorem actually needs it.
- **Consequences:** C, followed by D if its proof fits the allotted space;
  a short mathematical closing paragraph. Technical appendices follow.

The P¹ lemma is shared by endpoint computations, so state it once with its
actual scope. The cubic proof can use its cubic instance; Section 5 should
verify the other finite hypotheses rather than repeat the continuation
argument. Likewise, give a reusable reduced-ring faithfulness argument
whose hypotheses Section 6 explicitly checks on the fixed base. Reuse the
argument, not an unsupported identification of the two bases.

## Major comments: arguments that must remain readable

The body should contain exact statements and the central proof steps of
the following arguments. An appendix may carry their technical completion.

1. **Faithful transport.** Show the reduced source domain, explain the
   finite ample-degree slice, and display the finite relation between
   independent divisor exponentials that the Vandermonde argument rules
   out. State that the actual map intertwines the z-connection and that it
   and its inverse preserve the original lattice. These assertions connect
   a source theorem to the claimed invariant and are not bookkeeping.
2. **Canonical lattice versus formal exponents.** Explain how preservation
   of N and im(N) transports the elementary modification. Include one
   resonant example when A first needs it. A nonzero residue discriminant
   must not be described as equivalent to distinct exponent classes.
3. **Surface vanishing in the correct order.** Prove point/curve facts
   before the surface reduction and the fourfold theorem. Retain enough
   of the ruled calculation to explain the elliptic exception; the
   transformation giving centered operator κh is an economical candidate.
4. **Full-bulk endpoint continuation.** State the small-locus product
   identification with its original lattice, separation by the independent
   P¹ parameter, and continuation in mixed even directions. The small
   product locus is not claimed to be a faithful base for an arbitrary big
   quantum tensor formula. The general recurrence can be deferred.
5. **Completeness for A.** Keep visible both the nine detected cases and
   the eight all-member rationality inputs, as well as the classification
   that exhausts the seventeen families. Zero selector is not a rationality
   criterion. Matrix provenance and exceptional geometric models can be
   detailed in an appendix, but the table must show which assertion each
   source supplies and whether it covers every smooth member.
6. **The final proof of B.** Write the equality
   2[H³(X)] = 2[H³(Y)] and explain torsion-free semisimple cancellation,
   recovery of pure weight three from the Tate-periodized class, and
   rational descent. State why all odd endpoint cohomology lies in the
   selected whole repeated factor. Include the safe unlabelled sum;
   individual scalar-labelled factors need not descend. This should be a
   short proof the intended adjacent reader can follow without reconstructing
   a second paper from appendix references.

## Comparison of P, Q, R, S and a further alternative

| Choice | Assessment | Condition that would change the choice |
|---|---|---|
| **P** | Best present fit. It preserves the accessible result and gives A/B appropriate independent endpoints, with a substantial shared comparison argument. | Reverse if measured B development dominates the paper or forces repeated background and proofs. |
| **Q** | A serious option for a methodological paper. It could avoid apparent repetition if there is one genuinely economical master construction. | Prefer it only after a statement-and-proof outline demonstrates a shorter common construction with distinct bases explicit, while retaining the unconditional cubic statement at the start. Do not obtain unity by hiding the rank-three branch or B's extra premises. |
| **R** | The strongest fallback. A numerical paper can stand alone, and B can support a paper centered on Hodge conservation and its consequences. | Prefer it if B adds more than roughly 6–8 essential body pages or needs its own substantial setup. These are review triggers, not correctness limits. Each paper then needs an exact published or fully supplied shared interface, without circular cross-citation. |
| **S** | Least attractive with B as a principal result. Fixed-base faithfulness and Hodge recovery are conceptual work, not merely a longer calculation. | Reconsider only if an assembled section shows that B really follows from a short body proposition and the deferred content consists of technical proofs already explained there. That becomes a modest variant of P. |

A useful fifth option is **P with C in the body and D in a short application
appendix**, leaving B's complete conceptual proof in the body. This separates
the additional arithmetic language without separating the shared quantum
argument. It is preferable to hiding B solely to save the body pages spent
on D. A brief D statement in the consequences section can still make the
result discoverable.

## Practicality, page budgets, and retained material

The proposed body budgets add to **21–29 pages**, and the appendices add
**8–12**, for **29–41 pages before an explicit bibliography allowance**.
The introduction alone is budgeted at 3–4 pages. Thus P is a substantial
expansion, not a small insertion. The plan correctly calls these estimates,
but its final decision gate should measure the whole object, not only B.

Before drafting, allocate every current statement to retain, subsume,
appendix, or companion. In particular, the arbitrary-threefold criterion,
V14 application, zero-cycle examples, additive/motivic extension, spectral
refinement, and independent cubic calculation need explicit dispositions.
A may subsume an old application as a theorem but not replace its distinct
geometric explanation. Retaining every existing extension as well as all
new A–D material could defeat the proposed hierarchy.
Any retained warning about extending rank-two lattice constructions to
rank three must be distinguished from A's rank-three parity selector:
the latter does not purport to construct that stronger lattice theory.
Keep that distinction explicit in the migration inventory.

Measure three quantities after assembly: pages needed to reach the cubic
proof, pages added exclusively for B, and total length including references
and appendices. Also count genuine repetitions of comparison setup. Do not
force any number by deleting a proof. If the cubic cannot be reached at the
planned pace, first remove optional generality and repeated orientation;
if B dominates, use R. A final PDF review is needed before any page estimate
can become a claim about readability.

C belongs naturally as B's first application if its exact rational Torelli
statement is supplied. D belongs only if its several independent inputs
can be introduced and used economically. D should explicitly fix the source,
the finitely generated characteristic-zero field, and the degree bound,
and say that the objects counted are geometric cubic isomorphism classes.
Neither bounded-degree fields nor twists are themselves being counted.
C must distinguish a very general source from an arbitrary smooth target
in the same cubic or quartic-threefold family. These scopes should appear in
the theorem statements, not only in the integration plan's opening prose.

## Minor comments

- The nine-family set needs a definition before B. “Detected” is a method
  description, not an intrinsic membership criterion for a theorem statement.
  A concise family list or reference to a defined table suffices.
- Reserve different notation for numerical selectors and Hodge-valued
  classes. Distinguish full even rank from invariant-subspace dimension.
- Keep “generic” tied to quantum parameters, with the current one-time
  clarification that no general-member geometric restriction is imposed.
- Keep the cubic theorem's stable semantic label. Preserve other labels
  through moves unless a statement itself is replaced and its mappings are
  deliberately updated.
- Mention formal evidence once with its exact correspondence boundary.
  Written theorem strength and formal coverage need not coincide; moving a
  proof does not upgrade a formal claim.
- An abstract listing cubic, A, mechanism, and B is already full. Prefer
  omission of C/D there to another sentence cataloguing consequences.

## Reasoned recommendation and reversal gates

Proceed with P after repairing the rank-three proof ordering, the C/D
dependency arrows, the minimum body proof of B, and the treatment of retained
general statements. The plan is well directed but not yet a sufficiently
specified migration contract for manuscript edits. A resolved statement
inventory and a short completed B draft are the highest-value next tests.

Choose R if that draft exposes substantial independent theory or excessive
duplication. Choose Q only on positive evidence of a simpler shared proof,
not on the appeal of a broader opening theorem. Choose the P/C-body/D-appendix
variant if arithmetic exposition alone causes the overrun. S should not be
the default compromise. Final editorial acceptance requires reading the
assembled text and rendered pages; none is implied by this planning report.

## EJ + TT closeout and Mystery ledger

The extra-value pass identifies a cheap improvement: use one shared
faithfulness lemma with explicit hypotheses, then verify those hypotheses
separately on the numerical and Hodge-fixed bases. This reduces repetition
without claiming those bases have the same generic primary decomposition.
The reader-first test is whether someone can explain the obstruction from
surface centers, the resonant exception, and the new information in B after
reading only the introduction and the central proofs.

- **Settled editorially:** cubic-first order is compatible with A's logical
  generality; B should have a body proof; C/D have independent inputs.
- **Open measurement:** how much new exposition B needs. Gate: assembled
  B draft, duplication count, and whole-paper page accounting.
- **Open disposition:** which existing generality and applications survive.
  Gate: explicit statement inventory before manuscript migration.
- No new mathematical mystery is claimed; theorem certification and source
  completeness were outside this review.

## Read record and process boundary

Read completely: repository `AGENTS.md`, selected lane handoff,
`papers/style-guide.md`, the frozen integration plan, current
`sections/01-introduction.tex`, `2026-09-10-c1133-transport-input-reduction.md`,
and `2026-09-09-c1133-fixed-base-proof.md`. Read the main TeX file through
line 170, including all front matter and section inputs; inspected the
section/subsection and semantic-label structure of the four remaining
main-paper section files; read `sections/03-applications.tex` lines 1–120.
No full-paper or rendered-PDF read is claimed. The proof notes were used to
identify proof-placement obligations, not to inherit their acceptance claims.
No external sources, prior referee reports, or conversation-derived
integration outline were opened. The mandatory handoff contains summaries
of prior review and planning; these were not treated as endorsements.

The initial handoff command exceeded the repository's original-output cap
(19,042 tokens). That command-shaping failure was reported and the handoff
was then read in bounded chunks. No mathematical build, Lean operation,
manuscript edit, mirror edit, or external communication was performed.
This report is the sole owned output.
