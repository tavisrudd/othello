# C620 — split-freeness on higher Lucas modular carriers

**Lane:** `reed-solomon` · **Date:** 2026-08-02 · **Status:** mathematics and
reproducibility complete; independent specialist review pending

## Result

Let (k=mathbf F_{2^m}), (mge4), and let

\[
 \mathcal M_9=\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle
 \subset\mathbf P(\Gamma^9E).
\]

The split-free locus of the first fresh higher Lucas carrier is empty:

\[
 \boxed{\mathcal M_9(k)\cap\{\text{split-free syndromes}\}=\varnothing.}
                                                               \tag{1}
\]

Equivalently, every one of the

\[
             |\mathcal M_9(k)|=1+q+q^2+q^3+q^4+q^5             \tag{2}
\]

projective carrier points has a completely split squarefree degree-eight
member in its two-row Hankel kernel.  This holds over every field in which the
full-length redundancy-ten PRS problem is admissible.  Consequently the
carrier contributes no code deep holes, regardless of which applicable
covering-radius theorem is used: membership in the contraction kernel holds,
split-freeness fails everywhere, and there is nothing to promote.

The proof separates the invariant block already closed by C530/C531/C578 from
the genuine two-moduli complement.  Put

\[
 U=\langle e_2,e_3,e_6,e_7\rangle,
 \qquad \mathcal M_9/U\simeq\det^4\otimes E.                \tag{3}
\]

C530, C531, and C578 prove every point of \(\mathbf P(U)(k)\) shallow for
every (m\ge4).  For the complement, an exact six-root/final-pair reduction
gives a geometrically nonconstant Artin--Schreier curve of genus at most one.
A sharpened coordinatewise selection bound supplies a good rational slice for
every (q\ge32), and Hasse--Weil beats the exact 48-point deletion from
(q=64).  The only remaining fields (q=16,32) are closed on the intrinsic
orbit quotient: respectively 292 and 1090 Borel orbits, each with an explicit
eight-root witness and an independent replay.

There is also a sharp negative answer to the proposed linearized-polynomial
criterion.  Over (mathbf F_{16}), the complete projective
subspace-polynomial family has 510 distinct eight-divisors, but 101 of the 292
complement orbits have no witness in that family.  All 101 nevertheless have
ordinary split squarefree witnesses.  Thus subspace polynomials give a useful
sufficient section, but not an exact split-freeness criterion even on the
first fresh carrier.  The exact uniform replacement is the final-pair linear
system plus its Artin--Schreier trace condition in §5.

The placement decision is **Version 2 of the beyond-four paper**, not a
separate modular-carrier companion.  Equation (1) directly evaluates C820's
first new maximal Lucas carrier and removes C532's last two-dimensional
residue.  The general final-pair criterion belongs as the arithmetic lemma;
the 101-orbit obstruction belongs as the warning that the linearized section
is not exhaustive.  No stronger all-digit-pattern classification is claimed.

## 1. The two-row kernel

Write a carrier point as

\[
 z=(z_2,z_3,z_4,z_5,z_6,z_7).
\]

For (f(t)=\sum_{j=0}^8 f_jt^j), the Hankel kernel equations are

\[
 \sum_{i=2}^7z_if_{i-1}=0,
 \qquad
 \sum_{i=2}^7z_if_i=0.                                    \tag{4}
\]

They are intrinsic: an inverse projective change of variables acts on (z)
in the divided-power module and contragrediently on the root divisor of (f).
Coefficientwise Frobenius commutes with both actions.  Thus one split
squarefree member at an orbit representative transports across its complete
(PGL_2(k))-orbit, and semilinear transport preserves shallowness.

The four-dimensional submodule and two-dimensional quotient in (3) are the
exact C531 filtration.  C530 closes its Frobenius-graph rank-one orbit by
three-space subspace polynomials, C531 closes the off-graph rank-one orbit by
the reciprocal construction, and C578 closes every rational rank-two
(A_5)-twist.  Hence only

