# Cubic threefolds after stabilization

**Lane:** `cubic-threefolds`

**Date:** 2026-08-24

> **LIVE MAP ONLY.** This is the routing and state surface for this lane.
> Per-task detail belongs in the task cards under `notes/cubic-threefolds-tasks/`;
> proof-level detail belongs in the dated notes those cards link to.  Removed
> chronology is retained in `2026-08-15-cubic-threefolds-archive.md`.

## Origin and scope

Split off from the `clebsch` lane on 2026-08-15. This lane owns the
research-only successor program that grew out of Clebsch Paper V's
(`papers/chordal-conference-reconstruction/`) cubic-threefold epilogue:
quantum-monodromy stabilization, the relative Chow/cycle-theory frontier,
and adjacent structural research on cubic threefolds. It does **not** own
Paper V itself or the numbered Clebsch series — those stay in `clebsch`.

**C912 and C913 were re-pegged to this lane on 2026-08-15 by author
instruction**, and with them both stabilization manuscripts. C912 closed the
referee-foundation repairs to the cubic-stabilization epilogue
(`papers/cubic-stabilization-m1/`), the `m = 1` statement, whose headline
is now unconditional. C913 owns the referee revision pass on
*Irrationality of Cubic Threefolds after One Stabilization*
(`papers/cubic-stabilization-irrationality/`), the all-`m` statement, conditional
on the marked-threshold wall and zero-mode hypotheses. They are separate
manuscripts with separate hypotheses; this lane now covers both.

## Formal standard (when Lean-facing)

Any declaration this lane promotes to Lean (currently only C910's epilogue
companion) meets the same standard as the numbered Clebsch series: no
`sorry`, no `native_decide` or compiled-evaluation axiom at any terminal, no
project axiom or assumed hypothesis standing in for a proof, and every
promoted mathematical assertion maps to a kernel-checked declaration.

## Current status

- **C936 — accepted after cold-referee repair audit.**  The warning-free eleven-page paper
  develops the signed nonstandard \(A_5\)-cubic parameter as the
  sign/discriminant resolvent of the actual
  relative norm-axis elliptic two-division cover.  It identifies
  \(T=81t^2\), \(r=9t\), \(X_0(6)\), the sign and split level-six subgroups,
  exact \(A_3\) monodromy, cusp widths \(2,6\), and the two extra
  modular-interior cubic boundary values.  At the chordal value, an exact
  orbit-and-ideal certificate identifies the transverse divisor with the
  reduced twelve-point icosahedral orbit conditional on identifying the
  special fibre with the secant cubic of its reduced singular rational normal
  quartic.  The van Geemen-lens referee's geometric findings are now repaired:
  the paper derives the factor-five Prym pullback and axis polarizations and
  forces the comparison isogeny to have degree one; an exact Fourier transform
  proves the coordinate and twist bridges; a separate programme-input
  proposition distinguishes candidates from the actual kernel; and the
  chordal fibre is displayed as a Hankel catalecticant.  The independent
  repair audit returns Accept at confidence 0.94 with no fatal or major
  defect; its final minor wording and optional certificate points are closed.
  A final style-guide pass gives a 142-source-word abstract and exposes the
  three-step proof mechanism immediately after the main theorem.  Integrated
  `make check` passes.  The verified standalone repository is
  `~/src/math-papers/cubic-gluing-resolvent` at `92a7d79`; its rebuilt PDF is
  byte-identical to the authority PDF.  A post-close EJ pass further proves
  that golden orientation turns the rational triple into the cyclic cubic
  splitting cover and gives
  \(t=3(\eta(3\tau)/\eta(\tau))^6\).  Exact algebra and an independent subgroup
  enumeration replay under `make check`.  Referee
  report: `../2026-08-21-c936-van-geemen-cold-referee.md`; project report:
  `../2026-08-21-c936-modular-resolvent-companion.md`.  The cubic-stabilization
  epilogue now points forward to the companion from its elliptic-discriminant
  paragraph.  Its 51-page rendering passes visual inspection and `make check`;
  its abstract is now a 164-word theorem-first paragraph and it carries the
  standard AI-assistance disclosure.  The verified standalone epilogue is
  synchronized at commit `65ef31d`, with a PDF byte-identical to authority.
- **C935 — closed 2026-08-21; exotic gluing is the elliptic discriminant
  orientation.**  The epilogue now proves that monodromy on the exotic pair is
  the sign of its action on the rational two-division triple, identifies the
  resulting class with the square-root torsor of the elliptic discriminant,
  and observes that the actual kernel section cuts mod-two monodromy to
  \(A_3\).  The noncanonical deck choice is explicit; the universal modular
  resolvent is verified but a curve-level cubic identification is reserved for
  a short companion after normalization, degree, stack-marking, and cusp gates.
  The manuscript remains fifty pages and `make check` passes.  Report:
  `../2026-08-21-c935-elliptic-two-division-resolvent.md`.
- **C934 -- paper upgrade/export complete; all-degree table active.** The
  11-page paper now proves the integral derived splitting, central Smith
  factor three, canonical mod-three `delta_0`--`IC`--`delta_0` Loewy chain,
  Fano lift of the link class, and exact modular failure of relative hard
  Lefschetz.  Fresh modular, geometric, and editorial packets are unanimous A;
  the active-voice abstract is 147 tokens; *Mathematische Zeitschrift* is the
  strongest target.  The clean standalone repository is
  `~/src/math-papers/blown-up-theta-lattice` and includes `.zenodo.json`.
  DOI `10.5281/zenodo.22036586` and the standard badge are recorded in the
  paper README; the public portfolio summary is synchronized.
  Original acceptance debt remains: enumerate all local/global integral groups
  in every degree.  Full Fano-transfer surjectivity and a monodromy-equivariant
  family form remain secondary tests.  Card:
  `../cubic-threefolds-tasks/c934-integral-theta-decomposition-complex.md`.
- **C933 — closed 2026-08-20; six-page Hodge-atom marker-ledger companion.**
  The standard atom construction is now a self-contained, strictly `m=1`
  specialization of the categorical occurrence/groupoid/fold spine; the
  epilogue has one non-load-bearing cross-reference and remains fifty pages,
  Gamma-row is untouched, and both standalone repositories are synchronized
  and verified.  Report:
  `../2026-08-20-c933-hodge-atom-marker-ledger-companion.md`.
- **C931 -- closed 2026-08-20; C928 repaired, re-refereed, and submission-ready.**
  The four adopted local findings were repaired without changing a theorem or
  proof mechanism: exact FVME credit, the integral-IH truncation convention and
  citation, the dual exact-sequence bridge, and noncanonical wording for
  Krämer's rational splitting.  Six fresh mutually isolated packets all return
  A with no required finding; Theorems 1.1 and 1.2 and Corollary 1.3 survive
  integrally, the eight-page PDF is clean, and every abstract count is below
  250 words.  Submit to *Proceedings of the AMS*; do not expand the present
  focused paper merely to chase the *Algebraic Geometry* stretch venue.  Card:
  `../cubic-threefolds-tasks/c931-c928-referee-dossier.md`; dossier:
  `../2026-08-20-c931-c928-referee-dossier.md`; final synthesis:
  `../2026-08-20-c931-c928-rerun-synthesis.md`.
