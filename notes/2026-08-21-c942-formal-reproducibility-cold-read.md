# C942 formalization and reproducibility cold read

**Artifact reviewed:** commit `6412a6c926e040257f09a63eea48e87cdb311533`

**Role:** formalization/reproducibility referee. I read the frozen reviewer guide without consulting other C942 review reports.

## Verdict

**Revise before release (narrow, required corrections).** The guide's mathematical route and its main evidence boundary are unusually clear. In particular, it correctly says that `make check` does not build Lean or replay the axiom audit, and the claim registry candidly exposes the geometric and QDM inputs as hypotheses. The release-facing documentation nevertheless needs two factual boundary repairs: the linked Lean README does not document the “guarded formal replay” promised by the guide, and the verification README calls source-parsed declaration text “elaborated statements.” The guide should also state the primary paper's actual coverage distribution, because its compact sentence that Lean “checks the algebraic ledger, rank-two marker, and final deductions” is easy to read more broadly than the claim rows warrant.

**Confidence:** high (0.97). This judgment rests on the frozen sources, an actual `make check` replay in a detached worktree, inspection of the checker, the public interface, the central claim rows, the imported-source and evidence registries, and the expected-axiom inventory.

## Required findings

1. **The promised guarded replay is not documented at the link.** `REVIEWER_GUIDE.md` lines 80--82 say that a “separate guarded formal replay” is documented in `lean/README.md`; the root README likewise refers to “guarded commands.” The linked README instead gives the bare command `lake build CubicStabilizationM1` (around lines 687--693), followed by source-only and axiom-log checker commands. It gives neither a guarded build entry point nor a complete command that captures `AxiomAudit` stdout. Thus every repository-relative link resolves, but this particular link does not deliver the procedure its surrounding prose promises. Either document the actual guarded, copy-pasteable build-and-capture sequence for this package, or remove “guarded” and state exactly what the reader must arrange. The two READMEs and the guide should agree.

2. **State the formal coverage at its real strength in the guide itself.** Among the 15 labelled primary-paper statements, the registry records **0 complete, 1 absent, 5 fragmentary, and 9 conditional deductions**. In particular:
   - `lem:faithful-center-base-change` is absent;
   - `prop:generic-spectral-connection-splitting`, `prop:cubic-block-data`, and `prop:residue-discriminant-exponents` are fragments;
   - `thm:marker-ledger`, `prop:qdm-operation-ledgers`, `prop:atomic-lowdim`, and `thm:every-cubic` are conditional deductions.

   The headline terminal takes a `RankTwoResidueMarkerContext` and a `CubicResidueMarkerOneStepInput`; the corresponding claim row says that weak factorization, the Iritani and Iritani--Koto comparisons, construction of the cubic QDM, and geometric low-dimensional nullity remain supplied. No external mathematics is hidden as a Lean axiom—this is a good design—but it also means Lean does not formalize the headline theorem from the paper's cited geometric inputs. Replace or immediately qualify “checks the algebraic ledger, rank-two marker, and final deductions” with a one-sentence quantitative summary such as: “For the primary paper, Lean supplies five strict fragments and nine conditional deductions; no primary-paper claim is complete, and the faithful center base-change lemma is absent.” Keep the existing explanation that external premises occur in theorem types.

3. **Correct what the source-only correspondence check is said to hash.** `verification/README.md` says that a claim digest covers “the elaborated statements of the terminals.” Inspection of `lean/verification/check_formal_artifact.py` shows that `terminal_signatures` reads raw reviewer-interface source, collects text from a `theorem` or `def` keyword through the first `:=`, normalizes whitespace, and hashes that text. The source-only mode does not invoke Lean. Consequently it detects source-signature drift, terminal census drift, claim annotation drift, and expected-axiom-row drift, but it does not establish that any declaration parses, elaborates, typechecks, or has the recorded kernel dependencies. Call these **source declaration signatures**, not elaborated statements. Preserve the guide's accurate sentence that `make check` does not build Lean or replay the audit.

## Reproducibility observations

