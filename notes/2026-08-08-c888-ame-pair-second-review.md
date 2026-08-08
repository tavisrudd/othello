# C888: AME pair second external-review validation and remediation

**Lane:** `ame-lu`

**Status:** complete; both local standalone mirrors synchronized and unpushed.

## Objective

Independently vet the supplied second referee-style review against both current
manuscripts, their rendered PDFs, the owning Lean comments/trust maps, git
history, and the cited primary literature.  Repair every finding that survives
without adopting the review's novelty or correctness conclusions by authority.

## Required checks

1. Locate and read Ian Tan's five-qubit/six-qubit AME symmetry paper; decide
   whether it belongs in the AME paper beside his general AME--QMDS work.
2. Audit the companion's quantum-transversal related work against the primary
   papers by Tansuwannont--Takada--Fujii, Dasu--Burton, Sayginel and
   collaborators, and the claimed August 2026 Victor Albert preprint.  State
   their scopes accurately and avoid a firstness or absence claim.
3. Reconstruct the coherent Weil-lift paragraph with the manuscript's exact
   Weyl and CSS stabilizer conventions.  Decide whether the tensor phase
   `chi(c dot h / 2)` is trivial on `C direct-sum C-perp` and whether that proves
   preservation of the stabilizer character/state ray rather than labels only.
4. Check every `Corollary 1.1`/`Theorem 1.1` reference semantically and repair
   all stale numbering, including public maps and generated statement facts.
5. Cross-check every change against the owning Lean module comments and exact
   declarations.  Quantitative or phase arguments not formalized in Lean must
   remain explicitly manuscript-only.
6. Rebuild and visually inspect both papers as affected, regenerate release
   identities, audit/export both existing standalone histories through the
   guarded exporter, and leave push/deposit/submission as author decisions.

## Acceptance

Record a finding disposition and primary-source ledger with exact read depth;
pass warning-free paper and release gates; run an adversarial phase-convention
and novelty-boundary closeout; keep edits within both paper roots, their owning
trust metadata if genuinely required, and this report/lane lifecycle surface.

## Finding disposition

| Review claim | Verdict | Disposition |
|---|---|---|
| The previous AME correctness objections are repaired | **confirmed** | Rechecked the current theorem/proof bridge, fixed-state scope, lift notation, Bell convention, and literature concessions.  No further mathematical correction was needed. |
| Tan's five-qubit paper belongs beside the special AME symmetry calculations | **confirmed** | Its abstract and Section 3.4 explicitly compute the six-qubit AME local symmetries and relate them to the transversal gates of the associated five- and four-qubit codes.  AME--LU now cites it next to Tan's four-qutrit calculation. |
| The MDS--CSS related work is too thin | **confirmed** | The bibliography already contained Tansuwannont--Takada--Fujii, Dasu--Burton, and Sayginel et al., but none appeared in the text.  The introduction now states their exact qubit/CSS scopes, adds Albert's 6 August 2026 preprint, credits Tan's concrete AME cases, and distinguishes the odd-prime one-logical-qudit MDS nullity classification without a firstness claim. |
| Dasu--Burton and Prakash--Singhal use a uniform physical convention, unlike this paper's site-dependent products | **confirmed and load-bearing** | Dasu--Burton use \(T^{\oplus n}\), the tableau of \(U^{\otimes n}\).  Prakash--Singhal's complete-Clifford lemma conjugates by \(V_F^{\otimes n}\).  The introduction now states that this paper permits site-dependent factors and explains that the isodual branch generally propagates \(A\) through different \(\phi_i(A)\). |
| Rains is the conceptual endomorphism-algebra ancestor | **confirmed with scope qualification** | Rains studies the same symplectic transformation at each coordinate, algebras spanned by those global actions, and universal operations on multiple copies (Theorems 4 and 14).  The paper now cites this framework and calls Proposition 3.1 an MDS collapse of the corresponding endomorphism problem, not a specialization of Rains's theorem. |
| Prakash--Singhal creates an apparent self-orthogonal-CSS contradiction | **confirmed as a convention distinction** | Their Section IV.C lemma assumes a complete set implemented by uniform \(V_F^{\otimes n}\).  This does not cover the companion's site-dependent \(\phi_i(A)\) implementations; the distinction is now explicit. |
| The non-isodual \(T\)-branch skips the proof that diagonal blocks are common | **confirmed as proof-hardening** | Proposition 3.1 applied to \(\mathcal D(C,C)\) and \(\mathcal D(C^\perp,C^\perp)\) forces \(D_\alpha=aI\) and \(D_\delta=dI\); local determinant one gives \(ad=1\).  These lines are now printed. |
| The square class of \(t_i\) detects whether propagation can be uniformized | **confirmed** | Conjugation by \(\operatorname{diag}(1,t_i)\) is inner on \(\mathrm{SL}_2(q)\) exactly when \(t_i\) is square: the centralizer in \(\mathrm{GL}_2(q)\) is scalar and determinant normalization is possible exactly then.  Since \(t_j=1\), any nonsquare \(t_i\) gives mixed inner/outer classes that fixed local Clifford frames cannot make uniform.  The observation is now stated after (3.4). |
| Sayginel's ZX/Pauli machinery and Tan's general bridge need direct comparison | **confirmed** | The introduction now relates Sayginel et al.'s sign correction to the imported character-correction lemma and their ZX dualities to Appendix C, and directly credits Tan's general AME--QMDS LU-orbit and symmetry--transversal theorems before identifying the multiplier theorem's separate role. |
| The coherent Weil lift preserves only labels unless a phase is checked | **confirmed as proof-hardening** | In the symmetric convention (D_{a,b}=\chi(ab/2)X(a)Z(b)), a CSS label ((c,h)\in C\oplus C^\perp) has global phase (\chi(c\cdot h/2)=1).  Exact Egorov covariance therefore preserves the actual (X(c)Z(h)) stabilizer lift and its trivial character/state ray.  The manuscript now gives this calculation. |
| The headline is repeatedly called Corollary 1.1 | **confirmed** | The environment was a theorem but retained a `cor:` semantic label and three prose references called it a corollary.  The label is now `thm:diagonal-isodual-transversal-group` across source, maps, claim manifest, trust registry, and regenerated paper facts. |
| The cross-paper split is coherent | **confirmed** | The dependency remains one-way: Paper II imports exact factorwise rigidity, phase correction, and the atlas; Paper I's exact and quantitative theorems do not depend on Paper II.  No ownership edit was required. |