- **C930 — 50-page epilogue refounding passes hostile manuscript review.**
  C930 owns only `papers/cubic-stabilization-m1/`, strictly at `m=1`.
  The common occurrence-indexed marker theorem is now instantiated on distinct
  atomic and framed block types, and both specializations pass resumed, fresh
  blind, and hostile manuscript review.  The implementation retains the
  18-page cycle core and refounds the quantum pair through the common compiler,
  shortening the frozen 60-page epilogue to 50 pages.  The full integrated
  check passes.  The Gamma-row manuscript is explicitly out of C930 scope and
  was not edited.  Baseline: `../2026-08-20-c930-epilogue-baseline.md`; memo:
  `../2026-08-20-c930-categorical-direct-qdm-proof-memo.md`; reports:
  `../2026-08-20-c930-independent-referee-report.md` and
  `../2026-08-20-c930-second-referee-pass.md`. Card:
  `../cubic-threefolds-tasks/c930-categorical-direct-qdm-paper-preparation.md`.
- **C925 — stabilization threshold and cancellation, active.**
  **Result boundary:** no unconditional every-smooth \(m=2\) theorem has
  been landed, but both explicit Tschinkel--Zhang cubics now have exact
  threshold \(s(X)=2\): \(X\times\mathbf P^1\) is irrational and
  \(X\times\mathbf P^2\) is rational. The every-smooth all-\(m\) target is false by
  Tschinkel--Zhang's stably rational smooth cubic threefolds.  The separate Voisin plus
  Engel--de Gaay Fortman--Schreieder route proves all stabilizations for a
  very general cubic, conditional on the cited 2025 preprint; it does not
  cover Voisin's special universally-\(\mathrm{CH}_0\)-trivial loci.
  The improved level-five theorem is uniform.  For the full type-\(I_3\)
  group, quotient by the anticanonical scalar and both full auxiliary
  permutation tori.  A primitive split kernel projectivizes the target
  four-block; the residual actor is quasi-trivial and its quotient of the
  \(6+1\) block is a rational rank-two torus.  Since
  \(I_0,I_1,I_2\subset I_3\), every stably rational quartic del Pezzo surface
  satisfies \(S\times\mathbf A^5\) rational, and every cubic hypersurface in
  both Tschinkel--Zhang families satisfies
  \(X\times\mathbf P^5\) rational over \(\mathbf Q\).  Their cubic
  threefolds therefore had certified interval \(2\le s(X)\le5\).  The exact
  CARAT replay also resolves class `(5,232,15)`, listed as unknown in
  Jamshidpey's 2017 Table B.2.  Its dual `(5,232,14)` is not retract rational
  by Hoshi--Yamasaki Table 15, giving a rational torus whose dual is not
  retract rational; post-2017 priority remains unaudited.  Report and
  certificates:
  `../2026-08-24-c925-uniform-quartic-del-pezzo-level-five.md`.

  Level four is now isolated as a cancellation frontier.  The type-\(I_1\)
  rank-five lattice has no second split direction; its three sign directions
  have nonsplitting indices \(2,2,6\), although all three rank-four quotient
  tori are rational.  For either explicit cubic threefold, putting
  \(Y=X\times\mathbf P^4\) gives \(Y\times\mathbf A^1\) rational.  Thus
  \(m=4\) irrationality would produce the cancellation example
  Tschinkel--Zhang state is currently unknown, while \(m=4\) rationality
  lowers the bound.  Report:
  `../2026-08-24-c925-level-four-cancellation-frontier.md`.

  **Superseding level-four result:** the cancellation gate is bypassed by a
  geometric slice. Two type-\(I_1\) sign subtori have projective Cox weights
  \(0^8,1^8\), hence line orbit closures. A hyperplane through a general
  OADP tangent center is both rational by tangent projection and a one-point
  quotient slice. The residual rank-four torus has actual character class
  `(4,76,4)` and is hereditarily rational. Therefore every type-\(I_1\)
  quartic del Pezzo surface with a point satisfies
  \(S\times\mathbf A^4\) rational, and every cubic in Tschinkel--Zhang
  Proposition 5.1 satisfies \(X\times\mathbf P^4\) rational. Their cubic
  threefolds then had certified interval \(2\le s(X)\le4\), superseded below
  by the exact level-two result. Report:
  `../2026-08-24-c925-type-i1-level-four-rationality.md`.

  **Uniform level-four result:** for the full type-\(I_3\) action, the sign
  subtorus with Cox weights \(0^2,1^6,2^6,3^2\) has rational-normal-cubic
  orbits. Their two boundary points lie in a fixed Galois-stable
  \(\mathbf P^3\). A tangent hyperplane through that boundary space is a
  rational one-point quotient slice. The residual character lattice is
  `(4,99,3)`, inside a Lemire hereditary-rational class. Hence every stably
  rational quartic del Pezzo satisfies \(S\times\mathbf A^4\) rational and
  every cubic in both Tschinkel--Zhang families satisfies
  \(X\times\mathbf P^4\) rational. Report:
  `../2026-08-24-c925-uniform-level-four-rationality.md`.

  **General OADP quotient theorem:** the line and cubic slices are now
  instances of one adjacent-weight principle. If a one-dimensional torus
  acts on an OADP variety and a Galois-stable linear boundary space contains
  every weight block except two adjacent ones, a tangent hyperplane restricts
  to a binomial and meets each open orbit once. Hence the quotient is
  rational. No normality or rational-normal-curve hypothesis on the orbit
  closure is needed. This makes the Tschinkel--Zhang level-four theorem a
  corollary of a reusable result while the exact rank-two polytope exhaustion
  explains why it does not iterate to level three. More generally, a
  rank-\(r\) torus quotient is rational when a tangent codimension-\(r\)
  section leaves exactly a Galois-stable unimodular \(r\)-simplex of weight
  blocks: the section equations have a unique open-orbit solution. Report:
  `../2026-08-24-c925-adjacent-weight-oadp-quotient-theorem.md`.

  **Exact level-three frontier:** for type \(I_1\), the saturated span of
  two sign cocharacters has four Cox weight blocks of size four, so its
  generic orbit closure is a Segre quadric. The residual rank-three
  character torus is CARAT `(3,25,2)` and is rational by Kunyavskii's
  complete classification. Over the splitting field, an exact Cox-Jacobian
  rank-six calculation produces the expected tangent two-hyperplane slice:
  one boundary point plus one open-orbit point. It does not descend by the
  direct linear construction, because Galois exchanges the chosen boundary
  ruling with its opposite and their coordinate spaces span all
  \(\mathbf P^{15}\). This is now exhaustive: the multiplicity-free
  cocharacter representation has exactly four invariant two-planes, with
  orbit-surface degrees `2,6,6,6`; their boundary-edge orbit sizes force
  every descended proper ambient codimension-two section to have open degree
  divisible by two or three (an arbitrary ambient codimension-two cycle has
  class `dH^2`). Exact affine Galois closure also shows that none of the four
  polygons has any stable three-weight subset, so there is no descended
  unimodular triangle window. The fourth residual torus is additionally the
  non-retract-rational class `(3,6,3)`. Thus the remaining gate is an
  intrinsic rational correspondence or invariant-field parametrization, not
  a missed linear subtorus, higher-degree ambient slice, or residual-torus
  calculation. Moreover, if
  \(Y=X\times\mathbf P^3\) is irrational, then the uniform level-four
  theorem makes \(Y\times\mathbf A^1\) rational, producing the cancellation
  example Tschinkel--Zhang record as unknown; if \(Y\) is rational, the
  bound drops to three. Unconditionally, since \(s(X)\in\{2,3,4\}\), one
  of the three named smooth projective varieties
  \(X\times\mathbf P^i\), \(1\le i\le3\), is nonrational but has rational
  \(\mathbf A^1\)-stabilization. This finite-list certificate does not yet
  identify which candidate, so it does not close Tschinkel--Zhang's
  single-example construction problem. Report and exact certificates:
  `../2026-08-24-c925-level-three-descent-and-cancellation-frontier.md`.

  **Standalone cancellation consequence:** the same threshold argument has
  now been hardened over \(\mathbf Q\). The complex \(m=1\) irrationality
  theorem rules out \(\mathbf Q\)-rationality at level one, while the uniform
  OADP theorem gives \(\mathbf Q\)-rationality at level four. For the minimal
  \(s_{\mathbf Q}\in\{2,3,4\}\), the smooth projective variety
  \(X\times\mathbf P^{s-1}\) is nonrational but becomes rational after one
  \(\mathbf A^1\). This settles the existential birational-cancellation
  statement with the explicit three-element candidate list
  \(X\times\mathbf P^i\), \(1\le i\le3\), but does not identify one member.
  The source's August 21 open statement and a bounded August 24 arXiv/OpenAlex
  screen support only correspondingly bounded priority language. Report:
  `../2026-08-24-c925-finite-disjunction-a1-cancellation-theorem.md`.

  **Identified cancellation counterexample and exact type-\(I_1\) threshold:**
  the three-sign eigenbasis used in the first rank-three pass had saturation
  index two. Replacing its third vector by the integral half-sum gives the
  actual saturated subtorus. Its central four-block weight window is
  unimodular, not index two, and the exact tangent coefficient matrix has
  rank three with all kernel coordinates nonzero. The higher-rank OADP
  theorem therefore makes the quotient rational. Its residual torus has rank
  two, so every type-\(I_1\) quartic del Pezzo surface in the
  Tschinkel--Zhang setting satisfies \(S\times\mathbf A^2\) rational and
  every Proposition 5.1 cubic satisfies \(X\times\mathbf P^2\) rational over
  \(\mathbf Q\). For their cubic threefold, the \(m=1\) theorem gives
  \(s(X)=2\). Hence the single smooth projective variety
  \(Y=X\times\mathbf P^1\) is nonrational while
  \(Y\times\mathbf A^1\) is rational, answering their stated construction
  problem. Primary SymPy and independent stdlib certificates agree. Report:
  `../2026-08-24-c925-type-i1-level-two-rationality.md`.
  The exact “priority judo” boundary—what becomes a corollary, what remains an
  input, and which novelty checks remain open—is recorded in
  `../2026-08-24-c925-tz-priority-judo-synthesis.md`.

  **Uniform level-two extension:** the full type-\(I_3\) group preserves the
  saturated rank-three lattice spanned by the last three standard
  cocharacters. Its four surviving Cox blocks form the same unimodular
  tetrahedron, with the same boundary space, as the type-\(I_1\) slice. The
  residual torus again has rank two. Since \(I_0,I_1,I_2\) embed in \(I_3\)
  up to conjugacy, all four Tschinkel--Zhang types satisfy
  \(S\times\mathbf A^2\) rational. Both cubic families therefore satisfy
  \(X\times\mathbf P^2\) rational, and both cubic threefolds have exact
  threshold \(s(X)=2\). Report and certificate:
  `../2026-08-24-c925-uniform-level-two-rationality.md`.

  **Corrected rank-three frontier:** the former index-two/double-cover
  conclusion was a nonsaturated-lattice artifact and is withdrawn. In the
  actual lattice the orbit degrees are `7,18,18,6`; the three-sign stable
  windows have indices three and one. The index-one window lands type-\(I_1\)
  level-two rationality as above. Report and corrected certificate:
  `../2026-08-24-c925-rank-three-boundary-peeling-frontier.md`.

  **Unbounded INT-\(\Psi\) falsifier:** the isolated codimension-four
  negative-normal example extends to every \(r\ge4\) and every \(k\ge1\).
  For the section \(Z\cong\mathbf P^1\) in
  `P_{P1}(O + N)` with
  `-deg(N)=(r-1)(k+2)`, the first reconstructed base-square coefficient is
  the nonzero term \(q^kz^{r-4}\). Thus no finite universal Novikov shift
  repairs the decorated transport across arbitrary blowup edges. This is a
  general local mechanism compatible with Tschinkel--Zhang's required
  eventual marker failure. Its \(z\)-degree shows that codimension four is
  the first dangerous case, hence ambient dimension five—exactly cubic
  stabilization \(m=2\). It does not identify an edge in their
  rationalization or decide \(m=2\). Report and exact certificate:
  `../2026-08-24-c925-unbounded-int-psi-negative-normal-family.md`.

  **Conditional finite reduction:** put \(n=m+1\).  For a connected center,
  after a native pure-Euler inner \(n\)-cycle has been placed inside one fixed
  outer correction factor, Lean's cyclic dimension consumer forces \(d=n\)
  and exhausts the residue-zero plane.  Only that inner case is codimension
  two.  Lean also checks the recurrence compression, the lower cubic
  certificate, and scalar formula regressions at \(m=1,2,3,4,13\); it does
  not derive the generic all-\(n\) recurrence or residue shapes.

  **Exact open gate:** for \(m=2\), the nonsplit outer-return law and the
  accepted point/curve/surface marker theorem exclude codimensions three
  through five at the generic numerical-reduced even base.  The sole
  remaining theorem is occurrence-wise exclusion of an exact three-cycle
  among exact-\(4/9\) marked blocks of the single outer factor attached to
  each connected codimension-two threefold-center occurrence.  A generic
  divisor-generator reduction is not enough: a pairing-preserving parabolic
  shear fixes the unit and both divisor vectors and still produces the cubic
  marker.  The sufficient provider must descend the carrier and elementary
  modification to the native effective large-radius calibration, or prove the
  exact-period exclusion directly.  A regular unital projector descent would
  force a rank-six whole-center algebra; Elias--Rossi reduce its classical
  fibre to two types.  Explicit graded self-dual orders nevertheless realize
  both types with the same generic paired \(C_3\)-algebra and marked divisor,
  so order data alone do not close the QDM residue problem.  The
  matched divisor specializes to \(J_4\oplus J_2\) and
  \(J_4\oplus J_1^{\oplus2}\), respectively, so native control of this
  special Jordan type is a narrower possible separator.  Lean now checks one
  normalized generic primary reduction for each type: the dual-number
  reduction has residue discriminant zero, while the distinct-root reduction
  does not preserve the elementary-modification line.  Thus either normalized
  native calibration excludes \(4/9\), but no source constructs such a
  calibration from the geometric occurrence.  The strict companion equality
  case is now independently replayable: exact Rust elimination solves the two
  unique normalized gauges, Lean checks their full recurrences and
  discriminants \(0,4\), and a typed `Calibration` theorem transports the
  exclusion under simultaneous intertwining of multiplication, projector,
  first gauge, grading, selected basis, and left inverse.  The geometric task
  is to construct that calibration, not another finite recurrence proof.  The
  pre-strict candidate dimensions at
  \(n=2,3,4,5,14\) are respectively \(\{1,2\}\), \(\{1,3\}\),
  \(\{1,3,4\}\), \(\{1,5\}\), and
  \(\{1,7,8,9,11,13,14\}\).  After a separate equality-case exclusion, the
  unresolved sets are empty, empty, \(\{3\}\), empty, and
  \(\{8,9,11,13\}\).  These are missing geometric data or theorems, not
  another consumer-plumbing lemma.

  **Programme-level reconstruction signal:** the smallest plausible
  enrichment of the generic marked packet is now a two-layer **marked Rees
  port**: its self-dual Kummer-coweight orbit and its first marked
  connection/Rees jet.  The layers are independently necessary.  The two explicit native
  orders differ by relative coweight \((-1,0,0,0,0,1)\), whereas the
  coweight-zero parabolic shear retains the associated grading but changes the
  marker through its first jet.  The discrete monomial enumeration is now
  landed with canonical Rust data and Lean correspondence.  A bounded raw
  Bruhat domain is now ruled out under the coarse hypotheses: the effective
  charge-(3k+1) family retains exact cubic period and has unbounded self-dual
  coweight \((0,-k,-2k,2k,k,0)\).  Lean proves this uniformly.  The source
  theorem must instead construct a primitive marked valuation or quotient the
  coweight and first jet together by loop-trivial cocharacter drift.  C924's
  modified-flatness calculation does make the marked base connection regular
  in (z), so a relative Deligne--Manin extension is conditionally applicable
  after an effective regular-singular trait has been supplied; it does not
  choose that trait or the quotient.  Reports:
  `../2026-08-22-c925-marked-rees-shadow.md` and
  `../2026-08-22-c925-deligne-rees-extension-audit.md`.
  The first exact certificate stage is now landed: Rust emits the three
  Laurent comparison blocks inside the full (6\times6) basis-change matrix
  and the parabolic first jet, while Lean independently checks the extraction,
  recovers coweight \((-1,0,0,0,0,1)\), checks self-duality and all finite jet
  identities, and certifies the two independent information-loss modes.
  A second exact certificate now exhausts the effective coweight-zero
  dual-number chart: self-duality leaves five parameters, correct transport of
  both multiplication indices makes conformality equivalent to a
  one-parameter normal family, and Lean checks the complete gauge recurrence
  and discriminant zero throughout that family.  The output-only transport
  mutation is explicitly rejected.  A third exact certificate exhausts the
  five-parameter distinct-root chart.  Its logarithmic defect vanishes
  identically, but Lean proves that the selected block's lower-left grading
  entry is always \(1/6\), so the marker's leading line is not preserved.
  Thus both normalized native-order charts are closed.  A fourth exact
  certificate now exhausts the discrete unit/top-fixed monomial Weyl layer:
  four of eight positions are divisor-generating, and the Laurent Kummer
  involution pairs them into the two already-checked zero and single-reversal
  classes.  Lean now checks the complete divisor pullback after arbitrary
  displayed effective unipotent factors on both sides: none of the four other
  Weyl cells can satisfy the cubic branch-separation fingerprint.  This does
  not control loop-trivial coweight drift outside those cells.  The next
  finite test is the induced semidirect action on the first marked jet and
  recurrence; the geometric occurrence-to-port construction remains external.

  **Closed lanes:** the common \(\epsilon M\)-row/stable-projector
  composite, raw and normalized degree-zero augmentation, ordinary
  Hodge/Hard-Lefschetz multiplicity, and algebraic-simplicity projection all
  have explicit countermodels or completion/type failures.  Do not reopen
  them without defeating the recorded falsifier.

  Card: `../cubic-threefolds-tasks/c925-modular-direct-qdm-proof-packet.md`.
  Source dossier: `../2026-08-21-c925-no-stokes-source-dossier.md`.
  Divisor/calibration report:
  `../2026-08-22-c925-kummer-divisor-generator.md`.
  Marked Rees-shadow report:
  `../2026-08-22-c925-marked-rees-shadow.md`.
  Logarithmic-extension and trait-drift audit:
  `../2026-08-22-c925-deligne-rees-extension-audit.md`.
  Indirect route report:
  `../2026-08-22-c925-indirect-rationality-predictions.md`.

  Geometric (rotation-order) route and its 2026-08-23 vetting, which voids the
  grading-multiplicity exclusion and confirms the del Pezzo refutation of the
  dimension bound: card section "Geometric route to the same gate" and
  `../2026-08-23-c925-fable-opus-vetting.md`.  Marker reformulated as a
  \(\Psi\)-invariant Levelt exponent class; the calibration gate is superseded
  and the \(m=2\) obligation now lives on the centre's own quantum connection:
  `../2026-08-23-c925-fable-marker-is-levelt-exponent.md`.  Rank-two
  confluence rule proved and the cubic's block/Kuznetsov-Serre dictionary
  made unconditional via Sanda--Shamoto:
  `../2026-08-23-c925-fable-rank-two-confluence-gamma-ii.md`.  MM 2-24
  closed: every smooth member is a \(\mathbf P^1\)-bundle over
  \(\mathbf P^2\) and Iritani--Koto Theorem 5.1 splits its ledger into two
  semisimple \(\mathbf P^2\) summands; the \(b_3=0\) tail residue is now
  the Mori--Mukai enumeration completion plus non-chain non-Fano carriers:
  `../2026-08-23-c925-fable-mm224-projective-bundle-closure.md`.  The
  enumeration is complete: all 59 \(h^{1,2}=0\) Mori--Mukai families are
  ledger-closed with zero escapees, so the Fano \(b_3=0\) tail is fully
  discharged and the sole remaining tail item is non-Fano carriers:
  `../2026-08-23-c925-fable-b3zero-enumeration-closure.md`.  The carrier
  structure theorem then reduces those by smooth MMP to discriminantal
  conic bundles, del Pezzo fibrations of degree \(\le8\), E3--E5-only
  stages, and the \(K\)-nef boundary; both open gates now converge on the
  two fibration classes:
  `../2026-08-23-c925-fable-carrier-mmp-reduction.md`.  Over
  \(\mathbf P^2\) the conic-bundle residue's smooth-discriminant slice is
  exactly the closed MM 2-24 family; the frontier is nodal rational
  discriminants with vanishing abelian Prym:
  `../2026-08-23-c925-fable-conic-bundle-residue-anatomy.md`.  The
  Beauville check then proves \(b_3=2\sum(p_a-1)\), refuting the nodal
  lead: the conic-bundle residue over \(\mathbf P^2\) reduces to
  \(d=3\), and the frontier is elliptic-configuration discriminants:
  `../2026-08-23-c925-fable-conic-bundle-b3-formula.md`.  Corrected: the
  \(d=3\) class also holds non-Fano members; the first explicit one — a
  weak-Fano minimal conic bundle whose \(K\)-trivial \(\mathbf
  P^2\)-section contracts to the E5 germ — is constructed and is the
  queued (GS-carrier) test object:
  `../2026-08-23-c925-fable-weak-fano-conic-bundle.md`.  Correction II:
  that example has split cover (\(=\mathrm{Bl}_E(\mathbf
  P^1\times\mathbf P^2)\), \(b_3=2\)), but the failure yields the
  flagged candidate theorem that markedness is a birational invariant
  of smooth threefolds (rational \(\Rightarrow\) marked-free):
  `../2026-08-23-c925-fable-marked-block-birational-invariance.md`.
  Same-day red-team **withdraws the candidate** (splitting hole on
  \(b_3=0\) members, circular over the open case); what survives is
  curve-anchored transport along arbitrary AKMW chains, and the tail's
  single technical target is now the Stokes-decorated ledger
  (non-semisimple Gamma-II):
  `../2026-08-23-c925-fable-birational-invariance-redteam.md`.  That
  target is now built: the decoration on split pairs is defined
  valuatively over the chain rings (merged-block Levelt class at the
  edge's large-radius specialization, bridged to the analytic \(ss'\) by
  the proved confluence rule, with the open analytic cluster-factor
  problem sidestepped), and one-step Iritani transport is proved in both
  directions modulo one named integrality hypothesis (INT-\(\Psi\)) on
  the base row-block of Iritani's \(\Psi\), proved unconditionally on
  the initial slice by his property (4).  An exact four-leg certificate
  replays the mechanism, with a negative control showing the decoration
  is an integral-model invariant, so (INT-\(\Psi\)) is load-bearing.
  The tail's spine is now: (INT-\(\Psi\)) beyond the initial slice
  (Iritani §5.8 reconstruction recursion), then chain composition:
  `../2026-08-23-c925-fable-stokes-decorated-ledger.md`.
  The 2026-08-24 reconstruction audit shows that the Birkhoff recursion is
  integral only after whole-loop integrality is supplied; Iritani's centre
  extension (5.40) produces positive \(q\)-powers at negative-normal rational
  centres.  The joint \((q,z)\)-calculation is now complete and closes
  universal (INT-\(\Psi\)) false: a codimension-four \(\mathbf P^1\) with
  normal degrees \((-3,-2,-2,-2)\) contributes a nonzero \(q^{+1}\)
  coefficient already in the base-to-base square block at first Novikov
  order.  Arbitrary chain composition
  therefore needs negative-normal factorization control or a replacement
  lattice.  Report:
  `../2026-08-24-c925-int-psi-negative-normal-counterexample.md`.
  Tschinkel--Zhang (arXiv:2608.20029v1) construct
  stably rational smooth cubic threefolds, definitively closing the
  every-smooth all-\(m\) target false. The type-\(I_1\) level-two theorem
  below now also makes the every-smooth \(m=2\) irrationality target false; their
  Section 4 bound implies \(X\times\mathbf P^{11}\) is rational for the
  explicit \(r=0\) cubic by a function-field argument.  Report:
  `../2026-08-24-c925-int-psi-reconstruction-and-stable-rationality-boundary.md`.
  The direct opposite-route optimization is now exhausted as well: the
  type-\(I_1\) Picard lattice admits no stable-permutation identity with
  target rank below eleven (fourteen character candidates, each obstructed
  modulo two or three), so the published eleven is optimal within that
  method but remains no intrinsic lower bound.  Report:
  `../2026-08-24-c925-i1-permutation-resolution-optimality.md`.

