# C756 — passant-code equality and the local tangent graph

**Lane**: `clebsch` · **Date**: 2026-08-08 · **Scope**: research only

## Verdict

The first publication-route pass produced two exact reductions and corrected the
novelty claim attached to one of them.

1. The binary passant incidence code has the elementary lower bound
   \(d(K_q)\ge(q+3)/2\).  This bound is **not new**: it is Theorem 7.11 of
   Droms--Mellinger--Meyer.  The useful general bridge for C756 is its equality case:
   a word has weight \((q+3)/2\) if and only if its support is an internal
   \((q+3)/2\)-arc whose pairwise joins are passant.
2. Equality therefore turns the saturated-internal branch into a minimum-word
   classification problem.  The correct target is: for \(q>3\), equality occurs only
   at \(q=5\), where the supports are projective four-frames.  The qualifier \(q>3\)
   matters: \(K_3\) has one word of weight three.
3. Paper IV already contains the right proof prototype at \(q=13\).  Fix a support
   point \(P\); Segre's lemma makes the other \((q+1)/2\) points a clique in a local
   tangent-holonomy graph \(H_{q,P}\).  Exact computation gives
   \(\omega(H_{q,P})<(q+1)/2\) for every tested \(q>5\), over all odd prime powers
   through \(49\).  At \(q=5\), equality holds.  This local graph is a better next
   certificate target than the pair-only elliptic association scheme because it keeps
   precisely the tangent/no-three-collinear information lost by the global relaxation.
4. A separate norm identity proves that the orientation signs on every triple of
   internal points of an external line multiply to \(-1\).  It closes the canonical
   line-plus-pole coherent candidate for every \(q\equiv3\pmod4\), \(q\ge7\), but does
   not classify non-line candidates.

The complete saturated classification remains open.  Its equality gate is now sharper
and has a proved all-field interface, but two bounded certificate passes show that the
optimal-PSD exactification does not stay finite-dimensional.  The correct next move is
the source audit and partial-results scoping described below, while retaining the local
graph as a clean open problem.

## 1. The general code and the equality bridge

Let \(\mathcal C\subset\mathrm{PG}(2,q)\) be a nonsingular conic over an odd field.
Let \(I\) be its internal points and \(\mathrm{Pa}\) its passant lines.  Write

\[
 M_q=(1_{P\in\ell})_{\ell\in\mathrm{Pa},P\in I},
 \qquad K_q=\ker_{\mathbb F_2}M_q.
\]

Polarity gives \(|I|=|\mathrm{Pa}|=q(q-1)/2\).  Every internal point is on
\((q+1)/2\) passants, and every passant contains \((q+1)/2\) internal points.

> **Theorem 11 (passant-code equality bridge).**  Every nonzero word of \(K_q\)
> has weight at least \((q+3)/2\).  A support \(S\subset I\) has weight exactly
> \((q+3)/2\) and belongs to \(K_q\) if and only if:
>
> - every join of two points of \(S\) is passant to \(\mathcal C\); and
> - no three points of \(S\) are collinear.

*Proof.*  Let \(S\) support a nonzero codeword and fix \(P\in S\).  Each of the
\((q+1)/2\) passants through \(P\) meets \(S\) evenly and already contains \(P\), so
it contains at least one further support point.  Distinct lines through \(P\) provide
distinct points.  Hence

\[
 |S|-1\ge(q+1)/2,
\]

which is the lower bound.

If equality holds, those passants contain exactly one further support point and
exhaust \(S\setminus\{P\}\).  Repeating this at every \(P\in S\) shows that every
support join is passant and that a support line cannot contain three points.

Conversely, suppose \(S\) has size \((q+3)/2\) and the two displayed properties.
For each \(P\in S\), the \((q+1)/2\) distinct joins from \(P\) to the other support
points are passant and therefore exhaust all passants through \(P\).  Each contains
exactly two support points.  A passant disjoint from \(S\) contains zero.  Thus every
row of \(M_q\) meets \(S\) evenly, so \(1_S\in K_q\).  \(\square\)

