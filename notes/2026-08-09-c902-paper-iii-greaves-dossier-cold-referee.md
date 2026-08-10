# Paper III: Greaves/Suda dossier cold-referee report

Date: 2026-08-09  
Referee stance: independent conference-design / two-graph cold read  
Verdict: **MINOR**

## Frozen object and isolation record

I verified before reading that the repository was at
`41d989ebaa977b7d194a1e0425ed6028f5a43fe0` and that
`papers/clebsch-passages/clebsch_passages.pdf` had SHA-256
`f5e34cfd5c3c049acff0739fae1662f3f8deb11758cdab6e8251bb4c2bd29905`.
I read the complete 33-page PDF before consulting the authorized persona packet,
assigned literature, or public supplement. I did not inspect C902 notes, a queue or
handoff, prior reviews, git history, git diff, manuscript sources, or another persona
packet.

My PDF-only verdict was **MINOR**. The packet, primary sources, and public supplement
did not change it.

## 1. Strongest theorem package

The paper proves a coherent three-stage package. First, it identifies the rational
quadratic field and normalized Stein algebra of Hitchin's incidence cover as

\[
  \mathbb Q(\mathbf P(H))(\sqrt{5J_0}),\qquad
  \mathcal O\oplus\mathcal O(-3),\quad z^2=5J_0,
\]

using a reduced branch-cycle calculation and the complete nonsplit fibre at `xyz`.
Second, after an explicitly nonintrinsic marked bridge datum is supplied, it transports
the deck sign to the order-six golden conference carrier and proves that one cubic is
simultaneously triangle holonomy, a middle-exterior diagonal, a commutator Pfaffian,
and an oriented cross-golden determinant; its six outer translates recover the
Joubert--Segre--Igusa--Clebsch chain. Third, the same carrier yields two independent
combinatorial theorems: cut-independent balanced exchange spectrum characterizes the
realized nontrivial order six case, and aligned four-sets determine every two-graph on at
least seven labelled vertices up to complement, hence recover conference signings from
order ten onward up to switching and global negation. The marked Petersen map then
returns the exact degree-six harmonic cubic.

## 2. Causal proof reconstructed without the supplement

The incidence variety is a rational, normal, integral projective bundle over Hitchin's
Grassmannian model. Its generic degree is two. The canonical-class calculation puts the
ramification divisor in class `3h`, hence its branch cycle in class `6h`; Hitchin's dense
real boundary identifies the irreducible sextic `J0=0` as that reduced cycle. Since
`Pic(P(H))` has no 2-torsion, a quadratic extension with precisely this odd valuation
locus is `K(sqrt(cJ0))`. At `xyz`, the cover is finite etale and its complete reduced fibre
is `Q(sqrt(5))`, while `J0(xyz)` is a rational square, forcing `c=5`. Trace splitting and
reflexivity then give the normalized algebra and its `O(-3)` odd summand.

Pulling back to the Clebsch chart gives `z^2=80 sigma_3^2`; its normalization is the
disjoint pair of chart components. A chosen component does not create labels. Once the
axis ordering, chart lift, outer labels, and Petersen labels are fixed, the golden
exchanger sends the displayed conference source `(C,Z)` to `(-C,-Z)` and reverses the
normalized lift. This is a relative marked compatibility statement, not an intrinsic
global conference labelling, and the paper consistently says so.

For the operator theorem, `C^2=5I` supplies pair balance. Complementary `3 x 3` minors
of `C` are four times its triangle products, so the middle-exterior diagonal and the
matching expansion of `Pf[D_x,C]` both give `4Z`. Splitting into the two golden
eigenspaces gives the cross-block form of the commutator; its determinant gives
`Z^2=500 det(B)^2`, and compatible determinant-line orientations choose the stated
sign. The six explicit outer sign words then identify the classical Joubert frame, from
which the cited Segre and Igusa relations follow.

For a balanced cut of a general symmetric conference matrix,
`RR^T=qI-A^2`, so the exchange eigenvalues are `1-alpha_i^2/q`. Expanding
`tr(A^4)` by support gives the affine `32 c_Y` term. If this is cut-independent for
`d>=4`, characteristic-zero full rank of the four-set-to-`d`-set inclusion matrix forces
the aligned indicator to be constant. Switching at one vertex then reduces the two
constant cases to an impossible all-monochromatic signing or a two-colouring of
`K_{2d-1}` with no monochromatic triangle. The small cases give order six and spectrum
`{1/5,4/5,4/5}`.

For reconstruction, rooting a two-graph converts each aligned four-set through the root
to a homogeneous triple of a graph. `R(3,3)=6` supplies an anchor. Four anchor tests
recover each normalized outside cut except for three balanced cuts; pair tests and the
third outside point remove that ambiguity. Seven-point restrictions then glue through a
common triple, leaving one global complement bit. The identity
`det C[Q]=3-2w(Q)` converts this to the conference statement.

