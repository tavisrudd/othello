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

Nine research passes complete; the theorem is **not** proved. Reports:
`notes/2026-08-01-c756-all-k-conic-filling.md` and
`notes/2026-08-01-c756-saturated-matching-attack.md`, and
`notes/2026-08-01-c756-segre-tangent-coherence.md`, and
`notes/2026-08-01-c756-paley-windmill-reduction.md`, and
`notes/2026-08-01-c756-paley-bispectral-reduction.md`, and
`notes/2026-08-01-c756-primitive-jacobi-collisions.md`, and
`notes/2026-08-01-c756-nonsaturated-direction-reduction.md`, and
`notes/2026-08-01-c756-segre-discriminant-comparison.md`, and
`notes/2026-08-01-c756-subresultant-moment-obstruction.md`.

Branch ledger:

- **saturated-external — closed:** the Clebsch hexagon over \(\mathbb F_{11}\) is the
  only covering example;
- **saturated-internal — open:** the four-frame over \(\mathbb F_5\) is the known
  example, but no uniform obstruction beyond the certified \(q\le43\) range is on
  record; the saturated-external mod-4 and matching arguments do not transfer;
- **nonsaturated — open for \(\delta\ge2\):** \(\delta=0,1\) are closed, while the
  direct Segre, raw-subresultant, and global-moment defect-two repairs fail.

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

What is now settled computationally: the complete classification, every \(k\) at once,
for every odd prime power \(q\le 43\) — only the four-frame at \(q=5\) and the Clebsch
hexagon at \(q=11\).

Remaining frontier: counting cannot finish the job (both \(k_{\min}(q)\) and the largest
conic-external arc \(m(q)\) are \(\sqrt{2q}+O(1)\), and which is larger alternates with
\(q\)).  The sixth pass proves the primitive Jacobi collision lemma and closes the entire
saturated-external branch.  The seventh pass gives the strict nonsaturated bound, divides
the direction polynomial by its forced Moore factor, localizes the defect, and closes
\(\delta=0,1\).  The saturated-internal branch remains independently open beyond the
known \(q=5\) four-frame; none of the saturated-external closure proves its uniqueness.
At nonsaturated defect \(\delta=2\), both the direct Segre discriminant comparison and the
unweighted subresultant/moment repairs are closed negatively: the former loses the spare
factor, the subresultant remains degree \(\Theta(q)\) after its exact \(E_P^2\) division,
and both residual fibre shapes satisfy all global slope moments.  The next and last
identified bounded nonsaturated gate is the dual conic-weighted pencil through \(\ell^\perp\): derive
a degree-\(O(\delta)\) norm or classify its all-internal defect-two near-transversals.
If that fails, no current small-degree nonsaturated route remains.  Residual slack
\(\delta\ge3\) stays open behind the defect-two gate, while saturated-internal needs a
separate torus/Segre or literature classification.

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
nonsaturated gate is the dual internal-node near-transversal through \(\ell^\perp\); the
saturated-internal branch requires a separate torus/Segre normal form or a literature
classification.

## Prior estimate

The review prior was ~30% provable with current tools (§12.6).  After the direct Segre,
subresultant, and global-moment repairs failed and the saturated-internal omission was
identified, the working estimate is ~5--10%.  A bounded dual conic-weighted-pencil route
and a separate saturated-internal audit remain.  Record the actual obstruction if either
fails — a sharp statement of *why* the chord-moment system cannot close is itself
publishable material for the existing papers.

## Scope

Research task, not a manuscript task. No edits to `papers/` under this ID; a positive
result triggers a separate paper task, and a negative result is written up as a dated
note plus, if warranted, an amended open-problem statement.

## Runner-up (not this task)

An all-good-reduction version of Paper II's classification. The missing ingredients are
named in `papers/clebsch-factorization/clebsch_factorization.tex:1390-1396` (integral
models, degeneration analysis). Bigger than a bounded push; do not fold it in here.
