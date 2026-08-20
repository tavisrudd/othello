# C931 editor synthesis of the C928 referee batch

**Date:** 2026-08-20

**Decision:** **B — minor revision.**  Every mathematical gate survives.  The
paper is publishable at the default *Proceedings of the AMS* standard after a
small attribution-and-exposition repair.  The present scope does not clear the
*Algebraic Geometry* stretch standard.

This synthesis adjudicates evidence rather than counting verdicts.  It uses
only the sealed dossier, the frozen eight-page PDF, and the six frozen reports
listed below.  No C908/C928 internal material, source TeX, audit, certificate,
handoff, or model conversation was consulted.

## Frozen inputs and hashes/commits

The listed inputs were clean in the working tree at synthesis time.  “Commit”
for a report is the commit containing the frozen bytes; the manuscript
authority is the closure commit fixed by the dossier.

| Input | SHA-256 | Commit |
|---|---|---|
| `papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf` | `3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5` | authority `ac04f826c179b53a599d95b4bac7534ba6a900a1` |
| sealed dossier | `c7ec24f7408dabedc784deb07c161e1e5858be91a7548ad3fa372ce5eb2b2056` | `5de936e852ff748d72bbd5e98fe065eddd9062db` |
| report G | `1542f8f1889ed63f8c0b4db1cb4eca3a478998410713e3b4f8d1009ff43a45af` | `549c8ae8b13193e26416b7a086f65fccc33af545` |
| report T | `e2e70edf328f90b84a919f55a7add484a4bd685899a6d7106fc6c83b363298d0` | `549c8ae8b13193e26416b7a086f65fccc33af545` |
| report A | `a62c7bd25c03bec72985e80b63095d026fc8142acb4a227c6911e38c4bebe8b1` | `549c8ae8b13193e26416b7a086f65fccc33af545` |
| report L | `9c9f590a7517bfd88228cc59b0760f3199c574e4bba214f8d6db89be0d8457a1` | `2a09554b4999ef238c60527114ad36e5f8720b15` |
| report P | `a44e4546cfb17c4839b812a27018c8b414d926fe8e303c2abe76efb096f442ed` | `2a09554b4999ef238c60527114ad36e5f8720b15` |
| report E | `061c2222dc638ae3e3394fb7090686afa771afe9de2412cf3b6918aea576bac4` | `a5f22cd61eb50f25bb2e9f891ba4eae68483d4b3` |

The manuscript hash was independently recomputed and matches the sealed
value.  The dossier records an extent of eight A4 pages and `make check`
passing at the authority commit.

## Report verdict table

| Report | Surface | Frozen verdict | Editorial use |
|---|---|---:|---|
| G | cubic theta divisor and Fano geometry | A | Accepts the classical model, multiplicity-one restriction, integral clean pull-push, and ten endpoint lifts. |
| T | link topology and integral intersection cohomology | A | Discharges every integral coefficient and perversity issue; turns E's verification debt into an exposition repair only. |
| A | abelian endpoint and cylinder/Pontryagin normalization | A | Accepts unimodularity, divided-power coefficient, global sign, and canonical mod-two coset. |
| L | integral symplectic Lefschetz lattice | B | Accepts all algebra, but requires exact credit that the Smith data specialize immediately from FVME. |
| P | priority and decomposition boundary | B | Confirms the geometric mod-two glue survives reviewed prior art; requires the same FVME correction and careful rational wording. |
| E | whole-paper editorial ceiling | B | Finds a coherent publishable package; requires precise FVME positioning and a clearer integral-IH endpoint. |

The three A reports cover the load-bearing geometric, topological, and
endpoint interfaces.  The three B reports do not identify a false theorem or
a changed proof mechanism: their common concern is credit and auditability.

## Adopted findings with exact evidence and severity

Severity here follows the dossier scale.  “A/verified” records a load-bearing
positive finding; “B/required” is a local manuscript condition.