- **C924 — closed 2026-08-19.** The direct ordinary-QDM route proves
  irrationality of `X x P^1` after one mandatory local repair: compare the
  intrinsic and asymptotic projective-bundle QDMs through Iritani--Koto's
  common faithful ring `C[q][[Q,t]]`, not through a nonexistent embedding of
  the full `q`-adic completion into the `q^{-1}`-Laurent completion.  Every
  other load-bearing step and primary source passed, the finite cubic algebra
  replayed exactly, and the route compresses further to even rank two,
  nonzero nilpotent, and nonzero modified-residue discriminant.  No manuscript
  or Lean file was edited.  Report:
  [`2026-08-19-c924-direct-qdm-proof-audit.md`](../2026-08-19-c924-direct-qdm-proof-audit.md).
- **C912 — closed 2026-08-18 by author instruction.** Referee-facing
  foundations for the epilogue: all twelve work packages landed, every
  implementation, review, copy-edit, detritus, build, and export gate green.
  The one-stabilization headline is unconditional through the Section 4 atomic
  route; Hypotheses 5.7R and 5.7T carry only the Section 5 framed-monodromy
  refinement. Standalone export is synchronized and unpushed. Card:
  [`c912-cubic-stabilization-referee-foundations.md`](../cubic-threefolds-tasks/c912-cubic-stabilization-referee-foundations.md).