- A clean detached checkout of the frozen commit passed `make check` in 11.7 seconds. The source-only checker reported: `sources=186`, `terminals=317`, `manuscript_claims=57`, `machinery=83`, with coverage `5 absent / 1 complete / 27 conditional / 24 fragment`. The command log contained the TeX lint, `check_formal_artifact.py --source-only`, and `latexmk`; it contained no Lean build or axiom-audit invocation.
- The detached checkout had no `lean/.lake` or paper-level `.lake` directory when `make check` succeeded. This independently confirms that the advertised check is not relying on a local Lean build in that checkout.
- The rebuilt PDF was byte-identical to the committed PDF: SHA-256 `246d254f7275111ba33b5b73ad344d31a89b749b28e37d76b306b919349b708a`.
- The 317 expected-axiom rows contain only standard logical/classical dependencies: 288 list `propext, Classical.choice, Quot.sound`; 22 list `propext, Quot.sound`; four list `propext`; two list `none`; one lists `Quot.sound`. The checked central terminals use `propext, Classical.choice, Quot.sound`. No project-specific axiom or `sorry` appears in the expected inventory. This is a property of the pinned expectation file until the captured kernel audit is replayed.
- The headline theorem has no computational evidence dependency. `evidence.json` has three bundles, but the verification README says exactly one statement uses one as a premise, in the conditional framed companion; the other registered computations concern companion-coordinate or discovery evidence.
- The six imported inputs named by the guide all have entries with pinpoints and convention matching: AKMW Theorem 0.3.1, Beauville's main theorem and equations (2.1)--(2.3), Iritani Theorem 5.18 and specified parts, Iritani--Koto Theorem 5.1 and specified parts, van der Put--Singer Chapter 3, and Beauville's surface classification Chapter VI. This audit checked registry presence and internal specificity, not the truth of the imported theorems against the external publications.

## Link audit

All 21 distinct repository-relative targets linked from `REVIEWER_GUIDE.md` and the root `README.md` exist at the frozen commit, including the three section files, the public `PaperInterface/Main.lean`, both verification registries, the expected-axiom file, both READMEs, the PDF, both companion directories, the top-level source/directories, `.zenodo.json`, and `LICENSE`. The ten semantic labels named in the guide also occur in the three linked primary-paper section files. The DOI link returned HTTP 200 and resolved to Zenodo record `22052604`.

Existence is not semantic adequacy: the Lean README mismatch in required finding 1 is therefore still a failed reproducibility link in substance.

## Optional findings

1. Repair the Markdown math in the six-step synopsis. The source currently has `(z)`, `(mathbb Z)`, `(-1/6)`, `(2/3)`, `(X\times\mathbb P^1)`, and `(mathbb P^4)` rather than consistently delimited inline mathematics. Use `$z$`, `$\mathbb Z$`, `$-1/6$`, `$2/3$`, `$X\times\mathbb P^1$`, and `$\mathbb P^4$` (or the repository's chosen Markdown math convention).
2. Make the suggested route easier to execute. “Through the discussion following `thm:every-cubic`” sends a referee into raw TeX with only an internal label. A section/subsection title or a stable source-line link would remove the first navigational stumble.
3. Add a compact three-column boundary table: manuscript step; Lean status; external premise still supplied. The six-step proof spine already supplies the right rows, and the table would prevent the broad summary sentence from carrying more weight than intended.
4. Consider changing “expected kernel-reported dependencies are pinned” to “the expected dependency transcript is pinned.” The existing wording is defensible, but the revised form makes clearer that only `formal-audit` against freshly captured output turns expectations into observed evidence.

## Strongest passage

The strongest passage is lines 37--43, especially: “The fold marks distinct exponent classes; a merely nonzero residue discriminant would also mark resonant blocks and is not enough.” It tells the referee both what the invariant measures and why the tempting weaker invariant fails. That is exactly the kind of compact mathematical audit guidance a reviewer guide should provide.

## First point of friction

The first point of friction is the instruction at lines 12--15 to read a raw TeX file “through the discussion following `thm:every-cubic`.” The semantic label is stable and does resolve in the source, but the guide makes the reader search for it before the promised short route has begun. A subsection name or anchored source location would preserve stability while making the route immediate.

## Bottom line on overstatement

The guide **does not overstate what `make check` proves**: lines 78--80 accurately exclude Lean building and axiom replay, and the replay behaved exactly that way. The verification README does overdescribe one implementation detail by calling raw source signatures “elaborated.” The guide's **formal-coverage summary is directionally honest but too compressed**: its caveat about hypotheses is correct, yet the absence of any complete primary-paper claim and the complete absence of the faithful center base-change lemma deserve explicit disclosure in the guide rather than requiring a referee to reconstruct them from `claims.json`.
