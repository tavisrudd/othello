# C756 — information/probability structure lottery

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The nonsaturated branch has an exact coding-theoretic reformulation and a
falsifiable second-order obstruction target, but not yet the inequality that
would close it.  After deleting the chosen arc point and putting its spare
external line at infinity, the remaining affine points define degree-one
Reed--Solomon words

\[
        c_i(t)=y_i-tx_i,\qquad t\in\mathbb F_q.
\]

Every pair of words agrees in exactly one coordinate, its chord direction;
the common symbol is the chord intercept.  The arc condition says that an
agreement cell contains exactly one pair, direction covering says that every
coordinate has an agreement, and conic externality says that every agreement
cell lies in a fixed quadratic-character mask occupying roughly half of that
coordinate's alphabet.  Thus the open branch is exactly a **masked collision
cover inside \(RS_2(q)\)**.

This separates two notions that the failed subresultant probe had conflated.
For defect \(\delta=O(1)\), the collision *information* is almost completely
compressed by the direction coordinate, even though the polynomial that
interpolates the collision symbol has degree \(\Theta(q)\).  Shannon
compression is present; low algebraic degree is not.  A successful carrier
must therefore couple pairs of point pencils and measure collision variance,
not try once more to interpolate the intercept function.

The new exact gate is the parallel-chord count

\[
 R=\sum_{t\in\mathbb F_q}\binom{\mu_t}{2},
\]

where \(\mu_t\) is the number of chords of direction \(t\).  Covering places a
sharp upper bound on \(R\).  Consequently, any theorem saying that the conic
character mask forces \(R\) above that bound would exclude the nonsaturated
branch uniformly in \(k\).  No such character-to-variance inequality is in
hand.  This pass upgrades “find a pair-structure carrier” from a shape to one
specific quantity and threshold, but the full-theorem odds remain about
10--15%; it does not displace the coherent saturated-internal double-clique as
the highest-EV gate.

## 1. Masked Reed--Solomon collision lemma

Let \(B=\{(x_i,y_i):1\le i\le n\}\) be the affine arc obtained after deleting
the chosen point.  Its \(x_i\) are distinct.  Associate to point \(i\) the word
\(c_i=(y_i-tx_i)_{t\in\mathbb F_q}\), an evaluation word of a polynomial of
degree at most one.

For \(i\ne j\),

\[
 c_i(t)=c_j(t)
 \quad\Longleftrightarrow\quad
 t=\frac{y_j-y_i}{x_j-x_i}=:t_{ij}.
\]

At this coordinate their common symbol
\(u_{ij}=y_i-t_{ij}x_i\) is the chord intercept.  Therefore:

1. every pair of words has one and only one agreement coordinate;
2. no agreement cell \((t,u)\) contains three words, because that would be a
   three-point line;
3. distinct chord pairs give distinct agreement cells, again by the arc
   condition;
4. the chords in one coordinate form a matching, so
   \(\mu_t\le m:=\lfloor n/2\rfloor\);
5. direction covering is exactly \(\mu_t\ge1\) for every \(t\).

Finally the line \(Y=tX+uZ\) is external to the fixed conic precisely when a
fixed direction-dependent quadratic discriminant has the required nonsquare
character.  Writing its permitted intercept set as \(M_t\subseteq\mathbb F_q\),
conic externality is simply

\[
             u_{ij}\in M_{t_{ij}}\quad\hbox{for every }i<j. \tag{1}
\]

The masks \(M_t\) are structured half-alphabets, not independent random
subsets.  Equation (1) is the missing information that the unweighted slope
moments discard.

## 2. Exact entropy identities

Put \(b=\binom n2=q+\delta\), choose a chord uniformly, and let \(T\) and
\(U\) be its direction and intercept.  Since a chord is uniquely determined
by its agreement cell,

\[
 H(T,U)=\log b,\qquad
 \Pr(T=t)=\frac{\mu_t}{b},
\]