- **C913 — referee revision pass on the all-`m` paper, active, author-close
  only.** Manuscript `papers/cubic-stabilization-irrationality/`, conditional on
  the marked-threshold wall and zero-mode hypotheses. Local frame/source repairs,
  modular hypothesis presentation and expanded proofs before the next frozen
  cold-read cycle; card:
  [`c913-cubic-stabilization-fable-revisions.md`](../cubic-threefolds-tasks/c913-cubic-stabilization-fable-revisions.md).
- **C907 — quantum monodromy stabilization, active.** v1 is unconditional:
  framed formal monodromy of the numerical small quantum connection, followed
  through Iritani's blow-up comparison, proves `X x P^1` irrational for every
  smooth cubic threefold (`papers/cubic-stabilization-m1/`, Silver
  tier). Gold (`m=2`) is reduced to a minimal nilpotent `K[N]` packet on the
  whole generalized `zeta_6` sector: endpoint `J_3`, strict blowup
  biproducts, and no center `J_3` imply irrationality; a `J_3` requires
  `nu_6>=6`, and the two-block strictness obstruction is one explicit
  `Ext^1_(K[N])` class. One exact localizing, Orlov-additive,
  `K_0`-linear/derived-Gysin `Phi_6` packet functor vanishing on all
  low-dimensional supports would kill every base-ideal extension and prove
  `m=2` by relative factorization; a formal-space projector is too weak, and
  linear projection shows raw `K_0` can already create `J_3`. Higher
  codimension needs a non-split exceptional string, so this Gold mechanism
  does not naively extend to Platinum (`m` arbitrary), which remains open.
  No Paper V or Lean promotion follows automatically. Card:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md`; solver dossier:
  `../cubic-threefolds-tasks/c907-solver-dossier.md`; closed-phase archive:
  `../cubic-threefolds-tasks/c907-quantum-monodromy-stabilization-archive.md`.
- **C908 — Annals-upgrade mathematics, active.** Retains the highest-ceiling
  mathematics left by C904/Paper V after the fibrewise minimal-class theorem
  and the one-stabilization epilogue: priority A is the intrinsic relative
  Chow index of the generic unordered-theta fibre (`ind(Y)=1` vs `2`);
  priority B is the intrinsic `p`-typical divisor-product classification.
  Its integral lattice theorem for `H^3(Bl_0Θ,Z)` (torsion-free rank
  130, escape group free of rank ten, correcting a prior `(Z/2)^10`
  misidentification) and the resulting standalone paper were split to C928
  by author instruction on 2026-08-20. The priority-A `(1,5)` Chow-index channel is closed negative for
  every named source; priority A itself remains undecided. Card:
  `../cubic-threefolds-tasks/c908-annals-math-upgrades.md`.
- **C909 — cycle-side crown, active.** Extracts intrinsic cofactor-saturation
  and atom-carrier theorems from the epilogue; C907 retains higher-stabilization
  quantum work and C908 retains relative Chow / full `p`-typical
  classification. Full ordinary cohomological saturation of the prescribed
  graph divisor lattice is proved intrinsically; the actual six-axis
  four-slot quotient audit is now positive (unit line plus depth-one
  rank-four block, Pluecker defect vanishes), passing two independent
  hostile/priority audits. The higher-rank Dyck-height Smith formula is a
  successor crown, not a gate on this one. Card:
  `../cubic-threefolds-tasks/c909-epilogue-math-level-ups.md`.
- **C910 — Lean companion for the epilogue, active.** Formalizes the
  cubic-stabilization epilogue in the Mathlib-only package
  [`papers/cubic-stabilization-m1/`](../../papers/cubic-stabilization-m1/),
  under the C879 paper-facing
  namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationM1`, with
  reviewer entry point `PaperInterface` and machine audit
  `Verification/AxiomAudit`. The entry point is now a thin aggregator over
  semantic facades for the five proof-bearing manuscript sections, a
  declaration-free synthesis facade, and three semantic machinery facades
  containing the 83 unclaimed terminals; all 311 fully qualified terminal
  names are unchanged. The current
  main proof spine is the effective
  categorical block ledger and occurrence-indexed weak-factorization descent:
  the direct rank-two residue theorem and the finer primitive-sixth framed
  theorem are literal specializations of the same generic theorem, and their
  strict `m = 1` cubic contradictions are now the reviewer-facing headline
  terminals. QDM block construction, comparison, factorization, and geometric
  nullity remain explicit premises; Gamma-row and all-`m` work are untouched.
  A 2026-08-21 red-team repair narrows the atomic fold from nonzero residue
  discriminant to distinct formal exponent classes modulo the integers, makes
  the even carrier explicit, and closes the spectral-splitting,
  summand-separation, coefficient-ring, and grading-suspension interfaces.
  The current checked snapshot is 54 claims, 4 absent, 23 fragmentary, 26
  conditional, 1 complete, and 316 reviewer terminals, of which 83 are
  machinery. A fresh isolated cold read found no process debris, retained the
  concise theorem-first abstract, and made the formal-exponent terminology
  consistent throughout. Earlier checkpoints below record the superseded atom-route
  assembly history. No duplicate under the shared
  `lean/TavisRuddFiniteGeom/` tree or a second Lean repository. The sources
  build through the guarded queue; `make check` and the axiom-log gate are green
  at the current snapshot. `thm:every-cubic` is
  anchored to the atomic route, the framed spine answers to its own manuscript
  theorem `thm:every-cubic-conditional` and is now assembled end to end on the
  product-formula signature, the small even block reduction is formalized from
  Cai's connection matrices through the modified residue, both six-point hearts
  and both product-formula corollaries have terminals, and the rank-two residue
  rigidity algebra of the atomic route is kernel checked, together with block
  diagonality of a pairing on separated spectral factors, the order comparison
  that selects the exotic gluing, and the order-by-order derivation of both
  pairing systems from horizontality, which closes the link from `lem:horiz`
  through `lem:orthogonal` to `lem:A0preserve`. The unconditional half of
  `cor:v14-one-step` is also proved: the genus-eight flop makes the two
  stabilizations birational and irrationality transports back from the cubic.
  The curve and surface exclusions are proved from premises matching the
  manuscript's citations rather than from two bundled implications. `lem:disc`
  and `lem:spectrum-transfer` are now conditional deductions: the four
  logarithmic derivatives of the quartic discriminant follow from the
  coefficient identities alone, those identities are exhibited in the universal
  root model, the vanishing half is proved in a formal power-series model of the
  germ, and the eigenvalue sets on the even algebra and on the full module
  coincide. `lem:orthogonal` is also a conditional deduction now: block
  diagonality holds for an arbitrary labelled splitting whose connection is
  block diagonal, a nondegenerate pairing stays nondegenerate on any set of
  coordinates orthogonal to its complement, which covers one factor and the even
  part of a factor, and equal leading eigenvalues admit a horizontal nonzero
  pairing. The residue discriminant is also proved invariant under conjugation,
  under a block-diagonal change of frame on one factor, and constant over a
  formal germ whose residue derivatives are commutators, which makes
  `prop:atom-invariant`, `lem:factor-glue`, and `lem:crossing` fragments. The
  three geometric rows `lem:euler-sign`, `lem:hodge-base`, and `prop:cubic-atom`
  are fragments as well, so every row of the unconditional atomic route carries
  at least a fragment. The manuscript now carries gated provenance annotations
  (`\coverage`, `\lean`, `\uses`, `\imports`, `\evidence`, `\proves`) resolved
  against the claim map, two registries, and per-row statement and terminal
  digests, with the dependency edges of the atomic route recorded and the
  annotated graph emitted and gated. Every claim-map row has now been reviewed
  against its statement and its terminals, which completes the adoption order of
  the annotation conventions; the review left the coverage labels unchanged and
  corrected nine recorded descriptions. The two clauses of
  `lem:six-axis-local-chart` that carried neither a terminal nor a fragment are
  now covered: the depth-one lift of a residue endomorphism to a self-adjoint
  integral one, and triviality of the principal quotient on the unimodular
  summand, the latter both in the chart, whose decomposition is now proved as a
  change of basis, and over the integers through the Smith reduction. The
  Section 5 framed-germ rows are covered as well: formal-germ rigidity of an
  isolated rank-two cluster and the multiplicity-one Euler block are fragments,
  formal-germ persistence of the cubic packet and the projective-space product
  formula are conditional deductions. Direct specialized low-dimensional
  vanishing is a conditional deduction as well: a weight-raising residue is
  nilpotent, the exponential of a nilpotent matrix is unipotent, a parity factor
  of square one leaves only characteristic roots of square one, and separability
  of the specialized quantum relation of a projective space makes every Euler
  block simple. The five absent rows left are the four separation corollaries and
  `lem:exact-low-degree-shifts`; neither cluster is a composition of formalized
  algebra.
  The rank-two step of the atomic route is now derived from a formal model of
  the connection rather than assumed: flatness and pairing horizontality are
  single power-series identities, the elementary modification is constructed as
  a gauge identity without inverses, flatness passes to the modified lattice,
  and the commutant computation, the vanishing of the residual base pole, the
  Lax equation, and constancy of the residue discriminant follow, over a formal
  germ as well; those terminals are registered, and the rank-two rigidity row is
  now a conditional deduction.  The normalized Sylvester gauge shared by the
  cubic block reduction and the spectral-factor gluing is formalized over a
  coefficient ring: the Sylvester operator of two separated leading operators is
  invertible, the block equation has exactly one block off-diagonal solution, a
  normalized block-off-diagonal gauge reducing a block-separated system exists
  and is unique, and for the separated small even cubic system the exhibited
  gauge and reduced coefficients are the first two coefficients of that unique
  gauge.
  The six-axis local chart now feeds the all-degree graph saturation theorem
  directly: the depth decomposition, the split coordinates, and the depth,
  scalar, and slope-error families are constructed from the chart instead of
  supplied, and the eigenblocks of a self-adjoint depth-one slope are proved
  orthogonal.  At three those data come from the slope itself; at two the
  exotic slope is proved to have no model over an ordered coefficient ring.
  The separated-variable clause of the separation theorem is also formalized,
  so the manuscript names the Fermat point instead of saying all but finitely
  many.
  The discriminant group of the source polarization is now built as well, with
  its `Q/Z`-valued pairing, order `6^8`, and maximal isotropy of the order-`6^4`
  kernel subgroup of any comparison matrix satisfying the pullback identity.
  The per-prime form is proved too: the explicit cofactor `I5+J5` makes six
  annihilate the group, so it splits as `D_2 + D_3` with orthogonal, separately
  nondegenerate parts, the kernel splits the same way, and each `K_p` is a
  relative maximal isotropic subgroup of `D_p`. The two models of the
  two-primary discriminant are also identified: reduction modulo two of the
  cofactor image carries the two-torsion part of the cokernel isomorphically
  onto the kernel of the polarization reduced modulo two, hence onto four
  copies of the rank-two two-torsion module, and that identification carries the
  discriminant pairing to the normalized two-primary form, which is in turn
  isometric to the rank-eight tensor form in the standard coordinates. So the
  two-primary kernel, carried into those coordinates, is proved maximal
  isotropic and belongs to the five-member projective-line packet as soon as
  diagonal stability is granted. The same chain now runs at three: the
  reduction modulo three of the cofactor image identifies the three-primary
  part with the kernel of the polarization reduced modulo three, carries the
  discriminant pairing to minus the dot product tensored with the reduced
  elliptic pairing, and is an isometry onto the two-copy polarization form of
  the three-primary heart, where the transported kernel is maximal isotropic
  and therefore four-dimensional, hence the vertical copy or one of the three
  scalar graphs once diagonal stability is granted. The orders `2^8` and `3^8`
  of the primary parts of the discriminant group follow from those two
  comparisons. Stability is no longer an input at either prime: the six-label
  permutation group is represented on the source lattice by explicit integral
  matrices preserving the polarization, its contragredient descends to the
  discriminant group, and for a comparison matrix equivariant for the two
  displayed generators both transported primary kernels are diagonally stable
  and therefore unconditionally in their packets. Which member the two-primary
  kernel is cannot be settled that way, since every packet member is stable; the
  selecting input is now formalized as Frobenius marking. Frobenius of the
  labelling field transported to the packet is an involution fixing exactly the
  three members defined over the prime field and exchanging the two exotic
  graphs, so a marked member is exotic and its graph slope has minimal
  polynomial `t^2+t+1`, which is the slope datum the local-chart lemma states at
  two; one marked fibre over a connected base makes every fibre exotic. That
  involution is now identified with the labels themselves: scaling by a
  non-square scalar is an odd permutation of the six labels whose diagonal heart
  action is exactly the transported involution, the packet action of the group
  generated by the three displayed label permutations factors through the sign
  character, and the three prime-field members are fixed by every invertible
  diagonal action, so marking is being moved by an odd label permutation and no
  group-invariance hypothesis can replace it. The label group is now determined
  exactly: a label permutation preserves the packet precisely when conjugation
  by its heart matrix fixes the commutant root or moves it to its conjugate, the
  permutations centralizing that root form a group of order sixty which is the
  alternating image itself, and the packet-preserving permutations therefore form
  a group of order one hundred twenty that is generated by the three displayed
  permutations and equals the full normalizer of the alternating image. The
  orders `2^4` and `3^4` of the primary parts of the kernel are proved as well,
  from the splitting and Lagrange's theorem alone. What remains supplied is the
  identification of that matrix-level equivariance with equivariance of an
  actual relative isogeny, the marking of the actual geometric kernel, the
  identification of the six labels with the manuscript's dihedral axes, and the
  geometric commutator pairing.
  The fifteen nonzero heart vectors are now identified with the fifteen pairs of
  labels, the displayed one-factorization is proved to be the orbit decomposition
  of multiplication by the quadratic root `W`, and preserving that
  one-factorization is proved equal to the packet-preserving condition, with
  centralizing `W` its index-two even part.
  Card:
  `../cubic-threefolds-tasks/c910-cubic-stabilization-lean-companion.md`; gap audit
  `../2026-08-18-c910-post-restructure-gap-audit.md`; anchor report
  `../2026-08-18-c910-atom-route-anchor.md`; block-reduction report
  `../2026-08-18-c910-block-reduction.md`; hearts and product-corollary report
  `../2026-08-18-c910-hearts-and-product-corollaries.md`; framed-route and
  rank-two rigidity report
  `../2026-08-18-c910-framed-route-and-rank-two-rigidity.md`; highest-risk-items
  report `../2026-08-18-c910-highest-risk-items.md`; pairing-horizontality
  report `../2026-08-18-c910-pairing-horizontality.md`; even-part
  orthogonality report `../2026-08-18-c910-even-part-orthogonality.md`;
  residue-discriminant invariance report
  `../2026-08-18-c910-residue-discriminant-invariance.md`; geometric-rows report
  `../2026-08-18-c910-geometric-rows-of-the-atomic-route.md`; annotation-layer
  report `../2026-08-18-c910-manuscript-formal-annotations.md`; claim-map reviews
  `../2026-08-18-c910-claim-map-review.md` and
  `../2026-08-18-c910-cycle-side-and-absent-rows-review.md`; local-chart lift and
  unit-summand report
  `../2026-08-18-c910-local-chart-lift-and-unit-summand.md`; framed-germ rows
  report `../2026-08-18-c910-framed-germ-rows.md`; direct specialized
  low-dimensional vanishing report
  `../2026-08-18-c910-direct-specialized-lowdim.md`;
  genus-eight
  unconditional report `../2026-08-18-c910-genus-eight-unconditional.md`;
  low-dimensional exclusions report
  `../2026-08-18-c910-low-dimensional-exclusions.md`; discriminant and
  spectrum-transfer report
  `../2026-08-18-c910-discriminant-and-spectrum-transfer.md`; separation and
  absent-rows report `../2026-08-19-c910-separation-and-absent-rows.md`;
  chart split-presentation report
  `../2026-08-19-c910-six-axis-chart-split-presentation.md`;
  source-discriminant-group report
  `../2026-08-19-c910-source-discriminant-group.md`;
  primary-splitting report
  `../2026-08-19-c910-primary-discriminant-splitting.md`;
  two-primary lattice-model report
  `../2026-08-19-c910-two-primary-lattice-model.md`;
  two-primary pairing report
  `../2026-08-19-c910-two-primary-pairing.md`;
  two-primary standard-coordinate report
  `../2026-08-19-c910-two-primary-standard-coordinates.md`;
  three-primary analogue report
  `../2026-08-19-c910-three-primary-analogue.md`;
  six-label action and kernel-stability report
  `../2026-08-20-c910-six-label-action-and-kernel-stability.md`;
  marked-Frobenius selection report
  `../2026-08-20-c910-marked-frobenius-exotic-selection.md`;
  packet label-group and kernel-order report
  `../2026-08-20-c910-packet-label-group-and-kernel-orders.md`;
  unconditional QDM referee repair
  `../2026-08-21-c910-unconditional-qdm-referee-repair.md`;
  duad/one-factorization dictionary report
  `../2026-08-20-c910-duad-one-factorization-dictionary.md`;
  odd-label realization report
  `../2026-08-20-c910-odd-label-frobenius-realization.md`;
  interim release report
  `../2026-08-12-c910-partial-lean-release.md`.
