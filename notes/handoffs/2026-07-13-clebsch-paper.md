# Clebsch three-paper program

**Lane**: `clebsch`

**Date**: 2026-07-29

> **LIVE MAP ONLY.** The three-paper program below is the active publication
> path. The 37-page mega-paper and its evidence surface are preserved
> unchanged as a fallback, not as the active release target. Historical
> planning and review records are linked at the end.
>
> **ROUTING AUTHORITY.** This handoff is the single entry point for all active
> Clebsch paper work. No dated planning note, archived mega-paper verdict, or
> completed task report may override the order stated here.

## Current verdict

Paper I, *Reconstructing the Clebsch code from its deep-hole syndrome locus*,
is a warning-free candidate with a complete nineteen-row release surface; its
computational companion is *Computational strengthenings of Clebsch syndrome
rigidity*.
It lives in `papers/clebsch-rigidity/`. The first user-launched C320 review
returned `NO-GO` and commit `3ed43a0d` repaired its findings. The separately
user-launched PDF-only post-fix review found one remaining enumeration-boundary
overstatement; commit `70fb1e7f` repairs it and its clean replay is green.
A fresh separately user-launched, context-free PDF review returned final
`GO`, with no blocking or material minor finding. C320 is complete; C182 is
the active Paper I archive/release task. A later editorial review's
Dye-bound rigor clarification and presentation findings are repaired on
current `main`. A subsequent elevation pass replaces four separate
small-arc counts by a universal chord-defect theorem, proves
$|\mathcal U(A)|=q+1\Rightarrow q<\binom{k}{2}$ together with a sharper
quadratic field-size barrier and the passant lower bound $q\ge2k-3$,
plus the stronger even-order oval obstruction, and classifies conic filling
through eight points. The last three fields are excluded by a complete
passant-edge-orbit search: over each of $q=13,17,19$, the maximum arc with
all chords passant has size six. Compact certificates and a separate
discriminant/backtracking replay agree. The regenerated nineteen-row release
surface now has sixteen checks.
The final dependency audit explicitly attributes the Clebsch-only
$c(A)=10$ value to Dye, restores the point-orbit subtraction, and uses that
orbit proposition in the uncovered-conic proof.
The closing copy-edit removes the unused discrepancy column and stale
perturbation-checker reference and adds the exact secant-covering
reformulation.  The final referee pass adds its necessary
$A\cap\mathcal Q(\mathbb F_q)=\varnothing$ clause, aligns the two dependency
tables, records all four non-Clebsch degree-four classes, and identifies the
complete $q=9$ Clebsch specialization of
$|\mathcal U(K)|=q^2-14q+45$.  The $q=5$ root is explicitly separated as
an exceptional-characteristic counting degeneration, not an instance of
the associated-conic construction.  The final consistency pass cites the
unique $K_6$ one-factorization, folds the $k\le5$ clause into Theorem 2.2,
harmonizes frame order, and routes the $q=9$ exclusion to Theorem 6.2.
The final claim-preserving editorial pass now foregrounds the unified
inverse statement---coarse decoding data reconstruct the hidden Clebsch
geometry---rather than presenting the abstract as a flat result list.  It
regenerated the statement identity, PDF, trust manifest, and release
certificate; the clean fifteen-check replay is green at `949ec7b2`.

The five prose--Lean synchronization findings are repaired.  The polarity
route, support-bipartition trust boundary, Dye theorem numbering,
icosahedral-local-data name, ambiguity wording, and public docstrings now
match the exact formal statements.  The formal gate passed at `6d4766d1`;
the manuscript and nineteen-row surface were regenerated at `59f6babe`;
the refreshed certificate and final clean fifteen-check replay passed at
`341fabbf`.

C605 is complete. Its report, exact search, compact certificates, independent
replay, and mystery ledger are in
`notes/2026-07-25-c605-eight-point-conic-filling-search.md`. The final clean
sixteen-check release replay is green at `91db7b5c`.

C610 is complete. Paper I now states the length-at-most-eight projective MDS
consequence, promotes C605's sharp maximum-six exterior-set arc bound, names
the exterior-set framework, and exposes the \(q=13\) passant-saturation
mechanism without adding a new evidence route. The warning-free 19-page PDF,
nineteen-row trust surface, and clean sixteen-check release replay are green
at `fd2dee6e`. C611 owns the broader conceptual mechanism and
v2/other-paper disposition.

C662 is complete and its partial-cover theorem is integrated into Paper I.
It gives
\(\binom{k}{2}\ge3(q-1)/2\), reconstructing the exact \(k=7,8\) terminal
window and strengthening the general upper bound to
\(q\le(k(k-1)+3)/3\). The saturation theorem identifies the \(q=2k-3\)
endpoint with arc-supported minimum-weight words in the passant/internal
incidence-code nullspace. Its full \(q=13\) elliptic-scheme audit reaches
only the integer bound eight, one short of excluding the terminal eight-arc.
The literature audit shows that the missing support and near-minimum-cover
classifications are not consequences of the known human theorems. The C605
terminal searches therefore remain load-bearing. The report and mystery
ledger are in
`notes/2026-07-26-c662-human-passant-bound.md`.
The accepted Paper I trial now implements C662's subtractive disposition:
the warning-free fourteen-page human paper points to a standalone
seven-page computational companion in the same paper root. The companion
holds the fifteen-class/low-degree/gap results, cross-field six-arc
uniqueness, and the classification through eight points, with its own build
target, bibliography, machine-readable seven-claim ledger, validator, and
five passing exact replay routes. A post-choice cold read again selected the
human-core paper, found that its revised abstract repairs the apparent
novelty loss, and ranked *Reconstructing the Clebsch code from its deep-hole
syndrome locus* first; that title is now adopted. A copy edit of both parts
then fixed the companion's undefined code symbol and synchronized
terminology without changing either page count. The companion's remaining
submission blocker is external packaging: its relative replay paths need a
stable artifact locator and immutable version, as tracked by C182.
A submission-readiness pass then narrowed the companion's
``without classification'' claim to ``without an exhaustive classification
of six-arcs over \(\mathbb F_{11}\)'', stated fixed-conic reconstruction as one
stabilizer orbit, promoted and motivated the general conic-filling window,
added its sharpness status, positioned Kaipa and Wu--Ding--Chen, made the
Lean/exhaustive-search boundary explicit in both papers, and replaced the
companion's exponent-like histogram with a frequency table. Both PDFs remain
warning-free at fourteen and seven pages. No paper-code remote or immutable
deposit exists yet, so the external artifact citation remains C182's
blocker.

C182 follows C610. Its blocker is external publication packaging. The
paper repository and immutable public deposit do not yet exist, and this
workspace has no GitHub or Zenodo publication credential. The manuscript
names the shared `tavisrudd/finitegeom` formal repository, pins its commit,
and gives the exact replay interface; it must not ship until the paper
repository has an immutable DOI or Software Heritage identifier and that
identifier is added to the paper.

C577 has begun under the permitted external-wait exception. Paper II now has
a standalone headline factorization theorem, marked-conic notation, the
general matching-secant quotient with proof, and the four-endpoint switch
mechanism. It also defines the three matching orbits explicitly and proves the
exact `3,6,10` rank theorem, distinguishing the full spaces in types `A_3`
and `B_3` from the canonical harmonic-plus-radial ten-space in type `H_3`.
An `ej` upgrade proves that the omitted five-space is exactly the middle
Fischer layer `Q H_2`. C616 now explains this loss by projecting the affine
connecting cocycle to the three twisted Fischer summands: Sylow-normalizer
cohomology and the `A5` fixed-space calculation kill the middle layer.
Same-sheet unique factorization and irreducibility force the top nine-space,
while one independently replayed second-Laplacian scalar supplies the radial
line.
The same pass promotes the uniform Coxeter-number formula
`dim W_T = h_T - 1 + 1_(h_T/2-1 even)`, whose three values are `3,6,10`.
C616 is complete: the radial-trace identity is coordinate-free, and the
ten-space row reduction has been replaced by the cohomological argument plus
one scalar radial witness. The proof, certificate, independent replay, and
mystery ledger are in `notes/2026-07-25-c616-h3-uniform-rank-upgrade.md`.
A fresh PDF-only referee read then found three local self-containedness gaps
in that proof.  The manuscript now defines the twisted
\(\operatorname{GL}_2/\operatorname{PGL}_2\) action and its scalar descent,
proves the cocycle-value span is stable before invoking irreducibility, and
exhibits a nonsquare-determinant projectivity carrying the base matching to
the radial witness.  The evidence inventory, conclusion boundary, and
Eisenbud--Popescu journal citation are synchronized; the full eighteen-row,
eight-bundle release replay and warning-free build are green.  A fresh
independent reread remains.
Paper II now also proves the abstract radical--Hadamard recovery lemma,
specializes it to the `B_3` `7+7` and `H_3` `11+11` sheets without subset
enumeration, and proves that the first signed tensor orientation moment is
cubic and carries the outer character. The C406 and C430 primary certificates,
independent replays, and checksum gates are green. The six-profile section
now derives the `1,4,6 / 1,4,6` rows from subgroup marks, defines the
secant-incidence profiles, proves set-theoretic row separation despite the
rank-two image, recovers the `1,4,6` orbit weights from the three unlabeled
profile rays, forces the compressed cubic by a general three-ray lemma, and
derives its doubled-line/residual-line Hessian flag from the modular
mass-zero identity `1+4+6=0` while stating the exact singleton
matching/parent recovery boundary. The modular section now identifies the
depth plane as `P(1)^A4 / soc(P(1))`, separates its six-row set-theoretic
memory from its rank-two linear memory, and proves the frozen `A_3`
fused / `B_3,H_3` split arithmetic theorem with the
`A5 cap A5 = A4` and generated `PSL_2(11)` hinge. The canonical
relative-cubic Tate plane and its divided-transfer non-identification with
the depth plane are isolated in an appendix. It now has a twenty-one-statement
paper-specific trust manifest, an eight-bundle aggregate replay, a verification
section that separates conceptual, classical, certificate, and Lean support,
and a conclusion that states the exact reconstruction ladder and its
relative/global boundaries. The Milnor/Serre structural pass is now applied:
the mechanism precedes the narrowed four-clause theorem; the switch is folded
into the general quotient section; the applications paragraph is replaced by
companion-paper citations; Section 6 has a conceptual gateway; modular depth
and arithmetic splitting are separate sections; and the conclusion precedes
the verification and mathematical appendices. A front-matter scope ledger
now distinguishes the three-type linear theorem from the `B_3/H_3` sheet
theorem and the `H_3`-only refinements. A fresh staged title/abstract/full-PDF
cold read returned editorial `GO`, conditional only on the already-declared
public immutable archive locator. The full local replay and warning-free
twenty-four-page build is green. The current theorem,
evidence boundary, and mystery ledger are in
`notes/2026-07-25-c577-clebsch-factorization-memory.md`.
The two unprimed next-question reads are consolidated in
`notes/2026-07-25-c620-clebsch-factorization-next-questions.md`. C620 is
complete: Paper II now proves \(L^{\circ3}=k^\Omega\), the full Schur-power
filtration, and the Hilbert function with \(h\)-vector
\((1,q-1,q-1,1)\). C417's nontrivial base-choice cocycle explains
why the graded algebra is reference-independent under translation without
coming from a canonical equivariant origin; that obstruction remains on
C417's existing evidence surface rather than becoming a new Paper II
theorem. C621 is complete: the homogenized \(B_3/H_3\) configurations are
self-associated arithmetically Gorenstein sets, their dualizing residue
vector is the sheet sign, and \(\mu_3\) is the cubic inverse system of
their Artinian reductions. The exact saturated ideals, deletion tests,
socles, Betti tables, and independent replay are positive. Paper II's
twenty-one-statement, eight-bundle aggregate replay and warning-free
twenty-four-page build is green. C616 completes the \(SL_2/A_5\)
uniform-rank upgrade. The C620 proof,
trust disposition, and mystery ledger are in
`notes/2026-07-25-c620-graded-evaluation-algebra.md`.
The C621 proof, audit, exact certificate, and mystery ledger are in
`notes/2026-07-25-c621-gorenstein-gate.md`.
C632 formalizes the reusable signed Gale-kernel hinge: weighted
orthogonality is the matrix identity \(A(AD)^{\mathsf T}=0\), its signed
rows lie in \(\ker A\), and full row rank plus the \(q\)-by-\(2q\)
dimension count identifies their span with the entire kernel. The dedicated
Lean gate and exact noncoverage boundary are recorded in
`notes/2026-07-25-c632-signed-gale-duality-lean.md`; the frozen
\(B_3/H_3\) coordinate hypotheses and the Gorenstein criterion remain on
C621's non-Lean evidence routes.
C635 removes the formal theorem's redundant signed-row-independence
hypothesis: full row rank makes the original rows independent, while
full-support weights make diagonal scaling injective. The resulting terminal
takes exactly the matrix identity, full row rank, full support, and the
\(q\)-by-\(2q\) size; its degrees-of-freedom audit is in
`notes/2026-07-25-c635-signed-gale-closeout.md`.
The final polish renumbers equations by section, shortens the title,
defines the profile and Tate-basis conventions, and identifies the
top-harmonic homogeneous extension with
\(P(\mathbf1)/\operatorname{soc}P(\mathbf1)\). A revision-specific reader
then caught the necessary full-module correction: the complete restricted
homogenization has one additional trivial radial summand. Its standard
questions are in
`notes/2026-07-25-c577-revised-standard-questions.md`; the post-baseline
literature and novelty disposition is in
`notes/2026-07-25-c577-postbaseline-novelty-audit.md`.
The final Paper II hierarchy now presents the quotient, \(3,6,10\) ranks,
quadratic sheet recovery, cubic orientation, and Gorenstein duality as the
twelve-page main paper; the decorated \(H_3\) profile, modular, arithmetic,
and Tate results are preserved as mathematical appendices, with verification
last. A concrete \(B_3\) walkthrough and proof/evidence map complete the
accessibility pass. The synchronized twenty-one-statement, eight-bundle
aggregate replay, Lean gate, warning-free twenty-four-page PDF, and fingerprint
are green at `b9ee4f88`.