and hence

\[
 \boxed{\quad H(U\mid T)
     =\frac1b\sum_t\mu_t\log\mu_t.\quad} \tag{2}
\]

If \(\delta\) is fixed and every direction occurs, only \(\delta\) excess
chords must be distributed among the fibres, so (2) is
\(O(\delta\log(\delta+1)/q)\).  Direction therefore almost determines the
chord.  This is fully compatible with the prior report's maximal
interpolation degree: entropy measures how many symbols remain possible at
each coordinate, not the degree of the function selecting them.

For two independent uniform chords, the collision probability of their
directions is

\[
 \Pr(T=T')=\frac{\sum_t\mu_t^2}{b^2}
           =\frac{b+2R}{b^2},\qquad
 R=\sum_t\binom{\mu_t}{2}. \tag{3}
\]

Thus \(R\) is exactly the order-two / Renyi collision statistic.  Geometrically
it counts unordered pairs of parallel chords.  Such chords are disjoint, so it
is also a genuine four-point statistic: the number of opposite-side
parallelisms in complete quadrilaterals of \(B\).

## 3. The sharp covering threshold

Assume every direction is covered.  Write \(\mu_t=1+e_t\), where
\(0\le e_t\le m-1\) and \(\sum_t e_t=\delta\).  Convexity of
\(\binom{1+e}{2}\) says the largest possible \(R\) is obtained by packing the
excess into as few fibres as the matching cap permits.  If

\[
 \delta=a(m-1)+r,\qquad 0\le r<m-1,
\]

then every covering configuration satisfies the sharp bound

\[
 \boxed{\quad R\le R_{\rm cover}(n,\delta)
     :=a\binom m2+\binom{r+1}{2}.\quad} \tag{4}
\]

For the active defect-two boundary, (4) is simply \(R\le3\): two doubled
directions give \(R=2\), while one tripled direction gives \(R=3\).
Therefore the following statement would close defect two, and its natural
generalization would close every nonsaturated defect:

> **Masked-collision variance gate.**  Prove that an affine \(n\)-arc whose
> every chord satisfies the conic mask (1) has
> \(R>R_{\rm cover}(n,\delta)\) whenever \(q>43\) and
> \(\binom n2=q+\delta\).

The direction moment identities from the previous pass determine the first
moments but do not control (3).  The required object is intrinsically
pair-coupled: expanding \(R\) produces a four-point equality-of-slopes
condition, while (1) supplies four conic-character factors.  That is the
smallest plausible Fourier/character carrier left by the negative
subresultant result.

## 4. Exact controls

The script `notes/2026-08-01-c756-masked-rs-collision-controls.py` recomputes the
agreement cells from the six previously committed direction-covering
instances and checks

\[
 \sum_t\mu_t=b,qquad \sum_t\mu_t^2=b+2R,
\]

cell occupancy one, and the matching cap.  Certificate:
`notes/2026-08-01-c756-masked-rs-collision-controls.json`.

| \(n\) | \(q\) | \(\delta\) | fibre profile | \(R\) | \(R_{\rm cover}\) | \(H(U\mid T)\) |
|---:|---:|---:|:---|---:|---:|:---|
| 5 | 7  | 3 | \(1^4 2^3\)   | 3 | 3  | \(\log64/10\) |
| 6 | 13 | 2 | \(1^{11}2^2\)| 2 | 3  | \(\log16/15\) |
| 7 | 19 | 2 | \(1^{17}2^2\)| 2 | 3  | \(\log16/21\) |
| 7 | 17 | 4 | \(1^{13}2^4\)| 4 | 6  | \(\log256/21\) |
| 9 | 31 | 5 | \(1^{26}2^5\)| 5 | 9  | \(\log1024/36\) |
|10 | 41 | 4 | \(1^{37}2^4\)| 4 | 10 | \(\log256/45\) |

These are covering controls, **not conic-external arcs**.  Their role is to
verify the dictionary and show the threshold is nonvacuous.  In every control
the excess is maximally dispersed, one chord into each exceptional direction;
ordinary covering therefore prefers small \(R\).  The proposed obstruction
must show that the conic mask drives \(R\) in the opposite direction.

Reproduction:

```text
cd rust
python3 ../notes/2026-08-01-c756-masked-rs-collision-controls.py
sha256sum ../notes/2026-08-01-c756-masked-rs-collision-controls.{py,json}
```

Recorded hashes from this pass:

```text
acc40f77c43dde9036cb6ef0557f2fefc72973d49a40d6ea387b6c1183edd65c  notes/2026-08-01-c756-masked-rs-collision-controls.py
0f148cda3b35682c3160e74bb6014aa3ef6038d0402cbd98c934783308052dc1  notes/2026-08-01-c756-masked-rs-collision-controls.json
```

The certificate is a diagnostic exact-arithmetic replay, not exhaustive
evidence.  The identities and threshold are proved above independently of
the six rows.

## 5. Probability heuristic — and its limit

If the \(b\) chord directions behaved like independent balls in \(q\) bins,
then at zero defect the probability of covering would be
\(q!/q^q\asymp\sqrt{q}\,e^{-q}\), and fixed defect has the same exponential
rarity.  Imposing a half-alphabet mask on every collision would appear to
cost roughly another bit per chord.  Since \(n\sim\sqrt{2q}\), even the
number of labelled affine point configurations grows only like
\(\exp(O(\sqrt q\log q))\); the naive model predicts eventual nonexistence
overwhelmingly.

That heuristic is motivational, not proof evidence.  Chord slopes share
vertices, satisfy exact moment identities, and arise from a two-dimensional
algebraic configuration; the conic masks are Paley-type character sets with
strong correlations.  Known structured direction-covering sets already show
that independent occupancy is the wrong model.  A union bound or a claim of
\(2^{-b}\) independence would merely repackage the counting route already
known to be too weak.  The rigorous residue of the heuristic is (3)--(4):
test whether the mask creates a detectable excess in a four-point collision
statistic.

## 6. EJ + TT closeout

**EJ.**  The useful conceptual correction is the separation between
information compression and algebraic compression.  At fixed defect the
direction contains almost all information about the chord, but recovering
the intercept can still require a degree-\(\Theta(q)\) polynomial.  This
explains rather than contradicts the negative subresultant report.  The cheap
acceptance test for any next carrier is now: does it see \(R\), or another
four-point collision statistic, before doing high-degree elimination?

**TT.**  The most economical next experiment is not another generic search.
Instrument the existing exact conic-external enumeration through \(q\le43\)
to record \((\delta,R,R_{\rm cover})\), split by internal/external deleted
point and residual-fibre shape.  A consistent gap toward
\(R_{\rm cover}+1\) would justify expanding the equality-of-slopes indicator
with additive characters and the external-line mask with the quadratic
character.  No gap would kill this lottery ticket cheaply.  The desired
analytic statement should be sought as a fourth-moment or additive-energy
inequality, not a spectral bound on the already-tight saturated graph.

Secondary information-theory lens on the saturated-internal gate: its
balance theorem makes the signed indicator of the two cliques a sparse
Paley-eigenspace vector whose additive Fourier support lies in one quadratic
frequency class.  Since interlacing is tight, the relevant question is a
minimum-support/equality-case classification for that eigencode, not another
Hoffman bound.  This is compatible with, but does not replace, the current
coherent-double-clique program.

## 7. Mystery ledger

- The direct \(R>R_{\rm cover}\) prediction is not the clean empirical law:
  exhaustive instances at \(q=29,31,43\) can have
  \(R\le R_{\rm cover}\).  Yet no audited instance has \(h=0\) or \(h=1\).
  Can the character mask force the sharper direction gap \(h\ge1\) uniformly?
- Can \(R\) be written as a positive or nearly positive quadratic form after
  inserting the external-line character, so that the half-alphabet mask has
  a sign rather than only cancellation?
- At defect two, do the one-triple and two-double residual shapes have
  distinguishable masked fourth moments even though all unweighted slope
  moments agree?
- Does the saturated-internal signed indicator attain a genuine
  uncertainty-principle equality case whose support can be classified?

## 8. Exhaustive resolution and probability portfolio

The follow-up exhaustive audit is
`notes/2026-08-01-c756-masked-rs-collision-audit.md`.  It enumerates every
conic-external arc at a direction-cover-feasible size, every deleted point,
and every spare external line through \(q\le43\): 234,188 instances.  The
only feasible fields are \(q=27,29,31,41,43\), with respective minimum
missing-direction counts

\[
                 \min h=6,2,4,6,8.
\]

Thus the existential falsifier does not fire: no conic-external instance
has \(h\le1\).  Conversely, the threshold-unification hypothesis closes
negative.  Away from the saturated \(q=11\) Clebsch hexagon, extremal
conic-external arcs cover only 64--94% of the off-conic plane, with no trend
toward a global near-cover.  Coincidences between \(m(q)\) and the numerical
covering threshold appear to be rounding, not evidence that every extremal
external clique nearly covers.

The primary nonsaturated target is therefore the clean masked direction
theorem:

> If \(A\) is conic-external and \(\ell\) is a spare external line through
> \(P\in A\), then \(A\setminus\{P\}\) misses at least one direction on
> \(\ell\).

This alone closes the nonsaturated branch, because conic filling forces all
directions on every such line.  The weighted fourth moment \(R\) remains a
fallback carrier if the direct \(h\ge1\) theorem is too strong.  The identity
\(\sum_{\mu_t>0}(\mu_t-1)=\delta+h\) is exact; the residue-dependent incidence
of equality \(R=\delta+h\) is unexplained.

The following probability/information routes were recorded in priority order
with their falsifiers retained:

1. **Global split evaluation code.**  Treat the chord product \(H_A\) as a
   completely split projective Reed--Muller word with nonzero support
   \(C(\mathbb F_q)\sqcup S_A\).  Measure the Hilbert function, minimum
   containing-curve degree, and line/pencil concentration of \(S_A\).  Generic
   missing sets kill the proposed lacunary rigidity; low-complexity support
   promotes a split-codeword classification.
2. **Lloyd/Delsarte multiplicity enumerator.**  For
   \(W_A(z)=\sum_jN_jz^j\), use the exact incidence moments and \(N_0=0\) to
   search for a nonnegative dual polynomial on the allowable integer
   multiplicities.  Repeated feasibility through higher moments demotes the
   analogy; a negative summed value is an exact impossibility certificate.
3. **Saturated-internal uncertainty.**  Measure Fourier entropy, Fourier
   magnitude profile, additive energy, and doubling of the coherent signed
   Paley eigenvector.  Near equality or high energy invites an equality-case
   or inverse theorem; a large irregular uncertainty gap kills this route.
4. **Resultant-sign prefix entropy.**  Record conditional extension counts for
   ordered general-position prefixes and the latent line, pencil, coset, and
   spectral states responsible for plateaux.  A bounded structured catalogue
   supports an entropy-container proof; diffuse plateaux do not.
5. **Local character cumulants.**  Measure \(K_4/K_5\) sign-pattern frequencies
   and cycle cumulants.  A stable forbidden-pattern inequality can feed a
   character-sum or flag-algebra certificate; locally consistent all-negative
   data kills this lowest-priority route.

They were subsequently executed in
`notes/2026-08-01-c756-probability-cheap-tests.md`.  Entropic uncertainty,
degree-two Lloyd moments, and uniform local cumulants close negative; global
split support is mixed-positive; prefix entropy survives with a compressed
but as-yet-unlabelled extension-count catalogue.