| # | Adopted finding | Exact manuscript evidence | Reproducible support | Severity |
|---:|---|---|---|---|
| 1 | The link, pair, and Mayer--Vietoris calculation is integral and gives the kernel in (1). | Lemma 2.1 and Proposition 2.2, printed pp. 3--4, equations (5)--(6). | Report T recomputes the circle-bundle Gysin fragments: \(h\mapsto3\ell\) gives \(H^4(K)=\mathbf Z^{10}\oplus\mathbf Z/3\), while \(p^*:H^3(X)\to H^3(K)\) is an isomorphism.  It then identifies \(e^*=(p^*)^{-1}r_U\) in Mayer--Vietoris. | A/verified |
| 2 | Singular weak Lefschetz is valid over \(\mathbf Z\) in the needed range. | Printed p. 3, equation (5). | Report T applies the relative-homotopy theorem to the support of the hyperplane cut defined by a very ample power: \((J,\Theta)\) is 4-connected, so \(H^3(J,\mathbf Z)\simeq H^3(\Theta,\mathbf Z)\). | A/verified |
| 3 | The isolated-singularity Deligne truncation gives the claimed integral degree-three group; no \(\mathbf Z/3\) contaminates it. | Section 6, printed p. 7, equation (17). | Report T fixes the unshifted convention \(\mathcal P_{\bar m}=\tau_{\le3}Rj_*\mathbf Z_U\), equivalently \(IC_\Theta(\mathbf Z)=\mathcal P_{\bar m}[4]\).  Since the link's \(\mathbf Z/3\) lies in degree 4, the truncation gives \(IH^3(\Theta,\mathbf Z)=H^3(U,\mathbf Z)\). | A/verified mathematically; B/required exposition |
| 4 | The Fano blow-up geometry and clean exceptional restriction work integrally with multiplicity one. | Lemma 4.1, printed p. 5, equation (12). | Report G derives \(q^*X=P\) as Cartier divisors: \(q^{-1}(X)=P\) set-theoretically and restriction to a fibre gives \(-1=-m\).  The normal bundles and integral Thom orientations then give \(q^*e_*=j_*p^*\).  Report A independently checks the same degrees and multiplicity. | A/verified |
| 5 | The cylinder/Albanese coordinate is unimodular and the Pontryagin endpoint has unit divided-power coefficient with only one global sign. | Printed pp. 5--6, (11), Lemma 4.2 and (13). | Reports G and A trace the integral cylinder map to Clemens--Griffiths §2 and Theorem 11.19, then use perfect free-lattice pairings for its adjoint.  Report A expands \(\theta^{[3]}\) in a symplectic basis and finds coefficient one in every surviving term; swapping Fano factors changes only the global sign. | A/verified |
| 6 | Proposition 4.3 supplies exactly ten integral endpoint lifts and does not assume surjectivity of the full degree-six transfer. | Proposition 4.3, printed p. 6, equation (14), and the following proof of Theorem 1.1. | Reports G and A choose one \(\beta\) for each \(\gamma\) using the unimodular adjoint, apply (12), and compute the pushforward with (13).  A basis of \(H^3(X,\mathbf Z)\) yields the ten required directions. | A/verified |
| 7 | The complete-graph proof of Theorem 3.1 is correct, including the edge case \(n=3\), completeness of the saturation quotient, and \(1^{110},2^{10}\). | Theorem 3.1, printed pp. 4--5, equations (7)--(10). | Report L partitions the integral monomial bases into occupancy blocks, exhibits a unit \((n-1)\)-minor and determinant-two \(n\)-minor for \(U_n\), and uses the all-edge vector in each of exactly \(2g\) blocks. | A/verified mathematics |
| 8 | The manuscript understates how directly FVME supplies the abstract Smith factors and saturation defect. | Introduction, printed p. 3, “nearest general algebraic framework”; paragraph after Theorem 3.1, printed p. 5. | Reports L and P identify FVME Theorem 2.9, Corollary 2.10, and Proposition 2.14: after transposing wedge to contraction, the \(P^3\) layer has factor 1 and rank 110, and the \(P^1=\Lambda\) layer has factor 2 and rank 10.  E independently finds the same credit boundary. | B/required priority repair |
| 9 | The surviving contribution is the geometric realization and simultaneous fibre-product glue, not the abstract Smith multiplicities alone. | Theorem 1.1(2)--(3), printed p. 2; Proposition 4.3 and the final paragraph of Section 4, printed p. 6. | FVME has no Fano or cylinder coordinate; Krämer's rational decomposition kills the mod-two quotient.  P finds no reviewed source containing (3), (14), or the doubled escape lattice.  This is a bounded-source conclusion, not a global firstness claim. | A/verified priority boundary |
| 10 | Theorem 1.2 is the correct integral dual of the fibre-product kernel, but the transition to (16) is too terse. | Section 5, printed p. 7, equations (15)--(16). | The PDF identifies \(\ker b_*\) in the fibre product with \(2H^3(X,\mathbf Z)\); unimodular duality then makes the exceptional image \(2E_M\).  E notes that one short exact-dual sequence would expose this already valid implication. | A/verified mathematics; B/required exposition |
| 11 | Krämer's result is rational/complex and does not determine the integral glue; the displayed splitting should be labelled noncanonical. | Section 6, printed pp. 7--8, equation (18). | Report P checks Krämer Corollary 6 and the shifts (2,0,-2), yielding corrections in ordinary degrees 2, 4, and 6 only.  Tensoring (3) with \(\mathbf Q\) erases its parity coset.  Decomposition-theorem splitting does not canonically choose the integral-compatible maps. | A/verified boundary; B/required wording |

