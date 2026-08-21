# C937 — Equivariant paper layered-exposition revision

**Lane:** `paper-frob-eq`
**State:** complete
**Canonical manuscript:** `papers/equivariant-robust-completion/frobenius_pair_extension.tex`

**Hard constraint:** no large Q25 certificate rebuilds. Scoped Lean development and validation are
allowed, but do not regenerate or force re-elaboration of the residual transport, dispatch,
class-link, composition, or exhaustion forests. C937 itself remains a manuscript-revision task and
may rebuild the LaTeX manuscript PDF.

## Objective

Turn the mathematically complete manuscript into one visibly unified, submission-shaped paper. The
revision follows `papers/style-guide.md`, especially its opening sequence, two-track architecture,
and separation of mathematical mechanism from verification detail. It changes exposition and
presentation, not the proved theorem package.

## Revision spine

1. Make the causal line explicit: quadratic Frobenius gives fixed mate-line carriers; empty-carrier
   counting gives the uniform criterion; invisible centers and collisions give the exact
   correction; the general envelope gives robust repair; the Q25 certificate closes the exceptional
   base order and classifies equality.
2. Give the criterion, exact Q25 result, and robust-repair consequence clear primacy. Keep the
   parameterized exchange theorem as the natural general form. Subordinate the Clebsch
   specialization, saturation bound, and profile arithmetic as corollaries or supporting layers.
3. Add one concise MDS-code translation near the principal result: arcs correspond to
   dimension-three MDS generator columns, conjugate-pair extension is a paired two-column MDS
   extension, and alternate-orbit repair is paired column replacement. Do not recast the paper as a
   storage-repair paper or compete with `complete-ports`.
4. Synchronize the abstract, introduction, theorem statements, section openings, and conclusion.
   In particular, replace the stale conclusion's “two legal pairs / one alternative” summary by the
   proved uniform Q25 multiplicity of four legal pairs and three alternate repairs.
5. Present the trust boundary once at the right level: human proof, classical input, kernel-checked
   theorem, generated certificate layer, and reproducible computation. Do not decide C318's manifest
   inventory or C319's canonicalizer/demotion question inside this task.

D-AOR8 is not part of C937. A separately bounded scout may seek a direct geometric proof of the
coupling inequality `B+R≥66`, which would conceptually explain the Q25 minimum `32` using the
committed census and mask evidence. A resulting small theorem may be formalized in an isolated
downstream module if its scoped validation does not rebuild the large certificate forests. The full
`32`–`47` spectrum, semantic surjectivity away from the minimum, and certificate-tree regeneration
remain outside this manuscript-revision task.

## Acceptance gates

- A theorem-and-section-opening read exposes one coherent story and the main result by page 1 or 2.
- A first-pass adjacent reader can follow every language change and identify the exceptional finite
  step without reading the certificate inventory.
- The Clebsch, saturation, and profile consequences no longer compete rhetorically with the main
  theorem spine.
- Every numerical and qualitative Q25 summary agrees with the theorem statements, including
  `32`, the five equality orbits up to normalization, four uniform legal pairs, and three uniform
  alternate repairs.
- No hypothesis, quantifier, normalization scope, citation boundary, or formal-coverage claim is
  strengthened accidentally.
- The README and manuscript agree on status and headline claims; the final source builds cleanly,
  references resolve, and the checked-in PDF is regenerated from the revised source.
- The scoped diff, build result, page/floating-object inspection, and remaining C318/C319 boundary
  are recorded here before C937 is reported.

## Result

The manuscript now has one visible causal spine:

```text
fixed mate-line carriers
→ empty-carrier count
→ invisible-center/collision correction
→ general robust repair
→ one exceptional Q25 certificate and equality classification.
```

The abstract leads with that mechanism and then states the Q25 and general repair payoffs in their
logical order. The introduction gives the arc--MDS translation once, distinguishes paired column
replacement from erasure decoding in a fixed code, and states the exact main theorem on page 2.
The theorem separates uniform Q25 multiplicity, the exact normalized two-fixed-point minimum, and
the `s≥7` envelope without broadening any hypothesis.

