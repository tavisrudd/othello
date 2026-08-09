# C894 — EJ theorem inventory and lean paper architecture

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** theorem architecture
and cheap consequences; no manuscript or Lean edits

## Verdict

The best extra value is subtraction. C894 no longer needs the earlier
partial-results-companion shape. The audited local-Paley theorem and the
complete saturated-exterior classification support a focused two-theorem
paper on their own:

1. local-to-global rigidity for Paley out-neighbourhoods; and
2. classification of extremal exterior arcs of conics, with the Clebsch
   filling theorem as a corollary.

The all-\(k\) LP bound, saturated-internal code equality, Baer exclusion,
local tangent graph, and finite sweeps should not form sections of this paper.
At most, a short final outlook should name the two open branches and point to
their separate evidence. This turns a broad fallback paper into a sharper
graph-theory/finite-geometry paper with one causal bridge: Segre coherence
manufactures the local Paley automorphism that the first theorem classifies.

## 1. Frozen theorem hierarchy

### Lemma A — flat Sidon

Let \(G\) be finite abelian and let
\(\Lambda\subset\widehat G\) have unique nonzero ordered differences. A
constant-modulus function with Fourier support in \(\Lambda\) has at most one
nonzero Fourier coefficient.

**Role:** elementary proof device. Prove inline; make no novelty claim.

### Proposition B — one-block cyclic Cayley rigidity

Let \(X=\operatorname{Cay}(G,D)\) for a cyclic group \(G\). Suppose a
faithful character \(\rho\) has an adjacency-eigenvalue collision class
\(\Lambda\) which is Sidon. Then every automorphism of \(X\), after a
translation, acts on \(\rho\) through one character in \(\Lambda\). If
\(\Lambda\) consists of multiplier translates of \(\rho\), then
\(\operatorname{Aut}(X)\) is contained in the corresponding affine multiplier
group.

**Role:** reusable abstraction that makes clear why one eigenspace, not simple
spectrum, controls the whole graph. Present as a criterion, not a claimed-new
general theorem.

### Theorem C — primitive Paley collision class

For \(q=p^n\equiv3\pmod4\), \(S=(\mathbb F_q^*)^2\), and a faithful
\(\rho\in\widehat S\), the signed local-Paley convolution eigenvalue satisfies
\[
 \beta_\sigma=\beta_\rho
 \quad\Longleftrightarrow\quad
 \sigma=\rho^{p^j}\qquad(0\le j<n).
\]
No imprimitive character collides.

**Role:** exact arithmetic engine. It deserves a named theorem because it is
stronger than the automorphism application and cleanly exposes what the
Stickelberger/half-carry proof establishes. Do not make a separate novelty
claim until the human search also screens exact Jacobi-spectrum collisions.

### Main Theorem D — restriction is an isomorphism

For every vertex \(v\) of the Paley tournament \(P(q)\),
\[
 \operatorname{Aut}(P(q))_v
 \longrightarrow
 \operatorname{Aut}\bigl(P(q)[N^+(v)]\bigr)
\]
is an isomorphism. Equivalently, every out-neighbourhood automorphism extends
uniquely to the full Paley tournament fixing \(v\). In coordinates at
\(v=0\),
\[
 \operatorname{Aut}(P(q)[S])
 =\{s\mapsto cs^{p^j}:c\in S,\ 0\le j<n\}.
\]

**Role:** graph-theoretic headline and qualified candidate novelty. This
single invariant statement owns the exact group formula, normality, order,
prime-field DRR, and unique extension.

### Corollary package from Theorem D

- \(P(q)[S]\) is a normal cyclic Cayley tournament;
- its automorphism group has order \(n(q-1)/2\);
- for prime \(q\), it is a cyclic directed regular representation;
- a faithful primitive eigenblock has, up to scalar, exactly its Frobenius
  character lines as flat vectors, so it reconstructs the cyclic coordinate
  up to translation and Frobenius.

These are one corollary block, not four novelty claims.

### Main Theorem E — extremal exterior arcs

Let \(C\) be a nonsingular conic in \(\mathrm{PG}(2,q)\), \(q\) odd. An
exterior set of \(C\) consisting of \((q+1)/2\) exterior points and forming an
arc exists only for
\[
 q\in\{3,7,11\}.
\]
For \(q>3\), the \(q=7\) and \(q=11\) examples each form one orbit under the
conic stabilizer.

**Role:** finite-geometric headline. Its proof is the bridge from matching
normal form through Segre coherence, Theorem D, the coset Weil bound, and
Hasse.

### Corollary F — saturated-exterior filling

If the joins must cover every point off \(C\), the \(q=3,7\) endpoints fail
and the unique \(q=11\) orbit is the Clebsch hexagon.

**Role:** direct connection to Paper I and the originating all-\(k\) problem.