- **C928 — closed 2026-08-20.** The integral middle lattice of the
  cubic-threefold theta divisor is now a self-contained warning-free
  eight-page paper.  Pair occupancy and complete-graph incidence replace the
  saturation certificate; the universal line and a Pontryagin endpoint formula
  replace the glue certificate; `IH^3(Theta,Z)` is free of rank 130 with the
  canonical mod-two fibre-product glue; and the dual escape lattice is free of
  rank ten with exceptional image `2E`.  Kraemer's rational decomposition is
  credited as prior art, the modern integral-Lefschetz boundary is explicit,
  and C908 retains its Chow-index and `p`-typical crowns.  Card:
  `../cubic-threefolds-tasks/c928-blown-up-theta-lattice-paper.md`; report:
  `../2026-08-20-c928-closeout.md`; paper:
  `../../papers/blown-up-theta-lattice/`.
- **C920 — closed 2026-08-18.** Hypothesis 5.7T of the epilogue is now used only
  for surface centers that are neither minimal nor geometrically ruled: the
  specialized primitive-sixth count vanishes for every Hirzebruch surface, by one
  deformation to index at most one, the rank-four Euler quartic and its
  discriminant, and a non-collision argument for the center specializations; the
  quadric surface goes through the Gromov--Witten product formula instead, which
  needs no relation between its two specialized values. The residual use of 5.7T
  is a single named obstruction, a support or base-change statement for the
  blowup comparison after external specialization. Card:
  `../cubic-threefolds-tasks/c920-minimal-ruled-tagging-removal.md`; report
  `../2026-08-18-c920-minimal-ruled-tagging-removal.md`. Not yet exported to the
  standalone repository.