## Primary-source record

The audit used the following cached primary PDFs.  Read depth is claim-specific;
cache presence alone is not counted as inspection.

| Source | Cache and SHA-256 | Read depth and load-bearing locator |
|---|---|---|
| Ian Tan, *Classification of Five-Qubit Absolutely Maximally Entangled States*, arXiv:2507.02185v4 | `c888-2507.02185.pdf`, `1670c4774274156a2079caac312b440f60f5de36b4a05159ace682946d753943` | partial: abstract, introduction, Section 3.4, especially Theorem 3.6 and Propositions 3.8--3.9 |
| Tansuwannont--Takada--Fujii, *Clifford Gates with Logical Transversality for Self-Dual CSS Codes*, arXiv:2503.19790v1 | `c888-2503.19790.pdf`, `1734a9034eabbf75450c00e41352fa2b049747384d06528053f834cacab3e82e` | partial: abstract, Theorem 1 and its construction, Corollary 1, conclusion |
| Dasu--Burton, *A Classification of Transversal Clifford Gates for Qubit Stabilizer Codes*, arXiv:2507.10519v1 | `c888-2507.10519.pdf`, `da95db6671622a7356666212017749eb42da3e5ab545c3acb7e4a5013bc8452f` | partial: abstract, introduction, uniform \(T^{\oplus n}\) definition, endomorphism-algebra definitions, Theorems 4.1 and 6.1, conclusion |
| Sayginel--Koutsioumpas--Webster--Rajput--Browne, *Fault-Tolerant Logical Clifford Gates from Code Automorphisms*, arXiv:2409.18175v3 | `c888-2409.18175.pdf`, `f95889863485fb43f2036783ebff3618661dff1bb68753f7dd22256e32adaa68` | partial: abstract, Sections III--IV, Pauli-correction and ZX-duality passages, conclusion |
| Victor V. Albert, *Beyond Transversality: Structure of Clifford Circuits for CSS Codes*, arXiv:2608.05688v1 | `c888-2608.05688.pdf`, `4d8d1f2f22c483ee7c7cf1983b63d42fa2dbb6df27f135354c565445392a9728` | partial: abstract, Sections III--V, three-layer transversal result, two-fold group definition, conclusion |
| Eric M. Rains, *Nonbinary Quantum Codes*, arXiv:quant-ph/9703048 | `c888-rains-nonbinary.pdf`, `d97559db6fd164b7aeab176987c32c286eb429bd18fd82be0a44bc5c31f1c7fd` | partial: linear-code/global-symmetry setup, Theorem 4, and the complete “Universal fault-tolerant operations” section through Theorem 14 |
| Shiroman Prakash and Rishabh Singhal, *Search for High-Threshold Qutrit Magic-State Distillation Routines*, arXiv:2408.00436v4 / PRA 113, 042404 (2026) | `c888-prakash-singhal.pdf`, `fa9494bea915848cf996e0219fc101b5a93b79ad747e8f988e045d31d28881d2` | partial: transversal definition, Section IV.C complete-Clifford lemma and proof, discussion |