## 2. Recommended paper architecture

**Working title:** *Automorphisms of Paley out-neighbourhoods and extremal
exterior arcs of conics*.

The older title *Local-to-global rigidity in Paley tournaments and exterior
arcs of conics* remains a strong, slightly less searchable alternative.

1. **Introduction and results.** State Theorems D and E, Corollary F, the
   exact predecessor boundary, and the Segre-to-Paley bridge.
2. **One eigenblock controls a Cayley digraph.** Lemma A and Proposition B.
3. **Primitive local-Paley spectrum.** Jacobi-pair reduction,
   Stickelberger valuations, half-carry multiplier rigidity, and Theorem C.
4. **Paley restriction isomorphism.** Apply Proposition B and Theorem C;
   collect the normality/DRR/coordinate-recovery corollaries.
5. **Exterior arcs and tangent coherence.** Binary-quadratic dictionary,
   perfect matching, complete-mapping parity, and the published scaled Segre
   lemma.
6. **Semilinear exclusion and endpoints.** Coset Weil, scalar Hasse,
   \(q=3,7,11\), inversion orbits, and the explicit \(q=11\) chord union.
7. **Clebsch boundary and outlook.** Corollary F, a brief Paper-I connection,
   and two sentences identifying saturated-internal and nonsaturated filling
   as open.

Expected main-text scale is roughly 16--20 pages before bibliography. No
finite certificate is required for a theorem; a short reproducibility note may
link the independent endpoint and extension-field checks.

## 3. Material cut from the main spine

Exclude:

- the general all-\(k\) LP theorem and even-characteristic nucleus argument;
- the saturated-internal passant-code equality bridge;
- Baer-subline and external-line holonomy partial results;
- the local tangent-graph and SDP evidence;
- every theta, anticommutator, second-operator, simple-spectrum,
  Gaussian/Pfaffian, and negative-compression route;
- tables from bounded field sweeps.

These results remain valid C756 outputs. They simply dilute C894's two complete
theorems and foreground unfinished work. If desired, one paragraph in the
outlook may cite a separate C756 technical report.

## 4. Extra connections now in reach

1. **Spectral coordinate recovery.** The primitive eigenblock is not merely
   a proof aid: its flat projective lines canonically recover the cyclic
   coordinate on the out-neighbourhood up to the exact unavoidable
   translation--Frobenius ambiguity.
2. **Prime-field sharpness.** Javier--Llano--Zuazua identify the prime local
   tournament as a multiplicative circulant; Theorem D upgrades that model to
   a DRR and proves that it has no hidden permutations.
3. **Clebsch symmetry bridge.** At \(q=11\), the normalized local group is
   \(C_5\), the cyclic rigidity left after fixing a matching edge. This is
   compatible with, but does not by itself recover, the full \(A_5\) symmetry
   of the Clebsch hexagon. Use this as explanation, not a theorem claim.
4. **Series discipline.** Cite Paper I for the conic-filling question and
   its \(q=11\) model; mention Paper II's Paley carrier only as a structural
   echo. Do not advertise a transfer to Papers III or IV.
5. **Arithmetic search target.** The human novelty query should include the
   exact primitive Jacobi-eigenvalue collision theorem, not only graph
   automorphisms. A predecessor there would change attribution of the engine
   without pre-empting the geometric application.

## 5. Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| Does C894 need the broad all-\(k\) partial-results package? | settled negative | the two complete theorems give a tighter paper; move open branches to a short outlook |
| Is one faithful eigenblock genuinely enough? | settled positive | Proposition B plus flat Sidon; no simple-spectrum hypothesis |
| Is the primitive collision theorem stronger than the application? | settled positive | it excludes imprimitive competitors and deserves its own theorem label |
| Is that exact Jacobi collision theorem already known? | not audited independently | add exact Jacobi-spectrum terms to the human MathSciNet/Scopus query; make no separate novelty claim yet |
| Does the primitive block canonically reconstruct coordinates? | settled up to the natural ambiguity | flat lines are precisely Frobenius character lines; ambiguity is translation and Frobenius |
| Does the local \(C_5\) recover the Clebsch \(A_5\)? | no | it identifies the normalized cyclic skeleton only; projective geometry supplies the larger symmetry |
| Should internal/passant-code partial results appear in C894? | settled negative for the main text | at most one outlook paragraph and a technical-report pointer |
| Should Peisert or higher cyclotomic analogues be added? | no | successor research after C894, not scope expansion |
| What remains externally blocking? | explicit | human MathSciNet/Scopus coverage and an external specialist read before submission |

## 6. Next action

Turn this hierarchy into the claim--proof--citation matrix used for drafting.
The human-search request should ask about both Theorem D and Theorem C. No
manuscript prose is authorized yet.
