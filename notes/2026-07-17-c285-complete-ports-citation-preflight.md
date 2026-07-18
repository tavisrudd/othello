# C285 complete-ports citation-chain and claim preflight

**Lane:** `complete-ports`

**Status:** COMPLETE — the six-part source, bibliography, proof ledger, novelty ledger, C216/C227/
C244 evidence reports, and optional C220 strengthening were audited. The theorem spine survives,
but the present source is **not submission-ready** until the required corrections below are made.
No manuscript source, public-export state, Lean source, repository identity, license, remote, or
C220 gate was changed by this audit.

## Verdict

The central claims have an adequate evidence route:

- exact pointed transfer and the cubic theorem chain have the stated kernel-checked owners;
- prescribed-port realization has a kernel-checked finite core and a valid manuscript-level
  random/AG route;
- the reliability, EXIT, pointed-Tutte, and harmonic finite tables match the C219/C226/C227/C244
  evidence boundary; and
- the all-field harmonic and Poisson claims have symbolic or dependency-graph arguments rather
  than being inferred from the q=9/q=27 certificates.

The preflight found no contradiction in the cited Chen--Ling--Xing, Singer, Las Vergnas,
Gmainer--Havlicek, Stichtenoth, EXIT, or Chen--Stein source roles. The Las Vergnas normalization is
literally the one-element set-pointed expansion in equation (3.1), and the cached 2005
Chen--Ling--Xing source contains the cited concatenated-dual decomposition. The citation chain is
nevertheless incomplete at several points, and three pieces of current mathematical prose are
wrong or vacuous.

## Required source and claim corrections

These are submission blockers. The locators name the current theorem, paragraph, or phrase so the
list remains usable after line numbers move.

1. **Repair the abstract's obstruction direction.** In the abstract, replace “Every fixed
   represented port above this obstruction” by “Every fixed represented port satisfying the
   pointed-obstruction bound” (or the explicit condition `r+1<z_x(I)`). “Above” reverses or at
   least obscures the inequality used by Theorem `thm:prescribed`.

2. **Delete the vacuous final sentence of Proposition “Basic invariants” and its proof sentence.**
   With the displayed definition, every witness already has
   `wt(w)=|supp(w)\setminus{x}|+1=|R|+1`. Moreover, `|R|<=r` and
   `r+1<d(C^\perp)` imply that no such nonzero witness exists. The current dual-distance sentence
   is therefore vacuous, and the asserted difference-of-witnesses argument does not prove a new
   edge-cardinality fact. Do not silently replace it by coefficient uniqueness unless that new
   statement is separately proved and entered in the ledger.

3. **Replace “projective tuples” in Definition “Coefficient layer” by normalized coefficient
   vectors.** The ratios `(-w_y/w_x)_{y\in R}` are invariant after normalizing the target
   coefficient and give an actual vector in `(F_q^\times)^R`, not a projective class: multiplying
   that vector changes the recovery equation with coefficient one on `c_x`. Remove the outer
   projective brackets or define them explicitly as ordinary tuple delimiters. Synchronize
   proof-ledger D1a.

4. **Restore the missing dual-distance half of the AG realization region.** After
   `gamma<R<1-gamma`, state both
   `delta(O_N)>=1-R-gamma` and `delta(O_N^\perp)>=R-gamma`, then derive the concatenated primal
   bound. The second inequality is what discharges Theorem `thm:prescribed`; it is present in C216
   but absent from the manuscript. Cite the generic evaluation/differential-code source here and
   reserve Stichtenoth 2006, Theorem 1.6(ii), for the concrete self-dual `F_6561` family.

5. **Give the random simultaneous GV step its one-line proof and source.** State that the expected
   numbers of nonzero codewords and dual codewords below the two relative-distance cutoffs have
   exponential rates `R+H_Q(delta)-1` and `H_Q(delta_perp)-R`; hence both vanish simultaneously.
   Add the appropriate coding-theory citation at this paragraph. The current two inequalities are
   correct, but merely calling them “classical GV” does not document the simultaneous primal/dual
   claim.

6. **Qualify the radius-four harmonic transfer sentence.** Replace “The coarse transfer gate is
   automatic” by “The inner-dual half of the coarse gate is automatic.” The outer functional-dual
   bound is still required; the positive-density realization supplies it eventually.

7. **State the q-ary EXIT normalization and source the area identity.** Immediately before
   `sum_x int h_x^MAP=K`, say that entropy is normalized in `log_q` units (equivalently, that the
   unrecoverable-symbol indicator equals normalized conditional entropy for a linear code on the
   q-ary erasure channel). Attach the exact area-theorem citation. Ashikhmin--Kramer--ten Brink is
   already relevant, but the present citation is attached to the bounded/full-MAP distinction,
   not visibly to the later q-ary area equation.

8. **Put the all-field Poisson rates in the public proof chain.** Add the explicit
   Arratia--Goldstein--Gordon dependency bound, or at minimum the block count and the one- and
   two-point intersection-pair orders that yield `O(n^{-1/4})`; do the analogous one-point overlap
   count for the derived `S(2,3,n-1)` and `O(n^{-1/3})` rate. C244 contains this argument, but the
   current manuscript jumps from the theorem name to the rates in one sentence while claiming an
   all-field proof.

9. **Disambiguate the two uses of `L_4`.** The EXIT section defines `L_r(x)` as a locality deficit;
   the final flagship paragraph reuses `L_4(S)` for harmonic circuit closure. Rename the latter,
   for example to `\operatorname{cl}_4(S)`, throughout the gate law and prose.