Discovery queries were `Ian Tan five-qubit six-qubit AME symmetry`, the exact
author/title combinations for the four transversal papers, and the date-sensitive
`Victor Albert Clifford circuits CSS codes transversal two-fold-transversal August
2026`.  A bounded predecessor screen used `diagonally isodual MDS CSS transversal
Clifford group`, `diagonal multiplier code dual transversal logical group MDS CSS`,
`odd prime MDS CSS exact transversal Clifford group SL2 split torus`, and `one
logical qudit MDS CSS transversal Clifford group classification`.  It promoted no
direct subsumer of the paper's exact nullity dichotomy, but this was not an
exhaustive citation-graph screen and licenses no absence claim.  MathSciNet,
Google Scholar, and zbMATH were NOT COVERED in C888.

The deeper follow-up used exact-title searches for Rains's *Nonbinary Quantum
Codes* and Prakash--Singhal's qutrit distillation paper, then inspected their
arXiv sources rather than relying on search snippets.  It also inspected the
Dasu--Burton source definition of the repeated tableau \(T^{\oplus n}\).
The review's ranking of likely referees is an opinion rather than a verifiable
claim; C888 records only the scope and theorem comparisons that can be audited.

## Lean and trust cross-check

No `.lean` source required an edit.  `StabilizerAMERigidity` already permits
arbitrary nonzero stabilizer-lift phases and proves exact factorwise rigidity for
(m\ge2); `EncoderTransversal` states Cliffordness of the logical factor and
every physical factor with the inverse-transpose Choi convention.  The coherent
Weil lift is explicitly manuscript-only in both the formalization and verification
maps.  The only formal-surface change is the semantic manuscript-label rename in
`lean/trust/papers.toml`; both paper-facts artifacts were regenerated rather than
edited by hand, and paper-facts checks report no errors or staleness.

## Validation before export

- AME--LU rebuilt warning-free at 35 pages and 304,715 bytes.  The opening
  literature paragraph and final bibliography page were visually inspected.
- MDS--CSS rebuilt warning-free at 23 pages and 210,953 bytes.  The expanded
  related-work discussion, hardened torus-branch proof, inner/outer propagation
  remark, coherent Weil calculation, affected theorem references, and final
  bibliography were visually inspected; all 17 evidence artifacts and eight
  replay bundles passed.
- AME release identity: 18 public artifacts, tree
  `fa1d640e09e5fc6619cabc075cafab04a9eca6976816effefc6d555b975c3dbc`;
  82 formal artifacts, unchanged tree
  `9689cefd30fe04d163d32ba93e5f84b3a67906db69e57bd1a254c411ddabb131`.
- MDS--CSS release identity: 20 public artifacts, tree
  `b0e99b22cbcb0006396cead37e5090a82674e68e65966fdeb3d28f423f185129`;
  72 formal artifacts, tree
  `fd9279edd28abb23b13d01ad1070801771aced5c9ae306b8975cb69d1d65f929`.

## Standalone export closeout

Both guarded plans and audits at immutable authority commit
`3996cb3678e9ae6d58c5c3bccc1e3d60987c2dc1` reported zero private-reference
findings.  The existing clean mirrors were synchronized, force-rebuilt, checked
against their paper-local release manifests, checked again against their
canonical export manifests, and committed:

- AME--LU: mirror commit
  `d6ca9e564d4e5b9e775a25e768741a12da92a137`, export-manifest SHA-256
  `f2c0ec6af5b95f1b3f5bc8b2adaf4ad48b1a2fcc4e9973a565d214e2a6709236`,
  PDF SHA-256
  `239d97a02d617354c07fd3ee4675916329ea1fc86a9ec26afab08fd432a353aa`;
- MDS--CSS: mirror commit
  `c5f6cec1a600695ae35df9eba7bd81cdab19919a`,
  export-manifest SHA-256
  `4409b2f0a54bfbb6048b55bba8f462a69d4626177ac5c891bc8241195863f4ea`,
  PDF SHA-256
  `ad97bc1747e3367ebb4ff91d58081336927d27c7db6b88fe51aa97a10b7b41ff`.

Both mirrors are clean.  Nothing was pushed, deposited, tagged, or submitted.
The discovery-track discriminator produced no incidental lead beyond the
reviewed and adopted scope distinctions, so no companion-log entry was added.