- **C914 — both comparisons decided, restatement applied 2026-08-19.** The
  pencil contains the Fermat cubic threefold. All but finitely many of its
  members lie outside the Yang--Yu--Zhu coprime-degree locus: every member of
  their normal form carries an Eckardt point, and the generic pencil member
  carries none. Voisin's criterion is unreachable by any elliptic-product
  route: with the exotic two-primary gluing kernel, the only odd-degree product
  factorization of the intermediate Jacobian is `1 + 4`, realized at odd index
  `25`, so the pencil is not known to lie in a Voisin component. The restatement
  is in the manuscript and its registries, through four cold-read rounds. Card:
  `../cubic-threefolds-tasks/c914-a5-pencil-vs-coprime-degree-locus.md`;
  report `../2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`; round-four reads
  `../2026-08-19-c914-round-four-mathematics.md` and
  `../2026-08-19-c914-round-four-consistency.md`.
- **C921 — residual Voisin gate, active; genus-four branch closed negative
  2026-08-19.** For all but finitely many members the four-dimensional factor
  `A_b` is not a genus-four Jacobian. What is left is the genus-five route, and
  only through an isogeny of degree greater than one. The integral glued model
  of the four-dimensional factor is derived and the Schottky count evaluated;
  that pass also corrects C914's description of the factor, which is of
  symplectic type `(1,1,1,5)` rather than principally polarized. That pass also
  located the pencil's Eckardt locus at the two Fermat members and its singular
  locus at six members, by elimination over `Q`; C923 has since reproved the
  Eckardt half structurally, so the epilogue's separation theorem keeps a
  qualifier but can name the single exceptional moduli point instead of saying
  "all but finitely many". Card:
  `../cubic-threefolds-tasks/c921-four-dimensional-factor-jacobian.md`; reports
  and evidence bundles `../2026-08-19-c921-genus-four-branch.md`,
  `../2026-08-19-c921-integral-glued-model.md` and
  `../2026-08-19-c921-pencil-level-structure-and-eckardt.md`.