No adopted finding has severity C or D.  In particular, E's medium-confidence
verification debt at (17) is not a surviving mathematical debt: T supplies
the exact coefficient, perversity, shift, and truncation calculation.  The
need to print that information remains.

## Rejected/non-adopted suggestions with reasons

| Suggestion | Decision | Reason |
|---|---|---|
| Treat the sequence (1) as arithmetically nonsplit. | Rejected. | The PDF explicitly says it splits abstractly; the invariant is the simultaneous \((b_*,e^*)\)-placement (3). |
| Demand surjectivity of the full degree-six Fano transfer. | Rejected. | Proposition 4.3 needs and constructs only ten labelled endpoint lifts; G verifies that no stronger surjectivity is used. |
| Downgrade Corollary 1.3 because E lacked a theorem-level integral-IH source. | Rejected. | T independently supplies the Deligne-sheaf convention and direct truncation proof over \(\mathbf Z\).  This resolves correctness and leaves only a citation/exposition repair. |
| Claim independent novelty for the Smith factors or abstract quotient \(\Lambda/2\Lambda\). | Rejected. | L and P show they are immediate from FVME's integral filtration and compatible splittings. |
| Add Bayer et al., Zhang, and Artebani--Kloosterman--Pacini as conditions of acceptance. | Not adopted as a condition. | P finds these useful geometric context but no pre-emption of the integral fibre product.  They are optional unless the introduction expands its historical claims. |
| Expand Lemma 4.1 with the full Cartier fibre calculation and replace broad classical citations by proposition-level references. | Not required. | G verifies the printed proof as sufficient.  The extra sentence (q|_P=p) and sharper Beauville/CG pointers would improve auditability but do not repair a gap. |
| Print the full two-factor sign calculation or an explicit wedge-dual convention in Lemma 4.2. | Not required. | A verifies that factor exchange produces one uniform sign and that the mod-two coset is sign-independent.  A short sign-independence sentence is optional polish. |
| Add a broad new theorem or another geometric family merely to reach the stretch venue. | Rejected as a repair. | That would change the paper's scope rather than repair this manuscript.  It is a future-project route, not a publication condition at the default venue. |
| Make an integral decomposition-theorem claim outside degree three. | Rejected. | The \(h\mapsto3\ell\) link map creates a genuine \(\mathbf Z/3\) obstruction.  The PDF correctly limits its integral conclusion. |

## Theorem-by-theorem survival table