10. **Correct the verification trust wording.** Replace “The only quarantined asymptotic import
    is Stichtenoth's ... theorem” by “The only nonformalized axiom in the cited Lean theorem chain
    is ...”. The paper also uses nonformalized classical random-code, AG, EXIT, reliability, and
    probability inputs, so “only import” is too broad. Likewise, call the random/AG material
    “manuscript-level arguments” until the short arguments required above are actually present.

11. **Use LaTeX source notation in the verification section.** Replace Markdown backticks around
    `RepairCodes` and `RepairPorts.FunctionalCost` by `\texttt{...}`. This is a source/PDF defect,
    not a mathematical issue.

## Required citation-chain corrections

The existing bibliography metadata is internally consistent; the `Stichtenoth2005` key names a
2005 preprint whose journal record correctly says 2006 and need not be renamed. Make these
placement/pinpoint changes in the public source:

1. Pin the concatenated-dual attribution to Chen--Ling--Xing 2001, Theorem 2.3, and 2005,
   Theorem 2.1. The quantum-code titles are not an error: those theorems contain the ordinary
   concatenated-dual decomposition being used.
2. Pin the pointed-polynomial attribution to Las Vergnas 1999, equation (3.1), and say explicitly
   that the manuscript's displayed polynomial is its singleton specialization. This distinguishes
   the cited standard polynomial from the new radius filtration.
3. Keep Singer 1938 attached only to the regular projective action used in the strict finite
   example; the weighted-cost conclusion remains the paper's checked deduction.
4. Keep Gmainer--Havlicek attached only to the normal-rational-curve nucleus formula. Add a
   separate finite-geometry/design reference for the classical harmonic-quadruple terminology and
   Steiner-system context, even though the manuscript proves the completion property directly.
5. Attach Arratia--Goldstein--Gordon 1989 to the displayed dependency bound, not only to the final
   convergence sentence.
6. Add a standard reliability/Boolean-function source at the first deletion--contraction and
   pivotality theorem, or remove the blanket “reliability identities are classical” attribution.
   The manuscript's elementary proof establishes the identities, but an attribution should still
   identify what prior machinery is being acknowledged.
7. Add the generic AG evaluation/differential-code reference described above. Stichtenoth's
   self-dual TVZ theorem supports the concrete `F_6561` import, not by itself every generic
   square-alphabet sentence as currently placed.

Primary records checked during preflight include the official Numdam record/full text for Las
Vergnas, the official AMS record for Singer, the arXiv full text for Gmainer--Havlicek, and the
cached IEEE text for Chen--Ling--Xing 2005. Cache identities used for load-bearing full-text checks
were:

| Source | Cached SHA-256 | Bytes |
|---|---|---:|
| Chen--Ling--Xing 2005, DOI `10.1109/TIT.2005.851760` | `e566d78ab3a82d08ea4fc0441b98a85677dda41ee727a91b365c13b907733f0f` | 321662 |
| Las Vergnas 1999, DOI `10.5802/aif.1702` | `645aeb2c003aecefc4f7ccec9e771bb287a9bbf5d79182fda2e848b8b235d19d` | 3323624 |
| Gmainer--Havlicek, arXiv:1304.0088 | `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0` | 192925 |

The cache records fetched bytes, not priority. None-found positioning continues to rely on the
bounded search recorded in `adversarial_novelty_review.md`.

## Novelty and none-found wording

The current draft contains no categorical “first,” “new polynomial,” “optimal bandwidth,”
“capacity,” or harmonic-threshold claim. Preserve that. The permitted contribution wording is:

- **prior/classical:** locality and repair tolerance, all-dual-support adjacency, concatenated-dual
  fibers, Singer regularity, random GV and AG/TVZ regions, reliability/pivotality, EXIT area,
  normal-rational-curve nuclei, harmonic Steiner systems, Chen--Stein, and the Las Vergnas
  polynomial;
- **derived framework / bounded none-found:** the exact represented-port confinement criterion and
  positive-density consequence;
- **candidate none-found applications:** literal complete bounded repair-port transfer, the exact
  cubic coordinate rows, the completed cubic full-port rows, and the harmonic repair-port
  interpretation and filtered q=9 profiles.

If the introduction retains “Our contribution,” follow it with the bounded phrase “In the
literature reviewed, we did not locate ...” and the exact candidate list above. Do not turn the
search into a priority certificate. The weighted strict example is a natural finite separation,
not a new MDS construction or an asymptotic improvement.

## C220 inclusion recommendation — user gate remains open

**Recommendation: omit C220 from this submission.** This does not decide the gate.

C220 is correct, uniform, and useful: it gives the defect identity

```text
|X|+|Y| = q-1 + delta(S) + e
```

and classifies both minimum and one-above-minimum cubic blockers. In the present 11-page manuscript,
however, it does not shorten a proof or supply a displayed cubic reliability coefficient. Including
the full result would add a seventh conceptual payload, an inverse restricted-sumset proof, a new
additive-combinatorics citation chain, and another evidence bundle to a paper whose selected spine
is already six parts.

If the user elects inclusion, retain only one compact proposition: the defect identity, the two
minimum-blocker forms, and the count `q(q+1)/2`. Omit the complete defect-one enumeration and its
Gaussian-binomial count from the main paper. That narrow form would directly sharpen the cubic
high-survival reliability coefficient while keeping the additive theorem's classical/none-found
boundary explicit. The current omission remains the cleaner submission recommendation.

## Exact next gate

Apply the required correction list to the private source, synchronize `refs.bib`, `proof_ledger.md`,
`adversarial_novelty_review.md`, and `README.md`, rebuild the PDF without warnings, and recheck the
changed citation locations and first/final rendered pages. Public export remains blocked on the
user's repository destination/remote, license, and C220 decision, plus the separately owned shared
Lean export. This audit authorizes none of those actions.
