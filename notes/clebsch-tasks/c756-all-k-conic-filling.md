# C756 — all-k conic-filling classification

**Lane**: `clebsch`

## Goal

Remove the \(k \le 8\) boundary from the conic-filling classification and prove, or
decisively fail to prove, the complete statement:

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in \(\mathrm{PG}(2,q)\)
> whose uncovered locus is the full point set of a nonsingular conic are the projective
> four-frame over \(\mathbb{F}_5\) and the Clebsch hexagon over \(\mathbb{F}_{11}\).

Quotable form: *deep-hole loci are conics exactly twice, ever.*

## Why this task exists

It is the only identified route to an A+ paper in the Clebsch/golden group. The
2026-08-01 review (`notes/2026-08-01-clebsch-golden-paper-review.md`, §12.6) found that
no repackaging of existing results clears A−/A: every headline concerns one exceptional
object over one or two small fields, with no infinite family, no asymptotic statement,
and no transferable technique. Exceptional-object papers reach the top tier only when the
exceptional object closes a general question, and the general question is currently open
at \(k = 9\).

If the theorem lands, the packaging is a **new** headline paper (rigidity + all-k
classification + golden operator), not a retrofit into Paper I.

## Current state (2026-08-01)

Eleven research passes complete; the theorem is **not** proved. Reports:
`notes/2026-08-01-c756-all-k-conic-filling.md` and
`notes/2026-08-01-c756-saturated-matching-attack.md`, and
`notes/2026-08-01-c756-segre-tangent-coherence.md`, and
`notes/2026-08-01-c756-paley-windmill-reduction.md`, and
`notes/2026-08-01-c756-paley-bispectral-reduction.md`, and
`notes/2026-08-01-c756-primitive-jacobi-collisions.md`, and
`notes/2026-08-01-c756-nonsaturated-direction-reduction.md`, and
`notes/2026-08-01-c756-segre-discriminant-comparison.md`, and
`notes/2026-08-01-c756-subresultant-moment-obstruction.md`, and
`notes/2026-08-01-c756-saturated-internal-branch.md`, and
`notes/2026-08-01-c756-intercept-subresultant-probe.md`.

Branch ledger:

- **saturated-external — closed:** the Clebsch hexagon over \(\mathbb F_{11}\) is the
  only covering example;
- **saturated-internal — sharply reduced but open:** canonical tangent polynomials and
  Segre's lemma force a coherent Paley double-clique-plus-matching at tight spectral
  interlacing; the four-frame over \(\mathbb F_5\) is the known example, the exact audit
  through \(q\le43\) finds no other coherent candidate, and the remaining uniform gate
  is to prove that no coherent system exists for \(q>5\);
- **nonsaturated — open for \(\delta\ge2\):** \(\delta=0,1\) are closed, while the
  direct Segre, global-moment, raw-subresultant, and dual-pencil low-degree norm repairs
  fail; the all-internal near-transversal classification itself remains open.

What is now proved for all \(k\) and all \(q\):

- \(\mathcal U(A)=C\) splits into (E) every chord is external to \(C\) and (V) the chords
  cover all \(q^2\) points off \(C\); (E) is hereditary and equals
  \(\chi(\operatorname{Res}(f_i,f_j))=-1\) in the binary-quadratic model of the plane.
- Even \(q\) is impossible (the nucleus is never covered).
- A covering LP bound with the correct degree cap \(\lfloor k/2\rfloor\), replacing the
  \(k\le 8\)-only bound \(q\le(k(k-1)+3)/3\).
- A spare-external-line bound: either \(\binom{k-1}{2}\ge q\), or every arc point is
  saturated, which forces \(k=(q+1)/2\) with all arc points external or \(k=(q+3)/2\)
  with all internal. **Both known examples are exactly the two saturated types**, and in
  the saturated-external case the arc is a perfect matching of \(\mathbb P^1(\mathbb F_q)\)
  with all pairwise resultants non-residues.

What the saturated-external attack adds:

- after fixing one matching edge, the arc condition forces a complete mapping of the cyclic
  square group;
- this excludes every \(q\equiv1\pmod4\), hence every odd square field, by a group-sum
  obstruction;
- for \(q\equiv3\pmod4\), the coherent scalar matching branch reduces to a genus-one character
  sum and Hasse's bound forces \(q\in\{3,7,11\}\); only \(q=11\) also covers;
- Segre's lemma of tangents forces **every** saturated-external arc in the odd branch to be
  sign-coherent; conditional on the remaining first-subconstituent automorphism lemma, a coset
  Weil bound eliminates every nontrivial Frobenius form and reduces uniformly to the scalar branch;