| Statement | Correctness | Priority/status after synthesis | Required action |
|---|---|---|---|
| Lemma 2.1 | Survives integrally. | Link computation is standard input, including the \(\mathbf Z/3\). | Optional “noncanonically” for the abstract split \(H^4(K)\). |
| Proposition 2.2 | Survives integrally. | Topological exact-sequence mechanism is sound; geometric surjectivity is correctly postponed. | None. |
| Theorem 3.1 | Survives in full. | Direct complete-graph proof and divided-power representatives are useful; abstract Smith data and saturation quotient are immediate FVME consequences. | Rewrite credit and add exact FVME pointers. |
| Lemma 4.1 | Survives integrally. | Clean exceptional restriction is a manuscript deduction from classical geometry. | None required. |
| Lemma 4.2 | Survives integrally. | Formal endpoint calculation from the classical minimal class; unit coefficient verified. | None required. |
| Proposition 4.3 | Survives in full. | The ten cylinder-labelled endpoint lifts are surviving geometric content in the reviewed literature boundary. | None required. |
| Theorem 1.1 | Survives in full. | Main publishable result is the canonical simultaneous mod-two fibre product (3), not abstract splitting or bare Smith data. | FVME attribution repair; keep headline on geometric glue. |
| Theorem 1.2 | Survives in full. | Correct dual corollary of (3); not found in reviewed sources. | Expose the short dual exact-sequence step before (16). |
| Corollary 1.3 | Survives integrally. | Rational degree-three equality is prior through Krämer; integral identification and inherited lattice survive. | State convention, exact citation, and two-sentence truncation argument. |
| Rational comparison (18) | Survives over \(\mathbf Q\). | Prior through Krämer; carries no mod-two or compatible integral splitting. | Say “noncanonically” and standardize “Krämer.” |

## Venue verdict

**Proceedings of the AMS — minor revision, then publish.**  The paper fits the
short-article format and has one coherent theorem: classical Fano geometry
realizes an integral Lefschetz defect as a canonical mod-two lattice in the
middle cohomology of the resolved theta divisor.  The surviving contribution
is more than a Smith computation, and none of the required edits changes a
statement or proof mechanism.

**Algebraic Geometry — do not submit in the present scope.**  Mathematical
quality is not the obstacle.  The abstract integral Lefschetz algebra already
sits in FVME's broader framework, and the paper treats one exceptional theta
divisor.  Reaching this stretch standard would require a genuinely broader
geometric or functorial theorem, not more exposition.

**Manuscripta Mathematica — viable specialist fallback after the same minor
revision.**  This is not a lower correctness gate; it is a narrower venue fit.
Current scope, board, and conflicts would need fresh checking before an actual
submission.

## Minimal manuscript repair list

1. **Correct the FVME boundary at printed pp. 3 and 5 and in the reference.**
   Cite FVME Theorem 2.9, Corollary 2.10, and Proposition 2.14 (or the final
   publication numbering).  State that their filtration and compatible
   splittings imply the off-central Smith factors and abstract
   \(\Lambda/2\Lambda\) defect.  Then state what this paper adds: the direct
   complete-graph realization, the representatives
   \(\theta^{[2]}\wedge z\), and their Fano/cylinder-labelled realization in
   (3).  Include `arXiv:2507.00844` or final publication data.
2. **Expand the integral-IH sentence before (17).**  Name traditional middle
   perversity and the normalization
   \(\mathcal P=\tau_{\le3}Rj_*\mathbf Z_U\) (equivalently
   \(IC_\Theta(\mathbf Z)=\mathcal P[4]\)), give a theorem-level integral
   Deligne-sheaf citation, and say why complex dimension four places degree
   three at the retained boundary.  State that the map is ordinary
   restriction to \(U\); the link's \(\mathbf Z/3\) lies in degree four and
   is truncated away.
3. **Expose the dualization before (16).**  Add one verbal or displayed exact
   dual sequence showing why quotienting functionals coming from
   \(\bigwedge^5\Lambda\) leaves
   \(\operatorname{Hom}(\ker b_*,\mathbf Z)\).  No proof change is needed.
4. **Tighten the rational comparison.**  Label (18) a noncanonical rational
   derived-category splitting and standardize the prose spelling to
   “Krämer.”

Everything else in the reports is optional polish.  In particular, no theorem
statement, lattice formula, endpoint construction, or headline needs to
change.

## Exact focused rerun plan

Any manuscript edit produces a new PDF hash, so the dossier rule invalidates
all six old verdicts.  The rerun is a new frozen batch at the new authority
commit, but its checks can be focused as follows.

1. Build with the paper's guarded `make check` route; record the new authority
   commit, PDF SHA-256, page count, and a zero-diff/clean-worktree statement for
   the paper directory.  Freeze the new PDF before any report runs.