The first paragraph is the argument of Droms--Mellinger--Meyer, Theorem 7.11.  The
iff equality statement is the general form of the \(q=13\) reduction already written
in Paper IV, lines 178--190.  It should be presented as a bridge and attribution
upgrade unless the remaining source audit establishes an earlier explicit equality
statement.

### Consequence for C756

A saturated-internal conic-filling arc already has exactly the two geometric
properties in Theorem 11, hence is the support of a minimum-size word of \(K_q\).
Therefore the field-uniform statement

> for odd \(q>3\), \(K_q\) meets the Droms--Mellinger--Meyer lower bound only for
> \(q=5\), and its equality supports are four-frames,

would close the saturated-internal branch.  The code statement is stronger than C756:
an equality support need not satisfy the covering condition or the normalized coherence
conditions.  This strength is useful if it remains provable, but it is also the main
risk of the route.

At \(q=3\), the three internal points support the unique nonzero word of \(K_3\).
That exception is outside the desired \(q>3\) minimum-word statement and must not be
silently reported as a four-frame exception.

## 2. The external-line orientation product

Work in \(\mathbb F_{q^2}\), and normalize the \(q+1\) roots representing the internal
points of an external line by

\[
 z^q=-z^{-1}\qquad\text{or, equivalently,}\qquad N(z)=-1.
\]

> **Lemma 12 (external-line orientation product).**  For three distinct such roots,
> set
>
> \[
> X=\frac{(z_1-z_2)(z_2-z_3)(z_3-z_1)}{z_1z_2z_3}.
> \]
> Then \(X^q=-X\), and
>
> \[
> \prod_{i<j}N(z_i-z_j)=X^2
> \]
> is a nonsquare in \(\mathbb F_q\).

*Proof.*  From \(z_i^q=-z_i^{-1}\),

\[
 (z_i-z_j)^q=\frac{z_i-z_j}{z_iz_j}.
\]

Applying this to the three cyclic differences and using
\((z_1z_2z_3)^q=-(z_1z_2z_3)^{-1}\) gives \(X^q=-X\).  Thus \(X\) lies on the
one-dimensional trace-zero \(\mathbb F_q\)-line: if
\(\mathbb F_{q^2}=\mathbb F_q(s)\) with \(s^2=\varepsilon\) a nonsquare, then
\(X=sc\) for some \(c\in\mathbb F_q^*\).  Hence \(X^2=\varepsilon c^2\) is a
nonsquare.  Multiplying

\[
 N(z_i-z_j)=\frac{(z_i-z_j)^2}{z_iz_j}
\]

over the three pairs gives the claimed identity.  \(\square\)

Taking quadratic characters says that the three orientation signs have product
\(-1\).  When \(q\equiv3\pmod4\), the saturated coherence normalization requires
sign \(+1\) on every pair.  For \(q\ge7\), the line part of
\(C_\ell\cup\{\ell^\perp\}\) contains a triple, so this canonical extremal
\(\Gamma_q\)-clique cannot be coherent.  This supplies the cheap successor test left
open by Theorem 10 of the invariant-half report.  It does not address extremal
cliques with no external-line triple.

## 3. The local Segre-tangent graph

For an internal point \(P\), choose one nonzero equation for each secant to
\(\mathcal C\) through \(P\), and set

\[
 T_P(X)=\prod_{\substack{\ell\ni P\\\ell\text{ secant to }\mathcal C}}\ell(X).
\]

For a pairwise-passant triple define the scale-free ratio

\[
 h(P,Q,R)=
 \frac{T_P(Q)T_Q(R)T_R(P)}{T_P(R)T_R(Q)T_Q(P)}.
\]