\[
                    z_4\ne0\quad\text{or}\quad z_5\ne0      \tag{5}
\]

is new here.

## 2. Exact final-pair descent

Choose six distinct finite roots with monic polynomial

\[
 h(t)=\sum_{i=0}^6h_it^i,qquad h_6=1,
\]

and let the final pair have sum (s) and product (p).  Define the four
consecutive convolutions

\[
                  A_j=\sum_{i=2}^7z_i h_{i+j-3},
                  \qquad 0\le j\le3,                       \tag{6}
\]

with coefficients outside (0,\ldots,6) set to zero.  Substitution of
(f=h(t)(t^2+st+p)) in (4) gives exactly

\[
 A_0+sA_1+pA_2=0,
 \qquad
 A_1+sA_2+pA_3=0.                                         \tag{7}
\]

Put

\[
 \Delta=A_1A_3+A_2^2,
 \quad Q=A_0A_3+A_1A_2,
 \quad N=A_1^2+A_0A_2.                                    \tag{8}
\]

On (Delta Q\ne0), the unique solution is

\[
                         s=Q/\Delta,qquad p=N/\Delta.      \tag{9}
\]

The final pair is rational and distinct precisely when

\[
                  y^2+y=\frac{N\Delta}{Q^2}                \tag{10}
\]

has a rational solution, equivalently when the absolute trace of its
right-hand side is zero.  Collision with a root (r) of (h) is exactly

\[
                         r^2\Delta+rQ+N=0.                  \tag{11}
\]

Equations (6)--(11) are defined over the rational syndrome itself.  They do
not choose a geometric orbit representative or hide a descent cocycle.

The ordered-root cover is geometrically nonconstant on (5).  The elementary
proof is the same nonsquare-leading-coefficient test as C531/C578, with one
new Toeplitz rank lemma.  The linear map

\[
 (h_0,\ldots,h_5)\longmapsto(A_0,A_1,A_2,A_3)              \tag{12}
\]

has rank at least three.  At rank four the (A_j) are independent and, along
(Q=0), the double-pole leading coefficient in (10) is (A_1/A_3), which is
not a square.  At rank three, row reduction gives one affine relation among
the (A_j).  Substituting that relation on (Q=0) and differentiating the
resulting rational expression for (A_1/A_3) shows it can be a square only if
(z_4=z_5=0).  Rank at most two forces the same conclusion directly from the
four shifted rows.  Thus (5) excludes every exceptional case, and (10) is
geometrically integral there.

For reference, if the rank-three relation is

\[
 \ell_0A_0+\ell_1A_1+\ell_2A_2+\ell_3A_3=\kappa,
\]

then on (Q=0)

\[
 \frac{A_1}{A_3}
 =\frac{\kappa+\ell_2A_2+\ell_3A_3}
        {\ell_0A_2+\ell_1A_3}.                             \tag{13}
\]

Both partial derivatives vanish only when
(ell_0\kappa=ell_1\kappa=0) and
(ell_1\ell_2=ell_0\ell_3).  Comparing the six Toeplitz columns under
those three equalities gives (z_4=z_5=0).  This is the promised rank lemma;
no finite-field census enters it.

## 3. A uniform genus-one slice from (q=64)

Fix five roots (r_1,\ldots,r_5), put

\[
 g(t)=\prod_{i=1}^5(t+r_i)=\sum_{i=0}^5g_it^i,
 \qquad g_5=1,
\]

and use (x) as the sixth root.  Define

\[
 B_j=\sum_{i=2}^7z_i g_{i+j-4},\qquad0\le j\le4.           \tag{14}
\]

Then

\[
                         A_j=B_j+xB_{j+1}.                  \tag{15}
\]

In particular (Q) has degree at most two in (x), (N\Delta) has degree
at most four, and

\[
                         Q'(x)=B_0B_4+B_2^2.                \tag{16}
\]