2. Rerun **L** against the new printed pp. 3 and 5 plus the bibliography.  Gate:
   exact FVME numbering is correct for the cited version; the text concedes
   the Smith factors and abstract quotient while preserving only the direct
   blocks and divided-power representatives as the algebraic addition.
3. Rerun **P** against the new introduction, end of Section 3, equation (18),
   and references.  Gate: no unqualified firstness claim; FVME/Krämer division
   of credit is exact; (18) is noncanonical; the surviving claim is precisely
   the Fano-labelled fibre product and its dual.  No broader absence claim is
   licensed without a new citation-graph/MathSciNet/zbMATH audit.
4. Rerun **T** against Lemma 2.1, equation (5), and the revised paragraph at
   (17).  Gate: coefficient ring \(\mathbf Z\), traditional middle perversity,
   unshifted/perverse normalization, natural map, cutoff degree, and the
   degree-four \(\mathbf Z/3\) boundary all agree with the cited theorem.
5. Rerun **E** on the full new PDF, concentrating on the abstract,
   introduction, equations (16)--(18), and references.  Gate: one coherent
   headline remains, the dual transition is readable, the default-venue
   significance survives the corrected priority claim, and the abstract
   remains below 250 words.
6. Rerun **G** and **A** as regression checks on the new PDF.  G rechecks that
   Lemma 4.1, (12), Proposition 4.3, and the classical geometry are unchanged
   in substance.  A rechecks (11), (13)--(14), the global sign convention, and
   the fibre-product coset.  Neither old A transfers automatically.
7. The editor then compares the six independently frozen reruns.  Acceptance
   requires no new C/D, all four repairs above visibly present, the same main
   theorem statements, and a new synthesis pinned to the new PDF/report
   hashes.  Any changed proof mechanism, coefficient convention, or headline
   expands the rerun back to the full original packet rather than passing by
   impact assertion.

## Abstract <250 finding

**Pass.**  Report E counts the frozen abstract at **179
whitespace-delimited tokens**, below the 250-word ceiling.  Direct inspection
confirms that it leads with the rank-130 integral middle lattice, distinguishes
the abstract splitting from the simultaneous mod-two glue, and includes the
dual escape conclusion.  No abstract repair is required.  The focused rerun
must recount it after manuscript edits.

## Mystery ledger

- **Settled by the evidence closeout:** the unanimity on correctness is not a
  vote-count artifact.  G/T/A independently close the three interfaces most
  capable of breaking the headline, while L independently reconstructs every
  Smith block.  The only common adverse finding, FVME credit, is pinned to
  exact named results and is therefore adopted.
- **Settled:** E's integral-IH verification debt does not survive as a
  mathematical uncertainty.  T supplies the missing full convention and
  calculation; the remaining issue is that readers should not have to
  reconstruct it.
- **Settled:** the ten factors of two have two roles but one origin: saturation
  in degree three and the doubled exceptional sublattice in the dual escape
  lattice.  They do not make the abstract exact sequence nonsplit.
- **Open evidence boundary:** no exhaustive citation-graph, MathSciNet, or
  zbMATH search was run.  Therefore the paper may say the result is not in the
  reviewed predecessors, but a global firstness claim would require a new
  priority audit.
- **Open stretch question:** whether analogous geometric glue exists for a
  family of singular theta divisors is not answered here.  That is the exact
  kind of broader theorem needed for the stretch venue, but it is not a C928
  repair and has no bearing on the default decision.

No further correctness mystery remains on the frozen theorem package.

## Final C931 verdict

**B — minor revision; submission blocked only pending the four local repairs
and the focused fresh batch above.**  Theorem 1.1's canonical mod-two
fibre-product placement, Theorem 1.2's doubled escape lattice, and Corollary
1.3's integral degree-three intersection cohomology all survive.  The direct
Smith proof is correct, but its abstract output must be credited as an
immediate FVME specialization.  After that credit correction and the local
IH/duality/rational-convention clarifications, the evidence supports
publication in *Proceedings of the AMS*.  It does not support the
*Algebraic Geometry* stretch submission at the manuscript's present scope.