Finally, the labelled pair-sum map is the Petersen `(-2)`-eigenspace. The addition
theorem gives an injective zonal map; multiplicity one reduces its invariant cubic to one
point-stabilizer-fixed vector, whose exact spherical moment fixes the coefficient.

## 3. Earliest implication not justified from the text and assigned sources

The earliest implication I cannot independently certify from the text plus Packet G is
the identification of the six explicit sign rows with the *classical signed Joubert
coordinates*, and hence the invocation of the Segre and Segre--Igusa relations. The
paper attributes this to Howard--Millson--Snowden--Vakil, but that source is outside the
assigned Greaves/Suda packet. The displayed rows themselves are fully auditable and I
recomputed them; what remains outside this packet is the classical-name and invariant-
theory identification. This is an audit boundary, not evidence of a mathematical error
or citation overreach.

## 4. Fields, signs, labels, equivalences, and exceptional orders

- The Clebsch chart is correctly kept over `Q(sqrt(5))`; the rational object is the
  incidence cover and its descended union, not a rational inclusion of the fixed chart.
- Normalization versus the meeting of the unnormalized branches is stated correctly.
  The complete fibre at `xyz` is used only in the finite etale locus.
- The `-8000` norm sign is consistent: conjugation swaps the two rank-three golden
  eigenspaces, and the odd block swap changes the determinant-line contraction by
  `(-1)^(3*3)=-1`. Together with `Z=10 sqrt(5) det(B)`, this gives
  `det[D_x,C]=16Z^2=-8000 N(det B)`.
- Axis switching, relabelling, five-label transport, chart scaling, global negation, and
  deck exchange are not conflated. In particular, the inverse theorem is labelwise and
  concludes switching plus global negation; vertex reordering is a separate operation.
- The symmetric conference order restriction is handled correctly. The `d=2` algebra is
  a formal small case, while order six is the unique nontrivial *realized* cut-independent
  case. The reconstruction corollary starts at order ten, as it should.
- The integral finite-field comparison retains an unspecified finite exceptional set and
  does not promote the explicit mod-11 specialization to a global good-reduction theorem.

## 5. Classification of issues

I found no false statement and no proof gap in the headline package. The assigned
citations support the conference determinant fibres, design parameters, complementary
spectral input, two-graph terminology, and inclusion-rank step at the claimed depth.
The one requested revision is a normalization/exposition repair. The remaining friction
is density, not correctness.

## 6. Ranked findings and verdict

1. **Normalization/exposition — minor effect.** In Theorem 5.1,
   `B_T=P_{T,-}D_xP_{T,+}` is first written as a `6 x 6` ambient operator, for which the
   literal ordinary determinant is zero. The intended determinant is the determinant-line
   element of the restricted map `V_{T,+} -> V_{T,-}`, as explained only later in “Why
   the determinant.” Define that restricted map at first use and state there how the
   inherited pairing and transported orientations trivialize
   `det(V_- ) tensor det(V_+)^{-1}`. The same paragraph should give the one-line
   odd-rank contraction producing the minus sign in the field norm. The present meaning
   is recoverable and the formula is correct, but a headline identity should not depend on
   retroactive interpretation.

2. **Citation/exposition — very minor effect.** The transition from the explicit six-row
   table to the named Joubert frame is appropriately attributed, but the exact pinpoint is
   spread over several subsections of reference [13]. Adding the precise proposition or
   displayed formula that matches the paper's sign convention would make the claimed
   normalization independently checkable without changing the proof.

**Verdict: MINOR.** Neither finding changes a theorem, parameter, equivalence relation,
or sign after the intended determinant-line convention is made explicit.

## Independent recomputations

I did not treat verification output as proof. Independently of the supplement, I checked:

- `C^2=5I`, pair balance, all twenty triangle/complementary-minor signs, and all six
  coefficient words in (5.1);
- `Pf[D_x,C]=4Z`, the block determinant factor `(2 sqrt(5))^6=8000`, and the negative
  determinant-line norm convention;
- `tr(A^4)=d(d-1)+12 binom(d,3)+8 sum_Q w(Q)`, hence the coefficient `32c_Y`;
- from the Greaves--Suda `3-(4m+2,4,m-1)` design, the translation
  `lambda=(d-3)/2`, density `rho=(d-3)/(2(2d-3))`, and the stated mean and variance;
- for a Paley conference matrix of order ten, exactly thirty determinant-`(-3)` blocks,
  one through each triple, and the projective balanced-cut split `36/90` with
  `c_Y=0/1`;
- exhaustive rooted enumeration on seven vertices: the 32768 two-graphs give 16384
  aligned signatures, every fibre consisting exactly of one complement pair; the two
  six-vertex examples in Remark 5.5 have the same aligned family and are neither equal
  nor complementary;