- **C923 — closed 2026-08-19.** The pencil's Eckardt locus is now proved from
  complex reflection groups rather than from the elimination, and
  `prop:A5-not-coprime` is sharper for it: exactly two members, interchanged by
  the normalizer of `A_5`, each with exactly thirty Eckardt points, both the
  Fermat cubic threefold. The manuscript's only remaining premise-level
  computation is `lem:hirzebruch-euler-spectrum`. Naming the Fermat point in
  `thm:separation-family` is no longer blocked by any computation; the
  remaining gate is C910 sharpening
  `Applications.SeparationFamilyConclusion`, without which that row would drop
  to a fragment. Card:
  `../cubic-threefolds-tasks/c923-eckardt-locus-structural-proof.md`; report
  `../2026-08-19-c923-eckardt-locus-structural-proof.md`.
- **C917 — closed 2026-08-18.** The epilogue introduction now says why the
  direct Clemens--Griffiths mechanism gives no contradiction after one
  stabilization and where the result sits relative to Guéré
  (arXiv:2603.04518v1) and Benedetti--Fay--Guéré--Manivel--Perrin
  (arXiv:2607.26718v1), whose criterion assumes `b_3 = 0` and so does not
  reach `X x P^1`. Theorems and proofs unchanged; standalone repository
  synchronized and verified. Card:
  `../cubic-threefolds-tasks/c917-epilogue-hodge-and-guere-positioning.md`;
  report `../2026-08-18-c917-hodge-guere-positioning.md`.