The right side is not the zero polynomial for any nonzero syndrome.  Indeed,
successively comparing the coefficients of
(g_0^2,g_4^2,g_2^2,g_1^2,g_3^2,1) in (16) would otherwise force

\[
                 z_2=z_6=z_4=z_3=z_5=z_7=0.                \tag{17}
\]

At a root of (Q), Artin--Schreier reduction leaves a simple pole exactly
when

\[
                    R=((N\Delta)')^2+(Q')^2N\Delta         \tag{18}
\]

does not vanish.  Geometric nontriviality says (Q\nmid R).  Hence a
specialization can be selected by a nonzero pseudo-remainder coefficient,
the nonzero polynomial (16), the appropriate leading coefficient of (Q),
and the five-root Vandermonde.

C578 bounded only total degree.  Here the coordinatewise bound is decisive.
Each (B_j) is multi-affine in the five roots; a (Q)-coefficient has degree
at most two in each root; an (R)-coefficient has degree at most eight; and a
cleared quadratic pseudo-remainder has degree at most fourteen.  Including
(Q'), the quadratic leading coefficient, and the Vandermonde gives degree at
most

\[
                            14+2+2+4=22                    \tag{19}
\]

in each root variable.  In the linear-(Q) alternative the corresponding
bound is (16+2+4=22).  The finite-field grid lemma therefore supplies five
distinct rational roots for every (q>22), hence every binary (q\ge32).

After Artin--Schreier reduction, (10) has at most two simple poles and genus
at most one.  The exact deletion remains C578's

\[
 \begin{array}{c|c}
 \text{condition}&\deg_x\\\hline
 x=r_i&5\\
 Q=0&2\\
 \Delta=0&2\\
 \text{a final root equals an old root}&10\\
 \text{a final root equals }x&4
 \end{array}
 \qquad\text{total }23.                                   \tag{20}
\]

There are at most two points over each deleted coordinate and at most two
over infinity, so at most 48 rational points are removed.  At (q=64),

\[
                         q+1-2\sqrt q=49>48.                \tag{21}
\]

Equations (19)--(21) prove every point satisfying (5) shallow for all
(q\ge64).

## 4. The exact (q=16,32) quotient certificates

Since (3) is the standard two-dimensional quotient, (PGL_2(k)) is
transitive on its nonzero projective points.  Normalize the quotient to
([e_4]).  Every point outside (U) then has the unique affine-slice form

\[
                     (z_2,z_3,z_4,z_5,z_6,z_7)
                       =(a,b,1,0,c,d).                     \tag{22}
\]

The remaining equivalence is exactly the upper Borel stabilizer of
([e_4]).  Thus (PGL_2(k))-orbits in the complement are in bijection with
Borel orbits on (k^4), a theorem-derived quotient rather than an ambient
syndrome census.

The generator closes this quotient under the unipotent and primitive-diagonal
Borel generators.  It finds exactly

\[
 \begin{array}{c|c|c}
 q&\text{Borel orbits on (22)}&\text{certified witnesses}\\\hline
 16&292&292\\
 32&1090&1090
 \end{array}                                               \tag{23}
\]

For each representative, the certificate records eight distinct points of
(\mathbf P^1(k)).  The replay independently reconstructs the divided-power
action, the complete Borel quotient, the root polynomial, and both equations
in (4).  It reproduces the two orbit counts and checks every witness.
Together with §3 and the imported (U)-theorem, this proves (1).

There are no surviving split-free projective or semilinear strata.  The
projective count is zero, and coefficientwise Frobenius has no residual orbit
data to fuse.

## 5. The strongest uniform consecutive-support criterion

The final-pair construction is not special to degree eight.  For any
two-row Hankel kernel coming from a consecutive-support carrier in
characteristic two, choose a split squarefree polynomial (h) containing all
but two desired roots and form the four consecutive convolutions (6), with
the indices shifted to the carrier's support.  Then a split squarefree member
exists exactly when there are (s,p\in k) satisfying:

1. the two linear equations (7);
2. (s\ne0) and
   (operatorname {Tr}_{k/\mathbf F_2}(p/s^2)=0), so
   (X^2+sX+p) has two distinct rational roots; and
3. (gcd(h,X^2+sX+p)=1).

One ranges over the finite and reciprocal projective charts.  This is an exact
criterion: every split divisor can be partitioned into (h) and a final pair,
and every solution reconstructs one.  On the principal open it is the single
trace condition (10); on (Delta=0) it remains the explicit rank-one or
rank-zero linear-system alternative in (7).  Infinity and collisions are
therefore included rather than deleted from the statement.

What does not exist is an exact criterion based only on the Lucas digit
pattern, subfield containment, or the presence of a linearized subspace
polynomial.  The (q=16) certificate exhausts that possibility on the first
fresh carrier.  There are 15 three-dimensional (mathbf F_2)-subspaces of
(mathbf F_{16}), two affine cosets each.  Closing those 30 divisors under
(PGL_2(16)) gives exactly 510 distinct projective-additive divisors.  Of the
292 intrinsic complement orbits, exactly 101 have no kernel member among the
510, although §4 gives an ordinary split member on all 101.  The independent
replay recomputes the 510-set closure and the 101 negative orbit tests.

Thus the exact uniform object is the trace incidence (7)--(10), not a
linearized section of it.  Digit patterns still identify the carrier and
subspace polynomials still produce cheap witnesses on special strata, but
neither decides split-freeness.

## 6. Reproducibility boundary

The atomic evidence bundle is:

- `notes/2026-08-02-c620-higher-lucas-modular-carriers.py`;
- `notes/2026-08-02-c620-higher-lucas-modular-carriers-q16.json`;
- `notes/2026-08-02-c620-higher-lucas-modular-carriers-q32.json`;
- `notes/2026-08-02-c620-higher-lucas-modular-carriers-replay.py`; and
- `notes/2026-08-02-c620-higher-lucas-modular-carriers.sha256`.

From the repository root:

```text
python3 notes/2026-08-02-c620-higher-lucas-modular-carriers.py 16 \
  --check notes/2026-08-02-c620-higher-lucas-modular-carriers-q16.json
python3 notes/2026-08-02-c620-higher-lucas-modular-carriers.py 32 \
  --check notes/2026-08-02-c620-higher-lucas-modular-carriers-q32.json
python3 notes/2026-08-02-c620-higher-lucas-modular-carriers-replay.py
(cd notes && sha256sum -c 2026-08-02-c620-higher-lucas-modular-carriers.sha256)
```

The generator imports C531's frozen divided-power action implementation; each
JSON certificate records its SHA-256.  The replay imports no generator or C531
code.  It separately implements finite-field arithmetic, Lucas expansion of
the degree-nine action, Borel orbit closure, polynomial reconstruction, and
the projective-additive family.

Both certificates use schema `c620-higher-lucas-quotient-v1` and canonical
sorted JSON.  The `q=16` generator exhausts all 24,310 eight-subsets of
`P1(F16)`.  At `q=32`, witness discovery uses the fixed seed `620032` and the
first 100,000 distinct sampled eight-subsets; the resulting certificate is
not probabilistic because it stores one exact witness per complete quotient
orbit and the replay checks those witnesses directly.  Replacing `--check` by
`--output` regenerates the named certificate.

The load-bearing byte counts are: report `19,060`, generator `11,094`, replay
`8,321`, `q=16` certificate `32,489`, and `q=32` certificate `81,955`.

The computation proves only the exact quotient statements (23), the listed
witnesses, and the 510/101 linearized obstruction.  It does not prove the
all-field theorem.  The load-bearing all-field inputs are the displayed
final-pair algebra, the nonsquare Toeplitz lemma, the coordinatewise degree-22
selection, the genus-one reduction, and the 48-point deletion.

## 7. Literature and placement boundary

This report reuses a frozen audit with **two sources read at full text**, one
at partial depth, and one at abstract/metadata depth.  It makes no priority
claim.

- Wang--Wu--Hu, *3-Designs from
  \(\mathrm{GL}_2(\mathbf F_q)\)-Invariant Subspaces* — **full text**, arXiv
  v4, all sections; cache key `arXiv:2604.21183v4`, SHA-256
  `ad1e19b1a1bf7b1bbc016cc4617a59a718cf1a3f9396f6386f4b1b151149a811`.
  Their Proposition 11 owns the projective-subline endpoint criterion
  (a\mid e), and their general framework owns the invariant-subspace block
  viewpoint.  C620 does not claim either as new.  Their current arXiv record
  was checked on 2026-08-02 and remains v4.
- Wang, *Splitting of Polynomial Families via Galois Theory* — **full text**,
  arXiv v1, all sections; cache key `arXiv:2606.12810`, SHA-256
  `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.
  It supplies general splitting-family/Galois infrastructure, not the
  consecutive Hankel trace system or its carrier quotient.  The current arXiv
  record remains v1.
- Gmainer--Havlicek, *Nuclei of Normal Rational Curves* — **partial**, arXiv
  v1 abstract and Theorem 1; cache key `arXiv:1304.0088`, SHA-256
  `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`.
  It owns the NRC nucleus and digit formula background.  C620 imports that
  background through C529/C820.
- Dau--Xinh--Kiah--Luong--Milenkovic, *Repairing Reed--Solomon Codes via
  Subspace Polynomials* — **abstract/metadata only**, arXiv v1.  Its stated
  application is repair bandwidth for extension-field RS codes.  It was
  screened because of the shared subspace-polynomial tool, not used as a
  theorem input.

Four current primary-source searches on 2026-08-02 used the exact clauses
`Lucas subspace projective Reed-Solomon split squarefree Hankel`, `linearized
subspace polynomial Reed-Solomon deep hole characteristic two`, `consecutive
Hankel kernel split polynomial finite field`, and `normal rational curve
nucleus Lucas subspace polynomial`, restricted to arXiv.  They returned the
known nucleus/PRS works, the unrelated repair paper, older standard/GRS
deep-hole papers, and false positives.  This bounded check changed no
attribution.  MathSciNet, zbMATH, Google Scholar, and forward-citation graphs
were not covered; consequently C620 states no unqualified novelty or priority
negative.

The exact placement judgment is mathematical rather than priority-based:
C820 needs the truth value of split-freeness on (1), and C620 supplies it.
Version 2 should adopt the empty-carrier conclusion and the trace criterion,
while retaining Wang--Wu--Hu's endpoint attribution.

## 8. Review gate and mystery ledger

The independent arithmetic replay is green, but it is not a substitute for
the task card's independent finite-geometer/coding-theorist proof review.  The
remaining reviewer should pressure-test exactly four seams:

1. the rank-three clause in the Toeplitz nonsquare lemma;
2. the coordinatewise degree 22 in both quadratic- and linear-(Q) branches;
3. the assertion that the final-pair criterion is exhaustive across
   projective charts; and
4. the Version 2 statement's separation of kernel membership, shallowness,
   and covering-radius promotion.

Mysteries settled by the mathematical pass:

- **Does the first higher Lucas carrier contain split-free points?**  No, in
  every admissible field.
- **Was C532's two-dimensional residue genuine?**  It was a proof residue,
  not an arithmetic stratum; the final-pair cover supplies witnesses
  everywhere.
- **Are linearized/subspace-polynomial witnesses exact?**  No; the exact
  510/101 obstruction already appears at (q=16).
- **What replaces them uniformly?**  The two-equation final-pair system and
  its Artin--Schreier trace condition.
- **What remains open?**  Arbitrary digit patterns can now use this exact
  criterion, but no all-pattern solution theorem follows from the first
  carrier.  C620's own remaining gate is independent proof review, after
  which the required extra-juice/Tao closeout and lifecycle update can run.

No incidental observation falls outside C620's target, so the discovery track
receives no entry at this stage.