- the Petersen kernel eigenvalues and pair-sum tightness; and
- a fresh exact expansion of the spherical moment at
  `y=(4,-1,-1,-1,-1)`, obtaining
  `-15680000/1247103`, hence `-784000 sigma_3/1247103`.

## 7. Contribution relative to Packet G

Relative to Greaves--Suda's forward determinant-fibre 3-design and the classical
conference/two-graph inputs, the paper turns the same order-six conference carrier into
an exact oriented cubic operator and proves the new inverse and rigidity directions:
balanced exchange cut-rigidity and aligned-design faithfulness up to complement.

## 8. Advances in Mathematics bar

Assuming the proofs stand, the article meets the significance bar: the exact arithmetic
twist, four-way operator identity, balanced-exchange classification, sharp two-graph
reconstruction theorem, and harmonic return are individually nontrivial and unusually
well normalized. It also has a real common mechanism—the marked golden conference
carrier—rather than merely a list of unrelated results. Cross-field readability is close to
the bar but not effortless: the first-pass route, caveats, and marking appendix help, while
the determinant-line point above and the density of Section 5 should be repaired before
submission.

## Supplemental inspection and effect on findings

After freezing the PDF-only assessment, I inspected only these public supplemental files:

- `papers/clebsch-passages/README.md`;
- `papers/clebsch-passages/ARTIFACT.md`;
- `papers/clebsch-passages/literature-boundaries.md`;
- the `ORIENT-1` and `OPER-1`--`OPER-4` rows of
  `papers/clebsch-passages/verification/trust_manifest.json`.

No supplemental file changed a finding or the verdict. They clarified the declared proof
and literature boundaries, but I did not use them as proof premises and did not run the
verification programs.

---

## Sealed regrade — 2026-08-09

This section is an append-only regrade of the frozen report above. The original report is
preserved verbatim.

I verified the repaired authority commit
`6e05b2d5405c1f00f88922dccf8ed49863b77c6c` and repaired PDF SHA-256
`3251cb90a915e253ffdd01909174ff9248282ccb06e1a5b1705f308e64ab9d19`
before reviewing. I read only the repaired PDF passages requested: Theorem 5.1(2), its
proof, Theorem 5.2, the following “Why the determinant” paragraph, and the tiny edit in
the golden-involution paragraph. I did not inspect diffs, history, C902 notes, or other
reviews.

### Disposition of the determinant-line finding

The repair fully resolves Finding 1.

- `V_{T,+}` and `V_{T,-}` are now defined at first use, and `B_T(x)` is explicitly the
  restricted map `V_{T,+} -> V_{T,-}`, so its determinant can no longer be misread as
  the zero determinant of a rank-three ambient `6 x 6` operator.
- The theorem immediately locates the intrinsic determinant in
  `det(V_{T,-}) tensor det(V_{T,+})^{-1}`.
- It states how the inherited symmetric forms and transported orientations trivialize
  that determinant line before writing the scalar identity
  `Z_T=10 sqrt(5) det B_T`.
- It gives the missing sign calculation where it belongs: Galois exchange swaps two
  rank-three summands, so the determinant-line contraction contributes
  `(-1)^(3*3)=-1`, yielding
  `det[D_x,C_T]=-8000 N_{E/Q}(det B_T)`.
- The proof's block matrix still gives the same magnitude:
  `(2 sqrt(5))^6=8000` and `Z_T^2=500 det(B_T)^2`. Thus the inserted sign convention
  agrees with, rather than modifies, the previously checked formula.

The shortened “Why the determinant” paragraph now appropriately refers back to the
already-defined restricted determinant. It retains the basis-free determinant/permanent
contrast without duplicating the norm argument.

### Other repair checks

The Theorem 5.2 copy edit from an anaphoric reference to “the off-diagonal entries” is
clear and mathematically unchanged. The golden-involution transition now separates the
explicit transported-conjugation calculation from its deck-exchange consequence more
cleanly; it introduces no change in meaning and makes the role of the lone switching sign
easier to follow.

I found no new correctness, normalization, exposition, or layout defect. The page break
after the opening commutator identities leaves all new determinant-line definitions
together at the top of the next page; the block proof, Theorem 5.2, and “Why the
determinant” paragraph remain well spaced and readable. The small square at the end of
Theorem 5.2's proof is the normal proof-ending mark, not a rendering artifact.

The original Finding 2 about a more exact Howard--Millson--Snowden--Vakil pinpoint
remains optional editorial advice, not a correctness or acceptance condition. It did not
drive the frozen `MINOR` verdict.

### Final regraded verdict

**GO.** The only requested mathematical-normalization repair is complete, exact, and
cleanly integrated. No new defect was introduced.