C661 is complete.  Paper II's \(A_3,B_3\) row reductions are replaced by
one affine-cocycle/Fischer-module proof: defining-characteristic
\(\operatorname{SL}_2\) irreducibility forces the top summands, while the
\(B_3\) outer quotient is \(3L_{02}^2\), so its radial trace is the dual
norm of a secant.  The `tt` closeout first reversed the former
cubic-to-Gorenstein dependency: radical--Hadamard recovery gives signed Gale
self-duality and Cayley--Bacharach in degree two, after which the classical
self-association criterion and Hilbert symmetry recover
\(h=(1,q-1,q-1,1)\).  C665's later full-support hyperplane-square lemma now
forces \(L^{\circ3}=k^\Omega\) and the nonzero cubic directly, so Gorenstein
symmetry is a geometric consequence and independent check rather than the
logical source of cubic nonvanishing.
The final Hilbert-symmetry arithmetic is kernel-checked by
`RelativeConicArcs.HilbertSymmetry.socleDegree_eq_three` and
`RelativeConicArcs.HilbertSymmetry.value_three_eq_one`; source elaboration
is green, while its import-only gate and the refreshed aggregate are waiting
behind a foreign Lean build owner.  Exact matrices and cubic tensors remain
cross-checks rather than the human proof.  The bounded family route found the
abstract antipodal-simplex family
but no new conic matching realization, so the remaining frontier is the
structural derivation of radical--Hadamard hypotheses beyond \(B_3,H_3\).
The proof and mystery ledger are in
`notes/2026-07-26-c661-uniform-factorization-upgrade.md`.

C665's limited Gold theorem is complete and integrated as a Paper II v2
upgrade; it does not hold v1.  A one-dimensional strength-two trade with
one-factorization fibres forces the balanced \(q+q\) split and reduces the
full-projective recovering orbits to \(B_3\) and \(H_3\), with the \(q=5\)
orbit excluded by its full Schur square.  The field-independent
hyperplane-square lemma also gives
\[
L^{\circ2}=\ker\epsilon,\quad \epsilon\text{ full support}
\quad\Longrightarrow\quad L^{\circ3}=k^\Omega.
\]
The report, exact certificate, independent replay, Lean boundary, and
mystery ledger are in
`notes/2026-07-26-c665-balanced-matching-completeness.md`.

The Platinum characteristic-three torus gate T3 is closed.  The
inverse-discriminant weight \(w(\{x,y\})=(x-y)^{-4}\) supplies the missing
sheet trade uniformly; its \(H\)-span is
\(L(8)=L(2)\otimes L(2)^{(1)}\).  The split, nonsplit, and antipodal cases
are settled.  The q=27 Fourier excess is a warning that the actual module
occurrence, not its composition-factor label, controls the operator.

The only open C665 frontier is **uniform extension-field C1** for the
remaining exceptional \(A_4,S_4,A_5\) heads.  Prime fields are closed.
The q=25 and q=49 heads have zero affine Hom and need no pullback; q=121 is
the first open gate.  There \(L(6)\) embeds in
\(F=\operatorname{Sym}^{59}L(2)\) but is nonretracting, while the
\(L(8)\) and \(L(12)\) probes are eliminated.  The former q=121 scalar
Hasse-pairing certificate was non-equivariant and is retired, so the
quadratic pullback for \(L(6)\) remains undecided.  Its correction and
replacement attacks are in
`notes/2026-07-29-c665-uniform-c1-correction.md`.

### C665 cold-session protocol: uniform extension-field C1

Route a fresh session with

```text
go C665 clebsch uniform extension-field C1
```

This is a Paper II v2 Platinum continuation and must not hold v1 or enter the
manuscript before the uniform theorem exists.  T3 is closed; do not resume
torus calculations.

Before proof work, read the rank-one modular persona and the C1 sections of
the C665 report and correction note.  Keep
\[
0\to F\to E\xrightarrow{\epsilon}k\to0,\qquad
F=\operatorname{Sym}^{(q-3)/2}L(2),
\]
and
\[
\partial:\operatorname{Sym}^2E\to E,\qquad
\partial(xy)=\epsilon(x)y+\epsilon(y)x
\]
as the fixed point-vector convention.

For each outer-parity head \(i:S^\chi\hookrightarrow E\), use this order:

1. close the row immediately if \(\operatorname{Hom}_H(S,E)=0\);
2. if \(S\) embeds, decide whether its actual occurrence retracts;
3. use the retracted-socle trace lemma only for a proved retraction with
   \(p\nmid\dim S\);
4. only for an embedded nonretract compute the outer-parity pullback class
   or give an injective Borel obstruction.

The immediate gate is the embedded nonretract \(L(6)\subset
\operatorname{Sym}^{59}L(2)\) at q=121.  Test the genuine ordinary
contractions of orders \(1,\ldots,10\); if they are blind, pass to Borel
restriction.  The uniform target is a modular-Hermite/tilting description
that expresses the embedding gate, retraction scalar, and radical-branch
pullback obstruction in Frobenius digits for every candidate family.

Do not infer occurrences from composition factors, extrapolate q=25/49,
reuse the retired Hasse pairing, or build a field-sized symmetric square
before the affine Hom gate.  The full candidate table, exact replay commands,
and historical finite-field evidence remain in the report, correction note,
and companion handoff archive.

The active order is strict:

1. **C182:** make the immutable public deposit and insert its identifier.
2. **C611:** pursue the broader exterior-set mechanism for v2 or its actual
   owning paper without holding v1.
3. **C577:** build and referee-test standalone Paper II after Paper I is
   submission-ready.

C680 has completed the local mathematical and artifact repair.  The
fixed-icosahedron Clebsch chart is correctly defined over
\(\mathbf Q(\sqrt5)\), not \(\mathbf Q\); a finite-etale local normalization
argument now makes the two golden configurations the complete reduced fibre
and preserves the global \(5J_0\) square-class theorem.  The exchanger has
uniform finite-field spinor class \([2]\), with the certified nontrivial
\(q=11\) case as its specialization.  The 27-file
`clebsch-passages` artifact has no C-ID, stale program name, repository-note
reference, Mathieu/Hadamard/matching branch, or Klein bundle.  Label-level
trust identity, explicit `formal_coverage: none claimed`, ordinary replay,
isolated replay, and the warning-free ten-page PDF are green.  The global
square-class proof now correctly uses \(j_s=J_0/s^2\in K^\times\) for a
rational section of \(\mathcal O(3)\), and the local generator comparison
preserves the \(c=5\) specialization.  The style findings are repaired, and
the cheap closeout adds the exact standard bond-order restriction
\(W_6(F_y)=313600\pi^{3/2}\sigma_3(y)/(4563\sqrt{3553})\).  Two
direct-access pre-release reviews received the complete live paper and Lean
directories with metadata excluded; both returned `GO` with zero blockers
or material minors, and the final grades were `A/A`.  Submission remains
`NO-GO` only pending an immutable artifact locator and the author's
affiliation/contact metadata.  The
authoritative report and mystery ledger are
`notes/2026-07-26-c680-paper-iii-cold-session-closure.md`.

C682 is an open Hitchin-facing exploration, not a theorem gate.  It ranges
over the rational \(5J_0\) incidence torsor, complete golden fibre,
conjugate Clebsch charts, Petersen module, and Steinhardt/Gaunt realization,
looking for any interesting structural consequence, connection, question,
example, or viewpoint.  It must label proved deductions and conjectural
leads honestly.  Its target is Gold/Platinum-level structure; preserve
genuine Silver results as interim gains, but do not treat Silver as
completion.  It has no preset output shape, negative-close test, or automatic
stopping condition.  If the first proposed bridge is tautological or fails,
the task continues: rotate through deeper Hitchin-style geometric,
invariant-theoretic, arithmetic, and representation-theoretic questions and
look for the next interesting structure.  The user decides when C682 is
done.  This exploration does not reopen or hold the pre-release-green Paper
III bytes unless the user later chooses to promote a finding.