- every surviving local automorphism produces a signed perfect-matching matrix \(M\) with
  \(M^2=-I\), two forced vector equations, and the single Paley anticommutator
  \(AM+MA=-2I\); the mixed sign diagonal is forced to be \(-1\);
- the anticommutator produces a second regular tournament matrix \(K\) commuting with the
  first-subconstituent Paley matrix \(B\), with the forced square
  \(K^2=-B^2-(q-1)I+2J\); if \(B\) has simple spectrum, every signed monomial solution is
  scalar and the existing Hasse argument closes it;
- the Gaussian-unit matrix \(W=(B+iK)/(1+i)\) is a regular simplex with
  \(WW^*=((q-1)/2)I-J\); its principal Pfaffian norm excludes every
  \(q\equiv3\pmod8\) for which \((q-1)/2\) is not a sum of two squares;
- Stickelberger's half-carry profile and a base-\(p\) digit-weight lemma prove that one
  faithful Jacobi eigenvalue has exactly its Frobenius collisions, including exclusion
  of collisions with imprimitive characters; the one-block Sidon argument therefore
  makes every matching multiplication--Frobenius, and the prior Weil/Hasse arguments
  close the saturated-external branch completely;
- polarity turns covering into the assertion that the complete node set of \((q+1)/2\) secants,
  consisting entirely of internal points, blocks every non-tangent line.

What the saturated-internal pass adds:

- after fixing one internal point, the other \((q+1)/2\) points map bijectively to the
  odd coset of the norm-one circle via their relative angles; the external branch's
  complete-mapping parity obstruction has no internal analogue;
- the secants of the conic through an internal arc point give a canonical scale-free
  tangent polynomial, so Segre's triangle identity forces unconditional sign coherence;
- coherent representatives form two Paley cliques joined by conjugation matching at
  exactly tight spectral interlacing; the resulting balance theorem and Parseval identity
  characterize the saturated size \(k=(q+3)/2\);
- a master polynomial \(G=\prod_i f_i\) satisfies the necessary Frobenius divisibility
  \(G\mid G'^q-(-1)^{(q+3)/2}G'\), furnishing a concrete lacunary-polynomial gate;
- the exact audit over every odd prime power \(q\le43\), independently replayed on five
  prime fields, finds only the two normalized \(q=5\) four-frames as coherent covering
  arcs; no coherent candidate survives for any audited \(q>5\).

What the first nonsaturated pass adds:

- deleting an arc point on a spare external line produces a \((k-1)\)-arc in the affine
  plane which determines exactly all \(q\) directions other than the deleted point;
- its direction discriminant factors as
  \(D_P(T)=(T^q-T)E_P(T)\), where
  \(\deg E_P=\binom{k-1}{2}-q\) and the root multiplicities of \(E_P\) are exactly
  the excess parallel-chord concurrences;
- equivalently, the complete chord product on the spare line is the binary Moore form,
  the forced \((k-2)\)-fold residual factor at the deleted point, and one canonical
  degree-\(\delta\) concurrence divisor;
- the residual divisor is completely split and supported on at most \(\delta\) exceptional
  directions involving at most \(2\delta\) chords;
- zero slack is impossible over every odd prime-power field except the already excluded
  \(q=3\); defect one factors into exactly \(q=5,9,27\), all removed by the certified
  bounded classification; hence every nonsaturated conic-filling arc satisfies
  \(\binom{k-1}{2}\ge q+2\);
- at defect two the residual divisor is either one double rational point or two distinct
  rational points, so its binary-quadratic discriminant is zero or a square; the first
  boundary not removed by the \(q\le43\) classification is \((q,k)=(53,12)\).

What the defect-two comparison adds:

- the residual quadratic has square-or-zero discriminant while the anisotropic
  \(Q|_\ell\) has nonsquare discriminant, but Segre reciprocity does not identify them;
- every tangent product factors as a conic-meeting factor times a spare-external factor;
  the latter is trivial in the saturated proof but has large positive degree here and
  absorbs the desired square-class comparison;
- after removing the selected spare line, its tangent factor restricts back to that line
  as a pure power at the selected arc point, so it contains no residual concurrence
  divisor;
- the smallest replacement carrier is the first subresultant of
  \(\mathcal H(U,T)=\prod_i(U+x_iT-y_i)\), which retains the repeated chord intercept as
  well as its direction.

What the subresultant and Tao-moment pass adds:

- the first subresultant has Vandermonde-minor coefficients \(A,B\), is nonzero at every
  uniquely represented direction, and therefore cannot inherit the Moore factor;
- the exact uniform forced factor is \(E_P^2\mid A,B\), but after division the coefficient
  degrees remain \(\Theta(q)\), with the predicted maxima attained by exact defect-two
  examples over \(\mathbb F_{13}\);