Put \(t=(q+1)/2\).  If an equality support from Theorem 11 exists, its chords
exhaust every passant pencil, so its combinatorial tangents are exactly the secants
used in \(T_P\).  Segre's lemma of tangents then gives

\[
 h(P,Q,R)=(-1)^{t+1}. \tag{1}
\]

Fix an internal point \(P\).  Define \(H_{q,P}\) on the
\((q^2-1)/4\) internal points \(Q\) joined passantly to \(P\); join \(Q,R\) when
\(QR\) is passant and (1) holds.  An equality support through \(P\) would give a
clique of size \(t\) in \(H_{q,P}\).  Thus the exact gate is

\[
 \omega(H_{q,P})<\frac{q+1}{2}\qquad(q>5). \tag{2}
\]

The graph is independent, up to isomorphism, of \(P\).  It is not generally regular,
so a one-matrix Hoffman calculation is not the correct first abstraction.  Its
stabilizer-orbital algebra is the natural certificate space.  At \(q=13\), this is
exactly Paper IV's \(42\)-vertex tangent graph: the new implementation independently
reproduces \(238\) edges and clique number \(5\), while the paper's rank-\(28\) exact
PSD certificate proves the same bound.

### Exact bounded sweep

The exhaustive values are:

| \(q\) | \(|V(H_{q,P})|\) | \(\omega(H_{q,P})\) | target \((q+1)/2\) |
|---:|---:|---:|---:|
| 5 | 6 | 3 | 3 |
| 7 | 12 | 2 | 4 |
| 9 | 20 | 3 | 5 |
| 11 | 30 | 4 | 6 |
| 13 | 42 | 5 | 7 |
| 17 | 72 | 5 | 9 |
| 19 | 90 | 5 | 10 |
| 23 | 132 | 5 | 12 |
| 25 | 156 | 7 | 13 |
| 27 | 182 | 8 | 14 |
| 29 | 210 | 6 | 15 |
| 31 | 240 | 6 | 16 |
| 37 | 342 | 7 | 19 |
| 41 | 420 | 9 | 21 |
| 43 | 462 | 8 | 22 |
| 49 | 600 | 9 | 25 |

The fields \(9,25,27,49\) are extension fields.  Every \(q>5\) row excludes the
target, usually by a wide margin; this is evidence for (2), not a proof outside the
displayed domain.  The irregular degree multiplicities and edge counts are retained
in the JSON certificate.

The routing implication is important: the pair-only elliptic scheme sees the large
line-plus-pole cliques and therefore cannot close \(q\equiv3\pmod4\).  The local
tangent graph deletes them by retaining Segre holonomy.  The next certificate pass
therefore averaged over the stabilizer of \(P\) in \(H_{q,P}\), using Paper IV's
\(q=13\) theta matrix as the worked example.  The global elliptic scheme remains a
comparison model, not the primary proof object; the outcome and stop decision follow.

### The two bounded certificate passes

The first pass solved the following PSD completion numerically.  For a symmetric
matrix \(C\) indexed by \(V(H_{q,P})\), maximize \(s\) subject to

\[
 C\succeq0,
 \qquad C_{ii}=1,
 \qquad C_{ij}=-s\quad(ij\in E(H_{q,P})). \tag{3}
\]

For a clique indicator \(v\) of size \(c\), (3) gives

\[
 0\le v^{\mathsf T}Cv=c-sc(c-1),
 \qquad c\le1+1/s. \tag{4}
\]

The results are discovery evidence, not exact certificates:

| \(q\) | optimum \(s\) | bound \(1+1/s\) | forbidden target | numerical rank |
|---:|---:|---:|---:|---:|
| 5 | 0.5000000000 | 3.00000000 | 3 | 4 |
| 7 | 0.9999999996 | 2.00000000 | 4 | 1 |
| 9 | 0.4999999927 | 3.00000003 | 5 | 9 |
| 11 | 0.3333333172 | 4.00000014 | 6 | 18 |
| 13 | 0.2499999955 | 5.00000007 | 7 | 30 |
| 17 | 0.2318948213 | 5.31229984 | 9 | 41 |
| 19 | 0.2259196654 | 5.42635217 | 10 | 71 |