- **C911 — closed.** Discrepancy-one flip correction, published as a
  standalone ten-page note (`papers/discrepancy-one-flips/`), DOI
  `10.5281/zenodo.21924799`. Independent cold read passed; authority and
  clean standalone gates pass; portfolio summary synchronized. Card:
  `../cubic-threefolds-tasks/c911-shen-shoemaker-flip-repair-note.md`.

No C907, C908, C909, C914, or C921 promotion into any manuscript, PDF,
mirror, or Lean source follows automatically from any of the above.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Cubic-stabilization epilogue: `X x P^1` irrational, the `m = 1` statement | `papers/cubic-stabilization-m1/` | headline unconditional through the Section 4 atomic route since 2026-08-16; Hypothesis 5.7R and, since C920, Hypothesis 5.7T only for surface centers that are neither minimal nor geometrically ruled carry the Section 5 framed refinement stated as `thm:every-cubic-conditional`; Lean anchored to the atomic route, further coverage open under C910; the standalone export is synchronized and verified at `0387c21` | C907, C909, C910, C913 (C912 closed) |
| Discrepancy-one flip correction | `papers/discrepancy-one-flips/` | published standalone note, DOI `10.5281/zenodo.21924799` | C911 (closed) |
| *Irrationality of Cubic Threefolds after One Stabilization*: `X x P^m` for all `m`, the all-`m` statement | `papers/cubic-stabilization-irrationality/` | headline conditional on the marked-threshold wall and zero-mode hypotheses | C913 |

## Lane boundaries

This lane owns the cubic-threefold research program above, its task cards
under `notes/cubic-threefolds-tasks/`, and — since 2026-08-15 —
both stabilization manuscripts: `papers/cubic-stabilization-m1/` under
C907, C909 and C910, and `papers/cubic-stabilization-irrationality/`
under C913. It does not
own the numbered Clebsch series (Papers I–V) or any other `clebsch`-lane
surface — those remain foreign until an owning task here explicitly admits
them, per the usual cross-lane hygiene rule.

The companion discovery log is
`notes/2026-08-15-cubic-threefolds-discovery-track.md`. Logging an
observation neither allocates work nor adds it to a paper.

## Working and historical indexes

- Live task detail: `notes/cubic-threefolds-tasks/`.
- Prior lane history (pre-2026-08-15, while this program lived under
  `clebsch`): `notes/handoffs/2026-07-13-clebsch-lane.md` and its archive
  `notes/handoffs/done/2026-07-13-clebsch-lane-archive.md`.
