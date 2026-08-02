# C826: Integrated Golden exchange-landscape paper

**Date:** 2026-08-02

**Lane:** `golden`

**Verdict:** adopt the integrated theorem-first manuscript

## Result

The strongest single-paper package is now the authoritative Golden
quantum-statistics manuscript.  Its central chain is

\[
\text{port-gauge observables}
\longrightarrow \text{continuous real control}
\longrightarrow \text{Hermitian holonomy/Pareto geometry}
\longrightarrow \text{squared-spectrum rigidity and stability}.
\]

This replaces a Boolean-endpoint and implementation-heavy center by one
mathematical narrative.  The operational section remains long enough to show
how the determinant sign, bosonic sector, and antisymmetric sector are read,
but the netlist table, detailed shot allocation, and detailed fidelity budgets
no longer compete with the theorem spine.

## Adopted theorem package

1. **Observable hierarchy.**  Singular values classify the unframed
   left--right orbit, the determinant sign is the minimal real orientation
   carrier, and the permanent requires calibrated port frames.
2. **Continuous Golden control.**  Over the full cube
   \(x\in[-1,1]^6\), the manuscript gives the joint exact degree-three bounds
   \(e_3\le16/125\), \(h_3\le313/125\), and
   \(s_{(2,1)}\le8/5\), with equality exactly at the twenty balanced Boolean
   controls.  The proof is a cube reduction by separate convexity followed by
   exact endpoint structure, not a floating-point search.
3. **Hermitian mixed plane.**  For balanced cuts, triangle holonomy supplies
   one coordinate \(t=r_T^2\in[0,1]\).  The three exchange observables are
   affine in that coordinate:

   \[
   (h_3,s_{(2,1)},e_3)
   =\frac1{125}(317-4t,\,196+4t,\,20-4t).
   \]

   This is the exact componentwise-maximal Pareto segment.  It closes the
   mixed-plane ceiling structurally: there is no hidden two-dimensional
   frontier after the conference equations and balanced-cut constraint are
   imposed.
4. **Squared-spectrum rigidity.**  Uniformity of any one of the three
   sign-blind balanced exchange sectors is equivalent to the real order-six
   conference switching class.  The statement is deliberately about squared
   cross-block/exchange spectrum, not ordinary principal spectrum.
5. **Defect and stability.**  The averaged defect
   \(\delta=1-10^{-1}\sum_T r_T^2\) controls distance to the real conference
   orbit globally from below,
   \(d_{\mathbb R}^2\ge(10/3)\delta\), and locally from above,
   \(d_{\mathbb R}^2\le40\delta\), under
   \(\delta<(6-\sqrt{35})/20\).  No sharpness claim is made.

## Structural certificate compression

The manuscript proof now carries the explanation.  Conference block
equations reduce each balanced cross-Gram characteristic polynomial to the
squared real triangle holonomy.  A pentagon parity identity forces the uniform
endpoint; a Pfaffian-square argument excludes the wrong endpoint; triangle
product Lipschitz bounds yield the global metric inequality; and sign rounding
plus the conference residual yields the local reverse inequality.

The machine certificate has the narrower and more trustworthy role of
checking all sixty-four Boolean endpoint profiles, the twenty balanced
maximizers, the exact Pareto identities at independent parameter values, and
the stability constants.  It does not substitute a census for the rigidity
proof or a symbolic expression dump for the Pareto explanation.

## Literature and trust sweep

The C825 audit supports integration with conservative priority language.  It
records eleven sources at explicit read depths (five full text, three partial,
three abstract/metadata only) and three independently checked citation graphs.
The established boundary includes ordinary three-uniform ETF theory,
triple-product switching invariants, the order-six Hermitian conference family,
and a published classification claim.  No predecessor was located for the
continuous Golden joint optimum, the exact exchange Pareto segment, or the
conference-specific defect-to-real-orbit stability estimate.

Accordingly, the paper makes no broad three-spectral-uniformity claim and uses
no classification theorem in the new proofs.  The strongest novelty candidate
is the quantitative stability theorem; squared-spectrum rigidity is presented
only in its narrow sign-blind exchange form.  Full-text access remains missing
for Et-Taoui--Makhlouf and Cheng--Lv--Sun, so the paper does not infer theorem
details beyond the audited metadata/partial-text boundary.

## A/B decision

| Criterion | Earlier authoritative version | Integrated version | Decision |
|---|---|---|---|
| theorem hierarchy | orientation and Boolean benchmark, followed by substantial implementation detail | one chain from observable quotient through continuous optimum to rigidity/stability | integrated |
| mathematical ceiling | Boolean boundary | full real cube plus exact Hermitian Pareto edge and local metric stability | integrated |
| mixed-plane explanation | finite/exact observations distributed across research artifacts | one triangle-holonomy coordinate and affine exchange formulas in the proof | integrated |
| trust boundary | strong local exact bundle, narrower literature map | exact bundle extended and claims aligned with the C825 source-depth audit | integrated |
| operational balance | implementation material competes with the mathematical crown | measurement and resource boundary retained; engineering tables compressed | integrated |
| page budget | 14 pages | 16 pages | accept the two-page cost |

The two added pages buy a qualitatively stronger paper rather than an accretion
of side results.  Splitting the Hermitian/stability material would weaken both
papers: the continuous endpoint theorem supplies the real benchmark, while the
Hermitian deformation explains why that benchmark is rigid and quantitatively
stable.

## Verification

The final in-tree and clean extracted-package runs of `make check` both pass.
They cover TeX spacing lint, evidence-manifest verification, all three exact
generators, all three independent replays, PDF compilation, and a strict TeX
warning scan.  The sixteen-page PDF was visually inspected page by page; no
collision, clipping, unreadable theorem block, or malformed bibliography was
found.

Frozen principal hashes:

| artifact | SHA-256 |
|---|---|
| manuscript source | `6341feccfd5c20d1a0610beda09c2b6914cb80c30b111d8e796a089744e8c7f8` |
| manuscript PDF | `812bbc5dbf8e254c76a6369ccefd59142aa21346ad7716f82de39aa11109b7c2` |
| mixed-plane/continuous certificate | `1989fc56e7b4eaa9d8598b1b818d3027173238630ffc6561618f89346d12dbd0` |
| evidence certificate | `592c10c67616c26bc55c9a9aa5f0357d679b79e6fe8b62639d579b45d417501a` |
| evidence manifest | `5e9f35c8ff8a381884d68201fb444c86a045b98fb581f2872861cd049c2bf242` |

The extracted build produced a different PDF byte hash because the TeX toolchain
embeds build metadata; source, evidence, warning, page-count, and replay gates
were identical.  The submission record pins the authoritative in-tree PDF.

## Final recommendation

Adopt this version as the single submission package.  Do not add another
generality layer before review: the remaining worthwhile work is editorial
cold reading and external mathematical review of the rigidity/stability proof,
not another theorem family or more implementation detail.
