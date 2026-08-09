# Paper II non-C894 human-proof repair plan

**Date:** 2026-08-09  
**Scope:** Paper II human proof only  
**Status:** proposed repair plan; no theorem surface is refrozen by this note

## Decision

Retain the existing modular proof spine and repair it at referee depth.  Do
not use C894, the saturated-exterior theorem, the postclassification Paley
carrier, Lean, or finite certificates as a substitute for any human step.

The earlier C747/C749 closure must be reopened at three interfaces:

1. the detector-specific finite-group Hom statements that the false
   universal Lucas-socle calculation was meant to supply;
2. the opposite-outer-parity vanishing, especially the Steinberg source; and
3. descent for arbitrary `p'` matching stabilizers through subfield groups.

The endpoint-lift intrinsicity omission and the density of the current
presentation are secondary repairs.  The quotient, trade pullback,
contraction formula, small endpoint block systems, cubic, fixed-line, and
Gorenstein arguments remain provisionally accepted.

## Dependency spine

| Gate | Mathematical output | Consumed by | Stop condition |
|---|---|---|---|
| R0 | Frozen notation and exact preclassification hypotheses | all work | any later argument imports sheet size, one-factorization, or survivor data |
| R1 | Detector-specific linear Hom occurrence, absence, and outer normalization | R2 and detector selection | any stated detector channel differs from the exact Hom calculation |
| R2 | Opposite-parity Hom vanishing for every detecting module | uniform sheet exclusion | Steinberg or another detecting Hom space is nonzero |
| R3 | Complete `p'`-subgroup descent | detector coverage | an untreated `PGL_2(q_0)` or exceptional extension branch |
| R4 | Integrated modular exclusion | classification theorem | any branch uses an output of the classification |
| R5 | Independent human cold reads | release freeze | any reader cannot reconstruct R1--R3 from the paper and cited sources |

R1 must precede the final form of R2: the parity argument must know the exact
detector maps, not only possible composition factors.  The universal socle
formula is abandoned: at `q=9`, the catalecticant minors give an additional
`L(2,0)=L(q-7)` copy omitted by that formula.  R3 may be researched
concurrently, but its detector table cannot be frozen until R1 and R2
identify which simple modules genuinely work.

## R0 — freeze the proof interface

Before changing prose, write a one-page theorem-interface sheet containing
only facts available before the all-field exclusion:

- `G=PGL_2(q)`, `H=PSL_2(q)`, and the two `H`-sheets;
- the matching stabilizer `K<=H` is a `p'` group;
- the projective-trade pullback dichotomy and point-vector cocycle;
- `F=Sym^d L(2) \simeq Sym^2 \nabla(d)` over the algebraic closure;
- the two outer extensions of a simple `H`-module.

Explicitly forbid use of sheet size `q`, one-factorizations, regular
translations, Paley incidence, the fields `7,11`, or the final stabilizers.
This interface is the circularity audit for every later lemma.

## R1 — prove only the detector-specific linear Hom facts

Delete the universal finite-group socle classification.  Its smallest
two-digit case is false: for `q=9`, the three catalecticant minors embed
`L(2,0)` in `Sym^2(Sym^3 V)` in addition to the listed `L(0,2)` copy.

Replace it by three propositions, exactly matching later uses:

1. `Hom_H(St,F)=0` in the extension-field exceptional branch;
2. the occurrence, multiplicity, and determinant-normalized outer parity of
   `L(q-7)` in `F` in the torus-normalizer branch, including the
   characteristic-three endpoint whose `q=9` map is the catalecticant map;
3. the multiplicity-one prime-field Fischer summands and their explicit
   retractions.

The complete coefficient system remains available as a diagnostic in
`notes/2026-08-09-c895-finite-hom-matrix-specification.md`, but the paper no
longer needs to factor it for every simple module.  Each of the three targeted
statements may use a shorter rational, tilting, root-equation, or explicit
covariant proof suited to that channel.

**R1 acceptance gate:** a modular-representation reader verifies the exact
Hom dimension and outer normalization of every detector actually used by the
uniform exclusion.  No universal socle claim remains.

## R2 — prove the outer-parity obstruction

Split this work into three lemmas: root-defect injection, detecting-source
vanishing, and affine-class contraction.

### R2.1 Root-defect injection

Retain the construction

