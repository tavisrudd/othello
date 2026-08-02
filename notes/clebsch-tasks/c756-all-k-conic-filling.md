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

Seven research passes complete; the theorem is **not** proved. Reports:
`notes/2026-08-01-c756-all-k-conic-filling.md` and
`notes/2026-08-01-c756-saturated-matching-attack.md`, and
`notes/2026-08-01-c756-segre-tangent-coherence.md`, and
`notes/2026-08-01-c756-paley-windmill-reduction.md`, and
`notes/2026-08-01-c756-paley-bispectral-reduction.md`, and
`notes/2026-08-01-c756-primitive-jacobi-collisions.md`, and
`notes/2026-08-01-c756-nonsaturated-direction-reduction.md`.

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
- zero slack is impossible over every odd prime-power field except the already excluded
  \(q=3\), so every nonsaturated conic-filling arc satisfies the strict uniform bound
  \(\binom{k-1}{2}\ge q+1\).

What is now settled computationally: the complete classification, every \(k\) at once,
for every odd prime power \(q\le 43\) — only the four-frame at \(q=5\) and the Clebsch
hexagon at \(q=11\).

Remaining frontier: counting cannot finish the job (both \(k_{\min}(q)\) and the largest
conic-external arc \(m(q)\) are \(\sqrt{2q}+O(1)\), and which is larger alternates with
\(q\)).  The sixth pass proves the primitive Jacobi collision lemma and closes the entire
saturated-external branch.  The seventh pass gives the strict nonsaturated bound and divides
the direction polynomial by its forced Moore factor.  Positive residual slack remains open;
the next gate is to combine Segre's tangent-product relation with the degree-\(\delta\)
residual concurrence divisor, so that a character sum sees \(\delta\) rather than the
original degree about \(q\).  The dual internal-node blocking formulation is retained as
structural input rather than as a substitute for the closed spectral step.

## Current boundary

- Open problem as stated: `papers/clebsch-rigidity/clebsch_rigidity.tex:1485-1489`.
- The \(k \ge 8\) / \(k \ge 9\) obstruction boundary:
  `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex:1646-1647`.

## What must be proved

A uniform obstruction for \(k \ge 9\) across the window's \(\sim k^2/3\)-sized \(q\)-range.
The chord-moment system leaves free concurrence parameters for \(r \ge 4\)
(`clebsch_hexagon_code.tex:1646-1647`), so this needs a new idea rather than more search:
the \(k = 7\) case already required brute force, and that does not scale.

Two candidate routes, both about making a second-order count uniform in \(k\):

1. Secant-pencil saturation, generalizing the \(q = 13\) weight-eight argument in the
   computational companion.
2. An association-scheme or clique bound generalizing the Sylvester trick.

## Prior estimate

~30% provable with current tools (review §12.6). The estimate is driven entirely by
whether either route above admits a \(k\)-uniform form. Record the actual obstruction
if it fails — a sharp statement of *why* the chord-moment system cannot close is itself
publishable material for the existing papers.

## Scope

Research task, not a manuscript task. No edits to `papers/` under this ID; a positive
result triggers a separate paper task, and a negative result is written up as a dated
note plus, if warranted, an amended open-problem statement.

## Runner-up (not this task)

An all-good-reduction version of Paper II's classification. The missing ingredients are
named in `papers/clebsch-factorization/clebsch_factorization.tex:1390-1396` (integral
models, degeneration analysis). Bigger than a bounded push; do not fold it in here.