Thus the theta-type completion reproduces the exact clique number through \(q=13\)
and remains far below the forbidden linear target at \(q=17,19\).  At \(q=13\),
Paper IV supplies a different optimum of exact rank \(28\); the numerical solver's
rank \(30\) records nonuniqueness and interior-point selection, not a conflict.

The second pass enumerated the full conic point stabilizer.  The action is
\(\mathrm{PGL}(2,q)_P\), of order \(2(q+1)\), on binary quadratic forms.  Exact
stabilizer averaging reduces (3) to one variable for \(s\) plus one for every
nonedge orbital, but that algebra does **not** stay bounded:

| \(q\) | vertex orbits | edge orbitals | nonedge orbitals | completion variables |
|---:|---:|---:|---:|---:|
| 5 | 1 | 1 | 2 | 3 |
| 7 | 2 | 3 | 6 | 7 |
| 9 | 2 | 4 | 12 | 13 |
| 11 | 3 | 9 | 21 | 22 |
| 13 | 3 | 11 | 34 | 35 |
| 17 | 4 | 24 | 72 | 73 |
| 19 | 5 | 35 | 100 | 101 |

The raw optimal completions likewise acquire growing rank and growing rounded
nonedge-value complexity.  No fixed dual support or bounded block pattern emerges.
This triggers the card's precommitted stop rule: **do not exactify the field-by-field
theta optima and do not promote the numerical pattern to a conjectural formula.**
The local graph remains the cleanest formulation of the equality obstruction, but
the optimal-PSD route is closed as the next research investment.  A future return
would require a genuinely new closed-form feasible matrix or character inequality
whose description is independent of the optimum's orbital dimension.