\[
 \operatorname{Hom}_{PGL_2(q)}(S^\square,M)
 \hookrightarrow
 \operatorname{Hom}_{\mathbf G}(S\otimes L(1)\otimes L(1)^{(e)},M),
 \qquad M=\operatorname{Sym}^2F,
\]

where `\mathbf G=SL_2(k)` is the algebraic group,
but promote the Chevalley-factorization step to a proved lemma.  Give the
degree bounds after denominators are cleared and show the coefficient
comparison that eliminates every omitted divided power.  The existing four
weight vectors and root-action table should be the conclusion, not the
justification.

Record, for each detecting `S`, its digit tuple, determinant-normalized
extension, opposite extension, and the parity of any linear occurrence in
`F`.

### R2.2 Steinberg source: first hard gate

Do this before manuscript integration.  Compute

\[
 \operatorname{Hom}_{\mathbf G}
 (\operatorname{St}\otimes L(1)\otimes L(1)^{(e)},M)
\]

rather than arguing only from a high simple head.  Preferred order of
attack:

1. determine the complete relevant Weyl/tilting filtration and apply a
   cited Hom or reciprocity theorem;
2. if that does not give immediate vanishing, give a direct generator and
   divided-power calculation analogous to the `L(q-7)` calculation; and
3. use bounded exact calculations only to discover the correct general
   relations and to test endpoints.

The proof must show why every homomorphism is detected on the chosen
generator or enumerate all lower subquotients that could map to `M`.

**Hard stop:** if this Hom space is nonzero, do not repair the prose around
the present detector.  Replace the Steinberg detector or redesign the
extension-field branch, then return to R1 and the detector table.

### R2.3 Other detecting modules

Re-audit the prime-field modules and `L(q-7)` with the same standard:

- cite the exact tilting-socle facts used for the prime-field branch;
- state why the candidate list is exhaustive;
- retain the explicit primitive-vector relations for `L(q-7)` in
  characteristics at least `7`; and
- isolate the characteristic-three `T(3)` calculation, including why its
  two displayed generators generate the complete source.

### R2.4 Contraction

Move the accepted evaluation--coevaluation calculation into its own lemma.
State the required `H`-retraction and explain where it is available for each
prime-field detector.  Keep the cocycle computation

\[
 C_{\rho,i}(z_i)=(\dim S)c+i\rho(c)
\]

explicit.  This prevents the accepted contraction from being obscured by
the unresolved parity calculation.

**R2 acceptance gate:** every vanishing is a full Hom-space statement, the
outer-extension normalization is explicit, and no argument relies only on a
simple head or a list of composition factors.

## R3 — use the tame subgroup theorem directly

Once the matching stabilizer `K` is proved to be `p'`, regard it as a finite
subgroup of `PGL_2` over the algebraic closure.  Faber's Theorem C gives the
complete tame list immediately:

\[
 K\text{ is cyclic, dihedral, }A_4,S_4,\text{ or }A_5.
\]

There is no subfield branch to descend through: subfield groups themselves
have order divisible by `p`, while every `p'` subgroup inside one is already
covered by the tame theorem.  Retain the current action-specific cyclic,
dihedral, exceptional, and transitivity arguments.  Use Giudici only later,
after sheet size is known and the exact large stabilizer order makes a
maximal-overgroup argument appropriate.

**R3 acceptance gate:** a group theorist confirms that the later detector
arguments need only the algebraic-closure conjugacy type supplied by Faber,
not an unproved rational-conjugacy refinement.

## R4 — integrate without burying the theorem

Only after R1--R3 pass their gates:

1. split the current Lemma 3.2 into detector-Hom, outer-parity,
   detecting-source, and contraction lemmas;
2. state only the precise modular propositions, their hypotheses, and their
   consequences in the main body; put the complete divided-power
   verification, Steinberg-source filtration, digitwise `L(q-7)` embedding,
   and prime-field contraction details in a self-contained technical
   appendix; the falsified universal coefficient matrix does not enter;
3. cite Faber's tame subgroup theorem before uniform sheet exclusion and use
   Giudici only in the later exact-order maximal-overgroup step;
4. keep the classification proof's causal paragraph to: trade gives sheets,
   R1--R2 forbid oversized sheets, R3 exhausts stabilizers, and endpoint
   block systems identify the survivors; and
