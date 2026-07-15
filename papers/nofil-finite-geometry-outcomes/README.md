# Paper: Nofil/cap outcome classes on finite geometries

**Working title:** *Achievement games in the Nofil genus — outcome classes of cap/Nofil
games on finite geometries* (pairing/mirror method).

**Status:** Partial draft. The manuscript (`paper-sumfree-capgame/main.tex`, every paragraph
flagged `DRAFT — SUBJECT TO LEAD-AUTHOR REVISION`) currently covers the sum-free game on ℤₙ
and the cap game on AG(n,q); it still treats the **projective** case as open. But the
projective mirror-outcome theorems are already proven in Lean and only need writing up.

**Open packaging decision — fold vs split:** does the projective mirror-outcomes material
become a section of this flagship (finishing what `main.tex` started, per the master plan),
or split into its own companion paper (the Fable-review "Paper 2" framing)? Recorded in
`../papers-planning.md`; this is the main question for the Fable review. The evidence-tagged D1
manuscript skeleton (listed below) is the ready draft asset for either path.

**Technique:** fixed-point-free collineation ⇒ P (the mirror⇒P spine). Split by technique
from the `dihedral-schreier-node-kayles` catalogue.

## Files here (symlinks into ../../notes/)

- `paper-sumfree-capgame/` — **the manuscript** (`main.tex`, `refs.bib`, `kernels/`)
- `2026-07-09-d1-outcome-classes-manuscript.md`, `2026-07-09-codex-d1-manuscript-skeleton.md` —
  **the projective-section draft asset**: an evidence-tagged skeleton (Lean theorem quotes,
  per-q evidence table) ready for writing up the projective outcomes
- `2026-07-07-relatedwork-o4.md` — related-work / bibliography pulls
- `2026-07-08-projective-mirror-proof-kernels.md` — prose proofs, projective geometries
- `2026-07-07-nofil-connection.md` — the Nofil/Node-Kayles framing + novelty section
- `2026-07-07-kernel-nofil-corollaries.md`, `2026-07-07-kernel-affine-cap.md`,
  `2026-07-07-kernel-conic-localization.md` — proof kernels
- `2026-07-05-qeven-plane-theorem.md` — PG(2,q) even-q result
- `2026-07-09-mirror-unification.md` — the mirror engine + capacity-2-only sharpness axis
- `2026-07-09-mirror-method-boundary.md` — the sharpness dichotomy (method-negatives)
- `2026-07-08-codex-projective-nofil-novelty-audit.md` — novelty guards / prior-art overlaps
- `2026-07-06-escape-count-lemma.md`, `2026-07-07-conic-localization-onconic-escape.md` —
  the **open odd-plane kernel** (frontier/open-problems material, not a finished result)
- [`../../notes/2026-07-15-c189-q5-octahedral-frame.md`](../../notes/2026-07-15-c189-q5-octahedral-frame.md)
  — queued cross-paper bridge from the Clebsch `U(A)=C(F_q)`, `4 <= |A| <= 7`, classification:
  certify the expected octahedral `q=5` seeded residual and compare it with the proved icosahedral
  `q=11` seed. This is not yet a manuscript theorem, does not exclude proper conic-contained
  extension loci, and does not change the odd-plane conjecture or `(ON)`.
  The q=11 Clebsch seed, associated conic, and complete-exterior geometry are classical
  (Dye; Blokhuis--Seress--Wilbrink); `arcs` supplies the exact uncovered-locus/coding certificate,
  while this paper claims only the residual-game interpretation.

## Elsewhere (not symlinked)

- **Lean:** each positive geometry is formalized with no `sorry` — general mirror⇒P in
  `lean/ProjectiveCap/Mirror.lean`; per-geometry in `lean/ProjectiveCap/{Binary,EllipticMirror,
  HyperbolicQuadricMirror,PlaneOutcome}.lean` and `lean/CapGame/Affine.lean`.

## Loose ends

- **Sharpness:** the elliptic Q⁻ method-negative needs a Scharlau/Witt-transfer lemma to be
  airtight (parabolic + Hermitian negatives are already rigorous).
- **Novelty admin:** verify the Clark–Mancini–Van Hook full text before hardening any "first"
  language; HHS's STS(7)=PG(2,2) / STS(9)=AG(2,3) instances are prior art.
- **Polyhedral seeded positions (C189):** check all fifteen pairs of the six `PG(2,5)` frame
  continuations, prove the conflict graph is `K6-M3`, transport its antipodal-copycat P-value
  through the sealing bridge, and decide whether the octahedral/icosahedral pair belongs in this
  paper or only its outlook.

See `../papers-index.md` for the registry and `../papers-planning.md` for cross-paper strategy.