- all global slope moments satisfy
  \(\sum_{i<j}t_{ij}^m=r^m+s^m\) for \(1\le m\le q-2\), but explicit affine six-arcs
  realize both the one-triple and two-double residual shapes, so those moments do not
  obstruct either shape before conic externality;
- the remaining bounded nonsaturated attack is the dual conic-weighted pencil: internal chord poles
  form a defect-two near-transversal of the pencil through \(\ell^\perp\), retaining both
  direction and intercept.

What the bounded dual-pencil/intercept pass adds:

- the chord pole's coordinate along its line of the pencil through \(\ell^\perp\) is the
  repeated-chord intercept \(U^*=N/G\);
- the exact root formula is
  \(S_1=\pm E_P^2(GU-N)\), with
  \(G=\sum_m\Phi_m^2\), \(N=\sum_m r_m\Phi_m^2\), and
  \(\Phi_m=(T^q-T)/w_m\);
- the Moore mass fragments among the point pencils: after the only uniform forced factor
  \(E_P^2\), the residual degrees are \(2(q-n+1)\) and \(2(q-n+1)+1\), not
  \(O(\delta)\); six exact covering instances attain this scale, including degrees
  \(16\) and \(26\) at fixed \(\delta=2\);
- hence the proposed low-degree conic norm/Weil route fails.  This does not classify the
  all-internal near-transversals themselves; it closes only their last identified
  small-degree algebraic compression.

What is now settled computationally: the complete classification, every \(k\) at once,
for every odd prime power \(q\le 43\) — only the four-frame at \(q=5\) and the Clebsch
hexagon at \(q=11\).

Remaining frontier: counting cannot finish the job (both \(k_{\min}(q)\) and the largest
conic-external arc \(m(q)\) are \(\sqrt{2q}+O(1)\), and which is larger alternates with
\(q\)).  The sixth pass proves the primitive Jacobi collision lemma and closes the entire
saturated-external branch.  The seventh pass gives the strict nonsaturated bound, divides
the direction polynomial by its forced Moore factor, localizes the defect, and closes
\(\delta=0,1\).  The saturated-internal branch is now reduced to proving that no coherent
double-clique system exists for \(q>5\); the exact audit closes it only through \(q=43\).
At nonsaturated defect \(\delta=2\), both the direct Segre discriminant comparison and the
unweighted subresultant/moment repairs are closed negatively: the former loses the spare
factor, the subresultant remains degree \(\Theta(q)\) after its exact \(E_P^2\) division,
and both residual fibre shapes satisfy all global slope moments.  The dual-pencil
intercept calculation now proves that its natural conic-weighted norm also remains at
degree \(\Theta(q)\).  No current small-degree nonsaturated route remains.  The
all-internal defect-two near-transversal classification, genuinely pair-coupled carriers,
and second-order covering counts remain structural possibilities; residual slack
\(\delta\ge3\) stays open behind the defect-two gate.

## Current boundary

- Open problem as stated: `papers/clebsch-rigidity/clebsch_rigidity.tex:1485-1489`.
- The \(k \ge 8\) / \(k \ge 9\) obstruction boundary:
  `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex:1646-1647`.

## What must be proved

Two independent uniform obstructions are still required:

1. classify the saturated-internal family \(k=(q+3)/2\), proving that only the
   \(q=5\) four-frame covers; and
2. exclude every nonsaturated family with \(\delta\ge2\), beginning with the
   defect-two boundary \((q,k)=(53,12)\).

The old secant-pencil and association-scheme candidates are superseded.  The active
saturated-internal gate is the coherent Paley double-clique classification (equivalently,
exploit balance, simultaneous angle bijections, or the master-polynomial divisibility).
The nonsaturated branch has no bounded algebraic-compression gate left; only a structural
classification of the dual internal-node near-transversal, a pair-coupled carrier, or a
uniform second-order covering count remains identified.

## Prior estimate

The review prior was ~30% provable with current tools (§12.6).  The saturated-internal
audit produced a strong normal form but not its final classification, while the bounded
dual conic-weighted-pencil norm fails at degree \(\Theta(q)\).  The working estimate stays
~5--10%, read at its low end for the current toolkit.  The two remaining gates require
new structural input and no present route joins them.

## Scope

Research task, not a manuscript task. No edits to `papers/` under this ID; a positive
result triggers a separate paper task, and a negative result is written up as a dated
note plus, if warranted, an amended open-problem statement.

## Runner-up (not this task)

An all-good-reduction version of Paper II's classification. The missing ingredients are
named in `papers/clebsch-factorization/clebsch_factorization.tex:1390-1396` (integral
models, degeneration analysis). Bigger than a bounded push; do not fold it in here.