The Q25 section now has explicit structural and exceptional tracks. Its computer-assisted proof
states the load-bearing reduction `L=B+R-34` and target `B+R≥66`, without claiming the conceptual
coupling that C938 failed to find. The saturation result is marked secondary inside a section led by
the profile envelope and parameterized exchange theorem. The formal-verification section identifies
its own role as an evidence map rather than a second proof narrative.

The conclusion now agrees with the theorem package: four legal pairs and three alternate repairs
uniformly over Q25; exact minimum `32` and five equality orbits up to normalization in the
two-fixed-point profile; `319/318` for `s≥7`; and the parameterized phase thereafter. It begins on a
fresh page so the verification inventory is not the paper's final mathematical impression.

The README was synchronized, including repaired mathematical markup, the normalization scope, the
finite-geometry/coding-theory boundary, and the subordinate status of the Clebsch specialization.
No Lean source, generated certificate, Q25 data tree, or formal build was touched.

## Validation

From `papers/equivariant-robust-completion/`:

```sh
nix shell nixpkgs#tectonic -c tectonic \
  frobenius_pair_extension.tex --keep-logs
```

The build is warning-free: no undefined references, overfull or underfull boxes, or rerun request.
The PDF has 14 A4 pages. Rendered pages 1--3, 5--6, and 10--13 were inspected at publication scale:
the main theorem fits cleanly on page 2; the Q25 table is legible; the structural/exceptional and
general-repair headings are correctly placed; the formal theorem map fits; and the conclusion starts
at the top of page 13. The theorem/section-opening pass and an internal adjacent-audience pass both
recover the intended spine and trust boundary. No independent cold reader was commissioned inside
this edit-only task.

| Artifact | SHA-256 | Bytes |
|---|---|---:|
| `frobenius_pair_extension.tex` | `fd68ca40c5d24de5b5064c14a8335a30c5e2debab1be5e52d5958cbf5ef6050e` | 41,006 |
| `frobenius_pair_extension.pdf` | `166dc765f36467aeb26b8d6a277e34980d32bc504c2231ecf4d50b6cf1aa2784` | 120,383 |

The scoped manuscript change is commit `8c633fc29`.

## EJ + TT closeout

The cheap additional gain was to make the coding connection exact without changing the paper's
home: a `k`-arc is presented as the projective column set of a `[k,3,k-2]` MDS code, while the prose
explicitly separates paired column replacement from fixed-code erasure repair. This makes the
relationship to `complete-ports` legible without merging their theorem stories.

The Tao-style test asks whether every displayed layer earns its place in the causal proof. The
Clebsch count, saturation scale, and profile arithmetic survive only as consequences; none defines
the headline. The exact Q25 classification remains because it closes the sole exceptional profile,
not because its census is independently interesting. C938's negative result prevents the paper
from advertising a nonexistent conceptual proof of `32`. No further cheap hierarchy change survives
the rendered-page check.

## Mystery ledger

| Feature | Status | Exact remaining gap or owner |
|---|---|---|
| Conceptual source of `B+R≥66` in the exceptional Q25 profile | open but no longer an exposition blocker | C938 found no compact invariant proof; the exact residual certificate remains load bearing. |
| Surviving Q25 trust-manifest surface | open release gate | C318 must inventory the surviving residual/data layers and reconcile C151 references to payload removed by `6da475113`. |
| Literal class links versus a canonicalizer or mixed-verification demotion | open release decision | C319 owns the decision; C937 does not prejudge it. |
| Final audited source checkpoint, identifiers, and public export | author/release boundary | Record only after C318/C319 and final submission choices. |
| Manuscript hierarchy and Q25 numerical consistency | settled by C937 | No genuine mystery remains in the exposition structure itself. |