This behavior matches the warning in Magsino--Mixon--Parshall, *Linear programming
bounds for cliques in Paley graphs*,
[arXiv:1907.05971](https://arxiv.org/abs/1907.05971): localizing a Paley clique problem
can make theta bounds strong, but proof requires an explicit dual “magic function.”
Their local graph is circulant and reduces to one Fourier LP; \(H_{q,P}\) has multiple
growing stabilizer orbits, so their reduction is a template rather than a theorem
that applies here.

## 4. Focused predecessor audit

The audit was deliberately narrow and does not yet authorize a novelty claim.

- S. V. Droms, K. E. Mellinger, and C. Meyer, *LDPC codes generated by conics in
  the classical projective plane*, Designs, Codes and Cryptography 40 (2006),
  343--356, DOI
  [10.1007/s10623-006-0022-6](https://doi.org/10.1007/s10623-006-0022-6).
  Relevant source depth: the original indexed PDF's Section 7.4 and Theorem 7.11.
  It proves \((q+3)/2\le d\le q-1\) for \(q>3\); its lower-bound proof is the
  passant-pencil argument above.  No explicit equality classification was found in
  the inspected theorem text.
- A. L. Madison and J. Wu, *On binary codes from conics in
  \(\mathrm{PG}(2,q)\)*, European Journal of Combinatorics 33 (2012), 33--48,
  [arXiv:1104.0324](https://arxiv.org/abs/1104.0324).  Its stated main contribution
  is the nullity/module structure, including \(\dim K_q=(q-1)^2/4\), not a general
  minimum-word classification.
- The ScienceDirect cited-by list for Madison--Wu and exact-phrase searches for the
  passant/internal code found the later dimension/rank papers and the 2024 quadrics
  paper, but no source claiming the equality classification or (2).
- Paper IV already states and proves the equality-to-arc reduction at \(q=13\) and
  supplies the exact local theta certificate there.  Any companion paper must cite
  that internal predecessor transparently rather than presenting the bridge as newly
  discovered in C756.
- M. Magsino, D. G. Mixon, and H. Parshall, *Linear programming bounds for cliques
  in Paley graphs*, [arXiv:1907.05971](https://arxiv.org/abs/1907.05971), supplies the
  relevant local-theta/Fourier-dual template.  It does not cover the pointed
  tangent-holonomy graph or give the required all-field certificate.

Still required before publication: source-read the full Droms paper rather than only
the relevant indexed section; close its forward citation graph in MathSciNet and at
least one independent citation index; inspect the six Madison--Wu cited-by papers at
the theorem level; and search explicitly for conic-external internal arcs, not only
for code terminology.

The follow-up audit is
\`notes/2026-08-08-c756-predecessor-audit-and-companion-scope.md\`.  It source-read
the complete archived Droms--Mellinger--Meyer author preprint, screened the accessible
forward graphs, and found the missing established vocabulary: an exterior set of a
conic is a point set whose pairwise joins miss the conic.  Blokhuis--Seress--Wilbrink
and Van de Voorde classify or extend exterior-*point* sets of size \((q+1)/2\), not
the internal-point arcs of size \((q+3)/2\) arising here.  Consequently the equality
bridge remains a useful qualified interface, but not a standalone terminology or
lower-bound novelty claim.  MathSciNet and Semantic Scholar closure remain uncovered.

## 5. Reproducibility and trust boundary

Evidence bundle:

- `notes/2026-08-08-c756-passant-code-equality.py` — 12,401 bytes,
  SHA-256 `acf54490218a59fb05a3dcd479ec216f9d439d16d69227d9be4113407bdb881b`;
- `notes/2026-08-08-c756-passant-code-equality.json` — 7,147 bytes,
  SHA-256 `6648efc6cea6e563777ef230f1ca07938f74895dcc2da606772084125e7e3657`;
- `notes/2026-08-08-c756-tangent-psd-probe.py` — 5,541 bytes,
  SHA-256 `e891553074f5f82747faf90d1107ab1d39e05b0c740bb6b3a5ce2e7140292046`;
- `notes/2026-08-08-c756-tangent-psd-probe.json` — 5,707 bytes,
  SHA-256 `d5a388dc0fdca8922eb30a8f80f7afa3cca9ae6b9fa062bcfcc8c82aef86afcb`;
- `notes/2026-08-08-c756-tangent-orbitals.py` — 6,366 bytes,
  SHA-256 `9099e6bafec5637e425329bfe4c96bcc4b8bb326262cae7c9e1f9ddb45f66859`;
- `notes/2026-08-08-c756-tangent-orbitals.json` — 5,364 bytes,
  SHA-256 `abd04c935243d1abde23c36224ae72ac6034f90452038fa9677b72c3615bd2c3`;
- load-bearing field/plane dependency
  `notes/2026-08-02-c756-invariant-half-clique.py` — 13,865 bytes,
  SHA-256 `2e04d757e958fcd67628b3cba472aaaeaa2575ea4f925bf6390fbc6c569435cf`.

Replay from the repository root:

```text
python3 notes/2026-08-08-c756-passant-code-equality.py --check
python3 notes/2026-08-08-c756-tangent-orbitals.py --check
nix shell --impure --expr \
  'with import <nixpkgs> {}; python3.withPackages (ps: [ ps.numpy ps.cvxpy ])' \
  -c python3 notes/2026-08-08-c756-tangent-psd-probe.py --check
sha256sum notes/2026-08-08-c756-passant-code-equality.{py,json} \
  notes/2026-08-08-c756-tangent-{psd-probe,orbitals}.{py,json} \
  notes/2026-08-02-c756-invariant-half-clique.py
```

The code check enumerates all \(2,16,512,65536\) words of \(K_q\) at
\(q=3,5,7,9\), respectively.  It independently enumerates all internal
conic-external arcs of equality size and checks equality of the two support lists.
It obtains minimum distances \(3,4,6,8\), with equality-support counts \(1,5,0,0\).

The external-line check enumerates every triple among the \(q+1\) norm-minus-one
roots for \(q=3,5,7,9,11,13,19,23,25,27,31,43,49\), verifying both the displayed
identity and nonsquare conclusion.  The local tangent sweep constructs every graph
from projective incidence and tangent products and computes its exact clique number
by deterministic branch-and-bound.

Independent checks are: the human proofs of Theorems 11 and 12; Madison--Wu's
dimension formula against the computed dimensions; the older independent
external-arc maxima at \(q=5,7,9\); and exact agreement at \(q=13\) with Paper IV's
separately implemented tangent graph and PSD certificate.  The shared finite-field
and plane implementation remains inside the computational trusted boundary.  The
finite sweep does not prove (2), classify equality supports beyond its domain, or
establish literature novelty.

The PSD probe uses Python 3.13.12, NumPy 2.3.4, CVXPY 1.7.3, and Clarabel 0.10.0
from the displayed Nix environment, with absolute, relative, and feasibility
tolerances \(10^{-9}\).  Its output is byte-stable under replay, but remains
numerical.  The orbital census is standard-library exact and independently verifies
the full point-stabilizer order and graph invariance before counting orbitals.

## 6. EJ + TT closeout and mystery ledger

**EJ.**  The free upgrade was not the already-published lower bound but its equality
interface.  Following that interface back into Paper IV exposed a theorem-facing
local graph with an existing exact certificate, and the new sweep shows a large gap
between its clique number and the forbidden target.  This is the first successor in
this review with both a uniform human reduction and a demonstrably strong bounded
signal.  The two promised certificate passes have now been spent: the numerical
bound is excellent, but the stabilizer-averaged completion grows to 101 variables by
\(q=19\).  The correct decision is to retain the reduction as an open problem and
stop exactifying optimal theta matrices.

**TT.**  Ask which hypothesis the relaxation discarded.  The global elliptic graph
keeps only pairwise passant joins and admits line-plus-pole extremals.  Minimum-code
equality restores no-three-collinear, and Segre's lemma converts exactly that missing
geometry into tangent holonomy.  The right object is therefore not another global
clique graph but the pointed tangent graph \(H_{q,P}\).  The obstacle has moved from
classifying special configurations to proving that a pseudorandom local graph has no
linear-size clique.

| mystery | status | exact gap / next test |
|---|---|---|
| Is the lower bound new? | settled negative | Droms--Mellinger--Meyer Theorem 7.11 already proves it |
| Is equality exactly the internal conic-external arc condition? | settled | Theorem 11, with exhaustive checks at \(q=3,5,7,9\) |
| Does \(q=3\) violate the planned statement? | settled | yes for the code; state the classification for \(q>3\) and eliminate \(q=3\) separately in C756 |
| Does the canonical \(q\equiv3\pmod4\) line-plus-pole clique survive coherence? | settled negative for \(q\ge7\) | Lemma 12 gives triangle sign product \(-1\) |
| Is \(\omega(H_{q,P})<(q+1)/2\) uniform for \(q>5\)? | open, cleanest equality gate | true exactly for every odd prime power \(q\le49\); the optimal-PSD route has now stopped |
| Does Paper IV's theta matrix stabilize symbolically with \(q\)? | settled negative for the tested mechanism | completion variables grow \(3,7,13,22,35,73,101\); the precommitted stop rule fires |
| Is the numerical theta signal still useful? | settled as routing evidence | bounds through \(q=19\) are far below target, but only a new closed-form feasible matrix can reopen the route |
| Is the equality classification new? | audit incomplete | no explicit predecessor found, but MathSciNet and theorem-level forward-citation closure remain mandatory |
| Does this close all \(k\)? | no | it targets only saturated-internal; masked Rédei \(h\ge1\) remains the nonsaturated gate |