5. update all cross-references and the proof/evidence map, while continuing
   to say that formal and finite checks do not prove R1--R3.

Add the independent minor repair in Section 2: rescaling endpoint lifts by
`lambda_a` multiplies every matching product and quotient difference by the
common scalar `prod_a lambda_a`; hence the configuration changes by a common
homothety, the trade data are unchanged, and the cubic line scales
accordingly.

### Page budget

Keep the classification narrative concise even though the complete human
proof grows.

- **Main body:** at most two net new pages; aim for no net growth by replacing
  the current dense proof sketch with short proposition statements and a
  clean causal proof.
- **Technical appendix:** approximately three to six pages containing all
  load-bearing calculations.  It remains part of the paper, not a separate
  companion or optional supplement.
- **Overall target:** about 46--49 pages from the current 43-page build.
  Treat 50 pages as a review threshold: if the proof exceeds it, run a
  compression pass before integration rather than allowing incremental
  expansion.

Do not shorten by hiding a human implication behind Lean, a certificate, or
an unpublished memo.  Concision comes from separating the causal theorem
spine from its checkable technical proofs and deleting duplicated setup.

### Layered exposition

Apply `papers/style-guide.md` as a two-track architecture rather than treating
the appendix as a storage area.

1. **Problem and mechanism.** Before the modular exclusion, give a short
   ordinary-language roadmap: an oversized sheet supplies a genuine simple
   constituent; the two outer extensions are forced into the moment module;
   one extension is absent; subgroup descent supplies a detector in every
   branch.
2. **Exact first-pass proof.** In the body, state the finite-Hom, parity,
   contraction, and subgroup propositions with complete hypotheses.  Prove
   the classification from their outputs.  An adjacent expert should be able
   to follow this route without reading the coefficient calculation, but no
   hypothesis, completeness claim, exceptional case, or change of language
   may be hidden by the skip.
3. **Specialist proof layer.** Open the technical appendix with one sentence
   naming the outputs a first-pass reader should retain.  Put the two-digit
   model case before the general Lucas matrix, then give the full carry,
   divided-power, Steinberg, and subfield-descent proofs.
4. **Verification boundary.** Keep formal and finite corroboration in the
   verification section.  Do not interleave artifact names, hashes, or replay
   details with either mathematical proof track.

Use one roadmap and one model example.  Delete repeated strategy summaries
from the introduction, section opening, appendix opening, and conclusion so
the added layer replaces orientation prose rather than accumulating it.

## R5 — human verification sequence

Use fresh, context-limited review subagents; do not load this material into
general Paper/Lean routing.

1. **Finite-Hom read:** manuscript R1 plus only the McDowell--Wildon,
   Steinberg, and any newly cited modular sources.  Ask the reader to build
   the coefficient matrix independently and search for extra kernels.
2. **Outer-parity read:** R2 plus the exact tilting/distribution-algebra
   sources.  Ask specifically for a nonzero map from a lower Steinberg
   subquotient and for a missed divided power.
3. **Subgroup read:** R3 plus Dickson/Giudici sources.  Start the reader in a
   square-subfield `PGL_2(q_0)` branch and ask it to escape the case split.
4. **Final cold referee read:** complete paper, no earlier reports, with the
   public repository available only as trust material and Lean explicitly
   described as incomplete and non-substitutive.

The repair freezes only when all three specialist reads close their assigned
interface and the final reader returns no major objection.  Only then should
the statement identity, trust ledger, PDF, standalone export, and release
checks be regenerated.

## Risk ledger

| Risk | Level | Response |
|---|---|---|
| Steinberg-source Hom vanishing is false or needs a different detector | red | resolve before prose integration; redesign the extension-field branch if necessary |
| Lucas factorization has an extra alias/carry kernel | red | recompute detector coverage and theorem consequences before continuing |
| `PGL_2(q_0)` descent requires extra subgroup types | amber | strengthen the stated corollary and detector table |
| proof is correct but too long for the main narrative | amber | move the checkable matrix calculation to an appendix, retain a precise proposition in the spine |
| endpoint-lift intrinsicity | green | one paragraph |

## Immediate next action

Begin with the Steinberg-source Hom calculation and the explicit R1 matrix
specification as two mathematical memos.  They are the fastest falsification
tests for the retained architecture.  Do not edit the theorem statement or
declare the human surface repaired until both memos pass an adversarial
modular-representation read.