C682's first Gold result is proved and exactly cross-checked.  For an
icosahedral invariant \(I\in\mathcal H_6^{A_5}\), the unique
Clebsch--Gordan coupling
\(\mathcal H_3\otimes\mathcal H_6\to\mathcal H_6\), equivalently the third
binary transvectant, gives an \(A_5\)-map \(T_I\) of rank four.  Its kernel
is the nonmatching \(V_{3'}\), and its image is the unique \(V_4\), hence
the Petersen four-space.  At the Klein dodecic the kernel is also
pairwise isotropic for the fifth transvectant, so the kernel construction
identifies the binary-dodecic and Grassmannian \(PSL_2/A_5\) models on
their open orbit.  The rank-four locus has projective tangent dimension
three at the Klein point, so the Mukai--Umemura closure is its local
component there.  Both boundary-orbit representatives retain rank four
with exactly Hitchin's isotropic weight-space kernels; the closed orbit has
one extra rank-locus tangent direction, so isotropy remains essential.
After primitive normalization the integral map has rank four modulo \(11\)
and rank two modulo \(5\), opening a genuine bridge to C651's finite
matching cubic while respecting the Gaunt-scalar obstruction.  The `ej2`
portfolio pass also isolates exact or actionable compositions with
complete-port reconstruction, AME--LU reduction, Kneser defect spectra,
PRS catalecticant flags, and Frobenius replacement graphs.  The exact
matrix, proof, reproducibility boundary, algorithm landscape, cross-paper
disposition, conjectural \([5]\)-descent refinement, and mystery ledger are in
`notes/2026-07-26-c682-hitchin-structural-question.md`.  C682 remains open.
The highest-EV cheap gate is the C651 contraction through the primitive
mod-\(11\) map; globally, determine whether rank four plus isotropic kernel
characterizes the full Mukai--Umemura compactification.  Exact
Euclidean/binary normalization, conjugate-map descent, and targeted
primary-source audit precede any manuscript promotion.

C682's portfolio `ej` pass finds a Platinum three-paper candidate.  With
the frozen Paper II normalization
\(c_{\mathrm{match}}=4\sigma_3\) over \(\mathbf F_{11}\) and Paper III's
\(J_0|_V=16\sigma_3^2\),
\[
c_{\mathrm{match}}^2=J_0|_V,\qquad
w=\pm4c_{\mathrm{match}}\quad(w^2=5J_0).
\]
These are exact identities in C651's selected coordinates, not yet an
intrinsic equality: its \(V_4\) scalar was chosen inside a
three-dimensional Hom-space, and no morphism yet identifies the matching
sheet torsor with the incidence torsor.  Paper I supplies a potential
inverse-problem front end by reconstructing the Clebsch class and \(A_5\),
but not the required five-point marking or characteristic-zero lift.  The
resulting \(2\)-\(3\)-\(6\) target is quadratic reconstruction, cubic
orientation, and sextic forgetting by squaring, with the odd transvectant
as the proposed degree-three-to-degree-six map.  Promotion needs one
marked Paper I--II--III diagram, one C651/transvectant scalar comparison,
equivariance of the two \(C_2\)-actions, and wording restricted to the
abstract mod-\(11\) orientation algebra rather than global geometric good
reduction.  The full red-team verdict is in the C682 report.

C682's next `ej` pass closes one of C373's old common-duality kill tests.
For the ordered golden \(3\times6\) axis matrix \(A_t\), an exact Gale
kernel \(K_t\) and invertible \(H\) satisfy
\[
A_tK_t^{\mathsf T}=0,\qquad HK_t=-tA_{1-t}.
\]
Thus six-point Gale association is exactly Paper III golden Galois
conjugation on this marked fibre, and the two golden codes are dual:
\(\operatorname{row}(A_t)^\perp=\operatorname{row}(A_{1-t})\).
This does not yet identify Paper II's global factorization-sheet
involution with that operation.
The exact characteristic-zero certificate and an independent mod-\(11\)
replay are in the C682 evidence bundle.  A further Gold composition puts
Paper I's twenty oriented support triples over the same ten-vertex
Petersen carrier as Paper III's face axes.  The exact marked test is now
complete: one Paper I support orbit is precisely the ten supports of
icosahedron face pairs, the complementary orbit gives a second signed-sum
decomposition of the same ten face axes, and
\((T_0,\ldots,T_4)\mapsto(1,5,2,4,3)\) matches the displayed Paper III
labels.  A literature-triggered correction fixes the conjugate edge
branch: the conjugate icosahedron has edge inner product
\(-\bar t=t-1\), so its face supports are the complementary Paper I
orbit.  Support complementation, Gale association, and golden Galois
exchange are therefore the same marked \(C_2\), as the classical
opposite-icosahedron description predicts.  The Paper I support sheets
also have equal
moments through degree two and first differ cubically, exactly paralleling
Paper II's recovery/orientation mechanism.  However, the obvious
syntheme-quadratic followed by the Clebsch cubic is not the square of that
support cubic; two exact witnesses falsify the scalar identity.  The
`ej` invariant-span pass finds the corrected theorem on the augmentation
module:
\[
375C^2-12\sigma_3(q)
=6000p_6-4350p_4p_2-2125p_3^2+705p_2^3.
\]
The \(A_5\), outer-even \(S_5\), and fully symmetric \(S_6\) sextic spaces
have dimensions \(7,5,4\).  Hence the exotic outer-even quotient is
one-dimensional, and \(C^2\) and \(\sigma_3(q)\) have projective ratio
\(4:125\) there.  This is the surviving quadratic--cubic--sextic
composition: the Paper I orientation square and the common Paper II/III
Clebsch cubic agree after the syntheme quadratic map modulo universal
symmetric information.  Paper II's outer sheet placement and an intrinsic
interpretation of the four symmetric correction terms remain open.

The focused literature audit removes the proposed Platinum crown.
Howard--Millson--Snowden--Vakil's Joubert/Segre coordinates \(Z_T\) are
the support cubics \(C_T\), and their classical Segre--Igusa dual
coordinates are
\[
W_T=Z_T^2-\frac16\sum_U Z_U^2
   =\operatorname{center}(C_T^2).
\]
Kraft likewise treats the lowest-degree outer-\(S_6\) Joubert covariant
and its sextic Tschirnhaus application.  Hence uniqueness, outer
covariance, and the generic resolvent application are preempted.  The
surviving formula-level Gold candidate is the compact identity
\[
125W_T=4\,\operatorname{center}\bigl(\sigma_3(q_T)\bigr),
\]
which computes the classical dual coordinate from the five syntheme
quadratics using one Clebsch cubic.  A bounded exact-phrase audit did not
locate this presentation, but that is not an absence claim; compare it
term-by-term with the classical explicit \(W_T\) formulas before
promotion, and require a consequence beyond Segre--Igusa duality for any
general-journal claim.

C682's TR Platinum track is now proved in characteristic zero.  On the
Mukai--Umemura threefold, the dodecics annihilating a universal isotropic
three-plane under the third transvectant form a line bundle: exact ranks
on Hitchin's three orbits are uniformly \(12\).  The Borel lower bound then
makes the dodecic-to-kernel and plane-to-annihilator constructions inverse
scheme-valued functors.  Consequently the stable rank-four locus is exactly
the icosahedral orbit, while rank four plus fifth-transvectant kernel
isotropy cuts out its entire smooth compactification with no remote
component.  The construction is the degree-\(22\) projection of the
anticanonical \([1+\Phi_{12}]\) model from its invariant coordinate.
Three exact rational orbit rows, all tangent spaces, and a separately
written mod-\(101\) replay pass.  A bounded source audit did not locate the
explicit inverse.  Mukai's 1992 *Fano 3-folds* triangulates the same
compactification through polar six-sides/VSP, and his 1995/2002 Fano survey
explicitly identifies its genus-\(12\) net-of-skew-forms model with
\(SL_2/A_5\), but neither states a dodecic transvectant inverse.  The 1983
paper remains available here only through the user's page images, and the
broader databases remain uncovered, so novelty and manuscript promotion
are not yet claimed.

C682's beyond-threefold `ej` pass now places TR in a precise
transvectant-isotropic ladder.  For odd \(r\), the rank-two locus
\[
X_{m,r}=\{E\in Gr(2,\operatorname{Sym}^m):(E,E)_r=0\}
\]
has expected dimension \(2r-3\) and anticanonical index \(2r-m\).
The two uniform smooth Fano rows are
\(X_{r,r}=IGr(2,r+1)\) and the codimension-three invariant section
\(X_{r+1,r}\); all later positive-index rows lose transversality at the
unique Borel-fixed plane.  Solving the corresponding positive-index
threefold balance leaves exactly \(Q^3\), \(V_5\), a nontransverse
genus-eight near-miss, and \(U_{22}\).  Moreover \(V_5\) has the exact
lower kernel inverse
\[
I_6\longmapsto
\ker((\,\cdot\,,I_6)_2:\operatorname{Sym}^4\to\operatorname{Sym}^6),
\]
with rank three, third-transvectant-isotropic kernel of dimension two,
and annihilator line on all three orbits.  The exact audit is
`notes/2026-07-26-c682-transvectant-ladder.py`.  The highest-EV
genuinely beyond-variety continuation is to write the Sarkisov link
\(V_{22}\dashrightarrow V_5\) between the two kernel transforms and test
whether it exposes the branch divisor of the rational-quartic
Hilbert-scheme double cover.

C682 now resolves that pointed Sarkisov graph scheme-theoretically.
The seventh-polar formula is the complete system
\(|H-2L_\lambda|\): its ambient center is exactly the span of the first
infinitesimal neighborhood of \(L_\lambda\).  Hence its graph is the KPS
double-projection graph as a closed subscheme, not only a rational map
with the same reduced exceptional image.  The entering integral-closure
guess was false.  On the open pointed-line chart the exact base ideal is
the integrally closed ideal
\[
 (u^2,uv,v^5)\subsetneq(u,v)^2.
\]
After blowing up \(L_\lambda\), the residual ideal is \((r,v^3)\), its
Rees equation is \(rB=v^3A\), and three ordinary section blowups give
the width-three Reid-pagoda resolution of the unique flop.  KPS
Proposition 5.4.3 supplies the global special-line facts:
\(N_{L/X}=\mathcal O(1)\oplus\mathcal O(-2)\), no other line meets
\(L\), and the target flopping curve is the strict transform of the
unique tangent bisecant \(B_\lambda\).  The exact audit and independent
10,201-point mod-\(101\) replay are folded into the existing C682
Sarkisov-kernel bundle.  The next geometric gate is the inverse pointed
kernel formula, followed by the quartic branch equation; C682 remains
open until the user closes it.

C682's instance audit separates the universal construction from the
Clebsch special fibre.  The complete system \(|H-2L|\) is general for a
line on any smooth \(V_{22}\), but the local ideal
\((u^2,uv,v^5)\) and width-three pagoda belong to the special
Mukai--Umemura pointed chart.  The nearest comparisons are the
distinguished special-line links on the additive and multiplicative
large-automorphism \(V_{22}\)'s.  A second published link, centered on a
smooth conic, gives \(V_{22}\dashrightarrow Q^3\); together with the
line link and the transvectant classification, this places
\(Q^3,V_5,U_{22}\) in one exact two-edge diagram.  The next cheap
falsifiable experiment is the relative Rees algebra in the \(G_m\)-pencil
at its Mukai--Umemura parameter \(u=-1/4\), testing whether the
width-three pagoda is a collision of ordinary flop data.  The
highest-payoff calculation remains the \(PGL_2\)-constrained branch
equation of the rational-quartic Hilbert double cover.  A single
equivariant master correspondence explaining the three kernel nodes, both
links, the double conic of lines, and the pagoda is an explicit conjectural
target, not a proved conclusion.

C682's opposite-code audit finds an exact \(q=11\) midpoint pattern.
Evaluating the binary-form modules \(U_4,U_5,U_6\) on all twelve points
of \(\mathbf P^1(\mathbf F_{11})\) gives extended GRS codes
\[
 [12,5,8],\qquad[12,6,7],\qquad[12,7,6].
\]
The outer codes are dual and the middle code is self-dual.  These are
precisely the modules of the \(V_5\) kernel model, the normal-quintic
Sarkisov center \(\lambda U_5\), and the \(U_{22}\) kernel model.  Thus the
line link has an exact object-level code shadow: a dual MDS pair with a
rate-half self-dual MDS center, and hence an
\(\operatorname{AME}(12,11)\) midpoint.  The original Clebsch
\([6,3,4]_{11}\) seed instead has duality exchanging its two golden
forms, while its complete legal-extension port is the conic
\([12,3,10]_{11}\).  No functor from the Sarkisov graph to these code
objects is yet proved.

The conic-edge finite test is now exact.  Kuznetsov--Prokhorov's sextic
\((t_0^6:t_0^5t_1:t_0^3t_1^3:t_0t_1^5:t_1^6)\) gives
\[
 C_\Gamma=[12,5,6]_{11},\qquad
 C_\Gamma^\perp=[12,7,4]_{11};
\]
both Singleton defects are two.  It is the degree-six extended RS code
with precisely the \(t^2,t^4\) rows deleted, so
\[
0\to C_\Gamma\to R_6\to\mathbf F_{11}^2\to0,\qquad
0\to R_4\to C_\Gamma^\perp\to\mathbf F_{11}^2\to0.
\]
The code has \(24\) projective minimum words; the dual has \(15\), supported
on exactly fifteen rational four-secant planes in three five-element
orbits.  Its \(PGL_2(\mathbf F_{11})\) parameter stabilizer is exactly the
dihedral group of order \(20\), matching \(G_m\rtimes C_2\).  The
certificate exhausts all \(11^5\) codewords and \(1320\) projectivities,
and a separately implemented replay agrees.  This code is fixed throughout
the \(G_m\)-pencil and does not isolate the Mukai--Umemura parameter.

The `tt` pass makes the code statement uniform.  For every odd prime power
\(q\ge7\),
\[
C_\Gamma(q)=[q+1,5,q-5]_q,\qquad
C_\Gamma(q)^\perp=[q+1,q-4,4]_q;
\]
both Singleton defects are always two.  The dual RS endpoint is
\(R_{q-7}\), so it equals the lower Sarkisov module \(R_4\) uniquely when
\(q=11\); residue duality then exchanges degrees \(4,6\) and fixes degree
\(5\).  Geometrically, the omitted \(t^2,t^4\) coordinates are the
second-jet lines at the two torus-fixed points, with centered weights
\(2,-2\).  Their omission gives vanishing sequence
\((0,1,3,5,6)\) at both points and raises the two tangent contacts from
order two to order three.  Kuznetsov--Prokhorov identify precisely those
two 3-tangent lines as the complete Reid-pagoda flopping locus.  Thus the
two code defects, missing weights, jet gaps, and flop components are one
pair of objects.  The remaining categorical gate is a
base-change-compatible Rees-algebra construction from the two jet quotient
lines.

C682's Klein \(E_8\) operator-algebra gate is resolved through the first
non-multiplicity-free McKay weight.  For the normalized third
transvectant and its positive Fischer adjoint, the first two return words
saturate the full binary-icosahedral commutants in degrees \(6,12,18\):
\[
\mathbf C^2,\qquad \mathbf C^4,\qquad
\mathbf C^3\oplus M_2(\mathbf C).
\]
At degree eighteen their commutator has rank eight on the doubled
four-vertex; the exact positive spectrum starts with singular value
\(30\sqrt7/551\).  The separate \(SL_2\)-apolar adjoint refines the
Mukai--Umemura orbit picture: transvectant rank stays four on all three
orbits, but the apolar return is a nonzero scaled projector on the open
orbit and vanishes on both boundary orbits.  Kramer's generalized Casimir
has rank-eight commutator with the first return at degree eighteen, ruling
out a polynomial identification.  The exact proof, primary certificate,
independent replay, source-depth boundary, and mystery ledger are in
`notes/2026-07-28-c682-klein-e8-operator-algebra.md`.  The next \(E_8\)
gate was all-weight commutant saturation or its first failure.

That gate now closes negatively at the first actual obstruction.  The two
shortest returns saturate every integer weight through \(21\), but at weight
\(22\)
\[
\operatorname{Sym}^{22}|_{2.A_5}
\simeq3^{\oplus2}\oplus5^{\oplus2}\oplus3'\oplus4
\]
has commutant dimension ten and return-algebra dimension eight.  This is a
failure of the full graded corner, not only the two-return generating set:
the doubled \(3\) has adjacent multiplicities \(0,2,1\) in weights
\(16,22,28\), so every downward excursion vanishes and every upward
excursion factors through one multiplicity line.  Thus all closed words act
through \(\operatorname{span}\{I,A^\dagger A\}\) on that block and cannot
generate \(M_2\).  Exact rational closure through weight \(22\), two
independent modular replays, the general bottleneck lemma, and the mystery
ledger are in
`notes/2026-07-28-c682-klein-e8-first-failure.md`.  The next \(E_8\)
`ej` pass identifies the two degree-\(22\) \(3\)-covariants as
\(H_{20}\operatorname{Sym}^2\) and
\(\Phi_{12}\operatorname{Pol}_2(\Phi_{12})\).  The dark line is the exact
\(5/11\) graph killed by \(\Delta\), while the bright target is
\(\operatorname{Pol}_2(T_{30})\).  The full Molien-numerator audit proves
that weight \(22\) is the unique all-weight bottleneck of local type
\(0,m,1\).  Primitive normalization turns the dark coupling into
\(110=2\cdot5\cdot11\); ordinary second polars vanish modulo \(11\) while
the primitive Hessian survives, isolating a concrete divided-power bridge
question without yet identifying C651's finite map.  The next \(E_8\)
frontier has now closed for the complete \(3\)-covariant block.  Over
\(\mathbf Q[F,h]\) it is free on degrees \(2,10,12,18,20,28\), and
\(\mathcal D=(\,\cdot\,,F)_3/132\) is a primitive integral
\(6\)-by-\(6\), order-three Weyl operator with complete off-diagonal
\(3+3\) support.  Its degree-\(22\) row is the Koszul map
\(100(-\partial_h,\partial_F)\), so the dark line is \(hg_2+Fg_{10}\).
All principal entries share
\[
p=2F\xi^3+5h\xi^2\eta-8000F^3\eta^3,
\qquad
\det\sigma_3(\mathcal D)=-10^6p^6t^6,
\]
where \(t^2=1728F^5-h^3\).  Thus the characteristic locus has exactly the
cotangent cubic and Klein branch components.  The exact presentation,
two-prime replay, proof, and mystery ledger are in
`notes/2026-07-28-c682-klein-e8-free-covariant.md`.  The next \(E_8\)
frontier is to identify \(p\) intrinsically and test whether the other eight
McKay blocks share it, then use the finite matrices to classify all later
corner failures.

The bounded C682 literature audit subtracts two apparent novelty claims.
Suter prints the exact \(3\)-node numerator
\(t^2+t^{10}+t^{12}+t^{18}+t^{20}+t^{28}\), and the McKay module is a
classical maximal-Cohen--Macaulay covariant module.  More decisively, direct
multiplication of the principal blocks gives
\[
AB=BA=-100(h^3-1728F^5)I_3,
\]
so they lie in the classical \(E_8\) matrix-factorization classification.
The surviving paper candidate is that the primitive third transvectant
realizes this factorization as its principal symbol, with common scalar
cubic \(p\), and that its return algebra first fails at the degree-\(22\)
Koszul line.  No predecessor for that combined result was located in the
quick pass, but source-deep priority closure remains open.  The exact
claim disposition, read depths, cache hashes, and uncovered literature are
in `notes/2026-07-28-c682-klein-e8-literature-audit.md`.  The next audit gate
was an explicit graded gauge equivalence with the tabulated length-three
\(E_8\) factorization.

That gate is now closed.  Under the rational base change
\(Y=-h/12,\ Z=F\), compatible degree-zero gauges identify C682's two
principal blocks with the unprimed tabulated three-node pair
\((\psi_3,-172800\phi_3)\).  The bases have degrees
\((2,10,18)\) and \((12,20,28)\), both maps have degree \(30\), and the
potential has degree \(60\).  The equivalence is defined over
\(\mathbf Z[1/30]\), so it survives modulo \(11\); prime \(11\) remains an
operator/lattice issue rather than a matrix-factorization obstruction.  The
exact proof, symbolic certificate, independent two-field replay, and mystery
ledger are in
`notes/2026-07-28-c682-klein-e8-graded-gauge.md`.  The next \(E_8\) gate is
the source-deep invariant-differential-operator audit, with the mod-\(11\)
divided-power comparison to C651 as the arithmetic branch.

That audit and arithmetic branch are now closed.  Dixmier's 1992
full-text paper is the direct predecessor for binary-polyhedral
transvectants, including the exact Klein dodecic and isotypic vanishing;
Olver--Sanders supplies the full omega-process/operator background.
Neither source contains C682's finite Weyl realization, scalar-symbol
\(E_8\) factorization, or degree-\(22\) Koszul failure, so the combined
claim survives with “to our knowledge.”  At \(11\), the primitive operator
is exactly the Bockstein/Hasse transvectant
\[
\overline{\mathcal D}(f)=
\sum_{i=0}^3(-1)^i\frac{i!(3-i)!}{2}
\partial_X^{[3-i]}\partial_Y^{[i]}f
\left(\frac{\partial_X^{[i]}\partial_Y^{[3-i]}F}{11}\bmod11\right).
\]
On \(\operatorname{Sym}^6\) it is \(9\) times the primitive rank-four
matrix.  The proposed marked C651 bridge closes negatively: for the
standard order-\(60\) subgroup, all three generator defects have rank four,
and the primitive image is disjoint from the unique equivariant target
four-space.  Multiplicity one therefore cannot fix a nonexistent scalar.
The closeout computes the cause: each defect is exactly the third
transvectant with
\((\det(g)F(g^{-1}z)-F)/11\bmod11\), the mod-\(121\) lift cocycle of the
stored C651 generator.  The subsequent `tt` pass repairs the incompatibility:
for
\[
K=10X^{10}Y^2+5X^9Y^3+7X^8Y^4+8X^7Y^5+2X^6Y^6+
3X^5Y^7+7X^4Y^8+6X^3Y^9+10X^2Y^{10},
\]
the divided operator attached to \(F+11K\bmod121\) is fully
\(A_5\)-equivariant and the marked source-to-target map is scalar \(5\).
The correction is unique modulo
\(\langle X^{12},X^{11}Y,XY^{11},Y^{12}\rangle\), whose ordinary third
derivatives vanish modulo \(11\).  The `ej` pass identifies this ambiguity
intrinsically as \(V^{(1)}\otimes V\), simultaneously the complete
right-slot kernel of \((\,\cdot\,,K)_3\) and the raw infinitesimal
\(GL_2\)-orbit of the Dickson form.  Hence the repair is a canonical class
in the nine-dimensional quotient
\(\operatorname{Sym}^{12}/(V^{(1)}\otimes V)\).
The source records, exact certificate, independent replay, and mystery
ledger are in
`notes/2026-07-28-c682-invariant-operator-divided-power.md`.  The next
\(E_8\) mathematical frontier is the intrinsic meaning of \(p\) and the
other McKay blocks; the arithmetic frontier is now a conceptual
mod-\(11^3\) test for an \(11\)-adic tower of the corrected lift.

That arithmetic frontier is now positive.  A determinant-one Hensel lift
of the marked binary \(A_5\), normalized invariant dodecic modulo
\(11^3\), and independently replayed divided transvectant give an
equivariant operator modulo \(11^2\).  The first correction is the
previous \(K\)-class, differing only by \(4XY^{11}\) in the declared
Frobenius gauge; the second digit is explicit.  The marked scalar is
\(115\bmod121\), and a target-line rescaling congruent to one restores
the scalar \(5\).  The rank-five smooth presentation gate and exact
Reynolds averaging for \(11\nmid120\) upgrade the finite test to existence
of the full compatible \(\mathbf Z_{11}\)-tower.  The operator
kernel-to-cokernel Bockstein is zero, so no hidden \(11\)-torsion channel
appears: the \(V_4/V_{3'}\) rank-four splitting is flat through modulus
\(121\).  Intrinsically, \([K]\) is the normal direction of the
\(A_5\)-invariant line away from the maximally symmetric Dickson fibre,
modulo its full coordinate-and-scalar tangent space.  A further `ej2`
composition identifies the presentation root itself with the golden
sheet:
\(s=2\operatorname{tr}(ST)+1\) satisfies \(s^2=5\), and its two
mod-\(1331\) values \(1258,73\) reduce to the marked incidence scalars
\(\pm4\).  Thus the corrected tower and incidence cover have the same
quadratic character algebra and \(C_2\)-exchange.  A direct equality of
their tangent classes is ill-typed until the third-transvectant
kernel/annihilator morphism is constructed.  The report, primary
certificate, independent replay, and mystery ledger are in
`notes/2026-07-28-c682-corrected-bridge-mod-1331.md`.  The local lift
equation is closed; its intrinsic relation to the global incidence cover
or golden-fibre integral model remains open.

C682 now closes the marked special-fibre deformation map.  The ordinary
nine-dimensional dodecic normal quotient is insufficient because the
primitive Bockstein operator lies outside the ordinary third-transvectant
image.  Adjoining that one direction gives a ten-dimensional extended
normal space and a homogeneous kernel map to isotropic three-planes.  The
selected line \((1,[K])\) and its exchanger-conjugate map to two distinct
parents whose apolar four-planes meet in
\[
 \langle X^6+6X^4Y^2+6X^2Y^4+Y^6\rangle,
\]
exactly the binary line representing \(xyz\).  The known finite-etale
degree-two theorem makes these the complete marked incidence fibre, with
orientation scalars \(4,-4\).  Conversely, annihilating either parent in
the extended operator space uniquely recovers its normal line.  Thus the
correct bridge is a two-sided kernel--apolar--incidence diagram, not the
ill-typed equality \([K]=d(5J_0)\).  The proof, exact certificate,
independent replay, trust boundary, and mystery ledger are in
`notes/2026-07-28-c682-transvectant-deformation-map.md`.  The remaining
integral question is to globalize this Bockstein extension as a formal
normal-cone or first-jet map over \(\mathbf Z_{11}\).
The subsequent `ej` pass identifies the entire extended normal space with
C651's ten-pair module
\(P_{10}=\mathbf1\oplus V_4\oplus V_5\): the Bockstein coordinate is the
missing radial summand and its all-ones vector is the corrected \(K\)-line.
The exchanger line has a five-point \(A_5/A_4\) orbit of reduced isolated
rank drops.  Intersecting their five parent-annihilator four-spaces with
the fixed one recovers a complete Clebsch frame
\(q_1+\cdots+q_5=0\), with \(q_1=xyz\).

The proposed six-point exhaustiveness statement is now closed negatively,
with a stronger exact replacement.  The full projective rank-four scheme
of the ten-pair pencil is reduced of length \(22\), all of its points are
\(\mathbf F_{11}\)-rational, all kernels are fifth-transvectant-isotropic,
and the kernel map is injective.  It has the explicit split presentation
\[
 \mathbf F_{11}[t,s]/(t^{11}-t,s^2-1)
\]
and \(A_5\)-orbit decomposition \(1+5+6+10\).  The original six points
remain canonical: they are scheme-theoretically exactly the linear section
by \(\mathbf P(\mathbf1\oplus V_4)\), the star-sum subspace of the ten-pair
module.  A further `ej` pass proves that the split coordinate \(s\) is the
canonical invariant quadratic
\[
 7(\sum p_e)^2+9\sum p_e^2+10\sum_{e\sim f}p_ep_f;
\]
its idempotents split the scheme into the two stable length-eleven sheets
\((1+10)\) and \((5+6)\).  Exact Macaulay ranks \(1980/2002\) and \(4983/5005\), invertible
Bockstein multiplication, the explicit \(22\)-point parameterization, and
an independent invariant replay prove exhaustiveness and reducedness.  The
proof and mystery ledger are in
`notes/2026-07-28-c682-rank-four-resolvent.md`.

The target-side question is now closed scheme-theoretically.  In the
anticanonical Plücker carrier
\[
\ker(c_{(\,\cdot\,,\,\cdot\,)_5})
\simeq\mathbf1\oplus\operatorname{Sym}^{12}
\simeq2\mathbf1\oplus V_3\oplus V_4\oplus V_5,
\]
the \(22\) kernel planes are exactly the complementary \(\mathbf P^{10}\)
section obtained by killing the multiplicity-one \(V_3\).  In the frozen
binary basis it is
\[
p_{012}=p_{013}+p_{356}=p_{456}=0.
\]
All \(22\) intersections are transverse.  The restricted Plücker ideal has
Hilbert values \(21,22,22\) in degrees \(2,3,4\), and invariant-coordinate
multiplication is an isomorphism from degree three to four, so the Hilbert
function stays \(22\) and proves scheme-theoretic exhaustiveness directly;
this realizes \((-K_{U_{22}})^3=22\).  The two invariant target coordinates
\(u=5p_{036}+8p_{045}\) and
\(v=10p_{013}+p_{356}\) satisfy \(u^2=v^2\), recover the source sheet by
\(s=u/v\), and split the section into the length-eleven hyperplane halves
\((1+10)\) and \((5+6)\).  The exact certificate, independent replay,
proof boundary, and mystery ledger are in
`notes/2026-07-28-c682-u22-linear-section.md`.  The remaining target-side
gate is to globalize this marked \(\mathbf F_{11}\) section and invariant
pencil over the corrected \(11\)-adic tower or a characteristic-zero
family, then compare \(u/v\) with the local incidence orientation
coordinate.

The formal \(11\)-adic gate is now closed.  The complementary
\(\mathbf P^{10}\) is the kernel of the integral Bockstein contraction
\[
 Q_I=\frac1{11}B_{11}(\pi_{12}(-),I),
 \qquad
 \pi_{12}:\Lambda^3\operatorname{Sym}^6\to\operatorname{Sym}^{12},
\]
and the invariant pencil globalizes as the alternating scalar
\(\epsilon\) together with
\(\eta_I=B_{12}(\pi_{12}(-),I)/11\).  All \(22\) transverse points lift
finite-etale over \(\mathbf Z_{11}\).  Modulo \(121\), the ratio
\(r=(8\epsilon)/(7\eta_I)\) takes four values of multiplicities
\(1,5,10,6\), so the generic pencil separates the four \(A_5\)-orbits
whose reductions collide into the two length-eleven sheets.  On the two
golden incidence parents \(r_+=100,r_-=43\), while
\(\sqrt5=48\bmod121\); the exact orientation coordinate is
\[
 w=\sqrt5\,\frac{2r-r_+-r_-}{r_+-r_-},
 \qquad w=4u/v\bmod11.
\]
The nonzero midpoint \(11\bmod121\) falsifies an uncentered all-order
scalar identity.  The proof, primary certificate, independent reverse-chart
replay, scope boundary, and mystery ledger are in
`notes/2026-07-28-c682-u22-bockstein-pencil.md`.  The remaining
globalization gate is characteristic-zero and Zariski-local; the local
formal comparison is complete.

C682 now closes that Zariski globalization gate.  On an actual smooth
marked-presentation neighborhood over \(\mathbf Z_{(11)}\), Reynolds
averaging gives the invariant dodecic line and covariance makes the
order-\(11\) and order-\(12\) contractions vanish along the entire Dickson
special orbit.  Flatness therefore divides them algebraically by \(11\),
not merely in the completion.  The transverse \(22\)-section spreads to a
finite-etale degree-\(22\) family, and its tame \(A_5\)-quotient is
finite etale of degree four with stabilizers
\(A_5,A_4,D_5,S_3\).  In the split completion its complete first-order
normal form is
\[
 s^2=1,\qquad b(b-(3+2s))=0,\qquad r=s+11(4+b),
\]
giving the four orbit values \(100,43,54,45\) on orbit sizes
\(1,5,6,10\).  The within-sheet splitting speeds are \(5\) and \(1\);
their ratio \(5\) survives congruent pencil-coordinate changes, whereas
the golden-pair midpoint \(11\) does not.  The exact proof, quotient
certificate, normalization boundary, and mystery ledger are in
`notes/2026-07-28-c682-zariski-bockstein-orbits.md`.

The coordinate-free global gate is now closed.  Pulling the universal
rank-three kernel to the finite-etale \(22\)-section and projectivizing its
apolar rank-four annihilator gives exactly the base change of Hitchin's
incidence bundle.  On the radial/\(A_4\) golden pair, the common annihilator
line descends and identifies the quadratic sheet cover with the pullback of
the incidence Stein cover.  Relative trace sends the centered Bockstein
separator \(b=5e_1+e_6\) to \(5s\) in its deck-odd line:
the orbit degrees force
\(1\cdot5+6\cdot1=11=0\).  Equivalently the two split values of
\(\delta=3+2s\) are \(5,1\) and
\(\operatorname{Nm}(\delta)=5\).  This identifies the tangent factor with
the reduction of the \(5J_0\) discriminant character; the frozen pencil
normalization fixes the literal ratio \(5/1\).  The proof and scope
boundary are in
`notes/2026-07-28-c682-kernel-incidence-morphism.md`.  The remaining
geometric frontier was a canonical flattening of the operator-side kernel
map across non-constant-rank degenerations or a classical moduli meaning
for the \(D_5/S_3\) branches.

The classical moduli frontier is now closed.  The six \(D_5\) kernels are
the nonradial common-fivefold-axis mates of the marked icosahedron; their
common-annihilator pencils are exactly the exceptional Schlaefli six on the
Clebsch cubic surface.  The ten \(S_3\) kernels are the opposite-face-axis
mates over the centered pentahedral edge points
\(q_\alpha+q_\beta\), not the adjacent Eckardt differences
\(q_\alpha-q_\beta\).  Thus the complete \(1+5+6+10\) section is the
maximal-subgroup incidence star of a marked icosahedron.  Exact
reconstruction and an independent apolar replay agree.  The proof, source
boundary, and mystery ledger are in
`notes/2026-07-28-c682-incidence-moduli.md`.  The remaining geometric
frontier is the canonical flattening or a single characteristic-zero
correspondence producing all three \(A_4,D_5,S_3\) mate components
intrinsically.

C682 now supplies that characteristic-zero correspondence.  For
\(G=\operatorname{PGL}_2\), a marked \(A_5=A<G\), and
\(H=A_4,D_5,S_3\), the ambient normalizer doubles \(H\):
\[
 N_G(H)=S_4,D_{10},D_6,\qquad N_G(H)/H=C_2.
\]
The unique nontrivial coset therefore defines the symmetric correspondence
\(G/H\rightrightarrows G/A\), and the diagonal plus its three components
has degree \(1+5+6+10=22\).  Equivalently, every maximal subgroup
\(H<A\) lies in exactly two icosahedral subgroups: the marked one and its
unique mate.  This selects the distinguished \(D_5\) point from the
common-axis curve without Bockstein input and descends with the rational
icosahedral homogeneous space.  Exact \(\mathbf F_{11}\) enumeration
proves that its finite shadow is precisely the existing reduced four-orbit
section.  An `ej` upgrade cuts out the finite \((6_5,10_3)\) incidence
intrinsically: a \(D_5\) kernel and an \(S_3\) kernel are incident exactly
when their three-planes meet in dimension one.  The theorem, proof,
certificate, independent replay, scope boundary, and mystery ledger are in
`notes/2026-07-28-c682-maximal-subgroup-mates.md`.  The remaining geometric
question from that report was an operator realization and a natural source
for the complementary Schläfli six.

That operator and complementary-six gate is now closed.  Pulling the
ordinary rank-four third-transvectant map
\(F\mapsto T_F=((\,\cdot\,,F)_3)\) along the maximal-subgroup mate
correspondence realizes all four characteristic-zero components.  On the
\(D_5\) component, a mate pair has
\(U_F\cap U_{F_i}=\langle q_i^3\rangle\).  If
\(\mathcal T_i=q_i^2\operatorname{Sym}^2\) is the tangent plane to the
cubic Veronese there, then
\[
 E_i=V_F\cap\mathcal T_i=V_F\cap V_{F_i},
 \qquad
 E_i'=V_F\cap\mathcal T_i^\perp .
\]
The second cut is exactly Hitchin's pencil of cubics singular at the
\(i\)-th axis.  Over \(\mathbf Q(\zeta_5)\), the six axes
\(XY\) and \(X^2+bXY-b^2Y^2\), \(b^5=1\), give the full double-six
intersection matrix: lines in either row are pairwise skew, while
\(E_i\) meets \(E_j'\) exactly for \(i\ne j\).  Thus the complementary
six is a functorial apolar-polar companion of the \(D_5\) operator branch,
not a second mate component and not merely an externally imposed outer
automorphism.  The exact characteristic-zero certificate and independent
two-prime replay are in
`notes/2026-07-28-c682-operator-schlafli.md`.
C682 now closes the characteristic-zero \(D_5\)--\(S_3\) incidence
frontier with a necessary correction.  The literal finite kernel-rank
equation does not lift: all sixty ordinary characteristic-zero kernel pairs
are transverse.  Instead their normalized apolar cross-Gram invariant takes
exactly
\[
 \lambda_\pm=(54781\pm24288\sqrt5)/820125.
\]
Each golden level is one thirty-edge \((6_5,10_3)\) design, and Galois
conjugation exchanges it with the complementary design.  Equivalently the
centered invariant is exactly \(\pm\sqrt5\), so the incidence choice is the
golden torsor itself.  Since \(24288=11\cdot2208\), the levels coalesce at
\(5\) modulo \(11\) and their divided centered first digits are
\(\pm5\); this explains why the finite shadow is recovered by the
Bockstein operator rather than ordinary reduction.  The exact
characteristic-zero certificate, two-prime independent replay, proof, and
mystery ledger are in
`notes/2026-07-29-c682-d5-s3-kernel-incidence.md`.
The remaining local gate is only the common-marking sign that identifies the
stored mod-\(11\) matrix with the displayed plus rather than minus fibre.
The broader mysteries remain a vector-bundle extension of the cross-Gram
separator over the compactification, a global row-swap involution, and the
minimal integral base.

C682's remaining Platinum track is:

1. **QG:** prove that the generic fibre of the rate-half MDS-code to
   stabilizer-AME functor is exactly a monomial/Gale orbit.  Code duality
   is Gale association and local Fourier transform identifies the two
   equal-phase states; the new content must be the converse fibre theorem.

The independent Gold-to-Platinum fallback E3 classifies codes whose
deep-hole/legal-extension transform is a rational normal curve or
minimal-degree variety.  At \(q=11\), Clebsch simultaneously has the
smallest legal extension port \(12\) (next \(16\)), largest projective
stabilizer \(60\) (next \(12\)), least containing degree \(2\) (next
\(4\)), and discrepancy zero (next \(12\)); its minimum port is itself
the complete conic/GRS object.  The all-size full-conic conjecture says
only the \(\mathbf F_5\) frame and \(\mathbf F_{11}\) Clebsch hexagon
occur.  The report records exact gates and falsifiers.  The highest-EV TR
follow-ups are a source-deep priority audit and a divided-power/Weyl
integral model: naive reduction of the ordinary-derivative tensor has
extra degeneracies at \(3,7,11\) and does not yet recover the sharp
Mukai--Umemura bad-prime set \(2,5\).  Independently, the next QG gate is
the generic \(m=3\) local-symplectic component test.

If C182 has passed every local gate and waits only for a user-controlled
DOI, licence, or repository-release action, C577 may begin without treating
that external wait as a Paper I defect.

C321 was not triggered: Paper I retains no load-bearing Singular claim.

The authoritative split records are:

- `notes/2026-07-24-clebsch-paper-split-trial.md` — three-paper charter and
  acceptance gates;
- `notes/2026-07-24-c575-clebsch-split-disposition.md` — exact source and
  content disposition;
- `notes/2026-07-24-c575-clebsch-trust-disposition.csv` — exact 58-row
  partition;
- `notes/2026-07-24-c576-clebsch-rigidity-candidate.md` — Paper I build,
  hashes, and referee assessment.
- `notes/2026-07-24-c182-clebsch-paper-release.md` — universal-bound
  elevation, release verification, and remaining archive blocker.

## Source roots and status

| role | root | status |
|---|---|---|
| Paper I | `papers/clebsch-rigidity/` | C320 final `GO`; C182 archive/release next |
| Paper II | `papers/clebsch-factorization/` | C577 active; standalone quotient/switch opening built |
| Paper III | `papers/clebsch-passages/` | C680 local closure green; fresh PDF-only review and external submission metadata remain |
| mega-paper fallback | `papers/clebsch-hexagon-code/` | preserved unchanged with its 58-row/18-check evidence surface |

Never rename, delete, repurpose, or silently filter the mega-paper fallback.
Its manuscript, manifest, aggregate gate, and release replay remain a
matched historical surface. Do not use them to certify a split-paper source
hash.

## Paper I — rigidity and decoding

Paper I owns:

- the code--arc dictionary and explicit Clebsch parity-check matrix;
- the syndrome conic, decoding oracle, automorphisms, and complete ambiguity
  census;
- symmetry-free rigidity, the sharp numerical and nearest-conic gaps, and
  low-degree rigidity;
- Brianchon reconstruction and the intrinsic unordered `10+10` invariant
  support bipartition;
- uniqueness at `q=11`, the Clebsch-family formula, and the
  `4 <= k <= 7` classification;
- the nineteen-row Paper I claim/evidence map and its future C320 release
  surface.

Paper I has no Paper II or Paper III theorem dependency. It omits the
optional `H_3` paragraph. Exhaustive computation is load-bearing only for
the numerical gap, low-degree strengthening, and terminal small-arc
exclusion; the conic-containment implication is conceptual.

Current build:

```text
cd papers
make -B clebsch-rigidity
```

Inspect `papers/clebsch-rigidity/clebsch_rigidity.log`, not the fallback
Clebsch log.

## C320 — completed Paper I trust gate

C320 means **Paper I only**. The implementation and clean replay are complete
in `notes/2026-07-20-c320-clebsch-trust-ledger.md`. The exact formal source
pin is `bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`; the manifest is
`papers/clebsch-rigidity/verification/trust_manifest.json`.

The final verification surface is:

- `papers/clebsch-rigidity/clebsch_rigidity.tex`;
- the nineteen rows `2, 11--26, 29, 58` in
  `notes/2026-07-24-c575-clebsch-trust-disposition.csv`;
- the exact manuscript-facing map in C576's report;
- the broad fallback ledger only as a source of candidate evidence routes.

C320's implemented surface:

1. has the exact nineteen-row statement identity and manifest;
2. admits 24 Lean terminals and ten release-local exact checkers, with no
   Paper II, Paper III, or Singular route;
3. has a separate aggregate gate, axiom audit, canonical checker-output
   certificate, and fifteen-check clean release runner;
4. pins hashes, toolchains, the exact formal source commit, and manuscript
   correspondence while preserving the fallback surface byte-for-byte.

The first user-launched cold review returned `NO-GO`, commit `3ed43a0d`
repaired its findings, and its fifteen-check clean replay passed. A
separately user-launched PDF-only review then returned `NO-GO` on one
localized enumeration-boundary sentence; commit `70fb1e7f` repairs it and
its clean replay is green. A fresh separately user-launched context-free PDF
review returned final `GO`, found no blocking or material minor defect, and
independently reproduced the displayed 12-point uncovered locus,
syndrome-conic equality, and secant-index counts. C320 is complete and C182
is next.

The previous C320 `NO-GO`, 58-row manifest, 29-statement extraction, and
18-check replay belong to the mega-paper fallback. They are provenance and
evidence inputs, not the active C320 acceptance state. Do not resume the old
instruction to launch its reviewer.

## Paper II — conic-ideal quotients

C577 owns the standalone paper titled *Quadratic recovery and cubic
orientation in conic matching quotients*. Its spine is:

1. conic matching products and the general switch/divisibility quotient;
2. the `A_3/B_3/H_3` configurations, ranks `3,6,10`, and the `H_3`
   cohomological missing-layer proof;
3. quadratic recovery of the balanced sheets and cubic-first orientation;
4. self-association, the Schur-power filtration, and Gorenstein duality;
5. decorated `H_3` profiles, modular depth, arithmetic gluing, and relative
   cubic structure as mathematical appendices;
6. a final Paper II-specific verification architecture.

The opening bridge is fixed: Paper I reconstructs the Clebsch configuration
from its uncovered syndrome locus and decoding data; Paper II asks the
complementary reconstruction question of what marked secant data survives
common restriction to a conic. This is motivation, not proof inheritance.
Paper II defines its marked-conic objects and quotient independently and
must cite the final Paper I release rather than changing or extending it.

Current C577 drafting state: the opening bridge, narrowed headline theorem,
marked-conic definition, general quotient proof, switch identity, explicit
rank-three configurations, exact `3,6,10` theorem, balanced-sheet uniqueness,
cubic-first orientation, six-profile matching-row reconstruction, modular
depth quotient, arithmetic splitting/gluing, and the relative-cubic Tate
appendix are in the manuscript. The Paper II-specific verification
architecture and conclusion are drafted and their full local replay is
green. The technical rereads and post-spine staged cold read are `GO`;
release still requires the user-controlled immutable public evidence
locator.

### Outward-consequence bridge

The introduction may use one compact paragraph to show that the rigidity
geometry has mathematical consequences outside the three-paper sequence.
Keep the interfaces and their strengths distinct:

| Destination | Exact earned connection | Placement and boundary |
|---|---|---|
| prescribed-hole arcs | Paper I's conic-filling equality and uncovered-locus reconstruction are the exceptional small-arc face of the general defect and forward/inverse reconstruction theory | Paper I keeps its existing proposition-level citation; C182 must resolve the public provenance target. Paper II may name the general framework as context, not import a proof from it. |
| projective cap game / CGT | This is the source problem as well as a consumer. Frame reduction and conic localization of the odd-plane game exposed the exceptional `q=11` six-arc. The `4<=k<=7` equality classification then leaves only the `q=5` frame and `q=11` Clebsch hexagon as full-conic seals. The `q=11` seed is a certified P-position whose conic extension complex is the icosahedron independence complex `1+12t+36t^2+20t^3`. | Present this as an origin-and-return loop, not a one-way application. It is a finite base case and response-packet template, not a proof of the all-odd-`q` cap-game kernel or the `(ON)` response theorem. |
| AME/LU | The `H_3` six-arc gives an `[6,3,4]_{11}` MDS code and hence a minimum-support stabilizer `AME(6,11)` state. Projective rigidity fixes the discrete geometric input; the separate AME/LU theorem proves the LU-to-LC and scalar-invariant conclusions. | Use the arc--MDS--AME dictionary as a genuine application. Do not suggest that Paper I proves LU rigidity, or that Paper II's quotient theorem is needed by the AME/LU paper. The detailed backward citation belongs in the AME/LU introduction when both releases are citable. |
| PRS beyond redundancy four | Both programs begin from projective syndromes as uncovered points/MDS extensions. The beyond-four paper shows that this geometric viewpoint scales to normal rational curves via Hankel systems and coherent polar flags. | This is reach of the method, not a corollary of Clebsch rigidity. Mention only as a continuation of the syndrome/uncovered-point mechanism; do not claim that the Clebsch equality or decoder proves a higher-redundancy classification. |

Paper II's working introduction now contains this paragraph. Add exact
bibliographic citations when its bibliography is integrated. Do not reopen
the final-GO Paper I bytes to add a program survey. Paper III may synthesize
these four avatars only if C579 first produces a principal theorem that makes
them consequences or applications; otherwise retain this map as editorial
routing rather than manuscript prose.

The projective cap game has no citable public paper yet. Any manuscript
mention must therefore be self-contained: define the normal-play rule
(players alternately adjoin a point while keeping an arc; no legal move
loses), state only the exact finite consequence proved in the local
argument, and do not ask the reader to recognize `C80`, `(ON)`, `K_Omega`,
or any internal program name. Those identifiers belong only in routing and
verification records.

The exact cap-lane return path is:

```text
odd-plane frame reduction and conic-localized escape
  -> exceptional q=11 six-arc / full-conic seal
  -> Clebsch rigidity and icosahedral continuation geometry
  -> A5 orbitals, edge-to-pair packets, and marked-response compression
  -> C80 strict-overload kernel K_Omega and the Rmax incidence packet
```

The proved C80 payoff is finite but substantial: `K_Omega` agrees with exact
P/N values on the exhaustive `q=5,7` residual domains, selects exactly the
135 P roots among all 210 raw `q=11` on-conic roots, and passes the stated
`q=13,17` frozen gates. On the 135 `q=11` P roots, `Rmax` contains a
lower-kernel response on all 2,720 certified marked edges. The Clebsch
geometry supplies the exceptional seed, symmetry, and compression language;
C80 separately supplies the game-value kernel and finite certificates.

Do not promote the return path to the uniform crown. The current C80 records
also prove that fixed-depth `capOK` absorption cannot scale: an `s`-cap with
`capOK` forces `q<=binom(s,2)`, so response depth must grow with `q` or use a
different P-guard. The q=17 marked-head exceptions split into five orbits,
and the observed `Rmax` bulk is boundary absorption rather than a proved
positive-overload exchange law. C82 therefore remains gated on a uniform
membership/response theorem.

### Paper I “teeth” candidate audit

Paper I already contains its two strongest broadly legible consequences:
decoder ambiguity reconstructs the Brianchon geometry, and a degree-at-most-
three vanishing test recognizes the Clebsch class. If the introduction or
conclusion is ever reopened, foreground those existing theorems before
adding another research program.

The only new outward examples strong enough to merit a Paper I sentence are:

1. **Simultaneous MDS extensions / complete arcs.** The twelve deep-hole
   directions have icosahedral conflict graph, with independence polynomial
   `1+12t+36t^2+20t^3`; its maximal faces give exactly six complete
   eight-arcs and twenty complete nine-arcs over the fixed seed. This is a
   direct, certified continuation consequence and has a public provenance
   route through the prescribed-hole arcs paper.
2. **Self-contained cap-game origin.** Define the placement game in one
   sentence, then say that the Clebsch seed localizes play to the icosahedral
   continuation graph and is a P-position by antipodal pairing. This is
   mathematically clean and explains why the object was studied, but because
   the cap-game paper is unpublished it must include its own definitions and
   the short argument.
3. **AME state.** The displayed `[6,3,4]_{11}` code gives the equal-phase
   minimum-support stabilizer `AME(6,11)` state by the standard MDS--AME
   dictionary. This fact is immediate and citable independently of the
   separate LU paper. Stop there: LU-to-LC rigidity and marginal separators
   are the AME/LU paper's theorems, not Paper I consequences.
4. **Algorithmic recognition / robustness.** Recast the existing
   low-degree and gap theorems as an exact recognition certificate: compute
   the uncovered syndrome locus and its cubic evaluation rank; acceptance
   identifies the Clebsch class, while a one-point perturbation changes at
   least eighteen locus points. This adds no claim and may communicate the
   strength better than another external application.
5. **Quadratic-Frobenius pair extension.** Regard the displayed
   `F_11`-rational hexagon as an invariant six-arc in `PG(2,11^2)`. Exactly
   76 `F_11`-lines avoid it, and each carries
   `(11^2-11)/2=55` nonfixed conjugate pairs. Because every old secant is
   fixed, all `76*55=4180` pairs are legal; after selecting one extension,
   the remaining `4179` are alternate pair repairs. This is a clean direct
   corollary of the Baer/Frobenius pair-extension mechanism. Its numerical
   count is shared by every `F_11`-rational six-arc, so present it as reach
   of the arc/MDS object, not as another Clebsch characterization.
6. **Positive-density complete repair ports.** For the Clebsch
   `[6,3,4]_{11}` code, the dual is `[6,3,4]`; at every target coordinate
   the minimum pointed dual word has weight four and
   `z_x=4+4=8`. The prescribed-port theorem therefore transfers the entire
   radius-five coefficient-valued port (`6<8`) to density `1/6` in an
   asymptotically good fixed-`F_11` concatenated family. Its minimal support
   clutter is the generic complete three-uniform hypergraph on five helpers
   (ten locality-three supports, matching number one, transversal number
   three). The potentially Clebsch-specific content is the coefficient
   layer: the normalized repair vectors through one target span `C^perp`
   and hence recover the inner code. Prove and trust-map that reconstruction
   lemma before claiming that Clebsch rigidity, rather than only generic MDS
   locality, survives transfer.

Do not use the following in Paper I: beyond-redundancy-four PRS (method
reach only), the Paper II Coxeter/reflection theorem (wrong owner),
Mathieu-hexad transversality (correct but decorative/negative), checked
isoduality (minor side fact), or the still-open orbit-labelled repair
hypergraph agenda. The exact complete-port transfer theorem exists, but its
Clebsch-specific coefficient-reconstruction specialization is not yet a
paper result.
Any new cap, extension-complex, AME, Baer-extension, or repair-port
theorem-like statement would change Paper I's nineteen-row trust surface
and require a fresh release review; a pure motivation sentence or reframing
of an existing theorem would not.

Forwarded to the owning papers on 2026-07-24:

- **complete-ports:** the manuscript proves that the full normalized
  pointed coefficient port reconstructs `C^perp`, instantiates `z_x=8`,
  and derives density `1/6` in an asymptotically good fixed-`F_11` family;
- **Baer/Frobenius:** the manuscript proves the exact `4180/4179`
  Clebsch-over-`F_121` extension/repair corollary.

Both papers cite *A conic deep-hole syndrome locus characterizes the Clebsch code* as a
working paper and state their generic-MDS/generic-six-arc boundaries.
Neither forward bridge changes Paper I or reopens its final-GO release
surface.

Use C399 as the conic-phase prelude and C403/C406/C411 with selective C412
upgrades. Credit Edge and Dye for the exceptional configurations and avoid
novelty claims for the raw `5/14/22` marker spaces, parent ambiguity, the
`B_3` `3+6` split, or conic--GRS identification.

Treat the specialist review's proposed `SC(j)` repair as an unverified
hypothesis, not a patch: independently derive and check every
characteristic, equivariance, and quantifier condition before it enters
Paper II.

Primary planning inputs:

- `notes/2026-07-20-c399-literature-audit.md`;
- `notes/2026-07-20-c406-matching-module.md`;
- `notes/2026-07-20-c406-priority-audit.md`;
- `notes/2026-07-20-c411-double-coset-hecke.md`;
- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`.

Passage, holonomy, torsor, theta/Fourier/quantum, Mathieu, and
characteristic-zero material is inventory-only during C577.

## Paper III — arithmetic Hitchin--Clebsch orientation cover

The imported ChatGPT reports identify a credible principal theorem: the
golden Clebsch orientation torsor is an arithmetic fibre of Hitchin's
ordered-icosahedron double cover. The candidate theorem joins
\(w^2=5J_0\), \(J_0|_{V_I}=16\sigma_3^2\), the golden fibre
\(\operatorname{Spec}\mathbf Q(\sqrt5)\), and the mod-\(11\) deck exchange
with \(T_{11}\). Its provenance, exact current evidence boundary, and
acceptance plan are in
`notes/2026-07-26-c579-hitchin-clebsch-paper-iii-plan.md`.

C651 is complete and archived: an explicit \(A_5\)-equivariant isomorphism from the
ten-pair permutation module to Paper II's quotient module has been verified
on all 60 elements, and the transported signed cubic restricts to
\(4\sigma_3\) over \(\mathbf F_{11}\). The certificate, independent replay,
prose proof, and Lean terminal are recorded in
`notes/2026-07-26-c651-hitchin-tensor-bridge.md`. Because the rational Gaunt
scalar has denominator divisible by \(11\), the cross-characteristic bridge
is the common integral Clebsch cubic line rather than reduction of that
scalar. The serialized import-only gate and its exact-target trace replay
are green, with the native-decision boundary unchanged. C652 is complete:
Section 4 now proves the golden fibre, unique
common cubic, \(A_4\) hinge, order-four exchanger, spinor class,
\(T_{11}\) reduction, and marked Hitchin--Mathieu torsor in prose. A compact
primary certificate and independent replay check only the explicit
projective substitutions and the two \(M_{11}\) carriers, their frozen
\(\operatorname{PSL}_2(11)\) intersection, \(M_{12}\) join, and Hadamard
parent exchange. The report and mystery ledger are in
`notes/2026-07-26-c652-arithmetic-cover-certificate.md`. C653 is complete:
the rational incidence extension is the \(5J_0\)-twist, the abstract
quadratic algebra is etale away from \(2,5\) and its branch, the classical
invariant presentation is used over \(\mathbf Z[1/30]\), and the geometric
incidence comparison retains an unspecified finite bad set. Hitchin
already owns the degree-two incidence cover and Dye the square-\(5\)
field criterion, so Paper III's novelty is the arithmetic normalization,
the \(p=11\) specialization, and the cross-characteristic cubic line. The
report and source-depth audit are in
`notes/2026-07-26-c653-hitchin-integral-novelty-gate.md`. C579 then
rebuilds Paper III around the arithmetic orientation theorem and creates
its independent trust surface.

The imported targets-4/5/7/8 report adds the conceptual interpretation of
C651: after localizing at the square of a nonzero odd element, an involutive
integral algebra is the direct sum of its invariant algebra and one odd
generator times that algebra. On the sign-twisted Clebsch four-space the
first odd invariant is \(e_3=\sigma_3\), so orientation forgetting is
generically quadratic and cubic recovery reads the missing sign. C653 must
verify the classical \(A_5\)-invariant-ring citation and characteristic
scope before manuscript integration. The report's marked
Hitchin--Mathieu torsor remains conditional on the carrier identifications
now added to C652. Its continuation-rigidity and repair-port targets remain
outside the clebsch lane. Provenance and exact disposition are recorded in
`notes/2026-07-26-c579-hitchin-clebsch-paper-iii-plan.md`.

The Klein intermediate-Jacobian kill test removes the proposed invariant
elliptic factor and replaces it by the canonical two-dimensional
\(A_5\)-multiplicity Hodge structure in
\(H^1(J(X),\mathbf Q)|_{A_5}\simeq W_5\otimes U\). Roulleau supplies the
CM product \(J(X)\cong E^5\) and the 55-curve index-two lattice; Hartlieb
supplies the relevant characters and the one-dimensional \(A_5\)-special
family. C654 is complete. The two \(A_5\) commutants are
\(M_2(\mathbf Q)\), their intersection is
\(\mathbf Q(\sqrt{-11})\), and the canonical Reynolds mixed operator has
spectrum \(1,1,1/12,1/12\). Its noncommon discriminant is zero, not five,
so the simple Klein period-lattice lift closes negatively and its detachable
Paper III section has been removed. A full conjugacy-class trace fingerprint
identifies the carrier with Hartlieb's rational \(5+\overline5\), and a
\(K\)-bimodule/character-trace argument derives \(1/12\) from
\(\operatorname{tr}(P_+P_-)=13/6\) without matrix diagonalization.
The exact certificate, independent
replay, trust boundary, and mystery ledger are in
`notes/2026-07-26-c654-klein-relative-position.md`.

C579 is complete as a candidate-synthesis task. The twelve-page manuscript
*The Clebsch orientation
cubic: arithmetic covers and icosahedral harmonics* has one page-one theorem
with two legs: the rational \(5J_0\) orientation cover and explicit
golden-fibre \(T_{11}\) specialization, and the exact degree-six
face-axis Gaunt--Steinhardt realization of the same integral cubic line.
The cold review is `GO`. It repaired the entering draft's only material
scope defect by restricting good reduction at \(11\) to the displayed
golden fibre and exchanger; the global geometric incidence comparison
retains its unspecified finite bad set. The failed Klein lift is not a
manuscript leg, the 55-curve saturation question remains outside C579, and
all materials utility remains empirical.

Human invariant-theoretic, spinor, Petersen, and spherical-moment arguments
carry the paper. Certificates only audit explicit matrices, finite carriers,
contractions, and constants. Lean is absent from the release-critical path;
the existing finite tensor terminal is an optional literal-tensor backstop.
Nine theorem-like statements, twelve claim rows, three independent exact
evidence pairs, and the warning-free build pass the aggregate gate. The
report and mystery ledger are in
`notes/2026-07-26-c579-paper-iii-synthesis-cold-review.md`.

That local `GO` is not the publication verdict. A later cross-window
editorial read judged the arithmetic--harmonic triangle strong but the
audience, contextualization, and central dependency shape unresolved. It
specifically requires more explanation of the global rational square class
before specialization, a decision on whether the marked Mathieu carrier is
mathematically necessary, removal of tentative physical-language and
research-inventory distractions, primary-source coverage commensurate with
the four literatures invoked, and an author name on the title page. C669
completed the literature and claim-ownership audit: it identifies the
\(5J_0\) normalization plus the mod-\(11\) and degree-six realizations as
the paper-owned bridge, adds the missing primary context, and determines
that both the marked Mathieu torsor and the speculative descriptor should
be removed. C668 implemented that entering disposition. Its
seven-statement, nine-row candidate is superseded by the C670 cut and C680
closure brief. The two entering revision reports are
`notes/2026-07-26-c669-paper-iii-context-literature-audit.md` and
`notes/2026-07-26-c668-paper-iii-focused-note-revision.md`.

C670 supplied the subtractive disposition and harmonic normalization.
C680 corrects its arithmetic descent statement, closes the local fibre
comparison, and replaces its private release bundle.  Do not revive the
deleted finite bridge.  The only remaining `clebsch-passages` gates are the
fresh PDF-only review and external submission metadata recorded above.

C664 is complete.  It implements the generic involutive odd-unit splitting and the
general \(K(n,2)\) pair-sum eigenspace theorem, including the full
four-dimensional Petersen \((-2)\)-eigenspace at \(n=5\).  Both symbolic
leaves elaborate warning-free with no generated data, imported certificate,
`native_decide`, new axiom, or admitted declaration.  The serialized
import-only gate and exact-current aggregate replay pass, and all twelve
audited terminals use only `propext`, `Classical.choice`, and `Quot.sound`.
The optional golden-exchanger leaf is omitted.  The implementation report and
mystery ledger are in
`notes/2026-07-26-c664-paper-iii-lean-mechanisms.md`; the Paper III release
gate remains independent of Lean pending a separate correspondence decision.

C655 is complete. The ten icosahedral face axes give an exact
\(1+4+5\) subspace of \(\mathcal H_6\), the four-space is the Petersen
\((-2)\)-eigenspace, and the spherical cubic restricts to
\(-784000/1247103\,\sigma_3\). Its exact conversion to the standard
unnormalized Steinhardt invariant is
\(\int F^3=-130/\sqrt{3553\pi}\,W_6(F)\). A task-owned certificate,
independent replay, primary-source audit, and warning-free manuscript
integration are complete. The physical claim is exact equality of
observables on the decorated four-channel; predictive materials utility is
not claimed.

The previous carrier, marked Mathieu, four-sheet holonomy, theta, Fourier,
quantum, and degree-23 coherence material remains inventory and is not
retained by Paper III. Paper II stays
closed to the characteristic-zero bridge apart from a possible short forward
reference to the completed Paper III.

## Shared verification and release policy

Each split paper gets its own statement identity, claim manifest, aggregate
gate, replay entry point, toolchain pins, adequacy appendix, and
AI/provenance disclosure. Shared Lean sources stay in the pinned standalone
Lean repository; no split paper inherits trust from the fallback aggregate
gate merely by importing related terminals.

Paper I ships after `arcs` supplies the public provenance target for the
shared deep-holes-equals-conic identification. C182 packages only the
C320-approved Paper I surface. Paper II still requires its separate release
pass. Paper III's local pass is complete; its immutable public artifact
locator remains an external packaging gate.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Results from those
lanes may be consumed read-only only when the split disposition explicitly
admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation does
not add it to any paper or allocate work.

## Historical records

- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; the full superseded record is
  `notes/2026-07-20-clebsch-paper-planning-archive.md`. Neither is an active
  routing source.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
- Former replacement-spine abstract and presentation drafts:
  `notes/2026-07-21-clebsch-paper-abstract-outline.md`,
  `notes/2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`,
  `notes/2026-07-22-clebsch-geb-design.md`, and
  `notes/2026-07-22-clebsch-geb-design-red-team.md` — fallback/history,
  not active split-paper instructions.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
